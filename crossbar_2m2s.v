module crossbar_2m2s(
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
/*
reg active_slave_1_req;
reg active_slave_2_req;
reg active_master_1_ack;
reg active_master_2_ack;
reg [31:0]active_slave_1_addr;
reg [31:0]active_slave_2_addr;
reg [31:0]active_slave_1_wdata;
reg [31:0]active_slave_2_wdata;
reg [31:0]active_master_1_rdata;
reg [31:0]active_master_2_rdata;
reg active_slave_1_cmd;
reg active_slave_2_cmd;*/

reg connect_req_m1_s1;
reg connect_req_m2_s1;
reg connect_req_m1_s2;
reg connect_req_m2_s2;

reg connect_approved_m1_s1;
reg connect_approved_m2_s1;
reg connect_approved_m1_s2;
reg connect_approved_m2_s2;

reg wdata_approved_m1_s1;
reg wdata_approved_m2_s1;
reg wdata_approved_m1_s2;
reg wdata_approved_m2_s2;

reg rdata_approved_m1_s1;
reg rdata_approved_m2_s1;
reg rdata_approved_m1_s2;
reg rdata_approved_m2_s2;

reg last_con_to_s1; //last connection to slave1 - wich master 1'b0 - 1st, 1'b1 - 2nd 
reg last_con_to_s2; //last connection to slave2 - wich master 

integer index;

always@*
begin
connect_req_m1_s1 = (~master_1_addr[31]) & (master_1_req);
connect_req_m2_s1 = (~master_2_addr[31]) & (master_2_req);
connect_req_m1_s2 = (master_1_addr[31]) & (master_1_req);
connect_req_m2_s2 = (master_2_addr[31]) & (master_2_req);


//resolving case if two M going to one slave
if (master_1_req & master_2_req)
 begin
	//M1 M2 to separate s
	if ((connect_req_m1_s1 & connect_req_m2_s2) | (connect_req_m1_s2 & connect_req_m2_s1))
	    begin
		connect_approved_m1_s1 = connect_req_m1_s1;
		connect_approved_m1_s2 = connect_req_m1_s2;
		connect_approved_m2_s1 = connect_req_m2_s1;
		connect_approved_m2_s2 = connect_req_m2_s2;
	    end

	//M1 M2 to s1
	if (connect_req_m1_s1 & connect_req_m2_s1)
	     begin
	     if (last_con_to_s1)
	  	begin
	    	//connect 1 master
		connect_approved_m1_s1 = 1'b1;
		connect_approved_m2_s1 = 1'b0;
		//last_con_to_s1 = 1'b0;
	  	end
	     else
	  	begin
	    	//connect 2 master
		connect_approved_m2_s1 = 1'b1;
		connect_approved_m1_s1 = 1'b0;
		//last_con_to_s1 = 1'b1;
	  	end
	     end
	     

	//M1 M2 to s2
	if (connect_req_m1_s2 & connect_req_m2_s2)
 	  begin
	     if (last_con_to_s2)
	  	begin
	    	//connect 1 master
		connect_approved_m1_s2 = 1'b1;
		connect_approved_m2_s2 = 1'b0;
		//last_con_to_s2 = 1'b0;
	  	end
	     else
	  	begin
	    	//connect 2 master
		connect_approved_m2_s2 = 1'b1;
		connect_approved_m1_s2 = 1'b0;
		//last_con_to_s2 = 1'b1;
	  	end
 	  end


 end
else
 begin
	connect_approved_m1_s1 = connect_req_m1_s1;
	connect_approved_m1_s2 = connect_req_m1_s2;
	connect_approved_m2_s1 = connect_req_m2_s1;
	connect_approved_m2_s2 = connect_req_m2_s2;

 end

wdata_approved_m1_s1 = (master_1_cmd) & (master_1_req) & (connect_approved_m1_s1);
rdata_approved_m1_s1 = (~(master_1_cmd)) & (master_1_req) & (connect_approved_m1_s1);

wdata_approved_m1_s2 = (master_1_cmd) & (master_1_req) & (connect_approved_m1_s2);
rdata_approved_m1_s2 = (~(master_1_cmd)) & (master_1_req) & (connect_approved_m1_s2);

wdata_approved_m2_s1 = (master_2_cmd) & (master_2_req) & (connect_approved_m2_s1);
rdata_approved_m2_s1 = (~(master_2_cmd)) & (master_2_req) & (connect_approved_m2_s1);

wdata_approved_m2_s2 = (master_2_cmd) & (master_2_req) & (connect_approved_m2_s2);
rdata_approved_m2_s2 = (~(master_2_cmd)) & (master_2_req) & (connect_approved_m2_s2);


//signals req, cmd, addr
slave_1_req = connect_req_m1_s1 | connect_req_m2_s1;
slave_2_req = connect_req_m1_s2 | connect_req_m2_s2;

slave_1_cmd = ((master_1_cmd) & (connect_approved_m1_s1)) | ((master_2_cmd) & (connect_approved_m2_s1));
slave_2_cmd = ((master_1_cmd) & (connect_approved_m1_s2)) | ((master_2_cmd) & (connect_approved_m2_s2));

master_1_ack = (slave_1_ack & ~(master_1_addr[31]) & connect_approved_m1_s1) | (slave_2_ack & (master_1_addr[31]) & connect_approved_m1_s2);
master_2_ack = (slave_1_ack & ~(master_2_addr[31]) & connect_approved_m2_s1) | (slave_2_ack & (master_2_addr[31]) & connect_approved_m2_s2);

for(index = 0; index < 32; index = index + 1)
  begin
	slave_1_addr[index] = ((master_1_addr[index]) && (connect_approved_m1_s1)) || ((master_2_addr[index]) && (connect_approved_m2_s1));
	slave_2_addr[index] = ((master_1_addr[index]) && (connect_approved_m1_s2)) || ((master_2_addr[index]) && (connect_approved_m2_s2));
  end


/*
if ((master_1_req) & (connect_approved_m1_s1)) 	last_con_to_s1 = 1'b0;
if ((master_1_req) & (connect_approved_m1_s2))  last_con_to_s2 = 1'b0;
if ((master_2_req) & (connect_approved_m2_s1))  last_con_to_s1 = 1'b1;
if ((master_2_req) & (connect_approved_m2_s2))  last_con_to_s2 = 1'b1;*/

//nullify connection approvation
connect_approved_m1_s1 = (master_1_req) & (connect_approved_m1_s1);
connect_approved_m1_s2 = (master_1_req) & (connect_approved_m1_s2);
connect_approved_m2_s1 = (master_2_req) & (connect_approved_m2_s1);
connect_approved_m2_s2 = (master_2_req) & (connect_approved_m2_s2);

end

always @(posedge master_1_req, posedge master_2_req)
begin

//set "last connection" initial statement to slave 2 for both masters

last_con_to_s1 = ~(last_con_to_s1 | ~last_con_to_s1);
last_con_to_s2 = ~(last_con_to_s2 | ~last_con_to_s2);

last_con_to_s1 =  ~(wdata_approved_m1_s1 | rdata_approved_m1_s1) & ((wdata_approved_m2_s1 | rdata_approved_m2_s1) | last_con_to_s1);
last_con_to_s2 =  ~(wdata_approved_m1_s2 | rdata_approved_m1_s2) & ((wdata_approved_m2_s2 | rdata_approved_m2_s2) | last_con_to_s2);
end

/*
always @(slave_1_ack, slave_2_ack)
begin

	if ((slave_1_ack) & (master_1_addr[31]))
	  begin
	  end
	else
	  begin
	  master_1_ack = slave_1_ack;
	  end
	if ((slave_1_ack) & (master_2_addr[31]))
	  begin
	  end
	else
	  begin
	  master_2_ack = slave_1_ack;
	  end


	if ((slave_2_ack) & (master_1_addr[31]))
	  begin
	  master_1_ack = slave_2_ack;
	  end

	if ((slave_2_ack) & (master_2_addr[31]))
	  begin
	  master_2_ack = slave_2_ack;
	  end
end*/


//data handling
always @*
begin
for(index = 0; index < 32; index = index + 1)
  begin
slave_1_wdata[index] = (master_1_wdata[index] & wdata_approved_m1_s1) | (master_2_wdata[index] & wdata_approved_m2_s1);
slave_2_wdata[index] = (master_1_wdata[index] & wdata_approved_m1_s2) | (master_2_wdata[index] & wdata_approved_m2_s2); 
master_1_rdata[index] = (slave_1_rdata[index] & rdata_approved_m1_s1 & slave_1_ack) | (slave_2_rdata[index] & rdata_approved_m1_s2 & slave_2_ack);
master_2_rdata[index] = (slave_1_rdata[index] & rdata_approved_m2_s1 & slave_1_ack) | (slave_2_rdata[index] & rdata_approved_m2_s2 & slave_2_ack);
  end
end
endmodule

