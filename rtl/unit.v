module unit #(
    parameter DATA_WIDTH = 16
) (
    input wire                          clk,
    input wire                          rst,
    input wire                          en,
    input wire [DATA_WIDTH - 1  : 0]    data_i,
    input wire [DATA_WIDTH - 1  : 0]    weight_i,
    input wire [DATA_WIDTH - 1  : 0]    bias_i,
    output reg [DATA_WIDTH - 1  : 0]    result
);

    always @(posedge clk) begin
        if (rst) begin
            result <= {DATA_WIDTH{1'b0}};
        end else if (en) begin
            result <= weight_i * data_i + bias_i;
        end
    end

endmodule