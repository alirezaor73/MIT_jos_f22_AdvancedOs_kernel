
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
	envid_t id = sys_getenvid();
  800064:	48 b8 57 02 80 00 00 	movabs $0x800257,%rax
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
  800099:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000a0:	00 00 00 
  8000a3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000aa:	7e 14                	jle    8000c0 <libmain+0x6b>
		binaryname = argv[0];
  8000ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000b0:	48 8b 10             	mov    (%rax),%rdx
  8000b3:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  8000ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ef:	48 b8 13 02 80 00 00 	movabs $0x800213,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
}
  8000fb:	5d                   	pop    %rbp
  8000fc:	c3                   	retq   

00000000008000fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000fd:	55                   	push   %rbp
  8000fe:	48 89 e5             	mov    %rsp,%rbp
  800101:	53                   	push   %rbx
  800102:	48 83 ec 48          	sub    $0x48,%rsp
  800106:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800109:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80010c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800110:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800114:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800118:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80011f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800123:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800127:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80012b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80012f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800133:	4c 89 c3             	mov    %r8,%rbx
  800136:	cd 30                	int    $0x30
  800138:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80013c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800140:	74 3e                	je     800180 <syscall+0x83>
  800142:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800147:	7e 37                	jle    800180 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800149:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80014d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800150:	49 89 d0             	mov    %rdx,%r8
  800153:	89 c1                	mov    %eax,%ecx
  800155:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  80015c:	00 00 00 
  80015f:	be 23 00 00 00       	mov    $0x23,%esi
  800164:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  80016b:	00 00 00 
  80016e:	b8 00 00 00 00       	mov    $0x0,%eax
  800173:	49 b9 f6 04 80 00 00 	movabs $0x8004f6,%r9
  80017a:	00 00 00 
  80017d:	41 ff d1             	callq  *%r9

	return ret;
  800180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800184:	48 83 c4 48          	add    $0x48,%rsp
  800188:	5b                   	pop    %rbx
  800189:	5d                   	pop    %rbp
  80018a:	c3                   	retq   

000000000080018b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80018b:	55                   	push   %rbp
  80018c:	48 89 e5             	mov    %rsp,%rbp
  80018f:	48 83 ec 20          	sub    $0x20,%rsp
  800193:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800197:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80019b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80019f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001aa:	00 
  8001ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001b7:	48 89 d1             	mov    %rdx,%rcx
  8001ba:	48 89 c2             	mov    %rax,%rdx
  8001bd:	be 00 00 00 00       	mov    $0x0,%esi
  8001c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c7:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
}
  8001d3:	c9                   	leaveq 
  8001d4:	c3                   	retq   

00000000008001d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001d5:	55                   	push   %rbp
  8001d6:	48 89 e5             	mov    %rsp,%rbp
  8001d9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001e4:	00 
  8001e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fb:	be 00 00 00 00       	mov    $0x0,%esi
  800200:	bf 01 00 00 00       	mov    $0x1,%edi
  800205:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  80020c:	00 00 00 
  80020f:	ff d0                	callq  *%rax
}
  800211:	c9                   	leaveq 
  800212:	c3                   	retq   

0000000000800213 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800213:	55                   	push   %rbp
  800214:	48 89 e5             	mov    %rsp,%rbp
  800217:	48 83 ec 10          	sub    $0x10,%rsp
  80021b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80021e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800221:	48 98                	cltq   
  800223:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80022a:	00 
  80022b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800231:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800237:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023c:	48 89 c2             	mov    %rax,%rdx
  80023f:	be 01 00 00 00       	mov    $0x1,%esi
  800244:	bf 03 00 00 00       	mov    $0x3,%edi
  800249:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
}
  800255:	c9                   	leaveq 
  800256:	c3                   	retq   

0000000000800257 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800257:	55                   	push   %rbp
  800258:	48 89 e5             	mov    %rsp,%rbp
  80025b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80025f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800266:	00 
  800267:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80026d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800273:	b9 00 00 00 00       	mov    $0x0,%ecx
  800278:	ba 00 00 00 00       	mov    $0x0,%edx
  80027d:	be 00 00 00 00       	mov    $0x0,%esi
  800282:	bf 02 00 00 00       	mov    $0x2,%edi
  800287:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
}
  800293:	c9                   	leaveq 
  800294:	c3                   	retq   

0000000000800295 <sys_yield>:

void
sys_yield(void)
{
  800295:	55                   	push   %rbp
  800296:	48 89 e5             	mov    %rsp,%rbp
  800299:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80029d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002a4:	00 
  8002a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002bb:	be 00 00 00 00       	mov    $0x0,%esi
  8002c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002c5:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	c9                   	leaveq 
  8002d2:	c3                   	retq   

00000000008002d3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002d3:	55                   	push   %rbp
  8002d4:	48 89 e5             	mov    %rsp,%rbp
  8002d7:	48 83 ec 20          	sub    $0x20,%rsp
  8002db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002e2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002e8:	48 63 c8             	movslq %eax,%rcx
  8002eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f2:	48 98                	cltq   
  8002f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002fb:	00 
  8002fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800302:	49 89 c8             	mov    %rcx,%r8
  800305:	48 89 d1             	mov    %rdx,%rcx
  800308:	48 89 c2             	mov    %rax,%rdx
  80030b:	be 01 00 00 00       	mov    $0x1,%esi
  800310:	bf 04 00 00 00       	mov    $0x4,%edi
  800315:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  80031c:	00 00 00 
  80031f:	ff d0                	callq  *%rax
}
  800321:	c9                   	leaveq 
  800322:	c3                   	retq   

0000000000800323 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800323:	55                   	push   %rbp
  800324:	48 89 e5             	mov    %rsp,%rbp
  800327:	48 83 ec 30          	sub    $0x30,%rsp
  80032b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80032e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800332:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800335:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800339:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80033d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800340:	48 63 c8             	movslq %eax,%rcx
  800343:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800347:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80034a:	48 63 f0             	movslq %eax,%rsi
  80034d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800351:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800354:	48 98                	cltq   
  800356:	48 89 0c 24          	mov    %rcx,(%rsp)
  80035a:	49 89 f9             	mov    %rdi,%r9
  80035d:	49 89 f0             	mov    %rsi,%r8
  800360:	48 89 d1             	mov    %rdx,%rcx
  800363:	48 89 c2             	mov    %rax,%rdx
  800366:	be 01 00 00 00       	mov    $0x1,%esi
  80036b:	bf 05 00 00 00       	mov    $0x5,%edi
  800370:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  800377:	00 00 00 
  80037a:	ff d0                	callq  *%rax
}
  80037c:	c9                   	leaveq 
  80037d:	c3                   	retq   

000000000080037e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80037e:	55                   	push   %rbp
  80037f:	48 89 e5             	mov    %rsp,%rbp
  800382:	48 83 ec 20          	sub    $0x20,%rsp
  800386:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800389:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80038d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800394:	48 98                	cltq   
  800396:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80039d:	00 
  80039e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003aa:	48 89 d1             	mov    %rdx,%rcx
  8003ad:	48 89 c2             	mov    %rax,%rdx
  8003b0:	be 01 00 00 00       	mov    $0x1,%esi
  8003b5:	bf 06 00 00 00       	mov    $0x6,%edi
  8003ba:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax
}
  8003c6:	c9                   	leaveq 
  8003c7:	c3                   	retq   

00000000008003c8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003c8:	55                   	push   %rbp
  8003c9:	48 89 e5             	mov    %rsp,%rbp
  8003cc:	48 83 ec 10          	sub    $0x10,%rsp
  8003d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003d3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003d9:	48 63 d0             	movslq %eax,%rdx
  8003dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003df:	48 98                	cltq   
  8003e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003e8:	00 
  8003e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003f5:	48 89 d1             	mov    %rdx,%rcx
  8003f8:	48 89 c2             	mov    %rax,%rdx
  8003fb:	be 01 00 00 00       	mov    $0x1,%esi
  800400:	bf 08 00 00 00       	mov    $0x8,%edi
  800405:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  80040c:	00 00 00 
  80040f:	ff d0                	callq  *%rax
}
  800411:	c9                   	leaveq 
  800412:	c3                   	retq   

0000000000800413 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800413:	55                   	push   %rbp
  800414:	48 89 e5             	mov    %rsp,%rbp
  800417:	48 83 ec 20          	sub    $0x20,%rsp
  80041b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800422:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800429:	48 98                	cltq   
  80042b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800432:	00 
  800433:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800439:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80043f:	48 89 d1             	mov    %rdx,%rcx
  800442:	48 89 c2             	mov    %rax,%rdx
  800445:	be 01 00 00 00       	mov    $0x1,%esi
  80044a:	bf 09 00 00 00       	mov    $0x9,%edi
  80044f:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  800456:	00 00 00 
  800459:	ff d0                	callq  *%rax
}
  80045b:	c9                   	leaveq 
  80045c:	c3                   	retq   

000000000080045d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80045d:	55                   	push   %rbp
  80045e:	48 89 e5             	mov    %rsp,%rbp
  800461:	48 83 ec 20          	sub    $0x20,%rsp
  800465:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800468:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80046c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800470:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800473:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800476:	48 63 f0             	movslq %eax,%rsi
  800479:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80047d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800480:	48 98                	cltq   
  800482:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800486:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80048d:	00 
  80048e:	49 89 f1             	mov    %rsi,%r9
  800491:	49 89 c8             	mov    %rcx,%r8
  800494:	48 89 d1             	mov    %rdx,%rcx
  800497:	48 89 c2             	mov    %rax,%rdx
  80049a:	be 00 00 00 00       	mov    $0x0,%esi
  80049f:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004a4:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
}
  8004b0:	c9                   	leaveq 
  8004b1:	c3                   	retq   

00000000008004b2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 83 ec 10          	sub    $0x10,%rsp
  8004ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c9:	00 
  8004ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004db:	48 89 c2             	mov    %rax,%rdx
  8004de:	be 01 00 00 00       	mov    $0x1,%esi
  8004e3:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004e8:	48 b8 fd 00 80 00 00 	movabs $0x8000fd,%rax
  8004ef:	00 00 00 
  8004f2:	ff d0                	callq  *%rax
}
  8004f4:	c9                   	leaveq 
  8004f5:	c3                   	retq   

00000000008004f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004f6:	55                   	push   %rbp
  8004f7:	48 89 e5             	mov    %rsp,%rbp
  8004fa:	53                   	push   %rbx
  8004fb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800502:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800509:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80050f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800516:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80051d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800524:	84 c0                	test   %al,%al
  800526:	74 23                	je     80054b <_panic+0x55>
  800528:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80052f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800533:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800537:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80053b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80053f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800543:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800547:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80054b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800552:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800559:	00 00 00 
  80055c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800563:	00 00 00 
  800566:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80056a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800571:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800578:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80057f:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800586:	00 00 00 
  800589:	48 8b 18             	mov    (%rax),%rbx
  80058c:	48 b8 57 02 80 00 00 	movabs $0x800257,%rax
  800593:	00 00 00 
  800596:	ff d0                	callq  *%rax
  800598:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80059e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005a5:	41 89 c8             	mov    %ecx,%r8d
  8005a8:	48 89 d1             	mov    %rdx,%rcx
  8005ab:	48 89 da             	mov    %rbx,%rdx
  8005ae:	89 c6                	mov    %eax,%esi
  8005b0:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005b7:	00 00 00 
  8005ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bf:	49 b9 2f 07 80 00 00 	movabs $0x80072f,%r9
  8005c6:	00 00 00 
  8005c9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005cc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005d3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005da:	48 89 d6             	mov    %rdx,%rsi
  8005dd:	48 89 c7             	mov    %rax,%rdi
  8005e0:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8005e7:	00 00 00 
  8005ea:	ff d0                	callq  *%rax
	cprintf("\n");
  8005ec:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  8005f3:	00 00 00 
  8005f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fb:	48 ba 2f 07 80 00 00 	movabs $0x80072f,%rdx
  800602:	00 00 00 
  800605:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800607:	cc                   	int3   
  800608:	eb fd                	jmp    800607 <_panic+0x111>

000000000080060a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80060a:	55                   	push   %rbp
  80060b:	48 89 e5             	mov    %rsp,%rbp
  80060e:	48 83 ec 10          	sub    $0x10,%rsp
  800612:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800615:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	8d 48 01             	lea    0x1(%rax),%ecx
  800622:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800626:	89 0a                	mov    %ecx,(%rdx)
  800628:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80062b:	89 d1                	mov    %edx,%ecx
  80062d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800631:	48 98                	cltq   
  800633:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063b:	8b 00                	mov    (%rax),%eax
  80063d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800642:	75 2c                	jne    800670 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800648:	8b 00                	mov    (%rax),%eax
  80064a:	48 98                	cltq   
  80064c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800650:	48 83 c2 08          	add    $0x8,%rdx
  800654:	48 89 c6             	mov    %rax,%rsi
  800657:	48 89 d7             	mov    %rdx,%rdi
  80065a:	48 b8 8b 01 80 00 00 	movabs $0x80018b,%rax
  800661:	00 00 00 
  800664:	ff d0                	callq  *%rax
        b->idx = 0;
  800666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800674:	8b 40 04             	mov    0x4(%rax),%eax
  800677:	8d 50 01             	lea    0x1(%rax),%edx
  80067a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800681:	c9                   	leaveq 
  800682:	c3                   	retq   

0000000000800683 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800683:	55                   	push   %rbp
  800684:	48 89 e5             	mov    %rsp,%rbp
  800687:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80068e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800695:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80069c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006a3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006aa:	48 8b 0a             	mov    (%rdx),%rcx
  8006ad:	48 89 08             	mov    %rcx,(%rax)
  8006b0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006bc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006c7:	00 00 00 
    b.cnt = 0;
  8006ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006d1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006d4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006db:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006e2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006e9:	48 89 c6             	mov    %rax,%rsi
  8006ec:	48 bf 0a 06 80 00 00 	movabs $0x80060a,%rdi
  8006f3:	00 00 00 
  8006f6:	48 b8 e2 0a 80 00 00 	movabs $0x800ae2,%rax
  8006fd:	00 00 00 
  800700:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800702:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800708:	48 98                	cltq   
  80070a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800711:	48 83 c2 08          	add    $0x8,%rdx
  800715:	48 89 c6             	mov    %rax,%rsi
  800718:	48 89 d7             	mov    %rdx,%rdi
  80071b:	48 b8 8b 01 80 00 00 	movabs $0x80018b,%rax
  800722:	00 00 00 
  800725:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800727:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80072d:	c9                   	leaveq 
  80072e:	c3                   	retq   

000000000080072f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80072f:	55                   	push   %rbp
  800730:	48 89 e5             	mov    %rsp,%rbp
  800733:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80073a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800741:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800748:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80074f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800756:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80075d:	84 c0                	test   %al,%al
  80075f:	74 20                	je     800781 <cprintf+0x52>
  800761:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800765:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800769:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80076d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800771:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800775:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800779:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80077d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800781:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800788:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80078f:	00 00 00 
  800792:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800799:	00 00 00 
  80079c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007a7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007ae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007b5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007bc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007c3:	48 8b 0a             	mov    (%rdx),%rcx
  8007c6:	48 89 08             	mov    %rcx,(%rax)
  8007c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007d9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007e0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007e7:	48 89 d6             	mov    %rdx,%rsi
  8007ea:	48 89 c7             	mov    %rax,%rdi
  8007ed:	48 b8 83 06 80 00 00 	movabs $0x800683,%rax
  8007f4:	00 00 00 
  8007f7:	ff d0                	callq  *%rax
  8007f9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007ff:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800805:	c9                   	leaveq 
  800806:	c3                   	retq   

0000000000800807 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800807:	55                   	push   %rbp
  800808:	48 89 e5             	mov    %rsp,%rbp
  80080b:	53                   	push   %rbx
  80080c:	48 83 ec 38          	sub    $0x38,%rsp
  800810:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800814:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800818:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80081c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80081f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800823:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800827:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80082a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80082e:	77 3b                	ja     80086b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800830:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800833:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800837:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80083a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80083e:	ba 00 00 00 00       	mov    $0x0,%edx
  800843:	48 f7 f3             	div    %rbx
  800846:	48 89 c2             	mov    %rax,%rdx
  800849:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80084c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80084f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800857:	41 89 f9             	mov    %edi,%r9d
  80085a:	48 89 c7             	mov    %rax,%rdi
  80085d:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800864:	00 00 00 
  800867:	ff d0                	callq  *%rax
  800869:	eb 1e                	jmp    800889 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086b:	eb 12                	jmp    80087f <printnum+0x78>
			putch(padc, putdat);
  80086d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800871:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 89 ce             	mov    %rcx,%rsi
  80087b:	89 d7                	mov    %edx,%edi
  80087d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800883:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800887:	7f e4                	jg     80086d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800889:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80088c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800890:	ba 00 00 00 00       	mov    $0x0,%edx
  800895:	48 f7 f1             	div    %rcx
  800898:	48 89 d0             	mov    %rdx,%rax
  80089b:	48 ba 10 1c 80 00 00 	movabs $0x801c10,%rdx
  8008a2:	00 00 00 
  8008a5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008a9:	0f be d0             	movsbl %al,%edx
  8008ac:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b4:	48 89 ce             	mov    %rcx,%rsi
  8008b7:	89 d7                	mov    %edx,%edi
  8008b9:	ff d0                	callq  *%rax
}
  8008bb:	48 83 c4 38          	add    $0x38,%rsp
  8008bf:	5b                   	pop    %rbx
  8008c0:	5d                   	pop    %rbp
  8008c1:	c3                   	retq   

00000000008008c2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c2:	55                   	push   %rbp
  8008c3:	48 89 e5             	mov    %rsp,%rbp
  8008c6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ce:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008d1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008d5:	7e 52                	jle    800929 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	8b 00                	mov    (%rax),%eax
  8008dd:	83 f8 30             	cmp    $0x30,%eax
  8008e0:	73 24                	jae    800906 <getuint+0x44>
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ee:	8b 00                	mov    (%rax),%eax
  8008f0:	89 c0                	mov    %eax,%eax
  8008f2:	48 01 d0             	add    %rdx,%rax
  8008f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f9:	8b 12                	mov    (%rdx),%edx
  8008fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800902:	89 0a                	mov    %ecx,(%rdx)
  800904:	eb 17                	jmp    80091d <getuint+0x5b>
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80090e:	48 89 d0             	mov    %rdx,%rax
  800911:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800915:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800919:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091d:	48 8b 00             	mov    (%rax),%rax
  800920:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800924:	e9 a3 00 00 00       	jmpq   8009cc <getuint+0x10a>
	else if (lflag)
  800929:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80092d:	74 4f                	je     80097e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	8b 00                	mov    (%rax),%eax
  800935:	83 f8 30             	cmp    $0x30,%eax
  800938:	73 24                	jae    80095e <getuint+0x9c>
  80093a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	8b 00                	mov    (%rax),%eax
  800948:	89 c0                	mov    %eax,%eax
  80094a:	48 01 d0             	add    %rdx,%rax
  80094d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800951:	8b 12                	mov    (%rdx),%edx
  800953:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800956:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095a:	89 0a                	mov    %ecx,(%rdx)
  80095c:	eb 17                	jmp    800975 <getuint+0xb3>
  80095e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800962:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800966:	48 89 d0             	mov    %rdx,%rax
  800969:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80096d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800971:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800975:	48 8b 00             	mov    (%rax),%rax
  800978:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097c:	eb 4e                	jmp    8009cc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	8b 00                	mov    (%rax),%eax
  800984:	83 f8 30             	cmp    $0x30,%eax
  800987:	73 24                	jae    8009ad <getuint+0xeb>
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800995:	8b 00                	mov    (%rax),%eax
  800997:	89 c0                	mov    %eax,%eax
  800999:	48 01 d0             	add    %rdx,%rax
  80099c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a0:	8b 12                	mov    (%rdx),%edx
  8009a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a9:	89 0a                	mov    %ecx,(%rdx)
  8009ab:	eb 17                	jmp    8009c4 <getuint+0x102>
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009b5:	48 89 d0             	mov    %rdx,%rax
  8009b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c4:	8b 00                	mov    (%rax),%eax
  8009c6:	89 c0                	mov    %eax,%eax
  8009c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d0:	c9                   	leaveq 
  8009d1:	c3                   	retq   

00000000008009d2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009d2:	55                   	push   %rbp
  8009d3:	48 89 e5             	mov    %rsp,%rbp
  8009d6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009de:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009e1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009e5:	7e 52                	jle    800a39 <getint+0x67>
		x=va_arg(*ap, long long);
  8009e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009eb:	8b 00                	mov    (%rax),%eax
  8009ed:	83 f8 30             	cmp    $0x30,%eax
  8009f0:	73 24                	jae    800a16 <getint+0x44>
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fe:	8b 00                	mov    (%rax),%eax
  800a00:	89 c0                	mov    %eax,%eax
  800a02:	48 01 d0             	add    %rdx,%rax
  800a05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a09:	8b 12                	mov    (%rdx),%edx
  800a0b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a12:	89 0a                	mov    %ecx,(%rdx)
  800a14:	eb 17                	jmp    800a2d <getint+0x5b>
  800a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a1e:	48 89 d0             	mov    %rdx,%rax
  800a21:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a29:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a2d:	48 8b 00             	mov    (%rax),%rax
  800a30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a34:	e9 a3 00 00 00       	jmpq   800adc <getint+0x10a>
	else if (lflag)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a3d:	74 4f                	je     800a8e <getint+0xbc>
		x=va_arg(*ap, long);
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	8b 00                	mov    (%rax),%eax
  800a45:	83 f8 30             	cmp    $0x30,%eax
  800a48:	73 24                	jae    800a6e <getint+0x9c>
  800a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a56:	8b 00                	mov    (%rax),%eax
  800a58:	89 c0                	mov    %eax,%eax
  800a5a:	48 01 d0             	add    %rdx,%rax
  800a5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a61:	8b 12                	mov    (%rdx),%edx
  800a63:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6a:	89 0a                	mov    %ecx,(%rdx)
  800a6c:	eb 17                	jmp    800a85 <getint+0xb3>
  800a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a72:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a76:	48 89 d0             	mov    %rdx,%rax
  800a79:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a81:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a85:	48 8b 00             	mov    (%rax),%rax
  800a88:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a8c:	eb 4e                	jmp    800adc <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a92:	8b 00                	mov    (%rax),%eax
  800a94:	83 f8 30             	cmp    $0x30,%eax
  800a97:	73 24                	jae    800abd <getint+0xeb>
  800a99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa5:	8b 00                	mov    (%rax),%eax
  800aa7:	89 c0                	mov    %eax,%eax
  800aa9:	48 01 d0             	add    %rdx,%rax
  800aac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab0:	8b 12                	mov    (%rdx),%edx
  800ab2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab9:	89 0a                	mov    %ecx,(%rdx)
  800abb:	eb 17                	jmp    800ad4 <getint+0x102>
  800abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ac5:	48 89 d0             	mov    %rdx,%rax
  800ac8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800acc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad4:	8b 00                	mov    (%rax),%eax
  800ad6:	48 98                	cltq   
  800ad8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800adc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ae0:	c9                   	leaveq 
  800ae1:	c3                   	retq   

0000000000800ae2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ae2:	55                   	push   %rbp
  800ae3:	48 89 e5             	mov    %rsp,%rbp
  800ae6:	41 54                	push   %r12
  800ae8:	53                   	push   %rbx
  800ae9:	48 83 ec 60          	sub    $0x60,%rsp
  800aed:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800af1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800af5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800af9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800afd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b01:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b05:	48 8b 0a             	mov    (%rdx),%rcx
  800b08:	48 89 08             	mov    %rcx,(%rax)
  800b0b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b0f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b13:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b17:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1b:	eb 17                	jmp    800b34 <vprintfmt+0x52>
			if (ch == '\0')
  800b1d:	85 db                	test   %ebx,%ebx
  800b1f:	0f 84 df 04 00 00    	je     801004 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800b25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2d:	48 89 d6             	mov    %rdx,%rsi
  800b30:	89 df                	mov    %ebx,%edi
  800b32:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b34:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b38:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b3c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b40:	0f b6 00             	movzbl (%rax),%eax
  800b43:	0f b6 d8             	movzbl %al,%ebx
  800b46:	83 fb 25             	cmp    $0x25,%ebx
  800b49:	75 d2                	jne    800b1d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b4b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b4f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b56:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b64:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b6b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b73:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b77:	0f b6 00             	movzbl (%rax),%eax
  800b7a:	0f b6 d8             	movzbl %al,%ebx
  800b7d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b80:	83 f8 55             	cmp    $0x55,%eax
  800b83:	0f 87 47 04 00 00    	ja     800fd0 <vprintfmt+0x4ee>
  800b89:	89 c0                	mov    %eax,%eax
  800b8b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b92:	00 
  800b93:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  800b9a:	00 00 00 
  800b9d:	48 01 d0             	add    %rdx,%rax
  800ba0:	48 8b 00             	mov    (%rax),%rax
  800ba3:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ba5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ba9:	eb c0                	jmp    800b6b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bab:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800baf:	eb ba                	jmp    800b6b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bb8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bbb:	89 d0                	mov    %edx,%eax
  800bbd:	c1 e0 02             	shl    $0x2,%eax
  800bc0:	01 d0                	add    %edx,%eax
  800bc2:	01 c0                	add    %eax,%eax
  800bc4:	01 d8                	add    %ebx,%eax
  800bc6:	83 e8 30             	sub    $0x30,%eax
  800bc9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bcc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd0:	0f b6 00             	movzbl (%rax),%eax
  800bd3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd6:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd9:	7e 0c                	jle    800be7 <vprintfmt+0x105>
  800bdb:	83 fb 39             	cmp    $0x39,%ebx
  800bde:	7f 07                	jg     800be7 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be5:	eb d1                	jmp    800bb8 <vprintfmt+0xd6>
			goto process_precision;
  800be7:	eb 58                	jmp    800c41 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800be9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bec:	83 f8 30             	cmp    $0x30,%eax
  800bef:	73 17                	jae    800c08 <vprintfmt+0x126>
  800bf1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf8:	89 c0                	mov    %eax,%eax
  800bfa:	48 01 d0             	add    %rdx,%rax
  800bfd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c00:	83 c2 08             	add    $0x8,%edx
  800c03:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c06:	eb 0f                	jmp    800c17 <vprintfmt+0x135>
  800c08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0c:	48 89 d0             	mov    %rdx,%rax
  800c0f:	48 83 c2 08          	add    $0x8,%rdx
  800c13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c17:	8b 00                	mov    (%rax),%eax
  800c19:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c1c:	eb 23                	jmp    800c41 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c22:	79 0c                	jns    800c30 <vprintfmt+0x14e>
				width = 0;
  800c24:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c2b:	e9 3b ff ff ff       	jmpq   800b6b <vprintfmt+0x89>
  800c30:	e9 36 ff ff ff       	jmpq   800b6b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c35:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c3c:	e9 2a ff ff ff       	jmpq   800b6b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c45:	79 12                	jns    800c59 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c47:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c4a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c4d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c54:	e9 12 ff ff ff       	jmpq   800b6b <vprintfmt+0x89>
  800c59:	e9 0d ff ff ff       	jmpq   800b6b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c5e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c62:	e9 04 ff ff ff       	jmpq   800b6b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6a:	83 f8 30             	cmp    $0x30,%eax
  800c6d:	73 17                	jae    800c86 <vprintfmt+0x1a4>
  800c6f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c76:	89 c0                	mov    %eax,%eax
  800c78:	48 01 d0             	add    %rdx,%rax
  800c7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7e:	83 c2 08             	add    $0x8,%edx
  800c81:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c84:	eb 0f                	jmp    800c95 <vprintfmt+0x1b3>
  800c86:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8a:	48 89 d0             	mov    %rdx,%rax
  800c8d:	48 83 c2 08          	add    $0x8,%rdx
  800c91:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c95:	8b 10                	mov    (%rax),%edx
  800c97:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9f:	48 89 ce             	mov    %rcx,%rsi
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	ff d0                	callq  *%rax
			break;
  800ca6:	e9 53 03 00 00       	jmpq   800ffe <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cae:	83 f8 30             	cmp    $0x30,%eax
  800cb1:	73 17                	jae    800cca <vprintfmt+0x1e8>
  800cb3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cba:	89 c0                	mov    %eax,%eax
  800cbc:	48 01 d0             	add    %rdx,%rax
  800cbf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc2:	83 c2 08             	add    $0x8,%edx
  800cc5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc8:	eb 0f                	jmp    800cd9 <vprintfmt+0x1f7>
  800cca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cce:	48 89 d0             	mov    %rdx,%rax
  800cd1:	48 83 c2 08          	add    $0x8,%rdx
  800cd5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cdb:	85 db                	test   %ebx,%ebx
  800cdd:	79 02                	jns    800ce1 <vprintfmt+0x1ff>
				err = -err;
  800cdf:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ce1:	83 fb 15             	cmp    $0x15,%ebx
  800ce4:	7f 16                	jg     800cfc <vprintfmt+0x21a>
  800ce6:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800ced:	00 00 00 
  800cf0:	48 63 d3             	movslq %ebx,%rdx
  800cf3:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cf7:	4d 85 e4             	test   %r12,%r12
  800cfa:	75 2e                	jne    800d2a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cfc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d04:	89 d9                	mov    %ebx,%ecx
  800d06:	48 ba 21 1c 80 00 00 	movabs $0x801c21,%rdx
  800d0d:	00 00 00 
  800d10:	48 89 c7             	mov    %rax,%rdi
  800d13:	b8 00 00 00 00       	mov    $0x0,%eax
  800d18:	49 b8 0d 10 80 00 00 	movabs $0x80100d,%r8
  800d1f:	00 00 00 
  800d22:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d25:	e9 d4 02 00 00       	jmpq   800ffe <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d2a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	4c 89 e1             	mov    %r12,%rcx
  800d35:	48 ba 2a 1c 80 00 00 	movabs $0x801c2a,%rdx
  800d3c:	00 00 00 
  800d3f:	48 89 c7             	mov    %rax,%rdi
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
  800d47:	49 b8 0d 10 80 00 00 	movabs $0x80100d,%r8
  800d4e:	00 00 00 
  800d51:	41 ff d0             	callq  *%r8
			break;
  800d54:	e9 a5 02 00 00       	jmpq   800ffe <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5c:	83 f8 30             	cmp    $0x30,%eax
  800d5f:	73 17                	jae    800d78 <vprintfmt+0x296>
  800d61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d68:	89 c0                	mov    %eax,%eax
  800d6a:	48 01 d0             	add    %rdx,%rax
  800d6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d70:	83 c2 08             	add    $0x8,%edx
  800d73:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d76:	eb 0f                	jmp    800d87 <vprintfmt+0x2a5>
  800d78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d7c:	48 89 d0             	mov    %rdx,%rax
  800d7f:	48 83 c2 08          	add    $0x8,%rdx
  800d83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d87:	4c 8b 20             	mov    (%rax),%r12
  800d8a:	4d 85 e4             	test   %r12,%r12
  800d8d:	75 0a                	jne    800d99 <vprintfmt+0x2b7>
				p = "(null)";
  800d8f:	49 bc 2d 1c 80 00 00 	movabs $0x801c2d,%r12
  800d96:	00 00 00 
			if (width > 0 && padc != '-')
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d9d:	7e 3f                	jle    800dde <vprintfmt+0x2fc>
  800d9f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800da3:	74 39                	je     800dde <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800da5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800da8:	48 98                	cltq   
  800daa:	48 89 c6             	mov    %rax,%rsi
  800dad:	4c 89 e7             	mov    %r12,%rdi
  800db0:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  800db7:	00 00 00 
  800dba:	ff d0                	callq  *%rax
  800dbc:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dbf:	eb 17                	jmp    800dd8 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dc1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dc5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcd:	48 89 ce             	mov    %rcx,%rsi
  800dd0:	89 d7                	mov    %edx,%edi
  800dd2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ddc:	7f e3                	jg     800dc1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dde:	eb 37                	jmp    800e17 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800de0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800de4:	74 1e                	je     800e04 <vprintfmt+0x322>
  800de6:	83 fb 1f             	cmp    $0x1f,%ebx
  800de9:	7e 05                	jle    800df0 <vprintfmt+0x30e>
  800deb:	83 fb 7e             	cmp    $0x7e,%ebx
  800dee:	7e 14                	jle    800e04 <vprintfmt+0x322>
					putch('?', putdat);
  800df0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df8:	48 89 d6             	mov    %rdx,%rsi
  800dfb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e00:	ff d0                	callq  *%rax
  800e02:	eb 0f                	jmp    800e13 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0c:	48 89 d6             	mov    %rdx,%rsi
  800e0f:	89 df                	mov    %ebx,%edi
  800e11:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e13:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e17:	4c 89 e0             	mov    %r12,%rax
  800e1a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e1e:	0f b6 00             	movzbl (%rax),%eax
  800e21:	0f be d8             	movsbl %al,%ebx
  800e24:	85 db                	test   %ebx,%ebx
  800e26:	74 10                	je     800e38 <vprintfmt+0x356>
  800e28:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e2c:	78 b2                	js     800de0 <vprintfmt+0x2fe>
  800e2e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e32:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e36:	79 a8                	jns    800de0 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e38:	eb 16                	jmp    800e50 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e42:	48 89 d6             	mov    %rdx,%rsi
  800e45:	bf 20 00 00 00       	mov    $0x20,%edi
  800e4a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e54:	7f e4                	jg     800e3a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e56:	e9 a3 01 00 00       	jmpq   800ffe <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e5b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e5f:	be 03 00 00 00       	mov    $0x3,%esi
  800e64:	48 89 c7             	mov    %rax,%rdi
  800e67:	48 b8 d2 09 80 00 00 	movabs $0x8009d2,%rax
  800e6e:	00 00 00 
  800e71:	ff d0                	callq  *%rax
  800e73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7b:	48 85 c0             	test   %rax,%rax
  800e7e:	79 1d                	jns    800e9d <vprintfmt+0x3bb>
				putch('-', putdat);
  800e80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e88:	48 89 d6             	mov    %rdx,%rsi
  800e8b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e90:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e96:	48 f7 d8             	neg    %rax
  800e99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e9d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea4:	e9 e8 00 00 00       	jmpq   800f91 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ea9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ead:	be 03 00 00 00       	mov    $0x3,%esi
  800eb2:	48 89 c7             	mov    %rax,%rdi
  800eb5:	48 b8 c2 08 80 00 00 	movabs $0x8008c2,%rax
  800ebc:	00 00 00 
  800ebf:	ff d0                	callq  *%rax
  800ec1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ec5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ecc:	e9 c0 00 00 00       	jmpq   800f91 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed9:	48 89 d6             	mov    %rdx,%rsi
  800edc:	bf 58 00 00 00       	mov    $0x58,%edi
  800ee1:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ee3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eeb:	48 89 d6             	mov    %rdx,%rsi
  800eee:	bf 58 00 00 00       	mov    $0x58,%edi
  800ef3:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ef5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efd:	48 89 d6             	mov    %rdx,%rsi
  800f00:	bf 58 00 00 00       	mov    $0x58,%edi
  800f05:	ff d0                	callq  *%rax
			break;
  800f07:	e9 f2 00 00 00       	jmpq   800ffe <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f14:	48 89 d6             	mov    %rdx,%rsi
  800f17:	bf 30 00 00 00       	mov    $0x30,%edi
  800f1c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f26:	48 89 d6             	mov    %rdx,%rsi
  800f29:	bf 78 00 00 00       	mov    $0x78,%edi
  800f2e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f33:	83 f8 30             	cmp    $0x30,%eax
  800f36:	73 17                	jae    800f4f <vprintfmt+0x46d>
  800f38:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f3f:	89 c0                	mov    %eax,%eax
  800f41:	48 01 d0             	add    %rdx,%rax
  800f44:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f47:	83 c2 08             	add    $0x8,%edx
  800f4a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4d:	eb 0f                	jmp    800f5e <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f4f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f53:	48 89 d0             	mov    %rdx,%rax
  800f56:	48 83 c2 08          	add    $0x8,%rdx
  800f5a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f5e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f65:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f6c:	eb 23                	jmp    800f91 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f6e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f72:	be 03 00 00 00       	mov    $0x3,%esi
  800f77:	48 89 c7             	mov    %rax,%rdi
  800f7a:	48 b8 c2 08 80 00 00 	movabs $0x8008c2,%rax
  800f81:	00 00 00 
  800f84:	ff d0                	callq  *%rax
  800f86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f8a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f91:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f96:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f99:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fa4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa8:	45 89 c1             	mov    %r8d,%r9d
  800fab:	41 89 f8             	mov    %edi,%r8d
  800fae:	48 89 c7             	mov    %rax,%rdi
  800fb1:	48 b8 07 08 80 00 00 	movabs $0x800807,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
			break;
  800fbd:	eb 3f                	jmp    800ffe <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc7:	48 89 d6             	mov    %rdx,%rsi
  800fca:	89 df                	mov    %ebx,%edi
  800fcc:	ff d0                	callq  *%rax
			break;
  800fce:	eb 2e                	jmp    800ffe <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fd0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd8:	48 89 d6             	mov    %rdx,%rsi
  800fdb:	bf 25 00 00 00       	mov    $0x25,%edi
  800fe0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fe2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fe7:	eb 05                	jmp    800fee <vprintfmt+0x50c>
  800fe9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ff2:	48 83 e8 01          	sub    $0x1,%rax
  800ff6:	0f b6 00             	movzbl (%rax),%eax
  800ff9:	3c 25                	cmp    $0x25,%al
  800ffb:	75 ec                	jne    800fe9 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ffd:	90                   	nop
		}
	}
  800ffe:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fff:	e9 30 fb ff ff       	jmpq   800b34 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801004:	48 83 c4 60          	add    $0x60,%rsp
  801008:	5b                   	pop    %rbx
  801009:	41 5c                	pop    %r12
  80100b:	5d                   	pop    %rbp
  80100c:	c3                   	retq   

000000000080100d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80100d:	55                   	push   %rbp
  80100e:	48 89 e5             	mov    %rsp,%rbp
  801011:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801018:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80101f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801026:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80102d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801034:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80103b:	84 c0                	test   %al,%al
  80103d:	74 20                	je     80105f <printfmt+0x52>
  80103f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801043:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801047:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80104b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80104f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801053:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801057:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80105b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80105f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801066:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80106d:	00 00 00 
  801070:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801077:	00 00 00 
  80107a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80107e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801085:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80108c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801093:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80109a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010a1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010a8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010af:	48 89 c7             	mov    %rax,%rdi
  8010b2:	48 b8 e2 0a 80 00 00 	movabs $0x800ae2,%rax
  8010b9:	00 00 00 
  8010bc:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 10          	sub    $0x10,%rsp
  8010c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d3:	8b 40 10             	mov    0x10(%rax),%eax
  8010d6:	8d 50 01             	lea    0x1(%rax),%edx
  8010d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e4:	48 8b 10             	mov    (%rax),%rdx
  8010e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010ef:	48 39 c2             	cmp    %rax,%rdx
  8010f2:	73 17                	jae    80110b <sprintputch+0x4b>
		*b->buf++ = ch;
  8010f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f8:	48 8b 00             	mov    (%rax),%rax
  8010fb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801103:	48 89 0a             	mov    %rcx,(%rdx)
  801106:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801109:	88 10                	mov    %dl,(%rax)
}
  80110b:	c9                   	leaveq 
  80110c:	c3                   	retq   

000000000080110d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80110d:	55                   	push   %rbp
  80110e:	48 89 e5             	mov    %rsp,%rbp
  801111:	48 83 ec 50          	sub    $0x50,%rsp
  801115:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801119:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80111c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801120:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801124:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801128:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80112c:	48 8b 0a             	mov    (%rdx),%rcx
  80112f:	48 89 08             	mov    %rcx,(%rax)
  801132:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801136:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80113e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801142:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801146:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80114a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80114d:	48 98                	cltq   
  80114f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801153:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801157:	48 01 d0             	add    %rdx,%rax
  80115a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80115e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801165:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80116a:	74 06                	je     801172 <vsnprintf+0x65>
  80116c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801170:	7f 07                	jg     801179 <vsnprintf+0x6c>
		return -E_INVAL;
  801172:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801177:	eb 2f                	jmp    8011a8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801179:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80117d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801181:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801185:	48 89 c6             	mov    %rax,%rsi
  801188:	48 bf c0 10 80 00 00 	movabs $0x8010c0,%rdi
  80118f:	00 00 00 
  801192:	48 b8 e2 0a 80 00 00 	movabs $0x800ae2,%rax
  801199:	00 00 00 
  80119c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80119e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011a2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011a5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011a8:	c9                   	leaveq 
  8011a9:	c3                   	retq   

00000000008011aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011aa:	55                   	push   %rbp
  8011ab:	48 89 e5             	mov    %rsp,%rbp
  8011ae:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011bc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011c2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011c9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011d0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011d7:	84 c0                	test   %al,%al
  8011d9:	74 20                	je     8011fb <snprintf+0x51>
  8011db:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011df:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011e3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011e7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011eb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011f3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011f7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011fb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801202:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801209:	00 00 00 
  80120c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801213:	00 00 00 
  801216:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80121a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801221:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801228:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80122f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801236:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80123d:	48 8b 0a             	mov    (%rdx),%rcx
  801240:	48 89 08             	mov    %rcx,(%rax)
  801243:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801247:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80124b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80124f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801253:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80125a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801261:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801267:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80126e:	48 89 c7             	mov    %rax,%rdi
  801271:	48 b8 0d 11 80 00 00 	movabs $0x80110d,%rax
  801278:	00 00 00 
  80127b:	ff d0                	callq  *%rax
  80127d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801283:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 18          	sub    $0x18,%rsp
  801293:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801297:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80129e:	eb 09                	jmp    8012a9 <strlen+0x1e>
		n++;
  8012a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ad:	0f b6 00             	movzbl (%rax),%eax
  8012b0:	84 c0                	test   %al,%al
  8012b2:	75 ec                	jne    8012a0 <strlen+0x15>
		n++;
	return n;
  8012b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012b7:	c9                   	leaveq 
  8012b8:	c3                   	retq   

00000000008012b9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	48 83 ec 20          	sub    $0x20,%rsp
  8012c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012d0:	eb 0e                	jmp    8012e0 <strnlen+0x27>
		n++;
  8012d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012db:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012e0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012e5:	74 0b                	je     8012f2 <strnlen+0x39>
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	0f b6 00             	movzbl (%rax),%eax
  8012ee:	84 c0                	test   %al,%al
  8012f0:	75 e0                	jne    8012d2 <strnlen+0x19>
		n++;
	return n;
  8012f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012f5:	c9                   	leaveq 
  8012f6:	c3                   	retq   

00000000008012f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012f7:	55                   	push   %rbp
  8012f8:	48 89 e5             	mov    %rsp,%rbp
  8012fb:	48 83 ec 20          	sub    $0x20,%rsp
  8012ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801303:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80130f:	90                   	nop
  801310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801314:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801318:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801320:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801324:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801328:	0f b6 12             	movzbl (%rdx),%edx
  80132b:	88 10                	mov    %dl,(%rax)
  80132d:	0f b6 00             	movzbl (%rax),%eax
  801330:	84 c0                	test   %al,%al
  801332:	75 dc                	jne    801310 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801338:	c9                   	leaveq 
  801339:	c3                   	retq   

000000000080133a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80133a:	55                   	push   %rbp
  80133b:	48 89 e5             	mov    %rsp,%rbp
  80133e:	48 83 ec 20          	sub    $0x20,%rsp
  801342:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80134a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134e:	48 89 c7             	mov    %rax,%rdi
  801351:	48 b8 8b 12 80 00 00 	movabs $0x80128b,%rax
  801358:	00 00 00 
  80135b:	ff d0                	callq  *%rax
  80135d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801360:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801363:	48 63 d0             	movslq %eax,%rdx
  801366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136a:	48 01 c2             	add    %rax,%rdx
  80136d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801371:	48 89 c6             	mov    %rax,%rsi
  801374:	48 89 d7             	mov    %rdx,%rdi
  801377:	48 b8 f7 12 80 00 00 	movabs $0x8012f7,%rax
  80137e:	00 00 00 
  801381:	ff d0                	callq  *%rax
	return dst;
  801383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801387:	c9                   	leaveq 
  801388:	c3                   	retq   

0000000000801389 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	48 83 ec 28          	sub    $0x28,%rsp
  801391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80139d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013a5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013ac:	00 
  8013ad:	eb 2a                	jmp    8013d9 <strncpy+0x50>
		*dst++ = *src;
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013bf:	0f b6 12             	movzbl (%rdx),%edx
  8013c2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 05                	je     8013d4 <strncpy+0x4b>
			src++;
  8013cf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013e1:	72 cc                	jb     8013af <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013e7:	c9                   	leaveq 
  8013e8:	c3                   	retq   

00000000008013e9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013e9:	55                   	push   %rbp
  8013ea:	48 89 e5             	mov    %rsp,%rbp
  8013ed:	48 83 ec 28          	sub    $0x28,%rsp
  8013f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801401:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801405:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80140a:	74 3d                	je     801449 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80140c:	eb 1d                	jmp    80142b <strlcpy+0x42>
			*dst++ = *src++;
  80140e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801412:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801416:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80141a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80141e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801422:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801426:	0f b6 12             	movzbl (%rdx),%edx
  801429:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80142b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801430:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801435:	74 0b                	je     801442 <strlcpy+0x59>
  801437:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143b:	0f b6 00             	movzbl (%rax),%eax
  80143e:	84 c0                	test   %al,%al
  801440:	75 cc                	jne    80140e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801446:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801449:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80144d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801451:	48 29 c2             	sub    %rax,%rdx
  801454:	48 89 d0             	mov    %rdx,%rax
}
  801457:	c9                   	leaveq 
  801458:	c3                   	retq   

0000000000801459 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801459:	55                   	push   %rbp
  80145a:	48 89 e5             	mov    %rsp,%rbp
  80145d:	48 83 ec 10          	sub    $0x10,%rsp
  801461:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801465:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801469:	eb 0a                	jmp    801475 <strcmp+0x1c>
		p++, q++;
  80146b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801470:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	0f b6 00             	movzbl (%rax),%eax
  80147c:	84 c0                	test   %al,%al
  80147e:	74 12                	je     801492 <strcmp+0x39>
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	0f b6 10             	movzbl (%rax),%edx
  801487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148b:	0f b6 00             	movzbl (%rax),%eax
  80148e:	38 c2                	cmp    %al,%dl
  801490:	74 d9                	je     80146b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	0f b6 d0             	movzbl %al,%edx
  80149c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	0f b6 c0             	movzbl %al,%eax
  8014a6:	29 c2                	sub    %eax,%edx
  8014a8:	89 d0                	mov    %edx,%eax
}
  8014aa:	c9                   	leaveq 
  8014ab:	c3                   	retq   

00000000008014ac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014ac:	55                   	push   %rbp
  8014ad:	48 89 e5             	mov    %rsp,%rbp
  8014b0:	48 83 ec 18          	sub    $0x18,%rsp
  8014b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014c0:	eb 0f                	jmp    8014d1 <strncmp+0x25>
		n--, p++, q++;
  8014c2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d6:	74 1d                	je     8014f5 <strncmp+0x49>
  8014d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	84 c0                	test   %al,%al
  8014e1:	74 12                	je     8014f5 <strncmp+0x49>
  8014e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e7:	0f b6 10             	movzbl (%rax),%edx
  8014ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	38 c2                	cmp    %al,%dl
  8014f3:	74 cd                	je     8014c2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014fa:	75 07                	jne    801503 <strncmp+0x57>
		return 0;
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	eb 18                	jmp    80151b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	0f b6 d0             	movzbl %al,%edx
  80150d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	c9                   	leaveq 
  80151c:	c3                   	retq   

000000000080151d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80151d:	55                   	push   %rbp
  80151e:	48 89 e5             	mov    %rsp,%rbp
  801521:	48 83 ec 0c          	sub    $0xc,%rsp
  801525:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801529:	89 f0                	mov    %esi,%eax
  80152b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80152e:	eb 17                	jmp    801547 <strchr+0x2a>
		if (*s == c)
  801530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80153a:	75 06                	jne    801542 <strchr+0x25>
			return (char *) s;
  80153c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801540:	eb 15                	jmp    801557 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801542:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	84 c0                	test   %al,%al
  801550:	75 de                	jne    801530 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801557:	c9                   	leaveq 
  801558:	c3                   	retq   

0000000000801559 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801559:	55                   	push   %rbp
  80155a:	48 89 e5             	mov    %rsp,%rbp
  80155d:	48 83 ec 0c          	sub    $0xc,%rsp
  801561:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801565:	89 f0                	mov    %esi,%eax
  801567:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80156a:	eb 13                	jmp    80157f <strfind+0x26>
		if (*s == c)
  80156c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801570:	0f b6 00             	movzbl (%rax),%eax
  801573:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801576:	75 02                	jne    80157a <strfind+0x21>
			break;
  801578:	eb 10                	jmp    80158a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80157a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80157f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801583:	0f b6 00             	movzbl (%rax),%eax
  801586:	84 c0                	test   %al,%al
  801588:	75 e2                	jne    80156c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80158a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 83 ec 18          	sub    $0x18,%rsp
  801598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80159f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a8:	75 06                	jne    8015b0 <memset+0x20>
		return v;
  8015aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ae:	eb 69                	jmp    801619 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b4:	83 e0 03             	and    $0x3,%eax
  8015b7:	48 85 c0             	test   %rax,%rax
  8015ba:	75 48                	jne    801604 <memset+0x74>
  8015bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c0:	83 e0 03             	and    $0x3,%eax
  8015c3:	48 85 c0             	test   %rax,%rax
  8015c6:	75 3c                	jne    801604 <memset+0x74>
		c &= 0xFF;
  8015c8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d2:	c1 e0 18             	shl    $0x18,%eax
  8015d5:	89 c2                	mov    %eax,%edx
  8015d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015da:	c1 e0 10             	shl    $0x10,%eax
  8015dd:	09 c2                	or     %eax,%edx
  8015df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e2:	c1 e0 08             	shl    $0x8,%eax
  8015e5:	09 d0                	or     %edx,%eax
  8015e7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ee:	48 c1 e8 02          	shr    $0x2,%rax
  8015f2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fc:	48 89 d7             	mov    %rdx,%rdi
  8015ff:	fc                   	cld    
  801600:	f3 ab                	rep stos %eax,%es:(%rdi)
  801602:	eb 11                	jmp    801615 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801604:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801608:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80160f:	48 89 d7             	mov    %rdx,%rdi
  801612:	fc                   	cld    
  801613:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801619:	c9                   	leaveq 
  80161a:	c3                   	retq   

000000000080161b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80161b:	55                   	push   %rbp
  80161c:	48 89 e5             	mov    %rsp,%rbp
  80161f:	48 83 ec 28          	sub    $0x28,%rsp
  801623:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801627:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80162b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80162f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801633:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80163f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801643:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801647:	0f 83 88 00 00 00    	jae    8016d5 <memmove+0xba>
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801655:	48 01 d0             	add    %rdx,%rax
  801658:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80165c:	76 77                	jbe    8016d5 <memmove+0xba>
		s += n;
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80166e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801672:	83 e0 03             	and    $0x3,%eax
  801675:	48 85 c0             	test   %rax,%rax
  801678:	75 3b                	jne    8016b5 <memmove+0x9a>
  80167a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167e:	83 e0 03             	and    $0x3,%eax
  801681:	48 85 c0             	test   %rax,%rax
  801684:	75 2f                	jne    8016b5 <memmove+0x9a>
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	83 e0 03             	and    $0x3,%eax
  80168d:	48 85 c0             	test   %rax,%rax
  801690:	75 23                	jne    8016b5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801696:	48 83 e8 04          	sub    $0x4,%rax
  80169a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169e:	48 83 ea 04          	sub    $0x4,%rdx
  8016a2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016a6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016aa:	48 89 c7             	mov    %rax,%rdi
  8016ad:	48 89 d6             	mov    %rdx,%rsi
  8016b0:	fd                   	std    
  8016b1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016b3:	eb 1d                	jmp    8016d2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c9:	48 89 d7             	mov    %rdx,%rdi
  8016cc:	48 89 c1             	mov    %rax,%rcx
  8016cf:	fd                   	std    
  8016d0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016d2:	fc                   	cld    
  8016d3:	eb 57                	jmp    80172c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d9:	83 e0 03             	and    $0x3,%eax
  8016dc:	48 85 c0             	test   %rax,%rax
  8016df:	75 36                	jne    801717 <memmove+0xfc>
  8016e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e5:	83 e0 03             	and    $0x3,%eax
  8016e8:	48 85 c0             	test   %rax,%rax
  8016eb:	75 2a                	jne    801717 <memmove+0xfc>
  8016ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f1:	83 e0 03             	and    $0x3,%eax
  8016f4:	48 85 c0             	test   %rax,%rax
  8016f7:	75 1e                	jne    801717 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	48 c1 e8 02          	shr    $0x2,%rax
  801701:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801708:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170c:	48 89 c7             	mov    %rax,%rdi
  80170f:	48 89 d6             	mov    %rdx,%rsi
  801712:	fc                   	cld    
  801713:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801715:	eb 15                	jmp    80172c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801723:	48 89 c7             	mov    %rax,%rdi
  801726:	48 89 d6             	mov    %rdx,%rsi
  801729:	fc                   	cld    
  80172a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80172c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801730:	c9                   	leaveq 
  801731:	c3                   	retq   

0000000000801732 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801732:	55                   	push   %rbp
  801733:	48 89 e5             	mov    %rsp,%rbp
  801736:	48 83 ec 18          	sub    $0x18,%rsp
  80173a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80173e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801742:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80174a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80174e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801752:	48 89 ce             	mov    %rcx,%rsi
  801755:	48 89 c7             	mov    %rax,%rdi
  801758:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  80175f:	00 00 00 
  801762:	ff d0                	callq  *%rax
}
  801764:	c9                   	leaveq 
  801765:	c3                   	retq   

0000000000801766 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801766:	55                   	push   %rbp
  801767:	48 89 e5             	mov    %rsp,%rbp
  80176a:	48 83 ec 28          	sub    $0x28,%rsp
  80176e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801772:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801776:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80177a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801782:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801786:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80178a:	eb 36                	jmp    8017c2 <memcmp+0x5c>
		if (*s1 != *s2)
  80178c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801790:	0f b6 10             	movzbl (%rax),%edx
  801793:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801797:	0f b6 00             	movzbl (%rax),%eax
  80179a:	38 c2                	cmp    %al,%dl
  80179c:	74 1a                	je     8017b8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80179e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	0f b6 d0             	movzbl %al,%edx
  8017a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	0f b6 c0             	movzbl %al,%eax
  8017b2:	29 c2                	sub    %eax,%edx
  8017b4:	89 d0                	mov    %edx,%eax
  8017b6:	eb 20                	jmp    8017d8 <memcmp+0x72>
		s1++, s2++;
  8017b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017bd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017ce:	48 85 c0             	test   %rax,%rax
  8017d1:	75 b9                	jne    80178c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d8:	c9                   	leaveq 
  8017d9:	c3                   	retq   

00000000008017da <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	48 83 ec 28          	sub    $0x28,%rsp
  8017e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f5:	48 01 d0             	add    %rdx,%rax
  8017f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017fc:	eb 15                	jmp    801813 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801802:	0f b6 10             	movzbl (%rax),%edx
  801805:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801808:	38 c2                	cmp    %al,%dl
  80180a:	75 02                	jne    80180e <memfind+0x34>
			break;
  80180c:	eb 0f                	jmp    80181d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80180e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801817:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80181b:	72 e1                	jb     8017fe <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801821:	c9                   	leaveq 
  801822:	c3                   	retq   

0000000000801823 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 34          	sub    $0x34,%rsp
  80182b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80182f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801833:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80183d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801844:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801845:	eb 05                	jmp    80184c <strtol+0x29>
		s++;
  801847:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801850:	0f b6 00             	movzbl (%rax),%eax
  801853:	3c 20                	cmp    $0x20,%al
  801855:	74 f0                	je     801847 <strtol+0x24>
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	3c 09                	cmp    $0x9,%al
  801860:	74 e5                	je     801847 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801866:	0f b6 00             	movzbl (%rax),%eax
  801869:	3c 2b                	cmp    $0x2b,%al
  80186b:	75 07                	jne    801874 <strtol+0x51>
		s++;
  80186d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801872:	eb 17                	jmp    80188b <strtol+0x68>
	else if (*s == '-')
  801874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801878:	0f b6 00             	movzbl (%rax),%eax
  80187b:	3c 2d                	cmp    $0x2d,%al
  80187d:	75 0c                	jne    80188b <strtol+0x68>
		s++, neg = 1;
  80187f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801884:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80188f:	74 06                	je     801897 <strtol+0x74>
  801891:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801895:	75 28                	jne    8018bf <strtol+0x9c>
  801897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	3c 30                	cmp    $0x30,%al
  8018a0:	75 1d                	jne    8018bf <strtol+0x9c>
  8018a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a6:	48 83 c0 01          	add    $0x1,%rax
  8018aa:	0f b6 00             	movzbl (%rax),%eax
  8018ad:	3c 78                	cmp    $0x78,%al
  8018af:	75 0e                	jne    8018bf <strtol+0x9c>
		s += 2, base = 16;
  8018b1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018b6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018bd:	eb 2c                	jmp    8018eb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c3:	75 19                	jne    8018de <strtol+0xbb>
  8018c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	3c 30                	cmp    $0x30,%al
  8018ce:	75 0e                	jne    8018de <strtol+0xbb>
		s++, base = 8;
  8018d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018dc:	eb 0d                	jmp    8018eb <strtol+0xc8>
	else if (base == 0)
  8018de:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e2:	75 07                	jne    8018eb <strtol+0xc8>
		base = 10;
  8018e4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ef:	0f b6 00             	movzbl (%rax),%eax
  8018f2:	3c 2f                	cmp    $0x2f,%al
  8018f4:	7e 1d                	jle    801913 <strtol+0xf0>
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	0f b6 00             	movzbl (%rax),%eax
  8018fd:	3c 39                	cmp    $0x39,%al
  8018ff:	7f 12                	jg     801913 <strtol+0xf0>
			dig = *s - '0';
  801901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801905:	0f b6 00             	movzbl (%rax),%eax
  801908:	0f be c0             	movsbl %al,%eax
  80190b:	83 e8 30             	sub    $0x30,%eax
  80190e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801911:	eb 4e                	jmp    801961 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801917:	0f b6 00             	movzbl (%rax),%eax
  80191a:	3c 60                	cmp    $0x60,%al
  80191c:	7e 1d                	jle    80193b <strtol+0x118>
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	0f b6 00             	movzbl (%rax),%eax
  801925:	3c 7a                	cmp    $0x7a,%al
  801927:	7f 12                	jg     80193b <strtol+0x118>
			dig = *s - 'a' + 10;
  801929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192d:	0f b6 00             	movzbl (%rax),%eax
  801930:	0f be c0             	movsbl %al,%eax
  801933:	83 e8 57             	sub    $0x57,%eax
  801936:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801939:	eb 26                	jmp    801961 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	3c 40                	cmp    $0x40,%al
  801944:	7e 48                	jle    80198e <strtol+0x16b>
  801946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	3c 5a                	cmp    $0x5a,%al
  80194f:	7f 3d                	jg     80198e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801955:	0f b6 00             	movzbl (%rax),%eax
  801958:	0f be c0             	movsbl %al,%eax
  80195b:	83 e8 37             	sub    $0x37,%eax
  80195e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801961:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801964:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801967:	7c 02                	jl     80196b <strtol+0x148>
			break;
  801969:	eb 23                	jmp    80198e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80196b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801970:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801973:	48 98                	cltq   
  801975:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80197a:	48 89 c2             	mov    %rax,%rdx
  80197d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801980:	48 98                	cltq   
  801982:	48 01 d0             	add    %rdx,%rax
  801985:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801989:	e9 5d ff ff ff       	jmpq   8018eb <strtol+0xc8>

	if (endptr)
  80198e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801993:	74 0b                	je     8019a0 <strtol+0x17d>
		*endptr = (char *) s;
  801995:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801999:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80199d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a4:	74 09                	je     8019af <strtol+0x18c>
  8019a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019aa:	48 f7 d8             	neg    %rax
  8019ad:	eb 04                	jmp    8019b3 <strtol+0x190>
  8019af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019b3:	c9                   	leaveq 
  8019b4:	c3                   	retq   

00000000008019b5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019b5:	55                   	push   %rbp
  8019b6:	48 89 e5             	mov    %rsp,%rbp
  8019b9:	48 83 ec 30          	sub    $0x30,%rsp
  8019bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019cd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019d1:	0f b6 00             	movzbl (%rax),%eax
  8019d4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019d7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019db:	75 06                	jne    8019e3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e1:	eb 6b                	jmp    801a4e <strstr+0x99>

	len = strlen(str);
  8019e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e7:	48 89 c7             	mov    %rax,%rdi
  8019ea:	48 b8 8b 12 80 00 00 	movabs $0x80128b,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
  8019f6:	48 98                	cltq   
  8019f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a00:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a08:	0f b6 00             	movzbl (%rax),%eax
  801a0b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a0e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a12:	75 07                	jne    801a1b <strstr+0x66>
				return (char *) 0;
  801a14:	b8 00 00 00 00       	mov    $0x0,%eax
  801a19:	eb 33                	jmp    801a4e <strstr+0x99>
		} while (sc != c);
  801a1b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a1f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a22:	75 d8                	jne    8019fc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a28:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a30:	48 89 ce             	mov    %rcx,%rsi
  801a33:	48 89 c7             	mov    %rax,%rdi
  801a36:	48 b8 ac 14 80 00 00 	movabs $0x8014ac,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	callq  *%rax
  801a42:	85 c0                	test   %eax,%eax
  801a44:	75 b6                	jne    8019fc <strstr+0x47>

	return (char *) (in - 1);
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	48 83 e8 01          	sub    $0x1,%rax
}
  801a4e:	c9                   	leaveq 
  801a4f:	c3                   	retq   
