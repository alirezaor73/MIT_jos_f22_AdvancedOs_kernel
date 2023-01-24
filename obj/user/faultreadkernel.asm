
obj/user/faultreadkernel:     file format elf64-x86-64


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
  80003c:	e8 3c 00 00 00       	callq  80007d <libmain>
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
	cprintf("I read %08x from location 0x8004000000!\n", *(unsigned*)0x8004000000);
  800052:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  800059:	00 00 00 
  80005c:	8b 00                	mov    (%rax),%eax
  80005e:	89 c6                	mov    %eax,%esi
  800060:	48 bf 00 18 80 00 00 	movabs $0x801800,%rdi
  800067:	00 00 00 
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 ba 19 02 80 00 00 	movabs $0x800219,%rdx
  800076:	00 00 00 
  800079:	ff d2                	callq  *%rdx
}
  80007b:	c9                   	leaveq 
  80007c:	c3                   	retq   

000000000080007d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007d:	55                   	push   %rbp
  80007e:	48 89 e5             	mov    %rsp,%rbp
  800081:	48 83 ec 10          	sub    $0x10,%rsp
  800085:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800088:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80008c:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800093:	00 00 00 
  800096:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000a1:	7e 14                	jle    8000b7 <libmain+0x3a>
		binaryname = argv[0];
  8000a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000a7:	48 8b 10             	mov    (%rax),%rdx
  8000aa:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000b1:	00 00 00 
  8000b4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000be:	48 89 d6             	mov    %rdx,%rsi
  8000c1:	89 c7                	mov    %eax,%edi
  8000c3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ca:	00 00 00 
  8000cd:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000cf:	48 b8 dd 00 80 00 00 	movabs $0x8000dd,%rax
  8000d6:	00 00 00 
  8000d9:	ff d0                	callq  *%rax
}
  8000db:	c9                   	leaveq 
  8000dc:	c3                   	retq   

00000000008000dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000dd:	55                   	push   %rbp
  8000de:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8000e6:	48 b8 50 16 80 00 00 	movabs $0x801650,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	callq  *%rax
}
  8000f2:	5d                   	pop    %rbp
  8000f3:	c3                   	retq   

00000000008000f4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8000f4:	55                   	push   %rbp
  8000f5:	48 89 e5             	mov    %rsp,%rbp
  8000f8:	48 83 ec 10          	sub    $0x10,%rsp
  8000fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800107:	8b 00                	mov    (%rax),%eax
  800109:	8d 48 01             	lea    0x1(%rax),%ecx
  80010c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800110:	89 0a                	mov    %ecx,(%rdx)
  800112:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800115:	89 d1                	mov    %edx,%ecx
  800117:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80011b:	48 98                	cltq   
  80011d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800125:	8b 00                	mov    (%rax),%eax
  800127:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012c:	75 2c                	jne    80015a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80012e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800132:	8b 00                	mov    (%rax),%eax
  800134:	48 98                	cltq   
  800136:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80013a:	48 83 c2 08          	add    $0x8,%rdx
  80013e:	48 89 c6             	mov    %rax,%rsi
  800141:	48 89 d7             	mov    %rdx,%rdi
  800144:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
        b->idx = 0;
  800150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800154:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80015a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015e:	8b 40 04             	mov    0x4(%rax),%eax
  800161:	8d 50 01             	lea    0x1(%rax),%edx
  800164:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800168:	89 50 04             	mov    %edx,0x4(%rax)
}
  80016b:	c9                   	leaveq 
  80016c:	c3                   	retq   

000000000080016d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80016d:	55                   	push   %rbp
  80016e:	48 89 e5             	mov    %rsp,%rbp
  800171:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800178:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80017f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800186:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80018d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800194:	48 8b 0a             	mov    (%rdx),%rcx
  800197:	48 89 08             	mov    %rcx,(%rax)
  80019a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80019e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001a2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001a6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001aa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001b1:	00 00 00 
    b.cnt = 0;
  8001b4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001bb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001be:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001c5:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001cc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001d3:	48 89 c6             	mov    %rax,%rsi
  8001d6:	48 bf f4 00 80 00 00 	movabs $0x8000f4,%rdi
  8001dd:	00 00 00 
  8001e0:	48 b8 cc 05 80 00 00 	movabs $0x8005cc,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8001ec:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8001f2:	48 98                	cltq   
  8001f4:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8001fb:	48 83 c2 08          	add    $0x8,%rdx
  8001ff:	48 89 c6             	mov    %rax,%rsi
  800202:	48 89 d7             	mov    %rdx,%rdi
  800205:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  80020c:	00 00 00 
  80020f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800211:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800217:	c9                   	leaveq 
  800218:	c3                   	retq   

0000000000800219 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800219:	55                   	push   %rbp
  80021a:	48 89 e5             	mov    %rsp,%rbp
  80021d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800224:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80022b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800232:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800239:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800240:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800247:	84 c0                	test   %al,%al
  800249:	74 20                	je     80026b <cprintf+0x52>
  80024b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80024f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800253:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800257:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80025b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80025f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800263:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800267:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80026b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800272:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800279:	00 00 00 
  80027c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800283:	00 00 00 
  800286:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80028a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800291:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800298:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80029f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002a6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002ad:	48 8b 0a             	mov    (%rdx),%rcx
  8002b0:	48 89 08             	mov    %rcx,(%rax)
  8002b3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002b7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002bb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002bf:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002c3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002ca:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002d1:	48 89 d6             	mov    %rdx,%rsi
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 6d 01 80 00 00 	movabs $0x80016d,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8002e9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8002ef:	c9                   	leaveq 
  8002f0:	c3                   	retq   

00000000008002f1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f1:	55                   	push   %rbp
  8002f2:	48 89 e5             	mov    %rsp,%rbp
  8002f5:	53                   	push   %rbx
  8002f6:	48 83 ec 38          	sub    $0x38,%rsp
  8002fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800302:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800306:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800309:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80030d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800311:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800314:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800318:	77 3b                	ja     800355 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80031a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80031d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800321:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800324:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800328:	ba 00 00 00 00       	mov    $0x0,%edx
  80032d:	48 f7 f3             	div    %rbx
  800330:	48 89 c2             	mov    %rax,%rdx
  800333:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800336:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800339:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80033d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800341:	41 89 f9             	mov    %edi,%r9d
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 f1 02 80 00 00 	movabs $0x8002f1,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
  800353:	eb 1e                	jmp    800373 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800355:	eb 12                	jmp    800369 <printnum+0x78>
			putch(padc, putdat);
  800357:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80035b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80035e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800362:	48 89 ce             	mov    %rcx,%rsi
  800365:	89 d7                	mov    %edx,%edi
  800367:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800369:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80036d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800371:	7f e4                	jg     800357 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800373:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80037a:	ba 00 00 00 00       	mov    $0x0,%edx
  80037f:	48 f7 f1             	div    %rcx
  800382:	48 89 d0             	mov    %rdx,%rax
  800385:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
  80038c:	00 00 00 
  80038f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800393:	0f be d0             	movsbl %al,%edx
  800396:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80039a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039e:	48 89 ce             	mov    %rcx,%rsi
  8003a1:	89 d7                	mov    %edx,%edi
  8003a3:	ff d0                	callq  *%rax
}
  8003a5:	48 83 c4 38          	add    $0x38,%rsp
  8003a9:	5b                   	pop    %rbx
  8003aa:	5d                   	pop    %rbp
  8003ab:	c3                   	retq   

00000000008003ac <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ac:	55                   	push   %rbp
  8003ad:	48 89 e5             	mov    %rsp,%rbp
  8003b0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003b8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003bb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003bf:	7e 52                	jle    800413 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c5:	8b 00                	mov    (%rax),%eax
  8003c7:	83 f8 30             	cmp    $0x30,%eax
  8003ca:	73 24                	jae    8003f0 <getuint+0x44>
  8003cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8003d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d8:	8b 00                	mov    (%rax),%eax
  8003da:	89 c0                	mov    %eax,%eax
  8003dc:	48 01 d0             	add    %rdx,%rax
  8003df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003e3:	8b 12                	mov    (%rdx),%edx
  8003e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8003e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003ec:	89 0a                	mov    %ecx,(%rdx)
  8003ee:	eb 17                	jmp    800407 <getuint+0x5b>
  8003f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8003f8:	48 89 d0             	mov    %rdx,%rax
  8003fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8003ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800403:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800407:	48 8b 00             	mov    (%rax),%rax
  80040a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80040e:	e9 a3 00 00 00       	jmpq   8004b6 <getuint+0x10a>
	else if (lflag)
  800413:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800417:	74 4f                	je     800468 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041d:	8b 00                	mov    (%rax),%eax
  80041f:	83 f8 30             	cmp    $0x30,%eax
  800422:	73 24                	jae    800448 <getuint+0x9c>
  800424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800428:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800430:	8b 00                	mov    (%rax),%eax
  800432:	89 c0                	mov    %eax,%eax
  800434:	48 01 d0             	add    %rdx,%rax
  800437:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043b:	8b 12                	mov    (%rdx),%edx
  80043d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800440:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800444:	89 0a                	mov    %ecx,(%rdx)
  800446:	eb 17                	jmp    80045f <getuint+0xb3>
  800448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800450:	48 89 d0             	mov    %rdx,%rax
  800453:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800457:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80045f:	48 8b 00             	mov    (%rax),%rax
  800462:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800466:	eb 4e                	jmp    8004b6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046c:	8b 00                	mov    (%rax),%eax
  80046e:	83 f8 30             	cmp    $0x30,%eax
  800471:	73 24                	jae    800497 <getuint+0xeb>
  800473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800477:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80047b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	89 c0                	mov    %eax,%eax
  800483:	48 01 d0             	add    %rdx,%rax
  800486:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048a:	8b 12                	mov    (%rdx),%edx
  80048c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80048f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800493:	89 0a                	mov    %ecx,(%rdx)
  800495:	eb 17                	jmp    8004ae <getuint+0x102>
  800497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049f:	48 89 d0             	mov    %rdx,%rax
  8004a2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004ae:	8b 00                	mov    (%rax),%eax
  8004b0:	89 c0                	mov    %eax,%eax
  8004b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004ba:	c9                   	leaveq 
  8004bb:	c3                   	retq   

00000000008004bc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004bc:	55                   	push   %rbp
  8004bd:	48 89 e5             	mov    %rsp,%rbp
  8004c0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004cb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004cf:	7e 52                	jle    800523 <getint+0x67>
		x=va_arg(*ap, long long);
  8004d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d5:	8b 00                	mov    (%rax),%eax
  8004d7:	83 f8 30             	cmp    $0x30,%eax
  8004da:	73 24                	jae    800500 <getint+0x44>
  8004dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e8:	8b 00                	mov    (%rax),%eax
  8004ea:	89 c0                	mov    %eax,%eax
  8004ec:	48 01 d0             	add    %rdx,%rax
  8004ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f3:	8b 12                	mov    (%rdx),%edx
  8004f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fc:	89 0a                	mov    %ecx,(%rdx)
  8004fe:	eb 17                	jmp    800517 <getint+0x5b>
  800500:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800504:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800508:	48 89 d0             	mov    %rdx,%rax
  80050b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80050f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800513:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800517:	48 8b 00             	mov    (%rax),%rax
  80051a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80051e:	e9 a3 00 00 00       	jmpq   8005c6 <getint+0x10a>
	else if (lflag)
  800523:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800527:	74 4f                	je     800578 <getint+0xbc>
		x=va_arg(*ap, long);
  800529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052d:	8b 00                	mov    (%rax),%eax
  80052f:	83 f8 30             	cmp    $0x30,%eax
  800532:	73 24                	jae    800558 <getint+0x9c>
  800534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800538:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80053c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800540:	8b 00                	mov    (%rax),%eax
  800542:	89 c0                	mov    %eax,%eax
  800544:	48 01 d0             	add    %rdx,%rax
  800547:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054b:	8b 12                	mov    (%rdx),%edx
  80054d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800550:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800554:	89 0a                	mov    %ecx,(%rdx)
  800556:	eb 17                	jmp    80056f <getint+0xb3>
  800558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800560:	48 89 d0             	mov    %rdx,%rax
  800563:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056f:	48 8b 00             	mov    (%rax),%rax
  800572:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800576:	eb 4e                	jmp    8005c6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	8b 00                	mov    (%rax),%eax
  80057e:	83 f8 30             	cmp    $0x30,%eax
  800581:	73 24                	jae    8005a7 <getint+0xeb>
  800583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800587:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058f:	8b 00                	mov    (%rax),%eax
  800591:	89 c0                	mov    %eax,%eax
  800593:	48 01 d0             	add    %rdx,%rax
  800596:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059a:	8b 12                	mov    (%rdx),%edx
  80059c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a3:	89 0a                	mov    %ecx,(%rdx)
  8005a5:	eb 17                	jmp    8005be <getint+0x102>
  8005a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005af:	48 89 d0             	mov    %rdx,%rax
  8005b2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005be:	8b 00                	mov    (%rax),%eax
  8005c0:	48 98                	cltq   
  8005c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005ca:	c9                   	leaveq 
  8005cb:	c3                   	retq   

00000000008005cc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005cc:	55                   	push   %rbp
  8005cd:	48 89 e5             	mov    %rsp,%rbp
  8005d0:	41 54                	push   %r12
  8005d2:	53                   	push   %rbx
  8005d3:	48 83 ec 60          	sub    $0x60,%rsp
  8005d7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8005db:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8005df:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8005e3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8005e7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8005eb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8005ef:	48 8b 0a             	mov    (%rdx),%rcx
  8005f2:	48 89 08             	mov    %rcx,(%rax)
  8005f5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005f9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005fd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800601:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800605:	eb 17                	jmp    80061e <vprintfmt+0x52>
			if (ch == '\0')
  800607:	85 db                	test   %ebx,%ebx
  800609:	0f 84 df 04 00 00    	je     800aee <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80060f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800613:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800617:	48 89 d6             	mov    %rdx,%rsi
  80061a:	89 df                	mov    %ebx,%edi
  80061c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800622:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800626:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80062a:	0f b6 00             	movzbl (%rax),%eax
  80062d:	0f b6 d8             	movzbl %al,%ebx
  800630:	83 fb 25             	cmp    $0x25,%ebx
  800633:	75 d2                	jne    800607 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800635:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800639:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800640:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800647:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80064e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800655:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800659:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80065d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800661:	0f b6 00             	movzbl (%rax),%eax
  800664:	0f b6 d8             	movzbl %al,%ebx
  800667:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80066a:	83 f8 55             	cmp    $0x55,%eax
  80066d:	0f 87 47 04 00 00    	ja     800aba <vprintfmt+0x4ee>
  800673:	89 c0                	mov    %eax,%eax
  800675:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80067c:	00 
  80067d:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  800684:	00 00 00 
  800687:	48 01 d0             	add    %rdx,%rax
  80068a:	48 8b 00             	mov    (%rax),%rax
  80068d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80068f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800693:	eb c0                	jmp    800655 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800695:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800699:	eb ba                	jmp    800655 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80069b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006a2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006a5:	89 d0                	mov    %edx,%eax
  8006a7:	c1 e0 02             	shl    $0x2,%eax
  8006aa:	01 d0                	add    %edx,%eax
  8006ac:	01 c0                	add    %eax,%eax
  8006ae:	01 d8                	add    %ebx,%eax
  8006b0:	83 e8 30             	sub    $0x30,%eax
  8006b3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006ba:	0f b6 00             	movzbl (%rax),%eax
  8006bd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006c0:	83 fb 2f             	cmp    $0x2f,%ebx
  8006c3:	7e 0c                	jle    8006d1 <vprintfmt+0x105>
  8006c5:	83 fb 39             	cmp    $0x39,%ebx
  8006c8:	7f 07                	jg     8006d1 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ca:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006cf:	eb d1                	jmp    8006a2 <vprintfmt+0xd6>
			goto process_precision;
  8006d1:	eb 58                	jmp    80072b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8006d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d6:	83 f8 30             	cmp    $0x30,%eax
  8006d9:	73 17                	jae    8006f2 <vprintfmt+0x126>
  8006db:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8006df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006e2:	89 c0                	mov    %eax,%eax
  8006e4:	48 01 d0             	add    %rdx,%rax
  8006e7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8006ea:	83 c2 08             	add    $0x8,%edx
  8006ed:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8006f0:	eb 0f                	jmp    800701 <vprintfmt+0x135>
  8006f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006f6:	48 89 d0             	mov    %rdx,%rax
  8006f9:	48 83 c2 08          	add    $0x8,%rdx
  8006fd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800701:	8b 00                	mov    (%rax),%eax
  800703:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800706:	eb 23                	jmp    80072b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800708:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80070c:	79 0c                	jns    80071a <vprintfmt+0x14e>
				width = 0;
  80070e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800715:	e9 3b ff ff ff       	jmpq   800655 <vprintfmt+0x89>
  80071a:	e9 36 ff ff ff       	jmpq   800655 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80071f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800726:	e9 2a ff ff ff       	jmpq   800655 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80072b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80072f:	79 12                	jns    800743 <vprintfmt+0x177>
				width = precision, precision = -1;
  800731:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800734:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800737:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80073e:	e9 12 ff ff ff       	jmpq   800655 <vprintfmt+0x89>
  800743:	e9 0d ff ff ff       	jmpq   800655 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800748:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80074c:	e9 04 ff ff ff       	jmpq   800655 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800751:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800754:	83 f8 30             	cmp    $0x30,%eax
  800757:	73 17                	jae    800770 <vprintfmt+0x1a4>
  800759:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80075d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800760:	89 c0                	mov    %eax,%eax
  800762:	48 01 d0             	add    %rdx,%rax
  800765:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800768:	83 c2 08             	add    $0x8,%edx
  80076b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80076e:	eb 0f                	jmp    80077f <vprintfmt+0x1b3>
  800770:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800774:	48 89 d0             	mov    %rdx,%rax
  800777:	48 83 c2 08          	add    $0x8,%rdx
  80077b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80077f:	8b 10                	mov    (%rax),%edx
  800781:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800785:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800789:	48 89 ce             	mov    %rcx,%rsi
  80078c:	89 d7                	mov    %edx,%edi
  80078e:	ff d0                	callq  *%rax
			break;
  800790:	e9 53 03 00 00       	jmpq   800ae8 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800795:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800798:	83 f8 30             	cmp    $0x30,%eax
  80079b:	73 17                	jae    8007b4 <vprintfmt+0x1e8>
  80079d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a4:	89 c0                	mov    %eax,%eax
  8007a6:	48 01 d0             	add    %rdx,%rax
  8007a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ac:	83 c2 08             	add    $0x8,%edx
  8007af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b2:	eb 0f                	jmp    8007c3 <vprintfmt+0x1f7>
  8007b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b8:	48 89 d0             	mov    %rdx,%rax
  8007bb:	48 83 c2 08          	add    $0x8,%rdx
  8007bf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007c5:	85 db                	test   %ebx,%ebx
  8007c7:	79 02                	jns    8007cb <vprintfmt+0x1ff>
				err = -err;
  8007c9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007cb:	83 fb 15             	cmp    $0x15,%ebx
  8007ce:	7f 16                	jg     8007e6 <vprintfmt+0x21a>
  8007d0:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  8007d7:	00 00 00 
  8007da:	48 63 d3             	movslq %ebx,%rdx
  8007dd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8007e1:	4d 85 e4             	test   %r12,%r12
  8007e4:	75 2e                	jne    800814 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8007e6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8007ea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ee:	89 d9                	mov    %ebx,%ecx
  8007f0:	48 ba 81 19 80 00 00 	movabs $0x801981,%rdx
  8007f7:	00 00 00 
  8007fa:	48 89 c7             	mov    %rax,%rdi
  8007fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800802:	49 b8 f7 0a 80 00 00 	movabs $0x800af7,%r8
  800809:	00 00 00 
  80080c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80080f:	e9 d4 02 00 00       	jmpq   800ae8 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800814:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800818:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80081c:	4c 89 e1             	mov    %r12,%rcx
  80081f:	48 ba 8a 19 80 00 00 	movabs $0x80198a,%rdx
  800826:	00 00 00 
  800829:	48 89 c7             	mov    %rax,%rdi
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
  800831:	49 b8 f7 0a 80 00 00 	movabs $0x800af7,%r8
  800838:	00 00 00 
  80083b:	41 ff d0             	callq  *%r8
			break;
  80083e:	e9 a5 02 00 00       	jmpq   800ae8 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800843:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800846:	83 f8 30             	cmp    $0x30,%eax
  800849:	73 17                	jae    800862 <vprintfmt+0x296>
  80084b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80084f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800852:	89 c0                	mov    %eax,%eax
  800854:	48 01 d0             	add    %rdx,%rax
  800857:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80085a:	83 c2 08             	add    $0x8,%edx
  80085d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800860:	eb 0f                	jmp    800871 <vprintfmt+0x2a5>
  800862:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800866:	48 89 d0             	mov    %rdx,%rax
  800869:	48 83 c2 08          	add    $0x8,%rdx
  80086d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800871:	4c 8b 20             	mov    (%rax),%r12
  800874:	4d 85 e4             	test   %r12,%r12
  800877:	75 0a                	jne    800883 <vprintfmt+0x2b7>
				p = "(null)";
  800879:	49 bc 8d 19 80 00 00 	movabs $0x80198d,%r12
  800880:	00 00 00 
			if (width > 0 && padc != '-')
  800883:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800887:	7e 3f                	jle    8008c8 <vprintfmt+0x2fc>
  800889:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80088d:	74 39                	je     8008c8 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800892:	48 98                	cltq   
  800894:	48 89 c6             	mov    %rax,%rsi
  800897:	4c 89 e7             	mov    %r12,%rdi
  80089a:	48 b8 a3 0d 80 00 00 	movabs $0x800da3,%rax
  8008a1:	00 00 00 
  8008a4:	ff d0                	callq  *%rax
  8008a6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008a9:	eb 17                	jmp    8008c2 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008ab:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008af:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008b3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b7:	48 89 ce             	mov    %rcx,%rsi
  8008ba:	89 d7                	mov    %edx,%edi
  8008bc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008be:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c6:	7f e3                	jg     8008ab <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008c8:	eb 37                	jmp    800901 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008ce:	74 1e                	je     8008ee <vprintfmt+0x322>
  8008d0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d3:	7e 05                	jle    8008da <vprintfmt+0x30e>
  8008d5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008d8:	7e 14                	jle    8008ee <vprintfmt+0x322>
					putch('?', putdat);
  8008da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e2:	48 89 d6             	mov    %rdx,%rsi
  8008e5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008ea:	ff d0                	callq  *%rax
  8008ec:	eb 0f                	jmp    8008fd <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8008ee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f6:	48 89 d6             	mov    %rdx,%rsi
  8008f9:	89 df                	mov    %ebx,%edi
  8008fb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008fd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800901:	4c 89 e0             	mov    %r12,%rax
  800904:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800908:	0f b6 00             	movzbl (%rax),%eax
  80090b:	0f be d8             	movsbl %al,%ebx
  80090e:	85 db                	test   %ebx,%ebx
  800910:	74 10                	je     800922 <vprintfmt+0x356>
  800912:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800916:	78 b2                	js     8008ca <vprintfmt+0x2fe>
  800918:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80091c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800920:	79 a8                	jns    8008ca <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800922:	eb 16                	jmp    80093a <vprintfmt+0x36e>
				putch(' ', putdat);
  800924:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800928:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092c:	48 89 d6             	mov    %rdx,%rsi
  80092f:	bf 20 00 00 00       	mov    $0x20,%edi
  800934:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800936:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80093a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80093e:	7f e4                	jg     800924 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800940:	e9 a3 01 00 00       	jmpq   800ae8 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800945:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800949:	be 03 00 00 00       	mov    $0x3,%esi
  80094e:	48 89 c7             	mov    %rax,%rdi
  800951:	48 b8 bc 04 80 00 00 	movabs $0x8004bc,%rax
  800958:	00 00 00 
  80095b:	ff d0                	callq  *%rax
  80095d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800965:	48 85 c0             	test   %rax,%rax
  800968:	79 1d                	jns    800987 <vprintfmt+0x3bb>
				putch('-', putdat);
  80096a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80096e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800972:	48 89 d6             	mov    %rdx,%rsi
  800975:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80097a:	ff d0                	callq  *%rax
				num = -(long long) num;
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 f7 d8             	neg    %rax
  800983:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800987:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80098e:	e9 e8 00 00 00       	jmpq   800a7b <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800993:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800997:	be 03 00 00 00       	mov    $0x3,%esi
  80099c:	48 89 c7             	mov    %rax,%rdi
  80099f:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  8009a6:	00 00 00 
  8009a9:	ff d0                	callq  *%rax
  8009ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009af:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009b6:	e9 c0 00 00 00       	jmpq   800a7b <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c3:	48 89 d6             	mov    %rdx,%rsi
  8009c6:	bf 58 00 00 00       	mov    $0x58,%edi
  8009cb:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009cd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d5:	48 89 d6             	mov    %rdx,%rsi
  8009d8:	bf 58 00 00 00       	mov    $0x58,%edi
  8009dd:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009df:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e7:	48 89 d6             	mov    %rdx,%rsi
  8009ea:	bf 58 00 00 00       	mov    $0x58,%edi
  8009ef:	ff d0                	callq  *%rax
			break;
  8009f1:	e9 f2 00 00 00       	jmpq   800ae8 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  8009f6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fe:	48 89 d6             	mov    %rdx,%rsi
  800a01:	bf 30 00 00 00       	mov    $0x30,%edi
  800a06:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a10:	48 89 d6             	mov    %rdx,%rsi
  800a13:	bf 78 00 00 00       	mov    $0x78,%edi
  800a18:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1d:	83 f8 30             	cmp    $0x30,%eax
  800a20:	73 17                	jae    800a39 <vprintfmt+0x46d>
  800a22:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a29:	89 c0                	mov    %eax,%eax
  800a2b:	48 01 d0             	add    %rdx,%rax
  800a2e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a31:	83 c2 08             	add    $0x8,%edx
  800a34:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a37:	eb 0f                	jmp    800a48 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3d:	48 89 d0             	mov    %rdx,%rax
  800a40:	48 83 c2 08          	add    $0x8,%rdx
  800a44:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a48:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a4f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a56:	eb 23                	jmp    800a7b <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a58:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a5c:	be 03 00 00 00       	mov    $0x3,%esi
  800a61:	48 89 c7             	mov    %rax,%rdi
  800a64:	48 b8 ac 03 80 00 00 	movabs $0x8003ac,%rax
  800a6b:	00 00 00 
  800a6e:	ff d0                	callq  *%rax
  800a70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a7b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a80:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a83:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a92:	45 89 c1             	mov    %r8d,%r9d
  800a95:	41 89 f8             	mov    %edi,%r8d
  800a98:	48 89 c7             	mov    %rax,%rdi
  800a9b:	48 b8 f1 02 80 00 00 	movabs $0x8002f1,%rax
  800aa2:	00 00 00 
  800aa5:	ff d0                	callq  *%rax
			break;
  800aa7:	eb 3f                	jmp    800ae8 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab1:	48 89 d6             	mov    %rdx,%rsi
  800ab4:	89 df                	mov    %ebx,%edi
  800ab6:	ff d0                	callq  *%rax
			break;
  800ab8:	eb 2e                	jmp    800ae8 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac2:	48 89 d6             	mov    %rdx,%rsi
  800ac5:	bf 25 00 00 00       	mov    $0x25,%edi
  800aca:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ad1:	eb 05                	jmp    800ad8 <vprintfmt+0x50c>
  800ad3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ad8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800adc:	48 83 e8 01          	sub    $0x1,%rax
  800ae0:	0f b6 00             	movzbl (%rax),%eax
  800ae3:	3c 25                	cmp    $0x25,%al
  800ae5:	75 ec                	jne    800ad3 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ae7:	90                   	nop
		}
	}
  800ae8:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ae9:	e9 30 fb ff ff       	jmpq   80061e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800aee:	48 83 c4 60          	add    $0x60,%rsp
  800af2:	5b                   	pop    %rbx
  800af3:	41 5c                	pop    %r12
  800af5:	5d                   	pop    %rbp
  800af6:	c3                   	retq   

0000000000800af7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af7:	55                   	push   %rbp
  800af8:	48 89 e5             	mov    %rsp,%rbp
  800afb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b02:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b09:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b10:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b17:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b1e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b25:	84 c0                	test   %al,%al
  800b27:	74 20                	je     800b49 <printfmt+0x52>
  800b29:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b2d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b31:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b35:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b39:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b3d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b41:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b45:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b49:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b50:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b57:	00 00 00 
  800b5a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b61:	00 00 00 
  800b64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b68:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b6f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b76:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b84:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b8b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800b92:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800b99:	48 89 c7             	mov    %rax,%rdi
  800b9c:	48 b8 cc 05 80 00 00 	movabs $0x8005cc,%rax
  800ba3:	00 00 00 
  800ba6:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ba8:	c9                   	leaveq 
  800ba9:	c3                   	retq   

0000000000800baa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800baa:	55                   	push   %rbp
  800bab:	48 89 e5             	mov    %rsp,%rbp
  800bae:	48 83 ec 10          	sub    $0x10,%rsp
  800bb2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bb5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bbd:	8b 40 10             	mov    0x10(%rax),%eax
  800bc0:	8d 50 01             	lea    0x1(%rax),%edx
  800bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bc7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bce:	48 8b 10             	mov    (%rax),%rdx
  800bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bd9:	48 39 c2             	cmp    %rax,%rdx
  800bdc:	73 17                	jae    800bf5 <sprintputch+0x4b>
		*b->buf++ = ch;
  800bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be2:	48 8b 00             	mov    (%rax),%rax
  800be5:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800be9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bed:	48 89 0a             	mov    %rcx,(%rdx)
  800bf0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800bf3:	88 10                	mov    %dl,(%rax)
}
  800bf5:	c9                   	leaveq 
  800bf6:	c3                   	retq   

0000000000800bf7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf7:	55                   	push   %rbp
  800bf8:	48 89 e5             	mov    %rsp,%rbp
  800bfb:	48 83 ec 50          	sub    $0x50,%rsp
  800bff:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c03:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c06:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c0a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c0e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c12:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c16:	48 8b 0a             	mov    (%rdx),%rcx
  800c19:	48 89 08             	mov    %rcx,(%rax)
  800c1c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c20:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c24:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c28:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c30:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c34:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c37:	48 98                	cltq   
  800c39:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c41:	48 01 d0             	add    %rdx,%rax
  800c44:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c48:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c4f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c54:	74 06                	je     800c5c <vsnprintf+0x65>
  800c56:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c5a:	7f 07                	jg     800c63 <vsnprintf+0x6c>
		return -E_INVAL;
  800c5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c61:	eb 2f                	jmp    800c92 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c63:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c67:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c6b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c6f:	48 89 c6             	mov    %rax,%rsi
  800c72:	48 bf aa 0b 80 00 00 	movabs $0x800baa,%rdi
  800c79:	00 00 00 
  800c7c:	48 b8 cc 05 80 00 00 	movabs $0x8005cc,%rax
  800c83:	00 00 00 
  800c86:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800c88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c8c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800c8f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800c92:	c9                   	leaveq 
  800c93:	c3                   	retq   

0000000000800c94 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c94:	55                   	push   %rbp
  800c95:	48 89 e5             	mov    %rsp,%rbp
  800c98:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c9f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ca6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cac:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cba:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 20                	je     800ce5 <snprintf+0x51>
  800cc5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cc9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ccd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cd9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cdd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ce5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800cec:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800cf3:	00 00 00 
  800cf6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800cfd:	00 00 00 
  800d00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d04:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d0b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d12:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d19:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d20:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d27:	48 8b 0a             	mov    (%rdx),%rcx
  800d2a:	48 89 08             	mov    %rcx,(%rax)
  800d2d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d31:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d35:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d39:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d3d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d44:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d4b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d51:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d58:	48 89 c7             	mov    %rax,%rdi
  800d5b:	48 b8 f7 0b 80 00 00 	movabs $0x800bf7,%rax
  800d62:	00 00 00 
  800d65:	ff d0                	callq  *%rax
  800d67:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d6d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d73:	c9                   	leaveq 
  800d74:	c3                   	retq   

0000000000800d75 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d75:	55                   	push   %rbp
  800d76:	48 89 e5             	mov    %rsp,%rbp
  800d79:	48 83 ec 18          	sub    $0x18,%rsp
  800d7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d88:	eb 09                	jmp    800d93 <strlen+0x1e>
		n++;
  800d8a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d8e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d97:	0f b6 00             	movzbl (%rax),%eax
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ec                	jne    800d8a <strlen+0x15>
		n++;
	return n;
  800d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800da1:	c9                   	leaveq 
  800da2:	c3                   	retq   

0000000000800da3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800da3:	55                   	push   %rbp
  800da4:	48 89 e5             	mov    %rsp,%rbp
  800da7:	48 83 ec 20          	sub    $0x20,%rsp
  800dab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800daf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dba:	eb 0e                	jmp    800dca <strnlen+0x27>
		n++;
  800dbc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dc5:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dca:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dcf:	74 0b                	je     800ddc <strnlen+0x39>
  800dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd5:	0f b6 00             	movzbl (%rax),%eax
  800dd8:	84 c0                	test   %al,%al
  800dda:	75 e0                	jne    800dbc <strnlen+0x19>
		n++;
	return n;
  800ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ddf:	c9                   	leaveq 
  800de0:	c3                   	retq   

0000000000800de1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de1:	55                   	push   %rbp
  800de2:	48 89 e5             	mov    %rsp,%rbp
  800de5:	48 83 ec 20          	sub    $0x20,%rsp
  800de9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ded:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800df9:	90                   	nop
  800dfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dfe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e02:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e06:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e0a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e0e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e12:	0f b6 12             	movzbl (%rdx),%edx
  800e15:	88 10                	mov    %dl,(%rax)
  800e17:	0f b6 00             	movzbl (%rax),%eax
  800e1a:	84 c0                	test   %al,%al
  800e1c:	75 dc                	jne    800dfa <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e22:	c9                   	leaveq 
  800e23:	c3                   	retq   

0000000000800e24 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e24:	55                   	push   %rbp
  800e25:	48 89 e5             	mov    %rsp,%rbp
  800e28:	48 83 ec 20          	sub    $0x20,%rsp
  800e2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e38:	48 89 c7             	mov    %rax,%rdi
  800e3b:	48 b8 75 0d 80 00 00 	movabs $0x800d75,%rax
  800e42:	00 00 00 
  800e45:	ff d0                	callq  *%rax
  800e47:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e4d:	48 63 d0             	movslq %eax,%rdx
  800e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e54:	48 01 c2             	add    %rax,%rdx
  800e57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e5b:	48 89 c6             	mov    %rax,%rsi
  800e5e:	48 89 d7             	mov    %rdx,%rdi
  800e61:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  800e68:	00 00 00 
  800e6b:	ff d0                	callq  *%rax
	return dst;
  800e6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e71:	c9                   	leaveq 
  800e72:	c3                   	retq   

0000000000800e73 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e73:	55                   	push   %rbp
  800e74:	48 89 e5             	mov    %rsp,%rbp
  800e77:	48 83 ec 28          	sub    $0x28,%rsp
  800e7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e83:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800e8f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800e96:	00 
  800e97:	eb 2a                	jmp    800ec3 <strncpy+0x50>
		*dst++ = *src;
  800e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ea1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ea5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea9:	0f b6 12             	movzbl (%rdx),%edx
  800eac:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eb2:	0f b6 00             	movzbl (%rax),%eax
  800eb5:	84 c0                	test   %al,%al
  800eb7:	74 05                	je     800ebe <strncpy+0x4b>
			src++;
  800eb9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ebe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ec7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ecb:	72 cc                	jb     800e99 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ed1:	c9                   	leaveq 
  800ed2:	c3                   	retq   

0000000000800ed3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ed3:	55                   	push   %rbp
  800ed4:	48 89 e5             	mov    %rsp,%rbp
  800ed7:	48 83 ec 28          	sub    $0x28,%rsp
  800edb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ee3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eeb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800eef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ef4:	74 3d                	je     800f33 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ef6:	eb 1d                	jmp    800f15 <strlcpy+0x42>
			*dst++ = *src++;
  800ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f00:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f04:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f08:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f0c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f10:	0f b6 12             	movzbl (%rdx),%edx
  800f13:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f15:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f1a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f1f:	74 0b                	je     800f2c <strlcpy+0x59>
  800f21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f25:	0f b6 00             	movzbl (%rax),%eax
  800f28:	84 c0                	test   %al,%al
  800f2a:	75 cc                	jne    800ef8 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f30:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f3b:	48 29 c2             	sub    %rax,%rdx
  800f3e:	48 89 d0             	mov    %rdx,%rax
}
  800f41:	c9                   	leaveq 
  800f42:	c3                   	retq   

0000000000800f43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f43:	55                   	push   %rbp
  800f44:	48 89 e5             	mov    %rsp,%rbp
  800f47:	48 83 ec 10          	sub    $0x10,%rsp
  800f4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f53:	eb 0a                	jmp    800f5f <strcmp+0x1c>
		p++, q++;
  800f55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f5a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f63:	0f b6 00             	movzbl (%rax),%eax
  800f66:	84 c0                	test   %al,%al
  800f68:	74 12                	je     800f7c <strcmp+0x39>
  800f6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f6e:	0f b6 10             	movzbl (%rax),%edx
  800f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f75:	0f b6 00             	movzbl (%rax),%eax
  800f78:	38 c2                	cmp    %al,%dl
  800f7a:	74 d9                	je     800f55 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f80:	0f b6 00             	movzbl (%rax),%eax
  800f83:	0f b6 d0             	movzbl %al,%edx
  800f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f8a:	0f b6 00             	movzbl (%rax),%eax
  800f8d:	0f b6 c0             	movzbl %al,%eax
  800f90:	29 c2                	sub    %eax,%edx
  800f92:	89 d0                	mov    %edx,%eax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 83 ec 18          	sub    $0x18,%rsp
  800f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fa2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fa6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800faa:	eb 0f                	jmp    800fbb <strncmp+0x25>
		n--, p++, q++;
  800fac:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fb1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fbb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fc0:	74 1d                	je     800fdf <strncmp+0x49>
  800fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc6:	0f b6 00             	movzbl (%rax),%eax
  800fc9:	84 c0                	test   %al,%al
  800fcb:	74 12                	je     800fdf <strncmp+0x49>
  800fcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd1:	0f b6 10             	movzbl (%rax),%edx
  800fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd8:	0f b6 00             	movzbl (%rax),%eax
  800fdb:	38 c2                	cmp    %al,%dl
  800fdd:	74 cd                	je     800fac <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800fdf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fe4:	75 07                	jne    800fed <strncmp+0x57>
		return 0;
  800fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  800feb:	eb 18                	jmp    801005 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff1:	0f b6 00             	movzbl (%rax),%eax
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffb:	0f b6 00             	movzbl (%rax),%eax
  800ffe:	0f b6 c0             	movzbl %al,%eax
  801001:	29 c2                	sub    %eax,%edx
  801003:	89 d0                	mov    %edx,%eax
}
  801005:	c9                   	leaveq 
  801006:	c3                   	retq   

0000000000801007 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801007:	55                   	push   %rbp
  801008:	48 89 e5             	mov    %rsp,%rbp
  80100b:	48 83 ec 0c          	sub    $0xc,%rsp
  80100f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801013:	89 f0                	mov    %esi,%eax
  801015:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801018:	eb 17                	jmp    801031 <strchr+0x2a>
		if (*s == c)
  80101a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101e:	0f b6 00             	movzbl (%rax),%eax
  801021:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801024:	75 06                	jne    80102c <strchr+0x25>
			return (char *) s;
  801026:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102a:	eb 15                	jmp    801041 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801035:	0f b6 00             	movzbl (%rax),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	75 de                	jne    80101a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80103c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801041:	c9                   	leaveq 
  801042:	c3                   	retq   

0000000000801043 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801043:	55                   	push   %rbp
  801044:	48 89 e5             	mov    %rsp,%rbp
  801047:	48 83 ec 0c          	sub    $0xc,%rsp
  80104b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104f:	89 f0                	mov    %esi,%eax
  801051:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801054:	eb 13                	jmp    801069 <strfind+0x26>
		if (*s == c)
  801056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105a:	0f b6 00             	movzbl (%rax),%eax
  80105d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801060:	75 02                	jne    801064 <strfind+0x21>
			break;
  801062:	eb 10                	jmp    801074 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801064:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106d:	0f b6 00             	movzbl (%rax),%eax
  801070:	84 c0                	test   %al,%al
  801072:	75 e2                	jne    801056 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801074:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 83 ec 18          	sub    $0x18,%rsp
  801082:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801086:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801089:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80108d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801092:	75 06                	jne    80109a <memset+0x20>
		return v;
  801094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801098:	eb 69                	jmp    801103 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	83 e0 03             	and    $0x3,%eax
  8010a1:	48 85 c0             	test   %rax,%rax
  8010a4:	75 48                	jne    8010ee <memset+0x74>
  8010a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010aa:	83 e0 03             	and    $0x3,%eax
  8010ad:	48 85 c0             	test   %rax,%rax
  8010b0:	75 3c                	jne    8010ee <memset+0x74>
		c &= 0xFF;
  8010b2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010bc:	c1 e0 18             	shl    $0x18,%eax
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010c4:	c1 e0 10             	shl    $0x10,%eax
  8010c7:	09 c2                	or     %eax,%edx
  8010c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010cc:	c1 e0 08             	shl    $0x8,%eax
  8010cf:	09 d0                	or     %edx,%eax
  8010d1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d8:	48 c1 e8 02          	shr    $0x2,%rax
  8010dc:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e6:	48 89 d7             	mov    %rdx,%rdi
  8010e9:	fc                   	cld    
  8010ea:	f3 ab                	rep stos %eax,%es:(%rdi)
  8010ec:	eb 11                	jmp    8010ff <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8010f9:	48 89 d7             	mov    %rdx,%rdi
  8010fc:	fc                   	cld    
  8010fd:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8010ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801103:	c9                   	leaveq 
  801104:	c3                   	retq   

0000000000801105 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801105:	55                   	push   %rbp
  801106:	48 89 e5             	mov    %rsp,%rbp
  801109:	48 83 ec 28          	sub    $0x28,%rsp
  80110d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801111:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801115:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801119:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801125:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801131:	0f 83 88 00 00 00    	jae    8011bf <memmove+0xba>
  801137:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80113b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80113f:	48 01 d0             	add    %rdx,%rax
  801142:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801146:	76 77                	jbe    8011bf <memmove+0xba>
		s += n;
  801148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80114c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801150:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801154:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115c:	83 e0 03             	and    $0x3,%eax
  80115f:	48 85 c0             	test   %rax,%rax
  801162:	75 3b                	jne    80119f <memmove+0x9a>
  801164:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801168:	83 e0 03             	and    $0x3,%eax
  80116b:	48 85 c0             	test   %rax,%rax
  80116e:	75 2f                	jne    80119f <memmove+0x9a>
  801170:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801174:	83 e0 03             	and    $0x3,%eax
  801177:	48 85 c0             	test   %rax,%rax
  80117a:	75 23                	jne    80119f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80117c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801180:	48 83 e8 04          	sub    $0x4,%rax
  801184:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801188:	48 83 ea 04          	sub    $0x4,%rdx
  80118c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801190:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801194:	48 89 c7             	mov    %rax,%rdi
  801197:	48 89 d6             	mov    %rdx,%rsi
  80119a:	fd                   	std    
  80119b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80119d:	eb 1d                	jmp    8011bc <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80119f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b3:	48 89 d7             	mov    %rdx,%rdi
  8011b6:	48 89 c1             	mov    %rax,%rcx
  8011b9:	fd                   	std    
  8011ba:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011bc:	fc                   	cld    
  8011bd:	eb 57                	jmp    801216 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	83 e0 03             	and    $0x3,%eax
  8011c6:	48 85 c0             	test   %rax,%rax
  8011c9:	75 36                	jne    801201 <memmove+0xfc>
  8011cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cf:	83 e0 03             	and    $0x3,%eax
  8011d2:	48 85 c0             	test   %rax,%rax
  8011d5:	75 2a                	jne    801201 <memmove+0xfc>
  8011d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011db:	83 e0 03             	and    $0x3,%eax
  8011de:	48 85 c0             	test   %rax,%rax
  8011e1:	75 1e                	jne    801201 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e7:	48 c1 e8 02          	shr    $0x2,%rax
  8011eb:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f6:	48 89 c7             	mov    %rax,%rdi
  8011f9:	48 89 d6             	mov    %rdx,%rsi
  8011fc:	fc                   	cld    
  8011fd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011ff:	eb 15                	jmp    801216 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801205:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801209:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80120d:	48 89 c7             	mov    %rax,%rdi
  801210:	48 89 d6             	mov    %rdx,%rsi
  801213:	fc                   	cld    
  801214:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80121a:	c9                   	leaveq 
  80121b:	c3                   	retq   

000000000080121c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	48 83 ec 18          	sub    $0x18,%rsp
  801224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801228:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801230:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801234:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	48 89 ce             	mov    %rcx,%rsi
  80123f:	48 89 c7             	mov    %rax,%rdi
  801242:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  801249:	00 00 00 
  80124c:	ff d0                	callq  *%rax
}
  80124e:	c9                   	leaveq 
  80124f:	c3                   	retq   

0000000000801250 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801250:	55                   	push   %rbp
  801251:	48 89 e5             	mov    %rsp,%rbp
  801254:	48 83 ec 28          	sub    $0x28,%rsp
  801258:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801260:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801268:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80126c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801270:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801274:	eb 36                	jmp    8012ac <memcmp+0x5c>
		if (*s1 != *s2)
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	0f b6 10             	movzbl (%rax),%edx
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801281:	0f b6 00             	movzbl (%rax),%eax
  801284:	38 c2                	cmp    %al,%dl
  801286:	74 1a                	je     8012a2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128c:	0f b6 00             	movzbl (%rax),%eax
  80128f:	0f b6 d0             	movzbl %al,%edx
  801292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801296:	0f b6 00             	movzbl (%rax),%eax
  801299:	0f b6 c0             	movzbl %al,%eax
  80129c:	29 c2                	sub    %eax,%edx
  80129e:	89 d0                	mov    %edx,%eax
  8012a0:	eb 20                	jmp    8012c2 <memcmp+0x72>
		s1++, s2++;
  8012a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012b8:	48 85 c0             	test   %rax,%rax
  8012bb:	75 b9                	jne    801276 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c2:	c9                   	leaveq 
  8012c3:	c3                   	retq   

00000000008012c4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012c4:	55                   	push   %rbp
  8012c5:	48 89 e5             	mov    %rsp,%rbp
  8012c8:	48 83 ec 28          	sub    $0x28,%rsp
  8012cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012df:	48 01 d0             	add    %rdx,%rax
  8012e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8012e6:	eb 15                	jmp    8012fd <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	0f b6 10             	movzbl (%rax),%edx
  8012ef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8012f2:	38 c2                	cmp    %al,%dl
  8012f4:	75 02                	jne    8012f8 <memfind+0x34>
			break;
  8012f6:	eb 0f                	jmp    801307 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801301:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801305:	72 e1                	jb     8012e8 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80130b:	c9                   	leaveq 
  80130c:	c3                   	retq   

000000000080130d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80130d:	55                   	push   %rbp
  80130e:	48 89 e5             	mov    %rsp,%rbp
  801311:	48 83 ec 34          	sub    $0x34,%rsp
  801315:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801319:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80131d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801320:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801327:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80132e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80132f:	eb 05                	jmp    801336 <strtol+0x29>
		s++;
  801331:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801336:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133a:	0f b6 00             	movzbl (%rax),%eax
  80133d:	3c 20                	cmp    $0x20,%al
  80133f:	74 f0                	je     801331 <strtol+0x24>
  801341:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801345:	0f b6 00             	movzbl (%rax),%eax
  801348:	3c 09                	cmp    $0x9,%al
  80134a:	74 e5                	je     801331 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80134c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801350:	0f b6 00             	movzbl (%rax),%eax
  801353:	3c 2b                	cmp    $0x2b,%al
  801355:	75 07                	jne    80135e <strtol+0x51>
		s++;
  801357:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80135c:	eb 17                	jmp    801375 <strtol+0x68>
	else if (*s == '-')
  80135e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801362:	0f b6 00             	movzbl (%rax),%eax
  801365:	3c 2d                	cmp    $0x2d,%al
  801367:	75 0c                	jne    801375 <strtol+0x68>
		s++, neg = 1;
  801369:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80136e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801375:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801379:	74 06                	je     801381 <strtol+0x74>
  80137b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80137f:	75 28                	jne    8013a9 <strtol+0x9c>
  801381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	3c 30                	cmp    $0x30,%al
  80138a:	75 1d                	jne    8013a9 <strtol+0x9c>
  80138c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801390:	48 83 c0 01          	add    $0x1,%rax
  801394:	0f b6 00             	movzbl (%rax),%eax
  801397:	3c 78                	cmp    $0x78,%al
  801399:	75 0e                	jne    8013a9 <strtol+0x9c>
		s += 2, base = 16;
  80139b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013a0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013a7:	eb 2c                	jmp    8013d5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ad:	75 19                	jne    8013c8 <strtol+0xbb>
  8013af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b3:	0f b6 00             	movzbl (%rax),%eax
  8013b6:	3c 30                	cmp    $0x30,%al
  8013b8:	75 0e                	jne    8013c8 <strtol+0xbb>
		s++, base = 8;
  8013ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013bf:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013c6:	eb 0d                	jmp    8013d5 <strtol+0xc8>
	else if (base == 0)
  8013c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013cc:	75 07                	jne    8013d5 <strtol+0xc8>
		base = 10;
  8013ce:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	0f b6 00             	movzbl (%rax),%eax
  8013dc:	3c 2f                	cmp    $0x2f,%al
  8013de:	7e 1d                	jle    8013fd <strtol+0xf0>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	3c 39                	cmp    $0x39,%al
  8013e9:	7f 12                	jg     8013fd <strtol+0xf0>
			dig = *s - '0';
  8013eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ef:	0f b6 00             	movzbl (%rax),%eax
  8013f2:	0f be c0             	movsbl %al,%eax
  8013f5:	83 e8 30             	sub    $0x30,%eax
  8013f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013fb:	eb 4e                	jmp    80144b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8013fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801401:	0f b6 00             	movzbl (%rax),%eax
  801404:	3c 60                	cmp    $0x60,%al
  801406:	7e 1d                	jle    801425 <strtol+0x118>
  801408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	3c 7a                	cmp    $0x7a,%al
  801411:	7f 12                	jg     801425 <strtol+0x118>
			dig = *s - 'a' + 10;
  801413:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801417:	0f b6 00             	movzbl (%rax),%eax
  80141a:	0f be c0             	movsbl %al,%eax
  80141d:	83 e8 57             	sub    $0x57,%eax
  801420:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801423:	eb 26                	jmp    80144b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	3c 40                	cmp    $0x40,%al
  80142e:	7e 48                	jle    801478 <strtol+0x16b>
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	3c 5a                	cmp    $0x5a,%al
  801439:	7f 3d                	jg     801478 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	0f be c0             	movsbl %al,%eax
  801445:	83 e8 37             	sub    $0x37,%eax
  801448:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80144b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80144e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801451:	7c 02                	jl     801455 <strtol+0x148>
			break;
  801453:	eb 23                	jmp    801478 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801455:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80145d:	48 98                	cltq   
  80145f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801464:	48 89 c2             	mov    %rax,%rdx
  801467:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80146a:	48 98                	cltq   
  80146c:	48 01 d0             	add    %rdx,%rax
  80146f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801473:	e9 5d ff ff ff       	jmpq   8013d5 <strtol+0xc8>

	if (endptr)
  801478:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80147d:	74 0b                	je     80148a <strtol+0x17d>
		*endptr = (char *) s;
  80147f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801483:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801487:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80148a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80148e:	74 09                	je     801499 <strtol+0x18c>
  801490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801494:	48 f7 d8             	neg    %rax
  801497:	eb 04                	jmp    80149d <strtol+0x190>
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80149d:	c9                   	leaveq 
  80149e:	c3                   	retq   

000000000080149f <strstr>:

char * strstr(const char *in, const char *str)
{
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	48 83 ec 30          	sub    $0x30,%rsp
  8014a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014c1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014c5:	75 06                	jne    8014cd <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cb:	eb 6b                	jmp    801538 <strstr+0x99>

	len = strlen(str);
  8014cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d1:	48 89 c7             	mov    %rax,%rdi
  8014d4:	48 b8 75 0d 80 00 00 	movabs $0x800d75,%rax
  8014db:	00 00 00 
  8014de:	ff d0                	callq  *%rax
  8014e0:	48 98                	cltq   
  8014e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8014f8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8014fc:	75 07                	jne    801505 <strstr+0x66>
				return (char *) 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801503:	eb 33                	jmp    801538 <strstr+0x99>
		} while (sc != c);
  801505:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801509:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80150c:	75 d8                	jne    8014e6 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80150e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801512:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151a:	48 89 ce             	mov    %rcx,%rsi
  80151d:	48 89 c7             	mov    %rax,%rdi
  801520:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  801527:	00 00 00 
  80152a:	ff d0                	callq  *%rax
  80152c:	85 c0                	test   %eax,%eax
  80152e:	75 b6                	jne    8014e6 <strstr+0x47>

	return (char *) (in - 1);
  801530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801534:	48 83 e8 01          	sub    $0x1,%rax
}
  801538:	c9                   	leaveq 
  801539:	c3                   	retq   

000000000080153a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	53                   	push   %rbx
  80153f:	48 83 ec 48          	sub    $0x48,%rsp
  801543:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801546:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801549:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80154d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801551:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801555:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801559:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80155c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801560:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801564:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801568:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80156c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801570:	4c 89 c3             	mov    %r8,%rbx
  801573:	cd 30                	int    $0x30
  801575:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801579:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80157d:	74 3e                	je     8015bd <syscall+0x83>
  80157f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801584:	7e 37                	jle    8015bd <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801586:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80158d:	49 89 d0             	mov    %rdx,%r8
  801590:	89 c1                	mov    %eax,%ecx
  801592:	48 ba 48 1c 80 00 00 	movabs $0x801c48,%rdx
  801599:	00 00 00 
  80159c:	be 23 00 00 00       	mov    $0x23,%esi
  8015a1:	48 bf 65 1c 80 00 00 	movabs $0x801c65,%rdi
  8015a8:	00 00 00 
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b0:	49 b9 d2 16 80 00 00 	movabs $0x8016d2,%r9
  8015b7:	00 00 00 
  8015ba:	41 ff d1             	callq  *%r9

	return ret;
  8015bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c1:	48 83 c4 48          	add    $0x48,%rsp
  8015c5:	5b                   	pop    %rbx
  8015c6:	5d                   	pop    %rbp
  8015c7:	c3                   	retq   

00000000008015c8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 20          	sub    $0x20,%rsp
  8015d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015e0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8015e7:	00 
  8015e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8015ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8015f4:	48 89 d1             	mov    %rdx,%rcx
  8015f7:	48 89 c2             	mov    %rax,%rdx
  8015fa:	be 00 00 00 00       	mov    $0x0,%esi
  8015ff:	bf 00 00 00 00       	mov    $0x0,%edi
  801604:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  80160b:	00 00 00 
  80160e:	ff d0                	callq  *%rax
}
  801610:	c9                   	leaveq 
  801611:	c3                   	retq   

0000000000801612 <sys_cgetc>:

int
sys_cgetc(void)
{
  801612:	55                   	push   %rbp
  801613:	48 89 e5             	mov    %rsp,%rbp
  801616:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80161a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801621:	00 
  801622:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801628:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80162e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801633:	ba 00 00 00 00       	mov    $0x0,%edx
  801638:	be 00 00 00 00       	mov    $0x0,%esi
  80163d:	bf 01 00 00 00       	mov    $0x1,%edi
  801642:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801649:	00 00 00 
  80164c:	ff d0                	callq  *%rax
}
  80164e:	c9                   	leaveq 
  80164f:	c3                   	retq   

0000000000801650 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	48 83 ec 10          	sub    $0x10,%rsp
  801658:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80165b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80165e:	48 98                	cltq   
  801660:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801667:	00 
  801668:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80166e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801674:	b9 00 00 00 00       	mov    $0x0,%ecx
  801679:	48 89 c2             	mov    %rax,%rdx
  80167c:	be 01 00 00 00       	mov    $0x1,%esi
  801681:	bf 03 00 00 00       	mov    $0x3,%edi
  801686:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  80168d:	00 00 00 
  801690:	ff d0                	callq  *%rax
}
  801692:	c9                   	leaveq 
  801693:	c3                   	retq   

0000000000801694 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801694:	55                   	push   %rbp
  801695:	48 89 e5             	mov    %rsp,%rbp
  801698:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80169c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a3:	00 
  8016a4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016aa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ba:	be 00 00 00 00       	mov    $0x0,%esi
  8016bf:	bf 02 00 00 00       	mov    $0x2,%edi
  8016c4:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  8016cb:	00 00 00 
  8016ce:	ff d0                	callq  *%rax
}
  8016d0:	c9                   	leaveq 
  8016d1:	c3                   	retq   

00000000008016d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8016d2:	55                   	push   %rbp
  8016d3:	48 89 e5             	mov    %rsp,%rbp
  8016d6:	53                   	push   %rbx
  8016d7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8016de:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8016e5:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8016eb:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8016f2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8016f9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801700:	84 c0                	test   %al,%al
  801702:	74 23                	je     801727 <_panic+0x55>
  801704:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80170b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80170f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801713:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801717:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80171b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80171f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801723:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801727:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80172e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801735:	00 00 00 
  801738:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80173f:	00 00 00 
  801742:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801746:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80174d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801754:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80175b:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801762:	00 00 00 
  801765:	48 8b 18             	mov    (%rax),%rbx
  801768:	48 b8 94 16 80 00 00 	movabs $0x801694,%rax
  80176f:	00 00 00 
  801772:	ff d0                	callq  *%rax
  801774:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80177a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801781:	41 89 c8             	mov    %ecx,%r8d
  801784:	48 89 d1             	mov    %rdx,%rcx
  801787:	48 89 da             	mov    %rbx,%rdx
  80178a:	89 c6                	mov    %eax,%esi
  80178c:	48 bf 78 1c 80 00 00 	movabs $0x801c78,%rdi
  801793:	00 00 00 
  801796:	b8 00 00 00 00       	mov    $0x0,%eax
  80179b:	49 b9 19 02 80 00 00 	movabs $0x800219,%r9
  8017a2:	00 00 00 
  8017a5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017a8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017af:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8017b6:	48 89 d6             	mov    %rdx,%rsi
  8017b9:	48 89 c7             	mov    %rax,%rdi
  8017bc:	48 b8 6d 01 80 00 00 	movabs $0x80016d,%rax
  8017c3:	00 00 00 
  8017c6:	ff d0                	callq  *%rax
	cprintf("\n");
  8017c8:	48 bf 9b 1c 80 00 00 	movabs $0x801c9b,%rdi
  8017cf:	00 00 00 
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d7:	48 ba 19 02 80 00 00 	movabs $0x800219,%rdx
  8017de:	00 00 00 
  8017e1:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8017e3:	cc                   	int3   
  8017e4:	eb fd                	jmp    8017e3 <_panic+0x111>
