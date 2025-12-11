`timescale 1ns/1ps

module Network_FPGA (
    input  wire sys_clk,   // map to W5 in XDC
    input  wire rst
);

    // No IBUFDS on Basys3 - clock is already single-ended
    // (remove your old IBUFDS block completely)

    wire        locked;
    wire        pll_clk;

    wire        state0,state1,state2,state3;
    wire [15:0] read0, read1, read2, read3, read4, read5, read6, read7, read8, read9, read10, read11, read12, read13, read14, read15;
    
    //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG

  clk_wiz_0 clk_wiz
   (
    // Clock out ports
    .clk_out1(pll_clk),     // output clk_out1
    // Status and control signals
    .reset(~rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk));      // input clk_in1
// INST_TAG_END ------ End INSTANTIATION Template ---------

    Network net(
        .clk(pll_clk),
        .rst(rst),
        .state0(state0),
        .state1(state1),
        .state2(state2),
        .state3(state3),
        .read0(read0),
        .read1(read1),
        .read2(read2),
        .read3(read3),
        .read4(read4),
        .read5(read5),
        .read6(read6),
        .read7(read7),
        .read8(read8),
        .read9(read9),
        .read10(read10),
        .read11(read11),
        .read12(read12),
        .read13(read13),
        .read14(read14),
        .read15(read15)
        );

    
    ila_0   ila (
        .clk    (sys_clk),
        .probe0 (state0),
        .probe1 (state1),
        .probe2 (state2),
        .probe3 (state3),
        .probe4 (read0),
        .probe5 (read1),
        .probe6 (read2),
        .probe7 (read3),
        .probe8 (read4),
        .probe9 (read5),
        .probe10 (read6),
        .probe11 (read7),
        .probe12 (read8),
        .probe13 (read9),
        .probe14 (read10),
        .probe15 (read11),
        .probe16 (read12),
        .probe17 (read13),
        .probe18 (read14),
        .probe19 (read15)
    );


endmodule //moduleName
