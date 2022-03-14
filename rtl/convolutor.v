module convolutor #(
    parameter N             = 4,
    parameter DATA_WIDTH    = 16,
    parameter K_SIZE        = 3
) (
    input   wire                        clk,
    input   wire                        rst,
    input   wire                        en,
    input   wire [DATA_WIDTH - 1: 0]    data_i,
    output  wire [DATA_WIDTH - 1: 0]    data_o
);
    
    wire    [DATA_WIDTH - 1: 0] units_result    [K_SIZE * K_SIZE - 1: 0];
    reg     [DATA_WIDTH - 1: 0] kernel          [K_SIZE * K_SIZE - 1: 0];
    reg     [DATA_WIDTH - 1: 0] shift_regs      [K_SIZE - 2: 0][N - K_SIZE - 1: 0];

    initial begin
        $readmemh("C:/Users/Ellen7ions/Desktop/conv_fpga/tb/kernel_weights.txt", kernel);
    end

    genvar i;
    generate
        unit u0 (
            .clk        (clk                ),
            .rst        (rst                ),
            .en         (en                 ),
            .data_i     (data_i             ),
            .weight_i   (kernel[0]          ),
            .bias_i     ({DATA_WIDTH{1'b0}} ),
            .result     (units_result[0]    )
        );

        for (i = 1; i < K_SIZE * K_SIZE; i = i + 1) begin: units
            if (i % K_SIZE == 0) begin
                unit u (
                    .clk        (clk                    ),
                    .rst        (rst                    ),
                    .en         (en                     ),
                    .data_i     (data_i                 ),
                    .weight_i   (kernel[i]              ),
                    .bias_i     (shift_regs[i / K_SIZE - 1][N - K_SIZE - 1]),
                    .result     (units_result[i     ]   )
                );    
            end else begin
                unit u (
                    .clk        (clk                    ),
                    .rst        (rst                    ),
                    .en         (en                     ),
                    .data_i     (data_i                 ),
                    .weight_i   (kernel[i]              ),
                    .bias_i     (units_result[i - 1 ]   ),
                    .result     (units_result[i     ]   )
                );
            end
        end
    endgenerate

    genvar j;
    generate
        for (i = 0; i < K_SIZE - 1; i = i + 1) begin: outer_k
            
            always @(posedge clk) begin
                if (rst) begin
                    shift_regs[i][0] <= {DATA_WIDTH{1'b0}};
                end else if (en) begin
                    shift_regs[i][0] <= units_result[K_SIZE * (i + 1) - 1];
                end
            end
            
            for (j = 1; j < N - K_SIZE; j = j + 1) begin: inter_n_k
                always @(posedge clk) begin
                    if (rst) begin
                        shift_regs[i][j] <= {DATA_WIDTH{1'b0}};
                    end else if (en) begin
                        shift_regs[i][j] <= shift_regs[i][j - 1];
                    end
                end
            end
        end
    endgenerate

    assign data_o = units_result[K_SIZE * K_SIZE - 1];
    
endmodule