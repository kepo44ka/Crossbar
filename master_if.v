module master_if(
  input wire req_from_master, 
  input wire [31:0] addr_from_master,
  input wire [31:0] wdata_from_master,
  input wire cmd_from_master,
  
  input wire ack_from_crossbar,
  input wire [31:0] rdata_from_crossbar,
  
  input wire connect_approved_from_crossbar,
  
  output reg ack_to_master,
  output reg [31:0] rdata_to_master,
  
  output reg req_to_crossbar, 
  output reg [31:0] addr_to_crossbar,
  output reg [31:0] wdata_to_crossbar,
  output reg cmd_to_crossbar
);
always @*
begin
  ack_to_master		= ack_from_crossbar & connect_approved_from_crossbar;
  rdata_to_master	= rdata_from_crossbar & {32{ack_from_crossbar}} & {32{connect_approved_from_crossbar}};
  
  req_to_crossbar	= req_from_master; 
  addr_to_crossbar	= addr_from_master & {32{connect_approved_from_crossbar}};
  wdata_to_crossbar	= wdata_from_master & {32{connect_approved_from_crossbar}};
  cmd_to_crossbar	= cmd_from_master & connect_approved_from_crossbar;
end

endmodule