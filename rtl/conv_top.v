module conv_top #(
    parameter N             = 4,
    parameter DATA_WIDTH    = 16,
    parameter Q             = 5,
    parameter K_SIZE        = 3
) (
    input   wire            clk,
    input   wire            rst,
    output  wire [15: 0]    data_o,
    output  reg             valid_o,
    output  wire            running_o
);

    reg     [13: 0] addra;
    wire    [15: 0] douta;
    reg             ena;

    img_block img_inst (
        .clka   (clk    ),      // input wire clka
        .ena    (ena    ),      // input wire ena
        .addra  (addra  ),      // input wire [13 : 0] addra
        .douta  (douta  )       // output wire [15 : 0] douta
    );

    convolutor #(
        .N          (N          ),
        .DATA_WIDTH (DATA_WIDTH ),
        .Q          (Q          ),
        .K_SIZE     (K_SIZE     )
    ) conv_inst (
        .clk    (clk    ),
        .rst    (rst    ),
        .en     (ena    ),
        .data_i (douta  ),
        .data_o (data_o )
    );


    reg         o_ena;
    reg [15:0]  o_counter;

    always @(posedge clk) begin
        if (rst) begin
            addra       <= 14'b0;
            valid_o     <= 1'b0;
            ena         <= 1'b0;
            
            o_ena       <= 1'b0;
            o_counter   <= 16'b0;
        end else begin
            if (ena) begin
                addra <= addra + 14'b1;
                if (addra == K_SIZE * K_SIZE + (K_SIZE - 1) * (N - K_SIZE)) begin
                    valid_o <= 1'b1;
                    o_ena   <= 1'b1;
                    o_counter <= 1'b1;
                end

                if (o_ena) begin
                    o_counter <= o_counter + 16'b1;
                    if (o_counter < N - K_SIZE + 1) begin
                        valid_o <= 1'b1;
                    end else begin
                        valid_o <= 1'b0;
                    end

                    if (o_counter == N - 1) begin
                        o_counter <= 16'b0;
                    end
                end

                if (addra == (N - K_SIZE + 1) * (N - K_SIZE + 1) + (N - K_SIZE) * (K_SIZE - 1) + K_SIZE * K_SIZE + (K_SIZE - 1) * (N - K_SIZE)) begin
                    valid_o <= 1'b0;
                    ena <= 1'b0;
                    o_ena <= 1'b0;
                end
            end else if (addra == 14'b0) begin
                ena <= 1'b1;
            end
        end
    end

    assign running_o = ena;

endmodule