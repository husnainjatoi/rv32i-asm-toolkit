# RISC-V Instruction Encoding Worksheet
This worksheet details the manual translation of 6 standard RISC-V instructions (one of each core format: R, I, S, B, U, J) into 32-bit machine code.

---

## 1. R-Type: `add t0, t1, t2`
* **Format:** `funct7 | rs2 | rs1 | funct3 | rd | opcode`
* **Fields:**
  * **opcode:** `0110011` (Standard arithmetic)
  * **rd (t0):** `x5` $\rightarrow$ `00101`
  * **funct3:** `000` (ADD)
  * **rs1 (t1):** `x6` $\rightarrow$ `00110`
  * **rs2 (t2):** `x7` $\rightarrow$ `00111`
  * **funct7:** `0000000` (ADD)
* **Binary Concatenation:**
  `0000000` | `00111` | `00110` | `000` | `00101` | `0110011`
* **32-bit Binary:** `00000000111100110000001010110011`
* **Hexadecimal:** `0x007302B3`

---

## 2. I-Type: `addi a0, a0, 15`
* **Format:** `imm[11:0] | rs1 | funct3 | rd | opcode`
* **Fields:**
  * **opcode:** `0010011` (Immediate arithmetic)
  * **rd (a0):** `x10` $\rightarrow$ `01010`
  * **funct3:** `000` (ADD)
  * **rs1 (a0):** `x10` $\rightarrow$ `01010`
  * **imm:** `15` $\rightarrow$ `000000001111`
* **Binary Concatenation:**
  `000000001111` | `01010` | `000` | `01010` | `0010011`
* **32-bit Binary:** `00000000111101010000010100010011`
* **Hexadecimal:** **`0x00F50513`**

---

## 3. S-Type: `sw ra, 12(sp)`
* **Format:** `imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode`
* **Fields:**
  * **opcode:** `0100011` (Store)
  * **imm:** `12` $\rightarrow$ `000000001100` (imm[11:5] = `0000000`, imm[4:0] = `01100`)
  * **funct3:** `010` (Word)
  * **rs1 (sp):** `x2` $\rightarrow$ `00010` (Base Address)
  * **rs2 (ra):** `x1` $\rightarrow$ `00001` (Source Data)
* **Binary Concatenation:**
  `0000000` | `00001` | `00010` | `010` | `01100` | `0100011`
* **32-bit Binary:** `00000000000100010010011000100011`
* **Hexadecimal:** `0x00112623`

---

## 4. B-Type: `beq t3, t4, 8`
* **Format:** `imm[12] | imm[10:5] | rs2 | rs1 | funct3 | imm[4:1] | imm[11] | opcode`
* **Fields:**
  * **opcode:** `1100011` (Branch)
  * **imm:** `8` $\rightarrow$ `0 0000 0000 100 0` (13-bit representation)
    * imm[12] = `0`
    * imm[11] = `0`
    * imm[10:5] = `000000`
    * imm[4:1] = `0100`
  * **funct3:** `000` (BEQ)
  * **rs1 (t3):** `x28` $\rightarrow$ `11100`
  * **rs2 (t4):** `x29` $\rightarrow$ `11101`
* **Binary Concatenation:**
  `0` | `000000` | `11101` | `11100` | `000` | `0100` | `0` | `1100011`
* **32-bit Binary:** `00000001110111100000010001100011`
* **Hexadecimal:** `0x01DE0463`

---

## 5. U-Type: `lui s0, 0x12345`
* **Format:** `imm[31:12] | rd | opcode`
* **Fields:**
  * **opcode:** `0110111` (LUI)
  * **rd (s0):** `x8` $\rightarrow$ `01000`
  * **imm:** `0x12345` $\rightarrow$ `00010010001101000101` (20-bit value)
* **Binary Concatenation:**
  `00010010001101000101` | `01000` | `0110111`
* **32-bit Binary:** `00010010001101000101010000110111`
* **Hexadecimal:** `0x12345437`

---

## 6. J-Type: `jal ra, 16`
* **Format:** `imm[20] | imm[10:1] | imm[11] | imm[19:12] | rd | opcode`
* **Fields:**
  * **opcode:** `1101111` (JAL)
  * **rd (ra):** `x1` $\rightarrow$ `00001`
  * **imm:** `16` $\rightarrow$ `0 00000000 0 0000001000 0` (21-bit representation)
    * imm[20] = `0`
    * imm[19:12] = `00000000`
    * imm[11] = `0`
    * imm[10:1] = `0000001000`
* **Binary Concatenation:**
  `0` | `0000001000` | `0` | `00000000` | `00001` | `1101111`
* **32-bit Binary:** `00000001000000000000000011101111`
* **Hexadecimal:** `0x010000EF`