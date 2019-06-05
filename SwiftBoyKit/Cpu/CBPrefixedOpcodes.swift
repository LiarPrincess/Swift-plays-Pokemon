// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable trailing_newline

/// One of additional 256 opcodes that should be executed if standard opcode is 0xCB.
/// See official "Gameboy programming manual" for details of each operation.
public enum CBPrefixedOpcode: UInt8, RawRepresentable {
  case rlc_b = 0x0
  case rlc_c = 0x1
  case rlc_d = 0x2
  case rlc_e = 0x3
  case rlc_h = 0x4
  case rlc_l = 0x5
  case rlc_pHL = 0x6
  case rlc_a = 0x7
  case rrc_b = 0x8
  case rrc_c = 0x9
  case rrc_d = 0xa
  case rrc_e = 0xb
  case rrc_h = 0xc
  case rrc_l = 0xd
  case rrc_pHL = 0xe
  case rrc_a = 0xf
  case rl_b = 0x10
  case rl_c = 0x11
  case rl_d = 0x12
  case rl_e = 0x13
  case rl_h = 0x14
  case rl_l = 0x15
  case rl_pHL = 0x16
  case rl_a = 0x17
  case rr_b = 0x18
  case rr_c = 0x19
  case rr_d = 0x1a
  case rr_e = 0x1b
  case rr_h = 0x1c
  case rr_l = 0x1d
  case rr_pHL = 0x1e
  case rr_a = 0x1f
  case sla_b = 0x20
  case sla_c = 0x21
  case sla_d = 0x22
  case sla_e = 0x23
  case sla_h = 0x24
  case sla_l = 0x25
  case sla_pHL = 0x26
  case sla_a = 0x27
  case sra_b = 0x28
  case sra_c = 0x29
  case sra_d = 0x2a
  case sra_e = 0x2b
  case sra_h = 0x2c
  case sra_l = 0x2d
  case sra_pHL = 0x2e
  case sra_a = 0x2f
  case swap_b = 0x30
  case swap_c = 0x31
  case swap_d = 0x32
  case swap_e = 0x33
  case swap_h = 0x34
  case swap_l = 0x35
  case swap_pHL = 0x36
  case swap_a = 0x37
  case srl_b = 0x38
  case srl_c = 0x39
  case srl_d = 0x3a
  case srl_e = 0x3b
  case srl_h = 0x3c
  case srl_l = 0x3d
  case srl_pHL = 0x3e
  case srl_a = 0x3f
  case bit_0_b = 0x40
  case bit_0_c = 0x41
  case bit_0_d = 0x42
  case bit_0_e = 0x43
  case bit_0_h = 0x44
  case bit_0_l = 0x45
  case bit_0_pHL = 0x46
  case bit_0_a = 0x47
  case bit_1_b = 0x48
  case bit_1_c = 0x49
  case bit_1_d = 0x4a
  case bit_1_e = 0x4b
  case bit_1_h = 0x4c
  case bit_1_l = 0x4d
  case bit_1_pHL = 0x4e
  case bit_1_a = 0x4f
  case bit_2_b = 0x50
  case bit_2_c = 0x51
  case bit_2_d = 0x52
  case bit_2_e = 0x53
  case bit_2_h = 0x54
  case bit_2_l = 0x55
  case bit_2_pHL = 0x56
  case bit_2_a = 0x57
  case bit_3_b = 0x58
  case bit_3_c = 0x59
  case bit_3_d = 0x5a
  case bit_3_e = 0x5b
  case bit_3_h = 0x5c
  case bit_3_l = 0x5d
  case bit_3_pHL = 0x5e
  case bit_3_a = 0x5f
  case bit_4_b = 0x60
  case bit_4_c = 0x61
  case bit_4_d = 0x62
  case bit_4_e = 0x63
  case bit_4_h = 0x64
  case bit_4_l = 0x65
  case bit_4_pHL = 0x66
  case bit_4_a = 0x67
  case bit_5_b = 0x68
  case bit_5_c = 0x69
  case bit_5_d = 0x6a
  case bit_5_e = 0x6b
  case bit_5_h = 0x6c
  case bit_5_l = 0x6d
  case bit_5_pHL = 0x6e
  case bit_5_a = 0x6f
  case bit_6_b = 0x70
  case bit_6_c = 0x71
  case bit_6_d = 0x72
  case bit_6_e = 0x73
  case bit_6_h = 0x74
  case bit_6_l = 0x75
  case bit_6_pHL = 0x76
  case bit_6_a = 0x77
  case bit_7_b = 0x78
  case bit_7_c = 0x79
  case bit_7_d = 0x7a
  case bit_7_e = 0x7b
  case bit_7_h = 0x7c
  case bit_7_l = 0x7d
  case bit_7_pHL = 0x7e
  case bit_7_a = 0x7f
  case res_0_b = 0x80
  case res_0_c = 0x81
  case res_0_d = 0x82
  case res_0_e = 0x83
  case res_0_h = 0x84
  case res_0_l = 0x85
  case res_0_pHL = 0x86
  case res_0_a = 0x87
  case res_1_b = 0x88
  case res_1_c = 0x89
  case res_1_d = 0x8a
  case res_1_e = 0x8b
  case res_1_h = 0x8c
  case res_1_l = 0x8d
  case res_1_pHL = 0x8e
  case res_1_a = 0x8f
  case res_2_b = 0x90
  case res_2_c = 0x91
  case res_2_d = 0x92
  case res_2_e = 0x93
  case res_2_h = 0x94
  case res_2_l = 0x95
  case res_2_pHL = 0x96
  case res_2_a = 0x97
  case res_3_b = 0x98
  case res_3_c = 0x99
  case res_3_d = 0x9a
  case res_3_e = 0x9b
  case res_3_h = 0x9c
  case res_3_l = 0x9d
  case res_3_pHL = 0x9e
  case res_3_a = 0x9f
  case res_4_b = 0xa0
  case res_4_c = 0xa1
  case res_4_d = 0xa2
  case res_4_e = 0xa3
  case res_4_h = 0xa4
  case res_4_l = 0xa5
  case res_4_pHL = 0xa6
  case res_4_a = 0xa7
  case res_5_b = 0xa8
  case res_5_c = 0xa9
  case res_5_d = 0xaa
  case res_5_e = 0xab
  case res_5_h = 0xac
  case res_5_l = 0xad
  case res_5_pHL = 0xae
  case res_5_a = 0xaf
  case res_6_b = 0xb0
  case res_6_c = 0xb1
  case res_6_d = 0xb2
  case res_6_e = 0xb3
  case res_6_h = 0xb4
  case res_6_l = 0xb5
  case res_6_pHL = 0xb6
  case res_6_a = 0xb7
  case res_7_b = 0xb8
  case res_7_c = 0xb9
  case res_7_d = 0xba
  case res_7_e = 0xbb
  case res_7_h = 0xbc
  case res_7_l = 0xbd
  case res_7_pHL = 0xbe
  case res_7_a = 0xbf
  case set_0_b = 0xc0
  case set_0_c = 0xc1
  case set_0_d = 0xc2
  case set_0_e = 0xc3
  case set_0_h = 0xc4
  case set_0_l = 0xc5
  case set_0_pHL = 0xc6
  case set_0_a = 0xc7
  case set_1_b = 0xc8
  case set_1_c = 0xc9
  case set_1_d = 0xca
  case set_1_e = 0xcb
  case set_1_h = 0xcc
  case set_1_l = 0xcd
  case set_1_pHL = 0xce
  case set_1_a = 0xcf
  case set_2_b = 0xd0
  case set_2_c = 0xd1
  case set_2_d = 0xd2
  case set_2_e = 0xd3
  case set_2_h = 0xd4
  case set_2_l = 0xd5
  case set_2_pHL = 0xd6
  case set_2_a = 0xd7
  case set_3_b = 0xd8
  case set_3_c = 0xd9
  case set_3_d = 0xda
  case set_3_e = 0xdb
  case set_3_h = 0xdc
  case set_3_l = 0xdd
  case set_3_pHL = 0xde
  case set_3_a = 0xdf
  case set_4_b = 0xe0
  case set_4_c = 0xe1
  case set_4_d = 0xe2
  case set_4_e = 0xe3
  case set_4_h = 0xe4
  case set_4_l = 0xe5
  case set_4_pHL = 0xe6
  case set_4_a = 0xe7
  case set_5_b = 0xe8
  case set_5_c = 0xe9
  case set_5_d = 0xea
  case set_5_e = 0xeb
  case set_5_h = 0xec
  case set_5_l = 0xed
  case set_5_pHL = 0xee
  case set_5_a = 0xef
  case set_6_b = 0xf0
  case set_6_c = 0xf1
  case set_6_d = 0xf2
  case set_6_e = 0xf3
  case set_6_h = 0xf4
  case set_6_l = 0xf5
  case set_6_pHL = 0xf6
  case set_6_a = 0xf7
  case set_7_b = 0xf8
  case set_7_c = 0xf9
  case set_7_d = 0xfa
  case set_7_e = 0xfb
  case set_7_h = 0xfc
  case set_7_l = 0xfd
  case set_7_pHL = 0xfe
  case set_7_a = 0xff
}

