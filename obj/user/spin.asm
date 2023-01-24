
obj/user/spin:     file format elf64-x86-64


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
  80003c:	e8 07 01 00 00       	callq  800148 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800052:	48 bf a0 22 80 00 00 	movabs $0x8022a0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 15 03 80 00 00 	movabs $0x800315,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf c8 22 80 00 00 	movabs $0x8022c8,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 15 03 80 00 00 	movabs $0x800315,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009d:	eb fe                	jmp    80009d <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  80009f:	48 bf e8 22 80 00 00 	movabs $0x8022e8,%rdi
  8000a6:	00 00 00 
  8000a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ae:	48 ba 15 03 80 00 00 	movabs $0x800315,%rdx
  8000b5:	00 00 00 
  8000b8:	ff d2                	callq  *%rdx
	sys_yield();
  8000ba:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
	sys_yield();
  8000c6:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
	sys_yield();
  8000d2:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
	sys_yield();
  8000de:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
	sys_yield();
  8000ea:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_yield();
  8000f6:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
	sys_yield();
  800102:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	sys_yield();
  80010e:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011a:	48 bf 10 23 80 00 00 	movabs $0x802310,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 15 03 80 00 00 	movabs $0x800315,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800138:	89 c7                	mov    %eax,%edi
  80013a:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
}
  800146:	c9                   	leaveq 
  800147:	c3                   	retq   

0000000000800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	48 83 ec 20          	sub    $0x20,%rsp
  800150:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800157:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800169:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016e:	48 63 d0             	movslq %eax,%rdx
  800171:	48 89 d0             	mov    %rdx,%rax
  800174:	48 c1 e0 03          	shl    $0x3,%rax
  800178:	48 01 d0             	add    %rdx,%rax
  80017b:	48 c1 e0 05          	shl    $0x5,%rax
  80017f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800186:	00 00 00 
  800189:	48 01 c2             	add    %rax,%rdx
  80018c:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800193:	00 00 00 
  800196:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800199:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80019d:	7e 14                	jle    8001b3 <libmain+0x6b>
		binaryname = argv[0];
  80019f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001a3:	48 8b 10             	mov    (%rax),%rdx
  8001a6:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8001ad:	00 00 00 
  8001b0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ba:	48 89 d6             	mov    %rdx,%rsi
  8001bd:	89 c7                	mov    %eax,%edi
  8001bf:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c6:	00 00 00 
  8001c9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001cb:	48 b8 d9 01 80 00 00 	movabs $0x8001d9,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
}
  8001d7:	c9                   	leaveq 
  8001d8:	c3                   	retq   

00000000008001d9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d9:	55                   	push   %rbp
  8001da:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e2:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax
}
  8001ee:	5d                   	pop    %rbp
  8001ef:	c3                   	retq   

00000000008001f0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001f0:	55                   	push   %rbp
  8001f1:	48 89 e5             	mov    %rsp,%rbp
  8001f4:	48 83 ec 10          	sub    $0x10,%rsp
  8001f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800203:	8b 00                	mov    (%rax),%eax
  800205:	8d 48 01             	lea    0x1(%rax),%ecx
  800208:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80020c:	89 0a                	mov    %ecx,(%rdx)
  80020e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800211:	89 d1                	mov    %edx,%ecx
  800213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800217:	48 98                	cltq   
  800219:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80021d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800221:	8b 00                	mov    (%rax),%eax
  800223:	3d ff 00 00 00       	cmp    $0xff,%eax
  800228:	75 2c                	jne    800256 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80022a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022e:	8b 00                	mov    (%rax),%eax
  800230:	48 98                	cltq   
  800232:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800236:	48 83 c2 08          	add    $0x8,%rdx
  80023a:	48 89 c6             	mov    %rax,%rsi
  80023d:	48 89 d7             	mov    %rdx,%rdi
  800240:	48 b8 c4 16 80 00 00 	movabs $0x8016c4,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax
        b->idx = 0;
  80024c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800250:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025a:	8b 40 04             	mov    0x4(%rax),%eax
  80025d:	8d 50 01             	lea    0x1(%rax),%edx
  800260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800264:	89 50 04             	mov    %edx,0x4(%rax)
}
  800267:	c9                   	leaveq 
  800268:	c3                   	retq   

0000000000800269 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800269:	55                   	push   %rbp
  80026a:	48 89 e5             	mov    %rsp,%rbp
  80026d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800274:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80027b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800282:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800289:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800290:	48 8b 0a             	mov    (%rdx),%rcx
  800293:	48 89 08             	mov    %rcx,(%rax)
  800296:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80029a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80029e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002a2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002ad:	00 00 00 
    b.cnt = 0;
  8002b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002b7:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002ba:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002c1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002c8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002cf:	48 89 c6             	mov    %rax,%rsi
  8002d2:	48 bf f0 01 80 00 00 	movabs $0x8001f0,%rdi
  8002d9:	00 00 00 
  8002dc:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  8002e3:	00 00 00 
  8002e6:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002e8:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002ee:	48 98                	cltq   
  8002f0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002f7:	48 83 c2 08          	add    $0x8,%rdx
  8002fb:	48 89 c6             	mov    %rax,%rsi
  8002fe:	48 89 d7             	mov    %rdx,%rdi
  800301:	48 b8 c4 16 80 00 00 	movabs $0x8016c4,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80030d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800313:	c9                   	leaveq 
  800314:	c3                   	retq   

0000000000800315 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800315:	55                   	push   %rbp
  800316:	48 89 e5             	mov    %rsp,%rbp
  800319:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800320:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800327:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80032e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800335:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80033c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800343:	84 c0                	test   %al,%al
  800345:	74 20                	je     800367 <cprintf+0x52>
  800347:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80034b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80034f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800353:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800357:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80035b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80035f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800363:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800367:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80036e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800375:	00 00 00 
  800378:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80037f:	00 00 00 
  800382:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800386:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80038d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800394:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80039b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003a2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003a9:	48 8b 0a             	mov    (%rdx),%rcx
  8003ac:	48 89 08             	mov    %rcx,(%rax)
  8003af:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003b3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003b7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003bf:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003cd:	48 89 d6             	mov    %rdx,%rsi
  8003d0:	48 89 c7             	mov    %rax,%rdi
  8003d3:	48 b8 69 02 80 00 00 	movabs $0x800269,%rax
  8003da:	00 00 00 
  8003dd:	ff d0                	callq  *%rax
  8003df:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003e5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003eb:	c9                   	leaveq 
  8003ec:	c3                   	retq   

00000000008003ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ed:	55                   	push   %rbp
  8003ee:	48 89 e5             	mov    %rsp,%rbp
  8003f1:	53                   	push   %rbx
  8003f2:	48 83 ec 38          	sub    $0x38,%rsp
  8003f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800402:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800405:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800409:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80040d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800410:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800414:	77 3b                	ja     800451 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800416:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800419:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80041d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	48 f7 f3             	div    %rbx
  80042c:	48 89 c2             	mov    %rax,%rdx
  80042f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800432:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800435:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043d:	41 89 f9             	mov    %edi,%r9d
  800440:	48 89 c7             	mov    %rax,%rdi
  800443:	48 b8 ed 03 80 00 00 	movabs $0x8003ed,%rax
  80044a:	00 00 00 
  80044d:	ff d0                	callq  *%rax
  80044f:	eb 1e                	jmp    80046f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800451:	eb 12                	jmp    800465 <printnum+0x78>
			putch(padc, putdat);
  800453:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800457:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80045a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045e:	48 89 ce             	mov    %rcx,%rsi
  800461:	89 d7                	mov    %edx,%edi
  800463:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800465:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800469:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80046d:	7f e4                	jg     800453 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800476:	ba 00 00 00 00       	mov    $0x0,%edx
  80047b:	48 f7 f1             	div    %rcx
  80047e:	48 89 d0             	mov    %rdx,%rax
  800481:	48 ba b0 24 80 00 00 	movabs $0x8024b0,%rdx
  800488:	00 00 00 
  80048b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80048f:	0f be d0             	movsbl %al,%edx
  800492:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800496:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049a:	48 89 ce             	mov    %rcx,%rsi
  80049d:	89 d7                	mov    %edx,%edi
  80049f:	ff d0                	callq  *%rax
}
  8004a1:	48 83 c4 38          	add    $0x38,%rsp
  8004a5:	5b                   	pop    %rbx
  8004a6:	5d                   	pop    %rbp
  8004a7:	c3                   	retq   

00000000008004a8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a8:	55                   	push   %rbp
  8004a9:	48 89 e5             	mov    %rsp,%rbp
  8004ac:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004b7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004bb:	7e 52                	jle    80050f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c1:	8b 00                	mov    (%rax),%eax
  8004c3:	83 f8 30             	cmp    $0x30,%eax
  8004c6:	73 24                	jae    8004ec <getuint+0x44>
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d4:	8b 00                	mov    (%rax),%eax
  8004d6:	89 c0                	mov    %eax,%eax
  8004d8:	48 01 d0             	add    %rdx,%rax
  8004db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004df:	8b 12                	mov    (%rdx),%edx
  8004e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e8:	89 0a                	mov    %ecx,(%rdx)
  8004ea:	eb 17                	jmp    800503 <getuint+0x5b>
  8004ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f4:	48 89 d0             	mov    %rdx,%rax
  8004f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800503:	48 8b 00             	mov    (%rax),%rax
  800506:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80050a:	e9 a3 00 00 00       	jmpq   8005b2 <getuint+0x10a>
	else if (lflag)
  80050f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800513:	74 4f                	je     800564 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800515:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800519:	8b 00                	mov    (%rax),%eax
  80051b:	83 f8 30             	cmp    $0x30,%eax
  80051e:	73 24                	jae    800544 <getuint+0x9c>
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052c:	8b 00                	mov    (%rax),%eax
  80052e:	89 c0                	mov    %eax,%eax
  800530:	48 01 d0             	add    %rdx,%rax
  800533:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800537:	8b 12                	mov    (%rdx),%edx
  800539:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80053c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800540:	89 0a                	mov    %ecx,(%rdx)
  800542:	eb 17                	jmp    80055b <getuint+0xb3>
  800544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800548:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80054c:	48 89 d0             	mov    %rdx,%rax
  80054f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800553:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800557:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80055b:	48 8b 00             	mov    (%rax),%rax
  80055e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800562:	eb 4e                	jmp    8005b2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800568:	8b 00                	mov    (%rax),%eax
  80056a:	83 f8 30             	cmp    $0x30,%eax
  80056d:	73 24                	jae    800593 <getuint+0xeb>
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057b:	8b 00                	mov    (%rax),%eax
  80057d:	89 c0                	mov    %eax,%eax
  80057f:	48 01 d0             	add    %rdx,%rax
  800582:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800586:	8b 12                	mov    (%rdx),%edx
  800588:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80058b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058f:	89 0a                	mov    %ecx,(%rdx)
  800591:	eb 17                	jmp    8005aa <getuint+0x102>
  800593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800597:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80059b:	48 89 d0             	mov    %rdx,%rax
  80059e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005aa:	8b 00                	mov    (%rax),%eax
  8005ac:	89 c0                	mov    %eax,%eax
  8005ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005b6:	c9                   	leaveq 
  8005b7:	c3                   	retq   

00000000008005b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005b8:	55                   	push   %rbp
  8005b9:	48 89 e5             	mov    %rsp,%rbp
  8005bc:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005c4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005c7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005cb:	7e 52                	jle    80061f <getint+0x67>
		x=va_arg(*ap, long long);
  8005cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d1:	8b 00                	mov    (%rax),%eax
  8005d3:	83 f8 30             	cmp    $0x30,%eax
  8005d6:	73 24                	jae    8005fc <getint+0x44>
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e4:	8b 00                	mov    (%rax),%eax
  8005e6:	89 c0                	mov    %eax,%eax
  8005e8:	48 01 d0             	add    %rdx,%rax
  8005eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ef:	8b 12                	mov    (%rdx),%edx
  8005f1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f8:	89 0a                	mov    %ecx,(%rdx)
  8005fa:	eb 17                	jmp    800613 <getint+0x5b>
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800604:	48 89 d0             	mov    %rdx,%rax
  800607:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800613:	48 8b 00             	mov    (%rax),%rax
  800616:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061a:	e9 a3 00 00 00       	jmpq   8006c2 <getint+0x10a>
	else if (lflag)
  80061f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800623:	74 4f                	je     800674 <getint+0xbc>
		x=va_arg(*ap, long);
  800625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800629:	8b 00                	mov    (%rax),%eax
  80062b:	83 f8 30             	cmp    $0x30,%eax
  80062e:	73 24                	jae    800654 <getint+0x9c>
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	89 c0                	mov    %eax,%eax
  800640:	48 01 d0             	add    %rdx,%rax
  800643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800647:	8b 12                	mov    (%rdx),%edx
  800649:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80064c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800650:	89 0a                	mov    %ecx,(%rdx)
  800652:	eb 17                	jmp    80066b <getint+0xb3>
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80065c:	48 89 d0             	mov    %rdx,%rax
  80065f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800667:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80066b:	48 8b 00             	mov    (%rax),%rax
  80066e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800672:	eb 4e                	jmp    8006c2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	8b 00                	mov    (%rax),%eax
  80067a:	83 f8 30             	cmp    $0x30,%eax
  80067d:	73 24                	jae    8006a3 <getint+0xeb>
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	89 c0                	mov    %eax,%eax
  80068f:	48 01 d0             	add    %rdx,%rax
  800692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800696:	8b 12                	mov    (%rdx),%edx
  800698:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80069b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069f:	89 0a                	mov    %ecx,(%rdx)
  8006a1:	eb 17                	jmp    8006ba <getint+0x102>
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ab:	48 89 d0             	mov    %rdx,%rax
  8006ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ba:	8b 00                	mov    (%rax),%eax
  8006bc:	48 98                	cltq   
  8006be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006c6:	c9                   	leaveq 
  8006c7:	c3                   	retq   

00000000008006c8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006c8:	55                   	push   %rbp
  8006c9:	48 89 e5             	mov    %rsp,%rbp
  8006cc:	41 54                	push   %r12
  8006ce:	53                   	push   %rbx
  8006cf:	48 83 ec 60          	sub    $0x60,%rsp
  8006d3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006d7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006db:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006df:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006e3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006e7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006eb:	48 8b 0a             	mov    (%rdx),%rcx
  8006ee:	48 89 08             	mov    %rcx,(%rax)
  8006f1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006f5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006f9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006fd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800701:	eb 17                	jmp    80071a <vprintfmt+0x52>
			if (ch == '\0')
  800703:	85 db                	test   %ebx,%ebx
  800705:	0f 84 df 04 00 00    	je     800bea <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80070b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80070f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800713:	48 89 d6             	mov    %rdx,%rsi
  800716:	89 df                	mov    %ebx,%edi
  800718:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80071e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800722:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800726:	0f b6 00             	movzbl (%rax),%eax
  800729:	0f b6 d8             	movzbl %al,%ebx
  80072c:	83 fb 25             	cmp    $0x25,%ebx
  80072f:	75 d2                	jne    800703 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800731:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800735:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80073c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800743:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80074a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800751:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800755:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800759:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80075d:	0f b6 00             	movzbl (%rax),%eax
  800760:	0f b6 d8             	movzbl %al,%ebx
  800763:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800766:	83 f8 55             	cmp    $0x55,%eax
  800769:	0f 87 47 04 00 00    	ja     800bb6 <vprintfmt+0x4ee>
  80076f:	89 c0                	mov    %eax,%eax
  800771:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800778:	00 
  800779:	48 b8 d8 24 80 00 00 	movabs $0x8024d8,%rax
  800780:	00 00 00 
  800783:	48 01 d0             	add    %rdx,%rax
  800786:	48 8b 00             	mov    (%rax),%rax
  800789:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80078b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80078f:	eb c0                	jmp    800751 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800791:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800795:	eb ba                	jmp    800751 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800797:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80079e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007a1:	89 d0                	mov    %edx,%eax
  8007a3:	c1 e0 02             	shl    $0x2,%eax
  8007a6:	01 d0                	add    %edx,%eax
  8007a8:	01 c0                	add    %eax,%eax
  8007aa:	01 d8                	add    %ebx,%eax
  8007ac:	83 e8 30             	sub    $0x30,%eax
  8007af:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007b2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007b6:	0f b6 00             	movzbl (%rax),%eax
  8007b9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007bc:	83 fb 2f             	cmp    $0x2f,%ebx
  8007bf:	7e 0c                	jle    8007cd <vprintfmt+0x105>
  8007c1:	83 fb 39             	cmp    $0x39,%ebx
  8007c4:	7f 07                	jg     8007cd <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007cb:	eb d1                	jmp    80079e <vprintfmt+0xd6>
			goto process_precision;
  8007cd:	eb 58                	jmp    800827 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d2:	83 f8 30             	cmp    $0x30,%eax
  8007d5:	73 17                	jae    8007ee <vprintfmt+0x126>
  8007d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007de:	89 c0                	mov    %eax,%eax
  8007e0:	48 01 d0             	add    %rdx,%rax
  8007e3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007e6:	83 c2 08             	add    $0x8,%edx
  8007e9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ec:	eb 0f                	jmp    8007fd <vprintfmt+0x135>
  8007ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f2:	48 89 d0             	mov    %rdx,%rax
  8007f5:	48 83 c2 08          	add    $0x8,%rdx
  8007f9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007fd:	8b 00                	mov    (%rax),%eax
  8007ff:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800802:	eb 23                	jmp    800827 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800804:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800808:	79 0c                	jns    800816 <vprintfmt+0x14e>
				width = 0;
  80080a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800811:	e9 3b ff ff ff       	jmpq   800751 <vprintfmt+0x89>
  800816:	e9 36 ff ff ff       	jmpq   800751 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80081b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800822:	e9 2a ff ff ff       	jmpq   800751 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800827:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80082b:	79 12                	jns    80083f <vprintfmt+0x177>
				width = precision, precision = -1;
  80082d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800830:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800833:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80083a:	e9 12 ff ff ff       	jmpq   800751 <vprintfmt+0x89>
  80083f:	e9 0d ff ff ff       	jmpq   800751 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800844:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800848:	e9 04 ff ff ff       	jmpq   800751 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80084d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800850:	83 f8 30             	cmp    $0x30,%eax
  800853:	73 17                	jae    80086c <vprintfmt+0x1a4>
  800855:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800859:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085c:	89 c0                	mov    %eax,%eax
  80085e:	48 01 d0             	add    %rdx,%rax
  800861:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800864:	83 c2 08             	add    $0x8,%edx
  800867:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086a:	eb 0f                	jmp    80087b <vprintfmt+0x1b3>
  80086c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800870:	48 89 d0             	mov    %rdx,%rax
  800873:	48 83 c2 08          	add    $0x8,%rdx
  800877:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80087b:	8b 10                	mov    (%rax),%edx
  80087d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800881:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800885:	48 89 ce             	mov    %rcx,%rsi
  800888:	89 d7                	mov    %edx,%edi
  80088a:	ff d0                	callq  *%rax
			break;
  80088c:	e9 53 03 00 00       	jmpq   800be4 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800894:	83 f8 30             	cmp    $0x30,%eax
  800897:	73 17                	jae    8008b0 <vprintfmt+0x1e8>
  800899:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80089d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a0:	89 c0                	mov    %eax,%eax
  8008a2:	48 01 d0             	add    %rdx,%rax
  8008a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a8:	83 c2 08             	add    $0x8,%edx
  8008ab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ae:	eb 0f                	jmp    8008bf <vprintfmt+0x1f7>
  8008b0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b4:	48 89 d0             	mov    %rdx,%rax
  8008b7:	48 83 c2 08          	add    $0x8,%rdx
  8008bb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008bf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008c1:	85 db                	test   %ebx,%ebx
  8008c3:	79 02                	jns    8008c7 <vprintfmt+0x1ff>
				err = -err;
  8008c5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008c7:	83 fb 15             	cmp    $0x15,%ebx
  8008ca:	7f 16                	jg     8008e2 <vprintfmt+0x21a>
  8008cc:	48 b8 00 24 80 00 00 	movabs $0x802400,%rax
  8008d3:	00 00 00 
  8008d6:	48 63 d3             	movslq %ebx,%rdx
  8008d9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008dd:	4d 85 e4             	test   %r12,%r12
  8008e0:	75 2e                	jne    800910 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008e2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ea:	89 d9                	mov    %ebx,%ecx
  8008ec:	48 ba c1 24 80 00 00 	movabs $0x8024c1,%rdx
  8008f3:	00 00 00 
  8008f6:	48 89 c7             	mov    %rax,%rdi
  8008f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fe:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  800905:	00 00 00 
  800908:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80090b:	e9 d4 02 00 00       	jmpq   800be4 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800910:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800914:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800918:	4c 89 e1             	mov    %r12,%rcx
  80091b:	48 ba ca 24 80 00 00 	movabs $0x8024ca,%rdx
  800922:	00 00 00 
  800925:	48 89 c7             	mov    %rax,%rdi
  800928:	b8 00 00 00 00       	mov    $0x0,%eax
  80092d:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  800934:	00 00 00 
  800937:	41 ff d0             	callq  *%r8
			break;
  80093a:	e9 a5 02 00 00       	jmpq   800be4 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80093f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800942:	83 f8 30             	cmp    $0x30,%eax
  800945:	73 17                	jae    80095e <vprintfmt+0x296>
  800947:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80094b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094e:	89 c0                	mov    %eax,%eax
  800950:	48 01 d0             	add    %rdx,%rax
  800953:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800956:	83 c2 08             	add    $0x8,%edx
  800959:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80095c:	eb 0f                	jmp    80096d <vprintfmt+0x2a5>
  80095e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800962:	48 89 d0             	mov    %rdx,%rax
  800965:	48 83 c2 08          	add    $0x8,%rdx
  800969:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80096d:	4c 8b 20             	mov    (%rax),%r12
  800970:	4d 85 e4             	test   %r12,%r12
  800973:	75 0a                	jne    80097f <vprintfmt+0x2b7>
				p = "(null)";
  800975:	49 bc cd 24 80 00 00 	movabs $0x8024cd,%r12
  80097c:	00 00 00 
			if (width > 0 && padc != '-')
  80097f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800983:	7e 3f                	jle    8009c4 <vprintfmt+0x2fc>
  800985:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800989:	74 39                	je     8009c4 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80098b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80098e:	48 98                	cltq   
  800990:	48 89 c6             	mov    %rax,%rsi
  800993:	4c 89 e7             	mov    %r12,%rdi
  800996:	48 b8 9f 0e 80 00 00 	movabs $0x800e9f,%rax
  80099d:	00 00 00 
  8009a0:	ff d0                	callq  *%rax
  8009a2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009a5:	eb 17                	jmp    8009be <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009a7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009ab:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b3:	48 89 ce             	mov    %rcx,%rsi
  8009b6:	89 d7                	mov    %edx,%edi
  8009b8:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c2:	7f e3                	jg     8009a7 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c4:	eb 37                	jmp    8009fd <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ca:	74 1e                	je     8009ea <vprintfmt+0x322>
  8009cc:	83 fb 1f             	cmp    $0x1f,%ebx
  8009cf:	7e 05                	jle    8009d6 <vprintfmt+0x30e>
  8009d1:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d4:	7e 14                	jle    8009ea <vprintfmt+0x322>
					putch('?', putdat);
  8009d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009de:	48 89 d6             	mov    %rdx,%rsi
  8009e1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009e6:	ff d0                	callq  *%rax
  8009e8:	eb 0f                	jmp    8009f9 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f2:	48 89 d6             	mov    %rdx,%rsi
  8009f5:	89 df                	mov    %ebx,%edi
  8009f7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009fd:	4c 89 e0             	mov    %r12,%rax
  800a00:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a04:	0f b6 00             	movzbl (%rax),%eax
  800a07:	0f be d8             	movsbl %al,%ebx
  800a0a:	85 db                	test   %ebx,%ebx
  800a0c:	74 10                	je     800a1e <vprintfmt+0x356>
  800a0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a12:	78 b2                	js     8009c6 <vprintfmt+0x2fe>
  800a14:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a18:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1c:	79 a8                	jns    8009c6 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1e:	eb 16                	jmp    800a36 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a28:	48 89 d6             	mov    %rdx,%rsi
  800a2b:	bf 20 00 00 00       	mov    $0x20,%edi
  800a30:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a36:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3a:	7f e4                	jg     800a20 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a3c:	e9 a3 01 00 00       	jmpq   800be4 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a41:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a45:	be 03 00 00 00       	mov    $0x3,%esi
  800a4a:	48 89 c7             	mov    %rax,%rdi
  800a4d:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  800a54:	00 00 00 
  800a57:	ff d0                	callq  *%rax
  800a59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a61:	48 85 c0             	test   %rax,%rax
  800a64:	79 1d                	jns    800a83 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6e:	48 89 d6             	mov    %rdx,%rsi
  800a71:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a76:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 f7 d8             	neg    %rax
  800a7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a83:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8a:	e9 e8 00 00 00       	jmpq   800b77 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a93:	be 03 00 00 00       	mov    $0x3,%esi
  800a98:	48 89 c7             	mov    %rax,%rdi
  800a9b:	48 b8 a8 04 80 00 00 	movabs $0x8004a8,%rax
  800aa2:	00 00 00 
  800aa5:	ff d0                	callq  *%rax
  800aa7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800aab:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab2:	e9 c0 00 00 00       	jmpq   800b77 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ab7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abf:	48 89 d6             	mov    %rdx,%rsi
  800ac2:	bf 58 00 00 00       	mov    $0x58,%edi
  800ac7:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ac9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800acd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad1:	48 89 d6             	mov    %rdx,%rsi
  800ad4:	bf 58 00 00 00       	mov    $0x58,%edi
  800ad9:	ff d0                	callq  *%rax
			putch('X', putdat);
  800adb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800adf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae3:	48 89 d6             	mov    %rdx,%rsi
  800ae6:	bf 58 00 00 00       	mov    $0x58,%edi
  800aeb:	ff d0                	callq  *%rax
			break;
  800aed:	e9 f2 00 00 00       	jmpq   800be4 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800af2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afa:	48 89 d6             	mov    %rdx,%rsi
  800afd:	bf 30 00 00 00       	mov    $0x30,%edi
  800b02:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0c:	48 89 d6             	mov    %rdx,%rsi
  800b0f:	bf 78 00 00 00       	mov    $0x78,%edi
  800b14:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b19:	83 f8 30             	cmp    $0x30,%eax
  800b1c:	73 17                	jae    800b35 <vprintfmt+0x46d>
  800b1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b25:	89 c0                	mov    %eax,%eax
  800b27:	48 01 d0             	add    %rdx,%rax
  800b2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2d:	83 c2 08             	add    $0x8,%edx
  800b30:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b33:	eb 0f                	jmp    800b44 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800b35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b39:	48 89 d0             	mov    %rdx,%rax
  800b3c:	48 83 c2 08          	add    $0x8,%rdx
  800b40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b44:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b4b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b52:	eb 23                	jmp    800b77 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b58:	be 03 00 00 00       	mov    $0x3,%esi
  800b5d:	48 89 c7             	mov    %rax,%rdi
  800b60:	48 b8 a8 04 80 00 00 	movabs $0x8004a8,%rax
  800b67:	00 00 00 
  800b6a:	ff d0                	callq  *%rax
  800b6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b70:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b77:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b7c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b7f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b86:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8e:	45 89 c1             	mov    %r8d,%r9d
  800b91:	41 89 f8             	mov    %edi,%r8d
  800b94:	48 89 c7             	mov    %rax,%rdi
  800b97:	48 b8 ed 03 80 00 00 	movabs $0x8003ed,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
			break;
  800ba3:	eb 3f                	jmp    800be4 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bad:	48 89 d6             	mov    %rdx,%rsi
  800bb0:	89 df                	mov    %ebx,%edi
  800bb2:	ff d0                	callq  *%rax
			break;
  800bb4:	eb 2e                	jmp    800be4 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbe:	48 89 d6             	mov    %rdx,%rsi
  800bc1:	bf 25 00 00 00       	mov    $0x25,%edi
  800bc6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bcd:	eb 05                	jmp    800bd4 <vprintfmt+0x50c>
  800bcf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bd4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd8:	48 83 e8 01          	sub    $0x1,%rax
  800bdc:	0f b6 00             	movzbl (%rax),%eax
  800bdf:	3c 25                	cmp    $0x25,%al
  800be1:	75 ec                	jne    800bcf <vprintfmt+0x507>
				/* do nothing */;
			break;
  800be3:	90                   	nop
		}
	}
  800be4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be5:	e9 30 fb ff ff       	jmpq   80071a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bea:	48 83 c4 60          	add    $0x60,%rsp
  800bee:	5b                   	pop    %rbx
  800bef:	41 5c                	pop    %r12
  800bf1:	5d                   	pop    %rbp
  800bf2:	c3                   	retq   

0000000000800bf3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf3:	55                   	push   %rbp
  800bf4:	48 89 e5             	mov    %rsp,%rbp
  800bf7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bfe:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c05:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c21:	84 c0                	test   %al,%al
  800c23:	74 20                	je     800c45 <printfmt+0x52>
  800c25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c45:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c4c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c53:	00 00 00 
  800c56:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c5d:	00 00 00 
  800c60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c64:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c6b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c72:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c79:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c80:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c87:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c8e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c95:	48 89 c7             	mov    %rax,%rdi
  800c98:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800c9f:	00 00 00 
  800ca2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ca4:	c9                   	leaveq 
  800ca5:	c3                   	retq   

0000000000800ca6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ca6:	55                   	push   %rbp
  800ca7:	48 89 e5             	mov    %rsp,%rbp
  800caa:	48 83 ec 10          	sub    $0x10,%rsp
  800cae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb9:	8b 40 10             	mov    0x10(%rax),%eax
  800cbc:	8d 50 01             	lea    0x1(%rax),%edx
  800cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cca:	48 8b 10             	mov    (%rax),%rdx
  800ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cd5:	48 39 c2             	cmp    %rax,%rdx
  800cd8:	73 17                	jae    800cf1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cde:	48 8b 00             	mov    (%rax),%rax
  800ce1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ce5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce9:	48 89 0a             	mov    %rcx,(%rdx)
  800cec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cef:	88 10                	mov    %dl,(%rax)
}
  800cf1:	c9                   	leaveq 
  800cf2:	c3                   	retq   

0000000000800cf3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf3:	55                   	push   %rbp
  800cf4:	48 89 e5             	mov    %rsp,%rbp
  800cf7:	48 83 ec 50          	sub    $0x50,%rsp
  800cfb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cff:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d02:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d06:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d0a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d0e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d12:	48 8b 0a             	mov    (%rdx),%rcx
  800d15:	48 89 08             	mov    %rcx,(%rax)
  800d18:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d1c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d20:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d24:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d2c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d30:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d33:	48 98                	cltq   
  800d35:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d3d:	48 01 d0             	add    %rdx,%rax
  800d40:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d4b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d50:	74 06                	je     800d58 <vsnprintf+0x65>
  800d52:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d56:	7f 07                	jg     800d5f <vsnprintf+0x6c>
		return -E_INVAL;
  800d58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d5d:	eb 2f                	jmp    800d8e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d5f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d63:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d67:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d6b:	48 89 c6             	mov    %rax,%rsi
  800d6e:	48 bf a6 0c 80 00 00 	movabs $0x800ca6,%rdi
  800d75:	00 00 00 
  800d78:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800d7f:	00 00 00 
  800d82:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d88:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d8b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d8e:	c9                   	leaveq 
  800d8f:	c3                   	retq   

0000000000800d90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d90:	55                   	push   %rbp
  800d91:	48 89 e5             	mov    %rsp,%rbp
  800d94:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d9b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800da2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800da8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800daf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbd:	84 c0                	test   %al,%al
  800dbf:	74 20                	je     800de1 <snprintf+0x51>
  800dc1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dcd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ddd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800de8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800def:	00 00 00 
  800df2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800df9:	00 00 00 
  800dfc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e00:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e07:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e15:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e1c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e23:	48 8b 0a             	mov    (%rdx),%rcx
  800e26:	48 89 08             	mov    %rcx,(%rax)
  800e29:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e2d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e31:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e35:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e39:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e40:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e47:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e4d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e54:	48 89 c7             	mov    %rax,%rdi
  800e57:	48 b8 f3 0c 80 00 00 	movabs $0x800cf3,%rax
  800e5e:	00 00 00 
  800e61:	ff d0                	callq  *%rax
  800e63:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e69:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e6f:	c9                   	leaveq 
  800e70:	c3                   	retq   

0000000000800e71 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e71:	55                   	push   %rbp
  800e72:	48 89 e5             	mov    %rsp,%rbp
  800e75:	48 83 ec 18          	sub    $0x18,%rsp
  800e79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e84:	eb 09                	jmp    800e8f <strlen+0x1e>
		n++;
  800e86:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	0f b6 00             	movzbl (%rax),%eax
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ec                	jne    800e86 <strlen+0x15>
		n++;
	return n;
  800e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e9d:	c9                   	leaveq 
  800e9e:	c3                   	retq   

0000000000800e9f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e9f:	55                   	push   %rbp
  800ea0:	48 89 e5             	mov    %rsp,%rbp
  800ea3:	48 83 ec 20          	sub    $0x20,%rsp
  800ea7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eb6:	eb 0e                	jmp    800ec6 <strnlen+0x27>
		n++;
  800eb8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ec1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ec6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ecb:	74 0b                	je     800ed8 <strnlen+0x39>
  800ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed1:	0f b6 00             	movzbl (%rax),%eax
  800ed4:	84 c0                	test   %al,%al
  800ed6:	75 e0                	jne    800eb8 <strnlen+0x19>
		n++;
	return n;
  800ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800edb:	c9                   	leaveq 
  800edc:	c3                   	retq   

0000000000800edd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800edd:	55                   	push   %rbp
  800ede:	48 89 e5             	mov    %rsp,%rbp
  800ee1:	48 83 ec 20          	sub    $0x20,%rsp
  800ee5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ef5:	90                   	nop
  800ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800efe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f02:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f06:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f0a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f0e:	0f b6 12             	movzbl (%rdx),%edx
  800f11:	88 10                	mov    %dl,(%rax)
  800f13:	0f b6 00             	movzbl (%rax),%eax
  800f16:	84 c0                	test   %al,%al
  800f18:	75 dc                	jne    800ef6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 20          	sub    $0x20,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	48 89 c7             	mov    %rax,%rdi
  800f37:	48 b8 71 0e 80 00 00 	movabs $0x800e71,%rax
  800f3e:	00 00 00 
  800f41:	ff d0                	callq  *%rax
  800f43:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f49:	48 63 d0             	movslq %eax,%rdx
  800f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f50:	48 01 c2             	add    %rax,%rdx
  800f53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f57:	48 89 c6             	mov    %rax,%rsi
  800f5a:	48 89 d7             	mov    %rdx,%rdi
  800f5d:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  800f64:	00 00 00 
  800f67:	ff d0                	callq  *%rax
	return dst;
  800f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f6d:	c9                   	leaveq 
  800f6e:	c3                   	retq   

0000000000800f6f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f6f:	55                   	push   %rbp
  800f70:	48 89 e5             	mov    %rsp,%rbp
  800f73:	48 83 ec 28          	sub    $0x28,%rsp
  800f77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f7f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f8b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f92:	00 
  800f93:	eb 2a                	jmp    800fbf <strncpy+0x50>
		*dst++ = *src;
  800f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa5:	0f b6 12             	movzbl (%rdx),%edx
  800fa8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800faa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fae:	0f b6 00             	movzbl (%rax),%eax
  800fb1:	84 c0                	test   %al,%al
  800fb3:	74 05                	je     800fba <strncpy+0x4b>
			src++;
  800fb5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fc7:	72 cc                	jb     800f95 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 83 ec 28          	sub    $0x28,%rsp
  800fd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800feb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ff0:	74 3d                	je     80102f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ff2:	eb 1d                	jmp    801011 <strlcpy+0x42>
			*dst++ = *src++;
  800ff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ffc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801000:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801004:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801008:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80100c:	0f b6 12             	movzbl (%rdx),%edx
  80100f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801011:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801016:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80101b:	74 0b                	je     801028 <strlcpy+0x59>
  80101d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801021:	0f b6 00             	movzbl (%rax),%eax
  801024:	84 c0                	test   %al,%al
  801026:	75 cc                	jne    800ff4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80102f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801037:	48 29 c2             	sub    %rax,%rdx
  80103a:	48 89 d0             	mov    %rdx,%rax
}
  80103d:	c9                   	leaveq 
  80103e:	c3                   	retq   

000000000080103f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	48 83 ec 10          	sub    $0x10,%rsp
  801047:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80104f:	eb 0a                	jmp    80105b <strcmp+0x1c>
		p++, q++;
  801051:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801056:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80105b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105f:	0f b6 00             	movzbl (%rax),%eax
  801062:	84 c0                	test   %al,%al
  801064:	74 12                	je     801078 <strcmp+0x39>
  801066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106a:	0f b6 10             	movzbl (%rax),%edx
  80106d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801071:	0f b6 00             	movzbl (%rax),%eax
  801074:	38 c2                	cmp    %al,%dl
  801076:	74 d9                	je     801051 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107c:	0f b6 00             	movzbl (%rax),%eax
  80107f:	0f b6 d0             	movzbl %al,%edx
  801082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801086:	0f b6 00             	movzbl (%rax),%eax
  801089:	0f b6 c0             	movzbl %al,%eax
  80108c:	29 c2                	sub    %eax,%edx
  80108e:	89 d0                	mov    %edx,%eax
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   

0000000000801092 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801092:	55                   	push   %rbp
  801093:	48 89 e5             	mov    %rsp,%rbp
  801096:	48 83 ec 18          	sub    $0x18,%rsp
  80109a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80109e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010a6:	eb 0f                	jmp    8010b7 <strncmp+0x25>
		n--, p++, q++;
  8010a8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010bc:	74 1d                	je     8010db <strncmp+0x49>
  8010be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c2:	0f b6 00             	movzbl (%rax),%eax
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 12                	je     8010db <strncmp+0x49>
  8010c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cd:	0f b6 10             	movzbl (%rax),%edx
  8010d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d4:	0f b6 00             	movzbl (%rax),%eax
  8010d7:	38 c2                	cmp    %al,%dl
  8010d9:	74 cd                	je     8010a8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e0:	75 07                	jne    8010e9 <strncmp+0x57>
		return 0;
  8010e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e7:	eb 18                	jmp    801101 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ed:	0f b6 00             	movzbl (%rax),%eax
  8010f0:	0f b6 d0             	movzbl %al,%edx
  8010f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f7:	0f b6 00             	movzbl (%rax),%eax
  8010fa:	0f b6 c0             	movzbl %al,%eax
  8010fd:	29 c2                	sub    %eax,%edx
  8010ff:	89 d0                	mov    %edx,%eax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 0c          	sub    $0xc,%rsp
  80110b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110f:	89 f0                	mov    %esi,%eax
  801111:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801114:	eb 17                	jmp    80112d <strchr+0x2a>
		if (*s == c)
  801116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801120:	75 06                	jne    801128 <strchr+0x25>
			return (char *) s;
  801122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801126:	eb 15                	jmp    80113d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801128:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801131:	0f b6 00             	movzbl (%rax),%eax
  801134:	84 c0                	test   %al,%al
  801136:	75 de                	jne    801116 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113d:	c9                   	leaveq 
  80113e:	c3                   	retq   

000000000080113f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80113f:	55                   	push   %rbp
  801140:	48 89 e5             	mov    %rsp,%rbp
  801143:	48 83 ec 0c          	sub    $0xc,%rsp
  801147:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114b:	89 f0                	mov    %esi,%eax
  80114d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801150:	eb 13                	jmp    801165 <strfind+0x26>
		if (*s == c)
  801152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801156:	0f b6 00             	movzbl (%rax),%eax
  801159:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80115c:	75 02                	jne    801160 <strfind+0x21>
			break;
  80115e:	eb 10                	jmp    801170 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801160:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801169:	0f b6 00             	movzbl (%rax),%eax
  80116c:	84 c0                	test   %al,%al
  80116e:	75 e2                	jne    801152 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   

0000000000801176 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801176:	55                   	push   %rbp
  801177:	48 89 e5             	mov    %rsp,%rbp
  80117a:	48 83 ec 18          	sub    $0x18,%rsp
  80117e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801182:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801185:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801189:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80118e:	75 06                	jne    801196 <memset+0x20>
		return v;
  801190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801194:	eb 69                	jmp    8011ff <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119a:	83 e0 03             	and    $0x3,%eax
  80119d:	48 85 c0             	test   %rax,%rax
  8011a0:	75 48                	jne    8011ea <memset+0x74>
  8011a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a6:	83 e0 03             	and    $0x3,%eax
  8011a9:	48 85 c0             	test   %rax,%rax
  8011ac:	75 3c                	jne    8011ea <memset+0x74>
		c &= 0xFF;
  8011ae:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b8:	c1 e0 18             	shl    $0x18,%eax
  8011bb:	89 c2                	mov    %eax,%edx
  8011bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c0:	c1 e0 10             	shl    $0x10,%eax
  8011c3:	09 c2                	or     %eax,%edx
  8011c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c8:	c1 e0 08             	shl    $0x8,%eax
  8011cb:	09 d0                	or     %edx,%eax
  8011cd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d4:	48 c1 e8 02          	shr    $0x2,%rax
  8011d8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e2:	48 89 d7             	mov    %rdx,%rdi
  8011e5:	fc                   	cld    
  8011e6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011e8:	eb 11                	jmp    8011fb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011f5:	48 89 d7             	mov    %rdx,%rdi
  8011f8:	fc                   	cld    
  8011f9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ff:	c9                   	leaveq 
  801200:	c3                   	retq   

0000000000801201 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801201:	55                   	push   %rbp
  801202:	48 89 e5             	mov    %rsp,%rbp
  801205:	48 83 ec 28          	sub    $0x28,%rsp
  801209:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801211:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801215:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801219:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801221:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801229:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80122d:	0f 83 88 00 00 00    	jae    8012bb <memmove+0xba>
  801233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801237:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123b:	48 01 d0             	add    %rdx,%rax
  80123e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801242:	76 77                	jbe    8012bb <memmove+0xba>
		s += n;
  801244:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801248:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80124c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801250:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	83 e0 03             	and    $0x3,%eax
  80125b:	48 85 c0             	test   %rax,%rax
  80125e:	75 3b                	jne    80129b <memmove+0x9a>
  801260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801264:	83 e0 03             	and    $0x3,%eax
  801267:	48 85 c0             	test   %rax,%rax
  80126a:	75 2f                	jne    80129b <memmove+0x9a>
  80126c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801270:	83 e0 03             	and    $0x3,%eax
  801273:	48 85 c0             	test   %rax,%rax
  801276:	75 23                	jne    80129b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	48 83 e8 04          	sub    $0x4,%rax
  801280:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801284:	48 83 ea 04          	sub    $0x4,%rdx
  801288:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80128c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801290:	48 89 c7             	mov    %rax,%rdi
  801293:	48 89 d6             	mov    %rdx,%rsi
  801296:	fd                   	std    
  801297:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801299:	eb 1d                	jmp    8012b8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012af:	48 89 d7             	mov    %rdx,%rdi
  8012b2:	48 89 c1             	mov    %rax,%rcx
  8012b5:	fd                   	std    
  8012b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012b8:	fc                   	cld    
  8012b9:	eb 57                	jmp    801312 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bf:	83 e0 03             	and    $0x3,%eax
  8012c2:	48 85 c0             	test   %rax,%rax
  8012c5:	75 36                	jne    8012fd <memmove+0xfc>
  8012c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cb:	83 e0 03             	and    $0x3,%eax
  8012ce:	48 85 c0             	test   %rax,%rax
  8012d1:	75 2a                	jne    8012fd <memmove+0xfc>
  8012d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d7:	83 e0 03             	and    $0x3,%eax
  8012da:	48 85 c0             	test   %rax,%rax
  8012dd:	75 1e                	jne    8012fd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e3:	48 c1 e8 02          	shr    $0x2,%rax
  8012e7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f2:	48 89 c7             	mov    %rax,%rdi
  8012f5:	48 89 d6             	mov    %rdx,%rsi
  8012f8:	fc                   	cld    
  8012f9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012fb:	eb 15                	jmp    801312 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801301:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801305:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801309:	48 89 c7             	mov    %rax,%rdi
  80130c:	48 89 d6             	mov    %rdx,%rsi
  80130f:	fc                   	cld    
  801310:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801316:	c9                   	leaveq 
  801317:	c3                   	retq   

0000000000801318 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801318:	55                   	push   %rbp
  801319:	48 89 e5             	mov    %rsp,%rbp
  80131c:	48 83 ec 18          	sub    $0x18,%rsp
  801320:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801324:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801328:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80132c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801330:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801338:	48 89 ce             	mov    %rcx,%rsi
  80133b:	48 89 c7             	mov    %rax,%rdi
  80133e:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  801345:	00 00 00 
  801348:	ff d0                	callq  *%rax
}
  80134a:	c9                   	leaveq 
  80134b:	c3                   	retq   

000000000080134c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	48 83 ec 28          	sub    $0x28,%rsp
  801354:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801358:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80135c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801368:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801370:	eb 36                	jmp    8013a8 <memcmp+0x5c>
		if (*s1 != *s2)
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 10             	movzbl (%rax),%edx
  801379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137d:	0f b6 00             	movzbl (%rax),%eax
  801380:	38 c2                	cmp    %al,%dl
  801382:	74 1a                	je     80139e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	0f b6 00             	movzbl (%rax),%eax
  80138b:	0f b6 d0             	movzbl %al,%edx
  80138e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	0f b6 c0             	movzbl %al,%eax
  801398:	29 c2                	sub    %eax,%edx
  80139a:	89 d0                	mov    %edx,%eax
  80139c:	eb 20                	jmp    8013be <memcmp+0x72>
		s1++, s2++;
  80139e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013b4:	48 85 c0             	test   %rax,%rax
  8013b7:	75 b9                	jne    801372 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013be:	c9                   	leaveq 
  8013bf:	c3                   	retq   

00000000008013c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	48 83 ec 28          	sub    $0x28,%rsp
  8013c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013db:	48 01 d0             	add    %rdx,%rax
  8013de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013e2:	eb 15                	jmp    8013f9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e8:	0f b6 10             	movzbl (%rax),%edx
  8013eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013ee:	38 c2                	cmp    %al,%dl
  8013f0:	75 02                	jne    8013f4 <memfind+0x34>
			break;
  8013f2:	eb 0f                	jmp    801403 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013f4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801401:	72 e1                	jb     8013e4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 34          	sub    $0x34,%rsp
  801411:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801415:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801419:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80141c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801423:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80142a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80142b:	eb 05                	jmp    801432 <strtol+0x29>
		s++;
  80142d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	0f b6 00             	movzbl (%rax),%eax
  801439:	3c 20                	cmp    $0x20,%al
  80143b:	74 f0                	je     80142d <strtol+0x24>
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	3c 09                	cmp    $0x9,%al
  801446:	74 e5                	je     80142d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	0f b6 00             	movzbl (%rax),%eax
  80144f:	3c 2b                	cmp    $0x2b,%al
  801451:	75 07                	jne    80145a <strtol+0x51>
		s++;
  801453:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801458:	eb 17                	jmp    801471 <strtol+0x68>
	else if (*s == '-')
  80145a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	3c 2d                	cmp    $0x2d,%al
  801463:	75 0c                	jne    801471 <strtol+0x68>
		s++, neg = 1;
  801465:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80146a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801471:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801475:	74 06                	je     80147d <strtol+0x74>
  801477:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80147b:	75 28                	jne    8014a5 <strtol+0x9c>
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	0f b6 00             	movzbl (%rax),%eax
  801484:	3c 30                	cmp    $0x30,%al
  801486:	75 1d                	jne    8014a5 <strtol+0x9c>
  801488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148c:	48 83 c0 01          	add    $0x1,%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	3c 78                	cmp    $0x78,%al
  801495:	75 0e                	jne    8014a5 <strtol+0x9c>
		s += 2, base = 16;
  801497:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80149c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014a3:	eb 2c                	jmp    8014d1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014a9:	75 19                	jne    8014c4 <strtol+0xbb>
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	0f b6 00             	movzbl (%rax),%eax
  8014b2:	3c 30                	cmp    $0x30,%al
  8014b4:	75 0e                	jne    8014c4 <strtol+0xbb>
		s++, base = 8;
  8014b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014bb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xc8>
	else if (base == 0)
  8014c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xc8>
		base = 10;
  8014ca:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	3c 2f                	cmp    $0x2f,%al
  8014da:	7e 1d                	jle    8014f9 <strtol+0xf0>
  8014dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	3c 39                	cmp    $0x39,%al
  8014e5:	7f 12                	jg     8014f9 <strtol+0xf0>
			dig = *s - '0';
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	0f be c0             	movsbl %al,%eax
  8014f1:	83 e8 30             	sub    $0x30,%eax
  8014f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014f7:	eb 4e                	jmp    801547 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	3c 60                	cmp    $0x60,%al
  801502:	7e 1d                	jle    801521 <strtol+0x118>
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	3c 7a                	cmp    $0x7a,%al
  80150d:	7f 12                	jg     801521 <strtol+0x118>
			dig = *s - 'a' + 10;
  80150f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	0f be c0             	movsbl %al,%eax
  801519:	83 e8 57             	sub    $0x57,%eax
  80151c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80151f:	eb 26                	jmp    801547 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	3c 40                	cmp    $0x40,%al
  80152a:	7e 48                	jle    801574 <strtol+0x16b>
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	3c 5a                	cmp    $0x5a,%al
  801535:	7f 3d                	jg     801574 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	0f be c0             	movsbl %al,%eax
  801541:	83 e8 37             	sub    $0x37,%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801547:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80154a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80154d:	7c 02                	jl     801551 <strtol+0x148>
			break;
  80154f:	eb 23                	jmp    801574 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801551:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801556:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801559:	48 98                	cltq   
  80155b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801560:	48 89 c2             	mov    %rax,%rdx
  801563:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801566:	48 98                	cltq   
  801568:	48 01 d0             	add    %rdx,%rax
  80156b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80156f:	e9 5d ff ff ff       	jmpq   8014d1 <strtol+0xc8>

	if (endptr)
  801574:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801579:	74 0b                	je     801586 <strtol+0x17d>
		*endptr = (char *) s;
  80157b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801583:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80158a:	74 09                	je     801595 <strtol+0x18c>
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801590:	48 f7 d8             	neg    %rax
  801593:	eb 04                	jmp    801599 <strtol+0x190>
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801599:	c9                   	leaveq 
  80159a:	c3                   	retq   

000000000080159b <strstr>:

char * strstr(const char *in, const char *str)
{
  80159b:	55                   	push   %rbp
  80159c:	48 89 e5             	mov    %rsp,%rbp
  80159f:	48 83 ec 30          	sub    $0x30,%rsp
  8015a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015bd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015c1:	75 06                	jne    8015c9 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	eb 6b                	jmp    801634 <strstr+0x99>

	len = strlen(str);
  8015c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015cd:	48 89 c7             	mov    %rax,%rdi
  8015d0:	48 b8 71 0e 80 00 00 	movabs $0x800e71,%rax
  8015d7:	00 00 00 
  8015da:	ff d0                	callq  *%rax
  8015dc:	48 98                	cltq   
  8015de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015f8:	75 07                	jne    801601 <strstr+0x66>
				return (char *) 0;
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ff:	eb 33                	jmp    801634 <strstr+0x99>
		} while (sc != c);
  801601:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801605:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801608:	75 d8                	jne    8015e2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80160a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80160e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801616:	48 89 ce             	mov    %rcx,%rsi
  801619:	48 89 c7             	mov    %rax,%rdi
  80161c:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  801623:	00 00 00 
  801626:	ff d0                	callq  *%rax
  801628:	85 c0                	test   %eax,%eax
  80162a:	75 b6                	jne    8015e2 <strstr+0x47>

	return (char *) (in - 1);
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	48 83 e8 01          	sub    $0x1,%rax
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	53                   	push   %rbx
  80163b:	48 83 ec 48          	sub    $0x48,%rsp
  80163f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801642:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801645:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801649:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80164d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801651:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801655:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801658:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80165c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801660:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801664:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801668:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80166c:	4c 89 c3             	mov    %r8,%rbx
  80166f:	cd 30                	int    $0x30
  801671:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801675:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801679:	74 3e                	je     8016b9 <syscall+0x83>
  80167b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801680:	7e 37                	jle    8016b9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801682:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801686:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801689:	49 89 d0             	mov    %rdx,%r8
  80168c:	89 c1                	mov    %eax,%ecx
  80168e:	48 ba 88 27 80 00 00 	movabs $0x802788,%rdx
  801695:	00 00 00 
  801698:	be 23 00 00 00       	mov    $0x23,%esi
  80169d:	48 bf a5 27 80 00 00 	movabs $0x8027a5,%rdi
  8016a4:	00 00 00 
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	49 b9 39 20 80 00 00 	movabs $0x802039,%r9
  8016b3:	00 00 00 
  8016b6:	41 ff d1             	callq  *%r9

	return ret;
  8016b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016bd:	48 83 c4 48          	add    $0x48,%rsp
  8016c1:	5b                   	pop    %rbx
  8016c2:	5d                   	pop    %rbp
  8016c3:	c3                   	retq   

00000000008016c4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016c4:	55                   	push   %rbp
  8016c5:	48 89 e5             	mov    %rsp,%rbp
  8016c8:	48 83 ec 20          	sub    $0x20,%rsp
  8016cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e3:	00 
  8016e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f0:	48 89 d1             	mov    %rdx,%rcx
  8016f3:	48 89 c2             	mov    %rax,%rdx
  8016f6:	be 00 00 00 00       	mov    $0x0,%esi
  8016fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801700:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801707:	00 00 00 
  80170a:	ff d0                	callq  *%rax
}
  80170c:	c9                   	leaveq 
  80170d:	c3                   	retq   

000000000080170e <sys_cgetc>:

int
sys_cgetc(void)
{
  80170e:	55                   	push   %rbp
  80170f:	48 89 e5             	mov    %rsp,%rbp
  801712:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801716:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80171d:	00 
  80171e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801724:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80172a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	be 00 00 00 00       	mov    $0x0,%esi
  801739:	bf 01 00 00 00       	mov    $0x1,%edi
  80173e:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801745:	00 00 00 
  801748:	ff d0                	callq  *%rax
}
  80174a:	c9                   	leaveq 
  80174b:	c3                   	retq   

000000000080174c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80174c:	55                   	push   %rbp
  80174d:	48 89 e5             	mov    %rsp,%rbp
  801750:	48 83 ec 10          	sub    $0x10,%rsp
  801754:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80175a:	48 98                	cltq   
  80175c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801763:	00 
  801764:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801770:	b9 00 00 00 00       	mov    $0x0,%ecx
  801775:	48 89 c2             	mov    %rax,%rdx
  801778:	be 01 00 00 00       	mov    $0x1,%esi
  80177d:	bf 03 00 00 00       	mov    $0x3,%edi
  801782:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801789:	00 00 00 
  80178c:	ff d0                	callq  *%rax
}
  80178e:	c9                   	leaveq 
  80178f:	c3                   	retq   

0000000000801790 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801790:	55                   	push   %rbp
  801791:	48 89 e5             	mov    %rsp,%rbp
  801794:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801798:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80179f:	00 
  8017a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	be 00 00 00 00       	mov    $0x0,%esi
  8017bb:	bf 02 00 00 00       	mov    $0x2,%edi
  8017c0:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8017c7:	00 00 00 
  8017ca:	ff d0                	callq  *%rax
}
  8017cc:	c9                   	leaveq 
  8017cd:	c3                   	retq   

00000000008017ce <sys_yield>:

void
sys_yield(void)
{
  8017ce:	55                   	push   %rbp
  8017cf:	48 89 e5             	mov    %rsp,%rbp
  8017d2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017dd:	00 
  8017de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f4:	be 00 00 00 00       	mov    $0x0,%esi
  8017f9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8017fe:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801805:	00 00 00 
  801808:	ff d0                	callq  *%rax
}
  80180a:	c9                   	leaveq 
  80180b:	c3                   	retq   

000000000080180c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	48 83 ec 20          	sub    $0x20,%rsp
  801814:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801817:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80181e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801821:	48 63 c8             	movslq %eax,%rcx
  801824:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182b:	48 98                	cltq   
  80182d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801834:	00 
  801835:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183b:	49 89 c8             	mov    %rcx,%r8
  80183e:	48 89 d1             	mov    %rdx,%rcx
  801841:	48 89 c2             	mov    %rax,%rdx
  801844:	be 01 00 00 00       	mov    $0x1,%esi
  801849:	bf 04 00 00 00       	mov    $0x4,%edi
  80184e:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801855:	00 00 00 
  801858:	ff d0                	callq  *%rax
}
  80185a:	c9                   	leaveq 
  80185b:	c3                   	retq   

000000000080185c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80185c:	55                   	push   %rbp
  80185d:	48 89 e5             	mov    %rsp,%rbp
  801860:	48 83 ec 30          	sub    $0x30,%rsp
  801864:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801867:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80186b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80186e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801872:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801876:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801879:	48 63 c8             	movslq %eax,%rcx
  80187c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801880:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801883:	48 63 f0             	movslq %eax,%rsi
  801886:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80188a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80188d:	48 98                	cltq   
  80188f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801893:	49 89 f9             	mov    %rdi,%r9
  801896:	49 89 f0             	mov    %rsi,%r8
  801899:	48 89 d1             	mov    %rdx,%rcx
  80189c:	48 89 c2             	mov    %rax,%rdx
  80189f:	be 01 00 00 00       	mov    $0x1,%esi
  8018a4:	bf 05 00 00 00       	mov    $0x5,%edi
  8018a9:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8018b0:	00 00 00 
  8018b3:	ff d0                	callq  *%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 20          	sub    $0x20,%rsp
  8018bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cd:	48 98                	cltq   
  8018cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d6:	00 
  8018d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e3:	48 89 d1             	mov    %rdx,%rcx
  8018e6:	48 89 c2             	mov    %rax,%rdx
  8018e9:	be 01 00 00 00       	mov    $0x1,%esi
  8018ee:	bf 06 00 00 00       	mov    $0x6,%edi
  8018f3:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8018fa:	00 00 00 
  8018fd:	ff d0                	callq  *%rax
}
  8018ff:	c9                   	leaveq 
  801900:	c3                   	retq   

0000000000801901 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801901:	55                   	push   %rbp
  801902:	48 89 e5             	mov    %rsp,%rbp
  801905:	48 83 ec 10          	sub    $0x10,%rsp
  801909:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80190f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801912:	48 63 d0             	movslq %eax,%rdx
  801915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801918:	48 98                	cltq   
  80191a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801921:	00 
  801922:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801928:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192e:	48 89 d1             	mov    %rdx,%rcx
  801931:	48 89 c2             	mov    %rax,%rdx
  801934:	be 01 00 00 00       	mov    $0x1,%esi
  801939:	bf 08 00 00 00       	mov    $0x8,%edi
  80193e:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801945:	00 00 00 
  801948:	ff d0                	callq  *%rax
}
  80194a:	c9                   	leaveq 
  80194b:	c3                   	retq   

000000000080194c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	48 83 ec 20          	sub    $0x20,%rsp
  801954:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801957:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80195b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801962:	48 98                	cltq   
  801964:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196b:	00 
  80196c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801972:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801978:	48 89 d1             	mov    %rdx,%rcx
  80197b:	48 89 c2             	mov    %rax,%rdx
  80197e:	be 01 00 00 00       	mov    $0x1,%esi
  801983:	bf 09 00 00 00       	mov    $0x9,%edi
  801988:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  80198f:	00 00 00 
  801992:	ff d0                	callq  *%rax
}
  801994:	c9                   	leaveq 
  801995:	c3                   	retq   

0000000000801996 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801996:	55                   	push   %rbp
  801997:	48 89 e5             	mov    %rsp,%rbp
  80199a:	48 83 ec 20          	sub    $0x20,%rsp
  80199e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019af:	48 63 f0             	movslq %eax,%rsi
  8019b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c6:	00 
  8019c7:	49 89 f1             	mov    %rsi,%r9
  8019ca:	49 89 c8             	mov    %rcx,%r8
  8019cd:	48 89 d1             	mov    %rdx,%rcx
  8019d0:	48 89 c2             	mov    %rax,%rdx
  8019d3:	be 00 00 00 00       	mov    $0x0,%esi
  8019d8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019dd:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
}
  8019e9:	c9                   	leaveq 
  8019ea:	c3                   	retq   

00000000008019eb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019eb:	55                   	push   %rbp
  8019ec:	48 89 e5             	mov    %rsp,%rbp
  8019ef:	48 83 ec 10          	sub    $0x10,%rsp
  8019f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a02:	00 
  801a03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a14:	48 89 c2             	mov    %rax,%rdx
  801a17:	be 01 00 00 00       	mov    $0x1,%esi
  801a1c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a21:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   

0000000000801a2f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	48 83 ec 30          	sub    $0x30,%rsp
  801a37:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3f:	48 8b 00             	mov    (%rax),%rax
  801a42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a4e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801a51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a54:	83 e0 02             	and    $0x2,%eax
  801a57:	85 c0                	test   %eax,%eax
  801a59:	75 4d                	jne    801aa8 <pgfault+0x79>
  801a5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5f:	48 c1 e8 0c          	shr    $0xc,%rax
  801a63:	48 89 c2             	mov    %rax,%rdx
  801a66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a6d:	01 00 00 
  801a70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a74:	25 00 08 00 00       	and    $0x800,%eax
  801a79:	48 85 c0             	test   %rax,%rax
  801a7c:	74 2a                	je     801aa8 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801a7e:	48 ba b8 27 80 00 00 	movabs $0x8027b8,%rdx
  801a85:	00 00 00 
  801a88:	be 1e 00 00 00       	mov    $0x1e,%esi
  801a8d:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801a94:	00 00 00 
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9c:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801aa3:	00 00 00 
  801aa6:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801aa8:	ba 07 00 00 00       	mov    $0x7,%edx
  801aad:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ab2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab7:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  801abe:	00 00 00 
  801ac1:	ff d0                	callq  *%rax
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	0f 85 cd 00 00 00    	jne    801b98 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801acb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801add:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801ae1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ae5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aea:	48 89 c6             	mov    %rax,%rsi
  801aed:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801af2:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  801af9:	00 00 00 
  801afc:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801afe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b02:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b08:	48 89 c1             	mov    %rax,%rcx
  801b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b10:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b15:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1a:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801b21:	00 00 00 
  801b24:	ff d0                	callq  *%rax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	79 2a                	jns    801b54 <pgfault+0x125>
				panic("Page map at temp address failed");
  801b2a:	48 ba e8 27 80 00 00 	movabs $0x8027e8,%rdx
  801b31:	00 00 00 
  801b34:	be 2f 00 00 00       	mov    $0x2f,%esi
  801b39:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801b40:	00 00 00 
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801b4f:	00 00 00 
  801b52:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801b54:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b59:	bf 00 00 00 00       	mov    $0x0,%edi
  801b5e:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	callq  *%rax
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	79 54                	jns    801bc2 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801b6e:	48 ba 08 28 80 00 00 	movabs $0x802808,%rdx
  801b75:	00 00 00 
  801b78:	be 31 00 00 00       	mov    $0x31,%esi
  801b7d:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801b84:	00 00 00 
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8c:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801b93:	00 00 00 
  801b96:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801b98:	48 ba 30 28 80 00 00 	movabs $0x802830,%rdx
  801b9f:	00 00 00 
  801ba2:	be 35 00 00 00       	mov    $0x35,%esi
  801ba7:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801bae:	00 00 00 
  801bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb6:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801bbd:	00 00 00 
  801bc0:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801bc2:	c9                   	leaveq 
  801bc3:	c3                   	retq   

0000000000801bc4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801bc4:	55                   	push   %rbp
  801bc5:	48 89 e5             	mov    %rsp,%rbp
  801bc8:	48 83 ec 20          	sub    $0x20,%rsp
  801bcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801bcf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801bd2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bd9:	01 00 00 
  801bdc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801bdf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801be3:	25 07 0e 00 00       	and    $0xe07,%eax
  801be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801beb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801bee:	48 c1 e0 0c          	shl    $0xc,%rax
  801bf2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf9:	25 00 04 00 00       	and    $0x400,%eax
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	74 57                	je     801c59 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c02:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c05:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c09:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c10:	41 89 f0             	mov    %esi,%r8d
  801c13:	48 89 c6             	mov    %rax,%rsi
  801c16:	bf 00 00 00 00       	mov    $0x0,%edi
  801c1b:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	callq  *%rax
  801c27:	85 c0                	test   %eax,%eax
  801c29:	0f 8e 52 01 00 00    	jle    801d81 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801c2f:	48 ba 5d 28 80 00 00 	movabs $0x80285d,%rdx
  801c36:	00 00 00 
  801c39:	be 52 00 00 00       	mov    $0x52,%esi
  801c3e:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801c45:	00 00 00 
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4d:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801c54:	00 00 00 
  801c57:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5c:	83 e0 02             	and    $0x2,%eax
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	75 10                	jne    801c73 <duppage+0xaf>
  801c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c66:	25 00 08 00 00       	and    $0x800,%eax
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	0f 84 bb 00 00 00    	je     801d2e <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c76:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801c7b:	80 cc 08             	or     $0x8,%ah
  801c7e:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c81:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c84:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c88:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8f:	41 89 f0             	mov    %esi,%r8d
  801c92:	48 89 c6             	mov    %rax,%rsi
  801c95:	bf 00 00 00 00       	mov    $0x0,%edi
  801c9a:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801ca1:	00 00 00 
  801ca4:	ff d0                	callq  *%rax
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	7e 2a                	jle    801cd4 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801caa:	48 ba 5d 28 80 00 00 	movabs $0x80285d,%rdx
  801cb1:	00 00 00 
  801cb4:	be 5a 00 00 00       	mov    $0x5a,%esi
  801cb9:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801cc0:	00 00 00 
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801ccf:	00 00 00 
  801cd2:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801cd4:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801cd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cdf:	41 89 c8             	mov    %ecx,%r8d
  801ce2:	48 89 d1             	mov    %rdx,%rcx
  801ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cea:	48 89 c6             	mov    %rax,%rsi
  801ced:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf2:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	7e 2a                	jle    801d2c <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801d02:	48 ba 5d 28 80 00 00 	movabs $0x80285d,%rdx
  801d09:	00 00 00 
  801d0c:	be 5d 00 00 00       	mov    $0x5d,%esi
  801d11:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801d18:	00 00 00 
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801d27:	00 00 00 
  801d2a:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d2c:	eb 53                	jmp    801d81 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d2e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d31:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d35:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d3c:	41 89 f0             	mov    %esi,%r8d
  801d3f:	48 89 c6             	mov    %rax,%rsi
  801d42:	bf 00 00 00 00       	mov    $0x0,%edi
  801d47:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801d4e:	00 00 00 
  801d51:	ff d0                	callq  *%rax
  801d53:	85 c0                	test   %eax,%eax
  801d55:	7e 2a                	jle    801d81 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801d57:	48 ba 5d 28 80 00 00 	movabs $0x80285d,%rdx
  801d5e:	00 00 00 
  801d61:	be 61 00 00 00       	mov    $0x61,%esi
  801d66:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801d6d:	00 00 00 
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
  801d75:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  801d7c:	00 00 00 
  801d7f:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801d90:	48 bf 2f 1a 80 00 00 	movabs $0x801a2f,%rdi
  801d97:	00 00 00 
  801d9a:	48 b8 4d 21 80 00 00 	movabs $0x80214d,%rax
  801da1:	00 00 00 
  801da4:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801da6:	b8 07 00 00 00       	mov    $0x7,%eax
  801dab:	cd 30                	int    $0x30
  801dad:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801db0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801db3:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801dba:	79 30                	jns    801dec <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801dbc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dbf:	89 c1                	mov    %eax,%ecx
  801dc1:	48 ba 7b 28 80 00 00 	movabs $0x80287b,%rdx
  801dc8:	00 00 00 
  801dcb:	be 89 00 00 00       	mov    $0x89,%esi
  801dd0:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  801dd7:	00 00 00 
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddf:	49 b8 39 20 80 00 00 	movabs $0x802039,%r8
  801de6:	00 00 00 
  801de9:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801df0:	75 46                	jne    801e38 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801df2:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	callq  *%rax
  801dfe:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e03:	48 63 d0             	movslq %eax,%rdx
  801e06:	48 89 d0             	mov    %rdx,%rax
  801e09:	48 c1 e0 03          	shl    $0x3,%rax
  801e0d:	48 01 d0             	add    %rdx,%rax
  801e10:	48 c1 e0 05          	shl    $0x5,%rax
  801e14:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e1b:	00 00 00 
  801e1e:	48 01 c2             	add    %rax,%rdx
  801e21:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801e28:	00 00 00 
  801e2b:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e33:	e9 d1 01 00 00       	jmpq   802009 <fork+0x281>
	}

	uint64_t ad = 0;
  801e38:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801e3f:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801e40:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801e45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801e49:	e9 df 00 00 00       	jmpq   801f2d <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e52:	48 c1 e8 27          	shr    $0x27,%rax
  801e56:	48 89 c2             	mov    %rax,%rdx
  801e59:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801e60:	01 00 00 
  801e63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e67:	83 e0 01             	and    $0x1,%eax
  801e6a:	48 85 c0             	test   %rax,%rax
  801e6d:	0f 84 9e 00 00 00    	je     801f11 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e77:	48 c1 e8 1e          	shr    $0x1e,%rax
  801e7b:	48 89 c2             	mov    %rax,%rdx
  801e7e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e85:	01 00 00 
  801e88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8c:	83 e0 01             	and    $0x1,%eax
  801e8f:	48 85 c0             	test   %rax,%rax
  801e92:	74 73                	je     801f07 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801e94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e98:	48 c1 e8 15          	shr    $0x15,%rax
  801e9c:	48 89 c2             	mov    %rax,%rdx
  801e9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ea6:	01 00 00 
  801ea9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ead:	83 e0 01             	and    $0x1,%eax
  801eb0:	48 85 c0             	test   %rax,%rax
  801eb3:	74 48                	je     801efd <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb9:	48 c1 e8 0c          	shr    $0xc,%rax
  801ebd:	48 89 c2             	mov    %rax,%rdx
  801ec0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec7:	01 00 00 
  801eca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ece:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed6:	83 e0 01             	and    $0x1,%eax
  801ed9:	48 85 c0             	test   %rax,%rax
  801edc:	74 47                	je     801f25 <fork+0x19d>
						duppage(envid, VPN(addr));
  801ede:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee2:	48 c1 e8 0c          	shr    $0xc,%rax
  801ee6:	89 c2                	mov    %eax,%edx
  801ee8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801eeb:	89 d6                	mov    %edx,%esi
  801eed:	89 c7                	mov    %eax,%edi
  801eef:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	callq  *%rax
  801efb:	eb 28                	jmp    801f25 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  801efd:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801f04:	00 
  801f05:	eb 1e                	jmp    801f25 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801f07:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801f0e:	40 
  801f0f:	eb 14                	jmp    801f25 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  801f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f15:	48 c1 e8 27          	shr    $0x27,%rax
  801f19:	48 83 c0 01          	add    $0x1,%rax
  801f1d:	48 c1 e0 27          	shl    $0x27,%rax
  801f21:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801f25:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801f2c:	00 
  801f2d:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  801f34:	00 
  801f35:	0f 87 13 ff ff ff    	ja     801e4e <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801f3b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f3e:	ba 07 00 00 00       	mov    $0x7,%edx
  801f43:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f48:	89 c7                	mov    %eax,%edi
  801f4a:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  801f51:	00 00 00 
  801f54:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801f56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f59:	ba 07 00 00 00       	mov    $0x7,%edx
  801f5e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801f63:	89 c7                	mov    %eax,%edi
  801f65:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  801f71:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f74:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f7a:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  801f7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f84:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801f89:	89 c7                	mov    %eax,%edi
  801f8b:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  801f97:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f9c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fa1:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fa6:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  801fb2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbc:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801fc8:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801fcf:	00 00 00 
  801fd2:	48 8b 00             	mov    (%rax),%rax
  801fd5:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  801fdc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fdf:	48 89 d6             	mov    %rdx,%rsi
  801fe2:	89 c7                	mov    %eax,%edi
  801fe4:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  801ff0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ff3:	be 02 00 00 00       	mov    $0x2,%esi
  801ff8:	89 c7                	mov    %eax,%edi
  801ffa:	48 b8 01 19 80 00 00 	movabs $0x801901,%rax
  802001:	00 00 00 
  802004:	ff d0                	callq  *%rax

	return envid;
  802006:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  802009:	c9                   	leaveq 
  80200a:	c3                   	retq   

000000000080200b <sfork>:

// Challenge!
int
sfork(void)
{
  80200b:	55                   	push   %rbp
  80200c:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80200f:	48 ba 93 28 80 00 00 	movabs $0x802893,%rdx
  802016:	00 00 00 
  802019:	be b8 00 00 00       	mov    $0xb8,%esi
  80201e:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  802025:	00 00 00 
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
  80202d:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  802034:	00 00 00 
  802037:	ff d1                	callq  *%rcx

0000000000802039 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	53                   	push   %rbx
  80203e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802045:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80204c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802052:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802059:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802060:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802067:	84 c0                	test   %al,%al
  802069:	74 23                	je     80208e <_panic+0x55>
  80206b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802072:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802076:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80207a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80207e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802082:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802086:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80208a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80208e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802095:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80209c:	00 00 00 
  80209f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8020a6:	00 00 00 
  8020a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020ad:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8020b4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8020bb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020c2:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8020c9:	00 00 00 
  8020cc:	48 8b 18             	mov    (%rax),%rbx
  8020cf:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
  8020db:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8020e1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8020e8:	41 89 c8             	mov    %ecx,%r8d
  8020eb:	48 89 d1             	mov    %rdx,%rcx
  8020ee:	48 89 da             	mov    %rbx,%rdx
  8020f1:	89 c6                	mov    %eax,%esi
  8020f3:	48 bf b0 28 80 00 00 	movabs $0x8028b0,%rdi
  8020fa:	00 00 00 
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	49 b9 15 03 80 00 00 	movabs $0x800315,%r9
  802109:	00 00 00 
  80210c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80210f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802116:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80211d:	48 89 d6             	mov    %rdx,%rsi
  802120:	48 89 c7             	mov    %rax,%rdi
  802123:	48 b8 69 02 80 00 00 	movabs $0x800269,%rax
  80212a:	00 00 00 
  80212d:	ff d0                	callq  *%rax
	cprintf("\n");
  80212f:	48 bf d3 28 80 00 00 	movabs $0x8028d3,%rdi
  802136:	00 00 00 
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	48 ba 15 03 80 00 00 	movabs $0x800315,%rdx
  802145:	00 00 00 
  802148:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80214a:	cc                   	int3   
  80214b:	eb fd                	jmp    80214a <_panic+0x111>

000000000080214d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80214d:	55                   	push   %rbp
  80214e:	48 89 e5             	mov    %rsp,%rbp
  802151:	48 83 ec 10          	sub    $0x10,%rsp
  802155:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  802159:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  802160:	00 00 00 
  802163:	48 8b 00             	mov    (%rax),%rax
  802166:	48 85 c0             	test   %rax,%rax
  802169:	75 49                	jne    8021b4 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  80216b:	ba 07 00 00 00       	mov    $0x7,%edx
  802170:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802175:	bf 00 00 00 00       	mov    $0x0,%edi
  80217a:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax
  802186:	85 c0                	test   %eax,%eax
  802188:	79 2a                	jns    8021b4 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80218a:	48 ba d8 28 80 00 00 	movabs $0x8028d8,%rdx
  802191:	00 00 00 
  802194:	be 21 00 00 00       	mov    $0x21,%esi
  802199:	48 bf 03 29 80 00 00 	movabs $0x802903,%rdi
  8021a0:	00 00 00 
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a8:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  8021af:	00 00 00 
  8021b2:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021b4:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8021bb:	00 00 00 
  8021be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021c2:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8021c5:	48 be 10 22 80 00 00 	movabs $0x802210,%rsi
  8021cc:	00 00 00 
  8021cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d4:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	callq  *%rax
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	79 2a                	jns    80220e <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  8021e4:	48 ba 18 29 80 00 00 	movabs $0x802918,%rdx
  8021eb:	00 00 00 
  8021ee:	be 27 00 00 00       	mov    $0x27,%esi
  8021f3:	48 bf 03 29 80 00 00 	movabs $0x802903,%rdi
  8021fa:	00 00 00 
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802202:	48 b9 39 20 80 00 00 	movabs $0x802039,%rcx
  802209:	00 00 00 
  80220c:	ff d1                	callq  *%rcx
}
  80220e:	c9                   	leaveq 
  80220f:	c3                   	retq   

0000000000802210 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  802210:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  802213:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  80221a:	00 00 00 
call *%rax
  80221d:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  80221f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802226:	00 
    movq 152(%rsp), %rcx
  802227:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80222e:	00 
    subq $8, %rcx
  80222f:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  802233:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  802236:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80223d:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  80223e:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  802242:	4c 8b 3c 24          	mov    (%rsp),%r15
  802246:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80224b:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802250:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802255:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80225a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80225f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802264:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802269:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80226e:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802273:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802278:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80227d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802282:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802287:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80228c:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  802290:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  802294:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  802295:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  802296:	c3                   	retq   
