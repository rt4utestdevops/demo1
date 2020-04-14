package t4u.beans;

public class DriverDetentionTime {
	public int detentionTime; 
    public String name; 
    // Constructor 
    public DriverDetentionTime(int detentionTime, String name) 
    { 
        this.detentionTime = detentionTime; 
        this.name = name; 
    } 
  
    // Used to print student details in main() 
    public String toString() 
    { 
        return this.detentionTime + " " + this.name; 
    } 
}
