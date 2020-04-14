package t4u.passengerbustransportation;

public class ProftAndLossBean {
	public String serviceName;
	public String registrationNo;
	public String journeyDate;
	public String routeName;
	public int totalSeats;
	public float totalAmount;
	public float tripExpense;
	public float maintanenceExpense;
	public float netProfit;
	public String terminalName;
	public float getNetProfit() {
		return netProfit;
	}
	public void setNetProfit(float netProfit) {
		this.netProfit = netProfit;
	}
	public String getServiceName() {
		return serviceName;
	}
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	public String getRegistrationNo() {
		return registrationNo;
	}
	public void setRegistrationNo(String registrationNo) {
		this.registrationNo = registrationNo;
	}
	public String getJourneyDate() {
		return journeyDate;
	}
	public void setJourneyDate(String journeyDate) {
		this.journeyDate = journeyDate;
	}
	public String getRouteName() {
		return routeName;
	}
	public void setRouteName(String routeName) {
		this.routeName = routeName;
	}
	public int getTotalSeats() {
		return totalSeats;
	}
	public void setTotalSeats(int totalSeats) {
		this.totalSeats = totalSeats;
	}
	public float getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(float totalAmount) {
		this.totalAmount = totalAmount;
	}
	public float getTripExpense() {
		return tripExpense;
	}
	public void setTripExpense(float tripExpense) {
		this.tripExpense = tripExpense;
	}
	public float getMaintanenceExpense() {
		return maintanenceExpense;
	}
	public void setMaintanenceExpense(float maintanenceExpense) {
		this.maintanenceExpense = maintanenceExpense;
	}
	
	public String getTerminalName() {
		return terminalName;
	}
	public void setTerminalName(String terminalName) {
		this.terminalName = terminalName;
	}
	
	
}
