
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
  800060:	48 bf 80 1a 80 00 00 	movabs $0x801a80,%rdi
  800067:	00 00 00 
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 ba 4a 02 80 00 00 	movabs $0x80024a,%rdx
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
  800081:	48 83 ec 20          	sub    $0x20,%rsp
  800085:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800088:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80008c:	48 b8 c5 16 80 00 00 	movabs $0x8016c5,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
  800098:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  80009b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a3:	48 63 d0             	movslq %eax,%rdx
  8000a6:	48 89 d0             	mov    %rdx,%rax
  8000a9:	48 c1 e0 03          	shl    $0x3,%rax
  8000ad:	48 01 d0             	add    %rdx,%rax
  8000b0:	48 c1 e0 05          	shl    $0x5,%rax
  8000b4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000bb:	00 00 00 
  8000be:	48 01 c2             	add    %rax,%rdx
  8000c1:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000c8:	00 00 00 
  8000cb:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000d2:	7e 14                	jle    8000e8 <libmain+0x6b>
		binaryname = argv[0];
  8000d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d8:	48 8b 10             	mov    (%rax),%rdx
  8000db:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000e2:	00 00 00 
  8000e5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000ef:	48 89 d6             	mov    %rdx,%rsi
  8000f2:	89 c7                	mov    %eax,%edi
  8000f4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800100:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
}
  80010c:	c9                   	leaveq 
  80010d:	c3                   	retq   

000000000080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	55                   	push   %rbp
  80010f:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800112:	bf 00 00 00 00       	mov    $0x0,%edi
  800117:	48 b8 81 16 80 00 00 	movabs $0x801681,%rax
  80011e:	00 00 00 
  800121:	ff d0                	callq  *%rax
}
  800123:	5d                   	pop    %rbp
  800124:	c3                   	retq   

0000000000800125 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800125:	55                   	push   %rbp
  800126:	48 89 e5             	mov    %rsp,%rbp
  800129:	48 83 ec 10          	sub    $0x10,%rsp
  80012d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800130:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800138:	8b 00                	mov    (%rax),%eax
  80013a:	8d 48 01             	lea    0x1(%rax),%ecx
  80013d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800141:	89 0a                	mov    %ecx,(%rdx)
  800143:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800146:	89 d1                	mov    %edx,%ecx
  800148:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80014c:	48 98                	cltq   
  80014e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800156:	8b 00                	mov    (%rax),%eax
  800158:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015d:	75 2c                	jne    80018b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80015f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800163:	8b 00                	mov    (%rax),%eax
  800165:	48 98                	cltq   
  800167:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016b:	48 83 c2 08          	add    $0x8,%rdx
  80016f:	48 89 c6             	mov    %rax,%rsi
  800172:	48 89 d7             	mov    %rdx,%rdi
  800175:	48 b8 f9 15 80 00 00 	movabs $0x8015f9,%rax
  80017c:	00 00 00 
  80017f:	ff d0                	callq  *%rax
        b->idx = 0;
  800181:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800185:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80018b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018f:	8b 40 04             	mov    0x4(%rax),%eax
  800192:	8d 50 01             	lea    0x1(%rax),%edx
  800195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800199:	89 50 04             	mov    %edx,0x4(%rax)
}
  80019c:	c9                   	leaveq 
  80019d:	c3                   	retq   

000000000080019e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80019e:	55                   	push   %rbp
  80019f:	48 89 e5             	mov    %rsp,%rbp
  8001a2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001a9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001b0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001b7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001be:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001c5:	48 8b 0a             	mov    (%rdx),%rcx
  8001c8:	48 89 08             	mov    %rcx,(%rax)
  8001cb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001cf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001d3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001d7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001e2:	00 00 00 
    b.cnt = 0;
  8001e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001ec:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001ef:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001f6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001fd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800204:	48 89 c6             	mov    %rax,%rsi
  800207:	48 bf 25 01 80 00 00 	movabs $0x800125,%rdi
  80020e:	00 00 00 
  800211:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  800218:	00 00 00 
  80021b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80021d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800223:	48 98                	cltq   
  800225:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80022c:	48 83 c2 08          	add    $0x8,%rdx
  800230:	48 89 c6             	mov    %rax,%rsi
  800233:	48 89 d7             	mov    %rdx,%rdi
  800236:	48 b8 f9 15 80 00 00 	movabs $0x8015f9,%rax
  80023d:	00 00 00 
  800240:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800242:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800248:	c9                   	leaveq 
  800249:	c3                   	retq   

000000000080024a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80024a:	55                   	push   %rbp
  80024b:	48 89 e5             	mov    %rsp,%rbp
  80024e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800255:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80025c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800263:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80026a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800271:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800278:	84 c0                	test   %al,%al
  80027a:	74 20                	je     80029c <cprintf+0x52>
  80027c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800280:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800284:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800288:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80028c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800290:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800294:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800298:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80029c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002a3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002aa:	00 00 00 
  8002ad:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002b4:	00 00 00 
  8002b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002bb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002c9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002d0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002de:	48 8b 0a             	mov    (%rdx),%rcx
  8002e1:	48 89 08             	mov    %rcx,(%rax)
  8002e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002f4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800302:	48 89 d6             	mov    %rdx,%rsi
  800305:	48 89 c7             	mov    %rax,%rdi
  800308:	48 b8 9e 01 80 00 00 	movabs $0x80019e,%rax
  80030f:	00 00 00 
  800312:	ff d0                	callq  *%rax
  800314:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80031a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800320:	c9                   	leaveq 
  800321:	c3                   	retq   

0000000000800322 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800322:	55                   	push   %rbp
  800323:	48 89 e5             	mov    %rsp,%rbp
  800326:	53                   	push   %rbx
  800327:	48 83 ec 38          	sub    $0x38,%rsp
  80032b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80032f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800333:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800337:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80033a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80033e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800342:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800345:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800349:	77 3b                	ja     800386 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80034e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800352:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800359:	ba 00 00 00 00       	mov    $0x0,%edx
  80035e:	48 f7 f3             	div    %rbx
  800361:	48 89 c2             	mov    %rax,%rdx
  800364:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800367:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80036a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80036e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800372:	41 89 f9             	mov    %edi,%r9d
  800375:	48 89 c7             	mov    %rax,%rdi
  800378:	48 b8 22 03 80 00 00 	movabs $0x800322,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax
  800384:	eb 1e                	jmp    8003a4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800386:	eb 12                	jmp    80039a <printnum+0x78>
			putch(padc, putdat);
  800388:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80038c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80038f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800393:	48 89 ce             	mov    %rcx,%rsi
  800396:	89 d7                	mov    %edx,%edi
  800398:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80039e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003a2:	7f e4                	jg     800388 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b0:	48 f7 f1             	div    %rcx
  8003b3:	48 89 d0             	mov    %rdx,%rax
  8003b6:	48 ba 10 1c 80 00 00 	movabs $0x801c10,%rdx
  8003bd:	00 00 00 
  8003c0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003c4:	0f be d0             	movsbl %al,%edx
  8003c7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003cf:	48 89 ce             	mov    %rcx,%rsi
  8003d2:	89 d7                	mov    %edx,%edi
  8003d4:	ff d0                	callq  *%rax
}
  8003d6:	48 83 c4 38          	add    $0x38,%rsp
  8003da:	5b                   	pop    %rbx
  8003db:	5d                   	pop    %rbp
  8003dc:	c3                   	retq   

00000000008003dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003dd:	55                   	push   %rbp
  8003de:	48 89 e5             	mov    %rsp,%rbp
  8003e1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003f0:	7e 52                	jle    800444 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f6:	8b 00                	mov    (%rax),%eax
  8003f8:	83 f8 30             	cmp    $0x30,%eax
  8003fb:	73 24                	jae    800421 <getuint+0x44>
  8003fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800401:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800409:	8b 00                	mov    (%rax),%eax
  80040b:	89 c0                	mov    %eax,%eax
  80040d:	48 01 d0             	add    %rdx,%rax
  800410:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800414:	8b 12                	mov    (%rdx),%edx
  800416:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800419:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80041d:	89 0a                	mov    %ecx,(%rdx)
  80041f:	eb 17                	jmp    800438 <getuint+0x5b>
  800421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800425:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800429:	48 89 d0             	mov    %rdx,%rax
  80042c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800430:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800434:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800438:	48 8b 00             	mov    (%rax),%rax
  80043b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80043f:	e9 a3 00 00 00       	jmpq   8004e7 <getuint+0x10a>
	else if (lflag)
  800444:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800448:	74 4f                	je     800499 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80044a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044e:	8b 00                	mov    (%rax),%eax
  800450:	83 f8 30             	cmp    $0x30,%eax
  800453:	73 24                	jae    800479 <getuint+0x9c>
  800455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800459:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80045d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800461:	8b 00                	mov    (%rax),%eax
  800463:	89 c0                	mov    %eax,%eax
  800465:	48 01 d0             	add    %rdx,%rax
  800468:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80046c:	8b 12                	mov    (%rdx),%edx
  80046e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800471:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800475:	89 0a                	mov    %ecx,(%rdx)
  800477:	eb 17                	jmp    800490 <getuint+0xb3>
  800479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800481:	48 89 d0             	mov    %rdx,%rax
  800484:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800488:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800490:	48 8b 00             	mov    (%rax),%rax
  800493:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800497:	eb 4e                	jmp    8004e7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	8b 00                	mov    (%rax),%eax
  80049f:	83 f8 30             	cmp    $0x30,%eax
  8004a2:	73 24                	jae    8004c8 <getuint+0xeb>
  8004a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b0:	8b 00                	mov    (%rax),%eax
  8004b2:	89 c0                	mov    %eax,%eax
  8004b4:	48 01 d0             	add    %rdx,%rax
  8004b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004bb:	8b 12                	mov    (%rdx),%edx
  8004bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c4:	89 0a                	mov    %ecx,(%rdx)
  8004c6:	eb 17                	jmp    8004df <getuint+0x102>
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d0:	48 89 d0             	mov    %rdx,%rax
  8004d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004df:	8b 00                	mov    (%rax),%eax
  8004e1:	89 c0                	mov    %eax,%eax
  8004e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004eb:	c9                   	leaveq 
  8004ec:	c3                   	retq   

00000000008004ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004fc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800500:	7e 52                	jle    800554 <getint+0x67>
		x=va_arg(*ap, long long);
  800502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800506:	8b 00                	mov    (%rax),%eax
  800508:	83 f8 30             	cmp    $0x30,%eax
  80050b:	73 24                	jae    800531 <getint+0x44>
  80050d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800511:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800515:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800519:	8b 00                	mov    (%rax),%eax
  80051b:	89 c0                	mov    %eax,%eax
  80051d:	48 01 d0             	add    %rdx,%rax
  800520:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800524:	8b 12                	mov    (%rdx),%edx
  800526:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800529:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052d:	89 0a                	mov    %ecx,(%rdx)
  80052f:	eb 17                	jmp    800548 <getint+0x5b>
  800531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800535:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800539:	48 89 d0             	mov    %rdx,%rax
  80053c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800540:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800544:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800548:	48 8b 00             	mov    (%rax),%rax
  80054b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80054f:	e9 a3 00 00 00       	jmpq   8005f7 <getint+0x10a>
	else if (lflag)
  800554:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800558:	74 4f                	je     8005a9 <getint+0xbc>
		x=va_arg(*ap, long);
  80055a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055e:	8b 00                	mov    (%rax),%eax
  800560:	83 f8 30             	cmp    $0x30,%eax
  800563:	73 24                	jae    800589 <getint+0x9c>
  800565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800569:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	8b 00                	mov    (%rax),%eax
  800573:	89 c0                	mov    %eax,%eax
  800575:	48 01 d0             	add    %rdx,%rax
  800578:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057c:	8b 12                	mov    (%rdx),%edx
  80057e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800581:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800585:	89 0a                	mov    %ecx,(%rdx)
  800587:	eb 17                	jmp    8005a0 <getint+0xb3>
  800589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800591:	48 89 d0             	mov    %rdx,%rax
  800594:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800598:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a0:	48 8b 00             	mov    (%rax),%rax
  8005a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005a7:	eb 4e                	jmp    8005f7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	8b 00                	mov    (%rax),%eax
  8005af:	83 f8 30             	cmp    $0x30,%eax
  8005b2:	73 24                	jae    8005d8 <getint+0xeb>
  8005b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c0:	8b 00                	mov    (%rax),%eax
  8005c2:	89 c0                	mov    %eax,%eax
  8005c4:	48 01 d0             	add    %rdx,%rax
  8005c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cb:	8b 12                	mov    (%rdx),%edx
  8005cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d4:	89 0a                	mov    %ecx,(%rdx)
  8005d6:	eb 17                	jmp    8005ef <getint+0x102>
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e0:	48 89 d0             	mov    %rdx,%rax
  8005e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ef:	8b 00                	mov    (%rax),%eax
  8005f1:	48 98                	cltq   
  8005f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005fb:	c9                   	leaveq 
  8005fc:	c3                   	retq   

00000000008005fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fd:	55                   	push   %rbp
  8005fe:	48 89 e5             	mov    %rsp,%rbp
  800601:	41 54                	push   %r12
  800603:	53                   	push   %rbx
  800604:	48 83 ec 60          	sub    $0x60,%rsp
  800608:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80060c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800610:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800614:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800618:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80061c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800620:	48 8b 0a             	mov    (%rdx),%rcx
  800623:	48 89 08             	mov    %rcx,(%rax)
  800626:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80062a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80062e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800632:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800636:	eb 17                	jmp    80064f <vprintfmt+0x52>
			if (ch == '\0')
  800638:	85 db                	test   %ebx,%ebx
  80063a:	0f 84 df 04 00 00    	je     800b1f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800640:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800644:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800648:	48 89 d6             	mov    %rdx,%rsi
  80064b:	89 df                	mov    %ebx,%edi
  80064d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800653:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800657:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80065b:	0f b6 00             	movzbl (%rax),%eax
  80065e:	0f b6 d8             	movzbl %al,%ebx
  800661:	83 fb 25             	cmp    $0x25,%ebx
  800664:	75 d2                	jne    800638 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800666:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80066a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800671:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800678:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80067f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800686:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80068a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80068e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800692:	0f b6 00             	movzbl (%rax),%eax
  800695:	0f b6 d8             	movzbl %al,%ebx
  800698:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80069b:	83 f8 55             	cmp    $0x55,%eax
  80069e:	0f 87 47 04 00 00    	ja     800aeb <vprintfmt+0x4ee>
  8006a4:	89 c0                	mov    %eax,%eax
  8006a6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006ad:	00 
  8006ae:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  8006b5:	00 00 00 
  8006b8:	48 01 d0             	add    %rdx,%rax
  8006bb:	48 8b 00             	mov    (%rax),%rax
  8006be:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006c0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006c4:	eb c0                	jmp    800686 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006ca:	eb ba                	jmp    800686 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006cc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006d3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006d6:	89 d0                	mov    %edx,%eax
  8006d8:	c1 e0 02             	shl    $0x2,%eax
  8006db:	01 d0                	add    %edx,%eax
  8006dd:	01 c0                	add    %eax,%eax
  8006df:	01 d8                	add    %ebx,%eax
  8006e1:	83 e8 30             	sub    $0x30,%eax
  8006e4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006e7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006eb:	0f b6 00             	movzbl (%rax),%eax
  8006ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f4:	7e 0c                	jle    800702 <vprintfmt+0x105>
  8006f6:	83 fb 39             	cmp    $0x39,%ebx
  8006f9:	7f 07                	jg     800702 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800700:	eb d1                	jmp    8006d3 <vprintfmt+0xd6>
			goto process_precision;
  800702:	eb 58                	jmp    80075c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800704:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800707:	83 f8 30             	cmp    $0x30,%eax
  80070a:	73 17                	jae    800723 <vprintfmt+0x126>
  80070c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800710:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800713:	89 c0                	mov    %eax,%eax
  800715:	48 01 d0             	add    %rdx,%rax
  800718:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80071b:	83 c2 08             	add    $0x8,%edx
  80071e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800721:	eb 0f                	jmp    800732 <vprintfmt+0x135>
  800723:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800727:	48 89 d0             	mov    %rdx,%rax
  80072a:	48 83 c2 08          	add    $0x8,%rdx
  80072e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800732:	8b 00                	mov    (%rax),%eax
  800734:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800737:	eb 23                	jmp    80075c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800739:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80073d:	79 0c                	jns    80074b <vprintfmt+0x14e>
				width = 0;
  80073f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800746:	e9 3b ff ff ff       	jmpq   800686 <vprintfmt+0x89>
  80074b:	e9 36 ff ff ff       	jmpq   800686 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800750:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800757:	e9 2a ff ff ff       	jmpq   800686 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80075c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800760:	79 12                	jns    800774 <vprintfmt+0x177>
				width = precision, precision = -1;
  800762:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800765:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800768:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80076f:	e9 12 ff ff ff       	jmpq   800686 <vprintfmt+0x89>
  800774:	e9 0d ff ff ff       	jmpq   800686 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800779:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80077d:	e9 04 ff ff ff       	jmpq   800686 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800782:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800785:	83 f8 30             	cmp    $0x30,%eax
  800788:	73 17                	jae    8007a1 <vprintfmt+0x1a4>
  80078a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80078e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800791:	89 c0                	mov    %eax,%eax
  800793:	48 01 d0             	add    %rdx,%rax
  800796:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800799:	83 c2 08             	add    $0x8,%edx
  80079c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80079f:	eb 0f                	jmp    8007b0 <vprintfmt+0x1b3>
  8007a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007a5:	48 89 d0             	mov    %rdx,%rax
  8007a8:	48 83 c2 08          	add    $0x8,%rdx
  8007ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007b0:	8b 10                	mov    (%rax),%edx
  8007b2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ba:	48 89 ce             	mov    %rcx,%rsi
  8007bd:	89 d7                	mov    %edx,%edi
  8007bf:	ff d0                	callq  *%rax
			break;
  8007c1:	e9 53 03 00 00       	jmpq   800b19 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	83 f8 30             	cmp    $0x30,%eax
  8007cc:	73 17                	jae    8007e5 <vprintfmt+0x1e8>
  8007ce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d5:	89 c0                	mov    %eax,%eax
  8007d7:	48 01 d0             	add    %rdx,%rax
  8007da:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007dd:	83 c2 08             	add    $0x8,%edx
  8007e0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007e3:	eb 0f                	jmp    8007f4 <vprintfmt+0x1f7>
  8007e5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007e9:	48 89 d0             	mov    %rdx,%rax
  8007ec:	48 83 c2 08          	add    $0x8,%rdx
  8007f0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007f4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007f6:	85 db                	test   %ebx,%ebx
  8007f8:	79 02                	jns    8007fc <vprintfmt+0x1ff>
				err = -err;
  8007fa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007fc:	83 fb 15             	cmp    $0x15,%ebx
  8007ff:	7f 16                	jg     800817 <vprintfmt+0x21a>
  800801:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800808:	00 00 00 
  80080b:	48 63 d3             	movslq %ebx,%rdx
  80080e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800812:	4d 85 e4             	test   %r12,%r12
  800815:	75 2e                	jne    800845 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800817:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80081b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80081f:	89 d9                	mov    %ebx,%ecx
  800821:	48 ba 21 1c 80 00 00 	movabs $0x801c21,%rdx
  800828:	00 00 00 
  80082b:	48 89 c7             	mov    %rax,%rdi
  80082e:	b8 00 00 00 00       	mov    $0x0,%eax
  800833:	49 b8 28 0b 80 00 00 	movabs $0x800b28,%r8
  80083a:	00 00 00 
  80083d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800840:	e9 d4 02 00 00       	jmpq   800b19 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800845:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800849:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80084d:	4c 89 e1             	mov    %r12,%rcx
  800850:	48 ba 2a 1c 80 00 00 	movabs $0x801c2a,%rdx
  800857:	00 00 00 
  80085a:	48 89 c7             	mov    %rax,%rdi
  80085d:	b8 00 00 00 00       	mov    $0x0,%eax
  800862:	49 b8 28 0b 80 00 00 	movabs $0x800b28,%r8
  800869:	00 00 00 
  80086c:	41 ff d0             	callq  *%r8
			break;
  80086f:	e9 a5 02 00 00       	jmpq   800b19 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800874:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800877:	83 f8 30             	cmp    $0x30,%eax
  80087a:	73 17                	jae    800893 <vprintfmt+0x296>
  80087c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800880:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800883:	89 c0                	mov    %eax,%eax
  800885:	48 01 d0             	add    %rdx,%rax
  800888:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088b:	83 c2 08             	add    $0x8,%edx
  80088e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800891:	eb 0f                	jmp    8008a2 <vprintfmt+0x2a5>
  800893:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800897:	48 89 d0             	mov    %rdx,%rax
  80089a:	48 83 c2 08          	add    $0x8,%rdx
  80089e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a2:	4c 8b 20             	mov    (%rax),%r12
  8008a5:	4d 85 e4             	test   %r12,%r12
  8008a8:	75 0a                	jne    8008b4 <vprintfmt+0x2b7>
				p = "(null)";
  8008aa:	49 bc 2d 1c 80 00 00 	movabs $0x801c2d,%r12
  8008b1:	00 00 00 
			if (width > 0 && padc != '-')
  8008b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008b8:	7e 3f                	jle    8008f9 <vprintfmt+0x2fc>
  8008ba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008be:	74 39                	je     8008f9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008c3:	48 98                	cltq   
  8008c5:	48 89 c6             	mov    %rax,%rsi
  8008c8:	4c 89 e7             	mov    %r12,%rdi
  8008cb:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  8008d2:	00 00 00 
  8008d5:	ff d0                	callq  *%rax
  8008d7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008da:	eb 17                	jmp    8008f3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008dc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008e0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e8:	48 89 ce             	mov    %rcx,%rsi
  8008eb:	89 d7                	mov    %edx,%edi
  8008ed:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008f7:	7f e3                	jg     8008dc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f9:	eb 37                	jmp    800932 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008ff:	74 1e                	je     80091f <vprintfmt+0x322>
  800901:	83 fb 1f             	cmp    $0x1f,%ebx
  800904:	7e 05                	jle    80090b <vprintfmt+0x30e>
  800906:	83 fb 7e             	cmp    $0x7e,%ebx
  800909:	7e 14                	jle    80091f <vprintfmt+0x322>
					putch('?', putdat);
  80090b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80090f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800913:	48 89 d6             	mov    %rdx,%rsi
  800916:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80091b:	ff d0                	callq  *%rax
  80091d:	eb 0f                	jmp    80092e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80091f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800923:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800927:	48 89 d6             	mov    %rdx,%rsi
  80092a:	89 df                	mov    %ebx,%edi
  80092c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800932:	4c 89 e0             	mov    %r12,%rax
  800935:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800939:	0f b6 00             	movzbl (%rax),%eax
  80093c:	0f be d8             	movsbl %al,%ebx
  80093f:	85 db                	test   %ebx,%ebx
  800941:	74 10                	je     800953 <vprintfmt+0x356>
  800943:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800947:	78 b2                	js     8008fb <vprintfmt+0x2fe>
  800949:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80094d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800951:	79 a8                	jns    8008fb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800953:	eb 16                	jmp    80096b <vprintfmt+0x36e>
				putch(' ', putdat);
  800955:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800959:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80095d:	48 89 d6             	mov    %rdx,%rsi
  800960:	bf 20 00 00 00       	mov    $0x20,%edi
  800965:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800967:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80096b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096f:	7f e4                	jg     800955 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800971:	e9 a3 01 00 00       	jmpq   800b19 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800976:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80097a:	be 03 00 00 00       	mov    $0x3,%esi
  80097f:	48 89 c7             	mov    %rax,%rdi
  800982:	48 b8 ed 04 80 00 00 	movabs $0x8004ed,%rax
  800989:	00 00 00 
  80098c:	ff d0                	callq  *%rax
  80098e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800996:	48 85 c0             	test   %rax,%rax
  800999:	79 1d                	jns    8009b8 <vprintfmt+0x3bb>
				putch('-', putdat);
  80099b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80099f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a3:	48 89 d6             	mov    %rdx,%rsi
  8009a6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009ab:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 f7 d8             	neg    %rax
  8009b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009b8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009bf:	e9 e8 00 00 00       	jmpq   800aac <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009c8:	be 03 00 00 00       	mov    $0x3,%esi
  8009cd:	48 89 c7             	mov    %rax,%rdi
  8009d0:	48 b8 dd 03 80 00 00 	movabs $0x8003dd,%rax
  8009d7:	00 00 00 
  8009da:	ff d0                	callq  *%rax
  8009dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009e0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e7:	e9 c0 00 00 00       	jmpq   800aac <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f4:	48 89 d6             	mov    %rdx,%rsi
  8009f7:	bf 58 00 00 00       	mov    $0x58,%edi
  8009fc:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a06:	48 89 d6             	mov    %rdx,%rsi
  800a09:	bf 58 00 00 00       	mov    $0x58,%edi
  800a0e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a18:	48 89 d6             	mov    %rdx,%rsi
  800a1b:	bf 58 00 00 00       	mov    $0x58,%edi
  800a20:	ff d0                	callq  *%rax
			break;
  800a22:	e9 f2 00 00 00       	jmpq   800b19 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2f:	48 89 d6             	mov    %rdx,%rsi
  800a32:	bf 30 00 00 00       	mov    $0x30,%edi
  800a37:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a41:	48 89 d6             	mov    %rdx,%rsi
  800a44:	bf 78 00 00 00       	mov    $0x78,%edi
  800a49:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4e:	83 f8 30             	cmp    $0x30,%eax
  800a51:	73 17                	jae    800a6a <vprintfmt+0x46d>
  800a53:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5a:	89 c0                	mov    %eax,%eax
  800a5c:	48 01 d0             	add    %rdx,%rax
  800a5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a62:	83 c2 08             	add    $0x8,%edx
  800a65:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a68:	eb 0f                	jmp    800a79 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6e:	48 89 d0             	mov    %rdx,%rax
  800a71:	48 83 c2 08          	add    $0x8,%rdx
  800a75:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a79:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a87:	eb 23                	jmp    800aac <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a8d:	be 03 00 00 00       	mov    $0x3,%esi
  800a92:	48 89 c7             	mov    %rax,%rdi
  800a95:	48 b8 dd 03 80 00 00 	movabs $0x8003dd,%rax
  800a9c:	00 00 00 
  800a9f:	ff d0                	callq  *%rax
  800aa1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800aa5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aac:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ab1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ab4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ab7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac3:	45 89 c1             	mov    %r8d,%r9d
  800ac6:	41 89 f8             	mov    %edi,%r8d
  800ac9:	48 89 c7             	mov    %rax,%rdi
  800acc:	48 b8 22 03 80 00 00 	movabs $0x800322,%rax
  800ad3:	00 00 00 
  800ad6:	ff d0                	callq  *%rax
			break;
  800ad8:	eb 3f                	jmp    800b19 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ada:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ade:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae2:	48 89 d6             	mov    %rdx,%rsi
  800ae5:	89 df                	mov    %ebx,%edi
  800ae7:	ff d0                	callq  *%rax
			break;
  800ae9:	eb 2e                	jmp    800b19 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aeb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af3:	48 89 d6             	mov    %rdx,%rsi
  800af6:	bf 25 00 00 00       	mov    $0x25,%edi
  800afb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b02:	eb 05                	jmp    800b09 <vprintfmt+0x50c>
  800b04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b0d:	48 83 e8 01          	sub    $0x1,%rax
  800b11:	0f b6 00             	movzbl (%rax),%eax
  800b14:	3c 25                	cmp    $0x25,%al
  800b16:	75 ec                	jne    800b04 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b18:	90                   	nop
		}
	}
  800b19:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1a:	e9 30 fb ff ff       	jmpq   80064f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b1f:	48 83 c4 60          	add    $0x60,%rsp
  800b23:	5b                   	pop    %rbx
  800b24:	41 5c                	pop    %r12
  800b26:	5d                   	pop    %rbp
  800b27:	c3                   	retq   

0000000000800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %rbp
  800b29:	48 89 e5             	mov    %rsp,%rbp
  800b2c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b33:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b3a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b41:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b48:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b4f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b56:	84 c0                	test   %al,%al
  800b58:	74 20                	je     800b7a <printfmt+0x52>
  800b5a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b5e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b62:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b66:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b6a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b6e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b72:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b76:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b7a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b81:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b88:	00 00 00 
  800b8b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b92:	00 00 00 
  800b95:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b99:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ba0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bae:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bb5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bbc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bc3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bca:	48 89 c7             	mov    %rax,%rdi
  800bcd:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bd9:	c9                   	leaveq 
  800bda:	c3                   	retq   

0000000000800bdb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bdb:	55                   	push   %rbp
  800bdc:	48 89 e5             	mov    %rsp,%rbp
  800bdf:	48 83 ec 10          	sub    $0x10,%rsp
  800be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800be6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bee:	8b 40 10             	mov    0x10(%rax),%eax
  800bf1:	8d 50 01             	lea    0x1(%rax),%edx
  800bf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bff:	48 8b 10             	mov    (%rax),%rdx
  800c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c06:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c0a:	48 39 c2             	cmp    %rax,%rdx
  800c0d:	73 17                	jae    800c26 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c13:	48 8b 00             	mov    (%rax),%rax
  800c16:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1e:	48 89 0a             	mov    %rcx,(%rdx)
  800c21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c24:	88 10                	mov    %dl,(%rax)
}
  800c26:	c9                   	leaveq 
  800c27:	c3                   	retq   

0000000000800c28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c28:	55                   	push   %rbp
  800c29:	48 89 e5             	mov    %rsp,%rbp
  800c2c:	48 83 ec 50          	sub    $0x50,%rsp
  800c30:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c34:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c37:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c3b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c3f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c43:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c47:	48 8b 0a             	mov    (%rdx),%rcx
  800c4a:	48 89 08             	mov    %rcx,(%rax)
  800c4d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c51:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c55:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c59:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c61:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c65:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c68:	48 98                	cltq   
  800c6a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c6e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c72:	48 01 d0             	add    %rdx,%rax
  800c75:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c80:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c85:	74 06                	je     800c8d <vsnprintf+0x65>
  800c87:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c8b:	7f 07                	jg     800c94 <vsnprintf+0x6c>
		return -E_INVAL;
  800c8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c92:	eb 2f                	jmp    800cc3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c94:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c98:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c9c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ca0:	48 89 c6             	mov    %rax,%rsi
  800ca3:	48 bf db 0b 80 00 00 	movabs $0x800bdb,%rdi
  800caa:	00 00 00 
  800cad:	48 b8 fd 05 80 00 00 	movabs $0x8005fd,%rax
  800cb4:	00 00 00 
  800cb7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cbd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cc0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cc3:	c9                   	leaveq 
  800cc4:	c3                   	retq   

0000000000800cc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc5:	55                   	push   %rbp
  800cc6:	48 89 e5             	mov    %rsp,%rbp
  800cc9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cd0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cd7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cdd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ce4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ceb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 20                	je     800d16 <snprintf+0x51>
  800cf6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cfa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cfe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d02:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d06:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d0a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d0e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d12:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d16:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d1d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d24:	00 00 00 
  800d27:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d2e:	00 00 00 
  800d31:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d35:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d3c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d4a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d51:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d58:	48 8b 0a             	mov    (%rdx),%rcx
  800d5b:	48 89 08             	mov    %rcx,(%rax)
  800d5e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d62:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d66:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d6a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d6e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d75:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d7c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d82:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d89:	48 89 c7             	mov    %rax,%rdi
  800d8c:	48 b8 28 0c 80 00 00 	movabs $0x800c28,%rax
  800d93:	00 00 00 
  800d96:	ff d0                	callq  *%rax
  800d98:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d9e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800da4:	c9                   	leaveq 
  800da5:	c3                   	retq   

0000000000800da6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800da6:	55                   	push   %rbp
  800da7:	48 89 e5             	mov    %rsp,%rbp
  800daa:	48 83 ec 18          	sub    $0x18,%rsp
  800dae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800db2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800db9:	eb 09                	jmp    800dc4 <strlen+0x1e>
		n++;
  800dbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc8:	0f b6 00             	movzbl (%rax),%eax
  800dcb:	84 c0                	test   %al,%al
  800dcd:	75 ec                	jne    800dbb <strlen+0x15>
		n++;
	return n;
  800dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dd2:	c9                   	leaveq 
  800dd3:	c3                   	retq   

0000000000800dd4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dd4:	55                   	push   %rbp
  800dd5:	48 89 e5             	mov    %rsp,%rbp
  800dd8:	48 83 ec 20          	sub    $0x20,%rsp
  800ddc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800de0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800deb:	eb 0e                	jmp    800dfb <strnlen+0x27>
		n++;
  800ded:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800df6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dfb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e00:	74 0b                	je     800e0d <strnlen+0x39>
  800e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e06:	0f b6 00             	movzbl (%rax),%eax
  800e09:	84 c0                	test   %al,%al
  800e0b:	75 e0                	jne    800ded <strnlen+0x19>
		n++;
	return n;
  800e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e10:	c9                   	leaveq 
  800e11:	c3                   	retq   

0000000000800e12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e12:	55                   	push   %rbp
  800e13:	48 89 e5             	mov    %rsp,%rbp
  800e16:	48 83 ec 20          	sub    $0x20,%rsp
  800e1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e37:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e3b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e3f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e43:	0f b6 12             	movzbl (%rdx),%edx
  800e46:	88 10                	mov    %dl,(%rax)
  800e48:	0f b6 00             	movzbl (%rax),%eax
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 dc                	jne    800e2b <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e53:	c9                   	leaveq 
  800e54:	c3                   	retq   

0000000000800e55 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e55:	55                   	push   %rbp
  800e56:	48 89 e5             	mov    %rsp,%rbp
  800e59:	48 83 ec 20          	sub    $0x20,%rsp
  800e5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e69:	48 89 c7             	mov    %rax,%rdi
  800e6c:	48 b8 a6 0d 80 00 00 	movabs $0x800da6,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	callq  *%rax
  800e78:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e7e:	48 63 d0             	movslq %eax,%rdx
  800e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e85:	48 01 c2             	add    %rax,%rdx
  800e88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e8c:	48 89 c6             	mov    %rax,%rsi
  800e8f:	48 89 d7             	mov    %rdx,%rdi
  800e92:	48 b8 12 0e 80 00 00 	movabs $0x800e12,%rax
  800e99:	00 00 00 
  800e9c:	ff d0                	callq  *%rax
	return dst;
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ea2:	c9                   	leaveq 
  800ea3:	c3                   	retq   

0000000000800ea4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ea4:	55                   	push   %rbp
  800ea5:	48 89 e5             	mov    %rsp,%rbp
  800ea8:	48 83 ec 28          	sub    $0x28,%rsp
  800eac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800eb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ec0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ec7:	00 
  800ec8:	eb 2a                	jmp    800ef4 <strncpy+0x50>
		*dst++ = *src;
  800eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ece:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ed2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ed6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eda:	0f b6 12             	movzbl (%rdx),%edx
  800edd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800edf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ee3:	0f b6 00             	movzbl (%rax),%eax
  800ee6:	84 c0                	test   %al,%al
  800ee8:	74 05                	je     800eef <strncpy+0x4b>
			src++;
  800eea:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ef8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800efc:	72 cc                	jb     800eca <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 83 ec 28          	sub    $0x28,%rsp
  800f0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f20:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f25:	74 3d                	je     800f64 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f27:	eb 1d                	jmp    800f46 <strlcpy+0x42>
			*dst++ = *src++;
  800f29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f31:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f39:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f3d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f41:	0f b6 12             	movzbl (%rdx),%edx
  800f44:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f46:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f4b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f50:	74 0b                	je     800f5d <strlcpy+0x59>
  800f52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f56:	0f b6 00             	movzbl (%rax),%eax
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 cc                	jne    800f29 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f61:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f6c:	48 29 c2             	sub    %rax,%rdx
  800f6f:	48 89 d0             	mov    %rdx,%rax
}
  800f72:	c9                   	leaveq 
  800f73:	c3                   	retq   

0000000000800f74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f74:	55                   	push   %rbp
  800f75:	48 89 e5             	mov    %rsp,%rbp
  800f78:	48 83 ec 10          	sub    $0x10,%rsp
  800f7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f84:	eb 0a                	jmp    800f90 <strcmp+0x1c>
		p++, q++;
  800f86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f8b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f94:	0f b6 00             	movzbl (%rax),%eax
  800f97:	84 c0                	test   %al,%al
  800f99:	74 12                	je     800fad <strcmp+0x39>
  800f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f9f:	0f b6 10             	movzbl (%rax),%edx
  800fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa6:	0f b6 00             	movzbl (%rax),%eax
  800fa9:	38 c2                	cmp    %al,%dl
  800fab:	74 d9                	je     800f86 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb1:	0f b6 00             	movzbl (%rax),%eax
  800fb4:	0f b6 d0             	movzbl %al,%edx
  800fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbb:	0f b6 00             	movzbl (%rax),%eax
  800fbe:	0f b6 c0             	movzbl %al,%eax
  800fc1:	29 c2                	sub    %eax,%edx
  800fc3:	89 d0                	mov    %edx,%eax
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 18          	sub    $0x18,%rsp
  800fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fdb:	eb 0f                	jmp    800fec <strncmp+0x25>
		n--, p++, q++;
  800fdd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fe2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fe7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ff1:	74 1d                	je     801010 <strncmp+0x49>
  800ff3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	84 c0                	test   %al,%al
  800ffc:	74 12                	je     801010 <strncmp+0x49>
  800ffe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801002:	0f b6 10             	movzbl (%rax),%edx
  801005:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801009:	0f b6 00             	movzbl (%rax),%eax
  80100c:	38 c2                	cmp    %al,%dl
  80100e:	74 cd                	je     800fdd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801010:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801015:	75 07                	jne    80101e <strncmp+0x57>
		return 0;
  801017:	b8 00 00 00 00       	mov    $0x0,%eax
  80101c:	eb 18                	jmp    801036 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80101e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801022:	0f b6 00             	movzbl (%rax),%eax
  801025:	0f b6 d0             	movzbl %al,%edx
  801028:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102c:	0f b6 00             	movzbl (%rax),%eax
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
}
  801036:	c9                   	leaveq 
  801037:	c3                   	retq   

0000000000801038 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801038:	55                   	push   %rbp
  801039:	48 89 e5             	mov    %rsp,%rbp
  80103c:	48 83 ec 0c          	sub    $0xc,%rsp
  801040:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801044:	89 f0                	mov    %esi,%eax
  801046:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801049:	eb 17                	jmp    801062 <strchr+0x2a>
		if (*s == c)
  80104b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801055:	75 06                	jne    80105d <strchr+0x25>
			return (char *) s;
  801057:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105b:	eb 15                	jmp    801072 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80105d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801066:	0f b6 00             	movzbl (%rax),%eax
  801069:	84 c0                	test   %al,%al
  80106b:	75 de                	jne    80104b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80106d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801072:	c9                   	leaveq 
  801073:	c3                   	retq   

0000000000801074 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801074:	55                   	push   %rbp
  801075:	48 89 e5             	mov    %rsp,%rbp
  801078:	48 83 ec 0c          	sub    $0xc,%rsp
  80107c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801080:	89 f0                	mov    %esi,%eax
  801082:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801085:	eb 13                	jmp    80109a <strfind+0x26>
		if (*s == c)
  801087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108b:	0f b6 00             	movzbl (%rax),%eax
  80108e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801091:	75 02                	jne    801095 <strfind+0x21>
			break;
  801093:	eb 10                	jmp    8010a5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801095:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	84 c0                	test   %al,%al
  8010a3:	75 e2                	jne    801087 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 83 ec 18          	sub    $0x18,%rsp
  8010b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010be:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010c3:	75 06                	jne    8010cb <memset+0x20>
		return v;
  8010c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c9:	eb 69                	jmp    801134 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cf:	83 e0 03             	and    $0x3,%eax
  8010d2:	48 85 c0             	test   %rax,%rax
  8010d5:	75 48                	jne    80111f <memset+0x74>
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	83 e0 03             	and    $0x3,%eax
  8010de:	48 85 c0             	test   %rax,%rax
  8010e1:	75 3c                	jne    80111f <memset+0x74>
		c &= 0xFF;
  8010e3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010ed:	c1 e0 18             	shl    $0x18,%eax
  8010f0:	89 c2                	mov    %eax,%edx
  8010f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f5:	c1 e0 10             	shl    $0x10,%eax
  8010f8:	09 c2                	or     %eax,%edx
  8010fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010fd:	c1 e0 08             	shl    $0x8,%eax
  801100:	09 d0                	or     %edx,%eax
  801102:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801109:	48 c1 e8 02          	shr    $0x2,%rax
  80110d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801110:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801117:	48 89 d7             	mov    %rdx,%rdi
  80111a:	fc                   	cld    
  80111b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80111d:	eb 11                	jmp    801130 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80111f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801123:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801126:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80112a:	48 89 d7             	mov    %rdx,%rdi
  80112d:	fc                   	cld    
  80112e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 28          	sub    $0x28,%rsp
  80113e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801142:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801146:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80114a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80114e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801156:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80115a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801162:	0f 83 88 00 00 00    	jae    8011f0 <memmove+0xba>
  801168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80116c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801170:	48 01 d0             	add    %rdx,%rax
  801173:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801177:	76 77                	jbe    8011f0 <memmove+0xba>
		s += n;
  801179:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80117d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801181:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801185:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118d:	83 e0 03             	and    $0x3,%eax
  801190:	48 85 c0             	test   %rax,%rax
  801193:	75 3b                	jne    8011d0 <memmove+0x9a>
  801195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801199:	83 e0 03             	and    $0x3,%eax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 2f                	jne    8011d0 <memmove+0x9a>
  8011a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a5:	83 e0 03             	and    $0x3,%eax
  8011a8:	48 85 c0             	test   %rax,%rax
  8011ab:	75 23                	jne    8011d0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b1:	48 83 e8 04          	sub    $0x4,%rax
  8011b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b9:	48 83 ea 04          	sub    $0x4,%rdx
  8011bd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011c1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011c5:	48 89 c7             	mov    %rax,%rdi
  8011c8:	48 89 d6             	mov    %rdx,%rsi
  8011cb:	fd                   	std    
  8011cc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011ce:	eb 1d                	jmp    8011ed <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e4:	48 89 d7             	mov    %rdx,%rdi
  8011e7:	48 89 c1             	mov    %rax,%rcx
  8011ea:	fd                   	std    
  8011eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011ed:	fc                   	cld    
  8011ee:	eb 57                	jmp    801247 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	83 e0 03             	and    $0x3,%eax
  8011f7:	48 85 c0             	test   %rax,%rax
  8011fa:	75 36                	jne    801232 <memmove+0xfc>
  8011fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801200:	83 e0 03             	and    $0x3,%eax
  801203:	48 85 c0             	test   %rax,%rax
  801206:	75 2a                	jne    801232 <memmove+0xfc>
  801208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120c:	83 e0 03             	and    $0x3,%eax
  80120f:	48 85 c0             	test   %rax,%rax
  801212:	75 1e                	jne    801232 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801214:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801218:	48 c1 e8 02          	shr    $0x2,%rax
  80121c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80121f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801223:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801227:	48 89 c7             	mov    %rax,%rdi
  80122a:	48 89 d6             	mov    %rdx,%rsi
  80122d:	fc                   	cld    
  80122e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801230:	eb 15                	jmp    801247 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80123e:	48 89 c7             	mov    %rax,%rdi
  801241:	48 89 d6             	mov    %rdx,%rsi
  801244:	fc                   	cld    
  801245:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80124b:	c9                   	leaveq 
  80124c:	c3                   	retq   

000000000080124d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80124d:	55                   	push   %rbp
  80124e:	48 89 e5             	mov    %rsp,%rbp
  801251:	48 83 ec 18          	sub    $0x18,%rsp
  801255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801259:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80125d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801261:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801265:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126d:	48 89 ce             	mov    %rcx,%rsi
  801270:	48 89 c7             	mov    %rax,%rdi
  801273:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  80127a:	00 00 00 
  80127d:	ff d0                	callq  *%rax
}
  80127f:	c9                   	leaveq 
  801280:	c3                   	retq   

0000000000801281 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801281:	55                   	push   %rbp
  801282:	48 89 e5             	mov    %rsp,%rbp
  801285:	48 83 ec 28          	sub    $0x28,%rsp
  801289:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80128d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801291:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801299:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80129d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012a5:	eb 36                	jmp    8012dd <memcmp+0x5c>
		if (*s1 != *s2)
  8012a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ab:	0f b6 10             	movzbl (%rax),%edx
  8012ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	38 c2                	cmp    %al,%dl
  8012b7:	74 1a                	je     8012d3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	0f b6 00             	movzbl (%rax),%eax
  8012c0:	0f b6 d0             	movzbl %al,%edx
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	0f b6 c0             	movzbl %al,%eax
  8012cd:	29 c2                	sub    %eax,%edx
  8012cf:	89 d0                	mov    %edx,%eax
  8012d1:	eb 20                	jmp    8012f3 <memcmp+0x72>
		s1++, s2++;
  8012d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012e9:	48 85 c0             	test   %rax,%rax
  8012ec:	75 b9                	jne    8012a7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f3:	c9                   	leaveq 
  8012f4:	c3                   	retq   

00000000008012f5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012f5:	55                   	push   %rbp
  8012f6:	48 89 e5             	mov    %rsp,%rbp
  8012f9:	48 83 ec 28          	sub    $0x28,%rsp
  8012fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801301:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801304:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801308:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801310:	48 01 d0             	add    %rdx,%rax
  801313:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801317:	eb 15                	jmp    80132e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131d:	0f b6 10             	movzbl (%rax),%edx
  801320:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801323:	38 c2                	cmp    %al,%dl
  801325:	75 02                	jne    801329 <memfind+0x34>
			break;
  801327:	eb 0f                	jmp    801338 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801329:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801336:	72 e1                	jb     801319 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80133c:	c9                   	leaveq 
  80133d:	c3                   	retq   

000000000080133e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 34          	sub    $0x34,%rsp
  801346:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80134a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80134e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801351:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801358:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80135f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801360:	eb 05                	jmp    801367 <strtol+0x29>
		s++;
  801362:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801367:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	3c 20                	cmp    $0x20,%al
  801370:	74 f0                	je     801362 <strtol+0x24>
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	3c 09                	cmp    $0x9,%al
  80137b:	74 e5                	je     801362 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80137d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	3c 2b                	cmp    $0x2b,%al
  801386:	75 07                	jne    80138f <strtol+0x51>
		s++;
  801388:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80138d:	eb 17                	jmp    8013a6 <strtol+0x68>
	else if (*s == '-')
  80138f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	3c 2d                	cmp    $0x2d,%al
  801398:	75 0c                	jne    8013a6 <strtol+0x68>
		s++, neg = 1;
  80139a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80139f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013aa:	74 06                	je     8013b2 <strtol+0x74>
  8013ac:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013b0:	75 28                	jne    8013da <strtol+0x9c>
  8013b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	3c 30                	cmp    $0x30,%al
  8013bb:	75 1d                	jne    8013da <strtol+0x9c>
  8013bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c1:	48 83 c0 01          	add    $0x1,%rax
  8013c5:	0f b6 00             	movzbl (%rax),%eax
  8013c8:	3c 78                	cmp    $0x78,%al
  8013ca:	75 0e                	jne    8013da <strtol+0x9c>
		s += 2, base = 16;
  8013cc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013d1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013d8:	eb 2c                	jmp    801406 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013da:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013de:	75 19                	jne    8013f9 <strtol+0xbb>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	3c 30                	cmp    $0x30,%al
  8013e9:	75 0e                	jne    8013f9 <strtol+0xbb>
		s++, base = 8;
  8013eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013f7:	eb 0d                	jmp    801406 <strtol+0xc8>
	else if (base == 0)
  8013f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013fd:	75 07                	jne    801406 <strtol+0xc8>
		base = 10;
  8013ff:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3c 2f                	cmp    $0x2f,%al
  80140f:	7e 1d                	jle    80142e <strtol+0xf0>
  801411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801415:	0f b6 00             	movzbl (%rax),%eax
  801418:	3c 39                	cmp    $0x39,%al
  80141a:	7f 12                	jg     80142e <strtol+0xf0>
			dig = *s - '0';
  80141c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	0f be c0             	movsbl %al,%eax
  801426:	83 e8 30             	sub    $0x30,%eax
  801429:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80142c:	eb 4e                	jmp    80147c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80142e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	3c 60                	cmp    $0x60,%al
  801437:	7e 1d                	jle    801456 <strtol+0x118>
  801439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143d:	0f b6 00             	movzbl (%rax),%eax
  801440:	3c 7a                	cmp    $0x7a,%al
  801442:	7f 12                	jg     801456 <strtol+0x118>
			dig = *s - 'a' + 10;
  801444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	0f be c0             	movsbl %al,%eax
  80144e:	83 e8 57             	sub    $0x57,%eax
  801451:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801454:	eb 26                	jmp    80147c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145a:	0f b6 00             	movzbl (%rax),%eax
  80145d:	3c 40                	cmp    $0x40,%al
  80145f:	7e 48                	jle    8014a9 <strtol+0x16b>
  801461:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801465:	0f b6 00             	movzbl (%rax),%eax
  801468:	3c 5a                	cmp    $0x5a,%al
  80146a:	7f 3d                	jg     8014a9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	0f b6 00             	movzbl (%rax),%eax
  801473:	0f be c0             	movsbl %al,%eax
  801476:	83 e8 37             	sub    $0x37,%eax
  801479:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80147c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80147f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801482:	7c 02                	jl     801486 <strtol+0x148>
			break;
  801484:	eb 23                	jmp    8014a9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801486:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80148b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80148e:	48 98                	cltq   
  801490:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801495:	48 89 c2             	mov    %rax,%rdx
  801498:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80149b:	48 98                	cltq   
  80149d:	48 01 d0             	add    %rdx,%rax
  8014a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014a4:	e9 5d ff ff ff       	jmpq   801406 <strtol+0xc8>

	if (endptr)
  8014a9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014ae:	74 0b                	je     8014bb <strtol+0x17d>
		*endptr = (char *) s;
  8014b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014b4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014b8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014bf:	74 09                	je     8014ca <strtol+0x18c>
  8014c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c5:	48 f7 d8             	neg    %rax
  8014c8:	eb 04                	jmp    8014ce <strtol+0x190>
  8014ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014ce:	c9                   	leaveq 
  8014cf:	c3                   	retq   

00000000008014d0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014d0:	55                   	push   %rbp
  8014d1:	48 89 e5             	mov    %rsp,%rbp
  8014d4:	48 83 ec 30          	sub    $0x30,%rsp
  8014d8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014dc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014f2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014f6:	75 06                	jne    8014fe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	eb 6b                	jmp    801569 <strstr+0x99>

	len = strlen(str);
  8014fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801502:	48 89 c7             	mov    %rax,%rdi
  801505:	48 b8 a6 0d 80 00 00 	movabs $0x800da6,%rax
  80150c:	00 00 00 
  80150f:	ff d0                	callq  *%rax
  801511:	48 98                	cltq   
  801513:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80151f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801529:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80152d:	75 07                	jne    801536 <strstr+0x66>
				return (char *) 0;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
  801534:	eb 33                	jmp    801569 <strstr+0x99>
		} while (sc != c);
  801536:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80153a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80153d:	75 d8                	jne    801517 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80153f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801543:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 89 ce             	mov    %rcx,%rsi
  80154e:	48 89 c7             	mov    %rax,%rdi
  801551:	48 b8 c7 0f 80 00 00 	movabs $0x800fc7,%rax
  801558:	00 00 00 
  80155b:	ff d0                	callq  *%rax
  80155d:	85 c0                	test   %eax,%eax
  80155f:	75 b6                	jne    801517 <strstr+0x47>

	return (char *) (in - 1);
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	48 83 e8 01          	sub    $0x1,%rax
}
  801569:	c9                   	leaveq 
  80156a:	c3                   	retq   

000000000080156b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80156b:	55                   	push   %rbp
  80156c:	48 89 e5             	mov    %rsp,%rbp
  80156f:	53                   	push   %rbx
  801570:	48 83 ec 48          	sub    $0x48,%rsp
  801574:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801577:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80157a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80157e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801582:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801586:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80158d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801591:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801595:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801599:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80159d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015a1:	4c 89 c3             	mov    %r8,%rbx
  8015a4:	cd 30                	int    $0x30
  8015a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015ae:	74 3e                	je     8015ee <syscall+0x83>
  8015b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b5:	7e 37                	jle    8015ee <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015be:	49 89 d0             	mov    %rdx,%r8
  8015c1:	89 c1                	mov    %eax,%ecx
  8015c3:	48 ba e8 1e 80 00 00 	movabs $0x801ee8,%rdx
  8015ca:	00 00 00 
  8015cd:	be 23 00 00 00       	mov    $0x23,%esi
  8015d2:	48 bf 05 1f 80 00 00 	movabs $0x801f05,%rdi
  8015d9:	00 00 00 
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e1:	49 b9 64 19 80 00 00 	movabs $0x801964,%r9
  8015e8:	00 00 00 
  8015eb:	41 ff d1             	callq  *%r9

	return ret;
  8015ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f2:	48 83 c4 48          	add    $0x48,%rsp
  8015f6:	5b                   	pop    %rbx
  8015f7:	5d                   	pop    %rbp
  8015f8:	c3                   	retq   

00000000008015f9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015f9:	55                   	push   %rbp
  8015fa:	48 89 e5             	mov    %rsp,%rbp
  8015fd:	48 83 ec 20          	sub    $0x20,%rsp
  801601:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801605:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801611:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801618:	00 
  801619:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80161f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801625:	48 89 d1             	mov    %rdx,%rcx
  801628:	48 89 c2             	mov    %rax,%rdx
  80162b:	be 00 00 00 00       	mov    $0x0,%esi
  801630:	bf 00 00 00 00       	mov    $0x0,%edi
  801635:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80163c:	00 00 00 
  80163f:	ff d0                	callq  *%rax
}
  801641:	c9                   	leaveq 
  801642:	c3                   	retq   

0000000000801643 <sys_cgetc>:

int
sys_cgetc(void)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80164b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801652:	00 
  801653:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801659:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80165f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	be 00 00 00 00       	mov    $0x0,%esi
  80166e:	bf 01 00 00 00       	mov    $0x1,%edi
  801673:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80167a:	00 00 00 
  80167d:	ff d0                	callq  *%rax
}
  80167f:	c9                   	leaveq 
  801680:	c3                   	retq   

0000000000801681 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801681:	55                   	push   %rbp
  801682:	48 89 e5             	mov    %rsp,%rbp
  801685:	48 83 ec 10          	sub    $0x10,%rsp
  801689:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80168c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80168f:	48 98                	cltq   
  801691:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801698:	00 
  801699:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80169f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016aa:	48 89 c2             	mov    %rax,%rdx
  8016ad:	be 01 00 00 00       	mov    $0x1,%esi
  8016b2:	bf 03 00 00 00       	mov    $0x3,%edi
  8016b7:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	callq  *%rax
}
  8016c3:	c9                   	leaveq 
  8016c4:	c3                   	retq   

00000000008016c5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
  8016c9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d4:	00 
  8016d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	be 00 00 00 00       	mov    $0x0,%esi
  8016f0:	bf 02 00 00 00       	mov    $0x2,%edi
  8016f5:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8016fc:	00 00 00 
  8016ff:	ff d0                	callq  *%rax
}
  801701:	c9                   	leaveq 
  801702:	c3                   	retq   

0000000000801703 <sys_yield>:

void
sys_yield(void)
{
  801703:	55                   	push   %rbp
  801704:	48 89 e5             	mov    %rsp,%rbp
  801707:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80170b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801712:	00 
  801713:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801719:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	be 00 00 00 00       	mov    $0x0,%esi
  80172e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801733:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80173a:	00 00 00 
  80173d:	ff d0                	callq  *%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 20          	sub    $0x20,%rsp
  801749:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80174c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801750:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801753:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801756:	48 63 c8             	movslq %eax,%rcx
  801759:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80175d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801760:	48 98                	cltq   
  801762:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801769:	00 
  80176a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801770:	49 89 c8             	mov    %rcx,%r8
  801773:	48 89 d1             	mov    %rdx,%rcx
  801776:	48 89 c2             	mov    %rax,%rdx
  801779:	be 01 00 00 00       	mov    $0x1,%esi
  80177e:	bf 04 00 00 00       	mov    $0x4,%edi
  801783:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80178a:	00 00 00 
  80178d:	ff d0                	callq  *%rax
}
  80178f:	c9                   	leaveq 
  801790:	c3                   	retq   

0000000000801791 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801791:	55                   	push   %rbp
  801792:	48 89 e5             	mov    %rsp,%rbp
  801795:	48 83 ec 30          	sub    $0x30,%rsp
  801799:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80179c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017a3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017a7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017ae:	48 63 c8             	movslq %eax,%rcx
  8017b1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017b8:	48 63 f0             	movslq %eax,%rsi
  8017bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c2:	48 98                	cltq   
  8017c4:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017c8:	49 89 f9             	mov    %rdi,%r9
  8017cb:	49 89 f0             	mov    %rsi,%r8
  8017ce:	48 89 d1             	mov    %rdx,%rcx
  8017d1:	48 89 c2             	mov    %rax,%rdx
  8017d4:	be 01 00 00 00       	mov    $0x1,%esi
  8017d9:	bf 05 00 00 00       	mov    $0x5,%edi
  8017de:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	callq  *%rax
}
  8017ea:	c9                   	leaveq 
  8017eb:	c3                   	retq   

00000000008017ec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017ec:	55                   	push   %rbp
  8017ed:	48 89 e5             	mov    %rsp,%rbp
  8017f0:	48 83 ec 20          	sub    $0x20,%rsp
  8017f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801802:	48 98                	cltq   
  801804:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80180b:	00 
  80180c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801812:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801818:	48 89 d1             	mov    %rdx,%rcx
  80181b:	48 89 c2             	mov    %rax,%rdx
  80181e:	be 01 00 00 00       	mov    $0x1,%esi
  801823:	bf 06 00 00 00       	mov    $0x6,%edi
  801828:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	48 83 ec 10          	sub    $0x10,%rsp
  80183e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801841:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801844:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801847:	48 63 d0             	movslq %eax,%rdx
  80184a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184d:	48 98                	cltq   
  80184f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801856:	00 
  801857:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801863:	48 89 d1             	mov    %rdx,%rcx
  801866:	48 89 c2             	mov    %rax,%rdx
  801869:	be 01 00 00 00       	mov    $0x1,%esi
  80186e:	bf 08 00 00 00       	mov    $0x8,%edi
  801873:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80187a:	00 00 00 
  80187d:	ff d0                	callq  *%rax
}
  80187f:	c9                   	leaveq 
  801880:	c3                   	retq   

0000000000801881 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801881:	55                   	push   %rbp
  801882:	48 89 e5             	mov    %rsp,%rbp
  801885:	48 83 ec 20          	sub    $0x20,%rsp
  801889:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801890:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801894:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801897:	48 98                	cltq   
  801899:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a0:	00 
  8018a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ad:	48 89 d1             	mov    %rdx,%rcx
  8018b0:	48 89 c2             	mov    %rax,%rdx
  8018b3:	be 01 00 00 00       	mov    $0x1,%esi
  8018b8:	bf 09 00 00 00       	mov    $0x9,%edi
  8018bd:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8018c4:	00 00 00 
  8018c7:	ff d0                	callq  *%rax
}
  8018c9:	c9                   	leaveq 
  8018ca:	c3                   	retq   

00000000008018cb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	48 83 ec 20          	sub    $0x20,%rsp
  8018d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018de:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e4:	48 63 f0             	movslq %eax,%rsi
  8018e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ee:	48 98                	cltq   
  8018f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fb:	00 
  8018fc:	49 89 f1             	mov    %rsi,%r9
  8018ff:	49 89 c8             	mov    %rcx,%r8
  801902:	48 89 d1             	mov    %rdx,%rcx
  801905:	48 89 c2             	mov    %rax,%rdx
  801908:	be 00 00 00 00       	mov    $0x0,%esi
  80190d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801912:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  801919:	00 00 00 
  80191c:	ff d0                	callq  *%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	48 83 ec 10          	sub    $0x10,%rsp
  801928:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80192c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801930:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801937:	00 
  801938:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801944:	b9 00 00 00 00       	mov    $0x0,%ecx
  801949:	48 89 c2             	mov    %rax,%rdx
  80194c:	be 01 00 00 00       	mov    $0x1,%esi
  801951:	bf 0c 00 00 00       	mov    $0xc,%edi
  801956:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	53                   	push   %rbx
  801969:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801970:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801977:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80197d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801984:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80198b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801992:	84 c0                	test   %al,%al
  801994:	74 23                	je     8019b9 <_panic+0x55>
  801996:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80199d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8019a1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019a5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019a9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019ad:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019b1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019b5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8019b9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019c0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019c7:	00 00 00 
  8019ca:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019d1:	00 00 00 
  8019d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019d8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019df:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019e6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019ed:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8019f4:	00 00 00 
  8019f7:	48 8b 18             	mov    (%rax),%rbx
  8019fa:	48 b8 c5 16 80 00 00 	movabs $0x8016c5,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	callq  *%rax
  801a06:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801a0c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801a13:	41 89 c8             	mov    %ecx,%r8d
  801a16:	48 89 d1             	mov    %rdx,%rcx
  801a19:	48 89 da             	mov    %rbx,%rdx
  801a1c:	89 c6                	mov    %eax,%esi
  801a1e:	48 bf 18 1f 80 00 00 	movabs $0x801f18,%rdi
  801a25:	00 00 00 
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2d:	49 b9 4a 02 80 00 00 	movabs $0x80024a,%r9
  801a34:	00 00 00 
  801a37:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a3a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a41:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a48:	48 89 d6             	mov    %rdx,%rsi
  801a4b:	48 89 c7             	mov    %rax,%rdi
  801a4e:	48 b8 9e 01 80 00 00 	movabs $0x80019e,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	callq  *%rax
	cprintf("\n");
  801a5a:	48 bf 3b 1f 80 00 00 	movabs $0x801f3b,%rdi
  801a61:	00 00 00 
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	48 ba 4a 02 80 00 00 	movabs $0x80024a,%rdx
  801a70:	00 00 00 
  801a73:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a75:	cc                   	int3   
  801a76:	eb fd                	jmp    801a75 <_panic+0x111>
