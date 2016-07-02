module crossbar_2m2s(
  input wire clk,
  input wire master_1_req, master_2_req, 
  input wire slave_1_ack, slave_2_ack,
  input wire [31:0] master_1_addr, master_2_addr,
  input wire [31:0] master_1_wdata, master_2_wdata,
  input wire [31:0] slave_1_rdata, slave_2_rdata,
  input wire master_1_cmd, master_2_cmd,
  output reg slave_1_req, slave_2_req,
  output reg master_1_ack, master_2_ack,
  output reg [31:0] slave_1_addr, slave_2_addr,
  output reg [31:0] slave_1_wdata, slave_2_wdata,
  output reg [31:0] master_1_rdata, master_2_rdata,
  output reg slave_1_cmd, slave_2_cmd
);



master_if master_1(
  .req_from_master(var_master_1_req), 
  .addr_from_master(var_master_1_addr),
  .wdata_from_master(var_master_1_wdata),
  .cmd_from_master(var_master_1_cmd),
  
  .ack_from_crossbar(ack_m1),
  .rdata_from_crossbar(rdata_m1),
  
  .connect_approved_from_crossbar(c_appr_m1),
  
  .ack_to_master(out_master_1_ack),
  .rdata_to_master(out_master_1_rdata),
  
  .req_to_crossbar(req_m1), 
  .addr_to_crossbar(addr_m1),
  .wdata_to_crossbar(wdata_m1),
  .cmd_to_crossbar
);

master_if master_2(
  .req_from_master(var_master_2_req), 
  .addr_from_master(var_master_2_addr),
  .wdata_from_master(var_master_2_wdata),
  .cmd_from_master(var_master_2_cmd),
  
  .ack_from_crossbar(ack_m2),
  .rdata_from_crossbar(rdata_m2),
  
  .connect_approved_from_crossbar(c_appr_m2),
  
  .ack_to_master(out_master_1_ack),
  .rdata_to_master(out_master_1_rdata),
  
  .req_to_crossbar(req_m2), 
  .addr_to_crossbar(addr_m2),
  .wdata_to_crossbar(wdata_m2),
  .cmd_to_crossbar
);

slave_if slave_1(
  .ack_from_slave(var_slave_1_ack),
  .rdata_from_slave(var_slave_1_rdata),
  
  .req_from_crossbar(req_s1),
  .addr_from_crossbar(addr_s1),
  .wdata_from_crossbar(wdata_s1),
  .cmd_from_crossbar(cmd_s1),
  
  .connect_approved_from_crossbar(c_appr_s1),
  
  .ack_to_crossbar(ack_s1),    
  .rdata_to_crossbar(rdata_s1),
  
  .req_to_slave(out_slave_1_req),
  .addr_to_slave(out_slave_1_addr),
  .wdata_to_slave(out_slave_1_wdata),
  .cmd_to_slave(out_slave_1_cmd),
);

slave_if slave_2(
  .ack_from_slave(var_slave_2_ack),
  .rdata_from_slave(var_slave_2_rdata),
  
  .req_from_crossbar(req_s2),
  .addr_from_crossbar(addr_s2),
  .wdata_from_crossbar(wdata_s2),
  .cmd_from_crossbar(cmd_s2),
  
  .connect_approved_from_crossbar(c_appr_s2),
  
  .ack_to_crossbar(ack_s2),    
  .rdata_to_crossbar(rdata_s2),
  
  .req_to_slave(out_slave_1_req),
  .addr_to_slave(out_slave_1_addr),
  .wdata_to_slave(out_slave_1_wdata),
  .cmd_to_slave(out_slave_1_cmd),
);

wire req_m1;
wire req_m2;
wire req_s1 = req_m1_s1 | req_m2_s1;
wire req_s2 = req_m1_s2 | req_m2_s2;

wire ack_m1 = ack_s1 & c_appr_m1_s1 | ack_s2 & c_appr_m1_s2;
wire ack_m2 = ack_s1 & c_appr_m2_s1 | ack_s2 & c_appr_m2_s2;
wire ack_s1;
wire ack_s2;

wire cmd_m1;
wire cmd_m2;
wire cmd_s1 = cmd_m1 & c_appr_m1_s1 | cmd_m2 & c_appr_m2_s1;
wire cmd_s2 = cmd_m1 & c_appr_m1_s2 | cmd_m2 & c_appr_m2_s2;

wire [31:0] addr_m1;
wire [31:0] addr_m2;
wire [31:0] addr_s1 = addr_m1 & {32{c_appr_m1_s1}} | addr_m2 & {32{c_appr_m2_s1}};
wire [31:0] addr_s2 = addr_m1 & {32{c_appr_m1_s2}} | addr_m2 & {32{c_appr_m2_s2}};

wire [31:0] wdata_m1;
wire [31:0] wdata_m2;
wire [31:0] wdata_s1 = wdata_m1 & {32{c_appr_m1_s1}} | wdata_m2 & {32{c_appr_m2_s1}};
wire [31:0] wdata_s2 = wdata_m1 & {32{c_appr_m1_s2}} | wdata_m2 & {32{c_appr_m2_s2}};


wire [31:0] rdata_m1 = rdata_s1 & {32{c_appr_m1_s1}} | rdata_s2 & {32{c_appr_m1_s2}};
wire [31:0] rdata_m2 = rdata_s1 & {32{c_appr_m2_s1}} | rdata_s2 & {32{c_appr_m2_s2}};
wire [31:0] rdata_s1;
wire [31:0] rdata_s2;

wire req_m1_s1 = ~addr_m1[31] & req_m1;
wire req_m2_s1 = ~addr_m2[31] & req_m2;
wire req_m1_s2 = addr_m1[31] & req_m1;
wire req_m2_s2 = addr_m2[31] & req_m2;

wire c_appr_m1 = c_appr_m1_s1 | c_appr_m1_s2;
wire c_appr_m2 = c_appr_m2_s1 | c_appr_m2_s2;
wire c_appr_s1 = c_appr_m1_s1 | c_appr_m2_s1;
wire c_appr_s2 = c_appr_m1_s2 | c_appr_m2_s2;



wire c_appr_m1_s1;
wire c_appr_m2_s1;
wire c_appr_m1_s2;
wire c_appr_m2_s2;

//connection approvation;   resolving case if two M going to one slave
always @*
begin
if ((req_m1_s1 & req_m2_s1) | (req_m1_s2 & req_m2_s2))
 begin
	//M1 M2 to s1
	if (req_m1_s1 & req_m2_s1)
	  begin
	    	//if last connection to s1 was from m2 - connect 1st master, from m1 - connect 2nd
			//(if last_con_to_s1 = 1 last one was m2, = 0 last one was m1)
		c_appr_m1_s1 = (req_m1_s1 & req_m2_s1) & (last_con_to_s1);
		c_appr_m2_s1 = ~(c_appr_m1_s1);
	  end
    
	//M1 M2 to s2
	if (req_m1_s2 & req_m2_s2)
 	  begin
	    	//if last connection to s2 was from m2 - connect 1st master, from m1 - connect 2nd
			//(if last_con_to_s2 = 1 last one was m2, = 0 last one was m1)
		c_appr_m1_s2 = (req_m1_s2 & req_m2_s2) & (last_con_to_s2);
		c_appr_m2_s2 = ~(c_appr_m1_s2);	  
 	  end
 end
else
 begin
	c_appr_m1_s1 = req_m1_s1;
	c_appr_m2_s1 = req_m2_s1;
	c_appr_m1_s2 = req_m1_s1;
	c_appr_m2_s2 = req_m2_s1;
 end

end


reg last_con_to_s1; //last connection to slave1 - wich master 1'b0 - 1st, 1'b1 - 2nd 
reg last_con_to_s2; //last connection to slave2 - wich master 1'b0 - 1st, 1'b1 - 2nd 

always @(posedge clk)
   last_con_to_s1 <= ~c_appr_m1_s1 & (c_appr_m2_s1 | last_con_to_s1); // will be 1 if last was m2

always @(posedge clk)
   last_con_to_s2 <= ~c_appr_m1_s2 & (c_appr_m2_s2 | last_con_to_s2);
   




endmodule

