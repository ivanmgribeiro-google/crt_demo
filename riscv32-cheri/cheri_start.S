/*
 * Startup for OpenTitan ROM
 */

#ifdef __CHERI_PURE_CAPABILITY__
  .option nocapmode
#endif
  .option push
  .option norvc
  .option norelax
  .section .vectors, "ax"
  .balign 256
  .global _rom_interrupt_vectors
  .type _rom_interrupt_vectors, @function
_rom_interrupt_vectors:
    .rept 32
    j _exception_handler
    .endr
    j _reset_cheri_start
  .size _rom_interrupt_vectors, .-_rom_interrupt_vectors
  .option pop

  .section .crt, "ax"
  .balign 4
  .global _reset_cheri_start
  .type _reset_cheri_start, @function
_reset_cheri_start:
  /* Clobber all writeable registers. */
  li  x1, 0x0
  li  x2, 0x0
  li  x3, 0x0
  li  x4, 0x0
  li  x5, 0x0
  li  x6, 0x0
  li  x7, 0x0
  li  x8, 0x0
  li  x9, 0x0
  li  x10, 0x0
  li  x11, 0x0
  li  x12, 0x0
  li  x13, 0x0
  li  x14, 0x0
  li  x15, 0x0
  li  x16, 0x0
  li  x17, 0x0
  li  x18, 0x0
  li  x19, 0x0
  li  x20, 0x0
  li  x21, 0x0
  li  x22, 0x0
  li  x23, 0x0
  li  x24, 0x0
  li  x25, 0x0
  li  x26, 0x0
  li  x27, 0x0
  li  x28, 0x0
  li  x29, 0x0
  li  x30, 0x0
  li  x31, 0x0

  # From now on, do purecap ABI but in hybrid mode.
  # Set up stack pointer
  la              sp, _stack
  cfromptr        csp, ddc, sp # Get DDC - almighty cap on boot
  la              t2, _stack_end
  sub             t2, t2, sp # length of the stack
  csetbounds      csp, csp, t2
  cincoffset      csp, csp, t2

  # Initialise the captable.
  cspecialrw      ct0, pcc, cnull # Get PCC.
  la              t1, _start_purecap
  csetoffset      ct0, ct0, t1

#ifdef __riscv_xcheri_mode_dependent_jumps
  jalr.cap        cra, ct0
#else
  cjalr           cra, ct0
#endif

  /*
  ** Set up the global pointer. This requires that we disable linker relaxations
  ** (or it will be relaxed to `mv gp, gp`).
  */
  .option push
  .option norelax
  la  gp, __global_pointer
  .option pop

  li a0, 0x411C0000     /* SRAM_CTRL main base addr */
  li t0, 2              /* CTRL_INIT bit */
  sw t0, 0x14(a0)       /* CTRL register is at 0x14 */

  /* Zero out the `.bss` segment. */
/*
  la   a0, _bss_start
  la   a1, _bss_end
  call crt_section_clear
*/

  /* Initialize the `.data` segment from the `.idata` segment. */
/*
  la   a0, _data_start
  la   a1, _data_end
  la   a2, _data_init_start
  call crt_section_copy
*/

  # From now on, the DDC is always null.
  cmove           ct0, cnull
  cspecialrw      cnull, ddc, ct0 # Write DDC.

  # Set up mtcc and jump to main in purecap mode.
  cspecialrw      ct0, pcc, cnull # Get PCC.

  li              t1, 1
  csetflags       ct0, ct0, t1     # set cap mode on

  la              t1, _exception_handler
  csetoffset      ct0, ct0, t1
  cspecialrw      cnull, mtcc, ct0 # Write MTCC.

  la              t1, _boot_start
  csetoffset      ct0, ct0, t1
#ifdef __riscv_xcheri_mode_dependent_jumps
  jalr.cap        cra, ct0 # jump to main
#else
  cjalr           cra, ct0 # jump to main
#endif

  /* Clobber all temporary registers. */
  li t0, 0x0
  li t1, 0x0
  li t2, 0x0
  li t3, 0x0
  li t4, 0x0
  li t5, 0x0
  li t6, 0x0

  /* Clobber all argument registers. */
  li a0, 0x0
  li a1, 0x0
  li a2, 0x0
  li a3, 0x0
  li a4, 0x0
  li a5, 0x0
  li a6, 0x0
  li a7, 0x0

  /* semihost exit syscall */
  li a0, 0x18
  li a1, 0x20026
  .option norvc
  .option norelax
  .global semihost_call
  .type semihost_call, @function
semihost_call:
    slli zero, zero, 0x1f
    ebreak
    srai zero, zero, 0x7
    ret

  .global _exception_handler
  .type _exception_handler, @function
_exception_handler:
    wfi
