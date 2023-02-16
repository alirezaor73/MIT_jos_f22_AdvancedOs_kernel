
obj/user/buggyhello:     file format elf64-x86-64


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
  80003c:	e8 29 00 00 00       	callq  80006a <libmain>
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
	sys_cputs((char*)1, 1);
  800052:	be 01 00 00 00       	mov    $0x1,%esi
  800057:	bf 01 00 00 00       	mov    $0x1,%edi
  80005c:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
}
  800068:	c9                   	leaveq 
  800069:	c3                   	retq   

000000000080006a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006a:	55                   	push   %rbp
  80006b:	48 89 e5             	mov    %rsp,%rbp
  80006e:	48 83 ec 20          	sub    $0x20,%rsp
  800072:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800075:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800079:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	48 63 d0             	movslq %eax,%rdx
  800093:	48 89 d0             	mov    %rdx,%rax
  800096:	48 c1 e0 03          	shl    $0x3,%rax
  80009a:	48 01 d0             	add    %rdx,%rax
  80009d:	48 c1 e0 05          	shl    $0x5,%rax
  8000a1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000a8:	00 00 00 
  8000ab:	48 01 c2             	add    %rax,%rdx
  8000ae:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000b5:	00 00 00 
  8000b8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000bf:	7e 14                	jle    8000d5 <libmain+0x6b>
		binaryname = argv[0];
  8000c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000c5:	48 8b 10             	mov    (%rax),%rdx
  8000c8:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000cf:	00 00 00 
  8000d2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000dc:	48 89 d6             	mov    %rdx,%rsi
  8000df:	89 c7                	mov    %eax,%edi
  8000e1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e8:	00 00 00 
  8000eb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000ed:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax
}
  8000f9:	c9                   	leaveq 
  8000fa:	c3                   	retq   

00000000008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %rbp
  8000fc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000ff:	48 b8 a2 08 80 00 00 	movabs $0x8008a2,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80010b:	bf 00 00 00 00       	mov    $0x0,%edi
  800110:	48 b8 34 02 80 00 00 	movabs $0x800234,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
}
  80011c:	5d                   	pop    %rbp
  80011d:	c3                   	retq   

000000000080011e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	53                   	push   %rbx
  800123:	48 83 ec 48          	sub    $0x48,%rsp
  800127:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80012a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80012d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800131:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800135:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800139:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800140:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800144:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800148:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80014c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800150:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800154:	4c 89 c3             	mov    %r8,%rbx
  800157:	cd 30                	int    $0x30
  800159:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80015d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800161:	74 3e                	je     8001a1 <syscall+0x83>
  800163:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800168:	7e 37                	jle    8001a1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	49 89 d0             	mov    %rdx,%r8
  800174:	89 c1                	mov    %eax,%ecx
  800176:	48 ba 0a 36 80 00 00 	movabs $0x80360a,%rdx
  80017d:	00 00 00 
  800180:	be 23 00 00 00       	mov    $0x23,%esi
  800185:	48 bf 27 36 80 00 00 	movabs $0x803627,%rdi
  80018c:	00 00 00 
  80018f:	b8 00 00 00 00       	mov    $0x0,%eax
  800194:	49 b9 26 1e 80 00 00 	movabs $0x801e26,%r9
  80019b:	00 00 00 
  80019e:	41 ff d1             	callq  *%r9

	return ret;
  8001a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a5:	48 83 c4 48          	add    $0x48,%rsp
  8001a9:	5b                   	pop    %rbx
  8001aa:	5d                   	pop    %rbp
  8001ab:	c3                   	retq   

00000000008001ac <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001ac:	55                   	push   %rbp
  8001ad:	48 89 e5             	mov    %rsp,%rbp
  8001b0:	48 83 ec 20          	sub    $0x20,%rsp
  8001b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001cb:	00 
  8001cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d8:	48 89 d1             	mov    %rdx,%rcx
  8001db:	48 89 c2             	mov    %rax,%rdx
  8001de:	be 00 00 00 00       	mov    $0x0,%esi
  8001e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e8:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	callq  *%rax
}
  8001f4:	c9                   	leaveq 
  8001f5:	c3                   	retq   

00000000008001f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f6:	55                   	push   %rbp
  8001f7:	48 89 e5             	mov    %rsp,%rbp
  8001fa:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800205:	00 
  800206:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800212:	b9 00 00 00 00       	mov    $0x0,%ecx
  800217:	ba 00 00 00 00       	mov    $0x0,%edx
  80021c:	be 00 00 00 00       	mov    $0x0,%esi
  800221:	bf 01 00 00 00       	mov    $0x1,%edi
  800226:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax
}
  800232:	c9                   	leaveq 
  800233:	c3                   	retq   

0000000000800234 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800234:	55                   	push   %rbp
  800235:	48 89 e5             	mov    %rsp,%rbp
  800238:	48 83 ec 10          	sub    $0x10,%rsp
  80023c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80023f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800242:	48 98                	cltq   
  800244:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80024b:	00 
  80024c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800252:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800258:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	be 01 00 00 00       	mov    $0x1,%esi
  800265:	bf 03 00 00 00       	mov    $0x3,%edi
  80026a:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  800271:	00 00 00 
  800274:	ff d0                	callq  *%rax
}
  800276:	c9                   	leaveq 
  800277:	c3                   	retq   

0000000000800278 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
  80027c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800280:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800287:	00 
  800288:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80028e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800294:	b9 00 00 00 00       	mov    $0x0,%ecx
  800299:	ba 00 00 00 00       	mov    $0x0,%edx
  80029e:	be 00 00 00 00       	mov    $0x0,%esi
  8002a3:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a8:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  8002af:	00 00 00 
  8002b2:	ff d0                	callq  *%rax
}
  8002b4:	c9                   	leaveq 
  8002b5:	c3                   	retq   

00000000008002b6 <sys_yield>:

void
sys_yield(void)
{
  8002b6:	55                   	push   %rbp
  8002b7:	48 89 e5             	mov    %rsp,%rbp
  8002ba:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002c5:	00 
  8002c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002dc:	be 00 00 00 00       	mov    $0x0,%esi
  8002e1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002e6:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  8002ed:	00 00 00 
  8002f0:	ff d0                	callq  *%rax
}
  8002f2:	c9                   	leaveq 
  8002f3:	c3                   	retq   

00000000008002f4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f4:	55                   	push   %rbp
  8002f5:	48 89 e5             	mov    %rsp,%rbp
  8002f8:	48 83 ec 20          	sub    $0x20,%rsp
  8002fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800303:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800306:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800309:	48 63 c8             	movslq %eax,%rcx
  80030c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800313:	48 98                	cltq   
  800315:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80031c:	00 
  80031d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800323:	49 89 c8             	mov    %rcx,%r8
  800326:	48 89 d1             	mov    %rdx,%rcx
  800329:	48 89 c2             	mov    %rax,%rdx
  80032c:	be 01 00 00 00       	mov    $0x1,%esi
  800331:	bf 04 00 00 00       	mov    $0x4,%edi
  800336:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
}
  800342:	c9                   	leaveq 
  800343:	c3                   	retq   

0000000000800344 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800344:	55                   	push   %rbp
  800345:	48 89 e5             	mov    %rsp,%rbp
  800348:	48 83 ec 30          	sub    $0x30,%rsp
  80034c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800353:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800356:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80035a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80035e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800361:	48 63 c8             	movslq %eax,%rcx
  800364:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800368:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036b:	48 63 f0             	movslq %eax,%rsi
  80036e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800372:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800375:	48 98                	cltq   
  800377:	48 89 0c 24          	mov    %rcx,(%rsp)
  80037b:	49 89 f9             	mov    %rdi,%r9
  80037e:	49 89 f0             	mov    %rsi,%r8
  800381:	48 89 d1             	mov    %rdx,%rcx
  800384:	48 89 c2             	mov    %rax,%rdx
  800387:	be 01 00 00 00       	mov    $0x1,%esi
  80038c:	bf 05 00 00 00       	mov    $0x5,%edi
  800391:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  800398:	00 00 00 
  80039b:	ff d0                	callq  *%rax
}
  80039d:	c9                   	leaveq 
  80039e:	c3                   	retq   

000000000080039f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80039f:	55                   	push   %rbp
  8003a0:	48 89 e5             	mov    %rsp,%rbp
  8003a3:	48 83 ec 20          	sub    $0x20,%rsp
  8003a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b5:	48 98                	cltq   
  8003b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003be:	00 
  8003bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003cb:	48 89 d1             	mov    %rdx,%rcx
  8003ce:	48 89 c2             	mov    %rax,%rdx
  8003d1:	be 01 00 00 00       	mov    $0x1,%esi
  8003d6:	bf 06 00 00 00       	mov    $0x6,%edi
  8003db:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax
}
  8003e7:	c9                   	leaveq 
  8003e8:	c3                   	retq   

00000000008003e9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e9:	55                   	push   %rbp
  8003ea:	48 89 e5             	mov    %rsp,%rbp
  8003ed:	48 83 ec 10          	sub    $0x10,%rsp
  8003f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003fa:	48 63 d0             	movslq %eax,%rdx
  8003fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800400:	48 98                	cltq   
  800402:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800409:	00 
  80040a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800410:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800416:	48 89 d1             	mov    %rdx,%rcx
  800419:	48 89 c2             	mov    %rax,%rdx
  80041c:	be 01 00 00 00       	mov    $0x1,%esi
  800421:	bf 08 00 00 00       	mov    $0x8,%edi
  800426:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  80042d:	00 00 00 
  800430:	ff d0                	callq  *%rax
}
  800432:	c9                   	leaveq 
  800433:	c3                   	retq   

0000000000800434 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800434:	55                   	push   %rbp
  800435:	48 89 e5             	mov    %rsp,%rbp
  800438:	48 83 ec 20          	sub    $0x20,%rsp
  80043c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80043f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800443:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800447:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80044a:	48 98                	cltq   
  80044c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800453:	00 
  800454:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80045a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800460:	48 89 d1             	mov    %rdx,%rcx
  800463:	48 89 c2             	mov    %rax,%rdx
  800466:	be 01 00 00 00       	mov    $0x1,%esi
  80046b:	bf 09 00 00 00       	mov    $0x9,%edi
  800470:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  800477:	00 00 00 
  80047a:	ff d0                	callq  *%rax
}
  80047c:	c9                   	leaveq 
  80047d:	c3                   	retq   

000000000080047e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80047e:	55                   	push   %rbp
  80047f:	48 89 e5             	mov    %rsp,%rbp
  800482:	48 83 ec 20          	sub    $0x20,%rsp
  800486:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800489:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80048d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800491:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800494:	48 98                	cltq   
  800496:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80049d:	00 
  80049e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004aa:	48 89 d1             	mov    %rdx,%rcx
  8004ad:	48 89 c2             	mov    %rax,%rdx
  8004b0:	be 01 00 00 00       	mov    $0x1,%esi
  8004b5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004ba:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
}
  8004c6:	c9                   	leaveq 
  8004c7:	c3                   	retq   

00000000008004c8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004c8:	55                   	push   %rbp
  8004c9:	48 89 e5             	mov    %rsp,%rbp
  8004cc:	48 83 ec 20          	sub    $0x20,%rsp
  8004d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004db:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004e1:	48 63 f0             	movslq %eax,%rsi
  8004e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004eb:	48 98                	cltq   
  8004ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004f8:	00 
  8004f9:	49 89 f1             	mov    %rsi,%r9
  8004fc:	49 89 c8             	mov    %rcx,%r8
  8004ff:	48 89 d1             	mov    %rdx,%rcx
  800502:	48 89 c2             	mov    %rax,%rdx
  800505:	be 00 00 00 00       	mov    $0x0,%esi
  80050a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80050f:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  800516:	00 00 00 
  800519:	ff d0                	callq  *%rax
}
  80051b:	c9                   	leaveq 
  80051c:	c3                   	retq   

000000000080051d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80051d:	55                   	push   %rbp
  80051e:	48 89 e5             	mov    %rsp,%rbp
  800521:	48 83 ec 10          	sub    $0x10,%rsp
  800525:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80052d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800534:	00 
  800535:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80053b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800541:	b9 00 00 00 00       	mov    $0x0,%ecx
  800546:	48 89 c2             	mov    %rax,%rdx
  800549:	be 01 00 00 00       	mov    $0x1,%esi
  80054e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800553:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  80055a:	00 00 00 
  80055d:	ff d0                	callq  *%rax
}
  80055f:	c9                   	leaveq 
  800560:	c3                   	retq   

0000000000800561 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800561:	55                   	push   %rbp
  800562:	48 89 e5             	mov    %rsp,%rbp
  800565:	48 83 ec 08          	sub    $0x8,%rsp
  800569:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80056d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800571:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800578:	ff ff ff 
  80057b:	48 01 d0             	add    %rdx,%rax
  80057e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800582:	c9                   	leaveq 
  800583:	c3                   	retq   

0000000000800584 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800584:	55                   	push   %rbp
  800585:	48 89 e5             	mov    %rsp,%rbp
  800588:	48 83 ec 08          	sub    $0x8,%rsp
  80058c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800594:	48 89 c7             	mov    %rax,%rdi
  800597:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  80059e:	00 00 00 
  8005a1:	ff d0                	callq  *%rax
  8005a3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005a9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005ad:	c9                   	leaveq 
  8005ae:	c3                   	retq   

00000000008005af <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005af:	55                   	push   %rbp
  8005b0:	48 89 e5             	mov    %rsp,%rbp
  8005b3:	48 83 ec 18          	sub    $0x18,%rsp
  8005b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005c2:	eb 6b                	jmp    80062f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005c7:	48 98                	cltq   
  8005c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8005d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005db:	48 c1 e8 15          	shr    $0x15,%rax
  8005df:	48 89 c2             	mov    %rax,%rdx
  8005e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005e9:	01 00 00 
  8005ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005f0:	83 e0 01             	and    $0x1,%eax
  8005f3:	48 85 c0             	test   %rax,%rax
  8005f6:	74 21                	je     800619 <fd_alloc+0x6a>
  8005f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005fc:	48 c1 e8 0c          	shr    $0xc,%rax
  800600:	48 89 c2             	mov    %rax,%rdx
  800603:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80060a:	01 00 00 
  80060d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800611:	83 e0 01             	and    $0x1,%eax
  800614:	48 85 c0             	test   %rax,%rax
  800617:	75 12                	jne    80062b <fd_alloc+0x7c>
			*fd_store = fd;
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800621:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800624:	b8 00 00 00 00       	mov    $0x0,%eax
  800629:	eb 1a                	jmp    800645 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80062b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80062f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800633:	7e 8f                	jle    8005c4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800640:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800645:	c9                   	leaveq 
  800646:	c3                   	retq   

0000000000800647 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800647:	55                   	push   %rbp
  800648:	48 89 e5             	mov    %rsp,%rbp
  80064b:	48 83 ec 20          	sub    $0x20,%rsp
  80064f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800652:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800656:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80065a:	78 06                	js     800662 <fd_lookup+0x1b>
  80065c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800660:	7e 07                	jle    800669 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800662:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800667:	eb 6c                	jmp    8006d5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800669:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80066c:	48 98                	cltq   
  80066e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800674:	48 c1 e0 0c          	shl    $0xc,%rax
  800678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80067c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800680:	48 c1 e8 15          	shr    $0x15,%rax
  800684:	48 89 c2             	mov    %rax,%rdx
  800687:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80068e:	01 00 00 
  800691:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800695:	83 e0 01             	and    $0x1,%eax
  800698:	48 85 c0             	test   %rax,%rax
  80069b:	74 21                	je     8006be <fd_lookup+0x77>
  80069d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006a1:	48 c1 e8 0c          	shr    $0xc,%rax
  8006a5:	48 89 c2             	mov    %rax,%rdx
  8006a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006af:	01 00 00 
  8006b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006b6:	83 e0 01             	and    $0x1,%eax
  8006b9:	48 85 c0             	test   %rax,%rax
  8006bc:	75 07                	jne    8006c5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c3:	eb 10                	jmp    8006d5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006cd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006d5:	c9                   	leaveq 
  8006d6:	c3                   	retq   

00000000008006d7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006d7:	55                   	push   %rbp
  8006d8:	48 89 e5             	mov    %rsp,%rbp
  8006db:	48 83 ec 30          	sub    $0x30,%rsp
  8006df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006e3:	89 f0                	mov    %esi,%eax
  8006e5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006ec:	48 89 c7             	mov    %rax,%rdi
  8006ef:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  8006f6:	00 00 00 
  8006f9:	ff d0                	callq  *%rax
  8006fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8006ff:	48 89 d6             	mov    %rdx,%rsi
  800702:	89 c7                	mov    %eax,%edi
  800704:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  80070b:	00 00 00 
  80070e:	ff d0                	callq  *%rax
  800710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800717:	78 0a                	js     800723 <fd_close+0x4c>
	    || fd != fd2)
  800719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800721:	74 12                	je     800735 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800723:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800727:	74 05                	je     80072e <fd_close+0x57>
  800729:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072c:	eb 05                	jmp    800733 <fd_close+0x5c>
  80072e:	b8 00 00 00 00       	mov    $0x0,%eax
  800733:	eb 69                	jmp    80079e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800739:	8b 00                	mov    (%rax),%eax
  80073b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80073f:	48 89 d6             	mov    %rdx,%rsi
  800742:	89 c7                	mov    %eax,%edi
  800744:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  80074b:	00 00 00 
  80074e:	ff d0                	callq  *%rax
  800750:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800753:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800757:	78 2a                	js     800783 <fd_close+0xac>
		if (dev->dev_close)
  800759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075d:	48 8b 40 20          	mov    0x20(%rax),%rax
  800761:	48 85 c0             	test   %rax,%rax
  800764:	74 16                	je     80077c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80076e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800772:	48 89 d7             	mov    %rdx,%rdi
  800775:	ff d0                	callq  *%rax
  800777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80077a:	eb 07                	jmp    800783 <fd_close+0xac>
		else
			r = 0;
  80077c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800787:	48 89 c6             	mov    %rax,%rsi
  80078a:	bf 00 00 00 00       	mov    $0x0,%edi
  80078f:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  800796:	00 00 00 
  800799:	ff d0                	callq  *%rax
	return r;
  80079b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80079e:	c9                   	leaveq 
  80079f:	c3                   	retq   

00000000008007a0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007a0:	55                   	push   %rbp
  8007a1:	48 89 e5             	mov    %rsp,%rbp
  8007a4:	48 83 ec 20          	sub    $0x20,%rsp
  8007a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007b6:	eb 41                	jmp    8007f9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007b8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007bf:	00 00 00 
  8007c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007c5:	48 63 d2             	movslq %edx,%rdx
  8007c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007cc:	8b 00                	mov    (%rax),%eax
  8007ce:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007d1:	75 22                	jne    8007f5 <dev_lookup+0x55>
			*dev = devtab[i];
  8007d3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007da:	00 00 00 
  8007dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007e0:	48 63 d2             	movslq %edx,%rdx
  8007e3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007eb:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f3:	eb 60                	jmp    800855 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007f9:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800800:	00 00 00 
  800803:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800806:	48 63 d2             	movslq %edx,%rdx
  800809:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80080d:	48 85 c0             	test   %rax,%rax
  800810:	75 a6                	jne    8007b8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800812:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800819:	00 00 00 
  80081c:	48 8b 00             	mov    (%rax),%rax
  80081f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800825:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800828:	89 c6                	mov    %eax,%esi
  80082a:	48 bf 38 36 80 00 00 	movabs $0x803638,%rdi
  800831:	00 00 00 
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
  800839:	48 b9 5f 20 80 00 00 	movabs $0x80205f,%rcx
  800840:	00 00 00 
  800843:	ff d1                	callq  *%rcx
	*dev = 0;
  800845:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800849:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800850:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800855:	c9                   	leaveq 
  800856:	c3                   	retq   

0000000000800857 <close>:

int
close(int fdnum)
{
  800857:	55                   	push   %rbp
  800858:	48 89 e5             	mov    %rsp,%rbp
  80085b:	48 83 ec 20          	sub    $0x20,%rsp
  80085f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800862:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800866:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800869:	48 89 d6             	mov    %rdx,%rsi
  80086c:	89 c7                	mov    %eax,%edi
  80086e:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800875:	00 00 00 
  800878:	ff d0                	callq  *%rax
  80087a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80087d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800881:	79 05                	jns    800888 <close+0x31>
		return r;
  800883:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800886:	eb 18                	jmp    8008a0 <close+0x49>
	else
		return fd_close(fd, 1);
  800888:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80088c:	be 01 00 00 00       	mov    $0x1,%esi
  800891:	48 89 c7             	mov    %rax,%rdi
  800894:	48 b8 d7 06 80 00 00 	movabs $0x8006d7,%rax
  80089b:	00 00 00 
  80089e:	ff d0                	callq  *%rax
}
  8008a0:	c9                   	leaveq 
  8008a1:	c3                   	retq   

00000000008008a2 <close_all>:

void
close_all(void)
{
  8008a2:	55                   	push   %rbp
  8008a3:	48 89 e5             	mov    %rsp,%rbp
  8008a6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008b1:	eb 15                	jmp    8008c8 <close_all+0x26>
		close(i);
  8008b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008b6:	89 c7                	mov    %eax,%edi
  8008b8:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  8008bf:	00 00 00 
  8008c2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008c8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008cc:	7e e5                	jle    8008b3 <close_all+0x11>
		close(i);
}
  8008ce:	c9                   	leaveq 
  8008cf:	c3                   	retq   

00000000008008d0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008d0:	55                   	push   %rbp
  8008d1:	48 89 e5             	mov    %rsp,%rbp
  8008d4:	48 83 ec 40          	sub    $0x40,%rsp
  8008d8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008db:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008de:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008e2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008e5:	48 89 d6             	mov    %rdx,%rsi
  8008e8:	89 c7                	mov    %eax,%edi
  8008ea:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  8008f1:	00 00 00 
  8008f4:	ff d0                	callq  *%rax
  8008f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008fd:	79 08                	jns    800907 <dup+0x37>
		return r;
  8008ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800902:	e9 70 01 00 00       	jmpq   800a77 <dup+0x1a7>
	close(newfdnum);
  800907:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80090a:	89 c7                	mov    %eax,%edi
  80090c:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  800913:	00 00 00 
  800916:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800918:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80091b:	48 98                	cltq   
  80091d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800923:	48 c1 e0 0c          	shl    $0xc,%rax
  800927:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80092b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80092f:	48 89 c7             	mov    %rax,%rdi
  800932:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  800939:	00 00 00 
  80093c:	ff d0                	callq  *%rax
  80093e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800946:	48 89 c7             	mov    %rax,%rdi
  800949:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  800950:	00 00 00 
  800953:	ff d0                	callq  *%rax
  800955:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	48 c1 e8 15          	shr    $0x15,%rax
  800961:	48 89 c2             	mov    %rax,%rdx
  800964:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80096b:	01 00 00 
  80096e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800972:	83 e0 01             	and    $0x1,%eax
  800975:	48 85 c0             	test   %rax,%rax
  800978:	74 73                	je     8009ed <dup+0x11d>
  80097a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097e:	48 c1 e8 0c          	shr    $0xc,%rax
  800982:	48 89 c2             	mov    %rax,%rdx
  800985:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80098c:	01 00 00 
  80098f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800993:	83 e0 01             	and    $0x1,%eax
  800996:	48 85 c0             	test   %rax,%rax
  800999:	74 52                	je     8009ed <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80099b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099f:	48 c1 e8 0c          	shr    $0xc,%rax
  8009a3:	48 89 c2             	mov    %rax,%rdx
  8009a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009ad:	01 00 00 
  8009b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8009b9:	89 c1                	mov    %eax,%ecx
  8009bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c3:	41 89 c8             	mov    %ecx,%r8d
  8009c6:	48 89 d1             	mov    %rdx,%rcx
  8009c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ce:	48 89 c6             	mov    %rax,%rsi
  8009d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8009d6:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  8009dd:	00 00 00 
  8009e0:	ff d0                	callq  *%rax
  8009e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009e9:	79 02                	jns    8009ed <dup+0x11d>
			goto err;
  8009eb:	eb 57                	jmp    800a44 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8009f5:	48 89 c2             	mov    %rax,%rdx
  8009f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009ff:	01 00 00 
  800a02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a06:	25 07 0e 00 00       	and    $0xe07,%eax
  800a0b:	89 c1                	mov    %eax,%ecx
  800a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a15:	41 89 c8             	mov    %ecx,%r8d
  800a18:	48 89 d1             	mov    %rdx,%rcx
  800a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a20:	48 89 c6             	mov    %rax,%rsi
  800a23:	bf 00 00 00 00       	mov    $0x0,%edi
  800a28:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
  800a34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a3b:	79 02                	jns    800a3f <dup+0x16f>
		goto err;
  800a3d:	eb 05                	jmp    800a44 <dup+0x174>

	return newfdnum;
  800a3f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a42:	eb 33                	jmp    800a77 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a48:	48 89 c6             	mov    %rax,%rsi
  800a4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a50:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  800a57:	00 00 00 
  800a5a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a60:	48 89 c6             	mov    %rax,%rsi
  800a63:	bf 00 00 00 00       	mov    $0x0,%edi
  800a68:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  800a6f:	00 00 00 
  800a72:	ff d0                	callq  *%rax
	return r;
  800a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a77:	c9                   	leaveq 
  800a78:	c3                   	retq   

0000000000800a79 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a79:	55                   	push   %rbp
  800a7a:	48 89 e5             	mov    %rsp,%rbp
  800a7d:	48 83 ec 40          	sub    $0x40,%rsp
  800a81:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a84:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a88:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a8c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a90:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a93:	48 89 d6             	mov    %rdx,%rsi
  800a96:	89 c7                	mov    %eax,%edi
  800a98:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800a9f:	00 00 00 
  800aa2:	ff d0                	callq  *%rax
  800aa4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800aa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aab:	78 24                	js     800ad1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab1:	8b 00                	mov    (%rax),%eax
  800ab3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ab7:	48 89 d6             	mov    %rdx,%rsi
  800aba:	89 c7                	mov    %eax,%edi
  800abc:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800ac3:	00 00 00 
  800ac6:	ff d0                	callq  *%rax
  800ac8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800acb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800acf:	79 05                	jns    800ad6 <read+0x5d>
		return r;
  800ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ad4:	eb 76                	jmp    800b4c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ada:	8b 40 08             	mov    0x8(%rax),%eax
  800add:	83 e0 03             	and    $0x3,%eax
  800ae0:	83 f8 01             	cmp    $0x1,%eax
  800ae3:	75 3a                	jne    800b1f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800ae5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800aec:	00 00 00 
  800aef:	48 8b 00             	mov    (%rax),%rax
  800af2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800af8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800afb:	89 c6                	mov    %eax,%esi
  800afd:	48 bf 57 36 80 00 00 	movabs $0x803657,%rdi
  800b04:	00 00 00 
  800b07:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0c:	48 b9 5f 20 80 00 00 	movabs $0x80205f,%rcx
  800b13:	00 00 00 
  800b16:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b1d:	eb 2d                	jmp    800b4c <read+0xd3>
	}
	if (!dev->dev_read)
  800b1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b23:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b27:	48 85 c0             	test   %rax,%rax
  800b2a:	75 07                	jne    800b33 <read+0xba>
		return -E_NOT_SUPP;
  800b2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b31:	eb 19                	jmp    800b4c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b37:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b3b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b43:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b47:	48 89 cf             	mov    %rcx,%rdi
  800b4a:	ff d0                	callq  *%rax
}
  800b4c:	c9                   	leaveq 
  800b4d:	c3                   	retq   

0000000000800b4e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b4e:	55                   	push   %rbp
  800b4f:	48 89 e5             	mov    %rsp,%rbp
  800b52:	48 83 ec 30          	sub    $0x30,%rsp
  800b56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b5d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b68:	eb 49                	jmp    800bb3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b6d:	48 98                	cltq   
  800b6f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b73:	48 29 c2             	sub    %rax,%rdx
  800b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b79:	48 63 c8             	movslq %eax,%rcx
  800b7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b80:	48 01 c1             	add    %rax,%rcx
  800b83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b86:	48 89 ce             	mov    %rcx,%rsi
  800b89:	89 c7                	mov    %eax,%edi
  800b8b:	48 b8 79 0a 80 00 00 	movabs $0x800a79,%rax
  800b92:	00 00 00 
  800b95:	ff d0                	callq  *%rax
  800b97:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800b9a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b9e:	79 05                	jns    800ba5 <readn+0x57>
			return m;
  800ba0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ba3:	eb 1c                	jmp    800bc1 <readn+0x73>
		if (m == 0)
  800ba5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ba9:	75 02                	jne    800bad <readn+0x5f>
			break;
  800bab:	eb 11                	jmp    800bbe <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb0:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bb6:	48 98                	cltq   
  800bb8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bbc:	72 ac                	jb     800b6a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bc1:	c9                   	leaveq 
  800bc2:	c3                   	retq   

0000000000800bc3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bc3:	55                   	push   %rbp
  800bc4:	48 89 e5             	mov    %rsp,%rbp
  800bc7:	48 83 ec 40          	sub    $0x40,%rsp
  800bcb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bd2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bd6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bda:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bdd:	48 89 d6             	mov    %rdx,%rsi
  800be0:	89 c7                	mov    %eax,%edi
  800be2:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800be9:	00 00 00 
  800bec:	ff d0                	callq  *%rax
  800bee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bf5:	78 24                	js     800c1b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfb:	8b 00                	mov    (%rax),%eax
  800bfd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c01:	48 89 d6             	mov    %rdx,%rsi
  800c04:	89 c7                	mov    %eax,%edi
  800c06:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800c0d:	00 00 00 
  800c10:	ff d0                	callq  *%rax
  800c12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c19:	79 05                	jns    800c20 <write+0x5d>
		return r;
  800c1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c1e:	eb 75                	jmp    800c95 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c24:	8b 40 08             	mov    0x8(%rax),%eax
  800c27:	83 e0 03             	and    $0x3,%eax
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	75 3a                	jne    800c68 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c2e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c35:	00 00 00 
  800c38:	48 8b 00             	mov    (%rax),%rax
  800c3b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c41:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c44:	89 c6                	mov    %eax,%esi
  800c46:	48 bf 73 36 80 00 00 	movabs $0x803673,%rdi
  800c4d:	00 00 00 
  800c50:	b8 00 00 00 00       	mov    $0x0,%eax
  800c55:	48 b9 5f 20 80 00 00 	movabs $0x80205f,%rcx
  800c5c:	00 00 00 
  800c5f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c66:	eb 2d                	jmp    800c95 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c70:	48 85 c0             	test   %rax,%rax
  800c73:	75 07                	jne    800c7c <write+0xb9>
		return -E_NOT_SUPP;
  800c75:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c7a:	eb 19                	jmp    800c95 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c80:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c84:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c88:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c90:	48 89 cf             	mov    %rcx,%rdi
  800c93:	ff d0                	callq  *%rax
}
  800c95:	c9                   	leaveq 
  800c96:	c3                   	retq   

0000000000800c97 <seek>:

int
seek(int fdnum, off_t offset)
{
  800c97:	55                   	push   %rbp
  800c98:	48 89 e5             	mov    %rsp,%rbp
  800c9b:	48 83 ec 18          	sub    $0x18,%rsp
  800c9f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800ca2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ca5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ca9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cac:	48 89 d6             	mov    %rdx,%rsi
  800caf:	89 c7                	mov    %eax,%edi
  800cb1:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800cb8:	00 00 00 
  800cbb:	ff d0                	callq  *%rax
  800cbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc4:	79 05                	jns    800ccb <seek+0x34>
		return r;
  800cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cc9:	eb 0f                	jmp    800cda <seek+0x43>
	fd->fd_offset = offset;
  800ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ccf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cd2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cda:	c9                   	leaveq 
  800cdb:	c3                   	retq   

0000000000800cdc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800cdc:	55                   	push   %rbp
  800cdd:	48 89 e5             	mov    %rsp,%rbp
  800ce0:	48 83 ec 30          	sub    $0x30,%rsp
  800ce4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ce7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cf1:	48 89 d6             	mov    %rdx,%rsi
  800cf4:	89 c7                	mov    %eax,%edi
  800cf6:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800cfd:	00 00 00 
  800d00:	ff d0                	callq  *%rax
  800d02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d09:	78 24                	js     800d2f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0f:	8b 00                	mov    (%rax),%eax
  800d11:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d15:	48 89 d6             	mov    %rdx,%rsi
  800d18:	89 c7                	mov    %eax,%edi
  800d1a:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800d21:	00 00 00 
  800d24:	ff d0                	callq  *%rax
  800d26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d2d:	79 05                	jns    800d34 <ftruncate+0x58>
		return r;
  800d2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d32:	eb 72                	jmp    800da6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d38:	8b 40 08             	mov    0x8(%rax),%eax
  800d3b:	83 e0 03             	and    $0x3,%eax
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	75 3a                	jne    800d7c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d42:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d49:	00 00 00 
  800d4c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d4f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d55:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d58:	89 c6                	mov    %eax,%esi
  800d5a:	48 bf 90 36 80 00 00 	movabs $0x803690,%rdi
  800d61:	00 00 00 
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
  800d69:	48 b9 5f 20 80 00 00 	movabs $0x80205f,%rcx
  800d70:	00 00 00 
  800d73:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d7a:	eb 2a                	jmp    800da6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d80:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d84:	48 85 c0             	test   %rax,%rax
  800d87:	75 07                	jne    800d90 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d89:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d8e:	eb 16                	jmp    800da6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d94:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800d9f:	89 ce                	mov    %ecx,%esi
  800da1:	48 89 d7             	mov    %rdx,%rdi
  800da4:	ff d0                	callq  *%rax
}
  800da6:	c9                   	leaveq 
  800da7:	c3                   	retq   

0000000000800da8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800da8:	55                   	push   %rbp
  800da9:	48 89 e5             	mov    %rsp,%rbp
  800dac:	48 83 ec 30          	sub    $0x30,%rsp
  800db0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800db3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800db7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dbb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dbe:	48 89 d6             	mov    %rdx,%rsi
  800dc1:	89 c7                	mov    %eax,%edi
  800dc3:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  800dca:	00 00 00 
  800dcd:	ff d0                	callq  *%rax
  800dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dd6:	78 24                	js     800dfc <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddc:	8b 00                	mov    (%rax),%eax
  800dde:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800de2:	48 89 d6             	mov    %rdx,%rsi
  800de5:	89 c7                	mov    %eax,%edi
  800de7:	48 b8 a0 07 80 00 00 	movabs $0x8007a0,%rax
  800dee:	00 00 00 
  800df1:	ff d0                	callq  *%rax
  800df3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dfa:	79 05                	jns    800e01 <fstat+0x59>
		return r;
  800dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dff:	eb 5e                	jmp    800e5f <fstat+0xb7>
	if (!dev->dev_stat)
  800e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e05:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e09:	48 85 c0             	test   %rax,%rax
  800e0c:	75 07                	jne    800e15 <fstat+0x6d>
		return -E_NOT_SUPP;
  800e0e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e13:	eb 4a                	jmp    800e5f <fstat+0xb7>
	stat->st_name[0] = 0;
  800e15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e19:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e20:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e27:	00 00 00 
	stat->st_isdir = 0;
  800e2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e35:	00 00 00 
	stat->st_dev = dev;
  800e38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e40:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4b:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e53:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e57:	48 89 ce             	mov    %rcx,%rsi
  800e5a:	48 89 d7             	mov    %rdx,%rdi
  800e5d:	ff d0                	callq  *%rax
}
  800e5f:	c9                   	leaveq 
  800e60:	c3                   	retq   

0000000000800e61 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e61:	55                   	push   %rbp
  800e62:	48 89 e5             	mov    %rsp,%rbp
  800e65:	48 83 ec 20          	sub    $0x20,%rsp
  800e69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e75:	be 00 00 00 00       	mov    $0x0,%esi
  800e7a:	48 89 c7             	mov    %rax,%rdi
  800e7d:	48 b8 4f 0f 80 00 00 	movabs $0x800f4f,%rax
  800e84:	00 00 00 
  800e87:	ff d0                	callq  *%rax
  800e89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e90:	79 05                	jns    800e97 <stat+0x36>
		return fd;
  800e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e95:	eb 2f                	jmp    800ec6 <stat+0x65>
	r = fstat(fd, stat);
  800e97:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e9e:	48 89 d6             	mov    %rdx,%rsi
  800ea1:	89 c7                	mov    %eax,%edi
  800ea3:	48 b8 a8 0d 80 00 00 	movabs $0x800da8,%rax
  800eaa:	00 00 00 
  800ead:	ff d0                	callq  *%rax
  800eaf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eb5:	89 c7                	mov    %eax,%edi
  800eb7:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  800ebe:	00 00 00 
  800ec1:	ff d0                	callq  *%rax
	return r;
  800ec3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ec6:	c9                   	leaveq 
  800ec7:	c3                   	retq   

0000000000800ec8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ec8:	55                   	push   %rbp
  800ec9:	48 89 e5             	mov    %rsp,%rbp
  800ecc:	48 83 ec 10          	sub    $0x10,%rsp
  800ed0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ed7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ede:	00 00 00 
  800ee1:	8b 00                	mov    (%rax),%eax
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 1d                	jne    800f04 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ee7:	bf 01 00 00 00       	mov    $0x1,%edi
  800eec:	48 b8 d9 34 80 00 00 	movabs $0x8034d9,%rax
  800ef3:	00 00 00 
  800ef6:	ff d0                	callq  *%rax
  800ef8:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800eff:	00 00 00 
  800f02:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f04:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f0b:	00 00 00 
  800f0e:	8b 00                	mov    (%rax),%eax
  800f10:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f13:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f18:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f1f:	00 00 00 
  800f22:	89 c7                	mov    %eax,%edi
  800f24:	48 b8 41 34 80 00 00 	movabs $0x803441,%rax
  800f2b:	00 00 00 
  800f2e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f34:	ba 00 00 00 00       	mov    $0x0,%edx
  800f39:	48 89 c6             	mov    %rax,%rsi
  800f3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f41:	48 b8 80 33 80 00 00 	movabs $0x803380,%rax
  800f48:	00 00 00 
  800f4b:	ff d0                	callq  *%rax
}
  800f4d:	c9                   	leaveq 
  800f4e:	c3                   	retq   

0000000000800f4f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f4f:	55                   	push   %rbp
  800f50:	48 89 e5             	mov    %rsp,%rbp
  800f53:	48 83 ec 20          	sub    $0x20,%rsp
  800f57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f62:	48 89 c7             	mov    %rax,%rdi
  800f65:	48 b8 bb 2b 80 00 00 	movabs $0x802bbb,%rax
  800f6c:	00 00 00 
  800f6f:	ff d0                	callq  *%rax
  800f71:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f76:	7e 0a                	jle    800f82 <open+0x33>
		return -E_BAD_PATH;
  800f78:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f7d:	e9 a5 00 00 00       	jmpq   801027 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f82:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f86:	48 89 c7             	mov    %rax,%rdi
  800f89:	48 b8 af 05 80 00 00 	movabs $0x8005af,%rax
  800f90:	00 00 00 
  800f93:	ff d0                	callq  *%rax
  800f95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f9c:	79 08                	jns    800fa6 <open+0x57>
		return r;
  800f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa1:	e9 81 00 00 00       	jmpq   801027 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faa:	48 89 c6             	mov    %rax,%rsi
  800fad:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fb4:	00 00 00 
  800fb7:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  800fbe:	00 00 00 
  800fc1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fc3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fca:	00 00 00 
  800fcd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fd0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fda:	48 89 c6             	mov    %rax,%rsi
  800fdd:	bf 01 00 00 00       	mov    $0x1,%edi
  800fe2:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  800fe9:	00 00 00 
  800fec:	ff d0                	callq  *%rax
  800fee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ff1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ff5:	79 1d                	jns    801014 <open+0xc5>
		fd_close(fd, 0);
  800ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffb:	be 00 00 00 00       	mov    $0x0,%esi
  801000:	48 89 c7             	mov    %rax,%rdi
  801003:	48 b8 d7 06 80 00 00 	movabs $0x8006d7,%rax
  80100a:	00 00 00 
  80100d:	ff d0                	callq  *%rax
		return r;
  80100f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801012:	eb 13                	jmp    801027 <open+0xd8>
	}

	return fd2num(fd);
  801014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801018:	48 89 c7             	mov    %rax,%rdi
  80101b:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  801022:	00 00 00 
  801025:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  801027:	c9                   	leaveq 
  801028:	c3                   	retq   

0000000000801029 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
  80102d:	48 83 ec 10          	sub    $0x10,%rsp
  801031:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801039:	8b 50 0c             	mov    0xc(%rax),%edx
  80103c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801043:	00 00 00 
  801046:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801048:	be 00 00 00 00       	mov    $0x0,%esi
  80104d:	bf 06 00 00 00       	mov    $0x6,%edi
  801052:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  801059:	00 00 00 
  80105c:	ff d0                	callq  *%rax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 83 ec 30          	sub    $0x30,%rsp
  801068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801070:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	8b 50 0c             	mov    0xc(%rax),%edx
  80107b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801082:	00 00 00 
  801085:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801087:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80108e:	00 00 00 
  801091:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801095:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801099:	be 00 00 00 00       	mov    $0x0,%esi
  80109e:	bf 03 00 00 00       	mov    $0x3,%edi
  8010a3:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  8010aa:	00 00 00 
  8010ad:	ff d0                	callq  *%rax
  8010af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010b6:	79 08                	jns    8010c0 <devfile_read+0x60>
		return r;
  8010b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010bb:	e9 a4 00 00 00       	jmpq   801164 <devfile_read+0x104>
	assert(r <= n);
  8010c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c3:	48 98                	cltq   
  8010c5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010c9:	76 35                	jbe    801100 <devfile_read+0xa0>
  8010cb:	48 b9 bd 36 80 00 00 	movabs $0x8036bd,%rcx
  8010d2:	00 00 00 
  8010d5:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  8010dc:	00 00 00 
  8010df:	be 84 00 00 00       	mov    $0x84,%esi
  8010e4:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  8010eb:	00 00 00 
  8010ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f3:	49 b8 26 1e 80 00 00 	movabs $0x801e26,%r8
  8010fa:	00 00 00 
  8010fd:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  801100:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  801107:	7e 35                	jle    80113e <devfile_read+0xde>
  801109:	48 b9 e4 36 80 00 00 	movabs $0x8036e4,%rcx
  801110:	00 00 00 
  801113:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  80111a:	00 00 00 
  80111d:	be 85 00 00 00       	mov    $0x85,%esi
  801122:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  801129:	00 00 00 
  80112c:	b8 00 00 00 00       	mov    $0x0,%eax
  801131:	49 b8 26 1e 80 00 00 	movabs $0x801e26,%r8
  801138:	00 00 00 
  80113b:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80113e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801141:	48 63 d0             	movslq %eax,%rdx
  801144:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801148:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80114f:	00 00 00 
  801152:	48 89 c7             	mov    %rax,%rdi
  801155:	48 b8 4b 2f 80 00 00 	movabs $0x802f4b,%rax
  80115c:	00 00 00 
  80115f:	ff d0                	callq  *%rax
	return r;
  801161:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  801164:	c9                   	leaveq 
  801165:	c3                   	retq   

0000000000801166 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801166:	55                   	push   %rbp
  801167:	48 89 e5             	mov    %rsp,%rbp
  80116a:	48 83 ec 30          	sub    $0x30,%rsp
  80116e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801172:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801176:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	8b 50 0c             	mov    0xc(%rax),%edx
  801181:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801188:	00 00 00 
  80118b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80118d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801194:	00 00 00 
  801197:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80119b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80119f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011a6:	00 
  8011a7:	76 35                	jbe    8011de <devfile_write+0x78>
  8011a9:	48 b9 f0 36 80 00 00 	movabs $0x8036f0,%rcx
  8011b0:	00 00 00 
  8011b3:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  8011ba:	00 00 00 
  8011bd:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011c2:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  8011c9:	00 00 00 
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d1:	49 b8 26 1e 80 00 00 	movabs $0x801e26,%r8
  8011d8:	00 00 00 
  8011db:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e6:	48 89 c6             	mov    %rax,%rsi
  8011e9:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011f0:	00 00 00 
  8011f3:	48 b8 62 30 80 00 00 	movabs $0x803062,%rax
  8011fa:	00 00 00 
  8011fd:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8011ff:	be 00 00 00 00       	mov    $0x0,%esi
  801204:	bf 04 00 00 00       	mov    $0x4,%edi
  801209:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  801210:	00 00 00 
  801213:	ff d0                	callq  *%rax
  801215:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80121c:	79 05                	jns    801223 <devfile_write+0xbd>
		return r;
  80121e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801221:	eb 43                	jmp    801266 <devfile_write+0x100>
	assert(r <= n);
  801223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801226:	48 98                	cltq   
  801228:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80122c:	76 35                	jbe    801263 <devfile_write+0xfd>
  80122e:	48 b9 bd 36 80 00 00 	movabs $0x8036bd,%rcx
  801235:	00 00 00 
  801238:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  80123f:	00 00 00 
  801242:	be a2 00 00 00       	mov    $0xa2,%esi
  801247:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  80124e:	00 00 00 
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	49 b8 26 1e 80 00 00 	movabs $0x801e26,%r8
  80125d:	00 00 00 
  801260:	41 ff d0             	callq  *%r8
	return r;
  801263:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801266:	c9                   	leaveq 
  801267:	c3                   	retq   

0000000000801268 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801268:	55                   	push   %rbp
  801269:	48 89 e5             	mov    %rsp,%rbp
  80126c:	48 83 ec 20          	sub    $0x20,%rsp
  801270:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801274:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127c:	8b 50 0c             	mov    0xc(%rax),%edx
  80127f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801286:	00 00 00 
  801289:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80128b:	be 00 00 00 00       	mov    $0x0,%esi
  801290:	bf 05 00 00 00       	mov    $0x5,%edi
  801295:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  80129c:	00 00 00 
  80129f:	ff d0                	callq  *%rax
  8012a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012a8:	79 05                	jns    8012af <devfile_stat+0x47>
		return r;
  8012aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ad:	eb 56                	jmp    801305 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012ba:	00 00 00 
  8012bd:	48 89 c7             	mov    %rax,%rdi
  8012c0:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  8012c7:	00 00 00 
  8012ca:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012cc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012d3:	00 00 00 
  8012d6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012e6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012ed:	00 00 00 
  8012f0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fa:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801305:	c9                   	leaveq 
  801306:	c3                   	retq   

0000000000801307 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801307:	55                   	push   %rbp
  801308:	48 89 e5             	mov    %rsp,%rbp
  80130b:	48 83 ec 10          	sub    $0x10,%rsp
  80130f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801313:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	8b 50 0c             	mov    0xc(%rax),%edx
  80131d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801324:	00 00 00 
  801327:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801329:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801330:	00 00 00 
  801333:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801336:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801339:	be 00 00 00 00       	mov    $0x0,%esi
  80133e:	bf 02 00 00 00       	mov    $0x2,%edi
  801343:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  80134a:	00 00 00 
  80134d:	ff d0                	callq  *%rax
}
  80134f:	c9                   	leaveq 
  801350:	c3                   	retq   

0000000000801351 <remove>:

// Delete a file
int
remove(const char *path)
{
  801351:	55                   	push   %rbp
  801352:	48 89 e5             	mov    %rsp,%rbp
  801355:	48 83 ec 10          	sub    $0x10,%rsp
  801359:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80135d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801361:	48 89 c7             	mov    %rax,%rdi
  801364:	48 b8 bb 2b 80 00 00 	movabs $0x802bbb,%rax
  80136b:	00 00 00 
  80136e:	ff d0                	callq  *%rax
  801370:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801375:	7e 07                	jle    80137e <remove+0x2d>
		return -E_BAD_PATH;
  801377:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80137c:	eb 33                	jmp    8013b1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80137e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801382:	48 89 c6             	mov    %rax,%rsi
  801385:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80138c:	00 00 00 
  80138f:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  801396:	00 00 00 
  801399:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80139b:	be 00 00 00 00       	mov    $0x0,%esi
  8013a0:	bf 07 00 00 00       	mov    $0x7,%edi
  8013a5:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  8013ac:	00 00 00 
  8013af:	ff d0                	callq  *%rax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013b7:	be 00 00 00 00       	mov    $0x0,%esi
  8013bc:	bf 08 00 00 00       	mov    $0x8,%edi
  8013c1:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  8013c8:	00 00 00 
  8013cb:	ff d0                	callq  *%rax
}
  8013cd:	5d                   	pop    %rbp
  8013ce:	c3                   	retq   

00000000008013cf <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013cf:	55                   	push   %rbp
  8013d0:	48 89 e5             	mov    %rsp,%rbp
  8013d3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013da:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013e1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013e8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013ef:	be 00 00 00 00       	mov    $0x0,%esi
  8013f4:	48 89 c7             	mov    %rax,%rdi
  8013f7:	48 b8 4f 0f 80 00 00 	movabs $0x800f4f,%rax
  8013fe:	00 00 00 
  801401:	ff d0                	callq  *%rax
  801403:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80140a:	79 28                	jns    801434 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80140c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80140f:	89 c6                	mov    %eax,%esi
  801411:	48 bf 1d 37 80 00 00 	movabs $0x80371d,%rdi
  801418:	00 00 00 
  80141b:	b8 00 00 00 00       	mov    $0x0,%eax
  801420:	48 ba 5f 20 80 00 00 	movabs $0x80205f,%rdx
  801427:	00 00 00 
  80142a:	ff d2                	callq  *%rdx
		return fd_src;
  80142c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80142f:	e9 74 01 00 00       	jmpq   8015a8 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801434:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80143b:	be 01 01 00 00       	mov    $0x101,%esi
  801440:	48 89 c7             	mov    %rax,%rdi
  801443:	48 b8 4f 0f 80 00 00 	movabs $0x800f4f,%rax
  80144a:	00 00 00 
  80144d:	ff d0                	callq  *%rax
  80144f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801452:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801456:	79 39                	jns    801491 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801458:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80145b:	89 c6                	mov    %eax,%esi
  80145d:	48 bf 33 37 80 00 00 	movabs $0x803733,%rdi
  801464:	00 00 00 
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
  80146c:	48 ba 5f 20 80 00 00 	movabs $0x80205f,%rdx
  801473:	00 00 00 
  801476:	ff d2                	callq  *%rdx
		close(fd_src);
  801478:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80147b:	89 c7                	mov    %eax,%edi
  80147d:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  801484:	00 00 00 
  801487:	ff d0                	callq  *%rax
		return fd_dest;
  801489:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80148c:	e9 17 01 00 00       	jmpq   8015a8 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801491:	eb 74                	jmp    801507 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801493:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801496:	48 63 d0             	movslq %eax,%rdx
  801499:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014a3:	48 89 ce             	mov    %rcx,%rsi
  8014a6:	89 c7                	mov    %eax,%edi
  8014a8:	48 b8 c3 0b 80 00 00 	movabs $0x800bc3,%rax
  8014af:	00 00 00 
  8014b2:	ff d0                	callq  *%rax
  8014b4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014bb:	79 4a                	jns    801507 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014c0:	89 c6                	mov    %eax,%esi
  8014c2:	48 bf 4d 37 80 00 00 	movabs $0x80374d,%rdi
  8014c9:	00 00 00 
  8014cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d1:	48 ba 5f 20 80 00 00 	movabs $0x80205f,%rdx
  8014d8:	00 00 00 
  8014db:	ff d2                	callq  *%rdx
			close(fd_src);
  8014dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014e0:	89 c7                	mov    %eax,%edi
  8014e2:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  8014e9:	00 00 00 
  8014ec:	ff d0                	callq  *%rax
			close(fd_dest);
  8014ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014f1:	89 c7                	mov    %eax,%edi
  8014f3:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  8014fa:	00 00 00 
  8014fd:	ff d0                	callq  *%rax
			return write_size;
  8014ff:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801502:	e9 a1 00 00 00       	jmpq   8015a8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801507:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80150e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801511:	ba 00 02 00 00       	mov    $0x200,%edx
  801516:	48 89 ce             	mov    %rcx,%rsi
  801519:	89 c7                	mov    %eax,%edi
  80151b:	48 b8 79 0a 80 00 00 	movabs $0x800a79,%rax
  801522:	00 00 00 
  801525:	ff d0                	callq  *%rax
  801527:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80152a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80152e:	0f 8f 5f ff ff ff    	jg     801493 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  801534:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801538:	79 47                	jns    801581 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80153a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153d:	89 c6                	mov    %eax,%esi
  80153f:	48 bf 60 37 80 00 00 	movabs $0x803760,%rdi
  801546:	00 00 00 
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
  80154e:	48 ba 5f 20 80 00 00 	movabs $0x80205f,%rdx
  801555:	00 00 00 
  801558:	ff d2                	callq  *%rdx
		close(fd_src);
  80155a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80155d:	89 c7                	mov    %eax,%edi
  80155f:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
		close(fd_dest);
  80156b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80156e:	89 c7                	mov    %eax,%edi
  801570:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  801577:	00 00 00 
  80157a:	ff d0                	callq  *%rax
		return read_size;
  80157c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80157f:	eb 27                	jmp    8015a8 <copy+0x1d9>
	}
	close(fd_src);
  801581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801584:	89 c7                	mov    %eax,%edi
  801586:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  80158d:	00 00 00 
  801590:	ff d0                	callq  *%rax
	close(fd_dest);
  801592:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801595:	89 c7                	mov    %eax,%edi
  801597:	48 b8 57 08 80 00 00 	movabs $0x800857,%rax
  80159e:	00 00 00 
  8015a1:	ff d0                	callq  *%rax
	return 0;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015a8:	c9                   	leaveq 
  8015a9:	c3                   	retq   

00000000008015aa <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	53                   	push   %rbx
  8015af:	48 83 ec 38          	sub    $0x38,%rsp
  8015b3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015b7:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015bb:	48 89 c7             	mov    %rax,%rdi
  8015be:	48 b8 af 05 80 00 00 	movabs $0x8005af,%rax
  8015c5:	00 00 00 
  8015c8:	ff d0                	callq  *%rax
  8015ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015d1:	0f 88 bf 01 00 00    	js     801796 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015db:	ba 07 04 00 00       	mov    $0x407,%edx
  8015e0:	48 89 c6             	mov    %rax,%rsi
  8015e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8015e8:	48 b8 f4 02 80 00 00 	movabs $0x8002f4,%rax
  8015ef:	00 00 00 
  8015f2:	ff d0                	callq  *%rax
  8015f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015fb:	0f 88 95 01 00 00    	js     801796 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801601:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801605:	48 89 c7             	mov    %rax,%rdi
  801608:	48 b8 af 05 80 00 00 	movabs $0x8005af,%rax
  80160f:	00 00 00 
  801612:	ff d0                	callq  *%rax
  801614:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801617:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80161b:	0f 88 5d 01 00 00    	js     80177e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801621:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801625:	ba 07 04 00 00       	mov    $0x407,%edx
  80162a:	48 89 c6             	mov    %rax,%rsi
  80162d:	bf 00 00 00 00       	mov    $0x0,%edi
  801632:	48 b8 f4 02 80 00 00 	movabs $0x8002f4,%rax
  801639:	00 00 00 
  80163c:	ff d0                	callq  *%rax
  80163e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801641:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801645:	0f 88 33 01 00 00    	js     80177e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	48 89 c7             	mov    %rax,%rdi
  801652:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  801659:	00 00 00 
  80165c:	ff d0                	callq  *%rax
  80165e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801662:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801666:	ba 07 04 00 00       	mov    $0x407,%edx
  80166b:	48 89 c6             	mov    %rax,%rsi
  80166e:	bf 00 00 00 00       	mov    $0x0,%edi
  801673:	48 b8 f4 02 80 00 00 	movabs $0x8002f4,%rax
  80167a:	00 00 00 
  80167d:	ff d0                	callq  *%rax
  80167f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801682:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801686:	79 05                	jns    80168d <pipe+0xe3>
		goto err2;
  801688:	e9 d9 00 00 00       	jmpq   801766 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80168d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801691:	48 89 c7             	mov    %rax,%rdi
  801694:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  80169b:	00 00 00 
  80169e:	ff d0                	callq  *%rax
  8016a0:	48 89 c2             	mov    %rax,%rdx
  8016a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016ad:	48 89 d1             	mov    %rdx,%rcx
  8016b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b5:	48 89 c6             	mov    %rax,%rsi
  8016b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8016bd:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  8016c4:	00 00 00 
  8016c7:	ff d0                	callq  *%rax
  8016c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016d0:	79 1b                	jns    8016ed <pipe+0x143>
		goto err3;
  8016d2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016d7:	48 89 c6             	mov    %rax,%rsi
  8016da:	bf 00 00 00 00       	mov    $0x0,%edi
  8016df:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  8016e6:	00 00 00 
  8016e9:	ff d0                	callq  *%rax
  8016eb:	eb 79                	jmp    801766 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016f8:	00 00 00 
  8016fb:	8b 12                	mov    (%rdx),%edx
  8016fd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8016ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801703:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80170a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801715:	00 00 00 
  801718:	8b 12                	mov    (%rdx),%edx
  80171a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80171c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801720:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	48 89 c7             	mov    %rax,%rdi
  80172e:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  801735:	00 00 00 
  801738:	ff d0                	callq  *%rax
  80173a:	89 c2                	mov    %eax,%edx
  80173c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801740:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801742:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801746:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80174a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174e:	48 89 c7             	mov    %rax,%rdi
  801751:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  801758:	00 00 00 
  80175b:	ff d0                	callq  *%rax
  80175d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80175f:	b8 00 00 00 00       	mov    $0x0,%eax
  801764:	eb 33                	jmp    801799 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176a:	48 89 c6             	mov    %rax,%rsi
  80176d:	bf 00 00 00 00       	mov    $0x0,%edi
  801772:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  801779:	00 00 00 
  80177c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	48 89 c6             	mov    %rax,%rsi
  801785:	bf 00 00 00 00       	mov    $0x0,%edi
  80178a:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  801791:	00 00 00 
  801794:	ff d0                	callq  *%rax
err:
	return r;
  801796:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801799:	48 83 c4 38          	add    $0x38,%rsp
  80179d:	5b                   	pop    %rbx
  80179e:	5d                   	pop    %rbp
  80179f:	c3                   	retq   

00000000008017a0 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017a0:	55                   	push   %rbp
  8017a1:	48 89 e5             	mov    %rsp,%rbp
  8017a4:	53                   	push   %rbx
  8017a5:	48 83 ec 28          	sub    $0x28,%rsp
  8017a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017b8:	00 00 00 
  8017bb:	48 8b 00             	mov    (%rax),%rax
  8017be:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	48 89 c7             	mov    %rax,%rdi
  8017ce:	48 b8 5b 35 80 00 00 	movabs $0x80355b,%rax
  8017d5:	00 00 00 
  8017d8:	ff d0                	callq  *%rax
  8017da:	89 c3                	mov    %eax,%ebx
  8017dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e0:	48 89 c7             	mov    %rax,%rdi
  8017e3:	48 b8 5b 35 80 00 00 	movabs $0x80355b,%rax
  8017ea:	00 00 00 
  8017ed:	ff d0                	callq  *%rax
  8017ef:	39 c3                	cmp    %eax,%ebx
  8017f1:	0f 94 c0             	sete   %al
  8017f4:	0f b6 c0             	movzbl %al,%eax
  8017f7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8017fa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801801:	00 00 00 
  801804:	48 8b 00             	mov    (%rax),%rax
  801807:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80180d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801810:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801813:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801816:	75 05                	jne    80181d <_pipeisclosed+0x7d>
			return ret;
  801818:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80181b:	eb 4f                	jmp    80186c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80181d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801820:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801823:	74 42                	je     801867 <_pipeisclosed+0xc7>
  801825:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801829:	75 3c                	jne    801867 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80182b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801832:	00 00 00 
  801835:	48 8b 00             	mov    (%rax),%rax
  801838:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80183e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801841:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801844:	89 c6                	mov    %eax,%esi
  801846:	48 bf 7b 37 80 00 00 	movabs $0x80377b,%rdi
  80184d:	00 00 00 
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	49 b8 5f 20 80 00 00 	movabs $0x80205f,%r8
  80185c:	00 00 00 
  80185f:	41 ff d0             	callq  *%r8
	}
  801862:	e9 4a ff ff ff       	jmpq   8017b1 <_pipeisclosed+0x11>
  801867:	e9 45 ff ff ff       	jmpq   8017b1 <_pipeisclosed+0x11>
}
  80186c:	48 83 c4 28          	add    $0x28,%rsp
  801870:	5b                   	pop    %rbx
  801871:	5d                   	pop    %rbp
  801872:	c3                   	retq   

0000000000801873 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801873:	55                   	push   %rbp
  801874:	48 89 e5             	mov    %rsp,%rbp
  801877:	48 83 ec 30          	sub    $0x30,%rsp
  80187b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80187e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801882:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801885:	48 89 d6             	mov    %rdx,%rsi
  801888:	89 c7                	mov    %eax,%edi
  80188a:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  801891:	00 00 00 
  801894:	ff d0                	callq  *%rax
  801896:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801899:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80189d:	79 05                	jns    8018a4 <pipeisclosed+0x31>
		return r;
  80189f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a2:	eb 31                	jmp    8018d5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8018a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a8:	48 89 c7             	mov    %rax,%rdi
  8018ab:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  8018b2:	00 00 00 
  8018b5:	ff d0                	callq  *%rax
  8018b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c3:	48 89 d6             	mov    %rdx,%rsi
  8018c6:	48 89 c7             	mov    %rax,%rdi
  8018c9:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 40          	sub    $0x40,%rsp
  8018df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ef:	48 89 c7             	mov    %rax,%rdi
  8018f2:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  8018f9:	00 00 00 
  8018fc:	ff d0                	callq  *%rax
  8018fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801902:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801906:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80190a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801911:	00 
  801912:	e9 92 00 00 00       	jmpq   8019a9 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801917:	eb 41                	jmp    80195a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801919:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80191e:	74 09                	je     801929 <devpipe_read+0x52>
				return i;
  801920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801924:	e9 92 00 00 00       	jmpq   8019bb <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801929:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	48 89 d6             	mov    %rdx,%rsi
  801934:	48 89 c7             	mov    %rax,%rdi
  801937:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  80193e:	00 00 00 
  801941:	ff d0                	callq  *%rax
  801943:	85 c0                	test   %eax,%eax
  801945:	74 07                	je     80194e <devpipe_read+0x77>
				return 0;
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	eb 6d                	jmp    8019bb <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80194e:	48 b8 b6 02 80 00 00 	movabs $0x8002b6,%rax
  801955:	00 00 00 
  801958:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80195a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195e:	8b 10                	mov    (%rax),%edx
  801960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801964:	8b 40 04             	mov    0x4(%rax),%eax
  801967:	39 c2                	cmp    %eax,%edx
  801969:	74 ae                	je     801919 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80196b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801973:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801977:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80197b:	8b 00                	mov    (%rax),%eax
  80197d:	99                   	cltd   
  80197e:	c1 ea 1b             	shr    $0x1b,%edx
  801981:	01 d0                	add    %edx,%eax
  801983:	83 e0 1f             	and    $0x1f,%eax
  801986:	29 d0                	sub    %edx,%eax
  801988:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198c:	48 98                	cltq   
  80198e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801993:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801995:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801999:	8b 00                	mov    (%rax),%eax
  80199b:	8d 50 01             	lea    0x1(%rax),%edx
  80199e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a2:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019b1:	0f 82 60 ff ff ff    	jb     801917 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 40          	sub    $0x40,%rsp
  8019c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019cd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d5:	48 89 c7             	mov    %rax,%rdi
  8019d8:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	callq  *%rax
  8019e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019f0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019f7:	00 
  8019f8:	e9 8e 00 00 00       	jmpq   801a8b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019fd:	eb 31                	jmp    801a30 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a07:	48 89 d6             	mov    %rdx,%rsi
  801a0a:	48 89 c7             	mov    %rax,%rdi
  801a0d:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  801a14:	00 00 00 
  801a17:	ff d0                	callq  *%rax
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	74 07                	je     801a24 <devpipe_write+0x67>
				return 0;
  801a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a22:	eb 79                	jmp    801a9d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a24:	48 b8 b6 02 80 00 00 	movabs $0x8002b6,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a34:	8b 40 04             	mov    0x4(%rax),%eax
  801a37:	48 63 d0             	movslq %eax,%rdx
  801a3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a3e:	8b 00                	mov    (%rax),%eax
  801a40:	48 98                	cltq   
  801a42:	48 83 c0 20          	add    $0x20,%rax
  801a46:	48 39 c2             	cmp    %rax,%rdx
  801a49:	73 b4                	jae    8019ff <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a4f:	8b 40 04             	mov    0x4(%rax),%eax
  801a52:	99                   	cltd   
  801a53:	c1 ea 1b             	shr    $0x1b,%edx
  801a56:	01 d0                	add    %edx,%eax
  801a58:	83 e0 1f             	and    $0x1f,%eax
  801a5b:	29 d0                	sub    %edx,%eax
  801a5d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a65:	48 01 ca             	add    %rcx,%rdx
  801a68:	0f b6 0a             	movzbl (%rdx),%ecx
  801a6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6f:	48 98                	cltq   
  801a71:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a79:	8b 40 04             	mov    0x4(%rax),%eax
  801a7c:	8d 50 01             	lea    0x1(%rax),%edx
  801a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a83:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a93:	0f 82 64 ff ff ff    	jb     8019fd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a9d:	c9                   	leaveq 
  801a9e:	c3                   	retq   

0000000000801a9f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a9f:	55                   	push   %rbp
  801aa0:	48 89 e5             	mov    %rsp,%rbp
  801aa3:	48 83 ec 20          	sub    $0x20,%rsp
  801aa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801aab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab3:	48 89 c7             	mov    %rax,%rdi
  801ab6:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  801abd:	00 00 00 
  801ac0:	ff d0                	callq  *%rax
  801ac2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801ac6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aca:	48 be 8e 37 80 00 00 	movabs $0x80378e,%rsi
  801ad1:	00 00 00 
  801ad4:	48 89 c7             	mov    %rax,%rdi
  801ad7:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  801ade:	00 00 00 
  801ae1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae7:	8b 50 04             	mov    0x4(%rax),%edx
  801aea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aee:	8b 00                	mov    (%rax),%eax
  801af0:	29 c2                	sub    %eax,%edx
  801af2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b00:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b07:	00 00 00 
	stat->st_dev = &devpipe;
  801b0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b0e:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b15:	00 00 00 
  801b18:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b24:	c9                   	leaveq 
  801b25:	c3                   	retq   

0000000000801b26 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b26:	55                   	push   %rbp
  801b27:	48 89 e5             	mov    %rsp,%rbp
  801b2a:	48 83 ec 10          	sub    $0x10,%rsp
  801b2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b36:	48 89 c6             	mov    %rax,%rsi
  801b39:	bf 00 00 00 00       	mov    $0x0,%edi
  801b3e:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b4e:	48 89 c7             	mov    %rax,%rdi
  801b51:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  801b58:	00 00 00 
  801b5b:	ff d0                	callq  *%rax
  801b5d:	48 89 c6             	mov    %rax,%rsi
  801b60:	bf 00 00 00 00       	mov    $0x0,%edi
  801b65:	48 b8 9f 03 80 00 00 	movabs $0x80039f,%rax
  801b6c:	00 00 00 
  801b6f:	ff d0                	callq  *%rax
}
  801b71:	c9                   	leaveq 
  801b72:	c3                   	retq   

0000000000801b73 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b73:	55                   	push   %rbp
  801b74:	48 89 e5             	mov    %rsp,%rbp
  801b77:	48 83 ec 20          	sub    $0x20,%rsp
  801b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b81:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b84:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b88:	be 01 00 00 00       	mov    $0x1,%esi
  801b8d:	48 89 c7             	mov    %rax,%rdi
  801b90:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	callq  *%rax
}
  801b9c:	c9                   	leaveq 
  801b9d:	c3                   	retq   

0000000000801b9e <getchar>:

int
getchar(void)
{
  801b9e:	55                   	push   %rbp
  801b9f:	48 89 e5             	mov    %rsp,%rbp
  801ba2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ba6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801baa:	ba 01 00 00 00       	mov    $0x1,%edx
  801baf:	48 89 c6             	mov    %rax,%rsi
  801bb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb7:	48 b8 79 0a 80 00 00 	movabs $0x800a79,%rax
  801bbe:	00 00 00 
  801bc1:	ff d0                	callq  *%rax
  801bc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bca:	79 05                	jns    801bd1 <getchar+0x33>
		return r;
  801bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcf:	eb 14                	jmp    801be5 <getchar+0x47>
	if (r < 1)
  801bd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd5:	7f 07                	jg     801bde <getchar+0x40>
		return -E_EOF;
  801bd7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801bdc:	eb 07                	jmp    801be5 <getchar+0x47>
	return c;
  801bde:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801be2:	0f b6 c0             	movzbl %al,%eax
}
  801be5:	c9                   	leaveq 
  801be6:	c3                   	retq   

0000000000801be7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801be7:	55                   	push   %rbp
  801be8:	48 89 e5             	mov    %rsp,%rbp
  801beb:	48 83 ec 20          	sub    $0x20,%rsp
  801bef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bf2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bf9:	48 89 d6             	mov    %rdx,%rsi
  801bfc:	89 c7                	mov    %eax,%edi
  801bfe:	48 b8 47 06 80 00 00 	movabs $0x800647,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
  801c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c11:	79 05                	jns    801c18 <iscons+0x31>
		return r;
  801c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c16:	eb 1a                	jmp    801c32 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c1c:	8b 10                	mov    (%rax),%edx
  801c1e:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c25:	00 00 00 
  801c28:	8b 00                	mov    (%rax),%eax
  801c2a:	39 c2                	cmp    %eax,%edx
  801c2c:	0f 94 c0             	sete   %al
  801c2f:	0f b6 c0             	movzbl %al,%eax
}
  801c32:	c9                   	leaveq 
  801c33:	c3                   	retq   

0000000000801c34 <opencons>:

int
opencons(void)
{
  801c34:	55                   	push   %rbp
  801c35:	48 89 e5             	mov    %rsp,%rbp
  801c38:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c3c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c40:	48 89 c7             	mov    %rax,%rdi
  801c43:	48 b8 af 05 80 00 00 	movabs $0x8005af,%rax
  801c4a:	00 00 00 
  801c4d:	ff d0                	callq  *%rax
  801c4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c56:	79 05                	jns    801c5d <opencons+0x29>
		return r;
  801c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5b:	eb 5b                	jmp    801cb8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c61:	ba 07 04 00 00       	mov    $0x407,%edx
  801c66:	48 89 c6             	mov    %rax,%rsi
  801c69:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6e:	48 b8 f4 02 80 00 00 	movabs $0x8002f4,%rax
  801c75:	00 00 00 
  801c78:	ff d0                	callq  *%rax
  801c7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c81:	79 05                	jns    801c88 <opencons+0x54>
		return r;
  801c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c86:	eb 30                	jmp    801cb8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8c:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c93:	00 00 00 
  801c96:	8b 12                	mov    (%rdx),%edx
  801c98:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca9:	48 89 c7             	mov    %rax,%rdi
  801cac:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  801cb3:	00 00 00 
  801cb6:	ff d0                	callq  *%rax
}
  801cb8:	c9                   	leaveq 
  801cb9:	c3                   	retq   

0000000000801cba <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cba:	55                   	push   %rbp
  801cbb:	48 89 e5             	mov    %rsp,%rbp
  801cbe:	48 83 ec 30          	sub    $0x30,%rsp
  801cc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cc6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cd3:	75 07                	jne    801cdc <devcons_read+0x22>
		return 0;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cda:	eb 4b                	jmp    801d27 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801cdc:	eb 0c                	jmp    801cea <devcons_read+0x30>
		sys_yield();
  801cde:	48 b8 b6 02 80 00 00 	movabs $0x8002b6,%rax
  801ce5:	00 00 00 
  801ce8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cea:	48 b8 f6 01 80 00 00 	movabs $0x8001f6,%rax
  801cf1:	00 00 00 
  801cf4:	ff d0                	callq  *%rax
  801cf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cfd:	74 df                	je     801cde <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d03:	79 05                	jns    801d0a <devcons_read+0x50>
		return c;
  801d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d08:	eb 1d                	jmp    801d27 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d0a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d0e:	75 07                	jne    801d17 <devcons_read+0x5d>
		return 0;
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
  801d15:	eb 10                	jmp    801d27 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1a:	89 c2                	mov    %eax,%edx
  801d1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d20:	88 10                	mov    %dl,(%rax)
	return 1;
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d27:	c9                   	leaveq 
  801d28:	c3                   	retq   

0000000000801d29 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d29:	55                   	push   %rbp
  801d2a:	48 89 e5             	mov    %rsp,%rbp
  801d2d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d34:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d3b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d42:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d50:	eb 76                	jmp    801dc8 <devcons_write+0x9f>
		m = n - tot;
  801d52:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d59:	89 c2                	mov    %eax,%edx
  801d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5e:	29 c2                	sub    %eax,%edx
  801d60:	89 d0                	mov    %edx,%eax
  801d62:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d68:	83 f8 7f             	cmp    $0x7f,%eax
  801d6b:	76 07                	jbe    801d74 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d6d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d77:	48 63 d0             	movslq %eax,%rdx
  801d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7d:	48 63 c8             	movslq %eax,%rcx
  801d80:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d87:	48 01 c1             	add    %rax,%rcx
  801d8a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d91:	48 89 ce             	mov    %rcx,%rsi
  801d94:	48 89 c7             	mov    %rax,%rdi
  801d97:	48 b8 4b 2f 80 00 00 	movabs $0x802f4b,%rax
  801d9e:	00 00 00 
  801da1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801da3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da6:	48 63 d0             	movslq %eax,%rdx
  801da9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801db0:	48 89 d6             	mov    %rdx,%rsi
  801db3:	48 89 c7             	mov    %rax,%rdi
  801db6:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  801dbd:	00 00 00 
  801dc0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc5:	01 45 fc             	add    %eax,-0x4(%rbp)
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	48 98                	cltq   
  801dcd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dd4:	0f 82 78 ff ff ff    	jb     801d52 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 08          	sub    $0x8,%rsp
  801de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df0:	c9                   	leaveq 
  801df1:	c3                   	retq   

0000000000801df2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801df2:	55                   	push   %rbp
  801df3:	48 89 e5             	mov    %rsp,%rbp
  801df6:	48 83 ec 10          	sub    $0x10,%rsp
  801dfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e06:	48 be 9a 37 80 00 00 	movabs $0x80379a,%rsi
  801e0d:	00 00 00 
  801e10:	48 89 c7             	mov    %rax,%rdi
  801e13:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  801e1a:	00 00 00 
  801e1d:	ff d0                	callq  *%rax
	return 0;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	c9                   	leaveq 
  801e25:	c3                   	retq   

0000000000801e26 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e26:	55                   	push   %rbp
  801e27:	48 89 e5             	mov    %rsp,%rbp
  801e2a:	53                   	push   %rbx
  801e2b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e32:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e39:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e3f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e46:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e4d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e54:	84 c0                	test   %al,%al
  801e56:	74 23                	je     801e7b <_panic+0x55>
  801e58:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e5f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e63:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e67:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e6b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e6f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e73:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e77:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e7b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e82:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e89:	00 00 00 
  801e8c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e93:	00 00 00 
  801e96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e9a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801ea1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801ea8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801eaf:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801eb6:	00 00 00 
  801eb9:	48 8b 18             	mov    (%rax),%rbx
  801ebc:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
  801ec8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801ece:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ed5:	41 89 c8             	mov    %ecx,%r8d
  801ed8:	48 89 d1             	mov    %rdx,%rcx
  801edb:	48 89 da             	mov    %rbx,%rdx
  801ede:	89 c6                	mov    %eax,%esi
  801ee0:	48 bf a8 37 80 00 00 	movabs $0x8037a8,%rdi
  801ee7:	00 00 00 
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
  801eef:	49 b9 5f 20 80 00 00 	movabs $0x80205f,%r9
  801ef6:	00 00 00 
  801ef9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801efc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f03:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f0a:	48 89 d6             	mov    %rdx,%rsi
  801f0d:	48 89 c7             	mov    %rax,%rdi
  801f10:	48 b8 b3 1f 80 00 00 	movabs $0x801fb3,%rax
  801f17:	00 00 00 
  801f1a:	ff d0                	callq  *%rax
	cprintf("\n");
  801f1c:	48 bf cb 37 80 00 00 	movabs $0x8037cb,%rdi
  801f23:	00 00 00 
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2b:	48 ba 5f 20 80 00 00 	movabs $0x80205f,%rdx
  801f32:	00 00 00 
  801f35:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f37:	cc                   	int3   
  801f38:	eb fd                	jmp    801f37 <_panic+0x111>

0000000000801f3a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f3a:	55                   	push   %rbp
  801f3b:	48 89 e5             	mov    %rsp,%rbp
  801f3e:	48 83 ec 10          	sub    $0x10,%rsp
  801f42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4d:	8b 00                	mov    (%rax),%eax
  801f4f:	8d 48 01             	lea    0x1(%rax),%ecx
  801f52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f56:	89 0a                	mov    %ecx,(%rdx)
  801f58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f5b:	89 d1                	mov    %edx,%ecx
  801f5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f61:	48 98                	cltq   
  801f63:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6b:	8b 00                	mov    (%rax),%eax
  801f6d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f72:	75 2c                	jne    801fa0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f78:	8b 00                	mov    (%rax),%eax
  801f7a:	48 98                	cltq   
  801f7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f80:	48 83 c2 08          	add    $0x8,%rdx
  801f84:	48 89 c6             	mov    %rax,%rsi
  801f87:	48 89 d7             	mov    %rdx,%rdi
  801f8a:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	callq  *%rax
        b->idx = 0;
  801f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa4:	8b 40 04             	mov    0x4(%rax),%eax
  801fa7:	8d 50 01             	lea    0x1(%rax),%edx
  801faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fae:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fb1:	c9                   	leaveq 
  801fb2:	c3                   	retq   

0000000000801fb3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fb3:	55                   	push   %rbp
  801fb4:	48 89 e5             	mov    %rsp,%rbp
  801fb7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fbe:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fc5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fcc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fd3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fda:	48 8b 0a             	mov    (%rdx),%rcx
  801fdd:	48 89 08             	mov    %rcx,(%rax)
  801fe0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fe4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fe8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801fec:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801ff0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801ff7:	00 00 00 
    b.cnt = 0;
  801ffa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802001:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802004:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80200b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802012:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802019:	48 89 c6             	mov    %rax,%rsi
  80201c:	48 bf 3a 1f 80 00 00 	movabs $0x801f3a,%rdi
  802023:	00 00 00 
  802026:	48 b8 12 24 80 00 00 	movabs $0x802412,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802032:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802038:	48 98                	cltq   
  80203a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802041:	48 83 c2 08          	add    $0x8,%rdx
  802045:	48 89 c6             	mov    %rax,%rsi
  802048:	48 89 d7             	mov    %rdx,%rdi
  80204b:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  802052:	00 00 00 
  802055:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802057:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80205d:	c9                   	leaveq 
  80205e:	c3                   	retq   

000000000080205f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80205f:	55                   	push   %rbp
  802060:	48 89 e5             	mov    %rsp,%rbp
  802063:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80206a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802071:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802078:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80207f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802086:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80208d:	84 c0                	test   %al,%al
  80208f:	74 20                	je     8020b1 <cprintf+0x52>
  802091:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802095:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802099:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80209d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8020a1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8020a5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020a9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020ad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020b1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020b8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020bf:	00 00 00 
  8020c2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020c9:	00 00 00 
  8020cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020d7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020de:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020e5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020ec:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020f3:	48 8b 0a             	mov    (%rdx),%rcx
  8020f6:	48 89 08             	mov    %rcx,(%rax)
  8020f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8020fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802101:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802105:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802109:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802110:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802117:	48 89 d6             	mov    %rdx,%rsi
  80211a:	48 89 c7             	mov    %rax,%rdi
  80211d:	48 b8 b3 1f 80 00 00 	movabs $0x801fb3,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
  802129:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80212f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802135:	c9                   	leaveq 
  802136:	c3                   	retq   

0000000000802137 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802137:	55                   	push   %rbp
  802138:	48 89 e5             	mov    %rsp,%rbp
  80213b:	53                   	push   %rbx
  80213c:	48 83 ec 38          	sub    $0x38,%rsp
  802140:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802144:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802148:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80214c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80214f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802153:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802157:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80215a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80215e:	77 3b                	ja     80219b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802160:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802163:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802167:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80216a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216e:	ba 00 00 00 00       	mov    $0x0,%edx
  802173:	48 f7 f3             	div    %rbx
  802176:	48 89 c2             	mov    %rax,%rdx
  802179:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80217c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80217f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802183:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802187:	41 89 f9             	mov    %edi,%r9d
  80218a:	48 89 c7             	mov    %rax,%rdi
  80218d:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  802194:	00 00 00 
  802197:	ff d0                	callq  *%rax
  802199:	eb 1e                	jmp    8021b9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80219b:	eb 12                	jmp    8021af <printnum+0x78>
			putch(padc, putdat);
  80219d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021a1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	48 89 ce             	mov    %rcx,%rsi
  8021ab:	89 d7                	mov    %edx,%edi
  8021ad:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021af:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021b7:	7f e4                	jg     80219d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021b9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c5:	48 f7 f1             	div    %rcx
  8021c8:	48 89 d0             	mov    %rdx,%rax
  8021cb:	48 ba d0 39 80 00 00 	movabs $0x8039d0,%rdx
  8021d2:	00 00 00 
  8021d5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021d9:	0f be d0             	movsbl %al,%edx
  8021dc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e4:	48 89 ce             	mov    %rcx,%rsi
  8021e7:	89 d7                	mov    %edx,%edi
  8021e9:	ff d0                	callq  *%rax
}
  8021eb:	48 83 c4 38          	add    $0x38,%rsp
  8021ef:	5b                   	pop    %rbx
  8021f0:	5d                   	pop    %rbp
  8021f1:	c3                   	retq   

00000000008021f2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021f2:	55                   	push   %rbp
  8021f3:	48 89 e5             	mov    %rsp,%rbp
  8021f6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8021fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021fe:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  802201:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802205:	7e 52                	jle    802259 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220b:	8b 00                	mov    (%rax),%eax
  80220d:	83 f8 30             	cmp    $0x30,%eax
  802210:	73 24                	jae    802236 <getuint+0x44>
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80221a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221e:	8b 00                	mov    (%rax),%eax
  802220:	89 c0                	mov    %eax,%eax
  802222:	48 01 d0             	add    %rdx,%rax
  802225:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802229:	8b 12                	mov    (%rdx),%edx
  80222b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80222e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802232:	89 0a                	mov    %ecx,(%rdx)
  802234:	eb 17                	jmp    80224d <getuint+0x5b>
  802236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80223e:	48 89 d0             	mov    %rdx,%rax
  802241:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802245:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802249:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80224d:	48 8b 00             	mov    (%rax),%rax
  802250:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802254:	e9 a3 00 00 00       	jmpq   8022fc <getuint+0x10a>
	else if (lflag)
  802259:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80225d:	74 4f                	je     8022ae <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80225f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802263:	8b 00                	mov    (%rax),%eax
  802265:	83 f8 30             	cmp    $0x30,%eax
  802268:	73 24                	jae    80228e <getuint+0x9c>
  80226a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802276:	8b 00                	mov    (%rax),%eax
  802278:	89 c0                	mov    %eax,%eax
  80227a:	48 01 d0             	add    %rdx,%rax
  80227d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802281:	8b 12                	mov    (%rdx),%edx
  802283:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802286:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80228a:	89 0a                	mov    %ecx,(%rdx)
  80228c:	eb 17                	jmp    8022a5 <getuint+0xb3>
  80228e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802292:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802296:	48 89 d0             	mov    %rdx,%rax
  802299:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80229d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022a5:	48 8b 00             	mov    (%rax),%rax
  8022a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022ac:	eb 4e                	jmp    8022fc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b2:	8b 00                	mov    (%rax),%eax
  8022b4:	83 f8 30             	cmp    $0x30,%eax
  8022b7:	73 24                	jae    8022dd <getuint+0xeb>
  8022b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c5:	8b 00                	mov    (%rax),%eax
  8022c7:	89 c0                	mov    %eax,%eax
  8022c9:	48 01 d0             	add    %rdx,%rax
  8022cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022d0:	8b 12                	mov    (%rdx),%edx
  8022d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022d9:	89 0a                	mov    %ecx,(%rdx)
  8022db:	eb 17                	jmp    8022f4 <getuint+0x102>
  8022dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022e5:	48 89 d0             	mov    %rdx,%rax
  8022e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022f4:	8b 00                	mov    (%rax),%eax
  8022f6:	89 c0                	mov    %eax,%eax
  8022f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8022fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802300:	c9                   	leaveq 
  802301:	c3                   	retq   

0000000000802302 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802302:	55                   	push   %rbp
  802303:	48 89 e5             	mov    %rsp,%rbp
  802306:	48 83 ec 1c          	sub    $0x1c,%rsp
  80230a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80230e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802311:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802315:	7e 52                	jle    802369 <getint+0x67>
		x=va_arg(*ap, long long);
  802317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231b:	8b 00                	mov    (%rax),%eax
  80231d:	83 f8 30             	cmp    $0x30,%eax
  802320:	73 24                	jae    802346 <getint+0x44>
  802322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802326:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80232a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232e:	8b 00                	mov    (%rax),%eax
  802330:	89 c0                	mov    %eax,%eax
  802332:	48 01 d0             	add    %rdx,%rax
  802335:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802339:	8b 12                	mov    (%rdx),%edx
  80233b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80233e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802342:	89 0a                	mov    %ecx,(%rdx)
  802344:	eb 17                	jmp    80235d <getint+0x5b>
  802346:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80234e:	48 89 d0             	mov    %rdx,%rax
  802351:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802355:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802359:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80235d:	48 8b 00             	mov    (%rax),%rax
  802360:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802364:	e9 a3 00 00 00       	jmpq   80240c <getint+0x10a>
	else if (lflag)
  802369:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80236d:	74 4f                	je     8023be <getint+0xbc>
		x=va_arg(*ap, long);
  80236f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802373:	8b 00                	mov    (%rax),%eax
  802375:	83 f8 30             	cmp    $0x30,%eax
  802378:	73 24                	jae    80239e <getint+0x9c>
  80237a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802386:	8b 00                	mov    (%rax),%eax
  802388:	89 c0                	mov    %eax,%eax
  80238a:	48 01 d0             	add    %rdx,%rax
  80238d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802391:	8b 12                	mov    (%rdx),%edx
  802393:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802396:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239a:	89 0a                	mov    %ecx,(%rdx)
  80239c:	eb 17                	jmp    8023b5 <getint+0xb3>
  80239e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023a6:	48 89 d0             	mov    %rdx,%rax
  8023a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023b5:	48 8b 00             	mov    (%rax),%rax
  8023b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023bc:	eb 4e                	jmp    80240c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c2:	8b 00                	mov    (%rax),%eax
  8023c4:	83 f8 30             	cmp    $0x30,%eax
  8023c7:	73 24                	jae    8023ed <getint+0xeb>
  8023c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d5:	8b 00                	mov    (%rax),%eax
  8023d7:	89 c0                	mov    %eax,%eax
  8023d9:	48 01 d0             	add    %rdx,%rax
  8023dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023e0:	8b 12                	mov    (%rdx),%edx
  8023e2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023e9:	89 0a                	mov    %ecx,(%rdx)
  8023eb:	eb 17                	jmp    802404 <getint+0x102>
  8023ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023f5:	48 89 d0             	mov    %rdx,%rax
  8023f8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802400:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802404:	8b 00                	mov    (%rax),%eax
  802406:	48 98                	cltq   
  802408:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80240c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802410:	c9                   	leaveq 
  802411:	c3                   	retq   

0000000000802412 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802412:	55                   	push   %rbp
  802413:	48 89 e5             	mov    %rsp,%rbp
  802416:	41 54                	push   %r12
  802418:	53                   	push   %rbx
  802419:	48 83 ec 60          	sub    $0x60,%rsp
  80241d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802421:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802425:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802429:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80242d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802431:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802435:	48 8b 0a             	mov    (%rdx),%rcx
  802438:	48 89 08             	mov    %rcx,(%rax)
  80243b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80243f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802443:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802447:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80244b:	eb 17                	jmp    802464 <vprintfmt+0x52>
			if (ch == '\0')
  80244d:	85 db                	test   %ebx,%ebx
  80244f:	0f 84 df 04 00 00    	je     802934 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  802455:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802459:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80245d:	48 89 d6             	mov    %rdx,%rsi
  802460:	89 df                	mov    %ebx,%edi
  802462:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802464:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802468:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80246c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802470:	0f b6 00             	movzbl (%rax),%eax
  802473:	0f b6 d8             	movzbl %al,%ebx
  802476:	83 fb 25             	cmp    $0x25,%ebx
  802479:	75 d2                	jne    80244d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80247b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80247f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802486:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80248d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802494:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80249b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80249f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024a3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024a7:	0f b6 00             	movzbl (%rax),%eax
  8024aa:	0f b6 d8             	movzbl %al,%ebx
  8024ad:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024b0:	83 f8 55             	cmp    $0x55,%eax
  8024b3:	0f 87 47 04 00 00    	ja     802900 <vprintfmt+0x4ee>
  8024b9:	89 c0                	mov    %eax,%eax
  8024bb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024c2:	00 
  8024c3:	48 b8 f8 39 80 00 00 	movabs $0x8039f8,%rax
  8024ca:	00 00 00 
  8024cd:	48 01 d0             	add    %rdx,%rax
  8024d0:	48 8b 00             	mov    (%rax),%rax
  8024d3:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024d5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024d9:	eb c0                	jmp    80249b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024db:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024df:	eb ba                	jmp    80249b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024e1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024e8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024eb:	89 d0                	mov    %edx,%eax
  8024ed:	c1 e0 02             	shl    $0x2,%eax
  8024f0:	01 d0                	add    %edx,%eax
  8024f2:	01 c0                	add    %eax,%eax
  8024f4:	01 d8                	add    %ebx,%eax
  8024f6:	83 e8 30             	sub    $0x30,%eax
  8024f9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8024fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802500:	0f b6 00             	movzbl (%rax),%eax
  802503:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802506:	83 fb 2f             	cmp    $0x2f,%ebx
  802509:	7e 0c                	jle    802517 <vprintfmt+0x105>
  80250b:	83 fb 39             	cmp    $0x39,%ebx
  80250e:	7f 07                	jg     802517 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802510:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802515:	eb d1                	jmp    8024e8 <vprintfmt+0xd6>
			goto process_precision;
  802517:	eb 58                	jmp    802571 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802519:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80251c:	83 f8 30             	cmp    $0x30,%eax
  80251f:	73 17                	jae    802538 <vprintfmt+0x126>
  802521:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802525:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802528:	89 c0                	mov    %eax,%eax
  80252a:	48 01 d0             	add    %rdx,%rax
  80252d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802530:	83 c2 08             	add    $0x8,%edx
  802533:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802536:	eb 0f                	jmp    802547 <vprintfmt+0x135>
  802538:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80253c:	48 89 d0             	mov    %rdx,%rax
  80253f:	48 83 c2 08          	add    $0x8,%rdx
  802543:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802547:	8b 00                	mov    (%rax),%eax
  802549:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80254c:	eb 23                	jmp    802571 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80254e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802552:	79 0c                	jns    802560 <vprintfmt+0x14e>
				width = 0;
  802554:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80255b:	e9 3b ff ff ff       	jmpq   80249b <vprintfmt+0x89>
  802560:	e9 36 ff ff ff       	jmpq   80249b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802565:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80256c:	e9 2a ff ff ff       	jmpq   80249b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802571:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802575:	79 12                	jns    802589 <vprintfmt+0x177>
				width = precision, precision = -1;
  802577:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80257a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80257d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802584:	e9 12 ff ff ff       	jmpq   80249b <vprintfmt+0x89>
  802589:	e9 0d ff ff ff       	jmpq   80249b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80258e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802592:	e9 04 ff ff ff       	jmpq   80249b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802597:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80259a:	83 f8 30             	cmp    $0x30,%eax
  80259d:	73 17                	jae    8025b6 <vprintfmt+0x1a4>
  80259f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a6:	89 c0                	mov    %eax,%eax
  8025a8:	48 01 d0             	add    %rdx,%rax
  8025ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025ae:	83 c2 08             	add    $0x8,%edx
  8025b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025b4:	eb 0f                	jmp    8025c5 <vprintfmt+0x1b3>
  8025b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025ba:	48 89 d0             	mov    %rdx,%rax
  8025bd:	48 83 c2 08          	add    $0x8,%rdx
  8025c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025c5:	8b 10                	mov    (%rax),%edx
  8025c7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025cf:	48 89 ce             	mov    %rcx,%rsi
  8025d2:	89 d7                	mov    %edx,%edi
  8025d4:	ff d0                	callq  *%rax
			break;
  8025d6:	e9 53 03 00 00       	jmpq   80292e <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025de:	83 f8 30             	cmp    $0x30,%eax
  8025e1:	73 17                	jae    8025fa <vprintfmt+0x1e8>
  8025e3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025ea:	89 c0                	mov    %eax,%eax
  8025ec:	48 01 d0             	add    %rdx,%rax
  8025ef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025f2:	83 c2 08             	add    $0x8,%edx
  8025f5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025f8:	eb 0f                	jmp    802609 <vprintfmt+0x1f7>
  8025fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025fe:	48 89 d0             	mov    %rdx,%rax
  802601:	48 83 c2 08          	add    $0x8,%rdx
  802605:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802609:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80260b:	85 db                	test   %ebx,%ebx
  80260d:	79 02                	jns    802611 <vprintfmt+0x1ff>
				err = -err;
  80260f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802611:	83 fb 15             	cmp    $0x15,%ebx
  802614:	7f 16                	jg     80262c <vprintfmt+0x21a>
  802616:	48 b8 20 39 80 00 00 	movabs $0x803920,%rax
  80261d:	00 00 00 
  802620:	48 63 d3             	movslq %ebx,%rdx
  802623:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802627:	4d 85 e4             	test   %r12,%r12
  80262a:	75 2e                	jne    80265a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80262c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802630:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802634:	89 d9                	mov    %ebx,%ecx
  802636:	48 ba e1 39 80 00 00 	movabs $0x8039e1,%rdx
  80263d:	00 00 00 
  802640:	48 89 c7             	mov    %rax,%rdi
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	49 b8 3d 29 80 00 00 	movabs $0x80293d,%r8
  80264f:	00 00 00 
  802652:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802655:	e9 d4 02 00 00       	jmpq   80292e <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80265a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80265e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802662:	4c 89 e1             	mov    %r12,%rcx
  802665:	48 ba ea 39 80 00 00 	movabs $0x8039ea,%rdx
  80266c:	00 00 00 
  80266f:	48 89 c7             	mov    %rax,%rdi
  802672:	b8 00 00 00 00       	mov    $0x0,%eax
  802677:	49 b8 3d 29 80 00 00 	movabs $0x80293d,%r8
  80267e:	00 00 00 
  802681:	41 ff d0             	callq  *%r8
			break;
  802684:	e9 a5 02 00 00       	jmpq   80292e <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802689:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80268c:	83 f8 30             	cmp    $0x30,%eax
  80268f:	73 17                	jae    8026a8 <vprintfmt+0x296>
  802691:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802695:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802698:	89 c0                	mov    %eax,%eax
  80269a:	48 01 d0             	add    %rdx,%rax
  80269d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8026a0:	83 c2 08             	add    $0x8,%edx
  8026a3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8026a6:	eb 0f                	jmp    8026b7 <vprintfmt+0x2a5>
  8026a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026ac:	48 89 d0             	mov    %rdx,%rax
  8026af:	48 83 c2 08          	add    $0x8,%rdx
  8026b3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026b7:	4c 8b 20             	mov    (%rax),%r12
  8026ba:	4d 85 e4             	test   %r12,%r12
  8026bd:	75 0a                	jne    8026c9 <vprintfmt+0x2b7>
				p = "(null)";
  8026bf:	49 bc ed 39 80 00 00 	movabs $0x8039ed,%r12
  8026c6:	00 00 00 
			if (width > 0 && padc != '-')
  8026c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026cd:	7e 3f                	jle    80270e <vprintfmt+0x2fc>
  8026cf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026d3:	74 39                	je     80270e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026d5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026d8:	48 98                	cltq   
  8026da:	48 89 c6             	mov    %rax,%rsi
  8026dd:	4c 89 e7             	mov    %r12,%rdi
  8026e0:	48 b8 e9 2b 80 00 00 	movabs $0x802be9,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	callq  *%rax
  8026ec:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026ef:	eb 17                	jmp    802708 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026f1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8026f5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8026f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026fd:	48 89 ce             	mov    %rcx,%rsi
  802700:	89 d7                	mov    %edx,%edi
  802702:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802704:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802708:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80270c:	7f e3                	jg     8026f1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80270e:	eb 37                	jmp    802747 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802710:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802714:	74 1e                	je     802734 <vprintfmt+0x322>
  802716:	83 fb 1f             	cmp    $0x1f,%ebx
  802719:	7e 05                	jle    802720 <vprintfmt+0x30e>
  80271b:	83 fb 7e             	cmp    $0x7e,%ebx
  80271e:	7e 14                	jle    802734 <vprintfmt+0x322>
					putch('?', putdat);
  802720:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802724:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802728:	48 89 d6             	mov    %rdx,%rsi
  80272b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802730:	ff d0                	callq  *%rax
  802732:	eb 0f                	jmp    802743 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802734:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802738:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80273c:	48 89 d6             	mov    %rdx,%rsi
  80273f:	89 df                	mov    %ebx,%edi
  802741:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802743:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802747:	4c 89 e0             	mov    %r12,%rax
  80274a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80274e:	0f b6 00             	movzbl (%rax),%eax
  802751:	0f be d8             	movsbl %al,%ebx
  802754:	85 db                	test   %ebx,%ebx
  802756:	74 10                	je     802768 <vprintfmt+0x356>
  802758:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80275c:	78 b2                	js     802710 <vprintfmt+0x2fe>
  80275e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802762:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802766:	79 a8                	jns    802710 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802768:	eb 16                	jmp    802780 <vprintfmt+0x36e>
				putch(' ', putdat);
  80276a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80276e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802772:	48 89 d6             	mov    %rdx,%rsi
  802775:	bf 20 00 00 00       	mov    $0x20,%edi
  80277a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80277c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802780:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802784:	7f e4                	jg     80276a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802786:	e9 a3 01 00 00       	jmpq   80292e <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80278b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80278f:	be 03 00 00 00       	mov    $0x3,%esi
  802794:	48 89 c7             	mov    %rax,%rdi
  802797:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
  8027a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8027a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ab:	48 85 c0             	test   %rax,%rax
  8027ae:	79 1d                	jns    8027cd <vprintfmt+0x3bb>
				putch('-', putdat);
  8027b0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027b8:	48 89 d6             	mov    %rdx,%rsi
  8027bb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027c0:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c6:	48 f7 d8             	neg    %rax
  8027c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027cd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027d4:	e9 e8 00 00 00       	jmpq   8028c1 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027d9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027dd:	be 03 00 00 00       	mov    $0x3,%esi
  8027e2:	48 89 c7             	mov    %rax,%rdi
  8027e5:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  8027ec:	00 00 00 
  8027ef:	ff d0                	callq  *%rax
  8027f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8027f5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027fc:	e9 c0 00 00 00       	jmpq   8028c1 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802801:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802805:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802809:	48 89 d6             	mov    %rdx,%rsi
  80280c:	bf 58 00 00 00       	mov    $0x58,%edi
  802811:	ff d0                	callq  *%rax
			putch('X', putdat);
  802813:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802817:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80281b:	48 89 d6             	mov    %rdx,%rsi
  80281e:	bf 58 00 00 00       	mov    $0x58,%edi
  802823:	ff d0                	callq  *%rax
			putch('X', putdat);
  802825:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802829:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80282d:	48 89 d6             	mov    %rdx,%rsi
  802830:	bf 58 00 00 00       	mov    $0x58,%edi
  802835:	ff d0                	callq  *%rax
			break;
  802837:	e9 f2 00 00 00       	jmpq   80292e <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  80283c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802840:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802844:	48 89 d6             	mov    %rdx,%rsi
  802847:	bf 30 00 00 00       	mov    $0x30,%edi
  80284c:	ff d0                	callq  *%rax
			putch('x', putdat);
  80284e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802852:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802856:	48 89 d6             	mov    %rdx,%rsi
  802859:	bf 78 00 00 00       	mov    $0x78,%edi
  80285e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802860:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802863:	83 f8 30             	cmp    $0x30,%eax
  802866:	73 17                	jae    80287f <vprintfmt+0x46d>
  802868:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80286c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80286f:	89 c0                	mov    %eax,%eax
  802871:	48 01 d0             	add    %rdx,%rax
  802874:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802877:	83 c2 08             	add    $0x8,%edx
  80287a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80287d:	eb 0f                	jmp    80288e <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80287f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802883:	48 89 d0             	mov    %rdx,%rax
  802886:	48 83 c2 08          	add    $0x8,%rdx
  80288a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80288e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802891:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802895:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80289c:	eb 23                	jmp    8028c1 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80289e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028a2:	be 03 00 00 00       	mov    $0x3,%esi
  8028a7:	48 89 c7             	mov    %rax,%rdi
  8028aa:	48 b8 f2 21 80 00 00 	movabs $0x8021f2,%rax
  8028b1:	00 00 00 
  8028b4:	ff d0                	callq  *%rax
  8028b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028ba:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028c1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028c6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028c9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028d0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028d8:	45 89 c1             	mov    %r8d,%r9d
  8028db:	41 89 f8             	mov    %edi,%r8d
  8028de:	48 89 c7             	mov    %rax,%rdi
  8028e1:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  8028e8:	00 00 00 
  8028eb:	ff d0                	callq  *%rax
			break;
  8028ed:	eb 3f                	jmp    80292e <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028f7:	48 89 d6             	mov    %rdx,%rsi
  8028fa:	89 df                	mov    %ebx,%edi
  8028fc:	ff d0                	callq  *%rax
			break;
  8028fe:	eb 2e                	jmp    80292e <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802900:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802904:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802908:	48 89 d6             	mov    %rdx,%rsi
  80290b:	bf 25 00 00 00       	mov    $0x25,%edi
  802910:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802912:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802917:	eb 05                	jmp    80291e <vprintfmt+0x50c>
  802919:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80291e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802922:	48 83 e8 01          	sub    $0x1,%rax
  802926:	0f b6 00             	movzbl (%rax),%eax
  802929:	3c 25                	cmp    $0x25,%al
  80292b:	75 ec                	jne    802919 <vprintfmt+0x507>
				/* do nothing */;
			break;
  80292d:	90                   	nop
		}
	}
  80292e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80292f:	e9 30 fb ff ff       	jmpq   802464 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802934:	48 83 c4 60          	add    $0x60,%rsp
  802938:	5b                   	pop    %rbx
  802939:	41 5c                	pop    %r12
  80293b:	5d                   	pop    %rbp
  80293c:	c3                   	retq   

000000000080293d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80293d:	55                   	push   %rbp
  80293e:	48 89 e5             	mov    %rsp,%rbp
  802941:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802948:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80294f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802956:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80295d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802964:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80296b:	84 c0                	test   %al,%al
  80296d:	74 20                	je     80298f <printfmt+0x52>
  80296f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802973:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802977:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80297b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80297f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802983:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802987:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80298b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80298f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802996:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80299d:	00 00 00 
  8029a0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8029a7:	00 00 00 
  8029aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029ae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029b5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029bc:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029c3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029ca:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029d1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029d8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029df:	48 89 c7             	mov    %rax,%rdi
  8029e2:	48 b8 12 24 80 00 00 	movabs $0x802412,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029ee:	c9                   	leaveq 
  8029ef:	c3                   	retq   

00000000008029f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029f0:	55                   	push   %rbp
  8029f1:	48 89 e5             	mov    %rsp,%rbp
  8029f4:	48 83 ec 10          	sub    $0x10,%rsp
  8029f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8029ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a03:	8b 40 10             	mov    0x10(%rax),%eax
  802a06:	8d 50 01             	lea    0x1(%rax),%edx
  802a09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a14:	48 8b 10             	mov    (%rax),%rdx
  802a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a1f:	48 39 c2             	cmp    %rax,%rdx
  802a22:	73 17                	jae    802a3b <sprintputch+0x4b>
		*b->buf++ = ch;
  802a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a28:	48 8b 00             	mov    (%rax),%rax
  802a2b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a33:	48 89 0a             	mov    %rcx,(%rdx)
  802a36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a39:	88 10                	mov    %dl,(%rax)
}
  802a3b:	c9                   	leaveq 
  802a3c:	c3                   	retq   

0000000000802a3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a3d:	55                   	push   %rbp
  802a3e:	48 89 e5             	mov    %rsp,%rbp
  802a41:	48 83 ec 50          	sub    $0x50,%rsp
  802a45:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a49:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a4c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a50:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a54:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a58:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a5c:	48 8b 0a             	mov    (%rdx),%rcx
  802a5f:	48 89 08             	mov    %rcx,(%rax)
  802a62:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a66:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a6a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a6e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a76:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a7a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a7d:	48 98                	cltq   
  802a7f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a87:	48 01 d0             	add    %rdx,%rax
  802a8a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a8e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a95:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a9a:	74 06                	je     802aa2 <vsnprintf+0x65>
  802a9c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802aa0:	7f 07                	jg     802aa9 <vsnprintf+0x6c>
		return -E_INVAL;
  802aa2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa7:	eb 2f                	jmp    802ad8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802aa9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802aad:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802ab1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ab5:	48 89 c6             	mov    %rax,%rsi
  802ab8:	48 bf f0 29 80 00 00 	movabs $0x8029f0,%rdi
  802abf:	00 00 00 
  802ac2:	48 b8 12 24 80 00 00 	movabs $0x802412,%rax
  802ac9:	00 00 00 
  802acc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802ace:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ad2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802ad5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802ad8:	c9                   	leaveq 
  802ad9:	c3                   	retq   

0000000000802ada <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802ada:	55                   	push   %rbp
  802adb:	48 89 e5             	mov    %rsp,%rbp
  802ade:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802ae5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802aec:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802af2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802af9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b00:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b07:	84 c0                	test   %al,%al
  802b09:	74 20                	je     802b2b <snprintf+0x51>
  802b0b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b0f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b13:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b17:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b1b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b1f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b23:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b27:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b2b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b32:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b39:	00 00 00 
  802b3c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b43:	00 00 00 
  802b46:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b4a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b51:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b58:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b5f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b66:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b6d:	48 8b 0a             	mov    (%rdx),%rcx
  802b70:	48 89 08             	mov    %rcx,(%rax)
  802b73:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b77:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b7b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b7f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b83:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b8a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b91:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b97:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b9e:	48 89 c7             	mov    %rax,%rdi
  802ba1:	48 b8 3d 2a 80 00 00 	movabs $0x802a3d,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	callq  *%rax
  802bad:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802bb3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bb9:	c9                   	leaveq 
  802bba:	c3                   	retq   

0000000000802bbb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802bbb:	55                   	push   %rbp
  802bbc:	48 89 e5             	mov    %rsp,%rbp
  802bbf:	48 83 ec 18          	sub    $0x18,%rsp
  802bc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bce:	eb 09                	jmp    802bd9 <strlen+0x1e>
		n++;
  802bd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bd4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdd:	0f b6 00             	movzbl (%rax),%eax
  802be0:	84 c0                	test   %al,%al
  802be2:	75 ec                	jne    802bd0 <strlen+0x15>
		n++;
	return n;
  802be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802be7:	c9                   	leaveq 
  802be8:	c3                   	retq   

0000000000802be9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802be9:	55                   	push   %rbp
  802bea:	48 89 e5             	mov    %rsp,%rbp
  802bed:	48 83 ec 20          	sub    $0x20,%rsp
  802bf1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bf5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c00:	eb 0e                	jmp    802c10 <strnlen+0x27>
		n++;
  802c02:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c06:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c0b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c10:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c15:	74 0b                	je     802c22 <strnlen+0x39>
  802c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1b:	0f b6 00             	movzbl (%rax),%eax
  802c1e:	84 c0                	test   %al,%al
  802c20:	75 e0                	jne    802c02 <strnlen+0x19>
		n++;
	return n;
  802c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c25:	c9                   	leaveq 
  802c26:	c3                   	retq   

0000000000802c27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c27:	55                   	push   %rbp
  802c28:	48 89 e5             	mov    %rsp,%rbp
  802c2b:	48 83 ec 20          	sub    $0x20,%rsp
  802c2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c3f:	90                   	nop
  802c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c44:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c48:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c4c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c50:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c54:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c58:	0f b6 12             	movzbl (%rdx),%edx
  802c5b:	88 10                	mov    %dl,(%rax)
  802c5d:	0f b6 00             	movzbl (%rax),%eax
  802c60:	84 c0                	test   %al,%al
  802c62:	75 dc                	jne    802c40 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c68:	c9                   	leaveq 
  802c69:	c3                   	retq   

0000000000802c6a <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c6a:	55                   	push   %rbp
  802c6b:	48 89 e5             	mov    %rsp,%rbp
  802c6e:	48 83 ec 20          	sub    $0x20,%rsp
  802c72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	48 89 c7             	mov    %rax,%rdi
  802c81:	48 b8 bb 2b 80 00 00 	movabs $0x802bbb,%rax
  802c88:	00 00 00 
  802c8b:	ff d0                	callq  *%rax
  802c8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c93:	48 63 d0             	movslq %eax,%rdx
  802c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9a:	48 01 c2             	add    %rax,%rdx
  802c9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca1:	48 89 c6             	mov    %rax,%rsi
  802ca4:	48 89 d7             	mov    %rdx,%rdi
  802ca7:	48 b8 27 2c 80 00 00 	movabs $0x802c27,%rax
  802cae:	00 00 00 
  802cb1:	ff d0                	callq  *%rax
	return dst;
  802cb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802cb7:	c9                   	leaveq 
  802cb8:	c3                   	retq   

0000000000802cb9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802cb9:	55                   	push   %rbp
  802cba:	48 89 e5             	mov    %rsp,%rbp
  802cbd:	48 83 ec 28          	sub    $0x28,%rsp
  802cc1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cc5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cc9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802ccd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802cd5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802cdc:	00 
  802cdd:	eb 2a                	jmp    802d09 <strncpy+0x50>
		*dst++ = *src;
  802cdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802ce7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ceb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cef:	0f b6 12             	movzbl (%rdx),%edx
  802cf2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802cf4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf8:	0f b6 00             	movzbl (%rax),%eax
  802cfb:	84 c0                	test   %al,%al
  802cfd:	74 05                	je     802d04 <strncpy+0x4b>
			src++;
  802cff:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d04:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d0d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d11:	72 cc                	jb     802cdf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d17:	c9                   	leaveq 
  802d18:	c3                   	retq   

0000000000802d19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d19:	55                   	push   %rbp
  802d1a:	48 89 e5             	mov    %rsp,%rbp
  802d1d:	48 83 ec 28          	sub    $0x28,%rsp
  802d21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d29:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d35:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d3a:	74 3d                	je     802d79 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d3c:	eb 1d                	jmp    802d5b <strlcpy+0x42>
			*dst++ = *src++;
  802d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d42:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d46:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d4a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d4e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d52:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d56:	0f b6 12             	movzbl (%rdx),%edx
  802d59:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d5b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d60:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d65:	74 0b                	je     802d72 <strlcpy+0x59>
  802d67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d6b:	0f b6 00             	movzbl (%rax),%eax
  802d6e:	84 c0                	test   %al,%al
  802d70:	75 cc                	jne    802d3e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d76:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d81:	48 29 c2             	sub    %rax,%rdx
  802d84:	48 89 d0             	mov    %rdx,%rax
}
  802d87:	c9                   	leaveq 
  802d88:	c3                   	retq   

0000000000802d89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d89:	55                   	push   %rbp
  802d8a:	48 89 e5             	mov    %rsp,%rbp
  802d8d:	48 83 ec 10          	sub    $0x10,%rsp
  802d91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d99:	eb 0a                	jmp    802da5 <strcmp+0x1c>
		p++, q++;
  802d9b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802da0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da9:	0f b6 00             	movzbl (%rax),%eax
  802dac:	84 c0                	test   %al,%al
  802dae:	74 12                	je     802dc2 <strcmp+0x39>
  802db0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db4:	0f b6 10             	movzbl (%rax),%edx
  802db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbb:	0f b6 00             	movzbl (%rax),%eax
  802dbe:	38 c2                	cmp    %al,%dl
  802dc0:	74 d9                	je     802d9b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802dc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc6:	0f b6 00             	movzbl (%rax),%eax
  802dc9:	0f b6 d0             	movzbl %al,%edx
  802dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd0:	0f b6 00             	movzbl (%rax),%eax
  802dd3:	0f b6 c0             	movzbl %al,%eax
  802dd6:	29 c2                	sub    %eax,%edx
  802dd8:	89 d0                	mov    %edx,%eax
}
  802dda:	c9                   	leaveq 
  802ddb:	c3                   	retq   

0000000000802ddc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802ddc:	55                   	push   %rbp
  802ddd:	48 89 e5             	mov    %rsp,%rbp
  802de0:	48 83 ec 18          	sub    $0x18,%rsp
  802de4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802de8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802df0:	eb 0f                	jmp    802e01 <strncmp+0x25>
		n--, p++, q++;
  802df2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802df7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dfc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e01:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e06:	74 1d                	je     802e25 <strncmp+0x49>
  802e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0c:	0f b6 00             	movzbl (%rax),%eax
  802e0f:	84 c0                	test   %al,%al
  802e11:	74 12                	je     802e25 <strncmp+0x49>
  802e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e17:	0f b6 10             	movzbl (%rax),%edx
  802e1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1e:	0f b6 00             	movzbl (%rax),%eax
  802e21:	38 c2                	cmp    %al,%dl
  802e23:	74 cd                	je     802df2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e25:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e2a:	75 07                	jne    802e33 <strncmp+0x57>
		return 0;
  802e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e31:	eb 18                	jmp    802e4b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e37:	0f b6 00             	movzbl (%rax),%eax
  802e3a:	0f b6 d0             	movzbl %al,%edx
  802e3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e41:	0f b6 00             	movzbl (%rax),%eax
  802e44:	0f b6 c0             	movzbl %al,%eax
  802e47:	29 c2                	sub    %eax,%edx
  802e49:	89 d0                	mov    %edx,%eax
}
  802e4b:	c9                   	leaveq 
  802e4c:	c3                   	retq   

0000000000802e4d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e4d:	55                   	push   %rbp
  802e4e:	48 89 e5             	mov    %rsp,%rbp
  802e51:	48 83 ec 0c          	sub    $0xc,%rsp
  802e55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e59:	89 f0                	mov    %esi,%eax
  802e5b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e5e:	eb 17                	jmp    802e77 <strchr+0x2a>
		if (*s == c)
  802e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e64:	0f b6 00             	movzbl (%rax),%eax
  802e67:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e6a:	75 06                	jne    802e72 <strchr+0x25>
			return (char *) s;
  802e6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e70:	eb 15                	jmp    802e87 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e72:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7b:	0f b6 00             	movzbl (%rax),%eax
  802e7e:	84 c0                	test   %al,%al
  802e80:	75 de                	jne    802e60 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e87:	c9                   	leaveq 
  802e88:	c3                   	retq   

0000000000802e89 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e89:	55                   	push   %rbp
  802e8a:	48 89 e5             	mov    %rsp,%rbp
  802e8d:	48 83 ec 0c          	sub    $0xc,%rsp
  802e91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e95:	89 f0                	mov    %esi,%eax
  802e97:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e9a:	eb 13                	jmp    802eaf <strfind+0x26>
		if (*s == c)
  802e9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea0:	0f b6 00             	movzbl (%rax),%eax
  802ea3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802ea6:	75 02                	jne    802eaa <strfind+0x21>
			break;
  802ea8:	eb 10                	jmp    802eba <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802eaa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb3:	0f b6 00             	movzbl (%rax),%eax
  802eb6:	84 c0                	test   %al,%al
  802eb8:	75 e2                	jne    802e9c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802eba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ebe:	c9                   	leaveq 
  802ebf:	c3                   	retq   

0000000000802ec0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802ec0:	55                   	push   %rbp
  802ec1:	48 89 e5             	mov    %rsp,%rbp
  802ec4:	48 83 ec 18          	sub    $0x18,%rsp
  802ec8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ecc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ecf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ed3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ed8:	75 06                	jne    802ee0 <memset+0x20>
		return v;
  802eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ede:	eb 69                	jmp    802f49 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee4:	83 e0 03             	and    $0x3,%eax
  802ee7:	48 85 c0             	test   %rax,%rax
  802eea:	75 48                	jne    802f34 <memset+0x74>
  802eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef0:	83 e0 03             	and    $0x3,%eax
  802ef3:	48 85 c0             	test   %rax,%rax
  802ef6:	75 3c                	jne    802f34 <memset+0x74>
		c &= 0xFF;
  802ef8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802eff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f02:	c1 e0 18             	shl    $0x18,%eax
  802f05:	89 c2                	mov    %eax,%edx
  802f07:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f0a:	c1 e0 10             	shl    $0x10,%eax
  802f0d:	09 c2                	or     %eax,%edx
  802f0f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f12:	c1 e0 08             	shl    $0x8,%eax
  802f15:	09 d0                	or     %edx,%eax
  802f17:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1e:	48 c1 e8 02          	shr    $0x2,%rax
  802f22:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f25:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f29:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f2c:	48 89 d7             	mov    %rdx,%rdi
  802f2f:	fc                   	cld    
  802f30:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f32:	eb 11                	jmp    802f45 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f34:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f3b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f3f:	48 89 d7             	mov    %rdx,%rdi
  802f42:	fc                   	cld    
  802f43:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f49:	c9                   	leaveq 
  802f4a:	c3                   	retq   

0000000000802f4b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f4b:	55                   	push   %rbp
  802f4c:	48 89 e5             	mov    %rsp,%rbp
  802f4f:	48 83 ec 28          	sub    $0x28,%rsp
  802f53:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f57:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f5b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f73:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f77:	0f 83 88 00 00 00    	jae    803005 <memmove+0xba>
  802f7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f81:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f85:	48 01 d0             	add    %rdx,%rax
  802f88:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f8c:	76 77                	jbe    803005 <memmove+0xba>
		s += n;
  802f8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f92:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa2:	83 e0 03             	and    $0x3,%eax
  802fa5:	48 85 c0             	test   %rax,%rax
  802fa8:	75 3b                	jne    802fe5 <memmove+0x9a>
  802faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fae:	83 e0 03             	and    $0x3,%eax
  802fb1:	48 85 c0             	test   %rax,%rax
  802fb4:	75 2f                	jne    802fe5 <memmove+0x9a>
  802fb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fba:	83 e0 03             	and    $0x3,%eax
  802fbd:	48 85 c0             	test   %rax,%rax
  802fc0:	75 23                	jne    802fe5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc6:	48 83 e8 04          	sub    $0x4,%rax
  802fca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fce:	48 83 ea 04          	sub    $0x4,%rdx
  802fd2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fd6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fda:	48 89 c7             	mov    %rax,%rdi
  802fdd:	48 89 d6             	mov    %rdx,%rsi
  802fe0:	fd                   	std    
  802fe1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fe3:	eb 1d                	jmp    803002 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802fe5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802ff5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff9:	48 89 d7             	mov    %rdx,%rdi
  802ffc:	48 89 c1             	mov    %rax,%rcx
  802fff:	fd                   	std    
  803000:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803002:	fc                   	cld    
  803003:	eb 57                	jmp    80305c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803009:	83 e0 03             	and    $0x3,%eax
  80300c:	48 85 c0             	test   %rax,%rax
  80300f:	75 36                	jne    803047 <memmove+0xfc>
  803011:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803015:	83 e0 03             	and    $0x3,%eax
  803018:	48 85 c0             	test   %rax,%rax
  80301b:	75 2a                	jne    803047 <memmove+0xfc>
  80301d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803021:	83 e0 03             	and    $0x3,%eax
  803024:	48 85 c0             	test   %rax,%rax
  803027:	75 1e                	jne    803047 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803029:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80302d:	48 c1 e8 02          	shr    $0x2,%rax
  803031:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803034:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803038:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80303c:	48 89 c7             	mov    %rax,%rdi
  80303f:	48 89 d6             	mov    %rdx,%rsi
  803042:	fc                   	cld    
  803043:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803045:	eb 15                	jmp    80305c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80304f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803053:	48 89 c7             	mov    %rax,%rdi
  803056:	48 89 d6             	mov    %rdx,%rsi
  803059:	fc                   	cld    
  80305a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80305c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803060:	c9                   	leaveq 
  803061:	c3                   	retq   

0000000000803062 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803062:	55                   	push   %rbp
  803063:	48 89 e5             	mov    %rsp,%rbp
  803066:	48 83 ec 18          	sub    $0x18,%rsp
  80306a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80306e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803072:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803076:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80307a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80307e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803082:	48 89 ce             	mov    %rcx,%rsi
  803085:	48 89 c7             	mov    %rax,%rdi
  803088:	48 b8 4b 2f 80 00 00 	movabs $0x802f4b,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
}
  803094:	c9                   	leaveq 
  803095:	c3                   	retq   

0000000000803096 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803096:	55                   	push   %rbp
  803097:	48 89 e5             	mov    %rsp,%rbp
  80309a:	48 83 ec 28          	sub    $0x28,%rsp
  80309e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8030aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030ba:	eb 36                	jmp    8030f2 <memcmp+0x5c>
		if (*s1 != *s2)
  8030bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c0:	0f b6 10             	movzbl (%rax),%edx
  8030c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c7:	0f b6 00             	movzbl (%rax),%eax
  8030ca:	38 c2                	cmp    %al,%dl
  8030cc:	74 1a                	je     8030e8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d2:	0f b6 00             	movzbl (%rax),%eax
  8030d5:	0f b6 d0             	movzbl %al,%edx
  8030d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030dc:	0f b6 00             	movzbl (%rax),%eax
  8030df:	0f b6 c0             	movzbl %al,%eax
  8030e2:	29 c2                	sub    %eax,%edx
  8030e4:	89 d0                	mov    %edx,%eax
  8030e6:	eb 20                	jmp    803108 <memcmp+0x72>
		s1++, s2++;
  8030e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8030fe:	48 85 c0             	test   %rax,%rax
  803101:	75 b9                	jne    8030bc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803103:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803108:	c9                   	leaveq 
  803109:	c3                   	retq   

000000000080310a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80310a:	55                   	push   %rbp
  80310b:	48 89 e5             	mov    %rsp,%rbp
  80310e:	48 83 ec 28          	sub    $0x28,%rsp
  803112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803116:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803119:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80311d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803121:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803125:	48 01 d0             	add    %rdx,%rax
  803128:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80312c:	eb 15                	jmp    803143 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80312e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803132:	0f b6 10             	movzbl (%rax),%edx
  803135:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803138:	38 c2                	cmp    %al,%dl
  80313a:	75 02                	jne    80313e <memfind+0x34>
			break;
  80313c:	eb 0f                	jmp    80314d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80313e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803147:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80314b:	72 e1                	jb     80312e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80314d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803151:	c9                   	leaveq 
  803152:	c3                   	retq   

0000000000803153 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803153:	55                   	push   %rbp
  803154:	48 89 e5             	mov    %rsp,%rbp
  803157:	48 83 ec 34          	sub    $0x34,%rsp
  80315b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80315f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803163:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803166:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80316d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803174:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803175:	eb 05                	jmp    80317c <strtol+0x29>
		s++;
  803177:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80317c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803180:	0f b6 00             	movzbl (%rax),%eax
  803183:	3c 20                	cmp    $0x20,%al
  803185:	74 f0                	je     803177 <strtol+0x24>
  803187:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318b:	0f b6 00             	movzbl (%rax),%eax
  80318e:	3c 09                	cmp    $0x9,%al
  803190:	74 e5                	je     803177 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803196:	0f b6 00             	movzbl (%rax),%eax
  803199:	3c 2b                	cmp    $0x2b,%al
  80319b:	75 07                	jne    8031a4 <strtol+0x51>
		s++;
  80319d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031a2:	eb 17                	jmp    8031bb <strtol+0x68>
	else if (*s == '-')
  8031a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a8:	0f b6 00             	movzbl (%rax),%eax
  8031ab:	3c 2d                	cmp    $0x2d,%al
  8031ad:	75 0c                	jne    8031bb <strtol+0x68>
		s++, neg = 1;
  8031af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031bf:	74 06                	je     8031c7 <strtol+0x74>
  8031c1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031c5:	75 28                	jne    8031ef <strtol+0x9c>
  8031c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031cb:	0f b6 00             	movzbl (%rax),%eax
  8031ce:	3c 30                	cmp    $0x30,%al
  8031d0:	75 1d                	jne    8031ef <strtol+0x9c>
  8031d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d6:	48 83 c0 01          	add    $0x1,%rax
  8031da:	0f b6 00             	movzbl (%rax),%eax
  8031dd:	3c 78                	cmp    $0x78,%al
  8031df:	75 0e                	jne    8031ef <strtol+0x9c>
		s += 2, base = 16;
  8031e1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031e6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031ed:	eb 2c                	jmp    80321b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031f3:	75 19                	jne    80320e <strtol+0xbb>
  8031f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f9:	0f b6 00             	movzbl (%rax),%eax
  8031fc:	3c 30                	cmp    $0x30,%al
  8031fe:	75 0e                	jne    80320e <strtol+0xbb>
		s++, base = 8;
  803200:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803205:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80320c:	eb 0d                	jmp    80321b <strtol+0xc8>
	else if (base == 0)
  80320e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803212:	75 07                	jne    80321b <strtol+0xc8>
		base = 10;
  803214:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80321b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321f:	0f b6 00             	movzbl (%rax),%eax
  803222:	3c 2f                	cmp    $0x2f,%al
  803224:	7e 1d                	jle    803243 <strtol+0xf0>
  803226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322a:	0f b6 00             	movzbl (%rax),%eax
  80322d:	3c 39                	cmp    $0x39,%al
  80322f:	7f 12                	jg     803243 <strtol+0xf0>
			dig = *s - '0';
  803231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803235:	0f b6 00             	movzbl (%rax),%eax
  803238:	0f be c0             	movsbl %al,%eax
  80323b:	83 e8 30             	sub    $0x30,%eax
  80323e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803241:	eb 4e                	jmp    803291 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803247:	0f b6 00             	movzbl (%rax),%eax
  80324a:	3c 60                	cmp    $0x60,%al
  80324c:	7e 1d                	jle    80326b <strtol+0x118>
  80324e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803252:	0f b6 00             	movzbl (%rax),%eax
  803255:	3c 7a                	cmp    $0x7a,%al
  803257:	7f 12                	jg     80326b <strtol+0x118>
			dig = *s - 'a' + 10;
  803259:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325d:	0f b6 00             	movzbl (%rax),%eax
  803260:	0f be c0             	movsbl %al,%eax
  803263:	83 e8 57             	sub    $0x57,%eax
  803266:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803269:	eb 26                	jmp    803291 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80326b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326f:	0f b6 00             	movzbl (%rax),%eax
  803272:	3c 40                	cmp    $0x40,%al
  803274:	7e 48                	jle    8032be <strtol+0x16b>
  803276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327a:	0f b6 00             	movzbl (%rax),%eax
  80327d:	3c 5a                	cmp    $0x5a,%al
  80327f:	7f 3d                	jg     8032be <strtol+0x16b>
			dig = *s - 'A' + 10;
  803281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803285:	0f b6 00             	movzbl (%rax),%eax
  803288:	0f be c0             	movsbl %al,%eax
  80328b:	83 e8 37             	sub    $0x37,%eax
  80328e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803291:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803294:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803297:	7c 02                	jl     80329b <strtol+0x148>
			break;
  803299:	eb 23                	jmp    8032be <strtol+0x16b>
		s++, val = (val * base) + dig;
  80329b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8032a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032a3:	48 98                	cltq   
  8032a5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8032aa:	48 89 c2             	mov    %rax,%rdx
  8032ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b0:	48 98                	cltq   
  8032b2:	48 01 d0             	add    %rdx,%rax
  8032b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032b9:	e9 5d ff ff ff       	jmpq   80321b <strtol+0xc8>

	if (endptr)
  8032be:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032c3:	74 0b                	je     8032d0 <strtol+0x17d>
		*endptr = (char *) s;
  8032c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032cd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d4:	74 09                	je     8032df <strtol+0x18c>
  8032d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032da:	48 f7 d8             	neg    %rax
  8032dd:	eb 04                	jmp    8032e3 <strtol+0x190>
  8032df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032e3:	c9                   	leaveq 
  8032e4:	c3                   	retq   

00000000008032e5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8032e5:	55                   	push   %rbp
  8032e6:	48 89 e5             	mov    %rsp,%rbp
  8032e9:	48 83 ec 30          	sub    $0x30,%rsp
  8032ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8032f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032fd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803301:	0f b6 00             	movzbl (%rax),%eax
  803304:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803307:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80330b:	75 06                	jne    803313 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80330d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803311:	eb 6b                	jmp    80337e <strstr+0x99>

	len = strlen(str);
  803313:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803317:	48 89 c7             	mov    %rax,%rdi
  80331a:	48 b8 bb 2b 80 00 00 	movabs $0x802bbb,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
  803326:	48 98                	cltq   
  803328:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80332c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803330:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803334:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803338:	0f b6 00             	movzbl (%rax),%eax
  80333b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80333e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803342:	75 07                	jne    80334b <strstr+0x66>
				return (char *) 0;
  803344:	b8 00 00 00 00       	mov    $0x0,%eax
  803349:	eb 33                	jmp    80337e <strstr+0x99>
		} while (sc != c);
  80334b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80334f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803352:	75 d8                	jne    80332c <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803354:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803358:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80335c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803360:	48 89 ce             	mov    %rcx,%rsi
  803363:	48 89 c7             	mov    %rax,%rdi
  803366:	48 b8 dc 2d 80 00 00 	movabs $0x802ddc,%rax
  80336d:	00 00 00 
  803370:	ff d0                	callq  *%rax
  803372:	85 c0                	test   %eax,%eax
  803374:	75 b6                	jne    80332c <strstr+0x47>

	return (char *) (in - 1);
  803376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337a:	48 83 e8 01          	sub    $0x1,%rax
}
  80337e:	c9                   	leaveq 
  80337f:	c3                   	retq   

0000000000803380 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803380:	55                   	push   %rbp
  803381:	48 89 e5             	mov    %rsp,%rbp
  803384:	48 83 ec 30          	sub    $0x30,%rsp
  803388:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80338c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803390:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803394:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803399:	75 0e                	jne    8033a9 <ipc_recv+0x29>
        pg = (void *)UTOP;
  80339b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033a2:	00 00 00 
  8033a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ad:	48 89 c7             	mov    %rax,%rdi
  8033b0:	48 b8 1d 05 80 00 00 	movabs $0x80051d,%rax
  8033b7:	00 00 00 
  8033ba:	ff d0                	callq  *%rax
  8033bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c3:	79 27                	jns    8033ec <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ca:	74 0a                	je     8033d6 <ipc_recv+0x56>
            *from_env_store = 0;
  8033cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033d6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033db:	74 0a                	je     8033e7 <ipc_recv+0x67>
            *perm_store = 0;
  8033dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ea:	eb 53                	jmp    80343f <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033f1:	74 19                	je     80340c <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033f3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033fa:	00 00 00 
  8033fd:	48 8b 00             	mov    (%rax),%rax
  803400:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340a:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80340c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803411:	74 19                	je     80342c <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803413:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80341a:	00 00 00 
  80341d:	48 8b 00             	mov    (%rax),%rax
  803420:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80342a:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80342c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803433:	00 00 00 
  803436:	48 8b 00             	mov    (%rax),%rax
  803439:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80343f:	c9                   	leaveq 
  803440:	c3                   	retq   

0000000000803441 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803441:	55                   	push   %rbp
  803442:	48 89 e5             	mov    %rsp,%rbp
  803445:	48 83 ec 30          	sub    $0x30,%rsp
  803449:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80344c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80344f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803453:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803456:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80345b:	75 0e                	jne    80346b <ipc_send+0x2a>
        pg = (void *)UTOP;
  80345d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803464:	00 00 00 
  803467:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  80346b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80346e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803471:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803475:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803478:	89 c7                	mov    %eax,%edi
  80347a:	48 b8 c8 04 80 00 00 	movabs $0x8004c8,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
  803486:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348d:	79 36                	jns    8034c5 <ipc_send+0x84>
  80348f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803493:	74 30                	je     8034c5 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803498:	89 c1                	mov    %eax,%ecx
  80349a:	48 ba a8 3c 80 00 00 	movabs $0x803ca8,%rdx
  8034a1:	00 00 00 
  8034a4:	be 49 00 00 00       	mov    $0x49,%esi
  8034a9:	48 bf b5 3c 80 00 00 	movabs $0x803cb5,%rdi
  8034b0:	00 00 00 
  8034b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b8:	49 b8 26 1e 80 00 00 	movabs $0x801e26,%r8
  8034bf:	00 00 00 
  8034c2:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034c5:	48 b8 b6 02 80 00 00 	movabs $0x8002b6,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	callq  *%rax
    } while(r != 0);
  8034d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d5:	75 94                	jne    80346b <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034d7:	c9                   	leaveq 
  8034d8:	c3                   	retq   

00000000008034d9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034d9:	55                   	push   %rbp
  8034da:	48 89 e5             	mov    %rsp,%rbp
  8034dd:	48 83 ec 14          	sub    $0x14,%rsp
  8034e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034eb:	eb 5e                	jmp    80354b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034ed:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034f4:	00 00 00 
  8034f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fa:	48 63 d0             	movslq %eax,%rdx
  8034fd:	48 89 d0             	mov    %rdx,%rax
  803500:	48 c1 e0 03          	shl    $0x3,%rax
  803504:	48 01 d0             	add    %rdx,%rax
  803507:	48 c1 e0 05          	shl    $0x5,%rax
  80350b:	48 01 c8             	add    %rcx,%rax
  80350e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803514:	8b 00                	mov    (%rax),%eax
  803516:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803519:	75 2c                	jne    803547 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80351b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803522:	00 00 00 
  803525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803528:	48 63 d0             	movslq %eax,%rdx
  80352b:	48 89 d0             	mov    %rdx,%rax
  80352e:	48 c1 e0 03          	shl    $0x3,%rax
  803532:	48 01 d0             	add    %rdx,%rax
  803535:	48 c1 e0 05          	shl    $0x5,%rax
  803539:	48 01 c8             	add    %rcx,%rax
  80353c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803542:	8b 40 08             	mov    0x8(%rax),%eax
  803545:	eb 12                	jmp    803559 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803547:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80354b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803552:	7e 99                	jle    8034ed <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803559:	c9                   	leaveq 
  80355a:	c3                   	retq   

000000000080355b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80355b:	55                   	push   %rbp
  80355c:	48 89 e5             	mov    %rsp,%rbp
  80355f:	48 83 ec 18          	sub    $0x18,%rsp
  803563:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80356b:	48 c1 e8 15          	shr    $0x15,%rax
  80356f:	48 89 c2             	mov    %rax,%rdx
  803572:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803579:	01 00 00 
  80357c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803580:	83 e0 01             	and    $0x1,%eax
  803583:	48 85 c0             	test   %rax,%rax
  803586:	75 07                	jne    80358f <pageref+0x34>
		return 0;
  803588:	b8 00 00 00 00       	mov    $0x0,%eax
  80358d:	eb 53                	jmp    8035e2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80358f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803593:	48 c1 e8 0c          	shr    $0xc,%rax
  803597:	48 89 c2             	mov    %rax,%rdx
  80359a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035a1:	01 00 00 
  8035a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b0:	83 e0 01             	and    $0x1,%eax
  8035b3:	48 85 c0             	test   %rax,%rax
  8035b6:	75 07                	jne    8035bf <pageref+0x64>
		return 0;
  8035b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035bd:	eb 23                	jmp    8035e2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c3:	48 c1 e8 0c          	shr    $0xc,%rax
  8035c7:	48 89 c2             	mov    %rax,%rdx
  8035ca:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035d1:	00 00 00 
  8035d4:	48 c1 e2 04          	shl    $0x4,%rdx
  8035d8:	48 01 d0             	add    %rdx,%rax
  8035db:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035df:	0f b7 c0             	movzwl %ax,%eax
}
  8035e2:	c9                   	leaveq 
  8035e3:	c3                   	retq   
