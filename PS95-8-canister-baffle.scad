$fn = 120 ;

function in2mm(mm) = mm*25.4 ;

/*  https://www.target.com/p/large-marble-utensil-holder-threshold-153/-/A-51399768
*/
CANOD     = 135             ; // in2mm(  5.25  ) ;
CANID     = 115             ; // in2mm(  4.5   ) ;

/* https://www.parts-express.com/pedocs/specs/295-349--dayton-audio-ps95-8-spec-sheet.pdf
*/
PS95OD    = 98.5 ;
PS95ID    = 77.1 ;
PS95MD    = 87.0 ;
PS95MNTZ  = 52.3 - 47.6 ;
PS95DRLID = 2 ;
PS95DRLOD = in2mm(  0.25 ) ;

BASEH     = in2mm(  0.1875) ;
BAFFLEZ   = BASEH + CANOD/4 - in2mm( 0.75 );
BCWALLT   = in2mm(  0.25  ) ;
BCWALLH   = in2mm(  0.25  ) ;
BCCONE    = BAFFLEZ - BASEH - PS95MNTZ ;
BCCOREW   = in2mm(  0.3875) ;
BCCOREH   = in2mm(  0.3875) ;

oc        = in2mm(  0.125 ) ;

// Drill holes and undermount countersink
module driver_mount_holes() {
  n = 4 ;
  h = 20 ;
  for ( i = [0:n-1] )
    rotate([0,0,45+i*360/n])
      union () {
        translate([0,PS95MD/2,-h/2])
          cylinder(r=PS95DRLID/2,h=h);
        
        translate([0,PS95MD/2,-h-BCWALLH])
          cylinder(r=PS95DRLOD/2,h=h);
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
            scale([1,1,0.36])
              sphere(CANOD/2);
          
          // Base cylindrical extension
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
      translate([0,0,-BCWALLH])
        cylinder(h=BCWALLH,r=CANID/2);
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
  
      cylinder(h=BAFFLEZ-PS95MNTZ-BCWALLH,r=(PS95ID)/2);
  
      translate([0,0,-BCWALLH-oc])
        cylinder(h=BCWALLH/2+oc,r=CANID/2-BCWALLT);
    }
    
    /*
    translate([0,0,1])
      #rotate_extrude () {
        translate([-(CANID-BCWALLT)/2,0,0])
          rotate([0,0,45])
            square([BCCOREW,BCCOREH]);
      }
    */
  }
}

// Make it so
baffle();
