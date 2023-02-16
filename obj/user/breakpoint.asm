
obj/user/breakpoint:     file format elf64-x86-64


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
  80003c:	e8 14 00 00 00       	callq  800055 <libmain>
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
	asm volatile("int $3");
  800052:	cc                   	int3   
}
  800053:	c9                   	leaveq 
  800054:	c3                   	retq   

0000000000800055 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800055:	55                   	push   %rbp
  800056:	48 89 e5             	mov    %rsp,%rbp
  800059:	48 83 ec 20          	sub    $0x20,%rsp
  80005d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800060:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800064:	48 b8 63 02 80 00 00 	movabs $0x800263,%rax
  80006b:	00 00 00 
  80006e:	ff d0                	callq  *%rax
  800070:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800076:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007b:	48 63 d0             	movslq %eax,%rdx
  80007e:	48 89 d0             	mov    %rdx,%rax
  800081:	48 c1 e0 03          	shl    $0x3,%rax
  800085:	48 01 d0             	add    %rdx,%rax
  800088:	48 c1 e0 05          	shl    $0x5,%rax
  80008c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800093:	00 00 00 
  800096:	48 01 c2             	add    %rax,%rdx
  800099:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000a0:	00 00 00 
  8000a3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000aa:	7e 14                	jle    8000c0 <libmain+0x6b>
		binaryname = argv[0];
  8000ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000b0:	48 8b 10             	mov    (%rax),%rdx
  8000b3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000ba:	00 00 00 
  8000bd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000c0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000c7:	48 89 d6             	mov    %rdx,%rsi
  8000ca:	89 c7                	mov    %eax,%edi
  8000cc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000d8:	48 b8 e6 00 80 00 00 	movabs $0x8000e6,%rax
  8000df:	00 00 00 
  8000e2:	ff d0                	callq  *%rax
}
  8000e4:	c9                   	leaveq 
  8000e5:	c3                   	retq   

00000000008000e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e6:	55                   	push   %rbp
  8000e7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000ea:	48 b8 8d 08 80 00 00 	movabs $0x80088d,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8000f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000fb:	48 b8 1f 02 80 00 00 	movabs $0x80021f,%rax
  800102:	00 00 00 
  800105:	ff d0                	callq  *%rax
}
  800107:	5d                   	pop    %rbp
  800108:	c3                   	retq   

0000000000800109 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800109:	55                   	push   %rbp
  80010a:	48 89 e5             	mov    %rsp,%rbp
  80010d:	53                   	push   %rbx
  80010e:	48 83 ec 48          	sub    $0x48,%rsp
  800112:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800115:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800118:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80011c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800120:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800124:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800128:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80012b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80012f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800133:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800137:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80013b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80013f:	4c 89 c3             	mov    %r8,%rbx
  800142:	cd 30                	int    $0x30
  800144:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800148:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80014c:	74 3e                	je     80018c <syscall+0x83>
  80014e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800153:	7e 37                	jle    80018c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800155:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800159:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80015c:	49 89 d0             	mov    %rdx,%r8
  80015f:	89 c1                	mov    %eax,%ecx
  800161:	48 ba ea 35 80 00 00 	movabs $0x8035ea,%rdx
  800168:	00 00 00 
  80016b:	be 23 00 00 00       	mov    $0x23,%esi
  800170:	48 bf 07 36 80 00 00 	movabs $0x803607,%rdi
  800177:	00 00 00 
  80017a:	b8 00 00 00 00       	mov    $0x0,%eax
  80017f:	49 b9 11 1e 80 00 00 	movabs $0x801e11,%r9
  800186:	00 00 00 
  800189:	41 ff d1             	callq  *%r9

	return ret;
  80018c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800190:	48 83 c4 48          	add    $0x48,%rsp
  800194:	5b                   	pop    %rbx
  800195:	5d                   	pop    %rbp
  800196:	c3                   	retq   

0000000000800197 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800197:	55                   	push   %rbp
  800198:	48 89 e5             	mov    %rsp,%rbp
  80019b:	48 83 ec 20          	sub    $0x20,%rsp
  80019f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001af:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b6:	00 
  8001b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c3:	48 89 d1             	mov    %rdx,%rcx
  8001c6:	48 89 c2             	mov    %rax,%rdx
  8001c9:	be 00 00 00 00       	mov    $0x0,%esi
  8001ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d3:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8001da:	00 00 00 
  8001dd:	ff d0                	callq  *%rax
}
  8001df:	c9                   	leaveq 
  8001e0:	c3                   	retq   

00000000008001e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e1:	55                   	push   %rbp
  8001e2:	48 89 e5             	mov    %rsp,%rbp
  8001e5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f0:	00 
  8001f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800202:	ba 00 00 00 00       	mov    $0x0,%edx
  800207:	be 00 00 00 00       	mov    $0x0,%esi
  80020c:	bf 01 00 00 00       	mov    $0x1,%edi
  800211:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800218:	00 00 00 
  80021b:	ff d0                	callq  *%rax
}
  80021d:	c9                   	leaveq 
  80021e:	c3                   	retq   

000000000080021f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80021f:	55                   	push   %rbp
  800220:	48 89 e5             	mov    %rsp,%rbp
  800223:	48 83 ec 10          	sub    $0x10,%rsp
  800227:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80022a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022d:	48 98                	cltq   
  80022f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800236:	00 
  800237:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80023d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800243:	b9 00 00 00 00       	mov    $0x0,%ecx
  800248:	48 89 c2             	mov    %rax,%rdx
  80024b:	be 01 00 00 00       	mov    $0x1,%esi
  800250:	bf 03 00 00 00       	mov    $0x3,%edi
  800255:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
}
  800261:	c9                   	leaveq 
  800262:	c3                   	retq   

0000000000800263 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80026b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800272:	00 
  800273:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800279:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80027f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800284:	ba 00 00 00 00       	mov    $0x0,%edx
  800289:	be 00 00 00 00       	mov    $0x0,%esi
  80028e:	bf 02 00 00 00       	mov    $0x2,%edi
  800293:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  80029a:	00 00 00 
  80029d:	ff d0                	callq  *%rax
}
  80029f:	c9                   	leaveq 
  8002a0:	c3                   	retq   

00000000008002a1 <sys_yield>:

void
sys_yield(void)
{
  8002a1:	55                   	push   %rbp
  8002a2:	48 89 e5             	mov    %rsp,%rbp
  8002a5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002a9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002b0:	00 
  8002b1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c7:	be 00 00 00 00       	mov    $0x0,%esi
  8002cc:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002d1:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8002d8:	00 00 00 
  8002db:	ff d0                	callq  *%rax
}
  8002dd:	c9                   	leaveq 
  8002de:	c3                   	retq   

00000000008002df <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002df:	55                   	push   %rbp
  8002e0:	48 89 e5             	mov    %rsp,%rbp
  8002e3:	48 83 ec 20          	sub    $0x20,%rsp
  8002e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002ee:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f4:	48 63 c8             	movslq %eax,%rcx
  8002f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002fe:	48 98                	cltq   
  800300:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800307:	00 
  800308:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80030e:	49 89 c8             	mov    %rcx,%r8
  800311:	48 89 d1             	mov    %rdx,%rcx
  800314:	48 89 c2             	mov    %rax,%rdx
  800317:	be 01 00 00 00       	mov    $0x1,%esi
  80031c:	bf 04 00 00 00       	mov    $0x4,%edi
  800321:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800328:	00 00 00 
  80032b:	ff d0                	callq  *%rax
}
  80032d:	c9                   	leaveq 
  80032e:	c3                   	retq   

000000000080032f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80032f:	55                   	push   %rbp
  800330:	48 89 e5             	mov    %rsp,%rbp
  800333:	48 83 ec 30          	sub    $0x30,%rsp
  800337:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80033a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80033e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800341:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800345:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800349:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80034c:	48 63 c8             	movslq %eax,%rcx
  80034f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800353:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800356:	48 63 f0             	movslq %eax,%rsi
  800359:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800360:	48 98                	cltq   
  800362:	48 89 0c 24          	mov    %rcx,(%rsp)
  800366:	49 89 f9             	mov    %rdi,%r9
  800369:	49 89 f0             	mov    %rsi,%r8
  80036c:	48 89 d1             	mov    %rdx,%rcx
  80036f:	48 89 c2             	mov    %rax,%rdx
  800372:	be 01 00 00 00       	mov    $0x1,%esi
  800377:	bf 05 00 00 00       	mov    $0x5,%edi
  80037c:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800383:	00 00 00 
  800386:	ff d0                	callq  *%rax
}
  800388:	c9                   	leaveq 
  800389:	c3                   	retq   

000000000080038a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80038a:	55                   	push   %rbp
  80038b:	48 89 e5             	mov    %rsp,%rbp
  80038e:	48 83 ec 20          	sub    $0x20,%rsp
  800392:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800395:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800399:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a0:	48 98                	cltq   
  8003a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003a9:	00 
  8003aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003b6:	48 89 d1             	mov    %rdx,%rcx
  8003b9:	48 89 c2             	mov    %rax,%rdx
  8003bc:	be 01 00 00 00       	mov    $0x1,%esi
  8003c1:	bf 06 00 00 00       	mov    $0x6,%edi
  8003c6:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8003cd:	00 00 00 
  8003d0:	ff d0                	callq  *%rax
}
  8003d2:	c9                   	leaveq 
  8003d3:	c3                   	retq   

00000000008003d4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003d4:	55                   	push   %rbp
  8003d5:	48 89 e5             	mov    %rsp,%rbp
  8003d8:	48 83 ec 10          	sub    $0x10,%rsp
  8003dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003df:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e5:	48 63 d0             	movslq %eax,%rdx
  8003e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003eb:	48 98                	cltq   
  8003ed:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003f4:	00 
  8003f5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003fb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800401:	48 89 d1             	mov    %rdx,%rcx
  800404:	48 89 c2             	mov    %rax,%rdx
  800407:	be 01 00 00 00       	mov    $0x1,%esi
  80040c:	bf 08 00 00 00       	mov    $0x8,%edi
  800411:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800418:	00 00 00 
  80041b:	ff d0                	callq  *%rax
}
  80041d:	c9                   	leaveq 
  80041e:	c3                   	retq   

000000000080041f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80041f:	55                   	push   %rbp
  800420:	48 89 e5             	mov    %rsp,%rbp
  800423:	48 83 ec 20          	sub    $0x20,%rsp
  800427:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80042e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800435:	48 98                	cltq   
  800437:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80043e:	00 
  80043f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800445:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80044b:	48 89 d1             	mov    %rdx,%rcx
  80044e:	48 89 c2             	mov    %rax,%rdx
  800451:	be 01 00 00 00       	mov    $0x1,%esi
  800456:	bf 09 00 00 00       	mov    $0x9,%edi
  80045b:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
}
  800467:	c9                   	leaveq 
  800468:	c3                   	retq   

0000000000800469 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800469:	55                   	push   %rbp
  80046a:	48 89 e5             	mov    %rsp,%rbp
  80046d:	48 83 ec 20          	sub    $0x20,%rsp
  800471:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800474:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800478:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80047f:	48 98                	cltq   
  800481:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800488:	00 
  800489:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80048f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800495:	48 89 d1             	mov    %rdx,%rcx
  800498:	48 89 c2             	mov    %rax,%rdx
  80049b:	be 01 00 00 00       	mov    $0x1,%esi
  8004a0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004a5:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  8004ac:	00 00 00 
  8004af:	ff d0                	callq  *%rax
}
  8004b1:	c9                   	leaveq 
  8004b2:	c3                   	retq   

00000000008004b3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004b3:	55                   	push   %rbp
  8004b4:	48 89 e5             	mov    %rsp,%rbp
  8004b7:	48 83 ec 20          	sub    $0x20,%rsp
  8004bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004c6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004cc:	48 63 f0             	movslq %eax,%rsi
  8004cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d6:	48 98                	cltq   
  8004d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e3:	00 
  8004e4:	49 89 f1             	mov    %rsi,%r9
  8004e7:	49 89 c8             	mov    %rcx,%r8
  8004ea:	48 89 d1             	mov    %rdx,%rcx
  8004ed:	48 89 c2             	mov    %rax,%rdx
  8004f0:	be 00 00 00 00       	mov    $0x0,%esi
  8004f5:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004fa:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800501:	00 00 00 
  800504:	ff d0                	callq  *%rax
}
  800506:	c9                   	leaveq 
  800507:	c3                   	retq   

0000000000800508 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800508:	55                   	push   %rbp
  800509:	48 89 e5             	mov    %rsp,%rbp
  80050c:	48 83 ec 10          	sub    $0x10,%rsp
  800510:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800518:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80051f:	00 
  800520:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800526:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80052c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800531:	48 89 c2             	mov    %rax,%rdx
  800534:	be 01 00 00 00       	mov    $0x1,%esi
  800539:	bf 0d 00 00 00       	mov    $0xd,%edi
  80053e:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800545:	00 00 00 
  800548:	ff d0                	callq  *%rax
}
  80054a:	c9                   	leaveq 
  80054b:	c3                   	retq   

000000000080054c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80054c:	55                   	push   %rbp
  80054d:	48 89 e5             	mov    %rsp,%rbp
  800550:	48 83 ec 08          	sub    $0x8,%rsp
  800554:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800558:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80055c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800563:	ff ff ff 
  800566:	48 01 d0             	add    %rdx,%rax
  800569:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80056d:	c9                   	leaveq 
  80056e:	c3                   	retq   

000000000080056f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80056f:	55                   	push   %rbp
  800570:	48 89 e5             	mov    %rsp,%rbp
  800573:	48 83 ec 08          	sub    $0x8,%rsp
  800577:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80057b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80057f:	48 89 c7             	mov    %rax,%rdi
  800582:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  800589:	00 00 00 
  80058c:	ff d0                	callq  *%rax
  80058e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800594:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800598:	c9                   	leaveq 
  800599:	c3                   	retq   

000000000080059a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80059a:	55                   	push   %rbp
  80059b:	48 89 e5             	mov    %rsp,%rbp
  80059e:	48 83 ec 18          	sub    $0x18,%rsp
  8005a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005ad:	eb 6b                	jmp    80061a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005b2:	48 98                	cltq   
  8005b4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8005be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c6:	48 c1 e8 15          	shr    $0x15,%rax
  8005ca:	48 89 c2             	mov    %rax,%rdx
  8005cd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005d4:	01 00 00 
  8005d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005db:	83 e0 01             	and    $0x1,%eax
  8005de:	48 85 c0             	test   %rax,%rax
  8005e1:	74 21                	je     800604 <fd_alloc+0x6a>
  8005e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8005eb:	48 89 c2             	mov    %rax,%rdx
  8005ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005f5:	01 00 00 
  8005f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005fc:	83 e0 01             	and    $0x1,%eax
  8005ff:	48 85 c0             	test   %rax,%rax
  800602:	75 12                	jne    800616 <fd_alloc+0x7c>
			*fd_store = fd;
  800604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800608:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80060c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80060f:	b8 00 00 00 00       	mov    $0x0,%eax
  800614:	eb 1a                	jmp    800630 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800616:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80061a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80061e:	7e 8f                	jle    8005af <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800624:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80062b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800630:	c9                   	leaveq 
  800631:	c3                   	retq   

0000000000800632 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800632:	55                   	push   %rbp
  800633:	48 89 e5             	mov    %rsp,%rbp
  800636:	48 83 ec 20          	sub    $0x20,%rsp
  80063a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80063d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800641:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800645:	78 06                	js     80064d <fd_lookup+0x1b>
  800647:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80064b:	7e 07                	jle    800654 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80064d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800652:	eb 6c                	jmp    8006c0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800654:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800657:	48 98                	cltq   
  800659:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80065f:	48 c1 e0 0c          	shl    $0xc,%rax
  800663:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80066b:	48 c1 e8 15          	shr    $0x15,%rax
  80066f:	48 89 c2             	mov    %rax,%rdx
  800672:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800679:	01 00 00 
  80067c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800680:	83 e0 01             	and    $0x1,%eax
  800683:	48 85 c0             	test   %rax,%rax
  800686:	74 21                	je     8006a9 <fd_lookup+0x77>
  800688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80068c:	48 c1 e8 0c          	shr    $0xc,%rax
  800690:	48 89 c2             	mov    %rax,%rdx
  800693:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80069a:	01 00 00 
  80069d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a1:	83 e0 01             	and    $0x1,%eax
  8006a4:	48 85 c0             	test   %rax,%rax
  8006a7:	75 07                	jne    8006b0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ae:	eb 10                	jmp    8006c0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006b8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006c0:	c9                   	leaveq 
  8006c1:	c3                   	retq   

00000000008006c2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006c2:	55                   	push   %rbp
  8006c3:	48 89 e5             	mov    %rsp,%rbp
  8006c6:	48 83 ec 30          	sub    $0x30,%rsp
  8006ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006ce:	89 f0                	mov    %esi,%eax
  8006d0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006d7:	48 89 c7             	mov    %rax,%rdi
  8006da:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  8006e1:	00 00 00 
  8006e4:	ff d0                	callq  *%rax
  8006e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8006ea:	48 89 d6             	mov    %rdx,%rsi
  8006ed:	89 c7                	mov    %eax,%edi
  8006ef:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  8006f6:	00 00 00 
  8006f9:	ff d0                	callq  *%rax
  8006fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8006fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800702:	78 0a                	js     80070e <fd_close+0x4c>
	    || fd != fd2)
  800704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800708:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80070c:	74 12                	je     800720 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80070e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800712:	74 05                	je     800719 <fd_close+0x57>
  800714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800717:	eb 05                	jmp    80071e <fd_close+0x5c>
  800719:	b8 00 00 00 00       	mov    $0x0,%eax
  80071e:	eb 69                	jmp    800789 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800720:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800724:	8b 00                	mov    (%rax),%eax
  800726:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80072a:	48 89 d6             	mov    %rdx,%rsi
  80072d:	89 c7                	mov    %eax,%edi
  80072f:	48 b8 8b 07 80 00 00 	movabs $0x80078b,%rax
  800736:	00 00 00 
  800739:	ff d0                	callq  *%rax
  80073b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80073e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800742:	78 2a                	js     80076e <fd_close+0xac>
		if (dev->dev_close)
  800744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800748:	48 8b 40 20          	mov    0x20(%rax),%rax
  80074c:	48 85 c0             	test   %rax,%rax
  80074f:	74 16                	je     800767 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800755:	48 8b 40 20          	mov    0x20(%rax),%rax
  800759:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80075d:	48 89 d7             	mov    %rdx,%rdi
  800760:	ff d0                	callq  *%rax
  800762:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800765:	eb 07                	jmp    80076e <fd_close+0xac>
		else
			r = 0;
  800767:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80076e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800772:	48 89 c6             	mov    %rax,%rsi
  800775:	bf 00 00 00 00       	mov    $0x0,%edi
  80077a:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  800781:	00 00 00 
  800784:	ff d0                	callq  *%rax
	return r;
  800786:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800789:	c9                   	leaveq 
  80078a:	c3                   	retq   

000000000080078b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80078b:	55                   	push   %rbp
  80078c:	48 89 e5             	mov    %rsp,%rbp
  80078f:	48 83 ec 20          	sub    $0x20,%rsp
  800793:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800796:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80079a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007a1:	eb 41                	jmp    8007e4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007a3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007aa:	00 00 00 
  8007ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007b0:	48 63 d2             	movslq %edx,%rdx
  8007b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007b7:	8b 00                	mov    (%rax),%eax
  8007b9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007bc:	75 22                	jne    8007e0 <dev_lookup+0x55>
			*dev = devtab[i];
  8007be:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007c5:	00 00 00 
  8007c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007cb:	48 63 d2             	movslq %edx,%rdx
  8007ce:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007d6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007de:	eb 60                	jmp    800840 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007e4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007eb:	00 00 00 
  8007ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007f1:	48 63 d2             	movslq %edx,%rdx
  8007f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f8:	48 85 c0             	test   %rax,%rax
  8007fb:	75 a6                	jne    8007a3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007fd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800804:	00 00 00 
  800807:	48 8b 00             	mov    (%rax),%rax
  80080a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800810:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800813:	89 c6                	mov    %eax,%esi
  800815:	48 bf 18 36 80 00 00 	movabs $0x803618,%rdi
  80081c:	00 00 00 
  80081f:	b8 00 00 00 00       	mov    $0x0,%eax
  800824:	48 b9 4a 20 80 00 00 	movabs $0x80204a,%rcx
  80082b:	00 00 00 
  80082e:	ff d1                	callq  *%rcx
	*dev = 0;
  800830:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800834:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80083b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800840:	c9                   	leaveq 
  800841:	c3                   	retq   

0000000000800842 <close>:

int
close(int fdnum)
{
  800842:	55                   	push   %rbp
  800843:	48 89 e5             	mov    %rsp,%rbp
  800846:	48 83 ec 20          	sub    $0x20,%rsp
  80084a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80084d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800851:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800854:	48 89 d6             	mov    %rdx,%rsi
  800857:	89 c7                	mov    %eax,%edi
  800859:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800860:	00 00 00 
  800863:	ff d0                	callq  *%rax
  800865:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800868:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80086c:	79 05                	jns    800873 <close+0x31>
		return r;
  80086e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800871:	eb 18                	jmp    80088b <close+0x49>
	else
		return fd_close(fd, 1);
  800873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800877:	be 01 00 00 00       	mov    $0x1,%esi
  80087c:	48 89 c7             	mov    %rax,%rdi
  80087f:	48 b8 c2 06 80 00 00 	movabs $0x8006c2,%rax
  800886:	00 00 00 
  800889:	ff d0                	callq  *%rax
}
  80088b:	c9                   	leaveq 
  80088c:	c3                   	retq   

000000000080088d <close_all>:

void
close_all(void)
{
  80088d:	55                   	push   %rbp
  80088e:	48 89 e5             	mov    %rsp,%rbp
  800891:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800895:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80089c:	eb 15                	jmp    8008b3 <close_all+0x26>
		close(i);
  80089e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a1:	89 c7                	mov    %eax,%edi
  8008a3:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  8008aa:	00 00 00 
  8008ad:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008b3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008b7:	7e e5                	jle    80089e <close_all+0x11>
		close(i);
}
  8008b9:	c9                   	leaveq 
  8008ba:	c3                   	retq   

00000000008008bb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008bb:	55                   	push   %rbp
  8008bc:	48 89 e5             	mov    %rsp,%rbp
  8008bf:	48 83 ec 40          	sub    $0x40,%rsp
  8008c3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008c6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008c9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008cd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008d0:	48 89 d6             	mov    %rdx,%rsi
  8008d3:	89 c7                	mov    %eax,%edi
  8008d5:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  8008dc:	00 00 00 
  8008df:	ff d0                	callq  *%rax
  8008e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008e8:	79 08                	jns    8008f2 <dup+0x37>
		return r;
  8008ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ed:	e9 70 01 00 00       	jmpq   800a62 <dup+0x1a7>
	close(newfdnum);
  8008f2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8008f5:	89 c7                	mov    %eax,%edi
  8008f7:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  8008fe:	00 00 00 
  800901:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800903:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800906:	48 98                	cltq   
  800908:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80090e:	48 c1 e0 0c          	shl    $0xc,%rax
  800912:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80091a:	48 89 c7             	mov    %rax,%rdi
  80091d:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  800924:	00 00 00 
  800927:	ff d0                	callq  *%rax
  800929:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80092d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800931:	48 89 c7             	mov    %rax,%rdi
  800934:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  80093b:	00 00 00 
  80093e:	ff d0                	callq  *%rax
  800940:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800948:	48 c1 e8 15          	shr    $0x15,%rax
  80094c:	48 89 c2             	mov    %rax,%rdx
  80094f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800956:	01 00 00 
  800959:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80095d:	83 e0 01             	and    $0x1,%eax
  800960:	48 85 c0             	test   %rax,%rax
  800963:	74 73                	je     8009d8 <dup+0x11d>
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	48 c1 e8 0c          	shr    $0xc,%rax
  80096d:	48 89 c2             	mov    %rax,%rdx
  800970:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800977:	01 00 00 
  80097a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80097e:	83 e0 01             	and    $0x1,%eax
  800981:	48 85 c0             	test   %rax,%rax
  800984:	74 52                	je     8009d8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	48 c1 e8 0c          	shr    $0xc,%rax
  80098e:	48 89 c2             	mov    %rax,%rdx
  800991:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800998:	01 00 00 
  80099b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80099f:	25 07 0e 00 00       	and    $0xe07,%eax
  8009a4:	89 c1                	mov    %eax,%ecx
  8009a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ae:	41 89 c8             	mov    %ecx,%r8d
  8009b1:	48 89 d1             	mov    %rdx,%rcx
  8009b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b9:	48 89 c6             	mov    %rax,%rsi
  8009bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8009c1:	48 b8 2f 03 80 00 00 	movabs $0x80032f,%rax
  8009c8:	00 00 00 
  8009cb:	ff d0                	callq  *%rax
  8009cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009d4:	79 02                	jns    8009d8 <dup+0x11d>
			goto err;
  8009d6:	eb 57                	jmp    800a2f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8009e0:	48 89 c2             	mov    %rax,%rdx
  8009e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009ea:	01 00 00 
  8009ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8009f6:	89 c1                	mov    %eax,%ecx
  8009f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a00:	41 89 c8             	mov    %ecx,%r8d
  800a03:	48 89 d1             	mov    %rdx,%rcx
  800a06:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0b:	48 89 c6             	mov    %rax,%rsi
  800a0e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a13:	48 b8 2f 03 80 00 00 	movabs $0x80032f,%rax
  800a1a:	00 00 00 
  800a1d:	ff d0                	callq  *%rax
  800a1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a26:	79 02                	jns    800a2a <dup+0x16f>
		goto err;
  800a28:	eb 05                	jmp    800a2f <dup+0x174>

	return newfdnum;
  800a2a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a2d:	eb 33                	jmp    800a62 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a33:	48 89 c6             	mov    %rax,%rsi
  800a36:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3b:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  800a42:	00 00 00 
  800a45:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a4b:	48 89 c6             	mov    %rax,%rsi
  800a4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a53:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  800a5a:	00 00 00 
  800a5d:	ff d0                	callq  *%rax
	return r;
  800a5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a62:	c9                   	leaveq 
  800a63:	c3                   	retq   

0000000000800a64 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a64:	55                   	push   %rbp
  800a65:	48 89 e5             	mov    %rsp,%rbp
  800a68:	48 83 ec 40          	sub    $0x40,%rsp
  800a6c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a6f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a73:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a77:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a7b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a7e:	48 89 d6             	mov    %rdx,%rsi
  800a81:	89 c7                	mov    %eax,%edi
  800a83:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800a8a:	00 00 00 
  800a8d:	ff d0                	callq  *%rax
  800a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a96:	78 24                	js     800abc <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9c:	8b 00                	mov    (%rax),%eax
  800a9e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800aa2:	48 89 d6             	mov    %rdx,%rsi
  800aa5:	89 c7                	mov    %eax,%edi
  800aa7:	48 b8 8b 07 80 00 00 	movabs $0x80078b,%rax
  800aae:	00 00 00 
  800ab1:	ff d0                	callq  *%rax
  800ab3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aba:	79 05                	jns    800ac1 <read+0x5d>
		return r;
  800abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800abf:	eb 76                	jmp    800b37 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	8b 40 08             	mov    0x8(%rax),%eax
  800ac8:	83 e0 03             	and    $0x3,%eax
  800acb:	83 f8 01             	cmp    $0x1,%eax
  800ace:	75 3a                	jne    800b0a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800ad0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ad7:	00 00 00 
  800ada:	48 8b 00             	mov    (%rax),%rax
  800add:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800ae3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ae6:	89 c6                	mov    %eax,%esi
  800ae8:	48 bf 37 36 80 00 00 	movabs $0x803637,%rdi
  800aef:	00 00 00 
  800af2:	b8 00 00 00 00       	mov    $0x0,%eax
  800af7:	48 b9 4a 20 80 00 00 	movabs $0x80204a,%rcx
  800afe:	00 00 00 
  800b01:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b08:	eb 2d                	jmp    800b37 <read+0xd3>
	}
	if (!dev->dev_read)
  800b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b0e:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b12:	48 85 c0             	test   %rax,%rax
  800b15:	75 07                	jne    800b1e <read+0xba>
		return -E_NOT_SUPP;
  800b17:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b1c:	eb 19                	jmp    800b37 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b22:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b2a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b32:	48 89 cf             	mov    %rcx,%rdi
  800b35:	ff d0                	callq  *%rax
}
  800b37:	c9                   	leaveq 
  800b38:	c3                   	retq   

0000000000800b39 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b39:	55                   	push   %rbp
  800b3a:	48 89 e5             	mov    %rsp,%rbp
  800b3d:	48 83 ec 30          	sub    $0x30,%rsp
  800b41:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b53:	eb 49                	jmp    800b9e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b58:	48 98                	cltq   
  800b5a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b5e:	48 29 c2             	sub    %rax,%rdx
  800b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b64:	48 63 c8             	movslq %eax,%rcx
  800b67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b6b:	48 01 c1             	add    %rax,%rcx
  800b6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b71:	48 89 ce             	mov    %rcx,%rsi
  800b74:	89 c7                	mov    %eax,%edi
  800b76:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  800b7d:	00 00 00 
  800b80:	ff d0                	callq  *%rax
  800b82:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800b85:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b89:	79 05                	jns    800b90 <readn+0x57>
			return m;
  800b8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b8e:	eb 1c                	jmp    800bac <readn+0x73>
		if (m == 0)
  800b90:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b94:	75 02                	jne    800b98 <readn+0x5f>
			break;
  800b96:	eb 11                	jmp    800ba9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b9b:	01 45 fc             	add    %eax,-0x4(%rbp)
  800b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ba1:	48 98                	cltq   
  800ba3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ba7:	72 ac                	jb     800b55 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bac:	c9                   	leaveq 
  800bad:	c3                   	retq   

0000000000800bae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bae:	55                   	push   %rbp
  800baf:	48 89 e5             	mov    %rsp,%rbp
  800bb2:	48 83 ec 40          	sub    $0x40,%rsp
  800bb6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bb9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bbd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bc1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bc5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bc8:	48 89 d6             	mov    %rdx,%rsi
  800bcb:	89 c7                	mov    %eax,%edi
  800bcd:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
  800bd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800be0:	78 24                	js     800c06 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be6:	8b 00                	mov    (%rax),%eax
  800be8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bec:	48 89 d6             	mov    %rdx,%rsi
  800bef:	89 c7                	mov    %eax,%edi
  800bf1:	48 b8 8b 07 80 00 00 	movabs $0x80078b,%rax
  800bf8:	00 00 00 
  800bfb:	ff d0                	callq  *%rax
  800bfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c04:	79 05                	jns    800c0b <write+0x5d>
		return r;
  800c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c09:	eb 75                	jmp    800c80 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0f:	8b 40 08             	mov    0x8(%rax),%eax
  800c12:	83 e0 03             	and    $0x3,%eax
  800c15:	85 c0                	test   %eax,%eax
  800c17:	75 3a                	jne    800c53 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c19:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c20:	00 00 00 
  800c23:	48 8b 00             	mov    (%rax),%rax
  800c26:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c2c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c2f:	89 c6                	mov    %eax,%esi
  800c31:	48 bf 53 36 80 00 00 	movabs $0x803653,%rdi
  800c38:	00 00 00 
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c40:	48 b9 4a 20 80 00 00 	movabs $0x80204a,%rcx
  800c47:	00 00 00 
  800c4a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c51:	eb 2d                	jmp    800c80 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c57:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c5b:	48 85 c0             	test   %rax,%rax
  800c5e:	75 07                	jne    800c67 <write+0xb9>
		return -E_NOT_SUPP;
  800c60:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c65:	eb 19                	jmp    800c80 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c6f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c73:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c77:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c7b:	48 89 cf             	mov    %rcx,%rdi
  800c7e:	ff d0                	callq  *%rax
}
  800c80:	c9                   	leaveq 
  800c81:	c3                   	retq   

0000000000800c82 <seek>:

int
seek(int fdnum, off_t offset)
{
  800c82:	55                   	push   %rbp
  800c83:	48 89 e5             	mov    %rsp,%rbp
  800c86:	48 83 ec 18          	sub    $0x18,%rsp
  800c8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c8d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c97:	48 89 d6             	mov    %rdx,%rsi
  800c9a:	89 c7                	mov    %eax,%edi
  800c9c:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	callq  *%rax
  800ca8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800caf:	79 05                	jns    800cb6 <seek+0x34>
		return r;
  800cb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb4:	eb 0f                	jmp    800cc5 <seek+0x43>
	fd->fd_offset = offset;
  800cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cbd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc5:	c9                   	leaveq 
  800cc6:	c3                   	retq   

0000000000800cc7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800cc7:	55                   	push   %rbp
  800cc8:	48 89 e5             	mov    %rsp,%rbp
  800ccb:	48 83 ec 30          	sub    $0x30,%rsp
  800ccf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cd2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cd5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cd9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cdc:	48 89 d6             	mov    %rdx,%rsi
  800cdf:	89 c7                	mov    %eax,%edi
  800ce1:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800ce8:	00 00 00 
  800ceb:	ff d0                	callq  *%rax
  800ced:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cf0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cf4:	78 24                	js     800d1a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfa:	8b 00                	mov    (%rax),%eax
  800cfc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d00:	48 89 d6             	mov    %rdx,%rsi
  800d03:	89 c7                	mov    %eax,%edi
  800d05:	48 b8 8b 07 80 00 00 	movabs $0x80078b,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	callq  *%rax
  800d11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d18:	79 05                	jns    800d1f <ftruncate+0x58>
		return r;
  800d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d1d:	eb 72                	jmp    800d91 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d23:	8b 40 08             	mov    0x8(%rax),%eax
  800d26:	83 e0 03             	and    $0x3,%eax
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	75 3a                	jne    800d67 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d2d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d34:	00 00 00 
  800d37:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d3a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d40:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d43:	89 c6                	mov    %eax,%esi
  800d45:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  800d4c:	00 00 00 
  800d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d54:	48 b9 4a 20 80 00 00 	movabs $0x80204a,%rcx
  800d5b:	00 00 00 
  800d5e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d65:	eb 2a                	jmp    800d91 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d6f:	48 85 c0             	test   %rax,%rax
  800d72:	75 07                	jne    800d7b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d74:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d79:	eb 16                	jmp    800d91 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7f:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d87:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800d8a:	89 ce                	mov    %ecx,%esi
  800d8c:	48 89 d7             	mov    %rdx,%rdi
  800d8f:	ff d0                	callq  *%rax
}
  800d91:	c9                   	leaveq 
  800d92:	c3                   	retq   

0000000000800d93 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800d93:	55                   	push   %rbp
  800d94:	48 89 e5             	mov    %rsp,%rbp
  800d97:	48 83 ec 30          	sub    $0x30,%rsp
  800d9b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d9e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800da2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800da6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800da9:	48 89 d6             	mov    %rdx,%rsi
  800dac:	89 c7                	mov    %eax,%edi
  800dae:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	callq  *%rax
  800dba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc1:	78 24                	js     800de7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc7:	8b 00                	mov    (%rax),%eax
  800dc9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dcd:	48 89 d6             	mov    %rdx,%rsi
  800dd0:	89 c7                	mov    %eax,%edi
  800dd2:	48 b8 8b 07 80 00 00 	movabs $0x80078b,%rax
  800dd9:	00 00 00 
  800ddc:	ff d0                	callq  *%rax
  800dde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800de1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de5:	79 05                	jns    800dec <fstat+0x59>
		return r;
  800de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dea:	eb 5e                	jmp    800e4a <fstat+0xb7>
	if (!dev->dev_stat)
  800dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df0:	48 8b 40 28          	mov    0x28(%rax),%rax
  800df4:	48 85 c0             	test   %rax,%rax
  800df7:	75 07                	jne    800e00 <fstat+0x6d>
		return -E_NOT_SUPP;
  800df9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800dfe:	eb 4a                	jmp    800e4a <fstat+0xb7>
	stat->st_name[0] = 0;
  800e00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e04:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e0b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e12:	00 00 00 
	stat->st_isdir = 0;
  800e15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e19:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e20:	00 00 00 
	stat->st_dev = dev;
  800e23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e36:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e3e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e42:	48 89 ce             	mov    %rcx,%rsi
  800e45:	48 89 d7             	mov    %rdx,%rdi
  800e48:	ff d0                	callq  *%rax
}
  800e4a:	c9                   	leaveq 
  800e4b:	c3                   	retq   

0000000000800e4c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e4c:	55                   	push   %rbp
  800e4d:	48 89 e5             	mov    %rsp,%rbp
  800e50:	48 83 ec 20          	sub    $0x20,%rsp
  800e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e60:	be 00 00 00 00       	mov    $0x0,%esi
  800e65:	48 89 c7             	mov    %rax,%rdi
  800e68:	48 b8 3a 0f 80 00 00 	movabs $0x800f3a,%rax
  800e6f:	00 00 00 
  800e72:	ff d0                	callq  *%rax
  800e74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e7b:	79 05                	jns    800e82 <stat+0x36>
		return fd;
  800e7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e80:	eb 2f                	jmp    800eb1 <stat+0x65>
	r = fstat(fd, stat);
  800e82:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e89:	48 89 d6             	mov    %rdx,%rsi
  800e8c:	89 c7                	mov    %eax,%edi
  800e8e:	48 b8 93 0d 80 00 00 	movabs $0x800d93,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea0:	89 c7                	mov    %eax,%edi
  800ea2:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  800ea9:	00 00 00 
  800eac:	ff d0                	callq  *%rax
	return r;
  800eae:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800eb1:	c9                   	leaveq 
  800eb2:	c3                   	retq   

0000000000800eb3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800eb3:	55                   	push   %rbp
  800eb4:	48 89 e5             	mov    %rsp,%rbp
  800eb7:	48 83 ec 10          	sub    $0x10,%rsp
  800ebb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ebe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ec2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ec9:	00 00 00 
  800ecc:	8b 00                	mov    (%rax),%eax
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	75 1d                	jne    800eef <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ed2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ed7:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	callq  *%rax
  800ee3:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800eea:	00 00 00 
  800eed:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800eef:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ef6:	00 00 00 
  800ef9:	8b 00                	mov    (%rax),%eax
  800efb:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800efe:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f03:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f0a:	00 00 00 
  800f0d:	89 c7                	mov    %eax,%edi
  800f0f:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  800f16:	00 00 00 
  800f19:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f24:	48 89 c6             	mov    %rax,%rsi
  800f27:	bf 00 00 00 00       	mov    $0x0,%edi
  800f2c:	48 b8 6b 33 80 00 00 	movabs $0x80336b,%rax
  800f33:	00 00 00 
  800f36:	ff d0                	callq  *%rax
}
  800f38:	c9                   	leaveq 
  800f39:	c3                   	retq   

0000000000800f3a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f3a:	55                   	push   %rbp
  800f3b:	48 89 e5             	mov    %rsp,%rbp
  800f3e:	48 83 ec 20          	sub    $0x20,%rsp
  800f42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f46:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4d:	48 89 c7             	mov    %rax,%rdi
  800f50:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
  800f5c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f61:	7e 0a                	jle    800f6d <open+0x33>
		return -E_BAD_PATH;
  800f63:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f68:	e9 a5 00 00 00       	jmpq   801012 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f6d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f71:	48 89 c7             	mov    %rax,%rdi
  800f74:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  800f7b:	00 00 00 
  800f7e:	ff d0                	callq  *%rax
  800f80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f87:	79 08                	jns    800f91 <open+0x57>
		return r;
  800f89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f8c:	e9 81 00 00 00       	jmpq   801012 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f95:	48 89 c6             	mov    %rax,%rsi
  800f98:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800f9f:	00 00 00 
  800fa2:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  800fa9:	00 00 00 
  800fac:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fb5:	00 00 00 
  800fb8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fbb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc5:	48 89 c6             	mov    %rax,%rsi
  800fc8:	bf 01 00 00 00       	mov    $0x1,%edi
  800fcd:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  800fd4:	00 00 00 
  800fd7:	ff d0                	callq  *%rax
  800fd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fe0:	79 1d                	jns    800fff <open+0xc5>
		fd_close(fd, 0);
  800fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe6:	be 00 00 00 00       	mov    $0x0,%esi
  800feb:	48 89 c7             	mov    %rax,%rdi
  800fee:	48 b8 c2 06 80 00 00 	movabs $0x8006c2,%rax
  800ff5:	00 00 00 
  800ff8:	ff d0                	callq  *%rax
		return r;
  800ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ffd:	eb 13                	jmp    801012 <open+0xd8>
	}

	return fd2num(fd);
  800fff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801003:	48 89 c7             	mov    %rax,%rdi
  801006:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  80100d:	00 00 00 
  801010:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  801012:	c9                   	leaveq 
  801013:	c3                   	retq   

0000000000801014 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801014:	55                   	push   %rbp
  801015:	48 89 e5             	mov    %rsp,%rbp
  801018:	48 83 ec 10          	sub    $0x10,%rsp
  80101c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801024:	8b 50 0c             	mov    0xc(%rax),%edx
  801027:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80102e:	00 00 00 
  801031:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801033:	be 00 00 00 00       	mov    $0x0,%esi
  801038:	bf 06 00 00 00       	mov    $0x6,%edi
  80103d:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  801044:	00 00 00 
  801047:	ff d0                	callq  *%rax
}
  801049:	c9                   	leaveq 
  80104a:	c3                   	retq   

000000000080104b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80104b:	55                   	push   %rbp
  80104c:	48 89 e5             	mov    %rsp,%rbp
  80104f:	48 83 ec 30          	sub    $0x30,%rsp
  801053:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801057:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80105b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80105f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801063:	8b 50 0c             	mov    0xc(%rax),%edx
  801066:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80106d:	00 00 00 
  801070:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801072:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801079:	00 00 00 
  80107c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801080:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801084:	be 00 00 00 00       	mov    $0x0,%esi
  801089:	bf 03 00 00 00       	mov    $0x3,%edi
  80108e:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  801095:	00 00 00 
  801098:	ff d0                	callq  *%rax
  80109a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80109d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010a1:	79 08                	jns    8010ab <devfile_read+0x60>
		return r;
  8010a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a6:	e9 a4 00 00 00       	jmpq   80114f <devfile_read+0x104>
	assert(r <= n);
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	48 98                	cltq   
  8010b0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010b4:	76 35                	jbe    8010eb <devfile_read+0xa0>
  8010b6:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  8010bd:	00 00 00 
  8010c0:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8010c7:	00 00 00 
  8010ca:	be 84 00 00 00       	mov    $0x84,%esi
  8010cf:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8010d6:	00 00 00 
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010de:	49 b8 11 1e 80 00 00 	movabs $0x801e11,%r8
  8010e5:	00 00 00 
  8010e8:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8010eb:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8010f2:	7e 35                	jle    801129 <devfile_read+0xde>
  8010f4:	48 b9 c4 36 80 00 00 	movabs $0x8036c4,%rcx
  8010fb:	00 00 00 
  8010fe:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  801105:	00 00 00 
  801108:	be 85 00 00 00       	mov    $0x85,%esi
  80110d:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  801114:	00 00 00 
  801117:	b8 00 00 00 00       	mov    $0x0,%eax
  80111c:	49 b8 11 1e 80 00 00 	movabs $0x801e11,%r8
  801123:	00 00 00 
  801126:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801129:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112c:	48 63 d0             	movslq %eax,%rdx
  80112f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801133:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80113a:	00 00 00 
  80113d:	48 89 c7             	mov    %rax,%rdi
  801140:	48 b8 36 2f 80 00 00 	movabs $0x802f36,%rax
  801147:	00 00 00 
  80114a:	ff d0                	callq  *%rax
	return r;
  80114c:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80114f:	c9                   	leaveq 
  801150:	c3                   	retq   

0000000000801151 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801151:	55                   	push   %rbp
  801152:	48 89 e5             	mov    %rsp,%rbp
  801155:	48 83 ec 30          	sub    $0x30,%rsp
  801159:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801161:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801165:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801169:	8b 50 0c             	mov    0xc(%rax),%edx
  80116c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801173:	00 00 00 
  801176:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801178:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80117f:	00 00 00 
  801182:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801186:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80118a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801191:	00 
  801192:	76 35                	jbe    8011c9 <devfile_write+0x78>
  801194:	48 b9 d0 36 80 00 00 	movabs $0x8036d0,%rcx
  80119b:	00 00 00 
  80119e:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8011a5:	00 00 00 
  8011a8:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011ad:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8011b4:	00 00 00 
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bc:	49 b8 11 1e 80 00 00 	movabs $0x801e11,%r8
  8011c3:	00 00 00 
  8011c6:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d1:	48 89 c6             	mov    %rax,%rsi
  8011d4:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011db:	00 00 00 
  8011de:	48 b8 4d 30 80 00 00 	movabs $0x80304d,%rax
  8011e5:	00 00 00 
  8011e8:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8011ea:	be 00 00 00 00       	mov    $0x0,%esi
  8011ef:	bf 04 00 00 00       	mov    $0x4,%edi
  8011f4:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  8011fb:	00 00 00 
  8011fe:	ff d0                	callq  *%rax
  801200:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801207:	79 05                	jns    80120e <devfile_write+0xbd>
		return r;
  801209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80120c:	eb 43                	jmp    801251 <devfile_write+0x100>
	assert(r <= n);
  80120e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801211:	48 98                	cltq   
  801213:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801217:	76 35                	jbe    80124e <devfile_write+0xfd>
  801219:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  801220:	00 00 00 
  801223:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  80122a:	00 00 00 
  80122d:	be a2 00 00 00       	mov    $0xa2,%esi
  801232:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  801239:	00 00 00 
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
  801241:	49 b8 11 1e 80 00 00 	movabs $0x801e11,%r8
  801248:	00 00 00 
  80124b:	41 ff d0             	callq  *%r8
	return r;
  80124e:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801251:	c9                   	leaveq 
  801252:	c3                   	retq   

0000000000801253 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801253:	55                   	push   %rbp
  801254:	48 89 e5             	mov    %rsp,%rbp
  801257:	48 83 ec 20          	sub    $0x20,%rsp
  80125b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801267:	8b 50 0c             	mov    0xc(%rax),%edx
  80126a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801271:	00 00 00 
  801274:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801276:	be 00 00 00 00       	mov    $0x0,%esi
  80127b:	bf 05 00 00 00       	mov    $0x5,%edi
  801280:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  801287:	00 00 00 
  80128a:	ff d0                	callq  *%rax
  80128c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80128f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801293:	79 05                	jns    80129a <devfile_stat+0x47>
		return r;
  801295:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801298:	eb 56                	jmp    8012f0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80129a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012a5:	00 00 00 
  8012a8:	48 89 c7             	mov    %rax,%rdi
  8012ab:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  8012b2:	00 00 00 
  8012b5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012b7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012be:	00 00 00 
  8012c1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012cb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012d1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012d8:	00 00 00 
  8012db:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f0:	c9                   	leaveq 
  8012f1:	c3                   	retq   

00000000008012f2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	48 83 ec 10          	sub    $0x10,%rsp
  8012fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fe:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801305:	8b 50 0c             	mov    0xc(%rax),%edx
  801308:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80130f:	00 00 00 
  801312:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801314:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80131b:	00 00 00 
  80131e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801321:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801324:	be 00 00 00 00       	mov    $0x0,%esi
  801329:	bf 02 00 00 00       	mov    $0x2,%edi
  80132e:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  801335:	00 00 00 
  801338:	ff d0                	callq  *%rax
}
  80133a:	c9                   	leaveq 
  80133b:	c3                   	retq   

000000000080133c <remove>:

// Delete a file
int
remove(const char *path)
{
  80133c:	55                   	push   %rbp
  80133d:	48 89 e5             	mov    %rsp,%rbp
  801340:	48 83 ec 10          	sub    $0x10,%rsp
  801344:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	48 89 c7             	mov    %rax,%rdi
  80134f:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  801356:	00 00 00 
  801359:	ff d0                	callq  *%rax
  80135b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801360:	7e 07                	jle    801369 <remove+0x2d>
		return -E_BAD_PATH;
  801362:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801367:	eb 33                	jmp    80139c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	48 89 c6             	mov    %rax,%rsi
  801370:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801377:	00 00 00 
  80137a:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  801381:	00 00 00 
  801384:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801386:	be 00 00 00 00       	mov    $0x0,%esi
  80138b:	bf 07 00 00 00       	mov    $0x7,%edi
  801390:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  801397:	00 00 00 
  80139a:	ff d0                	callq  *%rax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013a2:	be 00 00 00 00       	mov    $0x0,%esi
  8013a7:	bf 08 00 00 00       	mov    $0x8,%edi
  8013ac:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  8013b3:	00 00 00 
  8013b6:	ff d0                	callq  *%rax
}
  8013b8:	5d                   	pop    %rbp
  8013b9:	c3                   	retq   

00000000008013ba <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013c5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013cc:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013d3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013da:	be 00 00 00 00       	mov    $0x0,%esi
  8013df:	48 89 c7             	mov    %rax,%rdi
  8013e2:	48 b8 3a 0f 80 00 00 	movabs $0x800f3a,%rax
  8013e9:	00 00 00 
  8013ec:	ff d0                	callq  *%rax
  8013ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8013f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013f5:	79 28                	jns    80141f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8013f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013fa:	89 c6                	mov    %eax,%esi
  8013fc:	48 bf fd 36 80 00 00 	movabs $0x8036fd,%rdi
  801403:	00 00 00 
  801406:	b8 00 00 00 00       	mov    $0x0,%eax
  80140b:	48 ba 4a 20 80 00 00 	movabs $0x80204a,%rdx
  801412:	00 00 00 
  801415:	ff d2                	callq  *%rdx
		return fd_src;
  801417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141a:	e9 74 01 00 00       	jmpq   801593 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80141f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801426:	be 01 01 00 00       	mov    $0x101,%esi
  80142b:	48 89 c7             	mov    %rax,%rdi
  80142e:	48 b8 3a 0f 80 00 00 	movabs $0x800f3a,%rax
  801435:	00 00 00 
  801438:	ff d0                	callq  *%rax
  80143a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80143d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801441:	79 39                	jns    80147c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801443:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801446:	89 c6                	mov    %eax,%esi
  801448:	48 bf 13 37 80 00 00 	movabs $0x803713,%rdi
  80144f:	00 00 00 
  801452:	b8 00 00 00 00       	mov    $0x0,%eax
  801457:	48 ba 4a 20 80 00 00 	movabs $0x80204a,%rdx
  80145e:	00 00 00 
  801461:	ff d2                	callq  *%rdx
		close(fd_src);
  801463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801466:	89 c7                	mov    %eax,%edi
  801468:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  80146f:	00 00 00 
  801472:	ff d0                	callq  *%rax
		return fd_dest;
  801474:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801477:	e9 17 01 00 00       	jmpq   801593 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80147c:	eb 74                	jmp    8014f2 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80147e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801481:	48 63 d0             	movslq %eax,%rdx
  801484:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80148b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80148e:	48 89 ce             	mov    %rcx,%rsi
  801491:	89 c7                	mov    %eax,%edi
  801493:	48 b8 ae 0b 80 00 00 	movabs $0x800bae,%rax
  80149a:	00 00 00 
  80149d:	ff d0                	callq  *%rax
  80149f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014a6:	79 4a                	jns    8014f2 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014ab:	89 c6                	mov    %eax,%esi
  8014ad:	48 bf 2d 37 80 00 00 	movabs $0x80372d,%rdi
  8014b4:	00 00 00 
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bc:	48 ba 4a 20 80 00 00 	movabs $0x80204a,%rdx
  8014c3:	00 00 00 
  8014c6:	ff d2                	callq  *%rdx
			close(fd_src);
  8014c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014cb:	89 c7                	mov    %eax,%edi
  8014cd:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  8014d4:	00 00 00 
  8014d7:	ff d0                	callq  *%rax
			close(fd_dest);
  8014d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014dc:	89 c7                	mov    %eax,%edi
  8014de:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  8014e5:	00 00 00 
  8014e8:	ff d0                	callq  *%rax
			return write_size;
  8014ea:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014ed:	e9 a1 00 00 00       	jmpq   801593 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014f2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014fc:	ba 00 02 00 00       	mov    $0x200,%edx
  801501:	48 89 ce             	mov    %rcx,%rsi
  801504:	89 c7                	mov    %eax,%edi
  801506:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  80150d:	00 00 00 
  801510:	ff d0                	callq  *%rax
  801512:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801515:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801519:	0f 8f 5f ff ff ff    	jg     80147e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80151f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801523:	79 47                	jns    80156c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801525:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801528:	89 c6                	mov    %eax,%esi
  80152a:	48 bf 40 37 80 00 00 	movabs $0x803740,%rdi
  801531:	00 00 00 
  801534:	b8 00 00 00 00       	mov    $0x0,%eax
  801539:	48 ba 4a 20 80 00 00 	movabs $0x80204a,%rdx
  801540:	00 00 00 
  801543:	ff d2                	callq  *%rdx
		close(fd_src);
  801545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801548:	89 c7                	mov    %eax,%edi
  80154a:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  801551:	00 00 00 
  801554:	ff d0                	callq  *%rax
		close(fd_dest);
  801556:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801559:	89 c7                	mov    %eax,%edi
  80155b:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  801562:	00 00 00 
  801565:	ff d0                	callq  *%rax
		return read_size;
  801567:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80156a:	eb 27                	jmp    801593 <copy+0x1d9>
	}
	close(fd_src);
  80156c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80156f:	89 c7                	mov    %eax,%edi
  801571:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  801578:	00 00 00 
  80157b:	ff d0                	callq  *%rax
	close(fd_dest);
  80157d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801580:	89 c7                	mov    %eax,%edi
  801582:	48 b8 42 08 80 00 00 	movabs $0x800842,%rax
  801589:	00 00 00 
  80158c:	ff d0                	callq  *%rax
	return 0;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801593:	c9                   	leaveq 
  801594:	c3                   	retq   

0000000000801595 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801595:	55                   	push   %rbp
  801596:	48 89 e5             	mov    %rsp,%rbp
  801599:	53                   	push   %rbx
  80159a:	48 83 ec 38          	sub    $0x38,%rsp
  80159e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015a2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015a6:	48 89 c7             	mov    %rax,%rdi
  8015a9:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8015b0:	00 00 00 
  8015b3:	ff d0                	callq  *%rax
  8015b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015bc:	0f 88 bf 01 00 00    	js     801781 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	ba 07 04 00 00       	mov    $0x407,%edx
  8015cb:	48 89 c6             	mov    %rax,%rsi
  8015ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8015d3:	48 b8 df 02 80 00 00 	movabs $0x8002df,%rax
  8015da:	00 00 00 
  8015dd:	ff d0                	callq  *%rax
  8015df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015e6:	0f 88 95 01 00 00    	js     801781 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8015ec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015f0:	48 89 c7             	mov    %rax,%rdi
  8015f3:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8015fa:	00 00 00 
  8015fd:	ff d0                	callq  *%rax
  8015ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801602:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801606:	0f 88 5d 01 00 00    	js     801769 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80160c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801610:	ba 07 04 00 00       	mov    $0x407,%edx
  801615:	48 89 c6             	mov    %rax,%rsi
  801618:	bf 00 00 00 00       	mov    $0x0,%edi
  80161d:	48 b8 df 02 80 00 00 	movabs $0x8002df,%rax
  801624:	00 00 00 
  801627:	ff d0                	callq  *%rax
  801629:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80162c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801630:	0f 88 33 01 00 00    	js     801769 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163a:	48 89 c7             	mov    %rax,%rdi
  80163d:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  801644:	00 00 00 
  801647:	ff d0                	callq  *%rax
  801649:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80164d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801651:	ba 07 04 00 00       	mov    $0x407,%edx
  801656:	48 89 c6             	mov    %rax,%rsi
  801659:	bf 00 00 00 00       	mov    $0x0,%edi
  80165e:	48 b8 df 02 80 00 00 	movabs $0x8002df,%rax
  801665:	00 00 00 
  801668:	ff d0                	callq  *%rax
  80166a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801671:	79 05                	jns    801678 <pipe+0xe3>
		goto err2;
  801673:	e9 d9 00 00 00       	jmpq   801751 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167c:	48 89 c7             	mov    %rax,%rdi
  80167f:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  801686:	00 00 00 
  801689:	ff d0                	callq  *%rax
  80168b:	48 89 c2             	mov    %rax,%rdx
  80168e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801692:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801698:	48 89 d1             	mov    %rdx,%rcx
  80169b:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a0:	48 89 c6             	mov    %rax,%rsi
  8016a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a8:	48 b8 2f 03 80 00 00 	movabs $0x80032f,%rax
  8016af:	00 00 00 
  8016b2:	ff d0                	callq  *%rax
  8016b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016bb:	79 1b                	jns    8016d8 <pipe+0x143>
		goto err3;
  8016bd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016c2:	48 89 c6             	mov    %rax,%rsi
  8016c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ca:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  8016d1:	00 00 00 
  8016d4:	ff d0                	callq  *%rax
  8016d6:	eb 79                	jmp    801751 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dc:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016e3:	00 00 00 
  8016e6:	8b 12                	mov    (%rdx),%edx
  8016e8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8016ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8016f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f9:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801700:	00 00 00 
  801703:	8b 12                	mov    (%rdx),%edx
  801705:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801707:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	48 89 c7             	mov    %rax,%rdi
  801719:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  801720:	00 00 00 
  801723:	ff d0                	callq  *%rax
  801725:	89 c2                	mov    %eax,%edx
  801727:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80172b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80172d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801731:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801735:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801739:	48 89 c7             	mov    %rax,%rdi
  80173c:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  801743:	00 00 00 
  801746:	ff d0                	callq  *%rax
  801748:	89 03                	mov    %eax,(%rbx)
	return 0;
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
  80174f:	eb 33                	jmp    801784 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801751:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801755:	48 89 c6             	mov    %rax,%rsi
  801758:	bf 00 00 00 00       	mov    $0x0,%edi
  80175d:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  801764:	00 00 00 
  801767:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	48 89 c6             	mov    %rax,%rsi
  801770:	bf 00 00 00 00       	mov    $0x0,%edi
  801775:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  80177c:	00 00 00 
  80177f:	ff d0                	callq  *%rax
err:
	return r;
  801781:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801784:	48 83 c4 38          	add    $0x38,%rsp
  801788:	5b                   	pop    %rbx
  801789:	5d                   	pop    %rbp
  80178a:	c3                   	retq   

000000000080178b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80178b:	55                   	push   %rbp
  80178c:	48 89 e5             	mov    %rsp,%rbp
  80178f:	53                   	push   %rbx
  801790:	48 83 ec 28          	sub    $0x28,%rsp
  801794:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801798:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80179c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017a3:	00 00 00 
  8017a6:	48 8b 00             	mov    (%rax),%rax
  8017a9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017af:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b6:	48 89 c7             	mov    %rax,%rdi
  8017b9:	48 b8 46 35 80 00 00 	movabs $0x803546,%rax
  8017c0:	00 00 00 
  8017c3:	ff d0                	callq  *%rax
  8017c5:	89 c3                	mov    %eax,%ebx
  8017c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017cb:	48 89 c7             	mov    %rax,%rdi
  8017ce:	48 b8 46 35 80 00 00 	movabs $0x803546,%rax
  8017d5:	00 00 00 
  8017d8:	ff d0                	callq  *%rax
  8017da:	39 c3                	cmp    %eax,%ebx
  8017dc:	0f 94 c0             	sete   %al
  8017df:	0f b6 c0             	movzbl %al,%eax
  8017e2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8017e5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017ec:	00 00 00 
  8017ef:	48 8b 00             	mov    (%rax),%rax
  8017f2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017f8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8017fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017fe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801801:	75 05                	jne    801808 <_pipeisclosed+0x7d>
			return ret;
  801803:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801806:	eb 4f                	jmp    801857 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801808:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80180b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80180e:	74 42                	je     801852 <_pipeisclosed+0xc7>
  801810:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801814:	75 3c                	jne    801852 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801816:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80181d:	00 00 00 
  801820:	48 8b 00             	mov    (%rax),%rax
  801823:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801829:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80182c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80182f:	89 c6                	mov    %eax,%esi
  801831:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  801838:	00 00 00 
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
  801840:	49 b8 4a 20 80 00 00 	movabs $0x80204a,%r8
  801847:	00 00 00 
  80184a:	41 ff d0             	callq  *%r8
	}
  80184d:	e9 4a ff ff ff       	jmpq   80179c <_pipeisclosed+0x11>
  801852:	e9 45 ff ff ff       	jmpq   80179c <_pipeisclosed+0x11>
}
  801857:	48 83 c4 28          	add    $0x28,%rsp
  80185b:	5b                   	pop    %rbx
  80185c:	5d                   	pop    %rbp
  80185d:	c3                   	retq   

000000000080185e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80185e:	55                   	push   %rbp
  80185f:	48 89 e5             	mov    %rsp,%rbp
  801862:	48 83 ec 30          	sub    $0x30,%rsp
  801866:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801869:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80186d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801870:	48 89 d6             	mov    %rdx,%rsi
  801873:	89 c7                	mov    %eax,%edi
  801875:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  80187c:	00 00 00 
  80187f:	ff d0                	callq  *%rax
  801881:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801884:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801888:	79 05                	jns    80188f <pipeisclosed+0x31>
		return r;
  80188a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80188d:	eb 31                	jmp    8018c0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80188f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801893:	48 89 c7             	mov    %rax,%rdi
  801896:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  80189d:	00 00 00 
  8018a0:	ff d0                	callq  *%rax
  8018a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ae:	48 89 d6             	mov    %rdx,%rsi
  8018b1:	48 89 c7             	mov    %rax,%rdi
  8018b4:	48 b8 8b 17 80 00 00 	movabs $0x80178b,%rax
  8018bb:	00 00 00 
  8018be:	ff d0                	callq  *%rax
}
  8018c0:	c9                   	leaveq 
  8018c1:	c3                   	retq   

00000000008018c2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018c2:	55                   	push   %rbp
  8018c3:	48 89 e5             	mov    %rsp,%rbp
  8018c6:	48 83 ec 40          	sub    $0x40,%rsp
  8018ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018da:	48 89 c7             	mov    %rax,%rdi
  8018dd:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  8018e4:	00 00 00 
  8018e7:	ff d0                	callq  *%rax
  8018e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8018ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8018f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8018fc:	00 
  8018fd:	e9 92 00 00 00       	jmpq   801994 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801902:	eb 41                	jmp    801945 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801904:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801909:	74 09                	je     801914 <devpipe_read+0x52>
				return i;
  80190b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190f:	e9 92 00 00 00       	jmpq   8019a6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801914:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801918:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191c:	48 89 d6             	mov    %rdx,%rsi
  80191f:	48 89 c7             	mov    %rax,%rdi
  801922:	48 b8 8b 17 80 00 00 	movabs $0x80178b,%rax
  801929:	00 00 00 
  80192c:	ff d0                	callq  *%rax
  80192e:	85 c0                	test   %eax,%eax
  801930:	74 07                	je     801939 <devpipe_read+0x77>
				return 0;
  801932:	b8 00 00 00 00       	mov    $0x0,%eax
  801937:	eb 6d                	jmp    8019a6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801939:	48 b8 a1 02 80 00 00 	movabs $0x8002a1,%rax
  801940:	00 00 00 
  801943:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801945:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801949:	8b 10                	mov    (%rax),%edx
  80194b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194f:	8b 40 04             	mov    0x4(%rax),%eax
  801952:	39 c2                	cmp    %eax,%edx
  801954:	74 ae                	je     801904 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801956:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80195e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801962:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801966:	8b 00                	mov    (%rax),%eax
  801968:	99                   	cltd   
  801969:	c1 ea 1b             	shr    $0x1b,%edx
  80196c:	01 d0                	add    %edx,%eax
  80196e:	83 e0 1f             	and    $0x1f,%eax
  801971:	29 d0                	sub    %edx,%eax
  801973:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801977:	48 98                	cltq   
  801979:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80197e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801980:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801984:	8b 00                	mov    (%rax),%eax
  801986:	8d 50 01             	lea    0x1(%rax),%edx
  801989:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80198f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801994:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801998:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80199c:	0f 82 60 ff ff ff    	jb     801902 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019a6:	c9                   	leaveq 
  8019a7:	c3                   	retq   

00000000008019a8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019a8:	55                   	push   %rbp
  8019a9:	48 89 e5             	mov    %rsp,%rbp
  8019ac:	48 83 ec 40          	sub    $0x40,%rsp
  8019b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019b8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c0:	48 89 c7             	mov    %rax,%rdi
  8019c3:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  8019ca:	00 00 00 
  8019cd:	ff d0                	callq  *%rax
  8019cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019db:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019e2:	00 
  8019e3:	e9 8e 00 00 00       	jmpq   801a76 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019e8:	eb 31                	jmp    801a1b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f2:	48 89 d6             	mov    %rdx,%rsi
  8019f5:	48 89 c7             	mov    %rax,%rdi
  8019f8:	48 b8 8b 17 80 00 00 	movabs $0x80178b,%rax
  8019ff:	00 00 00 
  801a02:	ff d0                	callq  *%rax
  801a04:	85 c0                	test   %eax,%eax
  801a06:	74 07                	je     801a0f <devpipe_write+0x67>
				return 0;
  801a08:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0d:	eb 79                	jmp    801a88 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a0f:	48 b8 a1 02 80 00 00 	movabs $0x8002a1,%rax
  801a16:	00 00 00 
  801a19:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a1f:	8b 40 04             	mov    0x4(%rax),%eax
  801a22:	48 63 d0             	movslq %eax,%rdx
  801a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a29:	8b 00                	mov    (%rax),%eax
  801a2b:	48 98                	cltq   
  801a2d:	48 83 c0 20          	add    $0x20,%rax
  801a31:	48 39 c2             	cmp    %rax,%rdx
  801a34:	73 b4                	jae    8019ea <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a3a:	8b 40 04             	mov    0x4(%rax),%eax
  801a3d:	99                   	cltd   
  801a3e:	c1 ea 1b             	shr    $0x1b,%edx
  801a41:	01 d0                	add    %edx,%eax
  801a43:	83 e0 1f             	and    $0x1f,%eax
  801a46:	29 d0                	sub    %edx,%eax
  801a48:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a4c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a50:	48 01 ca             	add    %rcx,%rdx
  801a53:	0f b6 0a             	movzbl (%rdx),%ecx
  801a56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5a:	48 98                	cltq   
  801a5c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a64:	8b 40 04             	mov    0x4(%rax),%eax
  801a67:	8d 50 01             	lea    0x1(%rax),%edx
  801a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a71:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a7e:	0f 82 64 ff ff ff    	jb     8019e8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a88:	c9                   	leaveq 
  801a89:	c3                   	retq   

0000000000801a8a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a8a:	55                   	push   %rbp
  801a8b:	48 89 e5             	mov    %rsp,%rbp
  801a8e:	48 83 ec 20          	sub    $0x20,%rsp
  801a92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a9e:	48 89 c7             	mov    %rax,%rdi
  801aa1:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  801aa8:	00 00 00 
  801aab:	ff d0                	callq  *%rax
  801aad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801ab1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ab5:	48 be 6e 37 80 00 00 	movabs $0x80376e,%rsi
  801abc:	00 00 00 
  801abf:	48 89 c7             	mov    %rax,%rdi
  801ac2:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801ace:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad2:	8b 50 04             	mov    0x4(%rax),%edx
  801ad5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad9:	8b 00                	mov    (%rax),%eax
  801adb:	29 c2                	sub    %eax,%edx
  801add:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ae1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801ae7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aeb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801af2:	00 00 00 
	stat->st_dev = &devpipe;
  801af5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af9:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b00:	00 00 00 
  801b03:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 10          	sub    $0x10,%rsp
  801b19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b21:	48 89 c6             	mov    %rax,%rsi
  801b24:	bf 00 00 00 00       	mov    $0x0,%edi
  801b29:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b39:	48 89 c7             	mov    %rax,%rdi
  801b3c:	48 b8 6f 05 80 00 00 	movabs $0x80056f,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	callq  *%rax
  801b48:	48 89 c6             	mov    %rax,%rsi
  801b4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b50:	48 b8 8a 03 80 00 00 	movabs $0x80038a,%rax
  801b57:	00 00 00 
  801b5a:	ff d0                	callq  *%rax
}
  801b5c:	c9                   	leaveq 
  801b5d:	c3                   	retq   

0000000000801b5e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b5e:	55                   	push   %rbp
  801b5f:	48 89 e5             	mov    %rsp,%rbp
  801b62:	48 83 ec 20          	sub    $0x20,%rsp
  801b66:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b6c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b6f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b73:	be 01 00 00 00       	mov    $0x1,%esi
  801b78:	48 89 c7             	mov    %rax,%rdi
  801b7b:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  801b82:	00 00 00 
  801b85:	ff d0                	callq  *%rax
}
  801b87:	c9                   	leaveq 
  801b88:	c3                   	retq   

0000000000801b89 <getchar>:

int
getchar(void)
{
  801b89:	55                   	push   %rbp
  801b8a:	48 89 e5             	mov    %rsp,%rbp
  801b8d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801b91:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801b95:	ba 01 00 00 00       	mov    $0x1,%edx
  801b9a:	48 89 c6             	mov    %rax,%rsi
  801b9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba2:	48 b8 64 0a 80 00 00 	movabs $0x800a64,%rax
  801ba9:	00 00 00 
  801bac:	ff d0                	callq  *%rax
  801bae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb5:	79 05                	jns    801bbc <getchar+0x33>
		return r;
  801bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bba:	eb 14                	jmp    801bd0 <getchar+0x47>
	if (r < 1)
  801bbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bc0:	7f 07                	jg     801bc9 <getchar+0x40>
		return -E_EOF;
  801bc2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801bc7:	eb 07                	jmp    801bd0 <getchar+0x47>
	return c;
  801bc9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801bcd:	0f b6 c0             	movzbl %al,%eax
}
  801bd0:	c9                   	leaveq 
  801bd1:	c3                   	retq   

0000000000801bd2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bd2:	55                   	push   %rbp
  801bd3:	48 89 e5             	mov    %rsp,%rbp
  801bd6:	48 83 ec 20          	sub    $0x20,%rsp
  801bda:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bdd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801be1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801be4:	48 89 d6             	mov    %rdx,%rsi
  801be7:	89 c7                	mov    %eax,%edi
  801be9:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	callq  *%rax
  801bf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bfc:	79 05                	jns    801c03 <iscons+0x31>
		return r;
  801bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c01:	eb 1a                	jmp    801c1d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c07:	8b 10                	mov    (%rax),%edx
  801c09:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c10:	00 00 00 
  801c13:	8b 00                	mov    (%rax),%eax
  801c15:	39 c2                	cmp    %eax,%edx
  801c17:	0f 94 c0             	sete   %al
  801c1a:	0f b6 c0             	movzbl %al,%eax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   

0000000000801c1f <opencons>:

int
opencons(void)
{
  801c1f:	55                   	push   %rbp
  801c20:	48 89 e5             	mov    %rsp,%rbp
  801c23:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c27:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c2b:	48 89 c7             	mov    %rax,%rdi
  801c2e:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
  801c3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c41:	79 05                	jns    801c48 <opencons+0x29>
		return r;
  801c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c46:	eb 5b                	jmp    801ca3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4c:	ba 07 04 00 00       	mov    $0x407,%edx
  801c51:	48 89 c6             	mov    %rax,%rsi
  801c54:	bf 00 00 00 00       	mov    $0x0,%edi
  801c59:	48 b8 df 02 80 00 00 	movabs $0x8002df,%rax
  801c60:	00 00 00 
  801c63:	ff d0                	callq  *%rax
  801c65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c6c:	79 05                	jns    801c73 <opencons+0x54>
		return r;
  801c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c71:	eb 30                	jmp    801ca3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c77:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c7e:	00 00 00 
  801c81:	8b 12                	mov    (%rdx),%edx
  801c83:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c89:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c94:	48 89 c7             	mov    %rax,%rdi
  801c97:	48 b8 4c 05 80 00 00 	movabs $0x80054c,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
}
  801ca3:	c9                   	leaveq 
  801ca4:	c3                   	retq   

0000000000801ca5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	48 83 ec 30          	sub    $0x30,%rsp
  801cad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cb5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cb9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cbe:	75 07                	jne    801cc7 <devcons_read+0x22>
		return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc5:	eb 4b                	jmp    801d12 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801cc7:	eb 0c                	jmp    801cd5 <devcons_read+0x30>
		sys_yield();
  801cc9:	48 b8 a1 02 80 00 00 	movabs $0x8002a1,%rax
  801cd0:	00 00 00 
  801cd3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cd5:	48 b8 e1 01 80 00 00 	movabs $0x8001e1,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
  801ce1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce8:	74 df                	je     801cc9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801cea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cee:	79 05                	jns    801cf5 <devcons_read+0x50>
		return c;
  801cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf3:	eb 1d                	jmp    801d12 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801cf5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801cf9:	75 07                	jne    801d02 <devcons_read+0x5d>
		return 0;
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801d00:	eb 10                	jmp    801d12 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d05:	89 c2                	mov    %eax,%edx
  801d07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d0b:	88 10                	mov    %dl,(%rax)
	return 1;
  801d0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d12:	c9                   	leaveq 
  801d13:	c3                   	retq   

0000000000801d14 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d14:	55                   	push   %rbp
  801d15:	48 89 e5             	mov    %rsp,%rbp
  801d18:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d1f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d26:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d2d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d3b:	eb 76                	jmp    801db3 <devcons_write+0x9f>
		m = n - tot;
  801d3d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d44:	89 c2                	mov    %eax,%edx
  801d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d49:	29 c2                	sub    %eax,%edx
  801d4b:	89 d0                	mov    %edx,%eax
  801d4d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d53:	83 f8 7f             	cmp    $0x7f,%eax
  801d56:	76 07                	jbe    801d5f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d58:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d62:	48 63 d0             	movslq %eax,%rdx
  801d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d68:	48 63 c8             	movslq %eax,%rcx
  801d6b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d72:	48 01 c1             	add    %rax,%rcx
  801d75:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d7c:	48 89 ce             	mov    %rcx,%rsi
  801d7f:	48 89 c7             	mov    %rax,%rdi
  801d82:	48 b8 36 2f 80 00 00 	movabs $0x802f36,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801d8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d91:	48 63 d0             	movslq %eax,%rdx
  801d94:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d9b:	48 89 d6             	mov    %rdx,%rsi
  801d9e:	48 89 c7             	mov    %rax,%rdi
  801da1:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db0:	01 45 fc             	add    %eax,-0x4(%rbp)
  801db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db6:	48 98                	cltq   
  801db8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dbf:	0f 82 78 ff ff ff    	jb     801d3d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801dc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dc8:	c9                   	leaveq 
  801dc9:	c3                   	retq   

0000000000801dca <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	48 83 ec 08          	sub    $0x8,%rsp
  801dd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddb:	c9                   	leaveq 
  801ddc:	c3                   	retq   

0000000000801ddd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ddd:	55                   	push   %rbp
  801dde:	48 89 e5             	mov    %rsp,%rbp
  801de1:	48 83 ec 10          	sub    $0x10,%rsp
  801de5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801de9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801ded:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df1:	48 be 7a 37 80 00 00 	movabs $0x80377a,%rsi
  801df8:	00 00 00 
  801dfb:	48 89 c7             	mov    %rax,%rdi
  801dfe:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	callq  *%rax
	return 0;
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0f:	c9                   	leaveq 
  801e10:	c3                   	retq   

0000000000801e11 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e11:	55                   	push   %rbp
  801e12:	48 89 e5             	mov    %rsp,%rbp
  801e15:	53                   	push   %rbx
  801e16:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e1d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e24:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e2a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e31:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e38:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e3f:	84 c0                	test   %al,%al
  801e41:	74 23                	je     801e66 <_panic+0x55>
  801e43:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e4a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e4e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e52:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e56:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e5a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e5e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e62:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e66:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e6d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e74:	00 00 00 
  801e77:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e7e:	00 00 00 
  801e81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e85:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801e8c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801e93:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e9a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801ea1:	00 00 00 
  801ea4:	48 8b 18             	mov    (%rax),%rbx
  801ea7:	48 b8 63 02 80 00 00 	movabs $0x800263,%rax
  801eae:	00 00 00 
  801eb1:	ff d0                	callq  *%rax
  801eb3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801eb9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ec0:	41 89 c8             	mov    %ecx,%r8d
  801ec3:	48 89 d1             	mov    %rdx,%rcx
  801ec6:	48 89 da             	mov    %rbx,%rdx
  801ec9:	89 c6                	mov    %eax,%esi
  801ecb:	48 bf 88 37 80 00 00 	movabs $0x803788,%rdi
  801ed2:	00 00 00 
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	49 b9 4a 20 80 00 00 	movabs $0x80204a,%r9
  801ee1:	00 00 00 
  801ee4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ee7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801eee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801ef5:	48 89 d6             	mov    %rdx,%rsi
  801ef8:	48 89 c7             	mov    %rax,%rdi
  801efb:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  801f02:	00 00 00 
  801f05:	ff d0                	callq  *%rax
	cprintf("\n");
  801f07:	48 bf ab 37 80 00 00 	movabs $0x8037ab,%rdi
  801f0e:	00 00 00 
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	48 ba 4a 20 80 00 00 	movabs $0x80204a,%rdx
  801f1d:	00 00 00 
  801f20:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f22:	cc                   	int3   
  801f23:	eb fd                	jmp    801f22 <_panic+0x111>

0000000000801f25 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f25:	55                   	push   %rbp
  801f26:	48 89 e5             	mov    %rsp,%rbp
  801f29:	48 83 ec 10          	sub    $0x10,%rsp
  801f2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f38:	8b 00                	mov    (%rax),%eax
  801f3a:	8d 48 01             	lea    0x1(%rax),%ecx
  801f3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f41:	89 0a                	mov    %ecx,(%rdx)
  801f43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f46:	89 d1                	mov    %edx,%ecx
  801f48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4c:	48 98                	cltq   
  801f4e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f56:	8b 00                	mov    (%rax),%eax
  801f58:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f5d:	75 2c                	jne    801f8b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f63:	8b 00                	mov    (%rax),%eax
  801f65:	48 98                	cltq   
  801f67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6b:	48 83 c2 08          	add    $0x8,%rdx
  801f6f:	48 89 c6             	mov    %rax,%rsi
  801f72:	48 89 d7             	mov    %rdx,%rdi
  801f75:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  801f7c:	00 00 00 
  801f7f:	ff d0                	callq  *%rax
        b->idx = 0;
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8f:	8b 40 04             	mov    0x4(%rax),%eax
  801f92:	8d 50 01             	lea    0x1(%rax),%edx
  801f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f99:	89 50 04             	mov    %edx,0x4(%rax)
}
  801f9c:	c9                   	leaveq 
  801f9d:	c3                   	retq   

0000000000801f9e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801f9e:	55                   	push   %rbp
  801f9f:	48 89 e5             	mov    %rsp,%rbp
  801fa2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fa9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fb0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fb7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fbe:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fc5:	48 8b 0a             	mov    (%rdx),%rcx
  801fc8:	48 89 08             	mov    %rcx,(%rax)
  801fcb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fcf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fd3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801fd7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801fdb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801fe2:	00 00 00 
    b.cnt = 0;
  801fe5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801fec:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801fef:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801ff6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801ffd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802004:	48 89 c6             	mov    %rax,%rsi
  802007:	48 bf 25 1f 80 00 00 	movabs $0x801f25,%rdi
  80200e:	00 00 00 
  802011:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80201d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802023:	48 98                	cltq   
  802025:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80202c:	48 83 c2 08          	add    $0x8,%rdx
  802030:	48 89 c6             	mov    %rax,%rsi
  802033:	48 89 d7             	mov    %rdx,%rdi
  802036:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802042:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802048:	c9                   	leaveq 
  802049:	c3                   	retq   

000000000080204a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80204a:	55                   	push   %rbp
  80204b:	48 89 e5             	mov    %rsp,%rbp
  80204e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802055:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80205c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802063:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80206a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802071:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802078:	84 c0                	test   %al,%al
  80207a:	74 20                	je     80209c <cprintf+0x52>
  80207c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802080:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802084:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802088:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80208c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802090:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802094:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802098:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80209c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020a3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020aa:	00 00 00 
  8020ad:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020b4:	00 00 00 
  8020b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020bb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020c9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020d0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020de:	48 8b 0a             	mov    (%rdx),%rcx
  8020e1:	48 89 08             	mov    %rcx,(%rax)
  8020e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8020e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8020ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8020f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8020f4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8020fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802102:	48 89 d6             	mov    %rdx,%rsi
  802105:	48 89 c7             	mov    %rax,%rdi
  802108:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  80210f:	00 00 00 
  802112:	ff d0                	callq  *%rax
  802114:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80211a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802120:	c9                   	leaveq 
  802121:	c3                   	retq   

0000000000802122 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802122:	55                   	push   %rbp
  802123:	48 89 e5             	mov    %rsp,%rbp
  802126:	53                   	push   %rbx
  802127:	48 83 ec 38          	sub    $0x38,%rsp
  80212b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80212f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802133:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802137:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80213a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80213e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802142:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802145:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802149:	77 3b                	ja     802186 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80214b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80214e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802152:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802159:	ba 00 00 00 00       	mov    $0x0,%edx
  80215e:	48 f7 f3             	div    %rbx
  802161:	48 89 c2             	mov    %rax,%rdx
  802164:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802167:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80216a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	41 89 f9             	mov    %edi,%r9d
  802175:	48 89 c7             	mov    %rax,%rdi
  802178:	48 b8 22 21 80 00 00 	movabs $0x802122,%rax
  80217f:	00 00 00 
  802182:	ff d0                	callq  *%rax
  802184:	eb 1e                	jmp    8021a4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802186:	eb 12                	jmp    80219a <printnum+0x78>
			putch(padc, putdat);
  802188:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80218c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80218f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802193:	48 89 ce             	mov    %rcx,%rsi
  802196:	89 d7                	mov    %edx,%edi
  802198:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80219a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80219e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021a2:	7f e4                	jg     802188 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b0:	48 f7 f1             	div    %rcx
  8021b3:	48 89 d0             	mov    %rdx,%rax
  8021b6:	48 ba b0 39 80 00 00 	movabs $0x8039b0,%rdx
  8021bd:	00 00 00 
  8021c0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021c4:	0f be d0             	movsbl %al,%edx
  8021c7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cf:	48 89 ce             	mov    %rcx,%rsi
  8021d2:	89 d7                	mov    %edx,%edi
  8021d4:	ff d0                	callq  *%rax
}
  8021d6:	48 83 c4 38          	add    $0x38,%rsp
  8021da:	5b                   	pop    %rbx
  8021db:	5d                   	pop    %rbp
  8021dc:	c3                   	retq   

00000000008021dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021dd:	55                   	push   %rbp
  8021de:	48 89 e5             	mov    %rsp,%rbp
  8021e1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8021e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8021ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8021f0:	7e 52                	jle    802244 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8021f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f6:	8b 00                	mov    (%rax),%eax
  8021f8:	83 f8 30             	cmp    $0x30,%eax
  8021fb:	73 24                	jae    802221 <getuint+0x44>
  8021fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802201:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802209:	8b 00                	mov    (%rax),%eax
  80220b:	89 c0                	mov    %eax,%eax
  80220d:	48 01 d0             	add    %rdx,%rax
  802210:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802214:	8b 12                	mov    (%rdx),%edx
  802216:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802219:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80221d:	89 0a                	mov    %ecx,(%rdx)
  80221f:	eb 17                	jmp    802238 <getuint+0x5b>
  802221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802225:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802229:	48 89 d0             	mov    %rdx,%rax
  80222c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802230:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802234:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802238:	48 8b 00             	mov    (%rax),%rax
  80223b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80223f:	e9 a3 00 00 00       	jmpq   8022e7 <getuint+0x10a>
	else if (lflag)
  802244:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802248:	74 4f                	je     802299 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80224a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224e:	8b 00                	mov    (%rax),%eax
  802250:	83 f8 30             	cmp    $0x30,%eax
  802253:	73 24                	jae    802279 <getuint+0x9c>
  802255:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802259:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80225d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802261:	8b 00                	mov    (%rax),%eax
  802263:	89 c0                	mov    %eax,%eax
  802265:	48 01 d0             	add    %rdx,%rax
  802268:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80226c:	8b 12                	mov    (%rdx),%edx
  80226e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802271:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802275:	89 0a                	mov    %ecx,(%rdx)
  802277:	eb 17                	jmp    802290 <getuint+0xb3>
  802279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802281:	48 89 d0             	mov    %rdx,%rax
  802284:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802288:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80228c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802290:	48 8b 00             	mov    (%rax),%rax
  802293:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802297:	eb 4e                	jmp    8022e7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229d:	8b 00                	mov    (%rax),%eax
  80229f:	83 f8 30             	cmp    $0x30,%eax
  8022a2:	73 24                	jae    8022c8 <getuint+0xeb>
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b0:	8b 00                	mov    (%rax),%eax
  8022b2:	89 c0                	mov    %eax,%eax
  8022b4:	48 01 d0             	add    %rdx,%rax
  8022b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022bb:	8b 12                	mov    (%rdx),%edx
  8022bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c4:	89 0a                	mov    %ecx,(%rdx)
  8022c6:	eb 17                	jmp    8022df <getuint+0x102>
  8022c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022d0:	48 89 d0             	mov    %rdx,%rax
  8022d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022df:	8b 00                	mov    (%rax),%eax
  8022e1:	89 c0                	mov    %eax,%eax
  8022e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8022e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022eb:	c9                   	leaveq 
  8022ec:	c3                   	retq   

00000000008022ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8022ed:	55                   	push   %rbp
  8022ee:	48 89 e5             	mov    %rsp,%rbp
  8022f1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8022f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8022fc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802300:	7e 52                	jle    802354 <getint+0x67>
		x=va_arg(*ap, long long);
  802302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802306:	8b 00                	mov    (%rax),%eax
  802308:	83 f8 30             	cmp    $0x30,%eax
  80230b:	73 24                	jae    802331 <getint+0x44>
  80230d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802311:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802319:	8b 00                	mov    (%rax),%eax
  80231b:	89 c0                	mov    %eax,%eax
  80231d:	48 01 d0             	add    %rdx,%rax
  802320:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802324:	8b 12                	mov    (%rdx),%edx
  802326:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802329:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80232d:	89 0a                	mov    %ecx,(%rdx)
  80232f:	eb 17                	jmp    802348 <getint+0x5b>
  802331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802335:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802339:	48 89 d0             	mov    %rdx,%rax
  80233c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802340:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802344:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802348:	48 8b 00             	mov    (%rax),%rax
  80234b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80234f:	e9 a3 00 00 00       	jmpq   8023f7 <getint+0x10a>
	else if (lflag)
  802354:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802358:	74 4f                	je     8023a9 <getint+0xbc>
		x=va_arg(*ap, long);
  80235a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235e:	8b 00                	mov    (%rax),%eax
  802360:	83 f8 30             	cmp    $0x30,%eax
  802363:	73 24                	jae    802389 <getint+0x9c>
  802365:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802369:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80236d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802371:	8b 00                	mov    (%rax),%eax
  802373:	89 c0                	mov    %eax,%eax
  802375:	48 01 d0             	add    %rdx,%rax
  802378:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80237c:	8b 12                	mov    (%rdx),%edx
  80237e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802381:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802385:	89 0a                	mov    %ecx,(%rdx)
  802387:	eb 17                	jmp    8023a0 <getint+0xb3>
  802389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802391:	48 89 d0             	mov    %rdx,%rax
  802394:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802398:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023a0:	48 8b 00             	mov    (%rax),%rax
  8023a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023a7:	eb 4e                	jmp    8023f7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ad:	8b 00                	mov    (%rax),%eax
  8023af:	83 f8 30             	cmp    $0x30,%eax
  8023b2:	73 24                	jae    8023d8 <getint+0xeb>
  8023b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c0:	8b 00                	mov    (%rax),%eax
  8023c2:	89 c0                	mov    %eax,%eax
  8023c4:	48 01 d0             	add    %rdx,%rax
  8023c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023cb:	8b 12                	mov    (%rdx),%edx
  8023cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d4:	89 0a                	mov    %ecx,(%rdx)
  8023d6:	eb 17                	jmp    8023ef <getint+0x102>
  8023d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023e0:	48 89 d0             	mov    %rdx,%rax
  8023e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023ef:	8b 00                	mov    (%rax),%eax
  8023f1:	48 98                	cltq   
  8023f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8023f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023fb:	c9                   	leaveq 
  8023fc:	c3                   	retq   

00000000008023fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8023fd:	55                   	push   %rbp
  8023fe:	48 89 e5             	mov    %rsp,%rbp
  802401:	41 54                	push   %r12
  802403:	53                   	push   %rbx
  802404:	48 83 ec 60          	sub    $0x60,%rsp
  802408:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80240c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802410:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802414:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802418:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80241c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802420:	48 8b 0a             	mov    (%rdx),%rcx
  802423:	48 89 08             	mov    %rcx,(%rax)
  802426:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80242a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80242e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802432:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802436:	eb 17                	jmp    80244f <vprintfmt+0x52>
			if (ch == '\0')
  802438:	85 db                	test   %ebx,%ebx
  80243a:	0f 84 df 04 00 00    	je     80291f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  802440:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802444:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802448:	48 89 d6             	mov    %rdx,%rsi
  80244b:	89 df                	mov    %ebx,%edi
  80244d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80244f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802453:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802457:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80245b:	0f b6 00             	movzbl (%rax),%eax
  80245e:	0f b6 d8             	movzbl %al,%ebx
  802461:	83 fb 25             	cmp    $0x25,%ebx
  802464:	75 d2                	jne    802438 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802466:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80246a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802471:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802478:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80247f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802486:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80248a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80248e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802492:	0f b6 00             	movzbl (%rax),%eax
  802495:	0f b6 d8             	movzbl %al,%ebx
  802498:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80249b:	83 f8 55             	cmp    $0x55,%eax
  80249e:	0f 87 47 04 00 00    	ja     8028eb <vprintfmt+0x4ee>
  8024a4:	89 c0                	mov    %eax,%eax
  8024a6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024ad:	00 
  8024ae:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  8024b5:	00 00 00 
  8024b8:	48 01 d0             	add    %rdx,%rax
  8024bb:	48 8b 00             	mov    (%rax),%rax
  8024be:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024c0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024c4:	eb c0                	jmp    802486 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024c6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024ca:	eb ba                	jmp    802486 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024cc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024d3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024d6:	89 d0                	mov    %edx,%eax
  8024d8:	c1 e0 02             	shl    $0x2,%eax
  8024db:	01 d0                	add    %edx,%eax
  8024dd:	01 c0                	add    %eax,%eax
  8024df:	01 d8                	add    %ebx,%eax
  8024e1:	83 e8 30             	sub    $0x30,%eax
  8024e4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8024e7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024eb:	0f b6 00             	movzbl (%rax),%eax
  8024ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8024f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8024f4:	7e 0c                	jle    802502 <vprintfmt+0x105>
  8024f6:	83 fb 39             	cmp    $0x39,%ebx
  8024f9:	7f 07                	jg     802502 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024fb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802500:	eb d1                	jmp    8024d3 <vprintfmt+0xd6>
			goto process_precision;
  802502:	eb 58                	jmp    80255c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802504:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802507:	83 f8 30             	cmp    $0x30,%eax
  80250a:	73 17                	jae    802523 <vprintfmt+0x126>
  80250c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802510:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802513:	89 c0                	mov    %eax,%eax
  802515:	48 01 d0             	add    %rdx,%rax
  802518:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80251b:	83 c2 08             	add    $0x8,%edx
  80251e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802521:	eb 0f                	jmp    802532 <vprintfmt+0x135>
  802523:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802527:	48 89 d0             	mov    %rdx,%rax
  80252a:	48 83 c2 08          	add    $0x8,%rdx
  80252e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802532:	8b 00                	mov    (%rax),%eax
  802534:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802537:	eb 23                	jmp    80255c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802539:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80253d:	79 0c                	jns    80254b <vprintfmt+0x14e>
				width = 0;
  80253f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802546:	e9 3b ff ff ff       	jmpq   802486 <vprintfmt+0x89>
  80254b:	e9 36 ff ff ff       	jmpq   802486 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802550:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802557:	e9 2a ff ff ff       	jmpq   802486 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80255c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802560:	79 12                	jns    802574 <vprintfmt+0x177>
				width = precision, precision = -1;
  802562:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802565:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802568:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80256f:	e9 12 ff ff ff       	jmpq   802486 <vprintfmt+0x89>
  802574:	e9 0d ff ff ff       	jmpq   802486 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802579:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80257d:	e9 04 ff ff ff       	jmpq   802486 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802582:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802585:	83 f8 30             	cmp    $0x30,%eax
  802588:	73 17                	jae    8025a1 <vprintfmt+0x1a4>
  80258a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80258e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802591:	89 c0                	mov    %eax,%eax
  802593:	48 01 d0             	add    %rdx,%rax
  802596:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802599:	83 c2 08             	add    $0x8,%edx
  80259c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80259f:	eb 0f                	jmp    8025b0 <vprintfmt+0x1b3>
  8025a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025a5:	48 89 d0             	mov    %rdx,%rax
  8025a8:	48 83 c2 08          	add    $0x8,%rdx
  8025ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025b0:	8b 10                	mov    (%rax),%edx
  8025b2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025ba:	48 89 ce             	mov    %rcx,%rsi
  8025bd:	89 d7                	mov    %edx,%edi
  8025bf:	ff d0                	callq  *%rax
			break;
  8025c1:	e9 53 03 00 00       	jmpq   802919 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025c9:	83 f8 30             	cmp    $0x30,%eax
  8025cc:	73 17                	jae    8025e5 <vprintfmt+0x1e8>
  8025ce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025d5:	89 c0                	mov    %eax,%eax
  8025d7:	48 01 d0             	add    %rdx,%rax
  8025da:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025dd:	83 c2 08             	add    $0x8,%edx
  8025e0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025e3:	eb 0f                	jmp    8025f4 <vprintfmt+0x1f7>
  8025e5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025e9:	48 89 d0             	mov    %rdx,%rax
  8025ec:	48 83 c2 08          	add    $0x8,%rdx
  8025f0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025f4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8025f6:	85 db                	test   %ebx,%ebx
  8025f8:	79 02                	jns    8025fc <vprintfmt+0x1ff>
				err = -err;
  8025fa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8025fc:	83 fb 15             	cmp    $0x15,%ebx
  8025ff:	7f 16                	jg     802617 <vprintfmt+0x21a>
  802601:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  802608:	00 00 00 
  80260b:	48 63 d3             	movslq %ebx,%rdx
  80260e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802612:	4d 85 e4             	test   %r12,%r12
  802615:	75 2e                	jne    802645 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802617:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80261b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80261f:	89 d9                	mov    %ebx,%ecx
  802621:	48 ba c1 39 80 00 00 	movabs $0x8039c1,%rdx
  802628:	00 00 00 
  80262b:	48 89 c7             	mov    %rax,%rdi
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	49 b8 28 29 80 00 00 	movabs $0x802928,%r8
  80263a:	00 00 00 
  80263d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802640:	e9 d4 02 00 00       	jmpq   802919 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802645:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802649:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80264d:	4c 89 e1             	mov    %r12,%rcx
  802650:	48 ba ca 39 80 00 00 	movabs $0x8039ca,%rdx
  802657:	00 00 00 
  80265a:	48 89 c7             	mov    %rax,%rdi
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	49 b8 28 29 80 00 00 	movabs $0x802928,%r8
  802669:	00 00 00 
  80266c:	41 ff d0             	callq  *%r8
			break;
  80266f:	e9 a5 02 00 00       	jmpq   802919 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802674:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802677:	83 f8 30             	cmp    $0x30,%eax
  80267a:	73 17                	jae    802693 <vprintfmt+0x296>
  80267c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802680:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802683:	89 c0                	mov    %eax,%eax
  802685:	48 01 d0             	add    %rdx,%rax
  802688:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80268b:	83 c2 08             	add    $0x8,%edx
  80268e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802691:	eb 0f                	jmp    8026a2 <vprintfmt+0x2a5>
  802693:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802697:	48 89 d0             	mov    %rdx,%rax
  80269a:	48 83 c2 08          	add    $0x8,%rdx
  80269e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026a2:	4c 8b 20             	mov    (%rax),%r12
  8026a5:	4d 85 e4             	test   %r12,%r12
  8026a8:	75 0a                	jne    8026b4 <vprintfmt+0x2b7>
				p = "(null)";
  8026aa:	49 bc cd 39 80 00 00 	movabs $0x8039cd,%r12
  8026b1:	00 00 00 
			if (width > 0 && padc != '-')
  8026b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026b8:	7e 3f                	jle    8026f9 <vprintfmt+0x2fc>
  8026ba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026be:	74 39                	je     8026f9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026c0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026c3:	48 98                	cltq   
  8026c5:	48 89 c6             	mov    %rax,%rsi
  8026c8:	4c 89 e7             	mov    %r12,%rdi
  8026cb:	48 b8 d4 2b 80 00 00 	movabs $0x802bd4,%rax
  8026d2:	00 00 00 
  8026d5:	ff d0                	callq  *%rax
  8026d7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026da:	eb 17                	jmp    8026f3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026dc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8026e0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8026e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026e8:	48 89 ce             	mov    %rcx,%rsi
  8026eb:	89 d7                	mov    %edx,%edi
  8026ed:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8026ef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026f7:	7f e3                	jg     8026dc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026f9:	eb 37                	jmp    802732 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8026fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8026ff:	74 1e                	je     80271f <vprintfmt+0x322>
  802701:	83 fb 1f             	cmp    $0x1f,%ebx
  802704:	7e 05                	jle    80270b <vprintfmt+0x30e>
  802706:	83 fb 7e             	cmp    $0x7e,%ebx
  802709:	7e 14                	jle    80271f <vprintfmt+0x322>
					putch('?', putdat);
  80270b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80270f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802713:	48 89 d6             	mov    %rdx,%rsi
  802716:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80271b:	ff d0                	callq  *%rax
  80271d:	eb 0f                	jmp    80272e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80271f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802723:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802727:	48 89 d6             	mov    %rdx,%rsi
  80272a:	89 df                	mov    %ebx,%edi
  80272c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80272e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802732:	4c 89 e0             	mov    %r12,%rax
  802735:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802739:	0f b6 00             	movzbl (%rax),%eax
  80273c:	0f be d8             	movsbl %al,%ebx
  80273f:	85 db                	test   %ebx,%ebx
  802741:	74 10                	je     802753 <vprintfmt+0x356>
  802743:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802747:	78 b2                	js     8026fb <vprintfmt+0x2fe>
  802749:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80274d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802751:	79 a8                	jns    8026fb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802753:	eb 16                	jmp    80276b <vprintfmt+0x36e>
				putch(' ', putdat);
  802755:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802759:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80275d:	48 89 d6             	mov    %rdx,%rsi
  802760:	bf 20 00 00 00       	mov    $0x20,%edi
  802765:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802767:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80276b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80276f:	7f e4                	jg     802755 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802771:	e9 a3 01 00 00       	jmpq   802919 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802776:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80277a:	be 03 00 00 00       	mov    $0x3,%esi
  80277f:	48 89 c7             	mov    %rax,%rdi
  802782:	48 b8 ed 22 80 00 00 	movabs $0x8022ed,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
  80278e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802796:	48 85 c0             	test   %rax,%rax
  802799:	79 1d                	jns    8027b8 <vprintfmt+0x3bb>
				putch('-', putdat);
  80279b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80279f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027a3:	48 89 d6             	mov    %rdx,%rsi
  8027a6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027ab:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b1:	48 f7 d8             	neg    %rax
  8027b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027b8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027bf:	e9 e8 00 00 00       	jmpq   8028ac <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027c8:	be 03 00 00 00       	mov    $0x3,%esi
  8027cd:	48 89 c7             	mov    %rax,%rdi
  8027d0:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	callq  *%rax
  8027dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8027e0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027e7:	e9 c0 00 00 00       	jmpq   8028ac <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8027ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027f4:	48 89 d6             	mov    %rdx,%rsi
  8027f7:	bf 58 00 00 00       	mov    $0x58,%edi
  8027fc:	ff d0                	callq  *%rax
			putch('X', putdat);
  8027fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802802:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802806:	48 89 d6             	mov    %rdx,%rsi
  802809:	bf 58 00 00 00       	mov    $0x58,%edi
  80280e:	ff d0                	callq  *%rax
			putch('X', putdat);
  802810:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802814:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802818:	48 89 d6             	mov    %rdx,%rsi
  80281b:	bf 58 00 00 00       	mov    $0x58,%edi
  802820:	ff d0                	callq  *%rax
			break;
  802822:	e9 f2 00 00 00       	jmpq   802919 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802827:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80282b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80282f:	48 89 d6             	mov    %rdx,%rsi
  802832:	bf 30 00 00 00       	mov    $0x30,%edi
  802837:	ff d0                	callq  *%rax
			putch('x', putdat);
  802839:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80283d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802841:	48 89 d6             	mov    %rdx,%rsi
  802844:	bf 78 00 00 00       	mov    $0x78,%edi
  802849:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80284b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80284e:	83 f8 30             	cmp    $0x30,%eax
  802851:	73 17                	jae    80286a <vprintfmt+0x46d>
  802853:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802857:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80285a:	89 c0                	mov    %eax,%eax
  80285c:	48 01 d0             	add    %rdx,%rax
  80285f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802862:	83 c2 08             	add    $0x8,%edx
  802865:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802868:	eb 0f                	jmp    802879 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80286a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80286e:	48 89 d0             	mov    %rdx,%rax
  802871:	48 83 c2 08          	add    $0x8,%rdx
  802875:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802879:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80287c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802880:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802887:	eb 23                	jmp    8028ac <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802889:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80288d:	be 03 00 00 00       	mov    $0x3,%esi
  802892:	48 89 c7             	mov    %rax,%rdi
  802895:	48 b8 dd 21 80 00 00 	movabs $0x8021dd,%rax
  80289c:	00 00 00 
  80289f:	ff d0                	callq  *%rax
  8028a1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028a5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028ac:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028b1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028b4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028bb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028c3:	45 89 c1             	mov    %r8d,%r9d
  8028c6:	41 89 f8             	mov    %edi,%r8d
  8028c9:	48 89 c7             	mov    %rax,%rdi
  8028cc:	48 b8 22 21 80 00 00 	movabs $0x802122,%rax
  8028d3:	00 00 00 
  8028d6:	ff d0                	callq  *%rax
			break;
  8028d8:	eb 3f                	jmp    802919 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028e2:	48 89 d6             	mov    %rdx,%rsi
  8028e5:	89 df                	mov    %ebx,%edi
  8028e7:	ff d0                	callq  *%rax
			break;
  8028e9:	eb 2e                	jmp    802919 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8028eb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028f3:	48 89 d6             	mov    %rdx,%rsi
  8028f6:	bf 25 00 00 00       	mov    $0x25,%edi
  8028fb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8028fd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802902:	eb 05                	jmp    802909 <vprintfmt+0x50c>
  802904:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802909:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80290d:	48 83 e8 01          	sub    $0x1,%rax
  802911:	0f b6 00             	movzbl (%rax),%eax
  802914:	3c 25                	cmp    $0x25,%al
  802916:	75 ec                	jne    802904 <vprintfmt+0x507>
				/* do nothing */;
			break;
  802918:	90                   	nop
		}
	}
  802919:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80291a:	e9 30 fb ff ff       	jmpq   80244f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80291f:	48 83 c4 60          	add    $0x60,%rsp
  802923:	5b                   	pop    %rbx
  802924:	41 5c                	pop    %r12
  802926:	5d                   	pop    %rbp
  802927:	c3                   	retq   

0000000000802928 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802933:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80293a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802941:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802948:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80294f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802956:	84 c0                	test   %al,%al
  802958:	74 20                	je     80297a <printfmt+0x52>
  80295a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80295e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802962:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802966:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80296a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80296e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802972:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802976:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80297a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802981:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802988:	00 00 00 
  80298b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802992:	00 00 00 
  802995:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802999:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029a7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029ae:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029b5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029bc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029c3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029ca:	48 89 c7             	mov    %rax,%rdi
  8029cd:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029d9:	c9                   	leaveq 
  8029da:	c3                   	retq   

00000000008029db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029db:	55                   	push   %rbp
  8029dc:	48 89 e5             	mov    %rsp,%rbp
  8029df:	48 83 ec 10          	sub    $0x10,%rsp
  8029e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8029ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ee:	8b 40 10             	mov    0x10(%rax),%eax
  8029f1:	8d 50 01             	lea    0x1(%rax),%edx
  8029f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8029fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ff:	48 8b 10             	mov    (%rax),%rdx
  802a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a06:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a0a:	48 39 c2             	cmp    %rax,%rdx
  802a0d:	73 17                	jae    802a26 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a13:	48 8b 00             	mov    (%rax),%rax
  802a16:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a1e:	48 89 0a             	mov    %rcx,(%rdx)
  802a21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a24:	88 10                	mov    %dl,(%rax)
}
  802a26:	c9                   	leaveq 
  802a27:	c3                   	retq   

0000000000802a28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a28:	55                   	push   %rbp
  802a29:	48 89 e5             	mov    %rsp,%rbp
  802a2c:	48 83 ec 50          	sub    $0x50,%rsp
  802a30:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a34:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a37:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a3b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a3f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a43:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a47:	48 8b 0a             	mov    (%rdx),%rcx
  802a4a:	48 89 08             	mov    %rcx,(%rax)
  802a4d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a51:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a55:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a59:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a61:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a65:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a68:	48 98                	cltq   
  802a6a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a6e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a72:	48 01 d0             	add    %rdx,%rax
  802a75:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a80:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a85:	74 06                	je     802a8d <vsnprintf+0x65>
  802a87:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802a8b:	7f 07                	jg     802a94 <vsnprintf+0x6c>
		return -E_INVAL;
  802a8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a92:	eb 2f                	jmp    802ac3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802a94:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802a98:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a9c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802aa0:	48 89 c6             	mov    %rax,%rsi
  802aa3:	48 bf db 29 80 00 00 	movabs $0x8029db,%rdi
  802aaa:	00 00 00 
  802aad:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802ab9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802abd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802ac0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802ac3:	c9                   	leaveq 
  802ac4:	c3                   	retq   

0000000000802ac5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802ac5:	55                   	push   %rbp
  802ac6:	48 89 e5             	mov    %rsp,%rbp
  802ac9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802ad0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802ad7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802add:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ae4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802aeb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802af2:	84 c0                	test   %al,%al
  802af4:	74 20                	je     802b16 <snprintf+0x51>
  802af6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802afa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802afe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b02:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b06:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b0a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b0e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b12:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b16:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b1d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b24:	00 00 00 
  802b27:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b2e:	00 00 00 
  802b31:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b35:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b3c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b4a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b51:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b58:	48 8b 0a             	mov    (%rdx),%rcx
  802b5b:	48 89 08             	mov    %rcx,(%rax)
  802b5e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b62:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b66:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b6a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b6e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b75:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b7c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b82:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b89:	48 89 c7             	mov    %rax,%rdi
  802b8c:	48 b8 28 2a 80 00 00 	movabs $0x802a28,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
  802b98:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802b9e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 18          	sub    $0x18,%rsp
  802bae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bb9:	eb 09                	jmp    802bc4 <strlen+0x1e>
		n++;
  802bbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bbf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc8:	0f b6 00             	movzbl (%rax),%eax
  802bcb:	84 c0                	test   %al,%al
  802bcd:	75 ec                	jne    802bbb <strlen+0x15>
		n++;
	return n;
  802bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd2:	c9                   	leaveq 
  802bd3:	c3                   	retq   

0000000000802bd4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802bd4:	55                   	push   %rbp
  802bd5:	48 89 e5             	mov    %rsp,%rbp
  802bd8:	48 83 ec 20          	sub    $0x20,%rsp
  802bdc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802be4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802beb:	eb 0e                	jmp    802bfb <strnlen+0x27>
		n++;
  802bed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bf1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bf6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802bfb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c00:	74 0b                	je     802c0d <strnlen+0x39>
  802c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c06:	0f b6 00             	movzbl (%rax),%eax
  802c09:	84 c0                	test   %al,%al
  802c0b:	75 e0                	jne    802bed <strnlen+0x19>
		n++;
	return n;
  802c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c10:	c9                   	leaveq 
  802c11:	c3                   	retq   

0000000000802c12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c12:	55                   	push   %rbp
  802c13:	48 89 e5             	mov    %rsp,%rbp
  802c16:	48 83 ec 20          	sub    $0x20,%rsp
  802c1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c2a:	90                   	nop
  802c2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c37:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c3b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c3f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c43:	0f b6 12             	movzbl (%rdx),%edx
  802c46:	88 10                	mov    %dl,(%rax)
  802c48:	0f b6 00             	movzbl (%rax),%eax
  802c4b:	84 c0                	test   %al,%al
  802c4d:	75 dc                	jne    802c2b <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c53:	c9                   	leaveq 
  802c54:	c3                   	retq   

0000000000802c55 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c55:	55                   	push   %rbp
  802c56:	48 89 e5             	mov    %rsp,%rbp
  802c59:	48 83 ec 20          	sub    $0x20,%rsp
  802c5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c69:	48 89 c7             	mov    %rax,%rdi
  802c6c:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  802c73:	00 00 00 
  802c76:	ff d0                	callq  *%rax
  802c78:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7e:	48 63 d0             	movslq %eax,%rdx
  802c81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c85:	48 01 c2             	add    %rax,%rdx
  802c88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c8c:	48 89 c6             	mov    %rax,%rsi
  802c8f:	48 89 d7             	mov    %rdx,%rdi
  802c92:	48 b8 12 2c 80 00 00 	movabs $0x802c12,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
	return dst;
  802c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802ca2:	c9                   	leaveq 
  802ca3:	c3                   	retq   

0000000000802ca4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802ca4:	55                   	push   %rbp
  802ca5:	48 89 e5             	mov    %rsp,%rbp
  802ca8:	48 83 ec 28          	sub    $0x28,%rsp
  802cac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802cc0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802cc7:	00 
  802cc8:	eb 2a                	jmp    802cf4 <strncpy+0x50>
		*dst++ = *src;
  802cca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cd2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cd6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cda:	0f b6 12             	movzbl (%rdx),%edx
  802cdd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802cdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce3:	0f b6 00             	movzbl (%rax),%eax
  802ce6:	84 c0                	test   %al,%al
  802ce8:	74 05                	je     802cef <strncpy+0x4b>
			src++;
  802cea:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802cef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cf8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cfc:	72 cc                	jb     802cca <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d02:	c9                   	leaveq 
  802d03:	c3                   	retq   

0000000000802d04 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d04:	55                   	push   %rbp
  802d05:	48 89 e5             	mov    %rsp,%rbp
  802d08:	48 83 ec 28          	sub    $0x28,%rsp
  802d0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d20:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d25:	74 3d                	je     802d64 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d27:	eb 1d                	jmp    802d46 <strlcpy+0x42>
			*dst++ = *src++;
  802d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d31:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d39:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d3d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d41:	0f b6 12             	movzbl (%rdx),%edx
  802d44:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d46:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d4b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d50:	74 0b                	je     802d5d <strlcpy+0x59>
  802d52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d56:	0f b6 00             	movzbl (%rax),%eax
  802d59:	84 c0                	test   %al,%al
  802d5b:	75 cc                	jne    802d29 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d61:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d6c:	48 29 c2             	sub    %rax,%rdx
  802d6f:	48 89 d0             	mov    %rdx,%rax
}
  802d72:	c9                   	leaveq 
  802d73:	c3                   	retq   

0000000000802d74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d74:	55                   	push   %rbp
  802d75:	48 89 e5             	mov    %rsp,%rbp
  802d78:	48 83 ec 10          	sub    $0x10,%rsp
  802d7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d84:	eb 0a                	jmp    802d90 <strcmp+0x1c>
		p++, q++;
  802d86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d8b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d94:	0f b6 00             	movzbl (%rax),%eax
  802d97:	84 c0                	test   %al,%al
  802d99:	74 12                	je     802dad <strcmp+0x39>
  802d9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9f:	0f b6 10             	movzbl (%rax),%edx
  802da2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da6:	0f b6 00             	movzbl (%rax),%eax
  802da9:	38 c2                	cmp    %al,%dl
  802dab:	74 d9                	je     802d86 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db1:	0f b6 00             	movzbl (%rax),%eax
  802db4:	0f b6 d0             	movzbl %al,%edx
  802db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbb:	0f b6 00             	movzbl (%rax),%eax
  802dbe:	0f b6 c0             	movzbl %al,%eax
  802dc1:	29 c2                	sub    %eax,%edx
  802dc3:	89 d0                	mov    %edx,%eax
}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 18          	sub    $0x18,%rsp
  802dcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802ddb:	eb 0f                	jmp    802dec <strncmp+0x25>
		n--, p++, q++;
  802ddd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802de2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802de7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802dec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802df1:	74 1d                	je     802e10 <strncmp+0x49>
  802df3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df7:	0f b6 00             	movzbl (%rax),%eax
  802dfa:	84 c0                	test   %al,%al
  802dfc:	74 12                	je     802e10 <strncmp+0x49>
  802dfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e02:	0f b6 10             	movzbl (%rax),%edx
  802e05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e09:	0f b6 00             	movzbl (%rax),%eax
  802e0c:	38 c2                	cmp    %al,%dl
  802e0e:	74 cd                	je     802ddd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e10:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e15:	75 07                	jne    802e1e <strncmp+0x57>
		return 0;
  802e17:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1c:	eb 18                	jmp    802e36 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e22:	0f b6 00             	movzbl (%rax),%eax
  802e25:	0f b6 d0             	movzbl %al,%edx
  802e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2c:	0f b6 00             	movzbl (%rax),%eax
  802e2f:	0f b6 c0             	movzbl %al,%eax
  802e32:	29 c2                	sub    %eax,%edx
  802e34:	89 d0                	mov    %edx,%eax
}
  802e36:	c9                   	leaveq 
  802e37:	c3                   	retq   

0000000000802e38 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e38:	55                   	push   %rbp
  802e39:	48 89 e5             	mov    %rsp,%rbp
  802e3c:	48 83 ec 0c          	sub    $0xc,%rsp
  802e40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e44:	89 f0                	mov    %esi,%eax
  802e46:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e49:	eb 17                	jmp    802e62 <strchr+0x2a>
		if (*s == c)
  802e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4f:	0f b6 00             	movzbl (%rax),%eax
  802e52:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e55:	75 06                	jne    802e5d <strchr+0x25>
			return (char *) s;
  802e57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e5b:	eb 15                	jmp    802e72 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e5d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e66:	0f b6 00             	movzbl (%rax),%eax
  802e69:	84 c0                	test   %al,%al
  802e6b:	75 de                	jne    802e4b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e72:	c9                   	leaveq 
  802e73:	c3                   	retq   

0000000000802e74 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e74:	55                   	push   %rbp
  802e75:	48 89 e5             	mov    %rsp,%rbp
  802e78:	48 83 ec 0c          	sub    $0xc,%rsp
  802e7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e80:	89 f0                	mov    %esi,%eax
  802e82:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e85:	eb 13                	jmp    802e9a <strfind+0x26>
		if (*s == c)
  802e87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8b:	0f b6 00             	movzbl (%rax),%eax
  802e8e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e91:	75 02                	jne    802e95 <strfind+0x21>
			break;
  802e93:	eb 10                	jmp    802ea5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802e95:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9e:	0f b6 00             	movzbl (%rax),%eax
  802ea1:	84 c0                	test   %al,%al
  802ea3:	75 e2                	jne    802e87 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ea9:	c9                   	leaveq 
  802eaa:	c3                   	retq   

0000000000802eab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802eab:	55                   	push   %rbp
  802eac:	48 89 e5             	mov    %rsp,%rbp
  802eaf:	48 83 ec 18          	sub    $0x18,%rsp
  802eb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eb7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802eba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ebe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ec3:	75 06                	jne    802ecb <memset+0x20>
		return v;
  802ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec9:	eb 69                	jmp    802f34 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ecf:	83 e0 03             	and    $0x3,%eax
  802ed2:	48 85 c0             	test   %rax,%rax
  802ed5:	75 48                	jne    802f1f <memset+0x74>
  802ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802edb:	83 e0 03             	and    $0x3,%eax
  802ede:	48 85 c0             	test   %rax,%rax
  802ee1:	75 3c                	jne    802f1f <memset+0x74>
		c &= 0xFF;
  802ee3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802eea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eed:	c1 e0 18             	shl    $0x18,%eax
  802ef0:	89 c2                	mov    %eax,%edx
  802ef2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ef5:	c1 e0 10             	shl    $0x10,%eax
  802ef8:	09 c2                	or     %eax,%edx
  802efa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802efd:	c1 e0 08             	shl    $0x8,%eax
  802f00:	09 d0                	or     %edx,%eax
  802f02:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f09:	48 c1 e8 02          	shr    $0x2,%rax
  802f0d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f10:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f17:	48 89 d7             	mov    %rdx,%rdi
  802f1a:	fc                   	cld    
  802f1b:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f1d:	eb 11                	jmp    802f30 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f23:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f2a:	48 89 d7             	mov    %rdx,%rdi
  802f2d:	fc                   	cld    
  802f2e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f34:	c9                   	leaveq 
  802f35:	c3                   	retq   

0000000000802f36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f36:	55                   	push   %rbp
  802f37:	48 89 e5             	mov    %rsp,%rbp
  802f3a:	48 83 ec 28          	sub    $0x28,%rsp
  802f3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f46:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f56:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f62:	0f 83 88 00 00 00    	jae    802ff0 <memmove+0xba>
  802f68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f70:	48 01 d0             	add    %rdx,%rax
  802f73:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f77:	76 77                	jbe    802ff0 <memmove+0xba>
		s += n;
  802f79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f85:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8d:	83 e0 03             	and    $0x3,%eax
  802f90:	48 85 c0             	test   %rax,%rax
  802f93:	75 3b                	jne    802fd0 <memmove+0x9a>
  802f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f99:	83 e0 03             	and    $0x3,%eax
  802f9c:	48 85 c0             	test   %rax,%rax
  802f9f:	75 2f                	jne    802fd0 <memmove+0x9a>
  802fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa5:	83 e0 03             	and    $0x3,%eax
  802fa8:	48 85 c0             	test   %rax,%rax
  802fab:	75 23                	jne    802fd0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb1:	48 83 e8 04          	sub    $0x4,%rax
  802fb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fb9:	48 83 ea 04          	sub    $0x4,%rdx
  802fbd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fc1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fc5:	48 89 c7             	mov    %rax,%rdi
  802fc8:	48 89 d6             	mov    %rdx,%rsi
  802fcb:	fd                   	std    
  802fcc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fce:	eb 1d                	jmp    802fed <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802fd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fdc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802fe0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe4:	48 89 d7             	mov    %rdx,%rdi
  802fe7:	48 89 c1             	mov    %rax,%rcx
  802fea:	fd                   	std    
  802feb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802fed:	fc                   	cld    
  802fee:	eb 57                	jmp    803047 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802ff0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff4:	83 e0 03             	and    $0x3,%eax
  802ff7:	48 85 c0             	test   %rax,%rax
  802ffa:	75 36                	jne    803032 <memmove+0xfc>
  802ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803000:	83 e0 03             	and    $0x3,%eax
  803003:	48 85 c0             	test   %rax,%rax
  803006:	75 2a                	jne    803032 <memmove+0xfc>
  803008:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80300c:	83 e0 03             	and    $0x3,%eax
  80300f:	48 85 c0             	test   %rax,%rax
  803012:	75 1e                	jne    803032 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803018:	48 c1 e8 02          	shr    $0x2,%rax
  80301c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80301f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803023:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803027:	48 89 c7             	mov    %rax,%rdi
  80302a:	48 89 d6             	mov    %rdx,%rsi
  80302d:	fc                   	cld    
  80302e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803030:	eb 15                	jmp    803047 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803036:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80303a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80303e:	48 89 c7             	mov    %rax,%rdi
  803041:	48 89 d6             	mov    %rdx,%rsi
  803044:	fc                   	cld    
  803045:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80304b:	c9                   	leaveq 
  80304c:	c3                   	retq   

000000000080304d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80304d:	55                   	push   %rbp
  80304e:	48 89 e5             	mov    %rsp,%rbp
  803051:	48 83 ec 18          	sub    $0x18,%rsp
  803055:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803059:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80305d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803061:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803065:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306d:	48 89 ce             	mov    %rcx,%rsi
  803070:	48 89 c7             	mov    %rax,%rdi
  803073:	48 b8 36 2f 80 00 00 	movabs $0x802f36,%rax
  80307a:	00 00 00 
  80307d:	ff d0                	callq  *%rax
}
  80307f:	c9                   	leaveq 
  803080:	c3                   	retq   

0000000000803081 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803081:	55                   	push   %rbp
  803082:	48 89 e5             	mov    %rsp,%rbp
  803085:	48 83 ec 28          	sub    $0x28,%rsp
  803089:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80308d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803091:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803099:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80309d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030a5:	eb 36                	jmp    8030dd <memcmp+0x5c>
		if (*s1 != *s2)
  8030a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ab:	0f b6 10             	movzbl (%rax),%edx
  8030ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b2:	0f b6 00             	movzbl (%rax),%eax
  8030b5:	38 c2                	cmp    %al,%dl
  8030b7:	74 1a                	je     8030d3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030bd:	0f b6 00             	movzbl (%rax),%eax
  8030c0:	0f b6 d0             	movzbl %al,%edx
  8030c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c7:	0f b6 00             	movzbl (%rax),%eax
  8030ca:	0f b6 c0             	movzbl %al,%eax
  8030cd:	29 c2                	sub    %eax,%edx
  8030cf:	89 d0                	mov    %edx,%eax
  8030d1:	eb 20                	jmp    8030f3 <memcmp+0x72>
		s1++, s2++;
  8030d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8030e9:	48 85 c0             	test   %rax,%rax
  8030ec:	75 b9                	jne    8030a7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8030ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f3:	c9                   	leaveq 
  8030f4:	c3                   	retq   

00000000008030f5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8030f5:	55                   	push   %rbp
  8030f6:	48 89 e5             	mov    %rsp,%rbp
  8030f9:	48 83 ec 28          	sub    $0x28,%rsp
  8030fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803101:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803104:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803108:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80310c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803110:	48 01 d0             	add    %rdx,%rax
  803113:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803117:	eb 15                	jmp    80312e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311d:	0f b6 10             	movzbl (%rax),%edx
  803120:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803123:	38 c2                	cmp    %al,%dl
  803125:	75 02                	jne    803129 <memfind+0x34>
			break;
  803127:	eb 0f                	jmp    803138 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803129:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80312e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803132:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803136:	72 e1                	jb     803119 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80313c:	c9                   	leaveq 
  80313d:	c3                   	retq   

000000000080313e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80313e:	55                   	push   %rbp
  80313f:	48 89 e5             	mov    %rsp,%rbp
  803142:	48 83 ec 34          	sub    $0x34,%rsp
  803146:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80314a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80314e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803158:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80315f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803160:	eb 05                	jmp    803167 <strtol+0x29>
		s++;
  803162:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803167:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316b:	0f b6 00             	movzbl (%rax),%eax
  80316e:	3c 20                	cmp    $0x20,%al
  803170:	74 f0                	je     803162 <strtol+0x24>
  803172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803176:	0f b6 00             	movzbl (%rax),%eax
  803179:	3c 09                	cmp    $0x9,%al
  80317b:	74 e5                	je     803162 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80317d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803181:	0f b6 00             	movzbl (%rax),%eax
  803184:	3c 2b                	cmp    $0x2b,%al
  803186:	75 07                	jne    80318f <strtol+0x51>
		s++;
  803188:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80318d:	eb 17                	jmp    8031a6 <strtol+0x68>
	else if (*s == '-')
  80318f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803193:	0f b6 00             	movzbl (%rax),%eax
  803196:	3c 2d                	cmp    $0x2d,%al
  803198:	75 0c                	jne    8031a6 <strtol+0x68>
		s++, neg = 1;
  80319a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80319f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031aa:	74 06                	je     8031b2 <strtol+0x74>
  8031ac:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031b0:	75 28                	jne    8031da <strtol+0x9c>
  8031b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b6:	0f b6 00             	movzbl (%rax),%eax
  8031b9:	3c 30                	cmp    $0x30,%al
  8031bb:	75 1d                	jne    8031da <strtol+0x9c>
  8031bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c1:	48 83 c0 01          	add    $0x1,%rax
  8031c5:	0f b6 00             	movzbl (%rax),%eax
  8031c8:	3c 78                	cmp    $0x78,%al
  8031ca:	75 0e                	jne    8031da <strtol+0x9c>
		s += 2, base = 16;
  8031cc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031d1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031d8:	eb 2c                	jmp    803206 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031da:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031de:	75 19                	jne    8031f9 <strtol+0xbb>
  8031e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e4:	0f b6 00             	movzbl (%rax),%eax
  8031e7:	3c 30                	cmp    $0x30,%al
  8031e9:	75 0e                	jne    8031f9 <strtol+0xbb>
		s++, base = 8;
  8031eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031f0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8031f7:	eb 0d                	jmp    803206 <strtol+0xc8>
	else if (base == 0)
  8031f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031fd:	75 07                	jne    803206 <strtol+0xc8>
		base = 10;
  8031ff:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803206:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320a:	0f b6 00             	movzbl (%rax),%eax
  80320d:	3c 2f                	cmp    $0x2f,%al
  80320f:	7e 1d                	jle    80322e <strtol+0xf0>
  803211:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803215:	0f b6 00             	movzbl (%rax),%eax
  803218:	3c 39                	cmp    $0x39,%al
  80321a:	7f 12                	jg     80322e <strtol+0xf0>
			dig = *s - '0';
  80321c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803220:	0f b6 00             	movzbl (%rax),%eax
  803223:	0f be c0             	movsbl %al,%eax
  803226:	83 e8 30             	sub    $0x30,%eax
  803229:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80322c:	eb 4e                	jmp    80327c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80322e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803232:	0f b6 00             	movzbl (%rax),%eax
  803235:	3c 60                	cmp    $0x60,%al
  803237:	7e 1d                	jle    803256 <strtol+0x118>
  803239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323d:	0f b6 00             	movzbl (%rax),%eax
  803240:	3c 7a                	cmp    $0x7a,%al
  803242:	7f 12                	jg     803256 <strtol+0x118>
			dig = *s - 'a' + 10;
  803244:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803248:	0f b6 00             	movzbl (%rax),%eax
  80324b:	0f be c0             	movsbl %al,%eax
  80324e:	83 e8 57             	sub    $0x57,%eax
  803251:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803254:	eb 26                	jmp    80327c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803256:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325a:	0f b6 00             	movzbl (%rax),%eax
  80325d:	3c 40                	cmp    $0x40,%al
  80325f:	7e 48                	jle    8032a9 <strtol+0x16b>
  803261:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803265:	0f b6 00             	movzbl (%rax),%eax
  803268:	3c 5a                	cmp    $0x5a,%al
  80326a:	7f 3d                	jg     8032a9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80326c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803270:	0f b6 00             	movzbl (%rax),%eax
  803273:	0f be c0             	movsbl %al,%eax
  803276:	83 e8 37             	sub    $0x37,%eax
  803279:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80327c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803282:	7c 02                	jl     803286 <strtol+0x148>
			break;
  803284:	eb 23                	jmp    8032a9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803286:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80328b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80328e:	48 98                	cltq   
  803290:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803295:	48 89 c2             	mov    %rax,%rdx
  803298:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329b:	48 98                	cltq   
  80329d:	48 01 d0             	add    %rdx,%rax
  8032a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032a4:	e9 5d ff ff ff       	jmpq   803206 <strtol+0xc8>

	if (endptr)
  8032a9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032ae:	74 0b                	je     8032bb <strtol+0x17d>
		*endptr = (char *) s;
  8032b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032b8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032bf:	74 09                	je     8032ca <strtol+0x18c>
  8032c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c5:	48 f7 d8             	neg    %rax
  8032c8:	eb 04                	jmp    8032ce <strtol+0x190>
  8032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032ce:	c9                   	leaveq 
  8032cf:	c3                   	retq   

00000000008032d0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8032d0:	55                   	push   %rbp
  8032d1:	48 89 e5             	mov    %rsp,%rbp
  8032d4:	48 83 ec 30          	sub    $0x30,%rsp
  8032d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8032e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032e8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8032ec:	0f b6 00             	movzbl (%rax),%eax
  8032ef:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8032f2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8032f6:	75 06                	jne    8032fe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8032f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fc:	eb 6b                	jmp    803369 <strstr+0x99>

	len = strlen(str);
  8032fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803302:	48 89 c7             	mov    %rax,%rdi
  803305:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
  803311:	48 98                	cltq   
  803313:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803317:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80331f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803323:	0f b6 00             	movzbl (%rax),%eax
  803326:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803329:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80332d:	75 07                	jne    803336 <strstr+0x66>
				return (char *) 0;
  80332f:	b8 00 00 00 00       	mov    $0x0,%eax
  803334:	eb 33                	jmp    803369 <strstr+0x99>
		} while (sc != c);
  803336:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80333a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80333d:	75 d8                	jne    803317 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80333f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803343:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334b:	48 89 ce             	mov    %rcx,%rsi
  80334e:	48 89 c7             	mov    %rax,%rdi
  803351:	48 b8 c7 2d 80 00 00 	movabs $0x802dc7,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	75 b6                	jne    803317 <strstr+0x47>

	return (char *) (in - 1);
  803361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803365:	48 83 e8 01          	sub    $0x1,%rax
}
  803369:	c9                   	leaveq 
  80336a:	c3                   	retq   

000000000080336b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80336b:	55                   	push   %rbp
  80336c:	48 89 e5             	mov    %rsp,%rbp
  80336f:	48 83 ec 30          	sub    $0x30,%rsp
  803373:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803377:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80337b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80337f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803384:	75 0e                	jne    803394 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803386:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80338d:	00 00 00 
  803390:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803394:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803398:	48 89 c7             	mov    %rax,%rdi
  80339b:	48 b8 08 05 80 00 00 	movabs $0x800508,%rax
  8033a2:	00 00 00 
  8033a5:	ff d0                	callq  *%rax
  8033a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ae:	79 27                	jns    8033d7 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033b5:	74 0a                	je     8033c1 <ipc_recv+0x56>
            *from_env_store = 0;
  8033b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033bb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033c6:	74 0a                	je     8033d2 <ipc_recv+0x67>
            *perm_store = 0;
  8033c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033cc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d5:	eb 53                	jmp    80342a <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033d7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033dc:	74 19                	je     8033f7 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033de:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033e5:	00 00 00 
  8033e8:	48 8b 00             	mov    (%rax),%rax
  8033eb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8033f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f5:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8033f7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033fc:	74 19                	je     803417 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8033fe:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803405:	00 00 00 
  803408:	48 8b 00             	mov    (%rax),%rax
  80340b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803415:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803417:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80341e:	00 00 00 
  803421:	48 8b 00             	mov    (%rax),%rax
  803424:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80342a:	c9                   	leaveq 
  80342b:	c3                   	retq   

000000000080342c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80342c:	55                   	push   %rbp
  80342d:	48 89 e5             	mov    %rsp,%rbp
  803430:	48 83 ec 30          	sub    $0x30,%rsp
  803434:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803437:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80343a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80343e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803441:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803446:	75 0e                	jne    803456 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803448:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80344f:	00 00 00 
  803452:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803456:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803459:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80345c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803460:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803463:	89 c7                	mov    %eax,%edi
  803465:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803478:	79 36                	jns    8034b0 <ipc_send+0x84>
  80347a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80347e:	74 30                	je     8034b0 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803483:	89 c1                	mov    %eax,%ecx
  803485:	48 ba 88 3c 80 00 00 	movabs $0x803c88,%rdx
  80348c:	00 00 00 
  80348f:	be 49 00 00 00       	mov    $0x49,%esi
  803494:	48 bf 95 3c 80 00 00 	movabs $0x803c95,%rdi
  80349b:	00 00 00 
  80349e:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a3:	49 b8 11 1e 80 00 00 	movabs $0x801e11,%r8
  8034aa:	00 00 00 
  8034ad:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034b0:	48 b8 a1 02 80 00 00 	movabs $0x8002a1,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
    } while(r != 0);
  8034bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c0:	75 94                	jne    803456 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034c2:	c9                   	leaveq 
  8034c3:	c3                   	retq   

00000000008034c4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034c4:	55                   	push   %rbp
  8034c5:	48 89 e5             	mov    %rsp,%rbp
  8034c8:	48 83 ec 14          	sub    $0x14,%rsp
  8034cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034d6:	eb 5e                	jmp    803536 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034d8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034df:	00 00 00 
  8034e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e5:	48 63 d0             	movslq %eax,%rdx
  8034e8:	48 89 d0             	mov    %rdx,%rax
  8034eb:	48 c1 e0 03          	shl    $0x3,%rax
  8034ef:	48 01 d0             	add    %rdx,%rax
  8034f2:	48 c1 e0 05          	shl    $0x5,%rax
  8034f6:	48 01 c8             	add    %rcx,%rax
  8034f9:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8034ff:	8b 00                	mov    (%rax),%eax
  803501:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803504:	75 2c                	jne    803532 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803506:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80350d:	00 00 00 
  803510:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803513:	48 63 d0             	movslq %eax,%rdx
  803516:	48 89 d0             	mov    %rdx,%rax
  803519:	48 c1 e0 03          	shl    $0x3,%rax
  80351d:	48 01 d0             	add    %rdx,%rax
  803520:	48 c1 e0 05          	shl    $0x5,%rax
  803524:	48 01 c8             	add    %rcx,%rax
  803527:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80352d:	8b 40 08             	mov    0x8(%rax),%eax
  803530:	eb 12                	jmp    803544 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803532:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803536:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80353d:	7e 99                	jle    8034d8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80353f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803544:	c9                   	leaveq 
  803545:	c3                   	retq   

0000000000803546 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803546:	55                   	push   %rbp
  803547:	48 89 e5             	mov    %rsp,%rbp
  80354a:	48 83 ec 18          	sub    $0x18,%rsp
  80354e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803556:	48 c1 e8 15          	shr    $0x15,%rax
  80355a:	48 89 c2             	mov    %rax,%rdx
  80355d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803564:	01 00 00 
  803567:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80356b:	83 e0 01             	and    $0x1,%eax
  80356e:	48 85 c0             	test   %rax,%rax
  803571:	75 07                	jne    80357a <pageref+0x34>
		return 0;
  803573:	b8 00 00 00 00       	mov    $0x0,%eax
  803578:	eb 53                	jmp    8035cd <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80357a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357e:	48 c1 e8 0c          	shr    $0xc,%rax
  803582:	48 89 c2             	mov    %rax,%rdx
  803585:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80358c:	01 00 00 
  80358f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803593:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80359b:	83 e0 01             	and    $0x1,%eax
  80359e:	48 85 c0             	test   %rax,%rax
  8035a1:	75 07                	jne    8035aa <pageref+0x64>
		return 0;
  8035a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a8:	eb 23                	jmp    8035cd <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ae:	48 c1 e8 0c          	shr    $0xc,%rax
  8035b2:	48 89 c2             	mov    %rax,%rdx
  8035b5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035bc:	00 00 00 
  8035bf:	48 c1 e2 04          	shl    $0x4,%rdx
  8035c3:	48 01 d0             	add    %rdx,%rax
  8035c6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035ca:	0f b7 c0             	movzwl %ax,%eax
}
  8035cd:	c9                   	leaveq 
  8035ce:	c3                   	retq   
