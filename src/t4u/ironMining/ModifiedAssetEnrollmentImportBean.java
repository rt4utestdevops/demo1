package t4u.ironMining;

import java.util.Date;

public class ModifiedAssetEnrollmentImportBean {
	
	public String assetNo;
	public String engineNo;
	public String insuranseNo;
	public Date insuranseExpDate;
	public String pucNo;
	public Date pucExpDate;
	public Date roadTaxValididtyDate;
	public Date permitValididtyDate;
	public String challanNo;
	public Date challanDate;
	public String bankTransactionNo;
	public Double amountPaid;
	public Date validityDate;
	public String assetStatus;
	public String remarks;
	public Integer UID;
	
	public String operatingOnMine;
	public String location;
	public String miningLeaseNo;
	public String chassisNo;
	public String constituency;
	public String houseNo;
	public String locality;
	public String city;
	public String taluka;
	
	public String epicNo;
	public String panNo;
	public String mobileNo;
	public String phoneNo;
	public String aadharNo;
	public String bank;
	public String branch;
	public Double principalBalance;
	public Double principalOverDue;
	public Double interestBalance;
	public String accountNo;
	
	public ModifiedAssetEnrollmentImportBean() { super(); }



	public ModifiedAssetEnrollmentImportBean(String assetNo, String engineNo,
			String insuranseNo, Date insuranseExpDate, String pucNo,
			Date pucExpDate, Date roadTaxValididtyDate,Date permitValididtyDate,String challanNo, Date challanDate,
			String bankTransactionNo, Double amountPaid, Date validityDate,
			String operatingOnMine, String location, String miningLeaseNo,
			String chassisNo, String constituency, String houseNo,
			String locality, String city, String taluka, String epicNo,
			String panNo, String mobileNo, String phoneNo, String aadharNo,
			String bank, String branch, Double principalBalance,
			Double principalOverDue, Double interestBalance,
			String accountNo) {
		super();
		this.assetNo = assetNo;
		this.engineNo = engineNo;
		this.insuranseNo = insuranseNo;
		this.insuranseExpDate = insuranseExpDate;
		this.pucNo = pucNo;
		this.pucExpDate = pucExpDate;
		this.roadTaxValididtyDate = roadTaxValididtyDate;
		this.permitValididtyDate = permitValididtyDate;
		this.challanNo = challanNo;
		this.challanDate = challanDate;
		this.bankTransactionNo = bankTransactionNo;
		this.amountPaid = amountPaid;
		this.validityDate = validityDate;
		this.operatingOnMine = operatingOnMine;
		this.location = location;
		this.miningLeaseNo = miningLeaseNo;
		this.chassisNo = chassisNo;
		this.constituency = constituency;
		this.houseNo = houseNo;
		this.locality = locality;
		this.city = city;
		this.taluka = taluka;
		this.epicNo = epicNo;
		this.panNo = panNo;
		this.mobileNo = mobileNo;
		this.phoneNo = phoneNo;
		this.aadharNo = aadharNo;
		this.bank = bank;
		this.branch = branch;
		this.principalBalance = principalBalance;
		this.principalOverDue = principalOverDue;
		this.interestBalance = interestBalance;
		this.accountNo = accountNo;
	}

	public Date getRoadTaxValididtyDate() {
		return roadTaxValididtyDate;
	}

	public void setRoadTaxValididtyDate(Date roadTaxValididtyDate) {
		this.roadTaxValididtyDate = roadTaxValididtyDate;
	}

	public Date getPermitValididtyDate() {
		return permitValididtyDate;
	}

	public void setPermitValididtyDate(Date permitValididtyDate) {
		this.permitValididtyDate = permitValididtyDate;
	}

	public String getAssetNo() {
		return assetNo;
	}

	public void setAssetNo(String assetNo) {
		this.assetNo = assetNo;
	}

	public String getInsuranseNo() {
		return insuranseNo;
	}

	public void setInsuranseNo(String insuranseNo) {
		this.insuranseNo = insuranseNo;
	}

	public Date getInsuranseExpDate() {
		return insuranseExpDate;
	}

	public void setInsuranseExpDate(Date insuranseExpDate) {
		this.insuranseExpDate = insuranseExpDate;
	}

	public String getPucNo() {
		return pucNo;
	}

	public void setPucNo(String pucNo) {
		this.pucNo = pucNo;
	}

	public Date getPucExpDate() {
		return pucExpDate;
	}

	public void setPucExpDate(Date pucExpDate) {
		this.pucExpDate = pucExpDate;
	}

	public String getChallanNo() {
		return challanNo;
	}

	public void setChallanNo(String challanNo) {
		this.challanNo = challanNo;
	}

	public Date getChallanDate() {
		return challanDate;
	}

	public void setChallanDate(Date challanDate) {
		this.challanDate = challanDate;
	}

	public String getBankTransactionNo() {
		return bankTransactionNo;
	}

	public void setBankTransactionNo(String bankTransactionNo) {
		this.bankTransactionNo = bankTransactionNo;
	}

	public Double getAmountPaid() {
		return amountPaid;
	}

	public void setAmountPaid(Double amountPaid) {
		this.amountPaid = amountPaid;
	}

	public Date getValidityDate() {
		return validityDate;
	}

	public void setValidityDate(Date validityDate) {
		this.validityDate = validityDate;
	}

	public String getAssetStatus() {
		return assetStatus;
	}

	public void setAssetStatus(String assetStatus) {
		this.assetStatus = assetStatus;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getUID() {
		return UID;
	}

	public void setUID(Integer uID) {
		UID = uID;
	}

	public String getEngineNo() {
		return engineNo;
	}

	public void setEngineNo(String engineNo) {
		this.engineNo = engineNo;
	}

	public String getOperatingOnMine() {
		return operatingOnMine;
	}

	public void setOperatingOnMine(String operatingOnMine) {
		this.operatingOnMine = operatingOnMine;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getMiningLeaseNo() {
		return miningLeaseNo;
	}

	public void setMiningLeaseNo(String miningLeaseNo) {
		this.miningLeaseNo = miningLeaseNo;
	}

	public String getChassisNo() {
		return chassisNo;
	}

	public void setChassisNo(String chassisNo) {
		this.chassisNo = chassisNo;
	}

	public String getConstituency() {
		return constituency;
	}

	public void setConstituency(String constituency) {
		this.constituency = constituency;
	}

	public String getHouseNo() {
		return houseNo;
	}

	public void setHouseNo(String houseNo) {
		this.houseNo = houseNo;
	}

	public String getLocality() {
		return locality;
	}

	public void setLocality(String locality) {
		this.locality = locality;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getTaluka() {
		return taluka;
	}

	public void setTaluka(String taluka) {
		this.taluka = taluka;
	}

	public String getEpicNo() {
		return epicNo;
	}

	public void setEpicNo(String epicNo) {
		this.epicNo = epicNo;
	}

	public String getPanNo() {
		return panNo;
	}

	public void setPanNo(String panNo) {
		this.panNo = panNo;
	}

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public String getAadharNo() {
		return aadharNo;
	}

	public void setAadharNo(String aadharNo) {
		this.aadharNo = aadharNo;
	}

	public String getBank() {
		return bank;
	}

	public void setBank(String bank) {
		this.bank = bank;
	}

	public String getBranch() {
		return branch;
	}

	public void setBranch(String branch) {
		this.branch = branch;
	}

	public Double getPrincipalBalance() {
		return principalBalance;
	}

	public void setPrincipalBalance(Double principalBalance) {
		this.principalBalance = principalBalance;
	}

	public Double getPrincipalOverDue() {
		return principalOverDue;
	}

	public void setPrincipalOverDue(Double principalOverDue) {
		this.principalOverDue = principalOverDue;
	}

	public Double getInterestBalance() {
		return interestBalance;
	}

	public void setInterestBalance(Double interestBalance) {
		this.interestBalance = interestBalance;
	}

	public String getaccountNo() {
		return accountNo;
	}

	public void setaccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	
}
