
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
  800052:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  800059:	00 00 00 
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	cprintf("1/0 is %08x!\n", 1/zero);
  800062:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  800069:	00 00 00 
  80006c:	8b 08                	mov    (%rax),%ecx
  80006e:	b8 01 00 00 00       	mov    $0x1,%eax
  800073:	99                   	cltd   
  800074:	f7 f9                	idiv   %ecx
  800076:	89 c6                	mov    %eax,%esi
  800078:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  80007f:	00 00 00 
  800082:	b8 00 00 00 00       	mov    $0x0,%eax
  800087:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
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
  800099:	48 83 ec 20          	sub    $0x20,%rsp
  80009d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8000a4:	48 b8 e9 16 80 00 00 	movabs $0x8016e9,%rax
  8000ab:	00 00 00 
  8000ae:	ff d0                	callq  *%rax
  8000b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8000b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bb:	48 63 d0             	movslq %eax,%rdx
  8000be:	48 89 d0             	mov    %rdx,%rax
  8000c1:	48 c1 e0 03          	shl    $0x3,%rax
  8000c5:	48 01 d0             	add    %rdx,%rax
  8000c8:	48 c1 e0 05          	shl    $0x5,%rax
  8000cc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000d3:	00 00 00 
  8000d6:	48 01 c2             	add    %rax,%rdx
  8000d9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000e0:	00 00 00 
  8000e3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ea:	7e 14                	jle    800100 <libmain+0x6b>
		binaryname = argv[0];
  8000ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000f0:	48 8b 10             	mov    (%rax),%rdx
  8000f3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000fa:	00 00 00 
  8000fd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800100:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800104:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800107:	48 89 d6             	mov    %rdx,%rsi
  80010a:	89 c7                	mov    %eax,%edi
  80010c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800113:	00 00 00 
  800116:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800118:	48 b8 26 01 80 00 00 	movabs $0x800126,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
}
  800124:	c9                   	leaveq 
  800125:	c3                   	retq   

0000000000800126 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800126:	55                   	push   %rbp
  800127:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80012a:	48 b8 13 1d 80 00 00 	movabs $0x801d13,%rax
  800131:	00 00 00 
  800134:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800136:	bf 00 00 00 00       	mov    $0x0,%edi
  80013b:	48 b8 a5 16 80 00 00 	movabs $0x8016a5,%rax
  800142:	00 00 00 
  800145:	ff d0                	callq  *%rax
}
  800147:	5d                   	pop    %rbp
  800148:	c3                   	retq   

0000000000800149 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800149:	55                   	push   %rbp
  80014a:	48 89 e5             	mov    %rsp,%rbp
  80014d:	48 83 ec 10          	sub    $0x10,%rsp
  800151:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800154:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015c:	8b 00                	mov    (%rax),%eax
  80015e:	8d 48 01             	lea    0x1(%rax),%ecx
  800161:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800165:	89 0a                	mov    %ecx,(%rdx)
  800167:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800170:	48 98                	cltq   
  800172:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017a:	8b 00                	mov    (%rax),%eax
  80017c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800181:	75 2c                	jne    8001af <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800187:	8b 00                	mov    (%rax),%eax
  800189:	48 98                	cltq   
  80018b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018f:	48 83 c2 08          	add    $0x8,%rdx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 89 d7             	mov    %rdx,%rdi
  800199:	48 b8 1d 16 80 00 00 	movabs $0x80161d,%rax
  8001a0:	00 00 00 
  8001a3:	ff d0                	callq  *%rax
        b->idx = 0;
  8001a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b3:	8b 40 04             	mov    0x4(%rax),%eax
  8001b6:	8d 50 01             	lea    0x1(%rax),%edx
  8001b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bd:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001c0:	c9                   	leaveq 
  8001c1:	c3                   	retq   

00000000008001c2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001c2:	55                   	push   %rbp
  8001c3:	48 89 e5             	mov    %rsp,%rbp
  8001c6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001cd:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001db:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001e2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001e9:	48 8b 0a             	mov    (%rdx),%rcx
  8001ec:	48 89 08             	mov    %rcx,(%rax)
  8001ef:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001f3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001f7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001fb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800206:	00 00 00 
    b.cnt = 0;
  800209:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800210:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800213:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80021a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800221:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800228:	48 89 c6             	mov    %rax,%rsi
  80022b:	48 bf 49 01 80 00 00 	movabs $0x800149,%rdi
  800232:	00 00 00 
  800235:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800241:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800247:	48 98                	cltq   
  800249:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800250:	48 83 c2 08          	add    $0x8,%rdx
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 89 d7             	mov    %rdx,%rdi
  80025a:	48 b8 1d 16 80 00 00 	movabs $0x80161d,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800266:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80026c:	c9                   	leaveq 
  80026d:	c3                   	retq   

000000000080026e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80026e:	55                   	push   %rbp
  80026f:	48 89 e5             	mov    %rsp,%rbp
  800272:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800279:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800280:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800287:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80028e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800295:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80029c:	84 c0                	test   %al,%al
  80029e:	74 20                	je     8002c0 <cprintf+0x52>
  8002a0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002a4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002a8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002ac:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002b4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002b8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002bc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002c0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002c7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002ce:	00 00 00 
  8002d1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002d8:	00 00 00 
  8002db:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002df:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002e6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002ed:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002f4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002fb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800302:	48 8b 0a             	mov    (%rdx),%rcx
  800305:	48 89 08             	mov    %rcx,(%rax)
  800308:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80030c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800310:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800314:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800318:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80031f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800326:	48 89 d6             	mov    %rdx,%rsi
  800329:	48 89 c7             	mov    %rax,%rdi
  80032c:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
  800338:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80033e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800344:	c9                   	leaveq 
  800345:	c3                   	retq   

0000000000800346 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800346:	55                   	push   %rbp
  800347:	48 89 e5             	mov    %rsp,%rbp
  80034a:	53                   	push   %rbx
  80034b:	48 83 ec 38          	sub    $0x38,%rsp
  80034f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800353:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800357:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80035b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80035e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800362:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800366:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800369:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80036d:	77 3b                	ja     8003aa <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800372:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800376:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80037d:	ba 00 00 00 00       	mov    $0x0,%edx
  800382:	48 f7 f3             	div    %rbx
  800385:	48 89 c2             	mov    %rax,%rdx
  800388:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80038b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80038e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800396:	41 89 f9             	mov    %edi,%r9d
  800399:	48 89 c7             	mov    %rax,%rdi
  80039c:	48 b8 46 03 80 00 00 	movabs $0x800346,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	eb 1e                	jmp    8003c8 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003aa:	eb 12                	jmp    8003be <printnum+0x78>
			putch(padc, putdat);
  8003ac:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003b0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b7:	48 89 ce             	mov    %rcx,%rsi
  8003ba:	89 d7                	mov    %edx,%edi
  8003bc:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003be:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003c2:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003c6:	7f e4                	jg     8003ac <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d4:	48 f7 f1             	div    %rcx
  8003d7:	48 89 d0             	mov    %rdx,%rax
  8003da:	48 ba 30 38 80 00 00 	movabs $0x803830,%rdx
  8003e1:	00 00 00 
  8003e4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003e8:	0f be d0             	movsbl %al,%edx
  8003eb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f3:	48 89 ce             	mov    %rcx,%rsi
  8003f6:	89 d7                	mov    %edx,%edi
  8003f8:	ff d0                	callq  *%rax
}
  8003fa:	48 83 c4 38          	add    $0x38,%rsp
  8003fe:	5b                   	pop    %rbx
  8003ff:	5d                   	pop    %rbp
  800400:	c3                   	retq   

0000000000800401 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800401:	55                   	push   %rbp
  800402:	48 89 e5             	mov    %rsp,%rbp
  800405:	48 83 ec 1c          	sub    $0x1c,%rsp
  800409:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80040d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800410:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800414:	7e 52                	jle    800468 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041a:	8b 00                	mov    (%rax),%eax
  80041c:	83 f8 30             	cmp    $0x30,%eax
  80041f:	73 24                	jae    800445 <getuint+0x44>
  800421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800425:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042d:	8b 00                	mov    (%rax),%eax
  80042f:	89 c0                	mov    %eax,%eax
  800431:	48 01 d0             	add    %rdx,%rax
  800434:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800438:	8b 12                	mov    (%rdx),%edx
  80043a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80043d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800441:	89 0a                	mov    %ecx,(%rdx)
  800443:	eb 17                	jmp    80045c <getuint+0x5b>
  800445:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800449:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80044d:	48 89 d0             	mov    %rdx,%rax
  800450:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800454:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800458:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80045c:	48 8b 00             	mov    (%rax),%rax
  80045f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800463:	e9 a3 00 00 00       	jmpq   80050b <getuint+0x10a>
	else if (lflag)
  800468:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80046c:	74 4f                	je     8004bd <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80046e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800472:	8b 00                	mov    (%rax),%eax
  800474:	83 f8 30             	cmp    $0x30,%eax
  800477:	73 24                	jae    80049d <getuint+0x9c>
  800479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800485:	8b 00                	mov    (%rax),%eax
  800487:	89 c0                	mov    %eax,%eax
  800489:	48 01 d0             	add    %rdx,%rax
  80048c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800490:	8b 12                	mov    (%rdx),%edx
  800492:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800495:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800499:	89 0a                	mov    %ecx,(%rdx)
  80049b:	eb 17                	jmp    8004b4 <getuint+0xb3>
  80049d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004a5:	48 89 d0             	mov    %rdx,%rax
  8004a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004b4:	48 8b 00             	mov    (%rax),%rax
  8004b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004bb:	eb 4e                	jmp    80050b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c1:	8b 00                	mov    (%rax),%eax
  8004c3:	83 f8 30             	cmp    $0x30,%eax
  8004c6:	73 24                	jae    8004ec <getuint+0xeb>
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
  8004ea:	eb 17                	jmp    800503 <getuint+0x102>
  8004ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f4:	48 89 d0             	mov    %rdx,%rax
  8004f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800503:	8b 00                	mov    (%rax),%eax
  800505:	89 c0                	mov    %eax,%eax
  800507:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80050b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80050f:	c9                   	leaveq 
  800510:	c3                   	retq   

0000000000800511 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800511:	55                   	push   %rbp
  800512:	48 89 e5             	mov    %rsp,%rbp
  800515:	48 83 ec 1c          	sub    $0x1c,%rsp
  800519:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80051d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800520:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800524:	7e 52                	jle    800578 <getint+0x67>
		x=va_arg(*ap, long long);
  800526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052a:	8b 00                	mov    (%rax),%eax
  80052c:	83 f8 30             	cmp    $0x30,%eax
  80052f:	73 24                	jae    800555 <getint+0x44>
  800531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800535:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053d:	8b 00                	mov    (%rax),%eax
  80053f:	89 c0                	mov    %eax,%eax
  800541:	48 01 d0             	add    %rdx,%rax
  800544:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800548:	8b 12                	mov    (%rdx),%edx
  80054a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80054d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800551:	89 0a                	mov    %ecx,(%rdx)
  800553:	eb 17                	jmp    80056c <getint+0x5b>
  800555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800559:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80055d:	48 89 d0             	mov    %rdx,%rax
  800560:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800568:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056c:	48 8b 00             	mov    (%rax),%rax
  80056f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800573:	e9 a3 00 00 00       	jmpq   80061b <getint+0x10a>
	else if (lflag)
  800578:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80057c:	74 4f                	je     8005cd <getint+0xbc>
		x=va_arg(*ap, long);
  80057e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800582:	8b 00                	mov    (%rax),%eax
  800584:	83 f8 30             	cmp    $0x30,%eax
  800587:	73 24                	jae    8005ad <getint+0x9c>
  800589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	8b 00                	mov    (%rax),%eax
  800597:	89 c0                	mov    %eax,%eax
  800599:	48 01 d0             	add    %rdx,%rax
  80059c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a0:	8b 12                	mov    (%rdx),%edx
  8005a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a9:	89 0a                	mov    %ecx,(%rdx)
  8005ab:	eb 17                	jmp    8005c4 <getint+0xb3>
  8005ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b5:	48 89 d0             	mov    %rdx,%rax
  8005b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c4:	48 8b 00             	mov    (%rax),%rax
  8005c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005cb:	eb 4e                	jmp    80061b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d1:	8b 00                	mov    (%rax),%eax
  8005d3:	83 f8 30             	cmp    $0x30,%eax
  8005d6:	73 24                	jae    8005fc <getint+0xeb>
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
  8005fa:	eb 17                	jmp    800613 <getint+0x102>
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800604:	48 89 d0             	mov    %rdx,%rax
  800607:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800613:	8b 00                	mov    (%rax),%eax
  800615:	48 98                	cltq   
  800617:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80061b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80061f:	c9                   	leaveq 
  800620:	c3                   	retq   

0000000000800621 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800621:	55                   	push   %rbp
  800622:	48 89 e5             	mov    %rsp,%rbp
  800625:	41 54                	push   %r12
  800627:	53                   	push   %rbx
  800628:	48 83 ec 60          	sub    $0x60,%rsp
  80062c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800630:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800634:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800638:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80063c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800640:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800644:	48 8b 0a             	mov    (%rdx),%rcx
  800647:	48 89 08             	mov    %rcx,(%rax)
  80064a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80064e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800652:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800656:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065a:	eb 17                	jmp    800673 <vprintfmt+0x52>
			if (ch == '\0')
  80065c:	85 db                	test   %ebx,%ebx
  80065e:	0f 84 df 04 00 00    	je     800b43 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800664:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800668:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80066c:	48 89 d6             	mov    %rdx,%rsi
  80066f:	89 df                	mov    %ebx,%edi
  800671:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800673:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800677:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80067b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067f:	0f b6 00             	movzbl (%rax),%eax
  800682:	0f b6 d8             	movzbl %al,%ebx
  800685:	83 fb 25             	cmp    $0x25,%ebx
  800688:	75 d2                	jne    80065c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80068a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80068e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800695:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80069c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006a3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006aa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006b2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006b6:	0f b6 00             	movzbl (%rax),%eax
  8006b9:	0f b6 d8             	movzbl %al,%ebx
  8006bc:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006bf:	83 f8 55             	cmp    $0x55,%eax
  8006c2:	0f 87 47 04 00 00    	ja     800b0f <vprintfmt+0x4ee>
  8006c8:	89 c0                	mov    %eax,%eax
  8006ca:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006d1:	00 
  8006d2:	48 b8 58 38 80 00 00 	movabs $0x803858,%rax
  8006d9:	00 00 00 
  8006dc:	48 01 d0             	add    %rdx,%rax
  8006df:	48 8b 00             	mov    (%rax),%rax
  8006e2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006e4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006e8:	eb c0                	jmp    8006aa <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ea:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006ee:	eb ba                	jmp    8006aa <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006f7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006fa:	89 d0                	mov    %edx,%eax
  8006fc:	c1 e0 02             	shl    $0x2,%eax
  8006ff:	01 d0                	add    %edx,%eax
  800701:	01 c0                	add    %eax,%eax
  800703:	01 d8                	add    %ebx,%eax
  800705:	83 e8 30             	sub    $0x30,%eax
  800708:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80070b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80070f:	0f b6 00             	movzbl (%rax),%eax
  800712:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800715:	83 fb 2f             	cmp    $0x2f,%ebx
  800718:	7e 0c                	jle    800726 <vprintfmt+0x105>
  80071a:	83 fb 39             	cmp    $0x39,%ebx
  80071d:	7f 07                	jg     800726 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800724:	eb d1                	jmp    8006f7 <vprintfmt+0xd6>
			goto process_precision;
  800726:	eb 58                	jmp    800780 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800728:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072b:	83 f8 30             	cmp    $0x30,%eax
  80072e:	73 17                	jae    800747 <vprintfmt+0x126>
  800730:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800734:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800737:	89 c0                	mov    %eax,%eax
  800739:	48 01 d0             	add    %rdx,%rax
  80073c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80073f:	83 c2 08             	add    $0x8,%edx
  800742:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800745:	eb 0f                	jmp    800756 <vprintfmt+0x135>
  800747:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80074b:	48 89 d0             	mov    %rdx,%rax
  80074e:	48 83 c2 08          	add    $0x8,%rdx
  800752:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800756:	8b 00                	mov    (%rax),%eax
  800758:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80075b:	eb 23                	jmp    800780 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80075d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800761:	79 0c                	jns    80076f <vprintfmt+0x14e>
				width = 0;
  800763:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80076a:	e9 3b ff ff ff       	jmpq   8006aa <vprintfmt+0x89>
  80076f:	e9 36 ff ff ff       	jmpq   8006aa <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800774:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80077b:	e9 2a ff ff ff       	jmpq   8006aa <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800780:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800784:	79 12                	jns    800798 <vprintfmt+0x177>
				width = precision, precision = -1;
  800786:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800789:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80078c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800793:	e9 12 ff ff ff       	jmpq   8006aa <vprintfmt+0x89>
  800798:	e9 0d ff ff ff       	jmpq   8006aa <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80079d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007a1:	e9 04 ff ff ff       	jmpq   8006aa <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a9:	83 f8 30             	cmp    $0x30,%eax
  8007ac:	73 17                	jae    8007c5 <vprintfmt+0x1a4>
  8007ae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b5:	89 c0                	mov    %eax,%eax
  8007b7:	48 01 d0             	add    %rdx,%rax
  8007ba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007bd:	83 c2 08             	add    $0x8,%edx
  8007c0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c3:	eb 0f                	jmp    8007d4 <vprintfmt+0x1b3>
  8007c5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c9:	48 89 d0             	mov    %rdx,%rax
  8007cc:	48 83 c2 08          	add    $0x8,%rdx
  8007d0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d4:	8b 10                	mov    (%rax),%edx
  8007d6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007de:	48 89 ce             	mov    %rcx,%rsi
  8007e1:	89 d7                	mov    %edx,%edi
  8007e3:	ff d0                	callq  *%rax
			break;
  8007e5:	e9 53 03 00 00       	jmpq   800b3d <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ed:	83 f8 30             	cmp    $0x30,%eax
  8007f0:	73 17                	jae    800809 <vprintfmt+0x1e8>
  8007f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f9:	89 c0                	mov    %eax,%eax
  8007fb:	48 01 d0             	add    %rdx,%rax
  8007fe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800801:	83 c2 08             	add    $0x8,%edx
  800804:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800807:	eb 0f                	jmp    800818 <vprintfmt+0x1f7>
  800809:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080d:	48 89 d0             	mov    %rdx,%rax
  800810:	48 83 c2 08          	add    $0x8,%rdx
  800814:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800818:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80081a:	85 db                	test   %ebx,%ebx
  80081c:	79 02                	jns    800820 <vprintfmt+0x1ff>
				err = -err;
  80081e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800820:	83 fb 15             	cmp    $0x15,%ebx
  800823:	7f 16                	jg     80083b <vprintfmt+0x21a>
  800825:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  80082c:	00 00 00 
  80082f:	48 63 d3             	movslq %ebx,%rdx
  800832:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800836:	4d 85 e4             	test   %r12,%r12
  800839:	75 2e                	jne    800869 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80083b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80083f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800843:	89 d9                	mov    %ebx,%ecx
  800845:	48 ba 41 38 80 00 00 	movabs $0x803841,%rdx
  80084c:	00 00 00 
  80084f:	48 89 c7             	mov    %rax,%rdi
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
  800857:	49 b8 4c 0b 80 00 00 	movabs $0x800b4c,%r8
  80085e:	00 00 00 
  800861:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800864:	e9 d4 02 00 00       	jmpq   800b3d <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800869:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80086d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800871:	4c 89 e1             	mov    %r12,%rcx
  800874:	48 ba 4a 38 80 00 00 	movabs $0x80384a,%rdx
  80087b:	00 00 00 
  80087e:	48 89 c7             	mov    %rax,%rdi
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	49 b8 4c 0b 80 00 00 	movabs $0x800b4c,%r8
  80088d:	00 00 00 
  800890:	41 ff d0             	callq  *%r8
			break;
  800893:	e9 a5 02 00 00       	jmpq   800b3d <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800898:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089b:	83 f8 30             	cmp    $0x30,%eax
  80089e:	73 17                	jae    8008b7 <vprintfmt+0x296>
  8008a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a7:	89 c0                	mov    %eax,%eax
  8008a9:	48 01 d0             	add    %rdx,%rax
  8008ac:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008af:	83 c2 08             	add    $0x8,%edx
  8008b2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b5:	eb 0f                	jmp    8008c6 <vprintfmt+0x2a5>
  8008b7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bb:	48 89 d0             	mov    %rdx,%rax
  8008be:	48 83 c2 08          	add    $0x8,%rdx
  8008c2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c6:	4c 8b 20             	mov    (%rax),%r12
  8008c9:	4d 85 e4             	test   %r12,%r12
  8008cc:	75 0a                	jne    8008d8 <vprintfmt+0x2b7>
				p = "(null)";
  8008ce:	49 bc 4d 38 80 00 00 	movabs $0x80384d,%r12
  8008d5:	00 00 00 
			if (width > 0 && padc != '-')
  8008d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008dc:	7e 3f                	jle    80091d <vprintfmt+0x2fc>
  8008de:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008e2:	74 39                	je     80091d <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e7:	48 98                	cltq   
  8008e9:	48 89 c6             	mov    %rax,%rsi
  8008ec:	4c 89 e7             	mov    %r12,%rdi
  8008ef:	48 b8 f8 0d 80 00 00 	movabs $0x800df8,%rax
  8008f6:	00 00 00 
  8008f9:	ff d0                	callq  *%rax
  8008fb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008fe:	eb 17                	jmp    800917 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800900:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800904:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800908:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090c:	48 89 ce             	mov    %rcx,%rsi
  80090f:	89 d7                	mov    %edx,%edi
  800911:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800913:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800917:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80091b:	7f e3                	jg     800900 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091d:	eb 37                	jmp    800956 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80091f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800923:	74 1e                	je     800943 <vprintfmt+0x322>
  800925:	83 fb 1f             	cmp    $0x1f,%ebx
  800928:	7e 05                	jle    80092f <vprintfmt+0x30e>
  80092a:	83 fb 7e             	cmp    $0x7e,%ebx
  80092d:	7e 14                	jle    800943 <vprintfmt+0x322>
					putch('?', putdat);
  80092f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800933:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800937:	48 89 d6             	mov    %rdx,%rsi
  80093a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80093f:	ff d0                	callq  *%rax
  800941:	eb 0f                	jmp    800952 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800943:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800947:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094b:	48 89 d6             	mov    %rdx,%rsi
  80094e:	89 df                	mov    %ebx,%edi
  800950:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800952:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800956:	4c 89 e0             	mov    %r12,%rax
  800959:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80095d:	0f b6 00             	movzbl (%rax),%eax
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 10                	je     800977 <vprintfmt+0x356>
  800967:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80096b:	78 b2                	js     80091f <vprintfmt+0x2fe>
  80096d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800971:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800975:	79 a8                	jns    80091f <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	eb 16                	jmp    80098f <vprintfmt+0x36e>
				putch(' ', putdat);
  800979:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80097d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800981:	48 89 d6             	mov    %rdx,%rsi
  800984:	bf 20 00 00 00       	mov    $0x20,%edi
  800989:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80098f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800993:	7f e4                	jg     800979 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800995:	e9 a3 01 00 00       	jmpq   800b3d <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80099a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80099e:	be 03 00 00 00       	mov    $0x3,%esi
  8009a3:	48 89 c7             	mov    %rax,%rdi
  8009a6:	48 b8 11 05 80 00 00 	movabs $0x800511,%rax
  8009ad:	00 00 00 
  8009b0:	ff d0                	callq  *%rax
  8009b2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	48 85 c0             	test   %rax,%rax
  8009bd:	79 1d                	jns    8009dc <vprintfmt+0x3bb>
				putch('-', putdat);
  8009bf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c7:	48 89 d6             	mov    %rdx,%rsi
  8009ca:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009cf:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d5:	48 f7 d8             	neg    %rax
  8009d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009dc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e3:	e9 e8 00 00 00       	jmpq   800ad0 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009e8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ec:	be 03 00 00 00       	mov    $0x3,%esi
  8009f1:	48 89 c7             	mov    %rax,%rdi
  8009f4:	48 b8 01 04 80 00 00 	movabs $0x800401,%rax
  8009fb:	00 00 00 
  8009fe:	ff d0                	callq  *%rax
  800a00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a04:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a0b:	e9 c0 00 00 00       	jmpq   800ad0 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a18:	48 89 d6             	mov    %rdx,%rsi
  800a1b:	bf 58 00 00 00       	mov    $0x58,%edi
  800a20:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2a:	48 89 d6             	mov    %rdx,%rsi
  800a2d:	bf 58 00 00 00       	mov    $0x58,%edi
  800a32:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	48 89 d6             	mov    %rdx,%rsi
  800a3f:	bf 58 00 00 00       	mov    $0x58,%edi
  800a44:	ff d0                	callq  *%rax
			break;
  800a46:	e9 f2 00 00 00       	jmpq   800b3d <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a53:	48 89 d6             	mov    %rdx,%rsi
  800a56:	bf 30 00 00 00       	mov    $0x30,%edi
  800a5b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a65:	48 89 d6             	mov    %rdx,%rsi
  800a68:	bf 78 00 00 00       	mov    $0x78,%edi
  800a6d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a72:	83 f8 30             	cmp    $0x30,%eax
  800a75:	73 17                	jae    800a8e <vprintfmt+0x46d>
  800a77:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7e:	89 c0                	mov    %eax,%eax
  800a80:	48 01 d0             	add    %rdx,%rax
  800a83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a86:	83 c2 08             	add    $0x8,%edx
  800a89:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8c:	eb 0f                	jmp    800a9d <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a92:	48 89 d0             	mov    %rdx,%rax
  800a95:	48 83 c2 08          	add    $0x8,%rdx
  800a99:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800aa4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aab:	eb 23                	jmp    800ad0 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800aad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ab1:	be 03 00 00 00       	mov    $0x3,%esi
  800ab6:	48 89 c7             	mov    %rax,%rdi
  800ab9:	48 b8 01 04 80 00 00 	movabs $0x800401,%rax
  800ac0:	00 00 00 
  800ac3:	ff d0                	callq  *%rax
  800ac5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ac9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ad0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ad5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ad8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae7:	45 89 c1             	mov    %r8d,%r9d
  800aea:	41 89 f8             	mov    %edi,%r8d
  800aed:	48 89 c7             	mov    %rax,%rdi
  800af0:	48 b8 46 03 80 00 00 	movabs $0x800346,%rax
  800af7:	00 00 00 
  800afa:	ff d0                	callq  *%rax
			break;
  800afc:	eb 3f                	jmp    800b3d <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800afe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b06:	48 89 d6             	mov    %rdx,%rsi
  800b09:	89 df                	mov    %ebx,%edi
  800b0b:	ff d0                	callq  *%rax
			break;
  800b0d:	eb 2e                	jmp    800b3d <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b17:	48 89 d6             	mov    %rdx,%rsi
  800b1a:	bf 25 00 00 00       	mov    $0x25,%edi
  800b1f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b21:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b26:	eb 05                	jmp    800b2d <vprintfmt+0x50c>
  800b28:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b2d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b31:	48 83 e8 01          	sub    $0x1,%rax
  800b35:	0f b6 00             	movzbl (%rax),%eax
  800b38:	3c 25                	cmp    $0x25,%al
  800b3a:	75 ec                	jne    800b28 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b3c:	90                   	nop
		}
	}
  800b3d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3e:	e9 30 fb ff ff       	jmpq   800673 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b43:	48 83 c4 60          	add    $0x60,%rsp
  800b47:	5b                   	pop    %rbx
  800b48:	41 5c                	pop    %r12
  800b4a:	5d                   	pop    %rbp
  800b4b:	c3                   	retq   

0000000000800b4c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b4c:	55                   	push   %rbp
  800b4d:	48 89 e5             	mov    %rsp,%rbp
  800b50:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b57:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b5e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b65:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b6c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b73:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b7a:	84 c0                	test   %al,%al
  800b7c:	74 20                	je     800b9e <printfmt+0x52>
  800b7e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b82:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b86:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b8a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b8e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b92:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b96:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b9a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b9e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ba5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bac:	00 00 00 
  800baf:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bb6:	00 00 00 
  800bb9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bbd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bc4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bcb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bd9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800be0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800be7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bee:	48 89 c7             	mov    %rax,%rdi
  800bf1:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  800bf8:	00 00 00 
  800bfb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bfd:	c9                   	leaveq 
  800bfe:	c3                   	retq   

0000000000800bff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bff:	55                   	push   %rbp
  800c00:	48 89 e5             	mov    %rsp,%rbp
  800c03:	48 83 ec 10          	sub    $0x10,%rsp
  800c07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c0a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c12:	8b 40 10             	mov    0x10(%rax),%eax
  800c15:	8d 50 01             	lea    0x1(%rax),%edx
  800c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c23:	48 8b 10             	mov    (%rax),%rdx
  800c26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c2e:	48 39 c2             	cmp    %rax,%rdx
  800c31:	73 17                	jae    800c4a <sprintputch+0x4b>
		*b->buf++ = ch;
  800c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c37:	48 8b 00             	mov    (%rax),%rax
  800c3a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c42:	48 89 0a             	mov    %rcx,(%rdx)
  800c45:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c48:	88 10                	mov    %dl,(%rax)
}
  800c4a:	c9                   	leaveq 
  800c4b:	c3                   	retq   

0000000000800c4c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c4c:	55                   	push   %rbp
  800c4d:	48 89 e5             	mov    %rsp,%rbp
  800c50:	48 83 ec 50          	sub    $0x50,%rsp
  800c54:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c58:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c5b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c5f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c63:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c67:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c6b:	48 8b 0a             	mov    (%rdx),%rcx
  800c6e:	48 89 08             	mov    %rcx,(%rax)
  800c71:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c75:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c79:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c7d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c81:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c85:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c89:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c8c:	48 98                	cltq   
  800c8e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c92:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c96:	48 01 d0             	add    %rdx,%rax
  800c99:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c9d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ca4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ca9:	74 06                	je     800cb1 <vsnprintf+0x65>
  800cab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800caf:	7f 07                	jg     800cb8 <vsnprintf+0x6c>
		return -E_INVAL;
  800cb1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb6:	eb 2f                	jmp    800ce7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cb8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cbc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cc0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cc4:	48 89 c6             	mov    %rax,%rsi
  800cc7:	48 bf ff 0b 80 00 00 	movabs $0x800bff,%rdi
  800cce:	00 00 00 
  800cd1:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  800cd8:	00 00 00 
  800cdb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cdd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ce1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ce4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ce7:	c9                   	leaveq 
  800ce8:	c3                   	retq   

0000000000800ce9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce9:	55                   	push   %rbp
  800cea:	48 89 e5             	mov    %rsp,%rbp
  800ced:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cf4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cfb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d01:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d08:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d0f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d16:	84 c0                	test   %al,%al
  800d18:	74 20                	je     800d3a <snprintf+0x51>
  800d1a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d1e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d22:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d26:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d2a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d2e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d32:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d36:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d3a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d41:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d48:	00 00 00 
  800d4b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d52:	00 00 00 
  800d55:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d59:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d60:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d67:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d6e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d75:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d7c:	48 8b 0a             	mov    (%rdx),%rcx
  800d7f:	48 89 08             	mov    %rcx,(%rax)
  800d82:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d86:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d8a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d8e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d92:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d99:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800da0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800da6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dad:	48 89 c7             	mov    %rax,%rdi
  800db0:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  800db7:	00 00 00 
  800dba:	ff d0                	callq  *%rax
  800dbc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dc2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dc8:	c9                   	leaveq 
  800dc9:	c3                   	retq   

0000000000800dca <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dca:	55                   	push   %rbp
  800dcb:	48 89 e5             	mov    %rsp,%rbp
  800dce:	48 83 ec 18          	sub    $0x18,%rsp
  800dd2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ddd:	eb 09                	jmp    800de8 <strlen+0x1e>
		n++;
  800ddf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dec:	0f b6 00             	movzbl (%rax),%eax
  800def:	84 c0                	test   %al,%al
  800df1:	75 ec                	jne    800ddf <strlen+0x15>
		n++;
	return n;
  800df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800df6:	c9                   	leaveq 
  800df7:	c3                   	retq   

0000000000800df8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800df8:	55                   	push   %rbp
  800df9:	48 89 e5             	mov    %rsp,%rbp
  800dfc:	48 83 ec 20          	sub    $0x20,%rsp
  800e00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e0f:	eb 0e                	jmp    800e1f <strnlen+0x27>
		n++;
  800e11:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e15:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e1a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e1f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e24:	74 0b                	je     800e31 <strnlen+0x39>
  800e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2a:	0f b6 00             	movzbl (%rax),%eax
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 e0                	jne    800e11 <strnlen+0x19>
		n++;
	return n;
  800e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e34:	c9                   	leaveq 
  800e35:	c3                   	retq   

0000000000800e36 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e36:	55                   	push   %rbp
  800e37:	48 89 e5             	mov    %rsp,%rbp
  800e3a:	48 83 ec 20          	sub    $0x20,%rsp
  800e3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e4e:	90                   	nop
  800e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e57:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e5b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e5f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e63:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e67:	0f b6 12             	movzbl (%rdx),%edx
  800e6a:	88 10                	mov    %dl,(%rax)
  800e6c:	0f b6 00             	movzbl (%rax),%eax
  800e6f:	84 c0                	test   %al,%al
  800e71:	75 dc                	jne    800e4f <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e77:	c9                   	leaveq 
  800e78:	c3                   	retq   

0000000000800e79 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e79:	55                   	push   %rbp
  800e7a:	48 89 e5             	mov    %rsp,%rbp
  800e7d:	48 83 ec 20          	sub    $0x20,%rsp
  800e81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8d:	48 89 c7             	mov    %rax,%rdi
  800e90:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  800e97:	00 00 00 
  800e9a:	ff d0                	callq  *%rax
  800e9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea2:	48 63 d0             	movslq %eax,%rdx
  800ea5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea9:	48 01 c2             	add    %rax,%rdx
  800eac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eb0:	48 89 c6             	mov    %rax,%rsi
  800eb3:	48 89 d7             	mov    %rdx,%rdi
  800eb6:	48 b8 36 0e 80 00 00 	movabs $0x800e36,%rax
  800ebd:	00 00 00 
  800ec0:	ff d0                	callq  *%rax
	return dst;
  800ec2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ec6:	c9                   	leaveq 
  800ec7:	c3                   	retq   

0000000000800ec8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ec8:	55                   	push   %rbp
  800ec9:	48 89 e5             	mov    %rsp,%rbp
  800ecc:	48 83 ec 28          	sub    $0x28,%rsp
  800ed0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ed8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ee4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800eeb:	00 
  800eec:	eb 2a                	jmp    800f18 <strncpy+0x50>
		*dst++ = *src;
  800eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800efa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800efe:	0f b6 12             	movzbl (%rdx),%edx
  800f01:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f07:	0f b6 00             	movzbl (%rax),%eax
  800f0a:	84 c0                	test   %al,%al
  800f0c:	74 05                	je     800f13 <strncpy+0x4b>
			src++;
  800f0e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f13:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f1c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f20:	72 cc                	jb     800eee <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f26:	c9                   	leaveq 
  800f27:	c3                   	retq   

0000000000800f28 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f28:	55                   	push   %rbp
  800f29:	48 89 e5             	mov    %rsp,%rbp
  800f2c:	48 83 ec 28          	sub    $0x28,%rsp
  800f30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f38:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f44:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f49:	74 3d                	je     800f88 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f4b:	eb 1d                	jmp    800f6a <strlcpy+0x42>
			*dst++ = *src++;
  800f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f51:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f59:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f5d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f61:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f65:	0f b6 12             	movzbl (%rdx),%edx
  800f68:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f6a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f6f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f74:	74 0b                	je     800f81 <strlcpy+0x59>
  800f76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f7a:	0f b6 00             	movzbl (%rax),%eax
  800f7d:	84 c0                	test   %al,%al
  800f7f:	75 cc                	jne    800f4d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f85:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f90:	48 29 c2             	sub    %rax,%rdx
  800f93:	48 89 d0             	mov    %rdx,%rax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 83 ec 10          	sub    $0x10,%rsp
  800fa0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fa4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fa8:	eb 0a                	jmp    800fb4 <strcmp+0x1c>
		p++, q++;
  800faa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800faf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb8:	0f b6 00             	movzbl (%rax),%eax
  800fbb:	84 c0                	test   %al,%al
  800fbd:	74 12                	je     800fd1 <strcmp+0x39>
  800fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc3:	0f b6 10             	movzbl (%rax),%edx
  800fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fca:	0f b6 00             	movzbl (%rax),%eax
  800fcd:	38 c2                	cmp    %al,%dl
  800fcf:	74 d9                	je     800faa <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd5:	0f b6 00             	movzbl (%rax),%eax
  800fd8:	0f b6 d0             	movzbl %al,%edx
  800fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdf:	0f b6 00             	movzbl (%rax),%eax
  800fe2:	0f b6 c0             	movzbl %al,%eax
  800fe5:	29 c2                	sub    %eax,%edx
  800fe7:	89 d0                	mov    %edx,%eax
}
  800fe9:	c9                   	leaveq 
  800fea:	c3                   	retq   

0000000000800feb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800feb:	55                   	push   %rbp
  800fec:	48 89 e5             	mov    %rsp,%rbp
  800fef:	48 83 ec 18          	sub    $0x18,%rsp
  800ff3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ff7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ffb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fff:	eb 0f                	jmp    801010 <strncmp+0x25>
		n--, p++, q++;
  801001:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801006:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80100b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801010:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801015:	74 1d                	je     801034 <strncmp+0x49>
  801017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101b:	0f b6 00             	movzbl (%rax),%eax
  80101e:	84 c0                	test   %al,%al
  801020:	74 12                	je     801034 <strncmp+0x49>
  801022:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801026:	0f b6 10             	movzbl (%rax),%edx
  801029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	38 c2                	cmp    %al,%dl
  801032:	74 cd                	je     801001 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801034:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801039:	75 07                	jne    801042 <strncmp+0x57>
		return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
  801040:	eb 18                	jmp    80105a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801042:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801046:	0f b6 00             	movzbl (%rax),%eax
  801049:	0f b6 d0             	movzbl %al,%edx
  80104c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801050:	0f b6 00             	movzbl (%rax),%eax
  801053:	0f b6 c0             	movzbl %al,%eax
  801056:	29 c2                	sub    %eax,%edx
  801058:	89 d0                	mov    %edx,%eax
}
  80105a:	c9                   	leaveq 
  80105b:	c3                   	retq   

000000000080105c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 0c          	sub    $0xc,%rsp
  801064:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801068:	89 f0                	mov    %esi,%eax
  80106a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80106d:	eb 17                	jmp    801086 <strchr+0x2a>
		if (*s == c)
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801079:	75 06                	jne    801081 <strchr+0x25>
			return (char *) s;
  80107b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107f:	eb 15                	jmp    801096 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801081:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108a:	0f b6 00             	movzbl (%rax),%eax
  80108d:	84 c0                	test   %al,%al
  80108f:	75 de                	jne    80106f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801096:	c9                   	leaveq 
  801097:	c3                   	retq   

0000000000801098 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	48 83 ec 0c          	sub    $0xc,%rsp
  8010a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a4:	89 f0                	mov    %esi,%eax
  8010a6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010a9:	eb 13                	jmp    8010be <strfind+0x26>
		if (*s == c)
  8010ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010af:	0f b6 00             	movzbl (%rax),%eax
  8010b2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010b5:	75 02                	jne    8010b9 <strfind+0x21>
			break;
  8010b7:	eb 10                	jmp    8010c9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c2:	0f b6 00             	movzbl (%rax),%eax
  8010c5:	84 c0                	test   %al,%al
  8010c7:	75 e2                	jne    8010ab <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010cd:	c9                   	leaveq 
  8010ce:	c3                   	retq   

00000000008010cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010cf:	55                   	push   %rbp
  8010d0:	48 89 e5             	mov    %rsp,%rbp
  8010d3:	48 83 ec 18          	sub    $0x18,%rsp
  8010d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010db:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e7:	75 06                	jne    8010ef <memset+0x20>
		return v;
  8010e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ed:	eb 69                	jmp    801158 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f3:	83 e0 03             	and    $0x3,%eax
  8010f6:	48 85 c0             	test   %rax,%rax
  8010f9:	75 48                	jne    801143 <memset+0x74>
  8010fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ff:	83 e0 03             	and    $0x3,%eax
  801102:	48 85 c0             	test   %rax,%rax
  801105:	75 3c                	jne    801143 <memset+0x74>
		c &= 0xFF;
  801107:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80110e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801111:	c1 e0 18             	shl    $0x18,%eax
  801114:	89 c2                	mov    %eax,%edx
  801116:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801119:	c1 e0 10             	shl    $0x10,%eax
  80111c:	09 c2                	or     %eax,%edx
  80111e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801121:	c1 e0 08             	shl    $0x8,%eax
  801124:	09 d0                	or     %edx,%eax
  801126:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112d:	48 c1 e8 02          	shr    $0x2,%rax
  801131:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801134:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801138:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113b:	48 89 d7             	mov    %rdx,%rdi
  80113e:	fc                   	cld    
  80113f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801141:	eb 11                	jmp    801154 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801143:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801147:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80114e:	48 89 d7             	mov    %rdx,%rdi
  801151:	fc                   	cld    
  801152:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801158:	c9                   	leaveq 
  801159:	c3                   	retq   

000000000080115a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80115a:	55                   	push   %rbp
  80115b:	48 89 e5             	mov    %rsp,%rbp
  80115e:	48 83 ec 28          	sub    $0x28,%rsp
  801162:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801166:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80116e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801172:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801176:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80117e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801182:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801186:	0f 83 88 00 00 00    	jae    801214 <memmove+0xba>
  80118c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801190:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801194:	48 01 d0             	add    %rdx,%rax
  801197:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80119b:	76 77                	jbe    801214 <memmove+0xba>
		s += n;
  80119d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b1:	83 e0 03             	and    $0x3,%eax
  8011b4:	48 85 c0             	test   %rax,%rax
  8011b7:	75 3b                	jne    8011f4 <memmove+0x9a>
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	83 e0 03             	and    $0x3,%eax
  8011c0:	48 85 c0             	test   %rax,%rax
  8011c3:	75 2f                	jne    8011f4 <memmove+0x9a>
  8011c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c9:	83 e0 03             	and    $0x3,%eax
  8011cc:	48 85 c0             	test   %rax,%rax
  8011cf:	75 23                	jne    8011f4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d5:	48 83 e8 04          	sub    $0x4,%rax
  8011d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011dd:	48 83 ea 04          	sub    $0x4,%rdx
  8011e1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011e5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011e9:	48 89 c7             	mov    %rax,%rdi
  8011ec:	48 89 d6             	mov    %rdx,%rsi
  8011ef:	fd                   	std    
  8011f0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011f2:	eb 1d                	jmp    801211 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801200:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801204:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801208:	48 89 d7             	mov    %rdx,%rdi
  80120b:	48 89 c1             	mov    %rax,%rcx
  80120e:	fd                   	std    
  80120f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801211:	fc                   	cld    
  801212:	eb 57                	jmp    80126b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801218:	83 e0 03             	and    $0x3,%eax
  80121b:	48 85 c0             	test   %rax,%rax
  80121e:	75 36                	jne    801256 <memmove+0xfc>
  801220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801224:	83 e0 03             	and    $0x3,%eax
  801227:	48 85 c0             	test   %rax,%rax
  80122a:	75 2a                	jne    801256 <memmove+0xfc>
  80122c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801230:	83 e0 03             	and    $0x3,%eax
  801233:	48 85 c0             	test   %rax,%rax
  801236:	75 1e                	jne    801256 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801238:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123c:	48 c1 e8 02          	shr    $0x2,%rax
  801240:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801247:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124b:	48 89 c7             	mov    %rax,%rdi
  80124e:	48 89 d6             	mov    %rdx,%rsi
  801251:	fc                   	cld    
  801252:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801254:	eb 15                	jmp    80126b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801262:	48 89 c7             	mov    %rax,%rdi
  801265:	48 89 d6             	mov    %rdx,%rsi
  801268:	fc                   	cld    
  801269:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80126b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80126f:	c9                   	leaveq 
  801270:	c3                   	retq   

0000000000801271 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801271:	55                   	push   %rbp
  801272:	48 89 e5             	mov    %rsp,%rbp
  801275:	48 83 ec 18          	sub    $0x18,%rsp
  801279:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80127d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801281:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801285:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801289:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80128d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801291:	48 89 ce             	mov    %rcx,%rsi
  801294:	48 89 c7             	mov    %rax,%rdi
  801297:	48 b8 5a 11 80 00 00 	movabs $0x80115a,%rax
  80129e:	00 00 00 
  8012a1:	ff d0                	callq  *%rax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 28          	sub    $0x28,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012c9:	eb 36                	jmp    801301 <memcmp+0x5c>
		if (*s1 != *s2)
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	0f b6 10             	movzbl (%rax),%edx
  8012d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d6:	0f b6 00             	movzbl (%rax),%eax
  8012d9:	38 c2                	cmp    %al,%dl
  8012db:	74 1a                	je     8012f7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e1:	0f b6 00             	movzbl (%rax),%eax
  8012e4:	0f b6 d0             	movzbl %al,%edx
  8012e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012eb:	0f b6 00             	movzbl (%rax),%eax
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 20                	jmp    801317 <memcmp+0x72>
		s1++, s2++;
  8012f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801301:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801305:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801309:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80130d:	48 85 c0             	test   %rax,%rax
  801310:	75 b9                	jne    8012cb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	48 83 ec 28          	sub    $0x28,%rsp
  801321:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801325:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801328:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80132c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801330:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801334:	48 01 d0             	add    %rdx,%rax
  801337:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80133b:	eb 15                	jmp    801352 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80133d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801341:	0f b6 10             	movzbl (%rax),%edx
  801344:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801347:	38 c2                	cmp    %al,%dl
  801349:	75 02                	jne    80134d <memfind+0x34>
			break;
  80134b:	eb 0f                	jmp    80135c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80134d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801356:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80135a:	72 e1                	jb     80133d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801360:	c9                   	leaveq 
  801361:	c3                   	retq   

0000000000801362 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801362:	55                   	push   %rbp
  801363:	48 89 e5             	mov    %rsp,%rbp
  801366:	48 83 ec 34          	sub    $0x34,%rsp
  80136a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80136e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801372:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801375:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80137c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801383:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801384:	eb 05                	jmp    80138b <strtol+0x29>
		s++;
  801386:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138f:	0f b6 00             	movzbl (%rax),%eax
  801392:	3c 20                	cmp    $0x20,%al
  801394:	74 f0                	je     801386 <strtol+0x24>
  801396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	3c 09                	cmp    $0x9,%al
  80139f:	74 e5                	je     801386 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	3c 2b                	cmp    $0x2b,%al
  8013aa:	75 07                	jne    8013b3 <strtol+0x51>
		s++;
  8013ac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013b1:	eb 17                	jmp    8013ca <strtol+0x68>
	else if (*s == '-')
  8013b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b7:	0f b6 00             	movzbl (%rax),%eax
  8013ba:	3c 2d                	cmp    $0x2d,%al
  8013bc:	75 0c                	jne    8013ca <strtol+0x68>
		s++, neg = 1;
  8013be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ce:	74 06                	je     8013d6 <strtol+0x74>
  8013d0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013d4:	75 28                	jne    8013fe <strtol+0x9c>
  8013d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013da:	0f b6 00             	movzbl (%rax),%eax
  8013dd:	3c 30                	cmp    $0x30,%al
  8013df:	75 1d                	jne    8013fe <strtol+0x9c>
  8013e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e5:	48 83 c0 01          	add    $0x1,%rax
  8013e9:	0f b6 00             	movzbl (%rax),%eax
  8013ec:	3c 78                	cmp    $0x78,%al
  8013ee:	75 0e                	jne    8013fe <strtol+0x9c>
		s += 2, base = 16;
  8013f0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013f5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013fc:	eb 2c                	jmp    80142a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801402:	75 19                	jne    80141d <strtol+0xbb>
  801404:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801408:	0f b6 00             	movzbl (%rax),%eax
  80140b:	3c 30                	cmp    $0x30,%al
  80140d:	75 0e                	jne    80141d <strtol+0xbb>
		s++, base = 8;
  80140f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801414:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80141b:	eb 0d                	jmp    80142a <strtol+0xc8>
	else if (base == 0)
  80141d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801421:	75 07                	jne    80142a <strtol+0xc8>
		base = 10;
  801423:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	3c 2f                	cmp    $0x2f,%al
  801433:	7e 1d                	jle    801452 <strtol+0xf0>
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	3c 39                	cmp    $0x39,%al
  80143e:	7f 12                	jg     801452 <strtol+0xf0>
			dig = *s - '0';
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	0f be c0             	movsbl %al,%eax
  80144a:	83 e8 30             	sub    $0x30,%eax
  80144d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801450:	eb 4e                	jmp    8014a0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	3c 60                	cmp    $0x60,%al
  80145b:	7e 1d                	jle    80147a <strtol+0x118>
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	0f b6 00             	movzbl (%rax),%eax
  801464:	3c 7a                	cmp    $0x7a,%al
  801466:	7f 12                	jg     80147a <strtol+0x118>
			dig = *s - 'a' + 10;
  801468:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	0f be c0             	movsbl %al,%eax
  801472:	83 e8 57             	sub    $0x57,%eax
  801475:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801478:	eb 26                	jmp    8014a0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80147a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147e:	0f b6 00             	movzbl (%rax),%eax
  801481:	3c 40                	cmp    $0x40,%al
  801483:	7e 48                	jle    8014cd <strtol+0x16b>
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	0f b6 00             	movzbl (%rax),%eax
  80148c:	3c 5a                	cmp    $0x5a,%al
  80148e:	7f 3d                	jg     8014cd <strtol+0x16b>
			dig = *s - 'A' + 10;
  801490:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801494:	0f b6 00             	movzbl (%rax),%eax
  801497:	0f be c0             	movsbl %al,%eax
  80149a:	83 e8 37             	sub    $0x37,%eax
  80149d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014a3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014a6:	7c 02                	jl     8014aa <strtol+0x148>
			break;
  8014a8:	eb 23                	jmp    8014cd <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014af:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014b2:	48 98                	cltq   
  8014b4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014b9:	48 89 c2             	mov    %rax,%rdx
  8014bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014bf:	48 98                	cltq   
  8014c1:	48 01 d0             	add    %rdx,%rax
  8014c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014c8:	e9 5d ff ff ff       	jmpq   80142a <strtol+0xc8>

	if (endptr)
  8014cd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014d2:	74 0b                	je     8014df <strtol+0x17d>
		*endptr = (char *) s;
  8014d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014dc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014e3:	74 09                	je     8014ee <strtol+0x18c>
  8014e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e9:	48 f7 d8             	neg    %rax
  8014ec:	eb 04                	jmp    8014f2 <strtol+0x190>
  8014ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014f2:	c9                   	leaveq 
  8014f3:	c3                   	retq   

00000000008014f4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014f4:	55                   	push   %rbp
  8014f5:	48 89 e5             	mov    %rsp,%rbp
  8014f8:	48 83 ec 30          	sub    $0x30,%rsp
  8014fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801500:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801504:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801508:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80150c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801516:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80151a:	75 06                	jne    801522 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	eb 6b                	jmp    80158d <strstr+0x99>

	len = strlen(str);
  801522:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801526:	48 89 c7             	mov    %rax,%rdi
  801529:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  801530:	00 00 00 
  801533:	ff d0                	callq  *%rax
  801535:	48 98                	cltq   
  801537:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80153b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801543:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801547:	0f b6 00             	movzbl (%rax),%eax
  80154a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80154d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801551:	75 07                	jne    80155a <strstr+0x66>
				return (char *) 0;
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
  801558:	eb 33                	jmp    80158d <strstr+0x99>
		} while (sc != c);
  80155a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80155e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801561:	75 d8                	jne    80153b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801563:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801567:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80156b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156f:	48 89 ce             	mov    %rcx,%rsi
  801572:	48 89 c7             	mov    %rax,%rdi
  801575:	48 b8 eb 0f 80 00 00 	movabs $0x800feb,%rax
  80157c:	00 00 00 
  80157f:	ff d0                	callq  *%rax
  801581:	85 c0                	test   %eax,%eax
  801583:	75 b6                	jne    80153b <strstr+0x47>

	return (char *) (in - 1);
  801585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801589:	48 83 e8 01          	sub    $0x1,%rax
}
  80158d:	c9                   	leaveq 
  80158e:	c3                   	retq   

000000000080158f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80158f:	55                   	push   %rbp
  801590:	48 89 e5             	mov    %rsp,%rbp
  801593:	53                   	push   %rbx
  801594:	48 83 ec 48          	sub    $0x48,%rsp
  801598:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80159b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80159e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015a2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015a6:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015aa:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015b1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015b5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015b9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015bd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015c1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015c5:	4c 89 c3             	mov    %r8,%rbx
  8015c8:	cd 30                	int    $0x30
  8015ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015d2:	74 3e                	je     801612 <syscall+0x83>
  8015d4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d9:	7e 37                	jle    801612 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e2:	49 89 d0             	mov    %rdx,%r8
  8015e5:	89 c1                	mov    %eax,%ecx
  8015e7:	48 ba 08 3b 80 00 00 	movabs $0x803b08,%rdx
  8015ee:	00 00 00 
  8015f1:	be 23 00 00 00       	mov    $0x23,%esi
  8015f6:	48 bf 25 3b 80 00 00 	movabs $0x803b25,%rdi
  8015fd:	00 00 00 
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	49 b9 97 32 80 00 00 	movabs $0x803297,%r9
  80160c:	00 00 00 
  80160f:	41 ff d1             	callq  *%r9

	return ret;
  801612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801616:	48 83 c4 48          	add    $0x48,%rsp
  80161a:	5b                   	pop    %rbx
  80161b:	5d                   	pop    %rbp
  80161c:	c3                   	retq   

000000000080161d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80161d:	55                   	push   %rbp
  80161e:	48 89 e5             	mov    %rsp,%rbp
  801621:	48 83 ec 20          	sub    $0x20,%rsp
  801625:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801629:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80162d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801631:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801635:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80163c:	00 
  80163d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801643:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801649:	48 89 d1             	mov    %rdx,%rcx
  80164c:	48 89 c2             	mov    %rax,%rdx
  80164f:	be 00 00 00 00       	mov    $0x0,%esi
  801654:	bf 00 00 00 00       	mov    $0x0,%edi
  801659:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  801660:	00 00 00 
  801663:	ff d0                	callq  *%rax
}
  801665:	c9                   	leaveq 
  801666:	c3                   	retq   

0000000000801667 <sys_cgetc>:

int
sys_cgetc(void)
{
  801667:	55                   	push   %rbp
  801668:	48 89 e5             	mov    %rsp,%rbp
  80166b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80166f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801676:	00 
  801677:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80167d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801683:	b9 00 00 00 00       	mov    $0x0,%ecx
  801688:	ba 00 00 00 00       	mov    $0x0,%edx
  80168d:	be 00 00 00 00       	mov    $0x0,%esi
  801692:	bf 01 00 00 00       	mov    $0x1,%edi
  801697:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  80169e:	00 00 00 
  8016a1:	ff d0                	callq  *%rax
}
  8016a3:	c9                   	leaveq 
  8016a4:	c3                   	retq   

00000000008016a5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016a5:	55                   	push   %rbp
  8016a6:	48 89 e5             	mov    %rsp,%rbp
  8016a9:	48 83 ec 10          	sub    $0x10,%rsp
  8016ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016b3:	48 98                	cltq   
  8016b5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016bc:	00 
  8016bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ce:	48 89 c2             	mov    %rax,%rdx
  8016d1:	be 01 00 00 00       	mov    $0x1,%esi
  8016d6:	bf 03 00 00 00       	mov    $0x3,%edi
  8016db:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8016e2:	00 00 00 
  8016e5:	ff d0                	callq  *%rax
}
  8016e7:	c9                   	leaveq 
  8016e8:	c3                   	retq   

00000000008016e9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016e9:	55                   	push   %rbp
  8016ea:	48 89 e5             	mov    %rsp,%rbp
  8016ed:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f8:	00 
  8016f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801705:	b9 00 00 00 00       	mov    $0x0,%ecx
  80170a:	ba 00 00 00 00       	mov    $0x0,%edx
  80170f:	be 00 00 00 00       	mov    $0x0,%esi
  801714:	bf 02 00 00 00       	mov    $0x2,%edi
  801719:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  801720:	00 00 00 
  801723:	ff d0                	callq  *%rax
}
  801725:	c9                   	leaveq 
  801726:	c3                   	retq   

0000000000801727 <sys_yield>:

void
sys_yield(void)
{
  801727:	55                   	push   %rbp
  801728:	48 89 e5             	mov    %rsp,%rbp
  80172b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80172f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801736:	00 
  801737:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80173d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801743:	b9 00 00 00 00       	mov    $0x0,%ecx
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	be 00 00 00 00       	mov    $0x0,%esi
  801752:	bf 0b 00 00 00       	mov    $0xb,%edi
  801757:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  80175e:	00 00 00 
  801761:	ff d0                	callq  *%rax
}
  801763:	c9                   	leaveq 
  801764:	c3                   	retq   

0000000000801765 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801765:	55                   	push   %rbp
  801766:	48 89 e5             	mov    %rsp,%rbp
  801769:	48 83 ec 20          	sub    $0x20,%rsp
  80176d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801770:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801774:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801777:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80177a:	48 63 c8             	movslq %eax,%rcx
  80177d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801784:	48 98                	cltq   
  801786:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178d:	00 
  80178e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801794:	49 89 c8             	mov    %rcx,%r8
  801797:	48 89 d1             	mov    %rdx,%rcx
  80179a:	48 89 c2             	mov    %rax,%rdx
  80179d:	be 01 00 00 00       	mov    $0x1,%esi
  8017a2:	bf 04 00 00 00       	mov    $0x4,%edi
  8017a7:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8017ae:	00 00 00 
  8017b1:	ff d0                	callq  *%rax
}
  8017b3:	c9                   	leaveq 
  8017b4:	c3                   	retq   

00000000008017b5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017b5:	55                   	push   %rbp
  8017b6:	48 89 e5             	mov    %rsp,%rbp
  8017b9:	48 83 ec 30          	sub    $0x30,%rsp
  8017bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017c7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017cb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017cf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017d2:	48 63 c8             	movslq %eax,%rcx
  8017d5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017dc:	48 63 f0             	movslq %eax,%rsi
  8017df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e6:	48 98                	cltq   
  8017e8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017ec:	49 89 f9             	mov    %rdi,%r9
  8017ef:	49 89 f0             	mov    %rsi,%r8
  8017f2:	48 89 d1             	mov    %rdx,%rcx
  8017f5:	48 89 c2             	mov    %rax,%rdx
  8017f8:	be 01 00 00 00       	mov    $0x1,%esi
  8017fd:	bf 05 00 00 00       	mov    $0x5,%edi
  801802:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  801809:	00 00 00 
  80180c:	ff d0                	callq  *%rax
}
  80180e:	c9                   	leaveq 
  80180f:	c3                   	retq   

0000000000801810 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801810:	55                   	push   %rbp
  801811:	48 89 e5             	mov    %rsp,%rbp
  801814:	48 83 ec 20          	sub    $0x20,%rsp
  801818:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80181b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80181f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801826:	48 98                	cltq   
  801828:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182f:	00 
  801830:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801836:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80183c:	48 89 d1             	mov    %rdx,%rcx
  80183f:	48 89 c2             	mov    %rax,%rdx
  801842:	be 01 00 00 00       	mov    $0x1,%esi
  801847:	bf 06 00 00 00       	mov    $0x6,%edi
  80184c:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  801853:	00 00 00 
  801856:	ff d0                	callq  *%rax
}
  801858:	c9                   	leaveq 
  801859:	c3                   	retq   

000000000080185a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
  80185e:	48 83 ec 10          	sub    $0x10,%rsp
  801862:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801865:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801868:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80186b:	48 63 d0             	movslq %eax,%rdx
  80186e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801871:	48 98                	cltq   
  801873:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187a:	00 
  80187b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801881:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801887:	48 89 d1             	mov    %rdx,%rcx
  80188a:	48 89 c2             	mov    %rax,%rdx
  80188d:	be 01 00 00 00       	mov    $0x1,%esi
  801892:	bf 08 00 00 00       	mov    $0x8,%edi
  801897:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	callq  *%rax
}
  8018a3:	c9                   	leaveq 
  8018a4:	c3                   	retq   

00000000008018a5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 20          	sub    $0x20,%rsp
  8018ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018bb:	48 98                	cltq   
  8018bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c4:	00 
  8018c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d1:	48 89 d1             	mov    %rdx,%rcx
  8018d4:	48 89 c2             	mov    %rax,%rdx
  8018d7:	be 01 00 00 00       	mov    $0x1,%esi
  8018dc:	bf 09 00 00 00       	mov    $0x9,%edi
  8018e1:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8018e8:	00 00 00 
  8018eb:	ff d0                	callq  *%rax
}
  8018ed:	c9                   	leaveq 
  8018ee:	c3                   	retq   

00000000008018ef <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018ef:	55                   	push   %rbp
  8018f0:	48 89 e5             	mov    %rsp,%rbp
  8018f3:	48 83 ec 20          	sub    $0x20,%rsp
  8018f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801905:	48 98                	cltq   
  801907:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190e:	00 
  80190f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801915:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80191b:	48 89 d1             	mov    %rdx,%rcx
  80191e:	48 89 c2             	mov    %rax,%rdx
  801921:	be 01 00 00 00       	mov    $0x1,%esi
  801926:	bf 0a 00 00 00       	mov    $0xa,%edi
  80192b:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  801932:	00 00 00 
  801935:	ff d0                	callq  *%rax
}
  801937:	c9                   	leaveq 
  801938:	c3                   	retq   

0000000000801939 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	48 83 ec 20          	sub    $0x20,%rsp
  801941:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801944:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801948:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80194c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80194f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801952:	48 63 f0             	movslq %eax,%rsi
  801955:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801959:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195c:	48 98                	cltq   
  80195e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801962:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801969:	00 
  80196a:	49 89 f1             	mov    %rsi,%r9
  80196d:	49 89 c8             	mov    %rcx,%r8
  801970:	48 89 d1             	mov    %rdx,%rcx
  801973:	48 89 c2             	mov    %rax,%rdx
  801976:	be 00 00 00 00       	mov    $0x0,%esi
  80197b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801980:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  801987:	00 00 00 
  80198a:	ff d0                	callq  *%rax
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	48 83 ec 10          	sub    $0x10,%rsp
  801996:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80199a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a5:	00 
  8019a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b7:	48 89 c2             	mov    %rax,%rdx
  8019ba:	be 01 00 00 00       	mov    $0x1,%esi
  8019bf:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019c4:	48 b8 8f 15 80 00 00 	movabs $0x80158f,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
}
  8019d0:	c9                   	leaveq 
  8019d1:	c3                   	retq   

00000000008019d2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8019d2:	55                   	push   %rbp
  8019d3:	48 89 e5             	mov    %rsp,%rbp
  8019d6:	48 83 ec 08          	sub    $0x8,%rsp
  8019da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019e2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019e9:	ff ff ff 
  8019ec:	48 01 d0             	add    %rdx,%rax
  8019ef:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019f3:	c9                   	leaveq 
  8019f4:	c3                   	retq   

00000000008019f5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019f5:	55                   	push   %rbp
  8019f6:	48 89 e5             	mov    %rsp,%rbp
  8019f9:	48 83 ec 08          	sub    $0x8,%rsp
  8019fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a05:	48 89 c7             	mov    %rax,%rdi
  801a08:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
  801a14:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a1a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a1e:	c9                   	leaveq 
  801a1f:	c3                   	retq   

0000000000801a20 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a20:	55                   	push   %rbp
  801a21:	48 89 e5             	mov    %rsp,%rbp
  801a24:	48 83 ec 18          	sub    $0x18,%rsp
  801a28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a33:	eb 6b                	jmp    801aa0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a38:	48 98                	cltq   
  801a3a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a40:	48 c1 e0 0c          	shl    $0xc,%rax
  801a44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a4c:	48 c1 e8 15          	shr    $0x15,%rax
  801a50:	48 89 c2             	mov    %rax,%rdx
  801a53:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801a5a:	01 00 00 
  801a5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a61:	83 e0 01             	and    $0x1,%eax
  801a64:	48 85 c0             	test   %rax,%rax
  801a67:	74 21                	je     801a8a <fd_alloc+0x6a>
  801a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6d:	48 c1 e8 0c          	shr    $0xc,%rax
  801a71:	48 89 c2             	mov    %rax,%rdx
  801a74:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a7b:	01 00 00 
  801a7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a82:	83 e0 01             	and    $0x1,%eax
  801a85:	48 85 c0             	test   %rax,%rax
  801a88:	75 12                	jne    801a9c <fd_alloc+0x7c>
			*fd_store = fd;
  801a8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a92:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9a:	eb 1a                	jmp    801ab6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801aa0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801aa4:	7e 8f                	jle    801a35 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aaa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ab1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 20          	sub    $0x20,%rsp
  801ac0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ac3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ac7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801acb:	78 06                	js     801ad3 <fd_lookup+0x1b>
  801acd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ad1:	7e 07                	jle    801ada <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ad3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad8:	eb 6c                	jmp    801b46 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ada:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ae5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ae9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af1:	48 c1 e8 15          	shr    $0x15,%rax
  801af5:	48 89 c2             	mov    %rax,%rdx
  801af8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801aff:	01 00 00 
  801b02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b06:	83 e0 01             	and    $0x1,%eax
  801b09:	48 85 c0             	test   %rax,%rax
  801b0c:	74 21                	je     801b2f <fd_lookup+0x77>
  801b0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b12:	48 c1 e8 0c          	shr    $0xc,%rax
  801b16:	48 89 c2             	mov    %rax,%rdx
  801b19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b20:	01 00 00 
  801b23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b27:	83 e0 01             	and    $0x1,%eax
  801b2a:	48 85 c0             	test   %rax,%rax
  801b2d:	75 07                	jne    801b36 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b34:	eb 10                	jmp    801b46 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b3e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 30          	sub    $0x30,%rsp
  801b50:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b54:	89 f0                	mov    %esi,%eax
  801b56:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5d:	48 89 c7             	mov    %rax,%rdi
  801b60:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  801b67:	00 00 00 
  801b6a:	ff d0                	callq  *%rax
  801b6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b70:	48 89 d6             	mov    %rdx,%rsi
  801b73:	89 c7                	mov    %eax,%edi
  801b75:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  801b7c:	00 00 00 
  801b7f:	ff d0                	callq  *%rax
  801b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b88:	78 0a                	js     801b94 <fd_close+0x4c>
	    || fd != fd2)
  801b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b8e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801b92:	74 12                	je     801ba6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801b94:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801b98:	74 05                	je     801b9f <fd_close+0x57>
  801b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9d:	eb 05                	jmp    801ba4 <fd_close+0x5c>
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba4:	eb 69                	jmp    801c0f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ba6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801baa:	8b 00                	mov    (%rax),%eax
  801bac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801bb0:	48 89 d6             	mov    %rdx,%rsi
  801bb3:	89 c7                	mov    %eax,%edi
  801bb5:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  801bbc:	00 00 00 
  801bbf:	ff d0                	callq  *%rax
  801bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bc8:	78 2a                	js     801bf4 <fd_close+0xac>
		if (dev->dev_close)
  801bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bce:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bd2:	48 85 c0             	test   %rax,%rax
  801bd5:	74 16                	je     801bed <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdb:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bdf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801be3:	48 89 d7             	mov    %rdx,%rdi
  801be6:	ff d0                	callq  *%rax
  801be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801beb:	eb 07                	jmp    801bf4 <fd_close+0xac>
		else
			r = 0;
  801bed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf8:	48 89 c6             	mov    %rax,%rsi
  801bfb:	bf 00 00 00 00       	mov    $0x0,%edi
  801c00:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  801c07:	00 00 00 
  801c0a:	ff d0                	callq  *%rax
	return r;
  801c0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 20          	sub    $0x20,%rsp
  801c19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c27:	eb 41                	jmp    801c6a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c29:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c30:	00 00 00 
  801c33:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c36:	48 63 d2             	movslq %edx,%rdx
  801c39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c3d:	8b 00                	mov    (%rax),%eax
  801c3f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c42:	75 22                	jne    801c66 <dev_lookup+0x55>
			*dev = devtab[i];
  801c44:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c4b:	00 00 00 
  801c4e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c51:	48 63 d2             	movslq %edx,%rdx
  801c54:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c64:	eb 60                	jmp    801cc6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c66:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c6a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c71:	00 00 00 
  801c74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c77:	48 63 d2             	movslq %edx,%rdx
  801c7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c7e:	48 85 c0             	test   %rax,%rax
  801c81:	75 a6                	jne    801c29 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c83:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801c8a:	00 00 00 
  801c8d:	48 8b 00             	mov    (%rax),%rax
  801c90:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c96:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c99:	89 c6                	mov    %eax,%esi
  801c9b:	48 bf 38 3b 80 00 00 	movabs $0x803b38,%rdi
  801ca2:	00 00 00 
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  801caa:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  801cb1:	00 00 00 
  801cb4:	ff d1                	callq  *%rcx
	*dev = 0;
  801cb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801cc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cc6:	c9                   	leaveq 
  801cc7:	c3                   	retq   

0000000000801cc8 <close>:

int
close(int fdnum)
{
  801cc8:	55                   	push   %rbp
  801cc9:	48 89 e5             	mov    %rsp,%rbp
  801ccc:	48 83 ec 20          	sub    $0x20,%rsp
  801cd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cd3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cda:	48 89 d6             	mov    %rdx,%rsi
  801cdd:	89 c7                	mov    %eax,%edi
  801cdf:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
  801ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cf2:	79 05                	jns    801cf9 <close+0x31>
		return r;
  801cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf7:	eb 18                	jmp    801d11 <close+0x49>
	else
		return fd_close(fd, 1);
  801cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfd:	be 01 00 00 00       	mov    $0x1,%esi
  801d02:	48 89 c7             	mov    %rax,%rdi
  801d05:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  801d0c:	00 00 00 
  801d0f:	ff d0                	callq  *%rax
}
  801d11:	c9                   	leaveq 
  801d12:	c3                   	retq   

0000000000801d13 <close_all>:

void
close_all(void)
{
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
  801d17:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d22:	eb 15                	jmp    801d39 <close_all+0x26>
		close(i);
  801d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d27:	89 c7                	mov    %eax,%edi
  801d29:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801d30:	00 00 00 
  801d33:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d39:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d3d:	7e e5                	jle    801d24 <close_all+0x11>
		close(i);
}
  801d3f:	c9                   	leaveq 
  801d40:	c3                   	retq   

0000000000801d41 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d41:	55                   	push   %rbp
  801d42:	48 89 e5             	mov    %rsp,%rbp
  801d45:	48 83 ec 40          	sub    $0x40,%rsp
  801d49:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d4c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d4f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801d53:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d56:	48 89 d6             	mov    %rdx,%rsi
  801d59:	89 c7                	mov    %eax,%edi
  801d5b:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  801d62:	00 00 00 
  801d65:	ff d0                	callq  *%rax
  801d67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d6e:	79 08                	jns    801d78 <dup+0x37>
		return r;
  801d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d73:	e9 70 01 00 00       	jmpq   801ee8 <dup+0x1a7>
	close(newfdnum);
  801d78:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d7b:	89 c7                	mov    %eax,%edi
  801d7d:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801d89:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d8c:	48 98                	cltq   
  801d8e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d94:	48 c1 e0 0c          	shl    $0xc,%rax
  801d98:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801d9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da0:	48 89 c7             	mov    %rax,%rdi
  801da3:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	callq  *%rax
  801daf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db7:	48 89 c7             	mov    %rax,%rdi
  801dba:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
  801dc6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801dca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dce:	48 c1 e8 15          	shr    $0x15,%rax
  801dd2:	48 89 c2             	mov    %rax,%rdx
  801dd5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ddc:	01 00 00 
  801ddf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de3:	83 e0 01             	and    $0x1,%eax
  801de6:	48 85 c0             	test   %rax,%rax
  801de9:	74 73                	je     801e5e <dup+0x11d>
  801deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801def:	48 c1 e8 0c          	shr    $0xc,%rax
  801df3:	48 89 c2             	mov    %rax,%rdx
  801df6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dfd:	01 00 00 
  801e00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e04:	83 e0 01             	and    $0x1,%eax
  801e07:	48 85 c0             	test   %rax,%rax
  801e0a:	74 52                	je     801e5e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e10:	48 c1 e8 0c          	shr    $0xc,%rax
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e1e:	01 00 00 
  801e21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e25:	25 07 0e 00 00       	and    $0xe07,%eax
  801e2a:	89 c1                	mov    %eax,%ecx
  801e2c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e34:	41 89 c8             	mov    %ecx,%r8d
  801e37:	48 89 d1             	mov    %rdx,%rcx
  801e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3f:	48 89 c6             	mov    %rax,%rsi
  801e42:	bf 00 00 00 00       	mov    $0x0,%edi
  801e47:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801e4e:	00 00 00 
  801e51:	ff d0                	callq  *%rax
  801e53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e5a:	79 02                	jns    801e5e <dup+0x11d>
			goto err;
  801e5c:	eb 57                	jmp    801eb5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e62:	48 c1 e8 0c          	shr    $0xc,%rax
  801e66:	48 89 c2             	mov    %rax,%rdx
  801e69:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e70:	01 00 00 
  801e73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e77:	25 07 0e 00 00       	and    $0xe07,%eax
  801e7c:	89 c1                	mov    %eax,%ecx
  801e7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e86:	41 89 c8             	mov    %ecx,%r8d
  801e89:	48 89 d1             	mov    %rdx,%rcx
  801e8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e91:	48 89 c6             	mov    %rax,%rsi
  801e94:	bf 00 00 00 00       	mov    $0x0,%edi
  801e99:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  801ea0:	00 00 00 
  801ea3:	ff d0                	callq  *%rax
  801ea5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eac:	79 02                	jns    801eb0 <dup+0x16f>
		goto err;
  801eae:	eb 05                	jmp    801eb5 <dup+0x174>

	return newfdnum;
  801eb0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801eb3:	eb 33                	jmp    801ee8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb9:	48 89 c6             	mov    %rax,%rsi
  801ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec1:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed1:	48 89 c6             	mov    %rax,%rsi
  801ed4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed9:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	callq  *%rax
	return r;
  801ee5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ee8:	c9                   	leaveq 
  801ee9:	c3                   	retq   

0000000000801eea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801eea:	55                   	push   %rbp
  801eeb:	48 89 e5             	mov    %rsp,%rbp
  801eee:	48 83 ec 40          	sub    $0x40,%rsp
  801ef2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ef5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801ef9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801efd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f01:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f04:	48 89 d6             	mov    %rdx,%rsi
  801f07:	89 c7                	mov    %eax,%edi
  801f09:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	callq  *%rax
  801f15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f1c:	78 24                	js     801f42 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f22:	8b 00                	mov    (%rax),%eax
  801f24:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f28:	48 89 d6             	mov    %rdx,%rsi
  801f2b:	89 c7                	mov    %eax,%edi
  801f2d:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  801f34:	00 00 00 
  801f37:	ff d0                	callq  *%rax
  801f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f40:	79 05                	jns    801f47 <read+0x5d>
		return r;
  801f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f45:	eb 76                	jmp    801fbd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4b:	8b 40 08             	mov    0x8(%rax),%eax
  801f4e:	83 e0 03             	and    $0x3,%eax
  801f51:	83 f8 01             	cmp    $0x1,%eax
  801f54:	75 3a                	jne    801f90 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f56:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f5d:	00 00 00 
  801f60:	48 8b 00             	mov    (%rax),%rax
  801f63:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f69:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f6c:	89 c6                	mov    %eax,%esi
  801f6e:	48 bf 57 3b 80 00 00 	movabs $0x803b57,%rdi
  801f75:	00 00 00 
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  801f84:	00 00 00 
  801f87:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801f89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f8e:	eb 2d                	jmp    801fbd <read+0xd3>
	}
	if (!dev->dev_read)
  801f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f94:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f98:	48 85 c0             	test   %rax,%rax
  801f9b:	75 07                	jne    801fa4 <read+0xba>
		return -E_NOT_SUPP;
  801f9d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801fa2:	eb 19                	jmp    801fbd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa8:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fb0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801fb4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801fb8:	48 89 cf             	mov    %rcx,%rdi
  801fbb:	ff d0                	callq  *%rax
}
  801fbd:	c9                   	leaveq 
  801fbe:	c3                   	retq   

0000000000801fbf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801fbf:	55                   	push   %rbp
  801fc0:	48 89 e5             	mov    %rsp,%rbp
  801fc3:	48 83 ec 30          	sub    $0x30,%rsp
  801fc7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801fd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fd9:	eb 49                	jmp    802024 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fde:	48 98                	cltq   
  801fe0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fe4:	48 29 c2             	sub    %rax,%rdx
  801fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fea:	48 63 c8             	movslq %eax,%rcx
  801fed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff1:	48 01 c1             	add    %rax,%rcx
  801ff4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff7:	48 89 ce             	mov    %rcx,%rsi
  801ffa:	89 c7                	mov    %eax,%edi
  801ffc:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  802003:	00 00 00 
  802006:	ff d0                	callq  *%rax
  802008:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80200b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80200f:	79 05                	jns    802016 <readn+0x57>
			return m;
  802011:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802014:	eb 1c                	jmp    802032 <readn+0x73>
		if (m == 0)
  802016:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80201a:	75 02                	jne    80201e <readn+0x5f>
			break;
  80201c:	eb 11                	jmp    80202f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80201e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802021:	01 45 fc             	add    %eax,-0x4(%rbp)
  802024:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802027:	48 98                	cltq   
  802029:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80202d:	72 ac                	jb     801fdb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80202f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802032:	c9                   	leaveq 
  802033:	c3                   	retq   

0000000000802034 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802034:	55                   	push   %rbp
  802035:	48 89 e5             	mov    %rsp,%rbp
  802038:	48 83 ec 40          	sub    $0x40,%rsp
  80203c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80203f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802043:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802047:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80204b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80204e:	48 89 d6             	mov    %rdx,%rsi
  802051:	89 c7                	mov    %eax,%edi
  802053:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  80205a:	00 00 00 
  80205d:	ff d0                	callq  *%rax
  80205f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802066:	78 24                	js     80208c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206c:	8b 00                	mov    (%rax),%eax
  80206e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802072:	48 89 d6             	mov    %rdx,%rsi
  802075:	89 c7                	mov    %eax,%edi
  802077:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  80207e:	00 00 00 
  802081:	ff d0                	callq  *%rax
  802083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80208a:	79 05                	jns    802091 <write+0x5d>
		return r;
  80208c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80208f:	eb 75                	jmp    802106 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802095:	8b 40 08             	mov    0x8(%rax),%eax
  802098:	83 e0 03             	and    $0x3,%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	75 3a                	jne    8020d9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80209f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020a6:	00 00 00 
  8020a9:	48 8b 00             	mov    (%rax),%rax
  8020ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020b5:	89 c6                	mov    %eax,%esi
  8020b7:	48 bf 73 3b 80 00 00 	movabs $0x803b73,%rdi
  8020be:	00 00 00 
  8020c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c6:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  8020cd:	00 00 00 
  8020d0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020d7:	eb 2d                	jmp    802106 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020e1:	48 85 c0             	test   %rax,%rax
  8020e4:	75 07                	jne    8020ed <write+0xb9>
		return -E_NOT_SUPP;
  8020e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020eb:	eb 19                	jmp    802106 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8020ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020fd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802101:	48 89 cf             	mov    %rcx,%rdi
  802104:	ff d0                	callq  *%rax
}
  802106:	c9                   	leaveq 
  802107:	c3                   	retq   

0000000000802108 <seek>:

int
seek(int fdnum, off_t offset)
{
  802108:	55                   	push   %rbp
  802109:	48 89 e5             	mov    %rsp,%rbp
  80210c:	48 83 ec 18          	sub    $0x18,%rsp
  802110:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802113:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802116:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80211a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80211d:	48 89 d6             	mov    %rdx,%rsi
  802120:	89 c7                	mov    %eax,%edi
  802122:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax
  80212e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802135:	79 05                	jns    80213c <seek+0x34>
		return r;
  802137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213a:	eb 0f                	jmp    80214b <seek+0x43>
	fd->fd_offset = offset;
  80213c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802140:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802143:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214b:	c9                   	leaveq 
  80214c:	c3                   	retq   

000000000080214d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80214d:	55                   	push   %rbp
  80214e:	48 89 e5             	mov    %rsp,%rbp
  802151:	48 83 ec 30          	sub    $0x30,%rsp
  802155:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802158:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80215b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80215f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802162:	48 89 d6             	mov    %rdx,%rsi
  802165:	89 c7                	mov    %eax,%edi
  802167:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  80216e:	00 00 00 
  802171:	ff d0                	callq  *%rax
  802173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217a:	78 24                	js     8021a0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80217c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802180:	8b 00                	mov    (%rax),%eax
  802182:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802186:	48 89 d6             	mov    %rdx,%rsi
  802189:	89 c7                	mov    %eax,%edi
  80218b:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  802192:	00 00 00 
  802195:	ff d0                	callq  *%rax
  802197:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80219a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219e:	79 05                	jns    8021a5 <ftruncate+0x58>
		return r;
  8021a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a3:	eb 72                	jmp    802217 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a9:	8b 40 08             	mov    0x8(%rax),%eax
  8021ac:	83 e0 03             	and    $0x3,%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	75 3a                	jne    8021ed <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8021b3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021ba:	00 00 00 
  8021bd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021c0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021c6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021c9:	89 c6                	mov    %eax,%esi
  8021cb:	48 bf 90 3b 80 00 00 	movabs $0x803b90,%rdi
  8021d2:	00 00 00 
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021da:	48 b9 6e 02 80 00 00 	movabs $0x80026e,%rcx
  8021e1:	00 00 00 
  8021e4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8021e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021eb:	eb 2a                	jmp    802217 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8021ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021f5:	48 85 c0             	test   %rax,%rax
  8021f8:	75 07                	jne    802201 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8021fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021ff:	eb 16                	jmp    802217 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802205:	48 8b 40 30          	mov    0x30(%rax),%rax
  802209:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80220d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802210:	89 ce                	mov    %ecx,%esi
  802212:	48 89 d7             	mov    %rdx,%rdi
  802215:	ff d0                	callq  *%rax
}
  802217:	c9                   	leaveq 
  802218:	c3                   	retq   

0000000000802219 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802219:	55                   	push   %rbp
  80221a:	48 89 e5             	mov    %rsp,%rbp
  80221d:	48 83 ec 30          	sub    $0x30,%rsp
  802221:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802224:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802228:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80222c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80222f:	48 89 d6             	mov    %rdx,%rsi
  802232:	89 c7                	mov    %eax,%edi
  802234:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  80223b:	00 00 00 
  80223e:	ff d0                	callq  *%rax
  802240:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802243:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802247:	78 24                	js     80226d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224d:	8b 00                	mov    (%rax),%eax
  80224f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802253:	48 89 d6             	mov    %rdx,%rsi
  802256:	89 c7                	mov    %eax,%edi
  802258:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
  802264:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802267:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226b:	79 05                	jns    802272 <fstat+0x59>
		return r;
  80226d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802270:	eb 5e                	jmp    8022d0 <fstat+0xb7>
	if (!dev->dev_stat)
  802272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802276:	48 8b 40 28          	mov    0x28(%rax),%rax
  80227a:	48 85 c0             	test   %rax,%rax
  80227d:	75 07                	jne    802286 <fstat+0x6d>
		return -E_NOT_SUPP;
  80227f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802284:	eb 4a                	jmp    8022d0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80228a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80228d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802291:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802298:	00 00 00 
	stat->st_isdir = 0;
  80229b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80229f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8022a6:	00 00 00 
	stat->st_dev = dev;
  8022a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022b1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8022b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022bc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022c8:	48 89 ce             	mov    %rcx,%rsi
  8022cb:	48 89 d7             	mov    %rdx,%rdi
  8022ce:	ff d0                	callq  *%rax
}
  8022d0:	c9                   	leaveq 
  8022d1:	c3                   	retq   

00000000008022d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022d2:	55                   	push   %rbp
  8022d3:	48 89 e5             	mov    %rsp,%rbp
  8022d6:	48 83 ec 20          	sub    $0x20,%rsp
  8022da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e6:	be 00 00 00 00       	mov    $0x0,%esi
  8022eb:	48 89 c7             	mov    %rax,%rdi
  8022ee:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  8022f5:	00 00 00 
  8022f8:	ff d0                	callq  *%rax
  8022fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802301:	79 05                	jns    802308 <stat+0x36>
		return fd;
  802303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802306:	eb 2f                	jmp    802337 <stat+0x65>
	r = fstat(fd, stat);
  802308:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80230c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230f:	48 89 d6             	mov    %rdx,%rsi
  802312:	89 c7                	mov    %eax,%edi
  802314:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  80231b:	00 00 00 
  80231e:	ff d0                	callq  *%rax
  802320:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802326:	89 c7                	mov    %eax,%edi
  802328:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  80232f:	00 00 00 
  802332:	ff d0                	callq  *%rax
	return r;
  802334:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802337:	c9                   	leaveq 
  802338:	c3                   	retq   

0000000000802339 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802339:	55                   	push   %rbp
  80233a:	48 89 e5             	mov    %rsp,%rbp
  80233d:	48 83 ec 10          	sub    $0x10,%rsp
  802341:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802344:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802348:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80234f:	00 00 00 
  802352:	8b 00                	mov    (%rax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	75 1d                	jne    802375 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802358:	bf 01 00 00 00       	mov    $0x1,%edi
  80235d:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  802364:	00 00 00 
  802367:	ff d0                	callq  *%rax
  802369:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802370:	00 00 00 
  802373:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802375:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80237c:	00 00 00 
  80237f:	8b 00                	mov    (%rax),%eax
  802381:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802384:	b9 07 00 00 00       	mov    $0x7,%ecx
  802389:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802390:	00 00 00 
  802393:	89 c7                	mov    %eax,%edi
  802395:	48 b8 6c 34 80 00 00 	movabs $0x80346c,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023aa:	48 89 c6             	mov    %rax,%rsi
  8023ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b2:	48 b8 ab 33 80 00 00 	movabs $0x8033ab,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
}
  8023be:	c9                   	leaveq 
  8023bf:	c3                   	retq   

00000000008023c0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023c0:	55                   	push   %rbp
  8023c1:	48 89 e5             	mov    %rsp,%rbp
  8023c4:	48 83 ec 20          	sub    $0x20,%rsp
  8023c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8023cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d3:	48 89 c7             	mov    %rax,%rdi
  8023d6:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023e7:	7e 0a                	jle    8023f3 <open+0x33>
		return -E_BAD_PATH;
  8023e9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8023ee:	e9 a5 00 00 00       	jmpq   802498 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8023f3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8023f7:	48 89 c7             	mov    %rax,%rdi
  8023fa:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802401:	00 00 00 
  802404:	ff d0                	callq  *%rax
  802406:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802409:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80240d:	79 08                	jns    802417 <open+0x57>
		return r;
  80240f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802412:	e9 81 00 00 00       	jmpq   802498 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802417:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241b:	48 89 c6             	mov    %rax,%rsi
  80241e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802425:	00 00 00 
  802428:	48 b8 36 0e 80 00 00 	movabs $0x800e36,%rax
  80242f:	00 00 00 
  802432:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802434:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80243b:	00 00 00 
  80243e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802441:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244b:	48 89 c6             	mov    %rax,%rsi
  80244e:	bf 01 00 00 00       	mov    $0x1,%edi
  802453:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax
  80245f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802462:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802466:	79 1d                	jns    802485 <open+0xc5>
		fd_close(fd, 0);
  802468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246c:	be 00 00 00 00       	mov    $0x0,%esi
  802471:	48 89 c7             	mov    %rax,%rdi
  802474:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	callq  *%rax
		return r;
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	eb 13                	jmp    802498 <open+0xd8>
	}

	return fd2num(fd);
  802485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802489:	48 89 c7             	mov    %rax,%rdi
  80248c:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  802493:	00 00 00 
  802496:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80249a:	55                   	push   %rbp
  80249b:	48 89 e5             	mov    %rsp,%rbp
  80249e:	48 83 ec 10          	sub    $0x10,%rsp
  8024a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024aa:	8b 50 0c             	mov    0xc(%rax),%edx
  8024ad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024b4:	00 00 00 
  8024b7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8024b9:	be 00 00 00 00       	mov    $0x0,%esi
  8024be:	bf 06 00 00 00       	mov    $0x6,%edi
  8024c3:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	callq  *%rax
}
  8024cf:	c9                   	leaveq 
  8024d0:	c3                   	retq   

00000000008024d1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8024d1:	55                   	push   %rbp
  8024d2:	48 89 e5             	mov    %rsp,%rbp
  8024d5:	48 83 ec 30          	sub    $0x30,%rsp
  8024d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e9:	8b 50 0c             	mov    0xc(%rax),%edx
  8024ec:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024f3:	00 00 00 
  8024f6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8024f8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024ff:	00 00 00 
  802502:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802506:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80250a:	be 00 00 00 00       	mov    $0x0,%esi
  80250f:	bf 03 00 00 00       	mov    $0x3,%edi
  802514:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  80251b:	00 00 00 
  80251e:	ff d0                	callq  *%rax
  802520:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802523:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802527:	79 08                	jns    802531 <devfile_read+0x60>
		return r;
  802529:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252c:	e9 a4 00 00 00       	jmpq   8025d5 <devfile_read+0x104>
	assert(r <= n);
  802531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802534:	48 98                	cltq   
  802536:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80253a:	76 35                	jbe    802571 <devfile_read+0xa0>
  80253c:	48 b9 bd 3b 80 00 00 	movabs $0x803bbd,%rcx
  802543:	00 00 00 
  802546:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  80254d:	00 00 00 
  802550:	be 84 00 00 00       	mov    $0x84,%esi
  802555:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  80255c:	00 00 00 
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
  802564:	49 b8 97 32 80 00 00 	movabs $0x803297,%r8
  80256b:	00 00 00 
  80256e:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802571:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802578:	7e 35                	jle    8025af <devfile_read+0xde>
  80257a:	48 b9 e4 3b 80 00 00 	movabs $0x803be4,%rcx
  802581:	00 00 00 
  802584:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  80258b:	00 00 00 
  80258e:	be 85 00 00 00       	mov    $0x85,%esi
  802593:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  80259a:	00 00 00 
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	49 b8 97 32 80 00 00 	movabs $0x803297,%r8
  8025a9:	00 00 00 
  8025ac:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8025af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b2:	48 63 d0             	movslq %eax,%rdx
  8025b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b9:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8025c0:	00 00 00 
  8025c3:	48 89 c7             	mov    %rax,%rdi
  8025c6:	48 b8 5a 11 80 00 00 	movabs $0x80115a,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
	return r;
  8025d2:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8025d5:	c9                   	leaveq 
  8025d6:	c3                   	retq   

00000000008025d7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8025d7:	55                   	push   %rbp
  8025d8:	48 89 e5             	mov    %rsp,%rbp
  8025db:	48 83 ec 30          	sub    $0x30,%rsp
  8025df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ef:	8b 50 0c             	mov    0xc(%rax),%edx
  8025f2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025f9:	00 00 00 
  8025fc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8025fe:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802605:	00 00 00 
  802608:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80260c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802610:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802617:	00 
  802618:	76 35                	jbe    80264f <devfile_write+0x78>
  80261a:	48 b9 f0 3b 80 00 00 	movabs $0x803bf0,%rcx
  802621:	00 00 00 
  802624:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  80262b:	00 00 00 
  80262e:	be 9e 00 00 00       	mov    $0x9e,%esi
  802633:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  80263a:	00 00 00 
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
  802642:	49 b8 97 32 80 00 00 	movabs $0x803297,%r8
  802649:	00 00 00 
  80264c:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80264f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802653:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802657:	48 89 c6             	mov    %rax,%rsi
  80265a:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802661:	00 00 00 
  802664:	48 b8 71 12 80 00 00 	movabs $0x801271,%rax
  80266b:	00 00 00 
  80266e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802670:	be 00 00 00 00       	mov    $0x0,%esi
  802675:	bf 04 00 00 00       	mov    $0x4,%edi
  80267a:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  802681:	00 00 00 
  802684:	ff d0                	callq  *%rax
  802686:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802689:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268d:	79 05                	jns    802694 <devfile_write+0xbd>
		return r;
  80268f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802692:	eb 43                	jmp    8026d7 <devfile_write+0x100>
	assert(r <= n);
  802694:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802697:	48 98                	cltq   
  802699:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80269d:	76 35                	jbe    8026d4 <devfile_write+0xfd>
  80269f:	48 b9 bd 3b 80 00 00 	movabs $0x803bbd,%rcx
  8026a6:	00 00 00 
  8026a9:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  8026b0:	00 00 00 
  8026b3:	be a2 00 00 00       	mov    $0xa2,%esi
  8026b8:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  8026bf:	00 00 00 
  8026c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c7:	49 b8 97 32 80 00 00 	movabs $0x803297,%r8
  8026ce:	00 00 00 
  8026d1:	41 ff d0             	callq  *%r8
	return r;
  8026d4:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8026d7:	c9                   	leaveq 
  8026d8:	c3                   	retq   

00000000008026d9 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026d9:	55                   	push   %rbp
  8026da:	48 89 e5             	mov    %rsp,%rbp
  8026dd:	48 83 ec 20          	sub    $0x20,%rsp
  8026e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8026e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8026f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026f7:	00 00 00 
  8026fa:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8026fc:	be 00 00 00 00       	mov    $0x0,%esi
  802701:	bf 05 00 00 00       	mov    $0x5,%edi
  802706:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
  802712:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802715:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802719:	79 05                	jns    802720 <devfile_stat+0x47>
		return r;
  80271b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271e:	eb 56                	jmp    802776 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802720:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802724:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80272b:	00 00 00 
  80272e:	48 89 c7             	mov    %rax,%rdi
  802731:	48 b8 36 0e 80 00 00 	movabs $0x800e36,%rax
  802738:	00 00 00 
  80273b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80273d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802744:	00 00 00 
  802747:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80274d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802751:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802757:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80275e:	00 00 00 
  802761:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802767:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80276b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802776:	c9                   	leaveq 
  802777:	c3                   	retq   

0000000000802778 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802778:	55                   	push   %rbp
  802779:	48 89 e5             	mov    %rsp,%rbp
  80277c:	48 83 ec 10          	sub    $0x10,%rsp
  802780:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802784:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80278b:	8b 50 0c             	mov    0xc(%rax),%edx
  80278e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802795:	00 00 00 
  802798:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80279a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027a1:	00 00 00 
  8027a4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027a7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8027aa:	be 00 00 00 00       	mov    $0x0,%esi
  8027af:	bf 02 00 00 00       	mov    $0x2,%edi
  8027b4:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  8027bb:	00 00 00 
  8027be:	ff d0                	callq  *%rax
}
  8027c0:	c9                   	leaveq 
  8027c1:	c3                   	retq   

00000000008027c2 <remove>:

// Delete a file
int
remove(const char *path)
{
  8027c2:	55                   	push   %rbp
  8027c3:	48 89 e5             	mov    %rsp,%rbp
  8027c6:	48 83 ec 10          	sub    $0x10,%rsp
  8027ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8027ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d2:	48 89 c7             	mov    %rax,%rdi
  8027d5:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax
  8027e1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027e6:	7e 07                	jle    8027ef <remove+0x2d>
		return -E_BAD_PATH;
  8027e8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027ed:	eb 33                	jmp    802822 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8027ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f3:	48 89 c6             	mov    %rax,%rsi
  8027f6:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8027fd:	00 00 00 
  802800:	48 b8 36 0e 80 00 00 	movabs $0x800e36,%rax
  802807:	00 00 00 
  80280a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80280c:	be 00 00 00 00       	mov    $0x0,%esi
  802811:	bf 07 00 00 00       	mov    $0x7,%edi
  802816:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  80281d:	00 00 00 
  802820:	ff d0                	callq  *%rax
}
  802822:	c9                   	leaveq 
  802823:	c3                   	retq   

0000000000802824 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802824:	55                   	push   %rbp
  802825:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802828:	be 00 00 00 00       	mov    $0x0,%esi
  80282d:	bf 08 00 00 00       	mov    $0x8,%edi
  802832:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  802839:	00 00 00 
  80283c:	ff d0                	callq  *%rax
}
  80283e:	5d                   	pop    %rbp
  80283f:	c3                   	retq   

0000000000802840 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802840:	55                   	push   %rbp
  802841:	48 89 e5             	mov    %rsp,%rbp
  802844:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80284b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802852:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802859:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802860:	be 00 00 00 00       	mov    $0x0,%esi
  802865:	48 89 c7             	mov    %rax,%rdi
  802868:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
  802874:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802877:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287b:	79 28                	jns    8028a5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80287d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802880:	89 c6                	mov    %eax,%esi
  802882:	48 bf 1d 3c 80 00 00 	movabs $0x803c1d,%rdi
  802889:	00 00 00 
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802898:	00 00 00 
  80289b:	ff d2                	callq  *%rdx
		return fd_src;
  80289d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a0:	e9 74 01 00 00       	jmpq   802a19 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8028a5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8028ac:	be 01 01 00 00       	mov    $0x101,%esi
  8028b1:	48 89 c7             	mov    %rax,%rdi
  8028b4:	48 b8 c0 23 80 00 00 	movabs $0x8023c0,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	callq  *%rax
  8028c0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8028c3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028c7:	79 39                	jns    802902 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8028c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028cc:	89 c6                	mov    %eax,%esi
  8028ce:	48 bf 33 3c 80 00 00 	movabs $0x803c33,%rdi
  8028d5:	00 00 00 
  8028d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028dd:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  8028e4:	00 00 00 
  8028e7:	ff d2                	callq  *%rdx
		close(fd_src);
  8028e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ec:	89 c7                	mov    %eax,%edi
  8028ee:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  8028f5:	00 00 00 
  8028f8:	ff d0                	callq  *%rax
		return fd_dest;
  8028fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028fd:	e9 17 01 00 00       	jmpq   802a19 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802902:	eb 74                	jmp    802978 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802904:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802907:	48 63 d0             	movslq %eax,%rdx
  80290a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802911:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802914:	48 89 ce             	mov    %rcx,%rsi
  802917:	89 c7                	mov    %eax,%edi
  802919:	48 b8 34 20 80 00 00 	movabs $0x802034,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
  802925:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802928:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80292c:	79 4a                	jns    802978 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80292e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802931:	89 c6                	mov    %eax,%esi
  802933:	48 bf 4d 3c 80 00 00 	movabs $0x803c4d,%rdi
  80293a:	00 00 00 
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  802949:	00 00 00 
  80294c:	ff d2                	callq  *%rdx
			close(fd_src);
  80294e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802951:	89 c7                	mov    %eax,%edi
  802953:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  80295a:	00 00 00 
  80295d:	ff d0                	callq  *%rax
			close(fd_dest);
  80295f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802962:	89 c7                	mov    %eax,%edi
  802964:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  80296b:	00 00 00 
  80296e:	ff d0                	callq  *%rax
			return write_size;
  802970:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802973:	e9 a1 00 00 00       	jmpq   802a19 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802978:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80297f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802982:	ba 00 02 00 00       	mov    $0x200,%edx
  802987:	48 89 ce             	mov    %rcx,%rsi
  80298a:	89 c7                	mov    %eax,%edi
  80298c:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  802993:	00 00 00 
  802996:	ff d0                	callq  *%rax
  802998:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80299f:	0f 8f 5f ff ff ff    	jg     802904 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8029a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029a9:	79 47                	jns    8029f2 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8029ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029ae:	89 c6                	mov    %eax,%esi
  8029b0:	48 bf 60 3c 80 00 00 	movabs $0x803c60,%rdi
  8029b7:	00 00 00 
  8029ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bf:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  8029c6:	00 00 00 
  8029c9:	ff d2                	callq  *%rdx
		close(fd_src);
  8029cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ce:	89 c7                	mov    %eax,%edi
  8029d0:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
		close(fd_dest);
  8029dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029df:	89 c7                	mov    %eax,%edi
  8029e1:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
		return read_size;
  8029ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029f0:	eb 27                	jmp    802a19 <copy+0x1d9>
	}
	close(fd_src);
  8029f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f5:	89 c7                	mov    %eax,%edi
  8029f7:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  8029fe:	00 00 00 
  802a01:	ff d0                	callq  *%rax
	close(fd_dest);
  802a03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a06:	89 c7                	mov    %eax,%edi
  802a08:	48 b8 c8 1c 80 00 00 	movabs $0x801cc8,%rax
  802a0f:	00 00 00 
  802a12:	ff d0                	callq  *%rax
	return 0;
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802a19:	c9                   	leaveq 
  802a1a:	c3                   	retq   

0000000000802a1b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a1b:	55                   	push   %rbp
  802a1c:	48 89 e5             	mov    %rsp,%rbp
  802a1f:	53                   	push   %rbx
  802a20:	48 83 ec 38          	sub    $0x38,%rsp
  802a24:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a28:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a2c:	48 89 c7             	mov    %rax,%rdi
  802a2f:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802a36:	00 00 00 
  802a39:	ff d0                	callq  *%rax
  802a3b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a42:	0f 88 bf 01 00 00    	js     802c07 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a4c:	ba 07 04 00 00       	mov    $0x407,%edx
  802a51:	48 89 c6             	mov    %rax,%rsi
  802a54:	bf 00 00 00 00       	mov    $0x0,%edi
  802a59:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  802a60:	00 00 00 
  802a63:	ff d0                	callq  *%rax
  802a65:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a68:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a6c:	0f 88 95 01 00 00    	js     802c07 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802a72:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802a76:	48 89 c7             	mov    %rax,%rdi
  802a79:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802a80:	00 00 00 
  802a83:	ff d0                	callq  *%rax
  802a85:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a88:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a8c:	0f 88 5d 01 00 00    	js     802bef <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a96:	ba 07 04 00 00       	mov    $0x407,%edx
  802a9b:	48 89 c6             	mov    %rax,%rsi
  802a9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa3:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  802aaa:	00 00 00 
  802aad:	ff d0                	callq  *%rax
  802aaf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ab2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ab6:	0f 88 33 01 00 00    	js     802bef <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802abc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac0:	48 89 c7             	mov    %rax,%rdi
  802ac3:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
  802acf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ad3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad7:	ba 07 04 00 00       	mov    $0x407,%edx
  802adc:	48 89 c6             	mov    %rax,%rsi
  802adf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae4:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	callq  *%rax
  802af0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802af3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802af7:	79 05                	jns    802afe <pipe+0xe3>
		goto err2;
  802af9:	e9 d9 00 00 00       	jmpq   802bd7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802afe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b02:	48 89 c7             	mov    %rax,%rdi
  802b05:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
  802b11:	48 89 c2             	mov    %rax,%rdx
  802b14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b18:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b1e:	48 89 d1             	mov    %rdx,%rcx
  802b21:	ba 00 00 00 00       	mov    $0x0,%edx
  802b26:	48 89 c6             	mov    %rax,%rsi
  802b29:	bf 00 00 00 00       	mov    $0x0,%edi
  802b2e:	48 b8 b5 17 80 00 00 	movabs $0x8017b5,%rax
  802b35:	00 00 00 
  802b38:	ff d0                	callq  *%rax
  802b3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b41:	79 1b                	jns    802b5e <pipe+0x143>
		goto err3;
  802b43:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b48:	48 89 c6             	mov    %rax,%rsi
  802b4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b50:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
  802b5c:	eb 79                	jmp    802bd7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b62:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b69:	00 00 00 
  802b6c:	8b 12                	mov    (%rdx),%edx
  802b6e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b7f:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b86:	00 00 00 
  802b89:	8b 12                	mov    (%rdx),%edx
  802b8b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802b8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b91:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802b98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b9c:	48 89 c7             	mov    %rax,%rdi
  802b9f:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
  802bab:	89 c2                	mov    %eax,%edx
  802bad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bb1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802bb3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bb7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802bbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bbf:	48 89 c7             	mov    %rax,%rdi
  802bc2:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  802bc9:	00 00 00 
  802bcc:	ff d0                	callq  *%rax
  802bce:	89 03                	mov    %eax,(%rbx)
	return 0;
  802bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd5:	eb 33                	jmp    802c0a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802bd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bdb:	48 89 c6             	mov    %rax,%rsi
  802bde:	bf 00 00 00 00       	mov    $0x0,%edi
  802be3:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802bef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf3:	48 89 c6             	mov    %rax,%rsi
  802bf6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bfb:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	callq  *%rax
err:
	return r;
  802c07:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c0a:	48 83 c4 38          	add    $0x38,%rsp
  802c0e:	5b                   	pop    %rbx
  802c0f:	5d                   	pop    %rbp
  802c10:	c3                   	retq   

0000000000802c11 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c11:	55                   	push   %rbp
  802c12:	48 89 e5             	mov    %rsp,%rbp
  802c15:	53                   	push   %rbx
  802c16:	48 83 ec 28          	sub    $0x28,%rsp
  802c1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c1e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c22:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c29:	00 00 00 
  802c2c:	48 8b 00             	mov    (%rax),%rax
  802c2f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c35:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c3c:	48 89 c7             	mov    %rax,%rdi
  802c3f:	48 b8 86 35 80 00 00 	movabs $0x803586,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
  802c4b:	89 c3                	mov    %eax,%ebx
  802c4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c51:	48 89 c7             	mov    %rax,%rdi
  802c54:	48 b8 86 35 80 00 00 	movabs $0x803586,%rax
  802c5b:	00 00 00 
  802c5e:	ff d0                	callq  *%rax
  802c60:	39 c3                	cmp    %eax,%ebx
  802c62:	0f 94 c0             	sete   %al
  802c65:	0f b6 c0             	movzbl %al,%eax
  802c68:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802c6b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c72:	00 00 00 
  802c75:	48 8b 00             	mov    (%rax),%rax
  802c78:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c7e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802c81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c84:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c87:	75 05                	jne    802c8e <_pipeisclosed+0x7d>
			return ret;
  802c89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c8c:	eb 4f                	jmp    802cdd <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802c8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c91:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c94:	74 42                	je     802cd8 <_pipeisclosed+0xc7>
  802c96:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802c9a:	75 3c                	jne    802cd8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c9c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ca3:	00 00 00 
  802ca6:	48 8b 00             	mov    (%rax),%rax
  802ca9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802caf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802cb2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cb5:	89 c6                	mov    %eax,%esi
  802cb7:	48 bf 7b 3c 80 00 00 	movabs $0x803c7b,%rdi
  802cbe:	00 00 00 
  802cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc6:	49 b8 6e 02 80 00 00 	movabs $0x80026e,%r8
  802ccd:	00 00 00 
  802cd0:	41 ff d0             	callq  *%r8
	}
  802cd3:	e9 4a ff ff ff       	jmpq   802c22 <_pipeisclosed+0x11>
  802cd8:	e9 45 ff ff ff       	jmpq   802c22 <_pipeisclosed+0x11>
}
  802cdd:	48 83 c4 28          	add    $0x28,%rsp
  802ce1:	5b                   	pop    %rbx
  802ce2:	5d                   	pop    %rbp
  802ce3:	c3                   	retq   

0000000000802ce4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802ce4:	55                   	push   %rbp
  802ce5:	48 89 e5             	mov    %rsp,%rbp
  802ce8:	48 83 ec 30          	sub    $0x30,%rsp
  802cec:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cf3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf6:	48 89 d6             	mov    %rdx,%rsi
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
  802d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0e:	79 05                	jns    802d15 <pipeisclosed+0x31>
		return r;
  802d10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d13:	eb 31                	jmp    802d46 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d19:	48 89 c7             	mov    %rax,%rdi
  802d1c:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  802d23:	00 00 00 
  802d26:	ff d0                	callq  *%rax
  802d28:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d34:	48 89 d6             	mov    %rdx,%rsi
  802d37:	48 89 c7             	mov    %rax,%rdi
  802d3a:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802d41:	00 00 00 
  802d44:	ff d0                	callq  *%rax
}
  802d46:	c9                   	leaveq 
  802d47:	c3                   	retq   

0000000000802d48 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d48:	55                   	push   %rbp
  802d49:	48 89 e5             	mov    %rsp,%rbp
  802d4c:	48 83 ec 40          	sub    $0x40,%rsp
  802d50:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d54:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d58:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d60:	48 89 c7             	mov    %rax,%rdi
  802d63:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802d73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d7b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d82:	00 
  802d83:	e9 92 00 00 00       	jmpq   802e1a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802d88:	eb 41                	jmp    802dcb <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d8a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802d8f:	74 09                	je     802d9a <devpipe_read+0x52>
				return i;
  802d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d95:	e9 92 00 00 00       	jmpq   802e2c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da2:	48 89 d6             	mov    %rdx,%rsi
  802da5:	48 89 c7             	mov    %rax,%rdi
  802da8:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
  802db4:	85 c0                	test   %eax,%eax
  802db6:	74 07                	je     802dbf <devpipe_read+0x77>
				return 0;
  802db8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbd:	eb 6d                	jmp    802e2c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802dbf:	48 b8 27 17 80 00 00 	movabs $0x801727,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	8b 10                	mov    (%rax),%edx
  802dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd5:	8b 40 04             	mov    0x4(%rax),%eax
  802dd8:	39 c2                	cmp    %eax,%edx
  802dda:	74 ae                	je     802d8a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ddc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802de4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802de8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dec:	8b 00                	mov    (%rax),%eax
  802dee:	99                   	cltd   
  802def:	c1 ea 1b             	shr    $0x1b,%edx
  802df2:	01 d0                	add    %edx,%eax
  802df4:	83 e0 1f             	and    $0x1f,%eax
  802df7:	29 d0                	sub    %edx,%eax
  802df9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dfd:	48 98                	cltq   
  802dff:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e04:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0a:	8b 00                	mov    (%rax),%eax
  802e0c:	8d 50 01             	lea    0x1(%rax),%edx
  802e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e13:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e15:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e22:	0f 82 60 ff ff ff    	jb     802d88 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e2c:	c9                   	leaveq 
  802e2d:	c3                   	retq   

0000000000802e2e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e2e:	55                   	push   %rbp
  802e2f:	48 89 e5             	mov    %rsp,%rbp
  802e32:	48 83 ec 40          	sub    $0x40,%rsp
  802e36:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e3a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e3e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e46:	48 89 c7             	mov    %rax,%rdi
  802e49:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
  802e55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802e59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802e61:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802e68:	00 
  802e69:	e9 8e 00 00 00       	jmpq   802efc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e6e:	eb 31                	jmp    802ea1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802e70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e78:	48 89 d6             	mov    %rdx,%rsi
  802e7b:	48 89 c7             	mov    %rax,%rdi
  802e7e:	48 b8 11 2c 80 00 00 	movabs $0x802c11,%rax
  802e85:	00 00 00 
  802e88:	ff d0                	callq  *%rax
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	74 07                	je     802e95 <devpipe_write+0x67>
				return 0;
  802e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e93:	eb 79                	jmp    802f0e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802e95:	48 b8 27 17 80 00 00 	movabs $0x801727,%rax
  802e9c:	00 00 00 
  802e9f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea5:	8b 40 04             	mov    0x4(%rax),%eax
  802ea8:	48 63 d0             	movslq %eax,%rdx
  802eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eaf:	8b 00                	mov    (%rax),%eax
  802eb1:	48 98                	cltq   
  802eb3:	48 83 c0 20          	add    $0x20,%rax
  802eb7:	48 39 c2             	cmp    %rax,%rdx
  802eba:	73 b4                	jae    802e70 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ebc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec0:	8b 40 04             	mov    0x4(%rax),%eax
  802ec3:	99                   	cltd   
  802ec4:	c1 ea 1b             	shr    $0x1b,%edx
  802ec7:	01 d0                	add    %edx,%eax
  802ec9:	83 e0 1f             	and    $0x1f,%eax
  802ecc:	29 d0                	sub    %edx,%eax
  802ece:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ed2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ed6:	48 01 ca             	add    %rcx,%rdx
  802ed9:	0f b6 0a             	movzbl (%rdx),%ecx
  802edc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ee0:	48 98                	cltq   
  802ee2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802ee6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eea:	8b 40 04             	mov    0x4(%rax),%eax
  802eed:	8d 50 01             	lea    0x1(%rax),%edx
  802ef0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ef7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802efc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f00:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f04:	0f 82 64 ff ff ff    	jb     802e6e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f0e:	c9                   	leaveq 
  802f0f:	c3                   	retq   

0000000000802f10 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f10:	55                   	push   %rbp
  802f11:	48 89 e5             	mov    %rsp,%rbp
  802f14:	48 83 ec 20          	sub    $0x20,%rsp
  802f18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f24:	48 89 c7             	mov    %rax,%rdi
  802f27:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f3b:	48 be 8e 3c 80 00 00 	movabs $0x803c8e,%rsi
  802f42:	00 00 00 
  802f45:	48 89 c7             	mov    %rax,%rdi
  802f48:	48 b8 36 0e 80 00 00 	movabs $0x800e36,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f58:	8b 50 04             	mov    0x4(%rax),%edx
  802f5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5f:	8b 00                	mov    (%rax),%eax
  802f61:	29 c2                	sub    %eax,%edx
  802f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f67:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802f6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f71:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f78:	00 00 00 
	stat->st_dev = &devpipe;
  802f7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7f:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802f86:	00 00 00 
  802f89:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802f90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f95:	c9                   	leaveq 
  802f96:	c3                   	retq   

0000000000802f97 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802f97:	55                   	push   %rbp
  802f98:	48 89 e5             	mov    %rsp,%rbp
  802f9b:	48 83 ec 10          	sub    $0x10,%rsp
  802f9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa7:	48 89 c6             	mov    %rax,%rsi
  802faa:	bf 00 00 00 00       	mov    $0x0,%edi
  802faf:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802fbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fbf:	48 89 c7             	mov    %rax,%rdi
  802fc2:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
  802fce:	48 89 c6             	mov    %rax,%rsi
  802fd1:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd6:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
}
  802fe2:	c9                   	leaveq 
  802fe3:	c3                   	retq   

0000000000802fe4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802fe4:	55                   	push   %rbp
  802fe5:	48 89 e5             	mov    %rsp,%rbp
  802fe8:	48 83 ec 20          	sub    $0x20,%rsp
  802fec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802fef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ff5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802ff9:	be 01 00 00 00       	mov    $0x1,%esi
  802ffe:	48 89 c7             	mov    %rax,%rdi
  803001:	48 b8 1d 16 80 00 00 	movabs $0x80161d,%rax
  803008:	00 00 00 
  80300b:	ff d0                	callq  *%rax
}
  80300d:	c9                   	leaveq 
  80300e:	c3                   	retq   

000000000080300f <getchar>:

int
getchar(void)
{
  80300f:	55                   	push   %rbp
  803010:	48 89 e5             	mov    %rsp,%rbp
  803013:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803017:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80301b:	ba 01 00 00 00       	mov    $0x1,%edx
  803020:	48 89 c6             	mov    %rax,%rsi
  803023:	bf 00 00 00 00       	mov    $0x0,%edi
  803028:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303b:	79 05                	jns    803042 <getchar+0x33>
		return r;
  80303d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803040:	eb 14                	jmp    803056 <getchar+0x47>
	if (r < 1)
  803042:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803046:	7f 07                	jg     80304f <getchar+0x40>
		return -E_EOF;
  803048:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80304d:	eb 07                	jmp    803056 <getchar+0x47>
	return c;
  80304f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803053:	0f b6 c0             	movzbl %al,%eax
}
  803056:	c9                   	leaveq 
  803057:	c3                   	retq   

0000000000803058 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803058:	55                   	push   %rbp
  803059:	48 89 e5             	mov    %rsp,%rbp
  80305c:	48 83 ec 20          	sub    $0x20,%rsp
  803060:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803063:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803067:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80306a:	48 89 d6             	mov    %rdx,%rsi
  80306d:	89 c7                	mov    %eax,%edi
  80306f:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
  80307b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80307e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803082:	79 05                	jns    803089 <iscons+0x31>
		return r;
  803084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803087:	eb 1a                	jmp    8030a3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308d:	8b 10                	mov    (%rax),%edx
  80308f:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803096:	00 00 00 
  803099:	8b 00                	mov    (%rax),%eax
  80309b:	39 c2                	cmp    %eax,%edx
  80309d:	0f 94 c0             	sete   %al
  8030a0:	0f b6 c0             	movzbl %al,%eax
}
  8030a3:	c9                   	leaveq 
  8030a4:	c3                   	retq   

00000000008030a5 <opencons>:

int
opencons(void)
{
  8030a5:	55                   	push   %rbp
  8030a6:	48 89 e5             	mov    %rsp,%rbp
  8030a9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8030ad:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030b1:	48 89 c7             	mov    %rax,%rdi
  8030b4:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c7:	79 05                	jns    8030ce <opencons+0x29>
		return r;
  8030c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cc:	eb 5b                	jmp    803129 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8030ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d2:	ba 07 04 00 00       	mov    $0x407,%edx
  8030d7:	48 89 c6             	mov    %rax,%rsi
  8030da:	bf 00 00 00 00       	mov    $0x0,%edi
  8030df:	48 b8 65 17 80 00 00 	movabs $0x801765,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
  8030eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f2:	79 05                	jns    8030f9 <opencons+0x54>
		return r;
  8030f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f7:	eb 30                	jmp    803129 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8030f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fd:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803104:	00 00 00 
  803107:	8b 12                	mov    (%rdx),%edx
  803109:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80310b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80310f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311a:	48 89 c7             	mov    %rax,%rdi
  80311d:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  803124:	00 00 00 
  803127:	ff d0                	callq  *%rax
}
  803129:	c9                   	leaveq 
  80312a:	c3                   	retq   

000000000080312b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80312b:	55                   	push   %rbp
  80312c:	48 89 e5             	mov    %rsp,%rbp
  80312f:	48 83 ec 30          	sub    $0x30,%rsp
  803133:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803137:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80313b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80313f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803144:	75 07                	jne    80314d <devcons_read+0x22>
		return 0;
  803146:	b8 00 00 00 00       	mov    $0x0,%eax
  80314b:	eb 4b                	jmp    803198 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80314d:	eb 0c                	jmp    80315b <devcons_read+0x30>
		sys_yield();
  80314f:	48 b8 27 17 80 00 00 	movabs $0x801727,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80315b:	48 b8 67 16 80 00 00 	movabs $0x801667,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
  803167:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80316a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316e:	74 df                	je     80314f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803174:	79 05                	jns    80317b <devcons_read+0x50>
		return c;
  803176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803179:	eb 1d                	jmp    803198 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80317b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80317f:	75 07                	jne    803188 <devcons_read+0x5d>
		return 0;
  803181:	b8 00 00 00 00       	mov    $0x0,%eax
  803186:	eb 10                	jmp    803198 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318b:	89 c2                	mov    %eax,%edx
  80318d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803191:	88 10                	mov    %dl,(%rax)
	return 1;
  803193:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803198:	c9                   	leaveq 
  803199:	c3                   	retq   

000000000080319a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80319a:	55                   	push   %rbp
  80319b:	48 89 e5             	mov    %rsp,%rbp
  80319e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8031a5:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8031ac:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8031b3:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8031ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031c1:	eb 76                	jmp    803239 <devcons_write+0x9f>
		m = n - tot;
  8031c3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8031ca:	89 c2                	mov    %eax,%edx
  8031cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cf:	29 c2                	sub    %eax,%edx
  8031d1:	89 d0                	mov    %edx,%eax
  8031d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8031d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031d9:	83 f8 7f             	cmp    $0x7f,%eax
  8031dc:	76 07                	jbe    8031e5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8031de:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8031e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e8:	48 63 d0             	movslq %eax,%rdx
  8031eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ee:	48 63 c8             	movslq %eax,%rcx
  8031f1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8031f8:	48 01 c1             	add    %rax,%rcx
  8031fb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803202:	48 89 ce             	mov    %rcx,%rsi
  803205:	48 89 c7             	mov    %rax,%rdi
  803208:	48 b8 5a 11 80 00 00 	movabs $0x80115a,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803214:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803217:	48 63 d0             	movslq %eax,%rdx
  80321a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803221:	48 89 d6             	mov    %rdx,%rsi
  803224:	48 89 c7             	mov    %rax,%rdi
  803227:	48 b8 1d 16 80 00 00 	movabs $0x80161d,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803233:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803236:	01 45 fc             	add    %eax,-0x4(%rbp)
  803239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323c:	48 98                	cltq   
  80323e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803245:	0f 82 78 ff ff ff    	jb     8031c3 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80324b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80324e:	c9                   	leaveq 
  80324f:	c3                   	retq   

0000000000803250 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803250:	55                   	push   %rbp
  803251:	48 89 e5             	mov    %rsp,%rbp
  803254:	48 83 ec 08          	sub    $0x8,%rsp
  803258:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80325c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803261:	c9                   	leaveq 
  803262:	c3                   	retq   

0000000000803263 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803263:	55                   	push   %rbp
  803264:	48 89 e5             	mov    %rsp,%rbp
  803267:	48 83 ec 10          	sub    $0x10,%rsp
  80326b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80326f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803277:	48 be 9a 3c 80 00 00 	movabs $0x803c9a,%rsi
  80327e:	00 00 00 
  803281:	48 89 c7             	mov    %rax,%rdi
  803284:	48 b8 36 0e 80 00 00 	movabs $0x800e36,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
	return 0;
  803290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	53                   	push   %rbx
  80329c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8032a3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8032aa:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8032b0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8032b7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8032be:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8032c5:	84 c0                	test   %al,%al
  8032c7:	74 23                	je     8032ec <_panic+0x55>
  8032c9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8032d0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8032d4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8032d8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8032dc:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8032e0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8032e4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8032e8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8032ec:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8032f3:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8032fa:	00 00 00 
  8032fd:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803304:	00 00 00 
  803307:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80330b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803312:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803319:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803320:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803327:	00 00 00 
  80332a:	48 8b 18             	mov    (%rax),%rbx
  80332d:	48 b8 e9 16 80 00 00 	movabs $0x8016e9,%rax
  803334:	00 00 00 
  803337:	ff d0                	callq  *%rax
  803339:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80333f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803346:	41 89 c8             	mov    %ecx,%r8d
  803349:	48 89 d1             	mov    %rdx,%rcx
  80334c:	48 89 da             	mov    %rbx,%rdx
  80334f:	89 c6                	mov    %eax,%esi
  803351:	48 bf a8 3c 80 00 00 	movabs $0x803ca8,%rdi
  803358:	00 00 00 
  80335b:	b8 00 00 00 00       	mov    $0x0,%eax
  803360:	49 b9 6e 02 80 00 00 	movabs $0x80026e,%r9
  803367:	00 00 00 
  80336a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80336d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803374:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80337b:	48 89 d6             	mov    %rdx,%rsi
  80337e:	48 89 c7             	mov    %rax,%rdi
  803381:	48 b8 c2 01 80 00 00 	movabs $0x8001c2,%rax
  803388:	00 00 00 
  80338b:	ff d0                	callq  *%rax
	cprintf("\n");
  80338d:	48 bf cb 3c 80 00 00 	movabs $0x803ccb,%rdi
  803394:	00 00 00 
  803397:	b8 00 00 00 00       	mov    $0x0,%eax
  80339c:	48 ba 6e 02 80 00 00 	movabs $0x80026e,%rdx
  8033a3:	00 00 00 
  8033a6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8033a8:	cc                   	int3   
  8033a9:	eb fd                	jmp    8033a8 <_panic+0x111>

00000000008033ab <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033ab:	55                   	push   %rbp
  8033ac:	48 89 e5             	mov    %rsp,%rbp
  8033af:	48 83 ec 30          	sub    $0x30,%rsp
  8033b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8033bf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033c4:	75 0e                	jne    8033d4 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033cd:	00 00 00 
  8033d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d8:	48 89 c7             	mov    %rax,%rdi
  8033db:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ee:	79 27                	jns    803417 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033f5:	74 0a                	je     803401 <ipc_recv+0x56>
            *from_env_store = 0;
  8033f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803401:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803406:	74 0a                	je     803412 <ipc_recv+0x67>
            *perm_store = 0;
  803408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803412:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803415:	eb 53                	jmp    80346a <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803417:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80341c:	74 19                	je     803437 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80341e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803425:	00 00 00 
  803428:	48 8b 00             	mov    (%rax),%rax
  80342b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803435:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803437:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80343c:	74 19                	je     803457 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80343e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803445:	00 00 00 
  803448:	48 8b 00             	mov    (%rax),%rax
  80344b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803455:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803457:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80345e:	00 00 00 
  803461:	48 8b 00             	mov    (%rax),%rax
  803464:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80346a:	c9                   	leaveq 
  80346b:	c3                   	retq   

000000000080346c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80346c:	55                   	push   %rbp
  80346d:	48 89 e5             	mov    %rsp,%rbp
  803470:	48 83 ec 30          	sub    $0x30,%rsp
  803474:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803477:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80347a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80347e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803481:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803486:	75 0e                	jne    803496 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803488:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80348f:	00 00 00 
  803492:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803496:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803499:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80349c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034a3:	89 c7                	mov    %eax,%edi
  8034a5:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
  8034b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8034b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b8:	79 36                	jns    8034f0 <ipc_send+0x84>
  8034ba:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034be:	74 30                	je     8034f0 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8034c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c3:	89 c1                	mov    %eax,%ecx
  8034c5:	48 ba cd 3c 80 00 00 	movabs $0x803ccd,%rdx
  8034cc:	00 00 00 
  8034cf:	be 49 00 00 00       	mov    $0x49,%esi
  8034d4:	48 bf da 3c 80 00 00 	movabs $0x803cda,%rdi
  8034db:	00 00 00 
  8034de:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e3:	49 b8 97 32 80 00 00 	movabs $0x803297,%r8
  8034ea:	00 00 00 
  8034ed:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034f0:	48 b8 27 17 80 00 00 	movabs $0x801727,%rax
  8034f7:	00 00 00 
  8034fa:	ff d0                	callq  *%rax
    } while(r != 0);
  8034fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803500:	75 94                	jne    803496 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803502:	c9                   	leaveq 
  803503:	c3                   	retq   

0000000000803504 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803504:	55                   	push   %rbp
  803505:	48 89 e5             	mov    %rsp,%rbp
  803508:	48 83 ec 14          	sub    $0x14,%rsp
  80350c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80350f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803516:	eb 5e                	jmp    803576 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803518:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80351f:	00 00 00 
  803522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803525:	48 63 d0             	movslq %eax,%rdx
  803528:	48 89 d0             	mov    %rdx,%rax
  80352b:	48 c1 e0 03          	shl    $0x3,%rax
  80352f:	48 01 d0             	add    %rdx,%rax
  803532:	48 c1 e0 05          	shl    $0x5,%rax
  803536:	48 01 c8             	add    %rcx,%rax
  803539:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80353f:	8b 00                	mov    (%rax),%eax
  803541:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803544:	75 2c                	jne    803572 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803546:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80354d:	00 00 00 
  803550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803553:	48 63 d0             	movslq %eax,%rdx
  803556:	48 89 d0             	mov    %rdx,%rax
  803559:	48 c1 e0 03          	shl    $0x3,%rax
  80355d:	48 01 d0             	add    %rdx,%rax
  803560:	48 c1 e0 05          	shl    $0x5,%rax
  803564:	48 01 c8             	add    %rcx,%rax
  803567:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80356d:	8b 40 08             	mov    0x8(%rax),%eax
  803570:	eb 12                	jmp    803584 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803572:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803576:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80357d:	7e 99                	jle    803518 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80357f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803584:	c9                   	leaveq 
  803585:	c3                   	retq   

0000000000803586 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803586:	55                   	push   %rbp
  803587:	48 89 e5             	mov    %rsp,%rbp
  80358a:	48 83 ec 18          	sub    $0x18,%rsp
  80358e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803596:	48 c1 e8 15          	shr    $0x15,%rax
  80359a:	48 89 c2             	mov    %rax,%rdx
  80359d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8035a4:	01 00 00 
  8035a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ab:	83 e0 01             	and    $0x1,%eax
  8035ae:	48 85 c0             	test   %rax,%rax
  8035b1:	75 07                	jne    8035ba <pageref+0x34>
		return 0;
  8035b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b8:	eb 53                	jmp    80360d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8035ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035be:	48 c1 e8 0c          	shr    $0xc,%rax
  8035c2:	48 89 c2             	mov    %rax,%rdx
  8035c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035cc:	01 00 00 
  8035cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035db:	83 e0 01             	and    $0x1,%eax
  8035de:	48 85 c0             	test   %rax,%rax
  8035e1:	75 07                	jne    8035ea <pageref+0x64>
		return 0;
  8035e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e8:	eb 23                	jmp    80360d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8035f2:	48 89 c2             	mov    %rax,%rdx
  8035f5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035fc:	00 00 00 
  8035ff:	48 c1 e2 04          	shl    $0x4,%rdx
  803603:	48 01 d0             	add    %rdx,%rax
  803606:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80360a:	0f b7 c0             	movzwl %ax,%eax
}
  80360d:	c9                   	leaveq 
  80360e:	c3                   	retq   
