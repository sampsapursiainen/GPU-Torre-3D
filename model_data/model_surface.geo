
Mesh.CharacteristicLengthExtendFromBoundary = 1;
Mesh.CharacteristicLengthFactor = 1;
Mesh.CharacteristicLengthMin = 0.01;
Mesh.CharacteristicLengthMax = 0.06;
Mesh.Optimize = 1
Mesh.OptimizeNetgen = 1;
Mesh.Algorithm = 2; 
Mesh.Algorithm3D = 10;


lcar0 = 0.012;
lcar1 = 0.02;
lcar2 = 0.03;
r_1 = 0.19;
r_2 = 0.40;

Merge "model_surface.stl";
asteroid_surface_loop = newreg;
asteroid_volume = newreg;

Surface Loop(asteroid_surface_loop) = {1};

// Makes hole in model for the asteroid
Function CheeseHole

p1 = newp; Point(p1) = {x,  y,  z,  lcar0} ;
  p2 = newp; Point(p2) = {x+r_1,y,  z,  lcar1} ;
  p3 = newp; Point(p3) = {x,  y+r_1,z,  lcar1} ;
  p4 = newp; Point(p4) = {x,  y,  z+r_1,lcar1} ;
  p5 = newp; Point(p5) = {x-r_1,y,  z,  lcar1} ;
  p6 = newp; Point(p6) = {x,  y-r_1,z,  lcar1} ;
  p7 = newp; Point(p7) = {x,  y,  z-r_1,lcar1} ;

  c1 = newreg; Circle(c1) = {p2,p1,p7};
  c2 = newreg; Circle(c2) = {p7,p1,p5};
  c3 = newreg; Circle(c3) = {p5,p1,p4};
  c4 = newreg; Circle(c4) = {p4,p1,p2};
  c5 = newreg; Circle(c5) = {p2,p1,p3};
  c6 = newreg; Circle(c6) = {p3,p1,p5};
  c7 = newreg; Circle(c7) = {p5,p1,p6};
  c8 = newreg; Circle(c8) = {p6,p1,p2};
  c9 = newreg; Circle(c9) = {p7,p1,p3};
  c10 = newreg; Circle(c10) = {p3,p1,p4};
  c11 = newreg; Circle(c11) = {p4,p1,p6};
  c12 = newreg; Circle(c12) = {p6,p1,p7};

  // We need non-plane surfaces to define the spherical holes. Here we
  // use ruled surfaces, which can have 3 or 4 sides:

  l1 = newreg; Line Loop(l1) = {c5,c10,c4};   Surface(newreg) = {l1};
  l2 = newreg; Line Loop(l2) = {c9,-c5,c1};   Surface(newreg) = {l2};
  l3 = newreg; Line Loop(l3) = {c12,-c8,-c1}; Surface(newreg) = {l3};
  l4 = newreg; Line Loop(l4) = {c8,-c4,c11};  Surface(newreg) = {l4};
  l5 = newreg; Line Loop(l5) = {-c10,c6,c3};  Surface(newreg) = {l5};
  l6 = newreg; Line Loop(l6) = {-c11,-c3,c7}; Surface(newreg) = {l6};
  l7 = newreg; Line Loop(l7) = {-c2,-c7,-c12}; Surface(newreg) = {l7};
  l8 = newreg; Line Loop(l8) = {-c6,-c9,c2};  Surface(newreg) = {l8};

  // We then store the surface loops identification numbers in a list
  // for later reference (we will need these to define the final
  // volume):

  theloops[t] = newreg ;

  Surface Loop(theloops[t]) = {l8+1,l5+1,l1+1,l2+1,l3+1,l7+1,l6+1,l4+1};

Return

// Outer surface and volume
//Volume(asteroid_volume) = {asteroid_surface_loop, asteroid_surface_loop_scaled};
Volume(asteroid_volume) = {asteroid_surface_loop};
Physical Volume(1) = asteroid_volume;

Point(117) = {-r_2,-r_2,-r_2,lcar2};
Point(118) = {r_2,-r_2,-r_2,lcar2};
Point(119) = {r_2,r_2,-r_2,lcar2};
Point(120) = {-r_2,r_2,-r_2,lcar2};
Point(121) = {-r_2,-r_2,r_2,lcar2};
Point(122) = {r_2,-r_2,r_2,lcar2};
Point(123) = {r_2,r_2,r_2,lcar2};
Point(124) = {-r_2,r_2,r_2,lcar2};

Line(125) = {117,118};    Line(126) = {118,119};  Line(127) = {119,120};
Line(128) = {120,117};   Line(129) = {121,122};  Line(130) = {122,123};
Line(131) = {123,124};  Line(132) = {124,121}; Line(133) = {117,121};
Line(134) = {118,122};  Line(135) = {119,123};  Line(136) = {120,124};

Line Loop(162) = {125,126,127,128};   Plane Surface(163) = {162};
Line Loop(164) = {129,130,131,132};       Plane Surface(165) = {164};
Line Loop(166) = {125,134,-129,-133}; Plane Surface(167) = {166};
Line Loop(168) = {126,135,-130,-134};       Plane Surface(169) = {168};
Line Loop(170) = {127,136,-131,-135};        Plane Surface(171) = {170};
Line Loop(172) = {128,133,-132,-136};  Plane Surface(173) = {172};

cube1_surface_loop = newreg;
Surface Loop(cube1_surface_loop) = {163,165,167,169,171,173};

// Define parameters for cheesehole
x = 0 ; y = 0 ; z = 0 ;
t = 1; 

Call CheeseHole ;

orbits_volume = newreg;
Volume(orbits_volume) = {theloops[1], asteroid_surface_loop};
Physical Volume (2) = orbits_volume;

cube1_volume = newreg;
Volume(cube1_volume) = {cube1_surface_loop, theloops[1]};
Physical Volume (3) = cube1_volume ;

Coherence;
