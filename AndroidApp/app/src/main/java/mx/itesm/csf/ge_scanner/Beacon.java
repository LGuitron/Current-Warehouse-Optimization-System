package mx.itesm.csf.ge_scanner;

public class Beacon implements Comparable<Beacon> {
    private String id;
    private String minor;
    private String major;
    private String position;
    private String floors;
    private String type;
    private String capacity;
    private String cost;

    public Beacon(String id, String minor, String major, String position) {
        this.id = id;
        this.minor = minor;
        this.major = major;
        this.position = position;
        this.floors = "null";
        this.capacity = "null";
        this.type = "null";
        this.cost = "null";
    }

    public String getId() {
        return id;
    }

    public String getMinor() {
        return minor;
    }

    public String getMajor() {
        return major;
    }

    public String getFloors() { return floors; }

    public String getCapacity() { return capacity; }

    public String getType() { return type; }

    public String getCost() { return cost; }

    // If the id passed in is the same id as this beacon's id, the information is updated
    public void setFloorTypeCapacityCost(String id, String floors, String type, String capacity, String cost) {
        if (this.id.equals(id)) {
            this.floors = floors;
            this.type = type;
            this.capacity = capacity;
            this.cost = cost;
        }
    }

    public String getPosition() {
        return position;
    }

    // helper function used to sort a list of beacons by id
    public int compareTo(Beacon o) {
        return Integer.compare(Integer.parseInt(id), Integer.parseInt(o.getId()));
    }
}
