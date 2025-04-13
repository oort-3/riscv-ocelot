module csa #(parameter VSEW = 32)
(
  input  [VSEW-1:0] a, b, c,
  output [VSEW-1:0] sum,
  output [VSEW-1:0] carry
);
    assign sum   = a ^ b ^ c;
    assign carry = ( (a & b) | (b & c) | (a & c) ) << 1;
endmodule

module csa_tree_8 #(parameter VSEW = 8)
(
    input [VSEW-1:0] A0, A1, A2, A3, A4, A5, A6, A7, A8, A9,
                     A10, A11, A12, A13, A14, A15, A16, A17, A18, A19,
                     A20, A21, A22, A23, A24, A25, A26, A27, A28, A29,
                     A30, A31, A32,
    //output [VSEW-1:0] result
  	output [VSEW-1:0] sum_final, carry_final
);

    //wire [VSEW-1:0] sum_final, carry_final;

    // Stage 1
    wire [VSEW-1:0] S1, C1, S2, C2, S3, C3, S4, C4, S5, C5, S6, C6;
    wire [VSEW-1:0] S7, C7, S8, C8, S9, C9, S10, C10, S11, C11;

    csa #(.VSEW(VSEW)) U1 (.a(A0), .b(A1), .c(A2), .sum(S1), .carry(C1));
    csa #(.VSEW(VSEW)) U2 (.a(A3), .b(A4), .c(A5), .sum(S2), .carry(C2));
    csa #(.VSEW(VSEW)) U3 (.a(A6), .b(A7), .c(A8), .sum(S3), .carry(C3));
    csa #(.VSEW(VSEW)) U4 (.a(A9), .b(A10), .c(A11), .sum(S4), .carry(C4));
    csa #(.VSEW(VSEW)) U5 (.a(A12), .b(A13), .c(A14), .sum(S5), .carry(C5));
    csa #(.VSEW(VSEW)) U6 (.a(A15), .b(A16), .c(A17), .sum(S6), .carry(C6));
    csa #(.VSEW(VSEW)) U7 (.a(A18), .b(A19), .c(A20), .sum(S7), .carry(C7));
    csa #(.VSEW(VSEW)) U8 (.a(A21), .b(A22), .c(A23), .sum(S8), .carry(C8));
    csa #(.VSEW(VSEW)) U9 (.a(A24), .b(A25), .c(A26), .sum(S9), .carry(C9));
    csa #(.VSEW(VSEW)) U10 (.a(A27), .b(A28), .c(A29), .sum(S10), .carry(C10));
    csa #(.VSEW(VSEW)) U11 (.a(A30), .b(A31), .c(A32), .sum(S11), .carry(C11));

    // Stage 2
    wire [VSEW-1:0] S12, C12, S13, C13, S14, C14, S15, C15;
    wire [VSEW-1:0] S16, C16, S17, C17, S18, C18;

    csa #(.VSEW(VSEW)) U12 (.a(S1), .b(C1), .c(S2), .sum(S12), .carry(C12));
    csa #(.VSEW(VSEW)) U13 (.a(C2), .b(S3), .c(C3), .sum(S13), .carry(C13));
    csa #(.VSEW(VSEW)) U14 (.a(S4), .b(C4), .c(S5), .sum(S14), .carry(C14));
    csa #(.VSEW(VSEW)) U15 (.a(C5), .b(S6), .c(C6), .sum(S15), .carry(C15));
    csa #(.VSEW(VSEW)) U16 (.a(S7), .b(C7), .c(S8), .sum(S16), .carry(C16));
    csa #(.VSEW(VSEW)) U17 (.a(C8), .b(S9), .c(C9), .sum(S17), .carry(C17));
    csa #(.VSEW(VSEW)) U18 (.a(S10), .b(C10), .c(S11), .sum(S18), .carry(C18));

    // Stage 3
    wire [VSEW-1:0] S19, C19, S20, C20, S21, C21;
    wire [VSEW-1:0] S22, C22, S23, C23;

    csa #(.VSEW(VSEW)) U19 (.a(S12), .b(C12), .c(S13), .sum(S19), .carry(C19));
    csa #(.VSEW(VSEW)) U20 (.a(C13), .b(S14), .c(C14), .sum(S20), .carry(C20));
    csa #(.VSEW(VSEW)) U21 (.a(S15), .b(C15), .c(S16), .sum(S21), .carry(C21));
    csa #(.VSEW(VSEW)) U22 (.a(C16), .b(S17), .c(C17), .sum(S22), .carry(C22));
    csa #(.VSEW(VSEW)) U23 (.a(S18), .b(C18), .c(C11), .sum(S23), .carry(C23));

    // Stage 4
    wire [VSEW-1:0] S24, C24, S25, C25, S26, C26;

    csa #(.VSEW(VSEW)) U24 (.a(S19), .b(C19), .c(S20), .sum(S24), .carry(C24));
    csa #(.VSEW(VSEW)) U25 (.a(C20), .b(S21), .c(C21), .sum(S25), .carry(C25));
    csa #(.VSEW(VSEW)) U26 (.a(S22), .b(C22), .c(S23), .sum(S26), .carry(C26));

    // Stage 5
    wire [VSEW-1:0] S27, C27, S28, C28;

    csa #(.VSEW(VSEW)) U27 (.a(S24), .b(C24), .c(S25), .sum(S27), .carry(C27));
    csa #(.VSEW(VSEW)) U28 (.a(S26), .b(C26), .c(C23), .sum(S28), .carry(C28));

    // Stage 6
    wire [VSEW-1:0] S29, C29;

    csa #(.VSEW(VSEW)) U29 (.a(S27), .b(C27), .c(C25), .sum(S29), .carry(C29));

    // Stage 7
    wire [VSEW-1:0] S30, C30;
    csa #(.VSEW(VSEW)) U30 (.a(S29), .b(C29), .c(S28), .sum(S30), .carry(C30));
  
    // Stage 8
    csa #(.VSEW(VSEW)) U31 (.a(S30), .b(C30), .c(C28), .sum(sum_final), .carry(carry_final));
  
    // Final Adder
    //assign result = sum_final+carry_final;

endmodule




module csa_tree_16 #(parameter VSEW = 16)
(
  input  [VSEW-1:0] A0, A1, A2, A3, A4, A5, A6, A7, A8, A9,
                    A10, A11, A12, A13, A14, A15, A16,
  //output [VSEW-1:0] result
  output [VSEW-1:0] sum_final, carry_final
);

    //wire [VSEW-1:0] sum_final, carry_final;

    // Stage 1
    wire [VSEW-1:0] S1, C1, S2, C2, S3, C3, S4, C4, S5, C5;

    csa #(.VSEW(VSEW)) U1 (.a(A0), .b(A1), .c(A2), .sum(S1), .carry(C1));
    csa #(.VSEW(VSEW)) U2 (.a(A3), .b(A4), .c(A5), .sum(S2), .carry(C2));
    csa #(.VSEW(VSEW)) U3 (.a(A6), .b(A7), .c(A8), .sum(S3), .carry(C3));
    csa #(.VSEW(VSEW)) U4 (.a(A9), .b(A10), .c(A11), .sum(S4), .carry(C4));
    csa #(.VSEW(VSEW)) U5 (.a(A12), .b(A13), .c(A14), .sum(S5), .carry(C5));

    // Stage 2
    wire [VSEW-1:0] S6, C6, S7, C7, S8, C8, S9, C9;

    csa #(.VSEW(VSEW)) U6 (.a(S1), .b(C1), .c(S2), .sum(S6), .carry(C6));
    csa #(.VSEW(VSEW)) U7 (.a(C2), .b(S3), .c(C3), .sum(S7), .carry(C7));
    csa #(.VSEW(VSEW)) U8 (.a(S4), .b(C4), .c(S5), .sum(S8), .carry(C8));
    csa #(.VSEW(VSEW)) U9 (.a(C5), .b(A15), .c(A16), .sum(S9), .carry(C9));

    // Stage 3
    wire [VSEW-1:0] S10, C10, S11, C11;
    csa #(.VSEW(VSEW)) U10 (.a(S6), .b(C6), .c(S7), .sum(S10), .carry(C10));
    csa #(.VSEW(VSEW)) U11 (.a(C7), .b(S8), .c(C8), .sum(S11), .carry(C11));

    // Stage 4
    wire [VSEW-1:0] S12, C12, S13, C13;
    csa #(.VSEW(VSEW)) U12 (.a(S10), .b(C10), .c(S11), .sum(S12), .carry(C12));
    csa #(.VSEW(VSEW)) U13 (.a(C11), .b(S9), .c(C9), .sum(S13), .carry(C13));

    // Stage 5
    wire [VSEW-1:0] S14, C14;
  
    csa #(.VSEW(VSEW)) U14 (.a(S12), .b(C12), .c(S13), .sum(S14), .carry(C14));

    // Stage 6
    csa #(.VSEW(VSEW)) U15 (.a(S14), .b(C14), .c(C13), .sum(sum_final), .carry(carry_final));

    // Final Adder
    //assign result = sum_final + carry_final;

endmodule

module csa_tree_32 #(parameter VSEW = 32)
(
  input  [VSEW-1:0] A0, A1, A2, A3, A4, A5, A6, A7, A8,
  //output [VSEW-1:0] result
  output [VSEW-1:0] sum_final, carry_final
  
);
    wire [VSEW-1:0] S1, C1, S2, C2, S3, C3;
    wire [VSEW-1:0] S4, C4, S5, C5;
    wire [VSEW-1:0] S6, C6;
    //wire [VSEW-1:0] sum_final, carry_final;

    // Stage 1
    csa #(.VSEW(VSEW)) u1 (.a(A0), .b(A1), .c(A2), .sum(S1), .carry(C1));
    csa #(.VSEW(VSEW)) u2 (.a(A3), .b(A4), .c(A5), .sum(S2), .carry(C2));
    csa #(.VSEW(VSEW)) u3 (.a(A6), .b(A7), .c(A8), .sum(S3), .carry(C3));

    // Stage 2
    csa #(.VSEW(VSEW)) u4 (.a(S1), .b(C1), .c(S2), .sum(S4), .carry(C4));
    csa #(.VSEW(VSEW)) u5 (.a(C2), .b(S3), .c(C3), .sum(S5), .carry(C5));

    // Stage 3
    csa #(.VSEW(VSEW)) u6 (.a(S4), .b(C4), .c(S5), .sum(S6), .carry(C6));

    // Stage 4
    csa #(.VSEW(VSEW)) u7 (.a(C5), .b(S6), .c(C6), .sum(sum_final), .carry(carry_final));

//     Final Adder
//     assign result = sum_final + carry_final;

endmodule

module csa_tree_64 #(parameter VSEW = 64)
(
  input  [VSEW-1:0] A0, A1, A2, A3, A4,
  //output [VSEW-1:0] result
  output [VSEW-1:0] sum_final, carry_final
);
  wire [VSEW-1:0] S1, C1, S2, C2;
  //wire [VSEW-1:0] sum_final, carry_final;

    // Stage 1
    csa #(.VSEW(VSEW)) u1 (.a(A0), .b(A1), .c(A2), .sum(S1), .carry(C1));
    
    // Stage 2
    csa #(.VSEW(VSEW)) u2 (.a(S1), .b(C1), .c(A3), .sum(S2), .carry(C2));
  
  	// Stage 3
    csa #(.VSEW(VSEW)) u3 (.a(S2), .b(C2), .c(A4), .sum(sum_final), .carry(carry_final));

    // Final Adder
   // assign result = sum_final + carry_final;

endmodule


module csa_TOP #(parameter VSEW_temp = 32)
  (input [255:0] vs1, vs2,
   input clk,
   input [1:0] vsew,
   output reg [63:0] result
  );
  
  
  //individual tree outputs
  wire [7:0] out8_carry, out8_sum;
  wire [15:0] out16_carry, out16_sum;
  wire [31:0] out32_carry, out32_sum;
  wire [63:0] out64_carry, out64_sum;
  
  //wires for the mux output
  reg [63:0] final_carry, final_sum;
  
  //getting correct part of vs2
  wire [63:0] a8_64;
  wire [31:0] a8_32;
  wire [15:0] a8_16;
  wire [7:0] a8_8;
  assign a8_64 = vs2[63:0];
  assign a8_32 = vs2[31:0];
  assign a8_16 = vs2[15:0];
  assign a8_8 = vs2[7:0];
  
  
  //generate statements to split up vs1 into correct sizes, could add masking logic in here for efficiency or after for simplicity
  wire [63:0] slice_64 [3:0];
  genvar i64;
  generate
    for (i64 = 0; i64 < 4; i64 = i64 + 1) begin
      assign slice_64[i64] = vs1[255 - i64*64 -: 64];
    end
  endgenerate
  
  wire [31:0] slice_32 [7:0];
    genvar i32;
    generate
        for (i32 = 0; i32 < 8; i32 = i32 + 1) begin
          assign slice_32[i32] = vs1[255 - i32*32 -: 32];
        end
    endgenerate
  
  wire [15:0] slice_16 [15:0];
    genvar i16;
    generate
        for (i16 = 0; i16 < 16; i16 = i16 + 1) begin
          assign slice_16[i16] = vs1[255 - i16*16 -: 16];
        end
    endgenerate
  
   wire [7:0] slice_8 [31:0];
    genvar i8;
    generate
        for (i8 = 0; i8 < 32; i8 = i8 + 1) begin
          assign slice_8[i8] = vs1[255 - i8*8 -: 8];
        end
    endgenerate
  
  csa_tree_64 u64 (.A0(slice_64[0]), .A1(slice_64[1]), .A2(slice_64[2]), .A3(slice_64[3]), .A4(a8_64), .sum_final(out64_sum), .carry_final(out64_carry));
  
  csa_tree_32 u32 (.A0(slice_32[0]), .A1(slice_32[1]), .A2(slice_32[2]), .A3(slice_32[3]), .A4(slice_32[4]), .A5(slice_32[5]), .A6(slice_32[6]), .A7(slice_32[7]), .A8(a8_32), .sum_final(out32_sum), .carry_final(out32_carry));
  
  csa_tree_16 u16 (.A0(slice_16[0]), .A1(slice_16[1]), .A2(slice_16[2]), .A3(slice_16[3]), .A4(slice_16[4]), .A5(slice_16[5]), .A6(slice_16[6]), .A7(slice_16[7]), .A8(slice_16[8]), .A9(slice_16[9]), .A10(slice_16[10]), .A11(slice_16[11]), .A12(slice_16[12]), .A13(slice_16[13]), .A14(slice_16[14]), .A15(slice_16[15]), .A16(a8_16), .sum_final(out16_sum), .carry_final(out16_carry)); 
  
  csa_tree_8 u8 (.A0(slice_8[0]), .A1(slice_8[1]), .A2(slice_8[2]), .A3(slice_8[3]), .A4(slice_8[4]), .A5(slice_8[5]), .A6(slice_8[6]), .A7(slice_8[7]), .A8(slice_8[8]), .A9(slice_8[9]), .A10(slice_8[10]), .A11(slice_8[11]), .A12(slice_8[12]), .A13(slice_8[13]), .A14(slice_8[14]), .A15(slice_8[15]), .A16(slice_8[16]), .A17(slice_8[17]), .A18(slice_8[18]), .A19(slice_8[19]), .A20(slice_8[20]), .A21(slice_8[21]), .A22(slice_8[22]), .A23(slice_8[23]), .A24(slice_8[24]), .A25(slice_8[25]), .A26(slice_8[26]), .A27(slice_8[27]), .A28(slice_8[28]), .A29(slice_8[29]), .A30(slice_8[30]), .A31(slice_8[31]), .A32(a8_8), .sum_final(out8_sum), .carry_final(out8_carry));
  
  //mux block (not clocked, comb)
  always_comb begin
    case(vsew)
      2'b00: begin
        final_carry = {56'h00000000000000, out8_carry};
        final_sum = {56'h00000000000000, out8_sum};
        
      end
      2'b01: begin
        final_carry = {48'h000000000000, out16_carry};
      	final_sum = {48'h000000000000, out16_sum};
      end
      2'b10: begin
        final_carry = {32'h00000000, out32_carry};
        final_sum = {32'h00000000, out32_sum};
      end
      2'b11: begin
        final_carry = out64_carry;
        final_sum = out64_sum;
      end
      
      default	: begin
        final_carry = out64_carry;
        final_sum = out64_sum;
      end
    endcase
  end
  
  //clocked adder
  always @(posedge clk) begin
      result <= final_carry + final_sum;
    end
  
  //right here would be a different way to do the final add and latching comment out above clocked block and uncomment this one
//   wire [63:0] result_next = final_sum + final_carry;

//   always @(posedge clk) begin
//   	  result <= result_next;
// 	end

  
  
endmodule
