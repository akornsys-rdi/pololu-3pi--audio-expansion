$fn=36;

*stencil();
*support();

module support() {
    difference() {
        union() {
            cube([70,60,2]);
            translate([18.01876,80-26.1493,2]) hull() {
                cylinder(r=1.1, h=14);
                translate([(48.02124-18.01876),0,0]) cylinder(r=1.1, h=14);
            }
            translate([18.01876,80-26.1493,2]) cylinder(r=1.1, h=14+1);
            translate([25.51938,80-26.1493,2]) cylinder(r=1.1, h=14+1);
            translate([33.02,80-26.1493,2]) cylinder(r=1.1, h=14+1);
            translate([40.52062,80-26.1493,2]) cylinder(r=1.1, h=14+1);
            translate([48.02124,80-26.1493,2]) cylinder(r=1.1, h=14+1);
            translate([63.01994,80-74.44994,2]) cylinder(r=2, h=14);
            translate([63.01994,80-74.44994,2]) cylinder(r=1.1, h=14+1);
            translate([3.02006,80-74.44994,2]) cylinder(r=2, h=14);
            translate([3.02006,80-74.44994,2]) cylinder(r=1.1, h=14+1);
        }
        translate([10,10,-2]) cube([50,35,6]);
    }
}

module stencil() {
    difference() {
        union() {
            cube([70,80,2]);
            translate([3.51,80-57.785,2]) support_1x2();
            translate([55.88,80-71.755,2]) support_1x2();
            translate([27.94,80-32.385,2]) support_2x3();
            translate([22.86,80-19.685,2]) support_2x3();
            union() {
                translate([18.01876,80-26.1493,2]) hull() {
                    cylinder(r=1.1, h=3.75);
                    translate([(48.02124-18.01876),0,0]) cylinder(r=1.1, h=3.75);
                }
                translate([18.01876,80-26.1493,2]) cylinder(r=1.1, h=3.75+1);
                translate([25.51938,80-26.1493,2]) cylinder(r=1.1, h=3.75+1);
                translate([33.02,80-26.1493,2]) cylinder(r=1.1, h=3.75+1);
                translate([40.52062,80-26.1493,2]) cylinder(r=1.1, h=3.75+1);
                translate([48.02124,80-26.1493,2]) cylinder(r=1.1, h=3.75+1);
                translate([63.01994,80-74.44994,2]) cylinder(r=2, h=3.75);
                translate([63.01994,80-74.44994,2]) cylinder(r=1.1, h=3.75+1);
                translate([3.02006,80-74.44994,2]) cylinder(r=2, h=3.75);
                translate([3.02006,80-74.44994,2]) cylinder(r=1.1, h=3.75+1);
            }
        }
        union() {
            union() {
                translate([3.51,80-57.785,-1]) conn_1x2();
                translate([55.88,80-71.755,-1]) conn_1x2();
                translate([27.94,80-32.385,-1]) rotate([0,0,180]) conn_2x3();
                translate([22.86,80-19.685,-1]) conn_2x3();
            }
            union() {
                translate([10,-1,-1]) cube([40,40,6]);
                translate([60,10,-1]) cube([11,55,6]);
                translate([10,80-32.385+1.27-2.54-8,-1]) cube([40,8,6]);
                translate([-1,80-19.685+1.27,-1]) cube([72,20,6]);
            }
        }
    }
}

module support_1x2() {
    cylinder(r1=2, r2=1, h=2);
    translate([0,-2.54,0]) cylinder(r1=2, r2=1, h=2);
}

module support_2x3() {
    translate([-2.54,1.27,0]) union() {
        cylinder(r1=2, r2=1, h=2);
        translate([2.54,0,0]) cylinder(r1=2, r2=1, h=2);
        translate([5.08,0,0]) cylinder(r1=2, r2=1, h=2);
        translate([0,-2.54,0]) cylinder(r1=2, r2=1, h=2);
        translate([2.54,-2.54,0]) cylinder(r1=2, r2=1, h=2);
        translate([5.08,-2.54,0]) cylinder(r1=2, r2=1, h=2);
    }
}

module conn_1x2() {
    cylinder(r=0.5, h=6);
    translate([0,-2.54,0]) cylinder(r=0.5, h=6);
}

module conn_2x3() {
    translate([-2.54,1.27,0]) union() {
        cylinder(r=1, h=6);
        translate([2.54,0,0]) cylinder(r=1, h=6);
        translate([5.08,0,0]) cylinder(r=1, h=6);
        translate([0,-2.54,0]) cylinder(r=0.5, h=6);
        translate([2.54,-2.54,0]) cylinder(r=0.5, h=6);
        translate([5.08,-2.54,0]) cylinder(r=0.5, h=6);
    }
}