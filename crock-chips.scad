alphabet = [
  "O","1","2","3","4","5","6","7",
  "8","9","A","B","C","D","E","F",
  "G","H","J","K","M","N","P","Q",
  "R","S","T","V","W","X","Y","Z"];
chip_diam = 40;
chip_center_diam = 10;
chip_thickness = 3.5;
rim_font = "Inconsolata:style=Expanded Black";
rim_radius = 4;
rim_digit_size = 3;
decal_font = "Inconsolata:style=Expanded Black";
decal_digit_size = 8;
detail_inset = 0.4;

bounds = chip_diam * 2;
ring_r = (chip_diam/2 - chip_center_diam/2 - rim_radius) / 4;

module pinwheel(order) {
  if (order == 1) {
    translate([-bounds/2,-bounds/2])
      square([bounds,bounds/2]);
  } else {
    verts = 2^order;
    union() for (i=[0:2:verts-1]) {
      polygon([
        [0,0],
        [sin(360/verts*i)*bounds,cos(360/verts*i)*bounds],
        [sin(360/verts*(i+1))*bounds,cos(360/verts*(i+1))*bounds],
      ]);
    }
  }
}

module face_rings(order,bit) {
  rotate(11.25) difference() {
    circle(d = chip_diam);
  }
}

module chip_label(string, size, font) {
  text(string, size, font, halign = "center", valign = "center");
}

module chip_edge_labels(order,bit,pos) {
  chip = 2 ^ order;
  for (i = [pos:2:15]) {
    rotate(-22.5*i) translate([0,chip_diam/2-rim_radius/2])
      chip_label(alphabet[i+chip*(floor(i/chip)+bit)],
        rim_digit_size, rim_font);
  }
}
module chip_base() {
  cylinder(h=chip_thickness, d=chip_diam, center=true);
}
module chip_neg(order) {
  inset_height = chip_thickness/2 - detail_inset;
  translate([0,0,inset_height])
    linear_extrude(2*detail_inset) union () {
      chip_edge_labels(order,1,0);
      difference() {
        rotate(-11.25) pinwheel(4);
        circle(r=chip_diam/2-rim_radius);
        chip_edge_labels(order,1,1);
      }
      difference() {
        circle(d=chip_center_diam);
        chip_label(alphabet[2^order],
          decal_digit_size,decal_font);
      }
    }
  rotate([180,0,0]) translate([0,0,inset_height])
    linear_extrude(2*detail_inset) union () {
      chip_edge_labels(order,0,0);
      difference() {
        rotate(-11.25) pinwheel(4);
        circle(r=chip_diam/2-rim_radius);
        chip_edge_labels(order,0,1);
      }
      chip_label(alphabet[0],decal_digit_size,decal_font);
      translate([decal_digit_size/2,decal_digit_size/2])
        chip_label(alphabet[order],rim_digit_size,decal_font);
    }
}
module chip_detail(order) {
  intersection() {
    chip_base();
    chip_neg(order);
  }
}
module chip_body(order,bcolor="black") {
  difference() {
    color(bcolor) chip_base();
    color("white") chip_neg(order);
  }
}
module showcase() {
  translate([-chip_diam*3,0,0]) chip_body(4,"gold");
  translate([-chip_diam*1.5,0,0]) chip_body(3,"black");
  chip_body(2,"red");
  translate([chip_diam*1.5,0,0]) chip_body(1,"green");
  translate([chip_diam*3,0,0]) chip_body(0,"blue");
}

CHIP_ORDER=-1;
CHIP_DETAIL=0;
if (CHIP_ORDER>-1) {
  if (CHIP_DETAIL) chip_detail(CHIP_ORDER);
  else chip_body(CHIP_ORDER); 
} else {
  showcase();
}
