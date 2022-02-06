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

public class Tuner.StationContextMenu : Gtk.Menu {
    public Model.Station station { get; construct; }

    public StationContextMenu (Model.Station station) {
        Object (
            station: station
        );
    }

    construct {
        var label = new Gtk.MenuItem.with_label (this.station.title);
        label.sensitive = false;
        this.append (label);

        var label2 = new Gtk.MenuItem.with_label (this.station.location);
        label2.sensitive = false;
        this.append (label2);

        if (this.station.homepage != null && this.station.homepage.length > 0) {
            var website_label = new Gtk.MenuItem.with_label (_("Visit Website"));
            this.append (website_label);
            website_label.activate.connect (on_website_handler);
        }

        this.append (new Gtk.SeparatorMenuItem ());

        var m1 = new Gtk.MenuItem ();
        set_star_context (m1);
        m1.activate.connect (on_star_handler);
        this.append (m1);

        this.station.notify["starred"].connect ( (sender, property) => {
            set_star_context (m1);
        });
    }

    private void on_star_handler () {
       station.toggle_starred ();
    }

    private void on_website_handler () {
        try {
            Gtk.show_uri_on_window (Application._instance.window, station.homepage, Gdk.CURRENT_TIME);
        } catch (Error e) {
            warning (@"Unable to open website: $(e.message)");
        }

    }
    private void set_star_context (Gtk.MenuItem item) {
        item.label = station.starred ? Application.UNSTAR_CHAR + _("Unstar this station") : Application.STAR_CHAR + _("Star this station");
    }

}