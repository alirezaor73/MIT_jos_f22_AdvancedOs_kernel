
obj/user/badsegment:     file format elf64-x86-64


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
  80003c:	e8 19 00 00 00       	callq  80005a <libmain>
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
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800052:	66 b8 28 00          	mov    $0x28,%ax
  800056:	8e d8                	mov    %eax,%ds
}
  800058:	c9                   	leaveq 
  800059:	c3                   	retq   

000000000080005a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005a:	55                   	push   %rbp
  80005b:	48 89 e5             	mov    %rsp,%rbp
  80005e:	48 83 ec 20          	sub    $0x20,%rsp
  800062:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800065:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800069:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
  800075:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800080:	48 63 d0             	movslq %eax,%rdx
  800083:	48 89 d0             	mov    %rdx,%rax
  800086:	48 c1 e0 03          	shl    $0x3,%rax
  80008a:	48 01 d0             	add    %rdx,%rax
  80008d:	48 c1 e0 05          	shl    $0x5,%rax
  800091:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800098:	00 00 00 
  80009b:	48 01 c2             	add    %rax,%rdx
  80009e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000a5:	00 00 00 
  8000a8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000af:	7e 14                	jle    8000c5 <libmain+0x6b>
		binaryname = argv[0];
  8000b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000b5:	48 8b 10             	mov    (%rax),%rdx
  8000b8:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000bf:	00 00 00 
  8000c2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000cc:	48 89 d6             	mov    %rdx,%rsi
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000dd:	48 b8 eb 00 80 00 00 	movabs $0x8000eb,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
}
  8000e9:	c9                   	leaveq 
  8000ea:	c3                   	retq   

00000000008000eb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000eb:	55                   	push   %rbp
  8000ec:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000ef:	48 b8 92 08 80 00 00 	movabs $0x800892,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8000fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800100:	48 b8 24 02 80 00 00 	movabs $0x800224,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
}
  80010c:	5d                   	pop    %rbp
  80010d:	c3                   	retq   

000000000080010e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80010e:	55                   	push   %rbp
  80010f:	48 89 e5             	mov    %rsp,%rbp
  800112:	53                   	push   %rbx
  800113:	48 83 ec 48          	sub    $0x48,%rsp
  800117:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80011a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80011d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800121:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800125:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800129:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800130:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800134:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800138:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80013c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800140:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800144:	4c 89 c3             	mov    %r8,%rbx
  800147:	cd 30                	int    $0x30
  800149:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80014d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800151:	74 3e                	je     800191 <syscall+0x83>
  800153:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800158:	7e 37                	jle    800191 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80015a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80015e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800161:	49 89 d0             	mov    %rdx,%r8
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba ea 35 80 00 00 	movabs $0x8035ea,%rdx
  80016d:	00 00 00 
  800170:	be 23 00 00 00       	mov    $0x23,%esi
  800175:	48 bf 07 36 80 00 00 	movabs $0x803607,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b9 16 1e 80 00 00 	movabs $0x801e16,%r9
  80018b:	00 00 00 
  80018e:	41 ff d1             	callq  *%r9

	return ret;
  800191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800195:	48 83 c4 48          	add    $0x48,%rsp
  800199:	5b                   	pop    %rbx
  80019a:	5d                   	pop    %rbp
  80019b:	c3                   	retq   

000000000080019c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80019c:	55                   	push   %rbp
  80019d:	48 89 e5             	mov    %rsp,%rbp
  8001a0:	48 83 ec 20          	sub    $0x20,%rsp
  8001a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001bb:	00 
  8001bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c8:	48 89 d1             	mov    %rdx,%rcx
  8001cb:	48 89 c2             	mov    %rax,%rdx
  8001ce:	be 00 00 00 00       	mov    $0x0,%esi
  8001d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d8:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax
}
  8001e4:	c9                   	leaveq 
  8001e5:	c3                   	retq   

00000000008001e6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e6:	55                   	push   %rbp
  8001e7:	48 89 e5             	mov    %rsp,%rbp
  8001ea:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f5:	00 
  8001f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800202:	b9 00 00 00 00       	mov    $0x0,%ecx
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 00 00       	mov    $0x0,%esi
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
  800216:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  80021d:	00 00 00 
  800220:	ff d0                	callq  *%rax
}
  800222:	c9                   	leaveq 
  800223:	c3                   	retq   

0000000000800224 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800224:	55                   	push   %rbp
  800225:	48 89 e5             	mov    %rsp,%rbp
  800228:	48 83 ec 10          	sub    $0x10,%rsp
  80022c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80022f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800232:	48 98                	cltq   
  800234:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80023b:	00 
  80023c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800242:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800248:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024d:	48 89 c2             	mov    %rax,%rdx
  800250:	be 01 00 00 00       	mov    $0x1,%esi
  800255:	bf 03 00 00 00       	mov    $0x3,%edi
  80025a:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
}
  800266:	c9                   	leaveq 
  800267:	c3                   	retq   

0000000000800268 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800268:	55                   	push   %rbp
  800269:	48 89 e5             	mov    %rsp,%rbp
  80026c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800270:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800277:	00 
  800278:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80027e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800284:	b9 00 00 00 00       	mov    $0x0,%ecx
  800289:	ba 00 00 00 00       	mov    $0x0,%edx
  80028e:	be 00 00 00 00       	mov    $0x0,%esi
  800293:	bf 02 00 00 00       	mov    $0x2,%edi
  800298:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
}
  8002a4:	c9                   	leaveq 
  8002a5:	c3                   	retq   

00000000008002a6 <sys_yield>:

void
sys_yield(void)
{
  8002a6:	55                   	push   %rbp
  8002a7:	48 89 e5             	mov    %rsp,%rbp
  8002aa:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002b5:	00 
  8002b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cc:	be 00 00 00 00       	mov    $0x0,%esi
  8002d1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002d6:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
}
  8002e2:	c9                   	leaveq 
  8002e3:	c3                   	retq   

00000000008002e4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002e4:	55                   	push   %rbp
  8002e5:	48 89 e5             	mov    %rsp,%rbp
  8002e8:	48 83 ec 20          	sub    $0x20,%rsp
  8002ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f9:	48 63 c8             	movslq %eax,%rcx
  8002fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800300:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800303:	48 98                	cltq   
  800305:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80030c:	00 
  80030d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800313:	49 89 c8             	mov    %rcx,%r8
  800316:	48 89 d1             	mov    %rdx,%rcx
  800319:	48 89 c2             	mov    %rax,%rdx
  80031c:	be 01 00 00 00       	mov    $0x1,%esi
  800321:	bf 04 00 00 00       	mov    $0x4,%edi
  800326:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
}
  800332:	c9                   	leaveq 
  800333:	c3                   	retq   

0000000000800334 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800334:	55                   	push   %rbp
  800335:	48 89 e5             	mov    %rsp,%rbp
  800338:	48 83 ec 30          	sub    $0x30,%rsp
  80033c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80033f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800343:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800346:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80034a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80034e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800351:	48 63 c8             	movslq %eax,%rcx
  800354:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800358:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80035b:	48 63 f0             	movslq %eax,%rsi
  80035e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800362:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800365:	48 98                	cltq   
  800367:	48 89 0c 24          	mov    %rcx,(%rsp)
  80036b:	49 89 f9             	mov    %rdi,%r9
  80036e:	49 89 f0             	mov    %rsi,%r8
  800371:	48 89 d1             	mov    %rdx,%rcx
  800374:	48 89 c2             	mov    %rax,%rdx
  800377:	be 01 00 00 00       	mov    $0x1,%esi
  80037c:	bf 05 00 00 00       	mov    $0x5,%edi
  800381:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  800388:	00 00 00 
  80038b:	ff d0                	callq  *%rax
}
  80038d:	c9                   	leaveq 
  80038e:	c3                   	retq   

000000000080038f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80038f:	55                   	push   %rbp
  800390:	48 89 e5             	mov    %rsp,%rbp
  800393:	48 83 ec 20          	sub    $0x20,%rsp
  800397:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80039e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a5:	48 98                	cltq   
  8003a7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003ae:	00 
  8003af:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003bb:	48 89 d1             	mov    %rdx,%rcx
  8003be:	48 89 c2             	mov    %rax,%rdx
  8003c1:	be 01 00 00 00       	mov    $0x1,%esi
  8003c6:	bf 06 00 00 00       	mov    $0x6,%edi
  8003cb:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  8003d2:	00 00 00 
  8003d5:	ff d0                	callq  *%rax
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
  8003dd:	48 83 ec 10          	sub    $0x10,%rsp
  8003e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ea:	48 63 d0             	movslq %eax,%rdx
  8003ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f0:	48 98                	cltq   
  8003f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003f9:	00 
  8003fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800400:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800406:	48 89 d1             	mov    %rdx,%rcx
  800409:	48 89 c2             	mov    %rax,%rdx
  80040c:	be 01 00 00 00       	mov    $0x1,%esi
  800411:	bf 08 00 00 00       	mov    $0x8,%edi
  800416:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  80041d:	00 00 00 
  800420:	ff d0                	callq  *%rax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 20          	sub    $0x20,%rsp
  80042c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800433:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800437:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043a:	48 98                	cltq   
  80043c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800443:	00 
  800444:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80044a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800450:	48 89 d1             	mov    %rdx,%rcx
  800453:	48 89 c2             	mov    %rax,%rdx
  800456:	be 01 00 00 00       	mov    $0x1,%esi
  80045b:	bf 09 00 00 00       	mov    $0x9,%edi
  800460:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  800467:	00 00 00 
  80046a:	ff d0                	callq  *%rax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   

000000000080046e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
  800472:	48 83 ec 20          	sub    $0x20,%rsp
  800476:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800479:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80047d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800484:	48 98                	cltq   
  800486:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80048d:	00 
  80048e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800494:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80049a:	48 89 d1             	mov    %rdx,%rcx
  80049d:	48 89 c2             	mov    %rax,%rdx
  8004a0:	be 01 00 00 00       	mov    $0x1,%esi
  8004a5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004aa:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  8004b1:	00 00 00 
  8004b4:	ff d0                	callq  *%rax
}
  8004b6:	c9                   	leaveq 
  8004b7:	c3                   	retq   

00000000008004b8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004b8:	55                   	push   %rbp
  8004b9:	48 89 e5             	mov    %rsp,%rbp
  8004bc:	48 83 ec 20          	sub    $0x20,%rsp
  8004c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004cb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004d1:	48 63 f0             	movslq %eax,%rsi
  8004d4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004db:	48 98                	cltq   
  8004dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e8:	00 
  8004e9:	49 89 f1             	mov    %rsi,%r9
  8004ec:	49 89 c8             	mov    %rcx,%r8
  8004ef:	48 89 d1             	mov    %rdx,%rcx
  8004f2:	48 89 c2             	mov    %rax,%rdx
  8004f5:	be 00 00 00 00       	mov    $0x0,%esi
  8004fa:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004ff:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  800506:	00 00 00 
  800509:	ff d0                	callq  *%rax
}
  80050b:	c9                   	leaveq 
  80050c:	c3                   	retq   

000000000080050d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80050d:	55                   	push   %rbp
  80050e:	48 89 e5             	mov    %rsp,%rbp
  800511:	48 83 ec 10          	sub    $0x10,%rsp
  800515:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800519:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80051d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800524:	00 
  800525:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80052b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800531:	b9 00 00 00 00       	mov    $0x0,%ecx
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	be 01 00 00 00       	mov    $0x1,%esi
  80053e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800543:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  80054a:	00 00 00 
  80054d:	ff d0                	callq  *%rax
}
  80054f:	c9                   	leaveq 
  800550:	c3                   	retq   

0000000000800551 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800551:	55                   	push   %rbp
  800552:	48 89 e5             	mov    %rsp,%rbp
  800555:	48 83 ec 08          	sub    $0x8,%rsp
  800559:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80055d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800561:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800568:	ff ff ff 
  80056b:	48 01 d0             	add    %rdx,%rax
  80056e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800572:	c9                   	leaveq 
  800573:	c3                   	retq   

0000000000800574 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800574:	55                   	push   %rbp
  800575:	48 89 e5             	mov    %rsp,%rbp
  800578:	48 83 ec 08          	sub    $0x8,%rsp
  80057c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800584:	48 89 c7             	mov    %rax,%rdi
  800587:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  80058e:	00 00 00 
  800591:	ff d0                	callq  *%rax
  800593:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800599:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80059d:	c9                   	leaveq 
  80059e:	c3                   	retq   

000000000080059f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80059f:	55                   	push   %rbp
  8005a0:	48 89 e5             	mov    %rsp,%rbp
  8005a3:	48 83 ec 18          	sub    $0x18,%rsp
  8005a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005b2:	eb 6b                	jmp    80061f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005b7:	48 98                	cltq   
  8005b9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8005c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005cb:	48 c1 e8 15          	shr    $0x15,%rax
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005d9:	01 00 00 
  8005dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e0:	83 e0 01             	and    $0x1,%eax
  8005e3:	48 85 c0             	test   %rax,%rax
  8005e6:	74 21                	je     800609 <fd_alloc+0x6a>
  8005e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8005f0:	48 89 c2             	mov    %rax,%rdx
  8005f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005fa:	01 00 00 
  8005fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800601:	83 e0 01             	and    $0x1,%eax
  800604:	48 85 c0             	test   %rax,%rax
  800607:	75 12                	jne    80061b <fd_alloc+0x7c>
			*fd_store = fd;
  800609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800611:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800614:	b8 00 00 00 00       	mov    $0x0,%eax
  800619:	eb 1a                	jmp    800635 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80061b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80061f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800623:	7e 8f                	jle    8005b4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800629:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800630:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800635:	c9                   	leaveq 
  800636:	c3                   	retq   

0000000000800637 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800637:	55                   	push   %rbp
  800638:	48 89 e5             	mov    %rsp,%rbp
  80063b:	48 83 ec 20          	sub    $0x20,%rsp
  80063f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800642:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800646:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80064a:	78 06                	js     800652 <fd_lookup+0x1b>
  80064c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800650:	7e 07                	jle    800659 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800652:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800657:	eb 6c                	jmp    8006c5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800659:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80065c:	48 98                	cltq   
  80065e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800664:	48 c1 e0 0c          	shl    $0xc,%rax
  800668:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80066c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800670:	48 c1 e8 15          	shr    $0x15,%rax
  800674:	48 89 c2             	mov    %rax,%rdx
  800677:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80067e:	01 00 00 
  800681:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800685:	83 e0 01             	and    $0x1,%eax
  800688:	48 85 c0             	test   %rax,%rax
  80068b:	74 21                	je     8006ae <fd_lookup+0x77>
  80068d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800691:	48 c1 e8 0c          	shr    $0xc,%rax
  800695:	48 89 c2             	mov    %rax,%rdx
  800698:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80069f:	01 00 00 
  8006a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a6:	83 e0 01             	and    $0x1,%eax
  8006a9:	48 85 c0             	test   %rax,%rax
  8006ac:	75 07                	jne    8006b5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b3:	eb 10                	jmp    8006c5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006bd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006c5:	c9                   	leaveq 
  8006c6:	c3                   	retq   

00000000008006c7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006c7:	55                   	push   %rbp
  8006c8:	48 89 e5             	mov    %rsp,%rbp
  8006cb:	48 83 ec 30          	sub    $0x30,%rsp
  8006cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006d3:	89 f0                	mov    %esi,%eax
  8006d5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006dc:	48 89 c7             	mov    %rax,%rdi
  8006df:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  8006e6:	00 00 00 
  8006e9:	ff d0                	callq  *%rax
  8006eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8006ef:	48 89 d6             	mov    %rdx,%rsi
  8006f2:	89 c7                	mov    %eax,%edi
  8006f4:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  8006fb:	00 00 00 
  8006fe:	ff d0                	callq  *%rax
  800700:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800703:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800707:	78 0a                	js     800713 <fd_close+0x4c>
	    || fd != fd2)
  800709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800711:	74 12                	je     800725 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800713:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800717:	74 05                	je     80071e <fd_close+0x57>
  800719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80071c:	eb 05                	jmp    800723 <fd_close+0x5c>
  80071e:	b8 00 00 00 00       	mov    $0x0,%eax
  800723:	eb 69                	jmp    80078e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80072f:	48 89 d6             	mov    %rdx,%rsi
  800732:	89 c7                	mov    %eax,%edi
  800734:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  80073b:	00 00 00 
  80073e:	ff d0                	callq  *%rax
  800740:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800743:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800747:	78 2a                	js     800773 <fd_close+0xac>
		if (dev->dev_close)
  800749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074d:	48 8b 40 20          	mov    0x20(%rax),%rax
  800751:	48 85 c0             	test   %rax,%rax
  800754:	74 16                	je     80076c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80075e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800762:	48 89 d7             	mov    %rdx,%rdi
  800765:	ff d0                	callq  *%rax
  800767:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80076a:	eb 07                	jmp    800773 <fd_close+0xac>
		else
			r = 0;
  80076c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800777:	48 89 c6             	mov    %rax,%rsi
  80077a:	bf 00 00 00 00       	mov    $0x0,%edi
  80077f:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  800786:	00 00 00 
  800789:	ff d0                	callq  *%rax
	return r;
  80078b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80078e:	c9                   	leaveq 
  80078f:	c3                   	retq   

0000000000800790 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800790:	55                   	push   %rbp
  800791:	48 89 e5             	mov    %rsp,%rbp
  800794:	48 83 ec 20          	sub    $0x20,%rsp
  800798:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80079b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80079f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007a6:	eb 41                	jmp    8007e9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007a8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007af:	00 00 00 
  8007b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007b5:	48 63 d2             	movslq %edx,%rdx
  8007b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007bc:	8b 00                	mov    (%rax),%eax
  8007be:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007c1:	75 22                	jne    8007e5 <dev_lookup+0x55>
			*dev = devtab[i];
  8007c3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007ca:	00 00 00 
  8007cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007d0:	48 63 d2             	movslq %edx,%rdx
  8007d3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007db:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007de:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e3:	eb 60                	jmp    800845 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007e9:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007f0:	00 00 00 
  8007f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007f6:	48 63 d2             	movslq %edx,%rdx
  8007f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007fd:	48 85 c0             	test   %rax,%rax
  800800:	75 a6                	jne    8007a8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800802:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800809:	00 00 00 
  80080c:	48 8b 00             	mov    (%rax),%rax
  80080f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800815:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800818:	89 c6                	mov    %eax,%esi
  80081a:	48 bf 18 36 80 00 00 	movabs $0x803618,%rdi
  800821:	00 00 00 
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	48 b9 4f 20 80 00 00 	movabs $0x80204f,%rcx
  800830:	00 00 00 
  800833:	ff d1                	callq  *%rcx
	*dev = 0;
  800835:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800839:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800840:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800845:	c9                   	leaveq 
  800846:	c3                   	retq   

0000000000800847 <close>:

int
close(int fdnum)
{
  800847:	55                   	push   %rbp
  800848:	48 89 e5             	mov    %rsp,%rbp
  80084b:	48 83 ec 20          	sub    $0x20,%rsp
  80084f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800852:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800856:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800859:	48 89 d6             	mov    %rdx,%rsi
  80085c:	89 c7                	mov    %eax,%edi
  80085e:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  800865:	00 00 00 
  800868:	ff d0                	callq  *%rax
  80086a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80086d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800871:	79 05                	jns    800878 <close+0x31>
		return r;
  800873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800876:	eb 18                	jmp    800890 <close+0x49>
	else
		return fd_close(fd, 1);
  800878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80087c:	be 01 00 00 00       	mov    $0x1,%esi
  800881:	48 89 c7             	mov    %rax,%rdi
  800884:	48 b8 c7 06 80 00 00 	movabs $0x8006c7,%rax
  80088b:	00 00 00 
  80088e:	ff d0                	callq  *%rax
}
  800890:	c9                   	leaveq 
  800891:	c3                   	retq   

0000000000800892 <close_all>:

void
close_all(void)
{
  800892:	55                   	push   %rbp
  800893:	48 89 e5             	mov    %rsp,%rbp
  800896:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80089a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008a1:	eb 15                	jmp    8008b8 <close_all+0x26>
		close(i);
  8008a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a6:	89 c7                	mov    %eax,%edi
  8008a8:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  8008af:	00 00 00 
  8008b2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008b8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008bc:	7e e5                	jle    8008a3 <close_all+0x11>
		close(i);
}
  8008be:	c9                   	leaveq 
  8008bf:	c3                   	retq   

00000000008008c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008c0:	55                   	push   %rbp
  8008c1:	48 89 e5             	mov    %rsp,%rbp
  8008c4:	48 83 ec 40          	sub    $0x40,%rsp
  8008c8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008cb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008ce:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008d2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008d5:	48 89 d6             	mov    %rdx,%rsi
  8008d8:	89 c7                	mov    %eax,%edi
  8008da:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  8008e1:	00 00 00 
  8008e4:	ff d0                	callq  *%rax
  8008e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008ed:	79 08                	jns    8008f7 <dup+0x37>
		return r;
  8008ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008f2:	e9 70 01 00 00       	jmpq   800a67 <dup+0x1a7>
	close(newfdnum);
  8008f7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8008fa:	89 c7                	mov    %eax,%edi
  8008fc:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800903:	00 00 00 
  800906:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800908:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80090b:	48 98                	cltq   
  80090d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800913:	48 c1 e0 0c          	shl    $0xc,%rax
  800917:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80091b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80091f:	48 89 c7             	mov    %rax,%rdi
  800922:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  800929:	00 00 00 
  80092c:	ff d0                	callq  *%rax
  80092e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800936:	48 89 c7             	mov    %rax,%rdi
  800939:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  800940:	00 00 00 
  800943:	ff d0                	callq  *%rax
  800945:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094d:	48 c1 e8 15          	shr    $0x15,%rax
  800951:	48 89 c2             	mov    %rax,%rdx
  800954:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80095b:	01 00 00 
  80095e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800962:	83 e0 01             	and    $0x1,%eax
  800965:	48 85 c0             	test   %rax,%rax
  800968:	74 73                	je     8009dd <dup+0x11d>
  80096a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096e:	48 c1 e8 0c          	shr    $0xc,%rax
  800972:	48 89 c2             	mov    %rax,%rdx
  800975:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80097c:	01 00 00 
  80097f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800983:	83 e0 01             	and    $0x1,%eax
  800986:	48 85 c0             	test   %rax,%rax
  800989:	74 52                	je     8009dd <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80098b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098f:	48 c1 e8 0c          	shr    $0xc,%rax
  800993:	48 89 c2             	mov    %rax,%rdx
  800996:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80099d:	01 00 00 
  8009a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8009a9:	89 c1                	mov    %eax,%ecx
  8009ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	41 89 c8             	mov    %ecx,%r8d
  8009b6:	48 89 d1             	mov    %rdx,%rcx
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	48 89 c6             	mov    %rax,%rsi
  8009c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8009c6:	48 b8 34 03 80 00 00 	movabs $0x800334,%rax
  8009cd:	00 00 00 
  8009d0:	ff d0                	callq  *%rax
  8009d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009d9:	79 02                	jns    8009dd <dup+0x11d>
			goto err;
  8009db:	eb 57                	jmp    800a34 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009e1:	48 c1 e8 0c          	shr    $0xc,%rax
  8009e5:	48 89 c2             	mov    %rax,%rdx
  8009e8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009ef:	01 00 00 
  8009f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8009fb:	89 c1                	mov    %eax,%ecx
  8009fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a05:	41 89 c8             	mov    %ecx,%r8d
  800a08:	48 89 d1             	mov    %rdx,%rcx
  800a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a10:	48 89 c6             	mov    %rax,%rsi
  800a13:	bf 00 00 00 00       	mov    $0x0,%edi
  800a18:	48 b8 34 03 80 00 00 	movabs $0x800334,%rax
  800a1f:	00 00 00 
  800a22:	ff d0                	callq  *%rax
  800a24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a2b:	79 02                	jns    800a2f <dup+0x16f>
		goto err;
  800a2d:	eb 05                	jmp    800a34 <dup+0x174>

	return newfdnum;
  800a2f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a32:	eb 33                	jmp    800a67 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a38:	48 89 c6             	mov    %rax,%rsi
  800a3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a40:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  800a47:	00 00 00 
  800a4a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a50:	48 89 c6             	mov    %rax,%rsi
  800a53:	bf 00 00 00 00       	mov    $0x0,%edi
  800a58:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  800a5f:	00 00 00 
  800a62:	ff d0                	callq  *%rax
	return r;
  800a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a67:	c9                   	leaveq 
  800a68:	c3                   	retq   

0000000000800a69 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a69:	55                   	push   %rbp
  800a6a:	48 89 e5             	mov    %rsp,%rbp
  800a6d:	48 83 ec 40          	sub    $0x40,%rsp
  800a71:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a74:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a78:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a7c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a83:	48 89 d6             	mov    %rdx,%rsi
  800a86:	89 c7                	mov    %eax,%edi
  800a88:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  800a8f:	00 00 00 
  800a92:	ff d0                	callq  *%rax
  800a94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a9b:	78 24                	js     800ac1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa1:	8b 00                	mov    (%rax),%eax
  800aa3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800aa7:	48 89 d6             	mov    %rdx,%rsi
  800aaa:	89 c7                	mov    %eax,%edi
  800aac:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800ab3:	00 00 00 
  800ab6:	ff d0                	callq  *%rax
  800ab8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800abb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800abf:	79 05                	jns    800ac6 <read+0x5d>
		return r;
  800ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ac4:	eb 76                	jmp    800b3c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aca:	8b 40 08             	mov    0x8(%rax),%eax
  800acd:	83 e0 03             	and    $0x3,%eax
  800ad0:	83 f8 01             	cmp    $0x1,%eax
  800ad3:	75 3a                	jne    800b0f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800ad5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800adc:	00 00 00 
  800adf:	48 8b 00             	mov    (%rax),%rax
  800ae2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800ae8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800aeb:	89 c6                	mov    %eax,%esi
  800aed:	48 bf 37 36 80 00 00 	movabs $0x803637,%rdi
  800af4:	00 00 00 
  800af7:	b8 00 00 00 00       	mov    $0x0,%eax
  800afc:	48 b9 4f 20 80 00 00 	movabs $0x80204f,%rcx
  800b03:	00 00 00 
  800b06:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b0d:	eb 2d                	jmp    800b3c <read+0xd3>
	}
	if (!dev->dev_read)
  800b0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b13:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b17:	48 85 c0             	test   %rax,%rax
  800b1a:	75 07                	jne    800b23 <read+0xba>
		return -E_NOT_SUPP;
  800b1c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b21:	eb 19                	jmp    800b3c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b27:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b2b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b2f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b33:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b37:	48 89 cf             	mov    %rcx,%rdi
  800b3a:	ff d0                	callq  *%rax
}
  800b3c:	c9                   	leaveq 
  800b3d:	c3                   	retq   

0000000000800b3e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b3e:	55                   	push   %rbp
  800b3f:	48 89 e5             	mov    %rsp,%rbp
  800b42:	48 83 ec 30          	sub    $0x30,%rsp
  800b46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b4d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b58:	eb 49                	jmp    800ba3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b5d:	48 98                	cltq   
  800b5f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b63:	48 29 c2             	sub    %rax,%rdx
  800b66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b69:	48 63 c8             	movslq %eax,%rcx
  800b6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b70:	48 01 c1             	add    %rax,%rcx
  800b73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b76:	48 89 ce             	mov    %rcx,%rsi
  800b79:	89 c7                	mov    %eax,%edi
  800b7b:	48 b8 69 0a 80 00 00 	movabs $0x800a69,%rax
  800b82:	00 00 00 
  800b85:	ff d0                	callq  *%rax
  800b87:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800b8a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b8e:	79 05                	jns    800b95 <readn+0x57>
			return m;
  800b90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b93:	eb 1c                	jmp    800bb1 <readn+0x73>
		if (m == 0)
  800b95:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b99:	75 02                	jne    800b9d <readn+0x5f>
			break;
  800b9b:	eb 11                	jmp    800bae <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ba0:	01 45 fc             	add    %eax,-0x4(%rbp)
  800ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ba6:	48 98                	cltq   
  800ba8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bac:	72 ac                	jb     800b5a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bb1:	c9                   	leaveq 
  800bb2:	c3                   	retq   

0000000000800bb3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bb3:	55                   	push   %rbp
  800bb4:	48 89 e5             	mov    %rsp,%rbp
  800bb7:	48 83 ec 40          	sub    $0x40,%rsp
  800bbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bbe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bc2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bc6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bcd:	48 89 d6             	mov    %rdx,%rsi
  800bd0:	89 c7                	mov    %eax,%edi
  800bd2:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  800bd9:	00 00 00 
  800bdc:	ff d0                	callq  *%rax
  800bde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800be1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800be5:	78 24                	js     800c0b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800beb:	8b 00                	mov    (%rax),%eax
  800bed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bf1:	48 89 d6             	mov    %rdx,%rsi
  800bf4:	89 c7                	mov    %eax,%edi
  800bf6:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800bfd:	00 00 00 
  800c00:	ff d0                	callq  *%rax
  800c02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c09:	79 05                	jns    800c10 <write+0x5d>
		return r;
  800c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c0e:	eb 75                	jmp    800c85 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c14:	8b 40 08             	mov    0x8(%rax),%eax
  800c17:	83 e0 03             	and    $0x3,%eax
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	75 3a                	jne    800c58 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c1e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c25:	00 00 00 
  800c28:	48 8b 00             	mov    (%rax),%rax
  800c2b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c31:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c34:	89 c6                	mov    %eax,%esi
  800c36:	48 bf 53 36 80 00 00 	movabs $0x803653,%rdi
  800c3d:	00 00 00 
  800c40:	b8 00 00 00 00       	mov    $0x0,%eax
  800c45:	48 b9 4f 20 80 00 00 	movabs $0x80204f,%rcx
  800c4c:	00 00 00 
  800c4f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c56:	eb 2d                	jmp    800c85 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c60:	48 85 c0             	test   %rax,%rax
  800c63:	75 07                	jne    800c6c <write+0xb9>
		return -E_NOT_SUPP;
  800c65:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c6a:	eb 19                	jmp    800c85 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c70:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c74:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c78:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c7c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c80:	48 89 cf             	mov    %rcx,%rdi
  800c83:	ff d0                	callq  *%rax
}
  800c85:	c9                   	leaveq 
  800c86:	c3                   	retq   

0000000000800c87 <seek>:

int
seek(int fdnum, off_t offset)
{
  800c87:	55                   	push   %rbp
  800c88:	48 89 e5             	mov    %rsp,%rbp
  800c8b:	48 83 ec 18          	sub    $0x18,%rsp
  800c8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c92:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c9c:	48 89 d6             	mov    %rdx,%rsi
  800c9f:	89 c7                	mov    %eax,%edi
  800ca1:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  800ca8:	00 00 00 
  800cab:	ff d0                	callq  *%rax
  800cad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cb4:	79 05                	jns    800cbb <seek+0x34>
		return r;
  800cb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb9:	eb 0f                	jmp    800cca <seek+0x43>
	fd->fd_offset = offset;
  800cbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cc2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cca:	c9                   	leaveq 
  800ccb:	c3                   	retq   

0000000000800ccc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800ccc:	55                   	push   %rbp
  800ccd:	48 89 e5             	mov    %rsp,%rbp
  800cd0:	48 83 ec 30          	sub    $0x30,%rsp
  800cd4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cd7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cda:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cde:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ce1:	48 89 d6             	mov    %rdx,%rsi
  800ce4:	89 c7                	mov    %eax,%edi
  800ce6:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  800ced:	00 00 00 
  800cf0:	ff d0                	callq  *%rax
  800cf2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cf5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cf9:	78 24                	js     800d1f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cff:	8b 00                	mov    (%rax),%eax
  800d01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d05:	48 89 d6             	mov    %rdx,%rsi
  800d08:	89 c7                	mov    %eax,%edi
  800d0a:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800d11:	00 00 00 
  800d14:	ff d0                	callq  *%rax
  800d16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d1d:	79 05                	jns    800d24 <ftruncate+0x58>
		return r;
  800d1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d22:	eb 72                	jmp    800d96 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d28:	8b 40 08             	mov    0x8(%rax),%eax
  800d2b:	83 e0 03             	and    $0x3,%eax
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	75 3a                	jne    800d6c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d32:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d39:	00 00 00 
  800d3c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d3f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d45:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d48:	89 c6                	mov    %eax,%esi
  800d4a:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  800d51:	00 00 00 
  800d54:	b8 00 00 00 00       	mov    $0x0,%eax
  800d59:	48 b9 4f 20 80 00 00 	movabs $0x80204f,%rcx
  800d60:	00 00 00 
  800d63:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d6a:	eb 2a                	jmp    800d96 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d70:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d74:	48 85 c0             	test   %rax,%rax
  800d77:	75 07                	jne    800d80 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d79:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d7e:	eb 16                	jmp    800d96 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d84:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800d8f:	89 ce                	mov    %ecx,%esi
  800d91:	48 89 d7             	mov    %rdx,%rdi
  800d94:	ff d0                	callq  *%rax
}
  800d96:	c9                   	leaveq 
  800d97:	c3                   	retq   

0000000000800d98 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800d98:	55                   	push   %rbp
  800d99:	48 89 e5             	mov    %rsp,%rbp
  800d9c:	48 83 ec 30          	sub    $0x30,%rsp
  800da0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800da3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800da7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dae:	48 89 d6             	mov    %rdx,%rsi
  800db1:	89 c7                	mov    %eax,%edi
  800db3:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  800dba:	00 00 00 
  800dbd:	ff d0                	callq  *%rax
  800dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc6:	78 24                	js     800dec <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcc:	8b 00                	mov    (%rax),%eax
  800dce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dd2:	48 89 d6             	mov    %rdx,%rsi
  800dd5:	89 c7                	mov    %eax,%edi
  800dd7:	48 b8 90 07 80 00 00 	movabs $0x800790,%rax
  800dde:	00 00 00 
  800de1:	ff d0                	callq  *%rax
  800de3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800de6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dea:	79 05                	jns    800df1 <fstat+0x59>
		return r;
  800dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800def:	eb 5e                	jmp    800e4f <fstat+0xb7>
	if (!dev->dev_stat)
  800df1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df5:	48 8b 40 28          	mov    0x28(%rax),%rax
  800df9:	48 85 c0             	test   %rax,%rax
  800dfc:	75 07                	jne    800e05 <fstat+0x6d>
		return -E_NOT_SUPP;
  800dfe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e03:	eb 4a                	jmp    800e4f <fstat+0xb7>
	stat->st_name[0] = 0;
  800e05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e09:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e10:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e17:	00 00 00 
	stat->st_isdir = 0;
  800e1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e1e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e25:	00 00 00 
	stat->st_dev = dev;
  800e28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e30:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3b:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e43:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e47:	48 89 ce             	mov    %rcx,%rsi
  800e4a:	48 89 d7             	mov    %rdx,%rdi
  800e4d:	ff d0                	callq  *%rax
}
  800e4f:	c9                   	leaveq 
  800e50:	c3                   	retq   

0000000000800e51 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e51:	55                   	push   %rbp
  800e52:	48 89 e5             	mov    %rsp,%rbp
  800e55:	48 83 ec 20          	sub    $0x20,%rsp
  800e59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e65:	be 00 00 00 00       	mov    $0x0,%esi
  800e6a:	48 89 c7             	mov    %rax,%rdi
  800e6d:	48 b8 3f 0f 80 00 00 	movabs $0x800f3f,%rax
  800e74:	00 00 00 
  800e77:	ff d0                	callq  *%rax
  800e79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e80:	79 05                	jns    800e87 <stat+0x36>
		return fd;
  800e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e85:	eb 2f                	jmp    800eb6 <stat+0x65>
	r = fstat(fd, stat);
  800e87:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8e:	48 89 d6             	mov    %rdx,%rsi
  800e91:	89 c7                	mov    %eax,%edi
  800e93:	48 b8 98 0d 80 00 00 	movabs $0x800d98,%rax
  800e9a:	00 00 00 
  800e9d:	ff d0                	callq  *%rax
  800e9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea5:	89 c7                	mov    %eax,%edi
  800ea7:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800eae:	00 00 00 
  800eb1:	ff d0                	callq  *%rax
	return r;
  800eb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800eb6:	c9                   	leaveq 
  800eb7:	c3                   	retq   

0000000000800eb8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800eb8:	55                   	push   %rbp
  800eb9:	48 89 e5             	mov    %rsp,%rbp
  800ebc:	48 83 ec 10          	sub    $0x10,%rsp
  800ec0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ec3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ec7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ece:	00 00 00 
  800ed1:	8b 00                	mov    (%rax),%eax
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	75 1d                	jne    800ef4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ed7:	bf 01 00 00 00       	mov    $0x1,%edi
  800edc:	48 b8 c9 34 80 00 00 	movabs $0x8034c9,%rax
  800ee3:	00 00 00 
  800ee6:	ff d0                	callq  *%rax
  800ee8:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800eef:	00 00 00 
  800ef2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ef4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800efb:	00 00 00 
  800efe:	8b 00                	mov    (%rax),%eax
  800f00:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f03:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f08:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f0f:	00 00 00 
  800f12:	89 c7                	mov    %eax,%edi
  800f14:	48 b8 31 34 80 00 00 	movabs $0x803431,%rax
  800f1b:	00 00 00 
  800f1e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f24:	ba 00 00 00 00       	mov    $0x0,%edx
  800f29:	48 89 c6             	mov    %rax,%rsi
  800f2c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f31:	48 b8 70 33 80 00 00 	movabs $0x803370,%rax
  800f38:	00 00 00 
  800f3b:	ff d0                	callq  *%rax
}
  800f3d:	c9                   	leaveq 
  800f3e:	c3                   	retq   

0000000000800f3f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f3f:	55                   	push   %rbp
  800f40:	48 89 e5             	mov    %rsp,%rbp
  800f43:	48 83 ec 20          	sub    $0x20,%rsp
  800f47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f4b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f52:	48 89 c7             	mov    %rax,%rdi
  800f55:	48 b8 ab 2b 80 00 00 	movabs $0x802bab,%rax
  800f5c:	00 00 00 
  800f5f:	ff d0                	callq  *%rax
  800f61:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f66:	7e 0a                	jle    800f72 <open+0x33>
		return -E_BAD_PATH;
  800f68:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f6d:	e9 a5 00 00 00       	jmpq   801017 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f72:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f76:	48 89 c7             	mov    %rax,%rdi
  800f79:	48 b8 9f 05 80 00 00 	movabs $0x80059f,%rax
  800f80:	00 00 00 
  800f83:	ff d0                	callq  *%rax
  800f85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f8c:	79 08                	jns    800f96 <open+0x57>
		return r;
  800f8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f91:	e9 81 00 00 00       	jmpq   801017 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800f96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9a:	48 89 c6             	mov    %rax,%rsi
  800f9d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fa4:	00 00 00 
  800fa7:	48 b8 17 2c 80 00 00 	movabs $0x802c17,%rax
  800fae:	00 00 00 
  800fb1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fb3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fba:	00 00 00 
  800fbd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fc0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fca:	48 89 c6             	mov    %rax,%rsi
  800fcd:	bf 01 00 00 00       	mov    $0x1,%edi
  800fd2:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  800fd9:	00 00 00 
  800fdc:	ff d0                	callq  *%rax
  800fde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fe1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fe5:	79 1d                	jns    801004 <open+0xc5>
		fd_close(fd, 0);
  800fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800feb:	be 00 00 00 00       	mov    $0x0,%esi
  800ff0:	48 89 c7             	mov    %rax,%rdi
  800ff3:	48 b8 c7 06 80 00 00 	movabs $0x8006c7,%rax
  800ffa:	00 00 00 
  800ffd:	ff d0                	callq  *%rax
		return r;
  800fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801002:	eb 13                	jmp    801017 <open+0xd8>
	}

	return fd2num(fd);
  801004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801008:	48 89 c7             	mov    %rax,%rdi
  80100b:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  801012:	00 00 00 
  801015:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  801017:	c9                   	leaveq 
  801018:	c3                   	retq   

0000000000801019 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801019:	55                   	push   %rbp
  80101a:	48 89 e5             	mov    %rsp,%rbp
  80101d:	48 83 ec 10          	sub    $0x10,%rsp
  801021:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801029:	8b 50 0c             	mov    0xc(%rax),%edx
  80102c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801033:	00 00 00 
  801036:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801038:	be 00 00 00 00       	mov    $0x0,%esi
  80103d:	bf 06 00 00 00       	mov    $0x6,%edi
  801042:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  801049:	00 00 00 
  80104c:	ff d0                	callq  *%rax
}
  80104e:	c9                   	leaveq 
  80104f:	c3                   	retq   

0000000000801050 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801050:	55                   	push   %rbp
  801051:	48 89 e5             	mov    %rsp,%rbp
  801054:	48 83 ec 30          	sub    $0x30,%rsp
  801058:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801060:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801068:	8b 50 0c             	mov    0xc(%rax),%edx
  80106b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801072:	00 00 00 
  801075:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801077:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80107e:	00 00 00 
  801081:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801085:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801089:	be 00 00 00 00       	mov    $0x0,%esi
  80108e:	bf 03 00 00 00       	mov    $0x3,%edi
  801093:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  80109a:	00 00 00 
  80109d:	ff d0                	callq  *%rax
  80109f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010a6:	79 08                	jns    8010b0 <devfile_read+0x60>
		return r;
  8010a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ab:	e9 a4 00 00 00       	jmpq   801154 <devfile_read+0x104>
	assert(r <= n);
  8010b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b3:	48 98                	cltq   
  8010b5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010b9:	76 35                	jbe    8010f0 <devfile_read+0xa0>
  8010bb:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  8010c2:	00 00 00 
  8010c5:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8010cc:	00 00 00 
  8010cf:	be 84 00 00 00       	mov    $0x84,%esi
  8010d4:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8010db:	00 00 00 
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e3:	49 b8 16 1e 80 00 00 	movabs $0x801e16,%r8
  8010ea:	00 00 00 
  8010ed:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8010f0:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8010f7:	7e 35                	jle    80112e <devfile_read+0xde>
  8010f9:	48 b9 c4 36 80 00 00 	movabs $0x8036c4,%rcx
  801100:	00 00 00 
  801103:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  80110a:	00 00 00 
  80110d:	be 85 00 00 00       	mov    $0x85,%esi
  801112:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  801119:	00 00 00 
  80111c:	b8 00 00 00 00       	mov    $0x0,%eax
  801121:	49 b8 16 1e 80 00 00 	movabs $0x801e16,%r8
  801128:	00 00 00 
  80112b:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80112e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801131:	48 63 d0             	movslq %eax,%rdx
  801134:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801138:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80113f:	00 00 00 
  801142:	48 89 c7             	mov    %rax,%rdi
  801145:	48 b8 3b 2f 80 00 00 	movabs $0x802f3b,%rax
  80114c:	00 00 00 
  80114f:	ff d0                	callq  *%rax
	return r;
  801151:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  801154:	c9                   	leaveq 
  801155:	c3                   	retq   

0000000000801156 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801156:	55                   	push   %rbp
  801157:	48 89 e5             	mov    %rsp,%rbp
  80115a:	48 83 ec 30          	sub    $0x30,%rsp
  80115e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801162:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801166:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80116a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116e:	8b 50 0c             	mov    0xc(%rax),%edx
  801171:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801178:	00 00 00 
  80117b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80117d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801184:	00 00 00 
  801187:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80118b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80118f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801196:	00 
  801197:	76 35                	jbe    8011ce <devfile_write+0x78>
  801199:	48 b9 d0 36 80 00 00 	movabs $0x8036d0,%rcx
  8011a0:	00 00 00 
  8011a3:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8011aa:	00 00 00 
  8011ad:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011b2:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8011b9:	00 00 00 
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c1:	49 b8 16 1e 80 00 00 	movabs $0x801e16,%r8
  8011c8:	00 00 00 
  8011cb:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011ce:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d6:	48 89 c6             	mov    %rax,%rsi
  8011d9:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011e0:	00 00 00 
  8011e3:	48 b8 52 30 80 00 00 	movabs $0x803052,%rax
  8011ea:	00 00 00 
  8011ed:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8011ef:	be 00 00 00 00       	mov    $0x0,%esi
  8011f4:	bf 04 00 00 00       	mov    $0x4,%edi
  8011f9:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  801200:	00 00 00 
  801203:	ff d0                	callq  *%rax
  801205:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801208:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80120c:	79 05                	jns    801213 <devfile_write+0xbd>
		return r;
  80120e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801211:	eb 43                	jmp    801256 <devfile_write+0x100>
	assert(r <= n);
  801213:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801216:	48 98                	cltq   
  801218:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80121c:	76 35                	jbe    801253 <devfile_write+0xfd>
  80121e:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  801225:	00 00 00 
  801228:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  80122f:	00 00 00 
  801232:	be a2 00 00 00       	mov    $0xa2,%esi
  801237:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  80123e:	00 00 00 
  801241:	b8 00 00 00 00       	mov    $0x0,%eax
  801246:	49 b8 16 1e 80 00 00 	movabs $0x801e16,%r8
  80124d:	00 00 00 
  801250:	41 ff d0             	callq  *%r8
	return r;
  801253:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801256:	c9                   	leaveq 
  801257:	c3                   	retq   

0000000000801258 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801258:	55                   	push   %rbp
  801259:	48 89 e5             	mov    %rsp,%rbp
  80125c:	48 83 ec 20          	sub    $0x20,%rsp
  801260:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801264:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126c:	8b 50 0c             	mov    0xc(%rax),%edx
  80126f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801276:	00 00 00 
  801279:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80127b:	be 00 00 00 00       	mov    $0x0,%esi
  801280:	bf 05 00 00 00       	mov    $0x5,%edi
  801285:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  80128c:	00 00 00 
  80128f:	ff d0                	callq  *%rax
  801291:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801298:	79 05                	jns    80129f <devfile_stat+0x47>
		return r;
  80129a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80129d:	eb 56                	jmp    8012f5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80129f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012aa:	00 00 00 
  8012ad:	48 89 c7             	mov    %rax,%rdi
  8012b0:	48 b8 17 2c 80 00 00 	movabs $0x802c17,%rax
  8012b7:	00 00 00 
  8012ba:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012bc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012c3:	00 00 00 
  8012c6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012d6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012dd:	00 00 00 
  8012e0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ea:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f5:	c9                   	leaveq 
  8012f6:	c3                   	retq   

00000000008012f7 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012f7:	55                   	push   %rbp
  8012f8:	48 89 e5             	mov    %rsp,%rbp
  8012fb:	48 83 ec 10          	sub    $0x10,%rsp
  8012ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801303:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130a:	8b 50 0c             	mov    0xc(%rax),%edx
  80130d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801314:	00 00 00 
  801317:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801319:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801320:	00 00 00 
  801323:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801326:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801329:	be 00 00 00 00       	mov    $0x0,%esi
  80132e:	bf 02 00 00 00       	mov    $0x2,%edi
  801333:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  80133a:	00 00 00 
  80133d:	ff d0                	callq  *%rax
}
  80133f:	c9                   	leaveq 
  801340:	c3                   	retq   

0000000000801341 <remove>:

// Delete a file
int
remove(const char *path)
{
  801341:	55                   	push   %rbp
  801342:	48 89 e5             	mov    %rsp,%rbp
  801345:	48 83 ec 10          	sub    $0x10,%rsp
  801349:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	48 89 c7             	mov    %rax,%rdi
  801354:	48 b8 ab 2b 80 00 00 	movabs $0x802bab,%rax
  80135b:	00 00 00 
  80135e:	ff d0                	callq  *%rax
  801360:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801365:	7e 07                	jle    80136e <remove+0x2d>
		return -E_BAD_PATH;
  801367:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80136c:	eb 33                	jmp    8013a1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80136e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801372:	48 89 c6             	mov    %rax,%rsi
  801375:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80137c:	00 00 00 
  80137f:	48 b8 17 2c 80 00 00 	movabs $0x802c17,%rax
  801386:	00 00 00 
  801389:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80138b:	be 00 00 00 00       	mov    $0x0,%esi
  801390:	bf 07 00 00 00       	mov    $0x7,%edi
  801395:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  80139c:	00 00 00 
  80139f:	ff d0                	callq  *%rax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013a7:	be 00 00 00 00       	mov    $0x0,%esi
  8013ac:	bf 08 00 00 00       	mov    $0x8,%edi
  8013b1:	48 b8 b8 0e 80 00 00 	movabs $0x800eb8,%rax
  8013b8:	00 00 00 
  8013bb:	ff d0                	callq  *%rax
}
  8013bd:	5d                   	pop    %rbp
  8013be:	c3                   	retq   

00000000008013bf <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013ca:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013d1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013d8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013df:	be 00 00 00 00       	mov    $0x0,%esi
  8013e4:	48 89 c7             	mov    %rax,%rdi
  8013e7:	48 b8 3f 0f 80 00 00 	movabs $0x800f3f,%rax
  8013ee:	00 00 00 
  8013f1:	ff d0                	callq  *%rax
  8013f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8013f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013fa:	79 28                	jns    801424 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8013fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013ff:	89 c6                	mov    %eax,%esi
  801401:	48 bf fd 36 80 00 00 	movabs $0x8036fd,%rdi
  801408:	00 00 00 
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	48 ba 4f 20 80 00 00 	movabs $0x80204f,%rdx
  801417:	00 00 00 
  80141a:	ff d2                	callq  *%rdx
		return fd_src;
  80141c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141f:	e9 74 01 00 00       	jmpq   801598 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801424:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80142b:	be 01 01 00 00       	mov    $0x101,%esi
  801430:	48 89 c7             	mov    %rax,%rdi
  801433:	48 b8 3f 0f 80 00 00 	movabs $0x800f3f,%rax
  80143a:	00 00 00 
  80143d:	ff d0                	callq  *%rax
  80143f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801442:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801446:	79 39                	jns    801481 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801448:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80144b:	89 c6                	mov    %eax,%esi
  80144d:	48 bf 13 37 80 00 00 	movabs $0x803713,%rdi
  801454:	00 00 00 
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
  80145c:	48 ba 4f 20 80 00 00 	movabs $0x80204f,%rdx
  801463:	00 00 00 
  801466:	ff d2                	callq  *%rdx
		close(fd_src);
  801468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80146b:	89 c7                	mov    %eax,%edi
  80146d:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  801474:	00 00 00 
  801477:	ff d0                	callq  *%rax
		return fd_dest;
  801479:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80147c:	e9 17 01 00 00       	jmpq   801598 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801481:	eb 74                	jmp    8014f7 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801483:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801486:	48 63 d0             	movslq %eax,%rdx
  801489:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801490:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801493:	48 89 ce             	mov    %rcx,%rsi
  801496:	89 c7                	mov    %eax,%edi
  801498:	48 b8 b3 0b 80 00 00 	movabs $0x800bb3,%rax
  80149f:	00 00 00 
  8014a2:	ff d0                	callq  *%rax
  8014a4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014ab:	79 4a                	jns    8014f7 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014ad:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014b0:	89 c6                	mov    %eax,%esi
  8014b2:	48 bf 2d 37 80 00 00 	movabs $0x80372d,%rdi
  8014b9:	00 00 00 
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c1:	48 ba 4f 20 80 00 00 	movabs $0x80204f,%rdx
  8014c8:	00 00 00 
  8014cb:	ff d2                	callq  *%rdx
			close(fd_src);
  8014cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014d0:	89 c7                	mov    %eax,%edi
  8014d2:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  8014d9:	00 00 00 
  8014dc:	ff d0                	callq  *%rax
			close(fd_dest);
  8014de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014e1:	89 c7                	mov    %eax,%edi
  8014e3:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  8014ea:	00 00 00 
  8014ed:	ff d0                	callq  *%rax
			return write_size;
  8014ef:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014f2:	e9 a1 00 00 00       	jmpq   801598 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014f7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801501:	ba 00 02 00 00       	mov    $0x200,%edx
  801506:	48 89 ce             	mov    %rcx,%rsi
  801509:	89 c7                	mov    %eax,%edi
  80150b:	48 b8 69 0a 80 00 00 	movabs $0x800a69,%rax
  801512:	00 00 00 
  801515:	ff d0                	callq  *%rax
  801517:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80151a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80151e:	0f 8f 5f ff ff ff    	jg     801483 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  801524:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801528:	79 47                	jns    801571 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80152a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152d:	89 c6                	mov    %eax,%esi
  80152f:	48 bf 40 37 80 00 00 	movabs $0x803740,%rdi
  801536:	00 00 00 
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	48 ba 4f 20 80 00 00 	movabs $0x80204f,%rdx
  801545:	00 00 00 
  801548:	ff d2                	callq  *%rdx
		close(fd_src);
  80154a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80154d:	89 c7                	mov    %eax,%edi
  80154f:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  801556:	00 00 00 
  801559:	ff d0                	callq  *%rax
		close(fd_dest);
  80155b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80155e:	89 c7                	mov    %eax,%edi
  801560:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  801567:	00 00 00 
  80156a:	ff d0                	callq  *%rax
		return read_size;
  80156c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80156f:	eb 27                	jmp    801598 <copy+0x1d9>
	}
	close(fd_src);
  801571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801574:	89 c7                	mov    %eax,%edi
  801576:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  80157d:	00 00 00 
  801580:	ff d0                	callq  *%rax
	close(fd_dest);
  801582:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801585:	89 c7                	mov    %eax,%edi
  801587:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  80158e:	00 00 00 
  801591:	ff d0                	callq  *%rax
	return 0;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801598:	c9                   	leaveq 
  801599:	c3                   	retq   

000000000080159a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80159a:	55                   	push   %rbp
  80159b:	48 89 e5             	mov    %rsp,%rbp
  80159e:	53                   	push   %rbx
  80159f:	48 83 ec 38          	sub    $0x38,%rsp
  8015a3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015a7:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015ab:	48 89 c7             	mov    %rax,%rdi
  8015ae:	48 b8 9f 05 80 00 00 	movabs $0x80059f,%rax
  8015b5:	00 00 00 
  8015b8:	ff d0                	callq  *%rax
  8015ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015c1:	0f 88 bf 01 00 00    	js     801786 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	ba 07 04 00 00       	mov    $0x407,%edx
  8015d0:	48 89 c6             	mov    %rax,%rsi
  8015d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8015d8:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  8015df:	00 00 00 
  8015e2:	ff d0                	callq  *%rax
  8015e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015eb:	0f 88 95 01 00 00    	js     801786 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8015f1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015f5:	48 89 c7             	mov    %rax,%rdi
  8015f8:	48 b8 9f 05 80 00 00 	movabs $0x80059f,%rax
  8015ff:	00 00 00 
  801602:	ff d0                	callq  *%rax
  801604:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801607:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80160b:	0f 88 5d 01 00 00    	js     80176e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801611:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801615:	ba 07 04 00 00       	mov    $0x407,%edx
  80161a:	48 89 c6             	mov    %rax,%rsi
  80161d:	bf 00 00 00 00       	mov    $0x0,%edi
  801622:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  801629:	00 00 00 
  80162c:	ff d0                	callq  *%rax
  80162e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801631:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801635:	0f 88 33 01 00 00    	js     80176e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	48 89 c7             	mov    %rax,%rdi
  801642:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  801649:	00 00 00 
  80164c:	ff d0                	callq  *%rax
  80164e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801652:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801656:	ba 07 04 00 00       	mov    $0x407,%edx
  80165b:	48 89 c6             	mov    %rax,%rsi
  80165e:	bf 00 00 00 00       	mov    $0x0,%edi
  801663:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  80166a:	00 00 00 
  80166d:	ff d0                	callq  *%rax
  80166f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801672:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801676:	79 05                	jns    80167d <pipe+0xe3>
		goto err2;
  801678:	e9 d9 00 00 00       	jmpq   801756 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80167d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801681:	48 89 c7             	mov    %rax,%rdi
  801684:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  80168b:	00 00 00 
  80168e:	ff d0                	callq  *%rax
  801690:	48 89 c2             	mov    %rax,%rdx
  801693:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801697:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80169d:	48 89 d1             	mov    %rdx,%rcx
  8016a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a5:	48 89 c6             	mov    %rax,%rsi
  8016a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ad:	48 b8 34 03 80 00 00 	movabs $0x800334,%rax
  8016b4:	00 00 00 
  8016b7:	ff d0                	callq  *%rax
  8016b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016c0:	79 1b                	jns    8016dd <pipe+0x143>
		goto err3;
  8016c2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016c7:	48 89 c6             	mov    %rax,%rsi
  8016ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8016cf:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  8016d6:	00 00 00 
  8016d9:	ff d0                	callq  *%rax
  8016db:	eb 79                	jmp    801756 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016e8:	00 00 00 
  8016eb:	8b 12                	mov    (%rdx),%edx
  8016ed:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8016fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fe:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801705:	00 00 00 
  801708:	8b 12                	mov    (%rdx),%edx
  80170a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80170c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801710:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	48 89 c7             	mov    %rax,%rdi
  80171e:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  801725:	00 00 00 
  801728:	ff d0                	callq  *%rax
  80172a:	89 c2                	mov    %eax,%edx
  80172c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801730:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801732:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801736:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80173a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173e:	48 89 c7             	mov    %rax,%rdi
  801741:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  801748:	00 00 00 
  80174b:	ff d0                	callq  *%rax
  80174d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
  801754:	eb 33                	jmp    801789 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175a:	48 89 c6             	mov    %rax,%rsi
  80175d:	bf 00 00 00 00       	mov    $0x0,%edi
  801762:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  801769:	00 00 00 
  80176c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	48 89 c6             	mov    %rax,%rsi
  801775:	bf 00 00 00 00       	mov    $0x0,%edi
  80177a:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  801781:	00 00 00 
  801784:	ff d0                	callq  *%rax
err:
	return r;
  801786:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801789:	48 83 c4 38          	add    $0x38,%rsp
  80178d:	5b                   	pop    %rbx
  80178e:	5d                   	pop    %rbp
  80178f:	c3                   	retq   

0000000000801790 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801790:	55                   	push   %rbp
  801791:	48 89 e5             	mov    %rsp,%rbp
  801794:	53                   	push   %rbx
  801795:	48 83 ec 28          	sub    $0x28,%rsp
  801799:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80179d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017a1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017a8:	00 00 00 
  8017ab:	48 8b 00             	mov    (%rax),%rax
  8017ae:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	48 89 c7             	mov    %rax,%rdi
  8017be:	48 b8 4b 35 80 00 00 	movabs $0x80354b,%rax
  8017c5:	00 00 00 
  8017c8:	ff d0                	callq  *%rax
  8017ca:	89 c3                	mov    %eax,%ebx
  8017cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d0:	48 89 c7             	mov    %rax,%rdi
  8017d3:	48 b8 4b 35 80 00 00 	movabs $0x80354b,%rax
  8017da:	00 00 00 
  8017dd:	ff d0                	callq  *%rax
  8017df:	39 c3                	cmp    %eax,%ebx
  8017e1:	0f 94 c0             	sete   %al
  8017e4:	0f b6 c0             	movzbl %al,%eax
  8017e7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8017ea:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017f1:	00 00 00 
  8017f4:	48 8b 00             	mov    (%rax),%rax
  8017f7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017fd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801800:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801803:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801806:	75 05                	jne    80180d <_pipeisclosed+0x7d>
			return ret;
  801808:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80180b:	eb 4f                	jmp    80185c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80180d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801810:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801813:	74 42                	je     801857 <_pipeisclosed+0xc7>
  801815:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801819:	75 3c                	jne    801857 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80181b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801822:	00 00 00 
  801825:	48 8b 00             	mov    (%rax),%rax
  801828:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80182e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801834:	89 c6                	mov    %eax,%esi
  801836:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  80183d:	00 00 00 
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	49 b8 4f 20 80 00 00 	movabs $0x80204f,%r8
  80184c:	00 00 00 
  80184f:	41 ff d0             	callq  *%r8
	}
  801852:	e9 4a ff ff ff       	jmpq   8017a1 <_pipeisclosed+0x11>
  801857:	e9 45 ff ff ff       	jmpq   8017a1 <_pipeisclosed+0x11>
}
  80185c:	48 83 c4 28          	add    $0x28,%rsp
  801860:	5b                   	pop    %rbx
  801861:	5d                   	pop    %rbp
  801862:	c3                   	retq   

0000000000801863 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801863:	55                   	push   %rbp
  801864:	48 89 e5             	mov    %rsp,%rbp
  801867:	48 83 ec 30          	sub    $0x30,%rsp
  80186b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80186e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801872:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801875:	48 89 d6             	mov    %rdx,%rsi
  801878:	89 c7                	mov    %eax,%edi
  80187a:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  801881:	00 00 00 
  801884:	ff d0                	callq  *%rax
  801886:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801889:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80188d:	79 05                	jns    801894 <pipeisclosed+0x31>
		return r;
  80188f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801892:	eb 31                	jmp    8018c5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801898:	48 89 c7             	mov    %rax,%rdi
  80189b:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  8018a2:	00 00 00 
  8018a5:	ff d0                	callq  *%rax
  8018a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b3:	48 89 d6             	mov    %rdx,%rsi
  8018b6:	48 89 c7             	mov    %rax,%rdi
  8018b9:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 40          	sub    $0x40,%rsp
  8018cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018df:	48 89 c7             	mov    %rax,%rdi
  8018e2:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  8018e9:	00 00 00 
  8018ec:	ff d0                	callq  *%rax
  8018ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8018f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8018fa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801901:	00 
  801902:	e9 92 00 00 00       	jmpq   801999 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801907:	eb 41                	jmp    80194a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801909:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80190e:	74 09                	je     801919 <devpipe_read+0x52>
				return i;
  801910:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801914:	e9 92 00 00 00       	jmpq   8019ab <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801919:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801921:	48 89 d6             	mov    %rdx,%rsi
  801924:	48 89 c7             	mov    %rax,%rdi
  801927:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  80192e:	00 00 00 
  801931:	ff d0                	callq  *%rax
  801933:	85 c0                	test   %eax,%eax
  801935:	74 07                	je     80193e <devpipe_read+0x77>
				return 0;
  801937:	b8 00 00 00 00       	mov    $0x0,%eax
  80193c:	eb 6d                	jmp    8019ab <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80193e:	48 b8 a6 02 80 00 00 	movabs $0x8002a6,%rax
  801945:	00 00 00 
  801948:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80194a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194e:	8b 10                	mov    (%rax),%edx
  801950:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801954:	8b 40 04             	mov    0x4(%rax),%eax
  801957:	39 c2                	cmp    %eax,%edx
  801959:	74 ae                	je     801909 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80195b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801963:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80196b:	8b 00                	mov    (%rax),%eax
  80196d:	99                   	cltd   
  80196e:	c1 ea 1b             	shr    $0x1b,%edx
  801971:	01 d0                	add    %edx,%eax
  801973:	83 e0 1f             	and    $0x1f,%eax
  801976:	29 d0                	sub    %edx,%eax
  801978:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197c:	48 98                	cltq   
  80197e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801983:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801985:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801989:	8b 00                	mov    (%rax),%eax
  80198b:	8d 50 01             	lea    0x1(%rax),%edx
  80198e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801992:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801994:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801999:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019a1:	0f 82 60 ff ff ff    	jb     801907 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019ab:	c9                   	leaveq 
  8019ac:	c3                   	retq   

00000000008019ad <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019ad:	55                   	push   %rbp
  8019ae:	48 89 e5             	mov    %rsp,%rbp
  8019b1:	48 83 ec 40          	sub    $0x40,%rsp
  8019b5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019bd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	48 89 c7             	mov    %rax,%rdi
  8019c8:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  8019cf:	00 00 00 
  8019d2:	ff d0                	callq  *%rax
  8019d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019e0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019e7:	00 
  8019e8:	e9 8e 00 00 00       	jmpq   801a7b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019ed:	eb 31                	jmp    801a20 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f7:	48 89 d6             	mov    %rdx,%rsi
  8019fa:	48 89 c7             	mov    %rax,%rdi
  8019fd:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801a04:	00 00 00 
  801a07:	ff d0                	callq  *%rax
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	74 07                	je     801a14 <devpipe_write+0x67>
				return 0;
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a12:	eb 79                	jmp    801a8d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a14:	48 b8 a6 02 80 00 00 	movabs $0x8002a6,%rax
  801a1b:	00 00 00 
  801a1e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a24:	8b 40 04             	mov    0x4(%rax),%eax
  801a27:	48 63 d0             	movslq %eax,%rdx
  801a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a2e:	8b 00                	mov    (%rax),%eax
  801a30:	48 98                	cltq   
  801a32:	48 83 c0 20          	add    $0x20,%rax
  801a36:	48 39 c2             	cmp    %rax,%rdx
  801a39:	73 b4                	jae    8019ef <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a3f:	8b 40 04             	mov    0x4(%rax),%eax
  801a42:	99                   	cltd   
  801a43:	c1 ea 1b             	shr    $0x1b,%edx
  801a46:	01 d0                	add    %edx,%eax
  801a48:	83 e0 1f             	and    $0x1f,%eax
  801a4b:	29 d0                	sub    %edx,%eax
  801a4d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a51:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a55:	48 01 ca             	add    %rcx,%rdx
  801a58:	0f b6 0a             	movzbl (%rdx),%ecx
  801a5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5f:	48 98                	cltq   
  801a61:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a69:	8b 40 04             	mov    0x4(%rax),%eax
  801a6c:	8d 50 01             	lea    0x1(%rax),%edx
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a73:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a76:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a83:	0f 82 64 ff ff ff    	jb     8019ed <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a8d:	c9                   	leaveq 
  801a8e:	c3                   	retq   

0000000000801a8f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a8f:	55                   	push   %rbp
  801a90:	48 89 e5             	mov    %rsp,%rbp
  801a93:	48 83 ec 20          	sub    $0x20,%rsp
  801a97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa3:	48 89 c7             	mov    %rax,%rdi
  801aa6:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  801aad:	00 00 00 
  801ab0:	ff d0                	callq  *%rax
  801ab2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801ab6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aba:	48 be 6e 37 80 00 00 	movabs $0x80376e,%rsi
  801ac1:	00 00 00 
  801ac4:	48 89 c7             	mov    %rax,%rdi
  801ac7:	48 b8 17 2c 80 00 00 	movabs $0x802c17,%rax
  801ace:	00 00 00 
  801ad1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801ad3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad7:	8b 50 04             	mov    0x4(%rax),%edx
  801ada:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ade:	8b 00                	mov    (%rax),%eax
  801ae0:	29 c2                	sub    %eax,%edx
  801ae2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ae6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801af7:	00 00 00 
	stat->st_dev = &devpipe;
  801afa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801afe:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b05:	00 00 00 
  801b08:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b14:	c9                   	leaveq 
  801b15:	c3                   	retq   

0000000000801b16 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b16:	55                   	push   %rbp
  801b17:	48 89 e5             	mov    %rsp,%rbp
  801b1a:	48 83 ec 10          	sub    $0x10,%rsp
  801b1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b26:	48 89 c6             	mov    %rax,%rsi
  801b29:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2e:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  801b35:	00 00 00 
  801b38:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3e:	48 89 c7             	mov    %rax,%rdi
  801b41:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  801b48:	00 00 00 
  801b4b:	ff d0                	callq  *%rax
  801b4d:	48 89 c6             	mov    %rax,%rsi
  801b50:	bf 00 00 00 00       	mov    $0x0,%edi
  801b55:	48 b8 8f 03 80 00 00 	movabs $0x80038f,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
}
  801b61:	c9                   	leaveq 
  801b62:	c3                   	retq   

0000000000801b63 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b63:	55                   	push   %rbp
  801b64:	48 89 e5             	mov    %rsp,%rbp
  801b67:	48 83 ec 20          	sub    $0x20,%rsp
  801b6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b71:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b74:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b78:	be 01 00 00 00       	mov    $0x1,%esi
  801b7d:	48 89 c7             	mov    %rax,%rdi
  801b80:	48 b8 9c 01 80 00 00 	movabs $0x80019c,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
}
  801b8c:	c9                   	leaveq 
  801b8d:	c3                   	retq   

0000000000801b8e <getchar>:

int
getchar(void)
{
  801b8e:	55                   	push   %rbp
  801b8f:	48 89 e5             	mov    %rsp,%rbp
  801b92:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801b96:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801b9a:	ba 01 00 00 00       	mov    $0x1,%edx
  801b9f:	48 89 c6             	mov    %rax,%rsi
  801ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba7:	48 b8 69 0a 80 00 00 	movabs $0x800a69,%rax
  801bae:	00 00 00 
  801bb1:	ff d0                	callq  *%rax
  801bb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bba:	79 05                	jns    801bc1 <getchar+0x33>
		return r;
  801bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbf:	eb 14                	jmp    801bd5 <getchar+0x47>
	if (r < 1)
  801bc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bc5:	7f 07                	jg     801bce <getchar+0x40>
		return -E_EOF;
  801bc7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801bcc:	eb 07                	jmp    801bd5 <getchar+0x47>
	return c;
  801bce:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801bd2:	0f b6 c0             	movzbl %al,%eax
}
  801bd5:	c9                   	leaveq 
  801bd6:	c3                   	retq   

0000000000801bd7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bd7:	55                   	push   %rbp
  801bd8:	48 89 e5             	mov    %rsp,%rbp
  801bdb:	48 83 ec 20          	sub    $0x20,%rsp
  801bdf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801be6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801be9:	48 89 d6             	mov    %rdx,%rsi
  801bec:	89 c7                	mov    %eax,%edi
  801bee:	48 b8 37 06 80 00 00 	movabs $0x800637,%rax
  801bf5:	00 00 00 
  801bf8:	ff d0                	callq  *%rax
  801bfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c01:	79 05                	jns    801c08 <iscons+0x31>
		return r;
  801c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c06:	eb 1a                	jmp    801c22 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c0c:	8b 10                	mov    (%rax),%edx
  801c0e:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c15:	00 00 00 
  801c18:	8b 00                	mov    (%rax),%eax
  801c1a:	39 c2                	cmp    %eax,%edx
  801c1c:	0f 94 c0             	sete   %al
  801c1f:	0f b6 c0             	movzbl %al,%eax
}
  801c22:	c9                   	leaveq 
  801c23:	c3                   	retq   

0000000000801c24 <opencons>:

int
opencons(void)
{
  801c24:	55                   	push   %rbp
  801c25:	48 89 e5             	mov    %rsp,%rbp
  801c28:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c2c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c30:	48 89 c7             	mov    %rax,%rdi
  801c33:	48 b8 9f 05 80 00 00 	movabs $0x80059f,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	callq  *%rax
  801c3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c46:	79 05                	jns    801c4d <opencons+0x29>
		return r;
  801c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4b:	eb 5b                	jmp    801ca8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c51:	ba 07 04 00 00       	mov    $0x407,%edx
  801c56:	48 89 c6             	mov    %rax,%rsi
  801c59:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5e:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  801c65:	00 00 00 
  801c68:	ff d0                	callq  *%rax
  801c6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c71:	79 05                	jns    801c78 <opencons+0x54>
		return r;
  801c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c76:	eb 30                	jmp    801ca8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c7c:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c83:	00 00 00 
  801c86:	8b 12                	mov    (%rdx),%edx
  801c88:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c99:	48 89 c7             	mov    %rax,%rdi
  801c9c:	48 b8 51 05 80 00 00 	movabs $0x800551,%rax
  801ca3:	00 00 00 
  801ca6:	ff d0                	callq  *%rax
}
  801ca8:	c9                   	leaveq 
  801ca9:	c3                   	retq   

0000000000801caa <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801caa:	55                   	push   %rbp
  801cab:	48 89 e5             	mov    %rsp,%rbp
  801cae:	48 83 ec 30          	sub    $0x30,%rsp
  801cb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cbe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cc3:	75 07                	jne    801ccc <devcons_read+0x22>
		return 0;
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cca:	eb 4b                	jmp    801d17 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801ccc:	eb 0c                	jmp    801cda <devcons_read+0x30>
		sys_yield();
  801cce:	48 b8 a6 02 80 00 00 	movabs $0x8002a6,%rax
  801cd5:	00 00 00 
  801cd8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cda:	48 b8 e6 01 80 00 00 	movabs $0x8001e6,%rax
  801ce1:	00 00 00 
  801ce4:	ff d0                	callq  *%rax
  801ce6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ced:	74 df                	je     801cce <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801cef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cf3:	79 05                	jns    801cfa <devcons_read+0x50>
		return c;
  801cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf8:	eb 1d                	jmp    801d17 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801cfa:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801cfe:	75 07                	jne    801d07 <devcons_read+0x5d>
		return 0;
  801d00:	b8 00 00 00 00       	mov    $0x0,%eax
  801d05:	eb 10                	jmp    801d17 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0a:	89 c2                	mov    %eax,%edx
  801d0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d10:	88 10                	mov    %dl,(%rax)
	return 1;
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d17:	c9                   	leaveq 
  801d18:	c3                   	retq   

0000000000801d19 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d19:	55                   	push   %rbp
  801d1a:	48 89 e5             	mov    %rsp,%rbp
  801d1d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d24:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d2b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d32:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d40:	eb 76                	jmp    801db8 <devcons_write+0x9f>
		m = n - tot;
  801d42:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d49:	89 c2                	mov    %eax,%edx
  801d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4e:	29 c2                	sub    %eax,%edx
  801d50:	89 d0                	mov    %edx,%eax
  801d52:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d58:	83 f8 7f             	cmp    $0x7f,%eax
  801d5b:	76 07                	jbe    801d64 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d5d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d64:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d67:	48 63 d0             	movslq %eax,%rdx
  801d6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6d:	48 63 c8             	movslq %eax,%rcx
  801d70:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d77:	48 01 c1             	add    %rax,%rcx
  801d7a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d81:	48 89 ce             	mov    %rcx,%rsi
  801d84:	48 89 c7             	mov    %rax,%rdi
  801d87:	48 b8 3b 2f 80 00 00 	movabs $0x802f3b,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801d93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d96:	48 63 d0             	movslq %eax,%rdx
  801d99:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801da0:	48 89 d6             	mov    %rdx,%rsi
  801da3:	48 89 c7             	mov    %rax,%rdi
  801da6:	48 b8 9c 01 80 00 00 	movabs $0x80019c,%rax
  801dad:	00 00 00 
  801db0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801db2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db5:	01 45 fc             	add    %eax,-0x4(%rbp)
  801db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbb:	48 98                	cltq   
  801dbd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dc4:	0f 82 78 ff ff ff    	jb     801d42 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dcd:	c9                   	leaveq 
  801dce:	c3                   	retq   

0000000000801dcf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801dcf:	55                   	push   %rbp
  801dd0:	48 89 e5             	mov    %rsp,%rbp
  801dd3:	48 83 ec 08          	sub    $0x8,%rsp
  801dd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de0:	c9                   	leaveq 
  801de1:	c3                   	retq   

0000000000801de2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801de2:	55                   	push   %rbp
  801de3:	48 89 e5             	mov    %rsp,%rbp
  801de6:	48 83 ec 10          	sub    $0x10,%rsp
  801dea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df6:	48 be 7a 37 80 00 00 	movabs $0x80377a,%rsi
  801dfd:	00 00 00 
  801e00:	48 89 c7             	mov    %rax,%rdi
  801e03:	48 b8 17 2c 80 00 00 	movabs $0x802c17,%rax
  801e0a:	00 00 00 
  801e0d:	ff d0                	callq  *%rax
	return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e14:	c9                   	leaveq 
  801e15:	c3                   	retq   

0000000000801e16 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e16:	55                   	push   %rbp
  801e17:	48 89 e5             	mov    %rsp,%rbp
  801e1a:	53                   	push   %rbx
  801e1b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e22:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e29:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e2f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e36:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e3d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e44:	84 c0                	test   %al,%al
  801e46:	74 23                	je     801e6b <_panic+0x55>
  801e48:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e4f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e53:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e57:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e5b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e5f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e63:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e67:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e6b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e72:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e79:	00 00 00 
  801e7c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e83:	00 00 00 
  801e86:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e8a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801e91:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801e98:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e9f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801ea6:	00 00 00 
  801ea9:	48 8b 18             	mov    (%rax),%rbx
  801eac:	48 b8 68 02 80 00 00 	movabs $0x800268,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
  801eb8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801ebe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ec5:	41 89 c8             	mov    %ecx,%r8d
  801ec8:	48 89 d1             	mov    %rdx,%rcx
  801ecb:	48 89 da             	mov    %rbx,%rdx
  801ece:	89 c6                	mov    %eax,%esi
  801ed0:	48 bf 88 37 80 00 00 	movabs $0x803788,%rdi
  801ed7:	00 00 00 
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	49 b9 4f 20 80 00 00 	movabs $0x80204f,%r9
  801ee6:	00 00 00 
  801ee9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801eec:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801ef3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801efa:	48 89 d6             	mov    %rdx,%rsi
  801efd:	48 89 c7             	mov    %rax,%rdi
  801f00:	48 b8 a3 1f 80 00 00 	movabs $0x801fa3,%rax
  801f07:	00 00 00 
  801f0a:	ff d0                	callq  *%rax
	cprintf("\n");
  801f0c:	48 bf ab 37 80 00 00 	movabs $0x8037ab,%rdi
  801f13:	00 00 00 
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1b:	48 ba 4f 20 80 00 00 	movabs $0x80204f,%rdx
  801f22:	00 00 00 
  801f25:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f27:	cc                   	int3   
  801f28:	eb fd                	jmp    801f27 <_panic+0x111>

0000000000801f2a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f2a:	55                   	push   %rbp
  801f2b:	48 89 e5             	mov    %rsp,%rbp
  801f2e:	48 83 ec 10          	sub    $0x10,%rsp
  801f32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3d:	8b 00                	mov    (%rax),%eax
  801f3f:	8d 48 01             	lea    0x1(%rax),%ecx
  801f42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f46:	89 0a                	mov    %ecx,(%rdx)
  801f48:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f4b:	89 d1                	mov    %edx,%ecx
  801f4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f51:	48 98                	cltq   
  801f53:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5b:	8b 00                	mov    (%rax),%eax
  801f5d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f62:	75 2c                	jne    801f90 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f68:	8b 00                	mov    (%rax),%eax
  801f6a:	48 98                	cltq   
  801f6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f70:	48 83 c2 08          	add    $0x8,%rdx
  801f74:	48 89 c6             	mov    %rax,%rsi
  801f77:	48 89 d7             	mov    %rdx,%rdi
  801f7a:	48 b8 9c 01 80 00 00 	movabs $0x80019c,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
        b->idx = 0;
  801f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f94:	8b 40 04             	mov    0x4(%rax),%eax
  801f97:	8d 50 01             	lea    0x1(%rax),%edx
  801f9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9e:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fa1:	c9                   	leaveq 
  801fa2:	c3                   	retq   

0000000000801fa3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fa3:	55                   	push   %rbp
  801fa4:	48 89 e5             	mov    %rsp,%rbp
  801fa7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fae:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fb5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fbc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fc3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fca:	48 8b 0a             	mov    (%rdx),%rcx
  801fcd:	48 89 08             	mov    %rcx,(%rax)
  801fd0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fd4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fd8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801fdc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801fe0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801fe7:	00 00 00 
    b.cnt = 0;
  801fea:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801ff1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801ff4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801ffb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802002:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802009:	48 89 c6             	mov    %rax,%rsi
  80200c:	48 bf 2a 1f 80 00 00 	movabs $0x801f2a,%rdi
  802013:	00 00 00 
  802016:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802022:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802028:	48 98                	cltq   
  80202a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802031:	48 83 c2 08          	add    $0x8,%rdx
  802035:	48 89 c6             	mov    %rax,%rsi
  802038:	48 89 d7             	mov    %rdx,%rdi
  80203b:	48 b8 9c 01 80 00 00 	movabs $0x80019c,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802047:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80204d:	c9                   	leaveq 
  80204e:	c3                   	retq   

000000000080204f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80204f:	55                   	push   %rbp
  802050:	48 89 e5             	mov    %rsp,%rbp
  802053:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80205a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802061:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802068:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80206f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802076:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80207d:	84 c0                	test   %al,%al
  80207f:	74 20                	je     8020a1 <cprintf+0x52>
  802081:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802085:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802089:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80208d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802091:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802095:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802099:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80209d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020a1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020a8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020af:	00 00 00 
  8020b2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020b9:	00 00 00 
  8020bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020c0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020c7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020ce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020d5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020dc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020e3:	48 8b 0a             	mov    (%rdx),%rcx
  8020e6:	48 89 08             	mov    %rcx,(%rax)
  8020e9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8020ed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8020f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8020f5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8020f9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802100:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802107:	48 89 d6             	mov    %rdx,%rsi
  80210a:	48 89 c7             	mov    %rax,%rdi
  80210d:	48 b8 a3 1f 80 00 00 	movabs $0x801fa3,%rax
  802114:	00 00 00 
  802117:	ff d0                	callq  *%rax
  802119:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80211f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802125:	c9                   	leaveq 
  802126:	c3                   	retq   

0000000000802127 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802127:	55                   	push   %rbp
  802128:	48 89 e5             	mov    %rsp,%rbp
  80212b:	53                   	push   %rbx
  80212c:	48 83 ec 38          	sub    $0x38,%rsp
  802130:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802134:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802138:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80213c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80213f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802143:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802147:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80214a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80214e:	77 3b                	ja     80218b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802150:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802153:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802157:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80215a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215e:	ba 00 00 00 00       	mov    $0x0,%edx
  802163:	48 f7 f3             	div    %rbx
  802166:	48 89 c2             	mov    %rax,%rdx
  802169:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80216c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80216f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802177:	41 89 f9             	mov    %edi,%r9d
  80217a:	48 89 c7             	mov    %rax,%rdi
  80217d:	48 b8 27 21 80 00 00 	movabs $0x802127,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
  802189:	eb 1e                	jmp    8021a9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80218b:	eb 12                	jmp    80219f <printnum+0x78>
			putch(padc, putdat);
  80218d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802191:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802198:	48 89 ce             	mov    %rcx,%rsi
  80219b:	89 d7                	mov    %edx,%edi
  80219d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80219f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021a7:	7f e4                	jg     80218d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021a9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b5:	48 f7 f1             	div    %rcx
  8021b8:	48 89 d0             	mov    %rdx,%rax
  8021bb:	48 ba b0 39 80 00 00 	movabs $0x8039b0,%rdx
  8021c2:	00 00 00 
  8021c5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021c9:	0f be d0             	movsbl %al,%edx
  8021cc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d4:	48 89 ce             	mov    %rcx,%rsi
  8021d7:	89 d7                	mov    %edx,%edi
  8021d9:	ff d0                	callq  *%rax
}
  8021db:	48 83 c4 38          	add    $0x38,%rsp
  8021df:	5b                   	pop    %rbx
  8021e0:	5d                   	pop    %rbp
  8021e1:	c3                   	retq   

00000000008021e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021e2:	55                   	push   %rbp
  8021e3:	48 89 e5             	mov    %rsp,%rbp
  8021e6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8021ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021ee:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8021f1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8021f5:	7e 52                	jle    802249 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8021f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fb:	8b 00                	mov    (%rax),%eax
  8021fd:	83 f8 30             	cmp    $0x30,%eax
  802200:	73 24                	jae    802226 <getuint+0x44>
  802202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802206:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80220a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220e:	8b 00                	mov    (%rax),%eax
  802210:	89 c0                	mov    %eax,%eax
  802212:	48 01 d0             	add    %rdx,%rax
  802215:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802219:	8b 12                	mov    (%rdx),%edx
  80221b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80221e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802222:	89 0a                	mov    %ecx,(%rdx)
  802224:	eb 17                	jmp    80223d <getuint+0x5b>
  802226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80222e:	48 89 d0             	mov    %rdx,%rax
  802231:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802235:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802239:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80223d:	48 8b 00             	mov    (%rax),%rax
  802240:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802244:	e9 a3 00 00 00       	jmpq   8022ec <getuint+0x10a>
	else if (lflag)
  802249:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80224d:	74 4f                	je     80229e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80224f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802253:	8b 00                	mov    (%rax),%eax
  802255:	83 f8 30             	cmp    $0x30,%eax
  802258:	73 24                	jae    80227e <getuint+0x9c>
  80225a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802266:	8b 00                	mov    (%rax),%eax
  802268:	89 c0                	mov    %eax,%eax
  80226a:	48 01 d0             	add    %rdx,%rax
  80226d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802271:	8b 12                	mov    (%rdx),%edx
  802273:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802276:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227a:	89 0a                	mov    %ecx,(%rdx)
  80227c:	eb 17                	jmp    802295 <getuint+0xb3>
  80227e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802282:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802286:	48 89 d0             	mov    %rdx,%rax
  802289:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80228d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802291:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802295:	48 8b 00             	mov    (%rax),%rax
  802298:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80229c:	eb 4e                	jmp    8022ec <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80229e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a2:	8b 00                	mov    (%rax),%eax
  8022a4:	83 f8 30             	cmp    $0x30,%eax
  8022a7:	73 24                	jae    8022cd <getuint+0xeb>
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
  8022cb:	eb 17                	jmp    8022e4 <getuint+0x102>
  8022cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022d5:	48 89 d0             	mov    %rdx,%rax
  8022d8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022e0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022e4:	8b 00                	mov    (%rax),%eax
  8022e6:	89 c0                	mov    %eax,%eax
  8022e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8022ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022f0:	c9                   	leaveq 
  8022f1:	c3                   	retq   

00000000008022f2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8022f2:	55                   	push   %rbp
  8022f3:	48 89 e5             	mov    %rsp,%rbp
  8022f6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8022fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022fe:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802301:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802305:	7e 52                	jle    802359 <getint+0x67>
		x=va_arg(*ap, long long);
  802307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230b:	8b 00                	mov    (%rax),%eax
  80230d:	83 f8 30             	cmp    $0x30,%eax
  802310:	73 24                	jae    802336 <getint+0x44>
  802312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802316:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80231a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231e:	8b 00                	mov    (%rax),%eax
  802320:	89 c0                	mov    %eax,%eax
  802322:	48 01 d0             	add    %rdx,%rax
  802325:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802329:	8b 12                	mov    (%rdx),%edx
  80232b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80232e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802332:	89 0a                	mov    %ecx,(%rdx)
  802334:	eb 17                	jmp    80234d <getint+0x5b>
  802336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80233e:	48 89 d0             	mov    %rdx,%rax
  802341:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802345:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802349:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80234d:	48 8b 00             	mov    (%rax),%rax
  802350:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802354:	e9 a3 00 00 00       	jmpq   8023fc <getint+0x10a>
	else if (lflag)
  802359:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80235d:	74 4f                	je     8023ae <getint+0xbc>
		x=va_arg(*ap, long);
  80235f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802363:	8b 00                	mov    (%rax),%eax
  802365:	83 f8 30             	cmp    $0x30,%eax
  802368:	73 24                	jae    80238e <getint+0x9c>
  80236a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802376:	8b 00                	mov    (%rax),%eax
  802378:	89 c0                	mov    %eax,%eax
  80237a:	48 01 d0             	add    %rdx,%rax
  80237d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802381:	8b 12                	mov    (%rdx),%edx
  802383:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802386:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80238a:	89 0a                	mov    %ecx,(%rdx)
  80238c:	eb 17                	jmp    8023a5 <getint+0xb3>
  80238e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802392:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802396:	48 89 d0             	mov    %rdx,%rax
  802399:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80239d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023a5:	48 8b 00             	mov    (%rax),%rax
  8023a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023ac:	eb 4e                	jmp    8023fc <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b2:	8b 00                	mov    (%rax),%eax
  8023b4:	83 f8 30             	cmp    $0x30,%eax
  8023b7:	73 24                	jae    8023dd <getint+0xeb>
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
  8023db:	eb 17                	jmp    8023f4 <getint+0x102>
  8023dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023e5:	48 89 d0             	mov    %rdx,%rax
  8023e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023f4:	8b 00                	mov    (%rax),%eax
  8023f6:	48 98                	cltq   
  8023f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8023fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802400:	c9                   	leaveq 
  802401:	c3                   	retq   

0000000000802402 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802402:	55                   	push   %rbp
  802403:	48 89 e5             	mov    %rsp,%rbp
  802406:	41 54                	push   %r12
  802408:	53                   	push   %rbx
  802409:	48 83 ec 60          	sub    $0x60,%rsp
  80240d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802411:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802415:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802419:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80241d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802421:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802425:	48 8b 0a             	mov    (%rdx),%rcx
  802428:	48 89 08             	mov    %rcx,(%rax)
  80242b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80242f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802433:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802437:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80243b:	eb 17                	jmp    802454 <vprintfmt+0x52>
			if (ch == '\0')
  80243d:	85 db                	test   %ebx,%ebx
  80243f:	0f 84 df 04 00 00    	je     802924 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  802445:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802449:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80244d:	48 89 d6             	mov    %rdx,%rsi
  802450:	89 df                	mov    %ebx,%edi
  802452:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802454:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802458:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80245c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802460:	0f b6 00             	movzbl (%rax),%eax
  802463:	0f b6 d8             	movzbl %al,%ebx
  802466:	83 fb 25             	cmp    $0x25,%ebx
  802469:	75 d2                	jne    80243d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80246b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80246f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802476:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80247d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802484:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80248b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80248f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802493:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802497:	0f b6 00             	movzbl (%rax),%eax
  80249a:	0f b6 d8             	movzbl %al,%ebx
  80249d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024a0:	83 f8 55             	cmp    $0x55,%eax
  8024a3:	0f 87 47 04 00 00    	ja     8028f0 <vprintfmt+0x4ee>
  8024a9:	89 c0                	mov    %eax,%eax
  8024ab:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024b2:	00 
  8024b3:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  8024ba:	00 00 00 
  8024bd:	48 01 d0             	add    %rdx,%rax
  8024c0:	48 8b 00             	mov    (%rax),%rax
  8024c3:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024c5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024c9:	eb c0                	jmp    80248b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024cb:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024cf:	eb ba                	jmp    80248b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024d1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024d8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024db:	89 d0                	mov    %edx,%eax
  8024dd:	c1 e0 02             	shl    $0x2,%eax
  8024e0:	01 d0                	add    %edx,%eax
  8024e2:	01 c0                	add    %eax,%eax
  8024e4:	01 d8                	add    %ebx,%eax
  8024e6:	83 e8 30             	sub    $0x30,%eax
  8024e9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8024ec:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024f0:	0f b6 00             	movzbl (%rax),%eax
  8024f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8024f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8024f9:	7e 0c                	jle    802507 <vprintfmt+0x105>
  8024fb:	83 fb 39             	cmp    $0x39,%ebx
  8024fe:	7f 07                	jg     802507 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802500:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802505:	eb d1                	jmp    8024d8 <vprintfmt+0xd6>
			goto process_precision;
  802507:	eb 58                	jmp    802561 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802509:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80250c:	83 f8 30             	cmp    $0x30,%eax
  80250f:	73 17                	jae    802528 <vprintfmt+0x126>
  802511:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802515:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802518:	89 c0                	mov    %eax,%eax
  80251a:	48 01 d0             	add    %rdx,%rax
  80251d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802520:	83 c2 08             	add    $0x8,%edx
  802523:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802526:	eb 0f                	jmp    802537 <vprintfmt+0x135>
  802528:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80252c:	48 89 d0             	mov    %rdx,%rax
  80252f:	48 83 c2 08          	add    $0x8,%rdx
  802533:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802537:	8b 00                	mov    (%rax),%eax
  802539:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80253c:	eb 23                	jmp    802561 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80253e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802542:	79 0c                	jns    802550 <vprintfmt+0x14e>
				width = 0;
  802544:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80254b:	e9 3b ff ff ff       	jmpq   80248b <vprintfmt+0x89>
  802550:	e9 36 ff ff ff       	jmpq   80248b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802555:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80255c:	e9 2a ff ff ff       	jmpq   80248b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802561:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802565:	79 12                	jns    802579 <vprintfmt+0x177>
				width = precision, precision = -1;
  802567:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80256a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80256d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802574:	e9 12 ff ff ff       	jmpq   80248b <vprintfmt+0x89>
  802579:	e9 0d ff ff ff       	jmpq   80248b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80257e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802582:	e9 04 ff ff ff       	jmpq   80248b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802587:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80258a:	83 f8 30             	cmp    $0x30,%eax
  80258d:	73 17                	jae    8025a6 <vprintfmt+0x1a4>
  80258f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802593:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802596:	89 c0                	mov    %eax,%eax
  802598:	48 01 d0             	add    %rdx,%rax
  80259b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80259e:	83 c2 08             	add    $0x8,%edx
  8025a1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025a4:	eb 0f                	jmp    8025b5 <vprintfmt+0x1b3>
  8025a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025aa:	48 89 d0             	mov    %rdx,%rax
  8025ad:	48 83 c2 08          	add    $0x8,%rdx
  8025b1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025b5:	8b 10                	mov    (%rax),%edx
  8025b7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025bf:	48 89 ce             	mov    %rcx,%rsi
  8025c2:	89 d7                	mov    %edx,%edi
  8025c4:	ff d0                	callq  *%rax
			break;
  8025c6:	e9 53 03 00 00       	jmpq   80291e <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025ce:	83 f8 30             	cmp    $0x30,%eax
  8025d1:	73 17                	jae    8025ea <vprintfmt+0x1e8>
  8025d3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025da:	89 c0                	mov    %eax,%eax
  8025dc:	48 01 d0             	add    %rdx,%rax
  8025df:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025e2:	83 c2 08             	add    $0x8,%edx
  8025e5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025e8:	eb 0f                	jmp    8025f9 <vprintfmt+0x1f7>
  8025ea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025ee:	48 89 d0             	mov    %rdx,%rax
  8025f1:	48 83 c2 08          	add    $0x8,%rdx
  8025f5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025f9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8025fb:	85 db                	test   %ebx,%ebx
  8025fd:	79 02                	jns    802601 <vprintfmt+0x1ff>
				err = -err;
  8025ff:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802601:	83 fb 15             	cmp    $0x15,%ebx
  802604:	7f 16                	jg     80261c <vprintfmt+0x21a>
  802606:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  80260d:	00 00 00 
  802610:	48 63 d3             	movslq %ebx,%rdx
  802613:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802617:	4d 85 e4             	test   %r12,%r12
  80261a:	75 2e                	jne    80264a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80261c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802620:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802624:	89 d9                	mov    %ebx,%ecx
  802626:	48 ba c1 39 80 00 00 	movabs $0x8039c1,%rdx
  80262d:	00 00 00 
  802630:	48 89 c7             	mov    %rax,%rdi
  802633:	b8 00 00 00 00       	mov    $0x0,%eax
  802638:	49 b8 2d 29 80 00 00 	movabs $0x80292d,%r8
  80263f:	00 00 00 
  802642:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802645:	e9 d4 02 00 00       	jmpq   80291e <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80264a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80264e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802652:	4c 89 e1             	mov    %r12,%rcx
  802655:	48 ba ca 39 80 00 00 	movabs $0x8039ca,%rdx
  80265c:	00 00 00 
  80265f:	48 89 c7             	mov    %rax,%rdi
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
  802667:	49 b8 2d 29 80 00 00 	movabs $0x80292d,%r8
  80266e:	00 00 00 
  802671:	41 ff d0             	callq  *%r8
			break;
  802674:	e9 a5 02 00 00       	jmpq   80291e <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802679:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80267c:	83 f8 30             	cmp    $0x30,%eax
  80267f:	73 17                	jae    802698 <vprintfmt+0x296>
  802681:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802685:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802688:	89 c0                	mov    %eax,%eax
  80268a:	48 01 d0             	add    %rdx,%rax
  80268d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802690:	83 c2 08             	add    $0x8,%edx
  802693:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802696:	eb 0f                	jmp    8026a7 <vprintfmt+0x2a5>
  802698:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80269c:	48 89 d0             	mov    %rdx,%rax
  80269f:	48 83 c2 08          	add    $0x8,%rdx
  8026a3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026a7:	4c 8b 20             	mov    (%rax),%r12
  8026aa:	4d 85 e4             	test   %r12,%r12
  8026ad:	75 0a                	jne    8026b9 <vprintfmt+0x2b7>
				p = "(null)";
  8026af:	49 bc cd 39 80 00 00 	movabs $0x8039cd,%r12
  8026b6:	00 00 00 
			if (width > 0 && padc != '-')
  8026b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026bd:	7e 3f                	jle    8026fe <vprintfmt+0x2fc>
  8026bf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026c3:	74 39                	je     8026fe <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026c5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026c8:	48 98                	cltq   
  8026ca:	48 89 c6             	mov    %rax,%rsi
  8026cd:	4c 89 e7             	mov    %r12,%rdi
  8026d0:	48 b8 d9 2b 80 00 00 	movabs $0x802bd9,%rax
  8026d7:	00 00 00 
  8026da:	ff d0                	callq  *%rax
  8026dc:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026df:	eb 17                	jmp    8026f8 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026e1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8026e5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8026e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026ed:	48 89 ce             	mov    %rcx,%rsi
  8026f0:	89 d7                	mov    %edx,%edi
  8026f2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8026f4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026fc:	7f e3                	jg     8026e1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026fe:	eb 37                	jmp    802737 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802700:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802704:	74 1e                	je     802724 <vprintfmt+0x322>
  802706:	83 fb 1f             	cmp    $0x1f,%ebx
  802709:	7e 05                	jle    802710 <vprintfmt+0x30e>
  80270b:	83 fb 7e             	cmp    $0x7e,%ebx
  80270e:	7e 14                	jle    802724 <vprintfmt+0x322>
					putch('?', putdat);
  802710:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802714:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802718:	48 89 d6             	mov    %rdx,%rsi
  80271b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802720:	ff d0                	callq  *%rax
  802722:	eb 0f                	jmp    802733 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802724:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802728:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80272c:	48 89 d6             	mov    %rdx,%rsi
  80272f:	89 df                	mov    %ebx,%edi
  802731:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802733:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802737:	4c 89 e0             	mov    %r12,%rax
  80273a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80273e:	0f b6 00             	movzbl (%rax),%eax
  802741:	0f be d8             	movsbl %al,%ebx
  802744:	85 db                	test   %ebx,%ebx
  802746:	74 10                	je     802758 <vprintfmt+0x356>
  802748:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80274c:	78 b2                	js     802700 <vprintfmt+0x2fe>
  80274e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802752:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802756:	79 a8                	jns    802700 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802758:	eb 16                	jmp    802770 <vprintfmt+0x36e>
				putch(' ', putdat);
  80275a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80275e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802762:	48 89 d6             	mov    %rdx,%rsi
  802765:	bf 20 00 00 00       	mov    $0x20,%edi
  80276a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80276c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802770:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802774:	7f e4                	jg     80275a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802776:	e9 a3 01 00 00       	jmpq   80291e <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80277b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80277f:	be 03 00 00 00       	mov    $0x3,%esi
  802784:	48 89 c7             	mov    %rax,%rdi
  802787:	48 b8 f2 22 80 00 00 	movabs $0x8022f2,%rax
  80278e:	00 00 00 
  802791:	ff d0                	callq  *%rax
  802793:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279b:	48 85 c0             	test   %rax,%rax
  80279e:	79 1d                	jns    8027bd <vprintfmt+0x3bb>
				putch('-', putdat);
  8027a0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027a8:	48 89 d6             	mov    %rdx,%rsi
  8027ab:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027b0:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b6:	48 f7 d8             	neg    %rax
  8027b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027bd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027c4:	e9 e8 00 00 00       	jmpq   8028b1 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027c9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027cd:	be 03 00 00 00       	mov    $0x3,%esi
  8027d2:	48 89 c7             	mov    %rax,%rdi
  8027d5:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax
  8027e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8027e5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027ec:	e9 c0 00 00 00       	jmpq   8028b1 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8027f1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027f9:	48 89 d6             	mov    %rdx,%rsi
  8027fc:	bf 58 00 00 00       	mov    $0x58,%edi
  802801:	ff d0                	callq  *%rax
			putch('X', putdat);
  802803:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802807:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80280b:	48 89 d6             	mov    %rdx,%rsi
  80280e:	bf 58 00 00 00       	mov    $0x58,%edi
  802813:	ff d0                	callq  *%rax
			putch('X', putdat);
  802815:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802819:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80281d:	48 89 d6             	mov    %rdx,%rsi
  802820:	bf 58 00 00 00       	mov    $0x58,%edi
  802825:	ff d0                	callq  *%rax
			break;
  802827:	e9 f2 00 00 00       	jmpq   80291e <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  80282c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802830:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802834:	48 89 d6             	mov    %rdx,%rsi
  802837:	bf 30 00 00 00       	mov    $0x30,%edi
  80283c:	ff d0                	callq  *%rax
			putch('x', putdat);
  80283e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802842:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802846:	48 89 d6             	mov    %rdx,%rsi
  802849:	bf 78 00 00 00       	mov    $0x78,%edi
  80284e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802850:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802853:	83 f8 30             	cmp    $0x30,%eax
  802856:	73 17                	jae    80286f <vprintfmt+0x46d>
  802858:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80285c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80285f:	89 c0                	mov    %eax,%eax
  802861:	48 01 d0             	add    %rdx,%rax
  802864:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802867:	83 c2 08             	add    $0x8,%edx
  80286a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80286d:	eb 0f                	jmp    80287e <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80286f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802873:	48 89 d0             	mov    %rdx,%rax
  802876:	48 83 c2 08          	add    $0x8,%rdx
  80287a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80287e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802881:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802885:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80288c:	eb 23                	jmp    8028b1 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80288e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802892:	be 03 00 00 00       	mov    $0x3,%esi
  802897:	48 89 c7             	mov    %rax,%rdi
  80289a:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  8028a1:	00 00 00 
  8028a4:	ff d0                	callq  *%rax
  8028a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028aa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028b1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028b6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028b9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028c0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028c8:	45 89 c1             	mov    %r8d,%r9d
  8028cb:	41 89 f8             	mov    %edi,%r8d
  8028ce:	48 89 c7             	mov    %rax,%rdi
  8028d1:	48 b8 27 21 80 00 00 	movabs $0x802127,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
			break;
  8028dd:	eb 3f                	jmp    80291e <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028df:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028e7:	48 89 d6             	mov    %rdx,%rsi
  8028ea:	89 df                	mov    %ebx,%edi
  8028ec:	ff d0                	callq  *%rax
			break;
  8028ee:	eb 2e                	jmp    80291e <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8028f0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028f8:	48 89 d6             	mov    %rdx,%rsi
  8028fb:	bf 25 00 00 00       	mov    $0x25,%edi
  802900:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802902:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802907:	eb 05                	jmp    80290e <vprintfmt+0x50c>
  802909:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80290e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802912:	48 83 e8 01          	sub    $0x1,%rax
  802916:	0f b6 00             	movzbl (%rax),%eax
  802919:	3c 25                	cmp    $0x25,%al
  80291b:	75 ec                	jne    802909 <vprintfmt+0x507>
				/* do nothing */;
			break;
  80291d:	90                   	nop
		}
	}
  80291e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80291f:	e9 30 fb ff ff       	jmpq   802454 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802924:	48 83 c4 60          	add    $0x60,%rsp
  802928:	5b                   	pop    %rbx
  802929:	41 5c                	pop    %r12
  80292b:	5d                   	pop    %rbp
  80292c:	c3                   	retq   

000000000080292d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80292d:	55                   	push   %rbp
  80292e:	48 89 e5             	mov    %rsp,%rbp
  802931:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802938:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80293f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802946:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80294d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802954:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80295b:	84 c0                	test   %al,%al
  80295d:	74 20                	je     80297f <printfmt+0x52>
  80295f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802963:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802967:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80296b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80296f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802973:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802977:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80297b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80297f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802986:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80298d:	00 00 00 
  802990:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802997:	00 00 00 
  80299a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80299e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029a5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029ac:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029b3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029ba:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029c1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029c8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029cf:	48 89 c7             	mov    %rax,%rdi
  8029d2:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029de:	c9                   	leaveq 
  8029df:	c3                   	retq   

00000000008029e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
  8029e4:	48 83 ec 10          	sub    $0x10,%rsp
  8029e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8029ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f3:	8b 40 10             	mov    0x10(%rax),%eax
  8029f6:	8d 50 01             	lea    0x1(%rax),%edx
  8029f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a04:	48 8b 10             	mov    (%rax),%rdx
  802a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0b:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a0f:	48 39 c2             	cmp    %rax,%rdx
  802a12:	73 17                	jae    802a2b <sprintputch+0x4b>
		*b->buf++ = ch;
  802a14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a18:	48 8b 00             	mov    (%rax),%rax
  802a1b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a23:	48 89 0a             	mov    %rcx,(%rdx)
  802a26:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a29:	88 10                	mov    %dl,(%rax)
}
  802a2b:	c9                   	leaveq 
  802a2c:	c3                   	retq   

0000000000802a2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a2d:	55                   	push   %rbp
  802a2e:	48 89 e5             	mov    %rsp,%rbp
  802a31:	48 83 ec 50          	sub    $0x50,%rsp
  802a35:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a39:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a3c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a40:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a44:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a48:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a4c:	48 8b 0a             	mov    (%rdx),%rcx
  802a4f:	48 89 08             	mov    %rcx,(%rax)
  802a52:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a56:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a5a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a5e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a66:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a6a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a6d:	48 98                	cltq   
  802a6f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a73:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a77:	48 01 d0             	add    %rdx,%rax
  802a7a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a85:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a8a:	74 06                	je     802a92 <vsnprintf+0x65>
  802a8c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802a90:	7f 07                	jg     802a99 <vsnprintf+0x6c>
		return -E_INVAL;
  802a92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a97:	eb 2f                	jmp    802ac8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802a99:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802a9d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802aa1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802aa5:	48 89 c6             	mov    %rax,%rsi
  802aa8:	48 bf e0 29 80 00 00 	movabs $0x8029e0,%rdi
  802aaf:	00 00 00 
  802ab2:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802abe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ac2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802ac5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802ac8:	c9                   	leaveq 
  802ac9:	c3                   	retq   

0000000000802aca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802aca:	55                   	push   %rbp
  802acb:	48 89 e5             	mov    %rsp,%rbp
  802ace:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802ad5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802adc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802ae2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ae9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802af0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802af7:	84 c0                	test   %al,%al
  802af9:	74 20                	je     802b1b <snprintf+0x51>
  802afb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802aff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b03:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b07:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b0b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b0f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b13:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b17:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b1b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b22:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b29:	00 00 00 
  802b2c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b33:	00 00 00 
  802b36:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b3a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b41:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b48:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b4f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b56:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b5d:	48 8b 0a             	mov    (%rdx),%rcx
  802b60:	48 89 08             	mov    %rcx,(%rax)
  802b63:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b67:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b6b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b6f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b73:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b7a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b81:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b87:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b8e:	48 89 c7             	mov    %rax,%rdi
  802b91:	48 b8 2d 2a 80 00 00 	movabs $0x802a2d,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
  802b9d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802ba3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ba9:	c9                   	leaveq 
  802baa:	c3                   	retq   

0000000000802bab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802bab:	55                   	push   %rbp
  802bac:	48 89 e5             	mov    %rsp,%rbp
  802baf:	48 83 ec 18          	sub    $0x18,%rsp
  802bb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bbe:	eb 09                	jmp    802bc9 <strlen+0x1e>
		n++;
  802bc0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bc4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcd:	0f b6 00             	movzbl (%rax),%eax
  802bd0:	84 c0                	test   %al,%al
  802bd2:	75 ec                	jne    802bc0 <strlen+0x15>
		n++;
	return n;
  802bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd7:	c9                   	leaveq 
  802bd8:	c3                   	retq   

0000000000802bd9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802bd9:	55                   	push   %rbp
  802bda:	48 89 e5             	mov    %rsp,%rbp
  802bdd:	48 83 ec 20          	sub    $0x20,%rsp
  802be1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802be9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bf0:	eb 0e                	jmp    802c00 <strnlen+0x27>
		n++;
  802bf2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bf6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bfb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c00:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c05:	74 0b                	je     802c12 <strnlen+0x39>
  802c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0b:	0f b6 00             	movzbl (%rax),%eax
  802c0e:	84 c0                	test   %al,%al
  802c10:	75 e0                	jne    802bf2 <strnlen+0x19>
		n++;
	return n;
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c15:	c9                   	leaveq 
  802c16:	c3                   	retq   

0000000000802c17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c17:	55                   	push   %rbp
  802c18:	48 89 e5             	mov    %rsp,%rbp
  802c1b:	48 83 ec 20          	sub    $0x20,%rsp
  802c1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c2f:	90                   	nop
  802c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c34:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c38:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c3c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c40:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c44:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c48:	0f b6 12             	movzbl (%rdx),%edx
  802c4b:	88 10                	mov    %dl,(%rax)
  802c4d:	0f b6 00             	movzbl (%rax),%eax
  802c50:	84 c0                	test   %al,%al
  802c52:	75 dc                	jne    802c30 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c58:	c9                   	leaveq 
  802c59:	c3                   	retq   

0000000000802c5a <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c5a:	55                   	push   %rbp
  802c5b:	48 89 e5             	mov    %rsp,%rbp
  802c5e:	48 83 ec 20          	sub    $0x20,%rsp
  802c62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6e:	48 89 c7             	mov    %rax,%rdi
  802c71:	48 b8 ab 2b 80 00 00 	movabs $0x802bab,%rax
  802c78:	00 00 00 
  802c7b:	ff d0                	callq  *%rax
  802c7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c83:	48 63 d0             	movslq %eax,%rdx
  802c86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8a:	48 01 c2             	add    %rax,%rdx
  802c8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c91:	48 89 c6             	mov    %rax,%rsi
  802c94:	48 89 d7             	mov    %rdx,%rdi
  802c97:	48 b8 17 2c 80 00 00 	movabs $0x802c17,%rax
  802c9e:	00 00 00 
  802ca1:	ff d0                	callq  *%rax
	return dst;
  802ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802ca7:	c9                   	leaveq 
  802ca8:	c3                   	retq   

0000000000802ca9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802ca9:	55                   	push   %rbp
  802caa:	48 89 e5             	mov    %rsp,%rbp
  802cad:	48 83 ec 28          	sub    $0x28,%rsp
  802cb1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cb9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802cc5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ccc:	00 
  802ccd:	eb 2a                	jmp    802cf9 <strncpy+0x50>
		*dst++ = *src;
  802ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cdb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cdf:	0f b6 12             	movzbl (%rdx),%edx
  802ce2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802ce4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce8:	0f b6 00             	movzbl (%rax),%eax
  802ceb:	84 c0                	test   %al,%al
  802ced:	74 05                	je     802cf4 <strncpy+0x4b>
			src++;
  802cef:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802cf4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cfd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d01:	72 cc                	jb     802ccf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d07:	c9                   	leaveq 
  802d08:	c3                   	retq   

0000000000802d09 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d09:	55                   	push   %rbp
  802d0a:	48 89 e5             	mov    %rsp,%rbp
  802d0d:	48 83 ec 28          	sub    $0x28,%rsp
  802d11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d19:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d25:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d2a:	74 3d                	je     802d69 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d2c:	eb 1d                	jmp    802d4b <strlcpy+0x42>
			*dst++ = *src++;
  802d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d32:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d36:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d3a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d3e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d42:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d46:	0f b6 12             	movzbl (%rdx),%edx
  802d49:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d4b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d50:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d55:	74 0b                	je     802d62 <strlcpy+0x59>
  802d57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d5b:	0f b6 00             	movzbl (%rax),%eax
  802d5e:	84 c0                	test   %al,%al
  802d60:	75 cc                	jne    802d2e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d66:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d71:	48 29 c2             	sub    %rax,%rdx
  802d74:	48 89 d0             	mov    %rdx,%rax
}
  802d77:	c9                   	leaveq 
  802d78:	c3                   	retq   

0000000000802d79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d79:	55                   	push   %rbp
  802d7a:	48 89 e5             	mov    %rsp,%rbp
  802d7d:	48 83 ec 10          	sub    $0x10,%rsp
  802d81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d89:	eb 0a                	jmp    802d95 <strcmp+0x1c>
		p++, q++;
  802d8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d90:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d99:	0f b6 00             	movzbl (%rax),%eax
  802d9c:	84 c0                	test   %al,%al
  802d9e:	74 12                	je     802db2 <strcmp+0x39>
  802da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da4:	0f b6 10             	movzbl (%rax),%edx
  802da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dab:	0f b6 00             	movzbl (%rax),%eax
  802dae:	38 c2                	cmp    %al,%dl
  802db0:	74 d9                	je     802d8b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db6:	0f b6 00             	movzbl (%rax),%eax
  802db9:	0f b6 d0             	movzbl %al,%edx
  802dbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc0:	0f b6 00             	movzbl (%rax),%eax
  802dc3:	0f b6 c0             	movzbl %al,%eax
  802dc6:	29 c2                	sub    %eax,%edx
  802dc8:	89 d0                	mov    %edx,%eax
}
  802dca:	c9                   	leaveq 
  802dcb:	c3                   	retq   

0000000000802dcc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802dcc:	55                   	push   %rbp
  802dcd:	48 89 e5             	mov    %rsp,%rbp
  802dd0:	48 83 ec 18          	sub    $0x18,%rsp
  802dd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ddc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802de0:	eb 0f                	jmp    802df1 <strncmp+0x25>
		n--, p++, q++;
  802de2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802de7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802df1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802df6:	74 1d                	je     802e15 <strncmp+0x49>
  802df8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dfc:	0f b6 00             	movzbl (%rax),%eax
  802dff:	84 c0                	test   %al,%al
  802e01:	74 12                	je     802e15 <strncmp+0x49>
  802e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e07:	0f b6 10             	movzbl (%rax),%edx
  802e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0e:	0f b6 00             	movzbl (%rax),%eax
  802e11:	38 c2                	cmp    %al,%dl
  802e13:	74 cd                	je     802de2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e15:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e1a:	75 07                	jne    802e23 <strncmp+0x57>
		return 0;
  802e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e21:	eb 18                	jmp    802e3b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e27:	0f b6 00             	movzbl (%rax),%eax
  802e2a:	0f b6 d0             	movzbl %al,%edx
  802e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e31:	0f b6 00             	movzbl (%rax),%eax
  802e34:	0f b6 c0             	movzbl %al,%eax
  802e37:	29 c2                	sub    %eax,%edx
  802e39:	89 d0                	mov    %edx,%eax
}
  802e3b:	c9                   	leaveq 
  802e3c:	c3                   	retq   

0000000000802e3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e3d:	55                   	push   %rbp
  802e3e:	48 89 e5             	mov    %rsp,%rbp
  802e41:	48 83 ec 0c          	sub    $0xc,%rsp
  802e45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e49:	89 f0                	mov    %esi,%eax
  802e4b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e4e:	eb 17                	jmp    802e67 <strchr+0x2a>
		if (*s == c)
  802e50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e54:	0f b6 00             	movzbl (%rax),%eax
  802e57:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e5a:	75 06                	jne    802e62 <strchr+0x25>
			return (char *) s;
  802e5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e60:	eb 15                	jmp    802e77 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e62:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6b:	0f b6 00             	movzbl (%rax),%eax
  802e6e:	84 c0                	test   %al,%al
  802e70:	75 de                	jne    802e50 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e77:	c9                   	leaveq 
  802e78:	c3                   	retq   

0000000000802e79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e79:	55                   	push   %rbp
  802e7a:	48 89 e5             	mov    %rsp,%rbp
  802e7d:	48 83 ec 0c          	sub    $0xc,%rsp
  802e81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e85:	89 f0                	mov    %esi,%eax
  802e87:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e8a:	eb 13                	jmp    802e9f <strfind+0x26>
		if (*s == c)
  802e8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e90:	0f b6 00             	movzbl (%rax),%eax
  802e93:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e96:	75 02                	jne    802e9a <strfind+0x21>
			break;
  802e98:	eb 10                	jmp    802eaa <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802e9a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea3:	0f b6 00             	movzbl (%rax),%eax
  802ea6:	84 c0                	test   %al,%al
  802ea8:	75 e2                	jne    802e8c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802eae:	c9                   	leaveq 
  802eaf:	c3                   	retq   

0000000000802eb0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802eb0:	55                   	push   %rbp
  802eb1:	48 89 e5             	mov    %rsp,%rbp
  802eb4:	48 83 ec 18          	sub    $0x18,%rsp
  802eb8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ebc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ebf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ec3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ec8:	75 06                	jne    802ed0 <memset+0x20>
		return v;
  802eca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ece:	eb 69                	jmp    802f39 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802ed0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed4:	83 e0 03             	and    $0x3,%eax
  802ed7:	48 85 c0             	test   %rax,%rax
  802eda:	75 48                	jne    802f24 <memset+0x74>
  802edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee0:	83 e0 03             	and    $0x3,%eax
  802ee3:	48 85 c0             	test   %rax,%rax
  802ee6:	75 3c                	jne    802f24 <memset+0x74>
		c &= 0xFF;
  802ee8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802eef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ef2:	c1 e0 18             	shl    $0x18,%eax
  802ef5:	89 c2                	mov    %eax,%edx
  802ef7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802efa:	c1 e0 10             	shl    $0x10,%eax
  802efd:	09 c2                	or     %eax,%edx
  802eff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f02:	c1 e0 08             	shl    $0x8,%eax
  802f05:	09 d0                	or     %edx,%eax
  802f07:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0e:	48 c1 e8 02          	shr    $0x2,%rax
  802f12:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f15:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f19:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f1c:	48 89 d7             	mov    %rdx,%rdi
  802f1f:	fc                   	cld    
  802f20:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f22:	eb 11                	jmp    802f35 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f2b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f2f:	48 89 d7             	mov    %rdx,%rdi
  802f32:	fc                   	cld    
  802f33:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f39:	c9                   	leaveq 
  802f3a:	c3                   	retq   

0000000000802f3b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f3b:	55                   	push   %rbp
  802f3c:	48 89 e5             	mov    %rsp,%rbp
  802f3f:	48 83 ec 28          	sub    $0x28,%rsp
  802f43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f63:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f67:	0f 83 88 00 00 00    	jae    802ff5 <memmove+0xba>
  802f6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f71:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f75:	48 01 d0             	add    %rdx,%rax
  802f78:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f7c:	76 77                	jbe    802ff5 <memmove+0xba>
		s += n;
  802f7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f82:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f92:	83 e0 03             	and    $0x3,%eax
  802f95:	48 85 c0             	test   %rax,%rax
  802f98:	75 3b                	jne    802fd5 <memmove+0x9a>
  802f9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9e:	83 e0 03             	and    $0x3,%eax
  802fa1:	48 85 c0             	test   %rax,%rax
  802fa4:	75 2f                	jne    802fd5 <memmove+0x9a>
  802fa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802faa:	83 e0 03             	and    $0x3,%eax
  802fad:	48 85 c0             	test   %rax,%rax
  802fb0:	75 23                	jne    802fd5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb6:	48 83 e8 04          	sub    $0x4,%rax
  802fba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fbe:	48 83 ea 04          	sub    $0x4,%rdx
  802fc2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fc6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fca:	48 89 c7             	mov    %rax,%rdi
  802fcd:	48 89 d6             	mov    %rdx,%rsi
  802fd0:	fd                   	std    
  802fd1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fd3:	eb 1d                	jmp    802ff2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802fe5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe9:	48 89 d7             	mov    %rdx,%rdi
  802fec:	48 89 c1             	mov    %rax,%rcx
  802fef:	fd                   	std    
  802ff0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802ff2:	fc                   	cld    
  802ff3:	eb 57                	jmp    80304c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff9:	83 e0 03             	and    $0x3,%eax
  802ffc:	48 85 c0             	test   %rax,%rax
  802fff:	75 36                	jne    803037 <memmove+0xfc>
  803001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803005:	83 e0 03             	and    $0x3,%eax
  803008:	48 85 c0             	test   %rax,%rax
  80300b:	75 2a                	jne    803037 <memmove+0xfc>
  80300d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803011:	83 e0 03             	and    $0x3,%eax
  803014:	48 85 c0             	test   %rax,%rax
  803017:	75 1e                	jne    803037 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803019:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80301d:	48 c1 e8 02          	shr    $0x2,%rax
  803021:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803028:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80302c:	48 89 c7             	mov    %rax,%rdi
  80302f:	48 89 d6             	mov    %rdx,%rsi
  803032:	fc                   	cld    
  803033:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803035:	eb 15                	jmp    80304c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80303f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803043:	48 89 c7             	mov    %rax,%rdi
  803046:	48 89 d6             	mov    %rdx,%rsi
  803049:	fc                   	cld    
  80304a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80304c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803050:	c9                   	leaveq 
  803051:	c3                   	retq   

0000000000803052 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803052:	55                   	push   %rbp
  803053:	48 89 e5             	mov    %rsp,%rbp
  803056:	48 83 ec 18          	sub    $0x18,%rsp
  80305a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80305e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803062:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803066:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80306a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80306e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803072:	48 89 ce             	mov    %rcx,%rsi
  803075:	48 89 c7             	mov    %rax,%rdi
  803078:	48 b8 3b 2f 80 00 00 	movabs $0x802f3b,%rax
  80307f:	00 00 00 
  803082:	ff d0                	callq  *%rax
}
  803084:	c9                   	leaveq 
  803085:	c3                   	retq   

0000000000803086 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803086:	55                   	push   %rbp
  803087:	48 89 e5             	mov    %rsp,%rbp
  80308a:	48 83 ec 28          	sub    $0x28,%rsp
  80308e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803092:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803096:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80309a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030aa:	eb 36                	jmp    8030e2 <memcmp+0x5c>
		if (*s1 != *s2)
  8030ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b0:	0f b6 10             	movzbl (%rax),%edx
  8030b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b7:	0f b6 00             	movzbl (%rax),%eax
  8030ba:	38 c2                	cmp    %al,%dl
  8030bc:	74 1a                	je     8030d8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c2:	0f b6 00             	movzbl (%rax),%eax
  8030c5:	0f b6 d0             	movzbl %al,%edx
  8030c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cc:	0f b6 00             	movzbl (%rax),%eax
  8030cf:	0f b6 c0             	movzbl %al,%eax
  8030d2:	29 c2                	sub    %eax,%edx
  8030d4:	89 d0                	mov    %edx,%eax
  8030d6:	eb 20                	jmp    8030f8 <memcmp+0x72>
		s1++, s2++;
  8030d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030dd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8030ee:	48 85 c0             	test   %rax,%rax
  8030f1:	75 b9                	jne    8030ac <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8030f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f8:	c9                   	leaveq 
  8030f9:	c3                   	retq   

00000000008030fa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8030fa:	55                   	push   %rbp
  8030fb:	48 89 e5             	mov    %rsp,%rbp
  8030fe:	48 83 ec 28          	sub    $0x28,%rsp
  803102:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803106:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803109:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80310d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803111:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803115:	48 01 d0             	add    %rdx,%rax
  803118:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80311c:	eb 15                	jmp    803133 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80311e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803122:	0f b6 10             	movzbl (%rax),%edx
  803125:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803128:	38 c2                	cmp    %al,%dl
  80312a:	75 02                	jne    80312e <memfind+0x34>
			break;
  80312c:	eb 0f                	jmp    80313d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80312e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803137:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80313b:	72 e1                	jb     80311e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80313d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803141:	c9                   	leaveq 
  803142:	c3                   	retq   

0000000000803143 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803143:	55                   	push   %rbp
  803144:	48 89 e5             	mov    %rsp,%rbp
  803147:	48 83 ec 34          	sub    $0x34,%rsp
  80314b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80314f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803153:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80315d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803164:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803165:	eb 05                	jmp    80316c <strtol+0x29>
		s++;
  803167:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80316c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803170:	0f b6 00             	movzbl (%rax),%eax
  803173:	3c 20                	cmp    $0x20,%al
  803175:	74 f0                	je     803167 <strtol+0x24>
  803177:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317b:	0f b6 00             	movzbl (%rax),%eax
  80317e:	3c 09                	cmp    $0x9,%al
  803180:	74 e5                	je     803167 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803186:	0f b6 00             	movzbl (%rax),%eax
  803189:	3c 2b                	cmp    $0x2b,%al
  80318b:	75 07                	jne    803194 <strtol+0x51>
		s++;
  80318d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803192:	eb 17                	jmp    8031ab <strtol+0x68>
	else if (*s == '-')
  803194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803198:	0f b6 00             	movzbl (%rax),%eax
  80319b:	3c 2d                	cmp    $0x2d,%al
  80319d:	75 0c                	jne    8031ab <strtol+0x68>
		s++, neg = 1;
  80319f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031af:	74 06                	je     8031b7 <strtol+0x74>
  8031b1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031b5:	75 28                	jne    8031df <strtol+0x9c>
  8031b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031bb:	0f b6 00             	movzbl (%rax),%eax
  8031be:	3c 30                	cmp    $0x30,%al
  8031c0:	75 1d                	jne    8031df <strtol+0x9c>
  8031c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c6:	48 83 c0 01          	add    $0x1,%rax
  8031ca:	0f b6 00             	movzbl (%rax),%eax
  8031cd:	3c 78                	cmp    $0x78,%al
  8031cf:	75 0e                	jne    8031df <strtol+0x9c>
		s += 2, base = 16;
  8031d1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031d6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031dd:	eb 2c                	jmp    80320b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031e3:	75 19                	jne    8031fe <strtol+0xbb>
  8031e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e9:	0f b6 00             	movzbl (%rax),%eax
  8031ec:	3c 30                	cmp    $0x30,%al
  8031ee:	75 0e                	jne    8031fe <strtol+0xbb>
		s++, base = 8;
  8031f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031f5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8031fc:	eb 0d                	jmp    80320b <strtol+0xc8>
	else if (base == 0)
  8031fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803202:	75 07                	jne    80320b <strtol+0xc8>
		base = 10;
  803204:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80320b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320f:	0f b6 00             	movzbl (%rax),%eax
  803212:	3c 2f                	cmp    $0x2f,%al
  803214:	7e 1d                	jle    803233 <strtol+0xf0>
  803216:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321a:	0f b6 00             	movzbl (%rax),%eax
  80321d:	3c 39                	cmp    $0x39,%al
  80321f:	7f 12                	jg     803233 <strtol+0xf0>
			dig = *s - '0';
  803221:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803225:	0f b6 00             	movzbl (%rax),%eax
  803228:	0f be c0             	movsbl %al,%eax
  80322b:	83 e8 30             	sub    $0x30,%eax
  80322e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803231:	eb 4e                	jmp    803281 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803237:	0f b6 00             	movzbl (%rax),%eax
  80323a:	3c 60                	cmp    $0x60,%al
  80323c:	7e 1d                	jle    80325b <strtol+0x118>
  80323e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803242:	0f b6 00             	movzbl (%rax),%eax
  803245:	3c 7a                	cmp    $0x7a,%al
  803247:	7f 12                	jg     80325b <strtol+0x118>
			dig = *s - 'a' + 10;
  803249:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324d:	0f b6 00             	movzbl (%rax),%eax
  803250:	0f be c0             	movsbl %al,%eax
  803253:	83 e8 57             	sub    $0x57,%eax
  803256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803259:	eb 26                	jmp    803281 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80325b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325f:	0f b6 00             	movzbl (%rax),%eax
  803262:	3c 40                	cmp    $0x40,%al
  803264:	7e 48                	jle    8032ae <strtol+0x16b>
  803266:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326a:	0f b6 00             	movzbl (%rax),%eax
  80326d:	3c 5a                	cmp    $0x5a,%al
  80326f:	7f 3d                	jg     8032ae <strtol+0x16b>
			dig = *s - 'A' + 10;
  803271:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803275:	0f b6 00             	movzbl (%rax),%eax
  803278:	0f be c0             	movsbl %al,%eax
  80327b:	83 e8 37             	sub    $0x37,%eax
  80327e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803281:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803284:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803287:	7c 02                	jl     80328b <strtol+0x148>
			break;
  803289:	eb 23                	jmp    8032ae <strtol+0x16b>
		s++, val = (val * base) + dig;
  80328b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803290:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803293:	48 98                	cltq   
  803295:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80329a:	48 89 c2             	mov    %rax,%rdx
  80329d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a0:	48 98                	cltq   
  8032a2:	48 01 d0             	add    %rdx,%rax
  8032a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032a9:	e9 5d ff ff ff       	jmpq   80320b <strtol+0xc8>

	if (endptr)
  8032ae:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032b3:	74 0b                	je     8032c0 <strtol+0x17d>
		*endptr = (char *) s;
  8032b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032bd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c4:	74 09                	je     8032cf <strtol+0x18c>
  8032c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ca:	48 f7 d8             	neg    %rax
  8032cd:	eb 04                	jmp    8032d3 <strtol+0x190>
  8032cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032d3:	c9                   	leaveq 
  8032d4:	c3                   	retq   

00000000008032d5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8032d5:	55                   	push   %rbp
  8032d6:	48 89 e5             	mov    %rsp,%rbp
  8032d9:	48 83 ec 30          	sub    $0x30,%rsp
  8032dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8032e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032ed:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8032f1:	0f b6 00             	movzbl (%rax),%eax
  8032f4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8032f7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8032fb:	75 06                	jne    803303 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8032fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803301:	eb 6b                	jmp    80336e <strstr+0x99>

	len = strlen(str);
  803303:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803307:	48 89 c7             	mov    %rax,%rdi
  80330a:	48 b8 ab 2b 80 00 00 	movabs $0x802bab,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
  803316:	48 98                	cltq   
  803318:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80331c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803320:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803324:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803328:	0f b6 00             	movzbl (%rax),%eax
  80332b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80332e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803332:	75 07                	jne    80333b <strstr+0x66>
				return (char *) 0;
  803334:	b8 00 00 00 00       	mov    $0x0,%eax
  803339:	eb 33                	jmp    80336e <strstr+0x99>
		} while (sc != c);
  80333b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80333f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803342:	75 d8                	jne    80331c <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803344:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803348:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80334c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803350:	48 89 ce             	mov    %rcx,%rsi
  803353:	48 89 c7             	mov    %rax,%rdi
  803356:	48 b8 cc 2d 80 00 00 	movabs $0x802dcc,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
  803362:	85 c0                	test   %eax,%eax
  803364:	75 b6                	jne    80331c <strstr+0x47>

	return (char *) (in - 1);
  803366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336a:	48 83 e8 01          	sub    $0x1,%rax
}
  80336e:	c9                   	leaveq 
  80336f:	c3                   	retq   

0000000000803370 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803370:	55                   	push   %rbp
  803371:	48 89 e5             	mov    %rsp,%rbp
  803374:	48 83 ec 30          	sub    $0x30,%rsp
  803378:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80337c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803380:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803384:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803389:	75 0e                	jne    803399 <ipc_recv+0x29>
        pg = (void *)UTOP;
  80338b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803392:	00 00 00 
  803395:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803399:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339d:	48 89 c7             	mov    %rax,%rdi
  8033a0:	48 b8 0d 05 80 00 00 	movabs $0x80050d,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
  8033ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b3:	79 27                	jns    8033dc <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ba:	74 0a                	je     8033c6 <ipc_recv+0x56>
            *from_env_store = 0;
  8033bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033cb:	74 0a                	je     8033d7 <ipc_recv+0x67>
            *perm_store = 0;
  8033cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033da:	eb 53                	jmp    80342f <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033dc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033e1:	74 19                	je     8033fc <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033e3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033ea:	00 00 00 
  8033ed:	48 8b 00             	mov    (%rax),%rax
  8033f0:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8033f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fa:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8033fc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803401:	74 19                	je     80341c <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803403:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80340a:	00 00 00 
  80340d:	48 8b 00             	mov    (%rax),%rax
  803410:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341a:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80341c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803423:	00 00 00 
  803426:	48 8b 00             	mov    (%rax),%rax
  803429:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80342f:	c9                   	leaveq 
  803430:	c3                   	retq   

0000000000803431 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803431:	55                   	push   %rbp
  803432:	48 89 e5             	mov    %rsp,%rbp
  803435:	48 83 ec 30          	sub    $0x30,%rsp
  803439:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80343c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80343f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803443:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803446:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80344b:	75 0e                	jne    80345b <ipc_send+0x2a>
        pg = (void *)UTOP;
  80344d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803454:	00 00 00 
  803457:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  80345b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80345e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803461:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803465:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803468:	89 c7                	mov    %eax,%edi
  80346a:	48 b8 b8 04 80 00 00 	movabs $0x8004b8,%rax
  803471:	00 00 00 
  803474:	ff d0                	callq  *%rax
  803476:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803479:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347d:	79 36                	jns    8034b5 <ipc_send+0x84>
  80347f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803483:	74 30                	je     8034b5 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803488:	89 c1                	mov    %eax,%ecx
  80348a:	48 ba 88 3c 80 00 00 	movabs $0x803c88,%rdx
  803491:	00 00 00 
  803494:	be 49 00 00 00       	mov    $0x49,%esi
  803499:	48 bf 95 3c 80 00 00 	movabs $0x803c95,%rdi
  8034a0:	00 00 00 
  8034a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a8:	49 b8 16 1e 80 00 00 	movabs $0x801e16,%r8
  8034af:	00 00 00 
  8034b2:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034b5:	48 b8 a6 02 80 00 00 	movabs $0x8002a6,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
    } while(r != 0);
  8034c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c5:	75 94                	jne    80345b <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034c7:	c9                   	leaveq 
  8034c8:	c3                   	retq   

00000000008034c9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034c9:	55                   	push   %rbp
  8034ca:	48 89 e5             	mov    %rsp,%rbp
  8034cd:	48 83 ec 14          	sub    $0x14,%rsp
  8034d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034db:	eb 5e                	jmp    80353b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034dd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034e4:	00 00 00 
  8034e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ea:	48 63 d0             	movslq %eax,%rdx
  8034ed:	48 89 d0             	mov    %rdx,%rax
  8034f0:	48 c1 e0 03          	shl    $0x3,%rax
  8034f4:	48 01 d0             	add    %rdx,%rax
  8034f7:	48 c1 e0 05          	shl    $0x5,%rax
  8034fb:	48 01 c8             	add    %rcx,%rax
  8034fe:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803504:	8b 00                	mov    (%rax),%eax
  803506:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803509:	75 2c                	jne    803537 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80350b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803512:	00 00 00 
  803515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803518:	48 63 d0             	movslq %eax,%rdx
  80351b:	48 89 d0             	mov    %rdx,%rax
  80351e:	48 c1 e0 03          	shl    $0x3,%rax
  803522:	48 01 d0             	add    %rdx,%rax
  803525:	48 c1 e0 05          	shl    $0x5,%rax
  803529:	48 01 c8             	add    %rcx,%rax
  80352c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803532:	8b 40 08             	mov    0x8(%rax),%eax
  803535:	eb 12                	jmp    803549 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803537:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80353b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803542:	7e 99                	jle    8034dd <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803549:	c9                   	leaveq 
  80354a:	c3                   	retq   

000000000080354b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80354b:	55                   	push   %rbp
  80354c:	48 89 e5             	mov    %rsp,%rbp
  80354f:	48 83 ec 18          	sub    $0x18,%rsp
  803553:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355b:	48 c1 e8 15          	shr    $0x15,%rax
  80355f:	48 89 c2             	mov    %rax,%rdx
  803562:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803569:	01 00 00 
  80356c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803570:	83 e0 01             	and    $0x1,%eax
  803573:	48 85 c0             	test   %rax,%rax
  803576:	75 07                	jne    80357f <pageref+0x34>
		return 0;
  803578:	b8 00 00 00 00       	mov    $0x0,%eax
  80357d:	eb 53                	jmp    8035d2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80357f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803583:	48 c1 e8 0c          	shr    $0xc,%rax
  803587:	48 89 c2             	mov    %rax,%rdx
  80358a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803591:	01 00 00 
  803594:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803598:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80359c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a0:	83 e0 01             	and    $0x1,%eax
  8035a3:	48 85 c0             	test   %rax,%rax
  8035a6:	75 07                	jne    8035af <pageref+0x64>
		return 0;
  8035a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ad:	eb 23                	jmp    8035d2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8035b7:	48 89 c2             	mov    %rax,%rdx
  8035ba:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035c1:	00 00 00 
  8035c4:	48 c1 e2 04          	shl    $0x4,%rdx
  8035c8:	48 01 d0             	add    %rdx,%rax
  8035cb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035cf:	0f b7 c0             	movzwl %ax,%eax
}
  8035d2:	c9                   	leaveq 
  8035d3:	c3                   	retq   
