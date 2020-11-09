// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable trailing_newline

/// One of the standard 256 opcodes.
/// See official "Gameboy programming manual" for details.
/// (Because of performance this enum should be used only for debug.)
internal enum UnprefixedOpcode: UInt8, RawRepresentable {
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
