package t4u.google;

public class TeToge {

    private String mDis;

    private String gDis;

    private String odo;

    private String gTime;

    private String tTime;

    public String getMDis ()
    {
        return mDis;
    }

    public void setMDis (String mDis)
    {
        this.mDis = mDis;
    }

    public String getGDis ()
    {
        return gDis;
    }

    public void setGDis (String gDis)
    {
        this.gDis = gDis;
    }

    public String getOdo ()
    {
        return odo;
    }

    public void setOdo (String odo)
    {
        this.odo = odo;
    }

    public String getGTime ()
    {
        return gTime;
    }

    public void setGTime (String gTime)
    {
        this.gTime = gTime;
    }

    public String getTTime ()
    {
        return tTime;
    }

    public void setTTime (String tTime)
    {
        this.tTime = tTime;
    }

    @Override
    public String toString()
    {
        return "ClassPojo [mDis = "+mDis+", gDis = "+gDis+", odo = "+odo+", gTime = "+gTime+", tTime = "+tTime+"]";
    }

}
