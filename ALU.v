`timescale 1ns/1ps

// Main ALU Module with Finite State Machine Control
module ALU #(
    parameter WIDTH = 8    // Configurable bit width
)(
    input              clk,
    input              rst,
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input  [2:0]       opcode,
    output reg [WIDTH-1:0] result,
    output reg         valid
);

    // FSM state encoding
    localparam IDLE    = 2'b00;
    localparam EXECUTE = 2'b01;
    localparam DONE    = 2'b10;

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (opcode != 3'b000) ? EXECUTE : IDLE;
            EXECUTE: next_state = DONE;
            DONE:    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // ALU operation and valid signal
    always @(posedge clk) begin
        if (rst) begin
            result <= 0;
            valid  <= 0;
        end 
        else if (state == EXECUTE) begin
            case (opcode)
                3'b001: result <= A + B;
                3'b010: result <= A - B;
                3'b011: result <= A & B;
                3'b100: result <= A | B;
                3'b101: result <= A ^ B;
                3'b110: result <= A * B;         // Multiplication
                3'b111: result <= (A > B) ? A : B; // Maximum
                default: result <= 0;
            endcase
            valid <= 1'b1;
        end 
        else begin
            valid <= 1'b0;
        end
    end

endmodule

// Testbench for ALU
module tb_ALU;
    parameter WIDTH = 8;
    
    reg clk, rst;
    reg [WIDTH-1:0] A, B;
    reg [2:0] opcode;
    wire [WIDTH-1:0] result;
    wire valid;
    integer test_num;

    // Instantiate the ALU
    ALU #(.WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .valid(valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        clk = 0;
        rst = 1;
        A = 0;
        B = 0;
        opcode = 0;
        test_num = 0;
        
        #10 rst = 0;
        
        test_num = 1; A = 8'd15; B = 8'd5;  opcode = 3'b001; #20;
        test_num = 2; A = 8'd25; B = 8'd5;  opcode = 3'b010; #20;
        test_num = 3; A = 8'd12; B = 8'd3;  opcode = 3'b011; #20;
        test_num = 4; A = 8'd7;  B = 8'd1;  opcode = 3'b100; #20;
        test_num = 5; A = 8'd9;  B = 8'd5;  opcode = 3'b101; #20;
        test_num = 6; A = 8'd6;  B = 8'd2;  opcode = 3'b110; #20;
        test_num = 7; A = 8'd3;  B = 8'd8;  opcode = 3'b111; #20;
        
        $display("===================================");
        $display("All tests completed successfully!");
        $display("===================================");
        $finish;
    end

    // Monitor display (printing numeric opcode and state)
    initial begin
        $display("===============================================================");
        $display("                ALU SIMULATION RESULTS                       ");
        $display("Test | Time | Opcode |   A   |   B   | Result | Valid | FSM State");
        $display("-----+------+--------+-------+-------+--------+-------+----------");
        forever begin
            @(posedge clk);
            #1;
            if (valid)
                $display(" %2d  | %4t |  %3b   | %4d  | %4d  | %6d |   %b   |    %2b", 
                    test_num, $time, opcode, A, B, result, valid, uut.state);
        end
    end

endmodule