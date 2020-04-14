package t4u.distributionlogistics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


import t4u.common.DBConnection;
import t4u.statements.DistributionStatments;

public class CTDashboardColumns {
	private StringBuilder filterList=null;
	private StringBuffer gridHeaderBuffer = new StringBuffer();
	
	public StringBuilder getFilterList() {
		return filterList;
	}
	public void setFilterList(StringBuilder filterList) {
		this.filterList = filterList;
	}

	public StringBuffer getGridHeaderBuffer(int userId,int systemId,int customerId)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> dataindexList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(DistributionStatments.GET_COLUMN_HEADERS_FOR_USER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs=pstmt.executeQuery(); 
			while(rs.next()){
				if(rs.getString("LABEL").equalsIgnoreCase("Shipment_Id")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'shipmentIdIndex',filter: {type:'string'}},");
				  dataindexList.add("shipmentIdIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Vehicle_No")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'vehicleNoDataIndex',filter: {type:'string'}},");
				  dataindexList.add("vehicleNoDataIndex");
				}
				if(rs.getString("LABEL").equalsIgnoreCase("Source")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'sourceDataIndex',filter: {type:'string'}},");
				  dataindexList.add("sourceDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Destination")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'destataIndex',filter: {type:'string'}},");
				  dataindexList.add("destataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Touch_Point_in_Sequence")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'pointInSequenceDataIndex',filter: {type:'string'}},");
				  dataindexList.add("pointInSequenceDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Start_Time_Planned")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'plannedStartTimeDataIndex',filter: {type:'string'}},");
				  dataindexList.add("plannedStartTimeDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Start_Time_Actual")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'actualStartTimeDataIndex',filter: {type:'string'}},");
				  dataindexList.add("actualStartTimeDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Planned_Destination_ETA")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'etaDataIndex',filter: {type:'string'}},");
				  dataindexList.add("etaDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Revised_Destination_ETA")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'revisedetaDataIndex',filter: {type:'string'}},");
				  dataindexList.add("revisedetaDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Total_Trip_Distance")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'tripDistanceDataIndex',filter: {type:'numeric'}},");
				  dataindexList.add("tripDistanceDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Touch_Points_Covered")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'touchPtCoveredDataIndex',filter: {type:'int'}},");
				  dataindexList.add("touchPtCoveredDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Next_Touch_Point")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'nextTouchptDataIndex',filter: {type:'string'}},");
				  dataindexList.add("nextTouchptDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Current_Location")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'locationDataIndex',filter: {type:'string'}},");
				  dataindexList.add("locationDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Km_Coverd")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'kmsDataIndex',filter: {type:'numeric'}},");
				  dataindexList.add("kmsDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Km_to_be_Covered")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'kmtoDestDataIndex',filter: {type:'numeric'}},");
				  dataindexList.add("kmtoDestDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Status")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'statusDataIndex',filter: {type:'string'}},");
				  dataindexList.add("statusDataIndex");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Completion")){
				  gridHeaderBuffer.append("{header: '<span style=font-weight:bold;>"+rs.getString("VALUE")+"</span>', dataIndex: 'completionDataIndex',filter: {type:'string'},renderer: function(value, metaData, record, rowIndex, colIndex, store) {var fieldName = grid.getColumnModel().getDataIndex(colIndex);status = record.get(fieldName);return status;}},");
				  dataindexList.add("completionDataIndex");
			    }
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		return gridHeaderBuffer;
	}
	
	
	public StringBuilder getGridReaders(int userId,int systemId,int customerId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder gridFilterList=new StringBuilder();
		StringBuilder gridReaderList = new StringBuilder();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(DistributionStatments.GET_COLUMN_HEADERS_FOR_USER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs=pstmt.executeQuery(); 
			while(rs.next()){
				if(rs.getString("LABEL").equalsIgnoreCase("Shipment_Id")){
				  gridReaderList.append("{name: 'shipmentIdIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'shipmentIdIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Vehicle_No")){
				  gridReaderList.append("{name: 'vehicleNoDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'vehicleNoDataIndex',type: 'string'},");
				}
				if(rs.getString("LABEL").equalsIgnoreCase("Source")){
				  gridReaderList.append("{name: 'sourceDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'sourceDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Destination")){
				  gridReaderList.append("{name: 'destataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'destataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Touch_Point_in_Sequence")){
				  gridReaderList.append("{name: 'pointInSequenceDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'pointInSequenceDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Start_Time_Planned")){
				  gridReaderList.append("{name: 'plannedStartTimeDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'plannedStartTimeDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Start_Time_Actual")){
				  gridReaderList.append("{name: 'actualStartTimeDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'actualStartTimeDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Planned_Destination_ETA")){
				  gridReaderList.append("{name: 'etaDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'etaDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Revised_Destination_ETA")){
				  gridReaderList.append("{name: 'revisedetaDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'revisedetaDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Total_Trip_Distance")){
				  gridReaderList.append("{name: 'tripDistanceDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'tripDistanceDataIndex',type: 'numeric'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Touch_Points_Covered")){
				  gridReaderList.append("{name: 'touchPtCoveredDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'touchPtCoveredDataIndex',type: 'numeric'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Next_Touch_Point")){
				  gridReaderList.append("{name: 'nextTouchptDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'nextTouchptDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Current_Location")){
				  gridReaderList.append("{name: 'locationDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'locationDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Km_Coverd")){
				  gridReaderList.append("{name: 'kmsDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'kmsDataIndex',type: 'numeric'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Km_to_be_Covered")){
				  gridReaderList.append("{name: 'kmtoDestDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'kmtoDestDataIndex',type: 'numeric'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Status")){
				  gridReaderList.append("{name: 'statusDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'sourcstatusDataIndexeDataIndex',type: 'string'},");
			    }
				if(rs.getString("LABEL").equalsIgnoreCase("Trip_Completion")){
				  gridReaderList.append("{name: 'completionDataIndex',type: 'string'},");
				  gridFilterList.append("{dataIndex: 'completionDataIndex',type: 'string'},");
			    }
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		setFilterList(gridFilterList);	
		return gridReaderList;
	}
	
	public String exportDataTypes(int userId,int systemId,int customerId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String dataTypes="int";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(DistributionStatments.GET_COLUMN_HEADERS_FOR_USER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs=pstmt.executeQuery(); 
			while(rs.next()){
				dataTypes=dataTypes+","+rs.getString("DATA_TYPE");
			}
			dataTypes=dataTypes+","+"string"+","+"string";
			System.out.println(dataTypes);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return dataTypes;
	}
}
