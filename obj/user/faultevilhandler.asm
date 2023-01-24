
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
  800061:	48 b8 0e 03 80 00 00 	movabs $0x80030e,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  80006d:	be 20 00 10 f0       	mov    $0xf0100020,%esi
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 4e 04 80 00 00 	movabs $0x80044e,%rax
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
	envid_t id = sys_getenvid();
  80009f:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
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
  8000d4:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000db:	00 00 00 
  8000de:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000e5:	7e 14                	jle    8000fb <libmain+0x6b>
		binaryname = argv[0];
  8000e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000eb:	48 8b 10             	mov    (%rax),%rdx
  8000ee:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  800125:	bf 00 00 00 00       	mov    $0x0,%edi
  80012a:	48 b8 4e 02 80 00 00 	movabs $0x80024e,%rax
  800131:	00 00 00 
  800134:	ff d0                	callq  *%rax
}
  800136:	5d                   	pop    %rbp
  800137:	c3                   	retq   

0000000000800138 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800138:	55                   	push   %rbp
  800139:	48 89 e5             	mov    %rsp,%rbp
  80013c:	53                   	push   %rbx
  80013d:	48 83 ec 48          	sub    $0x48,%rsp
  800141:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800144:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800147:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80014b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80014f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800153:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800157:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80015a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80015e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800162:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800166:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80016a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80016e:	4c 89 c3             	mov    %r8,%rbx
  800171:	cd 30                	int    $0x30
  800173:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800177:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80017b:	74 3e                	je     8001bb <syscall+0x83>
  80017d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800182:	7e 37                	jle    8001bb <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800184:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800188:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80018b:	49 89 d0             	mov    %rdx,%r8
  80018e:	89 c1                	mov    %eax,%ecx
  800190:	48 ba aa 1a 80 00 00 	movabs $0x801aaa,%rdx
  800197:	00 00 00 
  80019a:	be 23 00 00 00       	mov    $0x23,%esi
  80019f:	48 bf c7 1a 80 00 00 	movabs $0x801ac7,%rdi
  8001a6:	00 00 00 
  8001a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ae:	49 b9 31 05 80 00 00 	movabs $0x800531,%r9
  8001b5:	00 00 00 
  8001b8:	41 ff d1             	callq  *%r9

	return ret;
  8001bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001bf:	48 83 c4 48          	add    $0x48,%rsp
  8001c3:	5b                   	pop    %rbx
  8001c4:	5d                   	pop    %rbp
  8001c5:	c3                   	retq   

00000000008001c6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001c6:	55                   	push   %rbp
  8001c7:	48 89 e5             	mov    %rsp,%rbp
  8001ca:	48 83 ec 20          	sub    $0x20,%rsp
  8001ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001e5:	00 
  8001e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f2:	48 89 d1             	mov    %rdx,%rcx
  8001f5:	48 89 c2             	mov    %rax,%rdx
  8001f8:	be 00 00 00 00       	mov    $0x0,%esi
  8001fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800202:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  800209:	00 00 00 
  80020c:	ff d0                	callq  *%rax
}
  80020e:	c9                   	leaveq 
  80020f:	c3                   	retq   

0000000000800210 <sys_cgetc>:

int
sys_cgetc(void)
{
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
  800214:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800218:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80021f:	00 
  800220:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800226:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80022c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800231:	ba 00 00 00 00       	mov    $0x0,%edx
  800236:	be 00 00 00 00       	mov    $0x0,%esi
  80023b:	bf 01 00 00 00       	mov    $0x1,%edi
  800240:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax
}
  80024c:	c9                   	leaveq 
  80024d:	c3                   	retq   

000000000080024e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80024e:	55                   	push   %rbp
  80024f:	48 89 e5             	mov    %rsp,%rbp
  800252:	48 83 ec 10          	sub    $0x10,%rsp
  800256:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025c:	48 98                	cltq   
  80025e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800265:	00 
  800266:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80026c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800272:	b9 00 00 00 00       	mov    $0x0,%ecx
  800277:	48 89 c2             	mov    %rax,%rdx
  80027a:	be 01 00 00 00       	mov    $0x1,%esi
  80027f:	bf 03 00 00 00       	mov    $0x3,%edi
  800284:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  80028b:	00 00 00 
  80028e:	ff d0                	callq  *%rax
}
  800290:	c9                   	leaveq 
  800291:	c3                   	retq   

0000000000800292 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800292:	55                   	push   %rbp
  800293:	48 89 e5             	mov    %rsp,%rbp
  800296:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80029a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002a1:	00 
  8002a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b8:	be 00 00 00 00       	mov    $0x0,%esi
  8002bd:	bf 02 00 00 00       	mov    $0x2,%edi
  8002c2:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  8002c9:	00 00 00 
  8002cc:	ff d0                	callq  *%rax
}
  8002ce:	c9                   	leaveq 
  8002cf:	c3                   	retq   

00000000008002d0 <sys_yield>:

void
sys_yield(void)
{
  8002d0:	55                   	push   %rbp
  8002d1:	48 89 e5             	mov    %rsp,%rbp
  8002d4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002d8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002df:	00 
  8002e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f6:	be 00 00 00 00       	mov    $0x0,%esi
  8002fb:	bf 0a 00 00 00       	mov    $0xa,%edi
  800300:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  800307:	00 00 00 
  80030a:	ff d0                	callq  *%rax
}
  80030c:	c9                   	leaveq 
  80030d:	c3                   	retq   

000000000080030e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80030e:	55                   	push   %rbp
  80030f:	48 89 e5             	mov    %rsp,%rbp
  800312:	48 83 ec 20          	sub    $0x20,%rsp
  800316:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800319:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80031d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800320:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800323:	48 63 c8             	movslq %eax,%rcx
  800326:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80032a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032d:	48 98                	cltq   
  80032f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800336:	00 
  800337:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80033d:	49 89 c8             	mov    %rcx,%r8
  800340:	48 89 d1             	mov    %rdx,%rcx
  800343:	48 89 c2             	mov    %rax,%rdx
  800346:	be 01 00 00 00       	mov    $0x1,%esi
  80034b:	bf 04 00 00 00       	mov    $0x4,%edi
  800350:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  800357:	00 00 00 
  80035a:	ff d0                	callq  *%rax
}
  80035c:	c9                   	leaveq 
  80035d:	c3                   	retq   

000000000080035e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80035e:	55                   	push   %rbp
  80035f:	48 89 e5             	mov    %rsp,%rbp
  800362:	48 83 ec 30          	sub    $0x30,%rsp
  800366:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800369:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80036d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800370:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800374:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800378:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80037b:	48 63 c8             	movslq %eax,%rcx
  80037e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800382:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800385:	48 63 f0             	movslq %eax,%rsi
  800388:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80038f:	48 98                	cltq   
  800391:	48 89 0c 24          	mov    %rcx,(%rsp)
  800395:	49 89 f9             	mov    %rdi,%r9
  800398:	49 89 f0             	mov    %rsi,%r8
  80039b:	48 89 d1             	mov    %rdx,%rcx
  80039e:	48 89 c2             	mov    %rax,%rdx
  8003a1:	be 01 00 00 00       	mov    $0x1,%esi
  8003a6:	bf 05 00 00 00       	mov    $0x5,%edi
  8003ab:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  8003b2:	00 00 00 
  8003b5:	ff d0                	callq  *%rax
}
  8003b7:	c9                   	leaveq 
  8003b8:	c3                   	retq   

00000000008003b9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003b9:	55                   	push   %rbp
  8003ba:	48 89 e5             	mov    %rsp,%rbp
  8003bd:	48 83 ec 20          	sub    $0x20,%rsp
  8003c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003cf:	48 98                	cltq   
  8003d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003d8:	00 
  8003d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003e5:	48 89 d1             	mov    %rdx,%rcx
  8003e8:	48 89 c2             	mov    %rax,%rdx
  8003eb:	be 01 00 00 00       	mov    $0x1,%esi
  8003f0:	bf 06 00 00 00       	mov    $0x6,%edi
  8003f5:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  8003fc:	00 00 00 
  8003ff:	ff d0                	callq  *%rax
}
  800401:	c9                   	leaveq 
  800402:	c3                   	retq   

0000000000800403 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	48 83 ec 10          	sub    $0x10,%rsp
  80040b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800411:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800414:	48 63 d0             	movslq %eax,%rdx
  800417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80041a:	48 98                	cltq   
  80041c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800423:	00 
  800424:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80042a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800430:	48 89 d1             	mov    %rdx,%rcx
  800433:	48 89 c2             	mov    %rax,%rdx
  800436:	be 01 00 00 00       	mov    $0x1,%esi
  80043b:	bf 08 00 00 00       	mov    $0x8,%edi
  800440:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  800447:	00 00 00 
  80044a:	ff d0                	callq  *%rax
}
  80044c:	c9                   	leaveq 
  80044d:	c3                   	retq   

000000000080044e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80044e:	55                   	push   %rbp
  80044f:	48 89 e5             	mov    %rsp,%rbp
  800452:	48 83 ec 20          	sub    $0x20,%rsp
  800456:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800459:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80045d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800461:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800464:	48 98                	cltq   
  800466:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80046d:	00 
  80046e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800474:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80047a:	48 89 d1             	mov    %rdx,%rcx
  80047d:	48 89 c2             	mov    %rax,%rdx
  800480:	be 01 00 00 00       	mov    $0x1,%esi
  800485:	bf 09 00 00 00       	mov    $0x9,%edi
  80048a:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  800491:	00 00 00 
  800494:	ff d0                	callq  *%rax
}
  800496:	c9                   	leaveq 
  800497:	c3                   	retq   

0000000000800498 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800498:	55                   	push   %rbp
  800499:	48 89 e5             	mov    %rsp,%rbp
  80049c:	48 83 ec 20          	sub    $0x20,%rsp
  8004a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004ab:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004b1:	48 63 f0             	movslq %eax,%rsi
  8004b4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bb:	48 98                	cltq   
  8004bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c8:	00 
  8004c9:	49 89 f1             	mov    %rsi,%r9
  8004cc:	49 89 c8             	mov    %rcx,%r8
  8004cf:	48 89 d1             	mov    %rdx,%rcx
  8004d2:	48 89 c2             	mov    %rax,%rdx
  8004d5:	be 00 00 00 00       	mov    $0x0,%esi
  8004da:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004df:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  8004e6:	00 00 00 
  8004e9:	ff d0                	callq  *%rax
}
  8004eb:	c9                   	leaveq 
  8004ec:	c3                   	retq   

00000000008004ed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 83 ec 10          	sub    $0x10,%rsp
  8004f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800504:	00 
  800505:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80050b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800511:	b9 00 00 00 00       	mov    $0x0,%ecx
  800516:	48 89 c2             	mov    %rax,%rdx
  800519:	be 01 00 00 00       	mov    $0x1,%esi
  80051e:	bf 0c 00 00 00       	mov    $0xc,%edi
  800523:	48 b8 38 01 80 00 00 	movabs $0x800138,%rax
  80052a:	00 00 00 
  80052d:	ff d0                	callq  *%rax
}
  80052f:	c9                   	leaveq 
  800530:	c3                   	retq   

0000000000800531 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800531:	55                   	push   %rbp
  800532:	48 89 e5             	mov    %rsp,%rbp
  800535:	53                   	push   %rbx
  800536:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80053d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800544:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80054a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800551:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800558:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80055f:	84 c0                	test   %al,%al
  800561:	74 23                	je     800586 <_panic+0x55>
  800563:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80056a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80056e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800572:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800576:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80057a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80057e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800582:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800586:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80058d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800594:	00 00 00 
  800597:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80059e:	00 00 00 
  8005a1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8005ac:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005b3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005ba:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005c1:	00 00 00 
  8005c4:	48 8b 18             	mov    (%rax),%rbx
  8005c7:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005d9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005e0:	41 89 c8             	mov    %ecx,%r8d
  8005e3:	48 89 d1             	mov    %rdx,%rcx
  8005e6:	48 89 da             	mov    %rbx,%rdx
  8005e9:	89 c6                	mov    %eax,%esi
  8005eb:	48 bf d8 1a 80 00 00 	movabs $0x801ad8,%rdi
  8005f2:	00 00 00 
  8005f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fa:	49 b9 6a 07 80 00 00 	movabs $0x80076a,%r9
  800601:	00 00 00 
  800604:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800607:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80060e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800615:	48 89 d6             	mov    %rdx,%rsi
  800618:	48 89 c7             	mov    %rax,%rdi
  80061b:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  800622:	00 00 00 
  800625:	ff d0                	callq  *%rax
	cprintf("\n");
  800627:	48 bf fb 1a 80 00 00 	movabs $0x801afb,%rdi
  80062e:	00 00 00 
  800631:	b8 00 00 00 00       	mov    $0x0,%eax
  800636:	48 ba 6a 07 80 00 00 	movabs $0x80076a,%rdx
  80063d:	00 00 00 
  800640:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800642:	cc                   	int3   
  800643:	eb fd                	jmp    800642 <_panic+0x111>

0000000000800645 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800645:	55                   	push   %rbp
  800646:	48 89 e5             	mov    %rsp,%rbp
  800649:	48 83 ec 10          	sub    $0x10,%rsp
  80064d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800650:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800658:	8b 00                	mov    (%rax),%eax
  80065a:	8d 48 01             	lea    0x1(%rax),%ecx
  80065d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800661:	89 0a                	mov    %ecx,(%rdx)
  800663:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800666:	89 d1                	mov    %edx,%ecx
  800668:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066c:	48 98                	cltq   
  80066e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800676:	8b 00                	mov    (%rax),%eax
  800678:	3d ff 00 00 00       	cmp    $0xff,%eax
  80067d:	75 2c                	jne    8006ab <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80067f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	48 98                	cltq   
  800687:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80068b:	48 83 c2 08          	add    $0x8,%rdx
  80068f:	48 89 c6             	mov    %rax,%rsi
  800692:	48 89 d7             	mov    %rdx,%rdi
  800695:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  80069c:	00 00 00 
  80069f:	ff d0                	callq  *%rax
        b->idx = 0;
  8006a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8006ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006af:	8b 40 04             	mov    0x4(%rax),%eax
  8006b2:	8d 50 01             	lea    0x1(%rax),%edx
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006bc:	c9                   	leaveq 
  8006bd:	c3                   	retq   

00000000008006be <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006be:	55                   	push   %rbp
  8006bf:	48 89 e5             	mov    %rsp,%rbp
  8006c2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006c9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006d0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006d7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006de:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006e5:	48 8b 0a             	mov    (%rdx),%rcx
  8006e8:	48 89 08             	mov    %rcx,(%rax)
  8006eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800702:	00 00 00 
    b.cnt = 0;
  800705:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80070c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80070f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800716:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80071d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800724:	48 89 c6             	mov    %rax,%rsi
  800727:	48 bf 45 06 80 00 00 	movabs $0x800645,%rdi
  80072e:	00 00 00 
  800731:	48 b8 1d 0b 80 00 00 	movabs $0x800b1d,%rax
  800738:	00 00 00 
  80073b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80073d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800743:	48 98                	cltq   
  800745:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80074c:	48 83 c2 08          	add    $0x8,%rdx
  800750:	48 89 c6             	mov    %rax,%rsi
  800753:	48 89 d7             	mov    %rdx,%rdi
  800756:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  80075d:	00 00 00 
  800760:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800762:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800768:	c9                   	leaveq 
  800769:	c3                   	retq   

000000000080076a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80076a:	55                   	push   %rbp
  80076b:	48 89 e5             	mov    %rsp,%rbp
  80076e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800775:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80077c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800783:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80078a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800791:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800798:	84 c0                	test   %al,%al
  80079a:	74 20                	je     8007bc <cprintf+0x52>
  80079c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8007a0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8007a4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007a8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007ac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007b0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007b4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007b8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007bc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007c3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007ca:	00 00 00 
  8007cd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007d4:	00 00 00 
  8007d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007db:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007e2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007e9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007f0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007f7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007fe:	48 8b 0a             	mov    (%rdx),%rcx
  800801:	48 89 08             	mov    %rcx,(%rax)
  800804:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800808:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80080c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800810:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800814:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80081b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800822:	48 89 d6             	mov    %rdx,%rsi
  800825:	48 89 c7             	mov    %rax,%rdi
  800828:	48 b8 be 06 80 00 00 	movabs $0x8006be,%rax
  80082f:	00 00 00 
  800832:	ff d0                	callq  *%rax
  800834:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80083a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800840:	c9                   	leaveq 
  800841:	c3                   	retq   

0000000000800842 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800842:	55                   	push   %rbp
  800843:	48 89 e5             	mov    %rsp,%rbp
  800846:	53                   	push   %rbx
  800847:	48 83 ec 38          	sub    $0x38,%rsp
  80084b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80084f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800853:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800857:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80085a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80085e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800862:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800865:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800869:	77 3b                	ja     8008a6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80086b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80086e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800872:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800879:	ba 00 00 00 00       	mov    $0x0,%edx
  80087e:	48 f7 f3             	div    %rbx
  800881:	48 89 c2             	mov    %rax,%rdx
  800884:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800887:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80088a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80088e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800892:	41 89 f9             	mov    %edi,%r9d
  800895:	48 89 c7             	mov    %rax,%rdi
  800898:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  80089f:	00 00 00 
  8008a2:	ff d0                	callq  *%rax
  8008a4:	eb 1e                	jmp    8008c4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a6:	eb 12                	jmp    8008ba <printnum+0x78>
			putch(padc, putdat);
  8008a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008ac:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	48 89 ce             	mov    %rcx,%rsi
  8008b6:	89 d7                	mov    %edx,%edi
  8008b8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ba:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008be:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008c2:	7f e4                	jg     8008a8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008c4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d0:	48 f7 f1             	div    %rcx
  8008d3:	48 89 d0             	mov    %rdx,%rax
  8008d6:	48 ba 50 1c 80 00 00 	movabs $0x801c50,%rdx
  8008dd:	00 00 00 
  8008e0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008e4:	0f be d0             	movsbl %al,%edx
  8008e7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ef:	48 89 ce             	mov    %rcx,%rsi
  8008f2:	89 d7                	mov    %edx,%edi
  8008f4:	ff d0                	callq  *%rax
}
  8008f6:	48 83 c4 38          	add    $0x38,%rsp
  8008fa:	5b                   	pop    %rbx
  8008fb:	5d                   	pop    %rbp
  8008fc:	c3                   	retq   

00000000008008fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008fd:	55                   	push   %rbp
  8008fe:	48 89 e5             	mov    %rsp,%rbp
  800901:	48 83 ec 1c          	sub    $0x1c,%rsp
  800905:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800909:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80090c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800910:	7e 52                	jle    800964 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800916:	8b 00                	mov    (%rax),%eax
  800918:	83 f8 30             	cmp    $0x30,%eax
  80091b:	73 24                	jae    800941 <getuint+0x44>
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	89 c0                	mov    %eax,%eax
  80092d:	48 01 d0             	add    %rdx,%rax
  800930:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800934:	8b 12                	mov    (%rdx),%edx
  800936:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093d:	89 0a                	mov    %ecx,(%rdx)
  80093f:	eb 17                	jmp    800958 <getuint+0x5b>
  800941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800945:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800949:	48 89 d0             	mov    %rdx,%rax
  80094c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800958:	48 8b 00             	mov    (%rax),%rax
  80095b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80095f:	e9 a3 00 00 00       	jmpq   800a07 <getuint+0x10a>
	else if (lflag)
  800964:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800968:	74 4f                	je     8009b9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80096a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096e:	8b 00                	mov    (%rax),%eax
  800970:	83 f8 30             	cmp    $0x30,%eax
  800973:	73 24                	jae    800999 <getuint+0x9c>
  800975:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800979:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80097d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800981:	8b 00                	mov    (%rax),%eax
  800983:	89 c0                	mov    %eax,%eax
  800985:	48 01 d0             	add    %rdx,%rax
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	8b 12                	mov    (%rdx),%edx
  80098e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800991:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800995:	89 0a                	mov    %ecx,(%rdx)
  800997:	eb 17                	jmp    8009b0 <getuint+0xb3>
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009a1:	48 89 d0             	mov    %rdx,%rax
  8009a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b0:	48 8b 00             	mov    (%rax),%rax
  8009b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009b7:	eb 4e                	jmp    800a07 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	8b 00                	mov    (%rax),%eax
  8009bf:	83 f8 30             	cmp    $0x30,%eax
  8009c2:	73 24                	jae    8009e8 <getuint+0xeb>
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d0:	8b 00                	mov    (%rax),%eax
  8009d2:	89 c0                	mov    %eax,%eax
  8009d4:	48 01 d0             	add    %rdx,%rax
  8009d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009db:	8b 12                	mov    (%rdx),%edx
  8009dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e4:	89 0a                	mov    %ecx,(%rdx)
  8009e6:	eb 17                	jmp    8009ff <getuint+0x102>
  8009e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009f0:	48 89 d0             	mov    %rdx,%rax
  8009f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ff:	8b 00                	mov    (%rax),%eax
  800a01:	89 c0                	mov    %eax,%eax
  800a03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a0b:	c9                   	leaveq 
  800a0c:	c3                   	retq   

0000000000800a0d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a0d:	55                   	push   %rbp
  800a0e:	48 89 e5             	mov    %rsp,%rbp
  800a11:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a19:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a1c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a20:	7e 52                	jle    800a74 <getint+0x67>
		x=va_arg(*ap, long long);
  800a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a26:	8b 00                	mov    (%rax),%eax
  800a28:	83 f8 30             	cmp    $0x30,%eax
  800a2b:	73 24                	jae    800a51 <getint+0x44>
  800a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a31:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a39:	8b 00                	mov    (%rax),%eax
  800a3b:	89 c0                	mov    %eax,%eax
  800a3d:	48 01 d0             	add    %rdx,%rax
  800a40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a44:	8b 12                	mov    (%rdx),%edx
  800a46:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4d:	89 0a                	mov    %ecx,(%rdx)
  800a4f:	eb 17                	jmp    800a68 <getint+0x5b>
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a59:	48 89 d0             	mov    %rdx,%rax
  800a5c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a68:	48 8b 00             	mov    (%rax),%rax
  800a6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a6f:	e9 a3 00 00 00       	jmpq   800b17 <getint+0x10a>
	else if (lflag)
  800a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a78:	74 4f                	je     800ac9 <getint+0xbc>
		x=va_arg(*ap, long);
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	8b 00                	mov    (%rax),%eax
  800a80:	83 f8 30             	cmp    $0x30,%eax
  800a83:	73 24                	jae    800aa9 <getint+0x9c>
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a91:	8b 00                	mov    (%rax),%eax
  800a93:	89 c0                	mov    %eax,%eax
  800a95:	48 01 d0             	add    %rdx,%rax
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	8b 12                	mov    (%rdx),%edx
  800a9e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa5:	89 0a                	mov    %ecx,(%rdx)
  800aa7:	eb 17                	jmp    800ac0 <getint+0xb3>
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ab1:	48 89 d0             	mov    %rdx,%rax
  800ab4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ac0:	48 8b 00             	mov    (%rax),%rax
  800ac3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ac7:	eb 4e                	jmp    800b17 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acd:	8b 00                	mov    (%rax),%eax
  800acf:	83 f8 30             	cmp    $0x30,%eax
  800ad2:	73 24                	jae    800af8 <getint+0xeb>
  800ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae0:	8b 00                	mov    (%rax),%eax
  800ae2:	89 c0                	mov    %eax,%eax
  800ae4:	48 01 d0             	add    %rdx,%rax
  800ae7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aeb:	8b 12                	mov    (%rdx),%edx
  800aed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800af0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af4:	89 0a                	mov    %ecx,(%rdx)
  800af6:	eb 17                	jmp    800b0f <getint+0x102>
  800af8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b00:	48 89 d0             	mov    %rdx,%rax
  800b03:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b0f:	8b 00                	mov    (%rax),%eax
  800b11:	48 98                	cltq   
  800b13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b1b:	c9                   	leaveq 
  800b1c:	c3                   	retq   

0000000000800b1d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b1d:	55                   	push   %rbp
  800b1e:	48 89 e5             	mov    %rsp,%rbp
  800b21:	41 54                	push   %r12
  800b23:	53                   	push   %rbx
  800b24:	48 83 ec 60          	sub    $0x60,%rsp
  800b28:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b2c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b30:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b34:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b38:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b3c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b40:	48 8b 0a             	mov    (%rdx),%rcx
  800b43:	48 89 08             	mov    %rcx,(%rax)
  800b46:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b4a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b4e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b52:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b56:	eb 17                	jmp    800b6f <vprintfmt+0x52>
			if (ch == '\0')
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	0f 84 df 04 00 00    	je     80103f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800b60:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b68:	48 89 d6             	mov    %rdx,%rsi
  800b6b:	89 df                	mov    %ebx,%edi
  800b6d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b73:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b77:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b7b:	0f b6 00             	movzbl (%rax),%eax
  800b7e:	0f b6 d8             	movzbl %al,%ebx
  800b81:	83 fb 25             	cmp    $0x25,%ebx
  800b84:	75 d2                	jne    800b58 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b86:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b8a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b91:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b98:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b9f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800baa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bae:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bb2:	0f b6 00             	movzbl (%rax),%eax
  800bb5:	0f b6 d8             	movzbl %al,%ebx
  800bb8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bbb:	83 f8 55             	cmp    $0x55,%eax
  800bbe:	0f 87 47 04 00 00    	ja     80100b <vprintfmt+0x4ee>
  800bc4:	89 c0                	mov    %eax,%eax
  800bc6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bcd:	00 
  800bce:	48 b8 78 1c 80 00 00 	movabs $0x801c78,%rax
  800bd5:	00 00 00 
  800bd8:	48 01 d0             	add    %rdx,%rax
  800bdb:	48 8b 00             	mov    (%rax),%rax
  800bde:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800be0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800be4:	eb c0                	jmp    800ba6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800be6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bea:	eb ba                	jmp    800ba6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bf3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bf6:	89 d0                	mov    %edx,%eax
  800bf8:	c1 e0 02             	shl    $0x2,%eax
  800bfb:	01 d0                	add    %edx,%eax
  800bfd:	01 c0                	add    %eax,%eax
  800bff:	01 d8                	add    %ebx,%eax
  800c01:	83 e8 30             	sub    $0x30,%eax
  800c04:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c0b:	0f b6 00             	movzbl (%rax),%eax
  800c0e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c11:	83 fb 2f             	cmp    $0x2f,%ebx
  800c14:	7e 0c                	jle    800c22 <vprintfmt+0x105>
  800c16:	83 fb 39             	cmp    $0x39,%ebx
  800c19:	7f 07                	jg     800c22 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c20:	eb d1                	jmp    800bf3 <vprintfmt+0xd6>
			goto process_precision;
  800c22:	eb 58                	jmp    800c7c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c27:	83 f8 30             	cmp    $0x30,%eax
  800c2a:	73 17                	jae    800c43 <vprintfmt+0x126>
  800c2c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c33:	89 c0                	mov    %eax,%eax
  800c35:	48 01 d0             	add    %rdx,%rax
  800c38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c3b:	83 c2 08             	add    $0x8,%edx
  800c3e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c41:	eb 0f                	jmp    800c52 <vprintfmt+0x135>
  800c43:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c47:	48 89 d0             	mov    %rdx,%rax
  800c4a:	48 83 c2 08          	add    $0x8,%rdx
  800c4e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c52:	8b 00                	mov    (%rax),%eax
  800c54:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c57:	eb 23                	jmp    800c7c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5d:	79 0c                	jns    800c6b <vprintfmt+0x14e>
				width = 0;
  800c5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c66:	e9 3b ff ff ff       	jmpq   800ba6 <vprintfmt+0x89>
  800c6b:	e9 36 ff ff ff       	jmpq   800ba6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c70:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c77:	e9 2a ff ff ff       	jmpq   800ba6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c80:	79 12                	jns    800c94 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c82:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c85:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c88:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c8f:	e9 12 ff ff ff       	jmpq   800ba6 <vprintfmt+0x89>
  800c94:	e9 0d ff ff ff       	jmpq   800ba6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c99:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c9d:	e9 04 ff ff ff       	jmpq   800ba6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ca2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca5:	83 f8 30             	cmp    $0x30,%eax
  800ca8:	73 17                	jae    800cc1 <vprintfmt+0x1a4>
  800caa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb1:	89 c0                	mov    %eax,%eax
  800cb3:	48 01 d0             	add    %rdx,%rax
  800cb6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb9:	83 c2 08             	add    $0x8,%edx
  800cbc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbf:	eb 0f                	jmp    800cd0 <vprintfmt+0x1b3>
  800cc1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc5:	48 89 d0             	mov    %rdx,%rax
  800cc8:	48 83 c2 08          	add    $0x8,%rdx
  800ccc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd0:	8b 10                	mov    (%rax),%edx
  800cd2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cda:	48 89 ce             	mov    %rcx,%rsi
  800cdd:	89 d7                	mov    %edx,%edi
  800cdf:	ff d0                	callq  *%rax
			break;
  800ce1:	e9 53 03 00 00       	jmpq   801039 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ce6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce9:	83 f8 30             	cmp    $0x30,%eax
  800cec:	73 17                	jae    800d05 <vprintfmt+0x1e8>
  800cee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf5:	89 c0                	mov    %eax,%eax
  800cf7:	48 01 d0             	add    %rdx,%rax
  800cfa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfd:	83 c2 08             	add    $0x8,%edx
  800d00:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d03:	eb 0f                	jmp    800d14 <vprintfmt+0x1f7>
  800d05:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d09:	48 89 d0             	mov    %rdx,%rax
  800d0c:	48 83 c2 08          	add    $0x8,%rdx
  800d10:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d14:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d16:	85 db                	test   %ebx,%ebx
  800d18:	79 02                	jns    800d1c <vprintfmt+0x1ff>
				err = -err;
  800d1a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d1c:	83 fb 15             	cmp    $0x15,%ebx
  800d1f:	7f 16                	jg     800d37 <vprintfmt+0x21a>
  800d21:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  800d28:	00 00 00 
  800d2b:	48 63 d3             	movslq %ebx,%rdx
  800d2e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d32:	4d 85 e4             	test   %r12,%r12
  800d35:	75 2e                	jne    800d65 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d37:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3f:	89 d9                	mov    %ebx,%ecx
  800d41:	48 ba 61 1c 80 00 00 	movabs $0x801c61,%rdx
  800d48:	00 00 00 
  800d4b:	48 89 c7             	mov    %rax,%rdi
  800d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d53:	49 b8 48 10 80 00 00 	movabs $0x801048,%r8
  800d5a:	00 00 00 
  800d5d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d60:	e9 d4 02 00 00       	jmpq   801039 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d65:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6d:	4c 89 e1             	mov    %r12,%rcx
  800d70:	48 ba 6a 1c 80 00 00 	movabs $0x801c6a,%rdx
  800d77:	00 00 00 
  800d7a:	48 89 c7             	mov    %rax,%rdi
  800d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d82:	49 b8 48 10 80 00 00 	movabs $0x801048,%r8
  800d89:	00 00 00 
  800d8c:	41 ff d0             	callq  *%r8
			break;
  800d8f:	e9 a5 02 00 00       	jmpq   801039 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d97:	83 f8 30             	cmp    $0x30,%eax
  800d9a:	73 17                	jae    800db3 <vprintfmt+0x296>
  800d9c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800da0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da3:	89 c0                	mov    %eax,%eax
  800da5:	48 01 d0             	add    %rdx,%rax
  800da8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dab:	83 c2 08             	add    $0x8,%edx
  800dae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x2a5>
  800db3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800db7:	48 89 d0             	mov    %rdx,%rax
  800dba:	48 83 c2 08          	add    $0x8,%rdx
  800dbe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dc2:	4c 8b 20             	mov    (%rax),%r12
  800dc5:	4d 85 e4             	test   %r12,%r12
  800dc8:	75 0a                	jne    800dd4 <vprintfmt+0x2b7>
				p = "(null)";
  800dca:	49 bc 6d 1c 80 00 00 	movabs $0x801c6d,%r12
  800dd1:	00 00 00 
			if (width > 0 && padc != '-')
  800dd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd8:	7e 3f                	jle    800e19 <vprintfmt+0x2fc>
  800dda:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dde:	74 39                	je     800e19 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800de0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800de3:	48 98                	cltq   
  800de5:	48 89 c6             	mov    %rax,%rsi
  800de8:	4c 89 e7             	mov    %r12,%rdi
  800deb:	48 b8 f4 12 80 00 00 	movabs $0x8012f4,%rax
  800df2:	00 00 00 
  800df5:	ff d0                	callq  *%rax
  800df7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dfa:	eb 17                	jmp    800e13 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dfc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e00:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e08:	48 89 ce             	mov    %rcx,%rsi
  800e0b:	89 d7                	mov    %edx,%edi
  800e0d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e13:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e17:	7f e3                	jg     800dfc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e19:	eb 37                	jmp    800e52 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e1b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e1f:	74 1e                	je     800e3f <vprintfmt+0x322>
  800e21:	83 fb 1f             	cmp    $0x1f,%ebx
  800e24:	7e 05                	jle    800e2b <vprintfmt+0x30e>
  800e26:	83 fb 7e             	cmp    $0x7e,%ebx
  800e29:	7e 14                	jle    800e3f <vprintfmt+0x322>
					putch('?', putdat);
  800e2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e33:	48 89 d6             	mov    %rdx,%rsi
  800e36:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e3b:	ff d0                	callq  *%rax
  800e3d:	eb 0f                	jmp    800e4e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e47:	48 89 d6             	mov    %rdx,%rsi
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e4e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e52:	4c 89 e0             	mov    %r12,%rax
  800e55:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e59:	0f b6 00             	movzbl (%rax),%eax
  800e5c:	0f be d8             	movsbl %al,%ebx
  800e5f:	85 db                	test   %ebx,%ebx
  800e61:	74 10                	je     800e73 <vprintfmt+0x356>
  800e63:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e67:	78 b2                	js     800e1b <vprintfmt+0x2fe>
  800e69:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e6d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e71:	79 a8                	jns    800e1b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e73:	eb 16                	jmp    800e8b <vprintfmt+0x36e>
				putch(' ', putdat);
  800e75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7d:	48 89 d6             	mov    %rdx,%rsi
  800e80:	bf 20 00 00 00       	mov    $0x20,%edi
  800e85:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e87:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e8f:	7f e4                	jg     800e75 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e91:	e9 a3 01 00 00       	jmpq   801039 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e9a:	be 03 00 00 00       	mov    $0x3,%esi
  800e9f:	48 89 c7             	mov    %rax,%rdi
  800ea2:	48 b8 0d 0a 80 00 00 	movabs $0x800a0d,%rax
  800ea9:	00 00 00 
  800eac:	ff d0                	callq  *%rax
  800eae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb6:	48 85 c0             	test   %rax,%rax
  800eb9:	79 1d                	jns    800ed8 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ebb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ebf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec3:	48 89 d6             	mov    %rdx,%rsi
  800ec6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ecb:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed1:	48 f7 d8             	neg    %rax
  800ed4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ed8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800edf:	e9 e8 00 00 00       	jmpq   800fcc <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ee4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee8:	be 03 00 00 00       	mov    $0x3,%esi
  800eed:	48 89 c7             	mov    %rax,%rdi
  800ef0:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  800ef7:	00 00 00 
  800efa:	ff d0                	callq  *%rax
  800efc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f00:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f07:	e9 c0 00 00 00       	jmpq   800fcc <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f14:	48 89 d6             	mov    %rdx,%rsi
  800f17:	bf 58 00 00 00       	mov    $0x58,%edi
  800f1c:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f26:	48 89 d6             	mov    %rdx,%rsi
  800f29:	bf 58 00 00 00       	mov    $0x58,%edi
  800f2e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f30:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f38:	48 89 d6             	mov    %rdx,%rsi
  800f3b:	bf 58 00 00 00       	mov    $0x58,%edi
  800f40:	ff d0                	callq  *%rax
			break;
  800f42:	e9 f2 00 00 00       	jmpq   801039 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f4f:	48 89 d6             	mov    %rdx,%rsi
  800f52:	bf 30 00 00 00       	mov    $0x30,%edi
  800f57:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f61:	48 89 d6             	mov    %rdx,%rsi
  800f64:	bf 78 00 00 00       	mov    $0x78,%edi
  800f69:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f6e:	83 f8 30             	cmp    $0x30,%eax
  800f71:	73 17                	jae    800f8a <vprintfmt+0x46d>
  800f73:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f7a:	89 c0                	mov    %eax,%eax
  800f7c:	48 01 d0             	add    %rdx,%rax
  800f7f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f82:	83 c2 08             	add    $0x8,%edx
  800f85:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f88:	eb 0f                	jmp    800f99 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f8a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f8e:	48 89 d0             	mov    %rdx,%rax
  800f91:	48 83 c2 08          	add    $0x8,%rdx
  800f95:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f99:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800fa0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fa7:	eb 23                	jmp    800fcc <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fa9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fad:	be 03 00 00 00       	mov    $0x3,%esi
  800fb2:	48 89 c7             	mov    %rax,%rdi
  800fb5:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  800fbc:	00 00 00 
  800fbf:	ff d0                	callq  *%rax
  800fc1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fc5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fcc:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fd1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fd4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fd7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fdb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fdf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe3:	45 89 c1             	mov    %r8d,%r9d
  800fe6:	41 89 f8             	mov    %edi,%r8d
  800fe9:	48 89 c7             	mov    %rax,%rdi
  800fec:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  800ff3:	00 00 00 
  800ff6:	ff d0                	callq  *%rax
			break;
  800ff8:	eb 3f                	jmp    801039 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ffa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801002:	48 89 d6             	mov    %rdx,%rsi
  801005:	89 df                	mov    %ebx,%edi
  801007:	ff d0                	callq  *%rax
			break;
  801009:	eb 2e                	jmp    801039 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80100b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80100f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801013:	48 89 d6             	mov    %rdx,%rsi
  801016:	bf 25 00 00 00       	mov    $0x25,%edi
  80101b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80101d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801022:	eb 05                	jmp    801029 <vprintfmt+0x50c>
  801024:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801029:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80102d:	48 83 e8 01          	sub    $0x1,%rax
  801031:	0f b6 00             	movzbl (%rax),%eax
  801034:	3c 25                	cmp    $0x25,%al
  801036:	75 ec                	jne    801024 <vprintfmt+0x507>
				/* do nothing */;
			break;
  801038:	90                   	nop
		}
	}
  801039:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80103a:	e9 30 fb ff ff       	jmpq   800b6f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80103f:	48 83 c4 60          	add    $0x60,%rsp
  801043:	5b                   	pop    %rbx
  801044:	41 5c                	pop    %r12
  801046:	5d                   	pop    %rbp
  801047:	c3                   	retq   

0000000000801048 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801048:	55                   	push   %rbp
  801049:	48 89 e5             	mov    %rsp,%rbp
  80104c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801053:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80105a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801061:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801068:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80106f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801076:	84 c0                	test   %al,%al
  801078:	74 20                	je     80109a <printfmt+0x52>
  80107a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80107e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801082:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801086:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80108a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80108e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801092:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801096:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80109a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010a1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010a8:	00 00 00 
  8010ab:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010b2:	00 00 00 
  8010b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010b9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010c0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010c7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010ce:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010d5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010dc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010e3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010ea:	48 89 c7             	mov    %rax,%rdi
  8010ed:	48 b8 1d 0b 80 00 00 	movabs $0x800b1d,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010f9:	c9                   	leaveq 
  8010fa:	c3                   	retq   

00000000008010fb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010fb:	55                   	push   %rbp
  8010fc:	48 89 e5             	mov    %rsp,%rbp
  8010ff:	48 83 ec 10          	sub    $0x10,%rsp
  801103:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801106:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80110a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110e:	8b 40 10             	mov    0x10(%rax),%eax
  801111:	8d 50 01             	lea    0x1(%rax),%edx
  801114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801118:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80111b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111f:	48 8b 10             	mov    (%rax),%rdx
  801122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801126:	48 8b 40 08          	mov    0x8(%rax),%rax
  80112a:	48 39 c2             	cmp    %rax,%rdx
  80112d:	73 17                	jae    801146 <sprintputch+0x4b>
		*b->buf++ = ch;
  80112f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801133:	48 8b 00             	mov    (%rax),%rax
  801136:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80113a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80113e:	48 89 0a             	mov    %rcx,(%rdx)
  801141:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801144:	88 10                	mov    %dl,(%rax)
}
  801146:	c9                   	leaveq 
  801147:	c3                   	retq   

0000000000801148 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801148:	55                   	push   %rbp
  801149:	48 89 e5             	mov    %rsp,%rbp
  80114c:	48 83 ec 50          	sub    $0x50,%rsp
  801150:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801154:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801157:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80115b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80115f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801163:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801167:	48 8b 0a             	mov    (%rdx),%rcx
  80116a:	48 89 08             	mov    %rcx,(%rax)
  80116d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801171:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801175:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801179:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80117d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801181:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801185:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801188:	48 98                	cltq   
  80118a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80118e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801192:	48 01 d0             	add    %rdx,%rax
  801195:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801199:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011a0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011a5:	74 06                	je     8011ad <vsnprintf+0x65>
  8011a7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011ab:	7f 07                	jg     8011b4 <vsnprintf+0x6c>
		return -E_INVAL;
  8011ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b2:	eb 2f                	jmp    8011e3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011b4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011b8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011bc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011c0:	48 89 c6             	mov    %rax,%rsi
  8011c3:	48 bf fb 10 80 00 00 	movabs $0x8010fb,%rdi
  8011ca:	00 00 00 
  8011cd:	48 b8 1d 0b 80 00 00 	movabs $0x800b1d,%rax
  8011d4:	00 00 00 
  8011d7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011dd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011e0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011e3:	c9                   	leaveq 
  8011e4:	c3                   	retq   

00000000008011e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e5:	55                   	push   %rbp
  8011e6:	48 89 e5             	mov    %rsp,%rbp
  8011e9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011f0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011f7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011fd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801204:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80120b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801212:	84 c0                	test   %al,%al
  801214:	74 20                	je     801236 <snprintf+0x51>
  801216:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80121a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80121e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801222:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801226:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80122a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80122e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801232:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801236:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80123d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801244:	00 00 00 
  801247:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80124e:	00 00 00 
  801251:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801255:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80125c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801263:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80126a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801271:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801278:	48 8b 0a             	mov    (%rdx),%rcx
  80127b:	48 89 08             	mov    %rcx,(%rax)
  80127e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801282:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801286:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80128a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80128e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801295:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80129c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012a2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012a9:	48 89 c7             	mov    %rax,%rdi
  8012ac:	48 b8 48 11 80 00 00 	movabs $0x801148,%rax
  8012b3:	00 00 00 
  8012b6:	ff d0                	callq  *%rax
  8012b8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012be:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012c4:	c9                   	leaveq 
  8012c5:	c3                   	retq   

00000000008012c6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012c6:	55                   	push   %rbp
  8012c7:	48 89 e5             	mov    %rsp,%rbp
  8012ca:	48 83 ec 18          	sub    $0x18,%rsp
  8012ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012d9:	eb 09                	jmp    8012e4 <strlen+0x1e>
		n++;
  8012db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	84 c0                	test   %al,%al
  8012ed:	75 ec                	jne    8012db <strlen+0x15>
		n++;
	return n;
  8012ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012f2:	c9                   	leaveq 
  8012f3:	c3                   	retq   

00000000008012f4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012f4:	55                   	push   %rbp
  8012f5:	48 89 e5             	mov    %rsp,%rbp
  8012f8:	48 83 ec 20          	sub    $0x20,%rsp
  8012fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801300:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80130b:	eb 0e                	jmp    80131b <strnlen+0x27>
		n++;
  80130d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801311:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801316:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80131b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801320:	74 0b                	je     80132d <strnlen+0x39>
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	0f b6 00             	movzbl (%rax),%eax
  801329:	84 c0                	test   %al,%al
  80132b:	75 e0                	jne    80130d <strnlen+0x19>
		n++;
	return n;
  80132d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 20          	sub    $0x20,%rsp
  80133a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801346:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80134a:	90                   	nop
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801353:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801357:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80135b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80135f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801363:	0f b6 12             	movzbl (%rdx),%edx
  801366:	88 10                	mov    %dl,(%rax)
  801368:	0f b6 00             	movzbl (%rax),%eax
  80136b:	84 c0                	test   %al,%al
  80136d:	75 dc                	jne    80134b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 20          	sub    $0x20,%rsp
  80137d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801381:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801389:	48 89 c7             	mov    %rax,%rdi
  80138c:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  801393:	00 00 00 
  801396:	ff d0                	callq  *%rax
  801398:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80139b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80139e:	48 63 d0             	movslq %eax,%rdx
  8013a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a5:	48 01 c2             	add    %rax,%rdx
  8013a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ac:	48 89 c6             	mov    %rax,%rsi
  8013af:	48 89 d7             	mov    %rdx,%rdi
  8013b2:	48 b8 32 13 80 00 00 	movabs $0x801332,%rax
  8013b9:	00 00 00 
  8013bc:	ff d0                	callq  *%rax
	return dst;
  8013be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013c2:	c9                   	leaveq 
  8013c3:	c3                   	retq   

00000000008013c4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013c4:	55                   	push   %rbp
  8013c5:	48 89 e5             	mov    %rsp,%rbp
  8013c8:	48 83 ec 28          	sub    $0x28,%rsp
  8013cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013e0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013e7:	00 
  8013e8:	eb 2a                	jmp    801414 <strncpy+0x50>
		*dst++ = *src;
  8013ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013fa:	0f b6 12             	movzbl (%rdx),%edx
  8013fd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801403:	0f b6 00             	movzbl (%rax),%eax
  801406:	84 c0                	test   %al,%al
  801408:	74 05                	je     80140f <strncpy+0x4b>
			src++;
  80140a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801418:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80141c:	72 cc                	jb     8013ea <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80141e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801422:	c9                   	leaveq 
  801423:	c3                   	retq   

0000000000801424 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801424:	55                   	push   %rbp
  801425:	48 89 e5             	mov    %rsp,%rbp
  801428:	48 83 ec 28          	sub    $0x28,%rsp
  80142c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801430:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801434:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801440:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801445:	74 3d                	je     801484 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801447:	eb 1d                	jmp    801466 <strlcpy+0x42>
			*dst++ = *src++;
  801449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801451:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801455:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801459:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80145d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801461:	0f b6 12             	movzbl (%rdx),%edx
  801464:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801466:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80146b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801470:	74 0b                	je     80147d <strlcpy+0x59>
  801472:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801476:	0f b6 00             	movzbl (%rax),%eax
  801479:	84 c0                	test   %al,%al
  80147b:	75 cc                	jne    801449 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80147d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801481:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801484:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148c:	48 29 c2             	sub    %rax,%rdx
  80148f:	48 89 d0             	mov    %rdx,%rax
}
  801492:	c9                   	leaveq 
  801493:	c3                   	retq   

0000000000801494 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801494:	55                   	push   %rbp
  801495:	48 89 e5             	mov    %rsp,%rbp
  801498:	48 83 ec 10          	sub    $0x10,%rsp
  80149c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014a4:	eb 0a                	jmp    8014b0 <strcmp+0x1c>
		p++, q++;
  8014a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	84 c0                	test   %al,%al
  8014b9:	74 12                	je     8014cd <strcmp+0x39>
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	0f b6 10             	movzbl (%rax),%edx
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	38 c2                	cmp    %al,%dl
  8014cb:	74 d9                	je     8014a6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	0f b6 d0             	movzbl %al,%edx
  8014d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014db:	0f b6 00             	movzbl (%rax),%eax
  8014de:	0f b6 c0             	movzbl %al,%eax
  8014e1:	29 c2                	sub    %eax,%edx
  8014e3:	89 d0                	mov    %edx,%eax
}
  8014e5:	c9                   	leaveq 
  8014e6:	c3                   	retq   

00000000008014e7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014e7:	55                   	push   %rbp
  8014e8:	48 89 e5             	mov    %rsp,%rbp
  8014eb:	48 83 ec 18          	sub    $0x18,%rsp
  8014ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014fb:	eb 0f                	jmp    80150c <strncmp+0x25>
		n--, p++, q++;
  8014fd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801502:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801507:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80150c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801511:	74 1d                	je     801530 <strncmp+0x49>
  801513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	84 c0                	test   %al,%al
  80151c:	74 12                	je     801530 <strncmp+0x49>
  80151e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801522:	0f b6 10             	movzbl (%rax),%edx
  801525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	38 c2                	cmp    %al,%dl
  80152e:	74 cd                	je     8014fd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801530:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801535:	75 07                	jne    80153e <strncmp+0x57>
		return 0;
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
  80153c:	eb 18                	jmp    801556 <strncmp+0x6f>
	else
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

0000000000801558 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801558:	55                   	push   %rbp
  801559:	48 89 e5             	mov    %rsp,%rbp
  80155c:	48 83 ec 0c          	sub    $0xc,%rsp
  801560:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801564:	89 f0                	mov    %esi,%eax
  801566:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801569:	eb 17                	jmp    801582 <strchr+0x2a>
		if (*s == c)
  80156b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156f:	0f b6 00             	movzbl (%rax),%eax
  801572:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801575:	75 06                	jne    80157d <strchr+0x25>
			return (char *) s;
  801577:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157b:	eb 15                	jmp    801592 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80157d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	84 c0                	test   %al,%al
  80158b:	75 de                	jne    80156b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80158d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801592:	c9                   	leaveq 
  801593:	c3                   	retq   

0000000000801594 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801594:	55                   	push   %rbp
  801595:	48 89 e5             	mov    %rsp,%rbp
  801598:	48 83 ec 0c          	sub    $0xc,%rsp
  80159c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a0:	89 f0                	mov    %esi,%eax
  8015a2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015a5:	eb 13                	jmp    8015ba <strfind+0x26>
		if (*s == c)
  8015a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ab:	0f b6 00             	movzbl (%rax),%eax
  8015ae:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015b1:	75 02                	jne    8015b5 <strfind+0x21>
			break;
  8015b3:	eb 10                	jmp    8015c5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015be:	0f b6 00             	movzbl (%rax),%eax
  8015c1:	84 c0                	test   %al,%al
  8015c3:	75 e2                	jne    8015a7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015c9:	c9                   	leaveq 
  8015ca:	c3                   	retq   

00000000008015cb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015cb:	55                   	push   %rbp
  8015cc:	48 89 e5             	mov    %rsp,%rbp
  8015cf:	48 83 ec 18          	sub    $0x18,%rsp
  8015d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015e3:	75 06                	jne    8015eb <memset+0x20>
		return v;
  8015e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e9:	eb 69                	jmp    801654 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ef:	83 e0 03             	and    $0x3,%eax
  8015f2:	48 85 c0             	test   %rax,%rax
  8015f5:	75 48                	jne    80163f <memset+0x74>
  8015f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fb:	83 e0 03             	and    $0x3,%eax
  8015fe:	48 85 c0             	test   %rax,%rax
  801601:	75 3c                	jne    80163f <memset+0x74>
		c &= 0xFF;
  801603:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80160a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160d:	c1 e0 18             	shl    $0x18,%eax
  801610:	89 c2                	mov    %eax,%edx
  801612:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801615:	c1 e0 10             	shl    $0x10,%eax
  801618:	09 c2                	or     %eax,%edx
  80161a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80161d:	c1 e0 08             	shl    $0x8,%eax
  801620:	09 d0                	or     %edx,%eax
  801622:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801629:	48 c1 e8 02          	shr    $0x2,%rax
  80162d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801630:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801634:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801637:	48 89 d7             	mov    %rdx,%rdi
  80163a:	fc                   	cld    
  80163b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80163d:	eb 11                	jmp    801650 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80163f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801643:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801646:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80164a:	48 89 d7             	mov    %rdx,%rdi
  80164d:	fc                   	cld    
  80164e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801654:	c9                   	leaveq 
  801655:	c3                   	retq   

0000000000801656 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801656:	55                   	push   %rbp
  801657:	48 89 e5             	mov    %rsp,%rbp
  80165a:	48 83 ec 28          	sub    $0x28,%rsp
  80165e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801662:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801666:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80166a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80166e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801676:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80167a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801682:	0f 83 88 00 00 00    	jae    801710 <memmove+0xba>
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801690:	48 01 d0             	add    %rdx,%rax
  801693:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801697:	76 77                	jbe    801710 <memmove+0xba>
		s += n;
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ad:	83 e0 03             	and    $0x3,%eax
  8016b0:	48 85 c0             	test   %rax,%rax
  8016b3:	75 3b                	jne    8016f0 <memmove+0x9a>
  8016b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b9:	83 e0 03             	and    $0x3,%eax
  8016bc:	48 85 c0             	test   %rax,%rax
  8016bf:	75 2f                	jne    8016f0 <memmove+0x9a>
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	83 e0 03             	and    $0x3,%eax
  8016c8:	48 85 c0             	test   %rax,%rax
  8016cb:	75 23                	jne    8016f0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d1:	48 83 e8 04          	sub    $0x4,%rax
  8016d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d9:	48 83 ea 04          	sub    $0x4,%rdx
  8016dd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016e1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016e5:	48 89 c7             	mov    %rax,%rdi
  8016e8:	48 89 d6             	mov    %rdx,%rsi
  8016eb:	fd                   	std    
  8016ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016ee:	eb 1d                	jmp    80170d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016fc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801704:	48 89 d7             	mov    %rdx,%rdi
  801707:	48 89 c1             	mov    %rax,%rcx
  80170a:	fd                   	std    
  80170b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80170d:	fc                   	cld    
  80170e:	eb 57                	jmp    801767 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801710:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801714:	83 e0 03             	and    $0x3,%eax
  801717:	48 85 c0             	test   %rax,%rax
  80171a:	75 36                	jne    801752 <memmove+0xfc>
  80171c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801720:	83 e0 03             	and    $0x3,%eax
  801723:	48 85 c0             	test   %rax,%rax
  801726:	75 2a                	jne    801752 <memmove+0xfc>
  801728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172c:	83 e0 03             	and    $0x3,%eax
  80172f:	48 85 c0             	test   %rax,%rax
  801732:	75 1e                	jne    801752 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	48 c1 e8 02          	shr    $0x2,%rax
  80173c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80173f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801743:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801747:	48 89 c7             	mov    %rax,%rdi
  80174a:	48 89 d6             	mov    %rdx,%rsi
  80174d:	fc                   	cld    
  80174e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801750:	eb 15                	jmp    801767 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801756:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80175a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80175e:	48 89 c7             	mov    %rax,%rdi
  801761:	48 89 d6             	mov    %rdx,%rsi
  801764:	fc                   	cld    
  801765:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80176b:	c9                   	leaveq 
  80176c:	c3                   	retq   

000000000080176d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80176d:	55                   	push   %rbp
  80176e:	48 89 e5             	mov    %rsp,%rbp
  801771:	48 83 ec 18          	sub    $0x18,%rsp
  801775:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801779:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80177d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801781:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801785:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801789:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178d:	48 89 ce             	mov    %rcx,%rsi
  801790:	48 89 c7             	mov    %rax,%rdi
  801793:	48 b8 56 16 80 00 00 	movabs $0x801656,%rax
  80179a:	00 00 00 
  80179d:	ff d0                	callq  *%rax
}
  80179f:	c9                   	leaveq 
  8017a0:	c3                   	retq   

00000000008017a1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017a1:	55                   	push   %rbp
  8017a2:	48 89 e5             	mov    %rsp,%rbp
  8017a5:	48 83 ec 28          	sub    $0x28,%rsp
  8017a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017c5:	eb 36                	jmp    8017fd <memcmp+0x5c>
		if (*s1 != *s2)
  8017c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017cb:	0f b6 10             	movzbl (%rax),%edx
  8017ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	38 c2                	cmp    %al,%dl
  8017d7:	74 1a                	je     8017f3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017dd:	0f b6 00             	movzbl (%rax),%eax
  8017e0:	0f b6 d0             	movzbl %al,%edx
  8017e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e7:	0f b6 00             	movzbl (%rax),%eax
  8017ea:	0f b6 c0             	movzbl %al,%eax
  8017ed:	29 c2                	sub    %eax,%edx
  8017ef:	89 d0                	mov    %edx,%eax
  8017f1:	eb 20                	jmp    801813 <memcmp+0x72>
		s1++, s2++;
  8017f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017f8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801801:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801805:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801809:	48 85 c0             	test   %rax,%rax
  80180c:	75 b9                	jne    8017c7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801813:	c9                   	leaveq 
  801814:	c3                   	retq   

0000000000801815 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801815:	55                   	push   %rbp
  801816:	48 89 e5             	mov    %rsp,%rbp
  801819:	48 83 ec 28          	sub    $0x28,%rsp
  80181d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801821:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801824:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801830:	48 01 d0             	add    %rdx,%rax
  801833:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801837:	eb 15                	jmp    80184e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183d:	0f b6 10             	movzbl (%rax),%edx
  801840:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801843:	38 c2                	cmp    %al,%dl
  801845:	75 02                	jne    801849 <memfind+0x34>
			break;
  801847:	eb 0f                	jmp    801858 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801849:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80184e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801852:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801856:	72 e1                	jb     801839 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80185c:	c9                   	leaveq 
  80185d:	c3                   	retq   

000000000080185e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80185e:	55                   	push   %rbp
  80185f:	48 89 e5             	mov    %rsp,%rbp
  801862:	48 83 ec 34          	sub    $0x34,%rsp
  801866:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80186a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80186e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801871:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801878:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80187f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801880:	eb 05                	jmp    801887 <strtol+0x29>
		s++;
  801882:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188b:	0f b6 00             	movzbl (%rax),%eax
  80188e:	3c 20                	cmp    $0x20,%al
  801890:	74 f0                	je     801882 <strtol+0x24>
  801892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801896:	0f b6 00             	movzbl (%rax),%eax
  801899:	3c 09                	cmp    $0x9,%al
  80189b:	74 e5                	je     801882 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80189d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a1:	0f b6 00             	movzbl (%rax),%eax
  8018a4:	3c 2b                	cmp    $0x2b,%al
  8018a6:	75 07                	jne    8018af <strtol+0x51>
		s++;
  8018a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ad:	eb 17                	jmp    8018c6 <strtol+0x68>
	else if (*s == '-')
  8018af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b3:	0f b6 00             	movzbl (%rax),%eax
  8018b6:	3c 2d                	cmp    $0x2d,%al
  8018b8:	75 0c                	jne    8018c6 <strtol+0x68>
		s++, neg = 1;
  8018ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018ca:	74 06                	je     8018d2 <strtol+0x74>
  8018cc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018d0:	75 28                	jne    8018fa <strtol+0x9c>
  8018d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d6:	0f b6 00             	movzbl (%rax),%eax
  8018d9:	3c 30                	cmp    $0x30,%al
  8018db:	75 1d                	jne    8018fa <strtol+0x9c>
  8018dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e1:	48 83 c0 01          	add    $0x1,%rax
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	3c 78                	cmp    $0x78,%al
  8018ea:	75 0e                	jne    8018fa <strtol+0x9c>
		s += 2, base = 16;
  8018ec:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018f1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018f8:	eb 2c                	jmp    801926 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018fe:	75 19                	jne    801919 <strtol+0xbb>
  801900:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801904:	0f b6 00             	movzbl (%rax),%eax
  801907:	3c 30                	cmp    $0x30,%al
  801909:	75 0e                	jne    801919 <strtol+0xbb>
		s++, base = 8;
  80190b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801910:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801917:	eb 0d                	jmp    801926 <strtol+0xc8>
	else if (base == 0)
  801919:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80191d:	75 07                	jne    801926 <strtol+0xc8>
		base = 10;
  80191f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192a:	0f b6 00             	movzbl (%rax),%eax
  80192d:	3c 2f                	cmp    $0x2f,%al
  80192f:	7e 1d                	jle    80194e <strtol+0xf0>
  801931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801935:	0f b6 00             	movzbl (%rax),%eax
  801938:	3c 39                	cmp    $0x39,%al
  80193a:	7f 12                	jg     80194e <strtol+0xf0>
			dig = *s - '0';
  80193c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801940:	0f b6 00             	movzbl (%rax),%eax
  801943:	0f be c0             	movsbl %al,%eax
  801946:	83 e8 30             	sub    $0x30,%eax
  801949:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80194c:	eb 4e                	jmp    80199c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80194e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801952:	0f b6 00             	movzbl (%rax),%eax
  801955:	3c 60                	cmp    $0x60,%al
  801957:	7e 1d                	jle    801976 <strtol+0x118>
  801959:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195d:	0f b6 00             	movzbl (%rax),%eax
  801960:	3c 7a                	cmp    $0x7a,%al
  801962:	7f 12                	jg     801976 <strtol+0x118>
			dig = *s - 'a' + 10;
  801964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801968:	0f b6 00             	movzbl (%rax),%eax
  80196b:	0f be c0             	movsbl %al,%eax
  80196e:	83 e8 57             	sub    $0x57,%eax
  801971:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801974:	eb 26                	jmp    80199c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197a:	0f b6 00             	movzbl (%rax),%eax
  80197d:	3c 40                	cmp    $0x40,%al
  80197f:	7e 48                	jle    8019c9 <strtol+0x16b>
  801981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801985:	0f b6 00             	movzbl (%rax),%eax
  801988:	3c 5a                	cmp    $0x5a,%al
  80198a:	7f 3d                	jg     8019c9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80198c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801990:	0f b6 00             	movzbl (%rax),%eax
  801993:	0f be c0             	movsbl %al,%eax
  801996:	83 e8 37             	sub    $0x37,%eax
  801999:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80199c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80199f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019a2:	7c 02                	jl     8019a6 <strtol+0x148>
			break;
  8019a4:	eb 23                	jmp    8019c9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8019a6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ab:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019ae:	48 98                	cltq   
  8019b0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8019b5:	48 89 c2             	mov    %rax,%rdx
  8019b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019bb:	48 98                	cltq   
  8019bd:	48 01 d0             	add    %rdx,%rax
  8019c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019c4:	e9 5d ff ff ff       	jmpq   801926 <strtol+0xc8>

	if (endptr)
  8019c9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019ce:	74 0b                	je     8019db <strtol+0x17d>
		*endptr = (char *) s;
  8019d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019d8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019df:	74 09                	je     8019ea <strtol+0x18c>
  8019e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e5:	48 f7 d8             	neg    %rax
  8019e8:	eb 04                	jmp    8019ee <strtol+0x190>
  8019ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019ee:	c9                   	leaveq 
  8019ef:	c3                   	retq   

00000000008019f0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019f0:	55                   	push   %rbp
  8019f1:	48 89 e5             	mov    %rsp,%rbp
  8019f4:	48 83 ec 30          	sub    $0x30,%rsp
  8019f8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019fc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a04:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a08:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a0c:	0f b6 00             	movzbl (%rax),%eax
  801a0f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a12:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a16:	75 06                	jne    801a1e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	eb 6b                	jmp    801a89 <strstr+0x99>

	len = strlen(str);
  801a1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a22:	48 89 c7             	mov    %rax,%rdi
  801a25:	48 b8 c6 12 80 00 00 	movabs $0x8012c6,%rax
  801a2c:	00 00 00 
  801a2f:	ff d0                	callq  *%rax
  801a31:	48 98                	cltq   
  801a33:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a3f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a43:	0f b6 00             	movzbl (%rax),%eax
  801a46:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a49:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a4d:	75 07                	jne    801a56 <strstr+0x66>
				return (char *) 0;
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	eb 33                	jmp    801a89 <strstr+0x99>
		} while (sc != c);
  801a56:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a5a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a5d:	75 d8                	jne    801a37 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a63:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6b:	48 89 ce             	mov    %rcx,%rsi
  801a6e:	48 89 c7             	mov    %rax,%rdi
  801a71:	48 b8 e7 14 80 00 00 	movabs $0x8014e7,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	callq  *%rax
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	75 b6                	jne    801a37 <strstr+0x47>

	return (char *) (in - 1);
  801a81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a85:	48 83 e8 01          	sub    $0x1,%rax
}
  801a89:	c9                   	leaveq 
  801a8a:	c3                   	retq   
