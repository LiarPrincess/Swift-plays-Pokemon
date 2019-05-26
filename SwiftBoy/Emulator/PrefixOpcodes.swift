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
  PrefixOpcode("0x0", "rlc",       type: .rlc_b_00,              length: 2, cycles: [8]),
  PrefixOpcode("0x1", "rlc",       type: .rlc_c_01,              length: 2, cycles: [8]),
  PrefixOpcode("0x2", "rlc",       type: .rlc_d_02,              length: 2, cycles: [8]),
  PrefixOpcode("0x3", "rlc",       type: .rlc_e_03,              length: 2, cycles: [8]),
  PrefixOpcode("0x4", "rlc",       type: .rlc_h_04,              length: 2, cycles: [8]),
  PrefixOpcode("0x5", "rlc",       type: .rlc_l_05,              length: 2, cycles: [8]),
  PrefixOpcode("0x6", "rlc",       type: .rlc_pHL_06,            length: 2, cycles: [16]),
  PrefixOpcode("0x7", "rlc",       type: .rlc_a_07,              length: 2, cycles: [8]),
  PrefixOpcode("0x8", "rrc",       type: .rrc_b_08,              length: 2, cycles: [8]),
  PrefixOpcode("0x9", "rrc",       type: .rrc_c_09,              length: 2, cycles: [8]),
  PrefixOpcode("0xa", "rrc",       type: .rrc_d_0a,              length: 2, cycles: [8]),
  PrefixOpcode("0xb", "rrc",       type: .rrc_e_0b,              length: 2, cycles: [8]),
  PrefixOpcode("0xc", "rrc",       type: .rrc_h_0c,              length: 2, cycles: [8]),
  PrefixOpcode("0xd", "rrc",       type: .rrc_l_0d,              length: 2, cycles: [8]),
  PrefixOpcode("0xe", "rrc",       type: .rrc_pHL_0e,            length: 2, cycles: [16]),
  PrefixOpcode("0xf", "rrc",       type: .rrc_a_0f,              length: 2, cycles: [8]),
  PrefixOpcode("0x10", "rl",       type: .rl_b_10,               length: 2, cycles: [8]),
  PrefixOpcode("0x11", "rl",       type: .rl_c_11,               length: 2, cycles: [8]),
  PrefixOpcode("0x12", "rl",       type: .rl_d_12,               length: 2, cycles: [8]),
  PrefixOpcode("0x13", "rl",       type: .rl_e_13,               length: 2, cycles: [8]),
  PrefixOpcode("0x14", "rl",       type: .rl_h_14,               length: 2, cycles: [8]),
  PrefixOpcode("0x15", "rl",       type: .rl_l_15,               length: 2, cycles: [8]),
  PrefixOpcode("0x16", "rl",       type: .rl_pHL_16,             length: 2, cycles: [16]),
  PrefixOpcode("0x17", "rl",       type: .rl_a_17,               length: 2, cycles: [8]),
  PrefixOpcode("0x18", "rr",       type: .rr_b_18,               length: 2, cycles: [8]),
  PrefixOpcode("0x19", "rr",       type: .rr_c_19,               length: 2, cycles: [8]),
  PrefixOpcode("0x1a", "rr",       type: .rr_d_1a,               length: 2, cycles: [8]),
  PrefixOpcode("0x1b", "rr",       type: .rr_e_1b,               length: 2, cycles: [8]),
  PrefixOpcode("0x1c", "rr",       type: .rr_h_1c,               length: 2, cycles: [8]),
  PrefixOpcode("0x1d", "rr",       type: .rr_l_1d,               length: 2, cycles: [8]),
  PrefixOpcode("0x1e", "rr",       type: .rr_pHL_1e,             length: 2, cycles: [16]),
  PrefixOpcode("0x1f", "rr",       type: .rr_a_1f,               length: 2, cycles: [8]),
  PrefixOpcode("0x20", "sla",      type: .sla_b_20,              length: 2, cycles: [8]),
  PrefixOpcode("0x21", "sla",      type: .sla_c_21,              length: 2, cycles: [8]),
  PrefixOpcode("0x22", "sla",      type: .sla_d_22,              length: 2, cycles: [8]),
  PrefixOpcode("0x23", "sla",      type: .sla_e_23,              length: 2, cycles: [8]),
  PrefixOpcode("0x24", "sla",      type: .sla_h_24,              length: 2, cycles: [8]),
  PrefixOpcode("0x25", "sla",      type: .sla_l_25,              length: 2, cycles: [8]),
  PrefixOpcode("0x26", "sla",      type: .sla_pHL_26,            length: 2, cycles: [16]),
  PrefixOpcode("0x27", "sla",      type: .sla_a_27,              length: 2, cycles: [8]),
  PrefixOpcode("0x28", "sra",      type: .sra_b_28,              length: 2, cycles: [8]),
  PrefixOpcode("0x29", "sra",      type: .sra_c_29,              length: 2, cycles: [8]),
  PrefixOpcode("0x2a", "sra",      type: .sra_d_2a,              length: 2, cycles: [8]),
  PrefixOpcode("0x2b", "sra",      type: .sra_e_2b,              length: 2, cycles: [8]),
  PrefixOpcode("0x2c", "sra",      type: .sra_h_2c,              length: 2, cycles: [8]),
  PrefixOpcode("0x2d", "sra",      type: .sra_l_2d,              length: 2, cycles: [8]),
  PrefixOpcode("0x2e", "sra",      type: .sra_pHL_2e,            length: 2, cycles: [16]),
  PrefixOpcode("0x2f", "sra",      type: .sra_a_2f,              length: 2, cycles: [8]),
  PrefixOpcode("0x30", "swap",     type: .swap_b_30,             length: 2, cycles: [8]),
  PrefixOpcode("0x31", "swap",     type: .swap_c_31,             length: 2, cycles: [8]),
  PrefixOpcode("0x32", "swap",     type: .swap_d_32,             length: 2, cycles: [8]),
  PrefixOpcode("0x33", "swap",     type: .swap_e_33,             length: 2, cycles: [8]),
  PrefixOpcode("0x34", "swap",     type: .swap_h_34,             length: 2, cycles: [8]),
  PrefixOpcode("0x35", "swap",     type: .swap_l_35,             length: 2, cycles: [8]),
  PrefixOpcode("0x36", "swap",     type: .swap_pHL_36,           length: 2, cycles: [16]),
  PrefixOpcode("0x37", "swap",     type: .swap_a_37,             length: 2, cycles: [8]),
  PrefixOpcode("0x38", "srl",      type: .srl_b_38,              length: 2, cycles: [8]),
  PrefixOpcode("0x39", "srl",      type: .srl_c_39,              length: 2, cycles: [8]),
  PrefixOpcode("0x3a", "srl",      type: .srl_d_3a,              length: 2, cycles: [8]),
  PrefixOpcode("0x3b", "srl",      type: .srl_e_3b,              length: 2, cycles: [8]),
  PrefixOpcode("0x3c", "srl",      type: .srl_h_3c,              length: 2, cycles: [8]),
  PrefixOpcode("0x3d", "srl",      type: .srl_l_3d,              length: 2, cycles: [8]),
  PrefixOpcode("0x3e", "srl",      type: .srl_pHL_3e,            length: 2, cycles: [16]),
  PrefixOpcode("0x3f", "srl",      type: .srl_a_3f,              length: 2, cycles: [8]),
  PrefixOpcode("0x40", "bit",      type: .bit_0_b_40,            length: 2, cycles: [8]),
  PrefixOpcode("0x41", "bit",      type: .bit_0_c_41,            length: 2, cycles: [8]),
  PrefixOpcode("0x42", "bit",      type: .bit_0_d_42,            length: 2, cycles: [8]),
  PrefixOpcode("0x43", "bit",      type: .bit_0_e_43,            length: 2, cycles: [8]),
  PrefixOpcode("0x44", "bit",      type: .bit_0_h_44,            length: 2, cycles: [8]),
  PrefixOpcode("0x45", "bit",      type: .bit_0_l_45,            length: 2, cycles: [8]),
  PrefixOpcode("0x46", "bit",      type: .bit_0_pHL_46,          length: 2, cycles: [16]),
  PrefixOpcode("0x47", "bit",      type: .bit_0_a_47,            length: 2, cycles: [8]),
  PrefixOpcode("0x48", "bit",      type: .bit_1_b_48,            length: 2, cycles: [8]),
  PrefixOpcode("0x49", "bit",      type: .bit_1_c_49,            length: 2, cycles: [8]),
  PrefixOpcode("0x4a", "bit",      type: .bit_1_d_4a,            length: 2, cycles: [8]),
  PrefixOpcode("0x4b", "bit",      type: .bit_1_e_4b,            length: 2, cycles: [8]),
  PrefixOpcode("0x4c", "bit",      type: .bit_1_h_4c,            length: 2, cycles: [8]),
  PrefixOpcode("0x4d", "bit",      type: .bit_1_l_4d,            length: 2, cycles: [8]),
  PrefixOpcode("0x4e", "bit",      type: .bit_1_pHL_4e,          length: 2, cycles: [16]),
  PrefixOpcode("0x4f", "bit",      type: .bit_1_a_4f,            length: 2, cycles: [8]),
  PrefixOpcode("0x50", "bit",      type: .bit_2_b_50,            length: 2, cycles: [8]),
  PrefixOpcode("0x51", "bit",      type: .bit_2_c_51,            length: 2, cycles: [8]),
  PrefixOpcode("0x52", "bit",      type: .bit_2_d_52,            length: 2, cycles: [8]),
  PrefixOpcode("0x53", "bit",      type: .bit_2_e_53,            length: 2, cycles: [8]),
  PrefixOpcode("0x54", "bit",      type: .bit_2_h_54,            length: 2, cycles: [8]),
  PrefixOpcode("0x55", "bit",      type: .bit_2_l_55,            length: 2, cycles: [8]),
  PrefixOpcode("0x56", "bit",      type: .bit_2_pHL_56,          length: 2, cycles: [16]),
  PrefixOpcode("0x57", "bit",      type: .bit_2_a_57,            length: 2, cycles: [8]),
  PrefixOpcode("0x58", "bit",      type: .bit_3_b_58,            length: 2, cycles: [8]),
  PrefixOpcode("0x59", "bit",      type: .bit_3_c_59,            length: 2, cycles: [8]),
  PrefixOpcode("0x5a", "bit",      type: .bit_3_d_5a,            length: 2, cycles: [8]),
  PrefixOpcode("0x5b", "bit",      type: .bit_3_e_5b,            length: 2, cycles: [8]),
  PrefixOpcode("0x5c", "bit",      type: .bit_3_h_5c,            length: 2, cycles: [8]),
  PrefixOpcode("0x5d", "bit",      type: .bit_3_l_5d,            length: 2, cycles: [8]),
  PrefixOpcode("0x5e", "bit",      type: .bit_3_pHL_5e,          length: 2, cycles: [16]),
  PrefixOpcode("0x5f", "bit",      type: .bit_3_a_5f,            length: 2, cycles: [8]),
  PrefixOpcode("0x60", "bit",      type: .bit_4_b_60,            length: 2, cycles: [8]),
  PrefixOpcode("0x61", "bit",      type: .bit_4_c_61,            length: 2, cycles: [8]),
  PrefixOpcode("0x62", "bit",      type: .bit_4_d_62,            length: 2, cycles: [8]),
  PrefixOpcode("0x63", "bit",      type: .bit_4_e_63,            length: 2, cycles: [8]),
  PrefixOpcode("0x64", "bit",      type: .bit_4_h_64,            length: 2, cycles: [8]),
  PrefixOpcode("0x65", "bit",      type: .bit_4_l_65,            length: 2, cycles: [8]),
  PrefixOpcode("0x66", "bit",      type: .bit_4_pHL_66,          length: 2, cycles: [16]),
  PrefixOpcode("0x67", "bit",      type: .bit_4_a_67,            length: 2, cycles: [8]),
  PrefixOpcode("0x68", "bit",      type: .bit_5_b_68,            length: 2, cycles: [8]),
  PrefixOpcode("0x69", "bit",      type: .bit_5_c_69,            length: 2, cycles: [8]),
  PrefixOpcode("0x6a", "bit",      type: .bit_5_d_6a,            length: 2, cycles: [8]),
  PrefixOpcode("0x6b", "bit",      type: .bit_5_e_6b,            length: 2, cycles: [8]),
  PrefixOpcode("0x6c", "bit",      type: .bit_5_h_6c,            length: 2, cycles: [8]),
  PrefixOpcode("0x6d", "bit",      type: .bit_5_l_6d,            length: 2, cycles: [8]),
  PrefixOpcode("0x6e", "bit",      type: .bit_5_pHL_6e,          length: 2, cycles: [16]),
  PrefixOpcode("0x6f", "bit",      type: .bit_5_a_6f,            length: 2, cycles: [8]),
  PrefixOpcode("0x70", "bit",      type: .bit_6_b_70,            length: 2, cycles: [8]),
  PrefixOpcode("0x71", "bit",      type: .bit_6_c_71,            length: 2, cycles: [8]),
  PrefixOpcode("0x72", "bit",      type: .bit_6_d_72,            length: 2, cycles: [8]),
  PrefixOpcode("0x73", "bit",      type: .bit_6_e_73,            length: 2, cycles: [8]),
  PrefixOpcode("0x74", "bit",      type: .bit_6_h_74,            length: 2, cycles: [8]),
  PrefixOpcode("0x75", "bit",      type: .bit_6_l_75,            length: 2, cycles: [8]),
  PrefixOpcode("0x76", "bit",      type: .bit_6_pHL_76,          length: 2, cycles: [16]),
  PrefixOpcode("0x77", "bit",      type: .bit_6_a_77,            length: 2, cycles: [8]),
  PrefixOpcode("0x78", "bit",      type: .bit_7_b_78,            length: 2, cycles: [8]),
  PrefixOpcode("0x79", "bit",      type: .bit_7_c_79,            length: 2, cycles: [8]),
  PrefixOpcode("0x7a", "bit",      type: .bit_7_d_7a,            length: 2, cycles: [8]),
  PrefixOpcode("0x7b", "bit",      type: .bit_7_e_7b,            length: 2, cycles: [8]),
  PrefixOpcode("0x7c", "bit",      type: .bit_7_h_7c,            length: 2, cycles: [8]),
  PrefixOpcode("0x7d", "bit",      type: .bit_7_l_7d,            length: 2, cycles: [8]),
  PrefixOpcode("0x7e", "bit",      type: .bit_7_pHL_7e,          length: 2, cycles: [16]),
  PrefixOpcode("0x7f", "bit",      type: .bit_7_a_7f,            length: 2, cycles: [8]),
  PrefixOpcode("0x80", "res",      type: .res_0_b_80,            length: 2, cycles: [8]),
  PrefixOpcode("0x81", "res",      type: .res_0_c_81,            length: 2, cycles: [8]),
  PrefixOpcode("0x82", "res",      type: .res_0_d_82,            length: 2, cycles: [8]),
  PrefixOpcode("0x83", "res",      type: .res_0_e_83,            length: 2, cycles: [8]),
  PrefixOpcode("0x84", "res",      type: .res_0_h_84,            length: 2, cycles: [8]),
  PrefixOpcode("0x85", "res",      type: .res_0_l_85,            length: 2, cycles: [8]),
  PrefixOpcode("0x86", "res",      type: .res_0_pHL_86,          length: 2, cycles: [16]),
  PrefixOpcode("0x87", "res",      type: .res_0_a_87,            length: 2, cycles: [8]),
  PrefixOpcode("0x88", "res",      type: .res_1_b_88,            length: 2, cycles: [8]),
  PrefixOpcode("0x89", "res",      type: .res_1_c_89,            length: 2, cycles: [8]),
  PrefixOpcode("0x8a", "res",      type: .res_1_d_8a,            length: 2, cycles: [8]),
  PrefixOpcode("0x8b", "res",      type: .res_1_e_8b,            length: 2, cycles: [8]),
  PrefixOpcode("0x8c", "res",      type: .res_1_h_8c,            length: 2, cycles: [8]),
  PrefixOpcode("0x8d", "res",      type: .res_1_l_8d,            length: 2, cycles: [8]),
  PrefixOpcode("0x8e", "res",      type: .res_1_pHL_8e,          length: 2, cycles: [16]),
  PrefixOpcode("0x8f", "res",      type: .res_1_a_8f,            length: 2, cycles: [8]),
  PrefixOpcode("0x90", "res",      type: .res_2_b_90,            length: 2, cycles: [8]),
  PrefixOpcode("0x91", "res",      type: .res_2_c_91,            length: 2, cycles: [8]),
  PrefixOpcode("0x92", "res",      type: .res_2_d_92,            length: 2, cycles: [8]),
  PrefixOpcode("0x93", "res",      type: .res_2_e_93,            length: 2, cycles: [8]),
  PrefixOpcode("0x94", "res",      type: .res_2_h_94,            length: 2, cycles: [8]),
  PrefixOpcode("0x95", "res",      type: .res_2_l_95,            length: 2, cycles: [8]),
  PrefixOpcode("0x96", "res",      type: .res_2_pHL_96,          length: 2, cycles: [16]),
  PrefixOpcode("0x97", "res",      type: .res_2_a_97,            length: 2, cycles: [8]),
  PrefixOpcode("0x98", "res",      type: .res_3_b_98,            length: 2, cycles: [8]),
  PrefixOpcode("0x99", "res",      type: .res_3_c_99,            length: 2, cycles: [8]),
  PrefixOpcode("0x9a", "res",      type: .res_3_d_9a,            length: 2, cycles: [8]),
  PrefixOpcode("0x9b", "res",      type: .res_3_e_9b,            length: 2, cycles: [8]),
  PrefixOpcode("0x9c", "res",      type: .res_3_h_9c,            length: 2, cycles: [8]),
  PrefixOpcode("0x9d", "res",      type: .res_3_l_9d,            length: 2, cycles: [8]),
  PrefixOpcode("0x9e", "res",      type: .res_3_pHL_9e,          length: 2, cycles: [16]),
  PrefixOpcode("0x9f", "res",      type: .res_3_a_9f,            length: 2, cycles: [8]),
  PrefixOpcode("0xa0", "res",      type: .res_4_b_a0,            length: 2, cycles: [8]),
  PrefixOpcode("0xa1", "res",      type: .res_4_c_a1,            length: 2, cycles: [8]),
  PrefixOpcode("0xa2", "res",      type: .res_4_d_a2,            length: 2, cycles: [8]),
  PrefixOpcode("0xa3", "res",      type: .res_4_e_a3,            length: 2, cycles: [8]),
  PrefixOpcode("0xa4", "res",      type: .res_4_h_a4,            length: 2, cycles: [8]),
  PrefixOpcode("0xa5", "res",      type: .res_4_l_a5,            length: 2, cycles: [8]),
  PrefixOpcode("0xa6", "res",      type: .res_4_pHL_a6,          length: 2, cycles: [16]),
  PrefixOpcode("0xa7", "res",      type: .res_4_a_a7,            length: 2, cycles: [8]),
  PrefixOpcode("0xa8", "res",      type: .res_5_b_a8,            length: 2, cycles: [8]),
  PrefixOpcode("0xa9", "res",      type: .res_5_c_a9,            length: 2, cycles: [8]),
  PrefixOpcode("0xaa", "res",      type: .res_5_d_aa,            length: 2, cycles: [8]),
  PrefixOpcode("0xab", "res",      type: .res_5_e_ab,            length: 2, cycles: [8]),
  PrefixOpcode("0xac", "res",      type: .res_5_h_ac,            length: 2, cycles: [8]),
  PrefixOpcode("0xad", "res",      type: .res_5_l_ad,            length: 2, cycles: [8]),
  PrefixOpcode("0xae", "res",      type: .res_5_pHL_ae,          length: 2, cycles: [16]),
  PrefixOpcode("0xaf", "res",      type: .res_5_a_af,            length: 2, cycles: [8]),
  PrefixOpcode("0xb0", "res",      type: .res_6_b_b0,            length: 2, cycles: [8]),
  PrefixOpcode("0xb1", "res",      type: .res_6_c_b1,            length: 2, cycles: [8]),
  PrefixOpcode("0xb2", "res",      type: .res_6_d_b2,            length: 2, cycles: [8]),
  PrefixOpcode("0xb3", "res",      type: .res_6_e_b3,            length: 2, cycles: [8]),
  PrefixOpcode("0xb4", "res",      type: .res_6_h_b4,            length: 2, cycles: [8]),
  PrefixOpcode("0xb5", "res",      type: .res_6_l_b5,            length: 2, cycles: [8]),
  PrefixOpcode("0xb6", "res",      type: .res_6_pHL_b6,          length: 2, cycles: [16]),
  PrefixOpcode("0xb7", "res",      type: .res_6_a_b7,            length: 2, cycles: [8]),
  PrefixOpcode("0xb8", "res",      type: .res_7_b_b8,            length: 2, cycles: [8]),
  PrefixOpcode("0xb9", "res",      type: .res_7_c_b9,            length: 2, cycles: [8]),
  PrefixOpcode("0xba", "res",      type: .res_7_d_ba,            length: 2, cycles: [8]),
  PrefixOpcode("0xbb", "res",      type: .res_7_e_bb,            length: 2, cycles: [8]),
  PrefixOpcode("0xbc", "res",      type: .res_7_h_bc,            length: 2, cycles: [8]),
  PrefixOpcode("0xbd", "res",      type: .res_7_l_bd,            length: 2, cycles: [8]),
  PrefixOpcode("0xbe", "res",      type: .res_7_pHL_be,          length: 2, cycles: [16]),
  PrefixOpcode("0xbf", "res",      type: .res_7_a_bf,            length: 2, cycles: [8]),
  PrefixOpcode("0xc0", "set",      type: .set_0_b_c0,            length: 2, cycles: [8]),
  PrefixOpcode("0xc1", "set",      type: .set_0_c_c1,            length: 2, cycles: [8]),
  PrefixOpcode("0xc2", "set",      type: .set_0_d_c2,            length: 2, cycles: [8]),
  PrefixOpcode("0xc3", "set",      type: .set_0_e_c3,            length: 2, cycles: [8]),
  PrefixOpcode("0xc4", "set",      type: .set_0_h_c4,            length: 2, cycles: [8]),
  PrefixOpcode("0xc5", "set",      type: .set_0_l_c5,            length: 2, cycles: [8]),
  PrefixOpcode("0xc6", "set",      type: .set_0_pHL_c6,          length: 2, cycles: [16]),
  PrefixOpcode("0xc7", "set",      type: .set_0_a_c7,            length: 2, cycles: [8]),
  PrefixOpcode("0xc8", "set",      type: .set_1_b_c8,            length: 2, cycles: [8]),
  PrefixOpcode("0xc9", "set",      type: .set_1_c_c9,            length: 2, cycles: [8]),
  PrefixOpcode("0xca", "set",      type: .set_1_d_ca,            length: 2, cycles: [8]),
  PrefixOpcode("0xcb", "set",      type: .set_1_e_cb,            length: 2, cycles: [8]),
  PrefixOpcode("0xcc", "set",      type: .set_1_h_cc,            length: 2, cycles: [8]),
  PrefixOpcode("0xcd", "set",      type: .set_1_l_cd,            length: 2, cycles: [8]),
  PrefixOpcode("0xce", "set",      type: .set_1_pHL_ce,          length: 2, cycles: [16]),
  PrefixOpcode("0xcf", "set",      type: .set_1_a_cf,            length: 2, cycles: [8]),
  PrefixOpcode("0xd0", "set",      type: .set_2_b_d0,            length: 2, cycles: [8]),
  PrefixOpcode("0xd1", "set",      type: .set_2_c_d1,            length: 2, cycles: [8]),
  PrefixOpcode("0xd2", "set",      type: .set_2_d_d2,            length: 2, cycles: [8]),
  PrefixOpcode("0xd3", "set",      type: .set_2_e_d3,            length: 2, cycles: [8]),
  PrefixOpcode("0xd4", "set",      type: .set_2_h_d4,            length: 2, cycles: [8]),
  PrefixOpcode("0xd5", "set",      type: .set_2_l_d5,            length: 2, cycles: [8]),
  PrefixOpcode("0xd6", "set",      type: .set_2_pHL_d6,          length: 2, cycles: [16]),
  PrefixOpcode("0xd7", "set",      type: .set_2_a_d7,            length: 2, cycles: [8]),
  PrefixOpcode("0xd8", "set",      type: .set_3_b_d8,            length: 2, cycles: [8]),
  PrefixOpcode("0xd9", "set",      type: .set_3_c_d9,            length: 2, cycles: [8]),
  PrefixOpcode("0xda", "set",      type: .set_3_d_da,            length: 2, cycles: [8]),
  PrefixOpcode("0xdb", "set",      type: .set_3_e_db,            length: 2, cycles: [8]),
  PrefixOpcode("0xdc", "set",      type: .set_3_h_dc,            length: 2, cycles: [8]),
  PrefixOpcode("0xdd", "set",      type: .set_3_l_dd,            length: 2, cycles: [8]),
  PrefixOpcode("0xde", "set",      type: .set_3_pHL_de,          length: 2, cycles: [16]),
  PrefixOpcode("0xdf", "set",      type: .set_3_a_df,            length: 2, cycles: [8]),
  PrefixOpcode("0xe0", "set",      type: .set_4_b_e0,            length: 2, cycles: [8]),
  PrefixOpcode("0xe1", "set",      type: .set_4_c_e1,            length: 2, cycles: [8]),
  PrefixOpcode("0xe2", "set",      type: .set_4_d_e2,            length: 2, cycles: [8]),
  PrefixOpcode("0xe3", "set",      type: .set_4_e_e3,            length: 2, cycles: [8]),
  PrefixOpcode("0xe4", "set",      type: .set_4_h_e4,            length: 2, cycles: [8]),
  PrefixOpcode("0xe5", "set",      type: .set_4_l_e5,            length: 2, cycles: [8]),
  PrefixOpcode("0xe6", "set",      type: .set_4_pHL_e6,          length: 2, cycles: [16]),
  PrefixOpcode("0xe7", "set",      type: .set_4_a_e7,            length: 2, cycles: [8]),
  PrefixOpcode("0xe8", "set",      type: .set_5_b_e8,            length: 2, cycles: [8]),
  PrefixOpcode("0xe9", "set",      type: .set_5_c_e9,            length: 2, cycles: [8]),
  PrefixOpcode("0xea", "set",      type: .set_5_d_ea,            length: 2, cycles: [8]),
  PrefixOpcode("0xeb", "set",      type: .set_5_e_eb,            length: 2, cycles: [8]),
  PrefixOpcode("0xec", "set",      type: .set_5_h_ec,            length: 2, cycles: [8]),
  PrefixOpcode("0xed", "set",      type: .set_5_l_ed,            length: 2, cycles: [8]),
  PrefixOpcode("0xee", "set",      type: .set_5_pHL_ee,          length: 2, cycles: [16]),
  PrefixOpcode("0xef", "set",      type: .set_5_a_ef,            length: 2, cycles: [8]),
  PrefixOpcode("0xf0", "set",      type: .set_6_b_f0,            length: 2, cycles: [8]),
  PrefixOpcode("0xf1", "set",      type: .set_6_c_f1,            length: 2, cycles: [8]),
  PrefixOpcode("0xf2", "set",      type: .set_6_d_f2,            length: 2, cycles: [8]),
  PrefixOpcode("0xf3", "set",      type: .set_6_e_f3,            length: 2, cycles: [8]),
  PrefixOpcode("0xf4", "set",      type: .set_6_h_f4,            length: 2, cycles: [8]),
  PrefixOpcode("0xf5", "set",      type: .set_6_l_f5,            length: 2, cycles: [8]),
  PrefixOpcode("0xf6", "set",      type: .set_6_pHL_f6,          length: 2, cycles: [16]),
  PrefixOpcode("0xf7", "set",      type: .set_6_a_f7,            length: 2, cycles: [8]),
  PrefixOpcode("0xf8", "set",      type: .set_7_b_f8,            length: 2, cycles: [8]),
  PrefixOpcode("0xf9", "set",      type: .set_7_c_f9,            length: 2, cycles: [8]),
  PrefixOpcode("0xfa", "set",      type: .set_7_d_fa,            length: 2, cycles: [8]),
  PrefixOpcode("0xfb", "set",      type: .set_7_e_fb,            length: 2, cycles: [8]),
  PrefixOpcode("0xfc", "set",      type: .set_7_h_fc,            length: 2, cycles: [8]),
  PrefixOpcode("0xfd", "set",      type: .set_7_l_fd,            length: 2, cycles: [8]),
  PrefixOpcode("0xfe", "set",      type: .set_7_pHL_fe,          length: 2, cycles: [16]),
  PrefixOpcode("0xff", "set",      type: .set_7_a_ff,            length: 2, cycles: [8]),
]
