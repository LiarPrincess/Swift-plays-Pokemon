// Source: http://gameboy.mongenel.com/dmg/asmmemmap.html

//0000-00FF  Restart and Interrupt Vectors
//0100-014F  Cartridge Header Area
//  0100-0103  NOP / JP $0150
//  0104-0133  Nintendo Logo
//  0134-013E  Game Title (Uppercase ASCII)
//  013F-0142  4-byte Game Designation
//  0143  Color Compatibility byte
//  0144-0145  New Licensee Code
//  0146  SGB Compatibility byte
//  0147  Cart Type
//  0148  Cart ROM size
//  0149  Cart RAM size
//  014A  Destination code
//  014B  Old Licensee code
//  014C  Mask ROM version
//  014D  Complement checksum
//  014E-014F  Checksum

//0150-3FFF  Cartridge ROM - Bank 0 (fixed)
//4000-7FFF  Cartridge ROM - Switchable Banks 1-xx

// 8000-$97FF  Character RAM
//  8000-87FF: Tile set #1
//  8800-8FFF: Tile set #1 #2 - shared
//  9000-97FF: Tile set #2

//9800-9BFF  Tile map #0
//9C00-9FFF  Tile map #1

//A000-BFFF  Cartridge RAM (If Available)
//C000-CFFF  Internal RAM - Bank 0 (fixed)
//D000-DFFF  Internal RAM - Bank 1-7 (switchable - CGB only)
//E000-FDFF  Echo RAM - Reserved, Do Not Use
//FE00-FE9F  OAM - Object Attribute Memory
//FEA0-FEFF  Unusable Memory
//FF00-FF7F  Hardware I/O Registers
//FF80-FFFE  Zero Page - 127 bytes
//FFFF  Interrupt Enable Flag

struct MemoryRegion {

  /// What this region is used for
  let name: String

  /// Address of the first byte of the memory region
  let start: UInt16

  /// Address of the last byte of the memory region
  let end:   UInt16
}
