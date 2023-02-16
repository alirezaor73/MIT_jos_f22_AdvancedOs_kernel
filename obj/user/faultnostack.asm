
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
  800052:	48 be 71 05 80 00 00 	movabs $0x800571,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 8e 04 80 00 00 	movabs $0x80048e,%rax
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800089:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
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
  8000be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c5:	00 00 00 
  8000c8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cf:	7e 14                	jle    8000e5 <libmain+0x6b>
		binaryname = argv[0];
  8000d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d5:	48 8b 10             	mov    (%rax),%rdx
  8000d8:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
	close_all();
  80010f:	48 b8 39 09 80 00 00 	movabs $0x800939,%rax
  800116:	00 00 00 
  800119:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80011b:	bf 00 00 00 00       	mov    $0x0,%edi
  800120:	48 b8 44 02 80 00 00 	movabs $0x800244,%rax
  800127:	00 00 00 
  80012a:	ff d0                	callq  *%rax
}
  80012c:	5d                   	pop    %rbp
  80012d:	c3                   	retq   

000000000080012e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80012e:	55                   	push   %rbp
  80012f:	48 89 e5             	mov    %rsp,%rbp
  800132:	53                   	push   %rbx
  800133:	48 83 ec 48          	sub    $0x48,%rsp
  800137:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80013d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800141:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800145:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800149:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80014d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800150:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800154:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800158:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80015c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800160:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800164:	4c 89 c3             	mov    %r8,%rbx
  800167:	cd 30                	int    $0x30
  800169:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80016d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800171:	74 3e                	je     8001b1 <syscall+0x83>
  800173:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800178:	7e 37                	jle    8001b1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80017a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80017e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800181:	49 89 d0             	mov    %rdx,%r8
  800184:	89 c1                	mov    %eax,%ecx
  800186:	48 ba 4a 37 80 00 00 	movabs $0x80374a,%rdx
  80018d:	00 00 00 
  800190:	be 23 00 00 00       	mov    $0x23,%esi
  800195:	48 bf 67 37 80 00 00 	movabs $0x803767,%rdi
  80019c:	00 00 00 
  80019f:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a4:	49 b9 bd 1e 80 00 00 	movabs $0x801ebd,%r9
  8001ab:	00 00 00 
  8001ae:	41 ff d1             	callq  *%r9

	return ret;
  8001b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b5:	48 83 c4 48          	add    $0x48,%rsp
  8001b9:	5b                   	pop    %rbx
  8001ba:	5d                   	pop    %rbp
  8001bb:	c3                   	retq   

00000000008001bc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001bc:	55                   	push   %rbp
  8001bd:	48 89 e5             	mov    %rsp,%rbp
  8001c0:	48 83 ec 20          	sub    $0x20,%rsp
  8001c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001db:	00 
  8001dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e8:	48 89 d1             	mov    %rdx,%rcx
  8001eb:	48 89 c2             	mov    %rax,%rdx
  8001ee:	be 00 00 00 00       	mov    $0x0,%esi
  8001f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f8:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
}
  800204:	c9                   	leaveq 
  800205:	c3                   	retq   

0000000000800206 <sys_cgetc>:

int
sys_cgetc(void)
{
  800206:	55                   	push   %rbp
  800207:	48 89 e5             	mov    %rsp,%rbp
  80020a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80020e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800215:	00 
  800216:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80021c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800222:	b9 00 00 00 00       	mov    $0x0,%ecx
  800227:	ba 00 00 00 00       	mov    $0x0,%edx
  80022c:	be 00 00 00 00       	mov    $0x0,%esi
  800231:	bf 01 00 00 00       	mov    $0x1,%edi
  800236:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
}
  800242:	c9                   	leaveq 
  800243:	c3                   	retq   

0000000000800244 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800244:	55                   	push   %rbp
  800245:	48 89 e5             	mov    %rsp,%rbp
  800248:	48 83 ec 10          	sub    $0x10,%rsp
  80024c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80024f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800252:	48 98                	cltq   
  800254:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80025b:	00 
  80025c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800262:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800268:	b9 00 00 00 00       	mov    $0x0,%ecx
  80026d:	48 89 c2             	mov    %rax,%rdx
  800270:	be 01 00 00 00       	mov    $0x1,%esi
  800275:	bf 03 00 00 00       	mov    $0x3,%edi
  80027a:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  800281:	00 00 00 
  800284:	ff d0                	callq  *%rax
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800290:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800297:	00 
  800298:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80029e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ae:	be 00 00 00 00       	mov    $0x0,%esi
  8002b3:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b8:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	callq  *%rax
}
  8002c4:	c9                   	leaveq 
  8002c5:	c3                   	retq   

00000000008002c6 <sys_yield>:

void
sys_yield(void)
{
  8002c6:	55                   	push   %rbp
  8002c7:	48 89 e5             	mov    %rsp,%rbp
  8002ca:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d5:	00 
  8002d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ec:	be 00 00 00 00       	mov    $0x0,%esi
  8002f1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f6:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  8002fd:	00 00 00 
  800300:	ff d0                	callq  *%rax
}
  800302:	c9                   	leaveq 
  800303:	c3                   	retq   

0000000000800304 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800304:	55                   	push   %rbp
  800305:	48 89 e5             	mov    %rsp,%rbp
  800308:	48 83 ec 20          	sub    $0x20,%rsp
  80030c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80030f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800313:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800316:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800319:	48 63 c8             	movslq %eax,%rcx
  80031c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800320:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800323:	48 98                	cltq   
  800325:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80032c:	00 
  80032d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800333:	49 89 c8             	mov    %rcx,%r8
  800336:	48 89 d1             	mov    %rdx,%rcx
  800339:	48 89 c2             	mov    %rax,%rdx
  80033c:	be 01 00 00 00       	mov    $0x1,%esi
  800341:	bf 04 00 00 00       	mov    $0x4,%edi
  800346:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  80034d:	00 00 00 
  800350:	ff d0                	callq  *%rax
}
  800352:	c9                   	leaveq 
  800353:	c3                   	retq   

0000000000800354 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800354:	55                   	push   %rbp
  800355:	48 89 e5             	mov    %rsp,%rbp
  800358:	48 83 ec 30          	sub    $0x30,%rsp
  80035c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800363:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800366:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80036a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80036e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800371:	48 63 c8             	movslq %eax,%rcx
  800374:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800378:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037b:	48 63 f0             	movslq %eax,%rsi
  80037e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800385:	48 98                	cltq   
  800387:	48 89 0c 24          	mov    %rcx,(%rsp)
  80038b:	49 89 f9             	mov    %rdi,%r9
  80038e:	49 89 f0             	mov    %rsi,%r8
  800391:	48 89 d1             	mov    %rdx,%rcx
  800394:	48 89 c2             	mov    %rax,%rdx
  800397:	be 01 00 00 00       	mov    $0x1,%esi
  80039c:	bf 05 00 00 00       	mov    $0x5,%edi
  8003a1:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  8003a8:	00 00 00 
  8003ab:	ff d0                	callq  *%rax
}
  8003ad:	c9                   	leaveq 
  8003ae:	c3                   	retq   

00000000008003af <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003af:	55                   	push   %rbp
  8003b0:	48 89 e5             	mov    %rsp,%rbp
  8003b3:	48 83 ec 20          	sub    $0x20,%rsp
  8003b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c5:	48 98                	cltq   
  8003c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003ce:	00 
  8003cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003db:	48 89 d1             	mov    %rdx,%rcx
  8003de:	48 89 c2             	mov    %rax,%rdx
  8003e1:	be 01 00 00 00       	mov    $0x1,%esi
  8003e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8003eb:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  8003f2:	00 00 00 
  8003f5:	ff d0                	callq  *%rax
}
  8003f7:	c9                   	leaveq 
  8003f8:	c3                   	retq   

00000000008003f9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f9:	55                   	push   %rbp
  8003fa:	48 89 e5             	mov    %rsp,%rbp
  8003fd:	48 83 ec 10          	sub    $0x10,%rsp
  800401:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800404:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	48 63 d0             	movslq %eax,%rdx
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800419:	00 
  80041a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800420:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800426:	48 89 d1             	mov    %rdx,%rcx
  800429:	48 89 c2             	mov    %rax,%rdx
  80042c:	be 01 00 00 00       	mov    $0x1,%esi
  800431:	bf 08 00 00 00       	mov    $0x8,%edi
  800436:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  80043d:	00 00 00 
  800440:	ff d0                	callq  *%rax
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 ec 20          	sub    $0x20,%rsp
  80044c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800453:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800457:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80045a:	48 98                	cltq   
  80045c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800463:	00 
  800464:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80046a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800470:	48 89 d1             	mov    %rdx,%rcx
  800473:	48 89 c2             	mov    %rax,%rdx
  800476:	be 01 00 00 00       	mov    $0x1,%esi
  80047b:	bf 09 00 00 00       	mov    $0x9,%edi
  800480:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  800487:	00 00 00 
  80048a:	ff d0                	callq  *%rax
}
  80048c:	c9                   	leaveq 
  80048d:	c3                   	retq   

000000000080048e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80048e:	55                   	push   %rbp
  80048f:	48 89 e5             	mov    %rsp,%rbp
  800492:	48 83 ec 20          	sub    $0x20,%rsp
  800496:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800499:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80049d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a4:	48 98                	cltq   
  8004a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ad:	00 
  8004ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ba:	48 89 d1             	mov    %rdx,%rcx
  8004bd:	48 89 c2             	mov    %rax,%rdx
  8004c0:	be 01 00 00 00       	mov    $0x1,%esi
  8004c5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004ca:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
}
  8004d6:	c9                   	leaveq 
  8004d7:	c3                   	retq   

00000000008004d8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d8:	55                   	push   %rbp
  8004d9:	48 89 e5             	mov    %rsp,%rbp
  8004dc:	48 83 ec 20          	sub    $0x20,%rsp
  8004e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004eb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004f1:	48 63 f0             	movslq %eax,%rsi
  8004f4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004fb:	48 98                	cltq   
  8004fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800501:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800508:	00 
  800509:	49 89 f1             	mov    %rsi,%r9
  80050c:	49 89 c8             	mov    %rcx,%r8
  80050f:	48 89 d1             	mov    %rdx,%rcx
  800512:	48 89 c2             	mov    %rax,%rdx
  800515:	be 00 00 00 00       	mov    $0x0,%esi
  80051a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051f:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  800526:	00 00 00 
  800529:	ff d0                	callq  *%rax
}
  80052b:	c9                   	leaveq 
  80052c:	c3                   	retq   

000000000080052d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80052d:	55                   	push   %rbp
  80052e:	48 89 e5             	mov    %rsp,%rbp
  800531:	48 83 ec 10          	sub    $0x10,%rsp
  800535:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80053d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800544:	00 
  800545:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80054b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800551:	b9 00 00 00 00       	mov    $0x0,%ecx
  800556:	48 89 c2             	mov    %rax,%rdx
  800559:	be 01 00 00 00       	mov    $0x1,%esi
  80055e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800563:	48 b8 2e 01 80 00 00 	movabs $0x80012e,%rax
  80056a:	00 00 00 
  80056d:	ff d0                	callq  *%rax
}
  80056f:	c9                   	leaveq 
  800570:	c3                   	retq   

0000000000800571 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  800571:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  800574:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  80057b:	00 00 00 
call *%rax
  80057e:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  800580:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  800587:	00 
    movq 152(%rsp), %rcx
  800588:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80058f:	00 
    subq $8, %rcx
  800590:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  800594:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  800597:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80059e:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  80059f:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8005a3:	4c 8b 3c 24          	mov    (%rsp),%r15
  8005a7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8005ac:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8005b1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8005b6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8005bb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8005c0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8005c5:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8005ca:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8005cf:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8005d4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8005d9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8005de:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8005e3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8005e8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8005ed:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  8005f1:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  8005f5:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  8005f6:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  8005f7:	c3                   	retq   

00000000008005f8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8005f8:	55                   	push   %rbp
  8005f9:	48 89 e5             	mov    %rsp,%rbp
  8005fc:	48 83 ec 08          	sub    $0x8,%rsp
  800600:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800604:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800608:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80060f:	ff ff ff 
  800612:	48 01 d0             	add    %rdx,%rax
  800615:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800619:	c9                   	leaveq 
  80061a:	c3                   	retq   

000000000080061b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80061b:	55                   	push   %rbp
  80061c:	48 89 e5             	mov    %rsp,%rbp
  80061f:	48 83 ec 08          	sub    $0x8,%rsp
  800623:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062b:	48 89 c7             	mov    %rax,%rdi
  80062e:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  800635:	00 00 00 
  800638:	ff d0                	callq  *%rax
  80063a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800640:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800644:	c9                   	leaveq 
  800645:	c3                   	retq   

0000000000800646 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800646:	55                   	push   %rbp
  800647:	48 89 e5             	mov    %rsp,%rbp
  80064a:	48 83 ec 18          	sub    $0x18,%rsp
  80064e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800652:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800659:	eb 6b                	jmp    8006c6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80065b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80065e:	48 98                	cltq   
  800660:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800666:	48 c1 e0 0c          	shl    $0xc,%rax
  80066a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80066e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800672:	48 c1 e8 15          	shr    $0x15,%rax
  800676:	48 89 c2             	mov    %rax,%rdx
  800679:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800680:	01 00 00 
  800683:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800687:	83 e0 01             	and    $0x1,%eax
  80068a:	48 85 c0             	test   %rax,%rax
  80068d:	74 21                	je     8006b0 <fd_alloc+0x6a>
  80068f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800693:	48 c1 e8 0c          	shr    $0xc,%rax
  800697:	48 89 c2             	mov    %rax,%rdx
  80069a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006a1:	01 00 00 
  8006a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a8:	83 e0 01             	and    $0x1,%eax
  8006ab:	48 85 c0             	test   %rax,%rax
  8006ae:	75 12                	jne    8006c2 <fd_alloc+0x7c>
			*fd_store = fd;
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006b8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8006bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c0:	eb 1a                	jmp    8006dc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8006c6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8006ca:	7e 8f                	jle    80065b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8006d7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8006dc:	c9                   	leaveq 
  8006dd:	c3                   	retq   

00000000008006de <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8006de:	55                   	push   %rbp
  8006df:	48 89 e5             	mov    %rsp,%rbp
  8006e2:	48 83 ec 20          	sub    $0x20,%rsp
  8006e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8006e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8006ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8006f1:	78 06                	js     8006f9 <fd_lookup+0x1b>
  8006f3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8006f7:	7e 07                	jle    800700 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fe:	eb 6c                	jmp    80076c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800700:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800703:	48 98                	cltq   
  800705:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80070b:	48 c1 e0 0c          	shl    $0xc,%rax
  80070f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800717:	48 c1 e8 15          	shr    $0x15,%rax
  80071b:	48 89 c2             	mov    %rax,%rdx
  80071e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800725:	01 00 00 
  800728:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80072c:	83 e0 01             	and    $0x1,%eax
  80072f:	48 85 c0             	test   %rax,%rax
  800732:	74 21                	je     800755 <fd_lookup+0x77>
  800734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800738:	48 c1 e8 0c          	shr    $0xc,%rax
  80073c:	48 89 c2             	mov    %rax,%rdx
  80073f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800746:	01 00 00 
  800749:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80074d:	83 e0 01             	and    $0x1,%eax
  800750:	48 85 c0             	test   %rax,%rax
  800753:	75 07                	jne    80075c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800755:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075a:	eb 10                	jmp    80076c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80075c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800760:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800764:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800767:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80076c:	c9                   	leaveq 
  80076d:	c3                   	retq   

000000000080076e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80076e:	55                   	push   %rbp
  80076f:	48 89 e5             	mov    %rsp,%rbp
  800772:	48 83 ec 30          	sub    $0x30,%rsp
  800776:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80077a:	89 f0                	mov    %esi,%eax
  80077c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80077f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800783:	48 89 c7             	mov    %rax,%rdi
  800786:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  80078d:	00 00 00 
  800790:	ff d0                	callq  *%rax
  800792:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800796:	48 89 d6             	mov    %rdx,%rsi
  800799:	89 c7                	mov    %eax,%edi
  80079b:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  8007a2:	00 00 00 
  8007a5:	ff d0                	callq  *%rax
  8007a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007ae:	78 0a                	js     8007ba <fd_close+0x4c>
	    || fd != fd2)
  8007b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007b4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8007b8:	74 12                	je     8007cc <fd_close+0x5e>
		return (must_exist ? r : 0);
  8007ba:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8007be:	74 05                	je     8007c5 <fd_close+0x57>
  8007c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007c3:	eb 05                	jmp    8007ca <fd_close+0x5c>
  8007c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ca:	eb 69                	jmp    800835 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d0:	8b 00                	mov    (%rax),%eax
  8007d2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8007d6:	48 89 d6             	mov    %rdx,%rsi
  8007d9:	89 c7                	mov    %eax,%edi
  8007db:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  8007e2:	00 00 00 
  8007e5:	ff d0                	callq  *%rax
  8007e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007ee:	78 2a                	js     80081a <fd_close+0xac>
		if (dev->dev_close)
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007f8:	48 85 c0             	test   %rax,%rax
  8007fb:	74 16                	je     800813 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8007fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800801:	48 8b 40 20          	mov    0x20(%rax),%rax
  800805:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800809:	48 89 d7             	mov    %rdx,%rdi
  80080c:	ff d0                	callq  *%rax
  80080e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800811:	eb 07                	jmp    80081a <fd_close+0xac>
		else
			r = 0;
  800813:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80081a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80081e:	48 89 c6             	mov    %rax,%rsi
  800821:	bf 00 00 00 00       	mov    $0x0,%edi
  800826:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  80082d:	00 00 00 
  800830:	ff d0                	callq  *%rax
	return r;
  800832:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800835:	c9                   	leaveq 
  800836:	c3                   	retq   

0000000000800837 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800837:	55                   	push   %rbp
  800838:	48 89 e5             	mov    %rsp,%rbp
  80083b:	48 83 ec 20          	sub    $0x20,%rsp
  80083f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800842:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800846:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80084d:	eb 41                	jmp    800890 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80084f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800856:	00 00 00 
  800859:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80085c:	48 63 d2             	movslq %edx,%rdx
  80085f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800863:	8b 00                	mov    (%rax),%eax
  800865:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800868:	75 22                	jne    80088c <dev_lookup+0x55>
			*dev = devtab[i];
  80086a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800871:	00 00 00 
  800874:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800877:	48 63 d2             	movslq %edx,%rdx
  80087a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80087e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800882:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800885:	b8 00 00 00 00       	mov    $0x0,%eax
  80088a:	eb 60                	jmp    8008ec <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80088c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800890:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800897:	00 00 00 
  80089a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80089d:	48 63 d2             	movslq %edx,%rdx
  8008a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008a4:	48 85 c0             	test   %rax,%rax
  8008a7:	75 a6                	jne    80084f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008b0:	00 00 00 
  8008b3:	48 8b 00             	mov    (%rax),%rax
  8008b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8008bc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008bf:	89 c6                	mov    %eax,%esi
  8008c1:	48 bf 78 37 80 00 00 	movabs $0x803778,%rdi
  8008c8:	00 00 00 
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	48 b9 f6 20 80 00 00 	movabs $0x8020f6,%rcx
  8008d7:	00 00 00 
  8008da:	ff d1                	callq  *%rcx
	*dev = 0;
  8008dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8008e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008ec:	c9                   	leaveq 
  8008ed:	c3                   	retq   

00000000008008ee <close>:

int
close(int fdnum)
{
  8008ee:	55                   	push   %rbp
  8008ef:	48 89 e5             	mov    %rsp,%rbp
  8008f2:	48 83 ec 20          	sub    $0x20,%rsp
  8008f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8008fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800900:	48 89 d6             	mov    %rdx,%rsi
  800903:	89 c7                	mov    %eax,%edi
  800905:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  80090c:	00 00 00 
  80090f:	ff d0                	callq  *%rax
  800911:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800918:	79 05                	jns    80091f <close+0x31>
		return r;
  80091a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80091d:	eb 18                	jmp    800937 <close+0x49>
	else
		return fd_close(fd, 1);
  80091f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800923:	be 01 00 00 00       	mov    $0x1,%esi
  800928:	48 89 c7             	mov    %rax,%rdi
  80092b:	48 b8 6e 07 80 00 00 	movabs $0x80076e,%rax
  800932:	00 00 00 
  800935:	ff d0                	callq  *%rax
}
  800937:	c9                   	leaveq 
  800938:	c3                   	retq   

0000000000800939 <close_all>:

void
close_all(void)
{
  800939:	55                   	push   %rbp
  80093a:	48 89 e5             	mov    %rsp,%rbp
  80093d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800948:	eb 15                	jmp    80095f <close_all+0x26>
		close(i);
  80094a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80094d:	89 c7                	mov    %eax,%edi
  80094f:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  800956:	00 00 00 
  800959:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80095b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80095f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800963:	7e e5                	jle    80094a <close_all+0x11>
		close(i);
}
  800965:	c9                   	leaveq 
  800966:	c3                   	retq   

0000000000800967 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800967:	55                   	push   %rbp
  800968:	48 89 e5             	mov    %rsp,%rbp
  80096b:	48 83 ec 40          	sub    $0x40,%rsp
  80096f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800972:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800975:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800979:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80097c:	48 89 d6             	mov    %rdx,%rsi
  80097f:	89 c7                	mov    %eax,%edi
  800981:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800988:	00 00 00 
  80098b:	ff d0                	callq  *%rax
  80098d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800990:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800994:	79 08                	jns    80099e <dup+0x37>
		return r;
  800996:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800999:	e9 70 01 00 00       	jmpq   800b0e <dup+0x1a7>
	close(newfdnum);
  80099e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009a1:	89 c7                	mov    %eax,%edi
  8009a3:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  8009aa:	00 00 00 
  8009ad:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009af:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009b2:	48 98                	cltq   
  8009b4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8009ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8009be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8009c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c6:	48 89 c7             	mov    %rax,%rdi
  8009c9:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  8009d0:	00 00 00 
  8009d3:	ff d0                	callq  *%rax
  8009d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8009d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009dd:	48 89 c7             	mov    %rax,%rdi
  8009e0:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  8009e7:	00 00 00 
  8009ea:	ff d0                	callq  *%rax
  8009ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f4:	48 c1 e8 15          	shr    $0x15,%rax
  8009f8:	48 89 c2             	mov    %rax,%rdx
  8009fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a02:	01 00 00 
  800a05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a09:	83 e0 01             	and    $0x1,%eax
  800a0c:	48 85 c0             	test   %rax,%rax
  800a0f:	74 73                	je     800a84 <dup+0x11d>
  800a11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a15:	48 c1 e8 0c          	shr    $0xc,%rax
  800a19:	48 89 c2             	mov    %rax,%rdx
  800a1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a23:	01 00 00 
  800a26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a2a:	83 e0 01             	and    $0x1,%eax
  800a2d:	48 85 c0             	test   %rax,%rax
  800a30:	74 52                	je     800a84 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a36:	48 c1 e8 0c          	shr    $0xc,%rax
  800a3a:	48 89 c2             	mov    %rax,%rdx
  800a3d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a44:	01 00 00 
  800a47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a4b:	25 07 0e 00 00       	and    $0xe07,%eax
  800a50:	89 c1                	mov    %eax,%ecx
  800a52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5a:	41 89 c8             	mov    %ecx,%r8d
  800a5d:	48 89 d1             	mov    %rdx,%rcx
  800a60:	ba 00 00 00 00       	mov    $0x0,%edx
  800a65:	48 89 c6             	mov    %rax,%rsi
  800a68:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6d:	48 b8 54 03 80 00 00 	movabs $0x800354,%rax
  800a74:	00 00 00 
  800a77:	ff d0                	callq  *%rax
  800a79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a80:	79 02                	jns    800a84 <dup+0x11d>
			goto err;
  800a82:	eb 57                	jmp    800adb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a88:	48 c1 e8 0c          	shr    $0xc,%rax
  800a8c:	48 89 c2             	mov    %rax,%rdx
  800a8f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a96:	01 00 00 
  800a99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a9d:	25 07 0e 00 00       	and    $0xe07,%eax
  800aa2:	89 c1                	mov    %eax,%ecx
  800aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aa8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aac:	41 89 c8             	mov    %ecx,%r8d
  800aaf:	48 89 d1             	mov    %rdx,%rcx
  800ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab7:	48 89 c6             	mov    %rax,%rsi
  800aba:	bf 00 00 00 00       	mov    $0x0,%edi
  800abf:	48 b8 54 03 80 00 00 	movabs $0x800354,%rax
  800ac6:	00 00 00 
  800ac9:	ff d0                	callq  *%rax
  800acb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ace:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad2:	79 02                	jns    800ad6 <dup+0x16f>
		goto err;
  800ad4:	eb 05                	jmp    800adb <dup+0x174>

	return newfdnum;
  800ad6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800ad9:	eb 33                	jmp    800b0e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800adb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800adf:	48 89 c6             	mov    %rax,%rsi
  800ae2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae7:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  800aee:	00 00 00 
  800af1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800af3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800af7:	48 89 c6             	mov    %rax,%rsi
  800afa:	bf 00 00 00 00       	mov    $0x0,%edi
  800aff:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  800b06:	00 00 00 
  800b09:	ff d0                	callq  *%rax
	return r;
  800b0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b0e:	c9                   	leaveq 
  800b0f:	c3                   	retq   

0000000000800b10 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b10:	55                   	push   %rbp
  800b11:	48 89 e5             	mov    %rsp,%rbp
  800b14:	48 83 ec 40          	sub    $0x40,%rsp
  800b18:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b1b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b23:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b27:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b2a:	48 89 d6             	mov    %rdx,%rsi
  800b2d:	89 c7                	mov    %eax,%edi
  800b2f:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800b36:	00 00 00 
  800b39:	ff d0                	callq  *%rax
  800b3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b42:	78 24                	js     800b68 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b48:	8b 00                	mov    (%rax),%eax
  800b4a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b4e:	48 89 d6             	mov    %rdx,%rsi
  800b51:	89 c7                	mov    %eax,%edi
  800b53:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	callq  *%rax
  800b5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b66:	79 05                	jns    800b6d <read+0x5d>
		return r;
  800b68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b6b:	eb 76                	jmp    800be3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800b6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b71:	8b 40 08             	mov    0x8(%rax),%eax
  800b74:	83 e0 03             	and    $0x3,%eax
  800b77:	83 f8 01             	cmp    $0x1,%eax
  800b7a:	75 3a                	jne    800bb6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b7c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b83:	00 00 00 
  800b86:	48 8b 00             	mov    (%rax),%rax
  800b89:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b8f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b92:	89 c6                	mov    %eax,%esi
  800b94:	48 bf 97 37 80 00 00 	movabs $0x803797,%rdi
  800b9b:	00 00 00 
  800b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba3:	48 b9 f6 20 80 00 00 	movabs $0x8020f6,%rcx
  800baa:	00 00 00 
  800bad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800baf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bb4:	eb 2d                	jmp    800be3 <read+0xd3>
	}
	if (!dev->dev_read)
  800bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bba:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bbe:	48 85 c0             	test   %rax,%rax
  800bc1:	75 07                	jne    800bca <read+0xba>
		return -E_NOT_SUPP;
  800bc3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800bc8:	eb 19                	jmp    800be3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800bca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bce:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bd2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800bd6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bda:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800bde:	48 89 cf             	mov    %rcx,%rdi
  800be1:	ff d0                	callq  *%rax
}
  800be3:	c9                   	leaveq 
  800be4:	c3                   	retq   

0000000000800be5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800be5:	55                   	push   %rbp
  800be6:	48 89 e5             	mov    %rsp,%rbp
  800be9:	48 83 ec 30          	sub    $0x30,%rsp
  800bed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800bf0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800bf4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800bff:	eb 49                	jmp    800c4a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c04:	48 98                	cltq   
  800c06:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c0a:	48 29 c2             	sub    %rax,%rdx
  800c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c10:	48 63 c8             	movslq %eax,%rcx
  800c13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c17:	48 01 c1             	add    %rax,%rcx
  800c1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c1d:	48 89 ce             	mov    %rcx,%rsi
  800c20:	89 c7                	mov    %eax,%edi
  800c22:	48 b8 10 0b 80 00 00 	movabs $0x800b10,%rax
  800c29:	00 00 00 
  800c2c:	ff d0                	callq  *%rax
  800c2e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c31:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c35:	79 05                	jns    800c3c <readn+0x57>
			return m;
  800c37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c3a:	eb 1c                	jmp    800c58 <readn+0x73>
		if (m == 0)
  800c3c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c40:	75 02                	jne    800c44 <readn+0x5f>
			break;
  800c42:	eb 11                	jmp    800c55 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c47:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c4d:	48 98                	cltq   
  800c4f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c53:	72 ac                	jb     800c01 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c58:	c9                   	leaveq 
  800c59:	c3                   	retq   

0000000000800c5a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c5a:	55                   	push   %rbp
  800c5b:	48 89 e5             	mov    %rsp,%rbp
  800c5e:	48 83 ec 40          	sub    $0x40,%rsp
  800c62:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800c65:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800c69:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800c71:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c74:	48 89 d6             	mov    %rdx,%rsi
  800c77:	89 c7                	mov    %eax,%edi
  800c79:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800c80:	00 00 00 
  800c83:	ff d0                	callq  *%rax
  800c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c8c:	78 24                	js     800cb2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c92:	8b 00                	mov    (%rax),%eax
  800c94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c98:	48 89 d6             	mov    %rdx,%rsi
  800c9b:	89 c7                	mov    %eax,%edi
  800c9d:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800ca4:	00 00 00 
  800ca7:	ff d0                	callq  *%rax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cb0:	79 05                	jns    800cb7 <write+0x5d>
		return r;
  800cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb5:	eb 75                	jmp    800d2c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cbb:	8b 40 08             	mov    0x8(%rax),%eax
  800cbe:	83 e0 03             	and    $0x3,%eax
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	75 3a                	jne    800cff <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800cc5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ccc:	00 00 00 
  800ccf:	48 8b 00             	mov    (%rax),%rax
  800cd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800cd8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800cdb:	89 c6                	mov    %eax,%esi
  800cdd:	48 bf b3 37 80 00 00 	movabs $0x8037b3,%rdi
  800ce4:	00 00 00 
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cec:	48 b9 f6 20 80 00 00 	movabs $0x8020f6,%rcx
  800cf3:	00 00 00 
  800cf6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800cf8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cfd:	eb 2d                	jmp    800d2c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d03:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d07:	48 85 c0             	test   %rax,%rax
  800d0a:	75 07                	jne    800d13 <write+0xb9>
		return -E_NOT_SUPP;
  800d0c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d11:	eb 19                	jmp    800d2c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d17:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d1b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d23:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d27:	48 89 cf             	mov    %rcx,%rdi
  800d2a:	ff d0                	callq  *%rax
}
  800d2c:	c9                   	leaveq 
  800d2d:	c3                   	retq   

0000000000800d2e <seek>:

int
seek(int fdnum, off_t offset)
{
  800d2e:	55                   	push   %rbp
  800d2f:	48 89 e5             	mov    %rsp,%rbp
  800d32:	48 83 ec 18          	sub    $0x18,%rsp
  800d36:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d39:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d3c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d43:	48 89 d6             	mov    %rdx,%rsi
  800d46:	89 c7                	mov    %eax,%edi
  800d48:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800d4f:	00 00 00 
  800d52:	ff d0                	callq  *%rax
  800d54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d5b:	79 05                	jns    800d62 <seek+0x34>
		return r;
  800d5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d60:	eb 0f                	jmp    800d71 <seek+0x43>
	fd->fd_offset = offset;
  800d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d66:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800d69:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d71:	c9                   	leaveq 
  800d72:	c3                   	retq   

0000000000800d73 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d73:	55                   	push   %rbp
  800d74:	48 89 e5             	mov    %rsp,%rbp
  800d77:	48 83 ec 30          	sub    $0x30,%rsp
  800d7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d7e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d81:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d85:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d88:	48 89 d6             	mov    %rdx,%rsi
  800d8b:	89 c7                	mov    %eax,%edi
  800d8d:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800d94:	00 00 00 
  800d97:	ff d0                	callq  *%rax
  800d99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800da0:	78 24                	js     800dc6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800da2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da6:	8b 00                	mov    (%rax),%eax
  800da8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dac:	48 89 d6             	mov    %rdx,%rsi
  800daf:	89 c7                	mov    %eax,%edi
  800db1:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800db8:	00 00 00 
  800dbb:	ff d0                	callq  *%rax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc4:	79 05                	jns    800dcb <ftruncate+0x58>
		return r;
  800dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dc9:	eb 72                	jmp    800e3d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcf:	8b 40 08             	mov    0x8(%rax),%eax
  800dd2:	83 e0 03             	and    $0x3,%eax
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	75 3a                	jne    800e13 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800dd9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800de0:	00 00 00 
  800de3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800de6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800dec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800def:	89 c6                	mov    %eax,%esi
  800df1:	48 bf d0 37 80 00 00 	movabs $0x8037d0,%rdi
  800df8:	00 00 00 
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	48 b9 f6 20 80 00 00 	movabs $0x8020f6,%rcx
  800e07:	00 00 00 
  800e0a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e11:	eb 2a                	jmp    800e3d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e17:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e1b:	48 85 c0             	test   %rax,%rax
  800e1e:	75 07                	jne    800e27 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e20:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e25:	eb 16                	jmp    800e3d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e33:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e36:	89 ce                	mov    %ecx,%esi
  800e38:	48 89 d7             	mov    %rdx,%rdi
  800e3b:	ff d0                	callq  *%rax
}
  800e3d:	c9                   	leaveq 
  800e3e:	c3                   	retq   

0000000000800e3f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e3f:	55                   	push   %rbp
  800e40:	48 89 e5             	mov    %rsp,%rbp
  800e43:	48 83 ec 30          	sub    $0x30,%rsp
  800e47:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e4a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e4e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e52:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e55:	48 89 d6             	mov    %rdx,%rsi
  800e58:	89 c7                	mov    %eax,%edi
  800e5a:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  800e61:	00 00 00 
  800e64:	ff d0                	callq  *%rax
  800e66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e6d:	78 24                	js     800e93 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e73:	8b 00                	mov    (%rax),%eax
  800e75:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e79:	48 89 d6             	mov    %rdx,%rsi
  800e7c:	89 c7                	mov    %eax,%edi
  800e7e:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800e85:	00 00 00 
  800e88:	ff d0                	callq  *%rax
  800e8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e91:	79 05                	jns    800e98 <fstat+0x59>
		return r;
  800e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e96:	eb 5e                	jmp    800ef6 <fstat+0xb7>
	if (!dev->dev_stat)
  800e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9c:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ea0:	48 85 c0             	test   %rax,%rax
  800ea3:	75 07                	jne    800eac <fstat+0x6d>
		return -E_NOT_SUPP;
  800ea5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800eaa:	eb 4a                	jmp    800ef6 <fstat+0xb7>
	stat->st_name[0] = 0;
  800eac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800eb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800ebe:	00 00 00 
	stat->st_isdir = 0;
  800ec1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ec5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800ecc:	00 00 00 
	stat->st_dev = dev;
  800ecf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ed3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ed7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee2:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ee6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eea:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800eee:	48 89 ce             	mov    %rcx,%rsi
  800ef1:	48 89 d7             	mov    %rdx,%rdi
  800ef4:	ff d0                	callq  *%rax
}
  800ef6:	c9                   	leaveq 
  800ef7:	c3                   	retq   

0000000000800ef8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ef8:	55                   	push   %rbp
  800ef9:	48 89 e5             	mov    %rsp,%rbp
  800efc:	48 83 ec 20          	sub    $0x20,%rsp
  800f00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0c:	be 00 00 00 00       	mov    $0x0,%esi
  800f11:	48 89 c7             	mov    %rax,%rdi
  800f14:	48 b8 e6 0f 80 00 00 	movabs $0x800fe6,%rax
  800f1b:	00 00 00 
  800f1e:	ff d0                	callq  *%rax
  800f20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f27:	79 05                	jns    800f2e <stat+0x36>
		return fd;
  800f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2c:	eb 2f                	jmp    800f5d <stat+0x65>
	r = fstat(fd, stat);
  800f2e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f35:	48 89 d6             	mov    %rdx,%rsi
  800f38:	89 c7                	mov    %eax,%edi
  800f3a:	48 b8 3f 0e 80 00 00 	movabs $0x800e3f,%rax
  800f41:	00 00 00 
  800f44:	ff d0                	callq  *%rax
  800f46:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f4c:	89 c7                	mov    %eax,%edi
  800f4e:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  800f55:	00 00 00 
  800f58:	ff d0                	callq  *%rax
	return r;
  800f5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f5d:	c9                   	leaveq 
  800f5e:	c3                   	retq   

0000000000800f5f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f5f:	55                   	push   %rbp
  800f60:	48 89 e5             	mov    %rsp,%rbp
  800f63:	48 83 ec 10          	sub    $0x10,%rsp
  800f67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800f6e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f75:	00 00 00 
  800f78:	8b 00                	mov    (%rax),%eax
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	75 1d                	jne    800f9b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f7e:	bf 01 00 00 00       	mov    $0x1,%edi
  800f83:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  800f8a:	00 00 00 
  800f8d:	ff d0                	callq  *%rax
  800f8f:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f96:	00 00 00 
  800f99:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f9b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fa2:	00 00 00 
  800fa5:	8b 00                	mov    (%rax),%eax
  800fa7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800faa:	b9 07 00 00 00       	mov    $0x7,%ecx
  800faf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fb6:	00 00 00 
  800fb9:	89 c7                	mov    %eax,%edi
  800fbb:	48 b8 9b 35 80 00 00 	movabs $0x80359b,%rax
  800fc2:	00 00 00 
  800fc5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	48 89 c6             	mov    %rax,%rsi
  800fd3:	bf 00 00 00 00       	mov    $0x0,%edi
  800fd8:	48 b8 da 34 80 00 00 	movabs $0x8034da,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	callq  *%rax
}
  800fe4:	c9                   	leaveq 
  800fe5:	c3                   	retq   

0000000000800fe6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800fe6:	55                   	push   %rbp
  800fe7:	48 89 e5             	mov    %rsp,%rbp
  800fea:	48 83 ec 20          	sub    $0x20,%rsp
  800fee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800ff5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff9:	48 89 c7             	mov    %rax,%rdi
  800ffc:	48 b8 52 2c 80 00 00 	movabs $0x802c52,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
  801008:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80100d:	7e 0a                	jle    801019 <open+0x33>
		return -E_BAD_PATH;
  80100f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801014:	e9 a5 00 00 00       	jmpq   8010be <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  801019:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80101d:	48 89 c7             	mov    %rax,%rdi
  801020:	48 b8 46 06 80 00 00 	movabs $0x800646,%rax
  801027:	00 00 00 
  80102a:	ff d0                	callq  *%rax
  80102c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80102f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801033:	79 08                	jns    80103d <open+0x57>
		return r;
  801035:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801038:	e9 81 00 00 00       	jmpq   8010be <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80103d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801041:	48 89 c6             	mov    %rax,%rsi
  801044:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80104b:	00 00 00 
  80104e:	48 b8 be 2c 80 00 00 	movabs $0x802cbe,%rax
  801055:	00 00 00 
  801058:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80105a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801061:	00 00 00 
  801064:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801067:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80106d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801071:	48 89 c6             	mov    %rax,%rsi
  801074:	bf 01 00 00 00       	mov    $0x1,%edi
  801079:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  801080:	00 00 00 
  801083:	ff d0                	callq  *%rax
  801085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80108c:	79 1d                	jns    8010ab <open+0xc5>
		fd_close(fd, 0);
  80108e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801092:	be 00 00 00 00       	mov    $0x0,%esi
  801097:	48 89 c7             	mov    %rax,%rdi
  80109a:	48 b8 6e 07 80 00 00 	movabs $0x80076e,%rax
  8010a1:	00 00 00 
  8010a4:	ff d0                	callq  *%rax
		return r;
  8010a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a9:	eb 13                	jmp    8010be <open+0xd8>
	}

	return fd2num(fd);
  8010ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010af:	48 89 c7             	mov    %rax,%rdi
  8010b2:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  8010b9:	00 00 00 
  8010bc:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 10          	sub    $0x10,%rsp
  8010c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8010cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8010d3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010da:	00 00 00 
  8010dd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8010df:	be 00 00 00 00       	mov    $0x0,%esi
  8010e4:	bf 06 00 00 00       	mov    $0x6,%edi
  8010e9:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  8010f0:	00 00 00 
  8010f3:	ff d0                	callq  *%rax
}
  8010f5:	c9                   	leaveq 
  8010f6:	c3                   	retq   

00000000008010f7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8010f7:	55                   	push   %rbp
  8010f8:	48 89 e5             	mov    %rsp,%rbp
  8010fb:	48 83 ec 30          	sub    $0x30,%rsp
  8010ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801103:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801107:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80110b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110f:	8b 50 0c             	mov    0xc(%rax),%edx
  801112:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801119:	00 00 00 
  80111c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80111e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801125:	00 00 00 
  801128:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80112c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801130:	be 00 00 00 00       	mov    $0x0,%esi
  801135:	bf 03 00 00 00       	mov    $0x3,%edi
  80113a:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  801141:	00 00 00 
  801144:	ff d0                	callq  *%rax
  801146:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80114d:	79 08                	jns    801157 <devfile_read+0x60>
		return r;
  80114f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801152:	e9 a4 00 00 00       	jmpq   8011fb <devfile_read+0x104>
	assert(r <= n);
  801157:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80115a:	48 98                	cltq   
  80115c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801160:	76 35                	jbe    801197 <devfile_read+0xa0>
  801162:	48 b9 fd 37 80 00 00 	movabs $0x8037fd,%rcx
  801169:	00 00 00 
  80116c:	48 ba 04 38 80 00 00 	movabs $0x803804,%rdx
  801173:	00 00 00 
  801176:	be 84 00 00 00       	mov    $0x84,%esi
  80117b:	48 bf 19 38 80 00 00 	movabs $0x803819,%rdi
  801182:	00 00 00 
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	49 b8 bd 1e 80 00 00 	movabs $0x801ebd,%r8
  801191:	00 00 00 
  801194:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  801197:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80119e:	7e 35                	jle    8011d5 <devfile_read+0xde>
  8011a0:	48 b9 24 38 80 00 00 	movabs $0x803824,%rcx
  8011a7:	00 00 00 
  8011aa:	48 ba 04 38 80 00 00 	movabs $0x803804,%rdx
  8011b1:	00 00 00 
  8011b4:	be 85 00 00 00       	mov    $0x85,%esi
  8011b9:	48 bf 19 38 80 00 00 	movabs $0x803819,%rdi
  8011c0:	00 00 00 
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c8:	49 b8 bd 1e 80 00 00 	movabs $0x801ebd,%r8
  8011cf:	00 00 00 
  8011d2:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8011d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d8:	48 63 d0             	movslq %eax,%rdx
  8011db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011df:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011e6:	00 00 00 
  8011e9:	48 89 c7             	mov    %rax,%rdi
  8011ec:	48 b8 e2 2f 80 00 00 	movabs $0x802fe2,%rax
  8011f3:	00 00 00 
  8011f6:	ff d0                	callq  *%rax
	return r;
  8011f8:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8011fb:	c9                   	leaveq 
  8011fc:	c3                   	retq   

00000000008011fd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8011fd:	55                   	push   %rbp
  8011fe:	48 89 e5             	mov    %rsp,%rbp
  801201:	48 83 ec 30          	sub    $0x30,%rsp
  801205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801209:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80120d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801215:	8b 50 0c             	mov    0xc(%rax),%edx
  801218:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80121f:	00 00 00 
  801222:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801224:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80122b:	00 00 00 
  80122e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801232:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801236:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80123d:	00 
  80123e:	76 35                	jbe    801275 <devfile_write+0x78>
  801240:	48 b9 30 38 80 00 00 	movabs $0x803830,%rcx
  801247:	00 00 00 
  80124a:	48 ba 04 38 80 00 00 	movabs $0x803804,%rdx
  801251:	00 00 00 
  801254:	be 9e 00 00 00       	mov    $0x9e,%esi
  801259:	48 bf 19 38 80 00 00 	movabs $0x803819,%rdi
  801260:	00 00 00 
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
  801268:	49 b8 bd 1e 80 00 00 	movabs $0x801ebd,%r8
  80126f:	00 00 00 
  801272:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801275:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801279:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80127d:	48 89 c6             	mov    %rax,%rsi
  801280:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801287:	00 00 00 
  80128a:	48 b8 f9 30 80 00 00 	movabs $0x8030f9,%rax
  801291:	00 00 00 
  801294:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801296:	be 00 00 00 00       	mov    $0x0,%esi
  80129b:	bf 04 00 00 00       	mov    $0x4,%edi
  8012a0:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  8012a7:	00 00 00 
  8012aa:	ff d0                	callq  *%rax
  8012ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012b3:	79 05                	jns    8012ba <devfile_write+0xbd>
		return r;
  8012b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012b8:	eb 43                	jmp    8012fd <devfile_write+0x100>
	assert(r <= n);
  8012ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012bd:	48 98                	cltq   
  8012bf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012c3:	76 35                	jbe    8012fa <devfile_write+0xfd>
  8012c5:	48 b9 fd 37 80 00 00 	movabs $0x8037fd,%rcx
  8012cc:	00 00 00 
  8012cf:	48 ba 04 38 80 00 00 	movabs $0x803804,%rdx
  8012d6:	00 00 00 
  8012d9:	be a2 00 00 00       	mov    $0xa2,%esi
  8012de:	48 bf 19 38 80 00 00 	movabs $0x803819,%rdi
  8012e5:	00 00 00 
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	49 b8 bd 1e 80 00 00 	movabs $0x801ebd,%r8
  8012f4:	00 00 00 
  8012f7:	41 ff d0             	callq  *%r8
	return r;
  8012fa:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8012fd:	c9                   	leaveq 
  8012fe:	c3                   	retq   

00000000008012ff <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012ff:	55                   	push   %rbp
  801300:	48 89 e5             	mov    %rsp,%rbp
  801303:	48 83 ec 20          	sub    $0x20,%rsp
  801307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80130f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801313:	8b 50 0c             	mov    0xc(%rax),%edx
  801316:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80131d:	00 00 00 
  801320:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801322:	be 00 00 00 00       	mov    $0x0,%esi
  801327:	bf 05 00 00 00       	mov    $0x5,%edi
  80132c:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  801333:	00 00 00 
  801336:	ff d0                	callq  *%rax
  801338:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80133b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80133f:	79 05                	jns    801346 <devfile_stat+0x47>
		return r;
  801341:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801344:	eb 56                	jmp    80139c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801346:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801351:	00 00 00 
  801354:	48 89 c7             	mov    %rax,%rdi
  801357:	48 b8 be 2c 80 00 00 	movabs $0x802cbe,%rax
  80135e:	00 00 00 
  801361:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801363:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80136a:	00 00 00 
  80136d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801373:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801377:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80137d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801384:	00 00 00 
  801387:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80138d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801391:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 10          	sub    $0x10,%rsp
  8013a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013aa:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8013b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013bb:	00 00 00 
  8013be:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8013c0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013c7:	00 00 00 
  8013ca:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013cd:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013d0:	be 00 00 00 00       	mov    $0x0,%esi
  8013d5:	bf 02 00 00 00       	mov    $0x2,%edi
  8013da:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  8013e1:	00 00 00 
  8013e4:	ff d0                	callq  *%rax
}
  8013e6:	c9                   	leaveq 
  8013e7:	c3                   	retq   

00000000008013e8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8013e8:	55                   	push   %rbp
  8013e9:	48 89 e5             	mov    %rsp,%rbp
  8013ec:	48 83 ec 10          	sub    $0x10,%rsp
  8013f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f8:	48 89 c7             	mov    %rax,%rdi
  8013fb:	48 b8 52 2c 80 00 00 	movabs $0x802c52,%rax
  801402:	00 00 00 
  801405:	ff d0                	callq  *%rax
  801407:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80140c:	7e 07                	jle    801415 <remove+0x2d>
		return -E_BAD_PATH;
  80140e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801413:	eb 33                	jmp    801448 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	48 89 c6             	mov    %rax,%rsi
  80141c:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801423:	00 00 00 
  801426:	48 b8 be 2c 80 00 00 	movabs $0x802cbe,%rax
  80142d:	00 00 00 
  801430:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801432:	be 00 00 00 00       	mov    $0x0,%esi
  801437:	bf 07 00 00 00       	mov    $0x7,%edi
  80143c:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  801443:	00 00 00 
  801446:	ff d0                	callq  *%rax
}
  801448:	c9                   	leaveq 
  801449:	c3                   	retq   

000000000080144a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80144a:	55                   	push   %rbp
  80144b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80144e:	be 00 00 00 00       	mov    $0x0,%esi
  801453:	bf 08 00 00 00       	mov    $0x8,%edi
  801458:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  80145f:	00 00 00 
  801462:	ff d0                	callq  *%rax
}
  801464:	5d                   	pop    %rbp
  801465:	c3                   	retq   

0000000000801466 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801471:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801478:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80147f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801486:	be 00 00 00 00       	mov    $0x0,%esi
  80148b:	48 89 c7             	mov    %rax,%rdi
  80148e:	48 b8 e6 0f 80 00 00 	movabs $0x800fe6,%rax
  801495:	00 00 00 
  801498:	ff d0                	callq  *%rax
  80149a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80149d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014a1:	79 28                	jns    8014cb <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8014a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014a6:	89 c6                	mov    %eax,%esi
  8014a8:	48 bf 5d 38 80 00 00 	movabs $0x80385d,%rdi
  8014af:	00 00 00 
  8014b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b7:	48 ba f6 20 80 00 00 	movabs $0x8020f6,%rdx
  8014be:	00 00 00 
  8014c1:	ff d2                	callq  *%rdx
		return fd_src;
  8014c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014c6:	e9 74 01 00 00       	jmpq   80163f <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8014cb:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8014d2:	be 01 01 00 00       	mov    $0x101,%esi
  8014d7:	48 89 c7             	mov    %rax,%rdi
  8014da:	48 b8 e6 0f 80 00 00 	movabs $0x800fe6,%rax
  8014e1:	00 00 00 
  8014e4:	ff d0                	callq  *%rax
  8014e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8014e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8014ed:	79 39                	jns    801528 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8014ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014f2:	89 c6                	mov    %eax,%esi
  8014f4:	48 bf 73 38 80 00 00 	movabs $0x803873,%rdi
  8014fb:	00 00 00 
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801503:	48 ba f6 20 80 00 00 	movabs $0x8020f6,%rdx
  80150a:	00 00 00 
  80150d:	ff d2                	callq  *%rdx
		close(fd_src);
  80150f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801512:	89 c7                	mov    %eax,%edi
  801514:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  80151b:	00 00 00 
  80151e:	ff d0                	callq  *%rax
		return fd_dest;
  801520:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801523:	e9 17 01 00 00       	jmpq   80163f <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801528:	eb 74                	jmp    80159e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80152a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152d:	48 63 d0             	movslq %eax,%rdx
  801530:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801537:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80153a:	48 89 ce             	mov    %rcx,%rsi
  80153d:	89 c7                	mov    %eax,%edi
  80153f:	48 b8 5a 0c 80 00 00 	movabs $0x800c5a,%rax
  801546:	00 00 00 
  801549:	ff d0                	callq  *%rax
  80154b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80154e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801552:	79 4a                	jns    80159e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801554:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801557:	89 c6                	mov    %eax,%esi
  801559:	48 bf 8d 38 80 00 00 	movabs $0x80388d,%rdi
  801560:	00 00 00 
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	48 ba f6 20 80 00 00 	movabs $0x8020f6,%rdx
  80156f:	00 00 00 
  801572:	ff d2                	callq  *%rdx
			close(fd_src);
  801574:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801577:	89 c7                	mov    %eax,%edi
  801579:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  801580:	00 00 00 
  801583:	ff d0                	callq  *%rax
			close(fd_dest);
  801585:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801588:	89 c7                	mov    %eax,%edi
  80158a:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  801591:	00 00 00 
  801594:	ff d0                	callq  *%rax
			return write_size;
  801596:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801599:	e9 a1 00 00 00       	jmpq   80163f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80159e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8015a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015a8:	ba 00 02 00 00       	mov    $0x200,%edx
  8015ad:	48 89 ce             	mov    %rcx,%rsi
  8015b0:	89 c7                	mov    %eax,%edi
  8015b2:	48 b8 10 0b 80 00 00 	movabs $0x800b10,%rax
  8015b9:	00 00 00 
  8015bc:	ff d0                	callq  *%rax
  8015be:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8015c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015c5:	0f 8f 5f ff ff ff    	jg     80152a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8015cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015cf:	79 47                	jns    801618 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8015d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d4:	89 c6                	mov    %eax,%esi
  8015d6:	48 bf a0 38 80 00 00 	movabs $0x8038a0,%rdi
  8015dd:	00 00 00 
  8015e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e5:	48 ba f6 20 80 00 00 	movabs $0x8020f6,%rdx
  8015ec:	00 00 00 
  8015ef:	ff d2                	callq  *%rdx
		close(fd_src);
  8015f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015f4:	89 c7                	mov    %eax,%edi
  8015f6:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  8015fd:	00 00 00 
  801600:	ff d0                	callq  *%rax
		close(fd_dest);
  801602:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801605:	89 c7                	mov    %eax,%edi
  801607:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  80160e:	00 00 00 
  801611:	ff d0                	callq  *%rax
		return read_size;
  801613:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801616:	eb 27                	jmp    80163f <copy+0x1d9>
	}
	close(fd_src);
  801618:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80161b:	89 c7                	mov    %eax,%edi
  80161d:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  801624:	00 00 00 
  801627:	ff d0                	callq  *%rax
	close(fd_dest);
  801629:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80162c:	89 c7                	mov    %eax,%edi
  80162e:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  801635:	00 00 00 
  801638:	ff d0                	callq  *%rax
	return 0;
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80163f:	c9                   	leaveq 
  801640:	c3                   	retq   

0000000000801641 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	53                   	push   %rbx
  801646:	48 83 ec 38          	sub    $0x38,%rsp
  80164a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80164e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801652:	48 89 c7             	mov    %rax,%rdi
  801655:	48 b8 46 06 80 00 00 	movabs $0x800646,%rax
  80165c:	00 00 00 
  80165f:	ff d0                	callq  *%rax
  801661:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801664:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801668:	0f 88 bf 01 00 00    	js     80182d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	ba 07 04 00 00       	mov    $0x407,%edx
  801677:	48 89 c6             	mov    %rax,%rsi
  80167a:	bf 00 00 00 00       	mov    $0x0,%edi
  80167f:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  801686:	00 00 00 
  801689:	ff d0                	callq  *%rax
  80168b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801692:	0f 88 95 01 00 00    	js     80182d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801698:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80169c:	48 89 c7             	mov    %rax,%rdi
  80169f:	48 b8 46 06 80 00 00 	movabs $0x800646,%rax
  8016a6:	00 00 00 
  8016a9:	ff d0                	callq  *%rax
  8016ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016b2:	0f 88 5d 01 00 00    	js     801815 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016bc:	ba 07 04 00 00       	mov    $0x407,%edx
  8016c1:	48 89 c6             	mov    %rax,%rsi
  8016c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8016c9:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  8016d0:	00 00 00 
  8016d3:	ff d0                	callq  *%rax
  8016d5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016dc:	0f 88 33 01 00 00    	js     801815 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	48 89 c7             	mov    %rax,%rdi
  8016e9:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  8016f0:	00 00 00 
  8016f3:	ff d0                	callq  *%rax
  8016f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016fd:	ba 07 04 00 00       	mov    $0x407,%edx
  801702:	48 89 c6             	mov    %rax,%rsi
  801705:	bf 00 00 00 00       	mov    $0x0,%edi
  80170a:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  801711:	00 00 00 
  801714:	ff d0                	callq  *%rax
  801716:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801719:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80171d:	79 05                	jns    801724 <pipe+0xe3>
		goto err2;
  80171f:	e9 d9 00 00 00       	jmpq   8017fd <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801724:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801728:	48 89 c7             	mov    %rax,%rdi
  80172b:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  801732:	00 00 00 
  801735:	ff d0                	callq  *%rax
  801737:	48 89 c2             	mov    %rax,%rdx
  80173a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80173e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801744:	48 89 d1             	mov    %rdx,%rcx
  801747:	ba 00 00 00 00       	mov    $0x0,%edx
  80174c:	48 89 c6             	mov    %rax,%rsi
  80174f:	bf 00 00 00 00       	mov    $0x0,%edi
  801754:	48 b8 54 03 80 00 00 	movabs $0x800354,%rax
  80175b:	00 00 00 
  80175e:	ff d0                	callq  *%rax
  801760:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801763:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801767:	79 1b                	jns    801784 <pipe+0x143>
		goto err3;
  801769:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80176a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80176e:	48 89 c6             	mov    %rax,%rsi
  801771:	bf 00 00 00 00       	mov    $0x0,%edi
  801776:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  80177d:	00 00 00 
  801780:	ff d0                	callq  *%rax
  801782:	eb 79                	jmp    8017fd <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80178f:	00 00 00 
  801792:	8b 12                	mov    (%rdx),%edx
  801794:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8017a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a5:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8017ac:	00 00 00 
  8017af:	8b 12                	mov    (%rdx),%edx
  8017b1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8017b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	48 89 c7             	mov    %rax,%rdi
  8017c5:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  8017cc:	00 00 00 
  8017cf:	ff d0                	callq  *%rax
  8017d1:	89 c2                	mov    %eax,%edx
  8017d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017d7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8017d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017dd:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8017e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e5:	48 89 c7             	mov    %rax,%rdi
  8017e8:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  8017ef:	00 00 00 
  8017f2:	ff d0                	callq  *%rax
  8017f4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	eb 33                	jmp    801830 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8017fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801801:	48 89 c6             	mov    %rax,%rsi
  801804:	bf 00 00 00 00       	mov    $0x0,%edi
  801809:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  801810:	00 00 00 
  801813:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	48 89 c6             	mov    %rax,%rsi
  80181c:	bf 00 00 00 00       	mov    $0x0,%edi
  801821:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  801828:	00 00 00 
  80182b:	ff d0                	callq  *%rax
err:
	return r;
  80182d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801830:	48 83 c4 38          	add    $0x38,%rsp
  801834:	5b                   	pop    %rbx
  801835:	5d                   	pop    %rbp
  801836:	c3                   	retq   

0000000000801837 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801837:	55                   	push   %rbp
  801838:	48 89 e5             	mov    %rsp,%rbp
  80183b:	53                   	push   %rbx
  80183c:	48 83 ec 28          	sub    $0x28,%rsp
  801840:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801844:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801848:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80184f:	00 00 00 
  801852:	48 8b 00             	mov    (%rax),%rax
  801855:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80185b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80185e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801862:	48 89 c7             	mov    %rax,%rdi
  801865:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
  80186c:	00 00 00 
  80186f:	ff d0                	callq  *%rax
  801871:	89 c3                	mov    %eax,%ebx
  801873:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801877:	48 89 c7             	mov    %rax,%rdi
  80187a:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
  801881:	00 00 00 
  801884:	ff d0                	callq  *%rax
  801886:	39 c3                	cmp    %eax,%ebx
  801888:	0f 94 c0             	sete   %al
  80188b:	0f b6 c0             	movzbl %al,%eax
  80188e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801891:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801898:	00 00 00 
  80189b:	48 8b 00             	mov    (%rax),%rax
  80189e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8018a4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8018a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018aa:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8018ad:	75 05                	jne    8018b4 <_pipeisclosed+0x7d>
			return ret;
  8018af:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8018b2:	eb 4f                	jmp    801903 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8018b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8018ba:	74 42                	je     8018fe <_pipeisclosed+0xc7>
  8018bc:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8018c0:	75 3c                	jne    8018fe <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018c2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8018c9:	00 00 00 
  8018cc:	48 8b 00             	mov    (%rax),%rax
  8018cf:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8018d5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8018d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018db:	89 c6                	mov    %eax,%esi
  8018dd:	48 bf bb 38 80 00 00 	movabs $0x8038bb,%rdi
  8018e4:	00 00 00 
  8018e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ec:	49 b8 f6 20 80 00 00 	movabs $0x8020f6,%r8
  8018f3:	00 00 00 
  8018f6:	41 ff d0             	callq  *%r8
	}
  8018f9:	e9 4a ff ff ff       	jmpq   801848 <_pipeisclosed+0x11>
  8018fe:	e9 45 ff ff ff       	jmpq   801848 <_pipeisclosed+0x11>
}
  801903:	48 83 c4 28          	add    $0x28,%rsp
  801907:	5b                   	pop    %rbx
  801908:	5d                   	pop    %rbp
  801909:	c3                   	retq   

000000000080190a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80190a:	55                   	push   %rbp
  80190b:	48 89 e5             	mov    %rsp,%rbp
  80190e:	48 83 ec 30          	sub    $0x30,%rsp
  801912:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801915:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801919:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80191c:	48 89 d6             	mov    %rdx,%rsi
  80191f:	89 c7                	mov    %eax,%edi
  801921:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
  80192d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801934:	79 05                	jns    80193b <pipeisclosed+0x31>
		return r;
  801936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801939:	eb 31                	jmp    80196c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80193b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80193f:	48 89 c7             	mov    %rax,%rdi
  801942:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  801949:	00 00 00 
  80194c:	ff d0                	callq  *%rax
  80194e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801956:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195a:	48 89 d6             	mov    %rdx,%rsi
  80195d:	48 89 c7             	mov    %rax,%rdi
  801960:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  801967:	00 00 00 
  80196a:	ff d0                	callq  *%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 40          	sub    $0x40,%rsp
  801976:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80197a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80197e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801982:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801986:	48 89 c7             	mov    %rax,%rdi
  801989:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  801990:	00 00 00 
  801993:	ff d0                	callq  *%rax
  801995:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801999:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80199d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019a1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019a8:	00 
  8019a9:	e9 92 00 00 00       	jmpq   801a40 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8019ae:	eb 41                	jmp    8019f1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8019b0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8019b5:	74 09                	je     8019c0 <devpipe_read+0x52>
				return i;
  8019b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019bb:	e9 92 00 00 00       	jmpq   801a52 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8019c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c8:	48 89 d6             	mov    %rdx,%rsi
  8019cb:	48 89 c7             	mov    %rax,%rdi
  8019ce:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	callq  *%rax
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	74 07                	je     8019e5 <devpipe_read+0x77>
				return 0;
  8019de:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e3:	eb 6d                	jmp    801a52 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8019e5:	48 b8 c6 02 80 00 00 	movabs $0x8002c6,%rax
  8019ec:	00 00 00 
  8019ef:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8019f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019f5:	8b 10                	mov    (%rax),%edx
  8019f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019fb:	8b 40 04             	mov    0x4(%rax),%eax
  8019fe:	39 c2                	cmp    %eax,%edx
  801a00:	74 ae                	je     8019b0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a0a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a12:	8b 00                	mov    (%rax),%eax
  801a14:	99                   	cltd   
  801a15:	c1 ea 1b             	shr    $0x1b,%edx
  801a18:	01 d0                	add    %edx,%eax
  801a1a:	83 e0 1f             	and    $0x1f,%eax
  801a1d:	29 d0                	sub    %edx,%eax
  801a1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a23:	48 98                	cltq   
  801a25:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801a2a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801a2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a30:	8b 00                	mov    (%rax),%eax
  801a32:	8d 50 01             	lea    0x1(%rax),%edx
  801a35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a39:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a3b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a44:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a48:	0f 82 60 ff ff ff    	jb     8019ae <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a52:	c9                   	leaveq 
  801a53:	c3                   	retq   

0000000000801a54 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a54:	55                   	push   %rbp
  801a55:	48 89 e5             	mov    %rsp,%rbp
  801a58:	48 83 ec 40          	sub    $0x40,%rsp
  801a5c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6c:	48 89 c7             	mov    %rax,%rdi
  801a6f:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  801a76:	00 00 00 
  801a79:	ff d0                	callq  *%rax
  801a7b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801a7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801a87:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a8e:	00 
  801a8f:	e9 8e 00 00 00       	jmpq   801b22 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a94:	eb 31                	jmp    801ac7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9e:	48 89 d6             	mov    %rdx,%rsi
  801aa1:	48 89 c7             	mov    %rax,%rdi
  801aa4:	48 b8 37 18 80 00 00 	movabs $0x801837,%rax
  801aab:	00 00 00 
  801aae:	ff d0                	callq  *%rax
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	74 07                	je     801abb <devpipe_write+0x67>
				return 0;
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab9:	eb 79                	jmp    801b34 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801abb:	48 b8 c6 02 80 00 00 	movabs $0x8002c6,%rax
  801ac2:	00 00 00 
  801ac5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ac7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801acb:	8b 40 04             	mov    0x4(%rax),%eax
  801ace:	48 63 d0             	movslq %eax,%rdx
  801ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad5:	8b 00                	mov    (%rax),%eax
  801ad7:	48 98                	cltq   
  801ad9:	48 83 c0 20          	add    $0x20,%rax
  801add:	48 39 c2             	cmp    %rax,%rdx
  801ae0:	73 b4                	jae    801a96 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ae2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae6:	8b 40 04             	mov    0x4(%rax),%eax
  801ae9:	99                   	cltd   
  801aea:	c1 ea 1b             	shr    $0x1b,%edx
  801aed:	01 d0                	add    %edx,%eax
  801aef:	83 e0 1f             	and    $0x1f,%eax
  801af2:	29 d0                	sub    %edx,%eax
  801af4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801af8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801afc:	48 01 ca             	add    %rcx,%rdx
  801aff:	0f b6 0a             	movzbl (%rdx),%ecx
  801b02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b06:	48 98                	cltq   
  801b08:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b10:	8b 40 04             	mov    0x4(%rax),%eax
  801b13:	8d 50 01             	lea    0x1(%rax),%edx
  801b16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b1a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b1d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b26:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801b2a:	0f 82 64 ff ff ff    	jb     801a94 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b34:	c9                   	leaveq 
  801b35:	c3                   	retq   

0000000000801b36 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b36:	55                   	push   %rbp
  801b37:	48 89 e5             	mov    %rsp,%rbp
  801b3a:	48 83 ec 20          	sub    $0x20,%rsp
  801b3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b4a:	48 89 c7             	mov    %rax,%rdi
  801b4d:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
  801b59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801b5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b61:	48 be ce 38 80 00 00 	movabs $0x8038ce,%rsi
  801b68:	00 00 00 
  801b6b:	48 89 c7             	mov    %rax,%rdi
  801b6e:	48 b8 be 2c 80 00 00 	movabs $0x802cbe,%rax
  801b75:	00 00 00 
  801b78:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7e:	8b 50 04             	mov    0x4(%rax),%edx
  801b81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b85:	8b 00                	mov    (%rax),%eax
  801b87:	29 c2                	sub    %eax,%edx
  801b89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b8d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801b93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b97:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b9e:	00 00 00 
	stat->st_dev = &devpipe;
  801ba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba5:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801bac:	00 00 00 
  801baf:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbb:	c9                   	leaveq 
  801bbc:	c3                   	retq   

0000000000801bbd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bbd:	55                   	push   %rbp
  801bbe:	48 89 e5             	mov    %rsp,%rbp
  801bc1:	48 83 ec 10          	sub    $0x10,%rsp
  801bc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcd:	48 89 c6             	mov    %rax,%rsi
  801bd0:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd5:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  801bdc:	00 00 00 
  801bdf:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801be1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be5:	48 89 c7             	mov    %rax,%rdi
  801be8:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  801bef:	00 00 00 
  801bf2:	ff d0                	callq  *%rax
  801bf4:	48 89 c6             	mov    %rax,%rsi
  801bf7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bfc:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  801c03:	00 00 00 
  801c06:	ff d0                	callq  *%rax
}
  801c08:	c9                   	leaveq 
  801c09:	c3                   	retq   

0000000000801c0a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801c0a:	55                   	push   %rbp
  801c0b:	48 89 e5             	mov    %rsp,%rbp
  801c0e:	48 83 ec 20          	sub    $0x20,%rsp
  801c12:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801c15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c18:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801c1b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801c1f:	be 01 00 00 00       	mov    $0x1,%esi
  801c24:	48 89 c7             	mov    %rax,%rdi
  801c27:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	callq  *%rax
}
  801c33:	c9                   	leaveq 
  801c34:	c3                   	retq   

0000000000801c35 <getchar>:

int
getchar(void)
{
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801c3d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801c41:	ba 01 00 00 00       	mov    $0x1,%edx
  801c46:	48 89 c6             	mov    %rax,%rsi
  801c49:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4e:	48 b8 10 0b 80 00 00 	movabs $0x800b10,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	callq  *%rax
  801c5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801c5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c61:	79 05                	jns    801c68 <getchar+0x33>
		return r;
  801c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c66:	eb 14                	jmp    801c7c <getchar+0x47>
	if (r < 1)
  801c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c6c:	7f 07                	jg     801c75 <getchar+0x40>
		return -E_EOF;
  801c6e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801c73:	eb 07                	jmp    801c7c <getchar+0x47>
	return c;
  801c75:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801c79:	0f b6 c0             	movzbl %al,%eax
}
  801c7c:	c9                   	leaveq 
  801c7d:	c3                   	retq   

0000000000801c7e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c7e:	55                   	push   %rbp
  801c7f:	48 89 e5             	mov    %rsp,%rbp
  801c82:	48 83 ec 20          	sub    $0x20,%rsp
  801c86:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c89:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c90:	48 89 d6             	mov    %rdx,%rsi
  801c93:	89 c7                	mov    %eax,%edi
  801c95:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
  801ca1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ca4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ca8:	79 05                	jns    801caf <iscons+0x31>
		return r;
  801caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cad:	eb 1a                	jmp    801cc9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb3:	8b 10                	mov    (%rax),%edx
  801cb5:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801cbc:	00 00 00 
  801cbf:	8b 00                	mov    (%rax),%eax
  801cc1:	39 c2                	cmp    %eax,%edx
  801cc3:	0f 94 c0             	sete   %al
  801cc6:	0f b6 c0             	movzbl %al,%eax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <opencons>:

int
opencons(void)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801cd3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801cd7:	48 89 c7             	mov    %rax,%rdi
  801cda:	48 b8 46 06 80 00 00 	movabs $0x800646,%rax
  801ce1:	00 00 00 
  801ce4:	ff d0                	callq  *%rax
  801ce6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ced:	79 05                	jns    801cf4 <opencons+0x29>
		return r;
  801cef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf2:	eb 5b                	jmp    801d4f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf8:	ba 07 04 00 00       	mov    $0x407,%edx
  801cfd:	48 89 c6             	mov    %rax,%rsi
  801d00:	bf 00 00 00 00       	mov    $0x0,%edi
  801d05:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  801d0c:	00 00 00 
  801d0f:	ff d0                	callq  *%rax
  801d11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d18:	79 05                	jns    801d1f <opencons+0x54>
		return r;
  801d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1d:	eb 30                	jmp    801d4f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d23:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801d2a:	00 00 00 
  801d2d:	8b 12                	mov    (%rdx),%edx
  801d2f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801d31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d35:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d40:	48 89 c7             	mov    %rax,%rdi
  801d43:	48 b8 f8 05 80 00 00 	movabs $0x8005f8,%rax
  801d4a:	00 00 00 
  801d4d:	ff d0                	callq  *%rax
}
  801d4f:	c9                   	leaveq 
  801d50:	c3                   	retq   

0000000000801d51 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
  801d55:	48 83 ec 30          	sub    $0x30,%rsp
  801d59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d61:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801d65:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801d6a:	75 07                	jne    801d73 <devcons_read+0x22>
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d71:	eb 4b                	jmp    801dbe <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801d73:	eb 0c                	jmp    801d81 <devcons_read+0x30>
		sys_yield();
  801d75:	48 b8 c6 02 80 00 00 	movabs $0x8002c6,%rax
  801d7c:	00 00 00 
  801d7f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d81:	48 b8 06 02 80 00 00 	movabs $0x800206,%rax
  801d88:	00 00 00 
  801d8b:	ff d0                	callq  *%rax
  801d8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d94:	74 df                	je     801d75 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801d96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d9a:	79 05                	jns    801da1 <devcons_read+0x50>
		return c;
  801d9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9f:	eb 1d                	jmp    801dbe <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801da1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801da5:	75 07                	jne    801dae <devcons_read+0x5d>
		return 0;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dac:	eb 10                	jmp    801dbe <devcons_read+0x6d>
	*(char*)vbuf = c;
  801dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db1:	89 c2                	mov    %eax,%edx
  801db3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801db7:	88 10                	mov    %dl,(%rax)
	return 1;
  801db9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801dbe:	c9                   	leaveq 
  801dbf:	c3                   	retq   

0000000000801dc0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801dc0:	55                   	push   %rbp
  801dc1:	48 89 e5             	mov    %rsp,%rbp
  801dc4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801dcb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801dd2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801dd9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801de0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801de7:	eb 76                	jmp    801e5f <devcons_write+0x9f>
		m = n - tot;
  801de9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801df0:	89 c2                	mov    %eax,%edx
  801df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df5:	29 c2                	sub    %eax,%edx
  801df7:	89 d0                	mov    %edx,%eax
  801df9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801dfc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dff:	83 f8 7f             	cmp    $0x7f,%eax
  801e02:	76 07                	jbe    801e0b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801e04:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801e0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e0e:	48 63 d0             	movslq %eax,%rdx
  801e11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e14:	48 63 c8             	movslq %eax,%rcx
  801e17:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801e1e:	48 01 c1             	add    %rax,%rcx
  801e21:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801e28:	48 89 ce             	mov    %rcx,%rsi
  801e2b:	48 89 c7             	mov    %rax,%rdi
  801e2e:	48 b8 e2 2f 80 00 00 	movabs $0x802fe2,%rax
  801e35:	00 00 00 
  801e38:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801e3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e3d:	48 63 d0             	movslq %eax,%rdx
  801e40:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801e47:	48 89 d6             	mov    %rdx,%rsi
  801e4a:	48 89 c7             	mov    %rax,%rdi
  801e4d:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801e59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e5c:	01 45 fc             	add    %eax,-0x4(%rbp)
  801e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e62:	48 98                	cltq   
  801e64:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801e6b:	0f 82 78 ff ff ff    	jb     801de9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e74:	c9                   	leaveq 
  801e75:	c3                   	retq   

0000000000801e76 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801e76:	55                   	push   %rbp
  801e77:	48 89 e5             	mov    %rsp,%rbp
  801e7a:	48 83 ec 08          	sub    $0x8,%rsp
  801e7e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e87:	c9                   	leaveq 
  801e88:	c3                   	retq   

0000000000801e89 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e89:	55                   	push   %rbp
  801e8a:	48 89 e5             	mov    %rsp,%rbp
  801e8d:	48 83 ec 10          	sub    $0x10,%rsp
  801e91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9d:	48 be da 38 80 00 00 	movabs $0x8038da,%rsi
  801ea4:	00 00 00 
  801ea7:	48 89 c7             	mov    %rax,%rdi
  801eaa:	48 b8 be 2c 80 00 00 	movabs $0x802cbe,%rax
  801eb1:	00 00 00 
  801eb4:	ff d0                	callq  *%rax
	return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	c9                   	leaveq 
  801ebc:	c3                   	retq   

0000000000801ebd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ebd:	55                   	push   %rbp
  801ebe:	48 89 e5             	mov    %rsp,%rbp
  801ec1:	53                   	push   %rbx
  801ec2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801ec9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801ed0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801ed6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801edd:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801ee4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801eeb:	84 c0                	test   %al,%al
  801eed:	74 23                	je     801f12 <_panic+0x55>
  801eef:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801ef6:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801efa:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801efe:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801f02:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801f06:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801f0a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801f0e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801f12:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801f19:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801f20:	00 00 00 
  801f23:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801f2a:	00 00 00 
  801f2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f31:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801f38:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801f3f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f46:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801f4d:	00 00 00 
  801f50:	48 8b 18             	mov    (%rax),%rbx
  801f53:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	callq  *%rax
  801f5f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801f65:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801f6c:	41 89 c8             	mov    %ecx,%r8d
  801f6f:	48 89 d1             	mov    %rdx,%rcx
  801f72:	48 89 da             	mov    %rbx,%rdx
  801f75:	89 c6                	mov    %eax,%esi
  801f77:	48 bf e8 38 80 00 00 	movabs $0x8038e8,%rdi
  801f7e:	00 00 00 
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	49 b9 f6 20 80 00 00 	movabs $0x8020f6,%r9
  801f8d:	00 00 00 
  801f90:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f93:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f9a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801fa1:	48 89 d6             	mov    %rdx,%rsi
  801fa4:	48 89 c7             	mov    %rax,%rdi
  801fa7:	48 b8 4a 20 80 00 00 	movabs $0x80204a,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	callq  *%rax
	cprintf("\n");
  801fb3:	48 bf 0b 39 80 00 00 	movabs $0x80390b,%rdi
  801fba:	00 00 00 
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	48 ba f6 20 80 00 00 	movabs $0x8020f6,%rdx
  801fc9:	00 00 00 
  801fcc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fce:	cc                   	int3   
  801fcf:	eb fd                	jmp    801fce <_panic+0x111>

0000000000801fd1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801fd1:	55                   	push   %rbp
  801fd2:	48 89 e5             	mov    %rsp,%rbp
  801fd5:	48 83 ec 10          	sub    $0x10,%rsp
  801fd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fdc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe4:	8b 00                	mov    (%rax),%eax
  801fe6:	8d 48 01             	lea    0x1(%rax),%ecx
  801fe9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fed:	89 0a                	mov    %ecx,(%rdx)
  801fef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff2:	89 d1                	mov    %edx,%ecx
  801ff4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ff8:	48 98                	cltq   
  801ffa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802002:	8b 00                	mov    (%rax),%eax
  802004:	3d ff 00 00 00       	cmp    $0xff,%eax
  802009:	75 2c                	jne    802037 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80200b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200f:	8b 00                	mov    (%rax),%eax
  802011:	48 98                	cltq   
  802013:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802017:	48 83 c2 08          	add    $0x8,%rdx
  80201b:	48 89 c6             	mov    %rax,%rsi
  80201e:	48 89 d7             	mov    %rdx,%rdi
  802021:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  802028:	00 00 00 
  80202b:	ff d0                	callq  *%rax
        b->idx = 0;
  80202d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802031:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203b:	8b 40 04             	mov    0x4(%rax),%eax
  80203e:	8d 50 01             	lea    0x1(%rax),%edx
  802041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802045:	89 50 04             	mov    %edx,0x4(%rax)
}
  802048:	c9                   	leaveq 
  802049:	c3                   	retq   

000000000080204a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80204a:	55                   	push   %rbp
  80204b:	48 89 e5             	mov    %rsp,%rbp
  80204e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802055:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80205c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802063:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80206a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802071:	48 8b 0a             	mov    (%rdx),%rcx
  802074:	48 89 08             	mov    %rcx,(%rax)
  802077:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80207b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80207f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802083:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802087:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80208e:	00 00 00 
    b.cnt = 0;
  802091:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802098:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80209b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8020a2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8020a9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8020b0:	48 89 c6             	mov    %rax,%rsi
  8020b3:	48 bf d1 1f 80 00 00 	movabs $0x801fd1,%rdi
  8020ba:	00 00 00 
  8020bd:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8020c4:	00 00 00 
  8020c7:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8020c9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8020cf:	48 98                	cltq   
  8020d1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8020d8:	48 83 c2 08          	add    $0x8,%rdx
  8020dc:	48 89 c6             	mov    %rax,%rsi
  8020df:	48 89 d7             	mov    %rdx,%rdi
  8020e2:	48 b8 bc 01 80 00 00 	movabs $0x8001bc,%rax
  8020e9:	00 00 00 
  8020ec:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8020ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8020f4:	c9                   	leaveq 
  8020f5:	c3                   	retq   

00000000008020f6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8020f6:	55                   	push   %rbp
  8020f7:	48 89 e5             	mov    %rsp,%rbp
  8020fa:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802101:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802108:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80210f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802116:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80211d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802124:	84 c0                	test   %al,%al
  802126:	74 20                	je     802148 <cprintf+0x52>
  802128:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80212c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802130:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802134:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802138:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80213c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802140:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802144:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802148:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80214f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802156:	00 00 00 
  802159:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802160:	00 00 00 
  802163:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802167:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80216e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802175:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80217c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802183:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80218a:	48 8b 0a             	mov    (%rdx),%rcx
  80218d:	48 89 08             	mov    %rcx,(%rax)
  802190:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802194:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802198:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80219c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8021a0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8021a7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8021ae:	48 89 d6             	mov    %rdx,%rsi
  8021b1:	48 89 c7             	mov    %rax,%rdi
  8021b4:	48 b8 4a 20 80 00 00 	movabs $0x80204a,%rax
  8021bb:	00 00 00 
  8021be:	ff d0                	callq  *%rax
  8021c0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8021c6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8021cc:	c9                   	leaveq 
  8021cd:	c3                   	retq   

00000000008021ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8021ce:	55                   	push   %rbp
  8021cf:	48 89 e5             	mov    %rsp,%rbp
  8021d2:	53                   	push   %rbx
  8021d3:	48 83 ec 38          	sub    $0x38,%rsp
  8021d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8021e3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8021e6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8021ea:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8021ee:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8021f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8021f5:	77 3b                	ja     802232 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8021f7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8021fa:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8021fe:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802205:	ba 00 00 00 00       	mov    $0x0,%edx
  80220a:	48 f7 f3             	div    %rbx
  80220d:	48 89 c2             	mov    %rax,%rdx
  802210:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802213:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802216:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80221a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221e:	41 89 f9             	mov    %edi,%r9d
  802221:	48 89 c7             	mov    %rax,%rdi
  802224:	48 b8 ce 21 80 00 00 	movabs $0x8021ce,%rax
  80222b:	00 00 00 
  80222e:	ff d0                	callq  *%rax
  802230:	eb 1e                	jmp    802250 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802232:	eb 12                	jmp    802246 <printnum+0x78>
			putch(padc, putdat);
  802234:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802238:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80223b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223f:	48 89 ce             	mov    %rcx,%rsi
  802242:	89 d7                	mov    %edx,%edi
  802244:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802246:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80224a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80224e:	7f e4                	jg     802234 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802250:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802257:	ba 00 00 00 00       	mov    $0x0,%edx
  80225c:	48 f7 f1             	div    %rcx
  80225f:	48 89 d0             	mov    %rdx,%rax
  802262:	48 ba 10 3b 80 00 00 	movabs $0x803b10,%rdx
  802269:	00 00 00 
  80226c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802270:	0f be d0             	movsbl %al,%edx
  802273:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227b:	48 89 ce             	mov    %rcx,%rsi
  80227e:	89 d7                	mov    %edx,%edi
  802280:	ff d0                	callq  *%rax
}
  802282:	48 83 c4 38          	add    $0x38,%rsp
  802286:	5b                   	pop    %rbx
  802287:	5d                   	pop    %rbp
  802288:	c3                   	retq   

0000000000802289 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802289:	55                   	push   %rbp
  80228a:	48 89 e5             	mov    %rsp,%rbp
  80228d:	48 83 ec 1c          	sub    $0x1c,%rsp
  802291:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802295:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  802298:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80229c:	7e 52                	jle    8022f0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80229e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a2:	8b 00                	mov    (%rax),%eax
  8022a4:	83 f8 30             	cmp    $0x30,%eax
  8022a7:	73 24                	jae    8022cd <getuint+0x44>
  8022a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b5:	8b 00                	mov    (%rax),%eax
  8022b7:	89 c0                	mov    %eax,%eax
  8022b9:	48 01 d0             	add    %rdx,%rax
  8022bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c0:	8b 12                	mov    (%rdx),%edx
  8022c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c9:	89 0a                	mov    %ecx,(%rdx)
  8022cb:	eb 17                	jmp    8022e4 <getuint+0x5b>
  8022cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022d5:	48 89 d0             	mov    %rdx,%rax
  8022d8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022e0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022e4:	48 8b 00             	mov    (%rax),%rax
  8022e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022eb:	e9 a3 00 00 00       	jmpq   802393 <getuint+0x10a>
	else if (lflag)
  8022f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022f4:	74 4f                	je     802345 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8022f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fa:	8b 00                	mov    (%rax),%eax
  8022fc:	83 f8 30             	cmp    $0x30,%eax
  8022ff:	73 24                	jae    802325 <getuint+0x9c>
  802301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802305:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230d:	8b 00                	mov    (%rax),%eax
  80230f:	89 c0                	mov    %eax,%eax
  802311:	48 01 d0             	add    %rdx,%rax
  802314:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802318:	8b 12                	mov    (%rdx),%edx
  80231a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80231d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802321:	89 0a                	mov    %ecx,(%rdx)
  802323:	eb 17                	jmp    80233c <getuint+0xb3>
  802325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802329:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80232d:	48 89 d0             	mov    %rdx,%rax
  802330:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802334:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802338:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80233c:	48 8b 00             	mov    (%rax),%rax
  80233f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802343:	eb 4e                	jmp    802393 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802349:	8b 00                	mov    (%rax),%eax
  80234b:	83 f8 30             	cmp    $0x30,%eax
  80234e:	73 24                	jae    802374 <getuint+0xeb>
  802350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802354:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235c:	8b 00                	mov    (%rax),%eax
  80235e:	89 c0                	mov    %eax,%eax
  802360:	48 01 d0             	add    %rdx,%rax
  802363:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802367:	8b 12                	mov    (%rdx),%edx
  802369:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80236c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802370:	89 0a                	mov    %ecx,(%rdx)
  802372:	eb 17                	jmp    80238b <getuint+0x102>
  802374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802378:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80237c:	48 89 d0             	mov    %rdx,%rax
  80237f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802383:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802387:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80238b:	8b 00                	mov    (%rax),%eax
  80238d:	89 c0                	mov    %eax,%eax
  80238f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802397:	c9                   	leaveq 
  802398:	c3                   	retq   

0000000000802399 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802399:	55                   	push   %rbp
  80239a:	48 89 e5             	mov    %rsp,%rbp
  80239d:	48 83 ec 1c          	sub    $0x1c,%rsp
  8023a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023a5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8023a8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8023ac:	7e 52                	jle    802400 <getint+0x67>
		x=va_arg(*ap, long long);
  8023ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b2:	8b 00                	mov    (%rax),%eax
  8023b4:	83 f8 30             	cmp    $0x30,%eax
  8023b7:	73 24                	jae    8023dd <getint+0x44>
  8023b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c5:	8b 00                	mov    (%rax),%eax
  8023c7:	89 c0                	mov    %eax,%eax
  8023c9:	48 01 d0             	add    %rdx,%rax
  8023cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d0:	8b 12                	mov    (%rdx),%edx
  8023d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d9:	89 0a                	mov    %ecx,(%rdx)
  8023db:	eb 17                	jmp    8023f4 <getint+0x5b>
  8023dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023e5:	48 89 d0             	mov    %rdx,%rax
  8023e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023f4:	48 8b 00             	mov    (%rax),%rax
  8023f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023fb:	e9 a3 00 00 00       	jmpq   8024a3 <getint+0x10a>
	else if (lflag)
  802400:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802404:	74 4f                	je     802455 <getint+0xbc>
		x=va_arg(*ap, long);
  802406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240a:	8b 00                	mov    (%rax),%eax
  80240c:	83 f8 30             	cmp    $0x30,%eax
  80240f:	73 24                	jae    802435 <getint+0x9c>
  802411:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802415:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241d:	8b 00                	mov    (%rax),%eax
  80241f:	89 c0                	mov    %eax,%eax
  802421:	48 01 d0             	add    %rdx,%rax
  802424:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802428:	8b 12                	mov    (%rdx),%edx
  80242a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80242d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802431:	89 0a                	mov    %ecx,(%rdx)
  802433:	eb 17                	jmp    80244c <getint+0xb3>
  802435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802439:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80243d:	48 89 d0             	mov    %rdx,%rax
  802440:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802444:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802448:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80244c:	48 8b 00             	mov    (%rax),%rax
  80244f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802453:	eb 4e                	jmp    8024a3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802459:	8b 00                	mov    (%rax),%eax
  80245b:	83 f8 30             	cmp    $0x30,%eax
  80245e:	73 24                	jae    802484 <getint+0xeb>
  802460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802464:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80246c:	8b 00                	mov    (%rax),%eax
  80246e:	89 c0                	mov    %eax,%eax
  802470:	48 01 d0             	add    %rdx,%rax
  802473:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802477:	8b 12                	mov    (%rdx),%edx
  802479:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80247c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802480:	89 0a                	mov    %ecx,(%rdx)
  802482:	eb 17                	jmp    80249b <getint+0x102>
  802484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802488:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80248c:	48 89 d0             	mov    %rdx,%rax
  80248f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802493:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802497:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80249b:	8b 00                	mov    (%rax),%eax
  80249d:	48 98                	cltq   
  80249f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8024a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8024a7:	c9                   	leaveq 
  8024a8:	c3                   	retq   

00000000008024a9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8024a9:	55                   	push   %rbp
  8024aa:	48 89 e5             	mov    %rsp,%rbp
  8024ad:	41 54                	push   %r12
  8024af:	53                   	push   %rbx
  8024b0:	48 83 ec 60          	sub    $0x60,%rsp
  8024b4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8024b8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8024bc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024c0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8024c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8024c8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8024cc:	48 8b 0a             	mov    (%rdx),%rcx
  8024cf:	48 89 08             	mov    %rcx,(%rax)
  8024d2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8024d6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8024da:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8024de:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8024e2:	eb 17                	jmp    8024fb <vprintfmt+0x52>
			if (ch == '\0')
  8024e4:	85 db                	test   %ebx,%ebx
  8024e6:	0f 84 df 04 00 00    	je     8029cb <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8024ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8024f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024f4:	48 89 d6             	mov    %rdx,%rsi
  8024f7:	89 df                	mov    %ebx,%edi
  8024f9:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8024fb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024ff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802503:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802507:	0f b6 00             	movzbl (%rax),%eax
  80250a:	0f b6 d8             	movzbl %al,%ebx
  80250d:	83 fb 25             	cmp    $0x25,%ebx
  802510:	75 d2                	jne    8024e4 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802512:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802516:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80251d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802524:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80252b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802532:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802536:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80253a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80253e:	0f b6 00             	movzbl (%rax),%eax
  802541:	0f b6 d8             	movzbl %al,%ebx
  802544:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802547:	83 f8 55             	cmp    $0x55,%eax
  80254a:	0f 87 47 04 00 00    	ja     802997 <vprintfmt+0x4ee>
  802550:	89 c0                	mov    %eax,%eax
  802552:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802559:	00 
  80255a:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  802561:	00 00 00 
  802564:	48 01 d0             	add    %rdx,%rax
  802567:	48 8b 00             	mov    (%rax),%rax
  80256a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80256c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802570:	eb c0                	jmp    802532 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802572:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802576:	eb ba                	jmp    802532 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802578:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80257f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802582:	89 d0                	mov    %edx,%eax
  802584:	c1 e0 02             	shl    $0x2,%eax
  802587:	01 d0                	add    %edx,%eax
  802589:	01 c0                	add    %eax,%eax
  80258b:	01 d8                	add    %ebx,%eax
  80258d:	83 e8 30             	sub    $0x30,%eax
  802590:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802593:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802597:	0f b6 00             	movzbl (%rax),%eax
  80259a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80259d:	83 fb 2f             	cmp    $0x2f,%ebx
  8025a0:	7e 0c                	jle    8025ae <vprintfmt+0x105>
  8025a2:	83 fb 39             	cmp    $0x39,%ebx
  8025a5:	7f 07                	jg     8025ae <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8025a7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8025ac:	eb d1                	jmp    80257f <vprintfmt+0xd6>
			goto process_precision;
  8025ae:	eb 58                	jmp    802608 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8025b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025b3:	83 f8 30             	cmp    $0x30,%eax
  8025b6:	73 17                	jae    8025cf <vprintfmt+0x126>
  8025b8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025bf:	89 c0                	mov    %eax,%eax
  8025c1:	48 01 d0             	add    %rdx,%rax
  8025c4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025c7:	83 c2 08             	add    $0x8,%edx
  8025ca:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025cd:	eb 0f                	jmp    8025de <vprintfmt+0x135>
  8025cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025d3:	48 89 d0             	mov    %rdx,%rax
  8025d6:	48 83 c2 08          	add    $0x8,%rdx
  8025da:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025de:	8b 00                	mov    (%rax),%eax
  8025e0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8025e3:	eb 23                	jmp    802608 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8025e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025e9:	79 0c                	jns    8025f7 <vprintfmt+0x14e>
				width = 0;
  8025eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8025f2:	e9 3b ff ff ff       	jmpq   802532 <vprintfmt+0x89>
  8025f7:	e9 36 ff ff ff       	jmpq   802532 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8025fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802603:	e9 2a ff ff ff       	jmpq   802532 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802608:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80260c:	79 12                	jns    802620 <vprintfmt+0x177>
				width = precision, precision = -1;
  80260e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802611:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802614:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80261b:	e9 12 ff ff ff       	jmpq   802532 <vprintfmt+0x89>
  802620:	e9 0d ff ff ff       	jmpq   802532 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802625:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802629:	e9 04 ff ff ff       	jmpq   802532 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80262e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802631:	83 f8 30             	cmp    $0x30,%eax
  802634:	73 17                	jae    80264d <vprintfmt+0x1a4>
  802636:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80263a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80263d:	89 c0                	mov    %eax,%eax
  80263f:	48 01 d0             	add    %rdx,%rax
  802642:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802645:	83 c2 08             	add    $0x8,%edx
  802648:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80264b:	eb 0f                	jmp    80265c <vprintfmt+0x1b3>
  80264d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802651:	48 89 d0             	mov    %rdx,%rax
  802654:	48 83 c2 08          	add    $0x8,%rdx
  802658:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80265c:	8b 10                	mov    (%rax),%edx
  80265e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802662:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802666:	48 89 ce             	mov    %rcx,%rsi
  802669:	89 d7                	mov    %edx,%edi
  80266b:	ff d0                	callq  *%rax
			break;
  80266d:	e9 53 03 00 00       	jmpq   8029c5 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802672:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802675:	83 f8 30             	cmp    $0x30,%eax
  802678:	73 17                	jae    802691 <vprintfmt+0x1e8>
  80267a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80267e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802681:	89 c0                	mov    %eax,%eax
  802683:	48 01 d0             	add    %rdx,%rax
  802686:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802689:	83 c2 08             	add    $0x8,%edx
  80268c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80268f:	eb 0f                	jmp    8026a0 <vprintfmt+0x1f7>
  802691:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802695:	48 89 d0             	mov    %rdx,%rax
  802698:	48 83 c2 08          	add    $0x8,%rdx
  80269c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026a0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8026a2:	85 db                	test   %ebx,%ebx
  8026a4:	79 02                	jns    8026a8 <vprintfmt+0x1ff>
				err = -err;
  8026a6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8026a8:	83 fb 15             	cmp    $0x15,%ebx
  8026ab:	7f 16                	jg     8026c3 <vprintfmt+0x21a>
  8026ad:	48 b8 60 3a 80 00 00 	movabs $0x803a60,%rax
  8026b4:	00 00 00 
  8026b7:	48 63 d3             	movslq %ebx,%rdx
  8026ba:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8026be:	4d 85 e4             	test   %r12,%r12
  8026c1:	75 2e                	jne    8026f1 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8026c3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8026c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026cb:	89 d9                	mov    %ebx,%ecx
  8026cd:	48 ba 21 3b 80 00 00 	movabs $0x803b21,%rdx
  8026d4:	00 00 00 
  8026d7:	48 89 c7             	mov    %rax,%rdi
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	49 b8 d4 29 80 00 00 	movabs $0x8029d4,%r8
  8026e6:	00 00 00 
  8026e9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8026ec:	e9 d4 02 00 00       	jmpq   8029c5 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8026f1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8026f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026f9:	4c 89 e1             	mov    %r12,%rcx
  8026fc:	48 ba 2a 3b 80 00 00 	movabs $0x803b2a,%rdx
  802703:	00 00 00 
  802706:	48 89 c7             	mov    %rax,%rdi
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
  80270e:	49 b8 d4 29 80 00 00 	movabs $0x8029d4,%r8
  802715:	00 00 00 
  802718:	41 ff d0             	callq  *%r8
			break;
  80271b:	e9 a5 02 00 00       	jmpq   8029c5 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802720:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802723:	83 f8 30             	cmp    $0x30,%eax
  802726:	73 17                	jae    80273f <vprintfmt+0x296>
  802728:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80272c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80272f:	89 c0                	mov    %eax,%eax
  802731:	48 01 d0             	add    %rdx,%rax
  802734:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802737:	83 c2 08             	add    $0x8,%edx
  80273a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80273d:	eb 0f                	jmp    80274e <vprintfmt+0x2a5>
  80273f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802743:	48 89 d0             	mov    %rdx,%rax
  802746:	48 83 c2 08          	add    $0x8,%rdx
  80274a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80274e:	4c 8b 20             	mov    (%rax),%r12
  802751:	4d 85 e4             	test   %r12,%r12
  802754:	75 0a                	jne    802760 <vprintfmt+0x2b7>
				p = "(null)";
  802756:	49 bc 2d 3b 80 00 00 	movabs $0x803b2d,%r12
  80275d:	00 00 00 
			if (width > 0 && padc != '-')
  802760:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802764:	7e 3f                	jle    8027a5 <vprintfmt+0x2fc>
  802766:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80276a:	74 39                	je     8027a5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80276c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80276f:	48 98                	cltq   
  802771:	48 89 c6             	mov    %rax,%rsi
  802774:	4c 89 e7             	mov    %r12,%rdi
  802777:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802786:	eb 17                	jmp    80279f <vprintfmt+0x2f6>
					putch(padc, putdat);
  802788:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80278c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802790:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802794:	48 89 ce             	mov    %rcx,%rsi
  802797:	89 d7                	mov    %edx,%edi
  802799:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80279b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80279f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8027a3:	7f e3                	jg     802788 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8027a5:	eb 37                	jmp    8027de <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8027a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8027ab:	74 1e                	je     8027cb <vprintfmt+0x322>
  8027ad:	83 fb 1f             	cmp    $0x1f,%ebx
  8027b0:	7e 05                	jle    8027b7 <vprintfmt+0x30e>
  8027b2:	83 fb 7e             	cmp    $0x7e,%ebx
  8027b5:	7e 14                	jle    8027cb <vprintfmt+0x322>
					putch('?', putdat);
  8027b7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027bf:	48 89 d6             	mov    %rdx,%rsi
  8027c2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8027c7:	ff d0                	callq  *%rax
  8027c9:	eb 0f                	jmp    8027da <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8027cb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027d3:	48 89 d6             	mov    %rdx,%rsi
  8027d6:	89 df                	mov    %ebx,%edi
  8027d8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8027da:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8027de:	4c 89 e0             	mov    %r12,%rax
  8027e1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8027e5:	0f b6 00             	movzbl (%rax),%eax
  8027e8:	0f be d8             	movsbl %al,%ebx
  8027eb:	85 db                	test   %ebx,%ebx
  8027ed:	74 10                	je     8027ff <vprintfmt+0x356>
  8027ef:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8027f3:	78 b2                	js     8027a7 <vprintfmt+0x2fe>
  8027f5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8027f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8027fd:	79 a8                	jns    8027a7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027ff:	eb 16                	jmp    802817 <vprintfmt+0x36e>
				putch(' ', putdat);
  802801:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802805:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802809:	48 89 d6             	mov    %rdx,%rsi
  80280c:	bf 20 00 00 00       	mov    $0x20,%edi
  802811:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802813:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802817:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80281b:	7f e4                	jg     802801 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80281d:	e9 a3 01 00 00       	jmpq   8029c5 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802822:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802826:	be 03 00 00 00       	mov    $0x3,%esi
  80282b:	48 89 c7             	mov    %rax,%rdi
  80282e:	48 b8 99 23 80 00 00 	movabs $0x802399,%rax
  802835:	00 00 00 
  802838:	ff d0                	callq  *%rax
  80283a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80283e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802842:	48 85 c0             	test   %rax,%rax
  802845:	79 1d                	jns    802864 <vprintfmt+0x3bb>
				putch('-', putdat);
  802847:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80284b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80284f:	48 89 d6             	mov    %rdx,%rsi
  802852:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802857:	ff d0                	callq  *%rax
				num = -(long long) num;
  802859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285d:	48 f7 d8             	neg    %rax
  802860:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802864:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80286b:	e9 e8 00 00 00       	jmpq   802958 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802870:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802874:	be 03 00 00 00       	mov    $0x3,%esi
  802879:	48 89 c7             	mov    %rax,%rdi
  80287c:	48 b8 89 22 80 00 00 	movabs $0x802289,%rax
  802883:	00 00 00 
  802886:	ff d0                	callq  *%rax
  802888:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80288c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802893:	e9 c0 00 00 00       	jmpq   802958 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802898:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80289c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028a0:	48 89 d6             	mov    %rdx,%rsi
  8028a3:	bf 58 00 00 00       	mov    $0x58,%edi
  8028a8:	ff d0                	callq  *%rax
			putch('X', putdat);
  8028aa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028b2:	48 89 d6             	mov    %rdx,%rsi
  8028b5:	bf 58 00 00 00       	mov    $0x58,%edi
  8028ba:	ff d0                	callq  *%rax
			putch('X', putdat);
  8028bc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028c4:	48 89 d6             	mov    %rdx,%rsi
  8028c7:	bf 58 00 00 00       	mov    $0x58,%edi
  8028cc:	ff d0                	callq  *%rax
			break;
  8028ce:	e9 f2 00 00 00       	jmpq   8029c5 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  8028d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028db:	48 89 d6             	mov    %rdx,%rsi
  8028de:	bf 30 00 00 00       	mov    $0x30,%edi
  8028e3:	ff d0                	callq  *%rax
			putch('x', putdat);
  8028e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028ed:	48 89 d6             	mov    %rdx,%rsi
  8028f0:	bf 78 00 00 00       	mov    $0x78,%edi
  8028f5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8028f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8028fa:	83 f8 30             	cmp    $0x30,%eax
  8028fd:	73 17                	jae    802916 <vprintfmt+0x46d>
  8028ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802903:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802906:	89 c0                	mov    %eax,%eax
  802908:	48 01 d0             	add    %rdx,%rax
  80290b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80290e:	83 c2 08             	add    $0x8,%edx
  802911:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802914:	eb 0f                	jmp    802925 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  802916:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80291a:	48 89 d0             	mov    %rdx,%rax
  80291d:	48 83 c2 08          	add    $0x8,%rdx
  802921:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802925:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802928:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80292c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802933:	eb 23                	jmp    802958 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802935:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802939:	be 03 00 00 00       	mov    $0x3,%esi
  80293e:	48 89 c7             	mov    %rax,%rdi
  802941:	48 b8 89 22 80 00 00 	movabs $0x802289,%rax
  802948:	00 00 00 
  80294b:	ff d0                	callq  *%rax
  80294d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802951:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802958:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80295d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802960:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802963:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802967:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80296b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80296f:	45 89 c1             	mov    %r8d,%r9d
  802972:	41 89 f8             	mov    %edi,%r8d
  802975:	48 89 c7             	mov    %rax,%rdi
  802978:	48 b8 ce 21 80 00 00 	movabs $0x8021ce,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
			break;
  802984:	eb 3f                	jmp    8029c5 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802986:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80298a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80298e:	48 89 d6             	mov    %rdx,%rsi
  802991:	89 df                	mov    %ebx,%edi
  802993:	ff d0                	callq  *%rax
			break;
  802995:	eb 2e                	jmp    8029c5 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802997:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80299b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80299f:	48 89 d6             	mov    %rdx,%rsi
  8029a2:	bf 25 00 00 00       	mov    $0x25,%edi
  8029a7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8029a9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8029ae:	eb 05                	jmp    8029b5 <vprintfmt+0x50c>
  8029b0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8029b5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8029b9:	48 83 e8 01          	sub    $0x1,%rax
  8029bd:	0f b6 00             	movzbl (%rax),%eax
  8029c0:	3c 25                	cmp    $0x25,%al
  8029c2:	75 ec                	jne    8029b0 <vprintfmt+0x507>
				/* do nothing */;
			break;
  8029c4:	90                   	nop
		}
	}
  8029c5:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8029c6:	e9 30 fb ff ff       	jmpq   8024fb <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8029cb:	48 83 c4 60          	add    $0x60,%rsp
  8029cf:	5b                   	pop    %rbx
  8029d0:	41 5c                	pop    %r12
  8029d2:	5d                   	pop    %rbp
  8029d3:	c3                   	retq   

00000000008029d4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8029d4:	55                   	push   %rbp
  8029d5:	48 89 e5             	mov    %rsp,%rbp
  8029d8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8029df:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8029e6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8029ed:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8029f4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8029fb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802a02:	84 c0                	test   %al,%al
  802a04:	74 20                	je     802a26 <printfmt+0x52>
  802a06:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802a0a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802a0e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802a12:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802a16:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802a1a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802a1e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802a22:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802a26:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802a2d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802a34:	00 00 00 
  802a37:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802a3e:	00 00 00 
  802a41:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a45:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802a4c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a53:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802a5a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802a61:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802a68:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802a6f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802a76:	48 89 c7             	mov    %rax,%rdi
  802a79:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802a80:	00 00 00 
  802a83:	ff d0                	callq  *%rax
	va_end(ap);
}
  802a85:	c9                   	leaveq 
  802a86:	c3                   	retq   

0000000000802a87 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802a87:	55                   	push   %rbp
  802a88:	48 89 e5             	mov    %rsp,%rbp
  802a8b:	48 83 ec 10          	sub    $0x10,%rsp
  802a8f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a92:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802a96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9a:	8b 40 10             	mov    0x10(%rax),%eax
  802a9d:	8d 50 01             	lea    0x1(%rax),%edx
  802aa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802aa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aab:	48 8b 10             	mov    (%rax),%rdx
  802aae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab2:	48 8b 40 08          	mov    0x8(%rax),%rax
  802ab6:	48 39 c2             	cmp    %rax,%rdx
  802ab9:	73 17                	jae    802ad2 <sprintputch+0x4b>
		*b->buf++ = ch;
  802abb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abf:	48 8b 00             	mov    (%rax),%rax
  802ac2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802ac6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aca:	48 89 0a             	mov    %rcx,(%rdx)
  802acd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ad0:	88 10                	mov    %dl,(%rax)
}
  802ad2:	c9                   	leaveq 
  802ad3:	c3                   	retq   

0000000000802ad4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802ad4:	55                   	push   %rbp
  802ad5:	48 89 e5             	mov    %rsp,%rbp
  802ad8:	48 83 ec 50          	sub    $0x50,%rsp
  802adc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802ae0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802ae3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802ae7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802aeb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802aef:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802af3:	48 8b 0a             	mov    (%rdx),%rcx
  802af6:	48 89 08             	mov    %rcx,(%rax)
  802af9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802afd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b01:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b05:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802b09:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b0d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802b11:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802b14:	48 98                	cltq   
  802b16:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802b1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b1e:	48 01 d0             	add    %rdx,%rax
  802b21:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802b2c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802b31:	74 06                	je     802b39 <vsnprintf+0x65>
  802b33:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802b37:	7f 07                	jg     802b40 <vsnprintf+0x6c>
		return -E_INVAL;
  802b39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b3e:	eb 2f                	jmp    802b6f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802b40:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802b44:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802b48:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b4c:	48 89 c6             	mov    %rax,%rsi
  802b4f:	48 bf 87 2a 80 00 00 	movabs $0x802a87,%rdi
  802b56:	00 00 00 
  802b59:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802b65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b69:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802b6c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802b6f:	c9                   	leaveq 
  802b70:	c3                   	retq   

0000000000802b71 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802b71:	55                   	push   %rbp
  802b72:	48 89 e5             	mov    %rsp,%rbp
  802b75:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802b7c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802b83:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802b89:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802b90:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b97:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b9e:	84 c0                	test   %al,%al
  802ba0:	74 20                	je     802bc2 <snprintf+0x51>
  802ba2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ba6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802baa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802bae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802bb2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802bb6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802bba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802bbe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802bc2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802bc9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802bd0:	00 00 00 
  802bd3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802bda:	00 00 00 
  802bdd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802be1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802be8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802bef:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802bf6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802bfd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802c04:	48 8b 0a             	mov    (%rdx),%rcx
  802c07:	48 89 08             	mov    %rcx,(%rax)
  802c0a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802c0e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802c12:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802c16:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802c1a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802c21:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802c28:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802c2e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802c35:	48 89 c7             	mov    %rax,%rdi
  802c38:	48 b8 d4 2a 80 00 00 	movabs $0x802ad4,%rax
  802c3f:	00 00 00 
  802c42:	ff d0                	callq  *%rax
  802c44:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802c4a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802c50:	c9                   	leaveq 
  802c51:	c3                   	retq   

0000000000802c52 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802c52:	55                   	push   %rbp
  802c53:	48 89 e5             	mov    %rsp,%rbp
  802c56:	48 83 ec 18          	sub    $0x18,%rsp
  802c5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c65:	eb 09                	jmp    802c70 <strlen+0x1e>
		n++;
  802c67:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802c6b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c74:	0f b6 00             	movzbl (%rax),%eax
  802c77:	84 c0                	test   %al,%al
  802c79:	75 ec                	jne    802c67 <strlen+0x15>
		n++;
	return n;
  802c7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c7e:	c9                   	leaveq 
  802c7f:	c3                   	retq   

0000000000802c80 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802c80:	55                   	push   %rbp
  802c81:	48 89 e5             	mov    %rsp,%rbp
  802c84:	48 83 ec 20          	sub    $0x20,%rsp
  802c88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c97:	eb 0e                	jmp    802ca7 <strnlen+0x27>
		n++;
  802c99:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c9d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802ca2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802ca7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802cac:	74 0b                	je     802cb9 <strnlen+0x39>
  802cae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb2:	0f b6 00             	movzbl (%rax),%eax
  802cb5:	84 c0                	test   %al,%al
  802cb7:	75 e0                	jne    802c99 <strnlen+0x19>
		n++;
	return n;
  802cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cbc:	c9                   	leaveq 
  802cbd:	c3                   	retq   

0000000000802cbe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802cbe:	55                   	push   %rbp
  802cbf:	48 89 e5             	mov    %rsp,%rbp
  802cc2:	48 83 ec 20          	sub    $0x20,%rsp
  802cc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802cd6:	90                   	nop
  802cd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cdf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ce3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ce7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802ceb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802cef:	0f b6 12             	movzbl (%rdx),%edx
  802cf2:	88 10                	mov    %dl,(%rax)
  802cf4:	0f b6 00             	movzbl (%rax),%eax
  802cf7:	84 c0                	test   %al,%al
  802cf9:	75 dc                	jne    802cd7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802cfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cff:	c9                   	leaveq 
  802d00:	c3                   	retq   

0000000000802d01 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802d01:	55                   	push   %rbp
  802d02:	48 89 e5             	mov    %rsp,%rbp
  802d05:	48 83 ec 20          	sub    $0x20,%rsp
  802d09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d15:	48 89 c7             	mov    %rax,%rdi
  802d18:	48 b8 52 2c 80 00 00 	movabs $0x802c52,%rax
  802d1f:	00 00 00 
  802d22:	ff d0                	callq  *%rax
  802d24:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802d27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2a:	48 63 d0             	movslq %eax,%rdx
  802d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d31:	48 01 c2             	add    %rax,%rdx
  802d34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d38:	48 89 c6             	mov    %rax,%rsi
  802d3b:	48 89 d7             	mov    %rdx,%rdi
  802d3e:	48 b8 be 2c 80 00 00 	movabs $0x802cbe,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax
	return dst;
  802d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802d4e:	c9                   	leaveq 
  802d4f:	c3                   	retq   

0000000000802d50 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802d50:	55                   	push   %rbp
  802d51:	48 89 e5             	mov    %rsp,%rbp
  802d54:	48 83 ec 28          	sub    $0x28,%rsp
  802d58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d60:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d68:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802d6c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d73:	00 
  802d74:	eb 2a                	jmp    802da0 <strncpy+0x50>
		*dst++ = *src;
  802d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d82:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d86:	0f b6 12             	movzbl (%rdx),%edx
  802d89:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802d8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d8f:	0f b6 00             	movzbl (%rax),%eax
  802d92:	84 c0                	test   %al,%al
  802d94:	74 05                	je     802d9b <strncpy+0x4b>
			src++;
  802d96:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d9b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802da8:	72 cc                	jb     802d76 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802dae:	c9                   	leaveq 
  802daf:	c3                   	retq   

0000000000802db0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802db0:	55                   	push   %rbp
  802db1:	48 89 e5             	mov    %rsp,%rbp
  802db4:	48 83 ec 28          	sub    $0x28,%rsp
  802db8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dc0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802dcc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802dd1:	74 3d                	je     802e10 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802dd3:	eb 1d                	jmp    802df2 <strlcpy+0x42>
			*dst++ = *src++;
  802dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802ddd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802de1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802de5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802de9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802ded:	0f b6 12             	movzbl (%rdx),%edx
  802df0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802df2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802df7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802dfc:	74 0b                	je     802e09 <strlcpy+0x59>
  802dfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e02:	0f b6 00             	movzbl (%rax),%eax
  802e05:	84 c0                	test   %al,%al
  802e07:	75 cc                	jne    802dd5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802e10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e18:	48 29 c2             	sub    %rax,%rdx
  802e1b:	48 89 d0             	mov    %rdx,%rax
}
  802e1e:	c9                   	leaveq 
  802e1f:	c3                   	retq   

0000000000802e20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802e20:	55                   	push   %rbp
  802e21:	48 89 e5             	mov    %rsp,%rbp
  802e24:	48 83 ec 10          	sub    $0x10,%rsp
  802e28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802e30:	eb 0a                	jmp    802e3c <strcmp+0x1c>
		p++, q++;
  802e32:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e37:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802e3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e40:	0f b6 00             	movzbl (%rax),%eax
  802e43:	84 c0                	test   %al,%al
  802e45:	74 12                	je     802e59 <strcmp+0x39>
  802e47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4b:	0f b6 10             	movzbl (%rax),%edx
  802e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e52:	0f b6 00             	movzbl (%rax),%eax
  802e55:	38 c2                	cmp    %al,%dl
  802e57:	74 d9                	je     802e32 <strcmp+0x12>
		p++, q++;
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

0000000000802e73 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 18          	sub    $0x18,%rsp
  802e7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e83:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802e87:	eb 0f                	jmp    802e98 <strncmp+0x25>
		n--, p++, q++;
  802e89:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802e8e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e93:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e98:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e9d:	74 1d                	je     802ebc <strncmp+0x49>
  802e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea3:	0f b6 00             	movzbl (%rax),%eax
  802ea6:	84 c0                	test   %al,%al
  802ea8:	74 12                	je     802ebc <strncmp+0x49>
  802eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eae:	0f b6 10             	movzbl (%rax),%edx
  802eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb5:	0f b6 00             	movzbl (%rax),%eax
  802eb8:	38 c2                	cmp    %al,%dl
  802eba:	74 cd                	je     802e89 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802ebc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ec1:	75 07                	jne    802eca <strncmp+0x57>
		return 0;
  802ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec8:	eb 18                	jmp    802ee2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802eca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ece:	0f b6 00             	movzbl (%rax),%eax
  802ed1:	0f b6 d0             	movzbl %al,%edx
  802ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed8:	0f b6 00             	movzbl (%rax),%eax
  802edb:	0f b6 c0             	movzbl %al,%eax
  802ede:	29 c2                	sub    %eax,%edx
  802ee0:	89 d0                	mov    %edx,%eax
}
  802ee2:	c9                   	leaveq 
  802ee3:	c3                   	retq   

0000000000802ee4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802ee4:	55                   	push   %rbp
  802ee5:	48 89 e5             	mov    %rsp,%rbp
  802ee8:	48 83 ec 0c          	sub    $0xc,%rsp
  802eec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ef0:	89 f0                	mov    %esi,%eax
  802ef2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802ef5:	eb 17                	jmp    802f0e <strchr+0x2a>
		if (*s == c)
  802ef7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802efb:	0f b6 00             	movzbl (%rax),%eax
  802efe:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802f01:	75 06                	jne    802f09 <strchr+0x25>
			return (char *) s;
  802f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f07:	eb 15                	jmp    802f1e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802f09:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f12:	0f b6 00             	movzbl (%rax),%eax
  802f15:	84 c0                	test   %al,%al
  802f17:	75 de                	jne    802ef7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f1e:	c9                   	leaveq 
  802f1f:	c3                   	retq   

0000000000802f20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802f20:	55                   	push   %rbp
  802f21:	48 89 e5             	mov    %rsp,%rbp
  802f24:	48 83 ec 0c          	sub    $0xc,%rsp
  802f28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f2c:	89 f0                	mov    %esi,%eax
  802f2e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802f31:	eb 13                	jmp    802f46 <strfind+0x26>
		if (*s == c)
  802f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f37:	0f b6 00             	movzbl (%rax),%eax
  802f3a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802f3d:	75 02                	jne    802f41 <strfind+0x21>
			break;
  802f3f:	eb 10                	jmp    802f51 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802f41:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4a:	0f b6 00             	movzbl (%rax),%eax
  802f4d:	84 c0                	test   %al,%al
  802f4f:	75 e2                	jne    802f33 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f55:	c9                   	leaveq 
  802f56:	c3                   	retq   

0000000000802f57 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802f57:	55                   	push   %rbp
  802f58:	48 89 e5             	mov    %rsp,%rbp
  802f5b:	48 83 ec 18          	sub    $0x18,%rsp
  802f5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f63:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802f66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802f6a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f6f:	75 06                	jne    802f77 <memset+0x20>
		return v;
  802f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f75:	eb 69                	jmp    802fe0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802f77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f7b:	83 e0 03             	and    $0x3,%eax
  802f7e:	48 85 c0             	test   %rax,%rax
  802f81:	75 48                	jne    802fcb <memset+0x74>
  802f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f87:	83 e0 03             	and    $0x3,%eax
  802f8a:	48 85 c0             	test   %rax,%rax
  802f8d:	75 3c                	jne    802fcb <memset+0x74>
		c &= 0xFF;
  802f8f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802f96:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f99:	c1 e0 18             	shl    $0x18,%eax
  802f9c:	89 c2                	mov    %eax,%edx
  802f9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fa1:	c1 e0 10             	shl    $0x10,%eax
  802fa4:	09 c2                	or     %eax,%edx
  802fa6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fa9:	c1 e0 08             	shl    $0x8,%eax
  802fac:	09 d0                	or     %edx,%eax
  802fae:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802fb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb5:	48 c1 e8 02          	shr    $0x2,%rax
  802fb9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802fbc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fc0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fc3:	48 89 d7             	mov    %rdx,%rdi
  802fc6:	fc                   	cld    
  802fc7:	f3 ab                	rep stos %eax,%es:(%rdi)
  802fc9:	eb 11                	jmp    802fdc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802fcb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fcf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fd2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fd6:	48 89 d7             	mov    %rdx,%rdi
  802fd9:	fc                   	cld    
  802fda:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802fe0:	c9                   	leaveq 
  802fe1:	c3                   	retq   

0000000000802fe2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802fe2:	55                   	push   %rbp
  802fe3:	48 89 e5             	mov    %rsp,%rbp
  802fe6:	48 83 ec 28          	sub    $0x28,%rsp
  802fea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802ff6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802ffe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803002:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  803006:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80300e:	0f 83 88 00 00 00    	jae    80309c <memmove+0xba>
  803014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803018:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80301c:	48 01 d0             	add    %rdx,%rax
  80301f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803023:	76 77                	jbe    80309c <memmove+0xba>
		s += n;
  803025:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803029:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80302d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803031:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803039:	83 e0 03             	and    $0x3,%eax
  80303c:	48 85 c0             	test   %rax,%rax
  80303f:	75 3b                	jne    80307c <memmove+0x9a>
  803041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803045:	83 e0 03             	and    $0x3,%eax
  803048:	48 85 c0             	test   %rax,%rax
  80304b:	75 2f                	jne    80307c <memmove+0x9a>
  80304d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803051:	83 e0 03             	and    $0x3,%eax
  803054:	48 85 c0             	test   %rax,%rax
  803057:	75 23                	jne    80307c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305d:	48 83 e8 04          	sub    $0x4,%rax
  803061:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803065:	48 83 ea 04          	sub    $0x4,%rdx
  803069:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80306d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803071:	48 89 c7             	mov    %rax,%rdi
  803074:	48 89 d6             	mov    %rdx,%rsi
  803077:	fd                   	std    
  803078:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80307a:	eb 1d                	jmp    803099 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80307c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803080:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803088:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80308c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803090:	48 89 d7             	mov    %rdx,%rdi
  803093:	48 89 c1             	mov    %rax,%rcx
  803096:	fd                   	std    
  803097:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803099:	fc                   	cld    
  80309a:	eb 57                	jmp    8030f3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80309c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a0:	83 e0 03             	and    $0x3,%eax
  8030a3:	48 85 c0             	test   %rax,%rax
  8030a6:	75 36                	jne    8030de <memmove+0xfc>
  8030a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ac:	83 e0 03             	and    $0x3,%eax
  8030af:	48 85 c0             	test   %rax,%rax
  8030b2:	75 2a                	jne    8030de <memmove+0xfc>
  8030b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b8:	83 e0 03             	and    $0x3,%eax
  8030bb:	48 85 c0             	test   %rax,%rax
  8030be:	75 1e                	jne    8030de <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8030c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c4:	48 c1 e8 02          	shr    $0x2,%rax
  8030c8:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8030cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030d3:	48 89 c7             	mov    %rax,%rdi
  8030d6:	48 89 d6             	mov    %rdx,%rsi
  8030d9:	fc                   	cld    
  8030da:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8030dc:	eb 15                	jmp    8030f3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8030de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030e6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8030ea:	48 89 c7             	mov    %rax,%rdi
  8030ed:	48 89 d6             	mov    %rdx,%rsi
  8030f0:	fc                   	cld    
  8030f1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8030f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8030f7:	c9                   	leaveq 
  8030f8:	c3                   	retq   

00000000008030f9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8030f9:	55                   	push   %rbp
  8030fa:	48 89 e5             	mov    %rsp,%rbp
  8030fd:	48 83 ec 18          	sub    $0x18,%rsp
  803101:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803105:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803109:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80310d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803111:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803119:	48 89 ce             	mov    %rcx,%rsi
  80311c:	48 89 c7             	mov    %rax,%rdi
  80311f:	48 b8 e2 2f 80 00 00 	movabs $0x802fe2,%rax
  803126:	00 00 00 
  803129:	ff d0                	callq  *%rax
}
  80312b:	c9                   	leaveq 
  80312c:	c3                   	retq   

000000000080312d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80312d:	55                   	push   %rbp
  80312e:	48 89 e5             	mov    %rsp,%rbp
  803131:	48 83 ec 28          	sub    $0x28,%rsp
  803135:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803139:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80313d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803145:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803149:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803151:	eb 36                	jmp    803189 <memcmp+0x5c>
		if (*s1 != *s2)
  803153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803157:	0f b6 10             	movzbl (%rax),%edx
  80315a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315e:	0f b6 00             	movzbl (%rax),%eax
  803161:	38 c2                	cmp    %al,%dl
  803163:	74 1a                	je     80317f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803169:	0f b6 00             	movzbl (%rax),%eax
  80316c:	0f b6 d0             	movzbl %al,%edx
  80316f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803173:	0f b6 00             	movzbl (%rax),%eax
  803176:	0f b6 c0             	movzbl %al,%eax
  803179:	29 c2                	sub    %eax,%edx
  80317b:	89 d0                	mov    %edx,%eax
  80317d:	eb 20                	jmp    80319f <memcmp+0x72>
		s1++, s2++;
  80317f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803184:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803189:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803191:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803195:	48 85 c0             	test   %rax,%rax
  803198:	75 b9                	jne    803153 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 83 ec 28          	sub    $0x28,%rsp
  8031a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ad:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8031b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8031b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031bc:	48 01 d0             	add    %rdx,%rax
  8031bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8031c3:	eb 15                	jmp    8031da <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8031c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c9:	0f b6 10             	movzbl (%rax),%edx
  8031cc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031cf:	38 c2                	cmp    %al,%dl
  8031d1:	75 02                	jne    8031d5 <memfind+0x34>
			break;
  8031d3:	eb 0f                	jmp    8031e4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8031d5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8031da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031de:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8031e2:	72 e1                	jb     8031c5 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8031e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8031e8:	c9                   	leaveq 
  8031e9:	c3                   	retq   

00000000008031ea <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8031ea:	55                   	push   %rbp
  8031eb:	48 89 e5             	mov    %rsp,%rbp
  8031ee:	48 83 ec 34          	sub    $0x34,%rsp
  8031f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031fa:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8031fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803204:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80320b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80320c:	eb 05                	jmp    803213 <strtol+0x29>
		s++;
  80320e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803213:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803217:	0f b6 00             	movzbl (%rax),%eax
  80321a:	3c 20                	cmp    $0x20,%al
  80321c:	74 f0                	je     80320e <strtol+0x24>
  80321e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803222:	0f b6 00             	movzbl (%rax),%eax
  803225:	3c 09                	cmp    $0x9,%al
  803227:	74 e5                	je     80320e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803229:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322d:	0f b6 00             	movzbl (%rax),%eax
  803230:	3c 2b                	cmp    $0x2b,%al
  803232:	75 07                	jne    80323b <strtol+0x51>
		s++;
  803234:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803239:	eb 17                	jmp    803252 <strtol+0x68>
	else if (*s == '-')
  80323b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323f:	0f b6 00             	movzbl (%rax),%eax
  803242:	3c 2d                	cmp    $0x2d,%al
  803244:	75 0c                	jne    803252 <strtol+0x68>
		s++, neg = 1;
  803246:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80324b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803252:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803256:	74 06                	je     80325e <strtol+0x74>
  803258:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80325c:	75 28                	jne    803286 <strtol+0x9c>
  80325e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803262:	0f b6 00             	movzbl (%rax),%eax
  803265:	3c 30                	cmp    $0x30,%al
  803267:	75 1d                	jne    803286 <strtol+0x9c>
  803269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326d:	48 83 c0 01          	add    $0x1,%rax
  803271:	0f b6 00             	movzbl (%rax),%eax
  803274:	3c 78                	cmp    $0x78,%al
  803276:	75 0e                	jne    803286 <strtol+0x9c>
		s += 2, base = 16;
  803278:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80327d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803284:	eb 2c                	jmp    8032b2 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803286:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80328a:	75 19                	jne    8032a5 <strtol+0xbb>
  80328c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803290:	0f b6 00             	movzbl (%rax),%eax
  803293:	3c 30                	cmp    $0x30,%al
  803295:	75 0e                	jne    8032a5 <strtol+0xbb>
		s++, base = 8;
  803297:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80329c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8032a3:	eb 0d                	jmp    8032b2 <strtol+0xc8>
	else if (base == 0)
  8032a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8032a9:	75 07                	jne    8032b2 <strtol+0xc8>
		base = 10;
  8032ab:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8032b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b6:	0f b6 00             	movzbl (%rax),%eax
  8032b9:	3c 2f                	cmp    $0x2f,%al
  8032bb:	7e 1d                	jle    8032da <strtol+0xf0>
  8032bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c1:	0f b6 00             	movzbl (%rax),%eax
  8032c4:	3c 39                	cmp    $0x39,%al
  8032c6:	7f 12                	jg     8032da <strtol+0xf0>
			dig = *s - '0';
  8032c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032cc:	0f b6 00             	movzbl (%rax),%eax
  8032cf:	0f be c0             	movsbl %al,%eax
  8032d2:	83 e8 30             	sub    $0x30,%eax
  8032d5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032d8:	eb 4e                	jmp    803328 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8032da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032de:	0f b6 00             	movzbl (%rax),%eax
  8032e1:	3c 60                	cmp    $0x60,%al
  8032e3:	7e 1d                	jle    803302 <strtol+0x118>
  8032e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e9:	0f b6 00             	movzbl (%rax),%eax
  8032ec:	3c 7a                	cmp    $0x7a,%al
  8032ee:	7f 12                	jg     803302 <strtol+0x118>
			dig = *s - 'a' + 10;
  8032f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f4:	0f b6 00             	movzbl (%rax),%eax
  8032f7:	0f be c0             	movsbl %al,%eax
  8032fa:	83 e8 57             	sub    $0x57,%eax
  8032fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803300:	eb 26                	jmp    803328 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803306:	0f b6 00             	movzbl (%rax),%eax
  803309:	3c 40                	cmp    $0x40,%al
  80330b:	7e 48                	jle    803355 <strtol+0x16b>
  80330d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803311:	0f b6 00             	movzbl (%rax),%eax
  803314:	3c 5a                	cmp    $0x5a,%al
  803316:	7f 3d                	jg     803355 <strtol+0x16b>
			dig = *s - 'A' + 10;
  803318:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331c:	0f b6 00             	movzbl (%rax),%eax
  80331f:	0f be c0             	movsbl %al,%eax
  803322:	83 e8 37             	sub    $0x37,%eax
  803325:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80332b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80332e:	7c 02                	jl     803332 <strtol+0x148>
			break;
  803330:	eb 23                	jmp    803355 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803332:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803337:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80333a:	48 98                	cltq   
  80333c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803341:	48 89 c2             	mov    %rax,%rdx
  803344:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803347:	48 98                	cltq   
  803349:	48 01 d0             	add    %rdx,%rax
  80334c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803350:	e9 5d ff ff ff       	jmpq   8032b2 <strtol+0xc8>

	if (endptr)
  803355:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80335a:	74 0b                	je     803367 <strtol+0x17d>
		*endptr = (char *) s;
  80335c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803360:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803364:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803367:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336b:	74 09                	je     803376 <strtol+0x18c>
  80336d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803371:	48 f7 d8             	neg    %rax
  803374:	eb 04                	jmp    80337a <strtol+0x190>
  803376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80337a:	c9                   	leaveq 
  80337b:	c3                   	retq   

000000000080337c <strstr>:

char * strstr(const char *in, const char *str)
{
  80337c:	55                   	push   %rbp
  80337d:	48 89 e5             	mov    %rsp,%rbp
  803380:	48 83 ec 30          	sub    $0x30,%rsp
  803384:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803388:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80338c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803390:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803394:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803398:	0f b6 00             	movzbl (%rax),%eax
  80339b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80339e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8033a2:	75 06                	jne    8033aa <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8033a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a8:	eb 6b                	jmp    803415 <strstr+0x99>

	len = strlen(str);
  8033aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ae:	48 89 c7             	mov    %rax,%rdi
  8033b1:	48 b8 52 2c 80 00 00 	movabs $0x802c52,%rax
  8033b8:	00 00 00 
  8033bb:	ff d0                	callq  *%rax
  8033bd:	48 98                	cltq   
  8033bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8033c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8033cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8033cf:	0f b6 00             	movzbl (%rax),%eax
  8033d2:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8033d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8033d9:	75 07                	jne    8033e2 <strstr+0x66>
				return (char *) 0;
  8033db:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e0:	eb 33                	jmp    803415 <strstr+0x99>
		} while (sc != c);
  8033e2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8033e6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8033e9:	75 d8                	jne    8033c3 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8033eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033ef:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8033f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f7:	48 89 ce             	mov    %rcx,%rsi
  8033fa:	48 89 c7             	mov    %rax,%rdi
  8033fd:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  803404:	00 00 00 
  803407:	ff d0                	callq  *%rax
  803409:	85 c0                	test   %eax,%eax
  80340b:	75 b6                	jne    8033c3 <strstr+0x47>

	return (char *) (in - 1);
  80340d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803411:	48 83 e8 01          	sub    $0x1,%rax
}
  803415:	c9                   	leaveq 
  803416:	c3                   	retq   

0000000000803417 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803417:	55                   	push   %rbp
  803418:	48 89 e5             	mov    %rsp,%rbp
  80341b:	48 83 ec 10          	sub    $0x10,%rsp
  80341f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803423:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80342a:	00 00 00 
  80342d:	48 8b 00             	mov    (%rax),%rax
  803430:	48 85 c0             	test   %rax,%rax
  803433:	75 49                	jne    80347e <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803435:	ba 07 00 00 00       	mov    $0x7,%edx
  80343a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80343f:	bf 00 00 00 00       	mov    $0x0,%edi
  803444:	48 b8 04 03 80 00 00 	movabs $0x800304,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	85 c0                	test   %eax,%eax
  803452:	79 2a                	jns    80347e <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803454:	48 ba e8 3d 80 00 00 	movabs $0x803de8,%rdx
  80345b:	00 00 00 
  80345e:	be 21 00 00 00       	mov    $0x21,%esi
  803463:	48 bf 13 3e 80 00 00 	movabs $0x803e13,%rdi
  80346a:	00 00 00 
  80346d:	b8 00 00 00 00       	mov    $0x0,%eax
  803472:	48 b9 bd 1e 80 00 00 	movabs $0x801ebd,%rcx
  803479:	00 00 00 
  80347c:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80347e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803485:	00 00 00 
  803488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80348c:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80348f:	48 be 71 05 80 00 00 	movabs $0x800571,%rsi
  803496:	00 00 00 
  803499:	bf 00 00 00 00       	mov    $0x0,%edi
  80349e:	48 b8 8e 04 80 00 00 	movabs $0x80048e,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	79 2a                	jns    8034d8 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8034ae:	48 ba 28 3e 80 00 00 	movabs $0x803e28,%rdx
  8034b5:	00 00 00 
  8034b8:	be 27 00 00 00       	mov    $0x27,%esi
  8034bd:	48 bf 13 3e 80 00 00 	movabs $0x803e13,%rdi
  8034c4:	00 00 00 
  8034c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cc:	48 b9 bd 1e 80 00 00 	movabs $0x801ebd,%rcx
  8034d3:	00 00 00 
  8034d6:	ff d1                	callq  *%rcx
}
  8034d8:	c9                   	leaveq 
  8034d9:	c3                   	retq   

00000000008034da <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034da:	55                   	push   %rbp
  8034db:	48 89 e5             	mov    %rsp,%rbp
  8034de:	48 83 ec 30          	sub    $0x30,%rsp
  8034e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8034ee:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034f3:	75 0e                	jne    803503 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8034f5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034fc:	00 00 00 
  8034ff:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803507:	48 89 c7             	mov    %rax,%rdi
  80350a:	48 b8 2d 05 80 00 00 	movabs $0x80052d,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
  803516:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803519:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351d:	79 27                	jns    803546 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80351f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803524:	74 0a                	je     803530 <ipc_recv+0x56>
            *from_env_store = 0;
  803526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803530:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803535:	74 0a                	je     803541 <ipc_recv+0x67>
            *perm_store = 0;
  803537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80353b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803544:	eb 53                	jmp    803599 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803546:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80354b:	74 19                	je     803566 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80354d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803554:	00 00 00 
  803557:	48 8b 00             	mov    (%rax),%rax
  80355a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803564:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803566:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80356b:	74 19                	je     803586 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80356d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803574:	00 00 00 
  803577:	48 8b 00             	mov    (%rax),%rax
  80357a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803584:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803586:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80358d:	00 00 00 
  803590:	48 8b 00             	mov    (%rax),%rax
  803593:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803599:	c9                   	leaveq 
  80359a:	c3                   	retq   

000000000080359b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80359b:	55                   	push   %rbp
  80359c:	48 89 e5             	mov    %rsp,%rbp
  80359f:	48 83 ec 30          	sub    $0x30,%rsp
  8035a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035a6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035a9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8035ad:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8035b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035b5:	75 0e                	jne    8035c5 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8035b7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8035be:	00 00 00 
  8035c1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8035c5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8035c8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8035cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d2:	89 c7                	mov    %eax,%edi
  8035d4:	48 b8 d8 04 80 00 00 	movabs $0x8004d8,%rax
  8035db:	00 00 00 
  8035de:	ff d0                	callq  *%rax
  8035e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8035e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e7:	79 36                	jns    80361f <ipc_send+0x84>
  8035e9:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8035ed:	74 30                	je     80361f <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8035ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f2:	89 c1                	mov    %eax,%ecx
  8035f4:	48 ba 5f 3e 80 00 00 	movabs $0x803e5f,%rdx
  8035fb:	00 00 00 
  8035fe:	be 49 00 00 00       	mov    $0x49,%esi
  803603:	48 bf 6c 3e 80 00 00 	movabs $0x803e6c,%rdi
  80360a:	00 00 00 
  80360d:	b8 00 00 00 00       	mov    $0x0,%eax
  803612:	49 b8 bd 1e 80 00 00 	movabs $0x801ebd,%r8
  803619:	00 00 00 
  80361c:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80361f:	48 b8 c6 02 80 00 00 	movabs $0x8002c6,%rax
  803626:	00 00 00 
  803629:	ff d0                	callq  *%rax
    } while(r != 0);
  80362b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80362f:	75 94                	jne    8035c5 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803631:	c9                   	leaveq 
  803632:	c3                   	retq   

0000000000803633 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803633:	55                   	push   %rbp
  803634:	48 89 e5             	mov    %rsp,%rbp
  803637:	48 83 ec 14          	sub    $0x14,%rsp
  80363b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80363e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803645:	eb 5e                	jmp    8036a5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803647:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80364e:	00 00 00 
  803651:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803654:	48 63 d0             	movslq %eax,%rdx
  803657:	48 89 d0             	mov    %rdx,%rax
  80365a:	48 c1 e0 03          	shl    $0x3,%rax
  80365e:	48 01 d0             	add    %rdx,%rax
  803661:	48 c1 e0 05          	shl    $0x5,%rax
  803665:	48 01 c8             	add    %rcx,%rax
  803668:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80366e:	8b 00                	mov    (%rax),%eax
  803670:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803673:	75 2c                	jne    8036a1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803675:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80367c:	00 00 00 
  80367f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803682:	48 63 d0             	movslq %eax,%rdx
  803685:	48 89 d0             	mov    %rdx,%rax
  803688:	48 c1 e0 03          	shl    $0x3,%rax
  80368c:	48 01 d0             	add    %rdx,%rax
  80368f:	48 c1 e0 05          	shl    $0x5,%rax
  803693:	48 01 c8             	add    %rcx,%rax
  803696:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80369c:	8b 40 08             	mov    0x8(%rax),%eax
  80369f:	eb 12                	jmp    8036b3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8036a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8036a5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8036ac:	7e 99                	jle    803647 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8036ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036b3:	c9                   	leaveq 
  8036b4:	c3                   	retq   

00000000008036b5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8036b5:	55                   	push   %rbp
  8036b6:	48 89 e5             	mov    %rsp,%rbp
  8036b9:	48 83 ec 18          	sub    $0x18,%rsp
  8036bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8036c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c5:	48 c1 e8 15          	shr    $0x15,%rax
  8036c9:	48 89 c2             	mov    %rax,%rdx
  8036cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036d3:	01 00 00 
  8036d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036da:	83 e0 01             	and    $0x1,%eax
  8036dd:	48 85 c0             	test   %rax,%rax
  8036e0:	75 07                	jne    8036e9 <pageref+0x34>
		return 0;
  8036e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e7:	eb 53                	jmp    80373c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8036e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8036f1:	48 89 c2             	mov    %rax,%rdx
  8036f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036fb:	01 00 00 
  8036fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803702:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370a:	83 e0 01             	and    $0x1,%eax
  80370d:	48 85 c0             	test   %rax,%rax
  803710:	75 07                	jne    803719 <pageref+0x64>
		return 0;
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
  803717:	eb 23                	jmp    80373c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371d:	48 c1 e8 0c          	shr    $0xc,%rax
  803721:	48 89 c2             	mov    %rax,%rdx
  803724:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80372b:	00 00 00 
  80372e:	48 c1 e2 04          	shl    $0x4,%rdx
  803732:	48 01 d0             	add    %rdx,%rax
  803735:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803739:	0f b7 c0             	movzwl %ax,%eax
}
  80373c:	c9                   	leaveq 
  80373d:	c3                   	retq   
