.macro patch name, offset
  .section ".patches","aw"
  .quad \offset, \name, end_\name, 0
  .previous
  .org \offset-0x10200
  \name:
.endm

.macro patch2 name, offset
  .section ".patches","aw"
  .quad end_\offset, \name, end_\name, 0
  .previous
  \name:
.endm

.macro patchend name
  end_\name:
.endm

.macro target name, offset
  .org \offset-0x10200
  \name:
.endm
