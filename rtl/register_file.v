module register_file(
    input clk,
    input rst,
    input we,
    input [1:0] write_addr,
    input [7:0] write_data,
    input [1:0] read_addr1,
    input [1:0] read_addr2,
    output [7:0] read_data1,
    output [7:0] read_data2
);

reg [7:0] regfile [0:3];
integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        regfile[0] <= 8'd10;
        regfile[1] <= 8'd5;
        regfile[2] <= 8'd3;
        regfile[3] <= 8'd1;
    end else if (we) begin
        regfile[write_addr] <= write_data;
    end
end

assign read_data1 = regfile[read_addr1];
assign read_data2 = regfile[read_addr2];

endmodule
