# ALU FSM Verilog Project

This project implements an Arithmetic Logic Unit (ALU) with a Finite State Machine (FSM) control in Verilog. The ALU supports several operations based on a 3-bit opcode and is configurable by parameterized width.

## Files
- **test6.v**: Contains the ALU module and its testbench.
  - The ALU module uses a state machine with the following states:
    - `IDLE`: Waiting for a valid opcode.
    - `EXECUTE`: Executes the operation.
    - `DONE`: Completes the operation and returns to idle.
  - Supported operations:
    - `3'b001`: Addition
    - `3'b010`: Subtraction
    - `3'b011`: Bitwise AND
    - `3'b100`: Bitwise OR
    - `3'b101`: Bitwise XOR
    - `3'b110`: Multiplication
    - `3'b111`: Maximum (returns the larger of `A` and `B`)
- **README.md**: This file.

## Requirements

- [Icarus Verilog](http://iverilog.icarus.com/) (iverilog and vvp)
- A text editor or an IDE (such as Visual Studio Code)

## Compiling and Running the Simulation

1. Open a terminal in the project directory (e.g., `C:\Users\futur\Desktop\vscode_verilog`).

2. Compile the Verilog file using Icarus Verilog:
   ```
   iverilog -o simulation test6.v
   ```

3. Launch the simulation:
   ```
   vvp simulation
   ```

4. You should see output from the testbench indicating the operation performed, the values of `A`, `B`, the calculated `result`, and the current FSM state.

## Project Structure

```
C:\Users\futur\Desktop\vscode_verilog\
│
├── test6.v          // Main ALU and Testbench code
└── README.md        // Project documentation
```

## Explanation

- **FSM Control:**  
  The ALU design uses a simple FSM with three states to manage the execution of operations. When the module is reset, the state transitions to `IDLE`. When a valid opcode is provided (opcode ≠ 0), the FSM moves to `EXECUTE` for performing the selected operation and then to `DONE` before returning to `IDLE`.

- **ALU Operations:**  
  The ALU supports addition, subtraction, bitwise operations, multiplication, and finding the maximum of two numbers based on the opcode input. The ALU outputs the result alongside a `valid` flag indicating that the result is ready.

- **Testbench:**  
  The testbench applies a sequence of stimulus events (changing the values of `A`, `B`, and `opcode`) and displays the result and FSM state for each test case.

## License
This project is provided as-is for educational purposes.
