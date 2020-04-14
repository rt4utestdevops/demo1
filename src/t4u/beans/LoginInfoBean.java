package t4u.beans;

import java.io.Serializable;

/**
 * 
 * This bean is used to store the logged in users details
 *
 */
@SuppressWarnings("serial")
public class LoginInfoBean implements Serializable{

	  private int systemId =0;
	  private String systemName = null;
	  private int userId = 0;
	  private String userName = null;
	  private String userFirstName=null;
	  private String userMiddleName = null;
	  private String userLastName = null;
	  private int groupId = 0;	
	  private int customerId = 0;
	  private String customerName = null;
	  private int offsetMinutes;
	  private String offset;
	  private String zone;
	  private String language;
	  private String category;
	  private String categoryType;
	  private String styleSheetOverride;
	  private String LTSPName;
	  private int isLtsp;
	  private int CountryCode;
	  private int mapType;
	  private int nonCommHrs = 6;
		private String  newMenuStyle = ""; //added by mallikarjuna to get new Menu Style
	  private MapAPIConfigBean mapAPIConfig;
	  
	  private int clientId = 0;
//		private Boolean isCustomerBasedData;
	
//	public Boolean getIsCustomerBasedData() {
//			return isCustomerBasedData;
//		}
//		public void setIsCustomerBasedData(Boolean isCustomerBasedData) {
//			this.isCustomerBasedData = isCustomerBasedData;
//		}
	public int getMapType() {
		return mapType;
	}
	public void setMapType(int mapType) {
		this.mapType = mapType;
	}
	public String getLTSPName() {
		return LTSPName;
	}
	public void setLTSPName(String lTSPName) {
		LTSPName = lTSPName;
	}
	
	public int getIsLtsp() {
		return isLtsp;
	}
	public void setIsLtsp(int isLtsp) {
		this.isLtsp = isLtsp;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getCategoryType() {
		return categoryType;
	}
	public void setCategoryType(String categoryType) {
		this.categoryType = categoryType;
	}
	public int getSystemId(){		
		  return systemId;
	  }
	  public void setSystemId(int systemId){
		  this.systemId=systemId;
	  }
	  
	  public String getSystemName(){
		  return systemName;
	  }
	  public void setSystemName(String systemName){
		  this.systemName=systemName;
	  }
	  
	  public int getUserId(){
		  return userId;
	  }
	  public void setUserId(int userId){
		  this.userId=userId;
	  }
	  
	  public String getUserName(){
		  return userName;
	  }
	  public void setUserName(String userName){
		  this.userName=userName;
	  }
	  
	  public String getUserFirstName(){
		  return userFirstName;
	  }
	  public void setUserFirstName(String userFirstName){
		  this.userFirstName=userFirstName;
	  }
	  
	  public String getUserMiddleName(){
		  return userMiddleName;
	  }
	  public void setUserMiddleName(String userMiddleName){
		  this.userMiddleName=userMiddleName;
	  }
	  
	  public String getUserLastName(){
		  return userLastName;
	  }
	  public void setUserLastName(String userLastName){
		  this.userLastName=userLastName;
	  }
	  
	  public int getGroupId(){
		  return groupId;
	  }
	  public void setGroupId(int groupId){
		  this.groupId=groupId;
	  }
	  
	  public int getCustomerId(){
		  return customerId;
	  }
	  public void setCustomerId(int customerId){
		  this.customerId=customerId;
	  }
	  
	  public String getCustomerName(){
		  return customerName;
	  }
	  public void setCustomerName(String customerName){
		  this.customerName=customerName;
	  }
	  
	  public int getOffsetMinutes(){
		  return offsetMinutes;
	  }
	  public void setOffsetMinutes(int offsetMinutes){
		  this.offsetMinutes=offsetMinutes;
	  }
	  
	  public String getOffset(){
		  return offset;
	  }
	  public void setOffset(String offset){
		  this.offset=offset;
	  }
	  public String getZone(){
		  return zone;
	  }
	  public void setZone(String zone){
		  this.zone=zone;
	  }
	  public String getLanguage(){
		  return language;
	  }
	  public void setLanguage(String language){
		  this.language=language;
	  }
	public void setStyleSheetOverride(String styleSheetOverride) {
		this.styleSheetOverride = styleSheetOverride;
	}
	public String getStyleSheetOverride() {
		return styleSheetOverride;
	}
	/**
	 * @return the countryCode
	 */
	public int getCountryCode() {
		return CountryCode;
	}
	/**
	 * @param countryCode the countryCode to set
	 */
	public void setCountryCode(int countryCode) {
		CountryCode = countryCode;
	}
		public int getNonCommHrs() {
		return nonCommHrs;
	}
	public void setNonCommHrs(int nonCommHrs) {
		this.nonCommHrs = nonCommHrs;
	}
	
	public String getNewMenuStyle() {
		return newMenuStyle;
	}

	public void setNewMenuStyle(String newMenuStyle) {
		this.newMenuStyle = newMenuStyle;
	}
	public MapAPIConfigBean getMapAPIConfig() {
		return mapAPIConfig;
	}
	public void setMapAPIConfig(MapAPIConfigBean mapAPIConfig) {
		this.mapAPIConfig = mapAPIConfig;
	}
	public int getClientId() {
		return clientId;
	}
	public void setClientId(int clientId) {
		this.clientId = clientId;
	}

	
	
}

