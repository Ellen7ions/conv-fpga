module unit #(
    parameter DATA_WIDTH    = 16,
    parameter Q             = 0
) (
    input wire                          clk,
    input wire                          rst,
    input wire                          en,
    input wire [DATA_WIDTH - 1  : 0]    data_i,
    input wire [DATA_WIDTH - 1  : 0]    weight_i,
    input wire [DATA_WIDTH - 1  : 0]    bias_i,
    output reg [DATA_WIDTH - 1  : 0]    result
);

    wire [DATA_WIDTH - 1: 0] mult_res;
    wire [DATA_WIDTH - 1: 0] add_res;

    qmult #(
        .Q(Q),
        .N(DATA_WIDTH)
    ) qmult_inst (
        .i_multiplicand (weight_i   ),
        .i_multiplier   (data_i     ),
        .o_result       (mult_res   ),
        .ovr            ()
    );

    qadd #(
        .Q(Q),
        .N(DATA_WIDTH)
    ) qadd_inst (
        .a(mult_res ),
        .b(bias_i   ),
        .c(add_res  )
    );

    always @(posedge clk) begin
        if (rst) begin
            result <= {DATA_WIDTH{1'b0}};
        end else if (en) begin
            result <= add_res;
        end
    end

endmodule