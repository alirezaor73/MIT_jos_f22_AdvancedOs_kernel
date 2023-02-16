
obj/user/faultwrite:     file format elf64-x86-64


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
  80003c:	e8 1e 00 00 00       	callq  80005f <libmain>
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
	*(unsigned*)0 = 0;
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80005d:	c9                   	leaveq 
  80005e:	c3                   	retq   

000000000080005f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005f:	55                   	push   %rbp
  800060:	48 89 e5             	mov    %rsp,%rbp
  800063:	48 83 ec 20          	sub    $0x20,%rsp
  800067:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80006a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80006e:	48 b8 6d 02 80 00 00 	movabs $0x80026d,%rax
  800075:	00 00 00 
  800078:	ff d0                	callq  *%rax
  80007a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  80007d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800080:	25 ff 03 00 00       	and    $0x3ff,%eax
  800085:	48 63 d0             	movslq %eax,%rdx
  800088:	48 89 d0             	mov    %rdx,%rax
  80008b:	48 c1 e0 03          	shl    $0x3,%rax
  80008f:	48 01 d0             	add    %rdx,%rax
  800092:	48 c1 e0 05          	shl    $0x5,%rax
  800096:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80009d:	00 00 00 
  8000a0:	48 01 c2             	add    %rax,%rdx
  8000a3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000aa:	00 00 00 
  8000ad:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000b4:	7e 14                	jle    8000ca <libmain+0x6b>
		binaryname = argv[0];
  8000b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000ba:	48 8b 10             	mov    (%rax),%rdx
  8000bd:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000c4:	00 00 00 
  8000c7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d1:	48 89 d6             	mov    %rdx,%rsi
  8000d4:	89 c7                	mov    %eax,%edi
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000e2:	48 b8 f0 00 80 00 00 	movabs $0x8000f0,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
}
  8000ee:	c9                   	leaveq 
  8000ef:	c3                   	retq   

00000000008000f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f0:	55                   	push   %rbp
  8000f1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8000f4:	48 b8 97 08 80 00 00 	movabs $0x800897,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800100:	bf 00 00 00 00       	mov    $0x0,%edi
  800105:	48 b8 29 02 80 00 00 	movabs $0x800229,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	callq  *%rax
}
  800111:	5d                   	pop    %rbp
  800112:	c3                   	retq   

0000000000800113 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800113:	55                   	push   %rbp
  800114:	48 89 e5             	mov    %rsp,%rbp
  800117:	53                   	push   %rbx
  800118:	48 83 ec 48          	sub    $0x48,%rsp
  80011c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80011f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800122:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800126:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80012a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80012e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800132:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800135:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800139:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80013d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800141:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800145:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800149:	4c 89 c3             	mov    %r8,%rbx
  80014c:	cd 30                	int    $0x30
  80014e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800152:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800156:	74 3e                	je     800196 <syscall+0x83>
  800158:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80015d:	7e 37                	jle    800196 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80015f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800163:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800166:	49 89 d0             	mov    %rdx,%r8
  800169:	89 c1                	mov    %eax,%ecx
  80016b:	48 ba ea 35 80 00 00 	movabs $0x8035ea,%rdx
  800172:	00 00 00 
  800175:	be 23 00 00 00       	mov    $0x23,%esi
  80017a:	48 bf 07 36 80 00 00 	movabs $0x803607,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	49 b9 1b 1e 80 00 00 	movabs $0x801e1b,%r9
  800190:	00 00 00 
  800193:	41 ff d1             	callq  *%r9

	return ret;
  800196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80019a:	48 83 c4 48          	add    $0x48,%rsp
  80019e:	5b                   	pop    %rbx
  80019f:	5d                   	pop    %rbp
  8001a0:	c3                   	retq   

00000000008001a1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	48 83 ec 20          	sub    $0x20,%rsp
  8001a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c0:	00 
  8001c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001cd:	48 89 d1             	mov    %rdx,%rcx
  8001d0:	48 89 c2             	mov    %rax,%rdx
  8001d3:	be 00 00 00 00       	mov    $0x0,%esi
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
}
  8001e9:	c9                   	leaveq 
  8001ea:	c3                   	retq   

00000000008001eb <sys_cgetc>:

int
sys_cgetc(void)
{
  8001eb:	55                   	push   %rbp
  8001ec:	48 89 e5             	mov    %rsp,%rbp
  8001ef:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001fa:	00 
  8001fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800201:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800207:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020c:	ba 00 00 00 00       	mov    $0x0,%edx
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	bf 01 00 00 00       	mov    $0x1,%edi
  80021b:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  800222:	00 00 00 
  800225:	ff d0                	callq  *%rax
}
  800227:	c9                   	leaveq 
  800228:	c3                   	retq   

0000000000800229 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800229:	55                   	push   %rbp
  80022a:	48 89 e5             	mov    %rsp,%rbp
  80022d:	48 83 ec 10          	sub    $0x10,%rsp
  800231:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800234:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800237:	48 98                	cltq   
  800239:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800240:	00 
  800241:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800247:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80024d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800252:	48 89 c2             	mov    %rax,%rdx
  800255:	be 01 00 00 00       	mov    $0x1,%esi
  80025a:	bf 03 00 00 00       	mov    $0x3,%edi
  80025f:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  800266:	00 00 00 
  800269:	ff d0                	callq  *%rax
}
  80026b:	c9                   	leaveq 
  80026c:	c3                   	retq   

000000000080026d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80026d:	55                   	push   %rbp
  80026e:	48 89 e5             	mov    %rsp,%rbp
  800271:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800275:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027c:	00 
  80027d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800283:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800289:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028e:	ba 00 00 00 00       	mov    $0x0,%edx
  800293:	be 00 00 00 00       	mov    $0x0,%esi
  800298:	bf 02 00 00 00       	mov    $0x2,%edi
  80029d:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  8002a4:	00 00 00 
  8002a7:	ff d0                	callq  *%rax
}
  8002a9:	c9                   	leaveq 
  8002aa:	c3                   	retq   

00000000008002ab <sys_yield>:

void
sys_yield(void)
{
  8002ab:	55                   	push   %rbp
  8002ac:	48 89 e5             	mov    %rsp,%rbp
  8002af:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002ba:	00 
  8002bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d1:	be 00 00 00 00       	mov    $0x0,%esi
  8002d6:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002db:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  8002e2:	00 00 00 
  8002e5:	ff d0                	callq  *%rax
}
  8002e7:	c9                   	leaveq 
  8002e8:	c3                   	retq   

00000000008002e9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002e9:	55                   	push   %rbp
  8002ea:	48 89 e5             	mov    %rsp,%rbp
  8002ed:	48 83 ec 20          	sub    $0x20,%rsp
  8002f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002fe:	48 63 c8             	movslq %eax,%rcx
  800301:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800308:	48 98                	cltq   
  80030a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800311:	00 
  800312:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800318:	49 89 c8             	mov    %rcx,%r8
  80031b:	48 89 d1             	mov    %rdx,%rcx
  80031e:	48 89 c2             	mov    %rax,%rdx
  800321:	be 01 00 00 00       	mov    $0x1,%esi
  800326:	bf 04 00 00 00       	mov    $0x4,%edi
  80032b:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  800332:	00 00 00 
  800335:	ff d0                	callq  *%rax
}
  800337:	c9                   	leaveq 
  800338:	c3                   	retq   

0000000000800339 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800339:	55                   	push   %rbp
  80033a:	48 89 e5             	mov    %rsp,%rbp
  80033d:	48 83 ec 30          	sub    $0x30,%rsp
  800341:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800344:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800348:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80034b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80034f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800353:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800356:	48 63 c8             	movslq %eax,%rcx
  800359:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80035d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800360:	48 63 f0             	movslq %eax,%rsi
  800363:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800367:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80036a:	48 98                	cltq   
  80036c:	48 89 0c 24          	mov    %rcx,(%rsp)
  800370:	49 89 f9             	mov    %rdi,%r9
  800373:	49 89 f0             	mov    %rsi,%r8
  800376:	48 89 d1             	mov    %rdx,%rcx
  800379:	48 89 c2             	mov    %rax,%rdx
  80037c:	be 01 00 00 00       	mov    $0x1,%esi
  800381:	bf 05 00 00 00       	mov    $0x5,%edi
  800386:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
}
  800392:	c9                   	leaveq 
  800393:	c3                   	retq   

0000000000800394 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800394:	55                   	push   %rbp
  800395:	48 89 e5             	mov    %rsp,%rbp
  800398:	48 83 ec 20          	sub    $0x20,%rsp
  80039c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003aa:	48 98                	cltq   
  8003ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003b3:	00 
  8003b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003c0:	48 89 d1             	mov    %rdx,%rcx
  8003c3:	48 89 c2             	mov    %rax,%rdx
  8003c6:	be 01 00 00 00       	mov    $0x1,%esi
  8003cb:	bf 06 00 00 00       	mov    $0x6,%edi
  8003d0:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
}
  8003dc:	c9                   	leaveq 
  8003dd:	c3                   	retq   

00000000008003de <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
  8003e2:	48 83 ec 10          	sub    $0x10,%rsp
  8003e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ef:	48 63 d0             	movslq %eax,%rdx
  8003f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f5:	48 98                	cltq   
  8003f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003fe:	00 
  8003ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800405:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80040b:	48 89 d1             	mov    %rdx,%rcx
  80040e:	48 89 c2             	mov    %rax,%rdx
  800411:	be 01 00 00 00       	mov    $0x1,%esi
  800416:	bf 08 00 00 00       	mov    $0x8,%edi
  80041b:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  800422:	00 00 00 
  800425:	ff d0                	callq  *%rax
}
  800427:	c9                   	leaveq 
  800428:	c3                   	retq   

0000000000800429 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800429:	55                   	push   %rbp
  80042a:	48 89 e5             	mov    %rsp,%rbp
  80042d:	48 83 ec 20          	sub    $0x20,%rsp
  800431:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800434:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800438:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043f:	48 98                	cltq   
  800441:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800448:	00 
  800449:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80044f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800455:	48 89 d1             	mov    %rdx,%rcx
  800458:	48 89 c2             	mov    %rax,%rdx
  80045b:	be 01 00 00 00       	mov    $0x1,%esi
  800460:	bf 09 00 00 00       	mov    $0x9,%edi
  800465:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  80046c:	00 00 00 
  80046f:	ff d0                	callq  *%rax
}
  800471:	c9                   	leaveq 
  800472:	c3                   	retq   

0000000000800473 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800473:	55                   	push   %rbp
  800474:	48 89 e5             	mov    %rsp,%rbp
  800477:	48 83 ec 20          	sub    $0x20,%rsp
  80047b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800482:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800489:	48 98                	cltq   
  80048b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800492:	00 
  800493:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800499:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80049f:	48 89 d1             	mov    %rdx,%rcx
  8004a2:	48 89 c2             	mov    %rax,%rdx
  8004a5:	be 01 00 00 00       	mov    $0x1,%esi
  8004aa:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004af:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  8004b6:	00 00 00 
  8004b9:	ff d0                	callq  *%rax
}
  8004bb:	c9                   	leaveq 
  8004bc:	c3                   	retq   

00000000008004bd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004bd:	55                   	push   %rbp
  8004be:	48 89 e5             	mov    %rsp,%rbp
  8004c1:	48 83 ec 20          	sub    $0x20,%rsp
  8004c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004cc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004d0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004d6:	48 63 f0             	movslq %eax,%rsi
  8004d9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e0:	48 98                	cltq   
  8004e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ed:	00 
  8004ee:	49 89 f1             	mov    %rsi,%r9
  8004f1:	49 89 c8             	mov    %rcx,%r8
  8004f4:	48 89 d1             	mov    %rdx,%rcx
  8004f7:	48 89 c2             	mov    %rax,%rdx
  8004fa:	be 00 00 00 00       	mov    $0x0,%esi
  8004ff:	bf 0c 00 00 00       	mov    $0xc,%edi
  800504:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  80050b:	00 00 00 
  80050e:	ff d0                	callq  *%rax
}
  800510:	c9                   	leaveq 
  800511:	c3                   	retq   

0000000000800512 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800512:	55                   	push   %rbp
  800513:	48 89 e5             	mov    %rsp,%rbp
  800516:	48 83 ec 10          	sub    $0x10,%rsp
  80051a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80051e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800522:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800529:	00 
  80052a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800530:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800536:	b9 00 00 00 00       	mov    $0x0,%ecx
  80053b:	48 89 c2             	mov    %rax,%rdx
  80053e:	be 01 00 00 00       	mov    $0x1,%esi
  800543:	bf 0d 00 00 00       	mov    $0xd,%edi
  800548:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  80054f:	00 00 00 
  800552:	ff d0                	callq  *%rax
}
  800554:	c9                   	leaveq 
  800555:	c3                   	retq   

0000000000800556 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800556:	55                   	push   %rbp
  800557:	48 89 e5             	mov    %rsp,%rbp
  80055a:	48 83 ec 08          	sub    $0x8,%rsp
  80055e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800562:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800566:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80056d:	ff ff ff 
  800570:	48 01 d0             	add    %rdx,%rax
  800573:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800577:	c9                   	leaveq 
  800578:	c3                   	retq   

0000000000800579 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800579:	55                   	push   %rbp
  80057a:	48 89 e5             	mov    %rsp,%rbp
  80057d:	48 83 ec 08          	sub    $0x8,%rsp
  800581:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800585:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800589:	48 89 c7             	mov    %rax,%rdi
  80058c:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  800593:	00 00 00 
  800596:	ff d0                	callq  *%rax
  800598:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80059e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005a2:	c9                   	leaveq 
  8005a3:	c3                   	retq   

00000000008005a4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005a4:	55                   	push   %rbp
  8005a5:	48 89 e5             	mov    %rsp,%rbp
  8005a8:	48 83 ec 18          	sub    $0x18,%rsp
  8005ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005b7:	eb 6b                	jmp    800624 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005bc:	48 98                	cltq   
  8005be:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005c4:	48 c1 e0 0c          	shl    $0xc,%rax
  8005c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005d0:	48 c1 e8 15          	shr    $0x15,%rax
  8005d4:	48 89 c2             	mov    %rax,%rdx
  8005d7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005de:	01 00 00 
  8005e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e5:	83 e0 01             	and    $0x1,%eax
  8005e8:	48 85 c0             	test   %rax,%rax
  8005eb:	74 21                	je     80060e <fd_alloc+0x6a>
  8005ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8005f5:	48 89 c2             	mov    %rax,%rdx
  8005f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005ff:	01 00 00 
  800602:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800606:	83 e0 01             	and    $0x1,%eax
  800609:	48 85 c0             	test   %rax,%rax
  80060c:	75 12                	jne    800620 <fd_alloc+0x7c>
			*fd_store = fd;
  80060e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800612:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800616:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	eb 1a                	jmp    80063a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800620:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800624:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800628:	7e 8f                	jle    8005b9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80062a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800635:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80063a:	c9                   	leaveq 
  80063b:	c3                   	retq   

000000000080063c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80063c:	55                   	push   %rbp
  80063d:	48 89 e5             	mov    %rsp,%rbp
  800640:	48 83 ec 20          	sub    $0x20,%rsp
  800644:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800647:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80064b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80064f:	78 06                	js     800657 <fd_lookup+0x1b>
  800651:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800655:	7e 07                	jle    80065e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80065c:	eb 6c                	jmp    8006ca <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80065e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800661:	48 98                	cltq   
  800663:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800669:	48 c1 e0 0c          	shl    $0xc,%rax
  80066d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800675:	48 c1 e8 15          	shr    $0x15,%rax
  800679:	48 89 c2             	mov    %rax,%rdx
  80067c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800683:	01 00 00 
  800686:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80068a:	83 e0 01             	and    $0x1,%eax
  80068d:	48 85 c0             	test   %rax,%rax
  800690:	74 21                	je     8006b3 <fd_lookup+0x77>
  800692:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800696:	48 c1 e8 0c          	shr    $0xc,%rax
  80069a:	48 89 c2             	mov    %rax,%rdx
  80069d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006a4:	01 00 00 
  8006a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006ab:	83 e0 01             	and    $0x1,%eax
  8006ae:	48 85 c0             	test   %rax,%rax
  8006b1:	75 07                	jne    8006ba <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b8:	eb 10                	jmp    8006ca <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006c2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ca:	c9                   	leaveq 
  8006cb:	c3                   	retq   

00000000008006cc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006cc:	55                   	push   %rbp
  8006cd:	48 89 e5             	mov    %rsp,%rbp
  8006d0:	48 83 ec 30          	sub    $0x30,%rsp
  8006d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006d8:	89 f0                	mov    %esi,%eax
  8006da:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006e1:	48 89 c7             	mov    %rax,%rdi
  8006e4:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  8006eb:	00 00 00 
  8006ee:	ff d0                	callq  *%rax
  8006f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8006f4:	48 89 d6             	mov    %rdx,%rsi
  8006f7:	89 c7                	mov    %eax,%edi
  8006f9:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800700:	00 00 00 
  800703:	ff d0                	callq  *%rax
  800705:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800708:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070c:	78 0a                	js     800718 <fd_close+0x4c>
	    || fd != fd2)
  80070e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800712:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800716:	74 12                	je     80072a <fd_close+0x5e>
		return (must_exist ? r : 0);
  800718:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80071c:	74 05                	je     800723 <fd_close+0x57>
  80071e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800721:	eb 05                	jmp    800728 <fd_close+0x5c>
  800723:	b8 00 00 00 00       	mov    $0x0,%eax
  800728:	eb 69                	jmp    800793 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80072a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80072e:	8b 00                	mov    (%rax),%eax
  800730:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800734:	48 89 d6             	mov    %rdx,%rsi
  800737:	89 c7                	mov    %eax,%edi
  800739:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800740:	00 00 00 
  800743:	ff d0                	callq  *%rax
  800745:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800748:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80074c:	78 2a                	js     800778 <fd_close+0xac>
		if (dev->dev_close)
  80074e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800752:	48 8b 40 20          	mov    0x20(%rax),%rax
  800756:	48 85 c0             	test   %rax,%rax
  800759:	74 16                	je     800771 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800763:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800767:	48 89 d7             	mov    %rdx,%rdi
  80076a:	ff d0                	callq  *%rax
  80076c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80076f:	eb 07                	jmp    800778 <fd_close+0xac>
		else
			r = 0;
  800771:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80077c:	48 89 c6             	mov    %rax,%rsi
  80077f:	bf 00 00 00 00       	mov    $0x0,%edi
  800784:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  80078b:	00 00 00 
  80078e:	ff d0                	callq  *%rax
	return r;
  800790:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800793:	c9                   	leaveq 
  800794:	c3                   	retq   

0000000000800795 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800795:	55                   	push   %rbp
  800796:	48 89 e5             	mov    %rsp,%rbp
  800799:	48 83 ec 20          	sub    $0x20,%rsp
  80079d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007ab:	eb 41                	jmp    8007ee <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007ad:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007b4:	00 00 00 
  8007b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007ba:	48 63 d2             	movslq %edx,%rdx
  8007bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007c6:	75 22                	jne    8007ea <dev_lookup+0x55>
			*dev = devtab[i];
  8007c8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007cf:	00 00 00 
  8007d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007d5:	48 63 d2             	movslq %edx,%rdx
  8007d8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007e0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e8:	eb 60                	jmp    80084a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007ea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007ee:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007f5:	00 00 00 
  8007f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007fb:	48 63 d2             	movslq %edx,%rdx
  8007fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800802:	48 85 c0             	test   %rax,%rax
  800805:	75 a6                	jne    8007ad <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800807:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80080e:	00 00 00 
  800811:	48 8b 00             	mov    (%rax),%rax
  800814:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80081a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80081d:	89 c6                	mov    %eax,%esi
  80081f:	48 bf 18 36 80 00 00 	movabs $0x803618,%rdi
  800826:	00 00 00 
  800829:	b8 00 00 00 00       	mov    $0x0,%eax
  80082e:	48 b9 54 20 80 00 00 	movabs $0x802054,%rcx
  800835:	00 00 00 
  800838:	ff d1                	callq  *%rcx
	*dev = 0;
  80083a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80083e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800845:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80084a:	c9                   	leaveq 
  80084b:	c3                   	retq   

000000000080084c <close>:

int
close(int fdnum)
{
  80084c:	55                   	push   %rbp
  80084d:	48 89 e5             	mov    %rsp,%rbp
  800850:	48 83 ec 20          	sub    $0x20,%rsp
  800854:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800857:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80085b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80085e:	48 89 d6             	mov    %rdx,%rsi
  800861:	89 c7                	mov    %eax,%edi
  800863:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  80086a:	00 00 00 
  80086d:	ff d0                	callq  *%rax
  80086f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800872:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800876:	79 05                	jns    80087d <close+0x31>
		return r;
  800878:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80087b:	eb 18                	jmp    800895 <close+0x49>
	else
		return fd_close(fd, 1);
  80087d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800881:	be 01 00 00 00       	mov    $0x1,%esi
  800886:	48 89 c7             	mov    %rax,%rdi
  800889:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  800890:	00 00 00 
  800893:	ff d0                	callq  *%rax
}
  800895:	c9                   	leaveq 
  800896:	c3                   	retq   

0000000000800897 <close_all>:

void
close_all(void)
{
  800897:	55                   	push   %rbp
  800898:	48 89 e5             	mov    %rsp,%rbp
  80089b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80089f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008a6:	eb 15                	jmp    8008bd <close_all+0x26>
		close(i);
  8008a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ab:	89 c7                	mov    %eax,%edi
  8008ad:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  8008b4:	00 00 00 
  8008b7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008bd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008c1:	7e e5                	jle    8008a8 <close_all+0x11>
		close(i);
}
  8008c3:	c9                   	leaveq 
  8008c4:	c3                   	retq   

00000000008008c5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008c5:	55                   	push   %rbp
  8008c6:	48 89 e5             	mov    %rsp,%rbp
  8008c9:	48 83 ec 40          	sub    $0x40,%rsp
  8008cd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008d0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008d3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008d7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008da:	48 89 d6             	mov    %rdx,%rsi
  8008dd:	89 c7                	mov    %eax,%edi
  8008df:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  8008e6:	00 00 00 
  8008e9:	ff d0                	callq  *%rax
  8008eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008f2:	79 08                	jns    8008fc <dup+0x37>
		return r;
  8008f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008f7:	e9 70 01 00 00       	jmpq   800a6c <dup+0x1a7>
	close(newfdnum);
  8008fc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8008ff:	89 c7                	mov    %eax,%edi
  800901:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  800908:	00 00 00 
  80090b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80090d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800910:	48 98                	cltq   
  800912:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800918:	48 c1 e0 0c          	shl    $0xc,%rax
  80091c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800920:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800924:	48 89 c7             	mov    %rax,%rdi
  800927:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  80092e:	00 00 00 
  800931:	ff d0                	callq  *%rax
  800933:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80093b:	48 89 c7             	mov    %rax,%rdi
  80093e:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  800945:	00 00 00 
  800948:	ff d0                	callq  *%rax
  80094a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80094e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800952:	48 c1 e8 15          	shr    $0x15,%rax
  800956:	48 89 c2             	mov    %rax,%rdx
  800959:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800960:	01 00 00 
  800963:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800967:	83 e0 01             	and    $0x1,%eax
  80096a:	48 85 c0             	test   %rax,%rax
  80096d:	74 73                	je     8009e2 <dup+0x11d>
  80096f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800973:	48 c1 e8 0c          	shr    $0xc,%rax
  800977:	48 89 c2             	mov    %rax,%rdx
  80097a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800981:	01 00 00 
  800984:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800988:	83 e0 01             	and    $0x1,%eax
  80098b:	48 85 c0             	test   %rax,%rax
  80098e:	74 52                	je     8009e2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800994:	48 c1 e8 0c          	shr    $0xc,%rax
  800998:	48 89 c2             	mov    %rax,%rdx
  80099b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009a2:	01 00 00 
  8009a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8009ae:	89 c1                	mov    %eax,%ecx
  8009b0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	41 89 c8             	mov    %ecx,%r8d
  8009bb:	48 89 d1             	mov    %rdx,%rcx
  8009be:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c3:	48 89 c6             	mov    %rax,%rsi
  8009c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8009cb:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  8009d2:	00 00 00 
  8009d5:	ff d0                	callq  *%rax
  8009d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009de:	79 02                	jns    8009e2 <dup+0x11d>
			goto err;
  8009e0:	eb 57                	jmp    800a39 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8009ea:	48 89 c2             	mov    %rax,%rdx
  8009ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009f4:	01 00 00 
  8009f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009fb:	25 07 0e 00 00       	and    $0xe07,%eax
  800a00:	89 c1                	mov    %eax,%ecx
  800a02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a0a:	41 89 c8             	mov    %ecx,%r8d
  800a0d:	48 89 d1             	mov    %rdx,%rcx
  800a10:	ba 00 00 00 00       	mov    $0x0,%edx
  800a15:	48 89 c6             	mov    %rax,%rsi
  800a18:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1d:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  800a24:	00 00 00 
  800a27:	ff d0                	callq  *%rax
  800a29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a30:	79 02                	jns    800a34 <dup+0x16f>
		goto err;
  800a32:	eb 05                	jmp    800a39 <dup+0x174>

	return newfdnum;
  800a34:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a37:	eb 33                	jmp    800a6c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a3d:	48 89 c6             	mov    %rax,%rsi
  800a40:	bf 00 00 00 00       	mov    $0x0,%edi
  800a45:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a55:	48 89 c6             	mov    %rax,%rsi
  800a58:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5d:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  800a64:	00 00 00 
  800a67:	ff d0                	callq  *%rax
	return r;
  800a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a6c:	c9                   	leaveq 
  800a6d:	c3                   	retq   

0000000000800a6e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a6e:	55                   	push   %rbp
  800a6f:	48 89 e5             	mov    %rsp,%rbp
  800a72:	48 83 ec 40          	sub    $0x40,%rsp
  800a76:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a7d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a81:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a85:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a88:	48 89 d6             	mov    %rdx,%rsi
  800a8b:	89 c7                	mov    %eax,%edi
  800a8d:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aa0:	78 24                	js     800ac6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa6:	8b 00                	mov    (%rax),%eax
  800aa8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800aac:	48 89 d6             	mov    %rdx,%rsi
  800aaf:	89 c7                	mov    %eax,%edi
  800ab1:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800ab8:	00 00 00 
  800abb:	ff d0                	callq  *%rax
  800abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ac4:	79 05                	jns    800acb <read+0x5d>
		return r;
  800ac6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ac9:	eb 76                	jmp    800b41 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acf:	8b 40 08             	mov    0x8(%rax),%eax
  800ad2:	83 e0 03             	and    $0x3,%eax
  800ad5:	83 f8 01             	cmp    $0x1,%eax
  800ad8:	75 3a                	jne    800b14 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800ada:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ae1:	00 00 00 
  800ae4:	48 8b 00             	mov    (%rax),%rax
  800ae7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800aed:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800af0:	89 c6                	mov    %eax,%esi
  800af2:	48 bf 37 36 80 00 00 	movabs $0x803637,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	48 b9 54 20 80 00 00 	movabs $0x802054,%rcx
  800b08:	00 00 00 
  800b0b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b12:	eb 2d                	jmp    800b41 <read+0xd3>
	}
	if (!dev->dev_read)
  800b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b18:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b1c:	48 85 c0             	test   %rax,%rax
  800b1f:	75 07                	jne    800b28 <read+0xba>
		return -E_NOT_SUPP;
  800b21:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b26:	eb 19                	jmp    800b41 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b2c:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b34:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b38:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b3c:	48 89 cf             	mov    %rcx,%rdi
  800b3f:	ff d0                	callq  *%rax
}
  800b41:	c9                   	leaveq 
  800b42:	c3                   	retq   

0000000000800b43 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b43:	55                   	push   %rbp
  800b44:	48 89 e5             	mov    %rsp,%rbp
  800b47:	48 83 ec 30          	sub    $0x30,%rsp
  800b4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b4e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b52:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b5d:	eb 49                	jmp    800ba8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b62:	48 98                	cltq   
  800b64:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b68:	48 29 c2             	sub    %rax,%rdx
  800b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b6e:	48 63 c8             	movslq %eax,%rcx
  800b71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b75:	48 01 c1             	add    %rax,%rcx
  800b78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b7b:	48 89 ce             	mov    %rcx,%rsi
  800b7e:	89 c7                	mov    %eax,%edi
  800b80:	48 b8 6e 0a 80 00 00 	movabs $0x800a6e,%rax
  800b87:	00 00 00 
  800b8a:	ff d0                	callq  *%rax
  800b8c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800b8f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b93:	79 05                	jns    800b9a <readn+0x57>
			return m;
  800b95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b98:	eb 1c                	jmp    800bb6 <readn+0x73>
		if (m == 0)
  800b9a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b9e:	75 02                	jne    800ba2 <readn+0x5f>
			break;
  800ba0:	eb 11                	jmp    800bb3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ba2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ba5:	01 45 fc             	add    %eax,-0x4(%rbp)
  800ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bab:	48 98                	cltq   
  800bad:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bb1:	72 ac                	jb     800b5f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bb6:	c9                   	leaveq 
  800bb7:	c3                   	retq   

0000000000800bb8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bb8:	55                   	push   %rbp
  800bb9:	48 89 e5             	mov    %rsp,%rbp
  800bbc:	48 83 ec 40          	sub    $0x40,%rsp
  800bc0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bc3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bc7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bcb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bcf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bd2:	48 89 d6             	mov    %rdx,%rsi
  800bd5:	89 c7                	mov    %eax,%edi
  800bd7:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800bde:	00 00 00 
  800be1:	ff d0                	callq  *%rax
  800be3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800be6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bea:	78 24                	js     800c10 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf0:	8b 00                	mov    (%rax),%eax
  800bf2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800bf6:	48 89 d6             	mov    %rdx,%rsi
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800c02:	00 00 00 
  800c05:	ff d0                	callq  *%rax
  800c07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c0e:	79 05                	jns    800c15 <write+0x5d>
		return r;
  800c10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c13:	eb 75                	jmp    800c8a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c19:	8b 40 08             	mov    0x8(%rax),%eax
  800c1c:	83 e0 03             	and    $0x3,%eax
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	75 3a                	jne    800c5d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c23:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c2a:	00 00 00 
  800c2d:	48 8b 00             	mov    (%rax),%rax
  800c30:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c36:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c39:	89 c6                	mov    %eax,%esi
  800c3b:	48 bf 53 36 80 00 00 	movabs $0x803653,%rdi
  800c42:	00 00 00 
  800c45:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4a:	48 b9 54 20 80 00 00 	movabs $0x802054,%rcx
  800c51:	00 00 00 
  800c54:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c5b:	eb 2d                	jmp    800c8a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c61:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c65:	48 85 c0             	test   %rax,%rax
  800c68:	75 07                	jne    800c71 <write+0xb9>
		return -E_NOT_SUPP;
  800c6a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c6f:	eb 19                	jmp    800c8a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c75:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c79:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c81:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c85:	48 89 cf             	mov    %rcx,%rdi
  800c88:	ff d0                	callq  *%rax
}
  800c8a:	c9                   	leaveq 
  800c8b:	c3                   	retq   

0000000000800c8c <seek>:

int
seek(int fdnum, off_t offset)
{
  800c8c:	55                   	push   %rbp
  800c8d:	48 89 e5             	mov    %rsp,%rbp
  800c90:	48 83 ec 18          	sub    $0x18,%rsp
  800c94:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c97:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c9a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ca1:	48 89 d6             	mov    %rdx,%rsi
  800ca4:	89 c7                	mov    %eax,%edi
  800ca6:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800cad:	00 00 00 
  800cb0:	ff d0                	callq  *%rax
  800cb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cb9:	79 05                	jns    800cc0 <seek+0x34>
		return r;
  800cbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cbe:	eb 0f                	jmp    800ccf <seek+0x43>
	fd->fd_offset = offset;
  800cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cc7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ccf:	c9                   	leaveq 
  800cd0:	c3                   	retq   

0000000000800cd1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800cd1:	55                   	push   %rbp
  800cd2:	48 89 e5             	mov    %rsp,%rbp
  800cd5:	48 83 ec 30          	sub    $0x30,%rsp
  800cd9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cdc:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cdf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ce3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ce6:	48 89 d6             	mov    %rdx,%rsi
  800ce9:	89 c7                	mov    %eax,%edi
  800ceb:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800cf2:	00 00 00 
  800cf5:	ff d0                	callq  *%rax
  800cf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cfe:	78 24                	js     800d24 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d04:	8b 00                	mov    (%rax),%eax
  800d06:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d0a:	48 89 d6             	mov    %rdx,%rsi
  800d0d:	89 c7                	mov    %eax,%edi
  800d0f:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800d16:	00 00 00 
  800d19:	ff d0                	callq  *%rax
  800d1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d22:	79 05                	jns    800d29 <ftruncate+0x58>
		return r;
  800d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d27:	eb 72                	jmp    800d9b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2d:	8b 40 08             	mov    0x8(%rax),%eax
  800d30:	83 e0 03             	and    $0x3,%eax
  800d33:	85 c0                	test   %eax,%eax
  800d35:	75 3a                	jne    800d71 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d37:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d3e:	00 00 00 
  800d41:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d4a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d4d:	89 c6                	mov    %eax,%esi
  800d4f:	48 bf 70 36 80 00 00 	movabs $0x803670,%rdi
  800d56:	00 00 00 
  800d59:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5e:	48 b9 54 20 80 00 00 	movabs $0x802054,%rcx
  800d65:	00 00 00 
  800d68:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d6f:	eb 2a                	jmp    800d9b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d75:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d79:	48 85 c0             	test   %rax,%rax
  800d7c:	75 07                	jne    800d85 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d7e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d83:	eb 16                	jmp    800d9b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d89:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d91:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800d94:	89 ce                	mov    %ecx,%esi
  800d96:	48 89 d7             	mov    %rdx,%rdi
  800d99:	ff d0                	callq  *%rax
}
  800d9b:	c9                   	leaveq 
  800d9c:	c3                   	retq   

0000000000800d9d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800d9d:	55                   	push   %rbp
  800d9e:	48 89 e5             	mov    %rsp,%rbp
  800da1:	48 83 ec 30          	sub    $0x30,%rsp
  800da5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800da8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800db0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800db3:	48 89 d6             	mov    %rdx,%rsi
  800db6:	89 c7                	mov    %eax,%edi
  800db8:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800dbf:	00 00 00 
  800dc2:	ff d0                	callq  *%rax
  800dc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dcb:	78 24                	js     800df1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd1:	8b 00                	mov    (%rax),%eax
  800dd3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dd7:	48 89 d6             	mov    %rdx,%rsi
  800dda:	89 c7                	mov    %eax,%edi
  800ddc:	48 b8 95 07 80 00 00 	movabs $0x800795,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
  800de8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800deb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800def:	79 05                	jns    800df6 <fstat+0x59>
		return r;
  800df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df4:	eb 5e                	jmp    800e54 <fstat+0xb7>
	if (!dev->dev_stat)
  800df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dfa:	48 8b 40 28          	mov    0x28(%rax),%rax
  800dfe:	48 85 c0             	test   %rax,%rax
  800e01:	75 07                	jne    800e0a <fstat+0x6d>
		return -E_NOT_SUPP;
  800e03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e08:	eb 4a                	jmp    800e54 <fstat+0xb7>
	stat->st_name[0] = 0;
  800e0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e0e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e15:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e1c:	00 00 00 
	stat->st_isdir = 0;
  800e1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e23:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e2a:	00 00 00 
	stat->st_dev = dev;
  800e2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e35:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e40:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e48:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e4c:	48 89 ce             	mov    %rcx,%rsi
  800e4f:	48 89 d7             	mov    %rdx,%rdi
  800e52:	ff d0                	callq  *%rax
}
  800e54:	c9                   	leaveq 
  800e55:	c3                   	retq   

0000000000800e56 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e56:	55                   	push   %rbp
  800e57:	48 89 e5             	mov    %rsp,%rbp
  800e5a:	48 83 ec 20          	sub    $0x20,%rsp
  800e5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6a:	be 00 00 00 00       	mov    $0x0,%esi
  800e6f:	48 89 c7             	mov    %rax,%rdi
  800e72:	48 b8 44 0f 80 00 00 	movabs $0x800f44,%rax
  800e79:	00 00 00 
  800e7c:	ff d0                	callq  *%rax
  800e7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e85:	79 05                	jns    800e8c <stat+0x36>
		return fd;
  800e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8a:	eb 2f                	jmp    800ebb <stat+0x65>
	r = fstat(fd, stat);
  800e8c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e93:	48 89 d6             	mov    %rdx,%rsi
  800e96:	89 c7                	mov    %eax,%edi
  800e98:	48 b8 9d 0d 80 00 00 	movabs $0x800d9d,%rax
  800e9f:	00 00 00 
  800ea2:	ff d0                	callq  *%rax
  800ea4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eaa:	89 c7                	mov    %eax,%edi
  800eac:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	callq  *%rax
	return r;
  800eb8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ebb:	c9                   	leaveq 
  800ebc:	c3                   	retq   

0000000000800ebd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ebd:	55                   	push   %rbp
  800ebe:	48 89 e5             	mov    %rsp,%rbp
  800ec1:	48 83 ec 10          	sub    $0x10,%rsp
  800ec5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ec8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ecc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ed3:	00 00 00 
  800ed6:	8b 00                	mov    (%rax),%eax
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	75 1d                	jne    800ef9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800edc:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee1:	48 b8 ce 34 80 00 00 	movabs $0x8034ce,%rax
  800ee8:	00 00 00 
  800eeb:	ff d0                	callq  *%rax
  800eed:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800ef4:	00 00 00 
  800ef7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ef9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f00:	00 00 00 
  800f03:	8b 00                	mov    (%rax),%eax
  800f05:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f08:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f0d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f14:	00 00 00 
  800f17:	89 c7                	mov    %eax,%edi
  800f19:	48 b8 36 34 80 00 00 	movabs $0x803436,%rax
  800f20:	00 00 00 
  800f23:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f29:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2e:	48 89 c6             	mov    %rax,%rsi
  800f31:	bf 00 00 00 00       	mov    $0x0,%edi
  800f36:	48 b8 75 33 80 00 00 	movabs $0x803375,%rax
  800f3d:	00 00 00 
  800f40:	ff d0                	callq  *%rax
}
  800f42:	c9                   	leaveq 
  800f43:	c3                   	retq   

0000000000800f44 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f44:	55                   	push   %rbp
  800f45:	48 89 e5             	mov    %rsp,%rbp
  800f48:	48 83 ec 20          	sub    $0x20,%rsp
  800f4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f50:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f57:	48 89 c7             	mov    %rax,%rdi
  800f5a:	48 b8 b0 2b 80 00 00 	movabs $0x802bb0,%rax
  800f61:	00 00 00 
  800f64:	ff d0                	callq  *%rax
  800f66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f6b:	7e 0a                	jle    800f77 <open+0x33>
		return -E_BAD_PATH;
  800f6d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f72:	e9 a5 00 00 00       	jmpq   80101c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f77:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f7b:	48 89 c7             	mov    %rax,%rdi
  800f7e:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  800f85:	00 00 00 
  800f88:	ff d0                	callq  *%rax
  800f8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f91:	79 08                	jns    800f9b <open+0x57>
		return r;
  800f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f96:	e9 81 00 00 00       	jmpq   80101c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800f9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9f:	48 89 c6             	mov    %rax,%rsi
  800fa2:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fa9:	00 00 00 
  800fac:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  800fb3:	00 00 00 
  800fb6:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fb8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fbf:	00 00 00 
  800fc2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fc5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcf:	48 89 c6             	mov    %rax,%rsi
  800fd2:	bf 01 00 00 00       	mov    $0x1,%edi
  800fd7:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	callq  *%rax
  800fe3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fe6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fea:	79 1d                	jns    801009 <open+0xc5>
		fd_close(fd, 0);
  800fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff0:	be 00 00 00 00       	mov    $0x0,%esi
  800ff5:	48 89 c7             	mov    %rax,%rdi
  800ff8:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  800fff:	00 00 00 
  801002:	ff d0                	callq  *%rax
		return r;
  801004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801007:	eb 13                	jmp    80101c <open+0xd8>
	}

	return fd2num(fd);
  801009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100d:	48 89 c7             	mov    %rax,%rdi
  801010:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  801017:	00 00 00 
  80101a:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  80101c:	c9                   	leaveq 
  80101d:	c3                   	retq   

000000000080101e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80101e:	55                   	push   %rbp
  80101f:	48 89 e5             	mov    %rsp,%rbp
  801022:	48 83 ec 10          	sub    $0x10,%rsp
  801026:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80102a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102e:	8b 50 0c             	mov    0xc(%rax),%edx
  801031:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801038:	00 00 00 
  80103b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80103d:	be 00 00 00 00       	mov    $0x0,%esi
  801042:	bf 06 00 00 00       	mov    $0x6,%edi
  801047:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  80104e:	00 00 00 
  801051:	ff d0                	callq  *%rax
}
  801053:	c9                   	leaveq 
  801054:	c3                   	retq   

0000000000801055 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801055:	55                   	push   %rbp
  801056:	48 89 e5             	mov    %rsp,%rbp
  801059:	48 83 ec 30          	sub    $0x30,%rsp
  80105d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801061:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801065:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106d:	8b 50 0c             	mov    0xc(%rax),%edx
  801070:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801077:	00 00 00 
  80107a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80107c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801083:	00 00 00 
  801086:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80108a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80108e:	be 00 00 00 00       	mov    $0x0,%esi
  801093:	bf 03 00 00 00       	mov    $0x3,%edi
  801098:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  80109f:	00 00 00 
  8010a2:	ff d0                	callq  *%rax
  8010a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010ab:	79 08                	jns    8010b5 <devfile_read+0x60>
		return r;
  8010ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b0:	e9 a4 00 00 00       	jmpq   801159 <devfile_read+0x104>
	assert(r <= n);
  8010b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b8:	48 98                	cltq   
  8010ba:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010be:	76 35                	jbe    8010f5 <devfile_read+0xa0>
  8010c0:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  8010c7:	00 00 00 
  8010ca:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8010d1:	00 00 00 
  8010d4:	be 84 00 00 00       	mov    $0x84,%esi
  8010d9:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8010e0:	00 00 00 
  8010e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e8:	49 b8 1b 1e 80 00 00 	movabs $0x801e1b,%r8
  8010ef:	00 00 00 
  8010f2:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8010f5:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8010fc:	7e 35                	jle    801133 <devfile_read+0xde>
  8010fe:	48 b9 c4 36 80 00 00 	movabs $0x8036c4,%rcx
  801105:	00 00 00 
  801108:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  80110f:	00 00 00 
  801112:	be 85 00 00 00       	mov    $0x85,%esi
  801117:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  80111e:	00 00 00 
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
  801126:	49 b8 1b 1e 80 00 00 	movabs $0x801e1b,%r8
  80112d:	00 00 00 
  801130:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801133:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801136:	48 63 d0             	movslq %eax,%rdx
  801139:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801144:	00 00 00 
  801147:	48 89 c7             	mov    %rax,%rdi
  80114a:	48 b8 40 2f 80 00 00 	movabs $0x802f40,%rax
  801151:	00 00 00 
  801154:	ff d0                	callq  *%rax
	return r;
  801156:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  801159:	c9                   	leaveq 
  80115a:	c3                   	retq   

000000000080115b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80115b:	55                   	push   %rbp
  80115c:	48 89 e5             	mov    %rsp,%rbp
  80115f:	48 83 ec 30          	sub    $0x30,%rsp
  801163:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801167:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80116f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801173:	8b 50 0c             	mov    0xc(%rax),%edx
  801176:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80117d:	00 00 00 
  801180:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801182:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801189:	00 00 00 
  80118c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801190:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801194:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80119b:	00 
  80119c:	76 35                	jbe    8011d3 <devfile_write+0x78>
  80119e:	48 b9 d0 36 80 00 00 	movabs $0x8036d0,%rcx
  8011a5:	00 00 00 
  8011a8:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  8011af:	00 00 00 
  8011b2:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011b7:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  8011be:	00 00 00 
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c6:	49 b8 1b 1e 80 00 00 	movabs $0x801e1b,%r8
  8011cd:	00 00 00 
  8011d0:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011d3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011db:	48 89 c6             	mov    %rax,%rsi
  8011de:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011e5:	00 00 00 
  8011e8:	48 b8 57 30 80 00 00 	movabs $0x803057,%rax
  8011ef:	00 00 00 
  8011f2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8011f4:	be 00 00 00 00       	mov    $0x0,%esi
  8011f9:	bf 04 00 00 00       	mov    $0x4,%edi
  8011fe:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  801205:	00 00 00 
  801208:	ff d0                	callq  *%rax
  80120a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80120d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801211:	79 05                	jns    801218 <devfile_write+0xbd>
		return r;
  801213:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801216:	eb 43                	jmp    80125b <devfile_write+0x100>
	assert(r <= n);
  801218:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80121b:	48 98                	cltq   
  80121d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801221:	76 35                	jbe    801258 <devfile_write+0xfd>
  801223:	48 b9 9d 36 80 00 00 	movabs $0x80369d,%rcx
  80122a:	00 00 00 
  80122d:	48 ba a4 36 80 00 00 	movabs $0x8036a4,%rdx
  801234:	00 00 00 
  801237:	be a2 00 00 00       	mov    $0xa2,%esi
  80123c:	48 bf b9 36 80 00 00 	movabs $0x8036b9,%rdi
  801243:	00 00 00 
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	49 b8 1b 1e 80 00 00 	movabs $0x801e1b,%r8
  801252:	00 00 00 
  801255:	41 ff d0             	callq  *%r8
	return r;
  801258:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80125b:	c9                   	leaveq 
  80125c:	c3                   	retq   

000000000080125d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80125d:	55                   	push   %rbp
  80125e:	48 89 e5             	mov    %rsp,%rbp
  801261:	48 83 ec 20          	sub    $0x20,%rsp
  801265:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801269:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801271:	8b 50 0c             	mov    0xc(%rax),%edx
  801274:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80127b:	00 00 00 
  80127e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801280:	be 00 00 00 00       	mov    $0x0,%esi
  801285:	bf 05 00 00 00       	mov    $0x5,%edi
  80128a:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  801291:	00 00 00 
  801294:	ff d0                	callq  *%rax
  801296:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801299:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80129d:	79 05                	jns    8012a4 <devfile_stat+0x47>
		return r;
  80129f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012a2:	eb 56                	jmp    8012fa <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a8:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012af:	00 00 00 
  8012b2:	48 89 c7             	mov    %rax,%rdi
  8012b5:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  8012bc:	00 00 00 
  8012bf:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012c1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012c8:	00 00 00 
  8012cb:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012db:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012e2:	00 00 00 
  8012e5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ef:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fa:	c9                   	leaveq 
  8012fb:	c3                   	retq   

00000000008012fc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012fc:	55                   	push   %rbp
  8012fd:	48 89 e5             	mov    %rsp,%rbp
  801300:	48 83 ec 10          	sub    $0x10,%rsp
  801304:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801308:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	8b 50 0c             	mov    0xc(%rax),%edx
  801312:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801319:	00 00 00 
  80131c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80131e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801325:	00 00 00 
  801328:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80132b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80132e:	be 00 00 00 00       	mov    $0x0,%esi
  801333:	bf 02 00 00 00       	mov    $0x2,%edi
  801338:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  80133f:	00 00 00 
  801342:	ff d0                	callq  *%rax
}
  801344:	c9                   	leaveq 
  801345:	c3                   	retq   

0000000000801346 <remove>:

// Delete a file
int
remove(const char *path)
{
  801346:	55                   	push   %rbp
  801347:	48 89 e5             	mov    %rsp,%rbp
  80134a:	48 83 ec 10          	sub    $0x10,%rsp
  80134e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	48 89 c7             	mov    %rax,%rdi
  801359:	48 b8 b0 2b 80 00 00 	movabs $0x802bb0,%rax
  801360:	00 00 00 
  801363:	ff d0                	callq  *%rax
  801365:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80136a:	7e 07                	jle    801373 <remove+0x2d>
		return -E_BAD_PATH;
  80136c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801371:	eb 33                	jmp    8013a6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	48 89 c6             	mov    %rax,%rsi
  80137a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801381:	00 00 00 
  801384:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801390:	be 00 00 00 00       	mov    $0x0,%esi
  801395:	bf 07 00 00 00       	mov    $0x7,%edi
  80139a:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  8013a1:	00 00 00 
  8013a4:	ff d0                	callq  *%rax
}
  8013a6:	c9                   	leaveq 
  8013a7:	c3                   	retq   

00000000008013a8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013a8:	55                   	push   %rbp
  8013a9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013ac:	be 00 00 00 00       	mov    $0x0,%esi
  8013b1:	bf 08 00 00 00       	mov    $0x8,%edi
  8013b6:	48 b8 bd 0e 80 00 00 	movabs $0x800ebd,%rax
  8013bd:	00 00 00 
  8013c0:	ff d0                	callq  *%rax
}
  8013c2:	5d                   	pop    %rbp
  8013c3:	c3                   	retq   

00000000008013c4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013c4:	55                   	push   %rbp
  8013c5:	48 89 e5             	mov    %rsp,%rbp
  8013c8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013cf:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013d6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013dd:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013e4:	be 00 00 00 00       	mov    $0x0,%esi
  8013e9:	48 89 c7             	mov    %rax,%rdi
  8013ec:	48 b8 44 0f 80 00 00 	movabs $0x800f44,%rax
  8013f3:	00 00 00 
  8013f6:	ff d0                	callq  *%rax
  8013f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8013fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013ff:	79 28                	jns    801429 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801404:	89 c6                	mov    %eax,%esi
  801406:	48 bf fd 36 80 00 00 	movabs $0x8036fd,%rdi
  80140d:	00 00 00 
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	48 ba 54 20 80 00 00 	movabs $0x802054,%rdx
  80141c:	00 00 00 
  80141f:	ff d2                	callq  *%rdx
		return fd_src;
  801421:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801424:	e9 74 01 00 00       	jmpq   80159d <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801429:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801430:	be 01 01 00 00       	mov    $0x101,%esi
  801435:	48 89 c7             	mov    %rax,%rdi
  801438:	48 b8 44 0f 80 00 00 	movabs $0x800f44,%rax
  80143f:	00 00 00 
  801442:	ff d0                	callq  *%rax
  801444:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801447:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80144b:	79 39                	jns    801486 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80144d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801450:	89 c6                	mov    %eax,%esi
  801452:	48 bf 13 37 80 00 00 	movabs $0x803713,%rdi
  801459:	00 00 00 
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	48 ba 54 20 80 00 00 	movabs $0x802054,%rdx
  801468:	00 00 00 
  80146b:	ff d2                	callq  *%rdx
		close(fd_src);
  80146d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801470:	89 c7                	mov    %eax,%edi
  801472:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  801479:	00 00 00 
  80147c:	ff d0                	callq  *%rax
		return fd_dest;
  80147e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801481:	e9 17 01 00 00       	jmpq   80159d <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801486:	eb 74                	jmp    8014fc <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801488:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80148b:	48 63 d0             	movslq %eax,%rdx
  80148e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801495:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801498:	48 89 ce             	mov    %rcx,%rsi
  80149b:	89 c7                	mov    %eax,%edi
  80149d:	48 b8 b8 0b 80 00 00 	movabs $0x800bb8,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	callq  *%rax
  8014a9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014b0:	79 4a                	jns    8014fc <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014b5:	89 c6                	mov    %eax,%esi
  8014b7:	48 bf 2d 37 80 00 00 	movabs $0x80372d,%rdi
  8014be:	00 00 00 
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	48 ba 54 20 80 00 00 	movabs $0x802054,%rdx
  8014cd:	00 00 00 
  8014d0:	ff d2                	callq  *%rdx
			close(fd_src);
  8014d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014d5:	89 c7                	mov    %eax,%edi
  8014d7:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  8014de:	00 00 00 
  8014e1:	ff d0                	callq  *%rax
			close(fd_dest);
  8014e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014e6:	89 c7                	mov    %eax,%edi
  8014e8:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  8014ef:	00 00 00 
  8014f2:	ff d0                	callq  *%rax
			return write_size;
  8014f4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014f7:	e9 a1 00 00 00       	jmpq   80159d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014fc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801503:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801506:	ba 00 02 00 00       	mov    $0x200,%edx
  80150b:	48 89 ce             	mov    %rcx,%rsi
  80150e:	89 c7                	mov    %eax,%edi
  801510:	48 b8 6e 0a 80 00 00 	movabs $0x800a6e,%rax
  801517:	00 00 00 
  80151a:	ff d0                	callq  *%rax
  80151c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80151f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801523:	0f 8f 5f ff ff ff    	jg     801488 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  801529:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80152d:	79 47                	jns    801576 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80152f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801532:	89 c6                	mov    %eax,%esi
  801534:	48 bf 40 37 80 00 00 	movabs $0x803740,%rdi
  80153b:	00 00 00 
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
  801543:	48 ba 54 20 80 00 00 	movabs $0x802054,%rdx
  80154a:	00 00 00 
  80154d:	ff d2                	callq  *%rdx
		close(fd_src);
  80154f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801552:	89 c7                	mov    %eax,%edi
  801554:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  80155b:	00 00 00 
  80155e:	ff d0                	callq  *%rax
		close(fd_dest);
  801560:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801563:	89 c7                	mov    %eax,%edi
  801565:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  80156c:	00 00 00 
  80156f:	ff d0                	callq  *%rax
		return read_size;
  801571:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801574:	eb 27                	jmp    80159d <copy+0x1d9>
	}
	close(fd_src);
  801576:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801579:	89 c7                	mov    %eax,%edi
  80157b:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  801582:	00 00 00 
  801585:	ff d0                	callq  *%rax
	close(fd_dest);
  801587:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80158a:	89 c7                	mov    %eax,%edi
  80158c:	48 b8 4c 08 80 00 00 	movabs $0x80084c,%rax
  801593:	00 00 00 
  801596:	ff d0                	callq  *%rax
	return 0;
  801598:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80159d:	c9                   	leaveq 
  80159e:	c3                   	retq   

000000000080159f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80159f:	55                   	push   %rbp
  8015a0:	48 89 e5             	mov    %rsp,%rbp
  8015a3:	53                   	push   %rbx
  8015a4:	48 83 ec 38          	sub    $0x38,%rsp
  8015a8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015ac:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015b0:	48 89 c7             	mov    %rax,%rdi
  8015b3:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  8015ba:	00 00 00 
  8015bd:	ff d0                	callq  *%rax
  8015bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015c6:	0f 88 bf 01 00 00    	js     80178b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d0:	ba 07 04 00 00       	mov    $0x407,%edx
  8015d5:	48 89 c6             	mov    %rax,%rsi
  8015d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8015dd:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  8015e4:	00 00 00 
  8015e7:	ff d0                	callq  *%rax
  8015e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015f0:	0f 88 95 01 00 00    	js     80178b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8015f6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015fa:	48 89 c7             	mov    %rax,%rdi
  8015fd:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  801604:	00 00 00 
  801607:	ff d0                	callq  *%rax
  801609:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80160c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801610:	0f 88 5d 01 00 00    	js     801773 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801616:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80161a:	ba 07 04 00 00       	mov    $0x407,%edx
  80161f:	48 89 c6             	mov    %rax,%rsi
  801622:	bf 00 00 00 00       	mov    $0x0,%edi
  801627:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  80162e:	00 00 00 
  801631:	ff d0                	callq  *%rax
  801633:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801636:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80163a:	0f 88 33 01 00 00    	js     801773 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801644:	48 89 c7             	mov    %rax,%rdi
  801647:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  80164e:	00 00 00 
  801651:	ff d0                	callq  *%rax
  801653:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801657:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80165b:	ba 07 04 00 00       	mov    $0x407,%edx
  801660:	48 89 c6             	mov    %rax,%rsi
  801663:	bf 00 00 00 00       	mov    $0x0,%edi
  801668:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  80166f:	00 00 00 
  801672:	ff d0                	callq  *%rax
  801674:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801677:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80167b:	79 05                	jns    801682 <pipe+0xe3>
		goto err2;
  80167d:	e9 d9 00 00 00       	jmpq   80175b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801682:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801686:	48 89 c7             	mov    %rax,%rdi
  801689:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  801690:	00 00 00 
  801693:	ff d0                	callq  *%rax
  801695:	48 89 c2             	mov    %rax,%rdx
  801698:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80169c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016a2:	48 89 d1             	mov    %rdx,%rcx
  8016a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016aa:	48 89 c6             	mov    %rax,%rsi
  8016ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b2:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  8016b9:	00 00 00 
  8016bc:	ff d0                	callq  *%rax
  8016be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016c5:	79 1b                	jns    8016e2 <pipe+0x143>
		goto err3;
  8016c7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016cc:	48 89 c6             	mov    %rax,%rsi
  8016cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8016d4:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  8016db:	00 00 00 
  8016de:	ff d0                	callq  *%rax
  8016e0:	eb 79                	jmp    80175b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016ed:	00 00 00 
  8016f0:	8b 12                	mov    (%rdx),%edx
  8016f2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8016ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801703:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80170a:	00 00 00 
  80170d:	8b 12                	mov    (%rdx),%edx
  80170f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801711:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801715:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	48 89 c7             	mov    %rax,%rdi
  801723:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  80172a:	00 00 00 
  80172d:	ff d0                	callq  *%rax
  80172f:	89 c2                	mov    %eax,%edx
  801731:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801735:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801737:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80173b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80173f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801743:	48 89 c7             	mov    %rax,%rdi
  801746:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  80174d:	00 00 00 
  801750:	ff d0                	callq  *%rax
  801752:	89 03                	mov    %eax,(%rbx)
	return 0;
  801754:	b8 00 00 00 00       	mov    $0x0,%eax
  801759:	eb 33                	jmp    80178e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80175b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175f:	48 89 c6             	mov    %rax,%rsi
  801762:	bf 00 00 00 00       	mov    $0x0,%edi
  801767:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	48 89 c6             	mov    %rax,%rsi
  80177a:	bf 00 00 00 00       	mov    $0x0,%edi
  80177f:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  801786:	00 00 00 
  801789:	ff d0                	callq  *%rax
err:
	return r;
  80178b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80178e:	48 83 c4 38          	add    $0x38,%rsp
  801792:	5b                   	pop    %rbx
  801793:	5d                   	pop    %rbp
  801794:	c3                   	retq   

0000000000801795 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	53                   	push   %rbx
  80179a:	48 83 ec 28          	sub    $0x28,%rsp
  80179e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017a6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017ad:	00 00 00 
  8017b0:	48 8b 00             	mov    (%rax),%rax
  8017b3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c0:	48 89 c7             	mov    %rax,%rdi
  8017c3:	48 b8 50 35 80 00 00 	movabs $0x803550,%rax
  8017ca:	00 00 00 
  8017cd:	ff d0                	callq  *%rax
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 50 35 80 00 00 	movabs $0x803550,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	39 c3                	cmp    %eax,%ebx
  8017e6:	0f 94 c0             	sete   %al
  8017e9:	0f b6 c0             	movzbl %al,%eax
  8017ec:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8017ef:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017f6:	00 00 00 
  8017f9:	48 8b 00             	mov    (%rax),%rax
  8017fc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801802:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801805:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801808:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80180b:	75 05                	jne    801812 <_pipeisclosed+0x7d>
			return ret;
  80180d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801810:	eb 4f                	jmp    801861 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801812:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801815:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801818:	74 42                	je     80185c <_pipeisclosed+0xc7>
  80181a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80181e:	75 3c                	jne    80185c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801820:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801827:	00 00 00 
  80182a:	48 8b 00             	mov    (%rax),%rax
  80182d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801833:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801836:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801839:	89 c6                	mov    %eax,%esi
  80183b:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  801842:	00 00 00 
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
  80184a:	49 b8 54 20 80 00 00 	movabs $0x802054,%r8
  801851:	00 00 00 
  801854:	41 ff d0             	callq  *%r8
	}
  801857:	e9 4a ff ff ff       	jmpq   8017a6 <_pipeisclosed+0x11>
  80185c:	e9 45 ff ff ff       	jmpq   8017a6 <_pipeisclosed+0x11>
}
  801861:	48 83 c4 28          	add    $0x28,%rsp
  801865:	5b                   	pop    %rbx
  801866:	5d                   	pop    %rbp
  801867:	c3                   	retq   

0000000000801868 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 30          	sub    $0x30,%rsp
  801870:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801873:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801877:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80187a:	48 89 d6             	mov    %rdx,%rsi
  80187d:	89 c7                	mov    %eax,%edi
  80187f:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  801886:	00 00 00 
  801889:	ff d0                	callq  *%rax
  80188b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80188e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801892:	79 05                	jns    801899 <pipeisclosed+0x31>
		return r;
  801894:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801897:	eb 31                	jmp    8018ca <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801899:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189d:	48 89 c7             	mov    %rax,%rdi
  8018a0:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  8018a7:	00 00 00 
  8018aa:	ff d0                	callq  *%rax
  8018ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b8:	48 89 d6             	mov    %rdx,%rsi
  8018bb:	48 89 c7             	mov    %rax,%rdi
  8018be:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	callq  *%rax
}
  8018ca:	c9                   	leaveq 
  8018cb:	c3                   	retq   

00000000008018cc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
  8018d0:	48 83 ec 40          	sub    $0x40,%rsp
  8018d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018dc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e4:	48 89 c7             	mov    %rax,%rdi
  8018e7:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  8018ee:	00 00 00 
  8018f1:	ff d0                	callq  *%rax
  8018f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8018f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8018ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801906:	00 
  801907:	e9 92 00 00 00       	jmpq   80199e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80190c:	eb 41                	jmp    80194f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80190e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801913:	74 09                	je     80191e <devpipe_read+0x52>
				return i;
  801915:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801919:	e9 92 00 00 00       	jmpq   8019b0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80191e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801926:	48 89 d6             	mov    %rdx,%rsi
  801929:	48 89 c7             	mov    %rax,%rdi
  80192c:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
  801938:	85 c0                	test   %eax,%eax
  80193a:	74 07                	je     801943 <devpipe_read+0x77>
				return 0;
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
  801941:	eb 6d                	jmp    8019b0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801943:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  80194a:	00 00 00 
  80194d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80194f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801953:	8b 10                	mov    (%rax),%edx
  801955:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801959:	8b 40 04             	mov    0x4(%rax),%eax
  80195c:	39 c2                	cmp    %eax,%edx
  80195e:	74 ae                	je     80190e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801960:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801964:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801968:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80196c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801970:	8b 00                	mov    (%rax),%eax
  801972:	99                   	cltd   
  801973:	c1 ea 1b             	shr    $0x1b,%edx
  801976:	01 d0                	add    %edx,%eax
  801978:	83 e0 1f             	and    $0x1f,%eax
  80197b:	29 d0                	sub    %edx,%eax
  80197d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801981:	48 98                	cltq   
  801983:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801988:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80198a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198e:	8b 00                	mov    (%rax),%eax
  801990:	8d 50 01             	lea    0x1(%rax),%edx
  801993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801997:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801999:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80199e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019a6:	0f 82 60 ff ff ff    	jb     80190c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019b0:	c9                   	leaveq 
  8019b1:	c3                   	retq   

00000000008019b2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019b2:	55                   	push   %rbp
  8019b3:	48 89 e5             	mov    %rsp,%rbp
  8019b6:	48 83 ec 40          	sub    $0x40,%rsp
  8019ba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019c2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ca:	48 89 c7             	mov    %rax,%rdi
  8019cd:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  8019d4:	00 00 00 
  8019d7:	ff d0                	callq  *%rax
  8019d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019e5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019ec:	00 
  8019ed:	e9 8e 00 00 00       	jmpq   801a80 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019f2:	eb 31                	jmp    801a25 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fc:	48 89 d6             	mov    %rdx,%rsi
  8019ff:	48 89 c7             	mov    %rax,%rdi
  801a02:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  801a09:	00 00 00 
  801a0c:	ff d0                	callq  *%rax
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	74 07                	je     801a19 <devpipe_write+0x67>
				return 0;
  801a12:	b8 00 00 00 00       	mov    $0x0,%eax
  801a17:	eb 79                	jmp    801a92 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a19:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a29:	8b 40 04             	mov    0x4(%rax),%eax
  801a2c:	48 63 d0             	movslq %eax,%rdx
  801a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a33:	8b 00                	mov    (%rax),%eax
  801a35:	48 98                	cltq   
  801a37:	48 83 c0 20          	add    $0x20,%rax
  801a3b:	48 39 c2             	cmp    %rax,%rdx
  801a3e:	73 b4                	jae    8019f4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a44:	8b 40 04             	mov    0x4(%rax),%eax
  801a47:	99                   	cltd   
  801a48:	c1 ea 1b             	shr    $0x1b,%edx
  801a4b:	01 d0                	add    %edx,%eax
  801a4d:	83 e0 1f             	and    $0x1f,%eax
  801a50:	29 d0                	sub    %edx,%eax
  801a52:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a56:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a5a:	48 01 ca             	add    %rcx,%rdx
  801a5d:	0f b6 0a             	movzbl (%rdx),%ecx
  801a60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a64:	48 98                	cltq   
  801a66:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6e:	8b 40 04             	mov    0x4(%rax),%eax
  801a71:	8d 50 01             	lea    0x1(%rax),%edx
  801a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a78:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a7b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a84:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a88:	0f 82 64 ff ff ff    	jb     8019f2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a92:	c9                   	leaveq 
  801a93:	c3                   	retq   

0000000000801a94 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a94:	55                   	push   %rbp
  801a95:	48 89 e5             	mov    %rsp,%rbp
  801a98:	48 83 ec 20          	sub    $0x20,%rsp
  801a9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801aa0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa8:	48 89 c7             	mov    %rax,%rdi
  801aab:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  801ab2:	00 00 00 
  801ab5:	ff d0                	callq  *%rax
  801ab7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801abb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801abf:	48 be 6e 37 80 00 00 	movabs $0x80376e,%rsi
  801ac6:	00 00 00 
  801ac9:	48 89 c7             	mov    %rax,%rdi
  801acc:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  801ad3:	00 00 00 
  801ad6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801ad8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801adc:	8b 50 04             	mov    0x4(%rax),%edx
  801adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae3:	8b 00                	mov    (%rax),%eax
  801ae5:	29 c2                	sub    %eax,%edx
  801ae7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aeb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801af1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801afc:	00 00 00 
	stat->st_dev = &devpipe;
  801aff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b03:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b0a:	00 00 00 
  801b0d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   

0000000000801b1b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 10          	sub    $0x10,%rsp
  801b23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2b:	48 89 c6             	mov    %rax,%rsi
  801b2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801b33:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b43:	48 89 c7             	mov    %rax,%rdi
  801b46:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
  801b52:	48 89 c6             	mov    %rax,%rsi
  801b55:	bf 00 00 00 00       	mov    $0x0,%edi
  801b5a:	48 b8 94 03 80 00 00 	movabs $0x800394,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
}
  801b66:	c9                   	leaveq 
  801b67:	c3                   	retq   

0000000000801b68 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b68:	55                   	push   %rbp
  801b69:	48 89 e5             	mov    %rsp,%rbp
  801b6c:	48 83 ec 20          	sub    $0x20,%rsp
  801b70:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b76:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b79:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b7d:	be 01 00 00 00       	mov    $0x1,%esi
  801b82:	48 89 c7             	mov    %rax,%rdi
  801b85:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  801b8c:	00 00 00 
  801b8f:	ff d0                	callq  *%rax
}
  801b91:	c9                   	leaveq 
  801b92:	c3                   	retq   

0000000000801b93 <getchar>:

int
getchar(void)
{
  801b93:	55                   	push   %rbp
  801b94:	48 89 e5             	mov    %rsp,%rbp
  801b97:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801b9b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801b9f:	ba 01 00 00 00       	mov    $0x1,%edx
  801ba4:	48 89 c6             	mov    %rax,%rsi
  801ba7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bac:	48 b8 6e 0a 80 00 00 	movabs $0x800a6e,%rax
  801bb3:	00 00 00 
  801bb6:	ff d0                	callq  *%rax
  801bb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bbf:	79 05                	jns    801bc6 <getchar+0x33>
		return r;
  801bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc4:	eb 14                	jmp    801bda <getchar+0x47>
	if (r < 1)
  801bc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bca:	7f 07                	jg     801bd3 <getchar+0x40>
		return -E_EOF;
  801bcc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801bd1:	eb 07                	jmp    801bda <getchar+0x47>
	return c;
  801bd3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801bd7:	0f b6 c0             	movzbl %al,%eax
}
  801bda:	c9                   	leaveq 
  801bdb:	c3                   	retq   

0000000000801bdc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bdc:	55                   	push   %rbp
  801bdd:	48 89 e5             	mov    %rsp,%rbp
  801be0:	48 83 ec 20          	sub    $0x20,%rsp
  801be4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801beb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bee:	48 89 d6             	mov    %rdx,%rsi
  801bf1:	89 c7                	mov    %eax,%edi
  801bf3:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	callq  *%rax
  801bff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c06:	79 05                	jns    801c0d <iscons+0x31>
		return r;
  801c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0b:	eb 1a                	jmp    801c27 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c11:	8b 10                	mov    (%rax),%edx
  801c13:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c1a:	00 00 00 
  801c1d:	8b 00                	mov    (%rax),%eax
  801c1f:	39 c2                	cmp    %eax,%edx
  801c21:	0f 94 c0             	sete   %al
  801c24:	0f b6 c0             	movzbl %al,%eax
}
  801c27:	c9                   	leaveq 
  801c28:	c3                   	retq   

0000000000801c29 <opencons>:

int
opencons(void)
{
  801c29:	55                   	push   %rbp
  801c2a:	48 89 e5             	mov    %rsp,%rbp
  801c2d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c31:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c35:	48 89 c7             	mov    %rax,%rdi
  801c38:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
  801c44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c4b:	79 05                	jns    801c52 <opencons+0x29>
		return r;
  801c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c50:	eb 5b                	jmp    801cad <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c56:	ba 07 04 00 00       	mov    $0x407,%edx
  801c5b:	48 89 c6             	mov    %rax,%rsi
  801c5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c63:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  801c6a:	00 00 00 
  801c6d:	ff d0                	callq  *%rax
  801c6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c76:	79 05                	jns    801c7d <opencons+0x54>
		return r;
  801c78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7b:	eb 30                	jmp    801cad <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c81:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c88:	00 00 00 
  801c8b:	8b 12                	mov    (%rdx),%edx
  801c8d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c93:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801c9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9e:	48 89 c7             	mov    %rax,%rdi
  801ca1:	48 b8 56 05 80 00 00 	movabs $0x800556,%rax
  801ca8:	00 00 00 
  801cab:	ff d0                	callq  *%rax
}
  801cad:	c9                   	leaveq 
  801cae:	c3                   	retq   

0000000000801caf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801caf:	55                   	push   %rbp
  801cb0:	48 89 e5             	mov    %rsp,%rbp
  801cb3:	48 83 ec 30          	sub    $0x30,%rsp
  801cb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cbb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cbf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cc3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cc8:	75 07                	jne    801cd1 <devcons_read+0x22>
		return 0;
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	eb 4b                	jmp    801d1c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801cd1:	eb 0c                	jmp    801cdf <devcons_read+0x30>
		sys_yield();
  801cd3:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cdf:	48 b8 eb 01 80 00 00 	movabs $0x8001eb,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
  801ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cf2:	74 df                	je     801cd3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801cf4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cf8:	79 05                	jns    801cff <devcons_read+0x50>
		return c;
  801cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfd:	eb 1d                	jmp    801d1c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801cff:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d03:	75 07                	jne    801d0c <devcons_read+0x5d>
		return 0;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	eb 10                	jmp    801d1c <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0f:	89 c2                	mov    %eax,%edx
  801d11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d15:	88 10                	mov    %dl,(%rax)
	return 1;
  801d17:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d1c:	c9                   	leaveq 
  801d1d:	c3                   	retq   

0000000000801d1e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d1e:	55                   	push   %rbp
  801d1f:	48 89 e5             	mov    %rsp,%rbp
  801d22:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d29:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d30:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d37:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d45:	eb 76                	jmp    801dbd <devcons_write+0x9f>
		m = n - tot;
  801d47:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d4e:	89 c2                	mov    %eax,%edx
  801d50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d53:	29 c2                	sub    %eax,%edx
  801d55:	89 d0                	mov    %edx,%eax
  801d57:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d5d:	83 f8 7f             	cmp    $0x7f,%eax
  801d60:	76 07                	jbe    801d69 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d62:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d6c:	48 63 d0             	movslq %eax,%rdx
  801d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d72:	48 63 c8             	movslq %eax,%rcx
  801d75:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d7c:	48 01 c1             	add    %rax,%rcx
  801d7f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d86:	48 89 ce             	mov    %rcx,%rsi
  801d89:	48 89 c7             	mov    %rax,%rdi
  801d8c:	48 b8 40 2f 80 00 00 	movabs $0x802f40,%rax
  801d93:	00 00 00 
  801d96:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801d98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9b:	48 63 d0             	movslq %eax,%rdx
  801d9e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801da5:	48 89 d6             	mov    %rdx,%rsi
  801da8:	48 89 c7             	mov    %rax,%rdi
  801dab:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dba:	01 45 fc             	add    %eax,-0x4(%rbp)
  801dbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc0:	48 98                	cltq   
  801dc2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dc9:	0f 82 78 ff ff ff    	jb     801d47 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dd2:	c9                   	leaveq 
  801dd3:	c3                   	retq   

0000000000801dd4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801dd4:	55                   	push   %rbp
  801dd5:	48 89 e5             	mov    %rsp,%rbp
  801dd8:	48 83 ec 08          	sub    $0x8,%rsp
  801ddc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	c9                   	leaveq 
  801de6:	c3                   	retq   

0000000000801de7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801de7:	55                   	push   %rbp
  801de8:	48 89 e5             	mov    %rsp,%rbp
  801deb:	48 83 ec 10          	sub    $0x10,%rsp
  801def:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801df3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dfb:	48 be 7a 37 80 00 00 	movabs $0x80377a,%rsi
  801e02:	00 00 00 
  801e05:	48 89 c7             	mov    %rax,%rdi
  801e08:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  801e0f:	00 00 00 
  801e12:	ff d0                	callq  *%rax
	return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e19:	c9                   	leaveq 
  801e1a:	c3                   	retq   

0000000000801e1b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e1b:	55                   	push   %rbp
  801e1c:	48 89 e5             	mov    %rsp,%rbp
  801e1f:	53                   	push   %rbx
  801e20:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e27:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e2e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e34:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e3b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e42:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e49:	84 c0                	test   %al,%al
  801e4b:	74 23                	je     801e70 <_panic+0x55>
  801e4d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e54:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e58:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e5c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e60:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e64:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e68:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e6c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e70:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e77:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e7e:	00 00 00 
  801e81:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e88:	00 00 00 
  801e8b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e8f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801e96:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801e9d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ea4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801eab:	00 00 00 
  801eae:	48 8b 18             	mov    (%rax),%rbx
  801eb1:	48 b8 6d 02 80 00 00 	movabs $0x80026d,%rax
  801eb8:	00 00 00 
  801ebb:	ff d0                	callq  *%rax
  801ebd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801ec3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801eca:	41 89 c8             	mov    %ecx,%r8d
  801ecd:	48 89 d1             	mov    %rdx,%rcx
  801ed0:	48 89 da             	mov    %rbx,%rdx
  801ed3:	89 c6                	mov    %eax,%esi
  801ed5:	48 bf 88 37 80 00 00 	movabs $0x803788,%rdi
  801edc:	00 00 00 
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	49 b9 54 20 80 00 00 	movabs $0x802054,%r9
  801eeb:	00 00 00 
  801eee:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ef1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801ef8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801eff:	48 89 d6             	mov    %rdx,%rsi
  801f02:	48 89 c7             	mov    %rax,%rdi
  801f05:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  801f0c:	00 00 00 
  801f0f:	ff d0                	callq  *%rax
	cprintf("\n");
  801f11:	48 bf ab 37 80 00 00 	movabs $0x8037ab,%rdi
  801f18:	00 00 00 
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	48 ba 54 20 80 00 00 	movabs $0x802054,%rdx
  801f27:	00 00 00 
  801f2a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f2c:	cc                   	int3   
  801f2d:	eb fd                	jmp    801f2c <_panic+0x111>

0000000000801f2f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f2f:	55                   	push   %rbp
  801f30:	48 89 e5             	mov    %rsp,%rbp
  801f33:	48 83 ec 10          	sub    $0x10,%rsp
  801f37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f42:	8b 00                	mov    (%rax),%eax
  801f44:	8d 48 01             	lea    0x1(%rax),%ecx
  801f47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4b:	89 0a                	mov    %ecx,(%rdx)
  801f4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f50:	89 d1                	mov    %edx,%ecx
  801f52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f56:	48 98                	cltq   
  801f58:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f60:	8b 00                	mov    (%rax),%eax
  801f62:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f67:	75 2c                	jne    801f95 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6d:	8b 00                	mov    (%rax),%eax
  801f6f:	48 98                	cltq   
  801f71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f75:	48 83 c2 08          	add    $0x8,%rdx
  801f79:	48 89 c6             	mov    %rax,%rsi
  801f7c:	48 89 d7             	mov    %rdx,%rdi
  801f7f:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  801f86:	00 00 00 
  801f89:	ff d0                	callq  *%rax
        b->idx = 0;
  801f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f99:	8b 40 04             	mov    0x4(%rax),%eax
  801f9c:	8d 50 01             	lea    0x1(%rax),%edx
  801f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa3:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fa6:	c9                   	leaveq 
  801fa7:	c3                   	retq   

0000000000801fa8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fa8:	55                   	push   %rbp
  801fa9:	48 89 e5             	mov    %rsp,%rbp
  801fac:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fb3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fba:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fc1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fc8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fcf:	48 8b 0a             	mov    (%rdx),%rcx
  801fd2:	48 89 08             	mov    %rcx,(%rax)
  801fd5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fd9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fdd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801fe1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801fe5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801fec:	00 00 00 
    b.cnt = 0;
  801fef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801ff6:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801ff9:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802000:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802007:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80200e:	48 89 c6             	mov    %rax,%rsi
  802011:	48 bf 2f 1f 80 00 00 	movabs $0x801f2f,%rdi
  802018:	00 00 00 
  80201b:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  802022:	00 00 00 
  802025:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802027:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80202d:	48 98                	cltq   
  80202f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802036:	48 83 c2 08          	add    $0x8,%rdx
  80203a:	48 89 c6             	mov    %rax,%rsi
  80203d:	48 89 d7             	mov    %rdx,%rdi
  802040:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  802047:	00 00 00 
  80204a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80204c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802052:	c9                   	leaveq 
  802053:	c3                   	retq   

0000000000802054 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802054:	55                   	push   %rbp
  802055:	48 89 e5             	mov    %rsp,%rbp
  802058:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80205f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802066:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80206d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802074:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80207b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802082:	84 c0                	test   %al,%al
  802084:	74 20                	je     8020a6 <cprintf+0x52>
  802086:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80208a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80208e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802092:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802096:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80209a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80209e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020a2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020a6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020ad:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020b4:	00 00 00 
  8020b7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020be:	00 00 00 
  8020c1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020c5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020cc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020d3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020da:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020e1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020e8:	48 8b 0a             	mov    (%rdx),%rcx
  8020eb:	48 89 08             	mov    %rcx,(%rax)
  8020ee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8020f2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8020f6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8020fa:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8020fe:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802105:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80210c:	48 89 d6             	mov    %rdx,%rsi
  80210f:	48 89 c7             	mov    %rax,%rdi
  802112:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802119:	00 00 00 
  80211c:	ff d0                	callq  *%rax
  80211e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802124:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80212a:	c9                   	leaveq 
  80212b:	c3                   	retq   

000000000080212c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80212c:	55                   	push   %rbp
  80212d:	48 89 e5             	mov    %rsp,%rbp
  802130:	53                   	push   %rbx
  802131:	48 83 ec 38          	sub    $0x38,%rsp
  802135:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802139:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80213d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802141:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802144:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802148:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80214c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80214f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802153:	77 3b                	ja     802190 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802155:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802158:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80215c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80215f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802163:	ba 00 00 00 00       	mov    $0x0,%edx
  802168:	48 f7 f3             	div    %rbx
  80216b:	48 89 c2             	mov    %rax,%rdx
  80216e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802171:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802174:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217c:	41 89 f9             	mov    %edi,%r9d
  80217f:	48 89 c7             	mov    %rax,%rdi
  802182:	48 b8 2c 21 80 00 00 	movabs $0x80212c,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
  80218e:	eb 1e                	jmp    8021ae <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802190:	eb 12                	jmp    8021a4 <printnum+0x78>
			putch(padc, putdat);
  802192:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802196:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219d:	48 89 ce             	mov    %rcx,%rsi
  8021a0:	89 d7                	mov    %edx,%edi
  8021a2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021a4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021a8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021ac:	7f e4                	jg     802192 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021ae:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ba:	48 f7 f1             	div    %rcx
  8021bd:	48 89 d0             	mov    %rdx,%rax
  8021c0:	48 ba b0 39 80 00 00 	movabs $0x8039b0,%rdx
  8021c7:	00 00 00 
  8021ca:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021ce:	0f be d0             	movsbl %al,%edx
  8021d1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d9:	48 89 ce             	mov    %rcx,%rsi
  8021dc:	89 d7                	mov    %edx,%edi
  8021de:	ff d0                	callq  *%rax
}
  8021e0:	48 83 c4 38          	add    $0x38,%rsp
  8021e4:	5b                   	pop    %rbx
  8021e5:	5d                   	pop    %rbp
  8021e6:	c3                   	retq   

00000000008021e7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021e7:	55                   	push   %rbp
  8021e8:	48 89 e5             	mov    %rsp,%rbp
  8021eb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8021ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021f3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8021f6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8021fa:	7e 52                	jle    80224e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8021fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802200:	8b 00                	mov    (%rax),%eax
  802202:	83 f8 30             	cmp    $0x30,%eax
  802205:	73 24                	jae    80222b <getuint+0x44>
  802207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80220f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802213:	8b 00                	mov    (%rax),%eax
  802215:	89 c0                	mov    %eax,%eax
  802217:	48 01 d0             	add    %rdx,%rax
  80221a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80221e:	8b 12                	mov    (%rdx),%edx
  802220:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802223:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802227:	89 0a                	mov    %ecx,(%rdx)
  802229:	eb 17                	jmp    802242 <getuint+0x5b>
  80222b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802233:	48 89 d0             	mov    %rdx,%rax
  802236:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80223a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80223e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802242:	48 8b 00             	mov    (%rax),%rax
  802245:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802249:	e9 a3 00 00 00       	jmpq   8022f1 <getuint+0x10a>
	else if (lflag)
  80224e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802252:	74 4f                	je     8022a3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802258:	8b 00                	mov    (%rax),%eax
  80225a:	83 f8 30             	cmp    $0x30,%eax
  80225d:	73 24                	jae    802283 <getuint+0x9c>
  80225f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802263:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226b:	8b 00                	mov    (%rax),%eax
  80226d:	89 c0                	mov    %eax,%eax
  80226f:	48 01 d0             	add    %rdx,%rax
  802272:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802276:	8b 12                	mov    (%rdx),%edx
  802278:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80227b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227f:	89 0a                	mov    %ecx,(%rdx)
  802281:	eb 17                	jmp    80229a <getuint+0xb3>
  802283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802287:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80228b:	48 89 d0             	mov    %rdx,%rax
  80228e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802292:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802296:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80229a:	48 8b 00             	mov    (%rax),%rax
  80229d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022a1:	eb 4e                	jmp    8022f1 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a7:	8b 00                	mov    (%rax),%eax
  8022a9:	83 f8 30             	cmp    $0x30,%eax
  8022ac:	73 24                	jae    8022d2 <getuint+0xeb>
  8022ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ba:	8b 00                	mov    (%rax),%eax
  8022bc:	89 c0                	mov    %eax,%eax
  8022be:	48 01 d0             	add    %rdx,%rax
  8022c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c5:	8b 12                	mov    (%rdx),%edx
  8022c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ce:	89 0a                	mov    %ecx,(%rdx)
  8022d0:	eb 17                	jmp    8022e9 <getuint+0x102>
  8022d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022da:	48 89 d0             	mov    %rdx,%rax
  8022dd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022e9:	8b 00                	mov    (%rax),%eax
  8022eb:	89 c0                	mov    %eax,%eax
  8022ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8022f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022f5:	c9                   	leaveq 
  8022f6:	c3                   	retq   

00000000008022f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8022f7:	55                   	push   %rbp
  8022f8:	48 89 e5             	mov    %rsp,%rbp
  8022fb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8022ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802303:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802306:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80230a:	7e 52                	jle    80235e <getint+0x67>
		x=va_arg(*ap, long long);
  80230c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802310:	8b 00                	mov    (%rax),%eax
  802312:	83 f8 30             	cmp    $0x30,%eax
  802315:	73 24                	jae    80233b <getint+0x44>
  802317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80231f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802323:	8b 00                	mov    (%rax),%eax
  802325:	89 c0                	mov    %eax,%eax
  802327:	48 01 d0             	add    %rdx,%rax
  80232a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80232e:	8b 12                	mov    (%rdx),%edx
  802330:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802333:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802337:	89 0a                	mov    %ecx,(%rdx)
  802339:	eb 17                	jmp    802352 <getint+0x5b>
  80233b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802343:	48 89 d0             	mov    %rdx,%rax
  802346:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80234a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80234e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802352:	48 8b 00             	mov    (%rax),%rax
  802355:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802359:	e9 a3 00 00 00       	jmpq   802401 <getint+0x10a>
	else if (lflag)
  80235e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802362:	74 4f                	je     8023b3 <getint+0xbc>
		x=va_arg(*ap, long);
  802364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802368:	8b 00                	mov    (%rax),%eax
  80236a:	83 f8 30             	cmp    $0x30,%eax
  80236d:	73 24                	jae    802393 <getint+0x9c>
  80236f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802373:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802377:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237b:	8b 00                	mov    (%rax),%eax
  80237d:	89 c0                	mov    %eax,%eax
  80237f:	48 01 d0             	add    %rdx,%rax
  802382:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802386:	8b 12                	mov    (%rdx),%edx
  802388:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80238b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80238f:	89 0a                	mov    %ecx,(%rdx)
  802391:	eb 17                	jmp    8023aa <getint+0xb3>
  802393:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802397:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80239b:	48 89 d0             	mov    %rdx,%rax
  80239e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023aa:	48 8b 00             	mov    (%rax),%rax
  8023ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023b1:	eb 4e                	jmp    802401 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b7:	8b 00                	mov    (%rax),%eax
  8023b9:	83 f8 30             	cmp    $0x30,%eax
  8023bc:	73 24                	jae    8023e2 <getint+0xeb>
  8023be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ca:	8b 00                	mov    (%rax),%eax
  8023cc:	89 c0                	mov    %eax,%eax
  8023ce:	48 01 d0             	add    %rdx,%rax
  8023d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023d5:	8b 12                	mov    (%rdx),%edx
  8023d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023de:	89 0a                	mov    %ecx,(%rdx)
  8023e0:	eb 17                	jmp    8023f9 <getint+0x102>
  8023e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023ea:	48 89 d0             	mov    %rdx,%rax
  8023ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023f9:	8b 00                	mov    (%rax),%eax
  8023fb:	48 98                	cltq   
  8023fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802405:	c9                   	leaveq 
  802406:	c3                   	retq   

0000000000802407 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802407:	55                   	push   %rbp
  802408:	48 89 e5             	mov    %rsp,%rbp
  80240b:	41 54                	push   %r12
  80240d:	53                   	push   %rbx
  80240e:	48 83 ec 60          	sub    $0x60,%rsp
  802412:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802416:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80241a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80241e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802422:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802426:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80242a:	48 8b 0a             	mov    (%rdx),%rcx
  80242d:	48 89 08             	mov    %rcx,(%rax)
  802430:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802434:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802438:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80243c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802440:	eb 17                	jmp    802459 <vprintfmt+0x52>
			if (ch == '\0')
  802442:	85 db                	test   %ebx,%ebx
  802444:	0f 84 df 04 00 00    	je     802929 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80244a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80244e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802452:	48 89 d6             	mov    %rdx,%rsi
  802455:	89 df                	mov    %ebx,%edi
  802457:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802459:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80245d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802461:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802465:	0f b6 00             	movzbl (%rax),%eax
  802468:	0f b6 d8             	movzbl %al,%ebx
  80246b:	83 fb 25             	cmp    $0x25,%ebx
  80246e:	75 d2                	jne    802442 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802470:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802474:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80247b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802482:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802489:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802490:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802494:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802498:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80249c:	0f b6 00             	movzbl (%rax),%eax
  80249f:	0f b6 d8             	movzbl %al,%ebx
  8024a2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024a5:	83 f8 55             	cmp    $0x55,%eax
  8024a8:	0f 87 47 04 00 00    	ja     8028f5 <vprintfmt+0x4ee>
  8024ae:	89 c0                	mov    %eax,%eax
  8024b0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024b7:	00 
  8024b8:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  8024bf:	00 00 00 
  8024c2:	48 01 d0             	add    %rdx,%rax
  8024c5:	48 8b 00             	mov    (%rax),%rax
  8024c8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024ca:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024ce:	eb c0                	jmp    802490 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024d0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024d4:	eb ba                	jmp    802490 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024dd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024e0:	89 d0                	mov    %edx,%eax
  8024e2:	c1 e0 02             	shl    $0x2,%eax
  8024e5:	01 d0                	add    %edx,%eax
  8024e7:	01 c0                	add    %eax,%eax
  8024e9:	01 d8                	add    %ebx,%eax
  8024eb:	83 e8 30             	sub    $0x30,%eax
  8024ee:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8024f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024f5:	0f b6 00             	movzbl (%rax),%eax
  8024f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8024fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8024fe:	7e 0c                	jle    80250c <vprintfmt+0x105>
  802500:	83 fb 39             	cmp    $0x39,%ebx
  802503:	7f 07                	jg     80250c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802505:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80250a:	eb d1                	jmp    8024dd <vprintfmt+0xd6>
			goto process_precision;
  80250c:	eb 58                	jmp    802566 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80250e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802511:	83 f8 30             	cmp    $0x30,%eax
  802514:	73 17                	jae    80252d <vprintfmt+0x126>
  802516:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80251a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80251d:	89 c0                	mov    %eax,%eax
  80251f:	48 01 d0             	add    %rdx,%rax
  802522:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802525:	83 c2 08             	add    $0x8,%edx
  802528:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80252b:	eb 0f                	jmp    80253c <vprintfmt+0x135>
  80252d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802531:	48 89 d0             	mov    %rdx,%rax
  802534:	48 83 c2 08          	add    $0x8,%rdx
  802538:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80253c:	8b 00                	mov    (%rax),%eax
  80253e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802541:	eb 23                	jmp    802566 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802543:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802547:	79 0c                	jns    802555 <vprintfmt+0x14e>
				width = 0;
  802549:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802550:	e9 3b ff ff ff       	jmpq   802490 <vprintfmt+0x89>
  802555:	e9 36 ff ff ff       	jmpq   802490 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80255a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802561:	e9 2a ff ff ff       	jmpq   802490 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802566:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80256a:	79 12                	jns    80257e <vprintfmt+0x177>
				width = precision, precision = -1;
  80256c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80256f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802572:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802579:	e9 12 ff ff ff       	jmpq   802490 <vprintfmt+0x89>
  80257e:	e9 0d ff ff ff       	jmpq   802490 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802583:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802587:	e9 04 ff ff ff       	jmpq   802490 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80258c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80258f:	83 f8 30             	cmp    $0x30,%eax
  802592:	73 17                	jae    8025ab <vprintfmt+0x1a4>
  802594:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802598:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80259b:	89 c0                	mov    %eax,%eax
  80259d:	48 01 d0             	add    %rdx,%rax
  8025a0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025a3:	83 c2 08             	add    $0x8,%edx
  8025a6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025a9:	eb 0f                	jmp    8025ba <vprintfmt+0x1b3>
  8025ab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025af:	48 89 d0             	mov    %rdx,%rax
  8025b2:	48 83 c2 08          	add    $0x8,%rdx
  8025b6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025ba:	8b 10                	mov    (%rax),%edx
  8025bc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025c4:	48 89 ce             	mov    %rcx,%rsi
  8025c7:	89 d7                	mov    %edx,%edi
  8025c9:	ff d0                	callq  *%rax
			break;
  8025cb:	e9 53 03 00 00       	jmpq   802923 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025d3:	83 f8 30             	cmp    $0x30,%eax
  8025d6:	73 17                	jae    8025ef <vprintfmt+0x1e8>
  8025d8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025df:	89 c0                	mov    %eax,%eax
  8025e1:	48 01 d0             	add    %rdx,%rax
  8025e4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025e7:	83 c2 08             	add    $0x8,%edx
  8025ea:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025ed:	eb 0f                	jmp    8025fe <vprintfmt+0x1f7>
  8025ef:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025f3:	48 89 d0             	mov    %rdx,%rax
  8025f6:	48 83 c2 08          	add    $0x8,%rdx
  8025fa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025fe:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802600:	85 db                	test   %ebx,%ebx
  802602:	79 02                	jns    802606 <vprintfmt+0x1ff>
				err = -err;
  802604:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802606:	83 fb 15             	cmp    $0x15,%ebx
  802609:	7f 16                	jg     802621 <vprintfmt+0x21a>
  80260b:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  802612:	00 00 00 
  802615:	48 63 d3             	movslq %ebx,%rdx
  802618:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80261c:	4d 85 e4             	test   %r12,%r12
  80261f:	75 2e                	jne    80264f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802621:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802625:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802629:	89 d9                	mov    %ebx,%ecx
  80262b:	48 ba c1 39 80 00 00 	movabs $0x8039c1,%rdx
  802632:	00 00 00 
  802635:	48 89 c7             	mov    %rax,%rdi
  802638:	b8 00 00 00 00       	mov    $0x0,%eax
  80263d:	49 b8 32 29 80 00 00 	movabs $0x802932,%r8
  802644:	00 00 00 
  802647:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80264a:	e9 d4 02 00 00       	jmpq   802923 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80264f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802653:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802657:	4c 89 e1             	mov    %r12,%rcx
  80265a:	48 ba ca 39 80 00 00 	movabs $0x8039ca,%rdx
  802661:	00 00 00 
  802664:	48 89 c7             	mov    %rax,%rdi
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	49 b8 32 29 80 00 00 	movabs $0x802932,%r8
  802673:	00 00 00 
  802676:	41 ff d0             	callq  *%r8
			break;
  802679:	e9 a5 02 00 00       	jmpq   802923 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80267e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802681:	83 f8 30             	cmp    $0x30,%eax
  802684:	73 17                	jae    80269d <vprintfmt+0x296>
  802686:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80268a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80268d:	89 c0                	mov    %eax,%eax
  80268f:	48 01 d0             	add    %rdx,%rax
  802692:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802695:	83 c2 08             	add    $0x8,%edx
  802698:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80269b:	eb 0f                	jmp    8026ac <vprintfmt+0x2a5>
  80269d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026a1:	48 89 d0             	mov    %rdx,%rax
  8026a4:	48 83 c2 08          	add    $0x8,%rdx
  8026a8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026ac:	4c 8b 20             	mov    (%rax),%r12
  8026af:	4d 85 e4             	test   %r12,%r12
  8026b2:	75 0a                	jne    8026be <vprintfmt+0x2b7>
				p = "(null)";
  8026b4:	49 bc cd 39 80 00 00 	movabs $0x8039cd,%r12
  8026bb:	00 00 00 
			if (width > 0 && padc != '-')
  8026be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026c2:	7e 3f                	jle    802703 <vprintfmt+0x2fc>
  8026c4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026c8:	74 39                	je     802703 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026ca:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026cd:	48 98                	cltq   
  8026cf:	48 89 c6             	mov    %rax,%rsi
  8026d2:	4c 89 e7             	mov    %r12,%rdi
  8026d5:	48 b8 de 2b 80 00 00 	movabs $0x802bde,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
  8026e1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026e4:	eb 17                	jmp    8026fd <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026e6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8026ea:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8026ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026f2:	48 89 ce             	mov    %rcx,%rsi
  8026f5:	89 d7                	mov    %edx,%edi
  8026f7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8026f9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802701:	7f e3                	jg     8026e6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802703:	eb 37                	jmp    80273c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802705:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802709:	74 1e                	je     802729 <vprintfmt+0x322>
  80270b:	83 fb 1f             	cmp    $0x1f,%ebx
  80270e:	7e 05                	jle    802715 <vprintfmt+0x30e>
  802710:	83 fb 7e             	cmp    $0x7e,%ebx
  802713:	7e 14                	jle    802729 <vprintfmt+0x322>
					putch('?', putdat);
  802715:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802719:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80271d:	48 89 d6             	mov    %rdx,%rsi
  802720:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802725:	ff d0                	callq  *%rax
  802727:	eb 0f                	jmp    802738 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802729:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80272d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802731:	48 89 d6             	mov    %rdx,%rsi
  802734:	89 df                	mov    %ebx,%edi
  802736:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802738:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80273c:	4c 89 e0             	mov    %r12,%rax
  80273f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802743:	0f b6 00             	movzbl (%rax),%eax
  802746:	0f be d8             	movsbl %al,%ebx
  802749:	85 db                	test   %ebx,%ebx
  80274b:	74 10                	je     80275d <vprintfmt+0x356>
  80274d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802751:	78 b2                	js     802705 <vprintfmt+0x2fe>
  802753:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802757:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80275b:	79 a8                	jns    802705 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80275d:	eb 16                	jmp    802775 <vprintfmt+0x36e>
				putch(' ', putdat);
  80275f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802763:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802767:	48 89 d6             	mov    %rdx,%rsi
  80276a:	bf 20 00 00 00       	mov    $0x20,%edi
  80276f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802771:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802775:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802779:	7f e4                	jg     80275f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80277b:	e9 a3 01 00 00       	jmpq   802923 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802780:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802784:	be 03 00 00 00       	mov    $0x3,%esi
  802789:	48 89 c7             	mov    %rax,%rdi
  80278c:	48 b8 f7 22 80 00 00 	movabs $0x8022f7,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80279c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a0:	48 85 c0             	test   %rax,%rax
  8027a3:	79 1d                	jns    8027c2 <vprintfmt+0x3bb>
				putch('-', putdat);
  8027a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027ad:	48 89 d6             	mov    %rdx,%rsi
  8027b0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027b5:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bb:	48 f7 d8             	neg    %rax
  8027be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027c2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027c9:	e9 e8 00 00 00       	jmpq   8028b6 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027ce:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027d2:	be 03 00 00 00       	mov    $0x3,%esi
  8027d7:	48 89 c7             	mov    %rax,%rdi
  8027da:	48 b8 e7 21 80 00 00 	movabs $0x8021e7,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
  8027e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8027ea:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027f1:	e9 c0 00 00 00       	jmpq   8028b6 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8027f6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027fe:	48 89 d6             	mov    %rdx,%rsi
  802801:	bf 58 00 00 00       	mov    $0x58,%edi
  802806:	ff d0                	callq  *%rax
			putch('X', putdat);
  802808:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80280c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802810:	48 89 d6             	mov    %rdx,%rsi
  802813:	bf 58 00 00 00       	mov    $0x58,%edi
  802818:	ff d0                	callq  *%rax
			putch('X', putdat);
  80281a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80281e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802822:	48 89 d6             	mov    %rdx,%rsi
  802825:	bf 58 00 00 00       	mov    $0x58,%edi
  80282a:	ff d0                	callq  *%rax
			break;
  80282c:	e9 f2 00 00 00       	jmpq   802923 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802831:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802835:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802839:	48 89 d6             	mov    %rdx,%rsi
  80283c:	bf 30 00 00 00       	mov    $0x30,%edi
  802841:	ff d0                	callq  *%rax
			putch('x', putdat);
  802843:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802847:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80284b:	48 89 d6             	mov    %rdx,%rsi
  80284e:	bf 78 00 00 00       	mov    $0x78,%edi
  802853:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802855:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802858:	83 f8 30             	cmp    $0x30,%eax
  80285b:	73 17                	jae    802874 <vprintfmt+0x46d>
  80285d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802861:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802864:	89 c0                	mov    %eax,%eax
  802866:	48 01 d0             	add    %rdx,%rax
  802869:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80286c:	83 c2 08             	add    $0x8,%edx
  80286f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802872:	eb 0f                	jmp    802883 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  802874:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802878:	48 89 d0             	mov    %rdx,%rax
  80287b:	48 83 c2 08          	add    $0x8,%rdx
  80287f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802883:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802886:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80288a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802891:	eb 23                	jmp    8028b6 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802893:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802897:	be 03 00 00 00       	mov    $0x3,%esi
  80289c:	48 89 c7             	mov    %rax,%rdi
  80289f:	48 b8 e7 21 80 00 00 	movabs $0x8021e7,%rax
  8028a6:	00 00 00 
  8028a9:	ff d0                	callq  *%rax
  8028ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028af:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028b6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028bb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028be:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028c5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028cd:	45 89 c1             	mov    %r8d,%r9d
  8028d0:	41 89 f8             	mov    %edi,%r8d
  8028d3:	48 89 c7             	mov    %rax,%rdi
  8028d6:	48 b8 2c 21 80 00 00 	movabs $0x80212c,%rax
  8028dd:	00 00 00 
  8028e0:	ff d0                	callq  *%rax
			break;
  8028e2:	eb 3f                	jmp    802923 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028ec:	48 89 d6             	mov    %rdx,%rsi
  8028ef:	89 df                	mov    %ebx,%edi
  8028f1:	ff d0                	callq  *%rax
			break;
  8028f3:	eb 2e                	jmp    802923 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8028f5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028fd:	48 89 d6             	mov    %rdx,%rsi
  802900:	bf 25 00 00 00       	mov    $0x25,%edi
  802905:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802907:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80290c:	eb 05                	jmp    802913 <vprintfmt+0x50c>
  80290e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802913:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802917:	48 83 e8 01          	sub    $0x1,%rax
  80291b:	0f b6 00             	movzbl (%rax),%eax
  80291e:	3c 25                	cmp    $0x25,%al
  802920:	75 ec                	jne    80290e <vprintfmt+0x507>
				/* do nothing */;
			break;
  802922:	90                   	nop
		}
	}
  802923:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802924:	e9 30 fb ff ff       	jmpq   802459 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802929:	48 83 c4 60          	add    $0x60,%rsp
  80292d:	5b                   	pop    %rbx
  80292e:	41 5c                	pop    %r12
  802930:	5d                   	pop    %rbp
  802931:	c3                   	retq   

0000000000802932 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802932:	55                   	push   %rbp
  802933:	48 89 e5             	mov    %rsp,%rbp
  802936:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80293d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802944:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80294b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802952:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802959:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802960:	84 c0                	test   %al,%al
  802962:	74 20                	je     802984 <printfmt+0x52>
  802964:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802968:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80296c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802970:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802974:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802978:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80297c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802980:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802984:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80298b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802992:	00 00 00 
  802995:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80299c:	00 00 00 
  80299f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029a3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029aa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029b1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029b8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029bf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029c6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029cd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029d4:	48 89 c7             	mov    %rax,%rdi
  8029d7:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029e3:	c9                   	leaveq 
  8029e4:	c3                   	retq   

00000000008029e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029e5:	55                   	push   %rbp
  8029e6:	48 89 e5             	mov    %rsp,%rbp
  8029e9:	48 83 ec 10          	sub    $0x10,%rsp
  8029ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8029f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f8:	8b 40 10             	mov    0x10(%rax),%eax
  8029fb:	8d 50 01             	lea    0x1(%rax),%edx
  8029fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a02:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a09:	48 8b 10             	mov    (%rax),%rdx
  802a0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a10:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a14:	48 39 c2             	cmp    %rax,%rdx
  802a17:	73 17                	jae    802a30 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1d:	48 8b 00             	mov    (%rax),%rax
  802a20:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a28:	48 89 0a             	mov    %rcx,(%rdx)
  802a2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a2e:	88 10                	mov    %dl,(%rax)
}
  802a30:	c9                   	leaveq 
  802a31:	c3                   	retq   

0000000000802a32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a32:	55                   	push   %rbp
  802a33:	48 89 e5             	mov    %rsp,%rbp
  802a36:	48 83 ec 50          	sub    $0x50,%rsp
  802a3a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a3e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a41:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a45:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a49:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a4d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a51:	48 8b 0a             	mov    (%rdx),%rcx
  802a54:	48 89 08             	mov    %rcx,(%rax)
  802a57:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a5b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a5f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a63:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a6b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a6f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a72:	48 98                	cltq   
  802a74:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a7c:	48 01 d0             	add    %rdx,%rax
  802a7f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a83:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a8a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a8f:	74 06                	je     802a97 <vsnprintf+0x65>
  802a91:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802a95:	7f 07                	jg     802a9e <vsnprintf+0x6c>
		return -E_INVAL;
  802a97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a9c:	eb 2f                	jmp    802acd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802a9e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802aa2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802aa6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802aaa:	48 89 c6             	mov    %rax,%rsi
  802aad:	48 bf e5 29 80 00 00 	movabs $0x8029e5,%rdi
  802ab4:	00 00 00 
  802ab7:	48 b8 07 24 80 00 00 	movabs $0x802407,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802ac3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ac7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802aca:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802acd:	c9                   	leaveq 
  802ace:	c3                   	retq   

0000000000802acf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802acf:	55                   	push   %rbp
  802ad0:	48 89 e5             	mov    %rsp,%rbp
  802ad3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802ada:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802ae1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802ae7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802aee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802af5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802afc:	84 c0                	test   %al,%al
  802afe:	74 20                	je     802b20 <snprintf+0x51>
  802b00:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b04:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b08:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b0c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b10:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b14:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b18:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b1c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b20:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b27:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b2e:	00 00 00 
  802b31:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b38:	00 00 00 
  802b3b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b3f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b46:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b4d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b54:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b5b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b62:	48 8b 0a             	mov    (%rdx),%rcx
  802b65:	48 89 08             	mov    %rcx,(%rax)
  802b68:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b6c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b70:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b74:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b78:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b7f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b86:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b8c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b93:	48 89 c7             	mov    %rax,%rdi
  802b96:	48 b8 32 2a 80 00 00 	movabs $0x802a32,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
  802ba2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802ba8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bae:	c9                   	leaveq 
  802baf:	c3                   	retq   

0000000000802bb0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802bb0:	55                   	push   %rbp
  802bb1:	48 89 e5             	mov    %rsp,%rbp
  802bb4:	48 83 ec 18          	sub    $0x18,%rsp
  802bb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bc3:	eb 09                	jmp    802bce <strlen+0x1e>
		n++;
  802bc5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bc9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd2:	0f b6 00             	movzbl (%rax),%eax
  802bd5:	84 c0                	test   %al,%al
  802bd7:	75 ec                	jne    802bc5 <strlen+0x15>
		n++;
	return n;
  802bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bdc:	c9                   	leaveq 
  802bdd:	c3                   	retq   

0000000000802bde <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802bde:	55                   	push   %rbp
  802bdf:	48 89 e5             	mov    %rsp,%rbp
  802be2:	48 83 ec 20          	sub    $0x20,%rsp
  802be6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bf5:	eb 0e                	jmp    802c05 <strnlen+0x27>
		n++;
  802bf7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bfb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c00:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c05:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c0a:	74 0b                	je     802c17 <strnlen+0x39>
  802c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c10:	0f b6 00             	movzbl (%rax),%eax
  802c13:	84 c0                	test   %al,%al
  802c15:	75 e0                	jne    802bf7 <strnlen+0x19>
		n++;
	return n;
  802c17:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c1a:	c9                   	leaveq 
  802c1b:	c3                   	retq   

0000000000802c1c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c1c:	55                   	push   %rbp
  802c1d:	48 89 e5             	mov    %rsp,%rbp
  802c20:	48 83 ec 20          	sub    $0x20,%rsp
  802c24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c34:	90                   	nop
  802c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c39:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c3d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c41:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c45:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c49:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c4d:	0f b6 12             	movzbl (%rdx),%edx
  802c50:	88 10                	mov    %dl,(%rax)
  802c52:	0f b6 00             	movzbl (%rax),%eax
  802c55:	84 c0                	test   %al,%al
  802c57:	75 dc                	jne    802c35 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 20          	sub    $0x20,%rsp
  802c67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c73:	48 89 c7             	mov    %rax,%rdi
  802c76:	48 b8 b0 2b 80 00 00 	movabs $0x802bb0,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c88:	48 63 d0             	movslq %eax,%rdx
  802c8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8f:	48 01 c2             	add    %rax,%rdx
  802c92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c96:	48 89 c6             	mov    %rax,%rsi
  802c99:	48 89 d7             	mov    %rdx,%rdi
  802c9c:	48 b8 1c 2c 80 00 00 	movabs $0x802c1c,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
	return dst;
  802ca8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802cac:	c9                   	leaveq 
  802cad:	c3                   	retq   

0000000000802cae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802cae:	55                   	push   %rbp
  802caf:	48 89 e5             	mov    %rsp,%rbp
  802cb2:	48 83 ec 28          	sub    $0x28,%rsp
  802cb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cbe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802cca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802cd1:	00 
  802cd2:	eb 2a                	jmp    802cfe <strncpy+0x50>
		*dst++ = *src;
  802cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cdc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ce0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ce4:	0f b6 12             	movzbl (%rdx),%edx
  802ce7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802ce9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ced:	0f b6 00             	movzbl (%rax),%eax
  802cf0:	84 c0                	test   %al,%al
  802cf2:	74 05                	je     802cf9 <strncpy+0x4b>
			src++;
  802cf4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802cf9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d02:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d06:	72 cc                	jb     802cd4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 28          	sub    $0x28,%rsp
  802d16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d2a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d2f:	74 3d                	je     802d6e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d31:	eb 1d                	jmp    802d50 <strlcpy+0x42>
			*dst++ = *src++;
  802d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d37:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d3b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d3f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d43:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d47:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d4b:	0f b6 12             	movzbl (%rdx),%edx
  802d4e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d50:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d55:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d5a:	74 0b                	je     802d67 <strlcpy+0x59>
  802d5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d60:	0f b6 00             	movzbl (%rax),%eax
  802d63:	84 c0                	test   %al,%al
  802d65:	75 cc                	jne    802d33 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d76:	48 29 c2             	sub    %rax,%rdx
  802d79:	48 89 d0             	mov    %rdx,%rax
}
  802d7c:	c9                   	leaveq 
  802d7d:	c3                   	retq   

0000000000802d7e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d7e:	55                   	push   %rbp
  802d7f:	48 89 e5             	mov    %rsp,%rbp
  802d82:	48 83 ec 10          	sub    $0x10,%rsp
  802d86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d8e:	eb 0a                	jmp    802d9a <strcmp+0x1c>
		p++, q++;
  802d90:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d95:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9e:	0f b6 00             	movzbl (%rax),%eax
  802da1:	84 c0                	test   %al,%al
  802da3:	74 12                	je     802db7 <strcmp+0x39>
  802da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da9:	0f b6 10             	movzbl (%rax),%edx
  802dac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db0:	0f b6 00             	movzbl (%rax),%eax
  802db3:	38 c2                	cmp    %al,%dl
  802db5:	74 d9                	je     802d90 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dbb:	0f b6 00             	movzbl (%rax),%eax
  802dbe:	0f b6 d0             	movzbl %al,%edx
  802dc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc5:	0f b6 00             	movzbl (%rax),%eax
  802dc8:	0f b6 c0             	movzbl %al,%eax
  802dcb:	29 c2                	sub    %eax,%edx
  802dcd:	89 d0                	mov    %edx,%eax
}
  802dcf:	c9                   	leaveq 
  802dd0:	c3                   	retq   

0000000000802dd1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802dd1:	55                   	push   %rbp
  802dd2:	48 89 e5             	mov    %rsp,%rbp
  802dd5:	48 83 ec 18          	sub    $0x18,%rsp
  802dd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ddd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802de1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802de5:	eb 0f                	jmp    802df6 <strncmp+0x25>
		n--, p++, q++;
  802de7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802dec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802df1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802df6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802dfb:	74 1d                	je     802e1a <strncmp+0x49>
  802dfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e01:	0f b6 00             	movzbl (%rax),%eax
  802e04:	84 c0                	test   %al,%al
  802e06:	74 12                	je     802e1a <strncmp+0x49>
  802e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0c:	0f b6 10             	movzbl (%rax),%edx
  802e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e13:	0f b6 00             	movzbl (%rax),%eax
  802e16:	38 c2                	cmp    %al,%dl
  802e18:	74 cd                	je     802de7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e1a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e1f:	75 07                	jne    802e28 <strncmp+0x57>
		return 0;
  802e21:	b8 00 00 00 00       	mov    $0x0,%eax
  802e26:	eb 18                	jmp    802e40 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e2c:	0f b6 00             	movzbl (%rax),%eax
  802e2f:	0f b6 d0             	movzbl %al,%edx
  802e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e36:	0f b6 00             	movzbl (%rax),%eax
  802e39:	0f b6 c0             	movzbl %al,%eax
  802e3c:	29 c2                	sub    %eax,%edx
  802e3e:	89 d0                	mov    %edx,%eax
}
  802e40:	c9                   	leaveq 
  802e41:	c3                   	retq   

0000000000802e42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e42:	55                   	push   %rbp
  802e43:	48 89 e5             	mov    %rsp,%rbp
  802e46:	48 83 ec 0c          	sub    $0xc,%rsp
  802e4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e4e:	89 f0                	mov    %esi,%eax
  802e50:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e53:	eb 17                	jmp    802e6c <strchr+0x2a>
		if (*s == c)
  802e55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e59:	0f b6 00             	movzbl (%rax),%eax
  802e5c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e5f:	75 06                	jne    802e67 <strchr+0x25>
			return (char *) s;
  802e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e65:	eb 15                	jmp    802e7c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e67:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e70:	0f b6 00             	movzbl (%rax),%eax
  802e73:	84 c0                	test   %al,%al
  802e75:	75 de                	jne    802e55 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e7c:	c9                   	leaveq 
  802e7d:	c3                   	retq   

0000000000802e7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e7e:	55                   	push   %rbp
  802e7f:	48 89 e5             	mov    %rsp,%rbp
  802e82:	48 83 ec 0c          	sub    $0xc,%rsp
  802e86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e8a:	89 f0                	mov    %esi,%eax
  802e8c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e8f:	eb 13                	jmp    802ea4 <strfind+0x26>
		if (*s == c)
  802e91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e95:	0f b6 00             	movzbl (%rax),%eax
  802e98:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e9b:	75 02                	jne    802e9f <strfind+0x21>
			break;
  802e9d:	eb 10                	jmp    802eaf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802e9f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea8:	0f b6 00             	movzbl (%rax),%eax
  802eab:	84 c0                	test   %al,%al
  802ead:	75 e2                	jne    802e91 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802eb3:	c9                   	leaveq 
  802eb4:	c3                   	retq   

0000000000802eb5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802eb5:	55                   	push   %rbp
  802eb6:	48 89 e5             	mov    %rsp,%rbp
  802eb9:	48 83 ec 18          	sub    $0x18,%rsp
  802ebd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ec1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ec4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ec8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ecd:	75 06                	jne    802ed5 <memset+0x20>
		return v;
  802ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed3:	eb 69                	jmp    802f3e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802ed5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed9:	83 e0 03             	and    $0x3,%eax
  802edc:	48 85 c0             	test   %rax,%rax
  802edf:	75 48                	jne    802f29 <memset+0x74>
  802ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee5:	83 e0 03             	and    $0x3,%eax
  802ee8:	48 85 c0             	test   %rax,%rax
  802eeb:	75 3c                	jne    802f29 <memset+0x74>
		c &= 0xFF;
  802eed:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802ef4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ef7:	c1 e0 18             	shl    $0x18,%eax
  802efa:	89 c2                	mov    %eax,%edx
  802efc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eff:	c1 e0 10             	shl    $0x10,%eax
  802f02:	09 c2                	or     %eax,%edx
  802f04:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f07:	c1 e0 08             	shl    $0x8,%eax
  802f0a:	09 d0                	or     %edx,%eax
  802f0c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f13:	48 c1 e8 02          	shr    $0x2,%rax
  802f17:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f1a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f1e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f21:	48 89 d7             	mov    %rdx,%rdi
  802f24:	fc                   	cld    
  802f25:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f27:	eb 11                	jmp    802f3a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f29:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f2d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f34:	48 89 d7             	mov    %rdx,%rdi
  802f37:	fc                   	cld    
  802f38:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f3e:	c9                   	leaveq 
  802f3f:	c3                   	retq   

0000000000802f40 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f40:	55                   	push   %rbp
  802f41:	48 89 e5             	mov    %rsp,%rbp
  802f44:	48 83 ec 28          	sub    $0x28,%rsp
  802f48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f50:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f58:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f68:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f6c:	0f 83 88 00 00 00    	jae    802ffa <memmove+0xba>
  802f72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f76:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f7a:	48 01 d0             	add    %rdx,%rax
  802f7d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f81:	76 77                	jbe    802ffa <memmove+0xba>
		s += n;
  802f83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f87:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f97:	83 e0 03             	and    $0x3,%eax
  802f9a:	48 85 c0             	test   %rax,%rax
  802f9d:	75 3b                	jne    802fda <memmove+0x9a>
  802f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa3:	83 e0 03             	and    $0x3,%eax
  802fa6:	48 85 c0             	test   %rax,%rax
  802fa9:	75 2f                	jne    802fda <memmove+0x9a>
  802fab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802faf:	83 e0 03             	and    $0x3,%eax
  802fb2:	48 85 c0             	test   %rax,%rax
  802fb5:	75 23                	jne    802fda <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbb:	48 83 e8 04          	sub    $0x4,%rax
  802fbf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fc3:	48 83 ea 04          	sub    $0x4,%rdx
  802fc7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fcb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fcf:	48 89 c7             	mov    %rax,%rdi
  802fd2:	48 89 d6             	mov    %rdx,%rsi
  802fd5:	fd                   	std    
  802fd6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fd8:	eb 1d                	jmp    802ff7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fde:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802fe2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802fea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fee:	48 89 d7             	mov    %rdx,%rdi
  802ff1:	48 89 c1             	mov    %rax,%rcx
  802ff4:	fd                   	std    
  802ff5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802ff7:	fc                   	cld    
  802ff8:	eb 57                	jmp    803051 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802ffa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffe:	83 e0 03             	and    $0x3,%eax
  803001:	48 85 c0             	test   %rax,%rax
  803004:	75 36                	jne    80303c <memmove+0xfc>
  803006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300a:	83 e0 03             	and    $0x3,%eax
  80300d:	48 85 c0             	test   %rax,%rax
  803010:	75 2a                	jne    80303c <memmove+0xfc>
  803012:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803016:	83 e0 03             	and    $0x3,%eax
  803019:	48 85 c0             	test   %rax,%rax
  80301c:	75 1e                	jne    80303c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80301e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803022:	48 c1 e8 02          	shr    $0x2,%rax
  803026:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80302d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803031:	48 89 c7             	mov    %rax,%rdi
  803034:	48 89 d6             	mov    %rdx,%rsi
  803037:	fc                   	cld    
  803038:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80303a:	eb 15                	jmp    803051 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80303c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803040:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803044:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803048:	48 89 c7             	mov    %rax,%rdi
  80304b:	48 89 d6             	mov    %rdx,%rsi
  80304e:	fc                   	cld    
  80304f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803055:	c9                   	leaveq 
  803056:	c3                   	retq   

0000000000803057 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803057:	55                   	push   %rbp
  803058:	48 89 e5             	mov    %rsp,%rbp
  80305b:	48 83 ec 18          	sub    $0x18,%rsp
  80305f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803063:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803067:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80306b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80306f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803073:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803077:	48 89 ce             	mov    %rcx,%rsi
  80307a:	48 89 c7             	mov    %rax,%rdi
  80307d:	48 b8 40 2f 80 00 00 	movabs $0x802f40,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
}
  803089:	c9                   	leaveq 
  80308a:	c3                   	retq   

000000000080308b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80308b:	55                   	push   %rbp
  80308c:	48 89 e5             	mov    %rsp,%rbp
  80308f:	48 83 ec 28          	sub    $0x28,%rsp
  803093:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803097:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80309b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80309f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030af:	eb 36                	jmp    8030e7 <memcmp+0x5c>
		if (*s1 != *s2)
  8030b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b5:	0f b6 10             	movzbl (%rax),%edx
  8030b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bc:	0f b6 00             	movzbl (%rax),%eax
  8030bf:	38 c2                	cmp    %al,%dl
  8030c1:	74 1a                	je     8030dd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c7:	0f b6 00             	movzbl (%rax),%eax
  8030ca:	0f b6 d0             	movzbl %al,%edx
  8030cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d1:	0f b6 00             	movzbl (%rax),%eax
  8030d4:	0f b6 c0             	movzbl %al,%eax
  8030d7:	29 c2                	sub    %eax,%edx
  8030d9:	89 d0                	mov    %edx,%eax
  8030db:	eb 20                	jmp    8030fd <memcmp+0x72>
		s1++, s2++;
  8030dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030e2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030eb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8030f3:	48 85 c0             	test   %rax,%rax
  8030f6:	75 b9                	jne    8030b1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8030f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030fd:	c9                   	leaveq 
  8030fe:	c3                   	retq   

00000000008030ff <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8030ff:	55                   	push   %rbp
  803100:	48 89 e5             	mov    %rsp,%rbp
  803103:	48 83 ec 28          	sub    $0x28,%rsp
  803107:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80310b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80310e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803116:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80311a:	48 01 d0             	add    %rdx,%rax
  80311d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803121:	eb 15                	jmp    803138 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803127:	0f b6 10             	movzbl (%rax),%edx
  80312a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80312d:	38 c2                	cmp    %al,%dl
  80312f:	75 02                	jne    803133 <memfind+0x34>
			break;
  803131:	eb 0f                	jmp    803142 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803133:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803140:	72 e1                	jb     803123 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803146:	c9                   	leaveq 
  803147:	c3                   	retq   

0000000000803148 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803148:	55                   	push   %rbp
  803149:	48 89 e5             	mov    %rsp,%rbp
  80314c:	48 83 ec 34          	sub    $0x34,%rsp
  803150:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803154:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803158:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80315b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803162:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803169:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80316a:	eb 05                	jmp    803171 <strtol+0x29>
		s++;
  80316c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803171:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803175:	0f b6 00             	movzbl (%rax),%eax
  803178:	3c 20                	cmp    $0x20,%al
  80317a:	74 f0                	je     80316c <strtol+0x24>
  80317c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803180:	0f b6 00             	movzbl (%rax),%eax
  803183:	3c 09                	cmp    $0x9,%al
  803185:	74 e5                	je     80316c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803187:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318b:	0f b6 00             	movzbl (%rax),%eax
  80318e:	3c 2b                	cmp    $0x2b,%al
  803190:	75 07                	jne    803199 <strtol+0x51>
		s++;
  803192:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803197:	eb 17                	jmp    8031b0 <strtol+0x68>
	else if (*s == '-')
  803199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80319d:	0f b6 00             	movzbl (%rax),%eax
  8031a0:	3c 2d                	cmp    $0x2d,%al
  8031a2:	75 0c                	jne    8031b0 <strtol+0x68>
		s++, neg = 1;
  8031a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031b4:	74 06                	je     8031bc <strtol+0x74>
  8031b6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031ba:	75 28                	jne    8031e4 <strtol+0x9c>
  8031bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c0:	0f b6 00             	movzbl (%rax),%eax
  8031c3:	3c 30                	cmp    $0x30,%al
  8031c5:	75 1d                	jne    8031e4 <strtol+0x9c>
  8031c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031cb:	48 83 c0 01          	add    $0x1,%rax
  8031cf:	0f b6 00             	movzbl (%rax),%eax
  8031d2:	3c 78                	cmp    $0x78,%al
  8031d4:	75 0e                	jne    8031e4 <strtol+0x9c>
		s += 2, base = 16;
  8031d6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031db:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031e2:	eb 2c                	jmp    803210 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031e4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031e8:	75 19                	jne    803203 <strtol+0xbb>
  8031ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ee:	0f b6 00             	movzbl (%rax),%eax
  8031f1:	3c 30                	cmp    $0x30,%al
  8031f3:	75 0e                	jne    803203 <strtol+0xbb>
		s++, base = 8;
  8031f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031fa:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803201:	eb 0d                	jmp    803210 <strtol+0xc8>
	else if (base == 0)
  803203:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803207:	75 07                	jne    803210 <strtol+0xc8>
		base = 10;
  803209:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803210:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803214:	0f b6 00             	movzbl (%rax),%eax
  803217:	3c 2f                	cmp    $0x2f,%al
  803219:	7e 1d                	jle    803238 <strtol+0xf0>
  80321b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321f:	0f b6 00             	movzbl (%rax),%eax
  803222:	3c 39                	cmp    $0x39,%al
  803224:	7f 12                	jg     803238 <strtol+0xf0>
			dig = *s - '0';
  803226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322a:	0f b6 00             	movzbl (%rax),%eax
  80322d:	0f be c0             	movsbl %al,%eax
  803230:	83 e8 30             	sub    $0x30,%eax
  803233:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803236:	eb 4e                	jmp    803286 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803238:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323c:	0f b6 00             	movzbl (%rax),%eax
  80323f:	3c 60                	cmp    $0x60,%al
  803241:	7e 1d                	jle    803260 <strtol+0x118>
  803243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803247:	0f b6 00             	movzbl (%rax),%eax
  80324a:	3c 7a                	cmp    $0x7a,%al
  80324c:	7f 12                	jg     803260 <strtol+0x118>
			dig = *s - 'a' + 10;
  80324e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803252:	0f b6 00             	movzbl (%rax),%eax
  803255:	0f be c0             	movsbl %al,%eax
  803258:	83 e8 57             	sub    $0x57,%eax
  80325b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80325e:	eb 26                	jmp    803286 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803260:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803264:	0f b6 00             	movzbl (%rax),%eax
  803267:	3c 40                	cmp    $0x40,%al
  803269:	7e 48                	jle    8032b3 <strtol+0x16b>
  80326b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326f:	0f b6 00             	movzbl (%rax),%eax
  803272:	3c 5a                	cmp    $0x5a,%al
  803274:	7f 3d                	jg     8032b3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  803276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327a:	0f b6 00             	movzbl (%rax),%eax
  80327d:	0f be c0             	movsbl %al,%eax
  803280:	83 e8 37             	sub    $0x37,%eax
  803283:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803286:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803289:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80328c:	7c 02                	jl     803290 <strtol+0x148>
			break;
  80328e:	eb 23                	jmp    8032b3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803290:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803295:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803298:	48 98                	cltq   
  80329a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80329f:	48 89 c2             	mov    %rax,%rdx
  8032a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a5:	48 98                	cltq   
  8032a7:	48 01 d0             	add    %rdx,%rax
  8032aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032ae:	e9 5d ff ff ff       	jmpq   803210 <strtol+0xc8>

	if (endptr)
  8032b3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032b8:	74 0b                	je     8032c5 <strtol+0x17d>
		*endptr = (char *) s;
  8032ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032c2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c9:	74 09                	je     8032d4 <strtol+0x18c>
  8032cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032cf:	48 f7 d8             	neg    %rax
  8032d2:	eb 04                	jmp    8032d8 <strtol+0x190>
  8032d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032d8:	c9                   	leaveq 
  8032d9:	c3                   	retq   

00000000008032da <strstr>:

char * strstr(const char *in, const char *str)
{
  8032da:	55                   	push   %rbp
  8032db:	48 89 e5             	mov    %rsp,%rbp
  8032de:	48 83 ec 30          	sub    $0x30,%rsp
  8032e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8032ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032f2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8032f6:	0f b6 00             	movzbl (%rax),%eax
  8032f9:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8032fc:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803300:	75 06                	jne    803308 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803306:	eb 6b                	jmp    803373 <strstr+0x99>

	len = strlen(str);
  803308:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80330c:	48 89 c7             	mov    %rax,%rdi
  80330f:	48 b8 b0 2b 80 00 00 	movabs $0x802bb0,%rax
  803316:	00 00 00 
  803319:	ff d0                	callq  *%rax
  80331b:	48 98                	cltq   
  80331d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803325:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803329:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80332d:	0f b6 00             	movzbl (%rax),%eax
  803330:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803333:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803337:	75 07                	jne    803340 <strstr+0x66>
				return (char *) 0;
  803339:	b8 00 00 00 00       	mov    $0x0,%eax
  80333e:	eb 33                	jmp    803373 <strstr+0x99>
		} while (sc != c);
  803340:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803344:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803347:	75 d8                	jne    803321 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803349:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80334d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803355:	48 89 ce             	mov    %rcx,%rsi
  803358:	48 89 c7             	mov    %rax,%rdi
  80335b:	48 b8 d1 2d 80 00 00 	movabs $0x802dd1,%rax
  803362:	00 00 00 
  803365:	ff d0                	callq  *%rax
  803367:	85 c0                	test   %eax,%eax
  803369:	75 b6                	jne    803321 <strstr+0x47>

	return (char *) (in - 1);
  80336b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336f:	48 83 e8 01          	sub    $0x1,%rax
}
  803373:	c9                   	leaveq 
  803374:	c3                   	retq   

0000000000803375 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803375:	55                   	push   %rbp
  803376:	48 89 e5             	mov    %rsp,%rbp
  803379:	48 83 ec 30          	sub    $0x30,%rsp
  80337d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803381:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803385:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803389:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80338e:	75 0e                	jne    80339e <ipc_recv+0x29>
        pg = (void *)UTOP;
  803390:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803397:	00 00 00 
  80339a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  80339e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a2:	48 89 c7             	mov    %rax,%rdi
  8033a5:	48 b8 12 05 80 00 00 	movabs $0x800512,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
  8033b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b8:	79 27                	jns    8033e1 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033bf:	74 0a                	je     8033cb <ipc_recv+0x56>
            *from_env_store = 0;
  8033c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033cb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033d0:	74 0a                	je     8033dc <ipc_recv+0x67>
            *perm_store = 0;
  8033d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033df:	eb 53                	jmp    803434 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033e6:	74 19                	je     803401 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033e8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033ef:	00 00 00 
  8033f2:	48 8b 00             	mov    (%rax),%rax
  8033f5:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8033fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ff:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803401:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803406:	74 19                	je     803421 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803408:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80340f:	00 00 00 
  803412:	48 8b 00             	mov    (%rax),%rax
  803415:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80341b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341f:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803421:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803428:	00 00 00 
  80342b:	48 8b 00             	mov    (%rax),%rax
  80342e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803434:	c9                   	leaveq 
  803435:	c3                   	retq   

0000000000803436 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803436:	55                   	push   %rbp
  803437:	48 89 e5             	mov    %rsp,%rbp
  80343a:	48 83 ec 30          	sub    $0x30,%rsp
  80343e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803441:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803444:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803448:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80344b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803450:	75 0e                	jne    803460 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803452:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803459:	00 00 00 
  80345c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803460:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803463:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803466:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80346a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80346d:	89 c7                	mov    %eax,%edi
  80346f:	48 b8 bd 04 80 00 00 	movabs $0x8004bd,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  80347e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803482:	79 36                	jns    8034ba <ipc_send+0x84>
  803484:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803488:	74 30                	je     8034ba <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80348a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348d:	89 c1                	mov    %eax,%ecx
  80348f:	48 ba 88 3c 80 00 00 	movabs $0x803c88,%rdx
  803496:	00 00 00 
  803499:	be 49 00 00 00       	mov    $0x49,%esi
  80349e:	48 bf 95 3c 80 00 00 	movabs $0x803c95,%rdi
  8034a5:	00 00 00 
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ad:	49 b8 1b 1e 80 00 00 	movabs $0x801e1b,%r8
  8034b4:	00 00 00 
  8034b7:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034ba:	48 b8 ab 02 80 00 00 	movabs $0x8002ab,%rax
  8034c1:	00 00 00 
  8034c4:	ff d0                	callq  *%rax
    } while(r != 0);
  8034c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ca:	75 94                	jne    803460 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034cc:	c9                   	leaveq 
  8034cd:	c3                   	retq   

00000000008034ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034ce:	55                   	push   %rbp
  8034cf:	48 89 e5             	mov    %rsp,%rbp
  8034d2:	48 83 ec 14          	sub    $0x14,%rsp
  8034d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034e0:	eb 5e                	jmp    803540 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034e2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034e9:	00 00 00 
  8034ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ef:	48 63 d0             	movslq %eax,%rdx
  8034f2:	48 89 d0             	mov    %rdx,%rax
  8034f5:	48 c1 e0 03          	shl    $0x3,%rax
  8034f9:	48 01 d0             	add    %rdx,%rax
  8034fc:	48 c1 e0 05          	shl    $0x5,%rax
  803500:	48 01 c8             	add    %rcx,%rax
  803503:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803509:	8b 00                	mov    (%rax),%eax
  80350b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80350e:	75 2c                	jne    80353c <ipc_find_env+0x6e>
			return envs[i].env_id;
  803510:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803517:	00 00 00 
  80351a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351d:	48 63 d0             	movslq %eax,%rdx
  803520:	48 89 d0             	mov    %rdx,%rax
  803523:	48 c1 e0 03          	shl    $0x3,%rax
  803527:	48 01 d0             	add    %rdx,%rax
  80352a:	48 c1 e0 05          	shl    $0x5,%rax
  80352e:	48 01 c8             	add    %rcx,%rax
  803531:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803537:	8b 40 08             	mov    0x8(%rax),%eax
  80353a:	eb 12                	jmp    80354e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80353c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803540:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803547:	7e 99                	jle    8034e2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80354e:	c9                   	leaveq 
  80354f:	c3                   	retq   

0000000000803550 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803550:	55                   	push   %rbp
  803551:	48 89 e5             	mov    %rsp,%rbp
  803554:	48 83 ec 18          	sub    $0x18,%rsp
  803558:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80355c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803560:	48 c1 e8 15          	shr    $0x15,%rax
  803564:	48 89 c2             	mov    %rax,%rdx
  803567:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80356e:	01 00 00 
  803571:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803575:	83 e0 01             	and    $0x1,%eax
  803578:	48 85 c0             	test   %rax,%rax
  80357b:	75 07                	jne    803584 <pageref+0x34>
		return 0;
  80357d:	b8 00 00 00 00       	mov    $0x0,%eax
  803582:	eb 53                	jmp    8035d7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803584:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803588:	48 c1 e8 0c          	shr    $0xc,%rax
  80358c:	48 89 c2             	mov    %rax,%rdx
  80358f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803596:	01 00 00 
  803599:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80359d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a5:	83 e0 01             	and    $0x1,%eax
  8035a8:	48 85 c0             	test   %rax,%rax
  8035ab:	75 07                	jne    8035b4 <pageref+0x64>
		return 0;
  8035ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b2:	eb 23                	jmp    8035d7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8035bc:	48 89 c2             	mov    %rax,%rdx
  8035bf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035c6:	00 00 00 
  8035c9:	48 c1 e2 04          	shl    $0x4,%rdx
  8035cd:	48 01 d0             	add    %rdx,%rax
  8035d0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035d4:	0f b7 c0             	movzwl %ax,%eax
}
  8035d7:	c9                   	leaveq 
  8035d8:	c3                   	retq   
