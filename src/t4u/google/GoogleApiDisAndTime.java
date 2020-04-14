package t4u.google;


public class GoogleApiDisAndTime {

    private GsToTs gsToTs;

    private String excepMins;

    private TeToge teToge;

    private String giToHubDis;

    private String excepDis;

    private String hubToGSDis;

    private TsTote tsTote;

    public GsToTs getGsToTs ()
    {
        return gsToTs;
    }

    public void setGsToTs (GsToTs gsToTs)
    {
        this.gsToTs = gsToTs;
    }

    public String getExcepMins ()
    {
        return excepMins;
    }

    public void setExcepMins (String excepMins)
    {
        this.excepMins = excepMins;
    }

    public TeToge getTeToge ()
    {
        return teToge;
    }

    public void setTeToge (TeToge teToge)
    {
        this.teToge = teToge;
    }

    public String getGiToHubDis ()
    {
        return giToHubDis;
    }

    public void setGiToHubDis (String giToHubDis)
    {
        this.giToHubDis = giToHubDis;
    }

    public String getExcepDis ()
    {
        return excepDis;
    }

    public void setExcepDis (String excepDis)
    {
        this.excepDis = excepDis;
    }

    public String getHubToGSDis ()
    {
        return hubToGSDis;
    }

    public void setHubToGSDis (String hubToGSDis)
    {
        this.hubToGSDis = hubToGSDis;
    }

    public TsTote getTsTote ()
    {
        return tsTote;
    }

    public void setTsTote (TsTote tsTote)
    {
        this.tsTote = tsTote;
    }

    @Override
    public String toString()
    {
        return "ClassPojo [gsToTs = "+gsToTs+", excepMins = "+excepMins+", teToge = "+teToge+", giToHubDis = "+giToHubDis+", excepDis = "+excepDis+", hubToGSDis = "+hubToGSDis+", tsTote = "+tsTote+"]";
    }

}
