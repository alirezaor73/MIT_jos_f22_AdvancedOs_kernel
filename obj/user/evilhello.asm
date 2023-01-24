
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
  800061:	48 b8 74 01 80 00 00 	movabs $0x800174,%rax
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
  800073:	48 83 ec 10          	sub    $0x10,%rsp
  800077:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80007a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80007e:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800085:	00 00 00 
  800088:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800093:	7e 14                	jle    8000a9 <libmain+0x3a>
		binaryname = argv[0];
  800095:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800099:	48 8b 10             	mov    (%rax),%rdx
  80009c:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000a3:	00 00 00 
  8000a6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b0:	48 89 d6             	mov    %rdx,%rsi
  8000b3:	89 c7                	mov    %eax,%edi
  8000b5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000bc:	00 00 00 
  8000bf:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000c1:	48 b8 cf 00 80 00 00 	movabs $0x8000cf,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	callq  *%rax
}
  8000cd:	c9                   	leaveq 
  8000ce:	c3                   	retq   

00000000008000cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000cf:	55                   	push   %rbp
  8000d0:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8000d8:	48 b8 fc 01 80 00 00 	movabs $0x8001fc,%rax
  8000df:	00 00 00 
  8000e2:	ff d0                	callq  *%rax
}
  8000e4:	5d                   	pop    %rbp
  8000e5:	c3                   	retq   

00000000008000e6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000e6:	55                   	push   %rbp
  8000e7:	48 89 e5             	mov    %rsp,%rbp
  8000ea:	53                   	push   %rbx
  8000eb:	48 83 ec 48          	sub    $0x48,%rsp
  8000ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000f2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000f5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000f9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8000fd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800101:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800105:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800108:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80010c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800110:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800114:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800118:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80011c:	4c 89 c3             	mov    %r8,%rbx
  80011f:	cd 30                	int    $0x30
  800121:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800125:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800129:	74 3e                	je     800169 <syscall+0x83>
  80012b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800130:	7e 37                	jle    800169 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800132:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800136:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800139:	49 89 d0             	mov    %rdx,%r8
  80013c:	89 c1                	mov    %eax,%ecx
  80013e:	48 ba ea 17 80 00 00 	movabs $0x8017ea,%rdx
  800145:	00 00 00 
  800148:	be 23 00 00 00       	mov    $0x23,%esi
  80014d:	48 bf 07 18 80 00 00 	movabs $0x801807,%rdi
  800154:	00 00 00 
  800157:	b8 00 00 00 00       	mov    $0x0,%eax
  80015c:	49 b9 7e 02 80 00 00 	movabs $0x80027e,%r9
  800163:	00 00 00 
  800166:	41 ff d1             	callq  *%r9

	return ret;
  800169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80016d:	48 83 c4 48          	add    $0x48,%rsp
  800171:	5b                   	pop    %rbx
  800172:	5d                   	pop    %rbp
  800173:	c3                   	retq   

0000000000800174 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800174:	55                   	push   %rbp
  800175:	48 89 e5             	mov    %rsp,%rbp
  800178:	48 83 ec 20          	sub    $0x20,%rsp
  80017c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800180:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800188:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800193:	00 
  800194:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80019a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001a0:	48 89 d1             	mov    %rdx,%rcx
  8001a3:	48 89 c2             	mov    %rax,%rdx
  8001a6:	be 00 00 00 00       	mov    $0x0,%esi
  8001ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b0:	48 b8 e6 00 80 00 00 	movabs $0x8000e6,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
}
  8001bc:	c9                   	leaveq 
  8001bd:	c3                   	retq   

00000000008001be <sys_cgetc>:

int
sys_cgetc(void)
{
  8001be:	55                   	push   %rbp
  8001bf:	48 89 e5             	mov    %rsp,%rbp
  8001c2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001cd:	00 
  8001ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001df:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e4:	be 00 00 00 00       	mov    $0x0,%esi
  8001e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8001ee:	48 b8 e6 00 80 00 00 	movabs $0x8000e6,%rax
  8001f5:	00 00 00 
  8001f8:	ff d0                	callq  *%rax
}
  8001fa:	c9                   	leaveq 
  8001fb:	c3                   	retq   

00000000008001fc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001fc:	55                   	push   %rbp
  8001fd:	48 89 e5             	mov    %rsp,%rbp
  800200:	48 83 ec 10          	sub    $0x10,%rsp
  800204:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800207:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020a:	48 98                	cltq   
  80020c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800213:	00 
  800214:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80021a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800220:	b9 00 00 00 00       	mov    $0x0,%ecx
  800225:	48 89 c2             	mov    %rax,%rdx
  800228:	be 01 00 00 00       	mov    $0x1,%esi
  80022d:	bf 03 00 00 00       	mov    $0x3,%edi
  800232:	48 b8 e6 00 80 00 00 	movabs $0x8000e6,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
  800244:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800248:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80024f:	00 
  800250:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800256:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80025c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800261:	ba 00 00 00 00       	mov    $0x0,%edx
  800266:	be 00 00 00 00       	mov    $0x0,%esi
  80026b:	bf 02 00 00 00       	mov    $0x2,%edi
  800270:	48 b8 e6 00 80 00 00 	movabs $0x8000e6,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
}
  80027c:	c9                   	leaveq 
  80027d:	c3                   	retq   

000000000080027e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027e:	55                   	push   %rbp
  80027f:	48 89 e5             	mov    %rsp,%rbp
  800282:	53                   	push   %rbx
  800283:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80028a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800291:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800297:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80029e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002ac:	84 c0                	test   %al,%al
  8002ae:	74 23                	je     8002d3 <_panic+0x55>
  8002b0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002b7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002bb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002bf:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002c7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002cb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002cf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002d3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002da:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002e1:	00 00 00 
  8002e4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002eb:	00 00 00 
  8002ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002f9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800300:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800307:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80030e:	00 00 00 
  800311:	48 8b 18             	mov    (%rax),%rbx
  800314:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  80031b:	00 00 00 
  80031e:	ff d0                	callq  *%rax
  800320:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800326:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80032d:	41 89 c8             	mov    %ecx,%r8d
  800330:	48 89 d1             	mov    %rdx,%rcx
  800333:	48 89 da             	mov    %rbx,%rdx
  800336:	89 c6                	mov    %eax,%esi
  800338:	48 bf 18 18 80 00 00 	movabs $0x801818,%rdi
  80033f:	00 00 00 
  800342:	b8 00 00 00 00       	mov    $0x0,%eax
  800347:	49 b9 b7 04 80 00 00 	movabs $0x8004b7,%r9
  80034e:	00 00 00 
  800351:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800354:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80035b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800362:	48 89 d6             	mov    %rdx,%rsi
  800365:	48 89 c7             	mov    %rax,%rdi
  800368:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  80036f:	00 00 00 
  800372:	ff d0                	callq  *%rax
	cprintf("\n");
  800374:	48 bf 3b 18 80 00 00 	movabs $0x80183b,%rdi
  80037b:	00 00 00 
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	48 ba b7 04 80 00 00 	movabs $0x8004b7,%rdx
  80038a:	00 00 00 
  80038d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038f:	cc                   	int3   
  800390:	eb fd                	jmp    80038f <_panic+0x111>

0000000000800392 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800392:	55                   	push   %rbp
  800393:	48 89 e5             	mov    %rsp,%rbp
  800396:	48 83 ec 10          	sub    $0x10,%rsp
  80039a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a5:	8b 00                	mov    (%rax),%eax
  8003a7:	8d 48 01             	lea    0x1(%rax),%ecx
  8003aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ae:	89 0a                	mov    %ecx,(%rdx)
  8003b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003b3:	89 d1                	mov    %edx,%ecx
  8003b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b9:	48 98                	cltq   
  8003bb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c3:	8b 00                	mov    (%rax),%eax
  8003c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ca:	75 2c                	jne    8003f8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d0:	8b 00                	mov    (%rax),%eax
  8003d2:	48 98                	cltq   
  8003d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d8:	48 83 c2 08          	add    $0x8,%rdx
  8003dc:	48 89 c6             	mov    %rax,%rsi
  8003df:	48 89 d7             	mov    %rdx,%rdi
  8003e2:	48 b8 74 01 80 00 00 	movabs $0x800174,%rax
  8003e9:	00 00 00 
  8003ec:	ff d0                	callq  *%rax
        b->idx = 0;
  8003ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fc:	8b 40 04             	mov    0x4(%rax),%eax
  8003ff:	8d 50 01             	lea    0x1(%rax),%edx
  800402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800406:	89 50 04             	mov    %edx,0x4(%rax)
}
  800409:	c9                   	leaveq 
  80040a:	c3                   	retq   

000000000080040b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80040b:	55                   	push   %rbp
  80040c:	48 89 e5             	mov    %rsp,%rbp
  80040f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800416:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80041d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800424:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80042b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800432:	48 8b 0a             	mov    (%rdx),%rcx
  800435:	48 89 08             	mov    %rcx,(%rax)
  800438:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80043c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800440:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800444:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800448:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80044f:	00 00 00 
    b.cnt = 0;
  800452:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800459:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80045c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800463:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80046a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800471:	48 89 c6             	mov    %rax,%rsi
  800474:	48 bf 92 03 80 00 00 	movabs $0x800392,%rdi
  80047b:	00 00 00 
  80047e:	48 b8 6a 08 80 00 00 	movabs $0x80086a,%rax
  800485:	00 00 00 
  800488:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80048a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800490:	48 98                	cltq   
  800492:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800499:	48 83 c2 08          	add    $0x8,%rdx
  80049d:	48 89 c6             	mov    %rax,%rsi
  8004a0:	48 89 d7             	mov    %rdx,%rdi
  8004a3:	48 b8 74 01 80 00 00 	movabs $0x800174,%rax
  8004aa:	00 00 00 
  8004ad:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004af:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b5:	c9                   	leaveq 
  8004b6:	c3                   	retq   

00000000008004b7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004b7:	55                   	push   %rbp
  8004b8:	48 89 e5             	mov    %rsp,%rbp
  8004bb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004c2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004d0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004d7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004de:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e5:	84 c0                	test   %al,%al
  8004e7:	74 20                	je     800509 <cprintf+0x52>
  8004e9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004ed:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004f1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004fd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800501:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800505:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800509:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800510:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800517:	00 00 00 
  80051a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800521:	00 00 00 
  800524:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800528:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80052f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800536:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80053d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800544:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80054b:	48 8b 0a             	mov    (%rdx),%rcx
  80054e:	48 89 08             	mov    %rcx,(%rax)
  800551:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800555:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800559:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80055d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800561:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800568:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80056f:	48 89 d6             	mov    %rdx,%rsi
  800572:	48 89 c7             	mov    %rax,%rdi
  800575:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
  800581:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800587:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80058d:	c9                   	leaveq 
  80058e:	c3                   	retq   

000000000080058f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058f:	55                   	push   %rbp
  800590:	48 89 e5             	mov    %rsp,%rbp
  800593:	53                   	push   %rbx
  800594:	48 83 ec 38          	sub    $0x38,%rsp
  800598:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80059c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005a4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005a7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005ab:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005af:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005b2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005b6:	77 3b                	ja     8005f3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005bb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005bf:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	48 f7 f3             	div    %rbx
  8005ce:	48 89 c2             	mov    %rax,%rdx
  8005d1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005d4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005d7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005df:	41 89 f9             	mov    %edi,%r9d
  8005e2:	48 89 c7             	mov    %rax,%rdi
  8005e5:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  8005ec:	00 00 00 
  8005ef:	ff d0                	callq  *%rax
  8005f1:	eb 1e                	jmp    800611 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f3:	eb 12                	jmp    800607 <printnum+0x78>
			putch(padc, putdat);
  8005f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005f9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	48 89 ce             	mov    %rcx,%rsi
  800603:	89 d7                	mov    %edx,%edi
  800605:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800607:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80060b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80060f:	7f e4                	jg     8005f5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800618:	ba 00 00 00 00       	mov    $0x0,%edx
  80061d:	48 f7 f1             	div    %rcx
  800620:	48 89 d0             	mov    %rdx,%rax
  800623:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
  80062a:	00 00 00 
  80062d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800631:	0f be d0             	movsbl %al,%edx
  800634:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	48 89 ce             	mov    %rcx,%rsi
  80063f:	89 d7                	mov    %edx,%edi
  800641:	ff d0                	callq  *%rax
}
  800643:	48 83 c4 38          	add    $0x38,%rsp
  800647:	5b                   	pop    %rbx
  800648:	5d                   	pop    %rbp
  800649:	c3                   	retq   

000000000080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %rbp
  80064b:	48 89 e5             	mov    %rsp,%rbp
  80064e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800652:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800656:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800659:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80065d:	7e 52                	jle    8006b1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	83 f8 30             	cmp    $0x30,%eax
  800668:	73 24                	jae    80068e <getuint+0x44>
  80066a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800676:	8b 00                	mov    (%rax),%eax
  800678:	89 c0                	mov    %eax,%eax
  80067a:	48 01 d0             	add    %rdx,%rax
  80067d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800681:	8b 12                	mov    (%rdx),%edx
  800683:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068a:	89 0a                	mov    %ecx,(%rdx)
  80068c:	eb 17                	jmp    8006a5 <getuint+0x5b>
  80068e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800692:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800696:	48 89 d0             	mov    %rdx,%rax
  800699:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a5:	48 8b 00             	mov    (%rax),%rax
  8006a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ac:	e9 a3 00 00 00       	jmpq   800754 <getuint+0x10a>
	else if (lflag)
  8006b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006b5:	74 4f                	je     800706 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bb:	8b 00                	mov    (%rax),%eax
  8006bd:	83 f8 30             	cmp    $0x30,%eax
  8006c0:	73 24                	jae    8006e6 <getuint+0x9c>
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ce:	8b 00                	mov    (%rax),%eax
  8006d0:	89 c0                	mov    %eax,%eax
  8006d2:	48 01 d0             	add    %rdx,%rax
  8006d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d9:	8b 12                	mov    (%rdx),%edx
  8006db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e2:	89 0a                	mov    %ecx,(%rdx)
  8006e4:	eb 17                	jmp    8006fd <getuint+0xb3>
  8006e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ee:	48 89 d0             	mov    %rdx,%rax
  8006f1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fd:	48 8b 00             	mov    (%rax),%rax
  800700:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800704:	eb 4e                	jmp    800754 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070a:	8b 00                	mov    (%rax),%eax
  80070c:	83 f8 30             	cmp    $0x30,%eax
  80070f:	73 24                	jae    800735 <getuint+0xeb>
  800711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800715:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071d:	8b 00                	mov    (%rax),%eax
  80071f:	89 c0                	mov    %eax,%eax
  800721:	48 01 d0             	add    %rdx,%rax
  800724:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800728:	8b 12                	mov    (%rdx),%edx
  80072a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80072d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800731:	89 0a                	mov    %ecx,(%rdx)
  800733:	eb 17                	jmp    80074c <getuint+0x102>
  800735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800739:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80073d:	48 89 d0             	mov    %rdx,%rax
  800740:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800744:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800748:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	89 c0                	mov    %eax,%eax
  800750:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800758:	c9                   	leaveq 
  800759:	c3                   	retq   

000000000080075a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075a:	55                   	push   %rbp
  80075b:	48 89 e5             	mov    %rsp,%rbp
  80075e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800762:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800766:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800769:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076d:	7e 52                	jle    8007c1 <getint+0x67>
		x=va_arg(*ap, long long);
  80076f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800773:	8b 00                	mov    (%rax),%eax
  800775:	83 f8 30             	cmp    $0x30,%eax
  800778:	73 24                	jae    80079e <getint+0x44>
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	8b 00                	mov    (%rax),%eax
  800788:	89 c0                	mov    %eax,%eax
  80078a:	48 01 d0             	add    %rdx,%rax
  80078d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800791:	8b 12                	mov    (%rdx),%edx
  800793:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800796:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079a:	89 0a                	mov    %ecx,(%rdx)
  80079c:	eb 17                	jmp    8007b5 <getint+0x5b>
  80079e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a6:	48 89 d0             	mov    %rdx,%rax
  8007a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b5:	48 8b 00             	mov    (%rax),%rax
  8007b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007bc:	e9 a3 00 00 00       	jmpq   800864 <getint+0x10a>
	else if (lflag)
  8007c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c5:	74 4f                	je     800816 <getint+0xbc>
		x=va_arg(*ap, long);
  8007c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cb:	8b 00                	mov    (%rax),%eax
  8007cd:	83 f8 30             	cmp    $0x30,%eax
  8007d0:	73 24                	jae    8007f6 <getint+0x9c>
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	8b 00                	mov    (%rax),%eax
  8007e0:	89 c0                	mov    %eax,%eax
  8007e2:	48 01 d0             	add    %rdx,%rax
  8007e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e9:	8b 12                	mov    (%rdx),%edx
  8007eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f2:	89 0a                	mov    %ecx,(%rdx)
  8007f4:	eb 17                	jmp    80080d <getint+0xb3>
  8007f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fe:	48 89 d0             	mov    %rdx,%rax
  800801:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800809:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080d:	48 8b 00             	mov    (%rax),%rax
  800810:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800814:	eb 4e                	jmp    800864 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081a:	8b 00                	mov    (%rax),%eax
  80081c:	83 f8 30             	cmp    $0x30,%eax
  80081f:	73 24                	jae    800845 <getint+0xeb>
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082d:	8b 00                	mov    (%rax),%eax
  80082f:	89 c0                	mov    %eax,%eax
  800831:	48 01 d0             	add    %rdx,%rax
  800834:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800838:	8b 12                	mov    (%rdx),%edx
  80083a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800841:	89 0a                	mov    %ecx,(%rdx)
  800843:	eb 17                	jmp    80085c <getint+0x102>
  800845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800849:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084d:	48 89 d0             	mov    %rdx,%rax
  800850:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800854:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800858:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085c:	8b 00                	mov    (%rax),%eax
  80085e:	48 98                	cltq   
  800860:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800864:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800868:	c9                   	leaveq 
  800869:	c3                   	retq   

000000000080086a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80086a:	55                   	push   %rbp
  80086b:	48 89 e5             	mov    %rsp,%rbp
  80086e:	41 54                	push   %r12
  800870:	53                   	push   %rbx
  800871:	48 83 ec 60          	sub    $0x60,%rsp
  800875:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800879:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80087d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800881:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800885:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800889:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80088d:	48 8b 0a             	mov    (%rdx),%rcx
  800890:	48 89 08             	mov    %rcx,(%rax)
  800893:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800897:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80089b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80089f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	eb 17                	jmp    8008bc <vprintfmt+0x52>
			if (ch == '\0')
  8008a5:	85 db                	test   %ebx,%ebx
  8008a7:	0f 84 df 04 00 00    	je     800d8c <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b5:	48 89 d6             	mov    %rdx,%rsi
  8008b8:	89 df                	mov    %ebx,%edi
  8008ba:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c8:	0f b6 00             	movzbl (%rax),%eax
  8008cb:	0f b6 d8             	movzbl %al,%ebx
  8008ce:	83 fb 25             	cmp    $0x25,%ebx
  8008d1:	75 d2                	jne    8008a5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008d7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008de:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008ec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ff:	0f b6 00             	movzbl (%rax),%eax
  800902:	0f b6 d8             	movzbl %al,%ebx
  800905:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800908:	83 f8 55             	cmp    $0x55,%eax
  80090b:	0f 87 47 04 00 00    	ja     800d58 <vprintfmt+0x4ee>
  800911:	89 c0                	mov    %eax,%eax
  800913:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80091a:	00 
  80091b:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  800922:	00 00 00 
  800925:	48 01 d0             	add    %rdx,%rax
  800928:	48 8b 00             	mov    (%rax),%rax
  80092b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80092d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800931:	eb c0                	jmp    8008f3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800933:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800937:	eb ba                	jmp    8008f3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800939:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800940:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800943:	89 d0                	mov    %edx,%eax
  800945:	c1 e0 02             	shl    $0x2,%eax
  800948:	01 d0                	add    %edx,%eax
  80094a:	01 c0                	add    %eax,%eax
  80094c:	01 d8                	add    %ebx,%eax
  80094e:	83 e8 30             	sub    $0x30,%eax
  800951:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800954:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800958:	0f b6 00             	movzbl (%rax),%eax
  80095b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80095e:	83 fb 2f             	cmp    $0x2f,%ebx
  800961:	7e 0c                	jle    80096f <vprintfmt+0x105>
  800963:	83 fb 39             	cmp    $0x39,%ebx
  800966:	7f 07                	jg     80096f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800968:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80096d:	eb d1                	jmp    800940 <vprintfmt+0xd6>
			goto process_precision;
  80096f:	eb 58                	jmp    8009c9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800971:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800974:	83 f8 30             	cmp    $0x30,%eax
  800977:	73 17                	jae    800990 <vprintfmt+0x126>
  800979:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80097d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800980:	89 c0                	mov    %eax,%eax
  800982:	48 01 d0             	add    %rdx,%rax
  800985:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800988:	83 c2 08             	add    $0x8,%edx
  80098b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80098e:	eb 0f                	jmp    80099f <vprintfmt+0x135>
  800990:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800994:	48 89 d0             	mov    %rdx,%rax
  800997:	48 83 c2 08          	add    $0x8,%rdx
  80099b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80099f:	8b 00                	mov    (%rax),%eax
  8009a1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009a4:	eb 23                	jmp    8009c9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009aa:	79 0c                	jns    8009b8 <vprintfmt+0x14e>
				width = 0;
  8009ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009b3:	e9 3b ff ff ff       	jmpq   8008f3 <vprintfmt+0x89>
  8009b8:	e9 36 ff ff ff       	jmpq   8008f3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009bd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009c4:	e9 2a ff ff ff       	jmpq   8008f3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cd:	79 12                	jns    8009e1 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009cf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009dc:	e9 12 ff ff ff       	jmpq   8008f3 <vprintfmt+0x89>
  8009e1:	e9 0d ff ff ff       	jmpq   8008f3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009ea:	e9 04 ff ff ff       	jmpq   8008f3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	83 f8 30             	cmp    $0x30,%eax
  8009f5:	73 17                	jae    800a0e <vprintfmt+0x1a4>
  8009f7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fe:	89 c0                	mov    %eax,%eax
  800a00:	48 01 d0             	add    %rdx,%rax
  800a03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a06:	83 c2 08             	add    $0x8,%edx
  800a09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0c:	eb 0f                	jmp    800a1d <vprintfmt+0x1b3>
  800a0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a12:	48 89 d0             	mov    %rdx,%rax
  800a15:	48 83 c2 08          	add    $0x8,%rdx
  800a19:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1d:	8b 10                	mov    (%rax),%edx
  800a1f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a27:	48 89 ce             	mov    %rcx,%rsi
  800a2a:	89 d7                	mov    %edx,%edi
  800a2c:	ff d0                	callq  *%rax
			break;
  800a2e:	e9 53 03 00 00       	jmpq   800d86 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a36:	83 f8 30             	cmp    $0x30,%eax
  800a39:	73 17                	jae    800a52 <vprintfmt+0x1e8>
  800a3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a42:	89 c0                	mov    %eax,%eax
  800a44:	48 01 d0             	add    %rdx,%rax
  800a47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4a:	83 c2 08             	add    $0x8,%edx
  800a4d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a50:	eb 0f                	jmp    800a61 <vprintfmt+0x1f7>
  800a52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a56:	48 89 d0             	mov    %rdx,%rax
  800a59:	48 83 c2 08          	add    $0x8,%rdx
  800a5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a61:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a63:	85 db                	test   %ebx,%ebx
  800a65:	79 02                	jns    800a69 <vprintfmt+0x1ff>
				err = -err;
  800a67:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a69:	83 fb 15             	cmp    $0x15,%ebx
  800a6c:	7f 16                	jg     800a84 <vprintfmt+0x21a>
  800a6e:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  800a75:	00 00 00 
  800a78:	48 63 d3             	movslq %ebx,%rdx
  800a7b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a7f:	4d 85 e4             	test   %r12,%r12
  800a82:	75 2e                	jne    800ab2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8c:	89 d9                	mov    %ebx,%ecx
  800a8e:	48 ba 81 19 80 00 00 	movabs $0x801981,%rdx
  800a95:	00 00 00 
  800a98:	48 89 c7             	mov    %rax,%rdi
  800a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa0:	49 b8 95 0d 80 00 00 	movabs $0x800d95,%r8
  800aa7:	00 00 00 
  800aaa:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aad:	e9 d4 02 00 00       	jmpq   800d86 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aba:	4c 89 e1             	mov    %r12,%rcx
  800abd:	48 ba 8a 19 80 00 00 	movabs $0x80198a,%rdx
  800ac4:	00 00 00 
  800ac7:	48 89 c7             	mov    %rax,%rdi
  800aca:	b8 00 00 00 00       	mov    $0x0,%eax
  800acf:	49 b8 95 0d 80 00 00 	movabs $0x800d95,%r8
  800ad6:	00 00 00 
  800ad9:	41 ff d0             	callq  *%r8
			break;
  800adc:	e9 a5 02 00 00       	jmpq   800d86 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ae1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae4:	83 f8 30             	cmp    $0x30,%eax
  800ae7:	73 17                	jae    800b00 <vprintfmt+0x296>
  800ae9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af0:	89 c0                	mov    %eax,%eax
  800af2:	48 01 d0             	add    %rdx,%rax
  800af5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af8:	83 c2 08             	add    $0x8,%edx
  800afb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afe:	eb 0f                	jmp    800b0f <vprintfmt+0x2a5>
  800b00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b04:	48 89 d0             	mov    %rdx,%rax
  800b07:	48 83 c2 08          	add    $0x8,%rdx
  800b0b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0f:	4c 8b 20             	mov    (%rax),%r12
  800b12:	4d 85 e4             	test   %r12,%r12
  800b15:	75 0a                	jne    800b21 <vprintfmt+0x2b7>
				p = "(null)";
  800b17:	49 bc 8d 19 80 00 00 	movabs $0x80198d,%r12
  800b1e:	00 00 00 
			if (width > 0 && padc != '-')
  800b21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b25:	7e 3f                	jle    800b66 <vprintfmt+0x2fc>
  800b27:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b2b:	74 39                	je     800b66 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b30:	48 98                	cltq   
  800b32:	48 89 c6             	mov    %rax,%rsi
  800b35:	4c 89 e7             	mov    %r12,%rdi
  800b38:	48 b8 41 10 80 00 00 	movabs $0x801041,%rax
  800b3f:	00 00 00 
  800b42:	ff d0                	callq  *%rax
  800b44:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b47:	eb 17                	jmp    800b60 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b49:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b4d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b55:	48 89 ce             	mov    %rcx,%rsi
  800b58:	89 d7                	mov    %edx,%edi
  800b5a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b64:	7f e3                	jg     800b49 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b66:	eb 37                	jmp    800b9f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b68:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b6c:	74 1e                	je     800b8c <vprintfmt+0x322>
  800b6e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b71:	7e 05                	jle    800b78 <vprintfmt+0x30e>
  800b73:	83 fb 7e             	cmp    $0x7e,%ebx
  800b76:	7e 14                	jle    800b8c <vprintfmt+0x322>
					putch('?', putdat);
  800b78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b80:	48 89 d6             	mov    %rdx,%rsi
  800b83:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b88:	ff d0                	callq  *%rax
  800b8a:	eb 0f                	jmp    800b9b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b94:	48 89 d6             	mov    %rdx,%rsi
  800b97:	89 df                	mov    %ebx,%edi
  800b99:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b9f:	4c 89 e0             	mov    %r12,%rax
  800ba2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ba6:	0f b6 00             	movzbl (%rax),%eax
  800ba9:	0f be d8             	movsbl %al,%ebx
  800bac:	85 db                	test   %ebx,%ebx
  800bae:	74 10                	je     800bc0 <vprintfmt+0x356>
  800bb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb4:	78 b2                	js     800b68 <vprintfmt+0x2fe>
  800bb6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bba:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bbe:	79 a8                	jns    800b68 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc0:	eb 16                	jmp    800bd8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bca:	48 89 d6             	mov    %rdx,%rsi
  800bcd:	bf 20 00 00 00       	mov    $0x20,%edi
  800bd2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bdc:	7f e4                	jg     800bc2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bde:	e9 a3 01 00 00       	jmpq   800d86 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be7:	be 03 00 00 00       	mov    $0x3,%esi
  800bec:	48 89 c7             	mov    %rax,%rdi
  800bef:	48 b8 5a 07 80 00 00 	movabs $0x80075a,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	callq  *%rax
  800bfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c03:	48 85 c0             	test   %rax,%rax
  800c06:	79 1d                	jns    800c25 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c10:	48 89 d6             	mov    %rdx,%rsi
  800c13:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c18:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1e:	48 f7 d8             	neg    %rax
  800c21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c25:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c2c:	e9 e8 00 00 00       	jmpq   800d19 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c31:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c35:	be 03 00 00 00       	mov    $0x3,%esi
  800c3a:	48 89 c7             	mov    %rax,%rdi
  800c3d:	48 b8 4a 06 80 00 00 	movabs $0x80064a,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	callq  *%rax
  800c49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c4d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c54:	e9 c0 00 00 00       	jmpq   800d19 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c61:	48 89 d6             	mov    %rdx,%rsi
  800c64:	bf 58 00 00 00       	mov    $0x58,%edi
  800c69:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c73:	48 89 d6             	mov    %rdx,%rsi
  800c76:	bf 58 00 00 00       	mov    $0x58,%edi
  800c7b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c85:	48 89 d6             	mov    %rdx,%rsi
  800c88:	bf 58 00 00 00       	mov    $0x58,%edi
  800c8d:	ff d0                	callq  *%rax
			break;
  800c8f:	e9 f2 00 00 00       	jmpq   800d86 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9c:	48 89 d6             	mov    %rdx,%rsi
  800c9f:	bf 30 00 00 00       	mov    $0x30,%edi
  800ca4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ca6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800caa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cae:	48 89 d6             	mov    %rdx,%rsi
  800cb1:	bf 78 00 00 00       	mov    $0x78,%edi
  800cb6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbb:	83 f8 30             	cmp    $0x30,%eax
  800cbe:	73 17                	jae    800cd7 <vprintfmt+0x46d>
  800cc0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cc4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc7:	89 c0                	mov    %eax,%eax
  800cc9:	48 01 d0             	add    %rdx,%rax
  800ccc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ccf:	83 c2 08             	add    $0x8,%edx
  800cd2:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd5:	eb 0f                	jmp    800ce6 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cd7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cdb:	48 89 d0             	mov    %rdx,%rax
  800cde:	48 83 c2 08          	add    $0x8,%rdx
  800ce2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ced:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cf4:	eb 23                	jmp    800d19 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cf6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cfa:	be 03 00 00 00       	mov    $0x3,%esi
  800cff:	48 89 c7             	mov    %rax,%rdi
  800d02:	48 b8 4a 06 80 00 00 	movabs $0x80064a,%rax
  800d09:	00 00 00 
  800d0c:	ff d0                	callq  *%rax
  800d0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d12:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d19:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d1e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d21:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d28:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d30:	45 89 c1             	mov    %r8d,%r9d
  800d33:	41 89 f8             	mov    %edi,%r8d
  800d36:	48 89 c7             	mov    %rax,%rdi
  800d39:	48 b8 8f 05 80 00 00 	movabs $0x80058f,%rax
  800d40:	00 00 00 
  800d43:	ff d0                	callq  *%rax
			break;
  800d45:	eb 3f                	jmp    800d86 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4f:	48 89 d6             	mov    %rdx,%rsi
  800d52:	89 df                	mov    %ebx,%edi
  800d54:	ff d0                	callq  *%rax
			break;
  800d56:	eb 2e                	jmp    800d86 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d60:	48 89 d6             	mov    %rdx,%rsi
  800d63:	bf 25 00 00 00       	mov    $0x25,%edi
  800d68:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d6a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d6f:	eb 05                	jmp    800d76 <vprintfmt+0x50c>
  800d71:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d76:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d7a:	48 83 e8 01          	sub    $0x1,%rax
  800d7e:	0f b6 00             	movzbl (%rax),%eax
  800d81:	3c 25                	cmp    $0x25,%al
  800d83:	75 ec                	jne    800d71 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d85:	90                   	nop
		}
	}
  800d86:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d87:	e9 30 fb ff ff       	jmpq   8008bc <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d8c:	48 83 c4 60          	add    $0x60,%rsp
  800d90:	5b                   	pop    %rbx
  800d91:	41 5c                	pop    %r12
  800d93:	5d                   	pop    %rbp
  800d94:	c3                   	retq   

0000000000800d95 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d95:	55                   	push   %rbp
  800d96:	48 89 e5             	mov    %rsp,%rbp
  800d99:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800da0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800da7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800db5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dbc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 20                	je     800de7 <printfmt+0x52>
  800dc7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dcb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dcf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ddb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ddf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dee:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800df5:	00 00 00 
  800df8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dff:	00 00 00 
  800e02:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e06:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e0d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e14:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e1b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e22:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e29:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e30:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e37:	48 89 c7             	mov    %rax,%rdi
  800e3a:	48 b8 6a 08 80 00 00 	movabs $0x80086a,%rax
  800e41:	00 00 00 
  800e44:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e46:	c9                   	leaveq 
  800e47:	c3                   	retq   

0000000000800e48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e48:	55                   	push   %rbp
  800e49:	48 89 e5             	mov    %rsp,%rbp
  800e4c:	48 83 ec 10          	sub    $0x10,%rsp
  800e50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5b:	8b 40 10             	mov    0x10(%rax),%eax
  800e5e:	8d 50 01             	lea    0x1(%rax),%edx
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6c:	48 8b 10             	mov    (%rax),%rdx
  800e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e73:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e77:	48 39 c2             	cmp    %rax,%rdx
  800e7a:	73 17                	jae    800e93 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e80:	48 8b 00             	mov    (%rax),%rax
  800e83:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e8b:	48 89 0a             	mov    %rcx,(%rdx)
  800e8e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e91:	88 10                	mov    %dl,(%rax)
}
  800e93:	c9                   	leaveq 
  800e94:	c3                   	retq   

0000000000800e95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e95:	55                   	push   %rbp
  800e96:	48 89 e5             	mov    %rsp,%rbp
  800e99:	48 83 ec 50          	sub    $0x50,%rsp
  800e9d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ea1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ea4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ea8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800eac:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eb0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eb4:	48 8b 0a             	mov    (%rdx),%rcx
  800eb7:	48 89 08             	mov    %rcx,(%rax)
  800eba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ebe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ec2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ec6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ece:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ed2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ed5:	48 98                	cltq   
  800ed7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800edb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800edf:	48 01 d0             	add    %rdx,%rax
  800ee2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ee6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eed:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ef2:	74 06                	je     800efa <vsnprintf+0x65>
  800ef4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ef8:	7f 07                	jg     800f01 <vsnprintf+0x6c>
		return -E_INVAL;
  800efa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eff:	eb 2f                	jmp    800f30 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f01:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f05:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f09:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f0d:	48 89 c6             	mov    %rax,%rsi
  800f10:	48 bf 48 0e 80 00 00 	movabs $0x800e48,%rdi
  800f17:	00 00 00 
  800f1a:	48 b8 6a 08 80 00 00 	movabs $0x80086a,%rax
  800f21:	00 00 00 
  800f24:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f2a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f2d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f30:	c9                   	leaveq 
  800f31:	c3                   	retq   

0000000000800f32 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f32:	55                   	push   %rbp
  800f33:	48 89 e5             	mov    %rsp,%rbp
  800f36:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f3d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f44:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f4a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f51:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f58:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f5f:	84 c0                	test   %al,%al
  800f61:	74 20                	je     800f83 <snprintf+0x51>
  800f63:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f67:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f6b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f6f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f73:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f77:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f7b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f7f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f83:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f8a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f91:	00 00 00 
  800f94:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f9b:	00 00 00 
  800f9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fa9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fb0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fb7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fbe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fc5:	48 8b 0a             	mov    (%rdx),%rcx
  800fc8:	48 89 08             	mov    %rcx,(%rax)
  800fcb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fcf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fd3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fd7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fdb:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fe2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fe9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ff6:	48 89 c7             	mov    %rax,%rdi
  800ff9:	48 b8 95 0e 80 00 00 	movabs $0x800e95,%rax
  801000:	00 00 00 
  801003:	ff d0                	callq  *%rax
  801005:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80100b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801011:	c9                   	leaveq 
  801012:	c3                   	retq   

0000000000801013 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801013:	55                   	push   %rbp
  801014:	48 89 e5             	mov    %rsp,%rbp
  801017:	48 83 ec 18          	sub    $0x18,%rsp
  80101b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80101f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801026:	eb 09                	jmp    801031 <strlen+0x1e>
		n++;
  801028:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80102c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801035:	0f b6 00             	movzbl (%rax),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	75 ec                	jne    801028 <strlen+0x15>
		n++;
	return n;
  80103c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80103f:	c9                   	leaveq 
  801040:	c3                   	retq   

0000000000801041 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801041:	55                   	push   %rbp
  801042:	48 89 e5             	mov    %rsp,%rbp
  801045:	48 83 ec 20          	sub    $0x20,%rsp
  801049:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801058:	eb 0e                	jmp    801068 <strnlen+0x27>
		n++;
  80105a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80105e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801063:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801068:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80106d:	74 0b                	je     80107a <strnlen+0x39>
  80106f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	84 c0                	test   %al,%al
  801078:	75 e0                	jne    80105a <strnlen+0x19>
		n++;
	return n;
  80107a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80107d:	c9                   	leaveq 
  80107e:	c3                   	retq   

000000000080107f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80107f:	55                   	push   %rbp
  801080:	48 89 e5             	mov    %rsp,%rbp
  801083:	48 83 ec 20          	sub    $0x20,%rsp
  801087:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801093:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801097:	90                   	nop
  801098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010ac:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b0:	0f b6 12             	movzbl (%rdx),%edx
  8010b3:	88 10                	mov    %dl,(%rax)
  8010b5:	0f b6 00             	movzbl (%rax),%eax
  8010b8:	84 c0                	test   %al,%al
  8010ba:	75 dc                	jne    801098 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c0:	c9                   	leaveq 
  8010c1:	c3                   	retq   

00000000008010c2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010c2:	55                   	push   %rbp
  8010c3:	48 89 e5             	mov    %rsp,%rbp
  8010c6:	48 83 ec 20          	sub    $0x20,%rsp
  8010ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d6:	48 89 c7             	mov    %rax,%rdi
  8010d9:	48 b8 13 10 80 00 00 	movabs $0x801013,%rax
  8010e0:	00 00 00 
  8010e3:	ff d0                	callq  *%rax
  8010e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010eb:	48 63 d0             	movslq %eax,%rdx
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	48 01 c2             	add    %rax,%rdx
  8010f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f9:	48 89 c6             	mov    %rax,%rsi
  8010fc:	48 89 d7             	mov    %rdx,%rdi
  8010ff:	48 b8 7f 10 80 00 00 	movabs $0x80107f,%rax
  801106:	00 00 00 
  801109:	ff d0                	callq  *%rax
	return dst;
  80110b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80110f:	c9                   	leaveq 
  801110:	c3                   	retq   

0000000000801111 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801111:	55                   	push   %rbp
  801112:	48 89 e5             	mov    %rsp,%rbp
  801115:	48 83 ec 28          	sub    $0x28,%rsp
  801119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801121:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801129:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80112d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801134:	00 
  801135:	eb 2a                	jmp    801161 <strncpy+0x50>
		*dst++ = *src;
  801137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801143:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801147:	0f b6 12             	movzbl (%rdx),%edx
  80114a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80114c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801150:	0f b6 00             	movzbl (%rax),%eax
  801153:	84 c0                	test   %al,%al
  801155:	74 05                	je     80115c <strncpy+0x4b>
			src++;
  801157:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80115c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801161:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801165:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801169:	72 cc                	jb     801137 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80116b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80116f:	c9                   	leaveq 
  801170:	c3                   	retq   

0000000000801171 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801171:	55                   	push   %rbp
  801172:	48 89 e5             	mov    %rsp,%rbp
  801175:	48 83 ec 28          	sub    $0x28,%rsp
  801179:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801181:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80118d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801192:	74 3d                	je     8011d1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801194:	eb 1d                	jmp    8011b3 <strlcpy+0x42>
			*dst++ = *src++;
  801196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011aa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011ae:	0f b6 12             	movzbl (%rdx),%edx
  8011b1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011b8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011bd:	74 0b                	je     8011ca <strlcpy+0x59>
  8011bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	84 c0                	test   %al,%al
  8011c8:	75 cc                	jne    801196 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ce:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d9:	48 29 c2             	sub    %rax,%rdx
  8011dc:	48 89 d0             	mov    %rdx,%rax
}
  8011df:	c9                   	leaveq 
  8011e0:	c3                   	retq   

00000000008011e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011e1:	55                   	push   %rbp
  8011e2:	48 89 e5             	mov    %rsp,%rbp
  8011e5:	48 83 ec 10          	sub    $0x10,%rsp
  8011e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011f1:	eb 0a                	jmp    8011fd <strcmp+0x1c>
		p++, q++;
  8011f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	84 c0                	test   %al,%al
  801206:	74 12                	je     80121a <strcmp+0x39>
  801208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120c:	0f b6 10             	movzbl (%rax),%edx
  80120f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801213:	0f b6 00             	movzbl (%rax),%eax
  801216:	38 c2                	cmp    %al,%dl
  801218:	74 d9                	je     8011f3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80121a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121e:	0f b6 00             	movzbl (%rax),%eax
  801221:	0f b6 d0             	movzbl %al,%edx
  801224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801228:	0f b6 00             	movzbl (%rax),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	29 c2                	sub    %eax,%edx
  801230:	89 d0                	mov    %edx,%eax
}
  801232:	c9                   	leaveq 
  801233:	c3                   	retq   

0000000000801234 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801234:	55                   	push   %rbp
  801235:	48 89 e5             	mov    %rsp,%rbp
  801238:	48 83 ec 18          	sub    $0x18,%rsp
  80123c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801240:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801244:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801248:	eb 0f                	jmp    801259 <strncmp+0x25>
		n--, p++, q++;
  80124a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80124f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801254:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801259:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80125e:	74 1d                	je     80127d <strncmp+0x49>
  801260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801264:	0f b6 00             	movzbl (%rax),%eax
  801267:	84 c0                	test   %al,%al
  801269:	74 12                	je     80127d <strncmp+0x49>
  80126b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126f:	0f b6 10             	movzbl (%rax),%edx
  801272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801276:	0f b6 00             	movzbl (%rax),%eax
  801279:	38 c2                	cmp    %al,%dl
  80127b:	74 cd                	je     80124a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80127d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801282:	75 07                	jne    80128b <strncmp+0x57>
		return 0;
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
  801289:	eb 18                	jmp    8012a3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80128b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128f:	0f b6 00             	movzbl (%rax),%eax
  801292:	0f b6 d0             	movzbl %al,%edx
  801295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	0f b6 c0             	movzbl %al,%eax
  80129f:	29 c2                	sub    %eax,%edx
  8012a1:	89 d0                	mov    %edx,%eax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 0c          	sub    $0xc,%rsp
  8012ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b1:	89 f0                	mov    %esi,%eax
  8012b3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012b6:	eb 17                	jmp    8012cf <strchr+0x2a>
		if (*s == c)
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bc:	0f b6 00             	movzbl (%rax),%eax
  8012bf:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c2:	75 06                	jne    8012ca <strchr+0x25>
			return (char *) s;
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	eb 15                	jmp    8012df <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	0f b6 00             	movzbl (%rax),%eax
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 de                	jne    8012b8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012df:	c9                   	leaveq 
  8012e0:	c3                   	retq   

00000000008012e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 83 ec 0c          	sub    $0xc,%rsp
  8012e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ed:	89 f0                	mov    %esi,%eax
  8012ef:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012f2:	eb 13                	jmp    801307 <strfind+0x26>
		if (*s == c)
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	0f b6 00             	movzbl (%rax),%eax
  8012fb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012fe:	75 02                	jne    801302 <strfind+0x21>
			break;
  801300:	eb 10                	jmp    801312 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801302:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	84 c0                	test   %al,%al
  801310:	75 e2                	jne    8012f4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801316:	c9                   	leaveq 
  801317:	c3                   	retq   

0000000000801318 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801318:	55                   	push   %rbp
  801319:	48 89 e5             	mov    %rsp,%rbp
  80131c:	48 83 ec 18          	sub    $0x18,%rsp
  801320:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801324:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801327:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80132b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801330:	75 06                	jne    801338 <memset+0x20>
		return v;
  801332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801336:	eb 69                	jmp    8013a1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133c:	83 e0 03             	and    $0x3,%eax
  80133f:	48 85 c0             	test   %rax,%rax
  801342:	75 48                	jne    80138c <memset+0x74>
  801344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801348:	83 e0 03             	and    $0x3,%eax
  80134b:	48 85 c0             	test   %rax,%rax
  80134e:	75 3c                	jne    80138c <memset+0x74>
		c &= 0xFF;
  801350:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801357:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135a:	c1 e0 18             	shl    $0x18,%eax
  80135d:	89 c2                	mov    %eax,%edx
  80135f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801362:	c1 e0 10             	shl    $0x10,%eax
  801365:	09 c2                	or     %eax,%edx
  801367:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136a:	c1 e0 08             	shl    $0x8,%eax
  80136d:	09 d0                	or     %edx,%eax
  80136f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801376:	48 c1 e8 02          	shr    $0x2,%rax
  80137a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80137d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801381:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801384:	48 89 d7             	mov    %rdx,%rdi
  801387:	fc                   	cld    
  801388:	f3 ab                	rep stos %eax,%es:(%rdi)
  80138a:	eb 11                	jmp    80139d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80138c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801390:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801393:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801397:	48 89 d7             	mov    %rdx,%rdi
  80139a:	fc                   	cld    
  80139b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80139d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 83 ec 28          	sub    $0x28,%rsp
  8013ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013cf:	0f 83 88 00 00 00    	jae    80145d <memmove+0xba>
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013dd:	48 01 d0             	add    %rdx,%rax
  8013e0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e4:	76 77                	jbe    80145d <memmove+0xba>
		s += n;
  8013e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ea:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fa:	83 e0 03             	and    $0x3,%eax
  8013fd:	48 85 c0             	test   %rax,%rax
  801400:	75 3b                	jne    80143d <memmove+0x9a>
  801402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801406:	83 e0 03             	and    $0x3,%eax
  801409:	48 85 c0             	test   %rax,%rax
  80140c:	75 2f                	jne    80143d <memmove+0x9a>
  80140e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801412:	83 e0 03             	and    $0x3,%eax
  801415:	48 85 c0             	test   %rax,%rax
  801418:	75 23                	jne    80143d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80141a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141e:	48 83 e8 04          	sub    $0x4,%rax
  801422:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801426:	48 83 ea 04          	sub    $0x4,%rdx
  80142a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80142e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801432:	48 89 c7             	mov    %rax,%rdi
  801435:	48 89 d6             	mov    %rdx,%rsi
  801438:	fd                   	std    
  801439:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143b:	eb 1d                	jmp    80145a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80143d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801441:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801445:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801449:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	48 89 d7             	mov    %rdx,%rdi
  801454:	48 89 c1             	mov    %rax,%rcx
  801457:	fd                   	std    
  801458:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80145a:	fc                   	cld    
  80145b:	eb 57                	jmp    8014b4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80145d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801461:	83 e0 03             	and    $0x3,%eax
  801464:	48 85 c0             	test   %rax,%rax
  801467:	75 36                	jne    80149f <memmove+0xfc>
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	83 e0 03             	and    $0x3,%eax
  801470:	48 85 c0             	test   %rax,%rax
  801473:	75 2a                	jne    80149f <memmove+0xfc>
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	75 1e                	jne    80149f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	48 c1 e8 02          	shr    $0x2,%rax
  801489:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80148c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801490:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801494:	48 89 c7             	mov    %rax,%rdi
  801497:	48 89 d6             	mov    %rdx,%rsi
  80149a:	fc                   	cld    
  80149b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80149d:	eb 15                	jmp    8014b4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80149f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ab:	48 89 c7             	mov    %rax,%rdi
  8014ae:	48 89 d6             	mov    %rdx,%rsi
  8014b1:	fc                   	cld    
  8014b2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b8:	c9                   	leaveq 
  8014b9:	c3                   	retq   

00000000008014ba <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014ba:	55                   	push   %rbp
  8014bb:	48 89 e5             	mov    %rsp,%rbp
  8014be:	48 83 ec 18          	sub    $0x18,%rsp
  8014c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014d2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014da:	48 89 ce             	mov    %rcx,%rsi
  8014dd:	48 89 c7             	mov    %rax,%rdi
  8014e0:	48 b8 a3 13 80 00 00 	movabs $0x8013a3,%rax
  8014e7:	00 00 00 
  8014ea:	ff d0                	callq  *%rax
}
  8014ec:	c9                   	leaveq 
  8014ed:	c3                   	retq   

00000000008014ee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014ee:	55                   	push   %rbp
  8014ef:	48 89 e5             	mov    %rsp,%rbp
  8014f2:	48 83 ec 28          	sub    $0x28,%rsp
  8014f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801506:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80150a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80150e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801512:	eb 36                	jmp    80154a <memcmp+0x5c>
		if (*s1 != *s2)
  801514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801518:	0f b6 10             	movzbl (%rax),%edx
  80151b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	38 c2                	cmp    %al,%dl
  801524:	74 1a                	je     801540 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801526:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152a:	0f b6 00             	movzbl (%rax),%eax
  80152d:	0f b6 d0             	movzbl %al,%edx
  801530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	0f b6 c0             	movzbl %al,%eax
  80153a:	29 c2                	sub    %eax,%edx
  80153c:	89 d0                	mov    %edx,%eax
  80153e:	eb 20                	jmp    801560 <memcmp+0x72>
		s1++, s2++;
  801540:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801545:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80154a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801552:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801556:	48 85 c0             	test   %rax,%rax
  801559:	75 b9                	jne    801514 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801560:	c9                   	leaveq 
  801561:	c3                   	retq   

0000000000801562 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801562:	55                   	push   %rbp
  801563:	48 89 e5             	mov    %rsp,%rbp
  801566:	48 83 ec 28          	sub    $0x28,%rsp
  80156a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80156e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801571:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80157d:	48 01 d0             	add    %rdx,%rax
  801580:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801584:	eb 15                	jmp    80159b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158a:	0f b6 10             	movzbl (%rax),%edx
  80158d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801590:	38 c2                	cmp    %al,%dl
  801592:	75 02                	jne    801596 <memfind+0x34>
			break;
  801594:	eb 0f                	jmp    8015a5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801596:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015a3:	72 e1                	jb     801586 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 34          	sub    $0x34,%rsp
  8015b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015bb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015c5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015cc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015cd:	eb 05                	jmp    8015d4 <strtol+0x29>
		s++;
  8015cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	0f b6 00             	movzbl (%rax),%eax
  8015db:	3c 20                	cmp    $0x20,%al
  8015dd:	74 f0                	je     8015cf <strtol+0x24>
  8015df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	3c 09                	cmp    $0x9,%al
  8015e8:	74 e5                	je     8015cf <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	3c 2b                	cmp    $0x2b,%al
  8015f3:	75 07                	jne    8015fc <strtol+0x51>
		s++;
  8015f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fa:	eb 17                	jmp    801613 <strtol+0x68>
	else if (*s == '-')
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	3c 2d                	cmp    $0x2d,%al
  801605:	75 0c                	jne    801613 <strtol+0x68>
		s++, neg = 1;
  801607:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80160c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801613:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801617:	74 06                	je     80161f <strtol+0x74>
  801619:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80161d:	75 28                	jne    801647 <strtol+0x9c>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 30                	cmp    $0x30,%al
  801628:	75 1d                	jne    801647 <strtol+0x9c>
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	48 83 c0 01          	add    $0x1,%rax
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	3c 78                	cmp    $0x78,%al
  801637:	75 0e                	jne    801647 <strtol+0x9c>
		s += 2, base = 16;
  801639:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80163e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801645:	eb 2c                	jmp    801673 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801647:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80164b:	75 19                	jne    801666 <strtol+0xbb>
  80164d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801651:	0f b6 00             	movzbl (%rax),%eax
  801654:	3c 30                	cmp    $0x30,%al
  801656:	75 0e                	jne    801666 <strtol+0xbb>
		s++, base = 8;
  801658:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80165d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801664:	eb 0d                	jmp    801673 <strtol+0xc8>
	else if (base == 0)
  801666:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166a:	75 07                	jne    801673 <strtol+0xc8>
		base = 10;
  80166c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	3c 2f                	cmp    $0x2f,%al
  80167c:	7e 1d                	jle    80169b <strtol+0xf0>
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 39                	cmp    $0x39,%al
  801687:	7f 12                	jg     80169b <strtol+0xf0>
			dig = *s - '0';
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	0f be c0             	movsbl %al,%eax
  801693:	83 e8 30             	sub    $0x30,%eax
  801696:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801699:	eb 4e                	jmp    8016e9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80169b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	3c 60                	cmp    $0x60,%al
  8016a4:	7e 1d                	jle    8016c3 <strtol+0x118>
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	0f b6 00             	movzbl (%rax),%eax
  8016ad:	3c 7a                	cmp    $0x7a,%al
  8016af:	7f 12                	jg     8016c3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b5:	0f b6 00             	movzbl (%rax),%eax
  8016b8:	0f be c0             	movsbl %al,%eax
  8016bb:	83 e8 57             	sub    $0x57,%eax
  8016be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c1:	eb 26                	jmp    8016e9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c7:	0f b6 00             	movzbl (%rax),%eax
  8016ca:	3c 40                	cmp    $0x40,%al
  8016cc:	7e 48                	jle    801716 <strtol+0x16b>
  8016ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	3c 5a                	cmp    $0x5a,%al
  8016d7:	7f 3d                	jg     801716 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	0f be c0             	movsbl %al,%eax
  8016e3:	83 e8 37             	sub    $0x37,%eax
  8016e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ec:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016ef:	7c 02                	jl     8016f3 <strtol+0x148>
			break;
  8016f1:	eb 23                	jmp    801716 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016fb:	48 98                	cltq   
  8016fd:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801702:	48 89 c2             	mov    %rax,%rdx
  801705:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801708:	48 98                	cltq   
  80170a:	48 01 d0             	add    %rdx,%rax
  80170d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801711:	e9 5d ff ff ff       	jmpq   801673 <strtol+0xc8>

	if (endptr)
  801716:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80171b:	74 0b                	je     801728 <strtol+0x17d>
		*endptr = (char *) s;
  80171d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801721:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801725:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801728:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80172c:	74 09                	je     801737 <strtol+0x18c>
  80172e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801732:	48 f7 d8             	neg    %rax
  801735:	eb 04                	jmp    80173b <strtol+0x190>
  801737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80173b:	c9                   	leaveq 
  80173c:	c3                   	retq   

000000000080173d <strstr>:

char * strstr(const char *in, const char *str)
{
  80173d:	55                   	push   %rbp
  80173e:	48 89 e5             	mov    %rsp,%rbp
  801741:	48 83 ec 30          	sub    $0x30,%rsp
  801745:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801749:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80174d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801751:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801755:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80175f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801763:	75 06                	jne    80176b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801769:	eb 6b                	jmp    8017d6 <strstr+0x99>

	len = strlen(str);
  80176b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176f:	48 89 c7             	mov    %rax,%rdi
  801772:	48 b8 13 10 80 00 00 	movabs $0x801013,%rax
  801779:	00 00 00 
  80177c:	ff d0                	callq  *%rax
  80177e:	48 98                	cltq   
  801780:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80178c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801790:	0f b6 00             	movzbl (%rax),%eax
  801793:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801796:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80179a:	75 07                	jne    8017a3 <strstr+0x66>
				return (char *) 0;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	eb 33                	jmp    8017d6 <strstr+0x99>
		} while (sc != c);
  8017a3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017a7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017aa:	75 d8                	jne    801784 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	48 89 ce             	mov    %rcx,%rsi
  8017bb:	48 89 c7             	mov    %rax,%rdi
  8017be:	48 b8 34 12 80 00 00 	movabs $0x801234,%rax
  8017c5:	00 00 00 
  8017c8:	ff d0                	callq  *%rax
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	75 b6                	jne    801784 <strstr+0x47>

	return (char *) (in - 1);
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	48 83 e8 01          	sub    $0x1,%rax
}
  8017d6:	c9                   	leaveq 
  8017d7:	c3                   	retq   
