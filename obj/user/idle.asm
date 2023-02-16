
obj/user/idle:     file format elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800059:	00 00 00 
  80005c:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 20          	sub    $0x20,%rsp
  80007f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800082:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800086:	48 b8 85 02 80 00 00 	movabs $0x800285,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800098:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009d:	48 63 d0             	movslq %eax,%rdx
  8000a0:	48 89 d0             	mov    %rdx,%rax
  8000a3:	48 c1 e0 03          	shl    $0x3,%rax
  8000a7:	48 01 d0             	add    %rdx,%rax
  8000aa:	48 c1 e0 05          	shl    $0x5,%rax
  8000ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b5:	00 00 00 
  8000b8:	48 01 c2             	add    %rax,%rdx
  8000bb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c2:	00 00 00 
  8000c5:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cc:	7e 14                	jle    8000e2 <libmain+0x6b>
		binaryname = argv[0];
  8000ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d2:	48 8b 10             	mov    (%rax),%rdx
  8000d5:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000dc:	00 00 00 
  8000df:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	89 c7                	mov    %eax,%edi
  8000ee:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f5:	00 00 00 
  8000f8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000fa:	48 b8 08 01 80 00 00 	movabs $0x800108,%rax
  800101:	00 00 00 
  800104:	ff d0                	callq  *%rax
}
  800106:	c9                   	leaveq 
  800107:	c3                   	retq   

0000000000800108 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800108:	55                   	push   %rbp
  800109:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80010c:	48 b8 af 08 80 00 00 	movabs $0x8008af,%rax
  800113:	00 00 00 
  800116:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800118:	bf 00 00 00 00       	mov    $0x0,%edi
  80011d:	48 b8 41 02 80 00 00 	movabs $0x800241,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
}
  800129:	5d                   	pop    %rbp
  80012a:	c3                   	retq   

000000000080012b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80012b:	55                   	push   %rbp
  80012c:	48 89 e5             	mov    %rsp,%rbp
  80012f:	53                   	push   %rbx
  800130:	48 83 ec 48          	sub    $0x48,%rsp
  800134:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800137:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80013a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80013e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800142:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800146:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80014a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800151:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800155:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800159:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800161:	4c 89 c3             	mov    %r8,%rbx
  800164:	cd 30                	int    $0x30
  800166:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80016a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80016e:	74 3e                	je     8001ae <syscall+0x83>
  800170:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800175:	7e 37                	jle    8001ae <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800177:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80017b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80017e:	49 89 d0             	mov    %rdx,%r8
  800181:	89 c1                	mov    %eax,%ecx
  800183:	48 ba 0f 36 80 00 00 	movabs $0x80360f,%rdx
  80018a:	00 00 00 
  80018d:	be 23 00 00 00       	mov    $0x23,%esi
  800192:	48 bf 2c 36 80 00 00 	movabs $0x80362c,%rdi
  800199:	00 00 00 
  80019c:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a1:	49 b9 33 1e 80 00 00 	movabs $0x801e33,%r9
  8001a8:	00 00 00 
  8001ab:	41 ff d1             	callq  *%r9

	return ret;
  8001ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b2:	48 83 c4 48          	add    $0x48,%rsp
  8001b6:	5b                   	pop    %rbx
  8001b7:	5d                   	pop    %rbp
  8001b8:	c3                   	retq   

00000000008001b9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b9:	55                   	push   %rbp
  8001ba:	48 89 e5             	mov    %rsp,%rbp
  8001bd:	48 83 ec 20          	sub    $0x20,%rsp
  8001c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d8:	00 
  8001d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e5:	48 89 d1             	mov    %rdx,%rcx
  8001e8:	48 89 c2             	mov    %rax,%rdx
  8001eb:	be 00 00 00 00       	mov    $0x0,%esi
  8001f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f5:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  8001fc:	00 00 00 
  8001ff:	ff d0                	callq  *%rax
}
  800201:	c9                   	leaveq 
  800202:	c3                   	retq   

0000000000800203 <sys_cgetc>:

int
sys_cgetc(void)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80020b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800212:	00 
  800213:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800219:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80021f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800224:	ba 00 00 00 00       	mov    $0x0,%edx
  800229:	be 00 00 00 00       	mov    $0x0,%esi
  80022e:	bf 01 00 00 00       	mov    $0x1,%edi
  800233:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  80023a:	00 00 00 
  80023d:	ff d0                	callq  *%rax
}
  80023f:	c9                   	leaveq 
  800240:	c3                   	retq   

0000000000800241 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800241:	55                   	push   %rbp
  800242:	48 89 e5             	mov    %rsp,%rbp
  800245:	48 83 ec 10          	sub    $0x10,%rsp
  800249:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80024c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80024f:	48 98                	cltq   
  800251:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800258:	00 
  800259:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80025f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800265:	b9 00 00 00 00       	mov    $0x0,%ecx
  80026a:	48 89 c2             	mov    %rax,%rdx
  80026d:	be 01 00 00 00       	mov    $0x1,%esi
  800272:	bf 03 00 00 00       	mov    $0x3,%edi
  800277:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  80027e:	00 00 00 
  800281:	ff d0                	callq  *%rax
}
  800283:	c9                   	leaveq 
  800284:	c3                   	retq   

0000000000800285 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800285:	55                   	push   %rbp
  800286:	48 89 e5             	mov    %rsp,%rbp
  800289:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800294:	00 
  800295:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80029b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ab:	be 00 00 00 00       	mov    $0x0,%esi
  8002b0:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b5:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  8002bc:	00 00 00 
  8002bf:	ff d0                	callq  *%rax
}
  8002c1:	c9                   	leaveq 
  8002c2:	c3                   	retq   

00000000008002c3 <sys_yield>:

void
sys_yield(void)
{
  8002c3:	55                   	push   %rbp
  8002c4:	48 89 e5             	mov    %rsp,%rbp
  8002c7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d2:	00 
  8002d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e9:	be 00 00 00 00       	mov    $0x0,%esi
  8002ee:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f3:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  8002fa:	00 00 00 
  8002fd:	ff d0                	callq  *%rax
}
  8002ff:	c9                   	leaveq 
  800300:	c3                   	retq   

0000000000800301 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800301:	55                   	push   %rbp
  800302:	48 89 e5             	mov    %rsp,%rbp
  800305:	48 83 ec 20          	sub    $0x20,%rsp
  800309:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80030c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800310:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800313:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800316:	48 63 c8             	movslq %eax,%rcx
  800319:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800320:	48 98                	cltq   
  800322:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800329:	00 
  80032a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800330:	49 89 c8             	mov    %rcx,%r8
  800333:	48 89 d1             	mov    %rdx,%rcx
  800336:	48 89 c2             	mov    %rax,%rdx
  800339:	be 01 00 00 00       	mov    $0x1,%esi
  80033e:	bf 04 00 00 00       	mov    $0x4,%edi
  800343:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
}
  80034f:	c9                   	leaveq 
  800350:	c3                   	retq   

0000000000800351 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800351:	55                   	push   %rbp
  800352:	48 89 e5             	mov    %rsp,%rbp
  800355:	48 83 ec 30          	sub    $0x30,%rsp
  800359:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800360:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800363:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800367:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80036b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036e:	48 63 c8             	movslq %eax,%rcx
  800371:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800375:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800378:	48 63 f0             	movslq %eax,%rsi
  80037b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800382:	48 98                	cltq   
  800384:	48 89 0c 24          	mov    %rcx,(%rsp)
  800388:	49 89 f9             	mov    %rdi,%r9
  80038b:	49 89 f0             	mov    %rsi,%r8
  80038e:	48 89 d1             	mov    %rdx,%rcx
  800391:	48 89 c2             	mov    %rax,%rdx
  800394:	be 01 00 00 00       	mov    $0x1,%esi
  800399:	bf 05 00 00 00       	mov    $0x5,%edi
  80039e:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
}
  8003aa:	c9                   	leaveq 
  8003ab:	c3                   	retq   

00000000008003ac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003ac:	55                   	push   %rbp
  8003ad:	48 89 e5             	mov    %rsp,%rbp
  8003b0:	48 83 ec 20          	sub    $0x20,%rsp
  8003b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 98                	cltq   
  8003c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003cb:	00 
  8003cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d8:	48 89 d1             	mov    %rdx,%rcx
  8003db:	48 89 c2             	mov    %rax,%rdx
  8003de:	be 01 00 00 00       	mov    $0x1,%esi
  8003e3:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e8:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
}
  8003f4:	c9                   	leaveq 
  8003f5:	c3                   	retq   

00000000008003f6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f6:	55                   	push   %rbp
  8003f7:	48 89 e5             	mov    %rsp,%rbp
  8003fa:	48 83 ec 10          	sub    $0x10,%rsp
  8003fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800401:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800404:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800407:	48 63 d0             	movslq %eax,%rdx
  80040a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040d:	48 98                	cltq   
  80040f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800416:	00 
  800417:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800423:	48 89 d1             	mov    %rdx,%rcx
  800426:	48 89 c2             	mov    %rax,%rdx
  800429:	be 01 00 00 00       	mov    $0x1,%esi
  80042e:	bf 08 00 00 00       	mov    $0x8,%edi
  800433:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  80043a:	00 00 00 
  80043d:	ff d0                	callq  *%rax
}
  80043f:	c9                   	leaveq 
  800440:	c3                   	retq   

0000000000800441 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800441:	55                   	push   %rbp
  800442:	48 89 e5             	mov    %rsp,%rbp
  800445:	48 83 ec 20          	sub    $0x20,%rsp
  800449:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800450:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800457:	48 98                	cltq   
  800459:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800460:	00 
  800461:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800467:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046d:	48 89 d1             	mov    %rdx,%rcx
  800470:	48 89 c2             	mov    %rax,%rdx
  800473:	be 01 00 00 00       	mov    $0x1,%esi
  800478:	bf 09 00 00 00       	mov    $0x9,%edi
  80047d:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  800484:	00 00 00 
  800487:	ff d0                	callq  *%rax
}
  800489:	c9                   	leaveq 
  80048a:	c3                   	retq   

000000000080048b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80048b:	55                   	push   %rbp
  80048c:	48 89 e5             	mov    %rsp,%rbp
  80048f:	48 83 ec 20          	sub    $0x20,%rsp
  800493:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800496:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80049a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a1:	48 98                	cltq   
  8004a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004aa:	00 
  8004ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b7:	48 89 d1             	mov    %rdx,%rcx
  8004ba:	48 89 c2             	mov    %rax,%rdx
  8004bd:	be 01 00 00 00       	mov    $0x1,%esi
  8004c2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c7:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  8004ce:	00 00 00 
  8004d1:	ff d0                	callq  *%rax
}
  8004d3:	c9                   	leaveq 
  8004d4:	c3                   	retq   

00000000008004d5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d5:	55                   	push   %rbp
  8004d6:	48 89 e5             	mov    %rsp,%rbp
  8004d9:	48 83 ec 20          	sub    $0x20,%rsp
  8004dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ee:	48 63 f0             	movslq %eax,%rsi
  8004f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f8:	48 98                	cltq   
  8004fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800505:	00 
  800506:	49 89 f1             	mov    %rsi,%r9
  800509:	49 89 c8             	mov    %rcx,%r8
  80050c:	48 89 d1             	mov    %rdx,%rcx
  80050f:	48 89 c2             	mov    %rax,%rdx
  800512:	be 00 00 00 00       	mov    $0x0,%esi
  800517:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051c:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  800523:	00 00 00 
  800526:	ff d0                	callq  *%rax
}
  800528:	c9                   	leaveq 
  800529:	c3                   	retq   

000000000080052a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80052a:	55                   	push   %rbp
  80052b:	48 89 e5             	mov    %rsp,%rbp
  80052e:	48 83 ec 10          	sub    $0x10,%rsp
  800532:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80053a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800541:	00 
  800542:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800548:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80054e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800553:	48 89 c2             	mov    %rax,%rdx
  800556:	be 01 00 00 00       	mov    $0x1,%esi
  80055b:	bf 0d 00 00 00       	mov    $0xd,%edi
  800560:	48 b8 2b 01 80 00 00 	movabs $0x80012b,%rax
  800567:	00 00 00 
  80056a:	ff d0                	callq  *%rax
}
  80056c:	c9                   	leaveq 
  80056d:	c3                   	retq   

000000000080056e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80056e:	55                   	push   %rbp
  80056f:	48 89 e5             	mov    %rsp,%rbp
  800572:	48 83 ec 08          	sub    $0x8,%rsp
  800576:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80057a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800585:	ff ff ff 
  800588:	48 01 d0             	add    %rdx,%rax
  80058b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80058f:	c9                   	leaveq 
  800590:	c3                   	retq   

0000000000800591 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800591:	55                   	push   %rbp
  800592:	48 89 e5             	mov    %rsp,%rbp
  800595:	48 83 ec 08          	sub    $0x8,%rsp
  800599:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80059d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005a1:	48 89 c7             	mov    %rax,%rdi
  8005a4:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
  8005b0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005b6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005ba:	c9                   	leaveq 
  8005bb:	c3                   	retq   

00000000008005bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005bc:	55                   	push   %rbp
  8005bd:	48 89 e5             	mov    %rsp,%rbp
  8005c0:	48 83 ec 18          	sub    $0x18,%rsp
  8005c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005cf:	eb 6b                	jmp    80063c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005d4:	48 98                	cltq   
  8005d6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8005e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e8:	48 c1 e8 15          	shr    $0x15,%rax
  8005ec:	48 89 c2             	mov    %rax,%rdx
  8005ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005f6:	01 00 00 
  8005f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005fd:	83 e0 01             	and    $0x1,%eax
  800600:	48 85 c0             	test   %rax,%rax
  800603:	74 21                	je     800626 <fd_alloc+0x6a>
  800605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800609:	48 c1 e8 0c          	shr    $0xc,%rax
  80060d:	48 89 c2             	mov    %rax,%rdx
  800610:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800617:	01 00 00 
  80061a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80061e:	83 e0 01             	and    $0x1,%eax
  800621:	48 85 c0             	test   %rax,%rax
  800624:	75 12                	jne    800638 <fd_alloc+0x7c>
			*fd_store = fd;
  800626:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80062e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800631:	b8 00 00 00 00       	mov    $0x0,%eax
  800636:	eb 1a                	jmp    800652 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800638:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80063c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800640:	7e 8f                	jle    8005d1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80064d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800652:	c9                   	leaveq 
  800653:	c3                   	retq   

0000000000800654 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800654:	55                   	push   %rbp
  800655:	48 89 e5             	mov    %rsp,%rbp
  800658:	48 83 ec 20          	sub    $0x20,%rsp
  80065c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80065f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800663:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800667:	78 06                	js     80066f <fd_lookup+0x1b>
  800669:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80066d:	7e 07                	jle    800676 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80066f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800674:	eb 6c                	jmp    8006e2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800676:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800679:	48 98                	cltq   
  80067b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800681:	48 c1 e0 0c          	shl    $0xc,%rax
  800685:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80068d:	48 c1 e8 15          	shr    $0x15,%rax
  800691:	48 89 c2             	mov    %rax,%rdx
  800694:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80069b:	01 00 00 
  80069e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a2:	83 e0 01             	and    $0x1,%eax
  8006a5:	48 85 c0             	test   %rax,%rax
  8006a8:	74 21                	je     8006cb <fd_lookup+0x77>
  8006aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ae:	48 c1 e8 0c          	shr    $0xc,%rax
  8006b2:	48 89 c2             	mov    %rax,%rdx
  8006b5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006bc:	01 00 00 
  8006bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006c3:	83 e0 01             	and    $0x1,%eax
  8006c6:	48 85 c0             	test   %rax,%rax
  8006c9:	75 07                	jne    8006d2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d0:	eb 10                	jmp    8006e2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006da:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006e2:	c9                   	leaveq 
  8006e3:	c3                   	retq   

00000000008006e4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006e4:	55                   	push   %rbp
  8006e5:	48 89 e5             	mov    %rsp,%rbp
  8006e8:	48 83 ec 30          	sub    $0x30,%rsp
  8006ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006f0:	89 f0                	mov    %esi,%eax
  8006f2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f9:	48 89 c7             	mov    %rax,%rdi
  8006fc:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  800703:	00 00 00 
  800706:	ff d0                	callq  *%rax
  800708:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80070c:	48 89 d6             	mov    %rdx,%rsi
  80070f:	89 c7                	mov    %eax,%edi
  800711:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800718:	00 00 00 
  80071b:	ff d0                	callq  *%rax
  80071d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800720:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800724:	78 0a                	js     800730 <fd_close+0x4c>
	    || fd != fd2)
  800726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80072e:	74 12                	je     800742 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800730:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800734:	74 05                	je     80073b <fd_close+0x57>
  800736:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800739:	eb 05                	jmp    800740 <fd_close+0x5c>
  80073b:	b8 00 00 00 00       	mov    $0x0,%eax
  800740:	eb 69                	jmp    8007ab <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800746:	8b 00                	mov    (%rax),%eax
  800748:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80074c:	48 89 d6             	mov    %rdx,%rsi
  80074f:	89 c7                	mov    %eax,%edi
  800751:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800758:	00 00 00 
  80075b:	ff d0                	callq  *%rax
  80075d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800764:	78 2a                	js     800790 <fd_close+0xac>
		if (dev->dev_close)
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80076e:	48 85 c0             	test   %rax,%rax
  800771:	74 16                	je     800789 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800777:	48 8b 40 20          	mov    0x20(%rax),%rax
  80077b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80077f:	48 89 d7             	mov    %rdx,%rdi
  800782:	ff d0                	callq  *%rax
  800784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800787:	eb 07                	jmp    800790 <fd_close+0xac>
		else
			r = 0;
  800789:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800794:	48 89 c6             	mov    %rax,%rsi
  800797:	bf 00 00 00 00       	mov    $0x0,%edi
  80079c:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  8007a3:	00 00 00 
  8007a6:	ff d0                	callq  *%rax
	return r;
  8007a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ab:	c9                   	leaveq 
  8007ac:	c3                   	retq   

00000000008007ad <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007ad:	55                   	push   %rbp
  8007ae:	48 89 e5             	mov    %rsp,%rbp
  8007b1:	48 83 ec 20          	sub    $0x20,%rsp
  8007b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007c3:	eb 41                	jmp    800806 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007c5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007cc:	00 00 00 
  8007cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007d2:	48 63 d2             	movslq %edx,%rdx
  8007d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007de:	75 22                	jne    800802 <dev_lookup+0x55>
			*dev = devtab[i];
  8007e0:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e7:	00 00 00 
  8007ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007ed:	48 63 d2             	movslq %edx,%rdx
  8007f0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007f8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	eb 60                	jmp    800862 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800802:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800806:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80080d:	00 00 00 
  800810:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800813:	48 63 d2             	movslq %edx,%rdx
  800816:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80081a:	48 85 c0             	test   %rax,%rax
  80081d:	75 a6                	jne    8007c5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80081f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800826:	00 00 00 
  800829:	48 8b 00             	mov    (%rax),%rax
  80082c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800832:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800835:	89 c6                	mov    %eax,%esi
  800837:	48 bf 40 36 80 00 00 	movabs $0x803640,%rdi
  80083e:	00 00 00 
  800841:	b8 00 00 00 00       	mov    $0x0,%eax
  800846:	48 b9 6c 20 80 00 00 	movabs $0x80206c,%rcx
  80084d:	00 00 00 
  800850:	ff d1                	callq  *%rcx
	*dev = 0;
  800852:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800856:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80085d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800862:	c9                   	leaveq 
  800863:	c3                   	retq   

0000000000800864 <close>:

int
close(int fdnum)
{
  800864:	55                   	push   %rbp
  800865:	48 89 e5             	mov    %rsp,%rbp
  800868:	48 83 ec 20          	sub    $0x20,%rsp
  80086c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80086f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800873:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800876:	48 89 d6             	mov    %rdx,%rsi
  800879:	89 c7                	mov    %eax,%edi
  80087b:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800882:	00 00 00 
  800885:	ff d0                	callq  *%rax
  800887:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80088a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80088e:	79 05                	jns    800895 <close+0x31>
		return r;
  800890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800893:	eb 18                	jmp    8008ad <close+0x49>
	else
		return fd_close(fd, 1);
  800895:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800899:	be 01 00 00 00       	mov    $0x1,%esi
  80089e:	48 89 c7             	mov    %rax,%rdi
  8008a1:	48 b8 e4 06 80 00 00 	movabs $0x8006e4,%rax
  8008a8:	00 00 00 
  8008ab:	ff d0                	callq  *%rax
}
  8008ad:	c9                   	leaveq 
  8008ae:	c3                   	retq   

00000000008008af <close_all>:

void
close_all(void)
{
  8008af:	55                   	push   %rbp
  8008b0:	48 89 e5             	mov    %rsp,%rbp
  8008b3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008be:	eb 15                	jmp    8008d5 <close_all+0x26>
		close(i);
  8008c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008c3:	89 c7                	mov    %eax,%edi
  8008c5:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008d5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008d9:	7e e5                	jle    8008c0 <close_all+0x11>
		close(i);
}
  8008db:	c9                   	leaveq 
  8008dc:	c3                   	retq   

00000000008008dd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008dd:	55                   	push   %rbp
  8008de:	48 89 e5             	mov    %rsp,%rbp
  8008e1:	48 83 ec 40          	sub    $0x40,%rsp
  8008e5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008e8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008eb:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008ef:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008f2:	48 89 d6             	mov    %rdx,%rsi
  8008f5:	89 c7                	mov    %eax,%edi
  8008f7:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  8008fe:	00 00 00 
  800901:	ff d0                	callq  *%rax
  800903:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800906:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80090a:	79 08                	jns    800914 <dup+0x37>
		return r;
  80090c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80090f:	e9 70 01 00 00       	jmpq   800a84 <dup+0x1a7>
	close(newfdnum);
  800914:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800917:	89 c7                	mov    %eax,%edi
  800919:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  800920:	00 00 00 
  800923:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800925:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800928:	48 98                	cltq   
  80092a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800930:	48 c1 e0 0c          	shl    $0xc,%rax
  800934:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093c:	48 89 c7             	mov    %rax,%rdi
  80093f:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  800946:	00 00 00 
  800949:	ff d0                	callq  *%rax
  80094b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80094f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800953:	48 89 c7             	mov    %rax,%rdi
  800956:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  80095d:	00 00 00 
  800960:	ff d0                	callq  *%rax
  800962:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	48 c1 e8 15          	shr    $0x15,%rax
  80096e:	48 89 c2             	mov    %rax,%rdx
  800971:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800978:	01 00 00 
  80097b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80097f:	83 e0 01             	and    $0x1,%eax
  800982:	48 85 c0             	test   %rax,%rax
  800985:	74 73                	je     8009fa <dup+0x11d>
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	48 c1 e8 0c          	shr    $0xc,%rax
  80098f:	48 89 c2             	mov    %rax,%rdx
  800992:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800999:	01 00 00 
  80099c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009a0:	83 e0 01             	and    $0x1,%eax
  8009a3:	48 85 c0             	test   %rax,%rax
  8009a6:	74 52                	je     8009fa <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8009b0:	48 89 c2             	mov    %rax,%rdx
  8009b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009ba:	01 00 00 
  8009bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009c1:	25 07 0e 00 00       	and    $0xe07,%eax
  8009c6:	89 c1                	mov    %eax,%ecx
  8009c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d0:	41 89 c8             	mov    %ecx,%r8d
  8009d3:	48 89 d1             	mov    %rdx,%rcx
  8009d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009db:	48 89 c6             	mov    %rax,%rsi
  8009de:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e3:	48 b8 51 03 80 00 00 	movabs $0x800351,%rax
  8009ea:	00 00 00 
  8009ed:	ff d0                	callq  *%rax
  8009ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009f6:	79 02                	jns    8009fa <dup+0x11d>
			goto err;
  8009f8:	eb 57                	jmp    800a51 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009fe:	48 c1 e8 0c          	shr    $0xc,%rax
  800a02:	48 89 c2             	mov    %rax,%rdx
  800a05:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a0c:	01 00 00 
  800a0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a13:	25 07 0e 00 00       	and    $0xe07,%eax
  800a18:	89 c1                	mov    %eax,%ecx
  800a1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a22:	41 89 c8             	mov    %ecx,%r8d
  800a25:	48 89 d1             	mov    %rdx,%rcx
  800a28:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2d:	48 89 c6             	mov    %rax,%rsi
  800a30:	bf 00 00 00 00       	mov    $0x0,%edi
  800a35:	48 b8 51 03 80 00 00 	movabs $0x800351,%rax
  800a3c:	00 00 00 
  800a3f:	ff d0                	callq  *%rax
  800a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a48:	79 02                	jns    800a4c <dup+0x16f>
		goto err;
  800a4a:	eb 05                	jmp    800a51 <dup+0x174>

	return newfdnum;
  800a4c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a4f:	eb 33                	jmp    800a84 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a55:	48 89 c6             	mov    %rax,%rsi
  800a58:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5d:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  800a64:	00 00 00 
  800a67:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a6d:	48 89 c6             	mov    %rax,%rsi
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
  800a75:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	callq  *%rax
	return r;
  800a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a84:	c9                   	leaveq 
  800a85:	c3                   	retq   

0000000000800a86 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a86:	55                   	push   %rbp
  800a87:	48 89 e5             	mov    %rsp,%rbp
  800a8a:	48 83 ec 40          	sub    $0x40,%rsp
  800a8e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a91:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a95:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a99:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a9d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800aa0:	48 89 d6             	mov    %rdx,%rsi
  800aa3:	89 c7                	mov    %eax,%edi
  800aa5:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800aac:	00 00 00 
  800aaf:	ff d0                	callq  *%rax
  800ab1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ab8:	78 24                	js     800ade <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abe:	8b 00                	mov    (%rax),%eax
  800ac0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ac4:	48 89 d6             	mov    %rdx,%rsi
  800ac7:	89 c7                	mov    %eax,%edi
  800ac9:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800ad0:	00 00 00 
  800ad3:	ff d0                	callq  *%rax
  800ad5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800adc:	79 05                	jns    800ae3 <read+0x5d>
		return r;
  800ade:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae1:	eb 76                	jmp    800b59 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae7:	8b 40 08             	mov    0x8(%rax),%eax
  800aea:	83 e0 03             	and    $0x3,%eax
  800aed:	83 f8 01             	cmp    $0x1,%eax
  800af0:	75 3a                	jne    800b2c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800af2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800af9:	00 00 00 
  800afc:	48 8b 00             	mov    (%rax),%rax
  800aff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b05:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b08:	89 c6                	mov    %eax,%esi
  800b0a:	48 bf 5f 36 80 00 00 	movabs $0x80365f,%rdi
  800b11:	00 00 00 
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
  800b19:	48 b9 6c 20 80 00 00 	movabs $0x80206c,%rcx
  800b20:	00 00 00 
  800b23:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b2a:	eb 2d                	jmp    800b59 <read+0xd3>
	}
	if (!dev->dev_read)
  800b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b30:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b34:	48 85 c0             	test   %rax,%rax
  800b37:	75 07                	jne    800b40 <read+0xba>
		return -E_NOT_SUPP;
  800b39:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b3e:	eb 19                	jmp    800b59 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b44:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b48:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b50:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b54:	48 89 cf             	mov    %rcx,%rdi
  800b57:	ff d0                	callq  *%rax
}
  800b59:	c9                   	leaveq 
  800b5a:	c3                   	retq   

0000000000800b5b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b5b:	55                   	push   %rbp
  800b5c:	48 89 e5             	mov    %rsp,%rbp
  800b5f:	48 83 ec 30          	sub    $0x30,%rsp
  800b63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b75:	eb 49                	jmp    800bc0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b7a:	48 98                	cltq   
  800b7c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b80:	48 29 c2             	sub    %rax,%rdx
  800b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b86:	48 63 c8             	movslq %eax,%rcx
  800b89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b8d:	48 01 c1             	add    %rax,%rcx
  800b90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b93:	48 89 ce             	mov    %rcx,%rsi
  800b96:	89 c7                	mov    %eax,%edi
  800b98:	48 b8 86 0a 80 00 00 	movabs $0x800a86,%rax
  800b9f:	00 00 00 
  800ba2:	ff d0                	callq  *%rax
  800ba4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800ba7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bab:	79 05                	jns    800bb2 <readn+0x57>
			return m;
  800bad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb0:	eb 1c                	jmp    800bce <readn+0x73>
		if (m == 0)
  800bb2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bb6:	75 02                	jne    800bba <readn+0x5f>
			break;
  800bb8:	eb 11                	jmp    800bcb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bbd:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bc3:	48 98                	cltq   
  800bc5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bc9:	72 ac                	jb     800b77 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bce:	c9                   	leaveq 
  800bcf:	c3                   	retq   

0000000000800bd0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bd0:	55                   	push   %rbp
  800bd1:	48 89 e5             	mov    %rsp,%rbp
  800bd4:	48 83 ec 40          	sub    $0x40,%rsp
  800bd8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bdb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bdf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800be3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800be7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bea:	48 89 d6             	mov    %rdx,%rsi
  800bed:	89 c7                	mov    %eax,%edi
  800bef:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	callq  *%rax
  800bfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c02:	78 24                	js     800c28 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c08:	8b 00                	mov    (%rax),%eax
  800c0a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c0e:	48 89 d6             	mov    %rdx,%rsi
  800c11:	89 c7                	mov    %eax,%edi
  800c13:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800c1a:	00 00 00 
  800c1d:	ff d0                	callq  *%rax
  800c1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c26:	79 05                	jns    800c2d <write+0x5d>
		return r;
  800c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c2b:	eb 75                	jmp    800ca2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c31:	8b 40 08             	mov    0x8(%rax),%eax
  800c34:	83 e0 03             	and    $0x3,%eax
  800c37:	85 c0                	test   %eax,%eax
  800c39:	75 3a                	jne    800c75 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c3b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c42:	00 00 00 
  800c45:	48 8b 00             	mov    (%rax),%rax
  800c48:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c4e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c51:	89 c6                	mov    %eax,%esi
  800c53:	48 bf 7b 36 80 00 00 	movabs $0x80367b,%rdi
  800c5a:	00 00 00 
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	48 b9 6c 20 80 00 00 	movabs $0x80206c,%rcx
  800c69:	00 00 00 
  800c6c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c73:	eb 2d                	jmp    800ca2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c79:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c7d:	48 85 c0             	test   %rax,%rax
  800c80:	75 07                	jne    800c89 <write+0xb9>
		return -E_NOT_SUPP;
  800c82:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c87:	eb 19                	jmp    800ca2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8d:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c91:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c99:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c9d:	48 89 cf             	mov    %rcx,%rdi
  800ca0:	ff d0                	callq  *%rax
}
  800ca2:	c9                   	leaveq 
  800ca3:	c3                   	retq   

0000000000800ca4 <seek>:

int
seek(int fdnum, off_t offset)
{
  800ca4:	55                   	push   %rbp
  800ca5:	48 89 e5             	mov    %rsp,%rbp
  800ca8:	48 83 ec 18          	sub    $0x18,%rsp
  800cac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800caf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cb2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cb6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cb9:	48 89 d6             	mov    %rdx,%rsi
  800cbc:	89 c7                	mov    %eax,%edi
  800cbe:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800cc5:	00 00 00 
  800cc8:	ff d0                	callq  *%rax
  800cca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ccd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cd1:	79 05                	jns    800cd8 <seek+0x34>
		return r;
  800cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd6:	eb 0f                	jmp    800ce7 <seek+0x43>
	fd->fd_offset = offset;
  800cd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cdf:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce7:	c9                   	leaveq 
  800ce8:	c3                   	retq   

0000000000800ce9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800ce9:	55                   	push   %rbp
  800cea:	48 89 e5             	mov    %rsp,%rbp
  800ced:	48 83 ec 30          	sub    $0x30,%rsp
  800cf1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cf4:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cfb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cfe:	48 89 d6             	mov    %rdx,%rsi
  800d01:	89 c7                	mov    %eax,%edi
  800d03:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800d0a:	00 00 00 
  800d0d:	ff d0                	callq  *%rax
  800d0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d16:	78 24                	js     800d3c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1c:	8b 00                	mov    (%rax),%eax
  800d1e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d22:	48 89 d6             	mov    %rdx,%rsi
  800d25:	89 c7                	mov    %eax,%edi
  800d27:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800d2e:	00 00 00 
  800d31:	ff d0                	callq  *%rax
  800d33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d3a:	79 05                	jns    800d41 <ftruncate+0x58>
		return r;
  800d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d3f:	eb 72                	jmp    800db3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d45:	8b 40 08             	mov    0x8(%rax),%eax
  800d48:	83 e0 03             	and    $0x3,%eax
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	75 3a                	jne    800d89 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d4f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d56:	00 00 00 
  800d59:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d5c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d62:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d65:	89 c6                	mov    %eax,%esi
  800d67:	48 bf 98 36 80 00 00 	movabs $0x803698,%rdi
  800d6e:	00 00 00 
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	48 b9 6c 20 80 00 00 	movabs $0x80206c,%rcx
  800d7d:	00 00 00 
  800d80:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d87:	eb 2a                	jmp    800db3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8d:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d91:	48 85 c0             	test   %rax,%rax
  800d94:	75 07                	jne    800d9d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d96:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d9b:	eb 16                	jmp    800db3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da1:	48 8b 40 30          	mov    0x30(%rax),%rax
  800da5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800dac:	89 ce                	mov    %ecx,%esi
  800dae:	48 89 d7             	mov    %rdx,%rdi
  800db1:	ff d0                	callq  *%rax
}
  800db3:	c9                   	leaveq 
  800db4:	c3                   	retq   

0000000000800db5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800db5:	55                   	push   %rbp
  800db6:	48 89 e5             	mov    %rsp,%rbp
  800db9:	48 83 ec 30          	sub    $0x30,%rsp
  800dbd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dc0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dc4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dcb:	48 89 d6             	mov    %rdx,%rsi
  800dce:	89 c7                	mov    %eax,%edi
  800dd0:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	callq  *%rax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de3:	78 24                	js     800e09 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800de5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de9:	8b 00                	mov    (%rax),%eax
  800deb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800def:	48 89 d6             	mov    %rdx,%rsi
  800df2:	89 c7                	mov    %eax,%edi
  800df4:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800dfb:	00 00 00 
  800dfe:	ff d0                	callq  *%rax
  800e00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e07:	79 05                	jns    800e0e <fstat+0x59>
		return r;
  800e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e0c:	eb 5e                	jmp    800e6c <fstat+0xb7>
	if (!dev->dev_stat)
  800e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e12:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e16:	48 85 c0             	test   %rax,%rax
  800e19:	75 07                	jne    800e22 <fstat+0x6d>
		return -E_NOT_SUPP;
  800e1b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e20:	eb 4a                	jmp    800e6c <fstat+0xb7>
	stat->st_name[0] = 0;
  800e22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e26:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e34:	00 00 00 
	stat->st_isdir = 0;
  800e37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e3b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e42:	00 00 00 
	stat->st_dev = dev;
  800e45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e4d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e58:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e60:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e64:	48 89 ce             	mov    %rcx,%rsi
  800e67:	48 89 d7             	mov    %rdx,%rdi
  800e6a:	ff d0                	callq  *%rax
}
  800e6c:	c9                   	leaveq 
  800e6d:	c3                   	retq   

0000000000800e6e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e6e:	55                   	push   %rbp
  800e6f:	48 89 e5             	mov    %rsp,%rbp
  800e72:	48 83 ec 20          	sub    $0x20,%rsp
  800e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	be 00 00 00 00       	mov    $0x0,%esi
  800e87:	48 89 c7             	mov    %rax,%rdi
  800e8a:	48 b8 5c 0f 80 00 00 	movabs $0x800f5c,%rax
  800e91:	00 00 00 
  800e94:	ff d0                	callq  *%rax
  800e96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e9d:	79 05                	jns    800ea4 <stat+0x36>
		return fd;
  800e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea2:	eb 2f                	jmp    800ed3 <stat+0x65>
	r = fstat(fd, stat);
  800ea4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eab:	48 89 d6             	mov    %rdx,%rsi
  800eae:	89 c7                	mov    %eax,%edi
  800eb0:	48 b8 b5 0d 80 00 00 	movabs $0x800db5,%rax
  800eb7:	00 00 00 
  800eba:	ff d0                	callq  *%rax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ebf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec2:	89 c7                	mov    %eax,%edi
  800ec4:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
	return r;
  800ed0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ed3:	c9                   	leaveq 
  800ed4:	c3                   	retq   

0000000000800ed5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ed5:	55                   	push   %rbp
  800ed6:	48 89 e5             	mov    %rsp,%rbp
  800ed9:	48 83 ec 10          	sub    $0x10,%rsp
  800edd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ee0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ee4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800eeb:	00 00 00 
  800eee:	8b 00                	mov    (%rax),%eax
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	75 1d                	jne    800f11 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ef4:	bf 01 00 00 00       	mov    $0x1,%edi
  800ef9:	48 b8 e6 34 80 00 00 	movabs $0x8034e6,%rax
  800f00:	00 00 00 
  800f03:	ff d0                	callq  *%rax
  800f05:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f0c:	00 00 00 
  800f0f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f11:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f18:	00 00 00 
  800f1b:	8b 00                	mov    (%rax),%eax
  800f1d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f20:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f25:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f2c:	00 00 00 
  800f2f:	89 c7                	mov    %eax,%edi
  800f31:	48 b8 4e 34 80 00 00 	movabs $0x80344e,%rax
  800f38:	00 00 00 
  800f3b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f41:	ba 00 00 00 00       	mov    $0x0,%edx
  800f46:	48 89 c6             	mov    %rax,%rsi
  800f49:	bf 00 00 00 00       	mov    $0x0,%edi
  800f4e:	48 b8 8d 33 80 00 00 	movabs $0x80338d,%rax
  800f55:	00 00 00 
  800f58:	ff d0                	callq  *%rax
}
  800f5a:	c9                   	leaveq 
  800f5b:	c3                   	retq   

0000000000800f5c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f5c:	55                   	push   %rbp
  800f5d:	48 89 e5             	mov    %rsp,%rbp
  800f60:	48 83 ec 20          	sub    $0x20,%rsp
  800f64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f68:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6f:	48 89 c7             	mov    %rax,%rdi
  800f72:	48 b8 c8 2b 80 00 00 	movabs $0x802bc8,%rax
  800f79:	00 00 00 
  800f7c:	ff d0                	callq  *%rax
  800f7e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f83:	7e 0a                	jle    800f8f <open+0x33>
		return -E_BAD_PATH;
  800f85:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f8a:	e9 a5 00 00 00       	jmpq   801034 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f8f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f93:	48 89 c7             	mov    %rax,%rdi
  800f96:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  800f9d:	00 00 00 
  800fa0:	ff d0                	callq  *%rax
  800fa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa9:	79 08                	jns    800fb3 <open+0x57>
		return r;
  800fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fae:	e9 81 00 00 00       	jmpq   801034 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb7:	48 89 c6             	mov    %rax,%rsi
  800fba:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fc1:	00 00 00 
  800fc4:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  800fcb:	00 00 00 
  800fce:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fd0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fd7:	00 00 00 
  800fda:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fdd:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe7:	48 89 c6             	mov    %rax,%rsi
  800fea:	bf 01 00 00 00       	mov    $0x1,%edi
  800fef:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  800ff6:	00 00 00 
  800ff9:	ff d0                	callq  *%rax
  800ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801002:	79 1d                	jns    801021 <open+0xc5>
		fd_close(fd, 0);
  801004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801008:	be 00 00 00 00       	mov    $0x0,%esi
  80100d:	48 89 c7             	mov    %rax,%rdi
  801010:	48 b8 e4 06 80 00 00 	movabs $0x8006e4,%rax
  801017:	00 00 00 
  80101a:	ff d0                	callq  *%rax
		return r;
  80101c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80101f:	eb 13                	jmp    801034 <open+0xd8>
	}

	return fd2num(fd);
  801021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801025:	48 89 c7             	mov    %rax,%rdi
  801028:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  80102f:	00 00 00 
  801032:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  801034:	c9                   	leaveq 
  801035:	c3                   	retq   

0000000000801036 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801036:	55                   	push   %rbp
  801037:	48 89 e5             	mov    %rsp,%rbp
  80103a:	48 83 ec 10          	sub    $0x10,%rsp
  80103e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801042:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801046:	8b 50 0c             	mov    0xc(%rax),%edx
  801049:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801050:	00 00 00 
  801053:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801055:	be 00 00 00 00       	mov    $0x0,%esi
  80105a:	bf 06 00 00 00       	mov    $0x6,%edi
  80105f:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  801066:	00 00 00 
  801069:	ff d0                	callq  *%rax
}
  80106b:	c9                   	leaveq 
  80106c:	c3                   	retq   

000000000080106d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80106d:	55                   	push   %rbp
  80106e:	48 89 e5             	mov    %rsp,%rbp
  801071:	48 83 ec 30          	sub    $0x30,%rsp
  801075:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801079:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80107d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801085:	8b 50 0c             	mov    0xc(%rax),%edx
  801088:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80108f:	00 00 00 
  801092:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801094:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80109b:	00 00 00 
  80109e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010a2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010a6:	be 00 00 00 00       	mov    $0x0,%esi
  8010ab:	bf 03 00 00 00       	mov    $0x3,%edi
  8010b0:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  8010b7:	00 00 00 
  8010ba:	ff d0                	callq  *%rax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c3:	79 08                	jns    8010cd <devfile_read+0x60>
		return r;
  8010c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c8:	e9 a4 00 00 00       	jmpq   801171 <devfile_read+0x104>
	assert(r <= n);
  8010cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d0:	48 98                	cltq   
  8010d2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010d6:	76 35                	jbe    80110d <devfile_read+0xa0>
  8010d8:	48 b9 c5 36 80 00 00 	movabs $0x8036c5,%rcx
  8010df:	00 00 00 
  8010e2:	48 ba cc 36 80 00 00 	movabs $0x8036cc,%rdx
  8010e9:	00 00 00 
  8010ec:	be 84 00 00 00       	mov    $0x84,%esi
  8010f1:	48 bf e1 36 80 00 00 	movabs $0x8036e1,%rdi
  8010f8:	00 00 00 
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	49 b8 33 1e 80 00 00 	movabs $0x801e33,%r8
  801107:	00 00 00 
  80110a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80110d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  801114:	7e 35                	jle    80114b <devfile_read+0xde>
  801116:	48 b9 ec 36 80 00 00 	movabs $0x8036ec,%rcx
  80111d:	00 00 00 
  801120:	48 ba cc 36 80 00 00 	movabs $0x8036cc,%rdx
  801127:	00 00 00 
  80112a:	be 85 00 00 00       	mov    $0x85,%esi
  80112f:	48 bf e1 36 80 00 00 	movabs $0x8036e1,%rdi
  801136:	00 00 00 
  801139:	b8 00 00 00 00       	mov    $0x0,%eax
  80113e:	49 b8 33 1e 80 00 00 	movabs $0x801e33,%r8
  801145:	00 00 00 
  801148:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80114b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80114e:	48 63 d0             	movslq %eax,%rdx
  801151:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801155:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80115c:	00 00 00 
  80115f:	48 89 c7             	mov    %rax,%rdi
  801162:	48 b8 58 2f 80 00 00 	movabs $0x802f58,%rax
  801169:	00 00 00 
  80116c:	ff d0                	callq  *%rax
	return r;
  80116e:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  801171:	c9                   	leaveq 
  801172:	c3                   	retq   

0000000000801173 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801173:	55                   	push   %rbp
  801174:	48 89 e5             	mov    %rsp,%rbp
  801177:	48 83 ec 30          	sub    $0x30,%rsp
  80117b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801183:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118b:	8b 50 0c             	mov    0xc(%rax),%edx
  80118e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801195:	00 00 00 
  801198:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80119a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011a1:	00 00 00 
  8011a4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011a8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8011ac:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011b3:	00 
  8011b4:	76 35                	jbe    8011eb <devfile_write+0x78>
  8011b6:	48 b9 f8 36 80 00 00 	movabs $0x8036f8,%rcx
  8011bd:	00 00 00 
  8011c0:	48 ba cc 36 80 00 00 	movabs $0x8036cc,%rdx
  8011c7:	00 00 00 
  8011ca:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011cf:	48 bf e1 36 80 00 00 	movabs $0x8036e1,%rdi
  8011d6:	00 00 00 
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011de:	49 b8 33 1e 80 00 00 	movabs $0x801e33,%r8
  8011e5:	00 00 00 
  8011e8:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f3:	48 89 c6             	mov    %rax,%rsi
  8011f6:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011fd:	00 00 00 
  801200:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  801207:	00 00 00 
  80120a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80120c:	be 00 00 00 00       	mov    $0x0,%esi
  801211:	bf 04 00 00 00       	mov    $0x4,%edi
  801216:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  80121d:	00 00 00 
  801220:	ff d0                	callq  *%rax
  801222:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801225:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801229:	79 05                	jns    801230 <devfile_write+0xbd>
		return r;
  80122b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80122e:	eb 43                	jmp    801273 <devfile_write+0x100>
	assert(r <= n);
  801230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801233:	48 98                	cltq   
  801235:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801239:	76 35                	jbe    801270 <devfile_write+0xfd>
  80123b:	48 b9 c5 36 80 00 00 	movabs $0x8036c5,%rcx
  801242:	00 00 00 
  801245:	48 ba cc 36 80 00 00 	movabs $0x8036cc,%rdx
  80124c:	00 00 00 
  80124f:	be a2 00 00 00       	mov    $0xa2,%esi
  801254:	48 bf e1 36 80 00 00 	movabs $0x8036e1,%rdi
  80125b:	00 00 00 
  80125e:	b8 00 00 00 00       	mov    $0x0,%eax
  801263:	49 b8 33 1e 80 00 00 	movabs $0x801e33,%r8
  80126a:	00 00 00 
  80126d:	41 ff d0             	callq  *%r8
	return r;
  801270:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801273:	c9                   	leaveq 
  801274:	c3                   	retq   

0000000000801275 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801275:	55                   	push   %rbp
  801276:	48 89 e5             	mov    %rsp,%rbp
  801279:	48 83 ec 20          	sub    $0x20,%rsp
  80127d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801281:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801289:	8b 50 0c             	mov    0xc(%rax),%edx
  80128c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801293:	00 00 00 
  801296:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801298:	be 00 00 00 00       	mov    $0x0,%esi
  80129d:	bf 05 00 00 00       	mov    $0x5,%edi
  8012a2:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  8012a9:	00 00 00 
  8012ac:	ff d0                	callq  *%rax
  8012ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012b5:	79 05                	jns    8012bc <devfile_stat+0x47>
		return r;
  8012b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ba:	eb 56                	jmp    801312 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c0:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012c7:	00 00 00 
  8012ca:	48 89 c7             	mov    %rax,%rdi
  8012cd:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  8012d4:	00 00 00 
  8012d7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012d9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012e0:	00 00 00 
  8012e3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ed:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012fa:	00 00 00 
  8012fd:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801303:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801307:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801312:	c9                   	leaveq 
  801313:	c3                   	retq   

0000000000801314 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801314:	55                   	push   %rbp
  801315:	48 89 e5             	mov    %rsp,%rbp
  801318:	48 83 ec 10          	sub    $0x10,%rsp
  80131c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801320:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	8b 50 0c             	mov    0xc(%rax),%edx
  80132a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801331:	00 00 00 
  801334:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801336:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80133d:	00 00 00 
  801340:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801343:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801346:	be 00 00 00 00       	mov    $0x0,%esi
  80134b:	bf 02 00 00 00       	mov    $0x2,%edi
  801350:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  801357:	00 00 00 
  80135a:	ff d0                	callq  *%rax
}
  80135c:	c9                   	leaveq 
  80135d:	c3                   	retq   

000000000080135e <remove>:

// Delete a file
int
remove(const char *path)
{
  80135e:	55                   	push   %rbp
  80135f:	48 89 e5             	mov    %rsp,%rbp
  801362:	48 83 ec 10          	sub    $0x10,%rsp
  801366:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	48 89 c7             	mov    %rax,%rdi
  801371:	48 b8 c8 2b 80 00 00 	movabs $0x802bc8,%rax
  801378:	00 00 00 
  80137b:	ff d0                	callq  *%rax
  80137d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801382:	7e 07                	jle    80138b <remove+0x2d>
		return -E_BAD_PATH;
  801384:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801389:	eb 33                	jmp    8013be <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	48 89 c6             	mov    %rax,%rsi
  801392:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801399:	00 00 00 
  80139c:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  8013a3:	00 00 00 
  8013a6:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8013a8:	be 00 00 00 00       	mov    $0x0,%esi
  8013ad:	bf 07 00 00 00       	mov    $0x7,%edi
  8013b2:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  8013b9:	00 00 00 
  8013bc:	ff d0                	callq  *%rax
}
  8013be:	c9                   	leaveq 
  8013bf:	c3                   	retq   

00000000008013c0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013c4:	be 00 00 00 00       	mov    $0x0,%esi
  8013c9:	bf 08 00 00 00       	mov    $0x8,%edi
  8013ce:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  8013d5:	00 00 00 
  8013d8:	ff d0                	callq  *%rax
}
  8013da:	5d                   	pop    %rbp
  8013db:	c3                   	retq   

00000000008013dc <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013dc:	55                   	push   %rbp
  8013dd:	48 89 e5             	mov    %rsp,%rbp
  8013e0:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013e7:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013ee:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013f5:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013fc:	be 00 00 00 00       	mov    $0x0,%esi
  801401:	48 89 c7             	mov    %rax,%rdi
  801404:	48 b8 5c 0f 80 00 00 	movabs $0x800f5c,%rax
  80140b:	00 00 00 
  80140e:	ff d0                	callq  *%rax
  801410:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801413:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801417:	79 28                	jns    801441 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141c:	89 c6                	mov    %eax,%esi
  80141e:	48 bf 25 37 80 00 00 	movabs $0x803725,%rdi
  801425:	00 00 00 
  801428:	b8 00 00 00 00       	mov    $0x0,%eax
  80142d:	48 ba 6c 20 80 00 00 	movabs $0x80206c,%rdx
  801434:	00 00 00 
  801437:	ff d2                	callq  *%rdx
		return fd_src;
  801439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80143c:	e9 74 01 00 00       	jmpq   8015b5 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801441:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801448:	be 01 01 00 00       	mov    $0x101,%esi
  80144d:	48 89 c7             	mov    %rax,%rdi
  801450:	48 b8 5c 0f 80 00 00 	movabs $0x800f5c,%rax
  801457:	00 00 00 
  80145a:	ff d0                	callq  *%rax
  80145c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80145f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801463:	79 39                	jns    80149e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801465:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801468:	89 c6                	mov    %eax,%esi
  80146a:	48 bf 3b 37 80 00 00 	movabs $0x80373b,%rdi
  801471:	00 00 00 
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
  801479:	48 ba 6c 20 80 00 00 	movabs $0x80206c,%rdx
  801480:	00 00 00 
  801483:	ff d2                	callq  *%rdx
		close(fd_src);
  801485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801488:	89 c7                	mov    %eax,%edi
  80148a:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  801491:	00 00 00 
  801494:	ff d0                	callq  *%rax
		return fd_dest;
  801496:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801499:	e9 17 01 00 00       	jmpq   8015b5 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80149e:	eb 74                	jmp    801514 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8014a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a3:	48 63 d0             	movslq %eax,%rdx
  8014a6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014b0:	48 89 ce             	mov    %rcx,%rsi
  8014b3:	89 c7                	mov    %eax,%edi
  8014b5:	48 b8 d0 0b 80 00 00 	movabs $0x800bd0,%rax
  8014bc:	00 00 00 
  8014bf:	ff d0                	callq  *%rax
  8014c1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014c8:	79 4a                	jns    801514 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014ca:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014cd:	89 c6                	mov    %eax,%esi
  8014cf:	48 bf 55 37 80 00 00 	movabs $0x803755,%rdi
  8014d6:	00 00 00 
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014de:	48 ba 6c 20 80 00 00 	movabs $0x80206c,%rdx
  8014e5:	00 00 00 
  8014e8:	ff d2                	callq  *%rdx
			close(fd_src);
  8014ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ed:	89 c7                	mov    %eax,%edi
  8014ef:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  8014f6:	00 00 00 
  8014f9:	ff d0                	callq  *%rax
			close(fd_dest);
  8014fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014fe:	89 c7                	mov    %eax,%edi
  801500:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  801507:	00 00 00 
  80150a:	ff d0                	callq  *%rax
			return write_size;
  80150c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80150f:	e9 a1 00 00 00       	jmpq   8015b5 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801514:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80151b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80151e:	ba 00 02 00 00       	mov    $0x200,%edx
  801523:	48 89 ce             	mov    %rcx,%rsi
  801526:	89 c7                	mov    %eax,%edi
  801528:	48 b8 86 0a 80 00 00 	movabs $0x800a86,%rax
  80152f:	00 00 00 
  801532:	ff d0                	callq  *%rax
  801534:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801537:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80153b:	0f 8f 5f ff ff ff    	jg     8014a0 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  801541:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801545:	79 47                	jns    80158e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801547:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80154a:	89 c6                	mov    %eax,%esi
  80154c:	48 bf 68 37 80 00 00 	movabs $0x803768,%rdi
  801553:	00 00 00 
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	48 ba 6c 20 80 00 00 	movabs $0x80206c,%rdx
  801562:	00 00 00 
  801565:	ff d2                	callq  *%rdx
		close(fd_src);
  801567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80156a:	89 c7                	mov    %eax,%edi
  80156c:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  801573:	00 00 00 
  801576:	ff d0                	callq  *%rax
		close(fd_dest);
  801578:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80157b:	89 c7                	mov    %eax,%edi
  80157d:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  801584:	00 00 00 
  801587:	ff d0                	callq  *%rax
		return read_size;
  801589:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158c:	eb 27                	jmp    8015b5 <copy+0x1d9>
	}
	close(fd_src);
  80158e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801591:	89 c7                	mov    %eax,%edi
  801593:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  80159a:	00 00 00 
  80159d:	ff d0                	callq  *%rax
	close(fd_dest);
  80159f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015a2:	89 c7                	mov    %eax,%edi
  8015a4:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  8015ab:	00 00 00 
  8015ae:	ff d0                	callq  *%rax
	return 0;
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015b5:	c9                   	leaveq 
  8015b6:	c3                   	retq   

00000000008015b7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015b7:	55                   	push   %rbp
  8015b8:	48 89 e5             	mov    %rsp,%rbp
  8015bb:	53                   	push   %rbx
  8015bc:	48 83 ec 38          	sub    $0x38,%rsp
  8015c0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015c4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015c8:	48 89 c7             	mov    %rax,%rdi
  8015cb:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  8015d2:	00 00 00 
  8015d5:	ff d0                	callq  *%rax
  8015d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015da:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015de:	0f 88 bf 01 00 00    	js     8017a3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8015ed:	48 89 c6             	mov    %rax,%rsi
  8015f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8015f5:	48 b8 01 03 80 00 00 	movabs $0x800301,%rax
  8015fc:	00 00 00 
  8015ff:	ff d0                	callq  *%rax
  801601:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801604:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801608:	0f 88 95 01 00 00    	js     8017a3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80160e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801612:	48 89 c7             	mov    %rax,%rdi
  801615:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  80161c:	00 00 00 
  80161f:	ff d0                	callq  *%rax
  801621:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801624:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801628:	0f 88 5d 01 00 00    	js     80178b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80162e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801632:	ba 07 04 00 00       	mov    $0x407,%edx
  801637:	48 89 c6             	mov    %rax,%rsi
  80163a:	bf 00 00 00 00       	mov    $0x0,%edi
  80163f:	48 b8 01 03 80 00 00 	movabs $0x800301,%rax
  801646:	00 00 00 
  801649:	ff d0                	callq  *%rax
  80164b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80164e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801652:	0f 88 33 01 00 00    	js     80178b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	48 89 c7             	mov    %rax,%rdi
  80165f:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  801666:	00 00 00 
  801669:	ff d0                	callq  *%rax
  80166b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80166f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801673:	ba 07 04 00 00       	mov    $0x407,%edx
  801678:	48 89 c6             	mov    %rax,%rsi
  80167b:	bf 00 00 00 00       	mov    $0x0,%edi
  801680:	48 b8 01 03 80 00 00 	movabs $0x800301,%rax
  801687:	00 00 00 
  80168a:	ff d0                	callq  *%rax
  80168c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801693:	79 05                	jns    80169a <pipe+0xe3>
		goto err2;
  801695:	e9 d9 00 00 00       	jmpq   801773 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80169a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80169e:	48 89 c7             	mov    %rax,%rdi
  8016a1:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  8016a8:	00 00 00 
  8016ab:	ff d0                	callq  *%rax
  8016ad:	48 89 c2             	mov    %rax,%rdx
  8016b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016ba:	48 89 d1             	mov    %rdx,%rcx
  8016bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c2:	48 89 c6             	mov    %rax,%rsi
  8016c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ca:	48 b8 51 03 80 00 00 	movabs $0x800351,%rax
  8016d1:	00 00 00 
  8016d4:	ff d0                	callq  *%rax
  8016d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016dd:	79 1b                	jns    8016fa <pipe+0x143>
		goto err3;
  8016df:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016e4:	48 89 c6             	mov    %rax,%rsi
  8016e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ec:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  8016f3:	00 00 00 
  8016f6:	ff d0                	callq  *%rax
  8016f8:	eb 79                	jmp    801773 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fe:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801705:	00 00 00 
  801708:	8b 12                	mov    (%rdx),%edx
  80170a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801717:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171b:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801722:	00 00 00 
  801725:	8b 12                	mov    (%rdx),%edx
  801727:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801729:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	48 89 c7             	mov    %rax,%rdi
  80173b:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  801742:	00 00 00 
  801745:	ff d0                	callq  *%rax
  801747:	89 c2                	mov    %eax,%edx
  801749:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80174d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80174f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801753:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801757:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175b:	48 89 c7             	mov    %rax,%rdi
  80175e:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  801765:	00 00 00 
  801768:	ff d0                	callq  *%rax
  80176a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
  801771:	eb 33                	jmp    8017a6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801773:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801777:	48 89 c6             	mov    %rax,%rsi
  80177a:	bf 00 00 00 00       	mov    $0x0,%edi
  80177f:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  801786:	00 00 00 
  801789:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	48 89 c6             	mov    %rax,%rsi
  801792:	bf 00 00 00 00       	mov    $0x0,%edi
  801797:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  80179e:	00 00 00 
  8017a1:	ff d0                	callq  *%rax
err:
	return r;
  8017a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8017a6:	48 83 c4 38          	add    $0x38,%rsp
  8017aa:	5b                   	pop    %rbx
  8017ab:	5d                   	pop    %rbp
  8017ac:	c3                   	retq   

00000000008017ad <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017ad:	55                   	push   %rbp
  8017ae:	48 89 e5             	mov    %rsp,%rbp
  8017b1:	53                   	push   %rbx
  8017b2:	48 83 ec 28          	sub    $0x28,%rsp
  8017b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017c5:	00 00 00 
  8017c8:	48 8b 00             	mov    (%rax),%rax
  8017cb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	48 89 c7             	mov    %rax,%rdi
  8017db:	48 b8 68 35 80 00 00 	movabs $0x803568,%rax
  8017e2:	00 00 00 
  8017e5:	ff d0                	callq  *%rax
  8017e7:	89 c3                	mov    %eax,%ebx
  8017e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ed:	48 89 c7             	mov    %rax,%rdi
  8017f0:	48 b8 68 35 80 00 00 	movabs $0x803568,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
  8017fc:	39 c3                	cmp    %eax,%ebx
  8017fe:	0f 94 c0             	sete   %al
  801801:	0f b6 c0             	movzbl %al,%eax
  801804:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801807:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80180e:	00 00 00 
  801811:	48 8b 00             	mov    (%rax),%rax
  801814:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80181a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80181d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801820:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801823:	75 05                	jne    80182a <_pipeisclosed+0x7d>
			return ret;
  801825:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801828:	eb 4f                	jmp    801879 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80182a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80182d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801830:	74 42                	je     801874 <_pipeisclosed+0xc7>
  801832:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801836:	75 3c                	jne    801874 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801838:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80183f:	00 00 00 
  801842:	48 8b 00             	mov    (%rax),%rax
  801845:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80184b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80184e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801851:	89 c6                	mov    %eax,%esi
  801853:	48 bf 83 37 80 00 00 	movabs $0x803783,%rdi
  80185a:	00 00 00 
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
  801862:	49 b8 6c 20 80 00 00 	movabs $0x80206c,%r8
  801869:	00 00 00 
  80186c:	41 ff d0             	callq  *%r8
	}
  80186f:	e9 4a ff ff ff       	jmpq   8017be <_pipeisclosed+0x11>
  801874:	e9 45 ff ff ff       	jmpq   8017be <_pipeisclosed+0x11>
}
  801879:	48 83 c4 28          	add    $0x28,%rsp
  80187d:	5b                   	pop    %rbx
  80187e:	5d                   	pop    %rbp
  80187f:	c3                   	retq   

0000000000801880 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801880:	55                   	push   %rbp
  801881:	48 89 e5             	mov    %rsp,%rbp
  801884:	48 83 ec 30          	sub    $0x30,%rsp
  801888:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80188b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80188f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801892:	48 89 d6             	mov    %rdx,%rsi
  801895:	89 c7                	mov    %eax,%edi
  801897:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	callq  *%rax
  8018a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018aa:	79 05                	jns    8018b1 <pipeisclosed+0x31>
		return r;
  8018ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018af:	eb 31                	jmp    8018e2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8018b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b5:	48 89 c7             	mov    %rax,%rdi
  8018b8:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	callq  *%rax
  8018c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d0:	48 89 d6             	mov    %rdx,%rsi
  8018d3:	48 89 c7             	mov    %rax,%rdi
  8018d6:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  8018dd:	00 00 00 
  8018e0:	ff d0                	callq  *%rax
}
  8018e2:	c9                   	leaveq 
  8018e3:	c3                   	retq   

00000000008018e4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018e4:	55                   	push   %rbp
  8018e5:	48 89 e5             	mov    %rsp,%rbp
  8018e8:	48 83 ec 40          	sub    $0x40,%rsp
  8018ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018f4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fc:	48 89 c7             	mov    %rax,%rdi
  8018ff:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  801906:	00 00 00 
  801909:	ff d0                	callq  *%rax
  80190b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80190f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801913:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801917:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80191e:	00 
  80191f:	e9 92 00 00 00       	jmpq   8019b6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801924:	eb 41                	jmp    801967 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801926:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80192b:	74 09                	je     801936 <devpipe_read+0x52>
				return i;
  80192d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801931:	e9 92 00 00 00       	jmpq   8019c8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801936:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	48 89 d6             	mov    %rdx,%rsi
  801941:	48 89 c7             	mov    %rax,%rdi
  801944:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  80194b:	00 00 00 
  80194e:	ff d0                	callq  *%rax
  801950:	85 c0                	test   %eax,%eax
  801952:	74 07                	je     80195b <devpipe_read+0x77>
				return 0;
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
  801959:	eb 6d                	jmp    8019c8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80195b:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  801962:	00 00 00 
  801965:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80196b:	8b 10                	mov    (%rax),%edx
  80196d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801971:	8b 40 04             	mov    0x4(%rax),%eax
  801974:	39 c2                	cmp    %eax,%edx
  801976:	74 ae                	je     801926 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801978:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801980:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801988:	8b 00                	mov    (%rax),%eax
  80198a:	99                   	cltd   
  80198b:	c1 ea 1b             	shr    $0x1b,%edx
  80198e:	01 d0                	add    %edx,%eax
  801990:	83 e0 1f             	and    $0x1f,%eax
  801993:	29 d0                	sub    %edx,%eax
  801995:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801999:	48 98                	cltq   
  80199b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8019a0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8019a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a6:	8b 00                	mov    (%rax),%eax
  8019a8:	8d 50 01             	lea    0x1(%rax),%edx
  8019ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019af:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ba:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019be:	0f 82 60 ff ff ff    	jb     801924 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019c8:	c9                   	leaveq 
  8019c9:	c3                   	retq   

00000000008019ca <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019ca:	55                   	push   %rbp
  8019cb:	48 89 e5             	mov    %rsp,%rbp
  8019ce:	48 83 ec 40          	sub    $0x40,%rsp
  8019d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	48 89 c7             	mov    %rax,%rdi
  8019e5:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  8019ec:	00 00 00 
  8019ef:	ff d0                	callq  *%rax
  8019f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019fd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a04:	00 
  801a05:	e9 8e 00 00 00       	jmpq   801a98 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a0a:	eb 31                	jmp    801a3d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a14:	48 89 d6             	mov    %rdx,%rsi
  801a17:	48 89 c7             	mov    %rax,%rdi
  801a1a:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
  801a26:	85 c0                	test   %eax,%eax
  801a28:	74 07                	je     801a31 <devpipe_write+0x67>
				return 0;
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2f:	eb 79                	jmp    801aaa <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a31:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  801a38:	00 00 00 
  801a3b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a41:	8b 40 04             	mov    0x4(%rax),%eax
  801a44:	48 63 d0             	movslq %eax,%rdx
  801a47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a4b:	8b 00                	mov    (%rax),%eax
  801a4d:	48 98                	cltq   
  801a4f:	48 83 c0 20          	add    $0x20,%rax
  801a53:	48 39 c2             	cmp    %rax,%rdx
  801a56:	73 b4                	jae    801a0c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5c:	8b 40 04             	mov    0x4(%rax),%eax
  801a5f:	99                   	cltd   
  801a60:	c1 ea 1b             	shr    $0x1b,%edx
  801a63:	01 d0                	add    %edx,%eax
  801a65:	83 e0 1f             	and    $0x1f,%eax
  801a68:	29 d0                	sub    %edx,%eax
  801a6a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a6e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a72:	48 01 ca             	add    %rcx,%rdx
  801a75:	0f b6 0a             	movzbl (%rdx),%ecx
  801a78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a7c:	48 98                	cltq   
  801a7e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a86:	8b 40 04             	mov    0x4(%rax),%eax
  801a89:	8d 50 01             	lea    0x1(%rax),%edx
  801a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a90:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a93:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801aa0:	0f 82 64 ff ff ff    	jb     801a0a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801aa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	48 83 ec 20          	sub    $0x20,%rsp
  801ab4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ab8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac0:	48 89 c7             	mov    %rax,%rdi
  801ac3:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
  801acf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801ad3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ad7:	48 be 96 37 80 00 00 	movabs $0x803796,%rsi
  801ade:	00 00 00 
  801ae1:	48 89 c7             	mov    %rax,%rdi
  801ae4:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801af0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af4:	8b 50 04             	mov    0x4(%rax),%edx
  801af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afb:	8b 00                	mov    (%rax),%eax
  801afd:	29 c2                	sub    %eax,%edx
  801aff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b03:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801b09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b0d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b14:	00 00 00 
	stat->st_dev = &devpipe;
  801b17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b1b:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b22:	00 00 00 
  801b25:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b31:	c9                   	leaveq 
  801b32:	c3                   	retq   

0000000000801b33 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b33:	55                   	push   %rbp
  801b34:	48 89 e5             	mov    %rsp,%rbp
  801b37:	48 83 ec 10          	sub    $0x10,%rsp
  801b3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b43:	48 89 c6             	mov    %rax,%rsi
  801b46:	bf 00 00 00 00       	mov    $0x0,%edi
  801b4b:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  801b52:	00 00 00 
  801b55:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5b:	48 89 c7             	mov    %rax,%rdi
  801b5e:	48 b8 91 05 80 00 00 	movabs $0x800591,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	callq  *%rax
  801b6a:	48 89 c6             	mov    %rax,%rsi
  801b6d:	bf 00 00 00 00       	mov    $0x0,%edi
  801b72:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  801b79:	00 00 00 
  801b7c:	ff d0                	callq  *%rax
}
  801b7e:	c9                   	leaveq 
  801b7f:	c3                   	retq   

0000000000801b80 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b80:	55                   	push   %rbp
  801b81:	48 89 e5             	mov    %rsp,%rbp
  801b84:	48 83 ec 20          	sub    $0x20,%rsp
  801b88:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b8e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b91:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b95:	be 01 00 00 00       	mov    $0x1,%esi
  801b9a:	48 89 c7             	mov    %rax,%rdi
  801b9d:	48 b8 b9 01 80 00 00 	movabs $0x8001b9,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
}
  801ba9:	c9                   	leaveq 
  801baa:	c3                   	retq   

0000000000801bab <getchar>:

int
getchar(void)
{
  801bab:	55                   	push   %rbp
  801bac:	48 89 e5             	mov    %rsp,%rbp
  801baf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bb3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801bb7:	ba 01 00 00 00       	mov    $0x1,%edx
  801bbc:	48 89 c6             	mov    %rax,%rsi
  801bbf:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc4:	48 b8 86 0a 80 00 00 	movabs $0x800a86,%rax
  801bcb:	00 00 00 
  801bce:	ff d0                	callq  *%rax
  801bd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd7:	79 05                	jns    801bde <getchar+0x33>
		return r;
  801bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdc:	eb 14                	jmp    801bf2 <getchar+0x47>
	if (r < 1)
  801bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801be2:	7f 07                	jg     801beb <getchar+0x40>
		return -E_EOF;
  801be4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801be9:	eb 07                	jmp    801bf2 <getchar+0x47>
	return c;
  801beb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801bef:	0f b6 c0             	movzbl %al,%eax
}
  801bf2:	c9                   	leaveq 
  801bf3:	c3                   	retq   

0000000000801bf4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bf4:	55                   	push   %rbp
  801bf5:	48 89 e5             	mov    %rsp,%rbp
  801bf8:	48 83 ec 20          	sub    $0x20,%rsp
  801bfc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c06:	48 89 d6             	mov    %rdx,%rsi
  801c09:	89 c7                	mov    %eax,%edi
  801c0b:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  801c12:	00 00 00 
  801c15:	ff d0                	callq  *%rax
  801c17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c1e:	79 05                	jns    801c25 <iscons+0x31>
		return r;
  801c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c23:	eb 1a                	jmp    801c3f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c29:	8b 10                	mov    (%rax),%edx
  801c2b:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c32:	00 00 00 
  801c35:	8b 00                	mov    (%rax),%eax
  801c37:	39 c2                	cmp    %eax,%edx
  801c39:	0f 94 c0             	sete   %al
  801c3c:	0f b6 c0             	movzbl %al,%eax
}
  801c3f:	c9                   	leaveq 
  801c40:	c3                   	retq   

0000000000801c41 <opencons>:

int
opencons(void)
{
  801c41:	55                   	push   %rbp
  801c42:	48 89 e5             	mov    %rsp,%rbp
  801c45:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c49:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c4d:	48 89 c7             	mov    %rax,%rdi
  801c50:	48 b8 bc 05 80 00 00 	movabs $0x8005bc,%rax
  801c57:	00 00 00 
  801c5a:	ff d0                	callq  *%rax
  801c5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c63:	79 05                	jns    801c6a <opencons+0x29>
		return r;
  801c65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c68:	eb 5b                	jmp    801cc5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c6e:	ba 07 04 00 00       	mov    $0x407,%edx
  801c73:	48 89 c6             	mov    %rax,%rsi
  801c76:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7b:	48 b8 01 03 80 00 00 	movabs $0x800301,%rax
  801c82:	00 00 00 
  801c85:	ff d0                	callq  *%rax
  801c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c8e:	79 05                	jns    801c95 <opencons+0x54>
		return r;
  801c90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c93:	eb 30                	jmp    801cc5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c99:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801ca0:	00 00 00 
  801ca3:	8b 12                	mov    (%rdx),%edx
  801ca5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb6:	48 89 c7             	mov    %rax,%rdi
  801cb9:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	callq  *%rax
}
  801cc5:	c9                   	leaveq 
  801cc6:	c3                   	retq   

0000000000801cc7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cc7:	55                   	push   %rbp
  801cc8:	48 89 e5             	mov    %rsp,%rbp
  801ccb:	48 83 ec 30          	sub    $0x30,%rsp
  801ccf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cdb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ce0:	75 07                	jne    801ce9 <devcons_read+0x22>
		return 0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	eb 4b                	jmp    801d34 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801ce9:	eb 0c                	jmp    801cf7 <devcons_read+0x30>
		sys_yield();
  801ceb:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  801cf2:	00 00 00 
  801cf5:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cf7:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	callq  *%rax
  801d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d0a:	74 df                	je     801ceb <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d10:	79 05                	jns    801d17 <devcons_read+0x50>
		return c;
  801d12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d15:	eb 1d                	jmp    801d34 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d17:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d1b:	75 07                	jne    801d24 <devcons_read+0x5d>
		return 0;
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d22:	eb 10                	jmp    801d34 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d27:	89 c2                	mov    %eax,%edx
  801d29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d2d:	88 10                	mov    %dl,(%rax)
	return 1;
  801d2f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d34:	c9                   	leaveq 
  801d35:	c3                   	retq   

0000000000801d36 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d36:	55                   	push   %rbp
  801d37:	48 89 e5             	mov    %rsp,%rbp
  801d3a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d41:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d48:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d4f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d5d:	eb 76                	jmp    801dd5 <devcons_write+0x9f>
		m = n - tot;
  801d5f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d66:	89 c2                	mov    %eax,%edx
  801d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6b:	29 c2                	sub    %eax,%edx
  801d6d:	89 d0                	mov    %edx,%eax
  801d6f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d75:	83 f8 7f             	cmp    $0x7f,%eax
  801d78:	76 07                	jbe    801d81 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d7a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d81:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d84:	48 63 d0             	movslq %eax,%rdx
  801d87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8a:	48 63 c8             	movslq %eax,%rcx
  801d8d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d94:	48 01 c1             	add    %rax,%rcx
  801d97:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d9e:	48 89 ce             	mov    %rcx,%rsi
  801da1:	48 89 c7             	mov    %rax,%rdi
  801da4:	48 b8 58 2f 80 00 00 	movabs $0x802f58,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801db0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db3:	48 63 d0             	movslq %eax,%rdx
  801db6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801dbd:	48 89 d6             	mov    %rdx,%rsi
  801dc0:	48 89 c7             	mov    %rax,%rdi
  801dc3:	48 b8 b9 01 80 00 00 	movabs $0x8001b9,%rax
  801dca:	00 00 00 
  801dcd:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dcf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd2:	01 45 fc             	add    %eax,-0x4(%rbp)
  801dd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd8:	48 98                	cltq   
  801dda:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801de1:	0f 82 78 ff ff ff    	jb     801d5f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 08          	sub    $0x8,%rsp
  801df4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfd:	c9                   	leaveq 
  801dfe:	c3                   	retq   

0000000000801dff <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dff:	55                   	push   %rbp
  801e00:	48 89 e5             	mov    %rsp,%rbp
  801e03:	48 83 ec 10          	sub    $0x10,%rsp
  801e07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e13:	48 be a2 37 80 00 00 	movabs $0x8037a2,%rsi
  801e1a:	00 00 00 
  801e1d:	48 89 c7             	mov    %rax,%rdi
  801e20:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  801e27:	00 00 00 
  801e2a:	ff d0                	callq  *%rax
	return 0;
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	53                   	push   %rbx
  801e38:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e3f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e46:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e4c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e53:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e5a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e61:	84 c0                	test   %al,%al
  801e63:	74 23                	je     801e88 <_panic+0x55>
  801e65:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e6c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e70:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e74:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e78:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e7c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e80:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e84:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e88:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e8f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e96:	00 00 00 
  801e99:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801ea0:	00 00 00 
  801ea3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ea7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801eae:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801eb5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ebc:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801ec3:	00 00 00 
  801ec6:	48 8b 18             	mov    (%rax),%rbx
  801ec9:	48 b8 85 02 80 00 00 	movabs $0x800285,%rax
  801ed0:	00 00 00 
  801ed3:	ff d0                	callq  *%rax
  801ed5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801edb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ee2:	41 89 c8             	mov    %ecx,%r8d
  801ee5:	48 89 d1             	mov    %rdx,%rcx
  801ee8:	48 89 da             	mov    %rbx,%rdx
  801eeb:	89 c6                	mov    %eax,%esi
  801eed:	48 bf b0 37 80 00 00 	movabs $0x8037b0,%rdi
  801ef4:	00 00 00 
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	49 b9 6c 20 80 00 00 	movabs $0x80206c,%r9
  801f03:	00 00 00 
  801f06:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f09:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f10:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f17:	48 89 d6             	mov    %rdx,%rsi
  801f1a:	48 89 c7             	mov    %rax,%rdi
  801f1d:	48 b8 c0 1f 80 00 00 	movabs $0x801fc0,%rax
  801f24:	00 00 00 
  801f27:	ff d0                	callq  *%rax
	cprintf("\n");
  801f29:	48 bf d3 37 80 00 00 	movabs $0x8037d3,%rdi
  801f30:	00 00 00 
  801f33:	b8 00 00 00 00       	mov    $0x0,%eax
  801f38:	48 ba 6c 20 80 00 00 	movabs $0x80206c,%rdx
  801f3f:	00 00 00 
  801f42:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f44:	cc                   	int3   
  801f45:	eb fd                	jmp    801f44 <_panic+0x111>

0000000000801f47 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f47:	55                   	push   %rbp
  801f48:	48 89 e5             	mov    %rsp,%rbp
  801f4b:	48 83 ec 10          	sub    $0x10,%rsp
  801f4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5a:	8b 00                	mov    (%rax),%eax
  801f5c:	8d 48 01             	lea    0x1(%rax),%ecx
  801f5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f63:	89 0a                	mov    %ecx,(%rdx)
  801f65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f68:	89 d1                	mov    %edx,%ecx
  801f6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6e:	48 98                	cltq   
  801f70:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f78:	8b 00                	mov    (%rax),%eax
  801f7a:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f7f:	75 2c                	jne    801fad <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	8b 00                	mov    (%rax),%eax
  801f87:	48 98                	cltq   
  801f89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8d:	48 83 c2 08          	add    $0x8,%rdx
  801f91:	48 89 c6             	mov    %rax,%rsi
  801f94:	48 89 d7             	mov    %rdx,%rdi
  801f97:	48 b8 b9 01 80 00 00 	movabs $0x8001b9,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
        b->idx = 0;
  801fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb1:	8b 40 04             	mov    0x4(%rax),%eax
  801fb4:	8d 50 01             	lea    0x1(%rax),%edx
  801fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbb:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fbe:	c9                   	leaveq 
  801fbf:	c3                   	retq   

0000000000801fc0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fc0:	55                   	push   %rbp
  801fc1:	48 89 e5             	mov    %rsp,%rbp
  801fc4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fcb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fd2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fd9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fe0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fe7:	48 8b 0a             	mov    (%rdx),%rcx
  801fea:	48 89 08             	mov    %rcx,(%rax)
  801fed:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801ff1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801ff5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801ff9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801ffd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802004:	00 00 00 
    b.cnt = 0;
  802007:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80200e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802011:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802018:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80201f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802026:	48 89 c6             	mov    %rax,%rsi
  802029:	48 bf 47 1f 80 00 00 	movabs $0x801f47,%rdi
  802030:	00 00 00 
  802033:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80203f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802045:	48 98                	cltq   
  802047:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80204e:	48 83 c2 08          	add    $0x8,%rdx
  802052:	48 89 c6             	mov    %rax,%rsi
  802055:	48 89 d7             	mov    %rdx,%rdi
  802058:	48 b8 b9 01 80 00 00 	movabs $0x8001b9,%rax
  80205f:	00 00 00 
  802062:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802064:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80206a:	c9                   	leaveq 
  80206b:	c3                   	retq   

000000000080206c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80206c:	55                   	push   %rbp
  80206d:	48 89 e5             	mov    %rsp,%rbp
  802070:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802077:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80207e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802085:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80208c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802093:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80209a:	84 c0                	test   %al,%al
  80209c:	74 20                	je     8020be <cprintf+0x52>
  80209e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8020a2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8020a6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8020aa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8020ae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8020b2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020b6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020ba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020be:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020c5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020cc:	00 00 00 
  8020cf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020d6:	00 00 00 
  8020d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020e4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020eb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020f2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020f9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802100:	48 8b 0a             	mov    (%rdx),%rcx
  802103:	48 89 08             	mov    %rcx,(%rax)
  802106:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80210a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80210e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802112:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802116:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80211d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802124:	48 89 d6             	mov    %rdx,%rsi
  802127:	48 89 c7             	mov    %rax,%rdi
  80212a:	48 b8 c0 1f 80 00 00 	movabs $0x801fc0,%rax
  802131:	00 00 00 
  802134:	ff d0                	callq  *%rax
  802136:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80213c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802142:	c9                   	leaveq 
  802143:	c3                   	retq   

0000000000802144 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802144:	55                   	push   %rbp
  802145:	48 89 e5             	mov    %rsp,%rbp
  802148:	53                   	push   %rbx
  802149:	48 83 ec 38          	sub    $0x38,%rsp
  80214d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802151:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802155:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802159:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80215c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802160:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802164:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802167:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80216b:	77 3b                	ja     8021a8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80216d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802170:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802174:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802177:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217b:	ba 00 00 00 00       	mov    $0x0,%edx
  802180:	48 f7 f3             	div    %rbx
  802183:	48 89 c2             	mov    %rax,%rdx
  802186:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802189:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80218c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802194:	41 89 f9             	mov    %edi,%r9d
  802197:	48 89 c7             	mov    %rax,%rdi
  80219a:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
  8021a6:	eb 1e                	jmp    8021c6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021a8:	eb 12                	jmp    8021bc <printnum+0x78>
			putch(padc, putdat);
  8021aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021ae:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8021b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b5:	48 89 ce             	mov    %rcx,%rsi
  8021b8:	89 d7                	mov    %edx,%edi
  8021ba:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021bc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021c4:	7f e4                	jg     8021aa <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021c6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d2:	48 f7 f1             	div    %rcx
  8021d5:	48 89 d0             	mov    %rdx,%rax
  8021d8:	48 ba d0 39 80 00 00 	movabs $0x8039d0,%rdx
  8021df:	00 00 00 
  8021e2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021e6:	0f be d0             	movsbl %al,%edx
  8021e9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f1:	48 89 ce             	mov    %rcx,%rsi
  8021f4:	89 d7                	mov    %edx,%edi
  8021f6:	ff d0                	callq  *%rax
}
  8021f8:	48 83 c4 38          	add    $0x38,%rsp
  8021fc:	5b                   	pop    %rbx
  8021fd:	5d                   	pop    %rbp
  8021fe:	c3                   	retq   

00000000008021ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021ff:	55                   	push   %rbp
  802200:	48 89 e5             	mov    %rsp,%rbp
  802203:	48 83 ec 1c          	sub    $0x1c,%rsp
  802207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80220b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80220e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802212:	7e 52                	jle    802266 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802218:	8b 00                	mov    (%rax),%eax
  80221a:	83 f8 30             	cmp    $0x30,%eax
  80221d:	73 24                	jae    802243 <getuint+0x44>
  80221f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802223:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222b:	8b 00                	mov    (%rax),%eax
  80222d:	89 c0                	mov    %eax,%eax
  80222f:	48 01 d0             	add    %rdx,%rax
  802232:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802236:	8b 12                	mov    (%rdx),%edx
  802238:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80223b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80223f:	89 0a                	mov    %ecx,(%rdx)
  802241:	eb 17                	jmp    80225a <getuint+0x5b>
  802243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802247:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80224b:	48 89 d0             	mov    %rdx,%rax
  80224e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802252:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802256:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80225a:	48 8b 00             	mov    (%rax),%rax
  80225d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802261:	e9 a3 00 00 00       	jmpq   802309 <getuint+0x10a>
	else if (lflag)
  802266:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80226a:	74 4f                	je     8022bb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80226c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802270:	8b 00                	mov    (%rax),%eax
  802272:	83 f8 30             	cmp    $0x30,%eax
  802275:	73 24                	jae    80229b <getuint+0x9c>
  802277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80227f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802283:	8b 00                	mov    (%rax),%eax
  802285:	89 c0                	mov    %eax,%eax
  802287:	48 01 d0             	add    %rdx,%rax
  80228a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80228e:	8b 12                	mov    (%rdx),%edx
  802290:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802293:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802297:	89 0a                	mov    %ecx,(%rdx)
  802299:	eb 17                	jmp    8022b2 <getuint+0xb3>
  80229b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022a3:	48 89 d0             	mov    %rdx,%rax
  8022a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022b2:	48 8b 00             	mov    (%rax),%rax
  8022b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022b9:	eb 4e                	jmp    802309 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bf:	8b 00                	mov    (%rax),%eax
  8022c1:	83 f8 30             	cmp    $0x30,%eax
  8022c4:	73 24                	jae    8022ea <getuint+0xeb>
  8022c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d2:	8b 00                	mov    (%rax),%eax
  8022d4:	89 c0                	mov    %eax,%eax
  8022d6:	48 01 d0             	add    %rdx,%rax
  8022d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022dd:	8b 12                	mov    (%rdx),%edx
  8022df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022e6:	89 0a                	mov    %ecx,(%rdx)
  8022e8:	eb 17                	jmp    802301 <getuint+0x102>
  8022ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022f2:	48 89 d0             	mov    %rdx,%rax
  8022f5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802301:	8b 00                	mov    (%rax),%eax
  802303:	89 c0                	mov    %eax,%eax
  802305:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80230d:	c9                   	leaveq 
  80230e:	c3                   	retq   

000000000080230f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80230f:	55                   	push   %rbp
  802310:	48 89 e5             	mov    %rsp,%rbp
  802313:	48 83 ec 1c          	sub    $0x1c,%rsp
  802317:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80231b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80231e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802322:	7e 52                	jle    802376 <getint+0x67>
		x=va_arg(*ap, long long);
  802324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802328:	8b 00                	mov    (%rax),%eax
  80232a:	83 f8 30             	cmp    $0x30,%eax
  80232d:	73 24                	jae    802353 <getint+0x44>
  80232f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802333:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802337:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233b:	8b 00                	mov    (%rax),%eax
  80233d:	89 c0                	mov    %eax,%eax
  80233f:	48 01 d0             	add    %rdx,%rax
  802342:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802346:	8b 12                	mov    (%rdx),%edx
  802348:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80234b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80234f:	89 0a                	mov    %ecx,(%rdx)
  802351:	eb 17                	jmp    80236a <getint+0x5b>
  802353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802357:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80235b:	48 89 d0             	mov    %rdx,%rax
  80235e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802362:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802366:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80236a:	48 8b 00             	mov    (%rax),%rax
  80236d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802371:	e9 a3 00 00 00       	jmpq   802419 <getint+0x10a>
	else if (lflag)
  802376:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80237a:	74 4f                	je     8023cb <getint+0xbc>
		x=va_arg(*ap, long);
  80237c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802380:	8b 00                	mov    (%rax),%eax
  802382:	83 f8 30             	cmp    $0x30,%eax
  802385:	73 24                	jae    8023ab <getint+0x9c>
  802387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80238f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802393:	8b 00                	mov    (%rax),%eax
  802395:	89 c0                	mov    %eax,%eax
  802397:	48 01 d0             	add    %rdx,%rax
  80239a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239e:	8b 12                	mov    (%rdx),%edx
  8023a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a7:	89 0a                	mov    %ecx,(%rdx)
  8023a9:	eb 17                	jmp    8023c2 <getint+0xb3>
  8023ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023b3:	48 89 d0             	mov    %rdx,%rax
  8023b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023c2:	48 8b 00             	mov    (%rax),%rax
  8023c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023c9:	eb 4e                	jmp    802419 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cf:	8b 00                	mov    (%rax),%eax
  8023d1:	83 f8 30             	cmp    $0x30,%eax
  8023d4:	73 24                	jae    8023fa <getint+0xeb>
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e2:	8b 00                	mov    (%rax),%eax
  8023e4:	89 c0                	mov    %eax,%eax
  8023e6:	48 01 d0             	add    %rdx,%rax
  8023e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023ed:	8b 12                	mov    (%rdx),%edx
  8023ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f6:	89 0a                	mov    %ecx,(%rdx)
  8023f8:	eb 17                	jmp    802411 <getint+0x102>
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802402:	48 89 d0             	mov    %rdx,%rax
  802405:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802409:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80240d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802411:	8b 00                	mov    (%rax),%eax
  802413:	48 98                	cltq   
  802415:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80241d:	c9                   	leaveq 
  80241e:	c3                   	retq   

000000000080241f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80241f:	55                   	push   %rbp
  802420:	48 89 e5             	mov    %rsp,%rbp
  802423:	41 54                	push   %r12
  802425:	53                   	push   %rbx
  802426:	48 83 ec 60          	sub    $0x60,%rsp
  80242a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80242e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802432:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802436:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80243a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80243e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802442:	48 8b 0a             	mov    (%rdx),%rcx
  802445:	48 89 08             	mov    %rcx,(%rax)
  802448:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80244c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802450:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802454:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802458:	eb 17                	jmp    802471 <vprintfmt+0x52>
			if (ch == '\0')
  80245a:	85 db                	test   %ebx,%ebx
  80245c:	0f 84 df 04 00 00    	je     802941 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  802462:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802466:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80246a:	48 89 d6             	mov    %rdx,%rsi
  80246d:	89 df                	mov    %ebx,%edi
  80246f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802471:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802475:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802479:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80247d:	0f b6 00             	movzbl (%rax),%eax
  802480:	0f b6 d8             	movzbl %al,%ebx
  802483:	83 fb 25             	cmp    $0x25,%ebx
  802486:	75 d2                	jne    80245a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802488:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80248c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802493:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80249a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8024a1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8024a8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024b0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024b4:	0f b6 00             	movzbl (%rax),%eax
  8024b7:	0f b6 d8             	movzbl %al,%ebx
  8024ba:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024bd:	83 f8 55             	cmp    $0x55,%eax
  8024c0:	0f 87 47 04 00 00    	ja     80290d <vprintfmt+0x4ee>
  8024c6:	89 c0                	mov    %eax,%eax
  8024c8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024cf:	00 
  8024d0:	48 b8 f8 39 80 00 00 	movabs $0x8039f8,%rax
  8024d7:	00 00 00 
  8024da:	48 01 d0             	add    %rdx,%rax
  8024dd:	48 8b 00             	mov    (%rax),%rax
  8024e0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024e2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024e6:	eb c0                	jmp    8024a8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024e8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024ec:	eb ba                	jmp    8024a8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024ee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024f5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024f8:	89 d0                	mov    %edx,%eax
  8024fa:	c1 e0 02             	shl    $0x2,%eax
  8024fd:	01 d0                	add    %edx,%eax
  8024ff:	01 c0                	add    %eax,%eax
  802501:	01 d8                	add    %ebx,%eax
  802503:	83 e8 30             	sub    $0x30,%eax
  802506:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802509:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80250d:	0f b6 00             	movzbl (%rax),%eax
  802510:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802513:	83 fb 2f             	cmp    $0x2f,%ebx
  802516:	7e 0c                	jle    802524 <vprintfmt+0x105>
  802518:	83 fb 39             	cmp    $0x39,%ebx
  80251b:	7f 07                	jg     802524 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80251d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802522:	eb d1                	jmp    8024f5 <vprintfmt+0xd6>
			goto process_precision;
  802524:	eb 58                	jmp    80257e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802526:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802529:	83 f8 30             	cmp    $0x30,%eax
  80252c:	73 17                	jae    802545 <vprintfmt+0x126>
  80252e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802532:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802535:	89 c0                	mov    %eax,%eax
  802537:	48 01 d0             	add    %rdx,%rax
  80253a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80253d:	83 c2 08             	add    $0x8,%edx
  802540:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802543:	eb 0f                	jmp    802554 <vprintfmt+0x135>
  802545:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802549:	48 89 d0             	mov    %rdx,%rax
  80254c:	48 83 c2 08          	add    $0x8,%rdx
  802550:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802554:	8b 00                	mov    (%rax),%eax
  802556:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802559:	eb 23                	jmp    80257e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80255b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80255f:	79 0c                	jns    80256d <vprintfmt+0x14e>
				width = 0;
  802561:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802568:	e9 3b ff ff ff       	jmpq   8024a8 <vprintfmt+0x89>
  80256d:	e9 36 ff ff ff       	jmpq   8024a8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802572:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802579:	e9 2a ff ff ff       	jmpq   8024a8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80257e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802582:	79 12                	jns    802596 <vprintfmt+0x177>
				width = precision, precision = -1;
  802584:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802587:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80258a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802591:	e9 12 ff ff ff       	jmpq   8024a8 <vprintfmt+0x89>
  802596:	e9 0d ff ff ff       	jmpq   8024a8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80259b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80259f:	e9 04 ff ff ff       	jmpq   8024a8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8025a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a7:	83 f8 30             	cmp    $0x30,%eax
  8025aa:	73 17                	jae    8025c3 <vprintfmt+0x1a4>
  8025ac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025b3:	89 c0                	mov    %eax,%eax
  8025b5:	48 01 d0             	add    %rdx,%rax
  8025b8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025bb:	83 c2 08             	add    $0x8,%edx
  8025be:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025c1:	eb 0f                	jmp    8025d2 <vprintfmt+0x1b3>
  8025c3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025c7:	48 89 d0             	mov    %rdx,%rax
  8025ca:	48 83 c2 08          	add    $0x8,%rdx
  8025ce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025d2:	8b 10                	mov    (%rax),%edx
  8025d4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025dc:	48 89 ce             	mov    %rcx,%rsi
  8025df:	89 d7                	mov    %edx,%edi
  8025e1:	ff d0                	callq  *%rax
			break;
  8025e3:	e9 53 03 00 00       	jmpq   80293b <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025eb:	83 f8 30             	cmp    $0x30,%eax
  8025ee:	73 17                	jae    802607 <vprintfmt+0x1e8>
  8025f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025f7:	89 c0                	mov    %eax,%eax
  8025f9:	48 01 d0             	add    %rdx,%rax
  8025fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025ff:	83 c2 08             	add    $0x8,%edx
  802602:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802605:	eb 0f                	jmp    802616 <vprintfmt+0x1f7>
  802607:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80260b:	48 89 d0             	mov    %rdx,%rax
  80260e:	48 83 c2 08          	add    $0x8,%rdx
  802612:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802616:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802618:	85 db                	test   %ebx,%ebx
  80261a:	79 02                	jns    80261e <vprintfmt+0x1ff>
				err = -err;
  80261c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80261e:	83 fb 15             	cmp    $0x15,%ebx
  802621:	7f 16                	jg     802639 <vprintfmt+0x21a>
  802623:	48 b8 20 39 80 00 00 	movabs $0x803920,%rax
  80262a:	00 00 00 
  80262d:	48 63 d3             	movslq %ebx,%rdx
  802630:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802634:	4d 85 e4             	test   %r12,%r12
  802637:	75 2e                	jne    802667 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802639:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80263d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802641:	89 d9                	mov    %ebx,%ecx
  802643:	48 ba e1 39 80 00 00 	movabs $0x8039e1,%rdx
  80264a:	00 00 00 
  80264d:	48 89 c7             	mov    %rax,%rdi
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
  802655:	49 b8 4a 29 80 00 00 	movabs $0x80294a,%r8
  80265c:	00 00 00 
  80265f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802662:	e9 d4 02 00 00       	jmpq   80293b <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802667:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80266b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80266f:	4c 89 e1             	mov    %r12,%rcx
  802672:	48 ba ea 39 80 00 00 	movabs $0x8039ea,%rdx
  802679:	00 00 00 
  80267c:	48 89 c7             	mov    %rax,%rdi
  80267f:	b8 00 00 00 00       	mov    $0x0,%eax
  802684:	49 b8 4a 29 80 00 00 	movabs $0x80294a,%r8
  80268b:	00 00 00 
  80268e:	41 ff d0             	callq  *%r8
			break;
  802691:	e9 a5 02 00 00       	jmpq   80293b <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802696:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802699:	83 f8 30             	cmp    $0x30,%eax
  80269c:	73 17                	jae    8026b5 <vprintfmt+0x296>
  80269e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026a5:	89 c0                	mov    %eax,%eax
  8026a7:	48 01 d0             	add    %rdx,%rax
  8026aa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8026ad:	83 c2 08             	add    $0x8,%edx
  8026b0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8026b3:	eb 0f                	jmp    8026c4 <vprintfmt+0x2a5>
  8026b5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026b9:	48 89 d0             	mov    %rdx,%rax
  8026bc:	48 83 c2 08          	add    $0x8,%rdx
  8026c0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026c4:	4c 8b 20             	mov    (%rax),%r12
  8026c7:	4d 85 e4             	test   %r12,%r12
  8026ca:	75 0a                	jne    8026d6 <vprintfmt+0x2b7>
				p = "(null)";
  8026cc:	49 bc ed 39 80 00 00 	movabs $0x8039ed,%r12
  8026d3:	00 00 00 
			if (width > 0 && padc != '-')
  8026d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026da:	7e 3f                	jle    80271b <vprintfmt+0x2fc>
  8026dc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026e0:	74 39                	je     80271b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026e2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026e5:	48 98                	cltq   
  8026e7:	48 89 c6             	mov    %rax,%rsi
  8026ea:	4c 89 e7             	mov    %r12,%rdi
  8026ed:	48 b8 f6 2b 80 00 00 	movabs $0x802bf6,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	callq  *%rax
  8026f9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026fc:	eb 17                	jmp    802715 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026fe:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802702:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802706:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80270a:	48 89 ce             	mov    %rcx,%rsi
  80270d:	89 d7                	mov    %edx,%edi
  80270f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802711:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802715:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802719:	7f e3                	jg     8026fe <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80271b:	eb 37                	jmp    802754 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80271d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802721:	74 1e                	je     802741 <vprintfmt+0x322>
  802723:	83 fb 1f             	cmp    $0x1f,%ebx
  802726:	7e 05                	jle    80272d <vprintfmt+0x30e>
  802728:	83 fb 7e             	cmp    $0x7e,%ebx
  80272b:	7e 14                	jle    802741 <vprintfmt+0x322>
					putch('?', putdat);
  80272d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802731:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802735:	48 89 d6             	mov    %rdx,%rsi
  802738:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80273d:	ff d0                	callq  *%rax
  80273f:	eb 0f                	jmp    802750 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802741:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802745:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802749:	48 89 d6             	mov    %rdx,%rsi
  80274c:	89 df                	mov    %ebx,%edi
  80274e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802750:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802754:	4c 89 e0             	mov    %r12,%rax
  802757:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80275b:	0f b6 00             	movzbl (%rax),%eax
  80275e:	0f be d8             	movsbl %al,%ebx
  802761:	85 db                	test   %ebx,%ebx
  802763:	74 10                	je     802775 <vprintfmt+0x356>
  802765:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802769:	78 b2                	js     80271d <vprintfmt+0x2fe>
  80276b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80276f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802773:	79 a8                	jns    80271d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802775:	eb 16                	jmp    80278d <vprintfmt+0x36e>
				putch(' ', putdat);
  802777:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80277b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80277f:	48 89 d6             	mov    %rdx,%rsi
  802782:	bf 20 00 00 00       	mov    $0x20,%edi
  802787:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802789:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80278d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802791:	7f e4                	jg     802777 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802793:	e9 a3 01 00 00       	jmpq   80293b <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802798:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80279c:	be 03 00 00 00       	mov    $0x3,%esi
  8027a1:	48 89 c7             	mov    %rax,%rdi
  8027a4:	48 b8 0f 23 80 00 00 	movabs $0x80230f,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax
  8027b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8027b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b8:	48 85 c0             	test   %rax,%rax
  8027bb:	79 1d                	jns    8027da <vprintfmt+0x3bb>
				putch('-', putdat);
  8027bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027c5:	48 89 d6             	mov    %rdx,%rsi
  8027c8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027cd:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d3:	48 f7 d8             	neg    %rax
  8027d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027da:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027e1:	e9 e8 00 00 00       	jmpq   8028ce <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027e6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027ea:	be 03 00 00 00       	mov    $0x3,%esi
  8027ef:	48 89 c7             	mov    %rax,%rdi
  8027f2:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802802:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802809:	e9 c0 00 00 00       	jmpq   8028ce <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80280e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802812:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802816:	48 89 d6             	mov    %rdx,%rsi
  802819:	bf 58 00 00 00       	mov    $0x58,%edi
  80281e:	ff d0                	callq  *%rax
			putch('X', putdat);
  802820:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802824:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802828:	48 89 d6             	mov    %rdx,%rsi
  80282b:	bf 58 00 00 00       	mov    $0x58,%edi
  802830:	ff d0                	callq  *%rax
			putch('X', putdat);
  802832:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802836:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80283a:	48 89 d6             	mov    %rdx,%rsi
  80283d:	bf 58 00 00 00       	mov    $0x58,%edi
  802842:	ff d0                	callq  *%rax
			break;
  802844:	e9 f2 00 00 00       	jmpq   80293b <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802849:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80284d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802851:	48 89 d6             	mov    %rdx,%rsi
  802854:	bf 30 00 00 00       	mov    $0x30,%edi
  802859:	ff d0                	callq  *%rax
			putch('x', putdat);
  80285b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80285f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802863:	48 89 d6             	mov    %rdx,%rsi
  802866:	bf 78 00 00 00       	mov    $0x78,%edi
  80286b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80286d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802870:	83 f8 30             	cmp    $0x30,%eax
  802873:	73 17                	jae    80288c <vprintfmt+0x46d>
  802875:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802879:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80287c:	89 c0                	mov    %eax,%eax
  80287e:	48 01 d0             	add    %rdx,%rax
  802881:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802884:	83 c2 08             	add    $0x8,%edx
  802887:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80288a:	eb 0f                	jmp    80289b <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80288c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802890:	48 89 d0             	mov    %rdx,%rax
  802893:	48 83 c2 08          	add    $0x8,%rdx
  802897:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80289b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80289e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8028a2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8028a9:	eb 23                	jmp    8028ce <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8028ab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028af:	be 03 00 00 00       	mov    $0x3,%esi
  8028b4:	48 89 c7             	mov    %rax,%rdi
  8028b7:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  8028be:	00 00 00 
  8028c1:	ff d0                	callq  *%rax
  8028c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028c7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028ce:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028d3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028d6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028dd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028e5:	45 89 c1             	mov    %r8d,%r9d
  8028e8:	41 89 f8             	mov    %edi,%r8d
  8028eb:	48 89 c7             	mov    %rax,%rdi
  8028ee:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  8028f5:	00 00 00 
  8028f8:	ff d0                	callq  *%rax
			break;
  8028fa:	eb 3f                	jmp    80293b <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802900:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802904:	48 89 d6             	mov    %rdx,%rsi
  802907:	89 df                	mov    %ebx,%edi
  802909:	ff d0                	callq  *%rax
			break;
  80290b:	eb 2e                	jmp    80293b <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80290d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802911:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802915:	48 89 d6             	mov    %rdx,%rsi
  802918:	bf 25 00 00 00       	mov    $0x25,%edi
  80291d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80291f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802924:	eb 05                	jmp    80292b <vprintfmt+0x50c>
  802926:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80292b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80292f:	48 83 e8 01          	sub    $0x1,%rax
  802933:	0f b6 00             	movzbl (%rax),%eax
  802936:	3c 25                	cmp    $0x25,%al
  802938:	75 ec                	jne    802926 <vprintfmt+0x507>
				/* do nothing */;
			break;
  80293a:	90                   	nop
		}
	}
  80293b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80293c:	e9 30 fb ff ff       	jmpq   802471 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802941:	48 83 c4 60          	add    $0x60,%rsp
  802945:	5b                   	pop    %rbx
  802946:	41 5c                	pop    %r12
  802948:	5d                   	pop    %rbp
  802949:	c3                   	retq   

000000000080294a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80294a:	55                   	push   %rbp
  80294b:	48 89 e5             	mov    %rsp,%rbp
  80294e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802955:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80295c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802963:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80296a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802971:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802978:	84 c0                	test   %al,%al
  80297a:	74 20                	je     80299c <printfmt+0x52>
  80297c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802980:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802984:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802988:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80298c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802990:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802994:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802998:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80299c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8029a3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8029aa:	00 00 00 
  8029ad:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8029b4:	00 00 00 
  8029b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029bb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029c9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029d0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029d7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029de:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029e5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029ec:	48 89 c7             	mov    %rax,%rdi
  8029ef:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  8029f6:	00 00 00 
  8029f9:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 10          	sub    $0x10,%rsp
  802a05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802a0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a10:	8b 40 10             	mov    0x10(%rax),%eax
  802a13:	8d 50 01             	lea    0x1(%rax),%edx
  802a16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a21:	48 8b 10             	mov    (%rax),%rdx
  802a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a28:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a2c:	48 39 c2             	cmp    %rax,%rdx
  802a2f:	73 17                	jae    802a48 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a35:	48 8b 00             	mov    (%rax),%rax
  802a38:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a40:	48 89 0a             	mov    %rcx,(%rdx)
  802a43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a46:	88 10                	mov    %dl,(%rax)
}
  802a48:	c9                   	leaveq 
  802a49:	c3                   	retq   

0000000000802a4a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a4a:	55                   	push   %rbp
  802a4b:	48 89 e5             	mov    %rsp,%rbp
  802a4e:	48 83 ec 50          	sub    $0x50,%rsp
  802a52:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a56:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a59:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a5d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a61:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a65:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a69:	48 8b 0a             	mov    (%rdx),%rcx
  802a6c:	48 89 08             	mov    %rcx,(%rax)
  802a6f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a73:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a77:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a7b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a83:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a87:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a8a:	48 98                	cltq   
  802a8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a94:	48 01 d0             	add    %rdx,%rax
  802a97:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802aa2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802aa7:	74 06                	je     802aaf <vsnprintf+0x65>
  802aa9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802aad:	7f 07                	jg     802ab6 <vsnprintf+0x6c>
		return -E_INVAL;
  802aaf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ab4:	eb 2f                	jmp    802ae5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802ab6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802aba:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802abe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ac2:	48 89 c6             	mov    %rax,%rsi
  802ac5:	48 bf fd 29 80 00 00 	movabs $0x8029fd,%rdi
  802acc:	00 00 00 
  802acf:	48 b8 1f 24 80 00 00 	movabs $0x80241f,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802adb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802adf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802ae2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802ae5:	c9                   	leaveq 
  802ae6:	c3                   	retq   

0000000000802ae7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802ae7:	55                   	push   %rbp
  802ae8:	48 89 e5             	mov    %rsp,%rbp
  802aeb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802af2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802af9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802aff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802b06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b14:	84 c0                	test   %al,%al
  802b16:	74 20                	je     802b38 <snprintf+0x51>
  802b18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b38:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b3f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b46:	00 00 00 
  802b49:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b50:	00 00 00 
  802b53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b57:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b65:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b6c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b73:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b7a:	48 8b 0a             	mov    (%rdx),%rcx
  802b7d:	48 89 08             	mov    %rcx,(%rax)
  802b80:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b84:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b88:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b8c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b90:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b97:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b9e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802ba4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802bab:	48 89 c7             	mov    %rax,%rdi
  802bae:	48 b8 4a 2a 80 00 00 	movabs $0x802a4a,%rax
  802bb5:	00 00 00 
  802bb8:	ff d0                	callq  *%rax
  802bba:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802bc0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bc6:	c9                   	leaveq 
  802bc7:	c3                   	retq   

0000000000802bc8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802bc8:	55                   	push   %rbp
  802bc9:	48 89 e5             	mov    %rsp,%rbp
  802bcc:	48 83 ec 18          	sub    $0x18,%rsp
  802bd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bdb:	eb 09                	jmp    802be6 <strlen+0x1e>
		n++;
  802bdd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802be1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bea:	0f b6 00             	movzbl (%rax),%eax
  802bed:	84 c0                	test   %al,%al
  802bef:	75 ec                	jne    802bdd <strlen+0x15>
		n++;
	return n;
  802bf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bf4:	c9                   	leaveq 
  802bf5:	c3                   	retq   

0000000000802bf6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802bf6:	55                   	push   %rbp
  802bf7:	48 89 e5             	mov    %rsp,%rbp
  802bfa:	48 83 ec 20          	sub    $0x20,%rsp
  802bfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c0d:	eb 0e                	jmp    802c1d <strnlen+0x27>
		n++;
  802c0f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c13:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c18:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c22:	74 0b                	je     802c2f <strnlen+0x39>
  802c24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c28:	0f b6 00             	movzbl (%rax),%eax
  802c2b:	84 c0                	test   %al,%al
  802c2d:	75 e0                	jne    802c0f <strnlen+0x19>
		n++;
	return n;
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c32:	c9                   	leaveq 
  802c33:	c3                   	retq   

0000000000802c34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c34:	55                   	push   %rbp
  802c35:	48 89 e5             	mov    %rsp,%rbp
  802c38:	48 83 ec 20          	sub    $0x20,%rsp
  802c3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c4c:	90                   	nop
  802c4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c51:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c59:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c5d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c61:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c65:	0f b6 12             	movzbl (%rdx),%edx
  802c68:	88 10                	mov    %dl,(%rax)
  802c6a:	0f b6 00             	movzbl (%rax),%eax
  802c6d:	84 c0                	test   %al,%al
  802c6f:	75 dc                	jne    802c4d <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c75:	c9                   	leaveq 
  802c76:	c3                   	retq   

0000000000802c77 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c77:	55                   	push   %rbp
  802c78:	48 89 e5             	mov    %rsp,%rbp
  802c7b:	48 83 ec 20          	sub    $0x20,%rsp
  802c7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8b:	48 89 c7             	mov    %rax,%rdi
  802c8e:	48 b8 c8 2b 80 00 00 	movabs $0x802bc8,%rax
  802c95:	00 00 00 
  802c98:	ff d0                	callq  *%rax
  802c9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca0:	48 63 d0             	movslq %eax,%rdx
  802ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca7:	48 01 c2             	add    %rax,%rdx
  802caa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cae:	48 89 c6             	mov    %rax,%rsi
  802cb1:	48 89 d7             	mov    %rdx,%rdi
  802cb4:	48 b8 34 2c 80 00 00 	movabs $0x802c34,%rax
  802cbb:	00 00 00 
  802cbe:	ff d0                	callq  *%rax
	return dst;
  802cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802cc4:	c9                   	leaveq 
  802cc5:	c3                   	retq   

0000000000802cc6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802cc6:	55                   	push   %rbp
  802cc7:	48 89 e5             	mov    %rsp,%rbp
  802cca:	48 83 ec 28          	sub    $0x28,%rsp
  802cce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802ce2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ce9:	00 
  802cea:	eb 2a                	jmp    802d16 <strncpy+0x50>
		*dst++ = *src;
  802cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cf4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cf8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cfc:	0f b6 12             	movzbl (%rdx),%edx
  802cff:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802d01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d05:	0f b6 00             	movzbl (%rax),%eax
  802d08:	84 c0                	test   %al,%al
  802d0a:	74 05                	je     802d11 <strncpy+0x4b>
			src++;
  802d0c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d11:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d1e:	72 cc                	jb     802cec <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d24:	c9                   	leaveq 
  802d25:	c3                   	retq   

0000000000802d26 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 28          	sub    $0x28,%rsp
  802d2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d36:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d42:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d47:	74 3d                	je     802d86 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d49:	eb 1d                	jmp    802d68 <strlcpy+0x42>
			*dst++ = *src++;
  802d4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d53:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d57:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d5b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d5f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d63:	0f b6 12             	movzbl (%rdx),%edx
  802d66:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d68:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d6d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d72:	74 0b                	je     802d7f <strlcpy+0x59>
  802d74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d78:	0f b6 00             	movzbl (%rax),%eax
  802d7b:	84 c0                	test   %al,%al
  802d7d:	75 cc                	jne    802d4b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d83:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8e:	48 29 c2             	sub    %rax,%rdx
  802d91:	48 89 d0             	mov    %rdx,%rax
}
  802d94:	c9                   	leaveq 
  802d95:	c3                   	retq   

0000000000802d96 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d96:	55                   	push   %rbp
  802d97:	48 89 e5             	mov    %rsp,%rbp
  802d9a:	48 83 ec 10          	sub    $0x10,%rsp
  802d9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802da2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802da6:	eb 0a                	jmp    802db2 <strcmp+0x1c>
		p++, q++;
  802da8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dad:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db6:	0f b6 00             	movzbl (%rax),%eax
  802db9:	84 c0                	test   %al,%al
  802dbb:	74 12                	je     802dcf <strcmp+0x39>
  802dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc1:	0f b6 10             	movzbl (%rax),%edx
  802dc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc8:	0f b6 00             	movzbl (%rax),%eax
  802dcb:	38 c2                	cmp    %al,%dl
  802dcd:	74 d9                	je     802da8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802dcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd3:	0f b6 00             	movzbl (%rax),%eax
  802dd6:	0f b6 d0             	movzbl %al,%edx
  802dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddd:	0f b6 00             	movzbl (%rax),%eax
  802de0:	0f b6 c0             	movzbl %al,%eax
  802de3:	29 c2                	sub    %eax,%edx
  802de5:	89 d0                	mov    %edx,%eax
}
  802de7:	c9                   	leaveq 
  802de8:	c3                   	retq   

0000000000802de9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802de9:	55                   	push   %rbp
  802dea:	48 89 e5             	mov    %rsp,%rbp
  802ded:	48 83 ec 18          	sub    $0x18,%rsp
  802df1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802df5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802df9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802dfd:	eb 0f                	jmp    802e0e <strncmp+0x25>
		n--, p++, q++;
  802dff:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802e04:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e09:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e0e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e13:	74 1d                	je     802e32 <strncmp+0x49>
  802e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e19:	0f b6 00             	movzbl (%rax),%eax
  802e1c:	84 c0                	test   %al,%al
  802e1e:	74 12                	je     802e32 <strncmp+0x49>
  802e20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e24:	0f b6 10             	movzbl (%rax),%edx
  802e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2b:	0f b6 00             	movzbl (%rax),%eax
  802e2e:	38 c2                	cmp    %al,%dl
  802e30:	74 cd                	je     802dff <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e32:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e37:	75 07                	jne    802e40 <strncmp+0x57>
		return 0;
  802e39:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3e:	eb 18                	jmp    802e58 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e44:	0f b6 00             	movzbl (%rax),%eax
  802e47:	0f b6 d0             	movzbl %al,%edx
  802e4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4e:	0f b6 00             	movzbl (%rax),%eax
  802e51:	0f b6 c0             	movzbl %al,%eax
  802e54:	29 c2                	sub    %eax,%edx
  802e56:	89 d0                	mov    %edx,%eax
}
  802e58:	c9                   	leaveq 
  802e59:	c3                   	retq   

0000000000802e5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e5a:	55                   	push   %rbp
  802e5b:	48 89 e5             	mov    %rsp,%rbp
  802e5e:	48 83 ec 0c          	sub    $0xc,%rsp
  802e62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e66:	89 f0                	mov    %esi,%eax
  802e68:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e6b:	eb 17                	jmp    802e84 <strchr+0x2a>
		if (*s == c)
  802e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e71:	0f b6 00             	movzbl (%rax),%eax
  802e74:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e77:	75 06                	jne    802e7f <strchr+0x25>
			return (char *) s;
  802e79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7d:	eb 15                	jmp    802e94 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e7f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e88:	0f b6 00             	movzbl (%rax),%eax
  802e8b:	84 c0                	test   %al,%al
  802e8d:	75 de                	jne    802e6d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e94:	c9                   	leaveq 
  802e95:	c3                   	retq   

0000000000802e96 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e96:	55                   	push   %rbp
  802e97:	48 89 e5             	mov    %rsp,%rbp
  802e9a:	48 83 ec 0c          	sub    $0xc,%rsp
  802e9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ea2:	89 f0                	mov    %esi,%eax
  802ea4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802ea7:	eb 13                	jmp    802ebc <strfind+0x26>
		if (*s == c)
  802ea9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ead:	0f b6 00             	movzbl (%rax),%eax
  802eb0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802eb3:	75 02                	jne    802eb7 <strfind+0x21>
			break;
  802eb5:	eb 10                	jmp    802ec7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802eb7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ebc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec0:	0f b6 00             	movzbl (%rax),%eax
  802ec3:	84 c0                	test   %al,%al
  802ec5:	75 e2                	jne    802ea9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ec7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ecb:	c9                   	leaveq 
  802ecc:	c3                   	retq   

0000000000802ecd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802ecd:	55                   	push   %rbp
  802ece:	48 89 e5             	mov    %rsp,%rbp
  802ed1:	48 83 ec 18          	sub    $0x18,%rsp
  802ed5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ed9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802edc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ee0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ee5:	75 06                	jne    802eed <memset+0x20>
		return v;
  802ee7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eeb:	eb 69                	jmp    802f56 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef1:	83 e0 03             	and    $0x3,%eax
  802ef4:	48 85 c0             	test   %rax,%rax
  802ef7:	75 48                	jne    802f41 <memset+0x74>
  802ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efd:	83 e0 03             	and    $0x3,%eax
  802f00:	48 85 c0             	test   %rax,%rax
  802f03:	75 3c                	jne    802f41 <memset+0x74>
		c &= 0xFF;
  802f05:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802f0c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f0f:	c1 e0 18             	shl    $0x18,%eax
  802f12:	89 c2                	mov    %eax,%edx
  802f14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f17:	c1 e0 10             	shl    $0x10,%eax
  802f1a:	09 c2                	or     %eax,%edx
  802f1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f1f:	c1 e0 08             	shl    $0x8,%eax
  802f22:	09 d0                	or     %edx,%eax
  802f24:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2b:	48 c1 e8 02          	shr    $0x2,%rax
  802f2f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f36:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f39:	48 89 d7             	mov    %rdx,%rdi
  802f3c:	fc                   	cld    
  802f3d:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f3f:	eb 11                	jmp    802f52 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f45:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f48:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f4c:	48 89 d7             	mov    %rdx,%rdi
  802f4f:	fc                   	cld    
  802f50:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f56:	c9                   	leaveq 
  802f57:	c3                   	retq   

0000000000802f58 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f58:	55                   	push   %rbp
  802f59:	48 89 e5             	mov    %rsp,%rbp
  802f5c:	48 83 ec 28          	sub    $0x28,%rsp
  802f60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f80:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f84:	0f 83 88 00 00 00    	jae    803012 <memmove+0xba>
  802f8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f92:	48 01 d0             	add    %rdx,%rax
  802f95:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f99:	76 77                	jbe    803012 <memmove+0xba>
		s += n;
  802f9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802fa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802faf:	83 e0 03             	and    $0x3,%eax
  802fb2:	48 85 c0             	test   %rax,%rax
  802fb5:	75 3b                	jne    802ff2 <memmove+0x9a>
  802fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbb:	83 e0 03             	and    $0x3,%eax
  802fbe:	48 85 c0             	test   %rax,%rax
  802fc1:	75 2f                	jne    802ff2 <memmove+0x9a>
  802fc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc7:	83 e0 03             	and    $0x3,%eax
  802fca:	48 85 c0             	test   %rax,%rax
  802fcd:	75 23                	jne    802ff2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd3:	48 83 e8 04          	sub    $0x4,%rax
  802fd7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fdb:	48 83 ea 04          	sub    $0x4,%rdx
  802fdf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fe3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fe7:	48 89 c7             	mov    %rax,%rdi
  802fea:	48 89 d6             	mov    %rdx,%rsi
  802fed:	fd                   	std    
  802fee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802ff0:	eb 1d                	jmp    80300f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802ffa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffe:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803006:	48 89 d7             	mov    %rdx,%rdi
  803009:	48 89 c1             	mov    %rax,%rcx
  80300c:	fd                   	std    
  80300d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80300f:	fc                   	cld    
  803010:	eb 57                	jmp    803069 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803012:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803016:	83 e0 03             	and    $0x3,%eax
  803019:	48 85 c0             	test   %rax,%rax
  80301c:	75 36                	jne    803054 <memmove+0xfc>
  80301e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803022:	83 e0 03             	and    $0x3,%eax
  803025:	48 85 c0             	test   %rax,%rax
  803028:	75 2a                	jne    803054 <memmove+0xfc>
  80302a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80302e:	83 e0 03             	and    $0x3,%eax
  803031:	48 85 c0             	test   %rax,%rax
  803034:	75 1e                	jne    803054 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803036:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80303a:	48 c1 e8 02          	shr    $0x2,%rax
  80303e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803045:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803049:	48 89 c7             	mov    %rax,%rdi
  80304c:	48 89 d6             	mov    %rdx,%rsi
  80304f:	fc                   	cld    
  803050:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803052:	eb 15                	jmp    803069 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803054:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803058:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80305c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803060:	48 89 c7             	mov    %rax,%rdi
  803063:	48 89 d6             	mov    %rdx,%rsi
  803066:	fc                   	cld    
  803067:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80306d:	c9                   	leaveq 
  80306e:	c3                   	retq   

000000000080306f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80306f:	55                   	push   %rbp
  803070:	48 89 e5             	mov    %rsp,%rbp
  803073:	48 83 ec 18          	sub    $0x18,%rsp
  803077:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80307b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80307f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803083:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803087:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80308b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80308f:	48 89 ce             	mov    %rcx,%rsi
  803092:	48 89 c7             	mov    %rax,%rdi
  803095:	48 b8 58 2f 80 00 00 	movabs $0x802f58,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
}
  8030a1:	c9                   	leaveq 
  8030a2:	c3                   	retq   

00000000008030a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8030a3:	55                   	push   %rbp
  8030a4:	48 89 e5             	mov    %rsp,%rbp
  8030a7:	48 83 ec 28          	sub    $0x28,%rsp
  8030ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8030b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030c7:	eb 36                	jmp    8030ff <memcmp+0x5c>
		if (*s1 != *s2)
  8030c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030cd:	0f b6 10             	movzbl (%rax),%edx
  8030d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d4:	0f b6 00             	movzbl (%rax),%eax
  8030d7:	38 c2                	cmp    %al,%dl
  8030d9:	74 1a                	je     8030f5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030df:	0f b6 00             	movzbl (%rax),%eax
  8030e2:	0f b6 d0             	movzbl %al,%edx
  8030e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e9:	0f b6 00             	movzbl (%rax),%eax
  8030ec:	0f b6 c0             	movzbl %al,%eax
  8030ef:	29 c2                	sub    %eax,%edx
  8030f1:	89 d0                	mov    %edx,%eax
  8030f3:	eb 20                	jmp    803115 <memcmp+0x72>
		s1++, s2++;
  8030f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030fa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803103:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803107:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80310b:	48 85 c0             	test   %rax,%rax
  80310e:	75 b9                	jne    8030c9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803115:	c9                   	leaveq 
  803116:	c3                   	retq   

0000000000803117 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803117:	55                   	push   %rbp
  803118:	48 89 e5             	mov    %rsp,%rbp
  80311b:	48 83 ec 28          	sub    $0x28,%rsp
  80311f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803123:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803126:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80312a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80312e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803132:	48 01 d0             	add    %rdx,%rax
  803135:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803139:	eb 15                	jmp    803150 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80313b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313f:	0f b6 10             	movzbl (%rax),%edx
  803142:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803145:	38 c2                	cmp    %al,%dl
  803147:	75 02                	jne    80314b <memfind+0x34>
			break;
  803149:	eb 0f                	jmp    80315a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80314b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803150:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803154:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803158:	72 e1                	jb     80313b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80315a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80315e:	c9                   	leaveq 
  80315f:	c3                   	retq   

0000000000803160 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803160:	55                   	push   %rbp
  803161:	48 89 e5             	mov    %rsp,%rbp
  803164:	48 83 ec 34          	sub    $0x34,%rsp
  803168:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80316c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803170:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803173:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80317a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803181:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803182:	eb 05                	jmp    803189 <strtol+0x29>
		s++;
  803184:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803189:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318d:	0f b6 00             	movzbl (%rax),%eax
  803190:	3c 20                	cmp    $0x20,%al
  803192:	74 f0                	je     803184 <strtol+0x24>
  803194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803198:	0f b6 00             	movzbl (%rax),%eax
  80319b:	3c 09                	cmp    $0x9,%al
  80319d:	74 e5                	je     803184 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80319f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a3:	0f b6 00             	movzbl (%rax),%eax
  8031a6:	3c 2b                	cmp    $0x2b,%al
  8031a8:	75 07                	jne    8031b1 <strtol+0x51>
		s++;
  8031aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031af:	eb 17                	jmp    8031c8 <strtol+0x68>
	else if (*s == '-')
  8031b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b5:	0f b6 00             	movzbl (%rax),%eax
  8031b8:	3c 2d                	cmp    $0x2d,%al
  8031ba:	75 0c                	jne    8031c8 <strtol+0x68>
		s++, neg = 1;
  8031bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031cc:	74 06                	je     8031d4 <strtol+0x74>
  8031ce:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031d2:	75 28                	jne    8031fc <strtol+0x9c>
  8031d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d8:	0f b6 00             	movzbl (%rax),%eax
  8031db:	3c 30                	cmp    $0x30,%al
  8031dd:	75 1d                	jne    8031fc <strtol+0x9c>
  8031df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e3:	48 83 c0 01          	add    $0x1,%rax
  8031e7:	0f b6 00             	movzbl (%rax),%eax
  8031ea:	3c 78                	cmp    $0x78,%al
  8031ec:	75 0e                	jne    8031fc <strtol+0x9c>
		s += 2, base = 16;
  8031ee:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031f3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031fa:	eb 2c                	jmp    803228 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803200:	75 19                	jne    80321b <strtol+0xbb>
  803202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803206:	0f b6 00             	movzbl (%rax),%eax
  803209:	3c 30                	cmp    $0x30,%al
  80320b:	75 0e                	jne    80321b <strtol+0xbb>
		s++, base = 8;
  80320d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803212:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803219:	eb 0d                	jmp    803228 <strtol+0xc8>
	else if (base == 0)
  80321b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80321f:	75 07                	jne    803228 <strtol+0xc8>
		base = 10;
  803221:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803228:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322c:	0f b6 00             	movzbl (%rax),%eax
  80322f:	3c 2f                	cmp    $0x2f,%al
  803231:	7e 1d                	jle    803250 <strtol+0xf0>
  803233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803237:	0f b6 00             	movzbl (%rax),%eax
  80323a:	3c 39                	cmp    $0x39,%al
  80323c:	7f 12                	jg     803250 <strtol+0xf0>
			dig = *s - '0';
  80323e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803242:	0f b6 00             	movzbl (%rax),%eax
  803245:	0f be c0             	movsbl %al,%eax
  803248:	83 e8 30             	sub    $0x30,%eax
  80324b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80324e:	eb 4e                	jmp    80329e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803254:	0f b6 00             	movzbl (%rax),%eax
  803257:	3c 60                	cmp    $0x60,%al
  803259:	7e 1d                	jle    803278 <strtol+0x118>
  80325b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325f:	0f b6 00             	movzbl (%rax),%eax
  803262:	3c 7a                	cmp    $0x7a,%al
  803264:	7f 12                	jg     803278 <strtol+0x118>
			dig = *s - 'a' + 10;
  803266:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326a:	0f b6 00             	movzbl (%rax),%eax
  80326d:	0f be c0             	movsbl %al,%eax
  803270:	83 e8 57             	sub    $0x57,%eax
  803273:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803276:	eb 26                	jmp    80329e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803278:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327c:	0f b6 00             	movzbl (%rax),%eax
  80327f:	3c 40                	cmp    $0x40,%al
  803281:	7e 48                	jle    8032cb <strtol+0x16b>
  803283:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803287:	0f b6 00             	movzbl (%rax),%eax
  80328a:	3c 5a                	cmp    $0x5a,%al
  80328c:	7f 3d                	jg     8032cb <strtol+0x16b>
			dig = *s - 'A' + 10;
  80328e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803292:	0f b6 00             	movzbl (%rax),%eax
  803295:	0f be c0             	movsbl %al,%eax
  803298:	83 e8 37             	sub    $0x37,%eax
  80329b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80329e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8032a4:	7c 02                	jl     8032a8 <strtol+0x148>
			break;
  8032a6:	eb 23                	jmp    8032cb <strtol+0x16b>
		s++, val = (val * base) + dig;
  8032a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8032ad:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032b0:	48 98                	cltq   
  8032b2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8032b7:	48 89 c2             	mov    %rax,%rdx
  8032ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032bd:	48 98                	cltq   
  8032bf:	48 01 d0             	add    %rdx,%rax
  8032c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032c6:	e9 5d ff ff ff       	jmpq   803228 <strtol+0xc8>

	if (endptr)
  8032cb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032d0:	74 0b                	je     8032dd <strtol+0x17d>
		*endptr = (char *) s;
  8032d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032da:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e1:	74 09                	je     8032ec <strtol+0x18c>
  8032e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e7:	48 f7 d8             	neg    %rax
  8032ea:	eb 04                	jmp    8032f0 <strtol+0x190>
  8032ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032f0:	c9                   	leaveq 
  8032f1:	c3                   	retq   

00000000008032f2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8032f2:	55                   	push   %rbp
  8032f3:	48 89 e5             	mov    %rsp,%rbp
  8032f6:	48 83 ec 30          	sub    $0x30,%rsp
  8032fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803302:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803306:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80330a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80330e:	0f b6 00             	movzbl (%rax),%eax
  803311:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803314:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803318:	75 06                	jne    803320 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80331a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331e:	eb 6b                	jmp    80338b <strstr+0x99>

	len = strlen(str);
  803320:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803324:	48 89 c7             	mov    %rax,%rdi
  803327:	48 b8 c8 2b 80 00 00 	movabs $0x802bc8,%rax
  80332e:	00 00 00 
  803331:	ff d0                	callq  *%rax
  803333:	48 98                	cltq   
  803335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803339:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80333d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803341:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803345:	0f b6 00             	movzbl (%rax),%eax
  803348:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80334b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80334f:	75 07                	jne    803358 <strstr+0x66>
				return (char *) 0;
  803351:	b8 00 00 00 00       	mov    $0x0,%eax
  803356:	eb 33                	jmp    80338b <strstr+0x99>
		} while (sc != c);
  803358:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80335c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80335f:	75 d8                	jne    803339 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803361:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803365:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803369:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336d:	48 89 ce             	mov    %rcx,%rsi
  803370:	48 89 c7             	mov    %rax,%rdi
  803373:	48 b8 e9 2d 80 00 00 	movabs $0x802de9,%rax
  80337a:	00 00 00 
  80337d:	ff d0                	callq  *%rax
  80337f:	85 c0                	test   %eax,%eax
  803381:	75 b6                	jne    803339 <strstr+0x47>

	return (char *) (in - 1);
  803383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803387:	48 83 e8 01          	sub    $0x1,%rax
}
  80338b:	c9                   	leaveq 
  80338c:	c3                   	retq   

000000000080338d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80338d:	55                   	push   %rbp
  80338e:	48 89 e5             	mov    %rsp,%rbp
  803391:	48 83 ec 30          	sub    $0x30,%rsp
  803395:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803399:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80339d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8033a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033a6:	75 0e                	jne    8033b6 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033a8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033af:	00 00 00 
  8033b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ba:	48 89 c7             	mov    %rax,%rdi
  8033bd:	48 b8 2a 05 80 00 00 	movabs $0x80052a,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
  8033c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d0:	79 27                	jns    8033f9 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033d7:	74 0a                	je     8033e3 <ipc_recv+0x56>
            *from_env_store = 0;
  8033d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033dd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033e3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033e8:	74 0a                	je     8033f4 <ipc_recv+0x67>
            *perm_store = 0;
  8033ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ee:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f7:	eb 53                	jmp    80344c <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033fe:	74 19                	je     803419 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803400:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803407:	00 00 00 
  80340a:	48 8b 00             	mov    (%rax),%rax
  80340d:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803417:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803419:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80341e:	74 19                	je     803439 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803420:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803427:	00 00 00 
  80342a:	48 8b 00             	mov    (%rax),%rax
  80342d:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803437:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803439:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803440:	00 00 00 
  803443:	48 8b 00             	mov    (%rax),%rax
  803446:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80344c:	c9                   	leaveq 
  80344d:	c3                   	retq   

000000000080344e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80344e:	55                   	push   %rbp
  80344f:	48 89 e5             	mov    %rsp,%rbp
  803452:	48 83 ec 30          	sub    $0x30,%rsp
  803456:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803459:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80345c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803460:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803463:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803468:	75 0e                	jne    803478 <ipc_send+0x2a>
        pg = (void *)UTOP;
  80346a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803471:	00 00 00 
  803474:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803478:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80347b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80347e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803482:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803485:	89 c7                	mov    %eax,%edi
  803487:	48 b8 d5 04 80 00 00 	movabs $0x8004d5,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
  803493:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803496:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349a:	79 36                	jns    8034d2 <ipc_send+0x84>
  80349c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034a0:	74 30                	je     8034d2 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8034a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a5:	89 c1                	mov    %eax,%ecx
  8034a7:	48 ba a8 3c 80 00 00 	movabs $0x803ca8,%rdx
  8034ae:	00 00 00 
  8034b1:	be 49 00 00 00       	mov    $0x49,%esi
  8034b6:	48 bf b5 3c 80 00 00 	movabs $0x803cb5,%rdi
  8034bd:	00 00 00 
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c5:	49 b8 33 1e 80 00 00 	movabs $0x801e33,%r8
  8034cc:	00 00 00 
  8034cf:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034d2:	48 b8 c3 02 80 00 00 	movabs $0x8002c3,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
    } while(r != 0);
  8034de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e2:	75 94                	jne    803478 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034e4:	c9                   	leaveq 
  8034e5:	c3                   	retq   

00000000008034e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034e6:	55                   	push   %rbp
  8034e7:	48 89 e5             	mov    %rsp,%rbp
  8034ea:	48 83 ec 14          	sub    $0x14,%rsp
  8034ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034f8:	eb 5e                	jmp    803558 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034fa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803501:	00 00 00 
  803504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803507:	48 63 d0             	movslq %eax,%rdx
  80350a:	48 89 d0             	mov    %rdx,%rax
  80350d:	48 c1 e0 03          	shl    $0x3,%rax
  803511:	48 01 d0             	add    %rdx,%rax
  803514:	48 c1 e0 05          	shl    $0x5,%rax
  803518:	48 01 c8             	add    %rcx,%rax
  80351b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803521:	8b 00                	mov    (%rax),%eax
  803523:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803526:	75 2c                	jne    803554 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803528:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80352f:	00 00 00 
  803532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803535:	48 63 d0             	movslq %eax,%rdx
  803538:	48 89 d0             	mov    %rdx,%rax
  80353b:	48 c1 e0 03          	shl    $0x3,%rax
  80353f:	48 01 d0             	add    %rdx,%rax
  803542:	48 c1 e0 05          	shl    $0x5,%rax
  803546:	48 01 c8             	add    %rcx,%rax
  803549:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80354f:	8b 40 08             	mov    0x8(%rax),%eax
  803552:	eb 12                	jmp    803566 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803554:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803558:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80355f:	7e 99                	jle    8034fa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803566:	c9                   	leaveq 
  803567:	c3                   	retq   

0000000000803568 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803568:	55                   	push   %rbp
  803569:	48 89 e5             	mov    %rsp,%rbp
  80356c:	48 83 ec 18          	sub    $0x18,%rsp
  803570:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803578:	48 c1 e8 15          	shr    $0x15,%rax
  80357c:	48 89 c2             	mov    %rax,%rdx
  80357f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803586:	01 00 00 
  803589:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80358d:	83 e0 01             	and    $0x1,%eax
  803590:	48 85 c0             	test   %rax,%rax
  803593:	75 07                	jne    80359c <pageref+0x34>
		return 0;
  803595:	b8 00 00 00 00       	mov    $0x0,%eax
  80359a:	eb 53                	jmp    8035ef <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80359c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8035a4:	48 89 c2             	mov    %rax,%rdx
  8035a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035ae:	01 00 00 
  8035b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035bd:	83 e0 01             	and    $0x1,%eax
  8035c0:	48 85 c0             	test   %rax,%rax
  8035c3:	75 07                	jne    8035cc <pageref+0x64>
		return 0;
  8035c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ca:	eb 23                	jmp    8035ef <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8035d4:	48 89 c2             	mov    %rax,%rdx
  8035d7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035de:	00 00 00 
  8035e1:	48 c1 e2 04          	shl    $0x4,%rdx
  8035e5:	48 01 d0             	add    %rdx,%rax
  8035e8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035ec:	0f b7 c0             	movzwl %ax,%eax
}
  8035ef:	c9                   	leaveq 
  8035f0:	c3                   	retq   
