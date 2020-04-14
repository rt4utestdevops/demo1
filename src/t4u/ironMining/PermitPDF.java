package t4u.ironMining;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

@SuppressWarnings("serial")
public class PermitPDF extends HttpServlet {
	static BaseFont baseFont = null;
	static int font = 10;
	static int fontsc = 9;

	public String GET_PERMIT_DETAILS = " select isnull(e1.IBM_TRADER_NO,'') as IBM_APPLICATION_NO,isnull(e3.GST_NO,'') as TC_GST_NO,isnull(e1.GST_NO,'') as GST_NO,isnull(mpd.STATUS,'') as STATUS,isnull(DEST_TYPE,'') as DEST_TYPE,isnull(SRC_TYPE,'') as SRC_TYPE,isnull(rd.ROUTE_NAME,'') as Trip_Name,isnull(lz1.NAME,'') as Start_Location,isnull(lz2.NAME,'') as End_Location,isnull(lz.NAME,'') as NAME,mpd.REMARKS,isnull(PERMIT_TYPE,'') AS PERMIT_TYPE,isnull(mpd.INSERTED_DATETIME,'') as ISSUED_DATE,tc.MINE_CODE,tc.TC_NO,e.ORGANIZATION_NAME,e1.ORGANIZATION_CODE,isnull(e1.ORGANIZATION_NAME,'') as PROCESSED_ORGANIZATION_NAME,mpd.PERMIT_NO,mpd.MINERAL,isnull(mpd.DATE,'') as DATE,mpd.APPLICATION_NO, "
			+ " mcd.CHALLAN_NO,isnull(mpd.START_DATE,'') as START_DATE,isnull(mpd.END_DATE,'') as END_DATE,mpd.CHALLAN_ID,isnull(mcd.PROCESSING_FEE,0) as  PROCESSING_FEE,  "
			+ " isnull(sd.STATE_NAME,'') as STATE_NAME,isnull(cd.COUNTRY_NAME,'') as COUNTRY_NAME,isnull(BUYER_NAME,'') as BUYER_NAME ,isnull(SHIP_NAME,'') as  SHIP_NAME,isnull(e2.ORGANIZATION_NAME,'') as BUYING_ORGANIZAION_NAME,isnull(e2.ORGANIZATION_CODE,'') as BUYING_ORGANIZATION_CODE,"
			+ " (select PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS where ID=mpd.EXISTING_PERMIT_ID) as EXISTING_PERMIT_NO, "
			+ " isnull(mpd.PERMIT_REQUEST_TYPE,'')as PERMIT_REQUEST_TYPE,isnull(mpd.EXISTING_PERMIT_ID,'') as EXISTING_PERMIT_ID, "
			+ " isnull(IMPORT_TYPE,'') as IMPORT_TYPE,isnull(IMPORT_PURPOSE,'') as IMPORT_PURPOSE ,isnull(EXPORT_PERMIT_NO,'') as EXPORT_PERMIT_NO,isnull(EXPORT_PERMIT_NO_DATE,'') as EXPORT_PERMIT_NO_DATE ,isnull(EXPORT_CHALLAN_NO,'') as EXPORT_CHALLAN_NO,isnull(EXPORT_CHALLAN_NO_DATE,'') as EXPORT_CHALLAN_NO_DATE,"
			+ " isnull(SALE_INVOICE_NO,'') as SALE_INVOICE_NO,isnull(SALE_INVOICE_NO_DATE,'') as SALE_INVOICE_NO_DATE,isnull(TRANSPORTATION_TYPE,'') as TRANSPORTATION_TYPE,isnull(VESSEL_NAME,'') as VESSEL_NAME "
			+ " from dbo.MINING_PERMIT_DETAILS mpd  "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on mpd.TC_ID=tc.ID  "
			+ " left outer join AMS.dbo.MINING_CHALLAN_DETAILS mcd on mcd.ID=mpd.CHALLAN_ID  " 
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=tc.MINE_ID and e.SYSTEM_ID=tc.SYSTEM_ID  and e.CUSTOMER_ID=tc.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER e1 on e1.ID=mpd.ORGANIZATION_CODE and e1.SYSTEM_ID=mpd.SYSTEM_ID  and e1.CUSTOMER_ID=mpd.CUSTOMER_ID"
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER e2 on e2.ID=mpd.BUYING_ORG_ID and e2.SYSTEM_ID=mpd.SYSTEM_ID  and e2.CUSTOMER_ID=mpd.CUSTOMER_ID"
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER e3 on e3.ID=e.ORG_ID and e3.SYSTEM_ID=e.SYSTEM_ID  and e3.CUSTOMER_ID=e.CUSTOMER_ID "
			+ " left outer join ADMINISTRATOR.dbo.STATE_DETAILS sd on sd.STATE_CODE=mpd.STATE "
			+ " left outer join ADMINISTRATOR.dbo.COUNTRY_DETAILS cd on cd.COUNTRY_CODE=mpd.COUNTRY "
			+ " left outer join MINING.dbo.IMPORT_PERMIT_DETAILS ipd on ipd.PERMIT_ID=mpd.ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=mpd.ROUTE_ID and rd.SYSTEM_ID=mpd.SYSTEM_ID and rd.CUSTOMER_ID=mpd.CUSTOMER_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=mpd.ROUTE_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz1 on lz1.HUBID=rd.SOURCE_HUB_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz2 on lz2.HUBID=rd.DESTINATION_HUB_ID "
			+ " where mpd.ID=? ";

	public String GET_PERMIT_GRADE_DETAILS_FOR_PROCESSED_ORE = " select isnull(QUANTITY,0) as QUANTITY,isnull(TYPE,'') as TYPE,isnull(GRADE,'') as GRADE,isnull(TOTAL_PROCESSING_FEE,0)as TOTAL_PROCESSING_FEE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=? ";

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath = properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName = "AssetAcknowledgement";
			int id1 = Integer.parseInt(request.getParameter("autoGeneratedKeys"));
			String formno = "PERMIT FORM_" + id1;
			baseFont = BaseFont.createFont(BaseFont.TIMES_ROMAN,BaseFont.CP1252, false);
			String bill = billpath + pdfFileName + ".pdf";
			generateBill(bill, request);
			printBill(servletOutputStream, response, bill, formno);

		} catch (Exception e) {
			System.out.println("Error generating pdf form : " + e);
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	private void generateBill(String bill, HttpServletRequest request) {
		try {
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4, 40, 40, 30, 20);
			@SuppressWarnings("unused")
			PdfWriter writer = PdfWriter.getInstance(document, fileOut);
			document.open();

			int id = Integer.parseInt(request.getParameter("autoGeneratedKeys"));
			String buttonType = request.getParameter("buttonType");

			HashMap permitDetails = new HashMap();
			permitDetails = getDataForPermitDetails(id);

			String organisationName = "";
			String gstNo="";
			String romPermitNo = (String) permitDetails.get("permitNo");
			String issuedDate = (String) permitDetails.get("issuedDate");
			String appNo = (String) permitDetails.get("appNo");
			String permitAppliedDate = (String) permitDetails.get("permitDate");
			String orgName = (String) permitDetails.get("orgName");
			String tcNo = (String) permitDetails.get("tcNo");
			String mineCode = (String) permitDetails.get("minecode");
			String mineral = (String) permitDetails.get("mineral");
			String gradeLumps = (String) permitDetails.get("lumpGrade");
			String gradeFines = (String) permitDetails.get("fineGrade");
			String graderom = (String) permitDetails.get("romGrade");
			String gradeConc = (String) permitDetails.get("concGrade");
			String gradeTailings = (String) permitDetails.get("tailingGrade");
			String challanNo = (String) permitDetails.get("challanNo");
			String gradeQtylump = (String) permitDetails.get("lumpQuantity");
			String gradeQtyfines = (String) permitDetails.get("fineQuantity");
			String gradeQtyrom = (String) permitDetails.get("romQuantity");
			String gradeQtyConc = (String) permitDetails.get("concQuantity");
			String gradeQtyTailings = (String) permitDetails.get("tailingQuantity");
			String totalQty = (String) permitDetails.get("totalQuantity");
			String royalityPaid = (String) permitDetails.get("royalityPaid");
			String routeId = (String) permitDetails.get("tripName");
			String sourceLocation = (String) permitDetails.get("startLocation");
			String destLocation = (String) permitDetails.get("endLocation");
			String permitValidity = (String) permitDetails.get("startDate")+ " - " + (String) permitDetails.get("endDate");
			String permitProcessingFee = (String) permitDetails.get("processingFee");
			String permitType = (String) permitDetails.get("permitType");
			String orgCode = (String) permitDetails.get("orgCode");
			String processedOrgName = (String) permitDetails.get("processedOrgName");
			String stateName = (String) permitDetails.get("stateName");
			String countryName = (String) permitDetails.get("countryName");
			String buyerName = (String) permitDetails.get("buyerName");
			String shipName = (String) permitDetails.get("shipName");
			String buyingOrgName = (String) permitDetails.get("buyingOrgName");
			String buyingOrgCode = (String) permitDetails.get("buyingOrgCode");
			String permitReqType = (String) permitDetails.get("permitReqType");
			String existingPermitNo = (String) permitDetails.get("existingPermitNo");
			String totalProFee = (String) permitDetails.get("totalProcessingFee");

			String importType = (String) permitDetails.get("importType");
			String importPurpose = (String) permitDetails.get("importPurpose");
			String exportPermitNo = (String) permitDetails.get("exportPermitNo");
			String exportPermitDate = (String) permitDetails.get("exportPermitDate");
			String exportChallanNo = (String) permitDetails.get("exportChallanNo");
			String exportChallanDate = (String) permitDetails.get("exportChallanDate");
			String invoiceNo = (String) permitDetails.get("invoiceNo");
			String invoiceDate = (String) permitDetails.get("invoiceDate");
			String transportnType = (String) permitDetails.get("transportnType");
			String vesselName = (String) permitDetails.get("vesselName");
			String remarks = (String) permitDetails.get("remarks");
			String hubIdPo = (String) permitDetails.get("hubIdPo");
			String srcType = (String) permitDetails.get("srcType");
			String destType = (String) permitDetails.get("destType");
			String status=(String)permitDetails.get("status");
			String OrggstNo=(String)permitDetails.get("gstNo");
			String TCgstNo = (String)permitDetails.get("TCgstNo");
			String ibmAppNo = (String)permitDetails.get("ibmAppNo");

			if (((permitType.equals("Rom Transit") || permitType.equals("Rom Sale")) && srcType
					.equalsIgnoreCase("ROM"))
					|| permitType.equals("Purchased Rom Sale Transit Permit")
					|| permitType.equals("Processed Ore Transit")
					|| permitType.equals("International Export")
					|| permitType.equals("Domestic Export")
					|| permitType.equals("Processed Ore Sale")
					|| permitType.equals("Processed Ore Sale Transit")
					|| permitType.equals("Import Permit")
					|| permitType.equals("Import Transit Permit")) {
				organisationName = processedOrgName;
				gstNo=OrggstNo;
			} else {
				organisationName = orgName;
				gstNo=TCgstNo;
			}
			if (((permitType.equals("Rom Transit") || permitType.equals("Rom Sale")) && srcType
					.equalsIgnoreCase("ROM"))
					|| permitType.equals("Processed Ore Transit")
					|| permitType.equals("International Export")
					|| permitType.equals("Domestic Export")
					|| permitType.equals("Processed Ore Sale")
					|| permitType.equals("Processed Ore Sale Transit")
					|| permitType.equals("Import Permit")
					|| permitType.equals("Import Transit Permit")) {
				gradeQtylump = (String) permitDetails.get("lumpQuantity");
				gradeQtyfines = (String) permitDetails.get("fineQuantity");
				gradeQtyConc = (String) permitDetails.get("concQuantity");
				gradeQtyTailings = (String) permitDetails.get("tailingQuantity");
				totalQty = (String) permitDetails.get("totalQuantity");
				gradeLumps = (String) permitDetails.get("lumpGrade");
				gradeFines = (String) permitDetails.get("fineGrade");
				gradeConc = (String) permitDetails.get("concGrade");
				gradeTailings = (String) permitDetails.get("tailingGrade");
				totalProFee = (String) permitDetails.get("totalProcessingFee");
			}
			if (!(buttonType.equals("Add") || buttonType.equals("Modify"))) {
				PdfPTable image = createImage();
				document.add(image);
			} else {
				document.add(createEmptyLogoHeader());
			}

			PdfPTable permitHeader = createPermitHeader(permitType,permitReqType, buttonType, importType);
			document.add(permitHeader);

			PdfPTable heading = createTableForHeadings(romPermitNo, issuedDate);
			document.add(heading);

			PdfPTable permitData = createTableForPermitDetails(appNo,
					permitAppliedDate, organisationName, tcNo, mineCode,
					mineral, gradeLumps, gradeFines, challanNo, gradeQtyfines,
					gradeQtylump, totalQty, royalityPaid, routeId,
					sourceLocation, destLocation, permitValidity,
					permitProcessingFee, permitType, orgCode, stateName,
					countryName, buyerName, shipName, buyingOrgName,
					buyingOrgCode, totalProFee, importType, importPurpose,
					exportPermitNo, exportPermitDate, exportChallanNo,
					exportChallanDate, invoiceNo, invoiceDate, transportnType,
					vesselName, existingPermitNo, remarks, graderom,
					gradeQtyrom, hubIdPo, srcType, destType,gradeConc,gradeTailings,gradeQtyConc,gradeQtyTailings,gstNo,ibmAppNo);
			document.add(permitData);

			PdfPTable footer = createFooter();
			document.add(footer);

			PdfPTable footer1 = createFooter1();
			document.add(footer1);

			document.close();
		} catch (Exception e) {
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}

	/** if directory not exists then create it */
	private void refreshdir(String reportpath) {
		try {
			File f = new File(reportpath);
			if (!f.exists()) {
				f.mkdir();
			}
		} catch (Exception e) {
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
	}

	private PdfPTable createTableForHeadings(String romPermitNo,
			String issuedDate) {
		float[] widths = { 70, 20, 50 };
		PdfPTable t = new PdfPTable(3);

		try {
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1 = new Phrase("        PERMIT NO : " + romPermitNo,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			Phrase myPhrase = new Phrase("", new Font(baseFont, font,Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.setBackgroundColor(Color.WHITE);
			t.addCell(c1);

			myPhrase1 = new Phrase("        Issue Date : " + issuedDate,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			c2.setBackgroundColor(Color.WHITE);
			t.addCell(c2);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs = new PdfPCell(myPhrase);
			cs.disableBorderSide(Rectangle.LEFT);
			cs.disableBorderSide(Rectangle.RIGHT);
			cs.disableBorderSide(Rectangle.TOP);
			cs.setBackgroundColor(Color.WHITE);
			t.addCell(cs);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs1 = new PdfPCell(myPhrase);
			cs1.disableBorderSide(Rectangle.LEFT);
			cs1.disableBorderSide(Rectangle.RIGHT);
			cs1.disableBorderSide(Rectangle.TOP);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs2 = new PdfPCell(myPhrase);
			cs2.disableBorderSide(Rectangle.LEFT);
			cs2.disableBorderSide(Rectangle.RIGHT);
			cs2.disableBorderSide(Rectangle.TOP);
			cs2.setBackgroundColor(Color.WHITE);
			t.addCell(cs2);

		} catch (Exception e) {
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createTableForPermitDetails(String appNo,
			String permitAppliedDate, String orgName, String tcNo,
			String mineCode, String mineral, String gradeLumps,
			String gradeFines, String challanNo, String gradeQtyfines,
			String gradeQtylump, String totalQty, String royalityPaid,
			String routeId, String sourceLocation, String destLocation,
			String permitValidity, String permitProcessingFee,
			String permitType, String orgCode, String stateName,
			String countryName, String buyerName, String shipName,
			String buyingOrgName, String buyingOrgCode, String totalProFee,
			String importType, String importPurpose, String exportPermitNo,
			String exportPermitDate, String exportChallanNo,
			String exportChallanDate, String invoiceNo, String invoiceDate,
			String transportnType, String vesselName, String existingPermitNo,
			String remarks, String graderom, String gradeQtyrom,
			String hubIdPo, String srcType, String destType,String gradeConc,String gradeTailings,String gradeQtyConc,String gradeQtyTailings,String gstNo,String ibmAppNo) {
		float[] widths = { 50, 15, 50 };
		PdfPTable t = new PdfPTable(3);
		String loc = "";
		if (permitType.equals("Processed Ore Sale")|| permitType.equals("Rom Sale")) {
			loc = hubIdPo;
		} else {
			loc = sourceLocation;
		}

		try {
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1 = new Phrase("        Permit applied Date  ", new Font(baseFont, font, Font.NORMAL));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			c2.setBackgroundColor(Color.WHITE);
			t.addCell(c2);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell cd2 = new PdfPCell(myPhrase1);
			cd2.setBorder(Rectangle.NO_BORDER);
			cd2.setBackgroundColor(Color.WHITE);
			t.addCell(cd2);

			Phrase myPhrase = new Phrase(permitAppliedDate, new Font(baseFont, font,Font.NORMAL));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			c3.setBackgroundColor(Color.WHITE);
			t.addCell(c3);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs2 = new PdfPCell(myPhrase);
			cs2.setBorder(Rectangle.NO_BORDER);
			cs2.setBackgroundColor(Color.WHITE);
			t.addCell(cs2);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs3 = new PdfPCell(myPhrase);
			cs3.setBorder(Rectangle.NO_BORDER);
			cs3.setBackgroundColor(Color.WHITE);
			t.addCell(cs3);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs1 = new PdfPCell(myPhrase);
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			if (((permitType.equals("Rom Transit") || permitType.equals("Rom Transit")) && srcType
					.equalsIgnoreCase("ROM"))
					|| permitType.equals("Processed Ore Transit")
					|| permitType.equals("International Export")
					|| permitType.equals("Domestic Export")
					|| permitType.equals("Processed Ore Sale")
					|| permitType.equals("Processed Ore Sale Transit")
					|| permitType.equals("Import Permit")
					|| permitType.equals("Import Transit Permit")
					|| permitType.equals("Purchased Rom Sale Transit Permit")) {

				myPhrase1 = new Phrase("        Organization/Trader Code   ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c4 = new PdfPCell(myPhrase1);
				c4.setBorder(Rectangle.NO_BORDER);
				c4.setBackgroundColor(Color.WHITE);
				t.addCell(c4);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd4 = new PdfPCell(myPhrase1);
				cd4.setBorder(Rectangle.NO_BORDER);
				cd4.setBackgroundColor(Color.WHITE);
				t.addCell(cd4);

				myPhrase = new Phrase(orgCode, new Font(baseFont, font,Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase);
				c5.setBorder(Rectangle.NO_BORDER);
				c5.setBackgroundColor(Color.WHITE);
				t.addCell(c5);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs4 = new PdfPCell(myPhrase);
				cs4.setBorder(Rectangle.NO_BORDER);
				cs4.setBackgroundColor(Color.WHITE);
				t.addCell(cs4);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs5 = new PdfPCell(myPhrase);
				cs5.setBorder(Rectangle.NO_BORDER);
				cs5.setBackgroundColor(Color.WHITE);
				t.addCell(cs5);

			}
			myPhrase1 = new Phrase("        Organization/Trader Name   ",new Font(baseFont, font, Font.NORMAL));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBorder(Rectangle.NO_BORDER);
			c4.setBackgroundColor(Color.WHITE);
			t.addCell(c4);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell cd4 = new PdfPCell(myPhrase1);
			cd4.setBorder(Rectangle.NO_BORDER);
			cd4.setBackgroundColor(Color.WHITE);
			t.addCell(cd4);

			myPhrase = new Phrase(orgName, new Font(baseFont, font, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBorder(Rectangle.NO_BORDER);
			c5.setBackgroundColor(Color.WHITE);
			t.addCell(c5);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs4 = new PdfPCell(myPhrase);
			cs4.setBorder(Rectangle.NO_BORDER);
			cs4.setBackgroundColor(Color.WHITE);
			t.addCell(cs4);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs5 = new PdfPCell(myPhrase);
			cs5.setBorder(Rectangle.NO_BORDER);
			cs5.setBackgroundColor(Color.WHITE);
			t.addCell(cs5);
			
			myPhrase1 = new Phrase("        Application No  ", new Font(baseFont, font, Font.NORMAL));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase = new Phrase(":", new Font(baseFont, font,Font.BOLD));
			PdfPCell cd1 = new PdfPCell(myPhrase);
			cd1.setBorder(Rectangle.NO_BORDER);
			cd1.setBackgroundColor(Color.WHITE);
			t.addCell(cd1);

			myPhrase = new Phrase(appNo, new Font(baseFont, font, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.setBackgroundColor(Color.WHITE);
			t.addCell(c1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs = new PdfPCell(myPhrase);
			cs.setBorder(Rectangle.NO_BORDER);
			cs.setBackgroundColor(Color.WHITE);
			t.addCell(cs);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			if ((permitType.equals("Rom Transit"))|| permitType.equals("Rom Sale")|| permitType.equals("Bauxite Transit")) {
				if (srcType.equalsIgnoreCase("E-Wallet")) {
					myPhrase1 = new Phrase("        T.C. No. ", new Font(baseFont, font, Font.NORMAL));
					PdfPCell c6 = new PdfPCell(myPhrase1);
					c6.setBorder(Rectangle.NO_BORDER);
					c6.setBackgroundColor(Color.WHITE);
					t.addCell(c6);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cd6 = new PdfPCell(myPhrase1);
					cd6.setBorder(Rectangle.NO_BORDER);
					cd6.setBackgroundColor(Color.WHITE);
					t.addCell(cd6);

					myPhrase = new Phrase(tcNo, new Font(baseFont, font,Font.BOLD));
					PdfPCell c7 = new PdfPCell(myPhrase);
					c7.setBorder(Rectangle.NO_BORDER);
					c7.setBackgroundColor(Color.WHITE);
					t.addCell(c7);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs6 = new PdfPCell(myPhrase);
					cs6.setBorder(Rectangle.NO_BORDER);
					cs6.setBackgroundColor(Color.WHITE);
					t.addCell(cs6);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs7 = new PdfPCell(myPhrase);
					cs7.setBorder(Rectangle.NO_BORDER);
					cs7.setBackgroundColor(Color.WHITE);
					t.addCell(cs7);

					myPhrase1 = new Phrase("        Mine Code ", new Font(baseFont, font, Font.NORMAL));
					PdfPCell c006 = new PdfPCell(myPhrase1);
					c006.setBorder(Rectangle.NO_BORDER);
					c006.setBackgroundColor(Color.WHITE);
					t.addCell(c006);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cdo6 = new PdfPCell(myPhrase1);
					cdo6.setBorder(Rectangle.NO_BORDER);
					cdo6.setBackgroundColor(Color.WHITE);
					t.addCell(cdo6);

					myPhrase = new Phrase(mineCode, new Font(baseFont, font,Font.NORMAL));
					PdfPCell c007 = new PdfPCell(myPhrase);
					c007.setBorder(Rectangle.NO_BORDER);
					c007.setBackgroundColor(Color.WHITE);
					t.addCell(c007);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs8 = new PdfPCell(myPhrase);
					cs8.setBorder(Rectangle.NO_BORDER);
					cs8.setBackgroundColor(Color.WHITE);
					t.addCell(cs8);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs9 = new PdfPCell(myPhrase);
					cs9.setBorder(Rectangle.NO_BORDER);
					cs9.setBackgroundColor(Color.WHITE);
					t.addCell(cs9);
				}

				if (permitType.equals("Rom Transit") || permitType.equals("Rom Sale")) {
					myPhrase1 = new Phrase("        Source Type ", new Font(baseFont, font, Font.NORMAL));
					PdfPCell c006r = new PdfPCell(myPhrase1);
					c006r.setBorder(Rectangle.NO_BORDER);
					c006r.setBackgroundColor(Color.WHITE);
					t.addCell(c006r);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cdo6r = new PdfPCell(myPhrase1);
					cdo6r.setBorder(Rectangle.NO_BORDER);
					cdo6r.setBackgroundColor(Color.WHITE);
					t.addCell(cdo6r);

					myPhrase = new Phrase(srcType, new Font(baseFont, font,Font.NORMAL));
					PdfPCell c007r = new PdfPCell(myPhrase);
					c007r.setBorder(Rectangle.NO_BORDER);
					c007r.setBackgroundColor(Color.WHITE);
					t.addCell(c007r);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);
				}
			}
			myPhrase1 = new Phrase("        Mineral  ", new Font(baseFont,font, Font.NORMAL));
			PdfPCell c06 = new PdfPCell(myPhrase1);
			c06.setBorder(Rectangle.NO_BORDER);
			c06.setBackgroundColor(Color.WHITE);
			t.addCell(c06);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell cd06 = new PdfPCell(myPhrase1);
			cd06.setBorder(Rectangle.NO_BORDER);
			cd06.setBackgroundColor(Color.WHITE);
			t.addCell(cd06);

			myPhrase = new Phrase(mineral,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c07 = new PdfPCell(myPhrase);
			c07.setBorder(Rectangle.NO_BORDER);
			c07.setBackgroundColor(Color.WHITE);
			t.addCell(c07);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs10 = new PdfPCell(myPhrase);
			cs10.setBorder(Rectangle.NO_BORDER);
			cs10.setBackgroundColor(Color.WHITE);
			t.addCell(cs10);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs11 = new PdfPCell(myPhrase);
			cs11.setBorder(Rectangle.NO_BORDER);
			cs11.setBackgroundColor(Color.WHITE);
			t.addCell(cs11);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			if (((permitType.equals("Rom Transit") || permitType.equals("Rom Sale")) && srcType.equalsIgnoreCase("E-Wallet")) || permitType.equals("Bauxite Transit")) {

				if (permitType.equals("Bauxite Transit")) {
					myPhrase1 = new Phrase("        Bauxite Challan No  ",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c12 = new PdfPCell(myPhrase1);
					c12.setBorder(Rectangle.NO_BORDER);
					c12.setBackgroundColor(Color.WHITE);
					t.addCell(c12);
				} else {
					myPhrase1 = new Phrase("        E-Wallet Challan No  ",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c12 = new PdfPCell(myPhrase1);
					c12.setBorder(Rectangle.NO_BORDER);
					c12.setBackgroundColor(Color.WHITE);
					t.addCell(c12);
				}

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd12 = new PdfPCell(myPhrase1);
				cd12.setBorder(Rectangle.NO_BORDER);
				cd12.setBackgroundColor(Color.WHITE);
				t.addCell(cd12);

				myPhrase = new Phrase(challanNo, new Font(baseFont, font,Font.BOLD));
				PdfPCell c13 = new PdfPCell(myPhrase);
				c13.setBorder(Rectangle.NO_BORDER);
				c13.setBackgroundColor(Color.WHITE);
				t.addCell(c13);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs16 = new PdfPCell(myPhrase);
				cs16.setBorder(Rectangle.NO_BORDER);
				cs16.setBackgroundColor(Color.WHITE);
				t.addCell(cs16);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs17 = new PdfPCell(myPhrase);
				cs17.setBorder(Rectangle.NO_BORDER);
				cs17.setBackgroundColor(Color.WHITE);
				t.addCell(cs17);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

			}
			if (!permitType.equals("Bauxite Transit")) {
				if (!permitType.equals("Rom Transit") && !permitType.equals("Purchased Rom Sale Transit Permit") && !permitType.equals("Rom Sale")) {
					myPhrase1 = new Phrase("        Grade Quantity (Fines)  ",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c14 = new PdfPCell(myPhrase1);
					c14.setBackgroundColor(Color.WHITE);
					c14.setBorder(Rectangle.NO_BORDER);
					t.addCell(c14);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cd14 = new PdfPCell(myPhrase1);
					cd14.setBackgroundColor(Color.WHITE);
					cd14.setBorder(Rectangle.NO_BORDER);
					t.addCell(cd14);

					if (gradeFines != null && !gradeFines.equals("")) {
						myPhrase = new Phrase(gradeQtyfines + " Tons" + "  "+ "(" + gradeFines + ")", new Font(baseFont,font, Font.BOLD));
						PdfPCell c177 = new PdfPCell(myPhrase);
						c177.setBorder(Rectangle.NO_BORDER);
						c177.setBackgroundColor(Color.WHITE);
						t.addCell(c177);
					} else {
						myPhrase = new Phrase(gradeQtyfines!=null?gradeQtyfines:0 + " Tons",new Font(baseFont, font, Font.BOLD));
						PdfPCell c177 = new PdfPCell(myPhrase);
						c177.setBorder(Rectangle.NO_BORDER);
						c177.setBackgroundColor(Color.WHITE);
						t.addCell(c177);
					}

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs107 = new PdfPCell(myPhrase);
					cs107.setBorder(Rectangle.NO_BORDER);
					cs107.setBackgroundColor(Color.WHITE);
					t.addCell(cs107);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs18 = new PdfPCell(myPhrase);
					cs18.setBorder(Rectangle.NO_BORDER);
					cs18.setBackgroundColor(Color.WHITE);
					t.addCell(cs18);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase1 = new Phrase("        Grade Quantity (Lumps)  ",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c16 = new PdfPCell(myPhrase1);
					c16.setBorder(Rectangle.NO_BORDER);
					c16.setBackgroundColor(Color.WHITE);
					t.addCell(c16);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cd16 = new PdfPCell(myPhrase1);
					cd16.setBorder(Rectangle.NO_BORDER);
					cd16.setBackgroundColor(Color.WHITE);
					t.addCell(cd16);

					if (gradeLumps != null && !gradeLumps.equals("")) {
						myPhrase = new Phrase(gradeQtylump + " Tons" + "  "+ "(" + gradeLumps + ")", new Font(baseFont,font, Font.BOLD));
						PdfPCell c17 = new PdfPCell(myPhrase);
						c17.setBorder(Rectangle.NO_BORDER);
						c17.setBackgroundColor(Color.WHITE);
						t.addCell(c17);
					} else {
						myPhrase = new Phrase(gradeQtylump!=null?gradeQtylump:0 + " Tons", new Font(baseFont, font, Font.BOLD));
						PdfPCell c17 = new PdfPCell(myPhrase);
						c17.setBorder(Rectangle.NO_BORDER);
						c17.setBackgroundColor(Color.WHITE);
						t.addCell(c17);
					}

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs19 = new PdfPCell(myPhrase);
					cs19.setBorder(Rectangle.NO_BORDER);
					cs19.setBackgroundColor(Color.WHITE);
					t.addCell(cs19);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs20 = new PdfPCell(myPhrase);
					cs20.setBorder(Rectangle.NO_BORDER);
					cs20.setBackgroundColor(Color.WHITE);
					t.addCell(cs20);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);
					
					myPhrase1 = new Phrase("        Grade Quantity (Concentrates)  ",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c14c = new PdfPCell(myPhrase1);
					c14c.setBackgroundColor(Color.WHITE);
					c14c.setBorder(Rectangle.NO_BORDER);
					t.addCell(c14c);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cd14c = new PdfPCell(myPhrase1);
					cd14c.setBackgroundColor(Color.WHITE);
					cd14c.setBorder(Rectangle.NO_BORDER);
					t.addCell(cd14c);

					if (gradeConc != null && !gradeConc.equals("")) {
						myPhrase = new Phrase(gradeQtyConc + " Tons" + "  "+ "(" + gradeConc + ")", new Font(baseFont,font, Font.BOLD));
						PdfPCell c177c = new PdfPCell(myPhrase);
						c177c.setBorder(Rectangle.NO_BORDER);
						c177c.setBackgroundColor(Color.WHITE);
						t.addCell(c177c);
					} else {
						myPhrase = new Phrase(gradeQtyConc!=null?gradeQtyConc:0 + " Tons",new Font(baseFont, font, Font.BOLD));
						PdfPCell c177c = new PdfPCell(myPhrase);
						c177c.setBorder(Rectangle.NO_BORDER);
						c177c.setBackgroundColor(Color.WHITE);
						t.addCell(c177c);
					}

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);
					
					myPhrase1 = new Phrase("        Grade Quantity (Tailings)  ",new Font(baseFont, font, Font.NORMAL));
					PdfPCell c14t = new PdfPCell(myPhrase1);
					c14t.setBackgroundColor(Color.WHITE);
					c14t.setBorder(Rectangle.NO_BORDER);
					t.addCell(c14t);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cd14t = new PdfPCell(myPhrase1);
					cd14t.setBackgroundColor(Color.WHITE);
					cd14t.setBorder(Rectangle.NO_BORDER);
					t.addCell(cd14t);

					if (gradeTailings != null && !gradeTailings.equals("")) {
						myPhrase = new Phrase(gradeQtyTailings + " Tons" + "  "+ "(" + gradeTailings + ")", new Font(baseFont,font, Font.BOLD));
						PdfPCell c177c = new PdfPCell(myPhrase);
						c177c.setBorder(Rectangle.NO_BORDER);
						c177c.setBackgroundColor(Color.WHITE);
						t.addCell(c177c);
					} else {
						myPhrase = new Phrase(gradeQtyTailings!=null?gradeQtyTailings:0 + " Tons",new Font(baseFont, font, Font.BOLD));
						PdfPCell c177c = new PdfPCell(myPhrase);
						c177c.setBorder(Rectangle.NO_BORDER);
						c177c.setBackgroundColor(Color.WHITE);
						t.addCell(c177c);
					}

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);
				}

				myPhrase1 = new Phrase("        Grade Quantity (ROM)  ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c148 = new PdfPCell(myPhrase1);
				c148.setBackgroundColor(Color.WHITE);
				c148.setBorder(Rectangle.NO_BORDER);
				t.addCell(c148);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd1448 = new PdfPCell(myPhrase1);
				cd1448.setBackgroundColor(Color.WHITE);
				cd1448.setBorder(Rectangle.NO_BORDER);
				t.addCell(cd1448);

				if (graderom != null && !graderom.equals("")) {
					myPhrase = new Phrase(gradeQtyrom + " Tons" + "  " + "("+ graderom + ")", new Font(baseFont, font,Font.BOLD));
					PdfPCell c177 = new PdfPCell(myPhrase);
					c177.setBorder(Rectangle.NO_BORDER);
					c177.setBackgroundColor(Color.WHITE);
					t.addCell(c177);
				} else {
					myPhrase = new Phrase(gradeQtyrom!=null?gradeQtyrom:0 + " Tons", new Font(baseFont, font, Font.BOLD));
					PdfPCell c177 = new PdfPCell(myPhrase);
					c177.setBorder(Rectangle.NO_BORDER);
					c177.setBackgroundColor(Color.WHITE);
					t.addCell(c177);
				}

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs1073 = new PdfPCell(myPhrase);
				cs1073.setBorder(Rectangle.NO_BORDER);
				cs1073.setBackgroundColor(Color.WHITE);
				t.addCell(cs1073);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs183 = new PdfPCell(myPhrase);
				cs183.setBorder(Rectangle.NO_BORDER);
				cs183.setBackgroundColor(Color.WHITE);
				t.addCell(cs183);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);
				
				
			}

			myPhrase1 = new Phrase("        Total Quantity  ", new Font(baseFont, font, Font.NORMAL));
			PdfPCell c18 = new PdfPCell(myPhrase1);
			c18.setBorder(Rectangle.NO_BORDER);
			c18.setBackgroundColor(Color.WHITE);
			t.addCell(c18);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell cd18 = new PdfPCell(myPhrase1);
			cd18.setBorder(Rectangle.NO_BORDER);
			cd18.setBackgroundColor(Color.WHITE);
			t.addCell(cd18);

			myPhrase = new Phrase(totalQty + " Tons", new Font(baseFont, font,Font.BOLD));
			PdfPCell c19 = new PdfPCell(myPhrase);
			c19.setBorder(Rectangle.NO_BORDER);
			c19.setBackgroundColor(Color.WHITE);
			t.addCell(c19);

			if (totalProFee != null) {
				myPhrase1 = new Phrase(" ", new Font(baseFont, font,Font.NORMAL));
				PdfPCell cn18 = new PdfPCell(myPhrase1);
				cn18.setColspan(3);
				cn18.setBorder(Rectangle.NO_BORDER);
				cn18.setBackgroundColor(Color.WHITE);
				t.addCell(cn18);

				myPhrase1 = new Phrase("        Total Processing Fee  ",new Font(baseFont, font, Font.NORMAL));
				cn18 = new PdfPCell(myPhrase1);
				cn18.setBorder(Rectangle.NO_BORDER);
				cn18.setBackgroundColor(Color.WHITE);
				t.addCell(cn18);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cnd18 = new PdfPCell(myPhrase1);
				cnd18.setBorder(Rectangle.NO_BORDER);
				cnd18.setBackgroundColor(Color.WHITE);
				t.addCell(cnd18);

				myPhrase = new Phrase("Rs. " + totalProFee, new Font(baseFont,font, Font.BOLD));
				PdfPCell cn19 = new PdfPCell(myPhrase);
				cn19.setBorder(Rectangle.NO_BORDER);
				cn19.setBackgroundColor(Color.WHITE);
				t.addCell(cn19);
			}

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs21 = new PdfPCell(myPhrase);
			cs21.setBorder(Rectangle.NO_BORDER);
			cs21.setBackgroundColor(Color.WHITE);
			t.addCell(cs21);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs22 = new PdfPCell(myPhrase);
			cs22.setBorder(Rectangle.NO_BORDER);
			cs22.setBackgroundColor(Color.WHITE);
			t.addCell(cs22);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			if (((permitType.equals("Rom Transit") || permitType.equals("Rom Sale") )&& srcType.equalsIgnoreCase("E-Wallet"))|| permitType.equals("Bauxite Transit")) {

				myPhrase1 = new Phrase("        Royalty Paid  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c20 = new PdfPCell(myPhrase1);
				c20.setBorder(Rectangle.NO_BORDER);
				c20.setBackgroundColor(Color.WHITE);
				t.addCell(c20);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd20 = new PdfPCell(myPhrase1);
				cd20.setBorder(Rectangle.NO_BORDER);
				cd20.setBackgroundColor(Color.WHITE);
				t.addCell(cd20);

				myPhrase = new Phrase("Rs. " + royalityPaid, new Font(baseFont,font, Font.BOLD));
				PdfPCell c21 = new PdfPCell(myPhrase);
				c21.setBorder(Rectangle.NO_BORDER);
				c21.setBackgroundColor(Color.WHITE);
				t.addCell(c21);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs23 = new PdfPCell(myPhrase);
				cs23.setBorder(Rectangle.NO_BORDER);
				cs23.setBackgroundColor(Color.WHITE);
				t.addCell(cs23);

				myPhrase = new Phrase(" ",new Font(baseFont, fontsc, Font.BOLD));
				PdfPCell cs24 = new PdfPCell(myPhrase);
				cs24.setBorder(Rectangle.NO_BORDER);
				cs24.setBackgroundColor(Color.WHITE);
				t.addCell(cs24);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Processing Fee   ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c27 = new PdfPCell(myPhrase1);
				c27.setBorder(Rectangle.NO_BORDER);
				c27.setBackgroundColor(Color.WHITE);
				t.addCell(c27);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd27 = new PdfPCell(myPhrase1);
				cd27.setBorder(Rectangle.NO_BORDER);
				cd27.setBackgroundColor(Color.WHITE);
				t.addCell(cd27);

				myPhrase = new Phrase("Rs. " + permitProcessingFee, new Font(baseFont, font, Font.BOLD));
				PdfPCell c028 = new PdfPCell(myPhrase);
				c028.setBorder(Rectangle.NO_BORDER);
				c028.setBackgroundColor(Color.WHITE);
				t.addCell(c028);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs238 = new PdfPCell(myPhrase);
				cs238.setBorder(Rectangle.NO_BORDER);
				cs238.setBackgroundColor(Color.WHITE);
				t.addCell(cs238);

				myPhrase = new Phrase(" ",new Font(baseFont, fontsc, Font.BOLD));
				PdfPCell cs248 = new PdfPCell(myPhrase);
				cs248.setBorder(Rectangle.NO_BORDER);
				cs248.setBackgroundColor(Color.WHITE);
				t.addCell(cs24);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

			}
			if (permitType.equals("Processed Ore Sale")|| permitType.equals("Rom Sale")) {
				myPhrase1 = new Phrase("        Source Hub  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c020 = new PdfPCell(myPhrase1);
				c020.setBorder(Rectangle.NO_BORDER);
				c020.setBackgroundColor(Color.WHITE);
				t.addCell(c020);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd020 = new PdfPCell(myPhrase1);
				cd020.setBorder(Rectangle.NO_BORDER);
				cd020.setBackgroundColor(Color.WHITE);
				t.addCell(cd020);

				myPhrase = new Phrase(loc, new Font(baseFont, font, Font.BOLD));
				PdfPCell c021 = new PdfPCell(myPhrase);
				c021.setBorder(Rectangle.NO_BORDER);
				c021.setBackgroundColor(Color.WHITE);
				t.addCell(c021);

			} else {
				myPhrase1 = new Phrase("        Route ID  ", new Font(baseFont,font, Font.NORMAL));
				PdfPCell c020 = new PdfPCell(myPhrase1);
				c020.setBorder(Rectangle.NO_BORDER);
				c020.setBackgroundColor(Color.WHITE);
				t.addCell(c020);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd020 = new PdfPCell(myPhrase1);
				cd020.setBorder(Rectangle.NO_BORDER);
				cd020.setBackgroundColor(Color.WHITE);
				t.addCell(cd020);

				myPhrase = new Phrase(routeId, new Font(baseFont, font,Font.NORMAL));
				PdfPCell c021 = new PdfPCell(myPhrase);
				c021.setBorder(Rectangle.NO_BORDER);
				c021.setBackgroundColor(Color.WHITE);
				t.addCell(c021);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs25 = new PdfPCell(myPhrase);
				cs25.setBorder(Rectangle.NO_BORDER);
				cs25.setBackgroundColor(Color.WHITE);
				t.addCell(cs25);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs26 = new PdfPCell(myPhrase);
				cs26.setBorder(Rectangle.NO_BORDER);
				cs26.setBackgroundColor(Color.WHITE);
				t.addCell(cs26);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Source Location     ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c23 = new PdfPCell(myPhrase1);
				c23.setBorder(Rectangle.NO_BORDER);
				c23.setBackgroundColor(Color.WHITE);
				t.addCell(c23);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd23 = new PdfPCell(myPhrase1);
				cd23.setBorder(Rectangle.NO_BORDER);
				cd23.setBackgroundColor(Color.WHITE);
				t.addCell(cd23);

				myPhrase = new Phrase(loc, new Font(baseFont, font, Font.BOLD));
				PdfPCell c24 = new PdfPCell(myPhrase);
				c24.setBorder(Rectangle.NO_BORDER);
				c24.setBackgroundColor(Color.WHITE);
				t.addCell(c24);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs27 = new PdfPCell(myPhrase);
				cs27.setBorder(Rectangle.NO_BORDER);
				cs27.setBackgroundColor(Color.WHITE);
				t.addCell(cs27);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs28 = new PdfPCell(myPhrase);
				cs28.setBorder(Rectangle.NO_BORDER);
				cs28.setBackgroundColor(Color.WHITE);
				t.addCell(cs28);

				myPhrase1 = new Phrase("        Destination Location  ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c25 = new PdfPCell(myPhrase1);
				c25.setBorder(Rectangle.NO_BORDER);
				c25.setBackgroundColor(Color.WHITE);
				t.addCell(c25);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd25 = new PdfPCell(myPhrase1);
				cd25.setBorder(Rectangle.NO_BORDER);
				cd25.setBackgroundColor(Color.WHITE);
				t.addCell(cd25);

				myPhrase = new Phrase(destLocation, new Font(baseFont, font,Font.BOLD));
				PdfPCell c26 = new PdfPCell(myPhrase);
				c26.setBorder(Rectangle.NO_BORDER);
				c26.setBackgroundColor(Color.WHITE);
				t.addCell(c26);

			}
			if (permitType.equals("Domestic Export")) {

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Buyer Name  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c250 = new PdfPCell(myPhrase1);
				c250.setBorder(Rectangle.NO_BORDER);
				c250.setBackgroundColor(Color.WHITE);
				t.addCell(c250);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd251 = new PdfPCell(myPhrase1);
				cd251.setBorder(Rectangle.NO_BORDER);
				cd251.setBackgroundColor(Color.WHITE);
				t.addCell(cd251);

				myPhrase = new Phrase(buyerName, new Font(baseFont, font,Font.BOLD));
				PdfPCell c262 = new PdfPCell(myPhrase);
				c262.setBorder(Rectangle.NO_BORDER);
				c262.setBackgroundColor(Color.WHITE);
				t.addCell(c262);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs293 = new PdfPCell(myPhrase);
				cs293.setBorder(Rectangle.NO_BORDER);
				cs293.setBackgroundColor(Color.WHITE);
				t.addCell(cs293);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs301 = new PdfPCell(myPhrase);
				cs301.setBorder(Rectangle.NO_BORDER);
				cs301.setBackgroundColor(Color.WHITE);
				t.addCell(cs301);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        State Name  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c2501 = new PdfPCell(myPhrase1);
				c2501.setBorder(Rectangle.NO_BORDER);
				c2501.setBackgroundColor(Color.WHITE);
				t.addCell(c2501);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd2511 = new PdfPCell(myPhrase1);
				cd2511.setBorder(Rectangle.NO_BORDER);
				cd2511.setBackgroundColor(Color.WHITE);
				t.addCell(cd2511);

				myPhrase = new Phrase(stateName, new Font(baseFont, font,Font.BOLD));
				PdfPCell c2621 = new PdfPCell(myPhrase);
				c2621.setBorder(Rectangle.NO_BORDER);
				c2621.setBackgroundColor(Color.WHITE);
				t.addCell(c2621);

			}
			if (permitType.equals("International Export")) {

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Buyer Name  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c250 = new PdfPCell(myPhrase1);
				c250.setBorder(Rectangle.NO_BORDER);
				c250.setBackgroundColor(Color.WHITE);
				t.addCell(c250);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd251 = new PdfPCell(myPhrase1);
				cd251.setBorder(Rectangle.NO_BORDER);
				cd251.setBackgroundColor(Color.WHITE);
				t.addCell(cd251);

				myPhrase = new Phrase(buyerName, new Font(baseFont, font,Font.BOLD));
				PdfPCell c262 = new PdfPCell(myPhrase);
				c262.setBorder(Rectangle.NO_BORDER);
				c262.setBackgroundColor(Color.WHITE);
				t.addCell(c262);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs293 = new PdfPCell(myPhrase);
				cs293.setBorder(Rectangle.NO_BORDER);
				cs293.setBackgroundColor(Color.WHITE);
				t.addCell(cs293);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs301 = new PdfPCell(myPhrase);
				cs301.setBorder(Rectangle.NO_BORDER);
				cs301.setBackgroundColor(Color.WHITE);
				t.addCell(cs301);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Country Name  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c2501 = new PdfPCell(myPhrase1);
				c2501.setBorder(Rectangle.NO_BORDER);
				c2501.setBackgroundColor(Color.WHITE);
				t.addCell(c2501);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd2511 = new PdfPCell(myPhrase1);
				cd2511.setBorder(Rectangle.NO_BORDER);
				cd2511.setBackgroundColor(Color.WHITE);
				t.addCell(cd2511);

				myPhrase = new Phrase(countryName, new Font(baseFont, font,Font.BOLD));
				PdfPCell c2621 = new PdfPCell(myPhrase);
				c2621.setBorder(Rectangle.NO_BORDER);
				c2621.setBackgroundColor(Color.WHITE);
				t.addCell(c2621);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Vessel Name  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c25011 = new PdfPCell(myPhrase1);
				c25011.setBorder(Rectangle.NO_BORDER);
				c25011.setBackgroundColor(Color.WHITE);
				t.addCell(c25011);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd25111 = new PdfPCell(myPhrase1);
				cd25111.setBorder(Rectangle.NO_BORDER);
				cd25111.setBackgroundColor(Color.WHITE);
				t.addCell(cd25111);

				myPhrase = new Phrase(shipName, new Font(baseFont, font,Font.BOLD));
				PdfPCell c26211 = new PdfPCell(myPhrase);
				c26211.setBorder(Rectangle.NO_BORDER);
				c26211.setBackgroundColor(Color.WHITE);
				t.addCell(c26211);

			}
			if (permitType.equals("Import Permit")) {
				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Vessel Name  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c250 = new PdfPCell(myPhrase1);
				c250.setBorder(Rectangle.NO_BORDER);
				c250.setBackgroundColor(Color.WHITE);
				t.addCell(c250);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd251 = new PdfPCell(myPhrase1);
				cd251.setBorder(Rectangle.NO_BORDER);
				cd251.setBackgroundColor(Color.WHITE);
				t.addCell(cd251);

				myPhrase = new Phrase(vesselName, new Font(baseFont, font,Font.BOLD));
				PdfPCell c262 = new PdfPCell(myPhrase);
				c262.setBorder(Rectangle.NO_BORDER);
				c262.setBackgroundColor(Color.WHITE);
				t.addCell(c262);
				// --------------------
				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Purpose Of Import  ", new Font(baseFont, font, Font.NORMAL));
				c250 = new PdfPCell(myPhrase1);
				c250.setBorder(Rectangle.NO_BORDER);
				c250.setBackgroundColor(Color.WHITE);
				t.addCell(c250);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				cd251 = new PdfPCell(myPhrase1);
				cd251.setBorder(Rectangle.NO_BORDER);
				cd251.setBackgroundColor(Color.WHITE);
				t.addCell(cd251);

				myPhrase = new Phrase(importPurpose, new Font(baseFont, font,Font.BOLD));
				c262 = new PdfPCell(myPhrase);
				c262.setBorder(Rectangle.NO_BORDER);
				c262.setBackgroundColor(Color.WHITE);
				t.addCell(c262);
			}
			if (importType.equals("Domestic Import")&& permitType.equals("Import Permit")) {

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs293 = new PdfPCell(myPhrase);
				cs293.setBorder(Rectangle.NO_BORDER);
				cs293.setBackgroundColor(Color.WHITE);
				t.addCell(cs293);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				PdfPCell cs301 = new PdfPCell(myPhrase);
				cs301.setBorder(Rectangle.NO_BORDER);
				cs301.setBackgroundColor(Color.WHITE);
				t.addCell(cs301);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        State Name  ", new Font(
						baseFont, font, Font.NORMAL));
				PdfPCell c2501 = new PdfPCell(myPhrase1);
				c2501.setBorder(Rectangle.NO_BORDER);
				c2501.setBackgroundColor(Color.WHITE);
				t.addCell(c2501);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd2511 = new PdfPCell(myPhrase1);
				cd2511.setBorder(Rectangle.NO_BORDER);
				cd2511.setBackgroundColor(Color.WHITE);
				t.addCell(cd2511);

				myPhrase = new Phrase(stateName, new Font(baseFont, font,
						Font.BOLD));
				PdfPCell c2621 = new PdfPCell(myPhrase);
				c2621.setBorder(Rectangle.NO_BORDER);
				c2621.setBackgroundColor(Color.WHITE);
				t.addCell(c2621);

			}
			if (importType.equals("International Import")
					&& permitType.equals("Import Permit")) {

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				PdfPCell cs293 = new PdfPCell(myPhrase);
				cs293.setBorder(Rectangle.NO_BORDER);
				cs293.setBackgroundColor(Color.WHITE);
				t.addCell(cs293);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				PdfPCell cs301 = new PdfPCell(myPhrase);
				cs301.setBorder(Rectangle.NO_BORDER);
				cs301.setBackgroundColor(Color.WHITE);
				t.addCell(cs301);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Country Name  ", new Font(
						baseFont, font, Font.NORMAL));
				PdfPCell c2501 = new PdfPCell(myPhrase1);
				c2501.setBorder(Rectangle.NO_BORDER);
				c2501.setBackgroundColor(Color.WHITE);
				t.addCell(c2501);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd2511 = new PdfPCell(myPhrase1);
				cd2511.setBorder(Rectangle.NO_BORDER);
				cd2511.setBackgroundColor(Color.WHITE);
				t.addCell(cd2511);

				myPhrase = new Phrase(countryName, new Font(baseFont, font,
						Font.BOLD));
				PdfPCell c2621 = new PdfPCell(myPhrase);
				c2621.setBorder(Rectangle.NO_BORDER);
				c2621.setBackgroundColor(Color.WHITE);
				t.addCell(c2621);

			}
			if (permitType.equals("Import Transit Permit")) {

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Vessel Name  ", new Font(
						baseFont, font, Font.NORMAL));
				PdfPCell c250 = new PdfPCell(myPhrase1);
				c250.setBorder(Rectangle.NO_BORDER);
				c250.setBackgroundColor(Color.WHITE);
				t.addCell(c250);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd251 = new PdfPCell(myPhrase1);
				cd251.setBorder(Rectangle.NO_BORDER);
				cd251.setBackgroundColor(Color.WHITE);
				t.addCell(cd251);

				myPhrase = new Phrase(vesselName, new Font(baseFont, font,
						Font.BOLD));
				PdfPCell c262 = new PdfPCell(myPhrase);
				c262.setBorder(Rectangle.NO_BORDER);
				c262.setBackgroundColor(Color.WHITE);
				t.addCell(c262);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				PdfPCell cs293 = new PdfPCell(myPhrase);
				cs293.setBorder(Rectangle.NO_BORDER);
				cs293.setBackgroundColor(Color.WHITE);
				t.addCell(cs293);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				PdfPCell cs301 = new PdfPCell(myPhrase);
				cs301.setBorder(Rectangle.NO_BORDER);
				cs301.setBackgroundColor(Color.WHITE);
				t.addCell(cs301);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Imported Permit No   ",
						new Font(baseFont, font, Font.NORMAL));
				PdfPCell c2501 = new PdfPCell(myPhrase1);
				c2501.setBorder(Rectangle.NO_BORDER);
				c2501.setBackgroundColor(Color.WHITE);
				t.addCell(c2501);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd2511 = new PdfPCell(myPhrase1);
				cd2511.setBorder(Rectangle.NO_BORDER);
				cd2511.setBackgroundColor(Color.WHITE);
				t.addCell(cd2511);

				myPhrase = new Phrase(existingPermitNo, new Font(baseFont,
						font, Font.BOLD));
				PdfPCell c2621 = new PdfPCell(myPhrase);
				c2621.setBorder(Rectangle.NO_BORDER);
				c2621.setBackgroundColor(Color.WHITE);
				t.addCell(c2621);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Export Permit No  ", new Font(
						baseFont, font, Font.NORMAL));
				PdfPCell c25011 = new PdfPCell(myPhrase1);
				c25011.setBorder(Rectangle.NO_BORDER);
				c25011.setBackgroundColor(Color.WHITE);
				t.addCell(c25011);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd25111 = new PdfPCell(myPhrase1);
				cd25111.setBorder(Rectangle.NO_BORDER);
				cd25111.setBackgroundColor(Color.WHITE);
				t.addCell(cd25111);

				myPhrase = new Phrase(exportPermitNo, new Font(baseFont, font,
						Font.BOLD));
				PdfPCell c26211 = new PdfPCell(myPhrase);
				c26211.setBorder(Rectangle.NO_BORDER);
				c26211.setBackgroundColor(Color.WHITE);
				t.addCell(c26211);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Export Permit Date  ",
						new Font(baseFont, font, Font.NORMAL));
				PdfPCell c254011 = new PdfPCell(myPhrase1);
				c254011.setBorder(Rectangle.NO_BORDER);
				c254011.setBackgroundColor(Color.WHITE);
				t.addCell(c254011);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd254111 = new PdfPCell(myPhrase1);
				cd254111.setBorder(Rectangle.NO_BORDER);
				cd254111.setBackgroundColor(Color.WHITE);
				t.addCell(cd254111);

				myPhrase = new Phrase(exportPermitDate, new Font(baseFont,
						font, Font.BOLD));
				PdfPCell c262411 = new PdfPCell(myPhrase);
				c262411.setBorder(Rectangle.NO_BORDER);
				c262411.setBackgroundColor(Color.WHITE);
				t.addCell(c262411);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,
						Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Export Challan No  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell cfr = new PdfPCell(myPhrase1);
				cfr.setBorder(Rectangle.NO_BORDER);
				cfr.setBackgroundColor(Color.WHITE);
				t.addCell(cfr);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd = new PdfPCell(myPhrase1);
				cd.setBorder(Rectangle.NO_BORDER);
				cd.setBackgroundColor(Color.WHITE);
				t.addCell(cd);

				myPhrase = new Phrase(exportChallanNo, new Font(baseFont, font,Font.BOLD));
				PdfPCell ck23 = new PdfPCell(myPhrase);
				ck23.setBorder(Rectangle.NO_BORDER);
				ck23.setBackgroundColor(Color.WHITE);
				t.addCell(ck23);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Export Challan Date  ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cfr1 = new PdfPCell(myPhrase1);
				cfr1.setBorder(Rectangle.NO_BORDER);
				cfr1.setBackgroundColor(Color.WHITE);
				t.addCell(cfr1);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd31 = new PdfPCell(myPhrase1);
				cd31.setBorder(Rectangle.NO_BORDER);
				cd31.setBackgroundColor(Color.WHITE);
				t.addCell(cd31);

				myPhrase = new Phrase(exportChallanDate, new Font(baseFont,font, Font.BOLD));
				PdfPCell ck231 = new PdfPCell(myPhrase);
				ck231.setBorder(Rectangle.NO_BORDER);
				ck231.setBackgroundColor(Color.WHITE);
				t.addCell(ck231);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Sale Invoice No  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell cfr11 = new PdfPCell(myPhrase1);
				cfr11.setBorder(Rectangle.NO_BORDER);
				cfr11.setBackgroundColor(Color.WHITE);
				t.addCell(cfr11);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd311 = new PdfPCell(myPhrase1);
				cd311.setBorder(Rectangle.NO_BORDER);
				cd311.setBackgroundColor(Color.WHITE);
				t.addCell(cd311);

				myPhrase = new Phrase(invoiceNo, new Font(baseFont, font,Font.BOLD));
				PdfPCell ck2311 = new PdfPCell(myPhrase);
				ck2311.setBorder(Rectangle.NO_BORDER);
				ck2311.setBackgroundColor(Color.WHITE);
				t.addCell(ck2311);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Sale Invoice Date  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell cfr21 = new PdfPCell(myPhrase1);
				cfr21.setBorder(Rectangle.NO_BORDER);
				cfr21.setBackgroundColor(Color.WHITE);
				t.addCell(cfr21);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd321 = new PdfPCell(myPhrase1);
				cd321.setBorder(Rectangle.NO_BORDER);
				cd321.setBackgroundColor(Color.WHITE);
				t.addCell(cd321);

				myPhrase = new Phrase(invoiceDate, new Font(baseFont, font,Font.BOLD));
				PdfPCell ck2231 = new PdfPCell(myPhrase);
				ck2231.setBorder(Rectangle.NO_BORDER);
				ck2231.setBackgroundColor(Color.WHITE);
				t.addCell(ck2231);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Transportation Type  ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell cf3r21 = new PdfPCell(myPhrase1);
				cf3r21.setBorder(Rectangle.NO_BORDER);
				cf3r21.setBackgroundColor(Color.WHITE);
				t.addCell(cf3r21);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd3321 = new PdfPCell(myPhrase1);
				cd3321.setBorder(Rectangle.NO_BORDER);
				cd3321.setBackgroundColor(Color.WHITE);
				t.addCell(cd3321);

				myPhrase = new Phrase(transportnType, new Font(baseFont, font,Font.BOLD));
				PdfPCell ck23231 = new PdfPCell(myPhrase);
				ck23231.setBorder(Rectangle.NO_BORDER);
				ck23231.setBackgroundColor(Color.WHITE);
				t.addCell(ck23231);

			}
			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs29 = new PdfPCell(myPhrase);
			cs29.setBorder(Rectangle.NO_BORDER);
			cs29.setBackgroundColor(Color.WHITE);
			t.addCell(cs29);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs30 = new PdfPCell(myPhrase);
			cs30.setBorder(Rectangle.NO_BORDER);
			cs30.setBackgroundColor(Color.WHITE);
			t.addCell(cs30);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase1 = new Phrase("        Permit Validity  ", new Font(baseFont, font, Font.NORMAL));
			PdfPCell c025 = new PdfPCell(myPhrase1);
			c025.setBorder(Rectangle.NO_BORDER);
			c025.setBackgroundColor(Color.WHITE);
			t.addCell(c025);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell cd025 = new PdfPCell(myPhrase1);
			cd025.setBorder(Rectangle.NO_BORDER);
			cd025.setBackgroundColor(Color.WHITE);
			t.addCell(cd025);

			myPhrase = new Phrase(permitValidity, new Font(baseFont, font,Font.NORMAL));
			PdfPCell c026 = new PdfPCell(myPhrase);
			c026.setBorder(Rectangle.NO_BORDER);
			c026.setBackgroundColor(Color.WHITE);
			t.addCell(c026);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs296 = new PdfPCell(myPhrase);
			cs296.setBorder(Rectangle.NO_BORDER);
			cs296.setBackgroundColor(Color.WHITE);
			t.addCell(cs296);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs306 = new PdfPCell(myPhrase);
			cs306.setBorder(Rectangle.NO_BORDER);
			cs306.setBackgroundColor(Color.WHITE);
			t.addCell(cs306);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase1 = new Phrase("        Remarks  ", new Font(baseFont,font, Font.NORMAL));
			PdfPCell c0256 = new PdfPCell(myPhrase1);
			c0256.setBorder(Rectangle.NO_BORDER);
			c0256.setBackgroundColor(Color.WHITE);
			t.addCell(c0256);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell cd0256 = new PdfPCell(myPhrase1);
			cd0256.setBorder(Rectangle.NO_BORDER);
			cd0256.setBackgroundColor(Color.WHITE);
			t.addCell(cd0256);

			myPhrase = new Phrase(remarks,new Font(baseFont, font, Font.NORMAL));
			PdfPCell c0266 = new PdfPCell(myPhrase);
			c0266.setBorder(Rectangle.NO_BORDER);
			c0266.setBackgroundColor(Color.WHITE);
			t.addCell(c0266);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs31 = new PdfPCell(myPhrase);
			cs31.setBorder(Rectangle.NO_BORDER);
			cs31.setBackgroundColor(Color.WHITE);
			t.addCell(cs31);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			PdfPCell cs32 = new PdfPCell(myPhrase);
			cs32.setBorder(Rectangle.NO_BORDER);
			cs32.setBackgroundColor(Color.WHITE);
			t.addCell(cs32);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);
			
			myPhrase1 = new Phrase("        GST No  ", new Font(baseFont,font, Font.NORMAL));
			PdfPCell cgst = new PdfPCell(myPhrase1);
			cgst.setBorder(Rectangle.NO_BORDER);
			cgst.setBackgroundColor(Color.WHITE);
			t.addCell(cgst);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell cgst1 = new PdfPCell(myPhrase1);
			cgst1.setBorder(Rectangle.NO_BORDER);
			cgst1.setBackgroundColor(Color.WHITE);
			t.addCell(cgst1);

			myPhrase = new Phrase(gstNo,new Font(baseFont, font, Font.NORMAL));
			PdfPCell cgst2 = new PdfPCell(myPhrase);
			cgst2.setBorder(Rectangle.NO_BORDER);
			cgst2.setBackgroundColor(Color.WHITE);
			t.addCell(cgst2);
			
			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase1 = new Phrase("        IBM Trader No  ", new Font(baseFont,font, Font.NORMAL));
			PdfPCell ci = new PdfPCell(myPhrase1);
			ci.setBorder(Rectangle.NO_BORDER);
			ci.setBackgroundColor(Color.WHITE);
			t.addCell(ci);

			myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
			PdfPCell ci1 = new PdfPCell(myPhrase1);
			ci1.setBorder(Rectangle.NO_BORDER);
			ci1.setBackgroundColor(Color.WHITE);
			t.addCell(ci1);

			myPhrase = new Phrase(ibmAppNo,new Font(baseFont, font, Font.NORMAL));
			PdfPCell ci2 = new PdfPCell(myPhrase);
			ci2.setBorder(Rectangle.NO_BORDER);
			ci2.setBackgroundColor(Color.WHITE);
			t.addCell(ci2);
			
			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);

			myPhrase = new Phrase(" ", new Font(baseFont, fontsc, Font.NORMAL));
			cs1.setBorder(Rectangle.NO_BORDER);
			cs1.setBackgroundColor(Color.WHITE);
			t.addCell(cs1);
			
			if (permitType.equals("Rom Sale")) {

				myPhrase1 = new Phrase("        Buying Organization/Trader Name & Code   ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c250 = new PdfPCell(myPhrase1);
				c250.setBorder(Rectangle.NO_BORDER);
				c250.setBackgroundColor(Color.WHITE);
				t.addCell(c250);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd251 = new PdfPCell(myPhrase1);
				cd251.setBorder(Rectangle.NO_BORDER);
				cd251.setBackgroundColor(Color.WHITE);
				t.addCell(cd251);

				myPhrase = new Phrase(buyingOrgName + "  &  " + buyingOrgCode,new Font(baseFont, font, Font.BOLD));
				PdfPCell c262 = new PdfPCell(myPhrase);
				c262.setBorder(Rectangle.NO_BORDER);
				c262.setBackgroundColor(Color.WHITE);
				t.addCell(c262);

			}
			if (permitType.equals("Processed Ore Sale") || permitType.equals("Processed Ore Sale Transit")) {

				myPhrase1 = new Phrase("        Buying Organization/Trader Name  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c250 = new PdfPCell(myPhrase1);
				c250.setBorder(Rectangle.NO_BORDER);
				c250.setBackgroundColor(Color.WHITE);
				t.addCell(c250);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd251 = new PdfPCell(myPhrase1);
				cd251.setBorder(Rectangle.NO_BORDER);
				cd251.setBackgroundColor(Color.WHITE);
				t.addCell(cd251);

				myPhrase = new Phrase(buyingOrgName, new Font(baseFont, font,Font.BOLD));
				PdfPCell c262 = new PdfPCell(myPhrase);
				c262.setBorder(Rectangle.NO_BORDER);
				c262.setBackgroundColor(Color.WHITE);
				t.addCell(c262);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs293 = new PdfPCell(myPhrase);
				cs293.setBorder(Rectangle.NO_BORDER);
				cs293.setBackgroundColor(Color.WHITE);
				t.addCell(cs293);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs301 = new PdfPCell(myPhrase);
				cs301.setBorder(Rectangle.NO_BORDER);
				cs301.setBackgroundColor(Color.WHITE);
				t.addCell(cs301);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        Buying Organization/Trader Code  ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell c25011 = new PdfPCell(myPhrase1);
				c25011.setBorder(Rectangle.NO_BORDER);
				c25011.setBackgroundColor(Color.WHITE);
				t.addCell(c25011);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd2511 = new PdfPCell(myPhrase1);
				cd2511.setBorder(Rectangle.NO_BORDER);
				cd2511.setBackgroundColor(Color.WHITE);
				t.addCell(cd2511);

				myPhrase = new Phrase(buyingOrgCode, new Font(baseFont, font,Font.BOLD));
				PdfPCell c2621 = new PdfPCell(myPhrase);
				c2621.setBorder(Rectangle.NO_BORDER);
				c2621.setBackgroundColor(Color.WHITE);
				t.addCell(c2621);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				if (!permitType.equals("Processed Ore Sale") && !permitType.equals("Rom Sale")) {
					myPhrase1 = new Phrase("        Country Name  ", new Font(baseFont, font, Font.NORMAL));
					PdfPCell c2501 = new PdfPCell(myPhrase1);
					c2501.setBorder(Rectangle.NO_BORDER);
					c2501.setBackgroundColor(Color.WHITE);
					t.addCell(c2501);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cd25111 = new PdfPCell(myPhrase1);
					cd25111.setBorder(Rectangle.NO_BORDER);
					cd25111.setBackgroundColor(Color.WHITE);
					t.addCell(cd25111);

					myPhrase = new Phrase(countryName, new Font(baseFont, font,Font.BOLD));
					PdfPCell c26211 = new PdfPCell(myPhrase);
					c26211.setBorder(Rectangle.NO_BORDER);
					c26211.setBackgroundColor(Color.WHITE);
					t.addCell(c26211);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs290 = new PdfPCell(myPhrase);
					cs290.setBorder(Rectangle.NO_BORDER);
					cs290.setBackgroundColor(Color.WHITE);
					t.addCell(cs290);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs300 = new PdfPCell(myPhrase);
					cs300.setBorder(Rectangle.NO_BORDER);
					cs300.setBackgroundColor(Color.WHITE);
					t.addCell(cs300);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);

					myPhrase1 = new Phrase("        State Name  ", new Font(baseFont, font, Font.NORMAL));
					PdfPCell c0250 = new PdfPCell(myPhrase1);
					c0250.setBorder(Rectangle.NO_BORDER);
					c0250.setBackgroundColor(Color.WHITE);
					t.addCell(c0250);

					myPhrase1 = new Phrase(":", new Font(baseFont, font,Font.BOLD));
					PdfPCell cd0250 = new PdfPCell(myPhrase1);
					cd0250.setBorder(Rectangle.NO_BORDER);
					cd0250.setBackgroundColor(Color.WHITE);
					t.addCell(cd0250);

					myPhrase = new Phrase(stateName, new Font(baseFont, font,Font.BOLD));
					PdfPCell c0260 = new PdfPCell(myPhrase);
					c0260.setBorder(Rectangle.NO_BORDER);
					c0260.setBackgroundColor(Color.WHITE);
					t.addCell(c0260);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs310 = new PdfPCell(myPhrase);
					cs310.setBorder(Rectangle.NO_BORDER);
					cs310.setBackgroundColor(Color.WHITE);
					t.addCell(cs310);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					PdfPCell cs320 = new PdfPCell(myPhrase);
					cs320.setBorder(Rectangle.NO_BORDER);
					cs320.setBackgroundColor(Color.WHITE);
					t.addCell(cs320);

					myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
					cs1.setBorder(Rectangle.NO_BORDER);
					cs1.setBackgroundColor(Color.WHITE);
					t.addCell(cs1);
				}
			}
			if (permitType.equalsIgnoreCase("Purchased Rom Sale Transit Permit")) {

				myPhrase1 = new Phrase("        Country Name / State Name  ",new Font(baseFont, font, Font.NORMAL));
				PdfPCell c2501 = new PdfPCell(myPhrase1);
				c2501.setBorder(Rectangle.NO_BORDER);
				c2501.setBackgroundColor(Color.WHITE);
				t.addCell(c2501);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell cd25111 = new PdfPCell(myPhrase1);
				cd25111.setBorder(Rectangle.NO_BORDER);
				cd25111.setBackgroundColor(Color.WHITE);
				t.addCell(cd25111);

				myPhrase = new Phrase(countryName + "  /  " + stateName,new Font(baseFont, font, Font.BOLD));
				PdfPCell c2666211 = new PdfPCell(myPhrase);
				c2666211.setBorder(Rectangle.NO_BORDER);
				c2666211.setBackgroundColor(Color.WHITE);
				t.addCell(c2666211);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs2693 = new PdfPCell(myPhrase);
				cs2693.setBorder(Rectangle.NO_BORDER);
				cs2693.setBackgroundColor(Color.WHITE);
				t.addCell(cs2693);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				PdfPCell cs6301 = new PdfPCell(myPhrase);
				cs6301.setBorder(Rectangle.NO_BORDER);
				cs6301.setBackgroundColor(Color.WHITE);
				t.addCell(cs6301);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        RS Permit ", new Font(baseFont,font, Font.NORMAL));
				PdfPCell cc = new PdfPCell(myPhrase1);
				cc.setBorder(Rectangle.NO_BORDER);
				cc.setBackgroundColor(Color.WHITE);
				t.addCell(cc);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell czx = new PdfPCell(myPhrase1);
				czx.setBorder(Rectangle.NO_BORDER);
				czx.setBackgroundColor(Color.WHITE);
				t.addCell(czx);

				myPhrase = new Phrase(existingPermitNo, new Font(baseFont,font, Font.BOLD));
				PdfPCell css = new PdfPCell(myPhrase);
				css.setBorder(Rectangle.NO_BORDER);
				css.setBackgroundColor(Color.WHITE);
				t.addCell(css);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase1 = new Phrase("        To Location ", new Font(baseFont, font, Font.NORMAL));
				PdfPCell cc1 = new PdfPCell(myPhrase1);
				cc1.setBorder(Rectangle.NO_BORDER);
				cc1.setBackgroundColor(Color.WHITE);
				t.addCell(cc1);

				myPhrase1 = new Phrase(":", new Font(baseFont, font, Font.BOLD));
				PdfPCell czx1 = new PdfPCell(myPhrase1);
				czx1.setBorder(Rectangle.NO_BORDER);
				czx1.setBackgroundColor(Color.WHITE);
				t.addCell(czx1);

				myPhrase = new Phrase(destType, new Font(baseFont, font,Font.BOLD));
				PdfPCell css1 = new PdfPCell(myPhrase);
				css1.setBorder(Rectangle.NO_BORDER);
				css1.setBackgroundColor(Color.WHITE);
				t.addCell(css1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);

				myPhrase = new Phrase(" ", new Font(baseFont, fontsc,Font.NORMAL));
				cs1.setBorder(Rectangle.NO_BORDER);
				cs1.setBackgroundColor(Color.WHITE);
				t.addCell(cs1);
			}
		} catch (Exception e) {
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
		return t;
	}

	@SuppressWarnings("unchecked")
	private PdfPTable createFooter() {

		float[] width = { 10, 10, 10 };
		PdfPTable maintable = new PdfPTable(3);

		try {

			maintable.setWidthPercentage(90);
			maintable.setWidths(width);

			String path = getServletContext().getRealPath("/")+ "Main/modules/ironMining/images/authorizedsign.jpg";
			Image imgsign = Image.getInstance(path);

			String pathStap = getServletContext().getRealPath("/")+ "Main/modules/ironMining/images/DMG_SEAL.jpg";
			Image imgStamp = Image.getInstance(pathStap);
			imgStamp.scaleToFit(5, 5);

			Phrase myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell ci1 = new PdfPCell(myPhrase);
			ci1.setBackgroundColor(Color.WHITE);
			ci1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			ci1.addElement(imgStamp);
			ci1.setBorder(Rectangle.NO_BORDER);
			ci1.disableBorderSide(Rectangle.TOP);
			maintable.addCell(ci1);

			myPhrase = new Phrase("", new Font(baseFont, font, Font.NORMAL));
			PdfPCell ck = new PdfPCell(myPhrase);
			ck.setBorder(Rectangle.NO_BORDER);
			ck.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			ck.setBackgroundColor(Color.WHITE);
			maintable.addCell(ck);

			myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell ci = new PdfPCell(myPhrase);
			ci.setBackgroundColor(Color.WHITE);
			ci.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			ci.addElement(imgsign);
			ci.setBorder(Rectangle.NO_BORDER);
			ci.disableBorderSide(Rectangle.TOP);
			maintable.addCell(ci);

			myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell c0 = new PdfPCell(myPhrase);
			c0.disableBorderSide(Rectangle.TOP);
			c0.disableBorderSide(Rectangle.LEFT);
			c0.disableBorderSide(Rectangle.RIGHT);
			c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c0.setBackgroundColor(Color.WHITE);
			maintable.addCell(c0);

			myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell c71 = new PdfPCell(myPhrase);
			c71.disableBorderSide(Rectangle.TOP);
			c71.disableBorderSide(Rectangle.LEFT);
			c71.disableBorderSide(Rectangle.RIGHT);
			c71.setBackgroundColor(Color.WHITE);
			maintable.addCell(c71);

			myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell c7 = new PdfPCell(myPhrase);
			c7.disableBorderSide(Rectangle.TOP);
			c7.disableBorderSide(Rectangle.LEFT);
			c7.disableBorderSide(Rectangle.RIGHT);
			c7.setBackgroundColor(Color.WHITE);
			maintable.addCell(c7);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return maintable;
	}
	
	private PdfPTable createFooter1() {

		float[] width = { 100 };
		PdfPTable maintable = new PdfPTable(1);

		try {

			maintable.setWidthPercentage(100);
			maintable.setWidths(width);
			
			Phrase myPhrase = new Phrase("Disclaimer: The DMG reserves the right to modify, suspend, continue or terminate all or any part of the permit in general, at any time without giving notice and without assigning any reason whatsoever ",new Font(baseFont, 8, Font.NORMAL));
			PdfPCell cl = new PdfPCell(myPhrase);
			cl.setBorder(Rectangle.NO_BORDER);
			cl.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			cl.setBackgroundColor(Color.WHITE);
			maintable.addCell(cl);

			myPhrase = new Phrase("* The Goa Prevention of Illegal Mining, Storage & Transportation of Mineral Rules, 2013 needs to be strictly followed",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell cl1 = new PdfPCell(myPhrase);
			cl1.setBorder(Rectangle.NO_BORDER);
			cl1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			cl1.setBackgroundColor(Color.WHITE);
			maintable.addCell(cl1);

			myPhrase = new Phrase("* Any changes in the above details should be brought to the notice of the DMG",new Font(baseFont, 9, Font.NORMAL));
			PdfPCell cl11 = new PdfPCell(myPhrase);
			cl11.setBorder(Rectangle.NO_BORDER);
			cl11.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			cl11.setBackgroundColor(Color.WHITE);
			maintable.addCell(cl11);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return maintable;
	}

	private PdfPTable createImage() {

		float[] width = { 16 };
		PdfPTable maintable = new PdfPTable(1);

		try {

			String path = getServletContext().getRealPath("/")+ "Main/modules/ironMining/images/dmgLogo.png";
			Image img2 = Image.getInstance(path);

			maintable.setWidthPercentage(16);
			maintable.setWidths(width);

			Phrase myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell ci2 = new PdfPCell(myPhrase);
			ci2.setBackgroundColor(Color.WHITE);
			ci2.setBorder(Rectangle.NO_BORDER);
			maintable.addCell(ci2);

			myPhrase = new Phrase("", new Font(baseFont, 1, Font.NORMAL));
			PdfPCell ci = new PdfPCell(myPhrase);
			ci.setBackgroundColor(Color.WHITE);
			ci.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			ci.addElement(img2);
			ci.setBorder(Rectangle.NO_BORDER);
			ci.disableBorderSide(Rectangle.TOP);
			maintable.addCell(ci);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return maintable;
	}

	private PdfPTable createEmptyLogoHeader() {
		float[] width = { 100 };
		PdfPTable maintable = new PdfPTable(1);
		try {
			maintable.setWidthPercentage(100);
			maintable.setWidths(width);
			Phrase myPhrase = new Phrase("DRAFT", new Font(baseFont, 15,Font.UNDERLINE));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setPaddingTop(60f);
			c1.setPaddingBottom(10f);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBackgroundColor(Color.WHITE);
			maintable.addCell(c1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return maintable;
	}

	private PdfPTable createPermitHeader(String PermitType,
			String permitReqType, String buttonType, String importType) {

		float[] width = { 100 };
		PdfPTable maintable = new PdfPTable(1);

		String heading = "";
		if (PermitType.equals("Rom Transit")) {
			heading = "ROM TRANSIT PERMIT";
		}
		if (PermitType.equals("Processed Ore Transit")) {
			heading = "PROCESSED ORE TRANSIT PERMIT";
		}
		if (PermitType.equals("Domestic Export")) {
			heading = "DOMESTIC EXPORT PERMIT";
		}
		if (PermitType.equals("International Export")) {
			heading = "INTERNATIONAL EXPORT PERMIT";
		}
		if (PermitType.equals("Rom Sale")) {
			heading = "ROM SALE PERMIT";
		}
		if (PermitType.equals("Processed Ore Sale")) {
			heading = "PROCESSED ORE SALE PERMIT";
		}
		if (PermitType.equals("Bauxite Transit")) {
			heading = "BAUXITE TRANSIT PERMIT";
		}
		if (PermitType.equals("Processed Ore Sale Transit")) {
			heading = "PROCESSED ORE SALE TRANSIT PERMIT";
		}
		if (PermitType.equals("Import Permit")) {
			heading = "IMPORT PERMIT (" + importType + ")";
		}
		if (PermitType.equals("Import Transit Permit")) {
			heading = "IMPORT TRANSIT PERMIT (" + importType + ")";
		}
		if (PermitType.equals("Purchased Rom Sale Transit Permit")) {
			heading = "PURCHASED ROM SALE TRANSIT PERMIT";
		}
		try {

			maintable.setWidthPercentage(100);
			maintable.setWidths(width);
			Phrase myPhrase = null;

			if (!(buttonType.equals("Add") || buttonType.equals("Modify"))) {
				myPhrase = new Phrase("Government of Goa", new Font(baseFont,11, Font.NORMAL));
				PdfPCell cb = new PdfPCell(myPhrase);
				cb.setBorder(Rectangle.NO_BORDER);
				cb.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				cb.setBackgroundColor(Color.WHITE);
				maintable.addCell(cb);

				myPhrase = new Phrase("Directorate of Mines & Geology",new Font(baseFont, 13, Font.NORMAL));
				PdfPCell cc = new PdfPCell(myPhrase);
				cc.setBorder(Rectangle.NO_BORDER);
				cc.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				cc.setBackgroundColor(Color.WHITE);
				maintable.addCell(cc);
			} else {
				myPhrase = new Phrase("", new Font(baseFont, 11, Font.NORMAL));
				PdfPCell cb = new PdfPCell(myPhrase);
				cb.setBorder(Rectangle.NO_BORDER);
				cb.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				cb.setBackgroundColor(Color.WHITE);
				maintable.addCell(cb);

				myPhrase = new Phrase("", new Font(baseFont, 13, Font.NORMAL));
				PdfPCell cc = new PdfPCell(myPhrase);
				cc.setBorder(Rectangle.NO_BORDER);
				cc.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				cc.setBackgroundColor(Color.WHITE);
				maintable.addCell(cc);
			}

			// myPhrase=new Phrase(" ",new Font(baseFont,10, Font.NORMAL));
			// PdfPCell c0 = new PdfPCell(myPhrase);
			// c0.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			// c0.setBorder(Rectangle.NO_BORDER);
			// c0.setBackgroundColor(Color.WHITE);
			// maintable.addCell(c0);

			myPhrase = new Phrase(heading, new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBackgroundColor(Color.WHITE);
			maintable.addCell(c);

			myPhrase = new Phrase("", new Font(baseFont, 10, Font.NORMAL));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c1.setBackgroundColor(Color.WHITE);
			c1.disableBorderSide(Rectangle.LEFT);
			c1.disableBorderSide(Rectangle.RIGHT);
			c1.disableBorderSide(Rectangle.TOP);
			maintable.addCell(c1);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return maintable;
	}

	@SuppressWarnings("unchecked")
	public HashMap getDataForPermitDetails(int id) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		HashMap dataMap = new HashMap();
		SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		DecimalFormat df = new DecimalFormat("0.00");
		int challanId = 0;
		String permitT = null;
		String permitreqType = null;
		float processingFee = 0;
		int existingPId = 0;
		double LmeRate = 0;
		double tdsPerc = 0;
		double dollarRate = 0;
		double gradeRate = 0;
		double rate = 0;
		double cellAmt = 0;
		double processFeeRate = 0;
		double qty = 0;
		double totalRoyality = 0;
		double royality = 0;
		String srcType = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_PERMIT_DETAILS);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("ISSUED_DATE") == "" || rs.getString("ISSUED_DATE").contains("1900")) {
					dataMap.put("issuedDate", "");
				} else {
					dataMap.put("issuedDate", ddmmyyyy.format(yyyymmdd.parse(rs .getString("ISSUED_DATE"))));
				}

				if (rs.getString("START_DATE") == "" || rs.getString("START_DATE").contains("1900")) {
					dataMap.put("startDate", "");
				} else {
					dataMap.put("startDate", ddmmyyyy.format(yyyymmdd.parse(rs .getString("START_DATE"))));
				}

				if (rs.getString("END_DATE") == "" || rs.getString("END_DATE").contains("1900")) {
					dataMap.put("endDate", "");
				} else {
					dataMap.put("endDate", ddmmyyyy.format(yyyymmdd.parse(rs .getString("END_DATE"))));
				}

				if (rs.getString("DATE") == "" || rs.getString("DATE").contains("1900")) {
					dataMap.put("permitDate", "");
				} else {
					dataMap.put("permitDate", ddmmyyyy.format(yyyymmdd.parse(rs.getString("DATE"))));
				}

				dataMap.put("tcNo", rs.getString("TC_NO"));
				dataMap.put("minecode", rs.getString("MINE_CODE"));
				dataMap.put("orgName", rs.getString("ORGANIZATION_NAME"));

				dataMap.put("permitNo", rs.getString("PERMIT_NO"));
				dataMap.put("mineral", rs.getString("MINERAL"));
				dataMap.put("appNo", rs.getString("APPLICATION_NO"));
				dataMap.put("challanNo", rs.getString("CHALLAN_NO"));

				dataMap.put("tripName", rs.getString("Trip_Name"));
				dataMap.put("startLocation", rs.getString("Start_Location"));
				dataMap.put("endLocation", rs.getString("End_Location"));
				dataMap.put("permitType", rs.getString("PERMIT_TYPE"));
				dataMap.put("orgCode", rs.getString("ORGANIZATION_CODE"));
				dataMap.put("processedOrgName", rs.getString("PROCESSED_ORGANIZATION_NAME"));

				dataMap.put("stateName", rs.getString("STATE_NAME"));
				dataMap.put("countryName", rs.getString("COUNTRY_NAME"));
				dataMap.put("buyerName", rs.getString("BUYER_NAME"));
				dataMap.put("shipName", rs.getString("SHIP_NAME"));
				dataMap.put("buyingOrgName", rs.getString("BUYING_ORGANIZAION_NAME"));
				dataMap.put("buyingOrgCode", rs.getString("BUYING_ORGANIZATION_CODE"));

				dataMap.put("permitReqType", rs.getString("PERMIT_REQUEST_TYPE"));
				dataMap.put("existingPermitNo", rs.getString("EXISTING_PERMIT_NO"));

				dataMap.put("importType", rs.getString("IMPORT_TYPE"));
				dataMap.put("importPurpose", rs.getString("IMPORT_PURPOSE"));
				dataMap.put("exportPermitNo", rs.getString("EXPORT_PERMIT_NO"));
				dataMap.put("remarks", rs.getString("REMARKS"));
				dataMap.put("hubIdPo", rs.getString("NAME"));

				if (rs.getString("EXPORT_PERMIT_NO_DATE") == ""|| rs.getString("EXPORT_PERMIT_NO_DATE").contains("1900")) {
					dataMap.put("exportPermitDate", "");
				} else {
					dataMap.put("exportPermitDate", ddmmyyyy.format(yyyymmdd.parse(rs.getString("EXPORT_PERMIT_NO_DATE"))));
				}
				dataMap.put("exportChallanNo", rs.getString("EXPORT_CHALLAN_NO"));
				if (rs.getString("EXPORT_CHALLAN_NO_DATE") == ""|| rs.getString("EXPORT_CHALLAN_NO_DATE").contains("1900")) {
					dataMap.put("exportChallanDate", "");
				} else {
					dataMap.put("exportChallanDate", ddmmyyyy.format(yyyymmdd.parse(rs.getString("EXPORT_CHALLAN_NO_DATE"))));
				}
				dataMap.put("invoiceNo", rs.getString("SALE_INVOICE_NO"));
				if (rs.getString("EXPORT_CHALLAN_NO_DATE") == "" || rs.getString("SALE_INVOICE_NO_DATE").contains("1900")) {
					dataMap.put("invoiceDate", "");
				} else {
					dataMap.put("invoiceDate", ddmmyyyy.format(yyyymmdd.parse(rs.getString("SALE_INVOICE_NO_DATE"))));
				}
				dataMap.put("transportnType", rs.getString("TRANSPORTATION_TYPE"));
				dataMap.put("vesselName", rs.getString("VESSEL_NAME"));
				dataMap.put("srcType", rs.getString("SRC_TYPE"));
				dataMap.put("destType", rs.getString("DEST_TYPE"));
				dataMap.put("status", rs.getString("STATUS"));
				dataMap.put("gstNo", rs.getString("GST_NO"));
				dataMap.put("TCgstNo", rs.getString("TC_GST_NO"));
				dataMap.put("ibmAppNo", rs.getString("IBM_APPLICATION_NO"));

				permitreqType = rs.getString("PERMIT_REQUEST_TYPE");
				existingPId = rs.getInt("EXISTING_PERMIT_ID");
				challanId = rs.getInt("CHALLAN_ID");
				permitT = rs.getString("PERMIT_TYPE");
				srcType = rs.getString("SRC_TYPE");
				processingFee = Float.parseFloat(rs.getString("PROCESSING_FEE"));

			}
			if (((permitT.equals("Rom Transit") || permitT.equals("Rom Sale")) && srcType.equalsIgnoreCase("ROM"))
					|| permitT.equals(("Processed Ore Transit"))
					|| permitT.equals("International Export")
					|| permitT.equals("Domestic Export")
					|| permitT.equals("Processed Ore Sale")
					|| permitT.equals("Processed Ore Sale Transit")
					|| permitT.equals("Import Permit")
					|| permitT.equals("Import Transit Permit")
					|| permitT.equals("Purchased Rom Sale Transit Permit")) {
				pstmt1 = con.prepareStatement(GET_PERMIT_GRADE_DETAILS_FOR_PROCESSED_ORE);
				pstmt1.setInt(1, id);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					if (rs1.getString("TYPE").equals("Lumps")) {
						dataMap.put("fineQuantity", "0");
						dataMap.put("lumpQuantity", df.format(rs1.getDouble("QUANTITY")));
						dataMap.put("romQuantity", "0");
						dataMap.put("concQuantity", "0");
						dataMap.put("tailingQuantity", "0");
						dataMap.put("fineGrade", "");
						dataMap.put("lumpGrade", rs1.getString("GRADE"));
						dataMap.put("romGrade", "");
						dataMap.put("concGrade", "");
						dataMap.put("tailingGrade", "");
						
					} else if (rs1.getString("TYPE").equals("Fines")){
						dataMap.put("fineQuantity", df.format(rs1.getDouble("QUANTITY")));
						dataMap.put("lumpQuantity", "0");
						dataMap.put("romQuantity", "0");
						dataMap.put("concQuantity", "0");
						dataMap.put("tailingQuantity", "0");
						dataMap.put("fineGrade", rs1.getString("GRADE"));
						dataMap.put("lumpGrade", "");
						dataMap.put("romGrade", "");
						dataMap.put("concGrade", "");
						dataMap.put("tailingGrade", "");
						
					}else if (rs1.getString("TYPE").equals("Concentrates")){
						dataMap.put("fineQuantity", "0");
						dataMap.put("lumpQuantity", "0");
						dataMap.put("romQuantity", "0");
						dataMap.put("concQuantity", df.format(rs1.getDouble("QUANTITY")));
						dataMap.put("tailingQuantity", "0");
						dataMap.put("fineGrade", "");
						dataMap.put("lumpGrade", "");
						dataMap.put("romGrade", "");
						dataMap.put("concGrade", rs1.getString("GRADE"));
						dataMap.put("tailingGrade", "");
						
					}else if (rs1.getString("TYPE").equals("Tailings")){
						dataMap.put("fineQuantity", "0");
						dataMap.put("lumpQuantity", "0");
						dataMap.put("romQuantity", "0");
						dataMap.put("concQuantity", "0");
						dataMap.put("tailingQuantity", df.format(rs1.getDouble("QUANTITY")));
						dataMap.put("fineGrade", "");
						dataMap.put("lumpGrade", "");
						dataMap.put("romGrade", "");
						dataMap.put("concGrade", "");
						dataMap.put("tailingGrade", rs1.getString("GRADE"));
						
					}
					dataMap.put("totalQuantity", df.format(rs1.getDouble("QUANTITY")));
					dataMap.put("totalProcessingFee", df.format(rs1.getDouble("TOTAL_PROCESSING_FEE")));
					if (((permitT.equals("Rom Transit") || permitT.equals("Rom Sale"))&& srcType.equalsIgnoreCase("ROM")) || permitT.equals("Purchased Rom Sale Transit Permit")) {
						dataMap.put("romQuantity", df.format(rs1.getDouble("QUANTITY")));
						dataMap.put("romGrade", rs1.getString("GRADE"));
					}
				}
			} else if (permitT.equals(("Bauxite Transit"))) {
				pstmt1 = con.prepareStatement(" select * from CHALLAN_GRADE_DETAILS where CHALLAN_ID=? ");
				pstmt1.setInt(1, challanId);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					if (rs1.getString("GRADE").equals("LME RATE")) {
						LmeRate = rs1.getDouble("RATE");
					}
					if (rs1.getString("GRADE").equals("DOLLAR RATE")) {
						dollarRate = rs1.getDouble("RATE");
					}
					if (rs1.getString("GRADE").equals("GRADE RATE")) {
						gradeRate = rs1.getDouble("RATE");
					}
					if (rs1.getString("GRADE").equals("RATE")) {
						rate = rs1.getDouble("RATE");
					}
					if (rs1.getString("GRADE").equals("QUANTITY")) {
						qty = rs1.getDouble("RATE");
					}
					if (rs1.getString("GRADE").equals("CELL AMOUNT RATE")) {
						cellAmt = rs1.getDouble("RATE");
					}
					if (rs1.getString("GRADE").equals("PROCESSING FEE RATE")) {
						processFeeRate = rs1.getDouble("RATE");
					}
					if (rs1.getString("GRADE").equals("TDS PERCENTAGE")) {
						tdsPerc = (rs1.getDouble("RATE")) / 100;
					}
					royality = (LmeRate * dollarRate * gradeRate)* (rate / 100);
					totalRoyality = ((LmeRate * dollarRate * gradeRate) * (rate / 100))* qty;
					dataMap.put("totalQuantity", df.format(qty));
					dataMap.put("royalityPaid", df.format(totalRoyality));
					dataMap.put("fineGrade", "0");
					dataMap.put("lumpGrade", "0");
					dataMap.put("romGrade", "");
					dataMap.put("fineQuantity", "0");
					dataMap.put("lumpQuantity", "0");
					dataMap.put("romQuantity", "0");
					dataMap.put("processingFee", df.format(qty * processFeeRate));
				}
			} else {
				pstmt1 = con.prepareStatement(" select isnull(sum(QUANTITY),0) as TOTAL_QUANTITY,isnull(sum(PAYABLE),0) as ROYALITY_PAID,isnull((select isnull(TOTAL_PROCESSING_FEE,0) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=?),0) as PROCESSING_FEE_1 , "
								+ " (select top 1 isnull(GRADE,'') from CHALLAN_GRADE_DETAILS where CHALLAN_ID=?) as GRADE_ROM ,  "
								+ " isnull((select top 1 isnull(QUANTITY,0) as QUANTITY from CHALLAN_GRADE_DETAILS where CHALLAN_ID=?),0) as QUANTITY_ROM   "
								+ " from CHALLAN_GRADE_DETAILS where CHALLAN_ID=? group by CHALLAN_ID ");
				pstmt1.setInt(1, id);
				pstmt1.setInt(2, challanId);
				pstmt1.setInt(3, challanId);
				pstmt1.setInt(4, challanId);
				rs1 = pstmt1.executeQuery();
				while (rs1.next()) {
					dataMap.put("totalQuantity", df.format(rs1.getDouble("TOTAL_QUANTITY")));
					dataMap.put("royalityPaid", df.format(rs1.getDouble("ROYALITY_PAID")));
					dataMap.put("fineGrade", "");
					dataMap.put("lumpGrade", "");
					dataMap.put("romGrade", rs1.getString("GRADE_ROM"));
					dataMap.put("fineQuantity", "0");
					dataMap.put("lumpQuantity", "0");
					dataMap.put("romQuantity", df.format(rs1.getDouble("QUANTITY_ROM")));
					dataMap.put("processingFee", df.format(rs1.getDouble("PROCESSING_FEE_1")));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}

		return dataMap;
	}

	private void printBill(ServletOutputStream servletOutputStream,
			HttpServletResponse response, String bill, String PDForm) {
		try {
			String formno = PDForm;
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition", "attachment;filename="+ formno + ".pdf");
			FileInputStream fis = new FileInputStream(bill);
			DataOutputStream outputStream = new DataOutputStream(servletOutputStream);
			byte[] buffer = new byte[1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0) {
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		} catch (Exception e) {
			System.out.println("Error printing pdf form : " + e);
			e.printStackTrace();
		}
	}

}
