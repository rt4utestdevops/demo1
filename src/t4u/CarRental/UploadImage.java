package t4u.CarRental;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Iterator;
import java.util.List;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import t4u.common.DBConnection;
import t4u.statements.CarRentalStatements;
import t4u.statements.IronMiningStatement;

public class UploadImage extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private boolean isMultipart;
	private String filePath;
	private String message;
	private File file;

	public void init() {
		// Get the file location where it would be stored.
		filePath = getServletContext().getInitParameter("file-path");
	}
	@SuppressWarnings( { "unchecked", "deprecation" })
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, java.io.IOException {

		// Check that we have a file upload request
		isMultipart = ServletFileUpload.isMultipartContent(request);
		response.setContentType("text/html");
		if (!isMultipart) {
			message="No Upload This Time";
			System.out.println("No Upload This Time");
			return;
		}
		int driverId=getDriverId();
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// Create a new file upload handler
		ServletFileUpload up = new ServletFileUpload(factory);
		try {
			List fileItems = up.parseRequest(request);
			Iterator element = fileItems.iterator();
			while (element.hasNext()) {
				FileItem fi = (FileItem) element.next();
				if (!fi.isFormField()) {
					String fileName = fi.getName();
					String fileNameForSave=filePath+"/"+driverId+"_"+fileName;
					if (fileName.lastIndexOf("\\") >= 0) {
						file = new File(fileNameForSave);
					} else {
						file = new File(fileNameForSave);
					}
					fi.write(file);

					File input = new File(fileNameForSave);
				    BufferedImage image = ImageIO.read(input);

			        File compressedImageFile = new File(fileNameForSave);
			        OutputStream os =new FileOutputStream(compressedImageFile);

			        Iterator<ImageWriter>writers =  ImageIO.getImageWritersByFormatName("jpg");
			        ImageWriter writer = (ImageWriter) writers.next();

			        ImageOutputStream ios = ImageIO.createImageOutputStream(os);
			        writer.setOutput(ios);
 
			        ImageWriteParam param = writer.getDefaultWriteParam();
			      
			        param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
			        param.setCompressionQuality(0.05f);
			        writer.write(null, new IIOImage(image, null, null), param);
			      
			        os.close();
			        ios.close();
			        writer.dispose();
					
					message="Uploaded";
					System.out.println("Uploaded Filename: " + fileNameForSave);
				}
			}
		    response.getWriter().print("{success:true}");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doPost(request, response);
	}
	public int getDriverId() {
		Connection con=null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		int driverIdNew = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(CarRentalStatements.GET_DRIVER_ID,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			rs=pstmt.executeQuery();
			if(rs.next())
			{   
				driverIdNew = rs.getInt("VALUE");
				driverIdNew++;
				rs.updateInt("VALUE", driverIdNew);
				rs.updateRow();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return driverIdNew;
	}


}
