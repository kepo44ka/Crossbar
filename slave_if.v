module slave_if(

  input wire ack_from_slave,
  input wire [31:0] rdata_from_slave,
  
  input wire req_from_crossbar,
  input wire [31:0] addr_from_crossbar,
  input wire [31:0] wdata_from_crossbar,
  input wire cmd_from_crossbar,
  
  input wire connect_approved_from_crossbar,
  
  output reg ack_to_crossbar,    
  output reg [31:0] rdata_to_crossbar,
  
  output req_to_slave,
  output [31:0] addr_to_slave,
  output [31:0] wdata_to_slave,
  output cmd_to_slave
);

assign req_to_slave	= req_from_crossbar;
assign addr_to_slave	= addr_from_crossbar & {32{connect_approved_from_crossbar}};
assign wdata_to_slave	= wdata_from_crossbar & {32{cmd_from_crossbar}} & {32{connect_approved_from_crossbar}}; //{32{cmd_from_crossbar}} <= write command
assign cmd_to_slave	= cmd_from_crossbar & connect_approved_from_crossbar;

always @*
begin
  ack_to_crossbar	= ack_from_slave;
  rdata_to_crossbar	= rdata_from_slave & ~{32{cmd_from_crossbar}} & {32{connect_approved_from_crossbar}}; //~{32{cmd_from_crossbar}} <= read command
end

endmodule