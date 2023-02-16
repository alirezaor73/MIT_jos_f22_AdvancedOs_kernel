
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
  80005b:	48 bf 00 36 80 00 00 	movabs $0x803600,%rdi
  800062:	00 00 00 
  800065:	b8 00 00 00 00       	mov    $0x0,%eax
  80006a:	48 ba 51 02 80 00 00 	movabs $0x800251,%rdx
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
  80007c:	48 83 ec 20          	sub    $0x20,%rsp
  800080:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800083:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800087:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009e:	48 63 d0             	movslq %eax,%rdx
  8000a1:	48 89 d0             	mov    %rdx,%rax
  8000a4:	48 c1 e0 03          	shl    $0x3,%rax
  8000a8:	48 01 d0             	add    %rdx,%rax
  8000ab:	48 c1 e0 05          	shl    $0x5,%rax
  8000af:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b6:	00 00 00 
  8000b9:	48 01 c2             	add    %rax,%rdx
  8000bc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c3:	00 00 00 
  8000c6:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cd:	7e 14                	jle    8000e3 <libmain+0x6b>
		binaryname = argv[0];
  8000cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d3:	48 8b 10             	mov    (%rax),%rdx
  8000d6:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000dd:	00 00 00 
  8000e0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000ea:	48 89 d6             	mov    %rdx,%rsi
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000fb:	48 b8 09 01 80 00 00 	movabs $0x800109,%rax
  800102:	00 00 00 
  800105:	ff d0                	callq  *%rax
}
  800107:	c9                   	leaveq 
  800108:	c3                   	retq   

0000000000800109 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800109:	55                   	push   %rbp
  80010a:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80010d:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800119:	bf 00 00 00 00       	mov    $0x0,%edi
  80011e:	48 b8 88 16 80 00 00 	movabs $0x801688,%rax
  800125:	00 00 00 
  800128:	ff d0                	callq  *%rax
}
  80012a:	5d                   	pop    %rbp
  80012b:	c3                   	retq   

000000000080012c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80012c:	55                   	push   %rbp
  80012d:	48 89 e5             	mov    %rsp,%rbp
  800130:	48 83 ec 10          	sub    $0x10,%rsp
  800134:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800137:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80013b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013f:	8b 00                	mov    (%rax),%eax
  800141:	8d 48 01             	lea    0x1(%rax),%ecx
  800144:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800148:	89 0a                	mov    %ecx,(%rdx)
  80014a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80014d:	89 d1                	mov    %edx,%ecx
  80014f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800153:	48 98                	cltq   
  800155:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800159:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015d:	8b 00                	mov    (%rax),%eax
  80015f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800164:	75 2c                	jne    800192 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80016a:	8b 00                	mov    (%rax),%eax
  80016c:	48 98                	cltq   
  80016e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800172:	48 83 c2 08          	add    $0x8,%rdx
  800176:	48 89 c6             	mov    %rax,%rsi
  800179:	48 89 d7             	mov    %rdx,%rdi
  80017c:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax
        b->idx = 0;
  800188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800196:	8b 40 04             	mov    0x4(%rax),%eax
  800199:	8d 50 01             	lea    0x1(%rax),%edx
  80019c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001a3:	c9                   	leaveq 
  8001a4:	c3                   	retq   

00000000008001a5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001a5:	55                   	push   %rbp
  8001a6:	48 89 e5             	mov    %rsp,%rbp
  8001a9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001b0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001b7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001be:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001c5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001cc:	48 8b 0a             	mov    (%rdx),%rcx
  8001cf:	48 89 08             	mov    %rcx,(%rax)
  8001d2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001d6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001da:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001de:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001e9:	00 00 00 
    b.cnt = 0;
  8001ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001f3:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001f6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001fd:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800204:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80020b:	48 89 c6             	mov    %rax,%rsi
  80020e:	48 bf 2c 01 80 00 00 	movabs $0x80012c,%rdi
  800215:	00 00 00 
  800218:	48 b8 04 06 80 00 00 	movabs $0x800604,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800224:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80022a:	48 98                	cltq   
  80022c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800233:	48 83 c2 08          	add    $0x8,%rdx
  800237:	48 89 c6             	mov    %rax,%rsi
  80023a:	48 89 d7             	mov    %rdx,%rdi
  80023d:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  800244:	00 00 00 
  800247:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800249:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80024f:	c9                   	leaveq 
  800250:	c3                   	retq   

0000000000800251 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800251:	55                   	push   %rbp
  800252:	48 89 e5             	mov    %rsp,%rbp
  800255:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80025c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800263:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80026a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800271:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800278:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80027f:	84 c0                	test   %al,%al
  800281:	74 20                	je     8002a3 <cprintf+0x52>
  800283:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800287:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80028b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80028f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800293:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800297:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80029b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80029f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002a3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002aa:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002b1:	00 00 00 
  8002b4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002bb:	00 00 00 
  8002be:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002c9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002d0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002d7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002de:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002e5:	48 8b 0a             	mov    (%rdx),%rcx
  8002e8:	48 89 08             	mov    %rcx,(%rax)
  8002eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002fb:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800302:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800309:	48 89 d6             	mov    %rdx,%rsi
  80030c:	48 89 c7             	mov    %rax,%rdi
  80030f:	48 b8 a5 01 80 00 00 	movabs $0x8001a5,%rax
  800316:	00 00 00 
  800319:	ff d0                	callq  *%rax
  80031b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800321:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800327:	c9                   	leaveq 
  800328:	c3                   	retq   

0000000000800329 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800329:	55                   	push   %rbp
  80032a:	48 89 e5             	mov    %rsp,%rbp
  80032d:	53                   	push   %rbx
  80032e:	48 83 ec 38          	sub    $0x38,%rsp
  800332:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800336:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80033a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80033e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800341:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800345:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800349:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80034c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800350:	77 3b                	ja     80038d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800352:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800355:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800359:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80035c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800360:	ba 00 00 00 00       	mov    $0x0,%edx
  800365:	48 f7 f3             	div    %rbx
  800368:	48 89 c2             	mov    %rax,%rdx
  80036b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80036e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800371:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800379:	41 89 f9             	mov    %edi,%r9d
  80037c:	48 89 c7             	mov    %rax,%rdi
  80037f:	48 b8 29 03 80 00 00 	movabs $0x800329,%rax
  800386:	00 00 00 
  800389:	ff d0                	callq  *%rax
  80038b:	eb 1e                	jmp    8003ab <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038d:	eb 12                	jmp    8003a1 <printnum+0x78>
			putch(padc, putdat);
  80038f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800393:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039a:	48 89 ce             	mov    %rcx,%rsi
  80039d:	89 d7                	mov    %edx,%edi
  80039f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003a5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003a9:	7f e4                	jg     80038f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ab:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b7:	48 f7 f1             	div    %rcx
  8003ba:	48 89 d0             	mov    %rdx,%rax
  8003bd:	48 ba 30 38 80 00 00 	movabs $0x803830,%rdx
  8003c4:	00 00 00 
  8003c7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003cb:	0f be d0             	movsbl %al,%edx
  8003ce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	89 d7                	mov    %edx,%edi
  8003db:	ff d0                	callq  *%rax
}
  8003dd:	48 83 c4 38          	add    $0x38,%rsp
  8003e1:	5b                   	pop    %rbx
  8003e2:	5d                   	pop    %rbp
  8003e3:	c3                   	retq   

00000000008003e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e4:	55                   	push   %rbp
  8003e5:	48 89 e5             	mov    %rsp,%rbp
  8003e8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8003f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003f7:	7e 52                	jle    80044b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fd:	8b 00                	mov    (%rax),%eax
  8003ff:	83 f8 30             	cmp    $0x30,%eax
  800402:	73 24                	jae    800428 <getuint+0x44>
  800404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800408:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80040c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800410:	8b 00                	mov    (%rax),%eax
  800412:	89 c0                	mov    %eax,%eax
  800414:	48 01 d0             	add    %rdx,%rax
  800417:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80041b:	8b 12                	mov    (%rdx),%edx
  80041d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800424:	89 0a                	mov    %ecx,(%rdx)
  800426:	eb 17                	jmp    80043f <getuint+0x5b>
  800428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800430:	48 89 d0             	mov    %rdx,%rax
  800433:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800437:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80043f:	48 8b 00             	mov    (%rax),%rax
  800442:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800446:	e9 a3 00 00 00       	jmpq   8004ee <getuint+0x10a>
	else if (lflag)
  80044b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80044f:	74 4f                	je     8004a0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800455:	8b 00                	mov    (%rax),%eax
  800457:	83 f8 30             	cmp    $0x30,%eax
  80045a:	73 24                	jae    800480 <getuint+0x9c>
  80045c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800460:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800468:	8b 00                	mov    (%rax),%eax
  80046a:	89 c0                	mov    %eax,%eax
  80046c:	48 01 d0             	add    %rdx,%rax
  80046f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800473:	8b 12                	mov    (%rdx),%edx
  800475:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800478:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047c:	89 0a                	mov    %ecx,(%rdx)
  80047e:	eb 17                	jmp    800497 <getuint+0xb3>
  800480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800484:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800488:	48 89 d0             	mov    %rdx,%rax
  80048b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80048f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800493:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800497:	48 8b 00             	mov    (%rax),%rax
  80049a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80049e:	eb 4e                	jmp    8004ee <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a4:	8b 00                	mov    (%rax),%eax
  8004a6:	83 f8 30             	cmp    $0x30,%eax
  8004a9:	73 24                	jae    8004cf <getuint+0xeb>
  8004ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b7:	8b 00                	mov    (%rax),%eax
  8004b9:	89 c0                	mov    %eax,%eax
  8004bb:	48 01 d0             	add    %rdx,%rax
  8004be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c2:	8b 12                	mov    (%rdx),%edx
  8004c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cb:	89 0a                	mov    %ecx,(%rdx)
  8004cd:	eb 17                	jmp    8004e6 <getuint+0x102>
  8004cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d7:	48 89 d0             	mov    %rdx,%rax
  8004da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004e6:	8b 00                	mov    (%rax),%eax
  8004e8:	89 c0                	mov    %eax,%eax
  8004ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004f2:	c9                   	leaveq 
  8004f3:	c3                   	retq   

00000000008004f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f4:	55                   	push   %rbp
  8004f5:	48 89 e5             	mov    %rsp,%rbp
  8004f8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800500:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800503:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800507:	7e 52                	jle    80055b <getint+0x67>
		x=va_arg(*ap, long long);
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	8b 00                	mov    (%rax),%eax
  80050f:	83 f8 30             	cmp    $0x30,%eax
  800512:	73 24                	jae    800538 <getint+0x44>
  800514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800518:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80051c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800520:	8b 00                	mov    (%rax),%eax
  800522:	89 c0                	mov    %eax,%eax
  800524:	48 01 d0             	add    %rdx,%rax
  800527:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052b:	8b 12                	mov    (%rdx),%edx
  80052d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800530:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800534:	89 0a                	mov    %ecx,(%rdx)
  800536:	eb 17                	jmp    80054f <getint+0x5b>
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800540:	48 89 d0             	mov    %rdx,%rax
  800543:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800547:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80054f:	48 8b 00             	mov    (%rax),%rax
  800552:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800556:	e9 a3 00 00 00       	jmpq   8005fe <getint+0x10a>
	else if (lflag)
  80055b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80055f:	74 4f                	je     8005b0 <getint+0xbc>
		x=va_arg(*ap, long);
  800561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800565:	8b 00                	mov    (%rax),%eax
  800567:	83 f8 30             	cmp    $0x30,%eax
  80056a:	73 24                	jae    800590 <getint+0x9c>
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800578:	8b 00                	mov    (%rax),%eax
  80057a:	89 c0                	mov    %eax,%eax
  80057c:	48 01 d0             	add    %rdx,%rax
  80057f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800583:	8b 12                	mov    (%rdx),%edx
  800585:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800588:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058c:	89 0a                	mov    %ecx,(%rdx)
  80058e:	eb 17                	jmp    8005a7 <getint+0xb3>
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800598:	48 89 d0             	mov    %rdx,%rax
  80059b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80059f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a7:	48 8b 00             	mov    (%rax),%rax
  8005aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005ae:	eb 4e                	jmp    8005fe <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b4:	8b 00                	mov    (%rax),%eax
  8005b6:	83 f8 30             	cmp    $0x30,%eax
  8005b9:	73 24                	jae    8005df <getint+0xeb>
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c7:	8b 00                	mov    (%rax),%eax
  8005c9:	89 c0                	mov    %eax,%eax
  8005cb:	48 01 d0             	add    %rdx,%rax
  8005ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d2:	8b 12                	mov    (%rdx),%edx
  8005d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005db:	89 0a                	mov    %ecx,(%rdx)
  8005dd:	eb 17                	jmp    8005f6 <getint+0x102>
  8005df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e7:	48 89 d0             	mov    %rdx,%rax
  8005ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f6:	8b 00                	mov    (%rax),%eax
  8005f8:	48 98                	cltq   
  8005fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800602:	c9                   	leaveq 
  800603:	c3                   	retq   

0000000000800604 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800604:	55                   	push   %rbp
  800605:	48 89 e5             	mov    %rsp,%rbp
  800608:	41 54                	push   %r12
  80060a:	53                   	push   %rbx
  80060b:	48 83 ec 60          	sub    $0x60,%rsp
  80060f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800613:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800617:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80061b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80061f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800623:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800627:	48 8b 0a             	mov    (%rdx),%rcx
  80062a:	48 89 08             	mov    %rcx,(%rax)
  80062d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800631:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800635:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800639:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063d:	eb 17                	jmp    800656 <vprintfmt+0x52>
			if (ch == '\0')
  80063f:	85 db                	test   %ebx,%ebx
  800641:	0f 84 df 04 00 00    	je     800b26 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800647:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80064b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80064f:	48 89 d6             	mov    %rdx,%rsi
  800652:	89 df                	mov    %ebx,%edi
  800654:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80065a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80065e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800662:	0f b6 00             	movzbl (%rax),%eax
  800665:	0f b6 d8             	movzbl %al,%ebx
  800668:	83 fb 25             	cmp    $0x25,%ebx
  80066b:	75 d2                	jne    80063f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800671:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800678:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80067f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800686:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800691:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800695:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800699:	0f b6 00             	movzbl (%rax),%eax
  80069c:	0f b6 d8             	movzbl %al,%ebx
  80069f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006a2:	83 f8 55             	cmp    $0x55,%eax
  8006a5:	0f 87 47 04 00 00    	ja     800af2 <vprintfmt+0x4ee>
  8006ab:	89 c0                	mov    %eax,%eax
  8006ad:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006b4:	00 
  8006b5:	48 b8 58 38 80 00 00 	movabs $0x803858,%rax
  8006bc:	00 00 00 
  8006bf:	48 01 d0             	add    %rdx,%rax
  8006c2:	48 8b 00             	mov    (%rax),%rax
  8006c5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006c7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006cb:	eb c0                	jmp    80068d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006cd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006d1:	eb ba                	jmp    80068d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006da:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	c1 e0 02             	shl    $0x2,%eax
  8006e2:	01 d0                	add    %edx,%eax
  8006e4:	01 c0                	add    %eax,%eax
  8006e6:	01 d8                	add    %ebx,%eax
  8006e8:	83 e8 30             	sub    $0x30,%eax
  8006eb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006ee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f2:	0f b6 00             	movzbl (%rax),%eax
  8006f5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006f8:	83 fb 2f             	cmp    $0x2f,%ebx
  8006fb:	7e 0c                	jle    800709 <vprintfmt+0x105>
  8006fd:	83 fb 39             	cmp    $0x39,%ebx
  800700:	7f 07                	jg     800709 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800702:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800707:	eb d1                	jmp    8006da <vprintfmt+0xd6>
			goto process_precision;
  800709:	eb 58                	jmp    800763 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80070b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070e:	83 f8 30             	cmp    $0x30,%eax
  800711:	73 17                	jae    80072a <vprintfmt+0x126>
  800713:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800717:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80071a:	89 c0                	mov    %eax,%eax
  80071c:	48 01 d0             	add    %rdx,%rax
  80071f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800722:	83 c2 08             	add    $0x8,%edx
  800725:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800728:	eb 0f                	jmp    800739 <vprintfmt+0x135>
  80072a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80072e:	48 89 d0             	mov    %rdx,%rax
  800731:	48 83 c2 08          	add    $0x8,%rdx
  800735:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800739:	8b 00                	mov    (%rax),%eax
  80073b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80073e:	eb 23                	jmp    800763 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800740:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800744:	79 0c                	jns    800752 <vprintfmt+0x14e>
				width = 0;
  800746:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80074d:	e9 3b ff ff ff       	jmpq   80068d <vprintfmt+0x89>
  800752:	e9 36 ff ff ff       	jmpq   80068d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800757:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80075e:	e9 2a ff ff ff       	jmpq   80068d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800763:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800767:	79 12                	jns    80077b <vprintfmt+0x177>
				width = precision, precision = -1;
  800769:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80076c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80076f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800776:	e9 12 ff ff ff       	jmpq   80068d <vprintfmt+0x89>
  80077b:	e9 0d ff ff ff       	jmpq   80068d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800780:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800784:	e9 04 ff ff ff       	jmpq   80068d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800789:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078c:	83 f8 30             	cmp    $0x30,%eax
  80078f:	73 17                	jae    8007a8 <vprintfmt+0x1a4>
  800791:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800795:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800798:	89 c0                	mov    %eax,%eax
  80079a:	48 01 d0             	add    %rdx,%rax
  80079d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a0:	83 c2 08             	add    $0x8,%edx
  8007a3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007a6:	eb 0f                	jmp    8007b7 <vprintfmt+0x1b3>
  8007a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ac:	48 89 d0             	mov    %rdx,%rax
  8007af:	48 83 c2 08          	add    $0x8,%rdx
  8007b3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007b7:	8b 10                	mov    (%rax),%edx
  8007b9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c1:	48 89 ce             	mov    %rcx,%rsi
  8007c4:	89 d7                	mov    %edx,%edi
  8007c6:	ff d0                	callq  *%rax
			break;
  8007c8:	e9 53 03 00 00       	jmpq   800b20 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d0:	83 f8 30             	cmp    $0x30,%eax
  8007d3:	73 17                	jae    8007ec <vprintfmt+0x1e8>
  8007d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dc:	89 c0                	mov    %eax,%eax
  8007de:	48 01 d0             	add    %rdx,%rax
  8007e1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007e4:	83 c2 08             	add    $0x8,%edx
  8007e7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ea:	eb 0f                	jmp    8007fb <vprintfmt+0x1f7>
  8007ec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f0:	48 89 d0             	mov    %rdx,%rax
  8007f3:	48 83 c2 08          	add    $0x8,%rdx
  8007f7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007fb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007fd:	85 db                	test   %ebx,%ebx
  8007ff:	79 02                	jns    800803 <vprintfmt+0x1ff>
				err = -err;
  800801:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800803:	83 fb 15             	cmp    $0x15,%ebx
  800806:	7f 16                	jg     80081e <vprintfmt+0x21a>
  800808:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  80080f:	00 00 00 
  800812:	48 63 d3             	movslq %ebx,%rdx
  800815:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800819:	4d 85 e4             	test   %r12,%r12
  80081c:	75 2e                	jne    80084c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80081e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800822:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800826:	89 d9                	mov    %ebx,%ecx
  800828:	48 ba 41 38 80 00 00 	movabs $0x803841,%rdx
  80082f:	00 00 00 
  800832:	48 89 c7             	mov    %rax,%rdi
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
  80083a:	49 b8 2f 0b 80 00 00 	movabs $0x800b2f,%r8
  800841:	00 00 00 
  800844:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800847:	e9 d4 02 00 00       	jmpq   800b20 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80084c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800850:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800854:	4c 89 e1             	mov    %r12,%rcx
  800857:	48 ba 4a 38 80 00 00 	movabs $0x80384a,%rdx
  80085e:	00 00 00 
  800861:	48 89 c7             	mov    %rax,%rdi
  800864:	b8 00 00 00 00       	mov    $0x0,%eax
  800869:	49 b8 2f 0b 80 00 00 	movabs $0x800b2f,%r8
  800870:	00 00 00 
  800873:	41 ff d0             	callq  *%r8
			break;
  800876:	e9 a5 02 00 00       	jmpq   800b20 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80087b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087e:	83 f8 30             	cmp    $0x30,%eax
  800881:	73 17                	jae    80089a <vprintfmt+0x296>
  800883:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800887:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088a:	89 c0                	mov    %eax,%eax
  80088c:	48 01 d0             	add    %rdx,%rax
  80088f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800892:	83 c2 08             	add    $0x8,%edx
  800895:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800898:	eb 0f                	jmp    8008a9 <vprintfmt+0x2a5>
  80089a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80089e:	48 89 d0             	mov    %rdx,%rax
  8008a1:	48 83 c2 08          	add    $0x8,%rdx
  8008a5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a9:	4c 8b 20             	mov    (%rax),%r12
  8008ac:	4d 85 e4             	test   %r12,%r12
  8008af:	75 0a                	jne    8008bb <vprintfmt+0x2b7>
				p = "(null)";
  8008b1:	49 bc 4d 38 80 00 00 	movabs $0x80384d,%r12
  8008b8:	00 00 00 
			if (width > 0 && padc != '-')
  8008bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008bf:	7e 3f                	jle    800900 <vprintfmt+0x2fc>
  8008c1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008c5:	74 39                	je     800900 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008ca:	48 98                	cltq   
  8008cc:	48 89 c6             	mov    %rax,%rsi
  8008cf:	4c 89 e7             	mov    %r12,%rdi
  8008d2:	48 b8 db 0d 80 00 00 	movabs $0x800ddb,%rax
  8008d9:	00 00 00 
  8008dc:	ff d0                	callq  *%rax
  8008de:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008e1:	eb 17                	jmp    8008fa <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008e3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008e7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ef:	48 89 ce             	mov    %rcx,%rsi
  8008f2:	89 d7                	mov    %edx,%edi
  8008f4:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008fe:	7f e3                	jg     8008e3 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800900:	eb 37                	jmp    800939 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800902:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800906:	74 1e                	je     800926 <vprintfmt+0x322>
  800908:	83 fb 1f             	cmp    $0x1f,%ebx
  80090b:	7e 05                	jle    800912 <vprintfmt+0x30e>
  80090d:	83 fb 7e             	cmp    $0x7e,%ebx
  800910:	7e 14                	jle    800926 <vprintfmt+0x322>
					putch('?', putdat);
  800912:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800916:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091a:	48 89 d6             	mov    %rdx,%rsi
  80091d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800922:	ff d0                	callq  *%rax
  800924:	eb 0f                	jmp    800935 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800926:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092e:	48 89 d6             	mov    %rdx,%rsi
  800931:	89 df                	mov    %ebx,%edi
  800933:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800935:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800939:	4c 89 e0             	mov    %r12,%rax
  80093c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800940:	0f b6 00             	movzbl (%rax),%eax
  800943:	0f be d8             	movsbl %al,%ebx
  800946:	85 db                	test   %ebx,%ebx
  800948:	74 10                	je     80095a <vprintfmt+0x356>
  80094a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80094e:	78 b2                	js     800902 <vprintfmt+0x2fe>
  800950:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800954:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800958:	79 a8                	jns    800902 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095a:	eb 16                	jmp    800972 <vprintfmt+0x36e>
				putch(' ', putdat);
  80095c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800960:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800964:	48 89 d6             	mov    %rdx,%rsi
  800967:	bf 20 00 00 00       	mov    $0x20,%edi
  80096c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800972:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800976:	7f e4                	jg     80095c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800978:	e9 a3 01 00 00       	jmpq   800b20 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80097d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800981:	be 03 00 00 00       	mov    $0x3,%esi
  800986:	48 89 c7             	mov    %rax,%rdi
  800989:	48 b8 f4 04 80 00 00 	movabs $0x8004f4,%rax
  800990:	00 00 00 
  800993:	ff d0                	callq  *%rax
  800995:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	48 85 c0             	test   %rax,%rax
  8009a0:	79 1d                	jns    8009bf <vprintfmt+0x3bb>
				putch('-', putdat);
  8009a2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009aa:	48 89 d6             	mov    %rdx,%rsi
  8009ad:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009b2:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	48 f7 d8             	neg    %rax
  8009bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009bf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009c6:	e9 e8 00 00 00       	jmpq   800ab3 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009cb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009cf:	be 03 00 00 00       	mov    $0x3,%esi
  8009d4:	48 89 c7             	mov    %rax,%rdi
  8009d7:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  8009de:	00 00 00 
  8009e1:	ff d0                	callq  *%rax
  8009e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009e7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009ee:	e9 c0 00 00 00       	jmpq   800ab3 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fb:	48 89 d6             	mov    %rdx,%rsi
  8009fe:	bf 58 00 00 00       	mov    $0x58,%edi
  800a03:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0d:	48 89 d6             	mov    %rdx,%rsi
  800a10:	bf 58 00 00 00       	mov    $0x58,%edi
  800a15:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1f:	48 89 d6             	mov    %rdx,%rsi
  800a22:	bf 58 00 00 00       	mov    $0x58,%edi
  800a27:	ff d0                	callq  *%rax
			break;
  800a29:	e9 f2 00 00 00       	jmpq   800b20 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a36:	48 89 d6             	mov    %rdx,%rsi
  800a39:	bf 30 00 00 00       	mov    $0x30,%edi
  800a3e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a48:	48 89 d6             	mov    %rdx,%rsi
  800a4b:	bf 78 00 00 00       	mov    $0x78,%edi
  800a50:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a55:	83 f8 30             	cmp    $0x30,%eax
  800a58:	73 17                	jae    800a71 <vprintfmt+0x46d>
  800a5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a61:	89 c0                	mov    %eax,%eax
  800a63:	48 01 d0             	add    %rdx,%rax
  800a66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a69:	83 c2 08             	add    $0x8,%edx
  800a6c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a6f:	eb 0f                	jmp    800a80 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a75:	48 89 d0             	mov    %rdx,%rax
  800a78:	48 83 c2 08          	add    $0x8,%rdx
  800a7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a80:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a87:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a8e:	eb 23                	jmp    800ab3 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a94:	be 03 00 00 00       	mov    $0x3,%esi
  800a99:	48 89 c7             	mov    %rax,%rdi
  800a9c:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  800aa3:	00 00 00 
  800aa6:	ff d0                	callq  *%rax
  800aa8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800aac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ab8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800abb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800abe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ac6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aca:	45 89 c1             	mov    %r8d,%r9d
  800acd:	41 89 f8             	mov    %edi,%r8d
  800ad0:	48 89 c7             	mov    %rax,%rdi
  800ad3:	48 b8 29 03 80 00 00 	movabs $0x800329,%rax
  800ada:	00 00 00 
  800add:	ff d0                	callq  *%rax
			break;
  800adf:	eb 3f                	jmp    800b20 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae9:	48 89 d6             	mov    %rdx,%rsi
  800aec:	89 df                	mov    %ebx,%edi
  800aee:	ff d0                	callq  *%rax
			break;
  800af0:	eb 2e                	jmp    800b20 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afa:	48 89 d6             	mov    %rdx,%rsi
  800afd:	bf 25 00 00 00       	mov    $0x25,%edi
  800b02:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b09:	eb 05                	jmp    800b10 <vprintfmt+0x50c>
  800b0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b10:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b14:	48 83 e8 01          	sub    $0x1,%rax
  800b18:	0f b6 00             	movzbl (%rax),%eax
  800b1b:	3c 25                	cmp    $0x25,%al
  800b1d:	75 ec                	jne    800b0b <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b1f:	90                   	nop
		}
	}
  800b20:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b21:	e9 30 fb ff ff       	jmpq   800656 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b26:	48 83 c4 60          	add    $0x60,%rsp
  800b2a:	5b                   	pop    %rbx
  800b2b:	41 5c                	pop    %r12
  800b2d:	5d                   	pop    %rbp
  800b2e:	c3                   	retq   

0000000000800b2f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b2f:	55                   	push   %rbp
  800b30:	48 89 e5             	mov    %rsp,%rbp
  800b33:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b3a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b41:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b48:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b4f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b56:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b5d:	84 c0                	test   %al,%al
  800b5f:	74 20                	je     800b81 <printfmt+0x52>
  800b61:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b65:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b69:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b6d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b71:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b75:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b79:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b7d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b81:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b88:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b8f:	00 00 00 
  800b92:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b99:	00 00 00 
  800b9c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ba0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ba7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bae:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bb5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bbc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bc3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bd1:	48 89 c7             	mov    %rax,%rdi
  800bd4:	48 b8 04 06 80 00 00 	movabs $0x800604,%rax
  800bdb:	00 00 00 
  800bde:	ff d0                	callq  *%rax
	va_end(ap);
}
  800be0:	c9                   	leaveq 
  800be1:	c3                   	retq   

0000000000800be2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be2:	55                   	push   %rbp
  800be3:	48 89 e5             	mov    %rsp,%rbp
  800be6:	48 83 ec 10          	sub    $0x10,%rsp
  800bea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf5:	8b 40 10             	mov    0x10(%rax),%eax
  800bf8:	8d 50 01             	lea    0x1(%rax),%edx
  800bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bff:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c06:	48 8b 10             	mov    (%rax),%rdx
  800c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c11:	48 39 c2             	cmp    %rax,%rdx
  800c14:	73 17                	jae    800c2d <sprintputch+0x4b>
		*b->buf++ = ch;
  800c16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1a:	48 8b 00             	mov    (%rax),%rax
  800c1d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c25:	48 89 0a             	mov    %rcx,(%rdx)
  800c28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c2b:	88 10                	mov    %dl,(%rax)
}
  800c2d:	c9                   	leaveq 
  800c2e:	c3                   	retq   

0000000000800c2f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c2f:	55                   	push   %rbp
  800c30:	48 89 e5             	mov    %rsp,%rbp
  800c33:	48 83 ec 50          	sub    $0x50,%rsp
  800c37:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c3b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c3e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c42:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c46:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c4a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c4e:	48 8b 0a             	mov    (%rdx),%rcx
  800c51:	48 89 08             	mov    %rcx,(%rax)
  800c54:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c58:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c5c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c60:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c68:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c6c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c6f:	48 98                	cltq   
  800c71:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c79:	48 01 d0             	add    %rdx,%rax
  800c7c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c87:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c8c:	74 06                	je     800c94 <vsnprintf+0x65>
  800c8e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c92:	7f 07                	jg     800c9b <vsnprintf+0x6c>
		return -E_INVAL;
  800c94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c99:	eb 2f                	jmp    800cca <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c9b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c9f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ca3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ca7:	48 89 c6             	mov    %rax,%rsi
  800caa:	48 bf e2 0b 80 00 00 	movabs $0x800be2,%rdi
  800cb1:	00 00 00 
  800cb4:	48 b8 04 06 80 00 00 	movabs $0x800604,%rax
  800cbb:	00 00 00 
  800cbe:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cc4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cc7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cca:	c9                   	leaveq 
  800ccb:	c3                   	retq   

0000000000800ccc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ccc:	55                   	push   %rbp
  800ccd:	48 89 e5             	mov    %rsp,%rbp
  800cd0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cd7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cde:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ce4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ceb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cf2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cf9:	84 c0                	test   %al,%al
  800cfb:	74 20                	je     800d1d <snprintf+0x51>
  800cfd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d01:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d05:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d09:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d0d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d11:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d15:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d19:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d1d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d24:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d2b:	00 00 00 
  800d2e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d35:	00 00 00 
  800d38:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d3c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d43:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d4a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d51:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d58:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d5f:	48 8b 0a             	mov    (%rdx),%rcx
  800d62:	48 89 08             	mov    %rcx,(%rax)
  800d65:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d69:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d6d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d71:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d75:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d7c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d83:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d89:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d90:	48 89 c7             	mov    %rax,%rdi
  800d93:	48 b8 2f 0c 80 00 00 	movabs $0x800c2f,%rax
  800d9a:	00 00 00 
  800d9d:	ff d0                	callq  *%rax
  800d9f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800da5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dab:	c9                   	leaveq 
  800dac:	c3                   	retq   

0000000000800dad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dad:	55                   	push   %rbp
  800dae:	48 89 e5             	mov    %rsp,%rbp
  800db1:	48 83 ec 18          	sub    $0x18,%rsp
  800db5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800db9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dc0:	eb 09                	jmp    800dcb <strlen+0x1e>
		n++;
  800dc2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcf:	0f b6 00             	movzbl (%rax),%eax
  800dd2:	84 c0                	test   %al,%al
  800dd4:	75 ec                	jne    800dc2 <strlen+0x15>
		n++;
	return n;
  800dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dd9:	c9                   	leaveq 
  800dda:	c3                   	retq   

0000000000800ddb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ddb:	55                   	push   %rbp
  800ddc:	48 89 e5             	mov    %rsp,%rbp
  800ddf:	48 83 ec 20          	sub    $0x20,%rsp
  800de3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800de7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800deb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800df2:	eb 0e                	jmp    800e02 <strnlen+0x27>
		n++;
  800df4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dfd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e02:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e07:	74 0b                	je     800e14 <strnlen+0x39>
  800e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0d:	0f b6 00             	movzbl (%rax),%eax
  800e10:	84 c0                	test   %al,%al
  800e12:	75 e0                	jne    800df4 <strnlen+0x19>
		n++;
	return n;
  800e14:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e17:	c9                   	leaveq 
  800e18:	c3                   	retq   

0000000000800e19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e19:	55                   	push   %rbp
  800e1a:	48 89 e5             	mov    %rsp,%rbp
  800e1d:	48 83 ec 20          	sub    $0x20,%rsp
  800e21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e31:	90                   	nop
  800e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e36:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e3a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e3e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e42:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e46:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e4a:	0f b6 12             	movzbl (%rdx),%edx
  800e4d:	88 10                	mov    %dl,(%rax)
  800e4f:	0f b6 00             	movzbl (%rax),%eax
  800e52:	84 c0                	test   %al,%al
  800e54:	75 dc                	jne    800e32 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e5a:	c9                   	leaveq 
  800e5b:	c3                   	retq   

0000000000800e5c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e5c:	55                   	push   %rbp
  800e5d:	48 89 e5             	mov    %rsp,%rbp
  800e60:	48 83 ec 20          	sub    $0x20,%rsp
  800e64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e70:	48 89 c7             	mov    %rax,%rdi
  800e73:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  800e7a:	00 00 00 
  800e7d:	ff d0                	callq  *%rax
  800e7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e85:	48 63 d0             	movslq %eax,%rdx
  800e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8c:	48 01 c2             	add    %rax,%rdx
  800e8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e93:	48 89 c6             	mov    %rax,%rsi
  800e96:	48 89 d7             	mov    %rdx,%rdi
  800e99:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  800ea0:	00 00 00 
  800ea3:	ff d0                	callq  *%rax
	return dst;
  800ea5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ea9:	c9                   	leaveq 
  800eaa:	c3                   	retq   

0000000000800eab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eab:	55                   	push   %rbp
  800eac:	48 89 e5             	mov    %rsp,%rbp
  800eaf:	48 83 ec 28          	sub    $0x28,%rsp
  800eb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ebb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ec7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ece:	00 
  800ecf:	eb 2a                	jmp    800efb <strncpy+0x50>
		*dst++ = *src;
  800ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ed9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800edd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ee1:	0f b6 12             	movzbl (%rdx),%edx
  800ee4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eea:	0f b6 00             	movzbl (%rax),%eax
  800eed:	84 c0                	test   %al,%al
  800eef:	74 05                	je     800ef6 <strncpy+0x4b>
			src++;
  800ef1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800eff:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f03:	72 cc                	jb     800ed1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f09:	c9                   	leaveq 
  800f0a:	c3                   	retq   

0000000000800f0b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f0b:	55                   	push   %rbp
  800f0c:	48 89 e5             	mov    %rsp,%rbp
  800f0f:	48 83 ec 28          	sub    $0x28,%rsp
  800f13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f1b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f27:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f2c:	74 3d                	je     800f6b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f2e:	eb 1d                	jmp    800f4d <strlcpy+0x42>
			*dst++ = *src++;
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f38:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f3c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f40:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f44:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f48:	0f b6 12             	movzbl (%rdx),%edx
  800f4b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f4d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f52:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f57:	74 0b                	je     800f64 <strlcpy+0x59>
  800f59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f5d:	0f b6 00             	movzbl (%rax),%eax
  800f60:	84 c0                	test   %al,%al
  800f62:	75 cc                	jne    800f30 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f68:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f73:	48 29 c2             	sub    %rax,%rdx
  800f76:	48 89 d0             	mov    %rdx,%rax
}
  800f79:	c9                   	leaveq 
  800f7a:	c3                   	retq   

0000000000800f7b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f7b:	55                   	push   %rbp
  800f7c:	48 89 e5             	mov    %rsp,%rbp
  800f7f:	48 83 ec 10          	sub    $0x10,%rsp
  800f83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f8b:	eb 0a                	jmp    800f97 <strcmp+0x1c>
		p++, q++;
  800f8d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f92:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f9b:	0f b6 00             	movzbl (%rax),%eax
  800f9e:	84 c0                	test   %al,%al
  800fa0:	74 12                	je     800fb4 <strcmp+0x39>
  800fa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa6:	0f b6 10             	movzbl (%rax),%edx
  800fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fad:	0f b6 00             	movzbl (%rax),%eax
  800fb0:	38 c2                	cmp    %al,%dl
  800fb2:	74 d9                	je     800f8d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb8:	0f b6 00             	movzbl (%rax),%eax
  800fbb:	0f b6 d0             	movzbl %al,%edx
  800fbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc2:	0f b6 00             	movzbl (%rax),%eax
  800fc5:	0f b6 c0             	movzbl %al,%eax
  800fc8:	29 c2                	sub    %eax,%edx
  800fca:	89 d0                	mov    %edx,%eax
}
  800fcc:	c9                   	leaveq 
  800fcd:	c3                   	retq   

0000000000800fce <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fce:	55                   	push   %rbp
  800fcf:	48 89 e5             	mov    %rsp,%rbp
  800fd2:	48 83 ec 18          	sub    $0x18,%rsp
  800fd6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fde:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fe2:	eb 0f                	jmp    800ff3 <strncmp+0x25>
		n--, p++, q++;
  800fe4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fe9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ff3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ff8:	74 1d                	je     801017 <strncmp+0x49>
  800ffa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ffe:	0f b6 00             	movzbl (%rax),%eax
  801001:	84 c0                	test   %al,%al
  801003:	74 12                	je     801017 <strncmp+0x49>
  801005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801009:	0f b6 10             	movzbl (%rax),%edx
  80100c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	38 c2                	cmp    %al,%dl
  801015:	74 cd                	je     800fe4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801017:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80101c:	75 07                	jne    801025 <strncmp+0x57>
		return 0;
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
  801023:	eb 18                	jmp    80103d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801029:	0f b6 00             	movzbl (%rax),%eax
  80102c:	0f b6 d0             	movzbl %al,%edx
  80102f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801033:	0f b6 00             	movzbl (%rax),%eax
  801036:	0f b6 c0             	movzbl %al,%eax
  801039:	29 c2                	sub    %eax,%edx
  80103b:	89 d0                	mov    %edx,%eax
}
  80103d:	c9                   	leaveq 
  80103e:	c3                   	retq   

000000000080103f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	48 83 ec 0c          	sub    $0xc,%rsp
  801047:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104b:	89 f0                	mov    %esi,%eax
  80104d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801050:	eb 17                	jmp    801069 <strchr+0x2a>
		if (*s == c)
  801052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801056:	0f b6 00             	movzbl (%rax),%eax
  801059:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80105c:	75 06                	jne    801064 <strchr+0x25>
			return (char *) s;
  80105e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801062:	eb 15                	jmp    801079 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801064:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106d:	0f b6 00             	movzbl (%rax),%eax
  801070:	84 c0                	test   %al,%al
  801072:	75 de                	jne    801052 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801079:	c9                   	leaveq 
  80107a:	c3                   	retq   

000000000080107b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80107b:	55                   	push   %rbp
  80107c:	48 89 e5             	mov    %rsp,%rbp
  80107f:	48 83 ec 0c          	sub    $0xc,%rsp
  801083:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801087:	89 f0                	mov    %esi,%eax
  801089:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80108c:	eb 13                	jmp    8010a1 <strfind+0x26>
		if (*s == c)
  80108e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801098:	75 02                	jne    80109c <strfind+0x21>
			break;
  80109a:	eb 10                	jmp    8010ac <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80109c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a5:	0f b6 00             	movzbl (%rax),%eax
  8010a8:	84 c0                	test   %al,%al
  8010aa:	75 e2                	jne    80108e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b0:	c9                   	leaveq 
  8010b1:	c3                   	retq   

00000000008010b2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	48 83 ec 18          	sub    $0x18,%rsp
  8010ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010be:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ca:	75 06                	jne    8010d2 <memset+0x20>
		return v;
  8010cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d0:	eb 69                	jmp    80113b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d6:	83 e0 03             	and    $0x3,%eax
  8010d9:	48 85 c0             	test   %rax,%rax
  8010dc:	75 48                	jne    801126 <memset+0x74>
  8010de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e2:	83 e0 03             	and    $0x3,%eax
  8010e5:	48 85 c0             	test   %rax,%rax
  8010e8:	75 3c                	jne    801126 <memset+0x74>
		c &= 0xFF;
  8010ea:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f4:	c1 e0 18             	shl    $0x18,%eax
  8010f7:	89 c2                	mov    %eax,%edx
  8010f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010fc:	c1 e0 10             	shl    $0x10,%eax
  8010ff:	09 c2                	or     %eax,%edx
  801101:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801104:	c1 e0 08             	shl    $0x8,%eax
  801107:	09 d0                	or     %edx,%eax
  801109:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80110c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801110:	48 c1 e8 02          	shr    $0x2,%rax
  801114:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801117:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80111b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80111e:	48 89 d7             	mov    %rdx,%rdi
  801121:	fc                   	cld    
  801122:	f3 ab                	rep stos %eax,%es:(%rdi)
  801124:	eb 11                	jmp    801137 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801126:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80112a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80112d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801131:	48 89 d7             	mov    %rdx,%rdi
  801134:	fc                   	cld    
  801135:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113b:	c9                   	leaveq 
  80113c:	c3                   	retq   

000000000080113d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	48 83 ec 28          	sub    $0x28,%rsp
  801145:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801149:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80114d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801151:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801155:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801161:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801165:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801169:	0f 83 88 00 00 00    	jae    8011f7 <memmove+0xba>
  80116f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801173:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801177:	48 01 d0             	add    %rdx,%rax
  80117a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80117e:	76 77                	jbe    8011f7 <memmove+0xba>
		s += n;
  801180:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801184:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801188:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80118c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801194:	83 e0 03             	and    $0x3,%eax
  801197:	48 85 c0             	test   %rax,%rax
  80119a:	75 3b                	jne    8011d7 <memmove+0x9a>
  80119c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a0:	83 e0 03             	and    $0x3,%eax
  8011a3:	48 85 c0             	test   %rax,%rax
  8011a6:	75 2f                	jne    8011d7 <memmove+0x9a>
  8011a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ac:	83 e0 03             	and    $0x3,%eax
  8011af:	48 85 c0             	test   %rax,%rax
  8011b2:	75 23                	jne    8011d7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b8:	48 83 e8 04          	sub    $0x4,%rax
  8011bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c0:	48 83 ea 04          	sub    $0x4,%rdx
  8011c4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011c8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011cc:	48 89 c7             	mov    %rax,%rdi
  8011cf:	48 89 d6             	mov    %rdx,%rsi
  8011d2:	fd                   	std    
  8011d3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011d5:	eb 1d                	jmp    8011f4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011db:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011eb:	48 89 d7             	mov    %rdx,%rdi
  8011ee:	48 89 c1             	mov    %rax,%rcx
  8011f1:	fd                   	std    
  8011f2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011f4:	fc                   	cld    
  8011f5:	eb 57                	jmp    80124e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fb:	83 e0 03             	and    $0x3,%eax
  8011fe:	48 85 c0             	test   %rax,%rax
  801201:	75 36                	jne    801239 <memmove+0xfc>
  801203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801207:	83 e0 03             	and    $0x3,%eax
  80120a:	48 85 c0             	test   %rax,%rax
  80120d:	75 2a                	jne    801239 <memmove+0xfc>
  80120f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801213:	83 e0 03             	and    $0x3,%eax
  801216:	48 85 c0             	test   %rax,%rax
  801219:	75 1e                	jne    801239 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80121b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121f:	48 c1 e8 02          	shr    $0x2,%rax
  801223:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80122e:	48 89 c7             	mov    %rax,%rdi
  801231:	48 89 d6             	mov    %rdx,%rsi
  801234:	fc                   	cld    
  801235:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801237:	eb 15                	jmp    80124e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801241:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801245:	48 89 c7             	mov    %rax,%rdi
  801248:	48 89 d6             	mov    %rdx,%rsi
  80124b:	fc                   	cld    
  80124c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80124e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801252:	c9                   	leaveq 
  801253:	c3                   	retq   

0000000000801254 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801254:	55                   	push   %rbp
  801255:	48 89 e5             	mov    %rsp,%rbp
  801258:	48 83 ec 18          	sub    $0x18,%rsp
  80125c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801260:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801264:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801268:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80126c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801274:	48 89 ce             	mov    %rcx,%rsi
  801277:	48 89 c7             	mov    %rax,%rdi
  80127a:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  801281:	00 00 00 
  801284:	ff d0                	callq  *%rax
}
  801286:	c9                   	leaveq 
  801287:	c3                   	retq   

0000000000801288 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801288:	55                   	push   %rbp
  801289:	48 89 e5             	mov    %rsp,%rbp
  80128c:	48 83 ec 28          	sub    $0x28,%rsp
  801290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801294:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801298:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80129c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012ac:	eb 36                	jmp    8012e4 <memcmp+0x5c>
		if (*s1 != *s2)
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	0f b6 10             	movzbl (%rax),%edx
  8012b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b9:	0f b6 00             	movzbl (%rax),%eax
  8012bc:	38 c2                	cmp    %al,%dl
  8012be:	74 1a                	je     8012da <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c4:	0f b6 00             	movzbl (%rax),%eax
  8012c7:	0f b6 d0             	movzbl %al,%edx
  8012ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ce:	0f b6 00             	movzbl (%rax),%eax
  8012d1:	0f b6 c0             	movzbl %al,%eax
  8012d4:	29 c2                	sub    %eax,%edx
  8012d6:	89 d0                	mov    %edx,%eax
  8012d8:	eb 20                	jmp    8012fa <memcmp+0x72>
		s1++, s2++;
  8012da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012df:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012f0:	48 85 c0             	test   %rax,%rax
  8012f3:	75 b9                	jne    8012ae <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fa:	c9                   	leaveq 
  8012fb:	c3                   	retq   

00000000008012fc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012fc:	55                   	push   %rbp
  8012fd:	48 89 e5             	mov    %rsp,%rbp
  801300:	48 83 ec 28          	sub    $0x28,%rsp
  801304:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801308:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80130b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80130f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801313:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801317:	48 01 d0             	add    %rdx,%rax
  80131a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80131e:	eb 15                	jmp    801335 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801320:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801324:	0f b6 10             	movzbl (%rax),%edx
  801327:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80132a:	38 c2                	cmp    %al,%dl
  80132c:	75 02                	jne    801330 <memfind+0x34>
			break;
  80132e:	eb 0f                	jmp    80133f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801330:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801339:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80133d:	72 e1                	jb     801320 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80133f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801343:	c9                   	leaveq 
  801344:	c3                   	retq   

0000000000801345 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801345:	55                   	push   %rbp
  801346:	48 89 e5             	mov    %rsp,%rbp
  801349:	48 83 ec 34          	sub    $0x34,%rsp
  80134d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801351:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801355:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801358:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80135f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801366:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801367:	eb 05                	jmp    80136e <strtol+0x29>
		s++;
  801369:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	3c 20                	cmp    $0x20,%al
  801377:	74 f0                	je     801369 <strtol+0x24>
  801379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137d:	0f b6 00             	movzbl (%rax),%eax
  801380:	3c 09                	cmp    $0x9,%al
  801382:	74 e5                	je     801369 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801384:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801388:	0f b6 00             	movzbl (%rax),%eax
  80138b:	3c 2b                	cmp    $0x2b,%al
  80138d:	75 07                	jne    801396 <strtol+0x51>
		s++;
  80138f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801394:	eb 17                	jmp    8013ad <strtol+0x68>
	else if (*s == '-')
  801396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	3c 2d                	cmp    $0x2d,%al
  80139f:	75 0c                	jne    8013ad <strtol+0x68>
		s++, neg = 1;
  8013a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013b1:	74 06                	je     8013b9 <strtol+0x74>
  8013b3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013b7:	75 28                	jne    8013e1 <strtol+0x9c>
  8013b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	3c 30                	cmp    $0x30,%al
  8013c2:	75 1d                	jne    8013e1 <strtol+0x9c>
  8013c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c8:	48 83 c0 01          	add    $0x1,%rax
  8013cc:	0f b6 00             	movzbl (%rax),%eax
  8013cf:	3c 78                	cmp    $0x78,%al
  8013d1:	75 0e                	jne    8013e1 <strtol+0x9c>
		s += 2, base = 16;
  8013d3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013d8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013df:	eb 2c                	jmp    80140d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013e5:	75 19                	jne    801400 <strtol+0xbb>
  8013e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013eb:	0f b6 00             	movzbl (%rax),%eax
  8013ee:	3c 30                	cmp    $0x30,%al
  8013f0:	75 0e                	jne    801400 <strtol+0xbb>
		s++, base = 8;
  8013f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013fe:	eb 0d                	jmp    80140d <strtol+0xc8>
	else if (base == 0)
  801400:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801404:	75 07                	jne    80140d <strtol+0xc8>
		base = 10;
  801406:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80140d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801411:	0f b6 00             	movzbl (%rax),%eax
  801414:	3c 2f                	cmp    $0x2f,%al
  801416:	7e 1d                	jle    801435 <strtol+0xf0>
  801418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141c:	0f b6 00             	movzbl (%rax),%eax
  80141f:	3c 39                	cmp    $0x39,%al
  801421:	7f 12                	jg     801435 <strtol+0xf0>
			dig = *s - '0';
  801423:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	0f be c0             	movsbl %al,%eax
  80142d:	83 e8 30             	sub    $0x30,%eax
  801430:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801433:	eb 4e                	jmp    801483 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	3c 60                	cmp    $0x60,%al
  80143e:	7e 1d                	jle    80145d <strtol+0x118>
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 12                	jg     80145d <strtol+0x118>
			dig = *s - 'a' + 10;
  80144b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144f:	0f b6 00             	movzbl (%rax),%eax
  801452:	0f be c0             	movsbl %al,%eax
  801455:	83 e8 57             	sub    $0x57,%eax
  801458:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80145b:	eb 26                	jmp    801483 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	0f b6 00             	movzbl (%rax),%eax
  801464:	3c 40                	cmp    $0x40,%al
  801466:	7e 48                	jle    8014b0 <strtol+0x16b>
  801468:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	3c 5a                	cmp    $0x5a,%al
  801471:	7f 3d                	jg     8014b0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801473:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	0f be c0             	movsbl %al,%eax
  80147d:	83 e8 37             	sub    $0x37,%eax
  801480:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801483:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801486:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801489:	7c 02                	jl     80148d <strtol+0x148>
			break;
  80148b:	eb 23                	jmp    8014b0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80148d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801492:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801495:	48 98                	cltq   
  801497:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80149c:	48 89 c2             	mov    %rax,%rdx
  80149f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014a2:	48 98                	cltq   
  8014a4:	48 01 d0             	add    %rdx,%rax
  8014a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014ab:	e9 5d ff ff ff       	jmpq   80140d <strtol+0xc8>

	if (endptr)
  8014b0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014b5:	74 0b                	je     8014c2 <strtol+0x17d>
		*endptr = (char *) s;
  8014b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014bb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014bf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014c6:	74 09                	je     8014d1 <strtol+0x18c>
  8014c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cc:	48 f7 d8             	neg    %rax
  8014cf:	eb 04                	jmp    8014d5 <strtol+0x190>
  8014d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014d5:	c9                   	leaveq 
  8014d6:	c3                   	retq   

00000000008014d7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014d7:	55                   	push   %rbp
  8014d8:	48 89 e5             	mov    %rsp,%rbp
  8014db:	48 83 ec 30          	sub    $0x30,%rsp
  8014df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ef:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014f9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014fd:	75 06                	jne    801505 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801503:	eb 6b                	jmp    801570 <strstr+0x99>

	len = strlen(str);
  801505:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801509:	48 89 c7             	mov    %rax,%rdi
  80150c:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  801513:	00 00 00 
  801516:	ff d0                	callq  *%rax
  801518:	48 98                	cltq   
  80151a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801526:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80152a:	0f b6 00             	movzbl (%rax),%eax
  80152d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801530:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801534:	75 07                	jne    80153d <strstr+0x66>
				return (char *) 0;
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	eb 33                	jmp    801570 <strstr+0x99>
		} while (sc != c);
  80153d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801541:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801544:	75 d8                	jne    80151e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801546:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80154a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80154e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801552:	48 89 ce             	mov    %rcx,%rsi
  801555:	48 89 c7             	mov    %rax,%rdi
  801558:	48 b8 ce 0f 80 00 00 	movabs $0x800fce,%rax
  80155f:	00 00 00 
  801562:	ff d0                	callq  *%rax
  801564:	85 c0                	test   %eax,%eax
  801566:	75 b6                	jne    80151e <strstr+0x47>

	return (char *) (in - 1);
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	48 83 e8 01          	sub    $0x1,%rax
}
  801570:	c9                   	leaveq 
  801571:	c3                   	retq   

0000000000801572 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	53                   	push   %rbx
  801577:	48 83 ec 48          	sub    $0x48,%rsp
  80157b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80157e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801581:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801585:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801589:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80158d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801591:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801594:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801598:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80159c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015a0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015a4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015a8:	4c 89 c3             	mov    %r8,%rbx
  8015ab:	cd 30                	int    $0x30
  8015ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015b5:	74 3e                	je     8015f5 <syscall+0x83>
  8015b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015bc:	7e 37                	jle    8015f5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015c5:	49 89 d0             	mov    %rdx,%r8
  8015c8:	89 c1                	mov    %eax,%ecx
  8015ca:	48 ba 08 3b 80 00 00 	movabs $0x803b08,%rdx
  8015d1:	00 00 00 
  8015d4:	be 23 00 00 00       	mov    $0x23,%esi
  8015d9:	48 bf 25 3b 80 00 00 	movabs $0x803b25,%rdi
  8015e0:	00 00 00 
  8015e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e8:	49 b9 7a 32 80 00 00 	movabs $0x80327a,%r9
  8015ef:	00 00 00 
  8015f2:	41 ff d1             	callq  *%r9

	return ret;
  8015f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f9:	48 83 c4 48          	add    $0x48,%rsp
  8015fd:	5b                   	pop    %rbx
  8015fe:	5d                   	pop    %rbp
  8015ff:	c3                   	retq   

0000000000801600 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801600:	55                   	push   %rbp
  801601:	48 89 e5             	mov    %rsp,%rbp
  801604:	48 83 ec 20          	sub    $0x20,%rsp
  801608:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80160c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801614:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801618:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80161f:	00 
  801620:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801626:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80162c:	48 89 d1             	mov    %rdx,%rcx
  80162f:	48 89 c2             	mov    %rax,%rdx
  801632:	be 00 00 00 00       	mov    $0x0,%esi
  801637:	bf 00 00 00 00       	mov    $0x0,%edi
  80163c:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801643:	00 00 00 
  801646:	ff d0                	callq  *%rax
}
  801648:	c9                   	leaveq 
  801649:	c3                   	retq   

000000000080164a <sys_cgetc>:

int
sys_cgetc(void)
{
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
  80164e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801652:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801659:	00 
  80165a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801660:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801666:	b9 00 00 00 00       	mov    $0x0,%ecx
  80166b:	ba 00 00 00 00       	mov    $0x0,%edx
  801670:	be 00 00 00 00       	mov    $0x0,%esi
  801675:	bf 01 00 00 00       	mov    $0x1,%edi
  80167a:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801681:	00 00 00 
  801684:	ff d0                	callq  *%rax
}
  801686:	c9                   	leaveq 
  801687:	c3                   	retq   

0000000000801688 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801688:	55                   	push   %rbp
  801689:	48 89 e5             	mov    %rsp,%rbp
  80168c:	48 83 ec 10          	sub    $0x10,%rsp
  801690:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801696:	48 98                	cltq   
  801698:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80169f:	00 
  8016a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b1:	48 89 c2             	mov    %rax,%rdx
  8016b4:	be 01 00 00 00       	mov    $0x1,%esi
  8016b9:	bf 03 00 00 00       	mov    $0x3,%edi
  8016be:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  8016c5:	00 00 00 
  8016c8:	ff d0                	callq  *%rax
}
  8016ca:	c9                   	leaveq 
  8016cb:	c3                   	retq   

00000000008016cc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016cc:	55                   	push   %rbp
  8016cd:	48 89 e5             	mov    %rsp,%rbp
  8016d0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016db:	00 
  8016dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f2:	be 00 00 00 00       	mov    $0x0,%esi
  8016f7:	bf 02 00 00 00       	mov    $0x2,%edi
  8016fc:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801703:	00 00 00 
  801706:	ff d0                	callq  *%rax
}
  801708:	c9                   	leaveq 
  801709:	c3                   	retq   

000000000080170a <sys_yield>:

void
sys_yield(void)
{
  80170a:	55                   	push   %rbp
  80170b:	48 89 e5             	mov    %rsp,%rbp
  80170e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801712:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801719:	00 
  80171a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801720:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801726:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172b:	ba 00 00 00 00       	mov    $0x0,%edx
  801730:	be 00 00 00 00       	mov    $0x0,%esi
  801735:	bf 0b 00 00 00       	mov    $0xb,%edi
  80173a:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801741:	00 00 00 
  801744:	ff d0                	callq  *%rax
}
  801746:	c9                   	leaveq 
  801747:	c3                   	retq   

0000000000801748 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801748:	55                   	push   %rbp
  801749:	48 89 e5             	mov    %rsp,%rbp
  80174c:	48 83 ec 20          	sub    $0x20,%rsp
  801750:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801753:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801757:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80175a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80175d:	48 63 c8             	movslq %eax,%rcx
  801760:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801764:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801767:	48 98                	cltq   
  801769:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801770:	00 
  801771:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801777:	49 89 c8             	mov    %rcx,%r8
  80177a:	48 89 d1             	mov    %rdx,%rcx
  80177d:	48 89 c2             	mov    %rax,%rdx
  801780:	be 01 00 00 00       	mov    $0x1,%esi
  801785:	bf 04 00 00 00       	mov    $0x4,%edi
  80178a:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801791:	00 00 00 
  801794:	ff d0                	callq  *%rax
}
  801796:	c9                   	leaveq 
  801797:	c3                   	retq   

0000000000801798 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801798:	55                   	push   %rbp
  801799:	48 89 e5             	mov    %rsp,%rbp
  80179c:	48 83 ec 30          	sub    $0x30,%rsp
  8017a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017aa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017ae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017b2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017b5:	48 63 c8             	movslq %eax,%rcx
  8017b8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017bf:	48 63 f0             	movslq %eax,%rsi
  8017c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c9:	48 98                	cltq   
  8017cb:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017cf:	49 89 f9             	mov    %rdi,%r9
  8017d2:	49 89 f0             	mov    %rsi,%r8
  8017d5:	48 89 d1             	mov    %rdx,%rcx
  8017d8:	48 89 c2             	mov    %rax,%rdx
  8017db:	be 01 00 00 00       	mov    $0x1,%esi
  8017e0:	bf 05 00 00 00       	mov    $0x5,%edi
  8017e5:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  8017ec:	00 00 00 
  8017ef:	ff d0                	callq  *%rax
}
  8017f1:	c9                   	leaveq 
  8017f2:	c3                   	retq   

00000000008017f3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017f3:	55                   	push   %rbp
  8017f4:	48 89 e5             	mov    %rsp,%rbp
  8017f7:	48 83 ec 20          	sub    $0x20,%rsp
  8017fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801802:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801806:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801809:	48 98                	cltq   
  80180b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801812:	00 
  801813:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801819:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80181f:	48 89 d1             	mov    %rdx,%rcx
  801822:	48 89 c2             	mov    %rax,%rdx
  801825:	be 01 00 00 00       	mov    $0x1,%esi
  80182a:	bf 06 00 00 00       	mov    $0x6,%edi
  80182f:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801836:	00 00 00 
  801839:	ff d0                	callq  *%rax
}
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 10          	sub    $0x10,%rsp
  801845:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801848:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80184b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80184e:	48 63 d0             	movslq %eax,%rdx
  801851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801854:	48 98                	cltq   
  801856:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185d:	00 
  80185e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801864:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186a:	48 89 d1             	mov    %rdx,%rcx
  80186d:	48 89 c2             	mov    %rax,%rdx
  801870:	be 01 00 00 00       	mov    $0x1,%esi
  801875:	bf 08 00 00 00       	mov    $0x8,%edi
  80187a:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801881:	00 00 00 
  801884:	ff d0                	callq  *%rax
}
  801886:	c9                   	leaveq 
  801887:	c3                   	retq   

0000000000801888 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	48 83 ec 20          	sub    $0x20,%rsp
  801890:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801893:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801897:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189e:	48 98                	cltq   
  8018a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a7:	00 
  8018a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b4:	48 89 d1             	mov    %rdx,%rcx
  8018b7:	48 89 c2             	mov    %rax,%rdx
  8018ba:	be 01 00 00 00       	mov    $0x1,%esi
  8018bf:	bf 09 00 00 00       	mov    $0x9,%edi
  8018c4:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  8018cb:	00 00 00 
  8018ce:	ff d0                	callq  *%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 20          	sub    $0x20,%rsp
  8018da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e8:	48 98                	cltq   
  8018ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f1:	00 
  8018f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fe:	48 89 d1             	mov    %rdx,%rcx
  801901:	48 89 c2             	mov    %rax,%rdx
  801904:	be 01 00 00 00       	mov    $0x1,%esi
  801909:	bf 0a 00 00 00       	mov    $0xa,%edi
  80190e:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  801915:	00 00 00 
  801918:	ff d0                	callq  *%rax
}
  80191a:	c9                   	leaveq 
  80191b:	c3                   	retq   

000000000080191c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80191c:	55                   	push   %rbp
  80191d:	48 89 e5             	mov    %rsp,%rbp
  801920:	48 83 ec 20          	sub    $0x20,%rsp
  801924:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801927:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80192b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80192f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801932:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801935:	48 63 f0             	movslq %eax,%rsi
  801938:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80193c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193f:	48 98                	cltq   
  801941:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801945:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194c:	00 
  80194d:	49 89 f1             	mov    %rsi,%r9
  801950:	49 89 c8             	mov    %rcx,%r8
  801953:	48 89 d1             	mov    %rdx,%rcx
  801956:	48 89 c2             	mov    %rax,%rdx
  801959:	be 00 00 00 00       	mov    $0x0,%esi
  80195e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801963:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  80196a:	00 00 00 
  80196d:	ff d0                	callq  *%rax
}
  80196f:	c9                   	leaveq 
  801970:	c3                   	retq   

0000000000801971 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801971:	55                   	push   %rbp
  801972:	48 89 e5             	mov    %rsp,%rbp
  801975:	48 83 ec 10          	sub    $0x10,%rsp
  801979:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80197d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801981:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801988:	00 
  801989:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801995:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199a:	48 89 c2             	mov    %rax,%rdx
  80199d:	be 01 00 00 00       	mov    $0x1,%esi
  8019a2:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019a7:	48 b8 72 15 80 00 00 	movabs $0x801572,%rax
  8019ae:	00 00 00 
  8019b1:	ff d0                	callq  *%rax
}
  8019b3:	c9                   	leaveq 
  8019b4:	c3                   	retq   

00000000008019b5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8019b5:	55                   	push   %rbp
  8019b6:	48 89 e5             	mov    %rsp,%rbp
  8019b9:	48 83 ec 08          	sub    $0x8,%rsp
  8019bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019c5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019cc:	ff ff ff 
  8019cf:	48 01 d0             	add    %rdx,%rax
  8019d2:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019d6:	c9                   	leaveq 
  8019d7:	c3                   	retq   

00000000008019d8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019d8:	55                   	push   %rbp
  8019d9:	48 89 e5             	mov    %rsp,%rbp
  8019dc:	48 83 ec 08          	sub    $0x8,%rsp
  8019e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8019e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e8:	48 89 c7             	mov    %rax,%rdi
  8019eb:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  8019f2:	00 00 00 
  8019f5:	ff d0                	callq  *%rax
  8019f7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019fd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a01:	c9                   	leaveq 
  801a02:	c3                   	retq   

0000000000801a03 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a03:	55                   	push   %rbp
  801a04:	48 89 e5             	mov    %rsp,%rbp
  801a07:	48 83 ec 18          	sub    $0x18,%rsp
  801a0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a16:	eb 6b                	jmp    801a83 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1b:	48 98                	cltq   
  801a1d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a23:	48 c1 e0 0c          	shl    $0xc,%rax
  801a27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a2f:	48 c1 e8 15          	shr    $0x15,%rax
  801a33:	48 89 c2             	mov    %rax,%rdx
  801a36:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801a3d:	01 00 00 
  801a40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a44:	83 e0 01             	and    $0x1,%eax
  801a47:	48 85 c0             	test   %rax,%rax
  801a4a:	74 21                	je     801a6d <fd_alloc+0x6a>
  801a4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a50:	48 c1 e8 0c          	shr    $0xc,%rax
  801a54:	48 89 c2             	mov    %rax,%rdx
  801a57:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a5e:	01 00 00 
  801a61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a65:	83 e0 01             	and    $0x1,%eax
  801a68:	48 85 c0             	test   %rax,%rax
  801a6b:	75 12                	jne    801a7f <fd_alloc+0x7c>
			*fd_store = fd;
  801a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a75:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7d:	eb 1a                	jmp    801a99 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a7f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801a83:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801a87:	7e 8f                	jle    801a18 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a8d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801a94:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	48 83 ec 20          	sub    $0x20,%rsp
  801aa3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801aa6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801aaa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801aae:	78 06                	js     801ab6 <fd_lookup+0x1b>
  801ab0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ab4:	7e 07                	jle    801abd <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ab6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801abb:	eb 6c                	jmp    801b29 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801abd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ac0:	48 98                	cltq   
  801ac2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ac8:	48 c1 e0 0c          	shl    $0xc,%rax
  801acc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad4:	48 c1 e8 15          	shr    $0x15,%rax
  801ad8:	48 89 c2             	mov    %rax,%rdx
  801adb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ae2:	01 00 00 
  801ae5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ae9:	83 e0 01             	and    $0x1,%eax
  801aec:	48 85 c0             	test   %rax,%rax
  801aef:	74 21                	je     801b12 <fd_lookup+0x77>
  801af1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af5:	48 c1 e8 0c          	shr    $0xc,%rax
  801af9:	48 89 c2             	mov    %rax,%rdx
  801afc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b03:	01 00 00 
  801b06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b0a:	83 e0 01             	and    $0x1,%eax
  801b0d:	48 85 c0             	test   %rax,%rax
  801b10:	75 07                	jne    801b19 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b17:	eb 10                	jmp    801b29 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b1d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b21:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b29:	c9                   	leaveq 
  801b2a:	c3                   	retq   

0000000000801b2b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b2b:	55                   	push   %rbp
  801b2c:	48 89 e5             	mov    %rsp,%rbp
  801b2f:	48 83 ec 30          	sub    $0x30,%rsp
  801b33:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b37:	89 f0                	mov    %esi,%eax
  801b39:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b40:	48 89 c7             	mov    %rax,%rdi
  801b43:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
  801b4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b53:	48 89 d6             	mov    %rdx,%rsi
  801b56:	89 c7                	mov    %eax,%edi
  801b58:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  801b5f:	00 00 00 
  801b62:	ff d0                	callq  *%rax
  801b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b6b:	78 0a                	js     801b77 <fd_close+0x4c>
	    || fd != fd2)
  801b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b71:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801b75:	74 12                	je     801b89 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801b77:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801b7b:	74 05                	je     801b82 <fd_close+0x57>
  801b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b80:	eb 05                	jmp    801b87 <fd_close+0x5c>
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
  801b87:	eb 69                	jmp    801bf2 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8d:	8b 00                	mov    (%rax),%eax
  801b8f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b93:	48 89 d6             	mov    %rdx,%rsi
  801b96:	89 c7                	mov    %eax,%edi
  801b98:	48 b8 f4 1b 80 00 00 	movabs $0x801bf4,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
  801ba4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ba7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bab:	78 2a                	js     801bd7 <fd_close+0xac>
		if (dev->dev_close)
  801bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb1:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bb5:	48 85 c0             	test   %rax,%rax
  801bb8:	74 16                	je     801bd0 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbe:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bc2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bc6:	48 89 d7             	mov    %rdx,%rdi
  801bc9:	ff d0                	callq  *%rax
  801bcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bce:	eb 07                	jmp    801bd7 <fd_close+0xac>
		else
			r = 0;
  801bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bdb:	48 89 c6             	mov    %rax,%rsi
  801bde:	bf 00 00 00 00       	mov    $0x0,%edi
  801be3:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  801bea:	00 00 00 
  801bed:	ff d0                	callq  *%rax
	return r;
  801bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801bf2:	c9                   	leaveq 
  801bf3:	c3                   	retq   

0000000000801bf4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801bf4:	55                   	push   %rbp
  801bf5:	48 89 e5             	mov    %rsp,%rbp
  801bf8:	48 83 ec 20          	sub    $0x20,%rsp
  801bfc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801bff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c0a:	eb 41                	jmp    801c4d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c0c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c13:	00 00 00 
  801c16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c19:	48 63 d2             	movslq %edx,%rdx
  801c1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c20:	8b 00                	mov    (%rax),%eax
  801c22:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c25:	75 22                	jne    801c49 <dev_lookup+0x55>
			*dev = devtab[i];
  801c27:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c2e:	00 00 00 
  801c31:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c34:	48 63 d2             	movslq %edx,%rdx
  801c37:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c3f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
  801c47:	eb 60                	jmp    801ca9 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c49:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c4d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c54:	00 00 00 
  801c57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c5a:	48 63 d2             	movslq %edx,%rdx
  801c5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c61:	48 85 c0             	test   %rax,%rax
  801c64:	75 a6                	jne    801c0c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c66:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801c6d:	00 00 00 
  801c70:	48 8b 00             	mov    (%rax),%rax
  801c73:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c79:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c7c:	89 c6                	mov    %eax,%esi
  801c7e:	48 bf 38 3b 80 00 00 	movabs $0x803b38,%rdi
  801c85:	00 00 00 
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	48 b9 51 02 80 00 00 	movabs $0x800251,%rcx
  801c94:	00 00 00 
  801c97:	ff d1                	callq  *%rcx
	*dev = 0;
  801c99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c9d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ca4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ca9:	c9                   	leaveq 
  801caa:	c3                   	retq   

0000000000801cab <close>:

int
close(int fdnum)
{
  801cab:	55                   	push   %rbp
  801cac:	48 89 e5             	mov    %rsp,%rbp
  801caf:	48 83 ec 20          	sub    $0x20,%rsp
  801cb3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cb6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cbd:	48 89 d6             	mov    %rdx,%rsi
  801cc0:	89 c7                	mov    %eax,%edi
  801cc2:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
  801cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cd5:	79 05                	jns    801cdc <close+0x31>
		return r;
  801cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cda:	eb 18                	jmp    801cf4 <close+0x49>
	else
		return fd_close(fd, 1);
  801cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce0:	be 01 00 00 00       	mov    $0x1,%esi
  801ce5:	48 89 c7             	mov    %rax,%rdi
  801ce8:	48 b8 2b 1b 80 00 00 	movabs $0x801b2b,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	callq  *%rax
}
  801cf4:	c9                   	leaveq 
  801cf5:	c3                   	retq   

0000000000801cf6 <close_all>:

void
close_all(void)
{
  801cf6:	55                   	push   %rbp
  801cf7:	48 89 e5             	mov    %rsp,%rbp
  801cfa:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801cfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d05:	eb 15                	jmp    801d1c <close_all+0x26>
		close(i);
  801d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0a:	89 c7                	mov    %eax,%edi
  801d0c:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d18:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d1c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d20:	7e e5                	jle    801d07 <close_all+0x11>
		close(i);
}
  801d22:	c9                   	leaveq 
  801d23:	c3                   	retq   

0000000000801d24 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d24:	55                   	push   %rbp
  801d25:	48 89 e5             	mov    %rsp,%rbp
  801d28:	48 83 ec 40          	sub    $0x40,%rsp
  801d2c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d2f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d32:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801d36:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d39:	48 89 d6             	mov    %rdx,%rsi
  801d3c:	89 c7                	mov    %eax,%edi
  801d3e:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	callq  *%rax
  801d4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d51:	79 08                	jns    801d5b <dup+0x37>
		return r;
  801d53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d56:	e9 70 01 00 00       	jmpq   801ecb <dup+0x1a7>
	close(newfdnum);
  801d5b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d5e:	89 c7                	mov    %eax,%edi
  801d60:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  801d67:	00 00 00 
  801d6a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801d6c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d6f:	48 98                	cltq   
  801d71:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d77:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801d7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d83:	48 89 c7             	mov    %rax,%rdi
  801d86:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	callq  *%rax
  801d92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d9a:	48 89 c7             	mov    %rax,%rdi
  801d9d:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	callq  *%rax
  801da9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db1:	48 c1 e8 15          	shr    $0x15,%rax
  801db5:	48 89 c2             	mov    %rax,%rdx
  801db8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dbf:	01 00 00 
  801dc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dc6:	83 e0 01             	and    $0x1,%eax
  801dc9:	48 85 c0             	test   %rax,%rax
  801dcc:	74 73                	je     801e41 <dup+0x11d>
  801dce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd2:	48 c1 e8 0c          	shr    $0xc,%rax
  801dd6:	48 89 c2             	mov    %rax,%rdx
  801dd9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801de0:	01 00 00 
  801de3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de7:	83 e0 01             	and    $0x1,%eax
  801dea:	48 85 c0             	test   %rax,%rax
  801ded:	74 52                	je     801e41 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df3:	48 c1 e8 0c          	shr    $0xc,%rax
  801df7:	48 89 c2             	mov    %rax,%rdx
  801dfa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e01:	01 00 00 
  801e04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e08:	25 07 0e 00 00       	and    $0xe07,%eax
  801e0d:	89 c1                	mov    %eax,%ecx
  801e0f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e17:	41 89 c8             	mov    %ecx,%r8d
  801e1a:	48 89 d1             	mov    %rdx,%rcx
  801e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e22:	48 89 c6             	mov    %rax,%rsi
  801e25:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2a:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801e31:	00 00 00 
  801e34:	ff d0                	callq  *%rax
  801e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3d:	79 02                	jns    801e41 <dup+0x11d>
			goto err;
  801e3f:	eb 57                	jmp    801e98 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e45:	48 c1 e8 0c          	shr    $0xc,%rax
  801e49:	48 89 c2             	mov    %rax,%rdx
  801e4c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e53:	01 00 00 
  801e56:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5a:	25 07 0e 00 00       	and    $0xe07,%eax
  801e5f:	89 c1                	mov    %eax,%ecx
  801e61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e69:	41 89 c8             	mov    %ecx,%r8d
  801e6c:	48 89 d1             	mov    %rdx,%rcx
  801e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e74:	48 89 c6             	mov    %rax,%rsi
  801e77:	bf 00 00 00 00       	mov    $0x0,%edi
  801e7c:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
  801e88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e8f:	79 02                	jns    801e93 <dup+0x16f>
		goto err;
  801e91:	eb 05                	jmp    801e98 <dup+0x174>

	return newfdnum;
  801e93:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e96:	eb 33                	jmp    801ecb <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9c:	48 89 c6             	mov    %rax,%rsi
  801e9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea4:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  801eab:	00 00 00 
  801eae:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801eb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb4:	48 89 c6             	mov    %rax,%rsi
  801eb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ebc:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
	return r;
  801ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ecb:	c9                   	leaveq 
  801ecc:	c3                   	retq   

0000000000801ecd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	48 83 ec 40          	sub    $0x40,%rsp
  801ed5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ed8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801edc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ee0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ee4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ee7:	48 89 d6             	mov    %rdx,%rsi
  801eea:	89 c7                	mov    %eax,%edi
  801eec:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  801ef3:	00 00 00 
  801ef6:	ff d0                	callq  *%rax
  801ef8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eff:	78 24                	js     801f25 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f05:	8b 00                	mov    (%rax),%eax
  801f07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f0b:	48 89 d6             	mov    %rdx,%rsi
  801f0e:	89 c7                	mov    %eax,%edi
  801f10:	48 b8 f4 1b 80 00 00 	movabs $0x801bf4,%rax
  801f17:	00 00 00 
  801f1a:	ff d0                	callq  *%rax
  801f1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f23:	79 05                	jns    801f2a <read+0x5d>
		return r;
  801f25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f28:	eb 76                	jmp    801fa0 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2e:	8b 40 08             	mov    0x8(%rax),%eax
  801f31:	83 e0 03             	and    $0x3,%eax
  801f34:	83 f8 01             	cmp    $0x1,%eax
  801f37:	75 3a                	jne    801f73 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f39:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f40:	00 00 00 
  801f43:	48 8b 00             	mov    (%rax),%rax
  801f46:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f4c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f4f:	89 c6                	mov    %eax,%esi
  801f51:	48 bf 57 3b 80 00 00 	movabs $0x803b57,%rdi
  801f58:	00 00 00 
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f60:	48 b9 51 02 80 00 00 	movabs $0x800251,%rcx
  801f67:	00 00 00 
  801f6a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801f6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f71:	eb 2d                	jmp    801fa0 <read+0xd3>
	}
	if (!dev->dev_read)
  801f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f77:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f7b:	48 85 c0             	test   %rax,%rax
  801f7e:	75 07                	jne    801f87 <read+0xba>
		return -E_NOT_SUPP;
  801f80:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801f85:	eb 19                	jmp    801fa0 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f8f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f93:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801f97:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801f9b:	48 89 cf             	mov    %rcx,%rdi
  801f9e:	ff d0                	callq  *%rax
}
  801fa0:	c9                   	leaveq 
  801fa1:	c3                   	retq   

0000000000801fa2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801fa2:	55                   	push   %rbp
  801fa3:	48 89 e5             	mov    %rsp,%rbp
  801fa6:	48 83 ec 30          	sub    $0x30,%rsp
  801faa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fb1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fbc:	eb 49                	jmp    802007 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc1:	48 98                	cltq   
  801fc3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fc7:	48 29 c2             	sub    %rax,%rdx
  801fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fcd:	48 63 c8             	movslq %eax,%rcx
  801fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd4:	48 01 c1             	add    %rax,%rcx
  801fd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fda:	48 89 ce             	mov    %rcx,%rsi
  801fdd:	89 c7                	mov    %eax,%edi
  801fdf:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  801fe6:	00 00 00 
  801fe9:	ff d0                	callq  *%rax
  801feb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801fee:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ff2:	79 05                	jns    801ff9 <readn+0x57>
			return m;
  801ff4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ff7:	eb 1c                	jmp    802015 <readn+0x73>
		if (m == 0)
  801ff9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ffd:	75 02                	jne    802001 <readn+0x5f>
			break;
  801fff:	eb 11                	jmp    802012 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802001:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802004:	01 45 fc             	add    %eax,-0x4(%rbp)
  802007:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200a:	48 98                	cltq   
  80200c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802010:	72 ac                	jb     801fbe <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802012:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802015:	c9                   	leaveq 
  802016:	c3                   	retq   

0000000000802017 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
  80201b:	48 83 ec 40          	sub    $0x40,%rsp
  80201f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802022:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802026:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80202a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80202e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802031:	48 89 d6             	mov    %rdx,%rsi
  802034:	89 c7                	mov    %eax,%edi
  802036:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
  802042:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802045:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802049:	78 24                	js     80206f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80204b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204f:	8b 00                	mov    (%rax),%eax
  802051:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802055:	48 89 d6             	mov    %rdx,%rsi
  802058:	89 c7                	mov    %eax,%edi
  80205a:	48 b8 f4 1b 80 00 00 	movabs $0x801bf4,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
  802066:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802069:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206d:	79 05                	jns    802074 <write+0x5d>
		return r;
  80206f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802072:	eb 75                	jmp    8020e9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802078:	8b 40 08             	mov    0x8(%rax),%eax
  80207b:	83 e0 03             	and    $0x3,%eax
  80207e:	85 c0                	test   %eax,%eax
  802080:	75 3a                	jne    8020bc <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802082:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802089:	00 00 00 
  80208c:	48 8b 00             	mov    (%rax),%rax
  80208f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802095:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802098:	89 c6                	mov    %eax,%esi
  80209a:	48 bf 73 3b 80 00 00 	movabs $0x803b73,%rdi
  8020a1:	00 00 00 
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	48 b9 51 02 80 00 00 	movabs $0x800251,%rcx
  8020b0:	00 00 00 
  8020b3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ba:	eb 2d                	jmp    8020e9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020c4:	48 85 c0             	test   %rax,%rax
  8020c7:	75 07                	jne    8020d0 <write+0xb9>
		return -E_NOT_SUPP;
  8020c9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020ce:	eb 19                	jmp    8020e9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8020d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020d8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020e0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8020e4:	48 89 cf             	mov    %rcx,%rdi
  8020e7:	ff d0                	callq  *%rax
}
  8020e9:	c9                   	leaveq 
  8020ea:	c3                   	retq   

00000000008020eb <seek>:

int
seek(int fdnum, off_t offset)
{
  8020eb:	55                   	push   %rbp
  8020ec:	48 89 e5             	mov    %rsp,%rbp
  8020ef:	48 83 ec 18          	sub    $0x18,%rsp
  8020f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020f6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802100:	48 89 d6             	mov    %rdx,%rsi
  802103:	89 c7                	mov    %eax,%edi
  802105:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax
  802111:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802114:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802118:	79 05                	jns    80211f <seek+0x34>
		return r;
  80211a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211d:	eb 0f                	jmp    80212e <seek+0x43>
	fd->fd_offset = offset;
  80211f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802123:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802126:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212e:	c9                   	leaveq 
  80212f:	c3                   	retq   

0000000000802130 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802130:	55                   	push   %rbp
  802131:	48 89 e5             	mov    %rsp,%rbp
  802134:	48 83 ec 30          	sub    $0x30,%rsp
  802138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80213b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80213e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802142:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802145:	48 89 d6             	mov    %rdx,%rsi
  802148:	89 c7                	mov    %eax,%edi
  80214a:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  802151:	00 00 00 
  802154:	ff d0                	callq  *%rax
  802156:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802159:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215d:	78 24                	js     802183 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80215f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802163:	8b 00                	mov    (%rax),%eax
  802165:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802169:	48 89 d6             	mov    %rdx,%rsi
  80216c:	89 c7                	mov    %eax,%edi
  80216e:	48 b8 f4 1b 80 00 00 	movabs $0x801bf4,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802181:	79 05                	jns    802188 <ftruncate+0x58>
		return r;
  802183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802186:	eb 72                	jmp    8021fa <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218c:	8b 40 08             	mov    0x8(%rax),%eax
  80218f:	83 e0 03             	and    $0x3,%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	75 3a                	jne    8021d0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802196:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80219d:	00 00 00 
  8021a0:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021a3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021a9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021ac:	89 c6                	mov    %eax,%esi
  8021ae:	48 bf 90 3b 80 00 00 	movabs $0x803b90,%rdi
  8021b5:	00 00 00 
  8021b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bd:	48 b9 51 02 80 00 00 	movabs $0x800251,%rcx
  8021c4:	00 00 00 
  8021c7:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8021c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021ce:	eb 2a                	jmp    8021fa <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8021d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021d8:	48 85 c0             	test   %rax,%rax
  8021db:	75 07                	jne    8021e4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8021dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021e2:	eb 16                	jmp    8021fa <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8021e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021f0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8021f3:	89 ce                	mov    %ecx,%esi
  8021f5:	48 89 d7             	mov    %rdx,%rdi
  8021f8:	ff d0                	callq  *%rax
}
  8021fa:	c9                   	leaveq 
  8021fb:	c3                   	retq   

00000000008021fc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8021fc:	55                   	push   %rbp
  8021fd:	48 89 e5             	mov    %rsp,%rbp
  802200:	48 83 ec 30          	sub    $0x30,%rsp
  802204:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802207:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80220b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80220f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802212:	48 89 d6             	mov    %rdx,%rsi
  802215:	89 c7                	mov    %eax,%edi
  802217:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  80221e:	00 00 00 
  802221:	ff d0                	callq  *%rax
  802223:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802226:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222a:	78 24                	js     802250 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80222c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802230:	8b 00                	mov    (%rax),%eax
  802232:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802236:	48 89 d6             	mov    %rdx,%rsi
  802239:	89 c7                	mov    %eax,%edi
  80223b:	48 b8 f4 1b 80 00 00 	movabs $0x801bf4,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
  802247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224e:	79 05                	jns    802255 <fstat+0x59>
		return r;
  802250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802253:	eb 5e                	jmp    8022b3 <fstat+0xb7>
	if (!dev->dev_stat)
  802255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802259:	48 8b 40 28          	mov    0x28(%rax),%rax
  80225d:	48 85 c0             	test   %rax,%rax
  802260:	75 07                	jne    802269 <fstat+0x6d>
		return -E_NOT_SUPP;
  802262:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802267:	eb 4a                	jmp    8022b3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802269:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80226d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802270:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802274:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80227b:	00 00 00 
	stat->st_isdir = 0;
  80227e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802282:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802289:	00 00 00 
	stat->st_dev = dev;
  80228c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802290:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802294:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80229b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229f:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022a7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022ab:	48 89 ce             	mov    %rcx,%rsi
  8022ae:	48 89 d7             	mov    %rdx,%rdi
  8022b1:	ff d0                	callq  *%rax
}
  8022b3:	c9                   	leaveq 
  8022b4:	c3                   	retq   

00000000008022b5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022b5:	55                   	push   %rbp
  8022b6:	48 89 e5             	mov    %rsp,%rbp
  8022b9:	48 83 ec 20          	sub    $0x20,%rsp
  8022bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c9:	be 00 00 00 00       	mov    $0x0,%esi
  8022ce:	48 89 c7             	mov    %rax,%rdi
  8022d1:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e4:	79 05                	jns    8022eb <stat+0x36>
		return fd;
  8022e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e9:	eb 2f                	jmp    80231a <stat+0x65>
	r = fstat(fd, stat);
  8022eb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f2:	48 89 d6             	mov    %rdx,%rsi
  8022f5:	89 c7                	mov    %eax,%edi
  8022f7:	48 b8 fc 21 80 00 00 	movabs $0x8021fc,%rax
  8022fe:	00 00 00 
  802301:	ff d0                	callq  *%rax
  802303:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802309:	89 c7                	mov    %eax,%edi
  80230b:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  802312:	00 00 00 
  802315:	ff d0                	callq  *%rax
	return r;
  802317:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80231a:	c9                   	leaveq 
  80231b:	c3                   	retq   

000000000080231c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80231c:	55                   	push   %rbp
  80231d:	48 89 e5             	mov    %rsp,%rbp
  802320:	48 83 ec 10          	sub    $0x10,%rsp
  802324:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802327:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80232b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802332:	00 00 00 
  802335:	8b 00                	mov    (%rax),%eax
  802337:	85 c0                	test   %eax,%eax
  802339:	75 1d                	jne    802358 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80233b:	bf 01 00 00 00       	mov    $0x1,%edi
  802340:	48 b8 e7 34 80 00 00 	movabs $0x8034e7,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
  80234c:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802353:	00 00 00 
  802356:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802358:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80235f:	00 00 00 
  802362:	8b 00                	mov    (%rax),%eax
  802364:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802367:	b9 07 00 00 00       	mov    $0x7,%ecx
  80236c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802373:	00 00 00 
  802376:	89 c7                	mov    %eax,%edi
  802378:	48 b8 4f 34 80 00 00 	movabs $0x80344f,%rax
  80237f:	00 00 00 
  802382:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802388:	ba 00 00 00 00       	mov    $0x0,%edx
  80238d:	48 89 c6             	mov    %rax,%rsi
  802390:	bf 00 00 00 00       	mov    $0x0,%edi
  802395:	48 b8 8e 33 80 00 00 	movabs $0x80338e,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	callq  *%rax
}
  8023a1:	c9                   	leaveq 
  8023a2:	c3                   	retq   

00000000008023a3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023a3:	55                   	push   %rbp
  8023a4:	48 89 e5             	mov    %rsp,%rbp
  8023a7:	48 83 ec 20          	sub    $0x20,%rsp
  8023ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8023b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b6:	48 89 c7             	mov    %rax,%rdi
  8023b9:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  8023c0:	00 00 00 
  8023c3:	ff d0                	callq  *%rax
  8023c5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023ca:	7e 0a                	jle    8023d6 <open+0x33>
		return -E_BAD_PATH;
  8023cc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8023d1:	e9 a5 00 00 00       	jmpq   80247b <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8023d6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8023da:	48 89 c7             	mov    %rax,%rdi
  8023dd:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	callq  *%rax
  8023e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f0:	79 08                	jns    8023fa <open+0x57>
		return r;
  8023f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f5:	e9 81 00 00 00       	jmpq   80247b <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	48 89 c6             	mov    %rax,%rsi
  802401:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802408:	00 00 00 
  80240b:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  802412:	00 00 00 
  802415:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802417:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80241e:	00 00 00 
  802421:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802424:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80242a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242e:	48 89 c6             	mov    %rax,%rsi
  802431:	bf 01 00 00 00       	mov    $0x1,%edi
  802436:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  80243d:	00 00 00 
  802440:	ff d0                	callq  *%rax
  802442:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802445:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802449:	79 1d                	jns    802468 <open+0xc5>
		fd_close(fd, 0);
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	be 00 00 00 00       	mov    $0x0,%esi
  802454:	48 89 c7             	mov    %rax,%rdi
  802457:	48 b8 2b 1b 80 00 00 	movabs $0x801b2b,%rax
  80245e:	00 00 00 
  802461:	ff d0                	callq  *%rax
		return r;
  802463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802466:	eb 13                	jmp    80247b <open+0xd8>
	}

	return fd2num(fd);
  802468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246c:	48 89 c7             	mov    %rax,%rdi
  80246f:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  802476:	00 00 00 
  802479:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  80247b:	c9                   	leaveq 
  80247c:	c3                   	retq   

000000000080247d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80247d:	55                   	push   %rbp
  80247e:	48 89 e5             	mov    %rsp,%rbp
  802481:	48 83 ec 10          	sub    $0x10,%rsp
  802485:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248d:	8b 50 0c             	mov    0xc(%rax),%edx
  802490:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802497:	00 00 00 
  80249a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80249c:	be 00 00 00 00       	mov    $0x0,%esi
  8024a1:	bf 06 00 00 00       	mov    $0x6,%edi
  8024a6:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
}
  8024b2:	c9                   	leaveq 
  8024b3:	c3                   	retq   

00000000008024b4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8024b4:	55                   	push   %rbp
  8024b5:	48 89 e5             	mov    %rsp,%rbp
  8024b8:	48 83 ec 30          	sub    $0x30,%rsp
  8024bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cc:	8b 50 0c             	mov    0xc(%rax),%edx
  8024cf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024d6:	00 00 00 
  8024d9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8024db:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024e2:	00 00 00 
  8024e5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024e9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8024ed:	be 00 00 00 00       	mov    $0x0,%esi
  8024f2:	bf 03 00 00 00       	mov    $0x3,%edi
  8024f7:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  8024fe:	00 00 00 
  802501:	ff d0                	callq  *%rax
  802503:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802506:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250a:	79 08                	jns    802514 <devfile_read+0x60>
		return r;
  80250c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250f:	e9 a4 00 00 00       	jmpq   8025b8 <devfile_read+0x104>
	assert(r <= n);
  802514:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802517:	48 98                	cltq   
  802519:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80251d:	76 35                	jbe    802554 <devfile_read+0xa0>
  80251f:	48 b9 bd 3b 80 00 00 	movabs $0x803bbd,%rcx
  802526:	00 00 00 
  802529:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  802530:	00 00 00 
  802533:	be 84 00 00 00       	mov    $0x84,%esi
  802538:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  80253f:	00 00 00 
  802542:	b8 00 00 00 00       	mov    $0x0,%eax
  802547:	49 b8 7a 32 80 00 00 	movabs $0x80327a,%r8
  80254e:	00 00 00 
  802551:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802554:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80255b:	7e 35                	jle    802592 <devfile_read+0xde>
  80255d:	48 b9 e4 3b 80 00 00 	movabs $0x803be4,%rcx
  802564:	00 00 00 
  802567:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  80256e:	00 00 00 
  802571:	be 85 00 00 00       	mov    $0x85,%esi
  802576:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  80257d:	00 00 00 
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
  802585:	49 b8 7a 32 80 00 00 	movabs $0x80327a,%r8
  80258c:	00 00 00 
  80258f:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802595:	48 63 d0             	movslq %eax,%rdx
  802598:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8025a3:	00 00 00 
  8025a6:	48 89 c7             	mov    %rax,%rdi
  8025a9:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  8025b0:	00 00 00 
  8025b3:	ff d0                	callq  *%rax
	return r;
  8025b5:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8025b8:	c9                   	leaveq 
  8025b9:	c3                   	retq   

00000000008025ba <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8025ba:	55                   	push   %rbp
  8025bb:	48 89 e5             	mov    %rsp,%rbp
  8025be:	48 83 ec 30          	sub    $0x30,%rsp
  8025c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8025d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025dc:	00 00 00 
  8025df:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8025e1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025e8:	00 00 00 
  8025eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025ef:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8025f3:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8025fa:	00 
  8025fb:	76 35                	jbe    802632 <devfile_write+0x78>
  8025fd:	48 b9 f0 3b 80 00 00 	movabs $0x803bf0,%rcx
  802604:	00 00 00 
  802607:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  80260e:	00 00 00 
  802611:	be 9e 00 00 00       	mov    $0x9e,%esi
  802616:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  80261d:	00 00 00 
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	49 b8 7a 32 80 00 00 	movabs $0x80327a,%r8
  80262c:	00 00 00 
  80262f:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802632:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802636:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263a:	48 89 c6             	mov    %rax,%rsi
  80263d:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802644:	00 00 00 
  802647:	48 b8 54 12 80 00 00 	movabs $0x801254,%rax
  80264e:	00 00 00 
  802651:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802653:	be 00 00 00 00       	mov    $0x0,%esi
  802658:	bf 04 00 00 00       	mov    $0x4,%edi
  80265d:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  802664:	00 00 00 
  802667:	ff d0                	callq  *%rax
  802669:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802670:	79 05                	jns    802677 <devfile_write+0xbd>
		return r;
  802672:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802675:	eb 43                	jmp    8026ba <devfile_write+0x100>
	assert(r <= n);
  802677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267a:	48 98                	cltq   
  80267c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802680:	76 35                	jbe    8026b7 <devfile_write+0xfd>
  802682:	48 b9 bd 3b 80 00 00 	movabs $0x803bbd,%rcx
  802689:	00 00 00 
  80268c:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  802693:	00 00 00 
  802696:	be a2 00 00 00       	mov    $0xa2,%esi
  80269b:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  8026a2:	00 00 00 
  8026a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026aa:	49 b8 7a 32 80 00 00 	movabs $0x80327a,%r8
  8026b1:	00 00 00 
  8026b4:	41 ff d0             	callq  *%r8
	return r;
  8026b7:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8026ba:	c9                   	leaveq 
  8026bb:	c3                   	retq   

00000000008026bc <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026bc:	55                   	push   %rbp
  8026bd:	48 89 e5             	mov    %rsp,%rbp
  8026c0:	48 83 ec 20          	sub    $0x20,%rsp
  8026c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8026cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8026d3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026da:	00 00 00 
  8026dd:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8026df:	be 00 00 00 00       	mov    $0x0,%esi
  8026e4:	bf 05 00 00 00       	mov    $0x5,%edi
  8026e9:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  8026f0:	00 00 00 
  8026f3:	ff d0                	callq  *%rax
  8026f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fc:	79 05                	jns    802703 <devfile_stat+0x47>
		return r;
  8026fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802701:	eb 56                	jmp    802759 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802703:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802707:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80270e:	00 00 00 
  802711:	48 89 c7             	mov    %rax,%rdi
  802714:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802720:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802727:	00 00 00 
  80272a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802734:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80273a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802741:	00 00 00 
  802744:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80274a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80274e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802759:	c9                   	leaveq 
  80275a:	c3                   	retq   

000000000080275b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80275b:	55                   	push   %rbp
  80275c:	48 89 e5             	mov    %rsp,%rbp
  80275f:	48 83 ec 10          	sub    $0x10,%rsp
  802763:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802767:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80276a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80276e:	8b 50 0c             	mov    0xc(%rax),%edx
  802771:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802778:	00 00 00 
  80277b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80277d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802784:	00 00 00 
  802787:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80278a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80278d:	be 00 00 00 00       	mov    $0x0,%esi
  802792:	bf 02 00 00 00       	mov    $0x2,%edi
  802797:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
}
  8027a3:	c9                   	leaveq 
  8027a4:	c3                   	retq   

00000000008027a5 <remove>:

// Delete a file
int
remove(const char *path)
{
  8027a5:	55                   	push   %rbp
  8027a6:	48 89 e5             	mov    %rsp,%rbp
  8027a9:	48 83 ec 10          	sub    $0x10,%rsp
  8027ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8027b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b5:	48 89 c7             	mov    %rax,%rdi
  8027b8:	48 b8 ad 0d 80 00 00 	movabs $0x800dad,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax
  8027c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027c9:	7e 07                	jle    8027d2 <remove+0x2d>
		return -E_BAD_PATH;
  8027cb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027d0:	eb 33                	jmp    802805 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8027d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d6:	48 89 c6             	mov    %rax,%rsi
  8027d9:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8027e0:	00 00 00 
  8027e3:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  8027ea:	00 00 00 
  8027ed:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8027ef:	be 00 00 00 00       	mov    $0x0,%esi
  8027f4:	bf 07 00 00 00       	mov    $0x7,%edi
  8027f9:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
}
  802805:	c9                   	leaveq 
  802806:	c3                   	retq   

0000000000802807 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802807:	55                   	push   %rbp
  802808:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80280b:	be 00 00 00 00       	mov    $0x0,%esi
  802810:	bf 08 00 00 00       	mov    $0x8,%edi
  802815:	48 b8 1c 23 80 00 00 	movabs $0x80231c,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	callq  *%rax
}
  802821:	5d                   	pop    %rbp
  802822:	c3                   	retq   

0000000000802823 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802823:	55                   	push   %rbp
  802824:	48 89 e5             	mov    %rsp,%rbp
  802827:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80282e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802835:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80283c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802843:	be 00 00 00 00       	mov    $0x0,%esi
  802848:	48 89 c7             	mov    %rax,%rdi
  80284b:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  802852:	00 00 00 
  802855:	ff d0                	callq  *%rax
  802857:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80285a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285e:	79 28                	jns    802888 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802863:	89 c6                	mov    %eax,%esi
  802865:	48 bf 1d 3c 80 00 00 	movabs $0x803c1d,%rdi
  80286c:	00 00 00 
  80286f:	b8 00 00 00 00       	mov    $0x0,%eax
  802874:	48 ba 51 02 80 00 00 	movabs $0x800251,%rdx
  80287b:	00 00 00 
  80287e:	ff d2                	callq  *%rdx
		return fd_src;
  802880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802883:	e9 74 01 00 00       	jmpq   8029fc <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802888:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80288f:	be 01 01 00 00       	mov    $0x101,%esi
  802894:	48 89 c7             	mov    %rax,%rdi
  802897:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
  8028a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8028a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028aa:	79 39                	jns    8028e5 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8028ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028af:	89 c6                	mov    %eax,%esi
  8028b1:	48 bf 33 3c 80 00 00 	movabs $0x803c33,%rdi
  8028b8:	00 00 00 
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c0:	48 ba 51 02 80 00 00 	movabs $0x800251,%rdx
  8028c7:	00 00 00 
  8028ca:	ff d2                	callq  *%rdx
		close(fd_src);
  8028cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cf:	89 c7                	mov    %eax,%edi
  8028d1:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
		return fd_dest;
  8028dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028e0:	e9 17 01 00 00       	jmpq   8029fc <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8028e5:	eb 74                	jmp    80295b <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8028e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028ea:	48 63 d0             	movslq %eax,%rdx
  8028ed:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8028f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028f7:	48 89 ce             	mov    %rcx,%rsi
  8028fa:	89 c7                	mov    %eax,%edi
  8028fc:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
  802908:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80290b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80290f:	79 4a                	jns    80295b <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802911:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802914:	89 c6                	mov    %eax,%esi
  802916:	48 bf 4d 3c 80 00 00 	movabs $0x803c4d,%rdi
  80291d:	00 00 00 
  802920:	b8 00 00 00 00       	mov    $0x0,%eax
  802925:	48 ba 51 02 80 00 00 	movabs $0x800251,%rdx
  80292c:	00 00 00 
  80292f:	ff d2                	callq  *%rdx
			close(fd_src);
  802931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802934:	89 c7                	mov    %eax,%edi
  802936:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  80293d:	00 00 00 
  802940:	ff d0                	callq  *%rax
			close(fd_dest);
  802942:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802945:	89 c7                	mov    %eax,%edi
  802947:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  80294e:	00 00 00 
  802951:	ff d0                	callq  *%rax
			return write_size;
  802953:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802956:	e9 a1 00 00 00       	jmpq   8029fc <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80295b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802962:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802965:	ba 00 02 00 00       	mov    $0x200,%edx
  80296a:	48 89 ce             	mov    %rcx,%rsi
  80296d:	89 c7                	mov    %eax,%edi
  80296f:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  802976:	00 00 00 
  802979:	ff d0                	callq  *%rax
  80297b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80297e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802982:	0f 8f 5f ff ff ff    	jg     8028e7 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802988:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80298c:	79 47                	jns    8029d5 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80298e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802991:	89 c6                	mov    %eax,%esi
  802993:	48 bf 60 3c 80 00 00 	movabs $0x803c60,%rdi
  80299a:	00 00 00 
  80299d:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a2:	48 ba 51 02 80 00 00 	movabs $0x800251,%rdx
  8029a9:	00 00 00 
  8029ac:	ff d2                	callq  *%rdx
		close(fd_src);
  8029ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b1:	89 c7                	mov    %eax,%edi
  8029b3:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  8029ba:	00 00 00 
  8029bd:	ff d0                	callq  *%rax
		close(fd_dest);
  8029bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
		return read_size;
  8029d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029d3:	eb 27                	jmp    8029fc <copy+0x1d9>
	}
	close(fd_src);
  8029d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d8:	89 c7                	mov    %eax,%edi
  8029da:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  8029e1:	00 00 00 
  8029e4:	ff d0                	callq  *%rax
	close(fd_dest);
  8029e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029e9:	89 c7                	mov    %eax,%edi
  8029eb:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
	return 0;
  8029f7:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8029fc:	c9                   	leaveq 
  8029fd:	c3                   	retq   

00000000008029fe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8029fe:	55                   	push   %rbp
  8029ff:	48 89 e5             	mov    %rsp,%rbp
  802a02:	53                   	push   %rbx
  802a03:	48 83 ec 38          	sub    $0x38,%rsp
  802a07:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a0b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a0f:	48 89 c7             	mov    %rax,%rdi
  802a12:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
  802a1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a25:	0f 88 bf 01 00 00    	js     802bea <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a2f:	ba 07 04 00 00       	mov    $0x407,%edx
  802a34:	48 89 c6             	mov    %rax,%rsi
  802a37:	bf 00 00 00 00       	mov    $0x0,%edi
  802a3c:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
  802a48:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a4f:	0f 88 95 01 00 00    	js     802bea <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802a55:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802a59:	48 89 c7             	mov    %rax,%rdi
  802a5c:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a6f:	0f 88 5d 01 00 00    	js     802bd2 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a79:	ba 07 04 00 00       	mov    $0x407,%edx
  802a7e:	48 89 c6             	mov    %rax,%rsi
  802a81:	bf 00 00 00 00       	mov    $0x0,%edi
  802a86:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax
  802a92:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a95:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a99:	0f 88 33 01 00 00    	js     802bd2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa3:	48 89 c7             	mov    %rax,%rdi
  802aa6:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  802aad:	00 00 00 
  802ab0:	ff d0                	callq  *%rax
  802ab2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ab6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aba:	ba 07 04 00 00       	mov    $0x407,%edx
  802abf:	48 89 c6             	mov    %rax,%rsi
  802ac2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac7:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	callq  *%rax
  802ad3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ad6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ada:	79 05                	jns    802ae1 <pipe+0xe3>
		goto err2;
  802adc:	e9 d9 00 00 00       	jmpq   802bba <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ae1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ae5:	48 89 c7             	mov    %rax,%rdi
  802ae8:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
  802af4:	48 89 c2             	mov    %rax,%rdx
  802af7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802afb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b01:	48 89 d1             	mov    %rdx,%rcx
  802b04:	ba 00 00 00 00       	mov    $0x0,%edx
  802b09:	48 89 c6             	mov    %rax,%rsi
  802b0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b11:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
  802b1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b20:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b24:	79 1b                	jns    802b41 <pipe+0x143>
		goto err3;
  802b26:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802b27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2b:	48 89 c6             	mov    %rax,%rsi
  802b2e:	bf 00 00 00 00       	mov    $0x0,%edi
  802b33:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
  802b3f:	eb 79                	jmp    802bba <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b45:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b4c:	00 00 00 
  802b4f:	8b 12                	mov    (%rdx),%edx
  802b51:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802b53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b62:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b69:	00 00 00 
  802b6c:	8b 12                	mov    (%rdx),%edx
  802b6e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802b70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b74:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802b7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b7f:	48 89 c7             	mov    %rax,%rdi
  802b82:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
  802b8e:	89 c2                	mov    %eax,%edx
  802b90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b94:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802b96:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b9a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802b9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba2:	48 89 c7             	mov    %rax,%rdi
  802ba5:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  802bac:	00 00 00 
  802baf:	ff d0                	callq  *%rax
  802bb1:	89 03                	mov    %eax,(%rbx)
	return 0;
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	eb 33                	jmp    802bed <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802bba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bbe:	48 89 c6             	mov    %rax,%rsi
  802bc1:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc6:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802bd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bd6:	48 89 c6             	mov    %rax,%rsi
  802bd9:	bf 00 00 00 00       	mov    $0x0,%edi
  802bde:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  802be5:	00 00 00 
  802be8:	ff d0                	callq  *%rax
err:
	return r;
  802bea:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802bed:	48 83 c4 38          	add    $0x38,%rsp
  802bf1:	5b                   	pop    %rbx
  802bf2:	5d                   	pop    %rbp
  802bf3:	c3                   	retq   

0000000000802bf4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802bf4:	55                   	push   %rbp
  802bf5:	48 89 e5             	mov    %rsp,%rbp
  802bf8:	53                   	push   %rbx
  802bf9:	48 83 ec 28          	sub    $0x28,%rsp
  802bfd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c05:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c0c:	00 00 00 
  802c0f:	48 8b 00             	mov    (%rax),%rax
  802c12:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c18:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c1f:	48 89 c7             	mov    %rax,%rdi
  802c22:	48 b8 69 35 80 00 00 	movabs $0x803569,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
  802c2e:	89 c3                	mov    %eax,%ebx
  802c30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c34:	48 89 c7             	mov    %rax,%rdi
  802c37:	48 b8 69 35 80 00 00 	movabs $0x803569,%rax
  802c3e:	00 00 00 
  802c41:	ff d0                	callq  *%rax
  802c43:	39 c3                	cmp    %eax,%ebx
  802c45:	0f 94 c0             	sete   %al
  802c48:	0f b6 c0             	movzbl %al,%eax
  802c4b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802c4e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c55:	00 00 00 
  802c58:	48 8b 00             	mov    (%rax),%rax
  802c5b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c61:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802c64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c67:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c6a:	75 05                	jne    802c71 <_pipeisclosed+0x7d>
			return ret;
  802c6c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c6f:	eb 4f                	jmp    802cc0 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802c71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c74:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c77:	74 42                	je     802cbb <_pipeisclosed+0xc7>
  802c79:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802c7d:	75 3c                	jne    802cbb <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c7f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c86:	00 00 00 
  802c89:	48 8b 00             	mov    (%rax),%rax
  802c8c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802c92:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802c95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c98:	89 c6                	mov    %eax,%esi
  802c9a:	48 bf 7b 3c 80 00 00 	movabs $0x803c7b,%rdi
  802ca1:	00 00 00 
  802ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca9:	49 b8 51 02 80 00 00 	movabs $0x800251,%r8
  802cb0:	00 00 00 
  802cb3:	41 ff d0             	callq  *%r8
	}
  802cb6:	e9 4a ff ff ff       	jmpq   802c05 <_pipeisclosed+0x11>
  802cbb:	e9 45 ff ff ff       	jmpq   802c05 <_pipeisclosed+0x11>
}
  802cc0:	48 83 c4 28          	add    $0x28,%rsp
  802cc4:	5b                   	pop    %rbx
  802cc5:	5d                   	pop    %rbp
  802cc6:	c3                   	retq   

0000000000802cc7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802cc7:	55                   	push   %rbp
  802cc8:	48 89 e5             	mov    %rsp,%rbp
  802ccb:	48 83 ec 30          	sub    $0x30,%rsp
  802ccf:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cd6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cd9:	48 89 d6             	mov    %rdx,%rsi
  802cdc:	89 c7                	mov    %eax,%edi
  802cde:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ced:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf1:	79 05                	jns    802cf8 <pipeisclosed+0x31>
		return r;
  802cf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf6:	eb 31                	jmp    802d29 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfc:	48 89 c7             	mov    %rax,%rdi
  802cff:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  802d06:	00 00 00 
  802d09:	ff d0                	callq  *%rax
  802d0b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d17:	48 89 d6             	mov    %rdx,%rsi
  802d1a:	48 89 c7             	mov    %rax,%rdi
  802d1d:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
}
  802d29:	c9                   	leaveq 
  802d2a:	c3                   	retq   

0000000000802d2b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d2b:	55                   	push   %rbp
  802d2c:	48 89 e5             	mov    %rsp,%rbp
  802d2f:	48 83 ec 40          	sub    $0x40,%rsp
  802d33:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d37:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d3b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d43:	48 89 c7             	mov    %rax,%rdi
  802d46:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
  802d52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802d56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d5e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d65:	00 
  802d66:	e9 92 00 00 00       	jmpq   802dfd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802d6b:	eb 41                	jmp    802dae <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d6d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802d72:	74 09                	je     802d7d <devpipe_read+0x52>
				return i;
  802d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d78:	e9 92 00 00 00       	jmpq   802e0f <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d85:	48 89 d6             	mov    %rdx,%rsi
  802d88:	48 89 c7             	mov    %rax,%rdi
  802d8b:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
  802d97:	85 c0                	test   %eax,%eax
  802d99:	74 07                	je     802da2 <devpipe_read+0x77>
				return 0;
  802d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802da0:	eb 6d                	jmp    802e0f <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802da2:	48 b8 0a 17 80 00 00 	movabs $0x80170a,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802dae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db2:	8b 10                	mov    (%rax),%edx
  802db4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db8:	8b 40 04             	mov    0x4(%rax),%eax
  802dbb:	39 c2                	cmp    %eax,%edx
  802dbd:	74 ae                	je     802d6d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dc7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	8b 00                	mov    (%rax),%eax
  802dd1:	99                   	cltd   
  802dd2:	c1 ea 1b             	shr    $0x1b,%edx
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	83 e0 1f             	and    $0x1f,%eax
  802dda:	29 d0                	sub    %edx,%eax
  802ddc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802de0:	48 98                	cltq   
  802de2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802de7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802de9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ded:	8b 00                	mov    (%rax),%eax
  802def:	8d 50 01             	lea    0x1(%rax),%edx
  802df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802df8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e01:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e05:	0f 82 60 ff ff ff    	jb     802d6b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e0f:	c9                   	leaveq 
  802e10:	c3                   	retq   

0000000000802e11 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e11:	55                   	push   %rbp
  802e12:	48 89 e5             	mov    %rsp,%rbp
  802e15:	48 83 ec 40          	sub    $0x40,%rsp
  802e19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e29:	48 89 c7             	mov    %rax,%rdi
  802e2c:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
  802e38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802e3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802e44:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802e4b:	00 
  802e4c:	e9 8e 00 00 00       	jmpq   802edf <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e51:	eb 31                	jmp    802e84 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802e53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e5b:	48 89 d6             	mov    %rdx,%rsi
  802e5e:	48 89 c7             	mov    %rax,%rdi
  802e61:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802e68:	00 00 00 
  802e6b:	ff d0                	callq  *%rax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 07                	je     802e78 <devpipe_write+0x67>
				return 0;
  802e71:	b8 00 00 00 00       	mov    $0x0,%eax
  802e76:	eb 79                	jmp    802ef1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802e78:	48 b8 0a 17 80 00 00 	movabs $0x80170a,%rax
  802e7f:	00 00 00 
  802e82:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e88:	8b 40 04             	mov    0x4(%rax),%eax
  802e8b:	48 63 d0             	movslq %eax,%rdx
  802e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e92:	8b 00                	mov    (%rax),%eax
  802e94:	48 98                	cltq   
  802e96:	48 83 c0 20          	add    $0x20,%rax
  802e9a:	48 39 c2             	cmp    %rax,%rdx
  802e9d:	73 b4                	jae    802e53 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea3:	8b 40 04             	mov    0x4(%rax),%eax
  802ea6:	99                   	cltd   
  802ea7:	c1 ea 1b             	shr    $0x1b,%edx
  802eaa:	01 d0                	add    %edx,%eax
  802eac:	83 e0 1f             	and    $0x1f,%eax
  802eaf:	29 d0                	sub    %edx,%eax
  802eb1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802eb5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802eb9:	48 01 ca             	add    %rcx,%rdx
  802ebc:	0f b6 0a             	movzbl (%rdx),%ecx
  802ebf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ec3:	48 98                	cltq   
  802ec5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802ec9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecd:	8b 40 04             	mov    0x4(%rax),%eax
  802ed0:	8d 50 01             	lea    0x1(%rax),%edx
  802ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802eda:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802edf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ee7:	0f 82 64 ff ff ff    	jb     802e51 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ef1:	c9                   	leaveq 
  802ef2:	c3                   	retq   

0000000000802ef3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ef3:	55                   	push   %rbp
  802ef4:	48 89 e5             	mov    %rsp,%rbp
  802ef7:	48 83 ec 20          	sub    $0x20,%rsp
  802efb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f07:	48 89 c7             	mov    %rax,%rdi
  802f0a:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
  802f16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f1e:	48 be 8e 3c 80 00 00 	movabs $0x803c8e,%rsi
  802f25:	00 00 00 
  802f28:	48 89 c7             	mov    %rax,%rdi
  802f2b:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  802f32:	00 00 00 
  802f35:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f3b:	8b 50 04             	mov    0x4(%rax),%edx
  802f3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f42:	8b 00                	mov    (%rax),%eax
  802f44:	29 c2                	sub    %eax,%edx
  802f46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f54:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f5b:	00 00 00 
	stat->st_dev = &devpipe;
  802f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f62:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802f69:	00 00 00 
  802f6c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f78:	c9                   	leaveq 
  802f79:	c3                   	retq   

0000000000802f7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802f7a:	55                   	push   %rbp
  802f7b:	48 89 e5             	mov    %rsp,%rbp
  802f7e:	48 83 ec 10          	sub    $0x10,%rsp
  802f82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802f86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8a:	48 89 c6             	mov    %rax,%rsi
  802f8d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f92:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa2:	48 89 c7             	mov    %rax,%rdi
  802fa5:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
  802fb1:	48 89 c6             	mov    %rax,%rsi
  802fb4:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb9:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
}
  802fc5:	c9                   	leaveq 
  802fc6:	c3                   	retq   

0000000000802fc7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802fc7:	55                   	push   %rbp
  802fc8:	48 89 e5             	mov    %rsp,%rbp
  802fcb:	48 83 ec 20          	sub    $0x20,%rsp
  802fcf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802fd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fd5:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802fd8:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802fdc:	be 01 00 00 00       	mov    $0x1,%esi
  802fe1:	48 89 c7             	mov    %rax,%rdi
  802fe4:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  802feb:	00 00 00 
  802fee:	ff d0                	callq  *%rax
}
  802ff0:	c9                   	leaveq 
  802ff1:	c3                   	retq   

0000000000802ff2 <getchar>:

int
getchar(void)
{
  802ff2:	55                   	push   %rbp
  802ff3:	48 89 e5             	mov    %rsp,%rbp
  802ff6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802ffa:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802ffe:	ba 01 00 00 00       	mov    $0x1,%edx
  803003:	48 89 c6             	mov    %rax,%rsi
  803006:	bf 00 00 00 00       	mov    $0x0,%edi
  80300b:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  803012:	00 00 00 
  803015:	ff d0                	callq  *%rax
  803017:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80301a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301e:	79 05                	jns    803025 <getchar+0x33>
		return r;
  803020:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803023:	eb 14                	jmp    803039 <getchar+0x47>
	if (r < 1)
  803025:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803029:	7f 07                	jg     803032 <getchar+0x40>
		return -E_EOF;
  80302b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803030:	eb 07                	jmp    803039 <getchar+0x47>
	return c;
  803032:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803036:	0f b6 c0             	movzbl %al,%eax
}
  803039:	c9                   	leaveq 
  80303a:	c3                   	retq   

000000000080303b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80303b:	55                   	push   %rbp
  80303c:	48 89 e5             	mov    %rsp,%rbp
  80303f:	48 83 ec 20          	sub    $0x20,%rsp
  803043:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803046:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80304a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304d:	48 89 d6             	mov    %rdx,%rsi
  803050:	89 c7                	mov    %eax,%edi
  803052:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  803059:	00 00 00 
  80305c:	ff d0                	callq  *%rax
  80305e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803061:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803065:	79 05                	jns    80306c <iscons+0x31>
		return r;
  803067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306a:	eb 1a                	jmp    803086 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80306c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803070:	8b 10                	mov    (%rax),%edx
  803072:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803079:	00 00 00 
  80307c:	8b 00                	mov    (%rax),%eax
  80307e:	39 c2                	cmp    %eax,%edx
  803080:	0f 94 c0             	sete   %al
  803083:	0f b6 c0             	movzbl %al,%eax
}
  803086:	c9                   	leaveq 
  803087:	c3                   	retq   

0000000000803088 <opencons>:

int
opencons(void)
{
  803088:	55                   	push   %rbp
  803089:	48 89 e5             	mov    %rsp,%rbp
  80308c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803090:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803094:	48 89 c7             	mov    %rax,%rdi
  803097:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	callq  *%rax
  8030a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030aa:	79 05                	jns    8030b1 <opencons+0x29>
		return r;
  8030ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030af:	eb 5b                	jmp    80310c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8030b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b5:	ba 07 04 00 00       	mov    $0x407,%edx
  8030ba:	48 89 c6             	mov    %rax,%rsi
  8030bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c2:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
  8030ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d5:	79 05                	jns    8030dc <opencons+0x54>
		return r;
  8030d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030da:	eb 30                	jmp    80310c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8030dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e0:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8030e7:	00 00 00 
  8030ea:	8b 12                	mov    (%rdx),%edx
  8030ec:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8030ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8030f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fd:	48 89 c7             	mov    %rax,%rdi
  803100:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
}
  80310c:	c9                   	leaveq 
  80310d:	c3                   	retq   

000000000080310e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80310e:	55                   	push   %rbp
  80310f:	48 89 e5             	mov    %rsp,%rbp
  803112:	48 83 ec 30          	sub    $0x30,%rsp
  803116:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80311a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80311e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803122:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803127:	75 07                	jne    803130 <devcons_read+0x22>
		return 0;
  803129:	b8 00 00 00 00       	mov    $0x0,%eax
  80312e:	eb 4b                	jmp    80317b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803130:	eb 0c                	jmp    80313e <devcons_read+0x30>
		sys_yield();
  803132:	48 b8 0a 17 80 00 00 	movabs $0x80170a,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80313e:	48 b8 4a 16 80 00 00 	movabs $0x80164a,%rax
  803145:	00 00 00 
  803148:	ff d0                	callq  *%rax
  80314a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803151:	74 df                	je     803132 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803157:	79 05                	jns    80315e <devcons_read+0x50>
		return c;
  803159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315c:	eb 1d                	jmp    80317b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80315e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803162:	75 07                	jne    80316b <devcons_read+0x5d>
		return 0;
  803164:	b8 00 00 00 00       	mov    $0x0,%eax
  803169:	eb 10                	jmp    80317b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80316b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316e:	89 c2                	mov    %eax,%edx
  803170:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803174:	88 10                	mov    %dl,(%rax)
	return 1;
  803176:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80317b:	c9                   	leaveq 
  80317c:	c3                   	retq   

000000000080317d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80317d:	55                   	push   %rbp
  80317e:	48 89 e5             	mov    %rsp,%rbp
  803181:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803188:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80318f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803196:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80319d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031a4:	eb 76                	jmp    80321c <devcons_write+0x9f>
		m = n - tot;
  8031a6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8031ad:	89 c2                	mov    %eax,%edx
  8031af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b2:	29 c2                	sub    %eax,%edx
  8031b4:	89 d0                	mov    %edx,%eax
  8031b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8031b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031bc:	83 f8 7f             	cmp    $0x7f,%eax
  8031bf:	76 07                	jbe    8031c8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8031c1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8031c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031cb:	48 63 d0             	movslq %eax,%rdx
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	48 63 c8             	movslq %eax,%rcx
  8031d4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8031db:	48 01 c1             	add    %rax,%rcx
  8031de:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8031e5:	48 89 ce             	mov    %rcx,%rsi
  8031e8:	48 89 c7             	mov    %rax,%rdi
  8031eb:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  8031f2:	00 00 00 
  8031f5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8031f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031fa:	48 63 d0             	movslq %eax,%rdx
  8031fd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803204:	48 89 d6             	mov    %rdx,%rsi
  803207:	48 89 c7             	mov    %rax,%rdi
  80320a:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  803211:	00 00 00 
  803214:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803216:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803219:	01 45 fc             	add    %eax,-0x4(%rbp)
  80321c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321f:	48 98                	cltq   
  803221:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803228:	0f 82 78 ff ff ff    	jb     8031a6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80322e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803231:	c9                   	leaveq 
  803232:	c3                   	retq   

0000000000803233 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803233:	55                   	push   %rbp
  803234:	48 89 e5             	mov    %rsp,%rbp
  803237:	48 83 ec 08          	sub    $0x8,%rsp
  80323b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80323f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803244:	c9                   	leaveq 
  803245:	c3                   	retq   

0000000000803246 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803246:	55                   	push   %rbp
  803247:	48 89 e5             	mov    %rsp,%rbp
  80324a:	48 83 ec 10          	sub    $0x10,%rsp
  80324e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803252:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325a:	48 be 9a 3c 80 00 00 	movabs $0x803c9a,%rsi
  803261:	00 00 00 
  803264:	48 89 c7             	mov    %rax,%rdi
  803267:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
	return 0;
  803273:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803278:	c9                   	leaveq 
  803279:	c3                   	retq   

000000000080327a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80327a:	55                   	push   %rbp
  80327b:	48 89 e5             	mov    %rsp,%rbp
  80327e:	53                   	push   %rbx
  80327f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803286:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80328d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803293:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80329a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8032a1:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8032a8:	84 c0                	test   %al,%al
  8032aa:	74 23                	je     8032cf <_panic+0x55>
  8032ac:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8032b3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8032b7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8032bb:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8032bf:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8032c3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8032c7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8032cb:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8032cf:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8032d6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8032dd:	00 00 00 
  8032e0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8032e7:	00 00 00 
  8032ea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032ee:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8032f5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8032fc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803303:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80330a:	00 00 00 
  80330d:	48 8b 18             	mov    (%rax),%rbx
  803310:	48 b8 cc 16 80 00 00 	movabs $0x8016cc,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
  80331c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803322:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803329:	41 89 c8             	mov    %ecx,%r8d
  80332c:	48 89 d1             	mov    %rdx,%rcx
  80332f:	48 89 da             	mov    %rbx,%rdx
  803332:	89 c6                	mov    %eax,%esi
  803334:	48 bf a8 3c 80 00 00 	movabs $0x803ca8,%rdi
  80333b:	00 00 00 
  80333e:	b8 00 00 00 00       	mov    $0x0,%eax
  803343:	49 b9 51 02 80 00 00 	movabs $0x800251,%r9
  80334a:	00 00 00 
  80334d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803350:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803357:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80335e:	48 89 d6             	mov    %rdx,%rsi
  803361:	48 89 c7             	mov    %rax,%rdi
  803364:	48 b8 a5 01 80 00 00 	movabs $0x8001a5,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
	cprintf("\n");
  803370:	48 bf cb 3c 80 00 00 	movabs $0x803ccb,%rdi
  803377:	00 00 00 
  80337a:	b8 00 00 00 00       	mov    $0x0,%eax
  80337f:	48 ba 51 02 80 00 00 	movabs $0x800251,%rdx
  803386:	00 00 00 
  803389:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80338b:	cc                   	int3   
  80338c:	eb fd                	jmp    80338b <_panic+0x111>

000000000080338e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80338e:	55                   	push   %rbp
  80338f:	48 89 e5             	mov    %rsp,%rbp
  803392:	48 83 ec 30          	sub    $0x30,%rsp
  803396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80339a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80339e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8033a2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033a7:	75 0e                	jne    8033b7 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033a9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033b0:	00 00 00 
  8033b3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033bb:	48 89 c7             	mov    %rax,%rdi
  8033be:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
  8033ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d1:	79 27                	jns    8033fa <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033d8:	74 0a                	je     8033e4 <ipc_recv+0x56>
            *from_env_store = 0;
  8033da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033de:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033e9:	74 0a                	je     8033f5 <ipc_recv+0x67>
            *perm_store = 0;
  8033eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ef:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f8:	eb 53                	jmp    80344d <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033fa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ff:	74 19                	je     80341a <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803401:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803408:	00 00 00 
  80340b:	48 8b 00             	mov    (%rax),%rax
  80340e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803418:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80341a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80341f:	74 19                	je     80343a <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803421:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803428:	00 00 00 
  80342b:	48 8b 00             	mov    (%rax),%rax
  80342e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803438:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80343a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803441:	00 00 00 
  803444:	48 8b 00             	mov    (%rax),%rax
  803447:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80344d:	c9                   	leaveq 
  80344e:	c3                   	retq   

000000000080344f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80344f:	55                   	push   %rbp
  803450:	48 89 e5             	mov    %rsp,%rbp
  803453:	48 83 ec 30          	sub    $0x30,%rsp
  803457:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80345a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80345d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803461:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803464:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803469:	75 0e                	jne    803479 <ipc_send+0x2a>
        pg = (void *)UTOP;
  80346b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803472:	00 00 00 
  803475:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803479:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80347c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80347f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803483:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803486:	89 c7                	mov    %eax,%edi
  803488:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803497:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349b:	79 36                	jns    8034d3 <ipc_send+0x84>
  80349d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034a1:	74 30                	je     8034d3 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8034a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a6:	89 c1                	mov    %eax,%ecx
  8034a8:	48 ba cd 3c 80 00 00 	movabs $0x803ccd,%rdx
  8034af:	00 00 00 
  8034b2:	be 49 00 00 00       	mov    $0x49,%esi
  8034b7:	48 bf da 3c 80 00 00 	movabs $0x803cda,%rdi
  8034be:	00 00 00 
  8034c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c6:	49 b8 7a 32 80 00 00 	movabs $0x80327a,%r8
  8034cd:	00 00 00 
  8034d0:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034d3:	48 b8 0a 17 80 00 00 	movabs $0x80170a,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
    } while(r != 0);
  8034df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e3:	75 94                	jne    803479 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034e5:	c9                   	leaveq 
  8034e6:	c3                   	retq   

00000000008034e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034e7:	55                   	push   %rbp
  8034e8:	48 89 e5             	mov    %rsp,%rbp
  8034eb:	48 83 ec 14          	sub    $0x14,%rsp
  8034ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034f9:	eb 5e                	jmp    803559 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034fb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803502:	00 00 00 
  803505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803508:	48 63 d0             	movslq %eax,%rdx
  80350b:	48 89 d0             	mov    %rdx,%rax
  80350e:	48 c1 e0 03          	shl    $0x3,%rax
  803512:	48 01 d0             	add    %rdx,%rax
  803515:	48 c1 e0 05          	shl    $0x5,%rax
  803519:	48 01 c8             	add    %rcx,%rax
  80351c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803522:	8b 00                	mov    (%rax),%eax
  803524:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803527:	75 2c                	jne    803555 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803529:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803530:	00 00 00 
  803533:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803536:	48 63 d0             	movslq %eax,%rdx
  803539:	48 89 d0             	mov    %rdx,%rax
  80353c:	48 c1 e0 03          	shl    $0x3,%rax
  803540:	48 01 d0             	add    %rdx,%rax
  803543:	48 c1 e0 05          	shl    $0x5,%rax
  803547:	48 01 c8             	add    %rcx,%rax
  80354a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803550:	8b 40 08             	mov    0x8(%rax),%eax
  803553:	eb 12                	jmp    803567 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803555:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803559:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803560:	7e 99                	jle    8034fb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803562:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803567:	c9                   	leaveq 
  803568:	c3                   	retq   

0000000000803569 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803569:	55                   	push   %rbp
  80356a:	48 89 e5             	mov    %rsp,%rbp
  80356d:	48 83 ec 18          	sub    $0x18,%rsp
  803571:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803579:	48 c1 e8 15          	shr    $0x15,%rax
  80357d:	48 89 c2             	mov    %rax,%rdx
  803580:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803587:	01 00 00 
  80358a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80358e:	83 e0 01             	and    $0x1,%eax
  803591:	48 85 c0             	test   %rax,%rax
  803594:	75 07                	jne    80359d <pageref+0x34>
		return 0;
  803596:	b8 00 00 00 00       	mov    $0x0,%eax
  80359b:	eb 53                	jmp    8035f0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80359d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a1:	48 c1 e8 0c          	shr    $0xc,%rax
  8035a5:	48 89 c2             	mov    %rax,%rdx
  8035a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035af:	01 00 00 
  8035b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035be:	83 e0 01             	and    $0x1,%eax
  8035c1:	48 85 c0             	test   %rax,%rax
  8035c4:	75 07                	jne    8035cd <pageref+0x64>
		return 0;
  8035c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cb:	eb 23                	jmp    8035f0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8035d5:	48 89 c2             	mov    %rax,%rdx
  8035d8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035df:	00 00 00 
  8035e2:	48 c1 e2 04          	shl    $0x4,%rdx
  8035e6:	48 01 d0             	add    %rdx,%rax
  8035e9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035ed:	0f b7 c0             	movzwl %ax,%eax
}
  8035f0:	c9                   	leaveq 
  8035f1:	c3                   	retq   
