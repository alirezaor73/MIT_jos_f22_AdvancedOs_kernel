
obj/user/buggyhello2:     file format elf64-x86-64


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
  80003c:	e8 34 00 00 00       	callq  800075 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_cputs(hello, 1024*1024);
  800052:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	be 00 00 10 00       	mov    $0x100000,%esi
  800064:	48 89 c7             	mov    %rax,%rdi
  800067:	48 b8 b7 01 80 00 00 	movabs $0x8001b7,%rax
  80006e:	00 00 00 
  800071:	ff d0                	callq  *%rax
}
  800073:	c9                   	leaveq 
  800074:	c3                   	retq   

0000000000800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %rbp
  800076:	48 89 e5             	mov    %rsp,%rbp
  800079:	48 83 ec 20          	sub    $0x20,%rsp
  80007d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800080:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800084:	48 b8 83 02 80 00 00 	movabs $0x800283,%rax
  80008b:	00 00 00 
  80008e:	ff d0                	callq  *%rax
  800090:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800093:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800096:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009b:	48 63 d0             	movslq %eax,%rdx
  80009e:	48 89 d0             	mov    %rdx,%rax
  8000a1:	48 c1 e0 03          	shl    $0x3,%rax
  8000a5:	48 01 d0             	add    %rdx,%rax
  8000a8:	48 c1 e0 05          	shl    $0x5,%rax
  8000ac:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b3:	00 00 00 
  8000b6:	48 01 c2             	add    %rax,%rdx
  8000b9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c0:	00 00 00 
  8000c3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ca:	7e 14                	jle    8000e0 <libmain+0x6b>
		binaryname = argv[0];
  8000cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d0:	48 8b 10             	mov    (%rax),%rdx
  8000d3:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8000da:	00 00 00 
  8000dd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e7:	48 89 d6             	mov    %rdx,%rsi
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f8:	48 b8 06 01 80 00 00 	movabs $0x800106,%rax
  8000ff:	00 00 00 
  800102:	ff d0                	callq  *%rax
}
  800104:	c9                   	leaveq 
  800105:	c3                   	retq   

0000000000800106 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800106:	55                   	push   %rbp
  800107:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80010a:	48 b8 ad 08 80 00 00 	movabs $0x8008ad,%rax
  800111:	00 00 00 
  800114:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800116:	bf 00 00 00 00       	mov    $0x0,%edi
  80011b:	48 b8 3f 02 80 00 00 	movabs $0x80023f,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax
}
  800127:	5d                   	pop    %rbp
  800128:	c3                   	retq   

0000000000800129 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800129:	55                   	push   %rbp
  80012a:	48 89 e5             	mov    %rsp,%rbp
  80012d:	53                   	push   %rbx
  80012e:	48 83 ec 48          	sub    $0x48,%rsp
  800132:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800135:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800138:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80013c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800140:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800144:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800148:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80014f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800153:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800157:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80015f:	4c 89 c3             	mov    %r8,%rbx
  800162:	cd 30                	int    $0x30
  800164:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800168:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80016c:	74 3e                	je     8001ac <syscall+0x83>
  80016e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800173:	7e 37                	jle    8001ac <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800175:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800179:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80017c:	49 89 d0             	mov    %rdx,%r8
  80017f:	89 c1                	mov    %eax,%ecx
  800181:	48 ba 18 36 80 00 00 	movabs $0x803618,%rdx
  800188:	00 00 00 
  80018b:	be 23 00 00 00       	mov    $0x23,%esi
  800190:	48 bf 35 36 80 00 00 	movabs $0x803635,%rdi
  800197:	00 00 00 
  80019a:	b8 00 00 00 00       	mov    $0x0,%eax
  80019f:	49 b9 31 1e 80 00 00 	movabs $0x801e31,%r9
  8001a6:	00 00 00 
  8001a9:	41 ff d1             	callq  *%r9

	return ret;
  8001ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b0:	48 83 c4 48          	add    $0x48,%rsp
  8001b4:	5b                   	pop    %rbx
  8001b5:	5d                   	pop    %rbp
  8001b6:	c3                   	retq   

00000000008001b7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b7:	55                   	push   %rbp
  8001b8:	48 89 e5             	mov    %rsp,%rbp
  8001bb:	48 83 ec 20          	sub    $0x20,%rsp
  8001bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d6:	00 
  8001d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e3:	48 89 d1             	mov    %rdx,%rcx
  8001e6:	48 89 c2             	mov    %rax,%rdx
  8001e9:	be 00 00 00 00       	mov    $0x0,%esi
  8001ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f3:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  8001fa:	00 00 00 
  8001fd:	ff d0                	callq  *%rax
}
  8001ff:	c9                   	leaveq 
  800200:	c3                   	retq   

0000000000800201 <sys_cgetc>:

int
sys_cgetc(void)
{
  800201:	55                   	push   %rbp
  800202:	48 89 e5             	mov    %rsp,%rbp
  800205:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800209:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800210:	00 
  800211:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800217:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80021d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800222:	ba 00 00 00 00       	mov    $0x0,%edx
  800227:	be 00 00 00 00       	mov    $0x0,%esi
  80022c:	bf 01 00 00 00       	mov    $0x1,%edi
  800231:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  800238:	00 00 00 
  80023b:	ff d0                	callq  *%rax
}
  80023d:	c9                   	leaveq 
  80023e:	c3                   	retq   

000000000080023f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80023f:	55                   	push   %rbp
  800240:	48 89 e5             	mov    %rsp,%rbp
  800243:	48 83 ec 10          	sub    $0x10,%rsp
  800247:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80024a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80024d:	48 98                	cltq   
  80024f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800256:	00 
  800257:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80025d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800263:	b9 00 00 00 00       	mov    $0x0,%ecx
  800268:	48 89 c2             	mov    %rax,%rdx
  80026b:	be 01 00 00 00       	mov    $0x1,%esi
  800270:	bf 03 00 00 00       	mov    $0x3,%edi
  800275:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  80027c:	00 00 00 
  80027f:	ff d0                	callq  *%rax
}
  800281:	c9                   	leaveq 
  800282:	c3                   	retq   

0000000000800283 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800283:	55                   	push   %rbp
  800284:	48 89 e5             	mov    %rsp,%rbp
  800287:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800292:	00 
  800293:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800299:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80029f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a9:	be 00 00 00 00       	mov    $0x0,%esi
  8002ae:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b3:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
}
  8002bf:	c9                   	leaveq 
  8002c0:	c3                   	retq   

00000000008002c1 <sys_yield>:

void
sys_yield(void)
{
  8002c1:	55                   	push   %rbp
  8002c2:	48 89 e5             	mov    %rsp,%rbp
  8002c5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d0:	00 
  8002d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e7:	be 00 00 00 00       	mov    $0x0,%esi
  8002ec:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f1:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 20          	sub    $0x20,%rsp
  800307:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80030a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800311:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800314:	48 63 c8             	movslq %eax,%rcx
  800317:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031e:	48 98                	cltq   
  800320:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800327:	00 
  800328:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032e:	49 89 c8             	mov    %rcx,%r8
  800331:	48 89 d1             	mov    %rdx,%rcx
  800334:	48 89 c2             	mov    %rax,%rdx
  800337:	be 01 00 00 00       	mov    $0x1,%esi
  80033c:	bf 04 00 00 00       	mov    $0x4,%edi
  800341:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  800348:	00 00 00 
  80034b:	ff d0                	callq  *%rax
}
  80034d:	c9                   	leaveq 
  80034e:	c3                   	retq   

000000000080034f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80034f:	55                   	push   %rbp
  800350:	48 89 e5             	mov    %rsp,%rbp
  800353:	48 83 ec 30          	sub    $0x30,%rsp
  800357:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800361:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800365:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800369:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036c:	48 63 c8             	movslq %eax,%rcx
  80036f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800373:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800376:	48 63 f0             	movslq %eax,%rsi
  800379:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800380:	48 98                	cltq   
  800382:	48 89 0c 24          	mov    %rcx,(%rsp)
  800386:	49 89 f9             	mov    %rdi,%r9
  800389:	49 89 f0             	mov    %rsi,%r8
  80038c:	48 89 d1             	mov    %rdx,%rcx
  80038f:	48 89 c2             	mov    %rax,%rdx
  800392:	be 01 00 00 00       	mov    $0x1,%esi
  800397:	bf 05 00 00 00       	mov    $0x5,%edi
  80039c:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
}
  8003a8:	c9                   	leaveq 
  8003a9:	c3                   	retq   

00000000008003aa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003aa:	55                   	push   %rbp
  8003ab:	48 89 e5             	mov    %rsp,%rbp
  8003ae:	48 83 ec 20          	sub    $0x20,%rsp
  8003b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c0:	48 98                	cltq   
  8003c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c9:	00 
  8003ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d6:	48 89 d1             	mov    %rdx,%rcx
  8003d9:	48 89 c2             	mov    %rax,%rdx
  8003dc:	be 01 00 00 00       	mov    $0x1,%esi
  8003e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e6:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	callq  *%rax
}
  8003f2:	c9                   	leaveq 
  8003f3:	c3                   	retq   

00000000008003f4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f4:	55                   	push   %rbp
  8003f5:	48 89 e5             	mov    %rsp,%rbp
  8003f8:	48 83 ec 10          	sub    $0x10,%rsp
  8003fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ff:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800402:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800405:	48 63 d0             	movslq %eax,%rdx
  800408:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040b:	48 98                	cltq   
  80040d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800414:	00 
  800415:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800421:	48 89 d1             	mov    %rdx,%rcx
  800424:	48 89 c2             	mov    %rax,%rdx
  800427:	be 01 00 00 00       	mov    $0x1,%esi
  80042c:	bf 08 00 00 00       	mov    $0x8,%edi
  800431:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  800438:	00 00 00 
  80043b:	ff d0                	callq  *%rax
}
  80043d:	c9                   	leaveq 
  80043e:	c3                   	retq   

000000000080043f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80043f:	55                   	push   %rbp
  800440:	48 89 e5             	mov    %rsp,%rbp
  800443:	48 83 ec 20          	sub    $0x20,%rsp
  800447:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800455:	48 98                	cltq   
  800457:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045e:	00 
  80045f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800465:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046b:	48 89 d1             	mov    %rdx,%rcx
  80046e:	48 89 c2             	mov    %rax,%rdx
  800471:	be 01 00 00 00       	mov    $0x1,%esi
  800476:	bf 09 00 00 00       	mov    $0x9,%edi
  80047b:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  800482:	00 00 00 
  800485:	ff d0                	callq  *%rax
}
  800487:	c9                   	leaveq 
  800488:	c3                   	retq   

0000000000800489 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800489:	55                   	push   %rbp
  80048a:	48 89 e5             	mov    %rsp,%rbp
  80048d:	48 83 ec 20          	sub    $0x20,%rsp
  800491:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800494:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800498:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049f:	48 98                	cltq   
  8004a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a8:	00 
  8004a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b5:	48 89 d1             	mov    %rdx,%rcx
  8004b8:	48 89 c2             	mov    %rax,%rdx
  8004bb:	be 01 00 00 00       	mov    $0x1,%esi
  8004c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c5:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  8004cc:	00 00 00 
  8004cf:	ff d0                	callq  *%rax
}
  8004d1:	c9                   	leaveq 
  8004d2:	c3                   	retq   

00000000008004d3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d3:	55                   	push   %rbp
  8004d4:	48 89 e5             	mov    %rsp,%rbp
  8004d7:	48 83 ec 20          	sub    $0x20,%rsp
  8004db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ec:	48 63 f0             	movslq %eax,%rsi
  8004ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f6:	48 98                	cltq   
  8004f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800503:	00 
  800504:	49 89 f1             	mov    %rsi,%r9
  800507:	49 89 c8             	mov    %rcx,%r8
  80050a:	48 89 d1             	mov    %rdx,%rcx
  80050d:	48 89 c2             	mov    %rax,%rdx
  800510:	be 00 00 00 00       	mov    $0x0,%esi
  800515:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051a:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  800521:	00 00 00 
  800524:	ff d0                	callq  *%rax
}
  800526:	c9                   	leaveq 
  800527:	c3                   	retq   

0000000000800528 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800528:	55                   	push   %rbp
  800529:	48 89 e5             	mov    %rsp,%rbp
  80052c:	48 83 ec 10          	sub    $0x10,%rsp
  800530:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800538:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80053f:	00 
  800540:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800546:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80054c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800551:	48 89 c2             	mov    %rax,%rdx
  800554:	be 01 00 00 00       	mov    $0x1,%esi
  800559:	bf 0d 00 00 00       	mov    $0xd,%edi
  80055e:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  800565:	00 00 00 
  800568:	ff d0                	callq  *%rax
}
  80056a:	c9                   	leaveq 
  80056b:	c3                   	retq   

000000000080056c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80056c:	55                   	push   %rbp
  80056d:	48 89 e5             	mov    %rsp,%rbp
  800570:	48 83 ec 08          	sub    $0x8,%rsp
  800574:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800578:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800583:	ff ff ff 
  800586:	48 01 d0             	add    %rdx,%rax
  800589:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80058d:	c9                   	leaveq 
  80058e:	c3                   	retq   

000000000080058f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80058f:	55                   	push   %rbp
  800590:	48 89 e5             	mov    %rsp,%rbp
  800593:	48 83 ec 08          	sub    $0x8,%rsp
  800597:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80059b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80059f:	48 89 c7             	mov    %rax,%rdi
  8005a2:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  8005a9:	00 00 00 
  8005ac:	ff d0                	callq  *%rax
  8005ae:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005b4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005b8:	c9                   	leaveq 
  8005b9:	c3                   	retq   

00000000008005ba <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005ba:	55                   	push   %rbp
  8005bb:	48 89 e5             	mov    %rsp,%rbp
  8005be:	48 83 ec 18          	sub    $0x18,%rsp
  8005c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005cd:	eb 6b                	jmp    80063a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005d2:	48 98                	cltq   
  8005d4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005da:	48 c1 e0 0c          	shl    $0xc,%rax
  8005de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e6:	48 c1 e8 15          	shr    $0x15,%rax
  8005ea:	48 89 c2             	mov    %rax,%rdx
  8005ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005f4:	01 00 00 
  8005f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005fb:	83 e0 01             	and    $0x1,%eax
  8005fe:	48 85 c0             	test   %rax,%rax
  800601:	74 21                	je     800624 <fd_alloc+0x6a>
  800603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800607:	48 c1 e8 0c          	shr    $0xc,%rax
  80060b:	48 89 c2             	mov    %rax,%rdx
  80060e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800615:	01 00 00 
  800618:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80061c:	83 e0 01             	and    $0x1,%eax
  80061f:	48 85 c0             	test   %rax,%rax
  800622:	75 12                	jne    800636 <fd_alloc+0x7c>
			*fd_store = fd;
  800624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800628:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80062c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80062f:	b8 00 00 00 00       	mov    $0x0,%eax
  800634:	eb 1a                	jmp    800650 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800636:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80063a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80063e:	7e 8f                	jle    8005cf <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80064b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800650:	c9                   	leaveq 
  800651:	c3                   	retq   

0000000000800652 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800652:	55                   	push   %rbp
  800653:	48 89 e5             	mov    %rsp,%rbp
  800656:	48 83 ec 20          	sub    $0x20,%rsp
  80065a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80065d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800661:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800665:	78 06                	js     80066d <fd_lookup+0x1b>
  800667:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80066b:	7e 07                	jle    800674 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80066d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800672:	eb 6c                	jmp    8006e0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800674:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800677:	48 98                	cltq   
  800679:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80067f:	48 c1 e0 0c          	shl    $0xc,%rax
  800683:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80068b:	48 c1 e8 15          	shr    $0x15,%rax
  80068f:	48 89 c2             	mov    %rax,%rdx
  800692:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800699:	01 00 00 
  80069c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a0:	83 e0 01             	and    $0x1,%eax
  8006a3:	48 85 c0             	test   %rax,%rax
  8006a6:	74 21                	je     8006c9 <fd_lookup+0x77>
  8006a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8006b0:	48 89 c2             	mov    %rax,%rdx
  8006b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006ba:	01 00 00 
  8006bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006c1:	83 e0 01             	and    $0x1,%eax
  8006c4:	48 85 c0             	test   %rax,%rax
  8006c7:	75 07                	jne    8006d0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ce:	eb 10                	jmp    8006e0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006d8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006e0:	c9                   	leaveq 
  8006e1:	c3                   	retq   

00000000008006e2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006e2:	55                   	push   %rbp
  8006e3:	48 89 e5             	mov    %rsp,%rbp
  8006e6:	48 83 ec 30          	sub    $0x30,%rsp
  8006ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006ee:	89 f0                	mov    %esi,%eax
  8006f0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f7:	48 89 c7             	mov    %rax,%rdi
  8006fa:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80070a:	48 89 d6             	mov    %rdx,%rsi
  80070d:	89 c7                	mov    %eax,%edi
  80070f:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  800716:	00 00 00 
  800719:	ff d0                	callq  *%rax
  80071b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80071e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800722:	78 0a                	js     80072e <fd_close+0x4c>
	    || fd != fd2)
  800724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800728:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80072c:	74 12                	je     800740 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80072e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800732:	74 05                	je     800739 <fd_close+0x57>
  800734:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800737:	eb 05                	jmp    80073e <fd_close+0x5c>
  800739:	b8 00 00 00 00       	mov    $0x0,%eax
  80073e:	eb 69                	jmp    8007a9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800744:	8b 00                	mov    (%rax),%eax
  800746:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80074a:	48 89 d6             	mov    %rdx,%rsi
  80074d:	89 c7                	mov    %eax,%edi
  80074f:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  800756:	00 00 00 
  800759:	ff d0                	callq  *%rax
  80075b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80075e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800762:	78 2a                	js     80078e <fd_close+0xac>
		if (dev->dev_close)
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 40 20          	mov    0x20(%rax),%rax
  80076c:	48 85 c0             	test   %rax,%rax
  80076f:	74 16                	je     800787 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800775:	48 8b 40 20          	mov    0x20(%rax),%rax
  800779:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80077d:	48 89 d7             	mov    %rdx,%rdi
  800780:	ff d0                	callq  *%rax
  800782:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800785:	eb 07                	jmp    80078e <fd_close+0xac>
		else
			r = 0;
  800787:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80078e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800792:	48 89 c6             	mov    %rax,%rsi
  800795:	bf 00 00 00 00       	mov    $0x0,%edi
  80079a:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  8007a1:	00 00 00 
  8007a4:	ff d0                	callq  *%rax
	return r;
  8007a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007a9:	c9                   	leaveq 
  8007aa:	c3                   	retq   

00000000008007ab <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007ab:	55                   	push   %rbp
  8007ac:	48 89 e5             	mov    %rsp,%rbp
  8007af:	48 83 ec 20          	sub    $0x20,%rsp
  8007b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007c1:	eb 41                	jmp    800804 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007c3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007ca:	00 00 00 
  8007cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007d0:	48 63 d2             	movslq %edx,%rdx
  8007d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d7:	8b 00                	mov    (%rax),%eax
  8007d9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007dc:	75 22                	jne    800800 <dev_lookup+0x55>
			*dev = devtab[i];
  8007de:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e5:	00 00 00 
  8007e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007eb:	48 63 d2             	movslq %edx,%rdx
  8007ee:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007f6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fe:	eb 60                	jmp    800860 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800800:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800804:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80080b:	00 00 00 
  80080e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800811:	48 63 d2             	movslq %edx,%rdx
  800814:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800818:	48 85 c0             	test   %rax,%rax
  80081b:	75 a6                	jne    8007c3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80081d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800824:	00 00 00 
  800827:	48 8b 00             	mov    (%rax),%rax
  80082a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800830:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800833:	89 c6                	mov    %eax,%esi
  800835:	48 bf 48 36 80 00 00 	movabs $0x803648,%rdi
  80083c:	00 00 00 
  80083f:	b8 00 00 00 00       	mov    $0x0,%eax
  800844:	48 b9 6a 20 80 00 00 	movabs $0x80206a,%rcx
  80084b:	00 00 00 
  80084e:	ff d1                	callq  *%rcx
	*dev = 0;
  800850:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800854:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80085b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800860:	c9                   	leaveq 
  800861:	c3                   	retq   

0000000000800862 <close>:

int
close(int fdnum)
{
  800862:	55                   	push   %rbp
  800863:	48 89 e5             	mov    %rsp,%rbp
  800866:	48 83 ec 20          	sub    $0x20,%rsp
  80086a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80086d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800871:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800874:	48 89 d6             	mov    %rdx,%rsi
  800877:	89 c7                	mov    %eax,%edi
  800879:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  800880:	00 00 00 
  800883:	ff d0                	callq  *%rax
  800885:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800888:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80088c:	79 05                	jns    800893 <close+0x31>
		return r;
  80088e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800891:	eb 18                	jmp    8008ab <close+0x49>
	else
		return fd_close(fd, 1);
  800893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800897:	be 01 00 00 00       	mov    $0x1,%esi
  80089c:	48 89 c7             	mov    %rax,%rdi
  80089f:	48 b8 e2 06 80 00 00 	movabs $0x8006e2,%rax
  8008a6:	00 00 00 
  8008a9:	ff d0                	callq  *%rax
}
  8008ab:	c9                   	leaveq 
  8008ac:	c3                   	retq   

00000000008008ad <close_all>:

void
close_all(void)
{
  8008ad:	55                   	push   %rbp
  8008ae:	48 89 e5             	mov    %rsp,%rbp
  8008b1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008bc:	eb 15                	jmp    8008d3 <close_all+0x26>
		close(i);
  8008be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008c1:	89 c7                	mov    %eax,%edi
  8008c3:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  8008ca:	00 00 00 
  8008cd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008d3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008d7:	7e e5                	jle    8008be <close_all+0x11>
		close(i);
}
  8008d9:	c9                   	leaveq 
  8008da:	c3                   	retq   

00000000008008db <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008db:	55                   	push   %rbp
  8008dc:	48 89 e5             	mov    %rsp,%rbp
  8008df:	48 83 ec 40          	sub    $0x40,%rsp
  8008e3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008e6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008e9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008ed:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008f0:	48 89 d6             	mov    %rdx,%rsi
  8008f3:	89 c7                	mov    %eax,%edi
  8008f5:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  8008fc:	00 00 00 
  8008ff:	ff d0                	callq  *%rax
  800901:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800904:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800908:	79 08                	jns    800912 <dup+0x37>
		return r;
  80090a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80090d:	e9 70 01 00 00       	jmpq   800a82 <dup+0x1a7>
	close(newfdnum);
  800912:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800915:	89 c7                	mov    %eax,%edi
  800917:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  80091e:	00 00 00 
  800921:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800923:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800926:	48 98                	cltq   
  800928:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80092e:	48 c1 e0 0c          	shl    $0xc,%rax
  800932:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093a:	48 89 c7             	mov    %rax,%rdi
  80093d:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  800944:	00 00 00 
  800947:	ff d0                	callq  *%rax
  800949:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80094d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800951:	48 89 c7             	mov    %rax,%rdi
  800954:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  80095b:	00 00 00 
  80095e:	ff d0                	callq  *%rax
  800960:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	48 c1 e8 15          	shr    $0x15,%rax
  80096c:	48 89 c2             	mov    %rax,%rdx
  80096f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800976:	01 00 00 
  800979:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80097d:	83 e0 01             	and    $0x1,%eax
  800980:	48 85 c0             	test   %rax,%rax
  800983:	74 73                	je     8009f8 <dup+0x11d>
  800985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800989:	48 c1 e8 0c          	shr    $0xc,%rax
  80098d:	48 89 c2             	mov    %rax,%rdx
  800990:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800997:	01 00 00 
  80099a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80099e:	83 e0 01             	and    $0x1,%eax
  8009a1:	48 85 c0             	test   %rax,%rax
  8009a4:	74 52                	je     8009f8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8009ae:	48 89 c2             	mov    %rax,%rdx
  8009b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b8:	01 00 00 
  8009bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8009c4:	89 c1                	mov    %eax,%ecx
  8009c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ce:	41 89 c8             	mov    %ecx,%r8d
  8009d1:	48 89 d1             	mov    %rdx,%rcx
  8009d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d9:	48 89 c6             	mov    %rax,%rsi
  8009dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e1:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  8009e8:	00 00 00 
  8009eb:	ff d0                	callq  *%rax
  8009ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009f4:	79 02                	jns    8009f8 <dup+0x11d>
			goto err;
  8009f6:	eb 57                	jmp    800a4f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009fc:	48 c1 e8 0c          	shr    $0xc,%rax
  800a00:	48 89 c2             	mov    %rax,%rdx
  800a03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a0a:	01 00 00 
  800a0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a11:	25 07 0e 00 00       	and    $0xe07,%eax
  800a16:	89 c1                	mov    %eax,%ecx
  800a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a20:	41 89 c8             	mov    %ecx,%r8d
  800a23:	48 89 d1             	mov    %rdx,%rcx
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	48 89 c6             	mov    %rax,%rsi
  800a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a33:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  800a3a:	00 00 00 
  800a3d:	ff d0                	callq  *%rax
  800a3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a46:	79 02                	jns    800a4a <dup+0x16f>
		goto err;
  800a48:	eb 05                	jmp    800a4f <dup+0x174>

	return newfdnum;
  800a4a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a4d:	eb 33                	jmp    800a82 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a53:	48 89 c6             	mov    %rax,%rsi
  800a56:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5b:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  800a62:	00 00 00 
  800a65:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a6b:	48 89 c6             	mov    %rax,%rsi
  800a6e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a73:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  800a7a:	00 00 00 
  800a7d:	ff d0                	callq  *%rax
	return r;
  800a7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a82:	c9                   	leaveq 
  800a83:	c3                   	retq   

0000000000800a84 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a84:	55                   	push   %rbp
  800a85:	48 89 e5             	mov    %rsp,%rbp
  800a88:	48 83 ec 40          	sub    $0x40,%rsp
  800a8c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a8f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a93:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a97:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a9b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a9e:	48 89 d6             	mov    %rdx,%rsi
  800aa1:	89 c7                	mov    %eax,%edi
  800aa3:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  800aaa:	00 00 00 
  800aad:	ff d0                	callq  *%rax
  800aaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ab6:	78 24                	js     800adc <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abc:	8b 00                	mov    (%rax),%eax
  800abe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ac2:	48 89 d6             	mov    %rdx,%rsi
  800ac5:	89 c7                	mov    %eax,%edi
  800ac7:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  800ace:	00 00 00 
  800ad1:	ff d0                	callq  *%rax
  800ad3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ada:	79 05                	jns    800ae1 <read+0x5d>
		return r;
  800adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800adf:	eb 76                	jmp    800b57 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae5:	8b 40 08             	mov    0x8(%rax),%eax
  800ae8:	83 e0 03             	and    $0x3,%eax
  800aeb:	83 f8 01             	cmp    $0x1,%eax
  800aee:	75 3a                	jne    800b2a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800af0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800af7:	00 00 00 
  800afa:	48 8b 00             	mov    (%rax),%rax
  800afd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b03:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b06:	89 c6                	mov    %eax,%esi
  800b08:	48 bf 67 36 80 00 00 	movabs $0x803667,%rdi
  800b0f:	00 00 00 
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
  800b17:	48 b9 6a 20 80 00 00 	movabs $0x80206a,%rcx
  800b1e:	00 00 00 
  800b21:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b28:	eb 2d                	jmp    800b57 <read+0xd3>
	}
	if (!dev->dev_read)
  800b2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b2e:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b32:	48 85 c0             	test   %rax,%rax
  800b35:	75 07                	jne    800b3e <read+0xba>
		return -E_NOT_SUPP;
  800b37:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b3c:	eb 19                	jmp    800b57 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b42:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b46:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b4a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b52:	48 89 cf             	mov    %rcx,%rdi
  800b55:	ff d0                	callq  *%rax
}
  800b57:	c9                   	leaveq 
  800b58:	c3                   	retq   

0000000000800b59 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b59:	55                   	push   %rbp
  800b5a:	48 89 e5             	mov    %rsp,%rbp
  800b5d:	48 83 ec 30          	sub    $0x30,%rsp
  800b61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b73:	eb 49                	jmp    800bbe <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b78:	48 98                	cltq   
  800b7a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b7e:	48 29 c2             	sub    %rax,%rdx
  800b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b84:	48 63 c8             	movslq %eax,%rcx
  800b87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b8b:	48 01 c1             	add    %rax,%rcx
  800b8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b91:	48 89 ce             	mov    %rcx,%rsi
  800b94:	89 c7                	mov    %eax,%edi
  800b96:	48 b8 84 0a 80 00 00 	movabs $0x800a84,%rax
  800b9d:	00 00 00 
  800ba0:	ff d0                	callq  *%rax
  800ba2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800ba5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ba9:	79 05                	jns    800bb0 <readn+0x57>
			return m;
  800bab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bae:	eb 1c                	jmp    800bcc <readn+0x73>
		if (m == 0)
  800bb0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bb4:	75 02                	jne    800bb8 <readn+0x5f>
			break;
  800bb6:	eb 11                	jmp    800bc9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bb8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bbb:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bc1:	48 98                	cltq   
  800bc3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bc7:	72 ac                	jb     800b75 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bcc:	c9                   	leaveq 
  800bcd:	c3                   	retq   

0000000000800bce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bce:	55                   	push   %rbp
  800bcf:	48 89 e5             	mov    %rsp,%rbp
  800bd2:	48 83 ec 40          	sub    $0x40,%rsp
  800bd6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bd9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bdd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800be1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800be5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800be8:	48 89 d6             	mov    %rdx,%rsi
  800beb:	89 c7                	mov    %eax,%edi
  800bed:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  800bf4:	00 00 00 
  800bf7:	ff d0                	callq  *%rax
  800bf9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c00:	78 24                	js     800c26 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c06:	8b 00                	mov    (%rax),%eax
  800c08:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c0c:	48 89 d6             	mov    %rdx,%rsi
  800c0f:	89 c7                	mov    %eax,%edi
  800c11:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  800c18:	00 00 00 
  800c1b:	ff d0                	callq  *%rax
  800c1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c24:	79 05                	jns    800c2b <write+0x5d>
		return r;
  800c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c29:	eb 75                	jmp    800ca0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2f:	8b 40 08             	mov    0x8(%rax),%eax
  800c32:	83 e0 03             	and    $0x3,%eax
  800c35:	85 c0                	test   %eax,%eax
  800c37:	75 3a                	jne    800c73 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c39:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c40:	00 00 00 
  800c43:	48 8b 00             	mov    (%rax),%rax
  800c46:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c4c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c4f:	89 c6                	mov    %eax,%esi
  800c51:	48 bf 83 36 80 00 00 	movabs $0x803683,%rdi
  800c58:	00 00 00 
  800c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c60:	48 b9 6a 20 80 00 00 	movabs $0x80206a,%rcx
  800c67:	00 00 00 
  800c6a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c71:	eb 2d                	jmp    800ca0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c77:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c7b:	48 85 c0             	test   %rax,%rax
  800c7e:	75 07                	jne    800c87 <write+0xb9>
		return -E_NOT_SUPP;
  800c80:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c85:	eb 19                	jmp    800ca0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c8f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c93:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c97:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c9b:	48 89 cf             	mov    %rcx,%rdi
  800c9e:	ff d0                	callq  *%rax
}
  800ca0:	c9                   	leaveq 
  800ca1:	c3                   	retq   

0000000000800ca2 <seek>:

int
seek(int fdnum, off_t offset)
{
  800ca2:	55                   	push   %rbp
  800ca3:	48 89 e5             	mov    %rsp,%rbp
  800ca6:	48 83 ec 18          	sub    $0x18,%rsp
  800caa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cb0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cb7:	48 89 d6             	mov    %rdx,%rsi
  800cba:	89 c7                	mov    %eax,%edi
  800cbc:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  800cc3:	00 00 00 
  800cc6:	ff d0                	callq  *%rax
  800cc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ccb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ccf:	79 05                	jns    800cd6 <seek+0x34>
		return r;
  800cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd4:	eb 0f                	jmp    800ce5 <seek+0x43>
	fd->fd_offset = offset;
  800cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cda:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cdd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce5:	c9                   	leaveq 
  800ce6:	c3                   	retq   

0000000000800ce7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800ce7:	55                   	push   %rbp
  800ce8:	48 89 e5             	mov    %rsp,%rbp
  800ceb:	48 83 ec 30          	sub    $0x30,%rsp
  800cef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cf2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cf9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cfc:	48 89 d6             	mov    %rdx,%rsi
  800cff:	89 c7                	mov    %eax,%edi
  800d01:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  800d08:	00 00 00 
  800d0b:	ff d0                	callq  *%rax
  800d0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d14:	78 24                	js     800d3a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1a:	8b 00                	mov    (%rax),%eax
  800d1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d20:	48 89 d6             	mov    %rdx,%rsi
  800d23:	89 c7                	mov    %eax,%edi
  800d25:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  800d2c:	00 00 00 
  800d2f:	ff d0                	callq  *%rax
  800d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d38:	79 05                	jns    800d3f <ftruncate+0x58>
		return r;
  800d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d3d:	eb 72                	jmp    800db1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d43:	8b 40 08             	mov    0x8(%rax),%eax
  800d46:	83 e0 03             	and    $0x3,%eax
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	75 3a                	jne    800d87 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d4d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d54:	00 00 00 
  800d57:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d60:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d63:	89 c6                	mov    %eax,%esi
  800d65:	48 bf a0 36 80 00 00 	movabs $0x8036a0,%rdi
  800d6c:	00 00 00 
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d74:	48 b9 6a 20 80 00 00 	movabs $0x80206a,%rcx
  800d7b:	00 00 00 
  800d7e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d85:	eb 2a                	jmp    800db1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d8f:	48 85 c0             	test   %rax,%rax
  800d92:	75 07                	jne    800d9b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d94:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d99:	eb 16                	jmp    800db1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d9f:	48 8b 40 30          	mov    0x30(%rax),%rax
  800da3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800daa:	89 ce                	mov    %ecx,%esi
  800dac:	48 89 d7             	mov    %rdx,%rdi
  800daf:	ff d0                	callq  *%rax
}
  800db1:	c9                   	leaveq 
  800db2:	c3                   	retq   

0000000000800db3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800db3:	55                   	push   %rbp
  800db4:	48 89 e5             	mov    %rsp,%rbp
  800db7:	48 83 ec 30          	sub    $0x30,%rsp
  800dbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dbe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dc2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dc9:	48 89 d6             	mov    %rdx,%rsi
  800dcc:	89 c7                	mov    %eax,%edi
  800dce:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  800dd5:	00 00 00 
  800dd8:	ff d0                	callq  *%rax
  800dda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ddd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de1:	78 24                	js     800e07 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de7:	8b 00                	mov    (%rax),%eax
  800de9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ded:	48 89 d6             	mov    %rdx,%rsi
  800df0:	89 c7                	mov    %eax,%edi
  800df2:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	callq  *%rax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e05:	79 05                	jns    800e0c <fstat+0x59>
		return r;
  800e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e0a:	eb 5e                	jmp    800e6a <fstat+0xb7>
	if (!dev->dev_stat)
  800e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e10:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e14:	48 85 c0             	test   %rax,%rax
  800e17:	75 07                	jne    800e20 <fstat+0x6d>
		return -E_NOT_SUPP;
  800e19:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e1e:	eb 4a                	jmp    800e6a <fstat+0xb7>
	stat->st_name[0] = 0;
  800e20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e24:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e32:	00 00 00 
	stat->st_isdir = 0;
  800e35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e40:	00 00 00 
	stat->st_dev = dev;
  800e43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e4b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e56:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e62:	48 89 ce             	mov    %rcx,%rsi
  800e65:	48 89 d7             	mov    %rdx,%rdi
  800e68:	ff d0                	callq  *%rax
}
  800e6a:	c9                   	leaveq 
  800e6b:	c3                   	retq   

0000000000800e6c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e6c:	55                   	push   %rbp
  800e6d:	48 89 e5             	mov    %rsp,%rbp
  800e70:	48 83 ec 20          	sub    $0x20,%rsp
  800e74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e80:	be 00 00 00 00       	mov    $0x0,%esi
  800e85:	48 89 c7             	mov    %rax,%rdi
  800e88:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  800e8f:	00 00 00 
  800e92:	ff d0                	callq  *%rax
  800e94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e9b:	79 05                	jns    800ea2 <stat+0x36>
		return fd;
  800e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea0:	eb 2f                	jmp    800ed1 <stat+0x65>
	r = fstat(fd, stat);
  800ea2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea9:	48 89 d6             	mov    %rdx,%rsi
  800eac:	89 c7                	mov    %eax,%edi
  800eae:	48 b8 b3 0d 80 00 00 	movabs $0x800db3,%rax
  800eb5:	00 00 00 
  800eb8:	ff d0                	callq  *%rax
  800eba:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec0:	89 c7                	mov    %eax,%edi
  800ec2:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800ec9:	00 00 00 
  800ecc:	ff d0                	callq  *%rax
	return r;
  800ece:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ed1:	c9                   	leaveq 
  800ed2:	c3                   	retq   

0000000000800ed3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ed3:	55                   	push   %rbp
  800ed4:	48 89 e5             	mov    %rsp,%rbp
  800ed7:	48 83 ec 10          	sub    $0x10,%rsp
  800edb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ede:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ee2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ee9:	00 00 00 
  800eec:	8b 00                	mov    (%rax),%eax
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	75 1d                	jne    800f0f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ef2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ef7:	48 b8 e4 34 80 00 00 	movabs $0x8034e4,%rax
  800efe:	00 00 00 
  800f01:	ff d0                	callq  *%rax
  800f03:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f0a:	00 00 00 
  800f0d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f0f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f16:	00 00 00 
  800f19:	8b 00                	mov    (%rax),%eax
  800f1b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f1e:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f23:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f2a:	00 00 00 
  800f2d:	89 c7                	mov    %eax,%edi
  800f2f:	48 b8 4c 34 80 00 00 	movabs $0x80344c,%rax
  800f36:	00 00 00 
  800f39:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f44:	48 89 c6             	mov    %rax,%rsi
  800f47:	bf 00 00 00 00       	mov    $0x0,%edi
  800f4c:	48 b8 8b 33 80 00 00 	movabs $0x80338b,%rax
  800f53:	00 00 00 
  800f56:	ff d0                	callq  *%rax
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 20          	sub    $0x20,%rsp
  800f62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f66:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6d:	48 89 c7             	mov    %rax,%rdi
  800f70:	48 b8 c6 2b 80 00 00 	movabs $0x802bc6,%rax
  800f77:	00 00 00 
  800f7a:	ff d0                	callq  *%rax
  800f7c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f81:	7e 0a                	jle    800f8d <open+0x33>
		return -E_BAD_PATH;
  800f83:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f88:	e9 a5 00 00 00       	jmpq   801032 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f8d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f91:	48 89 c7             	mov    %rax,%rdi
  800f94:	48 b8 ba 05 80 00 00 	movabs $0x8005ba,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	callq  *%rax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa7:	79 08                	jns    800fb1 <open+0x57>
		return r;
  800fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fac:	e9 81 00 00 00       	jmpq   801032 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb5:	48 89 c6             	mov    %rax,%rsi
  800fb8:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fbf:	00 00 00 
  800fc2:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  800fc9:	00 00 00 
  800fcc:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fce:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fd5:	00 00 00 
  800fd8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fdb:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fe1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe5:	48 89 c6             	mov    %rax,%rsi
  800fe8:	bf 01 00 00 00       	mov    $0x1,%edi
  800fed:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  800ff4:	00 00 00 
  800ff7:	ff d0                	callq  *%rax
  800ff9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ffc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801000:	79 1d                	jns    80101f <open+0xc5>
		fd_close(fd, 0);
  801002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801006:	be 00 00 00 00       	mov    $0x0,%esi
  80100b:	48 89 c7             	mov    %rax,%rdi
  80100e:	48 b8 e2 06 80 00 00 	movabs $0x8006e2,%rax
  801015:	00 00 00 
  801018:	ff d0                	callq  *%rax
		return r;
  80101a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80101d:	eb 13                	jmp    801032 <open+0xd8>
	}

	return fd2num(fd);
  80101f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801023:	48 89 c7             	mov    %rax,%rdi
  801026:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  80102d:	00 00 00 
  801030:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  801032:	c9                   	leaveq 
  801033:	c3                   	retq   

0000000000801034 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801034:	55                   	push   %rbp
  801035:	48 89 e5             	mov    %rsp,%rbp
  801038:	48 83 ec 10          	sub    $0x10,%rsp
  80103c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801044:	8b 50 0c             	mov    0xc(%rax),%edx
  801047:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80104e:	00 00 00 
  801051:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801053:	be 00 00 00 00       	mov    $0x0,%esi
  801058:	bf 06 00 00 00       	mov    $0x6,%edi
  80105d:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  801064:	00 00 00 
  801067:	ff d0                	callq  *%rax
}
  801069:	c9                   	leaveq 
  80106a:	c3                   	retq   

000000000080106b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80106b:	55                   	push   %rbp
  80106c:	48 89 e5             	mov    %rsp,%rbp
  80106f:	48 83 ec 30          	sub    $0x30,%rsp
  801073:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801077:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80107b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80107f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801083:	8b 50 0c             	mov    0xc(%rax),%edx
  801086:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80108d:	00 00 00 
  801090:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801092:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801099:	00 00 00 
  80109c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010a0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010a4:	be 00 00 00 00       	mov    $0x0,%esi
  8010a9:	bf 03 00 00 00       	mov    $0x3,%edi
  8010ae:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  8010b5:	00 00 00 
  8010b8:	ff d0                	callq  *%rax
  8010ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c1:	79 08                	jns    8010cb <devfile_read+0x60>
		return r;
  8010c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c6:	e9 a4 00 00 00       	jmpq   80116f <devfile_read+0x104>
	assert(r <= n);
  8010cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ce:	48 98                	cltq   
  8010d0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010d4:	76 35                	jbe    80110b <devfile_read+0xa0>
  8010d6:	48 b9 cd 36 80 00 00 	movabs $0x8036cd,%rcx
  8010dd:	00 00 00 
  8010e0:	48 ba d4 36 80 00 00 	movabs $0x8036d4,%rdx
  8010e7:	00 00 00 
  8010ea:	be 84 00 00 00       	mov    $0x84,%esi
  8010ef:	48 bf e9 36 80 00 00 	movabs $0x8036e9,%rdi
  8010f6:	00 00 00 
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	49 b8 31 1e 80 00 00 	movabs $0x801e31,%r8
  801105:	00 00 00 
  801108:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80110b:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  801112:	7e 35                	jle    801149 <devfile_read+0xde>
  801114:	48 b9 f4 36 80 00 00 	movabs $0x8036f4,%rcx
  80111b:	00 00 00 
  80111e:	48 ba d4 36 80 00 00 	movabs $0x8036d4,%rdx
  801125:	00 00 00 
  801128:	be 85 00 00 00       	mov    $0x85,%esi
  80112d:	48 bf e9 36 80 00 00 	movabs $0x8036e9,%rdi
  801134:	00 00 00 
  801137:	b8 00 00 00 00       	mov    $0x0,%eax
  80113c:	49 b8 31 1e 80 00 00 	movabs $0x801e31,%r8
  801143:	00 00 00 
  801146:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80114c:	48 63 d0             	movslq %eax,%rdx
  80114f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801153:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80115a:	00 00 00 
  80115d:	48 89 c7             	mov    %rax,%rdi
  801160:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  801167:	00 00 00 
  80116a:	ff d0                	callq  *%rax
	return r;
  80116c:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80116f:	c9                   	leaveq 
  801170:	c3                   	retq   

0000000000801171 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801171:	55                   	push   %rbp
  801172:	48 89 e5             	mov    %rsp,%rbp
  801175:	48 83 ec 30          	sub    $0x30,%rsp
  801179:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801181:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	8b 50 0c             	mov    0xc(%rax),%edx
  80118c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801193:	00 00 00 
  801196:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801198:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80119f:	00 00 00 
  8011a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011a6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8011aa:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011b1:	00 
  8011b2:	76 35                	jbe    8011e9 <devfile_write+0x78>
  8011b4:	48 b9 00 37 80 00 00 	movabs $0x803700,%rcx
  8011bb:	00 00 00 
  8011be:	48 ba d4 36 80 00 00 	movabs $0x8036d4,%rdx
  8011c5:	00 00 00 
  8011c8:	be 9e 00 00 00       	mov    $0x9e,%esi
  8011cd:	48 bf e9 36 80 00 00 	movabs $0x8036e9,%rdi
  8011d4:	00 00 00 
  8011d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011dc:	49 b8 31 1e 80 00 00 	movabs $0x801e31,%r8
  8011e3:	00 00 00 
  8011e6:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f1:	48 89 c6             	mov    %rax,%rsi
  8011f4:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011fb:	00 00 00 
  8011fe:	48 b8 6d 30 80 00 00 	movabs $0x80306d,%rax
  801205:	00 00 00 
  801208:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80120a:	be 00 00 00 00       	mov    $0x0,%esi
  80120f:	bf 04 00 00 00       	mov    $0x4,%edi
  801214:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  80121b:	00 00 00 
  80121e:	ff d0                	callq  *%rax
  801220:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801223:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801227:	79 05                	jns    80122e <devfile_write+0xbd>
		return r;
  801229:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80122c:	eb 43                	jmp    801271 <devfile_write+0x100>
	assert(r <= n);
  80122e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801231:	48 98                	cltq   
  801233:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801237:	76 35                	jbe    80126e <devfile_write+0xfd>
  801239:	48 b9 cd 36 80 00 00 	movabs $0x8036cd,%rcx
  801240:	00 00 00 
  801243:	48 ba d4 36 80 00 00 	movabs $0x8036d4,%rdx
  80124a:	00 00 00 
  80124d:	be a2 00 00 00       	mov    $0xa2,%esi
  801252:	48 bf e9 36 80 00 00 	movabs $0x8036e9,%rdi
  801259:	00 00 00 
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
  801261:	49 b8 31 1e 80 00 00 	movabs $0x801e31,%r8
  801268:	00 00 00 
  80126b:	41 ff d0             	callq  *%r8
	return r;
  80126e:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801271:	c9                   	leaveq 
  801272:	c3                   	retq   

0000000000801273 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801273:	55                   	push   %rbp
  801274:	48 89 e5             	mov    %rsp,%rbp
  801277:	48 83 ec 20          	sub    $0x20,%rsp
  80127b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801287:	8b 50 0c             	mov    0xc(%rax),%edx
  80128a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801291:	00 00 00 
  801294:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801296:	be 00 00 00 00       	mov    $0x0,%esi
  80129b:	bf 05 00 00 00       	mov    $0x5,%edi
  8012a0:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  8012a7:	00 00 00 
  8012aa:	ff d0                	callq  *%rax
  8012ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012b3:	79 05                	jns    8012ba <devfile_stat+0x47>
		return r;
  8012b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012b8:	eb 56                	jmp    801310 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012be:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8012c5:	00 00 00 
  8012c8:	48 89 c7             	mov    %rax,%rdi
  8012cb:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8012d2:	00 00 00 
  8012d5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012d7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012de:	00 00 00 
  8012e1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012eb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012f1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012f8:	00 00 00 
  8012fb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801301:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801305:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801310:	c9                   	leaveq 
  801311:	c3                   	retq   

0000000000801312 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801312:	55                   	push   %rbp
  801313:	48 89 e5             	mov    %rsp,%rbp
  801316:	48 83 ec 10          	sub    $0x10,%rsp
  80131a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801325:	8b 50 0c             	mov    0xc(%rax),%edx
  801328:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80132f:	00 00 00 
  801332:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801334:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80133b:	00 00 00 
  80133e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801341:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801344:	be 00 00 00 00       	mov    $0x0,%esi
  801349:	bf 02 00 00 00       	mov    $0x2,%edi
  80134e:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  801355:	00 00 00 
  801358:	ff d0                	callq  *%rax
}
  80135a:	c9                   	leaveq 
  80135b:	c3                   	retq   

000000000080135c <remove>:

// Delete a file
int
remove(const char *path)
{
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	48 83 ec 10          	sub    $0x10,%rsp
  801364:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	48 89 c7             	mov    %rax,%rdi
  80136f:	48 b8 c6 2b 80 00 00 	movabs $0x802bc6,%rax
  801376:	00 00 00 
  801379:	ff d0                	callq  *%rax
  80137b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801380:	7e 07                	jle    801389 <remove+0x2d>
		return -E_BAD_PATH;
  801382:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801387:	eb 33                	jmp    8013bc <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138d:	48 89 c6             	mov    %rax,%rsi
  801390:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801397:	00 00 00 
  80139a:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8013a1:	00 00 00 
  8013a4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8013a6:	be 00 00 00 00       	mov    $0x0,%esi
  8013ab:	bf 07 00 00 00       	mov    $0x7,%edi
  8013b0:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  8013b7:	00 00 00 
  8013ba:	ff d0                	callq  *%rax
}
  8013bc:	c9                   	leaveq 
  8013bd:	c3                   	retq   

00000000008013be <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013be:	55                   	push   %rbp
  8013bf:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8013c2:	be 00 00 00 00       	mov    $0x0,%esi
  8013c7:	bf 08 00 00 00       	mov    $0x8,%edi
  8013cc:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  8013d3:	00 00 00 
  8013d6:	ff d0                	callq  *%rax
}
  8013d8:	5d                   	pop    %rbp
  8013d9:	c3                   	retq   

00000000008013da <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8013da:	55                   	push   %rbp
  8013db:	48 89 e5             	mov    %rsp,%rbp
  8013de:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8013e5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8013ec:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8013f3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8013fa:	be 00 00 00 00       	mov    $0x0,%esi
  8013ff:	48 89 c7             	mov    %rax,%rdi
  801402:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  801409:	00 00 00 
  80140c:	ff d0                	callq  *%rax
  80140e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801411:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801415:	79 28                	jns    80143f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141a:	89 c6                	mov    %eax,%esi
  80141c:	48 bf 2d 37 80 00 00 	movabs $0x80372d,%rdi
  801423:	00 00 00 
  801426:	b8 00 00 00 00       	mov    $0x0,%eax
  80142b:	48 ba 6a 20 80 00 00 	movabs $0x80206a,%rdx
  801432:	00 00 00 
  801435:	ff d2                	callq  *%rdx
		return fd_src;
  801437:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80143a:	e9 74 01 00 00       	jmpq   8015b3 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80143f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801446:	be 01 01 00 00       	mov    $0x101,%esi
  80144b:	48 89 c7             	mov    %rax,%rdi
  80144e:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  801455:	00 00 00 
  801458:	ff d0                	callq  *%rax
  80145a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80145d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801461:	79 39                	jns    80149c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801463:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801466:	89 c6                	mov    %eax,%esi
  801468:	48 bf 43 37 80 00 00 	movabs $0x803743,%rdi
  80146f:	00 00 00 
  801472:	b8 00 00 00 00       	mov    $0x0,%eax
  801477:	48 ba 6a 20 80 00 00 	movabs $0x80206a,%rdx
  80147e:	00 00 00 
  801481:	ff d2                	callq  *%rdx
		close(fd_src);
  801483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801486:	89 c7                	mov    %eax,%edi
  801488:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  80148f:	00 00 00 
  801492:	ff d0                	callq  *%rax
		return fd_dest;
  801494:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801497:	e9 17 01 00 00       	jmpq   8015b3 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80149c:	eb 74                	jmp    801512 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80149e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a1:	48 63 d0             	movslq %eax,%rdx
  8014a4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014ae:	48 89 ce             	mov    %rcx,%rsi
  8014b1:	89 c7                	mov    %eax,%edi
  8014b3:	48 b8 ce 0b 80 00 00 	movabs $0x800bce,%rax
  8014ba:	00 00 00 
  8014bd:	ff d0                	callq  *%rax
  8014bf:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8014c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014c6:	79 4a                	jns    801512 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8014c8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014cb:	89 c6                	mov    %eax,%esi
  8014cd:	48 bf 5d 37 80 00 00 	movabs $0x80375d,%rdi
  8014d4:	00 00 00 
  8014d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dc:	48 ba 6a 20 80 00 00 	movabs $0x80206a,%rdx
  8014e3:	00 00 00 
  8014e6:	ff d2                	callq  *%rdx
			close(fd_src);
  8014e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014eb:	89 c7                	mov    %eax,%edi
  8014ed:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  8014f4:	00 00 00 
  8014f7:	ff d0                	callq  *%rax
			close(fd_dest);
  8014f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014fc:	89 c7                	mov    %eax,%edi
  8014fe:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  801505:	00 00 00 
  801508:	ff d0                	callq  *%rax
			return write_size;
  80150a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80150d:	e9 a1 00 00 00       	jmpq   8015b3 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801512:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80151c:	ba 00 02 00 00       	mov    $0x200,%edx
  801521:	48 89 ce             	mov    %rcx,%rsi
  801524:	89 c7                	mov    %eax,%edi
  801526:	48 b8 84 0a 80 00 00 	movabs $0x800a84,%rax
  80152d:	00 00 00 
  801530:	ff d0                	callq  *%rax
  801532:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801535:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801539:	0f 8f 5f ff ff ff    	jg     80149e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80153f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801543:	79 47                	jns    80158c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801545:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801548:	89 c6                	mov    %eax,%esi
  80154a:	48 bf 70 37 80 00 00 	movabs $0x803770,%rdi
  801551:	00 00 00 
  801554:	b8 00 00 00 00       	mov    $0x0,%eax
  801559:	48 ba 6a 20 80 00 00 	movabs $0x80206a,%rdx
  801560:	00 00 00 
  801563:	ff d2                	callq  *%rdx
		close(fd_src);
  801565:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801568:	89 c7                	mov    %eax,%edi
  80156a:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  801571:	00 00 00 
  801574:	ff d0                	callq  *%rax
		close(fd_dest);
  801576:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801579:	89 c7                	mov    %eax,%edi
  80157b:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  801582:	00 00 00 
  801585:	ff d0                	callq  *%rax
		return read_size;
  801587:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80158a:	eb 27                	jmp    8015b3 <copy+0x1d9>
	}
	close(fd_src);
  80158c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80158f:	89 c7                	mov    %eax,%edi
  801591:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  801598:	00 00 00 
  80159b:	ff d0                	callq  *%rax
	close(fd_dest);
  80159d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015a0:	89 c7                	mov    %eax,%edi
  8015a2:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  8015a9:	00 00 00 
  8015ac:	ff d0                	callq  *%rax
	return 0;
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015b3:	c9                   	leaveq 
  8015b4:	c3                   	retq   

00000000008015b5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015b5:	55                   	push   %rbp
  8015b6:	48 89 e5             	mov    %rsp,%rbp
  8015b9:	53                   	push   %rbx
  8015ba:	48 83 ec 38          	sub    $0x38,%rsp
  8015be:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015c2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8015c6:	48 89 c7             	mov    %rax,%rdi
  8015c9:	48 b8 ba 05 80 00 00 	movabs $0x8005ba,%rax
  8015d0:	00 00 00 
  8015d3:	ff d0                	callq  *%rax
  8015d5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015dc:	0f 88 bf 01 00 00    	js     8017a1 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	ba 07 04 00 00       	mov    $0x407,%edx
  8015eb:	48 89 c6             	mov    %rax,%rsi
  8015ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8015f3:	48 b8 ff 02 80 00 00 	movabs $0x8002ff,%rax
  8015fa:	00 00 00 
  8015fd:	ff d0                	callq  *%rax
  8015ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801602:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801606:	0f 88 95 01 00 00    	js     8017a1 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80160c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801610:	48 89 c7             	mov    %rax,%rdi
  801613:	48 b8 ba 05 80 00 00 	movabs $0x8005ba,%rax
  80161a:	00 00 00 
  80161d:	ff d0                	callq  *%rax
  80161f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801622:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801626:	0f 88 5d 01 00 00    	js     801789 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80162c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801630:	ba 07 04 00 00       	mov    $0x407,%edx
  801635:	48 89 c6             	mov    %rax,%rsi
  801638:	bf 00 00 00 00       	mov    $0x0,%edi
  80163d:	48 b8 ff 02 80 00 00 	movabs $0x8002ff,%rax
  801644:	00 00 00 
  801647:	ff d0                	callq  *%rax
  801649:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80164c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801650:	0f 88 33 01 00 00    	js     801789 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	48 89 c7             	mov    %rax,%rdi
  80165d:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  801664:	00 00 00 
  801667:	ff d0                	callq  *%rax
  801669:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80166d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801671:	ba 07 04 00 00       	mov    $0x407,%edx
  801676:	48 89 c6             	mov    %rax,%rsi
  801679:	bf 00 00 00 00       	mov    $0x0,%edi
  80167e:	48 b8 ff 02 80 00 00 	movabs $0x8002ff,%rax
  801685:	00 00 00 
  801688:	ff d0                	callq  *%rax
  80168a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801691:	79 05                	jns    801698 <pipe+0xe3>
		goto err2;
  801693:	e9 d9 00 00 00       	jmpq   801771 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801698:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80169c:	48 89 c7             	mov    %rax,%rdi
  80169f:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  8016a6:	00 00 00 
  8016a9:	ff d0                	callq  *%rax
  8016ab:	48 89 c2             	mov    %rax,%rdx
  8016ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8016b8:	48 89 d1             	mov    %rdx,%rcx
  8016bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c0:	48 89 c6             	mov    %rax,%rsi
  8016c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8016c8:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  8016cf:	00 00 00 
  8016d2:	ff d0                	callq  *%rax
  8016d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016db:	79 1b                	jns    8016f8 <pipe+0x143>
		goto err3;
  8016dd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8016de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016e2:	48 89 c6             	mov    %rax,%rsi
  8016e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ea:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  8016f1:	00 00 00 
  8016f4:	ff d0                	callq  *%rax
  8016f6:	eb 79                	jmp    801771 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fc:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801703:	00 00 00 
  801706:	8b 12                	mov    (%rdx),%edx
  801708:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801715:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801719:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801720:	00 00 00 
  801723:	8b 12                	mov    (%rdx),%edx
  801725:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801727:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801736:	48 89 c7             	mov    %rax,%rdi
  801739:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  801740:	00 00 00 
  801743:	ff d0                	callq  *%rax
  801745:	89 c2                	mov    %eax,%edx
  801747:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80174b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80174d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801751:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801755:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801759:	48 89 c7             	mov    %rax,%rdi
  80175c:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  801763:	00 00 00 
  801766:	ff d0                	callq  *%rax
  801768:	89 03                	mov    %eax,(%rbx)
	return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 33                	jmp    8017a4 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801771:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801775:	48 89 c6             	mov    %rax,%rsi
  801778:	bf 00 00 00 00       	mov    $0x0,%edi
  80177d:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  801784:	00 00 00 
  801787:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178d:	48 89 c6             	mov    %rax,%rsi
  801790:	bf 00 00 00 00       	mov    $0x0,%edi
  801795:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  80179c:	00 00 00 
  80179f:	ff d0                	callq  *%rax
err:
	return r;
  8017a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8017a4:	48 83 c4 38          	add    $0x38,%rsp
  8017a8:	5b                   	pop    %rbx
  8017a9:	5d                   	pop    %rbp
  8017aa:	c3                   	retq   

00000000008017ab <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017ab:	55                   	push   %rbp
  8017ac:	48 89 e5             	mov    %rsp,%rbp
  8017af:	53                   	push   %rbx
  8017b0:	48 83 ec 28          	sub    $0x28,%rsp
  8017b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017bc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017c3:	00 00 00 
  8017c6:	48 8b 00             	mov    (%rax),%rax
  8017c9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8017d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d6:	48 89 c7             	mov    %rax,%rdi
  8017d9:	48 b8 66 35 80 00 00 	movabs $0x803566,%rax
  8017e0:	00 00 00 
  8017e3:	ff d0                	callq  *%rax
  8017e5:	89 c3                	mov    %eax,%ebx
  8017e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017eb:	48 89 c7             	mov    %rax,%rdi
  8017ee:	48 b8 66 35 80 00 00 	movabs $0x803566,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
  8017fa:	39 c3                	cmp    %eax,%ebx
  8017fc:	0f 94 c0             	sete   %al
  8017ff:	0f b6 c0             	movzbl %al,%eax
  801802:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801805:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80180c:	00 00 00 
  80180f:	48 8b 00             	mov    (%rax),%rax
  801812:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801818:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80181b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80181e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801821:	75 05                	jne    801828 <_pipeisclosed+0x7d>
			return ret;
  801823:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801826:	eb 4f                	jmp    801877 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801828:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80182b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80182e:	74 42                	je     801872 <_pipeisclosed+0xc7>
  801830:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801834:	75 3c                	jne    801872 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801836:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80183d:	00 00 00 
  801840:	48 8b 00             	mov    (%rax),%rax
  801843:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801849:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80184c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80184f:	89 c6                	mov    %eax,%esi
  801851:	48 bf 8b 37 80 00 00 	movabs $0x80378b,%rdi
  801858:	00 00 00 
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
  801860:	49 b8 6a 20 80 00 00 	movabs $0x80206a,%r8
  801867:	00 00 00 
  80186a:	41 ff d0             	callq  *%r8
	}
  80186d:	e9 4a ff ff ff       	jmpq   8017bc <_pipeisclosed+0x11>
  801872:	e9 45 ff ff ff       	jmpq   8017bc <_pipeisclosed+0x11>
}
  801877:	48 83 c4 28          	add    $0x28,%rsp
  80187b:	5b                   	pop    %rbx
  80187c:	5d                   	pop    %rbp
  80187d:	c3                   	retq   

000000000080187e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80187e:	55                   	push   %rbp
  80187f:	48 89 e5             	mov    %rsp,%rbp
  801882:	48 83 ec 30          	sub    $0x30,%rsp
  801886:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801889:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80188d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801890:	48 89 d6             	mov    %rdx,%rsi
  801893:	89 c7                	mov    %eax,%edi
  801895:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  80189c:	00 00 00 
  80189f:	ff d0                	callq  *%rax
  8018a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a8:	79 05                	jns    8018af <pipeisclosed+0x31>
		return r;
  8018aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ad:	eb 31                	jmp    8018e0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8018af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b3:	48 89 c7             	mov    %rax,%rdi
  8018b6:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  8018bd:	00 00 00 
  8018c0:	ff d0                	callq  *%rax
  8018c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8018c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ce:	48 89 d6             	mov    %rdx,%rsi
  8018d1:	48 89 c7             	mov    %rax,%rdi
  8018d4:	48 b8 ab 17 80 00 00 	movabs $0x8017ab,%rax
  8018db:	00 00 00 
  8018de:	ff d0                	callq  *%rax
}
  8018e0:	c9                   	leaveq 
  8018e1:	c3                   	retq   

00000000008018e2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
  8018e6:	48 83 ec 40          	sub    $0x40,%rsp
  8018ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018f2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	48 89 c7             	mov    %rax,%rdi
  8018fd:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  801904:	00 00 00 
  801907:	ff d0                	callq  *%rax
  801909:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80190d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801911:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801915:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80191c:	00 
  80191d:	e9 92 00 00 00       	jmpq   8019b4 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801922:	eb 41                	jmp    801965 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801924:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801929:	74 09                	je     801934 <devpipe_read+0x52>
				return i;
  80192b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192f:	e9 92 00 00 00       	jmpq   8019c6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801934:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	48 89 d6             	mov    %rdx,%rsi
  80193f:	48 89 c7             	mov    %rax,%rdi
  801942:	48 b8 ab 17 80 00 00 	movabs $0x8017ab,%rax
  801949:	00 00 00 
  80194c:	ff d0                	callq  *%rax
  80194e:	85 c0                	test   %eax,%eax
  801950:	74 07                	je     801959 <devpipe_read+0x77>
				return 0;
  801952:	b8 00 00 00 00       	mov    $0x0,%eax
  801957:	eb 6d                	jmp    8019c6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801959:	48 b8 c1 02 80 00 00 	movabs $0x8002c1,%rax
  801960:	00 00 00 
  801963:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801969:	8b 10                	mov    (%rax),%edx
  80196b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80196f:	8b 40 04             	mov    0x4(%rax),%eax
  801972:	39 c2                	cmp    %eax,%edx
  801974:	74 ae                	je     801924 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801976:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80197e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801986:	8b 00                	mov    (%rax),%eax
  801988:	99                   	cltd   
  801989:	c1 ea 1b             	shr    $0x1b,%edx
  80198c:	01 d0                	add    %edx,%eax
  80198e:	83 e0 1f             	and    $0x1f,%eax
  801991:	29 d0                	sub    %edx,%eax
  801993:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801997:	48 98                	cltq   
  801999:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80199e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8019a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a4:	8b 00                	mov    (%rax),%eax
  8019a6:	8d 50 01             	lea    0x1(%rax),%edx
  8019a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ad:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019bc:	0f 82 60 ff ff ff    	jb     801922 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8019c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019c6:	c9                   	leaveq 
  8019c7:	c3                   	retq   

00000000008019c8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8019c8:	55                   	push   %rbp
  8019c9:	48 89 e5             	mov    %rsp,%rbp
  8019cc:	48 83 ec 40          	sub    $0x40,%rsp
  8019d0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8019dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e0:	48 89 c7             	mov    %rax,%rdi
  8019e3:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  8019ea:	00 00 00 
  8019ed:	ff d0                	callq  *%rax
  8019ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8019f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019f7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8019fb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a02:	00 
  801a03:	e9 8e 00 00 00       	jmpq   801a96 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a08:	eb 31                	jmp    801a3b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a12:	48 89 d6             	mov    %rdx,%rsi
  801a15:	48 89 c7             	mov    %rax,%rdi
  801a18:	48 b8 ab 17 80 00 00 	movabs $0x8017ab,%rax
  801a1f:	00 00 00 
  801a22:	ff d0                	callq  *%rax
  801a24:	85 c0                	test   %eax,%eax
  801a26:	74 07                	je     801a2f <devpipe_write+0x67>
				return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2d:	eb 79                	jmp    801aa8 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a2f:	48 b8 c1 02 80 00 00 	movabs $0x8002c1,%rax
  801a36:	00 00 00 
  801a39:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a3f:	8b 40 04             	mov    0x4(%rax),%eax
  801a42:	48 63 d0             	movslq %eax,%rdx
  801a45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a49:	8b 00                	mov    (%rax),%eax
  801a4b:	48 98                	cltq   
  801a4d:	48 83 c0 20          	add    $0x20,%rax
  801a51:	48 39 c2             	cmp    %rax,%rdx
  801a54:	73 b4                	jae    801a0a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5a:	8b 40 04             	mov    0x4(%rax),%eax
  801a5d:	99                   	cltd   
  801a5e:	c1 ea 1b             	shr    $0x1b,%edx
  801a61:	01 d0                	add    %edx,%eax
  801a63:	83 e0 1f             	and    $0x1f,%eax
  801a66:	29 d0                	sub    %edx,%eax
  801a68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a6c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a70:	48 01 ca             	add    %rcx,%rdx
  801a73:	0f b6 0a             	movzbl (%rdx),%ecx
  801a76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a7a:	48 98                	cltq   
  801a7c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a84:	8b 40 04             	mov    0x4(%rax),%eax
  801a87:	8d 50 01             	lea    0x1(%rax),%edx
  801a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a91:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a9e:	0f 82 64 ff ff ff    	jb     801a08 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801aa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801aa8:	c9                   	leaveq 
  801aa9:	c3                   	retq   

0000000000801aaa <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aaa:	55                   	push   %rbp
  801aab:	48 89 e5             	mov    %rsp,%rbp
  801aae:	48 83 ec 20          	sub    $0x20,%rsp
  801ab2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ab6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801abe:	48 89 c7             	mov    %rax,%rdi
  801ac1:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  801ac8:	00 00 00 
  801acb:	ff d0                	callq  *%rax
  801acd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801ad1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ad5:	48 be 9e 37 80 00 00 	movabs $0x80379e,%rsi
  801adc:	00 00 00 
  801adf:	48 89 c7             	mov    %rax,%rdi
  801ae2:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af2:	8b 50 04             	mov    0x4(%rax),%edx
  801af5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af9:	8b 00                	mov    (%rax),%eax
  801afb:	29 c2                	sub    %eax,%edx
  801afd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b01:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801b07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b0b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801b12:	00 00 00 
	stat->st_dev = &devpipe;
  801b15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b19:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801b20:	00 00 00 
  801b23:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2f:	c9                   	leaveq 
  801b30:	c3                   	retq   

0000000000801b31 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b31:	55                   	push   %rbp
  801b32:	48 89 e5             	mov    %rsp,%rbp
  801b35:	48 83 ec 10          	sub    $0x10,%rsp
  801b39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801b3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b41:	48 89 c6             	mov    %rax,%rsi
  801b44:	bf 00 00 00 00       	mov    $0x0,%edi
  801b49:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  801b50:	00 00 00 
  801b53:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b59:	48 89 c7             	mov    %rax,%rdi
  801b5c:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  801b63:	00 00 00 
  801b66:	ff d0                	callq  *%rax
  801b68:	48 89 c6             	mov    %rax,%rsi
  801b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b70:	48 b8 aa 03 80 00 00 	movabs $0x8003aa,%rax
  801b77:	00 00 00 
  801b7a:	ff d0                	callq  *%rax
}
  801b7c:	c9                   	leaveq 
  801b7d:	c3                   	retq   

0000000000801b7e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b7e:	55                   	push   %rbp
  801b7f:	48 89 e5             	mov    %rsp,%rbp
  801b82:	48 83 ec 20          	sub    $0x20,%rsp
  801b86:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b8c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b8f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b93:	be 01 00 00 00       	mov    $0x1,%esi
  801b98:	48 89 c7             	mov    %rax,%rdi
  801b9b:	48 b8 b7 01 80 00 00 	movabs $0x8001b7,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <getchar>:

int
getchar(void)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bb1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801bb5:	ba 01 00 00 00       	mov    $0x1,%edx
  801bba:	48 89 c6             	mov    %rax,%rsi
  801bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc2:	48 b8 84 0a 80 00 00 	movabs $0x800a84,%rax
  801bc9:	00 00 00 
  801bcc:	ff d0                	callq  *%rax
  801bce:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801bd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd5:	79 05                	jns    801bdc <getchar+0x33>
		return r;
  801bd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bda:	eb 14                	jmp    801bf0 <getchar+0x47>
	if (r < 1)
  801bdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801be0:	7f 07                	jg     801be9 <getchar+0x40>
		return -E_EOF;
  801be2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801be7:	eb 07                	jmp    801bf0 <getchar+0x47>
	return c;
  801be9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801bed:	0f b6 c0             	movzbl %al,%eax
}
  801bf0:	c9                   	leaveq 
  801bf1:	c3                   	retq   

0000000000801bf2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	48 83 ec 20          	sub    $0x20,%rsp
  801bfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bfd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c04:	48 89 d6             	mov    %rdx,%rsi
  801c07:	89 c7                	mov    %eax,%edi
  801c09:	48 b8 52 06 80 00 00 	movabs $0x800652,%rax
  801c10:	00 00 00 
  801c13:	ff d0                	callq  *%rax
  801c15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c1c:	79 05                	jns    801c23 <iscons+0x31>
		return r;
  801c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c21:	eb 1a                	jmp    801c3d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801c23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c27:	8b 10                	mov    (%rax),%edx
  801c29:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801c30:	00 00 00 
  801c33:	8b 00                	mov    (%rax),%eax
  801c35:	39 c2                	cmp    %eax,%edx
  801c37:	0f 94 c0             	sete   %al
  801c3a:	0f b6 c0             	movzbl %al,%eax
}
  801c3d:	c9                   	leaveq 
  801c3e:	c3                   	retq   

0000000000801c3f <opencons>:

int
opencons(void)
{
  801c3f:	55                   	push   %rbp
  801c40:	48 89 e5             	mov    %rsp,%rbp
  801c43:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c47:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c4b:	48 89 c7             	mov    %rax,%rdi
  801c4e:	48 b8 ba 05 80 00 00 	movabs $0x8005ba,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	callq  *%rax
  801c5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c61:	79 05                	jns    801c68 <opencons+0x29>
		return r;
  801c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c66:	eb 5b                	jmp    801cc3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c6c:	ba 07 04 00 00       	mov    $0x407,%edx
  801c71:	48 89 c6             	mov    %rax,%rsi
  801c74:	bf 00 00 00 00       	mov    $0x0,%edi
  801c79:	48 b8 ff 02 80 00 00 	movabs $0x8002ff,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	callq  *%rax
  801c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c8c:	79 05                	jns    801c93 <opencons+0x54>
		return r;
  801c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c91:	eb 30                	jmp    801cc3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c97:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c9e:	00 00 00 
  801ca1:	8b 12                	mov    (%rdx),%edx
  801ca3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801cb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb4:	48 89 c7             	mov    %rax,%rdi
  801cb7:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	callq  *%rax
}
  801cc3:	c9                   	leaveq 
  801cc4:	c3                   	retq   

0000000000801cc5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cc5:	55                   	push   %rbp
  801cc6:	48 89 e5             	mov    %rsp,%rbp
  801cc9:	48 83 ec 30          	sub    $0x30,%rsp
  801ccd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cd5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801cd9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cde:	75 07                	jne    801ce7 <devcons_read+0x22>
		return 0;
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce5:	eb 4b                	jmp    801d32 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801ce7:	eb 0c                	jmp    801cf5 <devcons_read+0x30>
		sys_yield();
  801ce9:	48 b8 c1 02 80 00 00 	movabs $0x8002c1,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cf5:	48 b8 01 02 80 00 00 	movabs $0x800201,%rax
  801cfc:	00 00 00 
  801cff:	ff d0                	callq  *%rax
  801d01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d08:	74 df                	je     801ce9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d0e:	79 05                	jns    801d15 <devcons_read+0x50>
		return c;
  801d10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d13:	eb 1d                	jmp    801d32 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801d15:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801d19:	75 07                	jne    801d22 <devcons_read+0x5d>
		return 0;
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	eb 10                	jmp    801d32 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d25:	89 c2                	mov    %eax,%edx
  801d27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d2b:	88 10                	mov    %dl,(%rax)
	return 1;
  801d2d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d32:	c9                   	leaveq 
  801d33:	c3                   	retq   

0000000000801d34 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801d3f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801d46:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801d4d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d5b:	eb 76                	jmp    801dd3 <devcons_write+0x9f>
		m = n - tot;
  801d5d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801d64:	89 c2                	mov    %eax,%edx
  801d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d69:	29 c2                	sub    %eax,%edx
  801d6b:	89 d0                	mov    %edx,%eax
  801d6d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d73:	83 f8 7f             	cmp    $0x7f,%eax
  801d76:	76 07                	jbe    801d7f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d78:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d82:	48 63 d0             	movslq %eax,%rdx
  801d85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d88:	48 63 c8             	movslq %eax,%rcx
  801d8b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d92:	48 01 c1             	add    %rax,%rcx
  801d95:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d9c:	48 89 ce             	mov    %rcx,%rsi
  801d9f:	48 89 c7             	mov    %rax,%rdi
  801da2:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801dae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db1:	48 63 d0             	movslq %eax,%rdx
  801db4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801dbb:	48 89 d6             	mov    %rdx,%rsi
  801dbe:	48 89 c7             	mov    %rax,%rdi
  801dc1:	48 b8 b7 01 80 00 00 	movabs $0x8001b7,%rax
  801dc8:	00 00 00 
  801dcb:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801dcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd0:	01 45 fc             	add    %eax,-0x4(%rbp)
  801dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd6:	48 98                	cltq   
  801dd8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801ddf:	0f 82 78 ff ff ff    	jb     801d5d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801de8:	c9                   	leaveq 
  801de9:	c3                   	retq   

0000000000801dea <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801dea:	55                   	push   %rbp
  801deb:	48 89 e5             	mov    %rsp,%rbp
  801dee:	48 83 ec 08          	sub    $0x8,%rsp
  801df2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 10          	sub    $0x10,%rsp
  801e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e11:	48 be aa 37 80 00 00 	movabs $0x8037aa,%rsi
  801e18:	00 00 00 
  801e1b:	48 89 c7             	mov    %rax,%rdi
  801e1e:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  801e25:	00 00 00 
  801e28:	ff d0                	callq  *%rax
	return 0;
  801e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2f:	c9                   	leaveq 
  801e30:	c3                   	retq   

0000000000801e31 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e31:	55                   	push   %rbp
  801e32:	48 89 e5             	mov    %rsp,%rbp
  801e35:	53                   	push   %rbx
  801e36:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801e3d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801e44:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801e4a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801e51:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801e58:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801e5f:	84 c0                	test   %al,%al
  801e61:	74 23                	je     801e86 <_panic+0x55>
  801e63:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e6a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e6e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e72:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e76:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e7a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e7e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e82:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e86:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e8d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e94:	00 00 00 
  801e97:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e9e:	00 00 00 
  801ea1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ea5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801eac:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801eb3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801eba:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  801ec1:	00 00 00 
  801ec4:	48 8b 18             	mov    (%rax),%rbx
  801ec7:	48 b8 83 02 80 00 00 	movabs $0x800283,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
  801ed3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801ed9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ee0:	41 89 c8             	mov    %ecx,%r8d
  801ee3:	48 89 d1             	mov    %rdx,%rcx
  801ee6:	48 89 da             	mov    %rbx,%rdx
  801ee9:	89 c6                	mov    %eax,%esi
  801eeb:	48 bf b8 37 80 00 00 	movabs $0x8037b8,%rdi
  801ef2:	00 00 00 
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	49 b9 6a 20 80 00 00 	movabs $0x80206a,%r9
  801f01:	00 00 00 
  801f04:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f07:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801f0e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f15:	48 89 d6             	mov    %rdx,%rsi
  801f18:	48 89 c7             	mov    %rax,%rdi
  801f1b:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
	cprintf("\n");
  801f27:	48 bf db 37 80 00 00 	movabs $0x8037db,%rdi
  801f2e:	00 00 00 
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
  801f36:	48 ba 6a 20 80 00 00 	movabs $0x80206a,%rdx
  801f3d:	00 00 00 
  801f40:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f42:	cc                   	int3   
  801f43:	eb fd                	jmp    801f42 <_panic+0x111>

0000000000801f45 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801f45:	55                   	push   %rbp
  801f46:	48 89 e5             	mov    %rsp,%rbp
  801f49:	48 83 ec 10          	sub    $0x10,%rsp
  801f4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801f54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f58:	8b 00                	mov    (%rax),%eax
  801f5a:	8d 48 01             	lea    0x1(%rax),%ecx
  801f5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f61:	89 0a                	mov    %ecx,(%rdx)
  801f63:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f66:	89 d1                	mov    %edx,%ecx
  801f68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6c:	48 98                	cltq   
  801f6e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f76:	8b 00                	mov    (%rax),%eax
  801f78:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f7d:	75 2c                	jne    801fab <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f83:	8b 00                	mov    (%rax),%eax
  801f85:	48 98                	cltq   
  801f87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8b:	48 83 c2 08          	add    $0x8,%rdx
  801f8f:	48 89 c6             	mov    %rax,%rsi
  801f92:	48 89 d7             	mov    %rdx,%rdi
  801f95:	48 b8 b7 01 80 00 00 	movabs $0x8001b7,%rax
  801f9c:	00 00 00 
  801f9f:	ff d0                	callq  *%rax
        b->idx = 0;
  801fa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801faf:	8b 40 04             	mov    0x4(%rax),%eax
  801fb2:	8d 50 01             	lea    0x1(%rax),%edx
  801fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb9:	89 50 04             	mov    %edx,0x4(%rax)
}
  801fbc:	c9                   	leaveq 
  801fbd:	c3                   	retq   

0000000000801fbe <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801fbe:	55                   	push   %rbp
  801fbf:	48 89 e5             	mov    %rsp,%rbp
  801fc2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801fc9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801fd0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801fd7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801fde:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801fe5:	48 8b 0a             	mov    (%rdx),%rcx
  801fe8:	48 89 08             	mov    %rcx,(%rax)
  801feb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801fef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801ff3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801ff7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801ffb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802002:	00 00 00 
    b.cnt = 0;
  802005:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80200c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80200f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802016:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80201d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802024:	48 89 c6             	mov    %rax,%rsi
  802027:	48 bf 45 1f 80 00 00 	movabs $0x801f45,%rdi
  80202e:	00 00 00 
  802031:	48 b8 1d 24 80 00 00 	movabs $0x80241d,%rax
  802038:	00 00 00 
  80203b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80203d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802043:	48 98                	cltq   
  802045:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80204c:	48 83 c2 08          	add    $0x8,%rdx
  802050:	48 89 c6             	mov    %rax,%rsi
  802053:	48 89 d7             	mov    %rdx,%rdi
  802056:	48 b8 b7 01 80 00 00 	movabs $0x8001b7,%rax
  80205d:	00 00 00 
  802060:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802062:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802068:	c9                   	leaveq 
  802069:	c3                   	retq   

000000000080206a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80206a:	55                   	push   %rbp
  80206b:	48 89 e5             	mov    %rsp,%rbp
  80206e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802075:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80207c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802083:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80208a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802091:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802098:	84 c0                	test   %al,%al
  80209a:	74 20                	je     8020bc <cprintf+0x52>
  80209c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8020a0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8020a4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8020a8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8020ac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8020b0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020b4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020b8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020bc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8020c3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8020ca:	00 00 00 
  8020cd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020d4:	00 00 00 
  8020d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020db:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8020e2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8020e9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8020f0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8020f7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8020fe:	48 8b 0a             	mov    (%rdx),%rcx
  802101:	48 89 08             	mov    %rcx,(%rax)
  802104:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802108:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80210c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802110:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802114:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80211b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802122:	48 89 d6             	mov    %rdx,%rsi
  802125:	48 89 c7             	mov    %rax,%rdi
  802128:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  80212f:	00 00 00 
  802132:	ff d0                	callq  *%rax
  802134:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80213a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802140:	c9                   	leaveq 
  802141:	c3                   	retq   

0000000000802142 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802142:	55                   	push   %rbp
  802143:	48 89 e5             	mov    %rsp,%rbp
  802146:	53                   	push   %rbx
  802147:	48 83 ec 38          	sub    $0x38,%rsp
  80214b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80214f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802153:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802157:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80215a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80215e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802162:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802165:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802169:	77 3b                	ja     8021a6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80216b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80216e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802172:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802179:	ba 00 00 00 00       	mov    $0x0,%edx
  80217e:	48 f7 f3             	div    %rbx
  802181:	48 89 c2             	mov    %rax,%rdx
  802184:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802187:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80218a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80218e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802192:	41 89 f9             	mov    %edi,%r9d
  802195:	48 89 c7             	mov    %rax,%rdi
  802198:	48 b8 42 21 80 00 00 	movabs $0x802142,%rax
  80219f:	00 00 00 
  8021a2:	ff d0                	callq  *%rax
  8021a4:	eb 1e                	jmp    8021c4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021a6:	eb 12                	jmp    8021ba <printnum+0x78>
			putch(padc, putdat);
  8021a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021ac:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8021af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b3:	48 89 ce             	mov    %rcx,%rsi
  8021b6:	89 d7                	mov    %edx,%edi
  8021b8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8021ba:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8021be:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021c2:	7f e4                	jg     8021a8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8021c4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8021c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d0:	48 f7 f1             	div    %rcx
  8021d3:	48 89 d0             	mov    %rdx,%rax
  8021d6:	48 ba d0 39 80 00 00 	movabs $0x8039d0,%rdx
  8021dd:	00 00 00 
  8021e0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8021e4:	0f be d0             	movsbl %al,%edx
  8021e7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ef:	48 89 ce             	mov    %rcx,%rsi
  8021f2:	89 d7                	mov    %edx,%edi
  8021f4:	ff d0                	callq  *%rax
}
  8021f6:	48 83 c4 38          	add    $0x38,%rsp
  8021fa:	5b                   	pop    %rbx
  8021fb:	5d                   	pop    %rbp
  8021fc:	c3                   	retq   

00000000008021fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8021fd:	55                   	push   %rbp
  8021fe:	48 89 e5             	mov    %rsp,%rbp
  802201:	48 83 ec 1c          	sub    $0x1c,%rsp
  802205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802209:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80220c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802210:	7e 52                	jle    802264 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	8b 00                	mov    (%rax),%eax
  802218:	83 f8 30             	cmp    $0x30,%eax
  80221b:	73 24                	jae    802241 <getuint+0x44>
  80221d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802221:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802225:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802229:	8b 00                	mov    (%rax),%eax
  80222b:	89 c0                	mov    %eax,%eax
  80222d:	48 01 d0             	add    %rdx,%rax
  802230:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802234:	8b 12                	mov    (%rdx),%edx
  802236:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802239:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80223d:	89 0a                	mov    %ecx,(%rdx)
  80223f:	eb 17                	jmp    802258 <getuint+0x5b>
  802241:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802245:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802249:	48 89 d0             	mov    %rdx,%rax
  80224c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802250:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802254:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802258:	48 8b 00             	mov    (%rax),%rax
  80225b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80225f:	e9 a3 00 00 00       	jmpq   802307 <getuint+0x10a>
	else if (lflag)
  802264:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802268:	74 4f                	je     8022b9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80226a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226e:	8b 00                	mov    (%rax),%eax
  802270:	83 f8 30             	cmp    $0x30,%eax
  802273:	73 24                	jae    802299 <getuint+0x9c>
  802275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802279:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80227d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802281:	8b 00                	mov    (%rax),%eax
  802283:	89 c0                	mov    %eax,%eax
  802285:	48 01 d0             	add    %rdx,%rax
  802288:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80228c:	8b 12                	mov    (%rdx),%edx
  80228e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802291:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802295:	89 0a                	mov    %ecx,(%rdx)
  802297:	eb 17                	jmp    8022b0 <getuint+0xb3>
  802299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022a1:	48 89 d0             	mov    %rdx,%rax
  8022a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022b0:	48 8b 00             	mov    (%rax),%rax
  8022b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022b7:	eb 4e                	jmp    802307 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8022b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bd:	8b 00                	mov    (%rax),%eax
  8022bf:	83 f8 30             	cmp    $0x30,%eax
  8022c2:	73 24                	jae    8022e8 <getuint+0xeb>
  8022c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d0:	8b 00                	mov    (%rax),%eax
  8022d2:	89 c0                	mov    %eax,%eax
  8022d4:	48 01 d0             	add    %rdx,%rax
  8022d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022db:	8b 12                	mov    (%rdx),%edx
  8022dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022e4:	89 0a                	mov    %ecx,(%rdx)
  8022e6:	eb 17                	jmp    8022ff <getuint+0x102>
  8022e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022f0:	48 89 d0             	mov    %rdx,%rax
  8022f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022ff:	8b 00                	mov    (%rax),%eax
  802301:	89 c0                	mov    %eax,%eax
  802303:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80230b:	c9                   	leaveq 
  80230c:	c3                   	retq   

000000000080230d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80230d:	55                   	push   %rbp
  80230e:	48 89 e5             	mov    %rsp,%rbp
  802311:	48 83 ec 1c          	sub    $0x1c,%rsp
  802315:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802319:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80231c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802320:	7e 52                	jle    802374 <getint+0x67>
		x=va_arg(*ap, long long);
  802322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802326:	8b 00                	mov    (%rax),%eax
  802328:	83 f8 30             	cmp    $0x30,%eax
  80232b:	73 24                	jae    802351 <getint+0x44>
  80232d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802331:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802339:	8b 00                	mov    (%rax),%eax
  80233b:	89 c0                	mov    %eax,%eax
  80233d:	48 01 d0             	add    %rdx,%rax
  802340:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802344:	8b 12                	mov    (%rdx),%edx
  802346:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802349:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80234d:	89 0a                	mov    %ecx,(%rdx)
  80234f:	eb 17                	jmp    802368 <getint+0x5b>
  802351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802355:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802359:	48 89 d0             	mov    %rdx,%rax
  80235c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802360:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802364:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802368:	48 8b 00             	mov    (%rax),%rax
  80236b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80236f:	e9 a3 00 00 00       	jmpq   802417 <getint+0x10a>
	else if (lflag)
  802374:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802378:	74 4f                	je     8023c9 <getint+0xbc>
		x=va_arg(*ap, long);
  80237a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237e:	8b 00                	mov    (%rax),%eax
  802380:	83 f8 30             	cmp    $0x30,%eax
  802383:	73 24                	jae    8023a9 <getint+0x9c>
  802385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802389:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80238d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802391:	8b 00                	mov    (%rax),%eax
  802393:	89 c0                	mov    %eax,%eax
  802395:	48 01 d0             	add    %rdx,%rax
  802398:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239c:	8b 12                	mov    (%rdx),%edx
  80239e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a5:	89 0a                	mov    %ecx,(%rdx)
  8023a7:	eb 17                	jmp    8023c0 <getint+0xb3>
  8023a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023b1:	48 89 d0             	mov    %rdx,%rax
  8023b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8023b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023c0:	48 8b 00             	mov    (%rax),%rax
  8023c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023c7:	eb 4e                	jmp    802417 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8023c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cd:	8b 00                	mov    (%rax),%eax
  8023cf:	83 f8 30             	cmp    $0x30,%eax
  8023d2:	73 24                	jae    8023f8 <getint+0xeb>
  8023d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e0:	8b 00                	mov    (%rax),%eax
  8023e2:	89 c0                	mov    %eax,%eax
  8023e4:	48 01 d0             	add    %rdx,%rax
  8023e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023eb:	8b 12                	mov    (%rdx),%edx
  8023ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8023f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f4:	89 0a                	mov    %ecx,(%rdx)
  8023f6:	eb 17                	jmp    80240f <getint+0x102>
  8023f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802400:	48 89 d0             	mov    %rdx,%rax
  802403:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802407:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80240b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80240f:	8b 00                	mov    (%rax),%eax
  802411:	48 98                	cltq   
  802413:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80241b:	c9                   	leaveq 
  80241c:	c3                   	retq   

000000000080241d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80241d:	55                   	push   %rbp
  80241e:	48 89 e5             	mov    %rsp,%rbp
  802421:	41 54                	push   %r12
  802423:	53                   	push   %rbx
  802424:	48 83 ec 60          	sub    $0x60,%rsp
  802428:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80242c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802430:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802434:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802438:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80243c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802440:	48 8b 0a             	mov    (%rdx),%rcx
  802443:	48 89 08             	mov    %rcx,(%rax)
  802446:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80244a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80244e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802452:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802456:	eb 17                	jmp    80246f <vprintfmt+0x52>
			if (ch == '\0')
  802458:	85 db                	test   %ebx,%ebx
  80245a:	0f 84 df 04 00 00    	je     80293f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  802460:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802464:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802468:	48 89 d6             	mov    %rdx,%rsi
  80246b:	89 df                	mov    %ebx,%edi
  80246d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80246f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802473:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802477:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80247b:	0f b6 00             	movzbl (%rax),%eax
  80247e:	0f b6 d8             	movzbl %al,%ebx
  802481:	83 fb 25             	cmp    $0x25,%ebx
  802484:	75 d2                	jne    802458 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802486:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80248a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802491:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80249f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8024a6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8024ae:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8024b2:	0f b6 00             	movzbl (%rax),%eax
  8024b5:	0f b6 d8             	movzbl %al,%ebx
  8024b8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8024bb:	83 f8 55             	cmp    $0x55,%eax
  8024be:	0f 87 47 04 00 00    	ja     80290b <vprintfmt+0x4ee>
  8024c4:	89 c0                	mov    %eax,%eax
  8024c6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8024cd:	00 
  8024ce:	48 b8 f8 39 80 00 00 	movabs $0x8039f8,%rax
  8024d5:	00 00 00 
  8024d8:	48 01 d0             	add    %rdx,%rax
  8024db:	48 8b 00             	mov    (%rax),%rax
  8024de:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8024e0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8024e4:	eb c0                	jmp    8024a6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8024e6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8024ea:	eb ba                	jmp    8024a6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8024f3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8024f6:	89 d0                	mov    %edx,%eax
  8024f8:	c1 e0 02             	shl    $0x2,%eax
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	01 c0                	add    %eax,%eax
  8024ff:	01 d8                	add    %ebx,%eax
  802501:	83 e8 30             	sub    $0x30,%eax
  802504:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802507:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80250b:	0f b6 00             	movzbl (%rax),%eax
  80250e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802511:	83 fb 2f             	cmp    $0x2f,%ebx
  802514:	7e 0c                	jle    802522 <vprintfmt+0x105>
  802516:	83 fb 39             	cmp    $0x39,%ebx
  802519:	7f 07                	jg     802522 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80251b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802520:	eb d1                	jmp    8024f3 <vprintfmt+0xd6>
			goto process_precision;
  802522:	eb 58                	jmp    80257c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802524:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802527:	83 f8 30             	cmp    $0x30,%eax
  80252a:	73 17                	jae    802543 <vprintfmt+0x126>
  80252c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802530:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802533:	89 c0                	mov    %eax,%eax
  802535:	48 01 d0             	add    %rdx,%rax
  802538:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80253b:	83 c2 08             	add    $0x8,%edx
  80253e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802541:	eb 0f                	jmp    802552 <vprintfmt+0x135>
  802543:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802547:	48 89 d0             	mov    %rdx,%rax
  80254a:	48 83 c2 08          	add    $0x8,%rdx
  80254e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802552:	8b 00                	mov    (%rax),%eax
  802554:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802557:	eb 23                	jmp    80257c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802559:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80255d:	79 0c                	jns    80256b <vprintfmt+0x14e>
				width = 0;
  80255f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802566:	e9 3b ff ff ff       	jmpq   8024a6 <vprintfmt+0x89>
  80256b:	e9 36 ff ff ff       	jmpq   8024a6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802570:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802577:	e9 2a ff ff ff       	jmpq   8024a6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80257c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802580:	79 12                	jns    802594 <vprintfmt+0x177>
				width = precision, precision = -1;
  802582:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802585:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802588:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80258f:	e9 12 ff ff ff       	jmpq   8024a6 <vprintfmt+0x89>
  802594:	e9 0d ff ff ff       	jmpq   8024a6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802599:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80259d:	e9 04 ff ff ff       	jmpq   8024a6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8025a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a5:	83 f8 30             	cmp    $0x30,%eax
  8025a8:	73 17                	jae    8025c1 <vprintfmt+0x1a4>
  8025aa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025b1:	89 c0                	mov    %eax,%eax
  8025b3:	48 01 d0             	add    %rdx,%rax
  8025b6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025b9:	83 c2 08             	add    $0x8,%edx
  8025bc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025bf:	eb 0f                	jmp    8025d0 <vprintfmt+0x1b3>
  8025c1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025c5:	48 89 d0             	mov    %rdx,%rax
  8025c8:	48 83 c2 08          	add    $0x8,%rdx
  8025cc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025d0:	8b 10                	mov    (%rax),%edx
  8025d2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8025d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025da:	48 89 ce             	mov    %rcx,%rsi
  8025dd:	89 d7                	mov    %edx,%edi
  8025df:	ff d0                	callq  *%rax
			break;
  8025e1:	e9 53 03 00 00       	jmpq   802939 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8025e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025e9:	83 f8 30             	cmp    $0x30,%eax
  8025ec:	73 17                	jae    802605 <vprintfmt+0x1e8>
  8025ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025f5:	89 c0                	mov    %eax,%eax
  8025f7:	48 01 d0             	add    %rdx,%rax
  8025fa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025fd:	83 c2 08             	add    $0x8,%edx
  802600:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802603:	eb 0f                	jmp    802614 <vprintfmt+0x1f7>
  802605:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802609:	48 89 d0             	mov    %rdx,%rax
  80260c:	48 83 c2 08          	add    $0x8,%rdx
  802610:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802614:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802616:	85 db                	test   %ebx,%ebx
  802618:	79 02                	jns    80261c <vprintfmt+0x1ff>
				err = -err;
  80261a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80261c:	83 fb 15             	cmp    $0x15,%ebx
  80261f:	7f 16                	jg     802637 <vprintfmt+0x21a>
  802621:	48 b8 20 39 80 00 00 	movabs $0x803920,%rax
  802628:	00 00 00 
  80262b:	48 63 d3             	movslq %ebx,%rdx
  80262e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802632:	4d 85 e4             	test   %r12,%r12
  802635:	75 2e                	jne    802665 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802637:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80263b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80263f:	89 d9                	mov    %ebx,%ecx
  802641:	48 ba e1 39 80 00 00 	movabs $0x8039e1,%rdx
  802648:	00 00 00 
  80264b:	48 89 c7             	mov    %rax,%rdi
  80264e:	b8 00 00 00 00       	mov    $0x0,%eax
  802653:	49 b8 48 29 80 00 00 	movabs $0x802948,%r8
  80265a:	00 00 00 
  80265d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802660:	e9 d4 02 00 00       	jmpq   802939 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802665:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802669:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80266d:	4c 89 e1             	mov    %r12,%rcx
  802670:	48 ba ea 39 80 00 00 	movabs $0x8039ea,%rdx
  802677:	00 00 00 
  80267a:	48 89 c7             	mov    %rax,%rdi
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
  802682:	49 b8 48 29 80 00 00 	movabs $0x802948,%r8
  802689:	00 00 00 
  80268c:	41 ff d0             	callq  *%r8
			break;
  80268f:	e9 a5 02 00 00       	jmpq   802939 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802694:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802697:	83 f8 30             	cmp    $0x30,%eax
  80269a:	73 17                	jae    8026b3 <vprintfmt+0x296>
  80269c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026a0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026a3:	89 c0                	mov    %eax,%eax
  8026a5:	48 01 d0             	add    %rdx,%rax
  8026a8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8026ab:	83 c2 08             	add    $0x8,%edx
  8026ae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8026b1:	eb 0f                	jmp    8026c2 <vprintfmt+0x2a5>
  8026b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026b7:	48 89 d0             	mov    %rdx,%rax
  8026ba:	48 83 c2 08          	add    $0x8,%rdx
  8026be:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026c2:	4c 8b 20             	mov    (%rax),%r12
  8026c5:	4d 85 e4             	test   %r12,%r12
  8026c8:	75 0a                	jne    8026d4 <vprintfmt+0x2b7>
				p = "(null)";
  8026ca:	49 bc ed 39 80 00 00 	movabs $0x8039ed,%r12
  8026d1:	00 00 00 
			if (width > 0 && padc != '-')
  8026d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026d8:	7e 3f                	jle    802719 <vprintfmt+0x2fc>
  8026da:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8026de:	74 39                	je     802719 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8026e0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8026e3:	48 98                	cltq   
  8026e5:	48 89 c6             	mov    %rax,%rsi
  8026e8:	4c 89 e7             	mov    %r12,%rdi
  8026eb:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  8026f2:	00 00 00 
  8026f5:	ff d0                	callq  *%rax
  8026f7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8026fa:	eb 17                	jmp    802713 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8026fc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802700:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802704:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802708:	48 89 ce             	mov    %rcx,%rsi
  80270b:	89 d7                	mov    %edx,%edi
  80270d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80270f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802713:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802717:	7f e3                	jg     8026fc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802719:	eb 37                	jmp    802752 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80271b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80271f:	74 1e                	je     80273f <vprintfmt+0x322>
  802721:	83 fb 1f             	cmp    $0x1f,%ebx
  802724:	7e 05                	jle    80272b <vprintfmt+0x30e>
  802726:	83 fb 7e             	cmp    $0x7e,%ebx
  802729:	7e 14                	jle    80273f <vprintfmt+0x322>
					putch('?', putdat);
  80272b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80272f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802733:	48 89 d6             	mov    %rdx,%rsi
  802736:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80273b:	ff d0                	callq  *%rax
  80273d:	eb 0f                	jmp    80274e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80273f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802743:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802747:	48 89 d6             	mov    %rdx,%rsi
  80274a:	89 df                	mov    %ebx,%edi
  80274c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80274e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802752:	4c 89 e0             	mov    %r12,%rax
  802755:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802759:	0f b6 00             	movzbl (%rax),%eax
  80275c:	0f be d8             	movsbl %al,%ebx
  80275f:	85 db                	test   %ebx,%ebx
  802761:	74 10                	je     802773 <vprintfmt+0x356>
  802763:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802767:	78 b2                	js     80271b <vprintfmt+0x2fe>
  802769:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80276d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802771:	79 a8                	jns    80271b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802773:	eb 16                	jmp    80278b <vprintfmt+0x36e>
				putch(' ', putdat);
  802775:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802779:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80277d:	48 89 d6             	mov    %rdx,%rsi
  802780:	bf 20 00 00 00       	mov    $0x20,%edi
  802785:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802787:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80278b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80278f:	7f e4                	jg     802775 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802791:	e9 a3 01 00 00       	jmpq   802939 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802796:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80279a:	be 03 00 00 00       	mov    $0x3,%esi
  80279f:	48 89 c7             	mov    %rax,%rdi
  8027a2:	48 b8 0d 23 80 00 00 	movabs $0x80230d,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
  8027ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8027b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b6:	48 85 c0             	test   %rax,%rax
  8027b9:	79 1d                	jns    8027d8 <vprintfmt+0x3bb>
				putch('-', putdat);
  8027bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027c3:	48 89 d6             	mov    %rdx,%rsi
  8027c6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027cb:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d1:	48 f7 d8             	neg    %rax
  8027d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8027d8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8027df:	e9 e8 00 00 00       	jmpq   8028cc <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8027e4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027e8:	be 03 00 00 00       	mov    $0x3,%esi
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
  8027fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802800:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802807:	e9 c0 00 00 00       	jmpq   8028cc <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80280c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802810:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802814:	48 89 d6             	mov    %rdx,%rsi
  802817:	bf 58 00 00 00       	mov    $0x58,%edi
  80281c:	ff d0                	callq  *%rax
			putch('X', putdat);
  80281e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802822:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802826:	48 89 d6             	mov    %rdx,%rsi
  802829:	bf 58 00 00 00       	mov    $0x58,%edi
  80282e:	ff d0                	callq  *%rax
			putch('X', putdat);
  802830:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802834:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802838:	48 89 d6             	mov    %rdx,%rsi
  80283b:	bf 58 00 00 00       	mov    $0x58,%edi
  802840:	ff d0                	callq  *%rax
			break;
  802842:	e9 f2 00 00 00       	jmpq   802939 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  802847:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80284b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80284f:	48 89 d6             	mov    %rdx,%rsi
  802852:	bf 30 00 00 00       	mov    $0x30,%edi
  802857:	ff d0                	callq  *%rax
			putch('x', putdat);
  802859:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80285d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802861:	48 89 d6             	mov    %rdx,%rsi
  802864:	bf 78 00 00 00       	mov    $0x78,%edi
  802869:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80286b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80286e:	83 f8 30             	cmp    $0x30,%eax
  802871:	73 17                	jae    80288a <vprintfmt+0x46d>
  802873:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802877:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80287a:	89 c0                	mov    %eax,%eax
  80287c:	48 01 d0             	add    %rdx,%rax
  80287f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802882:	83 c2 08             	add    $0x8,%edx
  802885:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802888:	eb 0f                	jmp    802899 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80288a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80288e:	48 89 d0             	mov    %rdx,%rax
  802891:	48 83 c2 08          	add    $0x8,%rdx
  802895:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802899:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80289c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8028a0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8028a7:	eb 23                	jmp    8028cc <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8028a9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8028ad:	be 03 00 00 00       	mov    $0x3,%esi
  8028b2:	48 89 c7             	mov    %rax,%rdi
  8028b5:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
  8028c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8028c5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028cc:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8028d1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8028d4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8028d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028db:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8028df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028e3:	45 89 c1             	mov    %r8d,%r9d
  8028e6:	41 89 f8             	mov    %edi,%r8d
  8028e9:	48 89 c7             	mov    %rax,%rdi
  8028ec:	48 b8 42 21 80 00 00 	movabs $0x802142,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
			break;
  8028f8:	eb 3f                	jmp    802939 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028fa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028fe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802902:	48 89 d6             	mov    %rdx,%rsi
  802905:	89 df                	mov    %ebx,%edi
  802907:	ff d0                	callq  *%rax
			break;
  802909:	eb 2e                	jmp    802939 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80290b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80290f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802913:	48 89 d6             	mov    %rdx,%rsi
  802916:	bf 25 00 00 00       	mov    $0x25,%edi
  80291b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80291d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802922:	eb 05                	jmp    802929 <vprintfmt+0x50c>
  802924:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802929:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80292d:	48 83 e8 01          	sub    $0x1,%rax
  802931:	0f b6 00             	movzbl (%rax),%eax
  802934:	3c 25                	cmp    $0x25,%al
  802936:	75 ec                	jne    802924 <vprintfmt+0x507>
				/* do nothing */;
			break;
  802938:	90                   	nop
		}
	}
  802939:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80293a:	e9 30 fb ff ff       	jmpq   80246f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80293f:	48 83 c4 60          	add    $0x60,%rsp
  802943:	5b                   	pop    %rbx
  802944:	41 5c                	pop    %r12
  802946:	5d                   	pop    %rbp
  802947:	c3                   	retq   

0000000000802948 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802948:	55                   	push   %rbp
  802949:	48 89 e5             	mov    %rsp,%rbp
  80294c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802953:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80295a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802961:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802968:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80296f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802976:	84 c0                	test   %al,%al
  802978:	74 20                	je     80299a <printfmt+0x52>
  80297a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80297e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802982:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802986:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80298a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80298e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802992:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802996:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80299a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8029a1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8029a8:	00 00 00 
  8029ab:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8029b2:	00 00 00 
  8029b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029b9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8029c0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029c7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8029ce:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8029d5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8029dc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8029e3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8029ea:	48 89 c7             	mov    %rax,%rdi
  8029ed:	48 b8 1d 24 80 00 00 	movabs $0x80241d,%rax
  8029f4:	00 00 00 
  8029f7:	ff d0                	callq  *%rax
	va_end(ap);
}
  8029f9:	c9                   	leaveq 
  8029fa:	c3                   	retq   

00000000008029fb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029fb:	55                   	push   %rbp
  8029fc:	48 89 e5             	mov    %rsp,%rbp
  8029ff:	48 83 ec 10          	sub    $0x10,%rsp
  802a03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0e:	8b 40 10             	mov    0x10(%rax),%eax
  802a11:	8d 50 01             	lea    0x1(%rax),%edx
  802a14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a18:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802a1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1f:	48 8b 10             	mov    (%rax),%rdx
  802a22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a26:	48 8b 40 08          	mov    0x8(%rax),%rax
  802a2a:	48 39 c2             	cmp    %rax,%rdx
  802a2d:	73 17                	jae    802a46 <sprintputch+0x4b>
		*b->buf++ = ch;
  802a2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a33:	48 8b 00             	mov    (%rax),%rax
  802a36:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802a3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a3e:	48 89 0a             	mov    %rcx,(%rdx)
  802a41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a44:	88 10                	mov    %dl,(%rax)
}
  802a46:	c9                   	leaveq 
  802a47:	c3                   	retq   

0000000000802a48 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802a48:	55                   	push   %rbp
  802a49:	48 89 e5             	mov    %rsp,%rbp
  802a4c:	48 83 ec 50          	sub    $0x50,%rsp
  802a50:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a54:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802a57:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a5b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a5f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a63:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a67:	48 8b 0a             	mov    (%rdx),%rcx
  802a6a:	48 89 08             	mov    %rcx,(%rax)
  802a6d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a71:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a75:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a79:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a81:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a85:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a88:	48 98                	cltq   
  802a8a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a8e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a92:	48 01 d0             	add    %rdx,%rax
  802a95:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a99:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802aa0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802aa5:	74 06                	je     802aad <vsnprintf+0x65>
  802aa7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802aab:	7f 07                	jg     802ab4 <vsnprintf+0x6c>
		return -E_INVAL;
  802aad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ab2:	eb 2f                	jmp    802ae3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802ab4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802ab8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802abc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ac0:	48 89 c6             	mov    %rax,%rsi
  802ac3:	48 bf fb 29 80 00 00 	movabs $0x8029fb,%rdi
  802aca:	00 00 00 
  802acd:	48 b8 1d 24 80 00 00 	movabs $0x80241d,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802ad9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802add:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802ae0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802ae3:	c9                   	leaveq 
  802ae4:	c3                   	retq   

0000000000802ae5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802ae5:	55                   	push   %rbp
  802ae6:	48 89 e5             	mov    %rsp,%rbp
  802ae9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802af0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802af7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802afd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802b04:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b0b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b12:	84 c0                	test   %al,%al
  802b14:	74 20                	je     802b36 <snprintf+0x51>
  802b16:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b1a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b1e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b22:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b26:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b2a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b2e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b32:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802b36:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802b3d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802b44:	00 00 00 
  802b47:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b4e:	00 00 00 
  802b51:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b55:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b5c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b63:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b6a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b71:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b78:	48 8b 0a             	mov    (%rdx),%rcx
  802b7b:	48 89 08             	mov    %rcx,(%rax)
  802b7e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b82:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b86:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b8a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b8e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b95:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b9c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802ba2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802ba9:	48 89 c7             	mov    %rax,%rdi
  802bac:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802bb3:	00 00 00 
  802bb6:	ff d0                	callq  *%rax
  802bb8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802bbe:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bc4:	c9                   	leaveq 
  802bc5:	c3                   	retq   

0000000000802bc6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802bc6:	55                   	push   %rbp
  802bc7:	48 89 e5             	mov    %rsp,%rbp
  802bca:	48 83 ec 18          	sub    $0x18,%rsp
  802bce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802bd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bd9:	eb 09                	jmp    802be4 <strlen+0x1e>
		n++;
  802bdb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802bdf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be8:	0f b6 00             	movzbl (%rax),%eax
  802beb:	84 c0                	test   %al,%al
  802bed:	75 ec                	jne    802bdb <strlen+0x15>
		n++;
	return n;
  802bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bf2:	c9                   	leaveq 
  802bf3:	c3                   	retq   

0000000000802bf4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802bf4:	55                   	push   %rbp
  802bf5:	48 89 e5             	mov    %rsp,%rbp
  802bf8:	48 83 ec 20          	sub    $0x20,%rsp
  802bfc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c0b:	eb 0e                	jmp    802c1b <strnlen+0x27>
		n++;
  802c0d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802c11:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802c16:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802c1b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c20:	74 0b                	je     802c2d <strnlen+0x39>
  802c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c26:	0f b6 00             	movzbl (%rax),%eax
  802c29:	84 c0                	test   %al,%al
  802c2b:	75 e0                	jne    802c0d <strnlen+0x19>
		n++;
	return n;
  802c2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c30:	c9                   	leaveq 
  802c31:	c3                   	retq   

0000000000802c32 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802c32:	55                   	push   %rbp
  802c33:	48 89 e5             	mov    %rsp,%rbp
  802c36:	48 83 ec 20          	sub    $0x20,%rsp
  802c3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c46:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802c4a:	90                   	nop
  802c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c53:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c57:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c5b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c5f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c63:	0f b6 12             	movzbl (%rdx),%edx
  802c66:	88 10                	mov    %dl,(%rax)
  802c68:	0f b6 00             	movzbl (%rax),%eax
  802c6b:	84 c0                	test   %al,%al
  802c6d:	75 dc                	jne    802c4b <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c73:	c9                   	leaveq 
  802c74:	c3                   	retq   

0000000000802c75 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c75:	55                   	push   %rbp
  802c76:	48 89 e5             	mov    %rsp,%rbp
  802c79:	48 83 ec 20          	sub    $0x20,%rsp
  802c7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c89:	48 89 c7             	mov    %rax,%rdi
  802c8c:	48 b8 c6 2b 80 00 00 	movabs $0x802bc6,%rax
  802c93:	00 00 00 
  802c96:	ff d0                	callq  *%rax
  802c98:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9e:	48 63 d0             	movslq %eax,%rdx
  802ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca5:	48 01 c2             	add    %rax,%rdx
  802ca8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cac:	48 89 c6             	mov    %rax,%rsi
  802caf:	48 89 d7             	mov    %rdx,%rdi
  802cb2:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
	return dst;
  802cbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802cc2:	c9                   	leaveq 
  802cc3:	c3                   	retq   

0000000000802cc4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 28          	sub    $0x28,%rsp
  802ccc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802ce0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ce7:	00 
  802ce8:	eb 2a                	jmp    802d14 <strncpy+0x50>
		*dst++ = *src;
  802cea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cf2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cf6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cfa:	0f b6 12             	movzbl (%rdx),%edx
  802cfd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802cff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d03:	0f b6 00             	movzbl (%rax),%eax
  802d06:	84 c0                	test   %al,%al
  802d08:	74 05                	je     802d0f <strncpy+0x4b>
			src++;
  802d0a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802d0f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d1c:	72 cc                	jb     802cea <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802d22:	c9                   	leaveq 
  802d23:	c3                   	retq   

0000000000802d24 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802d24:	55                   	push   %rbp
  802d25:	48 89 e5             	mov    %rsp,%rbp
  802d28:	48 83 ec 28          	sub    $0x28,%rsp
  802d2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d34:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802d40:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d45:	74 3d                	je     802d84 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802d47:	eb 1d                	jmp    802d66 <strlcpy+0x42>
			*dst++ = *src++;
  802d49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d51:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d55:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d59:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d5d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d61:	0f b6 12             	movzbl (%rdx),%edx
  802d64:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d66:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d6b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d70:	74 0b                	je     802d7d <strlcpy+0x59>
  802d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d76:	0f b6 00             	movzbl (%rax),%eax
  802d79:	84 c0                	test   %al,%al
  802d7b:	75 cc                	jne    802d49 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d81:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8c:	48 29 c2             	sub    %rax,%rdx
  802d8f:	48 89 d0             	mov    %rdx,%rax
}
  802d92:	c9                   	leaveq 
  802d93:	c3                   	retq   

0000000000802d94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d94:	55                   	push   %rbp
  802d95:	48 89 e5             	mov    %rsp,%rbp
  802d98:	48 83 ec 10          	sub    $0x10,%rsp
  802d9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802da0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802da4:	eb 0a                	jmp    802db0 <strcmp+0x1c>
		p++, q++;
  802da6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802db0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db4:	0f b6 00             	movzbl (%rax),%eax
  802db7:	84 c0                	test   %al,%al
  802db9:	74 12                	je     802dcd <strcmp+0x39>
  802dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dbf:	0f b6 10             	movzbl (%rax),%edx
  802dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc6:	0f b6 00             	movzbl (%rax),%eax
  802dc9:	38 c2                	cmp    %al,%dl
  802dcb:	74 d9                	je     802da6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd1:	0f b6 00             	movzbl (%rax),%eax
  802dd4:	0f b6 d0             	movzbl %al,%edx
  802dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddb:	0f b6 00             	movzbl (%rax),%eax
  802dde:	0f b6 c0             	movzbl %al,%eax
  802de1:	29 c2                	sub    %eax,%edx
  802de3:	89 d0                	mov    %edx,%eax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 18          	sub    $0x18,%rsp
  802def:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802df3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802df7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802dfb:	eb 0f                	jmp    802e0c <strncmp+0x25>
		n--, p++, q++;
  802dfd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802e02:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e07:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802e0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e11:	74 1d                	je     802e30 <strncmp+0x49>
  802e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e17:	0f b6 00             	movzbl (%rax),%eax
  802e1a:	84 c0                	test   %al,%al
  802e1c:	74 12                	je     802e30 <strncmp+0x49>
  802e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e22:	0f b6 10             	movzbl (%rax),%edx
  802e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e29:	0f b6 00             	movzbl (%rax),%eax
  802e2c:	38 c2                	cmp    %al,%dl
  802e2e:	74 cd                	je     802dfd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802e30:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e35:	75 07                	jne    802e3e <strncmp+0x57>
		return 0;
  802e37:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3c:	eb 18                	jmp    802e56 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802e3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e42:	0f b6 00             	movzbl (%rax),%eax
  802e45:	0f b6 d0             	movzbl %al,%edx
  802e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4c:	0f b6 00             	movzbl (%rax),%eax
  802e4f:	0f b6 c0             	movzbl %al,%eax
  802e52:	29 c2                	sub    %eax,%edx
  802e54:	89 d0                	mov    %edx,%eax
}
  802e56:	c9                   	leaveq 
  802e57:	c3                   	retq   

0000000000802e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802e58:	55                   	push   %rbp
  802e59:	48 89 e5             	mov    %rsp,%rbp
  802e5c:	48 83 ec 0c          	sub    $0xc,%rsp
  802e60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e64:	89 f0                	mov    %esi,%eax
  802e66:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e69:	eb 17                	jmp    802e82 <strchr+0x2a>
		if (*s == c)
  802e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6f:	0f b6 00             	movzbl (%rax),%eax
  802e72:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e75:	75 06                	jne    802e7d <strchr+0x25>
			return (char *) s;
  802e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7b:	eb 15                	jmp    802e92 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e7d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e86:	0f b6 00             	movzbl (%rax),%eax
  802e89:	84 c0                	test   %al,%al
  802e8b:	75 de                	jne    802e6b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e92:	c9                   	leaveq 
  802e93:	c3                   	retq   

0000000000802e94 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e94:	55                   	push   %rbp
  802e95:	48 89 e5             	mov    %rsp,%rbp
  802e98:	48 83 ec 0c          	sub    $0xc,%rsp
  802e9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ea0:	89 f0                	mov    %esi,%eax
  802ea2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802ea5:	eb 13                	jmp    802eba <strfind+0x26>
		if (*s == c)
  802ea7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eab:	0f b6 00             	movzbl (%rax),%eax
  802eae:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802eb1:	75 02                	jne    802eb5 <strfind+0x21>
			break;
  802eb3:	eb 10                	jmp    802ec5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802eb5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802eba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebe:	0f b6 00             	movzbl (%rax),%eax
  802ec1:	84 c0                	test   %al,%al
  802ec3:	75 e2                	jne    802ea7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ec9:	c9                   	leaveq 
  802eca:	c3                   	retq   

0000000000802ecb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802ecb:	55                   	push   %rbp
  802ecc:	48 89 e5             	mov    %rsp,%rbp
  802ecf:	48 83 ec 18          	sub    $0x18,%rsp
  802ed3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ed7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802eda:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ede:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ee3:	75 06                	jne    802eeb <memset+0x20>
		return v;
  802ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee9:	eb 69                	jmp    802f54 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802eeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eef:	83 e0 03             	and    $0x3,%eax
  802ef2:	48 85 c0             	test   %rax,%rax
  802ef5:	75 48                	jne    802f3f <memset+0x74>
  802ef7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efb:	83 e0 03             	and    $0x3,%eax
  802efe:	48 85 c0             	test   %rax,%rax
  802f01:	75 3c                	jne    802f3f <memset+0x74>
		c &= 0xFF;
  802f03:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802f0a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f0d:	c1 e0 18             	shl    $0x18,%eax
  802f10:	89 c2                	mov    %eax,%edx
  802f12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f15:	c1 e0 10             	shl    $0x10,%eax
  802f18:	09 c2                	or     %eax,%edx
  802f1a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f1d:	c1 e0 08             	shl    $0x8,%eax
  802f20:	09 d0                	or     %edx,%eax
  802f22:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802f25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f29:	48 c1 e8 02          	shr    $0x2,%rax
  802f2d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802f30:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f34:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f37:	48 89 d7             	mov    %rdx,%rdi
  802f3a:	fc                   	cld    
  802f3b:	f3 ab                	rep stos %eax,%es:(%rdi)
  802f3d:	eb 11                	jmp    802f50 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802f3f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f43:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f46:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f4a:	48 89 d7             	mov    %rdx,%rdi
  802f4d:	fc                   	cld    
  802f4e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802f50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f54:	c9                   	leaveq 
  802f55:	c3                   	retq   

0000000000802f56 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802f56:	55                   	push   %rbp
  802f57:	48 89 e5             	mov    %rsp,%rbp
  802f5a:	48 83 ec 28          	sub    $0x28,%rsp
  802f5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f66:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f7e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f82:	0f 83 88 00 00 00    	jae    803010 <memmove+0xba>
  802f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f90:	48 01 d0             	add    %rdx,%rax
  802f93:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f97:	76 77                	jbe    803010 <memmove+0xba>
		s += n;
  802f99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802fa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fad:	83 e0 03             	and    $0x3,%eax
  802fb0:	48 85 c0             	test   %rax,%rax
  802fb3:	75 3b                	jne    802ff0 <memmove+0x9a>
  802fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb9:	83 e0 03             	and    $0x3,%eax
  802fbc:	48 85 c0             	test   %rax,%rax
  802fbf:	75 2f                	jne    802ff0 <memmove+0x9a>
  802fc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc5:	83 e0 03             	and    $0x3,%eax
  802fc8:	48 85 c0             	test   %rax,%rax
  802fcb:	75 23                	jne    802ff0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd1:	48 83 e8 04          	sub    $0x4,%rax
  802fd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fd9:	48 83 ea 04          	sub    $0x4,%rdx
  802fdd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fe1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802fe5:	48 89 c7             	mov    %rax,%rdi
  802fe8:	48 89 d6             	mov    %rdx,%rsi
  802feb:	fd                   	std    
  802fec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fee:	eb 1d                	jmp    80300d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802ff8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803000:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803004:	48 89 d7             	mov    %rdx,%rdi
  803007:	48 89 c1             	mov    %rax,%rcx
  80300a:	fd                   	std    
  80300b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80300d:	fc                   	cld    
  80300e:	eb 57                	jmp    803067 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803014:	83 e0 03             	and    $0x3,%eax
  803017:	48 85 c0             	test   %rax,%rax
  80301a:	75 36                	jne    803052 <memmove+0xfc>
  80301c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803020:	83 e0 03             	and    $0x3,%eax
  803023:	48 85 c0             	test   %rax,%rax
  803026:	75 2a                	jne    803052 <memmove+0xfc>
  803028:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80302c:	83 e0 03             	and    $0x3,%eax
  80302f:	48 85 c0             	test   %rax,%rax
  803032:	75 1e                	jne    803052 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803034:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803038:	48 c1 e8 02          	shr    $0x2,%rax
  80303c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80303f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803043:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803047:	48 89 c7             	mov    %rax,%rdi
  80304a:	48 89 d6             	mov    %rdx,%rsi
  80304d:	fc                   	cld    
  80304e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803050:	eb 15                	jmp    803067 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803056:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80305a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80305e:	48 89 c7             	mov    %rax,%rdi
  803061:	48 89 d6             	mov    %rdx,%rsi
  803064:	fc                   	cld    
  803065:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803067:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80306b:	c9                   	leaveq 
  80306c:	c3                   	retq   

000000000080306d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80306d:	55                   	push   %rbp
  80306e:	48 89 e5             	mov    %rsp,%rbp
  803071:	48 83 ec 18          	sub    $0x18,%rsp
  803075:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803079:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80307d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803081:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803085:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803089:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80308d:	48 89 ce             	mov    %rcx,%rsi
  803090:	48 89 c7             	mov    %rax,%rdi
  803093:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
}
  80309f:	c9                   	leaveq 
  8030a0:	c3                   	retq   

00000000008030a1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8030a1:	55                   	push   %rbp
  8030a2:	48 89 e5             	mov    %rsp,%rbp
  8030a5:	48 83 ec 28          	sub    $0x28,%rsp
  8030a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8030b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8030bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8030c5:	eb 36                	jmp    8030fd <memcmp+0x5c>
		if (*s1 != *s2)
  8030c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030cb:	0f b6 10             	movzbl (%rax),%edx
  8030ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d2:	0f b6 00             	movzbl (%rax),%eax
  8030d5:	38 c2                	cmp    %al,%dl
  8030d7:	74 1a                	je     8030f3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8030d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030dd:	0f b6 00             	movzbl (%rax),%eax
  8030e0:	0f b6 d0             	movzbl %al,%edx
  8030e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e7:	0f b6 00             	movzbl (%rax),%eax
  8030ea:	0f b6 c0             	movzbl %al,%eax
  8030ed:	29 c2                	sub    %eax,%edx
  8030ef:	89 d0                	mov    %edx,%eax
  8030f1:	eb 20                	jmp    803113 <memcmp+0x72>
		s1++, s2++;
  8030f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030f8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803101:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803105:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803109:	48 85 c0             	test   %rax,%rax
  80310c:	75 b9                	jne    8030c7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80310e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803113:	c9                   	leaveq 
  803114:	c3                   	retq   

0000000000803115 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803115:	55                   	push   %rbp
  803116:	48 89 e5             	mov    %rsp,%rbp
  803119:	48 83 ec 28          	sub    $0x28,%rsp
  80311d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803121:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803124:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803128:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80312c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803130:	48 01 d0             	add    %rdx,%rax
  803133:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803137:	eb 15                	jmp    80314e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313d:	0f b6 10             	movzbl (%rax),%edx
  803140:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803143:	38 c2                	cmp    %al,%dl
  803145:	75 02                	jne    803149 <memfind+0x34>
			break;
  803147:	eb 0f                	jmp    803158 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803149:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80314e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803152:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803156:	72 e1                	jb     803139 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80315c:	c9                   	leaveq 
  80315d:	c3                   	retq   

000000000080315e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80315e:	55                   	push   %rbp
  80315f:	48 89 e5             	mov    %rsp,%rbp
  803162:	48 83 ec 34          	sub    $0x34,%rsp
  803166:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80316a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80316e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803178:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80317f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803180:	eb 05                	jmp    803187 <strtol+0x29>
		s++;
  803182:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803187:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318b:	0f b6 00             	movzbl (%rax),%eax
  80318e:	3c 20                	cmp    $0x20,%al
  803190:	74 f0                	je     803182 <strtol+0x24>
  803192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803196:	0f b6 00             	movzbl (%rax),%eax
  803199:	3c 09                	cmp    $0x9,%al
  80319b:	74 e5                	je     803182 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80319d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a1:	0f b6 00             	movzbl (%rax),%eax
  8031a4:	3c 2b                	cmp    $0x2b,%al
  8031a6:	75 07                	jne    8031af <strtol+0x51>
		s++;
  8031a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031ad:	eb 17                	jmp    8031c6 <strtol+0x68>
	else if (*s == '-')
  8031af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b3:	0f b6 00             	movzbl (%rax),%eax
  8031b6:	3c 2d                	cmp    $0x2d,%al
  8031b8:	75 0c                	jne    8031c6 <strtol+0x68>
		s++, neg = 1;
  8031ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8031c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031ca:	74 06                	je     8031d2 <strtol+0x74>
  8031cc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8031d0:	75 28                	jne    8031fa <strtol+0x9c>
  8031d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d6:	0f b6 00             	movzbl (%rax),%eax
  8031d9:	3c 30                	cmp    $0x30,%al
  8031db:	75 1d                	jne    8031fa <strtol+0x9c>
  8031dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e1:	48 83 c0 01          	add    $0x1,%rax
  8031e5:	0f b6 00             	movzbl (%rax),%eax
  8031e8:	3c 78                	cmp    $0x78,%al
  8031ea:	75 0e                	jne    8031fa <strtol+0x9c>
		s += 2, base = 16;
  8031ec:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8031f1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8031f8:	eb 2c                	jmp    803226 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8031fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031fe:	75 19                	jne    803219 <strtol+0xbb>
  803200:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803204:	0f b6 00             	movzbl (%rax),%eax
  803207:	3c 30                	cmp    $0x30,%al
  803209:	75 0e                	jne    803219 <strtol+0xbb>
		s++, base = 8;
  80320b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803210:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803217:	eb 0d                	jmp    803226 <strtol+0xc8>
	else if (base == 0)
  803219:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80321d:	75 07                	jne    803226 <strtol+0xc8>
		base = 10;
  80321f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322a:	0f b6 00             	movzbl (%rax),%eax
  80322d:	3c 2f                	cmp    $0x2f,%al
  80322f:	7e 1d                	jle    80324e <strtol+0xf0>
  803231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803235:	0f b6 00             	movzbl (%rax),%eax
  803238:	3c 39                	cmp    $0x39,%al
  80323a:	7f 12                	jg     80324e <strtol+0xf0>
			dig = *s - '0';
  80323c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803240:	0f b6 00             	movzbl (%rax),%eax
  803243:	0f be c0             	movsbl %al,%eax
  803246:	83 e8 30             	sub    $0x30,%eax
  803249:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80324c:	eb 4e                	jmp    80329c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80324e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803252:	0f b6 00             	movzbl (%rax),%eax
  803255:	3c 60                	cmp    $0x60,%al
  803257:	7e 1d                	jle    803276 <strtol+0x118>
  803259:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325d:	0f b6 00             	movzbl (%rax),%eax
  803260:	3c 7a                	cmp    $0x7a,%al
  803262:	7f 12                	jg     803276 <strtol+0x118>
			dig = *s - 'a' + 10;
  803264:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803268:	0f b6 00             	movzbl (%rax),%eax
  80326b:	0f be c0             	movsbl %al,%eax
  80326e:	83 e8 57             	sub    $0x57,%eax
  803271:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803274:	eb 26                	jmp    80329c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327a:	0f b6 00             	movzbl (%rax),%eax
  80327d:	3c 40                	cmp    $0x40,%al
  80327f:	7e 48                	jle    8032c9 <strtol+0x16b>
  803281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803285:	0f b6 00             	movzbl (%rax),%eax
  803288:	3c 5a                	cmp    $0x5a,%al
  80328a:	7f 3d                	jg     8032c9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80328c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803290:	0f b6 00             	movzbl (%rax),%eax
  803293:	0f be c0             	movsbl %al,%eax
  803296:	83 e8 37             	sub    $0x37,%eax
  803299:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80329c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8032a2:	7c 02                	jl     8032a6 <strtol+0x148>
			break;
  8032a4:	eb 23                	jmp    8032c9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8032a6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8032ab:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032ae:	48 98                	cltq   
  8032b0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8032b5:	48 89 c2             	mov    %rax,%rdx
  8032b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032bb:	48 98                	cltq   
  8032bd:	48 01 d0             	add    %rdx,%rax
  8032c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8032c4:	e9 5d ff ff ff       	jmpq   803226 <strtol+0xc8>

	if (endptr)
  8032c9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8032ce:	74 0b                	je     8032db <strtol+0x17d>
		*endptr = (char *) s;
  8032d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8032db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032df:	74 09                	je     8032ea <strtol+0x18c>
  8032e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e5:	48 f7 d8             	neg    %rax
  8032e8:	eb 04                	jmp    8032ee <strtol+0x190>
  8032ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8032ee:	c9                   	leaveq 
  8032ef:	c3                   	retq   

00000000008032f0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8032f0:	55                   	push   %rbp
  8032f1:	48 89 e5             	mov    %rsp,%rbp
  8032f4:	48 83 ec 30          	sub    $0x30,%rsp
  8032f8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032fc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803300:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803304:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803308:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80330c:	0f b6 00             	movzbl (%rax),%eax
  80330f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803312:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803316:	75 06                	jne    80331e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803318:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331c:	eb 6b                	jmp    803389 <strstr+0x99>

	len = strlen(str);
  80331e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803322:	48 89 c7             	mov    %rax,%rdi
  803325:	48 b8 c6 2b 80 00 00 	movabs $0x802bc6,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
  803331:	48 98                	cltq   
  803333:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803337:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80333b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80333f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803343:	0f b6 00             	movzbl (%rax),%eax
  803346:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803349:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80334d:	75 07                	jne    803356 <strstr+0x66>
				return (char *) 0;
  80334f:	b8 00 00 00 00       	mov    $0x0,%eax
  803354:	eb 33                	jmp    803389 <strstr+0x99>
		} while (sc != c);
  803356:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80335a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80335d:	75 d8                	jne    803337 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80335f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803363:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803367:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336b:	48 89 ce             	mov    %rcx,%rsi
  80336e:	48 89 c7             	mov    %rax,%rdi
  803371:	48 b8 e7 2d 80 00 00 	movabs $0x802de7,%rax
  803378:	00 00 00 
  80337b:	ff d0                	callq  *%rax
  80337d:	85 c0                	test   %eax,%eax
  80337f:	75 b6                	jne    803337 <strstr+0x47>

	return (char *) (in - 1);
  803381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803385:	48 83 e8 01          	sub    $0x1,%rax
}
  803389:	c9                   	leaveq 
  80338a:	c3                   	retq   

000000000080338b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80338b:	55                   	push   %rbp
  80338c:	48 89 e5             	mov    %rsp,%rbp
  80338f:	48 83 ec 30          	sub    $0x30,%rsp
  803393:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803397:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80339b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80339f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033a4:	75 0e                	jne    8033b4 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033a6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033ad:	00 00 00 
  8033b0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b8:	48 89 c7             	mov    %rax,%rdi
  8033bb:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
  8033c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ce:	79 27                	jns    8033f7 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033d0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033d5:	74 0a                	je     8033e1 <ipc_recv+0x56>
            *from_env_store = 0;
  8033d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033db:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033e1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033e6:	74 0a                	je     8033f2 <ipc_recv+0x67>
            *perm_store = 0;
  8033e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ec:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f5:	eb 53                	jmp    80344a <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033fc:	74 19                	je     803417 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8033fe:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803405:	00 00 00 
  803408:	48 8b 00             	mov    (%rax),%rax
  80340b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803411:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803415:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803417:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80341c:	74 19                	je     803437 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80341e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803425:	00 00 00 
  803428:	48 8b 00             	mov    (%rax),%rax
  80342b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803435:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803437:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80343e:	00 00 00 
  803441:	48 8b 00             	mov    (%rax),%rax
  803444:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80344a:	c9                   	leaveq 
  80344b:	c3                   	retq   

000000000080344c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80344c:	55                   	push   %rbp
  80344d:	48 89 e5             	mov    %rsp,%rbp
  803450:	48 83 ec 30          	sub    $0x30,%rsp
  803454:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803457:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80345a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80345e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803461:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803466:	75 0e                	jne    803476 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803468:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80346f:	00 00 00 
  803472:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803476:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803479:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80347c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803480:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803483:	89 c7                	mov    %eax,%edi
  803485:	48 b8 d3 04 80 00 00 	movabs $0x8004d3,%rax
  80348c:	00 00 00 
  80348f:	ff d0                	callq  *%rax
  803491:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803498:	79 36                	jns    8034d0 <ipc_send+0x84>
  80349a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80349e:	74 30                	je     8034d0 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8034a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a3:	89 c1                	mov    %eax,%ecx
  8034a5:	48 ba a8 3c 80 00 00 	movabs $0x803ca8,%rdx
  8034ac:	00 00 00 
  8034af:	be 49 00 00 00       	mov    $0x49,%esi
  8034b4:	48 bf b5 3c 80 00 00 	movabs $0x803cb5,%rdi
  8034bb:	00 00 00 
  8034be:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c3:	49 b8 31 1e 80 00 00 	movabs $0x801e31,%r8
  8034ca:	00 00 00 
  8034cd:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034d0:	48 b8 c1 02 80 00 00 	movabs $0x8002c1,%rax
  8034d7:	00 00 00 
  8034da:	ff d0                	callq  *%rax
    } while(r != 0);
  8034dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e0:	75 94                	jne    803476 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034e2:	c9                   	leaveq 
  8034e3:	c3                   	retq   

00000000008034e4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034e4:	55                   	push   %rbp
  8034e5:	48 89 e5             	mov    %rsp,%rbp
  8034e8:	48 83 ec 14          	sub    $0x14,%rsp
  8034ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034f6:	eb 5e                	jmp    803556 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034f8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034ff:	00 00 00 
  803502:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803505:	48 63 d0             	movslq %eax,%rdx
  803508:	48 89 d0             	mov    %rdx,%rax
  80350b:	48 c1 e0 03          	shl    $0x3,%rax
  80350f:	48 01 d0             	add    %rdx,%rax
  803512:	48 c1 e0 05          	shl    $0x5,%rax
  803516:	48 01 c8             	add    %rcx,%rax
  803519:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80351f:	8b 00                	mov    (%rax),%eax
  803521:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803524:	75 2c                	jne    803552 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803526:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80352d:	00 00 00 
  803530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803533:	48 63 d0             	movslq %eax,%rdx
  803536:	48 89 d0             	mov    %rdx,%rax
  803539:	48 c1 e0 03          	shl    $0x3,%rax
  80353d:	48 01 d0             	add    %rdx,%rax
  803540:	48 c1 e0 05          	shl    $0x5,%rax
  803544:	48 01 c8             	add    %rcx,%rax
  803547:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80354d:	8b 40 08             	mov    0x8(%rax),%eax
  803550:	eb 12                	jmp    803564 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803552:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803556:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80355d:	7e 99                	jle    8034f8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80355f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803564:	c9                   	leaveq 
  803565:	c3                   	retq   

0000000000803566 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803566:	55                   	push   %rbp
  803567:	48 89 e5             	mov    %rsp,%rbp
  80356a:	48 83 ec 18          	sub    $0x18,%rsp
  80356e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803576:	48 c1 e8 15          	shr    $0x15,%rax
  80357a:	48 89 c2             	mov    %rax,%rdx
  80357d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803584:	01 00 00 
  803587:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80358b:	83 e0 01             	and    $0x1,%eax
  80358e:	48 85 c0             	test   %rax,%rax
  803591:	75 07                	jne    80359a <pageref+0x34>
		return 0;
  803593:	b8 00 00 00 00       	mov    $0x0,%eax
  803598:	eb 53                	jmp    8035ed <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80359a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359e:	48 c1 e8 0c          	shr    $0xc,%rax
  8035a2:	48 89 c2             	mov    %rax,%rdx
  8035a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035ac:	01 00 00 
  8035af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035bb:	83 e0 01             	and    $0x1,%eax
  8035be:	48 85 c0             	test   %rax,%rax
  8035c1:	75 07                	jne    8035ca <pageref+0x64>
		return 0;
  8035c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c8:	eb 23                	jmp    8035ed <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8035d2:	48 89 c2             	mov    %rax,%rdx
  8035d5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035dc:	00 00 00 
  8035df:	48 c1 e2 04          	shl    $0x4,%rdx
  8035e3:	48 01 d0             	add    %rdx,%rax
  8035e6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035ea:	0f b7 c0             	movzwl %ax,%eax
}
  8035ed:	c9                   	leaveq 
  8035ee:	c3                   	retq   
