
module tb_csa_TOP;
  reg [255:0] vs1, vs2;
  reg clk = 0;
  reg [1:0] vsew;
  wire [63:0] result;
  
  parameter CYCLE = 10;
  integer i, j;
  integer pass = 0, fail = 0;
  
  logic [63:0] expected;
  
  csa_TOP dut (
    .vs1(vs1),
    .vs2(vs2),
    .vsew(vsew),
    .clk(clk),
    .result(result)
  );
  
  //Clock
  always #(CYCLE/2) clk = ~clk;
  
  //function to compute the expected result
  function automatic [63:0] compute_expected(input [255:0] vs1, input [255:0] vs2, input [1:0] vsew);
    integer k;
    reg [63:0] sum;
    begin
      sum = 0;
      case (vsew)
        2'b11: begin
          for (k = 0;k < 4; k = k + 1)
            sum += vs1[255 - k*64 -: 64];
          sum += vs2[63:0];
        end
        2'b10: begin
          for (k = 0;k < 8; k = k + 1)
            sum += vs1[255 - k*32 -: 32];
          sum += vs2[31:0];
        end
        2'b01: begin
          for (k = 0;k < 16; k = k + 1)
            sum += vs1[255 - k*16 -: 16];
          sum += vs2[15:0];
        end
        2'b00: begin
          for (k = 0;k < 32; k = k + 1)
            sum += vs1[255 - k*8 -: 8];
          sum += vs2[7:0];
        end
      endcase
      return sum[63:0];
    end
  endfunction
  
  initial begin
    //int VSEW_expected; //this is to make sure the tests don't fail bc of overflow
    $display("Starting test for csa_TOP...");
    $dumpfile("csa_TOP.vcd");
    $dumpvars(0, tb_csa_TOP);
    
    
    for (i = 0; i < 10; i = i + 1) begin
      vs1 = {$random, $random, $random, $random, $random, $random, $random, $random};
      vs2 = {$random, $random, $random, $random, $random, $random, $random, $random};
      
      for(j = 0; j < 4; j = j + 1) begin
        vsew = j[1:0];
        
        
        expected = compute_expected(vs1, vs2, vsew);
        
        @(posedge clk);
        @(posedge clk);
        
        case (vsew)
    		2'b11: begin
              	if (result[63:0] === expected[63:0]) begin
                  $display("Test %0d VSEW=64 PASSED: Result = %h", i, result);
                  //$display("VS1 = %h VS2 = %h", vs1, vs2);
          			pass++;
                  end else begin
               		$display("Test %0d VSEW=64 FAILED: Expected = %h, Got = %h", i, expected[63:0], result[63:0]);
               		fail++;
                end
           end
          2'b10: begin
            if (result[31:0] === expected[31:0]) begin
              $display("Test %0d VSEW=32 PASSED: Result = %h", i, result);
          			pass++;
                  end else begin
                    $display("Test %0d VSEW=32 FAILED: Expected = %h, Got = %h", i, expected[63:0], result[63:0]);
               		fail++;
                end
           end
          2'b01: begin
            if (result[15:0] === expected[15:0]) begin
              $display("Test %0d VSEW=16 PASSED: Result = %h", i, result);
          			pass++;
                  end else begin
                    $display("Test %0d VSEW=16 FAILED: Expected = %h, Got = %h", i, expected[63:0], result[63:0]);
               		fail++;
                end
           end
          2'b00: begin
            if (result[7:0] === expected[7:0]) begin
              $display("Test %0d VSEW=8 PASSED: Result = %h", i, result);
          			pass++;
                  end else begin
                    $display("Test %0d VSEW=8 FAILED: Expected = %h, Got = %h", i, expected[63:0], result[63:0]);
               		fail++;
                end
           end
        endcase
        
      end
    end
    
    $display("Testing complete: %0d passed, %0d failed", pass, fail);
    $finish;
  end
endmodule
  
  
  
