
obj/user/divzero:     file format elf64-x86-64


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
  80003c:	e8 54 00 00 00       	callq  800095 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	zero = 0;
  800052:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800059:	00 00 00 
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	cprintf("1/0 is %08x!\n", 1/zero);
  800062:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800069:	00 00 00 
  80006c:	8b 08                	mov    (%rax),%ecx
  80006e:	b8 01 00 00 00       	mov    $0x1,%eax
  800073:	99                   	cltd   
  800074:	f7 f9                	idiv   %ecx
  800076:	89 c6                	mov    %eax,%esi
  800078:	48 bf 00 18 80 00 00 	movabs $0x801800,%rdi
  80007f:	00 00 00 
  800082:	b8 00 00 00 00       	mov    $0x0,%eax
  800087:	48 ba 31 02 80 00 00 	movabs $0x800231,%rdx
  80008e:	00 00 00 
  800091:	ff d2                	callq  *%rdx
}
  800093:	c9                   	leaveq 
  800094:	c3                   	retq   

0000000000800095 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800095:	55                   	push   %rbp
  800096:	48 89 e5             	mov    %rsp,%rbp
  800099:	48 83 ec 10          	sub    $0x10,%rsp
  80009d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000a4:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000ab:	00 00 00 
  8000ae:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b9:	7e 14                	jle    8000cf <libmain+0x3a>
		binaryname = argv[0];
  8000bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000bf:	48 8b 10             	mov    (%rax),%rdx
  8000c2:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000c9:	00 00 00 
  8000cc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
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
  8000fe:	48 b8 68 16 80 00 00 	movabs $0x801668,%rax
  800105:	00 00 00 
  800108:	ff d0                	callq  *%rax
}
  80010a:	5d                   	pop    %rbp
  80010b:	c3                   	retq   

000000000080010c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80010c:	55                   	push   %rbp
  80010d:	48 89 e5             	mov    %rsp,%rbp
  800110:	48 83 ec 10          	sub    $0x10,%rsp
  800114:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800117:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80011b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80011f:	8b 00                	mov    (%rax),%eax
  800121:	8d 48 01             	lea    0x1(%rax),%ecx
  800124:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800128:	89 0a                	mov    %ecx,(%rdx)
  80012a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80012d:	89 d1                	mov    %edx,%ecx
  80012f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800133:	48 98                	cltq   
  800135:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013d:	8b 00                	mov    (%rax),%eax
  80013f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800144:	75 2c                	jne    800172 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014a:	8b 00                	mov    (%rax),%eax
  80014c:	48 98                	cltq   
  80014e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800152:	48 83 c2 08          	add    $0x8,%rdx
  800156:	48 89 c6             	mov    %rax,%rsi
  800159:	48 89 d7             	mov    %rdx,%rdi
  80015c:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  800163:	00 00 00 
  800166:	ff d0                	callq  *%rax
        b->idx = 0;
  800168:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80016c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800176:	8b 40 04             	mov    0x4(%rax),%eax
  800179:	8d 50 01             	lea    0x1(%rax),%edx
  80017c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800180:	89 50 04             	mov    %edx,0x4(%rax)
}
  800183:	c9                   	leaveq 
  800184:	c3                   	retq   

0000000000800185 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800185:	55                   	push   %rbp
  800186:	48 89 e5             	mov    %rsp,%rbp
  800189:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800190:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800197:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80019e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001a5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001ac:	48 8b 0a             	mov    (%rdx),%rcx
  8001af:	48 89 08             	mov    %rcx,(%rax)
  8001b2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001b6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001ba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001be:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001c2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001c9:	00 00 00 
    b.cnt = 0;
  8001cc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001d3:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001d6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001dd:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001e4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001eb:	48 89 c6             	mov    %rax,%rsi
  8001ee:	48 bf 0c 01 80 00 00 	movabs $0x80010c,%rdi
  8001f5:	00 00 00 
  8001f8:	48 b8 e4 05 80 00 00 	movabs $0x8005e4,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800204:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80020a:	48 98                	cltq   
  80020c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800213:	48 83 c2 08          	add    $0x8,%rdx
  800217:	48 89 c6             	mov    %rax,%rsi
  80021a:	48 89 d7             	mov    %rdx,%rdi
  80021d:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  800224:	00 00 00 
  800227:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800229:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80022f:	c9                   	leaveq 
  800230:	c3                   	retq   

0000000000800231 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800231:	55                   	push   %rbp
  800232:	48 89 e5             	mov    %rsp,%rbp
  800235:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80023c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800243:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80024a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800251:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800258:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80025f:	84 c0                	test   %al,%al
  800261:	74 20                	je     800283 <cprintf+0x52>
  800263:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800267:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80026b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80026f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800273:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800277:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80027b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80027f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800283:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80028a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800291:	00 00 00 
  800294:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80029b:	00 00 00 
  80029e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002a9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002b0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002b7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002be:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002c5:	48 8b 0a             	mov    (%rdx),%rcx
  8002c8:	48 89 08             	mov    %rcx,(%rax)
  8002cb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002cf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002d3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002d7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002db:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002e2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002e9:	48 89 d6             	mov    %rdx,%rsi
  8002ec:	48 89 c7             	mov    %rax,%rdi
  8002ef:	48 b8 85 01 80 00 00 	movabs $0x800185,%rax
  8002f6:	00 00 00 
  8002f9:	ff d0                	callq  *%rax
  8002fb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800301:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800307:	c9                   	leaveq 
  800308:	c3                   	retq   

0000000000800309 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800309:	55                   	push   %rbp
  80030a:	48 89 e5             	mov    %rsp,%rbp
  80030d:	53                   	push   %rbx
  80030e:	48 83 ec 38          	sub    $0x38,%rsp
  800312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800316:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80031a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80031e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800321:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800325:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800329:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80032c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800330:	77 3b                	ja     80036d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800332:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800335:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800339:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80033c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800340:	ba 00 00 00 00       	mov    $0x0,%edx
  800345:	48 f7 f3             	div    %rbx
  800348:	48 89 c2             	mov    %rax,%rdx
  80034b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80034e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800351:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800359:	41 89 f9             	mov    %edi,%r9d
  80035c:	48 89 c7             	mov    %rax,%rdi
  80035f:	48 b8 09 03 80 00 00 	movabs $0x800309,%rax
  800366:	00 00 00 
  800369:	ff d0                	callq  *%rax
  80036b:	eb 1e                	jmp    80038b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80036d:	eb 12                	jmp    800381 <printnum+0x78>
			putch(padc, putdat);
  80036f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800373:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800376:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037a:	48 89 ce             	mov    %rcx,%rsi
  80037d:	89 d7                	mov    %edx,%edi
  80037f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800381:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800385:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800389:	7f e4                	jg     80036f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80038e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
  800397:	48 f7 f1             	div    %rcx
  80039a:	48 89 d0             	mov    %rdx,%rax
  80039d:	48 ba 50 19 80 00 00 	movabs $0x801950,%rdx
  8003a4:	00 00 00 
  8003a7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003ab:	0f be d0             	movsbl %al,%edx
  8003ae:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b6:	48 89 ce             	mov    %rcx,%rsi
  8003b9:	89 d7                	mov    %edx,%edi
  8003bb:	ff d0                	callq  *%rax
}
  8003bd:	48 83 c4 38          	add    $0x38,%rsp
  8003c1:	5b                   	pop    %rbx
  8003c2:	5d                   	pop    %rbp
  8003c3:	c3                   	retq   

00000000008003c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c4:	55                   	push   %rbp
  8003c5:	48 89 e5             	mov    %rsp,%rbp
  8003c8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003d7:	7e 52                	jle    80042b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003dd:	8b 00                	mov    (%rax),%eax
  8003df:	83 f8 30             	cmp    $0x30,%eax
  8003e2:	73 24                	jae    800408 <getuint+0x44>
  8003e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8003ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f0:	8b 00                	mov    (%rax),%eax
  8003f2:	89 c0                	mov    %eax,%eax
  8003f4:	48 01 d0             	add    %rdx,%rax
  8003f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003fb:	8b 12                	mov    (%rdx),%edx
  8003fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800400:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800404:	89 0a                	mov    %ecx,(%rdx)
  800406:	eb 17                	jmp    80041f <getuint+0x5b>
  800408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80040c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800410:	48 89 d0             	mov    %rdx,%rax
  800413:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800417:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80041b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80041f:	48 8b 00             	mov    (%rax),%rax
  800422:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800426:	e9 a3 00 00 00       	jmpq   8004ce <getuint+0x10a>
	else if (lflag)
  80042b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80042f:	74 4f                	je     800480 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800435:	8b 00                	mov    (%rax),%eax
  800437:	83 f8 30             	cmp    $0x30,%eax
  80043a:	73 24                	jae    800460 <getuint+0x9c>
  80043c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800440:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800448:	8b 00                	mov    (%rax),%eax
  80044a:	89 c0                	mov    %eax,%eax
  80044c:	48 01 d0             	add    %rdx,%rax
  80044f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800453:	8b 12                	mov    (%rdx),%edx
  800455:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800458:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045c:	89 0a                	mov    %ecx,(%rdx)
  80045e:	eb 17                	jmp    800477 <getuint+0xb3>
  800460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800464:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800468:	48 89 d0             	mov    %rdx,%rax
  80046b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80046f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800473:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800477:	48 8b 00             	mov    (%rax),%rax
  80047a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80047e:	eb 4e                	jmp    8004ce <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800484:	8b 00                	mov    (%rax),%eax
  800486:	83 f8 30             	cmp    $0x30,%eax
  800489:	73 24                	jae    8004af <getuint+0xeb>
  80048b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800497:	8b 00                	mov    (%rax),%eax
  800499:	89 c0                	mov    %eax,%eax
  80049b:	48 01 d0             	add    %rdx,%rax
  80049e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a2:	8b 12                	mov    (%rdx),%edx
  8004a4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ab:	89 0a                	mov    %ecx,(%rdx)
  8004ad:	eb 17                	jmp    8004c6 <getuint+0x102>
  8004af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004b7:	48 89 d0             	mov    %rdx,%rax
  8004ba:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004c6:	8b 00                	mov    (%rax),%eax
  8004c8:	89 c0                	mov    %eax,%eax
  8004ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004d2:	c9                   	leaveq 
  8004d3:	c3                   	retq   

00000000008004d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004d4:	55                   	push   %rbp
  8004d5:	48 89 e5             	mov    %rsp,%rbp
  8004d8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004e7:	7e 52                	jle    80053b <getint+0x67>
		x=va_arg(*ap, long long);
  8004e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ed:	8b 00                	mov    (%rax),%eax
  8004ef:	83 f8 30             	cmp    $0x30,%eax
  8004f2:	73 24                	jae    800518 <getint+0x44>
  8004f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800500:	8b 00                	mov    (%rax),%eax
  800502:	89 c0                	mov    %eax,%eax
  800504:	48 01 d0             	add    %rdx,%rax
  800507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050b:	8b 12                	mov    (%rdx),%edx
  80050d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800510:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800514:	89 0a                	mov    %ecx,(%rdx)
  800516:	eb 17                	jmp    80052f <getint+0x5b>
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800520:	48 89 d0             	mov    %rdx,%rax
  800523:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800527:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80052f:	48 8b 00             	mov    (%rax),%rax
  800532:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800536:	e9 a3 00 00 00       	jmpq   8005de <getint+0x10a>
	else if (lflag)
  80053b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80053f:	74 4f                	je     800590 <getint+0xbc>
		x=va_arg(*ap, long);
  800541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800545:	8b 00                	mov    (%rax),%eax
  800547:	83 f8 30             	cmp    $0x30,%eax
  80054a:	73 24                	jae    800570 <getint+0x9c>
  80054c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800550:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800558:	8b 00                	mov    (%rax),%eax
  80055a:	89 c0                	mov    %eax,%eax
  80055c:	48 01 d0             	add    %rdx,%rax
  80055f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800563:	8b 12                	mov    (%rdx),%edx
  800565:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800568:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056c:	89 0a                	mov    %ecx,(%rdx)
  80056e:	eb 17                	jmp    800587 <getint+0xb3>
  800570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800574:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800578:	48 89 d0             	mov    %rdx,%rax
  80057b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800583:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800587:	48 8b 00             	mov    (%rax),%rax
  80058a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058e:	eb 4e                	jmp    8005de <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	8b 00                	mov    (%rax),%eax
  800596:	83 f8 30             	cmp    $0x30,%eax
  800599:	73 24                	jae    8005bf <getint+0xeb>
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a7:	8b 00                	mov    (%rax),%eax
  8005a9:	89 c0                	mov    %eax,%eax
  8005ab:	48 01 d0             	add    %rdx,%rax
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	8b 12                	mov    (%rdx),%edx
  8005b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bb:	89 0a                	mov    %ecx,(%rdx)
  8005bd:	eb 17                	jmp    8005d6 <getint+0x102>
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c7:	48 89 d0             	mov    %rdx,%rax
  8005ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d6:	8b 00                	mov    (%rax),%eax
  8005d8:	48 98                	cltq   
  8005da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005e2:	c9                   	leaveq 
  8005e3:	c3                   	retq   

00000000008005e4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e4:	55                   	push   %rbp
  8005e5:	48 89 e5             	mov    %rsp,%rbp
  8005e8:	41 54                	push   %r12
  8005ea:	53                   	push   %rbx
  8005eb:	48 83 ec 60          	sub    $0x60,%rsp
  8005ef:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8005f3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8005f7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8005fb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8005ff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800603:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800607:	48 8b 0a             	mov    (%rdx),%rcx
  80060a:	48 89 08             	mov    %rcx,(%rax)
  80060d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800611:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800615:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800619:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061d:	eb 17                	jmp    800636 <vprintfmt+0x52>
			if (ch == '\0')
  80061f:	85 db                	test   %ebx,%ebx
  800621:	0f 84 df 04 00 00    	je     800b06 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800627:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80062b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80062f:	48 89 d6             	mov    %rdx,%rsi
  800632:	89 df                	mov    %ebx,%edi
  800634:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800636:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80063a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80063e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800642:	0f b6 00             	movzbl (%rax),%eax
  800645:	0f b6 d8             	movzbl %al,%ebx
  800648:	83 fb 25             	cmp    $0x25,%ebx
  80064b:	75 d2                	jne    80061f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80064d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800651:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800658:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80065f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800666:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800671:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800675:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800679:	0f b6 00             	movzbl (%rax),%eax
  80067c:	0f b6 d8             	movzbl %al,%ebx
  80067f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800682:	83 f8 55             	cmp    $0x55,%eax
  800685:	0f 87 47 04 00 00    	ja     800ad2 <vprintfmt+0x4ee>
  80068b:	89 c0                	mov    %eax,%eax
  80068d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800694:	00 
  800695:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  80069c:	00 00 00 
  80069f:	48 01 d0             	add    %rdx,%rax
  8006a2:	48 8b 00             	mov    (%rax),%rax
  8006a5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006a7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006ab:	eb c0                	jmp    80066d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ad:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006b1:	eb ba                	jmp    80066d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006ba:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006bd:	89 d0                	mov    %edx,%eax
  8006bf:	c1 e0 02             	shl    $0x2,%eax
  8006c2:	01 d0                	add    %edx,%eax
  8006c4:	01 c0                	add    %eax,%eax
  8006c6:	01 d8                	add    %ebx,%eax
  8006c8:	83 e8 30             	sub    $0x30,%eax
  8006cb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006ce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d2:	0f b6 00             	movzbl (%rax),%eax
  8006d5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006d8:	83 fb 2f             	cmp    $0x2f,%ebx
  8006db:	7e 0c                	jle    8006e9 <vprintfmt+0x105>
  8006dd:	83 fb 39             	cmp    $0x39,%ebx
  8006e0:	7f 07                	jg     8006e9 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d1                	jmp    8006ba <vprintfmt+0xd6>
			goto process_precision;
  8006e9:	eb 58                	jmp    800743 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8006eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ee:	83 f8 30             	cmp    $0x30,%eax
  8006f1:	73 17                	jae    80070a <vprintfmt+0x126>
  8006f3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8006f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006fa:	89 c0                	mov    %eax,%eax
  8006fc:	48 01 d0             	add    %rdx,%rax
  8006ff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800702:	83 c2 08             	add    $0x8,%edx
  800705:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800708:	eb 0f                	jmp    800719 <vprintfmt+0x135>
  80070a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80070e:	48 89 d0             	mov    %rdx,%rax
  800711:	48 83 c2 08          	add    $0x8,%rdx
  800715:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800719:	8b 00                	mov    (%rax),%eax
  80071b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80071e:	eb 23                	jmp    800743 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800720:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800724:	79 0c                	jns    800732 <vprintfmt+0x14e>
				width = 0;
  800726:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80072d:	e9 3b ff ff ff       	jmpq   80066d <vprintfmt+0x89>
  800732:	e9 36 ff ff ff       	jmpq   80066d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800737:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80073e:	e9 2a ff ff ff       	jmpq   80066d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800743:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800747:	79 12                	jns    80075b <vprintfmt+0x177>
				width = precision, precision = -1;
  800749:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80074c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80074f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800756:	e9 12 ff ff ff       	jmpq   80066d <vprintfmt+0x89>
  80075b:	e9 0d ff ff ff       	jmpq   80066d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800760:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800764:	e9 04 ff ff ff       	jmpq   80066d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800769:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076c:	83 f8 30             	cmp    $0x30,%eax
  80076f:	73 17                	jae    800788 <vprintfmt+0x1a4>
  800771:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800775:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800778:	89 c0                	mov    %eax,%eax
  80077a:	48 01 d0             	add    %rdx,%rax
  80077d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800780:	83 c2 08             	add    $0x8,%edx
  800783:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800786:	eb 0f                	jmp    800797 <vprintfmt+0x1b3>
  800788:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80078c:	48 89 d0             	mov    %rdx,%rax
  80078f:	48 83 c2 08          	add    $0x8,%rdx
  800793:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800797:	8b 10                	mov    (%rax),%edx
  800799:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80079d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	89 d7                	mov    %edx,%edi
  8007a6:	ff d0                	callq  *%rax
			break;
  8007a8:	e9 53 03 00 00       	jmpq   800b00 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b0:	83 f8 30             	cmp    $0x30,%eax
  8007b3:	73 17                	jae    8007cc <vprintfmt+0x1e8>
  8007b5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007bc:	89 c0                	mov    %eax,%eax
  8007be:	48 01 d0             	add    %rdx,%rax
  8007c1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c4:	83 c2 08             	add    $0x8,%edx
  8007c7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ca:	eb 0f                	jmp    8007db <vprintfmt+0x1f7>
  8007cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d0:	48 89 d0             	mov    %rdx,%rax
  8007d3:	48 83 c2 08          	add    $0x8,%rdx
  8007d7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007db:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007dd:	85 db                	test   %ebx,%ebx
  8007df:	79 02                	jns    8007e3 <vprintfmt+0x1ff>
				err = -err;
  8007e1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007e3:	83 fb 15             	cmp    $0x15,%ebx
  8007e6:	7f 16                	jg     8007fe <vprintfmt+0x21a>
  8007e8:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  8007ef:	00 00 00 
  8007f2:	48 63 d3             	movslq %ebx,%rdx
  8007f5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8007f9:	4d 85 e4             	test   %r12,%r12
  8007fc:	75 2e                	jne    80082c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8007fe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800802:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800806:	89 d9                	mov    %ebx,%ecx
  800808:	48 ba 61 19 80 00 00 	movabs $0x801961,%rdx
  80080f:	00 00 00 
  800812:	48 89 c7             	mov    %rax,%rdi
  800815:	b8 00 00 00 00       	mov    $0x0,%eax
  80081a:	49 b8 0f 0b 80 00 00 	movabs $0x800b0f,%r8
  800821:	00 00 00 
  800824:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800827:	e9 d4 02 00 00       	jmpq   800b00 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80082c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800830:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800834:	4c 89 e1             	mov    %r12,%rcx
  800837:	48 ba 6a 19 80 00 00 	movabs $0x80196a,%rdx
  80083e:	00 00 00 
  800841:	48 89 c7             	mov    %rax,%rdi
  800844:	b8 00 00 00 00       	mov    $0x0,%eax
  800849:	49 b8 0f 0b 80 00 00 	movabs $0x800b0f,%r8
  800850:	00 00 00 
  800853:	41 ff d0             	callq  *%r8
			break;
  800856:	e9 a5 02 00 00       	jmpq   800b00 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80085b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085e:	83 f8 30             	cmp    $0x30,%eax
  800861:	73 17                	jae    80087a <vprintfmt+0x296>
  800863:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800867:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086a:	89 c0                	mov    %eax,%eax
  80086c:	48 01 d0             	add    %rdx,%rax
  80086f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800872:	83 c2 08             	add    $0x8,%edx
  800875:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800878:	eb 0f                	jmp    800889 <vprintfmt+0x2a5>
  80087a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087e:	48 89 d0             	mov    %rdx,%rax
  800881:	48 83 c2 08          	add    $0x8,%rdx
  800885:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800889:	4c 8b 20             	mov    (%rax),%r12
  80088c:	4d 85 e4             	test   %r12,%r12
  80088f:	75 0a                	jne    80089b <vprintfmt+0x2b7>
				p = "(null)";
  800891:	49 bc 6d 19 80 00 00 	movabs $0x80196d,%r12
  800898:	00 00 00 
			if (width > 0 && padc != '-')
  80089b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80089f:	7e 3f                	jle    8008e0 <vprintfmt+0x2fc>
  8008a1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008a5:	74 39                	je     8008e0 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008aa:	48 98                	cltq   
  8008ac:	48 89 c6             	mov    %rax,%rsi
  8008af:	4c 89 e7             	mov    %r12,%rdi
  8008b2:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  8008b9:	00 00 00 
  8008bc:	ff d0                	callq  *%rax
  8008be:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008c1:	eb 17                	jmp    8008da <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008c3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008c7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008cf:	48 89 ce             	mov    %rcx,%rsi
  8008d2:	89 d7                	mov    %edx,%edi
  8008d4:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008da:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008de:	7f e3                	jg     8008c3 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e0:	eb 37                	jmp    800919 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008e6:	74 1e                	je     800906 <vprintfmt+0x322>
  8008e8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008eb:	7e 05                	jle    8008f2 <vprintfmt+0x30e>
  8008ed:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f0:	7e 14                	jle    800906 <vprintfmt+0x322>
					putch('?', putdat);
  8008f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fa:	48 89 d6             	mov    %rdx,%rsi
  8008fd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800902:	ff d0                	callq  *%rax
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800906:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80090a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090e:	48 89 d6             	mov    %rdx,%rsi
  800911:	89 df                	mov    %ebx,%edi
  800913:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800919:	4c 89 e0             	mov    %r12,%rax
  80091c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800920:	0f b6 00             	movzbl (%rax),%eax
  800923:	0f be d8             	movsbl %al,%ebx
  800926:	85 db                	test   %ebx,%ebx
  800928:	74 10                	je     80093a <vprintfmt+0x356>
  80092a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80092e:	78 b2                	js     8008e2 <vprintfmt+0x2fe>
  800930:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800934:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800938:	79 a8                	jns    8008e2 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093a:	eb 16                	jmp    800952 <vprintfmt+0x36e>
				putch(' ', putdat);
  80093c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800940:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800944:	48 89 d6             	mov    %rdx,%rsi
  800947:	bf 20 00 00 00       	mov    $0x20,%edi
  80094c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800952:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800956:	7f e4                	jg     80093c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800958:	e9 a3 01 00 00       	jmpq   800b00 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80095d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800961:	be 03 00 00 00       	mov    $0x3,%esi
  800966:	48 89 c7             	mov    %rax,%rdi
  800969:	48 b8 d4 04 80 00 00 	movabs $0x8004d4,%rax
  800970:	00 00 00 
  800973:	ff d0                	callq  *%rax
  800975:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 85 c0             	test   %rax,%rax
  800980:	79 1d                	jns    80099f <vprintfmt+0x3bb>
				putch('-', putdat);
  800982:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800986:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098a:	48 89 d6             	mov    %rdx,%rsi
  80098d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800992:	ff d0                	callq  *%rax
				num = -(long long) num;
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	48 f7 d8             	neg    %rax
  80099b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80099f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009a6:	e9 e8 00 00 00       	jmpq   800a93 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009ab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009af:	be 03 00 00 00       	mov    $0x3,%esi
  8009b4:	48 89 c7             	mov    %rax,%rdi
  8009b7:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8009be:	00 00 00 
  8009c1:	ff d0                	callq  *%rax
  8009c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009c7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009ce:	e9 c0 00 00 00       	jmpq   800a93 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009db:	48 89 d6             	mov    %rdx,%rsi
  8009de:	bf 58 00 00 00       	mov    $0x58,%edi
  8009e3:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ed:	48 89 d6             	mov    %rdx,%rsi
  8009f0:	bf 58 00 00 00       	mov    $0x58,%edi
  8009f5:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ff:	48 89 d6             	mov    %rdx,%rsi
  800a02:	bf 58 00 00 00       	mov    $0x58,%edi
  800a07:	ff d0                	callq  *%rax
			break;
  800a09:	e9 f2 00 00 00       	jmpq   800b00 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a16:	48 89 d6             	mov    %rdx,%rsi
  800a19:	bf 30 00 00 00       	mov    $0x30,%edi
  800a1e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a28:	48 89 d6             	mov    %rdx,%rsi
  800a2b:	bf 78 00 00 00       	mov    $0x78,%edi
  800a30:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a35:	83 f8 30             	cmp    $0x30,%eax
  800a38:	73 17                	jae    800a51 <vprintfmt+0x46d>
  800a3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a41:	89 c0                	mov    %eax,%eax
  800a43:	48 01 d0             	add    %rdx,%rax
  800a46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a49:	83 c2 08             	add    $0x8,%edx
  800a4c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	eb 0f                	jmp    800a60 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a55:	48 89 d0             	mov    %rdx,%rax
  800a58:	48 83 c2 08          	add    $0x8,%rdx
  800a5c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a60:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a67:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a6e:	eb 23                	jmp    800a93 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a74:	be 03 00 00 00       	mov    $0x3,%esi
  800a79:	48 89 c7             	mov    %rax,%rdi
  800a7c:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  800a83:	00 00 00 
  800a86:	ff d0                	callq  *%rax
  800a88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a8c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a93:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a98:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a9b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aaa:	45 89 c1             	mov    %r8d,%r9d
  800aad:	41 89 f8             	mov    %edi,%r8d
  800ab0:	48 89 c7             	mov    %rax,%rdi
  800ab3:	48 b8 09 03 80 00 00 	movabs $0x800309,%rax
  800aba:	00 00 00 
  800abd:	ff d0                	callq  *%rax
			break;
  800abf:	eb 3f                	jmp    800b00 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac9:	48 89 d6             	mov    %rdx,%rsi
  800acc:	89 df                	mov    %ebx,%edi
  800ace:	ff d0                	callq  *%rax
			break;
  800ad0:	eb 2e                	jmp    800b00 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ada:	48 89 d6             	mov    %rdx,%rsi
  800add:	bf 25 00 00 00       	mov    $0x25,%edi
  800ae2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ae9:	eb 05                	jmp    800af0 <vprintfmt+0x50c>
  800aeb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800af0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af4:	48 83 e8 01          	sub    $0x1,%rax
  800af8:	0f b6 00             	movzbl (%rax),%eax
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 ec                	jne    800aeb <vprintfmt+0x507>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b01:	e9 30 fb ff ff       	jmpq   800636 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b06:	48 83 c4 60          	add    $0x60,%rsp
  800b0a:	5b                   	pop    %rbx
  800b0b:	41 5c                	pop    %r12
  800b0d:	5d                   	pop    %rbp
  800b0e:	c3                   	retq   

0000000000800b0f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0f:	55                   	push   %rbp
  800b10:	48 89 e5             	mov    %rsp,%rbp
  800b13:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b1a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b21:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b28:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b2f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b36:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b3d:	84 c0                	test   %al,%al
  800b3f:	74 20                	je     800b61 <printfmt+0x52>
  800b41:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b45:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b49:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b4d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b51:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b55:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b59:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b5d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b61:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b68:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b6f:	00 00 00 
  800b72:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b79:	00 00 00 
  800b7c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b80:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b87:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b8e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b95:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b9c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ba3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800baa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bb1:	48 89 c7             	mov    %rax,%rdi
  800bb4:	48 b8 e4 05 80 00 00 	movabs $0x8005e4,%rax
  800bbb:	00 00 00 
  800bbe:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bc0:	c9                   	leaveq 
  800bc1:	c3                   	retq   

0000000000800bc2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc2:	55                   	push   %rbp
  800bc3:	48 89 e5             	mov    %rsp,%rbp
  800bc6:	48 83 ec 10          	sub    $0x10,%rsp
  800bca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd5:	8b 40 10             	mov    0x10(%rax),%eax
  800bd8:	8d 50 01             	lea    0x1(%rax),%edx
  800bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bdf:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be6:	48 8b 10             	mov    (%rax),%rdx
  800be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bed:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bf1:	48 39 c2             	cmp    %rax,%rdx
  800bf4:	73 17                	jae    800c0d <sprintputch+0x4b>
		*b->buf++ = ch;
  800bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfa:	48 8b 00             	mov    (%rax),%rax
  800bfd:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c05:	48 89 0a             	mov    %rcx,(%rdx)
  800c08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c0b:	88 10                	mov    %dl,(%rax)
}
  800c0d:	c9                   	leaveq 
  800c0e:	c3                   	retq   

0000000000800c0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0f:	55                   	push   %rbp
  800c10:	48 89 e5             	mov    %rsp,%rbp
  800c13:	48 83 ec 50          	sub    $0x50,%rsp
  800c17:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c1b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c1e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c22:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c26:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c2a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c2e:	48 8b 0a             	mov    (%rdx),%rcx
  800c31:	48 89 08             	mov    %rcx,(%rax)
  800c34:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c38:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c3c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c40:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c48:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c4c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c4f:	48 98                	cltq   
  800c51:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c55:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c59:	48 01 d0             	add    %rdx,%rax
  800c5c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c60:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c67:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c6c:	74 06                	je     800c74 <vsnprintf+0x65>
  800c6e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c72:	7f 07                	jg     800c7b <vsnprintf+0x6c>
		return -E_INVAL;
  800c74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c79:	eb 2f                	jmp    800caa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c7b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c7f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c83:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c87:	48 89 c6             	mov    %rax,%rsi
  800c8a:	48 bf c2 0b 80 00 00 	movabs $0x800bc2,%rdi
  800c91:	00 00 00 
  800c94:	48 b8 e4 05 80 00 00 	movabs $0x8005e4,%rax
  800c9b:	00 00 00 
  800c9e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ca0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ca4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ca7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800caa:	c9                   	leaveq 
  800cab:	c3                   	retq   

0000000000800cac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cac:	55                   	push   %rbp
  800cad:	48 89 e5             	mov    %rsp,%rbp
  800cb0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cb7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cbe:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cc4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ccb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cd2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cd9:	84 c0                	test   %al,%al
  800cdb:	74 20                	je     800cfd <snprintf+0x51>
  800cdd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ce1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ce5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ce9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ced:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cf1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cf5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cf9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cfd:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d04:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d0b:	00 00 00 
  800d0e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d15:	00 00 00 
  800d18:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d1c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d23:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d2a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d31:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d38:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d3f:	48 8b 0a             	mov    (%rdx),%rcx
  800d42:	48 89 08             	mov    %rcx,(%rax)
  800d45:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d49:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d4d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d51:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d55:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d5c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d63:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d69:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d70:	48 89 c7             	mov    %rax,%rdi
  800d73:	48 b8 0f 0c 80 00 00 	movabs $0x800c0f,%rax
  800d7a:	00 00 00 
  800d7d:	ff d0                	callq  *%rax
  800d7f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d85:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d8b:	c9                   	leaveq 
  800d8c:	c3                   	retq   

0000000000800d8d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d8d:	55                   	push   %rbp
  800d8e:	48 89 e5             	mov    %rsp,%rbp
  800d91:	48 83 ec 18          	sub    $0x18,%rsp
  800d95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800da0:	eb 09                	jmp    800dab <strlen+0x1e>
		n++;
  800da2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800da6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800daf:	0f b6 00             	movzbl (%rax),%eax
  800db2:	84 c0                	test   %al,%al
  800db4:	75 ec                	jne    800da2 <strlen+0x15>
		n++;
	return n;
  800db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800db9:	c9                   	leaveq 
  800dba:	c3                   	retq   

0000000000800dbb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dbb:	55                   	push   %rbp
  800dbc:	48 89 e5             	mov    %rsp,%rbp
  800dbf:	48 83 ec 20          	sub    $0x20,%rsp
  800dc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dd2:	eb 0e                	jmp    800de2 <strnlen+0x27>
		n++;
  800dd4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ddd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800de2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800de7:	74 0b                	je     800df4 <strnlen+0x39>
  800de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ded:	0f b6 00             	movzbl (%rax),%eax
  800df0:	84 c0                	test   %al,%al
  800df2:	75 e0                	jne    800dd4 <strnlen+0x19>
		n++;
	return n;
  800df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800df7:	c9                   	leaveq 
  800df8:	c3                   	retq   

0000000000800df9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800df9:	55                   	push   %rbp
  800dfa:	48 89 e5             	mov    %rsp,%rbp
  800dfd:	48 83 ec 20          	sub    $0x20,%rsp
  800e01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e11:	90                   	nop
  800e12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e16:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e1e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e22:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e26:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e2a:	0f b6 12             	movzbl (%rdx),%edx
  800e2d:	88 10                	mov    %dl,(%rax)
  800e2f:	0f b6 00             	movzbl (%rax),%eax
  800e32:	84 c0                	test   %al,%al
  800e34:	75 dc                	jne    800e12 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e3a:	c9                   	leaveq 
  800e3b:	c3                   	retq   

0000000000800e3c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e3c:	55                   	push   %rbp
  800e3d:	48 89 e5             	mov    %rsp,%rbp
  800e40:	48 83 ec 20          	sub    $0x20,%rsp
  800e44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e50:	48 89 c7             	mov    %rax,%rdi
  800e53:	48 b8 8d 0d 80 00 00 	movabs $0x800d8d,%rax
  800e5a:	00 00 00 
  800e5d:	ff d0                	callq  *%rax
  800e5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e65:	48 63 d0             	movslq %eax,%rdx
  800e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6c:	48 01 c2             	add    %rax,%rdx
  800e6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e73:	48 89 c6             	mov    %rax,%rsi
  800e76:	48 89 d7             	mov    %rdx,%rdi
  800e79:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  800e80:	00 00 00 
  800e83:	ff d0                	callq  *%rax
	return dst;
  800e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e89:	c9                   	leaveq 
  800e8a:	c3                   	retq   

0000000000800e8b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e8b:	55                   	push   %rbp
  800e8c:	48 89 e5             	mov    %rsp,%rbp
  800e8f:	48 83 ec 28          	sub    $0x28,%rsp
  800e93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e9b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ea7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800eae:	00 
  800eaf:	eb 2a                	jmp    800edb <strncpy+0x50>
		*dst++ = *src;
  800eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eb9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ebd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec1:	0f b6 12             	movzbl (%rdx),%edx
  800ec4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eca:	0f b6 00             	movzbl (%rax),%eax
  800ecd:	84 c0                	test   %al,%al
  800ecf:	74 05                	je     800ed6 <strncpy+0x4b>
			src++;
  800ed1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800edb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800edf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ee3:	72 cc                	jb     800eb1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ee9:	c9                   	leaveq 
  800eea:	c3                   	retq   

0000000000800eeb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800eeb:	55                   	push   %rbp
  800eec:	48 89 e5             	mov    %rsp,%rbp
  800eef:	48 83 ec 28          	sub    $0x28,%rsp
  800ef3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800efb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f0c:	74 3d                	je     800f4b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f0e:	eb 1d                	jmp    800f2d <strlcpy+0x42>
			*dst++ = *src++;
  800f10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f14:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f18:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f1c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f20:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f24:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f28:	0f b6 12             	movzbl (%rdx),%edx
  800f2b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f32:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f37:	74 0b                	je     800f44 <strlcpy+0x59>
  800f39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f3d:	0f b6 00             	movzbl (%rax),%eax
  800f40:	84 c0                	test   %al,%al
  800f42:	75 cc                	jne    800f10 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f48:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f53:	48 29 c2             	sub    %rax,%rdx
  800f56:	48 89 d0             	mov    %rdx,%rax
}
  800f59:	c9                   	leaveq 
  800f5a:	c3                   	retq   

0000000000800f5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f5b:	55                   	push   %rbp
  800f5c:	48 89 e5             	mov    %rsp,%rbp
  800f5f:	48 83 ec 10          	sub    $0x10,%rsp
  800f63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f6b:	eb 0a                	jmp    800f77 <strcmp+0x1c>
		p++, q++;
  800f6d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f72:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f7b:	0f b6 00             	movzbl (%rax),%eax
  800f7e:	84 c0                	test   %al,%al
  800f80:	74 12                	je     800f94 <strcmp+0x39>
  800f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f86:	0f b6 10             	movzbl (%rax),%edx
  800f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f8d:	0f b6 00             	movzbl (%rax),%eax
  800f90:	38 c2                	cmp    %al,%dl
  800f92:	74 d9                	je     800f6d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f98:	0f b6 00             	movzbl (%rax),%eax
  800f9b:	0f b6 d0             	movzbl %al,%edx
  800f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa2:	0f b6 00             	movzbl (%rax),%eax
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
}
  800fac:	c9                   	leaveq 
  800fad:	c3                   	retq   

0000000000800fae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fae:	55                   	push   %rbp
  800faf:	48 89 e5             	mov    %rsp,%rbp
  800fb2:	48 83 ec 18          	sub    $0x18,%rsp
  800fb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fbe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fc2:	eb 0f                	jmp    800fd3 <strncmp+0x25>
		n--, p++, q++;
  800fc4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fc9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fd3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fd8:	74 1d                	je     800ff7 <strncmp+0x49>
  800fda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fde:	0f b6 00             	movzbl (%rax),%eax
  800fe1:	84 c0                	test   %al,%al
  800fe3:	74 12                	je     800ff7 <strncmp+0x49>
  800fe5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe9:	0f b6 10             	movzbl (%rax),%edx
  800fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff0:	0f b6 00             	movzbl (%rax),%eax
  800ff3:	38 c2                	cmp    %al,%dl
  800ff5:	74 cd                	je     800fc4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800ff7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ffc:	75 07                	jne    801005 <strncmp+0x57>
		return 0;
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  801003:	eb 18                	jmp    80101d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801009:	0f b6 00             	movzbl (%rax),%eax
  80100c:	0f b6 d0             	movzbl %al,%edx
  80100f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	0f b6 c0             	movzbl %al,%eax
  801019:	29 c2                	sub    %eax,%edx
  80101b:	89 d0                	mov    %edx,%eax
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 83 ec 0c          	sub    $0xc,%rsp
  801027:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80102b:	89 f0                	mov    %esi,%eax
  80102d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801030:	eb 17                	jmp    801049 <strchr+0x2a>
		if (*s == c)
  801032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801036:	0f b6 00             	movzbl (%rax),%eax
  801039:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80103c:	75 06                	jne    801044 <strchr+0x25>
			return (char *) s;
  80103e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801042:	eb 15                	jmp    801059 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801044:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801049:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104d:	0f b6 00             	movzbl (%rax),%eax
  801050:	84 c0                	test   %al,%al
  801052:	75 de                	jne    801032 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   

000000000080105b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	48 83 ec 0c          	sub    $0xc,%rsp
  801063:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801067:	89 f0                	mov    %esi,%eax
  801069:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80106c:	eb 13                	jmp    801081 <strfind+0x26>
		if (*s == c)
  80106e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801072:	0f b6 00             	movzbl (%rax),%eax
  801075:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801078:	75 02                	jne    80107c <strfind+0x21>
			break;
  80107a:	eb 10                	jmp    80108c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80107c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801081:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801085:	0f b6 00             	movzbl (%rax),%eax
  801088:	84 c0                	test   %al,%al
  80108a:	75 e2                	jne    80106e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80108c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   

0000000000801092 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801092:	55                   	push   %rbp
  801093:	48 89 e5             	mov    %rsp,%rbp
  801096:	48 83 ec 18          	sub    $0x18,%rsp
  80109a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80109e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010aa:	75 06                	jne    8010b2 <memset+0x20>
		return v;
  8010ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b0:	eb 69                	jmp    80111b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b6:	83 e0 03             	and    $0x3,%eax
  8010b9:	48 85 c0             	test   %rax,%rax
  8010bc:	75 48                	jne    801106 <memset+0x74>
  8010be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c2:	83 e0 03             	and    $0x3,%eax
  8010c5:	48 85 c0             	test   %rax,%rax
  8010c8:	75 3c                	jne    801106 <memset+0x74>
		c &= 0xFF;
  8010ca:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010d4:	c1 e0 18             	shl    $0x18,%eax
  8010d7:	89 c2                	mov    %eax,%edx
  8010d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010dc:	c1 e0 10             	shl    $0x10,%eax
  8010df:	09 c2                	or     %eax,%edx
  8010e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e4:	c1 e0 08             	shl    $0x8,%eax
  8010e7:	09 d0                	or     %edx,%eax
  8010e9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	48 c1 e8 02          	shr    $0x2,%rax
  8010f4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010fe:	48 89 d7             	mov    %rdx,%rdi
  801101:	fc                   	cld    
  801102:	f3 ab                	rep stos %eax,%es:(%rdi)
  801104:	eb 11                	jmp    801117 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801106:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80110a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801111:	48 89 d7             	mov    %rdx,%rdi
  801114:	fc                   	cld    
  801115:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801117:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80111b:	c9                   	leaveq 
  80111c:	c3                   	retq   

000000000080111d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80111d:	55                   	push   %rbp
  80111e:	48 89 e5             	mov    %rsp,%rbp
  801121:	48 83 ec 28          	sub    $0x28,%rsp
  801125:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801129:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80112d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801131:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801135:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801145:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801149:	0f 83 88 00 00 00    	jae    8011d7 <memmove+0xba>
  80114f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801153:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801157:	48 01 d0             	add    %rdx,%rax
  80115a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80115e:	76 77                	jbe    8011d7 <memmove+0xba>
		s += n;
  801160:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801164:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801174:	83 e0 03             	and    $0x3,%eax
  801177:	48 85 c0             	test   %rax,%rax
  80117a:	75 3b                	jne    8011b7 <memmove+0x9a>
  80117c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801180:	83 e0 03             	and    $0x3,%eax
  801183:	48 85 c0             	test   %rax,%rax
  801186:	75 2f                	jne    8011b7 <memmove+0x9a>
  801188:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80118c:	83 e0 03             	and    $0x3,%eax
  80118f:	48 85 c0             	test   %rax,%rax
  801192:	75 23                	jne    8011b7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801198:	48 83 e8 04          	sub    $0x4,%rax
  80119c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a0:	48 83 ea 04          	sub    $0x4,%rdx
  8011a4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011a8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011ac:	48 89 c7             	mov    %rax,%rdi
  8011af:	48 89 d6             	mov    %rdx,%rsi
  8011b2:	fd                   	std    
  8011b3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011b5:	eb 1d                	jmp    8011d4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011cb:	48 89 d7             	mov    %rdx,%rdi
  8011ce:	48 89 c1             	mov    %rax,%rcx
  8011d1:	fd                   	std    
  8011d2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011d4:	fc                   	cld    
  8011d5:	eb 57                	jmp    80122e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011db:	83 e0 03             	and    $0x3,%eax
  8011de:	48 85 c0             	test   %rax,%rax
  8011e1:	75 36                	jne    801219 <memmove+0xfc>
  8011e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e7:	83 e0 03             	and    $0x3,%eax
  8011ea:	48 85 c0             	test   %rax,%rax
  8011ed:	75 2a                	jne    801219 <memmove+0xfc>
  8011ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f3:	83 e0 03             	and    $0x3,%eax
  8011f6:	48 85 c0             	test   %rax,%rax
  8011f9:	75 1e                	jne    801219 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ff:	48 c1 e8 02          	shr    $0x2,%rax
  801203:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80120e:	48 89 c7             	mov    %rax,%rdi
  801211:	48 89 d6             	mov    %rdx,%rsi
  801214:	fc                   	cld    
  801215:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801217:	eb 15                	jmp    80122e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801221:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801225:	48 89 c7             	mov    %rax,%rdi
  801228:	48 89 d6             	mov    %rdx,%rsi
  80122b:	fc                   	cld    
  80122c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80122e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801232:	c9                   	leaveq 
  801233:	c3                   	retq   

0000000000801234 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801234:	55                   	push   %rbp
  801235:	48 89 e5             	mov    %rsp,%rbp
  801238:	48 83 ec 18          	sub    $0x18,%rsp
  80123c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801240:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801244:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801248:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80124c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	48 89 ce             	mov    %rcx,%rsi
  801257:	48 89 c7             	mov    %rax,%rdi
  80125a:	48 b8 1d 11 80 00 00 	movabs $0x80111d,%rax
  801261:	00 00 00 
  801264:	ff d0                	callq  *%rax
}
  801266:	c9                   	leaveq 
  801267:	c3                   	retq   

0000000000801268 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801268:	55                   	push   %rbp
  801269:	48 89 e5             	mov    %rsp,%rbp
  80126c:	48 83 ec 28          	sub    $0x28,%rsp
  801270:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801274:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801278:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801284:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801288:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80128c:	eb 36                	jmp    8012c4 <memcmp+0x5c>
		if (*s1 != *s2)
  80128e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801292:	0f b6 10             	movzbl (%rax),%edx
  801295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	38 c2                	cmp    %al,%dl
  80129e:	74 1a                	je     8012ba <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a4:	0f b6 00             	movzbl (%rax),%eax
  8012a7:	0f b6 d0             	movzbl %al,%edx
  8012aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	0f b6 c0             	movzbl %al,%eax
  8012b4:	29 c2                	sub    %eax,%edx
  8012b6:	89 d0                	mov    %edx,%eax
  8012b8:	eb 20                	jmp    8012da <memcmp+0x72>
		s1++, s2++;
  8012ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012d0:	48 85 c0             	test   %rax,%rax
  8012d3:	75 b9                	jne    80128e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012da:	c9                   	leaveq 
  8012db:	c3                   	retq   

00000000008012dc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	48 83 ec 28          	sub    $0x28,%rsp
  8012e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f7:	48 01 d0             	add    %rdx,%rax
  8012fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8012fe:	eb 15                	jmp    801315 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801304:	0f b6 10             	movzbl (%rax),%edx
  801307:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80130a:	38 c2                	cmp    %al,%dl
  80130c:	75 02                	jne    801310 <memfind+0x34>
			break;
  80130e:	eb 0f                	jmp    80131f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801310:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801319:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80131d:	72 e1                	jb     801300 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801323:	c9                   	leaveq 
  801324:	c3                   	retq   

0000000000801325 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801325:	55                   	push   %rbp
  801326:	48 89 e5             	mov    %rsp,%rbp
  801329:	48 83 ec 34          	sub    $0x34,%rsp
  80132d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801331:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801335:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80133f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801346:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801347:	eb 05                	jmp    80134e <strtol+0x29>
		s++;
  801349:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80134e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801352:	0f b6 00             	movzbl (%rax),%eax
  801355:	3c 20                	cmp    $0x20,%al
  801357:	74 f0                	je     801349 <strtol+0x24>
  801359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135d:	0f b6 00             	movzbl (%rax),%eax
  801360:	3c 09                	cmp    $0x9,%al
  801362:	74 e5                	je     801349 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801364:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801368:	0f b6 00             	movzbl (%rax),%eax
  80136b:	3c 2b                	cmp    $0x2b,%al
  80136d:	75 07                	jne    801376 <strtol+0x51>
		s++;
  80136f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801374:	eb 17                	jmp    80138d <strtol+0x68>
	else if (*s == '-')
  801376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	3c 2d                	cmp    $0x2d,%al
  80137f:	75 0c                	jne    80138d <strtol+0x68>
		s++, neg = 1;
  801381:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801386:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80138d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801391:	74 06                	je     801399 <strtol+0x74>
  801393:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801397:	75 28                	jne    8013c1 <strtol+0x9c>
  801399:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139d:	0f b6 00             	movzbl (%rax),%eax
  8013a0:	3c 30                	cmp    $0x30,%al
  8013a2:	75 1d                	jne    8013c1 <strtol+0x9c>
  8013a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a8:	48 83 c0 01          	add    $0x1,%rax
  8013ac:	0f b6 00             	movzbl (%rax),%eax
  8013af:	3c 78                	cmp    $0x78,%al
  8013b1:	75 0e                	jne    8013c1 <strtol+0x9c>
		s += 2, base = 16;
  8013b3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013b8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013bf:	eb 2c                	jmp    8013ed <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013c5:	75 19                	jne    8013e0 <strtol+0xbb>
  8013c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	3c 30                	cmp    $0x30,%al
  8013d0:	75 0e                	jne    8013e0 <strtol+0xbb>
		s++, base = 8;
  8013d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013d7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013de:	eb 0d                	jmp    8013ed <strtol+0xc8>
	else if (base == 0)
  8013e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013e4:	75 07                	jne    8013ed <strtol+0xc8>
		base = 10;
  8013e6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	0f b6 00             	movzbl (%rax),%eax
  8013f4:	3c 2f                	cmp    $0x2f,%al
  8013f6:	7e 1d                	jle    801415 <strtol+0xf0>
  8013f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fc:	0f b6 00             	movzbl (%rax),%eax
  8013ff:	3c 39                	cmp    $0x39,%al
  801401:	7f 12                	jg     801415 <strtol+0xf0>
			dig = *s - '0';
  801403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	0f be c0             	movsbl %al,%eax
  80140d:	83 e8 30             	sub    $0x30,%eax
  801410:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801413:	eb 4e                	jmp    801463 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	3c 60                	cmp    $0x60,%al
  80141e:	7e 1d                	jle    80143d <strtol+0x118>
  801420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	3c 7a                	cmp    $0x7a,%al
  801429:	7f 12                	jg     80143d <strtol+0x118>
			dig = *s - 'a' + 10;
  80142b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142f:	0f b6 00             	movzbl (%rax),%eax
  801432:	0f be c0             	movsbl %al,%eax
  801435:	83 e8 57             	sub    $0x57,%eax
  801438:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80143b:	eb 26                	jmp    801463 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	3c 40                	cmp    $0x40,%al
  801446:	7e 48                	jle    801490 <strtol+0x16b>
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	0f b6 00             	movzbl (%rax),%eax
  80144f:	3c 5a                	cmp    $0x5a,%al
  801451:	7f 3d                	jg     801490 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	0f b6 00             	movzbl (%rax),%eax
  80145a:	0f be c0             	movsbl %al,%eax
  80145d:	83 e8 37             	sub    $0x37,%eax
  801460:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801463:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801466:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801469:	7c 02                	jl     80146d <strtol+0x148>
			break;
  80146b:	eb 23                	jmp    801490 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80146d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801472:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801475:	48 98                	cltq   
  801477:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80147c:	48 89 c2             	mov    %rax,%rdx
  80147f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801482:	48 98                	cltq   
  801484:	48 01 d0             	add    %rdx,%rax
  801487:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80148b:	e9 5d ff ff ff       	jmpq   8013ed <strtol+0xc8>

	if (endptr)
  801490:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801495:	74 0b                	je     8014a2 <strtol+0x17d>
		*endptr = (char *) s;
  801497:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80149b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80149f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014a6:	74 09                	je     8014b1 <strtol+0x18c>
  8014a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ac:	48 f7 d8             	neg    %rax
  8014af:	eb 04                	jmp    8014b5 <strtol+0x190>
  8014b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014b5:	c9                   	leaveq 
  8014b6:	c3                   	retq   

00000000008014b7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014b7:	55                   	push   %rbp
  8014b8:	48 89 e5             	mov    %rsp,%rbp
  8014bb:	48 83 ec 30          	sub    $0x30,%rsp
  8014bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014cf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014d9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014dd:	75 06                	jne    8014e5 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	eb 6b                	jmp    801550 <strstr+0x99>

	len = strlen(str);
  8014e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014e9:	48 89 c7             	mov    %rax,%rdi
  8014ec:	48 b8 8d 0d 80 00 00 	movabs $0x800d8d,%rax
  8014f3:	00 00 00 
  8014f6:	ff d0                	callq  *%rax
  8014f8:	48 98                	cltq   
  8014fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8014fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801502:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801506:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80150a:	0f b6 00             	movzbl (%rax),%eax
  80150d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801510:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801514:	75 07                	jne    80151d <strstr+0x66>
				return (char *) 0;
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb 33                	jmp    801550 <strstr+0x99>
		} while (sc != c);
  80151d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801521:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801524:	75 d8                	jne    8014fe <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801526:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80152a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	48 89 ce             	mov    %rcx,%rsi
  801535:	48 89 c7             	mov    %rax,%rdi
  801538:	48 b8 ae 0f 80 00 00 	movabs $0x800fae,%rax
  80153f:	00 00 00 
  801542:	ff d0                	callq  *%rax
  801544:	85 c0                	test   %eax,%eax
  801546:	75 b6                	jne    8014fe <strstr+0x47>

	return (char *) (in - 1);
  801548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154c:	48 83 e8 01          	sub    $0x1,%rax
}
  801550:	c9                   	leaveq 
  801551:	c3                   	retq   

0000000000801552 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	53                   	push   %rbx
  801557:	48 83 ec 48          	sub    $0x48,%rsp
  80155b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80155e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801561:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801565:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801569:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80156d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801571:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801574:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801578:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80157c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801580:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801584:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801588:	4c 89 c3             	mov    %r8,%rbx
  80158b:	cd 30                	int    $0x30
  80158d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801591:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801595:	74 3e                	je     8015d5 <syscall+0x83>
  801597:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80159c:	7e 37                	jle    8015d5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80159e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015a5:	49 89 d0             	mov    %rdx,%r8
  8015a8:	89 c1                	mov    %eax,%ecx
  8015aa:	48 ba 28 1c 80 00 00 	movabs $0x801c28,%rdx
  8015b1:	00 00 00 
  8015b4:	be 23 00 00 00       	mov    $0x23,%esi
  8015b9:	48 bf 45 1c 80 00 00 	movabs $0x801c45,%rdi
  8015c0:	00 00 00 
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	49 b9 ea 16 80 00 00 	movabs $0x8016ea,%r9
  8015cf:	00 00 00 
  8015d2:	41 ff d1             	callq  *%r9

	return ret;
  8015d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d9:	48 83 c4 48          	add    $0x48,%rsp
  8015dd:	5b                   	pop    %rbx
  8015de:	5d                   	pop    %rbp
  8015df:	c3                   	retq   

00000000008015e0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015e0:	55                   	push   %rbp
  8015e1:	48 89 e5             	mov    %rsp,%rbp
  8015e4:	48 83 ec 20          	sub    $0x20,%rsp
  8015e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8015ff:	00 
  801600:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801606:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80160c:	48 89 d1             	mov    %rdx,%rcx
  80160f:	48 89 c2             	mov    %rax,%rdx
  801612:	be 00 00 00 00       	mov    $0x0,%esi
  801617:	bf 00 00 00 00       	mov    $0x0,%edi
  80161c:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  801623:	00 00 00 
  801626:	ff d0                	callq  *%rax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <sys_cgetc>:

int
sys_cgetc(void)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801632:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801639:	00 
  80163a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801640:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801646:	b9 00 00 00 00       	mov    $0x0,%ecx
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	be 00 00 00 00       	mov    $0x0,%esi
  801655:	bf 01 00 00 00       	mov    $0x1,%edi
  80165a:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  801661:	00 00 00 
  801664:	ff d0                	callq  *%rax
}
  801666:	c9                   	leaveq 
  801667:	c3                   	retq   

0000000000801668 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801668:	55                   	push   %rbp
  801669:	48 89 e5             	mov    %rsp,%rbp
  80166c:	48 83 ec 10          	sub    $0x10,%rsp
  801670:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801676:	48 98                	cltq   
  801678:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80167f:	00 
  801680:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801686:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80168c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801691:	48 89 c2             	mov    %rax,%rdx
  801694:	be 01 00 00 00       	mov    $0x1,%esi
  801699:	bf 03 00 00 00       	mov    $0x3,%edi
  80169e:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  8016a5:	00 00 00 
  8016a8:	ff d0                	callq  *%rax
}
  8016aa:	c9                   	leaveq 
  8016ab:	c3                   	retq   

00000000008016ac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016ac:	55                   	push   %rbp
  8016ad:	48 89 e5             	mov    %rsp,%rbp
  8016b0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016bb:	00 
  8016bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d2:	be 00 00 00 00       	mov    $0x0,%esi
  8016d7:	bf 02 00 00 00       	mov    $0x2,%edi
  8016dc:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  8016e3:	00 00 00 
  8016e6:	ff d0                	callq  *%rax
}
  8016e8:	c9                   	leaveq 
  8016e9:	c3                   	retq   

00000000008016ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8016ea:	55                   	push   %rbp
  8016eb:	48 89 e5             	mov    %rsp,%rbp
  8016ee:	53                   	push   %rbx
  8016ef:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8016f6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8016fd:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801703:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80170a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801711:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801718:	84 c0                	test   %al,%al
  80171a:	74 23                	je     80173f <_panic+0x55>
  80171c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801723:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801727:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80172b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80172f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801733:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801737:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80173b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80173f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801746:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80174d:	00 00 00 
  801750:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801757:	00 00 00 
  80175a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80175e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801765:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80176c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801773:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80177a:	00 00 00 
  80177d:	48 8b 18             	mov    (%rax),%rbx
  801780:	48 b8 ac 16 80 00 00 	movabs $0x8016ac,%rax
  801787:	00 00 00 
  80178a:	ff d0                	callq  *%rax
  80178c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801792:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801799:	41 89 c8             	mov    %ecx,%r8d
  80179c:	48 89 d1             	mov    %rdx,%rcx
  80179f:	48 89 da             	mov    %rbx,%rdx
  8017a2:	89 c6                	mov    %eax,%esi
  8017a4:	48 bf 58 1c 80 00 00 	movabs $0x801c58,%rdi
  8017ab:	00 00 00 
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b3:	49 b9 31 02 80 00 00 	movabs $0x800231,%r9
  8017ba:	00 00 00 
  8017bd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017c0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017c7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8017ce:	48 89 d6             	mov    %rdx,%rsi
  8017d1:	48 89 c7             	mov    %rax,%rdi
  8017d4:	48 b8 85 01 80 00 00 	movabs $0x800185,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	callq  *%rax
	cprintf("\n");
  8017e0:	48 bf 7b 1c 80 00 00 	movabs $0x801c7b,%rdi
  8017e7:	00 00 00 
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ef:	48 ba 31 02 80 00 00 	movabs $0x800231,%rdx
  8017f6:	00 00 00 
  8017f9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8017fb:	cc                   	int3   
  8017fc:	eb fd                	jmp    8017fb <_panic+0x111>
