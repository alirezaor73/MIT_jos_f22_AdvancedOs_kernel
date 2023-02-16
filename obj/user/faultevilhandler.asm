
obj/user/faultevilhandler:     file format elf64-x86-64


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
  80003c:	e8 4f 00 00 00       	callq  800090 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800052:	ba 07 00 00 00       	mov    $0x7,%edx
  800057:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  80006d:	be 20 00 10 f0       	mov    $0xf0100020,%esi
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  800083:	b8 00 00 00 00       	mov    $0x0,%eax
  800088:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80008e:	c9                   	leaveq 
  80008f:	c3                   	retq   

0000000000800090 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800090:	55                   	push   %rbp
  800091:	48 89 e5             	mov    %rsp,%rbp
  800094:	48 83 ec 20          	sub    $0x20,%rsp
  800098:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80009b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80009f:	48 b8 9e 02 80 00 00 	movabs $0x80029e,%rax
  8000a6:	00 00 00 
  8000a9:	ff d0                	callq  *%rax
  8000ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8000ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	48 63 d0             	movslq %eax,%rdx
  8000b9:	48 89 d0             	mov    %rdx,%rax
  8000bc:	48 c1 e0 03          	shl    $0x3,%rax
  8000c0:	48 01 d0             	add    %rdx,%rax
  8000c3:	48 c1 e0 05          	shl    $0x5,%rax
  8000c7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000ce:	00 00 00 
  8000d1:	48 01 c2             	add    %rax,%rdx
  8000d4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000db:	00 00 00 
  8000de:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000e5:	7e 14                	jle    8000fb <libmain+0x6b>
		binaryname = argv[0];
  8000e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000eb:	48 8b 10             	mov    (%rax),%rdx
  8000ee:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000f5:	00 00 00 
  8000f8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800102:	48 89 d6             	mov    %rdx,%rsi
  800105:	89 c7                	mov    %eax,%edi
  800107:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800113:	48 b8 21 01 80 00 00 	movabs $0x800121,%rax
  80011a:	00 00 00 
  80011d:	ff d0                	callq  *%rax
}
  80011f:	c9                   	leaveq 
  800120:	c3                   	retq   

0000000000800121 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800121:	55                   	push   %rbp
  800122:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800125:	48 b8 c8 08 80 00 00 	movabs $0x8008c8,%rax
  80012c:	00 00 00 
  80012f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800131:	bf 00 00 00 00       	mov    $0x0,%edi
  800136:	48 b8 5a 02 80 00 00 	movabs $0x80025a,%rax
  80013d:	00 00 00 
  800140:	ff d0                	callq  *%rax
}
  800142:	5d                   	pop    %rbp
  800143:	c3                   	retq   

0000000000800144 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
  800148:	53                   	push   %rbx
  800149:	48 83 ec 48          	sub    $0x48,%rsp
  80014d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800150:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800153:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800157:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80015b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80015f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800163:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800166:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80016a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80016e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800172:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800176:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80017a:	4c 89 c3             	mov    %r8,%rbx
  80017d:	cd 30                	int    $0x30
  80017f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800183:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800187:	74 3e                	je     8001c7 <syscall+0x83>
  800189:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80018e:	7e 37                	jle    8001c7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800190:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800194:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800197:	49 89 d0             	mov    %rdx,%r8
  80019a:	89 c1                	mov    %eax,%ecx
  80019c:	48 ba 2a 36 80 00 00 	movabs $0x80362a,%rdx
  8001a3:	00 00 00 
  8001a6:	be 23 00 00 00       	mov    $0x23,%esi
  8001ab:	48 bf 47 36 80 00 00 	movabs $0x803647,%rdi
  8001b2:	00 00 00 
  8001b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ba:	49 b9 4c 1e 80 00 00 	movabs $0x801e4c,%r9
  8001c1:	00 00 00 
  8001c4:	41 ff d1             	callq  *%r9

	return ret;
  8001c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001cb:	48 83 c4 48          	add    $0x48,%rsp
  8001cf:	5b                   	pop    %rbx
  8001d0:	5d                   	pop    %rbp
  8001d1:	c3                   	retq   

00000000008001d2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001d2:	55                   	push   %rbp
  8001d3:	48 89 e5             	mov    %rsp,%rbp
  8001d6:	48 83 ec 20          	sub    $0x20,%rsp
  8001da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f1:	00 
  8001f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001fe:	48 89 d1             	mov    %rdx,%rcx
  800201:	48 89 c2             	mov    %rax,%rdx
  800204:	be 00 00 00 00       	mov    $0x0,%esi
  800209:	bf 00 00 00 00       	mov    $0x0,%edi
  80020e:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
}
  80021a:	c9                   	leaveq 
  80021b:	c3                   	retq   

000000000080021c <sys_cgetc>:

int
sys_cgetc(void)
{
  80021c:	55                   	push   %rbp
  80021d:	48 89 e5             	mov    %rsp,%rbp
  800220:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800224:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80022b:	00 
  80022c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800232:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800238:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023d:	ba 00 00 00 00       	mov    $0x0,%edx
  800242:	be 00 00 00 00       	mov    $0x0,%esi
  800247:	bf 01 00 00 00       	mov    $0x1,%edi
  80024c:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
}
  800258:	c9                   	leaveq 
  800259:	c3                   	retq   

000000000080025a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80025a:	55                   	push   %rbp
  80025b:	48 89 e5             	mov    %rsp,%rbp
  80025e:	48 83 ec 10          	sub    $0x10,%rsp
  800262:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800265:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800268:	48 98                	cltq   
  80026a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800271:	00 
  800272:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800278:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80027e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800283:	48 89 c2             	mov    %rax,%rdx
  800286:	be 01 00 00 00       	mov    $0x1,%esi
  80028b:	bf 03 00 00 00       	mov    $0x3,%edi
  800290:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800297:	00 00 00 
  80029a:	ff d0                	callq  *%rax
}
  80029c:	c9                   	leaveq 
  80029d:	c3                   	retq   

000000000080029e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80029e:	55                   	push   %rbp
  80029f:	48 89 e5             	mov    %rsp,%rbp
  8002a2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002ad:	00 
  8002ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c4:	be 00 00 00 00       	mov    $0x0,%esi
  8002c9:	bf 02 00 00 00       	mov    $0x2,%edi
  8002ce:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
}
  8002da:	c9                   	leaveq 
  8002db:	c3                   	retq   

00000000008002dc <sys_yield>:

void
sys_yield(void)
{
  8002dc:	55                   	push   %rbp
  8002dd:	48 89 e5             	mov    %rsp,%rbp
  8002e0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002eb:	00 
  8002ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800302:	be 00 00 00 00       	mov    $0x0,%esi
  800307:	bf 0b 00 00 00       	mov    $0xb,%edi
  80030c:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 83 ec 20          	sub    $0x20,%rsp
  800322:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800325:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800329:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80032c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80032f:	48 63 c8             	movslq %eax,%rcx
  800332:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800336:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800339:	48 98                	cltq   
  80033b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800342:	00 
  800343:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800349:	49 89 c8             	mov    %rcx,%r8
  80034c:	48 89 d1             	mov    %rdx,%rcx
  80034f:	48 89 c2             	mov    %rax,%rdx
  800352:	be 01 00 00 00       	mov    $0x1,%esi
  800357:	bf 04 00 00 00       	mov    $0x4,%edi
  80035c:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax
}
  800368:	c9                   	leaveq 
  800369:	c3                   	retq   

000000000080036a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80036a:	55                   	push   %rbp
  80036b:	48 89 e5             	mov    %rsp,%rbp
  80036e:	48 83 ec 30          	sub    $0x30,%rsp
  800372:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800375:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800379:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80037c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800380:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800384:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800387:	48 63 c8             	movslq %eax,%rcx
  80038a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80038e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800391:	48 63 f0             	movslq %eax,%rsi
  800394:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800398:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039b:	48 98                	cltq   
  80039d:	48 89 0c 24          	mov    %rcx,(%rsp)
  8003a1:	49 89 f9             	mov    %rdi,%r9
  8003a4:	49 89 f0             	mov    %rsi,%r8
  8003a7:	48 89 d1             	mov    %rdx,%rcx
  8003aa:	48 89 c2             	mov    %rax,%rdx
  8003ad:	be 01 00 00 00       	mov    $0x1,%esi
  8003b2:	bf 05 00 00 00       	mov    $0x5,%edi
  8003b7:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8003be:	00 00 00 
  8003c1:	ff d0                	callq  *%rax
}
  8003c3:	c9                   	leaveq 
  8003c4:	c3                   	retq   

00000000008003c5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003c5:	55                   	push   %rbp
  8003c6:	48 89 e5             	mov    %rsp,%rbp
  8003c9:	48 83 ec 20          	sub    $0x20,%rsp
  8003cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003db:	48 98                	cltq   
  8003dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003e4:	00 
  8003e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003f1:	48 89 d1             	mov    %rdx,%rcx
  8003f4:	48 89 c2             	mov    %rax,%rdx
  8003f7:	be 01 00 00 00       	mov    $0x1,%esi
  8003fc:	bf 06 00 00 00       	mov    $0x6,%edi
  800401:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800408:	00 00 00 
  80040b:	ff d0                	callq  *%rax
}
  80040d:	c9                   	leaveq 
  80040e:	c3                   	retq   

000000000080040f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80040f:	55                   	push   %rbp
  800410:	48 89 e5             	mov    %rsp,%rbp
  800413:	48 83 ec 10          	sub    $0x10,%rsp
  800417:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80041d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800420:	48 63 d0             	movslq %eax,%rdx
  800423:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800426:	48 98                	cltq   
  800428:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80042f:	00 
  800430:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800436:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80043c:	48 89 d1             	mov    %rdx,%rcx
  80043f:	48 89 c2             	mov    %rax,%rdx
  800442:	be 01 00 00 00       	mov    $0x1,%esi
  800447:	bf 08 00 00 00       	mov    $0x8,%edi
  80044c:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800453:	00 00 00 
  800456:	ff d0                	callq  *%rax
}
  800458:	c9                   	leaveq 
  800459:	c3                   	retq   

000000000080045a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80045a:	55                   	push   %rbp
  80045b:	48 89 e5             	mov    %rsp,%rbp
  80045e:	48 83 ec 20          	sub    $0x20,%rsp
  800462:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800465:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800469:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80046d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800470:	48 98                	cltq   
  800472:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800479:	00 
  80047a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800480:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800486:	48 89 d1             	mov    %rdx,%rcx
  800489:	48 89 c2             	mov    %rax,%rdx
  80048c:	be 01 00 00 00       	mov    $0x1,%esi
  800491:	bf 09 00 00 00       	mov    $0x9,%edi
  800496:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  80049d:	00 00 00 
  8004a0:	ff d0                	callq  *%rax
}
  8004a2:	c9                   	leaveq 
  8004a3:	c3                   	retq   

00000000008004a4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8004a4:	55                   	push   %rbp
  8004a5:	48 89 e5             	mov    %rsp,%rbp
  8004a8:	48 83 ec 20          	sub    $0x20,%rsp
  8004ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ba:	48 98                	cltq   
  8004bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c3:	00 
  8004c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004d0:	48 89 d1             	mov    %rdx,%rcx
  8004d3:	48 89 c2             	mov    %rax,%rdx
  8004d6:	be 01 00 00 00       	mov    $0x1,%esi
  8004db:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004e0:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  8004e7:	00 00 00 
  8004ea:	ff d0                	callq  *%rax
}
  8004ec:	c9                   	leaveq 
  8004ed:	c3                   	retq   

00000000008004ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004ee:	55                   	push   %rbp
  8004ef:	48 89 e5             	mov    %rsp,%rbp
  8004f2:	48 83 ec 20          	sub    $0x20,%rsp
  8004f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800501:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800504:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800507:	48 63 f0             	movslq %eax,%rsi
  80050a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80050e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800511:	48 98                	cltq   
  800513:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800517:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80051e:	00 
  80051f:	49 89 f1             	mov    %rsi,%r9
  800522:	49 89 c8             	mov    %rcx,%r8
  800525:	48 89 d1             	mov    %rdx,%rcx
  800528:	48 89 c2             	mov    %rax,%rdx
  80052b:	be 00 00 00 00       	mov    $0x0,%esi
  800530:	bf 0c 00 00 00       	mov    $0xc,%edi
  800535:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  80053c:	00 00 00 
  80053f:	ff d0                	callq  *%rax
}
  800541:	c9                   	leaveq 
  800542:	c3                   	retq   

0000000000800543 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800543:	55                   	push   %rbp
  800544:	48 89 e5             	mov    %rsp,%rbp
  800547:	48 83 ec 10          	sub    $0x10,%rsp
  80054b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80055a:	00 
  80055b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800561:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800567:	b9 00 00 00 00       	mov    $0x0,%ecx
  80056c:	48 89 c2             	mov    %rax,%rdx
  80056f:	be 01 00 00 00       	mov    $0x1,%esi
  800574:	bf 0d 00 00 00       	mov    $0xd,%edi
  800579:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  800580:	00 00 00 
  800583:	ff d0                	callq  *%rax
}
  800585:	c9                   	leaveq 
  800586:	c3                   	retq   

0000000000800587 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800587:	55                   	push   %rbp
  800588:	48 89 e5             	mov    %rsp,%rbp
  80058b:	48 83 ec 08          	sub    $0x8,%rsp
  80058f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800593:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800597:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80059e:	ff ff ff 
  8005a1:	48 01 d0             	add    %rdx,%rax
  8005a4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8005a8:	c9                   	leaveq 
  8005a9:	c3                   	retq   

00000000008005aa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005aa:	55                   	push   %rbp
  8005ab:	48 89 e5             	mov    %rsp,%rbp
  8005ae:	48 83 ec 08          	sub    $0x8,%rsp
  8005b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8005b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ba:	48 89 c7             	mov    %rax,%rdi
  8005bd:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  8005c4:	00 00 00 
  8005c7:	ff d0                	callq  *%rax
  8005c9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005cf:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005d3:	c9                   	leaveq 
  8005d4:	c3                   	retq   

00000000008005d5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005d5:	55                   	push   %rbp
  8005d6:	48 89 e5             	mov    %rsp,%rbp
  8005d9:	48 83 ec 18          	sub    $0x18,%rsp
  8005dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005e8:	eb 6b                	jmp    800655 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ed:	48 98                	cltq   
  8005ef:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005f5:	48 c1 e0 0c          	shl    $0xc,%rax
  8005f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800601:	48 c1 e8 15          	shr    $0x15,%rax
  800605:	48 89 c2             	mov    %rax,%rdx
  800608:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80060f:	01 00 00 
  800612:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800616:	83 e0 01             	and    $0x1,%eax
  800619:	48 85 c0             	test   %rax,%rax
  80061c:	74 21                	je     80063f <fd_alloc+0x6a>
  80061e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800622:	48 c1 e8 0c          	shr    $0xc,%rax
  800626:	48 89 c2             	mov    %rax,%rdx
  800629:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800630:	01 00 00 
  800633:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800637:	83 e0 01             	and    $0x1,%eax
  80063a:	48 85 c0             	test   %rax,%rax
  80063d:	75 12                	jne    800651 <fd_alloc+0x7c>
			*fd_store = fd;
  80063f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800643:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800647:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80064a:	b8 00 00 00 00       	mov    $0x0,%eax
  80064f:	eb 1a                	jmp    80066b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800651:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800655:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800659:	7e 8f                	jle    8005ea <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800666:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80066b:	c9                   	leaveq 
  80066c:	c3                   	retq   

000000000080066d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80066d:	55                   	push   %rbp
  80066e:	48 89 e5             	mov    %rsp,%rbp
  800671:	48 83 ec 20          	sub    $0x20,%rsp
  800675:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800678:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80067c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800680:	78 06                	js     800688 <fd_lookup+0x1b>
  800682:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800686:	7e 07                	jle    80068f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800688:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80068d:	eb 6c                	jmp    8006fb <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80068f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800692:	48 98                	cltq   
  800694:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80069a:	48 c1 e0 0c          	shl    $0xc,%rax
  80069e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8006a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006a6:	48 c1 e8 15          	shr    $0x15,%rax
  8006aa:	48 89 c2             	mov    %rax,%rdx
  8006ad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006b4:	01 00 00 
  8006b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006bb:	83 e0 01             	and    $0x1,%eax
  8006be:	48 85 c0             	test   %rax,%rax
  8006c1:	74 21                	je     8006e4 <fd_lookup+0x77>
  8006c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c7:	48 c1 e8 0c          	shr    $0xc,%rax
  8006cb:	48 89 c2             	mov    %rax,%rdx
  8006ce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006d5:	01 00 00 
  8006d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006dc:	83 e0 01             	and    $0x1,%eax
  8006df:	48 85 c0             	test   %rax,%rax
  8006e2:	75 07                	jne    8006eb <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006e9:	eb 10                	jmp    8006fb <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006f3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006fb:	c9                   	leaveq 
  8006fc:	c3                   	retq   

00000000008006fd <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006fd:	55                   	push   %rbp
  8006fe:	48 89 e5             	mov    %rsp,%rbp
  800701:	48 83 ec 30          	sub    $0x30,%rsp
  800705:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800709:	89 f0                	mov    %esi,%eax
  80070b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80070e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800712:	48 89 c7             	mov    %rax,%rdi
  800715:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  80071c:	00 00 00 
  80071f:	ff d0                	callq  *%rax
  800721:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800725:	48 89 d6             	mov    %rdx,%rsi
  800728:	89 c7                	mov    %eax,%edi
  80072a:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800731:	00 00 00 
  800734:	ff d0                	callq  *%rax
  800736:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800739:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80073d:	78 0a                	js     800749 <fd_close+0x4c>
	    || fd != fd2)
  80073f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800743:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800747:	74 12                	je     80075b <fd_close+0x5e>
		return (must_exist ? r : 0);
  800749:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80074d:	74 05                	je     800754 <fd_close+0x57>
  80074f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800752:	eb 05                	jmp    800759 <fd_close+0x5c>
  800754:	b8 00 00 00 00       	mov    $0x0,%eax
  800759:	eb 69                	jmp    8007c4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80075b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80075f:	8b 00                	mov    (%rax),%eax
  800761:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800765:	48 89 d6             	mov    %rdx,%rsi
  800768:	89 c7                	mov    %eax,%edi
  80076a:	48 b8 c6 07 80 00 00 	movabs $0x8007c6,%rax
  800771:	00 00 00 
  800774:	ff d0                	callq  *%rax
  800776:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800779:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80077d:	78 2a                	js     8007a9 <fd_close+0xac>
		if (dev->dev_close)
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	48 8b 40 20          	mov    0x20(%rax),%rax
  800787:	48 85 c0             	test   %rax,%rax
  80078a:	74 16                	je     8007a2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80078c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800790:	48 8b 40 20          	mov    0x20(%rax),%rax
  800794:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800798:	48 89 d7             	mov    %rdx,%rdi
  80079b:	ff d0                	callq  *%rax
  80079d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007a0:	eb 07                	jmp    8007a9 <fd_close+0xac>
		else
			r = 0;
  8007a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8007a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ad:	48 89 c6             	mov    %rax,%rsi
  8007b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8007b5:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  8007bc:	00 00 00 
  8007bf:	ff d0                	callq  *%rax
	return r;
  8007c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007c4:	c9                   	leaveq 
  8007c5:	c3                   	retq   

00000000008007c6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007c6:	55                   	push   %rbp
  8007c7:	48 89 e5             	mov    %rsp,%rbp
  8007ca:	48 83 ec 20          	sub    $0x20,%rsp
  8007ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007dc:	eb 41                	jmp    80081f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007de:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e5:	00 00 00 
  8007e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007eb:	48 63 d2             	movslq %edx,%rdx
  8007ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f2:	8b 00                	mov    (%rax),%eax
  8007f4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007f7:	75 22                	jne    80081b <dev_lookup+0x55>
			*dev = devtab[i];
  8007f9:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800800:	00 00 00 
  800803:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800806:	48 63 d2             	movslq %edx,%rdx
  800809:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80080d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800811:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800814:	b8 00 00 00 00       	mov    $0x0,%eax
  800819:	eb 60                	jmp    80087b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80081b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80081f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800826:	00 00 00 
  800829:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80082c:	48 63 d2             	movslq %edx,%rdx
  80082f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800833:	48 85 c0             	test   %rax,%rax
  800836:	75 a6                	jne    8007de <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800838:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80083f:	00 00 00 
  800842:	48 8b 00             	mov    (%rax),%rax
  800845:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80084b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80084e:	89 c6                	mov    %eax,%esi
  800850:	48 bf 58 36 80 00 00 	movabs $0x803658,%rdi
  800857:	00 00 00 
  80085a:	b8 00 00 00 00       	mov    $0x0,%eax
  80085f:	48 b9 85 20 80 00 00 	movabs $0x802085,%rcx
  800866:	00 00 00 
  800869:	ff d1                	callq  *%rcx
	*dev = 0;
  80086b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80086f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800876:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80087b:	c9                   	leaveq 
  80087c:	c3                   	retq   

000000000080087d <close>:

int
close(int fdnum)
{
  80087d:	55                   	push   %rbp
  80087e:	48 89 e5             	mov    %rsp,%rbp
  800881:	48 83 ec 20          	sub    $0x20,%rsp
  800885:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800888:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80088c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80088f:	48 89 d6             	mov    %rdx,%rsi
  800892:	89 c7                	mov    %eax,%edi
  800894:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  80089b:	00 00 00 
  80089e:	ff d0                	callq  *%rax
  8008a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008a7:	79 05                	jns    8008ae <close+0x31>
		return r;
  8008a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ac:	eb 18                	jmp    8008c6 <close+0x49>
	else
		return fd_close(fd, 1);
  8008ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b2:	be 01 00 00 00       	mov    $0x1,%esi
  8008b7:	48 89 c7             	mov    %rax,%rdi
  8008ba:	48 b8 fd 06 80 00 00 	movabs $0x8006fd,%rax
  8008c1:	00 00 00 
  8008c4:	ff d0                	callq  *%rax
}
  8008c6:	c9                   	leaveq 
  8008c7:	c3                   	retq   

00000000008008c8 <close_all>:

void
close_all(void)
{
  8008c8:	55                   	push   %rbp
  8008c9:	48 89 e5             	mov    %rsp,%rbp
  8008cc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008d7:	eb 15                	jmp    8008ee <close_all+0x26>
		close(i);
  8008d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008dc:	89 c7                	mov    %eax,%edi
  8008de:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  8008e5:	00 00 00 
  8008e8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008ea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008ee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008f2:	7e e5                	jle    8008d9 <close_all+0x11>
		close(i);
}
  8008f4:	c9                   	leaveq 
  8008f5:	c3                   	retq   

00000000008008f6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008f6:	55                   	push   %rbp
  8008f7:	48 89 e5             	mov    %rsp,%rbp
  8008fa:	48 83 ec 40          	sub    $0x40,%rsp
  8008fe:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800901:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800904:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800908:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80090b:	48 89 d6             	mov    %rdx,%rsi
  80090e:	89 c7                	mov    %eax,%edi
  800910:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800917:	00 00 00 
  80091a:	ff d0                	callq  *%rax
  80091c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80091f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800923:	79 08                	jns    80092d <dup+0x37>
		return r;
  800925:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800928:	e9 70 01 00 00       	jmpq   800a9d <dup+0x1a7>
	close(newfdnum);
  80092d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800930:	89 c7                	mov    %eax,%edi
  800932:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  800939:	00 00 00 
  80093c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80093e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800941:	48 98                	cltq   
  800943:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800949:	48 c1 e0 0c          	shl    $0xc,%rax
  80094d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800955:	48 89 c7             	mov    %rax,%rdi
  800958:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  80095f:	00 00 00 
  800962:	ff d0                	callq  *%rax
  800964:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80096c:	48 89 c7             	mov    %rax,%rdi
  80096f:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  800976:	00 00 00 
  800979:	ff d0                	callq  *%rax
  80097b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 c1 e8 15          	shr    $0x15,%rax
  800987:	48 89 c2             	mov    %rax,%rdx
  80098a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800991:	01 00 00 
  800994:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800998:	83 e0 01             	and    $0x1,%eax
  80099b:	48 85 c0             	test   %rax,%rax
  80099e:	74 73                	je     800a13 <dup+0x11d>
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8009a8:	48 89 c2             	mov    %rax,%rdx
  8009ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b2:	01 00 00 
  8009b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009b9:	83 e0 01             	and    $0x1,%eax
  8009bc:	48 85 c0             	test   %rax,%rax
  8009bf:	74 52                	je     800a13 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c5:	48 c1 e8 0c          	shr    $0xc,%rax
  8009c9:	48 89 c2             	mov    %rax,%rdx
  8009cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009d3:	01 00 00 
  8009d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009da:	25 07 0e 00 00       	and    $0xe07,%eax
  8009df:	89 c1                	mov    %eax,%ecx
  8009e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e9:	41 89 c8             	mov    %ecx,%r8d
  8009ec:	48 89 d1             	mov    %rdx,%rcx
  8009ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f4:	48 89 c6             	mov    %rax,%rsi
  8009f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fc:	48 b8 6a 03 80 00 00 	movabs $0x80036a,%rax
  800a03:	00 00 00 
  800a06:	ff d0                	callq  *%rax
  800a08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a0f:	79 02                	jns    800a13 <dup+0x11d>
			goto err;
  800a11:	eb 57                	jmp    800a6a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a17:	48 c1 e8 0c          	shr    $0xc,%rax
  800a1b:	48 89 c2             	mov    %rax,%rdx
  800a1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a25:	01 00 00 
  800a28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a2c:	25 07 0e 00 00       	and    $0xe07,%eax
  800a31:	89 c1                	mov    %eax,%ecx
  800a33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a3b:	41 89 c8             	mov    %ecx,%r8d
  800a3e:	48 89 d1             	mov    %rdx,%rcx
  800a41:	ba 00 00 00 00       	mov    $0x0,%edx
  800a46:	48 89 c6             	mov    %rax,%rsi
  800a49:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4e:	48 b8 6a 03 80 00 00 	movabs $0x80036a,%rax
  800a55:	00 00 00 
  800a58:	ff d0                	callq  *%rax
  800a5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a61:	79 02                	jns    800a65 <dup+0x16f>
		goto err;
  800a63:	eb 05                	jmp    800a6a <dup+0x174>

	return newfdnum;
  800a65:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a68:	eb 33                	jmp    800a9d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6e:	48 89 c6             	mov    %rax,%rsi
  800a71:	bf 00 00 00 00       	mov    $0x0,%edi
  800a76:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  800a7d:	00 00 00 
  800a80:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a86:	48 89 c6             	mov    %rax,%rsi
  800a89:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8e:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  800a95:	00 00 00 
  800a98:	ff d0                	callq  *%rax
	return r;
  800a9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a9d:	c9                   	leaveq 
  800a9e:	c3                   	retq   

0000000000800a9f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a9f:	55                   	push   %rbp
  800aa0:	48 89 e5             	mov    %rsp,%rbp
  800aa3:	48 83 ec 40          	sub    $0x40,%rsp
  800aa7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800aaa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800aae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ab2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ab6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ab9:	48 89 d6             	mov    %rdx,%rsi
  800abc:	89 c7                	mov    %eax,%edi
  800abe:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800ac5:	00 00 00 
  800ac8:	ff d0                	callq  *%rax
  800aca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad1:	78 24                	js     800af7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad7:	8b 00                	mov    (%rax),%eax
  800ad9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800add:	48 89 d6             	mov    %rdx,%rsi
  800ae0:	89 c7                	mov    %eax,%edi
  800ae2:	48 b8 c6 07 80 00 00 	movabs $0x8007c6,%rax
  800ae9:	00 00 00 
  800aec:	ff d0                	callq  *%rax
  800aee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800af1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800af5:	79 05                	jns    800afc <read+0x5d>
		return r;
  800af7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800afa:	eb 76                	jmp    800b72 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b00:	8b 40 08             	mov    0x8(%rax),%eax
  800b03:	83 e0 03             	and    $0x3,%eax
  800b06:	83 f8 01             	cmp    $0x1,%eax
  800b09:	75 3a                	jne    800b45 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b0b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b12:	00 00 00 
  800b15:	48 8b 00             	mov    (%rax),%rax
  800b18:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b1e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b21:	89 c6                	mov    %eax,%esi
  800b23:	48 bf 77 36 80 00 00 	movabs $0x803677,%rdi
  800b2a:	00 00 00 
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b32:	48 b9 85 20 80 00 00 	movabs $0x802085,%rcx
  800b39:	00 00 00 
  800b3c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b43:	eb 2d                	jmp    800b72 <read+0xd3>
	}
	if (!dev->dev_read)
  800b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b49:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b4d:	48 85 c0             	test   %rax,%rax
  800b50:	75 07                	jne    800b59 <read+0xba>
		return -E_NOT_SUPP;
  800b52:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b57:	eb 19                	jmp    800b72 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b5d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b65:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b69:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b6d:	48 89 cf             	mov    %rcx,%rdi
  800b70:	ff d0                	callq  *%rax
}
  800b72:	c9                   	leaveq 
  800b73:	c3                   	retq   

0000000000800b74 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b74:	55                   	push   %rbp
  800b75:	48 89 e5             	mov    %rsp,%rbp
  800b78:	48 83 ec 30          	sub    $0x30,%rsp
  800b7c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b83:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b8e:	eb 49                	jmp    800bd9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b93:	48 98                	cltq   
  800b95:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b99:	48 29 c2             	sub    %rax,%rdx
  800b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b9f:	48 63 c8             	movslq %eax,%rcx
  800ba2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ba6:	48 01 c1             	add    %rax,%rcx
  800ba9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800bac:	48 89 ce             	mov    %rcx,%rsi
  800baf:	89 c7                	mov    %eax,%edi
  800bb1:	48 b8 9f 0a 80 00 00 	movabs $0x800a9f,%rax
  800bb8:	00 00 00 
  800bbb:	ff d0                	callq  *%rax
  800bbd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800bc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bc4:	79 05                	jns    800bcb <readn+0x57>
			return m;
  800bc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bc9:	eb 1c                	jmp    800be7 <readn+0x73>
		if (m == 0)
  800bcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bcf:	75 02                	jne    800bd3 <readn+0x5f>
			break;
  800bd1:	eb 11                	jmp    800be4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bd3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bd6:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bdc:	48 98                	cltq   
  800bde:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800be2:	72 ac                	jb     800b90 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800be7:	c9                   	leaveq 
  800be8:	c3                   	retq   

0000000000800be9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800be9:	55                   	push   %rbp
  800bea:	48 89 e5             	mov    %rsp,%rbp
  800bed:	48 83 ec 40          	sub    $0x40,%rsp
  800bf1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bf4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bf8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bfc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800c00:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c03:	48 89 d6             	mov    %rdx,%rsi
  800c06:	89 c7                	mov    %eax,%edi
  800c08:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800c0f:	00 00 00 
  800c12:	ff d0                	callq  *%rax
  800c14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c1b:	78 24                	js     800c41 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c21:	8b 00                	mov    (%rax),%eax
  800c23:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c27:	48 89 d6             	mov    %rdx,%rsi
  800c2a:	89 c7                	mov    %eax,%edi
  800c2c:	48 b8 c6 07 80 00 00 	movabs $0x8007c6,%rax
  800c33:	00 00 00 
  800c36:	ff d0                	callq  *%rax
  800c38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c3f:	79 05                	jns    800c46 <write+0x5d>
		return r;
  800c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c44:	eb 75                	jmp    800cbb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4a:	8b 40 08             	mov    0x8(%rax),%eax
  800c4d:	83 e0 03             	and    $0x3,%eax
  800c50:	85 c0                	test   %eax,%eax
  800c52:	75 3a                	jne    800c8e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c54:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c5b:	00 00 00 
  800c5e:	48 8b 00             	mov    (%rax),%rax
  800c61:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c67:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c6a:	89 c6                	mov    %eax,%esi
  800c6c:	48 bf 93 36 80 00 00 	movabs $0x803693,%rdi
  800c73:	00 00 00 
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	48 b9 85 20 80 00 00 	movabs $0x802085,%rcx
  800c82:	00 00 00 
  800c85:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c8c:	eb 2d                	jmp    800cbb <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c92:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c96:	48 85 c0             	test   %rax,%rax
  800c99:	75 07                	jne    800ca2 <write+0xb9>
		return -E_NOT_SUPP;
  800c9b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ca0:	eb 19                	jmp    800cbb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca6:	48 8b 40 18          	mov    0x18(%rax),%rax
  800caa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800cae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800cb6:	48 89 cf             	mov    %rcx,%rdi
  800cb9:	ff d0                	callq  *%rax
}
  800cbb:	c9                   	leaveq 
  800cbc:	c3                   	retq   

0000000000800cbd <seek>:

int
seek(int fdnum, off_t offset)
{
  800cbd:	55                   	push   %rbp
  800cbe:	48 89 e5             	mov    %rsp,%rbp
  800cc1:	48 83 ec 18          	sub    $0x18,%rsp
  800cc5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cc8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ccb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ccf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cd2:	48 89 d6             	mov    %rdx,%rsi
  800cd5:	89 c7                	mov    %eax,%edi
  800cd7:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	callq  *%rax
  800ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cea:	79 05                	jns    800cf1 <seek+0x34>
		return r;
  800cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cef:	eb 0f                	jmp    800d00 <seek+0x43>
	fd->fd_offset = offset;
  800cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cf8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d00:	c9                   	leaveq 
  800d01:	c3                   	retq   

0000000000800d02 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d02:	55                   	push   %rbp
  800d03:	48 89 e5             	mov    %rsp,%rbp
  800d06:	48 83 ec 30          	sub    $0x30,%rsp
  800d0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d0d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d10:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d14:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d17:	48 89 d6             	mov    %rdx,%rsi
  800d1a:	89 c7                	mov    %eax,%edi
  800d1c:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
  800d28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d2f:	78 24                	js     800d55 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d35:	8b 00                	mov    (%rax),%eax
  800d37:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d3b:	48 89 d6             	mov    %rdx,%rsi
  800d3e:	89 c7                	mov    %eax,%edi
  800d40:	48 b8 c6 07 80 00 00 	movabs $0x8007c6,%rax
  800d47:	00 00 00 
  800d4a:	ff d0                	callq  *%rax
  800d4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d53:	79 05                	jns    800d5a <ftruncate+0x58>
		return r;
  800d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d58:	eb 72                	jmp    800dcc <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5e:	8b 40 08             	mov    0x8(%rax),%eax
  800d61:	83 e0 03             	and    $0x3,%eax
  800d64:	85 c0                	test   %eax,%eax
  800d66:	75 3a                	jne    800da2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d68:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d6f:	00 00 00 
  800d72:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d75:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d7e:	89 c6                	mov    %eax,%esi
  800d80:	48 bf b0 36 80 00 00 	movabs $0x8036b0,%rdi
  800d87:	00 00 00 
  800d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8f:	48 b9 85 20 80 00 00 	movabs $0x802085,%rcx
  800d96:	00 00 00 
  800d99:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800da0:	eb 2a                	jmp    800dcc <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800da2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da6:	48 8b 40 30          	mov    0x30(%rax),%rax
  800daa:	48 85 c0             	test   %rax,%rax
  800dad:	75 07                	jne    800db6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800daf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800db4:	eb 16                	jmp    800dcc <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800db6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dba:	48 8b 40 30          	mov    0x30(%rax),%rax
  800dbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800dc5:	89 ce                	mov    %ecx,%esi
  800dc7:	48 89 d7             	mov    %rdx,%rdi
  800dca:	ff d0                	callq  *%rax
}
  800dcc:	c9                   	leaveq 
  800dcd:	c3                   	retq   

0000000000800dce <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800dce:	55                   	push   %rbp
  800dcf:	48 89 e5             	mov    %rsp,%rbp
  800dd2:	48 83 ec 30          	sub    $0x30,%rsp
  800dd6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dd9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ddd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800de1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800de4:	48 89 d6             	mov    %rdx,%rsi
  800de7:	89 c7                	mov    %eax,%edi
  800de9:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800df0:	00 00 00 
  800df3:	ff d0                	callq  *%rax
  800df5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dfc:	78 24                	js     800e22 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e02:	8b 00                	mov    (%rax),%eax
  800e04:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e08:	48 89 d6             	mov    %rdx,%rsi
  800e0b:	89 c7                	mov    %eax,%edi
  800e0d:	48 b8 c6 07 80 00 00 	movabs $0x8007c6,%rax
  800e14:	00 00 00 
  800e17:	ff d0                	callq  *%rax
  800e19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e20:	79 05                	jns    800e27 <fstat+0x59>
		return r;
  800e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e25:	eb 5e                	jmp    800e85 <fstat+0xb7>
	if (!dev->dev_stat)
  800e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2b:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e2f:	48 85 c0             	test   %rax,%rax
  800e32:	75 07                	jne    800e3b <fstat+0x6d>
		return -E_NOT_SUPP;
  800e34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e39:	eb 4a                	jmp    800e85 <fstat+0xb7>
	stat->st_name[0] = 0;
  800e3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e3f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e46:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e4d:	00 00 00 
	stat->st_isdir = 0;
  800e50:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e54:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e5b:	00 00 00 
	stat->st_dev = dev;
  800e5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e66:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e71:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e79:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e7d:	48 89 ce             	mov    %rcx,%rsi
  800e80:	48 89 d7             	mov    %rdx,%rdi
  800e83:	ff d0                	callq  *%rax
}
  800e85:	c9                   	leaveq 
  800e86:	c3                   	retq   

0000000000800e87 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e87:	55                   	push   %rbp
  800e88:	48 89 e5             	mov    %rsp,%rbp
  800e8b:	48 83 ec 20          	sub    $0x20,%rsp
  800e8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e93:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9b:	be 00 00 00 00       	mov    $0x0,%esi
  800ea0:	48 89 c7             	mov    %rax,%rdi
  800ea3:	48 b8 75 0f 80 00 00 	movabs $0x800f75,%rax
  800eaa:	00 00 00 
  800ead:	ff d0                	callq  *%rax
  800eaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800eb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eb6:	79 05                	jns    800ebd <stat+0x36>
		return fd;
  800eb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ebb:	eb 2f                	jmp    800eec <stat+0x65>
	r = fstat(fd, stat);
  800ebd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec4:	48 89 d6             	mov    %rdx,%rsi
  800ec7:	89 c7                	mov    %eax,%edi
  800ec9:	48 b8 ce 0d 80 00 00 	movabs $0x800dce,%rax
  800ed0:	00 00 00 
  800ed3:	ff d0                	callq  *%rax
  800ed5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800edb:	89 c7                	mov    %eax,%edi
  800edd:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  800ee4:	00 00 00 
  800ee7:	ff d0                	callq  *%rax
	return r;
  800ee9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 10          	sub    $0x10,%rsp
  800ef6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ef9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800efd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f04:	00 00 00 
  800f07:	8b 00                	mov    (%rax),%eax
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 1d                	jne    800f2a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f0d:	bf 01 00 00 00       	mov    $0x1,%edi
  800f12:	48 b8 ff 34 80 00 00 	movabs $0x8034ff,%rax
  800f19:	00 00 00 
  800f1c:	ff d0                	callq  *%rax
  800f1e:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f25:	00 00 00 
  800f28:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f2a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f31:	00 00 00 
  800f34:	8b 00                	mov    (%rax),%eax
  800f36:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f39:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f3e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f45:	00 00 00 
  800f48:	89 c7                	mov    %eax,%edi
  800f4a:	48 b8 67 34 80 00 00 	movabs $0x803467,%rax
  800f51:	00 00 00 
  800f54:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5f:	48 89 c6             	mov    %rax,%rsi
  800f62:	bf 00 00 00 00       	mov    $0x0,%edi
  800f67:	48 b8 a6 33 80 00 00 	movabs $0x8033a6,%rax
  800f6e:	00 00 00 
  800f71:	ff d0                	callq  *%rax
}
  800f73:	c9                   	leaveq 
  800f74:	c3                   	retq   

0000000000800f75 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f75:	55                   	push   %rbp
  800f76:	48 89 e5             	mov    %rsp,%rbp
  800f79:	48 83 ec 20          	sub    $0x20,%rsp
  800f7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f81:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f88:	48 89 c7             	mov    %rax,%rdi
  800f8b:	48 b8 e1 2b 80 00 00 	movabs $0x802be1,%rax
  800f92:	00 00 00 
  800f95:	ff d0                	callq  *%rax
  800f97:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f9c:	7e 0a                	jle    800fa8 <open+0x33>
		return -E_BAD_PATH;
  800f9e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800fa3:	e9 a5 00 00 00       	jmpq   80104d <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800fa8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800fac:	48 89 c7             	mov    %rax,%rdi
  800faf:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  800fb6:	00 00 00 
  800fb9:	ff d0                	callq  *%rax
  800fbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fc2:	79 08                	jns    800fcc <open+0x57>
		return r;
  800fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc7:	e9 81 00 00 00       	jmpq   80104d <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd0:	48 89 c6             	mov    %rax,%rsi
  800fd3:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fda:	00 00 00 
  800fdd:	48 b8 4d 2c 80 00 00 	movabs $0x802c4d,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fe9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ff0:	00 00 00 
  800ff3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800ff6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801000:	48 89 c6             	mov    %rax,%rsi
  801003:	bf 01 00 00 00       	mov    $0x1,%edi
  801008:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80100f:	00 00 00 
  801012:	ff d0                	callq  *%rax
  801014:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801017:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80101b:	79 1d                	jns    80103a <open+0xc5>
		fd_close(fd, 0);
  80101d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801021:	be 00 00 00 00       	mov    $0x0,%esi
  801026:	48 89 c7             	mov    %rax,%rdi
  801029:	48 b8 fd 06 80 00 00 	movabs $0x8006fd,%rax
  801030:	00 00 00 
  801033:	ff d0                	callq  *%rax
		return r;
  801035:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801038:	eb 13                	jmp    80104d <open+0xd8>
	}

	return fd2num(fd);
  80103a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103e:	48 89 c7             	mov    %rax,%rdi
  801041:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  801048:	00 00 00 
  80104b:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  80104d:	c9                   	leaveq 
  80104e:	c3                   	retq   

000000000080104f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80104f:	55                   	push   %rbp
  801050:	48 89 e5             	mov    %rsp,%rbp
  801053:	48 83 ec 10          	sub    $0x10,%rsp
  801057:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80105b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105f:	8b 50 0c             	mov    0xc(%rax),%edx
  801062:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801069:	00 00 00 
  80106c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80106e:	be 00 00 00 00       	mov    $0x0,%esi
  801073:	bf 06 00 00 00       	mov    $0x6,%edi
  801078:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80107f:	00 00 00 
  801082:	ff d0                	callq  *%rax
}
  801084:	c9                   	leaveq 
  801085:	c3                   	retq   

0000000000801086 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801086:	55                   	push   %rbp
  801087:	48 89 e5             	mov    %rsp,%rbp
  80108a:	48 83 ec 30          	sub    $0x30,%rsp
  80108e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801092:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801096:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80109a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109e:	8b 50 0c             	mov    0xc(%rax),%edx
  8010a1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010a8:	00 00 00 
  8010ab:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8010ad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010b4:	00 00 00 
  8010b7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010bb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010bf:	be 00 00 00 00       	mov    $0x0,%esi
  8010c4:	bf 03 00 00 00       	mov    $0x3,%edi
  8010c9:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
  8010d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010dc:	79 08                	jns    8010e6 <devfile_read+0x60>
		return r;
  8010de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e1:	e9 a4 00 00 00       	jmpq   80118a <devfile_read+0x104>
	assert(r <= n);
  8010e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e9:	48 98                	cltq   
  8010eb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010ef:	76 35                	jbe    801126 <devfile_read+0xa0>
  8010f1:	48 b9 dd 36 80 00 00 	movabs $0x8036dd,%rcx
  8010f8:	00 00 00 
  8010fb:	48 ba e4 36 80 00 00 	movabs $0x8036e4,%rdx
  801102:	00 00 00 
  801105:	be 84 00 00 00       	mov    $0x84,%esi
  80110a:	48 bf f9 36 80 00 00 	movabs $0x8036f9,%rdi
  801111:	00 00 00 
  801114:	b8 00 00 00 00       	mov    $0x0,%eax
  801119:	49 b8 4c 1e 80 00 00 	movabs $0x801e4c,%r8
  801120:	00 00 00 
  801123:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  801126:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80112d:	7e 35                	jle    801164 <devfile_read+0xde>
  80112f:	48 b9 04 37 80 00 00 	movabs $0x803704,%rcx
  801136:	00 00 00 
  801139:	48 ba e4 36 80 00 00 	movabs $0x8036e4,%rdx
  801140:	00 00 00 
  801143:	be 85 00 00 00       	mov    $0x85,%esi
  801148:	48 bf f9 36 80 00 00 	movabs $0x8036f9,%rdi
  80114f:	00 00 00 
  801152:	b8 00 00 00 00       	mov    $0x0,%eax
  801157:	49 b8 4c 1e 80 00 00 	movabs $0x801e4c,%r8
  80115e:	00 00 00 
  801161:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801167:	48 63 d0             	movslq %eax,%rdx
  80116a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801175:	00 00 00 
  801178:	48 89 c7             	mov    %rax,%rdi
  80117b:	48 b8 71 2f 80 00 00 	movabs $0x802f71,%rax
  801182:	00 00 00 
  801185:	ff d0                	callq  *%rax
	return r;
  801187:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80118a:	c9                   	leaveq 
  80118b:	c3                   	retq   

000000000080118c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80118c:	55                   	push   %rbp
  80118d:	48 89 e5             	mov    %rsp,%rbp
  801190:	48 83 ec 30          	sub    $0x30,%rsp
  801194:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801198:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80119c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8011a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a4:	8b 50 0c             	mov    0xc(%rax),%edx
  8011a7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011ae:	00 00 00 
  8011b1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8011b3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011ba:	00 00 00 
  8011bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011c1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8011c5:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011cc:	00 
  8011cd:	76 35                	jbe    801204 <devfile_write+0x78>
  8011cf:	48 b9 10 37 80 00 00 	movabs $0x803710,%rcx
  8011d6:	00 00 00 
  8011d9:	48 ba e4 36 80 00 00 	movabs $0x8036e4,%rdx
  8011e0:	00 00 00 
  8011e3:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011e8:	48 bf f9 36 80 00 00 	movabs $0x8036f9,%rdi
  8011ef:	00 00 00 
  8011f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f7:	49 b8 4c 1e 80 00 00 	movabs $0x801e4c,%r8
  8011fe:	00 00 00 
  801201:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801204:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801208:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120c:	48 89 c6             	mov    %rax,%rsi
  80120f:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801216:	00 00 00 
  801219:	48 b8 88 30 80 00 00 	movabs $0x803088,%rax
  801220:	00 00 00 
  801223:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801225:	be 00 00 00 00       	mov    $0x0,%esi
  80122a:	bf 04 00 00 00       	mov    $0x4,%edi
  80122f:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  801236:	00 00 00 
  801239:	ff d0                	callq  *%rax
  80123b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80123e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801242:	79 05                	jns    801249 <devfile_write+0xbd>
		return r;
  801244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801247:	eb 43                	jmp    80128c <devfile_write+0x100>
	assert(r <= n);
  801249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80124c:	48 98                	cltq   
  80124e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801252:	76 35                	jbe    801289 <devfile_write+0xfd>
  801254:	48 b9 dd 36 80 00 00 	movabs $0x8036dd,%rcx
  80125b:	00 00 00 
  80125e:	48 ba e4 36 80 00 00 	movabs $0x8036e4,%rdx
  801265:	00 00 00 
  801268:	be a2 00 00 00       	mov    $0xa2,%esi
  80126d:	48 bf f9 36 80 00 00 	movabs $0x8036f9,%rdi
  801274:	00 00 00 
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
  80127c:	49 b8 4c 1e 80 00 00 	movabs $0x801e4c,%r8
  801283:	00 00 00 
  801286:	41 ff d0             	callq  *%r8
	return r;
  801289:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80128c:	c9                   	leaveq 
  80128d:	c3                   	retq   

000000000080128e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80128e:	55                   	push   %rbp
  80128f:	48 89 e5             	mov    %rsp,%rbp
  801292:	48 83 ec 20          	sub    $0x20,%rsp
  801296:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	8b 50 0c             	mov    0xc(%rax),%edx
  8012a5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012ac:	00 00 00 
  8012af:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012b1:	be 00 00 00 00       	mov    $0x0,%esi
  8012b6:	bf 05 00 00 00       	mov    $0x5,%edi
  8012bb:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8012c2:	00 00 00 
  8012c5:	ff d0                	callq  *%rax
  8012c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012ce:	79 05                	jns    8012d5 <devfile_stat+0x47>
		return r;
  8012d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012d3:	eb 56                	jmp    80132b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d9:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012e0:	00 00 00 
  8012e3:	48 89 c7             	mov    %rax,%rdi
  8012e6:	48 b8 4d 2c 80 00 00 	movabs $0x802c4d,%rax
  8012ed:	00 00 00 
  8012f0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012f2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012f9:	00 00 00 
  8012fc:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801302:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801306:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80130c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801313:	00 00 00 
  801316:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80131c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801320:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leaveq 
  80132c:	c3                   	retq   

000000000080132d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80132d:	55                   	push   %rbp
  80132e:	48 89 e5             	mov    %rsp,%rbp
  801331:	48 83 ec 10          	sub    $0x10,%rsp
  801335:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801339:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	8b 50 0c             	mov    0xc(%rax),%edx
  801343:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80134a:	00 00 00 
  80134d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80134f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801356:	00 00 00 
  801359:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80135c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80135f:	be 00 00 00 00       	mov    $0x0,%esi
  801364:	bf 02 00 00 00       	mov    $0x2,%edi
  801369:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  801370:	00 00 00 
  801373:	ff d0                	callq  *%rax
}
  801375:	c9                   	leaveq 
  801376:	c3                   	retq   

0000000000801377 <remove>:

// Delete a file
int
remove(const char *path)
{
  801377:	55                   	push   %rbp
  801378:	48 89 e5             	mov    %rsp,%rbp
  80137b:	48 83 ec 10          	sub    $0x10,%rsp
  80137f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801387:	48 89 c7             	mov    %rax,%rdi
  80138a:	48 b8 e1 2b 80 00 00 	movabs $0x802be1,%rax
  801391:	00 00 00 
  801394:	ff d0                	callq  *%rax
  801396:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80139b:	7e 07                	jle    8013a4 <remove+0x2d>
		return -E_BAD_PATH;
  80139d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8013a2:	eb 33                	jmp    8013d7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8013a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a8:	48 89 c6             	mov    %rax,%rsi
  8013ab:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8013b2:	00 00 00 
  8013b5:	48 b8 4d 2c 80 00 00 	movabs $0x802c4d,%rax
  8013bc:	00 00 00 
  8013bf:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8013c1:	be 00 00 00 00       	mov    $0x0,%esi
  8013c6:	bf 07 00 00 00       	mov    $0x7,%edi
  8013cb:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8013d2:	00 00 00 
  8013d5:	ff d0                	callq  *%rax
}
  8013d7:	c9                   	leaveq 
  8013d8:	c3                   	retq   

00000000008013d9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013d9:	55                   	push   %rbp
  8013da:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013dd:	be 00 00 00 00       	mov    $0x0,%esi
  8013e2:	bf 08 00 00 00       	mov    $0x8,%edi
  8013e7:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  8013ee:	00 00 00 
  8013f1:	ff d0                	callq  *%rax
}
  8013f3:	5d                   	pop    %rbp
  8013f4:	c3                   	retq   

00000000008013f5 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013f5:	55                   	push   %rbp
  8013f6:	48 89 e5             	mov    %rsp,%rbp
  8013f9:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801400:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801407:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80140e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801415:	be 00 00 00 00       	mov    $0x0,%esi
  80141a:	48 89 c7             	mov    %rax,%rdi
  80141d:	48 b8 75 0f 80 00 00 	movabs $0x800f75,%rax
  801424:	00 00 00 
  801427:	ff d0                	callq  *%rax
  801429:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80142c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801430:	79 28                	jns    80145a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801435:	89 c6                	mov    %eax,%esi
  801437:	48 bf 3d 37 80 00 00 	movabs $0x80373d,%rdi
  80143e:	00 00 00 
  801441:	b8 00 00 00 00       	mov    $0x0,%eax
  801446:	48 ba 85 20 80 00 00 	movabs $0x802085,%rdx
  80144d:	00 00 00 
  801450:	ff d2                	callq  *%rdx
		return fd_src;
  801452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801455:	e9 74 01 00 00       	jmpq   8015ce <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80145a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801461:	be 01 01 00 00       	mov    $0x101,%esi
  801466:	48 89 c7             	mov    %rax,%rdi
  801469:	48 b8 75 0f 80 00 00 	movabs $0x800f75,%rax
  801470:	00 00 00 
  801473:	ff d0                	callq  *%rax
  801475:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801478:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80147c:	79 39                	jns    8014b7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80147e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801481:	89 c6                	mov    %eax,%esi
  801483:	48 bf 53 37 80 00 00 	movabs $0x803753,%rdi
  80148a:	00 00 00 
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
  801492:	48 ba 85 20 80 00 00 	movabs $0x802085,%rdx
  801499:	00 00 00 
  80149c:	ff d2                	callq  *%rdx
		close(fd_src);
  80149e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014a1:	89 c7                	mov    %eax,%edi
  8014a3:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  8014aa:	00 00 00 
  8014ad:	ff d0                	callq  *%rax
		return fd_dest;
  8014af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014b2:	e9 17 01 00 00       	jmpq   8015ce <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014b7:	eb 74                	jmp    80152d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8014b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014bc:	48 63 d0             	movslq %eax,%rdx
  8014bf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014c9:	48 89 ce             	mov    %rcx,%rsi
  8014cc:	89 c7                	mov    %eax,%edi
  8014ce:	48 b8 e9 0b 80 00 00 	movabs $0x800be9,%rax
  8014d5:	00 00 00 
  8014d8:	ff d0                	callq  *%rax
  8014da:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014e1:	79 4a                	jns    80152d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014e6:	89 c6                	mov    %eax,%esi
  8014e8:	48 bf 6d 37 80 00 00 	movabs $0x80376d,%rdi
  8014ef:	00 00 00 
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f7:	48 ba 85 20 80 00 00 	movabs $0x802085,%rdx
  8014fe:	00 00 00 
  801501:	ff d2                	callq  *%rdx
			close(fd_src);
  801503:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801506:	89 c7                	mov    %eax,%edi
  801508:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  80150f:	00 00 00 
  801512:	ff d0                	callq  *%rax
			close(fd_dest);
  801514:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801517:	89 c7                	mov    %eax,%edi
  801519:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  801520:	00 00 00 
  801523:	ff d0                	callq  *%rax
			return write_size;
  801525:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801528:	e9 a1 00 00 00       	jmpq   8015ce <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80152d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801537:	ba 00 02 00 00       	mov    $0x200,%edx
  80153c:	48 89 ce             	mov    %rcx,%rsi
  80153f:	89 c7                	mov    %eax,%edi
  801541:	48 b8 9f 0a 80 00 00 	movabs $0x800a9f,%rax
  801548:	00 00 00 
  80154b:	ff d0                	callq  *%rax
  80154d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801550:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801554:	0f 8f 5f ff ff ff    	jg     8014b9 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80155a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80155e:	79 47                	jns    8015a7 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801560:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801563:	89 c6                	mov    %eax,%esi
  801565:	48 bf 80 37 80 00 00 	movabs $0x803780,%rdi
  80156c:	00 00 00 
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	48 ba 85 20 80 00 00 	movabs $0x802085,%rdx
  80157b:	00 00 00 
  80157e:	ff d2                	callq  *%rdx
		close(fd_src);
  801580:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801583:	89 c7                	mov    %eax,%edi
  801585:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  80158c:	00 00 00 
  80158f:	ff d0                	callq  *%rax
		close(fd_dest);
  801591:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801594:	89 c7                	mov    %eax,%edi
  801596:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  80159d:	00 00 00 
  8015a0:	ff d0                	callq  *%rax
		return read_size;
  8015a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015a5:	eb 27                	jmp    8015ce <copy+0x1d9>
	}
	close(fd_src);
  8015a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015aa:	89 c7                	mov    %eax,%edi
  8015ac:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  8015b3:	00 00 00 
  8015b6:	ff d0                	callq  *%rax
	close(fd_dest);
  8015b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015bb:	89 c7                	mov    %eax,%edi
  8015bd:	48 b8 7d 08 80 00 00 	movabs $0x80087d,%rax
  8015c4:	00 00 00 
  8015c7:	ff d0                	callq  *%rax
	return 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015ce:	c9                   	leaveq 
  8015cf:	c3                   	retq   

00000000008015d0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015d0:	55                   	push   %rbp
  8015d1:	48 89 e5             	mov    %rsp,%rbp
  8015d4:	53                   	push   %rbx
  8015d5:	48 83 ec 38          	sub    $0x38,%rsp
  8015d9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015dd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015e1:	48 89 c7             	mov    %rax,%rdi
  8015e4:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  8015eb:	00 00 00 
  8015ee:	ff d0                	callq  *%rax
  8015f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015f7:	0f 88 bf 01 00 00    	js     8017bc <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801601:	ba 07 04 00 00       	mov    $0x407,%edx
  801606:	48 89 c6             	mov    %rax,%rsi
  801609:	bf 00 00 00 00       	mov    $0x0,%edi
  80160e:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  801615:	00 00 00 
  801618:	ff d0                	callq  *%rax
  80161a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80161d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801621:	0f 88 95 01 00 00    	js     8017bc <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801627:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80162b:	48 89 c7             	mov    %rax,%rdi
  80162e:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  801635:	00 00 00 
  801638:	ff d0                	callq  *%rax
  80163a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80163d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801641:	0f 88 5d 01 00 00    	js     8017a4 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801647:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80164b:	ba 07 04 00 00       	mov    $0x407,%edx
  801650:	48 89 c6             	mov    %rax,%rsi
  801653:	bf 00 00 00 00       	mov    $0x0,%edi
  801658:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  80165f:	00 00 00 
  801662:	ff d0                	callq  *%rax
  801664:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801667:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80166b:	0f 88 33 01 00 00    	js     8017a4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801675:	48 89 c7             	mov    %rax,%rdi
  801678:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  80167f:	00 00 00 
  801682:	ff d0                	callq  *%rax
  801684:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801688:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80168c:	ba 07 04 00 00       	mov    $0x407,%edx
  801691:	48 89 c6             	mov    %rax,%rsi
  801694:	bf 00 00 00 00       	mov    $0x0,%edi
  801699:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  8016a0:	00 00 00 
  8016a3:	ff d0                	callq  *%rax
  8016a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016ac:	79 05                	jns    8016b3 <pipe+0xe3>
		goto err2;
  8016ae:	e9 d9 00 00 00       	jmpq   80178c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016b7:	48 89 c7             	mov    %rax,%rdi
  8016ba:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  8016c1:	00 00 00 
  8016c4:	ff d0                	callq  *%rax
  8016c6:	48 89 c2             	mov    %rax,%rdx
  8016c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016cd:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016d3:	48 89 d1             	mov    %rdx,%rcx
  8016d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016db:	48 89 c6             	mov    %rax,%rsi
  8016de:	bf 00 00 00 00       	mov    $0x0,%edi
  8016e3:	48 b8 6a 03 80 00 00 	movabs $0x80036a,%rax
  8016ea:	00 00 00 
  8016ed:	ff d0                	callq  *%rax
  8016ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016f6:	79 1b                	jns    801713 <pipe+0x143>
		goto err3;
  8016f8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016fd:	48 89 c6             	mov    %rax,%rsi
  801700:	bf 00 00 00 00       	mov    $0x0,%edi
  801705:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  80170c:	00 00 00 
  80170f:	ff d0                	callq  *%rax
  801711:	eb 79                	jmp    80178c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801717:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80171e:	00 00 00 
  801721:	8b 12                	mov    (%rdx),%edx
  801723:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801730:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801734:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80173b:	00 00 00 
  80173e:	8b 12                	mov    (%rdx),%edx
  801740:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801742:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801746:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	48 89 c7             	mov    %rax,%rdi
  801754:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  80175b:	00 00 00 
  80175e:	ff d0                	callq  *%rax
  801760:	89 c2                	mov    %eax,%edx
  801762:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801766:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801768:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80176c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801770:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801774:	48 89 c7             	mov    %rax,%rdi
  801777:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  80177e:	00 00 00 
  801781:	ff d0                	callq  *%rax
  801783:	89 03                	mov    %eax,(%rbx)
	return 0;
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
  80178a:	eb 33                	jmp    8017bf <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80178c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801790:	48 89 c6             	mov    %rax,%rsi
  801793:	bf 00 00 00 00       	mov    $0x0,%edi
  801798:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  80179f:	00 00 00 
  8017a2:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	48 89 c6             	mov    %rax,%rsi
  8017ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8017b0:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  8017b7:	00 00 00 
  8017ba:	ff d0                	callq  *%rax
err:
	return r;
  8017bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8017bf:	48 83 c4 38          	add    $0x38,%rsp
  8017c3:	5b                   	pop    %rbx
  8017c4:	5d                   	pop    %rbp
  8017c5:	c3                   	retq   

00000000008017c6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017c6:	55                   	push   %rbp
  8017c7:	48 89 e5             	mov    %rsp,%rbp
  8017ca:	53                   	push   %rbx
  8017cb:	48 83 ec 28          	sub    $0x28,%rsp
  8017cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017d7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017de:	00 00 00 
  8017e1:	48 8b 00             	mov    (%rax),%rax
  8017e4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	48 89 c7             	mov    %rax,%rdi
  8017f4:	48 b8 81 35 80 00 00 	movabs $0x803581,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	callq  *%rax
  801800:	89 c3                	mov    %eax,%ebx
  801802:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801806:	48 89 c7             	mov    %rax,%rdi
  801809:	48 b8 81 35 80 00 00 	movabs $0x803581,%rax
  801810:	00 00 00 
  801813:	ff d0                	callq  *%rax
  801815:	39 c3                	cmp    %eax,%ebx
  801817:	0f 94 c0             	sete   %al
  80181a:	0f b6 c0             	movzbl %al,%eax
  80181d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801820:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801827:	00 00 00 
  80182a:	48 8b 00             	mov    (%rax),%rax
  80182d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801833:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801836:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801839:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80183c:	75 05                	jne    801843 <_pipeisclosed+0x7d>
			return ret;
  80183e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801841:	eb 4f                	jmp    801892 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801843:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801846:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801849:	74 42                	je     80188d <_pipeisclosed+0xc7>
  80184b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80184f:	75 3c                	jne    80188d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801851:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801858:	00 00 00 
  80185b:	48 8b 00             	mov    (%rax),%rax
  80185e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801864:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801867:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80186a:	89 c6                	mov    %eax,%esi
  80186c:	48 bf 9b 37 80 00 00 	movabs $0x80379b,%rdi
  801873:	00 00 00 
  801876:	b8 00 00 00 00       	mov    $0x0,%eax
  80187b:	49 b8 85 20 80 00 00 	movabs $0x802085,%r8
  801882:	00 00 00 
  801885:	41 ff d0             	callq  *%r8
	}
  801888:	e9 4a ff ff ff       	jmpq   8017d7 <_pipeisclosed+0x11>
  80188d:	e9 45 ff ff ff       	jmpq   8017d7 <_pipeisclosed+0x11>
}
  801892:	48 83 c4 28          	add    $0x28,%rsp
  801896:	5b                   	pop    %rbx
  801897:	5d                   	pop    %rbp
  801898:	c3                   	retq   

0000000000801899 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801899:	55                   	push   %rbp
  80189a:	48 89 e5             	mov    %rsp,%rbp
  80189d:	48 83 ec 30          	sub    $0x30,%rsp
  8018a1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8018a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018ab:	48 89 d6             	mov    %rdx,%rsi
  8018ae:	89 c7                	mov    %eax,%edi
  8018b0:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  8018b7:	00 00 00 
  8018ba:	ff d0                	callq  *%rax
  8018bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c3:	79 05                	jns    8018ca <pipeisclosed+0x31>
		return r;
  8018c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c8:	eb 31                	jmp    8018fb <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8018ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ce:	48 89 c7             	mov    %rax,%rdi
  8018d1:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  8018d8:	00 00 00 
  8018db:	ff d0                	callq  *%rax
  8018dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e9:	48 89 d6             	mov    %rdx,%rsi
  8018ec:	48 89 c7             	mov    %rax,%rdi
  8018ef:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 40          	sub    $0x40,%rsp
  801905:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801909:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80190d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801915:	48 89 c7             	mov    %rax,%rdi
  801918:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  80191f:	00 00 00 
  801922:	ff d0                	callq  *%rax
  801924:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801928:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80192c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801930:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801937:	00 
  801938:	e9 92 00 00 00       	jmpq   8019cf <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80193d:	eb 41                	jmp    801980 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80193f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801944:	74 09                	je     80194f <devpipe_read+0x52>
				return i;
  801946:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194a:	e9 92 00 00 00       	jmpq   8019e1 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80194f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801957:	48 89 d6             	mov    %rdx,%rsi
  80195a:	48 89 c7             	mov    %rax,%rdi
  80195d:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  801964:	00 00 00 
  801967:	ff d0                	callq  *%rax
  801969:	85 c0                	test   %eax,%eax
  80196b:	74 07                	je     801974 <devpipe_read+0x77>
				return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	eb 6d                	jmp    8019e1 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801974:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  80197b:	00 00 00 
  80197e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801980:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801984:	8b 10                	mov    (%rax),%edx
  801986:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198a:	8b 40 04             	mov    0x4(%rax),%eax
  80198d:	39 c2                	cmp    %eax,%edx
  80198f:	74 ae                	je     80193f <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801991:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801999:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80199d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a1:	8b 00                	mov    (%rax),%eax
  8019a3:	99                   	cltd   
  8019a4:	c1 ea 1b             	shr    $0x1b,%edx
  8019a7:	01 d0                	add    %edx,%eax
  8019a9:	83 e0 1f             	and    $0x1f,%eax
  8019ac:	29 d0                	sub    %edx,%eax
  8019ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b2:	48 98                	cltq   
  8019b4:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8019b9:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8019bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019bf:	8b 00                	mov    (%rax),%eax
  8019c1:	8d 50 01             	lea    0x1(%rax),%edx
  8019c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c8:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019d7:	0f 82 60 ff ff ff    	jb     80193d <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019e1:	c9                   	leaveq 
  8019e2:	c3                   	retq   

00000000008019e3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019e3:	55                   	push   %rbp
  8019e4:	48 89 e5             	mov    %rsp,%rbp
  8019e7:	48 83 ec 40          	sub    $0x40,%rsp
  8019eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019ef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019f3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	48 89 c7             	mov    %rax,%rdi
  8019fe:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
  801a0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801a0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801a16:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a1d:	00 
  801a1e:	e9 8e 00 00 00       	jmpq   801ab1 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a23:	eb 31                	jmp    801a56 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2d:	48 89 d6             	mov    %rdx,%rsi
  801a30:	48 89 c7             	mov    %rax,%rdi
  801a33:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	callq  *%rax
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	74 07                	je     801a4a <devpipe_write+0x67>
				return 0;
  801a43:	b8 00 00 00 00       	mov    $0x0,%eax
  801a48:	eb 79                	jmp    801ac3 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a4a:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  801a51:	00 00 00 
  801a54:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5a:	8b 40 04             	mov    0x4(%rax),%eax
  801a5d:	48 63 d0             	movslq %eax,%rdx
  801a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a64:	8b 00                	mov    (%rax),%eax
  801a66:	48 98                	cltq   
  801a68:	48 83 c0 20          	add    $0x20,%rax
  801a6c:	48 39 c2             	cmp    %rax,%rdx
  801a6f:	73 b4                	jae    801a25 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a75:	8b 40 04             	mov    0x4(%rax),%eax
  801a78:	99                   	cltd   
  801a79:	c1 ea 1b             	shr    $0x1b,%edx
  801a7c:	01 d0                	add    %edx,%eax
  801a7e:	83 e0 1f             	and    $0x1f,%eax
  801a81:	29 d0                	sub    %edx,%eax
  801a83:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a87:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a8b:	48 01 ca             	add    %rcx,%rdx
  801a8e:	0f b6 0a             	movzbl (%rdx),%ecx
  801a91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a95:	48 98                	cltq   
  801a97:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a9f:	8b 40 04             	mov    0x4(%rax),%eax
  801aa2:	8d 50 01             	lea    0x1(%rax),%edx
  801aa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa9:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801aac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801ab9:	0f 82 64 ff ff ff    	jb     801a23 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801abf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801ac3:	c9                   	leaveq 
  801ac4:	c3                   	retq   

0000000000801ac5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	48 83 ec 20          	sub    $0x20,%rsp
  801acd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ad1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad9:	48 89 c7             	mov    %rax,%rdi
  801adc:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	callq  *%rax
  801ae8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af0:	48 be ae 37 80 00 00 	movabs $0x8037ae,%rsi
  801af7:	00 00 00 
  801afa:	48 89 c7             	mov    %rax,%rdi
  801afd:	48 b8 4d 2c 80 00 00 	movabs $0x802c4d,%rax
  801b04:	00 00 00 
  801b07:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0d:	8b 50 04             	mov    0x4(%rax),%edx
  801b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b14:	8b 00                	mov    (%rax),%eax
  801b16:	29 c2                	sub    %eax,%edx
  801b18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b1c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801b22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b26:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b2d:	00 00 00 
	stat->st_dev = &devpipe;
  801b30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b34:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b3b:	00 00 00 
  801b3e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 10          	sub    $0x10,%rsp
  801b54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5c:	48 89 c6             	mov    %rax,%rsi
  801b5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b64:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b74:	48 89 c7             	mov    %rax,%rdi
  801b77:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	callq  *%rax
  801b83:	48 89 c6             	mov    %rax,%rsi
  801b86:	bf 00 00 00 00       	mov    $0x0,%edi
  801b8b:	48 b8 c5 03 80 00 00 	movabs $0x8003c5,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
}
  801b97:	c9                   	leaveq 
  801b98:	c3                   	retq   

0000000000801b99 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	48 83 ec 20          	sub    $0x20,%rsp
  801ba1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801ba4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ba7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801baa:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801bae:	be 01 00 00 00       	mov    $0x1,%esi
  801bb3:	48 89 c7             	mov    %rax,%rdi
  801bb6:	48 b8 d2 01 80 00 00 	movabs $0x8001d2,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
}
  801bc2:	c9                   	leaveq 
  801bc3:	c3                   	retq   

0000000000801bc4 <getchar>:

int
getchar(void)
{
  801bc4:	55                   	push   %rbp
  801bc5:	48 89 e5             	mov    %rsp,%rbp
  801bc8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bcc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801bd0:	ba 01 00 00 00       	mov    $0x1,%edx
  801bd5:	48 89 c6             	mov    %rax,%rsi
  801bd8:	bf 00 00 00 00       	mov    $0x0,%edi
  801bdd:	48 b8 9f 0a 80 00 00 	movabs $0x800a9f,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
  801be9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bf0:	79 05                	jns    801bf7 <getchar+0x33>
		return r;
  801bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf5:	eb 14                	jmp    801c0b <getchar+0x47>
	if (r < 1)
  801bf7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bfb:	7f 07                	jg     801c04 <getchar+0x40>
		return -E_EOF;
  801bfd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801c02:	eb 07                	jmp    801c0b <getchar+0x47>
	return c;
  801c04:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801c08:	0f b6 c0             	movzbl %al,%eax
}
  801c0b:	c9                   	leaveq 
  801c0c:	c3                   	retq   

0000000000801c0d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c0d:	55                   	push   %rbp
  801c0e:	48 89 e5             	mov    %rsp,%rbp
  801c11:	48 83 ec 20          	sub    $0x20,%rsp
  801c15:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c1f:	48 89 d6             	mov    %rdx,%rsi
  801c22:	89 c7                	mov    %eax,%edi
  801c24:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  801c2b:	00 00 00 
  801c2e:	ff d0                	callq  *%rax
  801c30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c37:	79 05                	jns    801c3e <iscons+0x31>
		return r;
  801c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3c:	eb 1a                	jmp    801c58 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c42:	8b 10                	mov    (%rax),%edx
  801c44:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c4b:	00 00 00 
  801c4e:	8b 00                	mov    (%rax),%eax
  801c50:	39 c2                	cmp    %eax,%edx
  801c52:	0f 94 c0             	sete   %al
  801c55:	0f b6 c0             	movzbl %al,%eax
}
  801c58:	c9                   	leaveq 
  801c59:	c3                   	retq   

0000000000801c5a <opencons>:

int
opencons(void)
{
  801c5a:	55                   	push   %rbp
  801c5b:	48 89 e5             	mov    %rsp,%rbp
  801c5e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c62:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c66:	48 89 c7             	mov    %rax,%rdi
  801c69:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  801c70:	00 00 00 
  801c73:	ff d0                	callq  *%rax
  801c75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c7c:	79 05                	jns    801c83 <opencons+0x29>
		return r;
  801c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c81:	eb 5b                	jmp    801cde <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c87:	ba 07 04 00 00       	mov    $0x407,%edx
  801c8c:	48 89 c6             	mov    %rax,%rsi
  801c8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c94:	48 b8 1a 03 80 00 00 	movabs $0x80031a,%rax
  801c9b:	00 00 00 
  801c9e:	ff d0                	callq  *%rax
  801ca0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ca3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ca7:	79 05                	jns    801cae <opencons+0x54>
		return r;
  801ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cac:	eb 30                	jmp    801cde <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb2:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801cb9:	00 00 00 
  801cbc:	8b 12                	mov    (%rdx),%edx
  801cbe:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccf:	48 89 c7             	mov    %rax,%rdi
  801cd2:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
}
  801cde:	c9                   	leaveq 
  801cdf:	c3                   	retq   

0000000000801ce0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 30          	sub    $0x30,%rsp
  801ce8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cf0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cf4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cf9:	75 07                	jne    801d02 <devcons_read+0x22>
		return 0;
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801d00:	eb 4b                	jmp    801d4d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801d02:	eb 0c                	jmp    801d10 <devcons_read+0x30>
		sys_yield();
  801d04:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  801d0b:	00 00 00 
  801d0e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d10:	48 b8 1c 02 80 00 00 	movabs $0x80021c,%rax
  801d17:	00 00 00 
  801d1a:	ff d0                	callq  *%rax
  801d1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d23:	74 df                	je     801d04 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801d25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d29:	79 05                	jns    801d30 <devcons_read+0x50>
		return c;
  801d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2e:	eb 1d                	jmp    801d4d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d30:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d34:	75 07                	jne    801d3d <devcons_read+0x5d>
		return 0;
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3b:	eb 10                	jmp    801d4d <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d40:	89 c2                	mov    %eax,%edx
  801d42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d46:	88 10                	mov    %dl,(%rax)
	return 1;
  801d48:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d4d:	c9                   	leaveq 
  801d4e:	c3                   	retq   

0000000000801d4f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d5a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d61:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d68:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d76:	eb 76                	jmp    801dee <devcons_write+0x9f>
		m = n - tot;
  801d78:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d7f:	89 c2                	mov    %eax,%edx
  801d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d84:	29 c2                	sub    %eax,%edx
  801d86:	89 d0                	mov    %edx,%eax
  801d88:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d8e:	83 f8 7f             	cmp    $0x7f,%eax
  801d91:	76 07                	jbe    801d9a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d93:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9d:	48 63 d0             	movslq %eax,%rdx
  801da0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da3:	48 63 c8             	movslq %eax,%rcx
  801da6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801dad:	48 01 c1             	add    %rax,%rcx
  801db0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801db7:	48 89 ce             	mov    %rcx,%rsi
  801dba:	48 89 c7             	mov    %rax,%rdi
  801dbd:	48 b8 71 2f 80 00 00 	movabs $0x802f71,%rax
  801dc4:	00 00 00 
  801dc7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801dc9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dcc:	48 63 d0             	movslq %eax,%rdx
  801dcf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801dd6:	48 89 d6             	mov    %rdx,%rsi
  801dd9:	48 89 c7             	mov    %rax,%rdi
  801ddc:	48 b8 d2 01 80 00 00 	movabs $0x8001d2,%rax
  801de3:	00 00 00 
  801de6:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801de8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801deb:	01 45 fc             	add    %eax,-0x4(%rbp)
  801dee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df1:	48 98                	cltq   
  801df3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dfa:	0f 82 78 ff ff ff    	jb     801d78 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801e00:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e03:	c9                   	leaveq 
  801e04:	c3                   	retq   

0000000000801e05 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801e05:	55                   	push   %rbp
  801e06:	48 89 e5             	mov    %rsp,%rbp
  801e09:	48 83 ec 08          	sub    $0x8,%rsp
  801e0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e16:	c9                   	leaveq 
  801e17:	c3                   	retq   

0000000000801e18 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e18:	55                   	push   %rbp
  801e19:	48 89 e5             	mov    %rsp,%rbp
  801e1c:	48 83 ec 10          	sub    $0x10,%rsp
  801e20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2c:	48 be ba 37 80 00 00 	movabs $0x8037ba,%rsi
  801e33:	00 00 00 
  801e36:	48 89 c7             	mov    %rax,%rdi
  801e39:	48 b8 4d 2c 80 00 00 	movabs $0x802c4d,%rax
  801e40:	00 00 00 
  801e43:	ff d0                	callq  *%rax
	return 0;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4a:	c9                   	leaveq 
  801e4b:	c3                   	retq   

0000000000801e4c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	53                   	push   %rbx
  801e51:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e58:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e5f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e65:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e6c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e73:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e7a:	84 c0                	test   %al,%al
  801e7c:	74 23                	je     801ea1 <_panic+0x55>
  801e7e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e85:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e89:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e8d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e91:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e95:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e99:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e9d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801ea1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801ea8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801eaf:	00 00 00 
  801eb2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801eb9:	00 00 00 
  801ebc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ec0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801ec7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801ece:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ed5:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801edc:	00 00 00 
  801edf:	48 8b 18             	mov    (%rax),%rbx
  801ee2:	48 b8 9e 02 80 00 00 	movabs $0x80029e,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	callq  *%rax
  801eee:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801ef4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801efb:	41 89 c8             	mov    %ecx,%r8d
  801efe:	48 89 d1             	mov    %rdx,%rcx
  801f01:	48 89 da             	mov    %rbx,%rdx
  801f04:	89 c6                	mov    %eax,%esi
  801f06:	48 bf c8 37 80 00 00 	movabs $0x8037c8,%rdi
  801f0d:	00 00 00 
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
  801f15:	49 b9 85 20 80 00 00 	movabs $0x802085,%r9
  801f1c:	00 00 00 
  801f1f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f22:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f29:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f30:	48 89 d6             	mov    %rdx,%rsi
  801f33:	48 89 c7             	mov    %rax,%rdi
  801f36:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  801f3d:	00 00 00 
  801f40:	ff d0                	callq  *%rax
	cprintf("\n");
  801f42:	48 bf eb 37 80 00 00 	movabs $0x8037eb,%rdi
  801f49:	00 00 00 
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f51:	48 ba 85 20 80 00 00 	movabs $0x802085,%rdx
  801f58:	00 00 00 
  801f5b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f5d:	cc                   	int3   
  801f5e:	eb fd                	jmp    801f5d <_panic+0x111>

0000000000801f60 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f60:	55                   	push   %rbp
  801f61:	48 89 e5             	mov    %rsp,%rbp
  801f64:	48 83 ec 10          	sub    $0x10,%rsp
  801f68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f73:	8b 00                	mov    (%rax),%eax
  801f75:	8d 48 01             	lea    0x1(%rax),%ecx
  801f78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7c:	89 0a                	mov    %ecx,(%rdx)
  801f7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f81:	89 d1                	mov    %edx,%ecx
  801f83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f87:	48 98                	cltq   
  801f89:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f91:	8b 00                	mov    (%rax),%eax
  801f93:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f98:	75 2c                	jne    801fc6 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9e:	8b 00                	mov    (%rax),%eax
  801fa0:	48 98                	cltq   
  801fa2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa6:	48 83 c2 08          	add    $0x8,%rdx
  801faa:	48 89 c6             	mov    %rax,%rsi
  801fad:	48 89 d7             	mov    %rdx,%rdi
  801fb0:	48 b8 d2 01 80 00 00 	movabs $0x8001d2,%rax
  801fb7:	00 00 00 
  801fba:	ff d0                	callq  *%rax
        b->idx = 0;
  801fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fca:	8b 40 04             	mov    0x4(%rax),%eax
  801fcd:	8d 50 01             	lea    0x1(%rax),%edx
  801fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd4:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fd7:	c9                   	leaveq 
  801fd8:	c3                   	retq   

0000000000801fd9 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fe4:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801feb:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801ff2:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801ff9:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802000:	48 8b 0a             	mov    (%rdx),%rcx
  802003:	48 89 08             	mov    %rcx,(%rax)
  802006:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80200a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80200e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802012:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802016:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80201d:	00 00 00 
    b.cnt = 0;
  802020:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802027:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80202a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802031:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802038:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80203f:	48 89 c6             	mov    %rax,%rsi
  802042:	48 bf 60 1f 80 00 00 	movabs $0x801f60,%rdi
  802049:	00 00 00 
  80204c:	48 b8 38 24 80 00 00 	movabs $0x802438,%rax
  802053:	00 00 00 
  802056:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802058:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80205e:	48 98                	cltq   
  802060:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802067:	48 83 c2 08          	add    $0x8,%rdx
  80206b:	48 89 c6             	mov    %rax,%rsi
  80206e:	48 89 d7             	mov    %rdx,%rdi
  802071:	48 b8 d2 01 80 00 00 	movabs $0x8001d2,%rax
  802078:	00 00 00 
  80207b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80207d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802083:	c9                   	leaveq 
  802084:	c3                   	retq   

0000000000802085 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802085:	55                   	push   %rbp
  802086:	48 89 e5             	mov    %rsp,%rbp
  802089:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802090:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802097:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80209e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8020a5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8020ac:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8020b3:	84 c0                	test   %al,%al
  8020b5:	74 20                	je     8020d7 <cprintf+0x52>
  8020b7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8020bb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8020bf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8020c3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8020c7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8020cb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020cf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020d3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020d7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020de:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020e5:	00 00 00 
  8020e8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020ef:	00 00 00 
  8020f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020fd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802104:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80210b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802112:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802119:	48 8b 0a             	mov    (%rdx),%rcx
  80211c:	48 89 08             	mov    %rcx,(%rax)
  80211f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802123:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802127:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80212b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80212f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802136:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80213d:	48 89 d6             	mov    %rdx,%rsi
  802140:	48 89 c7             	mov    %rax,%rdi
  802143:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax
  80214f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802155:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80215b:	c9                   	leaveq 
  80215c:	c3                   	retq   

000000000080215d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80215d:	55                   	push   %rbp
  80215e:	48 89 e5             	mov    %rsp,%rbp
  802161:	53                   	push   %rbx
  802162:	48 83 ec 38          	sub    $0x38,%rsp
  802166:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80216a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80216e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802172:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802175:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802179:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80217d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802180:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802184:	77 3b                	ja     8021c1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802186:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802189:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80218d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802190:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802194:	ba 00 00 00 00       	mov    $0x0,%edx
  802199:	48 f7 f3             	div    %rbx
  80219c:	48 89 c2             	mov    %rax,%rdx
  80219f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8021a2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021a5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8021a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ad:	41 89 f9             	mov    %edi,%r9d
  8021b0:	48 89 c7             	mov    %rax,%rdi
  8021b3:	48 b8 5d 21 80 00 00 	movabs $0x80215d,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax
  8021bf:	eb 1e                	jmp    8021df <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021c1:	eb 12                	jmp    8021d5 <printnum+0x78>
			putch(padc, putdat);
  8021c3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021c7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8021ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ce:	48 89 ce             	mov    %rcx,%rsi
  8021d1:	89 d7                	mov    %edx,%edi
  8021d3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021d5:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021d9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021dd:	7f e4                	jg     8021c3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021df:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021eb:	48 f7 f1             	div    %rcx
  8021ee:	48 89 d0             	mov    %rdx,%rax
  8021f1:	48 ba f0 39 80 00 00 	movabs $0x8039f0,%rdx
  8021f8:	00 00 00 
  8021fb:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021ff:	0f be d0             	movsbl %al,%edx
  802202:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220a:	48 89 ce             	mov    %rcx,%rsi
  80220d:	89 d7                	mov    %edx,%edi
  80220f:	ff d0                	callq  *%rax
}
  802211:	48 83 c4 38          	add    $0x38,%rsp
  802215:	5b                   	pop    %rbx
  802216:	5d                   	pop    %rbp
  802217:	c3                   	retq   

0000000000802218 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802218:	55                   	push   %rbp
  802219:	48 89 e5             	mov    %rsp,%rbp
  80221c:	48 83 ec 1c          	sub    $0x1c,%rsp
  802220:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802224:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  802227:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80222b:	7e 52                	jle    80227f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80222d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802231:	8b 00                	mov    (%rax),%eax
  802233:	83 f8 30             	cmp    $0x30,%eax
  802236:	73 24                	jae    80225c <getuint+0x44>
  802238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802244:	8b 00                	mov    (%rax),%eax
  802246:	89 c0                	mov    %eax,%eax
  802248:	48 01 d0             	add    %rdx,%rax
  80224b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80224f:	8b 12                	mov    (%rdx),%edx
  802251:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802254:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802258:	89 0a                	mov    %ecx,(%rdx)
  80225a:	eb 17                	jmp    802273 <getuint+0x5b>
  80225c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802260:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802264:	48 89 d0             	mov    %rdx,%rax
  802267:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80226b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80226f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802273:	48 8b 00             	mov    (%rax),%rax
  802276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80227a:	e9 a3 00 00 00       	jmpq   802322 <getuint+0x10a>
	else if (lflag)
  80227f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802283:	74 4f                	je     8022d4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802289:	8b 00                	mov    (%rax),%eax
  80228b:	83 f8 30             	cmp    $0x30,%eax
  80228e:	73 24                	jae    8022b4 <getuint+0x9c>
  802290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802294:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229c:	8b 00                	mov    (%rax),%eax
  80229e:	89 c0                	mov    %eax,%eax
  8022a0:	48 01 d0             	add    %rdx,%rax
  8022a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022a7:	8b 12                	mov    (%rdx),%edx
  8022a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022b0:	89 0a                	mov    %ecx,(%rdx)
  8022b2:	eb 17                	jmp    8022cb <getuint+0xb3>
  8022b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022bc:	48 89 d0             	mov    %rdx,%rax
  8022bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022cb:	48 8b 00             	mov    (%rax),%rax
  8022ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022d2:	eb 4e                	jmp    802322 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d8:	8b 00                	mov    (%rax),%eax
  8022da:	83 f8 30             	cmp    $0x30,%eax
  8022dd:	73 24                	jae    802303 <getuint+0xeb>
  8022df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022eb:	8b 00                	mov    (%rax),%eax
  8022ed:	89 c0                	mov    %eax,%eax
  8022ef:	48 01 d0             	add    %rdx,%rax
  8022f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022f6:	8b 12                	mov    (%rdx),%edx
  8022f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ff:	89 0a                	mov    %ecx,(%rdx)
  802301:	eb 17                	jmp    80231a <getuint+0x102>
  802303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802307:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80230b:	48 89 d0             	mov    %rdx,%rax
  80230e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802312:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802316:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80231a:	8b 00                	mov    (%rax),%eax
  80231c:	89 c0                	mov    %eax,%eax
  80231e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802326:	c9                   	leaveq 
  802327:	c3                   	retq   

0000000000802328 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802328:	55                   	push   %rbp
  802329:	48 89 e5             	mov    %rsp,%rbp
  80232c:	48 83 ec 1c          	sub    $0x1c,%rsp
  802330:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802334:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802337:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80233b:	7e 52                	jle    80238f <getint+0x67>
		x=va_arg(*ap, long long);
  80233d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802341:	8b 00                	mov    (%rax),%eax
  802343:	83 f8 30             	cmp    $0x30,%eax
  802346:	73 24                	jae    80236c <getint+0x44>
  802348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802354:	8b 00                	mov    (%rax),%eax
  802356:	89 c0                	mov    %eax,%eax
  802358:	48 01 d0             	add    %rdx,%rax
  80235b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80235f:	8b 12                	mov    (%rdx),%edx
  802361:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802364:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802368:	89 0a                	mov    %ecx,(%rdx)
  80236a:	eb 17                	jmp    802383 <getint+0x5b>
  80236c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802370:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802374:	48 89 d0             	mov    %rdx,%rax
  802377:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80237b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80237f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802383:	48 8b 00             	mov    (%rax),%rax
  802386:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80238a:	e9 a3 00 00 00       	jmpq   802432 <getint+0x10a>
	else if (lflag)
  80238f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802393:	74 4f                	je     8023e4 <getint+0xbc>
		x=va_arg(*ap, long);
  802395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802399:	8b 00                	mov    (%rax),%eax
  80239b:	83 f8 30             	cmp    $0x30,%eax
  80239e:	73 24                	jae    8023c4 <getint+0x9c>
  8023a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ac:	8b 00                	mov    (%rax),%eax
  8023ae:	89 c0                	mov    %eax,%eax
  8023b0:	48 01 d0             	add    %rdx,%rax
  8023b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023b7:	8b 12                	mov    (%rdx),%edx
  8023b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023c0:	89 0a                	mov    %ecx,(%rdx)
  8023c2:	eb 17                	jmp    8023db <getint+0xb3>
  8023c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023cc:	48 89 d0             	mov    %rdx,%rax
  8023cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023db:	48 8b 00             	mov    (%rax),%rax
  8023de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023e2:	eb 4e                	jmp    802432 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e8:	8b 00                	mov    (%rax),%eax
  8023ea:	83 f8 30             	cmp    $0x30,%eax
  8023ed:	73 24                	jae    802413 <getint+0xeb>
  8023ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fb:	8b 00                	mov    (%rax),%eax
  8023fd:	89 c0                	mov    %eax,%eax
  8023ff:	48 01 d0             	add    %rdx,%rax
  802402:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802406:	8b 12                	mov    (%rdx),%edx
  802408:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80240b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80240f:	89 0a                	mov    %ecx,(%rdx)
  802411:	eb 17                	jmp    80242a <getint+0x102>
  802413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802417:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80241b:	48 89 d0             	mov    %rdx,%rax
  80241e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802422:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802426:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80242a:	8b 00                	mov    (%rax),%eax
  80242c:	48 98                	cltq   
  80242e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802436:	c9                   	leaveq 
  802437:	c3                   	retq   

0000000000802438 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802438:	55                   	push   %rbp
  802439:	48 89 e5             	mov    %rsp,%rbp
  80243c:	41 54                	push   %r12
  80243e:	53                   	push   %rbx
  80243f:	48 83 ec 60          	sub    $0x60,%rsp
  802443:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802447:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80244b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80244f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802453:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802457:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80245b:	48 8b 0a             	mov    (%rdx),%rcx
  80245e:	48 89 08             	mov    %rcx,(%rax)
  802461:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802465:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802469:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80246d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802471:	eb 17                	jmp    80248a <vprintfmt+0x52>
			if (ch == '\0')
  802473:	85 db                	test   %ebx,%ebx
  802475:	0f 84 df 04 00 00    	je     80295a <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80247b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80247f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802483:	48 89 d6             	mov    %rdx,%rsi
  802486:	89 df                	mov    %ebx,%edi
  802488:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80248a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80248e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802492:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802496:	0f b6 00             	movzbl (%rax),%eax
  802499:	0f b6 d8             	movzbl %al,%ebx
  80249c:	83 fb 25             	cmp    $0x25,%ebx
  80249f:	75 d2                	jne    802473 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8024a1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8024a5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8024ac:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8024b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8024ba:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8024c1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024c9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024cd:	0f b6 00             	movzbl (%rax),%eax
  8024d0:	0f b6 d8             	movzbl %al,%ebx
  8024d3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024d6:	83 f8 55             	cmp    $0x55,%eax
  8024d9:	0f 87 47 04 00 00    	ja     802926 <vprintfmt+0x4ee>
  8024df:	89 c0                	mov    %eax,%eax
  8024e1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024e8:	00 
  8024e9:	48 b8 18 3a 80 00 00 	movabs $0x803a18,%rax
  8024f0:	00 00 00 
  8024f3:	48 01 d0             	add    %rdx,%rax
  8024f6:	48 8b 00             	mov    (%rax),%rax
  8024f9:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024fb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024ff:	eb c0                	jmp    8024c1 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802501:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802505:	eb ba                	jmp    8024c1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802507:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80250e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802511:	89 d0                	mov    %edx,%eax
  802513:	c1 e0 02             	shl    $0x2,%eax
  802516:	01 d0                	add    %edx,%eax
  802518:	01 c0                	add    %eax,%eax
  80251a:	01 d8                	add    %ebx,%eax
  80251c:	83 e8 30             	sub    $0x30,%eax
  80251f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802522:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802526:	0f b6 00             	movzbl (%rax),%eax
  802529:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80252c:	83 fb 2f             	cmp    $0x2f,%ebx
  80252f:	7e 0c                	jle    80253d <vprintfmt+0x105>
  802531:	83 fb 39             	cmp    $0x39,%ebx
  802534:	7f 07                	jg     80253d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802536:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80253b:	eb d1                	jmp    80250e <vprintfmt+0xd6>
			goto process_precision;
  80253d:	eb 58                	jmp    802597 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80253f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802542:	83 f8 30             	cmp    $0x30,%eax
  802545:	73 17                	jae    80255e <vprintfmt+0x126>
  802547:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80254b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80254e:	89 c0                	mov    %eax,%eax
  802550:	48 01 d0             	add    %rdx,%rax
  802553:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802556:	83 c2 08             	add    $0x8,%edx
  802559:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80255c:	eb 0f                	jmp    80256d <vprintfmt+0x135>
  80255e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802562:	48 89 d0             	mov    %rdx,%rax
  802565:	48 83 c2 08          	add    $0x8,%rdx
  802569:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80256d:	8b 00                	mov    (%rax),%eax
  80256f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802572:	eb 23                	jmp    802597 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802574:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802578:	79 0c                	jns    802586 <vprintfmt+0x14e>
				width = 0;
  80257a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802581:	e9 3b ff ff ff       	jmpq   8024c1 <vprintfmt+0x89>
  802586:	e9 36 ff ff ff       	jmpq   8024c1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80258b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802592:	e9 2a ff ff ff       	jmpq   8024c1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802597:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80259b:	79 12                	jns    8025af <vprintfmt+0x177>
				width = precision, precision = -1;
  80259d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8025a0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8025a3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8025aa:	e9 12 ff ff ff       	jmpq   8024c1 <vprintfmt+0x89>
  8025af:	e9 0d ff ff ff       	jmpq   8024c1 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8025b4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8025b8:	e9 04 ff ff ff       	jmpq   8024c1 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8025bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025c0:	83 f8 30             	cmp    $0x30,%eax
  8025c3:	73 17                	jae    8025dc <vprintfmt+0x1a4>
  8025c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025cc:	89 c0                	mov    %eax,%eax
  8025ce:	48 01 d0             	add    %rdx,%rax
  8025d1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025d4:	83 c2 08             	add    $0x8,%edx
  8025d7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025da:	eb 0f                	jmp    8025eb <vprintfmt+0x1b3>
  8025dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025e0:	48 89 d0             	mov    %rdx,%rax
  8025e3:	48 83 c2 08          	add    $0x8,%rdx
  8025e7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025eb:	8b 10                	mov    (%rax),%edx
  8025ed:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025f5:	48 89 ce             	mov    %rcx,%rsi
  8025f8:	89 d7                	mov    %edx,%edi
  8025fa:	ff d0                	callq  *%rax
			break;
  8025fc:	e9 53 03 00 00       	jmpq   802954 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802601:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802604:	83 f8 30             	cmp    $0x30,%eax
  802607:	73 17                	jae    802620 <vprintfmt+0x1e8>
  802609:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80260d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802610:	89 c0                	mov    %eax,%eax
  802612:	48 01 d0             	add    %rdx,%rax
  802615:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802618:	83 c2 08             	add    $0x8,%edx
  80261b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80261e:	eb 0f                	jmp    80262f <vprintfmt+0x1f7>
  802620:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802624:	48 89 d0             	mov    %rdx,%rax
  802627:	48 83 c2 08          	add    $0x8,%rdx
  80262b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80262f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802631:	85 db                	test   %ebx,%ebx
  802633:	79 02                	jns    802637 <vprintfmt+0x1ff>
				err = -err;
  802635:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802637:	83 fb 15             	cmp    $0x15,%ebx
  80263a:	7f 16                	jg     802652 <vprintfmt+0x21a>
  80263c:	48 b8 40 39 80 00 00 	movabs $0x803940,%rax
  802643:	00 00 00 
  802646:	48 63 d3             	movslq %ebx,%rdx
  802649:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80264d:	4d 85 e4             	test   %r12,%r12
  802650:	75 2e                	jne    802680 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802652:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802656:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80265a:	89 d9                	mov    %ebx,%ecx
  80265c:	48 ba 01 3a 80 00 00 	movabs $0x803a01,%rdx
  802663:	00 00 00 
  802666:	48 89 c7             	mov    %rax,%rdi
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	49 b8 63 29 80 00 00 	movabs $0x802963,%r8
  802675:	00 00 00 
  802678:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80267b:	e9 d4 02 00 00       	jmpq   802954 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802680:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802684:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802688:	4c 89 e1             	mov    %r12,%rcx
  80268b:	48 ba 0a 3a 80 00 00 	movabs $0x803a0a,%rdx
  802692:	00 00 00 
  802695:	48 89 c7             	mov    %rax,%rdi
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
  80269d:	49 b8 63 29 80 00 00 	movabs $0x802963,%r8
  8026a4:	00 00 00 
  8026a7:	41 ff d0             	callq  *%r8
			break;
  8026aa:	e9 a5 02 00 00       	jmpq   802954 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8026af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026b2:	83 f8 30             	cmp    $0x30,%eax
  8026b5:	73 17                	jae    8026ce <vprintfmt+0x296>
  8026b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026be:	89 c0                	mov    %eax,%eax
  8026c0:	48 01 d0             	add    %rdx,%rax
  8026c3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8026c6:	83 c2 08             	add    $0x8,%edx
  8026c9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8026cc:	eb 0f                	jmp    8026dd <vprintfmt+0x2a5>
  8026ce:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026d2:	48 89 d0             	mov    %rdx,%rax
  8026d5:	48 83 c2 08          	add    $0x8,%rdx
  8026d9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026dd:	4c 8b 20             	mov    (%rax),%r12
  8026e0:	4d 85 e4             	test   %r12,%r12
  8026e3:	75 0a                	jne    8026ef <vprintfmt+0x2b7>
				p = "(null)";
  8026e5:	49 bc 0d 3a 80 00 00 	movabs $0x803a0d,%r12
  8026ec:	00 00 00 
			if (width > 0 && padc != '-')
  8026ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026f3:	7e 3f                	jle    802734 <vprintfmt+0x2fc>
  8026f5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026f9:	74 39                	je     802734 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026fb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026fe:	48 98                	cltq   
  802700:	48 89 c6             	mov    %rax,%rsi
  802703:	4c 89 e7             	mov    %r12,%rdi
  802706:	48 b8 0f 2c 80 00 00 	movabs $0x802c0f,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
  802712:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802715:	eb 17                	jmp    80272e <vprintfmt+0x2f6>
					putch(padc, putdat);
  802717:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80271b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80271f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802723:	48 89 ce             	mov    %rcx,%rsi
  802726:	89 d7                	mov    %edx,%edi
  802728:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80272a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80272e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802732:	7f e3                	jg     802717 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802734:	eb 37                	jmp    80276d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802736:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80273a:	74 1e                	je     80275a <vprintfmt+0x322>
  80273c:	83 fb 1f             	cmp    $0x1f,%ebx
  80273f:	7e 05                	jle    802746 <vprintfmt+0x30e>
  802741:	83 fb 7e             	cmp    $0x7e,%ebx
  802744:	7e 14                	jle    80275a <vprintfmt+0x322>
					putch('?', putdat);
  802746:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80274a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80274e:	48 89 d6             	mov    %rdx,%rsi
  802751:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802756:	ff d0                	callq  *%rax
  802758:	eb 0f                	jmp    802769 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80275a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80275e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802762:	48 89 d6             	mov    %rdx,%rsi
  802765:	89 df                	mov    %ebx,%edi
  802767:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802769:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80276d:	4c 89 e0             	mov    %r12,%rax
  802770:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802774:	0f b6 00             	movzbl (%rax),%eax
  802777:	0f be d8             	movsbl %al,%ebx
  80277a:	85 db                	test   %ebx,%ebx
  80277c:	74 10                	je     80278e <vprintfmt+0x356>
  80277e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802782:	78 b2                	js     802736 <vprintfmt+0x2fe>
  802784:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802788:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80278c:	79 a8                	jns    802736 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80278e:	eb 16                	jmp    8027a6 <vprintfmt+0x36e>
				putch(' ', putdat);
  802790:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802794:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802798:	48 89 d6             	mov    %rdx,%rsi
  80279b:	bf 20 00 00 00       	mov    $0x20,%edi
  8027a0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027a2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8027a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8027aa:	7f e4                	jg     802790 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8027ac:	e9 a3 01 00 00       	jmpq   802954 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8027b1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027b5:	be 03 00 00 00       	mov    $0x3,%esi
  8027ba:	48 89 c7             	mov    %rax,%rdi
  8027bd:	48 b8 28 23 80 00 00 	movabs $0x802328,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8027cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d1:	48 85 c0             	test   %rax,%rax
  8027d4:	79 1d                	jns    8027f3 <vprintfmt+0x3bb>
				putch('-', putdat);
  8027d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027de:	48 89 d6             	mov    %rdx,%rsi
  8027e1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027e6:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ec:	48 f7 d8             	neg    %rax
  8027ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027f3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027fa:	e9 e8 00 00 00       	jmpq   8028e7 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027ff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802803:	be 03 00 00 00       	mov    $0x3,%esi
  802808:	48 89 c7             	mov    %rax,%rdi
  80280b:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  802812:	00 00 00 
  802815:	ff d0                	callq  *%rax
  802817:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80281b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802822:	e9 c0 00 00 00       	jmpq   8028e7 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802827:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80282b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80282f:	48 89 d6             	mov    %rdx,%rsi
  802832:	bf 58 00 00 00       	mov    $0x58,%edi
  802837:	ff d0                	callq  *%rax
			putch('X', putdat);
  802839:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80283d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802841:	48 89 d6             	mov    %rdx,%rsi
  802844:	bf 58 00 00 00       	mov    $0x58,%edi
  802849:	ff d0                	callq  *%rax
			putch('X', putdat);
  80284b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80284f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802853:	48 89 d6             	mov    %rdx,%rsi
  802856:	bf 58 00 00 00       	mov    $0x58,%edi
  80285b:	ff d0                	callq  *%rax
			break;
  80285d:	e9 f2 00 00 00       	jmpq   802954 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802862:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802866:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80286a:	48 89 d6             	mov    %rdx,%rsi
  80286d:	bf 30 00 00 00       	mov    $0x30,%edi
  802872:	ff d0                	callq  *%rax
			putch('x', putdat);
  802874:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802878:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80287c:	48 89 d6             	mov    %rdx,%rsi
  80287f:	bf 78 00 00 00       	mov    $0x78,%edi
  802884:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802886:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802889:	83 f8 30             	cmp    $0x30,%eax
  80288c:	73 17                	jae    8028a5 <vprintfmt+0x46d>
  80288e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802892:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802895:	89 c0                	mov    %eax,%eax
  802897:	48 01 d0             	add    %rdx,%rax
  80289a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80289d:	83 c2 08             	add    $0x8,%edx
  8028a0:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8028a3:	eb 0f                	jmp    8028b4 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  8028a5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8028a9:	48 89 d0             	mov    %rdx,%rax
  8028ac:	48 83 c2 08          	add    $0x8,%rdx
  8028b0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8028b4:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8028b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8028bb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8028c2:	eb 23                	jmp    8028e7 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8028c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028c8:	be 03 00 00 00       	mov    $0x3,%esi
  8028cd:	48 89 c7             	mov    %rax,%rdi
  8028d0:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	callq  *%rax
  8028dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028e0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028e7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028ec:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028ef:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028f6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028fe:	45 89 c1             	mov    %r8d,%r9d
  802901:	41 89 f8             	mov    %edi,%r8d
  802904:	48 89 c7             	mov    %rax,%rdi
  802907:	48 b8 5d 21 80 00 00 	movabs $0x80215d,%rax
  80290e:	00 00 00 
  802911:	ff d0                	callq  *%rax
			break;
  802913:	eb 3f                	jmp    802954 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802915:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802919:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80291d:	48 89 d6             	mov    %rdx,%rsi
  802920:	89 df                	mov    %ebx,%edi
  802922:	ff d0                	callq  *%rax
			break;
  802924:	eb 2e                	jmp    802954 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802926:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80292a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80292e:	48 89 d6             	mov    %rdx,%rsi
  802931:	bf 25 00 00 00       	mov    $0x25,%edi
  802936:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802938:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80293d:	eb 05                	jmp    802944 <vprintfmt+0x50c>
  80293f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802944:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802948:	48 83 e8 01          	sub    $0x1,%rax
  80294c:	0f b6 00             	movzbl (%rax),%eax
  80294f:	3c 25                	cmp    $0x25,%al
  802951:	75 ec                	jne    80293f <vprintfmt+0x507>
				/* do nothing */;
			break;
  802953:	90                   	nop
		}
	}
  802954:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802955:	e9 30 fb ff ff       	jmpq   80248a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80295a:	48 83 c4 60          	add    $0x60,%rsp
  80295e:	5b                   	pop    %rbx
  80295f:	41 5c                	pop    %r12
  802961:	5d                   	pop    %rbp
  802962:	c3                   	retq   

0000000000802963 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802963:	55                   	push   %rbp
  802964:	48 89 e5             	mov    %rsp,%rbp
  802967:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80296e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802975:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80297c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802983:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80298a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802991:	84 c0                	test   %al,%al
  802993:	74 20                	je     8029b5 <printfmt+0x52>
  802995:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802999:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80299d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8029a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8029a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8029a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8029ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8029b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8029b5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8029bc:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8029c3:	00 00 00 
  8029c6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8029cd:	00 00 00 
  8029d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029d4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029e2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029e9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029f0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029f7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029fe:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802a05:	48 89 c7             	mov    %rax,%rdi
  802a08:	48 b8 38 24 80 00 00 	movabs $0x802438,%rax
  802a0f:	00 00 00 
  802a12:	ff d0                	callq  *%rax
	va_end(ap);
}
  802a14:	c9                   	leaveq 
  802a15:	c3                   	retq   

0000000000802a16 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802a16:	55                   	push   %rbp
  802a17:	48 89 e5             	mov    %rsp,%rbp
  802a1a:	48 83 ec 10          	sub    $0x10,%rsp
  802a1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a29:	8b 40 10             	mov    0x10(%rax),%eax
  802a2c:	8d 50 01             	lea    0x1(%rax),%edx
  802a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a33:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3a:	48 8b 10             	mov    (%rax),%rdx
  802a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a41:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a45:	48 39 c2             	cmp    %rax,%rdx
  802a48:	73 17                	jae    802a61 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4e:	48 8b 00             	mov    (%rax),%rax
  802a51:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a59:	48 89 0a             	mov    %rcx,(%rdx)
  802a5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a5f:	88 10                	mov    %dl,(%rax)
}
  802a61:	c9                   	leaveq 
  802a62:	c3                   	retq   

0000000000802a63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a63:	55                   	push   %rbp
  802a64:	48 89 e5             	mov    %rsp,%rbp
  802a67:	48 83 ec 50          	sub    $0x50,%rsp
  802a6b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a6f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a72:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a76:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a7a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a7e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a82:	48 8b 0a             	mov    (%rdx),%rcx
  802a85:	48 89 08             	mov    %rcx,(%rax)
  802a88:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a8c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a90:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a94:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a9c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802aa0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802aa3:	48 98                	cltq   
  802aa5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802aa9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802aad:	48 01 d0             	add    %rdx,%rax
  802ab0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802ab4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802abb:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802ac0:	74 06                	je     802ac8 <vsnprintf+0x65>
  802ac2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802ac6:	7f 07                	jg     802acf <vsnprintf+0x6c>
		return -E_INVAL;
  802ac8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802acd:	eb 2f                	jmp    802afe <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802acf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802ad3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802ad7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802adb:	48 89 c6             	mov    %rax,%rsi
  802ade:	48 bf 16 2a 80 00 00 	movabs $0x802a16,%rdi
  802ae5:	00 00 00 
  802ae8:	48 b8 38 24 80 00 00 	movabs $0x802438,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802af4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802af8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802afb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802afe:	c9                   	leaveq 
  802aff:	c3                   	retq   

0000000000802b00 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802b00:	55                   	push   %rbp
  802b01:	48 89 e5             	mov    %rsp,%rbp
  802b04:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802b0b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802b12:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802b18:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802b1f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b26:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b2d:	84 c0                	test   %al,%al
  802b2f:	74 20                	je     802b51 <snprintf+0x51>
  802b31:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b35:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b39:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b3d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b41:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b45:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b49:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b4d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b51:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b58:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b5f:	00 00 00 
  802b62:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b69:	00 00 00 
  802b6c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b70:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b77:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b7e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b85:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b8c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b93:	48 8b 0a             	mov    (%rdx),%rcx
  802b96:	48 89 08             	mov    %rcx,(%rax)
  802b99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802ba1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802ba5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802ba9:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802bb0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802bb7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802bbd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802bc4:	48 89 c7             	mov    %rax,%rdi
  802bc7:	48 b8 63 2a 80 00 00 	movabs $0x802a63,%rax
  802bce:	00 00 00 
  802bd1:	ff d0                	callq  *%rax
  802bd3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802bd9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bdf:	c9                   	leaveq 
  802be0:	c3                   	retq   

0000000000802be1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802be1:	55                   	push   %rbp
  802be2:	48 89 e5             	mov    %rsp,%rbp
  802be5:	48 83 ec 18          	sub    $0x18,%rsp
  802be9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bf4:	eb 09                	jmp    802bff <strlen+0x1e>
		n++;
  802bf6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bfa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c03:	0f b6 00             	movzbl (%rax),%eax
  802c06:	84 c0                	test   %al,%al
  802c08:	75 ec                	jne    802bf6 <strlen+0x15>
		n++;
	return n;
  802c0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c0d:	c9                   	leaveq 
  802c0e:	c3                   	retq   

0000000000802c0f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802c0f:	55                   	push   %rbp
  802c10:	48 89 e5             	mov    %rsp,%rbp
  802c13:	48 83 ec 20          	sub    $0x20,%rsp
  802c17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c26:	eb 0e                	jmp    802c36 <strnlen+0x27>
		n++;
  802c28:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c2c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c31:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c36:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c3b:	74 0b                	je     802c48 <strnlen+0x39>
  802c3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c41:	0f b6 00             	movzbl (%rax),%eax
  802c44:	84 c0                	test   %al,%al
  802c46:	75 e0                	jne    802c28 <strnlen+0x19>
		n++;
	return n;
  802c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c4b:	c9                   	leaveq 
  802c4c:	c3                   	retq   

0000000000802c4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c4d:	55                   	push   %rbp
  802c4e:	48 89 e5             	mov    %rsp,%rbp
  802c51:	48 83 ec 20          	sub    $0x20,%rsp
  802c55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c65:	90                   	nop
  802c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c6e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c72:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c76:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c7a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c7e:	0f b6 12             	movzbl (%rdx),%edx
  802c81:	88 10                	mov    %dl,(%rax)
  802c83:	0f b6 00             	movzbl (%rax),%eax
  802c86:	84 c0                	test   %al,%al
  802c88:	75 dc                	jne    802c66 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c8e:	c9                   	leaveq 
  802c8f:	c3                   	retq   

0000000000802c90 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c90:	55                   	push   %rbp
  802c91:	48 89 e5             	mov    %rsp,%rbp
  802c94:	48 83 ec 20          	sub    $0x20,%rsp
  802c98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802ca0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca4:	48 89 c7             	mov    %rax,%rdi
  802ca7:	48 b8 e1 2b 80 00 00 	movabs $0x802be1,%rax
  802cae:	00 00 00 
  802cb1:	ff d0                	callq  *%rax
  802cb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802cb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb9:	48 63 d0             	movslq %eax,%rdx
  802cbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc0:	48 01 c2             	add    %rax,%rdx
  802cc3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc7:	48 89 c6             	mov    %rax,%rsi
  802cca:	48 89 d7             	mov    %rdx,%rdi
  802ccd:	48 b8 4d 2c 80 00 00 	movabs $0x802c4d,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
	return dst;
  802cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802cdd:	c9                   	leaveq 
  802cde:	c3                   	retq   

0000000000802cdf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802cdf:	55                   	push   %rbp
  802ce0:	48 89 e5             	mov    %rsp,%rbp
  802ce3:	48 83 ec 28          	sub    $0x28,%rsp
  802ce7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ceb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802cfb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d02:	00 
  802d03:	eb 2a                	jmp    802d2f <strncpy+0x50>
		*dst++ = *src;
  802d05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d09:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d0d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d11:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d15:	0f b6 12             	movzbl (%rdx),%edx
  802d18:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802d1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d1e:	0f b6 00             	movzbl (%rax),%eax
  802d21:	84 c0                	test   %al,%al
  802d23:	74 05                	je     802d2a <strncpy+0x4b>
			src++;
  802d25:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d2a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d33:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d37:	72 cc                	jb     802d05 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d3d:	c9                   	leaveq 
  802d3e:	c3                   	retq   

0000000000802d3f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d3f:	55                   	push   %rbp
  802d40:	48 89 e5             	mov    %rsp,%rbp
  802d43:	48 83 ec 28          	sub    $0x28,%rsp
  802d47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d4f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d57:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d5b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d60:	74 3d                	je     802d9f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d62:	eb 1d                	jmp    802d81 <strlcpy+0x42>
			*dst++ = *src++;
  802d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d68:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d6c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d70:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d74:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d78:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d7c:	0f b6 12             	movzbl (%rdx),%edx
  802d7f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d81:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d86:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d8b:	74 0b                	je     802d98 <strlcpy+0x59>
  802d8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d91:	0f b6 00             	movzbl (%rax),%eax
  802d94:	84 c0                	test   %al,%al
  802d96:	75 cc                	jne    802d64 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da7:	48 29 c2             	sub    %rax,%rdx
  802daa:	48 89 d0             	mov    %rdx,%rax
}
  802dad:	c9                   	leaveq 
  802dae:	c3                   	retq   

0000000000802daf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802daf:	55                   	push   %rbp
  802db0:	48 89 e5             	mov    %rsp,%rbp
  802db3:	48 83 ec 10          	sub    $0x10,%rsp
  802db7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802dbf:	eb 0a                	jmp    802dcb <strcmp+0x1c>
		p++, q++;
  802dc1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dc6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802dcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dcf:	0f b6 00             	movzbl (%rax),%eax
  802dd2:	84 c0                	test   %al,%al
  802dd4:	74 12                	je     802de8 <strcmp+0x39>
  802dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dda:	0f b6 10             	movzbl (%rax),%edx
  802ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de1:	0f b6 00             	movzbl (%rax),%eax
  802de4:	38 c2                	cmp    %al,%dl
  802de6:	74 d9                	je     802dc1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dec:	0f b6 00             	movzbl (%rax),%eax
  802def:	0f b6 d0             	movzbl %al,%edx
  802df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df6:	0f b6 00             	movzbl (%rax),%eax
  802df9:	0f b6 c0             	movzbl %al,%eax
  802dfc:	29 c2                	sub    %eax,%edx
  802dfe:	89 d0                	mov    %edx,%eax
}
  802e00:	c9                   	leaveq 
  802e01:	c3                   	retq   

0000000000802e02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802e02:	55                   	push   %rbp
  802e03:	48 89 e5             	mov    %rsp,%rbp
  802e06:	48 83 ec 18          	sub    $0x18,%rsp
  802e0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e12:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802e16:	eb 0f                	jmp    802e27 <strncmp+0x25>
		n--, p++, q++;
  802e18:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802e1d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e22:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e27:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e2c:	74 1d                	je     802e4b <strncmp+0x49>
  802e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e32:	0f b6 00             	movzbl (%rax),%eax
  802e35:	84 c0                	test   %al,%al
  802e37:	74 12                	je     802e4b <strncmp+0x49>
  802e39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3d:	0f b6 10             	movzbl (%rax),%edx
  802e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e44:	0f b6 00             	movzbl (%rax),%eax
  802e47:	38 c2                	cmp    %al,%dl
  802e49:	74 cd                	je     802e18 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e4b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e50:	75 07                	jne    802e59 <strncmp+0x57>
		return 0;
  802e52:	b8 00 00 00 00       	mov    $0x0,%eax
  802e57:	eb 18                	jmp    802e71 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e5d:	0f b6 00             	movzbl (%rax),%eax
  802e60:	0f b6 d0             	movzbl %al,%edx
  802e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e67:	0f b6 00             	movzbl (%rax),%eax
  802e6a:	0f b6 c0             	movzbl %al,%eax
  802e6d:	29 c2                	sub    %eax,%edx
  802e6f:	89 d0                	mov    %edx,%eax
}
  802e71:	c9                   	leaveq 
  802e72:	c3                   	retq   

0000000000802e73 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 0c          	sub    $0xc,%rsp
  802e7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e7f:	89 f0                	mov    %esi,%eax
  802e81:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e84:	eb 17                	jmp    802e9d <strchr+0x2a>
		if (*s == c)
  802e86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8a:	0f b6 00             	movzbl (%rax),%eax
  802e8d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e90:	75 06                	jne    802e98 <strchr+0x25>
			return (char *) s;
  802e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e96:	eb 15                	jmp    802ead <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e98:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea1:	0f b6 00             	movzbl (%rax),%eax
  802ea4:	84 c0                	test   %al,%al
  802ea6:	75 de                	jne    802e86 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ead:	c9                   	leaveq 
  802eae:	c3                   	retq   

0000000000802eaf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802eaf:	55                   	push   %rbp
  802eb0:	48 89 e5             	mov    %rsp,%rbp
  802eb3:	48 83 ec 0c          	sub    $0xc,%rsp
  802eb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ebb:	89 f0                	mov    %esi,%eax
  802ebd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802ec0:	eb 13                	jmp    802ed5 <strfind+0x26>
		if (*s == c)
  802ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec6:	0f b6 00             	movzbl (%rax),%eax
  802ec9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802ecc:	75 02                	jne    802ed0 <strfind+0x21>
			break;
  802ece:	eb 10                	jmp    802ee0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802ed0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ed5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed9:	0f b6 00             	movzbl (%rax),%eax
  802edc:	84 c0                	test   %al,%al
  802ede:	75 e2                	jne    802ec2 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ee4:	c9                   	leaveq 
  802ee5:	c3                   	retq   

0000000000802ee6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802ee6:	55                   	push   %rbp
  802ee7:	48 89 e5             	mov    %rsp,%rbp
  802eea:	48 83 ec 18          	sub    $0x18,%rsp
  802eee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ef2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ef5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ef9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802efe:	75 06                	jne    802f06 <memset+0x20>
		return v;
  802f00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f04:	eb 69                	jmp    802f6f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0a:	83 e0 03             	and    $0x3,%eax
  802f0d:	48 85 c0             	test   %rax,%rax
  802f10:	75 48                	jne    802f5a <memset+0x74>
  802f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f16:	83 e0 03             	and    $0x3,%eax
  802f19:	48 85 c0             	test   %rax,%rax
  802f1c:	75 3c                	jne    802f5a <memset+0x74>
		c &= 0xFF;
  802f1e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802f25:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f28:	c1 e0 18             	shl    $0x18,%eax
  802f2b:	89 c2                	mov    %eax,%edx
  802f2d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f30:	c1 e0 10             	shl    $0x10,%eax
  802f33:	09 c2                	or     %eax,%edx
  802f35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f38:	c1 e0 08             	shl    $0x8,%eax
  802f3b:	09 d0                	or     %edx,%eax
  802f3d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f44:	48 c1 e8 02          	shr    $0x2,%rax
  802f48:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f4b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f52:	48 89 d7             	mov    %rdx,%rdi
  802f55:	fc                   	cld    
  802f56:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f58:	eb 11                	jmp    802f6b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f5a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f5e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f65:	48 89 d7             	mov    %rdx,%rdi
  802f68:	fc                   	cld    
  802f69:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f6f:	c9                   	leaveq 
  802f70:	c3                   	retq   

0000000000802f71 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f71:	55                   	push   %rbp
  802f72:	48 89 e5             	mov    %rsp,%rbp
  802f75:	48 83 ec 28          	sub    $0x28,%rsp
  802f79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f81:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f89:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f91:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f99:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f9d:	0f 83 88 00 00 00    	jae    80302b <memmove+0xba>
  802fa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fab:	48 01 d0             	add    %rdx,%rax
  802fae:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802fb2:	76 77                	jbe    80302b <memmove+0xba>
		s += n;
  802fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc8:	83 e0 03             	and    $0x3,%eax
  802fcb:	48 85 c0             	test   %rax,%rax
  802fce:	75 3b                	jne    80300b <memmove+0x9a>
  802fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd4:	83 e0 03             	and    $0x3,%eax
  802fd7:	48 85 c0             	test   %rax,%rax
  802fda:	75 2f                	jne    80300b <memmove+0x9a>
  802fdc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe0:	83 e0 03             	and    $0x3,%eax
  802fe3:	48 85 c0             	test   %rax,%rax
  802fe6:	75 23                	jne    80300b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fec:	48 83 e8 04          	sub    $0x4,%rax
  802ff0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ff4:	48 83 ea 04          	sub    $0x4,%rdx
  802ff8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802ffc:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803000:	48 89 c7             	mov    %rax,%rdi
  803003:	48 89 d6             	mov    %rdx,%rsi
  803006:	fd                   	std    
  803007:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803009:	eb 1d                	jmp    803028 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80300b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803017:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80301b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80301f:	48 89 d7             	mov    %rdx,%rdi
  803022:	48 89 c1             	mov    %rax,%rcx
  803025:	fd                   	std    
  803026:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803028:	fc                   	cld    
  803029:	eb 57                	jmp    803082 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80302b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80302f:	83 e0 03             	and    $0x3,%eax
  803032:	48 85 c0             	test   %rax,%rax
  803035:	75 36                	jne    80306d <memmove+0xfc>
  803037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303b:	83 e0 03             	and    $0x3,%eax
  80303e:	48 85 c0             	test   %rax,%rax
  803041:	75 2a                	jne    80306d <memmove+0xfc>
  803043:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803047:	83 e0 03             	and    $0x3,%eax
  80304a:	48 85 c0             	test   %rax,%rax
  80304d:	75 1e                	jne    80306d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80304f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803053:	48 c1 e8 02          	shr    $0x2,%rax
  803057:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80305a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803062:	48 89 c7             	mov    %rax,%rdi
  803065:	48 89 d6             	mov    %rdx,%rsi
  803068:	fc                   	cld    
  803069:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80306b:	eb 15                	jmp    803082 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80306d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803071:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803075:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803079:	48 89 c7             	mov    %rax,%rdi
  80307c:	48 89 d6             	mov    %rdx,%rsi
  80307f:	fc                   	cld    
  803080:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803086:	c9                   	leaveq 
  803087:	c3                   	retq   

0000000000803088 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803088:	55                   	push   %rbp
  803089:	48 89 e5             	mov    %rsp,%rbp
  80308c:	48 83 ec 18          	sub    $0x18,%rsp
  803090:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803094:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803098:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80309c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030a0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a8:	48 89 ce             	mov    %rcx,%rsi
  8030ab:	48 89 c7             	mov    %rax,%rdi
  8030ae:	48 b8 71 2f 80 00 00 	movabs $0x802f71,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	callq  *%rax
}
  8030ba:	c9                   	leaveq 
  8030bb:	c3                   	retq   

00000000008030bc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8030bc:	55                   	push   %rbp
  8030bd:	48 89 e5             	mov    %rsp,%rbp
  8030c0:	48 83 ec 28          	sub    $0x28,%rsp
  8030c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8030d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030e0:	eb 36                	jmp    803118 <memcmp+0x5c>
		if (*s1 != *s2)
  8030e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e6:	0f b6 10             	movzbl (%rax),%edx
  8030e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ed:	0f b6 00             	movzbl (%rax),%eax
  8030f0:	38 c2                	cmp    %al,%dl
  8030f2:	74 1a                	je     80310e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f8:	0f b6 00             	movzbl (%rax),%eax
  8030fb:	0f b6 d0             	movzbl %al,%edx
  8030fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803102:	0f b6 00             	movzbl (%rax),%eax
  803105:	0f b6 c0             	movzbl %al,%eax
  803108:	29 c2                	sub    %eax,%edx
  80310a:	89 d0                	mov    %edx,%eax
  80310c:	eb 20                	jmp    80312e <memcmp+0x72>
		s1++, s2++;
  80310e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803113:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803118:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803120:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803124:	48 85 c0             	test   %rax,%rax
  803127:	75 b9                	jne    8030e2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803129:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80312e:	c9                   	leaveq 
  80312f:	c3                   	retq   

0000000000803130 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803130:	55                   	push   %rbp
  803131:	48 89 e5             	mov    %rsp,%rbp
  803134:	48 83 ec 28          	sub    $0x28,%rsp
  803138:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80313c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80313f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803147:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80314b:	48 01 d0             	add    %rdx,%rax
  80314e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803152:	eb 15                	jmp    803169 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803158:	0f b6 10             	movzbl (%rax),%edx
  80315b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80315e:	38 c2                	cmp    %al,%dl
  803160:	75 02                	jne    803164 <memfind+0x34>
			break;
  803162:	eb 0f                	jmp    803173 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803164:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80316d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803171:	72 e1                	jb     803154 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803177:	c9                   	leaveq 
  803178:	c3                   	retq   

0000000000803179 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803179:	55                   	push   %rbp
  80317a:	48 89 e5             	mov    %rsp,%rbp
  80317d:	48 83 ec 34          	sub    $0x34,%rsp
  803181:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803185:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803189:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80318c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803193:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80319a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80319b:	eb 05                	jmp    8031a2 <strtol+0x29>
		s++;
  80319d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8031a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a6:	0f b6 00             	movzbl (%rax),%eax
  8031a9:	3c 20                	cmp    $0x20,%al
  8031ab:	74 f0                	je     80319d <strtol+0x24>
  8031ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b1:	0f b6 00             	movzbl (%rax),%eax
  8031b4:	3c 09                	cmp    $0x9,%al
  8031b6:	74 e5                	je     80319d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8031b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031bc:	0f b6 00             	movzbl (%rax),%eax
  8031bf:	3c 2b                	cmp    $0x2b,%al
  8031c1:	75 07                	jne    8031ca <strtol+0x51>
		s++;
  8031c3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031c8:	eb 17                	jmp    8031e1 <strtol+0x68>
	else if (*s == '-')
  8031ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ce:	0f b6 00             	movzbl (%rax),%eax
  8031d1:	3c 2d                	cmp    $0x2d,%al
  8031d3:	75 0c                	jne    8031e1 <strtol+0x68>
		s++, neg = 1;
  8031d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031e5:	74 06                	je     8031ed <strtol+0x74>
  8031e7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031eb:	75 28                	jne    803215 <strtol+0x9c>
  8031ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f1:	0f b6 00             	movzbl (%rax),%eax
  8031f4:	3c 30                	cmp    $0x30,%al
  8031f6:	75 1d                	jne    803215 <strtol+0x9c>
  8031f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fc:	48 83 c0 01          	add    $0x1,%rax
  803200:	0f b6 00             	movzbl (%rax),%eax
  803203:	3c 78                	cmp    $0x78,%al
  803205:	75 0e                	jne    803215 <strtol+0x9c>
		s += 2, base = 16;
  803207:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80320c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803213:	eb 2c                	jmp    803241 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803215:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803219:	75 19                	jne    803234 <strtol+0xbb>
  80321b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321f:	0f b6 00             	movzbl (%rax),%eax
  803222:	3c 30                	cmp    $0x30,%al
  803224:	75 0e                	jne    803234 <strtol+0xbb>
		s++, base = 8;
  803226:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80322b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803232:	eb 0d                	jmp    803241 <strtol+0xc8>
	else if (base == 0)
  803234:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803238:	75 07                	jne    803241 <strtol+0xc8>
		base = 10;
  80323a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803245:	0f b6 00             	movzbl (%rax),%eax
  803248:	3c 2f                	cmp    $0x2f,%al
  80324a:	7e 1d                	jle    803269 <strtol+0xf0>
  80324c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803250:	0f b6 00             	movzbl (%rax),%eax
  803253:	3c 39                	cmp    $0x39,%al
  803255:	7f 12                	jg     803269 <strtol+0xf0>
			dig = *s - '0';
  803257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325b:	0f b6 00             	movzbl (%rax),%eax
  80325e:	0f be c0             	movsbl %al,%eax
  803261:	83 e8 30             	sub    $0x30,%eax
  803264:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803267:	eb 4e                	jmp    8032b7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326d:	0f b6 00             	movzbl (%rax),%eax
  803270:	3c 60                	cmp    $0x60,%al
  803272:	7e 1d                	jle    803291 <strtol+0x118>
  803274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803278:	0f b6 00             	movzbl (%rax),%eax
  80327b:	3c 7a                	cmp    $0x7a,%al
  80327d:	7f 12                	jg     803291 <strtol+0x118>
			dig = *s - 'a' + 10;
  80327f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803283:	0f b6 00             	movzbl (%rax),%eax
  803286:	0f be c0             	movsbl %al,%eax
  803289:	83 e8 57             	sub    $0x57,%eax
  80328c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80328f:	eb 26                	jmp    8032b7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803291:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803295:	0f b6 00             	movzbl (%rax),%eax
  803298:	3c 40                	cmp    $0x40,%al
  80329a:	7e 48                	jle    8032e4 <strtol+0x16b>
  80329c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a0:	0f b6 00             	movzbl (%rax),%eax
  8032a3:	3c 5a                	cmp    $0x5a,%al
  8032a5:	7f 3d                	jg     8032e4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8032a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ab:	0f b6 00             	movzbl (%rax),%eax
  8032ae:	0f be c0             	movsbl %al,%eax
  8032b1:	83 e8 37             	sub    $0x37,%eax
  8032b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8032b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ba:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8032bd:	7c 02                	jl     8032c1 <strtol+0x148>
			break;
  8032bf:	eb 23                	jmp    8032e4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8032c1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8032c6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032c9:	48 98                	cltq   
  8032cb:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8032d0:	48 89 c2             	mov    %rax,%rdx
  8032d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032d6:	48 98                	cltq   
  8032d8:	48 01 d0             	add    %rdx,%rax
  8032db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032df:	e9 5d ff ff ff       	jmpq   803241 <strtol+0xc8>

	if (endptr)
  8032e4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032e9:	74 0b                	je     8032f6 <strtol+0x17d>
		*endptr = (char *) s;
  8032eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032f3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fa:	74 09                	je     803305 <strtol+0x18c>
  8032fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803300:	48 f7 d8             	neg    %rax
  803303:	eb 04                	jmp    803309 <strtol+0x190>
  803305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803309:	c9                   	leaveq 
  80330a:	c3                   	retq   

000000000080330b <strstr>:

char * strstr(const char *in, const char *str)
{
  80330b:	55                   	push   %rbp
  80330c:	48 89 e5             	mov    %rsp,%rbp
  80330f:	48 83 ec 30          	sub    $0x30,%rsp
  803313:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803317:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80331b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803323:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803327:	0f b6 00             	movzbl (%rax),%eax
  80332a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80332d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803331:	75 06                	jne    803339 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803337:	eb 6b                	jmp    8033a4 <strstr+0x99>

	len = strlen(str);
  803339:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333d:	48 89 c7             	mov    %rax,%rdi
  803340:	48 b8 e1 2b 80 00 00 	movabs $0x802be1,%rax
  803347:	00 00 00 
  80334a:	ff d0                	callq  *%rax
  80334c:	48 98                	cltq   
  80334e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803352:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803356:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80335a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80335e:	0f b6 00             	movzbl (%rax),%eax
  803361:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803364:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803368:	75 07                	jne    803371 <strstr+0x66>
				return (char *) 0;
  80336a:	b8 00 00 00 00       	mov    $0x0,%eax
  80336f:	eb 33                	jmp    8033a4 <strstr+0x99>
		} while (sc != c);
  803371:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803375:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803378:	75 d8                	jne    803352 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80337a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80337e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803386:	48 89 ce             	mov    %rcx,%rsi
  803389:	48 89 c7             	mov    %rax,%rdi
  80338c:	48 b8 02 2e 80 00 00 	movabs $0x802e02,%rax
  803393:	00 00 00 
  803396:	ff d0                	callq  *%rax
  803398:	85 c0                	test   %eax,%eax
  80339a:	75 b6                	jne    803352 <strstr+0x47>

	return (char *) (in - 1);
  80339c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a0:	48 83 e8 01          	sub    $0x1,%rax
}
  8033a4:	c9                   	leaveq 
  8033a5:	c3                   	retq   

00000000008033a6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033a6:	55                   	push   %rbp
  8033a7:	48 89 e5             	mov    %rsp,%rbp
  8033aa:	48 83 ec 30          	sub    $0x30,%rsp
  8033ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8033ba:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033bf:	75 0e                	jne    8033cf <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033c1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033c8:	00 00 00 
  8033cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d3:	48 89 c7             	mov    %rax,%rdi
  8033d6:	48 b8 43 05 80 00 00 	movabs $0x800543,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
  8033e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e9:	79 27                	jns    803412 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033f0:	74 0a                	je     8033fc <ipc_recv+0x56>
            *from_env_store = 0;
  8033f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033fc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803401:	74 0a                	je     80340d <ipc_recv+0x67>
            *perm_store = 0;
  803403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803407:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80340d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803410:	eb 53                	jmp    803465 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803412:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803417:	74 19                	je     803432 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803419:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803420:	00 00 00 
  803423:	48 8b 00             	mov    (%rax),%rax
  803426:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80342c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803430:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803432:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803437:	74 19                	je     803452 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803439:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803440:	00 00 00 
  803443:	48 8b 00             	mov    (%rax),%rax
  803446:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80344c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803450:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803452:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803459:	00 00 00 
  80345c:	48 8b 00             	mov    (%rax),%rax
  80345f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803465:	c9                   	leaveq 
  803466:	c3                   	retq   

0000000000803467 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803467:	55                   	push   %rbp
  803468:	48 89 e5             	mov    %rsp,%rbp
  80346b:	48 83 ec 30          	sub    $0x30,%rsp
  80346f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803472:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803475:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803479:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80347c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803481:	75 0e                	jne    803491 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803483:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80348a:	00 00 00 
  80348d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803491:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803494:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803497:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80349b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349e:	89 c7                	mov    %eax,%edi
  8034a0:	48 b8 ee 04 80 00 00 	movabs $0x8004ee,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8034af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b3:	79 36                	jns    8034eb <ipc_send+0x84>
  8034b5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034b9:	74 30                	je     8034eb <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8034bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034be:	89 c1                	mov    %eax,%ecx
  8034c0:	48 ba c8 3c 80 00 00 	movabs $0x803cc8,%rdx
  8034c7:	00 00 00 
  8034ca:	be 49 00 00 00       	mov    $0x49,%esi
  8034cf:	48 bf d5 3c 80 00 00 	movabs $0x803cd5,%rdi
  8034d6:	00 00 00 
  8034d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034de:	49 b8 4c 1e 80 00 00 	movabs $0x801e4c,%r8
  8034e5:	00 00 00 
  8034e8:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034eb:	48 b8 dc 02 80 00 00 	movabs $0x8002dc,%rax
  8034f2:	00 00 00 
  8034f5:	ff d0                	callq  *%rax
    } while(r != 0);
  8034f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034fb:	75 94                	jne    803491 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034fd:	c9                   	leaveq 
  8034fe:	c3                   	retq   

00000000008034ff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034ff:	55                   	push   %rbp
  803500:	48 89 e5             	mov    %rsp,%rbp
  803503:	48 83 ec 14          	sub    $0x14,%rsp
  803507:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80350a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803511:	eb 5e                	jmp    803571 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803513:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80351a:	00 00 00 
  80351d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803520:	48 63 d0             	movslq %eax,%rdx
  803523:	48 89 d0             	mov    %rdx,%rax
  803526:	48 c1 e0 03          	shl    $0x3,%rax
  80352a:	48 01 d0             	add    %rdx,%rax
  80352d:	48 c1 e0 05          	shl    $0x5,%rax
  803531:	48 01 c8             	add    %rcx,%rax
  803534:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80353a:	8b 00                	mov    (%rax),%eax
  80353c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80353f:	75 2c                	jne    80356d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803541:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803548:	00 00 00 
  80354b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354e:	48 63 d0             	movslq %eax,%rdx
  803551:	48 89 d0             	mov    %rdx,%rax
  803554:	48 c1 e0 03          	shl    $0x3,%rax
  803558:	48 01 d0             	add    %rdx,%rax
  80355b:	48 c1 e0 05          	shl    $0x5,%rax
  80355f:	48 01 c8             	add    %rcx,%rax
  803562:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803568:	8b 40 08             	mov    0x8(%rax),%eax
  80356b:	eb 12                	jmp    80357f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80356d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803571:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803578:	7e 99                	jle    803513 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80357a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80357f:	c9                   	leaveq 
  803580:	c3                   	retq   

0000000000803581 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803581:	55                   	push   %rbp
  803582:	48 89 e5             	mov    %rsp,%rbp
  803585:	48 83 ec 18          	sub    $0x18,%rsp
  803589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80358d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803591:	48 c1 e8 15          	shr    $0x15,%rax
  803595:	48 89 c2             	mov    %rax,%rdx
  803598:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80359f:	01 00 00 
  8035a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035a6:	83 e0 01             	and    $0x1,%eax
  8035a9:	48 85 c0             	test   %rax,%rax
  8035ac:	75 07                	jne    8035b5 <pageref+0x34>
		return 0;
  8035ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b3:	eb 53                	jmp    803608 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8035b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8035bd:	48 89 c2             	mov    %rax,%rdx
  8035c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035c7:	01 00 00 
  8035ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d6:	83 e0 01             	and    $0x1,%eax
  8035d9:	48 85 c0             	test   %rax,%rax
  8035dc:	75 07                	jne    8035e5 <pageref+0x64>
		return 0;
  8035de:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e3:	eb 23                	jmp    803608 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e9:	48 c1 e8 0c          	shr    $0xc,%rax
  8035ed:	48 89 c2             	mov    %rax,%rdx
  8035f0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035f7:	00 00 00 
  8035fa:	48 c1 e2 04          	shl    $0x4,%rdx
  8035fe:	48 01 d0             	add    %rdx,%rax
  803601:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803605:	0f b7 c0             	movzwl %ax,%eax
}
  803608:	c9                   	leaveq 
  803609:	c3                   	retq   
