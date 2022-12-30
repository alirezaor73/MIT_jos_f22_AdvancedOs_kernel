
obj/user/hello:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf 20 18 80 00 00 	movabs $0x801820,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 3b 02 80 00 00 	movabs $0x80023b,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 2e 18 80 00 00 	movabs $0x80182e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 3b 02 80 00 00 	movabs $0x80023b,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000ae:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b5:	00 00 00 
  8000b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c3:	7e 14                	jle    8000d9 <libmain+0x3a>
		binaryname = argv[0];
  8000c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c9:	48 8b 10             	mov    (%rax),%rdx
  8000cc:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000d3:	00 00 00 
  8000d6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e0:	48 89 d6             	mov    %rdx,%rsi
  8000e3:	89 c7                	mov    %eax,%edi
  8000e5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ec:	00 00 00 
  8000ef:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f1:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8000f8:	00 00 00 
  8000fb:	ff d0                	callq  *%rax
}
  8000fd:	c9                   	leaveq 
  8000fe:	c3                   	retq   

00000000008000ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ff:	55                   	push   %rbp
  800100:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800103:	bf 00 00 00 00       	mov    $0x0,%edi
  800108:	48 b8 72 16 80 00 00 	movabs $0x801672,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax
}
  800114:	5d                   	pop    %rbp
  800115:	c3                   	retq   

0000000000800116 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800116:	55                   	push   %rbp
  800117:	48 89 e5             	mov    %rsp,%rbp
  80011a:	48 83 ec 10          	sub    $0x10,%rsp
  80011e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800121:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800125:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800129:	8b 00                	mov    (%rax),%eax
  80012b:	8d 48 01             	lea    0x1(%rax),%ecx
  80012e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800132:	89 0a                	mov    %ecx,(%rdx)
  800134:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800137:	89 d1                	mov    %edx,%ecx
  800139:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80013d:	48 98                	cltq   
  80013f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800143:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800147:	8b 00                	mov    (%rax),%eax
  800149:	3d ff 00 00 00       	cmp    $0xff,%eax
  80014e:	75 2c                	jne    80017c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800154:	8b 00                	mov    (%rax),%eax
  800156:	48 98                	cltq   
  800158:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80015c:	48 83 c2 08          	add    $0x8,%rdx
  800160:	48 89 c6             	mov    %rax,%rsi
  800163:	48 89 d7             	mov    %rdx,%rdi
  800166:	48 b8 ea 15 80 00 00 	movabs $0x8015ea,%rax
  80016d:	00 00 00 
  800170:	ff d0                	callq  *%rax
        b->idx = 0;
  800172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800176:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80017c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800180:	8b 40 04             	mov    0x4(%rax),%eax
  800183:	8d 50 01             	lea    0x1(%rax),%edx
  800186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80018d:	c9                   	leaveq 
  80018e:	c3                   	retq   

000000000080018f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80018f:	55                   	push   %rbp
  800190:	48 89 e5             	mov    %rsp,%rbp
  800193:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80019a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001a1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001a8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001af:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001b6:	48 8b 0a             	mov    (%rdx),%rcx
  8001b9:	48 89 08             	mov    %rcx,(%rax)
  8001bc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001c0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001c4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001c8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001d3:	00 00 00 
    b.cnt = 0;
  8001d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001dd:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001e0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001e7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001ee:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f5:	48 89 c6             	mov    %rax,%rsi
  8001f8:	48 bf 16 01 80 00 00 	movabs $0x800116,%rdi
  8001ff:	00 00 00 
  800202:	48 b8 ee 05 80 00 00 	movabs $0x8005ee,%rax
  800209:	00 00 00 
  80020c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80020e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800214:	48 98                	cltq   
  800216:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80021d:	48 83 c2 08          	add    $0x8,%rdx
  800221:	48 89 c6             	mov    %rax,%rsi
  800224:	48 89 d7             	mov    %rdx,%rdi
  800227:	48 b8 ea 15 80 00 00 	movabs $0x8015ea,%rax
  80022e:	00 00 00 
  800231:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800233:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800239:	c9                   	leaveq 
  80023a:	c3                   	retq   

000000000080023b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
  80023f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800246:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80024d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800254:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80025b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800262:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800269:	84 c0                	test   %al,%al
  80026b:	74 20                	je     80028d <cprintf+0x52>
  80026d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800271:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800275:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800279:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80027d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800281:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800285:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800289:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80028d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800294:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80029b:	00 00 00 
  80029e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002a5:	00 00 00 
  8002a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002ac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002b3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002ba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002c1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002c8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002cf:	48 8b 0a             	mov    (%rdx),%rcx
  8002d2:	48 89 08             	mov    %rcx,(%rax)
  8002d5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002d9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002dd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002e1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002e5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002ec:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002f3:	48 89 d6             	mov    %rdx,%rsi
  8002f6:	48 89 c7             	mov    %rax,%rdi
  8002f9:	48 b8 8f 01 80 00 00 	movabs $0x80018f,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
  800305:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80030b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800311:	c9                   	leaveq 
  800312:	c3                   	retq   

0000000000800313 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800313:	55                   	push   %rbp
  800314:	48 89 e5             	mov    %rsp,%rbp
  800317:	53                   	push   %rbx
  800318:	48 83 ec 38          	sub    $0x38,%rsp
  80031c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800320:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800324:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800328:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80032b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80032f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800333:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800336:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80033a:	77 3b                	ja     800377 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80033c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80033f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800343:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800346:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80034a:	ba 00 00 00 00       	mov    $0x0,%edx
  80034f:	48 f7 f3             	div    %rbx
  800352:	48 89 c2             	mov    %rax,%rdx
  800355:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800358:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80035b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80035f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800363:	41 89 f9             	mov    %edi,%r9d
  800366:	48 89 c7             	mov    %rax,%rdi
  800369:	48 b8 13 03 80 00 00 	movabs $0x800313,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
  800375:	eb 1e                	jmp    800395 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800377:	eb 12                	jmp    80038b <printnum+0x78>
			putch(padc, putdat);
  800379:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80037d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800384:	48 89 ce             	mov    %rcx,%rsi
  800387:	89 d7                	mov    %edx,%edi
  800389:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80038f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800393:	7f e4                	jg     800379 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800395:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80039c:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a1:	48 f7 f1             	div    %rcx
  8003a4:	48 89 d0             	mov    %rdx,%rax
  8003a7:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  8003ae:	00 00 00 
  8003b1:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003b5:	0f be d0             	movsbl %al,%edx
  8003b8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c0:	48 89 ce             	mov    %rcx,%rsi
  8003c3:	89 d7                	mov    %edx,%edi
  8003c5:	ff d0                	callq  *%rax
}
  8003c7:	48 83 c4 38          	add    $0x38,%rsp
  8003cb:	5b                   	pop    %rbx
  8003cc:	5d                   	pop    %rbp
  8003cd:	c3                   	retq   

00000000008003ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003da:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003dd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003e1:	7e 52                	jle    800435 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003e7:	8b 00                	mov    (%rax),%eax
  8003e9:	83 f8 30             	cmp    $0x30,%eax
  8003ec:	73 24                	jae    800412 <getuint+0x44>
  8003ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8003f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fa:	8b 00                	mov    (%rax),%eax
  8003fc:	89 c0                	mov    %eax,%eax
  8003fe:	48 01 d0             	add    %rdx,%rax
  800401:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800405:	8b 12                	mov    (%rdx),%edx
  800407:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80040a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80040e:	89 0a                	mov    %ecx,(%rdx)
  800410:	eb 17                	jmp    800429 <getuint+0x5b>
  800412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800416:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80041a:	48 89 d0             	mov    %rdx,%rax
  80041d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800421:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800425:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800429:	48 8b 00             	mov    (%rax),%rax
  80042c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800430:	e9 a3 00 00 00       	jmpq   8004d8 <getuint+0x10a>
	else if (lflag)
  800435:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800439:	74 4f                	je     80048a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80043b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043f:	8b 00                	mov    (%rax),%eax
  800441:	83 f8 30             	cmp    $0x30,%eax
  800444:	73 24                	jae    80046a <getuint+0x9c>
  800446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80044e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800452:	8b 00                	mov    (%rax),%eax
  800454:	89 c0                	mov    %eax,%eax
  800456:	48 01 d0             	add    %rdx,%rax
  800459:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045d:	8b 12                	mov    (%rdx),%edx
  80045f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800462:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800466:	89 0a                	mov    %ecx,(%rdx)
  800468:	eb 17                	jmp    800481 <getuint+0xb3>
  80046a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800472:	48 89 d0             	mov    %rdx,%rax
  800475:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800479:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800481:	48 8b 00             	mov    (%rax),%rax
  800484:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800488:	eb 4e                	jmp    8004d8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80048a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048e:	8b 00                	mov    (%rax),%eax
  800490:	83 f8 30             	cmp    $0x30,%eax
  800493:	73 24                	jae    8004b9 <getuint+0xeb>
  800495:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800499:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80049d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a1:	8b 00                	mov    (%rax),%eax
  8004a3:	89 c0                	mov    %eax,%eax
  8004a5:	48 01 d0             	add    %rdx,%rax
  8004a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ac:	8b 12                	mov    (%rdx),%edx
  8004ae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b5:	89 0a                	mov    %ecx,(%rdx)
  8004b7:	eb 17                	jmp    8004d0 <getuint+0x102>
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004c1:	48 89 d0             	mov    %rdx,%rax
  8004c4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	89 c0                	mov    %eax,%eax
  8004d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004dc:	c9                   	leaveq 
  8004dd:	c3                   	retq   

00000000008004de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004de:	55                   	push   %rbp
  8004df:	48 89 e5             	mov    %rsp,%rbp
  8004e2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004ea:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004ed:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004f1:	7e 52                	jle    800545 <getint+0x67>
		x=va_arg(*ap, long long);
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	8b 00                	mov    (%rax),%eax
  8004f9:	83 f8 30             	cmp    $0x30,%eax
  8004fc:	73 24                	jae    800522 <getint+0x44>
  8004fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800502:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050a:	8b 00                	mov    (%rax),%eax
  80050c:	89 c0                	mov    %eax,%eax
  80050e:	48 01 d0             	add    %rdx,%rax
  800511:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800515:	8b 12                	mov    (%rdx),%edx
  800517:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80051a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051e:	89 0a                	mov    %ecx,(%rdx)
  800520:	eb 17                	jmp    800539 <getint+0x5b>
  800522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800526:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80052a:	48 89 d0             	mov    %rdx,%rax
  80052d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800531:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800535:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800539:	48 8b 00             	mov    (%rax),%rax
  80053c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800540:	e9 a3 00 00 00       	jmpq   8005e8 <getint+0x10a>
	else if (lflag)
  800545:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800549:	74 4f                	je     80059a <getint+0xbc>
		x=va_arg(*ap, long);
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	8b 00                	mov    (%rax),%eax
  800551:	83 f8 30             	cmp    $0x30,%eax
  800554:	73 24                	jae    80057a <getint+0x9c>
  800556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80055e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800562:	8b 00                	mov    (%rax),%eax
  800564:	89 c0                	mov    %eax,%eax
  800566:	48 01 d0             	add    %rdx,%rax
  800569:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056d:	8b 12                	mov    (%rdx),%edx
  80056f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800572:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800576:	89 0a                	mov    %ecx,(%rdx)
  800578:	eb 17                	jmp    800591 <getint+0xb3>
  80057a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800582:	48 89 d0             	mov    %rdx,%rax
  800585:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800589:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800591:	48 8b 00             	mov    (%rax),%rax
  800594:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800598:	eb 4e                	jmp    8005e8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	8b 00                	mov    (%rax),%eax
  8005a0:	83 f8 30             	cmp    $0x30,%eax
  8005a3:	73 24                	jae    8005c9 <getint+0xeb>
  8005a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b1:	8b 00                	mov    (%rax),%eax
  8005b3:	89 c0                	mov    %eax,%eax
  8005b5:	48 01 d0             	add    %rdx,%rax
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	8b 12                	mov    (%rdx),%edx
  8005be:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c5:	89 0a                	mov    %ecx,(%rdx)
  8005c7:	eb 17                	jmp    8005e0 <getint+0x102>
  8005c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005d1:	48 89 d0             	mov    %rdx,%rax
  8005d4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005e0:	8b 00                	mov    (%rax),%eax
  8005e2:	48 98                	cltq   
  8005e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005ec:	c9                   	leaveq 
  8005ed:	c3                   	retq   

00000000008005ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ee:	55                   	push   %rbp
  8005ef:	48 89 e5             	mov    %rsp,%rbp
  8005f2:	41 54                	push   %r12
  8005f4:	53                   	push   %rbx
  8005f5:	48 83 ec 60          	sub    $0x60,%rsp
  8005f9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8005fd:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800601:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800605:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800609:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80060d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800611:	48 8b 0a             	mov    (%rdx),%rcx
  800614:	48 89 08             	mov    %rcx,(%rax)
  800617:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80061b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80061f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800623:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800627:	eb 17                	jmp    800640 <vprintfmt+0x52>
			if (ch == '\0')
  800629:	85 db                	test   %ebx,%ebx
  80062b:	0f 84 df 04 00 00    	je     800b10 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800631:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800635:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800639:	48 89 d6             	mov    %rdx,%rsi
  80063c:	89 df                	mov    %ebx,%edi
  80063e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800640:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800644:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800648:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80064c:	0f b6 00             	movzbl (%rax),%eax
  80064f:	0f b6 d8             	movzbl %al,%ebx
  800652:	83 fb 25             	cmp    $0x25,%ebx
  800655:	75 d2                	jne    800629 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800657:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80065b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800662:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800669:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800670:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800677:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80067b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80067f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800683:	0f b6 00             	movzbl (%rax),%eax
  800686:	0f b6 d8             	movzbl %al,%ebx
  800689:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80068c:	83 f8 55             	cmp    $0x55,%eax
  80068f:	0f 87 47 04 00 00    	ja     800adc <vprintfmt+0x4ee>
  800695:	89 c0                	mov    %eax,%eax
  800697:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80069e:	00 
  80069f:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  8006a6:	00 00 00 
  8006a9:	48 01 d0             	add    %rdx,%rax
  8006ac:	48 8b 00             	mov    (%rax),%rax
  8006af:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006b1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006b5:	eb c0                	jmp    800677 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006bb:	eb ba                	jmp    800677 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006bd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006c4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006c7:	89 d0                	mov    %edx,%eax
  8006c9:	c1 e0 02             	shl    $0x2,%eax
  8006cc:	01 d0                	add    %edx,%eax
  8006ce:	01 c0                	add    %eax,%eax
  8006d0:	01 d8                	add    %ebx,%eax
  8006d2:	83 e8 30             	sub    $0x30,%eax
  8006d5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006d8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006dc:	0f b6 00             	movzbl (%rax),%eax
  8006df:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e2:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e5:	7e 0c                	jle    8006f3 <vprintfmt+0x105>
  8006e7:	83 fb 39             	cmp    $0x39,%ebx
  8006ea:	7f 07                	jg     8006f3 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ec:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f1:	eb d1                	jmp    8006c4 <vprintfmt+0xd6>
			goto process_precision;
  8006f3:	eb 58                	jmp    80074d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8006f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006f8:	83 f8 30             	cmp    $0x30,%eax
  8006fb:	73 17                	jae    800714 <vprintfmt+0x126>
  8006fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800701:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800704:	89 c0                	mov    %eax,%eax
  800706:	48 01 d0             	add    %rdx,%rax
  800709:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80070c:	83 c2 08             	add    $0x8,%edx
  80070f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800712:	eb 0f                	jmp    800723 <vprintfmt+0x135>
  800714:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800718:	48 89 d0             	mov    %rdx,%rax
  80071b:	48 83 c2 08          	add    $0x8,%rdx
  80071f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800723:	8b 00                	mov    (%rax),%eax
  800725:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800728:	eb 23                	jmp    80074d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80072a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80072e:	79 0c                	jns    80073c <vprintfmt+0x14e>
				width = 0;
  800730:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800737:	e9 3b ff ff ff       	jmpq   800677 <vprintfmt+0x89>
  80073c:	e9 36 ff ff ff       	jmpq   800677 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800741:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800748:	e9 2a ff ff ff       	jmpq   800677 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80074d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800751:	79 12                	jns    800765 <vprintfmt+0x177>
				width = precision, precision = -1;
  800753:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800756:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800759:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800760:	e9 12 ff ff ff       	jmpq   800677 <vprintfmt+0x89>
  800765:	e9 0d ff ff ff       	jmpq   800677 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80076a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80076e:	e9 04 ff ff ff       	jmpq   800677 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800773:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800776:	83 f8 30             	cmp    $0x30,%eax
  800779:	73 17                	jae    800792 <vprintfmt+0x1a4>
  80077b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80077f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800782:	89 c0                	mov    %eax,%eax
  800784:	48 01 d0             	add    %rdx,%rax
  800787:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80078a:	83 c2 08             	add    $0x8,%edx
  80078d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800790:	eb 0f                	jmp    8007a1 <vprintfmt+0x1b3>
  800792:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800796:	48 89 d0             	mov    %rdx,%rax
  800799:	48 83 c2 08          	add    $0x8,%rdx
  80079d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007a1:	8b 10                	mov    (%rax),%edx
  8007a3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ab:	48 89 ce             	mov    %rcx,%rsi
  8007ae:	89 d7                	mov    %edx,%edi
  8007b0:	ff d0                	callq  *%rax
			break;
  8007b2:	e9 53 03 00 00       	jmpq   800b0a <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ba:	83 f8 30             	cmp    $0x30,%eax
  8007bd:	73 17                	jae    8007d6 <vprintfmt+0x1e8>
  8007bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c6:	89 c0                	mov    %eax,%eax
  8007c8:	48 01 d0             	add    %rdx,%rax
  8007cb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ce:	83 c2 08             	add    $0x8,%edx
  8007d1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d4:	eb 0f                	jmp    8007e5 <vprintfmt+0x1f7>
  8007d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007da:	48 89 d0             	mov    %rdx,%rax
  8007dd:	48 83 c2 08          	add    $0x8,%rdx
  8007e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007e7:	85 db                	test   %ebx,%ebx
  8007e9:	79 02                	jns    8007ed <vprintfmt+0x1ff>
				err = -err;
  8007eb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007ed:	83 fb 15             	cmp    $0x15,%ebx
  8007f0:	7f 16                	jg     800808 <vprintfmt+0x21a>
  8007f2:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8007f9:	00 00 00 
  8007fc:	48 63 d3             	movslq %ebx,%rdx
  8007ff:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800803:	4d 85 e4             	test   %r12,%r12
  800806:	75 2e                	jne    800836 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800808:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80080c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800810:	89 d9                	mov    %ebx,%ecx
  800812:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800819:	00 00 00 
  80081c:	48 89 c7             	mov    %rax,%rdi
  80081f:	b8 00 00 00 00       	mov    $0x0,%eax
  800824:	49 b8 19 0b 80 00 00 	movabs $0x800b19,%r8
  80082b:	00 00 00 
  80082e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800831:	e9 d4 02 00 00       	jmpq   800b0a <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800836:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80083a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80083e:	4c 89 e1             	mov    %r12,%rcx
  800841:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800848:	00 00 00 
  80084b:	48 89 c7             	mov    %rax,%rdi
  80084e:	b8 00 00 00 00       	mov    $0x0,%eax
  800853:	49 b8 19 0b 80 00 00 	movabs $0x800b19,%r8
  80085a:	00 00 00 
  80085d:	41 ff d0             	callq  *%r8
			break;
  800860:	e9 a5 02 00 00       	jmpq   800b0a <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800865:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800868:	83 f8 30             	cmp    $0x30,%eax
  80086b:	73 17                	jae    800884 <vprintfmt+0x296>
  80086d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800871:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800874:	89 c0                	mov    %eax,%eax
  800876:	48 01 d0             	add    %rdx,%rax
  800879:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80087c:	83 c2 08             	add    $0x8,%edx
  80087f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800882:	eb 0f                	jmp    800893 <vprintfmt+0x2a5>
  800884:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800888:	48 89 d0             	mov    %rdx,%rax
  80088b:	48 83 c2 08          	add    $0x8,%rdx
  80088f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800893:	4c 8b 20             	mov    (%rax),%r12
  800896:	4d 85 e4             	test   %r12,%r12
  800899:	75 0a                	jne    8008a5 <vprintfmt+0x2b7>
				p = "(null)";
  80089b:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  8008a2:	00 00 00 
			if (width > 0 && padc != '-')
  8008a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008a9:	7e 3f                	jle    8008ea <vprintfmt+0x2fc>
  8008ab:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008af:	74 39                	je     8008ea <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008b4:	48 98                	cltq   
  8008b6:	48 89 c6             	mov    %rax,%rsi
  8008b9:	4c 89 e7             	mov    %r12,%rdi
  8008bc:	48 b8 c5 0d 80 00 00 	movabs $0x800dc5,%rax
  8008c3:	00 00 00 
  8008c6:	ff d0                	callq  *%rax
  8008c8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008cb:	eb 17                	jmp    8008e4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008cd:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008d1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008d5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d9:	48 89 ce             	mov    %rcx,%rsi
  8008dc:	89 d7                	mov    %edx,%edi
  8008de:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e8:	7f e3                	jg     8008cd <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ea:	eb 37                	jmp    800923 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008f0:	74 1e                	je     800910 <vprintfmt+0x322>
  8008f2:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f5:	7e 05                	jle    8008fc <vprintfmt+0x30e>
  8008f7:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fa:	7e 14                	jle    800910 <vprintfmt+0x322>
					putch('?', putdat);
  8008fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800900:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800904:	48 89 d6             	mov    %rdx,%rsi
  800907:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80090c:	ff d0                	callq  *%rax
  80090e:	eb 0f                	jmp    80091f <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800910:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800914:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800918:	48 89 d6             	mov    %rdx,%rsi
  80091b:	89 df                	mov    %ebx,%edi
  80091d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800923:	4c 89 e0             	mov    %r12,%rax
  800926:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80092a:	0f b6 00             	movzbl (%rax),%eax
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 10                	je     800944 <vprintfmt+0x356>
  800934:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800938:	78 b2                	js     8008ec <vprintfmt+0x2fe>
  80093a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80093e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800942:	79 a8                	jns    8008ec <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800944:	eb 16                	jmp    80095c <vprintfmt+0x36e>
				putch(' ', putdat);
  800946:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094e:	48 89 d6             	mov    %rdx,%rsi
  800951:	bf 20 00 00 00       	mov    $0x20,%edi
  800956:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800960:	7f e4                	jg     800946 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800962:	e9 a3 01 00 00       	jmpq   800b0a <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800967:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80096b:	be 03 00 00 00       	mov    $0x3,%esi
  800970:	48 89 c7             	mov    %rax,%rdi
  800973:	48 b8 de 04 80 00 00 	movabs $0x8004de,%rax
  80097a:	00 00 00 
  80097d:	ff d0                	callq  *%rax
  80097f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800987:	48 85 c0             	test   %rax,%rax
  80098a:	79 1d                	jns    8009a9 <vprintfmt+0x3bb>
				putch('-', putdat);
  80098c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800990:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800994:	48 89 d6             	mov    %rdx,%rsi
  800997:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80099c:	ff d0                	callq  *%rax
				num = -(long long) num;
  80099e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a2:	48 f7 d8             	neg    %rax
  8009a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009a9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009b0:	e9 e8 00 00 00       	jmpq   800a9d <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009b5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009b9:	be 03 00 00 00       	mov    $0x3,%esi
  8009be:	48 89 c7             	mov    %rax,%rdi
  8009c1:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  8009c8:	00 00 00 
  8009cb:	ff d0                	callq  *%rax
  8009cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009d1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009d8:	e9 c0 00 00 00       	jmpq   800a9d <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009dd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e5:	48 89 d6             	mov    %rdx,%rsi
  8009e8:	bf 58 00 00 00       	mov    $0x58,%edi
  8009ed:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f7:	48 89 d6             	mov    %rdx,%rsi
  8009fa:	bf 58 00 00 00       	mov    $0x58,%edi
  8009ff:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a09:	48 89 d6             	mov    %rdx,%rsi
  800a0c:	bf 58 00 00 00       	mov    $0x58,%edi
  800a11:	ff d0                	callq  *%rax
			break;
  800a13:	e9 f2 00 00 00       	jmpq   800b0a <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a20:	48 89 d6             	mov    %rdx,%rsi
  800a23:	bf 30 00 00 00       	mov    $0x30,%edi
  800a28:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a32:	48 89 d6             	mov    %rdx,%rsi
  800a35:	bf 78 00 00 00       	mov    $0x78,%edi
  800a3a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3f:	83 f8 30             	cmp    $0x30,%eax
  800a42:	73 17                	jae    800a5b <vprintfmt+0x46d>
  800a44:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4b:	89 c0                	mov    %eax,%eax
  800a4d:	48 01 d0             	add    %rdx,%rax
  800a50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a53:	83 c2 08             	add    $0x8,%edx
  800a56:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a59:	eb 0f                	jmp    800a6a <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a5f:	48 89 d0             	mov    %rdx,%rax
  800a62:	48 83 c2 08          	add    $0x8,%rdx
  800a66:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a71:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a78:	eb 23                	jmp    800a9d <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a7a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a7e:	be 03 00 00 00       	mov    $0x3,%esi
  800a83:	48 89 c7             	mov    %rax,%rdi
  800a86:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  800a8d:	00 00 00 
  800a90:	ff d0                	callq  *%rax
  800a92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a96:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a9d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800aa2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aa5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800aa8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aac:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab4:	45 89 c1             	mov    %r8d,%r9d
  800ab7:	41 89 f8             	mov    %edi,%r8d
  800aba:	48 89 c7             	mov    %rax,%rdi
  800abd:	48 b8 13 03 80 00 00 	movabs $0x800313,%rax
  800ac4:	00 00 00 
  800ac7:	ff d0                	callq  *%rax
			break;
  800ac9:	eb 3f                	jmp    800b0a <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800acf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad3:	48 89 d6             	mov    %rdx,%rsi
  800ad6:	89 df                	mov    %ebx,%edi
  800ad8:	ff d0                	callq  *%rax
			break;
  800ada:	eb 2e                	jmp    800b0a <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800adc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae4:	48 89 d6             	mov    %rdx,%rsi
  800ae7:	bf 25 00 00 00       	mov    $0x25,%edi
  800aec:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aee:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800af3:	eb 05                	jmp    800afa <vprintfmt+0x50c>
  800af5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800afa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800afe:	48 83 e8 01          	sub    $0x1,%rax
  800b02:	0f b6 00             	movzbl (%rax),%eax
  800b05:	3c 25                	cmp    $0x25,%al
  800b07:	75 ec                	jne    800af5 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b09:	90                   	nop
		}
	}
  800b0a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b0b:	e9 30 fb ff ff       	jmpq   800640 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b10:	48 83 c4 60          	add    $0x60,%rsp
  800b14:	5b                   	pop    %rbx
  800b15:	41 5c                	pop    %r12
  800b17:	5d                   	pop    %rbp
  800b18:	c3                   	retq   

0000000000800b19 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b19:	55                   	push   %rbp
  800b1a:	48 89 e5             	mov    %rsp,%rbp
  800b1d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b24:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b2b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b32:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b39:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b40:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b47:	84 c0                	test   %al,%al
  800b49:	74 20                	je     800b6b <printfmt+0x52>
  800b4b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b4f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b53:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b57:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b5b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b5f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b63:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b67:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b6b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b72:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b79:	00 00 00 
  800b7c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b83:	00 00 00 
  800b86:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b8a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b91:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b98:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ba6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bad:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bb4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bbb:	48 89 c7             	mov    %rax,%rdi
  800bbe:	48 b8 ee 05 80 00 00 	movabs $0x8005ee,%rax
  800bc5:	00 00 00 
  800bc8:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bca:	c9                   	leaveq 
  800bcb:	c3                   	retq   

0000000000800bcc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bcc:	55                   	push   %rbp
  800bcd:	48 89 e5             	mov    %rsp,%rbp
  800bd0:	48 83 ec 10          	sub    $0x10,%rsp
  800bd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bdf:	8b 40 10             	mov    0x10(%rax),%eax
  800be2:	8d 50 01             	lea    0x1(%rax),%edx
  800be5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf0:	48 8b 10             	mov    (%rax),%rdx
  800bf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bfb:	48 39 c2             	cmp    %rax,%rdx
  800bfe:	73 17                	jae    800c17 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c04:	48 8b 00             	mov    (%rax),%rax
  800c07:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c0f:	48 89 0a             	mov    %rcx,(%rdx)
  800c12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c15:	88 10                	mov    %dl,(%rax)
}
  800c17:	c9                   	leaveq 
  800c18:	c3                   	retq   

0000000000800c19 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c19:	55                   	push   %rbp
  800c1a:	48 89 e5             	mov    %rsp,%rbp
  800c1d:	48 83 ec 50          	sub    $0x50,%rsp
  800c21:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c25:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c28:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c2c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c30:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c34:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c38:	48 8b 0a             	mov    (%rdx),%rcx
  800c3b:	48 89 08             	mov    %rcx,(%rax)
  800c3e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c42:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c46:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c4a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c52:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c56:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c59:	48 98                	cltq   
  800c5b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c5f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c63:	48 01 d0             	add    %rdx,%rax
  800c66:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c71:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x65>
  800c78:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x6c>
		return -E_INVAL;
  800c7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c83:	eb 2f                	jmp    800cb4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c85:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c89:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c8d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c91:	48 89 c6             	mov    %rax,%rsi
  800c94:	48 bf cc 0b 80 00 00 	movabs $0x800bcc,%rdi
  800c9b:	00 00 00 
  800c9e:	48 b8 ee 05 80 00 00 	movabs $0x8005ee,%rax
  800ca5:	00 00 00 
  800ca8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800caa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cae:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cb1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cb4:	c9                   	leaveq 
  800cb5:	c3                   	retq   

0000000000800cb6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb6:	55                   	push   %rbp
  800cb7:	48 89 e5             	mov    %rsp,%rbp
  800cba:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cc1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cc8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cce:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cd5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cdc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ce3:	84 c0                	test   %al,%al
  800ce5:	74 20                	je     800d07 <snprintf+0x51>
  800ce7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ceb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cef:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cf3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cf7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cfb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d03:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d07:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d0e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d15:	00 00 00 
  800d18:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d1f:	00 00 00 
  800d22:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d26:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d2d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d34:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d3b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d42:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d49:	48 8b 0a             	mov    (%rdx),%rcx
  800d4c:	48 89 08             	mov    %rcx,(%rax)
  800d4f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d53:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d57:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d5b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d5f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d66:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d6d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d73:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d7a:	48 89 c7             	mov    %rax,%rdi
  800d7d:	48 b8 19 0c 80 00 00 	movabs $0x800c19,%rax
  800d84:	00 00 00 
  800d87:	ff d0                	callq  *%rax
  800d89:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d8f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d95:	c9                   	leaveq 
  800d96:	c3                   	retq   

0000000000800d97 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d97:	55                   	push   %rbp
  800d98:	48 89 e5             	mov    %rsp,%rbp
  800d9b:	48 83 ec 18          	sub    $0x18,%rsp
  800d9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800da3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800daa:	eb 09                	jmp    800db5 <strlen+0x1e>
		n++;
  800dac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800db5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db9:	0f b6 00             	movzbl (%rax),%eax
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 ec                	jne    800dac <strlen+0x15>
		n++;
	return n;
  800dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dc3:	c9                   	leaveq 
  800dc4:	c3                   	retq   

0000000000800dc5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	48 83 ec 20          	sub    $0x20,%rsp
  800dcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ddc:	eb 0e                	jmp    800dec <strnlen+0x27>
		n++;
  800dde:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800de7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800df1:	74 0b                	je     800dfe <strnlen+0x39>
  800df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df7:	0f b6 00             	movzbl (%rax),%eax
  800dfa:	84 c0                	test   %al,%al
  800dfc:	75 e0                	jne    800dde <strnlen+0x19>
		n++;
	return n;
  800dfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e01:	c9                   	leaveq 
  800e02:	c3                   	retq   

0000000000800e03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e03:	55                   	push   %rbp
  800e04:	48 89 e5             	mov    %rsp,%rbp
  800e07:	48 83 ec 20          	sub    $0x20,%rsp
  800e0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e1b:	90                   	nop
  800e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e20:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e24:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e28:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e2c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e30:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e34:	0f b6 12             	movzbl (%rdx),%edx
  800e37:	88 10                	mov    %dl,(%rax)
  800e39:	0f b6 00             	movzbl (%rax),%eax
  800e3c:	84 c0                	test   %al,%al
  800e3e:	75 dc                	jne    800e1c <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e44:	c9                   	leaveq 
  800e45:	c3                   	retq   

0000000000800e46 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e46:	55                   	push   %rbp
  800e47:	48 89 e5             	mov    %rsp,%rbp
  800e4a:	48 83 ec 20          	sub    $0x20,%rsp
  800e4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5a:	48 89 c7             	mov    %rax,%rdi
  800e5d:	48 b8 97 0d 80 00 00 	movabs $0x800d97,%rax
  800e64:	00 00 00 
  800e67:	ff d0                	callq  *%rax
  800e69:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e6f:	48 63 d0             	movslq %eax,%rdx
  800e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e76:	48 01 c2             	add    %rax,%rdx
  800e79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e7d:	48 89 c6             	mov    %rax,%rsi
  800e80:	48 89 d7             	mov    %rdx,%rdi
  800e83:	48 b8 03 0e 80 00 00 	movabs $0x800e03,%rax
  800e8a:	00 00 00 
  800e8d:	ff d0                	callq  *%rax
	return dst;
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e93:	c9                   	leaveq 
  800e94:	c3                   	retq   

0000000000800e95 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e95:	55                   	push   %rbp
  800e96:	48 89 e5             	mov    %rsp,%rbp
  800e99:	48 83 ec 28          	sub    $0x28,%rsp
  800e9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ea1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ea5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ea9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ead:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800eb1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800eb8:	00 
  800eb9:	eb 2a                	jmp    800ee5 <strncpy+0x50>
		*dst++ = *src;
  800ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ec3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ec7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ecb:	0f b6 12             	movzbl (%rdx),%edx
  800ece:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ed4:	0f b6 00             	movzbl (%rax),%eax
  800ed7:	84 c0                	test   %al,%al
  800ed9:	74 05                	je     800ee0 <strncpy+0x4b>
			src++;
  800edb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ee9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800eed:	72 cc                	jb     800ebb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ef3:	c9                   	leaveq 
  800ef4:	c3                   	retq   

0000000000800ef5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ef5:	55                   	push   %rbp
  800ef6:	48 89 e5             	mov    %rsp,%rbp
  800ef9:	48 83 ec 28          	sub    $0x28,%rsp
  800efd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f05:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f11:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f16:	74 3d                	je     800f55 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f18:	eb 1d                	jmp    800f37 <strlcpy+0x42>
			*dst++ = *src++;
  800f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f22:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f26:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f2e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f32:	0f b6 12             	movzbl (%rdx),%edx
  800f35:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f37:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f3c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f41:	74 0b                	je     800f4e <strlcpy+0x59>
  800f43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f47:	0f b6 00             	movzbl (%rax),%eax
  800f4a:	84 c0                	test   %al,%al
  800f4c:	75 cc                	jne    800f1a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f52:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f5d:	48 29 c2             	sub    %rax,%rdx
  800f60:	48 89 d0             	mov    %rdx,%rax
}
  800f63:	c9                   	leaveq 
  800f64:	c3                   	retq   

0000000000800f65 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f65:	55                   	push   %rbp
  800f66:	48 89 e5             	mov    %rsp,%rbp
  800f69:	48 83 ec 10          	sub    $0x10,%rsp
  800f6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f75:	eb 0a                	jmp    800f81 <strcmp+0x1c>
		p++, q++;
  800f77:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f7c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f85:	0f b6 00             	movzbl (%rax),%eax
  800f88:	84 c0                	test   %al,%al
  800f8a:	74 12                	je     800f9e <strcmp+0x39>
  800f8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f90:	0f b6 10             	movzbl (%rax),%edx
  800f93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f97:	0f b6 00             	movzbl (%rax),%eax
  800f9a:	38 c2                	cmp    %al,%dl
  800f9c:	74 d9                	je     800f77 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa2:	0f b6 00             	movzbl (%rax),%eax
  800fa5:	0f b6 d0             	movzbl %al,%edx
  800fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fac:	0f b6 00             	movzbl (%rax),%eax
  800faf:	0f b6 c0             	movzbl %al,%eax
  800fb2:	29 c2                	sub    %eax,%edx
  800fb4:	89 d0                	mov    %edx,%eax
}
  800fb6:	c9                   	leaveq 
  800fb7:	c3                   	retq   

0000000000800fb8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fb8:	55                   	push   %rbp
  800fb9:	48 89 e5             	mov    %rsp,%rbp
  800fbc:	48 83 ec 18          	sub    $0x18,%rsp
  800fc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fc8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fcc:	eb 0f                	jmp    800fdd <strncmp+0x25>
		n--, p++, q++;
  800fce:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fd3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fd8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fdd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fe2:	74 1d                	je     801001 <strncmp+0x49>
  800fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe8:	0f b6 00             	movzbl (%rax),%eax
  800feb:	84 c0                	test   %al,%al
  800fed:	74 12                	je     801001 <strncmp+0x49>
  800fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff3:	0f b6 10             	movzbl (%rax),%edx
  800ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffa:	0f b6 00             	movzbl (%rax),%eax
  800ffd:	38 c2                	cmp    %al,%dl
  800fff:	74 cd                	je     800fce <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801001:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801006:	75 07                	jne    80100f <strncmp+0x57>
		return 0;
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
  80100d:	eb 18                	jmp    801027 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80100f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	0f b6 d0             	movzbl %al,%edx
  801019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101d:	0f b6 00             	movzbl (%rax),%eax
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	c9                   	leaveq 
  801028:	c3                   	retq   

0000000000801029 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
  80102d:	48 83 ec 0c          	sub    $0xc,%rsp
  801031:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801035:	89 f0                	mov    %esi,%eax
  801037:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80103a:	eb 17                	jmp    801053 <strchr+0x2a>
		if (*s == c)
  80103c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801040:	0f b6 00             	movzbl (%rax),%eax
  801043:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801046:	75 06                	jne    80104e <strchr+0x25>
			return (char *) s;
  801048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104c:	eb 15                	jmp    801063 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80104e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	84 c0                	test   %al,%al
  80105c:	75 de                	jne    80103c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801063:	c9                   	leaveq 
  801064:	c3                   	retq   

0000000000801065 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801065:	55                   	push   %rbp
  801066:	48 89 e5             	mov    %rsp,%rbp
  801069:	48 83 ec 0c          	sub    $0xc,%rsp
  80106d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801071:	89 f0                	mov    %esi,%eax
  801073:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801076:	eb 13                	jmp    80108b <strfind+0x26>
		if (*s == c)
  801078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107c:	0f b6 00             	movzbl (%rax),%eax
  80107f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801082:	75 02                	jne    801086 <strfind+0x21>
			break;
  801084:	eb 10                	jmp    801096 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801086:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80108b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108f:	0f b6 00             	movzbl (%rax),%eax
  801092:	84 c0                	test   %al,%al
  801094:	75 e2                	jne    801078 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801096:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80109a:	c9                   	leaveq 
  80109b:	c3                   	retq   

000000000080109c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80109c:	55                   	push   %rbp
  80109d:	48 89 e5             	mov    %rsp,%rbp
  8010a0:	48 83 ec 18          	sub    $0x18,%rsp
  8010a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010b4:	75 06                	jne    8010bc <memset+0x20>
		return v;
  8010b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ba:	eb 69                	jmp    801125 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c0:	83 e0 03             	and    $0x3,%eax
  8010c3:	48 85 c0             	test   %rax,%rax
  8010c6:	75 48                	jne    801110 <memset+0x74>
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cc:	83 e0 03             	and    $0x3,%eax
  8010cf:	48 85 c0             	test   %rax,%rax
  8010d2:	75 3c                	jne    801110 <memset+0x74>
		c &= 0xFF;
  8010d4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010de:	c1 e0 18             	shl    $0x18,%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e6:	c1 e0 10             	shl    $0x10,%eax
  8010e9:	09 c2                	or     %eax,%edx
  8010eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010ee:	c1 e0 08             	shl    $0x8,%eax
  8010f1:	09 d0                	or     %edx,%eax
  8010f3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	48 c1 e8 02          	shr    $0x2,%rax
  8010fe:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801101:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801105:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801108:	48 89 d7             	mov    %rdx,%rdi
  80110b:	fc                   	cld    
  80110c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80110e:	eb 11                	jmp    801121 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801110:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801117:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80111b:	48 89 d7             	mov    %rdx,%rdi
  80111e:	fc                   	cld    
  80111f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801125:	c9                   	leaveq 
  801126:	c3                   	retq   

0000000000801127 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	48 83 ec 28          	sub    $0x28,%rsp
  80112f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801133:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801137:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80113b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801147:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80114b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801153:	0f 83 88 00 00 00    	jae    8011e1 <memmove+0xba>
  801159:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80115d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801161:	48 01 d0             	add    %rdx,%rax
  801164:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801168:	76 77                	jbe    8011e1 <memmove+0xba>
		s += n;
  80116a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801176:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80117a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117e:	83 e0 03             	and    $0x3,%eax
  801181:	48 85 c0             	test   %rax,%rax
  801184:	75 3b                	jne    8011c1 <memmove+0x9a>
  801186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118a:	83 e0 03             	and    $0x3,%eax
  80118d:	48 85 c0             	test   %rax,%rax
  801190:	75 2f                	jne    8011c1 <memmove+0x9a>
  801192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801196:	83 e0 03             	and    $0x3,%eax
  801199:	48 85 c0             	test   %rax,%rax
  80119c:	75 23                	jne    8011c1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80119e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a2:	48 83 e8 04          	sub    $0x4,%rax
  8011a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011aa:	48 83 ea 04          	sub    $0x4,%rdx
  8011ae:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011b2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011b6:	48 89 c7             	mov    %rax,%rdi
  8011b9:	48 89 d6             	mov    %rdx,%rsi
  8011bc:	fd                   	std    
  8011bd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011bf:	eb 1d                	jmp    8011de <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d5:	48 89 d7             	mov    %rdx,%rdi
  8011d8:	48 89 c1             	mov    %rax,%rcx
  8011db:	fd                   	std    
  8011dc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011de:	fc                   	cld    
  8011df:	eb 57                	jmp    801238 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e5:	83 e0 03             	and    $0x3,%eax
  8011e8:	48 85 c0             	test   %rax,%rax
  8011eb:	75 36                	jne    801223 <memmove+0xfc>
  8011ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f1:	83 e0 03             	and    $0x3,%eax
  8011f4:	48 85 c0             	test   %rax,%rax
  8011f7:	75 2a                	jne    801223 <memmove+0xfc>
  8011f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011fd:	83 e0 03             	and    $0x3,%eax
  801200:	48 85 c0             	test   %rax,%rax
  801203:	75 1e                	jne    801223 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801205:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801209:	48 c1 e8 02          	shr    $0x2,%rax
  80120d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801214:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801218:	48 89 c7             	mov    %rax,%rdi
  80121b:	48 89 d6             	mov    %rdx,%rsi
  80121e:	fc                   	cld    
  80121f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801221:	eb 15                	jmp    801238 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801227:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80122b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80122f:	48 89 c7             	mov    %rax,%rdi
  801232:	48 89 d6             	mov    %rdx,%rsi
  801235:	fc                   	cld    
  801236:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80123c:	c9                   	leaveq 
  80123d:	c3                   	retq   

000000000080123e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80123e:	55                   	push   %rbp
  80123f:	48 89 e5             	mov    %rsp,%rbp
  801242:	48 83 ec 18          	sub    $0x18,%rsp
  801246:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80124e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801252:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801256:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80125a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125e:	48 89 ce             	mov    %rcx,%rsi
  801261:	48 89 c7             	mov    %rax,%rdi
  801264:	48 b8 27 11 80 00 00 	movabs $0x801127,%rax
  80126b:	00 00 00 
  80126e:	ff d0                	callq  *%rax
}
  801270:	c9                   	leaveq 
  801271:	c3                   	retq   

0000000000801272 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801272:	55                   	push   %rbp
  801273:	48 89 e5             	mov    %rsp,%rbp
  801276:	48 83 ec 28          	sub    $0x28,%rsp
  80127a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801282:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80128e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801292:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801296:	eb 36                	jmp    8012ce <memcmp+0x5c>
		if (*s1 != *s2)
  801298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129c:	0f b6 10             	movzbl (%rax),%edx
  80129f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a3:	0f b6 00             	movzbl (%rax),%eax
  8012a6:	38 c2                	cmp    %al,%dl
  8012a8:	74 1a                	je     8012c4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	0f b6 d0             	movzbl %al,%edx
  8012b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	0f b6 c0             	movzbl %al,%eax
  8012be:	29 c2                	sub    %eax,%edx
  8012c0:	89 d0                	mov    %edx,%eax
  8012c2:	eb 20                	jmp    8012e4 <memcmp+0x72>
		s1++, s2++;
  8012c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012da:	48 85 c0             	test   %rax,%rax
  8012dd:	75 b9                	jne    801298 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e4:	c9                   	leaveq 
  8012e5:	c3                   	retq   

00000000008012e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012e6:	55                   	push   %rbp
  8012e7:	48 89 e5             	mov    %rsp,%rbp
  8012ea:	48 83 ec 28          	sub    $0x28,%rsp
  8012ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801301:	48 01 d0             	add    %rdx,%rax
  801304:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801308:	eb 15                	jmp    80131f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80130a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130e:	0f b6 10             	movzbl (%rax),%edx
  801311:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801314:	38 c2                	cmp    %al,%dl
  801316:	75 02                	jne    80131a <memfind+0x34>
			break;
  801318:	eb 0f                	jmp    801329 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80131a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80131f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801323:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801327:	72 e1                	jb     80130a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80132d:	c9                   	leaveq 
  80132e:	c3                   	retq   

000000000080132f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80132f:	55                   	push   %rbp
  801330:	48 89 e5             	mov    %rsp,%rbp
  801333:	48 83 ec 34          	sub    $0x34,%rsp
  801337:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80133b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80133f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801349:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801350:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801351:	eb 05                	jmp    801358 <strtol+0x29>
		s++;
  801353:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801358:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	3c 20                	cmp    $0x20,%al
  801361:	74 f0                	je     801353 <strtol+0x24>
  801363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801367:	0f b6 00             	movzbl (%rax),%eax
  80136a:	3c 09                	cmp    $0x9,%al
  80136c:	74 e5                	je     801353 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80136e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	3c 2b                	cmp    $0x2b,%al
  801377:	75 07                	jne    801380 <strtol+0x51>
		s++;
  801379:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80137e:	eb 17                	jmp    801397 <strtol+0x68>
	else if (*s == '-')
  801380:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0c                	jne    801397 <strtol+0x68>
		s++, neg = 1;
  80138b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801390:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801397:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80139b:	74 06                	je     8013a3 <strtol+0x74>
  80139d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013a1:	75 28                	jne    8013cb <strtol+0x9c>
  8013a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a7:	0f b6 00             	movzbl (%rax),%eax
  8013aa:	3c 30                	cmp    $0x30,%al
  8013ac:	75 1d                	jne    8013cb <strtol+0x9c>
  8013ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b2:	48 83 c0 01          	add    $0x1,%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	3c 78                	cmp    $0x78,%al
  8013bb:	75 0e                	jne    8013cb <strtol+0x9c>
		s += 2, base = 16;
  8013bd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013c2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013c9:	eb 2c                	jmp    8013f7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013cf:	75 19                	jne    8013ea <strtol+0xbb>
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	0f b6 00             	movzbl (%rax),%eax
  8013d8:	3c 30                	cmp    $0x30,%al
  8013da:	75 0e                	jne    8013ea <strtol+0xbb>
		s++, base = 8;
  8013dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013e8:	eb 0d                	jmp    8013f7 <strtol+0xc8>
	else if (base == 0)
  8013ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ee:	75 07                	jne    8013f7 <strtol+0xc8>
		base = 10;
  8013f0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fb:	0f b6 00             	movzbl (%rax),%eax
  8013fe:	3c 2f                	cmp    $0x2f,%al
  801400:	7e 1d                	jle    80141f <strtol+0xf0>
  801402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	3c 39                	cmp    $0x39,%al
  80140b:	7f 12                	jg     80141f <strtol+0xf0>
			dig = *s - '0';
  80140d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801411:	0f b6 00             	movzbl (%rax),%eax
  801414:	0f be c0             	movsbl %al,%eax
  801417:	83 e8 30             	sub    $0x30,%eax
  80141a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80141d:	eb 4e                	jmp    80146d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	3c 60                	cmp    $0x60,%al
  801428:	7e 1d                	jle    801447 <strtol+0x118>
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	3c 7a                	cmp    $0x7a,%al
  801433:	7f 12                	jg     801447 <strtol+0x118>
			dig = *s - 'a' + 10;
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	0f be c0             	movsbl %al,%eax
  80143f:	83 e8 57             	sub    $0x57,%eax
  801442:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801445:	eb 26                	jmp    80146d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	0f b6 00             	movzbl (%rax),%eax
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 48                	jle    80149a <strtol+0x16b>
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	3c 5a                	cmp    $0x5a,%al
  80145b:	7f 3d                	jg     80149a <strtol+0x16b>
			dig = *s - 'A' + 10;
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	0f b6 00             	movzbl (%rax),%eax
  801464:	0f be c0             	movsbl %al,%eax
  801467:	83 e8 37             	sub    $0x37,%eax
  80146a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80146d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801470:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801473:	7c 02                	jl     801477 <strtol+0x148>
			break;
  801475:	eb 23                	jmp    80149a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801477:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80147c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80147f:	48 98                	cltq   
  801481:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801486:	48 89 c2             	mov    %rax,%rdx
  801489:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80148c:	48 98                	cltq   
  80148e:	48 01 d0             	add    %rdx,%rax
  801491:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801495:	e9 5d ff ff ff       	jmpq   8013f7 <strtol+0xc8>

	if (endptr)
  80149a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80149f:	74 0b                	je     8014ac <strtol+0x17d>
		*endptr = (char *) s;
  8014a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014a9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014b0:	74 09                	je     8014bb <strtol+0x18c>
  8014b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b6:	48 f7 d8             	neg    %rax
  8014b9:	eb 04                	jmp    8014bf <strtol+0x190>
  8014bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014bf:	c9                   	leaveq 
  8014c0:	c3                   	retq   

00000000008014c1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014c1:	55                   	push   %rbp
  8014c2:	48 89 e5             	mov    %rsp,%rbp
  8014c5:	48 83 ec 30          	sub    $0x30,%rsp
  8014c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014d9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014e3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014e7:	75 06                	jne    8014ef <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ed:	eb 6b                	jmp    80155a <strstr+0x99>

	len = strlen(str);
  8014ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f3:	48 89 c7             	mov    %rax,%rdi
  8014f6:	48 b8 97 0d 80 00 00 	movabs $0x800d97,%rax
  8014fd:	00 00 00 
  801500:	ff d0                	callq  *%rax
  801502:	48 98                	cltq   
  801504:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801508:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801510:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801514:	0f b6 00             	movzbl (%rax),%eax
  801517:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80151a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80151e:	75 07                	jne    801527 <strstr+0x66>
				return (char *) 0;
  801520:	b8 00 00 00 00       	mov    $0x0,%eax
  801525:	eb 33                	jmp    80155a <strstr+0x99>
		} while (sc != c);
  801527:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80152b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80152e:	75 d8                	jne    801508 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801530:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801534:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153c:	48 89 ce             	mov    %rcx,%rsi
  80153f:	48 89 c7             	mov    %rax,%rdi
  801542:	48 b8 b8 0f 80 00 00 	movabs $0x800fb8,%rax
  801549:	00 00 00 
  80154c:	ff d0                	callq  *%rax
  80154e:	85 c0                	test   %eax,%eax
  801550:	75 b6                	jne    801508 <strstr+0x47>

	return (char *) (in - 1);
  801552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801556:	48 83 e8 01          	sub    $0x1,%rax
}
  80155a:	c9                   	leaveq 
  80155b:	c3                   	retq   

000000000080155c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80155c:	55                   	push   %rbp
  80155d:	48 89 e5             	mov    %rsp,%rbp
  801560:	53                   	push   %rbx
  801561:	48 83 ec 48          	sub    $0x48,%rsp
  801565:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801568:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80156b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80156f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801573:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801577:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80157b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80157e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801582:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801586:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80158a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80158e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801592:	4c 89 c3             	mov    %r8,%rbx
  801595:	cd 30                	int    $0x30
  801597:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80159b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80159f:	74 3e                	je     8015df <syscall+0x83>
  8015a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a6:	7e 37                	jle    8015df <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015af:	49 89 d0             	mov    %rdx,%r8
  8015b2:	89 c1                	mov    %eax,%ecx
  8015b4:	48 ba 68 1c 80 00 00 	movabs $0x801c68,%rdx
  8015bb:	00 00 00 
  8015be:	be 23 00 00 00       	mov    $0x23,%esi
  8015c3:	48 bf 85 1c 80 00 00 	movabs $0x801c85,%rdi
  8015ca:	00 00 00 
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	49 b9 f4 16 80 00 00 	movabs $0x8016f4,%r9
  8015d9:	00 00 00 
  8015dc:	41 ff d1             	callq  *%r9

	return ret;
  8015df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e3:	48 83 c4 48          	add    $0x48,%rsp
  8015e7:	5b                   	pop    %rbx
  8015e8:	5d                   	pop    %rbp
  8015e9:	c3                   	retq   

00000000008015ea <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015ea:	55                   	push   %rbp
  8015eb:	48 89 e5             	mov    %rsp,%rbp
  8015ee:	48 83 ec 20          	sub    $0x20,%rsp
  8015f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801602:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801609:	00 
  80160a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801610:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801616:	48 89 d1             	mov    %rdx,%rcx
  801619:	48 89 c2             	mov    %rax,%rdx
  80161c:	be 00 00 00 00       	mov    $0x0,%esi
  801621:	bf 00 00 00 00       	mov    $0x0,%edi
  801626:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  80162d:	00 00 00 
  801630:	ff d0                	callq  *%rax
}
  801632:	c9                   	leaveq 
  801633:	c3                   	retq   

0000000000801634 <sys_cgetc>:

int
sys_cgetc(void)
{
  801634:	55                   	push   %rbp
  801635:	48 89 e5             	mov    %rsp,%rbp
  801638:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80163c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801643:	00 
  801644:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80164a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801650:	b9 00 00 00 00       	mov    $0x0,%ecx
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	be 00 00 00 00       	mov    $0x0,%esi
  80165f:	bf 01 00 00 00       	mov    $0x1,%edi
  801664:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  80166b:	00 00 00 
  80166e:	ff d0                	callq  *%rax
}
  801670:	c9                   	leaveq 
  801671:	c3                   	retq   

0000000000801672 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801672:	55                   	push   %rbp
  801673:	48 89 e5             	mov    %rsp,%rbp
  801676:	48 83 ec 10          	sub    $0x10,%rsp
  80167a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80167d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801680:	48 98                	cltq   
  801682:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801689:	00 
  80168a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801690:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80169b:	48 89 c2             	mov    %rax,%rdx
  80169e:	be 01 00 00 00       	mov    $0x1,%esi
  8016a3:	bf 03 00 00 00       	mov    $0x3,%edi
  8016a8:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  8016af:	00 00 00 
  8016b2:	ff d0                	callq  *%rax
}
  8016b4:	c9                   	leaveq 
  8016b5:	c3                   	retq   

00000000008016b6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016b6:	55                   	push   %rbp
  8016b7:	48 89 e5             	mov    %rsp,%rbp
  8016ba:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016c5:	00 
  8016c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dc:	be 00 00 00 00       	mov    $0x0,%esi
  8016e1:	bf 02 00 00 00       	mov    $0x2,%edi
  8016e6:	48 b8 5c 15 80 00 00 	movabs $0x80155c,%rax
  8016ed:	00 00 00 
  8016f0:	ff d0                	callq  *%rax
}
  8016f2:	c9                   	leaveq 
  8016f3:	c3                   	retq   

00000000008016f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8016f4:	55                   	push   %rbp
  8016f5:	48 89 e5             	mov    %rsp,%rbp
  8016f8:	53                   	push   %rbx
  8016f9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801700:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801707:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80170d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801714:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80171b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801722:	84 c0                	test   %al,%al
  801724:	74 23                	je     801749 <_panic+0x55>
  801726:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80172d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801731:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801735:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801739:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80173d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801741:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801745:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801749:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801750:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801757:	00 00 00 
  80175a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801761:	00 00 00 
  801764:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801768:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80176f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801776:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80177d:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801784:	00 00 00 
  801787:	48 8b 18             	mov    (%rax),%rbx
  80178a:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  801791:	00 00 00 
  801794:	ff d0                	callq  *%rax
  801796:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80179c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8017a3:	41 89 c8             	mov    %ecx,%r8d
  8017a6:	48 89 d1             	mov    %rdx,%rcx
  8017a9:	48 89 da             	mov    %rbx,%rdx
  8017ac:	89 c6                	mov    %eax,%esi
  8017ae:	48 bf 98 1c 80 00 00 	movabs $0x801c98,%rdi
  8017b5:	00 00 00 
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bd:	49 b9 3b 02 80 00 00 	movabs $0x80023b,%r9
  8017c4:	00 00 00 
  8017c7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017ca:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017d1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8017d8:	48 89 d6             	mov    %rdx,%rsi
  8017db:	48 89 c7             	mov    %rax,%rdi
  8017de:	48 b8 8f 01 80 00 00 	movabs $0x80018f,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	callq  *%rax
	cprintf("\n");
  8017ea:	48 bf bb 1c 80 00 00 	movabs $0x801cbb,%rdi
  8017f1:	00 00 00 
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	48 ba 3b 02 80 00 00 	movabs $0x80023b,%rdx
  801800:	00 00 00 
  801803:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801805:	cc                   	int3   
  801806:	eb fd                	jmp    801805 <_panic+0x111>
