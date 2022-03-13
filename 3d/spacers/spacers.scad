$fn=36;

*spacer_small_matrix();
*spacer_big_matrix();

*drill_sizes();
*spacer_big();
*spacer_small();

module spacer_small_matrix() {
    grid=7.5;
    for(x=[0:grid:(grid*4)]) {
        for(y=[0:grid:(grid*3)]) {
            translate([x,y,0]) spacer_small();
        }
    }
    for(x=[0:grid:(grid*4)]) {
        for(y=[0:grid:grid*2]) {
            translate([x-0.5,y+1,0]) cube([1,grid-2,,1]);
        }
    }
    for(x=[0:grid:(grid*3)]) {
        for(y=[0:grid:(grid*3)]) {
            translate([x+1,y-0.5,0]) cube([grid-2,1,1]);
        }
    }
}

module spacer_big_matrix() {
    gridx=35;
    gridy=5;
    for(x=[0:gridx:gridx]) {
        for(y=[0:gridy:(gridy*5)]) {
            translate([x,y,0]) spacer_big();
        }
    }
    for(x=[0:gridx:gridx]) {
        for(y=[0:gridy:(gridy*4)]) {
            translate([x+15,y+1,0]) cube([1,gridy-2,,1]);
        }
    }
    for(x=[0:gridx:gridx-1]) {
        for(y=[0:gridy:(gridy*5)]) {
            translate([x+31.5,y-0.5,0]) cube([gridx-33,1,1]);
        }
    }
}

module spacer_small() {
    difference() {
        union() {
            cylinder(r=3, h=12.6, $fn=6);
        }
        union() {
            translate([0,0,-1]) cylinder(r=1, h=15);
        }
    }
}

module spacer_big() {
    difference() {
        union() {
            hull() {
                cylinder(r=2, h=12.6);
                translate([30.00248,0,0]) cylinder(r=2, h=12.6);
            }
            for(i = [0:7.50062:(7.50062*4)]) {
                translate([i,0,0]) cylinder(r=1.1, h=12.6+1.4);
            }
        }
        union() {
            for(i = [0:(7.50062):(7.50062*4)]) {
                translate([i,0,-1]) cylinder(r=1, h=8);
            }
            for(i = [3.5-1, (7.50062*4)-3.5-1]) {
                translate([i,-3,-1]) cube([2,6,1.8]);
            }
            translate([7.50062*2,0,0]) for(i = [0,180]) {
                rotate([0,0,i]) translate([-17,-3,10]) cube([7,2,5]);
            }
            for(x = [0.5:5:26]) {
                for(z = [4.5:5:10]) {
                    translate([x,-3,z]) rotate([0,45,0]) cube([2.5,6,2.5]);
                }
            }
            for(x = [3:5:25]) {
                translate([x,-3,7]) rotate([0,45,0]) cube([2.5,6,2.5]);
            }
        }
    }
}

module drill_sizes() {
    difference() {
        cube([20,10,15]);
        translate([5,2.5,10]) cylinder(r=0.6, h=6);
        translate([5,7.5,10]) cylinder(r=0.7, h=6);
        translate([10,2.5,10]) cylinder(r=0.8, h=6);
        translate([10,7.5,10]) cylinder(r=0.9, h=6);
        translate([15,2.5,10]) cylinder(r=1, h=6);
        translate([15,7.5,10]) cylinder(r=1.1, h=6);
        translate([10,5,-1]) mirror([1,0,0]) linear_extrude(2) text("PETG", font=":bold", size=5, valign="center", halign="center");
        translate([5,1,7.5]) rotate([90,-90,0]) linear_extrude(2) text("0.6", font=":bold", size=4.5, valign="center", halign="center");
        translate([10,1,7.5]) rotate([90,-90,0]) linear_extrude(2) text("0.8", font=":bold", size=4.5, valign="center", halign="center");
        translate([15,1,7.5]) rotate([90,-90,0]) linear_extrude(2) text("1.0", font=":bold", size=4.5, valign="center", halign="center");
        translate([5,9,7.5]) rotate([-90,-90,0]) linear_extrude(2) text("0.7", font=":bold", size=4.5, valign="center", halign="center");
        translate([10,9,7.5]) rotate([-90,-90,0]) linear_extrude(2) text("0.9", font=":bold", size=4.5, valign="center", halign="center");
        translate([15,9,7.5]) rotate([-90,-90,0]) linear_extrude(2) text("1.1", font=":bold", size=4.5, valign="center", halign="center");
    }
}