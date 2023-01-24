
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
  80005c:	48 b8 a0 01 80 00 00 	movabs $0x8001a0,%rax
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
	envid_t id = sys_getenvid();
  800079:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
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
  8000ae:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b5:	00 00 00 
  8000b8:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000bf:	7e 14                	jle    8000d5 <libmain+0x6b>
		binaryname = argv[0];
  8000c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000c5:	48 8b 10             	mov    (%rax),%rdx
  8000c8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  8000ff:	bf 00 00 00 00       	mov    $0x0,%edi
  800104:	48 b8 28 02 80 00 00 	movabs $0x800228,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	callq  *%rax
}
  800110:	5d                   	pop    %rbp
  800111:	c3                   	retq   

0000000000800112 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800112:	55                   	push   %rbp
  800113:	48 89 e5             	mov    %rsp,%rbp
  800116:	53                   	push   %rbx
  800117:	48 83 ec 48          	sub    $0x48,%rsp
  80011b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80011e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800121:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800125:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800129:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80012d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800131:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800134:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800138:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80013c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800140:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800144:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800148:	4c 89 c3             	mov    %r8,%rbx
  80014b:	cd 30                	int    $0x30
  80014d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800151:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800155:	74 3e                	je     800195 <syscall+0x83>
  800157:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80015c:	7e 37                	jle    800195 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80015e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800162:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800165:	49 89 d0             	mov    %rdx,%r8
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	48 ba 8a 1a 80 00 00 	movabs $0x801a8a,%rdx
  800171:	00 00 00 
  800174:	be 23 00 00 00       	mov    $0x23,%esi
  800179:	48 bf a7 1a 80 00 00 	movabs $0x801aa7,%rdi
  800180:	00 00 00 
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	49 b9 0b 05 80 00 00 	movabs $0x80050b,%r9
  80018f:	00 00 00 
  800192:	41 ff d1             	callq  *%r9

	return ret;
  800195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800199:	48 83 c4 48          	add    $0x48,%rsp
  80019d:	5b                   	pop    %rbx
  80019e:	5d                   	pop    %rbp
  80019f:	c3                   	retq   

00000000008001a0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a0:	55                   	push   %rbp
  8001a1:	48 89 e5             	mov    %rsp,%rbp
  8001a4:	48 83 ec 20          	sub    $0x20,%rsp
  8001a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001bf:	00 
  8001c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001cc:	48 89 d1             	mov    %rdx,%rcx
  8001cf:	48 89 c2             	mov    %rax,%rdx
  8001d2:	be 00 00 00 00       	mov    $0x0,%esi
  8001d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dc:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  8001e3:	00 00 00 
  8001e6:	ff d0                	callq  *%rax
}
  8001e8:	c9                   	leaveq 
  8001e9:	c3                   	retq   

00000000008001ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ea:	55                   	push   %rbp
  8001eb:	48 89 e5             	mov    %rsp,%rbp
  8001ee:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f9:	00 
  8001fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800200:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800206:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020b:	ba 00 00 00 00       	mov    $0x0,%edx
  800210:	be 00 00 00 00       	mov    $0x0,%esi
  800215:	bf 01 00 00 00       	mov    $0x1,%edi
  80021a:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  800221:	00 00 00 
  800224:	ff d0                	callq  *%rax
}
  800226:	c9                   	leaveq 
  800227:	c3                   	retq   

0000000000800228 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800228:	55                   	push   %rbp
  800229:	48 89 e5             	mov    %rsp,%rbp
  80022c:	48 83 ec 10          	sub    $0x10,%rsp
  800230:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800233:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800236:	48 98                	cltq   
  800238:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80023f:	00 
  800240:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800246:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80024c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800251:	48 89 c2             	mov    %rax,%rdx
  800254:	be 01 00 00 00       	mov    $0x1,%esi
  800259:	bf 03 00 00 00       	mov    $0x3,%edi
  80025e:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  800265:	00 00 00 
  800268:	ff d0                	callq  *%rax
}
  80026a:	c9                   	leaveq 
  80026b:	c3                   	retq   

000000000080026c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80026c:	55                   	push   %rbp
  80026d:	48 89 e5             	mov    %rsp,%rbp
  800270:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800274:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027b:	00 
  80027c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800282:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800288:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028d:	ba 00 00 00 00       	mov    $0x0,%edx
  800292:	be 00 00 00 00       	mov    $0x0,%esi
  800297:	bf 02 00 00 00       	mov    $0x2,%edi
  80029c:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
}
  8002a8:	c9                   	leaveq 
  8002a9:	c3                   	retq   

00000000008002aa <sys_yield>:

void
sys_yield(void)
{
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002b9:	00 
  8002ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d0:	be 00 00 00 00       	mov    $0x0,%esi
  8002d5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002da:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
}
  8002e6:	c9                   	leaveq 
  8002e7:	c3                   	retq   

00000000008002e8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002e8:	55                   	push   %rbp
  8002e9:	48 89 e5             	mov    %rsp,%rbp
  8002ec:	48 83 ec 20          	sub    $0x20,%rsp
  8002f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002f7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002fd:	48 63 c8             	movslq %eax,%rcx
  800300:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800304:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800307:	48 98                	cltq   
  800309:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800310:	00 
  800311:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800317:	49 89 c8             	mov    %rcx,%r8
  80031a:	48 89 d1             	mov    %rdx,%rcx
  80031d:	48 89 c2             	mov    %rax,%rdx
  800320:	be 01 00 00 00       	mov    $0x1,%esi
  800325:	bf 04 00 00 00       	mov    $0x4,%edi
  80032a:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
  80033c:	48 83 ec 30          	sub    $0x30,%rsp
  800340:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800347:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80034a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80034e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800352:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800355:	48 63 c8             	movslq %eax,%rcx
  800358:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80035c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80035f:	48 63 f0             	movslq %eax,%rsi
  800362:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800366:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800369:	48 98                	cltq   
  80036b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80036f:	49 89 f9             	mov    %rdi,%r9
  800372:	49 89 f0             	mov    %rsi,%r8
  800375:	48 89 d1             	mov    %rdx,%rcx
  800378:	48 89 c2             	mov    %rax,%rdx
  80037b:	be 01 00 00 00       	mov    $0x1,%esi
  800380:	bf 05 00 00 00       	mov    $0x5,%edi
  800385:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  80038c:	00 00 00 
  80038f:	ff d0                	callq  *%rax
}
  800391:	c9                   	leaveq 
  800392:	c3                   	retq   

0000000000800393 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800393:	55                   	push   %rbp
  800394:	48 89 e5             	mov    %rsp,%rbp
  800397:	48 83 ec 20          	sub    $0x20,%rsp
  80039b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a9:	48 98                	cltq   
  8003ab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003b2:	00 
  8003b3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003bf:	48 89 d1             	mov    %rdx,%rcx
  8003c2:	48 89 c2             	mov    %rax,%rdx
  8003c5:	be 01 00 00 00       	mov    $0x1,%esi
  8003ca:	bf 06 00 00 00       	mov    $0x6,%edi
  8003cf:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  8003d6:	00 00 00 
  8003d9:	ff d0                	callq  *%rax
}
  8003db:	c9                   	leaveq 
  8003dc:	c3                   	retq   

00000000008003dd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003dd:	55                   	push   %rbp
  8003de:	48 89 e5             	mov    %rsp,%rbp
  8003e1:	48 83 ec 10          	sub    $0x10,%rsp
  8003e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ee:	48 63 d0             	movslq %eax,%rdx
  8003f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f4:	48 98                	cltq   
  8003f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003fd:	00 
  8003fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800404:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80040a:	48 89 d1             	mov    %rdx,%rcx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	be 01 00 00 00       	mov    $0x1,%esi
  800415:	bf 08 00 00 00       	mov    $0x8,%edi
  80041a:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  800421:	00 00 00 
  800424:	ff d0                	callq  *%rax
}
  800426:	c9                   	leaveq 
  800427:	c3                   	retq   

0000000000800428 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800428:	55                   	push   %rbp
  800429:	48 89 e5             	mov    %rsp,%rbp
  80042c:	48 83 ec 20          	sub    $0x20,%rsp
  800430:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800433:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800437:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043e:	48 98                	cltq   
  800440:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800447:	00 
  800448:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80044e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800454:	48 89 d1             	mov    %rdx,%rcx
  800457:	48 89 c2             	mov    %rax,%rdx
  80045a:	be 01 00 00 00       	mov    $0x1,%esi
  80045f:	bf 09 00 00 00       	mov    $0x9,%edi
  800464:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	callq  *%rax
}
  800470:	c9                   	leaveq 
  800471:	c3                   	retq   

0000000000800472 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800472:	55                   	push   %rbp
  800473:	48 89 e5             	mov    %rsp,%rbp
  800476:	48 83 ec 20          	sub    $0x20,%rsp
  80047a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800481:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800485:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800488:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80048b:	48 63 f0             	movslq %eax,%rsi
  80048e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800492:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800495:	48 98                	cltq   
  800497:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a2:	00 
  8004a3:	49 89 f1             	mov    %rsi,%r9
  8004a6:	49 89 c8             	mov    %rcx,%r8
  8004a9:	48 89 d1             	mov    %rdx,%rcx
  8004ac:	48 89 c2             	mov    %rax,%rdx
  8004af:	be 00 00 00 00       	mov    $0x0,%esi
  8004b4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004b9:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  8004c0:	00 00 00 
  8004c3:	ff d0                	callq  *%rax
}
  8004c5:	c9                   	leaveq 
  8004c6:	c3                   	retq   

00000000008004c7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004c7:	55                   	push   %rbp
  8004c8:	48 89 e5             	mov    %rsp,%rbp
  8004cb:	48 83 ec 10          	sub    $0x10,%rsp
  8004cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004de:	00 
  8004df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f0:	48 89 c2             	mov    %rax,%rdx
  8004f3:	be 01 00 00 00       	mov    $0x1,%esi
  8004f8:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004fd:	48 b8 12 01 80 00 00 	movabs $0x800112,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
}
  800509:	c9                   	leaveq 
  80050a:	c3                   	retq   

000000000080050b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80050b:	55                   	push   %rbp
  80050c:	48 89 e5             	mov    %rsp,%rbp
  80050f:	53                   	push   %rbx
  800510:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800517:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80051e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800524:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80052b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800532:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800539:	84 c0                	test   %al,%al
  80053b:	74 23                	je     800560 <_panic+0x55>
  80053d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800544:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800548:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80054c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800550:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800554:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800558:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80055c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800560:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800567:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80056e:	00 00 00 
  800571:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800578:	00 00 00 
  80057b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80057f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800586:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80058d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800594:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80059b:	00 00 00 
  80059e:	48 8b 18             	mov    (%rax),%rbx
  8005a1:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  8005a8:	00 00 00 
  8005ab:	ff d0                	callq  *%rax
  8005ad:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005b3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005ba:	41 89 c8             	mov    %ecx,%r8d
  8005bd:	48 89 d1             	mov    %rdx,%rcx
  8005c0:	48 89 da             	mov    %rbx,%rdx
  8005c3:	89 c6                	mov    %eax,%esi
  8005c5:	48 bf b8 1a 80 00 00 	movabs $0x801ab8,%rdi
  8005cc:	00 00 00 
  8005cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d4:	49 b9 44 07 80 00 00 	movabs $0x800744,%r9
  8005db:	00 00 00 
  8005de:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005e8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ef:	48 89 d6             	mov    %rdx,%rsi
  8005f2:	48 89 c7             	mov    %rax,%rdi
  8005f5:	48 b8 98 06 80 00 00 	movabs $0x800698,%rax
  8005fc:	00 00 00 
  8005ff:	ff d0                	callq  *%rax
	cprintf("\n");
  800601:	48 bf db 1a 80 00 00 	movabs $0x801adb,%rdi
  800608:	00 00 00 
  80060b:	b8 00 00 00 00       	mov    $0x0,%eax
  800610:	48 ba 44 07 80 00 00 	movabs $0x800744,%rdx
  800617:	00 00 00 
  80061a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80061c:	cc                   	int3   
  80061d:	eb fd                	jmp    80061c <_panic+0x111>

000000000080061f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80061f:	55                   	push   %rbp
  800620:	48 89 e5             	mov    %rsp,%rbp
  800623:	48 83 ec 10          	sub    $0x10,%rsp
  800627:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80062a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80062e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800632:	8b 00                	mov    (%rax),%eax
  800634:	8d 48 01             	lea    0x1(%rax),%ecx
  800637:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80063b:	89 0a                	mov    %ecx,(%rdx)
  80063d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800640:	89 d1                	mov    %edx,%ecx
  800642:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800646:	48 98                	cltq   
  800648:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80064c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800650:	8b 00                	mov    (%rax),%eax
  800652:	3d ff 00 00 00       	cmp    $0xff,%eax
  800657:	75 2c                	jne    800685 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065d:	8b 00                	mov    (%rax),%eax
  80065f:	48 98                	cltq   
  800661:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800665:	48 83 c2 08          	add    $0x8,%rdx
  800669:	48 89 c6             	mov    %rax,%rsi
  80066c:	48 89 d7             	mov    %rdx,%rdi
  80066f:	48 b8 a0 01 80 00 00 	movabs $0x8001a0,%rax
  800676:	00 00 00 
  800679:	ff d0                	callq  *%rax
        b->idx = 0;
  80067b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800685:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800689:	8b 40 04             	mov    0x4(%rax),%eax
  80068c:	8d 50 01             	lea    0x1(%rax),%edx
  80068f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800693:	89 50 04             	mov    %edx,0x4(%rax)
}
  800696:	c9                   	leaveq 
  800697:	c3                   	retq   

0000000000800698 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800698:	55                   	push   %rbp
  800699:	48 89 e5             	mov    %rsp,%rbp
  80069c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006aa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006b1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006b8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006bf:	48 8b 0a             	mov    (%rdx),%rcx
  8006c2:	48 89 08             	mov    %rcx,(%rax)
  8006c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006dc:	00 00 00 
    b.cnt = 0;
  8006df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006e6:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006e9:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f0:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006f7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006fe:	48 89 c6             	mov    %rax,%rsi
  800701:	48 bf 1f 06 80 00 00 	movabs $0x80061f,%rdi
  800708:	00 00 00 
  80070b:	48 b8 f7 0a 80 00 00 	movabs $0x800af7,%rax
  800712:	00 00 00 
  800715:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800717:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80071d:	48 98                	cltq   
  80071f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800726:	48 83 c2 08          	add    $0x8,%rdx
  80072a:	48 89 c6             	mov    %rax,%rsi
  80072d:	48 89 d7             	mov    %rdx,%rdi
  800730:	48 b8 a0 01 80 00 00 	movabs $0x8001a0,%rax
  800737:	00 00 00 
  80073a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80073c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800742:	c9                   	leaveq 
  800743:	c3                   	retq   

0000000000800744 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800744:	55                   	push   %rbp
  800745:	48 89 e5             	mov    %rsp,%rbp
  800748:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80074f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800756:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80075d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800764:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80076b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800772:	84 c0                	test   %al,%al
  800774:	74 20                	je     800796 <cprintf+0x52>
  800776:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80077a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80077e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800782:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800786:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80078a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80078e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800792:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800796:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80079d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007a4:	00 00 00 
  8007a7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007ae:	00 00 00 
  8007b1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007bc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007ca:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007d8:	48 8b 0a             	mov    (%rdx),%rcx
  8007db:	48 89 08             	mov    %rcx,(%rax)
  8007de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007ee:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007f5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007fc:	48 89 d6             	mov    %rdx,%rsi
  8007ff:	48 89 c7             	mov    %rax,%rdi
  800802:	48 b8 98 06 80 00 00 	movabs $0x800698,%rax
  800809:	00 00 00 
  80080c:	ff d0                	callq  *%rax
  80080e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800814:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80081a:	c9                   	leaveq 
  80081b:	c3                   	retq   

000000000080081c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081c:	55                   	push   %rbp
  80081d:	48 89 e5             	mov    %rsp,%rbp
  800820:	53                   	push   %rbx
  800821:	48 83 ec 38          	sub    $0x38,%rsp
  800825:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800829:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80082d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800831:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800834:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800838:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80083f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800843:	77 3b                	ja     800880 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800845:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800848:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80084c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80084f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
  800858:	48 f7 f3             	div    %rbx
  80085b:	48 89 c2             	mov    %rax,%rdx
  80085e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800861:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800864:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086c:	41 89 f9             	mov    %edi,%r9d
  80086f:	48 89 c7             	mov    %rax,%rdi
  800872:	48 b8 1c 08 80 00 00 	movabs $0x80081c,%rax
  800879:	00 00 00 
  80087c:	ff d0                	callq  *%rax
  80087e:	eb 1e                	jmp    80089e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800880:	eb 12                	jmp    800894 <printnum+0x78>
			putch(padc, putdat);
  800882:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800886:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088d:	48 89 ce             	mov    %rcx,%rsi
  800890:	89 d7                	mov    %edx,%edi
  800892:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800894:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800898:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80089c:	7f e4                	jg     800882 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008aa:	48 f7 f1             	div    %rcx
  8008ad:	48 89 d0             	mov    %rdx,%rax
  8008b0:	48 ba 30 1c 80 00 00 	movabs $0x801c30,%rdx
  8008b7:	00 00 00 
  8008ba:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008be:	0f be d0             	movsbl %al,%edx
  8008c1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c9:	48 89 ce             	mov    %rcx,%rsi
  8008cc:	89 d7                	mov    %edx,%edi
  8008ce:	ff d0                	callq  *%rax
}
  8008d0:	48 83 c4 38          	add    $0x38,%rsp
  8008d4:	5b                   	pop    %rbx
  8008d5:	5d                   	pop    %rbp
  8008d6:	c3                   	retq   

00000000008008d7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d7:	55                   	push   %rbp
  8008d8:	48 89 e5             	mov    %rsp,%rbp
  8008db:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008e6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ea:	7e 52                	jle    80093e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f0:	8b 00                	mov    (%rax),%eax
  8008f2:	83 f8 30             	cmp    $0x30,%eax
  8008f5:	73 24                	jae    80091b <getuint+0x44>
  8008f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	8b 00                	mov    (%rax),%eax
  800905:	89 c0                	mov    %eax,%eax
  800907:	48 01 d0             	add    %rdx,%rax
  80090a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090e:	8b 12                	mov    (%rdx),%edx
  800910:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800913:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800917:	89 0a                	mov    %ecx,(%rdx)
  800919:	eb 17                	jmp    800932 <getuint+0x5b>
  80091b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800923:	48 89 d0             	mov    %rdx,%rax
  800926:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80092a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800932:	48 8b 00             	mov    (%rax),%rax
  800935:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800939:	e9 a3 00 00 00       	jmpq   8009e1 <getuint+0x10a>
	else if (lflag)
  80093e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800942:	74 4f                	je     800993 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800948:	8b 00                	mov    (%rax),%eax
  80094a:	83 f8 30             	cmp    $0x30,%eax
  80094d:	73 24                	jae    800973 <getuint+0x9c>
  80094f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800953:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	8b 00                	mov    (%rax),%eax
  80095d:	89 c0                	mov    %eax,%eax
  80095f:	48 01 d0             	add    %rdx,%rax
  800962:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800966:	8b 12                	mov    (%rdx),%edx
  800968:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096f:	89 0a                	mov    %ecx,(%rdx)
  800971:	eb 17                	jmp    80098a <getuint+0xb3>
  800973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800977:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80097b:	48 89 d0             	mov    %rdx,%rax
  80097e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800982:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800986:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80098a:	48 8b 00             	mov    (%rax),%rax
  80098d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800991:	eb 4e                	jmp    8009e1 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800993:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800997:	8b 00                	mov    (%rax),%eax
  800999:	83 f8 30             	cmp    $0x30,%eax
  80099c:	73 24                	jae    8009c2 <getuint+0xeb>
  80099e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	8b 00                	mov    (%rax),%eax
  8009ac:	89 c0                	mov    %eax,%eax
  8009ae:	48 01 d0             	add    %rdx,%rax
  8009b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b5:	8b 12                	mov    (%rdx),%edx
  8009b7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009be:	89 0a                	mov    %ecx,(%rdx)
  8009c0:	eb 17                	jmp    8009d9 <getuint+0x102>
  8009c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ca:	48 89 d0             	mov    %rdx,%rax
  8009cd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d9:	8b 00                	mov    (%rax),%eax
  8009db:	89 c0                	mov    %eax,%eax
  8009dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009e5:	c9                   	leaveq 
  8009e6:	c3                   	retq   

00000000008009e7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009e7:	55                   	push   %rbp
  8009e8:	48 89 e5             	mov    %rsp,%rbp
  8009eb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009f6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009fa:	7e 52                	jle    800a4e <getint+0x67>
		x=va_arg(*ap, long long);
  8009fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a00:	8b 00                	mov    (%rax),%eax
  800a02:	83 f8 30             	cmp    $0x30,%eax
  800a05:	73 24                	jae    800a2b <getint+0x44>
  800a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	8b 00                	mov    (%rax),%eax
  800a15:	89 c0                	mov    %eax,%eax
  800a17:	48 01 d0             	add    %rdx,%rax
  800a1a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1e:	8b 12                	mov    (%rdx),%edx
  800a20:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a27:	89 0a                	mov    %ecx,(%rdx)
  800a29:	eb 17                	jmp    800a42 <getint+0x5b>
  800a2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a33:	48 89 d0             	mov    %rdx,%rax
  800a36:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a42:	48 8b 00             	mov    (%rax),%rax
  800a45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a49:	e9 a3 00 00 00       	jmpq   800af1 <getint+0x10a>
	else if (lflag)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a52:	74 4f                	je     800aa3 <getint+0xbc>
		x=va_arg(*ap, long);
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	8b 00                	mov    (%rax),%eax
  800a5a:	83 f8 30             	cmp    $0x30,%eax
  800a5d:	73 24                	jae    800a83 <getint+0x9c>
  800a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a63:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6b:	8b 00                	mov    (%rax),%eax
  800a6d:	89 c0                	mov    %eax,%eax
  800a6f:	48 01 d0             	add    %rdx,%rax
  800a72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a76:	8b 12                	mov    (%rdx),%edx
  800a78:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7f:	89 0a                	mov    %ecx,(%rdx)
  800a81:	eb 17                	jmp    800a9a <getint+0xb3>
  800a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a87:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a8b:	48 89 d0             	mov    %rdx,%rax
  800a8e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a96:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9a:	48 8b 00             	mov    (%rax),%rax
  800a9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa1:	eb 4e                	jmp    800af1 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa7:	8b 00                	mov    (%rax),%eax
  800aa9:	83 f8 30             	cmp    $0x30,%eax
  800aac:	73 24                	jae    800ad2 <getint+0xeb>
  800aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	8b 00                	mov    (%rax),%eax
  800abc:	89 c0                	mov    %eax,%eax
  800abe:	48 01 d0             	add    %rdx,%rax
  800ac1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac5:	8b 12                	mov    (%rdx),%edx
  800ac7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ace:	89 0a                	mov    %ecx,(%rdx)
  800ad0:	eb 17                	jmp    800ae9 <getint+0x102>
  800ad2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ada:	48 89 d0             	mov    %rdx,%rax
  800add:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ae9:	8b 00                	mov    (%rax),%eax
  800aeb:	48 98                	cltq   
  800aed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800af5:	c9                   	leaveq 
  800af6:	c3                   	retq   

0000000000800af7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800af7:	55                   	push   %rbp
  800af8:	48 89 e5             	mov    %rsp,%rbp
  800afb:	41 54                	push   %r12
  800afd:	53                   	push   %rbx
  800afe:	48 83 ec 60          	sub    $0x60,%rsp
  800b02:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b06:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b0a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b0e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b16:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b1a:	48 8b 0a             	mov    (%rdx),%rcx
  800b1d:	48 89 08             	mov    %rcx,(%rax)
  800b20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b30:	eb 17                	jmp    800b49 <vprintfmt+0x52>
			if (ch == '\0')
  800b32:	85 db                	test   %ebx,%ebx
  800b34:	0f 84 df 04 00 00    	je     801019 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800b3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b42:	48 89 d6             	mov    %rdx,%rsi
  800b45:	89 df                	mov    %ebx,%edi
  800b47:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b4d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b51:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b55:	0f b6 00             	movzbl (%rax),%eax
  800b58:	0f b6 d8             	movzbl %al,%ebx
  800b5b:	83 fb 25             	cmp    $0x25,%ebx
  800b5e:	75 d2                	jne    800b32 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b60:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b64:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b6b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b79:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b80:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b84:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b88:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b8c:	0f b6 00             	movzbl (%rax),%eax
  800b8f:	0f b6 d8             	movzbl %al,%ebx
  800b92:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b95:	83 f8 55             	cmp    $0x55,%eax
  800b98:	0f 87 47 04 00 00    	ja     800fe5 <vprintfmt+0x4ee>
  800b9e:	89 c0                	mov    %eax,%eax
  800ba0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ba7:	00 
  800ba8:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  800baf:	00 00 00 
  800bb2:	48 01 d0             	add    %rdx,%rax
  800bb5:	48 8b 00             	mov    (%rax),%rax
  800bb8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bba:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bbe:	eb c0                	jmp    800b80 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bc4:	eb ba                	jmp    800b80 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bcd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bd0:	89 d0                	mov    %edx,%eax
  800bd2:	c1 e0 02             	shl    $0x2,%eax
  800bd5:	01 d0                	add    %edx,%eax
  800bd7:	01 c0                	add    %eax,%eax
  800bd9:	01 d8                	add    %ebx,%eax
  800bdb:	83 e8 30             	sub    $0x30,%eax
  800bde:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be5:	0f b6 00             	movzbl (%rax),%eax
  800be8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800beb:	83 fb 2f             	cmp    $0x2f,%ebx
  800bee:	7e 0c                	jle    800bfc <vprintfmt+0x105>
  800bf0:	83 fb 39             	cmp    $0x39,%ebx
  800bf3:	7f 07                	jg     800bfc <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bfa:	eb d1                	jmp    800bcd <vprintfmt+0xd6>
			goto process_precision;
  800bfc:	eb 58                	jmp    800c56 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bfe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c01:	83 f8 30             	cmp    $0x30,%eax
  800c04:	73 17                	jae    800c1d <vprintfmt+0x126>
  800c06:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0d:	89 c0                	mov    %eax,%eax
  800c0f:	48 01 d0             	add    %rdx,%rax
  800c12:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c15:	83 c2 08             	add    $0x8,%edx
  800c18:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c1b:	eb 0f                	jmp    800c2c <vprintfmt+0x135>
  800c1d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c21:	48 89 d0             	mov    %rdx,%rax
  800c24:	48 83 c2 08          	add    $0x8,%rdx
  800c28:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c2c:	8b 00                	mov    (%rax),%eax
  800c2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c31:	eb 23                	jmp    800c56 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c37:	79 0c                	jns    800c45 <vprintfmt+0x14e>
				width = 0;
  800c39:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c40:	e9 3b ff ff ff       	jmpq   800b80 <vprintfmt+0x89>
  800c45:	e9 36 ff ff ff       	jmpq   800b80 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c4a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c51:	e9 2a ff ff ff       	jmpq   800b80 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5a:	79 12                	jns    800c6e <vprintfmt+0x177>
				width = precision, precision = -1;
  800c5c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c5f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c62:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c69:	e9 12 ff ff ff       	jmpq   800b80 <vprintfmt+0x89>
  800c6e:	e9 0d ff ff ff       	jmpq   800b80 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c73:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c77:	e9 04 ff ff ff       	jmpq   800b80 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7f:	83 f8 30             	cmp    $0x30,%eax
  800c82:	73 17                	jae    800c9b <vprintfmt+0x1a4>
  800c84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8b:	89 c0                	mov    %eax,%eax
  800c8d:	48 01 d0             	add    %rdx,%rax
  800c90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c93:	83 c2 08             	add    $0x8,%edx
  800c96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c99:	eb 0f                	jmp    800caa <vprintfmt+0x1b3>
  800c9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9f:	48 89 d0             	mov    %rdx,%rax
  800ca2:	48 83 c2 08          	add    $0x8,%rdx
  800ca6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800caa:	8b 10                	mov    (%rax),%edx
  800cac:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb4:	48 89 ce             	mov    %rcx,%rsi
  800cb7:	89 d7                	mov    %edx,%edi
  800cb9:	ff d0                	callq  *%rax
			break;
  800cbb:	e9 53 03 00 00       	jmpq   801013 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc3:	83 f8 30             	cmp    $0x30,%eax
  800cc6:	73 17                	jae    800cdf <vprintfmt+0x1e8>
  800cc8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ccc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccf:	89 c0                	mov    %eax,%eax
  800cd1:	48 01 d0             	add    %rdx,%rax
  800cd4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd7:	83 c2 08             	add    $0x8,%edx
  800cda:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cdd:	eb 0f                	jmp    800cee <vprintfmt+0x1f7>
  800cdf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce3:	48 89 d0             	mov    %rdx,%rax
  800ce6:	48 83 c2 08          	add    $0x8,%rdx
  800cea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cee:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x1ff>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 15             	cmp    $0x15,%ebx
  800cf9:	7f 16                	jg     800d11 <vprintfmt+0x21a>
  800cfb:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800d02:	00 00 00 
  800d05:	48 63 d3             	movslq %ebx,%rdx
  800d08:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d0c:	4d 85 e4             	test   %r12,%r12
  800d0f:	75 2e                	jne    800d3f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d11:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d19:	89 d9                	mov    %ebx,%ecx
  800d1b:	48 ba 41 1c 80 00 00 	movabs $0x801c41,%rdx
  800d22:	00 00 00 
  800d25:	48 89 c7             	mov    %rax,%rdi
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2d:	49 b8 22 10 80 00 00 	movabs $0x801022,%r8
  800d34:	00 00 00 
  800d37:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d3a:	e9 d4 02 00 00       	jmpq   801013 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d3f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d47:	4c 89 e1             	mov    %r12,%rcx
  800d4a:	48 ba 4a 1c 80 00 00 	movabs $0x801c4a,%rdx
  800d51:	00 00 00 
  800d54:	48 89 c7             	mov    %rax,%rdi
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5c:	49 b8 22 10 80 00 00 	movabs $0x801022,%r8
  800d63:	00 00 00 
  800d66:	41 ff d0             	callq  *%r8
			break;
  800d69:	e9 a5 02 00 00       	jmpq   801013 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d71:	83 f8 30             	cmp    $0x30,%eax
  800d74:	73 17                	jae    800d8d <vprintfmt+0x296>
  800d76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7d:	89 c0                	mov    %eax,%eax
  800d7f:	48 01 d0             	add    %rdx,%rax
  800d82:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d85:	83 c2 08             	add    $0x8,%edx
  800d88:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d8b:	eb 0f                	jmp    800d9c <vprintfmt+0x2a5>
  800d8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d91:	48 89 d0             	mov    %rdx,%rax
  800d94:	48 83 c2 08          	add    $0x8,%rdx
  800d98:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d9c:	4c 8b 20             	mov    (%rax),%r12
  800d9f:	4d 85 e4             	test   %r12,%r12
  800da2:	75 0a                	jne    800dae <vprintfmt+0x2b7>
				p = "(null)";
  800da4:	49 bc 4d 1c 80 00 00 	movabs $0x801c4d,%r12
  800dab:	00 00 00 
			if (width > 0 && padc != '-')
  800dae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db2:	7e 3f                	jle    800df3 <vprintfmt+0x2fc>
  800db4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800db8:	74 39                	je     800df3 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dbd:	48 98                	cltq   
  800dbf:	48 89 c6             	mov    %rax,%rsi
  800dc2:	4c 89 e7             	mov    %r12,%rdi
  800dc5:	48 b8 ce 12 80 00 00 	movabs $0x8012ce,%rax
  800dcc:	00 00 00 
  800dcf:	ff d0                	callq  *%rax
  800dd1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dd4:	eb 17                	jmp    800ded <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dd6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dda:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de2:	48 89 ce             	mov    %rcx,%rsi
  800de5:	89 d7                	mov    %edx,%edi
  800de7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ded:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df1:	7f e3                	jg     800dd6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df3:	eb 37                	jmp    800e2c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800df5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800df9:	74 1e                	je     800e19 <vprintfmt+0x322>
  800dfb:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfe:	7e 05                	jle    800e05 <vprintfmt+0x30e>
  800e00:	83 fb 7e             	cmp    $0x7e,%ebx
  800e03:	7e 14                	jle    800e19 <vprintfmt+0x322>
					putch('?', putdat);
  800e05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0d:	48 89 d6             	mov    %rdx,%rsi
  800e10:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e15:	ff d0                	callq  *%rax
  800e17:	eb 0f                	jmp    800e28 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e21:	48 89 d6             	mov    %rdx,%rsi
  800e24:	89 df                	mov    %ebx,%edi
  800e26:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e2c:	4c 89 e0             	mov    %r12,%rax
  800e2f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e33:	0f b6 00             	movzbl (%rax),%eax
  800e36:	0f be d8             	movsbl %al,%ebx
  800e39:	85 db                	test   %ebx,%ebx
  800e3b:	74 10                	je     800e4d <vprintfmt+0x356>
  800e3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e41:	78 b2                	js     800df5 <vprintfmt+0x2fe>
  800e43:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e4b:	79 a8                	jns    800df5 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4d:	eb 16                	jmp    800e65 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e57:	48 89 d6             	mov    %rdx,%rsi
  800e5a:	bf 20 00 00 00       	mov    $0x20,%edi
  800e5f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e61:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e69:	7f e4                	jg     800e4f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e6b:	e9 a3 01 00 00       	jmpq   801013 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e74:	be 03 00 00 00       	mov    $0x3,%esi
  800e79:	48 89 c7             	mov    %rax,%rdi
  800e7c:	48 b8 e7 09 80 00 00 	movabs $0x8009e7,%rax
  800e83:	00 00 00 
  800e86:	ff d0                	callq  *%rax
  800e88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e90:	48 85 c0             	test   %rax,%rax
  800e93:	79 1d                	jns    800eb2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9d:	48 89 d6             	mov    %rdx,%rsi
  800ea0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ea5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eab:	48 f7 d8             	neg    %rax
  800eae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eb2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eb9:	e9 e8 00 00 00       	jmpq   800fa6 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ebe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec2:	be 03 00 00 00       	mov    $0x3,%esi
  800ec7:	48 89 c7             	mov    %rax,%rdi
  800eca:	48 b8 d7 08 80 00 00 	movabs $0x8008d7,%rax
  800ed1:	00 00 00 
  800ed4:	ff d0                	callq  *%rax
  800ed6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eda:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ee1:	e9 c0 00 00 00       	jmpq   800fa6 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ee6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eee:	48 89 d6             	mov    %rdx,%rsi
  800ef1:	bf 58 00 00 00       	mov    $0x58,%edi
  800ef6:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ef8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f00:	48 89 d6             	mov    %rdx,%rsi
  800f03:	bf 58 00 00 00       	mov    $0x58,%edi
  800f08:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f12:	48 89 d6             	mov    %rdx,%rsi
  800f15:	bf 58 00 00 00       	mov    $0x58,%edi
  800f1a:	ff d0                	callq  *%rax
			break;
  800f1c:	e9 f2 00 00 00       	jmpq   801013 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f29:	48 89 d6             	mov    %rdx,%rsi
  800f2c:	bf 30 00 00 00       	mov    $0x30,%edi
  800f31:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3b:	48 89 d6             	mov    %rdx,%rsi
  800f3e:	bf 78 00 00 00       	mov    $0x78,%edi
  800f43:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f48:	83 f8 30             	cmp    $0x30,%eax
  800f4b:	73 17                	jae    800f64 <vprintfmt+0x46d>
  800f4d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f54:	89 c0                	mov    %eax,%eax
  800f56:	48 01 d0             	add    %rdx,%rax
  800f59:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f5c:	83 c2 08             	add    $0x8,%edx
  800f5f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f62:	eb 0f                	jmp    800f73 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f64:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f68:	48 89 d0             	mov    %rdx,%rax
  800f6b:	48 83 c2 08          	add    $0x8,%rdx
  800f6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f73:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f76:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f7a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f81:	eb 23                	jmp    800fa6 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f83:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f87:	be 03 00 00 00       	mov    $0x3,%esi
  800f8c:	48 89 c7             	mov    %rax,%rdi
  800f8f:	48 b8 d7 08 80 00 00 	movabs $0x8008d7,%rax
  800f96:	00 00 00 
  800f99:	ff d0                	callq  *%rax
  800f9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f9f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fab:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fae:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbd:	45 89 c1             	mov    %r8d,%r9d
  800fc0:	41 89 f8             	mov    %edi,%r8d
  800fc3:	48 89 c7             	mov    %rax,%rdi
  800fc6:	48 b8 1c 08 80 00 00 	movabs $0x80081c,%rax
  800fcd:	00 00 00 
  800fd0:	ff d0                	callq  *%rax
			break;
  800fd2:	eb 3f                	jmp    801013 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fdc:	48 89 d6             	mov    %rdx,%rsi
  800fdf:	89 df                	mov    %ebx,%edi
  800fe1:	ff d0                	callq  *%rax
			break;
  800fe3:	eb 2e                	jmp    801013 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fed:	48 89 d6             	mov    %rdx,%rsi
  800ff0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ff5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ffc:	eb 05                	jmp    801003 <vprintfmt+0x50c>
  800ffe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801003:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801007:	48 83 e8 01          	sub    $0x1,%rax
  80100b:	0f b6 00             	movzbl (%rax),%eax
  80100e:	3c 25                	cmp    $0x25,%al
  801010:	75 ec                	jne    800ffe <vprintfmt+0x507>
				/* do nothing */;
			break;
  801012:	90                   	nop
		}
	}
  801013:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801014:	e9 30 fb ff ff       	jmpq   800b49 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801019:	48 83 c4 60          	add    $0x60,%rsp
  80101d:	5b                   	pop    %rbx
  80101e:	41 5c                	pop    %r12
  801020:	5d                   	pop    %rbp
  801021:	c3                   	retq   

0000000000801022 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801022:	55                   	push   %rbp
  801023:	48 89 e5             	mov    %rsp,%rbp
  801026:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80102d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801034:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80103b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801042:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801049:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801050:	84 c0                	test   %al,%al
  801052:	74 20                	je     801074 <printfmt+0x52>
  801054:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801058:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80105c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801060:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801064:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801068:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80106c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801070:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801074:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80107b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801082:	00 00 00 
  801085:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80108c:	00 00 00 
  80108f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801093:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80109a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010af:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010b6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010bd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010c4:	48 89 c7             	mov    %rax,%rdi
  8010c7:	48 b8 f7 0a 80 00 00 	movabs $0x800af7,%rax
  8010ce:	00 00 00 
  8010d1:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010d3:	c9                   	leaveq 
  8010d4:	c3                   	retq   

00000000008010d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010d5:	55                   	push   %rbp
  8010d6:	48 89 e5             	mov    %rsp,%rbp
  8010d9:	48 83 ec 10          	sub    $0x10,%rsp
  8010dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e8:	8b 40 10             	mov    0x10(%rax),%eax
  8010eb:	8d 50 01             	lea    0x1(%rax),%edx
  8010ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f9:	48 8b 10             	mov    (%rax),%rdx
  8010fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801100:	48 8b 40 08          	mov    0x8(%rax),%rax
  801104:	48 39 c2             	cmp    %rax,%rdx
  801107:	73 17                	jae    801120 <sprintputch+0x4b>
		*b->buf++ = ch;
  801109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110d:	48 8b 00             	mov    (%rax),%rax
  801110:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801114:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801118:	48 89 0a             	mov    %rcx,(%rdx)
  80111b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80111e:	88 10                	mov    %dl,(%rax)
}
  801120:	c9                   	leaveq 
  801121:	c3                   	retq   

0000000000801122 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801122:	55                   	push   %rbp
  801123:	48 89 e5             	mov    %rsp,%rbp
  801126:	48 83 ec 50          	sub    $0x50,%rsp
  80112a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80112e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801131:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801135:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801139:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80113d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801141:	48 8b 0a             	mov    (%rdx),%rcx
  801144:	48 89 08             	mov    %rcx,(%rax)
  801147:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80114b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801153:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80115b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80115f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801162:	48 98                	cltq   
  801164:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801168:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80116c:	48 01 d0             	add    %rdx,%rax
  80116f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801173:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80117a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80117f:	74 06                	je     801187 <vsnprintf+0x65>
  801181:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801185:	7f 07                	jg     80118e <vsnprintf+0x6c>
		return -E_INVAL;
  801187:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118c:	eb 2f                	jmp    8011bd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80118e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801192:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801196:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80119a:	48 89 c6             	mov    %rax,%rsi
  80119d:	48 bf d5 10 80 00 00 	movabs $0x8010d5,%rdi
  8011a4:	00 00 00 
  8011a7:	48 b8 f7 0a 80 00 00 	movabs $0x800af7,%rax
  8011ae:	00 00 00 
  8011b1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011b7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011ba:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011bd:	c9                   	leaveq 
  8011be:	c3                   	retq   

00000000008011bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011bf:	55                   	push   %rbp
  8011c0:	48 89 e5             	mov    %rsp,%rbp
  8011c3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011ca:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011d1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011d7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011de:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011e5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 20                	je     801210 <snprintf+0x51>
  8011f0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011f4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011f8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011fc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801200:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801204:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801208:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80120c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801210:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801217:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80121e:	00 00 00 
  801221:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801228:	00 00 00 
  80122b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80122f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801236:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80123d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801244:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80124b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801252:	48 8b 0a             	mov    (%rdx),%rcx
  801255:	48 89 08             	mov    %rcx,(%rax)
  801258:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80125c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801260:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801264:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801268:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80126f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801276:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80127c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801283:	48 89 c7             	mov    %rax,%rdi
  801286:	48 b8 22 11 80 00 00 	movabs $0x801122,%rax
  80128d:	00 00 00 
  801290:	ff d0                	callq  *%rax
  801292:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801298:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 18          	sub    $0x18,%rsp
  8012a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b3:	eb 09                	jmp    8012be <strlen+0x1e>
		n++;
  8012b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	84 c0                	test   %al,%al
  8012c7:	75 ec                	jne    8012b5 <strlen+0x15>
		n++;
	return n;
  8012c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 20          	sub    $0x20,%rsp
  8012d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012e5:	eb 0e                	jmp    8012f5 <strnlen+0x27>
		n++;
  8012e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012eb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012f5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012fa:	74 0b                	je     801307 <strnlen+0x39>
  8012fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801300:	0f b6 00             	movzbl (%rax),%eax
  801303:	84 c0                	test   %al,%al
  801305:	75 e0                	jne    8012e7 <strnlen+0x19>
		n++;
	return n;
  801307:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	48 83 ec 20          	sub    $0x20,%rsp
  801314:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801318:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80131c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801320:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801324:	90                   	nop
  801325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801329:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80132d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801331:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801335:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801339:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80133d:	0f b6 12             	movzbl (%rdx),%edx
  801340:	88 10                	mov    %dl,(%rax)
  801342:	0f b6 00             	movzbl (%rax),%eax
  801345:	84 c0                	test   %al,%al
  801347:	75 dc                	jne    801325 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80134d:	c9                   	leaveq 
  80134e:	c3                   	retq   

000000000080134f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80134f:	55                   	push   %rbp
  801350:	48 89 e5             	mov    %rsp,%rbp
  801353:	48 83 ec 20          	sub    $0x20,%rsp
  801357:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80135b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801363:	48 89 c7             	mov    %rax,%rdi
  801366:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  80136d:	00 00 00 
  801370:	ff d0                	callq  *%rax
  801372:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801378:	48 63 d0             	movslq %eax,%rdx
  80137b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137f:	48 01 c2             	add    %rax,%rdx
  801382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801386:	48 89 c6             	mov    %rax,%rsi
  801389:	48 89 d7             	mov    %rdx,%rdi
  80138c:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  801393:	00 00 00 
  801396:	ff d0                	callq  *%rax
	return dst;
  801398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 28          	sub    $0x28,%rsp
  8013a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013ba:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013c1:	00 
  8013c2:	eb 2a                	jmp    8013ee <strncpy+0x50>
		*dst++ = *src;
  8013c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013cc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d4:	0f b6 12             	movzbl (%rdx),%edx
  8013d7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	84 c0                	test   %al,%al
  8013e2:	74 05                	je     8013e9 <strncpy+0x4b>
			src++;
  8013e4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013f6:	72 cc                	jb     8013c4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013fc:	c9                   	leaveq 
  8013fd:	c3                   	retq   

00000000008013fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013fe:	55                   	push   %rbp
  8013ff:	48 89 e5             	mov    %rsp,%rbp
  801402:	48 83 ec 28          	sub    $0x28,%rsp
  801406:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801416:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80141a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80141f:	74 3d                	je     80145e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801421:	eb 1d                	jmp    801440 <strlcpy+0x42>
			*dst++ = *src++;
  801423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801427:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80142b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80142f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801433:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801437:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80143b:	0f b6 12             	movzbl (%rdx),%edx
  80143e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801440:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801445:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80144a:	74 0b                	je     801457 <strlcpy+0x59>
  80144c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	84 c0                	test   %al,%al
  801455:	75 cc                	jne    801423 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80145e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	48 29 c2             	sub    %rax,%rdx
  801469:	48 89 d0             	mov    %rdx,%rax
}
  80146c:	c9                   	leaveq 
  80146d:	c3                   	retq   

000000000080146e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80146e:	55                   	push   %rbp
  80146f:	48 89 e5             	mov    %rsp,%rbp
  801472:	48 83 ec 10          	sub    $0x10,%rsp
  801476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80147e:	eb 0a                	jmp    80148a <strcmp+0x1c>
		p++, q++;
  801480:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801485:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148e:	0f b6 00             	movzbl (%rax),%eax
  801491:	84 c0                	test   %al,%al
  801493:	74 12                	je     8014a7 <strcmp+0x39>
  801495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801499:	0f b6 10             	movzbl (%rax),%edx
  80149c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	38 c2                	cmp    %al,%dl
  8014a5:	74 d9                	je     801480 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	0f b6 d0             	movzbl %al,%edx
  8014b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b5:	0f b6 00             	movzbl (%rax),%eax
  8014b8:	0f b6 c0             	movzbl %al,%eax
  8014bb:	29 c2                	sub    %eax,%edx
  8014bd:	89 d0                	mov    %edx,%eax
}
  8014bf:	c9                   	leaveq 
  8014c0:	c3                   	retq   

00000000008014c1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014c1:	55                   	push   %rbp
  8014c2:	48 89 e5             	mov    %rsp,%rbp
  8014c5:	48 83 ec 18          	sub    $0x18,%rsp
  8014c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014d5:	eb 0f                	jmp    8014e6 <strncmp+0x25>
		n--, p++, q++;
  8014d7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014eb:	74 1d                	je     80150a <strncmp+0x49>
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	84 c0                	test   %al,%al
  8014f6:	74 12                	je     80150a <strncmp+0x49>
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 10             	movzbl (%rax),%edx
  8014ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	38 c2                	cmp    %al,%dl
  801508:	74 cd                	je     8014d7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80150a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80150f:	75 07                	jne    801518 <strncmp+0x57>
		return 0;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
  801516:	eb 18                	jmp    801530 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151c:	0f b6 00             	movzbl (%rax),%eax
  80151f:	0f b6 d0             	movzbl %al,%edx
  801522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801526:	0f b6 00             	movzbl (%rax),%eax
  801529:	0f b6 c0             	movzbl %al,%eax
  80152c:	29 c2                	sub    %eax,%edx
  80152e:	89 d0                	mov    %edx,%eax
}
  801530:	c9                   	leaveq 
  801531:	c3                   	retq   

0000000000801532 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801532:	55                   	push   %rbp
  801533:	48 89 e5             	mov    %rsp,%rbp
  801536:	48 83 ec 0c          	sub    $0xc,%rsp
  80153a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153e:	89 f0                	mov    %esi,%eax
  801540:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801543:	eb 17                	jmp    80155c <strchr+0x2a>
		if (*s == c)
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	0f b6 00             	movzbl (%rax),%eax
  80154c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80154f:	75 06                	jne    801557 <strchr+0x25>
			return (char *) s;
  801551:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801555:	eb 15                	jmp    80156c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801557:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	84 c0                	test   %al,%al
  801565:	75 de                	jne    801545 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156c:	c9                   	leaveq 
  80156d:	c3                   	retq   

000000000080156e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80156e:	55                   	push   %rbp
  80156f:	48 89 e5             	mov    %rsp,%rbp
  801572:	48 83 ec 0c          	sub    $0xc,%rsp
  801576:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157a:	89 f0                	mov    %esi,%eax
  80157c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80157f:	eb 13                	jmp    801594 <strfind+0x26>
		if (*s == c)
  801581:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80158b:	75 02                	jne    80158f <strfind+0x21>
			break;
  80158d:	eb 10                	jmp    80159f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80158f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	84 c0                	test   %al,%al
  80159d:	75 e2                	jne    801581 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80159f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a3:	c9                   	leaveq 
  8015a4:	c3                   	retq   

00000000008015a5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	48 83 ec 18          	sub    $0x18,%rsp
  8015ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015b4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015b8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015bd:	75 06                	jne    8015c5 <memset+0x20>
		return v;
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	eb 69                	jmp    80162e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c9:	83 e0 03             	and    $0x3,%eax
  8015cc:	48 85 c0             	test   %rax,%rax
  8015cf:	75 48                	jne    801619 <memset+0x74>
  8015d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d5:	83 e0 03             	and    $0x3,%eax
  8015d8:	48 85 c0             	test   %rax,%rax
  8015db:	75 3c                	jne    801619 <memset+0x74>
		c &= 0xFF;
  8015dd:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e7:	c1 e0 18             	shl    $0x18,%eax
  8015ea:	89 c2                	mov    %eax,%edx
  8015ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ef:	c1 e0 10             	shl    $0x10,%eax
  8015f2:	09 c2                	or     %eax,%edx
  8015f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f7:	c1 e0 08             	shl    $0x8,%eax
  8015fa:	09 d0                	or     %edx,%eax
  8015fc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801603:	48 c1 e8 02          	shr    $0x2,%rax
  801607:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80160a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801611:	48 89 d7             	mov    %rdx,%rdi
  801614:	fc                   	cld    
  801615:	f3 ab                	rep stos %eax,%es:(%rdi)
  801617:	eb 11                	jmp    80162a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801619:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80161d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801620:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801624:	48 89 d7             	mov    %rdx,%rdi
  801627:	fc                   	cld    
  801628:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80162a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80162e:	c9                   	leaveq 
  80162f:	c3                   	retq   

0000000000801630 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801630:	55                   	push   %rbp
  801631:	48 89 e5             	mov    %rsp,%rbp
  801634:	48 83 ec 28          	sub    $0x28,%rsp
  801638:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80163c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801640:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801644:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801648:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80164c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801650:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801658:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80165c:	0f 83 88 00 00 00    	jae    8016ea <memmove+0xba>
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166a:	48 01 d0             	add    %rdx,%rax
  80166d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801671:	76 77                	jbe    8016ea <memmove+0xba>
		s += n;
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801687:	83 e0 03             	and    $0x3,%eax
  80168a:	48 85 c0             	test   %rax,%rax
  80168d:	75 3b                	jne    8016ca <memmove+0x9a>
  80168f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801693:	83 e0 03             	and    $0x3,%eax
  801696:	48 85 c0             	test   %rax,%rax
  801699:	75 2f                	jne    8016ca <memmove+0x9a>
  80169b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169f:	83 e0 03             	and    $0x3,%eax
  8016a2:	48 85 c0             	test   %rax,%rax
  8016a5:	75 23                	jne    8016ca <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ab:	48 83 e8 04          	sub    $0x4,%rax
  8016af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b3:	48 83 ea 04          	sub    $0x4,%rdx
  8016b7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016bb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016bf:	48 89 c7             	mov    %rax,%rdi
  8016c2:	48 89 d6             	mov    %rdx,%rsi
  8016c5:	fd                   	std    
  8016c6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016c8:	eb 1d                	jmp    8016e7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ce:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016de:	48 89 d7             	mov    %rdx,%rdi
  8016e1:	48 89 c1             	mov    %rax,%rcx
  8016e4:	fd                   	std    
  8016e5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016e7:	fc                   	cld    
  8016e8:	eb 57                	jmp    801741 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ee:	83 e0 03             	and    $0x3,%eax
  8016f1:	48 85 c0             	test   %rax,%rax
  8016f4:	75 36                	jne    80172c <memmove+0xfc>
  8016f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fa:	83 e0 03             	and    $0x3,%eax
  8016fd:	48 85 c0             	test   %rax,%rax
  801700:	75 2a                	jne    80172c <memmove+0xfc>
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	83 e0 03             	and    $0x3,%eax
  801709:	48 85 c0             	test   %rax,%rax
  80170c:	75 1e                	jne    80172c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80170e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801712:	48 c1 e8 02          	shr    $0x2,%rax
  801716:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801721:	48 89 c7             	mov    %rax,%rdi
  801724:	48 89 d6             	mov    %rdx,%rsi
  801727:	fc                   	cld    
  801728:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80172a:	eb 15                	jmp    801741 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80172c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801730:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801734:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801738:	48 89 c7             	mov    %rax,%rdi
  80173b:	48 89 d6             	mov    %rdx,%rsi
  80173e:	fc                   	cld    
  80173f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801745:	c9                   	leaveq 
  801746:	c3                   	retq   

0000000000801747 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801747:	55                   	push   %rbp
  801748:	48 89 e5             	mov    %rsp,%rbp
  80174b:	48 83 ec 18          	sub    $0x18,%rsp
  80174f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801753:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801757:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80175b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801767:	48 89 ce             	mov    %rcx,%rsi
  80176a:	48 89 c7             	mov    %rax,%rdi
  80176d:	48 b8 30 16 80 00 00 	movabs $0x801630,%rax
  801774:	00 00 00 
  801777:	ff d0                	callq  *%rax
}
  801779:	c9                   	leaveq 
  80177a:	c3                   	retq   

000000000080177b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80177b:	55                   	push   %rbp
  80177c:	48 89 e5             	mov    %rsp,%rbp
  80177f:	48 83 ec 28          	sub    $0x28,%rsp
  801783:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801787:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80178b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80178f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801793:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801797:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80179b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80179f:	eb 36                	jmp    8017d7 <memcmp+0x5c>
		if (*s1 != *s2)
  8017a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a5:	0f b6 10             	movzbl (%rax),%edx
  8017a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	38 c2                	cmp    %al,%dl
  8017b1:	74 1a                	je     8017cd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	0f b6 d0             	movzbl %al,%edx
  8017bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c1:	0f b6 00             	movzbl (%rax),%eax
  8017c4:	0f b6 c0             	movzbl %al,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	eb 20                	jmp    8017ed <memcmp+0x72>
		s1++, s2++;
  8017cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017e3:	48 85 c0             	test   %rax,%rax
  8017e6:	75 b9                	jne    8017a1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ed:	c9                   	leaveq 
  8017ee:	c3                   	retq   

00000000008017ef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017ef:	55                   	push   %rbp
  8017f0:	48 89 e5             	mov    %rsp,%rbp
  8017f3:	48 83 ec 28          	sub    $0x28,%rsp
  8017f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180a:	48 01 d0             	add    %rdx,%rax
  80180d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801811:	eb 15                	jmp    801828 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801817:	0f b6 10             	movzbl (%rax),%edx
  80181a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80181d:	38 c2                	cmp    %al,%dl
  80181f:	75 02                	jne    801823 <memfind+0x34>
			break;
  801821:	eb 0f                	jmp    801832 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801823:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80182c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801830:	72 e1                	jb     801813 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801836:	c9                   	leaveq 
  801837:	c3                   	retq   

0000000000801838 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801838:	55                   	push   %rbp
  801839:	48 89 e5             	mov    %rsp,%rbp
  80183c:	48 83 ec 34          	sub    $0x34,%rsp
  801840:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801844:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801848:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80184b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801852:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801859:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185a:	eb 05                	jmp    801861 <strtol+0x29>
		s++;
  80185c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801865:	0f b6 00             	movzbl (%rax),%eax
  801868:	3c 20                	cmp    $0x20,%al
  80186a:	74 f0                	je     80185c <strtol+0x24>
  80186c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801870:	0f b6 00             	movzbl (%rax),%eax
  801873:	3c 09                	cmp    $0x9,%al
  801875:	74 e5                	je     80185c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	3c 2b                	cmp    $0x2b,%al
  801880:	75 07                	jne    801889 <strtol+0x51>
		s++;
  801882:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801887:	eb 17                	jmp    8018a0 <strtol+0x68>
	else if (*s == '-')
  801889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	3c 2d                	cmp    $0x2d,%al
  801892:	75 0c                	jne    8018a0 <strtol+0x68>
		s++, neg = 1;
  801894:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a4:	74 06                	je     8018ac <strtol+0x74>
  8018a6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018aa:	75 28                	jne    8018d4 <strtol+0x9c>
  8018ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b0:	0f b6 00             	movzbl (%rax),%eax
  8018b3:	3c 30                	cmp    $0x30,%al
  8018b5:	75 1d                	jne    8018d4 <strtol+0x9c>
  8018b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bb:	48 83 c0 01          	add    $0x1,%rax
  8018bf:	0f b6 00             	movzbl (%rax),%eax
  8018c2:	3c 78                	cmp    $0x78,%al
  8018c4:	75 0e                	jne    8018d4 <strtol+0x9c>
		s += 2, base = 16;
  8018c6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018cb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018d2:	eb 2c                	jmp    801900 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d8:	75 19                	jne    8018f3 <strtol+0xbb>
  8018da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	3c 30                	cmp    $0x30,%al
  8018e3:	75 0e                	jne    8018f3 <strtol+0xbb>
		s++, base = 8;
  8018e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ea:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018f1:	eb 0d                	jmp    801900 <strtol+0xc8>
	else if (base == 0)
  8018f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018f7:	75 07                	jne    801900 <strtol+0xc8>
		base = 10;
  8018f9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801900:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801904:	0f b6 00             	movzbl (%rax),%eax
  801907:	3c 2f                	cmp    $0x2f,%al
  801909:	7e 1d                	jle    801928 <strtol+0xf0>
  80190b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	3c 39                	cmp    $0x39,%al
  801914:	7f 12                	jg     801928 <strtol+0xf0>
			dig = *s - '0';
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	0f b6 00             	movzbl (%rax),%eax
  80191d:	0f be c0             	movsbl %al,%eax
  801920:	83 e8 30             	sub    $0x30,%eax
  801923:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801926:	eb 4e                	jmp    801976 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192c:	0f b6 00             	movzbl (%rax),%eax
  80192f:	3c 60                	cmp    $0x60,%al
  801931:	7e 1d                	jle    801950 <strtol+0x118>
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	0f b6 00             	movzbl (%rax),%eax
  80193a:	3c 7a                	cmp    $0x7a,%al
  80193c:	7f 12                	jg     801950 <strtol+0x118>
			dig = *s - 'a' + 10;
  80193e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801942:	0f b6 00             	movzbl (%rax),%eax
  801945:	0f be c0             	movsbl %al,%eax
  801948:	83 e8 57             	sub    $0x57,%eax
  80194b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80194e:	eb 26                	jmp    801976 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	0f b6 00             	movzbl (%rax),%eax
  801957:	3c 40                	cmp    $0x40,%al
  801959:	7e 48                	jle    8019a3 <strtol+0x16b>
  80195b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195f:	0f b6 00             	movzbl (%rax),%eax
  801962:	3c 5a                	cmp    $0x5a,%al
  801964:	7f 3d                	jg     8019a3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801966:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196a:	0f b6 00             	movzbl (%rax),%eax
  80196d:	0f be c0             	movsbl %al,%eax
  801970:	83 e8 37             	sub    $0x37,%eax
  801973:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801976:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801979:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80197c:	7c 02                	jl     801980 <strtol+0x148>
			break;
  80197e:	eb 23                	jmp    8019a3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801980:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801985:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801988:	48 98                	cltq   
  80198a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80198f:	48 89 c2             	mov    %rax,%rdx
  801992:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801995:	48 98                	cltq   
  801997:	48 01 d0             	add    %rdx,%rax
  80199a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80199e:	e9 5d ff ff ff       	jmpq   801900 <strtol+0xc8>

	if (endptr)
  8019a3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019a8:	74 0b                	je     8019b5 <strtol+0x17d>
		*endptr = (char *) s;
  8019aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019b2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019b9:	74 09                	je     8019c4 <strtol+0x18c>
  8019bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019bf:	48 f7 d8             	neg    %rax
  8019c2:	eb 04                	jmp    8019c8 <strtol+0x190>
  8019c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019c8:	c9                   	leaveq 
  8019c9:	c3                   	retq   

00000000008019ca <strstr>:

char * strstr(const char *in, const char *str)
{
  8019ca:	55                   	push   %rbp
  8019cb:	48 89 e5             	mov    %rsp,%rbp
  8019ce:	48 83 ec 30          	sub    $0x30,%rsp
  8019d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019ec:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019f0:	75 06                	jne    8019f8 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f6:	eb 6b                	jmp    801a63 <strstr+0x99>

	len = strlen(str);
  8019f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019fc:	48 89 c7             	mov    %rax,%rdi
  8019ff:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  801a06:	00 00 00 
  801a09:	ff d0                	callq  *%rax
  801a0b:	48 98                	cltq   
  801a0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a15:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a19:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a1d:	0f b6 00             	movzbl (%rax),%eax
  801a20:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a23:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a27:	75 07                	jne    801a30 <strstr+0x66>
				return (char *) 0;
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	eb 33                	jmp    801a63 <strstr+0x99>
		} while (sc != c);
  801a30:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a34:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a37:	75 d8                	jne    801a11 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	48 89 ce             	mov    %rcx,%rsi
  801a48:	48 89 c7             	mov    %rax,%rdi
  801a4b:	48 b8 c1 14 80 00 00 	movabs $0x8014c1,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
  801a57:	85 c0                	test   %eax,%eax
  801a59:	75 b6                	jne    801a11 <strstr+0x47>

	return (char *) (in - 1);
  801a5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5f:	48 83 e8 01          	sub    $0x1,%rax
}
  801a63:	c9                   	leaveq 
  801a64:	c3                   	retq   
