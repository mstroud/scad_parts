$fn = 60 ;

function in2mm(mm) = mm*25.4 ;

CANOD     = in2mm(  5.25  ) ;
CANID     = in2mm(  4.5   ) ;
BASEH     = in2mm(  0.25  ) ;

PS95OD    = 98.5 ;
PS95ID    = 77.1 ;
PS95MD    = 87.0 ;
PS95MNTZ  = 52.3 - 47.6 ;
PS95DRL   = 2 ;

BAFFLEZ   = BASEH + CANOD/4 - in2mm( 0.75 );
BCWALL    = in2mm(  0.25 ) ;

oc        = in2mm(  0.125 ) ;

// Drill holes and undermount countersink
module driver_mount_holes() {
  n = 4 ;
  h = 20 ;
  for ( i = [0:n-1] )
    rotate([0,0,45+i*360/n])
      union () {
        translate([0,PS95MD/2,-h/2])
          cylinder(r=PS95DRL,h=h);
        
        translate([0,PS95MD/2,-h-BASEH])
          cylinder(r=PS95DRL*2,h=h);
      }
}

// Main baffle
module baffle() {
  difference () {
    // Main body
    union () {
      difference () {
        union () {
          translate([0,0,BASEH])
            scale([1,1,0.5])
              sphere(CANOD/2);
      
          cylinder(r=CANOD/2,h=BASEH);
        }
    
        // Bottom clipping plane
        translate([-CANOD/2,-CANOD/2,-CANOD])
          cube(CANOD);
    
        // Top clipping plane 
        translate([-CANOD/2,-CANOD/2,BAFFLEZ])
          cube(CANOD);
      }
  
      // Canister lip tab
      translate([0,0,-BASEH])
        cylinder(h=BASEH,r=CANID/2);
    }  
    
    // Mount hole drilling
    translate([0,0,BAFFLEZ-PS95MNTZ])
      driver_mount_holes();
    
    // Driver recess rabbet
    translate([0,0,BAFFLEZ-PS95MNTZ])
      cylinder(h=BAFFLEZ+oc,r=PS95OD/2);
  
    // Driver through-hole
    translate([0,0,-BASEH-oc])
      cylinder(h=BASEH+BAFFLEZ+2*oc,r=PS95ID/2);
  
    // Cone chamfered undershelf for driver
    hull() {
  
      cylinder(h=BAFFLEZ-2*BASEH+oc,r=PS95ID/2);
  
      translate([0,0,-BASEH-oc])
        cylinder(h=BASEH+oc,r=CANID/2-BCWALL);
    }
  }
}

// Make it so
baffle();
