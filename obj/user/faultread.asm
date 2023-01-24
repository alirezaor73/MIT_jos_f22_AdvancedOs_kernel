
obj/user/faultread:     file format elf64-x86-64


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
  80003c:	e8 37 00 00 00       	callq  800078 <libmain>
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
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	8b 00                	mov    (%rax),%eax
  800059:	89 c6                	mov    %eax,%esi
  80005b:	48 bf 00 18 80 00 00 	movabs $0x801800,%rdi
  800062:	00 00 00 
  800065:	b8 00 00 00 00       	mov    $0x0,%eax
  80006a:	48 ba 14 02 80 00 00 	movabs $0x800214,%rdx
  800071:	00 00 00 
  800074:	ff d2                	callq  *%rdx
}
  800076:	c9                   	leaveq 
  800077:	c3                   	retq   

0000000000800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %rbp
  800079:	48 89 e5             	mov    %rsp,%rbp
  80007c:	48 83 ec 10          	sub    $0x10,%rsp
  800080:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800083:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800087:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80008e:	00 00 00 
  800091:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800098:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80009c:	7e 14                	jle    8000b2 <libmain+0x3a>
		binaryname = argv[0];
  80009e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000a2:	48 8b 10             	mov    (%rax),%rdx
  8000a5:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000ac:	00 00 00 
  8000af:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b9:	48 89 d6             	mov    %rdx,%rsi
  8000bc:	89 c7                	mov    %eax,%edi
  8000be:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000ca:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8000e1:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  8000e8:	00 00 00 
  8000eb:	ff d0                	callq  *%rax
}
  8000ed:	5d                   	pop    %rbp
  8000ee:	c3                   	retq   

00000000008000ef <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8000ef:	55                   	push   %rbp
  8000f0:	48 89 e5             	mov    %rsp,%rbp
  8000f3:	48 83 ec 10          	sub    $0x10,%rsp
  8000f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8000fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800102:	8b 00                	mov    (%rax),%eax
  800104:	8d 48 01             	lea    0x1(%rax),%ecx
  800107:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80010b:	89 0a                	mov    %ecx,(%rdx)
  80010d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800110:	89 d1                	mov    %edx,%ecx
  800112:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800116:	48 98                	cltq   
  800118:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80011c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800120:	8b 00                	mov    (%rax),%eax
  800122:	3d ff 00 00 00       	cmp    $0xff,%eax
  800127:	75 2c                	jne    800155 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80012d:	8b 00                	mov    (%rax),%eax
  80012f:	48 98                	cltq   
  800131:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800135:	48 83 c2 08          	add    $0x8,%rdx
  800139:	48 89 c6             	mov    %rax,%rsi
  80013c:	48 89 d7             	mov    %rdx,%rdi
  80013f:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  800146:	00 00 00 
  800149:	ff d0                	callq  *%rax
        b->idx = 0;
  80014b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800155:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800159:	8b 40 04             	mov    0x4(%rax),%eax
  80015c:	8d 50 01             	lea    0x1(%rax),%edx
  80015f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800163:	89 50 04             	mov    %edx,0x4(%rax)
}
  800166:	c9                   	leaveq 
  800167:	c3                   	retq   

0000000000800168 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800168:	55                   	push   %rbp
  800169:	48 89 e5             	mov    %rsp,%rbp
  80016c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800173:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80017a:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800181:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800188:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80018f:	48 8b 0a             	mov    (%rdx),%rcx
  800192:	48 89 08             	mov    %rcx,(%rax)
  800195:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800199:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80019d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001ac:	00 00 00 
    b.cnt = 0;
  8001af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001b6:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001b9:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001c0:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001c7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001ce:	48 89 c6             	mov    %rax,%rsi
  8001d1:	48 bf ef 00 80 00 00 	movabs $0x8000ef,%rdi
  8001d8:	00 00 00 
  8001db:	48 b8 c7 05 80 00 00 	movabs $0x8005c7,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8001e7:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8001ed:	48 98                	cltq   
  8001ef:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8001f6:	48 83 c2 08          	add    $0x8,%rdx
  8001fa:	48 89 c6             	mov    %rax,%rsi
  8001fd:	48 89 d7             	mov    %rdx,%rdi
  800200:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80020c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800212:	c9                   	leaveq 
  800213:	c3                   	retq   

0000000000800214 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800214:	55                   	push   %rbp
  800215:	48 89 e5             	mov    %rsp,%rbp
  800218:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80021f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800226:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80022d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800234:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80023b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800242:	84 c0                	test   %al,%al
  800244:	74 20                	je     800266 <cprintf+0x52>
  800246:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80024a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80024e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800252:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800256:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80025a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80025e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800262:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800266:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80026d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800274:	00 00 00 
  800277:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80027e:	00 00 00 
  800281:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800285:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80028c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800293:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80029a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002a1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002a8:	48 8b 0a             	mov    (%rdx),%rcx
  8002ab:	48 89 08             	mov    %rcx,(%rax)
  8002ae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002b2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002b6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ba:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002be:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002c5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002cc:	48 89 d6             	mov    %rdx,%rsi
  8002cf:	48 89 c7             	mov    %rax,%rdi
  8002d2:	48 b8 68 01 80 00 00 	movabs $0x800168,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8002e4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8002ea:	c9                   	leaveq 
  8002eb:	c3                   	retq   

00000000008002ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ec:	55                   	push   %rbp
  8002ed:	48 89 e5             	mov    %rsp,%rbp
  8002f0:	53                   	push   %rbx
  8002f1:	48 83 ec 38          	sub    $0x38,%rsp
  8002f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8002fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800301:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800304:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800308:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80030c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80030f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800313:	77 3b                	ja     800350 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800315:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800318:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80031c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80031f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800323:	ba 00 00 00 00       	mov    $0x0,%edx
  800328:	48 f7 f3             	div    %rbx
  80032b:	48 89 c2             	mov    %rax,%rdx
  80032e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800331:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800334:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033c:	41 89 f9             	mov    %edi,%r9d
  80033f:	48 89 c7             	mov    %rax,%rdi
  800342:	48 b8 ec 02 80 00 00 	movabs $0x8002ec,%rax
  800349:	00 00 00 
  80034c:	ff d0                	callq  *%rax
  80034e:	eb 1e                	jmp    80036e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800350:	eb 12                	jmp    800364 <printnum+0x78>
			putch(padc, putdat);
  800352:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800356:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80035d:	48 89 ce             	mov    %rcx,%rsi
  800360:	89 d7                	mov    %edx,%edi
  800362:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800364:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800368:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80036c:	7f e4                	jg     800352 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80036e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800375:	ba 00 00 00 00       	mov    $0x0,%edx
  80037a:	48 f7 f1             	div    %rcx
  80037d:	48 89 d0             	mov    %rdx,%rax
  800380:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
  800387:	00 00 00 
  80038a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80038e:	0f be d0             	movsbl %al,%edx
  800391:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800399:	48 89 ce             	mov    %rcx,%rsi
  80039c:	89 d7                	mov    %edx,%edi
  80039e:	ff d0                	callq  *%rax
}
  8003a0:	48 83 c4 38          	add    $0x38,%rsp
  8003a4:	5b                   	pop    %rbx
  8003a5:	5d                   	pop    %rbp
  8003a6:	c3                   	retq   

00000000008003a7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003a7:	55                   	push   %rbp
  8003a8:	48 89 e5             	mov    %rsp,%rbp
  8003ab:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003b3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003b6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003ba:	7e 52                	jle    80040e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c0:	8b 00                	mov    (%rax),%eax
  8003c2:	83 f8 30             	cmp    $0x30,%eax
  8003c5:	73 24                	jae    8003eb <getuint+0x44>
  8003c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8003cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d3:	8b 00                	mov    (%rax),%eax
  8003d5:	89 c0                	mov    %eax,%eax
  8003d7:	48 01 d0             	add    %rdx,%rax
  8003da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003de:	8b 12                	mov    (%rdx),%edx
  8003e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8003e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003e7:	89 0a                	mov    %ecx,(%rdx)
  8003e9:	eb 17                	jmp    800402 <getuint+0x5b>
  8003eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8003f3:	48 89 d0             	mov    %rdx,%rax
  8003f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8003fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800402:	48 8b 00             	mov    (%rax),%rax
  800405:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800409:	e9 a3 00 00 00       	jmpq   8004b1 <getuint+0x10a>
	else if (lflag)
  80040e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800412:	74 4f                	je     800463 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800418:	8b 00                	mov    (%rax),%eax
  80041a:	83 f8 30             	cmp    $0x30,%eax
  80041d:	73 24                	jae    800443 <getuint+0x9c>
  80041f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800423:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042b:	8b 00                	mov    (%rax),%eax
  80042d:	89 c0                	mov    %eax,%eax
  80042f:	48 01 d0             	add    %rdx,%rax
  800432:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800436:	8b 12                	mov    (%rdx),%edx
  800438:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80043b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043f:	89 0a                	mov    %ecx,(%rdx)
  800441:	eb 17                	jmp    80045a <getuint+0xb3>
  800443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800447:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80044b:	48 89 d0             	mov    %rdx,%rax
  80044e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800452:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800456:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80045a:	48 8b 00             	mov    (%rax),%rax
  80045d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800461:	eb 4e                	jmp    8004b1 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800467:	8b 00                	mov    (%rax),%eax
  800469:	83 f8 30             	cmp    $0x30,%eax
  80046c:	73 24                	jae    800492 <getuint+0xeb>
  80046e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800472:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047a:	8b 00                	mov    (%rax),%eax
  80047c:	89 c0                	mov    %eax,%eax
  80047e:	48 01 d0             	add    %rdx,%rax
  800481:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800485:	8b 12                	mov    (%rdx),%edx
  800487:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80048a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048e:	89 0a                	mov    %ecx,(%rdx)
  800490:	eb 17                	jmp    8004a9 <getuint+0x102>
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049a:	48 89 d0             	mov    %rdx,%rax
  80049d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004a9:	8b 00                	mov    (%rax),%eax
  8004ab:	89 c0                	mov    %eax,%eax
  8004ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004b5:	c9                   	leaveq 
  8004b6:	c3                   	retq   

00000000008004b7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b7:	55                   	push   %rbp
  8004b8:	48 89 e5             	mov    %rsp,%rbp
  8004bb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004c6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004ca:	7e 52                	jle    80051e <getint+0x67>
		x=va_arg(*ap, long long);
  8004cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	83 f8 30             	cmp    $0x30,%eax
  8004d5:	73 24                	jae    8004fb <getint+0x44>
  8004d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004db:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e3:	8b 00                	mov    (%rax),%eax
  8004e5:	89 c0                	mov    %eax,%eax
  8004e7:	48 01 d0             	add    %rdx,%rax
  8004ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ee:	8b 12                	mov    (%rdx),%edx
  8004f0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f7:	89 0a                	mov    %ecx,(%rdx)
  8004f9:	eb 17                	jmp    800512 <getint+0x5b>
  8004fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ff:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800503:	48 89 d0             	mov    %rdx,%rax
  800506:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80050a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800512:	48 8b 00             	mov    (%rax),%rax
  800515:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800519:	e9 a3 00 00 00       	jmpq   8005c1 <getint+0x10a>
	else if (lflag)
  80051e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800522:	74 4f                	je     800573 <getint+0xbc>
		x=va_arg(*ap, long);
  800524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800528:	8b 00                	mov    (%rax),%eax
  80052a:	83 f8 30             	cmp    $0x30,%eax
  80052d:	73 24                	jae    800553 <getint+0x9c>
  80052f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800533:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053b:	8b 00                	mov    (%rax),%eax
  80053d:	89 c0                	mov    %eax,%eax
  80053f:	48 01 d0             	add    %rdx,%rax
  800542:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800546:	8b 12                	mov    (%rdx),%edx
  800548:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80054b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054f:	89 0a                	mov    %ecx,(%rdx)
  800551:	eb 17                	jmp    80056a <getint+0xb3>
  800553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800557:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80055b:	48 89 d0             	mov    %rdx,%rax
  80055e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800562:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800566:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056a:	48 8b 00             	mov    (%rax),%rax
  80056d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800571:	eb 4e                	jmp    8005c1 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800577:	8b 00                	mov    (%rax),%eax
  800579:	83 f8 30             	cmp    $0x30,%eax
  80057c:	73 24                	jae    8005a2 <getint+0xeb>
  80057e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800582:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058a:	8b 00                	mov    (%rax),%eax
  80058c:	89 c0                	mov    %eax,%eax
  80058e:	48 01 d0             	add    %rdx,%rax
  800591:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800595:	8b 12                	mov    (%rdx),%edx
  800597:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059e:	89 0a                	mov    %ecx,(%rdx)
  8005a0:	eb 17                	jmp    8005b9 <getint+0x102>
  8005a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005aa:	48 89 d0             	mov    %rdx,%rax
  8005ad:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b9:	8b 00                	mov    (%rax),%eax
  8005bb:	48 98                	cltq   
  8005bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c5:	c9                   	leaveq 
  8005c6:	c3                   	retq   

00000000008005c7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005c7:	55                   	push   %rbp
  8005c8:	48 89 e5             	mov    %rsp,%rbp
  8005cb:	41 54                	push   %r12
  8005cd:	53                   	push   %rbx
  8005ce:	48 83 ec 60          	sub    $0x60,%rsp
  8005d2:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8005d6:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8005da:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8005de:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8005e2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8005e6:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8005ea:	48 8b 0a             	mov    (%rdx),%rcx
  8005ed:	48 89 08             	mov    %rcx,(%rax)
  8005f0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005f4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005f8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005fc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800600:	eb 17                	jmp    800619 <vprintfmt+0x52>
			if (ch == '\0')
  800602:	85 db                	test   %ebx,%ebx
  800604:	0f 84 df 04 00 00    	je     800ae9 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80060a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80060e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800612:	48 89 d6             	mov    %rdx,%rsi
  800615:	89 df                	mov    %ebx,%edi
  800617:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800619:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80061d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800621:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800625:	0f b6 00             	movzbl (%rax),%eax
  800628:	0f b6 d8             	movzbl %al,%ebx
  80062b:	83 fb 25             	cmp    $0x25,%ebx
  80062e:	75 d2                	jne    800602 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800630:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800634:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80063b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800642:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800649:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800650:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800654:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800658:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80065c:	0f b6 00             	movzbl (%rax),%eax
  80065f:	0f b6 d8             	movzbl %al,%ebx
  800662:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800665:	83 f8 55             	cmp    $0x55,%eax
  800668:	0f 87 47 04 00 00    	ja     800ab5 <vprintfmt+0x4ee>
  80066e:	89 c0                	mov    %eax,%eax
  800670:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800677:	00 
  800678:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80067f:	00 00 00 
  800682:	48 01 d0             	add    %rdx,%rax
  800685:	48 8b 00             	mov    (%rax),%rax
  800688:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80068a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80068e:	eb c0                	jmp    800650 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800690:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800694:	eb ba                	jmp    800650 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800696:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80069d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006a0:	89 d0                	mov    %edx,%eax
  8006a2:	c1 e0 02             	shl    $0x2,%eax
  8006a5:	01 d0                	add    %edx,%eax
  8006a7:	01 c0                	add    %eax,%eax
  8006a9:	01 d8                	add    %ebx,%eax
  8006ab:	83 e8 30             	sub    $0x30,%eax
  8006ae:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006b1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b5:	0f b6 00             	movzbl (%rax),%eax
  8006b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8006be:	7e 0c                	jle    8006cc <vprintfmt+0x105>
  8006c0:	83 fb 39             	cmp    $0x39,%ebx
  8006c3:	7f 07                	jg     8006cc <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ca:	eb d1                	jmp    80069d <vprintfmt+0xd6>
			goto process_precision;
  8006cc:	eb 58                	jmp    800726 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8006ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006d1:	83 f8 30             	cmp    $0x30,%eax
  8006d4:	73 17                	jae    8006ed <vprintfmt+0x126>
  8006d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8006da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006dd:	89 c0                	mov    %eax,%eax
  8006df:	48 01 d0             	add    %rdx,%rax
  8006e2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8006e5:	83 c2 08             	add    $0x8,%edx
  8006e8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8006eb:	eb 0f                	jmp    8006fc <vprintfmt+0x135>
  8006ed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006f1:	48 89 d0             	mov    %rdx,%rax
  8006f4:	48 83 c2 08          	add    $0x8,%rdx
  8006f8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8006fc:	8b 00                	mov    (%rax),%eax
  8006fe:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800701:	eb 23                	jmp    800726 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800703:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800707:	79 0c                	jns    800715 <vprintfmt+0x14e>
				width = 0;
  800709:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800710:	e9 3b ff ff ff       	jmpq   800650 <vprintfmt+0x89>
  800715:	e9 36 ff ff ff       	jmpq   800650 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80071a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800721:	e9 2a ff ff ff       	jmpq   800650 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800726:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80072a:	79 12                	jns    80073e <vprintfmt+0x177>
				width = precision, precision = -1;
  80072c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80072f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800732:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800739:	e9 12 ff ff ff       	jmpq   800650 <vprintfmt+0x89>
  80073e:	e9 0d ff ff ff       	jmpq   800650 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800743:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800747:	e9 04 ff ff ff       	jmpq   800650 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80074c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80074f:	83 f8 30             	cmp    $0x30,%eax
  800752:	73 17                	jae    80076b <vprintfmt+0x1a4>
  800754:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800758:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075b:	89 c0                	mov    %eax,%eax
  80075d:	48 01 d0             	add    %rdx,%rax
  800760:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800763:	83 c2 08             	add    $0x8,%edx
  800766:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800769:	eb 0f                	jmp    80077a <vprintfmt+0x1b3>
  80076b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80076f:	48 89 d0             	mov    %rdx,%rax
  800772:	48 83 c2 08          	add    $0x8,%rdx
  800776:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80077a:	8b 10                	mov    (%rax),%edx
  80077c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800780:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800784:	48 89 ce             	mov    %rcx,%rsi
  800787:	89 d7                	mov    %edx,%edi
  800789:	ff d0                	callq  *%rax
			break;
  80078b:	e9 53 03 00 00       	jmpq   800ae3 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800790:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800793:	83 f8 30             	cmp    $0x30,%eax
  800796:	73 17                	jae    8007af <vprintfmt+0x1e8>
  800798:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80079c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079f:	89 c0                	mov    %eax,%eax
  8007a1:	48 01 d0             	add    %rdx,%rax
  8007a4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a7:	83 c2 08             	add    $0x8,%edx
  8007aa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ad:	eb 0f                	jmp    8007be <vprintfmt+0x1f7>
  8007af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b3:	48 89 d0             	mov    %rdx,%rax
  8007b6:	48 83 c2 08          	add    $0x8,%rdx
  8007ba:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007be:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007c0:	85 db                	test   %ebx,%ebx
  8007c2:	79 02                	jns    8007c6 <vprintfmt+0x1ff>
				err = -err;
  8007c4:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007c6:	83 fb 15             	cmp    $0x15,%ebx
  8007c9:	7f 16                	jg     8007e1 <vprintfmt+0x21a>
  8007cb:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  8007d2:	00 00 00 
  8007d5:	48 63 d3             	movslq %ebx,%rdx
  8007d8:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8007dc:	4d 85 e4             	test   %r12,%r12
  8007df:	75 2e                	jne    80080f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8007e1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8007e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e9:	89 d9                	mov    %ebx,%ecx
  8007eb:	48 ba 81 19 80 00 00 	movabs $0x801981,%rdx
  8007f2:	00 00 00 
  8007f5:	48 89 c7             	mov    %rax,%rdi
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	49 b8 f2 0a 80 00 00 	movabs $0x800af2,%r8
  800804:	00 00 00 
  800807:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80080a:	e9 d4 02 00 00       	jmpq   800ae3 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80080f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800813:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800817:	4c 89 e1             	mov    %r12,%rcx
  80081a:	48 ba 8a 19 80 00 00 	movabs $0x80198a,%rdx
  800821:	00 00 00 
  800824:	48 89 c7             	mov    %rax,%rdi
  800827:	b8 00 00 00 00       	mov    $0x0,%eax
  80082c:	49 b8 f2 0a 80 00 00 	movabs $0x800af2,%r8
  800833:	00 00 00 
  800836:	41 ff d0             	callq  *%r8
			break;
  800839:	e9 a5 02 00 00       	jmpq   800ae3 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80083e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800841:	83 f8 30             	cmp    $0x30,%eax
  800844:	73 17                	jae    80085d <vprintfmt+0x296>
  800846:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80084a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084d:	89 c0                	mov    %eax,%eax
  80084f:	48 01 d0             	add    %rdx,%rax
  800852:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800855:	83 c2 08             	add    $0x8,%edx
  800858:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80085b:	eb 0f                	jmp    80086c <vprintfmt+0x2a5>
  80085d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800861:	48 89 d0             	mov    %rdx,%rax
  800864:	48 83 c2 08          	add    $0x8,%rdx
  800868:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80086c:	4c 8b 20             	mov    (%rax),%r12
  80086f:	4d 85 e4             	test   %r12,%r12
  800872:	75 0a                	jne    80087e <vprintfmt+0x2b7>
				p = "(null)";
  800874:	49 bc 8d 19 80 00 00 	movabs $0x80198d,%r12
  80087b:	00 00 00 
			if (width > 0 && padc != '-')
  80087e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800882:	7e 3f                	jle    8008c3 <vprintfmt+0x2fc>
  800884:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800888:	74 39                	je     8008c3 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80088d:	48 98                	cltq   
  80088f:	48 89 c6             	mov    %rax,%rsi
  800892:	4c 89 e7             	mov    %r12,%rdi
  800895:	48 b8 9e 0d 80 00 00 	movabs $0x800d9e,%rax
  80089c:	00 00 00 
  80089f:	ff d0                	callq  *%rax
  8008a1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008a4:	eb 17                	jmp    8008bd <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008a6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008aa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b2:	48 89 ce             	mov    %rcx,%rsi
  8008b5:	89 d7                	mov    %edx,%edi
  8008b7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c1:	7f e3                	jg     8008a6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008c3:	eb 37                	jmp    8008fc <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8008c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008c9:	74 1e                	je     8008e9 <vprintfmt+0x322>
  8008cb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ce:	7e 05                	jle    8008d5 <vprintfmt+0x30e>
  8008d0:	83 fb 7e             	cmp    $0x7e,%ebx
  8008d3:	7e 14                	jle    8008e9 <vprintfmt+0x322>
					putch('?', putdat);
  8008d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008dd:	48 89 d6             	mov    %rdx,%rsi
  8008e0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008e5:	ff d0                	callq  *%rax
  8008e7:	eb 0f                	jmp    8008f8 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8008e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f1:	48 89 d6             	mov    %rdx,%rsi
  8008f4:	89 df                	mov    %ebx,%edi
  8008f6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008fc:	4c 89 e0             	mov    %r12,%rax
  8008ff:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800903:	0f b6 00             	movzbl (%rax),%eax
  800906:	0f be d8             	movsbl %al,%ebx
  800909:	85 db                	test   %ebx,%ebx
  80090b:	74 10                	je     80091d <vprintfmt+0x356>
  80090d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800911:	78 b2                	js     8008c5 <vprintfmt+0x2fe>
  800913:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800917:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80091b:	79 a8                	jns    8008c5 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091d:	eb 16                	jmp    800935 <vprintfmt+0x36e>
				putch(' ', putdat);
  80091f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800923:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800927:	48 89 d6             	mov    %rdx,%rsi
  80092a:	bf 20 00 00 00       	mov    $0x20,%edi
  80092f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800935:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800939:	7f e4                	jg     80091f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80093b:	e9 a3 01 00 00       	jmpq   800ae3 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800940:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800944:	be 03 00 00 00       	mov    $0x3,%esi
  800949:	48 89 c7             	mov    %rax,%rdi
  80094c:	48 b8 b7 04 80 00 00 	movabs $0x8004b7,%rax
  800953:	00 00 00 
  800956:	ff d0                	callq  *%rax
  800958:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 85 c0             	test   %rax,%rax
  800963:	79 1d                	jns    800982 <vprintfmt+0x3bb>
				putch('-', putdat);
  800965:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800969:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80096d:	48 89 d6             	mov    %rdx,%rsi
  800970:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800975:	ff d0                	callq  *%rax
				num = -(long long) num;
  800977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097b:	48 f7 d8             	neg    %rax
  80097e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800982:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800989:	e9 e8 00 00 00       	jmpq   800a76 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80098e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800992:	be 03 00 00 00       	mov    $0x3,%esi
  800997:	48 89 c7             	mov    %rax,%rdi
  80099a:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009aa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009b1:	e9 c0 00 00 00       	jmpq   800a76 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009be:	48 89 d6             	mov    %rdx,%rsi
  8009c1:	bf 58 00 00 00       	mov    $0x58,%edi
  8009c6:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009c8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009cc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d0:	48 89 d6             	mov    %rdx,%rsi
  8009d3:	bf 58 00 00 00       	mov    $0x58,%edi
  8009d8:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e2:	48 89 d6             	mov    %rdx,%rsi
  8009e5:	bf 58 00 00 00       	mov    $0x58,%edi
  8009ea:	ff d0                	callq  *%rax
			break;
  8009ec:	e9 f2 00 00 00       	jmpq   800ae3 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  8009f1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f9:	48 89 d6             	mov    %rdx,%rsi
  8009fc:	bf 30 00 00 00       	mov    $0x30,%edi
  800a01:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0b:	48 89 d6             	mov    %rdx,%rsi
  800a0e:	bf 78 00 00 00       	mov    $0x78,%edi
  800a13:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a18:	83 f8 30             	cmp    $0x30,%eax
  800a1b:	73 17                	jae    800a34 <vprintfmt+0x46d>
  800a1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a24:	89 c0                	mov    %eax,%eax
  800a26:	48 01 d0             	add    %rdx,%rax
  800a29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2c:	83 c2 08             	add    $0x8,%edx
  800a2f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a32:	eb 0f                	jmp    800a43 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a38:	48 89 d0             	mov    %rdx,%rax
  800a3b:	48 83 c2 08          	add    $0x8,%rdx
  800a3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a43:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a4a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a51:	eb 23                	jmp    800a76 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a57:	be 03 00 00 00       	mov    $0x3,%esi
  800a5c:	48 89 c7             	mov    %rax,%rdi
  800a5f:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  800a66:	00 00 00 
  800a69:	ff d0                	callq  *%rax
  800a6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a6f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a76:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a7b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a7e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a85:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8d:	45 89 c1             	mov    %r8d,%r9d
  800a90:	41 89 f8             	mov    %edi,%r8d
  800a93:	48 89 c7             	mov    %rax,%rdi
  800a96:	48 b8 ec 02 80 00 00 	movabs $0x8002ec,%rax
  800a9d:	00 00 00 
  800aa0:	ff d0                	callq  *%rax
			break;
  800aa2:	eb 3f                	jmp    800ae3 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aac:	48 89 d6             	mov    %rdx,%rsi
  800aaf:	89 df                	mov    %ebx,%edi
  800ab1:	ff d0                	callq  *%rax
			break;
  800ab3:	eb 2e                	jmp    800ae3 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abd:	48 89 d6             	mov    %rdx,%rsi
  800ac0:	bf 25 00 00 00       	mov    $0x25,%edi
  800ac5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800acc:	eb 05                	jmp    800ad3 <vprintfmt+0x50c>
  800ace:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ad3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ad7:	48 83 e8 01          	sub    $0x1,%rax
  800adb:	0f b6 00             	movzbl (%rax),%eax
  800ade:	3c 25                	cmp    $0x25,%al
  800ae0:	75 ec                	jne    800ace <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ae2:	90                   	nop
		}
	}
  800ae3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ae4:	e9 30 fb ff ff       	jmpq   800619 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ae9:	48 83 c4 60          	add    $0x60,%rsp
  800aed:	5b                   	pop    %rbx
  800aee:	41 5c                	pop    %r12
  800af0:	5d                   	pop    %rbp
  800af1:	c3                   	retq   

0000000000800af2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af2:	55                   	push   %rbp
  800af3:	48 89 e5             	mov    %rsp,%rbp
  800af6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800afd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b04:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b0b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b12:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b19:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b20:	84 c0                	test   %al,%al
  800b22:	74 20                	je     800b44 <printfmt+0x52>
  800b24:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b28:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b2c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b30:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b34:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b38:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b3c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b40:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b44:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b4b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b52:	00 00 00 
  800b55:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b5c:	00 00 00 
  800b5f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b63:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b6a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b71:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b78:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b7f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b86:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800b8d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800b94:	48 89 c7             	mov    %rax,%rdi
  800b97:	48 b8 c7 05 80 00 00 	movabs $0x8005c7,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ba3:	c9                   	leaveq 
  800ba4:	c3                   	retq   

0000000000800ba5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba5:	55                   	push   %rbp
  800ba6:	48 89 e5             	mov    %rsp,%rbp
  800ba9:	48 83 ec 10          	sub    $0x10,%rsp
  800bad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bb8:	8b 40 10             	mov    0x10(%rax),%eax
  800bbb:	8d 50 01             	lea    0x1(%rax),%edx
  800bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bc2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bc9:	48 8b 10             	mov    (%rax),%rdx
  800bcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bd4:	48 39 c2             	cmp    %rax,%rdx
  800bd7:	73 17                	jae    800bf0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bdd:	48 8b 00             	mov    (%rax),%rax
  800be0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800be4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800be8:	48 89 0a             	mov    %rcx,(%rdx)
  800beb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800bee:	88 10                	mov    %dl,(%rax)
}
  800bf0:	c9                   	leaveq 
  800bf1:	c3                   	retq   

0000000000800bf2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf2:	55                   	push   %rbp
  800bf3:	48 89 e5             	mov    %rsp,%rbp
  800bf6:	48 83 ec 50          	sub    $0x50,%rsp
  800bfa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800bfe:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c01:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c05:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c09:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c0d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c11:	48 8b 0a             	mov    (%rdx),%rcx
  800c14:	48 89 08             	mov    %rcx,(%rax)
  800c17:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c1b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c1f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c23:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c27:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c2b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c2f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c32:	48 98                	cltq   
  800c34:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c3c:	48 01 d0             	add    %rdx,%rax
  800c3f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c4a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c4f:	74 06                	je     800c57 <vsnprintf+0x65>
  800c51:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c55:	7f 07                	jg     800c5e <vsnprintf+0x6c>
		return -E_INVAL;
  800c57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c5c:	eb 2f                	jmp    800c8d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c5e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c62:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c66:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c6a:	48 89 c6             	mov    %rax,%rsi
  800c6d:	48 bf a5 0b 80 00 00 	movabs $0x800ba5,%rdi
  800c74:	00 00 00 
  800c77:	48 b8 c7 05 80 00 00 	movabs $0x8005c7,%rax
  800c7e:	00 00 00 
  800c81:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800c83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c87:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800c8a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800c8d:	c9                   	leaveq 
  800c8e:	c3                   	retq   

0000000000800c8f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8f:	55                   	push   %rbp
  800c90:	48 89 e5             	mov    %rsp,%rbp
  800c93:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c9a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ca1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ca7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cae:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cb5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cbc:	84 c0                	test   %al,%al
  800cbe:	74 20                	je     800ce0 <snprintf+0x51>
  800cc0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cc4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cc8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ccc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cd4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cd8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cdc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ce0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ce7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800cee:	00 00 00 
  800cf1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800cf8:	00 00 00 
  800cfb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cff:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d06:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d0d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d14:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d1b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d22:	48 8b 0a             	mov    (%rdx),%rcx
  800d25:	48 89 08             	mov    %rcx,(%rax)
  800d28:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d2c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d30:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d34:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d38:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d3f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d46:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d4c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d53:	48 89 c7             	mov    %rax,%rdi
  800d56:	48 b8 f2 0b 80 00 00 	movabs $0x800bf2,%rax
  800d5d:	00 00 00 
  800d60:	ff d0                	callq  *%rax
  800d62:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d68:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d6e:	c9                   	leaveq 
  800d6f:	c3                   	retq   

0000000000800d70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d70:	55                   	push   %rbp
  800d71:	48 89 e5             	mov    %rsp,%rbp
  800d74:	48 83 ec 18          	sub    $0x18,%rsp
  800d78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d83:	eb 09                	jmp    800d8e <strlen+0x1e>
		n++;
  800d85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d89:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800d8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d92:	0f b6 00             	movzbl (%rax),%eax
  800d95:	84 c0                	test   %al,%al
  800d97:	75 ec                	jne    800d85 <strlen+0x15>
		n++;
	return n;
  800d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800d9c:	c9                   	leaveq 
  800d9d:	c3                   	retq   

0000000000800d9e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d9e:	55                   	push   %rbp
  800d9f:	48 89 e5             	mov    %rsp,%rbp
  800da2:	48 83 ec 20          	sub    $0x20,%rsp
  800da6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800daa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800db5:	eb 0e                	jmp    800dc5 <strnlen+0x27>
		n++;
  800db7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dbb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dc0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dc5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dca:	74 0b                	je     800dd7 <strnlen+0x39>
  800dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd0:	0f b6 00             	movzbl (%rax),%eax
  800dd3:	84 c0                	test   %al,%al
  800dd5:	75 e0                	jne    800db7 <strnlen+0x19>
		n++;
	return n;
  800dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dda:	c9                   	leaveq 
  800ddb:	c3                   	retq   

0000000000800ddc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ddc:	55                   	push   %rbp
  800ddd:	48 89 e5             	mov    %rsp,%rbp
  800de0:	48 83 ec 20          	sub    $0x20,%rsp
  800de4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800de8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800dec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800df4:	90                   	nop
  800df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dfd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e01:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e05:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e09:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e0d:	0f b6 12             	movzbl (%rdx),%edx
  800e10:	88 10                	mov    %dl,(%rax)
  800e12:	0f b6 00             	movzbl (%rax),%eax
  800e15:	84 c0                	test   %al,%al
  800e17:	75 dc                	jne    800df5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e1d:	c9                   	leaveq 
  800e1e:	c3                   	retq   

0000000000800e1f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e1f:	55                   	push   %rbp
  800e20:	48 89 e5             	mov    %rsp,%rbp
  800e23:	48 83 ec 20          	sub    $0x20,%rsp
  800e27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e33:	48 89 c7             	mov    %rax,%rdi
  800e36:	48 b8 70 0d 80 00 00 	movabs $0x800d70,%rax
  800e3d:	00 00 00 
  800e40:	ff d0                	callq  *%rax
  800e42:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e48:	48 63 d0             	movslq %eax,%rdx
  800e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4f:	48 01 c2             	add    %rax,%rdx
  800e52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e56:	48 89 c6             	mov    %rax,%rsi
  800e59:	48 89 d7             	mov    %rdx,%rdi
  800e5c:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  800e63:	00 00 00 
  800e66:	ff d0                	callq  *%rax
	return dst;
  800e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e6c:	c9                   	leaveq 
  800e6d:	c3                   	retq   

0000000000800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e6e:	55                   	push   %rbp
  800e6f:	48 89 e5             	mov    %rsp,%rbp
  800e72:	48 83 ec 28          	sub    $0x28,%rsp
  800e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800e8a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800e91:	00 
  800e92:	eb 2a                	jmp    800ebe <strncpy+0x50>
		*dst++ = *src;
  800e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e98:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e9c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ea0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea4:	0f b6 12             	movzbl (%rdx),%edx
  800ea7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ea9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ead:	0f b6 00             	movzbl (%rax),%eax
  800eb0:	84 c0                	test   %al,%al
  800eb2:	74 05                	je     800eb9 <strncpy+0x4b>
			src++;
  800eb4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ebe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ec2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ec6:	72 cc                	jb     800e94 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ecc:	c9                   	leaveq 
  800ecd:	c3                   	retq   

0000000000800ece <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ece:	55                   	push   %rbp
  800ecf:	48 89 e5             	mov    %rsp,%rbp
  800ed2:	48 83 ec 28          	sub    $0x28,%rsp
  800ed6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ede:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800eea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800eef:	74 3d                	je     800f2e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ef1:	eb 1d                	jmp    800f10 <strlcpy+0x42>
			*dst++ = *src++;
  800ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800efb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f03:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f07:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f0b:	0f b6 12             	movzbl (%rdx),%edx
  800f0e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f15:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f1a:	74 0b                	je     800f27 <strlcpy+0x59>
  800f1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f20:	0f b6 00             	movzbl (%rax),%eax
  800f23:	84 c0                	test   %al,%al
  800f25:	75 cc                	jne    800ef3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f36:	48 29 c2             	sub    %rax,%rdx
  800f39:	48 89 d0             	mov    %rdx,%rax
}
  800f3c:	c9                   	leaveq 
  800f3d:	c3                   	retq   

0000000000800f3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3e:	55                   	push   %rbp
  800f3f:	48 89 e5             	mov    %rsp,%rbp
  800f42:	48 83 ec 10          	sub    $0x10,%rsp
  800f46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f4e:	eb 0a                	jmp    800f5a <strcmp+0x1c>
		p++, q++;
  800f50:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f55:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f5e:	0f b6 00             	movzbl (%rax),%eax
  800f61:	84 c0                	test   %al,%al
  800f63:	74 12                	je     800f77 <strcmp+0x39>
  800f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f69:	0f b6 10             	movzbl (%rax),%edx
  800f6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f70:	0f b6 00             	movzbl (%rax),%eax
  800f73:	38 c2                	cmp    %al,%dl
  800f75:	74 d9                	je     800f50 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f7b:	0f b6 00             	movzbl (%rax),%eax
  800f7e:	0f b6 d0             	movzbl %al,%edx
  800f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f85:	0f b6 00             	movzbl (%rax),%eax
  800f88:	0f b6 c0             	movzbl %al,%eax
  800f8b:	29 c2                	sub    %eax,%edx
  800f8d:	89 d0                	mov    %edx,%eax
}
  800f8f:	c9                   	leaveq 
  800f90:	c3                   	retq   

0000000000800f91 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f91:	55                   	push   %rbp
  800f92:	48 89 e5             	mov    %rsp,%rbp
  800f95:	48 83 ec 18          	sub    $0x18,%rsp
  800f99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fa1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fa5:	eb 0f                	jmp    800fb6 <strncmp+0x25>
		n--, p++, q++;
  800fa7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fb6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fbb:	74 1d                	je     800fda <strncmp+0x49>
  800fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc1:	0f b6 00             	movzbl (%rax),%eax
  800fc4:	84 c0                	test   %al,%al
  800fc6:	74 12                	je     800fda <strncmp+0x49>
  800fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fcc:	0f b6 10             	movzbl (%rax),%edx
  800fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd3:	0f b6 00             	movzbl (%rax),%eax
  800fd6:	38 c2                	cmp    %al,%dl
  800fd8:	74 cd                	je     800fa7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800fda:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fdf:	75 07                	jne    800fe8 <strncmp+0x57>
		return 0;
  800fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe6:	eb 18                	jmp    801000 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fec:	0f b6 00             	movzbl (%rax),%eax
  800fef:	0f b6 d0             	movzbl %al,%edx
  800ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff6:	0f b6 00             	movzbl (%rax),%eax
  800ff9:	0f b6 c0             	movzbl %al,%eax
  800ffc:	29 c2                	sub    %eax,%edx
  800ffe:	89 d0                	mov    %edx,%eax
}
  801000:	c9                   	leaveq 
  801001:	c3                   	retq   

0000000000801002 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801002:	55                   	push   %rbp
  801003:	48 89 e5             	mov    %rsp,%rbp
  801006:	48 83 ec 0c          	sub    $0xc,%rsp
  80100a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80100e:	89 f0                	mov    %esi,%eax
  801010:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801013:	eb 17                	jmp    80102c <strchr+0x2a>
		if (*s == c)
  801015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801019:	0f b6 00             	movzbl (%rax),%eax
  80101c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80101f:	75 06                	jne    801027 <strchr+0x25>
			return (char *) s;
  801021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801025:	eb 15                	jmp    80103c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801027:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80102c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801030:	0f b6 00             	movzbl (%rax),%eax
  801033:	84 c0                	test   %al,%al
  801035:	75 de                	jne    801015 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801037:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103c:	c9                   	leaveq 
  80103d:	c3                   	retq   

000000000080103e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80103e:	55                   	push   %rbp
  80103f:	48 89 e5             	mov    %rsp,%rbp
  801042:	48 83 ec 0c          	sub    $0xc,%rsp
  801046:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104a:	89 f0                	mov    %esi,%eax
  80104c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80104f:	eb 13                	jmp    801064 <strfind+0x26>
		if (*s == c)
  801051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801055:	0f b6 00             	movzbl (%rax),%eax
  801058:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80105b:	75 02                	jne    80105f <strfind+0x21>
			break;
  80105d:	eb 10                	jmp    80106f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801068:	0f b6 00             	movzbl (%rax),%eax
  80106b:	84 c0                	test   %al,%al
  80106d:	75 e2                	jne    801051 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801073:	c9                   	leaveq 
  801074:	c3                   	retq   

0000000000801075 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801075:	55                   	push   %rbp
  801076:	48 89 e5             	mov    %rsp,%rbp
  801079:	48 83 ec 18          	sub    $0x18,%rsp
  80107d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801081:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801084:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801088:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80108d:	75 06                	jne    801095 <memset+0x20>
		return v;
  80108f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801093:	eb 69                	jmp    8010fe <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801095:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801099:	83 e0 03             	and    $0x3,%eax
  80109c:	48 85 c0             	test   %rax,%rax
  80109f:	75 48                	jne    8010e9 <memset+0x74>
  8010a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a5:	83 e0 03             	and    $0x3,%eax
  8010a8:	48 85 c0             	test   %rax,%rax
  8010ab:	75 3c                	jne    8010e9 <memset+0x74>
		c &= 0xFF;
  8010ad:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010b7:	c1 e0 18             	shl    $0x18,%eax
  8010ba:	89 c2                	mov    %eax,%edx
  8010bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010bf:	c1 e0 10             	shl    $0x10,%eax
  8010c2:	09 c2                	or     %eax,%edx
  8010c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010c7:	c1 e0 08             	shl    $0x8,%eax
  8010ca:	09 d0                	or     %edx,%eax
  8010cc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d3:	48 c1 e8 02          	shr    $0x2,%rax
  8010d7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8010da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e1:	48 89 d7             	mov    %rdx,%rdi
  8010e4:	fc                   	cld    
  8010e5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8010e7:	eb 11                	jmp    8010fa <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8010f4:	48 89 d7             	mov    %rdx,%rdi
  8010f7:	fc                   	cld    
  8010f8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8010fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010fe:	c9                   	leaveq 
  8010ff:	c3                   	retq   

0000000000801100 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	48 83 ec 28          	sub    $0x28,%rsp
  801108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801110:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801118:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80111c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801120:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801128:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80112c:	0f 83 88 00 00 00    	jae    8011ba <memmove+0xba>
  801132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801136:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80113a:	48 01 d0             	add    %rdx,%rax
  80113d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801141:	76 77                	jbe    8011ba <memmove+0xba>
		s += n;
  801143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801147:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80114b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80114f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801157:	83 e0 03             	and    $0x3,%eax
  80115a:	48 85 c0             	test   %rax,%rax
  80115d:	75 3b                	jne    80119a <memmove+0x9a>
  80115f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801163:	83 e0 03             	and    $0x3,%eax
  801166:	48 85 c0             	test   %rax,%rax
  801169:	75 2f                	jne    80119a <memmove+0x9a>
  80116b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116f:	83 e0 03             	and    $0x3,%eax
  801172:	48 85 c0             	test   %rax,%rax
  801175:	75 23                	jne    80119a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117b:	48 83 e8 04          	sub    $0x4,%rax
  80117f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801183:	48 83 ea 04          	sub    $0x4,%rdx
  801187:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80118b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80118f:	48 89 c7             	mov    %rax,%rdi
  801192:	48 89 d6             	mov    %rdx,%rsi
  801195:	fd                   	std    
  801196:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801198:	eb 1d                	jmp    8011b7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80119a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ae:	48 89 d7             	mov    %rdx,%rdi
  8011b1:	48 89 c1             	mov    %rax,%rcx
  8011b4:	fd                   	std    
  8011b5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011b7:	fc                   	cld    
  8011b8:	eb 57                	jmp    801211 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	83 e0 03             	and    $0x3,%eax
  8011c1:	48 85 c0             	test   %rax,%rax
  8011c4:	75 36                	jne    8011fc <memmove+0xfc>
  8011c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ca:	83 e0 03             	and    $0x3,%eax
  8011cd:	48 85 c0             	test   %rax,%rax
  8011d0:	75 2a                	jne    8011fc <memmove+0xfc>
  8011d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d6:	83 e0 03             	and    $0x3,%eax
  8011d9:	48 85 c0             	test   %rax,%rax
  8011dc:	75 1e                	jne    8011fc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e2:	48 c1 e8 02          	shr    $0x2,%rax
  8011e6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8011e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f1:	48 89 c7             	mov    %rax,%rdi
  8011f4:	48 89 d6             	mov    %rdx,%rsi
  8011f7:	fc                   	cld    
  8011f8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011fa:	eb 15                	jmp    801211 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8011fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801200:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801204:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801208:	48 89 c7             	mov    %rax,%rdi
  80120b:	48 89 d6             	mov    %rdx,%rsi
  80120e:	fc                   	cld    
  80120f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801215:	c9                   	leaveq 
  801216:	c3                   	retq   

0000000000801217 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801217:	55                   	push   %rbp
  801218:	48 89 e5             	mov    %rsp,%rbp
  80121b:	48 83 ec 18          	sub    $0x18,%rsp
  80121f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801223:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801227:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80122b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80122f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801237:	48 89 ce             	mov    %rcx,%rsi
  80123a:	48 89 c7             	mov    %rax,%rdi
  80123d:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801244:	00 00 00 
  801247:	ff d0                	callq  *%rax
}
  801249:	c9                   	leaveq 
  80124a:	c3                   	retq   

000000000080124b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80124b:	55                   	push   %rbp
  80124c:	48 89 e5             	mov    %rsp,%rbp
  80124f:	48 83 ec 28          	sub    $0x28,%rsp
  801253:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801257:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80125b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80125f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801263:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801267:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80126b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80126f:	eb 36                	jmp    8012a7 <memcmp+0x5c>
		if (*s1 != *s2)
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	0f b6 10             	movzbl (%rax),%edx
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	0f b6 00             	movzbl (%rax),%eax
  80127f:	38 c2                	cmp    %al,%dl
  801281:	74 1a                	je     80129d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801287:	0f b6 00             	movzbl (%rax),%eax
  80128a:	0f b6 d0             	movzbl %al,%edx
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	0f b6 00             	movzbl (%rax),%eax
  801294:	0f b6 c0             	movzbl %al,%eax
  801297:	29 c2                	sub    %eax,%edx
  801299:	89 d0                	mov    %edx,%eax
  80129b:	eb 20                	jmp    8012bd <memcmp+0x72>
		s1++, s2++;
  80129d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ab:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012b3:	48 85 c0             	test   %rax,%rax
  8012b6:	75 b9                	jne    801271 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bd:	c9                   	leaveq 
  8012be:	c3                   	retq   

00000000008012bf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012bf:	55                   	push   %rbp
  8012c0:	48 89 e5             	mov    %rsp,%rbp
  8012c3:	48 83 ec 28          	sub    $0x28,%rsp
  8012c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012cb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012da:	48 01 d0             	add    %rdx,%rax
  8012dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8012e1:	eb 15                	jmp    8012f8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e7:	0f b6 10             	movzbl (%rax),%edx
  8012ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8012ed:	38 c2                	cmp    %al,%dl
  8012ef:	75 02                	jne    8012f3 <memfind+0x34>
			break;
  8012f1:	eb 0f                	jmp    801302 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801300:	72 e1                	jb     8012e3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801306:	c9                   	leaveq 
  801307:	c3                   	retq   

0000000000801308 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801308:	55                   	push   %rbp
  801309:	48 89 e5             	mov    %rsp,%rbp
  80130c:	48 83 ec 34          	sub    $0x34,%rsp
  801310:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801314:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801318:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80131b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801322:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801329:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80132a:	eb 05                	jmp    801331 <strtol+0x29>
		s++;
  80132c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801331:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801335:	0f b6 00             	movzbl (%rax),%eax
  801338:	3c 20                	cmp    $0x20,%al
  80133a:	74 f0                	je     80132c <strtol+0x24>
  80133c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801340:	0f b6 00             	movzbl (%rax),%eax
  801343:	3c 09                	cmp    $0x9,%al
  801345:	74 e5                	je     80132c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134b:	0f b6 00             	movzbl (%rax),%eax
  80134e:	3c 2b                	cmp    $0x2b,%al
  801350:	75 07                	jne    801359 <strtol+0x51>
		s++;
  801352:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801357:	eb 17                	jmp    801370 <strtol+0x68>
	else if (*s == '-')
  801359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135d:	0f b6 00             	movzbl (%rax),%eax
  801360:	3c 2d                	cmp    $0x2d,%al
  801362:	75 0c                	jne    801370 <strtol+0x68>
		s++, neg = 1;
  801364:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801369:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801370:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801374:	74 06                	je     80137c <strtol+0x74>
  801376:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80137a:	75 28                	jne    8013a4 <strtol+0x9c>
  80137c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801380:	0f b6 00             	movzbl (%rax),%eax
  801383:	3c 30                	cmp    $0x30,%al
  801385:	75 1d                	jne    8013a4 <strtol+0x9c>
  801387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138b:	48 83 c0 01          	add    $0x1,%rax
  80138f:	0f b6 00             	movzbl (%rax),%eax
  801392:	3c 78                	cmp    $0x78,%al
  801394:	75 0e                	jne    8013a4 <strtol+0x9c>
		s += 2, base = 16;
  801396:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80139b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013a2:	eb 2c                	jmp    8013d0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013a8:	75 19                	jne    8013c3 <strtol+0xbb>
  8013aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ae:	0f b6 00             	movzbl (%rax),%eax
  8013b1:	3c 30                	cmp    $0x30,%al
  8013b3:	75 0e                	jne    8013c3 <strtol+0xbb>
		s++, base = 8;
  8013b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ba:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013c1:	eb 0d                	jmp    8013d0 <strtol+0xc8>
	else if (base == 0)
  8013c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013c7:	75 07                	jne    8013d0 <strtol+0xc8>
		base = 10;
  8013c9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	3c 2f                	cmp    $0x2f,%al
  8013d9:	7e 1d                	jle    8013f8 <strtol+0xf0>
  8013db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013df:	0f b6 00             	movzbl (%rax),%eax
  8013e2:	3c 39                	cmp    $0x39,%al
  8013e4:	7f 12                	jg     8013f8 <strtol+0xf0>
			dig = *s - '0';
  8013e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ea:	0f b6 00             	movzbl (%rax),%eax
  8013ed:	0f be c0             	movsbl %al,%eax
  8013f0:	83 e8 30             	sub    $0x30,%eax
  8013f3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013f6:	eb 4e                	jmp    801446 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8013f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fc:	0f b6 00             	movzbl (%rax),%eax
  8013ff:	3c 60                	cmp    $0x60,%al
  801401:	7e 1d                	jle    801420 <strtol+0x118>
  801403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	3c 7a                	cmp    $0x7a,%al
  80140c:	7f 12                	jg     801420 <strtol+0x118>
			dig = *s - 'a' + 10;
  80140e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801412:	0f b6 00             	movzbl (%rax),%eax
  801415:	0f be c0             	movsbl %al,%eax
  801418:	83 e8 57             	sub    $0x57,%eax
  80141b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80141e:	eb 26                	jmp    801446 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	3c 40                	cmp    $0x40,%al
  801429:	7e 48                	jle    801473 <strtol+0x16b>
  80142b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142f:	0f b6 00             	movzbl (%rax),%eax
  801432:	3c 5a                	cmp    $0x5a,%al
  801434:	7f 3d                	jg     801473 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801436:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143a:	0f b6 00             	movzbl (%rax),%eax
  80143d:	0f be c0             	movsbl %al,%eax
  801440:	83 e8 37             	sub    $0x37,%eax
  801443:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801446:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801449:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80144c:	7c 02                	jl     801450 <strtol+0x148>
			break;
  80144e:	eb 23                	jmp    801473 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801450:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801455:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801458:	48 98                	cltq   
  80145a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80145f:	48 89 c2             	mov    %rax,%rdx
  801462:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801465:	48 98                	cltq   
  801467:	48 01 d0             	add    %rdx,%rax
  80146a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80146e:	e9 5d ff ff ff       	jmpq   8013d0 <strtol+0xc8>

	if (endptr)
  801473:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801478:	74 0b                	je     801485 <strtol+0x17d>
		*endptr = (char *) s;
  80147a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80147e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801482:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801485:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801489:	74 09                	je     801494 <strtol+0x18c>
  80148b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148f:	48 f7 d8             	neg    %rax
  801492:	eb 04                	jmp    801498 <strtol+0x190>
  801494:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801498:	c9                   	leaveq 
  801499:	c3                   	retq   

000000000080149a <strstr>:

char * strstr(const char *in, const char *str)
{
  80149a:	55                   	push   %rbp
  80149b:	48 89 e5             	mov    %rsp,%rbp
  80149e:	48 83 ec 30          	sub    $0x30,%rsp
  8014a2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014a6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014bc:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014c0:	75 06                	jne    8014c8 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	eb 6b                	jmp    801533 <strstr+0x99>

	len = strlen(str);
  8014c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014cc:	48 89 c7             	mov    %rax,%rdi
  8014cf:	48 b8 70 0d 80 00 00 	movabs $0x800d70,%rax
  8014d6:	00 00 00 
  8014d9:	ff d0                	callq  *%rax
  8014db:	48 98                	cltq   
  8014dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8014e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8014f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8014f7:	75 07                	jne    801500 <strstr+0x66>
				return (char *) 0;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fe:	eb 33                	jmp    801533 <strstr+0x99>
		} while (sc != c);
  801500:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801504:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801507:	75 d8                	jne    8014e1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801509:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80150d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801511:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801515:	48 89 ce             	mov    %rcx,%rsi
  801518:	48 89 c7             	mov    %rax,%rdi
  80151b:	48 b8 91 0f 80 00 00 	movabs $0x800f91,%rax
  801522:	00 00 00 
  801525:	ff d0                	callq  *%rax
  801527:	85 c0                	test   %eax,%eax
  801529:	75 b6                	jne    8014e1 <strstr+0x47>

	return (char *) (in - 1);
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	48 83 e8 01          	sub    $0x1,%rax
}
  801533:	c9                   	leaveq 
  801534:	c3                   	retq   

0000000000801535 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801535:	55                   	push   %rbp
  801536:	48 89 e5             	mov    %rsp,%rbp
  801539:	53                   	push   %rbx
  80153a:	48 83 ec 48          	sub    $0x48,%rsp
  80153e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801541:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801544:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801548:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80154c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801550:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801554:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801557:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80155b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80155f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801563:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801567:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80156b:	4c 89 c3             	mov    %r8,%rbx
  80156e:	cd 30                	int    $0x30
  801570:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801574:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801578:	74 3e                	je     8015b8 <syscall+0x83>
  80157a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80157f:	7e 37                	jle    8015b8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801581:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801585:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801588:	49 89 d0             	mov    %rdx,%r8
  80158b:	89 c1                	mov    %eax,%ecx
  80158d:	48 ba 48 1c 80 00 00 	movabs $0x801c48,%rdx
  801594:	00 00 00 
  801597:	be 23 00 00 00       	mov    $0x23,%esi
  80159c:	48 bf 65 1c 80 00 00 	movabs $0x801c65,%rdi
  8015a3:	00 00 00 
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ab:	49 b9 cd 16 80 00 00 	movabs $0x8016cd,%r9
  8015b2:	00 00 00 
  8015b5:	41 ff d1             	callq  *%r9

	return ret;
  8015b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015bc:	48 83 c4 48          	add    $0x48,%rsp
  8015c0:	5b                   	pop    %rbx
  8015c1:	5d                   	pop    %rbp
  8015c2:	c3                   	retq   

00000000008015c3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
  8015c7:	48 83 ec 20          	sub    $0x20,%rsp
  8015cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8015e2:	00 
  8015e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8015e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8015ef:	48 89 d1             	mov    %rdx,%rcx
  8015f2:	48 89 c2             	mov    %rax,%rdx
  8015f5:	be 00 00 00 00       	mov    $0x0,%esi
  8015fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8015ff:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  801606:	00 00 00 
  801609:	ff d0                	callq  *%rax
}
  80160b:	c9                   	leaveq 
  80160c:	c3                   	retq   

000000000080160d <sys_cgetc>:

int
sys_cgetc(void)
{
  80160d:	55                   	push   %rbp
  80160e:	48 89 e5             	mov    %rsp,%rbp
  801611:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801615:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80161c:	00 
  80161d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801623:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801629:	b9 00 00 00 00       	mov    $0x0,%ecx
  80162e:	ba 00 00 00 00       	mov    $0x0,%edx
  801633:	be 00 00 00 00       	mov    $0x0,%esi
  801638:	bf 01 00 00 00       	mov    $0x1,%edi
  80163d:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  801644:	00 00 00 
  801647:	ff d0                	callq  *%rax
}
  801649:	c9                   	leaveq 
  80164a:	c3                   	retq   

000000000080164b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80164b:	55                   	push   %rbp
  80164c:	48 89 e5             	mov    %rsp,%rbp
  80164f:	48 83 ec 10          	sub    $0x10,%rsp
  801653:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801656:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801659:	48 98                	cltq   
  80165b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801662:	00 
  801663:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801669:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80166f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801674:	48 89 c2             	mov    %rax,%rdx
  801677:	be 01 00 00 00       	mov    $0x1,%esi
  80167c:	bf 03 00 00 00       	mov    $0x3,%edi
  801681:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  801688:	00 00 00 
  80168b:	ff d0                	callq  *%rax
}
  80168d:	c9                   	leaveq 
  80168e:	c3                   	retq   

000000000080168f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80168f:	55                   	push   %rbp
  801690:	48 89 e5             	mov    %rsp,%rbp
  801693:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801697:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80169e:	00 
  80169f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b5:	be 00 00 00 00       	mov    $0x0,%esi
  8016ba:	bf 02 00 00 00       	mov    $0x2,%edi
  8016bf:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  8016c6:	00 00 00 
  8016c9:	ff d0                	callq  *%rax
}
  8016cb:	c9                   	leaveq 
  8016cc:	c3                   	retq   

00000000008016cd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8016cd:	55                   	push   %rbp
  8016ce:	48 89 e5             	mov    %rsp,%rbp
  8016d1:	53                   	push   %rbx
  8016d2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8016d9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8016e0:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8016e6:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8016ed:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8016f4:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8016fb:	84 c0                	test   %al,%al
  8016fd:	74 23                	je     801722 <_panic+0x55>
  8016ff:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801706:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80170a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80170e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801712:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801716:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80171a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80171e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801722:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801729:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801730:	00 00 00 
  801733:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80173a:	00 00 00 
  80173d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801741:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801748:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80174f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801756:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80175d:	00 00 00 
  801760:	48 8b 18             	mov    (%rax),%rbx
  801763:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  80176a:	00 00 00 
  80176d:	ff d0                	callq  *%rax
  80176f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801775:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80177c:	41 89 c8             	mov    %ecx,%r8d
  80177f:	48 89 d1             	mov    %rdx,%rcx
  801782:	48 89 da             	mov    %rbx,%rdx
  801785:	89 c6                	mov    %eax,%esi
  801787:	48 bf 78 1c 80 00 00 	movabs $0x801c78,%rdi
  80178e:	00 00 00 
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
  801796:	49 b9 14 02 80 00 00 	movabs $0x800214,%r9
  80179d:	00 00 00 
  8017a0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017a3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017aa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8017b1:	48 89 d6             	mov    %rdx,%rsi
  8017b4:	48 89 c7             	mov    %rax,%rdi
  8017b7:	48 b8 68 01 80 00 00 	movabs $0x800168,%rax
  8017be:	00 00 00 
  8017c1:	ff d0                	callq  *%rax
	cprintf("\n");
  8017c3:	48 bf 9b 1c 80 00 00 	movabs $0x801c9b,%rdi
  8017ca:	00 00 00 
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	48 ba 14 02 80 00 00 	movabs $0x800214,%rdx
  8017d9:	00 00 00 
  8017dc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8017de:	cc                   	int3   
  8017df:	eb fd                	jmp    8017de <_panic+0x111>
