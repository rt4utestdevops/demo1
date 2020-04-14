package t4u.ironMining;

import java.io.Serializable;

public class ImportsExportsBean implements Serializable {
	int orgId;
	String orgName="";
	String orgCode="";
	
	double domExpFines=0.0;
	double domExpLumps=0.0;
	double domExpConcentrates=0.0;
	double domExpTailings=0.0;
	double totalDomExp=0.0;
	
	double intExpFines=0.0;
	double intExpLumps=0.0;
	double intExpConcentrates=0.0;
	double intExpTailings=0.0;
	double totalIntExp=0.0;
	
	double domImpFines=0.0;
	double domImpLumps=0.0;
	double domImpConcentrates=0.0;
	double domImpTailings=0.0;
	double totalDomImp=0.0;
	
	double intImpFines=0.0;
	double intImpLumps=0.0;
	double intImpConcentrates=0.0;
	double intImpTailings=0.0;
	double totalIntImp=0.0;
	
	public ImportsExportsBean() {super();}
	
	public int getOrgId() {
		return orgId;
	}
	public void setOrgId(int orgId) {
		this.orgId = orgId;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public double getDomExpFines() {
		return domExpFines;
	}
	public void setDomExpFines(double domExpFines) {
		this.domExpFines = domExpFines;
	}
	public double getDomExpLumps() {
		return domExpLumps;
	}
	public void setDomExpLumps(double domExpLumps) {
		this.domExpLumps = domExpLumps;
	}
	public double getDomExpConcentrates() {
		return domExpConcentrates;
	}
	public void setDomExpConcentrates(double domExpConcentrates) {
		this.domExpConcentrates = domExpConcentrates;
	}
	public double getDomExpTailings() {
		return domExpTailings;
	}
	public void setDomExpTailings(double domExpTailings) {
		this.domExpTailings = domExpTailings;
	}
	public double getTotalDomExp() {
		return domExpFines+domExpLumps+domExpConcentrates+domExpTailings;
	}
	
	public double getIntExpFines() {
		return intExpFines;
	}
	public void setIntExpFines(double intExpFines) {
		this.intExpFines = intExpFines;
	}
	public double getIntExpLumps() {
		return intExpLumps;
	}
	public void setIntExpLumps(double intExpLumps) {
		this.intExpLumps = intExpLumps;
	}
	public double getIntExpConcentrates() {
		return intExpConcentrates;
	}
	public void setIntExpConcentrates(double intExpConcentrates) {
		this.intExpConcentrates = intExpConcentrates;
	}
	public double getIntExpTailings() {
		return intExpTailings;
	}
	public void setIntExpTailings(double intExpTailings) {
		this.intExpTailings = intExpTailings;
	}
	public double getTotalIntExp() {
		return intExpFines+intExpLumps+intExpConcentrates+intExpTailings;
	}
	
	public double getDomImpFines() {
		return domImpFines;
	}
	public void setDomImpFines(double domImpFines) {
		this.domImpFines = domImpFines;
	}
	public double getDomImpLumps() {
		return domImpLumps;
	}
	public void setDomImpLumps(double domImpLumps) {
		this.domImpLumps = domImpLumps;
	}
	public double getDomImpConcentrates() {
		return domImpConcentrates;
	}
	public void setDomImpConcentrates(double domImpConcentrates) {
		this.domImpConcentrates = domImpConcentrates;
	}
	public double getDomImpTailings() {
		return domImpTailings;
	}
	public void setDomImpTailings(double domImpTailings) {
		this.domImpTailings = domImpTailings;
	}
	public double getTotalDomImp() {
		return domImpFines+domImpLumps+domImpConcentrates+domImpTailings;
	}
	
	public double getIntImpFines() {
		return intImpFines;
	}
	public void setIntImpFines(double intImpFines) {
		this.intImpFines = intImpFines;
	}
	public double getIntImpLumps() {
		return intImpLumps;
	}
	public void setIntImpLumps(double intImpLumps) {
		this.intImpLumps = intImpLumps;
	}
	public double getIntImpConcentrates() {
		return intImpConcentrates;
	}
	public void setIntImpConcentrates(double intImpConcentrates) {
		this.intImpConcentrates = intImpConcentrates;
	}
	public double getIntImpTailings() {
		return intImpTailings;
	}
	public void setIntImpTailings(double intImpTailings) {
		this.intImpTailings = intImpTailings;
	}
	public double getTotalIntImp() {
		return intImpFines+intImpLumps+intImpConcentrates+intImpTailings;
	}
	
}
