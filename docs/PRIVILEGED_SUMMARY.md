# RISC-V Privileged Architecture Summary

## 1. Privilege Levels
The RISC-V privileged architecture defines multiple privilege modes to control access to the hardware and isolate system-level execution. 
* **Machine-Mode (M-mode):** This is the highest privilege mode in a RISC-V system and the only mandatory privilege mode in any RISC-V hardware implementation. M-mode is used for low-level access to the hardware platform and is the first mode entered at power-on reset. 
* **Lower Privilege Modes:** Depending on the implementation, a RISC-V system may also support User (U), Supervisor (S), and Hypervisor (H) privilege modes. These modes execute environment calls instead of directly reading CPU registers to determine features, enabling virtualization and restricting hardware access.

## 2. Key Control and Status Registers (CSRs)
Machine-level operations rely on several critical Control and Status Registers (CSRs) to manage system states and trap handling.
* **`mstatus` (Machine Status Register):** Keeps track of and controls the hart's current operating state, including the current privilege mode (`PRV`) and interrupt-enable (`IE`) bits. It utilizes a privilege and interrupt-enable stack to support nested traps.
* **`mepc` (Machine Exception Program Counter):** When a trap is taken, this register is written with the virtual address of the instruction that encountered the exception.
* **`mcause` (Machine Cause Register):** Contains a specific exception code identifying the reason for the last exception or interrupt.
* **`mtvec` (Machine Trap Vector Base Address Register):** Holds the base address of the M-mode trap vector, which is where the Program Counter (PC) jumps when handling traps.
* **`mip` and `mie`:** These registers contain information on pending interrupts and their corresponding interrupt-enable bits, respectively.
* **`mtdeleg` (Machine Trap Delegation Register):** Allows specific traps to be delegated to and processed directly by a lower privilege level, increasing performance.

## 3. Trap Handling Flow
A trap transfers control to a privileged handler due to an exception or interrupt. The hardware-level flow operates as follows:
1. **State Preservation:** When a trap is taken, the hardware pushes the `mstatus` privilege stack to the left, setting the current privilege mode to the activated trap handler's mode and disabling interrupts by setting `IE=0`.
2. **Context Logging:** The virtual address of the instruction causing the trap is written to `mepc`. Simultaneously, the exception code is written to `mcause`.
3. **Jump to Handler:** The processor redirects execution to the trap handler address. A trap in privilege level P causes a jump to the address `mtvec + P x 0x40`. 
4. **Delegation (Optional):** If a trap is destined for a lower-privilege mode, M-mode handlers can quickly redirect the trap using instructions like `MRTS` (Machine Redirect Trap to Supervisor).
5. **Return from Trap:** To return from the handler, the `ERET` (Environment Return) instruction is executed. `ERET` pops the privilege stack in `mstatus` to restore the previous mode and interrupt-enable state, and it sets the PC back to the value stored in `mepc`.