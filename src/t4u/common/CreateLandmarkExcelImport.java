package t4u.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.admin.UnitDetailsData;
import t4u.statements.AdminStatements;
import t4u.statements.CreateLandmarkStatements;

public class CreateLandmarkExcelImport {
	static JSONArray globalJsonArray = new JSONArray();
	static Map<String, List<CreateLandmarkLocationData>> dataMap = new HashMap<String, List<CreateLandmarkLocationData>>();
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private String offset;
	private String hubname;
	private String radius;
	private String latitude;
	private String longitude;
	private String city;
	private String state;
	private String country;
	private String geoFence;
	private String stdDuration;
	private String Remarks = "";
	private int rowNo;
	String message = "";
	String format = "";
	CreateLandmarkStatements createLandmark = new CreateLandmarkStatements();

	public CreateLandmarkExcelImport(File inFile, int userId, int systemId,int clientId, String fileExtension) {
		this.inFile = inFile;
		this.userId = userId;
		this.systemId = systemId;
		this.clientId = clientId;
		this.fileExtension = fileExtension;
	}

	/** return message */
	public String getMessage() {
		return message;
	}

	public String importExcelData() {
		String importMessage = "";
		List<CreateLandmarkLocationData> list = new ArrayList();
		try {
			if (fileExtension.equals(".xls")) {
				try {
					InputStream excelFileToRead = new FileInputStream(inFile);
					HSSFWorkbook wb = new HSSFWorkbook(excelFileToRead);
					HSSFSheet sheet = wb.getSheetAt(0);
					HSSFRow row;
					HSSFCell cell;
					int cols = 0;
					int nRows = sheet.getPhysicalNumberOfRows() - 1;
					System.out.println("Number of rows in XL" + nRows);
					// Loop for traversing each row in the spreadsheet
					for (int r = 0; r < nRows; r++) {
						rowNo = r;
						rowNo++;
						row = sheet.getRow(rowNo);
						if (row != null) {
							// Column count in the current row
							cols = sheet.getRow(r).getLastCellNum();
							// Loop for traversing each column in each row in
							// the spreadsheet
							for (int c = 0; c < cols; c++) {
								cell = row.getCell((short) c);
								// If cell contains String value
								switch (c) {
								case 0:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
											hubname = cell.getStringCellValue();
										} else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											hubname = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										hubname = "";
									}
									break;
								case 1:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											radius = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											radius = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										radius = "";
									}
									break;
								case 2:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											latitude = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											latitude = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										latitude = "";
									}
									break;
								case 3:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											longitude = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											longitude = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										longitude = "";
									}
									break;
								case 4:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											offset = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											offset = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										offset = "";
									}
									break;
								case 5:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											city = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											city = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										city = "";
									}
									break;
								case 6:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											state = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											state = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										state = "";
									}
									break;
								case 7:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											country = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											country = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										country = "";
									}
									break;
								case 8:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											geoFence = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											geoFence = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										geoFence = "";
									}
									break;
								case 9:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											stdDuration = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											stdDuration = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										stdDuration = "";
									}
									String empty="";
									if(radius.equals("0") || radius.equals("0.0")){
										list.add(new CreateLandmarkLocationData(hubname, radius, latitude,
												longitude, offset, city, state,country, empty, empty,Remarks));
									}
									else {
										if(hubname != "" || radius != "" || latitude != ""
											|| longitude != "" || offset != ""
											|| city != "" || state != ""
											|| country != "" || geoFence != ""
											|| stdDuration != ""){
//										System.out.println("CHECK>>" + slno
//												+ "," + hubname + "," + radius
//												+ "," + latitude + ","
//												+ longitude + "," + offset
//												+ "," + city + "," + state
//												+ "," + country + ","
//												+ stdDuration + "," + Remarks);
									list.add(new CreateLandmarkLocationData(
											hubname, radius, latitude,
											longitude, offset, city, state,
											country, geoFence, stdDuration,
											Remarks));
										}
									}
									break;
								}
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (fileExtension.equals(".xlsx")) {
				try {
					System.out.println("CL XL IMPORT importExcelDATA() inside xlsx check!!!!!!!!!!!");
					InputStream excelFileToRead = new FileInputStream(inFile);
					XSSFWorkbook wb = new XSSFWorkbook(excelFileToRead);
					XSSFSheet sheet = wb.getSheetAt(0);
					XSSFRow row;
					XSSFCell cell;
					int cols = 0;
					int nRows = sheet.getPhysicalNumberOfRows();
					// Loop for traversing each row in the spreadsheet
					for (int r = 0; r < nRows; r++) {
						rowNo = r;
						rowNo++;
						row = sheet.getRow(rowNo);
						if (row != null) {
							// Column count in the current row
							cols = sheet.getRow(r).getLastCellNum();
							// Loop for traversing each column in each row in
							// the spreadsheet
							for (int c = 0; c < cols; c++) {
								cell = row.getCell((short) c);
								// If cell contains String value
								switch (c) {
								case 0:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
											hubname = cell.getStringCellValue();
										} else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell
													.setCellType(HSSFCell.CELL_TYPE_STRING);
											hubname = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										hubname = "";
									}
									break;
								case 1:
									if (cell != null) {

										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											radius = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell
													.setCellType(HSSFCell.CELL_TYPE_STRING);
											radius = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										radius = "";
									}
									break;
								case 2:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											latitude = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											latitude = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										latitude = "";
									}
									break;
								case 3:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											longitude = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											longitude = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										longitude = "";
									}
									break;
								case 4:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
											offset = cell.getStringCellValue();
										System.out.println("OFFSET_VALUE"+offset);
										}
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											offset = cell.getStringCellValue();
											System.out.println("OFFSET_VALUE"+offset);

										} else {
											format = "Invalid";
										}
									} else {
										offset = "";
									}
									break;
								case 5:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											city = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell
													.setCellType(HSSFCell.CELL_TYPE_STRING);
											city = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										city = "";
									}
									break;
								case 6:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											state = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell
													.setCellType(HSSFCell.CELL_TYPE_STRING);
											state = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										state = "";
									}
									break;
								case 7:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											country = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell
													.setCellType(HSSFCell.CELL_TYPE_STRING);
											country = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										country = "";
									}
									break;
								case 8:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											geoFence = cell
													.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell
													.setCellType(HSSFCell.CELL_TYPE_STRING);
											geoFence = cell
													.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										geoFence = "";
									}
									break;
								case 9:
									if (cell != null) {
										if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											stdDuration = cell.getStringCellValue();
										else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											stdDuration = cell.getStringCellValue();
										} else {
											format = "Invalid";
										}
									} else {
										stdDuration = "";
									}
									String empty="";
									if(radius.equals("0") || radius.equals("0.0")){
										list.add(new CreateLandmarkLocationData(hubname, radius, latitude,
												longitude, offset, city, state,country, empty, empty,Remarks));
									}
									else {
										if(hubname != "" || radius != "" || latitude != ""
											|| longitude != "" || offset != ""
											|| city != "" || state != ""
											|| country != "" || geoFence != ""
											|| stdDuration != ""){
									list.add(new CreateLandmarkLocationData(
											hubname, radius, latitude,
											longitude, offset, city, state,
											country, geoFence, stdDuration,
											Remarks));
										}
									}
									break;
								}
							}
						}
					}
				}  catch (Exception e) {
					e.printStackTrace();
				}
			}
			dataMap = getValidLocationDetails(list, systemId, userId);
			globalJsonArray = null;
			if (!dataMap.isEmpty())
				globalJsonArray = getImportExcelLocationDetails(clientId,systemId, dataMap.get("All"));
			if (globalJsonArray != null && globalJsonArray.length() > 0) {
				importMessage = "Success";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return importMessage;
	}

	public String editStrings(String str) {
		String s = "";
		str=str.trim();
		int length = str.length();
		if (str.contains(" ")) {
			String[] sd = str.split(" ");
			if (sd.length != 0) {
				for (int i = 0; i < sd.length; i++) {
					if(!sd[i].equals("")){
					String secondstr = sd[i].substring(0, 1).toUpperCase()
							+ sd[i].substring(1, sd[i].length());
					s = s + " " + secondstr;
					}
				}
			}
		} else {
			str = str.substring(0, 1).toUpperCase()
					+ str.substring(1, str.length());
			s = str;
		}
		return s.trim();
	}

	public String getLocationQuery(CharSequence query, String zone) {
		String retValue = query.toString();
		if (zone.equalsIgnoreCase("")) {
		} else {
			retValue = query.toString().replaceAll("LOCATION",
					"LOCATION_ZONE_" + zone);
		}
		return retValue;
	}

	public Map<String, List<CreateLandmarkLocationData>> getValidLocationDetails(
			List<CreateLandmarkLocationData> list, int systemId, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		Map<String, List<CreateLandmarkLocationData>> dataMap = new HashMap<String, List<CreateLandmarkLocationData>>();
		List<CreateLandmarkLocationData> validlist = new ArrayList();
		List<CreateLandmarkLocationData> validSavelist = new ArrayList();
		String zone = "";
		String loc = "{" + longitude + "," + latitude + "}";
		String locationString = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			System.out.println("LIST SIZE" + list.size());
			if (list.size() != 0) {
				for (CreateLandmarkLocationData locationDetails : list) {
					if (locationDetails.hubname == "") {
						locationDetails.Remarks = " Invalid Hub Name .";
					} else {
						locationString = editStrings(loc) +
						","
								+ editStrings(city) + "," + editStrings(state)
								+ "," + editStrings(country);
					}
					pstmt = con.prepareStatement("select Zone from System_Master where System_id=?");
					pstmt.setInt(1, systemId);
					rs = pstmt.executeQuery();
					if (rs.next()) {
						if (rs.getString("Zone") != null) {
							zone = rs.getString("Zone");
						}
					}
					String query = getLocationQuery("select NAME,HUBID from LOCATION where upper(NAME)=? and CLIENTID=? and SYSTEMID=?",zone);
					pstmt1 = con.prepareStatement(query);
					pstmt1.setString(1, locationString.toUpperCase());
					pstmt1.setInt(2, clientId);
					pstmt1.setInt(3, systemId);
					rs = pstmt1.executeQuery();
					if (rs.next()) {
						locationDetails.Remarks = " Hub Name already exist";
					}
					if (locationDetails.geoFence.equalsIgnoreCase("hub")) {
					float r = Float.parseFloat(locationDetails.radius);
						if (r > 3.0) {
							locationDetails.Remarks = "Invalid Radius for hub.Should not be more than 3";
						}
					}
					
					if (locationDetails.latitude != ""|| locationDetails.longitude != "") {
							pstmt = con.prepareStatement("select Zone from System_Master where System_id=?");
							pstmt.setInt(1, systemId);
							rs = pstmt.executeQuery();
							if (rs.next()) {
								if (rs.getString("Zone") != null) {
									zone = rs.getString("Zone");
								}
								pstmt = con.prepareStatement(CreateLandmarkStatements.CHECK_LAT_LONG_EXISTS_FOR_SYSTEM_AND_CLIENT
												.replace("LOCATION","LOCATION_ZONE_" + zone));
								pstmt.setInt(1,systemId);
								pstmt.setInt(2, clientId);
								rs = pstmt.executeQuery();
								while (rs.next()) {
									float lat=rs.getFloat(1);
									float lng=rs.getFloat(2);
									if (lat==(Float.parseFloat(locationDetails.latitude)) && lng==(Float.parseFloat(locationDetails.longitude))){
										locationDetails.Remarks = "LatLng already exists";
									}
								}
							}
					}
					
					if (!(locationDetails.Remarks.contains("already") || locationDetails.Remarks.contains("Invalid"))) {
						if(validlist.size()!=0){
							for (CreateLandmarkLocationData ld : validlist) {
								if(ld.hubname.equalsIgnoreCase(locationDetails.hubname)){
								    locationDetails.Remarks = " Hubname is Duplicate";
								}
							}
						}
						if(!locationDetails.Remarks.contains("Duplicate")){
						validSavelist.add(new CreateLandmarkLocationData(
								locationDetails.hubname,
								locationDetails.radius,
								locationDetails.latitude,
								locationDetails.longitude,
								locationDetails.offset, locationDetails.city,
								locationDetails.state, locationDetails.country,
								locationDetails.geoFence,
								locationDetails.stdDuration, locationDetails.Remarks));
						dataMap.put("Valid", validSavelist);
						}
					}
					validlist.add(new CreateLandmarkLocationData(
							locationDetails.hubname,
							locationDetails.radius,
							locationDetails.latitude,
							locationDetails.longitude,
							locationDetails.offset, locationDetails.city,
							locationDetails.state, locationDetails.country,
							locationDetails.geoFence,
							locationDetails.stdDuration, locationDetails.Remarks));
					dataMap.put("All", validlist);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return dataMap;
	}

	public JSONArray getImportExcelLocationDetails(int clientId, int systemId,
			List<CreateLandmarkLocationData> list) {
		JSONArray locationDetaisJsonArray = null;
		JSONObject locationDetailsJsonObject = null;
		int count = 0;
		try {
			locationDetaisJsonArray = new JSONArray();
			locationDetailsJsonObject = new JSONObject();
			for (CreateLandmarkLocationData locationDetails : list) {
				count++;
				locationDetailsJsonObject = new JSONObject();
				locationDetailsJsonObject.put("importslnoIndex", count);
				locationDetailsJsonObject.put("importhubname",locationDetails.hubname);
				locationDetailsJsonObject.put("importradius",locationDetails.radius);
				locationDetailsJsonObject.put("importlatitude",locationDetails.latitude);
				locationDetailsJsonObject.put("importlongitude",locationDetails.longitude);
				locationDetailsJsonObject.put("importoffset",locationDetails.offset);
				locationDetailsJsonObject.put("importcity",locationDetails.city);
				locationDetailsJsonObject.put("importstate",locationDetails.state);
				locationDetailsJsonObject.put("importcountry",locationDetails.country);
				locationDetailsJsonObject.put("importgeoFence",locationDetails.geoFence);
				locationDetailsJsonObject.put("importstdDuration",locationDetails.stdDuration);
				locationDetailsJsonObject.put("importremarksindex",locationDetails.Remarks);
				locationDetaisJsonArray.put(locationDetailsJsonObject);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return locationDetaisJsonArray;
	}
}
