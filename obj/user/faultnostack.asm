
obj/user/faultnostack:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 39 00 00 00       	callq  80007a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800052:	48 be 1b 05 80 00 00 	movabs $0x80051b,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 38 04 80 00 00 	movabs $0x800438,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800078:	c9                   	leaveq 
  800079:	c3                   	retq   

000000000080007a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007a:	55                   	push   %rbp
  80007b:	48 89 e5             	mov    %rsp,%rbp
  80007e:	48 83 ec 20          	sub    $0x20,%rsp
  800082:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800085:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800089:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  800090:	00 00 00 
  800093:	ff d0                	callq  *%rax
  800095:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a0:	48 63 d0             	movslq %eax,%rdx
  8000a3:	48 89 d0             	mov    %rdx,%rax
  8000a6:	48 c1 e0 03          	shl    $0x3,%rax
  8000aa:	48 01 d0             	add    %rdx,%rax
  8000ad:	48 c1 e0 05          	shl    $0x5,%rax
  8000b1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b8:	00 00 00 
  8000bb:	48 01 c2             	add    %rax,%rdx
  8000be:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000c5:	00 00 00 
  8000c8:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cf:	7e 14                	jle    8000e5 <libmain+0x6b>
		binaryname = argv[0];
  8000d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d5:	48 8b 10             	mov    (%rax),%rdx
  8000d8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000df:	00 00 00 
  8000e2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000ec:	48 89 d6             	mov    %rdx,%rsi
  8000ef:	89 c7                	mov    %eax,%edi
  8000f1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f8:	00 00 00 
  8000fb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000fd:	48 b8 0b 01 80 00 00 	movabs $0x80010b,%rax
  800104:	00 00 00 
  800107:	ff d0                	callq  *%rax
}
  800109:	c9                   	leaveq 
  80010a:	c3                   	retq   

000000000080010b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010b:	55                   	push   %rbp
  80010c:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80010f:	bf 00 00 00 00       	mov    $0x0,%edi
  800114:	48 b8 38 02 80 00 00 	movabs $0x800238,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
}
  800120:	5d                   	pop    %rbp
  800121:	c3                   	retq   

0000000000800122 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
  800126:	53                   	push   %rbx
  800127:	48 83 ec 48          	sub    $0x48,%rsp
  80012b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80012e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800131:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800135:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800139:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80013d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800141:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800144:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800148:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80014c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800150:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800154:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800158:	4c 89 c3             	mov    %r8,%rbx
  80015b:	cd 30                	int    $0x30
  80015d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800161:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800165:	74 3e                	je     8001a5 <syscall+0x83>
  800167:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80016c:	7e 37                	jle    8001a5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800172:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800175:	49 89 d0             	mov    %rdx,%r8
  800178:	89 c1                	mov    %eax,%ecx
  80017a:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  800181:	00 00 00 
  800184:	be 23 00 00 00       	mov    $0x23,%esi
  800189:	48 bf e7 1b 80 00 00 	movabs $0x801be7,%rdi
  800190:	00 00 00 
  800193:	b8 00 00 00 00       	mov    $0x0,%eax
  800198:	49 b9 a2 05 80 00 00 	movabs $0x8005a2,%r9
  80019f:	00 00 00 
  8001a2:	41 ff d1             	callq  *%r9

	return ret;
  8001a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a9:	48 83 c4 48          	add    $0x48,%rsp
  8001ad:	5b                   	pop    %rbx
  8001ae:	5d                   	pop    %rbp
  8001af:	c3                   	retq   

00000000008001b0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b0:	55                   	push   %rbp
  8001b1:	48 89 e5             	mov    %rsp,%rbp
  8001b4:	48 83 ec 20          	sub    $0x20,%rsp
  8001b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001cf:	00 
  8001d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001dc:	48 89 d1             	mov    %rdx,%rcx
  8001df:	48 89 c2             	mov    %rax,%rdx
  8001e2:	be 00 00 00 00       	mov    $0x0,%esi
  8001e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ec:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
}
  8001f8:	c9                   	leaveq 
  8001f9:	c3                   	retq   

00000000008001fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8001fa:	55                   	push   %rbp
  8001fb:	48 89 e5             	mov    %rsp,%rbp
  8001fe:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800202:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800209:	00 
  80020a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800210:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800216:	b9 00 00 00 00       	mov    $0x0,%ecx
  80021b:	ba 00 00 00 00       	mov    $0x0,%edx
  800220:	be 00 00 00 00       	mov    $0x0,%esi
  800225:	bf 01 00 00 00       	mov    $0x1,%edi
  80022a:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  800231:	00 00 00 
  800234:	ff d0                	callq  *%rax
}
  800236:	c9                   	leaveq 
  800237:	c3                   	retq   

0000000000800238 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800238:	55                   	push   %rbp
  800239:	48 89 e5             	mov    %rsp,%rbp
  80023c:	48 83 ec 10          	sub    $0x10,%rsp
  800240:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800246:	48 98                	cltq   
  800248:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80024f:	00 
  800250:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800256:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80025c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800261:	48 89 c2             	mov    %rax,%rdx
  800264:	be 01 00 00 00       	mov    $0x1,%esi
  800269:	bf 03 00 00 00       	mov    $0x3,%edi
  80026e:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
}
  80027a:	c9                   	leaveq 
  80027b:	c3                   	retq   

000000000080027c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80027c:	55                   	push   %rbp
  80027d:	48 89 e5             	mov    %rsp,%rbp
  800280:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800284:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80028b:	00 
  80028c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800292:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800298:	b9 00 00 00 00       	mov    $0x0,%ecx
  80029d:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a2:	be 00 00 00 00       	mov    $0x0,%esi
  8002a7:	bf 02 00 00 00       	mov    $0x2,%edi
  8002ac:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  8002b3:	00 00 00 
  8002b6:	ff d0                	callq  *%rax
}
  8002b8:	c9                   	leaveq 
  8002b9:	c3                   	retq   

00000000008002ba <sys_yield>:

void
sys_yield(void)
{
  8002ba:	55                   	push   %rbp
  8002bb:	48 89 e5             	mov    %rsp,%rbp
  8002be:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002c9:	00 
  8002ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002db:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e0:	be 00 00 00 00       	mov    $0x0,%esi
  8002e5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002ea:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  8002f1:	00 00 00 
  8002f4:	ff d0                	callq  *%rax
}
  8002f6:	c9                   	leaveq 
  8002f7:	c3                   	retq   

00000000008002f8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f8:	55                   	push   %rbp
  8002f9:	48 89 e5             	mov    %rsp,%rbp
  8002fc:	48 83 ec 20          	sub    $0x20,%rsp
  800300:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800303:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800307:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80030a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030d:	48 63 c8             	movslq %eax,%rcx
  800310:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800317:	48 98                	cltq   
  800319:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800320:	00 
  800321:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800327:	49 89 c8             	mov    %rcx,%r8
  80032a:	48 89 d1             	mov    %rdx,%rcx
  80032d:	48 89 c2             	mov    %rax,%rdx
  800330:	be 01 00 00 00       	mov    $0x1,%esi
  800335:	bf 04 00 00 00       	mov    $0x4,%edi
  80033a:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
}
  800346:	c9                   	leaveq 
  800347:	c3                   	retq   

0000000000800348 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800348:	55                   	push   %rbp
  800349:	48 89 e5             	mov    %rsp,%rbp
  80034c:	48 83 ec 30          	sub    $0x30,%rsp
  800350:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800353:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800357:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80035a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80035e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800362:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800365:	48 63 c8             	movslq %eax,%rcx
  800368:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80036c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036f:	48 63 f0             	movslq %eax,%rsi
  800372:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800379:	48 98                	cltq   
  80037b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80037f:	49 89 f9             	mov    %rdi,%r9
  800382:	49 89 f0             	mov    %rsi,%r8
  800385:	48 89 d1             	mov    %rdx,%rcx
  800388:	48 89 c2             	mov    %rax,%rdx
  80038b:	be 01 00 00 00       	mov    $0x1,%esi
  800390:	bf 05 00 00 00       	mov    $0x5,%edi
  800395:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  80039c:	00 00 00 
  80039f:	ff d0                	callq  *%rax
}
  8003a1:	c9                   	leaveq 
  8003a2:	c3                   	retq   

00000000008003a3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a3:	55                   	push   %rbp
  8003a4:	48 89 e5             	mov    %rsp,%rbp
  8003a7:	48 83 ec 20          	sub    $0x20,%rsp
  8003ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b9:	48 98                	cltq   
  8003bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c2:	00 
  8003c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003cf:	48 89 d1             	mov    %rdx,%rcx
  8003d2:	48 89 c2             	mov    %rax,%rdx
  8003d5:	be 01 00 00 00       	mov    $0x1,%esi
  8003da:	bf 06 00 00 00       	mov    $0x6,%edi
  8003df:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	callq  *%rax
}
  8003eb:	c9                   	leaveq 
  8003ec:	c3                   	retq   

00000000008003ed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003ed:	55                   	push   %rbp
  8003ee:	48 89 e5             	mov    %rsp,%rbp
  8003f1:	48 83 ec 10          	sub    $0x10,%rsp
  8003f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003fe:	48 63 d0             	movslq %eax,%rdx
  800401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800404:	48 98                	cltq   
  800406:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80040d:	00 
  80040e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800414:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041a:	48 89 d1             	mov    %rdx,%rcx
  80041d:	48 89 c2             	mov    %rax,%rdx
  800420:	be 01 00 00 00       	mov    $0x1,%esi
  800425:	bf 08 00 00 00       	mov    $0x8,%edi
  80042a:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  800431:	00 00 00 
  800434:	ff d0                	callq  *%rax
}
  800436:	c9                   	leaveq 
  800437:	c3                   	retq   

0000000000800438 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800438:	55                   	push   %rbp
  800439:	48 89 e5             	mov    %rsp,%rbp
  80043c:	48 83 ec 20          	sub    $0x20,%rsp
  800440:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800447:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80044e:	48 98                	cltq   
  800450:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800457:	00 
  800458:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80045e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800464:	48 89 d1             	mov    %rdx,%rcx
  800467:	48 89 c2             	mov    %rax,%rdx
  80046a:	be 01 00 00 00       	mov    $0x1,%esi
  80046f:	bf 09 00 00 00       	mov    $0x9,%edi
  800474:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
}
  800480:	c9                   	leaveq 
  800481:	c3                   	retq   

0000000000800482 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800482:	55                   	push   %rbp
  800483:	48 89 e5             	mov    %rsp,%rbp
  800486:	48 83 ec 20          	sub    $0x20,%rsp
  80048a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80048d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800491:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800495:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800498:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80049b:	48 63 f0             	movslq %eax,%rsi
  80049e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a5:	48 98                	cltq   
  8004a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004b2:	00 
  8004b3:	49 89 f1             	mov    %rsi,%r9
  8004b6:	49 89 c8             	mov    %rcx,%r8
  8004b9:	48 89 d1             	mov    %rdx,%rcx
  8004bc:	48 89 c2             	mov    %rax,%rdx
  8004bf:	be 00 00 00 00       	mov    $0x0,%esi
  8004c4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004c9:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
}
  8004d5:	c9                   	leaveq 
  8004d6:	c3                   	retq   

00000000008004d7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004d7:	55                   	push   %rbp
  8004d8:	48 89 e5             	mov    %rsp,%rbp
  8004db:	48 83 ec 10          	sub    $0x10,%rsp
  8004df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ee:	00 
  8004ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800500:	48 89 c2             	mov    %rax,%rdx
  800503:	be 01 00 00 00       	mov    $0x1,%esi
  800508:	bf 0c 00 00 00       	mov    $0xc,%edi
  80050d:	48 b8 22 01 80 00 00 	movabs $0x800122,%rax
  800514:	00 00 00 
  800517:	ff d0                	callq  *%rax
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80051b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80051e:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  800525:	00 00 00 
call *%rax
  800528:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  80052a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  800531:	00 
    movq 152(%rsp), %rcx
  800532:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  800539:	00 
    subq $8, %rcx
  80053a:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  80053e:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  800541:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  800548:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  800549:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  80054d:	4c 8b 3c 24          	mov    (%rsp),%r15
  800551:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  800556:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80055b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  800560:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  800565:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80056a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80056f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  800574:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  800579:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80057e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  800583:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  800588:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80058d:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  800592:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  800597:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  80059b:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  80059f:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  8005a0:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  8005a1:	c3                   	retq   

00000000008005a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005a2:	55                   	push   %rbp
  8005a3:	48 89 e5             	mov    %rsp,%rbp
  8005a6:	53                   	push   %rbx
  8005a7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005ae:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005b5:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005bb:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005c2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005c9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 23                	je     8005f7 <_panic+0x55>
  8005d4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005db:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005df:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8005e3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8005e7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8005eb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8005ef:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8005f3:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8005f7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8005fe:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800605:	00 00 00 
  800608:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80060f:	00 00 00 
  800612:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800616:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80061d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800624:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80062b:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800632:	00 00 00 
  800635:	48 8b 18             	mov    (%rax),%rbx
  800638:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  80063f:	00 00 00 
  800642:	ff d0                	callq  *%rax
  800644:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80064a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800651:	41 89 c8             	mov    %ecx,%r8d
  800654:	48 89 d1             	mov    %rdx,%rcx
  800657:	48 89 da             	mov    %rbx,%rdx
  80065a:	89 c6                	mov    %eax,%esi
  80065c:	48 bf f8 1b 80 00 00 	movabs $0x801bf8,%rdi
  800663:	00 00 00 
  800666:	b8 00 00 00 00       	mov    $0x0,%eax
  80066b:	49 b9 db 07 80 00 00 	movabs $0x8007db,%r9
  800672:	00 00 00 
  800675:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800678:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80067f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800686:	48 89 d6             	mov    %rdx,%rsi
  800689:	48 89 c7             	mov    %rax,%rdi
  80068c:	48 b8 2f 07 80 00 00 	movabs $0x80072f,%rax
  800693:	00 00 00 
  800696:	ff d0                	callq  *%rax
	cprintf("\n");
  800698:	48 bf 1b 1c 80 00 00 	movabs $0x801c1b,%rdi
  80069f:	00 00 00 
  8006a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a7:	48 ba db 07 80 00 00 	movabs $0x8007db,%rdx
  8006ae:	00 00 00 
  8006b1:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006b3:	cc                   	int3   
  8006b4:	eb fd                	jmp    8006b3 <_panic+0x111>

00000000008006b6 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006b6:	55                   	push   %rbp
  8006b7:	48 89 e5             	mov    %rsp,%rbp
  8006ba:	48 83 ec 10          	sub    $0x10,%rsp
  8006be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c9:	8b 00                	mov    (%rax),%eax
  8006cb:	8d 48 01             	lea    0x1(%rax),%ecx
  8006ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006d2:	89 0a                	mov    %ecx,(%rdx)
  8006d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006d7:	89 d1                	mov    %edx,%ecx
  8006d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006dd:	48 98                	cltq   
  8006df:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8006e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ee:	75 2c                	jne    80071c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8006f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	48 98                	cltq   
  8006f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006fc:	48 83 c2 08          	add    $0x8,%rdx
  800700:	48 89 c6             	mov    %rax,%rsi
  800703:	48 89 d7             	mov    %rdx,%rdi
  800706:	48 b8 b0 01 80 00 00 	movabs $0x8001b0,%rax
  80070d:	00 00 00 
  800710:	ff d0                	callq  *%rax
        b->idx = 0;
  800712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800716:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80071c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800720:	8b 40 04             	mov    0x4(%rax),%eax
  800723:	8d 50 01             	lea    0x1(%rax),%edx
  800726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80072d:	c9                   	leaveq 
  80072e:	c3                   	retq   

000000000080072f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80072f:	55                   	push   %rbp
  800730:	48 89 e5             	mov    %rsp,%rbp
  800733:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80073a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800741:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800748:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80074f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800756:	48 8b 0a             	mov    (%rdx),%rcx
  800759:	48 89 08             	mov    %rcx,(%rax)
  80075c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800760:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800764:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800768:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80076c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800773:	00 00 00 
    b.cnt = 0;
  800776:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80077d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800780:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800787:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80078e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800795:	48 89 c6             	mov    %rax,%rsi
  800798:	48 bf b6 06 80 00 00 	movabs $0x8006b6,%rdi
  80079f:	00 00 00 
  8007a2:	48 b8 8e 0b 80 00 00 	movabs $0x800b8e,%rax
  8007a9:	00 00 00 
  8007ac:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007ae:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007b4:	48 98                	cltq   
  8007b6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007bd:	48 83 c2 08          	add    $0x8,%rdx
  8007c1:	48 89 c6             	mov    %rax,%rsi
  8007c4:	48 89 d7             	mov    %rdx,%rdi
  8007c7:	48 b8 b0 01 80 00 00 	movabs $0x8001b0,%rax
  8007ce:	00 00 00 
  8007d1:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007d9:	c9                   	leaveq 
  8007da:	c3                   	retq   

00000000008007db <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007db:	55                   	push   %rbp
  8007dc:	48 89 e5             	mov    %rsp,%rbp
  8007df:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007e6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8007ed:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8007f4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8007fb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800802:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800809:	84 c0                	test   %al,%al
  80080b:	74 20                	je     80082d <cprintf+0x52>
  80080d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800811:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800815:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800819:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80081d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800821:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800825:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800829:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80082d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800834:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80083b:	00 00 00 
  80083e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800845:	00 00 00 
  800848:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80084c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800853:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80085a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800861:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800868:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80086f:	48 8b 0a             	mov    (%rdx),%rcx
  800872:	48 89 08             	mov    %rcx,(%rax)
  800875:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800879:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80087d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800881:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800885:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80088c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800893:	48 89 d6             	mov    %rdx,%rsi
  800896:	48 89 c7             	mov    %rax,%rdi
  800899:	48 b8 2f 07 80 00 00 	movabs $0x80072f,%rax
  8008a0:	00 00 00 
  8008a3:	ff d0                	callq  *%rax
  8008a5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008ab:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008b1:	c9                   	leaveq 
  8008b2:	c3                   	retq   

00000000008008b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008b3:	55                   	push   %rbp
  8008b4:	48 89 e5             	mov    %rsp,%rbp
  8008b7:	53                   	push   %rbx
  8008b8:	48 83 ec 38          	sub    $0x38,%rsp
  8008bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008c8:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008cb:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008cf:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8008d6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8008da:	77 3b                	ja     800917 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008dc:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8008df:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8008e3:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8008e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ef:	48 f7 f3             	div    %rbx
  8008f2:	48 89 c2             	mov    %rax,%rdx
  8008f5:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8008f8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008fb:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	41 89 f9             	mov    %edi,%r9d
  800906:	48 89 c7             	mov    %rax,%rdi
  800909:	48 b8 b3 08 80 00 00 	movabs $0x8008b3,%rax
  800910:	00 00 00 
  800913:	ff d0                	callq  *%rax
  800915:	eb 1e                	jmp    800935 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800917:	eb 12                	jmp    80092b <printnum+0x78>
			putch(padc, putdat);
  800919:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80091d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800924:	48 89 ce             	mov    %rcx,%rsi
  800927:	89 d7                	mov    %edx,%edi
  800929:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80092b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80092f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800933:	7f e4                	jg     800919 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800935:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093c:	ba 00 00 00 00       	mov    $0x0,%edx
  800941:	48 f7 f1             	div    %rcx
  800944:	48 89 d0             	mov    %rdx,%rax
  800947:	48 ba 70 1d 80 00 00 	movabs $0x801d70,%rdx
  80094e:	00 00 00 
  800951:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800955:	0f be d0             	movsbl %al,%edx
  800958:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 89 ce             	mov    %rcx,%rsi
  800963:	89 d7                	mov    %edx,%edi
  800965:	ff d0                	callq  *%rax
}
  800967:	48 83 c4 38          	add    $0x38,%rsp
  80096b:	5b                   	pop    %rbx
  80096c:	5d                   	pop    %rbp
  80096d:	c3                   	retq   

000000000080096e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80096e:	55                   	push   %rbp
  80096f:	48 89 e5             	mov    %rsp,%rbp
  800972:	48 83 ec 1c          	sub    $0x1c,%rsp
  800976:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80097a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80097d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800981:	7e 52                	jle    8009d5 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800987:	8b 00                	mov    (%rax),%eax
  800989:	83 f8 30             	cmp    $0x30,%eax
  80098c:	73 24                	jae    8009b2 <getuint+0x44>
  80098e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800992:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099a:	8b 00                	mov    (%rax),%eax
  80099c:	89 c0                	mov    %eax,%eax
  80099e:	48 01 d0             	add    %rdx,%rax
  8009a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a5:	8b 12                	mov    (%rdx),%edx
  8009a7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ae:	89 0a                	mov    %ecx,(%rdx)
  8009b0:	eb 17                	jmp    8009c9 <getuint+0x5b>
  8009b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ba:	48 89 d0             	mov    %rdx,%rax
  8009bd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c9:	48 8b 00             	mov    (%rax),%rax
  8009cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d0:	e9 a3 00 00 00       	jmpq   800a78 <getuint+0x10a>
	else if (lflag)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009d9:	74 4f                	je     800a2a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8009db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009df:	8b 00                	mov    (%rax),%eax
  8009e1:	83 f8 30             	cmp    $0x30,%eax
  8009e4:	73 24                	jae    800a0a <getuint+0x9c>
  8009e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f2:	8b 00                	mov    (%rax),%eax
  8009f4:	89 c0                	mov    %eax,%eax
  8009f6:	48 01 d0             	add    %rdx,%rax
  8009f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fd:	8b 12                	mov    (%rdx),%edx
  8009ff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a06:	89 0a                	mov    %ecx,(%rdx)
  800a08:	eb 17                	jmp    800a21 <getuint+0xb3>
  800a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a12:	48 89 d0             	mov    %rdx,%rax
  800a15:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a21:	48 8b 00             	mov    (%rax),%rax
  800a24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a28:	eb 4e                	jmp    800a78 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2e:	8b 00                	mov    (%rax),%eax
  800a30:	83 f8 30             	cmp    $0x30,%eax
  800a33:	73 24                	jae    800a59 <getuint+0xeb>
  800a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a39:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a41:	8b 00                	mov    (%rax),%eax
  800a43:	89 c0                	mov    %eax,%eax
  800a45:	48 01 d0             	add    %rdx,%rax
  800a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4c:	8b 12                	mov    (%rdx),%edx
  800a4e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a55:	89 0a                	mov    %ecx,(%rdx)
  800a57:	eb 17                	jmp    800a70 <getuint+0x102>
  800a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a61:	48 89 d0             	mov    %rdx,%rax
  800a64:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a70:	8b 00                	mov    (%rax),%eax
  800a72:	89 c0                	mov    %eax,%eax
  800a74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a7c:	c9                   	leaveq 
  800a7d:	c3                   	retq   

0000000000800a7e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a7e:	55                   	push   %rbp
  800a7f:	48 89 e5             	mov    %rsp,%rbp
  800a82:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a8a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a8d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a91:	7e 52                	jle    800ae5 <getint+0x67>
		x=va_arg(*ap, long long);
  800a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a97:	8b 00                	mov    (%rax),%eax
  800a99:	83 f8 30             	cmp    $0x30,%eax
  800a9c:	73 24                	jae    800ac2 <getint+0x44>
  800a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaa:	8b 00                	mov    (%rax),%eax
  800aac:	89 c0                	mov    %eax,%eax
  800aae:	48 01 d0             	add    %rdx,%rax
  800ab1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab5:	8b 12                	mov    (%rdx),%edx
  800ab7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abe:	89 0a                	mov    %ecx,(%rdx)
  800ac0:	eb 17                	jmp    800ad9 <getint+0x5b>
  800ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aca:	48 89 d0             	mov    %rdx,%rax
  800acd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ad1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad9:	48 8b 00             	mov    (%rax),%rax
  800adc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ae0:	e9 a3 00 00 00       	jmpq   800b88 <getint+0x10a>
	else if (lflag)
  800ae5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ae9:	74 4f                	je     800b3a <getint+0xbc>
		x=va_arg(*ap, long);
  800aeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aef:	8b 00                	mov    (%rax),%eax
  800af1:	83 f8 30             	cmp    $0x30,%eax
  800af4:	73 24                	jae    800b1a <getint+0x9c>
  800af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800afe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b02:	8b 00                	mov    (%rax),%eax
  800b04:	89 c0                	mov    %eax,%eax
  800b06:	48 01 d0             	add    %rdx,%rax
  800b09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0d:	8b 12                	mov    (%rdx),%edx
  800b0f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b16:	89 0a                	mov    %ecx,(%rdx)
  800b18:	eb 17                	jmp    800b31 <getint+0xb3>
  800b1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b22:	48 89 d0             	mov    %rdx,%rax
  800b25:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b31:	48 8b 00             	mov    (%rax),%rax
  800b34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b38:	eb 4e                	jmp    800b88 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3e:	8b 00                	mov    (%rax),%eax
  800b40:	83 f8 30             	cmp    $0x30,%eax
  800b43:	73 24                	jae    800b69 <getint+0xeb>
  800b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b49:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b51:	8b 00                	mov    (%rax),%eax
  800b53:	89 c0                	mov    %eax,%eax
  800b55:	48 01 d0             	add    %rdx,%rax
  800b58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5c:	8b 12                	mov    (%rdx),%edx
  800b5e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b65:	89 0a                	mov    %ecx,(%rdx)
  800b67:	eb 17                	jmp    800b80 <getint+0x102>
  800b69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b71:	48 89 d0             	mov    %rdx,%rax
  800b74:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b80:	8b 00                	mov    (%rax),%eax
  800b82:	48 98                	cltq   
  800b84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b8c:	c9                   	leaveq 
  800b8d:	c3                   	retq   

0000000000800b8e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b8e:	55                   	push   %rbp
  800b8f:	48 89 e5             	mov    %rsp,%rbp
  800b92:	41 54                	push   %r12
  800b94:	53                   	push   %rbx
  800b95:	48 83 ec 60          	sub    $0x60,%rsp
  800b99:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b9d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ba1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ba5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ba9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bad:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bb1:	48 8b 0a             	mov    (%rdx),%rcx
  800bb4:	48 89 08             	mov    %rcx,(%rax)
  800bb7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bbb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bbf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc7:	eb 17                	jmp    800be0 <vprintfmt+0x52>
			if (ch == '\0')
  800bc9:	85 db                	test   %ebx,%ebx
  800bcb:	0f 84 df 04 00 00    	je     8010b0 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800bd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd9:	48 89 d6             	mov    %rdx,%rsi
  800bdc:	89 df                	mov    %ebx,%edi
  800bde:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800be8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bec:	0f b6 00             	movzbl (%rax),%eax
  800bef:	0f b6 d8             	movzbl %al,%ebx
  800bf2:	83 fb 25             	cmp    $0x25,%ebx
  800bf5:	75 d2                	jne    800bc9 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bf7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800bfb:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c02:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c09:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c10:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c1f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c23:	0f b6 00             	movzbl (%rax),%eax
  800c26:	0f b6 d8             	movzbl %al,%ebx
  800c29:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c2c:	83 f8 55             	cmp    $0x55,%eax
  800c2f:	0f 87 47 04 00 00    	ja     80107c <vprintfmt+0x4ee>
  800c35:	89 c0                	mov    %eax,%eax
  800c37:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c3e:	00 
  800c3f:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  800c46:	00 00 00 
  800c49:	48 01 d0             	add    %rdx,%rax
  800c4c:	48 8b 00             	mov    (%rax),%rax
  800c4f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c51:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c55:	eb c0                	jmp    800c17 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c57:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c5b:	eb ba                	jmp    800c17 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c64:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c67:	89 d0                	mov    %edx,%eax
  800c69:	c1 e0 02             	shl    $0x2,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	01 c0                	add    %eax,%eax
  800c70:	01 d8                	add    %ebx,%eax
  800c72:	83 e8 30             	sub    $0x30,%eax
  800c75:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c78:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7c:	0f b6 00             	movzbl (%rax),%eax
  800c7f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c82:	83 fb 2f             	cmp    $0x2f,%ebx
  800c85:	7e 0c                	jle    800c93 <vprintfmt+0x105>
  800c87:	83 fb 39             	cmp    $0x39,%ebx
  800c8a:	7f 07                	jg     800c93 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c91:	eb d1                	jmp    800c64 <vprintfmt+0xd6>
			goto process_precision;
  800c93:	eb 58                	jmp    800ced <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c98:	83 f8 30             	cmp    $0x30,%eax
  800c9b:	73 17                	jae    800cb4 <vprintfmt+0x126>
  800c9d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca4:	89 c0                	mov    %eax,%eax
  800ca6:	48 01 d0             	add    %rdx,%rax
  800ca9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cac:	83 c2 08             	add    $0x8,%edx
  800caf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb2:	eb 0f                	jmp    800cc3 <vprintfmt+0x135>
  800cb4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb8:	48 89 d0             	mov    %rdx,%rax
  800cbb:	48 83 c2 08          	add    $0x8,%rdx
  800cbf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc3:	8b 00                	mov    (%rax),%eax
  800cc5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cc8:	eb 23                	jmp    800ced <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800cca:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cce:	79 0c                	jns    800cdc <vprintfmt+0x14e>
				width = 0;
  800cd0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cd7:	e9 3b ff ff ff       	jmpq   800c17 <vprintfmt+0x89>
  800cdc:	e9 36 ff ff ff       	jmpq   800c17 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800ce1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ce8:	e9 2a ff ff ff       	jmpq   800c17 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ced:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf1:	79 12                	jns    800d05 <vprintfmt+0x177>
				width = precision, precision = -1;
  800cf3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cf6:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800cf9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d00:	e9 12 ff ff ff       	jmpq   800c17 <vprintfmt+0x89>
  800d05:	e9 0d ff ff ff       	jmpq   800c17 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d0a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d0e:	e9 04 ff ff ff       	jmpq   800c17 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d13:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d16:	83 f8 30             	cmp    $0x30,%eax
  800d19:	73 17                	jae    800d32 <vprintfmt+0x1a4>
  800d1b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d22:	89 c0                	mov    %eax,%eax
  800d24:	48 01 d0             	add    %rdx,%rax
  800d27:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d2a:	83 c2 08             	add    $0x8,%edx
  800d2d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d30:	eb 0f                	jmp    800d41 <vprintfmt+0x1b3>
  800d32:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d36:	48 89 d0             	mov    %rdx,%rax
  800d39:	48 83 c2 08          	add    $0x8,%rdx
  800d3d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d41:	8b 10                	mov    (%rax),%edx
  800d43:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4b:	48 89 ce             	mov    %rcx,%rsi
  800d4e:	89 d7                	mov    %edx,%edi
  800d50:	ff d0                	callq  *%rax
			break;
  800d52:	e9 53 03 00 00       	jmpq   8010aa <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5a:	83 f8 30             	cmp    $0x30,%eax
  800d5d:	73 17                	jae    800d76 <vprintfmt+0x1e8>
  800d5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d66:	89 c0                	mov    %eax,%eax
  800d68:	48 01 d0             	add    %rdx,%rax
  800d6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6e:	83 c2 08             	add    $0x8,%edx
  800d71:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x1f7>
  800d76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d7a:	48 89 d0             	mov    %rdx,%rax
  800d7d:	48 83 c2 08          	add    $0x8,%rdx
  800d81:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d85:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d87:	85 db                	test   %ebx,%ebx
  800d89:	79 02                	jns    800d8d <vprintfmt+0x1ff>
				err = -err;
  800d8b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d8d:	83 fb 15             	cmp    $0x15,%ebx
  800d90:	7f 16                	jg     800da8 <vprintfmt+0x21a>
  800d92:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  800d99:	00 00 00 
  800d9c:	48 63 d3             	movslq %ebx,%rdx
  800d9f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800da3:	4d 85 e4             	test   %r12,%r12
  800da6:	75 2e                	jne    800dd6 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800da8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db0:	89 d9                	mov    %ebx,%ecx
  800db2:	48 ba 81 1d 80 00 00 	movabs $0x801d81,%rdx
  800db9:	00 00 00 
  800dbc:	48 89 c7             	mov    %rax,%rdi
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc4:	49 b8 b9 10 80 00 00 	movabs $0x8010b9,%r8
  800dcb:	00 00 00 
  800dce:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dd1:	e9 d4 02 00 00       	jmpq   8010aa <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dd6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dda:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dde:	4c 89 e1             	mov    %r12,%rcx
  800de1:	48 ba 8a 1d 80 00 00 	movabs $0x801d8a,%rdx
  800de8:	00 00 00 
  800deb:	48 89 c7             	mov    %rax,%rdi
  800dee:	b8 00 00 00 00       	mov    $0x0,%eax
  800df3:	49 b8 b9 10 80 00 00 	movabs $0x8010b9,%r8
  800dfa:	00 00 00 
  800dfd:	41 ff d0             	callq  *%r8
			break;
  800e00:	e9 a5 02 00 00       	jmpq   8010aa <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e08:	83 f8 30             	cmp    $0x30,%eax
  800e0b:	73 17                	jae    800e24 <vprintfmt+0x296>
  800e0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e14:	89 c0                	mov    %eax,%eax
  800e16:	48 01 d0             	add    %rdx,%rax
  800e19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1c:	83 c2 08             	add    $0x8,%edx
  800e1f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e22:	eb 0f                	jmp    800e33 <vprintfmt+0x2a5>
  800e24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e28:	48 89 d0             	mov    %rdx,%rax
  800e2b:	48 83 c2 08          	add    $0x8,%rdx
  800e2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e33:	4c 8b 20             	mov    (%rax),%r12
  800e36:	4d 85 e4             	test   %r12,%r12
  800e39:	75 0a                	jne    800e45 <vprintfmt+0x2b7>
				p = "(null)";
  800e3b:	49 bc 8d 1d 80 00 00 	movabs $0x801d8d,%r12
  800e42:	00 00 00 
			if (width > 0 && padc != '-')
  800e45:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e49:	7e 3f                	jle    800e8a <vprintfmt+0x2fc>
  800e4b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e4f:	74 39                	je     800e8a <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e51:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e54:	48 98                	cltq   
  800e56:	48 89 c6             	mov    %rax,%rsi
  800e59:	4c 89 e7             	mov    %r12,%rdi
  800e5c:	48 b8 65 13 80 00 00 	movabs $0x801365,%rax
  800e63:	00 00 00 
  800e66:	ff d0                	callq  *%rax
  800e68:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e6b:	eb 17                	jmp    800e84 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e6d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e71:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e79:	48 89 ce             	mov    %rcx,%rsi
  800e7c:	89 d7                	mov    %edx,%edi
  800e7e:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e80:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e88:	7f e3                	jg     800e6d <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8a:	eb 37                	jmp    800ec3 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e90:	74 1e                	je     800eb0 <vprintfmt+0x322>
  800e92:	83 fb 1f             	cmp    $0x1f,%ebx
  800e95:	7e 05                	jle    800e9c <vprintfmt+0x30e>
  800e97:	83 fb 7e             	cmp    $0x7e,%ebx
  800e9a:	7e 14                	jle    800eb0 <vprintfmt+0x322>
					putch('?', putdat);
  800e9c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea4:	48 89 d6             	mov    %rdx,%rsi
  800ea7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800eac:	ff d0                	callq  *%rax
  800eae:	eb 0f                	jmp    800ebf <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800eb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb8:	48 89 d6             	mov    %rdx,%rsi
  800ebb:	89 df                	mov    %ebx,%edi
  800ebd:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ec3:	4c 89 e0             	mov    %r12,%rax
  800ec6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800eca:	0f b6 00             	movzbl (%rax),%eax
  800ecd:	0f be d8             	movsbl %al,%ebx
  800ed0:	85 db                	test   %ebx,%ebx
  800ed2:	74 10                	je     800ee4 <vprintfmt+0x356>
  800ed4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ed8:	78 b2                	js     800e8c <vprintfmt+0x2fe>
  800eda:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ede:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ee2:	79 a8                	jns    800e8c <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee4:	eb 16                	jmp    800efc <vprintfmt+0x36e>
				putch(' ', putdat);
  800ee6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eee:	48 89 d6             	mov    %rdx,%rsi
  800ef1:	bf 20 00 00 00       	mov    $0x20,%edi
  800ef6:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800efc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f00:	7f e4                	jg     800ee6 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f02:	e9 a3 01 00 00       	jmpq   8010aa <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f07:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f0b:	be 03 00 00 00       	mov    $0x3,%esi
  800f10:	48 89 c7             	mov    %rax,%rdi
  800f13:	48 b8 7e 0a 80 00 00 	movabs $0x800a7e,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	callq  *%rax
  800f1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f27:	48 85 c0             	test   %rax,%rax
  800f2a:	79 1d                	jns    800f49 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f34:	48 89 d6             	mov    %rdx,%rsi
  800f37:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f3c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	48 f7 d8             	neg    %rax
  800f45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f49:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f50:	e9 e8 00 00 00       	jmpq   80103d <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f55:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f59:	be 03 00 00 00       	mov    $0x3,%esi
  800f5e:	48 89 c7             	mov    %rax,%rdi
  800f61:	48 b8 6e 09 80 00 00 	movabs $0x80096e,%rax
  800f68:	00 00 00 
  800f6b:	ff d0                	callq  *%rax
  800f6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f71:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f78:	e9 c0 00 00 00       	jmpq   80103d <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f85:	48 89 d6             	mov    %rdx,%rsi
  800f88:	bf 58 00 00 00       	mov    $0x58,%edi
  800f8d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f97:	48 89 d6             	mov    %rdx,%rsi
  800f9a:	bf 58 00 00 00       	mov    $0x58,%edi
  800f9f:	ff d0                	callq  *%rax
			putch('X', putdat);
  800fa1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa9:	48 89 d6             	mov    %rdx,%rsi
  800fac:	bf 58 00 00 00       	mov    $0x58,%edi
  800fb1:	ff d0                	callq  *%rax
			break;
  800fb3:	e9 f2 00 00 00       	jmpq   8010aa <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800fb8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc0:	48 89 d6             	mov    %rdx,%rsi
  800fc3:	bf 30 00 00 00       	mov    $0x30,%edi
  800fc8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd2:	48 89 d6             	mov    %rdx,%rsi
  800fd5:	bf 78 00 00 00       	mov    $0x78,%edi
  800fda:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fdc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fdf:	83 f8 30             	cmp    $0x30,%eax
  800fe2:	73 17                	jae    800ffb <vprintfmt+0x46d>
  800fe4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fe8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800feb:	89 c0                	mov    %eax,%eax
  800fed:	48 01 d0             	add    %rdx,%rax
  800ff0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ff3:	83 c2 08             	add    $0x8,%edx
  800ff6:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ff9:	eb 0f                	jmp    80100a <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ffb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fff:	48 89 d0             	mov    %rdx,%rax
  801002:	48 83 c2 08          	add    $0x8,%rdx
  801006:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80100a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80100d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801011:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801018:	eb 23                	jmp    80103d <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80101a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80101e:	be 03 00 00 00       	mov    $0x3,%esi
  801023:	48 89 c7             	mov    %rax,%rdi
  801026:	48 b8 6e 09 80 00 00 	movabs $0x80096e,%rax
  80102d:	00 00 00 
  801030:	ff d0                	callq  *%rax
  801032:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801036:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80103d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801042:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801045:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801048:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80104c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801050:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801054:	45 89 c1             	mov    %r8d,%r9d
  801057:	41 89 f8             	mov    %edi,%r8d
  80105a:	48 89 c7             	mov    %rax,%rdi
  80105d:	48 b8 b3 08 80 00 00 	movabs $0x8008b3,%rax
  801064:	00 00 00 
  801067:	ff d0                	callq  *%rax
			break;
  801069:	eb 3f                	jmp    8010aa <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80106b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80106f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801073:	48 89 d6             	mov    %rdx,%rsi
  801076:	89 df                	mov    %ebx,%edi
  801078:	ff d0                	callq  *%rax
			break;
  80107a:	eb 2e                	jmp    8010aa <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80107c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801080:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801084:	48 89 d6             	mov    %rdx,%rsi
  801087:	bf 25 00 00 00       	mov    $0x25,%edi
  80108c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80108e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801093:	eb 05                	jmp    80109a <vprintfmt+0x50c>
  801095:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80109a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80109e:	48 83 e8 01          	sub    $0x1,%rax
  8010a2:	0f b6 00             	movzbl (%rax),%eax
  8010a5:	3c 25                	cmp    $0x25,%al
  8010a7:	75 ec                	jne    801095 <vprintfmt+0x507>
				/* do nothing */;
			break;
  8010a9:	90                   	nop
		}
	}
  8010aa:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010ab:	e9 30 fb ff ff       	jmpq   800be0 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010b0:	48 83 c4 60          	add    $0x60,%rsp
  8010b4:	5b                   	pop    %rbx
  8010b5:	41 5c                	pop    %r12
  8010b7:	5d                   	pop    %rbp
  8010b8:	c3                   	retq   

00000000008010b9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010b9:	55                   	push   %rbp
  8010ba:	48 89 e5             	mov    %rsp,%rbp
  8010bd:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010c4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010cb:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010d2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010d9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010e0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010e7:	84 c0                	test   %al,%al
  8010e9:	74 20                	je     80110b <printfmt+0x52>
  8010eb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010ef:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010f3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010f7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010fb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010ff:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801103:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801107:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80110b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801112:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801119:	00 00 00 
  80111c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801123:	00 00 00 
  801126:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80112a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801131:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801138:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80113f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801146:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80114d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801154:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80115b:	48 89 c7             	mov    %rax,%rdi
  80115e:	48 b8 8e 0b 80 00 00 	movabs $0x800b8e,%rax
  801165:	00 00 00 
  801168:	ff d0                	callq  *%rax
	va_end(ap);
}
  80116a:	c9                   	leaveq 
  80116b:	c3                   	retq   

000000000080116c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80116c:	55                   	push   %rbp
  80116d:	48 89 e5             	mov    %rsp,%rbp
  801170:	48 83 ec 10          	sub    $0x10,%rsp
  801174:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801177:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80117b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117f:	8b 40 10             	mov    0x10(%rax),%eax
  801182:	8d 50 01             	lea    0x1(%rax),%edx
  801185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801189:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80118c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801190:	48 8b 10             	mov    (%rax),%rdx
  801193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801197:	48 8b 40 08          	mov    0x8(%rax),%rax
  80119b:	48 39 c2             	cmp    %rax,%rdx
  80119e:	73 17                	jae    8011b7 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a4:	48 8b 00             	mov    (%rax),%rax
  8011a7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011af:	48 89 0a             	mov    %rcx,(%rdx)
  8011b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011b5:	88 10                	mov    %dl,(%rax)
}
  8011b7:	c9                   	leaveq 
  8011b8:	c3                   	retq   

00000000008011b9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b9:	55                   	push   %rbp
  8011ba:	48 89 e5             	mov    %rsp,%rbp
  8011bd:	48 83 ec 50          	sub    $0x50,%rsp
  8011c1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011c5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011c8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011cc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011d0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011d4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011d8:	48 8b 0a             	mov    (%rdx),%rcx
  8011db:	48 89 08             	mov    %rcx,(%rax)
  8011de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011f2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011f6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011f9:	48 98                	cltq   
  8011fb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801203:	48 01 d0             	add    %rdx,%rax
  801206:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80120a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801211:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801216:	74 06                	je     80121e <vsnprintf+0x65>
  801218:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80121c:	7f 07                	jg     801225 <vsnprintf+0x6c>
		return -E_INVAL;
  80121e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801223:	eb 2f                	jmp    801254 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801225:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801229:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80122d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801231:	48 89 c6             	mov    %rax,%rsi
  801234:	48 bf 6c 11 80 00 00 	movabs $0x80116c,%rdi
  80123b:	00 00 00 
  80123e:	48 b8 8e 0b 80 00 00 	movabs $0x800b8e,%rax
  801245:	00 00 00 
  801248:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80124a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80124e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801251:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801254:	c9                   	leaveq 
  801255:	c3                   	retq   

0000000000801256 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
  80125a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801261:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801268:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80126e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801275:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80127c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801283:	84 c0                	test   %al,%al
  801285:	74 20                	je     8012a7 <snprintf+0x51>
  801287:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80128b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80128f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801293:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801297:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80129b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80129f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012a3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012a7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012ae:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012b5:	00 00 00 
  8012b8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012bf:	00 00 00 
  8012c2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012c6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012cd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012d4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012db:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012e2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012e9:	48 8b 0a             	mov    (%rdx),%rcx
  8012ec:	48 89 08             	mov    %rcx,(%rax)
  8012ef:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012f3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012f7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012fb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012ff:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801306:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80130d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801313:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80131a:	48 89 c7             	mov    %rax,%rdi
  80131d:	48 b8 b9 11 80 00 00 	movabs $0x8011b9,%rax
  801324:	00 00 00 
  801327:	ff d0                	callq  *%rax
  801329:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80132f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801335:	c9                   	leaveq 
  801336:	c3                   	retq   

0000000000801337 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801337:	55                   	push   %rbp
  801338:	48 89 e5             	mov    %rsp,%rbp
  80133b:	48 83 ec 18          	sub    $0x18,%rsp
  80133f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801343:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80134a:	eb 09                	jmp    801355 <strlen+0x1e>
		n++;
  80134c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801350:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	84 c0                	test   %al,%al
  80135e:	75 ec                	jne    80134c <strlen+0x15>
		n++;
	return n;
  801360:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801363:	c9                   	leaveq 
  801364:	c3                   	retq   

0000000000801365 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	48 83 ec 20          	sub    $0x20,%rsp
  80136d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801371:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801375:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80137c:	eb 0e                	jmp    80138c <strnlen+0x27>
		n++;
  80137e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801382:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801387:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80138c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801391:	74 0b                	je     80139e <strnlen+0x39>
  801393:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801397:	0f b6 00             	movzbl (%rax),%eax
  80139a:	84 c0                	test   %al,%al
  80139c:	75 e0                	jne    80137e <strnlen+0x19>
		n++;
	return n;
  80139e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 83 ec 20          	sub    $0x20,%rsp
  8013ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013bb:	90                   	nop
  8013bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013cc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013d0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013d4:	0f b6 12             	movzbl (%rdx),%edx
  8013d7:	88 10                	mov    %dl,(%rax)
  8013d9:	0f b6 00             	movzbl (%rax),%eax
  8013dc:	84 c0                	test   %al,%al
  8013de:	75 dc                	jne    8013bc <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013e4:	c9                   	leaveq 
  8013e5:	c3                   	retq   

00000000008013e6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013e6:	55                   	push   %rbp
  8013e7:	48 89 e5             	mov    %rsp,%rbp
  8013ea:	48 83 ec 20          	sub    $0x20,%rsp
  8013ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fa:	48 89 c7             	mov    %rax,%rdi
  8013fd:	48 b8 37 13 80 00 00 	movabs $0x801337,%rax
  801404:	00 00 00 
  801407:	ff d0                	callq  *%rax
  801409:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80140c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80140f:	48 63 d0             	movslq %eax,%rdx
  801412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801416:	48 01 c2             	add    %rax,%rdx
  801419:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141d:	48 89 c6             	mov    %rax,%rsi
  801420:	48 89 d7             	mov    %rdx,%rdi
  801423:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  80142a:	00 00 00 
  80142d:	ff d0                	callq  *%rax
	return dst;
  80142f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801433:	c9                   	leaveq 
  801434:	c3                   	retq   

0000000000801435 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801435:	55                   	push   %rbp
  801436:	48 89 e5             	mov    %rsp,%rbp
  801439:	48 83 ec 28          	sub    $0x28,%rsp
  80143d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801441:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801445:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801451:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801458:	00 
  801459:	eb 2a                	jmp    801485 <strncpy+0x50>
		*dst++ = *src;
  80145b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801463:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801467:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80146b:	0f b6 12             	movzbl (%rdx),%edx
  80146e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801470:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801474:	0f b6 00             	movzbl (%rax),%eax
  801477:	84 c0                	test   %al,%al
  801479:	74 05                	je     801480 <strncpy+0x4b>
			src++;
  80147b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801480:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801489:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80148d:	72 cc                	jb     80145b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80148f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801493:	c9                   	leaveq 
  801494:	c3                   	retq   

0000000000801495 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801495:	55                   	push   %rbp
  801496:	48 89 e5             	mov    %rsp,%rbp
  801499:	48 83 ec 28          	sub    $0x28,%rsp
  80149d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014b1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014b6:	74 3d                	je     8014f5 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014b8:	eb 1d                	jmp    8014d7 <strlcpy+0x42>
			*dst++ = *src++;
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014ca:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014ce:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014d2:	0f b6 12             	movzbl (%rdx),%edx
  8014d5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014dc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014e1:	74 0b                	je     8014ee <strlcpy+0x59>
  8014e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e7:	0f b6 00             	movzbl (%rax),%eax
  8014ea:	84 c0                	test   %al,%al
  8014ec:	75 cc                	jne    8014ba <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f2:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fd:	48 29 c2             	sub    %rax,%rdx
  801500:	48 89 d0             	mov    %rdx,%rax
}
  801503:	c9                   	leaveq 
  801504:	c3                   	retq   

0000000000801505 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801505:	55                   	push   %rbp
  801506:	48 89 e5             	mov    %rsp,%rbp
  801509:	48 83 ec 10          	sub    $0x10,%rsp
  80150d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801511:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801515:	eb 0a                	jmp    801521 <strcmp+0x1c>
		p++, q++;
  801517:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801521:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	84 c0                	test   %al,%al
  80152a:	74 12                	je     80153e <strcmp+0x39>
  80152c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801530:	0f b6 10             	movzbl (%rax),%edx
  801533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801537:	0f b6 00             	movzbl (%rax),%eax
  80153a:	38 c2                	cmp    %al,%dl
  80153c:	74 d9                	je     801517 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	0f b6 d0             	movzbl %al,%edx
  801548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	0f b6 c0             	movzbl %al,%eax
  801552:	29 c2                	sub    %eax,%edx
  801554:	89 d0                	mov    %edx,%eax
}
  801556:	c9                   	leaveq 
  801557:	c3                   	retq   

0000000000801558 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801558:	55                   	push   %rbp
  801559:	48 89 e5             	mov    %rsp,%rbp
  80155c:	48 83 ec 18          	sub    $0x18,%rsp
  801560:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801564:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801568:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80156c:	eb 0f                	jmp    80157d <strncmp+0x25>
		n--, p++, q++;
  80156e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801573:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801578:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80157d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801582:	74 1d                	je     8015a1 <strncmp+0x49>
  801584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	84 c0                	test   %al,%al
  80158d:	74 12                	je     8015a1 <strncmp+0x49>
  80158f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801593:	0f b6 10             	movzbl (%rax),%edx
  801596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	38 c2                	cmp    %al,%dl
  80159f:	74 cd                	je     80156e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a6:	75 07                	jne    8015af <strncmp+0x57>
		return 0;
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ad:	eb 18                	jmp    8015c7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	0f b6 d0             	movzbl %al,%edx
  8015b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	0f b6 c0             	movzbl %al,%eax
  8015c3:	29 c2                	sub    %eax,%edx
  8015c5:	89 d0                	mov    %edx,%eax
}
  8015c7:	c9                   	leaveq 
  8015c8:	c3                   	retq   

00000000008015c9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015c9:	55                   	push   %rbp
  8015ca:	48 89 e5             	mov    %rsp,%rbp
  8015cd:	48 83 ec 0c          	sub    $0xc,%rsp
  8015d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d5:	89 f0                	mov    %esi,%eax
  8015d7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015da:	eb 17                	jmp    8015f3 <strchr+0x2a>
		if (*s == c)
  8015dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015e6:	75 06                	jne    8015ee <strchr+0x25>
			return (char *) s;
  8015e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ec:	eb 15                	jmp    801603 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 de                	jne    8015dc <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801603:	c9                   	leaveq 
  801604:	c3                   	retq   

0000000000801605 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	48 83 ec 0c          	sub    $0xc,%rsp
  80160d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801611:	89 f0                	mov    %esi,%eax
  801613:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801616:	eb 13                	jmp    80162b <strfind+0x26>
		if (*s == c)
  801618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161c:	0f b6 00             	movzbl (%rax),%eax
  80161f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801622:	75 02                	jne    801626 <strfind+0x21>
			break;
  801624:	eb 10                	jmp    801636 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801626:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	0f b6 00             	movzbl (%rax),%eax
  801632:	84 c0                	test   %al,%al
  801634:	75 e2                	jne    801618 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801636:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80163a:	c9                   	leaveq 
  80163b:	c3                   	retq   

000000000080163c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	48 83 ec 18          	sub    $0x18,%rsp
  801644:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801648:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80164b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80164f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801654:	75 06                	jne    80165c <memset+0x20>
		return v;
  801656:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165a:	eb 69                	jmp    8016c5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80165c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801660:	83 e0 03             	and    $0x3,%eax
  801663:	48 85 c0             	test   %rax,%rax
  801666:	75 48                	jne    8016b0 <memset+0x74>
  801668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166c:	83 e0 03             	and    $0x3,%eax
  80166f:	48 85 c0             	test   %rax,%rax
  801672:	75 3c                	jne    8016b0 <memset+0x74>
		c &= 0xFF;
  801674:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80167b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80167e:	c1 e0 18             	shl    $0x18,%eax
  801681:	89 c2                	mov    %eax,%edx
  801683:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801686:	c1 e0 10             	shl    $0x10,%eax
  801689:	09 c2                	or     %eax,%edx
  80168b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80168e:	c1 e0 08             	shl    $0x8,%eax
  801691:	09 d0                	or     %edx,%eax
  801693:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169a:	48 c1 e8 02          	shr    $0x2,%rax
  80169e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a8:	48 89 d7             	mov    %rdx,%rdi
  8016ab:	fc                   	cld    
  8016ac:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016ae:	eb 11                	jmp    8016c1 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016bb:	48 89 d7             	mov    %rdx,%rdi
  8016be:	fc                   	cld    
  8016bf:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016c5:	c9                   	leaveq 
  8016c6:	c3                   	retq   

00000000008016c7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016c7:	55                   	push   %rbp
  8016c8:	48 89 e5             	mov    %rsp,%rbp
  8016cb:	48 83 ec 28          	sub    $0x28,%rsp
  8016cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ef:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016f3:	0f 83 88 00 00 00    	jae    801781 <memmove+0xba>
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801701:	48 01 d0             	add    %rdx,%rax
  801704:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801708:	76 77                	jbe    801781 <memmove+0xba>
		s += n;
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171e:	83 e0 03             	and    $0x3,%eax
  801721:	48 85 c0             	test   %rax,%rax
  801724:	75 3b                	jne    801761 <memmove+0x9a>
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	83 e0 03             	and    $0x3,%eax
  80172d:	48 85 c0             	test   %rax,%rax
  801730:	75 2f                	jne    801761 <memmove+0x9a>
  801732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801736:	83 e0 03             	and    $0x3,%eax
  801739:	48 85 c0             	test   %rax,%rax
  80173c:	75 23                	jne    801761 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80173e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801742:	48 83 e8 04          	sub    $0x4,%rax
  801746:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80174a:	48 83 ea 04          	sub    $0x4,%rdx
  80174e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801752:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801756:	48 89 c7             	mov    %rax,%rdi
  801759:	48 89 d6             	mov    %rdx,%rsi
  80175c:	fd                   	std    
  80175d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80175f:	eb 1d                	jmp    80177e <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801765:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	48 89 d7             	mov    %rdx,%rdi
  801778:	48 89 c1             	mov    %rax,%rcx
  80177b:	fd                   	std    
  80177c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80177e:	fc                   	cld    
  80177f:	eb 57                	jmp    8017d8 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801781:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801785:	83 e0 03             	and    $0x3,%eax
  801788:	48 85 c0             	test   %rax,%rax
  80178b:	75 36                	jne    8017c3 <memmove+0xfc>
  80178d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801791:	83 e0 03             	and    $0x3,%eax
  801794:	48 85 c0             	test   %rax,%rax
  801797:	75 2a                	jne    8017c3 <memmove+0xfc>
  801799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179d:	83 e0 03             	and    $0x3,%eax
  8017a0:	48 85 c0             	test   %rax,%rax
  8017a3:	75 1e                	jne    8017c3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a9:	48 c1 e8 02          	shr    $0x2,%rax
  8017ad:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b8:	48 89 c7             	mov    %rax,%rdi
  8017bb:	48 89 d6             	mov    %rdx,%rsi
  8017be:	fc                   	cld    
  8017bf:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017c1:	eb 15                	jmp    8017d8 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017cb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017cf:	48 89 c7             	mov    %rax,%rdi
  8017d2:	48 89 d6             	mov    %rdx,%rsi
  8017d5:	fc                   	cld    
  8017d6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017dc:	c9                   	leaveq 
  8017dd:	c3                   	retq   

00000000008017de <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	48 83 ec 18          	sub    $0x18,%rsp
  8017e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fe:	48 89 ce             	mov    %rcx,%rsi
  801801:	48 89 c7             	mov    %rax,%rdi
  801804:	48 b8 c7 16 80 00 00 	movabs $0x8016c7,%rax
  80180b:	00 00 00 
  80180e:	ff d0                	callq  *%rax
}
  801810:	c9                   	leaveq 
  801811:	c3                   	retq   

0000000000801812 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801812:	55                   	push   %rbp
  801813:	48 89 e5             	mov    %rsp,%rbp
  801816:	48 83 ec 28          	sub    $0x28,%rsp
  80181a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80181e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801822:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80182a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80182e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801832:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801836:	eb 36                	jmp    80186e <memcmp+0x5c>
		if (*s1 != *s2)
  801838:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183c:	0f b6 10             	movzbl (%rax),%edx
  80183f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801843:	0f b6 00             	movzbl (%rax),%eax
  801846:	38 c2                	cmp    %al,%dl
  801848:	74 1a                	je     801864 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80184a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	0f b6 d0             	movzbl %al,%edx
  801854:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801858:	0f b6 00             	movzbl (%rax),%eax
  80185b:	0f b6 c0             	movzbl %al,%eax
  80185e:	29 c2                	sub    %eax,%edx
  801860:	89 d0                	mov    %edx,%eax
  801862:	eb 20                	jmp    801884 <memcmp+0x72>
		s1++, s2++;
  801864:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801869:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80186e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801872:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801876:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80187a:	48 85 c0             	test   %rax,%rax
  80187d:	75 b9                	jne    801838 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80187f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801884:	c9                   	leaveq 
  801885:	c3                   	retq   

0000000000801886 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801886:	55                   	push   %rbp
  801887:	48 89 e5             	mov    %rsp,%rbp
  80188a:	48 83 ec 28          	sub    $0x28,%rsp
  80188e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801892:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801895:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a1:	48 01 d0             	add    %rdx,%rax
  8018a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018a8:	eb 15                	jmp    8018bf <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ae:	0f b6 10             	movzbl (%rax),%edx
  8018b1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018b4:	38 c2                	cmp    %al,%dl
  8018b6:	75 02                	jne    8018ba <memfind+0x34>
			break;
  8018b8:	eb 0f                	jmp    8018c9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018ba:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018c7:	72 e1                	jb     8018aa <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018cd:	c9                   	leaveq 
  8018ce:	c3                   	retq   

00000000008018cf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018cf:	55                   	push   %rbp
  8018d0:	48 89 e5             	mov    %rsp,%rbp
  8018d3:	48 83 ec 34          	sub    $0x34,%rsp
  8018d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018df:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018e9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018f0:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f1:	eb 05                	jmp    8018f8 <strtol+0x29>
		s++;
  8018f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fc:	0f b6 00             	movzbl (%rax),%eax
  8018ff:	3c 20                	cmp    $0x20,%al
  801901:	74 f0                	je     8018f3 <strtol+0x24>
  801903:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801907:	0f b6 00             	movzbl (%rax),%eax
  80190a:	3c 09                	cmp    $0x9,%al
  80190c:	74 e5                	je     8018f3 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80190e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801912:	0f b6 00             	movzbl (%rax),%eax
  801915:	3c 2b                	cmp    $0x2b,%al
  801917:	75 07                	jne    801920 <strtol+0x51>
		s++;
  801919:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80191e:	eb 17                	jmp    801937 <strtol+0x68>
	else if (*s == '-')
  801920:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801924:	0f b6 00             	movzbl (%rax),%eax
  801927:	3c 2d                	cmp    $0x2d,%al
  801929:	75 0c                	jne    801937 <strtol+0x68>
		s++, neg = 1;
  80192b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801930:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801937:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80193b:	74 06                	je     801943 <strtol+0x74>
  80193d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801941:	75 28                	jne    80196b <strtol+0x9c>
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	0f b6 00             	movzbl (%rax),%eax
  80194a:	3c 30                	cmp    $0x30,%al
  80194c:	75 1d                	jne    80196b <strtol+0x9c>
  80194e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801952:	48 83 c0 01          	add    $0x1,%rax
  801956:	0f b6 00             	movzbl (%rax),%eax
  801959:	3c 78                	cmp    $0x78,%al
  80195b:	75 0e                	jne    80196b <strtol+0x9c>
		s += 2, base = 16;
  80195d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801962:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801969:	eb 2c                	jmp    801997 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80196b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80196f:	75 19                	jne    80198a <strtol+0xbb>
  801971:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801975:	0f b6 00             	movzbl (%rax),%eax
  801978:	3c 30                	cmp    $0x30,%al
  80197a:	75 0e                	jne    80198a <strtol+0xbb>
		s++, base = 8;
  80197c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801981:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801988:	eb 0d                	jmp    801997 <strtol+0xc8>
	else if (base == 0)
  80198a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80198e:	75 07                	jne    801997 <strtol+0xc8>
		base = 10;
  801990:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199b:	0f b6 00             	movzbl (%rax),%eax
  80199e:	3c 2f                	cmp    $0x2f,%al
  8019a0:	7e 1d                	jle    8019bf <strtol+0xf0>
  8019a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a6:	0f b6 00             	movzbl (%rax),%eax
  8019a9:	3c 39                	cmp    $0x39,%al
  8019ab:	7f 12                	jg     8019bf <strtol+0xf0>
			dig = *s - '0';
  8019ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b1:	0f b6 00             	movzbl (%rax),%eax
  8019b4:	0f be c0             	movsbl %al,%eax
  8019b7:	83 e8 30             	sub    $0x30,%eax
  8019ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019bd:	eb 4e                	jmp    801a0d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c3:	0f b6 00             	movzbl (%rax),%eax
  8019c6:	3c 60                	cmp    $0x60,%al
  8019c8:	7e 1d                	jle    8019e7 <strtol+0x118>
  8019ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ce:	0f b6 00             	movzbl (%rax),%eax
  8019d1:	3c 7a                	cmp    $0x7a,%al
  8019d3:	7f 12                	jg     8019e7 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d9:	0f b6 00             	movzbl (%rax),%eax
  8019dc:	0f be c0             	movsbl %al,%eax
  8019df:	83 e8 57             	sub    $0x57,%eax
  8019e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019e5:	eb 26                	jmp    801a0d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019eb:	0f b6 00             	movzbl (%rax),%eax
  8019ee:	3c 40                	cmp    $0x40,%al
  8019f0:	7e 48                	jle    801a3a <strtol+0x16b>
  8019f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f6:	0f b6 00             	movzbl (%rax),%eax
  8019f9:	3c 5a                	cmp    $0x5a,%al
  8019fb:	7f 3d                	jg     801a3a <strtol+0x16b>
			dig = *s - 'A' + 10;
  8019fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a01:	0f b6 00             	movzbl (%rax),%eax
  801a04:	0f be c0             	movsbl %al,%eax
  801a07:	83 e8 37             	sub    $0x37,%eax
  801a0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a10:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a13:	7c 02                	jl     801a17 <strtol+0x148>
			break;
  801a15:	eb 23                	jmp    801a3a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a17:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a1c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a1f:	48 98                	cltq   
  801a21:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a26:	48 89 c2             	mov    %rax,%rdx
  801a29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a2c:	48 98                	cltq   
  801a2e:	48 01 d0             	add    %rdx,%rax
  801a31:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a35:	e9 5d ff ff ff       	jmpq   801997 <strtol+0xc8>

	if (endptr)
  801a3a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a3f:	74 0b                	je     801a4c <strtol+0x17d>
		*endptr = (char *) s;
  801a41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a45:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a49:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a50:	74 09                	je     801a5b <strtol+0x18c>
  801a52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a56:	48 f7 d8             	neg    %rax
  801a59:	eb 04                	jmp    801a5f <strtol+0x190>
  801a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a5f:	c9                   	leaveq 
  801a60:	c3                   	retq   

0000000000801a61 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a61:	55                   	push   %rbp
  801a62:	48 89 e5             	mov    %rsp,%rbp
  801a65:	48 83 ec 30          	sub    $0x30,%rsp
  801a69:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a75:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a79:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a7d:	0f b6 00             	movzbl (%rax),%eax
  801a80:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a83:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a87:	75 06                	jne    801a8f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8d:	eb 6b                	jmp    801afa <strstr+0x99>

	len = strlen(str);
  801a8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a93:	48 89 c7             	mov    %rax,%rdi
  801a96:	48 b8 37 13 80 00 00 	movabs $0x801337,%rax
  801a9d:	00 00 00 
  801aa0:	ff d0                	callq  *%rax
  801aa2:	48 98                	cltq   
  801aa4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801aa8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ab0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ab4:	0f b6 00             	movzbl (%rax),%eax
  801ab7:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801aba:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801abe:	75 07                	jne    801ac7 <strstr+0x66>
				return (char *) 0;
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac5:	eb 33                	jmp    801afa <strstr+0x99>
		} while (sc != c);
  801ac7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801acb:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ace:	75 d8                	jne    801aa8 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801ad0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ad8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801adc:	48 89 ce             	mov    %rcx,%rsi
  801adf:	48 89 c7             	mov    %rax,%rdi
  801ae2:	48 b8 58 15 80 00 00 	movabs $0x801558,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	callq  *%rax
  801aee:	85 c0                	test   %eax,%eax
  801af0:	75 b6                	jne    801aa8 <strstr+0x47>

	return (char *) (in - 1);
  801af2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af6:	48 83 e8 01          	sub    $0x1,%rax
}
  801afa:	c9                   	leaveq 
  801afb:	c3                   	retq   

0000000000801afc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801afc:	55                   	push   %rbp
  801afd:	48 89 e5             	mov    %rsp,%rbp
  801b00:	48 83 ec 10          	sub    $0x10,%rsp
  801b04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801b08:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801b0f:	00 00 00 
  801b12:	48 8b 00             	mov    (%rax),%rax
  801b15:	48 85 c0             	test   %rax,%rax
  801b18:	75 49                	jne    801b63 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801b1a:	ba 07 00 00 00       	mov    $0x7,%edx
  801b1f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801b24:	bf 00 00 00 00       	mov    $0x0,%edi
  801b29:	48 b8 f8 02 80 00 00 	movabs $0x8002f8,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	callq  *%rax
  801b35:	85 c0                	test   %eax,%eax
  801b37:	79 2a                	jns    801b63 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801b39:	48 ba 48 20 80 00 00 	movabs $0x802048,%rdx
  801b40:	00 00 00 
  801b43:	be 21 00 00 00       	mov    $0x21,%esi
  801b48:	48 bf 73 20 80 00 00 	movabs $0x802073,%rdi
  801b4f:	00 00 00 
  801b52:	b8 00 00 00 00       	mov    $0x0,%eax
  801b57:	48 b9 a2 05 80 00 00 	movabs $0x8005a2,%rcx
  801b5e:	00 00 00 
  801b61:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801b63:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801b6a:	00 00 00 
  801b6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b71:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801b74:	48 be 1b 05 80 00 00 	movabs $0x80051b,%rsi
  801b7b:	00 00 00 
  801b7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801b83:	48 b8 38 04 80 00 00 	movabs $0x800438,%rax
  801b8a:	00 00 00 
  801b8d:	ff d0                	callq  *%rax
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	79 2a                	jns    801bbd <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801b93:	48 ba 88 20 80 00 00 	movabs $0x802088,%rdx
  801b9a:	00 00 00 
  801b9d:	be 27 00 00 00       	mov    $0x27,%esi
  801ba2:	48 bf 73 20 80 00 00 	movabs $0x802073,%rdi
  801ba9:	00 00 00 
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb1:	48 b9 a2 05 80 00 00 	movabs $0x8005a2,%rcx
  801bb8:	00 00 00 
  801bbb:	ff d1                	callq  *%rcx
}
  801bbd:	c9                   	leaveq 
  801bbe:	c3                   	retq   
