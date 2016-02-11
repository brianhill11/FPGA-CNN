`ifndef CONV_FORWARD_TEST_H
`define CONV_FORWARD_TEST_H
reg [31:0] test_input [32];
reg [31:0] test_weights [32];
reg [31:0] test_bias [4];
reg [31:0] test_output [4];
initial begin
test_input[0:7] = '{32'hc2729d1c, 32'hc285e4d0, 32'hc1c44ff5, 32'h410f9da1, 32'h41be9d5b, 32'h4203fea6, 32'hc1455c0c, 32'h424d9e34};
test_weights[0:7] = '{32'h3f98215f, 32'h42811eba, 32'h4208690a, 32'hc2b31298, 32'h42468c0c, 32'h423e1f16, 32'h41dae951, 32'hc21f1268};
test_bias[0] = '{32'h0};
test_output[0] = '{32'hc5b10ae5};
test_input[8:15] = '{32'hc2213567, 32'hc1cac038, 32'h42b2b80d, 32'hc256b7ba, 32'h4276c5de, 32'hc25a11eb, 32'h415c6bda, 32'h4103a382};
test_weights[8:15] = '{32'h41beb921, 32'hc2733cef, 32'h4242c0d8, 32'hc25433af, 32'hc2b3c306, 32'hc22209b6, 32'h42845e14, 32'h42c43622};
test_bias[1] = '{32'h0};
test_output[1] = '{32'h45c08959};
test_input[16:23] = '{32'h424a9969, 32'hc29bd681, 32'hc2902df2, 32'hc2347c2e, 32'h42c7a96e, 32'hc293a865, 32'hc2674ed4, 32'hc1a06f16};
test_weights[16:23] = '{32'h424c6d7b, 32'h41fa09ce, 32'h41e406d8, 32'hc248e242, 32'hc27f549e, 32'hc19feb02, 32'hc2b61cff, 32'hc1b36afb};
test_bias[2] = '{32'h0};
test_output[2] = '{32'h4493e2f7};
test_input[24:31] = '{32'hc2c75a98, 32'h42038fe6, 32'hc25b83b1, 32'hc2c26972, 32'hc22bab50, 32'hc2a6d247, 32'hc1a3bef7, 32'h425aefa8};
test_weights[24:31] = '{32'hc281fa94, 32'hc2035e47, 32'h4290263f, 32'h40cc8828, 32'hc1a9cce2, 32'h4213775d, 32'hc0b76275, 32'h410af0d6};
test_bias[3] = '{32'h0};
test_output[3] = '{32'hc43b9d31};
end
`endif
