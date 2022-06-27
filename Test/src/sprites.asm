.include "constants.inc"

.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ;Write a pallete
  LDX PPUSTATUS  
  LDX #$3f    ;Load immediate mode value 3f to X register
  STX PPUADDR
  LDX #$00    ;Load immediate mode value 00 to X register
  STX PPUADDR
  LDA #$2B    
  STA PPUDATA
  LDA #$2B
  STA PPUDATA
  LDA #$1B 
  STA PPUDATA
  LDA #$0B 
  STA PPUDATA
  ;Write sprite data
  LDA #$70 
  STA $0200   ;Y coordinate of first sprite
  LDA #$05
  STA $0201   ;tile number of first sprite
  LDA #00
  STA $0202   ;attributes of first sprite
  LDA #$80
  STA $0203   ;X coordinate of first sprite

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK 

forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics.chr"

