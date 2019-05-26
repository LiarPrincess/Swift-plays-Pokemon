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
  case ld_hl_spPlusR8_f8
  case ld_sp_hl_f9
  case ld_a_pA16_fa
  case ei_fb
  case cp_d8_fe
  case rst_38h_ff
}

let opcodes: [Opcode] = [
  Opcode("0x0", "nop",       type: .nop_00,                length: 1, cycles: [4]),
  Opcode("0x1", "ld",        type: .ld_bc_d16_01,          length: 3, cycles: [12]),
  Opcode("0x2", "ld",        type: .ld_pBC_a_02,           length: 1, cycles: [8]),
  Opcode("0x3", "inc",       type: .inc_bc_03,             length: 1, cycles: [8]),
  Opcode("0x4", "inc",       type: .inc_b_04,              length: 1, cycles: [4]),
  Opcode("0x5", "dec",       type: .dec_b_05,              length: 1, cycles: [4]),
  Opcode("0x6", "ld",        type: .ld_b_d8_06,            length: 2, cycles: [8]),
  Opcode("0x7", "rlca",      type: .rlca_07,               length: 1, cycles: [4]),
  Opcode("0x8", "ld",        type: .ld_pA16_sp_08,         length: 3, cycles: [20]),
  Opcode("0x9", "add",       type: .add_hl_bc_09,          length: 1, cycles: [8]),
  Opcode("0xa", "ld",        type: .ld_a_pBC_0a,           length: 1, cycles: [8]),
  Opcode("0xb", "dec",       type: .dec_bc_0b,             length: 1, cycles: [8]),
  Opcode("0xc", "inc",       type: .inc_c_0c,              length: 1, cycles: [4]),
  Opcode("0xd", "dec",       type: .dec_c_0d,              length: 1, cycles: [4]),
  Opcode("0xe", "ld",        type: .ld_c_d8_0e,            length: 2, cycles: [8]),
  Opcode("0xf", "rrca",      type: .rrca_0f,               length: 1, cycles: [4]),
  Opcode("0x10", "stop",     type: .stop_0_10,             length: 1, cycles: [4]),
  Opcode("0x11", "ld",       type: .ld_de_d16_11,          length: 3, cycles: [12]),
  Opcode("0x12", "ld",       type: .ld_pDE_a_12,           length: 1, cycles: [8]),
  Opcode("0x13", "inc",      type: .inc_de_13,             length: 1, cycles: [8]),
  Opcode("0x14", "inc",      type: .inc_d_14,              length: 1, cycles: [4]),
  Opcode("0x15", "dec",      type: .dec_d_15,              length: 1, cycles: [4]),
  Opcode("0x16", "ld",       type: .ld_d_d8_16,            length: 2, cycles: [8]),
  Opcode("0x17", "rla",      type: .rla_17,                length: 1, cycles: [4]),
  Opcode("0x18", "jr",       type: .jr_r8_18,              length: 2, cycles: [12]),
  Opcode("0x19", "add",      type: .add_hl_de_19,          length: 1, cycles: [8]),
  Opcode("0x1a", "ld",       type: .ld_a_pDE_1a,           length: 1, cycles: [8]),
  Opcode("0x1b", "dec",      type: .dec_de_1b,             length: 1, cycles: [8]),
  Opcode("0x1c", "inc",      type: .inc_e_1c,              length: 1, cycles: [4]),
  Opcode("0x1d", "dec",      type: .dec_e_1d,              length: 1, cycles: [4]),
  Opcode("0x1e", "ld",       type: .ld_e_d8_1e,            length: 2, cycles: [8]),
  Opcode("0x1f", "rra",      type: .rra_1f,                length: 1, cycles: [4]),
  Opcode("0x20", "jr",       type: .jr_nz_r8_20,           length: 2, cycles: [12, 8]),
  Opcode("0x21", "ld",       type: .ld_hl_d16_21,          length: 3, cycles: [12]),
  Opcode("0x22", "ld",       type: .ld_pHLI_a_22,          length: 1, cycles: [8]),
  Opcode("0x23", "inc",      type: .inc_hl_23,             length: 1, cycles: [8]),
  Opcode("0x24", "inc",      type: .inc_h_24,              length: 1, cycles: [4]),
  Opcode("0x25", "dec",      type: .dec_h_25,              length: 1, cycles: [4]),
  Opcode("0x26", "ld",       type: .ld_h_d8_26,            length: 2, cycles: [8]),
  Opcode("0x27", "daa",      type: .daa_27,                length: 1, cycles: [4]),
  Opcode("0x28", "jr",       type: .jr_z_r8_28,            length: 2, cycles: [12, 8]),
  Opcode("0x29", "add",      type: .add_hl_hl_29,          length: 1, cycles: [8]),
  Opcode("0x2a", "ld",       type: .ld_a_pHLI_2a,          length: 1, cycles: [8]),
  Opcode("0x2b", "dec",      type: .dec_hl_2b,             length: 1, cycles: [8]),
  Opcode("0x2c", "inc",      type: .inc_l_2c,              length: 1, cycles: [4]),
  Opcode("0x2d", "dec",      type: .dec_l_2d,              length: 1, cycles: [4]),
  Opcode("0x2e", "ld",       type: .ld_l_d8_2e,            length: 2, cycles: [8]),
  Opcode("0x2f", "cpl",      type: .cpl_2f,                length: 1, cycles: [4]),
  Opcode("0x30", "jr",       type: .jr_nc_r8_30,           length: 2, cycles: [12, 8]),
  Opcode("0x31", "ld",       type: .ld_sp_d16_31,          length: 3, cycles: [12]),
  Opcode("0x32", "ld",       type: .ld_pHLD_a_32,          length: 1, cycles: [8]),
  Opcode("0x33", "inc",      type: .inc_sp_33,             length: 1, cycles: [8]),
  Opcode("0x34", "inc",      type: .inc_pHL_34,            length: 1, cycles: [12]),
  Opcode("0x35", "dec",      type: .dec_pHL_35,            length: 1, cycles: [12]),
  Opcode("0x36", "ld",       type: .ld_pHL_d8_36,          length: 2, cycles: [12]),
  Opcode("0x37", "scf",      type: .scf_37,                length: 1, cycles: [4]),
  Opcode("0x38", "jr",       type: .jr_c_r8_38,            length: 2, cycles: [12, 8]),
  Opcode("0x39", "add",      type: .add_hl_sp_39,          length: 1, cycles: [8]),
  Opcode("0x3a", "ld",       type: .ld_a_pHLD_3a,          length: 1, cycles: [8]),
  Opcode("0x3b", "dec",      type: .dec_sp_3b,             length: 1, cycles: [8]),
  Opcode("0x3c", "inc",      type: .inc_a_3c,              length: 1, cycles: [4]),
  Opcode("0x3d", "dec",      type: .dec_a_3d,              length: 1, cycles: [4]),
  Opcode("0x3e", "ld",       type: .ld_a_d8_3e,            length: 2, cycles: [8]),
  Opcode("0x3f", "ccf",      type: .ccf_3f,                length: 1, cycles: [4]),
  Opcode("0x40", "ld",       type: .ld_b_b_40,             length: 1, cycles: [4]),
  Opcode("0x41", "ld",       type: .ld_b_c_41,             length: 1, cycles: [4]),
  Opcode("0x42", "ld",       type: .ld_b_d_42,             length: 1, cycles: [4]),
  Opcode("0x43", "ld",       type: .ld_b_e_43,             length: 1, cycles: [4]),
  Opcode("0x44", "ld",       type: .ld_b_h_44,             length: 1, cycles: [4]),
  Opcode("0x45", "ld",       type: .ld_b_l_45,             length: 1, cycles: [4]),
  Opcode("0x46", "ld",       type: .ld_b_pHL_46,           length: 1, cycles: [8]),
  Opcode("0x47", "ld",       type: .ld_b_a_47,             length: 1, cycles: [4]),
  Opcode("0x48", "ld",       type: .ld_c_b_48,             length: 1, cycles: [4]),
  Opcode("0x49", "ld",       type: .ld_c_c_49,             length: 1, cycles: [4]),
  Opcode("0x4a", "ld",       type: .ld_c_d_4a,             length: 1, cycles: [4]),
  Opcode("0x4b", "ld",       type: .ld_c_e_4b,             length: 1, cycles: [4]),
  Opcode("0x4c", "ld",       type: .ld_c_h_4c,             length: 1, cycles: [4]),
  Opcode("0x4d", "ld",       type: .ld_c_l_4d,             length: 1, cycles: [4]),
  Opcode("0x4e", "ld",       type: .ld_c_pHL_4e,           length: 1, cycles: [8]),
  Opcode("0x4f", "ld",       type: .ld_c_a_4f,             length: 1, cycles: [4]),
  Opcode("0x50", "ld",       type: .ld_d_b_50,             length: 1, cycles: [4]),
  Opcode("0x51", "ld",       type: .ld_d_c_51,             length: 1, cycles: [4]),
  Opcode("0x52", "ld",       type: .ld_d_d_52,             length: 1, cycles: [4]),
  Opcode("0x53", "ld",       type: .ld_d_e_53,             length: 1, cycles: [4]),
  Opcode("0x54", "ld",       type: .ld_d_h_54,             length: 1, cycles: [4]),
  Opcode("0x55", "ld",       type: .ld_d_l_55,             length: 1, cycles: [4]),
  Opcode("0x56", "ld",       type: .ld_d_pHL_56,           length: 1, cycles: [8]),
  Opcode("0x57", "ld",       type: .ld_d_a_57,             length: 1, cycles: [4]),
  Opcode("0x58", "ld",       type: .ld_e_b_58,             length: 1, cycles: [4]),
  Opcode("0x59", "ld",       type: .ld_e_c_59,             length: 1, cycles: [4]),
  Opcode("0x5a", "ld",       type: .ld_e_d_5a,             length: 1, cycles: [4]),
  Opcode("0x5b", "ld",       type: .ld_e_e_5b,             length: 1, cycles: [4]),
  Opcode("0x5c", "ld",       type: .ld_e_h_5c,             length: 1, cycles: [4]),
  Opcode("0x5d", "ld",       type: .ld_e_l_5d,             length: 1, cycles: [4]),
  Opcode("0x5e", "ld",       type: .ld_e_pHL_5e,           length: 1, cycles: [8]),
  Opcode("0x5f", "ld",       type: .ld_e_a_5f,             length: 1, cycles: [4]),
  Opcode("0x60", "ld",       type: .ld_h_b_60,             length: 1, cycles: [4]),
  Opcode("0x61", "ld",       type: .ld_h_c_61,             length: 1, cycles: [4]),
  Opcode("0x62", "ld",       type: .ld_h_d_62,             length: 1, cycles: [4]),
  Opcode("0x63", "ld",       type: .ld_h_e_63,             length: 1, cycles: [4]),
  Opcode("0x64", "ld",       type: .ld_h_h_64,             length: 1, cycles: [4]),
  Opcode("0x65", "ld",       type: .ld_h_l_65,             length: 1, cycles: [4]),
  Opcode("0x66", "ld",       type: .ld_h_pHL_66,           length: 1, cycles: [8]),
  Opcode("0x67", "ld",       type: .ld_h_a_67,             length: 1, cycles: [4]),
  Opcode("0x68", "ld",       type: .ld_l_b_68,             length: 1, cycles: [4]),
  Opcode("0x69", "ld",       type: .ld_l_c_69,             length: 1, cycles: [4]),
  Opcode("0x6a", "ld",       type: .ld_l_d_6a,             length: 1, cycles: [4]),
  Opcode("0x6b", "ld",       type: .ld_l_e_6b,             length: 1, cycles: [4]),
  Opcode("0x6c", "ld",       type: .ld_l_h_6c,             length: 1, cycles: [4]),
  Opcode("0x6d", "ld",       type: .ld_l_l_6d,             length: 1, cycles: [4]),
  Opcode("0x6e", "ld",       type: .ld_l_pHL_6e,           length: 1, cycles: [8]),
  Opcode("0x6f", "ld",       type: .ld_l_a_6f,             length: 1, cycles: [4]),
  Opcode("0x70", "ld",       type: .ld_pHL_b_70,           length: 1, cycles: [8]),
  Opcode("0x71", "ld",       type: .ld_pHL_c_71,           length: 1, cycles: [8]),
  Opcode("0x72", "ld",       type: .ld_pHL_d_72,           length: 1, cycles: [8]),
  Opcode("0x73", "ld",       type: .ld_pHL_e_73,           length: 1, cycles: [8]),
  Opcode("0x74", "ld",       type: .ld_pHL_h_74,           length: 1, cycles: [8]),
  Opcode("0x75", "ld",       type: .ld_pHL_l_75,           length: 1, cycles: [8]),
  Opcode("0x76", "halt",     type: .halt_76,               length: 1, cycles: [4]),
  Opcode("0x77", "ld",       type: .ld_pHL_a_77,           length: 1, cycles: [8]),
  Opcode("0x78", "ld",       type: .ld_a_b_78,             length: 1, cycles: [4]),
  Opcode("0x79", "ld",       type: .ld_a_c_79,             length: 1, cycles: [4]),
  Opcode("0x7a", "ld",       type: .ld_a_d_7a,             length: 1, cycles: [4]),
  Opcode("0x7b", "ld",       type: .ld_a_e_7b,             length: 1, cycles: [4]),
  Opcode("0x7c", "ld",       type: .ld_a_h_7c,             length: 1, cycles: [4]),
  Opcode("0x7d", "ld",       type: .ld_a_l_7d,             length: 1, cycles: [4]),
  Opcode("0x7e", "ld",       type: .ld_a_pHL_7e,           length: 1, cycles: [8]),
  Opcode("0x7f", "ld",       type: .ld_a_a_7f,             length: 1, cycles: [4]),
  Opcode("0x80", "add",      type: .add_a_b_80,            length: 1, cycles: [4]),
  Opcode("0x81", "add",      type: .add_a_c_81,            length: 1, cycles: [4]),
  Opcode("0x82", "add",      type: .add_a_d_82,            length: 1, cycles: [4]),
  Opcode("0x83", "add",      type: .add_a_e_83,            length: 1, cycles: [4]),
  Opcode("0x84", "add",      type: .add_a_h_84,            length: 1, cycles: [4]),
  Opcode("0x85", "add",      type: .add_a_l_85,            length: 1, cycles: [4]),
  Opcode("0x86", "add",      type: .add_a_pHL_86,          length: 1, cycles: [8]),
  Opcode("0x87", "add",      type: .add_a_a_87,            length: 1, cycles: [4]),
  Opcode("0x88", "adc",      type: .adc_a_b_88,            length: 1, cycles: [4]),
  Opcode("0x89", "adc",      type: .adc_a_c_89,            length: 1, cycles: [4]),
  Opcode("0x8a", "adc",      type: .adc_a_d_8a,            length: 1, cycles: [4]),
  Opcode("0x8b", "adc",      type: .adc_a_e_8b,            length: 1, cycles: [4]),
  Opcode("0x8c", "adc",      type: .adc_a_h_8c,            length: 1, cycles: [4]),
  Opcode("0x8d", "adc",      type: .adc_a_l_8d,            length: 1, cycles: [4]),
  Opcode("0x8e", "adc",      type: .adc_a_pHL_8e,          length: 1, cycles: [8]),
  Opcode("0x8f", "adc",      type: .adc_a_a_8f,            length: 1, cycles: [4]),
  Opcode("0x90", "sub",      type: .sub_b_90,              length: 1, cycles: [4]),
  Opcode("0x91", "sub",      type: .sub_c_91,              length: 1, cycles: [4]),
  Opcode("0x92", "sub",      type: .sub_d_92,              length: 1, cycles: [4]),
  Opcode("0x93", "sub",      type: .sub_e_93,              length: 1, cycles: [4]),
  Opcode("0x94", "sub",      type: .sub_h_94,              length: 1, cycles: [4]),
  Opcode("0x95", "sub",      type: .sub_l_95,              length: 1, cycles: [4]),
  Opcode("0x96", "sub",      type: .sub_pHL_96,            length: 1, cycles: [8]),
  Opcode("0x97", "sub",      type: .sub_a_97,              length: 1, cycles: [4]),
  Opcode("0x98", "sbc",      type: .sbc_a_b_98,            length: 1, cycles: [4]),
  Opcode("0x99", "sbc",      type: .sbc_a_c_99,            length: 1, cycles: [4]),
  Opcode("0x9a", "sbc",      type: .sbc_a_d_9a,            length: 1, cycles: [4]),
  Opcode("0x9b", "sbc",      type: .sbc_a_e_9b,            length: 1, cycles: [4]),
  Opcode("0x9c", "sbc",      type: .sbc_a_h_9c,            length: 1, cycles: [4]),
  Opcode("0x9d", "sbc",      type: .sbc_a_l_9d,            length: 1, cycles: [4]),
  Opcode("0x9e", "sbc",      type: .sbc_a_pHL_9e,          length: 1, cycles: [8]),
  Opcode("0x9f", "sbc",      type: .sbc_a_a_9f,            length: 1, cycles: [4]),
  Opcode("0xa0", "and",      type: .and_b_a0,              length: 1, cycles: [4]),
  Opcode("0xa1", "and",      type: .and_c_a1,              length: 1, cycles: [4]),
  Opcode("0xa2", "and",      type: .and_d_a2,              length: 1, cycles: [4]),
  Opcode("0xa3", "and",      type: .and_e_a3,              length: 1, cycles: [4]),
  Opcode("0xa4", "and",      type: .and_h_a4,              length: 1, cycles: [4]),
  Opcode("0xa5", "and",      type: .and_l_a5,              length: 1, cycles: [4]),
  Opcode("0xa6", "and",      type: .and_pHL_a6,            length: 1, cycles: [8]),
  Opcode("0xa7", "and",      type: .and_a_a7,              length: 1, cycles: [4]),
  Opcode("0xa8", "xor",      type: .xor_b_a8,              length: 1, cycles: [4]),
  Opcode("0xa9", "xor",      type: .xor_c_a9,              length: 1, cycles: [4]),
  Opcode("0xaa", "xor",      type: .xor_d_aa,              length: 1, cycles: [4]),
  Opcode("0xab", "xor",      type: .xor_e_ab,              length: 1, cycles: [4]),
  Opcode("0xac", "xor",      type: .xor_h_ac,              length: 1, cycles: [4]),
  Opcode("0xad", "xor",      type: .xor_l_ad,              length: 1, cycles: [4]),
  Opcode("0xae", "xor",      type: .xor_pHL_ae,            length: 1, cycles: [8]),
  Opcode("0xaf", "xor",      type: .xor_a_af,              length: 1, cycles: [4]),
  Opcode("0xb0", "or",       type: .or_b_b0,               length: 1, cycles: [4]),
  Opcode("0xb1", "or",       type: .or_c_b1,               length: 1, cycles: [4]),
  Opcode("0xb2", "or",       type: .or_d_b2,               length: 1, cycles: [4]),
  Opcode("0xb3", "or",       type: .or_e_b3,               length: 1, cycles: [4]),
  Opcode("0xb4", "or",       type: .or_h_b4,               length: 1, cycles: [4]),
  Opcode("0xb5", "or",       type: .or_l_b5,               length: 1, cycles: [4]),
  Opcode("0xb6", "or",       type: .or_pHL_b6,             length: 1, cycles: [8]),
  Opcode("0xb7", "or",       type: .or_a_b7,               length: 1, cycles: [4]),
  Opcode("0xb8", "cp",       type: .cp_b_b8,               length: 1, cycles: [4]),
  Opcode("0xb9", "cp",       type: .cp_c_b9,               length: 1, cycles: [4]),
  Opcode("0xba", "cp",       type: .cp_d_ba,               length: 1, cycles: [4]),
  Opcode("0xbb", "cp",       type: .cp_e_bb,               length: 1, cycles: [4]),
  Opcode("0xbc", "cp",       type: .cp_h_bc,               length: 1, cycles: [4]),
  Opcode("0xbd", "cp",       type: .cp_l_bd,               length: 1, cycles: [4]),
  Opcode("0xbe", "cp",       type: .cp_pHL_be,             length: 1, cycles: [8]),
  Opcode("0xbf", "cp",       type: .cp_a_bf,               length: 1, cycles: [4]),
  Opcode("0xc0", "ret",      type: .ret_nz_c0,             length: 1, cycles: [20, 8]),
  Opcode("0xc1", "pop",      type: .pop_bc_c1,             length: 1, cycles: [12]),
  Opcode("0xc2", "jp",       type: .jp_nz_a16_c2,          length: 3, cycles: [16, 12]),
  Opcode("0xc3", "jp",       type: .jp_a16_c3,             length: 3, cycles: [16]),
  Opcode("0xc4", "call",     type: .call_nz_a16_c4,        length: 3, cycles: [24, 12]),
  Opcode("0xc5", "push",     type: .push_bc_c5,            length: 1, cycles: [16]),
  Opcode("0xc6", "add",      type: .add_a_d8_c6,           length: 2, cycles: [8]),
  Opcode("0xc7", "rst",      type: .rst_00h_c7,            length: 1, cycles: [16]),
  Opcode("0xc8", "ret",      type: .ret_z_c8,              length: 1, cycles: [20, 8]),
  Opcode("0xc9", "ret",      type: .ret_c9,                length: 1, cycles: [16]),
  Opcode("0xca", "jp",       type: .jp_z_a16_ca,           length: 3, cycles: [16, 12]),
  Opcode("0xcb", "prefix",   type: .prefix_cb_cb,          length: 1, cycles: [4]),
  Opcode("0xcc", "call",     type: .call_z_a16_cc,         length: 3, cycles: [24, 12]),
  Opcode("0xcd", "call",     type: .call_a16_cd,           length: 3, cycles: [24]),
  Opcode("0xce", "adc",      type: .adc_a_d8_ce,           length: 2, cycles: [8]),
  Opcode("0xcf", "rst",      type: .rst_08h_cf,            length: 1, cycles: [16]),
  Opcode("0xd0", "ret",      type: .ret_nc_d0,             length: 1, cycles: [20, 8]),
  Opcode("0xd1", "pop",      type: .pop_de_d1,             length: 1, cycles: [12]),
  Opcode("0xd2", "jp",       type: .jp_nc_a16_d2,          length: 3, cycles: [16, 12]),
  Opcode("0xd4", "call",     type: .call_nc_a16_d4,        length: 3, cycles: [24, 12]),
  Opcode("0xd5", "push",     type: .push_de_d5,            length: 1, cycles: [16]),
  Opcode("0xd6", "sub",      type: .sub_d8_d6,             length: 2, cycles: [8]),
  Opcode("0xd7", "rst",      type: .rst_10h_d7,            length: 1, cycles: [16]),
  Opcode("0xd8", "ret",      type: .ret_c_d8,              length: 1, cycles: [20, 8]),
  Opcode("0xd9", "reti",     type: .reti_d9,               length: 1, cycles: [16]),
  Opcode("0xda", "jp",       type: .jp_c_a16_da,           length: 3, cycles: [16, 12]),
  Opcode("0xdc", "call",     type: .call_c_a16_dc,         length: 3, cycles: [24, 12]),
  Opcode("0xde", "sbc",      type: .sbc_a_d8_de,           length: 2, cycles: [8]),
  Opcode("0xdf", "rst",      type: .rst_18h_df,            length: 1, cycles: [16]),
  Opcode("0xe0", "ldh",      type: .ldh_pA8_a_e0,          length: 2, cycles: [12]),
  Opcode("0xe1", "pop",      type: .pop_hl_e1,             length: 1, cycles: [12]),
  Opcode("0xe2", "ld",       type: .ld_pC_a_e2,            length: 1, cycles: [8]),
  Opcode("0xe5", "push",     type: .push_hl_e5,            length: 1, cycles: [16]),
  Opcode("0xe6", "and",      type: .and_d8_e6,             length: 2, cycles: [8]),
  Opcode("0xe7", "rst",      type: .rst_20h_e7,            length: 1, cycles: [16]),
  Opcode("0xe8", "add",      type: .add_sp_r8_e8,          length: 2, cycles: [16]),
  Opcode("0xe9", "jp",       type: .jp_pHL_e9,             length: 1, cycles: [4]),
  Opcode("0xea", "ld",       type: .ld_pA16_a_ea,          length: 3, cycles: [16]),
  Opcode("0xee", "xor",      type: .xor_d8_ee,             length: 2, cycles: [8]),
  Opcode("0xef", "rst",      type: .rst_28h_ef,            length: 1, cycles: [16]),
  Opcode("0xf0", "ldh",      type: .ldh_a_pA8_f0,          length: 2, cycles: [12]),
  Opcode("0xf1", "pop",      type: .pop_af_f1,             length: 1, cycles: [12]),
  Opcode("0xf2", "ld",       type: .ld_a_pC_f2,            length: 1, cycles: [8]),
  Opcode("0xf3", "di",       type: .di_f3,                 length: 1, cycles: [4]),
  Opcode("0xf5", "push",     type: .push_af_f5,            length: 1, cycles: [16]),
  Opcode("0xf6", "or",       type: .or_d8_f6,              length: 2, cycles: [8]),
  Opcode("0xf7", "rst",      type: .rst_30h_f7,            length: 1, cycles: [16]),
  Opcode("0xf8", "ld",       type: .ld_hl_spPlusR8_f8,     length: 2, cycles: [12]),
  Opcode("0xf9", "ld",       type: .ld_sp_hl_f9,           length: 1, cycles: [8]),
  Opcode("0xfa", "ld",       type: .ld_a_pA16_fa,          length: 3, cycles: [16]),
  Opcode("0xfb", "ei",       type: .ei_fb,                 length: 1, cycles: [4]),
  Opcode("0xfe", "cp",       type: .cp_d8_fe,              length: 2, cycles: [8]),
  Opcode("0xff", "rst",      type: .rst_38h_ff,            length: 1, cycles: [16]),
]
