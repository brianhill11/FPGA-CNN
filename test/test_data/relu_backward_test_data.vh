`ifndef RELU_BACKWARD_TEST_H
`define RELU_BACKWARD_TEST_H
reg [31:0] test_input [32];
reg [31:0] test_output [32];
initial begin
test_input[0:7] = '{32'hc20092d4, 32'hc249fe9e, 32'h419b9777, 32'hc1d8cb9c, 32'hc1458f64, 32'h41c7d214, 32'hc243b00d, 32'hc05163c4};
test_output[0:7] = '{32'h0, 32'h0, 32'h419b9777, 32'h0, 32'h0, 32'h41c7d214, 32'h0, 32'h0};
test_input[8:15] = '{32'hc29da639, 32'hc2af396e, 32'hc248b316, 32'h40151ddf, 32'h4265fe82, 32'hc2577fd0, 32'hc29ed7cc, 32'h429fac50};
test_output[8:15] = '{32'h0, 32'h0, 32'h0, 32'h40151ddf, 32'h4265fe82, 32'h0, 32'h0, 32'h429fac50};
test_input[16:23] = '{32'hc2a78315, 32'h421b373d, 32'hc2711509, 32'hc29ab816, 32'h4052604d, 32'h4221c0e6, 32'hc26d1308, 32'h423b3965};
test_output[16:23] = '{32'h0, 32'h421b373d, 32'h0, 32'h0, 32'h4052604d, 32'h4221c0e6, 32'h0, 32'h423b3965};
test_input[24:31] = '{32'h41fc8396, 32'hc232ffd1, 32'hc17f08bd, 32'hc16cd599, 32'hc24508fe, 32'hc25bb778, 32'h426fa87b, 32'hc29144d5};
test_output[24:31] = '{32'h41fc8396, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h426fa87b, 32'h0};
end
`endif
