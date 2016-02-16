`ifndef CONV_FORWARD_TEST_H
`define CONV_FORWARD_TEST_H
reg [31:0] test_input [32];
reg [31:0] test_weights [32];
reg [31:0] test_bias [4];
reg [31:0] test_output [4];
initial begin
test_input[0:7] = '{32'hc29babdf, 32'hc273d7f6, 32'h4292f89c, 32'hc2894f57, 32'hc1fdd75c, 32'h42628044, 32'h41e8624d, 32'h424e104f};
test_weights[0:7] = '{32'h4287dc82, 32'hc211106b, 32'hc2658a1c, 32'hc25aa83e, 32'hc2b2814c, 32'hc2c1a613, 32'hc182b02e, 32'hc2b88647};
test_bias[0] = '{32'h0};
test_output[0] = '{32'hc6326b46};
test_input[8:15] = '{32'hc27d80f0, 32'hc189b156, 32'hc1cf120c, 32'hc0b9bfdf, 32'hc2910799, 32'hc1cda669, 32'h427a385c, 32'h42b6a9f0};
test_weights[8:15] = '{32'hc2afd0f5, 32'hbfd0a2b0, 32'hc2afbafe, 32'h41d6b10e, 32'h427ef9d7, 32'h428a8c9e, 32'hc28c551e, 32'h42935a67};
test_bias[1] = '{32'h0};
test_output[1] = '{32'h456466a3};
test_input[16:23] = '{32'h40afcd90, 32'hc1100f6e, 32'hc2050fd3, 32'hc2027ce1, 32'hc1dc4b0c, 32'hc2868392, 32'hc2b219ef, 32'h419723db};
test_weights[16:23] = '{32'hbfb9865b, 32'h4078fde1, 32'hc2900ecd, 32'hc1cffe60, 32'hc1507d6b, 32'h4044d4fe, 32'h41c27277, 32'hc123a934};
test_bias[2] = '{32'h0};
test_output[2] = '{32'h4478dfaa};
test_input[24:31] = '{32'h4086cebe, 32'h419665ce, 32'h40948667, 32'h42061dd8, 32'hc1980fbd, 32'hc2622d0a, 32'h41402536, 32'hc24713c5};
test_weights[24:31] = '{32'hc2334e0f, 32'hc206e7f0, 32'hc2c6b639, 32'h424cb5bd, 32'hc18b3bb8, 32'h428ab0f2, 32'hc2c32273, 32'h4287e1a5};
test_bias[3] = '{32'h0};
test_output[3] = '{32'hc5f0fb62};
end
`endif
