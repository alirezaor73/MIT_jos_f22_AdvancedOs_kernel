
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
  800061:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80007e:	48 b8 7d 02 80 00 00 	movabs $0x80027d,%rax
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
  8000b3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000ba:	00 00 00 
  8000bd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000c4:	7e 14                	jle    8000da <libmain+0x6b>
		binaryname = argv[0];
  8000c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000ca:	48 8b 10             	mov    (%rax),%rdx
  8000cd:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
	close_all();
  800104:	48 b8 a7 08 80 00 00 	movabs $0x8008a7,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800110:	bf 00 00 00 00       	mov    $0x0,%edi
  800115:	48 b8 39 02 80 00 00 	movabs $0x800239,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
}
  800121:	5d                   	pop    %rbp
  800122:	c3                   	retq   

0000000000800123 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800123:	55                   	push   %rbp
  800124:	48 89 e5             	mov    %rsp,%rbp
  800127:	53                   	push   %rbx
  800128:	48 83 ec 48          	sub    $0x48,%rsp
  80012c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80012f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800132:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800136:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80013a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80013e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800142:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800145:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800149:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80014d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800151:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800155:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800159:	4c 89 c3             	mov    %r8,%rbx
  80015c:	cd 30                	int    $0x30
  80015e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800162:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800166:	74 3e                	je     8001a6 <syscall+0x83>
  800168:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80016d:	7e 37                	jle    8001a6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800173:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800176:	49 89 d0             	mov    %rdx,%r8
  800179:	89 c1                	mov    %eax,%ecx
  80017b:	48 ba 0a 36 80 00 00 	movabs $0x80360a,%rdx
  800182:	00 00 00 
  800185:	be 23 00 00 00       	mov    $0x23,%esi
  80018a:	48 bf 27 36 80 00 00 	movabs $0x803627,%rdi
  800191:	00 00 00 
  800194:	b8 00 00 00 00       	mov    $0x0,%eax
  800199:	49 b9 2b 1e 80 00 00 	movabs $0x801e2b,%r9
  8001a0:	00 00 00 
  8001a3:	41 ff d1             	callq  *%r9

	return ret;
  8001a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001aa:	48 83 c4 48          	add    $0x48,%rsp
  8001ae:	5b                   	pop    %rbx
  8001af:	5d                   	pop    %rbp
  8001b0:	c3                   	retq   

00000000008001b1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b1:	55                   	push   %rbp
  8001b2:	48 89 e5             	mov    %rsp,%rbp
  8001b5:	48 83 ec 20          	sub    $0x20,%rsp
  8001b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d0:	00 
  8001d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001dd:	48 89 d1             	mov    %rdx,%rcx
  8001e0:	48 89 c2             	mov    %rax,%rdx
  8001e3:	be 00 00 00 00       	mov    $0x0,%esi
  8001e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ed:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  8001f4:	00 00 00 
  8001f7:	ff d0                	callq  *%rax
}
  8001f9:	c9                   	leaveq 
  8001fa:	c3                   	retq   

00000000008001fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8001fb:	55                   	push   %rbp
  8001fc:	48 89 e5             	mov    %rsp,%rbp
  8001ff:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800203:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80020a:	00 
  80020b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800211:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800217:	b9 00 00 00 00       	mov    $0x0,%ecx
  80021c:	ba 00 00 00 00       	mov    $0x0,%edx
  800221:	be 00 00 00 00       	mov    $0x0,%esi
  800226:	bf 01 00 00 00       	mov    $0x1,%edi
  80022b:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax
}
  800237:	c9                   	leaveq 
  800238:	c3                   	retq   

0000000000800239 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800239:	55                   	push   %rbp
  80023a:	48 89 e5             	mov    %rsp,%rbp
  80023d:	48 83 ec 10          	sub    $0x10,%rsp
  800241:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800244:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800247:	48 98                	cltq   
  800249:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800250:	00 
  800251:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800257:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80025d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800262:	48 89 c2             	mov    %rax,%rdx
  800265:	be 01 00 00 00       	mov    $0x1,%esi
  80026a:	bf 03 00 00 00       	mov    $0x3,%edi
  80026f:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  800276:	00 00 00 
  800279:	ff d0                	callq  *%rax
}
  80027b:	c9                   	leaveq 
  80027c:	c3                   	retq   

000000000080027d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80027d:	55                   	push   %rbp
  80027e:	48 89 e5             	mov    %rsp,%rbp
  800281:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800285:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80028c:	00 
  80028d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800293:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800299:	b9 00 00 00 00       	mov    $0x0,%ecx
  80029e:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a3:	be 00 00 00 00       	mov    $0x0,%esi
  8002a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8002ad:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax
}
  8002b9:	c9                   	leaveq 
  8002ba:	c3                   	retq   

00000000008002bb <sys_yield>:

void
sys_yield(void)
{
  8002bb:	55                   	push   %rbp
  8002bc:	48 89 e5             	mov    %rsp,%rbp
  8002bf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002ca:	00 
  8002cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e1:	be 00 00 00 00       	mov    $0x0,%esi
  8002e6:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002eb:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  8002f2:	00 00 00 
  8002f5:	ff d0                	callq  *%rax
}
  8002f7:	c9                   	leaveq 
  8002f8:	c3                   	retq   

00000000008002f9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f9:	55                   	push   %rbp
  8002fa:	48 89 e5             	mov    %rsp,%rbp
  8002fd:	48 83 ec 20          	sub    $0x20,%rsp
  800301:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800304:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800308:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80030b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030e:	48 63 c8             	movslq %eax,%rcx
  800311:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800318:	48 98                	cltq   
  80031a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800321:	00 
  800322:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800328:	49 89 c8             	mov    %rcx,%r8
  80032b:	48 89 d1             	mov    %rdx,%rcx
  80032e:	48 89 c2             	mov    %rax,%rdx
  800331:	be 01 00 00 00       	mov    $0x1,%esi
  800336:	bf 04 00 00 00       	mov    $0x4,%edi
  80033b:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  800342:	00 00 00 
  800345:	ff d0                	callq  *%rax
}
  800347:	c9                   	leaveq 
  800348:	c3                   	retq   

0000000000800349 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800349:	55                   	push   %rbp
  80034a:	48 89 e5             	mov    %rsp,%rbp
  80034d:	48 83 ec 30          	sub    $0x30,%rsp
  800351:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800354:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800358:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80035b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80035f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800363:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800366:	48 63 c8             	movslq %eax,%rcx
  800369:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80036d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800370:	48 63 f0             	movslq %eax,%rsi
  800373:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037a:	48 98                	cltq   
  80037c:	48 89 0c 24          	mov    %rcx,(%rsp)
  800380:	49 89 f9             	mov    %rdi,%r9
  800383:	49 89 f0             	mov    %rsi,%r8
  800386:	48 89 d1             	mov    %rdx,%rcx
  800389:	48 89 c2             	mov    %rax,%rdx
  80038c:	be 01 00 00 00       	mov    $0x1,%esi
  800391:	bf 05 00 00 00       	mov    $0x5,%edi
  800396:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  80039d:	00 00 00 
  8003a0:	ff d0                	callq  *%rax
}
  8003a2:	c9                   	leaveq 
  8003a3:	c3                   	retq   

00000000008003a4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a4:	55                   	push   %rbp
  8003a5:	48 89 e5             	mov    %rsp,%rbp
  8003a8:	48 83 ec 20          	sub    $0x20,%rsp
  8003ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ba:	48 98                	cltq   
  8003bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c3:	00 
  8003c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d0:	48 89 d1             	mov    %rdx,%rcx
  8003d3:	48 89 c2             	mov    %rax,%rdx
  8003d6:	be 01 00 00 00       	mov    $0x1,%esi
  8003db:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e0:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	callq  *%rax
}
  8003ec:	c9                   	leaveq 
  8003ed:	c3                   	retq   

00000000008003ee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003ee:	55                   	push   %rbp
  8003ef:	48 89 e5             	mov    %rsp,%rbp
  8003f2:	48 83 ec 10          	sub    $0x10,%rsp
  8003f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ff:	48 63 d0             	movslq %eax,%rdx
  800402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800405:	48 98                	cltq   
  800407:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80040e:	00 
  80040f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800415:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041b:	48 89 d1             	mov    %rdx,%rcx
  80041e:	48 89 c2             	mov    %rax,%rdx
  800421:	be 01 00 00 00       	mov    $0x1,%esi
  800426:	bf 08 00 00 00       	mov    $0x8,%edi
  80042b:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
}
  800437:	c9                   	leaveq 
  800438:	c3                   	retq   

0000000000800439 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800439:	55                   	push   %rbp
  80043a:	48 89 e5             	mov    %rsp,%rbp
  80043d:	48 83 ec 20          	sub    $0x20,%rsp
  800441:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800444:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800448:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80044f:	48 98                	cltq   
  800451:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800458:	00 
  800459:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80045f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800465:	48 89 d1             	mov    %rdx,%rcx
  800468:	48 89 c2             	mov    %rax,%rdx
  80046b:	be 01 00 00 00       	mov    $0x1,%esi
  800470:	bf 09 00 00 00       	mov    $0x9,%edi
  800475:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
}
  800481:	c9                   	leaveq 
  800482:	c3                   	retq   

0000000000800483 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800483:	55                   	push   %rbp
  800484:	48 89 e5             	mov    %rsp,%rbp
  800487:	48 83 ec 20          	sub    $0x20,%rsp
  80048b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80048e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800492:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800496:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800499:	48 98                	cltq   
  80049b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a2:	00 
  8004a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004af:	48 89 d1             	mov    %rdx,%rcx
  8004b2:	48 89 c2             	mov    %rax,%rdx
  8004b5:	be 01 00 00 00       	mov    $0x1,%esi
  8004ba:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004bf:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  8004c6:	00 00 00 
  8004c9:	ff d0                	callq  *%rax
}
  8004cb:	c9                   	leaveq 
  8004cc:	c3                   	retq   

00000000008004cd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004cd:	55                   	push   %rbp
  8004ce:	48 89 e5             	mov    %rsp,%rbp
  8004d1:	48 83 ec 20          	sub    $0x20,%rsp
  8004d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004e6:	48 63 f0             	movslq %eax,%rsi
  8004e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f0:	48 98                	cltq   
  8004f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004fd:	00 
  8004fe:	49 89 f1             	mov    %rsi,%r9
  800501:	49 89 c8             	mov    %rcx,%r8
  800504:	48 89 d1             	mov    %rdx,%rcx
  800507:	48 89 c2             	mov    %rax,%rdx
  80050a:	be 00 00 00 00       	mov    $0x0,%esi
  80050f:	bf 0c 00 00 00       	mov    $0xc,%edi
  800514:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 10          	sub    $0x10,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800539:	00 
  80053a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800540:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800546:	b9 00 00 00 00       	mov    $0x0,%ecx
  80054b:	48 89 c2             	mov    %rax,%rdx
  80054e:	be 01 00 00 00       	mov    $0x1,%esi
  800553:	bf 0d 00 00 00       	mov    $0xd,%edi
  800558:	48 b8 23 01 80 00 00 	movabs $0x800123,%rax
  80055f:	00 00 00 
  800562:	ff d0                	callq  *%rax
}
  800564:	c9                   	leaveq 
  800565:	c3                   	retq   

0000000000800566 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800566:	55                   	push   %rbp
  800567:	48 89 e5             	mov    %rsp,%rbp
  80056a:	48 83 ec 08          	sub    $0x8,%rsp
  80056e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800572:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800576:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80057d:	ff ff ff 
  800580:	48 01 d0             	add    %rdx,%rax
  800583:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800587:	c9                   	leaveq 
  800588:	c3                   	retq   

0000000000800589 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800589:	55                   	push   %rbp
  80058a:	48 89 e5             	mov    %rsp,%rbp
  80058d:	48 83 ec 08          	sub    $0x8,%rsp
  800591:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800599:	48 89 c7             	mov    %rax,%rdi
  80059c:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8005a3:	00 00 00 
  8005a6:	ff d0                	callq  *%rax
  8005a8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005ae:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005b2:	c9                   	leaveq 
  8005b3:	c3                   	retq   

00000000008005b4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005b4:	55                   	push   %rbp
  8005b5:	48 89 e5             	mov    %rsp,%rbp
  8005b8:	48 83 ec 18          	sub    $0x18,%rsp
  8005bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005c7:	eb 6b                	jmp    800634 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005cc:	48 98                	cltq   
  8005ce:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005d4:	48 c1 e0 0c          	shl    $0xc,%rax
  8005d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e0:	48 c1 e8 15          	shr    $0x15,%rax
  8005e4:	48 89 c2             	mov    %rax,%rdx
  8005e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005ee:	01 00 00 
  8005f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005f5:	83 e0 01             	and    $0x1,%eax
  8005f8:	48 85 c0             	test   %rax,%rax
  8005fb:	74 21                	je     80061e <fd_alloc+0x6a>
  8005fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800601:	48 c1 e8 0c          	shr    $0xc,%rax
  800605:	48 89 c2             	mov    %rax,%rdx
  800608:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80060f:	01 00 00 
  800612:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800616:	83 e0 01             	and    $0x1,%eax
  800619:	48 85 c0             	test   %rax,%rax
  80061c:	75 12                	jne    800630 <fd_alloc+0x7c>
			*fd_store = fd;
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800626:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800629:	b8 00 00 00 00       	mov    $0x0,%eax
  80062e:	eb 1a                	jmp    80064a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800630:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800634:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800638:	7e 8f                	jle    8005c9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800645:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80064a:	c9                   	leaveq 
  80064b:	c3                   	retq   

000000000080064c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80064c:	55                   	push   %rbp
  80064d:	48 89 e5             	mov    %rsp,%rbp
  800650:	48 83 ec 20          	sub    $0x20,%rsp
  800654:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800657:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80065b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80065f:	78 06                	js     800667 <fd_lookup+0x1b>
  800661:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800665:	7e 07                	jle    80066e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80066c:	eb 6c                	jmp    8006da <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80066e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800671:	48 98                	cltq   
  800673:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800679:	48 c1 e0 0c          	shl    $0xc,%rax
  80067d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800681:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800685:	48 c1 e8 15          	shr    $0x15,%rax
  800689:	48 89 c2             	mov    %rax,%rdx
  80068c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800693:	01 00 00 
  800696:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80069a:	83 e0 01             	and    $0x1,%eax
  80069d:	48 85 c0             	test   %rax,%rax
  8006a0:	74 21                	je     8006c3 <fd_lookup+0x77>
  8006a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8006aa:	48 89 c2             	mov    %rax,%rdx
  8006ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006b4:	01 00 00 
  8006b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006bb:	83 e0 01             	and    $0x1,%eax
  8006be:	48 85 c0             	test   %rax,%rax
  8006c1:	75 07                	jne    8006ca <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c8:	eb 10                	jmp    8006da <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006d2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006da:	c9                   	leaveq 
  8006db:	c3                   	retq   

00000000008006dc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006dc:	55                   	push   %rbp
  8006dd:	48 89 e5             	mov    %rsp,%rbp
  8006e0:	48 83 ec 30          	sub    $0x30,%rsp
  8006e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006e8:	89 f0                	mov    %esi,%eax
  8006ea:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f1:	48 89 c7             	mov    %rax,%rdi
  8006f4:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  8006fb:	00 00 00 
  8006fe:	ff d0                	callq  *%rax
  800700:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800704:	48 89 d6             	mov    %rdx,%rsi
  800707:	89 c7                	mov    %eax,%edi
  800709:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800710:	00 00 00 
  800713:	ff d0                	callq  *%rax
  800715:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800718:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80071c:	78 0a                	js     800728 <fd_close+0x4c>
	    || fd != fd2)
  80071e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800722:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800726:	74 12                	je     80073a <fd_close+0x5e>
		return (must_exist ? r : 0);
  800728:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80072c:	74 05                	je     800733 <fd_close+0x57>
  80072e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800731:	eb 05                	jmp    800738 <fd_close+0x5c>
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	eb 69                	jmp    8007a3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80073a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80073e:	8b 00                	mov    (%rax),%eax
  800740:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800744:	48 89 d6             	mov    %rdx,%rsi
  800747:	89 c7                	mov    %eax,%edi
  800749:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800750:	00 00 00 
  800753:	ff d0                	callq  *%rax
  800755:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80075c:	78 2a                	js     800788 <fd_close+0xac>
		if (dev->dev_close)
  80075e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800762:	48 8b 40 20          	mov    0x20(%rax),%rax
  800766:	48 85 c0             	test   %rax,%rax
  800769:	74 16                	je     800781 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800773:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800777:	48 89 d7             	mov    %rdx,%rdi
  80077a:	ff d0                	callq  *%rax
  80077c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80077f:	eb 07                	jmp    800788 <fd_close+0xac>
		else
			r = 0;
  800781:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80078c:	48 89 c6             	mov    %rax,%rsi
  80078f:	bf 00 00 00 00       	mov    $0x0,%edi
  800794:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  80079b:	00 00 00 
  80079e:	ff d0                	callq  *%rax
	return r;
  8007a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007a3:	c9                   	leaveq 
  8007a4:	c3                   	retq   

00000000008007a5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007a5:	55                   	push   %rbp
  8007a6:	48 89 e5             	mov    %rsp,%rbp
  8007a9:	48 83 ec 20          	sub    $0x20,%rsp
  8007ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007bb:	eb 41                	jmp    8007fe <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007bd:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007c4:	00 00 00 
  8007c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007ca:	48 63 d2             	movslq %edx,%rdx
  8007cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d1:	8b 00                	mov    (%rax),%eax
  8007d3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007d6:	75 22                	jne    8007fa <dev_lookup+0x55>
			*dev = devtab[i];
  8007d8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007df:	00 00 00 
  8007e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007e5:	48 63 d2             	movslq %edx,%rdx
  8007e8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007f0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f8:	eb 60                	jmp    80085a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8007fe:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800805:	00 00 00 
  800808:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80080b:	48 63 d2             	movslq %edx,%rdx
  80080e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800812:	48 85 c0             	test   %rax,%rax
  800815:	75 a6                	jne    8007bd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800817:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80081e:	00 00 00 
  800821:	48 8b 00             	mov    (%rax),%rax
  800824:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80082a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80082d:	89 c6                	mov    %eax,%esi
  80082f:	48 bf 38 36 80 00 00 	movabs $0x803638,%rdi
  800836:	00 00 00 
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
  80083e:	48 b9 64 20 80 00 00 	movabs $0x802064,%rcx
  800845:	00 00 00 
  800848:	ff d1                	callq  *%rcx
	*dev = 0;
  80084a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80084e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80085a:	c9                   	leaveq 
  80085b:	c3                   	retq   

000000000080085c <close>:

int
close(int fdnum)
{
  80085c:	55                   	push   %rbp
  80085d:	48 89 e5             	mov    %rsp,%rbp
  800860:	48 83 ec 20          	sub    $0x20,%rsp
  800864:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800867:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80086b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80086e:	48 89 d6             	mov    %rdx,%rsi
  800871:	89 c7                	mov    %eax,%edi
  800873:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  80087a:	00 00 00 
  80087d:	ff d0                	callq  *%rax
  80087f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800882:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800886:	79 05                	jns    80088d <close+0x31>
		return r;
  800888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80088b:	eb 18                	jmp    8008a5 <close+0x49>
	else
		return fd_close(fd, 1);
  80088d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800891:	be 01 00 00 00       	mov    $0x1,%esi
  800896:	48 89 c7             	mov    %rax,%rdi
  800899:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  8008a0:	00 00 00 
  8008a3:	ff d0                	callq  *%rax
}
  8008a5:	c9                   	leaveq 
  8008a6:	c3                   	retq   

00000000008008a7 <close_all>:

void
close_all(void)
{
  8008a7:	55                   	push   %rbp
  8008a8:	48 89 e5             	mov    %rsp,%rbp
  8008ab:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008b6:	eb 15                	jmp    8008cd <close_all+0x26>
		close(i);
  8008b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008bb:	89 c7                	mov    %eax,%edi
  8008bd:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  8008c4:	00 00 00 
  8008c7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008cd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008d1:	7e e5                	jle    8008b8 <close_all+0x11>
		close(i);
}
  8008d3:	c9                   	leaveq 
  8008d4:	c3                   	retq   

00000000008008d5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008d5:	55                   	push   %rbp
  8008d6:	48 89 e5             	mov    %rsp,%rbp
  8008d9:	48 83 ec 40          	sub    $0x40,%rsp
  8008dd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008e0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008e3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008e7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008ea:	48 89 d6             	mov    %rdx,%rsi
  8008ed:	89 c7                	mov    %eax,%edi
  8008ef:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  8008f6:	00 00 00 
  8008f9:	ff d0                	callq  *%rax
  8008fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800902:	79 08                	jns    80090c <dup+0x37>
		return r;
  800904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800907:	e9 70 01 00 00       	jmpq   800a7c <dup+0x1a7>
	close(newfdnum);
  80090c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80090f:	89 c7                	mov    %eax,%edi
  800911:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  800918:	00 00 00 
  80091b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80091d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800920:	48 98                	cltq   
  800922:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800928:	48 c1 e0 0c          	shl    $0xc,%rax
  80092c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	48 89 c7             	mov    %rax,%rdi
  800937:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  80093e:	00 00 00 
  800941:	ff d0                	callq  *%rax
  800943:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80094b:	48 89 c7             	mov    %rax,%rdi
  80094e:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  800955:	00 00 00 
  800958:	ff d0                	callq  *%rax
  80095a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80095e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800962:	48 c1 e8 15          	shr    $0x15,%rax
  800966:	48 89 c2             	mov    %rax,%rdx
  800969:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800970:	01 00 00 
  800973:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800977:	83 e0 01             	and    $0x1,%eax
  80097a:	48 85 c0             	test   %rax,%rax
  80097d:	74 73                	je     8009f2 <dup+0x11d>
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 c1 e8 0c          	shr    $0xc,%rax
  800987:	48 89 c2             	mov    %rax,%rdx
  80098a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800991:	01 00 00 
  800994:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800998:	83 e0 01             	and    $0x1,%eax
  80099b:	48 85 c0             	test   %rax,%rax
  80099e:	74 52                	je     8009f2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8009a8:	48 89 c2             	mov    %rax,%rdx
  8009ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b2:	01 00 00 
  8009b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8009be:	89 c1                	mov    %eax,%ecx
  8009c0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	41 89 c8             	mov    %ecx,%r8d
  8009cb:	48 89 d1             	mov    %rdx,%rcx
  8009ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d3:	48 89 c6             	mov    %rax,%rsi
  8009d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8009db:	48 b8 49 03 80 00 00 	movabs $0x800349,%rax
  8009e2:	00 00 00 
  8009e5:	ff d0                	callq  *%rax
  8009e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009ee:	79 02                	jns    8009f2 <dup+0x11d>
			goto err;
  8009f0:	eb 57                	jmp    800a49 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8009fa:	48 89 c2             	mov    %rax,%rdx
  8009fd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a04:	01 00 00 
  800a07:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a0b:	25 07 0e 00 00       	and    $0xe07,%eax
  800a10:	89 c1                	mov    %eax,%ecx
  800a12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a1a:	41 89 c8             	mov    %ecx,%r8d
  800a1d:	48 89 d1             	mov    %rdx,%rcx
  800a20:	ba 00 00 00 00       	mov    $0x0,%edx
  800a25:	48 89 c6             	mov    %rax,%rsi
  800a28:	bf 00 00 00 00       	mov    $0x0,%edi
  800a2d:	48 b8 49 03 80 00 00 	movabs $0x800349,%rax
  800a34:	00 00 00 
  800a37:	ff d0                	callq  *%rax
  800a39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a40:	79 02                	jns    800a44 <dup+0x16f>
		goto err;
  800a42:	eb 05                	jmp    800a49 <dup+0x174>

	return newfdnum;
  800a44:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a47:	eb 33                	jmp    800a7c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a4d:	48 89 c6             	mov    %rax,%rsi
  800a50:	bf 00 00 00 00       	mov    $0x0,%edi
  800a55:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  800a5c:	00 00 00 
  800a5f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a65:	48 89 c6             	mov    %rax,%rsi
  800a68:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6d:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  800a74:	00 00 00 
  800a77:	ff d0                	callq  *%rax
	return r;
  800a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a7c:	c9                   	leaveq 
  800a7d:	c3                   	retq   

0000000000800a7e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a7e:	55                   	push   %rbp
  800a7f:	48 89 e5             	mov    %rsp,%rbp
  800a82:	48 83 ec 40          	sub    $0x40,%rsp
  800a86:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a89:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a8d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a91:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a95:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a98:	48 89 d6             	mov    %rdx,%rsi
  800a9b:	89 c7                	mov    %eax,%edi
  800a9d:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800aa4:	00 00 00 
  800aa7:	ff d0                	callq  *%rax
  800aa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800aac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ab0:	78 24                	js     800ad6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab6:	8b 00                	mov    (%rax),%eax
  800ab8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800abc:	48 89 d6             	mov    %rdx,%rsi
  800abf:	89 c7                	mov    %eax,%edi
  800ac1:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800ac8:	00 00 00 
  800acb:	ff d0                	callq  *%rax
  800acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad4:	79 05                	jns    800adb <read+0x5d>
		return r;
  800ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ad9:	eb 76                	jmp    800b51 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	8b 40 08             	mov    0x8(%rax),%eax
  800ae2:	83 e0 03             	and    $0x3,%eax
  800ae5:	83 f8 01             	cmp    $0x1,%eax
  800ae8:	75 3a                	jne    800b24 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aea:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800af1:	00 00 00 
  800af4:	48 8b 00             	mov    (%rax),%rax
  800af7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800afd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b00:	89 c6                	mov    %eax,%esi
  800b02:	48 bf 57 36 80 00 00 	movabs $0x803657,%rdi
  800b09:	00 00 00 
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	48 b9 64 20 80 00 00 	movabs $0x802064,%rcx
  800b18:	00 00 00 
  800b1b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b22:	eb 2d                	jmp    800b51 <read+0xd3>
	}
	if (!dev->dev_read)
  800b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b28:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b2c:	48 85 c0             	test   %rax,%rax
  800b2f:	75 07                	jne    800b38 <read+0xba>
		return -E_NOT_SUPP;
  800b31:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b36:	eb 19                	jmp    800b51 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b3c:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b40:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b44:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b48:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b4c:	48 89 cf             	mov    %rcx,%rdi
  800b4f:	ff d0                	callq  *%rax
}
  800b51:	c9                   	leaveq 
  800b52:	c3                   	retq   

0000000000800b53 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b53:	55                   	push   %rbp
  800b54:	48 89 e5             	mov    %rsp,%rbp
  800b57:	48 83 ec 30          	sub    $0x30,%rsp
  800b5b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b62:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b6d:	eb 49                	jmp    800bb8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b72:	48 98                	cltq   
  800b74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b78:	48 29 c2             	sub    %rax,%rdx
  800b7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b7e:	48 63 c8             	movslq %eax,%rcx
  800b81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b85:	48 01 c1             	add    %rax,%rcx
  800b88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b8b:	48 89 ce             	mov    %rcx,%rsi
  800b8e:	89 c7                	mov    %eax,%edi
  800b90:	48 b8 7e 0a 80 00 00 	movabs $0x800a7e,%rax
  800b97:	00 00 00 
  800b9a:	ff d0                	callq  *%rax
  800b9c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800b9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ba3:	79 05                	jns    800baa <readn+0x57>
			return m;
  800ba5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ba8:	eb 1c                	jmp    800bc6 <readn+0x73>
		if (m == 0)
  800baa:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bae:	75 02                	jne    800bb2 <readn+0x5f>
			break;
  800bb0:	eb 11                	jmp    800bc3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb5:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bbb:	48 98                	cltq   
  800bbd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bc1:	72 ac                	jb     800b6f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bc6:	c9                   	leaveq 
  800bc7:	c3                   	retq   

0000000000800bc8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bc8:	55                   	push   %rbp
  800bc9:	48 89 e5             	mov    %rsp,%rbp
  800bcc:	48 83 ec 40          	sub    $0x40,%rsp
  800bd0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bd3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bd7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bdb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bdf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800be2:	48 89 d6             	mov    %rdx,%rsi
  800be5:	89 c7                	mov    %eax,%edi
  800be7:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800bee:	00 00 00 
  800bf1:	ff d0                	callq  *%rax
  800bf3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bfa:	78 24                	js     800c20 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c00:	8b 00                	mov    (%rax),%eax
  800c02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c06:	48 89 d6             	mov    %rdx,%rsi
  800c09:	89 c7                	mov    %eax,%edi
  800c0b:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800c12:	00 00 00 
  800c15:	ff d0                	callq  *%rax
  800c17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c1e:	79 05                	jns    800c25 <write+0x5d>
		return r;
  800c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c23:	eb 75                	jmp    800c9a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c29:	8b 40 08             	mov    0x8(%rax),%eax
  800c2c:	83 e0 03             	and    $0x3,%eax
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	75 3a                	jne    800c6d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c33:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c3a:	00 00 00 
  800c3d:	48 8b 00             	mov    (%rax),%rax
  800c40:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c46:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c49:	89 c6                	mov    %eax,%esi
  800c4b:	48 bf 73 36 80 00 00 	movabs $0x803673,%rdi
  800c52:	00 00 00 
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5a:	48 b9 64 20 80 00 00 	movabs $0x802064,%rcx
  800c61:	00 00 00 
  800c64:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c6b:	eb 2d                	jmp    800c9a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c71:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c75:	48 85 c0             	test   %rax,%rax
  800c78:	75 07                	jne    800c81 <write+0xb9>
		return -E_NOT_SUPP;
  800c7a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c7f:	eb 19                	jmp    800c9a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c85:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c89:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c8d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c91:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c95:	48 89 cf             	mov    %rcx,%rdi
  800c98:	ff d0                	callq  *%rax
}
  800c9a:	c9                   	leaveq 
  800c9b:	c3                   	retq   

0000000000800c9c <seek>:

int
seek(int fdnum, off_t offset)
{
  800c9c:	55                   	push   %rbp
  800c9d:	48 89 e5             	mov    %rsp,%rbp
  800ca0:	48 83 ec 18          	sub    $0x18,%rsp
  800ca4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800ca7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800caa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cb1:	48 89 d6             	mov    %rdx,%rsi
  800cb4:	89 c7                	mov    %eax,%edi
  800cb6:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800cbd:	00 00 00 
  800cc0:	ff d0                	callq  *%rax
  800cc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc9:	79 05                	jns    800cd0 <seek+0x34>
		return r;
  800ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cce:	eb 0f                	jmp    800cdf <seek+0x43>
	fd->fd_offset = offset;
  800cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cd7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cdf:	c9                   	leaveq 
  800ce0:	c3                   	retq   

0000000000800ce1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800ce1:	55                   	push   %rbp
  800ce2:	48 89 e5             	mov    %rsp,%rbp
  800ce5:	48 83 ec 30          	sub    $0x30,%rsp
  800ce9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cec:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cf3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cf6:	48 89 d6             	mov    %rdx,%rsi
  800cf9:	89 c7                	mov    %eax,%edi
  800cfb:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800d02:	00 00 00 
  800d05:	ff d0                	callq  *%rax
  800d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d0e:	78 24                	js     800d34 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d14:	8b 00                	mov    (%rax),%eax
  800d16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d1a:	48 89 d6             	mov    %rdx,%rsi
  800d1d:	89 c7                	mov    %eax,%edi
  800d1f:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800d26:	00 00 00 
  800d29:	ff d0                	callq  *%rax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d32:	79 05                	jns    800d39 <ftruncate+0x58>
		return r;
  800d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d37:	eb 72                	jmp    800dab <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3d:	8b 40 08             	mov    0x8(%rax),%eax
  800d40:	83 e0 03             	and    $0x3,%eax
  800d43:	85 c0                	test   %eax,%eax
  800d45:	75 3a                	jne    800d81 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d47:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d4e:	00 00 00 
  800d51:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d5a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d5d:	89 c6                	mov    %eax,%esi
  800d5f:	48 bf 90 36 80 00 00 	movabs $0x803690,%rdi
  800d66:	00 00 00 
  800d69:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6e:	48 b9 64 20 80 00 00 	movabs $0x802064,%rcx
  800d75:	00 00 00 
  800d78:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d7f:	eb 2a                	jmp    800dab <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d85:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d89:	48 85 c0             	test   %rax,%rax
  800d8c:	75 07                	jne    800d95 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d93:	eb 16                	jmp    800dab <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d99:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800da4:	89 ce                	mov    %ecx,%esi
  800da6:	48 89 d7             	mov    %rdx,%rdi
  800da9:	ff d0                	callq  *%rax
}
  800dab:	c9                   	leaveq 
  800dac:	c3                   	retq   

0000000000800dad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800dad:	55                   	push   %rbp
  800dae:	48 89 e5             	mov    %rsp,%rbp
  800db1:	48 83 ec 30          	sub    $0x30,%rsp
  800db5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800db8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dbc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dc3:	48 89 d6             	mov    %rdx,%rsi
  800dc6:	89 c7                	mov    %eax,%edi
  800dc8:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800dcf:	00 00 00 
  800dd2:	ff d0                	callq  *%rax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ddb:	78 24                	js     800e01 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ddd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de1:	8b 00                	mov    (%rax),%eax
  800de3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800de7:	48 89 d6             	mov    %rdx,%rsi
  800dea:	89 c7                	mov    %eax,%edi
  800dec:	48 b8 a5 07 80 00 00 	movabs $0x8007a5,%rax
  800df3:	00 00 00 
  800df6:	ff d0                	callq  *%rax
  800df8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dff:	79 05                	jns    800e06 <fstat+0x59>
		return r;
  800e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e04:	eb 5e                	jmp    800e64 <fstat+0xb7>
	if (!dev->dev_stat)
  800e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0a:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e0e:	48 85 c0             	test   %rax,%rax
  800e11:	75 07                	jne    800e1a <fstat+0x6d>
		return -E_NOT_SUPP;
  800e13:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e18:	eb 4a                	jmp    800e64 <fstat+0xb7>
	stat->st_name[0] = 0;
  800e1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e1e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e25:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e2c:	00 00 00 
	stat->st_isdir = 0;
  800e2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e33:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e3a:	00 00 00 
	stat->st_dev = dev;
  800e3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e45:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e50:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e58:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e5c:	48 89 ce             	mov    %rcx,%rsi
  800e5f:	48 89 d7             	mov    %rdx,%rdi
  800e62:	ff d0                	callq  *%rax
}
  800e64:	c9                   	leaveq 
  800e65:	c3                   	retq   

0000000000800e66 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e66:	55                   	push   %rbp
  800e67:	48 89 e5             	mov    %rsp,%rbp
  800e6a:	48 83 ec 20          	sub    $0x20,%rsp
  800e6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7a:	be 00 00 00 00       	mov    $0x0,%esi
  800e7f:	48 89 c7             	mov    %rax,%rdi
  800e82:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  800e89:	00 00 00 
  800e8c:	ff d0                	callq  *%rax
  800e8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e95:	79 05                	jns    800e9c <stat+0x36>
		return fd;
  800e97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e9a:	eb 2f                	jmp    800ecb <stat+0x65>
	r = fstat(fd, stat);
  800e9c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea3:	48 89 d6             	mov    %rdx,%rsi
  800ea6:	89 c7                	mov    %eax,%edi
  800ea8:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  800eaf:	00 00 00 
  800eb2:	ff d0                	callq  *%rax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eba:	89 c7                	mov    %eax,%edi
  800ebc:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  800ec3:	00 00 00 
  800ec6:	ff d0                	callq  *%rax
	return r;
  800ec8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ecb:	c9                   	leaveq 
  800ecc:	c3                   	retq   

0000000000800ecd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ecd:	55                   	push   %rbp
  800ece:	48 89 e5             	mov    %rsp,%rbp
  800ed1:	48 83 ec 10          	sub    $0x10,%rsp
  800ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800edc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ee3:	00 00 00 
  800ee6:	8b 00                	mov    (%rax),%eax
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	75 1d                	jne    800f09 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800eec:	bf 01 00 00 00       	mov    $0x1,%edi
  800ef1:	48 b8 de 34 80 00 00 	movabs $0x8034de,%rax
  800ef8:	00 00 00 
  800efb:	ff d0                	callq  *%rax
  800efd:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f04:	00 00 00 
  800f07:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f09:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f10:	00 00 00 
  800f13:	8b 00                	mov    (%rax),%eax
  800f15:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f18:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f1d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f24:	00 00 00 
  800f27:	89 c7                	mov    %eax,%edi
  800f29:	48 b8 46 34 80 00 00 	movabs $0x803446,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f39:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3e:	48 89 c6             	mov    %rax,%rsi
  800f41:	bf 00 00 00 00       	mov    $0x0,%edi
  800f46:	48 b8 85 33 80 00 00 	movabs $0x803385,%rax
  800f4d:	00 00 00 
  800f50:	ff d0                	callq  *%rax
}
  800f52:	c9                   	leaveq 
  800f53:	c3                   	retq   

0000000000800f54 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f54:	55                   	push   %rbp
  800f55:	48 89 e5             	mov    %rsp,%rbp
  800f58:	48 83 ec 20          	sub    $0x20,%rsp
  800f5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f60:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f67:	48 89 c7             	mov    %rax,%rdi
  800f6a:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  800f71:	00 00 00 
  800f74:	ff d0                	callq  *%rax
  800f76:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f7b:	7e 0a                	jle    800f87 <open+0x33>
		return -E_BAD_PATH;
  800f7d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f82:	e9 a5 00 00 00       	jmpq   80102c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f87:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f8b:	48 89 c7             	mov    %rax,%rdi
  800f8e:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  800f95:	00 00 00 
  800f98:	ff d0                	callq  *%rax
  800f9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa1:	79 08                	jns    800fab <open+0x57>
		return r;
  800fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa6:	e9 81 00 00 00       	jmpq   80102c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faf:	48 89 c6             	mov    %rax,%rsi
  800fb2:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fb9:	00 00 00 
  800fbc:	48 b8 2c 2c 80 00 00 	movabs $0x802c2c,%rax
  800fc3:	00 00 00 
  800fc6:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fc8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fcf:	00 00 00 
  800fd2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fd5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdf:	48 89 c6             	mov    %rax,%rsi
  800fe2:	bf 01 00 00 00       	mov    $0x1,%edi
  800fe7:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  800fee:	00 00 00 
  800ff1:	ff d0                	callq  *%rax
  800ff3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ff6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ffa:	79 1d                	jns    801019 <open+0xc5>
		fd_close(fd, 0);
  800ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801000:	be 00 00 00 00       	mov    $0x0,%esi
  801005:	48 89 c7             	mov    %rax,%rdi
  801008:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  80100f:	00 00 00 
  801012:	ff d0                	callq  *%rax
		return r;
  801014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801017:	eb 13                	jmp    80102c <open+0xd8>
	}

	return fd2num(fd);
  801019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101d:	48 89 c7             	mov    %rax,%rdi
  801020:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  801027:	00 00 00 
  80102a:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  80102c:	c9                   	leaveq 
  80102d:	c3                   	retq   

000000000080102e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80102e:	55                   	push   %rbp
  80102f:	48 89 e5             	mov    %rsp,%rbp
  801032:	48 83 ec 10          	sub    $0x10,%rsp
  801036:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80103a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103e:	8b 50 0c             	mov    0xc(%rax),%edx
  801041:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801048:	00 00 00 
  80104b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80104d:	be 00 00 00 00       	mov    $0x0,%esi
  801052:	bf 06 00 00 00       	mov    $0x6,%edi
  801057:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  80105e:	00 00 00 
  801061:	ff d0                	callq  *%rax
}
  801063:	c9                   	leaveq 
  801064:	c3                   	retq   

0000000000801065 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801065:	55                   	push   %rbp
  801066:	48 89 e5             	mov    %rsp,%rbp
  801069:	48 83 ec 30          	sub    $0x30,%rsp
  80106d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801071:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801075:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107d:	8b 50 0c             	mov    0xc(%rax),%edx
  801080:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801087:	00 00 00 
  80108a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80108c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801093:	00 00 00 
  801096:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80109a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80109e:	be 00 00 00 00       	mov    $0x0,%esi
  8010a3:	bf 03 00 00 00       	mov    $0x3,%edi
  8010a8:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  8010af:	00 00 00 
  8010b2:	ff d0                	callq  *%rax
  8010b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010bb:	79 08                	jns    8010c5 <devfile_read+0x60>
		return r;
  8010bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c0:	e9 a4 00 00 00       	jmpq   801169 <devfile_read+0x104>
	assert(r <= n);
  8010c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c8:	48 98                	cltq   
  8010ca:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010ce:	76 35                	jbe    801105 <devfile_read+0xa0>
  8010d0:	48 b9 bd 36 80 00 00 	movabs $0x8036bd,%rcx
  8010d7:	00 00 00 
  8010da:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  8010e1:	00 00 00 
  8010e4:	be 84 00 00 00       	mov    $0x84,%esi
  8010e9:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  8010f0:	00 00 00 
  8010f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f8:	49 b8 2b 1e 80 00 00 	movabs $0x801e2b,%r8
  8010ff:	00 00 00 
  801102:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  801105:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80110c:	7e 35                	jle    801143 <devfile_read+0xde>
  80110e:	48 b9 e4 36 80 00 00 	movabs $0x8036e4,%rcx
  801115:	00 00 00 
  801118:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  80111f:	00 00 00 
  801122:	be 85 00 00 00       	mov    $0x85,%esi
  801127:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  80112e:	00 00 00 
  801131:	b8 00 00 00 00       	mov    $0x0,%eax
  801136:	49 b8 2b 1e 80 00 00 	movabs $0x801e2b,%r8
  80113d:	00 00 00 
  801140:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801143:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801146:	48 63 d0             	movslq %eax,%rdx
  801149:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80114d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801154:	00 00 00 
  801157:	48 89 c7             	mov    %rax,%rdi
  80115a:	48 b8 50 2f 80 00 00 	movabs $0x802f50,%rax
  801161:	00 00 00 
  801164:	ff d0                	callq  *%rax
	return r;
  801166:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  801169:	c9                   	leaveq 
  80116a:	c3                   	retq   

000000000080116b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80116b:	55                   	push   %rbp
  80116c:	48 89 e5             	mov    %rsp,%rbp
  80116f:	48 83 ec 30          	sub    $0x30,%rsp
  801173:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801177:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80117f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801183:	8b 50 0c             	mov    0xc(%rax),%edx
  801186:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80118d:	00 00 00 
  801190:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801192:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801199:	00 00 00 
  80119c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011a0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8011a4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011ab:	00 
  8011ac:	76 35                	jbe    8011e3 <devfile_write+0x78>
  8011ae:	48 b9 f0 36 80 00 00 	movabs $0x8036f0,%rcx
  8011b5:	00 00 00 
  8011b8:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  8011bf:	00 00 00 
  8011c2:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011c7:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  8011ce:	00 00 00 
  8011d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d6:	49 b8 2b 1e 80 00 00 	movabs $0x801e2b,%r8
  8011dd:	00 00 00 
  8011e0:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011eb:	48 89 c6             	mov    %rax,%rsi
  8011ee:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011f5:	00 00 00 
  8011f8:	48 b8 67 30 80 00 00 	movabs $0x803067,%rax
  8011ff:	00 00 00 
  801202:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801204:	be 00 00 00 00       	mov    $0x0,%esi
  801209:	bf 04 00 00 00       	mov    $0x4,%edi
  80120e:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  801215:	00 00 00 
  801218:	ff d0                	callq  *%rax
  80121a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80121d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801221:	79 05                	jns    801228 <devfile_write+0xbd>
		return r;
  801223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801226:	eb 43                	jmp    80126b <devfile_write+0x100>
	assert(r <= n);
  801228:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80122b:	48 98                	cltq   
  80122d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801231:	76 35                	jbe    801268 <devfile_write+0xfd>
  801233:	48 b9 bd 36 80 00 00 	movabs $0x8036bd,%rcx
  80123a:	00 00 00 
  80123d:	48 ba c4 36 80 00 00 	movabs $0x8036c4,%rdx
  801244:	00 00 00 
  801247:	be a2 00 00 00       	mov    $0xa2,%esi
  80124c:	48 bf d9 36 80 00 00 	movabs $0x8036d9,%rdi
  801253:	00 00 00 
  801256:	b8 00 00 00 00       	mov    $0x0,%eax
  80125b:	49 b8 2b 1e 80 00 00 	movabs $0x801e2b,%r8
  801262:	00 00 00 
  801265:	41 ff d0             	callq  *%r8
	return r;
  801268:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80126b:	c9                   	leaveq 
  80126c:	c3                   	retq   

000000000080126d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80126d:	55                   	push   %rbp
  80126e:	48 89 e5             	mov    %rsp,%rbp
  801271:	48 83 ec 20          	sub    $0x20,%rsp
  801275:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801279:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80127d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801281:	8b 50 0c             	mov    0xc(%rax),%edx
  801284:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80128b:	00 00 00 
  80128e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801290:	be 00 00 00 00       	mov    $0x0,%esi
  801295:	bf 05 00 00 00       	mov    $0x5,%edi
  80129a:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  8012a1:	00 00 00 
  8012a4:	ff d0                	callq  *%rax
  8012a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012ad:	79 05                	jns    8012b4 <devfile_stat+0x47>
		return r;
  8012af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012b2:	eb 56                	jmp    80130a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b8:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012bf:	00 00 00 
  8012c2:	48 89 c7             	mov    %rax,%rdi
  8012c5:	48 b8 2c 2c 80 00 00 	movabs $0x802c2c,%rax
  8012cc:	00 00 00 
  8012cf:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012d1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012d8:	00 00 00 
  8012db:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012eb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012f2:	00 00 00 
  8012f5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ff:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	48 83 ec 10          	sub    $0x10,%rsp
  801314:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801318:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131f:	8b 50 0c             	mov    0xc(%rax),%edx
  801322:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801329:	00 00 00 
  80132c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80132e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801335:	00 00 00 
  801338:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80133b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80133e:	be 00 00 00 00       	mov    $0x0,%esi
  801343:	bf 02 00 00 00       	mov    $0x2,%edi
  801348:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  80134f:	00 00 00 
  801352:	ff d0                	callq  *%rax
}
  801354:	c9                   	leaveq 
  801355:	c3                   	retq   

0000000000801356 <remove>:

// Delete a file
int
remove(const char *path)
{
  801356:	55                   	push   %rbp
  801357:	48 89 e5             	mov    %rsp,%rbp
  80135a:	48 83 ec 10          	sub    $0x10,%rsp
  80135e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	48 89 c7             	mov    %rax,%rdi
  801369:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  801370:	00 00 00 
  801373:	ff d0                	callq  *%rax
  801375:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80137a:	7e 07                	jle    801383 <remove+0x2d>
		return -E_BAD_PATH;
  80137c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801381:	eb 33                	jmp    8013b6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801387:	48 89 c6             	mov    %rax,%rsi
  80138a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801391:	00 00 00 
  801394:	48 b8 2c 2c 80 00 00 	movabs $0x802c2c,%rax
  80139b:	00 00 00 
  80139e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8013a0:	be 00 00 00 00       	mov    $0x0,%esi
  8013a5:	bf 07 00 00 00       	mov    $0x7,%edi
  8013aa:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  8013b1:	00 00 00 
  8013b4:	ff d0                	callq  *%rax
}
  8013b6:	c9                   	leaveq 
  8013b7:	c3                   	retq   

00000000008013b8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013b8:	55                   	push   %rbp
  8013b9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013bc:	be 00 00 00 00       	mov    $0x0,%esi
  8013c1:	bf 08 00 00 00       	mov    $0x8,%edi
  8013c6:	48 b8 cd 0e 80 00 00 	movabs $0x800ecd,%rax
  8013cd:	00 00 00 
  8013d0:	ff d0                	callq  *%rax
}
  8013d2:	5d                   	pop    %rbp
  8013d3:	c3                   	retq   

00000000008013d4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013d4:	55                   	push   %rbp
  8013d5:	48 89 e5             	mov    %rsp,%rbp
  8013d8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013df:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013e6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013ed:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013f4:	be 00 00 00 00       	mov    $0x0,%esi
  8013f9:	48 89 c7             	mov    %rax,%rdi
  8013fc:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  801403:	00 00 00 
  801406:	ff d0                	callq  *%rax
  801408:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80140b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80140f:	79 28                	jns    801439 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801414:	89 c6                	mov    %eax,%esi
  801416:	48 bf 1d 37 80 00 00 	movabs $0x80371d,%rdi
  80141d:	00 00 00 
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
  801425:	48 ba 64 20 80 00 00 	movabs $0x802064,%rdx
  80142c:	00 00 00 
  80142f:	ff d2                	callq  *%rdx
		return fd_src;
  801431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801434:	e9 74 01 00 00       	jmpq   8015ad <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801439:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801440:	be 01 01 00 00       	mov    $0x101,%esi
  801445:	48 89 c7             	mov    %rax,%rdi
  801448:	48 b8 54 0f 80 00 00 	movabs $0x800f54,%rax
  80144f:	00 00 00 
  801452:	ff d0                	callq  *%rax
  801454:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801457:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80145b:	79 39                	jns    801496 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80145d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801460:	89 c6                	mov    %eax,%esi
  801462:	48 bf 33 37 80 00 00 	movabs $0x803733,%rdi
  801469:	00 00 00 
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
  801471:	48 ba 64 20 80 00 00 	movabs $0x802064,%rdx
  801478:	00 00 00 
  80147b:	ff d2                	callq  *%rdx
		close(fd_src);
  80147d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801480:	89 c7                	mov    %eax,%edi
  801482:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  801489:	00 00 00 
  80148c:	ff d0                	callq  *%rax
		return fd_dest;
  80148e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801491:	e9 17 01 00 00       	jmpq   8015ad <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801496:	eb 74                	jmp    80150c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801498:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80149b:	48 63 d0             	movslq %eax,%rdx
  80149e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014a8:	48 89 ce             	mov    %rcx,%rsi
  8014ab:	89 c7                	mov    %eax,%edi
  8014ad:	48 b8 c8 0b 80 00 00 	movabs $0x800bc8,%rax
  8014b4:	00 00 00 
  8014b7:	ff d0                	callq  *%rax
  8014b9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014c0:	79 4a                	jns    80150c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014c2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014c5:	89 c6                	mov    %eax,%esi
  8014c7:	48 bf 4d 37 80 00 00 	movabs $0x80374d,%rdi
  8014ce:	00 00 00 
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d6:	48 ba 64 20 80 00 00 	movabs $0x802064,%rdx
  8014dd:	00 00 00 
  8014e0:	ff d2                	callq  *%rdx
			close(fd_src);
  8014e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014e5:	89 c7                	mov    %eax,%edi
  8014e7:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  8014ee:	00 00 00 
  8014f1:	ff d0                	callq  *%rax
			close(fd_dest);
  8014f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014f6:	89 c7                	mov    %eax,%edi
  8014f8:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  8014ff:	00 00 00 
  801502:	ff d0                	callq  *%rax
			return write_size;
  801504:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801507:	e9 a1 00 00 00       	jmpq   8015ad <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80150c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801513:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801516:	ba 00 02 00 00       	mov    $0x200,%edx
  80151b:	48 89 ce             	mov    %rcx,%rsi
  80151e:	89 c7                	mov    %eax,%edi
  801520:	48 b8 7e 0a 80 00 00 	movabs $0x800a7e,%rax
  801527:	00 00 00 
  80152a:	ff d0                	callq  *%rax
  80152c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80152f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801533:	0f 8f 5f ff ff ff    	jg     801498 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  801539:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80153d:	79 47                	jns    801586 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80153f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801542:	89 c6                	mov    %eax,%esi
  801544:	48 bf 60 37 80 00 00 	movabs $0x803760,%rdi
  80154b:	00 00 00 
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	48 ba 64 20 80 00 00 	movabs $0x802064,%rdx
  80155a:	00 00 00 
  80155d:	ff d2                	callq  *%rdx
		close(fd_src);
  80155f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801562:	89 c7                	mov    %eax,%edi
  801564:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  80156b:	00 00 00 
  80156e:	ff d0                	callq  *%rax
		close(fd_dest);
  801570:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801573:	89 c7                	mov    %eax,%edi
  801575:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  80157c:	00 00 00 
  80157f:	ff d0                	callq  *%rax
		return read_size;
  801581:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801584:	eb 27                	jmp    8015ad <copy+0x1d9>
	}
	close(fd_src);
  801586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801589:	89 c7                	mov    %eax,%edi
  80158b:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  801592:	00 00 00 
  801595:	ff d0                	callq  *%rax
	close(fd_dest);
  801597:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80159a:	89 c7                	mov    %eax,%edi
  80159c:	48 b8 5c 08 80 00 00 	movabs $0x80085c,%rax
  8015a3:	00 00 00 
  8015a6:	ff d0                	callq  *%rax
	return 0;
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	53                   	push   %rbx
  8015b4:	48 83 ec 38          	sub    $0x38,%rsp
  8015b8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015bc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015c0:	48 89 c7             	mov    %rax,%rdi
  8015c3:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  8015ca:	00 00 00 
  8015cd:	ff d0                	callq  *%rax
  8015cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015d6:	0f 88 bf 01 00 00    	js     80179b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e0:	ba 07 04 00 00       	mov    $0x407,%edx
  8015e5:	48 89 c6             	mov    %rax,%rsi
  8015e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8015ed:	48 b8 f9 02 80 00 00 	movabs $0x8002f9,%rax
  8015f4:	00 00 00 
  8015f7:	ff d0                	callq  *%rax
  8015f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801600:	0f 88 95 01 00 00    	js     80179b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801606:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80160a:	48 89 c7             	mov    %rax,%rdi
  80160d:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  801614:	00 00 00 
  801617:	ff d0                	callq  *%rax
  801619:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80161c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801620:	0f 88 5d 01 00 00    	js     801783 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801626:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80162a:	ba 07 04 00 00       	mov    $0x407,%edx
  80162f:	48 89 c6             	mov    %rax,%rsi
  801632:	bf 00 00 00 00       	mov    $0x0,%edi
  801637:	48 b8 f9 02 80 00 00 	movabs $0x8002f9,%rax
  80163e:	00 00 00 
  801641:	ff d0                	callq  *%rax
  801643:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801646:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80164a:	0f 88 33 01 00 00    	js     801783 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	48 89 c7             	mov    %rax,%rdi
  801657:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  80165e:	00 00 00 
  801661:	ff d0                	callq  *%rax
  801663:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80166b:	ba 07 04 00 00       	mov    $0x407,%edx
  801670:	48 89 c6             	mov    %rax,%rsi
  801673:	bf 00 00 00 00       	mov    $0x0,%edi
  801678:	48 b8 f9 02 80 00 00 	movabs $0x8002f9,%rax
  80167f:	00 00 00 
  801682:	ff d0                	callq  *%rax
  801684:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801687:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80168b:	79 05                	jns    801692 <pipe+0xe3>
		goto err2;
  80168d:	e9 d9 00 00 00       	jmpq   80176b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801692:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801696:	48 89 c7             	mov    %rax,%rdi
  801699:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  8016a0:	00 00 00 
  8016a3:	ff d0                	callq  *%rax
  8016a5:	48 89 c2             	mov    %rax,%rdx
  8016a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016ac:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016b2:	48 89 d1             	mov    %rdx,%rcx
  8016b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ba:	48 89 c6             	mov    %rax,%rsi
  8016bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8016c2:	48 b8 49 03 80 00 00 	movabs $0x800349,%rax
  8016c9:	00 00 00 
  8016cc:	ff d0                	callq  *%rax
  8016ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016d5:	79 1b                	jns    8016f2 <pipe+0x143>
		goto err3;
  8016d7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016dc:	48 89 c6             	mov    %rax,%rsi
  8016df:	bf 00 00 00 00       	mov    $0x0,%edi
  8016e4:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  8016eb:	00 00 00 
  8016ee:	ff d0                	callq  *%rax
  8016f0:	eb 79                	jmp    80176b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016fd:	00 00 00 
  801700:	8b 12                	mov    (%rdx),%edx
  801702:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801708:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80170f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801713:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80171a:	00 00 00 
  80171d:	8b 12                	mov    (%rdx),%edx
  80171f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801721:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801725:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	48 89 c7             	mov    %rax,%rdi
  801733:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  80173a:	00 00 00 
  80173d:	ff d0                	callq  *%rax
  80173f:	89 c2                	mov    %eax,%edx
  801741:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801745:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801747:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80174b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80174f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801753:	48 89 c7             	mov    %rax,%rdi
  801756:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  80175d:	00 00 00 
  801760:	ff d0                	callq  *%rax
  801762:	89 03                	mov    %eax,(%rbx)
	return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
  801769:	eb 33                	jmp    80179e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80176b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176f:	48 89 c6             	mov    %rax,%rsi
  801772:	bf 00 00 00 00       	mov    $0x0,%edi
  801777:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  80177e:	00 00 00 
  801781:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	48 89 c6             	mov    %rax,%rsi
  80178a:	bf 00 00 00 00       	mov    $0x0,%edi
  80178f:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  801796:	00 00 00 
  801799:	ff d0                	callq  *%rax
err:
	return r;
  80179b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80179e:	48 83 c4 38          	add    $0x38,%rsp
  8017a2:	5b                   	pop    %rbx
  8017a3:	5d                   	pop    %rbp
  8017a4:	c3                   	retq   

00000000008017a5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017a5:	55                   	push   %rbp
  8017a6:	48 89 e5             	mov    %rsp,%rbp
  8017a9:	53                   	push   %rbx
  8017aa:	48 83 ec 28          	sub    $0x28,%rsp
  8017ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017b6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017bd:	00 00 00 
  8017c0:	48 8b 00             	mov    (%rax),%rax
  8017c3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d0:	48 89 c7             	mov    %rax,%rdi
  8017d3:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  8017da:	00 00 00 
  8017dd:	ff d0                	callq  *%rax
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e5:	48 89 c7             	mov    %rax,%rdi
  8017e8:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  8017ef:	00 00 00 
  8017f2:	ff d0                	callq  *%rax
  8017f4:	39 c3                	cmp    %eax,%ebx
  8017f6:	0f 94 c0             	sete   %al
  8017f9:	0f b6 c0             	movzbl %al,%eax
  8017fc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8017ff:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801806:	00 00 00 
  801809:	48 8b 00             	mov    (%rax),%rax
  80180c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801812:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801815:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801818:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80181b:	75 05                	jne    801822 <_pipeisclosed+0x7d>
			return ret;
  80181d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801820:	eb 4f                	jmp    801871 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801822:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801825:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801828:	74 42                	je     80186c <_pipeisclosed+0xc7>
  80182a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80182e:	75 3c                	jne    80186c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801830:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801837:	00 00 00 
  80183a:	48 8b 00             	mov    (%rax),%rax
  80183d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801843:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801846:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801849:	89 c6                	mov    %eax,%esi
  80184b:	48 bf 7b 37 80 00 00 	movabs $0x80377b,%rdi
  801852:	00 00 00 
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
  80185a:	49 b8 64 20 80 00 00 	movabs $0x802064,%r8
  801861:	00 00 00 
  801864:	41 ff d0             	callq  *%r8
	}
  801867:	e9 4a ff ff ff       	jmpq   8017b6 <_pipeisclosed+0x11>
  80186c:	e9 45 ff ff ff       	jmpq   8017b6 <_pipeisclosed+0x11>
}
  801871:	48 83 c4 28          	add    $0x28,%rsp
  801875:	5b                   	pop    %rbx
  801876:	5d                   	pop    %rbp
  801877:	c3                   	retq   

0000000000801878 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801878:	55                   	push   %rbp
  801879:	48 89 e5             	mov    %rsp,%rbp
  80187c:	48 83 ec 30          	sub    $0x30,%rsp
  801880:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801883:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801887:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80188a:	48 89 d6             	mov    %rdx,%rsi
  80188d:	89 c7                	mov    %eax,%edi
  80188f:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  801896:	00 00 00 
  801899:	ff d0                	callq  *%rax
  80189b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80189e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a2:	79 05                	jns    8018a9 <pipeisclosed+0x31>
		return r;
  8018a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a7:	eb 31                	jmp    8018da <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8018a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ad:	48 89 c7             	mov    %rax,%rdi
  8018b0:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  8018b7:	00 00 00 
  8018ba:	ff d0                	callq  *%rax
  8018bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c8:	48 89 d6             	mov    %rdx,%rsi
  8018cb:	48 89 c7             	mov    %rax,%rdi
  8018ce:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  8018d5:	00 00 00 
  8018d8:	ff d0                	callq  *%rax
}
  8018da:	c9                   	leaveq 
  8018db:	c3                   	retq   

00000000008018dc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018dc:	55                   	push   %rbp
  8018dd:	48 89 e5             	mov    %rsp,%rbp
  8018e0:	48 83 ec 40          	sub    $0x40,%rsp
  8018e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f4:	48 89 c7             	mov    %rax,%rdi
  8018f7:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  8018fe:	00 00 00 
  801901:	ff d0                	callq  *%rax
  801903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801907:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80190b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80190f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801916:	00 
  801917:	e9 92 00 00 00       	jmpq   8019ae <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80191c:	eb 41                	jmp    80195f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80191e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801923:	74 09                	je     80192e <devpipe_read+0x52>
				return i;
  801925:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801929:	e9 92 00 00 00       	jmpq   8019c0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80192e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801932:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801936:	48 89 d6             	mov    %rdx,%rsi
  801939:	48 89 c7             	mov    %rax,%rdi
  80193c:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
  801948:	85 c0                	test   %eax,%eax
  80194a:	74 07                	je     801953 <devpipe_read+0x77>
				return 0;
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
  801951:	eb 6d                	jmp    8019c0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801953:	48 b8 bb 02 80 00 00 	movabs $0x8002bb,%rax
  80195a:	00 00 00 
  80195d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80195f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801963:	8b 10                	mov    (%rax),%edx
  801965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801969:	8b 40 04             	mov    0x4(%rax),%eax
  80196c:	39 c2                	cmp    %eax,%edx
  80196e:	74 ae                	je     80191e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801970:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801978:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80197c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801980:	8b 00                	mov    (%rax),%eax
  801982:	99                   	cltd   
  801983:	c1 ea 1b             	shr    $0x1b,%edx
  801986:	01 d0                	add    %edx,%eax
  801988:	83 e0 1f             	and    $0x1f,%eax
  80198b:	29 d0                	sub    %edx,%eax
  80198d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801991:	48 98                	cltq   
  801993:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801998:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80199a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80199e:	8b 00                	mov    (%rax),%eax
  8019a0:	8d 50 01             	lea    0x1(%rax),%edx
  8019a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019b6:	0f 82 60 ff ff ff    	jb     80191c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019c0:	c9                   	leaveq 
  8019c1:	c3                   	retq   

00000000008019c2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019c2:	55                   	push   %rbp
  8019c3:	48 89 e5             	mov    %rsp,%rbp
  8019c6:	48 83 ec 40          	sub    $0x40,%rsp
  8019ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019da:	48 89 c7             	mov    %rax,%rdi
  8019dd:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
  8019e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019fc:	00 
  8019fd:	e9 8e 00 00 00       	jmpq   801a90 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a02:	eb 31                	jmp    801a35 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0c:	48 89 d6             	mov    %rdx,%rsi
  801a0f:	48 89 c7             	mov    %rax,%rdi
  801a12:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	74 07                	je     801a29 <devpipe_write+0x67>
				return 0;
  801a22:	b8 00 00 00 00       	mov    $0x0,%eax
  801a27:	eb 79                	jmp    801aa2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a29:	48 b8 bb 02 80 00 00 	movabs $0x8002bb,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a39:	8b 40 04             	mov    0x4(%rax),%eax
  801a3c:	48 63 d0             	movslq %eax,%rdx
  801a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a43:	8b 00                	mov    (%rax),%eax
  801a45:	48 98                	cltq   
  801a47:	48 83 c0 20          	add    $0x20,%rax
  801a4b:	48 39 c2             	cmp    %rax,%rdx
  801a4e:	73 b4                	jae    801a04 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a54:	8b 40 04             	mov    0x4(%rax),%eax
  801a57:	99                   	cltd   
  801a58:	c1 ea 1b             	shr    $0x1b,%edx
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	83 e0 1f             	and    $0x1f,%eax
  801a60:	29 d0                	sub    %edx,%eax
  801a62:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a66:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a6a:	48 01 ca             	add    %rcx,%rdx
  801a6d:	0f b6 0a             	movzbl (%rdx),%ecx
  801a70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a74:	48 98                	cltq   
  801a76:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7e:	8b 40 04             	mov    0x4(%rax),%eax
  801a81:	8d 50 01             	lea    0x1(%rax),%edx
  801a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a88:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a94:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a98:	0f 82 64 ff ff ff    	jb     801a02 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801aa2:	c9                   	leaveq 
  801aa3:	c3                   	retq   

0000000000801aa4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aa4:	55                   	push   %rbp
  801aa5:	48 89 e5             	mov    %rsp,%rbp
  801aa8:	48 83 ec 20          	sub    $0x20,%rsp
  801aac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ab0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab8:	48 89 c7             	mov    %rax,%rdi
  801abb:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  801ac2:	00 00 00 
  801ac5:	ff d0                	callq  *%rax
  801ac7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801acb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801acf:	48 be 8e 37 80 00 00 	movabs $0x80378e,%rsi
  801ad6:	00 00 00 
  801ad9:	48 89 c7             	mov    %rax,%rdi
  801adc:	48 b8 2c 2c 80 00 00 	movabs $0x802c2c,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aec:	8b 50 04             	mov    0x4(%rax),%edx
  801aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af3:	8b 00                	mov    (%rax),%eax
  801af5:	29 c2                	sub    %eax,%edx
  801af7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801afb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801b01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b05:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b0c:	00 00 00 
	stat->st_dev = &devpipe;
  801b0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b13:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b1a:	00 00 00 
  801b1d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b29:	c9                   	leaveq 
  801b2a:	c3                   	retq   

0000000000801b2b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b2b:	55                   	push   %rbp
  801b2c:	48 89 e5             	mov    %rsp,%rbp
  801b2f:	48 83 ec 10          	sub    $0x10,%rsp
  801b33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3b:	48 89 c6             	mov    %rax,%rsi
  801b3e:	bf 00 00 00 00       	mov    $0x0,%edi
  801b43:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b53:	48 89 c7             	mov    %rax,%rdi
  801b56:	48 b8 89 05 80 00 00 	movabs $0x800589,%rax
  801b5d:	00 00 00 
  801b60:	ff d0                	callq  *%rax
  801b62:	48 89 c6             	mov    %rax,%rsi
  801b65:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6a:	48 b8 a4 03 80 00 00 	movabs $0x8003a4,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 20          	sub    $0x20,%rsp
  801b80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b86:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b89:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b8d:	be 01 00 00 00       	mov    $0x1,%esi
  801b92:	48 89 c7             	mov    %rax,%rdi
  801b95:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <getchar>:

int
getchar(void)
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bab:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801baf:	ba 01 00 00 00       	mov    $0x1,%edx
  801bb4:	48 89 c6             	mov    %rax,%rsi
  801bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbc:	48 b8 7e 0a 80 00 00 	movabs $0x800a7e,%rax
  801bc3:	00 00 00 
  801bc6:	ff d0                	callq  *%rax
  801bc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bcf:	79 05                	jns    801bd6 <getchar+0x33>
		return r;
  801bd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd4:	eb 14                	jmp    801bea <getchar+0x47>
	if (r < 1)
  801bd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bda:	7f 07                	jg     801be3 <getchar+0x40>
		return -E_EOF;
  801bdc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801be1:	eb 07                	jmp    801bea <getchar+0x47>
	return c;
  801be3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801be7:	0f b6 c0             	movzbl %al,%eax
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 20          	sub    $0x20,%rsp
  801bf4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bf7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801bfb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bfe:	48 89 d6             	mov    %rdx,%rsi
  801c01:	89 c7                	mov    %eax,%edi
  801c03:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	callq  *%rax
  801c0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c16:	79 05                	jns    801c1d <iscons+0x31>
		return r;
  801c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1b:	eb 1a                	jmp    801c37 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c21:	8b 10                	mov    (%rax),%edx
  801c23:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c2a:	00 00 00 
  801c2d:	8b 00                	mov    (%rax),%eax
  801c2f:	39 c2                	cmp    %eax,%edx
  801c31:	0f 94 c0             	sete   %al
  801c34:	0f b6 c0             	movzbl %al,%eax
}
  801c37:	c9                   	leaveq 
  801c38:	c3                   	retq   

0000000000801c39 <opencons>:

int
opencons(void)
{
  801c39:	55                   	push   %rbp
  801c3a:	48 89 e5             	mov    %rsp,%rbp
  801c3d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c41:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c45:	48 89 c7             	mov    %rax,%rdi
  801c48:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  801c4f:	00 00 00 
  801c52:	ff d0                	callq  *%rax
  801c54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c5b:	79 05                	jns    801c62 <opencons+0x29>
		return r;
  801c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c60:	eb 5b                	jmp    801cbd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c66:	ba 07 04 00 00       	mov    $0x407,%edx
  801c6b:	48 89 c6             	mov    %rax,%rsi
  801c6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c73:	48 b8 f9 02 80 00 00 	movabs $0x8002f9,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
  801c7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c86:	79 05                	jns    801c8d <opencons+0x54>
		return r;
  801c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8b:	eb 30                	jmp    801cbd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c91:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c98:	00 00 00 
  801c9b:	8b 12                	mov    (%rdx),%edx
  801c9d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801caa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cae:	48 89 c7             	mov    %rax,%rdi
  801cb1:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  801cb8:	00 00 00 
  801cbb:	ff d0                	callq  *%rax
}
  801cbd:	c9                   	leaveq 
  801cbe:	c3                   	retq   

0000000000801cbf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cbf:	55                   	push   %rbp
  801cc0:	48 89 e5             	mov    %rsp,%rbp
  801cc3:	48 83 ec 30          	sub    $0x30,%rsp
  801cc7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ccb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ccf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cd3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cd8:	75 07                	jne    801ce1 <devcons_read+0x22>
		return 0;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdf:	eb 4b                	jmp    801d2c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801ce1:	eb 0c                	jmp    801cef <devcons_read+0x30>
		sys_yield();
  801ce3:	48 b8 bb 02 80 00 00 	movabs $0x8002bb,%rax
  801cea:	00 00 00 
  801ced:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cef:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  801cf6:	00 00 00 
  801cf9:	ff d0                	callq  *%rax
  801cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d02:	74 df                	je     801ce3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801d04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d08:	79 05                	jns    801d0f <devcons_read+0x50>
		return c;
  801d0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0d:	eb 1d                	jmp    801d2c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d0f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d13:	75 07                	jne    801d1c <devcons_read+0x5d>
		return 0;
  801d15:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1a:	eb 10                	jmp    801d2c <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1f:	89 c2                	mov    %eax,%edx
  801d21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d25:	88 10                	mov    %dl,(%rax)
	return 1;
  801d27:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d2c:	c9                   	leaveq 
  801d2d:	c3                   	retq   

0000000000801d2e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d2e:	55                   	push   %rbp
  801d2f:	48 89 e5             	mov    %rsp,%rbp
  801d32:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d39:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d40:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d47:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d55:	eb 76                	jmp    801dcd <devcons_write+0x9f>
		m = n - tot;
  801d57:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d5e:	89 c2                	mov    %eax,%edx
  801d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d63:	29 c2                	sub    %eax,%edx
  801d65:	89 d0                	mov    %edx,%eax
  801d67:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d6d:	83 f8 7f             	cmp    $0x7f,%eax
  801d70:	76 07                	jbe    801d79 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d72:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d7c:	48 63 d0             	movslq %eax,%rdx
  801d7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d82:	48 63 c8             	movslq %eax,%rcx
  801d85:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d8c:	48 01 c1             	add    %rax,%rcx
  801d8f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d96:	48 89 ce             	mov    %rcx,%rsi
  801d99:	48 89 c7             	mov    %rax,%rdi
  801d9c:	48 b8 50 2f 80 00 00 	movabs $0x802f50,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801da8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dab:	48 63 d0             	movslq %eax,%rdx
  801dae:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801db5:	48 89 d6             	mov    %rdx,%rsi
  801db8:	48 89 c7             	mov    %rax,%rdi
  801dbb:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dc7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dca:	01 45 fc             	add    %eax,-0x4(%rbp)
  801dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd0:	48 98                	cltq   
  801dd2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801dd9:	0f 82 78 ff ff ff    	jb     801d57 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801de2:	c9                   	leaveq 
  801de3:	c3                   	retq   

0000000000801de4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801de4:	55                   	push   %rbp
  801de5:	48 89 e5             	mov    %rsp,%rbp
  801de8:	48 83 ec 08          	sub    $0x8,%rsp
  801dec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 10          	sub    $0x10,%rsp
  801dff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e0b:	48 be 9a 37 80 00 00 	movabs $0x80379a,%rsi
  801e12:	00 00 00 
  801e15:	48 89 c7             	mov    %rax,%rdi
  801e18:	48 b8 2c 2c 80 00 00 	movabs $0x802c2c,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	callq  *%rax
	return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e29:	c9                   	leaveq 
  801e2a:	c3                   	retq   

0000000000801e2b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e2b:	55                   	push   %rbp
  801e2c:	48 89 e5             	mov    %rsp,%rbp
  801e2f:	53                   	push   %rbx
  801e30:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e37:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e3e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e44:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e4b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e52:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e59:	84 c0                	test   %al,%al
  801e5b:	74 23                	je     801e80 <_panic+0x55>
  801e5d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e64:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e68:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e6c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e70:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e74:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e78:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e7c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e80:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e87:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e8e:	00 00 00 
  801e91:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e98:	00 00 00 
  801e9b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e9f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801ea6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801ead:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801eb4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801ebb:	00 00 00 
  801ebe:	48 8b 18             	mov    (%rax),%rbx
  801ec1:	48 b8 7d 02 80 00 00 	movabs $0x80027d,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	callq  *%rax
  801ecd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801ed3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801eda:	41 89 c8             	mov    %ecx,%r8d
  801edd:	48 89 d1             	mov    %rdx,%rcx
  801ee0:	48 89 da             	mov    %rbx,%rdx
  801ee3:	89 c6                	mov    %eax,%esi
  801ee5:	48 bf a8 37 80 00 00 	movabs $0x8037a8,%rdi
  801eec:	00 00 00 
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	49 b9 64 20 80 00 00 	movabs $0x802064,%r9
  801efb:	00 00 00 
  801efe:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f01:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f08:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f0f:	48 89 d6             	mov    %rdx,%rsi
  801f12:	48 89 c7             	mov    %rax,%rdi
  801f15:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  801f1c:	00 00 00 
  801f1f:	ff d0                	callq  *%rax
	cprintf("\n");
  801f21:	48 bf cb 37 80 00 00 	movabs $0x8037cb,%rdi
  801f28:	00 00 00 
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	48 ba 64 20 80 00 00 	movabs $0x802064,%rdx
  801f37:	00 00 00 
  801f3a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f3c:	cc                   	int3   
  801f3d:	eb fd                	jmp    801f3c <_panic+0x111>

0000000000801f3f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f3f:	55                   	push   %rbp
  801f40:	48 89 e5             	mov    %rsp,%rbp
  801f43:	48 83 ec 10          	sub    $0x10,%rsp
  801f47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f52:	8b 00                	mov    (%rax),%eax
  801f54:	8d 48 01             	lea    0x1(%rax),%ecx
  801f57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f5b:	89 0a                	mov    %ecx,(%rdx)
  801f5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f60:	89 d1                	mov    %edx,%ecx
  801f62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f66:	48 98                	cltq   
  801f68:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f70:	8b 00                	mov    (%rax),%eax
  801f72:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f77:	75 2c                	jne    801fa5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7d:	8b 00                	mov    (%rax),%eax
  801f7f:	48 98                	cltq   
  801f81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f85:	48 83 c2 08          	add    $0x8,%rdx
  801f89:	48 89 c6             	mov    %rax,%rsi
  801f8c:	48 89 d7             	mov    %rdx,%rdi
  801f8f:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
        b->idx = 0;
  801f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801fa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa9:	8b 40 04             	mov    0x4(%rax),%eax
  801fac:	8d 50 01             	lea    0x1(%rax),%edx
  801faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb3:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fb6:	c9                   	leaveq 
  801fb7:	c3                   	retq   

0000000000801fb8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fb8:	55                   	push   %rbp
  801fb9:	48 89 e5             	mov    %rsp,%rbp
  801fbc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fc3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fca:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fd1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fd8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fdf:	48 8b 0a             	mov    (%rdx),%rcx
  801fe2:	48 89 08             	mov    %rcx,(%rax)
  801fe5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fe9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801fed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801ff1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801ff5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801ffc:	00 00 00 
    b.cnt = 0;
  801fff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802006:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802009:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802010:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802017:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80201e:	48 89 c6             	mov    %rax,%rsi
  802021:	48 bf 3f 1f 80 00 00 	movabs $0x801f3f,%rdi
  802028:	00 00 00 
  80202b:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802037:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80203d:	48 98                	cltq   
  80203f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802046:	48 83 c2 08          	add    $0x8,%rdx
  80204a:	48 89 c6             	mov    %rax,%rsi
  80204d:	48 89 d7             	mov    %rdx,%rdi
  802050:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  802057:	00 00 00 
  80205a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80205c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802062:	c9                   	leaveq 
  802063:	c3                   	retq   

0000000000802064 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802064:	55                   	push   %rbp
  802065:	48 89 e5             	mov    %rsp,%rbp
  802068:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80206f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802076:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80207d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802084:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80208b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802092:	84 c0                	test   %al,%al
  802094:	74 20                	je     8020b6 <cprintf+0x52>
  802096:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80209a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80209e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8020a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8020a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8020aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020bd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020c4:	00 00 00 
  8020c7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020ce:	00 00 00 
  8020d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020ea:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020f1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020f8:	48 8b 0a             	mov    (%rdx),%rcx
  8020fb:	48 89 08             	mov    %rcx,(%rax)
  8020fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802102:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802106:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80210a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80210e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802115:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80211c:	48 89 d6             	mov    %rdx,%rsi
  80211f:	48 89 c7             	mov    %rax,%rdi
  802122:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax
  80212e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802134:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80213a:	c9                   	leaveq 
  80213b:	c3                   	retq   

000000000080213c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80213c:	55                   	push   %rbp
  80213d:	48 89 e5             	mov    %rsp,%rbp
  802140:	53                   	push   %rbx
  802141:	48 83 ec 38          	sub    $0x38,%rsp
  802145:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802149:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80214d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802151:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802154:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802158:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80215c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80215f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802163:	77 3b                	ja     8021a0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802165:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802168:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80216c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80216f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802173:	ba 00 00 00 00       	mov    $0x0,%edx
  802178:	48 f7 f3             	div    %rbx
  80217b:	48 89 c2             	mov    %rax,%rdx
  80217e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802181:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802184:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218c:	41 89 f9             	mov    %edi,%r9d
  80218f:	48 89 c7             	mov    %rax,%rdi
  802192:	48 b8 3c 21 80 00 00 	movabs $0x80213c,%rax
  802199:	00 00 00 
  80219c:	ff d0                	callq  *%rax
  80219e:	eb 1e                	jmp    8021be <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021a0:	eb 12                	jmp    8021b4 <printnum+0x78>
			putch(padc, putdat);
  8021a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021a6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8021a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ad:	48 89 ce             	mov    %rcx,%rsi
  8021b0:	89 d7                	mov    %edx,%edi
  8021b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021b4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021b8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021bc:	7f e4                	jg     8021a2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ca:	48 f7 f1             	div    %rcx
  8021cd:	48 89 d0             	mov    %rdx,%rax
  8021d0:	48 ba d0 39 80 00 00 	movabs $0x8039d0,%rdx
  8021d7:	00 00 00 
  8021da:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021de:	0f be d0             	movsbl %al,%edx
  8021e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e9:	48 89 ce             	mov    %rcx,%rsi
  8021ec:	89 d7                	mov    %edx,%edi
  8021ee:	ff d0                	callq  *%rax
}
  8021f0:	48 83 c4 38          	add    $0x38,%rsp
  8021f4:	5b                   	pop    %rbx
  8021f5:	5d                   	pop    %rbp
  8021f6:	c3                   	retq   

00000000008021f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021f7:	55                   	push   %rbp
  8021f8:	48 89 e5             	mov    %rsp,%rbp
  8021fb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8021ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802203:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  802206:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80220a:	7e 52                	jle    80225e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80220c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802210:	8b 00                	mov    (%rax),%eax
  802212:	83 f8 30             	cmp    $0x30,%eax
  802215:	73 24                	jae    80223b <getuint+0x44>
  802217:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80221f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802223:	8b 00                	mov    (%rax),%eax
  802225:	89 c0                	mov    %eax,%eax
  802227:	48 01 d0             	add    %rdx,%rax
  80222a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80222e:	8b 12                	mov    (%rdx),%edx
  802230:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802233:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802237:	89 0a                	mov    %ecx,(%rdx)
  802239:	eb 17                	jmp    802252 <getuint+0x5b>
  80223b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802243:	48 89 d0             	mov    %rdx,%rax
  802246:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80224a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80224e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802252:	48 8b 00             	mov    (%rax),%rax
  802255:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802259:	e9 a3 00 00 00       	jmpq   802301 <getuint+0x10a>
	else if (lflag)
  80225e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802262:	74 4f                	je     8022b3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802268:	8b 00                	mov    (%rax),%eax
  80226a:	83 f8 30             	cmp    $0x30,%eax
  80226d:	73 24                	jae    802293 <getuint+0x9c>
  80226f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802273:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227b:	8b 00                	mov    (%rax),%eax
  80227d:	89 c0                	mov    %eax,%eax
  80227f:	48 01 d0             	add    %rdx,%rax
  802282:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802286:	8b 12                	mov    (%rdx),%edx
  802288:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80228b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80228f:	89 0a                	mov    %ecx,(%rdx)
  802291:	eb 17                	jmp    8022aa <getuint+0xb3>
  802293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802297:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80229b:	48 89 d0             	mov    %rdx,%rax
  80229e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022aa:	48 8b 00             	mov    (%rax),%rax
  8022ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022b1:	eb 4e                	jmp    802301 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b7:	8b 00                	mov    (%rax),%eax
  8022b9:	83 f8 30             	cmp    $0x30,%eax
  8022bc:	73 24                	jae    8022e2 <getuint+0xeb>
  8022be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ca:	8b 00                	mov    (%rax),%eax
  8022cc:	89 c0                	mov    %eax,%eax
  8022ce:	48 01 d0             	add    %rdx,%rax
  8022d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022d5:	8b 12                	mov    (%rdx),%edx
  8022d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022de:	89 0a                	mov    %ecx,(%rdx)
  8022e0:	eb 17                	jmp    8022f9 <getuint+0x102>
  8022e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022ea:	48 89 d0             	mov    %rdx,%rax
  8022ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022f9:	8b 00                	mov    (%rax),%eax
  8022fb:	89 c0                	mov    %eax,%eax
  8022fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802305:	c9                   	leaveq 
  802306:	c3                   	retq   

0000000000802307 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802307:	55                   	push   %rbp
  802308:	48 89 e5             	mov    %rsp,%rbp
  80230b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80230f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802313:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802316:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80231a:	7e 52                	jle    80236e <getint+0x67>
		x=va_arg(*ap, long long);
  80231c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802320:	8b 00                	mov    (%rax),%eax
  802322:	83 f8 30             	cmp    $0x30,%eax
  802325:	73 24                	jae    80234b <getint+0x44>
  802327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80232f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802333:	8b 00                	mov    (%rax),%eax
  802335:	89 c0                	mov    %eax,%eax
  802337:	48 01 d0             	add    %rdx,%rax
  80233a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80233e:	8b 12                	mov    (%rdx),%edx
  802340:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802343:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802347:	89 0a                	mov    %ecx,(%rdx)
  802349:	eb 17                	jmp    802362 <getint+0x5b>
  80234b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802353:	48 89 d0             	mov    %rdx,%rax
  802356:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80235a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80235e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802362:	48 8b 00             	mov    (%rax),%rax
  802365:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802369:	e9 a3 00 00 00       	jmpq   802411 <getint+0x10a>
	else if (lflag)
  80236e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802372:	74 4f                	je     8023c3 <getint+0xbc>
		x=va_arg(*ap, long);
  802374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802378:	8b 00                	mov    (%rax),%eax
  80237a:	83 f8 30             	cmp    $0x30,%eax
  80237d:	73 24                	jae    8023a3 <getint+0x9c>
  80237f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802383:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238b:	8b 00                	mov    (%rax),%eax
  80238d:	89 c0                	mov    %eax,%eax
  80238f:	48 01 d0             	add    %rdx,%rax
  802392:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802396:	8b 12                	mov    (%rdx),%edx
  802398:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80239b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239f:	89 0a                	mov    %ecx,(%rdx)
  8023a1:	eb 17                	jmp    8023ba <getint+0xb3>
  8023a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023ab:	48 89 d0             	mov    %rdx,%rax
  8023ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023ba:	48 8b 00             	mov    (%rax),%rax
  8023bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023c1:	eb 4e                	jmp    802411 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c7:	8b 00                	mov    (%rax),%eax
  8023c9:	83 f8 30             	cmp    $0x30,%eax
  8023cc:	73 24                	jae    8023f2 <getint+0xeb>
  8023ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	8b 00                	mov    (%rax),%eax
  8023dc:	89 c0                	mov    %eax,%eax
  8023de:	48 01 d0             	add    %rdx,%rax
  8023e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023e5:	8b 12                	mov    (%rdx),%edx
  8023e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023ee:	89 0a                	mov    %ecx,(%rdx)
  8023f0:	eb 17                	jmp    802409 <getint+0x102>
  8023f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023fa:	48 89 d0             	mov    %rdx,%rax
  8023fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802401:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802405:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802409:	8b 00                	mov    (%rax),%eax
  80240b:	48 98                	cltq   
  80240d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802415:	c9                   	leaveq 
  802416:	c3                   	retq   

0000000000802417 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802417:	55                   	push   %rbp
  802418:	48 89 e5             	mov    %rsp,%rbp
  80241b:	41 54                	push   %r12
  80241d:	53                   	push   %rbx
  80241e:	48 83 ec 60          	sub    $0x60,%rsp
  802422:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802426:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80242a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80242e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802432:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802436:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80243a:	48 8b 0a             	mov    (%rdx),%rcx
  80243d:	48 89 08             	mov    %rcx,(%rax)
  802440:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802444:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802448:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80244c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802450:	eb 17                	jmp    802469 <vprintfmt+0x52>
			if (ch == '\0')
  802452:	85 db                	test   %ebx,%ebx
  802454:	0f 84 df 04 00 00    	je     802939 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80245a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80245e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802462:	48 89 d6             	mov    %rdx,%rsi
  802465:	89 df                	mov    %ebx,%edi
  802467:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802469:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80246d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802471:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802475:	0f b6 00             	movzbl (%rax),%eax
  802478:	0f b6 d8             	movzbl %al,%ebx
  80247b:	83 fb 25             	cmp    $0x25,%ebx
  80247e:	75 d2                	jne    802452 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802480:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802484:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80248b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802492:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802499:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8024a0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024ac:	0f b6 00             	movzbl (%rax),%eax
  8024af:	0f b6 d8             	movzbl %al,%ebx
  8024b2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024b5:	83 f8 55             	cmp    $0x55,%eax
  8024b8:	0f 87 47 04 00 00    	ja     802905 <vprintfmt+0x4ee>
  8024be:	89 c0                	mov    %eax,%eax
  8024c0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024c7:	00 
  8024c8:	48 b8 f8 39 80 00 00 	movabs $0x8039f8,%rax
  8024cf:	00 00 00 
  8024d2:	48 01 d0             	add    %rdx,%rax
  8024d5:	48 8b 00             	mov    (%rax),%rax
  8024d8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024da:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024de:	eb c0                	jmp    8024a0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024e0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024e4:	eb ba                	jmp    8024a0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024e6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024ed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024f0:	89 d0                	mov    %edx,%eax
  8024f2:	c1 e0 02             	shl    $0x2,%eax
  8024f5:	01 d0                	add    %edx,%eax
  8024f7:	01 c0                	add    %eax,%eax
  8024f9:	01 d8                	add    %ebx,%eax
  8024fb:	83 e8 30             	sub    $0x30,%eax
  8024fe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802501:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802505:	0f b6 00             	movzbl (%rax),%eax
  802508:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80250b:	83 fb 2f             	cmp    $0x2f,%ebx
  80250e:	7e 0c                	jle    80251c <vprintfmt+0x105>
  802510:	83 fb 39             	cmp    $0x39,%ebx
  802513:	7f 07                	jg     80251c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802515:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80251a:	eb d1                	jmp    8024ed <vprintfmt+0xd6>
			goto process_precision;
  80251c:	eb 58                	jmp    802576 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80251e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802521:	83 f8 30             	cmp    $0x30,%eax
  802524:	73 17                	jae    80253d <vprintfmt+0x126>
  802526:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80252a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80252d:	89 c0                	mov    %eax,%eax
  80252f:	48 01 d0             	add    %rdx,%rax
  802532:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802535:	83 c2 08             	add    $0x8,%edx
  802538:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80253b:	eb 0f                	jmp    80254c <vprintfmt+0x135>
  80253d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802541:	48 89 d0             	mov    %rdx,%rax
  802544:	48 83 c2 08          	add    $0x8,%rdx
  802548:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80254c:	8b 00                	mov    (%rax),%eax
  80254e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802551:	eb 23                	jmp    802576 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802553:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802557:	79 0c                	jns    802565 <vprintfmt+0x14e>
				width = 0;
  802559:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802560:	e9 3b ff ff ff       	jmpq   8024a0 <vprintfmt+0x89>
  802565:	e9 36 ff ff ff       	jmpq   8024a0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80256a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802571:	e9 2a ff ff ff       	jmpq   8024a0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802576:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80257a:	79 12                	jns    80258e <vprintfmt+0x177>
				width = precision, precision = -1;
  80257c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80257f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802582:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802589:	e9 12 ff ff ff       	jmpq   8024a0 <vprintfmt+0x89>
  80258e:	e9 0d ff ff ff       	jmpq   8024a0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802593:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802597:	e9 04 ff ff ff       	jmpq   8024a0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80259c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80259f:	83 f8 30             	cmp    $0x30,%eax
  8025a2:	73 17                	jae    8025bb <vprintfmt+0x1a4>
  8025a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025ab:	89 c0                	mov    %eax,%eax
  8025ad:	48 01 d0             	add    %rdx,%rax
  8025b0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025b3:	83 c2 08             	add    $0x8,%edx
  8025b6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025b9:	eb 0f                	jmp    8025ca <vprintfmt+0x1b3>
  8025bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025bf:	48 89 d0             	mov    %rdx,%rax
  8025c2:	48 83 c2 08          	add    $0x8,%rdx
  8025c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025ca:	8b 10                	mov    (%rax),%edx
  8025cc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025d4:	48 89 ce             	mov    %rcx,%rsi
  8025d7:	89 d7                	mov    %edx,%edi
  8025d9:	ff d0                	callq  *%rax
			break;
  8025db:	e9 53 03 00 00       	jmpq   802933 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025e3:	83 f8 30             	cmp    $0x30,%eax
  8025e6:	73 17                	jae    8025ff <vprintfmt+0x1e8>
  8025e8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025ef:	89 c0                	mov    %eax,%eax
  8025f1:	48 01 d0             	add    %rdx,%rax
  8025f4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025f7:	83 c2 08             	add    $0x8,%edx
  8025fa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025fd:	eb 0f                	jmp    80260e <vprintfmt+0x1f7>
  8025ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802603:	48 89 d0             	mov    %rdx,%rax
  802606:	48 83 c2 08          	add    $0x8,%rdx
  80260a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80260e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802610:	85 db                	test   %ebx,%ebx
  802612:	79 02                	jns    802616 <vprintfmt+0x1ff>
				err = -err;
  802614:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802616:	83 fb 15             	cmp    $0x15,%ebx
  802619:	7f 16                	jg     802631 <vprintfmt+0x21a>
  80261b:	48 b8 20 39 80 00 00 	movabs $0x803920,%rax
  802622:	00 00 00 
  802625:	48 63 d3             	movslq %ebx,%rdx
  802628:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80262c:	4d 85 e4             	test   %r12,%r12
  80262f:	75 2e                	jne    80265f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802631:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802635:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802639:	89 d9                	mov    %ebx,%ecx
  80263b:	48 ba e1 39 80 00 00 	movabs $0x8039e1,%rdx
  802642:	00 00 00 
  802645:	48 89 c7             	mov    %rax,%rdi
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	49 b8 42 29 80 00 00 	movabs $0x802942,%r8
  802654:	00 00 00 
  802657:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80265a:	e9 d4 02 00 00       	jmpq   802933 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80265f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802663:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802667:	4c 89 e1             	mov    %r12,%rcx
  80266a:	48 ba ea 39 80 00 00 	movabs $0x8039ea,%rdx
  802671:	00 00 00 
  802674:	48 89 c7             	mov    %rax,%rdi
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
  80267c:	49 b8 42 29 80 00 00 	movabs $0x802942,%r8
  802683:	00 00 00 
  802686:	41 ff d0             	callq  *%r8
			break;
  802689:	e9 a5 02 00 00       	jmpq   802933 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80268e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802691:	83 f8 30             	cmp    $0x30,%eax
  802694:	73 17                	jae    8026ad <vprintfmt+0x296>
  802696:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80269a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80269d:	89 c0                	mov    %eax,%eax
  80269f:	48 01 d0             	add    %rdx,%rax
  8026a2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8026a5:	83 c2 08             	add    $0x8,%edx
  8026a8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8026ab:	eb 0f                	jmp    8026bc <vprintfmt+0x2a5>
  8026ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026b1:	48 89 d0             	mov    %rdx,%rax
  8026b4:	48 83 c2 08          	add    $0x8,%rdx
  8026b8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026bc:	4c 8b 20             	mov    (%rax),%r12
  8026bf:	4d 85 e4             	test   %r12,%r12
  8026c2:	75 0a                	jne    8026ce <vprintfmt+0x2b7>
				p = "(null)";
  8026c4:	49 bc ed 39 80 00 00 	movabs $0x8039ed,%r12
  8026cb:	00 00 00 
			if (width > 0 && padc != '-')
  8026ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026d2:	7e 3f                	jle    802713 <vprintfmt+0x2fc>
  8026d4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026d8:	74 39                	je     802713 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026da:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026dd:	48 98                	cltq   
  8026df:	48 89 c6             	mov    %rax,%rsi
  8026e2:	4c 89 e7             	mov    %r12,%rdi
  8026e5:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  8026ec:	00 00 00 
  8026ef:	ff d0                	callq  *%rax
  8026f1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026f4:	eb 17                	jmp    80270d <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026f6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8026fa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8026fe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802702:	48 89 ce             	mov    %rcx,%rsi
  802705:	89 d7                	mov    %edx,%edi
  802707:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802709:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80270d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802711:	7f e3                	jg     8026f6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802713:	eb 37                	jmp    80274c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802715:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802719:	74 1e                	je     802739 <vprintfmt+0x322>
  80271b:	83 fb 1f             	cmp    $0x1f,%ebx
  80271e:	7e 05                	jle    802725 <vprintfmt+0x30e>
  802720:	83 fb 7e             	cmp    $0x7e,%ebx
  802723:	7e 14                	jle    802739 <vprintfmt+0x322>
					putch('?', putdat);
  802725:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802729:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80272d:	48 89 d6             	mov    %rdx,%rsi
  802730:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802735:	ff d0                	callq  *%rax
  802737:	eb 0f                	jmp    802748 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802739:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80273d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802741:	48 89 d6             	mov    %rdx,%rsi
  802744:	89 df                	mov    %ebx,%edi
  802746:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802748:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80274c:	4c 89 e0             	mov    %r12,%rax
  80274f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802753:	0f b6 00             	movzbl (%rax),%eax
  802756:	0f be d8             	movsbl %al,%ebx
  802759:	85 db                	test   %ebx,%ebx
  80275b:	74 10                	je     80276d <vprintfmt+0x356>
  80275d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802761:	78 b2                	js     802715 <vprintfmt+0x2fe>
  802763:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802767:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80276b:	79 a8                	jns    802715 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80276d:	eb 16                	jmp    802785 <vprintfmt+0x36e>
				putch(' ', putdat);
  80276f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802773:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802777:	48 89 d6             	mov    %rdx,%rsi
  80277a:	bf 20 00 00 00       	mov    $0x20,%edi
  80277f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802781:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802785:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802789:	7f e4                	jg     80276f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80278b:	e9 a3 01 00 00       	jmpq   802933 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802790:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802794:	be 03 00 00 00       	mov    $0x3,%esi
  802799:	48 89 c7             	mov    %rax,%rdi
  80279c:	48 b8 07 23 80 00 00 	movabs $0x802307,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	48 85 c0             	test   %rax,%rax
  8027b3:	79 1d                	jns    8027d2 <vprintfmt+0x3bb>
				putch('-', putdat);
  8027b5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027bd:	48 89 d6             	mov    %rdx,%rsi
  8027c0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027c5:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cb:	48 f7 d8             	neg    %rax
  8027ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027d2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027d9:	e9 e8 00 00 00       	jmpq   8028c6 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027de:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027e2:	be 03 00 00 00       	mov    $0x3,%esi
  8027e7:	48 89 c7             	mov    %rax,%rdi
  8027ea:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  8027f1:	00 00 00 
  8027f4:	ff d0                	callq  *%rax
  8027f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8027fa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802801:	e9 c0 00 00 00       	jmpq   8028c6 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802806:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80280a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80280e:	48 89 d6             	mov    %rdx,%rsi
  802811:	bf 58 00 00 00       	mov    $0x58,%edi
  802816:	ff d0                	callq  *%rax
			putch('X', putdat);
  802818:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80281c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802820:	48 89 d6             	mov    %rdx,%rsi
  802823:	bf 58 00 00 00       	mov    $0x58,%edi
  802828:	ff d0                	callq  *%rax
			putch('X', putdat);
  80282a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80282e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802832:	48 89 d6             	mov    %rdx,%rsi
  802835:	bf 58 00 00 00       	mov    $0x58,%edi
  80283a:	ff d0                	callq  *%rax
			break;
  80283c:	e9 f2 00 00 00       	jmpq   802933 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802841:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802845:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802849:	48 89 d6             	mov    %rdx,%rsi
  80284c:	bf 30 00 00 00       	mov    $0x30,%edi
  802851:	ff d0                	callq  *%rax
			putch('x', putdat);
  802853:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802857:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80285b:	48 89 d6             	mov    %rdx,%rsi
  80285e:	bf 78 00 00 00       	mov    $0x78,%edi
  802863:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802865:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802868:	83 f8 30             	cmp    $0x30,%eax
  80286b:	73 17                	jae    802884 <vprintfmt+0x46d>
  80286d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802871:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802874:	89 c0                	mov    %eax,%eax
  802876:	48 01 d0             	add    %rdx,%rax
  802879:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80287c:	83 c2 08             	add    $0x8,%edx
  80287f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802882:	eb 0f                	jmp    802893 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  802884:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802888:	48 89 d0             	mov    %rdx,%rax
  80288b:	48 83 c2 08          	add    $0x8,%rdx
  80288f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802893:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802896:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80289a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8028a1:	eb 23                	jmp    8028c6 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8028a3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028a7:	be 03 00 00 00       	mov    $0x3,%esi
  8028ac:	48 89 c7             	mov    %rax,%rdi
  8028af:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  8028b6:	00 00 00 
  8028b9:	ff d0                	callq  *%rax
  8028bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028bf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028c6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028cb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028ce:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028d5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028dd:	45 89 c1             	mov    %r8d,%r9d
  8028e0:	41 89 f8             	mov    %edi,%r8d
  8028e3:	48 89 c7             	mov    %rax,%rdi
  8028e6:	48 b8 3c 21 80 00 00 	movabs $0x80213c,%rax
  8028ed:	00 00 00 
  8028f0:	ff d0                	callq  *%rax
			break;
  8028f2:	eb 3f                	jmp    802933 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028fc:	48 89 d6             	mov    %rdx,%rsi
  8028ff:	89 df                	mov    %ebx,%edi
  802901:	ff d0                	callq  *%rax
			break;
  802903:	eb 2e                	jmp    802933 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802905:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802909:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80290d:	48 89 d6             	mov    %rdx,%rsi
  802910:	bf 25 00 00 00       	mov    $0x25,%edi
  802915:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802917:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80291c:	eb 05                	jmp    802923 <vprintfmt+0x50c>
  80291e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802923:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802927:	48 83 e8 01          	sub    $0x1,%rax
  80292b:	0f b6 00             	movzbl (%rax),%eax
  80292e:	3c 25                	cmp    $0x25,%al
  802930:	75 ec                	jne    80291e <vprintfmt+0x507>
				/* do nothing */;
			break;
  802932:	90                   	nop
		}
	}
  802933:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802934:	e9 30 fb ff ff       	jmpq   802469 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802939:	48 83 c4 60          	add    $0x60,%rsp
  80293d:	5b                   	pop    %rbx
  80293e:	41 5c                	pop    %r12
  802940:	5d                   	pop    %rbp
  802941:	c3                   	retq   

0000000000802942 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802942:	55                   	push   %rbp
  802943:	48 89 e5             	mov    %rsp,%rbp
  802946:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80294d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802954:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80295b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802962:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802969:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802970:	84 c0                	test   %al,%al
  802972:	74 20                	je     802994 <printfmt+0x52>
  802974:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802978:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80297c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802980:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802984:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802988:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80298c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802990:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802994:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80299b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8029a2:	00 00 00 
  8029a5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8029ac:	00 00 00 
  8029af:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029b3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029ba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029c1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029c8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029cf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029d6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029dd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029e4:	48 89 c7             	mov    %rax,%rdi
  8029e7:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029f3:	c9                   	leaveq 
  8029f4:	c3                   	retq   

00000000008029f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	48 83 ec 10          	sub    $0x10,%rsp
  8029fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802a04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a08:	8b 40 10             	mov    0x10(%rax),%eax
  802a0b:	8d 50 01             	lea    0x1(%rax),%edx
  802a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a12:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a19:	48 8b 10             	mov    (%rax),%rdx
  802a1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a20:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a24:	48 39 c2             	cmp    %rax,%rdx
  802a27:	73 17                	jae    802a40 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2d:	48 8b 00             	mov    (%rax),%rax
  802a30:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a38:	48 89 0a             	mov    %rcx,(%rdx)
  802a3b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a3e:	88 10                	mov    %dl,(%rax)
}
  802a40:	c9                   	leaveq 
  802a41:	c3                   	retq   

0000000000802a42 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a42:	55                   	push   %rbp
  802a43:	48 89 e5             	mov    %rsp,%rbp
  802a46:	48 83 ec 50          	sub    $0x50,%rsp
  802a4a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a4e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a51:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a55:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a59:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a5d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a61:	48 8b 0a             	mov    (%rdx),%rcx
  802a64:	48 89 08             	mov    %rcx,(%rax)
  802a67:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a6b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a6f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a73:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a7b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a7f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a82:	48 98                	cltq   
  802a84:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a88:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a8c:	48 01 d0             	add    %rdx,%rax
  802a8f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a9a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a9f:	74 06                	je     802aa7 <vsnprintf+0x65>
  802aa1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802aa5:	7f 07                	jg     802aae <vsnprintf+0x6c>
		return -E_INVAL;
  802aa7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aac:	eb 2f                	jmp    802add <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802aae:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802ab2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802ab6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802aba:	48 89 c6             	mov    %rax,%rsi
  802abd:	48 bf f5 29 80 00 00 	movabs $0x8029f5,%rdi
  802ac4:	00 00 00 
  802ac7:	48 b8 17 24 80 00 00 	movabs $0x802417,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802ad3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ad7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802ada:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802add:	c9                   	leaveq 
  802ade:	c3                   	retq   

0000000000802adf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802adf:	55                   	push   %rbp
  802ae0:	48 89 e5             	mov    %rsp,%rbp
  802ae3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802aea:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802af1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802af7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802afe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b05:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b0c:	84 c0                	test   %al,%al
  802b0e:	74 20                	je     802b30 <snprintf+0x51>
  802b10:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b14:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b18:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b1c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b20:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b24:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b28:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b2c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b30:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b37:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b3e:	00 00 00 
  802b41:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b48:	00 00 00 
  802b4b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b4f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b56:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b5d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b64:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b6b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b72:	48 8b 0a             	mov    (%rdx),%rcx
  802b75:	48 89 08             	mov    %rcx,(%rax)
  802b78:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b7c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b80:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b84:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b88:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b8f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b96:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b9c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802ba3:	48 89 c7             	mov    %rax,%rdi
  802ba6:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  802bad:	00 00 00 
  802bb0:	ff d0                	callq  *%rax
  802bb2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802bb8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bbe:	c9                   	leaveq 
  802bbf:	c3                   	retq   

0000000000802bc0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	48 83 ec 18          	sub    $0x18,%rsp
  802bc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bd3:	eb 09                	jmp    802bde <strlen+0x1e>
		n++;
  802bd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bd9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be2:	0f b6 00             	movzbl (%rax),%eax
  802be5:	84 c0                	test   %al,%al
  802be7:	75 ec                	jne    802bd5 <strlen+0x15>
		n++;
	return n;
  802be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bec:	c9                   	leaveq 
  802bed:	c3                   	retq   

0000000000802bee <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802bee:	55                   	push   %rbp
  802bef:	48 89 e5             	mov    %rsp,%rbp
  802bf2:	48 83 ec 20          	sub    $0x20,%rsp
  802bf6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c05:	eb 0e                	jmp    802c15 <strnlen+0x27>
		n++;
  802c07:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c0b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c10:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c15:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c1a:	74 0b                	je     802c27 <strnlen+0x39>
  802c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c20:	0f b6 00             	movzbl (%rax),%eax
  802c23:	84 c0                	test   %al,%al
  802c25:	75 e0                	jne    802c07 <strnlen+0x19>
		n++;
	return n;
  802c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c2a:	c9                   	leaveq 
  802c2b:	c3                   	retq   

0000000000802c2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c2c:	55                   	push   %rbp
  802c2d:	48 89 e5             	mov    %rsp,%rbp
  802c30:	48 83 ec 20          	sub    $0x20,%rsp
  802c34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c44:	90                   	nop
  802c45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c49:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c4d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c51:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c55:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c59:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c5d:	0f b6 12             	movzbl (%rdx),%edx
  802c60:	88 10                	mov    %dl,(%rax)
  802c62:	0f b6 00             	movzbl (%rax),%eax
  802c65:	84 c0                	test   %al,%al
  802c67:	75 dc                	jne    802c45 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c6d:	c9                   	leaveq 
  802c6e:	c3                   	retq   

0000000000802c6f <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c6f:	55                   	push   %rbp
  802c70:	48 89 e5             	mov    %rsp,%rbp
  802c73:	48 83 ec 20          	sub    $0x20,%rsp
  802c77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c83:	48 89 c7             	mov    %rax,%rdi
  802c86:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  802c8d:	00 00 00 
  802c90:	ff d0                	callq  *%rax
  802c92:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c98:	48 63 d0             	movslq %eax,%rdx
  802c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9f:	48 01 c2             	add    %rax,%rdx
  802ca2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca6:	48 89 c6             	mov    %rax,%rsi
  802ca9:	48 89 d7             	mov    %rdx,%rdi
  802cac:	48 b8 2c 2c 80 00 00 	movabs $0x802c2c,%rax
  802cb3:	00 00 00 
  802cb6:	ff d0                	callq  *%rax
	return dst;
  802cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802cbc:	c9                   	leaveq 
  802cbd:	c3                   	retq   

0000000000802cbe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802cbe:	55                   	push   %rbp
  802cbf:	48 89 e5             	mov    %rsp,%rbp
  802cc2:	48 83 ec 28          	sub    $0x28,%rsp
  802cc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802cda:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ce1:	00 
  802ce2:	eb 2a                	jmp    802d0e <strncpy+0x50>
		*dst++ = *src;
  802ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cf0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cf4:	0f b6 12             	movzbl (%rdx),%edx
  802cf7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802cf9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cfd:	0f b6 00             	movzbl (%rax),%eax
  802d00:	84 c0                	test   %al,%al
  802d02:	74 05                	je     802d09 <strncpy+0x4b>
			src++;
  802d04:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d09:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d12:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d16:	72 cc                	jb     802ce4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d1c:	c9                   	leaveq 
  802d1d:	c3                   	retq   

0000000000802d1e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d1e:	55                   	push   %rbp
  802d1f:	48 89 e5             	mov    %rsp,%rbp
  802d22:	48 83 ec 28          	sub    $0x28,%rsp
  802d26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d3a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d3f:	74 3d                	je     802d7e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d41:	eb 1d                	jmp    802d60 <strlcpy+0x42>
			*dst++ = *src++;
  802d43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d4b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d4f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d53:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d57:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d5b:	0f b6 12             	movzbl (%rdx),%edx
  802d5e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d60:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d65:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d6a:	74 0b                	je     802d77 <strlcpy+0x59>
  802d6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d70:	0f b6 00             	movzbl (%rax),%eax
  802d73:	84 c0                	test   %al,%al
  802d75:	75 cc                	jne    802d43 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d86:	48 29 c2             	sub    %rax,%rdx
  802d89:	48 89 d0             	mov    %rdx,%rax
}
  802d8c:	c9                   	leaveq 
  802d8d:	c3                   	retq   

0000000000802d8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d8e:	55                   	push   %rbp
  802d8f:	48 89 e5             	mov    %rsp,%rbp
  802d92:	48 83 ec 10          	sub    $0x10,%rsp
  802d96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d9e:	eb 0a                	jmp    802daa <strcmp+0x1c>
		p++, q++;
  802da0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802da5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802daa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dae:	0f b6 00             	movzbl (%rax),%eax
  802db1:	84 c0                	test   %al,%al
  802db3:	74 12                	je     802dc7 <strcmp+0x39>
  802db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db9:	0f b6 10             	movzbl (%rax),%edx
  802dbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc0:	0f b6 00             	movzbl (%rax),%eax
  802dc3:	38 c2                	cmp    %al,%dl
  802dc5:	74 d9                	je     802da0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802dc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dcb:	0f b6 00             	movzbl (%rax),%eax
  802dce:	0f b6 d0             	movzbl %al,%edx
  802dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd5:	0f b6 00             	movzbl (%rax),%eax
  802dd8:	0f b6 c0             	movzbl %al,%eax
  802ddb:	29 c2                	sub    %eax,%edx
  802ddd:	89 d0                	mov    %edx,%eax
}
  802ddf:	c9                   	leaveq 
  802de0:	c3                   	retq   

0000000000802de1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802de1:	55                   	push   %rbp
  802de2:	48 89 e5             	mov    %rsp,%rbp
  802de5:	48 83 ec 18          	sub    $0x18,%rsp
  802de9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ded:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802df1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802df5:	eb 0f                	jmp    802e06 <strncmp+0x25>
		n--, p++, q++;
  802df7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802dfc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e01:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e06:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e0b:	74 1d                	je     802e2a <strncmp+0x49>
  802e0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e11:	0f b6 00             	movzbl (%rax),%eax
  802e14:	84 c0                	test   %al,%al
  802e16:	74 12                	je     802e2a <strncmp+0x49>
  802e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1c:	0f b6 10             	movzbl (%rax),%edx
  802e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e23:	0f b6 00             	movzbl (%rax),%eax
  802e26:	38 c2                	cmp    %al,%dl
  802e28:	74 cd                	je     802df7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e2a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e2f:	75 07                	jne    802e38 <strncmp+0x57>
		return 0;
  802e31:	b8 00 00 00 00       	mov    $0x0,%eax
  802e36:	eb 18                	jmp    802e50 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3c:	0f b6 00             	movzbl (%rax),%eax
  802e3f:	0f b6 d0             	movzbl %al,%edx
  802e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e46:	0f b6 00             	movzbl (%rax),%eax
  802e49:	0f b6 c0             	movzbl %al,%eax
  802e4c:	29 c2                	sub    %eax,%edx
  802e4e:	89 d0                	mov    %edx,%eax
}
  802e50:	c9                   	leaveq 
  802e51:	c3                   	retq   

0000000000802e52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e52:	55                   	push   %rbp
  802e53:	48 89 e5             	mov    %rsp,%rbp
  802e56:	48 83 ec 0c          	sub    $0xc,%rsp
  802e5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5e:	89 f0                	mov    %esi,%eax
  802e60:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e63:	eb 17                	jmp    802e7c <strchr+0x2a>
		if (*s == c)
  802e65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e69:	0f b6 00             	movzbl (%rax),%eax
  802e6c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e6f:	75 06                	jne    802e77 <strchr+0x25>
			return (char *) s;
  802e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e75:	eb 15                	jmp    802e8c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e77:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e80:	0f b6 00             	movzbl (%rax),%eax
  802e83:	84 c0                	test   %al,%al
  802e85:	75 de                	jne    802e65 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e8c:	c9                   	leaveq 
  802e8d:	c3                   	retq   

0000000000802e8e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e8e:	55                   	push   %rbp
  802e8f:	48 89 e5             	mov    %rsp,%rbp
  802e92:	48 83 ec 0c          	sub    $0xc,%rsp
  802e96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e9a:	89 f0                	mov    %esi,%eax
  802e9c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e9f:	eb 13                	jmp    802eb4 <strfind+0x26>
		if (*s == c)
  802ea1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea5:	0f b6 00             	movzbl (%rax),%eax
  802ea8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802eab:	75 02                	jne    802eaf <strfind+0x21>
			break;
  802ead:	eb 10                	jmp    802ebf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802eaf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802eb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb8:	0f b6 00             	movzbl (%rax),%eax
  802ebb:	84 c0                	test   %al,%al
  802ebd:	75 e2                	jne    802ea1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ebf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ec3:	c9                   	leaveq 
  802ec4:	c3                   	retq   

0000000000802ec5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802ec5:	55                   	push   %rbp
  802ec6:	48 89 e5             	mov    %rsp,%rbp
  802ec9:	48 83 ec 18          	sub    $0x18,%rsp
  802ecd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ed1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ed4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ed8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802edd:	75 06                	jne    802ee5 <memset+0x20>
		return v;
  802edf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee3:	eb 69                	jmp    802f4e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee9:	83 e0 03             	and    $0x3,%eax
  802eec:	48 85 c0             	test   %rax,%rax
  802eef:	75 48                	jne    802f39 <memset+0x74>
  802ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef5:	83 e0 03             	and    $0x3,%eax
  802ef8:	48 85 c0             	test   %rax,%rax
  802efb:	75 3c                	jne    802f39 <memset+0x74>
		c &= 0xFF;
  802efd:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802f04:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f07:	c1 e0 18             	shl    $0x18,%eax
  802f0a:	89 c2                	mov    %eax,%edx
  802f0c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f0f:	c1 e0 10             	shl    $0x10,%eax
  802f12:	09 c2                	or     %eax,%edx
  802f14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f17:	c1 e0 08             	shl    $0x8,%eax
  802f1a:	09 d0                	or     %edx,%eax
  802f1c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f23:	48 c1 e8 02          	shr    $0x2,%rax
  802f27:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f2a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f2e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f31:	48 89 d7             	mov    %rdx,%rdi
  802f34:	fc                   	cld    
  802f35:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f37:	eb 11                	jmp    802f4a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f39:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f3d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f40:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f44:	48 89 d7             	mov    %rdx,%rdi
  802f47:	fc                   	cld    
  802f48:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f4e:	c9                   	leaveq 
  802f4f:	c3                   	retq   

0000000000802f50 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f50:	55                   	push   %rbp
  802f51:	48 89 e5             	mov    %rsp,%rbp
  802f54:	48 83 ec 28          	sub    $0x28,%rsp
  802f58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f60:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f70:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f78:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f7c:	0f 83 88 00 00 00    	jae    80300a <memmove+0xba>
  802f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f86:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f8a:	48 01 d0             	add    %rdx,%rax
  802f8d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f91:	76 77                	jbe    80300a <memmove+0xba>
		s += n;
  802f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f97:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa7:	83 e0 03             	and    $0x3,%eax
  802faa:	48 85 c0             	test   %rax,%rax
  802fad:	75 3b                	jne    802fea <memmove+0x9a>
  802faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb3:	83 e0 03             	and    $0x3,%eax
  802fb6:	48 85 c0             	test   %rax,%rax
  802fb9:	75 2f                	jne    802fea <memmove+0x9a>
  802fbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fbf:	83 e0 03             	and    $0x3,%eax
  802fc2:	48 85 c0             	test   %rax,%rax
  802fc5:	75 23                	jne    802fea <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcb:	48 83 e8 04          	sub    $0x4,%rax
  802fcf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fd3:	48 83 ea 04          	sub    $0x4,%rdx
  802fd7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fdb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fdf:	48 89 c7             	mov    %rax,%rdi
  802fe2:	48 89 d6             	mov    %rdx,%rsi
  802fe5:	fd                   	std    
  802fe6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fe8:	eb 1d                	jmp    803007 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fee:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802ff2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802ffa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ffe:	48 89 d7             	mov    %rdx,%rdi
  803001:	48 89 c1             	mov    %rax,%rcx
  803004:	fd                   	std    
  803005:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803007:	fc                   	cld    
  803008:	eb 57                	jmp    803061 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80300a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300e:	83 e0 03             	and    $0x3,%eax
  803011:	48 85 c0             	test   %rax,%rax
  803014:	75 36                	jne    80304c <memmove+0xfc>
  803016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301a:	83 e0 03             	and    $0x3,%eax
  80301d:	48 85 c0             	test   %rax,%rax
  803020:	75 2a                	jne    80304c <memmove+0xfc>
  803022:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803026:	83 e0 03             	and    $0x3,%eax
  803029:	48 85 c0             	test   %rax,%rax
  80302c:	75 1e                	jne    80304c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80302e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803032:	48 c1 e8 02          	shr    $0x2,%rax
  803036:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803041:	48 89 c7             	mov    %rax,%rdi
  803044:	48 89 d6             	mov    %rdx,%rsi
  803047:	fc                   	cld    
  803048:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80304a:	eb 15                	jmp    803061 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80304c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803050:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803054:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803058:	48 89 c7             	mov    %rax,%rdi
  80305b:	48 89 d6             	mov    %rdx,%rsi
  80305e:	fc                   	cld    
  80305f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803065:	c9                   	leaveq 
  803066:	c3                   	retq   

0000000000803067 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803067:	55                   	push   %rbp
  803068:	48 89 e5             	mov    %rsp,%rbp
  80306b:	48 83 ec 18          	sub    $0x18,%rsp
  80306f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803073:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803077:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80307b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80307f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803083:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803087:	48 89 ce             	mov    %rcx,%rsi
  80308a:	48 89 c7             	mov    %rax,%rdi
  80308d:	48 b8 50 2f 80 00 00 	movabs $0x802f50,%rax
  803094:	00 00 00 
  803097:	ff d0                	callq  *%rax
}
  803099:	c9                   	leaveq 
  80309a:	c3                   	retq   

000000000080309b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80309b:	55                   	push   %rbp
  80309c:	48 89 e5             	mov    %rsp,%rbp
  80309f:	48 83 ec 28          	sub    $0x28,%rsp
  8030a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8030af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030bf:	eb 36                	jmp    8030f7 <memcmp+0x5c>
		if (*s1 != *s2)
  8030c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c5:	0f b6 10             	movzbl (%rax),%edx
  8030c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cc:	0f b6 00             	movzbl (%rax),%eax
  8030cf:	38 c2                	cmp    %al,%dl
  8030d1:	74 1a                	je     8030ed <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d7:	0f b6 00             	movzbl (%rax),%eax
  8030da:	0f b6 d0             	movzbl %al,%edx
  8030dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e1:	0f b6 00             	movzbl (%rax),%eax
  8030e4:	0f b6 c0             	movzbl %al,%eax
  8030e7:	29 c2                	sub    %eax,%edx
  8030e9:	89 d0                	mov    %edx,%eax
  8030eb:	eb 20                	jmp    80310d <memcmp+0x72>
		s1++, s2++;
  8030ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803103:	48 85 c0             	test   %rax,%rax
  803106:	75 b9                	jne    8030c1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310d:	c9                   	leaveq 
  80310e:	c3                   	retq   

000000000080310f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80310f:	55                   	push   %rbp
  803110:	48 89 e5             	mov    %rsp,%rbp
  803113:	48 83 ec 28          	sub    $0x28,%rsp
  803117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80311b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80311e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803122:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803126:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80312a:	48 01 d0             	add    %rdx,%rax
  80312d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803131:	eb 15                	jmp    803148 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803137:	0f b6 10             	movzbl (%rax),%edx
  80313a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80313d:	38 c2                	cmp    %al,%dl
  80313f:	75 02                	jne    803143 <memfind+0x34>
			break;
  803141:	eb 0f                	jmp    803152 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803143:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803148:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80314c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803150:	72 e1                	jb     803133 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803156:	c9                   	leaveq 
  803157:	c3                   	retq   

0000000000803158 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803158:	55                   	push   %rbp
  803159:	48 89 e5             	mov    %rsp,%rbp
  80315c:	48 83 ec 34          	sub    $0x34,%rsp
  803160:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803164:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803168:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80316b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803172:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803179:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80317a:	eb 05                	jmp    803181 <strtol+0x29>
		s++;
  80317c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803181:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803185:	0f b6 00             	movzbl (%rax),%eax
  803188:	3c 20                	cmp    $0x20,%al
  80318a:	74 f0                	je     80317c <strtol+0x24>
  80318c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803190:	0f b6 00             	movzbl (%rax),%eax
  803193:	3c 09                	cmp    $0x9,%al
  803195:	74 e5                	je     80317c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803197:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80319b:	0f b6 00             	movzbl (%rax),%eax
  80319e:	3c 2b                	cmp    $0x2b,%al
  8031a0:	75 07                	jne    8031a9 <strtol+0x51>
		s++;
  8031a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031a7:	eb 17                	jmp    8031c0 <strtol+0x68>
	else if (*s == '-')
  8031a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ad:	0f b6 00             	movzbl (%rax),%eax
  8031b0:	3c 2d                	cmp    $0x2d,%al
  8031b2:	75 0c                	jne    8031c0 <strtol+0x68>
		s++, neg = 1;
  8031b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031c4:	74 06                	je     8031cc <strtol+0x74>
  8031c6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031ca:	75 28                	jne    8031f4 <strtol+0x9c>
  8031cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d0:	0f b6 00             	movzbl (%rax),%eax
  8031d3:	3c 30                	cmp    $0x30,%al
  8031d5:	75 1d                	jne    8031f4 <strtol+0x9c>
  8031d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031db:	48 83 c0 01          	add    $0x1,%rax
  8031df:	0f b6 00             	movzbl (%rax),%eax
  8031e2:	3c 78                	cmp    $0x78,%al
  8031e4:	75 0e                	jne    8031f4 <strtol+0x9c>
		s += 2, base = 16;
  8031e6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031eb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031f2:	eb 2c                	jmp    803220 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031f8:	75 19                	jne    803213 <strtol+0xbb>
  8031fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fe:	0f b6 00             	movzbl (%rax),%eax
  803201:	3c 30                	cmp    $0x30,%al
  803203:	75 0e                	jne    803213 <strtol+0xbb>
		s++, base = 8;
  803205:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80320a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803211:	eb 0d                	jmp    803220 <strtol+0xc8>
	else if (base == 0)
  803213:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803217:	75 07                	jne    803220 <strtol+0xc8>
		base = 10;
  803219:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803224:	0f b6 00             	movzbl (%rax),%eax
  803227:	3c 2f                	cmp    $0x2f,%al
  803229:	7e 1d                	jle    803248 <strtol+0xf0>
  80322b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322f:	0f b6 00             	movzbl (%rax),%eax
  803232:	3c 39                	cmp    $0x39,%al
  803234:	7f 12                	jg     803248 <strtol+0xf0>
			dig = *s - '0';
  803236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323a:	0f b6 00             	movzbl (%rax),%eax
  80323d:	0f be c0             	movsbl %al,%eax
  803240:	83 e8 30             	sub    $0x30,%eax
  803243:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803246:	eb 4e                	jmp    803296 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803248:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324c:	0f b6 00             	movzbl (%rax),%eax
  80324f:	3c 60                	cmp    $0x60,%al
  803251:	7e 1d                	jle    803270 <strtol+0x118>
  803253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803257:	0f b6 00             	movzbl (%rax),%eax
  80325a:	3c 7a                	cmp    $0x7a,%al
  80325c:	7f 12                	jg     803270 <strtol+0x118>
			dig = *s - 'a' + 10;
  80325e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803262:	0f b6 00             	movzbl (%rax),%eax
  803265:	0f be c0             	movsbl %al,%eax
  803268:	83 e8 57             	sub    $0x57,%eax
  80326b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80326e:	eb 26                	jmp    803296 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803270:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803274:	0f b6 00             	movzbl (%rax),%eax
  803277:	3c 40                	cmp    $0x40,%al
  803279:	7e 48                	jle    8032c3 <strtol+0x16b>
  80327b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327f:	0f b6 00             	movzbl (%rax),%eax
  803282:	3c 5a                	cmp    $0x5a,%al
  803284:	7f 3d                	jg     8032c3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  803286:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80328a:	0f b6 00             	movzbl (%rax),%eax
  80328d:	0f be c0             	movsbl %al,%eax
  803290:	83 e8 37             	sub    $0x37,%eax
  803293:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803296:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803299:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80329c:	7c 02                	jl     8032a0 <strtol+0x148>
			break;
  80329e:	eb 23                	jmp    8032c3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8032a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8032a5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032a8:	48 98                	cltq   
  8032aa:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8032af:	48 89 c2             	mov    %rax,%rdx
  8032b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b5:	48 98                	cltq   
  8032b7:	48 01 d0             	add    %rdx,%rax
  8032ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032be:	e9 5d ff ff ff       	jmpq   803220 <strtol+0xc8>

	if (endptr)
  8032c3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032c8:	74 0b                	je     8032d5 <strtol+0x17d>
		*endptr = (char *) s;
  8032ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ce:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d9:	74 09                	je     8032e4 <strtol+0x18c>
  8032db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032df:	48 f7 d8             	neg    %rax
  8032e2:	eb 04                	jmp    8032e8 <strtol+0x190>
  8032e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032e8:	c9                   	leaveq 
  8032e9:	c3                   	retq   

00000000008032ea <strstr>:

char * strstr(const char *in, const char *str)
{
  8032ea:	55                   	push   %rbp
  8032eb:	48 89 e5             	mov    %rsp,%rbp
  8032ee:	48 83 ec 30          	sub    $0x30,%rsp
  8032f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8032fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803302:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803306:	0f b6 00             	movzbl (%rax),%eax
  803309:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80330c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803310:	75 06                	jne    803318 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803316:	eb 6b                	jmp    803383 <strstr+0x99>

	len = strlen(str);
  803318:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331c:	48 89 c7             	mov    %rax,%rdi
  80331f:	48 b8 c0 2b 80 00 00 	movabs $0x802bc0,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
  80332b:	48 98                	cltq   
  80332d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803331:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803335:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803339:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80333d:	0f b6 00             	movzbl (%rax),%eax
  803340:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803343:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803347:	75 07                	jne    803350 <strstr+0x66>
				return (char *) 0;
  803349:	b8 00 00 00 00       	mov    $0x0,%eax
  80334e:	eb 33                	jmp    803383 <strstr+0x99>
		} while (sc != c);
  803350:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803354:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803357:	75 d8                	jne    803331 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803359:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80335d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803365:	48 89 ce             	mov    %rcx,%rsi
  803368:	48 89 c7             	mov    %rax,%rdi
  80336b:	48 b8 e1 2d 80 00 00 	movabs $0x802de1,%rax
  803372:	00 00 00 
  803375:	ff d0                	callq  *%rax
  803377:	85 c0                	test   %eax,%eax
  803379:	75 b6                	jne    803331 <strstr+0x47>

	return (char *) (in - 1);
  80337b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337f:	48 83 e8 01          	sub    $0x1,%rax
}
  803383:	c9                   	leaveq 
  803384:	c3                   	retq   

0000000000803385 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803385:	55                   	push   %rbp
  803386:	48 89 e5             	mov    %rsp,%rbp
  803389:	48 83 ec 30          	sub    $0x30,%rsp
  80338d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803391:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803395:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803399:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80339e:	75 0e                	jne    8033ae <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033a7:	00 00 00 
  8033aa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b2:	48 89 c7             	mov    %rax,%rdi
  8033b5:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
  8033c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c8:	79 27                	jns    8033f1 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033cf:	74 0a                	je     8033db <ipc_recv+0x56>
            *from_env_store = 0;
  8033d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033e0:	74 0a                	je     8033ec <ipc_recv+0x67>
            *perm_store = 0;
  8033e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ef:	eb 53                	jmp    803444 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033f6:	74 19                	je     803411 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033f8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033ff:	00 00 00 
  803402:	48 8b 00             	mov    (%rax),%rax
  803405:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80340b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340f:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803411:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803416:	74 19                	je     803431 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803418:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80341f:	00 00 00 
  803422:	48 8b 00             	mov    (%rax),%rax
  803425:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80342b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80342f:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803431:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803438:	00 00 00 
  80343b:	48 8b 00             	mov    (%rax),%rax
  80343e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803444:	c9                   	leaveq 
  803445:	c3                   	retq   

0000000000803446 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803446:	55                   	push   %rbp
  803447:	48 89 e5             	mov    %rsp,%rbp
  80344a:	48 83 ec 30          	sub    $0x30,%rsp
  80344e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803451:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803454:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803458:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80345b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803460:	75 0e                	jne    803470 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803462:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803469:	00 00 00 
  80346c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803470:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803473:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803476:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80347a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80347d:	89 c7                	mov    %eax,%edi
  80347f:	48 b8 cd 04 80 00 00 	movabs $0x8004cd,%rax
  803486:	00 00 00 
  803489:	ff d0                	callq  *%rax
  80348b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  80348e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803492:	79 36                	jns    8034ca <ipc_send+0x84>
  803494:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803498:	74 30                	je     8034ca <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80349a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349d:	89 c1                	mov    %eax,%ecx
  80349f:	48 ba a8 3c 80 00 00 	movabs $0x803ca8,%rdx
  8034a6:	00 00 00 
  8034a9:	be 49 00 00 00       	mov    $0x49,%esi
  8034ae:	48 bf b5 3c 80 00 00 	movabs $0x803cb5,%rdi
  8034b5:	00 00 00 
  8034b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034bd:	49 b8 2b 1e 80 00 00 	movabs $0x801e2b,%r8
  8034c4:	00 00 00 
  8034c7:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034ca:	48 b8 bb 02 80 00 00 	movabs $0x8002bb,%rax
  8034d1:	00 00 00 
  8034d4:	ff d0                	callq  *%rax
    } while(r != 0);
  8034d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034da:	75 94                	jne    803470 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034dc:	c9                   	leaveq 
  8034dd:	c3                   	retq   

00000000008034de <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034de:	55                   	push   %rbp
  8034df:	48 89 e5             	mov    %rsp,%rbp
  8034e2:	48 83 ec 14          	sub    $0x14,%rsp
  8034e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034f0:	eb 5e                	jmp    803550 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034f2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034f9:	00 00 00 
  8034fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ff:	48 63 d0             	movslq %eax,%rdx
  803502:	48 89 d0             	mov    %rdx,%rax
  803505:	48 c1 e0 03          	shl    $0x3,%rax
  803509:	48 01 d0             	add    %rdx,%rax
  80350c:	48 c1 e0 05          	shl    $0x5,%rax
  803510:	48 01 c8             	add    %rcx,%rax
  803513:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803519:	8b 00                	mov    (%rax),%eax
  80351b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80351e:	75 2c                	jne    80354c <ipc_find_env+0x6e>
			return envs[i].env_id;
  803520:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803527:	00 00 00 
  80352a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352d:	48 63 d0             	movslq %eax,%rdx
  803530:	48 89 d0             	mov    %rdx,%rax
  803533:	48 c1 e0 03          	shl    $0x3,%rax
  803537:	48 01 d0             	add    %rdx,%rax
  80353a:	48 c1 e0 05          	shl    $0x5,%rax
  80353e:	48 01 c8             	add    %rcx,%rax
  803541:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803547:	8b 40 08             	mov    0x8(%rax),%eax
  80354a:	eb 12                	jmp    80355e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80354c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803550:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803557:	7e 99                	jle    8034f2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80355e:	c9                   	leaveq 
  80355f:	c3                   	retq   

0000000000803560 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803560:	55                   	push   %rbp
  803561:	48 89 e5             	mov    %rsp,%rbp
  803564:	48 83 ec 18          	sub    $0x18,%rsp
  803568:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80356c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803570:	48 c1 e8 15          	shr    $0x15,%rax
  803574:	48 89 c2             	mov    %rax,%rdx
  803577:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80357e:	01 00 00 
  803581:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803585:	83 e0 01             	and    $0x1,%eax
  803588:	48 85 c0             	test   %rax,%rax
  80358b:	75 07                	jne    803594 <pageref+0x34>
		return 0;
  80358d:	b8 00 00 00 00       	mov    $0x0,%eax
  803592:	eb 53                	jmp    8035e7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803598:	48 c1 e8 0c          	shr    $0xc,%rax
  80359c:	48 89 c2             	mov    %rax,%rdx
  80359f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035a6:	01 00 00 
  8035a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b5:	83 e0 01             	and    $0x1,%eax
  8035b8:	48 85 c0             	test   %rax,%rax
  8035bb:	75 07                	jne    8035c4 <pageref+0x64>
		return 0;
  8035bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c2:	eb 23                	jmp    8035e7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8035cc:	48 89 c2             	mov    %rax,%rdx
  8035cf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035d6:	00 00 00 
  8035d9:	48 c1 e2 04          	shl    $0x4,%rdx
  8035dd:	48 01 d0             	add    %rdx,%rax
  8035e0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035e4:	0f b7 c0             	movzwl %ax,%eax
}
  8035e7:	c9                   	leaveq 
  8035e8:	c3                   	retq   
