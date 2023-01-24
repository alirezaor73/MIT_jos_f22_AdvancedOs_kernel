
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
  800068:	48 83 ec 10          	sub    $0x10,%rsp
  80006c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80006f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800073:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80007a:	00 00 00 
  80007d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800088:	7e 14                	jle    80009e <libmain+0x3a>
		binaryname = argv[0];
  80008a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80008e:	48 8b 10             	mov    (%rax),%rdx
  800091:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800098:	00 00 00 
  80009b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80009e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a5:	48 89 d6             	mov    %rdx,%rsi
  8000a8:	89 c7                	mov    %eax,%edi
  8000aa:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000b6:	48 b8 c4 00 80 00 00 	movabs $0x8000c4,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
}
  8000c2:	c9                   	leaveq 
  8000c3:	c3                   	retq   

00000000008000c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c4:	55                   	push   %rbp
  8000c5:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8000cd:	48 b8 f1 01 80 00 00 	movabs $0x8001f1,%rax
  8000d4:	00 00 00 
  8000d7:	ff d0                	callq  *%rax
}
  8000d9:	5d                   	pop    %rbp
  8000da:	c3                   	retq   

00000000008000db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000db:	55                   	push   %rbp
  8000dc:	48 89 e5             	mov    %rsp,%rbp
  8000df:	53                   	push   %rbx
  8000e0:	48 83 ec 48          	sub    $0x48,%rsp
  8000e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000e7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000ea:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000ee:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8000f2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8000f6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8000fd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800101:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800105:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800109:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80010d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800111:	4c 89 c3             	mov    %r8,%rbx
  800114:	cd 30                	int    $0x30
  800116:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80011a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80011e:	74 3e                	je     80015e <syscall+0x83>
  800120:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800125:	7e 37                	jle    80015e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800127:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80012b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80012e:	49 89 d0             	mov    %rdx,%r8
  800131:	89 c1                	mov    %eax,%ecx
  800133:	48 ba ea 17 80 00 00 	movabs $0x8017ea,%rdx
  80013a:	00 00 00 
  80013d:	be 23 00 00 00       	mov    $0x23,%esi
  800142:	48 bf 07 18 80 00 00 	movabs $0x801807,%rdi
  800149:	00 00 00 
  80014c:	b8 00 00 00 00       	mov    $0x0,%eax
  800151:	49 b9 73 02 80 00 00 	movabs $0x800273,%r9
  800158:	00 00 00 
  80015b:	41 ff d1             	callq  *%r9

	return ret;
  80015e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800162:	48 83 c4 48          	add    $0x48,%rsp
  800166:	5b                   	pop    %rbx
  800167:	5d                   	pop    %rbp
  800168:	c3                   	retq   

0000000000800169 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800169:	55                   	push   %rbp
  80016a:	48 89 e5             	mov    %rsp,%rbp
  80016d:	48 83 ec 20          	sub    $0x20,%rsp
  800171:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800175:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80017d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800181:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800188:	00 
  800189:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80018f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800195:	48 89 d1             	mov    %rdx,%rcx
  800198:	48 89 c2             	mov    %rax,%rdx
  80019b:	be 00 00 00 00       	mov    $0x0,%esi
  8001a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a5:	48 b8 db 00 80 00 00 	movabs $0x8000db,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
}
  8001b1:	c9                   	leaveq 
  8001b2:	c3                   	retq   

00000000008001b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001b3:	55                   	push   %rbp
  8001b4:	48 89 e5             	mov    %rsp,%rbp
  8001b7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c2:	00 
  8001c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001d9:	be 00 00 00 00       	mov    $0x0,%esi
  8001de:	bf 01 00 00 00       	mov    $0x1,%edi
  8001e3:	48 b8 db 00 80 00 00 	movabs $0x8000db,%rax
  8001ea:	00 00 00 
  8001ed:	ff d0                	callq  *%rax
}
  8001ef:	c9                   	leaveq 
  8001f0:	c3                   	retq   

00000000008001f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001f1:	55                   	push   %rbp
  8001f2:	48 89 e5             	mov    %rsp,%rbp
  8001f5:	48 83 ec 10          	sub    $0x10,%rsp
  8001f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ff:	48 98                	cltq   
  800201:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800208:	00 
  800209:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800215:	b9 00 00 00 00       	mov    $0x0,%ecx
  80021a:	48 89 c2             	mov    %rax,%rdx
  80021d:	be 01 00 00 00       	mov    $0x1,%esi
  800222:	bf 03 00 00 00       	mov    $0x3,%edi
  800227:	48 b8 db 00 80 00 00 	movabs $0x8000db,%rax
  80022e:	00 00 00 
  800231:	ff d0                	callq  *%rax
}
  800233:	c9                   	leaveq 
  800234:	c3                   	retq   

0000000000800235 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800235:	55                   	push   %rbp
  800236:	48 89 e5             	mov    %rsp,%rbp
  800239:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80023d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800244:	00 
  800245:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80024b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800251:	b9 00 00 00 00       	mov    $0x0,%ecx
  800256:	ba 00 00 00 00       	mov    $0x0,%edx
  80025b:	be 00 00 00 00       	mov    $0x0,%esi
  800260:	bf 02 00 00 00       	mov    $0x2,%edi
  800265:	48 b8 db 00 80 00 00 	movabs $0x8000db,%rax
  80026c:	00 00 00 
  80026f:	ff d0                	callq  *%rax
}
  800271:	c9                   	leaveq 
  800272:	c3                   	retq   

0000000000800273 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800273:	55                   	push   %rbp
  800274:	48 89 e5             	mov    %rsp,%rbp
  800277:	53                   	push   %rbx
  800278:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80027f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800286:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80028c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800293:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80029a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a1:	84 c0                	test   %al,%al
  8002a3:	74 23                	je     8002c8 <_panic+0x55>
  8002a5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002ac:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002b4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002b8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002bc:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002c4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002c8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002cf:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d6:	00 00 00 
  8002d9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e0:	00 00 00 
  8002e3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ee:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fc:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800303:	00 00 00 
  800306:	48 8b 18             	mov    (%rax),%rbx
  800309:	48 b8 35 02 80 00 00 	movabs $0x800235,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
  800315:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80031b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800322:	41 89 c8             	mov    %ecx,%r8d
  800325:	48 89 d1             	mov    %rdx,%rcx
  800328:	48 89 da             	mov    %rbx,%rdx
  80032b:	89 c6                	mov    %eax,%esi
  80032d:	48 bf 18 18 80 00 00 	movabs $0x801818,%rdi
  800334:	00 00 00 
  800337:	b8 00 00 00 00       	mov    $0x0,%eax
  80033c:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  800343:	00 00 00 
  800346:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800349:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800350:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800357:	48 89 d6             	mov    %rdx,%rsi
  80035a:	48 89 c7             	mov    %rax,%rdi
  80035d:	48 b8 00 04 80 00 00 	movabs $0x800400,%rax
  800364:	00 00 00 
  800367:	ff d0                	callq  *%rax
	cprintf("\n");
  800369:	48 bf 3b 18 80 00 00 	movabs $0x80183b,%rdi
  800370:	00 00 00 
  800373:	b8 00 00 00 00       	mov    $0x0,%eax
  800378:	48 ba ac 04 80 00 00 	movabs $0x8004ac,%rdx
  80037f:	00 00 00 
  800382:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800384:	cc                   	int3   
  800385:	eb fd                	jmp    800384 <_panic+0x111>

0000000000800387 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800387:	55                   	push   %rbp
  800388:	48 89 e5             	mov    %rsp,%rbp
  80038b:	48 83 ec 10          	sub    $0x10,%rsp
  80038f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800392:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039a:	8b 00                	mov    (%rax),%eax
  80039c:	8d 48 01             	lea    0x1(%rax),%ecx
  80039f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a3:	89 0a                	mov    %ecx,(%rdx)
  8003a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a8:	89 d1                	mov    %edx,%ecx
  8003aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ae:	48 98                	cltq   
  8003b0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b8:	8b 00                	mov    (%rax),%eax
  8003ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003bf:	75 2c                	jne    8003ed <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c5:	8b 00                	mov    (%rax),%eax
  8003c7:	48 98                	cltq   
  8003c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003cd:	48 83 c2 08          	add    $0x8,%rdx
  8003d1:	48 89 c6             	mov    %rax,%rsi
  8003d4:	48 89 d7             	mov    %rdx,%rdi
  8003d7:	48 b8 69 01 80 00 00 	movabs $0x800169,%rax
  8003de:	00 00 00 
  8003e1:	ff d0                	callq  *%rax
        b->idx = 0;
  8003e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f1:	8b 40 04             	mov    0x4(%rax),%eax
  8003f4:	8d 50 01             	lea    0x1(%rax),%edx
  8003f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003fe:	c9                   	leaveq 
  8003ff:	c3                   	retq   

0000000000800400 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800400:	55                   	push   %rbp
  800401:	48 89 e5             	mov    %rsp,%rbp
  800404:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80040b:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800412:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800419:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800420:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800427:	48 8b 0a             	mov    (%rdx),%rcx
  80042a:	48 89 08             	mov    %rcx,(%rax)
  80042d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800431:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800435:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800439:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80043d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800444:	00 00 00 
    b.cnt = 0;
  800447:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80044e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800451:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800458:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80045f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800466:	48 89 c6             	mov    %rax,%rsi
  800469:	48 bf 87 03 80 00 00 	movabs $0x800387,%rdi
  800470:	00 00 00 
  800473:	48 b8 5f 08 80 00 00 	movabs $0x80085f,%rax
  80047a:	00 00 00 
  80047d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80047f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800485:	48 98                	cltq   
  800487:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80048e:	48 83 c2 08          	add    $0x8,%rdx
  800492:	48 89 c6             	mov    %rax,%rsi
  800495:	48 89 d7             	mov    %rdx,%rdi
  800498:	48 b8 69 01 80 00 00 	movabs $0x800169,%rax
  80049f:	00 00 00 
  8004a2:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004aa:	c9                   	leaveq 
  8004ab:	c3                   	retq   

00000000008004ac <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ac:	55                   	push   %rbp
  8004ad:	48 89 e5             	mov    %rsp,%rbp
  8004b0:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004b7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004be:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004c5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004cc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004d3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004da:	84 c0                	test   %al,%al
  8004dc:	74 20                	je     8004fe <cprintf+0x52>
  8004de:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004e6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004ea:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ee:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004f6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004fa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004fe:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800505:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80050c:	00 00 00 
  80050f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800516:	00 00 00 
  800519:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80051d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800524:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80052b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800532:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800539:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800540:	48 8b 0a             	mov    (%rdx),%rcx
  800543:	48 89 08             	mov    %rcx,(%rax)
  800546:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800552:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800556:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80055d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800564:	48 89 d6             	mov    %rdx,%rsi
  800567:	48 89 c7             	mov    %rax,%rdi
  80056a:	48 b8 00 04 80 00 00 	movabs $0x800400,%rax
  800571:	00 00 00 
  800574:	ff d0                	callq  *%rax
  800576:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80057c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800582:	c9                   	leaveq 
  800583:	c3                   	retq   

0000000000800584 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800584:	55                   	push   %rbp
  800585:	48 89 e5             	mov    %rsp,%rbp
  800588:	53                   	push   %rbx
  800589:	48 83 ec 38          	sub    $0x38,%rsp
  80058d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800591:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800595:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800599:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80059c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005a0:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005a7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005ab:	77 3b                	ja     8005e8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ad:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005b0:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005b4:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	48 f7 f3             	div    %rbx
  8005c3:	48 89 c2             	mov    %rax,%rdx
  8005c6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005c9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005cc:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d4:	41 89 f9             	mov    %edi,%r9d
  8005d7:	48 89 c7             	mov    %rax,%rdi
  8005da:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  8005e1:	00 00 00 
  8005e4:	ff d0                	callq  *%rax
  8005e6:	eb 1e                	jmp    800606 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e8:	eb 12                	jmp    8005fc <printnum+0x78>
			putch(padc, putdat);
  8005ea:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ee:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f5:	48 89 ce             	mov    %rcx,%rsi
  8005f8:	89 d7                	mov    %edx,%edi
  8005fa:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800600:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800604:	7f e4                	jg     8005ea <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80060d:	ba 00 00 00 00       	mov    $0x0,%edx
  800612:	48 f7 f1             	div    %rcx
  800615:	48 89 d0             	mov    %rdx,%rax
  800618:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
  80061f:	00 00 00 
  800622:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800626:	0f be d0             	movsbl %al,%edx
  800629:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80062d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800631:	48 89 ce             	mov    %rcx,%rsi
  800634:	89 d7                	mov    %edx,%edi
  800636:	ff d0                	callq  *%rax
}
  800638:	48 83 c4 38          	add    $0x38,%rsp
  80063c:	5b                   	pop    %rbx
  80063d:	5d                   	pop    %rbp
  80063e:	c3                   	retq   

000000000080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %rbp
  800640:	48 89 e5             	mov    %rsp,%rbp
  800643:	48 83 ec 1c          	sub    $0x1c,%rsp
  800647:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80064b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80064e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800652:	7e 52                	jle    8006a6 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	8b 00                	mov    (%rax),%eax
  80065a:	83 f8 30             	cmp    $0x30,%eax
  80065d:	73 24                	jae    800683 <getuint+0x44>
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	8b 00                	mov    (%rax),%eax
  80066d:	89 c0                	mov    %eax,%eax
  80066f:	48 01 d0             	add    %rdx,%rax
  800672:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800676:	8b 12                	mov    (%rdx),%edx
  800678:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	89 0a                	mov    %ecx,(%rdx)
  800681:	eb 17                	jmp    80069a <getuint+0x5b>
  800683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800687:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068b:	48 89 d0             	mov    %rdx,%rax
  80068e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800696:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069a:	48 8b 00             	mov    (%rax),%rax
  80069d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a1:	e9 a3 00 00 00       	jmpq   800749 <getuint+0x10a>
	else if (lflag)
  8006a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006aa:	74 4f                	je     8006fb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	8b 00                	mov    (%rax),%eax
  8006b2:	83 f8 30             	cmp    $0x30,%eax
  8006b5:	73 24                	jae    8006db <getuint+0x9c>
  8006b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c3:	8b 00                	mov    (%rax),%eax
  8006c5:	89 c0                	mov    %eax,%eax
  8006c7:	48 01 d0             	add    %rdx,%rax
  8006ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ce:	8b 12                	mov    (%rdx),%edx
  8006d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d7:	89 0a                	mov    %ecx,(%rdx)
  8006d9:	eb 17                	jmp    8006f2 <getuint+0xb3>
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e3:	48 89 d0             	mov    %rdx,%rax
  8006e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f2:	48 8b 00             	mov    (%rax),%rax
  8006f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f9:	eb 4e                	jmp    800749 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	8b 00                	mov    (%rax),%eax
  800701:	83 f8 30             	cmp    $0x30,%eax
  800704:	73 24                	jae    80072a <getuint+0xeb>
  800706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	8b 00                	mov    (%rax),%eax
  800714:	89 c0                	mov    %eax,%eax
  800716:	48 01 d0             	add    %rdx,%rax
  800719:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071d:	8b 12                	mov    (%rdx),%edx
  80071f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800722:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800726:	89 0a                	mov    %ecx,(%rdx)
  800728:	eb 17                	jmp    800741 <getuint+0x102>
  80072a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800732:	48 89 d0             	mov    %rdx,%rax
  800735:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800739:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800741:	8b 00                	mov    (%rax),%eax
  800743:	89 c0                	mov    %eax,%eax
  800745:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800749:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80074d:	c9                   	leaveq 
  80074e:	c3                   	retq   

000000000080074f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80074f:	55                   	push   %rbp
  800750:	48 89 e5             	mov    %rsp,%rbp
  800753:	48 83 ec 1c          	sub    $0x1c,%rsp
  800757:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80075e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800762:	7e 52                	jle    8007b6 <getint+0x67>
		x=va_arg(*ap, long long);
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	8b 00                	mov    (%rax),%eax
  80076a:	83 f8 30             	cmp    $0x30,%eax
  80076d:	73 24                	jae    800793 <getint+0x44>
  80076f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800773:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	8b 00                	mov    (%rax),%eax
  80077d:	89 c0                	mov    %eax,%eax
  80077f:	48 01 d0             	add    %rdx,%rax
  800782:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800786:	8b 12                	mov    (%rdx),%edx
  800788:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	89 0a                	mov    %ecx,(%rdx)
  800791:	eb 17                	jmp    8007aa <getint+0x5b>
  800793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800797:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80079b:	48 89 d0             	mov    %rdx,%rax
  80079e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007aa:	48 8b 00             	mov    (%rax),%rax
  8007ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b1:	e9 a3 00 00 00       	jmpq   800859 <getint+0x10a>
	else if (lflag)
  8007b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ba:	74 4f                	je     80080b <getint+0xbc>
		x=va_arg(*ap, long);
  8007bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	83 f8 30             	cmp    $0x30,%eax
  8007c5:	73 24                	jae    8007eb <getint+0x9c>
  8007c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d3:	8b 00                	mov    (%rax),%eax
  8007d5:	89 c0                	mov    %eax,%eax
  8007d7:	48 01 d0             	add    %rdx,%rax
  8007da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007de:	8b 12                	mov    (%rdx),%edx
  8007e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	89 0a                	mov    %ecx,(%rdx)
  8007e9:	eb 17                	jmp    800802 <getint+0xb3>
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f3:	48 89 d0             	mov    %rdx,%rax
  8007f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800802:	48 8b 00             	mov    (%rax),%rax
  800805:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800809:	eb 4e                	jmp    800859 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	8b 00                	mov    (%rax),%eax
  800811:	83 f8 30             	cmp    $0x30,%eax
  800814:	73 24                	jae    80083a <getint+0xeb>
  800816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	8b 00                	mov    (%rax),%eax
  800824:	89 c0                	mov    %eax,%eax
  800826:	48 01 d0             	add    %rdx,%rax
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	8b 12                	mov    (%rdx),%edx
  80082f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	89 0a                	mov    %ecx,(%rdx)
  800838:	eb 17                	jmp    800851 <getint+0x102>
  80083a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800842:	48 89 d0             	mov    %rdx,%rax
  800845:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800851:	8b 00                	mov    (%rax),%eax
  800853:	48 98                	cltq   
  800855:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800859:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80085d:	c9                   	leaveq 
  80085e:	c3                   	retq   

000000000080085f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085f:	55                   	push   %rbp
  800860:	48 89 e5             	mov    %rsp,%rbp
  800863:	41 54                	push   %r12
  800865:	53                   	push   %rbx
  800866:	48 83 ec 60          	sub    $0x60,%rsp
  80086a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80086e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800872:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800876:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80087a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80087e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800882:	48 8b 0a             	mov    (%rdx),%rcx
  800885:	48 89 08             	mov    %rcx,(%rax)
  800888:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80088c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800890:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800894:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800898:	eb 17                	jmp    8008b1 <vprintfmt+0x52>
			if (ch == '\0')
  80089a:	85 db                	test   %ebx,%ebx
  80089c:	0f 84 df 04 00 00    	je     800d81 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008a2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008aa:	48 89 d6             	mov    %rdx,%rsi
  8008ad:	89 df                	mov    %ebx,%edi
  8008af:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008b9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008bd:	0f b6 00             	movzbl (%rax),%eax
  8008c0:	0f b6 d8             	movzbl %al,%ebx
  8008c3:	83 fb 25             	cmp    $0x25,%ebx
  8008c6:	75 d2                	jne    80089a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008cc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f4:	0f b6 00             	movzbl (%rax),%eax
  8008f7:	0f b6 d8             	movzbl %al,%ebx
  8008fa:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008fd:	83 f8 55             	cmp    $0x55,%eax
  800900:	0f 87 47 04 00 00    	ja     800d4d <vprintfmt+0x4ee>
  800906:	89 c0                	mov    %eax,%eax
  800908:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80090f:	00 
  800910:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  800917:	00 00 00 
  80091a:	48 01 d0             	add    %rdx,%rax
  80091d:	48 8b 00             	mov    (%rax),%rax
  800920:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800922:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800926:	eb c0                	jmp    8008e8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800928:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80092c:	eb ba                	jmp    8008e8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800935:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800938:	89 d0                	mov    %edx,%eax
  80093a:	c1 e0 02             	shl    $0x2,%eax
  80093d:	01 d0                	add    %edx,%eax
  80093f:	01 c0                	add    %eax,%eax
  800941:	01 d8                	add    %ebx,%eax
  800943:	83 e8 30             	sub    $0x30,%eax
  800946:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800949:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094d:	0f b6 00             	movzbl (%rax),%eax
  800950:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800953:	83 fb 2f             	cmp    $0x2f,%ebx
  800956:	7e 0c                	jle    800964 <vprintfmt+0x105>
  800958:	83 fb 39             	cmp    $0x39,%ebx
  80095b:	7f 07                	jg     800964 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800962:	eb d1                	jmp    800935 <vprintfmt+0xd6>
			goto process_precision;
  800964:	eb 58                	jmp    8009be <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800966:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800969:	83 f8 30             	cmp    $0x30,%eax
  80096c:	73 17                	jae    800985 <vprintfmt+0x126>
  80096e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800972:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800975:	89 c0                	mov    %eax,%eax
  800977:	48 01 d0             	add    %rdx,%rax
  80097a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097d:	83 c2 08             	add    $0x8,%edx
  800980:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800983:	eb 0f                	jmp    800994 <vprintfmt+0x135>
  800985:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800989:	48 89 d0             	mov    %rdx,%rax
  80098c:	48 83 c2 08          	add    $0x8,%rdx
  800990:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800994:	8b 00                	mov    (%rax),%eax
  800996:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800999:	eb 23                	jmp    8009be <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80099b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099f:	79 0c                	jns    8009ad <vprintfmt+0x14e>
				width = 0;
  8009a1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009a8:	e9 3b ff ff ff       	jmpq   8008e8 <vprintfmt+0x89>
  8009ad:	e9 36 ff ff ff       	jmpq   8008e8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009b2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009b9:	e9 2a ff ff ff       	jmpq   8008e8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c2:	79 12                	jns    8009d6 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009c4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009c7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ca:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009d1:	e9 12 ff ff ff       	jmpq   8008e8 <vprintfmt+0x89>
  8009d6:	e9 0d ff ff ff       	jmpq   8008e8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009db:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009df:	e9 04 ff ff ff       	jmpq   8008e8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e7:	83 f8 30             	cmp    $0x30,%eax
  8009ea:	73 17                	jae    800a03 <vprintfmt+0x1a4>
  8009ec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f3:	89 c0                	mov    %eax,%eax
  8009f5:	48 01 d0             	add    %rdx,%rax
  8009f8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fb:	83 c2 08             	add    $0x8,%edx
  8009fe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x1b3>
  800a03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a07:	48 89 d0             	mov    %rdx,%rax
  800a0a:	48 83 c2 08          	add    $0x8,%rdx
  800a0e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a12:	8b 10                	mov    (%rax),%edx
  800a14:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1c:	48 89 ce             	mov    %rcx,%rsi
  800a1f:	89 d7                	mov    %edx,%edi
  800a21:	ff d0                	callq  *%rax
			break;
  800a23:	e9 53 03 00 00       	jmpq   800d7b <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2b:	83 f8 30             	cmp    $0x30,%eax
  800a2e:	73 17                	jae    800a47 <vprintfmt+0x1e8>
  800a30:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a37:	89 c0                	mov    %eax,%eax
  800a39:	48 01 d0             	add    %rdx,%rax
  800a3c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3f:	83 c2 08             	add    $0x8,%edx
  800a42:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a45:	eb 0f                	jmp    800a56 <vprintfmt+0x1f7>
  800a47:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a4b:	48 89 d0             	mov    %rdx,%rax
  800a4e:	48 83 c2 08          	add    $0x8,%rdx
  800a52:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a56:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a58:	85 db                	test   %ebx,%ebx
  800a5a:	79 02                	jns    800a5e <vprintfmt+0x1ff>
				err = -err;
  800a5c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a5e:	83 fb 15             	cmp    $0x15,%ebx
  800a61:	7f 16                	jg     800a79 <vprintfmt+0x21a>
  800a63:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  800a6a:	00 00 00 
  800a6d:	48 63 d3             	movslq %ebx,%rdx
  800a70:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a74:	4d 85 e4             	test   %r12,%r12
  800a77:	75 2e                	jne    800aa7 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a79:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a81:	89 d9                	mov    %ebx,%ecx
  800a83:	48 ba 81 19 80 00 00 	movabs $0x801981,%rdx
  800a8a:	00 00 00 
  800a8d:	48 89 c7             	mov    %rax,%rdi
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
  800a95:	49 b8 8a 0d 80 00 00 	movabs $0x800d8a,%r8
  800a9c:	00 00 00 
  800a9f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa2:	e9 d4 02 00 00       	jmpq   800d7b <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aaf:	4c 89 e1             	mov    %r12,%rcx
  800ab2:	48 ba 8a 19 80 00 00 	movabs $0x80198a,%rdx
  800ab9:	00 00 00 
  800abc:	48 89 c7             	mov    %rax,%rdi
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac4:	49 b8 8a 0d 80 00 00 	movabs $0x800d8a,%r8
  800acb:	00 00 00 
  800ace:	41 ff d0             	callq  *%r8
			break;
  800ad1:	e9 a5 02 00 00       	jmpq   800d7b <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ad6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad9:	83 f8 30             	cmp    $0x30,%eax
  800adc:	73 17                	jae    800af5 <vprintfmt+0x296>
  800ade:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae5:	89 c0                	mov    %eax,%eax
  800ae7:	48 01 d0             	add    %rdx,%rax
  800aea:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aed:	83 c2 08             	add    $0x8,%edx
  800af0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af3:	eb 0f                	jmp    800b04 <vprintfmt+0x2a5>
  800af5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af9:	48 89 d0             	mov    %rdx,%rax
  800afc:	48 83 c2 08          	add    $0x8,%rdx
  800b00:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b04:	4c 8b 20             	mov    (%rax),%r12
  800b07:	4d 85 e4             	test   %r12,%r12
  800b0a:	75 0a                	jne    800b16 <vprintfmt+0x2b7>
				p = "(null)";
  800b0c:	49 bc 8d 19 80 00 00 	movabs $0x80198d,%r12
  800b13:	00 00 00 
			if (width > 0 && padc != '-')
  800b16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1a:	7e 3f                	jle    800b5b <vprintfmt+0x2fc>
  800b1c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b20:	74 39                	je     800b5b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b22:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b25:	48 98                	cltq   
  800b27:	48 89 c6             	mov    %rax,%rsi
  800b2a:	4c 89 e7             	mov    %r12,%rdi
  800b2d:	48 b8 36 10 80 00 00 	movabs $0x801036,%rax
  800b34:	00 00 00 
  800b37:	ff d0                	callq  *%rax
  800b39:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b3c:	eb 17                	jmp    800b55 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b3e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b42:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4a:	48 89 ce             	mov    %rcx,%rsi
  800b4d:	89 d7                	mov    %edx,%edi
  800b4f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b51:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b59:	7f e3                	jg     800b3e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5b:	eb 37                	jmp    800b94 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b61:	74 1e                	je     800b81 <vprintfmt+0x322>
  800b63:	83 fb 1f             	cmp    $0x1f,%ebx
  800b66:	7e 05                	jle    800b6d <vprintfmt+0x30e>
  800b68:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6b:	7e 14                	jle    800b81 <vprintfmt+0x322>
					putch('?', putdat);
  800b6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b75:	48 89 d6             	mov    %rdx,%rsi
  800b78:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b7d:	ff d0                	callq  *%rax
  800b7f:	eb 0f                	jmp    800b90 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b89:	48 89 d6             	mov    %rdx,%rsi
  800b8c:	89 df                	mov    %ebx,%edi
  800b8e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b90:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b94:	4c 89 e0             	mov    %r12,%rax
  800b97:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b9b:	0f b6 00             	movzbl (%rax),%eax
  800b9e:	0f be d8             	movsbl %al,%ebx
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	74 10                	je     800bb5 <vprintfmt+0x356>
  800ba5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba9:	78 b2                	js     800b5d <vprintfmt+0x2fe>
  800bab:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800baf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb3:	79 a8                	jns    800b5d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb5:	eb 16                	jmp    800bcd <vprintfmt+0x36e>
				putch(' ', putdat);
  800bb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbf:	48 89 d6             	mov    %rdx,%rsi
  800bc2:	bf 20 00 00 00       	mov    $0x20,%edi
  800bc7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd1:	7f e4                	jg     800bb7 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bd3:	e9 a3 01 00 00       	jmpq   800d7b <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bd8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdc:	be 03 00 00 00       	mov    $0x3,%esi
  800be1:	48 89 c7             	mov    %rax,%rdi
  800be4:	48 b8 4f 07 80 00 00 	movabs $0x80074f,%rax
  800beb:	00 00 00 
  800bee:	ff d0                	callq  *%rax
  800bf0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf8:	48 85 c0             	test   %rax,%rax
  800bfb:	79 1d                	jns    800c1a <vprintfmt+0x3bb>
				putch('-', putdat);
  800bfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c05:	48 89 d6             	mov    %rdx,%rsi
  800c08:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c0d:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c13:	48 f7 d8             	neg    %rax
  800c16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c1a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c21:	e9 e8 00 00 00       	jmpq   800d0e <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c26:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2a:	be 03 00 00 00       	mov    $0x3,%esi
  800c2f:	48 89 c7             	mov    %rax,%rdi
  800c32:	48 b8 3f 06 80 00 00 	movabs $0x80063f,%rax
  800c39:	00 00 00 
  800c3c:	ff d0                	callq  *%rax
  800c3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c42:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c49:	e9 c0 00 00 00       	jmpq   800d0e <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c56:	48 89 d6             	mov    %rdx,%rsi
  800c59:	bf 58 00 00 00       	mov    $0x58,%edi
  800c5e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c60:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c68:	48 89 d6             	mov    %rdx,%rsi
  800c6b:	bf 58 00 00 00       	mov    $0x58,%edi
  800c70:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7a:	48 89 d6             	mov    %rdx,%rsi
  800c7d:	bf 58 00 00 00       	mov    $0x58,%edi
  800c82:	ff d0                	callq  *%rax
			break;
  800c84:	e9 f2 00 00 00       	jmpq   800d7b <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c91:	48 89 d6             	mov    %rdx,%rsi
  800c94:	bf 30 00 00 00       	mov    $0x30,%edi
  800c99:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca3:	48 89 d6             	mov    %rdx,%rsi
  800ca6:	bf 78 00 00 00       	mov    $0x78,%edi
  800cab:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb0:	83 f8 30             	cmp    $0x30,%eax
  800cb3:	73 17                	jae    800ccc <vprintfmt+0x46d>
  800cb5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbc:	89 c0                	mov    %eax,%eax
  800cbe:	48 01 d0             	add    %rdx,%rax
  800cc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc4:	83 c2 08             	add    $0x8,%edx
  800cc7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cca:	eb 0f                	jmp    800cdb <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ccc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd0:	48 89 d0             	mov    %rdx,%rax
  800cd3:	48 83 c2 08          	add    $0x8,%rdx
  800cd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cdb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ce2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ce9:	eb 23                	jmp    800d0e <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ceb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cef:	be 03 00 00 00       	mov    $0x3,%esi
  800cf4:	48 89 c7             	mov    %rax,%rdi
  800cf7:	48 b8 3f 06 80 00 00 	movabs $0x80063f,%rax
  800cfe:	00 00 00 
  800d01:	ff d0                	callq  *%rax
  800d03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d07:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d0e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d13:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d16:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d1d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d25:	45 89 c1             	mov    %r8d,%r9d
  800d28:	41 89 f8             	mov    %edi,%r8d
  800d2b:	48 89 c7             	mov    %rax,%rdi
  800d2e:	48 b8 84 05 80 00 00 	movabs $0x800584,%rax
  800d35:	00 00 00 
  800d38:	ff d0                	callq  *%rax
			break;
  800d3a:	eb 3f                	jmp    800d7b <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d44:	48 89 d6             	mov    %rdx,%rsi
  800d47:	89 df                	mov    %ebx,%edi
  800d49:	ff d0                	callq  *%rax
			break;
  800d4b:	eb 2e                	jmp    800d7b <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d55:	48 89 d6             	mov    %rdx,%rsi
  800d58:	bf 25 00 00 00       	mov    $0x25,%edi
  800d5d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d5f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d64:	eb 05                	jmp    800d6b <vprintfmt+0x50c>
  800d66:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d6b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d6f:	48 83 e8 01          	sub    $0x1,%rax
  800d73:	0f b6 00             	movzbl (%rax),%eax
  800d76:	3c 25                	cmp    $0x25,%al
  800d78:	75 ec                	jne    800d66 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d7a:	90                   	nop
		}
	}
  800d7b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7c:	e9 30 fb ff ff       	jmpq   8008b1 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d81:	48 83 c4 60          	add    $0x60,%rsp
  800d85:	5b                   	pop    %rbx
  800d86:	41 5c                	pop    %r12
  800d88:	5d                   	pop    %rbp
  800d89:	c3                   	retq   

0000000000800d8a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d8a:	55                   	push   %rbp
  800d8b:	48 89 e5             	mov    %rsp,%rbp
  800d8e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d95:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d9c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800da3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800daa:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db8:	84 c0                	test   %al,%al
  800dba:	74 20                	je     800ddc <printfmt+0x52>
  800dbc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dcc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ddc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800de3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dea:	00 00 00 
  800ded:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800df4:	00 00 00 
  800df7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dfb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e02:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e09:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e10:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e17:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e1e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e25:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e2c:	48 89 c7             	mov    %rax,%rdi
  800e2f:	48 b8 5f 08 80 00 00 	movabs $0x80085f,%rax
  800e36:	00 00 00 
  800e39:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e3b:	c9                   	leaveq 
  800e3c:	c3                   	retq   

0000000000800e3d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e3d:	55                   	push   %rbp
  800e3e:	48 89 e5             	mov    %rsp,%rbp
  800e41:	48 83 ec 10          	sub    $0x10,%rsp
  800e45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e48:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e50:	8b 40 10             	mov    0x10(%rax),%eax
  800e53:	8d 50 01             	lea    0x1(%rax),%edx
  800e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e61:	48 8b 10             	mov    (%rax),%rdx
  800e64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e68:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e6c:	48 39 c2             	cmp    %rax,%rdx
  800e6f:	73 17                	jae    800e88 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e75:	48 8b 00             	mov    (%rax),%rax
  800e78:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e80:	48 89 0a             	mov    %rcx,(%rdx)
  800e83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e86:	88 10                	mov    %dl,(%rax)
}
  800e88:	c9                   	leaveq 
  800e89:	c3                   	retq   

0000000000800e8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e8a:	55                   	push   %rbp
  800e8b:	48 89 e5             	mov    %rsp,%rbp
  800e8e:	48 83 ec 50          	sub    $0x50,%rsp
  800e92:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e96:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e99:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e9d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ea1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ea5:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ea9:	48 8b 0a             	mov    (%rdx),%rcx
  800eac:	48 89 08             	mov    %rcx,(%rax)
  800eaf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eb7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ebb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ebf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ec7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eca:	48 98                	cltq   
  800ecc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ed0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed4:	48 01 d0             	add    %rdx,%rax
  800ed7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800edb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ee2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ee7:	74 06                	je     800eef <vsnprintf+0x65>
  800ee9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eed:	7f 07                	jg     800ef6 <vsnprintf+0x6c>
		return -E_INVAL;
  800eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef4:	eb 2f                	jmp    800f25 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ef6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800efa:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800efe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f02:	48 89 c6             	mov    %rax,%rsi
  800f05:	48 bf 3d 0e 80 00 00 	movabs $0x800e3d,%rdi
  800f0c:	00 00 00 
  800f0f:	48 b8 5f 08 80 00 00 	movabs $0x80085f,%rax
  800f16:	00 00 00 
  800f19:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f1f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f22:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f25:	c9                   	leaveq 
  800f26:	c3                   	retq   

0000000000800f27 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f27:	55                   	push   %rbp
  800f28:	48 89 e5             	mov    %rsp,%rbp
  800f2b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f32:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f39:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f3f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f46:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f4d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f54:	84 c0                	test   %al,%al
  800f56:	74 20                	je     800f78 <snprintf+0x51>
  800f58:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f60:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f64:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f68:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f70:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f74:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f78:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f7f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f86:	00 00 00 
  800f89:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f90:	00 00 00 
  800f93:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f97:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f9e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fac:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fb3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fba:	48 8b 0a             	mov    (%rdx),%rcx
  800fbd:	48 89 08             	mov    %rcx,(%rax)
  800fc0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fc8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fcc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fd0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fd7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fde:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fe4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800feb:	48 89 c7             	mov    %rax,%rdi
  800fee:	48 b8 8a 0e 80 00 00 	movabs $0x800e8a,%rax
  800ff5:	00 00 00 
  800ff8:	ff d0                	callq  *%rax
  800ffa:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801000:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801006:	c9                   	leaveq 
  801007:	c3                   	retq   

0000000000801008 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801008:	55                   	push   %rbp
  801009:	48 89 e5             	mov    %rsp,%rbp
  80100c:	48 83 ec 18          	sub    $0x18,%rsp
  801010:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80101b:	eb 09                	jmp    801026 <strlen+0x1e>
		n++;
  80101d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801021:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102a:	0f b6 00             	movzbl (%rax),%eax
  80102d:	84 c0                	test   %al,%al
  80102f:	75 ec                	jne    80101d <strlen+0x15>
		n++;
	return n;
  801031:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801034:	c9                   	leaveq 
  801035:	c3                   	retq   

0000000000801036 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801036:	55                   	push   %rbp
  801037:	48 89 e5             	mov    %rsp,%rbp
  80103a:	48 83 ec 20          	sub    $0x20,%rsp
  80103e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801042:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80104d:	eb 0e                	jmp    80105d <strnlen+0x27>
		n++;
  80104f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801053:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801058:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80105d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801062:	74 0b                	je     80106f <strnlen+0x39>
  801064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801068:	0f b6 00             	movzbl (%rax),%eax
  80106b:	84 c0                	test   %al,%al
  80106d:	75 e0                	jne    80104f <strnlen+0x19>
		n++;
	return n;
  80106f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801072:	c9                   	leaveq 
  801073:	c3                   	retq   

0000000000801074 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801074:	55                   	push   %rbp
  801075:	48 89 e5             	mov    %rsp,%rbp
  801078:	48 83 ec 20          	sub    $0x20,%rsp
  80107c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801080:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801088:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80108c:	90                   	nop
  80108d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801091:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801095:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801099:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80109d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010a5:	0f b6 12             	movzbl (%rdx),%edx
  8010a8:	88 10                	mov    %dl,(%rax)
  8010aa:	0f b6 00             	movzbl (%rax),%eax
  8010ad:	84 c0                	test   %al,%al
  8010af:	75 dc                	jne    80108d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b5:	c9                   	leaveq 
  8010b6:	c3                   	retq   

00000000008010b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010b7:	55                   	push   %rbp
  8010b8:	48 89 e5             	mov    %rsp,%rbp
  8010bb:	48 83 ec 20          	sub    $0x20,%rsp
  8010bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cb:	48 89 c7             	mov    %rax,%rdi
  8010ce:	48 b8 08 10 80 00 00 	movabs $0x801008,%rax
  8010d5:	00 00 00 
  8010d8:	ff d0                	callq  *%rax
  8010da:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e0:	48 63 d0             	movslq %eax,%rdx
  8010e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e7:	48 01 c2             	add    %rax,%rdx
  8010ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ee:	48 89 c6             	mov    %rax,%rsi
  8010f1:	48 89 d7             	mov    %rdx,%rdi
  8010f4:	48 b8 74 10 80 00 00 	movabs $0x801074,%rax
  8010fb:	00 00 00 
  8010fe:	ff d0                	callq  *%rax
	return dst;
  801100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801104:	c9                   	leaveq 
  801105:	c3                   	retq   

0000000000801106 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	48 83 ec 28          	sub    $0x28,%rsp
  80110e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801112:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801116:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801122:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801129:	00 
  80112a:	eb 2a                	jmp    801156 <strncpy+0x50>
		*dst++ = *src;
  80112c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801130:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801134:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801138:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80113c:	0f b6 12             	movzbl (%rdx),%edx
  80113f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801141:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801145:	0f b6 00             	movzbl (%rax),%eax
  801148:	84 c0                	test   %al,%al
  80114a:	74 05                	je     801151 <strncpy+0x4b>
			src++;
  80114c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801151:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80115e:	72 cc                	jb     80112c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801164:	c9                   	leaveq 
  801165:	c3                   	retq   

0000000000801166 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801166:	55                   	push   %rbp
  801167:	48 89 e5             	mov    %rsp,%rbp
  80116a:	48 83 ec 28          	sub    $0x28,%rsp
  80116e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801172:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801176:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801182:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801187:	74 3d                	je     8011c6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801189:	eb 1d                	jmp    8011a8 <strlcpy+0x42>
			*dst++ = *src++;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801193:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801197:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80119b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80119f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a3:	0f b6 12             	movzbl (%rdx),%edx
  8011a6:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011a8:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011ad:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b2:	74 0b                	je     8011bf <strlcpy+0x59>
  8011b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b8:	0f b6 00             	movzbl (%rax),%eax
  8011bb:	84 c0                	test   %al,%al
  8011bd:	75 cc                	jne    80118b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ce:	48 29 c2             	sub    %rax,%rdx
  8011d1:	48 89 d0             	mov    %rdx,%rax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 10          	sub    $0x10,%rsp
  8011de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011e6:	eb 0a                	jmp    8011f2 <strcmp+0x1c>
		p++, q++;
  8011e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f6:	0f b6 00             	movzbl (%rax),%eax
  8011f9:	84 c0                	test   %al,%al
  8011fb:	74 12                	je     80120f <strcmp+0x39>
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	0f b6 10             	movzbl (%rax),%edx
  801204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801208:	0f b6 00             	movzbl (%rax),%eax
  80120b:	38 c2                	cmp    %al,%dl
  80120d:	74 d9                	je     8011e8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80120f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801213:	0f b6 00             	movzbl (%rax),%eax
  801216:	0f b6 d0             	movzbl %al,%edx
  801219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121d:	0f b6 00             	movzbl (%rax),%eax
  801220:	0f b6 c0             	movzbl %al,%eax
  801223:	29 c2                	sub    %eax,%edx
  801225:	89 d0                	mov    %edx,%eax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 18          	sub    $0x18,%rsp
  801231:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801235:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801239:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80123d:	eb 0f                	jmp    80124e <strncmp+0x25>
		n--, p++, q++;
  80123f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801244:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801249:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80124e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801253:	74 1d                	je     801272 <strncmp+0x49>
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	84 c0                	test   %al,%al
  80125e:	74 12                	je     801272 <strncmp+0x49>
  801260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801264:	0f b6 10             	movzbl (%rax),%edx
  801267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	38 c2                	cmp    %al,%dl
  801270:	74 cd                	je     80123f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801272:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801277:	75 07                	jne    801280 <strncmp+0x57>
		return 0;
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
  80127e:	eb 18                	jmp    801298 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 d0             	movzbl %al,%edx
  80128a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	0f b6 c0             	movzbl %al,%eax
  801294:	29 c2                	sub    %eax,%edx
  801296:	89 d0                	mov    %edx,%eax
}
  801298:	c9                   	leaveq 
  801299:	c3                   	retq   

000000000080129a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80129a:	55                   	push   %rbp
  80129b:	48 89 e5             	mov    %rsp,%rbp
  80129e:	48 83 ec 0c          	sub    $0xc,%rsp
  8012a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a6:	89 f0                	mov    %esi,%eax
  8012a8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ab:	eb 17                	jmp    8012c4 <strchr+0x2a>
		if (*s == c)
  8012ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b1:	0f b6 00             	movzbl (%rax),%eax
  8012b4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012b7:	75 06                	jne    8012bf <strchr+0x25>
			return (char *) s;
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	eb 15                	jmp    8012d4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	0f b6 00             	movzbl (%rax),%eax
  8012cb:	84 c0                	test   %al,%al
  8012cd:	75 de                	jne    8012ad <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d4:	c9                   	leaveq 
  8012d5:	c3                   	retq   

00000000008012d6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d6:	55                   	push   %rbp
  8012d7:	48 89 e5             	mov    %rsp,%rbp
  8012da:	48 83 ec 0c          	sub    $0xc,%rsp
  8012de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e2:	89 f0                	mov    %esi,%eax
  8012e4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e7:	eb 13                	jmp    8012fc <strfind+0x26>
		if (*s == c)
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f3:	75 02                	jne    8012f7 <strfind+0x21>
			break;
  8012f5:	eb 10                	jmp    801307 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801300:	0f b6 00             	movzbl (%rax),%eax
  801303:	84 c0                	test   %al,%al
  801305:	75 e2                	jne    8012e9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130b:	c9                   	leaveq 
  80130c:	c3                   	retq   

000000000080130d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80130d:	55                   	push   %rbp
  80130e:	48 89 e5             	mov    %rsp,%rbp
  801311:	48 83 ec 18          	sub    $0x18,%rsp
  801315:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801319:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80131c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801320:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801325:	75 06                	jne    80132d <memset+0x20>
		return v;
  801327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132b:	eb 69                	jmp    801396 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	83 e0 03             	and    $0x3,%eax
  801334:	48 85 c0             	test   %rax,%rax
  801337:	75 48                	jne    801381 <memset+0x74>
  801339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133d:	83 e0 03             	and    $0x3,%eax
  801340:	48 85 c0             	test   %rax,%rax
  801343:	75 3c                	jne    801381 <memset+0x74>
		c &= 0xFF;
  801345:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80134c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134f:	c1 e0 18             	shl    $0x18,%eax
  801352:	89 c2                	mov    %eax,%edx
  801354:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801357:	c1 e0 10             	shl    $0x10,%eax
  80135a:	09 c2                	or     %eax,%edx
  80135c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135f:	c1 e0 08             	shl    $0x8,%eax
  801362:	09 d0                	or     %edx,%eax
  801364:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	48 c1 e8 02          	shr    $0x2,%rax
  80136f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801372:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801376:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801379:	48 89 d7             	mov    %rdx,%rdi
  80137c:	fc                   	cld    
  80137d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80137f:	eb 11                	jmp    801392 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801381:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801385:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801388:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80138c:	48 89 d7             	mov    %rdx,%rdi
  80138f:	fc                   	cld    
  801390:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801396:	c9                   	leaveq 
  801397:	c3                   	retq   

0000000000801398 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801398:	55                   	push   %rbp
  801399:	48 89 e5             	mov    %rsp,%rbp
  80139c:	48 83 ec 28          	sub    $0x28,%rsp
  8013a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c4:	0f 83 88 00 00 00    	jae    801452 <memmove+0xba>
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d2:	48 01 d0             	add    %rdx,%rax
  8013d5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013d9:	76 77                	jbe    801452 <memmove+0xba>
		s += n;
  8013db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013df:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ef:	83 e0 03             	and    $0x3,%eax
  8013f2:	48 85 c0             	test   %rax,%rax
  8013f5:	75 3b                	jne    801432 <memmove+0x9a>
  8013f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fb:	83 e0 03             	and    $0x3,%eax
  8013fe:	48 85 c0             	test   %rax,%rax
  801401:	75 2f                	jne    801432 <memmove+0x9a>
  801403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801407:	83 e0 03             	and    $0x3,%eax
  80140a:	48 85 c0             	test   %rax,%rax
  80140d:	75 23                	jne    801432 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80140f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801413:	48 83 e8 04          	sub    $0x4,%rax
  801417:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141b:	48 83 ea 04          	sub    $0x4,%rdx
  80141f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801423:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801427:	48 89 c7             	mov    %rax,%rdi
  80142a:	48 89 d6             	mov    %rdx,%rsi
  80142d:	fd                   	std    
  80142e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801430:	eb 1d                	jmp    80144f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801436:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80143a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801446:	48 89 d7             	mov    %rdx,%rdi
  801449:	48 89 c1             	mov    %rax,%rcx
  80144c:	fd                   	std    
  80144d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80144f:	fc                   	cld    
  801450:	eb 57                	jmp    8014a9 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801456:	83 e0 03             	and    $0x3,%eax
  801459:	48 85 c0             	test   %rax,%rax
  80145c:	75 36                	jne    801494 <memmove+0xfc>
  80145e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801462:	83 e0 03             	and    $0x3,%eax
  801465:	48 85 c0             	test   %rax,%rax
  801468:	75 2a                	jne    801494 <memmove+0xfc>
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	83 e0 03             	and    $0x3,%eax
  801471:	48 85 c0             	test   %rax,%rax
  801474:	75 1e                	jne    801494 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147a:	48 c1 e8 02          	shr    $0x2,%rax
  80147e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801489:	48 89 c7             	mov    %rax,%rdi
  80148c:	48 89 d6             	mov    %rdx,%rsi
  80148f:	fc                   	cld    
  801490:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801492:	eb 15                	jmp    8014a9 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801494:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801498:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a0:	48 89 c7             	mov    %rax,%rdi
  8014a3:	48 89 d6             	mov    %rdx,%rsi
  8014a6:	fc                   	cld    
  8014a7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014ad:	c9                   	leaveq 
  8014ae:	c3                   	retq   

00000000008014af <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014af:	55                   	push   %rbp
  8014b0:	48 89 e5             	mov    %rsp,%rbp
  8014b3:	48 83 ec 18          	sub    $0x18,%rsp
  8014b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014c7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cf:	48 89 ce             	mov    %rcx,%rsi
  8014d2:	48 89 c7             	mov    %rax,%rdi
  8014d5:	48 b8 98 13 80 00 00 	movabs $0x801398,%rax
  8014dc:	00 00 00 
  8014df:	ff d0                	callq  *%rax
}
  8014e1:	c9                   	leaveq 
  8014e2:	c3                   	retq   

00000000008014e3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014e3:	55                   	push   %rbp
  8014e4:	48 89 e5             	mov    %rsp,%rbp
  8014e7:	48 83 ec 28          	sub    $0x28,%rsp
  8014eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801503:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801507:	eb 36                	jmp    80153f <memcmp+0x5c>
		if (*s1 != *s2)
  801509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150d:	0f b6 10             	movzbl (%rax),%edx
  801510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801514:	0f b6 00             	movzbl (%rax),%eax
  801517:	38 c2                	cmp    %al,%dl
  801519:	74 1a                	je     801535 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80151b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	0f b6 d0             	movzbl %al,%edx
  801525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	0f b6 c0             	movzbl %al,%eax
  80152f:	29 c2                	sub    %eax,%edx
  801531:	89 d0                	mov    %edx,%eax
  801533:	eb 20                	jmp    801555 <memcmp+0x72>
		s1++, s2++;
  801535:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80153f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801543:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801547:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80154b:	48 85 c0             	test   %rax,%rax
  80154e:	75 b9                	jne    801509 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801555:	c9                   	leaveq 
  801556:	c3                   	retq   

0000000000801557 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801557:	55                   	push   %rbp
  801558:	48 89 e5             	mov    %rsp,%rbp
  80155b:	48 83 ec 28          	sub    $0x28,%rsp
  80155f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801563:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801566:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801572:	48 01 d0             	add    %rdx,%rax
  801575:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801579:	eb 15                	jmp    801590 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157f:	0f b6 10             	movzbl (%rax),%edx
  801582:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801585:	38 c2                	cmp    %al,%dl
  801587:	75 02                	jne    80158b <memfind+0x34>
			break;
  801589:	eb 0f                	jmp    80159a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801594:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801598:	72 e1                	jb     80157b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80159a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80159e:	c9                   	leaveq 
  80159f:	c3                   	retq   

00000000008015a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a0:	55                   	push   %rbp
  8015a1:	48 89 e5             	mov    %rsp,%rbp
  8015a4:	48 83 ec 34          	sub    $0x34,%rsp
  8015a8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015ac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015b0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015ba:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015c1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c2:	eb 05                	jmp    8015c9 <strtol+0x29>
		s++;
  8015c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	0f b6 00             	movzbl (%rax),%eax
  8015d0:	3c 20                	cmp    $0x20,%al
  8015d2:	74 f0                	je     8015c4 <strtol+0x24>
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	0f b6 00             	movzbl (%rax),%eax
  8015db:	3c 09                	cmp    $0x9,%al
  8015dd:	74 e5                	je     8015c4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	3c 2b                	cmp    $0x2b,%al
  8015e8:	75 07                	jne    8015f1 <strtol+0x51>
		s++;
  8015ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ef:	eb 17                	jmp    801608 <strtol+0x68>
	else if (*s == '-')
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 2d                	cmp    $0x2d,%al
  8015fa:	75 0c                	jne    801608 <strtol+0x68>
		s++, neg = 1;
  8015fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801601:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801608:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160c:	74 06                	je     801614 <strtol+0x74>
  80160e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801612:	75 28                	jne    80163c <strtol+0x9c>
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 30                	cmp    $0x30,%al
  80161d:	75 1d                	jne    80163c <strtol+0x9c>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	48 83 c0 01          	add    $0x1,%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	3c 78                	cmp    $0x78,%al
  80162c:	75 0e                	jne    80163c <strtol+0x9c>
		s += 2, base = 16;
  80162e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801633:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80163a:	eb 2c                	jmp    801668 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80163c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801640:	75 19                	jne    80165b <strtol+0xbb>
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	3c 30                	cmp    $0x30,%al
  80164b:	75 0e                	jne    80165b <strtol+0xbb>
		s++, base = 8;
  80164d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801652:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801659:	eb 0d                	jmp    801668 <strtol+0xc8>
	else if (base == 0)
  80165b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80165f:	75 07                	jne    801668 <strtol+0xc8>
		base = 10;
  801661:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	3c 2f                	cmp    $0x2f,%al
  801671:	7e 1d                	jle    801690 <strtol+0xf0>
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	3c 39                	cmp    $0x39,%al
  80167c:	7f 12                	jg     801690 <strtol+0xf0>
			dig = *s - '0';
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	0f be c0             	movsbl %al,%eax
  801688:	83 e8 30             	sub    $0x30,%eax
  80168b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168e:	eb 4e                	jmp    8016de <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	3c 60                	cmp    $0x60,%al
  801699:	7e 1d                	jle    8016b8 <strtol+0x118>
  80169b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	3c 7a                	cmp    $0x7a,%al
  8016a4:	7f 12                	jg     8016b8 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	0f b6 00             	movzbl (%rax),%eax
  8016ad:	0f be c0             	movsbl %al,%eax
  8016b0:	83 e8 57             	sub    $0x57,%eax
  8016b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b6:	eb 26                	jmp    8016de <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bc:	0f b6 00             	movzbl (%rax),%eax
  8016bf:	3c 40                	cmp    $0x40,%al
  8016c1:	7e 48                	jle    80170b <strtol+0x16b>
  8016c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c7:	0f b6 00             	movzbl (%rax),%eax
  8016ca:	3c 5a                	cmp    $0x5a,%al
  8016cc:	7f 3d                	jg     80170b <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	0f be c0             	movsbl %al,%eax
  8016d8:	83 e8 37             	sub    $0x37,%eax
  8016db:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016e4:	7c 02                	jl     8016e8 <strtol+0x148>
			break;
  8016e6:	eb 23                	jmp    80170b <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016e8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ed:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016f0:	48 98                	cltq   
  8016f2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016f7:	48 89 c2             	mov    %rax,%rdx
  8016fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016fd:	48 98                	cltq   
  8016ff:	48 01 d0             	add    %rdx,%rax
  801702:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801706:	e9 5d ff ff ff       	jmpq   801668 <strtol+0xc8>

	if (endptr)
  80170b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801710:	74 0b                	je     80171d <strtol+0x17d>
		*endptr = (char *) s;
  801712:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801716:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80171a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80171d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801721:	74 09                	je     80172c <strtol+0x18c>
  801723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801727:	48 f7 d8             	neg    %rax
  80172a:	eb 04                	jmp    801730 <strtol+0x190>
  80172c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801730:	c9                   	leaveq 
  801731:	c3                   	retq   

0000000000801732 <strstr>:

char * strstr(const char *in, const char *str)
{
  801732:	55                   	push   %rbp
  801733:	48 89 e5             	mov    %rsp,%rbp
  801736:	48 83 ec 30          	sub    $0x30,%rsp
  80173a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80173e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801742:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801746:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80174a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80174e:	0f b6 00             	movzbl (%rax),%eax
  801751:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801754:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801758:	75 06                	jne    801760 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80175a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175e:	eb 6b                	jmp    8017cb <strstr+0x99>

	len = strlen(str);
  801760:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801764:	48 89 c7             	mov    %rax,%rdi
  801767:	48 b8 08 10 80 00 00 	movabs $0x801008,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
  801773:	48 98                	cltq   
  801775:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801781:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801785:	0f b6 00             	movzbl (%rax),%eax
  801788:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80178b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80178f:	75 07                	jne    801798 <strstr+0x66>
				return (char *) 0;
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
  801796:	eb 33                	jmp    8017cb <strstr+0x99>
		} while (sc != c);
  801798:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80179c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80179f:	75 d8                	jne    801779 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	48 89 ce             	mov    %rcx,%rsi
  8017b0:	48 89 c7             	mov    %rax,%rdi
  8017b3:	48 b8 29 12 80 00 00 	movabs $0x801229,%rax
  8017ba:	00 00 00 
  8017bd:	ff d0                	callq  *%rax
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	75 b6                	jne    801779 <strstr+0x47>

	return (char *) (in - 1);
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	48 83 e8 01          	sub    $0x1,%rax
}
  8017cb:	c9                   	leaveq 
  8017cc:	c3                   	retq   
