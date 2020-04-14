package t4u.GeneralVertical;

import java.util.Comparator;

import t4u.beans.DriverDetentionTime;
/*
 * Swaroop Tewari
 *   Used for sorting in ascending order of 
 *   Driver's detention time for Jotun(DCS Dubai) 
  */

public class DriverDetentionTimeComparator implements Comparator<DriverDetentionTime> 
{ 

    public int compare(DriverDetentionTime a, DriverDetentionTime b) 
    { 
        return a.detentionTime - b.detentionTime; 
    } 
}
