`ifndef RELU_FORWARD_TEST_H
`define RELU_FORWARD_TEST_H
reg [31:0] test_input [32];
reg [31:0] test_output [32];
initial begin
test_input[0:7] = '{32'hc24cc7b2, 32'hc03942dd, 32'h42ac2ee9, 32'hc2a124a4, 32'h4284650a, 32'h411f589b, 32'h42c7a9ad, 32'h429d677d};
test_output[0:7] = '{32'h0, 32'h0, 32'h42ac2ee9, 32'h0, 32'h4284650a, 32'h411f589b, 32'h42c7a9ad, 32'h429d677d};
test_input[8:15] = '{32'hc20fb75a, 32'hc1617cb2, 32'hc2af2f38, 32'hc2308ca7, 32'hc1468566, 32'hc2b42a23, 32'hc2419dc9, 32'h42b6ab60};
test_output[8:15] = '{32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h42b6ab60};
test_input[16:23] = '{32'h41d54d29, 32'h4262adb9, 32'h41acdc10, 32'h42a6be27, 32'h42939ccf, 32'h41df8a5d, 32'h424a5b51, 32'hc28aac05};
test_output[16:23] = '{32'h41d54d29, 32'h4262adb9, 32'h41acdc10, 32'h42a6be27, 32'h42939ccf, 32'h41df8a5d, 32'h424a5b51, 32'h0};
test_input[24:31] = '{32'hc25a0698, 32'h42616625, 32'h420abe2d, 32'h429b77b5, 32'h4259205d, 32'h4214999c, 32'hc26a3450, 32'hc29bb946};
test_output[24:31] = '{32'h0, 32'h42616625, 32'h420abe2d, 32'h429b77b5, 32'h4259205d, 32'h4214999c, 32'h0, 32'h0};
end
`endif
