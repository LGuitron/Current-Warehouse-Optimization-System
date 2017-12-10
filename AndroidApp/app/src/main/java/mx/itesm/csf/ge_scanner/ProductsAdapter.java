package mx.itesm.csf.ge_scanner;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.amulyakhare.textdrawable.TextDrawable;
import com.amulyakhare.textdrawable.util.ColorGenerator;

import java.util.List;
import java.util.Random;

/* Resources:
https://stackoverflow.com/questions/37159217/how-to-get-data-from-a-particular-cardview-attached-recyclerview
*/

/**
 * Created by danflovier on 16/09/2017.
 */

public class ProductsAdapter extends RecyclerView.Adapter<ProductsAdapter.MyViewHolder> {

    private List<Products> list;
    static private String lid = Tabs.getVariable();
    private ProductsPreferences list_sP;
    private Context context;
    private Request request;
    private AlertDialog.Builder builder;

    private static final int HIGHLIGHT_COLOR = 0x999be6ff;


    // Show RecyclerView with their elements and info
    // Show the objects declared in the XML file so they can be seen at the view.
    class MyViewHolder extends RecyclerView.ViewHolder{
        TextView product_name, ean;
        ImageButton delete, leave_product;
        CardView mCardView;
        private ImageView image;

        MyViewHolder(View view) {
            super(view);
            mCardView = (CardView) view.findViewById(R.id.card_view);
            product_name = (TextView) view.findViewById(R.id.product);
            ean = (TextView) view.findViewById(R.id.ean);
            delete = (ImageButton) view.findViewById(R.id.card_delete);
            leave_product = (ImageButton) view.findViewById(R.id.card_leave);
            image = (ImageView) view.findViewById(R.id.image_view);

        }
    }

    // Constructor
    ProductsAdapter(Context context, List<Products> list) {
        this.list = list;
        this.context = context;
        list_sP = new ProductsPreferences(this.context);
        request = new Request(this.context);
        builder = new AlertDialog.Builder(this.context);
    }

    // Create new views by the layout manager)
    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.items, parent, false);

        return new MyViewHolder(itemView);
    }

    // Get element from the data entered by the user
    // at position and replace the content of the View with it
    @Override
    public void onBindViewHolder(final MyViewHolder holder, final int position) {

        // Get position of the current item
        final Products product = list.get(position);

        // Set name of the product on the current item
        holder.product_name.setText(product.getProduct());

        // Set ean of the product on the current item
        holder.ean.setText(product.getEAN());

        // Generate a color to fill the drawable
        ColorGenerator generator = ColorGenerator.MATERIAL;
        final int color = generator.getColor(position);

        // Set a letter to the drawable with the first character of the name of the product
        TextDrawable drawable = TextDrawable.builder().buildRound(String.valueOf(product.getProduct().charAt(0)), color);

        // Show the image of the text drawable
        holder.image.setImageDrawable(drawable);

        // Shows the section of the product on the drawable
        holder.image.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Set checked when drawable is clicked
                product.setChecked(!product.isChecked);

                // Update the drawable
                updateDrawable(holder, product, color);
            }
        });

        // Leave item at Warehouse and remove it from the list
        holder.leave_product.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                leaveItem(position, product);
                setText();
            }
        });

        // Remove the item from list and from the serer
        holder.delete.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                removeItem(position, product);
                setText();
            }
        });


    }

    // update behaviour of the drawable implemented on each row of the list
    public void updateDrawable(MyViewHolder holder, Products item, int color) {
        // Declare a builder of the drawable
        TextDrawable.IBuilder drawableBuilder;

        // if drawable is clicked, shows the section of the product
        if (item.isChecked) {
            drawableBuilder = TextDrawable.builder()
                    .beginConfig()
                    .fontSize(50)
                    .endConfig()
                    .round();
            holder.image.setImageDrawable(drawableBuilder.build("S" + String.valueOf(item.getSection().charAt(0)), 0xff616161));
            holder.mCardView.setBackgroundColor(HIGHLIGHT_COLOR);
        }

        // Return to the normal behaviour of the drawable
        else {
            drawableBuilder = TextDrawable.builder()
                    .beginConfig()
                    .fontSize(80)
                    .endConfig()
                    .round();
            TextDrawable drawable = drawableBuilder.build(String.valueOf(item.getProduct().charAt(0)), color);
            holder.image.setImageDrawable(drawable);
            holder.mCardView.setBackgroundColor(Color.WHITE);
        }
    }

    // This function returns the size of the list created
    @Override
    public int getItemCount() {
        return list.size();
    }

    // Insert item on the list
    public void insertItem(Products product) {
        list.add(product);
        list_sP.addProduct(product);
        notifyItemInserted(getItemCount());
        notifyDataSetChanged();
    }

    // Remove item from list in case the user scans twice a product by error
    public void removeItem(int position, Products product) {

        // Remove data from the each list
        list.remove(position);
        list_sP.removeProduct(position);

        // Get value of the pid and barcode from each product
        final String pid = String.valueOf(product.getPID());
        final String ean = product.getEAN();

        request.sendDeletedProducts(pid, ean, lid);

        //list_sP.saveProducts(list);
        notifyItemRemoved(position);
        notifyItemRangeChanged(position, list.size());
        notifyDataSetChanged();
    }

    // Remove item from list and data base
    public void leaveItem(final int position, Products product) {

        // Get value of the pid, lid and barcode from each product
        lid = Tabs.getVariable();
        final String pid = String.valueOf(product.getPID());
        final String ean = product.getEAN();

        //Resources from beacons/zones pulled from Tabs.java
        final int minor = Tabs.getZoneByMinor();
        final int floors_size = Tabs.getFloors();

        //Array of strings to show floors after trying to leave a product
        String[] items = new String[floors_size + 1];

        //Insert data in array
        for(int i = 0; i < floors_size + 1; i++)
        {
            if(i == 0)
                items[i] = "Selección";
            else
                items[i] = String.valueOf(i);
        }

        // List of items
        //String[] items = context.getResources().getStringArray(R.array.rack_floor_array);

        // Creating the builder of the alert dialog
        builder.setTitle("RACK FLOOR")
                // Select just a single choice of the items array
                .setSingleChoiceItems(items, 0, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int item) {
                        String rack_floor =  String.valueOf(item);
                        // Check a valid option of the rack floor
                        if (item == 0)
                        {
                            Message.message(context, "You must enter a valid option!");
                        }
                        else
                        {
                            // Close the alert dialog
                            dialog.dismiss();

                            // Send the data to the server
                            request.sendToPredix(pid, ean, lid, "0", String.valueOf(Tabs.getSection(minor, Integer.parseInt(rack_floor))), rack_floor, DateTime.getDateandTime());

                            // Delete the element from the list
                            list.remove(position);

                            // Delete the element from the list (but the one created with Shared Preferences)
                            list_sP.removeProduct(position);

                            // Notify about the item removed
                            notifyItemRemoved(position);

                            // Notify item range has changed
                            notifyItemRangeChanged(position, list.size());

                            // Put a message when the list is empty
                            setText();
                        }
                    }
                });

        // Create the alert dialog
        AlertDialog dialog = builder.create();

        // Display dialog
        dialog.show();
    }


    // Set message to textView in fragment depending if there's an item on the list
    public void setText(){
        if (getItemCount() == 0){
            Tab2_Products.setText();
        }
    }
}