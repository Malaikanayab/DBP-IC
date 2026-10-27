
`timescale 1ns/1ps

module tb_dbp_id_register;

    reg clk;
    reg rst_n;
    reg write_en;
    reg [31:0] write_data;
    wire [31:0] id_out;

    dbp_id_register uut (
        .clk(clk),
        .rst_n(rst_n),
        .write_en(write_en),
        .write_data(write_data),
        .id_out(id_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 1;
        write_en = 0;
        write_data = 0;

        // Test 1: Reset
        #2 rst_n = 0;
        #2;

        if (id_out !== 32'h00000000)
            $fatal(1, "FAIL: Reset");

        rst_n = 1;

        // Test 2: Write battery ID
        @(negedge clk);
        write_en = 1;
        write_data = 32'h12345678;

        @(posedge clk);
        #1;

        if (id_out !== 32'h12345678)
            $fatal(1, "FAIL: ID write");

        // Test 3: Hold battery ID
        @(negedge clk);
        write_en = 0;
        write_data = 32'hAAAAAAAA;

        @(posedge clk);
        #1;

        if (id_out !== 32'h12345678)
            $fatal(1, "FAIL: ID hold");

        $display("PASS: All ID register tests passed");
        $finish;
    end

endmodule
