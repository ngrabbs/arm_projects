	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 12, 3
	.globl	_sum                            ; -- Begin function sum
	.p2align	2
_sum:                                   ; @sum
	.cfi_startproc
; %bb.0:
	add	w0, w1, w0
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh0:
	adrp	x8, _f@GOTPAGE
Lloh1:
	ldr	x8, [x8, _f@GOTPAGEOFF]
	mov	w9, #2
Lloh2:
	str	w9, [x8]
Lloh3:
	adrp	x8, _g@GOTPAGE
Lloh4:
	ldr	x8, [x8, _g@GOTPAGEOFF]
	mov	w9, #3
Lloh5:
	str	w9, [x8]
	mov	w0, #2
	mov	w1, #3
	bl	_sum
Lloh6:
	adrp	x8, _y@GOTPAGE
Lloh7:
	ldr	x8, [x8, _y@GOTPAGEOFF]
Lloh8:
	str	w0, [x8]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGotStr	Lloh6, Lloh7, Lloh8
	.loh AdrpLdrGotStr	Lloh3, Lloh4, Lloh5
	.loh AdrpLdrGotStr	Lloh0, Lloh1, Lloh2
	.cfi_endproc
                                        ; -- End function
	.comm	_f,4,2                          ; @f
	.comm	_g,4,2                          ; @g
	.comm	_y,4,2                          ; @y
.subsections_via_symbols
