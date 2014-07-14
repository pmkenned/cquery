-- NOTE: this is non-compilable example code

library ary, arr,ar8, clib,clibp, ibm, ieee, stdcell, latches, support;
 use ibm.std_ulogic_function_support.all;

Entity top is port (
  vdd                            :  inout   power_logic;
  gnd                            :  inout   power_logic;
  gckn                           :  in   std_ulogic;
  output                         :  out  std_ulogic
);
 attribute pin_data of gckn  : signal is "PIN_FUNCTION=/G_CLK/";
 Attribute BLOCK_TYPE of top : entity is leaf;
end top ;

ARCHITECTURE top OF top IS
-- MAKESCH GENERATED
  SIGNAL  x_signal                         : std_ulogic;
  SIGNAL  y_signal                         : std_ulogic_vector(0 to 7); -- not sure why ms7 not defining this guy.
  SIGNAL  z_signal                         : std_ulogic;
begin
 
-- example assignment
x_vector(0 to 1) <= y_vector(0 to 1);

z_signal <= (a or b) and c  and not d;

-- example instantiation
    fm : entity work.foo_module
    port map (
        x_input                 => x_input     ,
        y_output (0 to 3)       => y_output (0 to 3)  
    ) ;

    bm : entity work.bar_module
    port map (
        x_input                 => x_input     ,
        y_output (0 to 3)       => y_output (0 to 3)  
    ) ;

END top;
