
obj/user/softint:     file format elf64-x86-64


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
  80003c:	e8 15 00 00 00       	callq  800056 <libmain>
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
	asm volatile("int $14");	// page fault
  800052:	cd 0e                	int    $0xe
}
  800054:	c9                   	leaveq 
  800055:	c3                   	retq   

0000000000800056 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800056:	55                   	push   %rbp
  800057:	48 89 e5             	mov    %rsp,%rbp
  80005a:	48 83 ec 20          	sub    $0x20,%rsp
  80005e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800061:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800065:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  80006c:	00 00 00 
  80006f:	ff d0                	callq  *%rax
  800071:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800077:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007c:	48 63 d0             	movslq %eax,%rdx
  80007f:	48 89 d0             	mov    %rdx,%rax
  800082:	48 c1 e0 03          	shl    $0x3,%rax
  800086:	48 01 d0             	add    %rdx,%rax
  800089:	48 c1 e0 05          	shl    $0x5,%rax
  80008d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800094:	00 00 00 
  800097:	48 01 c2             	add    %rax,%rdx
  80009a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000a1:	00 00 00 
  8000a4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ab:	7e 14                	jle    8000c1 <libmain+0x6b>
		binaryname = argv[0];
  8000ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000b1:	48 8b 10             	mov    (%rax),%rdx
  8000b4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000bb:	00 00 00 
  8000be:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000c8:	48 89 d6             	mov    %rdx,%rsi
  8000cb:	89 c7                	mov    %eax,%edi
  8000cd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000d4:	00 00 00 
  8000d7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d9:	48 b8 e7 00 80 00 00 	movabs $0x8000e7,%rax
  8000e0:	00 00 00 
  8000e3:	ff d0                	callq  *%rax
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000eb:	48 b8 8e 08 80 00 00 	movabs $0x80088e,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8000f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8000fc:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  800103:	00 00 00 
  800106:	ff d0                	callq  *%rax
}
  800108:	5d                   	pop    %rbp
  800109:	c3                   	retq   

000000000080010a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80010a:	55                   	push   %rbp
  80010b:	48 89 e5             	mov    %rsp,%rbp
  80010e:	53                   	push   %rbx
  80010f:	48 83 ec 48          	sub    $0x48,%rsp
  800113:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800116:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800119:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80011d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800121:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800125:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800129:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80012c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800130:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800134:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800138:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80013c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800140:	4c 89 c3             	mov    %r8,%rbx
  800143:	cd 30                	int    $0x30
  800145:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800149:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80014d:	74 3e                	je     80018d <syscall+0x83>
  80014f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800154:	7e 37                	jle    80018d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800156:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80015a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80015d:	49 89 d0             	mov    %rdx,%r8
  800160:	89 c1                	mov    %eax,%ecx
  800162:	48 ba ea 35 80 00 00 	movabs $0x8035ea,%rdx
  800169:	00 00 00 
  80016c:	be 23 00 00 00       	mov    $0x23,%esi
  800171:	48 bf 07 36 80 00 00 	movabs $0x803607,%rdi
  800178:	00 00 00 
  80017b:	b8 00 00 00 00       	mov    $0x0,%eax
  800180:	49 b9 12 1e 80 00 00 	movabs $0x801e12,%r9
  800187:	00 00 00 
  80018a:	41 ff d1             	callq  *%r9

	return ret;
  80018d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800191:	48 83 c4 48          	add    $0x48,%rsp
  800195:	5b                   	pop    %rbx
  800196:	5d                   	pop    %rbp
  800197:	c3                   	retq   

0000000000800198 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800198:	55                   	push   %rbp
  800199:	48 89 e5             	mov    %rsp,%rbp
  80019c:	48 83 ec 20          	sub    $0x20,%rsp
  8001a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b7:	00 
  8001b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c4:	48 89 d1             	mov    %rdx,%rcx
  8001c7:	48 89 c2             	mov    %rax,%rdx
  8001ca:	be 00 00 00 00       	mov    $0x0,%esi
  8001cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d4:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	callq  *%rax
}
  8001e0:	c9                   	leaveq 
  8001e1:	c3                   	retq   

00000000008001e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e2:	55                   	push   %rbp
  8001e3:	48 89 e5             	mov    %rsp,%rbp
  8001e6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f1:	00 
  8001f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800203:	ba 00 00 00 00       	mov    $0x0,%edx
  800208:	be 00 00 00 00       	mov    $0x0,%esi
  80020d:	bf 01 00 00 00       	mov    $0x1,%edi
  800212:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
}
  80021e:	c9                   	leaveq 
  80021f:	c3                   	retq   

0000000000800220 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800220:	55                   	push   %rbp
  800221:	48 89 e5             	mov    %rsp,%rbp
  800224:	48 83 ec 10          	sub    $0x10,%rsp
  800228:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80022b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022e:	48 98                	cltq   
  800230:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800237:	00 
  800238:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80023e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800244:	b9 00 00 00 00       	mov    $0x0,%ecx
  800249:	48 89 c2             	mov    %rax,%rdx
  80024c:	be 01 00 00 00       	mov    $0x1,%esi
  800251:	bf 03 00 00 00       	mov    $0x3,%edi
  800256:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
}
  800262:	c9                   	leaveq 
  800263:	c3                   	retq   

0000000000800264 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
  800268:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80026c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800273:	00 
  800274:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80027a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800280:	b9 00 00 00 00       	mov    $0x0,%ecx
  800285:	ba 00 00 00 00       	mov    $0x0,%edx
  80028a:	be 00 00 00 00       	mov    $0x0,%esi
  80028f:	bf 02 00 00 00       	mov    $0x2,%edi
  800294:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax
}
  8002a0:	c9                   	leaveq 
  8002a1:	c3                   	retq   

00000000008002a2 <sys_yield>:

void
sys_yield(void)
{
  8002a2:	55                   	push   %rbp
  8002a3:	48 89 e5             	mov    %rsp,%rbp
  8002a6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002b1:	00 
  8002b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c8:	be 00 00 00 00       	mov    $0x0,%esi
  8002cd:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002d2:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
}
  8002de:	c9                   	leaveq 
  8002df:	c3                   	retq   

00000000008002e0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002e0:	55                   	push   %rbp
  8002e1:	48 89 e5             	mov    %rsp,%rbp
  8002e4:	48 83 ec 20          	sub    $0x20,%rsp
  8002e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002ef:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f5:	48 63 c8             	movslq %eax,%rcx
  8002f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ff:	48 98                	cltq   
  800301:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800308:	00 
  800309:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80030f:	49 89 c8             	mov    %rcx,%r8
  800312:	48 89 d1             	mov    %rdx,%rcx
  800315:	48 89 c2             	mov    %rax,%rdx
  800318:	be 01 00 00 00       	mov    $0x1,%esi
  80031d:	bf 04 00 00 00       	mov    $0x4,%edi
  800322:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800329:	00 00 00 
  80032c:	ff d0                	callq  *%rax
}
  80032e:	c9                   	leaveq 
  80032f:	c3                   	retq   

0000000000800330 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800330:	55                   	push   %rbp
  800331:	48 89 e5             	mov    %rsp,%rbp
  800334:	48 83 ec 30          	sub    $0x30,%rsp
  800338:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80033b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80033f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800342:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800346:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80034a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80034d:	48 63 c8             	movslq %eax,%rcx
  800350:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800354:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800357:	48 63 f0             	movslq %eax,%rsi
  80035a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800361:	48 98                	cltq   
  800363:	48 89 0c 24          	mov    %rcx,(%rsp)
  800367:	49 89 f9             	mov    %rdi,%r9
  80036a:	49 89 f0             	mov    %rsi,%r8
  80036d:	48 89 d1             	mov    %rdx,%rcx
  800370:	48 89 c2             	mov    %rax,%rdx
  800373:	be 01 00 00 00       	mov    $0x1,%esi
  800378:	bf 05 00 00 00       	mov    $0x5,%edi
  80037d:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
}
  800389:	c9                   	leaveq 
  80038a:	c3                   	retq   

000000000080038b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80038b:	55                   	push   %rbp
  80038c:	48 89 e5             	mov    %rsp,%rbp
  80038f:	48 83 ec 20          	sub    $0x20,%rsp
  800393:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800396:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80039a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a1:	48 98                	cltq   
  8003a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003aa:	00 
  8003ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003b7:	48 89 d1             	mov    %rdx,%rcx
  8003ba:	48 89 c2             	mov    %rax,%rdx
  8003bd:	be 01 00 00 00       	mov    $0x1,%esi
  8003c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8003c7:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  8003ce:	00 00 00 
  8003d1:	ff d0                	callq  *%rax
}
  8003d3:	c9                   	leaveq 
  8003d4:	c3                   	retq   

00000000008003d5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003d5:	55                   	push   %rbp
  8003d6:	48 89 e5             	mov    %rsp,%rbp
  8003d9:	48 83 ec 10          	sub    $0x10,%rsp
  8003dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e6:	48 63 d0             	movslq %eax,%rdx
  8003e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ec:	48 98                	cltq   
  8003ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003f5:	00 
  8003f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800402:	48 89 d1             	mov    %rdx,%rcx
  800405:	48 89 c2             	mov    %rax,%rdx
  800408:	be 01 00 00 00       	mov    $0x1,%esi
  80040d:	bf 08 00 00 00       	mov    $0x8,%edi
  800412:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800419:	00 00 00 
  80041c:	ff d0                	callq  *%rax
}
  80041e:	c9                   	leaveq 
  80041f:	c3                   	retq   

0000000000800420 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	48 83 ec 20          	sub    $0x20,%rsp
  800428:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80042f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800436:	48 98                	cltq   
  800438:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80043f:	00 
  800440:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800446:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80044c:	48 89 d1             	mov    %rdx,%rcx
  80044f:	48 89 c2             	mov    %rax,%rdx
  800452:	be 01 00 00 00       	mov    $0x1,%esi
  800457:	bf 09 00 00 00       	mov    $0x9,%edi
  80045c:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800463:	00 00 00 
  800466:	ff d0                	callq  *%rax
}
  800468:	c9                   	leaveq 
  800469:	c3                   	retq   

000000000080046a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80046a:	55                   	push   %rbp
  80046b:	48 89 e5             	mov    %rsp,%rbp
  80046e:	48 83 ec 20          	sub    $0x20,%rsp
  800472:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800475:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800479:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800480:	48 98                	cltq   
  800482:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800489:	00 
  80048a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800490:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800496:	48 89 d1             	mov    %rdx,%rcx
  800499:	48 89 c2             	mov    %rax,%rdx
  80049c:	be 01 00 00 00       	mov    $0x1,%esi
  8004a1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004a6:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  8004ad:	00 00 00 
  8004b0:	ff d0                	callq  *%rax
}
  8004b2:	c9                   	leaveq 
  8004b3:	c3                   	retq   

00000000008004b4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004b4:	55                   	push   %rbp
  8004b5:	48 89 e5             	mov    %rsp,%rbp
  8004b8:	48 83 ec 20          	sub    $0x20,%rsp
  8004bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004c7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004cd:	48 63 f0             	movslq %eax,%rsi
  8004d0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d7:	48 98                	cltq   
  8004d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e4:	00 
  8004e5:	49 89 f1             	mov    %rsi,%r9
  8004e8:	49 89 c8             	mov    %rcx,%r8
  8004eb:	48 89 d1             	mov    %rdx,%rcx
  8004ee:	48 89 c2             	mov    %rax,%rdx
  8004f1:	be 00 00 00 00       	mov    $0x0,%esi
  8004f6:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004fb:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
}
  800507:	c9                   	leaveq 
  800508:	c3                   	retq   

0000000000800509 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800509:	55                   	push   %rbp
  80050a:	48 89 e5             	mov    %rsp,%rbp
  80050d:	48 83 ec 10          	sub    $0x10,%rsp
  800511:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800519:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800520:	00 
  800521:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800527:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80052d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800532:	48 89 c2             	mov    %rax,%rdx
  800535:	be 01 00 00 00       	mov    $0x1,%esi
  80053a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80053f:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800546:	00 00 00 
  800549:	ff d0                	callq  *%rax
}
  80054b:	c9                   	leaveq 
  80054c:	c3                   	retq   

000000000080054d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80054d:	55                   	push   %rbp
  80054e:	48 89 e5             	mov    %rsp,%rbp
  800551:	48 83 ec 08          	sub    $0x8,%rsp
  800555:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800559:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80055d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800564:	ff ff ff 
  800567:	48 01 d0             	add    %rdx,%rax
  80056a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80056e:	c9                   	leaveq 
  80056f:	c3                   	retq   

0000000000800570 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800570:	55                   	push   %rbp
  800571:	48 89 e5             	mov    %rsp,%rbp
  800574:	48 83 ec 08          	sub    $0x8,%rsp
  800578:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80057c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800580:	48 89 c7             	mov    %rax,%rdi
  800583:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  80058a:	00 00 00 
  80058d:	ff d0                	callq  *%rax
  80058f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800595:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800599:	c9                   	leaveq 
  80059a:	c3                   	retq   

000000000080059b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80059b:	55                   	push   %rbp
  80059c:	48 89 e5             	mov    %rsp,%rbp
  80059f:	48 83 ec 18          	sub    $0x18,%rsp
  8005a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005ae:	eb 6b                	jmp    80061b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005b3:	48 98                	cltq   
  8005b5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005bb:	48 c1 e0 0c          	shl    $0xc,%rax
  8005bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c7:	48 c1 e8 15          	shr    $0x15,%rax
  8005cb:	48 89 c2             	mov    %rax,%rdx
  8005ce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005d5:	01 00 00 
  8005d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005dc:	83 e0 01             	and    $0x1,%eax
  8005df:	48 85 c0             	test   %rax,%rax
  8005e2:	74 21                	je     800605 <fd_alloc+0x6a>
  8005e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8005ec:	48 89 c2             	mov    %rax,%rdx
  8005ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005f6:	01 00 00 
  8005f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005fd:	83 e0 01             	and    $0x1,%eax
  800600:	48 85 c0             	test   %rax,%rax
  800603:	75 12                	jne    800617 <fd_alloc+0x7c>
			*fd_store = fd;
  800605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800609:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80060d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	eb 1a                	jmp    800631 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800617:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80061b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80061f:	7e 8f                	jle    8005b0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800625:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80062c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800631:	c9                   	leaveq 
  800632:	c3                   	retq   

0000000000800633 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800633:	55                   	push   %rbp
  800634:	48 89 e5             	mov    %rsp,%rbp
  800637:	48 83 ec 20          	sub    $0x20,%rsp
  80063b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80063e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800642:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800646:	78 06                	js     80064e <fd_lookup+0x1b>
  800648:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80064c:	7e 07                	jle    800655 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80064e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800653:	eb 6c                	jmp    8006c1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800655:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800658:	48 98                	cltq   
  80065a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800660:	48 c1 e0 0c          	shl    $0xc,%rax
  800664:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80066c:	48 c1 e8 15          	shr    $0x15,%rax
  800670:	48 89 c2             	mov    %rax,%rdx
  800673:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80067a:	01 00 00 
  80067d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800681:	83 e0 01             	and    $0x1,%eax
  800684:	48 85 c0             	test   %rax,%rax
  800687:	74 21                	je     8006aa <fd_lookup+0x77>
  800689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80068d:	48 c1 e8 0c          	shr    $0xc,%rax
  800691:	48 89 c2             	mov    %rax,%rdx
  800694:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80069b:	01 00 00 
  80069e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a2:	83 e0 01             	and    $0x1,%eax
  8006a5:	48 85 c0             	test   %rax,%rax
  8006a8:	75 07                	jne    8006b1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006af:	eb 10                	jmp    8006c1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006b9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006c1:	c9                   	leaveq 
  8006c2:	c3                   	retq   

00000000008006c3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006c3:	55                   	push   %rbp
  8006c4:	48 89 e5             	mov    %rsp,%rbp
  8006c7:	48 83 ec 30          	sub    $0x30,%rsp
  8006cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006cf:	89 f0                	mov    %esi,%eax
  8006d1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006d8:	48 89 c7             	mov    %rax,%rdi
  8006db:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  8006e2:	00 00 00 
  8006e5:	ff d0                	callq  *%rax
  8006e7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8006eb:	48 89 d6             	mov    %rdx,%rsi
  8006ee:	89 c7                	mov    %eax,%edi
  8006f0:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  8006f7:	00 00 00 
  8006fa:	ff d0                	callq  *%rax
  8006fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8006ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800703:	78 0a                	js     80070f <fd_close+0x4c>
	    || fd != fd2)
  800705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800709:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80070d:	74 12                	je     800721 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80070f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800713:	74 05                	je     80071a <fd_close+0x57>
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 05                	jmp    80071f <fd_close+0x5c>
  80071a:	b8 00 00 00 00       	mov    $0x0,%eax
  80071f:	eb 69                	jmp    80078a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800725:	8b 00                	mov    (%rax),%eax
  800727:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80072b:	48 89 d6             	mov    %rdx,%rsi
  80072e:	89 c7                	mov    %eax,%edi
  800730:	48 b8 8c 07 80 00 00 	movabs $0x80078c,%rax
  800737:	00 00 00 
  80073a:	ff d0                	callq  *%rax
  80073c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80073f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800743:	78 2a                	js     80076f <fd_close+0xac>
		if (dev->dev_close)
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	48 8b 40 20          	mov    0x20(%rax),%rax
  80074d:	48 85 c0             	test   %rax,%rax
  800750:	74 16                	je     800768 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800756:	48 8b 40 20          	mov    0x20(%rax),%rax
  80075a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80075e:	48 89 d7             	mov    %rdx,%rdi
  800761:	ff d0                	callq  *%rax
  800763:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800766:	eb 07                	jmp    80076f <fd_close+0xac>
		else
			r = 0;
  800768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80076f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800773:	48 89 c6             	mov    %rax,%rsi
  800776:	bf 00 00 00 00       	mov    $0x0,%edi
  80077b:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  800782:	00 00 00 
  800785:	ff d0                	callq  *%rax
	return r;
  800787:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80078a:	c9                   	leaveq 
  80078b:	c3                   	retq   

000000000080078c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80078c:	55                   	push   %rbp
  80078d:	48 89 e5             	mov    %rsp,%rbp
  800790:	48 83 ec 20          	sub    $0x20,%rsp
  800794:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800797:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80079b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007a2:	eb 41                	jmp    8007e5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007a4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007ab:	00 00 00 
  8007ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007b1:	48 63 d2             	movslq %edx,%rdx
  8007b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007b8:	8b 00                	mov    (%rax),%eax
  8007ba:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007bd:	75 22                	jne    8007e1 <dev_lookup+0x55>
			*dev = devtab[i];
  8007bf:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007c6:	00 00 00 
  8007c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007cc:	48 63 d2             	movslq %edx,%rdx
  8007cf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007d7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	eb 60                	jmp    800841 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007e5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007ec:	00 00 00 
  8007ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007f2:	48 63 d2             	movslq %edx,%rdx
  8007f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f9:	48 85 c0             	test   %rax,%rax
  8007fc:	75 a6                	jne    8007a4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007fe:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800805:	00 00 00 
  800808:	48 8b 00             	mov    (%rax),%rax
  80080b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800811:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800814:	89 c6                	mov    %eax,%esi
  800816:	48 bf 18 36 80 00 00 	movabs $0x803618,%rdi
  80081d:	00 00 00 
  800820:	b8 00 00 00 00       	mov    $0x0,%eax
  800825:	48 b9 4b 20 80 00 00 	movabs $0x80204b,%rcx
  80082c:	00 00 00 
  80082f:	ff d1                	callq  *%rcx
	*dev = 0;
  800831:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800835:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80083c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800841:	c9                   	leaveq 
  800842:	c3                   	retq   

0000000000800843 <close>:

int
close(int fdnum)
{
  800843:	55                   	push   %rbp
  800844:	48 89 e5             	mov    %rsp,%rbp
  800847:	48 83 ec 20          	sub    $0x20,%rsp
  80084b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80084e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800852:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800855:	48 89 d6             	mov    %rdx,%rsi
  800858:	89 c7                	mov    %eax,%edi
  80085a:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800861:	00 00 00 
  800864:	ff d0                	callq  *%rax
  800866:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80086d:	79 05                	jns    800874 <close+0x31>
		return r;
  80086f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800872:	eb 18                	jmp    80088c <close+0x49>
	else
		return fd_close(fd, 1);
  800874:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800878:	be 01 00 00 00       	mov    $0x1,%esi
  80087d:	48 89 c7             	mov    %rax,%rdi
  800880:	48 b8 c3 06 80 00 00 	movabs $0x8006c3,%rax
  800887:	00 00 00 
  80088a:	ff d0                	callq  *%rax
}
  80088c:	c9                   	leaveq 
  80088d:	c3                   	retq   

000000000080088e <close_all>:

void
close_all(void)
{
  80088e:	55                   	push   %rbp
  80088f:	48 89 e5             	mov    %rsp,%rbp
  800892:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800896:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80089d:	eb 15                	jmp    8008b4 <close_all+0x26>
		close(i);
  80089f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a2:	89 c7                	mov    %eax,%edi
  8008a4:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  8008ab:	00 00 00 
  8008ae:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008b4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008b8:	7e e5                	jle    80089f <close_all+0x11>
		close(i);
}
  8008ba:	c9                   	leaveq 
  8008bb:	c3                   	retq   

00000000008008bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008bc:	55                   	push   %rbp
  8008bd:	48 89 e5             	mov    %rsp,%rbp
  8008c0:	48 83 ec 40          	sub    $0x40,%rsp
  8008c4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008c7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008ca:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008ce:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008d1:	48 89 d6             	mov    %rdx,%rsi
  8008d4:	89 c7                	mov    %eax,%edi
  8008d6:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  8008dd:	00 00 00 
  8008e0:	ff d0                	callq  *%rax
  8008e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008e9:	79 08                	jns    8008f3 <dup+0x37>
		return r;
  8008eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ee:	e9 70 01 00 00       	jmpq   800a63 <dup+0x1a7>
	close(newfdnum);
  8008f3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8008f6:	89 c7                	mov    %eax,%edi
  8008f8:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  8008ff:	00 00 00 
  800902:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800904:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800907:	48 98                	cltq   
  800909:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80090f:	48 c1 e0 0c          	shl    $0xc,%rax
  800913:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80091b:	48 89 c7             	mov    %rax,%rdi
  80091e:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  800925:	00 00 00 
  800928:	ff d0                	callq  *%rax
  80092a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80092e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800932:	48 89 c7             	mov    %rax,%rdi
  800935:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  80093c:	00 00 00 
  80093f:	ff d0                	callq  *%rax
  800941:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	48 c1 e8 15          	shr    $0x15,%rax
  80094d:	48 89 c2             	mov    %rax,%rdx
  800950:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800957:	01 00 00 
  80095a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80095e:	83 e0 01             	and    $0x1,%eax
  800961:	48 85 c0             	test   %rax,%rax
  800964:	74 73                	je     8009d9 <dup+0x11d>
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	48 c1 e8 0c          	shr    $0xc,%rax
  80096e:	48 89 c2             	mov    %rax,%rdx
  800971:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800978:	01 00 00 
  80097b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80097f:	83 e0 01             	and    $0x1,%eax
  800982:	48 85 c0             	test   %rax,%rax
  800985:	74 52                	je     8009d9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	48 c1 e8 0c          	shr    $0xc,%rax
  80098f:	48 89 c2             	mov    %rax,%rdx
  800992:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800999:	01 00 00 
  80099c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8009a5:	89 c1                	mov    %eax,%ecx
  8009a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	41 89 c8             	mov    %ecx,%r8d
  8009b2:	48 89 d1             	mov    %rdx,%rcx
  8009b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ba:	48 89 c6             	mov    %rax,%rsi
  8009bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8009c2:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
  8009c9:	00 00 00 
  8009cc:	ff d0                	callq  *%rax
  8009ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009d5:	79 02                	jns    8009d9 <dup+0x11d>
			goto err;
  8009d7:	eb 57                	jmp    800a30 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8009e1:	48 89 c2             	mov    %rax,%rdx
  8009e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009eb:	01 00 00 
  8009ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8009f7:	89 c1                	mov    %eax,%ecx
  8009f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a01:	41 89 c8             	mov    %ecx,%r8d
  800a04:	48 89 d1             	mov    %rdx,%rcx
  800a07:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0c:	48 89 c6             	mov    %rax,%rsi
  800a0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a14:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
  800a1b:	00 00 00 
  800a1e:	ff d0                	callq  *%rax
  800a20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a27:	79 02                	jns    800a2b <dup+0x16f>
		goto err;
  800a29:	eb 05                	jmp    800a30 <dup+0x174>

	return newfdnum;
  800a2b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a2e:	eb 33                	jmp    800a63 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a34:	48 89 c6             	mov    %rax,%rsi
  800a37:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3c:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  800a43:	00 00 00 
  800a46:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a4c:	48 89 c6             	mov    %rax,%rsi
  800a4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a54:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  800a5b:	00 00 00 
  800a5e:	ff d0                	callq  *%rax
	return r;
  800a60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a63:	c9                   	leaveq 
  800a64:	c3                   	retq   

0000000000800a65 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a65:	55                   	push   %rbp
  800a66:	48 89 e5             	mov    %rsp,%rbp
  800a69:	48 83 ec 40          	sub    $0x40,%rsp
  800a6d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a70:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a74:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a78:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a7f:	48 89 d6             	mov    %rdx,%rsi
  800a82:	89 c7                	mov    %eax,%edi
  800a84:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800a8b:	00 00 00 
  800a8e:	ff d0                	callq  *%rax
  800a90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a97:	78 24                	js     800abd <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9d:	8b 00                	mov    (%rax),%eax
  800a9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800aa3:	48 89 d6             	mov    %rdx,%rsi
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 8c 07 80 00 00 	movabs $0x80078c,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax
  800ab4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800abb:	79 05                	jns    800ac2 <read+0x5d>
		return r;
  800abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ac0:	eb 76                	jmp    800b38 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac6:	8b 40 08             	mov    0x8(%rax),%eax
  800ac9:	83 e0 03             	and    $0x3,%eax
  800acc:	83 f8 01             	cmp    $0x1,%eax
  800acf:	75 3a                	jne    800b0b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800ad1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ad8:	00 00 00 
  800adb:	48 8b 00             	mov    (%rax),%rax
  800ade:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800ae4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ae7:	89 c6                	mov    %eax,%esi
  800ae9:	48 bf 37 36 80 00 00 	movabs $0x803637,%rdi
  800af0:	00 00 00 
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
  800af8:	48 b9 4b 20 80 00 00 	movabs $0x80204b,%rcx
  800aff:	00 00 00 
  800b02:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b09:	eb 2d                	jmp    800b38 <read+0xd3>
	}
	if (!dev->dev_read)
  800b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b0f:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b13:	48 85 c0             	test   %rax,%rax
  800b16:	75 07                	jne    800b1f <read+0xba>
		return -E_NOT_SUPP;
  800b18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b1d:	eb 19                	jmp    800b38 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b23:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b27:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b33:	48 89 cf             	mov    %rcx,%rdi
  800b36:	ff d0                	callq  *%rax
}
  800b38:	c9                   	leaveq 
  800b39:	c3                   	retq   

0000000000800b3a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b3a:	55                   	push   %rbp
  800b3b:	48 89 e5             	mov    %rsp,%rbp
  800b3e:	48 83 ec 30          	sub    $0x30,%rsp
  800b42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b54:	eb 49                	jmp    800b9f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b59:	48 98                	cltq   
  800b5b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b5f:	48 29 c2             	sub    %rax,%rdx
  800b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b65:	48 63 c8             	movslq %eax,%rcx
  800b68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b6c:	48 01 c1             	add    %rax,%rcx
  800b6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b72:	48 89 ce             	mov    %rcx,%rsi
  800b75:	89 c7                	mov    %eax,%edi
  800b77:	48 b8 65 0a 80 00 00 	movabs $0x800a65,%rax
  800b7e:	00 00 00 
  800b81:	ff d0                	callq  *%rax
  800b83:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800b86:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b8a:	79 05                	jns    800b91 <readn+0x57>
			return m;
  800b8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b8f:	eb 1c                	jmp    800bad <readn+0x73>
		if (m == 0)
  800b91:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b95:	75 02                	jne    800b99 <readn+0x5f>
			break;
  800b97:	eb 11                	jmp    800baa <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b9c:	01 45 fc             	add    %eax,-0x4(%rbp)
  800b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ba2:	48 98                	cltq   
  800ba4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ba8:	72 ac                	jb     800b56 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bad:	c9                   	leaveq 
  800bae:	c3                   	retq   

0000000000800baf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800baf:	55                   	push   %rbp
  800bb0:	48 89 e5             	mov    %rsp,%rbp
  800bb3:	48 83 ec 40          	sub    $0x40,%rsp
  800bb7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bbe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bc2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bc6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bc9:	48 89 d6             	mov    %rdx,%rsi
  800bcc:	89 c7                	mov    %eax,%edi
  800bce:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800bd5:	00 00 00 
  800bd8:	ff d0                	callq  *%rax
  800bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800be1:	78 24                	js     800c07 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be7:	8b 00                	mov    (%rax),%eax
  800be9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bed:	48 89 d6             	mov    %rdx,%rsi
  800bf0:	89 c7                	mov    %eax,%edi
  800bf2:	48 b8 8c 07 80 00 00 	movabs $0x80078c,%rax
  800bf9:	00 00 00 
  800bfc:	ff d0                	callq  *%rax
  800bfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c05:	79 05                	jns    800c0c <write+0x5d>
		return r;
  800c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c0a:	eb 75                	jmp    800c81 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c10:	8b 40 08             	mov    0x8(%rax),%eax
  800c13:	83 e0 03             	and    $0x3,%eax
  800c16:	85 c0                	test   %eax,%eax
  800c18:	75 3a                	jne    800c54 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c1a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c21:	00 00 00 
  800c24:	48 8b 00             	mov    (%rax),%rax
  800c27:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c2d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c30:	89 c6                	mov    %eax,%esi
  800c32:	48 bf 53 36 80 00 00 	movabs $0x803653,%rdi
  800c39:	00 00 00 
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	48 b9 4b 20 80 00 00 	movabs $0x80204b,%rcx
  800c48:	00 00 00 
  800c4b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c52:	eb 2d                	jmp    800c81 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c58:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c5c:	48 85 c0             	test   %rax,%rax
  800c5f:	75 07                	jne    800c68 <write+0xb9>
		return -E_NOT_SUPP;
  800c61:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c66:	eb 19                	jmp    800c81 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c70:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c74:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c78:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c7c:	48 89 cf             	mov    %rcx,%rdi
  800c7f:	ff d0                	callq  *%rax
}
  800c81:	c9                   	leaveq 
  800c82:	c3                   	retq   

0000000000800c83 <seek>:

int
seek(int fdnum, off_t offset)
{
  800c83:	55                   	push   %rbp
  800c84:	48 89 e5             	mov    %rsp,%rbp
  800c87:	48 83 ec 18          	sub    $0x18,%rsp
  800c8b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c8e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c91:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c98:	48 89 d6             	mov    %rdx,%rsi
  800c9b:	89 c7                	mov    %eax,%edi
  800c9d:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800ca4:	00 00 00 
  800ca7:	ff d0                	callq  *%rax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cb0:	79 05                	jns    800cb7 <seek+0x34>
		return r;
  800cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb5:	eb 0f                	jmp    800cc6 <seek+0x43>
	fd->fd_offset = offset;
  800cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cbe:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc6:	c9                   	leaveq 
  800cc7:	c3                   	retq   

0000000000800cc8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800cc8:	55                   	push   %rbp
  800cc9:	48 89 e5             	mov    %rsp,%rbp
  800ccc:	48 83 ec 30          	sub    $0x30,%rsp
  800cd0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cd3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cd6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cda:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cdd:	48 89 d6             	mov    %rdx,%rsi
  800ce0:	89 c7                	mov    %eax,%edi
  800ce2:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800ce9:	00 00 00 
  800cec:	ff d0                	callq  *%rax
  800cee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cf5:	78 24                	js     800d1b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfb:	8b 00                	mov    (%rax),%eax
  800cfd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d01:	48 89 d6             	mov    %rdx,%rsi
  800d04:	89 c7                	mov    %eax,%edi
  800d06:	48 b8 8c 07 80 00 00 	movabs $0x80078c,%rax
  800d0d:	00 00 00 
  800d10:	ff d0                	callq  *%rax
  800d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d19:	79 05                	jns    800d20 <ftruncate+0x58>
		return r;
  800d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d1e:	eb 72                	jmp    800d92 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d24:	8b 40 08             	mov    0x8(%rax),%eax
  800d27:	83 e0 03             	and    $0x3,%eax
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	75 3a                	jne    800d68 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d2e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d35:	00 00 00 
  800d38:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d3b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d41:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d44:	89 c6                	mov    %eax,%esi
  800d46:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  800d4d:	00 00 00 
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	48 b9 4b 20 80 00 00 	movabs $0x80204b,%rcx
  800d5c:	00 00 00 
  800d5f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d66:	eb 2a                	jmp    800d92 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6c:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d70:	48 85 c0             	test   %rax,%rax
  800d73:	75 07                	jne    800d7c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d75:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d7a:	eb 16                	jmp    800d92 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d80:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d88:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800d8b:	89 ce                	mov    %ecx,%esi
  800d8d:	48 89 d7             	mov    %rdx,%rdi
  800d90:	ff d0                	callq  *%rax
}
  800d92:	c9                   	leaveq 
  800d93:	c3                   	retq   

0000000000800d94 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800d94:	55                   	push   %rbp
  800d95:	48 89 e5             	mov    %rsp,%rbp
  800d98:	48 83 ec 30          	sub    $0x30,%rsp
  800d9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800da3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800da7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800daa:	48 89 d6             	mov    %rdx,%rsi
  800dad:	89 c7                	mov    %eax,%edi
  800daf:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  800db6:	00 00 00 
  800db9:	ff d0                	callq  *%rax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc2:	78 24                	js     800de8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc8:	8b 00                	mov    (%rax),%eax
  800dca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dce:	48 89 d6             	mov    %rdx,%rsi
  800dd1:	89 c7                	mov    %eax,%edi
  800dd3:	48 b8 8c 07 80 00 00 	movabs $0x80078c,%rax
  800dda:	00 00 00 
  800ddd:	ff d0                	callq  *%rax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de6:	79 05                	jns    800ded <fstat+0x59>
		return r;
  800de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800deb:	eb 5e                	jmp    800e4b <fstat+0xb7>
	if (!dev->dev_stat)
  800ded:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df1:	48 8b 40 28          	mov    0x28(%rax),%rax
  800df5:	48 85 c0             	test   %rax,%rax
  800df8:	75 07                	jne    800e01 <fstat+0x6d>
		return -E_NOT_SUPP;
  800dfa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800dff:	eb 4a                	jmp    800e4b <fstat+0xb7>
	stat->st_name[0] = 0;
  800e01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e05:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e0c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e13:	00 00 00 
	stat->st_isdir = 0;
  800e16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e1a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e21:	00 00 00 
	stat->st_dev = dev;
  800e24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e37:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e3f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e43:	48 89 ce             	mov    %rcx,%rsi
  800e46:	48 89 d7             	mov    %rdx,%rdi
  800e49:	ff d0                	callq  *%rax
}
  800e4b:	c9                   	leaveq 
  800e4c:	c3                   	retq   

0000000000800e4d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e4d:	55                   	push   %rbp
  800e4e:	48 89 e5             	mov    %rsp,%rbp
  800e51:	48 83 ec 20          	sub    $0x20,%rsp
  800e55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e61:	be 00 00 00 00       	mov    $0x0,%esi
  800e66:	48 89 c7             	mov    %rax,%rdi
  800e69:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  800e70:	00 00 00 
  800e73:	ff d0                	callq  *%rax
  800e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e7c:	79 05                	jns    800e83 <stat+0x36>
		return fd;
  800e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e81:	eb 2f                	jmp    800eb2 <stat+0x65>
	r = fstat(fd, stat);
  800e83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8a:	48 89 d6             	mov    %rdx,%rsi
  800e8d:	89 c7                	mov    %eax,%edi
  800e8f:	48 b8 94 0d 80 00 00 	movabs $0x800d94,%rax
  800e96:	00 00 00 
  800e99:	ff d0                	callq  *%rax
  800e9b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea1:	89 c7                	mov    %eax,%edi
  800ea3:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  800eaa:	00 00 00 
  800ead:	ff d0                	callq  *%rax
	return r;
  800eaf:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800eb2:	c9                   	leaveq 
  800eb3:	c3                   	retq   

0000000000800eb4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800eb4:	55                   	push   %rbp
  800eb5:	48 89 e5             	mov    %rsp,%rbp
  800eb8:	48 83 ec 10          	sub    $0x10,%rsp
  800ebc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ebf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ec3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800eca:	00 00 00 
  800ecd:	8b 00                	mov    (%rax),%eax
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	75 1d                	jne    800ef0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ed3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ed8:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  800edf:	00 00 00 
  800ee2:	ff d0                	callq  *%rax
  800ee4:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800eeb:	00 00 00 
  800eee:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ef0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ef7:	00 00 00 
  800efa:	8b 00                	mov    (%rax),%eax
  800efc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800eff:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f04:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f0b:	00 00 00 
  800f0e:	89 c7                	mov    %eax,%edi
  800f10:	48 b8 2d 34 80 00 00 	movabs $0x80342d,%rax
  800f17:	00 00 00 
  800f1a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f20:	ba 00 00 00 00       	mov    $0x0,%edx
  800f25:	48 89 c6             	mov    %rax,%rsi
  800f28:	bf 00 00 00 00       	mov    $0x0,%edi
  800f2d:	48 b8 6c 33 80 00 00 	movabs $0x80336c,%rax
  800f34:	00 00 00 
  800f37:	ff d0                	callq  *%rax
}
  800f39:	c9                   	leaveq 
  800f3a:	c3                   	retq   

0000000000800f3b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f3b:	55                   	push   %rbp
  800f3c:	48 89 e5             	mov    %rsp,%rbp
  800f3f:	48 83 ec 20          	sub    $0x20,%rsp
  800f43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f47:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4e:	48 89 c7             	mov    %rax,%rdi
  800f51:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  800f58:	00 00 00 
  800f5b:	ff d0                	callq  *%rax
  800f5d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f62:	7e 0a                	jle    800f6e <open+0x33>
		return -E_BAD_PATH;
  800f64:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f69:	e9 a5 00 00 00       	jmpq   801013 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f6e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f72:	48 89 c7             	mov    %rax,%rdi
  800f75:	48 b8 9b 05 80 00 00 	movabs $0x80059b,%rax
  800f7c:	00 00 00 
  800f7f:	ff d0                	callq  *%rax
  800f81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f88:	79 08                	jns    800f92 <open+0x57>
		return r;
  800f8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f8d:	e9 81 00 00 00       	jmpq   801013 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f96:	48 89 c6             	mov    %rax,%rsi
  800f99:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fa0:	00 00 00 
  800fa3:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  800faa:	00 00 00 
  800fad:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800faf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fb6:	00 00 00 
  800fb9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fbc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc6:	48 89 c6             	mov    %rax,%rsi
  800fc9:	bf 01 00 00 00       	mov    $0x1,%edi
  800fce:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  800fd5:	00 00 00 
  800fd8:	ff d0                	callq  *%rax
  800fda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fe1:	79 1d                	jns    801000 <open+0xc5>
		fd_close(fd, 0);
  800fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe7:	be 00 00 00 00       	mov    $0x0,%esi
  800fec:	48 89 c7             	mov    %rax,%rdi
  800fef:	48 b8 c3 06 80 00 00 	movabs $0x8006c3,%rax
  800ff6:	00 00 00 
  800ff9:	ff d0                	callq  *%rax
		return r;
  800ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ffe:	eb 13                	jmp    801013 <open+0xd8>
	}

	return fd2num(fd);
  801000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801004:	48 89 c7             	mov    %rax,%rdi
  801007:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  80100e:	00 00 00 
  801011:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  801013:	c9                   	leaveq 
  801014:	c3                   	retq   

0000000000801015 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 83 ec 10          	sub    $0x10,%rsp
  80101d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801025:	8b 50 0c             	mov    0xc(%rax),%edx
  801028:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80102f:	00 00 00 
  801032:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801034:	be 00 00 00 00       	mov    $0x0,%esi
  801039:	bf 06 00 00 00       	mov    $0x6,%edi
  80103e:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  801045:	00 00 00 
  801048:	ff d0                	callq  *%rax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 30          	sub    $0x30,%rsp
  801054:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801058:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80105c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801060:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801064:	8b 50 0c             	mov    0xc(%rax),%edx
  801067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80106e:	00 00 00 
  801071:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801073:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80107a:	00 00 00 
  80107d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801081:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801085:	be 00 00 00 00       	mov    $0x0,%esi
  80108a:	bf 03 00 00 00       	mov    $0x3,%edi
  80108f:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  801096:	00 00 00 
  801099:	ff d0                	callq  *%rax
  80109b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80109e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010a2:	79 08                	jns    8010ac <devfile_read+0x60>
		return r;
  8010a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a7:	e9 a4 00 00 00       	jmpq   801150 <devfile_read+0x104>
	assert(r <= n);
  8010ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010af:	48 98                	cltq   
  8010b1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010b5:	76 35                	jbe    8010ec <devfile_read+0xa0>
  8010b7:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  8010be:	00 00 00 
  8010c1:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8010c8:	00 00 00 
  8010cb:	be 84 00 00 00       	mov    $0x84,%esi
  8010d0:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8010d7:	00 00 00 
  8010da:	b8 00 00 00 00       	mov    $0x0,%eax
  8010df:	49 b8 12 1e 80 00 00 	movabs $0x801e12,%r8
  8010e6:	00 00 00 
  8010e9:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8010ec:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8010f3:	7e 35                	jle    80112a <devfile_read+0xde>
  8010f5:	48 b9 c4 36 80 00 00 	movabs $0x8036c4,%rcx
  8010fc:	00 00 00 
  8010ff:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  801106:	00 00 00 
  801109:	be 85 00 00 00       	mov    $0x85,%esi
  80110e:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  801115:	00 00 00 
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
  80111d:	49 b8 12 1e 80 00 00 	movabs $0x801e12,%r8
  801124:	00 00 00 
  801127:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112d:	48 63 d0             	movslq %eax,%rdx
  801130:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801134:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80113b:	00 00 00 
  80113e:	48 89 c7             	mov    %rax,%rdi
  801141:	48 b8 37 2f 80 00 00 	movabs $0x802f37,%rax
  801148:	00 00 00 
  80114b:	ff d0                	callq  *%rax
	return r;
  80114d:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  801150:	c9                   	leaveq 
  801151:	c3                   	retq   

0000000000801152 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801152:	55                   	push   %rbp
  801153:	48 89 e5             	mov    %rsp,%rbp
  801156:	48 83 ec 30          	sub    $0x30,%rsp
  80115a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801162:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116a:	8b 50 0c             	mov    0xc(%rax),%edx
  80116d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801174:	00 00 00 
  801177:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801179:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801180:	00 00 00 
  801183:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801187:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80118b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801192:	00 
  801193:	76 35                	jbe    8011ca <devfile_write+0x78>
  801195:	48 b9 d0 36 80 00 00 	movabs $0x8036d0,%rcx
  80119c:	00 00 00 
  80119f:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8011a6:	00 00 00 
  8011a9:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011ae:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8011b5:	00 00 00 
  8011b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bd:	49 b8 12 1e 80 00 00 	movabs $0x801e12,%r8
  8011c4:	00 00 00 
  8011c7:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d2:	48 89 c6             	mov    %rax,%rsi
  8011d5:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011dc:	00 00 00 
  8011df:	48 b8 4e 30 80 00 00 	movabs $0x80304e,%rax
  8011e6:	00 00 00 
  8011e9:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8011eb:	be 00 00 00 00       	mov    $0x0,%esi
  8011f0:	bf 04 00 00 00       	mov    $0x4,%edi
  8011f5:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  8011fc:	00 00 00 
  8011ff:	ff d0                	callq  *%rax
  801201:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801204:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801208:	79 05                	jns    80120f <devfile_write+0xbd>
		return r;
  80120a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80120d:	eb 43                	jmp    801252 <devfile_write+0x100>
	assert(r <= n);
  80120f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801212:	48 98                	cltq   
  801214:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801218:	76 35                	jbe    80124f <devfile_write+0xfd>
  80121a:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  801221:	00 00 00 
  801224:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  80122b:	00 00 00 
  80122e:	be a2 00 00 00       	mov    $0xa2,%esi
  801233:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  80123a:	00 00 00 
  80123d:	b8 00 00 00 00       	mov    $0x0,%eax
  801242:	49 b8 12 1e 80 00 00 	movabs $0x801e12,%r8
  801249:	00 00 00 
  80124c:	41 ff d0             	callq  *%r8
	return r;
  80124f:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801252:	c9                   	leaveq 
  801253:	c3                   	retq   

0000000000801254 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801254:	55                   	push   %rbp
  801255:	48 89 e5             	mov    %rsp,%rbp
  801258:	48 83 ec 20          	sub    $0x20,%rsp
  80125c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801260:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801268:	8b 50 0c             	mov    0xc(%rax),%edx
  80126b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801272:	00 00 00 
  801275:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801277:	be 00 00 00 00       	mov    $0x0,%esi
  80127c:	bf 05 00 00 00       	mov    $0x5,%edi
  801281:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  801288:	00 00 00 
  80128b:	ff d0                	callq  *%rax
  80128d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801290:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801294:	79 05                	jns    80129b <devfile_stat+0x47>
		return r;
  801296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801299:	eb 56                	jmp    8012f1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80129b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012a6:	00 00 00 
  8012a9:	48 89 c7             	mov    %rax,%rdi
  8012ac:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  8012b3:	00 00 00 
  8012b6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012bf:	00 00 00 
  8012c2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012cc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012d2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012d9:	00 00 00 
  8012dc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f1:	c9                   	leaveq 
  8012f2:	c3                   	retq   

00000000008012f3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012f3:	55                   	push   %rbp
  8012f4:	48 89 e5             	mov    %rsp,%rbp
  8012f7:	48 83 ec 10          	sub    $0x10,%rsp
  8012fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ff:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	8b 50 0c             	mov    0xc(%rax),%edx
  801309:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801310:	00 00 00 
  801313:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801315:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80131c:	00 00 00 
  80131f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801322:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801325:	be 00 00 00 00       	mov    $0x0,%esi
  80132a:	bf 02 00 00 00       	mov    $0x2,%edi
  80132f:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  801336:	00 00 00 
  801339:	ff d0                	callq  *%rax
}
  80133b:	c9                   	leaveq 
  80133c:	c3                   	retq   

000000000080133d <remove>:

// Delete a file
int
remove(const char *path)
{
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	48 83 ec 10          	sub    $0x10,%rsp
  801345:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	48 89 c7             	mov    %rax,%rdi
  801350:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  801357:	00 00 00 
  80135a:	ff d0                	callq  *%rax
  80135c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801361:	7e 07                	jle    80136a <remove+0x2d>
		return -E_BAD_PATH;
  801363:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801368:	eb 33                	jmp    80139d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	48 89 c6             	mov    %rax,%rsi
  801371:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801378:	00 00 00 
  80137b:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  801382:	00 00 00 
  801385:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801387:	be 00 00 00 00       	mov    $0x0,%esi
  80138c:	bf 07 00 00 00       	mov    $0x7,%edi
  801391:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  801398:	00 00 00 
  80139b:	ff d0                	callq  *%rax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013a3:	be 00 00 00 00       	mov    $0x0,%esi
  8013a8:	bf 08 00 00 00       	mov    $0x8,%edi
  8013ad:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  8013b4:	00 00 00 
  8013b7:	ff d0                	callq  *%rax
}
  8013b9:	5d                   	pop    %rbp
  8013ba:	c3                   	retq   

00000000008013bb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013bb:	55                   	push   %rbp
  8013bc:	48 89 e5             	mov    %rsp,%rbp
  8013bf:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013c6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013cd:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013d4:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013db:	be 00 00 00 00       	mov    $0x0,%esi
  8013e0:	48 89 c7             	mov    %rax,%rdi
  8013e3:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  8013ea:	00 00 00 
  8013ed:	ff d0                	callq  *%rax
  8013ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8013f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013f6:	79 28                	jns    801420 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8013f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013fb:	89 c6                	mov    %eax,%esi
  8013fd:	48 bf fd 36 80 00 00 	movabs $0x8036fd,%rdi
  801404:	00 00 00 
  801407:	b8 00 00 00 00       	mov    $0x0,%eax
  80140c:	48 ba 4b 20 80 00 00 	movabs $0x80204b,%rdx
  801413:	00 00 00 
  801416:	ff d2                	callq  *%rdx
		return fd_src;
  801418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141b:	e9 74 01 00 00       	jmpq   801594 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801420:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801427:	be 01 01 00 00       	mov    $0x101,%esi
  80142c:	48 89 c7             	mov    %rax,%rdi
  80142f:	48 b8 3b 0f 80 00 00 	movabs $0x800f3b,%rax
  801436:	00 00 00 
  801439:	ff d0                	callq  *%rax
  80143b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80143e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801442:	79 39                	jns    80147d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801444:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801447:	89 c6                	mov    %eax,%esi
  801449:	48 bf 13 37 80 00 00 	movabs $0x803713,%rdi
  801450:	00 00 00 
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
  801458:	48 ba 4b 20 80 00 00 	movabs $0x80204b,%rdx
  80145f:	00 00 00 
  801462:	ff d2                	callq  *%rdx
		close(fd_src);
  801464:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801467:	89 c7                	mov    %eax,%edi
  801469:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  801470:	00 00 00 
  801473:	ff d0                	callq  *%rax
		return fd_dest;
  801475:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801478:	e9 17 01 00 00       	jmpq   801594 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80147d:	eb 74                	jmp    8014f3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80147f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801482:	48 63 d0             	movslq %eax,%rdx
  801485:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80148c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80148f:	48 89 ce             	mov    %rcx,%rsi
  801492:	89 c7                	mov    %eax,%edi
  801494:	48 b8 af 0b 80 00 00 	movabs $0x800baf,%rax
  80149b:	00 00 00 
  80149e:	ff d0                	callq  *%rax
  8014a0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014a7:	79 4a                	jns    8014f3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014ac:	89 c6                	mov    %eax,%esi
  8014ae:	48 bf 2d 37 80 00 00 	movabs $0x80372d,%rdi
  8014b5:	00 00 00 
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bd:	48 ba 4b 20 80 00 00 	movabs $0x80204b,%rdx
  8014c4:	00 00 00 
  8014c7:	ff d2                	callq  *%rdx
			close(fd_src);
  8014c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014cc:	89 c7                	mov    %eax,%edi
  8014ce:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  8014d5:	00 00 00 
  8014d8:	ff d0                	callq  *%rax
			close(fd_dest);
  8014da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014dd:	89 c7                	mov    %eax,%edi
  8014df:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  8014e6:	00 00 00 
  8014e9:	ff d0                	callq  *%rax
			return write_size;
  8014eb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014ee:	e9 a1 00 00 00       	jmpq   801594 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014f3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014fd:	ba 00 02 00 00       	mov    $0x200,%edx
  801502:	48 89 ce             	mov    %rcx,%rsi
  801505:	89 c7                	mov    %eax,%edi
  801507:	48 b8 65 0a 80 00 00 	movabs $0x800a65,%rax
  80150e:	00 00 00 
  801511:	ff d0                	callq  *%rax
  801513:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801516:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80151a:	0f 8f 5f ff ff ff    	jg     80147f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  801520:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801524:	79 47                	jns    80156d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801526:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801529:	89 c6                	mov    %eax,%esi
  80152b:	48 bf 40 37 80 00 00 	movabs $0x803740,%rdi
  801532:	00 00 00 
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	48 ba 4b 20 80 00 00 	movabs $0x80204b,%rdx
  801541:	00 00 00 
  801544:	ff d2                	callq  *%rdx
		close(fd_src);
  801546:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801549:	89 c7                	mov    %eax,%edi
  80154b:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  801552:	00 00 00 
  801555:	ff d0                	callq  *%rax
		close(fd_dest);
  801557:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80155a:	89 c7                	mov    %eax,%edi
  80155c:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  801563:	00 00 00 
  801566:	ff d0                	callq  *%rax
		return read_size;
  801568:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80156b:	eb 27                	jmp    801594 <copy+0x1d9>
	}
	close(fd_src);
  80156d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801570:	89 c7                	mov    %eax,%edi
  801572:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  801579:	00 00 00 
  80157c:	ff d0                	callq  *%rax
	close(fd_dest);
  80157e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801581:	89 c7                	mov    %eax,%edi
  801583:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  80158a:	00 00 00 
  80158d:	ff d0                	callq  *%rax
	return 0;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801594:	c9                   	leaveq 
  801595:	c3                   	retq   

0000000000801596 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801596:	55                   	push   %rbp
  801597:	48 89 e5             	mov    %rsp,%rbp
  80159a:	53                   	push   %rbx
  80159b:	48 83 ec 38          	sub    $0x38,%rsp
  80159f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015a3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015a7:	48 89 c7             	mov    %rax,%rdi
  8015aa:	48 b8 9b 05 80 00 00 	movabs $0x80059b,%rax
  8015b1:	00 00 00 
  8015b4:	ff d0                	callq  *%rax
  8015b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015bd:	0f 88 bf 01 00 00    	js     801782 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	ba 07 04 00 00       	mov    $0x407,%edx
  8015cc:	48 89 c6             	mov    %rax,%rsi
  8015cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8015d4:	48 b8 e0 02 80 00 00 	movabs $0x8002e0,%rax
  8015db:	00 00 00 
  8015de:	ff d0                	callq  *%rax
  8015e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015e7:	0f 88 95 01 00 00    	js     801782 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8015ed:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015f1:	48 89 c7             	mov    %rax,%rdi
  8015f4:	48 b8 9b 05 80 00 00 	movabs $0x80059b,%rax
  8015fb:	00 00 00 
  8015fe:	ff d0                	callq  *%rax
  801600:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801603:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801607:	0f 88 5d 01 00 00    	js     80176a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80160d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801611:	ba 07 04 00 00       	mov    $0x407,%edx
  801616:	48 89 c6             	mov    %rax,%rsi
  801619:	bf 00 00 00 00       	mov    $0x0,%edi
  80161e:	48 b8 e0 02 80 00 00 	movabs $0x8002e0,%rax
  801625:	00 00 00 
  801628:	ff d0                	callq  *%rax
  80162a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80162d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801631:	0f 88 33 01 00 00    	js     80176a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163b:	48 89 c7             	mov    %rax,%rdi
  80163e:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  801645:	00 00 00 
  801648:	ff d0                	callq  *%rax
  80164a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80164e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801652:	ba 07 04 00 00       	mov    $0x407,%edx
  801657:	48 89 c6             	mov    %rax,%rsi
  80165a:	bf 00 00 00 00       	mov    $0x0,%edi
  80165f:	48 b8 e0 02 80 00 00 	movabs $0x8002e0,%rax
  801666:	00 00 00 
  801669:	ff d0                	callq  *%rax
  80166b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801672:	79 05                	jns    801679 <pipe+0xe3>
		goto err2;
  801674:	e9 d9 00 00 00       	jmpq   801752 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801679:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167d:	48 89 c7             	mov    %rax,%rdi
  801680:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  801687:	00 00 00 
  80168a:	ff d0                	callq  *%rax
  80168c:	48 89 c2             	mov    %rax,%rdx
  80168f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801693:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801699:	48 89 d1             	mov    %rdx,%rcx
  80169c:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a1:	48 89 c6             	mov    %rax,%rsi
  8016a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a9:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
  8016b0:	00 00 00 
  8016b3:	ff d0                	callq  *%rax
  8016b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016bc:	79 1b                	jns    8016d9 <pipe+0x143>
		goto err3;
  8016be:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016c3:	48 89 c6             	mov    %rax,%rsi
  8016c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8016cb:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  8016d2:	00 00 00 
  8016d5:	ff d0                	callq  *%rax
  8016d7:	eb 79                	jmp    801752 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dd:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016e4:	00 00 00 
  8016e7:	8b 12                	mov    (%rdx),%edx
  8016e9:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8016eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8016f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fa:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801701:	00 00 00 
  801704:	8b 12                	mov    (%rdx),%edx
  801706:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801708:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801717:	48 89 c7             	mov    %rax,%rdi
  80171a:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  801721:	00 00 00 
  801724:	ff d0                	callq  *%rax
  801726:	89 c2                	mov    %eax,%edx
  801728:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80172c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80172e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801732:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801736:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173a:	48 89 c7             	mov    %rax,%rdi
  80173d:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  801744:	00 00 00 
  801747:	ff d0                	callq  *%rax
  801749:	89 03                	mov    %eax,(%rbx)
	return 0;
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
  801750:	eb 33                	jmp    801785 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801752:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801756:	48 89 c6             	mov    %rax,%rsi
  801759:	bf 00 00 00 00       	mov    $0x0,%edi
  80175e:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  801765:	00 00 00 
  801768:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80176a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176e:	48 89 c6             	mov    %rax,%rsi
  801771:	bf 00 00 00 00       	mov    $0x0,%edi
  801776:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  80177d:	00 00 00 
  801780:	ff d0                	callq  *%rax
err:
	return r;
  801782:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801785:	48 83 c4 38          	add    $0x38,%rsp
  801789:	5b                   	pop    %rbx
  80178a:	5d                   	pop    %rbp
  80178b:	c3                   	retq   

000000000080178c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80178c:	55                   	push   %rbp
  80178d:	48 89 e5             	mov    %rsp,%rbp
  801790:	53                   	push   %rbx
  801791:	48 83 ec 28          	sub    $0x28,%rsp
  801795:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801799:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80179d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017a4:	00 00 00 
  8017a7:	48 8b 00             	mov    (%rax),%rax
  8017aa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b7:	48 89 c7             	mov    %rax,%rdi
  8017ba:	48 b8 47 35 80 00 00 	movabs $0x803547,%rax
  8017c1:	00 00 00 
  8017c4:	ff d0                	callq  *%rax
  8017c6:	89 c3                	mov    %eax,%ebx
  8017c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017cc:	48 89 c7             	mov    %rax,%rdi
  8017cf:	48 b8 47 35 80 00 00 	movabs $0x803547,%rax
  8017d6:	00 00 00 
  8017d9:	ff d0                	callq  *%rax
  8017db:	39 c3                	cmp    %eax,%ebx
  8017dd:	0f 94 c0             	sete   %al
  8017e0:	0f b6 c0             	movzbl %al,%eax
  8017e3:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8017e6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017ed:	00 00 00 
  8017f0:	48 8b 00             	mov    (%rax),%rax
  8017f3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017f9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8017fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017ff:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801802:	75 05                	jne    801809 <_pipeisclosed+0x7d>
			return ret;
  801804:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801807:	eb 4f                	jmp    801858 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801809:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80180c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80180f:	74 42                	je     801853 <_pipeisclosed+0xc7>
  801811:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801815:	75 3c                	jne    801853 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801817:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80181e:	00 00 00 
  801821:	48 8b 00             	mov    (%rax),%rax
  801824:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80182a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80182d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801830:	89 c6                	mov    %eax,%esi
  801832:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  801839:	00 00 00 
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax
  801841:	49 b8 4b 20 80 00 00 	movabs $0x80204b,%r8
  801848:	00 00 00 
  80184b:	41 ff d0             	callq  *%r8
	}
  80184e:	e9 4a ff ff ff       	jmpq   80179d <_pipeisclosed+0x11>
  801853:	e9 45 ff ff ff       	jmpq   80179d <_pipeisclosed+0x11>
}
  801858:	48 83 c4 28          	add    $0x28,%rsp
  80185c:	5b                   	pop    %rbx
  80185d:	5d                   	pop    %rbp
  80185e:	c3                   	retq   

000000000080185f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80185f:	55                   	push   %rbp
  801860:	48 89 e5             	mov    %rsp,%rbp
  801863:	48 83 ec 30          	sub    $0x30,%rsp
  801867:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80186a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80186e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801871:	48 89 d6             	mov    %rdx,%rsi
  801874:	89 c7                	mov    %eax,%edi
  801876:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  80187d:	00 00 00 
  801880:	ff d0                	callq  *%rax
  801882:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801885:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801889:	79 05                	jns    801890 <pipeisclosed+0x31>
		return r;
  80188b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80188e:	eb 31                	jmp    8018c1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801894:	48 89 c7             	mov    %rax,%rdi
  801897:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	callq  *%rax
  8018a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018af:	48 89 d6             	mov    %rdx,%rsi
  8018b2:	48 89 c7             	mov    %rax,%rdi
  8018b5:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  8018bc:	00 00 00 
  8018bf:	ff d0                	callq  *%rax
}
  8018c1:	c9                   	leaveq 
  8018c2:	c3                   	retq   

00000000008018c3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018c3:	55                   	push   %rbp
  8018c4:	48 89 e5             	mov    %rsp,%rbp
  8018c7:	48 83 ec 40          	sub    $0x40,%rsp
  8018cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018d3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018db:	48 89 c7             	mov    %rax,%rdi
  8018de:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  8018e5:	00 00 00 
  8018e8:	ff d0                	callq  *%rax
  8018ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8018ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8018f6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8018fd:	00 
  8018fe:	e9 92 00 00 00       	jmpq   801995 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801903:	eb 41                	jmp    801946 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801905:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80190a:	74 09                	je     801915 <devpipe_read+0x52>
				return i;
  80190c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801910:	e9 92 00 00 00       	jmpq   8019a7 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801915:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801919:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191d:	48 89 d6             	mov    %rdx,%rsi
  801920:	48 89 c7             	mov    %rax,%rdi
  801923:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  80192a:	00 00 00 
  80192d:	ff d0                	callq  *%rax
  80192f:	85 c0                	test   %eax,%eax
  801931:	74 07                	je     80193a <devpipe_read+0x77>
				return 0;
  801933:	b8 00 00 00 00       	mov    $0x0,%eax
  801938:	eb 6d                	jmp    8019a7 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80193a:	48 b8 a2 02 80 00 00 	movabs $0x8002a2,%rax
  801941:	00 00 00 
  801944:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801946:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194a:	8b 10                	mov    (%rax),%edx
  80194c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801950:	8b 40 04             	mov    0x4(%rax),%eax
  801953:	39 c2                	cmp    %eax,%edx
  801955:	74 ae                	je     801905 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80195f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801963:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801967:	8b 00                	mov    (%rax),%eax
  801969:	99                   	cltd   
  80196a:	c1 ea 1b             	shr    $0x1b,%edx
  80196d:	01 d0                	add    %edx,%eax
  80196f:	83 e0 1f             	and    $0x1f,%eax
  801972:	29 d0                	sub    %edx,%eax
  801974:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801978:	48 98                	cltq   
  80197a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80197f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801985:	8b 00                	mov    (%rax),%eax
  801987:	8d 50 01             	lea    0x1(%rax),%edx
  80198a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801990:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801995:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801999:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80199d:	0f 82 60 ff ff ff    	jb     801903 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 40          	sub    $0x40,%rsp
  8019b1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019b9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c1:	48 89 c7             	mov    %rax,%rdi
  8019c4:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
  8019d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019dc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019e3:	00 
  8019e4:	e9 8e 00 00 00       	jmpq   801a77 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019e9:	eb 31                	jmp    801a1c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f3:	48 89 d6             	mov    %rdx,%rsi
  8019f6:	48 89 c7             	mov    %rax,%rdi
  8019f9:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  801a00:	00 00 00 
  801a03:	ff d0                	callq  *%rax
  801a05:	85 c0                	test   %eax,%eax
  801a07:	74 07                	je     801a10 <devpipe_write+0x67>
				return 0;
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	eb 79                	jmp    801a89 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a10:	48 b8 a2 02 80 00 00 	movabs $0x8002a2,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a20:	8b 40 04             	mov    0x4(%rax),%eax
  801a23:	48 63 d0             	movslq %eax,%rdx
  801a26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a2a:	8b 00                	mov    (%rax),%eax
  801a2c:	48 98                	cltq   
  801a2e:	48 83 c0 20          	add    $0x20,%rax
  801a32:	48 39 c2             	cmp    %rax,%rdx
  801a35:	73 b4                	jae    8019eb <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a3b:	8b 40 04             	mov    0x4(%rax),%eax
  801a3e:	99                   	cltd   
  801a3f:	c1 ea 1b             	shr    $0x1b,%edx
  801a42:	01 d0                	add    %edx,%eax
  801a44:	83 e0 1f             	and    $0x1f,%eax
  801a47:	29 d0                	sub    %edx,%eax
  801a49:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a4d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a51:	48 01 ca             	add    %rcx,%rdx
  801a54:	0f b6 0a             	movzbl (%rdx),%ecx
  801a57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5b:	48 98                	cltq   
  801a5d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a65:	8b 40 04             	mov    0x4(%rax),%eax
  801a68:	8d 50 01             	lea    0x1(%rax),%edx
  801a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a72:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a7f:	0f 82 64 ff ff ff    	jb     8019e9 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a89:	c9                   	leaveq 
  801a8a:	c3                   	retq   

0000000000801a8b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a8b:	55                   	push   %rbp
  801a8c:	48 89 e5             	mov    %rsp,%rbp
  801a8f:	48 83 ec 20          	sub    $0x20,%rsp
  801a93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a9f:	48 89 c7             	mov    %rax,%rdi
  801aa2:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	callq  *%rax
  801aae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801ab2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ab6:	48 be 6e 37 80 00 00 	movabs $0x80376e,%rsi
  801abd:	00 00 00 
  801ac0:	48 89 c7             	mov    %rax,%rdi
  801ac3:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801acf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad3:	8b 50 04             	mov    0x4(%rax),%edx
  801ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ada:	8b 00                	mov    (%rax),%eax
  801adc:	29 c2                	sub    %eax,%edx
  801ade:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ae2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801ae8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aec:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801af3:	00 00 00 
	stat->st_dev = &devpipe;
  801af6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801afa:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b01:	00 00 00 
  801b04:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b10:	c9                   	leaveq 
  801b11:	c3                   	retq   

0000000000801b12 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b12:	55                   	push   %rbp
  801b13:	48 89 e5             	mov    %rsp,%rbp
  801b16:	48 83 ec 10          	sub    $0x10,%rsp
  801b1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b22:	48 89 c6             	mov    %rax,%rsi
  801b25:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2a:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3a:	48 89 c7             	mov    %rax,%rdi
  801b3d:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	callq  *%rax
  801b49:	48 89 c6             	mov    %rax,%rsi
  801b4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801b51:	48 b8 8b 03 80 00 00 	movabs $0x80038b,%rax
  801b58:	00 00 00 
  801b5b:	ff d0                	callq  *%rax
}
  801b5d:	c9                   	leaveq 
  801b5e:	c3                   	retq   

0000000000801b5f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b5f:	55                   	push   %rbp
  801b60:	48 89 e5             	mov    %rsp,%rbp
  801b63:	48 83 ec 20          	sub    $0x20,%rsp
  801b67:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b6d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b70:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b74:	be 01 00 00 00       	mov    $0x1,%esi
  801b79:	48 89 c7             	mov    %rax,%rdi
  801b7c:	48 b8 98 01 80 00 00 	movabs $0x800198,%rax
  801b83:	00 00 00 
  801b86:	ff d0                	callq  *%rax
}
  801b88:	c9                   	leaveq 
  801b89:	c3                   	retq   

0000000000801b8a <getchar>:

int
getchar(void)
{
  801b8a:	55                   	push   %rbp
  801b8b:	48 89 e5             	mov    %rsp,%rbp
  801b8e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801b92:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801b96:	ba 01 00 00 00       	mov    $0x1,%edx
  801b9b:	48 89 c6             	mov    %rax,%rsi
  801b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba3:	48 b8 65 0a 80 00 00 	movabs $0x800a65,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	callq  *%rax
  801baf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb6:	79 05                	jns    801bbd <getchar+0x33>
		return r;
  801bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbb:	eb 14                	jmp    801bd1 <getchar+0x47>
	if (r < 1)
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bc1:	7f 07                	jg     801bca <getchar+0x40>
		return -E_EOF;
  801bc3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801bc8:	eb 07                	jmp    801bd1 <getchar+0x47>
	return c;
  801bca:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801bce:	0f b6 c0             	movzbl %al,%eax
}
  801bd1:	c9                   	leaveq 
  801bd2:	c3                   	retq   

0000000000801bd3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bd3:	55                   	push   %rbp
  801bd4:	48 89 e5             	mov    %rsp,%rbp
  801bd7:	48 83 ec 20          	sub    $0x20,%rsp
  801bdb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bde:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801be2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801be5:	48 89 d6             	mov    %rdx,%rsi
  801be8:	89 c7                	mov    %eax,%edi
  801bea:	48 b8 33 06 80 00 00 	movabs $0x800633,%rax
  801bf1:	00 00 00 
  801bf4:	ff d0                	callq  *%rax
  801bf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bfd:	79 05                	jns    801c04 <iscons+0x31>
		return r;
  801bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c02:	eb 1a                	jmp    801c1e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c08:	8b 10                	mov    (%rax),%edx
  801c0a:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c11:	00 00 00 
  801c14:	8b 00                	mov    (%rax),%eax
  801c16:	39 c2                	cmp    %eax,%edx
  801c18:	0f 94 c0             	sete   %al
  801c1b:	0f b6 c0             	movzbl %al,%eax
}
  801c1e:	c9                   	leaveq 
  801c1f:	c3                   	retq   

0000000000801c20 <opencons>:

int
opencons(void)
{
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c28:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c2c:	48 89 c7             	mov    %rax,%rdi
  801c2f:	48 b8 9b 05 80 00 00 	movabs $0x80059b,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
  801c3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c42:	79 05                	jns    801c49 <opencons+0x29>
		return r;
  801c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c47:	eb 5b                	jmp    801ca4 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4d:	ba 07 04 00 00       	mov    $0x407,%edx
  801c52:	48 89 c6             	mov    %rax,%rsi
  801c55:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5a:	48 b8 e0 02 80 00 00 	movabs $0x8002e0,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	callq  *%rax
  801c66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c6d:	79 05                	jns    801c74 <opencons+0x54>
		return r;
  801c6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c72:	eb 30                	jmp    801ca4 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c78:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c7f:	00 00 00 
  801c82:	8b 12                	mov    (%rdx),%edx
  801c84:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c95:	48 89 c7             	mov    %rax,%rdi
  801c98:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  801c9f:	00 00 00 
  801ca2:	ff d0                	callq  *%rax
}
  801ca4:	c9                   	leaveq 
  801ca5:	c3                   	retq   

0000000000801ca6 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ca6:	55                   	push   %rbp
  801ca7:	48 89 e5             	mov    %rsp,%rbp
  801caa:	48 83 ec 30          	sub    $0x30,%rsp
  801cae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cb6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cbf:	75 07                	jne    801cc8 <devcons_read+0x22>
		return 0;
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc6:	eb 4b                	jmp    801d13 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801cc8:	eb 0c                	jmp    801cd6 <devcons_read+0x30>
		sys_yield();
  801cca:	48 b8 a2 02 80 00 00 	movabs $0x8002a2,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cd6:	48 b8 e2 01 80 00 00 	movabs $0x8001e2,%rax
  801cdd:	00 00 00 
  801ce0:	ff d0                	callq  *%rax
  801ce2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce9:	74 df                	je     801cca <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801ceb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cef:	79 05                	jns    801cf6 <devcons_read+0x50>
		return c;
  801cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf4:	eb 1d                	jmp    801d13 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801cf6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801cfa:	75 07                	jne    801d03 <devcons_read+0x5d>
		return 0;
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	eb 10                	jmp    801d13 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d06:	89 c2                	mov    %eax,%edx
  801d08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d0c:	88 10                	mov    %dl,(%rax)
	return 1;
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d13:	c9                   	leaveq 
  801d14:	c3                   	retq   

0000000000801d15 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d15:	55                   	push   %rbp
  801d16:	48 89 e5             	mov    %rsp,%rbp
  801d19:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d20:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d27:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d2e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d3c:	eb 76                	jmp    801db4 <devcons_write+0x9f>
		m = n - tot;
  801d3e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d45:	89 c2                	mov    %eax,%edx
  801d47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4a:	29 c2                	sub    %eax,%edx
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d54:	83 f8 7f             	cmp    $0x7f,%eax
  801d57:	76 07                	jbe    801d60 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d59:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d63:	48 63 d0             	movslq %eax,%rdx
  801d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d69:	48 63 c8             	movslq %eax,%rcx
  801d6c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d73:	48 01 c1             	add    %rax,%rcx
  801d76:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d7d:	48 89 ce             	mov    %rcx,%rsi
  801d80:	48 89 c7             	mov    %rax,%rdi
  801d83:	48 b8 37 2f 80 00 00 	movabs $0x802f37,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801d8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d92:	48 63 d0             	movslq %eax,%rdx
  801d95:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d9c:	48 89 d6             	mov    %rdx,%rsi
  801d9f:	48 89 c7             	mov    %rax,%rdi
  801da2:	48 b8 98 01 80 00 00 	movabs $0x800198,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db1:	01 45 fc             	add    %eax,-0x4(%rbp)
  801db4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db7:	48 98                	cltq   
  801db9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dc0:	0f 82 78 ff ff ff    	jb     801d3e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dc9:	c9                   	leaveq 
  801dca:	c3                   	retq   

0000000000801dcb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801dcb:	55                   	push   %rbp
  801dcc:	48 89 e5             	mov    %rsp,%rbp
  801dcf:	48 83 ec 08          	sub    $0x8,%rsp
  801dd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 10          	sub    $0x10,%rsp
  801de6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df2:	48 be 7a 37 80 00 00 	movabs $0x80377a,%rsi
  801df9:	00 00 00 
  801dfc:	48 89 c7             	mov    %rax,%rdi
  801dff:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	callq  *%rax
	return 0;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e10:	c9                   	leaveq 
  801e11:	c3                   	retq   

0000000000801e12 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e12:	55                   	push   %rbp
  801e13:	48 89 e5             	mov    %rsp,%rbp
  801e16:	53                   	push   %rbx
  801e17:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e1e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e25:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e2b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e32:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e39:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e40:	84 c0                	test   %al,%al
  801e42:	74 23                	je     801e67 <_panic+0x55>
  801e44:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e4b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e4f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e53:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e57:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e5b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e5f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e63:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e67:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e6e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e75:	00 00 00 
  801e78:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e7f:	00 00 00 
  801e82:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e86:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801e8d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801e94:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e9b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801ea2:	00 00 00 
  801ea5:	48 8b 18             	mov    (%rax),%rbx
  801ea8:	48 b8 64 02 80 00 00 	movabs $0x800264,%rax
  801eaf:	00 00 00 
  801eb2:	ff d0                	callq  *%rax
  801eb4:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801eba:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ec1:	41 89 c8             	mov    %ecx,%r8d
  801ec4:	48 89 d1             	mov    %rdx,%rcx
  801ec7:	48 89 da             	mov    %rbx,%rdx
  801eca:	89 c6                	mov    %eax,%esi
  801ecc:	48 bf 88 37 80 00 00 	movabs $0x803788,%rdi
  801ed3:	00 00 00 
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	49 b9 4b 20 80 00 00 	movabs $0x80204b,%r9
  801ee2:	00 00 00 
  801ee5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ee8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801eef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801ef6:	48 89 d6             	mov    %rdx,%rsi
  801ef9:	48 89 c7             	mov    %rax,%rdi
  801efc:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  801f03:	00 00 00 
  801f06:	ff d0                	callq  *%rax
	cprintf("\n");
  801f08:	48 bf ab 37 80 00 00 	movabs $0x8037ab,%rdi
  801f0f:	00 00 00 
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
  801f17:	48 ba 4b 20 80 00 00 	movabs $0x80204b,%rdx
  801f1e:	00 00 00 
  801f21:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f23:	cc                   	int3   
  801f24:	eb fd                	jmp    801f23 <_panic+0x111>

0000000000801f26 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f26:	55                   	push   %rbp
  801f27:	48 89 e5             	mov    %rsp,%rbp
  801f2a:	48 83 ec 10          	sub    $0x10,%rsp
  801f2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f39:	8b 00                	mov    (%rax),%eax
  801f3b:	8d 48 01             	lea    0x1(%rax),%ecx
  801f3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f42:	89 0a                	mov    %ecx,(%rdx)
  801f44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f47:	89 d1                	mov    %edx,%ecx
  801f49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4d:	48 98                	cltq   
  801f4f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f57:	8b 00                	mov    (%rax),%eax
  801f59:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f5e:	75 2c                	jne    801f8c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f64:	8b 00                	mov    (%rax),%eax
  801f66:	48 98                	cltq   
  801f68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6c:	48 83 c2 08          	add    $0x8,%rdx
  801f70:	48 89 c6             	mov    %rax,%rsi
  801f73:	48 89 d7             	mov    %rdx,%rdi
  801f76:	48 b8 98 01 80 00 00 	movabs $0x800198,%rax
  801f7d:	00 00 00 
  801f80:	ff d0                	callq  *%rax
        b->idx = 0;
  801f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f86:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f90:	8b 40 04             	mov    0x4(%rax),%eax
  801f93:	8d 50 01             	lea    0x1(%rax),%edx
  801f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9a:	89 50 04             	mov    %edx,0x4(%rax)
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   

0000000000801f9f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
  801fa3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801faa:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fb1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fb8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fbf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fc6:	48 8b 0a             	mov    (%rdx),%rcx
  801fc9:	48 89 08             	mov    %rcx,(%rax)
  801fcc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fd0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fd4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801fd8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801fdc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801fe3:	00 00 00 
    b.cnt = 0;
  801fe6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801fed:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801ff0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801ff7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801ffe:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802005:	48 89 c6             	mov    %rax,%rsi
  802008:	48 bf 26 1f 80 00 00 	movabs $0x801f26,%rdi
  80200f:	00 00 00 
  802012:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  802019:	00 00 00 
  80201c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80201e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802024:	48 98                	cltq   
  802026:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80202d:	48 83 c2 08          	add    $0x8,%rdx
  802031:	48 89 c6             	mov    %rax,%rsi
  802034:	48 89 d7             	mov    %rdx,%rdi
  802037:	48 b8 98 01 80 00 00 	movabs $0x800198,%rax
  80203e:	00 00 00 
  802041:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802043:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802049:	c9                   	leaveq 
  80204a:	c3                   	retq   

000000000080204b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802056:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80205d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802064:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80206b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802072:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802079:	84 c0                	test   %al,%al
  80207b:	74 20                	je     80209d <cprintf+0x52>
  80207d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802081:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802085:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802089:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80208d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802091:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802095:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802099:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80209d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020a4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020ab:	00 00 00 
  8020ae:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020b5:	00 00 00 
  8020b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020bc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020c3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020ca:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020d1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020d8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020df:	48 8b 0a             	mov    (%rdx),%rcx
  8020e2:	48 89 08             	mov    %rcx,(%rax)
  8020e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8020e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8020ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8020f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8020f5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8020fc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802103:	48 89 d6             	mov    %rdx,%rsi
  802106:	48 89 c7             	mov    %rax,%rdi
  802109:	48 b8 9f 1f 80 00 00 	movabs $0x801f9f,%rax
  802110:	00 00 00 
  802113:	ff d0                	callq  *%rax
  802115:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80211b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802121:	c9                   	leaveq 
  802122:	c3                   	retq   

0000000000802123 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802123:	55                   	push   %rbp
  802124:	48 89 e5             	mov    %rsp,%rbp
  802127:	53                   	push   %rbx
  802128:	48 83 ec 38          	sub    $0x38,%rsp
  80212c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802130:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802134:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802138:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80213b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80213f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802143:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802146:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80214a:	77 3b                	ja     802187 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80214c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80214f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802153:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802156:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215a:	ba 00 00 00 00       	mov    $0x0,%edx
  80215f:	48 f7 f3             	div    %rbx
  802162:	48 89 c2             	mov    %rax,%rdx
  802165:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802168:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80216b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80216f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802173:	41 89 f9             	mov    %edi,%r9d
  802176:	48 89 c7             	mov    %rax,%rdi
  802179:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  802180:	00 00 00 
  802183:	ff d0                	callq  *%rax
  802185:	eb 1e                	jmp    8021a5 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802187:	eb 12                	jmp    80219b <printnum+0x78>
			putch(padc, putdat);
  802189:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80218d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802194:	48 89 ce             	mov    %rcx,%rsi
  802197:	89 d7                	mov    %edx,%edi
  802199:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80219b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80219f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021a3:	7f e4                	jg     802189 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021a5:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b1:	48 f7 f1             	div    %rcx
  8021b4:	48 89 d0             	mov    %rdx,%rax
  8021b7:	48 ba b0 39 80 00 00 	movabs $0x8039b0,%rdx
  8021be:	00 00 00 
  8021c1:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021c5:	0f be d0             	movsbl %al,%edx
  8021c8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d0:	48 89 ce             	mov    %rcx,%rsi
  8021d3:	89 d7                	mov    %edx,%edi
  8021d5:	ff d0                	callq  *%rax
}
  8021d7:	48 83 c4 38          	add    $0x38,%rsp
  8021db:	5b                   	pop    %rbx
  8021dc:	5d                   	pop    %rbp
  8021dd:	c3                   	retq   

00000000008021de <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021de:	55                   	push   %rbp
  8021df:	48 89 e5             	mov    %rsp,%rbp
  8021e2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8021e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021ea:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8021ed:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8021f1:	7e 52                	jle    802245 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8021f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f7:	8b 00                	mov    (%rax),%eax
  8021f9:	83 f8 30             	cmp    $0x30,%eax
  8021fc:	73 24                	jae    802222 <getuint+0x44>
  8021fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802202:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220a:	8b 00                	mov    (%rax),%eax
  80220c:	89 c0                	mov    %eax,%eax
  80220e:	48 01 d0             	add    %rdx,%rax
  802211:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802215:	8b 12                	mov    (%rdx),%edx
  802217:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80221a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80221e:	89 0a                	mov    %ecx,(%rdx)
  802220:	eb 17                	jmp    802239 <getuint+0x5b>
  802222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802226:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80222a:	48 89 d0             	mov    %rdx,%rax
  80222d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802231:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802235:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802239:	48 8b 00             	mov    (%rax),%rax
  80223c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802240:	e9 a3 00 00 00       	jmpq   8022e8 <getuint+0x10a>
	else if (lflag)
  802245:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802249:	74 4f                	je     80229a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80224b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224f:	8b 00                	mov    (%rax),%eax
  802251:	83 f8 30             	cmp    $0x30,%eax
  802254:	73 24                	jae    80227a <getuint+0x9c>
  802256:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80225e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802262:	8b 00                	mov    (%rax),%eax
  802264:	89 c0                	mov    %eax,%eax
  802266:	48 01 d0             	add    %rdx,%rax
  802269:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80226d:	8b 12                	mov    (%rdx),%edx
  80226f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802272:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802276:	89 0a                	mov    %ecx,(%rdx)
  802278:	eb 17                	jmp    802291 <getuint+0xb3>
  80227a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802282:	48 89 d0             	mov    %rdx,%rax
  802285:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802289:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80228d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802291:	48 8b 00             	mov    (%rax),%rax
  802294:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802298:	eb 4e                	jmp    8022e8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80229a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229e:	8b 00                	mov    (%rax),%eax
  8022a0:	83 f8 30             	cmp    $0x30,%eax
  8022a3:	73 24                	jae    8022c9 <getuint+0xeb>
  8022a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b1:	8b 00                	mov    (%rax),%eax
  8022b3:	89 c0                	mov    %eax,%eax
  8022b5:	48 01 d0             	add    %rdx,%rax
  8022b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022bc:	8b 12                	mov    (%rdx),%edx
  8022be:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c5:	89 0a                	mov    %ecx,(%rdx)
  8022c7:	eb 17                	jmp    8022e0 <getuint+0x102>
  8022c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022d1:	48 89 d0             	mov    %rdx,%rax
  8022d4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022dc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022e0:	8b 00                	mov    (%rax),%eax
  8022e2:	89 c0                	mov    %eax,%eax
  8022e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8022e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022ec:	c9                   	leaveq 
  8022ed:	c3                   	retq   

00000000008022ee <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8022ee:	55                   	push   %rbp
  8022ef:	48 89 e5             	mov    %rsp,%rbp
  8022f2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8022f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8022fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802301:	7e 52                	jle    802355 <getint+0x67>
		x=va_arg(*ap, long long);
  802303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802307:	8b 00                	mov    (%rax),%eax
  802309:	83 f8 30             	cmp    $0x30,%eax
  80230c:	73 24                	jae    802332 <getint+0x44>
  80230e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802312:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231a:	8b 00                	mov    (%rax),%eax
  80231c:	89 c0                	mov    %eax,%eax
  80231e:	48 01 d0             	add    %rdx,%rax
  802321:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802325:	8b 12                	mov    (%rdx),%edx
  802327:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80232a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80232e:	89 0a                	mov    %ecx,(%rdx)
  802330:	eb 17                	jmp    802349 <getint+0x5b>
  802332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802336:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80233a:	48 89 d0             	mov    %rdx,%rax
  80233d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802341:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802345:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802349:	48 8b 00             	mov    (%rax),%rax
  80234c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802350:	e9 a3 00 00 00       	jmpq   8023f8 <getint+0x10a>
	else if (lflag)
  802355:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802359:	74 4f                	je     8023aa <getint+0xbc>
		x=va_arg(*ap, long);
  80235b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235f:	8b 00                	mov    (%rax),%eax
  802361:	83 f8 30             	cmp    $0x30,%eax
  802364:	73 24                	jae    80238a <getint+0x9c>
  802366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80236e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802372:	8b 00                	mov    (%rax),%eax
  802374:	89 c0                	mov    %eax,%eax
  802376:	48 01 d0             	add    %rdx,%rax
  802379:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80237d:	8b 12                	mov    (%rdx),%edx
  80237f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802382:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802386:	89 0a                	mov    %ecx,(%rdx)
  802388:	eb 17                	jmp    8023a1 <getint+0xb3>
  80238a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802392:	48 89 d0             	mov    %rdx,%rax
  802395:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802399:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023a1:	48 8b 00             	mov    (%rax),%rax
  8023a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023a8:	eb 4e                	jmp    8023f8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ae:	8b 00                	mov    (%rax),%eax
  8023b0:	83 f8 30             	cmp    $0x30,%eax
  8023b3:	73 24                	jae    8023d9 <getint+0xeb>
  8023b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c1:	8b 00                	mov    (%rax),%eax
  8023c3:	89 c0                	mov    %eax,%eax
  8023c5:	48 01 d0             	add    %rdx,%rax
  8023c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023cc:	8b 12                	mov    (%rdx),%edx
  8023ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d5:	89 0a                	mov    %ecx,(%rdx)
  8023d7:	eb 17                	jmp    8023f0 <getint+0x102>
  8023d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023e1:	48 89 d0             	mov    %rdx,%rax
  8023e4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023f0:	8b 00                	mov    (%rax),%eax
  8023f2:	48 98                	cltq   
  8023f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8023f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023fc:	c9                   	leaveq 
  8023fd:	c3                   	retq   

00000000008023fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8023fe:	55                   	push   %rbp
  8023ff:	48 89 e5             	mov    %rsp,%rbp
  802402:	41 54                	push   %r12
  802404:	53                   	push   %rbx
  802405:	48 83 ec 60          	sub    $0x60,%rsp
  802409:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80240d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802411:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802415:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802419:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80241d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802421:	48 8b 0a             	mov    (%rdx),%rcx
  802424:	48 89 08             	mov    %rcx,(%rax)
  802427:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80242b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80242f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802433:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802437:	eb 17                	jmp    802450 <vprintfmt+0x52>
			if (ch == '\0')
  802439:	85 db                	test   %ebx,%ebx
  80243b:	0f 84 df 04 00 00    	je     802920 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  802441:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802445:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802449:	48 89 d6             	mov    %rdx,%rsi
  80244c:	89 df                	mov    %ebx,%edi
  80244e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802450:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802454:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802458:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80245c:	0f b6 00             	movzbl (%rax),%eax
  80245f:	0f b6 d8             	movzbl %al,%ebx
  802462:	83 fb 25             	cmp    $0x25,%ebx
  802465:	75 d2                	jne    802439 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802467:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80246b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802472:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802480:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802487:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80248b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80248f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802493:	0f b6 00             	movzbl (%rax),%eax
  802496:	0f b6 d8             	movzbl %al,%ebx
  802499:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80249c:	83 f8 55             	cmp    $0x55,%eax
  80249f:	0f 87 47 04 00 00    	ja     8028ec <vprintfmt+0x4ee>
  8024a5:	89 c0                	mov    %eax,%eax
  8024a7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024ae:	00 
  8024af:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  8024b6:	00 00 00 
  8024b9:	48 01 d0             	add    %rdx,%rax
  8024bc:	48 8b 00             	mov    (%rax),%rax
  8024bf:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024c1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024c5:	eb c0                	jmp    802487 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024c7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024cb:	eb ba                	jmp    802487 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024d4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024d7:	89 d0                	mov    %edx,%eax
  8024d9:	c1 e0 02             	shl    $0x2,%eax
  8024dc:	01 d0                	add    %edx,%eax
  8024de:	01 c0                	add    %eax,%eax
  8024e0:	01 d8                	add    %ebx,%eax
  8024e2:	83 e8 30             	sub    $0x30,%eax
  8024e5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8024e8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024ec:	0f b6 00             	movzbl (%rax),%eax
  8024ef:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8024f2:	83 fb 2f             	cmp    $0x2f,%ebx
  8024f5:	7e 0c                	jle    802503 <vprintfmt+0x105>
  8024f7:	83 fb 39             	cmp    $0x39,%ebx
  8024fa:	7f 07                	jg     802503 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024fc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802501:	eb d1                	jmp    8024d4 <vprintfmt+0xd6>
			goto process_precision;
  802503:	eb 58                	jmp    80255d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802505:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802508:	83 f8 30             	cmp    $0x30,%eax
  80250b:	73 17                	jae    802524 <vprintfmt+0x126>
  80250d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802511:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802514:	89 c0                	mov    %eax,%eax
  802516:	48 01 d0             	add    %rdx,%rax
  802519:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80251c:	83 c2 08             	add    $0x8,%edx
  80251f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802522:	eb 0f                	jmp    802533 <vprintfmt+0x135>
  802524:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802528:	48 89 d0             	mov    %rdx,%rax
  80252b:	48 83 c2 08          	add    $0x8,%rdx
  80252f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802533:	8b 00                	mov    (%rax),%eax
  802535:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802538:	eb 23                	jmp    80255d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80253a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80253e:	79 0c                	jns    80254c <vprintfmt+0x14e>
				width = 0;
  802540:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802547:	e9 3b ff ff ff       	jmpq   802487 <vprintfmt+0x89>
  80254c:	e9 36 ff ff ff       	jmpq   802487 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802551:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802558:	e9 2a ff ff ff       	jmpq   802487 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80255d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802561:	79 12                	jns    802575 <vprintfmt+0x177>
				width = precision, precision = -1;
  802563:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802566:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802569:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802570:	e9 12 ff ff ff       	jmpq   802487 <vprintfmt+0x89>
  802575:	e9 0d ff ff ff       	jmpq   802487 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80257a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80257e:	e9 04 ff ff ff       	jmpq   802487 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802583:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802586:	83 f8 30             	cmp    $0x30,%eax
  802589:	73 17                	jae    8025a2 <vprintfmt+0x1a4>
  80258b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80258f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802592:	89 c0                	mov    %eax,%eax
  802594:	48 01 d0             	add    %rdx,%rax
  802597:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80259a:	83 c2 08             	add    $0x8,%edx
  80259d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025a0:	eb 0f                	jmp    8025b1 <vprintfmt+0x1b3>
  8025a2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025a6:	48 89 d0             	mov    %rdx,%rax
  8025a9:	48 83 c2 08          	add    $0x8,%rdx
  8025ad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025b1:	8b 10                	mov    (%rax),%edx
  8025b3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025bb:	48 89 ce             	mov    %rcx,%rsi
  8025be:	89 d7                	mov    %edx,%edi
  8025c0:	ff d0                	callq  *%rax
			break;
  8025c2:	e9 53 03 00 00       	jmpq   80291a <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025ca:	83 f8 30             	cmp    $0x30,%eax
  8025cd:	73 17                	jae    8025e6 <vprintfmt+0x1e8>
  8025cf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025d6:	89 c0                	mov    %eax,%eax
  8025d8:	48 01 d0             	add    %rdx,%rax
  8025db:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025de:	83 c2 08             	add    $0x8,%edx
  8025e1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025e4:	eb 0f                	jmp    8025f5 <vprintfmt+0x1f7>
  8025e6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025ea:	48 89 d0             	mov    %rdx,%rax
  8025ed:	48 83 c2 08          	add    $0x8,%rdx
  8025f1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025f5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8025f7:	85 db                	test   %ebx,%ebx
  8025f9:	79 02                	jns    8025fd <vprintfmt+0x1ff>
				err = -err;
  8025fb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8025fd:	83 fb 15             	cmp    $0x15,%ebx
  802600:	7f 16                	jg     802618 <vprintfmt+0x21a>
  802602:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  802609:	00 00 00 
  80260c:	48 63 d3             	movslq %ebx,%rdx
  80260f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802613:	4d 85 e4             	test   %r12,%r12
  802616:	75 2e                	jne    802646 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802618:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80261c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802620:	89 d9                	mov    %ebx,%ecx
  802622:	48 ba c1 39 80 00 00 	movabs $0x8039c1,%rdx
  802629:	00 00 00 
  80262c:	48 89 c7             	mov    %rax,%rdi
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
  802634:	49 b8 29 29 80 00 00 	movabs $0x802929,%r8
  80263b:	00 00 00 
  80263e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802641:	e9 d4 02 00 00       	jmpq   80291a <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802646:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80264a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80264e:	4c 89 e1             	mov    %r12,%rcx
  802651:	48 ba ca 39 80 00 00 	movabs $0x8039ca,%rdx
  802658:	00 00 00 
  80265b:	48 89 c7             	mov    %rax,%rdi
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
  802663:	49 b8 29 29 80 00 00 	movabs $0x802929,%r8
  80266a:	00 00 00 
  80266d:	41 ff d0             	callq  *%r8
			break;
  802670:	e9 a5 02 00 00       	jmpq   80291a <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802675:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802678:	83 f8 30             	cmp    $0x30,%eax
  80267b:	73 17                	jae    802694 <vprintfmt+0x296>
  80267d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802681:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802684:	89 c0                	mov    %eax,%eax
  802686:	48 01 d0             	add    %rdx,%rax
  802689:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80268c:	83 c2 08             	add    $0x8,%edx
  80268f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802692:	eb 0f                	jmp    8026a3 <vprintfmt+0x2a5>
  802694:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802698:	48 89 d0             	mov    %rdx,%rax
  80269b:	48 83 c2 08          	add    $0x8,%rdx
  80269f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026a3:	4c 8b 20             	mov    (%rax),%r12
  8026a6:	4d 85 e4             	test   %r12,%r12
  8026a9:	75 0a                	jne    8026b5 <vprintfmt+0x2b7>
				p = "(null)";
  8026ab:	49 bc cd 39 80 00 00 	movabs $0x8039cd,%r12
  8026b2:	00 00 00 
			if (width > 0 && padc != '-')
  8026b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026b9:	7e 3f                	jle    8026fa <vprintfmt+0x2fc>
  8026bb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026bf:	74 39                	je     8026fa <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026c1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026c4:	48 98                	cltq   
  8026c6:	48 89 c6             	mov    %rax,%rsi
  8026c9:	4c 89 e7             	mov    %r12,%rdi
  8026cc:	48 b8 d5 2b 80 00 00 	movabs $0x802bd5,%rax
  8026d3:	00 00 00 
  8026d6:	ff d0                	callq  *%rax
  8026d8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026db:	eb 17                	jmp    8026f4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026dd:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8026e1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8026e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026e9:	48 89 ce             	mov    %rcx,%rsi
  8026ec:	89 d7                	mov    %edx,%edi
  8026ee:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8026f0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026f8:	7f e3                	jg     8026dd <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026fa:	eb 37                	jmp    802733 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8026fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802700:	74 1e                	je     802720 <vprintfmt+0x322>
  802702:	83 fb 1f             	cmp    $0x1f,%ebx
  802705:	7e 05                	jle    80270c <vprintfmt+0x30e>
  802707:	83 fb 7e             	cmp    $0x7e,%ebx
  80270a:	7e 14                	jle    802720 <vprintfmt+0x322>
					putch('?', putdat);
  80270c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802710:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802714:	48 89 d6             	mov    %rdx,%rsi
  802717:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80271c:	ff d0                	callq  *%rax
  80271e:	eb 0f                	jmp    80272f <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802720:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802724:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802728:	48 89 d6             	mov    %rdx,%rsi
  80272b:	89 df                	mov    %ebx,%edi
  80272d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80272f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802733:	4c 89 e0             	mov    %r12,%rax
  802736:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80273a:	0f b6 00             	movzbl (%rax),%eax
  80273d:	0f be d8             	movsbl %al,%ebx
  802740:	85 db                	test   %ebx,%ebx
  802742:	74 10                	je     802754 <vprintfmt+0x356>
  802744:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802748:	78 b2                	js     8026fc <vprintfmt+0x2fe>
  80274a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80274e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802752:	79 a8                	jns    8026fc <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802754:	eb 16                	jmp    80276c <vprintfmt+0x36e>
				putch(' ', putdat);
  802756:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80275a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80275e:	48 89 d6             	mov    %rdx,%rsi
  802761:	bf 20 00 00 00       	mov    $0x20,%edi
  802766:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802768:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80276c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802770:	7f e4                	jg     802756 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802772:	e9 a3 01 00 00       	jmpq   80291a <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802777:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80277b:	be 03 00 00 00       	mov    $0x3,%esi
  802780:	48 89 c7             	mov    %rax,%rdi
  802783:	48 b8 ee 22 80 00 00 	movabs $0x8022ee,%rax
  80278a:	00 00 00 
  80278d:	ff d0                	callq  *%rax
  80278f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802797:	48 85 c0             	test   %rax,%rax
  80279a:	79 1d                	jns    8027b9 <vprintfmt+0x3bb>
				putch('-', putdat);
  80279c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027a4:	48 89 d6             	mov    %rdx,%rsi
  8027a7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027ac:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b2:	48 f7 d8             	neg    %rax
  8027b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027b9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027c0:	e9 e8 00 00 00       	jmpq   8028ad <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027c5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027c9:	be 03 00 00 00       	mov    $0x3,%esi
  8027ce:	48 89 c7             	mov    %rax,%rdi
  8027d1:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	callq  *%rax
  8027dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8027e1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027e8:	e9 c0 00 00 00       	jmpq   8028ad <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8027ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027f5:	48 89 d6             	mov    %rdx,%rsi
  8027f8:	bf 58 00 00 00       	mov    $0x58,%edi
  8027fd:	ff d0                	callq  *%rax
			putch('X', putdat);
  8027ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802803:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802807:	48 89 d6             	mov    %rdx,%rsi
  80280a:	bf 58 00 00 00       	mov    $0x58,%edi
  80280f:	ff d0                	callq  *%rax
			putch('X', putdat);
  802811:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802815:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802819:	48 89 d6             	mov    %rdx,%rsi
  80281c:	bf 58 00 00 00       	mov    $0x58,%edi
  802821:	ff d0                	callq  *%rax
			break;
  802823:	e9 f2 00 00 00       	jmpq   80291a <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802828:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80282c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802830:	48 89 d6             	mov    %rdx,%rsi
  802833:	bf 30 00 00 00       	mov    $0x30,%edi
  802838:	ff d0                	callq  *%rax
			putch('x', putdat);
  80283a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80283e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802842:	48 89 d6             	mov    %rdx,%rsi
  802845:	bf 78 00 00 00       	mov    $0x78,%edi
  80284a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80284c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80284f:	83 f8 30             	cmp    $0x30,%eax
  802852:	73 17                	jae    80286b <vprintfmt+0x46d>
  802854:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802858:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80285b:	89 c0                	mov    %eax,%eax
  80285d:	48 01 d0             	add    %rdx,%rax
  802860:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802863:	83 c2 08             	add    $0x8,%edx
  802866:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802869:	eb 0f                	jmp    80287a <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80286b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80286f:	48 89 d0             	mov    %rdx,%rax
  802872:	48 83 c2 08          	add    $0x8,%rdx
  802876:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80287a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80287d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802881:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802888:	eb 23                	jmp    8028ad <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80288a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80288e:	be 03 00 00 00       	mov    $0x3,%esi
  802893:	48 89 c7             	mov    %rax,%rdi
  802896:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  80289d:	00 00 00 
  8028a0:	ff d0                	callq  *%rax
  8028a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028a6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028ad:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028b2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028b5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028bc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028c4:	45 89 c1             	mov    %r8d,%r9d
  8028c7:	41 89 f8             	mov    %edi,%r8d
  8028ca:	48 89 c7             	mov    %rax,%rdi
  8028cd:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
			break;
  8028d9:	eb 3f                	jmp    80291a <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028e3:	48 89 d6             	mov    %rdx,%rsi
  8028e6:	89 df                	mov    %ebx,%edi
  8028e8:	ff d0                	callq  *%rax
			break;
  8028ea:	eb 2e                	jmp    80291a <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8028ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028f4:	48 89 d6             	mov    %rdx,%rsi
  8028f7:	bf 25 00 00 00       	mov    $0x25,%edi
  8028fc:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8028fe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802903:	eb 05                	jmp    80290a <vprintfmt+0x50c>
  802905:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80290a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80290e:	48 83 e8 01          	sub    $0x1,%rax
  802912:	0f b6 00             	movzbl (%rax),%eax
  802915:	3c 25                	cmp    $0x25,%al
  802917:	75 ec                	jne    802905 <vprintfmt+0x507>
				/* do nothing */;
			break;
  802919:	90                   	nop
		}
	}
  80291a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80291b:	e9 30 fb ff ff       	jmpq   802450 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802920:	48 83 c4 60          	add    $0x60,%rsp
  802924:	5b                   	pop    %rbx
  802925:	41 5c                	pop    %r12
  802927:	5d                   	pop    %rbp
  802928:	c3                   	retq   

0000000000802929 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802929:	55                   	push   %rbp
  80292a:	48 89 e5             	mov    %rsp,%rbp
  80292d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802934:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80293b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802942:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802949:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802950:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802957:	84 c0                	test   %al,%al
  802959:	74 20                	je     80297b <printfmt+0x52>
  80295b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80295f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802963:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802967:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80296b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80296f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802973:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802977:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80297b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802982:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802989:	00 00 00 
  80298c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802993:	00 00 00 
  802996:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80299a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029a1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029a8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029af:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029b6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029bd:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029c4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029cb:	48 89 c7             	mov    %rax,%rdi
  8029ce:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029da:	c9                   	leaveq 
  8029db:	c3                   	retq   

00000000008029dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029dc:	55                   	push   %rbp
  8029dd:	48 89 e5             	mov    %rsp,%rbp
  8029e0:	48 83 ec 10          	sub    $0x10,%rsp
  8029e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8029eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ef:	8b 40 10             	mov    0x10(%rax),%eax
  8029f2:	8d 50 01             	lea    0x1(%rax),%edx
  8029f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8029fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a00:	48 8b 10             	mov    (%rax),%rdx
  802a03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a07:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a0b:	48 39 c2             	cmp    %rax,%rdx
  802a0e:	73 17                	jae    802a27 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a14:	48 8b 00             	mov    (%rax),%rax
  802a17:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a1f:	48 89 0a             	mov    %rcx,(%rdx)
  802a22:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a25:	88 10                	mov    %dl,(%rax)
}
  802a27:	c9                   	leaveq 
  802a28:	c3                   	retq   

0000000000802a29 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a29:	55                   	push   %rbp
  802a2a:	48 89 e5             	mov    %rsp,%rbp
  802a2d:	48 83 ec 50          	sub    $0x50,%rsp
  802a31:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a35:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a38:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a3c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a40:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a44:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a48:	48 8b 0a             	mov    (%rdx),%rcx
  802a4b:	48 89 08             	mov    %rcx,(%rax)
  802a4e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a52:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a56:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a5a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a5e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a62:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a66:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a69:	48 98                	cltq   
  802a6b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a73:	48 01 d0             	add    %rdx,%rax
  802a76:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a7a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a81:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a86:	74 06                	je     802a8e <vsnprintf+0x65>
  802a88:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802a8c:	7f 07                	jg     802a95 <vsnprintf+0x6c>
		return -E_INVAL;
  802a8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a93:	eb 2f                	jmp    802ac4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802a95:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802a99:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a9d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802aa1:	48 89 c6             	mov    %rax,%rsi
  802aa4:	48 bf dc 29 80 00 00 	movabs $0x8029dc,%rdi
  802aab:	00 00 00 
  802aae:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802aba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802abe:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802ac1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802ac4:	c9                   	leaveq 
  802ac5:	c3                   	retq   

0000000000802ac6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802ac6:	55                   	push   %rbp
  802ac7:	48 89 e5             	mov    %rsp,%rbp
  802aca:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802ad1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802ad8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802ade:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ae5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802aec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802af3:	84 c0                	test   %al,%al
  802af5:	74 20                	je     802b17 <snprintf+0x51>
  802af7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802afb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802aff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b03:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b07:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b0b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b0f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b13:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b17:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b1e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b25:	00 00 00 
  802b28:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b2f:	00 00 00 
  802b32:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b36:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b3d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b44:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b4b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b52:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b59:	48 8b 0a             	mov    (%rdx),%rcx
  802b5c:	48 89 08             	mov    %rcx,(%rax)
  802b5f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b63:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b67:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b6b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b6f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b76:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b7d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b83:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b8a:	48 89 c7             	mov    %rax,%rdi
  802b8d:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  802b94:	00 00 00 
  802b97:	ff d0                	callq  *%rax
  802b99:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802b9f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ba5:	c9                   	leaveq 
  802ba6:	c3                   	retq   

0000000000802ba7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802ba7:	55                   	push   %rbp
  802ba8:	48 89 e5             	mov    %rsp,%rbp
  802bab:	48 83 ec 18          	sub    $0x18,%rsp
  802baf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bba:	eb 09                	jmp    802bc5 <strlen+0x1e>
		n++;
  802bbc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bc0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc9:	0f b6 00             	movzbl (%rax),%eax
  802bcc:	84 c0                	test   %al,%al
  802bce:	75 ec                	jne    802bbc <strlen+0x15>
		n++;
	return n;
  802bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd3:	c9                   	leaveq 
  802bd4:	c3                   	retq   

0000000000802bd5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802bd5:	55                   	push   %rbp
  802bd6:	48 89 e5             	mov    %rsp,%rbp
  802bd9:	48 83 ec 20          	sub    $0x20,%rsp
  802bdd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802be5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bec:	eb 0e                	jmp    802bfc <strnlen+0x27>
		n++;
  802bee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bf2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bf7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802bfc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c01:	74 0b                	je     802c0e <strnlen+0x39>
  802c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c07:	0f b6 00             	movzbl (%rax),%eax
  802c0a:	84 c0                	test   %al,%al
  802c0c:	75 e0                	jne    802bee <strnlen+0x19>
		n++;
	return n;
  802c0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c11:	c9                   	leaveq 
  802c12:	c3                   	retq   

0000000000802c13 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c13:	55                   	push   %rbp
  802c14:	48 89 e5             	mov    %rsp,%rbp
  802c17:	48 83 ec 20          	sub    $0x20,%rsp
  802c1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c2b:	90                   	nop
  802c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c30:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c34:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c38:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c3c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c40:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c44:	0f b6 12             	movzbl (%rdx),%edx
  802c47:	88 10                	mov    %dl,(%rax)
  802c49:	0f b6 00             	movzbl (%rax),%eax
  802c4c:	84 c0                	test   %al,%al
  802c4e:	75 dc                	jne    802c2c <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c54:	c9                   	leaveq 
  802c55:	c3                   	retq   

0000000000802c56 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c56:	55                   	push   %rbp
  802c57:	48 89 e5             	mov    %rsp,%rbp
  802c5a:	48 83 ec 20          	sub    $0x20,%rsp
  802c5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6a:	48 89 c7             	mov    %rax,%rdi
  802c6d:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7f:	48 63 d0             	movslq %eax,%rdx
  802c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c86:	48 01 c2             	add    %rax,%rdx
  802c89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c8d:	48 89 c6             	mov    %rax,%rsi
  802c90:	48 89 d7             	mov    %rdx,%rdi
  802c93:	48 b8 13 2c 80 00 00 	movabs $0x802c13,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
	return dst;
  802c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802ca3:	c9                   	leaveq 
  802ca4:	c3                   	retq   

0000000000802ca5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802ca5:	55                   	push   %rbp
  802ca6:	48 89 e5             	mov    %rsp,%rbp
  802ca9:	48 83 ec 28          	sub    $0x28,%rsp
  802cad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cb5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802cc1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802cc8:	00 
  802cc9:	eb 2a                	jmp    802cf5 <strncpy+0x50>
		*dst++ = *src;
  802ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cd3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cd7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cdb:	0f b6 12             	movzbl (%rdx),%edx
  802cde:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802ce0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce4:	0f b6 00             	movzbl (%rax),%eax
  802ce7:	84 c0                	test   %al,%al
  802ce9:	74 05                	je     802cf0 <strncpy+0x4b>
			src++;
  802ceb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802cf0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cf9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cfd:	72 cc                	jb     802ccb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d03:	c9                   	leaveq 
  802d04:	c3                   	retq   

0000000000802d05 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d05:	55                   	push   %rbp
  802d06:	48 89 e5             	mov    %rsp,%rbp
  802d09:	48 83 ec 28          	sub    $0x28,%rsp
  802d0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d15:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d21:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d26:	74 3d                	je     802d65 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d28:	eb 1d                	jmp    802d47 <strlcpy+0x42>
			*dst++ = *src++;
  802d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d32:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d36:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d3a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d3e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d42:	0f b6 12             	movzbl (%rdx),%edx
  802d45:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d47:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d4c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d51:	74 0b                	je     802d5e <strlcpy+0x59>
  802d53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d57:	0f b6 00             	movzbl (%rax),%eax
  802d5a:	84 c0                	test   %al,%al
  802d5c:	75 cc                	jne    802d2a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d62:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d6d:	48 29 c2             	sub    %rax,%rdx
  802d70:	48 89 d0             	mov    %rdx,%rax
}
  802d73:	c9                   	leaveq 
  802d74:	c3                   	retq   

0000000000802d75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d75:	55                   	push   %rbp
  802d76:	48 89 e5             	mov    %rsp,%rbp
  802d79:	48 83 ec 10          	sub    $0x10,%rsp
  802d7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d85:	eb 0a                	jmp    802d91 <strcmp+0x1c>
		p++, q++;
  802d87:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d8c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d95:	0f b6 00             	movzbl (%rax),%eax
  802d98:	84 c0                	test   %al,%al
  802d9a:	74 12                	je     802dae <strcmp+0x39>
  802d9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da0:	0f b6 10             	movzbl (%rax),%edx
  802da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da7:	0f b6 00             	movzbl (%rax),%eax
  802daa:	38 c2                	cmp    %al,%dl
  802dac:	74 d9                	je     802d87 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802dae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db2:	0f b6 00             	movzbl (%rax),%eax
  802db5:	0f b6 d0             	movzbl %al,%edx
  802db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbc:	0f b6 00             	movzbl (%rax),%eax
  802dbf:	0f b6 c0             	movzbl %al,%eax
  802dc2:	29 c2                	sub    %eax,%edx
  802dc4:	89 d0                	mov    %edx,%eax
}
  802dc6:	c9                   	leaveq 
  802dc7:	c3                   	retq   

0000000000802dc8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802dc8:	55                   	push   %rbp
  802dc9:	48 89 e5             	mov    %rsp,%rbp
  802dcc:	48 83 ec 18          	sub    $0x18,%rsp
  802dd0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dd4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dd8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802ddc:	eb 0f                	jmp    802ded <strncmp+0x25>
		n--, p++, q++;
  802dde:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802de3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802de8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802ded:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802df2:	74 1d                	je     802e11 <strncmp+0x49>
  802df4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df8:	0f b6 00             	movzbl (%rax),%eax
  802dfb:	84 c0                	test   %al,%al
  802dfd:	74 12                	je     802e11 <strncmp+0x49>
  802dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e03:	0f b6 10             	movzbl (%rax),%edx
  802e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0a:	0f b6 00             	movzbl (%rax),%eax
  802e0d:	38 c2                	cmp    %al,%dl
  802e0f:	74 cd                	je     802dde <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e11:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e16:	75 07                	jne    802e1f <strncmp+0x57>
		return 0;
  802e18:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1d:	eb 18                	jmp    802e37 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e23:	0f b6 00             	movzbl (%rax),%eax
  802e26:	0f b6 d0             	movzbl %al,%edx
  802e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2d:	0f b6 00             	movzbl (%rax),%eax
  802e30:	0f b6 c0             	movzbl %al,%eax
  802e33:	29 c2                	sub    %eax,%edx
  802e35:	89 d0                	mov    %edx,%eax
}
  802e37:	c9                   	leaveq 
  802e38:	c3                   	retq   

0000000000802e39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e39:	55                   	push   %rbp
  802e3a:	48 89 e5             	mov    %rsp,%rbp
  802e3d:	48 83 ec 0c          	sub    $0xc,%rsp
  802e41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e45:	89 f0                	mov    %esi,%eax
  802e47:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e4a:	eb 17                	jmp    802e63 <strchr+0x2a>
		if (*s == c)
  802e4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e50:	0f b6 00             	movzbl (%rax),%eax
  802e53:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e56:	75 06                	jne    802e5e <strchr+0x25>
			return (char *) s;
  802e58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e5c:	eb 15                	jmp    802e73 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e5e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e67:	0f b6 00             	movzbl (%rax),%eax
  802e6a:	84 c0                	test   %al,%al
  802e6c:	75 de                	jne    802e4c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e73:	c9                   	leaveq 
  802e74:	c3                   	retq   

0000000000802e75 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e75:	55                   	push   %rbp
  802e76:	48 89 e5             	mov    %rsp,%rbp
  802e79:	48 83 ec 0c          	sub    $0xc,%rsp
  802e7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e81:	89 f0                	mov    %esi,%eax
  802e83:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e86:	eb 13                	jmp    802e9b <strfind+0x26>
		if (*s == c)
  802e88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8c:	0f b6 00             	movzbl (%rax),%eax
  802e8f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e92:	75 02                	jne    802e96 <strfind+0x21>
			break;
  802e94:	eb 10                	jmp    802ea6 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802e96:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9f:	0f b6 00             	movzbl (%rax),%eax
  802ea2:	84 c0                	test   %al,%al
  802ea4:	75 e2                	jne    802e88 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802eaa:	c9                   	leaveq 
  802eab:	c3                   	retq   

0000000000802eac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802eac:	55                   	push   %rbp
  802ead:	48 89 e5             	mov    %rsp,%rbp
  802eb0:	48 83 ec 18          	sub    $0x18,%rsp
  802eb4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eb8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ebb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ebf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ec4:	75 06                	jne    802ecc <memset+0x20>
		return v;
  802ec6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eca:	eb 69                	jmp    802f35 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802ecc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed0:	83 e0 03             	and    $0x3,%eax
  802ed3:	48 85 c0             	test   %rax,%rax
  802ed6:	75 48                	jne    802f20 <memset+0x74>
  802ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802edc:	83 e0 03             	and    $0x3,%eax
  802edf:	48 85 c0             	test   %rax,%rax
  802ee2:	75 3c                	jne    802f20 <memset+0x74>
		c &= 0xFF;
  802ee4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802eeb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eee:	c1 e0 18             	shl    $0x18,%eax
  802ef1:	89 c2                	mov    %eax,%edx
  802ef3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ef6:	c1 e0 10             	shl    $0x10,%eax
  802ef9:	09 c2                	or     %eax,%edx
  802efb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802efe:	c1 e0 08             	shl    $0x8,%eax
  802f01:	09 d0                	or     %edx,%eax
  802f03:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0a:	48 c1 e8 02          	shr    $0x2,%rax
  802f0e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f11:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f15:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f18:	48 89 d7             	mov    %rdx,%rdi
  802f1b:	fc                   	cld    
  802f1c:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f1e:	eb 11                	jmp    802f31 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f20:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f24:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f27:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f2b:	48 89 d7             	mov    %rdx,%rdi
  802f2e:	fc                   	cld    
  802f2f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f35:	c9                   	leaveq 
  802f36:	c3                   	retq   

0000000000802f37 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f37:	55                   	push   %rbp
  802f38:	48 89 e5             	mov    %rsp,%rbp
  802f3b:	48 83 ec 28          	sub    $0x28,%rsp
  802f3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f47:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f57:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f63:	0f 83 88 00 00 00    	jae    802ff1 <memmove+0xba>
  802f69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f71:	48 01 d0             	add    %rdx,%rax
  802f74:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f78:	76 77                	jbe    802ff1 <memmove+0xba>
		s += n;
  802f7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f86:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8e:	83 e0 03             	and    $0x3,%eax
  802f91:	48 85 c0             	test   %rax,%rax
  802f94:	75 3b                	jne    802fd1 <memmove+0x9a>
  802f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9a:	83 e0 03             	and    $0x3,%eax
  802f9d:	48 85 c0             	test   %rax,%rax
  802fa0:	75 2f                	jne    802fd1 <memmove+0x9a>
  802fa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa6:	83 e0 03             	and    $0x3,%eax
  802fa9:	48 85 c0             	test   %rax,%rax
  802fac:	75 23                	jne    802fd1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb2:	48 83 e8 04          	sub    $0x4,%rax
  802fb6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fba:	48 83 ea 04          	sub    $0x4,%rdx
  802fbe:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fc2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fc6:	48 89 c7             	mov    %rax,%rdi
  802fc9:	48 89 d6             	mov    %rdx,%rsi
  802fcc:	fd                   	std    
  802fcd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fcf:	eb 1d                	jmp    802fee <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802fd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fdd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe5:	48 89 d7             	mov    %rdx,%rdi
  802fe8:	48 89 c1             	mov    %rax,%rcx
  802feb:	fd                   	std    
  802fec:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802fee:	fc                   	cld    
  802fef:	eb 57                	jmp    803048 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff5:	83 e0 03             	and    $0x3,%eax
  802ff8:	48 85 c0             	test   %rax,%rax
  802ffb:	75 36                	jne    803033 <memmove+0xfc>
  802ffd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803001:	83 e0 03             	and    $0x3,%eax
  803004:	48 85 c0             	test   %rax,%rax
  803007:	75 2a                	jne    803033 <memmove+0xfc>
  803009:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80300d:	83 e0 03             	and    $0x3,%eax
  803010:	48 85 c0             	test   %rax,%rax
  803013:	75 1e                	jne    803033 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803015:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803019:	48 c1 e8 02          	shr    $0x2,%rax
  80301d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803024:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803028:	48 89 c7             	mov    %rax,%rdi
  80302b:	48 89 d6             	mov    %rdx,%rsi
  80302e:	fc                   	cld    
  80302f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803031:	eb 15                	jmp    803048 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803037:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80303b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80303f:	48 89 c7             	mov    %rax,%rdi
  803042:	48 89 d6             	mov    %rdx,%rsi
  803045:	fc                   	cld    
  803046:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80304c:	c9                   	leaveq 
  80304d:	c3                   	retq   

000000000080304e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80304e:	55                   	push   %rbp
  80304f:	48 89 e5             	mov    %rsp,%rbp
  803052:	48 83 ec 18          	sub    $0x18,%rsp
  803056:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80305a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80305e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803062:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803066:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80306a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306e:	48 89 ce             	mov    %rcx,%rsi
  803071:	48 89 c7             	mov    %rax,%rdi
  803074:	48 b8 37 2f 80 00 00 	movabs $0x802f37,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
}
  803080:	c9                   	leaveq 
  803081:	c3                   	retq   

0000000000803082 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803082:	55                   	push   %rbp
  803083:	48 89 e5             	mov    %rsp,%rbp
  803086:	48 83 ec 28          	sub    $0x28,%rsp
  80308a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80308e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803092:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80309e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030a6:	eb 36                	jmp    8030de <memcmp+0x5c>
		if (*s1 != *s2)
  8030a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ac:	0f b6 10             	movzbl (%rax),%edx
  8030af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b3:	0f b6 00             	movzbl (%rax),%eax
  8030b6:	38 c2                	cmp    %al,%dl
  8030b8:	74 1a                	je     8030d4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030be:	0f b6 00             	movzbl (%rax),%eax
  8030c1:	0f b6 d0             	movzbl %al,%edx
  8030c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c8:	0f b6 00             	movzbl (%rax),%eax
  8030cb:	0f b6 c0             	movzbl %al,%eax
  8030ce:	29 c2                	sub    %eax,%edx
  8030d0:	89 d0                	mov    %edx,%eax
  8030d2:	eb 20                	jmp    8030f4 <memcmp+0x72>
		s1++, s2++;
  8030d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8030ea:	48 85 c0             	test   %rax,%rax
  8030ed:	75 b9                	jne    8030a8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8030ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f4:	c9                   	leaveq 
  8030f5:	c3                   	retq   

00000000008030f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8030f6:	55                   	push   %rbp
  8030f7:	48 89 e5             	mov    %rsp,%rbp
  8030fa:	48 83 ec 28          	sub    $0x28,%rsp
  8030fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803102:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803105:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803109:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80310d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803111:	48 01 d0             	add    %rdx,%rax
  803114:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803118:	eb 15                	jmp    80312f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80311a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311e:	0f b6 10             	movzbl (%rax),%edx
  803121:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803124:	38 c2                	cmp    %al,%dl
  803126:	75 02                	jne    80312a <memfind+0x34>
			break;
  803128:	eb 0f                	jmp    803139 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80312a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80312f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803133:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803137:	72 e1                	jb     80311a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80313d:	c9                   	leaveq 
  80313e:	c3                   	retq   

000000000080313f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80313f:	55                   	push   %rbp
  803140:	48 89 e5             	mov    %rsp,%rbp
  803143:	48 83 ec 34          	sub    $0x34,%rsp
  803147:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80314b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80314f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803159:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803160:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803161:	eb 05                	jmp    803168 <strtol+0x29>
		s++;
  803163:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316c:	0f b6 00             	movzbl (%rax),%eax
  80316f:	3c 20                	cmp    $0x20,%al
  803171:	74 f0                	je     803163 <strtol+0x24>
  803173:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803177:	0f b6 00             	movzbl (%rax),%eax
  80317a:	3c 09                	cmp    $0x9,%al
  80317c:	74 e5                	je     803163 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80317e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803182:	0f b6 00             	movzbl (%rax),%eax
  803185:	3c 2b                	cmp    $0x2b,%al
  803187:	75 07                	jne    803190 <strtol+0x51>
		s++;
  803189:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80318e:	eb 17                	jmp    8031a7 <strtol+0x68>
	else if (*s == '-')
  803190:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803194:	0f b6 00             	movzbl (%rax),%eax
  803197:	3c 2d                	cmp    $0x2d,%al
  803199:	75 0c                	jne    8031a7 <strtol+0x68>
		s++, neg = 1;
  80319b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031ab:	74 06                	je     8031b3 <strtol+0x74>
  8031ad:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031b1:	75 28                	jne    8031db <strtol+0x9c>
  8031b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b7:	0f b6 00             	movzbl (%rax),%eax
  8031ba:	3c 30                	cmp    $0x30,%al
  8031bc:	75 1d                	jne    8031db <strtol+0x9c>
  8031be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c2:	48 83 c0 01          	add    $0x1,%rax
  8031c6:	0f b6 00             	movzbl (%rax),%eax
  8031c9:	3c 78                	cmp    $0x78,%al
  8031cb:	75 0e                	jne    8031db <strtol+0x9c>
		s += 2, base = 16;
  8031cd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031d2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031d9:	eb 2c                	jmp    803207 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031db:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031df:	75 19                	jne    8031fa <strtol+0xbb>
  8031e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e5:	0f b6 00             	movzbl (%rax),%eax
  8031e8:	3c 30                	cmp    $0x30,%al
  8031ea:	75 0e                	jne    8031fa <strtol+0xbb>
		s++, base = 8;
  8031ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031f1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8031f8:	eb 0d                	jmp    803207 <strtol+0xc8>
	else if (base == 0)
  8031fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031fe:	75 07                	jne    803207 <strtol+0xc8>
		base = 10;
  803200:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803207:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320b:	0f b6 00             	movzbl (%rax),%eax
  80320e:	3c 2f                	cmp    $0x2f,%al
  803210:	7e 1d                	jle    80322f <strtol+0xf0>
  803212:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803216:	0f b6 00             	movzbl (%rax),%eax
  803219:	3c 39                	cmp    $0x39,%al
  80321b:	7f 12                	jg     80322f <strtol+0xf0>
			dig = *s - '0';
  80321d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803221:	0f b6 00             	movzbl (%rax),%eax
  803224:	0f be c0             	movsbl %al,%eax
  803227:	83 e8 30             	sub    $0x30,%eax
  80322a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80322d:	eb 4e                	jmp    80327d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80322f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803233:	0f b6 00             	movzbl (%rax),%eax
  803236:	3c 60                	cmp    $0x60,%al
  803238:	7e 1d                	jle    803257 <strtol+0x118>
  80323a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323e:	0f b6 00             	movzbl (%rax),%eax
  803241:	3c 7a                	cmp    $0x7a,%al
  803243:	7f 12                	jg     803257 <strtol+0x118>
			dig = *s - 'a' + 10;
  803245:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803249:	0f b6 00             	movzbl (%rax),%eax
  80324c:	0f be c0             	movsbl %al,%eax
  80324f:	83 e8 57             	sub    $0x57,%eax
  803252:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803255:	eb 26                	jmp    80327d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325b:	0f b6 00             	movzbl (%rax),%eax
  80325e:	3c 40                	cmp    $0x40,%al
  803260:	7e 48                	jle    8032aa <strtol+0x16b>
  803262:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803266:	0f b6 00             	movzbl (%rax),%eax
  803269:	3c 5a                	cmp    $0x5a,%al
  80326b:	7f 3d                	jg     8032aa <strtol+0x16b>
			dig = *s - 'A' + 10;
  80326d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803271:	0f b6 00             	movzbl (%rax),%eax
  803274:	0f be c0             	movsbl %al,%eax
  803277:	83 e8 37             	sub    $0x37,%eax
  80327a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80327d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803280:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803283:	7c 02                	jl     803287 <strtol+0x148>
			break;
  803285:	eb 23                	jmp    8032aa <strtol+0x16b>
		s++, val = (val * base) + dig;
  803287:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80328c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80328f:	48 98                	cltq   
  803291:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803296:	48 89 c2             	mov    %rax,%rdx
  803299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329c:	48 98                	cltq   
  80329e:	48 01 d0             	add    %rdx,%rax
  8032a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032a5:	e9 5d ff ff ff       	jmpq   803207 <strtol+0xc8>

	if (endptr)
  8032aa:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032af:	74 0b                	je     8032bc <strtol+0x17d>
		*endptr = (char *) s;
  8032b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032b9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c0:	74 09                	je     8032cb <strtol+0x18c>
  8032c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c6:	48 f7 d8             	neg    %rax
  8032c9:	eb 04                	jmp    8032cf <strtol+0x190>
  8032cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032cf:	c9                   	leaveq 
  8032d0:	c3                   	retq   

00000000008032d1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8032d1:	55                   	push   %rbp
  8032d2:	48 89 e5             	mov    %rsp,%rbp
  8032d5:	48 83 ec 30          	sub    $0x30,%rsp
  8032d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8032e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032e9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8032ed:	0f b6 00             	movzbl (%rax),%eax
  8032f0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8032f3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8032f7:	75 06                	jne    8032ff <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8032f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fd:	eb 6b                	jmp    80336a <strstr+0x99>

	len = strlen(str);
  8032ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803303:	48 89 c7             	mov    %rax,%rdi
  803306:	48 b8 a7 2b 80 00 00 	movabs $0x802ba7,%rax
  80330d:	00 00 00 
  803310:	ff d0                	callq  *%rax
  803312:	48 98                	cltq   
  803314:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803318:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803320:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803324:	0f b6 00             	movzbl (%rax),%eax
  803327:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80332a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80332e:	75 07                	jne    803337 <strstr+0x66>
				return (char *) 0;
  803330:	b8 00 00 00 00       	mov    $0x0,%eax
  803335:	eb 33                	jmp    80336a <strstr+0x99>
		} while (sc != c);
  803337:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80333b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80333e:	75 d8                	jne    803318 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803344:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803348:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334c:	48 89 ce             	mov    %rcx,%rsi
  80334f:	48 89 c7             	mov    %rax,%rdi
  803352:	48 b8 c8 2d 80 00 00 	movabs $0x802dc8,%rax
  803359:	00 00 00 
  80335c:	ff d0                	callq  *%rax
  80335e:	85 c0                	test   %eax,%eax
  803360:	75 b6                	jne    803318 <strstr+0x47>

	return (char *) (in - 1);
  803362:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803366:	48 83 e8 01          	sub    $0x1,%rax
}
  80336a:	c9                   	leaveq 
  80336b:	c3                   	retq   

000000000080336c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80336c:	55                   	push   %rbp
  80336d:	48 89 e5             	mov    %rsp,%rbp
  803370:	48 83 ec 30          	sub    $0x30,%rsp
  803374:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803378:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80337c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803380:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803385:	75 0e                	jne    803395 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803387:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80338e:	00 00 00 
  803391:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803395:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803399:	48 89 c7             	mov    %rax,%rdi
  80339c:	48 b8 09 05 80 00 00 	movabs $0x800509,%rax
  8033a3:	00 00 00 
  8033a6:	ff d0                	callq  *%rax
  8033a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033af:	79 27                	jns    8033d8 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033b6:	74 0a                	je     8033c2 <ipc_recv+0x56>
            *from_env_store = 0;
  8033b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033c2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033c7:	74 0a                	je     8033d3 <ipc_recv+0x67>
            *perm_store = 0;
  8033c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033cd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d6:	eb 53                	jmp    80342b <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033dd:	74 19                	je     8033f8 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033df:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033e6:	00 00 00 
  8033e9:	48 8b 00             	mov    (%rax),%rax
  8033ec:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8033f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f6:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8033f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033fd:	74 19                	je     803418 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8033ff:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803406:	00 00 00 
  803409:	48 8b 00             	mov    (%rax),%rax
  80340c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803416:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803418:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80341f:	00 00 00 
  803422:	48 8b 00             	mov    (%rax),%rax
  803425:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80342b:	c9                   	leaveq 
  80342c:	c3                   	retq   

000000000080342d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80342d:	55                   	push   %rbp
  80342e:	48 89 e5             	mov    %rsp,%rbp
  803431:	48 83 ec 30          	sub    $0x30,%rsp
  803435:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803438:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80343b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80343f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803442:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803447:	75 0e                	jne    803457 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803449:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803450:	00 00 00 
  803453:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803457:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80345a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80345d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803461:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803464:	89 c7                	mov    %eax,%edi
  803466:	48 b8 b4 04 80 00 00 	movabs $0x8004b4,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
  803472:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803475:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803479:	79 36                	jns    8034b1 <ipc_send+0x84>
  80347b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80347f:	74 30                	je     8034b1 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803484:	89 c1                	mov    %eax,%ecx
  803486:	48 ba 88 3c 80 00 00 	movabs $0x803c88,%rdx
  80348d:	00 00 00 
  803490:	be 49 00 00 00       	mov    $0x49,%esi
  803495:	48 bf 95 3c 80 00 00 	movabs $0x803c95,%rdi
  80349c:	00 00 00 
  80349f:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a4:	49 b8 12 1e 80 00 00 	movabs $0x801e12,%r8
  8034ab:	00 00 00 
  8034ae:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034b1:	48 b8 a2 02 80 00 00 	movabs $0x8002a2,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
    } while(r != 0);
  8034bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c1:	75 94                	jne    803457 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034c3:	c9                   	leaveq 
  8034c4:	c3                   	retq   

00000000008034c5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034c5:	55                   	push   %rbp
  8034c6:	48 89 e5             	mov    %rsp,%rbp
  8034c9:	48 83 ec 14          	sub    $0x14,%rsp
  8034cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034d7:	eb 5e                	jmp    803537 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034d9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034e0:	00 00 00 
  8034e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e6:	48 63 d0             	movslq %eax,%rdx
  8034e9:	48 89 d0             	mov    %rdx,%rax
  8034ec:	48 c1 e0 03          	shl    $0x3,%rax
  8034f0:	48 01 d0             	add    %rdx,%rax
  8034f3:	48 c1 e0 05          	shl    $0x5,%rax
  8034f7:	48 01 c8             	add    %rcx,%rax
  8034fa:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803500:	8b 00                	mov    (%rax),%eax
  803502:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803505:	75 2c                	jne    803533 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803507:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80350e:	00 00 00 
  803511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803514:	48 63 d0             	movslq %eax,%rdx
  803517:	48 89 d0             	mov    %rdx,%rax
  80351a:	48 c1 e0 03          	shl    $0x3,%rax
  80351e:	48 01 d0             	add    %rdx,%rax
  803521:	48 c1 e0 05          	shl    $0x5,%rax
  803525:	48 01 c8             	add    %rcx,%rax
  803528:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80352e:	8b 40 08             	mov    0x8(%rax),%eax
  803531:	eb 12                	jmp    803545 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803533:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803537:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80353e:	7e 99                	jle    8034d9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803545:	c9                   	leaveq 
  803546:	c3                   	retq   

0000000000803547 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803547:	55                   	push   %rbp
  803548:	48 89 e5             	mov    %rsp,%rbp
  80354b:	48 83 ec 18          	sub    $0x18,%rsp
  80354f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803557:	48 c1 e8 15          	shr    $0x15,%rax
  80355b:	48 89 c2             	mov    %rax,%rdx
  80355e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803565:	01 00 00 
  803568:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80356c:	83 e0 01             	and    $0x1,%eax
  80356f:	48 85 c0             	test   %rax,%rax
  803572:	75 07                	jne    80357b <pageref+0x34>
		return 0;
  803574:	b8 00 00 00 00       	mov    $0x0,%eax
  803579:	eb 53                	jmp    8035ce <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80357b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357f:	48 c1 e8 0c          	shr    $0xc,%rax
  803583:	48 89 c2             	mov    %rax,%rdx
  803586:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80358d:	01 00 00 
  803590:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803594:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80359c:	83 e0 01             	and    $0x1,%eax
  80359f:	48 85 c0             	test   %rax,%rax
  8035a2:	75 07                	jne    8035ab <pageref+0x64>
		return 0;
  8035a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a9:	eb 23                	jmp    8035ce <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035af:	48 c1 e8 0c          	shr    $0xc,%rax
  8035b3:	48 89 c2             	mov    %rax,%rdx
  8035b6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035bd:	00 00 00 
  8035c0:	48 c1 e2 04          	shl    $0x4,%rdx
  8035c4:	48 01 d0             	add    %rdx,%rax
  8035c7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035cb:	0f b7 c0             	movzwl %ax,%eax
}
  8035ce:	c9                   	leaveq 
  8035cf:	c3                   	retq   
