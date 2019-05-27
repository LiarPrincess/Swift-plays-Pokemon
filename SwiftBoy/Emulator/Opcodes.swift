// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable trailing_comma
// swiftlint:disable file_length

enum OpcodeType {
  case nop_00
  case ld_bc_d16_01
  case ld_pBC_a_02
  case inc_bc_03
  case inc_b_04
  case dec_b_05
  case ld_b_d8_06
  case rlca_07
  case ld_pA16_sp_08
  case add_hl_bc_09
  case ld_a_pBC_0a
  case dec_bc_0b
  case inc_c_0c
  case dec_c_0d
  case ld_c_d8_0e
  case rrca_0f
  case stop_0_10
  case ld_de_d16_11
  case ld_pDE_a_12
  case inc_de_13
  case inc_d_14
  case dec_d_15
  case ld_d_d8_16
  case rla_17
  case jr_r8_18
  case add_hl_de_19
  case ld_a_pDE_1a
  case dec_de_1b
  case inc_e_1c
  case dec_e_1d
  case ld_e_d8_1e
  case rra_1f
  case jr_nz_r8_20
  case ld_hl_d16_21
  case ld_pHLI_a_22
  case inc_hl_23
  case inc_h_24
  case dec_h_25
  case ld_h_d8_26
  case daa_27
  case jr_z_r8_28
  case add_hl_hl_29
  case ld_a_pHLI_2a
  case dec_hl_2b
  case inc_l_2c
  case dec_l_2d
  case ld_l_d8_2e
  case cpl_2f
  case jr_nc_r8_30
  case ld_sp_d16_31
  case ld_pHLD_a_32
  case inc_sp_33
  case inc_pHL_34
  case dec_pHL_35
  case ld_pHL_d8_36
  case scf_37
  case jr_c_r8_38
  case add_hl_sp_39
  case ld_a_pHLD_3a
  case dec_sp_3b
  case inc_a_3c
  case dec_a_3d
  case ld_a_d8_3e
  case ccf_3f
  case ld_b_b_40
  case ld_b_c_41
  case ld_b_d_42
  case ld_b_e_43
  case ld_b_h_44
  case ld_b_l_45
  case ld_b_pHL_46
  case ld_b_a_47
  case ld_c_b_48
  case ld_c_c_49
  case ld_c_d_4a
  case ld_c_e_4b
  case ld_c_h_4c
  case ld_c_l_4d
  case ld_c_pHL_4e
  case ld_c_a_4f
  case ld_d_b_50
  case ld_d_c_51
  case ld_d_d_52
  case ld_d_e_53
  case ld_d_h_54
  case ld_d_l_55
  case ld_d_pHL_56
  case ld_d_a_57
  case ld_e_b_58
  case ld_e_c_59
  case ld_e_d_5a
  case ld_e_e_5b
  case ld_e_h_5c
  case ld_e_l_5d
  case ld_e_pHL_5e
  case ld_e_a_5f
  case ld_h_b_60
  case ld_h_c_61
  case ld_h_d_62
  case ld_h_e_63
  case ld_h_h_64
  case ld_h_l_65
  case ld_h_pHL_66
  case ld_h_a_67
  case ld_l_b_68
  case ld_l_c_69
  case ld_l_d_6a
  case ld_l_e_6b
  case ld_l_h_6c
  case ld_l_l_6d
  case ld_l_pHL_6e
  case ld_l_a_6f
  case ld_pHL_b_70
  case ld_pHL_c_71
  case ld_pHL_d_72
  case ld_pHL_e_73
  case ld_pHL_h_74
  case ld_pHL_l_75
  case halt_76
  case ld_pHL_a_77
  case ld_a_b_78
  case ld_a_c_79
  case ld_a_d_7a
  case ld_a_e_7b
  case ld_a_h_7c
  case ld_a_l_7d
  case ld_a_pHL_7e
  case ld_a_a_7f
  case add_a_b_80
  case add_a_c_81
  case add_a_d_82
  case add_a_e_83
  case add_a_h_84
  case add_a_l_85
  case add_a_pHL_86
  case add_a_a_87
  case adc_a_b_88
  case adc_a_c_89
  case adc_a_d_8a
  case adc_a_e_8b
  case adc_a_h_8c
  case adc_a_l_8d
  case adc_a_pHL_8e
  case adc_a_a_8f
  case sub_b_90
  case sub_c_91
  case sub_d_92
  case sub_e_93
  case sub_h_94
  case sub_l_95
  case sub_pHL_96
  case sub_a_97
  case sbc_a_b_98
  case sbc_a_c_99
  case sbc_a_d_9a
  case sbc_a_e_9b
  case sbc_a_h_9c
  case sbc_a_l_9d
  case sbc_a_pHL_9e
  case sbc_a_a_9f
  case and_b_a0
  case and_c_a1
  case and_d_a2
  case and_e_a3
  case and_h_a4
  case and_l_a5
  case and_pHL_a6
  case and_a_a7
  case xor_b_a8
  case xor_c_a9
  case xor_d_aa
  case xor_e_ab
  case xor_h_ac
  case xor_l_ad
  case xor_pHL_ae
  case xor_a_af
  case or_b_b0
  case or_c_b1
  case or_d_b2
  case or_e_b3
  case or_h_b4
  case or_l_b5
  case or_pHL_b6
  case or_a_b7
  case cp_b_b8
  case cp_c_b9
  case cp_d_ba
  case cp_e_bb
  case cp_h_bc
  case cp_l_bd
  case cp_pHL_be
  case cp_a_bf
  case ret_nz_c0
  case pop_bc_c1
  case jp_nz_a16_c2
  case jp_a16_c3
  case call_nz_a16_c4
  case push_bc_c5
  case add_a_d8_c6
  case rst_00h_c7
  case ret_z_c8
  case ret_c9
  case jp_z_a16_ca
  case prefix_cb_cb
  case call_z_a16_cc
  case call_a16_cd
  case adc_a_d8_ce
  case rst_08h_cf
  case ret_nc_d0
  case pop_de_d1
  case jp_nc_a16_d2
  case call_nc_a16_d4
  case push_de_d5
  case sub_d8_d6
  case rst_10h_d7
  case ret_c_d8
  case reti_d9
  case jp_c_a16_da
  case call_c_a16_dc
  case sbc_a_d8_de
  case rst_18h_df
  case ldh_pA8_a_e0
  case pop_hl_e1
  case ld_pC_a_e2
  case push_hl_e5
  case and_d8_e6
  case rst_20h_e7
  case add_sp_r8_e8
  case jp_pHL_e9
  case ld_pA16_a_ea
  case xor_d8_ee
  case rst_28h_ef
  case ldh_a_pA8_f0
  case pop_af_f1
  case ld_a_pC_f2
  case di_f3
  case push_af_f5
  case or_d8_f6
  case rst_30h_f7
  case ld_hl_spR8_f8
  case ld_sp_hl_f9
  case ld_a_pA16_fa
  case ei_fb
  case cp_d8_fe
  case rst_38h_ff
}

let opcodes: [Opcode] = [
  Opcode(addr: "0x0",     type: .nop_00,            debug: "nop",            length: 1, cycles: [4]),
  Opcode(addr: "0x1",     type: .ld_bc_d16_01,      debug: "ld_bc_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x2",     type: .ld_pBC_a_02,       debug: "ld_pBC_a",       length: 1, cycles: [8]),
  Opcode(addr: "0x3",     type: .inc_bc_03,         debug: "inc_bc",         length: 1, cycles: [8]),
  Opcode(addr: "0x4",     type: .inc_b_04,          debug: "inc_b",          length: 1, cycles: [4]),
  Opcode(addr: "0x5",     type: .dec_b_05,          debug: "dec_b",          length: 1, cycles: [4]),
  Opcode(addr: "0x6",     type: .ld_b_d8_06,        debug: "ld_b_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x7",     type: .rlca_07,           debug: "rlca",           length: 1, cycles: [4]),
  Opcode(addr: "0x8",     type: .ld_pA16_sp_08,     debug: "ld_pA16_sp",     length: 3, cycles: [20]),
  Opcode(addr: "0x9",     type: .add_hl_bc_09,      debug: "add_hl_bc",      length: 1, cycles: [8]),
  Opcode(addr: "0xa",     type: .ld_a_pBC_0a,       debug: "ld_a_pBC",       length: 1, cycles: [8]),
  Opcode(addr: "0xb",     type: .dec_bc_0b,         debug: "dec_bc",         length: 1, cycles: [8]),
  Opcode(addr: "0xc",     type: .inc_c_0c,          debug: "inc_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xd",     type: .dec_c_0d,          debug: "dec_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xe",     type: .ld_c_d8_0e,        debug: "ld_c_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0xf",     type: .rrca_0f,           debug: "rrca",           length: 1, cycles: [4]),
  Opcode(addr: "0x10",    type: .stop_0_10,         debug: "stop_0",         length: 1, cycles: [4]),
  Opcode(addr: "0x11",    type: .ld_de_d16_11,      debug: "ld_de_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x12",    type: .ld_pDE_a_12,       debug: "ld_pDE_a",       length: 1, cycles: [8]),
  Opcode(addr: "0x13",    type: .inc_de_13,         debug: "inc_de",         length: 1, cycles: [8]),
  Opcode(addr: "0x14",    type: .inc_d_14,          debug: "inc_d",          length: 1, cycles: [4]),
  Opcode(addr: "0x15",    type: .dec_d_15,          debug: "dec_d",          length: 1, cycles: [4]),
  Opcode(addr: "0x16",    type: .ld_d_d8_16,        debug: "ld_d_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x17",    type: .rla_17,            debug: "rla",            length: 1, cycles: [4]),
  Opcode(addr: "0x18",    type: .jr_r8_18,          debug: "jr_r8",          length: 2, cycles: [12]),
  Opcode(addr: "0x19",    type: .add_hl_de_19,      debug: "add_hl_de",      length: 1, cycles: [8]),
  Opcode(addr: "0x1a",    type: .ld_a_pDE_1a,       debug: "ld_a_pDE",       length: 1, cycles: [8]),
  Opcode(addr: "0x1b",    type: .dec_de_1b,         debug: "dec_de",         length: 1, cycles: [8]),
  Opcode(addr: "0x1c",    type: .inc_e_1c,          debug: "inc_e",          length: 1, cycles: [4]),
  Opcode(addr: "0x1d",    type: .dec_e_1d,          debug: "dec_e",          length: 1, cycles: [4]),
  Opcode(addr: "0x1e",    type: .ld_e_d8_1e,        debug: "ld_e_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x1f",    type: .rra_1f,            debug: "rra",            length: 1, cycles: [4]),
  Opcode(addr: "0x20",    type: .jr_nz_r8_20,       debug: "jr_nz_r8",       length: 2, cycles: [12, 8]),
  Opcode(addr: "0x21",    type: .ld_hl_d16_21,      debug: "ld_hl_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x22",    type: .ld_pHLI_a_22,      debug: "ld_pHLI_a",      length: 1, cycles: [8]),
  Opcode(addr: "0x23",    type: .inc_hl_23,         debug: "inc_hl",         length: 1, cycles: [8]),
  Opcode(addr: "0x24",    type: .inc_h_24,          debug: "inc_h",          length: 1, cycles: [4]),
  Opcode(addr: "0x25",    type: .dec_h_25,          debug: "dec_h",          length: 1, cycles: [4]),
  Opcode(addr: "0x26",    type: .ld_h_d8_26,        debug: "ld_h_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x27",    type: .daa_27,            debug: "daa",            length: 1, cycles: [4]),
  Opcode(addr: "0x28",    type: .jr_z_r8_28,        debug: "jr_z_r8",        length: 2, cycles: [12, 8]),
  Opcode(addr: "0x29",    type: .add_hl_hl_29,      debug: "add_hl_hl",      length: 1, cycles: [8]),
  Opcode(addr: "0x2a",    type: .ld_a_pHLI_2a,      debug: "ld_a_pHLI",      length: 1, cycles: [8]),
  Opcode(addr: "0x2b",    type: .dec_hl_2b,         debug: "dec_hl",         length: 1, cycles: [8]),
  Opcode(addr: "0x2c",    type: .inc_l_2c,          debug: "inc_l",          length: 1, cycles: [4]),
  Opcode(addr: "0x2d",    type: .dec_l_2d,          debug: "dec_l",          length: 1, cycles: [4]),
  Opcode(addr: "0x2e",    type: .ld_l_d8_2e,        debug: "ld_l_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x2f",    type: .cpl_2f,            debug: "cpl",            length: 1, cycles: [4]),
  Opcode(addr: "0x30",    type: .jr_nc_r8_30,       debug: "jr_nc_r8",       length: 2, cycles: [12, 8]),
  Opcode(addr: "0x31",    type: .ld_sp_d16_31,      debug: "ld_sp_d16",      length: 3, cycles: [12]),
  Opcode(addr: "0x32",    type: .ld_pHLD_a_32,      debug: "ld_pHLD_a",      length: 1, cycles: [8]),
  Opcode(addr: "0x33",    type: .inc_sp_33,         debug: "inc_sp",         length: 1, cycles: [8]),
  Opcode(addr: "0x34",    type: .inc_pHL_34,        debug: "inc_pHL",        length: 1, cycles: [12]),
  Opcode(addr: "0x35",    type: .dec_pHL_35,        debug: "dec_pHL",        length: 1, cycles: [12]),
  Opcode(addr: "0x36",    type: .ld_pHL_d8_36,      debug: "ld_pHL_d8",      length: 2, cycles: [12]),
  Opcode(addr: "0x37",    type: .scf_37,            debug: "scf",            length: 1, cycles: [4]),
  Opcode(addr: "0x38",    type: .jr_c_r8_38,        debug: "jr_c_r8",        length: 2, cycles: [12, 8]),
  Opcode(addr: "0x39",    type: .add_hl_sp_39,      debug: "add_hl_sp",      length: 1, cycles: [8]),
  Opcode(addr: "0x3a",    type: .ld_a_pHLD_3a,      debug: "ld_a_pHLD",      length: 1, cycles: [8]),
  Opcode(addr: "0x3b",    type: .dec_sp_3b,         debug: "dec_sp",         length: 1, cycles: [8]),
  Opcode(addr: "0x3c",    type: .inc_a_3c,          debug: "inc_a",          length: 1, cycles: [4]),
  Opcode(addr: "0x3d",    type: .dec_a_3d,          debug: "dec_a",          length: 1, cycles: [4]),
  Opcode(addr: "0x3e",    type: .ld_a_d8_3e,        debug: "ld_a_d8",        length: 2, cycles: [8]),
  Opcode(addr: "0x3f",    type: .ccf_3f,            debug: "ccf",            length: 1, cycles: [4]),
  Opcode(addr: "0x40",    type: .ld_b_b_40,         debug: "ld_b_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x41",    type: .ld_b_c_41,         debug: "ld_b_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x42",    type: .ld_b_d_42,         debug: "ld_b_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x43",    type: .ld_b_e_43,         debug: "ld_b_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x44",    type: .ld_b_h_44,         debug: "ld_b_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x45",    type: .ld_b_l_45,         debug: "ld_b_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x46",    type: .ld_b_pHL_46,       debug: "ld_b_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x47",    type: .ld_b_a_47,         debug: "ld_b_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x48",    type: .ld_c_b_48,         debug: "ld_c_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x49",    type: .ld_c_c_49,         debug: "ld_c_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x4a",    type: .ld_c_d_4a,         debug: "ld_c_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x4b",    type: .ld_c_e_4b,         debug: "ld_c_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x4c",    type: .ld_c_h_4c,         debug: "ld_c_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x4d",    type: .ld_c_l_4d,         debug: "ld_c_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x4e",    type: .ld_c_pHL_4e,       debug: "ld_c_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x4f",    type: .ld_c_a_4f,         debug: "ld_c_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x50",    type: .ld_d_b_50,         debug: "ld_d_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x51",    type: .ld_d_c_51,         debug: "ld_d_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x52",    type: .ld_d_d_52,         debug: "ld_d_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x53",    type: .ld_d_e_53,         debug: "ld_d_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x54",    type: .ld_d_h_54,         debug: "ld_d_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x55",    type: .ld_d_l_55,         debug: "ld_d_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x56",    type: .ld_d_pHL_56,       debug: "ld_d_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x57",    type: .ld_d_a_57,         debug: "ld_d_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x58",    type: .ld_e_b_58,         debug: "ld_e_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x59",    type: .ld_e_c_59,         debug: "ld_e_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x5a",    type: .ld_e_d_5a,         debug: "ld_e_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x5b",    type: .ld_e_e_5b,         debug: "ld_e_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x5c",    type: .ld_e_h_5c,         debug: "ld_e_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x5d",    type: .ld_e_l_5d,         debug: "ld_e_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x5e",    type: .ld_e_pHL_5e,       debug: "ld_e_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x5f",    type: .ld_e_a_5f,         debug: "ld_e_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x60",    type: .ld_h_b_60,         debug: "ld_h_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x61",    type: .ld_h_c_61,         debug: "ld_h_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x62",    type: .ld_h_d_62,         debug: "ld_h_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x63",    type: .ld_h_e_63,         debug: "ld_h_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x64",    type: .ld_h_h_64,         debug: "ld_h_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x65",    type: .ld_h_l_65,         debug: "ld_h_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x66",    type: .ld_h_pHL_66,       debug: "ld_h_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x67",    type: .ld_h_a_67,         debug: "ld_h_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x68",    type: .ld_l_b_68,         debug: "ld_l_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x69",    type: .ld_l_c_69,         debug: "ld_l_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x6a",    type: .ld_l_d_6a,         debug: "ld_l_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x6b",    type: .ld_l_e_6b,         debug: "ld_l_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x6c",    type: .ld_l_h_6c,         debug: "ld_l_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x6d",    type: .ld_l_l_6d,         debug: "ld_l_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x6e",    type: .ld_l_pHL_6e,       debug: "ld_l_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x6f",    type: .ld_l_a_6f,         debug: "ld_l_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x70",    type: .ld_pHL_b_70,       debug: "ld_pHL_b",       length: 1, cycles: [8]),
  Opcode(addr: "0x71",    type: .ld_pHL_c_71,       debug: "ld_pHL_c",       length: 1, cycles: [8]),
  Opcode(addr: "0x72",    type: .ld_pHL_d_72,       debug: "ld_pHL_d",       length: 1, cycles: [8]),
  Opcode(addr: "0x73",    type: .ld_pHL_e_73,       debug: "ld_pHL_e",       length: 1, cycles: [8]),
  Opcode(addr: "0x74",    type: .ld_pHL_h_74,       debug: "ld_pHL_h",       length: 1, cycles: [8]),
  Opcode(addr: "0x75",    type: .ld_pHL_l_75,       debug: "ld_pHL_l",       length: 1, cycles: [8]),
  Opcode(addr: "0x76",    type: .halt_76,           debug: "halt",           length: 1, cycles: [4]),
  Opcode(addr: "0x77",    type: .ld_pHL_a_77,       debug: "ld_pHL_a",       length: 1, cycles: [8]),
  Opcode(addr: "0x78",    type: .ld_a_b_78,         debug: "ld_a_b",         length: 1, cycles: [4]),
  Opcode(addr: "0x79",    type: .ld_a_c_79,         debug: "ld_a_c",         length: 1, cycles: [4]),
  Opcode(addr: "0x7a",    type: .ld_a_d_7a,         debug: "ld_a_d",         length: 1, cycles: [4]),
  Opcode(addr: "0x7b",    type: .ld_a_e_7b,         debug: "ld_a_e",         length: 1, cycles: [4]),
  Opcode(addr: "0x7c",    type: .ld_a_h_7c,         debug: "ld_a_h",         length: 1, cycles: [4]),
  Opcode(addr: "0x7d",    type: .ld_a_l_7d,         debug: "ld_a_l",         length: 1, cycles: [4]),
  Opcode(addr: "0x7e",    type: .ld_a_pHL_7e,       debug: "ld_a_pHL",       length: 1, cycles: [8]),
  Opcode(addr: "0x7f",    type: .ld_a_a_7f,         debug: "ld_a_a",         length: 1, cycles: [4]),
  Opcode(addr: "0x80",    type: .add_a_b_80,        debug: "add_a_b",        length: 1, cycles: [4]),
  Opcode(addr: "0x81",    type: .add_a_c_81,        debug: "add_a_c",        length: 1, cycles: [4]),
  Opcode(addr: "0x82",    type: .add_a_d_82,        debug: "add_a_d",        length: 1, cycles: [4]),
  Opcode(addr: "0x83",    type: .add_a_e_83,        debug: "add_a_e",        length: 1, cycles: [4]),
  Opcode(addr: "0x84",    type: .add_a_h_84,        debug: "add_a_h",        length: 1, cycles: [4]),
  Opcode(addr: "0x85",    type: .add_a_l_85,        debug: "add_a_l",        length: 1, cycles: [4]),
  Opcode(addr: "0x86",    type: .add_a_pHL_86,      debug: "add_a_pHL",      length: 1, cycles: [8]),
  Opcode(addr: "0x87",    type: .add_a_a_87,        debug: "add_a_a",        length: 1, cycles: [4]),
  Opcode(addr: "0x88",    type: .adc_a_b_88,        debug: "adc_a_b",        length: 1, cycles: [4]),
  Opcode(addr: "0x89",    type: .adc_a_c_89,        debug: "adc_a_c",        length: 1, cycles: [4]),
  Opcode(addr: "0x8a",    type: .adc_a_d_8a,        debug: "adc_a_d",        length: 1, cycles: [4]),
  Opcode(addr: "0x8b",    type: .adc_a_e_8b,        debug: "adc_a_e",        length: 1, cycles: [4]),
  Opcode(addr: "0x8c",    type: .adc_a_h_8c,        debug: "adc_a_h",        length: 1, cycles: [4]),
  Opcode(addr: "0x8d",    type: .adc_a_l_8d,        debug: "adc_a_l",        length: 1, cycles: [4]),
  Opcode(addr: "0x8e",    type: .adc_a_pHL_8e,      debug: "adc_a_pHL",      length: 1, cycles: [8]),
  Opcode(addr: "0x8f",    type: .adc_a_a_8f,        debug: "adc_a_a",        length: 1, cycles: [4]),
  Opcode(addr: "0x90",    type: .sub_b_90,          debug: "sub_b",          length: 1, cycles: [4]),
  Opcode(addr: "0x91",    type: .sub_c_91,          debug: "sub_c",          length: 1, cycles: [4]),
  Opcode(addr: "0x92",    type: .sub_d_92,          debug: "sub_d",          length: 1, cycles: [4]),
  Opcode(addr: "0x93",    type: .sub_e_93,          debug: "sub_e",          length: 1, cycles: [4]),
  Opcode(addr: "0x94",    type: .sub_h_94,          debug: "sub_h",          length: 1, cycles: [4]),
  Opcode(addr: "0x95",    type: .sub_l_95,          debug: "sub_l",          length: 1, cycles: [4]),
  Opcode(addr: "0x96",    type: .sub_pHL_96,        debug: "sub_pHL",        length: 1, cycles: [8]),
  Opcode(addr: "0x97",    type: .sub_a_97,          debug: "sub_a",          length: 1, cycles: [4]),
  Opcode(addr: "0x98",    type: .sbc_a_b_98,        debug: "sbc_a_b",        length: 1, cycles: [4]),
  Opcode(addr: "0x99",    type: .sbc_a_c_99,        debug: "sbc_a_c",        length: 1, cycles: [4]),
  Opcode(addr: "0x9a",    type: .sbc_a_d_9a,        debug: "sbc_a_d",        length: 1, cycles: [4]),
  Opcode(addr: "0x9b",    type: .sbc_a_e_9b,        debug: "sbc_a_e",        length: 1, cycles: [4]),
  Opcode(addr: "0x9c",    type: .sbc_a_h_9c,        debug: "sbc_a_h",        length: 1, cycles: [4]),
  Opcode(addr: "0x9d",    type: .sbc_a_l_9d,        debug: "sbc_a_l",        length: 1, cycles: [4]),
  Opcode(addr: "0x9e",    type: .sbc_a_pHL_9e,      debug: "sbc_a_pHL",      length: 1, cycles: [8]),
  Opcode(addr: "0x9f",    type: .sbc_a_a_9f,        debug: "sbc_a_a",        length: 1, cycles: [4]),
  Opcode(addr: "0xa0",    type: .and_b_a0,          debug: "and_b",          length: 1, cycles: [4]),
  Opcode(addr: "0xa1",    type: .and_c_a1,          debug: "and_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xa2",    type: .and_d_a2,          debug: "and_d",          length: 1, cycles: [4]),
  Opcode(addr: "0xa3",    type: .and_e_a3,          debug: "and_e",          length: 1, cycles: [4]),
  Opcode(addr: "0xa4",    type: .and_h_a4,          debug: "and_h",          length: 1, cycles: [4]),
  Opcode(addr: "0xa5",    type: .and_l_a5,          debug: "and_l",          length: 1, cycles: [4]),
  Opcode(addr: "0xa6",    type: .and_pHL_a6,        debug: "and_pHL",        length: 1, cycles: [8]),
  Opcode(addr: "0xa7",    type: .and_a_a7,          debug: "and_a",          length: 1, cycles: [4]),
  Opcode(addr: "0xa8",    type: .xor_b_a8,          debug: "xor_b",          length: 1, cycles: [4]),
  Opcode(addr: "0xa9",    type: .xor_c_a9,          debug: "xor_c",          length: 1, cycles: [4]),
  Opcode(addr: "0xaa",    type: .xor_d_aa,          debug: "xor_d",          length: 1, cycles: [4]),
  Opcode(addr: "0xab",    type: .xor_e_ab,          debug: "xor_e",          length: 1, cycles: [4]),
  Opcode(addr: "0xac",    type: .xor_h_ac,          debug: "xor_h",          length: 1, cycles: [4]),
  Opcode(addr: "0xad",    type: .xor_l_ad,          debug: "xor_l",          length: 1, cycles: [4]),
  Opcode(addr: "0xae",    type: .xor_pHL_ae,        debug: "xor_pHL",        length: 1, cycles: [8]),
  Opcode(addr: "0xaf",    type: .xor_a_af,          debug: "xor_a",          length: 1, cycles: [4]),
  Opcode(addr: "0xb0",    type: .or_b_b0,           debug: "or_b",           length: 1, cycles: [4]),
  Opcode(addr: "0xb1",    type: .or_c_b1,           debug: "or_c",           length: 1, cycles: [4]),
  Opcode(addr: "0xb2",    type: .or_d_b2,           debug: "or_d",           length: 1, cycles: [4]),
  Opcode(addr: "0xb3",    type: .or_e_b3,           debug: "or_e",           length: 1, cycles: [4]),
  Opcode(addr: "0xb4",    type: .or_h_b4,           debug: "or_h",           length: 1, cycles: [4]),
  Opcode(addr: "0xb5",    type: .or_l_b5,           debug: "or_l",           length: 1, cycles: [4]),
  Opcode(addr: "0xb6",    type: .or_pHL_b6,         debug: "or_pHL",         length: 1, cycles: [8]),
  Opcode(addr: "0xb7",    type: .or_a_b7,           debug: "or_a",           length: 1, cycles: [4]),
  Opcode(addr: "0xb8",    type: .cp_b_b8,           debug: "cp_b",           length: 1, cycles: [4]),
  Opcode(addr: "0xb9",    type: .cp_c_b9,           debug: "cp_c",           length: 1, cycles: [4]),
  Opcode(addr: "0xba",    type: .cp_d_ba,           debug: "cp_d",           length: 1, cycles: [4]),
  Opcode(addr: "0xbb",    type: .cp_e_bb,           debug: "cp_e",           length: 1, cycles: [4]),
  Opcode(addr: "0xbc",    type: .cp_h_bc,           debug: "cp_h",           length: 1, cycles: [4]),
  Opcode(addr: "0xbd",    type: .cp_l_bd,           debug: "cp_l",           length: 1, cycles: [4]),
  Opcode(addr: "0xbe",    type: .cp_pHL_be,         debug: "cp_pHL",         length: 1, cycles: [8]),
  Opcode(addr: "0xbf",    type: .cp_a_bf,           debug: "cp_a",           length: 1, cycles: [4]),
  Opcode(addr: "0xc0",    type: .ret_nz_c0,         debug: "ret_nz",         length: 1, cycles: [20, 8]),
  Opcode(addr: "0xc1",    type: .pop_bc_c1,         debug: "pop_bc",         length: 1, cycles: [12]),
  Opcode(addr: "0xc2",    type: .jp_nz_a16_c2,      debug: "jp_nz_a16",      length: 3, cycles: [16, 12]),
  Opcode(addr: "0xc3",    type: .jp_a16_c3,         debug: "jp_a16",         length: 3, cycles: [16]),
  Opcode(addr: "0xc4",    type: .call_nz_a16_c4,    debug: "call_nz_a16",    length: 3, cycles: [24, 12]),
  Opcode(addr: "0xc5",    type: .push_bc_c5,        debug: "push_bc",        length: 1, cycles: [16]),
  Opcode(addr: "0xc6",    type: .add_a_d8_c6,       debug: "add_a_d8",       length: 2, cycles: [8]),
  Opcode(addr: "0xc7",    type: .rst_00h_c7,        debug: "rst_00h",        length: 1, cycles: [16]),
  Opcode(addr: "0xc8",    type: .ret_z_c8,          debug: "ret_z",          length: 1, cycles: [20, 8]),
  Opcode(addr: "0xc9",    type: .ret_c9,            debug: "ret",            length: 1, cycles: [16]),
  Opcode(addr: "0xca",    type: .jp_z_a16_ca,       debug: "jp_z_a16",       length: 3, cycles: [16, 12]),
  Opcode(addr: "0xcb",    type: .prefix_cb_cb,      debug: "prefix_cb",      length: 1, cycles: [4]),
  Opcode(addr: "0xcc",    type: .call_z_a16_cc,     debug: "call_z_a16",     length: 3, cycles: [24, 12]),
  Opcode(addr: "0xcd",    type: .call_a16_cd,       debug: "call_a16",       length: 3, cycles: [24]),
  Opcode(addr: "0xce",    type: .adc_a_d8_ce,       debug: "adc_a_d8",       length: 2, cycles: [8]),
  Opcode(addr: "0xcf",    type: .rst_08h_cf,        debug: "rst_08h",        length: 1, cycles: [16]),
  Opcode(addr: "0xd0",    type: .ret_nc_d0,         debug: "ret_nc",         length: 1, cycles: [20, 8]),
  Opcode(addr: "0xd1",    type: .pop_de_d1,         debug: "pop_de",         length: 1, cycles: [12]),
  Opcode(addr: "0xd2",    type: .jp_nc_a16_d2,      debug: "jp_nc_a16",      length: 3, cycles: [16, 12]),
  Opcode(addr: "0xd4",    type: .call_nc_a16_d4,    debug: "call_nc_a16",    length: 3, cycles: [24, 12]),
  Opcode(addr: "0xd5",    type: .push_de_d5,        debug: "push_de",        length: 1, cycles: [16]),
  Opcode(addr: "0xd6",    type: .sub_d8_d6,         debug: "sub_d8",         length: 2, cycles: [8]),
  Opcode(addr: "0xd7",    type: .rst_10h_d7,        debug: "rst_10h",        length: 1, cycles: [16]),
  Opcode(addr: "0xd8",    type: .ret_c_d8,          debug: "ret_c",          length: 1, cycles: [20, 8]),
  Opcode(addr: "0xd9",    type: .reti_d9,           debug: "reti",           length: 1, cycles: [16]),
  Opcode(addr: "0xda",    type: .jp_c_a16_da,       debug: "jp_c_a16",       length: 3, cycles: [16, 12]),
  Opcode(addr: "0xdc",    type: .call_c_a16_dc,     debug: "call_c_a16",     length: 3, cycles: [24, 12]),
  Opcode(addr: "0xde",    type: .sbc_a_d8_de,       debug: "sbc_a_d8",       length: 2, cycles: [8]),
  Opcode(addr: "0xdf",    type: .rst_18h_df,        debug: "rst_18h",        length: 1, cycles: [16]),
  Opcode(addr: "0xe0",    type: .ldh_pA8_a_e0,      debug: "ldh_pA8_a",      length: 2, cycles: [12]),
  Opcode(addr: "0xe1",    type: .pop_hl_e1,         debug: "pop_hl",         length: 1, cycles: [12]),
  Opcode(addr: "0xe2",    type: .ld_pC_a_e2,        debug: "ld_pC_a",        length: 1, cycles: [8]),
  Opcode(addr: "0xe5",    type: .push_hl_e5,        debug: "push_hl",        length: 1, cycles: [16]),
  Opcode(addr: "0xe6",    type: .and_d8_e6,         debug: "and_d8",         length: 2, cycles: [8]),
  Opcode(addr: "0xe7",    type: .rst_20h_e7,        debug: "rst_20h",        length: 1, cycles: [16]),
  Opcode(addr: "0xe8",    type: .add_sp_r8_e8,      debug: "add_sp_r8",      length: 2, cycles: [16]),
  Opcode(addr: "0xe9",    type: .jp_pHL_e9,         debug: "jp_pHL",         length: 1, cycles: [4]),
  Opcode(addr: "0xea",    type: .ld_pA16_a_ea,      debug: "ld_pA16_a",      length: 3, cycles: [16]),
  Opcode(addr: "0xee",    type: .xor_d8_ee,         debug: "xor_d8",         length: 2, cycles: [8]),
  Opcode(addr: "0xef",    type: .rst_28h_ef,        debug: "rst_28h",        length: 1, cycles: [16]),
  Opcode(addr: "0xf0",    type: .ldh_a_pA8_f0,      debug: "ldh_a_pA8",      length: 2, cycles: [12]),
  Opcode(addr: "0xf1",    type: .pop_af_f1,         debug: "pop_af",         length: 1, cycles: [12]),
  Opcode(addr: "0xf2",    type: .ld_a_pC_f2,        debug: "ld_a_pC",        length: 1, cycles: [8]),
  Opcode(addr: "0xf3",    type: .di_f3,             debug: "di",             length: 1, cycles: [4]),
  Opcode(addr: "0xf5",    type: .push_af_f5,        debug: "push_af",        length: 1, cycles: [16]),
  Opcode(addr: "0xf6",    type: .or_d8_f6,          debug: "or_d8",          length: 2, cycles: [8]),
  Opcode(addr: "0xf7",    type: .rst_30h_f7,        debug: "rst_30h",        length: 1, cycles: [16]),
  Opcode(addr: "0xf8",    type: .ld_hl_spR8_f8,     debug: "ld_hl_spR8",     length: 2, cycles: [12]),
  Opcode(addr: "0xf9",    type: .ld_sp_hl_f9,       debug: "ld_sp_hl",       length: 1, cycles: [8]),
  Opcode(addr: "0xfa",    type: .ld_a_pA16_fa,      debug: "ld_a_pA16",      length: 3, cycles: [16]),
  Opcode(addr: "0xfb",    type: .ei_fb,             debug: "ei",             length: 1, cycles: [4]),
  Opcode(addr: "0xfe",    type: .cp_d8_fe,          debug: "cp_d8",          length: 2, cycles: [8]),
  Opcode(addr: "0xff",    type: .rst_38h_ff,        debug: "rst_38h",        length: 1, cycles: [16]),
]

