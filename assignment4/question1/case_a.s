# Begin asmlist al_begin
# End asmlist al_begin
# Begin asmlist al_stabs
# End asmlist al_stabs
# Begin asmlist al_procedures

.text
	.align 4
.globl	_PASCALMAIN
_PASCALMAIN:
# Temps allocated between ebp-8 and ebp+0
# [test.pas]
# [9] begin
	pushl	%ebp
	movl	%esp,%ebp
	subl	$8,%esp
	movl	%ebx,-8(%ebp)
	movl	%esi,-4(%ebp)
	call	Lj2
Lj2:
	popl	%esi
	call	LFPC_INITIALIZEUNITS$stub
# [10] alert := green;
	movl	L_U_P$HELLOWORLD_ALERT$non_lazy_ptr-Lj2(%esi),%eax
	movl	$0,(%eax)
# [12] if (alert = green) or (alert = pink) or (alert = black) then WriteLn('S OPT') else WriteLn('T OPT')
	movl	L_U_P$HELLOWORLD_ALERT$non_lazy_ptr-Lj2(%esi),%eax
	movl	(%eax),%eax
	testl	%eax,%eax
	je	Lj5
	jmp	Lj8
Lj8:
	movl	L_U_P$HELLOWORLD_ALERT$non_lazy_ptr-Lj2(%esi),%eax
	movl	(%eax),%eax
	cmpl	$2,%eax
	je	Lj5
	jmp	Lj7
Lj7:
	movl	L_U_P$HELLOWORLD_ALERT$non_lazy_ptr-Lj2(%esi),%eax
	movl	(%eax),%eax
	cmpl	$4,%eax
	je	Lj5
	jmp	Lj6
Lj5:
	call	Lfpc_get_output$stub
	movl	%eax,%ebx
	movl	%ebx,%edx
	movl	L_$HELLOWORLD$_Ld1$non_lazy_ptr-Lj2(%esi),%ecx
	movl	$0,%eax
	call	Lfpc_write_text_shortstr$stub
	call	LFPC_IOCHECK$stub
	movl	%ebx,%eax
	call	Lfpc_writeln_end$stub
	call	LFPC_IOCHECK$stub
	jmp	Lj19
Lj6:
	call	Lfpc_get_output$stub
	movl	%eax,%ebx
	movl	%ebx,%edx
	movl	L_$HELLOWORLD$_Ld2$non_lazy_ptr-Lj2(%esi),%ecx
	movl	$0,%eax
	call	Lfpc_write_text_shortstr$stub
	call	LFPC_IOCHECK$stub
	movl	%ebx,%eax
	call	Lfpc_writeln_end$stub
	call	LFPC_IOCHECK$stub
Lj19:
# [13] end.
	call	LFPC_DO_EXIT$stub
	movl	-8(%ebp),%ebx
	movl	-4(%ebp),%esi
	leave
	ret

.text
	.align 2
.globl	_main
_main:
	jmp	L_FPC_SYSTEMMAIN$stub
# End asmlist al_procedures
# Begin asmlist al_globals


	.align 2
# [7] alert: Color;
.globl _U_P$HELLOWORLD_ALERT
.data
.zerofill __DATA, __common, _U_P$HELLOWORLD_ALERT, 4,2



.data
	.align 2
.globl	_THREADVARLIST_P$HELLOWORLD
_THREADVARLIST_P$HELLOWORLD:
	.long	0
# [14] 

.data
	.align 2
.globl	INITFINAL
INITFINAL:
	.long	1,0
	.long	_INIT$_SYSTEM
	.long	0

.data
	.align 2
.globl	FPC_THREADVARTABLES
FPC_THREADVARTABLES:
	.long	2
	.long	_THREADVARLIST_SYSTEM
	.long	_THREADVARLIST_P$HELLOWORLD

.data
	.align 2
.globl	FPC_RESOURCESTRINGTABLES
FPC_RESOURCESTRINGTABLES:
	.long	0

.data
	.align 2
.globl	FPC_WIDEINITTABLES
FPC_WIDEINITTABLES:
	.long	0

.section __TEXT, .fpc, regular, no_dead_strip
	.align 3
	.ascii	"FPC 2.6.0 [2011/12/30] for i386 - Darwin"

.data
	.align 2
.globl	__stklen
__stklen:
	.long	262144

.data
	.align 2
.globl	__heapsize
__heapsize:
	.long	0

.data
.globl	__fpc_valgrind
__fpc_valgrind:
	.byte	0

.data
	.align 2
.globl	FPC_RESLOCATION
FPC_RESLOCATION:
	.long	0
# End asmlist al_globals
# Begin asmlist al_const
# End asmlist al_const
# Begin asmlist al_typedconsts

.const
	.align 2
.globl	_$HELLOWORLD$_Ld1
_$HELLOWORLD$_Ld1:
	.ascii	"\005S OPT\000"

.const
	.align 2
.globl	_$HELLOWORLD$_Ld2
_$HELLOWORLD$_Ld2:
	.ascii	"\005T OPT\000"
# End asmlist al_typedconsts
# Begin asmlist al_rotypedconsts
# End asmlist al_rotypedconsts
# Begin asmlist al_threadvars
# End asmlist al_threadvars
# Begin asmlist al_imports

.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5

Lfpc_get_output$stub:
.indirect_symbol fpc_get_output
	hlt
	hlt
	hlt
	hlt
	hlt

.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5

Lfpc_write_text_shortstr$stub:
.indirect_symbol fpc_write_text_shortstr
	hlt
	hlt
	hlt
	hlt
	hlt

.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5

LFPC_IOCHECK$stub:
.indirect_symbol FPC_IOCHECK
	hlt
	hlt
	hlt
	hlt
	hlt

.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5

Lfpc_writeln_end$stub:
.indirect_symbol fpc_writeln_end
	hlt
	hlt
	hlt
	hlt
	hlt

.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5

LFPC_INITIALIZEUNITS$stub:
.indirect_symbol FPC_INITIALIZEUNITS
	hlt
	hlt
	hlt
	hlt
	hlt

.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5

LFPC_DO_EXIT$stub:
.indirect_symbol FPC_DO_EXIT
	hlt
	hlt
	hlt
	hlt
	hlt

.section __IMPORT,__jump_table,symbol_stubs,self_modifying_code+pure_instructions,5

L_FPC_SYSTEMMAIN$stub:
.indirect_symbol _FPC_SYSTEMMAIN
	hlt
	hlt
	hlt
	hlt
	hlt
# End asmlist al_imports
# Begin asmlist al_exports
# End asmlist al_exports
# Begin asmlist al_resources
# End asmlist al_resources
# Begin asmlist al_rtti
# End asmlist al_rtti
# Begin asmlist al_dwarf_frame
# End asmlist al_dwarf_frame
# Begin asmlist al_dwarf_info
# End asmlist al_dwarf_info
# Begin asmlist al_dwarf_abbrev
# End asmlist al_dwarf_abbrev
# Begin asmlist al_dwarf_line
# End asmlist al_dwarf_line
# Begin asmlist al_picdata

.section __DATA, __nl_symbol_ptr,non_lazy_symbol_pointers
	.align 2
L_U_P$HELLOWORLD_ALERT$non_lazy_ptr:
.indirect_symbol _U_P$HELLOWORLD_ALERT
	.long	0

.section __DATA, __nl_symbol_ptr,non_lazy_symbol_pointers
	.align 2
L_$HELLOWORLD$_Ld1$non_lazy_ptr:
.indirect_symbol _$HELLOWORLD$_Ld1
	.long	0

.section __DATA, __nl_symbol_ptr,non_lazy_symbol_pointers
	.align 2
L_$HELLOWORLD$_Ld2$non_lazy_ptr:
.indirect_symbol _$HELLOWORLD$_Ld2
	.long	0
# End asmlist al_picdata
# Begin asmlist al_resourcestrings
# End asmlist al_resourcestrings
# Begin asmlist al_objc_data
# End asmlist al_objc_data
# Begin asmlist al_objc_pools
# End asmlist al_objc_pools
# Begin asmlist al_end
# End asmlist al_end
	.subsections_via_symbols

