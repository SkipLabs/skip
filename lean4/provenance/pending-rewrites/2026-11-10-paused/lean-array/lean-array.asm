
/home/julienv/skip/lean4/build/simp-demo/binaries/47416933818fbca62445456d526abdbe4b888aed/lean4-simp:     file format elf64-littleaarch64


Disassembly of section .text:

0000000000407ed4 <sk.leanArray>:
  407ed4:	f81c0ffe 	str	x30, [sp, #-64]!
  407ed8:	a9015ff8 	stp	x24, x23, [sp, #16]
  407edc:	a90257f6 	stp	x22, x21, [sp, #32]
  407ee0:	a9034ff4 	stp	x20, x19, [sp, #48]
  407ee4:	aa0003f3 	mov	x19, x0
  407ee8:	52800200 	mov	w0, #0x10                  	// #16
  407eec:	94191d76 	bl	a4f4c4 <SKIP_Obstack_alloc>
  407ef0:	d0004028 	adrp	x8, c0d000 <__do_global_dtors_aux_fini_array_entry+0x69808>
  407ef4:	913b4108 	add	x8, x8, #0xed0
  407ef8:	f85f8269 	ldur	x9, [x19, #-8]
  407efc:	f9000008 	str	x8, [x0]
  407f00:	f8008c1f 	str	xzr, [x0, #8]!
  407f04:	3940c128 	ldrb	w8, [x9, #48]
  407f08:	7100051f 	cmp	w8, #0x1
  407f0c:	540004ed 	b.le	407fa8 <sk.leanArray+0xd4>
  407f10:	7100091f 	cmp	w8, #0x2
  407f14:	540005a1 	b.ne	407fc8 <sk.leanArray+0xf4>  // b.any
  407f18:	f9400268 	ldr	x8, [x19]
  407f1c:	aa0003f5 	mov	x21, x0
  407f20:	f9000008 	str	x8, [x0]
  407f24:	52800200 	mov	w0, #0x10                  	// #16
  407f28:	f9400909 	ldr	x9, [x8, #16]
  407f2c:	39406508 	ldrb	w8, [x8, #25]
  407f30:	8b080137 	add	x23, x9, x8
  407f34:	94191d64 	bl	a4f4c4 <SKIP_Obstack_alloc>
  407f38:	d0004008 	adrp	x8, c09000 <__do_global_dtors_aux_fini_array_entry+0x65808>
  407f3c:	912a0108 	add	x8, x8, #0xa80
  407f40:	aa0003f4 	mov	x20, x0
  407f44:	f9000008 	str	x8, [x0]
  407f48:	f8008e95 	str	x21, [x20, #8]!
  407f4c:	b7f80597 	tbnz	x23, #63, 407ffc <sk.leanArray+0x128>
  407f50:	d37df2e8 	lsl	x8, x23, #3
  407f54:	aa0003f3 	mov	x19, x0
  407f58:	91004100 	add	x0, x8, #0x10
  407f5c:	94191d98 	bl	a4f5bc <SKIP_Obstack_calloc>
  407f60:	d0003f88 	adrp	x8, bf9000 <__do_global_dtors_aux_fini_array_entry+0x55808>
  407f64:	91086108 	add	x8, x8, #0x218
  407f68:	91004015 	add	x21, x0, #0x10
  407f6c:	b9000417 	str	w23, [x0, #4]
  407f70:	f9000408 	str	x8, [x0, #8]
  407f74:	b40001f7 	cbz	x23, 407fb0 <sk.leanArray+0xdc>
  407f78:	aa1f03f6 	mov	x22, xzr
  407f7c:	f9400268 	ldr	x8, [x19]
  407f80:	aa1403e0 	mov	x0, x20
  407f84:	aa1603e1 	mov	x1, x22
  407f88:	910006d8 	add	x24, x22, #0x1
  407f8c:	f9400108 	ldr	x8, [x8]
  407f90:	d63f0100 	blr	x8
  407f94:	eb1802ff 	cmp	x23, x24
  407f98:	f8367aa0 	str	x0, [x21, x22, lsl #3]
  407f9c:	aa1803f6 	mov	x22, x24
  407fa0:	54fffee1 	b.ne	407f7c <sk.leanArray+0xa8>  // b.any
  407fa4:	14000003 	b	407fb0 <sk.leanArray+0xdc>
  407fa8:	54000241 	b.ne	407ff0 <sk.leanArray+0x11c>  // b.any
  407fac:	f9400275 	ldr	x21, [x19]
  407fb0:	aa1503e0 	mov	x0, x21
  407fb4:	a9434ff4 	ldp	x20, x19, [sp, #48]
  407fb8:	a94257f6 	ldp	x22, x21, [sp, #32]
  407fbc:	a9415ff8 	ldp	x24, x23, [sp, #16]
  407fc0:	f84407fe 	ldr	x30, [sp], #64
  407fc4:	d65f03c0 	ret
  407fc8:	71000d1f 	cmp	w8, #0x3
  407fcc:	54000081 	b.ne	407fdc <sk.leanArray+0x108>  // b.any
  407fd0:	900034c0 	adrp	x0, a9f000 <_IO_stdin_used+0x3a200>
  407fd4:	9108e000 	add	x0, x0, #0x238
  407fd8:	97fffdbf 	bl	4076d4 <leanFail>
  407fdc:	f9400261 	ldr	x1, [x19]
  407fe0:	f0003900 	adrp	x0, b2a000 <_IO_stdin_used+0xc5200>
  407fe4:	911ba000 	add	x0, x0, #0x6e8
  407fe8:	94192409 	bl	a5100c <SKIP_String_concat2>
  407fec:	97fffdba 	bl	4076d4 <leanFail>
  407ff0:	90003920 	adrp	x0, b2b000 <_IO_stdin_used+0xc6200>
  407ff4:	910c2000 	add	x0, x0, #0x308
  407ff8:	97fffdb7 	bl	4076d4 <leanFail>
  407ffc:	90003300 	adrp	x0, a67000 <_IO_stdin_used+0x2200>
  408000:	911f2000 	add	x0, x0, #0x7c8
  408004:	97ffed0f 	bl	403440 <sk.invariant_violation.9>
