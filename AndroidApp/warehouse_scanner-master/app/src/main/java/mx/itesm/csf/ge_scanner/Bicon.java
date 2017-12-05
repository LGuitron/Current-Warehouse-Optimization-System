package mx.itesm.csf.ge_scanner;

import org.altbeacon.beacon.Identifier;
import org.altbeacon.beacon.Region;
import java.util.HashMap;
import java.util.Vector;

/**
 * Created by fas on 16/11/2017.
 */

//This class is used in order to do the monitoring of the beacons/zones inside Tabs.java
public class Bicon {

    //Region that will be monitored
    Region region;

    //ID's of adjacent regions
    Vector<Integer> beaconsInAdjacency = new Vector<Integer>();

    //Floors of the region according to the section ID provided in DB
    HashMap<Integer, Integer> floors = new HashMap<Integer, Integer>();

    //Principal configurations of the beacon/region
    int minor, major, zone;

    //UUID from the beacon and default name of the zone that will be monitored
    String uuid_beacon, region_id;

    //Constructor of the Bicon class, which saves all the Beacon info from the DB
    Bicon(String uuid, int maj, int min, int depZone)
    {
        uuid_beacon = uuid;
        major = maj;
        minor = min;
        zone = depZone;
        region_id = "ranged region ";
        region = new Region(region_id + zone, Identifier.parse(uuid), Identifier.parse(String.valueOf(major)), Identifier.parse(String.valueOf(minor)));
    }

    //SET's and GET's from Bicon class global variables
    public int getZone(){ return zone; }
    public void setFloor(int fl, int id){ floors.put(fl, id); }
    public String getRegionID(){ return region_id; }
    public void setRegion(Region r) {region = r;}
    public Region getRegion() {return region;}
    public void setBiA(Vector<Integer> adj) {beaconsInAdjacency = adj;}
    public int getMinor() {return minor;}
    public void setMinor(int x) {minor = x;}
    public int getMajor() {return major;}
    public void setMajor(int x) {major = x;}
    public String getUUID() {return uuid_beacon;}
    public void setUUID(String u) {uuid_beacon = u;}
    public void insertBiA(int x) {beaconsInAdjacency.add(x);}
    public Vector<Integer> getBiA() {return beaconsInAdjacency;}
    public int getFloorsSize()
    {
        return floors.size();
    }

    //Function to return section ID according to the floor in a zone
    public int getFloorZone(int x)
    {
        //If the floor requested is higher than the number of floors in the zone
        if(floors.size() < x)
            return 1;
        //If the request was correct, the function returns the correct section ID of the zone
        else
            return floors.get(x);
    }

    //Function to verify if the zone ID in the parameter is in adjacency in order to move to it
    public boolean isAdjacent(int x)
    {
        //If the zone doesn't have adjacencies
        if(beaconsInAdjacency != null)
        {
            for(int i = 0; i < beaconsInAdjacency.size(); i++)
            {
                //If the zone is adjacent
                if(x == beaconsInAdjacency.get(i))
                    return true;
            }
        }
        return false;
    }
}
