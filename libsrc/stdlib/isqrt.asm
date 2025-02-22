;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

SECTION code_clib
PUBLIC isqrt
PUBLIC _isqrt
PUBLIC ___isqrt
PUBLIC isqrt_fastcall
PUBLIC _isqrt_fastcall

; ----- uint __FASTCALL__ isqrt(uint val)

isqrt:
_isqrt:
___isqrt:
IF __CPU_GBZ80__
   ld  hl,sp+2
   ld  a,(hl+)
   ld  h,(hl)
   ld  l,a
ELIF __CPU_RABBIT__ | __CPU_KC160__
   ld hl,(sp+2)
ELSE
   pop de
   pop hl
   push hl
   push de
ENDIF

.isqrt_fastcall
._isqrt_fastcall

   ld b,l                    ; b = LSB of val
   ld l,h                    ; l = MSB of val
   xor a                     ; result
   ld h,a
   ld de,1
 
.sqrt1

   or a
   sbc hl,de
   jr c, sqrt2
   inc de
   inc de
   add a,$10                 ; result += 16
   jp sqrt1

.sqrt2

   add hl,de                 ; take back SBC HL, DE
   ld c,a                    ; save result
   ld e,a                    ; save result * 16 in E
   inc a                     ; result * 16 + 1
   add a,e                   ; add to E
   ld e,a                    ; start subtracting here
   ld d,0
   ld a,c                    ; get result
   ld h,l                    ; val <<= 8
   ld l,b                    ; + LSB(val)

.sqrt3

   or a
   sbc hl,de
   jr c, sqrt4
   inc de
   inc de
   inc a                     ; result += 1
   jp sqrt3

.sqrt4

   add hl,de                 ; take back SBC HL, DE
   ld l,a                    ; result in HL
   ret
