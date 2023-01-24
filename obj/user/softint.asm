
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
	envid_t id = sys_getenvid();
  800065:	48 b8 58 02 80 00 00 	movabs $0x800258,%rax
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
  80009a:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000a1:	00 00 00 
  8000a4:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ab:	7e 14                	jle    8000c1 <libmain+0x6b>
		binaryname = argv[0];
  8000ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000b1:	48 8b 10             	mov    (%rax),%rdx
  8000b4:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  8000eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8000f0:	48 b8 14 02 80 00 00 	movabs $0x800214,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	callq  *%rax
}
  8000fc:	5d                   	pop    %rbp
  8000fd:	c3                   	retq   

00000000008000fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000fe:	55                   	push   %rbp
  8000ff:	48 89 e5             	mov    %rsp,%rbp
  800102:	53                   	push   %rbx
  800103:	48 83 ec 48          	sub    $0x48,%rsp
  800107:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80010a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80010d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800111:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800115:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800119:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800120:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800124:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800128:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80012c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800130:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800134:	4c 89 c3             	mov    %r8,%rbx
  800137:	cd 30                	int    $0x30
  800139:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80013d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800141:	74 3e                	je     800181 <syscall+0x83>
  800143:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800148:	7e 37                	jle    800181 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80014a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80014e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800151:	49 89 d0             	mov    %rdx,%r8
  800154:	89 c1                	mov    %eax,%ecx
  800156:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  80015d:	00 00 00 
  800160:	be 23 00 00 00       	mov    $0x23,%esi
  800165:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  80016c:	00 00 00 
  80016f:	b8 00 00 00 00       	mov    $0x0,%eax
  800174:	49 b9 f7 04 80 00 00 	movabs $0x8004f7,%r9
  80017b:	00 00 00 
  80017e:	41 ff d1             	callq  *%r9

	return ret;
  800181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800185:	48 83 c4 48          	add    $0x48,%rsp
  800189:	5b                   	pop    %rbx
  80018a:	5d                   	pop    %rbp
  80018b:	c3                   	retq   

000000000080018c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80018c:	55                   	push   %rbp
  80018d:	48 89 e5             	mov    %rsp,%rbp
  800190:	48 83 ec 20          	sub    $0x20,%rsp
  800194:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800198:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80019c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ab:	00 
  8001ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b8:	48 89 d1             	mov    %rdx,%rcx
  8001bb:	48 89 c2             	mov    %rax,%rdx
  8001be:	be 00 00 00 00       	mov    $0x0,%esi
  8001c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c8:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax
}
  8001d4:	c9                   	leaveq 
  8001d5:	c3                   	retq   

00000000008001d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001d6:	55                   	push   %rbp
  8001d7:	48 89 e5             	mov    %rsp,%rbp
  8001da:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001e5:	00 
  8001e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fc:	be 00 00 00 00       	mov    $0x0,%esi
  800201:	bf 01 00 00 00       	mov    $0x1,%edi
  800206:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
}
  800212:	c9                   	leaveq 
  800213:	c3                   	retq   

0000000000800214 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800214:	55                   	push   %rbp
  800215:	48 89 e5             	mov    %rsp,%rbp
  800218:	48 83 ec 10          	sub    $0x10,%rsp
  80021c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80021f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800222:	48 98                	cltq   
  800224:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80022b:	00 
  80022c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800232:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800238:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023d:	48 89 c2             	mov    %rax,%rdx
  800240:	be 01 00 00 00       	mov    $0x1,%esi
  800245:	bf 03 00 00 00       	mov    $0x3,%edi
  80024a:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
}
  800256:	c9                   	leaveq 
  800257:	c3                   	retq   

0000000000800258 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800258:	55                   	push   %rbp
  800259:	48 89 e5             	mov    %rsp,%rbp
  80025c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800260:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800267:	00 
  800268:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80026e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800274:	b9 00 00 00 00       	mov    $0x0,%ecx
  800279:	ba 00 00 00 00       	mov    $0x0,%edx
  80027e:	be 00 00 00 00       	mov    $0x0,%esi
  800283:	bf 02 00 00 00       	mov    $0x2,%edi
  800288:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
}
  800294:	c9                   	leaveq 
  800295:	c3                   	retq   

0000000000800296 <sys_yield>:

void
sys_yield(void)
{
  800296:	55                   	push   %rbp
  800297:	48 89 e5             	mov    %rsp,%rbp
  80029a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80029e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002a5:	00 
  8002a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002bc:	be 00 00 00 00       	mov    $0x0,%esi
  8002c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002c6:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	callq  *%rax
}
  8002d2:	c9                   	leaveq 
  8002d3:	c3                   	retq   

00000000008002d4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002d4:	55                   	push   %rbp
  8002d5:	48 89 e5             	mov    %rsp,%rbp
  8002d8:	48 83 ec 20          	sub    $0x20,%rsp
  8002dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002e3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002e9:	48 63 c8             	movslq %eax,%rcx
  8002ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f3:	48 98                	cltq   
  8002f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002fc:	00 
  8002fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800303:	49 89 c8             	mov    %rcx,%r8
  800306:	48 89 d1             	mov    %rdx,%rcx
  800309:	48 89 c2             	mov    %rax,%rdx
  80030c:	be 01 00 00 00       	mov    $0x1,%esi
  800311:	bf 04 00 00 00       	mov    $0x4,%edi
  800316:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  80031d:	00 00 00 
  800320:	ff d0                	callq  *%rax
}
  800322:	c9                   	leaveq 
  800323:	c3                   	retq   

0000000000800324 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800324:	55                   	push   %rbp
  800325:	48 89 e5             	mov    %rsp,%rbp
  800328:	48 83 ec 30          	sub    $0x30,%rsp
  80032c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800333:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800336:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80033a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80033e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800341:	48 63 c8             	movslq %eax,%rcx
  800344:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800348:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80034b:	48 63 f0             	movslq %eax,%rsi
  80034e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800355:	48 98                	cltq   
  800357:	48 89 0c 24          	mov    %rcx,(%rsp)
  80035b:	49 89 f9             	mov    %rdi,%r9
  80035e:	49 89 f0             	mov    %rsi,%r8
  800361:	48 89 d1             	mov    %rdx,%rcx
  800364:	48 89 c2             	mov    %rax,%rdx
  800367:	be 01 00 00 00       	mov    $0x1,%esi
  80036c:	bf 05 00 00 00       	mov    $0x5,%edi
  800371:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  800378:	00 00 00 
  80037b:	ff d0                	callq  *%rax
}
  80037d:	c9                   	leaveq 
  80037e:	c3                   	retq   

000000000080037f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80037f:	55                   	push   %rbp
  800380:	48 89 e5             	mov    %rsp,%rbp
  800383:	48 83 ec 20          	sub    $0x20,%rsp
  800387:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80038a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80038e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800395:	48 98                	cltq   
  800397:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80039e:	00 
  80039f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003ab:	48 89 d1             	mov    %rdx,%rcx
  8003ae:	48 89 c2             	mov    %rax,%rdx
  8003b1:	be 01 00 00 00       	mov    $0x1,%esi
  8003b6:	bf 06 00 00 00       	mov    $0x6,%edi
  8003bb:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
}
  8003c7:	c9                   	leaveq 
  8003c8:	c3                   	retq   

00000000008003c9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003c9:	55                   	push   %rbp
  8003ca:	48 89 e5             	mov    %rsp,%rbp
  8003cd:	48 83 ec 10          	sub    $0x10,%rsp
  8003d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003d4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003da:	48 63 d0             	movslq %eax,%rdx
  8003dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e0:	48 98                	cltq   
  8003e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003e9:	00 
  8003ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003f6:	48 89 d1             	mov    %rdx,%rcx
  8003f9:	48 89 c2             	mov    %rax,%rdx
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	bf 08 00 00 00       	mov    $0x8,%edi
  800406:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  80040d:	00 00 00 
  800410:	ff d0                	callq  *%rax
}
  800412:	c9                   	leaveq 
  800413:	c3                   	retq   

0000000000800414 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 20          	sub    $0x20,%rsp
  80041c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800423:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800427:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042a:	48 98                	cltq   
  80042c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800433:	00 
  800434:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80043a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800440:	48 89 d1             	mov    %rdx,%rcx
  800443:	48 89 c2             	mov    %rax,%rdx
  800446:	be 01 00 00 00       	mov    $0x1,%esi
  80044b:	bf 09 00 00 00       	mov    $0x9,%edi
  800450:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  800457:	00 00 00 
  80045a:	ff d0                	callq  *%rax
}
  80045c:	c9                   	leaveq 
  80045d:	c3                   	retq   

000000000080045e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80045e:	55                   	push   %rbp
  80045f:	48 89 e5             	mov    %rsp,%rbp
  800462:	48 83 ec 20          	sub    $0x20,%rsp
  800466:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800469:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80046d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800471:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800474:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800477:	48 63 f0             	movslq %eax,%rsi
  80047a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80047e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800481:	48 98                	cltq   
  800483:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800487:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80048e:	00 
  80048f:	49 89 f1             	mov    %rsi,%r9
  800492:	49 89 c8             	mov    %rcx,%r8
  800495:	48 89 d1             	mov    %rdx,%rcx
  800498:	48 89 c2             	mov    %rax,%rdx
  80049b:	be 00 00 00 00       	mov    $0x0,%esi
  8004a0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004a5:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  8004ac:	00 00 00 
  8004af:	ff d0                	callq  *%rax
}
  8004b1:	c9                   	leaveq 
  8004b2:	c3                   	retq   

00000000008004b3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004b3:	55                   	push   %rbp
  8004b4:	48 89 e5             	mov    %rsp,%rbp
  8004b7:	48 83 ec 10          	sub    $0x10,%rsp
  8004bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ca:	00 
  8004cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004dc:	48 89 c2             	mov    %rax,%rdx
  8004df:	be 01 00 00 00       	mov    $0x1,%esi
  8004e4:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004e9:	48 b8 fe 00 80 00 00 	movabs $0x8000fe,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
}
  8004f5:	c9                   	leaveq 
  8004f6:	c3                   	retq   

00000000008004f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004f7:	55                   	push   %rbp
  8004f8:	48 89 e5             	mov    %rsp,%rbp
  8004fb:	53                   	push   %rbx
  8004fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800503:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80050a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800510:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800517:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80051e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800525:	84 c0                	test   %al,%al
  800527:	74 23                	je     80054c <_panic+0x55>
  800529:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800530:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800534:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800538:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80053c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800540:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800544:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800548:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80054c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800553:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80055a:	00 00 00 
  80055d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800564:	00 00 00 
  800567:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80056b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800572:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800579:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800580:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800587:	00 00 00 
  80058a:	48 8b 18             	mov    (%rax),%rbx
  80058d:	48 b8 58 02 80 00 00 	movabs $0x800258,%rax
  800594:	00 00 00 
  800597:	ff d0                	callq  *%rax
  800599:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80059f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005a6:	41 89 c8             	mov    %ecx,%r8d
  8005a9:	48 89 d1             	mov    %rdx,%rcx
  8005ac:	48 89 da             	mov    %rbx,%rdx
  8005af:	89 c6                	mov    %eax,%esi
  8005b1:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005b8:	00 00 00 
  8005bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c0:	49 b9 30 07 80 00 00 	movabs $0x800730,%r9
  8005c7:	00 00 00 
  8005ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005db:	48 89 d6             	mov    %rdx,%rsi
  8005de:	48 89 c7             	mov    %rax,%rdi
  8005e1:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  8005e8:	00 00 00 
  8005eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8005ed:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  8005f4:	00 00 00 
  8005f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fc:	48 ba 30 07 80 00 00 	movabs $0x800730,%rdx
  800603:	00 00 00 
  800606:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800608:	cc                   	int3   
  800609:	eb fd                	jmp    800608 <_panic+0x111>

000000000080060b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80060b:	55                   	push   %rbp
  80060c:	48 89 e5             	mov    %rsp,%rbp
  80060f:	48 83 ec 10          	sub    $0x10,%rsp
  800613:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800616:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80061a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80061e:	8b 00                	mov    (%rax),%eax
  800620:	8d 48 01             	lea    0x1(%rax),%ecx
  800623:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800627:	89 0a                	mov    %ecx,(%rdx)
  800629:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80062c:	89 d1                	mov    %edx,%ecx
  80062e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800632:	48 98                	cltq   
  800634:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800643:	75 2c                	jne    800671 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800649:	8b 00                	mov    (%rax),%eax
  80064b:	48 98                	cltq   
  80064d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800651:	48 83 c2 08          	add    $0x8,%rdx
  800655:	48 89 c6             	mov    %rax,%rsi
  800658:	48 89 d7             	mov    %rdx,%rdi
  80065b:	48 b8 8c 01 80 00 00 	movabs $0x80018c,%rax
  800662:	00 00 00 
  800665:	ff d0                	callq  *%rax
        b->idx = 0;
  800667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800671:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800675:	8b 40 04             	mov    0x4(%rax),%eax
  800678:	8d 50 01             	lea    0x1(%rax),%edx
  80067b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800682:	c9                   	leaveq 
  800683:	c3                   	retq   

0000000000800684 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800684:	55                   	push   %rbp
  800685:	48 89 e5             	mov    %rsp,%rbp
  800688:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80068f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800696:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80069d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006a4:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006ab:	48 8b 0a             	mov    (%rdx),%rcx
  8006ae:	48 89 08             	mov    %rcx,(%rax)
  8006b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006c8:	00 00 00 
    b.cnt = 0;
  8006cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006d2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006d5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006dc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006e3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006ea:	48 89 c6             	mov    %rax,%rsi
  8006ed:	48 bf 0b 06 80 00 00 	movabs $0x80060b,%rdi
  8006f4:	00 00 00 
  8006f7:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  8006fe:	00 00 00 
  800701:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800703:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800709:	48 98                	cltq   
  80070b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800712:	48 83 c2 08          	add    $0x8,%rdx
  800716:	48 89 c6             	mov    %rax,%rsi
  800719:	48 89 d7             	mov    %rdx,%rdi
  80071c:	48 b8 8c 01 80 00 00 	movabs $0x80018c,%rax
  800723:	00 00 00 
  800726:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800728:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80072e:	c9                   	leaveq 
  80072f:	c3                   	retq   

0000000000800730 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800730:	55                   	push   %rbp
  800731:	48 89 e5             	mov    %rsp,%rbp
  800734:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80073b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800742:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800749:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800750:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800757:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80075e:	84 c0                	test   %al,%al
  800760:	74 20                	je     800782 <cprintf+0x52>
  800762:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800766:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80076a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80076e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800772:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800776:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80077a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80077e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800782:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800789:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800790:	00 00 00 
  800793:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80079a:	00 00 00 
  80079d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007a8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007b6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007bd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007c4:	48 8b 0a             	mov    (%rdx),%rcx
  8007c7:	48 89 08             	mov    %rcx,(%rax)
  8007ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007da:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007e8:	48 89 d6             	mov    %rdx,%rsi
  8007eb:	48 89 c7             	mov    %rax,%rdi
  8007ee:	48 b8 84 06 80 00 00 	movabs $0x800684,%rax
  8007f5:	00 00 00 
  8007f8:	ff d0                	callq  *%rax
  8007fa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800800:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800806:	c9                   	leaveq 
  800807:	c3                   	retq   

0000000000800808 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800808:	55                   	push   %rbp
  800809:	48 89 e5             	mov    %rsp,%rbp
  80080c:	53                   	push   %rbx
  80080d:	48 83 ec 38          	sub    $0x38,%rsp
  800811:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800815:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800819:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80081d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800820:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800824:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800828:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80082b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80082f:	77 3b                	ja     80086c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800831:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800834:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800838:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80083b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80083f:	ba 00 00 00 00       	mov    $0x0,%edx
  800844:	48 f7 f3             	div    %rbx
  800847:	48 89 c2             	mov    %rax,%rdx
  80084a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80084d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800850:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800858:	41 89 f9             	mov    %edi,%r9d
  80085b:	48 89 c7             	mov    %rax,%rdi
  80085e:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800865:	00 00 00 
  800868:	ff d0                	callq  *%rax
  80086a:	eb 1e                	jmp    80088a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086c:	eb 12                	jmp    800880 <printnum+0x78>
			putch(padc, putdat);
  80086e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800872:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	48 89 ce             	mov    %rcx,%rsi
  80087c:	89 d7                	mov    %edx,%edi
  80087e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800880:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800884:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800888:	7f e4                	jg     80086e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80088d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800891:	ba 00 00 00 00       	mov    $0x0,%edx
  800896:	48 f7 f1             	div    %rcx
  800899:	48 89 d0             	mov    %rdx,%rax
  80089c:	48 ba 10 1c 80 00 00 	movabs $0x801c10,%rdx
  8008a3:	00 00 00 
  8008a6:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008aa:	0f be d0             	movsbl %al,%edx
  8008ad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b5:	48 89 ce             	mov    %rcx,%rsi
  8008b8:	89 d7                	mov    %edx,%edi
  8008ba:	ff d0                	callq  *%rax
}
  8008bc:	48 83 c4 38          	add    $0x38,%rsp
  8008c0:	5b                   	pop    %rbx
  8008c1:	5d                   	pop    %rbp
  8008c2:	c3                   	retq   

00000000008008c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c3:	55                   	push   %rbp
  8008c4:	48 89 e5             	mov    %rsp,%rbp
  8008c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008d6:	7e 52                	jle    80092a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dc:	8b 00                	mov    (%rax),%eax
  8008de:	83 f8 30             	cmp    $0x30,%eax
  8008e1:	73 24                	jae    800907 <getuint+0x44>
  8008e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ef:	8b 00                	mov    (%rax),%eax
  8008f1:	89 c0                	mov    %eax,%eax
  8008f3:	48 01 d0             	add    %rdx,%rax
  8008f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fa:	8b 12                	mov    (%rdx),%edx
  8008fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800903:	89 0a                	mov    %ecx,(%rdx)
  800905:	eb 17                	jmp    80091e <getuint+0x5b>
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80090f:	48 89 d0             	mov    %rdx,%rax
  800912:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800916:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091e:	48 8b 00             	mov    (%rax),%rax
  800921:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800925:	e9 a3 00 00 00       	jmpq   8009cd <getuint+0x10a>
	else if (lflag)
  80092a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80092e:	74 4f                	je     80097f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800934:	8b 00                	mov    (%rax),%eax
  800936:	83 f8 30             	cmp    $0x30,%eax
  800939:	73 24                	jae    80095f <getuint+0x9c>
  80093b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800947:	8b 00                	mov    (%rax),%eax
  800949:	89 c0                	mov    %eax,%eax
  80094b:	48 01 d0             	add    %rdx,%rax
  80094e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800952:	8b 12                	mov    (%rdx),%edx
  800954:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800957:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095b:	89 0a                	mov    %ecx,(%rdx)
  80095d:	eb 17                	jmp    800976 <getuint+0xb3>
  80095f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800963:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800967:	48 89 d0             	mov    %rdx,%rax
  80096a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80096e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800972:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800976:	48 8b 00             	mov    (%rax),%rax
  800979:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097d:	eb 4e                	jmp    8009cd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	8b 00                	mov    (%rax),%eax
  800985:	83 f8 30             	cmp    $0x30,%eax
  800988:	73 24                	jae    8009ae <getuint+0xeb>
  80098a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800996:	8b 00                	mov    (%rax),%eax
  800998:	89 c0                	mov    %eax,%eax
  80099a:	48 01 d0             	add    %rdx,%rax
  80099d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a1:	8b 12                	mov    (%rdx),%edx
  8009a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009aa:	89 0a                	mov    %ecx,(%rdx)
  8009ac:	eb 17                	jmp    8009c5 <getuint+0x102>
  8009ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009b6:	48 89 d0             	mov    %rdx,%rax
  8009b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c5:	8b 00                	mov    (%rax),%eax
  8009c7:	89 c0                	mov    %eax,%eax
  8009c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d1:	c9                   	leaveq 
  8009d2:	c3                   	retq   

00000000008009d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009d3:	55                   	push   %rbp
  8009d4:	48 89 e5             	mov    %rsp,%rbp
  8009d7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009e2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009e6:	7e 52                	jle    800a3a <getint+0x67>
		x=va_arg(*ap, long long);
  8009e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ec:	8b 00                	mov    (%rax),%eax
  8009ee:	83 f8 30             	cmp    $0x30,%eax
  8009f1:	73 24                	jae    800a17 <getint+0x44>
  8009f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ff:	8b 00                	mov    (%rax),%eax
  800a01:	89 c0                	mov    %eax,%eax
  800a03:	48 01 d0             	add    %rdx,%rax
  800a06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0a:	8b 12                	mov    (%rdx),%edx
  800a0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a13:	89 0a                	mov    %ecx,(%rdx)
  800a15:	eb 17                	jmp    800a2e <getint+0x5b>
  800a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a1f:	48 89 d0             	mov    %rdx,%rax
  800a22:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a2e:	48 8b 00             	mov    (%rax),%rax
  800a31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a35:	e9 a3 00 00 00       	jmpq   800add <getint+0x10a>
	else if (lflag)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a3e:	74 4f                	je     800a8f <getint+0xbc>
		x=va_arg(*ap, long);
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a44:	8b 00                	mov    (%rax),%eax
  800a46:	83 f8 30             	cmp    $0x30,%eax
  800a49:	73 24                	jae    800a6f <getint+0x9c>
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a57:	8b 00                	mov    (%rax),%eax
  800a59:	89 c0                	mov    %eax,%eax
  800a5b:	48 01 d0             	add    %rdx,%rax
  800a5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a62:	8b 12                	mov    (%rdx),%edx
  800a64:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	89 0a                	mov    %ecx,(%rdx)
  800a6d:	eb 17                	jmp    800a86 <getint+0xb3>
  800a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a73:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a77:	48 89 d0             	mov    %rdx,%rax
  800a7a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a82:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a86:	48 8b 00             	mov    (%rax),%rax
  800a89:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a8d:	eb 4e                	jmp    800add <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	8b 00                	mov    (%rax),%eax
  800a95:	83 f8 30             	cmp    $0x30,%eax
  800a98:	73 24                	jae    800abe <getint+0xeb>
  800a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa6:	8b 00                	mov    (%rax),%eax
  800aa8:	89 c0                	mov    %eax,%eax
  800aaa:	48 01 d0             	add    %rdx,%rax
  800aad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab1:	8b 12                	mov    (%rdx),%edx
  800ab3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aba:	89 0a                	mov    %ecx,(%rdx)
  800abc:	eb 17                	jmp    800ad5 <getint+0x102>
  800abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ac6:	48 89 d0             	mov    %rdx,%rax
  800ac9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800acd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad5:	8b 00                	mov    (%rax),%eax
  800ad7:	48 98                	cltq   
  800ad9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800add:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ae1:	c9                   	leaveq 
  800ae2:	c3                   	retq   

0000000000800ae3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ae3:	55                   	push   %rbp
  800ae4:	48 89 e5             	mov    %rsp,%rbp
  800ae7:	41 54                	push   %r12
  800ae9:	53                   	push   %rbx
  800aea:	48 83 ec 60          	sub    $0x60,%rsp
  800aee:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800af2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800af6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800afa:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800afe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b02:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b06:	48 8b 0a             	mov    (%rdx),%rcx
  800b09:	48 89 08             	mov    %rcx,(%rax)
  800b0c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b10:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b14:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b18:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1c:	eb 17                	jmp    800b35 <vprintfmt+0x52>
			if (ch == '\0')
  800b1e:	85 db                	test   %ebx,%ebx
  800b20:	0f 84 df 04 00 00    	je     801005 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800b26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2e:	48 89 d6             	mov    %rdx,%rsi
  800b31:	89 df                	mov    %ebx,%edi
  800b33:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b39:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b3d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b41:	0f b6 00             	movzbl (%rax),%eax
  800b44:	0f b6 d8             	movzbl %al,%ebx
  800b47:	83 fb 25             	cmp    $0x25,%ebx
  800b4a:	75 d2                	jne    800b1e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b4c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b50:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b57:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b65:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b6c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b70:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b74:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b78:	0f b6 00             	movzbl (%rax),%eax
  800b7b:	0f b6 d8             	movzbl %al,%ebx
  800b7e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b81:	83 f8 55             	cmp    $0x55,%eax
  800b84:	0f 87 47 04 00 00    	ja     800fd1 <vprintfmt+0x4ee>
  800b8a:	89 c0                	mov    %eax,%eax
  800b8c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b93:	00 
  800b94:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  800b9b:	00 00 00 
  800b9e:	48 01 d0             	add    %rdx,%rax
  800ba1:	48 8b 00             	mov    (%rax),%rax
  800ba4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ba6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800baa:	eb c0                	jmp    800b6c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bac:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bb0:	eb ba                	jmp    800b6c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bb9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bbc:	89 d0                	mov    %edx,%eax
  800bbe:	c1 e0 02             	shl    $0x2,%eax
  800bc1:	01 d0                	add    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d8                	add    %ebx,%eax
  800bc7:	83 e8 30             	sub    $0x30,%eax
  800bca:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bcd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd1:	0f b6 00             	movzbl (%rax),%eax
  800bd4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bda:	7e 0c                	jle    800be8 <vprintfmt+0x105>
  800bdc:	83 fb 39             	cmp    $0x39,%ebx
  800bdf:	7f 07                	jg     800be8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be6:	eb d1                	jmp    800bb9 <vprintfmt+0xd6>
			goto process_precision;
  800be8:	eb 58                	jmp    800c42 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bed:	83 f8 30             	cmp    $0x30,%eax
  800bf0:	73 17                	jae    800c09 <vprintfmt+0x126>
  800bf2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bf6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf9:	89 c0                	mov    %eax,%eax
  800bfb:	48 01 d0             	add    %rdx,%rax
  800bfe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c01:	83 c2 08             	add    $0x8,%edx
  800c04:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c07:	eb 0f                	jmp    800c18 <vprintfmt+0x135>
  800c09:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0d:	48 89 d0             	mov    %rdx,%rax
  800c10:	48 83 c2 08          	add    $0x8,%rdx
  800c14:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c18:	8b 00                	mov    (%rax),%eax
  800c1a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c1d:	eb 23                	jmp    800c42 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c23:	79 0c                	jns    800c31 <vprintfmt+0x14e>
				width = 0;
  800c25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c2c:	e9 3b ff ff ff       	jmpq   800b6c <vprintfmt+0x89>
  800c31:	e9 36 ff ff ff       	jmpq   800b6c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c36:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c3d:	e9 2a ff ff ff       	jmpq   800b6c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c42:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c46:	79 12                	jns    800c5a <vprintfmt+0x177>
				width = precision, precision = -1;
  800c48:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c4b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c4e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c55:	e9 12 ff ff ff       	jmpq   800b6c <vprintfmt+0x89>
  800c5a:	e9 0d ff ff ff       	jmpq   800b6c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c5f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c63:	e9 04 ff ff ff       	jmpq   800b6c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6b:	83 f8 30             	cmp    $0x30,%eax
  800c6e:	73 17                	jae    800c87 <vprintfmt+0x1a4>
  800c70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c77:	89 c0                	mov    %eax,%eax
  800c79:	48 01 d0             	add    %rdx,%rax
  800c7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7f:	83 c2 08             	add    $0x8,%edx
  800c82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c85:	eb 0f                	jmp    800c96 <vprintfmt+0x1b3>
  800c87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8b:	48 89 d0             	mov    %rdx,%rax
  800c8e:	48 83 c2 08          	add    $0x8,%rdx
  800c92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c96:	8b 10                	mov    (%rax),%edx
  800c98:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca0:	48 89 ce             	mov    %rcx,%rsi
  800ca3:	89 d7                	mov    %edx,%edi
  800ca5:	ff d0                	callq  *%rax
			break;
  800ca7:	e9 53 03 00 00       	jmpq   800fff <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800caf:	83 f8 30             	cmp    $0x30,%eax
  800cb2:	73 17                	jae    800ccb <vprintfmt+0x1e8>
  800cb4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbb:	89 c0                	mov    %eax,%eax
  800cbd:	48 01 d0             	add    %rdx,%rax
  800cc0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc3:	83 c2 08             	add    $0x8,%edx
  800cc6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc9:	eb 0f                	jmp    800cda <vprintfmt+0x1f7>
  800ccb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ccf:	48 89 d0             	mov    %rdx,%rax
  800cd2:	48 83 c2 08          	add    $0x8,%rdx
  800cd6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cda:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cdc:	85 db                	test   %ebx,%ebx
  800cde:	79 02                	jns    800ce2 <vprintfmt+0x1ff>
				err = -err;
  800ce0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ce2:	83 fb 15             	cmp    $0x15,%ebx
  800ce5:	7f 16                	jg     800cfd <vprintfmt+0x21a>
  800ce7:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800cee:	00 00 00 
  800cf1:	48 63 d3             	movslq %ebx,%rdx
  800cf4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cf8:	4d 85 e4             	test   %r12,%r12
  800cfb:	75 2e                	jne    800d2b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cfd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d05:	89 d9                	mov    %ebx,%ecx
  800d07:	48 ba 21 1c 80 00 00 	movabs $0x801c21,%rdx
  800d0e:	00 00 00 
  800d11:	48 89 c7             	mov    %rax,%rdi
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
  800d19:	49 b8 0e 10 80 00 00 	movabs $0x80100e,%r8
  800d20:	00 00 00 
  800d23:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d26:	e9 d4 02 00 00       	jmpq   800fff <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d2b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d33:	4c 89 e1             	mov    %r12,%rcx
  800d36:	48 ba 2a 1c 80 00 00 	movabs $0x801c2a,%rdx
  800d3d:	00 00 00 
  800d40:	48 89 c7             	mov    %rax,%rdi
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	49 b8 0e 10 80 00 00 	movabs $0x80100e,%r8
  800d4f:	00 00 00 
  800d52:	41 ff d0             	callq  *%r8
			break;
  800d55:	e9 a5 02 00 00       	jmpq   800fff <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5d:	83 f8 30             	cmp    $0x30,%eax
  800d60:	73 17                	jae    800d79 <vprintfmt+0x296>
  800d62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d69:	89 c0                	mov    %eax,%eax
  800d6b:	48 01 d0             	add    %rdx,%rax
  800d6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d71:	83 c2 08             	add    $0x8,%edx
  800d74:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d77:	eb 0f                	jmp    800d88 <vprintfmt+0x2a5>
  800d79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d7d:	48 89 d0             	mov    %rdx,%rax
  800d80:	48 83 c2 08          	add    $0x8,%rdx
  800d84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d88:	4c 8b 20             	mov    (%rax),%r12
  800d8b:	4d 85 e4             	test   %r12,%r12
  800d8e:	75 0a                	jne    800d9a <vprintfmt+0x2b7>
				p = "(null)";
  800d90:	49 bc 2d 1c 80 00 00 	movabs $0x801c2d,%r12
  800d97:	00 00 00 
			if (width > 0 && padc != '-')
  800d9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d9e:	7e 3f                	jle    800ddf <vprintfmt+0x2fc>
  800da0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800da4:	74 39                	je     800ddf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800da6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800da9:	48 98                	cltq   
  800dab:	48 89 c6             	mov    %rax,%rsi
  800dae:	4c 89 e7             	mov    %r12,%rdi
  800db1:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  800db8:	00 00 00 
  800dbb:	ff d0                	callq  *%rax
  800dbd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dc0:	eb 17                	jmp    800dd9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dc2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dc6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dce:	48 89 ce             	mov    %rcx,%rsi
  800dd1:	89 d7                	mov    %edx,%edi
  800dd3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ddd:	7f e3                	jg     800dc2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ddf:	eb 37                	jmp    800e18 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800de1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800de5:	74 1e                	je     800e05 <vprintfmt+0x322>
  800de7:	83 fb 1f             	cmp    $0x1f,%ebx
  800dea:	7e 05                	jle    800df1 <vprintfmt+0x30e>
  800dec:	83 fb 7e             	cmp    $0x7e,%ebx
  800def:	7e 14                	jle    800e05 <vprintfmt+0x322>
					putch('?', putdat);
  800df1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df9:	48 89 d6             	mov    %rdx,%rsi
  800dfc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e01:	ff d0                	callq  *%rax
  800e03:	eb 0f                	jmp    800e14 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0d:	48 89 d6             	mov    %rdx,%rsi
  800e10:	89 df                	mov    %ebx,%edi
  800e12:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e14:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e18:	4c 89 e0             	mov    %r12,%rax
  800e1b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e1f:	0f b6 00             	movzbl (%rax),%eax
  800e22:	0f be d8             	movsbl %al,%ebx
  800e25:	85 db                	test   %ebx,%ebx
  800e27:	74 10                	je     800e39 <vprintfmt+0x356>
  800e29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e2d:	78 b2                	js     800de1 <vprintfmt+0x2fe>
  800e2f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e37:	79 a8                	jns    800de1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e39:	eb 16                	jmp    800e51 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e43:	48 89 d6             	mov    %rdx,%rsi
  800e46:	bf 20 00 00 00       	mov    $0x20,%edi
  800e4b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e55:	7f e4                	jg     800e3b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e57:	e9 a3 01 00 00       	jmpq   800fff <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e5c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e60:	be 03 00 00 00       	mov    $0x3,%esi
  800e65:	48 89 c7             	mov    %rax,%rdi
  800e68:	48 b8 d3 09 80 00 00 	movabs $0x8009d3,%rax
  800e6f:	00 00 00 
  800e72:	ff d0                	callq  *%rax
  800e74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7c:	48 85 c0             	test   %rax,%rax
  800e7f:	79 1d                	jns    800e9e <vprintfmt+0x3bb>
				putch('-', putdat);
  800e81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e89:	48 89 d6             	mov    %rdx,%rsi
  800e8c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e91:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e97:	48 f7 d8             	neg    %rax
  800e9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea5:	e9 e8 00 00 00       	jmpq   800f92 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800eaa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eae:	be 03 00 00 00       	mov    $0x3,%esi
  800eb3:	48 89 c7             	mov    %rax,%rdi
  800eb6:	48 b8 c3 08 80 00 00 	movabs $0x8008c3,%rax
  800ebd:	00 00 00 
  800ec0:	ff d0                	callq  *%rax
  800ec2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ec6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ecd:	e9 c0 00 00 00       	jmpq   800f92 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eda:	48 89 d6             	mov    %rdx,%rsi
  800edd:	bf 58 00 00 00       	mov    $0x58,%edi
  800ee2:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ee4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eec:	48 89 d6             	mov    %rdx,%rsi
  800eef:	bf 58 00 00 00       	mov    $0x58,%edi
  800ef4:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ef6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efe:	48 89 d6             	mov    %rdx,%rsi
  800f01:	bf 58 00 00 00       	mov    $0x58,%edi
  800f06:	ff d0                	callq  *%rax
			break;
  800f08:	e9 f2 00 00 00       	jmpq   800fff <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f15:	48 89 d6             	mov    %rdx,%rsi
  800f18:	bf 30 00 00 00       	mov    $0x30,%edi
  800f1d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f27:	48 89 d6             	mov    %rdx,%rsi
  800f2a:	bf 78 00 00 00       	mov    $0x78,%edi
  800f2f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f34:	83 f8 30             	cmp    $0x30,%eax
  800f37:	73 17                	jae    800f50 <vprintfmt+0x46d>
  800f39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f40:	89 c0                	mov    %eax,%eax
  800f42:	48 01 d0             	add    %rdx,%rax
  800f45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f48:	83 c2 08             	add    $0x8,%edx
  800f4b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4e:	eb 0f                	jmp    800f5f <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f54:	48 89 d0             	mov    %rdx,%rax
  800f57:	48 83 c2 08          	add    $0x8,%rdx
  800f5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f5f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f66:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f6d:	eb 23                	jmp    800f92 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f73:	be 03 00 00 00       	mov    $0x3,%esi
  800f78:	48 89 c7             	mov    %rax,%rdi
  800f7b:	48 b8 c3 08 80 00 00 	movabs $0x8008c3,%rax
  800f82:	00 00 00 
  800f85:	ff d0                	callq  *%rax
  800f87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f8b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f92:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f97:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f9a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fa5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa9:	45 89 c1             	mov    %r8d,%r9d
  800fac:	41 89 f8             	mov    %edi,%r8d
  800faf:	48 89 c7             	mov    %rax,%rdi
  800fb2:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	callq  *%rax
			break;
  800fbe:	eb 3f                	jmp    800fff <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc8:	48 89 d6             	mov    %rdx,%rsi
  800fcb:	89 df                	mov    %ebx,%edi
  800fcd:	ff d0                	callq  *%rax
			break;
  800fcf:	eb 2e                	jmp    800fff <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd9:	48 89 d6             	mov    %rdx,%rsi
  800fdc:	bf 25 00 00 00       	mov    $0x25,%edi
  800fe1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fe3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fe8:	eb 05                	jmp    800fef <vprintfmt+0x50c>
  800fea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ff3:	48 83 e8 01          	sub    $0x1,%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	3c 25                	cmp    $0x25,%al
  800ffc:	75 ec                	jne    800fea <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ffe:	90                   	nop
		}
	}
  800fff:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801000:	e9 30 fb ff ff       	jmpq   800b35 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801005:	48 83 c4 60          	add    $0x60,%rsp
  801009:	5b                   	pop    %rbx
  80100a:	41 5c                	pop    %r12
  80100c:	5d                   	pop    %rbp
  80100d:	c3                   	retq   

000000000080100e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801019:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801020:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801027:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80102e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801035:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80103c:	84 c0                	test   %al,%al
  80103e:	74 20                	je     801060 <printfmt+0x52>
  801040:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801044:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801048:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80104c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801050:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801054:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801058:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80105c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801060:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801067:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80106e:	00 00 00 
  801071:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801078:	00 00 00 
  80107b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80107f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801086:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80108d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801094:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80109b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010a2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010a9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010b0:	48 89 c7             	mov    %rax,%rdi
  8010b3:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  8010ba:	00 00 00 
  8010bd:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010bf:	c9                   	leaveq 
  8010c0:	c3                   	retq   

00000000008010c1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c1:	55                   	push   %rbp
  8010c2:	48 89 e5             	mov    %rsp,%rbp
  8010c5:	48 83 ec 10          	sub    $0x10,%rsp
  8010c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d4:	8b 40 10             	mov    0x10(%rax),%eax
  8010d7:	8d 50 01             	lea    0x1(%rax),%edx
  8010da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010de:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e5:	48 8b 10             	mov    (%rax),%rdx
  8010e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ec:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010f0:	48 39 c2             	cmp    %rax,%rdx
  8010f3:	73 17                	jae    80110c <sprintputch+0x4b>
		*b->buf++ = ch;
  8010f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f9:	48 8b 00             	mov    (%rax),%rax
  8010fc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801100:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801104:	48 89 0a             	mov    %rcx,(%rdx)
  801107:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80110a:	88 10                	mov    %dl,(%rax)
}
  80110c:	c9                   	leaveq 
  80110d:	c3                   	retq   

000000000080110e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80110e:	55                   	push   %rbp
  80110f:	48 89 e5             	mov    %rsp,%rbp
  801112:	48 83 ec 50          	sub    $0x50,%rsp
  801116:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80111a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80111d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801121:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801125:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801129:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80112d:	48 8b 0a             	mov    (%rdx),%rcx
  801130:	48 89 08             	mov    %rcx,(%rax)
  801133:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801137:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80113f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801143:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801147:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80114b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80114e:	48 98                	cltq   
  801150:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801154:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801158:	48 01 d0             	add    %rdx,%rax
  80115b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80115f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801166:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80116b:	74 06                	je     801173 <vsnprintf+0x65>
  80116d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801171:	7f 07                	jg     80117a <vsnprintf+0x6c>
		return -E_INVAL;
  801173:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801178:	eb 2f                	jmp    8011a9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80117a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80117e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801182:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801186:	48 89 c6             	mov    %rax,%rsi
  801189:	48 bf c1 10 80 00 00 	movabs $0x8010c1,%rdi
  801190:	00 00 00 
  801193:	48 b8 e3 0a 80 00 00 	movabs $0x800ae3,%rax
  80119a:	00 00 00 
  80119d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80119f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011a3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011a6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011a9:	c9                   	leaveq 
  8011aa:	c3                   	retq   

00000000008011ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011ab:	55                   	push   %rbp
  8011ac:	48 89 e5             	mov    %rsp,%rbp
  8011af:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011bd:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011c3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011ca:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011d1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011d8:	84 c0                	test   %al,%al
  8011da:	74 20                	je     8011fc <snprintf+0x51>
  8011dc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011e0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011e4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011e8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011ec:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011f0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011f4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011f8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011fc:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801203:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80120a:	00 00 00 
  80120d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801214:	00 00 00 
  801217:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80121b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801222:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801229:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801230:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801237:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80123e:	48 8b 0a             	mov    (%rdx),%rcx
  801241:	48 89 08             	mov    %rcx,(%rax)
  801244:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801248:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80124c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801250:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801254:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80125b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801262:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801268:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80126f:	48 89 c7             	mov    %rax,%rdi
  801272:	48 b8 0e 11 80 00 00 	movabs $0x80110e,%rax
  801279:	00 00 00 
  80127c:	ff d0                	callq  *%rax
  80127e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801284:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80128a:	c9                   	leaveq 
  80128b:	c3                   	retq   

000000000080128c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 18          	sub    $0x18,%rsp
  801294:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80129f:	eb 09                	jmp    8012aa <strlen+0x1e>
		n++;
  8012a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	84 c0                	test   %al,%al
  8012b3:	75 ec                	jne    8012a1 <strlen+0x15>
		n++;
	return n;
  8012b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012b8:	c9                   	leaveq 
  8012b9:	c3                   	retq   

00000000008012ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012ba:	55                   	push   %rbp
  8012bb:	48 89 e5             	mov    %rsp,%rbp
  8012be:	48 83 ec 20          	sub    $0x20,%rsp
  8012c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012d1:	eb 0e                	jmp    8012e1 <strnlen+0x27>
		n++;
  8012d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012dc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012e6:	74 0b                	je     8012f3 <strnlen+0x39>
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	0f b6 00             	movzbl (%rax),%eax
  8012ef:	84 c0                	test   %al,%al
  8012f1:	75 e0                	jne    8012d3 <strnlen+0x19>
		n++;
	return n;
  8012f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012f6:	c9                   	leaveq 
  8012f7:	c3                   	retq   

00000000008012f8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012f8:	55                   	push   %rbp
  8012f9:	48 89 e5             	mov    %rsp,%rbp
  8012fc:	48 83 ec 20          	sub    $0x20,%rsp
  801300:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801304:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801310:	90                   	nop
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801319:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801321:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801325:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801329:	0f b6 12             	movzbl (%rdx),%edx
  80132c:	88 10                	mov    %dl,(%rax)
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	75 dc                	jne    801311 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801339:	c9                   	leaveq 
  80133a:	c3                   	retq   

000000000080133b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80133b:	55                   	push   %rbp
  80133c:	48 89 e5             	mov    %rsp,%rbp
  80133f:	48 83 ec 20          	sub    $0x20,%rsp
  801343:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801347:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134f:	48 89 c7             	mov    %rax,%rdi
  801352:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  801359:	00 00 00 
  80135c:	ff d0                	callq  *%rax
  80135e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801364:	48 63 d0             	movslq %eax,%rdx
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	48 01 c2             	add    %rax,%rdx
  80136e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801372:	48 89 c6             	mov    %rax,%rsi
  801375:	48 89 d7             	mov    %rdx,%rdi
  801378:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  80137f:	00 00 00 
  801382:	ff d0                	callq  *%rax
	return dst;
  801384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801388:	c9                   	leaveq 
  801389:	c3                   	retq   

000000000080138a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80138a:	55                   	push   %rbp
  80138b:	48 89 e5             	mov    %rsp,%rbp
  80138e:	48 83 ec 28          	sub    $0x28,%rsp
  801392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801396:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80139a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80139e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013a6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013ad:	00 
  8013ae:	eb 2a                	jmp    8013da <strncpy+0x50>
		*dst++ = *src;
  8013b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013c0:	0f b6 12             	movzbl (%rdx),%edx
  8013c3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	84 c0                	test   %al,%al
  8013ce:	74 05                	je     8013d5 <strncpy+0x4b>
			src++;
  8013d0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013e2:	72 cc                	jb     8013b0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013e8:	c9                   	leaveq 
  8013e9:	c3                   	retq   

00000000008013ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013ea:	55                   	push   %rbp
  8013eb:	48 89 e5             	mov    %rsp,%rbp
  8013ee:	48 83 ec 28          	sub    $0x28,%rsp
  8013f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801402:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801406:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80140b:	74 3d                	je     80144a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80140d:	eb 1d                	jmp    80142c <strlcpy+0x42>
			*dst++ = *src++;
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801413:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801417:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80141b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80141f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801423:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801427:	0f b6 12             	movzbl (%rdx),%edx
  80142a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80142c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801431:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801436:	74 0b                	je     801443 <strlcpy+0x59>
  801438:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	84 c0                	test   %al,%al
  801441:	75 cc                	jne    80140f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801447:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80144a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	48 29 c2             	sub    %rax,%rdx
  801455:	48 89 d0             	mov    %rdx,%rax
}
  801458:	c9                   	leaveq 
  801459:	c3                   	retq   

000000000080145a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
  80145e:	48 83 ec 10          	sub    $0x10,%rsp
  801462:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801466:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80146a:	eb 0a                	jmp    801476 <strcmp+0x1c>
		p++, q++;
  80146c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801471:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147a:	0f b6 00             	movzbl (%rax),%eax
  80147d:	84 c0                	test   %al,%al
  80147f:	74 12                	je     801493 <strcmp+0x39>
  801481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801485:	0f b6 10             	movzbl (%rax),%edx
  801488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	38 c2                	cmp    %al,%dl
  801491:	74 d9                	je     80146c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	0f b6 d0             	movzbl %al,%edx
  80149d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	0f b6 c0             	movzbl %al,%eax
  8014a7:	29 c2                	sub    %eax,%edx
  8014a9:	89 d0                	mov    %edx,%eax
}
  8014ab:	c9                   	leaveq 
  8014ac:	c3                   	retq   

00000000008014ad <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014ad:	55                   	push   %rbp
  8014ae:	48 89 e5             	mov    %rsp,%rbp
  8014b1:	48 83 ec 18          	sub    $0x18,%rsp
  8014b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014c1:	eb 0f                	jmp    8014d2 <strncmp+0x25>
		n--, p++, q++;
  8014c3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014cd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d7:	74 1d                	je     8014f6 <strncmp+0x49>
  8014d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	84 c0                	test   %al,%al
  8014e2:	74 12                	je     8014f6 <strncmp+0x49>
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	0f b6 10             	movzbl (%rax),%edx
  8014eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ef:	0f b6 00             	movzbl (%rax),%eax
  8014f2:	38 c2                	cmp    %al,%dl
  8014f4:	74 cd                	je     8014c3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014fb:	75 07                	jne    801504 <strncmp+0x57>
		return 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	eb 18                	jmp    80151c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	0f b6 d0             	movzbl %al,%edx
  80150e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	0f b6 c0             	movzbl %al,%eax
  801518:	29 c2                	sub    %eax,%edx
  80151a:	89 d0                	mov    %edx,%eax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 0c          	sub    $0xc,%rsp
  801526:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152a:	89 f0                	mov    %esi,%eax
  80152c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80152f:	eb 17                	jmp    801548 <strchr+0x2a>
		if (*s == c)
  801531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80153b:	75 06                	jne    801543 <strchr+0x25>
			return (char *) s;
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	eb 15                	jmp    801558 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801543:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	84 c0                	test   %al,%al
  801551:	75 de                	jne    801531 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801558:	c9                   	leaveq 
  801559:	c3                   	retq   

000000000080155a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80155a:	55                   	push   %rbp
  80155b:	48 89 e5             	mov    %rsp,%rbp
  80155e:	48 83 ec 0c          	sub    $0xc,%rsp
  801562:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801566:	89 f0                	mov    %esi,%eax
  801568:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80156b:	eb 13                	jmp    801580 <strfind+0x26>
		if (*s == c)
  80156d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801571:	0f b6 00             	movzbl (%rax),%eax
  801574:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801577:	75 02                	jne    80157b <strfind+0x21>
			break;
  801579:	eb 10                	jmp    80158b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80157b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	84 c0                	test   %al,%al
  801589:	75 e2                	jne    80156d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80158b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158f:	c9                   	leaveq 
  801590:	c3                   	retq   

0000000000801591 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801591:	55                   	push   %rbp
  801592:	48 89 e5             	mov    %rsp,%rbp
  801595:	48 83 ec 18          	sub    $0x18,%rsp
  801599:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a9:	75 06                	jne    8015b1 <memset+0x20>
		return v;
  8015ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015af:	eb 69                	jmp    80161a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b5:	83 e0 03             	and    $0x3,%eax
  8015b8:	48 85 c0             	test   %rax,%rax
  8015bb:	75 48                	jne    801605 <memset+0x74>
  8015bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c1:	83 e0 03             	and    $0x3,%eax
  8015c4:	48 85 c0             	test   %rax,%rax
  8015c7:	75 3c                	jne    801605 <memset+0x74>
		c &= 0xFF;
  8015c9:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d3:	c1 e0 18             	shl    $0x18,%eax
  8015d6:	89 c2                	mov    %eax,%edx
  8015d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015db:	c1 e0 10             	shl    $0x10,%eax
  8015de:	09 c2                	or     %eax,%edx
  8015e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e3:	c1 e0 08             	shl    $0x8,%eax
  8015e6:	09 d0                	or     %edx,%eax
  8015e8:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ef:	48 c1 e8 02          	shr    $0x2,%rax
  8015f3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fd:	48 89 d7             	mov    %rdx,%rdi
  801600:	fc                   	cld    
  801601:	f3 ab                	rep stos %eax,%es:(%rdi)
  801603:	eb 11                	jmp    801616 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801605:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801609:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801610:	48 89 d7             	mov    %rdx,%rdi
  801613:	fc                   	cld    
  801614:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80161a:	c9                   	leaveq 
  80161b:	c3                   	retq   

000000000080161c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80161c:	55                   	push   %rbp
  80161d:	48 89 e5             	mov    %rsp,%rbp
  801620:	48 83 ec 28          	sub    $0x28,%rsp
  801624:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801628:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80162c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801630:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801634:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801644:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801648:	0f 83 88 00 00 00    	jae    8016d6 <memmove+0xba>
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801656:	48 01 d0             	add    %rdx,%rax
  801659:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80165d:	76 77                	jbe    8016d6 <memmove+0xba>
		s += n;
  80165f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801663:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80166f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801673:	83 e0 03             	and    $0x3,%eax
  801676:	48 85 c0             	test   %rax,%rax
  801679:	75 3b                	jne    8016b6 <memmove+0x9a>
  80167b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167f:	83 e0 03             	and    $0x3,%eax
  801682:	48 85 c0             	test   %rax,%rax
  801685:	75 2f                	jne    8016b6 <memmove+0x9a>
  801687:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168b:	83 e0 03             	and    $0x3,%eax
  80168e:	48 85 c0             	test   %rax,%rax
  801691:	75 23                	jne    8016b6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801697:	48 83 e8 04          	sub    $0x4,%rax
  80169b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169f:	48 83 ea 04          	sub    $0x4,%rdx
  8016a3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016a7:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016ab:	48 89 c7             	mov    %rax,%rdi
  8016ae:	48 89 d6             	mov    %rdx,%rsi
  8016b1:	fd                   	std    
  8016b2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016b4:	eb 1d                	jmp    8016d3 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c2:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	48 89 d7             	mov    %rdx,%rdi
  8016cd:	48 89 c1             	mov    %rax,%rcx
  8016d0:	fd                   	std    
  8016d1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016d3:	fc                   	cld    
  8016d4:	eb 57                	jmp    80172d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016da:	83 e0 03             	and    $0x3,%eax
  8016dd:	48 85 c0             	test   %rax,%rax
  8016e0:	75 36                	jne    801718 <memmove+0xfc>
  8016e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e6:	83 e0 03             	and    $0x3,%eax
  8016e9:	48 85 c0             	test   %rax,%rax
  8016ec:	75 2a                	jne    801718 <memmove+0xfc>
  8016ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f2:	83 e0 03             	and    $0x3,%eax
  8016f5:	48 85 c0             	test   %rax,%rax
  8016f8:	75 1e                	jne    801718 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fe:	48 c1 e8 02          	shr    $0x2,%rax
  801702:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801709:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170d:	48 89 c7             	mov    %rax,%rdi
  801710:	48 89 d6             	mov    %rdx,%rsi
  801713:	fc                   	cld    
  801714:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801716:	eb 15                	jmp    80172d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801720:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801724:	48 89 c7             	mov    %rax,%rdi
  801727:	48 89 d6             	mov    %rdx,%rsi
  80172a:	fc                   	cld    
  80172b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80172d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801731:	c9                   	leaveq 
  801732:	c3                   	retq   

0000000000801733 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801733:	55                   	push   %rbp
  801734:	48 89 e5             	mov    %rsp,%rbp
  801737:	48 83 ec 18          	sub    $0x18,%rsp
  80173b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80173f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801743:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80174b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80174f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801753:	48 89 ce             	mov    %rcx,%rsi
  801756:	48 89 c7             	mov    %rax,%rdi
  801759:	48 b8 1c 16 80 00 00 	movabs $0x80161c,%rax
  801760:	00 00 00 
  801763:	ff d0                	callq  *%rax
}
  801765:	c9                   	leaveq 
  801766:	c3                   	retq   

0000000000801767 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801767:	55                   	push   %rbp
  801768:	48 89 e5             	mov    %rsp,%rbp
  80176b:	48 83 ec 28          	sub    $0x28,%rsp
  80176f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801773:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801777:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80177b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801783:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801787:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80178b:	eb 36                	jmp    8017c3 <memcmp+0x5c>
		if (*s1 != *s2)
  80178d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801791:	0f b6 10             	movzbl (%rax),%edx
  801794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801798:	0f b6 00             	movzbl (%rax),%eax
  80179b:	38 c2                	cmp    %al,%dl
  80179d:	74 1a                	je     8017b9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80179f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a3:	0f b6 00             	movzbl (%rax),%eax
  8017a6:	0f b6 d0             	movzbl %al,%edx
  8017a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	0f b6 c0             	movzbl %al,%eax
  8017b3:	29 c2                	sub    %eax,%edx
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	eb 20                	jmp    8017d9 <memcmp+0x72>
		s1++, s2++;
  8017b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017cf:	48 85 c0             	test   %rax,%rax
  8017d2:	75 b9                	jne    80178d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d9:	c9                   	leaveq 
  8017da:	c3                   	retq   

00000000008017db <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017db:	55                   	push   %rbp
  8017dc:	48 89 e5             	mov    %rsp,%rbp
  8017df:	48 83 ec 28          	sub    $0x28,%rsp
  8017e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f6:	48 01 d0             	add    %rdx,%rax
  8017f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017fd:	eb 15                	jmp    801814 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801803:	0f b6 10             	movzbl (%rax),%edx
  801806:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801809:	38 c2                	cmp    %al,%dl
  80180b:	75 02                	jne    80180f <memfind+0x34>
			break;
  80180d:	eb 0f                	jmp    80181e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80180f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801818:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80181c:	72 e1                	jb     8017ff <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80181e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801822:	c9                   	leaveq 
  801823:	c3                   	retq   

0000000000801824 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	48 83 ec 34          	sub    $0x34,%rsp
  80182c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801830:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801834:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80183e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801845:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801846:	eb 05                	jmp    80184d <strtol+0x29>
		s++;
  801848:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801851:	0f b6 00             	movzbl (%rax),%eax
  801854:	3c 20                	cmp    $0x20,%al
  801856:	74 f0                	je     801848 <strtol+0x24>
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	3c 09                	cmp    $0x9,%al
  801861:	74 e5                	je     801848 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	0f b6 00             	movzbl (%rax),%eax
  80186a:	3c 2b                	cmp    $0x2b,%al
  80186c:	75 07                	jne    801875 <strtol+0x51>
		s++;
  80186e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801873:	eb 17                	jmp    80188c <strtol+0x68>
	else if (*s == '-')
  801875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801879:	0f b6 00             	movzbl (%rax),%eax
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0c                	jne    80188c <strtol+0x68>
		s++, neg = 1;
  801880:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801885:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801890:	74 06                	je     801898 <strtol+0x74>
  801892:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801896:	75 28                	jne    8018c0 <strtol+0x9c>
  801898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189c:	0f b6 00             	movzbl (%rax),%eax
  80189f:	3c 30                	cmp    $0x30,%al
  8018a1:	75 1d                	jne    8018c0 <strtol+0x9c>
  8018a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a7:	48 83 c0 01          	add    $0x1,%rax
  8018ab:	0f b6 00             	movzbl (%rax),%eax
  8018ae:	3c 78                	cmp    $0x78,%al
  8018b0:	75 0e                	jne    8018c0 <strtol+0x9c>
		s += 2, base = 16;
  8018b2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018b7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018be:	eb 2c                	jmp    8018ec <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c4:	75 19                	jne    8018df <strtol+0xbb>
  8018c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ca:	0f b6 00             	movzbl (%rax),%eax
  8018cd:	3c 30                	cmp    $0x30,%al
  8018cf:	75 0e                	jne    8018df <strtol+0xbb>
		s++, base = 8;
  8018d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018dd:	eb 0d                	jmp    8018ec <strtol+0xc8>
	else if (base == 0)
  8018df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e3:	75 07                	jne    8018ec <strtol+0xc8>
		base = 10;
  8018e5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	0f b6 00             	movzbl (%rax),%eax
  8018f3:	3c 2f                	cmp    $0x2f,%al
  8018f5:	7e 1d                	jle    801914 <strtol+0xf0>
  8018f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fb:	0f b6 00             	movzbl (%rax),%eax
  8018fe:	3c 39                	cmp    $0x39,%al
  801900:	7f 12                	jg     801914 <strtol+0xf0>
			dig = *s - '0';
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	0f be c0             	movsbl %al,%eax
  80190c:	83 e8 30             	sub    $0x30,%eax
  80190f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801912:	eb 4e                	jmp    801962 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801914:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801918:	0f b6 00             	movzbl (%rax),%eax
  80191b:	3c 60                	cmp    $0x60,%al
  80191d:	7e 1d                	jle    80193c <strtol+0x118>
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	3c 7a                	cmp    $0x7a,%al
  801928:	7f 12                	jg     80193c <strtol+0x118>
			dig = *s - 'a' + 10;
  80192a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192e:	0f b6 00             	movzbl (%rax),%eax
  801931:	0f be c0             	movsbl %al,%eax
  801934:	83 e8 57             	sub    $0x57,%eax
  801937:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80193a:	eb 26                	jmp    801962 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80193c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801940:	0f b6 00             	movzbl (%rax),%eax
  801943:	3c 40                	cmp    $0x40,%al
  801945:	7e 48                	jle    80198f <strtol+0x16b>
  801947:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194b:	0f b6 00             	movzbl (%rax),%eax
  80194e:	3c 5a                	cmp    $0x5a,%al
  801950:	7f 3d                	jg     80198f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801952:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801956:	0f b6 00             	movzbl (%rax),%eax
  801959:	0f be c0             	movsbl %al,%eax
  80195c:	83 e8 37             	sub    $0x37,%eax
  80195f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801962:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801965:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801968:	7c 02                	jl     80196c <strtol+0x148>
			break;
  80196a:	eb 23                	jmp    80198f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80196c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801971:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801974:	48 98                	cltq   
  801976:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80197b:	48 89 c2             	mov    %rax,%rdx
  80197e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801981:	48 98                	cltq   
  801983:	48 01 d0             	add    %rdx,%rax
  801986:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80198a:	e9 5d ff ff ff       	jmpq   8018ec <strtol+0xc8>

	if (endptr)
  80198f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801994:	74 0b                	je     8019a1 <strtol+0x17d>
		*endptr = (char *) s;
  801996:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80199a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80199e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a5:	74 09                	je     8019b0 <strtol+0x18c>
  8019a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ab:	48 f7 d8             	neg    %rax
  8019ae:	eb 04                	jmp    8019b4 <strtol+0x190>
  8019b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019b4:	c9                   	leaveq 
  8019b5:	c3                   	retq   

00000000008019b6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019b6:	55                   	push   %rbp
  8019b7:	48 89 e5             	mov    %rsp,%rbp
  8019ba:	48 83 ec 30          	sub    $0x30,%rsp
  8019be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ce:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019d2:	0f b6 00             	movzbl (%rax),%eax
  8019d5:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019d8:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019dc:	75 06                	jne    8019e4 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	eb 6b                	jmp    801a4f <strstr+0x99>

	len = strlen(str);
  8019e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e8:	48 89 c7             	mov    %rax,%rdi
  8019eb:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  8019f2:	00 00 00 
  8019f5:	ff d0                	callq  *%rax
  8019f7:	48 98                	cltq   
  8019f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a01:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a05:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a09:	0f b6 00             	movzbl (%rax),%eax
  801a0c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a0f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a13:	75 07                	jne    801a1c <strstr+0x66>
				return (char *) 0;
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	eb 33                	jmp    801a4f <strstr+0x99>
		} while (sc != c);
  801a1c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a20:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a23:	75 d8                	jne    8019fd <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a29:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	48 89 ce             	mov    %rcx,%rsi
  801a34:	48 89 c7             	mov    %rax,%rdi
  801a37:	48 b8 ad 14 80 00 00 	movabs $0x8014ad,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	75 b6                	jne    8019fd <strstr+0x47>

	return (char *) (in - 1);
  801a47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4b:	48 83 e8 01          	sub    $0x1,%rax
}
  801a4f:	c9                   	leaveq 
  801a50:	c3                   	retq   
