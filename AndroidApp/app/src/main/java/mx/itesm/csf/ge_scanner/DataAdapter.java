package mx.itesm.csf.ge_scanner;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.Collections;

public class DataAdapter extends RecyclerView.Adapter<DataAdapter.ViewHolder> implements Filterable {

    private Context context;
    private ArrayList<Beacon> mArrayList;
    private ArrayList<Beacon> mFilteredList;
    private String[] types = { "Pasillos", "Zona de carga/descarga o producción", "Rack con producto directo", "Rack de tarimas", "Espacio para productos pequeños" };

    public DataAdapter(ArrayList<Beacon> arrayList, Context context) {
        mArrayList = arrayList;
        mFilteredList = arrayList;
        this.context = context;
    }

    @Override
    public DataAdapter.ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.card_row, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(DataAdapter.ViewHolder viewHolder, final int i) {
        // Set text in the Data Adapter Fields

        // Red missing string displayed when a value is yet to be assigned.
        String missing = "<font color='#EE0000'> " + context.getResources().getString(R.string.missing) + "</font>";
        String minor = mFilteredList.get(i).getMinor();
        if (minor.equals("null")) minor = missing;

        String position = mFilteredList.get(i).getPosition();
        if (position.equals("null")) position = missing;

        String floor = mFilteredList.get(i).getFloors();
        if (floor.equals("null")) floor = missing;

        String capacity = mFilteredList.get(i).getCapacity();
        if (capacity.equals("null")) capacity = missing;

        String cost = mFilteredList.get(i).getCost();
        if (cost.equals("null")) cost = missing;

        String type = types[Integer.valueOf(mFilteredList.get(i).getType())];
        if (type.equals("null")) type = missing;

        String display = context.getResources().getString(R.string.zone_label) + " " + mFilteredList.get(i).getId();

        viewHolder.zone.setText(display);
        viewHolder.positionTE.setText(Html.fromHtml(context.getResources().getString(R.string.beacon_id_label) + " " + minor));
        viewHolder.minorTE.setText(Html.fromHtml(context.getResources().getString(R.string.position_label) + " " + position));
        viewHolder.capacityTE.setText(Html.fromHtml(context.getResources().getString(R.string.capacity_label) + " " + capacity));
        viewHolder.costTE.setText(Html.fromHtml(context.getResources().getString(R.string.cost_label) + " " + cost));
        viewHolder.typeTE.setText(Html.fromHtml(context.getResources().getString(R.string.type_label) + " " + type));

        if (mFilteredList.get(i).getType().equals("0") || mFilteredList.get(i).getType().equals("1")) {
            // If the zone is type 0 or type 1, we don't show the floorsTE
            viewHolder.floorsTE.setText(Html.fromHtml(""));
        } else {
            viewHolder.floorsTE.setText(Html.fromHtml(context.getResources().getString(R.string.floors_label) + " " + floor));
        }

        viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Gson gson = new Gson();
                String beacon = gson.toJson(mFilteredList.get(i));
                // If a zone is clicked, the user is redirected to the BeaconInfoActivity
                Intent intent = new Intent(context, BeaconInfoActivity.class);
                intent.putExtra("beacon", beacon);
                context.startActivity(intent);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mFilteredList.size();
    }

    @Override
    public Filter getFilter() {
        // Filters the information in the RecyclerView depending on what's been typed in the search bar
        return new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence charSequence) {

                String charString = charSequence.toString();

                if (charString.isEmpty()) {
                    mFilteredList = mArrayList;
                    Collections.sort(mFilteredList);
                } else {

                    ArrayList<Beacon> filteredList = new ArrayList<>();

                    for (Beacon beacon : mArrayList) {

                        if (beacon.getId().toLowerCase().contains(charString) || beacon.getMinor().toLowerCase().contains(charString)) {
                            filteredList.add(beacon);
                        }

                        // Condition added to display zones missing data if "missing" is typed in the search bar.
                        String missing = "missing";
                        String sinAsignar = "sin asignar";
                        if (missing.contains(charString) || sinAsignar.contains(charString)) {
                            if (beacon.getMinor().equals("null") || beacon.getPosition().equals("null") || beacon.getFloors().equals("null") || beacon.getType().equals("null") || beacon.getCapacity().equals("null") || beacon.getCost().equals("null")) {
                                filteredList.add(beacon);
                            }
                        }
                    }

                    mFilteredList = filteredList;
                    Collections.sort(mFilteredList);
                }

                FilterResults filterResults = new FilterResults();
                filterResults.values = mFilteredList;
                return filterResults;
            }

            @Override
            protected void publishResults(CharSequence charSequence, FilterResults filterResults) {
                mFilteredList = (ArrayList<Beacon>) filterResults.values;
                notifyDataSetChanged();
            }
        };
    }

    public class ViewHolder extends RecyclerView.ViewHolder{
        private TextView zone, positionTE, minorTE, floorsTE, costTE, capacityTE, typeTE;

        private ViewHolder(View view) {
            super(view);
            // Bind layout elements to variables
            zone = view.findViewById(R.id.zone);
            positionTE = view.findViewById(R.id.position);
            minorTE = view.findViewById(R.id.minor);
            floorsTE = view.findViewById(R.id.floors);
            costTE = view.findViewById(R.id.cost);
            capacityTE = view.findViewById(R.id.capacity);
            typeTE = view.findViewById(R.id.type);
        }
    }

}