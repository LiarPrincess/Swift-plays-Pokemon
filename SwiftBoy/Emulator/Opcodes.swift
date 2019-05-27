// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable trailing_newline
// swiftlint:disable trailing_comma

enum OpcodeType {
/** 0x0 */ case nop
/** 0x1 */ case ld_bc_d16
/** 0x2 */ case ld_pBC_a
/** 0x3 */ case inc_bc
/** 0x4 */ case inc_b
/** 0x5 */ case dec_b
/** 0x6 */ case ld_b_d8
/** 0x7 */ case rlca
/** 0x8 */ case ld_pA16_sp
/** 0x9 */ case add_hl_bc
/** 0xa */ case ld_a_pBC
/** 0xb */ case dec_bc
/** 0xc */ case inc_c
/** 0xd */ case dec_c
/** 0xe */ case ld_c_d8
/** 0xf */ case rrca
/** 0x10 */ case stop_0
/** 0x11 */ case ld_de_d16
/** 0x12 */ case ld_pDE_a
/** 0x13 */ case inc_de
/** 0x14 */ case inc_d
/** 0x15 */ case dec_d
/** 0x16 */ case ld_d_d8
/** 0x17 */ case rla
/** 0x18 */ case jr_r8
/** 0x19 */ case add_hl_de
/** 0x1a */ case ld_a_pDE
/** 0x1b */ case dec_de
/** 0x1c */ case inc_e
/** 0x1d */ case dec_e
/** 0x1e */ case ld_e_d8
/** 0x1f */ case rra
/** 0x20 */ case jr_nz_r8
/** 0x21 */ case ld_hl_d16
/** 0x22 */ case ld_pHLI_a
/** 0x23 */ case inc_hl
/** 0x24 */ case inc_h
/** 0x25 */ case dec_h
/** 0x26 */ case ld_h_d8
/** 0x27 */ case daa
/** 0x28 */ case jr_z_r8
/** 0x29 */ case add_hl_hl
/** 0x2a */ case ld_a_pHLI
/** 0x2b */ case dec_hl
/** 0x2c */ case inc_l
/** 0x2d */ case dec_l
/** 0x2e */ case ld_l_d8
/** 0x2f */ case cpl
/** 0x30 */ case jr_nc_r8
/** 0x31 */ case ld_sp_d16
/** 0x32 */ case ld_pHLD_a
/** 0x33 */ case inc_sp
/** 0x34 */ case inc_pHL
/** 0x35 */ case dec_pHL
/** 0x36 */ case ld_pHL_d8
/** 0x37 */ case scf
/** 0x38 */ case jr_c_r8
/** 0x39 */ case add_hl_sp
/** 0x3a */ case ld_a_pHLD
/** 0x3b */ case dec_sp
/** 0x3c */ case inc_a
/** 0x3d */ case dec_a
/** 0x3e */ case ld_a_d8
/** 0x3f */ case ccf
/** 0x40 */ case ld_b_b
/** 0x41 */ case ld_b_c
/** 0x42 */ case ld_b_d
/** 0x43 */ case ld_b_e
/** 0x44 */ case ld_b_h
/** 0x45 */ case ld_b_l
/** 0x46 */ case ld_b_pHL
/** 0x47 */ case ld_b_a
/** 0x48 */ case ld_c_b
/** 0x49 */ case ld_c_c
/** 0x4a */ case ld_c_d
/** 0x4b */ case ld_c_e
/** 0x4c */ case ld_c_h
/** 0x4d */ case ld_c_l
/** 0x4e */ case ld_c_pHL
/** 0x4f */ case ld_c_a
/** 0x50 */ case ld_d_b
/** 0x51 */ case ld_d_c
/** 0x52 */ case ld_d_d
/** 0x53 */ case ld_d_e
/** 0x54 */ case ld_d_h
/** 0x55 */ case ld_d_l
/** 0x56 */ case ld_d_pHL
/** 0x57 */ case ld_d_a
/** 0x58 */ case ld_e_b
/** 0x59 */ case ld_e_c
/** 0x5a */ case ld_e_d
/** 0x5b */ case ld_e_e
/** 0x5c */ case ld_e_h
/** 0x5d */ case ld_e_l
/** 0x5e */ case ld_e_pHL
/** 0x5f */ case ld_e_a
/** 0x60 */ case ld_h_b
/** 0x61 */ case ld_h_c
/** 0x62 */ case ld_h_d
/** 0x63 */ case ld_h_e
/** 0x64 */ case ld_h_h
/** 0x65 */ case ld_h_l
/** 0x66 */ case ld_h_pHL
/** 0x67 */ case ld_h_a
/** 0x68 */ case ld_l_b
/** 0x69 */ case ld_l_c
/** 0x6a */ case ld_l_d
/** 0x6b */ case ld_l_e
/** 0x6c */ case ld_l_h
/** 0x6d */ case ld_l_l
/** 0x6e */ case ld_l_pHL
/** 0x6f */ case ld_l_a
/** 0x70 */ case ld_pHL_b
/** 0x71 */ case ld_pHL_c
/** 0x72 */ case ld_pHL_d
/** 0x73 */ case ld_pHL_e
/** 0x74 */ case ld_pHL_h
/** 0x75 */ case ld_pHL_l
/** 0x76 */ case halt
/** 0x77 */ case ld_pHL_a
/** 0x78 */ case ld_a_b
/** 0x79 */ case ld_a_c
/** 0x7a */ case ld_a_d
/** 0x7b */ case ld_a_e
/** 0x7c */ case ld_a_h
/** 0x7d */ case ld_a_l
/** 0x7e */ case ld_a_pHL
/** 0x7f */ case ld_a_a
/** 0x80 */ case add_a_b
/** 0x81 */ case add_a_c
/** 0x82 */ case add_a_d
/** 0x83 */ case add_a_e
/** 0x84 */ case add_a_h
/** 0x85 */ case add_a_l
/** 0x86 */ case add_a_pHL
/** 0x87 */ case add_a_a
/** 0x88 */ case adc_a_b
/** 0x89 */ case adc_a_c
/** 0x8a */ case adc_a_d
/** 0x8b */ case adc_a_e
/** 0x8c */ case adc_a_h
/** 0x8d */ case adc_a_l
/** 0x8e */ case adc_a_pHL
/** 0x8f */ case adc_a_a
/** 0x90 */ case sub_b
/** 0x91 */ case sub_c
/** 0x92 */ case sub_d
/** 0x93 */ case sub_e
/** 0x94 */ case sub_h
/** 0x95 */ case sub_l
/** 0x96 */ case sub_pHL
/** 0x97 */ case sub_a
/** 0x98 */ case sbc_a_b
/** 0x99 */ case sbc_a_c
/** 0x9a */ case sbc_a_d
/** 0x9b */ case sbc_a_e
/** 0x9c */ case sbc_a_h
/** 0x9d */ case sbc_a_l
/** 0x9e */ case sbc_a_pHL
/** 0x9f */ case sbc_a_a
/** 0xa0 */ case and_b
/** 0xa1 */ case and_c
/** 0xa2 */ case and_d
/** 0xa3 */ case and_e
/** 0xa4 */ case and_h
/** 0xa5 */ case and_l
/** 0xa6 */ case and_pHL
/** 0xa7 */ case and_a
/** 0xa8 */ case xor_b
/** 0xa9 */ case xor_c
/** 0xaa */ case xor_d
/** 0xab */ case xor_e
/** 0xac */ case xor_h
/** 0xad */ case xor_l
/** 0xae */ case xor_pHL
/** 0xaf */ case xor_a
/** 0xb0 */ case or_b
/** 0xb1 */ case or_c
/** 0xb2 */ case or_d
/** 0xb3 */ case or_e
/** 0xb4 */ case or_h
/** 0xb5 */ case or_l
/** 0xb6 */ case or_pHL
/** 0xb7 */ case or_a
/** 0xb8 */ case cp_b
/** 0xb9 */ case cp_c
/** 0xba */ case cp_d
/** 0xbb */ case cp_e
/** 0xbc */ case cp_h
/** 0xbd */ case cp_l
/** 0xbe */ case cp_pHL
/** 0xbf */ case cp_a
/** 0xc0 */ case ret_nz
/** 0xc1 */ case pop_bc
/** 0xc2 */ case jp_nz_a16
/** 0xc3 */ case jp_a16
/** 0xc4 */ case call_nz_a16
/** 0xc5 */ case push_bc
/** 0xc6 */ case add_a_d8
/** 0xc7 */ case rst_00
/** 0xc8 */ case ret_z
/** 0xc9 */ case ret
/** 0xca */ case jp_z_a16
/** 0xcb */ case prefix_cb
/** 0xcc */ case call_z_a16
/** 0xcd */ case call_a16
/** 0xce */ case adc_a_d8
/** 0xcf */ case rst_08
/** 0xd0 */ case ret_nc
/** 0xd1 */ case pop_de
/** 0xd2 */ case jp_nc_a16
/** 0xd4 */ case call_nc_a16
/** 0xd5 */ case push_de
/** 0xd6 */ case sub_d8
/** 0xd7 */ case rst_10
/** 0xd8 */ case ret_c
/** 0xd9 */ case reti
/** 0xda */ case jp_c_a16
/** 0xdc */ case call_c_a16
/** 0xde */ case sbc_a_d8
/** 0xdf */ case rst_18
/** 0xe0 */ case ldh_pA8_a
/** 0xe1 */ case pop_hl
/** 0xe2 */ case ld_pC_a
/** 0xe5 */ case push_hl
/** 0xe6 */ case and_d8
/** 0xe7 */ case rst_20
/** 0xe8 */ case add_sp_r8
/** 0xe9 */ case jp_pHL
/** 0xea */ case ld_pA16_a
/** 0xee */ case xor_d8
/** 0xef */ case rst_28
/** 0xf0 */ case ldh_a_pA8
/** 0xf1 */ case pop_af
/** 0xf2 */ case ld_a_pC
/** 0xf3 */ case di
/** 0xf5 */ case push_af
/** 0xf6 */ case or_d8
/** 0xf7 */ case rst_30
/** 0xf8 */ case ld_hl_spR8
/** 0xf9 */ case ld_sp_hl
/** 0xfa */ case ld_a_pA16
/** 0xfb */ case ei
/** 0xfe */ case cp_d8
/** 0xff */ case rst_38
}

let opcodes: [Opcode] = [
  Opcode(addr: "0x0",     type: .nop,               debug: "nop",            length: 1, cycles: [4]),
  Opcode(addr: "0x1",     type: .ld_bc_d16,         debug: "ld_bc_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x2",     type: .ld_pBC_a,          debug: "ld_pBC_a",       length: 1, cycles: [8]),
  Opcode(addr: "0x3",     type: .inc_bc,            debug: "inc_bc",         length: 1, cycles: [8]),
  Opcode(addr: "0x4",     type: .inc_b,             debug: "inc_b",          length: 1, cycles: [4]),
  Opcode(addr: "0x5",     type: .dec_b,             debug: "dec_b",          length: 1, cycles: [4]),
  Opcode(addr: "0x6",     type: .ld_b_d8,           debug: "ld_b_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x7",     type: .rlca,              debug: "rlca",           length: 1, cycles: [4]),
  Opcode(addr: "0x8",     type: .ld_pA16_sp,        debug: "ld_pA16_sp",     length: 3, cycles: [20]),
  Opcode(addr: "0x9",     type: .add_hl_bc,         debug: "add_hl_bc",      length: 1, cycles: [8]),
  Opcode(addr: "0xa",     type: .ld_a_pBC,          debug: "ld_a_pBC",       length: 1, cycles: [8]),
  Opcode(addr: "0xb",     type: .dec_bc,            debug: "dec_bc",         length: 1, cycles: [8]),
  Opcode(addr: "0xc",     type: .inc_c,             debug: "inc_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xd",     type: .dec_c,             debug: "dec_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xe",     type: .ld_c_d8,           debug: "ld_c_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0xf",     type: .rrca,              debug: "rrca",           length: 1, cycles: [4]),
  Opcode(addr: "0x10",    type: .stop_0,            debug: "stop_0",         length: 1, cycles: [4]),
  Opcode(addr: "0x11",    type: .ld_de_d16,         debug: "ld_de_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x12",    type: .ld_pDE_a,          debug: "ld_pDE_a",       length: 1, cycles: [8]),
  Opcode(addr: "0x13",    type: .inc_de,            debug: "inc_de",         length: 1, cycles: [8]),
  Opcode(addr: "0x14",    type: .inc_d,             debug: "inc_d",          length: 1, cycles: [4]),
  Opcode(addr: "0x15",    type: .dec_d,             debug: "dec_d",          length: 1, cycles: [4]),
  Opcode(addr: "0x16",    type: .ld_d_d8,           debug: "ld_d_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x17",    type: .rla,               debug: "rla",            length: 1, cycles: [4]),
  Opcode(addr: "0x18",    type: .jr_r8,             debug: "jr_r8",          length: 2, cycles: [12]),
  Opcode(addr: "0x19",    type: .add_hl_de,         debug: "add_hl_de",      length: 1, cycles: [8]),
  Opcode(addr: "0x1a",    type: .ld_a_pDE,          debug: "ld_a_pDE",       length: 1, cycles: [8]),
  Opcode(addr: "0x1b",    type: .dec_de,            debug: "dec_de",         length: 1, cycles: [8]),
  Opcode(addr: "0x1c",    type: .inc_e,             debug: "inc_e",          length: 1, cycles: [4]),
  Opcode(addr: "0x1d",    type: .dec_e,             debug: "dec_e",          length: 1, cycles: [4]),
  Opcode(addr: "0x1e",    type: .ld_e_d8,           debug: "ld_e_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x1f",    type: .rra,               debug: "rra",            length: 1, cycles: [4]),
  Opcode(addr: "0x20",    type: .jr_nz_r8,          debug: "jr_nz_r8",       length: 2, cycles: [12, 8]),
  Opcode(addr: "0x21",    type: .ld_hl_d16,         debug: "ld_hl_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x22",    type: .ld_pHLI_a,         debug: "ld_pHLI_a",      length: 1, cycles: [8]),
  Opcode(addr: "0x23",    type: .inc_hl,            debug: "inc_hl",         length: 1, cycles: [8]),
  Opcode(addr: "0x24",    type: .inc_h,             debug: "inc_h",          length: 1, cycles: [4]),
  Opcode(addr: "0x25",    type: .dec_h,             debug: "dec_h",          length: 1, cycles: [4]),
  Opcode(addr: "0x26",    type: .ld_h_d8,           debug: "ld_h_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x27",    type: .daa,               debug: "daa",            length: 1, cycles: [4]),
  Opcode(addr: "0x28",    type: .jr_z_r8,           debug: "jr_z_r8",        length: 2, cycles: [12, 8]),
  Opcode(addr: "0x29",    type: .add_hl_hl,         debug: "add_hl_hl",      length: 1, cycles: [8]),
  Opcode(addr: "0x2a",    type: .ld_a_pHLI,         debug: "ld_a_pHLI",      length: 1, cycles: [8]),
  Opcode(addr: "0x2b",    type: .dec_hl,            debug: "dec_hl",         length: 1, cycles: [8]),
  Opcode(addr: "0x2c",    type: .inc_l,             debug: "inc_l",          length: 1, cycles: [4]),
  Opcode(addr: "0x2d",    type: .dec_l,             debug: "dec_l",          length: 1, cycles: [4]),
  Opcode(addr: "0x2e",    type: .ld_l_d8,           debug: "ld_l_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x2f",    type: .cpl,               debug: "cpl",            length: 1, cycles: [4]),
  Opcode(addr: "0x30",    type: .jr_nc_r8,          debug: "jr_nc_r8",       length: 2, cycles: [12, 8]),
  Opcode(addr: "0x31",    type: .ld_sp_d16,         debug: "ld_sp_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x32",    type: .ld_pHLD_a,         debug: "ld_pHLD_a",      length: 1, cycles: [8]),
  Opcode(addr: "0x33",    type: .inc_sp,            debug: "inc_sp",         length: 1, cycles: [8]),
  Opcode(addr: "0x34",    type: .inc_pHL,           debug: "inc_pHL",        length: 1, cycles: [12]),
  Opcode(addr: "0x35",    type: .dec_pHL,           debug: "dec_pHL",        length: 1, cycles: [12]),
  Opcode(addr: "0x36",    type: .ld_pHL_d8,         debug: "ld_pHL_d8",      length: 2, cycles: [12]),
  Opcode(addr: "0x37",    type: .scf,               debug: "scf",            length: 1, cycles: [4]),
  Opcode(addr: "0x38",    type: .jr_c_r8,           debug: "jr_c_r8",        length: 2, cycles: [12, 8]),
  Opcode(addr: "0x39",    type: .add_hl_sp,         debug: "add_hl_sp",      length: 1, cycles: [8]),
  Opcode(addr: "0x3a",    type: .ld_a_pHLD,         debug: "ld_a_pHLD",      length: 1, cycles: [8]),
  Opcode(addr: "0x3b",    type: .dec_sp,            debug: "dec_sp",         length: 1, cycles: [8]),
  Opcode(addr: "0x3c",    type: .inc_a,             debug: "inc_a",          length: 1, cycles: [4]),
  Opcode(addr: "0x3d",    type: .dec_a,             debug: "dec_a",          length: 1, cycles: [4]),
  Opcode(addr: "0x3e",    type: .ld_a_d8,           debug: "ld_a_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x3f",    type: .ccf,               debug: "ccf",            length: 1, cycles: [4]),
  Opcode(addr: "0x40",    type: .ld_b_b,            debug: "ld_b_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x41",    type: .ld_b_c,            debug: "ld_b_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x42",    type: .ld_b_d,            debug: "ld_b_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x43",    type: .ld_b_e,            debug: "ld_b_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x44",    type: .ld_b_h,            debug: "ld_b_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x45",    type: .ld_b_l,            debug: "ld_b_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x46",    type: .ld_b_pHL,          debug: "ld_b_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x47",    type: .ld_b_a,            debug: "ld_b_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x48",    type: .ld_c_b,            debug: "ld_c_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x49",    type: .ld_c_c,            debug: "ld_c_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x4a",    type: .ld_c_d,            debug: "ld_c_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x4b",    type: .ld_c_e,            debug: "ld_c_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x4c",    type: .ld_c_h,            debug: "ld_c_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x4d",    type: .ld_c_l,            debug: "ld_c_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x4e",    type: .ld_c_pHL,          debug: "ld_c_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x4f",    type: .ld_c_a,            debug: "ld_c_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x50",    type: .ld_d_b,            debug: "ld_d_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x51",    type: .ld_d_c,            debug: "ld_d_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x52",    type: .ld_d_d,            debug: "ld_d_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x53",    type: .ld_d_e,            debug: "ld_d_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x54",    type: .ld_d_h,            debug: "ld_d_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x55",    type: .ld_d_l,            debug: "ld_d_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x56",    type: .ld_d_pHL,          debug: "ld_d_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x57",    type: .ld_d_a,            debug: "ld_d_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x58",    type: .ld_e_b,            debug: "ld_e_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x59",    type: .ld_e_c,            debug: "ld_e_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x5a",    type: .ld_e_d,            debug: "ld_e_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x5b",    type: .ld_e_e,            debug: "ld_e_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x5c",    type: .ld_e_h,            debug: "ld_e_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x5d",    type: .ld_e_l,            debug: "ld_e_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x5e",    type: .ld_e_pHL,          debug: "ld_e_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x5f",    type: .ld_e_a,            debug: "ld_e_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x60",    type: .ld_h_b,            debug: "ld_h_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x61",    type: .ld_h_c,            debug: "ld_h_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x62",    type: .ld_h_d,            debug: "ld_h_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x63",    type: .ld_h_e,            debug: "ld_h_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x64",    type: .ld_h_h,            debug: "ld_h_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x65",    type: .ld_h_l,            debug: "ld_h_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x66",    type: .ld_h_pHL,          debug: "ld_h_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x67",    type: .ld_h_a,            debug: "ld_h_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x68",    type: .ld_l_b,            debug: "ld_l_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x69",    type: .ld_l_c,            debug: "ld_l_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x6a",    type: .ld_l_d,            debug: "ld_l_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x6b",    type: .ld_l_e,            debug: "ld_l_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x6c",    type: .ld_l_h,            debug: "ld_l_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x6d",    type: .ld_l_l,            debug: "ld_l_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x6e",    type: .ld_l_pHL,          debug: "ld_l_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x6f",    type: .ld_l_a,            debug: "ld_l_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x70",    type: .ld_pHL_b,          debug: "ld_pHL_b",       length: 1, cycles: [8]),
  Opcode(addr: "0x71",    type: .ld_pHL_c,          debug: "ld_pHL_c",       length: 1, cycles: [8]),
  Opcode(addr: "0x72",    type: .ld_pHL_d,          debug: "ld_pHL_d",       length: 1, cycles: [8]),
  Opcode(addr: "0x73",    type: .ld_pHL_e,          debug: "ld_pHL_e",       length: 1, cycles: [8]),
  Opcode(addr: "0x74",    type: .ld_pHL_h,          debug: "ld_pHL_h",       length: 1, cycles: [8]),
  Opcode(addr: "0x75",    type: .ld_pHL_l,          debug: "ld_pHL_l",       length: 1, cycles: [8]),
  Opcode(addr: "0x76",    type: .halt,              debug: "halt",           length: 1, cycles: [4]),
  Opcode(addr: "0x77",    type: .ld_pHL_a,          debug: "ld_pHL_a",       length: 1, cycles: [8]),
  Opcode(addr: "0x78",    type: .ld_a_b,            debug: "ld_a_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x79",    type: .ld_a_c,            debug: "ld_a_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x7a",    type: .ld_a_d,            debug: "ld_a_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x7b",    type: .ld_a_e,            debug: "ld_a_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x7c",    type: .ld_a_h,            debug: "ld_a_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x7d",    type: .ld_a_l,            debug: "ld_a_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x7e",    type: .ld_a_pHL,          debug: "ld_a_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x7f",    type: .ld_a_a,            debug: "ld_a_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x80",    type: .add_a_b,           debug: "add_a_b",        length: 1, cycles: [4]),
  Opcode(addr: "0x81",    type: .add_a_c,           debug: "add_a_c",        length: 1, cycles: [4]),
  Opcode(addr: "0x82",    type: .add_a_d,           debug: "add_a_d",        length: 1, cycles: [4]),
  Opcode(addr: "0x83",    type: .add_a_e,           debug: "add_a_e",        length: 1, cycles: [4]),
  Opcode(addr: "0x84",    type: .add_a_h,           debug: "add_a_h",        length: 1, cycles: [4]),
  Opcode(addr: "0x85",    type: .add_a_l,           debug: "add_a_l",        length: 1, cycles: [4]),
  Opcode(addr: "0x86",    type: .add_a_pHL,         debug: "add_a_pHL",      length: 1, cycles: [8]),
  Opcode(addr: "0x87",    type: .add_a_a,           debug: "add_a_a",        length: 1, cycles: [4]),
  Opcode(addr: "0x88",    type: .adc_a_b,           debug: "adc_a_b",        length: 1, cycles: [4]),
  Opcode(addr: "0x89",    type: .adc_a_c,           debug: "adc_a_c",        length: 1, cycles: [4]),
  Opcode(addr: "0x8a",    type: .adc_a_d,           debug: "adc_a_d",        length: 1, cycles: [4]),
  Opcode(addr: "0x8b",    type: .adc_a_e,           debug: "adc_a_e",        length: 1, cycles: [4]),
  Opcode(addr: "0x8c",    type: .adc_a_h,           debug: "adc_a_h",        length: 1, cycles: [4]),
  Opcode(addr: "0x8d",    type: .adc_a_l,           debug: "adc_a_l",        length: 1, cycles: [4]),
  Opcode(addr: "0x8e",    type: .adc_a_pHL,         debug: "adc_a_pHL",      length: 1, cycles: [8]),
  Opcode(addr: "0x8f",    type: .adc_a_a,           debug: "adc_a_a",        length: 1, cycles: [4]),
  Opcode(addr: "0x90",    type: .sub_b,             debug: "sub_b",          length: 1, cycles: [4]),
  Opcode(addr: "0x91",    type: .sub_c,             debug: "sub_c",          length: 1, cycles: [4]),
  Opcode(addr: "0x92",    type: .sub_d,             debug: "sub_d",          length: 1, cycles: [4]),
  Opcode(addr: "0x93",    type: .sub_e,             debug: "sub_e",          length: 1, cycles: [4]),
  Opcode(addr: "0x94",    type: .sub_h,             debug: "sub_h",          length: 1, cycles: [4]),
  Opcode(addr: "0x95",    type: .sub_l,             debug: "sub_l",          length: 1, cycles: [4]),
  Opcode(addr: "0x96",    type: .sub_pHL,           debug: "sub_pHL",        length: 1, cycles: [8]),
  Opcode(addr: "0x97",    type: .sub_a,             debug: "sub_a",          length: 1, cycles: [4]),
  Opcode(addr: "0x98",    type: .sbc_a_b,           debug: "sbc_a_b",        length: 1, cycles: [4]),
  Opcode(addr: "0x99",    type: .sbc_a_c,           debug: "sbc_a_c",        length: 1, cycles: [4]),
  Opcode(addr: "0x9a",    type: .sbc_a_d,           debug: "sbc_a_d",        length: 1, cycles: [4]),
  Opcode(addr: "0x9b",    type: .sbc_a_e,           debug: "sbc_a_e",        length: 1, cycles: [4]),
  Opcode(addr: "0x9c",    type: .sbc_a_h,           debug: "sbc_a_h",        length: 1, cycles: [4]),
  Opcode(addr: "0x9d",    type: .sbc_a_l,           debug: "sbc_a_l",        length: 1, cycles: [4]),
  Opcode(addr: "0x9e",    type: .sbc_a_pHL,         debug: "sbc_a_pHL",      length: 1, cycles: [8]),
  Opcode(addr: "0x9f",    type: .sbc_a_a,           debug: "sbc_a_a",        length: 1, cycles: [4]),
  Opcode(addr: "0xa0",    type: .and_b,             debug: "and_b",          length: 1, cycles: [4]),
  Opcode(addr: "0xa1",    type: .and_c,             debug: "and_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xa2",    type: .and_d,             debug: "and_d",          length: 1, cycles: [4]),
  Opcode(addr: "0xa3",    type: .and_e,             debug: "and_e",          length: 1, cycles: [4]),
  Opcode(addr: "0xa4",    type: .and_h,             debug: "and_h",          length: 1, cycles: [4]),
  Opcode(addr: "0xa5",    type: .and_l,             debug: "and_l",          length: 1, cycles: [4]),
  Opcode(addr: "0xa6",    type: .and_pHL,           debug: "and_pHL",        length: 1, cycles: [8]),
  Opcode(addr: "0xa7",    type: .and_a,             debug: "and_a",          length: 1, cycles: [4]),
  Opcode(addr: "0xa8",    type: .xor_b,             debug: "xor_b",          length: 1, cycles: [4]),
  Opcode(addr: "0xa9",    type: .xor_c,             debug: "xor_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xaa",    type: .xor_d,             debug: "xor_d",          length: 1, cycles: [4]),
  Opcode(addr: "0xab",    type: .xor_e,             debug: "xor_e",          length: 1, cycles: [4]),
  Opcode(addr: "0xac",    type: .xor_h,             debug: "xor_h",          length: 1, cycles: [4]),
  Opcode(addr: "0xad",    type: .xor_l,             debug: "xor_l",          length: 1, cycles: [4]),
  Opcode(addr: "0xae",    type: .xor_pHL,           debug: "xor_pHL",        length: 1, cycles: [8]),
  Opcode(addr: "0xaf",    type: .xor_a,             debug: "xor_a",          length: 1, cycles: [4]),
  Opcode(addr: "0xb0",    type: .or_b,              debug: "or_b",           length: 1, cycles: [4]),
  Opcode(addr: "0xb1",    type: .or_c,              debug: "or_c",           length: 1, cycles: [4]),
  Opcode(addr: "0xb2",    type: .or_d,              debug: "or_d",           length: 1, cycles: [4]),
  Opcode(addr: "0xb3",    type: .or_e,              debug: "or_e",           length: 1, cycles: [4]),
  Opcode(addr: "0xb4",    type: .or_h,              debug: "or_h",           length: 1, cycles: [4]),
  Opcode(addr: "0xb5",    type: .or_l,              debug: "or_l",           length: 1, cycles: [4]),
  Opcode(addr: "0xb6",    type: .or_pHL,            debug: "or_pHL",         length: 1, cycles: [8]),
  Opcode(addr: "0xb7",    type: .or_a,              debug: "or_a",           length: 1, cycles: [4]),
  Opcode(addr: "0xb8",    type: .cp_b,              debug: "cp_b",           length: 1, cycles: [4]),
  Opcode(addr: "0xb9",    type: .cp_c,              debug: "cp_c",           length: 1, cycles: [4]),
  Opcode(addr: "0xba",    type: .cp_d,              debug: "cp_d",           length: 1, cycles: [4]),
  Opcode(addr: "0xbb",    type: .cp_e,              debug: "cp_e",           length: 1, cycles: [4]),
  Opcode(addr: "0xbc",    type: .cp_h,              debug: "cp_h",           length: 1, cycles: [4]),
  Opcode(addr: "0xbd",    type: .cp_l,              debug: "cp_l",           length: 1, cycles: [4]),
  Opcode(addr: "0xbe",    type: .cp_pHL,            debug: "cp_pHL",         length: 1, cycles: [8]),
  Opcode(addr: "0xbf",    type: .cp_a,              debug: "cp_a",           length: 1, cycles: [4]),
  Opcode(addr: "0xc0",    type: .ret_nz,            debug: "ret_nz",         length: 1, cycles: [20, 8]),
  Opcode(addr: "0xc1",    type: .pop_bc,            debug: "pop_bc",         length: 1, cycles: [12]),
  Opcode(addr: "0xc2",    type: .jp_nz_a16,         debug: "jp_nz_a16",      length: 3, cycles: [16, 12]),
  Opcode(addr: "0xc3",    type: .jp_a16,            debug: "jp_a16",         length: 3, cycles: [16]),
  Opcode(addr: "0xc4",    type: .call_nz_a16,       debug: "call_nz_a16",    length: 3, cycles: [24, 12]),
  Opcode(addr: "0xc5",    type: .push_bc,           debug: "push_bc",        length: 1, cycles: [16]),
  Opcode(addr: "0xc6",    type: .add_a_d8,          debug: "add_a_d8",       length: 2, cycles: [8]),
  Opcode(addr: "0xc7",    type: .rst_00,            debug: "rst_00",         length: 1, cycles: [16]),
  Opcode(addr: "0xc8",    type: .ret_z,             debug: "ret_z",          length: 1, cycles: [20, 8]),
  Opcode(addr: "0xc9",    type: .ret,               debug: "ret",            length: 1, cycles: [16]),
  Opcode(addr: "0xca",    type: .jp_z_a16,          debug: "jp_z_a16",       length: 3, cycles: [16, 12]),
  Opcode(addr: "0xcb",    type: .prefix_cb,         debug: "prefix_cb",      length: 1, cycles: [4]),
  Opcode(addr: "0xcc",    type: .call_z_a16,        debug: "call_z_a16",     length: 3, cycles: [24, 12]),
  Opcode(addr: "0xcd",    type: .call_a16,          debug: "call_a16",       length: 3, cycles: [24]),
  Opcode(addr: "0xce",    type: .adc_a_d8,          debug: "adc_a_d8",       length: 2, cycles: [8]),
  Opcode(addr: "0xcf",    type: .rst_08,            debug: "rst_08",         length: 1, cycles: [16]),
  Opcode(addr: "0xd0",    type: .ret_nc,            debug: "ret_nc",         length: 1, cycles: [20, 8]),
  Opcode(addr: "0xd1",    type: .pop_de,            debug: "pop_de",         length: 1, cycles: [12]),
  Opcode(addr: "0xd2",    type: .jp_nc_a16,         debug: "jp_nc_a16",      length: 3, cycles: [16, 12]),
  Opcode(addr: "0xd4",    type: .call_nc_a16,       debug: "call_nc_a16",    length: 3, cycles: [24, 12]),
  Opcode(addr: "0xd5",    type: .push_de,           debug: "push_de",        length: 1, cycles: [16]),
  Opcode(addr: "0xd6",    type: .sub_d8,            debug: "sub_d8",         length: 2, cycles: [8]),
  Opcode(addr: "0xd7",    type: .rst_10,            debug: "rst_10",         length: 1, cycles: [16]),
  Opcode(addr: "0xd8",    type: .ret_c,             debug: "ret_c",          length: 1, cycles: [20, 8]),
  Opcode(addr: "0xd9",    type: .reti,              debug: "reti",           length: 1, cycles: [16]),
  Opcode(addr: "0xda",    type: .jp_c_a16,          debug: "jp_c_a16",       length: 3, cycles: [16, 12]),
  Opcode(addr: "0xdc",    type: .call_c_a16,        debug: "call_c_a16",     length: 3, cycles: [24, 12]),
  Opcode(addr: "0xde",    type: .sbc_a_d8,          debug: "sbc_a_d8",       length: 2, cycles: [8]),
  Opcode(addr: "0xdf",    type: .rst_18,            debug: "rst_18",         length: 1, cycles: [16]),
  Opcode(addr: "0xe0",    type: .ldh_pA8_a,         debug: "ldh_pA8_a",      length: 2, cycles: [12]),
  Opcode(addr: "0xe1",    type: .pop_hl,            debug: "pop_hl",         length: 1, cycles: [12]),
  Opcode(addr: "0xe2",    type: .ld_pC_a,           debug: "ld_pC_a",        length: 1, cycles: [8]),
  Opcode(addr: "0xe5",    type: .push_hl,           debug: "push_hl",        length: 1, cycles: [16]),
  Opcode(addr: "0xe6",    type: .and_d8,            debug: "and_d8",         length: 2, cycles: [8]),
  Opcode(addr: "0xe7",    type: .rst_20,            debug: "rst_20",         length: 1, cycles: [16]),
  Opcode(addr: "0xe8",    type: .add_sp_r8,         debug: "add_sp_r8",      length: 2, cycles: [16]),
  Opcode(addr: "0xe9",    type: .jp_pHL,            debug: "jp_pHL",         length: 1, cycles: [4]),
  Opcode(addr: "0xea",    type: .ld_pA16_a,         debug: "ld_pA16_a",      length: 3, cycles: [16]),
  Opcode(addr: "0xee",    type: .xor_d8,            debug: "xor_d8",         length: 2, cycles: [8]),
  Opcode(addr: "0xef",    type: .rst_28,            debug: "rst_28",         length: 1, cycles: [16]),
  Opcode(addr: "0xf0",    type: .ldh_a_pA8,         debug: "ldh_a_pA8",      length: 2, cycles: [12]),
  Opcode(addr: "0xf1",    type: .pop_af,            debug: "pop_af",         length: 1, cycles: [12]),
  Opcode(addr: "0xf2",    type: .ld_a_pC,           debug: "ld_a_pC",        length: 1, cycles: [8]),
  Opcode(addr: "0xf3",    type: .di,                debug: "di",             length: 1, cycles: [4]),
  Opcode(addr: "0xf5",    type: .push_af,           debug: "push_af",        length: 1, cycles: [16]),
  Opcode(addr: "0xf6",    type: .or_d8,             debug: "or_d8",          length: 2, cycles: [8]),
  Opcode(addr: "0xf7",    type: .rst_30,            debug: "rst_30",         length: 1, cycles: [16]),
  Opcode(addr: "0xf8",    type: .ld_hl_spR8,        debug: "ld_hl_spR8",     length: 2, cycles: [12]),
  Opcode(addr: "0xf9",    type: .ld_sp_hl,          debug: "ld_sp_hl",       length: 1, cycles: [8]),
  Opcode(addr: "0xfa",    type: .ld_a_pA16,         debug: "ld_a_pA16",      length: 3, cycles: [16]),
  Opcode(addr: "0xfb",    type: .ei,                debug: "ei",             length: 1, cycles: [4]),
  Opcode(addr: "0xfe",    type: .cp_d8,             debug: "cp_d8",          length: 2, cycles: [8]),
  Opcode(addr: "0xff",    type: .rst_38,            debug: "rst_38",         length: 1, cycles: [16]),
]

