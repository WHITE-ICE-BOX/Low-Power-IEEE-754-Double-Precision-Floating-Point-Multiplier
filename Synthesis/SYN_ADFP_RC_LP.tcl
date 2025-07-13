###########################################################################
## Set RTL-Compiler Global Variables and Options                      ##
###########################################################################
## Information Level ##
#set_attr information_level 9
set_attr hdl_track_filename_row_col true /
set_attr remove_assigns true

## LPS: Clock Gating/Operand Isolation ##
set_attr lp_insert_discrete_clock_gating_logic true /
set_attr lp_insert_clock_gating true /

## Specified library ##
set_attr library {N16ADFP_StdCellsS0p72v125c_ccs.lib} /

## Setup Wireload Mode: PLE ##
set_attr interconnect_mode ple /
set_attribute lef_library {N16ADFP_APR_Innovus_11M.10a.tlef N16ADFP_StdCell.lef} /
set_attribute qrc_tech_file {qrcTechFile} /

###########################################################################
## Define Design TOP module name                                        ##
###########################################################################
set DESIGN "FP_MUL"

###########################################################################
## Read Verilog RTL source file                                         ##
###########################################################################
read_hdl -v2001 ../RTL/$DESIGN.v
elaborate $DESIGN

###########################################################################
## Define Design Constraints                                            ##
###########################################################################
## Read SDC Constraints ##
read_sdc SYN_RTL.sdc

## Power Constraints ##
set_attr lp_power_optimization_weight 0.1 /designs/$DESIGN
set_attr leakage_power_effort low
set_attr max_leakage_power 0.0 /designs/$DESIGN
set_attr max_dynamic_power 0.0 /designs/$DESIGN

## Read Switching Activities ##
read_tcf ../RTL/${DESIGN}_rtl.tcf

###########################################################################
## Optimize design                                                       ##
###########################################################################
set_remove_assign_options -dont_respect_boundary_optimization -ignore_preserve_setting -dont_skip_unconstrained_paths
syn_generic
syn_map

###########################################################################
## Change netlist naming rule                                           ##
###########################################################################
change_names -allowed "a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 _ \[ \]"

###########################################################################
## Report design timing, area and power                                 ##
###########################################################################
report area > report.area
report timing > report.timing
report power > report.power
report clock_gating > report.clock_gating
report summary > report.summary
report datapath > report.datapath

###########################################################################
## 1. Save Netlist and SDF/SDC Files                                     ##
###########################################################################
write_hdl > ../Netlist_syn/${DESIGN}_syn.v
write_sdf -version {OVI 3.0} -interconn interconnect -nosplit_timing_check -edges check_edge -no_escape -nonegchecks -delimiter / -recrm merge_when_paired -design $DESIGN > ../Netlist_syn/${DESIGN}.sdf
write_sdc > ../Netlist_syn/${DESIGN}.sdc

## Exit ##
quit
