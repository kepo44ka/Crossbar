
module testbench;

reg clk;

  reg var_master_1_req;
  reg var_master_2_req;
  reg var_slave_1_ack;
  reg var_slave_2_ack;
  reg[31:0] var_master_1_addr;
  reg[31:0] var_master_2_addr;
  reg[31:0] var_master_1_wdata;
  reg[31:0] var_master_2_wdata;
  reg[31:0] var_slave_1_rdata;
  reg[31:0] var_slave_2_rdata;
  reg var_master_1_cmd;
  reg var_master_2_cmd;

wire out_slave_1_req; 
wire out_slave_2_req;
wire out_master_1_ack; 
wire out_master_2_ack;
wire out_slave_1_cmd; 
wire out_slave_2_cmd;
wire [31:0] out_master_1_rdata; 
wire [31:0] out_master_2_rdata;
wire [31:0] out_slave_1_wdata; 
wire [31:0] out_slave_2_wdata;
wire [31:0] out_slave_1_addr; 
wire [31:0] out_slave_2_addr;

//instance of module being studied
crossbar_2m2s crossbar(
  .clk(clk),
  .master_1_req(var_master_1_req),
  .master_2_req(var_master_2_req),
  .slave_1_ack(var_slave_1_ack),
  .slave_2_ack(var_slave_2_ack),
  .master_1_addr(var_master_1_addr),
  .master_2_addr(var_master_2_addr),
  .master_1_wdata(var_master_1_wdata),
  .master_2_wdata(var_master_2_wdata),
  .slave_1_rdata(var_slave_1_rdata),
  .slave_2_rdata(var_slave_2_rdata),
  .master_1_cmd(var_master_1_cmd),
  .master_2_cmd(var_master_2_cmd),
  .slave_1_req(out_slave_1_req),
  .slave_2_req(out_slave_2_req),
  .master_1_ack(out_master_1_ack),
  .master_2_ack(out_master_2_ack),
  .slave_1_addr(out_slave_1_addr),
  .slave_2_addr(out_slave_2_addr),
  .slave_1_wdata(out_slave_1_wdata),
  .slave_2_wdata(out_slave_2_wdata),
  .master_1_rdata(out_master_1_rdata),
  .master_2_rdata(out_master_2_rdata),
  .slave_1_cmd(out_slave_1_cmd),
  .slave_2_cmd(out_slave_2_cmd)
);

initial
begin

clk = 'b0;

var_master_1_req = 'b0;
var_master_1_cmd = 'b0;
var_slave_1_ack = 'b0;
var_master_2_req = 'b0;
var_master_2_cmd = 'b0;
var_slave_2_ack = 'b0;
 var_master_1_wdata = 'h1111;
 var_master_2_wdata = 'h2222;
 var_slave_1_rdata = 'h11;
 var_slave_2_rdata = 'h22;
 var_master_1_addr = 'hf0000000;
 var_master_2_addr = 'hf0000000;








//________WRITING TEST_________
//Write to S1 from M1
var_master_1_req = 'b1;
var_master_1_cmd = 'b1;
var_master_1_addr = 32'h7fffffff;
var_master_1_wdata = 32'h11111111;
#5;
var_slave_1_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_slave_1_ack = 'b0;
#15;

//Write to S2 from M1
var_master_1_req = 'b1;
var_master_1_cmd = 'b1;
var_master_1_addr = 32'hffffffff;
var_master_1_wdata = 32'h22221111;
#5;
var_slave_2_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_slave_2_ack = 'b0;
#15;

//Write to S1 from M2
var_master_2_req = 'b1;
var_master_2_cmd = 'b1;
var_master_2_addr = 32'h7fffffff;
var_master_2_wdata = 32'h11112222;
#5;
var_slave_1_ack = 'b1;
#5;
var_master_2_req = 'b0;
var_slave_1_ack = 'b0;
#15;

//Write to S2 from M2
var_master_2_req = 'b1;
var_master_2_cmd = 'b1;
var_master_2_addr = 32'hffffffff;
var_master_2_wdata = 32'h22222222;
#5;
var_slave_2_ack = 'b1;
#5;
var_master_2_req = 'b0;
var_slave_2_ack = 'b0;
#15;

//________READING TEST_________
//Read from S1 to M1
var_master_1_req = 'b1;
var_master_1_cmd = 'b0;
var_master_1_addr = 'h7fffffff;
var_slave_1_rdata = 'h10000001;
#5;
var_slave_1_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_slave_1_ack = 'b0;
#15;

//Read from S2 to M1
var_master_1_req = 'b1;
var_master_1_cmd = 'b0;
var_master_1_addr = 'hffffffff;
var_slave_2_rdata = 'h20000001;
#5;
var_slave_2_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_slave_1_ack = 'b0;
#15;

//Read from S1 to M2
var_master_2_req = 'b1;
var_master_2_cmd = 'b0;
var_master_2_addr = 'h7fffffff;
var_slave_1_rdata = 'h10000002;
#5;
var_slave_1_ack = 'b1;
#5;
var_master_2_req = 'b0;
var_slave_1_ack = 'b0;
#15;

//Read from S2 to M2
var_master_2_req = 'b1;
var_master_2_cmd = 'b0;
var_master_2_addr = 'hffffffff;
var_slave_2_rdata = 'h20000002;
#5;
var_slave_2_ack = 'b1;
#5;
var_master_2_req = 'b0;
var_slave_2_ack = 'b0;
#15;

//________2 Request situations_________
//Write to different slaves 200ns
var_master_1_req = 'b1;
var_master_1_cmd = 'b1;
var_master_1_addr = 'h7fffffff;
var_master_1_wdata = 'h11111111;

var_master_2_req = 'b1;
var_master_2_cmd = 'b1;
var_master_2_addr = 32'hffffffff;
var_master_2_wdata = 32'h22222222;
#5;
var_slave_1_ack = 'b1;
var_slave_2_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_master_2_req = 'b0;
var_slave_1_ack = 'b0;
var_slave_2_ack = 'b0;
#15;

//Read from different slaves 225ns
var_master_1_req = 'b1;
var_master_1_cmd = 'b0;
var_master_1_addr = 'h7fffffff;
var_slave_1_rdata = 'h10000001;

var_master_2_req = 'b1;
var_master_2_cmd = 'b0;
var_master_2_addr = 'hffffffff;
var_slave_2_rdata = 'h20000002;
#5;
var_slave_1_ack = 'b1;
var_slave_2_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_slave_1_ack = 'b0;
var_master_2_req = 'b0;
var_slave_2_ack = 'b0;
#15;

//Write to the same slave (1st) 2 times  250ns
var_master_1_req = 'b1;			//1st
var_master_1_cmd = 'b1;
var_master_1_addr = 'h7fffffff;
var_master_1_wdata = 'h11111111;

var_master_2_req = 'b1;
var_master_2_cmd = 'b1;
var_master_2_addr = 32'h1fffffff;
var_master_2_wdata = 32'h11112222;
#5;
var_slave_1_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_master_2_req = 'b0;
var_slave_1_ack = 'b0;
#15;

var_master_1_req = 'b1;			//2nd
var_master_1_cmd = 'b1;
var_master_1_addr = 'h7fffffff;
var_master_1_wdata = 'h11111111;

var_master_2_req = 'b1;
var_master_2_cmd = 'b1;
var_master_2_addr = 32'h1fffffff;
var_master_2_wdata = 32'h11112222;
#5;
var_slave_1_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_master_2_req = 'b0;
var_slave_1_ack = 'b0;
#15;

//Read from the same slave  300 ns
var_master_1_req = 'b1;
var_master_1_cmd = 'b0;
var_master_1_addr = 'h7fffffff;
var_slave_1_rdata = 'h10000001;

var_master_2_req = 'b1;
var_master_2_cmd = 'b0;
var_master_2_addr = 'h1fffffff;
var_slave_2_rdata = 'h20000002;
#5;
var_slave_1_ack = 'b1;
#5;
var_master_1_req = 'b0;
var_slave_1_ack = 'b0;
var_master_2_req = 'b0;
#15;

end

always
# 5 clk = ~clk; 
endmodule