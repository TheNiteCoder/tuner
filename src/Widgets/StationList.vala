/*
* Copyright (c) 2020-2022 Louis Brauer <louis@brauer.family>
*
* This file is part of Tuner.
*
* Tuner is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Tuner is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Tuner.  If not, see <http://www.gnu.org/licenses/>.
*
*/

using Gee;

public class Tuner.StationList : AbstractContentList {

    public signal void selection_changed (Model.Station station);
    public signal void station_count_changed (uint count);
    public signal void favourites_changed ();

    public Model.Station selected_station;
    
    public ArrayList<Model.Station> stations {
        set construct {
            clear ();
            if (value == null) return;
            
            foreach (var s in value) {
                s.notify["starred"].connect ( () => {
                    favourites_changed ();
                });
                var box = new StationBox (s);
                box.clicked.connect (() => {
                    selection_changed (box.station);
                    selected_station = box.station;
                });
                add (box);
            }
            item_count = value.size;
        }
    }

    public StationList () {
        Object (
            homogeneous: false,
            min_children_per_line: 1,
            max_children_per_line: 3,
            column_spacing: 5,
            row_spacing: 5,
            border_width: 20,
            valign: Gtk.Align.START,
            selection_mode: Gtk.SelectionMode.NONE
        );
    }

    public StationList.with_stations (Gee.ArrayList<Model.Station> stations) {
        this ();
        this.stations = stations;
    }

    
    public void clear () {
        var childs = get_children();
        foreach (var c in childs) {
            c.destroy();
        }
    }

    public override uint item_count { get; set; }
}
