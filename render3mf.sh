for order in {0..4}; do
  echo "Rendering chip $order"
  openscad -o chip${order}_base.3mf -D CHIP_ORDER=$order -D CHIP_MAT=1 crockchips.scad
  openscad -o chip${order}_accent.3mf -D CHIP_ORDER=$order -D CHIP_MAT=0 crockchips.scad
done
