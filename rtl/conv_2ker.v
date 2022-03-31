module conv_2ker #(
    parameter N             = 4,
    parameter DATA_WIDTH    = 16,
    parameter Q             = 5,
    parameter K_SIZE        = 3
) (
    input   wire                        clk,
    input   wire                        rst,
    input   wire                        ena,
    input   wire [DATA_WIDTH - 1: 0]    data_i,
    input   wire                        valid_i,

    output  wire [DATA_WIDTH - 1: 0]    data_o,
    output  wire                        valid_o,
    output  wire                        running_o
);
    wire [DATA_WIDTH - 1: 0]    conv1_data_o;
    wire                        conv1_valid_o;
    wire                        conv1_running_o;

    conv_top # (
        .N          (N              ),
        .DATA_WIDTH (DATA_WIDTH     ),
        .Q          (Q              ),
        .K_SIZE     (K_SIZE         )
    ) conv1 (
        .clk        (clk            ),
        .rst        (rst            ),
        .ena        (ena            ),
        .data_i     (data_i         ),
        .valid_i    (valid_i        ),

        .data_o     (conv1_data_o   ),
        .valid_o    (conv1_valid_o  ),
        .running_o  (conv1_running_o)
    );

    conv_top # (
        .N          (N - K_SIZE + 1 ),
        .DATA_WIDTH (DATA_WIDTH     ),
        .Q          (Q              ),
        .K_SIZE     (K_SIZE         )
    ) conv2 (
        .clk        (clk            ),
        .rst        (rst            ),
        .ena        (conv1_running_o),
        .data_i     (conv1_data_o   ),
        .valid_i    (conv1_valid_o  ),

        .data_o     (data_o         ),
        .valid_o    (valid_o        ),
        .running_o  (running_o      )
    );

endmodule