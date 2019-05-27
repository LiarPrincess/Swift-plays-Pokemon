// This file was auto-generated.
// DO NOT EDIT!

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable switch_case_alignment

extension Cpu {
  mutating func execute(_ opcode: Opcode) {
    switch opcode.type {
/* 0x0 */ case .nop: break
/* 0x1 */ case .ld_bc_d16: self.ld_rr_d16(.bc, self.next16)
/* 0x2 */ case .ld_pBC_a: self.ld_pBC_a()
/* 0x3 */ case .inc_bc: self.inc_rr(.bc)
/* 0x4 */ case .inc_b: self.inc_r(.b)
/* 0x5 */ case .dec_b: self.dec_r(.b)
/* 0x6 */ case .ld_b_d8: self.ld_r_d8(.b, self.next8)
/* 0x7 */ case .rlca: self.rlca()
/* 0x8 */ case .ld_pA16_sp: self.ld_pA16_sp(self.next16)
/* 0x9 */ case .add_hl_bc: self.add_hl_r(.bc)
/* 0xa */ case .ld_a_pBC: self.ld_a_pBC()
/* 0xb */ case .dec_bc: self.dec_rr(.bc)
/* 0xc */ case .inc_c: self.inc_r(.c)
/* 0xd */ case .dec_c: self.dec_r(.c)
/* 0xe */ case .ld_c_d8: self.ld_r_d8(.c, self.next8)
/* 0xf */ case .rrca: self.rrca()
/* 0x10 */ case .stop_0: break // <--
/* 0x11 */ case .ld_de_d16: self.ld_rr_d16(.de, self.next16)
/* 0x12 */ case .ld_pDE_a: self.ld_pDE_a()
/* 0x13 */ case .inc_de: self.inc_rr(.de)
/* 0x14 */ case .inc_d: self.inc_r(.d)
/* 0x15 */ case .dec_d: self.dec_r(.d)
/* 0x16 */ case .ld_d_d8: self.ld_r_d8(.d, self.next8)
/* 0x17 */ case .rla: self.rla()
/* 0x18 */ case .jr_r8: self.jr_e(self.next8)
/* 0x19 */ case .add_hl_de: self.add_hl_r(.de)
/* 0x1a */ case .ld_a_pDE: self.ld_a_pDE()
/* 0x1b */ case .dec_de: self.dec_rr(.de)
/* 0x1c */ case .inc_e: self.inc_r(.e)
/* 0x1d */ case .dec_e: self.dec_r(.e)
/* 0x1e */ case .ld_e_d8: self.ld_r_d8(.e, self.next8)
/* 0x1f */ case .rra: self.rra()
/* 0x20 */ case .jr_nz_r8: self.jr_cc_e(.nz, self.next8)
/* 0x21 */ case .ld_hl_d16: self.ld_rr_d16(.hl, self.next16)
/* 0x22 */ case .ld_pHLI_a: self.ld_pHLI_a()
/* 0x23 */ case .inc_hl: self.inc_rr(.hl)
/* 0x24 */ case .inc_h: self.inc_r(.h)
/* 0x25 */ case .dec_h: self.dec_r(.h)
/* 0x26 */ case .ld_h_d8: self.ld_r_d8(.h, self.next8)
/* 0x27 */ case .daa: break // <--
/* 0x28 */ case .jr_z_r8: self.jr_cc_e(.z, self.next8)
/* 0x29 */ case .add_hl_hl: self.add_hl_r(.hl)
/* 0x2a */ case .ld_a_pHLI: self.ld_a_pHLI()
/* 0x2b */ case .dec_hl: self.dec_rr(.hl)
/* 0x2c */ case .inc_l: self.inc_r(.l)
/* 0x2d */ case .dec_l: self.dec_r(.l)
/* 0x2e */ case .ld_l_d8: self.ld_r_d8(.l, self.next8)
/* 0x2f */ case .cpl: break // <--
/* 0x30 */ case .jr_nc_r8: self.jr_cc_e(.nc, self.next8)
/* 0x31 */ case .ld_sp_d16: self.ld_sp_d16(self.next16)
/* 0x32 */ case .ld_pHLD_a: self.ld_pHLD_a()
/* 0x33 */ case .inc_sp: self.inc_sp()
/* 0x34 */ case .inc_pHL: self.inc_pHL()
/* 0x35 */ case .dec_pHL: self.dec_pHL()
/* 0x36 */ case .ld_pHL_d8: self.ld_pHL_d8(self.next8)
/* 0x37 */ case .scf: break // <--
/* 0x38 */ case .jr_c_r8: self.jr_cc_e(.c, self.next8)
/* 0x39 */ case .add_hl_sp: self.add_hl_sp()
/* 0x3a */ case .ld_a_pHLD: self.ld_a_pHLD()
/* 0x3b */ case .dec_sp: self.dec_sp()
/* 0x3c */ case .inc_a: self.inc_r(.a)
/* 0x3d */ case .dec_a: self.dec_r(.a)
/* 0x3e */ case .ld_a_d8: self.ld_r_d8(.a, self.next8)
/* 0x3f */ case .ccf: break // <--
/* 0x40 */ case .ld_b_b: self.ld_r_r(.b, .b)
/* 0x41 */ case .ld_b_c: self.ld_r_r(.b, .c)
/* 0x42 */ case .ld_b_d: self.ld_r_r(.b, .d)
/* 0x43 */ case .ld_b_e: self.ld_r_r(.b, .e)
/* 0x44 */ case .ld_b_h: self.ld_r_r(.b, .h)
/* 0x45 */ case .ld_b_l: self.ld_r_r(.b, .l)
/* 0x46 */ case .ld_b_pHL: self.ld_r_pHL(.b)
/* 0x47 */ case .ld_b_a: self.ld_r_r(.b, .a)
/* 0x48 */ case .ld_c_b: self.ld_r_r(.c, .b)
/* 0x49 */ case .ld_c_c: self.ld_r_r(.c, .c)
/* 0x4a */ case .ld_c_d: self.ld_r_r(.c, .d)
/* 0x4b */ case .ld_c_e: self.ld_r_r(.c, .e)
/* 0x4c */ case .ld_c_h: self.ld_r_r(.c, .h)
/* 0x4d */ case .ld_c_l: self.ld_r_r(.c, .l)
/* 0x4e */ case .ld_c_pHL: self.ld_r_pHL(.c)
/* 0x4f */ case .ld_c_a: self.ld_r_r(.c, .a)
/* 0x50 */ case .ld_d_b: self.ld_r_r(.d, .b)
/* 0x51 */ case .ld_d_c: self.ld_r_r(.d, .c)
/* 0x52 */ case .ld_d_d: self.ld_r_r(.d, .d)
/* 0x53 */ case .ld_d_e: self.ld_r_r(.d, .e)
/* 0x54 */ case .ld_d_h: self.ld_r_r(.d, .h)
/* 0x55 */ case .ld_d_l: self.ld_r_r(.d, .l)
/* 0x56 */ case .ld_d_pHL: self.ld_r_pHL(.d)
/* 0x57 */ case .ld_d_a: self.ld_r_r(.d, .a)
/* 0x58 */ case .ld_e_b: self.ld_r_r(.e, .b)
/* 0x59 */ case .ld_e_c: self.ld_r_r(.e, .c)
/* 0x5a */ case .ld_e_d: self.ld_r_r(.e, .d)
/* 0x5b */ case .ld_e_e: self.ld_r_r(.e, .e)
/* 0x5c */ case .ld_e_h: self.ld_r_r(.e, .h)
/* 0x5d */ case .ld_e_l: self.ld_r_r(.e, .l)
/* 0x5e */ case .ld_e_pHL: self.ld_r_pHL(.e)
/* 0x5f */ case .ld_e_a: self.ld_r_r(.e, .a)
/* 0x60 */ case .ld_h_b: self.ld_r_r(.h, .b)
/* 0x61 */ case .ld_h_c: self.ld_r_r(.h, .c)
/* 0x62 */ case .ld_h_d: self.ld_r_r(.h, .d)
/* 0x63 */ case .ld_h_e: self.ld_r_r(.h, .e)
/* 0x64 */ case .ld_h_h: self.ld_r_r(.h, .h)
/* 0x65 */ case .ld_h_l: self.ld_r_r(.h, .l)
/* 0x66 */ case .ld_h_pHL: self.ld_r_pHL(.h)
/* 0x67 */ case .ld_h_a: self.ld_r_r(.h, .a)
/* 0x68 */ case .ld_l_b: self.ld_r_r(.l, .b)
/* 0x69 */ case .ld_l_c: self.ld_r_r(.l, .c)
/* 0x6a */ case .ld_l_d: self.ld_r_r(.l, .d)
/* 0x6b */ case .ld_l_e: self.ld_r_r(.l, .e)
/* 0x6c */ case .ld_l_h: self.ld_r_r(.l, .h)
/* 0x6d */ case .ld_l_l: self.ld_r_r(.l, .l)
/* 0x6e */ case .ld_l_pHL: self.ld_r_pHL(.l)
/* 0x6f */ case .ld_l_a: self.ld_r_r(.l, .a)
/* 0x70 */ case .ld_pHL_b: self.ld_pHL_r(.b)
/* 0x71 */ case .ld_pHL_c: self.ld_pHL_r(.c)
/* 0x72 */ case .ld_pHL_d: self.ld_pHL_r(.d)
/* 0x73 */ case .ld_pHL_e: self.ld_pHL_r(.e)
/* 0x74 */ case .ld_pHL_h: self.ld_pHL_r(.h)
/* 0x75 */ case .ld_pHL_l: self.ld_pHL_r(.l)
/* 0x76 */ case .halt: break // <--
/* 0x77 */ case .ld_pHL_a: self.ld_pHL_r(.a)
/* 0x78 */ case .ld_a_b: self.ld_r_r(.a, .b)
/* 0x79 */ case .ld_a_c: self.ld_r_r(.a, .c)
/* 0x7a */ case .ld_a_d: self.ld_r_r(.a, .d)
/* 0x7b */ case .ld_a_e: self.ld_r_r(.a, .e)
/* 0x7c */ case .ld_a_h: self.ld_r_r(.a, .h)
/* 0x7d */ case .ld_a_l: self.ld_r_r(.a, .l)
/* 0x7e */ case .ld_a_pHL: self.ld_r_pHL(.a)
/* 0x7f */ case .ld_a_a: self.ld_r_r(.a, .a)
/* 0x80 */ case .add_a_b: self.add_a_r(.b)
/* 0x81 */ case .add_a_c: self.add_a_r(.c)
/* 0x82 */ case .add_a_d: self.add_a_r(.d)
/* 0x83 */ case .add_a_e: self.add_a_r(.e)
/* 0x84 */ case .add_a_h: self.add_a_r(.h)
/* 0x85 */ case .add_a_l: self.add_a_r(.l)
/* 0x86 */ case .add_a_pHL: self.add_a_pHL()
/* 0x87 */ case .add_a_a: self.add_a_r(.a)
/* 0x88 */ case .adc_a_b: self.adc_a_r(.b)
/* 0x89 */ case .adc_a_c: self.adc_a_r(.c)
/* 0x8a */ case .adc_a_d: self.adc_a_r(.d)
/* 0x8b */ case .adc_a_e: self.adc_a_r(.e)
/* 0x8c */ case .adc_a_h: self.adc_a_r(.h)
/* 0x8d */ case .adc_a_l: self.adc_a_r(.l)
/* 0x8e */ case .adc_a_pHL: self.adc_a_pHL()
/* 0x8f */ case .adc_a_a: self.adc_a_r(.a)
/* 0x90 */ case .sub_b: self.sub_a_r(.b)
/* 0x91 */ case .sub_c: self.sub_a_r(.c)
/* 0x92 */ case .sub_d: self.sub_a_r(.d)
/* 0x93 */ case .sub_e: self.sub_a_r(.e)
/* 0x94 */ case .sub_h: self.sub_a_r(.h)
/* 0x95 */ case .sub_l: self.sub_a_r(.l)
/* 0x96 */ case .sub_pHL: self.sub_a_pHL()
/* 0x97 */ case .sub_a: self.sub_a_r(.a)
/* 0x98 */ case .sbc_a_b: self.sbc_a_r(.b)
/* 0x99 */ case .sbc_a_c: self.sbc_a_r(.c)
/* 0x9a */ case .sbc_a_d: self.sbc_a_r(.d)
/* 0x9b */ case .sbc_a_e: self.sbc_a_r(.e)
/* 0x9c */ case .sbc_a_h: self.sbc_a_r(.h)
/* 0x9d */ case .sbc_a_l: self.sbc_a_r(.l)
/* 0x9e */ case .sbc_a_pHL: self.sbc_a_pHL()
/* 0x9f */ case .sbc_a_a: self.sbc_a_r(.a)
/* 0xa0 */ case .and_b: self.and_a_r(.b)
/* 0xa1 */ case .and_c: self.and_a_r(.c)
/* 0xa2 */ case .and_d: self.and_a_r(.d)
/* 0xa3 */ case .and_e: self.and_a_r(.e)
/* 0xa4 */ case .and_h: self.and_a_r(.h)
/* 0xa5 */ case .and_l: self.and_a_r(.l)
/* 0xa6 */ case .and_pHL: self.and_a_pHL()
/* 0xa7 */ case .and_a: self.and_a_r(.a)
/* 0xa8 */ case .xor_b: self.xor_a_r(.b)
/* 0xa9 */ case .xor_c: self.xor_a_r(.c)
/* 0xaa */ case .xor_d: self.xor_a_r(.d)
/* 0xab */ case .xor_e: self.xor_a_r(.e)
/* 0xac */ case .xor_h: self.xor_a_r(.h)
/* 0xad */ case .xor_l: self.xor_a_r(.l)
/* 0xae */ case .xor_pHL: self.xor_a_pHL()
/* 0xaf */ case .xor_a: self.xor_a_r(.a)
/* 0xb0 */ case .or_b: self.or_a_r(.b)
/* 0xb1 */ case .or_c: self.or_a_r(.c)
/* 0xb2 */ case .or_d: self.or_a_r(.d)
/* 0xb3 */ case .or_e: self.or_a_r(.e)
/* 0xb4 */ case .or_h: self.or_a_r(.h)
/* 0xb5 */ case .or_l: self.or_a_r(.l)
/* 0xb6 */ case .or_pHL: self.or_a_pHL()
/* 0xb7 */ case .or_a: self.or_a_r(.a)
/* 0xb8 */ case .cp_b: self.cp_a_r(.b)
/* 0xb9 */ case .cp_c: self.cp_a_r(.c)
/* 0xba */ case .cp_d: self.cp_a_r(.d)
/* 0xbb */ case .cp_e: self.cp_a_r(.e)
/* 0xbc */ case .cp_h: self.cp_a_r(.h)
/* 0xbd */ case .cp_l: self.cp_a_r(.l)
/* 0xbe */ case .cp_pHL: self.cp_a_pHL()
/* 0xbf */ case .cp_a: self.cp_a_r(.a)
/* 0xc0 */ case .ret_nz: self.ret_cc(.nz)
/* 0xc1 */ case .pop_bc: self.pop(.bc)
/* 0xc2 */ case .jp_nz_a16: self.jp_cc_nn(.nz, self.next16)
/* 0xc3 */ case .jp_a16: self.jp_nn(self.next16)
/* 0xc4 */ case .call_nz_a16: self.call_cc_a16(.nz, self.next16)
/* 0xc5 */ case .push_bc: self.push(.bc)
/* 0xc6 */ case .add_a_d8: self.add_a_d8(self.next8)
/* 0xc7 */ case .rst_00: self.rst(0x00)
/* 0xc8 */ case .ret_z: self.ret_cc(.z)
/* 0xc9 */ case .ret: self.ret()
/* 0xca */ case .jp_z_a16: self.jp_cc_nn(.z, self.next16)
/* 0xcb */ case .prefix_cb: break // <--
/* 0xcc */ case .call_z_a16: self.call_cc_a16(.z, self.next16)
/* 0xcd */ case .call_a16: self.call_a16(self.next16)
/* 0xce */ case .adc_a_d8: self.adc_a_d8(self.next8)
/* 0xcf */ case .rst_08: self.rst(0x08)
/* 0xd0 */ case .ret_nc: self.ret_cc(.nc)
/* 0xd1 */ case .pop_de: self.pop(.de)
/* 0xd2 */ case .jp_nc_a16: self.jp_cc_nn(.nc, self.next16)
/* 0xd4 */ case .call_nc_a16: self.call_cc_a16(.nc, self.next16)
/* 0xd5 */ case .push_de: self.push(.de)
/* 0xd6 */ case .sub_d8: self.sub_a_d8(self.next8)
/* 0xd7 */ case .rst_10: self.rst(0x10)
/* 0xd8 */ case .ret_c: self.ret_cc(.c)
/* 0xd9 */ case .reti: self.reti()
/* 0xda */ case .jp_c_a16: self.jp_cc_nn(.c, self.next16)
/* 0xdc */ case .call_c_a16: self.call_cc_a16(.c, self.next16)
/* 0xde */ case .sbc_a_d8: self.sbc_a_d8(self.next8)
/* 0xdf */ case .rst_18: self.rst(0x18)
/* 0xe0 */ case .ldh_pA8_a: self.ld_pA8_a(self.next8)
/* 0xe1 */ case .pop_hl: self.pop(.hl)
/* 0xe2 */ case .ld_pC_a: self.ld_ffC_a()
/* 0xe5 */ case .push_hl: self.push(.hl)
/* 0xe6 */ case .and_d8: self.and_a_d8(self.next8)
/* 0xe7 */ case .rst_20: self.rst(0x20)
/* 0xe8 */ case .add_sp_r8: self.add_sp_r8(self.next8)
/* 0xe9 */ case .jp_pHL: self.jp_pHL()
/* 0xea */ case .ld_pA16_a: self.ld_pA16_a(self.next16)
/* 0xee */ case .xor_d8: self.xor_a_d8(self.next8)
/* 0xef */ case .rst_28: self.rst(0x28)
/* 0xf0 */ case .ldh_a_pA8: self.ld_a_pA8(self.next8)
/* 0xf1 */ case .pop_af: self.pop(.af)
/* 0xf2 */ case .ld_a_pC: self.ld_a_ffC()
/* 0xf3 */ case .di: break // <--
/* 0xf5 */ case .push_af: self.push(.af)
/* 0xf6 */ case .or_d8: self.or_a_d8(self.next8)
/* 0xf7 */ case .rst_30: self.rst(0x30)
/* 0xf8 */ case .ld_hl_spR8: self.ld_hl_sp_plus_e(self.next8)
/* 0xf9 */ case .ld_sp_hl: self.ld_sp_hl()
/* 0xfa */ case .ld_a_pA16: self.ld_a_pA16(self.next16)
/* 0xfb */ case .ei: break // <--
/* 0xfe */ case .cp_d8: self.cp_a_d8(self.next8)
/* 0xff */ case .rst_38: self.rst(0x38)
    }
  }
}
