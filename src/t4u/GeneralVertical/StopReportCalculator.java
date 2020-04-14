package t4u.GeneralVertical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import t4u.beans.StopReportBean;

public class StopReportCalculator {

	public static final String GET_HISTORY_DATA_STOP = "Select UNIT_NO,REGISTRATION_NO,GPS_DATETIME,IGNITION,SPEED,LOCATION ,ODOMETER,DELTADISTANCE"
			+ " FROM HISTORY_DATA where GPS_DATETIME BETWEEN ? and ? and REGISTRATION_NO=? order by GPS_DATETIME";
	public static final String GET_DELTA_DISTANCE_COUNT = "select sum(DELTADISTANCE) from HISTORY_DATA where REGISTRATION_NO=?" + " and GPS_DATETIME between ? and ?";

	@SuppressWarnings("unchecked")
	public List getStopReportList(Connection con, String regNo, String startDate, String endDate, boolean isExceptionRpt, String systemId, long selectedInterval) {
		List result = new ArrayList();
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		boolean isStopped = false;
		double firstOdometer = 0;
		@SuppressWarnings("unused")
		double distance = 0;
		Timestamp firstStop = null;
		Timestamp prevStop = null;

		double deltaCount = getDeltaCount(con, regNo, startDate, endDate, systemId);
		try {
			query = getHistoryDataQuery(GET_HISTORY_DATA_STOP, systemId);
			pstmt = con.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			pstmt.setString(3, regNo);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				if (rs.getInt("IGNITION") == 0 && isStopped == false) {
					firstStop = rs.getTimestamp("GPS_DATETIME");
					prevStop = rs.getTimestamp("GPS_DATETIME");
					firstOdometer = rs.getDouble("ODOMETER");
					isStopped = true;
				}

				if (isStopped && rs.getInt("IGNITION") != 1) {
					if (deltaCount > 0) {
						distance = rs.getDouble("DELTADISTANCE");
					} else {
						distance = rs.getDouble("ODOMETER") - firstOdometer;
					}
					prevStop = rs.getTimestamp("GPS_DATETIME");
				}

				if (isStopped && (rs.getInt("IGNITION") == 1 || rs.isLast())) {
					long diffmilli = prevStop.getTime() - firstStop.getTime();
					long stopMinute = diffmilli / (60 * 1000);
					if (stopMinute > 0) {
						StopReportBean sr = new StopReportBean();
						sr.setUnitNo(rs.getString("UNIT_NO"));
						sr.setRegNo(rs.getString("REGISTRATION_NO"));
						sr.setStartDate(sdfFormatDate.format(firstStop));
						sr.setEndDate(sdfFormatDate.format(prevStop));
						if (rs.getString("LOCATION") == null) {
							sr.setLocation("");
						} else {
							sr.setLocation(rs.getString("LOCATION"));
						}

						sr.setDuration(stopMinute);
						if (isExceptionRpt) {
							if (stopMinute >= selectedInterval) {
								result.add(sr);
							}
						} else {
							result.add(sr);
						}
					}
					isStopped = false;
				}
				// }
			}// end while
			return result;
		} catch (Exception e) {

			System.out.println("Exception in StopReportCalculation:" + e);
		}
		return result;
	}

	public double getDeltaCount(Connection con, String regNo, String startDate, String endDate, String systemId) {
		double sum = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		try {
			query = getHistoryDataQuery(GET_DELTA_DISTANCE_COUNT, systemId);
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, regNo);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				sum = rs.getDouble(1);
			}
		} catch (Exception e) {
			System.out.println("Exception in getDeltaCount:" + e);
		}
		return sum;
	}

	public String getHistoryDataQuery(CharSequence query, String systemid) {
		String retValue = query.toString();
		retValue = query.toString().replaceAll("HISTORY_DATA", "HISTORY_DATA" + "_" + systemid);
		return retValue;
	}
}
