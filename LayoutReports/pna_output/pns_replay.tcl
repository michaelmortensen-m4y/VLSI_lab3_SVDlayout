# reset
set_fp_rail_constraints -remove_all_layers
remove_fp_virtual_pad -all              
set_fp_rail_strategy -reset             
set_fp_block_ring_constraints -remove_all
set_fp_rail_region_constraints  -remove 
# global constraints
set_fp_rail_constraints -set_global 

# layer constraints
set_fp_rail_constraints -add_layer  -layer M6 -direction horizontal -max_strap 128 -min_strap 8 -max_width 12.000000 -min_width 0.200000 -spacing minimum 
set_fp_rail_constraints -add_layer  -layer M5 -direction vertical -max_strap 124 -min_strap 8 -max_width 12.000000 -min_width 0.200000 -spacing minimum 

# ring and strap constraints
set_fp_rail_constraints  -skip_ring -extend_strap core_ring 

# strategies
set_fp_rail_strategy  -use_tluplus true 

# block ring constraints

# regions

# virtual pads

# synthesize_fp_rail 
synthesize_fp_rail -nets { VDD } -voltage_supply 1.500000 -power_budget 1000.000000  -target_voltage_drop 200.000000 -use_pins_as_pads  
