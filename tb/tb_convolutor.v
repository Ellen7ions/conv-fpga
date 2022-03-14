module tb_convolutor ();
    reg clk;
    reg rst;
    wire [15: 0] data_o;
    wire ok;

    conv_top top_inst (
        .clk    (clk    ),
        .rst    (rst    ),
        .data_o (data_o ),
        .valid_o(ok     )
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
        #25 rst = 1'b0;
    end

    always @(posedge clk) begin
        if (rst) begin
        end else begin
            if (ok) begin
                $fwrite(fp, "%d\n", data_o);
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
                    if (ok) cur <= 2'b10;
                end
                
                2'b10: begin
                    if (~ok) begin
                        $fclose(fp);
                        $finish;
                    end
                end
            endcase
        end
    end

endmodule