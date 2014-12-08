
# clocks

create_clock -name cpu_clk      -period 10.00 [get_pins i_system_wrapper/system_i/sys_ps7/FCLK_CLK0]
create_clock -name m200_clk     -period  5.00 [get_pins i_system_wrapper/system_i/sys_ps7/FCLK_CLK1]

create_clock -name ps7_clk_0  -period 10.00 [get_pins i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[0]]
create_clock -name ps7_clk_1  -period 5.00  [get_pins i_system_wrapper/system_i/sys_ps7/inst/PS7_i/FCLKCLK[1]]

set_clock_groups -asynchronous -group {cpu_clk}
set_clock_groups -asynchronous -group {m200_clk}
set_clock_groups -asynchronous -group {ps7_clk_0}
set_clock_groups -asynchronous -group {ps7_clk_1}
