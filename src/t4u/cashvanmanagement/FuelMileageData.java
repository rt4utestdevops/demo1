package t4u.cashvanmanagement;

import java.util.Comparator;

public class FuelMileageData implements Comparator<FuelMileageData>, Comparable<FuelMileageData> {
	
	public String vehicle;	
	public String date;
	public int odometer;
	public double fuel;
	public double amount;
	public String slipNo;
	public String fuelStationName;
	public String petroCardNumber;
	
	public FuelMileageData(String vehicle, String date,  int odometer, double fuel, double amount, String slipNo, String fuelStationName, String petroCardNumber) {
		this.vehicle = vehicle;		
		this.date = date;
		this.odometer = odometer;
		this.fuel = fuel;
		this.amount = amount;
		this.slipNo = slipNo;
		this.fuelStationName = fuelStationName;		
		this.petroCardNumber = petroCardNumber;
	}

	public FuelMileageData() {
		// TODO Auto-generated constructor stub
	}

	
	public int compareTo(FuelMileageData arg0) {
		return this.vehicle.compareTo(arg0.vehicle);
	}

	
	public int compare(FuelMileageData arg0, FuelMileageData arg1) {

		return (arg0.vehicle.compareTo(arg1.vehicle) == 0) ? (arg0.odometer - arg1.odometer) : arg0.vehicle.compareTo(arg1.vehicle);
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return this.vehicle + " " + this.odometer + " " + this.date;
	}
}
