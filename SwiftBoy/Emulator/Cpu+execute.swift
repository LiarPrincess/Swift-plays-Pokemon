// swiftlint:disable file_length

//extension Cpu {
//
//  // swiftlint:disable:next function_body_length cyclomatic_complexity
//  mutating func execute(_ instruction: Instruction) -> UInt16 {
//    //    let value = self.registers.c;
//    //    let new_value = self.add(value);
//    //    self.registers.a = new_value;
//
//    switch instruction.opcode {
//    case .nop_00:
//      break
//    case .ld_01:
//      break
//    case .ld_02:
//      break
//    case .inc_03:
//      break
//    case .inc_04:
//      break
//    case .dec_05:
//      break
//    case .ld_06:
//      break
//    case .rlca_07:
//      break
//    case .ld_08:
//      break
//    case .add_09:
//      break
//    case .ld_0a:
//      break
//    case .dec_0b:
//      break
//    case .inc_0c:
//      break
//    case .dec_0d:
//      break
//    case .ld_0e:
//      break
//    case .rrca_0f:
//      break
//    case .stop_10:
//      break
//    case .ld_11:
//      break
//    case .ld_12:
//      break
//    case .inc_13:
//      break
//    case .inc_14:
//      break
//    case .dec_15:
//      break
//    case .ld_16:
//      break
//    case .rla_17:
//      break
//    case .jr_18:
//      break
//    case .add_19:
//      break
//    case .ld_1a:
//      break
//    case .dec_1b:
//      break
//    case .inc_1c:
//      break
//    case .dec_1d:
//      break
//    case .ld_1e:
//      break
//    case .rra_1f:
//      break
//    case .jr_20:
//      break
//    case .ld_21:
//      break
//    case .ld_22:
//      break
//    case .inc_23:
//      break
//    case .inc_24:
//      break
//    case .dec_25:
//      break
//    case .ld_26:
//      break
//    case .daa_27:
//      break
//    case .jr_28:
//      break
//    case .add_29:
//      break
//    case .ld_2a:
//      break
//    case .dec_2b:
//      break
//    case .inc_2c:
//      break
//    case .dec_2d:
//      break
//    case .ld_2e:
//      break
//    case .cpl_2f:
//      break
//    case .jr_30:
//      break
//    case .ld_31:
//      break
//    case .ld_32:
//      break
//    case .inc_33:
//      break
//    case .inc_34:
//      break
//    case .dec_35:
//      break
//    case .ld_36:
//      break
//    case .scf_37:
//      break
//    case .jr_38:
//      break
//    case .add_39:
//      break
//    case .ld_3a:
//      break
//    case .dec_3b:
//      break
//    case .inc_3c:
//      break
//    case .dec_3d:
//      break
//    case .ld_3e:
//      break
//    case .ccf_3f:
//      break
//    case .ld_40:
//      break
//    case .ld_41:
//      break
//    case .ld_42:
//      break
//    case .ld_43:
//      break
//    case .ld_44:
//      break
//    case .ld_45:
//      break
//    case .ld_46:
//      break
//    case .ld_47:
//      break
//    case .ld_48:
//      break
//    case .ld_49:
//      break
//    case .ld_4a:
//      break
//    case .ld_4b:
//      break
//    case .ld_4c:
//      break
//    case .ld_4d:
//      break
//    case .ld_4e:
//      break
//    case .ld_4f:
//      break
//    case .ld_50:
//      break
//    case .ld_51:
//      break
//    case .ld_52:
//      break
//    case .ld_53:
//      break
//    case .ld_54:
//      break
//    case .ld_55:
//      break
//    case .ld_56:
//      break
//    case .ld_57:
//      break
//    case .ld_58:
//      break
//    case .ld_59:
//      break
//    case .ld_5a:
//      break
//    case .ld_5b:
//      break
//    case .ld_5c:
//      break
//    case .ld_5d:
//      break
//    case .ld_5e:
//      break
//    case .ld_5f:
//      break
//    case .ld_60:
//      break
//    case .ld_61:
//      break
//    case .ld_62:
//      break
//    case .ld_63:
//      break
//    case .ld_64:
//      break
//    case .ld_65:
//      break
//    case .ld_66:
//      break
//    case .ld_67:
//      break
//    case .ld_68:
//      break
//    case .ld_69:
//      break
//    case .ld_6a:
//      break
//    case .ld_6b:
//      break
//    case .ld_6c:
//      break
//    case .ld_6d:
//      break
//    case .ld_6e:
//      break
//    case .ld_6f:
//      break
//    case .ld_70:
//      break
//    case .ld_71:
//      break
//    case .ld_72:
//      break
//    case .ld_73:
//      break
//    case .ld_74:
//      break
//    case .ld_75:
//      break
//    case .halt_76:
//      break
//    case .ld_77:
//      break
//    case .ld_78:
//      break
//    case .ld_79:
//      break
//    case .ld_7a:
//      break
//    case .ld_7b:
//      break
//    case .ld_7c:
//      break
//    case .ld_7d:
//      break
//    case .ld_7e:
//      break
//    case .ld_7f:
//      break
//    case .add_80:
//      break
//    case .add_81:
//      break
//    case .add_82:
//      break
//    case .add_83:
//      break
//    case .add_84:
//      break
//    case .add_85:
//      break
//    case .add_86:
//      break
//    case .add_87:
//      break
//    case .adc_88:
//      break
//    case .adc_89:
//      break
//    case .adc_8a:
//      break
//    case .adc_8b:
//      break
//    case .adc_8c:
//      break
//    case .adc_8d:
//      break
//    case .adc_8e:
//      break
//    case .adc_8f:
//      break
//    case .sub_90:
//      break
//    case .sub_91:
//      break
//    case .sub_92:
//      break
//    case .sub_93:
//      break
//    case .sub_94:
//      break
//    case .sub_95:
//      break
//    case .sub_96:
//      break
//    case .sub_97:
//      break
//    case .sbc_98:
//      break
//    case .sbc_99:
//      break
//    case .sbc_9a:
//      break
//    case .sbc_9b:
//      break
//    case .sbc_9c:
//      break
//    case .sbc_9d:
//      break
//    case .sbc_9e:
//      break
//    case .sbc_9f:
//      break
//    case .and_a0:
//      break
//    case .and_a1:
//      break
//    case .and_a2:
//      break
//    case .and_a3:
//      break
//    case .and_a4:
//      break
//    case .and_a5:
//      break
//    case .and_a6:
//      break
//    case .and_a7:
//      break
//    case .xor_a8:
//      break
//    case .xor_a9:
//      break
//    case .xor_aa:
//      break
//    case .xor_ab:
//      break
//    case .xor_ac:
//      break
//    case .xor_ad:
//      break
//    case .xor_ae:
//      break
//    case .xor_af:
//      break
//    case .or_b0:
//      break
//    case .or_b1:
//      break
//    case .or_b2:
//      break
//    case .or_b3:
//      break
//    case .or_b4:
//      break
//    case .or_b5:
//      break
//    case .or_b6:
//      break
//    case .or_b7:
//      break
//    case .cp_b8:
//      break
//    case .cp_b9:
//      break
//    case .cp_ba:
//      break
//    case .cp_bb:
//      break
//    case .cp_bc:
//      break
//    case .cp_bd:
//      break
//    case .cp_be:
//      break
//    case .cp_bf:
//      break
//    case .ret_c0:
//      break
//    case .pop_c1:
//      break
//    case .jp_c2:
//      break
//    case .jp_c3:
//      break
//    case .call_c4:
//      break
//    case .push_c5:
//      break
//    case .add_c6:
//      break
//    case .rst_c7:
//      break
//    case .ret_c8:
//      break
//    case .ret_c9:
//      break
//    case .jp_ca:
//      break
//    case .prefix_cb:
//      break
//    case .call_cc:
//      break
//    case .call_cd:
//      break
//    case .adc_ce:
//      break
//    case .rst_cf:
//      break
//    case .ret_d0:
//      break
//    case .pop_d1:
//      break
//    case .jp_d2:
//      break
//    case .call_d4:
//      break
//    case .push_d5:
//      break
//    case .sub_d6:
//      break
//    case .rst_d7:
//      break
//    case .ret_d8:
//      break
//    case .reti_d9:
//      break
//    case .jp_da:
//      break
//    case .call_dc:
//      break
//    case .sbc_de:
//      break
//    case .rst_df:
//      break
//    case .ldh_e0:
//      break
//    case .pop_e1:
//      break
//    case .ld_e2:
//      break
//    case .push_e5:
//      break
//    case .and_e6:
//      break
//    case .rst_e7:
//      break
//    case .add_e8:
//      break
//    case .jp_e9:
//      break
//    case .ld_ea:
//      break
//    case .xor_ee:
//      break
//    case .rst_ef:
//      break
//    case .ldh_f0:
//      break
//    case .pop_f1:
//      break
//    case .ld_f2:
//      break
//    case .di_f3:
//      break
//    case .push_f5:
//      break
//    case .or_f6:
//      break
//    case .rst_f7:
//      break
//    case .ld_f8:
//      break
//    case .ld_f9:
//      break
//    case .ld_fa:
//      break
//    case .ei_fb:
//      break
//    case .cp_fe:
//      break
//    case .rst_ff:
//      break
//    }
//
//    return 0
//  }
//}
