func printSwitch() throws {
  print("switch instruction.opcode {")

  let opcodes = try openOpcodesFile()
  for op in opcodes.unprefixed {
    print("case .\(op.opcode):")
    print("  break")
  }

  print("default:")
  print("  print(\"Unknown instruction: \\(instruction)\")")
  print("}")
}
