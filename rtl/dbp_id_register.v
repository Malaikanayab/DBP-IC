
module dbp_id_register (
    input wire clk,
    input wire rst_n,
    input wire write_en,
    input wire [31:0] write_data,
    output reg [31:0] id_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            id_out <= 32'b0;
        else if (write_en)
            id_out <= write_data;
    end

endmodule
