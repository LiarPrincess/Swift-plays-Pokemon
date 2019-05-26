// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

extension Cpu {

  mutating func tick() {
    let opcodeIndex = self.memory.read(self.pc)
    let opcode = opcodes[opcodeIndex]

    // Swift compiler generates better code if we switch on 'opcode.type' and not on 'opcode'
    switch opcode.type {
    case .nop_00: break
    //case .ld_bc_d16_01: break
    case .ld_pBC_a_02: self.ld_pBC_a()
    case .inc_bc_03: self.inc_r(.bc)
    case .inc_b_04: self.inc_r(.b)
    case .dec_b_05: self.dec_r(.b)
    case .ld_b_d8_06: self.ld_r_d8(.b, self.memory.read(self.pc + 1))
    case .rlca_07: self.rlca()
    //case .ld_pA16_sp_08: break
    case .add_hl_bc_09: self.add_hl_r(.bc)
    case .ld_a_pBC_0a: self.ld_a_pBC()
    case .dec_bc_0b: self.dec_r(.bc)
    case .inc_c_0c: self.inc_r(.c)
    case .dec_c_0d: self.dec_r(.c)
    case .ld_c_d8_0e: self.ld_r_d8(.c, self.memory.read(self.pc + 1))
    case .rrca_0f: self.rrca()
      //case .stop_0_10: break
    //case .ld_de_d16_11: break
    case .ld_pDE_a_12: self.ld_pDE_a()
    case .inc_de_13: self.inc_r(.de)
    case .inc_d_14: self.inc_r(.d)
    case .dec_d_15: self.dec_r(.d)
    case .ld_d_d8_16: self.ld_r_d8(.d, self.memory.read(self.pc + 1))
    case .rla_17: self.rla()
    //case .jr_r8_18: break
    case .add_hl_de_19: self.add_hl_r(.de)
    case .ld_a_pDE_1a: self.ld_a_pDE()
    case .dec_de_1b: self.dec_r(.de)
    case .inc_e_1c: self.inc_r(.e)
    case .dec_e_1d: self.dec_r(.e)
    case .ld_e_d8_1e: self.ld_r_d8(.e, self.memory.read(self.pc + 1))
    case .rra_1f: self.rra()
      //case .jr_nz_r8_20: break
    //case .ld_hl_d16_21: break
    case .ld_pHLI_a_22: self.ld_pHLI_a()
    case .inc_hl_23: self.inc_r(.hl)
    case .inc_h_24: self.inc_r(.h)
    case .dec_h_25: self.dec_r(.h)
    case .ld_h_d8_26: self.ld_r_d8(.h, self.memory.read(self.pc + 1))
      //case .daa_27: break
    //case .jr_z_r8_28: break
    case .add_hl_hl_29: self.add_hl_r(.hl)
    case .ld_a_pHLI_2a: self.ld_a_pHLI()
    case .dec_hl_2b: self.dec_r(.hl)
    case .inc_l_2c: self.inc_r(.l)
    case .dec_l_2d: self.dec_r(.l)
    case .ld_l_d8_2e: self.ld_r_d8(.l, self.memory.read(self.pc + 1))
      //case .cpl_2f: break
      //case .jr_nc_r8_30: break
    //case .ld_sp_d16_31: break
    case .ld_pHLD_a_32: self.ld_pHLD_a()
    case .inc_sp_33: self.inc_sp()
    case .inc_pHL_34: self.inc_pHL()
    case .dec_pHL_35: self.dec_pHL()
    case .ld_pHL_d8_36: self.ld_pHL_d8(self.memory.read(self.pc + 1))
      //case .scf_37: break
    //case .jr_c_r8_38: break
    case .add_hl_sp_39: self.add_hl_sp()
    case .ld_a_pHLD_3a: self.ld_a_pHLD()
    case .dec_sp_3b: self.dec_sp()
    case .inc_a_3c: self.inc_r(.a)
    case .dec_a_3d: self.dec_r(.a)
    case .ld_a_d8_3e: self.ld_r_d8(.a, self.memory.read(self.pc + 1))
    //case .ccf_3f: break
    case .ld_b_b_40: self.ld_r_r(.b, .b)
    case .ld_b_c_41: self.ld_r_r(.b, .c)
    case .ld_b_d_42: self.ld_r_r(.b, .d)
    case .ld_b_e_43: self.ld_r_r(.b, .e)
    case .ld_b_h_44: self.ld_r_r(.b, .h)
    case .ld_b_l_45: self.ld_r_r(.b, .l)
    case .ld_b_pHL_46: self.ld_r_pHL(.b)
    case .ld_b_a_47: self.ld_r_r(.b, .a)
    case .ld_c_b_48: self.ld_r_r(.c, .b)
    case .ld_c_c_49: self.ld_r_r(.c, .c)
    case .ld_c_d_4a: self.ld_r_r(.c, .d)
    case .ld_c_e_4b: self.ld_r_r(.c, .e)
    case .ld_c_h_4c: self.ld_r_r(.c, .h)
    case .ld_c_l_4d: self.ld_r_r(.c, .l)
    case .ld_c_pHL_4e: self.ld_r_pHL(.c)
    case .ld_c_a_4f: self.ld_r_r(.c, .a)
    case .ld_d_b_50: self.ld_r_r(.d, .b)
    case .ld_d_c_51: self.ld_r_r(.d, .c)
    case .ld_d_d_52: self.ld_r_r(.d, .d)
    case .ld_d_e_53: self.ld_r_r(.d, .e)
    case .ld_d_h_54: self.ld_r_r(.d, .h)
    case .ld_d_l_55: self.ld_r_r(.d, .l)
    case .ld_d_pHL_56: self.ld_r_pHL(.d)
    case .ld_d_a_57: self.ld_r_r(.d, .a)
    case .ld_e_b_58: self.ld_r_r(.e, .b)
    case .ld_e_c_59: self.ld_r_r(.e, .c)
    case .ld_e_d_5a: self.ld_r_r(.e, .d)
    case .ld_e_e_5b: self.ld_r_r(.e, .e)
    case .ld_e_h_5c: self.ld_r_r(.e, .h)
    case .ld_e_l_5d: self.ld_r_r(.e, .l)
    case .ld_e_pHL_5e: self.ld_r_pHL(.e)
    case .ld_e_a_5f: self.ld_r_r(.e, .a)
    case .ld_h_b_60: self.ld_r_r(.h, .b)
    case .ld_h_c_61: self.ld_r_r(.h, .c)
    case .ld_h_d_62: self.ld_r_r(.h, .d)
    case .ld_h_e_63: self.ld_r_r(.h, .e)
    case .ld_h_h_64: self.ld_r_r(.h, .h)
    case .ld_h_l_65: self.ld_r_r(.h, .l)
    case .ld_h_pHL_66: self.ld_r_pHL(.h)
    case .ld_h_a_67: self.ld_r_r(.h, .a)
    case .ld_l_b_68: self.ld_r_r(.l, .b)
    case .ld_l_c_69: self.ld_r_r(.l, .c)
    case .ld_l_d_6a: self.ld_r_r(.l, .d)
    case .ld_l_e_6b: self.ld_r_r(.l, .e)
    case .ld_l_h_6c: self.ld_r_r(.l, .h)
    case .ld_l_l_6d: self.ld_r_r(.l, .l)
    case .ld_l_pHL_6e: self.ld_r_pHL(.l)
    case .ld_l_a_6f: self.ld_r_r(.l, .a)
    case .ld_pHL_b_70: self.ld_pHL_r(.b)
    case .ld_pHL_c_71: self.ld_pHL_r(.c)
    case .ld_pHL_d_72: self.ld_pHL_r(.d)
    case .ld_pHL_e_73: self.ld_pHL_r(.e)
    case .ld_pHL_h_74: self.ld_pHL_r(.h)
    case .ld_pHL_l_75: self.ld_pHL_r(.l)
    //case .halt_76: break
    case .ld_pHL_a_77: self.ld_pHL_r(.a)
    case .ld_a_b_78: self.ld_r_r(.a, .b)
    case .ld_a_c_79: self.ld_r_r(.a, .c)
    case .ld_a_d_7a: self.ld_r_r(.a, .d)
    case .ld_a_e_7b: self.ld_r_r(.a, .e)
    case .ld_a_h_7c: self.ld_r_r(.a, .h)
    case .ld_a_l_7d: self.ld_r_r(.a, .l)
    case .ld_a_pHL_7e: self.ld_r_pHL(.a)
    case .ld_a_a_7f: self.ld_r_r(.a, .a)
    case .add_a_b_80: self.add_a_r(.b)
    case .add_a_c_81: self.add_a_r(.c)
    case .add_a_d_82: self.add_a_r(.d)
    case .add_a_e_83: self.add_a_r(.e)
    case .add_a_h_84: self.add_a_r(.h)
    case .add_a_l_85: self.add_a_r(.l)
    case .add_a_pHL_86: self.add_a_pHL()
    case .add_a_a_87: self.add_a_r(.a)
    case .adc_a_b_88: self.adc_a_r(.b)
    case .adc_a_c_89: self.adc_a_r(.c)
    case .adc_a_d_8a: self.adc_a_r(.d)
    case .adc_a_e_8b: self.adc_a_r(.e)
    case .adc_a_h_8c: self.adc_a_r(.h)
    case .adc_a_l_8d: self.adc_a_r(.l)
    case .adc_a_pHL_8e: self.adc_a_pHL()
    case .adc_a_a_8f: self.adc_a_r(.a)
    case .sub_b_90: self.sub_a_r(.b)
    case .sub_c_91: self.sub_a_r(.c)
    case .sub_d_92: self.sub_a_r(.d)
    case .sub_e_93: self.sub_a_r(.e)
    case .sub_h_94: self.sub_a_r(.h)
    case .sub_l_95: self.sub_a_r(.l)
    case .sub_pHL_96: self.sub_a_pHL()
    case .sub_a_97: self.sub_a_r(.a)
    case .sbc_a_b_98: self.sbc_a_r(.b)
    case .sbc_a_c_99: self.sbc_a_r(.c)
    case .sbc_a_d_9a: self.sbc_a_r(.d)
    case .sbc_a_e_9b: self.sbc_a_r(.e)
    case .sbc_a_h_9c: self.sbc_a_r(.h)
    case .sbc_a_l_9d: self.sbc_a_r(.l)
    case .sbc_a_pHL_9e: self.sbc_a_pHL()
    case .sbc_a_a_9f: self.sbc_a_r(.a)
    case .and_b_a0: self.and_a_r(.b)
    case .and_c_a1: self.and_a_r(.c)
    case .and_d_a2: self.and_a_r(.d)
    case .and_e_a3: self.and_a_r(.e)
    case .and_h_a4: self.and_a_r(.h)
    case .and_l_a5: self.and_a_r(.l)
    case .and_pHL_a6: self.and_a_pHL()
    case .and_a_a7: self.and_a_r(.a)
    case .xor_b_a8: self.xor_a_r(.b)
    case .xor_c_a9: self.xor_a_r(.c)
    case .xor_d_aa: self.xor_a_r(.d)
    case .xor_e_ab: self.xor_a_r(.e)
    case .xor_h_ac: self.xor_a_r(.h)
    case .xor_l_ad: self.xor_a_r(.l)
    case .xor_pHL_ae: self.xor_a_pHL()
    case .xor_a_af: self.xor_a_r(.a)
    case .or_b_b0: self.or_a_r(.b)
    case .or_c_b1: self.or_a_r(.c)
    case .or_d_b2: self.or_a_r(.d)
    case .or_e_b3: self.or_a_r(.e)
    case .or_h_b4: self.or_a_r(.h)
    case .or_l_b5: self.or_a_r(.l)
    case .or_pHL_b6: self.or_a_pHL()
    case .or_a_b7: self.or_a_r(.a)
    case .cp_b_b8: self.cp_a_r(.b)
    case .cp_c_b9: self.cp_a_r(.c)
    case .cp_d_ba: self.cp_a_r(.d)
    case .cp_e_bb: self.cp_a_r(.e)
    case .cp_h_bc: self.cp_a_r(.h)
    case .cp_l_bd: self.cp_a_r(.l)
    case .cp_pHL_be: self.cp_a_pHL()
    case .cp_a_bf: self.cp_a_r(.a)
      //case .ret_nz_c0: break
      //case .pop_bc_c1: break
      //case .jp_nz_a16_c2: break
      //case .jp_a16_c3: break
      //case .call_nz_a16_c4: break
    //case .push_bc_c5: break
    case .add_a_d8_c6: self.add_a_n(self.memory.read(self.pc + 1))
      //case .rst_00h_c7: break
      //case .ret_z_c8: break
      //case .ret_c9: break
      //case .jp_z_a16_ca: break
      //case .prefix_cb_cb: break
      //case .call_z_a16_cc: break
    //case .call_a16_cd: break
    case .adc_a_d8_ce: self.adc_a_n(self.memory.read(self.pc + 1))
      //case .rst_08h_cf: break
      //case .ret_nc_d0: break
      //case .pop_de_d1: break
      //case .jp_nc_a16_d2: break
      //case .call_nc_a16_d4: break
    //case .push_de_d5: break
    case .sub_d8_d6: self.sub_a_n(self.memory.read(self.pc + 1))
      //case .rst_10h_d7: break
      //case .ret_c_d8: break
      //case .reti_d9: break
      //case .jp_c_a16_da: break
    //case .call_c_a16_dc: break
    case .sbc_a_d8_de: self.sbc_a_n(self.memory.read(self.pc + 1))
      //case .rst_18h_df: break
      //case .ldh_pA8_a_e0: break
    //case .pop_hl_e1: break
    case .ld_pC_a_e2: self.ld_ffC_a()
    //case .push_hl_e5: break
    case .and_d8_e6: self.and_a_n(self.memory.read(self.pc + 1))
    //case .rst_20h_e7: break
    case .add_sp_r8_e8: self.add_sp_n(self.memory.read(self.pc + 1))
      //case .jp_pHL_e9: break
    //case .ld_pA16_a_ea: break
    case .xor_d8_ee: self.xor_a_n(self.memory.read(self.pc + 1))
      //case .rst_28h_ef: break
      //case .ldh_a_pA8_f0: break
    //case .pop_af_f1: break
    case .ld_a_pC_f2: self.ld_a_ffC()
      //case .di_f3: break
    //case .push_af_f5: break
    case .or_d8_f6: self.or_a_n(self.memory.read(self.pc + 1))
      //case .rst_30h_f7: break
      //case .ld_hl_spPlusR8_f8: break
      //case .ld_sp_hl_f9: break
      //case .ld_a_pA16_fa: break
    //case .ei_fb: break
    case .cp_d8_fe: self.cp_a_n(self.memory.read(self.pc + 1))
    //case .rst_38h_ff: break
    default: print("Unknown opcode: \(opcode)")
    }
  }

}
// Implemented opcodes: 197, remaining: 58
