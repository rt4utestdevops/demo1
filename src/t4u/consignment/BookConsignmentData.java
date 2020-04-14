package t4u.consignment;

import java.util.Comparator;



public class BookConsignmentData implements Comparator<BookConsignmentData>, Comparable<BookConsignmentData>{
	public String bookingDate;	
	public String vehicleNumber;
	public String bookingCustomerName;
	public String dealers;
	public String consignmentNumber;
	public String scheduledShippingDate;
	public String scheduledDelivery;
	public String email;
	public String sms;
	public String totalDistance;
	public float distancePerDay;
	public String fromLocation;
	public String toLocation;
	public String status;
	public int fromId;
	public int toId;
	
	public BookConsignmentData(String bookingDate, String vehicleNumber,String bookingCustomerName,  String dealers, String consignmentNumber, String scheduledShippingDate, String scheduledDelivery, String email, String sms,String totalDistance,float distancePerDay,String fromLocation,String toLocation,String status,int fromId,int toId) {
		
		this.bookingDate = bookingDate;		
		this.vehicleNumber = vehicleNumber;
		this.bookingCustomerName=bookingCustomerName;
		this.dealers = dealers;
		this.consignmentNumber = consignmentNumber;
		this.scheduledShippingDate = scheduledShippingDate;
		this.scheduledDelivery = scheduledDelivery;
		this.email = email;		
		this.sms = sms;
		this.totalDistance=totalDistance;
		this.distancePerDay=distancePerDay;
		this.fromLocation=fromLocation;
		this.toLocation=toLocation;
		this.status=status;
		this.fromId=fromId;
		this.toId=toId;
		
	}
	
	public BookConsignmentData() {
		// TODO Auto-generated constructor stub
	}

	public int compare(BookConsignmentData o1, BookConsignmentData o2) {
		// TODO Auto-generated method stub
		return 0;
	}

	public int compareTo(BookConsignmentData o) {
		// TODO Auto-generated method stub
		return 0;
	}


	
}
