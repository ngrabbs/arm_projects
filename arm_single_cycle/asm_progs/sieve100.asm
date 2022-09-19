;
; Sieve of Eratosthenes
;
; Generate Primes on range 1 to 100
;
; Fill the first 100 locations of RAM with values 1 to 100.
;
.global main

start:
;			mvi		l,100		; HL is the pointer to DRAM
;			mvi		h,0
;			mvi		e,100		; E is max value
;loop0:		mov		m,e			; Store value
;			dcr		l			; Decrement address
;			dcr		e			; Decrement value
;			bnz		loop0		; If value not zero, do again

;; Zero all multiple locations up to Square Root(100) = 10
;;
;			mvi		c,2			; Start with 2 as base value
;loop1:		mov		l,c			; Set DRAM pointer to address of base value
;			or		m,m			; Has the base value been stricken?
;			bz		next_n		; If so, move on to next value to strike
;loop2:		add		l,c			; Otherwise, compute address of multiple
;			mvi		m,0			; Zero location to strike
;			cpi		l,101		; Have multiples 100 or less been stricken?
;			bc		loop2		; If not, strike another
;next_n:		inc		c			; Otherwise, next base value
;			cpi		c,10		; Reached 10?
;			bnz		loop1		; If not, do multiple zeroing again

;;
;; Display Primes in FIrst 100 bytes of MRAM
;;
;			mvi		l,2			; Start at location 2
;			mvi		h,0
;loop3:		or		m,m			; Is value zero?
;			bz		dspl_next	; If so, display next value
;			mov		e,m			; Move prime to DE
;			mvi		d,0
;cont2:		call	dout		; Display DE
;			mvi		b,space
;			call	bout
;dspl_next:	inc		l			; Pointer to next n
;			cpi		l,100		; Past last prime?
;			bc		loop3		; If not, do again
;self:		jmp		self		; Done
;
;			; Done-return to calling routine


;;
;; Output Message at DE IN DROM Routine
;;
;; Message terminates with 0x00 byte
;;
;mout:		lrom	b			; Get first message byte from DROM
;			or		b,b			; Is it zero?
;			bz		mout_done	; If so, done
;			call	bout		; Otherwise, display it
;			inc		e			; Increment DE
;			inz		d
;			jmp		mout		; Do again
;mout_done:	ret

;;
;; End of Program and beginning of data
;;
;data
;;
;eol			equ		13	; End-of-line character
;;
;; End of data
;;
end:
