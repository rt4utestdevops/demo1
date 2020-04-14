package t4u.GeneralVertical;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import t4u.common.ApplicationListener;

public class UploadCreateTripImage extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private boolean isMultipart;
	@SuppressWarnings("unused")
	private String message;
	private File file;

	/**
	 * Constructor of the object.
	 */
	public UploadCreateTripImage() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
//		System.out.println("in do get");
//		Properties properties = null;
//		properties = ApplicationListener.prop;
//		String FileDestination = properties.getProperty("CreateTripImage");
//		String tripId=request.getParameter("tripId");
//		System.out.println("TRIP ID in Get : "+tripId);
//		 String filePath = FileDestination+"\\Trip_Id_7976.jpg";
//	        File downloadFile = new File(filePath);
//	        FileInputStream inStream = new FileInputStream(downloadFile);
//	         
//	        // if you want to use a relative path to context root:
//	        String relativePath = getServletContext().getRealPath("");
//	        System.out.println("relativePath = " + relativePath);
//	         
//	        // obtains ServletContext
//	        ServletContext context = getServletContext();
//	         
//	        // gets MIME type of the file
//	        String mimeType = context.getMimeType(filePath);
//	        if (mimeType == null) {        
//	            // set to binary type if MIME mapping not found
//	            mimeType = "image/jpeg";
//	        }
//	        System.out.println("MIME type: " + mimeType);
//	         
//	        // modifies response
//	        response.setContentType(mimeType);
//	        response.setContentLength((int) downloadFile.length());
//	         
//	        // forces download
//	        String headerKey = "Content-Disposition";
//	        String headerValue = String.format("attachment; filename=\"%s\"", downloadFile.getName());
//	        response.setHeader(headerKey, headerValue);
//	         
//	        // obtains response's output stream
//	        OutputStream outStream = response.getOutputStream();
//	         
//	        byte[] buffer = new byte[4096];
//	        int bytesRead = -1;
//	         
//	        while ((bytesRead = inStream.read(buffer)) != -1) {
//	            outStream.write(buffer, 0, bytesRead);
//	        }
//	         
//	        inStream.close();
//	        outStream.close();  
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Properties properties = null;
		properties = ApplicationListener.prop;
		String FileDestination = properties.getProperty("CreateTripImage");
		
        HttpSession session = request.getSession();
       // filePath=request.getAttribute("filePath").toString();
		String tripId=session.getAttribute("tripId").toString();
	
		isMultipart = ServletFileUpload.isMultipartContent(request);
		response.setContentType("text/html");
		if (!isMultipart) {
			message="No Upload This Time";
			System.out.println("No Upload This Time");
			return;
		}
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
					String fileNameForSave=FileDestination+"/Trip_Id_"+tripId+".jpg";
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
			String fromTripImageUpload="fromTripImageUpload";
			session.setAttribute("fromTripImageUpload", fromTripImageUpload);
			//getServletContext().getRequestDispatcher("/Jsps/GeneralVertical/CreateTrip.jsp").include(request, response);
	           //response.sendRedirect(c+"/Jsps/loadandRoutePlanner/ImportLoadPlan.jsp");
		   response.sendRedirect(request.getContextPath()+"/Jsps/GeneralVertical/CreateTrip.jsp");
			//response.getWriter().print("{success:true}");
		} catch (Exception e) {
			String unsuccessfulImageUpload="unsuccessfulImageUpload";
			e.printStackTrace();
			session.setAttribute("unsuccessfulImageUpload", unsuccessfulImageUpload);
			response.sendRedirect(request.getContextPath()+"/Jsps/GeneralVertical/CreateTrip.jsp");
		}
	}
	
	
	public void getImagePathAndTripId(String tripId, String path){
//		System.out.print("SERVLET - TRIPID : "+tripId+" , PATH : "+path);
//		Properties properties = null;
//		properties = ApplicationListener.prop;
//		String pathToSave = properties.getProperty("CreateTripImage");
//		System.out.println("PATH : "+pathToSave);
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
