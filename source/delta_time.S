#include "helpers.inc"
#include "options.inc"
#include "symbols.inc"

.set patch_section_index, 2

#ifdef DELTA_TIME

patch_text_start call_delta_time
  bl my_delta_time
  nop
  nop
patch_text_end call_delta_time

patch_text_start initialize_flip_mode
  stb %r0, 0x6ED(%r31)
patch_text_end initialize_flip_mode

cave_start my_delta_time
  # get mftb
  mftb %r21                                   // Move from timebase register (clock)

  # get mftb delta
  lis %r22, my_delta_time_previous@h
  addi %r22, %r22, my_delta_time_previous@l
  ld %r20, 0x0(%r22)                          // load previous frames mftb reading
  std %r21, 0x0(%r22)                         // store this frames mftb reading
  subf %r19, %r20, %r21                       // subtract previous mftb reading from this mftb frames reading

  # mftb delta to float
  std %r19, 0x18(%r22)                        // store mftb delta (to be loaded into FPR)
  lfd %f30, 0x18(%r22)                        // load mftb delta into FPR
  fcfid %f30, %f30                            // convert integer to double
  frsp %f30, %f30                             // round to single precision

  # mftb delta to seconds
  lis %r18, my_delta_time_constants@h
  addi %r18, %r18, my_delta_time_constants@l
  lfs %f29, 0x0(%r18)                         // load timebase frequency constant
  lfs %f28, 0x4(%r18)                         // load maximum timestep size
  fdivs %f31, %f30, %f29                      // divide timebase delta by timebase frequency

  # check timestep size
  fcmpu %cr7, %f31, %f28                      // compare current delta time to maximum timestep
  blt %cr7, _skip_return_maximum_timestep     // don't return the maximum timestep size

_return_maximum_timestep:
  # set maximum timestep
  fmr %f31, %f28                              // move maximum timestep to be returned

_skip_return_maximum_timestep:
  # cleanup
  xor %r20, %r20, %r20                        // zero r20
  xor %r19, %r19, %r19                        // zero r19
  blr
cave_end my_delta_time

cave_start my_delta_time_constants
  .float 80000000.0 # timebase frequency (80mhz)
  .float 0.05000000 # maximum timestep size (50ms or 20FPS)
cave_end my_delta_time_constants

#endif
