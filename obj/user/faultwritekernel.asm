
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
	envid_t id = sys_getenvid();
  800073:	48 b8 66 02 80 00 00 	movabs $0x800266,%rax
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
  8000a8:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000af:	00 00 00 
  8000b2:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000b9:	7e 14                	jle    8000cf <libmain+0x6b>
		binaryname = argv[0];
  8000bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000bf:	48 8b 10             	mov    (%rax),%rdx
  8000c2:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  8000f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8000fe:	48 b8 22 02 80 00 00 	movabs $0x800222,%rax
  800105:	00 00 00 
  800108:	ff d0                	callq  *%rax
}
  80010a:	5d                   	pop    %rbp
  80010b:	c3                   	retq   

000000000080010c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80010c:	55                   	push   %rbp
  80010d:	48 89 e5             	mov    %rsp,%rbp
  800110:	53                   	push   %rbx
  800111:	48 83 ec 48          	sub    $0x48,%rsp
  800115:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800118:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80011b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80011f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800123:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800127:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80012e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800132:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800136:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80013a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80013e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800142:	4c 89 c3             	mov    %r8,%rbx
  800145:	cd 30                	int    $0x30
  800147:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80014b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80014f:	74 3e                	je     80018f <syscall+0x83>
  800151:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800156:	7e 37                	jle    80018f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800158:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80015c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80015f:	49 89 d0             	mov    %rdx,%r8
  800162:	89 c1                	mov    %eax,%ecx
  800164:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  80016b:	00 00 00 
  80016e:	be 23 00 00 00       	mov    $0x23,%esi
  800173:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	49 b9 05 05 80 00 00 	movabs $0x800505,%r9
  800189:	00 00 00 
  80018c:	41 ff d1             	callq  *%r9

	return ret;
  80018f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800193:	48 83 c4 48          	add    $0x48,%rsp
  800197:	5b                   	pop    %rbx
  800198:	5d                   	pop    %rbp
  800199:	c3                   	retq   

000000000080019a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80019a:	55                   	push   %rbp
  80019b:	48 89 e5             	mov    %rsp,%rbp
  80019e:	48 83 ec 20          	sub    $0x20,%rsp
  8001a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b9:	00 
  8001ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c6:	48 89 d1             	mov    %rdx,%rcx
  8001c9:	48 89 c2             	mov    %rax,%rdx
  8001cc:	be 00 00 00 00       	mov    $0x0,%esi
  8001d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d6:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  8001dd:	00 00 00 
  8001e0:	ff d0                	callq  *%rax
}
  8001e2:	c9                   	leaveq 
  8001e3:	c3                   	retq   

00000000008001e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e4:	55                   	push   %rbp
  8001e5:	48 89 e5             	mov    %rsp,%rbp
  8001e8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f3:	00 
  8001f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800200:	b9 00 00 00 00       	mov    $0x0,%ecx
  800205:	ba 00 00 00 00       	mov    $0x0,%edx
  80020a:	be 00 00 00 00       	mov    $0x0,%esi
  80020f:	bf 01 00 00 00       	mov    $0x1,%edi
  800214:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
}
  800220:	c9                   	leaveq 
  800221:	c3                   	retq   

0000000000800222 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800222:	55                   	push   %rbp
  800223:	48 89 e5             	mov    %rsp,%rbp
  800226:	48 83 ec 10          	sub    $0x10,%rsp
  80022a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80022d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800230:	48 98                	cltq   
  800232:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800239:	00 
  80023a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800240:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800246:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024b:	48 89 c2             	mov    %rax,%rdx
  80024e:	be 01 00 00 00       	mov    $0x1,%esi
  800253:	bf 03 00 00 00       	mov    $0x3,%edi
  800258:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
}
  800264:	c9                   	leaveq 
  800265:	c3                   	retq   

0000000000800266 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800266:	55                   	push   %rbp
  800267:	48 89 e5             	mov    %rsp,%rbp
  80026a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80026e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800275:	00 
  800276:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80027c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	ba 00 00 00 00       	mov    $0x0,%edx
  80028c:	be 00 00 00 00       	mov    $0x0,%esi
  800291:	bf 02 00 00 00       	mov    $0x2,%edi
  800296:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	callq  *%rax
}
  8002a2:	c9                   	leaveq 
  8002a3:	c3                   	retq   

00000000008002a4 <sys_yield>:

void
sys_yield(void)
{
  8002a4:	55                   	push   %rbp
  8002a5:	48 89 e5             	mov    %rsp,%rbp
  8002a8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002b3:	00 
  8002b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ca:	be 00 00 00 00       	mov    $0x0,%esi
  8002cf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002d4:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
}
  8002e0:	c9                   	leaveq 
  8002e1:	c3                   	retq   

00000000008002e2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002e2:	55                   	push   %rbp
  8002e3:	48 89 e5             	mov    %rsp,%rbp
  8002e6:	48 83 ec 20          	sub    $0x20,%rsp
  8002ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002f1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f7:	48 63 c8             	movslq %eax,%rcx
  8002fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800301:	48 98                	cltq   
  800303:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80030a:	00 
  80030b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800311:	49 89 c8             	mov    %rcx,%r8
  800314:	48 89 d1             	mov    %rdx,%rcx
  800317:	48 89 c2             	mov    %rax,%rdx
  80031a:	be 01 00 00 00       	mov    $0x1,%esi
  80031f:	bf 04 00 00 00       	mov    $0x4,%edi
  800324:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
}
  800330:	c9                   	leaveq 
  800331:	c3                   	retq   

0000000000800332 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
  800336:	48 83 ec 30          	sub    $0x30,%rsp
  80033a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80033d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800341:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800344:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800348:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80034c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80034f:	48 63 c8             	movslq %eax,%rcx
  800352:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800356:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800359:	48 63 f0             	movslq %eax,%rsi
  80035c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800360:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800363:	48 98                	cltq   
  800365:	48 89 0c 24          	mov    %rcx,(%rsp)
  800369:	49 89 f9             	mov    %rdi,%r9
  80036c:	49 89 f0             	mov    %rsi,%r8
  80036f:	48 89 d1             	mov    %rdx,%rcx
  800372:	48 89 c2             	mov    %rax,%rdx
  800375:	be 01 00 00 00       	mov    $0x1,%esi
  80037a:	bf 05 00 00 00       	mov    $0x5,%edi
  80037f:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  800386:	00 00 00 
  800389:	ff d0                	callq  *%rax
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 20          	sub    $0x20,%rsp
  800395:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80039c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	48 98                	cltq   
  8003a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003ac:	00 
  8003ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003b9:	48 89 d1             	mov    %rdx,%rcx
  8003bc:	48 89 c2             	mov    %rax,%rdx
  8003bf:	be 01 00 00 00       	mov    $0x1,%esi
  8003c4:	bf 06 00 00 00       	mov    $0x6,%edi
  8003c9:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  8003d0:	00 00 00 
  8003d3:	ff d0                	callq  *%rax
}
  8003d5:	c9                   	leaveq 
  8003d6:	c3                   	retq   

00000000008003d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003d7:	55                   	push   %rbp
  8003d8:	48 89 e5             	mov    %rsp,%rbp
  8003db:	48 83 ec 10          	sub    $0x10,%rsp
  8003df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003e8:	48 63 d0             	movslq %eax,%rdx
  8003eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ee:	48 98                	cltq   
  8003f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003f7:	00 
  8003f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800404:	48 89 d1             	mov    %rdx,%rcx
  800407:	48 89 c2             	mov    %rax,%rdx
  80040a:	be 01 00 00 00       	mov    $0x1,%esi
  80040f:	bf 08 00 00 00       	mov    $0x8,%edi
  800414:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  80041b:	00 00 00 
  80041e:	ff d0                	callq  *%rax
}
  800420:	c9                   	leaveq 
  800421:	c3                   	retq   

0000000000800422 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800422:	55                   	push   %rbp
  800423:	48 89 e5             	mov    %rsp,%rbp
  800426:	48 83 ec 20          	sub    $0x20,%rsp
  80042a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800431:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	48 98                	cltq   
  80043a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800441:	00 
  800442:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800448:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80044e:	48 89 d1             	mov    %rdx,%rcx
  800451:	48 89 c2             	mov    %rax,%rdx
  800454:	be 01 00 00 00       	mov    $0x1,%esi
  800459:	bf 09 00 00 00       	mov    $0x9,%edi
  80045e:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
}
  80046a:	c9                   	leaveq 
  80046b:	c3                   	retq   

000000000080046c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80046c:	55                   	push   %rbp
  80046d:	48 89 e5             	mov    %rsp,%rbp
  800470:	48 83 ec 20          	sub    $0x20,%rsp
  800474:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800477:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80047b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80047f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800482:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800485:	48 63 f0             	movslq %eax,%rsi
  800488:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80048c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80048f:	48 98                	cltq   
  800491:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800495:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80049c:	00 
  80049d:	49 89 f1             	mov    %rsi,%r9
  8004a0:	49 89 c8             	mov    %rcx,%r8
  8004a3:	48 89 d1             	mov    %rdx,%rcx
  8004a6:	48 89 c2             	mov    %rax,%rdx
  8004a9:	be 00 00 00 00       	mov    $0x0,%esi
  8004ae:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004b3:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  8004ba:	00 00 00 
  8004bd:	ff d0                	callq  *%rax
}
  8004bf:	c9                   	leaveq 
  8004c0:	c3                   	retq   

00000000008004c1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004c1:	55                   	push   %rbp
  8004c2:	48 89 e5             	mov    %rsp,%rbp
  8004c5:	48 83 ec 10          	sub    $0x10,%rsp
  8004c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004d8:	00 
  8004d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ea:	48 89 c2             	mov    %rax,%rdx
  8004ed:	be 01 00 00 00       	mov    $0x1,%esi
  8004f2:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004f7:	48 b8 0c 01 80 00 00 	movabs $0x80010c,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   

0000000000800505 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800505:	55                   	push   %rbp
  800506:	48 89 e5             	mov    %rsp,%rbp
  800509:	53                   	push   %rbx
  80050a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800511:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800518:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80051e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800525:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80052c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800533:	84 c0                	test   %al,%al
  800535:	74 23                	je     80055a <_panic+0x55>
  800537:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80053e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800542:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800546:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80054a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80054e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800552:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800556:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80055a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800561:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800568:	00 00 00 
  80056b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800572:	00 00 00 
  800575:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800579:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800580:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800587:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80058e:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800595:	00 00 00 
  800598:	48 8b 18             	mov    (%rax),%rbx
  80059b:	48 b8 66 02 80 00 00 	movabs $0x800266,%rax
  8005a2:	00 00 00 
  8005a5:	ff d0                	callq  *%rax
  8005a7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005ad:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005b4:	41 89 c8             	mov    %ecx,%r8d
  8005b7:	48 89 d1             	mov    %rdx,%rcx
  8005ba:	48 89 da             	mov    %rbx,%rdx
  8005bd:	89 c6                	mov    %eax,%esi
  8005bf:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005c6:	00 00 00 
  8005c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ce:	49 b9 3e 07 80 00 00 	movabs $0x80073e,%r9
  8005d5:	00 00 00 
  8005d8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005db:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005e2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005e9:	48 89 d6             	mov    %rdx,%rsi
  8005ec:	48 89 c7             	mov    %rax,%rdi
  8005ef:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  8005f6:	00 00 00 
  8005f9:	ff d0                	callq  *%rax
	cprintf("\n");
  8005fb:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  800602:	00 00 00 
  800605:	b8 00 00 00 00       	mov    $0x0,%eax
  80060a:	48 ba 3e 07 80 00 00 	movabs $0x80073e,%rdx
  800611:	00 00 00 
  800614:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800616:	cc                   	int3   
  800617:	eb fd                	jmp    800616 <_panic+0x111>

0000000000800619 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	48 83 ec 10          	sub    $0x10,%rsp
  800621:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800624:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	8d 48 01             	lea    0x1(%rax),%ecx
  800631:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800635:	89 0a                	mov    %ecx,(%rdx)
  800637:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80063a:	89 d1                	mov    %edx,%ecx
  80063c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800640:	48 98                	cltq   
  800642:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064a:	8b 00                	mov    (%rax),%eax
  80064c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800651:	75 2c                	jne    80067f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800657:	8b 00                	mov    (%rax),%eax
  800659:	48 98                	cltq   
  80065b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065f:	48 83 c2 08          	add    $0x8,%rdx
  800663:	48 89 c6             	mov    %rax,%rsi
  800666:	48 89 d7             	mov    %rdx,%rdi
  800669:	48 b8 9a 01 80 00 00 	movabs $0x80019a,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
        b->idx = 0;
  800675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800679:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80067f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800683:	8b 40 04             	mov    0x4(%rax),%eax
  800686:	8d 50 01             	lea    0x1(%rax),%edx
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800690:	c9                   	leaveq 
  800691:	c3                   	retq   

0000000000800692 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800692:	55                   	push   %rbp
  800693:	48 89 e5             	mov    %rsp,%rbp
  800696:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80069d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006a4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006ab:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006b2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006b9:	48 8b 0a             	mov    (%rdx),%rcx
  8006bc:	48 89 08             	mov    %rcx,(%rax)
  8006bf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006cb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006d6:	00 00 00 
    b.cnt = 0;
  8006d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006e0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006e3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ea:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006f8:	48 89 c6             	mov    %rax,%rsi
  8006fb:	48 bf 19 06 80 00 00 	movabs $0x800619,%rdi
  800702:	00 00 00 
  800705:	48 b8 f1 0a 80 00 00 	movabs $0x800af1,%rax
  80070c:	00 00 00 
  80070f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800711:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800717:	48 98                	cltq   
  800719:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800720:	48 83 c2 08          	add    $0x8,%rdx
  800724:	48 89 c6             	mov    %rax,%rsi
  800727:	48 89 d7             	mov    %rdx,%rdi
  80072a:	48 b8 9a 01 80 00 00 	movabs $0x80019a,%rax
  800731:	00 00 00 
  800734:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800736:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80073c:	c9                   	leaveq 
  80073d:	c3                   	retq   

000000000080073e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80073e:	55                   	push   %rbp
  80073f:	48 89 e5             	mov    %rsp,%rbp
  800742:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800749:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800750:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800757:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80075e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800765:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80076c:	84 c0                	test   %al,%al
  80076e:	74 20                	je     800790 <cprintf+0x52>
  800770:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800774:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800778:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80077c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800780:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800784:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800788:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80078c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800790:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800797:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80079e:	00 00 00 
  8007a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007a8:	00 00 00 
  8007ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007c4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007cb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007d2:	48 8b 0a             	mov    (%rdx),%rcx
  8007d5:	48 89 08             	mov    %rcx,(%rax)
  8007d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007e8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007ef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007f6:	48 89 d6             	mov    %rdx,%rsi
  8007f9:	48 89 c7             	mov    %rax,%rdi
  8007fc:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  800803:	00 00 00 
  800806:	ff d0                	callq  *%rax
  800808:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80080e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800814:	c9                   	leaveq 
  800815:	c3                   	retq   

0000000000800816 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800816:	55                   	push   %rbp
  800817:	48 89 e5             	mov    %rsp,%rbp
  80081a:	53                   	push   %rbx
  80081b:	48 83 ec 38          	sub    $0x38,%rsp
  80081f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800823:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800827:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80082b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80082e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800832:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800836:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800839:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80083d:	77 3b                	ja     80087a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80083f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800842:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800846:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80084d:	ba 00 00 00 00       	mov    $0x0,%edx
  800852:	48 f7 f3             	div    %rbx
  800855:	48 89 c2             	mov    %rax,%rdx
  800858:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80085b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80085e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800866:	41 89 f9             	mov    %edi,%r9d
  800869:	48 89 c7             	mov    %rax,%rdi
  80086c:	48 b8 16 08 80 00 00 	movabs $0x800816,%rax
  800873:	00 00 00 
  800876:	ff d0                	callq  *%rax
  800878:	eb 1e                	jmp    800898 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087a:	eb 12                	jmp    80088e <printnum+0x78>
			putch(padc, putdat);
  80087c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800880:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800887:	48 89 ce             	mov    %rcx,%rsi
  80088a:	89 d7                	mov    %edx,%edi
  80088c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800892:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800896:	7f e4                	jg     80087c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800898:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80089b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089f:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a4:	48 f7 f1             	div    %rcx
  8008a7:	48 89 d0             	mov    %rdx,%rax
  8008aa:	48 ba 10 1c 80 00 00 	movabs $0x801c10,%rdx
  8008b1:	00 00 00 
  8008b4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008b8:	0f be d0             	movsbl %al,%edx
  8008bb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c3:	48 89 ce             	mov    %rcx,%rsi
  8008c6:	89 d7                	mov    %edx,%edi
  8008c8:	ff d0                	callq  *%rax
}
  8008ca:	48 83 c4 38          	add    $0x38,%rsp
  8008ce:	5b                   	pop    %rbx
  8008cf:	5d                   	pop    %rbp
  8008d0:	c3                   	retq   

00000000008008d1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d1:	55                   	push   %rbp
  8008d2:	48 89 e5             	mov    %rsp,%rbp
  8008d5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008dd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008e0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008e4:	7e 52                	jle    800938 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ea:	8b 00                	mov    (%rax),%eax
  8008ec:	83 f8 30             	cmp    $0x30,%eax
  8008ef:	73 24                	jae    800915 <getuint+0x44>
  8008f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	8b 00                	mov    (%rax),%eax
  8008ff:	89 c0                	mov    %eax,%eax
  800901:	48 01 d0             	add    %rdx,%rax
  800904:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800908:	8b 12                	mov    (%rdx),%edx
  80090a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	89 0a                	mov    %ecx,(%rdx)
  800913:	eb 17                	jmp    80092c <getuint+0x5b>
  800915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800919:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80091d:	48 89 d0             	mov    %rdx,%rax
  800920:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800924:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800928:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80092c:	48 8b 00             	mov    (%rax),%rax
  80092f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800933:	e9 a3 00 00 00       	jmpq   8009db <getuint+0x10a>
	else if (lflag)
  800938:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80093c:	74 4f                	je     80098d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	8b 00                	mov    (%rax),%eax
  800944:	83 f8 30             	cmp    $0x30,%eax
  800947:	73 24                	jae    80096d <getuint+0x9c>
  800949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	8b 00                	mov    (%rax),%eax
  800957:	89 c0                	mov    %eax,%eax
  800959:	48 01 d0             	add    %rdx,%rax
  80095c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800960:	8b 12                	mov    (%rdx),%edx
  800962:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800965:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800969:	89 0a                	mov    %ecx,(%rdx)
  80096b:	eb 17                	jmp    800984 <getuint+0xb3>
  80096d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800971:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800975:	48 89 d0             	mov    %rdx,%rax
  800978:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80097c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800980:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800984:	48 8b 00             	mov    (%rax),%rax
  800987:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80098b:	eb 4e                	jmp    8009db <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80098d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800991:	8b 00                	mov    (%rax),%eax
  800993:	83 f8 30             	cmp    $0x30,%eax
  800996:	73 24                	jae    8009bc <getuint+0xeb>
  800998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	8b 00                	mov    (%rax),%eax
  8009a6:	89 c0                	mov    %eax,%eax
  8009a8:	48 01 d0             	add    %rdx,%rax
  8009ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009af:	8b 12                	mov    (%rdx),%edx
  8009b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b8:	89 0a                	mov    %ecx,(%rdx)
  8009ba:	eb 17                	jmp    8009d3 <getuint+0x102>
  8009bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009c4:	48 89 d0             	mov    %rdx,%rax
  8009c7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d3:	8b 00                	mov    (%rax),%eax
  8009d5:	89 c0                	mov    %eax,%eax
  8009d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009df:	c9                   	leaveq 
  8009e0:	c3                   	retq   

00000000008009e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009e1:	55                   	push   %rbp
  8009e2:	48 89 e5             	mov    %rsp,%rbp
  8009e5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009f0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009f4:	7e 52                	jle    800a48 <getint+0x67>
		x=va_arg(*ap, long long);
  8009f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fa:	8b 00                	mov    (%rax),%eax
  8009fc:	83 f8 30             	cmp    $0x30,%eax
  8009ff:	73 24                	jae    800a25 <getint+0x44>
  800a01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a05:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0d:	8b 00                	mov    (%rax),%eax
  800a0f:	89 c0                	mov    %eax,%eax
  800a11:	48 01 d0             	add    %rdx,%rax
  800a14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a18:	8b 12                	mov    (%rdx),%edx
  800a1a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a21:	89 0a                	mov    %ecx,(%rdx)
  800a23:	eb 17                	jmp    800a3c <getint+0x5b>
  800a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a29:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a2d:	48 89 d0             	mov    %rdx,%rax
  800a30:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a38:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a3c:	48 8b 00             	mov    (%rax),%rax
  800a3f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a43:	e9 a3 00 00 00       	jmpq   800aeb <getint+0x10a>
	else if (lflag)
  800a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a4c:	74 4f                	je     800a9d <getint+0xbc>
		x=va_arg(*ap, long);
  800a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a52:	8b 00                	mov    (%rax),%eax
  800a54:	83 f8 30             	cmp    $0x30,%eax
  800a57:	73 24                	jae    800a7d <getint+0x9c>
  800a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a65:	8b 00                	mov    (%rax),%eax
  800a67:	89 c0                	mov    %eax,%eax
  800a69:	48 01 d0             	add    %rdx,%rax
  800a6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a70:	8b 12                	mov    (%rdx),%edx
  800a72:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a79:	89 0a                	mov    %ecx,(%rdx)
  800a7b:	eb 17                	jmp    800a94 <getint+0xb3>
  800a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a81:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a85:	48 89 d0             	mov    %rdx,%rax
  800a88:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a90:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a94:	48 8b 00             	mov    (%rax),%rax
  800a97:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a9b:	eb 4e                	jmp    800aeb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa1:	8b 00                	mov    (%rax),%eax
  800aa3:	83 f8 30             	cmp    $0x30,%eax
  800aa6:	73 24                	jae    800acc <getint+0xeb>
  800aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab4:	8b 00                	mov    (%rax),%eax
  800ab6:	89 c0                	mov    %eax,%eax
  800ab8:	48 01 d0             	add    %rdx,%rax
  800abb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abf:	8b 12                	mov    (%rdx),%edx
  800ac1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ac4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac8:	89 0a                	mov    %ecx,(%rdx)
  800aca:	eb 17                	jmp    800ae3 <getint+0x102>
  800acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ad4:	48 89 d0             	mov    %rdx,%rax
  800ad7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ae3:	8b 00                	mov    (%rax),%eax
  800ae5:	48 98                	cltq   
  800ae7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aef:	c9                   	leaveq 
  800af0:	c3                   	retq   

0000000000800af1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800af1:	55                   	push   %rbp
  800af2:	48 89 e5             	mov    %rsp,%rbp
  800af5:	41 54                	push   %r12
  800af7:	53                   	push   %rbx
  800af8:	48 83 ec 60          	sub    $0x60,%rsp
  800afc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b00:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b04:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b08:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b0c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b10:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b14:	48 8b 0a             	mov    (%rdx),%rcx
  800b17:	48 89 08             	mov    %rcx,(%rax)
  800b1a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b1e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b22:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b26:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2a:	eb 17                	jmp    800b43 <vprintfmt+0x52>
			if (ch == '\0')
  800b2c:	85 db                	test   %ebx,%ebx
  800b2e:	0f 84 df 04 00 00    	je     801013 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800b34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3c:	48 89 d6             	mov    %rdx,%rsi
  800b3f:	89 df                	mov    %ebx,%edi
  800b41:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b43:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b4b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b4f:	0f b6 00             	movzbl (%rax),%eax
  800b52:	0f b6 d8             	movzbl %al,%ebx
  800b55:	83 fb 25             	cmp    $0x25,%ebx
  800b58:	75 d2                	jne    800b2c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b5a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b5e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b65:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b6c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b73:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b82:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b86:	0f b6 00             	movzbl (%rax),%eax
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b8f:	83 f8 55             	cmp    $0x55,%eax
  800b92:	0f 87 47 04 00 00    	ja     800fdf <vprintfmt+0x4ee>
  800b98:	89 c0                	mov    %eax,%eax
  800b9a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ba1:	00 
  800ba2:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  800ba9:	00 00 00 
  800bac:	48 01 d0             	add    %rdx,%rax
  800baf:	48 8b 00             	mov    (%rax),%rax
  800bb2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bb4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bb8:	eb c0                	jmp    800b7a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bba:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bbe:	eb ba                	jmp    800b7a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bc7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bca:	89 d0                	mov    %edx,%eax
  800bcc:	c1 e0 02             	shl    $0x2,%eax
  800bcf:	01 d0                	add    %edx,%eax
  800bd1:	01 c0                	add    %eax,%eax
  800bd3:	01 d8                	add    %ebx,%eax
  800bd5:	83 e8 30             	sub    $0x30,%eax
  800bd8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bdb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bdf:	0f b6 00             	movzbl (%rax),%eax
  800be2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be5:	83 fb 2f             	cmp    $0x2f,%ebx
  800be8:	7e 0c                	jle    800bf6 <vprintfmt+0x105>
  800bea:	83 fb 39             	cmp    $0x39,%ebx
  800bed:	7f 07                	jg     800bf6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bef:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d1                	jmp    800bc7 <vprintfmt+0xd6>
			goto process_precision;
  800bf6:	eb 58                	jmp    800c50 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bf8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfb:	83 f8 30             	cmp    $0x30,%eax
  800bfe:	73 17                	jae    800c17 <vprintfmt+0x126>
  800c00:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c07:	89 c0                	mov    %eax,%eax
  800c09:	48 01 d0             	add    %rdx,%rax
  800c0c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0f:	83 c2 08             	add    $0x8,%edx
  800c12:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c15:	eb 0f                	jmp    800c26 <vprintfmt+0x135>
  800c17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c1b:	48 89 d0             	mov    %rdx,%rax
  800c1e:	48 83 c2 08          	add    $0x8,%rdx
  800c22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c26:	8b 00                	mov    (%rax),%eax
  800c28:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c2b:	eb 23                	jmp    800c50 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c31:	79 0c                	jns    800c3f <vprintfmt+0x14e>
				width = 0;
  800c33:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c3a:	e9 3b ff ff ff       	jmpq   800b7a <vprintfmt+0x89>
  800c3f:	e9 36 ff ff ff       	jmpq   800b7a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c44:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c4b:	e9 2a ff ff ff       	jmpq   800b7a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c54:	79 12                	jns    800c68 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c56:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c59:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c5c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c63:	e9 12 ff ff ff       	jmpq   800b7a <vprintfmt+0x89>
  800c68:	e9 0d ff ff ff       	jmpq   800b7a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c6d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c71:	e9 04 ff ff ff       	jmpq   800b7a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c79:	83 f8 30             	cmp    $0x30,%eax
  800c7c:	73 17                	jae    800c95 <vprintfmt+0x1a4>
  800c7e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c85:	89 c0                	mov    %eax,%eax
  800c87:	48 01 d0             	add    %rdx,%rax
  800c8a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8d:	83 c2 08             	add    $0x8,%edx
  800c90:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c93:	eb 0f                	jmp    800ca4 <vprintfmt+0x1b3>
  800c95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c99:	48 89 d0             	mov    %rdx,%rax
  800c9c:	48 83 c2 08          	add    $0x8,%rdx
  800ca0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca4:	8b 10                	mov    (%rax),%edx
  800ca6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800caa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cae:	48 89 ce             	mov    %rcx,%rsi
  800cb1:	89 d7                	mov    %edx,%edi
  800cb3:	ff d0                	callq  *%rax
			break;
  800cb5:	e9 53 03 00 00       	jmpq   80100d <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbd:	83 f8 30             	cmp    $0x30,%eax
  800cc0:	73 17                	jae    800cd9 <vprintfmt+0x1e8>
  800cc2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc9:	89 c0                	mov    %eax,%eax
  800ccb:	48 01 d0             	add    %rdx,%rax
  800cce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd1:	83 c2 08             	add    $0x8,%edx
  800cd4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cd7:	eb 0f                	jmp    800ce8 <vprintfmt+0x1f7>
  800cd9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cdd:	48 89 d0             	mov    %rdx,%rax
  800ce0:	48 83 c2 08          	add    $0x8,%rdx
  800ce4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cea:	85 db                	test   %ebx,%ebx
  800cec:	79 02                	jns    800cf0 <vprintfmt+0x1ff>
				err = -err;
  800cee:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cf0:	83 fb 15             	cmp    $0x15,%ebx
  800cf3:	7f 16                	jg     800d0b <vprintfmt+0x21a>
  800cf5:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800cfc:	00 00 00 
  800cff:	48 63 d3             	movslq %ebx,%rdx
  800d02:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d06:	4d 85 e4             	test   %r12,%r12
  800d09:	75 2e                	jne    800d39 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d13:	89 d9                	mov    %ebx,%ecx
  800d15:	48 ba 21 1c 80 00 00 	movabs $0x801c21,%rdx
  800d1c:	00 00 00 
  800d1f:	48 89 c7             	mov    %rax,%rdi
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	49 b8 1c 10 80 00 00 	movabs $0x80101c,%r8
  800d2e:	00 00 00 
  800d31:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d34:	e9 d4 02 00 00       	jmpq   80100d <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d39:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d41:	4c 89 e1             	mov    %r12,%rcx
  800d44:	48 ba 2a 1c 80 00 00 	movabs $0x801c2a,%rdx
  800d4b:	00 00 00 
  800d4e:	48 89 c7             	mov    %rax,%rdi
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	49 b8 1c 10 80 00 00 	movabs $0x80101c,%r8
  800d5d:	00 00 00 
  800d60:	41 ff d0             	callq  *%r8
			break;
  800d63:	e9 a5 02 00 00       	jmpq   80100d <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6b:	83 f8 30             	cmp    $0x30,%eax
  800d6e:	73 17                	jae    800d87 <vprintfmt+0x296>
  800d70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d77:	89 c0                	mov    %eax,%eax
  800d79:	48 01 d0             	add    %rdx,%rax
  800d7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7f:	83 c2 08             	add    $0x8,%edx
  800d82:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d85:	eb 0f                	jmp    800d96 <vprintfmt+0x2a5>
  800d87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d8b:	48 89 d0             	mov    %rdx,%rax
  800d8e:	48 83 c2 08          	add    $0x8,%rdx
  800d92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d96:	4c 8b 20             	mov    (%rax),%r12
  800d99:	4d 85 e4             	test   %r12,%r12
  800d9c:	75 0a                	jne    800da8 <vprintfmt+0x2b7>
				p = "(null)";
  800d9e:	49 bc 2d 1c 80 00 00 	movabs $0x801c2d,%r12
  800da5:	00 00 00 
			if (width > 0 && padc != '-')
  800da8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dac:	7e 3f                	jle    800ded <vprintfmt+0x2fc>
  800dae:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800db2:	74 39                	je     800ded <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800db4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800db7:	48 98                	cltq   
  800db9:	48 89 c6             	mov    %rax,%rsi
  800dbc:	4c 89 e7             	mov    %r12,%rdi
  800dbf:	48 b8 c8 12 80 00 00 	movabs $0x8012c8,%rax
  800dc6:	00 00 00 
  800dc9:	ff d0                	callq  *%rax
  800dcb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dce:	eb 17                	jmp    800de7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dd0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dd4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddc:	48 89 ce             	mov    %rcx,%rsi
  800ddf:	89 d7                	mov    %edx,%edi
  800de1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800deb:	7f e3                	jg     800dd0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ded:	eb 37                	jmp    800e26 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800def:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800df3:	74 1e                	je     800e13 <vprintfmt+0x322>
  800df5:	83 fb 1f             	cmp    $0x1f,%ebx
  800df8:	7e 05                	jle    800dff <vprintfmt+0x30e>
  800dfa:	83 fb 7e             	cmp    $0x7e,%ebx
  800dfd:	7e 14                	jle    800e13 <vprintfmt+0x322>
					putch('?', putdat);
  800dff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e07:	48 89 d6             	mov    %rdx,%rsi
  800e0a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e0f:	ff d0                	callq  *%rax
  800e11:	eb 0f                	jmp    800e22 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1b:	48 89 d6             	mov    %rdx,%rsi
  800e1e:	89 df                	mov    %ebx,%edi
  800e20:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e22:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e26:	4c 89 e0             	mov    %r12,%rax
  800e29:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e2d:	0f b6 00             	movzbl (%rax),%eax
  800e30:	0f be d8             	movsbl %al,%ebx
  800e33:	85 db                	test   %ebx,%ebx
  800e35:	74 10                	je     800e47 <vprintfmt+0x356>
  800e37:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e3b:	78 b2                	js     800def <vprintfmt+0x2fe>
  800e3d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e41:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e45:	79 a8                	jns    800def <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e47:	eb 16                	jmp    800e5f <vprintfmt+0x36e>
				putch(' ', putdat);
  800e49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e51:	48 89 d6             	mov    %rdx,%rsi
  800e54:	bf 20 00 00 00       	mov    $0x20,%edi
  800e59:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e63:	7f e4                	jg     800e49 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e65:	e9 a3 01 00 00       	jmpq   80100d <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e6a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e6e:	be 03 00 00 00       	mov    $0x3,%esi
  800e73:	48 89 c7             	mov    %rax,%rdi
  800e76:	48 b8 e1 09 80 00 00 	movabs $0x8009e1,%rax
  800e7d:	00 00 00 
  800e80:	ff d0                	callq  *%rax
  800e82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8a:	48 85 c0             	test   %rax,%rax
  800e8d:	79 1d                	jns    800eac <vprintfmt+0x3bb>
				putch('-', putdat);
  800e8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e97:	48 89 d6             	mov    %rdx,%rsi
  800e9a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e9f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea5:	48 f7 d8             	neg    %rax
  800ea8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eac:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eb3:	e9 e8 00 00 00       	jmpq   800fa0 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800eb8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ebc:	be 03 00 00 00       	mov    $0x3,%esi
  800ec1:	48 89 c7             	mov    %rax,%rdi
  800ec4:	48 b8 d1 08 80 00 00 	movabs $0x8008d1,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
  800ed0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ed4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800edb:	e9 c0 00 00 00       	jmpq   800fa0 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ee0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee8:	48 89 d6             	mov    %rdx,%rsi
  800eeb:	bf 58 00 00 00       	mov    $0x58,%edi
  800ef0:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ef2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efa:	48 89 d6             	mov    %rdx,%rsi
  800efd:	bf 58 00 00 00       	mov    $0x58,%edi
  800f02:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0c:	48 89 d6             	mov    %rdx,%rsi
  800f0f:	bf 58 00 00 00       	mov    $0x58,%edi
  800f14:	ff d0                	callq  *%rax
			break;
  800f16:	e9 f2 00 00 00       	jmpq   80100d <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f23:	48 89 d6             	mov    %rdx,%rsi
  800f26:	bf 30 00 00 00       	mov    $0x30,%edi
  800f2b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f35:	48 89 d6             	mov    %rdx,%rsi
  800f38:	bf 78 00 00 00       	mov    $0x78,%edi
  800f3d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f42:	83 f8 30             	cmp    $0x30,%eax
  800f45:	73 17                	jae    800f5e <vprintfmt+0x46d>
  800f47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4e:	89 c0                	mov    %eax,%eax
  800f50:	48 01 d0             	add    %rdx,%rax
  800f53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f56:	83 c2 08             	add    $0x8,%edx
  800f59:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5c:	eb 0f                	jmp    800f6d <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f62:	48 89 d0             	mov    %rdx,%rax
  800f65:	48 83 c2 08          	add    $0x8,%rdx
  800f69:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f6d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f7b:	eb 23                	jmp    800fa0 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f81:	be 03 00 00 00       	mov    $0x3,%esi
  800f86:	48 89 c7             	mov    %rax,%rdi
  800f89:	48 b8 d1 08 80 00 00 	movabs $0x8008d1,%rax
  800f90:	00 00 00 
  800f93:	ff d0                	callq  *%rax
  800f95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f99:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fa5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fa8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800faf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb7:	45 89 c1             	mov    %r8d,%r9d
  800fba:	41 89 f8             	mov    %edi,%r8d
  800fbd:	48 89 c7             	mov    %rax,%rdi
  800fc0:	48 b8 16 08 80 00 00 	movabs $0x800816,%rax
  800fc7:	00 00 00 
  800fca:	ff d0                	callq  *%rax
			break;
  800fcc:	eb 3f                	jmp    80100d <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd6:	48 89 d6             	mov    %rdx,%rsi
  800fd9:	89 df                	mov    %ebx,%edi
  800fdb:	ff d0                	callq  *%rax
			break;
  800fdd:	eb 2e                	jmp    80100d <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe7:	48 89 d6             	mov    %rdx,%rsi
  800fea:	bf 25 00 00 00       	mov    $0x25,%edi
  800fef:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff6:	eb 05                	jmp    800ffd <vprintfmt+0x50c>
  800ff8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ffd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801001:	48 83 e8 01          	sub    $0x1,%rax
  801005:	0f b6 00             	movzbl (%rax),%eax
  801008:	3c 25                	cmp    $0x25,%al
  80100a:	75 ec                	jne    800ff8 <vprintfmt+0x507>
				/* do nothing */;
			break;
  80100c:	90                   	nop
		}
	}
  80100d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80100e:	e9 30 fb ff ff       	jmpq   800b43 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801013:	48 83 c4 60          	add    $0x60,%rsp
  801017:	5b                   	pop    %rbx
  801018:	41 5c                	pop    %r12
  80101a:	5d                   	pop    %rbp
  80101b:	c3                   	retq   

000000000080101c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80101c:	55                   	push   %rbp
  80101d:	48 89 e5             	mov    %rsp,%rbp
  801020:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801027:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80102e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801035:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80103c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801043:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80104a:	84 c0                	test   %al,%al
  80104c:	74 20                	je     80106e <printfmt+0x52>
  80104e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801052:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801056:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80105a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80105e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801062:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801066:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80106a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80106e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801075:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80107c:	00 00 00 
  80107f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801086:	00 00 00 
  801089:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801094:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010a9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010b0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010b7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010be:	48 89 c7             	mov    %rax,%rdi
  8010c1:	48 b8 f1 0a 80 00 00 	movabs $0x800af1,%rax
  8010c8:	00 00 00 
  8010cb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010cd:	c9                   	leaveq 
  8010ce:	c3                   	retq   

00000000008010cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010cf:	55                   	push   %rbp
  8010d0:	48 89 e5             	mov    %rsp,%rbp
  8010d3:	48 83 ec 10          	sub    $0x10,%rsp
  8010d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e2:	8b 40 10             	mov    0x10(%rax),%eax
  8010e5:	8d 50 01             	lea    0x1(%rax),%edx
  8010e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ec:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f3:	48 8b 10             	mov    (%rax),%rdx
  8010f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010fe:	48 39 c2             	cmp    %rax,%rdx
  801101:	73 17                	jae    80111a <sprintputch+0x4b>
		*b->buf++ = ch;
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	48 8b 00             	mov    (%rax),%rax
  80110a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80110e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801112:	48 89 0a             	mov    %rcx,(%rdx)
  801115:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801118:	88 10                	mov    %dl,(%rax)
}
  80111a:	c9                   	leaveq 
  80111b:	c3                   	retq   

000000000080111c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80111c:	55                   	push   %rbp
  80111d:	48 89 e5             	mov    %rsp,%rbp
  801120:	48 83 ec 50          	sub    $0x50,%rsp
  801124:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801128:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80112b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80112f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801133:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801137:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80113b:	48 8b 0a             	mov    (%rdx),%rcx
  80113e:	48 89 08             	mov    %rcx,(%rax)
  801141:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801145:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801149:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80114d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801151:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801155:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801159:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80115c:	48 98                	cltq   
  80115e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801162:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801166:	48 01 d0             	add    %rdx,%rax
  801169:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80116d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801174:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801179:	74 06                	je     801181 <vsnprintf+0x65>
  80117b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80117f:	7f 07                	jg     801188 <vsnprintf+0x6c>
		return -E_INVAL;
  801181:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801186:	eb 2f                	jmp    8011b7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801188:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80118c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801190:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801194:	48 89 c6             	mov    %rax,%rsi
  801197:	48 bf cf 10 80 00 00 	movabs $0x8010cf,%rdi
  80119e:	00 00 00 
  8011a1:	48 b8 f1 0a 80 00 00 	movabs $0x800af1,%rax
  8011a8:	00 00 00 
  8011ab:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011b1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011b7:	c9                   	leaveq 
  8011b8:	c3                   	retq   

00000000008011b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b9:	55                   	push   %rbp
  8011ba:	48 89 e5             	mov    %rsp,%rbp
  8011bd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011c4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011cb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011d1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011d8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011df:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011e6:	84 c0                	test   %al,%al
  8011e8:	74 20                	je     80120a <snprintf+0x51>
  8011ea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011ee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011f2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011f6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011fa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011fe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801202:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801206:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80120a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801211:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801218:	00 00 00 
  80121b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801222:	00 00 00 
  801225:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801229:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801230:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801237:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80123e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801245:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80124c:	48 8b 0a             	mov    (%rdx),%rcx
  80124f:	48 89 08             	mov    %rcx,(%rax)
  801252:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801256:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80125a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80125e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801262:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801269:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801270:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801276:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80127d:	48 89 c7             	mov    %rax,%rdi
  801280:	48 b8 1c 11 80 00 00 	movabs $0x80111c,%rax
  801287:	00 00 00 
  80128a:	ff d0                	callq  *%rax
  80128c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801292:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801298:	c9                   	leaveq 
  801299:	c3                   	retq   

000000000080129a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80129a:	55                   	push   %rbp
  80129b:	48 89 e5             	mov    %rsp,%rbp
  80129e:	48 83 ec 18          	sub    $0x18,%rsp
  8012a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ad:	eb 09                	jmp    8012b8 <strlen+0x1e>
		n++;
  8012af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	0f b6 00             	movzbl (%rax),%eax
  8012bf:	84 c0                	test   %al,%al
  8012c1:	75 ec                	jne    8012af <strlen+0x15>
		n++;
	return n;
  8012c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 20          	sub    $0x20,%rsp
  8012d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012df:	eb 0e                	jmp    8012ef <strnlen+0x27>
		n++;
  8012e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012ea:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012f4:	74 0b                	je     801301 <strnlen+0x39>
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	84 c0                	test   %al,%al
  8012ff:	75 e0                	jne    8012e1 <strnlen+0x19>
		n++;
	return n;
  801301:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801304:	c9                   	leaveq 
  801305:	c3                   	retq   

0000000000801306 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801306:	55                   	push   %rbp
  801307:	48 89 e5             	mov    %rsp,%rbp
  80130a:	48 83 ec 20          	sub    $0x20,%rsp
  80130e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801312:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80131e:	90                   	nop
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801327:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80132b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80132f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801333:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801337:	0f b6 12             	movzbl (%rdx),%edx
  80133a:	88 10                	mov    %dl,(%rax)
  80133c:	0f b6 00             	movzbl (%rax),%eax
  80133f:	84 c0                	test   %al,%al
  801341:	75 dc                	jne    80131f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801347:	c9                   	leaveq 
  801348:	c3                   	retq   

0000000000801349 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801349:	55                   	push   %rbp
  80134a:	48 89 e5             	mov    %rsp,%rbp
  80134d:	48 83 ec 20          	sub    $0x20,%rsp
  801351:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801355:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	48 89 c7             	mov    %rax,%rdi
  801360:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  801367:	00 00 00 
  80136a:	ff d0                	callq  *%rax
  80136c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80136f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801372:	48 63 d0             	movslq %eax,%rdx
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801379:	48 01 c2             	add    %rax,%rdx
  80137c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801380:	48 89 c6             	mov    %rax,%rsi
  801383:	48 89 d7             	mov    %rdx,%rdi
  801386:	48 b8 06 13 80 00 00 	movabs $0x801306,%rax
  80138d:	00 00 00 
  801390:	ff d0                	callq  *%rax
	return dst;
  801392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801396:	c9                   	leaveq 
  801397:	c3                   	retq   

0000000000801398 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801398:	55                   	push   %rbp
  801399:	48 89 e5             	mov    %rsp,%rbp
  80139c:	48 83 ec 28          	sub    $0x28,%rsp
  8013a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013b4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013bb:	00 
  8013bc:	eb 2a                	jmp    8013e8 <strncpy+0x50>
		*dst++ = *src;
  8013be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013ce:	0f b6 12             	movzbl (%rdx),%edx
  8013d1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	84 c0                	test   %al,%al
  8013dc:	74 05                	je     8013e3 <strncpy+0x4b>
			src++;
  8013de:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013f0:	72 cc                	jb     8013be <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013f6:	c9                   	leaveq 
  8013f7:	c3                   	retq   

00000000008013f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	48 83 ec 28          	sub    $0x28,%rsp
  801400:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801408:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80140c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801410:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801414:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801419:	74 3d                	je     801458 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80141b:	eb 1d                	jmp    80143a <strlcpy+0x42>
			*dst++ = *src++;
  80141d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801421:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801425:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801429:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80142d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801431:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801435:	0f b6 12             	movzbl (%rdx),%edx
  801438:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80143a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80143f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801444:	74 0b                	je     801451 <strlcpy+0x59>
  801446:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	84 c0                	test   %al,%al
  80144f:	75 cc                	jne    80141d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801455:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801458:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	48 29 c2             	sub    %rax,%rdx
  801463:	48 89 d0             	mov    %rdx,%rax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 10          	sub    $0x10,%rsp
  801470:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801474:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801478:	eb 0a                	jmp    801484 <strcmp+0x1c>
		p++, q++;
  80147a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	84 c0                	test   %al,%al
  80148d:	74 12                	je     8014a1 <strcmp+0x39>
  80148f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801493:	0f b6 10             	movzbl (%rax),%edx
  801496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149a:	0f b6 00             	movzbl (%rax),%eax
  80149d:	38 c2                	cmp    %al,%dl
  80149f:	74 d9                	je     80147a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	0f b6 d0             	movzbl %al,%edx
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014af:	0f b6 00             	movzbl (%rax),%eax
  8014b2:	0f b6 c0             	movzbl %al,%eax
  8014b5:	29 c2                	sub    %eax,%edx
  8014b7:	89 d0                	mov    %edx,%eax
}
  8014b9:	c9                   	leaveq 
  8014ba:	c3                   	retq   

00000000008014bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014bb:	55                   	push   %rbp
  8014bc:	48 89 e5             	mov    %rsp,%rbp
  8014bf:	48 83 ec 18          	sub    $0x18,%rsp
  8014c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014cf:	eb 0f                	jmp    8014e0 <strncmp+0x25>
		n--, p++, q++;
  8014d1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e5:	74 1d                	je     801504 <strncmp+0x49>
  8014e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	84 c0                	test   %al,%al
  8014f0:	74 12                	je     801504 <strncmp+0x49>
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	0f b6 10             	movzbl (%rax),%edx
  8014f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	38 c2                	cmp    %al,%dl
  801502:	74 cd                	je     8014d1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801504:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801509:	75 07                	jne    801512 <strncmp+0x57>
		return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
  801510:	eb 18                	jmp    80152a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801516:	0f b6 00             	movzbl (%rax),%eax
  801519:	0f b6 d0             	movzbl %al,%edx
  80151c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801520:	0f b6 00             	movzbl (%rax),%eax
  801523:	0f b6 c0             	movzbl %al,%eax
  801526:	29 c2                	sub    %eax,%edx
  801528:	89 d0                	mov    %edx,%eax
}
  80152a:	c9                   	leaveq 
  80152b:	c3                   	retq   

000000000080152c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	48 83 ec 0c          	sub    $0xc,%rsp
  801534:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801538:	89 f0                	mov    %esi,%eax
  80153a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80153d:	eb 17                	jmp    801556 <strchr+0x2a>
		if (*s == c)
  80153f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801543:	0f b6 00             	movzbl (%rax),%eax
  801546:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801549:	75 06                	jne    801551 <strchr+0x25>
			return (char *) s;
  80154b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154f:	eb 15                	jmp    801566 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801551:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	0f b6 00             	movzbl (%rax),%eax
  80155d:	84 c0                	test   %al,%al
  80155f:	75 de                	jne    80153f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801566:	c9                   	leaveq 
  801567:	c3                   	retq   

0000000000801568 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	48 83 ec 0c          	sub    $0xc,%rsp
  801570:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801574:	89 f0                	mov    %esi,%eax
  801576:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801579:	eb 13                	jmp    80158e <strfind+0x26>
		if (*s == c)
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157f:	0f b6 00             	movzbl (%rax),%eax
  801582:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801585:	75 02                	jne    801589 <strfind+0x21>
			break;
  801587:	eb 10                	jmp    801599 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801589:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	84 c0                	test   %al,%al
  801597:	75 e2                	jne    80157b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80159d:	c9                   	leaveq 
  80159e:	c3                   	retq   

000000000080159f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80159f:	55                   	push   %rbp
  8015a0:	48 89 e5             	mov    %rsp,%rbp
  8015a3:	48 83 ec 18          	sub    $0x18,%rsp
  8015a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ab:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b7:	75 06                	jne    8015bf <memset+0x20>
		return v;
  8015b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bd:	eb 69                	jmp    801628 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	83 e0 03             	and    $0x3,%eax
  8015c6:	48 85 c0             	test   %rax,%rax
  8015c9:	75 48                	jne    801613 <memset+0x74>
  8015cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cf:	83 e0 03             	and    $0x3,%eax
  8015d2:	48 85 c0             	test   %rax,%rax
  8015d5:	75 3c                	jne    801613 <memset+0x74>
		c &= 0xFF;
  8015d7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e1:	c1 e0 18             	shl    $0x18,%eax
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e9:	c1 e0 10             	shl    $0x10,%eax
  8015ec:	09 c2                	or     %eax,%edx
  8015ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f1:	c1 e0 08             	shl    $0x8,%eax
  8015f4:	09 d0                	or     %edx,%eax
  8015f6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fd:	48 c1 e8 02          	shr    $0x2,%rax
  801601:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801604:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801608:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160b:	48 89 d7             	mov    %rdx,%rdi
  80160e:	fc                   	cld    
  80160f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801611:	eb 11                	jmp    801624 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801613:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801617:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80161a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80161e:	48 89 d7             	mov    %rdx,%rdi
  801621:	fc                   	cld    
  801622:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 28          	sub    $0x28,%rsp
  801632:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801636:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80163a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80163e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801642:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80164e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801652:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801656:	0f 83 88 00 00 00    	jae    8016e4 <memmove+0xba>
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801664:	48 01 d0             	add    %rdx,%rax
  801667:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80166b:	76 77                	jbe    8016e4 <memmove+0xba>
		s += n;
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801675:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801679:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80167d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801681:	83 e0 03             	and    $0x3,%eax
  801684:	48 85 c0             	test   %rax,%rax
  801687:	75 3b                	jne    8016c4 <memmove+0x9a>
  801689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168d:	83 e0 03             	and    $0x3,%eax
  801690:	48 85 c0             	test   %rax,%rax
  801693:	75 2f                	jne    8016c4 <memmove+0x9a>
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	83 e0 03             	and    $0x3,%eax
  80169c:	48 85 c0             	test   %rax,%rax
  80169f:	75 23                	jne    8016c4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a5:	48 83 e8 04          	sub    $0x4,%rax
  8016a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ad:	48 83 ea 04          	sub    $0x4,%rdx
  8016b1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016b5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016b9:	48 89 c7             	mov    %rax,%rdi
  8016bc:	48 89 d6             	mov    %rdx,%rsi
  8016bf:	fd                   	std    
  8016c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016c2:	eb 1d                	jmp    8016e1 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	48 89 d7             	mov    %rdx,%rdi
  8016db:	48 89 c1             	mov    %rax,%rcx
  8016de:	fd                   	std    
  8016df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016e1:	fc                   	cld    
  8016e2:	eb 57                	jmp    80173b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e8:	83 e0 03             	and    $0x3,%eax
  8016eb:	48 85 c0             	test   %rax,%rax
  8016ee:	75 36                	jne    801726 <memmove+0xfc>
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	83 e0 03             	and    $0x3,%eax
  8016f7:	48 85 c0             	test   %rax,%rax
  8016fa:	75 2a                	jne    801726 <memmove+0xfc>
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	83 e0 03             	and    $0x3,%eax
  801703:	48 85 c0             	test   %rax,%rax
  801706:	75 1e                	jne    801726 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	48 c1 e8 02          	shr    $0x2,%rax
  801710:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801717:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171b:	48 89 c7             	mov    %rax,%rdi
  80171e:	48 89 d6             	mov    %rdx,%rsi
  801721:	fc                   	cld    
  801722:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801724:	eb 15                	jmp    80173b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80172e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801732:	48 89 c7             	mov    %rax,%rdi
  801735:	48 89 d6             	mov    %rdx,%rsi
  801738:	fc                   	cld    
  801739:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80173b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 18          	sub    $0x18,%rsp
  801749:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80174d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801751:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801759:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80175d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801761:	48 89 ce             	mov    %rcx,%rsi
  801764:	48 89 c7             	mov    %rax,%rdi
  801767:	48 b8 2a 16 80 00 00 	movabs $0x80162a,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
}
  801773:	c9                   	leaveq 
  801774:	c3                   	retq   

0000000000801775 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	48 83 ec 28          	sub    $0x28,%rsp
  80177d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801781:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801785:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801791:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801795:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801799:	eb 36                	jmp    8017d1 <memcmp+0x5c>
		if (*s1 != *s2)
  80179b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179f:	0f b6 10             	movzbl (%rax),%edx
  8017a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a6:	0f b6 00             	movzbl (%rax),%eax
  8017a9:	38 c2                	cmp    %al,%dl
  8017ab:	74 1a                	je     8017c7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	0f b6 d0             	movzbl %al,%edx
  8017b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bb:	0f b6 00             	movzbl (%rax),%eax
  8017be:	0f b6 c0             	movzbl %al,%eax
  8017c1:	29 c2                	sub    %eax,%edx
  8017c3:	89 d0                	mov    %edx,%eax
  8017c5:	eb 20                	jmp    8017e7 <memcmp+0x72>
		s1++, s2++;
  8017c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017dd:	48 85 c0             	test   %rax,%rax
  8017e0:	75 b9                	jne    80179b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leaveq 
  8017e8:	c3                   	retq   

00000000008017e9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017e9:	55                   	push   %rbp
  8017ea:	48 89 e5             	mov    %rsp,%rbp
  8017ed:	48 83 ec 28          	sub    $0x28,%rsp
  8017f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801804:	48 01 d0             	add    %rdx,%rax
  801807:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80180b:	eb 15                	jmp    801822 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80180d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801811:	0f b6 10             	movzbl (%rax),%edx
  801814:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801817:	38 c2                	cmp    %al,%dl
  801819:	75 02                	jne    80181d <memfind+0x34>
			break;
  80181b:	eb 0f                	jmp    80182c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80181d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801826:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80182a:	72 e1                	jb     80180d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80182c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 34          	sub    $0x34,%rsp
  80183a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80183e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801842:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801845:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80184c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801853:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801854:	eb 05                	jmp    80185b <strtol+0x29>
		s++;
  801856:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	3c 20                	cmp    $0x20,%al
  801864:	74 f0                	je     801856 <strtol+0x24>
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	3c 09                	cmp    $0x9,%al
  80186f:	74 e5                	je     801856 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	0f b6 00             	movzbl (%rax),%eax
  801878:	3c 2b                	cmp    $0x2b,%al
  80187a:	75 07                	jne    801883 <strtol+0x51>
		s++;
  80187c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801881:	eb 17                	jmp    80189a <strtol+0x68>
	else if (*s == '-')
  801883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801887:	0f b6 00             	movzbl (%rax),%eax
  80188a:	3c 2d                	cmp    $0x2d,%al
  80188c:	75 0c                	jne    80189a <strtol+0x68>
		s++, neg = 1;
  80188e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801893:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80189a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80189e:	74 06                	je     8018a6 <strtol+0x74>
  8018a0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018a4:	75 28                	jne    8018ce <strtol+0x9c>
  8018a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018aa:	0f b6 00             	movzbl (%rax),%eax
  8018ad:	3c 30                	cmp    $0x30,%al
  8018af:	75 1d                	jne    8018ce <strtol+0x9c>
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	48 83 c0 01          	add    $0x1,%rax
  8018b9:	0f b6 00             	movzbl (%rax),%eax
  8018bc:	3c 78                	cmp    $0x78,%al
  8018be:	75 0e                	jne    8018ce <strtol+0x9c>
		s += 2, base = 16;
  8018c0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018c5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018cc:	eb 2c                	jmp    8018fa <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d2:	75 19                	jne    8018ed <strtol+0xbb>
  8018d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	3c 30                	cmp    $0x30,%al
  8018dd:	75 0e                	jne    8018ed <strtol+0xbb>
		s++, base = 8;
  8018df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018e4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018eb:	eb 0d                	jmp    8018fa <strtol+0xc8>
	else if (base == 0)
  8018ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018f1:	75 07                	jne    8018fa <strtol+0xc8>
		base = 10;
  8018f3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fe:	0f b6 00             	movzbl (%rax),%eax
  801901:	3c 2f                	cmp    $0x2f,%al
  801903:	7e 1d                	jle    801922 <strtol+0xf0>
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	3c 39                	cmp    $0x39,%al
  80190e:	7f 12                	jg     801922 <strtol+0xf0>
			dig = *s - '0';
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 30             	sub    $0x30,%eax
  80191d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801920:	eb 4e                	jmp    801970 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	3c 60                	cmp    $0x60,%al
  80192b:	7e 1d                	jle    80194a <strtol+0x118>
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 7a                	cmp    $0x7a,%al
  801936:	7f 12                	jg     80194a <strtol+0x118>
			dig = *s - 'a' + 10;
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	0f be c0             	movsbl %al,%eax
  801942:	83 e8 57             	sub    $0x57,%eax
  801945:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801948:	eb 26                	jmp    801970 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80194a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194e:	0f b6 00             	movzbl (%rax),%eax
  801951:	3c 40                	cmp    $0x40,%al
  801953:	7e 48                	jle    80199d <strtol+0x16b>
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	3c 5a                	cmp    $0x5a,%al
  80195e:	7f 3d                	jg     80199d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	0f be c0             	movsbl %al,%eax
  80196a:	83 e8 37             	sub    $0x37,%eax
  80196d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801970:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801973:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801976:	7c 02                	jl     80197a <strtol+0x148>
			break;
  801978:	eb 23                	jmp    80199d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80197a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80197f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801982:	48 98                	cltq   
  801984:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801989:	48 89 c2             	mov    %rax,%rdx
  80198c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80198f:	48 98                	cltq   
  801991:	48 01 d0             	add    %rdx,%rax
  801994:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801998:	e9 5d ff ff ff       	jmpq   8018fa <strtol+0xc8>

	if (endptr)
  80199d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019a2:	74 0b                	je     8019af <strtol+0x17d>
		*endptr = (char *) s;
  8019a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019ac:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019b3:	74 09                	je     8019be <strtol+0x18c>
  8019b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b9:	48 f7 d8             	neg    %rax
  8019bc:	eb 04                	jmp    8019c2 <strtol+0x190>
  8019be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 30          	sub    $0x30,%rsp
  8019cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8019d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019e0:	0f b6 00             	movzbl (%rax),%eax
  8019e3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019e6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019ea:	75 06                	jne    8019f2 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f0:	eb 6b                	jmp    801a5d <strstr+0x99>

	len = strlen(str);
  8019f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019f6:	48 89 c7             	mov    %rax,%rdi
  8019f9:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  801a00:	00 00 00 
  801a03:	ff d0                	callq  *%rax
  801a05:	48 98                	cltq   
  801a07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a17:	0f b6 00             	movzbl (%rax),%eax
  801a1a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a1d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a21:	75 07                	jne    801a2a <strstr+0x66>
				return (char *) 0;
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
  801a28:	eb 33                	jmp    801a5d <strstr+0x99>
		} while (sc != c);
  801a2a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a2e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a31:	75 d8                	jne    801a0b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801a33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a37:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3f:	48 89 ce             	mov    %rcx,%rsi
  801a42:	48 89 c7             	mov    %rax,%rdi
  801a45:	48 b8 bb 14 80 00 00 	movabs $0x8014bb,%rax
  801a4c:	00 00 00 
  801a4f:	ff d0                	callq  *%rax
  801a51:	85 c0                	test   %eax,%eax
  801a53:	75 b6                	jne    801a0b <strstr+0x47>

	return (char *) (in - 1);
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	48 83 e8 01          	sub    $0x1,%rax
}
  801a5d:	c9                   	leaveq 
  801a5e:	c3                   	retq   
