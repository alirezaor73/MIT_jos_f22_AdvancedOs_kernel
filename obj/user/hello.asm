
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
  800052:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 78 02 80 00 00 	movabs $0x800278,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 2e 36 80 00 00 	movabs $0x80362e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 78 02 80 00 00 	movabs $0x800278,%rdx
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
  8000a3:	48 83 ec 20          	sub    $0x20,%rsp
  8000a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8000ae:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8000bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c5:	48 63 d0             	movslq %eax,%rdx
  8000c8:	48 89 d0             	mov    %rdx,%rax
  8000cb:	48 c1 e0 03          	shl    $0x3,%rax
  8000cf:	48 01 d0             	add    %rdx,%rax
  8000d2:	48 c1 e0 05          	shl    $0x5,%rax
  8000d6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000dd:	00 00 00 
  8000e0:	48 01 c2             	add    %rax,%rdx
  8000e3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000ea:	00 00 00 
  8000ed:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000f4:	7e 14                	jle    80010a <libmain+0x6b>
		binaryname = argv[0];
  8000f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fa:	48 8b 10             	mov    (%rax),%rdx
  8000fd:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800104:	00 00 00 
  800107:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80010a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80010e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800111:	48 89 d6             	mov    %rdx,%rsi
  800114:	89 c7                	mov    %eax,%edi
  800116:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011d:	00 00 00 
  800120:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800122:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  800129:	00 00 00 
  80012c:	ff d0                	callq  *%rax
}
  80012e:	c9                   	leaveq 
  80012f:	c3                   	retq   

0000000000800130 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800130:	55                   	push   %rbp
  800131:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800134:	48 b8 1d 1d 80 00 00 	movabs $0x801d1d,%rax
  80013b:	00 00 00 
  80013e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800140:	bf 00 00 00 00       	mov    $0x0,%edi
  800145:	48 b8 af 16 80 00 00 	movabs $0x8016af,%rax
  80014c:	00 00 00 
  80014f:	ff d0                	callq  *%rax
}
  800151:	5d                   	pop    %rbp
  800152:	c3                   	retq   

0000000000800153 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800153:	55                   	push   %rbp
  800154:	48 89 e5             	mov    %rsp,%rbp
  800157:	48 83 ec 10          	sub    $0x10,%rsp
  80015b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800166:	8b 00                	mov    (%rax),%eax
  800168:	8d 48 01             	lea    0x1(%rax),%ecx
  80016b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016f:	89 0a                	mov    %ecx,(%rdx)
  800171:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800174:	89 d1                	mov    %edx,%ecx
  800176:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80017a:	48 98                	cltq   
  80017c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800180:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800184:	8b 00                	mov    (%rax),%eax
  800186:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018b:	75 2c                	jne    8001b9 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80018d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800191:	8b 00                	mov    (%rax),%eax
  800193:	48 98                	cltq   
  800195:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800199:	48 83 c2 08          	add    $0x8,%rdx
  80019d:	48 89 c6             	mov    %rax,%rsi
  8001a0:	48 89 d7             	mov    %rdx,%rdi
  8001a3:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	callq  *%rax
        b->idx = 0;
  8001af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bd:	8b 40 04             	mov    0x4(%rax),%eax
  8001c0:	8d 50 01             	lea    0x1(%rax),%edx
  8001c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001ca:	c9                   	leaveq 
  8001cb:	c3                   	retq   

00000000008001cc <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001d7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001de:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001e5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001ec:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001f3:	48 8b 0a             	mov    (%rdx),%rcx
  8001f6:	48 89 08             	mov    %rcx,(%rax)
  8001f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800201:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800205:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800209:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800210:	00 00 00 
    b.cnt = 0;
  800213:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80021a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80021d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800224:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80022b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800232:	48 89 c6             	mov    %rax,%rsi
  800235:	48 bf 53 01 80 00 00 	movabs $0x800153,%rdi
  80023c:	00 00 00 
  80023f:	48 b8 2b 06 80 00 00 	movabs $0x80062b,%rax
  800246:	00 00 00 
  800249:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80024b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800251:	48 98                	cltq   
  800253:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80025a:	48 83 c2 08          	add    $0x8,%rdx
  80025e:	48 89 c6             	mov    %rax,%rsi
  800261:	48 89 d7             	mov    %rdx,%rdi
  800264:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  80026b:	00 00 00 
  80026e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800270:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800276:	c9                   	leaveq 
  800277:	c3                   	retq   

0000000000800278 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
  80027c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800283:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80028a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800291:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800298:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80029f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002a6:	84 c0                	test   %al,%al
  8002a8:	74 20                	je     8002ca <cprintf+0x52>
  8002aa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002ae:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002b2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002b6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002ba:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002be:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002c2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002c6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002ca:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002d1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002d8:	00 00 00 
  8002db:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002e2:	00 00 00 
  8002e5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002f0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002f7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002fe:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800305:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80030c:	48 8b 0a             	mov    (%rdx),%rcx
  80030f:	48 89 08             	mov    %rcx,(%rax)
  800312:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800316:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80031a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80031e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800322:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800329:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800330:	48 89 d6             	mov    %rdx,%rsi
  800333:	48 89 c7             	mov    %rax,%rdi
  800336:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
  800342:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800348:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80034e:	c9                   	leaveq 
  80034f:	c3                   	retq   

0000000000800350 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800350:	55                   	push   %rbp
  800351:	48 89 e5             	mov    %rsp,%rbp
  800354:	53                   	push   %rbx
  800355:	48 83 ec 38          	sub    $0x38,%rsp
  800359:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80035d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800361:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800365:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800368:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80036c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800370:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800373:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800377:	77 3b                	ja     8003b4 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800379:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800380:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800387:	ba 00 00 00 00       	mov    $0x0,%edx
  80038c:	48 f7 f3             	div    %rbx
  80038f:	48 89 c2             	mov    %rax,%rdx
  800392:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800395:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800398:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80039c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a0:	41 89 f9             	mov    %edi,%r9d
  8003a3:	48 89 c7             	mov    %rax,%rdi
  8003a6:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  8003ad:	00 00 00 
  8003b0:	ff d0                	callq  *%rax
  8003b2:	eb 1e                	jmp    8003d2 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b4:	eb 12                	jmp    8003c8 <printnum+0x78>
			putch(padc, putdat);
  8003b6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003ba:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c1:	48 89 ce             	mov    %rcx,%rsi
  8003c4:	89 d7                	mov    %edx,%edi
  8003c6:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c8:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003cc:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003d0:	7f e4                	jg     8003b6 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003de:	48 f7 f1             	div    %rcx
  8003e1:	48 89 d0             	mov    %rdx,%rax
  8003e4:	48 ba 50 38 80 00 00 	movabs $0x803850,%rdx
  8003eb:	00 00 00 
  8003ee:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003f2:	0f be d0             	movsbl %al,%edx
  8003f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fd:	48 89 ce             	mov    %rcx,%rsi
  800400:	89 d7                	mov    %edx,%edi
  800402:	ff d0                	callq  *%rax
}
  800404:	48 83 c4 38          	add    $0x38,%rsp
  800408:	5b                   	pop    %rbx
  800409:	5d                   	pop    %rbp
  80040a:	c3                   	retq   

000000000080040b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040b:	55                   	push   %rbp
  80040c:	48 89 e5             	mov    %rsp,%rbp
  80040f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800413:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800417:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80041a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80041e:	7e 52                	jle    800472 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800424:	8b 00                	mov    (%rax),%eax
  800426:	83 f8 30             	cmp    $0x30,%eax
  800429:	73 24                	jae    80044f <getuint+0x44>
  80042b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800437:	8b 00                	mov    (%rax),%eax
  800439:	89 c0                	mov    %eax,%eax
  80043b:	48 01 d0             	add    %rdx,%rax
  80043e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800442:	8b 12                	mov    (%rdx),%edx
  800444:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800447:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80044b:	89 0a                	mov    %ecx,(%rdx)
  80044d:	eb 17                	jmp    800466 <getuint+0x5b>
  80044f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800453:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800457:	48 89 d0             	mov    %rdx,%rax
  80045a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80045e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800462:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800466:	48 8b 00             	mov    (%rax),%rax
  800469:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80046d:	e9 a3 00 00 00       	jmpq   800515 <getuint+0x10a>
	else if (lflag)
  800472:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800476:	74 4f                	je     8004c7 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800478:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047c:	8b 00                	mov    (%rax),%eax
  80047e:	83 f8 30             	cmp    $0x30,%eax
  800481:	73 24                	jae    8004a7 <getuint+0x9c>
  800483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800487:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80048b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048f:	8b 00                	mov    (%rax),%eax
  800491:	89 c0                	mov    %eax,%eax
  800493:	48 01 d0             	add    %rdx,%rax
  800496:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049a:	8b 12                	mov    (%rdx),%edx
  80049c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80049f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a3:	89 0a                	mov    %ecx,(%rdx)
  8004a5:	eb 17                	jmp    8004be <getuint+0xb3>
  8004a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004af:	48 89 d0             	mov    %rdx,%rax
  8004b2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004be:	48 8b 00             	mov    (%rax),%rax
  8004c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004c5:	eb 4e                	jmp    800515 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cb:	8b 00                	mov    (%rax),%eax
  8004cd:	83 f8 30             	cmp    $0x30,%eax
  8004d0:	73 24                	jae    8004f6 <getuint+0xeb>
  8004d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004de:	8b 00                	mov    (%rax),%eax
  8004e0:	89 c0                	mov    %eax,%eax
  8004e2:	48 01 d0             	add    %rdx,%rax
  8004e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e9:	8b 12                	mov    (%rdx),%edx
  8004eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f2:	89 0a                	mov    %ecx,(%rdx)
  8004f4:	eb 17                	jmp    80050d <getuint+0x102>
  8004f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fe:	48 89 d0             	mov    %rdx,%rax
  800501:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800509:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050d:	8b 00                	mov    (%rax),%eax
  80050f:	89 c0                	mov    %eax,%eax
  800511:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 1c          	sub    $0x1c,%rsp
  800523:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800527:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80052a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80052e:	7e 52                	jle    800582 <getint+0x67>
		x=va_arg(*ap, long long);
  800530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800534:	8b 00                	mov    (%rax),%eax
  800536:	83 f8 30             	cmp    $0x30,%eax
  800539:	73 24                	jae    80055f <getint+0x44>
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800547:	8b 00                	mov    (%rax),%eax
  800549:	89 c0                	mov    %eax,%eax
  80054b:	48 01 d0             	add    %rdx,%rax
  80054e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800552:	8b 12                	mov    (%rdx),%edx
  800554:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800557:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055b:	89 0a                	mov    %ecx,(%rdx)
  80055d:	eb 17                	jmp    800576 <getint+0x5b>
  80055f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800563:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800567:	48 89 d0             	mov    %rdx,%rax
  80056a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800572:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800576:	48 8b 00             	mov    (%rax),%rax
  800579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057d:	e9 a3 00 00 00       	jmpq   800625 <getint+0x10a>
	else if (lflag)
  800582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800586:	74 4f                	je     8005d7 <getint+0xbc>
		x=va_arg(*ap, long);
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	8b 00                	mov    (%rax),%eax
  80058e:	83 f8 30             	cmp    $0x30,%eax
  800591:	73 24                	jae    8005b7 <getint+0x9c>
  800593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800597:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	8b 00                	mov    (%rax),%eax
  8005a1:	89 c0                	mov    %eax,%eax
  8005a3:	48 01 d0             	add    %rdx,%rax
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	8b 12                	mov    (%rdx),%edx
  8005ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	89 0a                	mov    %ecx,(%rdx)
  8005b5:	eb 17                	jmp    8005ce <getint+0xb3>
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005bf:	48 89 d0             	mov    %rdx,%rax
  8005c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ce:	48 8b 00             	mov    (%rax),%rax
  8005d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d5:	eb 4e                	jmp    800625 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	83 f8 30             	cmp    $0x30,%eax
  8005e0:	73 24                	jae    800606 <getint+0xeb>
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	89 c0                	mov    %eax,%eax
  8005f2:	48 01 d0             	add    %rdx,%rax
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	8b 12                	mov    (%rdx),%edx
  8005fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	89 0a                	mov    %ecx,(%rdx)
  800604:	eb 17                	jmp    80061d <getint+0x102>
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060e:	48 89 d0             	mov    %rdx,%rax
  800611:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	48 98                	cltq   
  800621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800629:	c9                   	leaveq 
  80062a:	c3                   	retq   

000000000080062b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062b:	55                   	push   %rbp
  80062c:	48 89 e5             	mov    %rsp,%rbp
  80062f:	41 54                	push   %r12
  800631:	53                   	push   %rbx
  800632:	48 83 ec 60          	sub    $0x60,%rsp
  800636:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80063a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80063e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800642:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800646:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80064a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80064e:	48 8b 0a             	mov    (%rdx),%rcx
  800651:	48 89 08             	mov    %rcx,(%rax)
  800654:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800658:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80065c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800660:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800664:	eb 17                	jmp    80067d <vprintfmt+0x52>
			if (ch == '\0')
  800666:	85 db                	test   %ebx,%ebx
  800668:	0f 84 df 04 00 00    	je     800b4d <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80066e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800672:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800676:	48 89 d6             	mov    %rdx,%rsi
  800679:	89 df                	mov    %ebx,%edi
  80067b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800681:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800685:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800689:	0f b6 00             	movzbl (%rax),%eax
  80068c:	0f b6 d8             	movzbl %al,%ebx
  80068f:	83 fb 25             	cmp    $0x25,%ebx
  800692:	75 d2                	jne    800666 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800694:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800698:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80069f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006ad:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006bc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c0:	0f b6 00             	movzbl (%rax),%eax
  8006c3:	0f b6 d8             	movzbl %al,%ebx
  8006c6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006c9:	83 f8 55             	cmp    $0x55,%eax
  8006cc:	0f 87 47 04 00 00    	ja     800b19 <vprintfmt+0x4ee>
  8006d2:	89 c0                	mov    %eax,%eax
  8006d4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006db:	00 
  8006dc:	48 b8 78 38 80 00 00 	movabs $0x803878,%rax
  8006e3:	00 00 00 
  8006e6:	48 01 d0             	add    %rdx,%rax
  8006e9:	48 8b 00             	mov    (%rax),%rax
  8006ec:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006ee:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006f2:	eb c0                	jmp    8006b4 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006f4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006f8:	eb ba                	jmp    8006b4 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006fa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800701:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800704:	89 d0                	mov    %edx,%eax
  800706:	c1 e0 02             	shl    $0x2,%eax
  800709:	01 d0                	add    %edx,%eax
  80070b:	01 c0                	add    %eax,%eax
  80070d:	01 d8                	add    %ebx,%eax
  80070f:	83 e8 30             	sub    $0x30,%eax
  800712:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800715:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800719:	0f b6 00             	movzbl (%rax),%eax
  80071c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80071f:	83 fb 2f             	cmp    $0x2f,%ebx
  800722:	7e 0c                	jle    800730 <vprintfmt+0x105>
  800724:	83 fb 39             	cmp    $0x39,%ebx
  800727:	7f 07                	jg     800730 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800729:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80072e:	eb d1                	jmp    800701 <vprintfmt+0xd6>
			goto process_precision;
  800730:	eb 58                	jmp    80078a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800732:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800735:	83 f8 30             	cmp    $0x30,%eax
  800738:	73 17                	jae    800751 <vprintfmt+0x126>
  80073a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80073e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800741:	89 c0                	mov    %eax,%eax
  800743:	48 01 d0             	add    %rdx,%rax
  800746:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800749:	83 c2 08             	add    $0x8,%edx
  80074c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80074f:	eb 0f                	jmp    800760 <vprintfmt+0x135>
  800751:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800755:	48 89 d0             	mov    %rdx,%rax
  800758:	48 83 c2 08          	add    $0x8,%rdx
  80075c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800760:	8b 00                	mov    (%rax),%eax
  800762:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800765:	eb 23                	jmp    80078a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800767:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80076b:	79 0c                	jns    800779 <vprintfmt+0x14e>
				width = 0;
  80076d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800774:	e9 3b ff ff ff       	jmpq   8006b4 <vprintfmt+0x89>
  800779:	e9 36 ff ff ff       	jmpq   8006b4 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80077e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800785:	e9 2a ff ff ff       	jmpq   8006b4 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80078a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80078e:	79 12                	jns    8007a2 <vprintfmt+0x177>
				width = precision, precision = -1;
  800790:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800793:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800796:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80079d:	e9 12 ff ff ff       	jmpq   8006b4 <vprintfmt+0x89>
  8007a2:	e9 0d ff ff ff       	jmpq   8006b4 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a7:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007ab:	e9 04 ff ff ff       	jmpq   8006b4 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b3:	83 f8 30             	cmp    $0x30,%eax
  8007b6:	73 17                	jae    8007cf <vprintfmt+0x1a4>
  8007b8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007bf:	89 c0                	mov    %eax,%eax
  8007c1:	48 01 d0             	add    %rdx,%rax
  8007c4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c7:	83 c2 08             	add    $0x8,%edx
  8007ca:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007cd:	eb 0f                	jmp    8007de <vprintfmt+0x1b3>
  8007cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d3:	48 89 d0             	mov    %rdx,%rax
  8007d6:	48 83 c2 08          	add    $0x8,%rdx
  8007da:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007de:	8b 10                	mov    (%rax),%edx
  8007e0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e8:	48 89 ce             	mov    %rcx,%rsi
  8007eb:	89 d7                	mov    %edx,%edi
  8007ed:	ff d0                	callq  *%rax
			break;
  8007ef:	e9 53 03 00 00       	jmpq   800b47 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f7:	83 f8 30             	cmp    $0x30,%eax
  8007fa:	73 17                	jae    800813 <vprintfmt+0x1e8>
  8007fc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800800:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800803:	89 c0                	mov    %eax,%eax
  800805:	48 01 d0             	add    %rdx,%rax
  800808:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80080b:	83 c2 08             	add    $0x8,%edx
  80080e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800811:	eb 0f                	jmp    800822 <vprintfmt+0x1f7>
  800813:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800817:	48 89 d0             	mov    %rdx,%rax
  80081a:	48 83 c2 08          	add    $0x8,%rdx
  80081e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800822:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800824:	85 db                	test   %ebx,%ebx
  800826:	79 02                	jns    80082a <vprintfmt+0x1ff>
				err = -err;
  800828:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80082a:	83 fb 15             	cmp    $0x15,%ebx
  80082d:	7f 16                	jg     800845 <vprintfmt+0x21a>
  80082f:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  800836:	00 00 00 
  800839:	48 63 d3             	movslq %ebx,%rdx
  80083c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800840:	4d 85 e4             	test   %r12,%r12
  800843:	75 2e                	jne    800873 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800845:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800849:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80084d:	89 d9                	mov    %ebx,%ecx
  80084f:	48 ba 61 38 80 00 00 	movabs $0x803861,%rdx
  800856:	00 00 00 
  800859:	48 89 c7             	mov    %rax,%rdi
  80085c:	b8 00 00 00 00       	mov    $0x0,%eax
  800861:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  800868:	00 00 00 
  80086b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086e:	e9 d4 02 00 00       	jmpq   800b47 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800873:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800877:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087b:	4c 89 e1             	mov    %r12,%rcx
  80087e:	48 ba 6a 38 80 00 00 	movabs $0x80386a,%rdx
  800885:	00 00 00 
  800888:	48 89 c7             	mov    %rax,%rdi
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
  800890:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  800897:	00 00 00 
  80089a:	41 ff d0             	callq  *%r8
			break;
  80089d:	e9 a5 02 00 00       	jmpq   800b47 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a5:	83 f8 30             	cmp    $0x30,%eax
  8008a8:	73 17                	jae    8008c1 <vprintfmt+0x296>
  8008aa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b1:	89 c0                	mov    %eax,%eax
  8008b3:	48 01 d0             	add    %rdx,%rax
  8008b6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b9:	83 c2 08             	add    $0x8,%edx
  8008bc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008bf:	eb 0f                	jmp    8008d0 <vprintfmt+0x2a5>
  8008c1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c5:	48 89 d0             	mov    %rdx,%rax
  8008c8:	48 83 c2 08          	add    $0x8,%rdx
  8008cc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008d0:	4c 8b 20             	mov    (%rax),%r12
  8008d3:	4d 85 e4             	test   %r12,%r12
  8008d6:	75 0a                	jne    8008e2 <vprintfmt+0x2b7>
				p = "(null)";
  8008d8:	49 bc 6d 38 80 00 00 	movabs $0x80386d,%r12
  8008df:	00 00 00 
			if (width > 0 && padc != '-')
  8008e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e6:	7e 3f                	jle    800927 <vprintfmt+0x2fc>
  8008e8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008ec:	74 39                	je     800927 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ee:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008f1:	48 98                	cltq   
  8008f3:	48 89 c6             	mov    %rax,%rsi
  8008f6:	4c 89 e7             	mov    %r12,%rdi
  8008f9:	48 b8 02 0e 80 00 00 	movabs $0x800e02,%rax
  800900:	00 00 00 
  800903:	ff d0                	callq  *%rax
  800905:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800908:	eb 17                	jmp    800921 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80090a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80090e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800912:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800916:	48 89 ce             	mov    %rcx,%rsi
  800919:	89 d7                	mov    %edx,%edi
  80091b:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800921:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800925:	7f e3                	jg     80090a <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 37                	jmp    800960 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80092d:	74 1e                	je     80094d <vprintfmt+0x322>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x30e>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 14                	jle    80094d <vprintfmt+0x322>
					putch('?', putdat);
  800939:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80093d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800941:	48 89 d6             	mov    %rdx,%rsi
  800944:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800949:	ff d0                	callq  *%rax
  80094b:	eb 0f                	jmp    80095c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80094d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800951:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800955:	48 89 d6             	mov    %rdx,%rsi
  800958:	89 df                	mov    %ebx,%edi
  80095a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800960:	4c 89 e0             	mov    %r12,%rax
  800963:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800967:	0f b6 00             	movzbl (%rax),%eax
  80096a:	0f be d8             	movsbl %al,%ebx
  80096d:	85 db                	test   %ebx,%ebx
  80096f:	74 10                	je     800981 <vprintfmt+0x356>
  800971:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800975:	78 b2                	js     800929 <vprintfmt+0x2fe>
  800977:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80097b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80097f:	79 a8                	jns    800929 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 16                	jmp    800999 <vprintfmt+0x36e>
				putch(' ', putdat);
  800983:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800987:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098b:	48 89 d6             	mov    %rdx,%rsi
  80098e:	bf 20 00 00 00       	mov    $0x20,%edi
  800993:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099d:	7f e4                	jg     800983 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80099f:	e9 a3 01 00 00       	jmpq   800b47 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009a4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009a8:	be 03 00 00 00       	mov    $0x3,%esi
  8009ad:	48 89 c7             	mov    %rax,%rdi
  8009b0:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  8009b7:	00 00 00 
  8009ba:	ff d0                	callq  *%rax
  8009bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 85 c0             	test   %rax,%rax
  8009c7:	79 1d                	jns    8009e6 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d1:	48 89 d6             	mov    %rdx,%rsi
  8009d4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009d9:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009df:	48 f7 d8             	neg    %rax
  8009e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009e6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009ed:	e9 e8 00 00 00       	jmpq   800ada <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009f2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f6:	be 03 00 00 00       	mov    $0x3,%esi
  8009fb:	48 89 c7             	mov    %rax,%rdi
  8009fe:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  800a05:	00 00 00 
  800a08:	ff d0                	callq  *%rax
  800a0a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a0e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a15:	e9 c0 00 00 00       	jmpq   800ada <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a1a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a22:	48 89 d6             	mov    %rdx,%rsi
  800a25:	bf 58 00 00 00       	mov    $0x58,%edi
  800a2a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a34:	48 89 d6             	mov    %rdx,%rsi
  800a37:	bf 58 00 00 00       	mov    $0x58,%edi
  800a3c:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a46:	48 89 d6             	mov    %rdx,%rsi
  800a49:	bf 58 00 00 00       	mov    $0x58,%edi
  800a4e:	ff d0                	callq  *%rax
			break;
  800a50:	e9 f2 00 00 00       	jmpq   800b47 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5d:	48 89 d6             	mov    %rdx,%rsi
  800a60:	bf 30 00 00 00       	mov    $0x30,%edi
  800a65:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6f:	48 89 d6             	mov    %rdx,%rsi
  800a72:	bf 78 00 00 00       	mov    $0x78,%edi
  800a77:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	83 f8 30             	cmp    $0x30,%eax
  800a7f:	73 17                	jae    800a98 <vprintfmt+0x46d>
  800a81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a88:	89 c0                	mov    %eax,%eax
  800a8a:	48 01 d0             	add    %rdx,%rax
  800a8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a90:	83 c2 08             	add    $0x8,%edx
  800a93:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a96:	eb 0f                	jmp    800aa7 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a9c:	48 89 d0             	mov    %rdx,%rax
  800a9f:	48 83 c2 08          	add    $0x8,%rdx
  800aa3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aa7:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aaa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800aae:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ab7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abb:	be 03 00 00 00       	mov    $0x3,%esi
  800ac0:	48 89 c7             	mov    %rax,%rdi
  800ac3:	48 b8 0b 04 80 00 00 	movabs $0x80040b,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ad3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800adf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ae2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ae5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af1:	45 89 c1             	mov    %r8d,%r9d
  800af4:	41 89 f8             	mov    %edi,%r8d
  800af7:	48 89 c7             	mov    %rax,%rdi
  800afa:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  800b01:	00 00 00 
  800b04:	ff d0                	callq  *%rax
			break;
  800b06:	eb 3f                	jmp    800b47 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b10:	48 89 d6             	mov    %rdx,%rsi
  800b13:	89 df                	mov    %ebx,%edi
  800b15:	ff d0                	callq  *%rax
			break;
  800b17:	eb 2e                	jmp    800b47 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b21:	48 89 d6             	mov    %rdx,%rsi
  800b24:	bf 25 00 00 00       	mov    $0x25,%edi
  800b29:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b2b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b30:	eb 05                	jmp    800b37 <vprintfmt+0x50c>
  800b32:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b37:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b3b:	48 83 e8 01          	sub    $0x1,%rax
  800b3f:	0f b6 00             	movzbl (%rax),%eax
  800b42:	3c 25                	cmp    $0x25,%al
  800b44:	75 ec                	jne    800b32 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b46:	90                   	nop
		}
	}
  800b47:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b48:	e9 30 fb ff ff       	jmpq   80067d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b4d:	48 83 c4 60          	add    $0x60,%rsp
  800b51:	5b                   	pop    %rbx
  800b52:	41 5c                	pop    %r12
  800b54:	5d                   	pop    %rbp
  800b55:	c3                   	retq   

0000000000800b56 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b56:	55                   	push   %rbp
  800b57:	48 89 e5             	mov    %rsp,%rbp
  800b5a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b61:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b68:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b6f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b76:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b7d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b84:	84 c0                	test   %al,%al
  800b86:	74 20                	je     800ba8 <printfmt+0x52>
  800b88:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b8c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b90:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b94:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b98:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b9c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ba0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ba4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ba8:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800baf:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bb6:	00 00 00 
  800bb9:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bc0:	00 00 00 
  800bc3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bc7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bce:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bd5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bdc:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800be3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bea:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bf1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bf8:	48 89 c7             	mov    %rax,%rdi
  800bfb:	48 b8 2b 06 80 00 00 	movabs $0x80062b,%rax
  800c02:	00 00 00 
  800c05:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c07:	c9                   	leaveq 
  800c08:	c3                   	retq   

0000000000800c09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c09:	55                   	push   %rbp
  800c0a:	48 89 e5             	mov    %rsp,%rbp
  800c0d:	48 83 ec 10          	sub    $0x10,%rsp
  800c11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1c:	8b 40 10             	mov    0x10(%rax),%eax
  800c1f:	8d 50 01             	lea    0x1(%rax),%edx
  800c22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c26:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2d:	48 8b 10             	mov    (%rax),%rdx
  800c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c34:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c38:	48 39 c2             	cmp    %rax,%rdx
  800c3b:	73 17                	jae    800c54 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c41:	48 8b 00             	mov    (%rax),%rax
  800c44:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c4c:	48 89 0a             	mov    %rcx,(%rdx)
  800c4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c52:	88 10                	mov    %dl,(%rax)
}
  800c54:	c9                   	leaveq 
  800c55:	c3                   	retq   

0000000000800c56 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c56:	55                   	push   %rbp
  800c57:	48 89 e5             	mov    %rsp,%rbp
  800c5a:	48 83 ec 50          	sub    $0x50,%rsp
  800c5e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c62:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c65:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c69:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c6d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c71:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c75:	48 8b 0a             	mov    (%rdx),%rcx
  800c78:	48 89 08             	mov    %rcx,(%rax)
  800c7b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c7f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c83:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c87:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c8b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c8f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c93:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c96:	48 98                	cltq   
  800c98:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c9c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ca0:	48 01 d0             	add    %rdx,%rax
  800ca3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ca7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cae:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cb3:	74 06                	je     800cbb <vsnprintf+0x65>
  800cb5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cb9:	7f 07                	jg     800cc2 <vsnprintf+0x6c>
		return -E_INVAL;
  800cbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cc0:	eb 2f                	jmp    800cf1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cc2:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cc6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cca:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cce:	48 89 c6             	mov    %rax,%rsi
  800cd1:	48 bf 09 0c 80 00 00 	movabs $0x800c09,%rdi
  800cd8:	00 00 00 
  800cdb:	48 b8 2b 06 80 00 00 	movabs $0x80062b,%rax
  800ce2:	00 00 00 
  800ce5:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ce7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ceb:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cee:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cf1:	c9                   	leaveq 
  800cf2:	c3                   	retq   

0000000000800cf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cf3:	55                   	push   %rbp
  800cf4:	48 89 e5             	mov    %rsp,%rbp
  800cf7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cfe:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d05:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d0b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d12:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d19:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d20:	84 c0                	test   %al,%al
  800d22:	74 20                	je     800d44 <snprintf+0x51>
  800d24:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d28:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d2c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d30:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d34:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d38:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d3c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d40:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d44:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d4b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d52:	00 00 00 
  800d55:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d5c:	00 00 00 
  800d5f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d63:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d6a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d71:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d78:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d7f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d86:	48 8b 0a             	mov    (%rdx),%rcx
  800d89:	48 89 08             	mov    %rcx,(%rax)
  800d8c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d90:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d94:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d98:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d9c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800da3:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800daa:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800db0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800db7:	48 89 c7             	mov    %rax,%rdi
  800dba:	48 b8 56 0c 80 00 00 	movabs $0x800c56,%rax
  800dc1:	00 00 00 
  800dc4:	ff d0                	callq  *%rax
  800dc6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dcc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dd2:	c9                   	leaveq 
  800dd3:	c3                   	retq   

0000000000800dd4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dd4:	55                   	push   %rbp
  800dd5:	48 89 e5             	mov    %rsp,%rbp
  800dd8:	48 83 ec 18          	sub    $0x18,%rsp
  800ddc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800de0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800de7:	eb 09                	jmp    800df2 <strlen+0x1e>
		n++;
  800de9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ded:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800df2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df6:	0f b6 00             	movzbl (%rax),%eax
  800df9:	84 c0                	test   %al,%al
  800dfb:	75 ec                	jne    800de9 <strlen+0x15>
		n++;
	return n;
  800dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e00:	c9                   	leaveq 
  800e01:	c3                   	retq   

0000000000800e02 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e02:	55                   	push   %rbp
  800e03:	48 89 e5             	mov    %rsp,%rbp
  800e06:	48 83 ec 20          	sub    $0x20,%rsp
  800e0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e19:	eb 0e                	jmp    800e29 <strnlen+0x27>
		n++;
  800e1b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e24:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e29:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e2e:	74 0b                	je     800e3b <strnlen+0x39>
  800e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e34:	0f b6 00             	movzbl (%rax),%eax
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e0                	jne    800e1b <strnlen+0x19>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e3e:	c9                   	leaveq 
  800e3f:	c3                   	retq   

0000000000800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %rbp
  800e41:	48 89 e5             	mov    %rsp,%rbp
  800e44:	48 83 ec 20          	sub    $0x20,%rsp
  800e48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e58:	90                   	nop
  800e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e61:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e65:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e69:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e6d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e71:	0f b6 12             	movzbl (%rdx),%edx
  800e74:	88 10                	mov    %dl,(%rax)
  800e76:	0f b6 00             	movzbl (%rax),%eax
  800e79:	84 c0                	test   %al,%al
  800e7b:	75 dc                	jne    800e59 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e81:	c9                   	leaveq 
  800e82:	c3                   	retq   

0000000000800e83 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e83:	55                   	push   %rbp
  800e84:	48 89 e5             	mov    %rsp,%rbp
  800e87:	48 83 ec 20          	sub    $0x20,%rsp
  800e8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e97:	48 89 c7             	mov    %rax,%rdi
  800e9a:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eac:	48 63 d0             	movslq %eax,%rdx
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb3:	48 01 c2             	add    %rax,%rdx
  800eb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eba:	48 89 c6             	mov    %rax,%rsi
  800ebd:	48 89 d7             	mov    %rdx,%rdi
  800ec0:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  800ec7:	00 00 00 
  800eca:	ff d0                	callq  *%rax
	return dst;
  800ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ed0:	c9                   	leaveq 
  800ed1:	c3                   	retq   

0000000000800ed2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ed2:	55                   	push   %rbp
  800ed3:	48 89 e5             	mov    %rsp,%rbp
  800ed6:	48 83 ec 28          	sub    $0x28,%rsp
  800eda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ede:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ee2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800eee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ef5:	00 
  800ef6:	eb 2a                	jmp    800f22 <strncpy+0x50>
		*dst++ = *src;
  800ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f00:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f04:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f08:	0f b6 12             	movzbl (%rdx),%edx
  800f0b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f11:	0f b6 00             	movzbl (%rax),%eax
  800f14:	84 c0                	test   %al,%al
  800f16:	74 05                	je     800f1d <strncpy+0x4b>
			src++;
  800f18:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f1d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f26:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f2a:	72 cc                	jb     800ef8 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f30:	c9                   	leaveq 
  800f31:	c3                   	retq   

0000000000800f32 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f32:	55                   	push   %rbp
  800f33:	48 89 e5             	mov    %rsp,%rbp
  800f36:	48 83 ec 28          	sub    $0x28,%rsp
  800f3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f42:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f4e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f53:	74 3d                	je     800f92 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f55:	eb 1d                	jmp    800f74 <strlcpy+0x42>
			*dst++ = *src++;
  800f57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f5f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f63:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f67:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f6b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f6f:	0f b6 12             	movzbl (%rdx),%edx
  800f72:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f74:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f79:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f7e:	74 0b                	je     800f8b <strlcpy+0x59>
  800f80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f84:	0f b6 00             	movzbl (%rax),%eax
  800f87:	84 c0                	test   %al,%al
  800f89:	75 cc                	jne    800f57 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f9a:	48 29 c2             	sub    %rax,%rdx
  800f9d:	48 89 d0             	mov    %rdx,%rax
}
  800fa0:	c9                   	leaveq 
  800fa1:	c3                   	retq   

0000000000800fa2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa2:	55                   	push   %rbp
  800fa3:	48 89 e5             	mov    %rsp,%rbp
  800fa6:	48 83 ec 10          	sub    $0x10,%rsp
  800faa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fb2:	eb 0a                	jmp    800fbe <strcmp+0x1c>
		p++, q++;
  800fb4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc2:	0f b6 00             	movzbl (%rax),%eax
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 12                	je     800fdb <strcmp+0x39>
  800fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fcd:	0f b6 10             	movzbl (%rax),%edx
  800fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd4:	0f b6 00             	movzbl (%rax),%eax
  800fd7:	38 c2                	cmp    %al,%dl
  800fd9:	74 d9                	je     800fb4 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fdf:	0f b6 00             	movzbl (%rax),%eax
  800fe2:	0f b6 d0             	movzbl %al,%edx
  800fe5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe9:	0f b6 00             	movzbl (%rax),%eax
  800fec:	0f b6 c0             	movzbl %al,%eax
  800fef:	29 c2                	sub    %eax,%edx
  800ff1:	89 d0                	mov    %edx,%eax
}
  800ff3:	c9                   	leaveq 
  800ff4:	c3                   	retq   

0000000000800ff5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ff5:	55                   	push   %rbp
  800ff6:	48 89 e5             	mov    %rsp,%rbp
  800ff9:	48 83 ec 18          	sub    $0x18,%rsp
  800ffd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801001:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801005:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801009:	eb 0f                	jmp    80101a <strncmp+0x25>
		n--, p++, q++;
  80100b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801010:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801015:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80101a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80101f:	74 1d                	je     80103e <strncmp+0x49>
  801021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801025:	0f b6 00             	movzbl (%rax),%eax
  801028:	84 c0                	test   %al,%al
  80102a:	74 12                	je     80103e <strncmp+0x49>
  80102c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801030:	0f b6 10             	movzbl (%rax),%edx
  801033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801037:	0f b6 00             	movzbl (%rax),%eax
  80103a:	38 c2                	cmp    %al,%dl
  80103c:	74 cd                	je     80100b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80103e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801043:	75 07                	jne    80104c <strncmp+0x57>
		return 0;
  801045:	b8 00 00 00 00       	mov    $0x0,%eax
  80104a:	eb 18                	jmp    801064 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80104c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801050:	0f b6 00             	movzbl (%rax),%eax
  801053:	0f b6 d0             	movzbl %al,%edx
  801056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105a:	0f b6 00             	movzbl (%rax),%eax
  80105d:	0f b6 c0             	movzbl %al,%eax
  801060:	29 c2                	sub    %eax,%edx
  801062:	89 d0                	mov    %edx,%eax
}
  801064:	c9                   	leaveq 
  801065:	c3                   	retq   

0000000000801066 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	48 83 ec 0c          	sub    $0xc,%rsp
  80106e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801072:	89 f0                	mov    %esi,%eax
  801074:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801077:	eb 17                	jmp    801090 <strchr+0x2a>
		if (*s == c)
  801079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107d:	0f b6 00             	movzbl (%rax),%eax
  801080:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801083:	75 06                	jne    80108b <strchr+0x25>
			return (char *) s;
  801085:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801089:	eb 15                	jmp    8010a0 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80108b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801090:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801094:	0f b6 00             	movzbl (%rax),%eax
  801097:	84 c0                	test   %al,%al
  801099:	75 de                	jne    801079 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80109b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a0:	c9                   	leaveq 
  8010a1:	c3                   	retq   

00000000008010a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a2:	55                   	push   %rbp
  8010a3:	48 89 e5             	mov    %rsp,%rbp
  8010a6:	48 83 ec 0c          	sub    $0xc,%rsp
  8010aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ae:	89 f0                	mov    %esi,%eax
  8010b0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010b3:	eb 13                	jmp    8010c8 <strfind+0x26>
		if (*s == c)
  8010b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010bf:	75 02                	jne    8010c3 <strfind+0x21>
			break;
  8010c1:	eb 10                	jmp    8010d3 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cc:	0f b6 00             	movzbl (%rax),%eax
  8010cf:	84 c0                	test   %al,%al
  8010d1:	75 e2                	jne    8010b5 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d7:	c9                   	leaveq 
  8010d8:	c3                   	retq   

00000000008010d9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010d9:	55                   	push   %rbp
  8010da:	48 89 e5             	mov    %rsp,%rbp
  8010dd:	48 83 ec 18          	sub    $0x18,%rsp
  8010e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e5:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010f1:	75 06                	jne    8010f9 <memset+0x20>
		return v;
  8010f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f7:	eb 69                	jmp    801162 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fd:	83 e0 03             	and    $0x3,%eax
  801100:	48 85 c0             	test   %rax,%rax
  801103:	75 48                	jne    80114d <memset+0x74>
  801105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801109:	83 e0 03             	and    $0x3,%eax
  80110c:	48 85 c0             	test   %rax,%rax
  80110f:	75 3c                	jne    80114d <memset+0x74>
		c &= 0xFF;
  801111:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801118:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80111b:	c1 e0 18             	shl    $0x18,%eax
  80111e:	89 c2                	mov    %eax,%edx
  801120:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801123:	c1 e0 10             	shl    $0x10,%eax
  801126:	09 c2                	or     %eax,%edx
  801128:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80112b:	c1 e0 08             	shl    $0x8,%eax
  80112e:	09 d0                	or     %edx,%eax
  801130:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801137:	48 c1 e8 02          	shr    $0x2,%rax
  80113b:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80113e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801142:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801145:	48 89 d7             	mov    %rdx,%rdi
  801148:	fc                   	cld    
  801149:	f3 ab                	rep stos %eax,%es:(%rdi)
  80114b:	eb 11                	jmp    80115e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80114d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801154:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801158:	48 89 d7             	mov    %rdx,%rdi
  80115b:	fc                   	cld    
  80115c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80115e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801162:	c9                   	leaveq 
  801163:	c3                   	retq   

0000000000801164 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801164:	55                   	push   %rbp
  801165:	48 89 e5             	mov    %rsp,%rbp
  801168:	48 83 ec 28          	sub    $0x28,%rsp
  80116c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801170:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801174:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801178:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80117c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801184:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801190:	0f 83 88 00 00 00    	jae    80121e <memmove+0xba>
  801196:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80119e:	48 01 d0             	add    %rdx,%rax
  8011a1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011a5:	76 77                	jbe    80121e <memmove+0xba>
		s += n;
  8011a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ab:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b3:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bb:	83 e0 03             	and    $0x3,%eax
  8011be:	48 85 c0             	test   %rax,%rax
  8011c1:	75 3b                	jne    8011fe <memmove+0x9a>
  8011c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c7:	83 e0 03             	and    $0x3,%eax
  8011ca:	48 85 c0             	test   %rax,%rax
  8011cd:	75 2f                	jne    8011fe <memmove+0x9a>
  8011cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d3:	83 e0 03             	and    $0x3,%eax
  8011d6:	48 85 c0             	test   %rax,%rax
  8011d9:	75 23                	jne    8011fe <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011df:	48 83 e8 04          	sub    $0x4,%rax
  8011e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e7:	48 83 ea 04          	sub    $0x4,%rdx
  8011eb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011ef:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011f3:	48 89 c7             	mov    %rax,%rdi
  8011f6:	48 89 d6             	mov    %rdx,%rsi
  8011f9:	fd                   	std    
  8011fa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011fc:	eb 1d                	jmp    80121b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801202:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801206:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80120e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801212:	48 89 d7             	mov    %rdx,%rdi
  801215:	48 89 c1             	mov    %rax,%rcx
  801218:	fd                   	std    
  801219:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80121b:	fc                   	cld    
  80121c:	eb 57                	jmp    801275 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80121e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801222:	83 e0 03             	and    $0x3,%eax
  801225:	48 85 c0             	test   %rax,%rax
  801228:	75 36                	jne    801260 <memmove+0xfc>
  80122a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122e:	83 e0 03             	and    $0x3,%eax
  801231:	48 85 c0             	test   %rax,%rax
  801234:	75 2a                	jne    801260 <memmove+0xfc>
  801236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123a:	83 e0 03             	and    $0x3,%eax
  80123d:	48 85 c0             	test   %rax,%rax
  801240:	75 1e                	jne    801260 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801242:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801246:	48 c1 e8 02          	shr    $0x2,%rax
  80124a:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80124d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801251:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801255:	48 89 c7             	mov    %rax,%rdi
  801258:	48 89 d6             	mov    %rdx,%rsi
  80125b:	fc                   	cld    
  80125c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80125e:	eb 15                	jmp    801275 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801264:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801268:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80126c:	48 89 c7             	mov    %rax,%rdi
  80126f:	48 89 d6             	mov    %rdx,%rsi
  801272:	fc                   	cld    
  801273:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801279:	c9                   	leaveq 
  80127a:	c3                   	retq   

000000000080127b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80127b:	55                   	push   %rbp
  80127c:	48 89 e5             	mov    %rsp,%rbp
  80127f:	48 83 ec 18          	sub    $0x18,%rsp
  801283:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801287:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80128b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80128f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801293:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129b:	48 89 ce             	mov    %rcx,%rsi
  80129e:	48 89 c7             	mov    %rax,%rdi
  8012a1:	48 b8 64 11 80 00 00 	movabs $0x801164,%rax
  8012a8:	00 00 00 
  8012ab:	ff d0                	callq  *%rax
}
  8012ad:	c9                   	leaveq 
  8012ae:	c3                   	retq   

00000000008012af <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012af:	55                   	push   %rbp
  8012b0:	48 89 e5             	mov    %rsp,%rbp
  8012b3:	48 83 ec 28          	sub    $0x28,%rsp
  8012b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012d3:	eb 36                	jmp    80130b <memcmp+0x5c>
		if (*s1 != *s2)
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	0f b6 10             	movzbl (%rax),%edx
  8012dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e0:	0f b6 00             	movzbl (%rax),%eax
  8012e3:	38 c2                	cmp    %al,%dl
  8012e5:	74 1a                	je     801301 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	0f b6 00             	movzbl (%rax),%eax
  8012ee:	0f b6 d0             	movzbl %al,%edx
  8012f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	0f b6 c0             	movzbl %al,%eax
  8012fb:	29 c2                	sub    %eax,%edx
  8012fd:	89 d0                	mov    %edx,%eax
  8012ff:	eb 20                	jmp    801321 <memcmp+0x72>
		s1++, s2++;
  801301:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801306:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80130b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801313:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801317:	48 85 c0             	test   %rax,%rax
  80131a:	75 b9                	jne    8012d5 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801321:	c9                   	leaveq 
  801322:	c3                   	retq   

0000000000801323 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp
  801327:	48 83 ec 28          	sub    $0x28,%rsp
  80132b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801332:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801336:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80133e:	48 01 d0             	add    %rdx,%rax
  801341:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801345:	eb 15                	jmp    80135c <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134b:	0f b6 10             	movzbl (%rax),%edx
  80134e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801351:	38 c2                	cmp    %al,%dl
  801353:	75 02                	jne    801357 <memfind+0x34>
			break;
  801355:	eb 0f                	jmp    801366 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801357:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801360:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801364:	72 e1                	jb     801347 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80136a:	c9                   	leaveq 
  80136b:	c3                   	retq   

000000000080136c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80136c:	55                   	push   %rbp
  80136d:	48 89 e5             	mov    %rsp,%rbp
  801370:	48 83 ec 34          	sub    $0x34,%rsp
  801374:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801378:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80137c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801386:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80138d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138e:	eb 05                	jmp    801395 <strtol+0x29>
		s++;
  801390:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801399:	0f b6 00             	movzbl (%rax),%eax
  80139c:	3c 20                	cmp    $0x20,%al
  80139e:	74 f0                	je     801390 <strtol+0x24>
  8013a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a4:	0f b6 00             	movzbl (%rax),%eax
  8013a7:	3c 09                	cmp    $0x9,%al
  8013a9:	74 e5                	je     801390 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	3c 2b                	cmp    $0x2b,%al
  8013b4:	75 07                	jne    8013bd <strtol+0x51>
		s++;
  8013b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013bb:	eb 17                	jmp    8013d4 <strtol+0x68>
	else if (*s == '-')
  8013bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c1:	0f b6 00             	movzbl (%rax),%eax
  8013c4:	3c 2d                	cmp    $0x2d,%al
  8013c6:	75 0c                	jne    8013d4 <strtol+0x68>
		s++, neg = 1;
  8013c8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013d8:	74 06                	je     8013e0 <strtol+0x74>
  8013da:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013de:	75 28                	jne    801408 <strtol+0x9c>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	3c 30                	cmp    $0x30,%al
  8013e9:	75 1d                	jne    801408 <strtol+0x9c>
  8013eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ef:	48 83 c0 01          	add    $0x1,%rax
  8013f3:	0f b6 00             	movzbl (%rax),%eax
  8013f6:	3c 78                	cmp    $0x78,%al
  8013f8:	75 0e                	jne    801408 <strtol+0x9c>
		s += 2, base = 16;
  8013fa:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013ff:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801406:	eb 2c                	jmp    801434 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801408:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80140c:	75 19                	jne    801427 <strtol+0xbb>
  80140e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801412:	0f b6 00             	movzbl (%rax),%eax
  801415:	3c 30                	cmp    $0x30,%al
  801417:	75 0e                	jne    801427 <strtol+0xbb>
		s++, base = 8;
  801419:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80141e:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801425:	eb 0d                	jmp    801434 <strtol+0xc8>
	else if (base == 0)
  801427:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80142b:	75 07                	jne    801434 <strtol+0xc8>
		base = 10;
  80142d:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	3c 2f                	cmp    $0x2f,%al
  80143d:	7e 1d                	jle    80145c <strtol+0xf0>
  80143f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	3c 39                	cmp    $0x39,%al
  801448:	7f 12                	jg     80145c <strtol+0xf0>
			dig = *s - '0';
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	0f be c0             	movsbl %al,%eax
  801454:	83 e8 30             	sub    $0x30,%eax
  801457:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80145a:	eb 4e                	jmp    8014aa <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	0f b6 00             	movzbl (%rax),%eax
  801463:	3c 60                	cmp    $0x60,%al
  801465:	7e 1d                	jle    801484 <strtol+0x118>
  801467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146b:	0f b6 00             	movzbl (%rax),%eax
  80146e:	3c 7a                	cmp    $0x7a,%al
  801470:	7f 12                	jg     801484 <strtol+0x118>
			dig = *s - 'a' + 10;
  801472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801476:	0f b6 00             	movzbl (%rax),%eax
  801479:	0f be c0             	movsbl %al,%eax
  80147c:	83 e8 57             	sub    $0x57,%eax
  80147f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801482:	eb 26                	jmp    8014aa <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801484:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	3c 40                	cmp    $0x40,%al
  80148d:	7e 48                	jle    8014d7 <strtol+0x16b>
  80148f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801493:	0f b6 00             	movzbl (%rax),%eax
  801496:	3c 5a                	cmp    $0x5a,%al
  801498:	7f 3d                	jg     8014d7 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	0f be c0             	movsbl %al,%eax
  8014a4:	83 e8 37             	sub    $0x37,%eax
  8014a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ad:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014b0:	7c 02                	jl     8014b4 <strtol+0x148>
			break;
  8014b2:	eb 23                	jmp    8014d7 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014bc:	48 98                	cltq   
  8014be:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014c3:	48 89 c2             	mov    %rax,%rdx
  8014c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014c9:	48 98                	cltq   
  8014cb:	48 01 d0             	add    %rdx,%rax
  8014ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014d2:	e9 5d ff ff ff       	jmpq   801434 <strtol+0xc8>

	if (endptr)
  8014d7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014dc:	74 0b                	je     8014e9 <strtol+0x17d>
		*endptr = (char *) s;
  8014de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014e6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014ed:	74 09                	je     8014f8 <strtol+0x18c>
  8014ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f3:	48 f7 d8             	neg    %rax
  8014f6:	eb 04                	jmp    8014fc <strtol+0x190>
  8014f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014fc:	c9                   	leaveq 
  8014fd:	c3                   	retq   

00000000008014fe <strstr>:

char * strstr(const char *in, const char *str)
{
  8014fe:	55                   	push   %rbp
  8014ff:	48 89 e5             	mov    %rsp,%rbp
  801502:	48 83 ec 30          	sub    $0x30,%rsp
  801506:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80150a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80150e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801512:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801516:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801520:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801524:	75 06                	jne    80152c <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152a:	eb 6b                	jmp    801597 <strstr+0x99>

	len = strlen(str);
  80152c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801530:	48 89 c7             	mov    %rax,%rdi
  801533:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  80153a:	00 00 00 
  80153d:	ff d0                	callq  *%rax
  80153f:	48 98                	cltq   
  801541:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801549:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80154d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801557:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80155b:	75 07                	jne    801564 <strstr+0x66>
				return (char *) 0;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 33                	jmp    801597 <strstr+0x99>
		} while (sc != c);
  801564:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801568:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80156b:	75 d8                	jne    801545 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80156d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801571:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801579:	48 89 ce             	mov    %rcx,%rsi
  80157c:	48 89 c7             	mov    %rax,%rdi
  80157f:	48 b8 f5 0f 80 00 00 	movabs $0x800ff5,%rax
  801586:	00 00 00 
  801589:	ff d0                	callq  *%rax
  80158b:	85 c0                	test   %eax,%eax
  80158d:	75 b6                	jne    801545 <strstr+0x47>

	return (char *) (in - 1);
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	48 83 e8 01          	sub    $0x1,%rax
}
  801597:	c9                   	leaveq 
  801598:	c3                   	retq   

0000000000801599 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801599:	55                   	push   %rbp
  80159a:	48 89 e5             	mov    %rsp,%rbp
  80159d:	53                   	push   %rbx
  80159e:	48 83 ec 48          	sub    $0x48,%rsp
  8015a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015a5:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015a8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015ac:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015b0:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015b4:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015bb:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015bf:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015c3:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015c7:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015cb:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015cf:	4c 89 c3             	mov    %r8,%rbx
  8015d2:	cd 30                	int    $0x30
  8015d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015d8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015dc:	74 3e                	je     80161c <syscall+0x83>
  8015de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015e3:	7e 37                	jle    80161c <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015ec:	49 89 d0             	mov    %rdx,%r8
  8015ef:	89 c1                	mov    %eax,%ecx
  8015f1:	48 ba 28 3b 80 00 00 	movabs $0x803b28,%rdx
  8015f8:	00 00 00 
  8015fb:	be 23 00 00 00       	mov    $0x23,%esi
  801600:	48 bf 45 3b 80 00 00 	movabs $0x803b45,%rdi
  801607:	00 00 00 
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
  80160f:	49 b9 a1 32 80 00 00 	movabs $0x8032a1,%r9
  801616:	00 00 00 
  801619:	41 ff d1             	callq  *%r9

	return ret;
  80161c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801620:	48 83 c4 48          	add    $0x48,%rsp
  801624:	5b                   	pop    %rbx
  801625:	5d                   	pop    %rbp
  801626:	c3                   	retq   

0000000000801627 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	48 83 ec 20          	sub    $0x20,%rsp
  80162f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801633:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80163f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801646:	00 
  801647:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80164d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801653:	48 89 d1             	mov    %rdx,%rcx
  801656:	48 89 c2             	mov    %rax,%rdx
  801659:	be 00 00 00 00       	mov    $0x0,%esi
  80165e:	bf 00 00 00 00       	mov    $0x0,%edi
  801663:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  80166a:	00 00 00 
  80166d:	ff d0                	callq  *%rax
}
  80166f:	c9                   	leaveq 
  801670:	c3                   	retq   

0000000000801671 <sys_cgetc>:

int
sys_cgetc(void)
{
  801671:	55                   	push   %rbp
  801672:	48 89 e5             	mov    %rsp,%rbp
  801675:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801679:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801680:	00 
  801681:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801687:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80168d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801692:	ba 00 00 00 00       	mov    $0x0,%edx
  801697:	be 00 00 00 00       	mov    $0x0,%esi
  80169c:	bf 01 00 00 00       	mov    $0x1,%edi
  8016a1:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8016a8:	00 00 00 
  8016ab:	ff d0                	callq  *%rax
}
  8016ad:	c9                   	leaveq 
  8016ae:	c3                   	retq   

00000000008016af <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016af:	55                   	push   %rbp
  8016b0:	48 89 e5             	mov    %rsp,%rbp
  8016b3:	48 83 ec 10          	sub    $0x10,%rsp
  8016b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016bd:	48 98                	cltq   
  8016bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016c6:	00 
  8016c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d8:	48 89 c2             	mov    %rax,%rdx
  8016db:	be 01 00 00 00       	mov    $0x1,%esi
  8016e0:	bf 03 00 00 00       	mov    $0x3,%edi
  8016e5:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8016ec:	00 00 00 
  8016ef:	ff d0                	callq  *%rax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801702:	00 
  801703:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801709:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80170f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801714:	ba 00 00 00 00       	mov    $0x0,%edx
  801719:	be 00 00 00 00       	mov    $0x0,%esi
  80171e:	bf 02 00 00 00       	mov    $0x2,%edi
  801723:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  80172a:	00 00 00 
  80172d:	ff d0                	callq  *%rax
}
  80172f:	c9                   	leaveq 
  801730:	c3                   	retq   

0000000000801731 <sys_yield>:

void
sys_yield(void)
{
  801731:	55                   	push   %rbp
  801732:	48 89 e5             	mov    %rsp,%rbp
  801735:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801739:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801740:	00 
  801741:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801747:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80174d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	be 00 00 00 00       	mov    $0x0,%esi
  80175c:	bf 0b 00 00 00       	mov    $0xb,%edi
  801761:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801768:	00 00 00 
  80176b:	ff d0                	callq  *%rax
}
  80176d:	c9                   	leaveq 
  80176e:	c3                   	retq   

000000000080176f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	48 83 ec 20          	sub    $0x20,%rsp
  801777:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80177a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80177e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801781:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801784:	48 63 c8             	movslq %eax,%rcx
  801787:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80178e:	48 98                	cltq   
  801790:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801797:	00 
  801798:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179e:	49 89 c8             	mov    %rcx,%r8
  8017a1:	48 89 d1             	mov    %rdx,%rcx
  8017a4:	48 89 c2             	mov    %rax,%rdx
  8017a7:	be 01 00 00 00       	mov    $0x1,%esi
  8017ac:	bf 04 00 00 00       	mov    $0x4,%edi
  8017b1:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8017b8:	00 00 00 
  8017bb:	ff d0                	callq  *%rax
}
  8017bd:	c9                   	leaveq 
  8017be:	c3                   	retq   

00000000008017bf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017bf:	55                   	push   %rbp
  8017c0:	48 89 e5             	mov    %rsp,%rbp
  8017c3:	48 83 ec 30          	sub    $0x30,%rsp
  8017c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ce:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017d1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017d5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017dc:	48 63 c8             	movslq %eax,%rcx
  8017df:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017e6:	48 63 f0             	movslq %eax,%rsi
  8017e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f0:	48 98                	cltq   
  8017f2:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017f6:	49 89 f9             	mov    %rdi,%r9
  8017f9:	49 89 f0             	mov    %rsi,%r8
  8017fc:	48 89 d1             	mov    %rdx,%rcx
  8017ff:	48 89 c2             	mov    %rax,%rdx
  801802:	be 01 00 00 00       	mov    $0x1,%esi
  801807:	bf 05 00 00 00       	mov    $0x5,%edi
  80180c:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801813:	00 00 00 
  801816:	ff d0                	callq  *%rax
}
  801818:	c9                   	leaveq 
  801819:	c3                   	retq   

000000000080181a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80181a:	55                   	push   %rbp
  80181b:	48 89 e5             	mov    %rsp,%rbp
  80181e:	48 83 ec 20          	sub    $0x20,%rsp
  801822:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801825:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801829:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801830:	48 98                	cltq   
  801832:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801839:	00 
  80183a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801840:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801846:	48 89 d1             	mov    %rdx,%rcx
  801849:	48 89 c2             	mov    %rax,%rdx
  80184c:	be 01 00 00 00       	mov    $0x1,%esi
  801851:	bf 06 00 00 00       	mov    $0x6,%edi
  801856:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  80185d:	00 00 00 
  801860:	ff d0                	callq  *%rax
}
  801862:	c9                   	leaveq 
  801863:	c3                   	retq   

0000000000801864 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801864:	55                   	push   %rbp
  801865:	48 89 e5             	mov    %rsp,%rbp
  801868:	48 83 ec 10          	sub    $0x10,%rsp
  80186c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80186f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801872:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801875:	48 63 d0             	movslq %eax,%rdx
  801878:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187b:	48 98                	cltq   
  80187d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801884:	00 
  801885:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801891:	48 89 d1             	mov    %rdx,%rcx
  801894:	48 89 c2             	mov    %rax,%rdx
  801897:	be 01 00 00 00       	mov    $0x1,%esi
  80189c:	bf 08 00 00 00       	mov    $0x8,%edi
  8018a1:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8018a8:	00 00 00 
  8018ab:	ff d0                	callq  *%rax
}
  8018ad:	c9                   	leaveq 
  8018ae:	c3                   	retq   

00000000008018af <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	48 83 ec 20          	sub    $0x20,%rsp
  8018b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c5:	48 98                	cltq   
  8018c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ce:	00 
  8018cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018db:	48 89 d1             	mov    %rdx,%rcx
  8018de:	48 89 c2             	mov    %rax,%rdx
  8018e1:	be 01 00 00 00       	mov    $0x1,%esi
  8018e6:	bf 09 00 00 00       	mov    $0x9,%edi
  8018eb:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	callq  *%rax
}
  8018f7:	c9                   	leaveq 
  8018f8:	c3                   	retq   

00000000008018f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	48 83 ec 20          	sub    $0x20,%rsp
  801901:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801904:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801908:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190f:	48 98                	cltq   
  801911:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801918:	00 
  801919:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801925:	48 89 d1             	mov    %rdx,%rcx
  801928:	48 89 c2             	mov    %rax,%rdx
  80192b:	be 01 00 00 00       	mov    $0x1,%esi
  801930:	bf 0a 00 00 00       	mov    $0xa,%edi
  801935:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	callq  *%rax
}
  801941:	c9                   	leaveq 
  801942:	c3                   	retq   

0000000000801943 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	48 83 ec 20          	sub    $0x20,%rsp
  80194b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80194e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801952:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801956:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801959:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80195c:	48 63 f0             	movslq %eax,%rsi
  80195f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801966:	48 98                	cltq   
  801968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801973:	00 
  801974:	49 89 f1             	mov    %rsi,%r9
  801977:	49 89 c8             	mov    %rcx,%r8
  80197a:	48 89 d1             	mov    %rdx,%rcx
  80197d:	48 89 c2             	mov    %rax,%rdx
  801980:	be 00 00 00 00       	mov    $0x0,%esi
  801985:	bf 0c 00 00 00       	mov    $0xc,%edi
  80198a:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  801991:	00 00 00 
  801994:	ff d0                	callq  *%rax
}
  801996:	c9                   	leaveq 
  801997:	c3                   	retq   

0000000000801998 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 83 ec 10          	sub    $0x10,%rsp
  8019a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019af:	00 
  8019b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c1:	48 89 c2             	mov    %rax,%rdx
  8019c4:	be 01 00 00 00       	mov    $0x1,%esi
  8019c9:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019ce:	48 b8 99 15 80 00 00 	movabs $0x801599,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	callq  *%rax
}
  8019da:	c9                   	leaveq 
  8019db:	c3                   	retq   

00000000008019dc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8019dc:	55                   	push   %rbp
  8019dd:	48 89 e5             	mov    %rsp,%rbp
  8019e0:	48 83 ec 08          	sub    $0x8,%rsp
  8019e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019ec:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019f3:	ff ff ff 
  8019f6:	48 01 d0             	add    %rdx,%rax
  8019f9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019fd:	c9                   	leaveq 
  8019fe:	c3                   	retq   

00000000008019ff <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019ff:	55                   	push   %rbp
  801a00:	48 89 e5             	mov    %rsp,%rbp
  801a03:	48 83 ec 08          	sub    $0x8,%rsp
  801a07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0f:	48 89 c7             	mov    %rax,%rdi
  801a12:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
  801a1e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a24:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 18          	sub    $0x18,%rsp
  801a32:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a3d:	eb 6b                	jmp    801aaa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a42:	48 98                	cltq   
  801a44:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a4a:	48 c1 e0 0c          	shl    $0xc,%rax
  801a4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a56:	48 c1 e8 15          	shr    $0x15,%rax
  801a5a:	48 89 c2             	mov    %rax,%rdx
  801a5d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801a64:	01 00 00 
  801a67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a6b:	83 e0 01             	and    $0x1,%eax
  801a6e:	48 85 c0             	test   %rax,%rax
  801a71:	74 21                	je     801a94 <fd_alloc+0x6a>
  801a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a77:	48 c1 e8 0c          	shr    $0xc,%rax
  801a7b:	48 89 c2             	mov    %rax,%rdx
  801a7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a85:	01 00 00 
  801a88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a8c:	83 e0 01             	and    $0x1,%eax
  801a8f:	48 85 c0             	test   %rax,%rax
  801a92:	75 12                	jne    801aa6 <fd_alloc+0x7c>
			*fd_store = fd;
  801a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a9c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa4:	eb 1a                	jmp    801ac0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801aa6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801aaa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801aae:	7e 8f                	jle    801a3f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801abb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ac0:	c9                   	leaveq 
  801ac1:	c3                   	retq   

0000000000801ac2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ac2:	55                   	push   %rbp
  801ac3:	48 89 e5             	mov    %rsp,%rbp
  801ac6:	48 83 ec 20          	sub    $0x20,%rsp
  801aca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801acd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ad1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ad5:	78 06                	js     801add <fd_lookup+0x1b>
  801ad7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801adb:	7e 07                	jle    801ae4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801add:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ae2:	eb 6c                	jmp    801b50 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ae4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ae7:	48 98                	cltq   
  801ae9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801aef:	48 c1 e0 0c          	shl    $0xc,%rax
  801af3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afb:	48 c1 e8 15          	shr    $0x15,%rax
  801aff:	48 89 c2             	mov    %rax,%rdx
  801b02:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b09:	01 00 00 
  801b0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b10:	83 e0 01             	and    $0x1,%eax
  801b13:	48 85 c0             	test   %rax,%rax
  801b16:	74 21                	je     801b39 <fd_lookup+0x77>
  801b18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1c:	48 c1 e8 0c          	shr    $0xc,%rax
  801b20:	48 89 c2             	mov    %rax,%rdx
  801b23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b2a:	01 00 00 
  801b2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b31:	83 e0 01             	and    $0x1,%eax
  801b34:	48 85 c0             	test   %rax,%rax
  801b37:	75 07                	jne    801b40 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3e:	eb 10                	jmp    801b50 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b44:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b48:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b50:	c9                   	leaveq 
  801b51:	c3                   	retq   

0000000000801b52 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b52:	55                   	push   %rbp
  801b53:	48 89 e5             	mov    %rsp,%rbp
  801b56:	48 83 ec 30          	sub    $0x30,%rsp
  801b5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b5e:	89 f0                	mov    %esi,%eax
  801b60:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b67:	48 89 c7             	mov    %rax,%rdi
  801b6a:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
  801b76:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b7a:	48 89 d6             	mov    %rdx,%rsi
  801b7d:	89 c7                	mov    %eax,%edi
  801b7f:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  801b86:	00 00 00 
  801b89:	ff d0                	callq  *%rax
  801b8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b92:	78 0a                	js     801b9e <fd_close+0x4c>
	    || fd != fd2)
  801b94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b98:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801b9c:	74 12                	je     801bb0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801b9e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ba2:	74 05                	je     801ba9 <fd_close+0x57>
  801ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba7:	eb 05                	jmp    801bae <fd_close+0x5c>
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bae:	eb 69                	jmp    801c19 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb4:	8b 00                	mov    (%rax),%eax
  801bb6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801bba:	48 89 d6             	mov    %rdx,%rsi
  801bbd:	89 c7                	mov    %eax,%edi
  801bbf:	48 b8 1b 1c 80 00 00 	movabs $0x801c1b,%rax
  801bc6:	00 00 00 
  801bc9:	ff d0                	callq  *%rax
  801bcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd2:	78 2a                	js     801bfe <fd_close+0xac>
		if (dev->dev_close)
  801bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bdc:	48 85 c0             	test   %rax,%rax
  801bdf:	74 16                	je     801bf7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801be1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be5:	48 8b 40 20          	mov    0x20(%rax),%rax
  801be9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bed:	48 89 d7             	mov    %rdx,%rdi
  801bf0:	ff d0                	callq  *%rax
  801bf2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bf5:	eb 07                	jmp    801bfe <fd_close+0xac>
		else
			r = 0;
  801bf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c02:	48 89 c6             	mov    %rax,%rsi
  801c05:	bf 00 00 00 00       	mov    $0x0,%edi
  801c0a:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  801c11:	00 00 00 
  801c14:	ff d0                	callq  *%rax
	return r;
  801c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c19:	c9                   	leaveq 
  801c1a:	c3                   	retq   

0000000000801c1b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c1b:	55                   	push   %rbp
  801c1c:	48 89 e5             	mov    %rsp,%rbp
  801c1f:	48 83 ec 20          	sub    $0x20,%rsp
  801c23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c31:	eb 41                	jmp    801c74 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c33:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c3a:	00 00 00 
  801c3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c40:	48 63 d2             	movslq %edx,%rdx
  801c43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c47:	8b 00                	mov    (%rax),%eax
  801c49:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c4c:	75 22                	jne    801c70 <dev_lookup+0x55>
			*dev = devtab[i];
  801c4e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c55:	00 00 00 
  801c58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c5b:	48 63 d2             	movslq %edx,%rdx
  801c5e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c66:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6e:	eb 60                	jmp    801cd0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c70:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c74:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c7b:	00 00 00 
  801c7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c81:	48 63 d2             	movslq %edx,%rdx
  801c84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c88:	48 85 c0             	test   %rax,%rax
  801c8b:	75 a6                	jne    801c33 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c8d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801c94:	00 00 00 
  801c97:	48 8b 00             	mov    (%rax),%rax
  801c9a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ca0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ca3:	89 c6                	mov    %eax,%esi
  801ca5:	48 bf 58 3b 80 00 00 	movabs $0x803b58,%rdi
  801cac:	00 00 00 
  801caf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb4:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  801cbb:	00 00 00 
  801cbe:	ff d1                	callq  *%rcx
	*dev = 0;
  801cc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cc4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ccb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cd0:	c9                   	leaveq 
  801cd1:	c3                   	retq   

0000000000801cd2 <close>:

int
close(int fdnum)
{
  801cd2:	55                   	push   %rbp
  801cd3:	48 89 e5             	mov    %rsp,%rbp
  801cd6:	48 83 ec 20          	sub    $0x20,%rsp
  801cda:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cdd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ce1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ce4:	48 89 d6             	mov    %rdx,%rsi
  801ce7:	89 c7                	mov    %eax,%edi
  801ce9:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	callq  *%rax
  801cf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cfc:	79 05                	jns    801d03 <close+0x31>
		return r;
  801cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d01:	eb 18                	jmp    801d1b <close+0x49>
	else
		return fd_close(fd, 1);
  801d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d07:	be 01 00 00 00       	mov    $0x1,%esi
  801d0c:	48 89 c7             	mov    %rax,%rdi
  801d0f:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	callq  *%rax
}
  801d1b:	c9                   	leaveq 
  801d1c:	c3                   	retq   

0000000000801d1d <close_all>:

void
close_all(void)
{
  801d1d:	55                   	push   %rbp
  801d1e:	48 89 e5             	mov    %rsp,%rbp
  801d21:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d2c:	eb 15                	jmp    801d43 <close_all+0x26>
		close(i);
  801d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d31:	89 c7                	mov    %eax,%edi
  801d33:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  801d3a:	00 00 00 
  801d3d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d3f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d43:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d47:	7e e5                	jle    801d2e <close_all+0x11>
		close(i);
}
  801d49:	c9                   	leaveq 
  801d4a:	c3                   	retq   

0000000000801d4b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d4b:	55                   	push   %rbp
  801d4c:	48 89 e5             	mov    %rsp,%rbp
  801d4f:	48 83 ec 40          	sub    $0x40,%rsp
  801d53:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d56:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d59:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801d5d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d60:	48 89 d6             	mov    %rdx,%rsi
  801d63:	89 c7                	mov    %eax,%edi
  801d65:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	callq  *%rax
  801d71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d78:	79 08                	jns    801d82 <dup+0x37>
		return r;
  801d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7d:	e9 70 01 00 00       	jmpq   801ef2 <dup+0x1a7>
	close(newfdnum);
  801d82:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d85:	89 c7                	mov    %eax,%edi
  801d87:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801d93:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d96:	48 98                	cltq   
  801d98:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d9e:	48 c1 e0 0c          	shl    $0xc,%rax
  801da2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801da6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801daa:	48 89 c7             	mov    %rax,%rdi
  801dad:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  801db4:	00 00 00 
  801db7:	ff d0                	callq  *%rax
  801db9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc1:	48 89 c7             	mov    %rax,%rdi
  801dc4:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  801dcb:	00 00 00 
  801dce:	ff d0                	callq  *%rax
  801dd0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801dd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd8:	48 c1 e8 15          	shr    $0x15,%rax
  801ddc:	48 89 c2             	mov    %rax,%rdx
  801ddf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801de6:	01 00 00 
  801de9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ded:	83 e0 01             	and    $0x1,%eax
  801df0:	48 85 c0             	test   %rax,%rax
  801df3:	74 73                	je     801e68 <dup+0x11d>
  801df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df9:	48 c1 e8 0c          	shr    $0xc,%rax
  801dfd:	48 89 c2             	mov    %rax,%rdx
  801e00:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e07:	01 00 00 
  801e0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e0e:	83 e0 01             	and    $0x1,%eax
  801e11:	48 85 c0             	test   %rax,%rax
  801e14:	74 52                	je     801e68 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1a:	48 c1 e8 0c          	shr    $0xc,%rax
  801e1e:	48 89 c2             	mov    %rax,%rdx
  801e21:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e28:	01 00 00 
  801e2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2f:	25 07 0e 00 00       	and    $0xe07,%eax
  801e34:	89 c1                	mov    %eax,%ecx
  801e36:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e3e:	41 89 c8             	mov    %ecx,%r8d
  801e41:	48 89 d1             	mov    %rdx,%rcx
  801e44:	ba 00 00 00 00       	mov    $0x0,%edx
  801e49:	48 89 c6             	mov    %rax,%rsi
  801e4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e51:	48 b8 bf 17 80 00 00 	movabs $0x8017bf,%rax
  801e58:	00 00 00 
  801e5b:	ff d0                	callq  *%rax
  801e5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e64:	79 02                	jns    801e68 <dup+0x11d>
			goto err;
  801e66:	eb 57                	jmp    801ebf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6c:	48 c1 e8 0c          	shr    $0xc,%rax
  801e70:	48 89 c2             	mov    %rax,%rdx
  801e73:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e7a:	01 00 00 
  801e7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e81:	25 07 0e 00 00       	and    $0xe07,%eax
  801e86:	89 c1                	mov    %eax,%ecx
  801e88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e90:	41 89 c8             	mov    %ecx,%r8d
  801e93:	48 89 d1             	mov    %rdx,%rcx
  801e96:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9b:	48 89 c6             	mov    %rax,%rsi
  801e9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea3:	48 b8 bf 17 80 00 00 	movabs $0x8017bf,%rax
  801eaa:	00 00 00 
  801ead:	ff d0                	callq  *%rax
  801eaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eb6:	79 02                	jns    801eba <dup+0x16f>
		goto err;
  801eb8:	eb 05                	jmp    801ebf <dup+0x174>

	return newfdnum;
  801eba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ebd:	eb 33                	jmp    801ef2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec3:	48 89 c6             	mov    %rax,%rsi
  801ec6:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecb:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  801ed2:	00 00 00 
  801ed5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801ed7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801edb:	48 89 c6             	mov    %rax,%rsi
  801ede:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee3:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax
	return r;
  801eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ef2:	c9                   	leaveq 
  801ef3:	c3                   	retq   

0000000000801ef4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ef4:	55                   	push   %rbp
  801ef5:	48 89 e5             	mov    %rsp,%rbp
  801ef8:	48 83 ec 40          	sub    $0x40,%rsp
  801efc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801eff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f03:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f07:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f0b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f0e:	48 89 d6             	mov    %rdx,%rsi
  801f11:	89 c7                	mov    %eax,%edi
  801f13:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  801f1a:	00 00 00 
  801f1d:	ff d0                	callq  *%rax
  801f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f26:	78 24                	js     801f4c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2c:	8b 00                	mov    (%rax),%eax
  801f2e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f32:	48 89 d6             	mov    %rdx,%rsi
  801f35:	89 c7                	mov    %eax,%edi
  801f37:	48 b8 1b 1c 80 00 00 	movabs $0x801c1b,%rax
  801f3e:	00 00 00 
  801f41:	ff d0                	callq  *%rax
  801f43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f4a:	79 05                	jns    801f51 <read+0x5d>
		return r;
  801f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4f:	eb 76                	jmp    801fc7 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f55:	8b 40 08             	mov    0x8(%rax),%eax
  801f58:	83 e0 03             	and    $0x3,%eax
  801f5b:	83 f8 01             	cmp    $0x1,%eax
  801f5e:	75 3a                	jne    801f9a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f60:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f67:	00 00 00 
  801f6a:	48 8b 00             	mov    (%rax),%rax
  801f6d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f73:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f76:	89 c6                	mov    %eax,%esi
  801f78:	48 bf 77 3b 80 00 00 	movabs $0x803b77,%rdi
  801f7f:	00 00 00 
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  801f8e:	00 00 00 
  801f91:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801f93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f98:	eb 2d                	jmp    801fc7 <read+0xd3>
	}
	if (!dev->dev_read)
  801f9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fa2:	48 85 c0             	test   %rax,%rax
  801fa5:	75 07                	jne    801fae <read+0xba>
		return -E_NOT_SUPP;
  801fa7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801fac:	eb 19                	jmp    801fc7 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb2:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fb6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801fbe:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801fc2:	48 89 cf             	mov    %rcx,%rdi
  801fc5:	ff d0                	callq  *%rax
}
  801fc7:	c9                   	leaveq 
  801fc8:	c3                   	retq   

0000000000801fc9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801fc9:	55                   	push   %rbp
  801fca:	48 89 e5             	mov    %rsp,%rbp
  801fcd:	48 83 ec 30          	sub    $0x30,%rsp
  801fd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fd8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801fdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fe3:	eb 49                	jmp    80202e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fe5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe8:	48 98                	cltq   
  801fea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fee:	48 29 c2             	sub    %rax,%rdx
  801ff1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff4:	48 63 c8             	movslq %eax,%rcx
  801ff7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ffb:	48 01 c1             	add    %rax,%rcx
  801ffe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802001:	48 89 ce             	mov    %rcx,%rsi
  802004:	89 c7                	mov    %eax,%edi
  802006:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  80200d:	00 00 00 
  802010:	ff d0                	callq  *%rax
  802012:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802015:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802019:	79 05                	jns    802020 <readn+0x57>
			return m;
  80201b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80201e:	eb 1c                	jmp    80203c <readn+0x73>
		if (m == 0)
  802020:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802024:	75 02                	jne    802028 <readn+0x5f>
			break;
  802026:	eb 11                	jmp    802039 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802028:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80202b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80202e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802031:	48 98                	cltq   
  802033:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802037:	72 ac                	jb     801fe5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802039:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80203c:	c9                   	leaveq 
  80203d:	c3                   	retq   

000000000080203e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80203e:	55                   	push   %rbp
  80203f:	48 89 e5             	mov    %rsp,%rbp
  802042:	48 83 ec 40          	sub    $0x40,%rsp
  802046:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802049:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80204d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802051:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802055:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802058:	48 89 d6             	mov    %rdx,%rsi
  80205b:	89 c7                	mov    %eax,%edi
  80205d:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  802064:	00 00 00 
  802067:	ff d0                	callq  *%rax
  802069:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802070:	78 24                	js     802096 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802076:	8b 00                	mov    (%rax),%eax
  802078:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80207c:	48 89 d6             	mov    %rdx,%rsi
  80207f:	89 c7                	mov    %eax,%edi
  802081:	48 b8 1b 1c 80 00 00 	movabs $0x801c1b,%rax
  802088:	00 00 00 
  80208b:	ff d0                	callq  *%rax
  80208d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802090:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802094:	79 05                	jns    80209b <write+0x5d>
		return r;
  802096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802099:	eb 75                	jmp    802110 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80209b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209f:	8b 40 08             	mov    0x8(%rax),%eax
  8020a2:	83 e0 03             	and    $0x3,%eax
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	75 3a                	jne    8020e3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020b0:	00 00 00 
  8020b3:	48 8b 00             	mov    (%rax),%rax
  8020b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020bf:	89 c6                	mov    %eax,%esi
  8020c1:	48 bf 93 3b 80 00 00 	movabs $0x803b93,%rdi
  8020c8:	00 00 00 
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  8020d7:	00 00 00 
  8020da:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e1:	eb 2d                	jmp    802110 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020eb:	48 85 c0             	test   %rax,%rax
  8020ee:	75 07                	jne    8020f7 <write+0xb9>
		return -E_NOT_SUPP;
  8020f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020f5:	eb 19                	jmp    802110 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8020f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802103:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802107:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80210b:	48 89 cf             	mov    %rcx,%rdi
  80210e:	ff d0                	callq  *%rax
}
  802110:	c9                   	leaveq 
  802111:	c3                   	retq   

0000000000802112 <seek>:

int
seek(int fdnum, off_t offset)
{
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
  802116:	48 83 ec 18          	sub    $0x18,%rsp
  80211a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80211d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802120:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802124:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802127:	48 89 d6             	mov    %rdx,%rsi
  80212a:	89 c7                	mov    %eax,%edi
  80212c:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  802133:	00 00 00 
  802136:	ff d0                	callq  *%rax
  802138:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80213b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213f:	79 05                	jns    802146 <seek+0x34>
		return r;
  802141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802144:	eb 0f                	jmp    802155 <seek+0x43>
	fd->fd_offset = offset;
  802146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80214d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802155:	c9                   	leaveq 
  802156:	c3                   	retq   

0000000000802157 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802157:	55                   	push   %rbp
  802158:	48 89 e5             	mov    %rsp,%rbp
  80215b:	48 83 ec 30          	sub    $0x30,%rsp
  80215f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802162:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802165:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802169:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80216c:	48 89 d6             	mov    %rdx,%rsi
  80216f:	89 c7                	mov    %eax,%edi
  802171:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
  80217d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802184:	78 24                	js     8021aa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218a:	8b 00                	mov    (%rax),%eax
  80218c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802190:	48 89 d6             	mov    %rdx,%rsi
  802193:	89 c7                	mov    %eax,%edi
  802195:	48 b8 1b 1c 80 00 00 	movabs $0x801c1b,%rax
  80219c:	00 00 00 
  80219f:	ff d0                	callq  *%rax
  8021a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a8:	79 05                	jns    8021af <ftruncate+0x58>
		return r;
  8021aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ad:	eb 72                	jmp    802221 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b3:	8b 40 08             	mov    0x8(%rax),%eax
  8021b6:	83 e0 03             	and    $0x3,%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	75 3a                	jne    8021f7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8021bd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021c4:	00 00 00 
  8021c7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021d3:	89 c6                	mov    %eax,%esi
  8021d5:	48 bf b0 3b 80 00 00 	movabs $0x803bb0,%rdi
  8021dc:	00 00 00 
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e4:	48 b9 78 02 80 00 00 	movabs $0x800278,%rcx
  8021eb:	00 00 00 
  8021ee:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8021f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021f5:	eb 2a                	jmp    802221 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8021f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021ff:	48 85 c0             	test   %rax,%rax
  802202:	75 07                	jne    80220b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802204:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802209:	eb 16                	jmp    802221 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80220b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802213:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802217:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80221a:	89 ce                	mov    %ecx,%esi
  80221c:	48 89 d7             	mov    %rdx,%rdi
  80221f:	ff d0                	callq  *%rax
}
  802221:	c9                   	leaveq 
  802222:	c3                   	retq   

0000000000802223 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802223:	55                   	push   %rbp
  802224:	48 89 e5             	mov    %rsp,%rbp
  802227:	48 83 ec 30          	sub    $0x30,%rsp
  80222b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80222e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802232:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802236:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802239:	48 89 d6             	mov    %rdx,%rsi
  80223c:	89 c7                	mov    %eax,%edi
  80223e:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  802245:	00 00 00 
  802248:	ff d0                	callq  *%rax
  80224a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802251:	78 24                	js     802277 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802257:	8b 00                	mov    (%rax),%eax
  802259:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80225d:	48 89 d6             	mov    %rdx,%rsi
  802260:	89 c7                	mov    %eax,%edi
  802262:	48 b8 1b 1c 80 00 00 	movabs $0x801c1b,%rax
  802269:	00 00 00 
  80226c:	ff d0                	callq  *%rax
  80226e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802271:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802275:	79 05                	jns    80227c <fstat+0x59>
		return r;
  802277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227a:	eb 5e                	jmp    8022da <fstat+0xb7>
	if (!dev->dev_stat)
  80227c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802280:	48 8b 40 28          	mov    0x28(%rax),%rax
  802284:	48 85 c0             	test   %rax,%rax
  802287:	75 07                	jne    802290 <fstat+0x6d>
		return -E_NOT_SUPP;
  802289:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80228e:	eb 4a                	jmp    8022da <fstat+0xb7>
	stat->st_name[0] = 0;
  802290:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802294:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802297:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80229b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8022a2:	00 00 00 
	stat->st_isdir = 0;
  8022a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022a9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8022b0:	00 00 00 
	stat->st_dev = dev;
  8022b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022bb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8022c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022d2:	48 89 ce             	mov    %rcx,%rsi
  8022d5:	48 89 d7             	mov    %rdx,%rdi
  8022d8:	ff d0                	callq  *%rax
}
  8022da:	c9                   	leaveq 
  8022db:	c3                   	retq   

00000000008022dc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022dc:	55                   	push   %rbp
  8022dd:	48 89 e5             	mov    %rsp,%rbp
  8022e0:	48 83 ec 20          	sub    $0x20,%rsp
  8022e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f0:	be 00 00 00 00       	mov    $0x0,%esi
  8022f5:	48 89 c7             	mov    %rax,%rdi
  8022f8:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  8022ff:	00 00 00 
  802302:	ff d0                	callq  *%rax
  802304:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802307:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80230b:	79 05                	jns    802312 <stat+0x36>
		return fd;
  80230d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802310:	eb 2f                	jmp    802341 <stat+0x65>
	r = fstat(fd, stat);
  802312:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802319:	48 89 d6             	mov    %rdx,%rsi
  80231c:	89 c7                	mov    %eax,%edi
  80231e:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802325:	00 00 00 
  802328:	ff d0                	callq  *%rax
  80232a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80232d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802330:	89 c7                	mov    %eax,%edi
  802332:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  802339:	00 00 00 
  80233c:	ff d0                	callq  *%rax
	return r;
  80233e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802341:	c9                   	leaveq 
  802342:	c3                   	retq   

0000000000802343 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802343:	55                   	push   %rbp
  802344:	48 89 e5             	mov    %rsp,%rbp
  802347:	48 83 ec 10          	sub    $0x10,%rsp
  80234b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80234e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802352:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802359:	00 00 00 
  80235c:	8b 00                	mov    (%rax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	75 1d                	jne    80237f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802362:	bf 01 00 00 00       	mov    $0x1,%edi
  802367:	48 b8 0e 35 80 00 00 	movabs $0x80350e,%rax
  80236e:	00 00 00 
  802371:	ff d0                	callq  *%rax
  802373:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80237a:	00 00 00 
  80237d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80237f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802386:	00 00 00 
  802389:	8b 00                	mov    (%rax),%eax
  80238b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80238e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802393:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80239a:	00 00 00 
  80239d:	89 c7                	mov    %eax,%edi
  80239f:	48 b8 76 34 80 00 00 	movabs $0x803476,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8023ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023af:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b4:	48 89 c6             	mov    %rax,%rsi
  8023b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023bc:	48 b8 b5 33 80 00 00 	movabs $0x8033b5,%rax
  8023c3:	00 00 00 
  8023c6:	ff d0                	callq  *%rax
}
  8023c8:	c9                   	leaveq 
  8023c9:	c3                   	retq   

00000000008023ca <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023ca:	55                   	push   %rbp
  8023cb:	48 89 e5             	mov    %rsp,%rbp
  8023ce:	48 83 ec 20          	sub    $0x20,%rsp
  8023d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023d6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8023d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dd:	48 89 c7             	mov    %rax,%rdi
  8023e0:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
  8023ec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023f1:	7e 0a                	jle    8023fd <open+0x33>
		return -E_BAD_PATH;
  8023f3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8023f8:	e9 a5 00 00 00       	jmpq   8024a2 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8023fd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802401:	48 89 c7             	mov    %rax,%rdi
  802404:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
  802410:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802413:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802417:	79 08                	jns    802421 <open+0x57>
		return r;
  802419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241c:	e9 81 00 00 00       	jmpq   8024a2 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802425:	48 89 c6             	mov    %rax,%rsi
  802428:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80242f:	00 00 00 
  802432:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  802439:	00 00 00 
  80243c:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80243e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802445:	00 00 00 
  802448:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80244b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802455:	48 89 c6             	mov    %rax,%rsi
  802458:	bf 01 00 00 00       	mov    $0x1,%edi
  80245d:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax
  802469:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802470:	79 1d                	jns    80248f <open+0xc5>
		fd_close(fd, 0);
  802472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802476:	be 00 00 00 00       	mov    $0x0,%esi
  80247b:	48 89 c7             	mov    %rax,%rdi
  80247e:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  802485:	00 00 00 
  802488:	ff d0                	callq  *%rax
		return r;
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248d:	eb 13                	jmp    8024a2 <open+0xd8>
	}

	return fd2num(fd);
  80248f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802493:	48 89 c7             	mov    %rax,%rdi
  802496:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8024a2:	c9                   	leaveq 
  8024a3:	c3                   	retq   

00000000008024a4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8024a4:	55                   	push   %rbp
  8024a5:	48 89 e5             	mov    %rsp,%rbp
  8024a8:	48 83 ec 10          	sub    $0x10,%rsp
  8024ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8024b7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024be:	00 00 00 
  8024c1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8024c3:	be 00 00 00 00       	mov    $0x0,%esi
  8024c8:	bf 06 00 00 00       	mov    $0x6,%edi
  8024cd:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  8024d4:	00 00 00 
  8024d7:	ff d0                	callq  *%rax
}
  8024d9:	c9                   	leaveq 
  8024da:	c3                   	retq   

00000000008024db <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8024db:	55                   	push   %rbp
  8024dc:	48 89 e5             	mov    %rsp,%rbp
  8024df:	48 83 ec 30          	sub    $0x30,%rsp
  8024e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f3:	8b 50 0c             	mov    0xc(%rax),%edx
  8024f6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024fd:	00 00 00 
  802500:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802502:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802509:	00 00 00 
  80250c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802510:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802514:	be 00 00 00 00       	mov    $0x0,%esi
  802519:	bf 03 00 00 00       	mov    $0x3,%edi
  80251e:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  802525:	00 00 00 
  802528:	ff d0                	callq  *%rax
  80252a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802531:	79 08                	jns    80253b <devfile_read+0x60>
		return r;
  802533:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802536:	e9 a4 00 00 00       	jmpq   8025df <devfile_read+0x104>
	assert(r <= n);
  80253b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253e:	48 98                	cltq   
  802540:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802544:	76 35                	jbe    80257b <devfile_read+0xa0>
  802546:	48 b9 dd 3b 80 00 00 	movabs $0x803bdd,%rcx
  80254d:	00 00 00 
  802550:	48 ba e4 3b 80 00 00 	movabs $0x803be4,%rdx
  802557:	00 00 00 
  80255a:	be 84 00 00 00       	mov    $0x84,%esi
  80255f:	48 bf f9 3b 80 00 00 	movabs $0x803bf9,%rdi
  802566:	00 00 00 
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
  80256e:	49 b8 a1 32 80 00 00 	movabs $0x8032a1,%r8
  802575:	00 00 00 
  802578:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80257b:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802582:	7e 35                	jle    8025b9 <devfile_read+0xde>
  802584:	48 b9 04 3c 80 00 00 	movabs $0x803c04,%rcx
  80258b:	00 00 00 
  80258e:	48 ba e4 3b 80 00 00 	movabs $0x803be4,%rdx
  802595:	00 00 00 
  802598:	be 85 00 00 00       	mov    $0x85,%esi
  80259d:	48 bf f9 3b 80 00 00 	movabs $0x803bf9,%rdi
  8025a4:	00 00 00 
  8025a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ac:	49 b8 a1 32 80 00 00 	movabs $0x8032a1,%r8
  8025b3:	00 00 00 
  8025b6:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8025b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bc:	48 63 d0             	movslq %eax,%rdx
  8025bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8025ca:	00 00 00 
  8025cd:	48 89 c7             	mov    %rax,%rdi
  8025d0:	48 b8 64 11 80 00 00 	movabs $0x801164,%rax
  8025d7:	00 00 00 
  8025da:	ff d0                	callq  *%rax
	return r;
  8025dc:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8025df:	c9                   	leaveq 
  8025e0:	c3                   	retq   

00000000008025e1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8025e1:	55                   	push   %rbp
  8025e2:	48 89 e5             	mov    %rsp,%rbp
  8025e5:	48 83 ec 30          	sub    $0x30,%rsp
  8025e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f9:	8b 50 0c             	mov    0xc(%rax),%edx
  8025fc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802603:	00 00 00 
  802606:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802608:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80260f:	00 00 00 
  802612:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802616:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80261a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802621:	00 
  802622:	76 35                	jbe    802659 <devfile_write+0x78>
  802624:	48 b9 10 3c 80 00 00 	movabs $0x803c10,%rcx
  80262b:	00 00 00 
  80262e:	48 ba e4 3b 80 00 00 	movabs $0x803be4,%rdx
  802635:	00 00 00 
  802638:	be 9e 00 00 00       	mov    $0x9e,%esi
  80263d:	48 bf f9 3b 80 00 00 	movabs $0x803bf9,%rdi
  802644:	00 00 00 
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	49 b8 a1 32 80 00 00 	movabs $0x8032a1,%r8
  802653:	00 00 00 
  802656:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802659:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80265d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802661:	48 89 c6             	mov    %rax,%rsi
  802664:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80266b:	00 00 00 
  80266e:	48 b8 7b 12 80 00 00 	movabs $0x80127b,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80267a:	be 00 00 00 00       	mov    $0x0,%esi
  80267f:	bf 04 00 00 00       	mov    $0x4,%edi
  802684:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  80268b:	00 00 00 
  80268e:	ff d0                	callq  *%rax
  802690:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802693:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802697:	79 05                	jns    80269e <devfile_write+0xbd>
		return r;
  802699:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269c:	eb 43                	jmp    8026e1 <devfile_write+0x100>
	assert(r <= n);
  80269e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a1:	48 98                	cltq   
  8026a3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8026a7:	76 35                	jbe    8026de <devfile_write+0xfd>
  8026a9:	48 b9 dd 3b 80 00 00 	movabs $0x803bdd,%rcx
  8026b0:	00 00 00 
  8026b3:	48 ba e4 3b 80 00 00 	movabs $0x803be4,%rdx
  8026ba:	00 00 00 
  8026bd:	be a2 00 00 00       	mov    $0xa2,%esi
  8026c2:	48 bf f9 3b 80 00 00 	movabs $0x803bf9,%rdi
  8026c9:	00 00 00 
  8026cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d1:	49 b8 a1 32 80 00 00 	movabs $0x8032a1,%r8
  8026d8:	00 00 00 
  8026db:	41 ff d0             	callq  *%r8
	return r;
  8026de:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8026e1:	c9                   	leaveq 
  8026e2:	c3                   	retq   

00000000008026e3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026e3:	55                   	push   %rbp
  8026e4:	48 89 e5             	mov    %rsp,%rbp
  8026e7:	48 83 ec 20          	sub    $0x20,%rsp
  8026eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8026f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f7:	8b 50 0c             	mov    0xc(%rax),%edx
  8026fa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802701:	00 00 00 
  802704:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802706:	be 00 00 00 00       	mov    $0x0,%esi
  80270b:	bf 05 00 00 00       	mov    $0x5,%edi
  802710:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  802717:	00 00 00 
  80271a:	ff d0                	callq  *%rax
  80271c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802723:	79 05                	jns    80272a <devfile_stat+0x47>
		return r;
  802725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802728:	eb 56                	jmp    802780 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80272a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80272e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802735:	00 00 00 
  802738:	48 89 c7             	mov    %rax,%rdi
  80273b:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  802742:	00 00 00 
  802745:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802747:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80274e:	00 00 00 
  802751:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802757:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80275b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802761:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802768:	00 00 00 
  80276b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802771:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802775:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802780:	c9                   	leaveq 
  802781:	c3                   	retq   

0000000000802782 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802782:	55                   	push   %rbp
  802783:	48 89 e5             	mov    %rsp,%rbp
  802786:	48 83 ec 10          	sub    $0x10,%rsp
  80278a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80278e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802795:	8b 50 0c             	mov    0xc(%rax),%edx
  802798:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80279f:	00 00 00 
  8027a2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8027a4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027ab:	00 00 00 
  8027ae:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8027b4:	be 00 00 00 00       	mov    $0x0,%esi
  8027b9:	bf 02 00 00 00       	mov    $0x2,%edi
  8027be:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	callq  *%rax
}
  8027ca:	c9                   	leaveq 
  8027cb:	c3                   	retq   

00000000008027cc <remove>:

// Delete a file
int
remove(const char *path)
{
  8027cc:	55                   	push   %rbp
  8027cd:	48 89 e5             	mov    %rsp,%rbp
  8027d0:	48 83 ec 10          	sub    $0x10,%rsp
  8027d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8027d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027dc:	48 89 c7             	mov    %rax,%rdi
  8027df:	48 b8 d4 0d 80 00 00 	movabs $0x800dd4,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	callq  *%rax
  8027eb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027f0:	7e 07                	jle    8027f9 <remove+0x2d>
		return -E_BAD_PATH;
  8027f2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027f7:	eb 33                	jmp    80282c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8027f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fd:	48 89 c6             	mov    %rax,%rsi
  802800:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802807:	00 00 00 
  80280a:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  802811:	00 00 00 
  802814:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802816:	be 00 00 00 00       	mov    $0x0,%esi
  80281b:	bf 07 00 00 00       	mov    $0x7,%edi
  802820:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax
}
  80282c:	c9                   	leaveq 
  80282d:	c3                   	retq   

000000000080282e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80282e:	55                   	push   %rbp
  80282f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802832:	be 00 00 00 00       	mov    $0x0,%esi
  802837:	bf 08 00 00 00       	mov    $0x8,%edi
  80283c:	48 b8 43 23 80 00 00 	movabs $0x802343,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
}
  802848:	5d                   	pop    %rbp
  802849:	c3                   	retq   

000000000080284a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80284a:	55                   	push   %rbp
  80284b:	48 89 e5             	mov    %rsp,%rbp
  80284e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802855:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80285c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802863:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80286a:	be 00 00 00 00       	mov    $0x0,%esi
  80286f:	48 89 c7             	mov    %rax,%rdi
  802872:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
  80287e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802885:	79 28                	jns    8028af <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802887:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288a:	89 c6                	mov    %eax,%esi
  80288c:	48 bf 3d 3c 80 00 00 	movabs $0x803c3d,%rdi
  802893:	00 00 00 
  802896:	b8 00 00 00 00       	mov    $0x0,%eax
  80289b:	48 ba 78 02 80 00 00 	movabs $0x800278,%rdx
  8028a2:	00 00 00 
  8028a5:	ff d2                	callq  *%rdx
		return fd_src;
  8028a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028aa:	e9 74 01 00 00       	jmpq   802a23 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8028af:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8028b6:	be 01 01 00 00       	mov    $0x101,%esi
  8028bb:	48 89 c7             	mov    %rax,%rdi
  8028be:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	callq  *%rax
  8028ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8028cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028d1:	79 39                	jns    80290c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8028d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028d6:	89 c6                	mov    %eax,%esi
  8028d8:	48 bf 53 3c 80 00 00 	movabs $0x803c53,%rdi
  8028df:	00 00 00 
  8028e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e7:	48 ba 78 02 80 00 00 	movabs $0x800278,%rdx
  8028ee:	00 00 00 
  8028f1:	ff d2                	callq  *%rdx
		close(fd_src);
  8028f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f6:	89 c7                	mov    %eax,%edi
  8028f8:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
		return fd_dest;
  802904:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802907:	e9 17 01 00 00       	jmpq   802a23 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80290c:	eb 74                	jmp    802982 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80290e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802911:	48 63 d0             	movslq %eax,%rdx
  802914:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80291b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80291e:	48 89 ce             	mov    %rcx,%rsi
  802921:	89 c7                	mov    %eax,%edi
  802923:	48 b8 3e 20 80 00 00 	movabs $0x80203e,%rax
  80292a:	00 00 00 
  80292d:	ff d0                	callq  *%rax
  80292f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802932:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802936:	79 4a                	jns    802982 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802938:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80293b:	89 c6                	mov    %eax,%esi
  80293d:	48 bf 6d 3c 80 00 00 	movabs $0x803c6d,%rdi
  802944:	00 00 00 
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
  80294c:	48 ba 78 02 80 00 00 	movabs $0x800278,%rdx
  802953:	00 00 00 
  802956:	ff d2                	callq  *%rdx
			close(fd_src);
  802958:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295b:	89 c7                	mov    %eax,%edi
  80295d:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  802964:	00 00 00 
  802967:	ff d0                	callq  *%rax
			close(fd_dest);
  802969:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80296c:	89 c7                	mov    %eax,%edi
  80296e:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  802975:	00 00 00 
  802978:	ff d0                	callq  *%rax
			return write_size;
  80297a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80297d:	e9 a1 00 00 00       	jmpq   802a23 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802982:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802989:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298c:	ba 00 02 00 00       	mov    $0x200,%edx
  802991:	48 89 ce             	mov    %rcx,%rsi
  802994:	89 c7                	mov    %eax,%edi
  802996:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  80299d:	00 00 00 
  8029a0:	ff d0                	callq  *%rax
  8029a2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8029a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029a9:	0f 8f 5f ff ff ff    	jg     80290e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8029af:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029b3:	79 47                	jns    8029fc <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8029b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029b8:	89 c6                	mov    %eax,%esi
  8029ba:	48 bf 80 3c 80 00 00 	movabs $0x803c80,%rdi
  8029c1:	00 00 00 
  8029c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c9:	48 ba 78 02 80 00 00 	movabs $0x800278,%rdx
  8029d0:	00 00 00 
  8029d3:	ff d2                	callq  *%rdx
		close(fd_src);
  8029d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d8:	89 c7                	mov    %eax,%edi
  8029da:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8029e1:	00 00 00 
  8029e4:	ff d0                	callq  *%rax
		close(fd_dest);
  8029e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029e9:	89 c7                	mov    %eax,%edi
  8029eb:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
		return read_size;
  8029f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029fa:	eb 27                	jmp    802a23 <copy+0x1d9>
	}
	close(fd_src);
  8029fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ff:	89 c7                	mov    %eax,%edi
  802a01:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
	close(fd_dest);
  802a0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a10:	89 c7                	mov    %eax,%edi
  802a12:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
	return 0;
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802a23:	c9                   	leaveq 
  802a24:	c3                   	retq   

0000000000802a25 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a25:	55                   	push   %rbp
  802a26:	48 89 e5             	mov    %rsp,%rbp
  802a29:	53                   	push   %rbx
  802a2a:	48 83 ec 38          	sub    $0x38,%rsp
  802a2e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a32:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a36:	48 89 c7             	mov    %rax,%rdi
  802a39:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
  802a45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a48:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a4c:	0f 88 bf 01 00 00    	js     802c11 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a56:	ba 07 04 00 00       	mov    $0x407,%edx
  802a5b:	48 89 c6             	mov    %rax,%rsi
  802a5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a63:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  802a6a:	00 00 00 
  802a6d:	ff d0                	callq  *%rax
  802a6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a72:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a76:	0f 88 95 01 00 00    	js     802c11 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802a7c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802a80:	48 89 c7             	mov    %rax,%rdi
  802a83:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a92:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a96:	0f 88 5d 01 00 00    	js     802bf9 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aa0:	ba 07 04 00 00       	mov    $0x407,%edx
  802aa5:	48 89 c6             	mov    %rax,%rsi
  802aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  802aad:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
  802ab9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802abc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ac0:	0f 88 33 01 00 00    	js     802bf9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aca:	48 89 c7             	mov    %rax,%rdi
  802acd:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  802ad4:	00 00 00 
  802ad7:	ff d0                	callq  *%rax
  802ad9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802add:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae1:	ba 07 04 00 00       	mov    $0x407,%edx
  802ae6:	48 89 c6             	mov    %rax,%rsi
  802ae9:	bf 00 00 00 00       	mov    $0x0,%edi
  802aee:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	callq  *%rax
  802afa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802afd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b01:	79 05                	jns    802b08 <pipe+0xe3>
		goto err2;
  802b03:	e9 d9 00 00 00       	jmpq   802be1 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b0c:	48 89 c7             	mov    %rax,%rdi
  802b0f:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	48 89 c2             	mov    %rax,%rdx
  802b1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b22:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b28:	48 89 d1             	mov    %rdx,%rcx
  802b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b30:	48 89 c6             	mov    %rax,%rsi
  802b33:	bf 00 00 00 00       	mov    $0x0,%edi
  802b38:	48 b8 bf 17 80 00 00 	movabs $0x8017bf,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
  802b44:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b47:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b4b:	79 1b                	jns    802b68 <pipe+0x143>
		goto err3;
  802b4d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802b4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b52:	48 89 c6             	mov    %rax,%rsi
  802b55:	bf 00 00 00 00       	mov    $0x0,%edi
  802b5a:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  802b61:	00 00 00 
  802b64:	ff d0                	callq  *%rax
  802b66:	eb 79                	jmp    802be1 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b6c:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b73:	00 00 00 
  802b76:	8b 12                	mov    (%rdx),%edx
  802b78:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802b7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b89:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b90:	00 00 00 
  802b93:	8b 12                	mov    (%rdx),%edx
  802b95:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802b97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b9b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802ba2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ba6:	48 89 c7             	mov    %rax,%rdi
  802ba9:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 c2                	mov    %eax,%edx
  802bb7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bbb:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802bbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bc1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802bc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bc9:	48 89 c7             	mov    %rax,%rdi
  802bcc:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	callq  *%rax
  802bd8:	89 03                	mov    %eax,(%rbx)
	return 0;
  802bda:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdf:	eb 33                	jmp    802c14 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802be1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be5:	48 89 c6             	mov    %rax,%rsi
  802be8:	bf 00 00 00 00       	mov    $0x0,%edi
  802bed:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802bf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bfd:	48 89 c6             	mov    %rax,%rsi
  802c00:	bf 00 00 00 00       	mov    $0x0,%edi
  802c05:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
err:
	return r;
  802c11:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c14:	48 83 c4 38          	add    $0x38,%rsp
  802c18:	5b                   	pop    %rbx
  802c19:	5d                   	pop    %rbp
  802c1a:	c3                   	retq   

0000000000802c1b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c1b:	55                   	push   %rbp
  802c1c:	48 89 e5             	mov    %rsp,%rbp
  802c1f:	53                   	push   %rbx
  802c20:	48 83 ec 28          	sub    $0x28,%rsp
  802c24:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c28:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c2c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c33:	00 00 00 
  802c36:	48 8b 00             	mov    (%rax),%rax
  802c39:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c3f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c46:	48 89 c7             	mov    %rax,%rdi
  802c49:	48 b8 90 35 80 00 00 	movabs $0x803590,%rax
  802c50:	00 00 00 
  802c53:	ff d0                	callq  *%rax
  802c55:	89 c3                	mov    %eax,%ebx
  802c57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c5b:	48 89 c7             	mov    %rax,%rdi
  802c5e:	48 b8 90 35 80 00 00 	movabs $0x803590,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
  802c6a:	39 c3                	cmp    %eax,%ebx
  802c6c:	0f 94 c0             	sete   %al
  802c6f:	0f b6 c0             	movzbl %al,%eax
  802c72:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802c75:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c7c:	00 00 00 
  802c7f:	48 8b 00             	mov    (%rax),%rax
  802c82:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c88:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802c8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c8e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c91:	75 05                	jne    802c98 <_pipeisclosed+0x7d>
			return ret;
  802c93:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c96:	eb 4f                	jmp    802ce7 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802c98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c9b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c9e:	74 42                	je     802ce2 <_pipeisclosed+0xc7>
  802ca0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802ca4:	75 3c                	jne    802ce2 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802ca6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cad:	00 00 00 
  802cb0:	48 8b 00             	mov    (%rax),%rax
  802cb3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802cb9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802cbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cbf:	89 c6                	mov    %eax,%esi
  802cc1:	48 bf 9b 3c 80 00 00 	movabs $0x803c9b,%rdi
  802cc8:	00 00 00 
  802ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd0:	49 b8 78 02 80 00 00 	movabs $0x800278,%r8
  802cd7:	00 00 00 
  802cda:	41 ff d0             	callq  *%r8
	}
  802cdd:	e9 4a ff ff ff       	jmpq   802c2c <_pipeisclosed+0x11>
  802ce2:	e9 45 ff ff ff       	jmpq   802c2c <_pipeisclosed+0x11>
}
  802ce7:	48 83 c4 28          	add    $0x28,%rsp
  802ceb:	5b                   	pop    %rbx
  802cec:	5d                   	pop    %rbp
  802ced:	c3                   	retq   

0000000000802cee <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802cee:	55                   	push   %rbp
  802cef:	48 89 e5             	mov    %rsp,%rbp
  802cf2:	48 83 ec 30          	sub    $0x30,%rsp
  802cf6:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cf9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cfd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d00:	48 89 d6             	mov    %rdx,%rsi
  802d03:	89 c7                	mov    %eax,%edi
  802d05:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
  802d11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d18:	79 05                	jns    802d1f <pipeisclosed+0x31>
		return r;
  802d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1d:	eb 31                	jmp    802d50 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d23:	48 89 c7             	mov    %rax,%rdi
  802d26:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  802d2d:	00 00 00 
  802d30:	ff d0                	callq  *%rax
  802d32:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d3e:	48 89 d6             	mov    %rdx,%rsi
  802d41:	48 89 c7             	mov    %rax,%rdi
  802d44:	48 b8 1b 2c 80 00 00 	movabs $0x802c1b,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	callq  *%rax
}
  802d50:	c9                   	leaveq 
  802d51:	c3                   	retq   

0000000000802d52 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d52:	55                   	push   %rbp
  802d53:	48 89 e5             	mov    %rsp,%rbp
  802d56:	48 83 ec 40          	sub    $0x40,%rsp
  802d5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d62:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d6a:	48 89 c7             	mov    %rax,%rdi
  802d6d:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
  802d79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802d7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d85:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d8c:	00 
  802d8d:	e9 92 00 00 00       	jmpq   802e24 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802d92:	eb 41                	jmp    802dd5 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d94:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802d99:	74 09                	je     802da4 <devpipe_read+0x52>
				return i;
  802d9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9f:	e9 92 00 00 00       	jmpq   802e36 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802da4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dac:	48 89 d6             	mov    %rdx,%rsi
  802daf:	48 89 c7             	mov    %rax,%rdi
  802db2:	48 b8 1b 2c 80 00 00 	movabs $0x802c1b,%rax
  802db9:	00 00 00 
  802dbc:	ff d0                	callq  *%rax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	74 07                	je     802dc9 <devpipe_read+0x77>
				return 0;
  802dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc7:	eb 6d                	jmp    802e36 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802dc9:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd9:	8b 10                	mov    (%rax),%edx
  802ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddf:	8b 40 04             	mov    0x4(%rax),%eax
  802de2:	39 c2                	cmp    %eax,%edx
  802de4:	74 ae                	je     802d94 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802de6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dee:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df6:	8b 00                	mov    (%rax),%eax
  802df8:	99                   	cltd   
  802df9:	c1 ea 1b             	shr    $0x1b,%edx
  802dfc:	01 d0                	add    %edx,%eax
  802dfe:	83 e0 1f             	and    $0x1f,%eax
  802e01:	29 d0                	sub    %edx,%eax
  802e03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e07:	48 98                	cltq   
  802e09:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e0e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e14:	8b 00                	mov    (%rax),%eax
  802e16:	8d 50 01             	lea    0x1(%rax),%edx
  802e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e1f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e28:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e2c:	0f 82 60 ff ff ff    	jb     802d92 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e36:	c9                   	leaveq 
  802e37:	c3                   	retq   

0000000000802e38 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e38:	55                   	push   %rbp
  802e39:	48 89 e5             	mov    %rsp,%rbp
  802e3c:	48 83 ec 40          	sub    $0x40,%rsp
  802e40:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e44:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e48:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e50:	48 89 c7             	mov    %rax,%rdi
  802e53:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  802e5a:	00 00 00 
  802e5d:	ff d0                	callq  *%rax
  802e5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802e63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802e6b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802e72:	00 
  802e73:	e9 8e 00 00 00       	jmpq   802f06 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e78:	eb 31                	jmp    802eab <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802e7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e82:	48 89 d6             	mov    %rdx,%rsi
  802e85:	48 89 c7             	mov    %rax,%rdi
  802e88:	48 b8 1b 2c 80 00 00 	movabs $0x802c1b,%rax
  802e8f:	00 00 00 
  802e92:	ff d0                	callq  *%rax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 07                	je     802e9f <devpipe_write+0x67>
				return 0;
  802e98:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9d:	eb 79                	jmp    802f18 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802e9f:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eaf:	8b 40 04             	mov    0x4(%rax),%eax
  802eb2:	48 63 d0             	movslq %eax,%rdx
  802eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb9:	8b 00                	mov    (%rax),%eax
  802ebb:	48 98                	cltq   
  802ebd:	48 83 c0 20          	add    $0x20,%rax
  802ec1:	48 39 c2             	cmp    %rax,%rdx
  802ec4:	73 b4                	jae    802e7a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ec6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eca:	8b 40 04             	mov    0x4(%rax),%eax
  802ecd:	99                   	cltd   
  802ece:	c1 ea 1b             	shr    $0x1b,%edx
  802ed1:	01 d0                	add    %edx,%eax
  802ed3:	83 e0 1f             	and    $0x1f,%eax
  802ed6:	29 d0                	sub    %edx,%eax
  802ed8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802edc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ee0:	48 01 ca             	add    %rcx,%rdx
  802ee3:	0f b6 0a             	movzbl (%rdx),%ecx
  802ee6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eea:	48 98                	cltq   
  802eec:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802ef0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef4:	8b 40 04             	mov    0x4(%rax),%eax
  802ef7:	8d 50 01             	lea    0x1(%rax),%edx
  802efa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efe:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f01:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f0e:	0f 82 64 ff ff ff    	jb     802e78 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f18:	c9                   	leaveq 
  802f19:	c3                   	retq   

0000000000802f1a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f1a:	55                   	push   %rbp
  802f1b:	48 89 e5             	mov    %rsp,%rbp
  802f1e:	48 83 ec 20          	sub    $0x20,%rsp
  802f22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2e:	48 89 c7             	mov    %rax,%rdi
  802f31:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f45:	48 be ae 3c 80 00 00 	movabs $0x803cae,%rsi
  802f4c:	00 00 00 
  802f4f:	48 89 c7             	mov    %rax,%rdi
  802f52:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f62:	8b 50 04             	mov    0x4(%rax),%edx
  802f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f69:	8b 00                	mov    (%rax),%eax
  802f6b:	29 c2                	sub    %eax,%edx
  802f6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f71:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802f77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f82:	00 00 00 
	stat->st_dev = &devpipe;
  802f85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f89:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802f90:	00 00 00 
  802f93:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802f9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f9f:	c9                   	leaveq 
  802fa0:	c3                   	retq   

0000000000802fa1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802fa1:	55                   	push   %rbp
  802fa2:	48 89 e5             	mov    %rsp,%rbp
  802fa5:	48 83 ec 10          	sub    $0x10,%rsp
  802fa9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802fad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb1:	48 89 c6             	mov    %rax,%rsi
  802fb4:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb9:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc9:	48 89 c7             	mov    %rax,%rdi
  802fcc:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  802fd3:	00 00 00 
  802fd6:	ff d0                	callq  *%rax
  802fd8:	48 89 c6             	mov    %rax,%rsi
  802fdb:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe0:	48 b8 1a 18 80 00 00 	movabs $0x80181a,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
}
  802fec:	c9                   	leaveq 
  802fed:	c3                   	retq   

0000000000802fee <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802fee:	55                   	push   %rbp
  802fef:	48 89 e5             	mov    %rsp,%rbp
  802ff2:	48 83 ec 20          	sub    $0x20,%rsp
  802ff6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802ff9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ffc:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802fff:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803003:	be 01 00 00 00       	mov    $0x1,%esi
  803008:	48 89 c7             	mov    %rax,%rdi
  80300b:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  803012:	00 00 00 
  803015:	ff d0                	callq  *%rax
}
  803017:	c9                   	leaveq 
  803018:	c3                   	retq   

0000000000803019 <getchar>:

int
getchar(void)
{
  803019:	55                   	push   %rbp
  80301a:	48 89 e5             	mov    %rsp,%rbp
  80301d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803021:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803025:	ba 01 00 00 00       	mov    $0x1,%edx
  80302a:	48 89 c6             	mov    %rax,%rsi
  80302d:	bf 00 00 00 00       	mov    $0x0,%edi
  803032:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
  80303e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803041:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803045:	79 05                	jns    80304c <getchar+0x33>
		return r;
  803047:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304a:	eb 14                	jmp    803060 <getchar+0x47>
	if (r < 1)
  80304c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803050:	7f 07                	jg     803059 <getchar+0x40>
		return -E_EOF;
  803052:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803057:	eb 07                	jmp    803060 <getchar+0x47>
	return c;
  803059:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80305d:	0f b6 c0             	movzbl %al,%eax
}
  803060:	c9                   	leaveq 
  803061:	c3                   	retq   

0000000000803062 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803062:	55                   	push   %rbp
  803063:	48 89 e5             	mov    %rsp,%rbp
  803066:	48 83 ec 20          	sub    $0x20,%rsp
  80306a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80306d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803071:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803074:	48 89 d6             	mov    %rdx,%rsi
  803077:	89 c7                	mov    %eax,%edi
  803079:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
  803085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308c:	79 05                	jns    803093 <iscons+0x31>
		return r;
  80308e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803091:	eb 1a                	jmp    8030ad <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803097:	8b 10                	mov    (%rax),%edx
  803099:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8030a0:	00 00 00 
  8030a3:	8b 00                	mov    (%rax),%eax
  8030a5:	39 c2                	cmp    %eax,%edx
  8030a7:	0f 94 c0             	sete   %al
  8030aa:	0f b6 c0             	movzbl %al,%eax
}
  8030ad:	c9                   	leaveq 
  8030ae:	c3                   	retq   

00000000008030af <opencons>:

int
opencons(void)
{
  8030af:	55                   	push   %rbp
  8030b0:	48 89 e5             	mov    %rsp,%rbp
  8030b3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8030b7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030bb:	48 89 c7             	mov    %rax,%rdi
  8030be:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  8030c5:	00 00 00 
  8030c8:	ff d0                	callq  *%rax
  8030ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d1:	79 05                	jns    8030d8 <opencons+0x29>
		return r;
  8030d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d6:	eb 5b                	jmp    803133 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8030d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8030e1:	48 89 c6             	mov    %rax,%rsi
  8030e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e9:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  8030f0:	00 00 00 
  8030f3:	ff d0                	callq  *%rax
  8030f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030fc:	79 05                	jns    803103 <opencons+0x54>
		return r;
  8030fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803101:	eb 30                	jmp    803133 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803107:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80310e:	00 00 00 
  803111:	8b 12                	mov    (%rdx),%edx
  803113:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803119:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803124:	48 89 c7             	mov    %rax,%rdi
  803127:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
}
  803133:	c9                   	leaveq 
  803134:	c3                   	retq   

0000000000803135 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803135:	55                   	push   %rbp
  803136:	48 89 e5             	mov    %rsp,%rbp
  803139:	48 83 ec 30          	sub    $0x30,%rsp
  80313d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803141:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803145:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803149:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80314e:	75 07                	jne    803157 <devcons_read+0x22>
		return 0;
  803150:	b8 00 00 00 00       	mov    $0x0,%eax
  803155:	eb 4b                	jmp    8031a2 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803157:	eb 0c                	jmp    803165 <devcons_read+0x30>
		sys_yield();
  803159:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803165:	48 b8 71 16 80 00 00 	movabs $0x801671,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
  803171:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803174:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803178:	74 df                	je     803159 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80317a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317e:	79 05                	jns    803185 <devcons_read+0x50>
		return c;
  803180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803183:	eb 1d                	jmp    8031a2 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803185:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803189:	75 07                	jne    803192 <devcons_read+0x5d>
		return 0;
  80318b:	b8 00 00 00 00       	mov    $0x0,%eax
  803190:	eb 10                	jmp    8031a2 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803192:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803195:	89 c2                	mov    %eax,%edx
  803197:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319b:	88 10                	mov    %dl,(%rax)
	return 1;
  80319d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8031a2:	c9                   	leaveq 
  8031a3:	c3                   	retq   

00000000008031a4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8031a4:	55                   	push   %rbp
  8031a5:	48 89 e5             	mov    %rsp,%rbp
  8031a8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8031af:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8031b6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8031bd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8031c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031cb:	eb 76                	jmp    803243 <devcons_write+0x9f>
		m = n - tot;
  8031cd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8031d4:	89 c2                	mov    %eax,%edx
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	29 c2                	sub    %eax,%edx
  8031db:	89 d0                	mov    %edx,%eax
  8031dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8031e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e3:	83 f8 7f             	cmp    $0x7f,%eax
  8031e6:	76 07                	jbe    8031ef <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8031e8:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8031ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031f2:	48 63 d0             	movslq %eax,%rdx
  8031f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f8:	48 63 c8             	movslq %eax,%rcx
  8031fb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803202:	48 01 c1             	add    %rax,%rcx
  803205:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80320c:	48 89 ce             	mov    %rcx,%rsi
  80320f:	48 89 c7             	mov    %rax,%rdi
  803212:	48 b8 64 11 80 00 00 	movabs $0x801164,%rax
  803219:	00 00 00 
  80321c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80321e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803221:	48 63 d0             	movslq %eax,%rdx
  803224:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80322b:	48 89 d6             	mov    %rdx,%rsi
  80322e:	48 89 c7             	mov    %rax,%rdi
  803231:	48 b8 27 16 80 00 00 	movabs $0x801627,%rax
  803238:	00 00 00 
  80323b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80323d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803240:	01 45 fc             	add    %eax,-0x4(%rbp)
  803243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803246:	48 98                	cltq   
  803248:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80324f:	0f 82 78 ff ff ff    	jb     8031cd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803255:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803258:	c9                   	leaveq 
  803259:	c3                   	retq   

000000000080325a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80325a:	55                   	push   %rbp
  80325b:	48 89 e5             	mov    %rsp,%rbp
  80325e:	48 83 ec 08          	sub    $0x8,%rsp
  803262:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326b:	c9                   	leaveq 
  80326c:	c3                   	retq   

000000000080326d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80326d:	55                   	push   %rbp
  80326e:	48 89 e5             	mov    %rsp,%rbp
  803271:	48 83 ec 10          	sub    $0x10,%rsp
  803275:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803279:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80327d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803281:	48 be ba 3c 80 00 00 	movabs $0x803cba,%rsi
  803288:	00 00 00 
  80328b:	48 89 c7             	mov    %rax,%rdi
  80328e:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  803295:	00 00 00 
  803298:	ff d0                	callq  *%rax
	return 0;
  80329a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80329f:	c9                   	leaveq 
  8032a0:	c3                   	retq   

00000000008032a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8032a1:	55                   	push   %rbp
  8032a2:	48 89 e5             	mov    %rsp,%rbp
  8032a5:	53                   	push   %rbx
  8032a6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8032ad:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8032b4:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8032ba:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8032c1:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8032c8:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8032cf:	84 c0                	test   %al,%al
  8032d1:	74 23                	je     8032f6 <_panic+0x55>
  8032d3:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8032da:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8032de:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8032e2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8032e6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8032ea:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8032ee:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8032f2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8032f6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8032fd:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803304:	00 00 00 
  803307:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80330e:	00 00 00 
  803311:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803315:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80331c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803323:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80332a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803331:	00 00 00 
  803334:	48 8b 18             	mov    (%rax),%rbx
  803337:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
  803343:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803349:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803350:	41 89 c8             	mov    %ecx,%r8d
  803353:	48 89 d1             	mov    %rdx,%rcx
  803356:	48 89 da             	mov    %rbx,%rdx
  803359:	89 c6                	mov    %eax,%esi
  80335b:	48 bf c8 3c 80 00 00 	movabs $0x803cc8,%rdi
  803362:	00 00 00 
  803365:	b8 00 00 00 00       	mov    $0x0,%eax
  80336a:	49 b9 78 02 80 00 00 	movabs $0x800278,%r9
  803371:	00 00 00 
  803374:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803377:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80337e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803385:	48 89 d6             	mov    %rdx,%rsi
  803388:	48 89 c7             	mov    %rax,%rdi
  80338b:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
	cprintf("\n");
  803397:	48 bf eb 3c 80 00 00 	movabs $0x803ceb,%rdi
  80339e:	00 00 00 
  8033a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a6:	48 ba 78 02 80 00 00 	movabs $0x800278,%rdx
  8033ad:	00 00 00 
  8033b0:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8033b2:	cc                   	int3   
  8033b3:	eb fd                	jmp    8033b2 <_panic+0x111>

00000000008033b5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033b5:	55                   	push   %rbp
  8033b6:	48 89 e5             	mov    %rsp,%rbp
  8033b9:	48 83 ec 30          	sub    $0x30,%rsp
  8033bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8033c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033ce:	75 0e                	jne    8033de <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033d0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033d7:	00 00 00 
  8033da:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033e2:	48 89 c7             	mov    %rax,%rdi
  8033e5:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  8033ec:	00 00 00 
  8033ef:	ff d0                	callq  *%rax
  8033f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f8:	79 27                	jns    803421 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033fa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ff:	74 0a                	je     80340b <ipc_recv+0x56>
            *from_env_store = 0;
  803401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803405:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80340b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803410:	74 0a                	je     80341c <ipc_recv+0x67>
            *perm_store = 0;
  803412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803416:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80341c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341f:	eb 53                	jmp    803474 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803421:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803426:	74 19                	je     803441 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803428:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80342f:	00 00 00 
  803432:	48 8b 00             	mov    (%rax),%rax
  803435:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80343b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80343f:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803441:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803446:	74 19                	je     803461 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803448:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80344f:	00 00 00 
  803452:	48 8b 00             	mov    (%rax),%rax
  803455:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80345b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80345f:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803461:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803468:	00 00 00 
  80346b:	48 8b 00             	mov    (%rax),%rax
  80346e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803474:	c9                   	leaveq 
  803475:	c3                   	retq   

0000000000803476 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803476:	55                   	push   %rbp
  803477:	48 89 e5             	mov    %rsp,%rbp
  80347a:	48 83 ec 30          	sub    $0x30,%rsp
  80347e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803481:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803484:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803488:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80348b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803490:	75 0e                	jne    8034a0 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803492:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803499:	00 00 00 
  80349c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8034a0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8034a3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8034a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ad:	89 c7                	mov    %eax,%edi
  8034af:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  8034b6:	00 00 00 
  8034b9:	ff d0                	callq  *%rax
  8034bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8034be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c2:	79 36                	jns    8034fa <ipc_send+0x84>
  8034c4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034c8:	74 30                	je     8034fa <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8034ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cd:	89 c1                	mov    %eax,%ecx
  8034cf:	48 ba ed 3c 80 00 00 	movabs $0x803ced,%rdx
  8034d6:	00 00 00 
  8034d9:	be 49 00 00 00       	mov    $0x49,%esi
  8034de:	48 bf fa 3c 80 00 00 	movabs $0x803cfa,%rdi
  8034e5:	00 00 00 
  8034e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ed:	49 b8 a1 32 80 00 00 	movabs $0x8032a1,%r8
  8034f4:	00 00 00 
  8034f7:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034fa:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
    } while(r != 0);
  803506:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80350a:	75 94                	jne    8034a0 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80350c:	c9                   	leaveq 
  80350d:	c3                   	retq   

000000000080350e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80350e:	55                   	push   %rbp
  80350f:	48 89 e5             	mov    %rsp,%rbp
  803512:	48 83 ec 14          	sub    $0x14,%rsp
  803516:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803519:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803520:	eb 5e                	jmp    803580 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803522:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803529:	00 00 00 
  80352c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352f:	48 63 d0             	movslq %eax,%rdx
  803532:	48 89 d0             	mov    %rdx,%rax
  803535:	48 c1 e0 03          	shl    $0x3,%rax
  803539:	48 01 d0             	add    %rdx,%rax
  80353c:	48 c1 e0 05          	shl    $0x5,%rax
  803540:	48 01 c8             	add    %rcx,%rax
  803543:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803549:	8b 00                	mov    (%rax),%eax
  80354b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80354e:	75 2c                	jne    80357c <ipc_find_env+0x6e>
			return envs[i].env_id;
  803550:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803557:	00 00 00 
  80355a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355d:	48 63 d0             	movslq %eax,%rdx
  803560:	48 89 d0             	mov    %rdx,%rax
  803563:	48 c1 e0 03          	shl    $0x3,%rax
  803567:	48 01 d0             	add    %rdx,%rax
  80356a:	48 c1 e0 05          	shl    $0x5,%rax
  80356e:	48 01 c8             	add    %rcx,%rax
  803571:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803577:	8b 40 08             	mov    0x8(%rax),%eax
  80357a:	eb 12                	jmp    80358e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80357c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803580:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803587:	7e 99                	jle    803522 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80358e:	c9                   	leaveq 
  80358f:	c3                   	retq   

0000000000803590 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803590:	55                   	push   %rbp
  803591:	48 89 e5             	mov    %rsp,%rbp
  803594:	48 83 ec 18          	sub    $0x18,%rsp
  803598:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80359c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a0:	48 c1 e8 15          	shr    $0x15,%rax
  8035a4:	48 89 c2             	mov    %rax,%rdx
  8035a7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8035ae:	01 00 00 
  8035b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035b5:	83 e0 01             	and    $0x1,%eax
  8035b8:	48 85 c0             	test   %rax,%rax
  8035bb:	75 07                	jne    8035c4 <pageref+0x34>
		return 0;
  8035bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c2:	eb 53                	jmp    803617 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8035c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8035cc:	48 89 c2             	mov    %rax,%rdx
  8035cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035d6:	01 00 00 
  8035d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e5:	83 e0 01             	and    $0x1,%eax
  8035e8:	48 85 c0             	test   %rax,%rax
  8035eb:	75 07                	jne    8035f4 <pageref+0x64>
		return 0;
  8035ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f2:	eb 23                	jmp    803617 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f8:	48 c1 e8 0c          	shr    $0xc,%rax
  8035fc:	48 89 c2             	mov    %rax,%rdx
  8035ff:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803606:	00 00 00 
  803609:	48 c1 e2 04          	shl    $0x4,%rdx
  80360d:	48 01 d0             	add    %rdx,%rax
  803610:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803614:	0f b7 c0             	movzwl %ax,%eax
}
  803617:	c9                   	leaveq 
  803618:	c3                   	retq   
