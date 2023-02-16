
obj/user/faultwritekernel:     file format elf64-x86-64


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
  80003c:	e8 23 00 00 00       	callq  800064 <libmain>
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
	*(unsigned*)0x8004000000 = 0;
  800052:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  800059:	00 00 00 
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800062:	c9                   	leaveq 
  800063:	c3                   	retq   

0000000000800064 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800064:	55                   	push   %rbp
  800065:	48 89 e5             	mov    %rsp,%rbp
  800068:	48 83 ec 20          	sub    $0x20,%rsp
  80006c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80006f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800073:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800085:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008a:	48 63 d0             	movslq %eax,%rdx
  80008d:	48 89 d0             	mov    %rdx,%rax
  800090:	48 c1 e0 03          	shl    $0x3,%rax
  800094:	48 01 d0             	add    %rdx,%rax
  800097:	48 c1 e0 05          	shl    $0x5,%rax
  80009b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000a2:	00 00 00 
  8000a5:	48 01 c2             	add    %rax,%rdx
  8000a8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000af:	00 00 00 
  8000b2:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000b9:	7e 14                	jle    8000cf <libmain+0x6b>
		binaryname = argv[0];
  8000bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000bf:	48 8b 10             	mov    (%rax),%rdx
  8000c2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000c9:	00 00 00 
  8000cc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d6:	48 89 d6             	mov    %rdx,%rsi
  8000d9:	89 c7                	mov    %eax,%edi
  8000db:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e2:	00 00 00 
  8000e5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000e7:	48 b8 f5 00 80 00 00 	movabs $0x8000f5,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
}
  8000f3:	c9                   	leaveq 
  8000f4:	c3                   	retq   

00000000008000f5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f5:	55                   	push   %rbp
  8000f6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000f9:	48 b8 9c 08 80 00 00 	movabs $0x80089c,%rax
  800100:	00 00 00 
  800103:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800105:	bf 00 00 00 00       	mov    $0x0,%edi
  80010a:	48 b8 2e 02 80 00 00 	movabs $0x80022e,%rax
  800111:	00 00 00 
  800114:	ff d0                	callq  *%rax
}
  800116:	5d                   	pop    %rbp
  800117:	c3                   	retq   

0000000000800118 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800118:	55                   	push   %rbp
  800119:	48 89 e5             	mov    %rsp,%rbp
  80011c:	53                   	push   %rbx
  80011d:	48 83 ec 48          	sub    $0x48,%rsp
  800121:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800124:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800127:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80012b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80012f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800133:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800137:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80013a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80013e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800142:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800146:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80014a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80014e:	4c 89 c3             	mov    %r8,%rbx
  800151:	cd 30                	int    $0x30
  800153:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800157:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80015b:	74 3e                	je     80019b <syscall+0x83>
  80015d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800162:	7e 37                	jle    80019b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800164:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800168:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80016b:	49 89 d0             	mov    %rdx,%r8
  80016e:	89 c1                	mov    %eax,%ecx
  800170:	48 ba ea 35 80 00 00 	movabs $0x8035ea,%rdx
  800177:	00 00 00 
  80017a:	be 23 00 00 00       	mov    $0x23,%esi
  80017f:	48 bf 07 36 80 00 00 	movabs $0x803607,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	49 b9 20 1e 80 00 00 	movabs $0x801e20,%r9
  800195:	00 00 00 
  800198:	41 ff d1             	callq  *%r9

	return ret;
  80019b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80019f:	48 83 c4 48          	add    $0x48,%rsp
  8001a3:	5b                   	pop    %rbx
  8001a4:	5d                   	pop    %rbp
  8001a5:	c3                   	retq   

00000000008001a6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a6:	55                   	push   %rbp
  8001a7:	48 89 e5             	mov    %rsp,%rbp
  8001aa:	48 83 ec 20          	sub    $0x20,%rsp
  8001ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c5:	00 
  8001c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d2:	48 89 d1             	mov    %rdx,%rcx
  8001d5:	48 89 c2             	mov    %rax,%rdx
  8001d8:	be 00 00 00 00       	mov    $0x0,%esi
  8001dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e2:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax
}
  8001ee:	c9                   	leaveq 
  8001ef:	c3                   	retq   

00000000008001f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f0:	55                   	push   %rbp
  8001f1:	48 89 e5             	mov    %rsp,%rbp
  8001f4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001ff:	00 
  800200:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800206:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800211:	ba 00 00 00 00       	mov    $0x0,%edx
  800216:	be 00 00 00 00       	mov    $0x0,%esi
  80021b:	bf 01 00 00 00       	mov    $0x1,%edi
  800220:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  800227:	00 00 00 
  80022a:	ff d0                	callq  *%rax
}
  80022c:	c9                   	leaveq 
  80022d:	c3                   	retq   

000000000080022e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80022e:	55                   	push   %rbp
  80022f:	48 89 e5             	mov    %rsp,%rbp
  800232:	48 83 ec 10          	sub    $0x10,%rsp
  800236:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023c:	48 98                	cltq   
  80023e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800245:	00 
  800246:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80024c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800252:	b9 00 00 00 00       	mov    $0x0,%ecx
  800257:	48 89 c2             	mov    %rax,%rdx
  80025a:	be 01 00 00 00       	mov    $0x1,%esi
  80025f:	bf 03 00 00 00       	mov    $0x3,%edi
  800264:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  80026b:	00 00 00 
  80026e:	ff d0                	callq  *%rax
}
  800270:	c9                   	leaveq 
  800271:	c3                   	retq   

0000000000800272 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800272:	55                   	push   %rbp
  800273:	48 89 e5             	mov    %rsp,%rbp
  800276:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80027a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800281:	00 
  800282:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800288:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800293:	ba 00 00 00 00       	mov    $0x0,%edx
  800298:	be 00 00 00 00       	mov    $0x0,%esi
  80029d:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a2:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  8002a9:	00 00 00 
  8002ac:	ff d0                	callq  *%rax
}
  8002ae:	c9                   	leaveq 
  8002af:	c3                   	retq   

00000000008002b0 <sys_yield>:

void
sys_yield(void)
{
  8002b0:	55                   	push   %rbp
  8002b1:	48 89 e5             	mov    %rsp,%rbp
  8002b4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002bf:	00 
  8002c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d6:	be 00 00 00 00       	mov    $0x0,%esi
  8002db:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002e0:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	callq  *%rax
}
  8002ec:	c9                   	leaveq 
  8002ed:	c3                   	retq   

00000000008002ee <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002ee:	55                   	push   %rbp
  8002ef:	48 89 e5             	mov    %rsp,%rbp
  8002f2:	48 83 ec 20          	sub    $0x20,%rsp
  8002f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002fd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800300:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800303:	48 63 c8             	movslq %eax,%rcx
  800306:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030d:	48 98                	cltq   
  80030f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800316:	00 
  800317:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80031d:	49 89 c8             	mov    %rcx,%r8
  800320:	48 89 d1             	mov    %rdx,%rcx
  800323:	48 89 c2             	mov    %rax,%rdx
  800326:	be 01 00 00 00       	mov    $0x1,%esi
  80032b:	bf 04 00 00 00       	mov    $0x4,%edi
  800330:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  800337:	00 00 00 
  80033a:	ff d0                	callq  *%rax
}
  80033c:	c9                   	leaveq 
  80033d:	c3                   	retq   

000000000080033e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80033e:	55                   	push   %rbp
  80033f:	48 89 e5             	mov    %rsp,%rbp
  800342:	48 83 ec 30          	sub    $0x30,%rsp
  800346:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800349:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80034d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800350:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800354:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800358:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80035b:	48 63 c8             	movslq %eax,%rcx
  80035e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800362:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800365:	48 63 f0             	movslq %eax,%rsi
  800368:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80036f:	48 98                	cltq   
  800371:	48 89 0c 24          	mov    %rcx,(%rsp)
  800375:	49 89 f9             	mov    %rdi,%r9
  800378:	49 89 f0             	mov    %rsi,%r8
  80037b:	48 89 d1             	mov    %rdx,%rcx
  80037e:	48 89 c2             	mov    %rax,%rdx
  800381:	be 01 00 00 00       	mov    $0x1,%esi
  800386:	bf 05 00 00 00       	mov    $0x5,%edi
  80038b:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  800392:	00 00 00 
  800395:	ff d0                	callq  *%rax
}
  800397:	c9                   	leaveq 
  800398:	c3                   	retq   

0000000000800399 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800399:	55                   	push   %rbp
  80039a:	48 89 e5             	mov    %rsp,%rbp
  80039d:	48 83 ec 20          	sub    $0x20,%rsp
  8003a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003af:	48 98                	cltq   
  8003b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003b8:	00 
  8003b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003c5:	48 89 d1             	mov    %rdx,%rcx
  8003c8:	48 89 c2             	mov    %rax,%rdx
  8003cb:	be 01 00 00 00       	mov    $0x1,%esi
  8003d0:	bf 06 00 00 00       	mov    $0x6,%edi
  8003d5:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  8003dc:	00 00 00 
  8003df:	ff d0                	callq  *%rax
}
  8003e1:	c9                   	leaveq 
  8003e2:	c3                   	retq   

00000000008003e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e3:	55                   	push   %rbp
  8003e4:	48 89 e5             	mov    %rsp,%rbp
  8003e7:	48 83 ec 10          	sub    $0x10,%rsp
  8003eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ee:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f4:	48 63 d0             	movslq %eax,%rdx
  8003f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003fa:	48 98                	cltq   
  8003fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800403:	00 
  800404:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80040a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800410:	48 89 d1             	mov    %rdx,%rcx
  800413:	48 89 c2             	mov    %rax,%rdx
  800416:	be 01 00 00 00       	mov    $0x1,%esi
  80041b:	bf 08 00 00 00       	mov    $0x8,%edi
  800420:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  800427:	00 00 00 
  80042a:	ff d0                	callq  *%rax
}
  80042c:	c9                   	leaveq 
  80042d:	c3                   	retq   

000000000080042e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80042e:	55                   	push   %rbp
  80042f:	48 89 e5             	mov    %rsp,%rbp
  800432:	48 83 ec 20          	sub    $0x20,%rsp
  800436:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800439:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80043d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800441:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800444:	48 98                	cltq   
  800446:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80044d:	00 
  80044e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800454:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80045a:	48 89 d1             	mov    %rdx,%rcx
  80045d:	48 89 c2             	mov    %rax,%rdx
  800460:	be 01 00 00 00       	mov    $0x1,%esi
  800465:	bf 09 00 00 00       	mov    $0x9,%edi
  80046a:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  800471:	00 00 00 
  800474:	ff d0                	callq  *%rax
}
  800476:	c9                   	leaveq 
  800477:	c3                   	retq   

0000000000800478 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800478:	55                   	push   %rbp
  800479:	48 89 e5             	mov    %rsp,%rbp
  80047c:	48 83 ec 20          	sub    $0x20,%rsp
  800480:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800483:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800487:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80048b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80048e:	48 98                	cltq   
  800490:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800497:	00 
  800498:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80049e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004a4:	48 89 d1             	mov    %rdx,%rcx
  8004a7:	48 89 c2             	mov    %rax,%rdx
  8004aa:	be 01 00 00 00       	mov    $0x1,%esi
  8004af:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004b4:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  8004bb:	00 00 00 
  8004be:	ff d0                	callq  *%rax
}
  8004c0:	c9                   	leaveq 
  8004c1:	c3                   	retq   

00000000008004c2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004c2:	55                   	push   %rbp
  8004c3:	48 89 e5             	mov    %rsp,%rbp
  8004c6:	48 83 ec 20          	sub    $0x20,%rsp
  8004ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004d5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004db:	48 63 f0             	movslq %eax,%rsi
  8004de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e5:	48 98                	cltq   
  8004e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004f2:	00 
  8004f3:	49 89 f1             	mov    %rsi,%r9
  8004f6:	49 89 c8             	mov    %rcx,%r8
  8004f9:	48 89 d1             	mov    %rdx,%rcx
  8004fc:	48 89 c2             	mov    %rax,%rdx
  8004ff:	be 00 00 00 00       	mov    $0x0,%esi
  800504:	bf 0c 00 00 00       	mov    $0xc,%edi
  800509:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  800510:	00 00 00 
  800513:	ff d0                	callq  *%rax
}
  800515:	c9                   	leaveq 
  800516:	c3                   	retq   

0000000000800517 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800517:	55                   	push   %rbp
  800518:	48 89 e5             	mov    %rsp,%rbp
  80051b:	48 83 ec 10          	sub    $0x10,%rsp
  80051f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800527:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80052e:	00 
  80052f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800535:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80053b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800540:	48 89 c2             	mov    %rax,%rdx
  800543:	be 01 00 00 00       	mov    $0x1,%esi
  800548:	bf 0d 00 00 00       	mov    $0xd,%edi
  80054d:	48 b8 18 01 80 00 00 	movabs $0x800118,%rax
  800554:	00 00 00 
  800557:	ff d0                	callq  *%rax
}
  800559:	c9                   	leaveq 
  80055a:	c3                   	retq   

000000000080055b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80055b:	55                   	push   %rbp
  80055c:	48 89 e5             	mov    %rsp,%rbp
  80055f:	48 83 ec 08          	sub    $0x8,%rsp
  800563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800567:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80056b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800572:	ff ff ff 
  800575:	48 01 d0             	add    %rdx,%rax
  800578:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80057c:	c9                   	leaveq 
  80057d:	c3                   	retq   

000000000080057e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80057e:	55                   	push   %rbp
  80057f:	48 89 e5             	mov    %rsp,%rbp
  800582:	48 83 ec 08          	sub    $0x8,%rsp
  800586:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80058a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80058e:	48 89 c7             	mov    %rax,%rdi
  800591:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  800598:	00 00 00 
  80059b:	ff d0                	callq  *%rax
  80059d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005a3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005a7:	c9                   	leaveq 
  8005a8:	c3                   	retq   

00000000008005a9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005a9:	55                   	push   %rbp
  8005aa:	48 89 e5             	mov    %rsp,%rbp
  8005ad:	48 83 ec 18          	sub    $0x18,%rsp
  8005b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005bc:	eb 6b                	jmp    800629 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005c1:	48 98                	cltq   
  8005c3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005c9:	48 c1 e0 0c          	shl    $0xc,%rax
  8005cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005d5:	48 c1 e8 15          	shr    $0x15,%rax
  8005d9:	48 89 c2             	mov    %rax,%rdx
  8005dc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005e3:	01 00 00 
  8005e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005ea:	83 e0 01             	and    $0x1,%eax
  8005ed:	48 85 c0             	test   %rax,%rax
  8005f0:	74 21                	je     800613 <fd_alloc+0x6a>
  8005f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8005fa:	48 89 c2             	mov    %rax,%rdx
  8005fd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800604:	01 00 00 
  800607:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80060b:	83 e0 01             	and    $0x1,%eax
  80060e:	48 85 c0             	test   %rax,%rax
  800611:	75 12                	jne    800625 <fd_alloc+0x7c>
			*fd_store = fd;
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80061b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80061e:	b8 00 00 00 00       	mov    $0x0,%eax
  800623:	eb 1a                	jmp    80063f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800625:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800629:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80062d:	7e 8f                	jle    8005be <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80063a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80063f:	c9                   	leaveq 
  800640:	c3                   	retq   

0000000000800641 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800641:	55                   	push   %rbp
  800642:	48 89 e5             	mov    %rsp,%rbp
  800645:	48 83 ec 20          	sub    $0x20,%rsp
  800649:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80064c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800650:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800654:	78 06                	js     80065c <fd_lookup+0x1b>
  800656:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80065a:	7e 07                	jle    800663 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80065c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800661:	eb 6c                	jmp    8006cf <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800663:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800666:	48 98                	cltq   
  800668:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80066e:	48 c1 e0 0c          	shl    $0xc,%rax
  800672:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80067a:	48 c1 e8 15          	shr    $0x15,%rax
  80067e:	48 89 c2             	mov    %rax,%rdx
  800681:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800688:	01 00 00 
  80068b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80068f:	83 e0 01             	and    $0x1,%eax
  800692:	48 85 c0             	test   %rax,%rax
  800695:	74 21                	je     8006b8 <fd_lookup+0x77>
  800697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80069b:	48 c1 e8 0c          	shr    $0xc,%rax
  80069f:	48 89 c2             	mov    %rax,%rdx
  8006a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006a9:	01 00 00 
  8006ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006b0:	83 e0 01             	and    $0x1,%eax
  8006b3:	48 85 c0             	test   %rax,%rax
  8006b6:	75 07                	jne    8006bf <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006bd:	eb 10                	jmp    8006cf <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006c7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006cf:	c9                   	leaveq 
  8006d0:	c3                   	retq   

00000000008006d1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006d1:	55                   	push   %rbp
  8006d2:	48 89 e5             	mov    %rsp,%rbp
  8006d5:	48 83 ec 30          	sub    $0x30,%rsp
  8006d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006dd:	89 f0                	mov    %esi,%eax
  8006df:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006e6:	48 89 c7             	mov    %rax,%rdi
  8006e9:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  8006f0:	00 00 00 
  8006f3:	ff d0                	callq  *%rax
  8006f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8006f9:	48 89 d6             	mov    %rdx,%rsi
  8006fc:	89 c7                	mov    %eax,%edi
  8006fe:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  800705:	00 00 00 
  800708:	ff d0                	callq  *%rax
  80070a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80070d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800711:	78 0a                	js     80071d <fd_close+0x4c>
	    || fd != fd2)
  800713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800717:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80071b:	74 12                	je     80072f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80071d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800721:	74 05                	je     800728 <fd_close+0x57>
  800723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800726:	eb 05                	jmp    80072d <fd_close+0x5c>
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	eb 69                	jmp    800798 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80072f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800733:	8b 00                	mov    (%rax),%eax
  800735:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800739:	48 89 d6             	mov    %rdx,%rsi
  80073c:	89 c7                	mov    %eax,%edi
  80073e:	48 b8 9a 07 80 00 00 	movabs $0x80079a,%rax
  800745:	00 00 00 
  800748:	ff d0                	callq  *%rax
  80074a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80074d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800751:	78 2a                	js     80077d <fd_close+0xac>
		if (dev->dev_close)
  800753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800757:	48 8b 40 20          	mov    0x20(%rax),%rax
  80075b:	48 85 c0             	test   %rax,%rax
  80075e:	74 16                	je     800776 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	48 8b 40 20          	mov    0x20(%rax),%rax
  800768:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80076c:	48 89 d7             	mov    %rdx,%rdi
  80076f:	ff d0                	callq  *%rax
  800771:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800774:	eb 07                	jmp    80077d <fd_close+0xac>
		else
			r = 0;
  800776:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80077d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800781:	48 89 c6             	mov    %rax,%rsi
  800784:	bf 00 00 00 00       	mov    $0x0,%edi
  800789:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  800790:	00 00 00 
  800793:	ff d0                	callq  *%rax
	return r;
  800795:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800798:	c9                   	leaveq 
  800799:	c3                   	retq   

000000000080079a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80079a:	55                   	push   %rbp
  80079b:	48 89 e5             	mov    %rsp,%rbp
  80079e:	48 83 ec 20          	sub    $0x20,%rsp
  8007a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007b0:	eb 41                	jmp    8007f3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007b2:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007b9:	00 00 00 
  8007bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007bf:	48 63 d2             	movslq %edx,%rdx
  8007c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007cb:	75 22                	jne    8007ef <dev_lookup+0x55>
			*dev = devtab[i];
  8007cd:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007d4:	00 00 00 
  8007d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007da:	48 63 d2             	movslq %edx,%rdx
  8007dd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007e5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ed:	eb 60                	jmp    80084f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007f3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007fa:	00 00 00 
  8007fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800800:	48 63 d2             	movslq %edx,%rdx
  800803:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800807:	48 85 c0             	test   %rax,%rax
  80080a:	75 a6                	jne    8007b2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80080c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800813:	00 00 00 
  800816:	48 8b 00             	mov    (%rax),%rax
  800819:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80081f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800822:	89 c6                	mov    %eax,%esi
  800824:	48 bf 18 36 80 00 00 	movabs $0x803618,%rdi
  80082b:	00 00 00 
  80082e:	b8 00 00 00 00       	mov    $0x0,%eax
  800833:	48 b9 59 20 80 00 00 	movabs $0x802059,%rcx
  80083a:	00 00 00 
  80083d:	ff d1                	callq  *%rcx
	*dev = 0;
  80083f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800843:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80084a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80084f:	c9                   	leaveq 
  800850:	c3                   	retq   

0000000000800851 <close>:

int
close(int fdnum)
{
  800851:	55                   	push   %rbp
  800852:	48 89 e5             	mov    %rsp,%rbp
  800855:	48 83 ec 20          	sub    $0x20,%rsp
  800859:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80085c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800860:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800863:	48 89 d6             	mov    %rdx,%rsi
  800866:	89 c7                	mov    %eax,%edi
  800868:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  80086f:	00 00 00 
  800872:	ff d0                	callq  *%rax
  800874:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800877:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80087b:	79 05                	jns    800882 <close+0x31>
		return r;
  80087d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800880:	eb 18                	jmp    80089a <close+0x49>
	else
		return fd_close(fd, 1);
  800882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800886:	be 01 00 00 00       	mov    $0x1,%esi
  80088b:	48 89 c7             	mov    %rax,%rdi
  80088e:	48 b8 d1 06 80 00 00 	movabs $0x8006d1,%rax
  800895:	00 00 00 
  800898:	ff d0                	callq  *%rax
}
  80089a:	c9                   	leaveq 
  80089b:	c3                   	retq   

000000000080089c <close_all>:

void
close_all(void)
{
  80089c:	55                   	push   %rbp
  80089d:	48 89 e5             	mov    %rsp,%rbp
  8008a0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008ab:	eb 15                	jmp    8008c2 <close_all+0x26>
		close(i);
  8008ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008b0:	89 c7                	mov    %eax,%edi
  8008b2:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  8008b9:	00 00 00 
  8008bc:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008be:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008c2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008c6:	7e e5                	jle    8008ad <close_all+0x11>
		close(i);
}
  8008c8:	c9                   	leaveq 
  8008c9:	c3                   	retq   

00000000008008ca <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008ca:	55                   	push   %rbp
  8008cb:	48 89 e5             	mov    %rsp,%rbp
  8008ce:	48 83 ec 40          	sub    $0x40,%rsp
  8008d2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008d5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008d8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008dc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008df:	48 89 d6             	mov    %rdx,%rsi
  8008e2:	89 c7                	mov    %eax,%edi
  8008e4:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  8008eb:	00 00 00 
  8008ee:	ff d0                	callq  *%rax
  8008f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008f7:	79 08                	jns    800901 <dup+0x37>
		return r;
  8008f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008fc:	e9 70 01 00 00       	jmpq   800a71 <dup+0x1a7>
	close(newfdnum);
  800901:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800904:	89 c7                	mov    %eax,%edi
  800906:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  80090d:	00 00 00 
  800910:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800912:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800915:	48 98                	cltq   
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	48 89 c7             	mov    %rax,%rdi
  80092c:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  800933:	00 00 00 
  800936:	ff d0                	callq  *%rax
  800938:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80093c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800940:	48 89 c7             	mov    %rax,%rdi
  800943:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  80094a:	00 00 00 
  80094d:	ff d0                	callq  *%rax
  80094f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800957:	48 c1 e8 15          	shr    $0x15,%rax
  80095b:	48 89 c2             	mov    %rax,%rdx
  80095e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800965:	01 00 00 
  800968:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80096c:	83 e0 01             	and    $0x1,%eax
  80096f:	48 85 c0             	test   %rax,%rax
  800972:	74 73                	je     8009e7 <dup+0x11d>
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	48 c1 e8 0c          	shr    $0xc,%rax
  80097c:	48 89 c2             	mov    %rax,%rdx
  80097f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800986:	01 00 00 
  800989:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80098d:	83 e0 01             	and    $0x1,%eax
  800990:	48 85 c0             	test   %rax,%rax
  800993:	74 52                	je     8009e7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800995:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800999:	48 c1 e8 0c          	shr    $0xc,%rax
  80099d:	48 89 c2             	mov    %rax,%rdx
  8009a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009a7:	01 00 00 
  8009aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8009b3:	89 c1                	mov    %eax,%ecx
  8009b5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	41 89 c8             	mov    %ecx,%r8d
  8009c0:	48 89 d1             	mov    %rdx,%rcx
  8009c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c8:	48 89 c6             	mov    %rax,%rsi
  8009cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8009d0:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  8009d7:	00 00 00 
  8009da:	ff d0                	callq  *%rax
  8009dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009e3:	79 02                	jns    8009e7 <dup+0x11d>
			goto err;
  8009e5:	eb 57                	jmp    800a3e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009eb:	48 c1 e8 0c          	shr    $0xc,%rax
  8009ef:	48 89 c2             	mov    %rax,%rdx
  8009f2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009f9:	01 00 00 
  8009fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a00:	25 07 0e 00 00       	and    $0xe07,%eax
  800a05:	89 c1                	mov    %eax,%ecx
  800a07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a0f:	41 89 c8             	mov    %ecx,%r8d
  800a12:	48 89 d1             	mov    %rdx,%rcx
  800a15:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1a:	48 89 c6             	mov    %rax,%rsi
  800a1d:	bf 00 00 00 00       	mov    $0x0,%edi
  800a22:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  800a29:	00 00 00 
  800a2c:	ff d0                	callq  *%rax
  800a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a35:	79 02                	jns    800a39 <dup+0x16f>
		goto err;
  800a37:	eb 05                	jmp    800a3e <dup+0x174>

	return newfdnum;
  800a39:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a3c:	eb 33                	jmp    800a71 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a42:	48 89 c6             	mov    %rax,%rsi
  800a45:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4a:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  800a51:	00 00 00 
  800a54:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a5a:	48 89 c6             	mov    %rax,%rsi
  800a5d:	bf 00 00 00 00       	mov    $0x0,%edi
  800a62:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  800a69:	00 00 00 
  800a6c:	ff d0                	callq  *%rax
	return r;
  800a6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a71:	c9                   	leaveq 
  800a72:	c3                   	retq   

0000000000800a73 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a73:	55                   	push   %rbp
  800a74:	48 89 e5             	mov    %rsp,%rbp
  800a77:	48 83 ec 40          	sub    $0x40,%rsp
  800a7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a7e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a82:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a86:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a8a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a8d:	48 89 d6             	mov    %rdx,%rsi
  800a90:	89 c7                	mov    %eax,%edi
  800a92:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  800a99:	00 00 00 
  800a9c:	ff d0                	callq  *%rax
  800a9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800aa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aa5:	78 24                	js     800acb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aab:	8b 00                	mov    (%rax),%eax
  800aad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ab1:	48 89 d6             	mov    %rdx,%rsi
  800ab4:	89 c7                	mov    %eax,%edi
  800ab6:	48 b8 9a 07 80 00 00 	movabs $0x80079a,%rax
  800abd:	00 00 00 
  800ac0:	ff d0                	callq  *%rax
  800ac2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ac5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ac9:	79 05                	jns    800ad0 <read+0x5d>
		return r;
  800acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ace:	eb 76                	jmp    800b46 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad4:	8b 40 08             	mov    0x8(%rax),%eax
  800ad7:	83 e0 03             	and    $0x3,%eax
  800ada:	83 f8 01             	cmp    $0x1,%eax
  800add:	75 3a                	jne    800b19 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800adf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ae6:	00 00 00 
  800ae9:	48 8b 00             	mov    (%rax),%rax
  800aec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800af2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800af5:	89 c6                	mov    %eax,%esi
  800af7:	48 bf 37 36 80 00 00 	movabs $0x803637,%rdi
  800afe:	00 00 00 
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	48 b9 59 20 80 00 00 	movabs $0x802059,%rcx
  800b0d:	00 00 00 
  800b10:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b17:	eb 2d                	jmp    800b46 <read+0xd3>
	}
	if (!dev->dev_read)
  800b19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b1d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b21:	48 85 c0             	test   %rax,%rax
  800b24:	75 07                	jne    800b2d <read+0xba>
		return -E_NOT_SUPP;
  800b26:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b2b:	eb 19                	jmp    800b46 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b31:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b35:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b41:	48 89 cf             	mov    %rcx,%rdi
  800b44:	ff d0                	callq  *%rax
}
  800b46:	c9                   	leaveq 
  800b47:	c3                   	retq   

0000000000800b48 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b48:	55                   	push   %rbp
  800b49:	48 89 e5             	mov    %rsp,%rbp
  800b4c:	48 83 ec 30          	sub    $0x30,%rsp
  800b50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b62:	eb 49                	jmp    800bad <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b67:	48 98                	cltq   
  800b69:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b6d:	48 29 c2             	sub    %rax,%rdx
  800b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b73:	48 63 c8             	movslq %eax,%rcx
  800b76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b7a:	48 01 c1             	add    %rax,%rcx
  800b7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b80:	48 89 ce             	mov    %rcx,%rsi
  800b83:	89 c7                	mov    %eax,%edi
  800b85:	48 b8 73 0a 80 00 00 	movabs $0x800a73,%rax
  800b8c:	00 00 00 
  800b8f:	ff d0                	callq  *%rax
  800b91:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800b94:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b98:	79 05                	jns    800b9f <readn+0x57>
			return m;
  800b9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b9d:	eb 1c                	jmp    800bbb <readn+0x73>
		if (m == 0)
  800b9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ba3:	75 02                	jne    800ba7 <readn+0x5f>
			break;
  800ba5:	eb 11                	jmp    800bb8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ba7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800baa:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bb0:	48 98                	cltq   
  800bb2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bb6:	72 ac                	jb     800b64 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bbb:	c9                   	leaveq 
  800bbc:	c3                   	retq   

0000000000800bbd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bbd:	55                   	push   %rbp
  800bbe:	48 89 e5             	mov    %rsp,%rbp
  800bc1:	48 83 ec 40          	sub    $0x40,%rsp
  800bc5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bc8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bcc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bd0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bd4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bd7:	48 89 d6             	mov    %rdx,%rsi
  800bda:	89 c7                	mov    %eax,%edi
  800bdc:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  800be3:	00 00 00 
  800be6:	ff d0                	callq  *%rax
  800be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800beb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bef:	78 24                	js     800c15 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf5:	8b 00                	mov    (%rax),%eax
  800bf7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bfb:	48 89 d6             	mov    %rdx,%rsi
  800bfe:	89 c7                	mov    %eax,%edi
  800c00:	48 b8 9a 07 80 00 00 	movabs $0x80079a,%rax
  800c07:	00 00 00 
  800c0a:	ff d0                	callq  *%rax
  800c0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c13:	79 05                	jns    800c1a <write+0x5d>
		return r;
  800c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c18:	eb 75                	jmp    800c8f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1e:	8b 40 08             	mov    0x8(%rax),%eax
  800c21:	83 e0 03             	and    $0x3,%eax
  800c24:	85 c0                	test   %eax,%eax
  800c26:	75 3a                	jne    800c62 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c28:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c2f:	00 00 00 
  800c32:	48 8b 00             	mov    (%rax),%rax
  800c35:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c3b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c3e:	89 c6                	mov    %eax,%esi
  800c40:	48 bf 53 36 80 00 00 	movabs $0x803653,%rdi
  800c47:	00 00 00 
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	48 b9 59 20 80 00 00 	movabs $0x802059,%rcx
  800c56:	00 00 00 
  800c59:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c60:	eb 2d                	jmp    800c8f <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c66:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c6a:	48 85 c0             	test   %rax,%rax
  800c6d:	75 07                	jne    800c76 <write+0xb9>
		return -E_NOT_SUPP;
  800c6f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c74:	eb 19                	jmp    800c8f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c7e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c82:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c86:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c8a:	48 89 cf             	mov    %rcx,%rdi
  800c8d:	ff d0                	callq  *%rax
}
  800c8f:	c9                   	leaveq 
  800c90:	c3                   	retq   

0000000000800c91 <seek>:

int
seek(int fdnum, off_t offset)
{
  800c91:	55                   	push   %rbp
  800c92:	48 89 e5             	mov    %rsp,%rbp
  800c95:	48 83 ec 18          	sub    $0x18,%rsp
  800c99:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c9c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ca3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ca6:	48 89 d6             	mov    %rdx,%rsi
  800ca9:	89 c7                	mov    %eax,%edi
  800cab:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  800cb2:	00 00 00 
  800cb5:	ff d0                	callq  *%rax
  800cb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cbe:	79 05                	jns    800cc5 <seek+0x34>
		return r;
  800cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cc3:	eb 0f                	jmp    800cd4 <seek+0x43>
	fd->fd_offset = offset;
  800cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800ccc:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd4:	c9                   	leaveq 
  800cd5:	c3                   	retq   

0000000000800cd6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800cd6:	55                   	push   %rbp
  800cd7:	48 89 e5             	mov    %rsp,%rbp
  800cda:	48 83 ec 30          	sub    $0x30,%rsp
  800cde:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800ce1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ce4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ce8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	89 c7                	mov    %eax,%edi
  800cf0:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d03:	78 24                	js     800d29 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d09:	8b 00                	mov    (%rax),%eax
  800d0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d0f:	48 89 d6             	mov    %rdx,%rsi
  800d12:	89 c7                	mov    %eax,%edi
  800d14:	48 b8 9a 07 80 00 00 	movabs $0x80079a,%rax
  800d1b:	00 00 00 
  800d1e:	ff d0                	callq  *%rax
  800d20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d27:	79 05                	jns    800d2e <ftruncate+0x58>
		return r;
  800d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d2c:	eb 72                	jmp    800da0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d32:	8b 40 08             	mov    0x8(%rax),%eax
  800d35:	83 e0 03             	and    $0x3,%eax
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	75 3a                	jne    800d76 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d3c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d43:	00 00 00 
  800d46:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d49:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d4f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d52:	89 c6                	mov    %eax,%esi
  800d54:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  800d5b:	00 00 00 
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d63:	48 b9 59 20 80 00 00 	movabs $0x802059,%rcx
  800d6a:	00 00 00 
  800d6d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d74:	eb 2a                	jmp    800da0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7a:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d7e:	48 85 c0             	test   %rax,%rax
  800d81:	75 07                	jne    800d8a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d83:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d88:	eb 16                	jmp    800da0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8e:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d96:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800d99:	89 ce                	mov    %ecx,%esi
  800d9b:	48 89 d7             	mov    %rdx,%rdi
  800d9e:	ff d0                	callq  *%rax
}
  800da0:	c9                   	leaveq 
  800da1:	c3                   	retq   

0000000000800da2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800da2:	55                   	push   %rbp
  800da3:	48 89 e5             	mov    %rsp,%rbp
  800da6:	48 83 ec 30          	sub    $0x30,%rsp
  800daa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800db1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800db5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800db8:	48 89 d6             	mov    %rdx,%rsi
  800dbb:	89 c7                	mov    %eax,%edi
  800dbd:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  800dc4:	00 00 00 
  800dc7:	ff d0                	callq  *%rax
  800dc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dd0:	78 24                	js     800df6 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd6:	8b 00                	mov    (%rax),%eax
  800dd8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ddc:	48 89 d6             	mov    %rdx,%rsi
  800ddf:	89 c7                	mov    %eax,%edi
  800de1:	48 b8 9a 07 80 00 00 	movabs $0x80079a,%rax
  800de8:	00 00 00 
  800deb:	ff d0                	callq  *%rax
  800ded:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800df4:	79 05                	jns    800dfb <fstat+0x59>
		return r;
  800df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df9:	eb 5e                	jmp    800e59 <fstat+0xb7>
	if (!dev->dev_stat)
  800dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dff:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e03:	48 85 c0             	test   %rax,%rax
  800e06:	75 07                	jne    800e0f <fstat+0x6d>
		return -E_NOT_SUPP;
  800e08:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e0d:	eb 4a                	jmp    800e59 <fstat+0xb7>
	stat->st_name[0] = 0;
  800e0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e13:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e1a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e21:	00 00 00 
	stat->st_isdir = 0;
  800e24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e28:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e2f:	00 00 00 
	stat->st_dev = dev;
  800e32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e3a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e45:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e4d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e51:	48 89 ce             	mov    %rcx,%rsi
  800e54:	48 89 d7             	mov    %rdx,%rdi
  800e57:	ff d0                	callq  *%rax
}
  800e59:	c9                   	leaveq 
  800e5a:	c3                   	retq   

0000000000800e5b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e5b:	55                   	push   %rbp
  800e5c:	48 89 e5             	mov    %rsp,%rbp
  800e5f:	48 83 ec 20          	sub    $0x20,%rsp
  800e63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6f:	be 00 00 00 00       	mov    $0x0,%esi
  800e74:	48 89 c7             	mov    %rax,%rdi
  800e77:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  800e7e:	00 00 00 
  800e81:	ff d0                	callq  *%rax
  800e83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e8a:	79 05                	jns    800e91 <stat+0x36>
		return fd;
  800e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8f:	eb 2f                	jmp    800ec0 <stat+0x65>
	r = fstat(fd, stat);
  800e91:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e98:	48 89 d6             	mov    %rdx,%rsi
  800e9b:	89 c7                	mov    %eax,%edi
  800e9d:	48 b8 a2 0d 80 00 00 	movabs $0x800da2,%rax
  800ea4:	00 00 00 
  800ea7:	ff d0                	callq  *%rax
  800ea9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eaf:	89 c7                	mov    %eax,%edi
  800eb1:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  800eb8:	00 00 00 
  800ebb:	ff d0                	callq  *%rax
	return r;
  800ebd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ec0:	c9                   	leaveq 
  800ec1:	c3                   	retq   

0000000000800ec2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ec2:	55                   	push   %rbp
  800ec3:	48 89 e5             	mov    %rsp,%rbp
  800ec6:	48 83 ec 10          	sub    $0x10,%rsp
  800eca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ecd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ed1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ed8:	00 00 00 
  800edb:	8b 00                	mov    (%rax),%eax
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 1d                	jne    800efe <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ee1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee6:	48 b8 d3 34 80 00 00 	movabs $0x8034d3,%rax
  800eed:	00 00 00 
  800ef0:	ff d0                	callq  *%rax
  800ef2:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800ef9:	00 00 00 
  800efc:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800efe:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f05:	00 00 00 
  800f08:	8b 00                	mov    (%rax),%eax
  800f0a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f0d:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f12:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f19:	00 00 00 
  800f1c:	89 c7                	mov    %eax,%edi
  800f1e:	48 b8 3b 34 80 00 00 	movabs $0x80343b,%rax
  800f25:	00 00 00 
  800f28:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f33:	48 89 c6             	mov    %rax,%rsi
  800f36:	bf 00 00 00 00       	mov    $0x0,%edi
  800f3b:	48 b8 7a 33 80 00 00 	movabs $0x80337a,%rax
  800f42:	00 00 00 
  800f45:	ff d0                	callq  *%rax
}
  800f47:	c9                   	leaveq 
  800f48:	c3                   	retq   

0000000000800f49 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f49:	55                   	push   %rbp
  800f4a:	48 89 e5             	mov    %rsp,%rbp
  800f4d:	48 83 ec 20          	sub    $0x20,%rsp
  800f51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f55:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5c:	48 89 c7             	mov    %rax,%rdi
  800f5f:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  800f66:	00 00 00 
  800f69:	ff d0                	callq  *%rax
  800f6b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f70:	7e 0a                	jle    800f7c <open+0x33>
		return -E_BAD_PATH;
  800f72:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f77:	e9 a5 00 00 00       	jmpq   801021 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f7c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f80:	48 89 c7             	mov    %rax,%rdi
  800f83:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  800f8a:	00 00 00 
  800f8d:	ff d0                	callq  *%rax
  800f8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f96:	79 08                	jns    800fa0 <open+0x57>
		return r;
  800f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f9b:	e9 81 00 00 00       	jmpq   801021 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa4:	48 89 c6             	mov    %rax,%rsi
  800fa7:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fae:	00 00 00 
  800fb1:	48 b8 21 2c 80 00 00 	movabs $0x802c21,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fbd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fc4:	00 00 00 
  800fc7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fca:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd4:	48 89 c6             	mov    %rax,%rsi
  800fd7:	bf 01 00 00 00       	mov    $0x1,%edi
  800fdc:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  800fe3:	00 00 00 
  800fe6:	ff d0                	callq  *%rax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800feb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fef:	79 1d                	jns    80100e <open+0xc5>
		fd_close(fd, 0);
  800ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff5:	be 00 00 00 00       	mov    $0x0,%esi
  800ffa:	48 89 c7             	mov    %rax,%rdi
  800ffd:	48 b8 d1 06 80 00 00 	movabs $0x8006d1,%rax
  801004:	00 00 00 
  801007:	ff d0                	callq  *%rax
		return r;
  801009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80100c:	eb 13                	jmp    801021 <open+0xd8>
	}

	return fd2num(fd);
  80100e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801012:	48 89 c7             	mov    %rax,%rdi
  801015:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  80101c:	00 00 00 
  80101f:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  801021:	c9                   	leaveq 
  801022:	c3                   	retq   

0000000000801023 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801023:	55                   	push   %rbp
  801024:	48 89 e5             	mov    %rsp,%rbp
  801027:	48 83 ec 10          	sub    $0x10,%rsp
  80102b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80102f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801033:	8b 50 0c             	mov    0xc(%rax),%edx
  801036:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80103d:	00 00 00 
  801040:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801042:	be 00 00 00 00       	mov    $0x0,%esi
  801047:	bf 06 00 00 00       	mov    $0x6,%edi
  80104c:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  801053:	00 00 00 
  801056:	ff d0                	callq  *%rax
}
  801058:	c9                   	leaveq 
  801059:	c3                   	retq   

000000000080105a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80105a:	55                   	push   %rbp
  80105b:	48 89 e5             	mov    %rsp,%rbp
  80105e:	48 83 ec 30          	sub    $0x30,%rsp
  801062:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801066:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80106a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80106e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801072:	8b 50 0c             	mov    0xc(%rax),%edx
  801075:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80107c:	00 00 00 
  80107f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801081:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801088:	00 00 00 
  80108b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80108f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801093:	be 00 00 00 00       	mov    $0x0,%esi
  801098:	bf 03 00 00 00       	mov    $0x3,%edi
  80109d:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  8010a4:	00 00 00 
  8010a7:	ff d0                	callq  *%rax
  8010a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010b0:	79 08                	jns    8010ba <devfile_read+0x60>
		return r;
  8010b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b5:	e9 a4 00 00 00       	jmpq   80115e <devfile_read+0x104>
	assert(r <= n);
  8010ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010bd:	48 98                	cltq   
  8010bf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010c3:	76 35                	jbe    8010fa <devfile_read+0xa0>
  8010c5:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  8010cc:	00 00 00 
  8010cf:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8010d6:	00 00 00 
  8010d9:	be 84 00 00 00       	mov    $0x84,%esi
  8010de:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8010e5:	00 00 00 
  8010e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ed:	49 b8 20 1e 80 00 00 	movabs $0x801e20,%r8
  8010f4:	00 00 00 
  8010f7:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8010fa:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  801101:	7e 35                	jle    801138 <devfile_read+0xde>
  801103:	48 b9 c4 36 80 00 00 	movabs $0x8036c4,%rcx
  80110a:	00 00 00 
  80110d:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  801114:	00 00 00 
  801117:	be 85 00 00 00       	mov    $0x85,%esi
  80111c:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  801123:	00 00 00 
  801126:	b8 00 00 00 00       	mov    $0x0,%eax
  80112b:	49 b8 20 1e 80 00 00 	movabs $0x801e20,%r8
  801132:	00 00 00 
  801135:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801138:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80113b:	48 63 d0             	movslq %eax,%rdx
  80113e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801142:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801149:	00 00 00 
  80114c:	48 89 c7             	mov    %rax,%rdi
  80114f:	48 b8 45 2f 80 00 00 	movabs $0x802f45,%rax
  801156:	00 00 00 
  801159:	ff d0                	callq  *%rax
	return r;
  80115b:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80115e:	c9                   	leaveq 
  80115f:	c3                   	retq   

0000000000801160 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801160:	55                   	push   %rbp
  801161:	48 89 e5             	mov    %rsp,%rbp
  801164:	48 83 ec 30          	sub    $0x30,%rsp
  801168:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80116c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801170:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	8b 50 0c             	mov    0xc(%rax),%edx
  80117b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801182:	00 00 00 
  801185:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801187:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80118e:	00 00 00 
  801191:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801195:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801199:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011a0:	00 
  8011a1:	76 35                	jbe    8011d8 <devfile_write+0x78>
  8011a3:	48 b9 d0 36 80 00 00 	movabs $0x8036d0,%rcx
  8011aa:	00 00 00 
  8011ad:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8011b4:	00 00 00 
  8011b7:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011bc:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8011c3:	00 00 00 
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	49 b8 20 1e 80 00 00 	movabs $0x801e20,%r8
  8011d2:	00 00 00 
  8011d5:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011d8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e0:	48 89 c6             	mov    %rax,%rsi
  8011e3:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011ea:	00 00 00 
  8011ed:	48 b8 5c 30 80 00 00 	movabs $0x80305c,%rax
  8011f4:	00 00 00 
  8011f7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8011f9:	be 00 00 00 00       	mov    $0x0,%esi
  8011fe:	bf 04 00 00 00       	mov    $0x4,%edi
  801203:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  80120a:	00 00 00 
  80120d:	ff d0                	callq  *%rax
  80120f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801212:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801216:	79 05                	jns    80121d <devfile_write+0xbd>
		return r;
  801218:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80121b:	eb 43                	jmp    801260 <devfile_write+0x100>
	assert(r <= n);
  80121d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801220:	48 98                	cltq   
  801222:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801226:	76 35                	jbe    80125d <devfile_write+0xfd>
  801228:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  80122f:	00 00 00 
  801232:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  801239:	00 00 00 
  80123c:	be a2 00 00 00       	mov    $0xa2,%esi
  801241:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  801248:	00 00 00 
  80124b:	b8 00 00 00 00       	mov    $0x0,%eax
  801250:	49 b8 20 1e 80 00 00 	movabs $0x801e20,%r8
  801257:	00 00 00 
  80125a:	41 ff d0             	callq  *%r8
	return r;
  80125d:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 83 ec 20          	sub    $0x20,%rsp
  80126a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801276:	8b 50 0c             	mov    0xc(%rax),%edx
  801279:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801280:	00 00 00 
  801283:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801285:	be 00 00 00 00       	mov    $0x0,%esi
  80128a:	bf 05 00 00 00       	mov    $0x5,%edi
  80128f:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  801296:	00 00 00 
  801299:	ff d0                	callq  *%rax
  80129b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80129e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012a2:	79 05                	jns    8012a9 <devfile_stat+0x47>
		return r;
  8012a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012a7:	eb 56                	jmp    8012ff <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ad:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012b4:	00 00 00 
  8012b7:	48 89 c7             	mov    %rax,%rdi
  8012ba:	48 b8 21 2c 80 00 00 	movabs $0x802c21,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012c6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012cd:	00 00 00 
  8012d0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012da:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012e0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012e7:	00 00 00 
  8012ea:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ff:	c9                   	leaveq 
  801300:	c3                   	retq   

0000000000801301 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801301:	55                   	push   %rbp
  801302:	48 89 e5             	mov    %rsp,%rbp
  801305:	48 83 ec 10          	sub    $0x10,%rsp
  801309:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801314:	8b 50 0c             	mov    0xc(%rax),%edx
  801317:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80131e:	00 00 00 
  801321:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801323:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80132a:	00 00 00 
  80132d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801330:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801333:	be 00 00 00 00       	mov    $0x0,%esi
  801338:	bf 02 00 00 00       	mov    $0x2,%edi
  80133d:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  801344:	00 00 00 
  801347:	ff d0                	callq  *%rax
}
  801349:	c9                   	leaveq 
  80134a:	c3                   	retq   

000000000080134b <remove>:

// Delete a file
int
remove(const char *path)
{
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	48 83 ec 10          	sub    $0x10,%rsp
  801353:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801357:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135b:	48 89 c7             	mov    %rax,%rdi
  80135e:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801365:	00 00 00 
  801368:	ff d0                	callq  *%rax
  80136a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80136f:	7e 07                	jle    801378 <remove+0x2d>
		return -E_BAD_PATH;
  801371:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801376:	eb 33                	jmp    8013ab <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137c:	48 89 c6             	mov    %rax,%rsi
  80137f:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801386:	00 00 00 
  801389:	48 b8 21 2c 80 00 00 	movabs $0x802c21,%rax
  801390:	00 00 00 
  801393:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801395:	be 00 00 00 00       	mov    $0x0,%esi
  80139a:	bf 07 00 00 00       	mov    $0x7,%edi
  80139f:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  8013a6:	00 00 00 
  8013a9:	ff d0                	callq  *%rax
}
  8013ab:	c9                   	leaveq 
  8013ac:	c3                   	retq   

00000000008013ad <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013ad:	55                   	push   %rbp
  8013ae:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013b1:	be 00 00 00 00       	mov    $0x0,%esi
  8013b6:	bf 08 00 00 00       	mov    $0x8,%edi
  8013bb:	48 b8 c2 0e 80 00 00 	movabs $0x800ec2,%rax
  8013c2:	00 00 00 
  8013c5:	ff d0                	callq  *%rax
}
  8013c7:	5d                   	pop    %rbp
  8013c8:	c3                   	retq   

00000000008013c9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013c9:	55                   	push   %rbp
  8013ca:	48 89 e5             	mov    %rsp,%rbp
  8013cd:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013d4:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013db:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013e2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013e9:	be 00 00 00 00       	mov    $0x0,%esi
  8013ee:	48 89 c7             	mov    %rax,%rdi
  8013f1:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  8013f8:	00 00 00 
  8013fb:	ff d0                	callq  *%rax
  8013fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801400:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801404:	79 28                	jns    80142e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801409:	89 c6                	mov    %eax,%esi
  80140b:	48 bf fd 36 80 00 00 	movabs $0x8036fd,%rdi
  801412:	00 00 00 
  801415:	b8 00 00 00 00       	mov    $0x0,%eax
  80141a:	48 ba 59 20 80 00 00 	movabs $0x802059,%rdx
  801421:	00 00 00 
  801424:	ff d2                	callq  *%rdx
		return fd_src;
  801426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801429:	e9 74 01 00 00       	jmpq   8015a2 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80142e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801435:	be 01 01 00 00       	mov    $0x101,%esi
  80143a:	48 89 c7             	mov    %rax,%rdi
  80143d:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  801444:	00 00 00 
  801447:	ff d0                	callq  *%rax
  801449:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80144c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801450:	79 39                	jns    80148b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801452:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801455:	89 c6                	mov    %eax,%esi
  801457:	48 bf 13 37 80 00 00 	movabs $0x803713,%rdi
  80145e:	00 00 00 
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	48 ba 59 20 80 00 00 	movabs $0x802059,%rdx
  80146d:	00 00 00 
  801470:	ff d2                	callq  *%rdx
		close(fd_src);
  801472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801475:	89 c7                	mov    %eax,%edi
  801477:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  80147e:	00 00 00 
  801481:	ff d0                	callq  *%rax
		return fd_dest;
  801483:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801486:	e9 17 01 00 00       	jmpq   8015a2 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80148b:	eb 74                	jmp    801501 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80148d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801490:	48 63 d0             	movslq %eax,%rdx
  801493:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80149a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80149d:	48 89 ce             	mov    %rcx,%rsi
  8014a0:	89 c7                	mov    %eax,%edi
  8014a2:	48 b8 bd 0b 80 00 00 	movabs $0x800bbd,%rax
  8014a9:	00 00 00 
  8014ac:	ff d0                	callq  *%rax
  8014ae:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014b5:	79 4a                	jns    801501 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014b7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014ba:	89 c6                	mov    %eax,%esi
  8014bc:	48 bf 2d 37 80 00 00 	movabs $0x80372d,%rdi
  8014c3:	00 00 00 
  8014c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cb:	48 ba 59 20 80 00 00 	movabs $0x802059,%rdx
  8014d2:	00 00 00 
  8014d5:	ff d2                	callq  *%rdx
			close(fd_src);
  8014d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014da:	89 c7                	mov    %eax,%edi
  8014dc:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  8014e3:	00 00 00 
  8014e6:	ff d0                	callq  *%rax
			close(fd_dest);
  8014e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014eb:	89 c7                	mov    %eax,%edi
  8014ed:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  8014f4:	00 00 00 
  8014f7:	ff d0                	callq  *%rax
			return write_size;
  8014f9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014fc:	e9 a1 00 00 00       	jmpq   8015a2 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801501:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801508:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80150b:	ba 00 02 00 00       	mov    $0x200,%edx
  801510:	48 89 ce             	mov    %rcx,%rsi
  801513:	89 c7                	mov    %eax,%edi
  801515:	48 b8 73 0a 80 00 00 	movabs $0x800a73,%rax
  80151c:	00 00 00 
  80151f:	ff d0                	callq  *%rax
  801521:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801524:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801528:	0f 8f 5f ff ff ff    	jg     80148d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80152e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801532:	79 47                	jns    80157b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801534:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801537:	89 c6                	mov    %eax,%esi
  801539:	48 bf 40 37 80 00 00 	movabs $0x803740,%rdi
  801540:	00 00 00 
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	48 ba 59 20 80 00 00 	movabs $0x802059,%rdx
  80154f:	00 00 00 
  801552:	ff d2                	callq  *%rdx
		close(fd_src);
  801554:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801557:	89 c7                	mov    %eax,%edi
  801559:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  801560:	00 00 00 
  801563:	ff d0                	callq  *%rax
		close(fd_dest);
  801565:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801568:	89 c7                	mov    %eax,%edi
  80156a:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  801571:	00 00 00 
  801574:	ff d0                	callq  *%rax
		return read_size;
  801576:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801579:	eb 27                	jmp    8015a2 <copy+0x1d9>
	}
	close(fd_src);
  80157b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80157e:	89 c7                	mov    %eax,%edi
  801580:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  801587:	00 00 00 
  80158a:	ff d0                	callq  *%rax
	close(fd_dest);
  80158c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80158f:	89 c7                	mov    %eax,%edi
  801591:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  801598:	00 00 00 
  80159b:	ff d0                	callq  *%rax
	return 0;
  80159d:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015a2:	c9                   	leaveq 
  8015a3:	c3                   	retq   

00000000008015a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015a4:	55                   	push   %rbp
  8015a5:	48 89 e5             	mov    %rsp,%rbp
  8015a8:	53                   	push   %rbx
  8015a9:	48 83 ec 38          	sub    $0x38,%rsp
  8015ad:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015b1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015b5:	48 89 c7             	mov    %rax,%rdi
  8015b8:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  8015bf:	00 00 00 
  8015c2:	ff d0                	callq  *%rax
  8015c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015cb:	0f 88 bf 01 00 00    	js     801790 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	ba 07 04 00 00       	mov    $0x407,%edx
  8015da:	48 89 c6             	mov    %rax,%rsi
  8015dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8015e2:	48 b8 ee 02 80 00 00 	movabs $0x8002ee,%rax
  8015e9:	00 00 00 
  8015ec:	ff d0                	callq  *%rax
  8015ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015f5:	0f 88 95 01 00 00    	js     801790 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8015fb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015ff:	48 89 c7             	mov    %rax,%rdi
  801602:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  801609:	00 00 00 
  80160c:	ff d0                	callq  *%rax
  80160e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801611:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801615:	0f 88 5d 01 00 00    	js     801778 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80161b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80161f:	ba 07 04 00 00       	mov    $0x407,%edx
  801624:	48 89 c6             	mov    %rax,%rsi
  801627:	bf 00 00 00 00       	mov    $0x0,%edi
  80162c:	48 b8 ee 02 80 00 00 	movabs $0x8002ee,%rax
  801633:	00 00 00 
  801636:	ff d0                	callq  *%rax
  801638:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80163b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80163f:	0f 88 33 01 00 00    	js     801778 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	48 89 c7             	mov    %rax,%rdi
  80164c:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  801653:	00 00 00 
  801656:	ff d0                	callq  *%rax
  801658:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80165c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801660:	ba 07 04 00 00       	mov    $0x407,%edx
  801665:	48 89 c6             	mov    %rax,%rsi
  801668:	bf 00 00 00 00       	mov    $0x0,%edi
  80166d:	48 b8 ee 02 80 00 00 	movabs $0x8002ee,%rax
  801674:	00 00 00 
  801677:	ff d0                	callq  *%rax
  801679:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80167c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801680:	79 05                	jns    801687 <pipe+0xe3>
		goto err2;
  801682:	e9 d9 00 00 00       	jmpq   801760 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801687:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80168b:	48 89 c7             	mov    %rax,%rdi
  80168e:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  801695:	00 00 00 
  801698:	ff d0                	callq  *%rax
  80169a:	48 89 c2             	mov    %rax,%rdx
  80169d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a1:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016a7:	48 89 d1             	mov    %rdx,%rcx
  8016aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016af:	48 89 c6             	mov    %rax,%rsi
  8016b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b7:	48 b8 3e 03 80 00 00 	movabs $0x80033e,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	callq  *%rax
  8016c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016ca:	79 1b                	jns    8016e7 <pipe+0x143>
		goto err3;
  8016cc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016d1:	48 89 c6             	mov    %rax,%rsi
  8016d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8016d9:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  8016e0:	00 00 00 
  8016e3:	ff d0                	callq  *%rax
  8016e5:	eb 79                	jmp    801760 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016f2:	00 00 00 
  8016f5:	8b 12                	mov    (%rdx),%edx
  8016f7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801704:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801708:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80170f:	00 00 00 
  801712:	8b 12                	mov    (%rdx),%edx
  801714:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801716:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	48 89 c7             	mov    %rax,%rdi
  801728:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  80172f:	00 00 00 
  801732:	ff d0                	callq  *%rax
  801734:	89 c2                	mov    %eax,%edx
  801736:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80173a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80173c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801740:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801748:	48 89 c7             	mov    %rax,%rdi
  80174b:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  801752:	00 00 00 
  801755:	ff d0                	callq  *%rax
  801757:	89 03                	mov    %eax,(%rbx)
	return 0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
  80175e:	eb 33                	jmp    801793 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801760:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801764:	48 89 c6             	mov    %rax,%rsi
  801767:	bf 00 00 00 00       	mov    $0x0,%edi
  80176c:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  801773:	00 00 00 
  801776:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	48 89 c6             	mov    %rax,%rsi
  80177f:	bf 00 00 00 00       	mov    $0x0,%edi
  801784:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  80178b:	00 00 00 
  80178e:	ff d0                	callq  *%rax
err:
	return r;
  801790:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801793:	48 83 c4 38          	add    $0x38,%rsp
  801797:	5b                   	pop    %rbx
  801798:	5d                   	pop    %rbp
  801799:	c3                   	retq   

000000000080179a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80179a:	55                   	push   %rbp
  80179b:	48 89 e5             	mov    %rsp,%rbp
  80179e:	53                   	push   %rbx
  80179f:	48 83 ec 28          	sub    $0x28,%rsp
  8017a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017ab:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017b2:	00 00 00 
  8017b5:	48 8b 00             	mov    (%rax),%rax
  8017b8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017be:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c5:	48 89 c7             	mov    %rax,%rdi
  8017c8:	48 b8 55 35 80 00 00 	movabs $0x803555,%rax
  8017cf:	00 00 00 
  8017d2:	ff d0                	callq  *%rax
  8017d4:	89 c3                	mov    %eax,%ebx
  8017d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017da:	48 89 c7             	mov    %rax,%rdi
  8017dd:	48 b8 55 35 80 00 00 	movabs $0x803555,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
  8017e9:	39 c3                	cmp    %eax,%ebx
  8017eb:	0f 94 c0             	sete   %al
  8017ee:	0f b6 c0             	movzbl %al,%eax
  8017f1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8017f4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017fb:	00 00 00 
  8017fe:	48 8b 00             	mov    (%rax),%rax
  801801:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801807:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80180a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80180d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801810:	75 05                	jne    801817 <_pipeisclosed+0x7d>
			return ret;
  801812:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801815:	eb 4f                	jmp    801866 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801817:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80181a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80181d:	74 42                	je     801861 <_pipeisclosed+0xc7>
  80181f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801823:	75 3c                	jne    801861 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801825:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80182c:	00 00 00 
  80182f:	48 8b 00             	mov    (%rax),%rax
  801832:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801838:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80183b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80183e:	89 c6                	mov    %eax,%esi
  801840:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  801847:	00 00 00 
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	49 b8 59 20 80 00 00 	movabs $0x802059,%r8
  801856:	00 00 00 
  801859:	41 ff d0             	callq  *%r8
	}
  80185c:	e9 4a ff ff ff       	jmpq   8017ab <_pipeisclosed+0x11>
  801861:	e9 45 ff ff ff       	jmpq   8017ab <_pipeisclosed+0x11>
}
  801866:	48 83 c4 28          	add    $0x28,%rsp
  80186a:	5b                   	pop    %rbx
  80186b:	5d                   	pop    %rbp
  80186c:	c3                   	retq   

000000000080186d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 30          	sub    $0x30,%rsp
  801875:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801878:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80187c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80187f:	48 89 d6             	mov    %rdx,%rsi
  801882:	89 c7                	mov    %eax,%edi
  801884:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  80188b:	00 00 00 
  80188e:	ff d0                	callq  *%rax
  801890:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801893:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801897:	79 05                	jns    80189e <pipeisclosed+0x31>
		return r;
  801899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189c:	eb 31                	jmp    8018cf <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80189e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a2:	48 89 c7             	mov    %rax,%rdi
  8018a5:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  8018ac:	00 00 00 
  8018af:	ff d0                	callq  *%rax
  8018b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bd:	48 89 d6             	mov    %rdx,%rsi
  8018c0:	48 89 c7             	mov    %rax,%rdi
  8018c3:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  8018ca:	00 00 00 
  8018cd:	ff d0                	callq  *%rax
}
  8018cf:	c9                   	leaveq 
  8018d0:	c3                   	retq   

00000000008018d1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018d1:	55                   	push   %rbp
  8018d2:	48 89 e5             	mov    %rsp,%rbp
  8018d5:	48 83 ec 40          	sub    $0x40,%rsp
  8018d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018e1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	48 89 c7             	mov    %rax,%rdi
  8018ec:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
  8018f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8018fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801900:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801904:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80190b:	00 
  80190c:	e9 92 00 00 00       	jmpq   8019a3 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801911:	eb 41                	jmp    801954 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801913:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801918:	74 09                	je     801923 <devpipe_read+0x52>
				return i;
  80191a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191e:	e9 92 00 00 00       	jmpq   8019b5 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801923:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192b:	48 89 d6             	mov    %rdx,%rsi
  80192e:	48 89 c7             	mov    %rax,%rdi
  801931:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801938:	00 00 00 
  80193b:	ff d0                	callq  *%rax
  80193d:	85 c0                	test   %eax,%eax
  80193f:	74 07                	je     801948 <devpipe_read+0x77>
				return 0;
  801941:	b8 00 00 00 00       	mov    $0x0,%eax
  801946:	eb 6d                	jmp    8019b5 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801948:	48 b8 b0 02 80 00 00 	movabs $0x8002b0,%rax
  80194f:	00 00 00 
  801952:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801958:	8b 10                	mov    (%rax),%edx
  80195a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195e:	8b 40 04             	mov    0x4(%rax),%eax
  801961:	39 c2                	cmp    %eax,%edx
  801963:	74 ae                	je     801913 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80196d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801971:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801975:	8b 00                	mov    (%rax),%eax
  801977:	99                   	cltd   
  801978:	c1 ea 1b             	shr    $0x1b,%edx
  80197b:	01 d0                	add    %edx,%eax
  80197d:	83 e0 1f             	and    $0x1f,%eax
  801980:	29 d0                	sub    %edx,%eax
  801982:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801986:	48 98                	cltq   
  801988:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80198d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80198f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801993:	8b 00                	mov    (%rax),%eax
  801995:	8d 50 01             	lea    0x1(%rax),%edx
  801998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80199c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80199e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019ab:	0f 82 60 ff ff ff    	jb     801911 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019b5:	c9                   	leaveq 
  8019b6:	c3                   	retq   

00000000008019b7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019b7:	55                   	push   %rbp
  8019b8:	48 89 e5             	mov    %rsp,%rbp
  8019bb:	48 83 ec 40          	sub    $0x40,%rsp
  8019bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cf:	48 89 c7             	mov    %rax,%rdi
  8019d2:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  8019d9:	00 00 00 
  8019dc:	ff d0                	callq  *%rax
  8019de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019f1:	00 
  8019f2:	e9 8e 00 00 00       	jmpq   801a85 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019f7:	eb 31                	jmp    801a2a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a01:	48 89 d6             	mov    %rdx,%rsi
  801a04:	48 89 c7             	mov    %rax,%rdi
  801a07:	48 b8 9a 17 80 00 00 	movabs $0x80179a,%rax
  801a0e:	00 00 00 
  801a11:	ff d0                	callq  *%rax
  801a13:	85 c0                	test   %eax,%eax
  801a15:	74 07                	je     801a1e <devpipe_write+0x67>
				return 0;
  801a17:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1c:	eb 79                	jmp    801a97 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a1e:	48 b8 b0 02 80 00 00 	movabs $0x8002b0,%rax
  801a25:	00 00 00 
  801a28:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a2e:	8b 40 04             	mov    0x4(%rax),%eax
  801a31:	48 63 d0             	movslq %eax,%rdx
  801a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a38:	8b 00                	mov    (%rax),%eax
  801a3a:	48 98                	cltq   
  801a3c:	48 83 c0 20          	add    $0x20,%rax
  801a40:	48 39 c2             	cmp    %rax,%rdx
  801a43:	73 b4                	jae    8019f9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a49:	8b 40 04             	mov    0x4(%rax),%eax
  801a4c:	99                   	cltd   
  801a4d:	c1 ea 1b             	shr    $0x1b,%edx
  801a50:	01 d0                	add    %edx,%eax
  801a52:	83 e0 1f             	and    $0x1f,%eax
  801a55:	29 d0                	sub    %edx,%eax
  801a57:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a5f:	48 01 ca             	add    %rcx,%rdx
  801a62:	0f b6 0a             	movzbl (%rdx),%ecx
  801a65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a69:	48 98                	cltq   
  801a6b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a73:	8b 40 04             	mov    0x4(%rax),%eax
  801a76:	8d 50 01             	lea    0x1(%rax),%edx
  801a79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a80:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a89:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a8d:	0f 82 64 ff ff ff    	jb     8019f7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a97:	c9                   	leaveq 
  801a98:	c3                   	retq   

0000000000801a99 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a99:	55                   	push   %rbp
  801a9a:	48 89 e5             	mov    %rsp,%rbp
  801a9d:	48 83 ec 20          	sub    $0x20,%rsp
  801aa1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801aa5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aad:	48 89 c7             	mov    %rax,%rdi
  801ab0:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	callq  *%rax
  801abc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801ac0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ac4:	48 be 6e 37 80 00 00 	movabs $0x80376e,%rsi
  801acb:	00 00 00 
  801ace:	48 89 c7             	mov    %rax,%rdi
  801ad1:	48 b8 21 2c 80 00 00 	movabs $0x802c21,%rax
  801ad8:	00 00 00 
  801adb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801add:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae1:	8b 50 04             	mov    0x4(%rax),%edx
  801ae4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae8:	8b 00                	mov    (%rax),%eax
  801aea:	29 c2                	sub    %eax,%edx
  801aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801af6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801afa:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b01:	00 00 00 
	stat->st_dev = &devpipe;
  801b04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b08:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b0f:	00 00 00 
  801b12:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leaveq 
  801b1f:	c3                   	retq   

0000000000801b20 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b20:	55                   	push   %rbp
  801b21:	48 89 e5             	mov    %rsp,%rbp
  801b24:	48 83 ec 10          	sub    $0x10,%rsp
  801b28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b30:	48 89 c6             	mov    %rax,%rsi
  801b33:	bf 00 00 00 00       	mov    $0x0,%edi
  801b38:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  801b3f:	00 00 00 
  801b42:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b48:	48 89 c7             	mov    %rax,%rdi
  801b4b:	48 b8 7e 05 80 00 00 	movabs $0x80057e,%rax
  801b52:	00 00 00 
  801b55:	ff d0                	callq  *%rax
  801b57:	48 89 c6             	mov    %rax,%rsi
  801b5a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b5f:	48 b8 99 03 80 00 00 	movabs $0x800399,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 20          	sub    $0x20,%rsp
  801b75:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b7b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b7e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b82:	be 01 00 00 00       	mov    $0x1,%esi
  801b87:	48 89 c7             	mov    %rax,%rdi
  801b8a:	48 b8 a6 01 80 00 00 	movabs $0x8001a6,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
}
  801b96:	c9                   	leaveq 
  801b97:	c3                   	retq   

0000000000801b98 <getchar>:

int
getchar(void)
{
  801b98:	55                   	push   %rbp
  801b99:	48 89 e5             	mov    %rsp,%rbp
  801b9c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ba0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801ba4:	ba 01 00 00 00       	mov    $0x1,%edx
  801ba9:	48 89 c6             	mov    %rax,%rsi
  801bac:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb1:	48 b8 73 0a 80 00 00 	movabs $0x800a73,%rax
  801bb8:	00 00 00 
  801bbb:	ff d0                	callq  *%rax
  801bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bc4:	79 05                	jns    801bcb <getchar+0x33>
		return r;
  801bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc9:	eb 14                	jmp    801bdf <getchar+0x47>
	if (r < 1)
  801bcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bcf:	7f 07                	jg     801bd8 <getchar+0x40>
		return -E_EOF;
  801bd1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801bd6:	eb 07                	jmp    801bdf <getchar+0x47>
	return c;
  801bd8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801bdc:	0f b6 c0             	movzbl %al,%eax
}
  801bdf:	c9                   	leaveq 
  801be0:	c3                   	retq   

0000000000801be1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	48 83 ec 20          	sub    $0x20,%rsp
  801be9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801bf0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bf3:	48 89 d6             	mov    %rdx,%rsi
  801bf6:	89 c7                	mov    %eax,%edi
  801bf8:	48 b8 41 06 80 00 00 	movabs $0x800641,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
  801c04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c0b:	79 05                	jns    801c12 <iscons+0x31>
		return r;
  801c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c10:	eb 1a                	jmp    801c2c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c16:	8b 10                	mov    (%rax),%edx
  801c18:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c1f:	00 00 00 
  801c22:	8b 00                	mov    (%rax),%eax
  801c24:	39 c2                	cmp    %eax,%edx
  801c26:	0f 94 c0             	sete   %al
  801c29:	0f b6 c0             	movzbl %al,%eax
}
  801c2c:	c9                   	leaveq 
  801c2d:	c3                   	retq   

0000000000801c2e <opencons>:

int
opencons(void)
{
  801c2e:	55                   	push   %rbp
  801c2f:	48 89 e5             	mov    %rsp,%rbp
  801c32:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c36:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c3a:	48 89 c7             	mov    %rax,%rdi
  801c3d:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  801c44:	00 00 00 
  801c47:	ff d0                	callq  *%rax
  801c49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c50:	79 05                	jns    801c57 <opencons+0x29>
		return r;
  801c52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c55:	eb 5b                	jmp    801cb2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c5b:	ba 07 04 00 00       	mov    $0x407,%edx
  801c60:	48 89 c6             	mov    %rax,%rsi
  801c63:	bf 00 00 00 00       	mov    $0x0,%edi
  801c68:	48 b8 ee 02 80 00 00 	movabs $0x8002ee,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	callq  *%rax
  801c74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c7b:	79 05                	jns    801c82 <opencons+0x54>
		return r;
  801c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c80:	eb 30                	jmp    801cb2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c86:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c8d:	00 00 00 
  801c90:	8b 12                	mov    (%rdx),%edx
  801c92:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c98:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801c9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca3:	48 89 c7             	mov    %rax,%rdi
  801ca6:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  801cad:	00 00 00 
  801cb0:	ff d0                	callq  *%rax
}
  801cb2:	c9                   	leaveq 
  801cb3:	c3                   	retq   

0000000000801cb4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cb4:	55                   	push   %rbp
  801cb5:	48 89 e5             	mov    %rsp,%rbp
  801cb8:	48 83 ec 30          	sub    $0x30,%rsp
  801cbc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cc8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ccd:	75 07                	jne    801cd6 <devcons_read+0x22>
		return 0;
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd4:	eb 4b                	jmp    801d21 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801cd6:	eb 0c                	jmp    801ce4 <devcons_read+0x30>
		sys_yield();
  801cd8:	48 b8 b0 02 80 00 00 	movabs $0x8002b0,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ce4:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  801ceb:	00 00 00 
  801cee:	ff d0                	callq  *%rax
  801cf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cf7:	74 df                	je     801cd8 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cfd:	79 05                	jns    801d04 <devcons_read+0x50>
		return c;
  801cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d02:	eb 1d                	jmp    801d21 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d04:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d08:	75 07                	jne    801d11 <devcons_read+0x5d>
		return 0;
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0f:	eb 10                	jmp    801d21 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d1a:	88 10                	mov    %dl,(%rax)
	return 1;
  801d1c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d21:	c9                   	leaveq 
  801d22:	c3                   	retq   

0000000000801d23 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d23:	55                   	push   %rbp
  801d24:	48 89 e5             	mov    %rsp,%rbp
  801d27:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d2e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d35:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d3c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d4a:	eb 76                	jmp    801dc2 <devcons_write+0x9f>
		m = n - tot;
  801d4c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d53:	89 c2                	mov    %eax,%edx
  801d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d58:	29 c2                	sub    %eax,%edx
  801d5a:	89 d0                	mov    %edx,%eax
  801d5c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d62:	83 f8 7f             	cmp    $0x7f,%eax
  801d65:	76 07                	jbe    801d6e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d67:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d71:	48 63 d0             	movslq %eax,%rdx
  801d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d77:	48 63 c8             	movslq %eax,%rcx
  801d7a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d81:	48 01 c1             	add    %rax,%rcx
  801d84:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d8b:	48 89 ce             	mov    %rcx,%rsi
  801d8e:	48 89 c7             	mov    %rax,%rdi
  801d91:	48 b8 45 2f 80 00 00 	movabs $0x802f45,%rax
  801d98:	00 00 00 
  801d9b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801d9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da0:	48 63 d0             	movslq %eax,%rdx
  801da3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801daa:	48 89 d6             	mov    %rdx,%rsi
  801dad:	48 89 c7             	mov    %rax,%rdi
  801db0:	48 b8 a6 01 80 00 00 	movabs $0x8001a6,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dbf:	01 45 fc             	add    %eax,-0x4(%rbp)
  801dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc5:	48 98                	cltq   
  801dc7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dce:	0f 82 78 ff ff ff    	jb     801d4c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dd7:	c9                   	leaveq 
  801dd8:	c3                   	retq   

0000000000801dd9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801dd9:	55                   	push   %rbp
  801dda:	48 89 e5             	mov    %rsp,%rbp
  801ddd:	48 83 ec 08          	sub    $0x8,%rsp
  801de1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dea:	c9                   	leaveq 
  801deb:	c3                   	retq   

0000000000801dec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dec:	55                   	push   %rbp
  801ded:	48 89 e5             	mov    %rsp,%rbp
  801df0:	48 83 ec 10          	sub    $0x10,%rsp
  801df4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801df8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e00:	48 be 7a 37 80 00 00 	movabs $0x80377a,%rsi
  801e07:	00 00 00 
  801e0a:	48 89 c7             	mov    %rax,%rdi
  801e0d:	48 b8 21 2c 80 00 00 	movabs $0x802c21,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	callq  *%rax
	return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	c9                   	leaveq 
  801e1f:	c3                   	retq   

0000000000801e20 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e20:	55                   	push   %rbp
  801e21:	48 89 e5             	mov    %rsp,%rbp
  801e24:	53                   	push   %rbx
  801e25:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e2c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e33:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e39:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e40:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e47:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e4e:	84 c0                	test   %al,%al
  801e50:	74 23                	je     801e75 <_panic+0x55>
  801e52:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e59:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e5d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e61:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e65:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e69:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e6d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e71:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e75:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e7c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e83:	00 00 00 
  801e86:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e8d:	00 00 00 
  801e90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e94:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801e9b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801ea2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ea9:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801eb0:	00 00 00 
  801eb3:	48 8b 18             	mov    (%rax),%rbx
  801eb6:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
  801ec2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801ec8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ecf:	41 89 c8             	mov    %ecx,%r8d
  801ed2:	48 89 d1             	mov    %rdx,%rcx
  801ed5:	48 89 da             	mov    %rbx,%rdx
  801ed8:	89 c6                	mov    %eax,%esi
  801eda:	48 bf 88 37 80 00 00 	movabs $0x803788,%rdi
  801ee1:	00 00 00 
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	49 b9 59 20 80 00 00 	movabs $0x802059,%r9
  801ef0:	00 00 00 
  801ef3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ef6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801efd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f04:	48 89 d6             	mov    %rdx,%rsi
  801f07:	48 89 c7             	mov    %rax,%rdi
  801f0a:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
	cprintf("\n");
  801f16:	48 bf ab 37 80 00 00 	movabs $0x8037ab,%rdi
  801f1d:	00 00 00 
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	48 ba 59 20 80 00 00 	movabs $0x802059,%rdx
  801f2c:	00 00 00 
  801f2f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f31:	cc                   	int3   
  801f32:	eb fd                	jmp    801f31 <_panic+0x111>

0000000000801f34 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f34:	55                   	push   %rbp
  801f35:	48 89 e5             	mov    %rsp,%rbp
  801f38:	48 83 ec 10          	sub    $0x10,%rsp
  801f3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f47:	8b 00                	mov    (%rax),%eax
  801f49:	8d 48 01             	lea    0x1(%rax),%ecx
  801f4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f50:	89 0a                	mov    %ecx,(%rdx)
  801f52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f55:	89 d1                	mov    %edx,%ecx
  801f57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f5b:	48 98                	cltq   
  801f5d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f65:	8b 00                	mov    (%rax),%eax
  801f67:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f6c:	75 2c                	jne    801f9a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f72:	8b 00                	mov    (%rax),%eax
  801f74:	48 98                	cltq   
  801f76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7a:	48 83 c2 08          	add    $0x8,%rdx
  801f7e:	48 89 c6             	mov    %rax,%rsi
  801f81:	48 89 d7             	mov    %rdx,%rdi
  801f84:	48 b8 a6 01 80 00 00 	movabs $0x8001a6,%rax
  801f8b:	00 00 00 
  801f8e:	ff d0                	callq  *%rax
        b->idx = 0;
  801f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f94:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801f9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9e:	8b 40 04             	mov    0x4(%rax),%eax
  801fa1:	8d 50 01             	lea    0x1(%rax),%edx
  801fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa8:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fab:	c9                   	leaveq 
  801fac:	c3                   	retq   

0000000000801fad <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
  801fb1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fb8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fbf:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fc6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fcd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fd4:	48 8b 0a             	mov    (%rdx),%rcx
  801fd7:	48 89 08             	mov    %rcx,(%rax)
  801fda:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fde:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fe2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801fe6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801fea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801ff1:	00 00 00 
    b.cnt = 0;
  801ff4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801ffb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801ffe:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802005:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80200c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802013:	48 89 c6             	mov    %rax,%rsi
  802016:	48 bf 34 1f 80 00 00 	movabs $0x801f34,%rdi
  80201d:	00 00 00 
  802020:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  802027:	00 00 00 
  80202a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80202c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802032:	48 98                	cltq   
  802034:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80203b:	48 83 c2 08          	add    $0x8,%rdx
  80203f:	48 89 c6             	mov    %rax,%rsi
  802042:	48 89 d7             	mov    %rdx,%rdi
  802045:	48 b8 a6 01 80 00 00 	movabs $0x8001a6,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802051:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802057:	c9                   	leaveq 
  802058:	c3                   	retq   

0000000000802059 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802059:	55                   	push   %rbp
  80205a:	48 89 e5             	mov    %rsp,%rbp
  80205d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802064:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80206b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802072:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802079:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802080:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802087:	84 c0                	test   %al,%al
  802089:	74 20                	je     8020ab <cprintf+0x52>
  80208b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80208f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802093:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802097:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80209b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80209f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020a3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020a7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020ab:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020b2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020b9:	00 00 00 
  8020bc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020c3:	00 00 00 
  8020c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020ca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020d1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020d8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020df:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020e6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020ed:	48 8b 0a             	mov    (%rdx),%rcx
  8020f0:	48 89 08             	mov    %rcx,(%rax)
  8020f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8020f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8020fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8020ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802103:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80210a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802111:	48 89 d6             	mov    %rdx,%rsi
  802114:	48 89 c7             	mov    %rax,%rdi
  802117:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  80211e:	00 00 00 
  802121:	ff d0                	callq  *%rax
  802123:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802129:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80212f:	c9                   	leaveq 
  802130:	c3                   	retq   

0000000000802131 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802131:	55                   	push   %rbp
  802132:	48 89 e5             	mov    %rsp,%rbp
  802135:	53                   	push   %rbx
  802136:	48 83 ec 38          	sub    $0x38,%rsp
  80213a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80213e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802142:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802146:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802149:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80214d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802151:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802154:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802158:	77 3b                	ja     802195 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80215a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80215d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802161:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802164:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802168:	ba 00 00 00 00       	mov    $0x0,%edx
  80216d:	48 f7 f3             	div    %rbx
  802170:	48 89 c2             	mov    %rax,%rdx
  802173:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802176:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802179:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80217d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802181:	41 89 f9             	mov    %edi,%r9d
  802184:	48 89 c7             	mov    %rax,%rdi
  802187:	48 b8 31 21 80 00 00 	movabs $0x802131,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax
  802193:	eb 1e                	jmp    8021b3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802195:	eb 12                	jmp    8021a9 <printnum+0x78>
			putch(padc, putdat);
  802197:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80219b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80219e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a2:	48 89 ce             	mov    %rcx,%rsi
  8021a5:	89 d7                	mov    %edx,%edi
  8021a7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021a9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021ad:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021b1:	7f e4                	jg     802197 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021b3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bf:	48 f7 f1             	div    %rcx
  8021c2:	48 89 d0             	mov    %rdx,%rax
  8021c5:	48 ba b0 39 80 00 00 	movabs $0x8039b0,%rdx
  8021cc:	00 00 00 
  8021cf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021d3:	0f be d0             	movsbl %al,%edx
  8021d6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021de:	48 89 ce             	mov    %rcx,%rsi
  8021e1:	89 d7                	mov    %edx,%edi
  8021e3:	ff d0                	callq  *%rax
}
  8021e5:	48 83 c4 38          	add    $0x38,%rsp
  8021e9:	5b                   	pop    %rbx
  8021ea:	5d                   	pop    %rbp
  8021eb:	c3                   	retq   

00000000008021ec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021ec:	55                   	push   %rbp
  8021ed:	48 89 e5             	mov    %rsp,%rbp
  8021f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8021f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8021fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8021ff:	7e 52                	jle    802253 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802205:	8b 00                	mov    (%rax),%eax
  802207:	83 f8 30             	cmp    $0x30,%eax
  80220a:	73 24                	jae    802230 <getuint+0x44>
  80220c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802210:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802218:	8b 00                	mov    (%rax),%eax
  80221a:	89 c0                	mov    %eax,%eax
  80221c:	48 01 d0             	add    %rdx,%rax
  80221f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802223:	8b 12                	mov    (%rdx),%edx
  802225:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802228:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80222c:	89 0a                	mov    %ecx,(%rdx)
  80222e:	eb 17                	jmp    802247 <getuint+0x5b>
  802230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802234:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802238:	48 89 d0             	mov    %rdx,%rax
  80223b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80223f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802243:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802247:	48 8b 00             	mov    (%rax),%rax
  80224a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80224e:	e9 a3 00 00 00       	jmpq   8022f6 <getuint+0x10a>
	else if (lflag)
  802253:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802257:	74 4f                	je     8022a8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225d:	8b 00                	mov    (%rax),%eax
  80225f:	83 f8 30             	cmp    $0x30,%eax
  802262:	73 24                	jae    802288 <getuint+0x9c>
  802264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802268:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80226c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802270:	8b 00                	mov    (%rax),%eax
  802272:	89 c0                	mov    %eax,%eax
  802274:	48 01 d0             	add    %rdx,%rax
  802277:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227b:	8b 12                	mov    (%rdx),%edx
  80227d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802280:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802284:	89 0a                	mov    %ecx,(%rdx)
  802286:	eb 17                	jmp    80229f <getuint+0xb3>
  802288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802290:	48 89 d0             	mov    %rdx,%rax
  802293:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802297:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80229b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80229f:	48 8b 00             	mov    (%rax),%rax
  8022a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022a6:	eb 4e                	jmp    8022f6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ac:	8b 00                	mov    (%rax),%eax
  8022ae:	83 f8 30             	cmp    $0x30,%eax
  8022b1:	73 24                	jae    8022d7 <getuint+0xeb>
  8022b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bf:	8b 00                	mov    (%rax),%eax
  8022c1:	89 c0                	mov    %eax,%eax
  8022c3:	48 01 d0             	add    %rdx,%rax
  8022c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ca:	8b 12                	mov    (%rdx),%edx
  8022cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022d3:	89 0a                	mov    %ecx,(%rdx)
  8022d5:	eb 17                	jmp    8022ee <getuint+0x102>
  8022d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022df:	48 89 d0             	mov    %rdx,%rax
  8022e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022ee:	8b 00                	mov    (%rax),%eax
  8022f0:	89 c0                	mov    %eax,%eax
  8022f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8022f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022fa:	c9                   	leaveq 
  8022fb:	c3                   	retq   

00000000008022fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8022fc:	55                   	push   %rbp
  8022fd:	48 89 e5             	mov    %rsp,%rbp
  802300:	48 83 ec 1c          	sub    $0x1c,%rsp
  802304:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802308:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80230b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80230f:	7e 52                	jle    802363 <getint+0x67>
		x=va_arg(*ap, long long);
  802311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802315:	8b 00                	mov    (%rax),%eax
  802317:	83 f8 30             	cmp    $0x30,%eax
  80231a:	73 24                	jae    802340 <getint+0x44>
  80231c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802320:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802328:	8b 00                	mov    (%rax),%eax
  80232a:	89 c0                	mov    %eax,%eax
  80232c:	48 01 d0             	add    %rdx,%rax
  80232f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802333:	8b 12                	mov    (%rdx),%edx
  802335:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802338:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80233c:	89 0a                	mov    %ecx,(%rdx)
  80233e:	eb 17                	jmp    802357 <getint+0x5b>
  802340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802344:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802348:	48 89 d0             	mov    %rdx,%rax
  80234b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80234f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802353:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802357:	48 8b 00             	mov    (%rax),%rax
  80235a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80235e:	e9 a3 00 00 00       	jmpq   802406 <getint+0x10a>
	else if (lflag)
  802363:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802367:	74 4f                	je     8023b8 <getint+0xbc>
		x=va_arg(*ap, long);
  802369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236d:	8b 00                	mov    (%rax),%eax
  80236f:	83 f8 30             	cmp    $0x30,%eax
  802372:	73 24                	jae    802398 <getint+0x9c>
  802374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802378:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80237c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802380:	8b 00                	mov    (%rax),%eax
  802382:	89 c0                	mov    %eax,%eax
  802384:	48 01 d0             	add    %rdx,%rax
  802387:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80238b:	8b 12                	mov    (%rdx),%edx
  80238d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802390:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802394:	89 0a                	mov    %ecx,(%rdx)
  802396:	eb 17                	jmp    8023af <getint+0xb3>
  802398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023a0:	48 89 d0             	mov    %rdx,%rax
  8023a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023af:	48 8b 00             	mov    (%rax),%rax
  8023b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023b6:	eb 4e                	jmp    802406 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bc:	8b 00                	mov    (%rax),%eax
  8023be:	83 f8 30             	cmp    $0x30,%eax
  8023c1:	73 24                	jae    8023e7 <getint+0xeb>
  8023c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cf:	8b 00                	mov    (%rax),%eax
  8023d1:	89 c0                	mov    %eax,%eax
  8023d3:	48 01 d0             	add    %rdx,%rax
  8023d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023da:	8b 12                	mov    (%rdx),%edx
  8023dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023e3:	89 0a                	mov    %ecx,(%rdx)
  8023e5:	eb 17                	jmp    8023fe <getint+0x102>
  8023e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023ef:	48 89 d0             	mov    %rdx,%rax
  8023f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023fe:	8b 00                	mov    (%rax),%eax
  802400:	48 98                	cltq   
  802402:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80240a:	c9                   	leaveq 
  80240b:	c3                   	retq   

000000000080240c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80240c:	55                   	push   %rbp
  80240d:	48 89 e5             	mov    %rsp,%rbp
  802410:	41 54                	push   %r12
  802412:	53                   	push   %rbx
  802413:	48 83 ec 60          	sub    $0x60,%rsp
  802417:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80241b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80241f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802423:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802427:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80242b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80242f:	48 8b 0a             	mov    (%rdx),%rcx
  802432:	48 89 08             	mov    %rcx,(%rax)
  802435:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802439:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80243d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802441:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802445:	eb 17                	jmp    80245e <vprintfmt+0x52>
			if (ch == '\0')
  802447:	85 db                	test   %ebx,%ebx
  802449:	0f 84 df 04 00 00    	je     80292e <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80244f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802453:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802457:	48 89 d6             	mov    %rdx,%rsi
  80245a:	89 df                	mov    %ebx,%edi
  80245c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80245e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802462:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802466:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80246a:	0f b6 00             	movzbl (%rax),%eax
  80246d:	0f b6 d8             	movzbl %al,%ebx
  802470:	83 fb 25             	cmp    $0x25,%ebx
  802473:	75 d2                	jne    802447 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802475:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802479:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802480:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802487:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80248e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802495:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802499:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80249d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024a1:	0f b6 00             	movzbl (%rax),%eax
  8024a4:	0f b6 d8             	movzbl %al,%ebx
  8024a7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024aa:	83 f8 55             	cmp    $0x55,%eax
  8024ad:	0f 87 47 04 00 00    	ja     8028fa <vprintfmt+0x4ee>
  8024b3:	89 c0                	mov    %eax,%eax
  8024b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024bc:	00 
  8024bd:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  8024c4:	00 00 00 
  8024c7:	48 01 d0             	add    %rdx,%rax
  8024ca:	48 8b 00             	mov    (%rax),%rax
  8024cd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024cf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024d3:	eb c0                	jmp    802495 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024d5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024d9:	eb ba                	jmp    802495 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024e2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	c1 e0 02             	shl    $0x2,%eax
  8024ea:	01 d0                	add    %edx,%eax
  8024ec:	01 c0                	add    %eax,%eax
  8024ee:	01 d8                	add    %ebx,%eax
  8024f0:	83 e8 30             	sub    $0x30,%eax
  8024f3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8024f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024fa:	0f b6 00             	movzbl (%rax),%eax
  8024fd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802500:	83 fb 2f             	cmp    $0x2f,%ebx
  802503:	7e 0c                	jle    802511 <vprintfmt+0x105>
  802505:	83 fb 39             	cmp    $0x39,%ebx
  802508:	7f 07                	jg     802511 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80250a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80250f:	eb d1                	jmp    8024e2 <vprintfmt+0xd6>
			goto process_precision;
  802511:	eb 58                	jmp    80256b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802513:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802516:	83 f8 30             	cmp    $0x30,%eax
  802519:	73 17                	jae    802532 <vprintfmt+0x126>
  80251b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80251f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802522:	89 c0                	mov    %eax,%eax
  802524:	48 01 d0             	add    %rdx,%rax
  802527:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80252a:	83 c2 08             	add    $0x8,%edx
  80252d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802530:	eb 0f                	jmp    802541 <vprintfmt+0x135>
  802532:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802536:	48 89 d0             	mov    %rdx,%rax
  802539:	48 83 c2 08          	add    $0x8,%rdx
  80253d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802541:	8b 00                	mov    (%rax),%eax
  802543:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802546:	eb 23                	jmp    80256b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802548:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80254c:	79 0c                	jns    80255a <vprintfmt+0x14e>
				width = 0;
  80254e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802555:	e9 3b ff ff ff       	jmpq   802495 <vprintfmt+0x89>
  80255a:	e9 36 ff ff ff       	jmpq   802495 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80255f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802566:	e9 2a ff ff ff       	jmpq   802495 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80256b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80256f:	79 12                	jns    802583 <vprintfmt+0x177>
				width = precision, precision = -1;
  802571:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802574:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802577:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80257e:	e9 12 ff ff ff       	jmpq   802495 <vprintfmt+0x89>
  802583:	e9 0d ff ff ff       	jmpq   802495 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802588:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80258c:	e9 04 ff ff ff       	jmpq   802495 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802591:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802594:	83 f8 30             	cmp    $0x30,%eax
  802597:	73 17                	jae    8025b0 <vprintfmt+0x1a4>
  802599:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80259d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a0:	89 c0                	mov    %eax,%eax
  8025a2:	48 01 d0             	add    %rdx,%rax
  8025a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025a8:	83 c2 08             	add    $0x8,%edx
  8025ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025ae:	eb 0f                	jmp    8025bf <vprintfmt+0x1b3>
  8025b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025b4:	48 89 d0             	mov    %rdx,%rax
  8025b7:	48 83 c2 08          	add    $0x8,%rdx
  8025bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025bf:	8b 10                	mov    (%rax),%edx
  8025c1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025c9:	48 89 ce             	mov    %rcx,%rsi
  8025cc:	89 d7                	mov    %edx,%edi
  8025ce:	ff d0                	callq  *%rax
			break;
  8025d0:	e9 53 03 00 00       	jmpq   802928 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025d8:	83 f8 30             	cmp    $0x30,%eax
  8025db:	73 17                	jae    8025f4 <vprintfmt+0x1e8>
  8025dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025e4:	89 c0                	mov    %eax,%eax
  8025e6:	48 01 d0             	add    %rdx,%rax
  8025e9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025ec:	83 c2 08             	add    $0x8,%edx
  8025ef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025f2:	eb 0f                	jmp    802603 <vprintfmt+0x1f7>
  8025f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025f8:	48 89 d0             	mov    %rdx,%rax
  8025fb:	48 83 c2 08          	add    $0x8,%rdx
  8025ff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802603:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802605:	85 db                	test   %ebx,%ebx
  802607:	79 02                	jns    80260b <vprintfmt+0x1ff>
				err = -err;
  802609:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80260b:	83 fb 15             	cmp    $0x15,%ebx
  80260e:	7f 16                	jg     802626 <vprintfmt+0x21a>
  802610:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  802617:	00 00 00 
  80261a:	48 63 d3             	movslq %ebx,%rdx
  80261d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802621:	4d 85 e4             	test   %r12,%r12
  802624:	75 2e                	jne    802654 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802626:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80262a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80262e:	89 d9                	mov    %ebx,%ecx
  802630:	48 ba c1 39 80 00 00 	movabs $0x8039c1,%rdx
  802637:	00 00 00 
  80263a:	48 89 c7             	mov    %rax,%rdi
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
  802642:	49 b8 37 29 80 00 00 	movabs $0x802937,%r8
  802649:	00 00 00 
  80264c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80264f:	e9 d4 02 00 00       	jmpq   802928 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802654:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802658:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80265c:	4c 89 e1             	mov    %r12,%rcx
  80265f:	48 ba ca 39 80 00 00 	movabs $0x8039ca,%rdx
  802666:	00 00 00 
  802669:	48 89 c7             	mov    %rax,%rdi
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	49 b8 37 29 80 00 00 	movabs $0x802937,%r8
  802678:	00 00 00 
  80267b:	41 ff d0             	callq  *%r8
			break;
  80267e:	e9 a5 02 00 00       	jmpq   802928 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802683:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802686:	83 f8 30             	cmp    $0x30,%eax
  802689:	73 17                	jae    8026a2 <vprintfmt+0x296>
  80268b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80268f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802692:	89 c0                	mov    %eax,%eax
  802694:	48 01 d0             	add    %rdx,%rax
  802697:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80269a:	83 c2 08             	add    $0x8,%edx
  80269d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8026a0:	eb 0f                	jmp    8026b1 <vprintfmt+0x2a5>
  8026a2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026a6:	48 89 d0             	mov    %rdx,%rax
  8026a9:	48 83 c2 08          	add    $0x8,%rdx
  8026ad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026b1:	4c 8b 20             	mov    (%rax),%r12
  8026b4:	4d 85 e4             	test   %r12,%r12
  8026b7:	75 0a                	jne    8026c3 <vprintfmt+0x2b7>
				p = "(null)";
  8026b9:	49 bc cd 39 80 00 00 	movabs $0x8039cd,%r12
  8026c0:	00 00 00 
			if (width > 0 && padc != '-')
  8026c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026c7:	7e 3f                	jle    802708 <vprintfmt+0x2fc>
  8026c9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026cd:	74 39                	je     802708 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026cf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026d2:	48 98                	cltq   
  8026d4:	48 89 c6             	mov    %rax,%rsi
  8026d7:	4c 89 e7             	mov    %r12,%rdi
  8026da:	48 b8 e3 2b 80 00 00 	movabs $0x802be3,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
  8026e6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026e9:	eb 17                	jmp    802702 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026eb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8026ef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8026f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026f7:	48 89 ce             	mov    %rcx,%rsi
  8026fa:	89 d7                	mov    %edx,%edi
  8026fc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8026fe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802702:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802706:	7f e3                	jg     8026eb <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802708:	eb 37                	jmp    802741 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80270a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80270e:	74 1e                	je     80272e <vprintfmt+0x322>
  802710:	83 fb 1f             	cmp    $0x1f,%ebx
  802713:	7e 05                	jle    80271a <vprintfmt+0x30e>
  802715:	83 fb 7e             	cmp    $0x7e,%ebx
  802718:	7e 14                	jle    80272e <vprintfmt+0x322>
					putch('?', putdat);
  80271a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80271e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802722:	48 89 d6             	mov    %rdx,%rsi
  802725:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80272a:	ff d0                	callq  *%rax
  80272c:	eb 0f                	jmp    80273d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80272e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802732:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802736:	48 89 d6             	mov    %rdx,%rsi
  802739:	89 df                	mov    %ebx,%edi
  80273b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80273d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802741:	4c 89 e0             	mov    %r12,%rax
  802744:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802748:	0f b6 00             	movzbl (%rax),%eax
  80274b:	0f be d8             	movsbl %al,%ebx
  80274e:	85 db                	test   %ebx,%ebx
  802750:	74 10                	je     802762 <vprintfmt+0x356>
  802752:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802756:	78 b2                	js     80270a <vprintfmt+0x2fe>
  802758:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80275c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802760:	79 a8                	jns    80270a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802762:	eb 16                	jmp    80277a <vprintfmt+0x36e>
				putch(' ', putdat);
  802764:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802768:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80276c:	48 89 d6             	mov    %rdx,%rsi
  80276f:	bf 20 00 00 00       	mov    $0x20,%edi
  802774:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802776:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80277a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80277e:	7f e4                	jg     802764 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802780:	e9 a3 01 00 00       	jmpq   802928 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802785:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802789:	be 03 00 00 00       	mov    $0x3,%esi
  80278e:	48 89 c7             	mov    %rax,%rdi
  802791:	48 b8 fc 22 80 00 00 	movabs $0x8022fc,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
  80279d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8027a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a5:	48 85 c0             	test   %rax,%rax
  8027a8:	79 1d                	jns    8027c7 <vprintfmt+0x3bb>
				putch('-', putdat);
  8027aa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027b2:	48 89 d6             	mov    %rdx,%rsi
  8027b5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027ba:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c0:	48 f7 d8             	neg    %rax
  8027c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027c7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027ce:	e9 e8 00 00 00       	jmpq   8028bb <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027d3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027d7:	be 03 00 00 00       	mov    $0x3,%esi
  8027dc:	48 89 c7             	mov    %rax,%rdi
  8027df:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	callq  *%rax
  8027eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8027ef:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027f6:	e9 c0 00 00 00       	jmpq   8028bb <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8027fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802803:	48 89 d6             	mov    %rdx,%rsi
  802806:	bf 58 00 00 00       	mov    $0x58,%edi
  80280b:	ff d0                	callq  *%rax
			putch('X', putdat);
  80280d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802811:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802815:	48 89 d6             	mov    %rdx,%rsi
  802818:	bf 58 00 00 00       	mov    $0x58,%edi
  80281d:	ff d0                	callq  *%rax
			putch('X', putdat);
  80281f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802823:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802827:	48 89 d6             	mov    %rdx,%rsi
  80282a:	bf 58 00 00 00       	mov    $0x58,%edi
  80282f:	ff d0                	callq  *%rax
			break;
  802831:	e9 f2 00 00 00       	jmpq   802928 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802836:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80283a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80283e:	48 89 d6             	mov    %rdx,%rsi
  802841:	bf 30 00 00 00       	mov    $0x30,%edi
  802846:	ff d0                	callq  *%rax
			putch('x', putdat);
  802848:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80284c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802850:	48 89 d6             	mov    %rdx,%rsi
  802853:	bf 78 00 00 00       	mov    $0x78,%edi
  802858:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80285a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80285d:	83 f8 30             	cmp    $0x30,%eax
  802860:	73 17                	jae    802879 <vprintfmt+0x46d>
  802862:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802866:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802869:	89 c0                	mov    %eax,%eax
  80286b:	48 01 d0             	add    %rdx,%rax
  80286e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802871:	83 c2 08             	add    $0x8,%edx
  802874:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802877:	eb 0f                	jmp    802888 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  802879:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80287d:	48 89 d0             	mov    %rdx,%rax
  802880:	48 83 c2 08          	add    $0x8,%rdx
  802884:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802888:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80288b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80288f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802896:	eb 23                	jmp    8028bb <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802898:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80289c:	be 03 00 00 00       	mov    $0x3,%esi
  8028a1:	48 89 c7             	mov    %rax,%rdi
  8028a4:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  8028ab:	00 00 00 
  8028ae:	ff d0                	callq  *%rax
  8028b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028b4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028bb:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028c0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028c3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028ca:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028d2:	45 89 c1             	mov    %r8d,%r9d
  8028d5:	41 89 f8             	mov    %edi,%r8d
  8028d8:	48 89 c7             	mov    %rax,%rdi
  8028db:	48 b8 31 21 80 00 00 	movabs $0x802131,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	callq  *%rax
			break;
  8028e7:	eb 3f                	jmp    802928 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028f1:	48 89 d6             	mov    %rdx,%rsi
  8028f4:	89 df                	mov    %ebx,%edi
  8028f6:	ff d0                	callq  *%rax
			break;
  8028f8:	eb 2e                	jmp    802928 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8028fa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028fe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802902:	48 89 d6             	mov    %rdx,%rsi
  802905:	bf 25 00 00 00       	mov    $0x25,%edi
  80290a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80290c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802911:	eb 05                	jmp    802918 <vprintfmt+0x50c>
  802913:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802918:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80291c:	48 83 e8 01          	sub    $0x1,%rax
  802920:	0f b6 00             	movzbl (%rax),%eax
  802923:	3c 25                	cmp    $0x25,%al
  802925:	75 ec                	jne    802913 <vprintfmt+0x507>
				/* do nothing */;
			break;
  802927:	90                   	nop
		}
	}
  802928:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802929:	e9 30 fb ff ff       	jmpq   80245e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80292e:	48 83 c4 60          	add    $0x60,%rsp
  802932:	5b                   	pop    %rbx
  802933:	41 5c                	pop    %r12
  802935:	5d                   	pop    %rbp
  802936:	c3                   	retq   

0000000000802937 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802937:	55                   	push   %rbp
  802938:	48 89 e5             	mov    %rsp,%rbp
  80293b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802942:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802949:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802950:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802957:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80295e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802965:	84 c0                	test   %al,%al
  802967:	74 20                	je     802989 <printfmt+0x52>
  802969:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80296d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802971:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802975:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802979:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80297d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802981:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802985:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802989:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802990:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802997:	00 00 00 
  80299a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8029a1:	00 00 00 
  8029a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029a8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029af:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029b6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029bd:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029c4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029cb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029d2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029d9:	48 89 c7             	mov    %rax,%rdi
  8029dc:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  8029e3:	00 00 00 
  8029e6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   

00000000008029ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029ea:	55                   	push   %rbp
  8029eb:	48 89 e5             	mov    %rsp,%rbp
  8029ee:	48 83 ec 10          	sub    $0x10,%rsp
  8029f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8029f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fd:	8b 40 10             	mov    0x10(%rax),%eax
  802a00:	8d 50 01             	lea    0x1(%rax),%edx
  802a03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a07:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0e:	48 8b 10             	mov    (%rax),%rdx
  802a11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a15:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a19:	48 39 c2             	cmp    %rax,%rdx
  802a1c:	73 17                	jae    802a35 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a22:	48 8b 00             	mov    (%rax),%rax
  802a25:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a2d:	48 89 0a             	mov    %rcx,(%rdx)
  802a30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a33:	88 10                	mov    %dl,(%rax)
}
  802a35:	c9                   	leaveq 
  802a36:	c3                   	retq   

0000000000802a37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a37:	55                   	push   %rbp
  802a38:	48 89 e5             	mov    %rsp,%rbp
  802a3b:	48 83 ec 50          	sub    $0x50,%rsp
  802a3f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a43:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a46:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a4a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a4e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a52:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a56:	48 8b 0a             	mov    (%rdx),%rcx
  802a59:	48 89 08             	mov    %rcx,(%rax)
  802a5c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a60:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a64:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a68:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a70:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a74:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a77:	48 98                	cltq   
  802a79:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a81:	48 01 d0             	add    %rdx,%rax
  802a84:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a8f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a94:	74 06                	je     802a9c <vsnprintf+0x65>
  802a96:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802a9a:	7f 07                	jg     802aa3 <vsnprintf+0x6c>
		return -E_INVAL;
  802a9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa1:	eb 2f                	jmp    802ad2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802aa3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802aa7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802aab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802aaf:	48 89 c6             	mov    %rax,%rsi
  802ab2:	48 bf ea 29 80 00 00 	movabs $0x8029ea,%rdi
  802ab9:	00 00 00 
  802abc:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802ac8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802acc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802acf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802ad2:	c9                   	leaveq 
  802ad3:	c3                   	retq   

0000000000802ad4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802ad4:	55                   	push   %rbp
  802ad5:	48 89 e5             	mov    %rsp,%rbp
  802ad8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802adf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802ae6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802aec:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802af3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802afa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b01:	84 c0                	test   %al,%al
  802b03:	74 20                	je     802b25 <snprintf+0x51>
  802b05:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b09:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b0d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b11:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b15:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b19:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b1d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b21:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b25:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b2c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b33:	00 00 00 
  802b36:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b3d:	00 00 00 
  802b40:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b44:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b4b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b52:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b59:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b60:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b67:	48 8b 0a             	mov    (%rdx),%rcx
  802b6a:	48 89 08             	mov    %rcx,(%rax)
  802b6d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b71:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b75:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b79:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b7d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b84:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b8b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b91:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b98:	48 89 c7             	mov    %rax,%rdi
  802b9b:	48 b8 37 2a 80 00 00 	movabs $0x802a37,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
  802ba7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802bad:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bb3:	c9                   	leaveq 
  802bb4:	c3                   	retq   

0000000000802bb5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802bb5:	55                   	push   %rbp
  802bb6:	48 89 e5             	mov    %rsp,%rbp
  802bb9:	48 83 ec 18          	sub    $0x18,%rsp
  802bbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bc8:	eb 09                	jmp    802bd3 <strlen+0x1e>
		n++;
  802bca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd7:	0f b6 00             	movzbl (%rax),%eax
  802bda:	84 c0                	test   %al,%al
  802bdc:	75 ec                	jne    802bca <strlen+0x15>
		n++;
	return n;
  802bde:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802be1:	c9                   	leaveq 
  802be2:	c3                   	retq   

0000000000802be3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802be3:	55                   	push   %rbp
  802be4:	48 89 e5             	mov    %rsp,%rbp
  802be7:	48 83 ec 20          	sub    $0x20,%rsp
  802beb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bfa:	eb 0e                	jmp    802c0a <strnlen+0x27>
		n++;
  802bfc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c00:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c05:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c0a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c0f:	74 0b                	je     802c1c <strnlen+0x39>
  802c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c15:	0f b6 00             	movzbl (%rax),%eax
  802c18:	84 c0                	test   %al,%al
  802c1a:	75 e0                	jne    802bfc <strnlen+0x19>
		n++;
	return n;
  802c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c1f:	c9                   	leaveq 
  802c20:	c3                   	retq   

0000000000802c21 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c21:	55                   	push   %rbp
  802c22:	48 89 e5             	mov    %rsp,%rbp
  802c25:	48 83 ec 20          	sub    $0x20,%rsp
  802c29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c39:	90                   	nop
  802c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c42:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c46:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c4a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c4e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c52:	0f b6 12             	movzbl (%rdx),%edx
  802c55:	88 10                	mov    %dl,(%rax)
  802c57:	0f b6 00             	movzbl (%rax),%eax
  802c5a:	84 c0                	test   %al,%al
  802c5c:	75 dc                	jne    802c3a <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c62:	c9                   	leaveq 
  802c63:	c3                   	retq   

0000000000802c64 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c64:	55                   	push   %rbp
  802c65:	48 89 e5             	mov    %rsp,%rbp
  802c68:	48 83 ec 20          	sub    $0x20,%rsp
  802c6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c78:	48 89 c7             	mov    %rax,%rdi
  802c7b:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  802c82:	00 00 00 
  802c85:	ff d0                	callq  *%rax
  802c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8d:	48 63 d0             	movslq %eax,%rdx
  802c90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c94:	48 01 c2             	add    %rax,%rdx
  802c97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c9b:	48 89 c6             	mov    %rax,%rsi
  802c9e:	48 89 d7             	mov    %rdx,%rdi
  802ca1:	48 b8 21 2c 80 00 00 	movabs $0x802c21,%rax
  802ca8:	00 00 00 
  802cab:	ff d0                	callq  *%rax
	return dst;
  802cad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802cb1:	c9                   	leaveq 
  802cb2:	c3                   	retq   

0000000000802cb3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802cb3:	55                   	push   %rbp
  802cb4:	48 89 e5             	mov    %rsp,%rbp
  802cb7:	48 83 ec 28          	sub    $0x28,%rsp
  802cbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cbf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cc3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802ccf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802cd6:	00 
  802cd7:	eb 2a                	jmp    802d03 <strncpy+0x50>
		*dst++ = *src;
  802cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802ce1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ce5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ce9:	0f b6 12             	movzbl (%rdx),%edx
  802cec:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802cee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf2:	0f b6 00             	movzbl (%rax),%eax
  802cf5:	84 c0                	test   %al,%al
  802cf7:	74 05                	je     802cfe <strncpy+0x4b>
			src++;
  802cf9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802cfe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d07:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d0b:	72 cc                	jb     802cd9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d11:	c9                   	leaveq 
  802d12:	c3                   	retq   

0000000000802d13 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d13:	55                   	push   %rbp
  802d14:	48 89 e5             	mov    %rsp,%rbp
  802d17:	48 83 ec 28          	sub    $0x28,%rsp
  802d1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d23:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d2f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d34:	74 3d                	je     802d73 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d36:	eb 1d                	jmp    802d55 <strlcpy+0x42>
			*dst++ = *src++;
  802d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d40:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d44:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d48:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d4c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d50:	0f b6 12             	movzbl (%rdx),%edx
  802d53:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d55:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d5a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d5f:	74 0b                	je     802d6c <strlcpy+0x59>
  802d61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d65:	0f b6 00             	movzbl (%rax),%eax
  802d68:	84 c0                	test   %al,%al
  802d6a:	75 cc                	jne    802d38 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d70:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d73:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7b:	48 29 c2             	sub    %rax,%rdx
  802d7e:	48 89 d0             	mov    %rdx,%rax
}
  802d81:	c9                   	leaveq 
  802d82:	c3                   	retq   

0000000000802d83 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d83:	55                   	push   %rbp
  802d84:	48 89 e5             	mov    %rsp,%rbp
  802d87:	48 83 ec 10          	sub    $0x10,%rsp
  802d8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d93:	eb 0a                	jmp    802d9f <strcmp+0x1c>
		p++, q++;
  802d95:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d9a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da3:	0f b6 00             	movzbl (%rax),%eax
  802da6:	84 c0                	test   %al,%al
  802da8:	74 12                	je     802dbc <strcmp+0x39>
  802daa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dae:	0f b6 10             	movzbl (%rax),%edx
  802db1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db5:	0f b6 00             	movzbl (%rax),%eax
  802db8:	38 c2                	cmp    %al,%dl
  802dba:	74 d9                	je     802d95 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802dbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc0:	0f b6 00             	movzbl (%rax),%eax
  802dc3:	0f b6 d0             	movzbl %al,%edx
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	0f b6 00             	movzbl (%rax),%eax
  802dcd:	0f b6 c0             	movzbl %al,%eax
  802dd0:	29 c2                	sub    %eax,%edx
  802dd2:	89 d0                	mov    %edx,%eax
}
  802dd4:	c9                   	leaveq 
  802dd5:	c3                   	retq   

0000000000802dd6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802dd6:	55                   	push   %rbp
  802dd7:	48 89 e5             	mov    %rsp,%rbp
  802dda:	48 83 ec 18          	sub    $0x18,%rsp
  802dde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802de2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802de6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802dea:	eb 0f                	jmp    802dfb <strncmp+0x25>
		n--, p++, q++;
  802dec:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802df1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802df6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802dfb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e00:	74 1d                	je     802e1f <strncmp+0x49>
  802e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e06:	0f b6 00             	movzbl (%rax),%eax
  802e09:	84 c0                	test   %al,%al
  802e0b:	74 12                	je     802e1f <strncmp+0x49>
  802e0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e11:	0f b6 10             	movzbl (%rax),%edx
  802e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e18:	0f b6 00             	movzbl (%rax),%eax
  802e1b:	38 c2                	cmp    %al,%dl
  802e1d:	74 cd                	je     802dec <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e1f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e24:	75 07                	jne    802e2d <strncmp+0x57>
		return 0;
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2b:	eb 18                	jmp    802e45 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e31:	0f b6 00             	movzbl (%rax),%eax
  802e34:	0f b6 d0             	movzbl %al,%edx
  802e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3b:	0f b6 00             	movzbl (%rax),%eax
  802e3e:	0f b6 c0             	movzbl %al,%eax
  802e41:	29 c2                	sub    %eax,%edx
  802e43:	89 d0                	mov    %edx,%eax
}
  802e45:	c9                   	leaveq 
  802e46:	c3                   	retq   

0000000000802e47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e47:	55                   	push   %rbp
  802e48:	48 89 e5             	mov    %rsp,%rbp
  802e4b:	48 83 ec 0c          	sub    $0xc,%rsp
  802e4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e53:	89 f0                	mov    %esi,%eax
  802e55:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e58:	eb 17                	jmp    802e71 <strchr+0x2a>
		if (*s == c)
  802e5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e5e:	0f b6 00             	movzbl (%rax),%eax
  802e61:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e64:	75 06                	jne    802e6c <strchr+0x25>
			return (char *) s;
  802e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6a:	eb 15                	jmp    802e81 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e6c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e75:	0f b6 00             	movzbl (%rax),%eax
  802e78:	84 c0                	test   %al,%al
  802e7a:	75 de                	jne    802e5a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e81:	c9                   	leaveq 
  802e82:	c3                   	retq   

0000000000802e83 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e83:	55                   	push   %rbp
  802e84:	48 89 e5             	mov    %rsp,%rbp
  802e87:	48 83 ec 0c          	sub    $0xc,%rsp
  802e8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e8f:	89 f0                	mov    %esi,%eax
  802e91:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e94:	eb 13                	jmp    802ea9 <strfind+0x26>
		if (*s == c)
  802e96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9a:	0f b6 00             	movzbl (%rax),%eax
  802e9d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802ea0:	75 02                	jne    802ea4 <strfind+0x21>
			break;
  802ea2:	eb 10                	jmp    802eb4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802ea4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ea9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ead:	0f b6 00             	movzbl (%rax),%eax
  802eb0:	84 c0                	test   %al,%al
  802eb2:	75 e2                	jne    802e96 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802eb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802eb8:	c9                   	leaveq 
  802eb9:	c3                   	retq   

0000000000802eba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802eba:	55                   	push   %rbp
  802ebb:	48 89 e5             	mov    %rsp,%rbp
  802ebe:	48 83 ec 18          	sub    $0x18,%rsp
  802ec2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ec6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ec9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ecd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ed2:	75 06                	jne    802eda <memset+0x20>
		return v;
  802ed4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed8:	eb 69                	jmp    802f43 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ede:	83 e0 03             	and    $0x3,%eax
  802ee1:	48 85 c0             	test   %rax,%rax
  802ee4:	75 48                	jne    802f2e <memset+0x74>
  802ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eea:	83 e0 03             	and    $0x3,%eax
  802eed:	48 85 c0             	test   %rax,%rax
  802ef0:	75 3c                	jne    802f2e <memset+0x74>
		c &= 0xFF;
  802ef2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802ef9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802efc:	c1 e0 18             	shl    $0x18,%eax
  802eff:	89 c2                	mov    %eax,%edx
  802f01:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f04:	c1 e0 10             	shl    $0x10,%eax
  802f07:	09 c2                	or     %eax,%edx
  802f09:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f0c:	c1 e0 08             	shl    $0x8,%eax
  802f0f:	09 d0                	or     %edx,%eax
  802f11:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f18:	48 c1 e8 02          	shr    $0x2,%rax
  802f1c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f23:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f26:	48 89 d7             	mov    %rdx,%rdi
  802f29:	fc                   	cld    
  802f2a:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f2c:	eb 11                	jmp    802f3f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f35:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f39:	48 89 d7             	mov    %rdx,%rdi
  802f3c:	fc                   	cld    
  802f3d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f43:	c9                   	leaveq 
  802f44:	c3                   	retq   

0000000000802f45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f45:	55                   	push   %rbp
  802f46:	48 89 e5             	mov    %rsp,%rbp
  802f49:	48 83 ec 28          	sub    $0x28,%rsp
  802f4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f55:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f71:	0f 83 88 00 00 00    	jae    802fff <memmove+0xba>
  802f77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f7f:	48 01 d0             	add    %rdx,%rax
  802f82:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f86:	76 77                	jbe    802fff <memmove+0xba>
		s += n;
  802f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f94:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9c:	83 e0 03             	and    $0x3,%eax
  802f9f:	48 85 c0             	test   %rax,%rax
  802fa2:	75 3b                	jne    802fdf <memmove+0x9a>
  802fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa8:	83 e0 03             	and    $0x3,%eax
  802fab:	48 85 c0             	test   %rax,%rax
  802fae:	75 2f                	jne    802fdf <memmove+0x9a>
  802fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb4:	83 e0 03             	and    $0x3,%eax
  802fb7:	48 85 c0             	test   %rax,%rax
  802fba:	75 23                	jne    802fdf <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc0:	48 83 e8 04          	sub    $0x4,%rax
  802fc4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fc8:	48 83 ea 04          	sub    $0x4,%rdx
  802fcc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fd0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fd4:	48 89 c7             	mov    %rax,%rdi
  802fd7:	48 89 d6             	mov    %rdx,%rsi
  802fda:	fd                   	std    
  802fdb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fdd:	eb 1d                	jmp    802ffc <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802fdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802fe7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802feb:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802fef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff3:	48 89 d7             	mov    %rdx,%rdi
  802ff6:	48 89 c1             	mov    %rax,%rcx
  802ff9:	fd                   	std    
  802ffa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802ffc:	fc                   	cld    
  802ffd:	eb 57                	jmp    803056 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802fff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803003:	83 e0 03             	and    $0x3,%eax
  803006:	48 85 c0             	test   %rax,%rax
  803009:	75 36                	jne    803041 <memmove+0xfc>
  80300b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300f:	83 e0 03             	and    $0x3,%eax
  803012:	48 85 c0             	test   %rax,%rax
  803015:	75 2a                	jne    803041 <memmove+0xfc>
  803017:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80301b:	83 e0 03             	and    $0x3,%eax
  80301e:	48 85 c0             	test   %rax,%rax
  803021:	75 1e                	jne    803041 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803023:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803027:	48 c1 e8 02          	shr    $0x2,%rax
  80302b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80302e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803032:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803036:	48 89 c7             	mov    %rax,%rdi
  803039:	48 89 d6             	mov    %rdx,%rsi
  80303c:	fc                   	cld    
  80303d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80303f:	eb 15                	jmp    803056 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803045:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803049:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80304d:	48 89 c7             	mov    %rax,%rdi
  803050:	48 89 d6             	mov    %rdx,%rsi
  803053:	fc                   	cld    
  803054:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80305a:	c9                   	leaveq 
  80305b:	c3                   	retq   

000000000080305c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80305c:	55                   	push   %rbp
  80305d:	48 89 e5             	mov    %rsp,%rbp
  803060:	48 83 ec 18          	sub    $0x18,%rsp
  803064:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803068:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80306c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803074:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80307c:	48 89 ce             	mov    %rcx,%rsi
  80307f:	48 89 c7             	mov    %rax,%rdi
  803082:	48 b8 45 2f 80 00 00 	movabs $0x802f45,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
}
  80308e:	c9                   	leaveq 
  80308f:	c3                   	retq   

0000000000803090 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803090:	55                   	push   %rbp
  803091:	48 89 e5             	mov    %rsp,%rbp
  803094:	48 83 ec 28          	sub    $0x28,%rsp
  803098:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8030a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030b4:	eb 36                	jmp    8030ec <memcmp+0x5c>
		if (*s1 != *s2)
  8030b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ba:	0f b6 10             	movzbl (%rax),%edx
  8030bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c1:	0f b6 00             	movzbl (%rax),%eax
  8030c4:	38 c2                	cmp    %al,%dl
  8030c6:	74 1a                	je     8030e2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030cc:	0f b6 00             	movzbl (%rax),%eax
  8030cf:	0f b6 d0             	movzbl %al,%edx
  8030d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d6:	0f b6 00             	movzbl (%rax),%eax
  8030d9:	0f b6 c0             	movzbl %al,%eax
  8030dc:	29 c2                	sub    %eax,%edx
  8030de:	89 d0                	mov    %edx,%eax
  8030e0:	eb 20                	jmp    803102 <memcmp+0x72>
		s1++, s2++;
  8030e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030e7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8030f8:	48 85 c0             	test   %rax,%rax
  8030fb:	75 b9                	jne    8030b6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8030fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803102:	c9                   	leaveq 
  803103:	c3                   	retq   

0000000000803104 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803104:	55                   	push   %rbp
  803105:	48 89 e5             	mov    %rsp,%rbp
  803108:	48 83 ec 28          	sub    $0x28,%rsp
  80310c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803110:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803113:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803117:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80311f:	48 01 d0             	add    %rdx,%rax
  803122:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803126:	eb 15                	jmp    80313d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312c:	0f b6 10             	movzbl (%rax),%edx
  80312f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803132:	38 c2                	cmp    %al,%dl
  803134:	75 02                	jne    803138 <memfind+0x34>
			break;
  803136:	eb 0f                	jmp    803147 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803138:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80313d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803141:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803145:	72 e1                	jb     803128 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
  803151:	48 83 ec 34          	sub    $0x34,%rsp
  803155:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803159:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80315d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803167:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80316e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80316f:	eb 05                	jmp    803176 <strtol+0x29>
		s++;
  803171:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803176:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317a:	0f b6 00             	movzbl (%rax),%eax
  80317d:	3c 20                	cmp    $0x20,%al
  80317f:	74 f0                	je     803171 <strtol+0x24>
  803181:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803185:	0f b6 00             	movzbl (%rax),%eax
  803188:	3c 09                	cmp    $0x9,%al
  80318a:	74 e5                	je     803171 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80318c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803190:	0f b6 00             	movzbl (%rax),%eax
  803193:	3c 2b                	cmp    $0x2b,%al
  803195:	75 07                	jne    80319e <strtol+0x51>
		s++;
  803197:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80319c:	eb 17                	jmp    8031b5 <strtol+0x68>
	else if (*s == '-')
  80319e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a2:	0f b6 00             	movzbl (%rax),%eax
  8031a5:	3c 2d                	cmp    $0x2d,%al
  8031a7:	75 0c                	jne    8031b5 <strtol+0x68>
		s++, neg = 1;
  8031a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031b9:	74 06                	je     8031c1 <strtol+0x74>
  8031bb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031bf:	75 28                	jne    8031e9 <strtol+0x9c>
  8031c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c5:	0f b6 00             	movzbl (%rax),%eax
  8031c8:	3c 30                	cmp    $0x30,%al
  8031ca:	75 1d                	jne    8031e9 <strtol+0x9c>
  8031cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d0:	48 83 c0 01          	add    $0x1,%rax
  8031d4:	0f b6 00             	movzbl (%rax),%eax
  8031d7:	3c 78                	cmp    $0x78,%al
  8031d9:	75 0e                	jne    8031e9 <strtol+0x9c>
		s += 2, base = 16;
  8031db:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031e0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031e7:	eb 2c                	jmp    803215 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031ed:	75 19                	jne    803208 <strtol+0xbb>
  8031ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f3:	0f b6 00             	movzbl (%rax),%eax
  8031f6:	3c 30                	cmp    $0x30,%al
  8031f8:	75 0e                	jne    803208 <strtol+0xbb>
		s++, base = 8;
  8031fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031ff:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803206:	eb 0d                	jmp    803215 <strtol+0xc8>
	else if (base == 0)
  803208:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80320c:	75 07                	jne    803215 <strtol+0xc8>
		base = 10;
  80320e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803219:	0f b6 00             	movzbl (%rax),%eax
  80321c:	3c 2f                	cmp    $0x2f,%al
  80321e:	7e 1d                	jle    80323d <strtol+0xf0>
  803220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803224:	0f b6 00             	movzbl (%rax),%eax
  803227:	3c 39                	cmp    $0x39,%al
  803229:	7f 12                	jg     80323d <strtol+0xf0>
			dig = *s - '0';
  80322b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322f:	0f b6 00             	movzbl (%rax),%eax
  803232:	0f be c0             	movsbl %al,%eax
  803235:	83 e8 30             	sub    $0x30,%eax
  803238:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80323b:	eb 4e                	jmp    80328b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80323d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803241:	0f b6 00             	movzbl (%rax),%eax
  803244:	3c 60                	cmp    $0x60,%al
  803246:	7e 1d                	jle    803265 <strtol+0x118>
  803248:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324c:	0f b6 00             	movzbl (%rax),%eax
  80324f:	3c 7a                	cmp    $0x7a,%al
  803251:	7f 12                	jg     803265 <strtol+0x118>
			dig = *s - 'a' + 10;
  803253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803257:	0f b6 00             	movzbl (%rax),%eax
  80325a:	0f be c0             	movsbl %al,%eax
  80325d:	83 e8 57             	sub    $0x57,%eax
  803260:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803263:	eb 26                	jmp    80328b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803265:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803269:	0f b6 00             	movzbl (%rax),%eax
  80326c:	3c 40                	cmp    $0x40,%al
  80326e:	7e 48                	jle    8032b8 <strtol+0x16b>
  803270:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803274:	0f b6 00             	movzbl (%rax),%eax
  803277:	3c 5a                	cmp    $0x5a,%al
  803279:	7f 3d                	jg     8032b8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80327b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327f:	0f b6 00             	movzbl (%rax),%eax
  803282:	0f be c0             	movsbl %al,%eax
  803285:	83 e8 37             	sub    $0x37,%eax
  803288:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80328b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80328e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803291:	7c 02                	jl     803295 <strtol+0x148>
			break;
  803293:	eb 23                	jmp    8032b8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803295:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80329a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80329d:	48 98                	cltq   
  80329f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8032a4:	48 89 c2             	mov    %rax,%rdx
  8032a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032aa:	48 98                	cltq   
  8032ac:	48 01 d0             	add    %rdx,%rax
  8032af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032b3:	e9 5d ff ff ff       	jmpq   803215 <strtol+0xc8>

	if (endptr)
  8032b8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032bd:	74 0b                	je     8032ca <strtol+0x17d>
		*endptr = (char *) s;
  8032bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032c7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ce:	74 09                	je     8032d9 <strtol+0x18c>
  8032d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d4:	48 f7 d8             	neg    %rax
  8032d7:	eb 04                	jmp    8032dd <strtol+0x190>
  8032d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032dd:	c9                   	leaveq 
  8032de:	c3                   	retq   

00000000008032df <strstr>:

char * strstr(const char *in, const char *str)
{
  8032df:	55                   	push   %rbp
  8032e0:	48 89 e5             	mov    %rsp,%rbp
  8032e3:	48 83 ec 30          	sub    $0x30,%rsp
  8032e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8032ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032f7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8032fb:	0f b6 00             	movzbl (%rax),%eax
  8032fe:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803301:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803305:	75 06                	jne    80330d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80330b:	eb 6b                	jmp    803378 <strstr+0x99>

	len = strlen(str);
  80330d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803311:	48 89 c7             	mov    %rax,%rdi
  803314:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  80331b:	00 00 00 
  80331e:	ff d0                	callq  *%rax
  803320:	48 98                	cltq   
  803322:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803326:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80332e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803332:	0f b6 00             	movzbl (%rax),%eax
  803335:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803338:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80333c:	75 07                	jne    803345 <strstr+0x66>
				return (char *) 0;
  80333e:	b8 00 00 00 00       	mov    $0x0,%eax
  803343:	eb 33                	jmp    803378 <strstr+0x99>
		} while (sc != c);
  803345:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803349:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80334c:	75 d8                	jne    803326 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80334e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803352:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80335a:	48 89 ce             	mov    %rcx,%rsi
  80335d:	48 89 c7             	mov    %rax,%rdi
  803360:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	75 b6                	jne    803326 <strstr+0x47>

	return (char *) (in - 1);
  803370:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803374:	48 83 e8 01          	sub    $0x1,%rax
}
  803378:	c9                   	leaveq 
  803379:	c3                   	retq   

000000000080337a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80337a:	55                   	push   %rbp
  80337b:	48 89 e5             	mov    %rsp,%rbp
  80337e:	48 83 ec 30          	sub    $0x30,%rsp
  803382:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803386:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80338a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80338e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803393:	75 0e                	jne    8033a3 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803395:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80339c:	00 00 00 
  80339f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a7:	48 89 c7             	mov    %rax,%rdi
  8033aa:	48 b8 17 05 80 00 00 	movabs $0x800517,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	callq  *%rax
  8033b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033bd:	79 27                	jns    8033e6 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033c4:	74 0a                	je     8033d0 <ipc_recv+0x56>
            *from_env_store = 0;
  8033c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033d0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033d5:	74 0a                	je     8033e1 <ipc_recv+0x67>
            *perm_store = 0;
  8033d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033db:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e4:	eb 53                	jmp    803439 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033eb:	74 19                	je     803406 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033ed:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033f4:	00 00 00 
  8033f7:	48 8b 00             	mov    (%rax),%rax
  8033fa:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803404:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803406:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80340b:	74 19                	je     803426 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80340d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803414:	00 00 00 
  803417:	48 8b 00             	mov    (%rax),%rax
  80341a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803424:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803426:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80342d:	00 00 00 
  803430:	48 8b 00             	mov    (%rax),%rax
  803433:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803439:	c9                   	leaveq 
  80343a:	c3                   	retq   

000000000080343b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80343b:	55                   	push   %rbp
  80343c:	48 89 e5             	mov    %rsp,%rbp
  80343f:	48 83 ec 30          	sub    $0x30,%rsp
  803443:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803446:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803449:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80344d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803450:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803455:	75 0e                	jne    803465 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803457:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80345e:	00 00 00 
  803461:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803465:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803468:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80346b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80346f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803472:	89 c7                	mov    %eax,%edi
  803474:	48 b8 c2 04 80 00 00 	movabs $0x8004c2,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	callq  *%rax
  803480:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803483:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803487:	79 36                	jns    8034bf <ipc_send+0x84>
  803489:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80348d:	74 30                	je     8034bf <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80348f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803492:	89 c1                	mov    %eax,%ecx
  803494:	48 ba 88 3c 80 00 00 	movabs $0x803c88,%rdx
  80349b:	00 00 00 
  80349e:	be 49 00 00 00       	mov    $0x49,%esi
  8034a3:	48 bf 95 3c 80 00 00 	movabs $0x803c95,%rdi
  8034aa:	00 00 00 
  8034ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b2:	49 b8 20 1e 80 00 00 	movabs $0x801e20,%r8
  8034b9:	00 00 00 
  8034bc:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034bf:	48 b8 b0 02 80 00 00 	movabs $0x8002b0,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
    } while(r != 0);
  8034cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034cf:	75 94                	jne    803465 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034d1:	c9                   	leaveq 
  8034d2:	c3                   	retq   

00000000008034d3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034d3:	55                   	push   %rbp
  8034d4:	48 89 e5             	mov    %rsp,%rbp
  8034d7:	48 83 ec 14          	sub    $0x14,%rsp
  8034db:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034e5:	eb 5e                	jmp    803545 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034e7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034ee:	00 00 00 
  8034f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f4:	48 63 d0             	movslq %eax,%rdx
  8034f7:	48 89 d0             	mov    %rdx,%rax
  8034fa:	48 c1 e0 03          	shl    $0x3,%rax
  8034fe:	48 01 d0             	add    %rdx,%rax
  803501:	48 c1 e0 05          	shl    $0x5,%rax
  803505:	48 01 c8             	add    %rcx,%rax
  803508:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80350e:	8b 00                	mov    (%rax),%eax
  803510:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803513:	75 2c                	jne    803541 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803515:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80351c:	00 00 00 
  80351f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803522:	48 63 d0             	movslq %eax,%rdx
  803525:	48 89 d0             	mov    %rdx,%rax
  803528:	48 c1 e0 03          	shl    $0x3,%rax
  80352c:	48 01 d0             	add    %rdx,%rax
  80352f:	48 c1 e0 05          	shl    $0x5,%rax
  803533:	48 01 c8             	add    %rcx,%rax
  803536:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80353c:	8b 40 08             	mov    0x8(%rax),%eax
  80353f:	eb 12                	jmp    803553 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803541:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803545:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80354c:	7e 99                	jle    8034e7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80354e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803553:	c9                   	leaveq 
  803554:	c3                   	retq   

0000000000803555 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803555:	55                   	push   %rbp
  803556:	48 89 e5             	mov    %rsp,%rbp
  803559:	48 83 ec 18          	sub    $0x18,%rsp
  80355d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803565:	48 c1 e8 15          	shr    $0x15,%rax
  803569:	48 89 c2             	mov    %rax,%rdx
  80356c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803573:	01 00 00 
  803576:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80357a:	83 e0 01             	and    $0x1,%eax
  80357d:	48 85 c0             	test   %rax,%rax
  803580:	75 07                	jne    803589 <pageref+0x34>
		return 0;
  803582:	b8 00 00 00 00       	mov    $0x0,%eax
  803587:	eb 53                	jmp    8035dc <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358d:	48 c1 e8 0c          	shr    $0xc,%rax
  803591:	48 89 c2             	mov    %rax,%rdx
  803594:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80359b:	01 00 00 
  80359e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035aa:	83 e0 01             	and    $0x1,%eax
  8035ad:	48 85 c0             	test   %rax,%rax
  8035b0:	75 07                	jne    8035b9 <pageref+0x64>
		return 0;
  8035b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b7:	eb 23                	jmp    8035dc <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035bd:	48 c1 e8 0c          	shr    $0xc,%rax
  8035c1:	48 89 c2             	mov    %rax,%rdx
  8035c4:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035cb:	00 00 00 
  8035ce:	48 c1 e2 04          	shl    $0x4,%rdx
  8035d2:	48 01 d0             	add    %rdx,%rax
  8035d5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035d9:	0f b7 c0             	movzwl %ax,%eax
}
  8035dc:	c9                   	leaveq 
  8035dd:	c3                   	retq   
