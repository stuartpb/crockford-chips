alphabet = [
  "O","1","2","3","4","5","6","7",
  "8","9","A","B","C","D","E","F",
  "G","H","J","K","M","N","P","Q",
  "R","S","T","V","W","X","Y","Z"];
chip_diam = 40;
chip_center_diam = 8;
chip_thickness = 3.5;
chip_rim_font = "Inconsolata:style=Expanded Black";
chip_decal_font = "Inconsolata:style=Expanded Black";
ring_r = (chip_diam - chip_center_diam) / 10;

module chip_label(string, size, font) {
  text(string, size, font, halign = "center", valign = "center");
}

module face_rings(order,arity) {
  rotate(11.25) difference() {
    circle(d = chip_diam);
  }
}

module chip_labels(order,arity) {
  chip = 2 ^ order;
  for (i = [0:15]) {
    rotate(-22.5*i) translate([0,chip_diam/2-ring_r/2])
      chip_label(alphabet[i+chip*(floor(i/chip)+arity)], ring_r, chip_rim_font);
  }
  if (arity) {
    chip_label(alphabet[chip],chip_center_diam,chip_decal_font);
  } else {
    chip_label(alphabet[0],chip_center_diam,chip_decal_font);
    rotate(-45) translate([0,chip_center_diam-ring_r]) rotate(45)
      chip_label(alphabet[order],2,chip_decal_font);
  }
}

chip_labels(0,1);
