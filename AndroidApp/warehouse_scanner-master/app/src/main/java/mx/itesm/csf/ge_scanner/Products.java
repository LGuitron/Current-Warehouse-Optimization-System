package mx.itesm.csf.ge_scanner;

/**
 * Created by danflovier on 16/09/2017.
 */


// Class of Products
public class Products {
    private String pid, ean, product, lid, section, status;
    protected boolean isChecked;

    // Parameterized constructor for receiving the data of the products.
    public Products(String pid, String ean, String product, String lid, String status, String section) {
        this.pid = pid;
        this.ean = ean;
        this.product = product;
        this.lid = lid;
        this.status = status;
        this.section = section;
    }

    // GET method to provide access to the value a variable holds
    public String getPID(){ return pid; }
    public String getEAN() {
        return ean;
    }
    public String getProduct() {
        return product;
    }
    public String getLID(){ return lid;}
    public String getSection(){ return section; }
    public String getStatus(){ return status; }

    // SET method to assign values to the variables
    public void setChecked(boolean isChecked) {
        this.isChecked = isChecked;
    }
    public void setPID(String pid){ this.pid = pid;}
    public void setEAN(String ean) {
        this.ean = ean;
    }
    public void setProduct(String product) {
        this.product = product;
    }
    public void setLID(String id_lift_truck){ this.lid = id_lift_truck;}
    public void setSection(String section){ this.section = section; }
    public void setStatus(String status){ this.status = status; }
}
