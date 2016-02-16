`ifndef CONV_FORWARD_TEST_H
`define CONV_FORWARD_TEST_H
reg [31:0] test_input [32];
reg [31:0] test_weights [32];
reg [31:0] test_bias [4];
reg [31:0] test_output [4];
initial begin
test_input[0:7] = '{32'hc26fdfa8, 32'h41ea2b51, 32'h3e756069, 32'hc2bee7c4, 32'h423ca13e, 32'hc267968b, 32'hc2a4d6eb, 32'hbf24c4f5};
test_weights[0:7] = '{32'hc2bd3f2f, 32'h41ef4376, 32'hc27bd7e5, 32'hc1f08333, 32'h42bbe746, 32'hc27ea48c, 32'h426c47d8, 32'h42a66c68};
test_bias[0] = '{32'h0};
test_output[0] = '{32'h4644da95};
test_input[8:15] = '{32'h412d307a, 32'h428e1128, 32'h41c2d156, 32'hc28b75cb, 32'hc2a8e015, 32'hc2be6fb6, 32'h42ae2cc5, 32'h40c8c53b};
test_weights[8:15] = '{32'hc2abe774, 32'hc25839a7, 32'hc22b3847, 32'hc2ae443f, 32'hc23d0c3a, 32'hc229a788, 32'h42b10fa1, 32'hc27d5624};
test_bias[1] = '{32'h0};
test_output[1] = '{32'h4673d400};
test_input[16:23] = '{32'hc14ebce8, 32'h429d3955, 32'h4287bf7d, 32'hc2a29a68, 32'h424818dd, 32'hc24a668e, 32'h42bb185d, 32'hc1d7b44e};
test_weights[16:23] = '{32'hc2a85391, 32'h42354df9, 32'h40af3936, 32'hc239319f, 32'h41e7b5dd, 32'h4231946c, 32'hc2b7509c, 32'h42932f0a};
test_bias[2] = '{32'h0};
test_output[2] = '{32'hc5209a1c};
test_input[24:31] = '{32'hc1f5d9f1, 32'h425b502f, 32'h42a95bb6, 32'hbf8976a8, 32'hc2c6ad6a, 32'h42a94dbc, 32'h42a60f14, 32'hc1f0abe3};
test_weights[24:31] = '{32'hc216c366, 32'h427c6416, 32'h42c1a9d4, 32'h42707064, 32'h42c3c705, 32'h42199cbe, 32'hc2b224ec, 32'h42a226d2};
test_bias[3] = '{32'h0};
test_output[3] = '{32'hc55e307e};
end
`endif
