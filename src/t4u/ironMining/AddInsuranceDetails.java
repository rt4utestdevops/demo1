package t4u.ironMining;

public class AddInsuranceDetails {
	
	
	public String AssetNumber;
	public String RegistrationDate;
	public String CarriageCapacity;
	public String OperatingOnMine;
	public String Location;
	public String MiningLeaseNo ;	
	public String ChassisNo; 	
	public String InsurancePolicyNo ;	
	public String InsuranceExpiryDate; 
	public String PucNumber ;	
	public String PucExpiryDate ;
	public String roadTaxValidityDate ;
	public String permitValidityDate ;
	public String OwnerName ;
	public String AssemblyConstituency;
	public String HouseNo ;
	public String Locality ;
	public String CityVillage ;	
	public String Taluka ;	
	public String State ;
	public String District ;	
	public String EPICNo; 
	public String PANNo; 	
	public String MobileNo;	
	public String PhoneNo	;
	public String AadharNo; 
	public String EnrollmentDate;	
	public String Bank ;	
	public String Branch;
	public String PrincipalBalance ;
	public String PrincipalOverDues; 	
	public String InterestBalance ;	
	public String AccountNo ;
	public String engineNo ;
	public String validstatus;
	public String remarks;
	public int stateid;
	public int districtId;
   
	
	
	public AddInsuranceDetails(String validstatus,String remarks,String AssetNumber,String RegistrationDate,String CarriageCapacity,String OperatingOnMine,String Location,String MiningLeaseNo,String ChassisNo,String InsurancePolicyNo,String InsuranceExpiryDate,String PucNumber,String PucExpiryDate,String roadTaxValidityDate,String permitValidityDate,String OwnerName,String AssemblyConstituency,String HouseNo,String Locality,String CityVillage,String Taluka ,String State ,String District ,String EPICNo,String PANNo,String MobileNo,String PhoneNo,String AadharNo,String EnrollmentDate,String Bank,String Branch,String PrincipalBalance ,String PrincipalOverDues, String InterestBalance ,String AccountNo,String engineNo,int stateid,int districtId ){
			this.validstatus = validstatus;
			this.remarks = remarks;
		    this. AssetNumber=AssetNumber;
		    this. RegistrationDate = RegistrationDate;
			this. CarriageCapacity = CarriageCapacity;
			this. OperatingOnMine=OperatingOnMine;
			this. Location=Location;
			this. MiningLeaseNo=MiningLeaseNo;
			this. ChassisNo= ChassisNo;	
			this. InsurancePolicyNo =InsurancePolicyNo;
			this. InsuranceExpiryDate=InsuranceExpiryDate ;
			this. PucNumber =PucNumber;
			this. PucExpiryDate =PucExpiryDate;
			this. roadTaxValidityDate =roadTaxValidityDate;
			this. permitValidityDate =permitValidityDate;
			this. OwnerName =OwnerName;
			this. AssemblyConstituency=AssemblyConstituency;
			this. HouseNo =HouseNo;
			this. Locality =Locality;
			this. CityVillage =	CityVillage;
			this. Taluka =	Taluka;
			this. State =State;
			this. District =District;
			this. EPICNo= EPICNo;
			this. PANNo= PANNo;
			this. MobileNo=	MobileNo;
			this. PhoneNo=PhoneNo;
			this. AadharNo= AadharNo;
			this. EnrollmentDate=EnrollmentDate;
			this. Bank =Bank;	
			this. Branch=Branch;
			this. PrincipalBalance =PrincipalBalance;
			this. PrincipalOverDues= PrincipalOverDues;
			this. InterestBalance =	InterestBalance;
			this. AccountNo =AccountNo;
			this.engineNo =engineNo;
			this. stateid =stateid;
			this.districtId =districtId;
			
	}

	public AddInsuranceDetails(){
		
	}
	
//	@Override
//	public String toString() {
//		// TODO Auto-generated method stub
//		return this. mobileNumber+ " " + this.serviceProvider;
//	}

}
