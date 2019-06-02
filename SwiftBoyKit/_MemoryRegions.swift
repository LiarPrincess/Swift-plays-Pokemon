// Source: http://bgb.bircd.org/pandocs.htm#memorymap
// and:    http://gameboy.mongenel.com/dmg/asmmemmap.html

private let bootromStart: UInt16 = 0x00
private let bootromEnd:   UInt16 = 0xff
private let bootromSize:  UInt16 = bootromEnd - bootromStart + 1

// 0000-3FFF   16KB ROM Bank 00     (in cartridge, fixed at bank 00)
//  0000-00FF  Restart and Interrupt Vectors
//  0100-014F  Cartridge Header Area
//   0100-0103  NOP / JP $0150
//   0104-0133  Nintendo Logo
//   0134-013E  Game Title (Uppercase ASCII)
//   013F-0142  4-byte Game Designation
//   0143  Color Compatibility byte
//   0144-0145  New Licensee Code
//   0146  SGB Compatibility byte
//   0147  Cart Type
//   0148  Cart ROM size
//   0149  Cart RAM size
//   014A  Destination code
//   014B  Old Licensee code
//   014C  Mask ROM version
//   014D  Complement checksum
//   014E-014F  Checksum
private let romBank0Start: UInt16 = 0x0000
private let romBank0End:   UInt16 = 0x3fff
private let romBank0Size:  UInt16 = romBank0End - romBank0Start + 1

// 4000-7FFF   16KB ROM Bank 01..NN (in cartridge, switchable bank number)
private let romBankNStart: UInt16 = 0x4000
private let romBankNEnd:   UInt16 = 0x7fff
private let romBankNSize:  UInt16 = romBankNEnd - romBankNStart + 1

// 8000-9FFF   8KB Video RAM (VRAM) (switchable bank 0-1 in CGB Mode)
//  8000-87FF: Tile set #1
//  8800-8FFF: Tile set #1 #2 - shared
//  9000-97FF: Tile set #2
private let vramStart: UInt16 = 0x8000
private let vramEnd:   UInt16 = 0x9fff
private let vramSize:  UInt16 = vramEnd - vramStart + 1

// A000-BFFF   8KB External RAM     (in cartridge, switchable bank, if any)
private let externalRamStart: UInt16 = 0xa000
private let externalRamEnd:   UInt16 = 0xbfff
private let externalRamSize:  UInt16 = externalRamEnd - externalRamStart + 1

// C000-CFFF   4KB Work RAM Bank 0 (WRAM)
// D000-DFFF   4KB Work RAM Bank 1 (WRAM)  (switchable bank 1-7 in CGB Mode)
private let workRamStart: UInt16 = 0xc000
private let workRamEnd:   UInt16 = 0xdfff
private let workRamSize:  UInt16 = workRamEnd - workRamStart + 1

// E000-FDFF   Same as C000-DDFF (ECHO)    (typically not used)
// not mapped

// FE00-FE9F   Sprite Attribute Table (OAM)
private let oamStart: UInt16 = 0xfe00
private let oamEnd:   UInt16 = 0xfe9f
private let oamSize:  UInt16 = oamEnd - oamStart + 1

// FEA0-FEFF   Not Usable
// Not mapped

// FF00-FF7F   I/O Ports
private let ioPortsStart: UInt16 = 0xff00
private let ioPortsEnd:   UInt16 = 0xff7f

// FF80-FFFE   High RAM (HRAM)
private let highRamStart: UInt16 = 0xff80
private let highRamEnd:   UInt16 = 0xfffe
private let highRamSize:  UInt16 = highRamEnd - highRamStart + 1

// FFFF        Interrupt Enable Register
private let interruptEnableRegister: UInt16 = 0xffff
