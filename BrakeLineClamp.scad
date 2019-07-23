$fn = 180;

function in2mm(in) = in*25.4 ; 
function mm2in(mm) = mm/25.4 ; 

// User parameters
npt   = "FTC Racing";
npft  = "#10-32 1.25\"";
e     = in2mm(0.03125 ); // Fit tolerance
T     = in2mm(0.55    ); // Part Z thickness
SDIA  = in2mm(1.75    ); // Strut diameter   
BDIA  = in2mm(0.3125  ); // Brake line diameter 
WALL  = in2mm(0.375   ); // Part wall thickness 
CL    = in2mm(0.75    ); // Clamp section length
CLD   = in2mm(0.5     ); // Clamp section depth
NUTOD = in2mm(0.421875); // Nut O.D. for 1/4-20
THROD = in2mm(0.19    ); // Thread O.D. for 1/4-20

LAPA  =       10       ; // Lap angle

// Derived parameters
SPC   = CL+(SDIA+BDIA)/2 ;
ULOA  = CL+SDIA/2+BDIA+WALL ;
LLOA  = 0 +SDIA/2+0   +WALL ;
LOA   = ULOA+LLOA ;

// Geometry maniplation 
oc    = in2mm(0.125   ); // Subtraction overcut

// Hex nut generator
module hexagon(r,h,e) {
  n = 6;
  hull() {
    for (i = [0:n-1])
      rotate([0,0,i*360/n])
        translate([0,r,0])
          cylinder(r=e,h=h);
  }
}

// Bolt and nut clearance
module bolt_clearance() {
  translate([0,0,-oc])
    cylinder(r=THROD/2,h=CLD+2*oc);
  
  translate([0,0,CLD])
    hexagon(NUTOD/2,(SDIA-BDIA)/2,e/2);
}

// Nameplate
module nameplate(scale) {
  linear_extrude(height=oc) {
    scale([scale,scale,1])
      union() {
        translate([-6,5,0])
          text(str(npt),size=6,font="Impact");
        translate([-10,-5,0])
          text(str(npft),size=6,font="Impact");
        translate([-14,-15,0])
          text(str(
            mm2in(BDIA),"\"/",
            mm2in(SDIA),"\""),size=6,font="Impact");
      }
  }
}

// Brake clamp model
module brake_clamp() {
  difference () {
    hull () {
      translate([0,0,-T/2]) 
        cylinder(r=SDIA/2+WALL,h=T);
      translate([0,SPC,-T/2]) 
        cylinder(r=BDIA/2+WALL,h=T);
    }
    translate([0,0,-T/2-oc])             
      cylinder(r=(SDIA+e)/2,h=T+2*oc);
    
    translate([0,SPC,-T/2-oc])    
      cylinder(r=(BDIA+e)/2,h=T+2*oc);
    
    translate([-e,0,-T/2-oc])
      cube([SDIA/2+WALL+e+oc,ULOA+2*oc,T+2*oc]);

    // Lap cut 1
    rotate([0,0,LAPA])
      translate([-e/2,-SDIA/2-WALL-oc,-T/2-oc])
        cube([SDIA/2+WALL+oc,LLOA+2*oc,T/2+2*oc]);
    
    // Lap cut 2
    rotate([0,0,-LAPA])
      translate([-e/2,-SDIA/2-WALL-oc,0])
        cube([SDIA/2+WALL+oc,LOA+2*oc,T/2+2*oc]);

    // Bolt cutout
    translate([0,(CL+SDIA)/2,0])
      rotate([180,90,0])
        bolt_clearance();
        
    // Nameplate
    #translate([-14,(CL+SDIA)/2,T/2-oc/2])
      nameplate(0.4);
  }
}

// Do the do
brake_clamp();  
