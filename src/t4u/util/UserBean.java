package t4u.util;

public class UserBean {

	String userName;
	
	public UserBean(String userName, String password) {
		super();
		this.userName = userName;
		this.password = password;
	}

	String password;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	
}
