// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable trailing_newline
// swiftlint:disable trailing_comma
// swiftlint:disable collection_alignment

/// See official "Gameboy programming manual" for details of each operation
public enum UnprefixedOpcodeValue: UInt8, RawRepresentable {
  case nop = 0x0
  case ld_bc_d16 = 0x1
  case ld_pBC_a = 0x2
  case inc_bc = 0x3
  case inc_b = 0x4
  case dec_b = 0x5
  case ld_b_d8 = 0x6
  case rlca = 0x7
  case ld_pA16_sp = 0x8
  case add_hl_bc = 0x9
  case ld_a_pBC = 0xa
  case dec_bc = 0xb
  case inc_c = 0xc
  case dec_c = 0xd
  case ld_c_d8 = 0xe
  case rrca = 0xf
  case stop = 0x10
  case ld_de_d16 = 0x11
  case ld_pDE_a = 0x12
  case inc_de = 0x13
  case inc_d = 0x14
  case dec_d = 0x15
  case ld_d_d8 = 0x16
  case rla = 0x17
  case jr_r8 = 0x18
  case add_hl_de = 0x19
  case ld_a_pDE = 0x1a
  case dec_de = 0x1b
  case inc_e = 0x1c
  case dec_e = 0x1d
  case ld_e_d8 = 0x1e
  case rra = 0x1f
  case jr_nz_r8 = 0x20
  case ld_hl_d16 = 0x21
  case ld_pHLI_a = 0x22
  case inc_hl = 0x23
  case inc_h = 0x24
  case dec_h = 0x25
  case ld_h_d8 = 0x26
  case daa = 0x27
  case jr_z_r8 = 0x28
  case add_hl_hl = 0x29
  case ld_a_pHLI = 0x2a
  case dec_hl = 0x2b
  case inc_l = 0x2c
  case dec_l = 0x2d
  case ld_l_d8 = 0x2e
  case cpl = 0x2f
  case jr_nc_r8 = 0x30
  case ld_sp_d16 = 0x31
  case ld_pHLD_a = 0x32
  case inc_sp = 0x33
  case inc_pHL = 0x34
  case dec_pHL = 0x35
  case ld_pHL_d8 = 0x36
  case scf = 0x37
  case jr_c_r8 = 0x38
  case add_hl_sp = 0x39
  case ld_a_pHLD = 0x3a
  case dec_sp = 0x3b
  case inc_a = 0x3c
  case dec_a = 0x3d
  case ld_a_d8 = 0x3e
  case ccf = 0x3f
  case ld_b_b = 0x40
  case ld_b_c = 0x41
  case ld_b_d = 0x42
  case ld_b_e = 0x43
  case ld_b_h = 0x44
  case ld_b_l = 0x45
  case ld_b_pHL = 0x46
  case ld_b_a = 0x47
  case ld_c_b = 0x48
  case ld_c_c = 0x49
  case ld_c_d = 0x4a
  case ld_c_e = 0x4b
  case ld_c_h = 0x4c
  case ld_c_l = 0x4d
  case ld_c_pHL = 0x4e
  case ld_c_a = 0x4f
  case ld_d_b = 0x50
  case ld_d_c = 0x51
  case ld_d_d = 0x52
  case ld_d_e = 0x53
  case ld_d_h = 0x54
  case ld_d_l = 0x55
  case ld_d_pHL = 0x56
  case ld_d_a = 0x57
  case ld_e_b = 0x58
  case ld_e_c = 0x59
  case ld_e_d = 0x5a
  case ld_e_e = 0x5b
  case ld_e_h = 0x5c
  case ld_e_l = 0x5d
  case ld_e_pHL = 0x5e
  case ld_e_a = 0x5f
  case ld_h_b = 0x60
  case ld_h_c = 0x61
  case ld_h_d = 0x62
  case ld_h_e = 0x63
  case ld_h_h = 0x64
  case ld_h_l = 0x65
  case ld_h_pHL = 0x66
  case ld_h_a = 0x67
  case ld_l_b = 0x68
  case ld_l_c = 0x69
  case ld_l_d = 0x6a
  case ld_l_e = 0x6b
  case ld_l_h = 0x6c
  case ld_l_l = 0x6d
  case ld_l_pHL = 0x6e
  case ld_l_a = 0x6f
  case ld_pHL_b = 0x70
  case ld_pHL_c = 0x71
  case ld_pHL_d = 0x72
  case ld_pHL_e = 0x73
  case ld_pHL_h = 0x74
  case ld_pHL_l = 0x75
  case halt = 0x76
  case ld_pHL_a = 0x77
  case ld_a_b = 0x78
  case ld_a_c = 0x79
  case ld_a_d = 0x7a
  case ld_a_e = 0x7b
  case ld_a_h = 0x7c
  case ld_a_l = 0x7d
  case ld_a_pHL = 0x7e
  case ld_a_a = 0x7f
  case add_a_b = 0x80
  case add_a_c = 0x81
  case add_a_d = 0x82
  case add_a_e = 0x83
  case add_a_h = 0x84
  case add_a_l = 0x85
  case add_a_pHL = 0x86
  case add_a_a = 0x87
  case adc_a_b = 0x88
  case adc_a_c = 0x89
  case adc_a_d = 0x8a
  case adc_a_e = 0x8b
  case adc_a_h = 0x8c
  case adc_a_l = 0x8d
  case adc_a_pHL = 0x8e
  case adc_a_a = 0x8f
  case sub_b = 0x90
  case sub_c = 0x91
  case sub_d = 0x92
  case sub_e = 0x93
  case sub_h = 0x94
  case sub_l = 0x95
  case sub_pHL = 0x96
  case sub_a = 0x97
  case sbc_a_b = 0x98
  case sbc_a_c = 0x99
  case sbc_a_d = 0x9a
  case sbc_a_e = 0x9b
  case sbc_a_h = 0x9c
  case sbc_a_l = 0x9d
  case sbc_a_pHL = 0x9e
  case sbc_a_a = 0x9f
  case and_b = 0xa0
  case and_c = 0xa1
  case and_d = 0xa2
  case and_e = 0xa3
  case and_h = 0xa4
  case and_l = 0xa5
  case and_pHL = 0xa6
  case and_a = 0xa7
  case xor_b = 0xa8
  case xor_c = 0xa9
  case xor_d = 0xaa
  case xor_e = 0xab
  case xor_h = 0xac
  case xor_l = 0xad
  case xor_pHL = 0xae
  case xor_a = 0xaf
  case or_b = 0xb0
  case or_c = 0xb1
  case or_d = 0xb2
  case or_e = 0xb3
  case or_h = 0xb4
  case or_l = 0xb5
  case or_pHL = 0xb6
  case or_a = 0xb7
  case cp_b = 0xb8
  case cp_c = 0xb9
  case cp_d = 0xba
  case cp_e = 0xbb
  case cp_h = 0xbc
  case cp_l = 0xbd
  case cp_pHL = 0xbe
  case cp_a = 0xbf
  case ret_nz = 0xc0
  case pop_bc = 0xc1
  case jp_nz_a16 = 0xc2
  case jp_a16 = 0xc3
  case call_nz_a16 = 0xc4
  case push_bc = 0xc5
  case add_a_d8 = 0xc6
  case rst_00 = 0xc7
  case ret_z = 0xc8
  case ret = 0xc9
  case jp_z_a16 = 0xca
  case prefix = 0xcb
  case call_z_a16 = 0xcc
  case call_a16 = 0xcd
  case adc_a_d8 = 0xce
  case rst_08 = 0xcf
  case ret_nc = 0xd0
  case pop_de = 0xd1
  case jp_nc_a16 = 0xd2
  /* 0xd3 - this opcode does not exists */
  case call_nc_a16 = 0xd4
  case push_de = 0xd5
  case sub_d8 = 0xd6
  case rst_10 = 0xd7
  case ret_c = 0xd8
  case reti = 0xd9
  case jp_c_a16 = 0xda
  /* 0xdb - this opcode does not exists */
  case call_c_a16 = 0xdc
  /* 0xdd - this opcode does not exists */
  case sbc_a_d8 = 0xde
  case rst_18 = 0xdf
  case ldh_pA8_a = 0xe0
  case pop_hl = 0xe1
  case ld_pC_a = 0xe2
  /* 0xe3 - this opcode does not exists */
  /* 0xe4 - this opcode does not exists */
  case push_hl = 0xe5
  case and_d8 = 0xe6
  case rst_20 = 0xe7
  case add_sp_r8 = 0xe8
  case jp_pHL = 0xe9
  case ld_pA16_a = 0xea
  /* 0xeb - this opcode does not exists */
  /* 0xec - this opcode does not exists */
  /* 0xed - this opcode does not exists */
  case xor_d8 = 0xee
  case rst_28 = 0xef
  case ldh_a_pA8 = 0xf0
  case pop_af = 0xf1
  case ld_a_pC = 0xf2
  case di = 0xf3
  /* 0xf4 - this opcode does not exists */
  case push_af = 0xf5
  case or_d8 = 0xf6
  case rst_30 = 0xf7
  case ld_hl_spR8 = 0xf8
  case ld_sp_hl = 0xf9
  case ld_a_pA16 = 0xfa
  case ei = 0xfb
  /* 0xfc - this opcode does not exists */
  /* 0xfd - this opcode does not exists */
  case cp_d8 = 0xfe
  case rst_38 = 0xff
}

public let unprefixedOpcodes: [UnprefixedOpcode?] = [
/* 0x0 */ UnprefixedOpcode(value: .nop,          length: 1, cycles: [4]),
/* 0x1 */ UnprefixedOpcode(value: .ld_bc_d16,    length: 3, cycles: [12]),
/* 0x2 */ UnprefixedOpcode(value: .ld_pBC_a,     length: 1, cycles: [8]),
/* 0x3 */ UnprefixedOpcode(value: .inc_bc,       length: 1, cycles: [8]),
/* 0x4 */ UnprefixedOpcode(value: .inc_b,        length: 1, cycles: [4]),
/* 0x5 */ UnprefixedOpcode(value: .dec_b,        length: 1, cycles: [4]),
/* 0x6 */ UnprefixedOpcode(value: .ld_b_d8,      length: 2, cycles: [8]),
/* 0x7 */ UnprefixedOpcode(value: .rlca,         length: 1, cycles: [4]),
/* 0x8 */ UnprefixedOpcode(value: .ld_pA16_sp,   length: 3, cycles: [20]),
/* 0x9 */ UnprefixedOpcode(value: .add_hl_bc,    length: 1, cycles: [8]),
/* 0xa */ UnprefixedOpcode(value: .ld_a_pBC,     length: 1, cycles: [8]),
/* 0xb */ UnprefixedOpcode(value: .dec_bc,       length: 1, cycles: [8]),
/* 0xc */ UnprefixedOpcode(value: .inc_c,        length: 1, cycles: [4]),
/* 0xd */ UnprefixedOpcode(value: .dec_c,        length: 1, cycles: [4]),
/* 0xe */ UnprefixedOpcode(value: .ld_c_d8,      length: 2, cycles: [8]),
/* 0xf */ UnprefixedOpcode(value: .rrca,         length: 1, cycles: [4]),
/* 0x10 */ UnprefixedOpcode(value: .stop,         length: 1, cycles: [4]),
/* 0x11 */ UnprefixedOpcode(value: .ld_de_d16,    length: 3, cycles: [12]),
/* 0x12 */ UnprefixedOpcode(value: .ld_pDE_a,     length: 1, cycles: [8]),
/* 0x13 */ UnprefixedOpcode(value: .inc_de,       length: 1, cycles: [8]),
/* 0x14 */ UnprefixedOpcode(value: .inc_d,        length: 1, cycles: [4]),
/* 0x15 */ UnprefixedOpcode(value: .dec_d,        length: 1, cycles: [4]),
/* 0x16 */ UnprefixedOpcode(value: .ld_d_d8,      length: 2, cycles: [8]),
/* 0x17 */ UnprefixedOpcode(value: .rla,          length: 1, cycles: [4]),
/* 0x18 */ UnprefixedOpcode(value: .jr_r8,        length: 2, cycles: [12]),
/* 0x19 */ UnprefixedOpcode(value: .add_hl_de,    length: 1, cycles: [8]),
/* 0x1a */ UnprefixedOpcode(value: .ld_a_pDE,     length: 1, cycles: [8]),
/* 0x1b */ UnprefixedOpcode(value: .dec_de,       length: 1, cycles: [8]),
/* 0x1c */ UnprefixedOpcode(value: .inc_e,        length: 1, cycles: [4]),
/* 0x1d */ UnprefixedOpcode(value: .dec_e,        length: 1, cycles: [4]),
/* 0x1e */ UnprefixedOpcode(value: .ld_e_d8,      length: 2, cycles: [8]),
/* 0x1f */ UnprefixedOpcode(value: .rra,          length: 1, cycles: [4]),
/* 0x20 */ UnprefixedOpcode(value: .jr_nz_r8,     length: 2, cycles: [12, 8]),
/* 0x21 */ UnprefixedOpcode(value: .ld_hl_d16,    length: 3, cycles: [12]),
/* 0x22 */ UnprefixedOpcode(value: .ld_pHLI_a,    length: 1, cycles: [8]),
/* 0x23 */ UnprefixedOpcode(value: .inc_hl,       length: 1, cycles: [8]),
/* 0x24 */ UnprefixedOpcode(value: .inc_h,        length: 1, cycles: [4]),
/* 0x25 */ UnprefixedOpcode(value: .dec_h,        length: 1, cycles: [4]),
/* 0x26 */ UnprefixedOpcode(value: .ld_h_d8,      length: 2, cycles: [8]),
/* 0x27 */ UnprefixedOpcode(value: .daa,          length: 1, cycles: [4]),
/* 0x28 */ UnprefixedOpcode(value: .jr_z_r8,      length: 2, cycles: [12, 8]),
/* 0x29 */ UnprefixedOpcode(value: .add_hl_hl,    length: 1, cycles: [8]),
/* 0x2a */ UnprefixedOpcode(value: .ld_a_pHLI,    length: 1, cycles: [8]),
/* 0x2b */ UnprefixedOpcode(value: .dec_hl,       length: 1, cycles: [8]),
/* 0x2c */ UnprefixedOpcode(value: .inc_l,        length: 1, cycles: [4]),
/* 0x2d */ UnprefixedOpcode(value: .dec_l,        length: 1, cycles: [4]),
/* 0x2e */ UnprefixedOpcode(value: .ld_l_d8,      length: 2, cycles: [8]),
/* 0x2f */ UnprefixedOpcode(value: .cpl,          length: 1, cycles: [4]),
/* 0x30 */ UnprefixedOpcode(value: .jr_nc_r8,     length: 2, cycles: [12, 8]),
/* 0x31 */ UnprefixedOpcode(value: .ld_sp_d16,    length: 3, cycles: [12]),
/* 0x32 */ UnprefixedOpcode(value: .ld_pHLD_a,    length: 1, cycles: [8]),
/* 0x33 */ UnprefixedOpcode(value: .inc_sp,       length: 1, cycles: [8]),
/* 0x34 */ UnprefixedOpcode(value: .inc_pHL,      length: 1, cycles: [12]),
/* 0x35 */ UnprefixedOpcode(value: .dec_pHL,      length: 1, cycles: [12]),
/* 0x36 */ UnprefixedOpcode(value: .ld_pHL_d8,    length: 2, cycles: [12]),
/* 0x37 */ UnprefixedOpcode(value: .scf,          length: 1, cycles: [4]),
/* 0x38 */ UnprefixedOpcode(value: .jr_c_r8,      length: 2, cycles: [12, 8]),
/* 0x39 */ UnprefixedOpcode(value: .add_hl_sp,    length: 1, cycles: [8]),
/* 0x3a */ UnprefixedOpcode(value: .ld_a_pHLD,    length: 1, cycles: [8]),
/* 0x3b */ UnprefixedOpcode(value: .dec_sp,       length: 1, cycles: [8]),
/* 0x3c */ UnprefixedOpcode(value: .inc_a,        length: 1, cycles: [4]),
/* 0x3d */ UnprefixedOpcode(value: .dec_a,        length: 1, cycles: [4]),
/* 0x3e */ UnprefixedOpcode(value: .ld_a_d8,      length: 2, cycles: [8]),
/* 0x3f */ UnprefixedOpcode(value: .ccf,          length: 1, cycles: [4]),
/* 0x40 */ UnprefixedOpcode(value: .ld_b_b,       length: 1, cycles: [4]),
/* 0x41 */ UnprefixedOpcode(value: .ld_b_c,       length: 1, cycles: [4]),
/* 0x42 */ UnprefixedOpcode(value: .ld_b_d,       length: 1, cycles: [4]),
/* 0x43 */ UnprefixedOpcode(value: .ld_b_e,       length: 1, cycles: [4]),
/* 0x44 */ UnprefixedOpcode(value: .ld_b_h,       length: 1, cycles: [4]),
/* 0x45 */ UnprefixedOpcode(value: .ld_b_l,       length: 1, cycles: [4]),
/* 0x46 */ UnprefixedOpcode(value: .ld_b_pHL,     length: 1, cycles: [8]),
/* 0x47 */ UnprefixedOpcode(value: .ld_b_a,       length: 1, cycles: [4]),
/* 0x48 */ UnprefixedOpcode(value: .ld_c_b,       length: 1, cycles: [4]),
/* 0x49 */ UnprefixedOpcode(value: .ld_c_c,       length: 1, cycles: [4]),
/* 0x4a */ UnprefixedOpcode(value: .ld_c_d,       length: 1, cycles: [4]),
/* 0x4b */ UnprefixedOpcode(value: .ld_c_e,       length: 1, cycles: [4]),
/* 0x4c */ UnprefixedOpcode(value: .ld_c_h,       length: 1, cycles: [4]),
/* 0x4d */ UnprefixedOpcode(value: .ld_c_l,       length: 1, cycles: [4]),
/* 0x4e */ UnprefixedOpcode(value: .ld_c_pHL,     length: 1, cycles: [8]),
/* 0x4f */ UnprefixedOpcode(value: .ld_c_a,       length: 1, cycles: [4]),
/* 0x50 */ UnprefixedOpcode(value: .ld_d_b,       length: 1, cycles: [4]),
/* 0x51 */ UnprefixedOpcode(value: .ld_d_c,       length: 1, cycles: [4]),
/* 0x52 */ UnprefixedOpcode(value: .ld_d_d,       length: 1, cycles: [4]),
/* 0x53 */ UnprefixedOpcode(value: .ld_d_e,       length: 1, cycles: [4]),
/* 0x54 */ UnprefixedOpcode(value: .ld_d_h,       length: 1, cycles: [4]),
/* 0x55 */ UnprefixedOpcode(value: .ld_d_l,       length: 1, cycles: [4]),
/* 0x56 */ UnprefixedOpcode(value: .ld_d_pHL,     length: 1, cycles: [8]),
/* 0x57 */ UnprefixedOpcode(value: .ld_d_a,       length: 1, cycles: [4]),
/* 0x58 */ UnprefixedOpcode(value: .ld_e_b,       length: 1, cycles: [4]),
/* 0x59 */ UnprefixedOpcode(value: .ld_e_c,       length: 1, cycles: [4]),
/* 0x5a */ UnprefixedOpcode(value: .ld_e_d,       length: 1, cycles: [4]),
/* 0x5b */ UnprefixedOpcode(value: .ld_e_e,       length: 1, cycles: [4]),
/* 0x5c */ UnprefixedOpcode(value: .ld_e_h,       length: 1, cycles: [4]),
/* 0x5d */ UnprefixedOpcode(value: .ld_e_l,       length: 1, cycles: [4]),
/* 0x5e */ UnprefixedOpcode(value: .ld_e_pHL,     length: 1, cycles: [8]),
/* 0x5f */ UnprefixedOpcode(value: .ld_e_a,       length: 1, cycles: [4]),
/* 0x60 */ UnprefixedOpcode(value: .ld_h_b,       length: 1, cycles: [4]),
/* 0x61 */ UnprefixedOpcode(value: .ld_h_c,       length: 1, cycles: [4]),
/* 0x62 */ UnprefixedOpcode(value: .ld_h_d,       length: 1, cycles: [4]),
/* 0x63 */ UnprefixedOpcode(value: .ld_h_e,       length: 1, cycles: [4]),
/* 0x64 */ UnprefixedOpcode(value: .ld_h_h,       length: 1, cycles: [4]),
/* 0x65 */ UnprefixedOpcode(value: .ld_h_l,       length: 1, cycles: [4]),
/* 0x66 */ UnprefixedOpcode(value: .ld_h_pHL,     length: 1, cycles: [8]),
/* 0x67 */ UnprefixedOpcode(value: .ld_h_a,       length: 1, cycles: [4]),
/* 0x68 */ UnprefixedOpcode(value: .ld_l_b,       length: 1, cycles: [4]),
/* 0x69 */ UnprefixedOpcode(value: .ld_l_c,       length: 1, cycles: [4]),
/* 0x6a */ UnprefixedOpcode(value: .ld_l_d,       length: 1, cycles: [4]),
/* 0x6b */ UnprefixedOpcode(value: .ld_l_e,       length: 1, cycles: [4]),
/* 0x6c */ UnprefixedOpcode(value: .ld_l_h,       length: 1, cycles: [4]),
/* 0x6d */ UnprefixedOpcode(value: .ld_l_l,       length: 1, cycles: [4]),
/* 0x6e */ UnprefixedOpcode(value: .ld_l_pHL,     length: 1, cycles: [8]),
/* 0x6f */ UnprefixedOpcode(value: .ld_l_a,       length: 1, cycles: [4]),
/* 0x70 */ UnprefixedOpcode(value: .ld_pHL_b,     length: 1, cycles: [8]),
/* 0x71 */ UnprefixedOpcode(value: .ld_pHL_c,     length: 1, cycles: [8]),
/* 0x72 */ UnprefixedOpcode(value: .ld_pHL_d,     length: 1, cycles: [8]),
/* 0x73 */ UnprefixedOpcode(value: .ld_pHL_e,     length: 1, cycles: [8]),
/* 0x74 */ UnprefixedOpcode(value: .ld_pHL_h,     length: 1, cycles: [8]),
/* 0x75 */ UnprefixedOpcode(value: .ld_pHL_l,     length: 1, cycles: [8]),
/* 0x76 */ UnprefixedOpcode(value: .halt,         length: 1, cycles: [4]),
/* 0x77 */ UnprefixedOpcode(value: .ld_pHL_a,     length: 1, cycles: [8]),
/* 0x78 */ UnprefixedOpcode(value: .ld_a_b,       length: 1, cycles: [4]),
/* 0x79 */ UnprefixedOpcode(value: .ld_a_c,       length: 1, cycles: [4]),
/* 0x7a */ UnprefixedOpcode(value: .ld_a_d,       length: 1, cycles: [4]),
/* 0x7b */ UnprefixedOpcode(value: .ld_a_e,       length: 1, cycles: [4]),
/* 0x7c */ UnprefixedOpcode(value: .ld_a_h,       length: 1, cycles: [4]),
/* 0x7d */ UnprefixedOpcode(value: .ld_a_l,       length: 1, cycles: [4]),
/* 0x7e */ UnprefixedOpcode(value: .ld_a_pHL,     length: 1, cycles: [8]),
/* 0x7f */ UnprefixedOpcode(value: .ld_a_a,       length: 1, cycles: [4]),
/* 0x80 */ UnprefixedOpcode(value: .add_a_b,      length: 1, cycles: [4]),
/* 0x81 */ UnprefixedOpcode(value: .add_a_c,      length: 1, cycles: [4]),
/* 0x82 */ UnprefixedOpcode(value: .add_a_d,      length: 1, cycles: [4]),
/* 0x83 */ UnprefixedOpcode(value: .add_a_e,      length: 1, cycles: [4]),
/* 0x84 */ UnprefixedOpcode(value: .add_a_h,      length: 1, cycles: [4]),
/* 0x85 */ UnprefixedOpcode(value: .add_a_l,      length: 1, cycles: [4]),
/* 0x86 */ UnprefixedOpcode(value: .add_a_pHL,    length: 1, cycles: [8]),
/* 0x87 */ UnprefixedOpcode(value: .add_a_a,      length: 1, cycles: [4]),
/* 0x88 */ UnprefixedOpcode(value: .adc_a_b,      length: 1, cycles: [4]),
/* 0x89 */ UnprefixedOpcode(value: .adc_a_c,      length: 1, cycles: [4]),
/* 0x8a */ UnprefixedOpcode(value: .adc_a_d,      length: 1, cycles: [4]),
/* 0x8b */ UnprefixedOpcode(value: .adc_a_e,      length: 1, cycles: [4]),
/* 0x8c */ UnprefixedOpcode(value: .adc_a_h,      length: 1, cycles: [4]),
/* 0x8d */ UnprefixedOpcode(value: .adc_a_l,      length: 1, cycles: [4]),
/* 0x8e */ UnprefixedOpcode(value: .adc_a_pHL,    length: 1, cycles: [8]),
/* 0x8f */ UnprefixedOpcode(value: .adc_a_a,      length: 1, cycles: [4]),
/* 0x90 */ UnprefixedOpcode(value: .sub_b,        length: 1, cycles: [4]),
/* 0x91 */ UnprefixedOpcode(value: .sub_c,        length: 1, cycles: [4]),
/* 0x92 */ UnprefixedOpcode(value: .sub_d,        length: 1, cycles: [4]),
/* 0x93 */ UnprefixedOpcode(value: .sub_e,        length: 1, cycles: [4]),
/* 0x94 */ UnprefixedOpcode(value: .sub_h,        length: 1, cycles: [4]),
/* 0x95 */ UnprefixedOpcode(value: .sub_l,        length: 1, cycles: [4]),
/* 0x96 */ UnprefixedOpcode(value: .sub_pHL,      length: 1, cycles: [8]),
/* 0x97 */ UnprefixedOpcode(value: .sub_a,        length: 1, cycles: [4]),
/* 0x98 */ UnprefixedOpcode(value: .sbc_a_b,      length: 1, cycles: [4]),
/* 0x99 */ UnprefixedOpcode(value: .sbc_a_c,      length: 1, cycles: [4]),
/* 0x9a */ UnprefixedOpcode(value: .sbc_a_d,      length: 1, cycles: [4]),
/* 0x9b */ UnprefixedOpcode(value: .sbc_a_e,      length: 1, cycles: [4]),
/* 0x9c */ UnprefixedOpcode(value: .sbc_a_h,      length: 1, cycles: [4]),
/* 0x9d */ UnprefixedOpcode(value: .sbc_a_l,      length: 1, cycles: [4]),
/* 0x9e */ UnprefixedOpcode(value: .sbc_a_pHL,    length: 1, cycles: [8]),
/* 0x9f */ UnprefixedOpcode(value: .sbc_a_a,      length: 1, cycles: [4]),
/* 0xa0 */ UnprefixedOpcode(value: .and_b,        length: 1, cycles: [4]),
/* 0xa1 */ UnprefixedOpcode(value: .and_c,        length: 1, cycles: [4]),
/* 0xa2 */ UnprefixedOpcode(value: .and_d,        length: 1, cycles: [4]),
/* 0xa3 */ UnprefixedOpcode(value: .and_e,        length: 1, cycles: [4]),
/* 0xa4 */ UnprefixedOpcode(value: .and_h,        length: 1, cycles: [4]),
/* 0xa5 */ UnprefixedOpcode(value: .and_l,        length: 1, cycles: [4]),
/* 0xa6 */ UnprefixedOpcode(value: .and_pHL,      length: 1, cycles: [8]),
/* 0xa7 */ UnprefixedOpcode(value: .and_a,        length: 1, cycles: [4]),
/* 0xa8 */ UnprefixedOpcode(value: .xor_b,        length: 1, cycles: [4]),
/* 0xa9 */ UnprefixedOpcode(value: .xor_c,        length: 1, cycles: [4]),
/* 0xaa */ UnprefixedOpcode(value: .xor_d,        length: 1, cycles: [4]),
/* 0xab */ UnprefixedOpcode(value: .xor_e,        length: 1, cycles: [4]),
/* 0xac */ UnprefixedOpcode(value: .xor_h,        length: 1, cycles: [4]),
/* 0xad */ UnprefixedOpcode(value: .xor_l,        length: 1, cycles: [4]),
/* 0xae */ UnprefixedOpcode(value: .xor_pHL,      length: 1, cycles: [8]),
/* 0xaf */ UnprefixedOpcode(value: .xor_a,        length: 1, cycles: [4]),
/* 0xb0 */ UnprefixedOpcode(value: .or_b,         length: 1, cycles: [4]),
/* 0xb1 */ UnprefixedOpcode(value: .or_c,         length: 1, cycles: [4]),
/* 0xb2 */ UnprefixedOpcode(value: .or_d,         length: 1, cycles: [4]),
/* 0xb3 */ UnprefixedOpcode(value: .or_e,         length: 1, cycles: [4]),
/* 0xb4 */ UnprefixedOpcode(value: .or_h,         length: 1, cycles: [4]),
/* 0xb5 */ UnprefixedOpcode(value: .or_l,         length: 1, cycles: [4]),
/* 0xb6 */ UnprefixedOpcode(value: .or_pHL,       length: 1, cycles: [8]),
/* 0xb7 */ UnprefixedOpcode(value: .or_a,         length: 1, cycles: [4]),
/* 0xb8 */ UnprefixedOpcode(value: .cp_b,         length: 1, cycles: [4]),
/* 0xb9 */ UnprefixedOpcode(value: .cp_c,         length: 1, cycles: [4]),
/* 0xba */ UnprefixedOpcode(value: .cp_d,         length: 1, cycles: [4]),
/* 0xbb */ UnprefixedOpcode(value: .cp_e,         length: 1, cycles: [4]),
/* 0xbc */ UnprefixedOpcode(value: .cp_h,         length: 1, cycles: [4]),
/* 0xbd */ UnprefixedOpcode(value: .cp_l,         length: 1, cycles: [4]),
/* 0xbe */ UnprefixedOpcode(value: .cp_pHL,       length: 1, cycles: [8]),
/* 0xbf */ UnprefixedOpcode(value: .cp_a,         length: 1, cycles: [4]),
/* 0xc0 */ UnprefixedOpcode(value: .ret_nz,       length: 1, cycles: [20, 8]),
/* 0xc1 */ UnprefixedOpcode(value: .pop_bc,       length: 1, cycles: [12]),
/* 0xc2 */ UnprefixedOpcode(value: .jp_nz_a16,    length: 3, cycles: [16, 12]),
/* 0xc3 */ UnprefixedOpcode(value: .jp_a16,       length: 3, cycles: [16]),
/* 0xc4 */ UnprefixedOpcode(value: .call_nz_a16,  length: 3, cycles: [24, 12]),
/* 0xc5 */ UnprefixedOpcode(value: .push_bc,      length: 1, cycles: [16]),
/* 0xc6 */ UnprefixedOpcode(value: .add_a_d8,     length: 2, cycles: [8]),
/* 0xc7 */ UnprefixedOpcode(value: .rst_00,       length: 1, cycles: [16]),
/* 0xc8 */ UnprefixedOpcode(value: .ret_z,        length: 1, cycles: [20, 8]),
/* 0xc9 */ UnprefixedOpcode(value: .ret,          length: 1, cycles: [16]),
/* 0xca */ UnprefixedOpcode(value: .jp_z_a16,     length: 3, cycles: [16, 12]),
/* 0xcb */ UnprefixedOpcode(value: .prefix,       length: 1, cycles: [4]),
/* 0xcc */ UnprefixedOpcode(value: .call_z_a16,   length: 3, cycles: [24, 12]),
/* 0xcd */ UnprefixedOpcode(value: .call_a16,     length: 3, cycles: [24]),
/* 0xce */ UnprefixedOpcode(value: .adc_a_d8,     length: 2, cycles: [8]),
/* 0xcf */ UnprefixedOpcode(value: .rst_08,       length: 1, cycles: [16]),
/* 0xd0 */ UnprefixedOpcode(value: .ret_nc,       length: 1, cycles: [20, 8]),
/* 0xd1 */ UnprefixedOpcode(value: .pop_de,       length: 1, cycles: [12]),
/* 0xd2 */ UnprefixedOpcode(value: .jp_nc_a16,    length: 3, cycles: [16, 12]),
/* 0xd3 */ nil, /* this opcode does not exists */
/* 0xd4 */ UnprefixedOpcode(value: .call_nc_a16,  length: 3, cycles: [24, 12]),
/* 0xd5 */ UnprefixedOpcode(value: .push_de,      length: 1, cycles: [16]),
/* 0xd6 */ UnprefixedOpcode(value: .sub_d8,       length: 2, cycles: [8]),
/* 0xd7 */ UnprefixedOpcode(value: .rst_10,       length: 1, cycles: [16]),
/* 0xd8 */ UnprefixedOpcode(value: .ret_c,        length: 1, cycles: [20, 8]),
/* 0xd9 */ UnprefixedOpcode(value: .reti,         length: 1, cycles: [16]),
/* 0xda */ UnprefixedOpcode(value: .jp_c_a16,     length: 3, cycles: [16, 12]),
/* 0xdb */ nil, /* this opcode does not exists */
/* 0xdc */ UnprefixedOpcode(value: .call_c_a16,   length: 3, cycles: [24, 12]),
/* 0xdd */ nil, /* this opcode does not exists */
/* 0xde */ UnprefixedOpcode(value: .sbc_a_d8,     length: 2, cycles: [8]),
/* 0xdf */ UnprefixedOpcode(value: .rst_18,       length: 1, cycles: [16]),
/* 0xe0 */ UnprefixedOpcode(value: .ldh_pA8_a,    length: 2, cycles: [12]),
/* 0xe1 */ UnprefixedOpcode(value: .pop_hl,       length: 1, cycles: [12]),
/* 0xe2 */ UnprefixedOpcode(value: .ld_pC_a,      length: 1, cycles: [8]),
/* 0xe3 */ nil, /* this opcode does not exists */
/* 0xe4 */ nil, /* this opcode does not exists */
/* 0xe5 */ UnprefixedOpcode(value: .push_hl,      length: 1, cycles: [16]),
/* 0xe6 */ UnprefixedOpcode(value: .and_d8,       length: 2, cycles: [8]),
/* 0xe7 */ UnprefixedOpcode(value: .rst_20,       length: 1, cycles: [16]),
/* 0xe8 */ UnprefixedOpcode(value: .add_sp_r8,    length: 2, cycles: [16]),
/* 0xe9 */ UnprefixedOpcode(value: .jp_pHL,       length: 1, cycles: [4]),
/* 0xea */ UnprefixedOpcode(value: .ld_pA16_a,    length: 3, cycles: [16]),
/* 0xeb */ nil, /* this opcode does not exists */
/* 0xec */ nil, /* this opcode does not exists */
/* 0xed */ nil, /* this opcode does not exists */
/* 0xee */ UnprefixedOpcode(value: .xor_d8,       length: 2, cycles: [8]),
/* 0xef */ UnprefixedOpcode(value: .rst_28,       length: 1, cycles: [16]),
/* 0xf0 */ UnprefixedOpcode(value: .ldh_a_pA8,    length: 2, cycles: [12]),
/* 0xf1 */ UnprefixedOpcode(value: .pop_af,       length: 1, cycles: [12]),
/* 0xf2 */ UnprefixedOpcode(value: .ld_a_pC,      length: 1, cycles: [8]),
/* 0xf3 */ UnprefixedOpcode(value: .di,           length: 1, cycles: [4]),
/* 0xf4 */ nil, /* this opcode does not exists */
/* 0xf5 */ UnprefixedOpcode(value: .push_af,      length: 1, cycles: [16]),
/* 0xf6 */ UnprefixedOpcode(value: .or_d8,        length: 2, cycles: [8]),
/* 0xf7 */ UnprefixedOpcode(value: .rst_30,       length: 1, cycles: [16]),
/* 0xf8 */ UnprefixedOpcode(value: .ld_hl_spR8,   length: 2, cycles: [12]),
/* 0xf9 */ UnprefixedOpcode(value: .ld_sp_hl,     length: 1, cycles: [8]),
/* 0xfa */ UnprefixedOpcode(value: .ld_a_pA16,    length: 3, cycles: [16]),
/* 0xfb */ UnprefixedOpcode(value: .ei,           length: 1, cycles: [4]),
/* 0xfc */ nil, /* this opcode does not exists */
/* 0xfd */ nil, /* this opcode does not exists */
/* 0xfe */ UnprefixedOpcode(value: .cp_d8,        length: 2, cycles: [8]),
/* 0xff */ UnprefixedOpcode(value: .rst_38,       length: 1, cycles: [16]),
]

