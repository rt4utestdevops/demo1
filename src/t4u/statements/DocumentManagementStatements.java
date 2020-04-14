package t4u.statements;

public class DocumentManagementStatements {
	public static final String INSERT_FILE_UPLOAD_DETAILS = "insert into dbo.DOCUMENT_STORAGE_DETAILS ( FILE_NAME, CATEGORY, VALUE, CUSTOMER_ID, " +
			"SYSTEM_ID, UPLOADED_BY, INSERTED_TIME, FILE_EXTENTION) values (?, ?, ?, ?, ?, ?, ?, ?)";
	
	public static final String GET_UPLOADED_FILE = "select ID, FILE_NAME,INSERTED_TIME,FILE_EXTENTION from  dbo.DOCUMENT_STORAGE_DETAILS where VALUE=? and SYSTEM_ID=? and " +
			"CUSTOMER_ID=?";
	
	public static final String GET_CLIENT_ID = "select CLIENT_ID from dbo.VEHICLE_CLIENT where REGISTRATION_NUMBER=? and SYSTEM_ID=?";
}
