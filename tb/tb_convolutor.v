module tb_convolutor ();
    localparam N            = 100;
    localparam DATA_WIDTH   = 32;
    localparam Q            = 10;
    reg clk;
    reg rst;
    wire [DATA_WIDTH - 1: 0] data_o;
    wire valid_o, running_o;

    reg ena;
    reg valid_i;
    reg [13             : 0]    addra;
    wire[DATA_WIDTH - 1 : 0]    douta;
    img_block img_inst (
        .clka   (clk    ),      // input wire clka
        .ena    (ena    ),      // input wire ena
        .addra  (addra  ),      // input wire [13 : 0] addra
        .douta  (douta  )       // output wire [15 : 0] douta
    );

    conv_top #(
        .N          (N          ),
        .DATA_WIDTH (DATA_WIDTH ),
        .Q          (Q          )
    ) top_inst (
        .clk        (clk    ),
        .rst        (rst    ),
        .ena        (ena    ),
        .data_i     (douta  ),
        .valid_i    (addra != 14'b0),
        .data_o     (data_o ),
        .valid_o    (valid_o),
        .running_o  (running_o)
    );
    
    integer fp;

    initial begin
        clk = 1'b0;
        fp = $fopen("C:/Users/Ellen7ions/Desktop/conv_fpga/tb/img_result.txt", "w");
        forever begin
            #5 clk = 1'b1;
            #5 clk = 1'b0;
        end
    end

    initial begin
        rst = 1'b1;
        ena = 1'b0;
        #25 begin
            rst = 1'b0;
        end

        // #25 ena = 1'b0;
    end

    reg finished;

    integer i = 0;
    always @(posedge clk) begin
        if (rst) begin
            addra <= 14'b0;
            valid_i <= 1'b1;
            ena <= 1'b0;

            finished <= 1'b0;
        end else begin

            if (ena && addra != N * N + 1)
                addra <= addra + 14'b1;

            if (!finished && addra == N * N) begin
                ena <= 1'b0;
                finished <= 1'b1;
            end else if (!finished) begin
                ena <= 1'b1;
            end

            if (running_o && valid_o) begin
                // for (i = 15; i >= 0; i = i - 1) begin
                //     $fwrite(fp, "%d", data_o[i]);    
                // end
                $fwrite(fp, "%b\n", data_o);
                $display("%d\n", data_o);
            end
        end
    end

    reg[1: 0] cur;
    always @(posedge clk) begin
        if (rst) begin
            cur <= 2'b00;
        end else begin
            case (cur)
                2'b00: begin
                    if (running_o) cur <= 2'b10;
                end
                
                2'b10: begin
                    if (~running_o) begin
                        $fclose(fp);
                        $finish;
                    end
                end
            endcase
        end
    end

endmodule