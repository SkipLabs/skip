
/home/julienv/skip/lean4/build/simp-demo/binaries/47416933818fbca62445456d526abdbe4b888aed/lean4-simp:     file format elf64-littleaarch64


Disassembly of section .text:

000000000043aa48 <sk.leanArrayRead+0x68>:
  43aa48:	7100091f 	cmp	w8, #0x2
  43aa4c:	54000061 	b.ne	43aa58 <sk.leanArrayRead+0x78>  // b.any
  43aa50:	f9400000 	ldr	x0, [x0]
  43aa54:	17fffffb 	b	43aa40 <sk.leanArrayRead+0x60>
  43aa58:	34000108 	cbz	w8, 43aa78 <sk.leanArrayRead+0x98>
  43aa5c:	7100051f 	cmp	w8, #0x1
  43aa60:	540001e1 	b.ne	43aa9c <sk.leanArrayRead+0xbc>  // b.any
  43aa64:	f9400008 	ldr	x8, [x0]
  43aa68:	f9400108 	ldr	x8, [x8]
  43aa6c:	b85f411c 	ldur	w28, [x8, #-12]
  43aa70:	370000b4 	tbnz	w20, #0, 43aa84 <sk.leanArrayRead+0xa4>
  43aa74:	1400000f 	b	43aab0 <sk.leanArrayRead+0xd0>
  43aa78:	97ff3517 	bl	407ed4 <sk.leanArray>
  43aa7c:	b85f401c 	ldur	w28, [x0, #-12]
  43aa80:	36000194 	tbz	w20, #0, 43aab0 <sk.leanArrayRead+0xd0>
  43aa84:	f85f82a8 	ldur	x8, [x21, #-8]
  43aa88:	39404108 	ldrb	w8, [x8, #16]
  43aa8c:	36000308 	tbz	w8, #0, 43aaec <sk.leanArrayRead+0x10c>
  43aa90:	aa1503e0 	mov	x0, x21
  43aa94:	97ff33c1 	bl	407998 <sk.leanWordBitsOther>
  43aa98:	14000016 	b	43aaf0 <sk.leanArrayRead+0x110>
  43aa9c:	f9400008 	ldr	x8, [x0]
  43aaa0:	f9400909 	ldr	x9, [x8, #16]
  43aaa4:	39406508 	ldrb	w8, [x8, #25]
  43aaa8:	8b08013c 	add	x28, x9, x8
  43aaac:	3707fed4 	tbnz	w20, #0, 43aa84 <sk.leanArrayRead+0xa4>
  43aab0:	aa1503e0 	mov	x0, x21
  43aab4:	97ff3756 	bl	40880c <sk.leanNat>
  43aab8:	b7f818bc 	tbnz	x28, #63, 43adcc <sk.leanArrayRead+0x3ec>
  43aabc:	aa0003f8 	mov	x24, x0
  43aac0:	f104039f 	cmp	x28, #0x100
  43aac4:	540001c2 	b.cs	43aafc <sk.leanArrayRead+0x11c>  // b.hs, b.nlast
  43aac8:	396b5328 	ldrb	w8, [x25, #2772]
  43aacc:	37080048 	tbnz	w8, #1, 43aad4 <sk.leanArrayRead+0xf4>
  43aad0:	97ff35a6 	bl	408168 <sk.leanSmallNaturals__initializeConst>
  43aad4:	f9426368 	ldr	x8, [x27, #1216]
  43aad8:	b85f4109 	ldur	w9, [x8, #-12]
  43aadc:	eb09039f 	cmp	x28, x9
  43aae0:	540017c2 	b.cs	43add8 <sk.leanArrayRead+0x3f8>  // b.hs, b.nlast
  43aae4:	f87c7900 	ldr	x0, [x8, x28, lsl #3]
  43aae8:	14000009 	b	43ab0c <sk.leanArrayRead+0x12c>
  43aaec:	f94006a0 	ldr	x0, [x21, #8]
  43aaf0:	eb1c001f 	cmp	x0, x28
  43aaf4:	54000943 	b.cc	43ac1c <sk.leanArrayRead+0x23c>  // b.lo, b.ul, b.last
  43aaf8:	140000b2 	b	43adc0 <sk.leanArrayRead+0x3e0>
  43aafc:	52800200 	mov	w0, #0x10                  	// #16
  43ab00:	94185271 	bl	a4f4c4 <SKIP_Obstack_alloc>
  43ab04:	f9000013 	str	x19, [x0]
  43ab08:	f8008c1c 	str	x28, [x0, #8]!
  43ab0c:	f85f8308 	ldur	x8, [x24, #-8]
  43ab10:	f85f8009 	ldur	x9, [x0, #-8]
  43ab14:	39406108 	ldrb	w8, [x8, #24]
  43ab18:	39406129 	ldrb	w9, [x9, #24]
  43ab1c:	360002a8 	tbz	w8, #0, 43ab70 <sk.leanArrayRead+0x190>
  43ab20:	360014a9 	tbz	w9, #0, 43adb4 <sk.leanArrayRead+0x3d4>
  43ab24:	f940030a 	ldr	x10, [x24]
  43ab28:	f9400009 	ldr	x9, [x0]
  43ab2c:	b85f4148 	ldur	w8, [x10, #-12]
  43ab30:	b85f412b 	ldur	w11, [x9, #-12]
  43ab34:	6b0b011f 	cmp	w8, w11
  43ab38:	540004e1 	b.ne	43abd4 <sk.leanArrayRead+0x1f4>  // b.any
  43ab3c:	d1002129 	sub	x9, x9, #0x8
  43ab40:	d100214a 	sub	x10, x10, #0x8
  43ab44:	f100050b 	subs	x11, x8, #0x1
  43ab48:	5400054b 	b.lt	43abf0 <sk.leanArrayRead+0x210>  // b.tstop
  43ab4c:	f868794c 	ldr	x12, [x10, x8, lsl #3]
  43ab50:	f8687928 	ldr	x8, [x9, x8, lsl #3]
  43ab54:	eb08019f 	cmp	x12, x8
  43ab58:	aa0b03e8 	mov	x8, x11
  43ab5c:	54ffff40 	b.eq	43ab44 <sk.leanArrayRead+0x164>  // b.none
  43ab60:	b0003b48 	adrp	x8, ba3000 <GCC_except_table10+0x7288>
  43ab64:	9120c108 	add	x8, x8, #0x830
  43ab68:	9a88b2e0 	csel	x0, x23, x8, lt	// lt = tstop
  43ab6c:	14000023 	b	43abf8 <sk.leanArrayRead+0x218>
  43ab70:	370000a9 	tbnz	w9, #0, 43ab84 <sk.leanArrayRead+0x1a4>
  43ab74:	f9400309 	ldr	x9, [x24]
  43ab78:	f940000a 	ldr	x10, [x0]
  43ab7c:	eb0a013f 	cmp	x9, x10
  43ab80:	540011aa 	b.ge	43adb4 <sk.leanArrayRead+0x3d4>  // b.tcont
  43ab84:	360004a8 	tbz	w8, #0, 43ac18 <sk.leanArrayRead+0x238>
  43ab88:	f9400309 	ldr	x9, [x24]
  43ab8c:	b85f4128 	ldur	w8, [x9, #-12]
  43ab90:	340002c8 	cbz	w8, 43abe8 <sk.leanArrayRead+0x208>
  43ab94:	8b080d29 	add	x9, x9, x8, lsl #3
  43ab98:	aa1f03e0 	mov	x0, xzr
  43ab9c:	91000508 	add	x8, x8, #0x1
  43aba0:	d1002129 	sub	x9, x9, #0x8
  43aba4:	f85f852a 	ldr	x10, [x9], #-8
  43aba8:	d240f94b 	eor	x11, x10, #0x7fffffffffffffff
  43abac:	9b5d7d6b 	smulh	x11, x11, x29
  43abb0:	935afd6c 	asr	x12, x11, #26
  43abb4:	8b4bfd8b 	add	x11, x12, x11, lsr #63
  43abb8:	eb0b001f 	cmp	x0, x11
  43abbc:	54000f6c 	b.gt	43ada8 <sk.leanArrayRead+0x3c8>
  43abc0:	9b1a2800 	madd	x0, x0, x26, x10
  43abc4:	d1000508 	sub	x8, x8, #0x1
  43abc8:	f100051f 	cmp	x8, #0x1
  43abcc:	54fffec8 	b.hi	43aba4 <sk.leanArrayRead+0x1c4>  // b.pmore
  43abd0:	14000013 	b	43ac1c <sk.leanArrayRead+0x23c>
  43abd4:	6b0b011f 	cmp	w8, w11
  43abd8:	b0003b48 	adrp	x8, ba3000 <GCC_except_table10+0x7288>
  43abdc:	9120c108 	add	x8, x8, #0x830
  43abe0:	9a8832e0 	csel	x0, x23, x8, cc	// cc = lo, ul, last
  43abe4:	14000005 	b	43abf8 <sk.leanArrayRead+0x218>
  43abe8:	aa1f03e0 	mov	x0, xzr
  43abec:	1400000c 	b	43ac1c <sk.leanArrayRead+0x23c>
  43abf0:	b0003b40 	adrp	x0, ba3000 <GCC_except_table10+0x7288>
  43abf4:	9120a000 	add	x0, x0, #0x828
  43abf8:	f85f8008 	ldur	x8, [x0, #-8]
  43abfc:	aa1703e1 	mov	x1, x23
  43ac00:	f9400908 	ldr	x8, [x8, #16]
  43ac04:	d63f0100 	blr	x8
  43ac08:	34000d60 	cbz	w0, 43adb4 <sk.leanArrayRead+0x3d4>
  43ac0c:	f85f8308 	ldur	x8, [x24, #-8]
  43ac10:	39406108 	ldrb	w8, [x8, #24]
  43ac14:	3707fba8 	tbnz	w8, #0, 43ab88 <sk.leanArrayRead+0x1a8>
  43ac18:	f9400300 	ldr	x0, [x24]
  43ac1c:	f85f82c8 	ldur	x8, [x22, #-8]
  43ac20:	39412108 	ldrb	w8, [x8, #72]
  43ac24:	7100091f 	cmp	w8, #0x2
  43ac28:	540000e1 	b.ne	43ac44 <sk.leanArrayRead+0x264>  // b.any
  43ac2c:	f9400ac8 	ldr	x8, [x22, #16]
  43ac30:	f94002c1 	ldr	x1, [x22]
  43ac34:	eb08001f 	cmp	x0, x8
  43ac38:	54fff001 	b.ne	43aa38 <sk.leanArrayRead+0x58>  // b.any
  43ac3c:	f94006c0 	ldr	x0, [x22, #8]
  43ac40:	14000052 	b	43ad88 <sk.leanArrayRead+0x3a8>
  43ac44:	340007c8 	cbz	w8, 43ad3c <sk.leanArrayRead+0x35c>
  43ac48:	7100051f 	cmp	w8, #0x1
  43ac4c:	54000881 	b.ne	43ad5c <sk.leanArrayRead+0x37c>  // b.any
  43ac50:	f94002d7 	ldr	x23, [x22]
  43ac54:	f94002e8 	ldr	x8, [x23]
  43ac58:	b85f4109 	ldur	w9, [x8, #-12]
  43ac5c:	eb09001f 	cmp	x0, x9
  43ac60:	54000bc2 	b.cs	43add8 <sk.leanArrayRead+0x3f8>  // b.hs, b.nlast
  43ac64:	f94007e9 	ldr	x9, [sp, #8]
  43ac68:	f9401934 	ldr	x20, [x9, #48]
  43ac6c:	b4000c34 	cbz	x20, 43adf0 <sk.leanArrayRead+0x410>
  43ac70:	f94006f5 	ldr	x21, [x23, #8]
  43ac74:	f8607913 	ldr	x19, [x8, x0, lsl #3]
  43ac78:	aa1403e0 	mov	x0, x20
  43ac7c:	f9400aa1 	ldr	x1, [x21, #16]
  43ac80:	97ffe658 	bl	4345e0 <sk.SKStore_Context__getDir>
  43ac84:	f85f8008 	ldur	x8, [x0, #-8]
  43ac88:	f9400d08 	ldr	x8, [x8, #24]
  43ac8c:	d63f0100 	blr	x8
  43ac90:	f85f8008 	ldur	x8, [x0, #-8]
  43ac94:	aa1403e1 	mov	x1, x20
  43ac98:	aa1303e2 	mov	x2, x19
  43ac9c:	f9400908 	ldr	x8, [x8, #16]
  43aca0:	d63f0100 	blr	x8
  43aca4:	aa0003f6 	mov	x22, x0
  43aca8:	f94006b9 	ldr	x25, [x21, #8]
  43acac:	b85f4018 	ldur	w24, [x0, #-12]
  43acb0:	52800300 	mov	w0, #0x18                  	// #24
  43acb4:	94185204 	bl	a4f4c4 <SKIP_Obstack_alloc>
  43acb8:	d0003e48 	adrp	x8, c04000 <__do_global_dtors_aux_fini_array_entry+0x60808>
  43acbc:	9103c108 	add	x8, x8, #0xf0
  43acc0:	aa0003f4 	mov	x20, x0
  43acc4:	f9000008 	str	x8, [x0]
  43acc8:	d37df308 	lsl	x8, x24, #3
  43accc:	aa0003f5 	mov	x21, x0
  43acd0:	f9000816 	str	x22, [x0, #16]
  43acd4:	91004100 	add	x0, x8, #0x10
  43acd8:	f8008eb9 	str	x25, [x21, #8]!
  43acdc:	94185238 	bl	a4f5bc <SKIP_Obstack_calloc>
  43ace0:	340007f8 	cbz	w24, 43addc <sk.leanArrayRead+0x3fc>
  43ace4:	aa1f03f6 	mov	x22, xzr
  43ace8:	91004019 	add	x25, x0, #0x10
  43acec:	f9400288 	ldr	x8, [x20]
  43acf0:	aa1503e0 	mov	x0, x21
  43acf4:	aa1603e1 	mov	x1, x22
  43acf8:	910006da 	add	x26, x22, #0x1
  43acfc:	f9400108 	ldr	x8, [x8]
  43ad00:	d63f0100 	blr	x8
  43ad04:	eb1a031f 	cmp	x24, x26
  43ad08:	f8367b20 	str	x0, [x25, x22, lsl #3]
  43ad0c:	aa1a03f6 	mov	x22, x26
  43ad10:	54fffee1 	b.ne	43acec <sk.leanArrayRead+0x30c>  // b.any
  43ad14:	7100071f 	cmp	w24, #0x1
  43ad18:	54000621 	b.ne	43addc <sk.leanArrayRead+0x3fc>  // b.any
  43ad1c:	394042e9 	ldrb	w9, [x23, #16]
  43ad20:	f9400328 	ldr	x8, [x25]
  43ad24:	36000309 	tbz	w9, #0, 43ad84 <sk.leanArrayRead+0x3a4>
  43ad28:	f9400500 	ldr	x0, [x8, #8]
  43ad2c:	b50002e0 	cbnz	x0, 43ad88 <sk.leanArrayRead+0x3a8>
  43ad30:	b0003340 	adrp	x0, aa3000 <_IO_stdin_used+0x3e200>
  43ad34:	910e2000 	add	x0, x0, #0x388
  43ad38:	97ff3267 	bl	4076d4 <leanFail>
  43ad3c:	aa0003f3 	mov	x19, x0
  43ad40:	aa1603e0 	mov	x0, x22
  43ad44:	97ff3464 	bl	407ed4 <sk.leanArray>
  43ad48:	b85f4009 	ldur	w9, [x0, #-12]
  43ad4c:	eb09027f 	cmp	x19, x9
  43ad50:	54000442 	b.cs	43add8 <sk.leanArrayRead+0x3f8>  // b.hs, b.nlast
  43ad54:	f8737800 	ldr	x0, [x0, x19, lsl #3]
  43ad58:	1400000c 	b	43ad88 <sk.leanArrayRead+0x3a8>
  43ad5c:	aa0003e1 	mov	x1, x0
  43ad60:	f94002c0 	ldr	x0, [x22]
  43ad64:	a9464ff4 	ldp	x20, x19, [sp, #96]
  43ad68:	a94557f6 	ldp	x22, x21, [sp, #80]
  43ad6c:	a9445ff8 	ldp	x24, x23, [sp, #64]
  43ad70:	a94367fa 	ldp	x26, x25, [sp, #48]
  43ad74:	a9426ffc 	ldp	x28, x27, [sp, #32]
  43ad78:	a9417bfd 	ldp	x29, x30, [sp, #16]
  43ad7c:	9101c3ff 	add	sp, sp, #0x70
  43ad80:	17fffee2 	b	43a908 <sk.Persistent_RadixTreeVector__get>
  43ad84:	f9400100 	ldr	x0, [x8]
  43ad88:	a9464ff4 	ldp	x20, x19, [sp, #96]
  43ad8c:	a94557f6 	ldp	x22, x21, [sp, #80]
  43ad90:	a9445ff8 	ldp	x24, x23, [sp, #64]
  43ad94:	a94367fa 	ldp	x26, x25, [sp, #48]
  43ad98:	a9426ffc 	ldp	x28, x27, [sp, #32]
  43ad9c:	a9417bfd 	ldp	x29, x30, [sp, #16]
  43ada0:	9101c3ff 	add	sp, sp, #0x70
  43ada4:	d65f03c0 	ret
  43ada8:	b0003340 	adrp	x0, aa3000 <_IO_stdin_used+0x3e200>
  43adac:	9103a000 	add	x0, x0, #0xe8
  43adb0:	97ff21a4 	bl	403440 <sk.invariant_violation.9>
  43adb4:	b0003340 	adrp	x0, aa3000 <_IO_stdin_used+0x3e200>
  43adb8:	910a6000 	add	x0, x0, #0x298
  43adbc:	97ff32f0 	bl	40797c <sk.leanFail.3>
  43adc0:	b0003340 	adrp	x0, aa3000 <_IO_stdin_used+0x3e200>
  43adc4:	910ba000 	add	x0, x0, #0x2e8
  43adc8:	97ff32ed 	bl	40797c <sk.leanFail.3>
  43adcc:	b0003780 	adrp	x0, b2b000 <_IO_stdin_used+0xc6200>
  43add0:	910ca000 	add	x0, x0, #0x328
  43add4:	97ff219b 	bl	403440 <sk.invariant_violation.9>
  43add8:	97ff21d6 	bl	403530 <sk.throwOutOfBounds.1>
  43addc:	f9400661 	ldr	x1, [x19, #8]
  43ade0:	b0003340 	adrp	x0, aa3000 <_IO_stdin_used+0x3e200>
  43ade4:	910f2000 	add	x0, x0, #0x3c8
  43ade8:	94185889 	bl	a5100c <SKIP_String_concat2>
  43adec:	97ff32e4 	bl	40797c <sk.leanFail.3>
  43adf0:	b0003340 	adrp	x0, aa3000 <_IO_stdin_used+0x3e200>
  43adf4:	910d4000 	add	x0, x0, #0x350
  43adf8:	97ff3237 	bl	4076d4 <leanFail>

000000000043adfc <sk.Persistent_RadixTreeVector___ConcreteMetaImpl__mcreateFromItems>:
  43adfc:	f81d0ffe 	str	x30, [sp, #-48]!
  43ae00:	a90157f6 	stp	x22, x21, [sp, #16]
  43ae04:	a9024ff4 	stp	x20, x19, [sp, #32]
  43ae08:	f85f8008 	ldur	x8, [x0, #-8]
  43ae0c:	aa0003f3 	mov	x19, x0
