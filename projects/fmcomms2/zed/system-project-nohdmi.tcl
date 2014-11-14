
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2013.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD em.avnet.com:zynq:zed:d [current_project]


# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
if { ${design_name} ne "" && ${cur_design} eq ${design_name} } {
   # Checks if design is empty or not
   set list_cells [get_bd_cells -quiet]

   if { $list_cells ne "" } {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 1
   } else {
      puts "INFO: Constructing design in IPI design <$design_name>..."
   }
} else {

   if { [get_files -quiet ${design_name}.bd] eq "" } {
      puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

      create_bd_design $design_name

      puts "INFO: Making design <$design_name> as current_bd_design."
      current_bd_design $design_name

   } else {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 3
   }

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: sys_wfifo_3
proc create_hier_cell_sys_wfifo_3 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_sys_wfifo_3() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk m_clk
  create_bd_pin -dir I -from 15 -to 0 m_wdata
  create_bd_pin -dir O m_wovf
  create_bd_pin -dir I m_wr
  create_bd_pin -dir I -from 0 -to 0 rstn
  create_bd_pin -dir I -type clk s_clk
  create_bd_pin -dir O -from 15 -to 0 s_wdata
  create_bd_pin -dir I s_wovf
  create_bd_pin -dir O s_wr

  # Create instance: wfifo_ctl, and set properties
  set wfifo_ctl [ create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 wfifo_ctl ]
  set_property -dict [ list CONFIG.M_DATA_WIDTH {16} CONFIG.S_DATA_WIDTH {16}  ] $wfifo_ctl

  # Create instance: wfifo_mem, and set properties
  set wfifo_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:11.0 wfifo_mem ]
  set_property -dict [ list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} CONFIG.INTERFACE_TYPE {Native} CONFIG.Input_Data_Width {16} CONFIG.Input_Depth {64} CONFIG.Output_Data_Width {16} CONFIG.Overflow_Flag {true}  ] $wfifo_mem

  # Create port connections
  connect_bd_net -net m_clk [get_bd_pins m_clk] [get_bd_pins wfifo_ctl/m_clk] [get_bd_pins wfifo_mem/wr_clk]
  connect_bd_net -net m_wdata [get_bd_pins m_wdata] [get_bd_pins wfifo_ctl/m_wdata]
  connect_bd_net -net m_wovf [get_bd_pins m_wovf] [get_bd_pins wfifo_ctl/m_wovf]
  connect_bd_net -net m_wr [get_bd_pins m_wr] [get_bd_pins wfifo_ctl/m_wr]
  connect_bd_net -net rstn [get_bd_pins rstn] [get_bd_pins wfifo_ctl/rstn]
  connect_bd_net -net s_clk [get_bd_pins s_clk] [get_bd_pins wfifo_ctl/s_clk] [get_bd_pins wfifo_mem/rd_clk]
  connect_bd_net -net s_wdata [get_bd_pins s_wdata] [get_bd_pins wfifo_ctl/s_wdata]
  connect_bd_net -net s_wovf [get_bd_pins s_wovf] [get_bd_pins wfifo_ctl/s_wovf]
  connect_bd_net -net s_wr [get_bd_pins s_wr] [get_bd_pins wfifo_ctl/s_wr]
  connect_bd_net -net wfifo_ctl_fifo_rd [get_bd_pins wfifo_ctl/fifo_rd] [get_bd_pins wfifo_mem/rd_en]
  connect_bd_net -net wfifo_ctl_fifo_rdata [get_bd_pins wfifo_ctl/fifo_rdata] [get_bd_pins wfifo_mem/dout]
  connect_bd_net -net wfifo_ctl_fifo_rempty [get_bd_pins wfifo_ctl/fifo_rempty] [get_bd_pins wfifo_mem/empty]
  connect_bd_net -net wfifo_ctl_fifo_rst [get_bd_pins wfifo_ctl/fifo_rst] [get_bd_pins wfifo_mem/rst]
  connect_bd_net -net wfifo_ctl_fifo_wdata [get_bd_pins wfifo_ctl/fifo_wdata] [get_bd_pins wfifo_mem/din]
  connect_bd_net -net wfifo_ctl_fifo_wfull [get_bd_pins wfifo_ctl/fifo_wfull] [get_bd_pins wfifo_mem/full]
  connect_bd_net -net wfifo_ctl_fifo_wovf [get_bd_pins wfifo_ctl/fifo_wovf] [get_bd_pins wfifo_mem/overflow]
  connect_bd_net -net wfifo_ctl_fifo_wr [get_bd_pins wfifo_ctl/fifo_wr] [get_bd_pins wfifo_mem/wr_en]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sys_wfifo_2
proc create_hier_cell_sys_wfifo_2 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_sys_wfifo_2() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk m_clk
  create_bd_pin -dir I -from 15 -to 0 m_wdata
  create_bd_pin -dir O m_wovf
  create_bd_pin -dir I m_wr
  create_bd_pin -dir I -from 0 -to 0 rstn
  create_bd_pin -dir I -type clk s_clk
  create_bd_pin -dir O -from 15 -to 0 s_wdata
  create_bd_pin -dir I s_wovf
  create_bd_pin -dir O s_wr

  # Create instance: wfifo_ctl, and set properties
  set wfifo_ctl [ create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 wfifo_ctl ]
  set_property -dict [ list CONFIG.M_DATA_WIDTH {16} CONFIG.S_DATA_WIDTH {16}  ] $wfifo_ctl

  # Create instance: wfifo_mem, and set properties
  set wfifo_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:11.0 wfifo_mem ]
  set_property -dict [ list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} CONFIG.INTERFACE_TYPE {Native} CONFIG.Input_Data_Width {16} CONFIG.Input_Depth {64} CONFIG.Output_Data_Width {16} CONFIG.Overflow_Flag {true}  ] $wfifo_mem

  # Create port connections
  connect_bd_net -net m_clk [get_bd_pins m_clk] [get_bd_pins wfifo_ctl/m_clk] [get_bd_pins wfifo_mem/wr_clk]
  connect_bd_net -net m_wdata [get_bd_pins m_wdata] [get_bd_pins wfifo_ctl/m_wdata]
  connect_bd_net -net m_wovf [get_bd_pins m_wovf] [get_bd_pins wfifo_ctl/m_wovf]
  connect_bd_net -net m_wr [get_bd_pins m_wr] [get_bd_pins wfifo_ctl/m_wr]
  connect_bd_net -net rstn [get_bd_pins rstn] [get_bd_pins wfifo_ctl/rstn]
  connect_bd_net -net s_clk [get_bd_pins s_clk] [get_bd_pins wfifo_ctl/s_clk] [get_bd_pins wfifo_mem/rd_clk]
  connect_bd_net -net s_wdata [get_bd_pins s_wdata] [get_bd_pins wfifo_ctl/s_wdata]
  connect_bd_net -net s_wovf [get_bd_pins s_wovf] [get_bd_pins wfifo_ctl/s_wovf]
  connect_bd_net -net s_wr [get_bd_pins s_wr] [get_bd_pins wfifo_ctl/s_wr]
  connect_bd_net -net wfifo_ctl_fifo_rd [get_bd_pins wfifo_ctl/fifo_rd] [get_bd_pins wfifo_mem/rd_en]
  connect_bd_net -net wfifo_ctl_fifo_rdata [get_bd_pins wfifo_ctl/fifo_rdata] [get_bd_pins wfifo_mem/dout]
  connect_bd_net -net wfifo_ctl_fifo_rempty [get_bd_pins wfifo_ctl/fifo_rempty] [get_bd_pins wfifo_mem/empty]
  connect_bd_net -net wfifo_ctl_fifo_rst [get_bd_pins wfifo_ctl/fifo_rst] [get_bd_pins wfifo_mem/rst]
  connect_bd_net -net wfifo_ctl_fifo_wdata [get_bd_pins wfifo_ctl/fifo_wdata] [get_bd_pins wfifo_mem/din]
  connect_bd_net -net wfifo_ctl_fifo_wfull [get_bd_pins wfifo_ctl/fifo_wfull] [get_bd_pins wfifo_mem/full]
  connect_bd_net -net wfifo_ctl_fifo_wovf [get_bd_pins wfifo_ctl/fifo_wovf] [get_bd_pins wfifo_mem/overflow]
  connect_bd_net -net wfifo_ctl_fifo_wr [get_bd_pins wfifo_ctl/fifo_wr] [get_bd_pins wfifo_mem/wr_en]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sys_wfifo_1
proc create_hier_cell_sys_wfifo_1 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_sys_wfifo_1() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk m_clk
  create_bd_pin -dir I -from 15 -to 0 m_wdata
  create_bd_pin -dir O m_wovf
  create_bd_pin -dir I m_wr
  create_bd_pin -dir I -from 0 -to 0 rstn
  create_bd_pin -dir I -type clk s_clk
  create_bd_pin -dir O -from 15 -to 0 s_wdata
  create_bd_pin -dir I s_wovf
  create_bd_pin -dir O s_wr

  # Create instance: wfifo_ctl, and set properties
  set wfifo_ctl [ create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 wfifo_ctl ]
  set_property -dict [ list CONFIG.M_DATA_WIDTH {16} CONFIG.S_DATA_WIDTH {16}  ] $wfifo_ctl

  # Create instance: wfifo_mem, and set properties
  set wfifo_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:11.0 wfifo_mem ]
  set_property -dict [ list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} CONFIG.INTERFACE_TYPE {Native} CONFIG.Input_Data_Width {16} CONFIG.Input_Depth {64} CONFIG.Output_Data_Width {16} CONFIG.Overflow_Flag {true}  ] $wfifo_mem

  # Create port connections
  connect_bd_net -net m_clk [get_bd_pins m_clk] [get_bd_pins wfifo_ctl/m_clk] [get_bd_pins wfifo_mem/wr_clk]
  connect_bd_net -net m_wdata [get_bd_pins m_wdata] [get_bd_pins wfifo_ctl/m_wdata]
  connect_bd_net -net m_wovf [get_bd_pins m_wovf] [get_bd_pins wfifo_ctl/m_wovf]
  connect_bd_net -net m_wr [get_bd_pins m_wr] [get_bd_pins wfifo_ctl/m_wr]
  connect_bd_net -net rstn [get_bd_pins rstn] [get_bd_pins wfifo_ctl/rstn]
  connect_bd_net -net s_clk [get_bd_pins s_clk] [get_bd_pins wfifo_ctl/s_clk] [get_bd_pins wfifo_mem/rd_clk]
  connect_bd_net -net s_wdata [get_bd_pins s_wdata] [get_bd_pins wfifo_ctl/s_wdata]
  connect_bd_net -net s_wovf [get_bd_pins s_wovf] [get_bd_pins wfifo_ctl/s_wovf]
  connect_bd_net -net s_wr [get_bd_pins s_wr] [get_bd_pins wfifo_ctl/s_wr]
  connect_bd_net -net wfifo_ctl_fifo_rd [get_bd_pins wfifo_ctl/fifo_rd] [get_bd_pins wfifo_mem/rd_en]
  connect_bd_net -net wfifo_ctl_fifo_rdata [get_bd_pins wfifo_ctl/fifo_rdata] [get_bd_pins wfifo_mem/dout]
  connect_bd_net -net wfifo_ctl_fifo_rempty [get_bd_pins wfifo_ctl/fifo_rempty] [get_bd_pins wfifo_mem/empty]
  connect_bd_net -net wfifo_ctl_fifo_rst [get_bd_pins wfifo_ctl/fifo_rst] [get_bd_pins wfifo_mem/rst]
  connect_bd_net -net wfifo_ctl_fifo_wdata [get_bd_pins wfifo_ctl/fifo_wdata] [get_bd_pins wfifo_mem/din]
  connect_bd_net -net wfifo_ctl_fifo_wfull [get_bd_pins wfifo_ctl/fifo_wfull] [get_bd_pins wfifo_mem/full]
  connect_bd_net -net wfifo_ctl_fifo_wovf [get_bd_pins wfifo_ctl/fifo_wovf] [get_bd_pins wfifo_mem/overflow]
  connect_bd_net -net wfifo_ctl_fifo_wr [get_bd_pins wfifo_ctl/fifo_wr] [get_bd_pins wfifo_mem/wr_en]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sys_wfifo_0
proc create_hier_cell_sys_wfifo_0 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_sys_wfifo_0() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk m_clk
  create_bd_pin -dir I -from 15 -to 0 m_wdata
  create_bd_pin -dir O m_wovf
  create_bd_pin -dir I m_wr
  create_bd_pin -dir I -from 0 -to 0 rstn
  create_bd_pin -dir I -type clk s_clk
  create_bd_pin -dir O -from 15 -to 0 s_wdata
  create_bd_pin -dir I s_wovf
  create_bd_pin -dir O s_wr

  # Create instance: wfifo_ctl, and set properties
  set wfifo_ctl [ create_bd_cell -type ip -vlnv analog.com:user:util_wfifo:1.0 wfifo_ctl ]
  set_property -dict [ list CONFIG.M_DATA_WIDTH {16} CONFIG.S_DATA_WIDTH {16}  ] $wfifo_ctl

  # Create instance: wfifo_mem, and set properties
  set wfifo_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:11.0 wfifo_mem ]
  set_property -dict [ list CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} CONFIG.INTERFACE_TYPE {Native} CONFIG.Input_Data_Width {16} CONFIG.Input_Depth {64} CONFIG.Output_Data_Width {16} CONFIG.Overflow_Flag {true}  ] $wfifo_mem

  # Create port connections
  connect_bd_net -net m_clk [get_bd_pins m_clk] [get_bd_pins wfifo_ctl/m_clk] [get_bd_pins wfifo_mem/wr_clk]
  connect_bd_net -net m_wdata [get_bd_pins m_wdata] [get_bd_pins wfifo_ctl/m_wdata]
  connect_bd_net -net m_wovf [get_bd_pins m_wovf] [get_bd_pins wfifo_ctl/m_wovf]
  connect_bd_net -net m_wr [get_bd_pins m_wr] [get_bd_pins wfifo_ctl/m_wr]
  connect_bd_net -net rstn [get_bd_pins rstn] [get_bd_pins wfifo_ctl/rstn]
  connect_bd_net -net s_clk [get_bd_pins s_clk] [get_bd_pins wfifo_ctl/s_clk] [get_bd_pins wfifo_mem/rd_clk]
  connect_bd_net -net s_wdata [get_bd_pins s_wdata] [get_bd_pins wfifo_ctl/s_wdata]
  connect_bd_net -net s_wovf [get_bd_pins s_wovf] [get_bd_pins wfifo_ctl/s_wovf]
  connect_bd_net -net s_wr [get_bd_pins s_wr] [get_bd_pins wfifo_ctl/s_wr]
  connect_bd_net -net wfifo_ctl_fifo_rd [get_bd_pins wfifo_ctl/fifo_rd] [get_bd_pins wfifo_mem/rd_en]
  connect_bd_net -net wfifo_ctl_fifo_rdata [get_bd_pins wfifo_ctl/fifo_rdata] [get_bd_pins wfifo_mem/dout]
  connect_bd_net -net wfifo_ctl_fifo_rempty [get_bd_pins wfifo_ctl/fifo_rempty] [get_bd_pins wfifo_mem/empty]
  connect_bd_net -net wfifo_ctl_fifo_rst [get_bd_pins wfifo_ctl/fifo_rst] [get_bd_pins wfifo_mem/rst]
  connect_bd_net -net wfifo_ctl_fifo_wdata [get_bd_pins wfifo_ctl/fifo_wdata] [get_bd_pins wfifo_mem/din]
  connect_bd_net -net wfifo_ctl_fifo_wfull [get_bd_pins wfifo_ctl/fifo_wfull] [get_bd_pins wfifo_mem/full]
  connect_bd_net -net wfifo_ctl_fifo_wovf [get_bd_pins wfifo_ctl/fifo_wovf] [get_bd_pins wfifo_mem/overflow]
  connect_bd_net -net wfifo_ctl_fifo_wr [get_bd_pins wfifo_ctl/fifo_wr] [get_bd_pins wfifo_mem/wr_en]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set IIC_FMC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_FMC ]

  # Create ports
  set GPIO_I [ create_bd_port -dir I -from 48 -to 0 GPIO_I ]
  set GPIO_O [ create_bd_port -dir O -from 48 -to 0 GPIO_O ]
  set GPIO_T [ create_bd_port -dir O -from 48 -to 0 GPIO_T ]
  set i2s_bclk [ create_bd_port -dir O -from 0 -to 0 i2s_bclk ]
  set i2s_lrclk [ create_bd_port -dir O -from 0 -to 0 i2s_lrclk ]
  set i2s_mclk [ create_bd_port -dir O -type clk i2s_mclk ]
  set i2s_sdata_in [ create_bd_port -dir I i2s_sdata_in ]
  set i2s_sdata_out [ create_bd_port -dir O -from 0 -to 0 i2s_sdata_out ]
  set iic_mux_scl_I [ create_bd_port -dir I -from 1 -to 0 iic_mux_scl_I ]
  set iic_mux_scl_O [ create_bd_port -dir O -from 1 -to 0 iic_mux_scl_O ]
  set iic_mux_scl_T [ create_bd_port -dir O iic_mux_scl_T ]
  set iic_mux_sda_I [ create_bd_port -dir I -from 1 -to 0 iic_mux_sda_I ]
  set iic_mux_sda_O [ create_bd_port -dir O -from 1 -to 0 iic_mux_sda_O ]
  set iic_mux_sda_T [ create_bd_port -dir O iic_mux_sda_T ]
  set otg_vbusoc [ create_bd_port -dir I otg_vbusoc ]
  set rx_clk_in_n [ create_bd_port -dir I rx_clk_in_n ]
  set rx_clk_in_p [ create_bd_port -dir I rx_clk_in_p ]
  set rx_data_in_n [ create_bd_port -dir I -from 5 -to 0 rx_data_in_n ]
  set rx_data_in_p [ create_bd_port -dir I -from 5 -to 0 rx_data_in_p ]
  set rx_frame_in_n [ create_bd_port -dir I rx_frame_in_n ]
  set rx_frame_in_p [ create_bd_port -dir I rx_frame_in_p ]
  set spi_csn_i [ create_bd_port -dir I spi_csn_i ]
  set spi_csn_o [ create_bd_port -dir O spi_csn_o ]
  set spi_miso_i [ create_bd_port -dir I spi_miso_i ]
  set spi_mosi_i [ create_bd_port -dir I spi_mosi_i ]
  set spi_mosi_o [ create_bd_port -dir O spi_mosi_o ]
  set spi_sclk_i [ create_bd_port -dir I spi_sclk_i ]
  set spi_sclk_o [ create_bd_port -dir O spi_sclk_o ]
  set testcrap [ create_bd_port -dir O testcrap ]
  set tx_clk_out_n [ create_bd_port -dir O tx_clk_out_n ]
  set tx_clk_out_p [ create_bd_port -dir O tx_clk_out_p ]
  set tx_data_out_n [ create_bd_port -dir O -from 5 -to 0 tx_data_out_n ]
  set tx_data_out_p [ create_bd_port -dir O -from 5 -to 0 tx_data_out_p ]
  set tx_frame_out_n [ create_bd_port -dir O tx_frame_out_n ]
  set tx_frame_out_p [ create_bd_port -dir O tx_frame_out_p ]

  # Create instance: axi_ad9361, and set properties
  set axi_ad9361 [ create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361 ]
  set_property -dict [ list CONFIG.PCORE_ID {0}  ] $axi_ad9361

  # Create instance: axi_ad9361_adc_dma, and set properties
  set axi_ad9361_adc_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_adc_dma ]
  set_property -dict [ list CONFIG.C_2D_TRANSFER {0} CONFIG.C_AXI_SLICE_DEST {0} CONFIG.C_AXI_SLICE_SRC {0} CONFIG.C_CLKS_ASYNC_DEST_REQ {1} CONFIG.C_CLKS_ASYNC_REQ_SRC {1} CONFIG.C_CLKS_ASYNC_SRC_DEST {1} CONFIG.C_CYCLIC {0} CONFIG.C_DMA_AXI_PROTOCOL_DEST {1} CONFIG.C_DMA_DATA_WIDTH_SRC {64} CONFIG.C_DMA_TYPE_DEST {0} CONFIG.C_DMA_TYPE_SRC {2} CONFIG.C_SYNC_TRANSFER_START {1}  ] $axi_ad9361_adc_dma

  # Create instance: axi_ad9361_dac_dma, and set properties
  set axi_ad9361_dac_dma [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_ad9361_dac_dma ]
  set_property -dict [ list CONFIG.C_2D_TRANSFER {0} CONFIG.C_AXI_SLICE_DEST {1} CONFIG.C_AXI_SLICE_SRC {0} CONFIG.C_CLKS_ASYNC_DEST_REQ {1} CONFIG.C_CLKS_ASYNC_REQ_SRC {1} CONFIG.C_CLKS_ASYNC_SRC_DEST {1} CONFIG.C_CYCLIC {1} CONFIG.C_DMA_AXI_PROTOCOL_SRC {1} CONFIG.C_DMA_DATA_WIDTH_DEST {64} CONFIG.C_DMA_TYPE_DEST {2} CONFIG.C_DMA_TYPE_SRC {0} CONFIG.C_SYNC_TRANSFER_START {0}  ] $axi_ad9361_dac_dma

  # Create instance: axi_cpu_interconnect, and set properties
  set axi_cpu_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_cpu_interconnect ]
  set_property -dict [ list CONFIG.NUM_MI {10} CONFIG.STRATEGY {1}  ] $axi_cpu_interconnect

  # Create instance: axi_i2s_adi, and set properties
  set axi_i2s_adi [ create_bd_cell -type ip -vlnv analog.com:user:axi_i2s_adi:1.0 axi_i2s_adi ]
  set_property -dict [ list CONFIG.C_DMA_TYPE {1} CONFIG.C_S_AXI_ADDR_WIDTH {16}  ] $axi_i2s_adi

  # Create instance: axi_iic_fmc, and set properties
  set axi_iic_fmc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_fmc ]

  # Create instance: axi_iic_main, and set properties
  set axi_iic_main [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_main ]
  set_property -dict [ list CONFIG.IIC_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true}  ] $axi_iic_main

  # Create instance: constant_0, and set properties
  set constant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.0 constant_0 ]
  set_property -dict [ list CONFIG.CONST_VAL {0}  ] $constant_0

  # Create instance: ila_adc, and set properties
  set ila_adc [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:3.0 ila_adc ]
  set_property -dict [ list CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_NUM_OF_PROBES {8} CONFIG.C_PROBE0_WIDTH {1} CONFIG.C_PROBE1_WIDTH {1} CONFIG.C_PROBE2_WIDTH {1} CONFIG.C_PROBE3_WIDTH {1} CONFIG.C_PROBE4_WIDTH {16} CONFIG.C_PROBE5_WIDTH {16} CONFIG.C_PROBE6_WIDTH {16} CONFIG.C_PROBE7_WIDTH {16} CONFIG.C_TRIGIN_EN {false}  ] $ila_adc

  # Create instance: sys_audio_clkgen, and set properties
  set sys_audio_clkgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 sys_audio_clkgen ]
  set_property -dict [ list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288} CONFIG.PRIM_IN_FREQ {200.000} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {true}  ] $sys_audio_clkgen

  # Create instance: sys_concat_intc, and set properties
  set sys_concat_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:1.0 sys_concat_intc ]
  set_property -dict [ list CONFIG.NUM_PORTS {5}  ] $sys_concat_intc

  # Create instance: sys_i2c_mixer, and set properties
  set sys_i2c_mixer [ create_bd_cell -type ip -vlnv analog.com:user:util_i2c_mixer:1.0 sys_i2c_mixer ]

  # Create instance: sys_logic_inv, and set properties
  set sys_logic_inv [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:1.0 sys_logic_inv ]
  set_property -dict [ list CONFIG.C_OPERATION {not} CONFIG.C_SIZE {1}  ] $sys_logic_inv

  # Create instance: sys_ps7, and set properties
  set sys_ps7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.3 sys_ps7 ]
  set_property -dict [ list CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_EN_CLK2_PORT {1} CONFIG.PCW_EN_RST1_PORT {1} CONFIG.PCW_EN_RST2_PORT {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.0} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.0} CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100.0} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {49} CONFIG.PCW_IMPORT_BOARD_PRESET {ZedBoard} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} CONFIG.PCW_SPI0_SPI0_IO {EMIO} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USE_DMA0 {1} CONFIG.PCW_USE_DMA1 {1} CONFIG.PCW_USE_DMA2 {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.PCW_USE_S_AXI_HP1 {1} CONFIG.PCW_USE_S_AXI_HP2 {1}  ] $sys_ps7

  # Create instance: sys_rstgen, and set properties
  set sys_rstgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sys_rstgen ]
  set_property -dict [ list CONFIG.C_EXT_RST_WIDTH {1}  ] $sys_rstgen

  # Create instance: sys_testcrap_clkgen, and set properties
  set sys_testcrap_clkgen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 sys_testcrap_clkgen ]
  set_property -dict [ list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {6.155} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {true}  ] $sys_testcrap_clkgen

  # Create instance: sys_wfifo_0
  create_hier_cell_sys_wfifo_0 [current_bd_instance .] sys_wfifo_0

  # Create instance: sys_wfifo_1
  create_hier_cell_sys_wfifo_1 [current_bd_instance .] sys_wfifo_1

  # Create instance: sys_wfifo_2
  create_hier_cell_sys_wfifo_2 [current_bd_instance .] sys_wfifo_2

  # Create instance: sys_wfifo_3
  create_hier_cell_sys_wfifo_3 [current_bd_instance .] sys_wfifo_3

  # Create instance: util_adc_pack, and set properties
  set util_adc_pack [ create_bd_cell -type ip -vlnv analog.com:user:util_adc_pack:1.0 util_adc_pack ]
  set_property -dict [ list CONFIG.CHANNELS {4}  ] $util_adc_pack

  # Create instance: util_dac_unpack, and set properties
  set util_dac_unpack [ create_bd_cell -type ip -vlnv analog.com:user:util_dac_unpack:1.0 util_dac_unpack ]
  set_property -dict [ list CONFIG.CHANNELS {4}  ] $util_dac_unpack

  # Create interface connections
  connect_bd_intf_net -intf_net axi_ad9361_adc_dma_axi [get_bd_intf_pins axi_ad9361_adc_dma/m_dest_axi] [get_bd_intf_pins sys_ps7/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_ad9361_dac_dma_axi [get_bd_intf_pins axi_ad9361_dac_dma/m_src_axi] [get_bd_intf_pins sys_ps7/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m00_axi [get_bd_intf_pins axi_cpu_interconnect/M00_AXI] [get_bd_intf_pins axi_iic_main/S_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m05_axi [get_bd_intf_pins axi_cpu_interconnect/M05_AXI] [get_bd_intf_pins axi_i2s_adi/S_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m06_axi [get_bd_intf_pins axi_cpu_interconnect/M06_AXI] [get_bd_intf_pins axi_iic_fmc/S_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m07_axi [get_bd_intf_pins axi_ad9361/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M07_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m08_axi [get_bd_intf_pins axi_ad9361_adc_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M08_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_m09_axi [get_bd_intf_pins axi_ad9361_dac_dma/s_axi] [get_bd_intf_pins axi_cpu_interconnect/M09_AXI]
  connect_bd_intf_net -intf_net axi_cpu_interconnect_s00_axi [get_bd_intf_pins axi_cpu_interconnect/S00_AXI] [get_bd_intf_pins sys_ps7/M_AXI_GP0]
  connect_bd_intf_net -intf_net axi_i2s_adi_dma_ack_rx [get_bd_intf_pins axi_i2s_adi/DMA_ACK_RX] [get_bd_intf_pins sys_ps7/DMA2_ACK]
  connect_bd_intf_net -intf_net axi_i2s_adi_dma_ack_tx [get_bd_intf_pins axi_i2s_adi/DMA_ACK_TX] [get_bd_intf_pins sys_ps7/DMA1_ACK]
  connect_bd_intf_net -intf_net axi_i2s_adi_dma_req_rx [get_bd_intf_pins axi_i2s_adi/DMA_REQ_RX] [get_bd_intf_pins sys_ps7/DMA2_REQ]
  connect_bd_intf_net -intf_net axi_i2s_adi_dma_req_tx [get_bd_intf_pins axi_i2s_adi/DMA_REQ_TX] [get_bd_intf_pins sys_ps7/DMA1_REQ]
  connect_bd_intf_net -intf_net axi_iic_fmc_iic [get_bd_intf_ports IIC_FMC] [get_bd_intf_pins axi_iic_fmc/IIC]
  connect_bd_intf_net -intf_net sys_ps7_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins sys_ps7/DDR]
  connect_bd_intf_net -intf_net sys_ps7_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins sys_ps7/FIXED_IO]

  # Create port connections
  connect_bd_net -net axi_ad9361_adc_chan_i0 [get_bd_pins axi_ad9361/adc_data_i0] [get_bd_pins sys_wfifo_0/m_wdata] [get_bd_pins util_adc_pack/chan_data_0]
  connect_bd_net -net axi_ad9361_adc_chan_i1 [get_bd_pins axi_ad9361/adc_data_i1] [get_bd_pins sys_wfifo_2/m_wdata] [get_bd_pins util_adc_pack/chan_data_2]
  connect_bd_net -net axi_ad9361_adc_chan_q0 [get_bd_pins axi_ad9361/adc_data_q0] [get_bd_pins sys_wfifo_1/m_wdata] [get_bd_pins util_adc_pack/chan_data_1]
  connect_bd_net -net axi_ad9361_adc_chan_q1 [get_bd_pins axi_ad9361/adc_data_q1] [get_bd_pins sys_wfifo_3/m_wdata] [get_bd_pins util_adc_pack/chan_data_3]
  connect_bd_net -net axi_ad9361_adc_dma_irq [get_bd_pins axi_ad9361_adc_dma/irq] [get_bd_pins sys_concat_intc/In2]
  connect_bd_net -net axi_ad9361_adc_dovf [get_bd_pins axi_ad9361/adc_dovf] [get_bd_pins axi_ad9361_adc_dma/fifo_wr_overflow]
  connect_bd_net -net axi_ad9361_adc_enable_i0 [get_bd_pins axi_ad9361/adc_enable_i0] [get_bd_pins util_adc_pack/chan_enable_0]
  connect_bd_net -net axi_ad9361_adc_enable_i1 [get_bd_pins axi_ad9361/adc_enable_i1] [get_bd_pins util_adc_pack/chan_enable_2]
  connect_bd_net -net axi_ad9361_adc_enable_q0 [get_bd_pins axi_ad9361/adc_enable_q0] [get_bd_pins util_adc_pack/chan_enable_1]
  connect_bd_net -net axi_ad9361_adc_enable_q1 [get_bd_pins axi_ad9361/adc_enable_q1] [get_bd_pins util_adc_pack/chan_enable_3]
  connect_bd_net -net axi_ad9361_adc_valid_i0 [get_bd_pins axi_ad9361/adc_valid_i0] [get_bd_pins sys_wfifo_0/m_wr] [get_bd_pins util_adc_pack/chan_valid_0]
  connect_bd_net -net axi_ad9361_adc_valid_i1 [get_bd_pins axi_ad9361/adc_valid_i1] [get_bd_pins sys_wfifo_2/m_wr] [get_bd_pins util_adc_pack/chan_valid_2]
  connect_bd_net -net axi_ad9361_adc_valid_q0 [get_bd_pins axi_ad9361/adc_valid_q0] [get_bd_pins sys_wfifo_1/m_wr] [get_bd_pins util_adc_pack/chan_valid_1]
  connect_bd_net -net axi_ad9361_adc_valid_q1 [get_bd_pins axi_ad9361/adc_valid_q1] [get_bd_pins sys_wfifo_3/m_wr] [get_bd_pins util_adc_pack/chan_valid_3]
  connect_bd_net -net axi_ad9361_clk [get_bd_pins axi_ad9361/clk] [get_bd_pins axi_ad9361/l_clk] [get_bd_pins axi_ad9361_adc_dma/fifo_wr_clk] [get_bd_pins axi_ad9361_dac_dma/fifo_rd_clk] [get_bd_pins sys_wfifo_0/m_clk] [get_bd_pins sys_wfifo_1/m_clk] [get_bd_pins sys_wfifo_2/m_clk] [get_bd_pins sys_wfifo_3/m_clk] [get_bd_pins util_adc_pack/clk] [get_bd_pins util_dac_unpack/clk]
  connect_bd_net -net axi_ad9361_dac_data_0 [get_bd_pins axi_ad9361/dac_data_i0] [get_bd_pins util_dac_unpack/dac_data_00]
  connect_bd_net -net axi_ad9361_dac_data_1 [get_bd_pins axi_ad9361/dac_data_q0] [get_bd_pins util_dac_unpack/dac_data_01]
  connect_bd_net -net axi_ad9361_dac_data_2 [get_bd_pins axi_ad9361/dac_data_i1] [get_bd_pins util_dac_unpack/dac_data_02]
  connect_bd_net -net axi_ad9361_dac_data_3 [get_bd_pins axi_ad9361/dac_data_q1] [get_bd_pins util_dac_unpack/dac_data_03]
  connect_bd_net -net axi_ad9361_dac_dma_irq [get_bd_pins axi_ad9361_dac_dma/irq] [get_bd_pins sys_concat_intc/In3]
  connect_bd_net -net axi_ad9361_dac_drd [get_bd_pins axi_ad9361_dac_dma/fifo_rd_en] [get_bd_pins util_dac_unpack/dma_rd]
  connect_bd_net -net axi_ad9361_dac_dunf [get_bd_pins axi_ad9361/dac_dunf] [get_bd_pins axi_ad9361_dac_dma/fifo_rd_underflow]
  connect_bd_net -net axi_ad9361_dac_enable_0 [get_bd_pins axi_ad9361/dac_enable_i0] [get_bd_pins util_dac_unpack/dac_enable_00]
  connect_bd_net -net axi_ad9361_dac_enable_1 [get_bd_pins axi_ad9361/dac_enable_q0] [get_bd_pins util_dac_unpack/dac_enable_01]
  connect_bd_net -net axi_ad9361_dac_enable_2 [get_bd_pins axi_ad9361/dac_enable_i1] [get_bd_pins util_dac_unpack/dac_enable_02]
  connect_bd_net -net axi_ad9361_dac_enable_3 [get_bd_pins axi_ad9361/dac_enable_q1] [get_bd_pins util_dac_unpack/dac_enable_03]
  connect_bd_net -net axi_ad9361_dac_valid_0 [get_bd_pins axi_ad9361/dac_valid_i0] [get_bd_pins util_dac_unpack/dac_valid_00]
  connect_bd_net -net axi_ad9361_dac_valid_1 [get_bd_pins axi_ad9361/dac_valid_q0] [get_bd_pins util_dac_unpack/dac_valid_01]
  connect_bd_net -net axi_ad9361_dac_valid_2 [get_bd_pins axi_ad9361/dac_valid_i1] [get_bd_pins util_dac_unpack/dac_valid_02]
  connect_bd_net -net axi_ad9361_dac_valid_3 [get_bd_pins axi_ad9361/dac_valid_q1] [get_bd_pins util_dac_unpack/dac_valid_03]
  connect_bd_net -net axi_ad9361_rx_clk_in_n [get_bd_ports rx_clk_in_n] [get_bd_pins axi_ad9361/rx_clk_in_n]
  connect_bd_net -net axi_ad9361_rx_clk_in_p [get_bd_ports rx_clk_in_p] [get_bd_pins axi_ad9361/rx_clk_in_p]
  connect_bd_net -net axi_ad9361_rx_data_in_n [get_bd_ports rx_data_in_n] [get_bd_pins axi_ad9361/rx_data_in_n]
  connect_bd_net -net axi_ad9361_rx_data_in_p [get_bd_ports rx_data_in_p] [get_bd_pins axi_ad9361/rx_data_in_p]
  connect_bd_net -net axi_ad9361_rx_frame_in_n [get_bd_ports rx_frame_in_n] [get_bd_pins axi_ad9361/rx_frame_in_n]
  connect_bd_net -net axi_ad9361_rx_frame_in_p [get_bd_ports rx_frame_in_p] [get_bd_pins axi_ad9361/rx_frame_in_p]
  connect_bd_net -net axi_ad9361_tx_clk_out_n [get_bd_ports tx_clk_out_n] [get_bd_pins axi_ad9361/tx_clk_out_n]
  connect_bd_net -net axi_ad9361_tx_clk_out_p [get_bd_ports tx_clk_out_p] [get_bd_pins axi_ad9361/tx_clk_out_p]
  connect_bd_net -net axi_ad9361_tx_data_out_n [get_bd_ports tx_data_out_n] [get_bd_pins axi_ad9361/tx_data_out_n]
  connect_bd_net -net axi_ad9361_tx_data_out_p [get_bd_ports tx_data_out_p] [get_bd_pins axi_ad9361/tx_data_out_p]
  connect_bd_net -net axi_ad9361_tx_frame_out_n [get_bd_ports tx_frame_out_n] [get_bd_pins axi_ad9361/tx_frame_out_n]
  connect_bd_net -net axi_ad9361_tx_frame_out_p [get_bd_ports tx_frame_out_p] [get_bd_pins axi_ad9361/tx_frame_out_p]
  connect_bd_net -net axi_iic_main_scl_i [get_bd_pins axi_iic_main/scl_i] [get_bd_pins sys_i2c_mixer/upstream_scl_O]
  connect_bd_net -net axi_iic_main_scl_o [get_bd_pins axi_iic_main/scl_o] [get_bd_pins sys_i2c_mixer/upstream_scl_I]
  connect_bd_net -net axi_iic_main_scl_t [get_bd_pins axi_iic_main/scl_t] [get_bd_pins sys_i2c_mixer/upstream_scl_T]
  connect_bd_net -net axi_iic_main_sda_i [get_bd_pins axi_iic_main/sda_i] [get_bd_pins sys_i2c_mixer/upstream_sda_O]
  connect_bd_net -net axi_iic_main_sda_o [get_bd_pins axi_iic_main/sda_o] [get_bd_pins sys_i2c_mixer/upstream_sda_I]
  connect_bd_net -net axi_iic_main_sda_t [get_bd_pins axi_iic_main/sda_t] [get_bd_pins sys_i2c_mixer/upstream_sda_T]
  connect_bd_net -net fifo_data [get_bd_pins axi_ad9361_dac_dma/fifo_rd_dout] [get_bd_pins util_dac_unpack/dma_data]
  connect_bd_net -net fifo_valid [get_bd_pins axi_ad9361_dac_dma/fifo_rd_valid] [get_bd_pins util_dac_unpack/fifo_valid]
  connect_bd_net -net i2s_bclk_s [get_bd_ports i2s_bclk] [get_bd_pins axi_i2s_adi/BCLK_O]
  connect_bd_net -net i2s_lrclk_s [get_bd_ports i2s_lrclk] [get_bd_pins axi_i2s_adi/LRCLK_O]
  connect_bd_net -net i2s_sdata_in_s [get_bd_ports i2s_sdata_in] [get_bd_pins axi_i2s_adi/SDATA_I]
  connect_bd_net -net i2s_sdata_out_s [get_bd_ports i2s_sdata_out] [get_bd_pins axi_i2s_adi/SDATA_O]
  connect_bd_net -net spi_csn_i [get_bd_ports spi_csn_i] [get_bd_pins sys_ps7/SPI0_SS_I]
  connect_bd_net -net spi_csn_o [get_bd_ports spi_csn_o] [get_bd_pins sys_ps7/SPI0_SS_O]
  connect_bd_net -net spi_miso_i [get_bd_ports spi_miso_i] [get_bd_pins sys_ps7/SPI0_MISO_I]
  connect_bd_net -net spi_mosi_i [get_bd_ports spi_mosi_i] [get_bd_pins sys_ps7/SPI0_MOSI_I]
  connect_bd_net -net spi_mosi_o [get_bd_ports spi_mosi_o] [get_bd_pins sys_ps7/SPI0_MOSI_O]
  connect_bd_net -net spi_sclk_i [get_bd_ports spi_sclk_i] [get_bd_pins sys_ps7/SPI0_SCLK_I]
  connect_bd_net -net spi_sclk_o [get_bd_ports spi_sclk_o] [get_bd_pins sys_ps7/SPI0_SCLK_O]
  connect_bd_net -net sys_100m_clk [get_bd_pins axi_ad9361/s_axi_aclk] [get_bd_pins axi_ad9361_adc_dma/s_axi_aclk] [get_bd_pins axi_ad9361_dac_dma/s_axi_aclk] [get_bd_pins axi_cpu_interconnect/ACLK] [get_bd_pins axi_cpu_interconnect/M00_ACLK] [get_bd_pins axi_cpu_interconnect/M01_ACLK] [get_bd_pins axi_cpu_interconnect/M02_ACLK] [get_bd_pins axi_cpu_interconnect/M03_ACLK] [get_bd_pins axi_cpu_interconnect/M04_ACLK] [get_bd_pins axi_cpu_interconnect/M05_ACLK] [get_bd_pins axi_cpu_interconnect/M06_ACLK] [get_bd_pins axi_cpu_interconnect/M07_ACLK] [get_bd_pins axi_cpu_interconnect/M08_ACLK] [get_bd_pins axi_cpu_interconnect/M09_ACLK] [get_bd_pins axi_cpu_interconnect/S00_ACLK] [get_bd_pins axi_i2s_adi/DMA_REQ_RX_ACLK] [get_bd_pins axi_i2s_adi/DMA_REQ_TX_ACLK] [get_bd_pins axi_i2s_adi/S_AXI_ACLK] [get_bd_pins axi_iic_fmc/s_axi_aclk] [get_bd_pins axi_iic_main/s_axi_aclk] [get_bd_pins sys_ps7/DMA0_ACLK] [get_bd_pins sys_ps7/DMA1_ACLK] [get_bd_pins sys_ps7/DMA2_ACLK] [get_bd_pins sys_ps7/FCLK_CLK0] [get_bd_pins sys_ps7/M_AXI_GP0_ACLK] [get_bd_pins sys_ps7/S_AXI_HP0_ACLK] [get_bd_pins sys_rstgen/slowest_sync_clk] [get_bd_pins sys_testcrap_clkgen/clk_in1]
  connect_bd_net -net sys_100m_resetn [get_bd_pins axi_ad9361/s_axi_aresetn] [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aresetn] [get_bd_pins axi_ad9361_adc_dma/s_axi_aresetn] [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aresetn] [get_bd_pins axi_ad9361_dac_dma/s_axi_aresetn] [get_bd_pins axi_cpu_interconnect/ARESETN] [get_bd_pins axi_cpu_interconnect/M00_ARESETN] [get_bd_pins axi_cpu_interconnect/M01_ARESETN] [get_bd_pins axi_cpu_interconnect/M02_ARESETN] [get_bd_pins axi_cpu_interconnect/M03_ARESETN] [get_bd_pins axi_cpu_interconnect/M04_ARESETN] [get_bd_pins axi_cpu_interconnect/M05_ARESETN] [get_bd_pins axi_cpu_interconnect/M06_ARESETN] [get_bd_pins axi_cpu_interconnect/M07_ARESETN] [get_bd_pins axi_cpu_interconnect/M08_ARESETN] [get_bd_pins axi_cpu_interconnect/M09_ARESETN] [get_bd_pins axi_cpu_interconnect/S00_ARESETN] [get_bd_pins axi_i2s_adi/DMA_REQ_RX_RSTN] [get_bd_pins axi_i2s_adi/DMA_REQ_TX_RSTN] [get_bd_pins axi_i2s_adi/S_AXI_ARESETN] [get_bd_pins axi_iic_fmc/s_axi_aresetn] [get_bd_pins axi_iic_main/s_axi_aresetn] [get_bd_pins sys_audio_clkgen/resetn] [get_bd_pins sys_rstgen/peripheral_aresetn] [get_bd_pins sys_wfifo_0/rstn] [get_bd_pins sys_wfifo_1/rstn] [get_bd_pins sys_wfifo_2/rstn] [get_bd_pins sys_wfifo_3/rstn]
  connect_bd_net -net sys_200m_clk [get_bd_pins axi_ad9361/delay_clk] [get_bd_pins sys_audio_clkgen/clk_in1] [get_bd_pins sys_ps7/FCLK_CLK1]
  connect_bd_net -net sys_200m_resetn [get_bd_pins sys_rstgen/interconnect_aresetn]
  connect_bd_net -net sys_audio_clkgen_clk [get_bd_ports i2s_mclk] [get_bd_pins axi_i2s_adi/DATA_CLK_I] [get_bd_pins sys_audio_clkgen/clk_out1]
  connect_bd_net -net sys_aux_reset [get_bd_pins sys_ps7/FCLK_RESET0_N] [get_bd_pins sys_rstgen/ext_reset_in] [get_bd_pins sys_testcrap_clkgen/resetn]
  connect_bd_net -net sys_concat_intc_din_1 [get_bd_pins axi_iic_main/iic2intc_irpt] [get_bd_pins sys_concat_intc/In1]
  connect_bd_net -net sys_concat_intc_din_4 [get_bd_pins axi_iic_fmc/iic2intc_irpt] [get_bd_pins sys_concat_intc/In4]
  connect_bd_net -net sys_fmc_dma_clk [get_bd_pins axi_ad9361_adc_dma/m_dest_axi_aclk] [get_bd_pins axi_ad9361_dac_dma/m_src_axi_aclk] [get_bd_pins ila_adc/clk] [get_bd_pins sys_ps7/FCLK_CLK2] [get_bd_pins sys_ps7/S_AXI_HP1_ACLK] [get_bd_pins sys_ps7/S_AXI_HP2_ACLK] [get_bd_pins sys_wfifo_0/s_clk] [get_bd_pins sys_wfifo_1/s_clk] [get_bd_pins sys_wfifo_2/s_clk] [get_bd_pins sys_wfifo_3/s_clk]
  connect_bd_net -net sys_i2c_mixer_downstream_scl_i [get_bd_ports iic_mux_scl_I] [get_bd_pins sys_i2c_mixer/downstream_scl_I]
  connect_bd_net -net sys_i2c_mixer_downstream_scl_o [get_bd_ports iic_mux_scl_O] [get_bd_pins sys_i2c_mixer/downstream_scl_O]
  connect_bd_net -net sys_i2c_mixer_downstream_scl_t [get_bd_ports iic_mux_scl_T] [get_bd_pins sys_i2c_mixer/downstream_scl_T]
  connect_bd_net -net sys_i2c_mixer_downstream_sda_i [get_bd_ports iic_mux_sda_I] [get_bd_pins sys_i2c_mixer/downstream_sda_I]
  connect_bd_net -net sys_i2c_mixer_downstream_sda_o [get_bd_ports iic_mux_sda_O] [get_bd_pins sys_i2c_mixer/downstream_sda_O]
  connect_bd_net -net sys_i2c_mixer_downstream_sda_t [get_bd_ports iic_mux_sda_T] [get_bd_pins sys_i2c_mixer/downstream_sda_T]
  connect_bd_net -net sys_logic_inv_i [get_bd_ports otg_vbusoc] [get_bd_pins sys_logic_inv/Op1]
  connect_bd_net -net sys_logic_inv_o [get_bd_pins sys_logic_inv/Res] [get_bd_pins sys_ps7/USB0_VBUS_PWRFAULT]
  connect_bd_net -net sys_ps7_GPIO_I [get_bd_ports GPIO_I] [get_bd_pins sys_ps7/GPIO_I]
  connect_bd_net -net sys_ps7_GPIO_O [get_bd_ports GPIO_O] [get_bd_pins sys_ps7/GPIO_O]
  connect_bd_net -net sys_ps7_GPIO_T [get_bd_ports GPIO_T] [get_bd_pins sys_ps7/GPIO_T]
  connect_bd_net -net sys_ps7_interrupt [get_bd_pins sys_concat_intc/dout] [get_bd_pins sys_ps7/IRQ_F2P]
  connect_bd_net -net sys_testcrap_clkgen_clk_out1 [get_bd_ports testcrap] [get_bd_pins sys_testcrap_clkgen/clk_out1]
  connect_bd_net -net util_adc_pack_ddata [get_bd_pins axi_ad9361_adc_dma/fifo_wr_din] [get_bd_pins util_adc_pack/ddata]
  connect_bd_net -net util_adc_pack_dsync [get_bd_pins axi_ad9361_adc_dma/fifo_wr_sync] [get_bd_pins util_adc_pack/dsync]
  connect_bd_net -net util_adc_pack_dvalid [get_bd_pins axi_ad9361_adc_dma/fifo_wr_en] [get_bd_pins util_adc_pack/dvalid]
  connect_bd_net -net util_wfifo_0_s_wdata [get_bd_pins ila_adc/probe4] [get_bd_pins sys_wfifo_0/s_wdata]
  connect_bd_net -net util_wfifo_0_s_wr [get_bd_pins ila_adc/probe0] [get_bd_pins sys_wfifo_0/s_wr]
  connect_bd_net -net util_wfifo_1_s_wdata [get_bd_pins ila_adc/probe5] [get_bd_pins sys_wfifo_1/s_wdata]
  connect_bd_net -net util_wfifo_1_s_wr [get_bd_pins ila_adc/probe1] [get_bd_pins sys_wfifo_1/s_wr]
  connect_bd_net -net util_wfifo_2_s_wdata [get_bd_pins ila_adc/probe6] [get_bd_pins sys_wfifo_2/s_wdata]
  connect_bd_net -net util_wfifo_2_s_wr [get_bd_pins ila_adc/probe2] [get_bd_pins sys_wfifo_2/s_wr]
  connect_bd_net -net util_wfifo_3_s_wdata [get_bd_pins ila_adc/probe7] [get_bd_pins sys_wfifo_3/s_wdata]
  connect_bd_net -net util_wfifo_3_s_wr [get_bd_pins ila_adc/probe3] [get_bd_pins sys_wfifo_3/s_wr]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_ad9361_adc_dma/m_dest_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_sys_ps7_hp1_ddr_lowocm
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_ad9361_dac_dma/m_src_axi] [get_bd_addr_segs sys_ps7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_sys_ps7_hp2_ddr_lowocm
  create_bd_addr_seg -range 0x10000 -offset 0x79020000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9361/s_axi/axi_lite] SEG_data_ad9361
  create_bd_addr_seg -range 0x10000 -offset 0x7C400000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9361_adc_dma/s_axi/axi_lite] SEG_data_ad9361_adc_dma
  create_bd_addr_seg -range 0x10000 -offset 0x7C420000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_ad9361_dac_dma/s_axi/axi_lite] SEG_data_ad9361_dac_dma
  create_bd_addr_seg -range 0x10000 -offset 0x77600000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_i2s_adi/S_AXI/reg0] SEG_data_i2s_adi
  create_bd_addr_seg -range 0x10000 -offset 0x41620000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_iic_fmc/S_AXI/Reg] SEG_data_iic_fmc
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces sys_ps7/Data] [get_bd_addr_segs axi_iic_main/S_AXI/Reg] SEG_data_iic_main
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


