// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable trailing_comma
// swiftlint:disable file_length

enum PrefixOpcodeType {
  case rlc_b_00
  case rlc_c_01
  case rlc_d_02
  case rlc_e_03
  case rlc_h_04
  case rlc_l_05
  case rlc_pHL_06
  case rlc_a_07
  case rrc_b_08
  case rrc_c_09
  case rrc_d_0a
  case rrc_e_0b
  case rrc_h_0c
  case rrc_l_0d
  case rrc_pHL_0e
  case rrc_a_0f
  case rl_b_10
  case rl_c_11
  case rl_d_12
  case rl_e_13
  case rl_h_14
  case rl_l_15
  case rl_pHL_16
  case rl_a_17
  case rr_b_18
  case rr_c_19
  case rr_d_1a
  case rr_e_1b
  case rr_h_1c
  case rr_l_1d
  case rr_pHL_1e
  case rr_a_1f
  case sla_b_20
  case sla_c_21
  case sla_d_22
  case sla_e_23
  case sla_h_24
  case sla_l_25
  case sla_pHL_26
  case sla_a_27
  case sra_b_28
  case sra_c_29
  case sra_d_2a
  case sra_e_2b
  case sra_h_2c
  case sra_l_2d
  case sra_pHL_2e
  case sra_a_2f
  case swap_b_30
  case swap_c_31
  case swap_d_32
  case swap_e_33
  case swap_h_34
  case swap_l_35
  case swap_pHL_36
  case swap_a_37
  case srl_b_38
  case srl_c_39
  case srl_d_3a
  case srl_e_3b
  case srl_h_3c
  case srl_l_3d
  case srl_pHL_3e
  case srl_a_3f
  case bit_0_b_40
  case bit_0_c_41
  case bit_0_d_42
  case bit_0_e_43
  case bit_0_h_44
  case bit_0_l_45
  case bit_0_pHL_46
  case bit_0_a_47
  case bit_1_b_48
  case bit_1_c_49
  case bit_1_d_4a
  case bit_1_e_4b
  case bit_1_h_4c
  case bit_1_l_4d
  case bit_1_pHL_4e
  case bit_1_a_4f
  case bit_2_b_50
  case bit_2_c_51
  case bit_2_d_52
  case bit_2_e_53
  case bit_2_h_54
  case bit_2_l_55
  case bit_2_pHL_56
  case bit_2_a_57
  case bit_3_b_58
  case bit_3_c_59
  case bit_3_d_5a
  case bit_3_e_5b
  case bit_3_h_5c
  case bit_3_l_5d
  case bit_3_pHL_5e
  case bit_3_a_5f
  case bit_4_b_60
  case bit_4_c_61
  case bit_4_d_62
  case bit_4_e_63
  case bit_4_h_64
  case bit_4_l_65
  case bit_4_pHL_66
  case bit_4_a_67
  case bit_5_b_68
  case bit_5_c_69
  case bit_5_d_6a
  case bit_5_e_6b
  case bit_5_h_6c
  case bit_5_l_6d
  case bit_5_pHL_6e
  case bit_5_a_6f
  case bit_6_b_70
  case bit_6_c_71
  case bit_6_d_72
  case bit_6_e_73
  case bit_6_h_74
  case bit_6_l_75
  case bit_6_pHL_76
  case bit_6_a_77
  case bit_7_b_78
  case bit_7_c_79
  case bit_7_d_7a
  case bit_7_e_7b
  case bit_7_h_7c
  case bit_7_l_7d
  case bit_7_pHL_7e
  case bit_7_a_7f
  case res_0_b_80
  case res_0_c_81
  case res_0_d_82
  case res_0_e_83
  case res_0_h_84
  case res_0_l_85
  case res_0_pHL_86
  case res_0_a_87
  case res_1_b_88
  case res_1_c_89
  case res_1_d_8a
  case res_1_e_8b
  case res_1_h_8c
  case res_1_l_8d
  case res_1_pHL_8e
  case res_1_a_8f
  case res_2_b_90
  case res_2_c_91
  case res_2_d_92
  case res_2_e_93
  case res_2_h_94
  case res_2_l_95
  case res_2_pHL_96
  case res_2_a_97
  case res_3_b_98
  case res_3_c_99
  case res_3_d_9a
  case res_3_e_9b
  case res_3_h_9c
  case res_3_l_9d
  case res_3_pHL_9e
  case res_3_a_9f
  case res_4_b_a0
  case res_4_c_a1
  case res_4_d_a2
  case res_4_e_a3
  case res_4_h_a4
  case res_4_l_a5
  case res_4_pHL_a6
  case res_4_a_a7
  case res_5_b_a8
  case res_5_c_a9
  case res_5_d_aa
  case res_5_e_ab
  case res_5_h_ac
  case res_5_l_ad
  case res_5_pHL_ae
  case res_5_a_af
  case res_6_b_b0
  case res_6_c_b1
  case res_6_d_b2
  case res_6_e_b3
  case res_6_h_b4
  case res_6_l_b5
  case res_6_pHL_b6
  case res_6_a_b7
  case res_7_b_b8
  case res_7_c_b9
  case res_7_d_ba
  case res_7_e_bb
  case res_7_h_bc
  case res_7_l_bd
  case res_7_pHL_be
  case res_7_a_bf
  case set_0_b_c0
  case set_0_c_c1
  case set_0_d_c2
  case set_0_e_c3
  case set_0_h_c4
  case set_0_l_c5
  case set_0_pHL_c6
  case set_0_a_c7
  case set_1_b_c8
  case set_1_c_c9
  case set_1_d_ca
  case set_1_e_cb
  case set_1_h_cc
  case set_1_l_cd
  case set_1_pHL_ce
  case set_1_a_cf
  case set_2_b_d0
  case set_2_c_d1
  case set_2_d_d2
  case set_2_e_d3
  case set_2_h_d4
  case set_2_l_d5
  case set_2_pHL_d6
  case set_2_a_d7
  case set_3_b_d8
  case set_3_c_d9
  case set_3_d_da
  case set_3_e_db
  case set_3_h_dc
  case set_3_l_dd
  case set_3_pHL_de
  case set_3_a_df
  case set_4_b_e0
  case set_4_c_e1
  case set_4_d_e2
  case set_4_e_e3
  case set_4_h_e4
  case set_4_l_e5
  case set_4_pHL_e6
  case set_4_a_e7
  case set_5_b_e8
  case set_5_c_e9
  case set_5_d_ea
  case set_5_e_eb
  case set_5_h_ec
  case set_5_l_ed
  case set_5_pHL_ee
  case set_5_a_ef
  case set_6_b_f0
  case set_6_c_f1
  case set_6_d_f2
  case set_6_e_f3
  case set_6_h_f4
  case set_6_l_f5
  case set_6_pHL_f6
  case set_6_a_f7
  case set_7_b_f8
  case set_7_c_f9
  case set_7_d_fa
  case set_7_e_fb
  case set_7_h_fc
  case set_7_l_fd
  case set_7_pHL_fe
  case set_7_a_ff
}

let prefixOpcodes: [PrefixOpcode] = [
  PrefixOpcode(addr: "0x0",     type: .rlc_b_00,          debug: "rlc_b",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x1",     type: .rlc_c_01,          debug: "rlc_c",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x2",     type: .rlc_d_02,          debug: "rlc_d",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x3",     type: .rlc_e_03,          debug: "rlc_e",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x4",     type: .rlc_h_04,          debug: "rlc_h",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x5",     type: .rlc_l_05,          debug: "rlc_l",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x6",     type: .rlc_pHL_06,        debug: "rlc_pHL",        length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x7",     type: .rlc_a_07,          debug: "rlc_a",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x8",     type: .rrc_b_08,          debug: "rrc_b",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x9",     type: .rrc_c_09,          debug: "rrc_c",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa",     type: .rrc_d_0a,          debug: "rrc_d",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb",     type: .rrc_e_0b,          debug: "rrc_e",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc",     type: .rrc_h_0c,          debug: "rrc_h",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd",     type: .rrc_l_0d,          debug: "rrc_l",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe",     type: .rrc_pHL_0e,        debug: "rrc_pHL",        length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xf",     type: .rrc_a_0f,          debug: "rrc_a",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x10",    type: .rl_b_10,           debug: "rl_b",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x11",    type: .rl_c_11,           debug: "rl_c",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x12",    type: .rl_d_12,           debug: "rl_d",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x13",    type: .rl_e_13,           debug: "rl_e",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x14",    type: .rl_h_14,           debug: "rl_h",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x15",    type: .rl_l_15,           debug: "rl_l",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x16",    type: .rl_pHL_16,         debug: "rl_pHL",         length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x17",    type: .rl_a_17,           debug: "rl_a",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x18",    type: .rr_b_18,           debug: "rr_b",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x19",    type: .rr_c_19,           debug: "rr_c",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x1a",    type: .rr_d_1a,           debug: "rr_d",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x1b",    type: .rr_e_1b,           debug: "rr_e",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x1c",    type: .rr_h_1c,           debug: "rr_h",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x1d",    type: .rr_l_1d,           debug: "rr_l",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x1e",    type: .rr_pHL_1e,         debug: "rr_pHL",         length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x1f",    type: .rr_a_1f,           debug: "rr_a",           length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x20",    type: .sla_b_20,          debug: "sla_b",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x21",    type: .sla_c_21,          debug: "sla_c",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x22",    type: .sla_d_22,          debug: "sla_d",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x23",    type: .sla_e_23,          debug: "sla_e",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x24",    type: .sla_h_24,          debug: "sla_h",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x25",    type: .sla_l_25,          debug: "sla_l",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x26",    type: .sla_pHL_26,        debug: "sla_pHL",        length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x27",    type: .sla_a_27,          debug: "sla_a",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x28",    type: .sra_b_28,          debug: "sra_b",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x29",    type: .sra_c_29,          debug: "sra_c",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x2a",    type: .sra_d_2a,          debug: "sra_d",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x2b",    type: .sra_e_2b,          debug: "sra_e",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x2c",    type: .sra_h_2c,          debug: "sra_h",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x2d",    type: .sra_l_2d,          debug: "sra_l",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x2e",    type: .sra_pHL_2e,        debug: "sra_pHL",        length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x2f",    type: .sra_a_2f,          debug: "sra_a",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x30",    type: .swap_b_30,         debug: "swap_b",         length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x31",    type: .swap_c_31,         debug: "swap_c",         length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x32",    type: .swap_d_32,         debug: "swap_d",         length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x33",    type: .swap_e_33,         debug: "swap_e",         length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x34",    type: .swap_h_34,         debug: "swap_h",         length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x35",    type: .swap_l_35,         debug: "swap_l",         length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x36",    type: .swap_pHL_36,       debug: "swap_pHL",       length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x37",    type: .swap_a_37,         debug: "swap_a",         length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x38",    type: .srl_b_38,          debug: "srl_b",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x39",    type: .srl_c_39,          debug: "srl_c",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x3a",    type: .srl_d_3a,          debug: "srl_d",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x3b",    type: .srl_e_3b,          debug: "srl_e",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x3c",    type: .srl_h_3c,          debug: "srl_h",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x3d",    type: .srl_l_3d,          debug: "srl_l",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x3e",    type: .srl_pHL_3e,        debug: "srl_pHL",        length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x3f",    type: .srl_a_3f,          debug: "srl_a",          length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x40",    type: .bit_0_b_40,        debug: "bit_0_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x41",    type: .bit_0_c_41,        debug: "bit_0_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x42",    type: .bit_0_d_42,        debug: "bit_0_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x43",    type: .bit_0_e_43,        debug: "bit_0_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x44",    type: .bit_0_h_44,        debug: "bit_0_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x45",    type: .bit_0_l_45,        debug: "bit_0_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x46",    type: .bit_0_pHL_46,      debug: "bit_0_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x47",    type: .bit_0_a_47,        debug: "bit_0_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x48",    type: .bit_1_b_48,        debug: "bit_1_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x49",    type: .bit_1_c_49,        debug: "bit_1_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x4a",    type: .bit_1_d_4a,        debug: "bit_1_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x4b",    type: .bit_1_e_4b,        debug: "bit_1_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x4c",    type: .bit_1_h_4c,        debug: "bit_1_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x4d",    type: .bit_1_l_4d,        debug: "bit_1_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x4e",    type: .bit_1_pHL_4e,      debug: "bit_1_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x4f",    type: .bit_1_a_4f,        debug: "bit_1_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x50",    type: .bit_2_b_50,        debug: "bit_2_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x51",    type: .bit_2_c_51,        debug: "bit_2_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x52",    type: .bit_2_d_52,        debug: "bit_2_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x53",    type: .bit_2_e_53,        debug: "bit_2_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x54",    type: .bit_2_h_54,        debug: "bit_2_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x55",    type: .bit_2_l_55,        debug: "bit_2_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x56",    type: .bit_2_pHL_56,      debug: "bit_2_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x57",    type: .bit_2_a_57,        debug: "bit_2_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x58",    type: .bit_3_b_58,        debug: "bit_3_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x59",    type: .bit_3_c_59,        debug: "bit_3_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x5a",    type: .bit_3_d_5a,        debug: "bit_3_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x5b",    type: .bit_3_e_5b,        debug: "bit_3_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x5c",    type: .bit_3_h_5c,        debug: "bit_3_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x5d",    type: .bit_3_l_5d,        debug: "bit_3_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x5e",    type: .bit_3_pHL_5e,      debug: "bit_3_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x5f",    type: .bit_3_a_5f,        debug: "bit_3_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x60",    type: .bit_4_b_60,        debug: "bit_4_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x61",    type: .bit_4_c_61,        debug: "bit_4_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x62",    type: .bit_4_d_62,        debug: "bit_4_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x63",    type: .bit_4_e_63,        debug: "bit_4_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x64",    type: .bit_4_h_64,        debug: "bit_4_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x65",    type: .bit_4_l_65,        debug: "bit_4_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x66",    type: .bit_4_pHL_66,      debug: "bit_4_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x67",    type: .bit_4_a_67,        debug: "bit_4_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x68",    type: .bit_5_b_68,        debug: "bit_5_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x69",    type: .bit_5_c_69,        debug: "bit_5_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x6a",    type: .bit_5_d_6a,        debug: "bit_5_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x6b",    type: .bit_5_e_6b,        debug: "bit_5_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x6c",    type: .bit_5_h_6c,        debug: "bit_5_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x6d",    type: .bit_5_l_6d,        debug: "bit_5_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x6e",    type: .bit_5_pHL_6e,      debug: "bit_5_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x6f",    type: .bit_5_a_6f,        debug: "bit_5_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x70",    type: .bit_6_b_70,        debug: "bit_6_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x71",    type: .bit_6_c_71,        debug: "bit_6_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x72",    type: .bit_6_d_72,        debug: "bit_6_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x73",    type: .bit_6_e_73,        debug: "bit_6_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x74",    type: .bit_6_h_74,        debug: "bit_6_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x75",    type: .bit_6_l_75,        debug: "bit_6_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x76",    type: .bit_6_pHL_76,      debug: "bit_6_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x77",    type: .bit_6_a_77,        debug: "bit_6_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x78",    type: .bit_7_b_78,        debug: "bit_7_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x79",    type: .bit_7_c_79,        debug: "bit_7_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x7a",    type: .bit_7_d_7a,        debug: "bit_7_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x7b",    type: .bit_7_e_7b,        debug: "bit_7_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x7c",    type: .bit_7_h_7c,        debug: "bit_7_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x7d",    type: .bit_7_l_7d,        debug: "bit_7_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x7e",    type: .bit_7_pHL_7e,      debug: "bit_7_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x7f",    type: .bit_7_a_7f,        debug: "bit_7_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x80",    type: .res_0_b_80,        debug: "res_0_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x81",    type: .res_0_c_81,        debug: "res_0_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x82",    type: .res_0_d_82,        debug: "res_0_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x83",    type: .res_0_e_83,        debug: "res_0_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x84",    type: .res_0_h_84,        debug: "res_0_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x85",    type: .res_0_l_85,        debug: "res_0_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x86",    type: .res_0_pHL_86,      debug: "res_0_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x87",    type: .res_0_a_87,        debug: "res_0_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x88",    type: .res_1_b_88,        debug: "res_1_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x89",    type: .res_1_c_89,        debug: "res_1_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x8a",    type: .res_1_d_8a,        debug: "res_1_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x8b",    type: .res_1_e_8b,        debug: "res_1_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x8c",    type: .res_1_h_8c,        debug: "res_1_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x8d",    type: .res_1_l_8d,        debug: "res_1_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x8e",    type: .res_1_pHL_8e,      debug: "res_1_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x8f",    type: .res_1_a_8f,        debug: "res_1_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x90",    type: .res_2_b_90,        debug: "res_2_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x91",    type: .res_2_c_91,        debug: "res_2_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x92",    type: .res_2_d_92,        debug: "res_2_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x93",    type: .res_2_e_93,        debug: "res_2_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x94",    type: .res_2_h_94,        debug: "res_2_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x95",    type: .res_2_l_95,        debug: "res_2_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x96",    type: .res_2_pHL_96,      debug: "res_2_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x97",    type: .res_2_a_97,        debug: "res_2_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x98",    type: .res_3_b_98,        debug: "res_3_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x99",    type: .res_3_c_99,        debug: "res_3_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x9a",    type: .res_3_d_9a,        debug: "res_3_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x9b",    type: .res_3_e_9b,        debug: "res_3_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x9c",    type: .res_3_h_9c,        debug: "res_3_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x9d",    type: .res_3_l_9d,        debug: "res_3_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0x9e",    type: .res_3_pHL_9e,      debug: "res_3_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0x9f",    type: .res_3_a_9f,        debug: "res_3_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa0",    type: .res_4_b_a0,        debug: "res_4_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa1",    type: .res_4_c_a1,        debug: "res_4_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa2",    type: .res_4_d_a2,        debug: "res_4_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa3",    type: .res_4_e_a3,        debug: "res_4_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa4",    type: .res_4_h_a4,        debug: "res_4_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa5",    type: .res_4_l_a5,        debug: "res_4_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa6",    type: .res_4_pHL_a6,      debug: "res_4_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xa7",    type: .res_4_a_a7,        debug: "res_4_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa8",    type: .res_5_b_a8,        debug: "res_5_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xa9",    type: .res_5_c_a9,        debug: "res_5_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xaa",    type: .res_5_d_aa,        debug: "res_5_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xab",    type: .res_5_e_ab,        debug: "res_5_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xac",    type: .res_5_h_ac,        debug: "res_5_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xad",    type: .res_5_l_ad,        debug: "res_5_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xae",    type: .res_5_pHL_ae,      debug: "res_5_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xaf",    type: .res_5_a_af,        debug: "res_5_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb0",    type: .res_6_b_b0,        debug: "res_6_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb1",    type: .res_6_c_b1,        debug: "res_6_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb2",    type: .res_6_d_b2,        debug: "res_6_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb3",    type: .res_6_e_b3,        debug: "res_6_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb4",    type: .res_6_h_b4,        debug: "res_6_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb5",    type: .res_6_l_b5,        debug: "res_6_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb6",    type: .res_6_pHL_b6,      debug: "res_6_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xb7",    type: .res_6_a_b7,        debug: "res_6_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb8",    type: .res_7_b_b8,        debug: "res_7_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xb9",    type: .res_7_c_b9,        debug: "res_7_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xba",    type: .res_7_d_ba,        debug: "res_7_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xbb",    type: .res_7_e_bb,        debug: "res_7_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xbc",    type: .res_7_h_bc,        debug: "res_7_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xbd",    type: .res_7_l_bd,        debug: "res_7_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xbe",    type: .res_7_pHL_be,      debug: "res_7_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xbf",    type: .res_7_a_bf,        debug: "res_7_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc0",    type: .set_0_b_c0,        debug: "set_0_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc1",    type: .set_0_c_c1,        debug: "set_0_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc2",    type: .set_0_d_c2,        debug: "set_0_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc3",    type: .set_0_e_c3,        debug: "set_0_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc4",    type: .set_0_h_c4,        debug: "set_0_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc5",    type: .set_0_l_c5,        debug: "set_0_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc6",    type: .set_0_pHL_c6,      debug: "set_0_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xc7",    type: .set_0_a_c7,        debug: "set_0_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc8",    type: .set_1_b_c8,        debug: "set_1_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xc9",    type: .set_1_c_c9,        debug: "set_1_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xca",    type: .set_1_d_ca,        debug: "set_1_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xcb",    type: .set_1_e_cb,        debug: "set_1_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xcc",    type: .set_1_h_cc,        debug: "set_1_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xcd",    type: .set_1_l_cd,        debug: "set_1_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xce",    type: .set_1_pHL_ce,      debug: "set_1_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xcf",    type: .set_1_a_cf,        debug: "set_1_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd0",    type: .set_2_b_d0,        debug: "set_2_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd1",    type: .set_2_c_d1,        debug: "set_2_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd2",    type: .set_2_d_d2,        debug: "set_2_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd3",    type: .set_2_e_d3,        debug: "set_2_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd4",    type: .set_2_h_d4,        debug: "set_2_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd5",    type: .set_2_l_d5,        debug: "set_2_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd6",    type: .set_2_pHL_d6,      debug: "set_2_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xd7",    type: .set_2_a_d7,        debug: "set_2_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd8",    type: .set_3_b_d8,        debug: "set_3_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xd9",    type: .set_3_c_d9,        debug: "set_3_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xda",    type: .set_3_d_da,        debug: "set_3_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xdb",    type: .set_3_e_db,        debug: "set_3_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xdc",    type: .set_3_h_dc,        debug: "set_3_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xdd",    type: .set_3_l_dd,        debug: "set_3_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xde",    type: .set_3_pHL_de,      debug: "set_3_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xdf",    type: .set_3_a_df,        debug: "set_3_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe0",    type: .set_4_b_e0,        debug: "set_4_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe1",    type: .set_4_c_e1,        debug: "set_4_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe2",    type: .set_4_d_e2,        debug: "set_4_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe3",    type: .set_4_e_e3,        debug: "set_4_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe4",    type: .set_4_h_e4,        debug: "set_4_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe5",    type: .set_4_l_e5,        debug: "set_4_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe6",    type: .set_4_pHL_e6,      debug: "set_4_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xe7",    type: .set_4_a_e7,        debug: "set_4_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe8",    type: .set_5_b_e8,        debug: "set_5_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xe9",    type: .set_5_c_e9,        debug: "set_5_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xea",    type: .set_5_d_ea,        debug: "set_5_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xeb",    type: .set_5_e_eb,        debug: "set_5_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xec",    type: .set_5_h_ec,        debug: "set_5_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xed",    type: .set_5_l_ed,        debug: "set_5_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xee",    type: .set_5_pHL_ee,      debug: "set_5_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xef",    type: .set_5_a_ef,        debug: "set_5_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf0",    type: .set_6_b_f0,        debug: "set_6_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf1",    type: .set_6_c_f1,        debug: "set_6_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf2",    type: .set_6_d_f2,        debug: "set_6_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf3",    type: .set_6_e_f3,        debug: "set_6_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf4",    type: .set_6_h_f4,        debug: "set_6_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf5",    type: .set_6_l_f5,        debug: "set_6_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf6",    type: .set_6_pHL_f6,      debug: "set_6_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xf7",    type: .set_6_a_f7,        debug: "set_6_a",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf8",    type: .set_7_b_f8,        debug: "set_7_b",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xf9",    type: .set_7_c_f9,        debug: "set_7_c",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xfa",    type: .set_7_d_fa,        debug: "set_7_d",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xfb",    type: .set_7_e_fb,        debug: "set_7_e",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xfc",    type: .set_7_h_fc,        debug: "set_7_h",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xfd",    type: .set_7_l_fd,        debug: "set_7_l",        length: 2, cycles: [8]),
  PrefixOpcode(addr: "0xfe",    type: .set_7_pHL_fe,      debug: "set_7_pHL",      length: 2, cycles: [16]),
  PrefixOpcode(addr: "0xff",    type: .set_7_a_ff,        debug: "set_7_a",        length: 2, cycles: [8]),
]

