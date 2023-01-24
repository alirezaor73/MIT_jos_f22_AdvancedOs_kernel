
obj/user/evilhello:     file format elf64-x86-64


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
  80003c:	e8 2e 00 00 00       	callq  80006f <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0x800420000c, 100);
  800052:	be 64 00 00 00       	mov    $0x64,%esi
  800057:	48 bf 0c 00 20 04 80 	movabs $0x800420000c,%rdi
  80005e:	00 00 00 
  800061:	48 b8 a5 01 80 00 00 	movabs $0x8001a5,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
}
  80006d:	c9                   	leaveq 
  80006e:	c3                   	retq   

000000000080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %rbp
  800070:	48 89 e5             	mov    %rsp,%rbp
  800073:	48 83 ec 20          	sub    $0x20,%rsp
  800077:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80007a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80007e:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  800085:	00 00 00 
  800088:	ff d0                	callq  *%rax
  80008a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  80008d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	48 63 d0             	movslq %eax,%rdx
  800098:	48 89 d0             	mov    %rdx,%rax
  80009b:	48 c1 e0 03          	shl    $0x3,%rax
  80009f:	48 01 d0             	add    %rdx,%rax
  8000a2:	48 c1 e0 05          	shl    $0x5,%rax
  8000a6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000ad:	00 00 00 
  8000b0:	48 01 c2             	add    %rax,%rdx
  8000b3:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000ba:	00 00 00 
  8000bd:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000c4:	7e 14                	jle    8000da <libmain+0x6b>
		binaryname = argv[0];
  8000c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000ca:	48 8b 10             	mov    (%rax),%rdx
  8000cd:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000d4:	00 00 00 
  8000d7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e1:	48 89 d6             	mov    %rdx,%rsi
  8000e4:	89 c7                	mov    %eax,%edi
  8000e6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f2:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
}
  8000fe:	c9                   	leaveq 
  8000ff:	c3                   	retq   

0000000000800100 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800100:	55                   	push   %rbp
  800101:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800104:	bf 00 00 00 00       	mov    $0x0,%edi
  800109:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  800110:	00 00 00 
  800113:	ff d0                	callq  *%rax
}
  800115:	5d                   	pop    %rbp
  800116:	c3                   	retq   

0000000000800117 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800117:	55                   	push   %rbp
  800118:	48 89 e5             	mov    %rsp,%rbp
  80011b:	53                   	push   %rbx
  80011c:	48 83 ec 48          	sub    $0x48,%rsp
  800120:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800123:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800126:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80012a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80012e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800132:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800136:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800139:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80013d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800141:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800145:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800149:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80014d:	4c 89 c3             	mov    %r8,%rbx
  800150:	cd 30                	int    $0x30
  800152:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800156:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80015a:	74 3e                	je     80019a <syscall+0x83>
  80015c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800161:	7e 37                	jle    80019a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800163:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800167:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80016a:	49 89 d0             	mov    %rdx,%r8
  80016d:	89 c1                	mov    %eax,%ecx
  80016f:	48 ba 8a 1a 80 00 00 	movabs $0x801a8a,%rdx
  800176:	00 00 00 
  800179:	be 23 00 00 00       	mov    $0x23,%esi
  80017e:	48 bf a7 1a 80 00 00 	movabs $0x801aa7,%rdi
  800185:	00 00 00 
  800188:	b8 00 00 00 00       	mov    $0x0,%eax
  80018d:	49 b9 10 05 80 00 00 	movabs $0x800510,%r9
  800194:	00 00 00 
  800197:	41 ff d1             	callq  *%r9

	return ret;
  80019a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80019e:	48 83 c4 48          	add    $0x48,%rsp
  8001a2:	5b                   	pop    %rbx
  8001a3:	5d                   	pop    %rbp
  8001a4:	c3                   	retq   

00000000008001a5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a5:	55                   	push   %rbp
  8001a6:	48 89 e5             	mov    %rsp,%rbp
  8001a9:	48 83 ec 20          	sub    $0x20,%rsp
  8001ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c4:	00 
  8001c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d1:	48 89 d1             	mov    %rdx,%rcx
  8001d4:	48 89 c2             	mov    %rax,%rdx
  8001d7:	be 00 00 00 00       	mov    $0x0,%esi
  8001dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e1:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  8001e8:	00 00 00 
  8001eb:	ff d0                	callq  *%rax
}
  8001ed:	c9                   	leaveq 
  8001ee:	c3                   	retq   

00000000008001ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ef:	55                   	push   %rbp
  8001f0:	48 89 e5             	mov    %rsp,%rbp
  8001f3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001fe:	00 
  8001ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800205:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800210:	ba 00 00 00 00       	mov    $0x0,%edx
  800215:	be 00 00 00 00       	mov    $0x0,%esi
  80021a:	bf 01 00 00 00       	mov    $0x1,%edi
  80021f:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  800226:	00 00 00 
  800229:	ff d0                	callq  *%rax
}
  80022b:	c9                   	leaveq 
  80022c:	c3                   	retq   

000000000080022d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80022d:	55                   	push   %rbp
  80022e:	48 89 e5             	mov    %rsp,%rbp
  800231:	48 83 ec 10          	sub    $0x10,%rsp
  800235:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023b:	48 98                	cltq   
  80023d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800244:	00 
  800245:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80024b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800251:	b9 00 00 00 00       	mov    $0x0,%ecx
  800256:	48 89 c2             	mov    %rax,%rdx
  800259:	be 01 00 00 00       	mov    $0x1,%esi
  80025e:	bf 03 00 00 00       	mov    $0x3,%edi
  800263:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
}
  80026f:	c9                   	leaveq 
  800270:	c3                   	retq   

0000000000800271 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
  800275:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800279:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800280:	00 
  800281:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800287:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800292:	ba 00 00 00 00       	mov    $0x0,%edx
  800297:	be 00 00 00 00       	mov    $0x0,%esi
  80029c:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a1:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  8002a8:	00 00 00 
  8002ab:	ff d0                	callq  *%rax
}
  8002ad:	c9                   	leaveq 
  8002ae:	c3                   	retq   

00000000008002af <sys_yield>:

void
sys_yield(void)
{
  8002af:	55                   	push   %rbp
  8002b0:	48 89 e5             	mov    %rsp,%rbp
  8002b3:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002be:	00 
  8002bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d5:	be 00 00 00 00       	mov    $0x0,%esi
  8002da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002df:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  8002e6:	00 00 00 
  8002e9:	ff d0                	callq  *%rax
}
  8002eb:	c9                   	leaveq 
  8002ec:	c3                   	retq   

00000000008002ed <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002ed:	55                   	push   %rbp
  8002ee:	48 89 e5             	mov    %rsp,%rbp
  8002f1:	48 83 ec 20          	sub    $0x20,%rsp
  8002f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002fc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800302:	48 63 c8             	movslq %eax,%rcx
  800305:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	48 98                	cltq   
  80030e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800315:	00 
  800316:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80031c:	49 89 c8             	mov    %rcx,%r8
  80031f:	48 89 d1             	mov    %rdx,%rcx
  800322:	48 89 c2             	mov    %rax,%rdx
  800325:	be 01 00 00 00       	mov    $0x1,%esi
  80032a:	bf 04 00 00 00       	mov    $0x4,%edi
  80032f:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
}
  80033b:	c9                   	leaveq 
  80033c:	c3                   	retq   

000000000080033d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80033d:	55                   	push   %rbp
  80033e:	48 89 e5             	mov    %rsp,%rbp
  800341:	48 83 ec 30          	sub    $0x30,%rsp
  800345:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800348:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80034c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80034f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800353:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800357:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80035a:	48 63 c8             	movslq %eax,%rcx
  80035d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800361:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800364:	48 63 f0             	movslq %eax,%rsi
  800367:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80036e:	48 98                	cltq   
  800370:	48 89 0c 24          	mov    %rcx,(%rsp)
  800374:	49 89 f9             	mov    %rdi,%r9
  800377:	49 89 f0             	mov    %rsi,%r8
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	be 01 00 00 00       	mov    $0x1,%esi
  800385:	bf 05 00 00 00       	mov    $0x5,%edi
  80038a:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  800391:	00 00 00 
  800394:	ff d0                	callq  *%rax
}
  800396:	c9                   	leaveq 
  800397:	c3                   	retq   

0000000000800398 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800398:	55                   	push   %rbp
  800399:	48 89 e5             	mov    %rsp,%rbp
  80039c:	48 83 ec 20          	sub    $0x20,%rsp
  8003a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ae:	48 98                	cltq   
  8003b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003b7:	00 
  8003b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003c4:	48 89 d1             	mov    %rdx,%rcx
  8003c7:	48 89 c2             	mov    %rax,%rdx
  8003ca:	be 01 00 00 00       	mov    $0x1,%esi
  8003cf:	bf 06 00 00 00       	mov    $0x6,%edi
  8003d4:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
}
  8003e0:	c9                   	leaveq 
  8003e1:	c3                   	retq   

00000000008003e2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e2:	55                   	push   %rbp
  8003e3:	48 89 e5             	mov    %rsp,%rbp
  8003e6:	48 83 ec 10          	sub    $0x10,%rsp
  8003ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ed:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f3:	48 63 d0             	movslq %eax,%rdx
  8003f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f9:	48 98                	cltq   
  8003fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800402:	00 
  800403:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800409:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80040f:	48 89 d1             	mov    %rdx,%rcx
  800412:	48 89 c2             	mov    %rax,%rdx
  800415:	be 01 00 00 00       	mov    $0x1,%esi
  80041a:	bf 08 00 00 00       	mov    $0x8,%edi
  80041f:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  800426:	00 00 00 
  800429:	ff d0                	callq  *%rax
}
  80042b:	c9                   	leaveq 
  80042c:	c3                   	retq   

000000000080042d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80042d:	55                   	push   %rbp
  80042e:	48 89 e5             	mov    %rsp,%rbp
  800431:	48 83 ec 20          	sub    $0x20,%rsp
  800435:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800438:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80043c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800440:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800443:	48 98                	cltq   
  800445:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80044c:	00 
  80044d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800453:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800459:	48 89 d1             	mov    %rdx,%rcx
  80045c:	48 89 c2             	mov    %rax,%rdx
  80045f:	be 01 00 00 00       	mov    $0x1,%esi
  800464:	bf 09 00 00 00       	mov    $0x9,%edi
  800469:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  800470:	00 00 00 
  800473:	ff d0                	callq  *%rax
}
  800475:	c9                   	leaveq 
  800476:	c3                   	retq   

0000000000800477 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800477:	55                   	push   %rbp
  800478:	48 89 e5             	mov    %rsp,%rbp
  80047b:	48 83 ec 20          	sub    $0x20,%rsp
  80047f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800482:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800486:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80048a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80048d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800490:	48 63 f0             	movslq %eax,%rsi
  800493:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049a:	48 98                	cltq   
  80049c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a7:	00 
  8004a8:	49 89 f1             	mov    %rsi,%r9
  8004ab:	49 89 c8             	mov    %rcx,%r8
  8004ae:	48 89 d1             	mov    %rdx,%rcx
  8004b1:	48 89 c2             	mov    %rax,%rdx
  8004b4:	be 00 00 00 00       	mov    $0x0,%esi
  8004b9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004be:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  8004c5:	00 00 00 
  8004c8:	ff d0                	callq  *%rax
}
  8004ca:	c9                   	leaveq 
  8004cb:	c3                   	retq   

00000000008004cc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004cc:	55                   	push   %rbp
  8004cd:	48 89 e5             	mov    %rsp,%rbp
  8004d0:	48 83 ec 10          	sub    $0x10,%rsp
  8004d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e3:	00 
  8004e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f5:	48 89 c2             	mov    %rax,%rdx
  8004f8:	be 01 00 00 00       	mov    $0x1,%esi
  8004fd:	bf 0c 00 00 00       	mov    $0xc,%edi
  800502:	48 b8 17 01 80 00 00 	movabs $0x800117,%rax
  800509:	00 00 00 
  80050c:	ff d0                	callq  *%rax
}
  80050e:	c9                   	leaveq 
  80050f:	c3                   	retq   

0000000000800510 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800510:	55                   	push   %rbp
  800511:	48 89 e5             	mov    %rsp,%rbp
  800514:	53                   	push   %rbx
  800515:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800523:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800529:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800530:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800537:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80053e:	84 c0                	test   %al,%al
  800540:	74 23                	je     800565 <_panic+0x55>
  800542:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800549:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80054d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800551:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800555:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800559:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80055d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800561:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800565:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800573:	00 00 00 
  800576:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80057d:	00 00 00 
  800580:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800584:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80058b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800592:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800599:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005a0:	00 00 00 
  8005a3:	48 8b 18             	mov    (%rax),%rbx
  8005a6:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  8005ad:	00 00 00 
  8005b0:	ff d0                	callq  *%rax
  8005b2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005b8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005bf:	41 89 c8             	mov    %ecx,%r8d
  8005c2:	48 89 d1             	mov    %rdx,%rcx
  8005c5:	48 89 da             	mov    %rbx,%rdx
  8005c8:	89 c6                	mov    %eax,%esi
  8005ca:	48 bf b8 1a 80 00 00 	movabs $0x801ab8,%rdi
  8005d1:	00 00 00 
  8005d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d9:	49 b9 49 07 80 00 00 	movabs $0x800749,%r9
  8005e0:	00 00 00 
  8005e3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005ed:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f4:	48 89 d6             	mov    %rdx,%rsi
  8005f7:	48 89 c7             	mov    %rax,%rdi
  8005fa:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  800601:	00 00 00 
  800604:	ff d0                	callq  *%rax
	cprintf("\n");
  800606:	48 bf db 1a 80 00 00 	movabs $0x801adb,%rdi
  80060d:	00 00 00 
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	48 ba 49 07 80 00 00 	movabs $0x800749,%rdx
  80061c:	00 00 00 
  80061f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800621:	cc                   	int3   
  800622:	eb fd                	jmp    800621 <_panic+0x111>

0000000000800624 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800624:	55                   	push   %rbp
  800625:	48 89 e5             	mov    %rsp,%rbp
  800628:	48 83 ec 10          	sub    $0x10,%rsp
  80062c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80062f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800637:	8b 00                	mov    (%rax),%eax
  800639:	8d 48 01             	lea    0x1(%rax),%ecx
  80063c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800640:	89 0a                	mov    %ecx,(%rdx)
  800642:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800645:	89 d1                	mov    %edx,%ecx
  800647:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064b:	48 98                	cltq   
  80064d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800651:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800655:	8b 00                	mov    (%rax),%eax
  800657:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065c:	75 2c                	jne    80068a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80065e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800662:	8b 00                	mov    (%rax),%eax
  800664:	48 98                	cltq   
  800666:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066a:	48 83 c2 08          	add    $0x8,%rdx
  80066e:	48 89 c6             	mov    %rax,%rsi
  800671:	48 89 d7             	mov    %rdx,%rdi
  800674:	48 b8 a5 01 80 00 00 	movabs $0x8001a5,%rax
  80067b:	00 00 00 
  80067e:	ff d0                	callq  *%rax
        b->idx = 0;
  800680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800684:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80068a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068e:	8b 40 04             	mov    0x4(%rax),%eax
  800691:	8d 50 01             	lea    0x1(%rax),%edx
  800694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800698:	89 50 04             	mov    %edx,0x4(%rax)
}
  80069b:	c9                   	leaveq 
  80069c:	c3                   	retq   

000000000080069d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80069d:	55                   	push   %rbp
  80069e:	48 89 e5             	mov    %rsp,%rbp
  8006a1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006af:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006b6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006bd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c4:	48 8b 0a             	mov    (%rdx),%rcx
  8006c7:	48 89 08             	mov    %rcx,(%rax)
  8006ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e1:	00 00 00 
    b.cnt = 0;
  8006e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006eb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006ee:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f5:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006fc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800703:	48 89 c6             	mov    %rax,%rsi
  800706:	48 bf 24 06 80 00 00 	movabs $0x800624,%rdi
  80070d:	00 00 00 
  800710:	48 b8 fc 0a 80 00 00 	movabs $0x800afc,%rax
  800717:	00 00 00 
  80071a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80071c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800722:	48 98                	cltq   
  800724:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80072b:	48 83 c2 08          	add    $0x8,%rdx
  80072f:	48 89 c6             	mov    %rax,%rsi
  800732:	48 89 d7             	mov    %rdx,%rdi
  800735:	48 b8 a5 01 80 00 00 	movabs $0x8001a5,%rax
  80073c:	00 00 00 
  80073f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800741:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800747:	c9                   	leaveq 
  800748:	c3                   	retq   

0000000000800749 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800749:	55                   	push   %rbp
  80074a:	48 89 e5             	mov    %rsp,%rbp
  80074d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800754:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80075b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800762:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800769:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800770:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800777:	84 c0                	test   %al,%al
  800779:	74 20                	je     80079b <cprintf+0x52>
  80077b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80077f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800783:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800787:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80078b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80078f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800793:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800797:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80079b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007a2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007a9:	00 00 00 
  8007ac:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b3:	00 00 00 
  8007b6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007ba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007cf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007dd:	48 8b 0a             	mov    (%rdx),%rcx
  8007e0:	48 89 08             	mov    %rcx,(%rax)
  8007e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007f3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800801:	48 89 d6             	mov    %rdx,%rsi
  800804:	48 89 c7             	mov    %rax,%rdi
  800807:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  80080e:	00 00 00 
  800811:	ff d0                	callq  *%rax
  800813:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800819:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80081f:	c9                   	leaveq 
  800820:	c3                   	retq   

0000000000800821 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800821:	55                   	push   %rbp
  800822:	48 89 e5             	mov    %rsp,%rbp
  800825:	53                   	push   %rbx
  800826:	48 83 ec 38          	sub    $0x38,%rsp
  80082a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80082e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800832:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800836:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800839:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80083d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800841:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800844:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800848:	77 3b                	ja     800885 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80084d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800851:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800858:	ba 00 00 00 00       	mov    $0x0,%edx
  80085d:	48 f7 f3             	div    %rbx
  800860:	48 89 c2             	mov    %rax,%rdx
  800863:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800866:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800869:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80086d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800871:	41 89 f9             	mov    %edi,%r9d
  800874:	48 89 c7             	mov    %rax,%rdi
  800877:	48 b8 21 08 80 00 00 	movabs $0x800821,%rax
  80087e:	00 00 00 
  800881:	ff d0                	callq  *%rax
  800883:	eb 1e                	jmp    8008a3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800885:	eb 12                	jmp    800899 <printnum+0x78>
			putch(padc, putdat);
  800887:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80088b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80088e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800892:	48 89 ce             	mov    %rcx,%rsi
  800895:	89 d7                	mov    %edx,%edi
  800897:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800899:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80089d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008a1:	7f e4                	jg     800887 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008af:	48 f7 f1             	div    %rcx
  8008b2:	48 89 d0             	mov    %rdx,%rax
  8008b5:	48 ba 30 1c 80 00 00 	movabs $0x801c30,%rdx
  8008bc:	00 00 00 
  8008bf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008c3:	0f be d0             	movsbl %al,%edx
  8008c6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ce:	48 89 ce             	mov    %rcx,%rsi
  8008d1:	89 d7                	mov    %edx,%edi
  8008d3:	ff d0                	callq  *%rax
}
  8008d5:	48 83 c4 38          	add    $0x38,%rsp
  8008d9:	5b                   	pop    %rbx
  8008da:	5d                   	pop    %rbp
  8008db:	c3                   	retq   

00000000008008dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008eb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ef:	7e 52                	jle    800943 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f5:	8b 00                	mov    (%rax),%eax
  8008f7:	83 f8 30             	cmp    $0x30,%eax
  8008fa:	73 24                	jae    800920 <getuint+0x44>
  8008fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800900:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	8b 00                	mov    (%rax),%eax
  80090a:	89 c0                	mov    %eax,%eax
  80090c:	48 01 d0             	add    %rdx,%rax
  80090f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800913:	8b 12                	mov    (%rdx),%edx
  800915:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091c:	89 0a                	mov    %ecx,(%rdx)
  80091e:	eb 17                	jmp    800937 <getuint+0x5b>
  800920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800924:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800928:	48 89 d0             	mov    %rdx,%rax
  80092b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80092f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800933:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800937:	48 8b 00             	mov    (%rax),%rax
  80093a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093e:	e9 a3 00 00 00       	jmpq   8009e6 <getuint+0x10a>
	else if (lflag)
  800943:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800947:	74 4f                	je     800998 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094d:	8b 00                	mov    (%rax),%eax
  80094f:	83 f8 30             	cmp    $0x30,%eax
  800952:	73 24                	jae    800978 <getuint+0x9c>
  800954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800958:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	8b 00                	mov    (%rax),%eax
  800962:	89 c0                	mov    %eax,%eax
  800964:	48 01 d0             	add    %rdx,%rax
  800967:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096b:	8b 12                	mov    (%rdx),%edx
  80096d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	89 0a                	mov    %ecx,(%rdx)
  800976:	eb 17                	jmp    80098f <getuint+0xb3>
  800978:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800980:	48 89 d0             	mov    %rdx,%rax
  800983:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800987:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80098f:	48 8b 00             	mov    (%rax),%rax
  800992:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800996:	eb 4e                	jmp    8009e6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099c:	8b 00                	mov    (%rax),%eax
  80099e:	83 f8 30             	cmp    $0x30,%eax
  8009a1:	73 24                	jae    8009c7 <getuint+0xeb>
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	8b 00                	mov    (%rax),%eax
  8009b1:	89 c0                	mov    %eax,%eax
  8009b3:	48 01 d0             	add    %rdx,%rax
  8009b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ba:	8b 12                	mov    (%rdx),%edx
  8009bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c3:	89 0a                	mov    %ecx,(%rdx)
  8009c5:	eb 17                	jmp    8009de <getuint+0x102>
  8009c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009cf:	48 89 d0             	mov    %rdx,%rax
  8009d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009de:	8b 00                	mov    (%rax),%eax
  8009e0:	89 c0                	mov    %eax,%eax
  8009e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009ea:	c9                   	leaveq 
  8009eb:	c3                   	retq   

00000000008009ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ec:	55                   	push   %rbp
  8009ed:	48 89 e5             	mov    %rsp,%rbp
  8009f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009ff:	7e 52                	jle    800a53 <getint+0x67>
		x=va_arg(*ap, long long);
  800a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a05:	8b 00                	mov    (%rax),%eax
  800a07:	83 f8 30             	cmp    $0x30,%eax
  800a0a:	73 24                	jae    800a30 <getint+0x44>
  800a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a10:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a18:	8b 00                	mov    (%rax),%eax
  800a1a:	89 c0                	mov    %eax,%eax
  800a1c:	48 01 d0             	add    %rdx,%rax
  800a1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a23:	8b 12                	mov    (%rdx),%edx
  800a25:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2c:	89 0a                	mov    %ecx,(%rdx)
  800a2e:	eb 17                	jmp    800a47 <getint+0x5b>
  800a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a34:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a38:	48 89 d0             	mov    %rdx,%rax
  800a3b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a43:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a47:	48 8b 00             	mov    (%rax),%rax
  800a4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a4e:	e9 a3 00 00 00       	jmpq   800af6 <getint+0x10a>
	else if (lflag)
  800a53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a57:	74 4f                	je     800aa8 <getint+0xbc>
		x=va_arg(*ap, long);
  800a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5d:	8b 00                	mov    (%rax),%eax
  800a5f:	83 f8 30             	cmp    $0x30,%eax
  800a62:	73 24                	jae    800a88 <getint+0x9c>
  800a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a68:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a70:	8b 00                	mov    (%rax),%eax
  800a72:	89 c0                	mov    %eax,%eax
  800a74:	48 01 d0             	add    %rdx,%rax
  800a77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7b:	8b 12                	mov    (%rdx),%edx
  800a7d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a84:	89 0a                	mov    %ecx,(%rdx)
  800a86:	eb 17                	jmp    800a9f <getint+0xb3>
  800a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a90:	48 89 d0             	mov    %rdx,%rax
  800a93:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9f:	48 8b 00             	mov    (%rax),%rax
  800aa2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa6:	eb 4e                	jmp    800af6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aac:	8b 00                	mov    (%rax),%eax
  800aae:	83 f8 30             	cmp    $0x30,%eax
  800ab1:	73 24                	jae    800ad7 <getint+0xeb>
  800ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abf:	8b 00                	mov    (%rax),%eax
  800ac1:	89 c0                	mov    %eax,%eax
  800ac3:	48 01 d0             	add    %rdx,%rax
  800ac6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aca:	8b 12                	mov    (%rdx),%edx
  800acc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800acf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad3:	89 0a                	mov    %ecx,(%rdx)
  800ad5:	eb 17                	jmp    800aee <getint+0x102>
  800ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800adf:	48 89 d0             	mov    %rdx,%rax
  800ae2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aee:	8b 00                	mov    (%rax),%eax
  800af0:	48 98                	cltq   
  800af2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800afa:	c9                   	leaveq 
  800afb:	c3                   	retq   

0000000000800afc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800afc:	55                   	push   %rbp
  800afd:	48 89 e5             	mov    %rsp,%rbp
  800b00:	41 54                	push   %r12
  800b02:	53                   	push   %rbx
  800b03:	48 83 ec 60          	sub    $0x60,%rsp
  800b07:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b0b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b13:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b1f:	48 8b 0a             	mov    (%rdx),%rcx
  800b22:	48 89 08             	mov    %rcx,(%rax)
  800b25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b35:	eb 17                	jmp    800b4e <vprintfmt+0x52>
			if (ch == '\0')
  800b37:	85 db                	test   %ebx,%ebx
  800b39:	0f 84 df 04 00 00    	je     80101e <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800b3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b47:	48 89 d6             	mov    %rdx,%rsi
  800b4a:	89 df                	mov    %ebx,%edi
  800b4c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b52:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b56:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b5a:	0f b6 00             	movzbl (%rax),%eax
  800b5d:	0f b6 d8             	movzbl %al,%ebx
  800b60:	83 fb 25             	cmp    $0x25,%ebx
  800b63:	75 d2                	jne    800b37 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b65:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b69:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b77:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b7e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b85:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b89:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b8d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b91:	0f b6 00             	movzbl (%rax),%eax
  800b94:	0f b6 d8             	movzbl %al,%ebx
  800b97:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b9a:	83 f8 55             	cmp    $0x55,%eax
  800b9d:	0f 87 47 04 00 00    	ja     800fea <vprintfmt+0x4ee>
  800ba3:	89 c0                	mov    %eax,%eax
  800ba5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bac:	00 
  800bad:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  800bb4:	00 00 00 
  800bb7:	48 01 d0             	add    %rdx,%rax
  800bba:	48 8b 00             	mov    (%rax),%rax
  800bbd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bbf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bc3:	eb c0                	jmp    800b85 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bc9:	eb ba                	jmp    800b85 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bcb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bd2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bd5:	89 d0                	mov    %edx,%eax
  800bd7:	c1 e0 02             	shl    $0x2,%eax
  800bda:	01 d0                	add    %edx,%eax
  800bdc:	01 c0                	add    %eax,%eax
  800bde:	01 d8                	add    %ebx,%eax
  800be0:	83 e8 30             	sub    $0x30,%eax
  800be3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bea:	0f b6 00             	movzbl (%rax),%eax
  800bed:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf3:	7e 0c                	jle    800c01 <vprintfmt+0x105>
  800bf5:	83 fb 39             	cmp    $0x39,%ebx
  800bf8:	7f 07                	jg     800c01 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfa:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bff:	eb d1                	jmp    800bd2 <vprintfmt+0xd6>
			goto process_precision;
  800c01:	eb 58                	jmp    800c5b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c06:	83 f8 30             	cmp    $0x30,%eax
  800c09:	73 17                	jae    800c22 <vprintfmt+0x126>
  800c0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c12:	89 c0                	mov    %eax,%eax
  800c14:	48 01 d0             	add    %rdx,%rax
  800c17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c1a:	83 c2 08             	add    $0x8,%edx
  800c1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c20:	eb 0f                	jmp    800c31 <vprintfmt+0x135>
  800c22:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c26:	48 89 d0             	mov    %rdx,%rax
  800c29:	48 83 c2 08          	add    $0x8,%rdx
  800c2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c31:	8b 00                	mov    (%rax),%eax
  800c33:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c36:	eb 23                	jmp    800c5b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3c:	79 0c                	jns    800c4a <vprintfmt+0x14e>
				width = 0;
  800c3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c45:	e9 3b ff ff ff       	jmpq   800b85 <vprintfmt+0x89>
  800c4a:	e9 36 ff ff ff       	jmpq   800b85 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c4f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c56:	e9 2a ff ff ff       	jmpq   800b85 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5f:	79 12                	jns    800c73 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c61:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c64:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c67:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c6e:	e9 12 ff ff ff       	jmpq   800b85 <vprintfmt+0x89>
  800c73:	e9 0d ff ff ff       	jmpq   800b85 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c78:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c7c:	e9 04 ff ff ff       	jmpq   800b85 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c84:	83 f8 30             	cmp    $0x30,%eax
  800c87:	73 17                	jae    800ca0 <vprintfmt+0x1a4>
  800c89:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c90:	89 c0                	mov    %eax,%eax
  800c92:	48 01 d0             	add    %rdx,%rax
  800c95:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c98:	83 c2 08             	add    $0x8,%edx
  800c9b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9e:	eb 0f                	jmp    800caf <vprintfmt+0x1b3>
  800ca0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca4:	48 89 d0             	mov    %rdx,%rax
  800ca7:	48 83 c2 08          	add    $0x8,%rdx
  800cab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800caf:	8b 10                	mov    (%rax),%edx
  800cb1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb9:	48 89 ce             	mov    %rcx,%rsi
  800cbc:	89 d7                	mov    %edx,%edi
  800cbe:	ff d0                	callq  *%rax
			break;
  800cc0:	e9 53 03 00 00       	jmpq   801018 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc8:	83 f8 30             	cmp    $0x30,%eax
  800ccb:	73 17                	jae    800ce4 <vprintfmt+0x1e8>
  800ccd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd4:	89 c0                	mov    %eax,%eax
  800cd6:	48 01 d0             	add    %rdx,%rax
  800cd9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cdc:	83 c2 08             	add    $0x8,%edx
  800cdf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce2:	eb 0f                	jmp    800cf3 <vprintfmt+0x1f7>
  800ce4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce8:	48 89 d0             	mov    %rdx,%rax
  800ceb:	48 83 c2 08          	add    $0x8,%rdx
  800cef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cf5:	85 db                	test   %ebx,%ebx
  800cf7:	79 02                	jns    800cfb <vprintfmt+0x1ff>
				err = -err;
  800cf9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cfb:	83 fb 15             	cmp    $0x15,%ebx
  800cfe:	7f 16                	jg     800d16 <vprintfmt+0x21a>
  800d00:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800d07:	00 00 00 
  800d0a:	48 63 d3             	movslq %ebx,%rdx
  800d0d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d11:	4d 85 e4             	test   %r12,%r12
  800d14:	75 2e                	jne    800d44 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d16:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1e:	89 d9                	mov    %ebx,%ecx
  800d20:	48 ba 41 1c 80 00 00 	movabs $0x801c41,%rdx
  800d27:	00 00 00 
  800d2a:	48 89 c7             	mov    %rax,%rdi
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	49 b8 27 10 80 00 00 	movabs $0x801027,%r8
  800d39:	00 00 00 
  800d3c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d3f:	e9 d4 02 00 00       	jmpq   801018 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d44:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4c:	4c 89 e1             	mov    %r12,%rcx
  800d4f:	48 ba 4a 1c 80 00 00 	movabs $0x801c4a,%rdx
  800d56:	00 00 00 
  800d59:	48 89 c7             	mov    %rax,%rdi
  800d5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d61:	49 b8 27 10 80 00 00 	movabs $0x801027,%r8
  800d68:	00 00 00 
  800d6b:	41 ff d0             	callq  *%r8
			break;
  800d6e:	e9 a5 02 00 00       	jmpq   801018 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d76:	83 f8 30             	cmp    $0x30,%eax
  800d79:	73 17                	jae    800d92 <vprintfmt+0x296>
  800d7b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d82:	89 c0                	mov    %eax,%eax
  800d84:	48 01 d0             	add    %rdx,%rax
  800d87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8a:	83 c2 08             	add    $0x8,%edx
  800d8d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d90:	eb 0f                	jmp    800da1 <vprintfmt+0x2a5>
  800d92:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d96:	48 89 d0             	mov    %rdx,%rax
  800d99:	48 83 c2 08          	add    $0x8,%rdx
  800d9d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da1:	4c 8b 20             	mov    (%rax),%r12
  800da4:	4d 85 e4             	test   %r12,%r12
  800da7:	75 0a                	jne    800db3 <vprintfmt+0x2b7>
				p = "(null)";
  800da9:	49 bc 4d 1c 80 00 00 	movabs $0x801c4d,%r12
  800db0:	00 00 00 
			if (width > 0 && padc != '-')
  800db3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db7:	7e 3f                	jle    800df8 <vprintfmt+0x2fc>
  800db9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dbd:	74 39                	je     800df8 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dc2:	48 98                	cltq   
  800dc4:	48 89 c6             	mov    %rax,%rsi
  800dc7:	4c 89 e7             	mov    %r12,%rdi
  800dca:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  800dd1:	00 00 00 
  800dd4:	ff d0                	callq  *%rax
  800dd6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dd9:	eb 17                	jmp    800df2 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ddb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ddf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800de3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de7:	48 89 ce             	mov    %rcx,%rsi
  800dea:	89 d7                	mov    %edx,%edi
  800dec:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dee:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800df2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df6:	7f e3                	jg     800ddb <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df8:	eb 37                	jmp    800e31 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800dfa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800dfe:	74 1e                	je     800e1e <vprintfmt+0x322>
  800e00:	83 fb 1f             	cmp    $0x1f,%ebx
  800e03:	7e 05                	jle    800e0a <vprintfmt+0x30e>
  800e05:	83 fb 7e             	cmp    $0x7e,%ebx
  800e08:	7e 14                	jle    800e1e <vprintfmt+0x322>
					putch('?', putdat);
  800e0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e12:	48 89 d6             	mov    %rdx,%rsi
  800e15:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e1a:	ff d0                	callq  *%rax
  800e1c:	eb 0f                	jmp    800e2d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e26:	48 89 d6             	mov    %rdx,%rsi
  800e29:	89 df                	mov    %ebx,%edi
  800e2b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e31:	4c 89 e0             	mov    %r12,%rax
  800e34:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e38:	0f b6 00             	movzbl (%rax),%eax
  800e3b:	0f be d8             	movsbl %al,%ebx
  800e3e:	85 db                	test   %ebx,%ebx
  800e40:	74 10                	je     800e52 <vprintfmt+0x356>
  800e42:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e46:	78 b2                	js     800dfa <vprintfmt+0x2fe>
  800e48:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e4c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e50:	79 a8                	jns    800dfa <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e52:	eb 16                	jmp    800e6a <vprintfmt+0x36e>
				putch(' ', putdat);
  800e54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5c:	48 89 d6             	mov    %rdx,%rsi
  800e5f:	bf 20 00 00 00       	mov    $0x20,%edi
  800e64:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e66:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e6e:	7f e4                	jg     800e54 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e70:	e9 a3 01 00 00       	jmpq   801018 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e79:	be 03 00 00 00       	mov    $0x3,%esi
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 ec 09 80 00 00 	movabs $0x8009ec,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
  800e8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e95:	48 85 c0             	test   %rax,%rax
  800e98:	79 1d                	jns    800eb7 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea2:	48 89 d6             	mov    %rdx,%rsi
  800ea5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eaa:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb0:	48 f7 d8             	neg    %rax
  800eb3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eb7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ebe:	e9 e8 00 00 00       	jmpq   800fab <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ec3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec7:	be 03 00 00 00       	mov    $0x3,%esi
  800ecc:	48 89 c7             	mov    %rax,%rdi
  800ecf:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800ed6:	00 00 00 
  800ed9:	ff d0                	callq  *%rax
  800edb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800edf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ee6:	e9 c0 00 00 00       	jmpq   800fab <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eeb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef3:	48 89 d6             	mov    %rdx,%rsi
  800ef6:	bf 58 00 00 00       	mov    $0x58,%edi
  800efb:	ff d0                	callq  *%rax
			putch('X', putdat);
  800efd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f05:	48 89 d6             	mov    %rdx,%rsi
  800f08:	bf 58 00 00 00       	mov    $0x58,%edi
  800f0d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f17:	48 89 d6             	mov    %rdx,%rsi
  800f1a:	bf 58 00 00 00       	mov    $0x58,%edi
  800f1f:	ff d0                	callq  *%rax
			break;
  800f21:	e9 f2 00 00 00       	jmpq   801018 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2e:	48 89 d6             	mov    %rdx,%rsi
  800f31:	bf 30 00 00 00       	mov    $0x30,%edi
  800f36:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f40:	48 89 d6             	mov    %rdx,%rsi
  800f43:	bf 78 00 00 00       	mov    $0x78,%edi
  800f48:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4d:	83 f8 30             	cmp    $0x30,%eax
  800f50:	73 17                	jae    800f69 <vprintfmt+0x46d>
  800f52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f59:	89 c0                	mov    %eax,%eax
  800f5b:	48 01 d0             	add    %rdx,%rax
  800f5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f61:	83 c2 08             	add    $0x8,%edx
  800f64:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f67:	eb 0f                	jmp    800f78 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f6d:	48 89 d0             	mov    %rdx,%rax
  800f70:	48 83 c2 08          	add    $0x8,%rdx
  800f74:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f78:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f7f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f86:	eb 23                	jmp    800fab <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f88:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f8c:	be 03 00 00 00       	mov    $0x3,%esi
  800f91:	48 89 c7             	mov    %rax,%rdi
  800f94:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	callq  *%rax
  800fa0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fa4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fab:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fb0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fb3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc2:	45 89 c1             	mov    %r8d,%r9d
  800fc5:	41 89 f8             	mov    %edi,%r8d
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 21 08 80 00 00 	movabs $0x800821,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
			break;
  800fd7:	eb 3f                	jmp    801018 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe1:	48 89 d6             	mov    %rdx,%rsi
  800fe4:	89 df                	mov    %ebx,%edi
  800fe6:	ff d0                	callq  *%rax
			break;
  800fe8:	eb 2e                	jmp    801018 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff2:	48 89 d6             	mov    %rdx,%rsi
  800ff5:	bf 25 00 00 00       	mov    $0x25,%edi
  800ffa:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ffc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801001:	eb 05                	jmp    801008 <vprintfmt+0x50c>
  801003:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801008:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80100c:	48 83 e8 01          	sub    $0x1,%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	3c 25                	cmp    $0x25,%al
  801015:	75 ec                	jne    801003 <vprintfmt+0x507>
				/* do nothing */;
			break;
  801017:	90                   	nop
		}
	}
  801018:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801019:	e9 30 fb ff ff       	jmpq   800b4e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80101e:	48 83 c4 60          	add    $0x60,%rsp
  801022:	5b                   	pop    %rbx
  801023:	41 5c                	pop    %r12
  801025:	5d                   	pop    %rbp
  801026:	c3                   	retq   

0000000000801027 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801032:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801039:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801040:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801047:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80104e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801055:	84 c0                	test   %al,%al
  801057:	74 20                	je     801079 <printfmt+0x52>
  801059:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80105d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801061:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801065:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801069:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80106d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801071:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801075:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801079:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801080:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801087:	00 00 00 
  80108a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801091:	00 00 00 
  801094:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801098:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80109f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010ad:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010b4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010bb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010c2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010c9:	48 89 c7             	mov    %rax,%rdi
  8010cc:	48 b8 fc 0a 80 00 00 	movabs $0x800afc,%rax
  8010d3:	00 00 00 
  8010d6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010d8:	c9                   	leaveq 
  8010d9:	c3                   	retq   

00000000008010da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010da:	55                   	push   %rbp
  8010db:	48 89 e5             	mov    %rsp,%rbp
  8010de:	48 83 ec 10          	sub    $0x10,%rsp
  8010e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ed:	8b 40 10             	mov    0x10(%rax),%eax
  8010f0:	8d 50 01             	lea    0x1(%rax),%edx
  8010f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fe:	48 8b 10             	mov    (%rax),%rdx
  801101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801105:	48 8b 40 08          	mov    0x8(%rax),%rax
  801109:	48 39 c2             	cmp    %rax,%rdx
  80110c:	73 17                	jae    801125 <sprintputch+0x4b>
		*b->buf++ = ch;
  80110e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801112:	48 8b 00             	mov    (%rax),%rax
  801115:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801119:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80111d:	48 89 0a             	mov    %rcx,(%rdx)
  801120:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801123:	88 10                	mov    %dl,(%rax)
}
  801125:	c9                   	leaveq 
  801126:	c3                   	retq   

0000000000801127 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	48 83 ec 50          	sub    $0x50,%rsp
  80112f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801133:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801136:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80113a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80113e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801142:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801146:	48 8b 0a             	mov    (%rdx),%rcx
  801149:	48 89 08             	mov    %rcx,(%rax)
  80114c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801150:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801154:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801158:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80115c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801160:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801164:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801167:	48 98                	cltq   
  801169:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80116d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801171:	48 01 d0             	add    %rdx,%rax
  801174:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801178:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80117f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801184:	74 06                	je     80118c <vsnprintf+0x65>
  801186:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80118a:	7f 07                	jg     801193 <vsnprintf+0x6c>
		return -E_INVAL;
  80118c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801191:	eb 2f                	jmp    8011c2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801193:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801197:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80119b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80119f:	48 89 c6             	mov    %rax,%rsi
  8011a2:	48 bf da 10 80 00 00 	movabs $0x8010da,%rdi
  8011a9:	00 00 00 
  8011ac:	48 b8 fc 0a 80 00 00 	movabs $0x800afc,%rax
  8011b3:	00 00 00 
  8011b6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011bc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011bf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011c2:	c9                   	leaveq 
  8011c3:	c3                   	retq   

00000000008011c4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011c4:	55                   	push   %rbp
  8011c5:	48 89 e5             	mov    %rsp,%rbp
  8011c8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011cf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011d6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011dc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011e3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011ea:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f1:	84 c0                	test   %al,%al
  8011f3:	74 20                	je     801215 <snprintf+0x51>
  8011f5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011f9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011fd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801201:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801205:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801209:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80120d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801211:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801215:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80121c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801223:	00 00 00 
  801226:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80122d:	00 00 00 
  801230:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801234:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80123b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801242:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801249:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801250:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801257:	48 8b 0a             	mov    (%rdx),%rcx
  80125a:	48 89 08             	mov    %rcx,(%rax)
  80125d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801261:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801265:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801269:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80126d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801274:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80127b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801281:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801288:	48 89 c7             	mov    %rax,%rdi
  80128b:	48 b8 27 11 80 00 00 	movabs $0x801127,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
  801297:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80129d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 18          	sub    $0x18,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b8:	eb 09                	jmp    8012c3 <strlen+0x1e>
		n++;
  8012ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	84 c0                	test   %al,%al
  8012cc:	75 ec                	jne    8012ba <strlen+0x15>
		n++;
	return n;
  8012ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d1:	c9                   	leaveq 
  8012d2:	c3                   	retq   

00000000008012d3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	48 83 ec 20          	sub    $0x20,%rsp
  8012db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ea:	eb 0e                	jmp    8012fa <strnlen+0x27>
		n++;
  8012ec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f5:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012fa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012ff:	74 0b                	je     80130c <strnlen+0x39>
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	84 c0                	test   %al,%al
  80130a:	75 e0                	jne    8012ec <strnlen+0x19>
		n++;
	return n;
  80130c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 20          	sub    $0x20,%rsp
  801319:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801325:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801329:	90                   	nop
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801332:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801336:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80133a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801342:	0f b6 12             	movzbl (%rdx),%edx
  801345:	88 10                	mov    %dl,(%rax)
  801347:	0f b6 00             	movzbl (%rax),%eax
  80134a:	84 c0                	test   %al,%al
  80134c:	75 dc                	jne    80132a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801352:	c9                   	leaveq 
  801353:	c3                   	retq   

0000000000801354 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801354:	55                   	push   %rbp
  801355:	48 89 e5             	mov    %rsp,%rbp
  801358:	48 83 ec 20          	sub    $0x20,%rsp
  80135c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801368:	48 89 c7             	mov    %rax,%rdi
  80136b:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  801372:	00 00 00 
  801375:	ff d0                	callq  *%rax
  801377:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80137a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80137d:	48 63 d0             	movslq %eax,%rdx
  801380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801384:	48 01 c2             	add    %rax,%rdx
  801387:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138b:	48 89 c6             	mov    %rax,%rsi
  80138e:	48 89 d7             	mov    %rdx,%rdi
  801391:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  801398:	00 00 00 
  80139b:	ff d0                	callq  *%rax
	return dst;
  80139d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 83 ec 28          	sub    $0x28,%rsp
  8013ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013c6:	00 
  8013c7:	eb 2a                	jmp    8013f3 <strncpy+0x50>
		*dst++ = *src;
  8013c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d9:	0f b6 12             	movzbl (%rdx),%edx
  8013dc:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e2:	0f b6 00             	movzbl (%rax),%eax
  8013e5:	84 c0                	test   %al,%al
  8013e7:	74 05                	je     8013ee <strncpy+0x4b>
			src++;
  8013e9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013fb:	72 cc                	jb     8013c9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801401:	c9                   	leaveq 
  801402:	c3                   	retq   

0000000000801403 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801403:	55                   	push   %rbp
  801404:	48 89 e5             	mov    %rsp,%rbp
  801407:	48 83 ec 28          	sub    $0x28,%rsp
  80140b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801413:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801417:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80141f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801424:	74 3d                	je     801463 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801426:	eb 1d                	jmp    801445 <strlcpy+0x42>
			*dst++ = *src++;
  801428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801430:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801434:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801438:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80143c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801440:	0f b6 12             	movzbl (%rdx),%edx
  801443:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80144a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80144f:	74 0b                	je     80145c <strlcpy+0x59>
  801451:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	84 c0                	test   %al,%al
  80145a:	75 cc                	jne    801428 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80145c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801460:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801463:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146b:	48 29 c2             	sub    %rax,%rdx
  80146e:	48 89 d0             	mov    %rdx,%rax
}
  801471:	c9                   	leaveq 
  801472:	c3                   	retq   

0000000000801473 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801473:	55                   	push   %rbp
  801474:	48 89 e5             	mov    %rsp,%rbp
  801477:	48 83 ec 10          	sub    $0x10,%rsp
  80147b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801483:	eb 0a                	jmp    80148f <strcmp+0x1c>
		p++, q++;
  801485:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80148a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80148f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801493:	0f b6 00             	movzbl (%rax),%eax
  801496:	84 c0                	test   %al,%al
  801498:	74 12                	je     8014ac <strcmp+0x39>
  80149a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149e:	0f b6 10             	movzbl (%rax),%edx
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	38 c2                	cmp    %al,%dl
  8014aa:	74 d9                	je     801485 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b0:	0f b6 00             	movzbl (%rax),%eax
  8014b3:	0f b6 d0             	movzbl %al,%edx
  8014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	0f b6 c0             	movzbl %al,%eax
  8014c0:	29 c2                	sub    %eax,%edx
  8014c2:	89 d0                	mov    %edx,%eax
}
  8014c4:	c9                   	leaveq 
  8014c5:	c3                   	retq   

00000000008014c6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014c6:	55                   	push   %rbp
  8014c7:	48 89 e5             	mov    %rsp,%rbp
  8014ca:	48 83 ec 18          	sub    $0x18,%rsp
  8014ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014da:	eb 0f                	jmp    8014eb <strncmp+0x25>
		n--, p++, q++;
  8014dc:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f0:	74 1d                	je     80150f <strncmp+0x49>
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	0f b6 00             	movzbl (%rax),%eax
  8014f9:	84 c0                	test   %al,%al
  8014fb:	74 12                	je     80150f <strncmp+0x49>
  8014fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801501:	0f b6 10             	movzbl (%rax),%edx
  801504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	38 c2                	cmp    %al,%dl
  80150d:	74 cd                	je     8014dc <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80150f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801514:	75 07                	jne    80151d <strncmp+0x57>
		return 0;
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb 18                	jmp    801535 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	0f b6 00             	movzbl (%rax),%eax
  801524:	0f b6 d0             	movzbl %al,%edx
  801527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 0c          	sub    $0xc,%rsp
  80153f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801543:	89 f0                	mov    %esi,%eax
  801545:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801548:	eb 17                	jmp    801561 <strchr+0x2a>
		if (*s == c)
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801554:	75 06                	jne    80155c <strchr+0x25>
			return (char *) s;
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	eb 15                	jmp    801571 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80155c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	84 c0                	test   %al,%al
  80156a:	75 de                	jne    80154a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801571:	c9                   	leaveq 
  801572:	c3                   	retq   

0000000000801573 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801573:	55                   	push   %rbp
  801574:	48 89 e5             	mov    %rsp,%rbp
  801577:	48 83 ec 0c          	sub    $0xc,%rsp
  80157b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157f:	89 f0                	mov    %esi,%eax
  801581:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801584:	eb 13                	jmp    801599 <strfind+0x26>
		if (*s == c)
  801586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158a:	0f b6 00             	movzbl (%rax),%eax
  80158d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801590:	75 02                	jne    801594 <strfind+0x21>
			break;
  801592:	eb 10                	jmp    8015a4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801594:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	84 c0                	test   %al,%al
  8015a2:	75 e2                	jne    801586 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a8:	c9                   	leaveq 
  8015a9:	c3                   	retq   

00000000008015aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	48 83 ec 18          	sub    $0x18,%rsp
  8015b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c2:	75 06                	jne    8015ca <memset+0x20>
		return v;
  8015c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c8:	eb 69                	jmp    801633 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ce:	83 e0 03             	and    $0x3,%eax
  8015d1:	48 85 c0             	test   %rax,%rax
  8015d4:	75 48                	jne    80161e <memset+0x74>
  8015d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015da:	83 e0 03             	and    $0x3,%eax
  8015dd:	48 85 c0             	test   %rax,%rax
  8015e0:	75 3c                	jne    80161e <memset+0x74>
		c &= 0xFF;
  8015e2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ec:	c1 e0 18             	shl    $0x18,%eax
  8015ef:	89 c2                	mov    %eax,%edx
  8015f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f4:	c1 e0 10             	shl    $0x10,%eax
  8015f7:	09 c2                	or     %eax,%edx
  8015f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fc:	c1 e0 08             	shl    $0x8,%eax
  8015ff:	09 d0                	or     %edx,%eax
  801601:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801608:	48 c1 e8 02          	shr    $0x2,%rax
  80160c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80160f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801613:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801616:	48 89 d7             	mov    %rdx,%rdi
  801619:	fc                   	cld    
  80161a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80161c:	eb 11                	jmp    80162f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80161e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801622:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801625:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801629:	48 89 d7             	mov    %rdx,%rdi
  80162c:	fc                   	cld    
  80162d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80162f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
  801639:	48 83 ec 28          	sub    $0x28,%rsp
  80163d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801641:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801645:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801649:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80164d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801655:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801661:	0f 83 88 00 00 00    	jae    8016ef <memmove+0xba>
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166f:	48 01 d0             	add    %rdx,%rax
  801672:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801676:	76 77                	jbe    8016ef <memmove+0xba>
		s += n;
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168c:	83 e0 03             	and    $0x3,%eax
  80168f:	48 85 c0             	test   %rax,%rax
  801692:	75 3b                	jne    8016cf <memmove+0x9a>
  801694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801698:	83 e0 03             	and    $0x3,%eax
  80169b:	48 85 c0             	test   %rax,%rax
  80169e:	75 2f                	jne    8016cf <memmove+0x9a>
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	83 e0 03             	and    $0x3,%eax
  8016a7:	48 85 c0             	test   %rax,%rax
  8016aa:	75 23                	jne    8016cf <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	48 83 e8 04          	sub    $0x4,%rax
  8016b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b8:	48 83 ea 04          	sub    $0x4,%rdx
  8016bc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016c0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016c4:	48 89 c7             	mov    %rax,%rdi
  8016c7:	48 89 d6             	mov    %rdx,%rsi
  8016ca:	fd                   	std    
  8016cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016cd:	eb 1d                	jmp    8016ec <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016db:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	48 89 d7             	mov    %rdx,%rdi
  8016e6:	48 89 c1             	mov    %rax,%rcx
  8016e9:	fd                   	std    
  8016ea:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016ec:	fc                   	cld    
  8016ed:	eb 57                	jmp    801746 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f3:	83 e0 03             	and    $0x3,%eax
  8016f6:	48 85 c0             	test   %rax,%rax
  8016f9:	75 36                	jne    801731 <memmove+0xfc>
  8016fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ff:	83 e0 03             	and    $0x3,%eax
  801702:	48 85 c0             	test   %rax,%rax
  801705:	75 2a                	jne    801731 <memmove+0xfc>
  801707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170b:	83 e0 03             	and    $0x3,%eax
  80170e:	48 85 c0             	test   %rax,%rax
  801711:	75 1e                	jne    801731 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801717:	48 c1 e8 02          	shr    $0x2,%rax
  80171b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80171e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801722:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801726:	48 89 c7             	mov    %rax,%rdi
  801729:	48 89 d6             	mov    %rdx,%rsi
  80172c:	fc                   	cld    
  80172d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80172f:	eb 15                	jmp    801746 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801735:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801739:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80173d:	48 89 c7             	mov    %rax,%rdi
  801740:	48 89 d6             	mov    %rdx,%rsi
  801743:	fc                   	cld    
  801744:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80174a:	c9                   	leaveq 
  80174b:	c3                   	retq   

000000000080174c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80174c:	55                   	push   %rbp
  80174d:	48 89 e5             	mov    %rsp,%rbp
  801750:	48 83 ec 18          	sub    $0x18,%rsp
  801754:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801758:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80175c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801760:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801764:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176c:	48 89 ce             	mov    %rcx,%rsi
  80176f:	48 89 c7             	mov    %rax,%rdi
  801772:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801779:	00 00 00 
  80177c:	ff d0                	callq  *%rax
}
  80177e:	c9                   	leaveq 
  80177f:	c3                   	retq   

0000000000801780 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801780:	55                   	push   %rbp
  801781:	48 89 e5             	mov    %rsp,%rbp
  801784:	48 83 ec 28          	sub    $0x28,%rsp
  801788:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80178c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801790:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801798:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80179c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017a4:	eb 36                	jmp    8017dc <memcmp+0x5c>
		if (*s1 != *s2)
  8017a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017aa:	0f b6 10             	movzbl (%rax),%edx
  8017ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	38 c2                	cmp    %al,%dl
  8017b6:	74 1a                	je     8017d2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	0f b6 d0             	movzbl %al,%edx
  8017c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c6:	0f b6 00             	movzbl (%rax),%eax
  8017c9:	0f b6 c0             	movzbl %al,%eax
  8017cc:	29 c2                	sub    %eax,%edx
  8017ce:	89 d0                	mov    %edx,%eax
  8017d0:	eb 20                	jmp    8017f2 <memcmp+0x72>
		s1++, s2++;
  8017d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017e8:	48 85 c0             	test   %rax,%rax
  8017eb:	75 b9                	jne    8017a6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	c9                   	leaveq 
  8017f3:	c3                   	retq   

00000000008017f4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017f4:	55                   	push   %rbp
  8017f5:	48 89 e5             	mov    %rsp,%rbp
  8017f8:	48 83 ec 28          	sub    $0x28,%rsp
  8017fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801800:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801803:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180f:	48 01 d0             	add    %rdx,%rax
  801812:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801816:	eb 15                	jmp    80182d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80181c:	0f b6 10             	movzbl (%rax),%edx
  80181f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801822:	38 c2                	cmp    %al,%dl
  801824:	75 02                	jne    801828 <memfind+0x34>
			break;
  801826:	eb 0f                	jmp    801837 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801828:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801831:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801835:	72 e1                	jb     801818 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 34          	sub    $0x34,%rsp
  801845:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801849:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80184d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801857:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80185e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185f:	eb 05                	jmp    801866 <strtol+0x29>
		s++;
  801861:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	3c 20                	cmp    $0x20,%al
  80186f:	74 f0                	je     801861 <strtol+0x24>
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	0f b6 00             	movzbl (%rax),%eax
  801878:	3c 09                	cmp    $0x9,%al
  80187a:	74 e5                	je     801861 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80187c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801880:	0f b6 00             	movzbl (%rax),%eax
  801883:	3c 2b                	cmp    $0x2b,%al
  801885:	75 07                	jne    80188e <strtol+0x51>
		s++;
  801887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188c:	eb 17                	jmp    8018a5 <strtol+0x68>
	else if (*s == '-')
  80188e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801892:	0f b6 00             	movzbl (%rax),%eax
  801895:	3c 2d                	cmp    $0x2d,%al
  801897:	75 0c                	jne    8018a5 <strtol+0x68>
		s++, neg = 1;
  801899:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80189e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a9:	74 06                	je     8018b1 <strtol+0x74>
  8018ab:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018af:	75 28                	jne    8018d9 <strtol+0x9c>
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	0f b6 00             	movzbl (%rax),%eax
  8018b8:	3c 30                	cmp    $0x30,%al
  8018ba:	75 1d                	jne    8018d9 <strtol+0x9c>
  8018bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c0:	48 83 c0 01          	add    $0x1,%rax
  8018c4:	0f b6 00             	movzbl (%rax),%eax
  8018c7:	3c 78                	cmp    $0x78,%al
  8018c9:	75 0e                	jne    8018d9 <strtol+0x9c>
		s += 2, base = 16;
  8018cb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018d0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018d7:	eb 2c                	jmp    801905 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018dd:	75 19                	jne    8018f8 <strtol+0xbb>
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	3c 30                	cmp    $0x30,%al
  8018e8:	75 0e                	jne    8018f8 <strtol+0xbb>
		s++, base = 8;
  8018ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ef:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018f6:	eb 0d                	jmp    801905 <strtol+0xc8>
	else if (base == 0)
  8018f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018fc:	75 07                	jne    801905 <strtol+0xc8>
		base = 10;
  8018fe:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	3c 2f                	cmp    $0x2f,%al
  80190e:	7e 1d                	jle    80192d <strtol+0xf0>
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	3c 39                	cmp    $0x39,%al
  801919:	7f 12                	jg     80192d <strtol+0xf0>
			dig = *s - '0';
  80191b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	0f be c0             	movsbl %al,%eax
  801925:	83 e8 30             	sub    $0x30,%eax
  801928:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80192b:	eb 4e                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 60                	cmp    $0x60,%al
  801936:	7e 1d                	jle    801955 <strtol+0x118>
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	3c 7a                	cmp    $0x7a,%al
  801941:	7f 12                	jg     801955 <strtol+0x118>
			dig = *s - 'a' + 10;
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	0f b6 00             	movzbl (%rax),%eax
  80194a:	0f be c0             	movsbl %al,%eax
  80194d:	83 e8 57             	sub    $0x57,%eax
  801950:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801953:	eb 26                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	3c 40                	cmp    $0x40,%al
  80195e:	7e 48                	jle    8019a8 <strtol+0x16b>
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	3c 5a                	cmp    $0x5a,%al
  801969:	7f 3d                	jg     8019a8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80196b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196f:	0f b6 00             	movzbl (%rax),%eax
  801972:	0f be c0             	movsbl %al,%eax
  801975:	83 e8 37             	sub    $0x37,%eax
  801978:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80197b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80197e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801981:	7c 02                	jl     801985 <strtol+0x148>
			break;
  801983:	eb 23                	jmp    8019a8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801985:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80198a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80198d:	48 98                	cltq   
  80198f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801994:	48 89 c2             	mov    %rax,%rdx
  801997:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80199a:	48 98                	cltq   
  80199c:	48 01 d0             	add    %rdx,%rax
  80199f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019a3:	e9 5d ff ff ff       	jmpq   801905 <strtol+0xc8>

	if (endptr)
  8019a8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019ad:	74 0b                	je     8019ba <strtol+0x17d>
		*endptr = (char *) s;
  8019af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019b7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019be:	74 09                	je     8019c9 <strtol+0x18c>
  8019c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c4:	48 f7 d8             	neg    %rax
  8019c7:	eb 04                	jmp    8019cd <strtol+0x190>
  8019c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019cd:	c9                   	leaveq 
  8019ce:	c3                   	retq   

00000000008019cf <strstr>:

char * strstr(const char *in, const char *str)
{
  8019cf:	55                   	push   %rbp
  8019d0:	48 89 e5             	mov    %rsp,%rbp
  8019d3:	48 83 ec 30          	sub    $0x30,%rsp
  8019d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019eb:	0f b6 00             	movzbl (%rax),%eax
  8019ee:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019f1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019f5:	75 06                	jne    8019fd <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	eb 6b                	jmp    801a68 <strstr+0x99>

	len = strlen(str);
  8019fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a01:	48 89 c7             	mov    %rax,%rdi
  801a04:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	callq  *%rax
  801a10:	48 98                	cltq   
  801a12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a22:	0f b6 00             	movzbl (%rax),%eax
  801a25:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a28:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a2c:	75 07                	jne    801a35 <strstr+0x66>
				return (char *) 0;
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a33:	eb 33                	jmp    801a68 <strstr+0x99>
		} while (sc != c);
  801a35:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a39:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a3c:	75 d8                	jne    801a16 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a42:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	48 89 ce             	mov    %rcx,%rsi
  801a4d:	48 89 c7             	mov    %rax,%rdi
  801a50:	48 b8 c6 14 80 00 00 	movabs $0x8014c6,%rax
  801a57:	00 00 00 
  801a5a:	ff d0                	callq  *%rax
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	75 b6                	jne    801a16 <strstr+0x47>

	return (char *) (in - 1);
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	48 83 e8 01          	sub    $0x1,%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   
