
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
  800060:	48 bf 00 36 80 00 00 	movabs $0x803600,%rdi
  800067:	00 00 00 
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 ba 56 02 80 00 00 	movabs $0x800256,%rdx
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80008c:	48 b8 d1 16 80 00 00 	movabs $0x8016d1,%rax
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
  8000c1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c8:	00 00 00 
  8000cb:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000d2:	7e 14                	jle    8000e8 <libmain+0x6b>
		binaryname = argv[0];
  8000d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d8:	48 8b 10             	mov    (%rax),%rdx
  8000db:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
	close_all();
  800112:	48 b8 fb 1c 80 00 00 	movabs $0x801cfb,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80011e:	bf 00 00 00 00       	mov    $0x0,%edi
  800123:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
}
  80012f:	5d                   	pop    %rbp
  800130:	c3                   	retq   

0000000000800131 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800131:	55                   	push   %rbp
  800132:	48 89 e5             	mov    %rsp,%rbp
  800135:	48 83 ec 10          	sub    $0x10,%rsp
  800139:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80013c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800140:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800144:	8b 00                	mov    (%rax),%eax
  800146:	8d 48 01             	lea    0x1(%rax),%ecx
  800149:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80014d:	89 0a                	mov    %ecx,(%rdx)
  80014f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800152:	89 d1                	mov    %edx,%ecx
  800154:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800158:	48 98                	cltq   
  80015a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80015e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800162:	8b 00                	mov    (%rax),%eax
  800164:	3d ff 00 00 00       	cmp    $0xff,%eax
  800169:	75 2c                	jne    800197 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80016b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80016f:	8b 00                	mov    (%rax),%eax
  800171:	48 98                	cltq   
  800173:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800177:	48 83 c2 08          	add    $0x8,%rdx
  80017b:	48 89 c6             	mov    %rax,%rsi
  80017e:	48 89 d7             	mov    %rdx,%rdi
  800181:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  800188:	00 00 00 
  80018b:	ff d0                	callq  *%rax
        b->idx = 0;
  80018d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800191:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019b:	8b 40 04             	mov    0x4(%rax),%eax
  80019e:	8d 50 01             	lea    0x1(%rax),%edx
  8001a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a5:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001a8:	c9                   	leaveq 
  8001a9:	c3                   	retq   

00000000008001aa <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001aa:	55                   	push   %rbp
  8001ab:	48 89 e5             	mov    %rsp,%rbp
  8001ae:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001b5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001bc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001c3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001ca:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001d1:	48 8b 0a             	mov    (%rdx),%rcx
  8001d4:	48 89 08             	mov    %rcx,(%rax)
  8001d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001ee:	00 00 00 
    b.cnt = 0;
  8001f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001f8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001fb:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800202:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800209:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800210:	48 89 c6             	mov    %rax,%rsi
  800213:	48 bf 31 01 80 00 00 	movabs $0x800131,%rdi
  80021a:	00 00 00 
  80021d:	48 b8 09 06 80 00 00 	movabs $0x800609,%rax
  800224:	00 00 00 
  800227:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800229:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80022f:	48 98                	cltq   
  800231:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800238:	48 83 c2 08          	add    $0x8,%rdx
  80023c:	48 89 c6             	mov    %rax,%rsi
  80023f:	48 89 d7             	mov    %rdx,%rdi
  800242:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  800249:	00 00 00 
  80024c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80024e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800254:	c9                   	leaveq 
  800255:	c3                   	retq   

0000000000800256 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800256:	55                   	push   %rbp
  800257:	48 89 e5             	mov    %rsp,%rbp
  80025a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800261:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800268:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80026f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800276:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80027d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800284:	84 c0                	test   %al,%al
  800286:	74 20                	je     8002a8 <cprintf+0x52>
  800288:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80028c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800290:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800294:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800298:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80029c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002a0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002a4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002a8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002af:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002b6:	00 00 00 
  8002b9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002c0:	00 00 00 
  8002c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002ce:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002d5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002dc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002e3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002ea:	48 8b 0a             	mov    (%rdx),%rcx
  8002ed:	48 89 08             	mov    %rcx,(%rax)
  8002f0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002f4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002f8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002fc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800300:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800307:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80030e:	48 89 d6             	mov    %rdx,%rsi
  800311:	48 89 c7             	mov    %rax,%rdi
  800314:	48 b8 aa 01 80 00 00 	movabs $0x8001aa,%rax
  80031b:	00 00 00 
  80031e:	ff d0                	callq  *%rax
  800320:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800326:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80032c:	c9                   	leaveq 
  80032d:	c3                   	retq   

000000000080032e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032e:	55                   	push   %rbp
  80032f:	48 89 e5             	mov    %rsp,%rbp
  800332:	53                   	push   %rbx
  800333:	48 83 ec 38          	sub    $0x38,%rsp
  800337:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80033b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80033f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800343:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800346:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80034a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80034e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800351:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800355:	77 3b                	ja     800392 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800357:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80035a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80035e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800365:	ba 00 00 00 00       	mov    $0x0,%edx
  80036a:	48 f7 f3             	div    %rbx
  80036d:	48 89 c2             	mov    %rax,%rdx
  800370:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800373:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800376:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80037a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037e:	41 89 f9             	mov    %edi,%r9d
  800381:	48 89 c7             	mov    %rax,%rdi
  800384:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  80038b:	00 00 00 
  80038e:	ff d0                	callq  *%rax
  800390:	eb 1e                	jmp    8003b0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800392:	eb 12                	jmp    8003a6 <printnum+0x78>
			putch(padc, putdat);
  800394:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800398:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80039b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039f:	48 89 ce             	mov    %rcx,%rsi
  8003a2:	89 d7                	mov    %edx,%edi
  8003a4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003ae:	7f e4                	jg     800394 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bc:	48 f7 f1             	div    %rcx
  8003bf:	48 89 d0             	mov    %rdx,%rax
  8003c2:	48 ba 30 38 80 00 00 	movabs $0x803830,%rdx
  8003c9:	00 00 00 
  8003cc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003d0:	0f be d0             	movsbl %al,%edx
  8003d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003db:	48 89 ce             	mov    %rcx,%rsi
  8003de:	89 d7                	mov    %edx,%edi
  8003e0:	ff d0                	callq  *%rax
}
  8003e2:	48 83 c4 38          	add    $0x38,%rsp
  8003e6:	5b                   	pop    %rbx
  8003e7:	5d                   	pop    %rbp
  8003e8:	c3                   	retq   

00000000008003e9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e9:	55                   	push   %rbp
  8003ea:	48 89 e5             	mov    %rsp,%rbp
  8003ed:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8003f8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003fc:	7e 52                	jle    800450 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800402:	8b 00                	mov    (%rax),%eax
  800404:	83 f8 30             	cmp    $0x30,%eax
  800407:	73 24                	jae    80042d <getuint+0x44>
  800409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80040d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800411:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800415:	8b 00                	mov    (%rax),%eax
  800417:	89 c0                	mov    %eax,%eax
  800419:	48 01 d0             	add    %rdx,%rax
  80041c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420:	8b 12                	mov    (%rdx),%edx
  800422:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800425:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800429:	89 0a                	mov    %ecx,(%rdx)
  80042b:	eb 17                	jmp    800444 <getuint+0x5b>
  80042d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800431:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800435:	48 89 d0             	mov    %rdx,%rax
  800438:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80043c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800440:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800444:	48 8b 00             	mov    (%rax),%rax
  800447:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80044b:	e9 a3 00 00 00       	jmpq   8004f3 <getuint+0x10a>
	else if (lflag)
  800450:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800454:	74 4f                	je     8004a5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045a:	8b 00                	mov    (%rax),%eax
  80045c:	83 f8 30             	cmp    $0x30,%eax
  80045f:	73 24                	jae    800485 <getuint+0x9c>
  800461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800465:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800469:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046d:	8b 00                	mov    (%rax),%eax
  80046f:	89 c0                	mov    %eax,%eax
  800471:	48 01 d0             	add    %rdx,%rax
  800474:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800478:	8b 12                	mov    (%rdx),%edx
  80047a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80047d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800481:	89 0a                	mov    %ecx,(%rdx)
  800483:	eb 17                	jmp    80049c <getuint+0xb3>
  800485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800489:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80048d:	48 89 d0             	mov    %rdx,%rax
  800490:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800494:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800498:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80049c:	48 8b 00             	mov    (%rax),%rax
  80049f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004a3:	eb 4e                	jmp    8004f3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a9:	8b 00                	mov    (%rax),%eax
  8004ab:	83 f8 30             	cmp    $0x30,%eax
  8004ae:	73 24                	jae    8004d4 <getuint+0xeb>
  8004b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bc:	8b 00                	mov    (%rax),%eax
  8004be:	89 c0                	mov    %eax,%eax
  8004c0:	48 01 d0             	add    %rdx,%rax
  8004c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c7:	8b 12                	mov    (%rdx),%edx
  8004c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d0:	89 0a                	mov    %ecx,(%rdx)
  8004d2:	eb 17                	jmp    8004eb <getuint+0x102>
  8004d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004dc:	48 89 d0             	mov    %rdx,%rax
  8004df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004eb:	8b 00                	mov    (%rax),%eax
  8004ed:	89 c0                	mov    %eax,%eax
  8004ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004f7:	c9                   	leaveq 
  8004f8:	c3                   	retq   

00000000008004f9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f9:	55                   	push   %rbp
  8004fa:	48 89 e5             	mov    %rsp,%rbp
  8004fd:	48 83 ec 1c          	sub    $0x1c,%rsp
  800501:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800505:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800508:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80050c:	7e 52                	jle    800560 <getint+0x67>
		x=va_arg(*ap, long long);
  80050e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800512:	8b 00                	mov    (%rax),%eax
  800514:	83 f8 30             	cmp    $0x30,%eax
  800517:	73 24                	jae    80053d <getint+0x44>
  800519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800525:	8b 00                	mov    (%rax),%eax
  800527:	89 c0                	mov    %eax,%eax
  800529:	48 01 d0             	add    %rdx,%rax
  80052c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800530:	8b 12                	mov    (%rdx),%edx
  800532:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800535:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800539:	89 0a                	mov    %ecx,(%rdx)
  80053b:	eb 17                	jmp    800554 <getint+0x5b>
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800545:	48 89 d0             	mov    %rdx,%rax
  800548:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80054c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800550:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800554:	48 8b 00             	mov    (%rax),%rax
  800557:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80055b:	e9 a3 00 00 00       	jmpq   800603 <getint+0x10a>
	else if (lflag)
  800560:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800564:	74 4f                	je     8005b5 <getint+0xbc>
		x=va_arg(*ap, long);
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	8b 00                	mov    (%rax),%eax
  80056c:	83 f8 30             	cmp    $0x30,%eax
  80056f:	73 24                	jae    800595 <getint+0x9c>
  800571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800575:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057d:	8b 00                	mov    (%rax),%eax
  80057f:	89 c0                	mov    %eax,%eax
  800581:	48 01 d0             	add    %rdx,%rax
  800584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800588:	8b 12                	mov    (%rdx),%edx
  80058a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80058d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800591:	89 0a                	mov    %ecx,(%rdx)
  800593:	eb 17                	jmp    8005ac <getint+0xb3>
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80059d:	48 89 d0             	mov    %rdx,%rax
  8005a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ac:	48 8b 00             	mov    (%rax),%rax
  8005af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b3:	eb 4e                	jmp    800603 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b9:	8b 00                	mov    (%rax),%eax
  8005bb:	83 f8 30             	cmp    $0x30,%eax
  8005be:	73 24                	jae    8005e4 <getint+0xeb>
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cc:	8b 00                	mov    (%rax),%eax
  8005ce:	89 c0                	mov    %eax,%eax
  8005d0:	48 01 d0             	add    %rdx,%rax
  8005d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d7:	8b 12                	mov    (%rdx),%edx
  8005d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e0:	89 0a                	mov    %ecx,(%rdx)
  8005e2:	eb 17                	jmp    8005fb <getint+0x102>
  8005e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ec:	48 89 d0             	mov    %rdx,%rax
  8005ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005fb:	8b 00                	mov    (%rax),%eax
  8005fd:	48 98                	cltq   
  8005ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800607:	c9                   	leaveq 
  800608:	c3                   	retq   

0000000000800609 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800609:	55                   	push   %rbp
  80060a:	48 89 e5             	mov    %rsp,%rbp
  80060d:	41 54                	push   %r12
  80060f:	53                   	push   %rbx
  800610:	48 83 ec 60          	sub    $0x60,%rsp
  800614:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800618:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80061c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800620:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800624:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800628:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80062c:	48 8b 0a             	mov    (%rdx),%rcx
  80062f:	48 89 08             	mov    %rcx,(%rax)
  800632:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800636:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80063a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80063e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800642:	eb 17                	jmp    80065b <vprintfmt+0x52>
			if (ch == '\0')
  800644:	85 db                	test   %ebx,%ebx
  800646:	0f 84 df 04 00 00    	je     800b2b <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80064c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800650:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800654:	48 89 d6             	mov    %rdx,%rsi
  800657:	89 df                	mov    %ebx,%edi
  800659:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80065f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800663:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800667:	0f b6 00             	movzbl (%rax),%eax
  80066a:	0f b6 d8             	movzbl %al,%ebx
  80066d:	83 fb 25             	cmp    $0x25,%ebx
  800670:	75 d2                	jne    800644 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800672:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800676:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80067d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800684:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80068b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800692:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800696:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80069a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80069e:	0f b6 00             	movzbl (%rax),%eax
  8006a1:	0f b6 d8             	movzbl %al,%ebx
  8006a4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006a7:	83 f8 55             	cmp    $0x55,%eax
  8006aa:	0f 87 47 04 00 00    	ja     800af7 <vprintfmt+0x4ee>
  8006b0:	89 c0                	mov    %eax,%eax
  8006b2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006b9:	00 
  8006ba:	48 b8 58 38 80 00 00 	movabs $0x803858,%rax
  8006c1:	00 00 00 
  8006c4:	48 01 d0             	add    %rdx,%rax
  8006c7:	48 8b 00             	mov    (%rax),%rax
  8006ca:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006cc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006d0:	eb c0                	jmp    800692 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006d6:	eb ba                	jmp    800692 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006df:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006e2:	89 d0                	mov    %edx,%eax
  8006e4:	c1 e0 02             	shl    $0x2,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	01 c0                	add    %eax,%eax
  8006eb:	01 d8                	add    %ebx,%eax
  8006ed:	83 e8 30             	sub    $0x30,%eax
  8006f0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f7:	0f b6 00             	movzbl (%rax),%eax
  8006fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800700:	7e 0c                	jle    80070e <vprintfmt+0x105>
  800702:	83 fb 39             	cmp    $0x39,%ebx
  800705:	7f 07                	jg     80070e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800707:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80070c:	eb d1                	jmp    8006df <vprintfmt+0xd6>
			goto process_precision;
  80070e:	eb 58                	jmp    800768 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800710:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800713:	83 f8 30             	cmp    $0x30,%eax
  800716:	73 17                	jae    80072f <vprintfmt+0x126>
  800718:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80071c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80071f:	89 c0                	mov    %eax,%eax
  800721:	48 01 d0             	add    %rdx,%rax
  800724:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800727:	83 c2 08             	add    $0x8,%edx
  80072a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80072d:	eb 0f                	jmp    80073e <vprintfmt+0x135>
  80072f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800733:	48 89 d0             	mov    %rdx,%rax
  800736:	48 83 c2 08          	add    $0x8,%rdx
  80073a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80073e:	8b 00                	mov    (%rax),%eax
  800740:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800743:	eb 23                	jmp    800768 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800745:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800749:	79 0c                	jns    800757 <vprintfmt+0x14e>
				width = 0;
  80074b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800752:	e9 3b ff ff ff       	jmpq   800692 <vprintfmt+0x89>
  800757:	e9 36 ff ff ff       	jmpq   800692 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80075c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800763:	e9 2a ff ff ff       	jmpq   800692 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800768:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80076c:	79 12                	jns    800780 <vprintfmt+0x177>
				width = precision, precision = -1;
  80076e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800771:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800774:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80077b:	e9 12 ff ff ff       	jmpq   800692 <vprintfmt+0x89>
  800780:	e9 0d ff ff ff       	jmpq   800692 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800785:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800789:	e9 04 ff ff ff       	jmpq   800692 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80078e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800791:	83 f8 30             	cmp    $0x30,%eax
  800794:	73 17                	jae    8007ad <vprintfmt+0x1a4>
  800796:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80079a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079d:	89 c0                	mov    %eax,%eax
  80079f:	48 01 d0             	add    %rdx,%rax
  8007a2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a5:	83 c2 08             	add    $0x8,%edx
  8007a8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ab:	eb 0f                	jmp    8007bc <vprintfmt+0x1b3>
  8007ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b1:	48 89 d0             	mov    %rdx,%rax
  8007b4:	48 83 c2 08          	add    $0x8,%rdx
  8007b8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007bc:	8b 10                	mov    (%rax),%edx
  8007be:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c6:	48 89 ce             	mov    %rcx,%rsi
  8007c9:	89 d7                	mov    %edx,%edi
  8007cb:	ff d0                	callq  *%rax
			break;
  8007cd:	e9 53 03 00 00       	jmpq   800b25 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d5:	83 f8 30             	cmp    $0x30,%eax
  8007d8:	73 17                	jae    8007f1 <vprintfmt+0x1e8>
  8007da:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e1:	89 c0                	mov    %eax,%eax
  8007e3:	48 01 d0             	add    %rdx,%rax
  8007e6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007e9:	83 c2 08             	add    $0x8,%edx
  8007ec:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ef:	eb 0f                	jmp    800800 <vprintfmt+0x1f7>
  8007f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f5:	48 89 d0             	mov    %rdx,%rax
  8007f8:	48 83 c2 08          	add    $0x8,%rdx
  8007fc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800800:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800802:	85 db                	test   %ebx,%ebx
  800804:	79 02                	jns    800808 <vprintfmt+0x1ff>
				err = -err;
  800806:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800808:	83 fb 15             	cmp    $0x15,%ebx
  80080b:	7f 16                	jg     800823 <vprintfmt+0x21a>
  80080d:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  800814:	00 00 00 
  800817:	48 63 d3             	movslq %ebx,%rdx
  80081a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80081e:	4d 85 e4             	test   %r12,%r12
  800821:	75 2e                	jne    800851 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800823:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800827:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80082b:	89 d9                	mov    %ebx,%ecx
  80082d:	48 ba 41 38 80 00 00 	movabs $0x803841,%rdx
  800834:	00 00 00 
  800837:	48 89 c7             	mov    %rax,%rdi
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	49 b8 34 0b 80 00 00 	movabs $0x800b34,%r8
  800846:	00 00 00 
  800849:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80084c:	e9 d4 02 00 00       	jmpq   800b25 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800851:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800855:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800859:	4c 89 e1             	mov    %r12,%rcx
  80085c:	48 ba 4a 38 80 00 00 	movabs $0x80384a,%rdx
  800863:	00 00 00 
  800866:	48 89 c7             	mov    %rax,%rdi
  800869:	b8 00 00 00 00       	mov    $0x0,%eax
  80086e:	49 b8 34 0b 80 00 00 	movabs $0x800b34,%r8
  800875:	00 00 00 
  800878:	41 ff d0             	callq  *%r8
			break;
  80087b:	e9 a5 02 00 00       	jmpq   800b25 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800880:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800883:	83 f8 30             	cmp    $0x30,%eax
  800886:	73 17                	jae    80089f <vprintfmt+0x296>
  800888:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80088c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088f:	89 c0                	mov    %eax,%eax
  800891:	48 01 d0             	add    %rdx,%rax
  800894:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800897:	83 c2 08             	add    $0x8,%edx
  80089a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80089d:	eb 0f                	jmp    8008ae <vprintfmt+0x2a5>
  80089f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a3:	48 89 d0             	mov    %rdx,%rax
  8008a6:	48 83 c2 08          	add    $0x8,%rdx
  8008aa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ae:	4c 8b 20             	mov    (%rax),%r12
  8008b1:	4d 85 e4             	test   %r12,%r12
  8008b4:	75 0a                	jne    8008c0 <vprintfmt+0x2b7>
				p = "(null)";
  8008b6:	49 bc 4d 38 80 00 00 	movabs $0x80384d,%r12
  8008bd:	00 00 00 
			if (width > 0 && padc != '-')
  8008c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c4:	7e 3f                	jle    800905 <vprintfmt+0x2fc>
  8008c6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008ca:	74 39                	je     800905 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008cf:	48 98                	cltq   
  8008d1:	48 89 c6             	mov    %rax,%rsi
  8008d4:	4c 89 e7             	mov    %r12,%rdi
  8008d7:	48 b8 e0 0d 80 00 00 	movabs $0x800de0,%rax
  8008de:	00 00 00 
  8008e1:	ff d0                	callq  *%rax
  8008e3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008e6:	eb 17                	jmp    8008ff <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008e8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008ec:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f4:	48 89 ce             	mov    %rcx,%rsi
  8008f7:	89 d7                	mov    %edx,%edi
  8008f9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800903:	7f e3                	jg     8008e8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800905:	eb 37                	jmp    80093e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800907:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80090b:	74 1e                	je     80092b <vprintfmt+0x322>
  80090d:	83 fb 1f             	cmp    $0x1f,%ebx
  800910:	7e 05                	jle    800917 <vprintfmt+0x30e>
  800912:	83 fb 7e             	cmp    $0x7e,%ebx
  800915:	7e 14                	jle    80092b <vprintfmt+0x322>
					putch('?', putdat);
  800917:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80091b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091f:	48 89 d6             	mov    %rdx,%rsi
  800922:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800927:	ff d0                	callq  *%rax
  800929:	eb 0f                	jmp    80093a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80092b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800933:	48 89 d6             	mov    %rdx,%rsi
  800936:	89 df                	mov    %ebx,%edi
  800938:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80093e:	4c 89 e0             	mov    %r12,%rax
  800941:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800945:	0f b6 00             	movzbl (%rax),%eax
  800948:	0f be d8             	movsbl %al,%ebx
  80094b:	85 db                	test   %ebx,%ebx
  80094d:	74 10                	je     80095f <vprintfmt+0x356>
  80094f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800953:	78 b2                	js     800907 <vprintfmt+0x2fe>
  800955:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800959:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80095d:	79 a8                	jns    800907 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095f:	eb 16                	jmp    800977 <vprintfmt+0x36e>
				putch(' ', putdat);
  800961:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800965:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800969:	48 89 d6             	mov    %rdx,%rsi
  80096c:	bf 20 00 00 00       	mov    $0x20,%edi
  800971:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800973:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800977:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097b:	7f e4                	jg     800961 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80097d:	e9 a3 01 00 00       	jmpq   800b25 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800982:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800986:	be 03 00 00 00       	mov    $0x3,%esi
  80098b:	48 89 c7             	mov    %rax,%rdi
  80098e:	48 b8 f9 04 80 00 00 	movabs $0x8004f9,%rax
  800995:	00 00 00 
  800998:	ff d0                	callq  *%rax
  80099a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80099e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a2:	48 85 c0             	test   %rax,%rax
  8009a5:	79 1d                	jns    8009c4 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009a7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009af:	48 89 d6             	mov    %rdx,%rsi
  8009b2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009b7:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	48 f7 d8             	neg    %rax
  8009c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009c4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009cb:	e9 e8 00 00 00       	jmpq   800ab8 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009d0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009d4:	be 03 00 00 00       	mov    $0x3,%esi
  8009d9:	48 89 c7             	mov    %rax,%rdi
  8009dc:	48 b8 e9 03 80 00 00 	movabs $0x8003e9,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009ec:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009f3:	e9 c0 00 00 00       	jmpq   800ab8 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009f8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a00:	48 89 d6             	mov    %rdx,%rsi
  800a03:	bf 58 00 00 00       	mov    $0x58,%edi
  800a08:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a12:	48 89 d6             	mov    %rdx,%rsi
  800a15:	bf 58 00 00 00       	mov    $0x58,%edi
  800a1a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a24:	48 89 d6             	mov    %rdx,%rsi
  800a27:	bf 58 00 00 00       	mov    $0x58,%edi
  800a2c:	ff d0                	callq  *%rax
			break;
  800a2e:	e9 f2 00 00 00       	jmpq   800b25 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3b:	48 89 d6             	mov    %rdx,%rsi
  800a3e:	bf 30 00 00 00       	mov    $0x30,%edi
  800a43:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4d:	48 89 d6             	mov    %rdx,%rsi
  800a50:	bf 78 00 00 00       	mov    $0x78,%edi
  800a55:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5a:	83 f8 30             	cmp    $0x30,%eax
  800a5d:	73 17                	jae    800a76 <vprintfmt+0x46d>
  800a5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a66:	89 c0                	mov    %eax,%eax
  800a68:	48 01 d0             	add    %rdx,%rax
  800a6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a6e:	83 c2 08             	add    $0x8,%edx
  800a71:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a74:	eb 0f                	jmp    800a85 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7a:	48 89 d0             	mov    %rdx,%rax
  800a7d:	48 83 c2 08          	add    $0x8,%rdx
  800a81:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a85:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a8c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a93:	eb 23                	jmp    800ab8 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a95:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a99:	be 03 00 00 00       	mov    $0x3,%esi
  800a9e:	48 89 c7             	mov    %rax,%rdi
  800aa1:	48 b8 e9 03 80 00 00 	movabs $0x8003e9,%rax
  800aa8:	00 00 00 
  800aab:	ff d0                	callq  *%rax
  800aad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ab1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800abd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ac0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ac3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800acb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acf:	45 89 c1             	mov    %r8d,%r9d
  800ad2:	41 89 f8             	mov    %edi,%r8d
  800ad5:	48 89 c7             	mov    %rax,%rdi
  800ad8:	48 b8 2e 03 80 00 00 	movabs $0x80032e,%rax
  800adf:	00 00 00 
  800ae2:	ff d0                	callq  *%rax
			break;
  800ae4:	eb 3f                	jmp    800b25 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aee:	48 89 d6             	mov    %rdx,%rsi
  800af1:	89 df                	mov    %ebx,%edi
  800af3:	ff d0                	callq  *%rax
			break;
  800af5:	eb 2e                	jmp    800b25 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 d6             	mov    %rdx,%rsi
  800b02:	bf 25 00 00 00       	mov    $0x25,%edi
  800b07:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b09:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b0e:	eb 05                	jmp    800b15 <vprintfmt+0x50c>
  800b10:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b15:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b19:	48 83 e8 01          	sub    $0x1,%rax
  800b1d:	0f b6 00             	movzbl (%rax),%eax
  800b20:	3c 25                	cmp    $0x25,%al
  800b22:	75 ec                	jne    800b10 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b24:	90                   	nop
		}
	}
  800b25:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b26:	e9 30 fb ff ff       	jmpq   80065b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b2b:	48 83 c4 60          	add    $0x60,%rsp
  800b2f:	5b                   	pop    %rbx
  800b30:	41 5c                	pop    %r12
  800b32:	5d                   	pop    %rbp
  800b33:	c3                   	retq   

0000000000800b34 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b34:	55                   	push   %rbp
  800b35:	48 89 e5             	mov    %rsp,%rbp
  800b38:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b3f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b46:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b4d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b54:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b5b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b62:	84 c0                	test   %al,%al
  800b64:	74 20                	je     800b86 <printfmt+0x52>
  800b66:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b6a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b6e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b72:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b76:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b7a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b7e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b82:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b86:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b8d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b94:	00 00 00 
  800b97:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b9e:	00 00 00 
  800ba1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ba5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bb3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bba:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bc1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bc8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bcf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bd6:	48 89 c7             	mov    %rax,%rdi
  800bd9:	48 b8 09 06 80 00 00 	movabs $0x800609,%rax
  800be0:	00 00 00 
  800be3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800be5:	c9                   	leaveq 
  800be6:	c3                   	retq   

0000000000800be7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be7:	55                   	push   %rbp
  800be8:	48 89 e5             	mov    %rsp,%rbp
  800beb:	48 83 ec 10          	sub    $0x10,%rsp
  800bef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bf2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfa:	8b 40 10             	mov    0x10(%rax),%eax
  800bfd:	8d 50 01             	lea    0x1(%rax),%edx
  800c00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c04:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0b:	48 8b 10             	mov    (%rax),%rdx
  800c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c12:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c16:	48 39 c2             	cmp    %rax,%rdx
  800c19:	73 17                	jae    800c32 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1f:	48 8b 00             	mov    (%rax),%rax
  800c22:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c2a:	48 89 0a             	mov    %rcx,(%rdx)
  800c2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c30:	88 10                	mov    %dl,(%rax)
}
  800c32:	c9                   	leaveq 
  800c33:	c3                   	retq   

0000000000800c34 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c34:	55                   	push   %rbp
  800c35:	48 89 e5             	mov    %rsp,%rbp
  800c38:	48 83 ec 50          	sub    $0x50,%rsp
  800c3c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c40:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c43:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c47:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c4b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c4f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c53:	48 8b 0a             	mov    (%rdx),%rcx
  800c56:	48 89 08             	mov    %rcx,(%rax)
  800c59:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c5d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c61:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c65:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c6d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c71:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c74:	48 98                	cltq   
  800c76:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c7a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c7e:	48 01 d0             	add    %rdx,%rax
  800c81:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c8c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c91:	74 06                	je     800c99 <vsnprintf+0x65>
  800c93:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c97:	7f 07                	jg     800ca0 <vsnprintf+0x6c>
		return -E_INVAL;
  800c99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c9e:	eb 2f                	jmp    800ccf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ca0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ca4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ca8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cac:	48 89 c6             	mov    %rax,%rsi
  800caf:	48 bf e7 0b 80 00 00 	movabs $0x800be7,%rdi
  800cb6:	00 00 00 
  800cb9:	48 b8 09 06 80 00 00 	movabs $0x800609,%rax
  800cc0:	00 00 00 
  800cc3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cc9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ccc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ccf:	c9                   	leaveq 
  800cd0:	c3                   	retq   

0000000000800cd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd1:	55                   	push   %rbp
  800cd2:	48 89 e5             	mov    %rsp,%rbp
  800cd5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cdc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ce3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ce9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cf0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cf7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cfe:	84 c0                	test   %al,%al
  800d00:	74 20                	je     800d22 <snprintf+0x51>
  800d02:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d06:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d0a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d0e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d12:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d16:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d1a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d1e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d22:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d29:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d30:	00 00 00 
  800d33:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d3a:	00 00 00 
  800d3d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d41:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d48:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d4f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d56:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d5d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d64:	48 8b 0a             	mov    (%rdx),%rcx
  800d67:	48 89 08             	mov    %rcx,(%rax)
  800d6a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d6e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d72:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d76:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d7a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d81:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d88:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d8e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d95:	48 89 c7             	mov    %rax,%rdi
  800d98:	48 b8 34 0c 80 00 00 	movabs $0x800c34,%rax
  800d9f:	00 00 00 
  800da2:	ff d0                	callq  *%rax
  800da4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800daa:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800db0:	c9                   	leaveq 
  800db1:	c3                   	retq   

0000000000800db2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800db2:	55                   	push   %rbp
  800db3:	48 89 e5             	mov    %rsp,%rbp
  800db6:	48 83 ec 18          	sub    $0x18,%rsp
  800dba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dc5:	eb 09                	jmp    800dd0 <strlen+0x1e>
		n++;
  800dc7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dcb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd4:	0f b6 00             	movzbl (%rax),%eax
  800dd7:	84 c0                	test   %al,%al
  800dd9:	75 ec                	jne    800dc7 <strlen+0x15>
		n++;
	return n;
  800ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dde:	c9                   	leaveq 
  800ddf:	c3                   	retq   

0000000000800de0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800de0:	55                   	push   %rbp
  800de1:	48 89 e5             	mov    %rsp,%rbp
  800de4:	48 83 ec 20          	sub    $0x20,%rsp
  800de8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800df7:	eb 0e                	jmp    800e07 <strnlen+0x27>
		n++;
  800df9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e02:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e07:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e0c:	74 0b                	je     800e19 <strnlen+0x39>
  800e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e12:	0f b6 00             	movzbl (%rax),%eax
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e0                	jne    800df9 <strnlen+0x19>
		n++;
	return n;
  800e19:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e1c:	c9                   	leaveq 
  800e1d:	c3                   	retq   

0000000000800e1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1e:	55                   	push   %rbp
  800e1f:	48 89 e5             	mov    %rsp,%rbp
  800e22:	48 83 ec 20          	sub    $0x20,%rsp
  800e26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e36:	90                   	nop
  800e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e3f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e43:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e47:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e4b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e4f:	0f b6 12             	movzbl (%rdx),%edx
  800e52:	88 10                	mov    %dl,(%rax)
  800e54:	0f b6 00             	movzbl (%rax),%eax
  800e57:	84 c0                	test   %al,%al
  800e59:	75 dc                	jne    800e37 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e5f:	c9                   	leaveq 
  800e60:	c3                   	retq   

0000000000800e61 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e61:	55                   	push   %rbp
  800e62:	48 89 e5             	mov    %rsp,%rbp
  800e65:	48 83 ec 20          	sub    $0x20,%rsp
  800e69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e75:	48 89 c7             	mov    %rax,%rdi
  800e78:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  800e7f:	00 00 00 
  800e82:	ff d0                	callq  *%rax
  800e84:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8a:	48 63 d0             	movslq %eax,%rdx
  800e8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e91:	48 01 c2             	add    %rax,%rdx
  800e94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e98:	48 89 c6             	mov    %rax,%rsi
  800e9b:	48 89 d7             	mov    %rdx,%rdi
  800e9e:	48 b8 1e 0e 80 00 00 	movabs $0x800e1e,%rax
  800ea5:	00 00 00 
  800ea8:	ff d0                	callq  *%rax
	return dst;
  800eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800eae:	c9                   	leaveq 
  800eaf:	c3                   	retq   

0000000000800eb0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eb0:	55                   	push   %rbp
  800eb1:	48 89 e5             	mov    %rsp,%rbp
  800eb4:	48 83 ec 28          	sub    $0x28,%rsp
  800eb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ebc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ec0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ecc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ed3:	00 
  800ed4:	eb 2a                	jmp    800f00 <strncpy+0x50>
		*dst++ = *src;
  800ed6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eda:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ede:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ee2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ee6:	0f b6 12             	movzbl (%rdx),%edx
  800ee9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eeb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eef:	0f b6 00             	movzbl (%rax),%eax
  800ef2:	84 c0                	test   %al,%al
  800ef4:	74 05                	je     800efb <strncpy+0x4b>
			src++;
  800ef6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f04:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f08:	72 cc                	jb     800ed6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f0e:	c9                   	leaveq 
  800f0f:	c3                   	retq   

0000000000800f10 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f10:	55                   	push   %rbp
  800f11:	48 89 e5             	mov    %rsp,%rbp
  800f14:	48 83 ec 28          	sub    $0x28,%rsp
  800f18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f28:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f2c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f31:	74 3d                	je     800f70 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f33:	eb 1d                	jmp    800f52 <strlcpy+0x42>
			*dst++ = *src++;
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f3d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f41:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f45:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f49:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f4d:	0f b6 12             	movzbl (%rdx),%edx
  800f50:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f52:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f57:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f5c:	74 0b                	je     800f69 <strlcpy+0x59>
  800f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f62:	0f b6 00             	movzbl (%rax),%eax
  800f65:	84 c0                	test   %al,%al
  800f67:	75 cc                	jne    800f35 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f78:	48 29 c2             	sub    %rax,%rdx
  800f7b:	48 89 d0             	mov    %rdx,%rax
}
  800f7e:	c9                   	leaveq 
  800f7f:	c3                   	retq   

0000000000800f80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f80:	55                   	push   %rbp
  800f81:	48 89 e5             	mov    %rsp,%rbp
  800f84:	48 83 ec 10          	sub    $0x10,%rsp
  800f88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f90:	eb 0a                	jmp    800f9c <strcmp+0x1c>
		p++, q++;
  800f92:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f97:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa0:	0f b6 00             	movzbl (%rax),%eax
  800fa3:	84 c0                	test   %al,%al
  800fa5:	74 12                	je     800fb9 <strcmp+0x39>
  800fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fab:	0f b6 10             	movzbl (%rax),%edx
  800fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb2:	0f b6 00             	movzbl (%rax),%eax
  800fb5:	38 c2                	cmp    %al,%dl
  800fb7:	74 d9                	je     800f92 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbd:	0f b6 00             	movzbl (%rax),%eax
  800fc0:	0f b6 d0             	movzbl %al,%edx
  800fc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc7:	0f b6 00             	movzbl (%rax),%eax
  800fca:	0f b6 c0             	movzbl %al,%eax
  800fcd:	29 c2                	sub    %eax,%edx
  800fcf:	89 d0                	mov    %edx,%eax
}
  800fd1:	c9                   	leaveq 
  800fd2:	c3                   	retq   

0000000000800fd3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fd3:	55                   	push   %rbp
  800fd4:	48 89 e5             	mov    %rsp,%rbp
  800fd7:	48 83 ec 18          	sub    $0x18,%rsp
  800fdb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fe3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fe7:	eb 0f                	jmp    800ff8 <strncmp+0x25>
		n--, p++, q++;
  800fe9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ff3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ff8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800ffd:	74 1d                	je     80101c <strncmp+0x49>
  800fff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801003:	0f b6 00             	movzbl (%rax),%eax
  801006:	84 c0                	test   %al,%al
  801008:	74 12                	je     80101c <strncmp+0x49>
  80100a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100e:	0f b6 10             	movzbl (%rax),%edx
  801011:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801015:	0f b6 00             	movzbl (%rax),%eax
  801018:	38 c2                	cmp    %al,%dl
  80101a:	74 cd                	je     800fe9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80101c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801021:	75 07                	jne    80102a <strncmp+0x57>
		return 0;
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
  801028:	eb 18                	jmp    801042 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80102a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102e:	0f b6 00             	movzbl (%rax),%eax
  801031:	0f b6 d0             	movzbl %al,%edx
  801034:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801038:	0f b6 00             	movzbl (%rax),%eax
  80103b:	0f b6 c0             	movzbl %al,%eax
  80103e:	29 c2                	sub    %eax,%edx
  801040:	89 d0                	mov    %edx,%eax
}
  801042:	c9                   	leaveq 
  801043:	c3                   	retq   

0000000000801044 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801044:	55                   	push   %rbp
  801045:	48 89 e5             	mov    %rsp,%rbp
  801048:	48 83 ec 0c          	sub    $0xc,%rsp
  80104c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801050:	89 f0                	mov    %esi,%eax
  801052:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801055:	eb 17                	jmp    80106e <strchr+0x2a>
		if (*s == c)
  801057:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105b:	0f b6 00             	movzbl (%rax),%eax
  80105e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801061:	75 06                	jne    801069 <strchr+0x25>
			return (char *) s;
  801063:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801067:	eb 15                	jmp    80107e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801069:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80106e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801072:	0f b6 00             	movzbl (%rax),%eax
  801075:	84 c0                	test   %al,%al
  801077:	75 de                	jne    801057 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801079:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107e:	c9                   	leaveq 
  80107f:	c3                   	retq   

0000000000801080 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801080:	55                   	push   %rbp
  801081:	48 89 e5             	mov    %rsp,%rbp
  801084:	48 83 ec 0c          	sub    $0xc,%rsp
  801088:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80108c:	89 f0                	mov    %esi,%eax
  80108e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801091:	eb 13                	jmp    8010a6 <strfind+0x26>
		if (*s == c)
  801093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801097:	0f b6 00             	movzbl (%rax),%eax
  80109a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80109d:	75 02                	jne    8010a1 <strfind+0x21>
			break;
  80109f:	eb 10                	jmp    8010b1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010aa:	0f b6 00             	movzbl (%rax),%eax
  8010ad:	84 c0                	test   %al,%al
  8010af:	75 e2                	jne    801093 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b5:	c9                   	leaveq 
  8010b6:	c3                   	retq   

00000000008010b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010b7:	55                   	push   %rbp
  8010b8:	48 89 e5             	mov    %rsp,%rbp
  8010bb:	48 83 ec 18          	sub    $0x18,%rsp
  8010bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010cf:	75 06                	jne    8010d7 <memset+0x20>
		return v;
  8010d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d5:	eb 69                	jmp    801140 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010db:	83 e0 03             	and    $0x3,%eax
  8010de:	48 85 c0             	test   %rax,%rax
  8010e1:	75 48                	jne    80112b <memset+0x74>
  8010e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e7:	83 e0 03             	and    $0x3,%eax
  8010ea:	48 85 c0             	test   %rax,%rax
  8010ed:	75 3c                	jne    80112b <memset+0x74>
		c &= 0xFF;
  8010ef:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f9:	c1 e0 18             	shl    $0x18,%eax
  8010fc:	89 c2                	mov    %eax,%edx
  8010fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801101:	c1 e0 10             	shl    $0x10,%eax
  801104:	09 c2                	or     %eax,%edx
  801106:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801109:	c1 e0 08             	shl    $0x8,%eax
  80110c:	09 d0                	or     %edx,%eax
  80110e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801115:	48 c1 e8 02          	shr    $0x2,%rax
  801119:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80111c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801120:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801123:	48 89 d7             	mov    %rdx,%rdi
  801126:	fc                   	cld    
  801127:	f3 ab                	rep stos %eax,%es:(%rdi)
  801129:	eb 11                	jmp    80113c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80112b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80112f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801132:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801136:	48 89 d7             	mov    %rdx,%rdi
  801139:	fc                   	cld    
  80113a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80113c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 28          	sub    $0x28,%rsp
  80114a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801152:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801156:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80115e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80116e:	0f 83 88 00 00 00    	jae    8011fc <memmove+0xba>
  801174:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801178:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80117c:	48 01 d0             	add    %rdx,%rax
  80117f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801183:	76 77                	jbe    8011fc <memmove+0xba>
		s += n;
  801185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801189:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80118d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801191:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801199:	83 e0 03             	and    $0x3,%eax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 3b                	jne    8011dc <memmove+0x9a>
  8011a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a5:	83 e0 03             	and    $0x3,%eax
  8011a8:	48 85 c0             	test   %rax,%rax
  8011ab:	75 2f                	jne    8011dc <memmove+0x9a>
  8011ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b1:	83 e0 03             	and    $0x3,%eax
  8011b4:	48 85 c0             	test   %rax,%rax
  8011b7:	75 23                	jne    8011dc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	48 83 e8 04          	sub    $0x4,%rax
  8011c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c5:	48 83 ea 04          	sub    $0x4,%rdx
  8011c9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011cd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011d1:	48 89 c7             	mov    %rax,%rdi
  8011d4:	48 89 d6             	mov    %rdx,%rsi
  8011d7:	fd                   	std    
  8011d8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011da:	eb 1d                	jmp    8011f9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f0:	48 89 d7             	mov    %rdx,%rdi
  8011f3:	48 89 c1             	mov    %rax,%rcx
  8011f6:	fd                   	std    
  8011f7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011f9:	fc                   	cld    
  8011fa:	eb 57                	jmp    801253 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801200:	83 e0 03             	and    $0x3,%eax
  801203:	48 85 c0             	test   %rax,%rax
  801206:	75 36                	jne    80123e <memmove+0xfc>
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	83 e0 03             	and    $0x3,%eax
  80120f:	48 85 c0             	test   %rax,%rax
  801212:	75 2a                	jne    80123e <memmove+0xfc>
  801214:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801218:	83 e0 03             	and    $0x3,%eax
  80121b:	48 85 c0             	test   %rax,%rax
  80121e:	75 1e                	jne    80123e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801224:	48 c1 e8 02          	shr    $0x2,%rax
  801228:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80122b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801233:	48 89 c7             	mov    %rax,%rdi
  801236:	48 89 d6             	mov    %rdx,%rsi
  801239:	fc                   	cld    
  80123a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80123c:	eb 15                	jmp    801253 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80123e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801242:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801246:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80124a:	48 89 c7             	mov    %rax,%rdi
  80124d:	48 89 d6             	mov    %rdx,%rsi
  801250:	fc                   	cld    
  801251:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801257:	c9                   	leaveq 
  801258:	c3                   	retq   

0000000000801259 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801259:	55                   	push   %rbp
  80125a:	48 89 e5             	mov    %rsp,%rbp
  80125d:	48 83 ec 18          	sub    $0x18,%rsp
  801261:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801265:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801269:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80126d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801271:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801279:	48 89 ce             	mov    %rcx,%rsi
  80127c:	48 89 c7             	mov    %rax,%rdi
  80127f:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  801286:	00 00 00 
  801289:	ff d0                	callq  *%rax
}
  80128b:	c9                   	leaveq 
  80128c:	c3                   	retq   

000000000080128d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80128d:	55                   	push   %rbp
  80128e:	48 89 e5             	mov    %rsp,%rbp
  801291:	48 83 ec 28          	sub    $0x28,%rsp
  801295:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801299:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012b1:	eb 36                	jmp    8012e9 <memcmp+0x5c>
		if (*s1 != *s2)
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	0f b6 10             	movzbl (%rax),%edx
  8012ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	38 c2                	cmp    %al,%dl
  8012c3:	74 1a                	je     8012df <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c9:	0f b6 00             	movzbl (%rax),%eax
  8012cc:	0f b6 d0             	movzbl %al,%edx
  8012cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d3:	0f b6 00             	movzbl (%rax),%eax
  8012d6:	0f b6 c0             	movzbl %al,%eax
  8012d9:	29 c2                	sub    %eax,%edx
  8012db:	89 d0                	mov    %edx,%eax
  8012dd:	eb 20                	jmp    8012ff <memcmp+0x72>
		s1++, s2++;
  8012df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ed:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012f5:	48 85 c0             	test   %rax,%rax
  8012f8:	75 b9                	jne    8012b3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ff:	c9                   	leaveq 
  801300:	c3                   	retq   

0000000000801301 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801301:	55                   	push   %rbp
  801302:	48 89 e5             	mov    %rsp,%rbp
  801305:	48 83 ec 28          	sub    $0x28,%rsp
  801309:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801310:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801314:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801318:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80131c:	48 01 d0             	add    %rdx,%rax
  80131f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801323:	eb 15                	jmp    80133a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801329:	0f b6 10             	movzbl (%rax),%edx
  80132c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80132f:	38 c2                	cmp    %al,%dl
  801331:	75 02                	jne    801335 <memfind+0x34>
			break;
  801333:	eb 0f                	jmp    801344 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801335:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80133a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801342:	72 e1                	jb     801325 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801348:	c9                   	leaveq 
  801349:	c3                   	retq   

000000000080134a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80134a:	55                   	push   %rbp
  80134b:	48 89 e5             	mov    %rsp,%rbp
  80134e:	48 83 ec 34          	sub    $0x34,%rsp
  801352:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801356:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80135a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80135d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801364:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80136b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80136c:	eb 05                	jmp    801373 <strtol+0x29>
		s++;
  80136e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801373:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	3c 20                	cmp    $0x20,%al
  80137c:	74 f0                	je     80136e <strtol+0x24>
  80137e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801382:	0f b6 00             	movzbl (%rax),%eax
  801385:	3c 09                	cmp    $0x9,%al
  801387:	74 e5                	je     80136e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	3c 2b                	cmp    $0x2b,%al
  801392:	75 07                	jne    80139b <strtol+0x51>
		s++;
  801394:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801399:	eb 17                	jmp    8013b2 <strtol+0x68>
	else if (*s == '-')
  80139b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139f:	0f b6 00             	movzbl (%rax),%eax
  8013a2:	3c 2d                	cmp    $0x2d,%al
  8013a4:	75 0c                	jne    8013b2 <strtol+0x68>
		s++, neg = 1;
  8013a6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013b6:	74 06                	je     8013be <strtol+0x74>
  8013b8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013bc:	75 28                	jne    8013e6 <strtol+0x9c>
  8013be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	3c 30                	cmp    $0x30,%al
  8013c7:	75 1d                	jne    8013e6 <strtol+0x9c>
  8013c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cd:	48 83 c0 01          	add    $0x1,%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	3c 78                	cmp    $0x78,%al
  8013d6:	75 0e                	jne    8013e6 <strtol+0x9c>
		s += 2, base = 16;
  8013d8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013dd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013e4:	eb 2c                	jmp    801412 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ea:	75 19                	jne    801405 <strtol+0xbb>
  8013ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	3c 30                	cmp    $0x30,%al
  8013f5:	75 0e                	jne    801405 <strtol+0xbb>
		s++, base = 8;
  8013f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013fc:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801403:	eb 0d                	jmp    801412 <strtol+0xc8>
	else if (base == 0)
  801405:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801409:	75 07                	jne    801412 <strtol+0xc8>
		base = 10;
  80140b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	0f b6 00             	movzbl (%rax),%eax
  801419:	3c 2f                	cmp    $0x2f,%al
  80141b:	7e 1d                	jle    80143a <strtol+0xf0>
  80141d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801421:	0f b6 00             	movzbl (%rax),%eax
  801424:	3c 39                	cmp    $0x39,%al
  801426:	7f 12                	jg     80143a <strtol+0xf0>
			dig = *s - '0';
  801428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	0f be c0             	movsbl %al,%eax
  801432:	83 e8 30             	sub    $0x30,%eax
  801435:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801438:	eb 4e                	jmp    801488 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80143a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	3c 60                	cmp    $0x60,%al
  801443:	7e 1d                	jle    801462 <strtol+0x118>
  801445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801449:	0f b6 00             	movzbl (%rax),%eax
  80144c:	3c 7a                	cmp    $0x7a,%al
  80144e:	7f 12                	jg     801462 <strtol+0x118>
			dig = *s - 'a' + 10;
  801450:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801454:	0f b6 00             	movzbl (%rax),%eax
  801457:	0f be c0             	movsbl %al,%eax
  80145a:	83 e8 57             	sub    $0x57,%eax
  80145d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801460:	eb 26                	jmp    801488 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801466:	0f b6 00             	movzbl (%rax),%eax
  801469:	3c 40                	cmp    $0x40,%al
  80146b:	7e 48                	jle    8014b5 <strtol+0x16b>
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	3c 5a                	cmp    $0x5a,%al
  801476:	7f 3d                	jg     8014b5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	83 e8 37             	sub    $0x37,%eax
  801485:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801488:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80148b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80148e:	7c 02                	jl     801492 <strtol+0x148>
			break;
  801490:	eb 23                	jmp    8014b5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801492:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801497:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80149a:	48 98                	cltq   
  80149c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014a1:	48 89 c2             	mov    %rax,%rdx
  8014a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014a7:	48 98                	cltq   
  8014a9:	48 01 d0             	add    %rdx,%rax
  8014ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014b0:	e9 5d ff ff ff       	jmpq   801412 <strtol+0xc8>

	if (endptr)
  8014b5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014ba:	74 0b                	je     8014c7 <strtol+0x17d>
		*endptr = (char *) s;
  8014bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014c4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014cb:	74 09                	je     8014d6 <strtol+0x18c>
  8014cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d1:	48 f7 d8             	neg    %rax
  8014d4:	eb 04                	jmp    8014da <strtol+0x190>
  8014d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014da:	c9                   	leaveq 
  8014db:	c3                   	retq   

00000000008014dc <strstr>:

char * strstr(const char *in, const char *str)
{
  8014dc:	55                   	push   %rbp
  8014dd:	48 89 e5             	mov    %rsp,%rbp
  8014e0:	48 83 ec 30          	sub    $0x30,%rsp
  8014e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014f4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014fe:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801502:	75 06                	jne    80150a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	eb 6b                	jmp    801575 <strstr+0x99>

	len = strlen(str);
  80150a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80150e:	48 89 c7             	mov    %rax,%rdi
  801511:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  801518:	00 00 00 
  80151b:	ff d0                	callq  *%rax
  80151d:	48 98                	cltq   
  80151f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80152b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801535:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801539:	75 07                	jne    801542 <strstr+0x66>
				return (char *) 0;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	eb 33                	jmp    801575 <strstr+0x99>
		} while (sc != c);
  801542:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801546:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801549:	75 d8                	jne    801523 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80154b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80154f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	48 89 ce             	mov    %rcx,%rsi
  80155a:	48 89 c7             	mov    %rax,%rdi
  80155d:	48 b8 d3 0f 80 00 00 	movabs $0x800fd3,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
  801569:	85 c0                	test   %eax,%eax
  80156b:	75 b6                	jne    801523 <strstr+0x47>

	return (char *) (in - 1);
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 83 e8 01          	sub    $0x1,%rax
}
  801575:	c9                   	leaveq 
  801576:	c3                   	retq   

0000000000801577 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	53                   	push   %rbx
  80157c:	48 83 ec 48          	sub    $0x48,%rsp
  801580:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801583:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801586:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80158a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80158e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801592:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801596:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801599:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80159d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015a1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015a5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015a9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015ad:	4c 89 c3             	mov    %r8,%rbx
  8015b0:	cd 30                	int    $0x30
  8015b2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015ba:	74 3e                	je     8015fa <syscall+0x83>
  8015bc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c1:	7e 37                	jle    8015fa <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015ca:	49 89 d0             	mov    %rdx,%r8
  8015cd:	89 c1                	mov    %eax,%ecx
  8015cf:	48 ba 08 3b 80 00 00 	movabs $0x803b08,%rdx
  8015d6:	00 00 00 
  8015d9:	be 23 00 00 00       	mov    $0x23,%esi
  8015de:	48 bf 25 3b 80 00 00 	movabs $0x803b25,%rdi
  8015e5:	00 00 00 
  8015e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ed:	49 b9 7f 32 80 00 00 	movabs $0x80327f,%r9
  8015f4:	00 00 00 
  8015f7:	41 ff d1             	callq  *%r9

	return ret;
  8015fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015fe:	48 83 c4 48          	add    $0x48,%rsp
  801602:	5b                   	pop    %rbx
  801603:	5d                   	pop    %rbp
  801604:	c3                   	retq   

0000000000801605 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	48 83 ec 20          	sub    $0x20,%rsp
  80160d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801611:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801619:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80161d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801624:	00 
  801625:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80162b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801631:	48 89 d1             	mov    %rdx,%rcx
  801634:	48 89 c2             	mov    %rax,%rdx
  801637:	be 00 00 00 00       	mov    $0x0,%esi
  80163c:	bf 00 00 00 00       	mov    $0x0,%edi
  801641:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  801648:	00 00 00 
  80164b:	ff d0                	callq  *%rax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <sys_cgetc>:

int
sys_cgetc(void)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801657:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80165e:	00 
  80165f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801665:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80166b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	be 00 00 00 00       	mov    $0x0,%esi
  80167a:	bf 01 00 00 00       	mov    $0x1,%edi
  80167f:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  801686:	00 00 00 
  801689:	ff d0                	callq  *%rax
}
  80168b:	c9                   	leaveq 
  80168c:	c3                   	retq   

000000000080168d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	48 83 ec 10          	sub    $0x10,%rsp
  801695:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80169b:	48 98                	cltq   
  80169d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a4:	00 
  8016a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b6:	48 89 c2             	mov    %rax,%rdx
  8016b9:	be 01 00 00 00       	mov    $0x1,%esi
  8016be:	bf 03 00 00 00       	mov    $0x3,%edi
  8016c3:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  8016ca:	00 00 00 
  8016cd:	ff d0                	callq  *%rax
}
  8016cf:	c9                   	leaveq 
  8016d0:	c3                   	retq   

00000000008016d1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016d1:	55                   	push   %rbp
  8016d2:	48 89 e5             	mov    %rsp,%rbp
  8016d5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016d9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e0:	00 
  8016e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f7:	be 00 00 00 00       	mov    $0x0,%esi
  8016fc:	bf 02 00 00 00       	mov    $0x2,%edi
  801701:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  801708:	00 00 00 
  80170b:	ff d0                	callq  *%rax
}
  80170d:	c9                   	leaveq 
  80170e:	c3                   	retq   

000000000080170f <sys_yield>:

void
sys_yield(void)
{
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
  801713:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801717:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80171e:	00 
  80171f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801725:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80172b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801730:	ba 00 00 00 00       	mov    $0x0,%edx
  801735:	be 00 00 00 00       	mov    $0x0,%esi
  80173a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80173f:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  801746:	00 00 00 
  801749:	ff d0                	callq  *%rax
}
  80174b:	c9                   	leaveq 
  80174c:	c3                   	retq   

000000000080174d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80174d:	55                   	push   %rbp
  80174e:	48 89 e5             	mov    %rsp,%rbp
  801751:	48 83 ec 20          	sub    $0x20,%rsp
  801755:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801758:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80175c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80175f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801762:	48 63 c8             	movslq %eax,%rcx
  801765:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801769:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80176c:	48 98                	cltq   
  80176e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801775:	00 
  801776:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80177c:	49 89 c8             	mov    %rcx,%r8
  80177f:	48 89 d1             	mov    %rdx,%rcx
  801782:	48 89 c2             	mov    %rax,%rdx
  801785:	be 01 00 00 00       	mov    $0x1,%esi
  80178a:	bf 04 00 00 00       	mov    $0x4,%edi
  80178f:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  801796:	00 00 00 
  801799:	ff d0                	callq  *%rax
}
  80179b:	c9                   	leaveq 
  80179c:	c3                   	retq   

000000000080179d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80179d:	55                   	push   %rbp
  80179e:	48 89 e5             	mov    %rsp,%rbp
  8017a1:	48 83 ec 30          	sub    $0x30,%rsp
  8017a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017af:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017b3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017b7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017ba:	48 63 c8             	movslq %eax,%rcx
  8017bd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017c4:	48 63 f0             	movslq %eax,%rsi
  8017c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ce:	48 98                	cltq   
  8017d0:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017d4:	49 89 f9             	mov    %rdi,%r9
  8017d7:	49 89 f0             	mov    %rsi,%r8
  8017da:	48 89 d1             	mov    %rdx,%rcx
  8017dd:	48 89 c2             	mov    %rax,%rdx
  8017e0:	be 01 00 00 00       	mov    $0x1,%esi
  8017e5:	bf 05 00 00 00       	mov    $0x5,%edi
  8017ea:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  8017f1:	00 00 00 
  8017f4:	ff d0                	callq  *%rax
}
  8017f6:	c9                   	leaveq 
  8017f7:	c3                   	retq   

00000000008017f8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017f8:	55                   	push   %rbp
  8017f9:	48 89 e5             	mov    %rsp,%rbp
  8017fc:	48 83 ec 20          	sub    $0x20,%rsp
  801800:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801803:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801807:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80180e:	48 98                	cltq   
  801810:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801817:	00 
  801818:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80181e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801824:	48 89 d1             	mov    %rdx,%rcx
  801827:	48 89 c2             	mov    %rax,%rdx
  80182a:	be 01 00 00 00       	mov    $0x1,%esi
  80182f:	bf 06 00 00 00       	mov    $0x6,%edi
  801834:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  80183b:	00 00 00 
  80183e:	ff d0                	callq  *%rax
}
  801840:	c9                   	leaveq 
  801841:	c3                   	retq   

0000000000801842 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801842:	55                   	push   %rbp
  801843:	48 89 e5             	mov    %rsp,%rbp
  801846:	48 83 ec 10          	sub    $0x10,%rsp
  80184a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80184d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801850:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801853:	48 63 d0             	movslq %eax,%rdx
  801856:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801859:	48 98                	cltq   
  80185b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801862:	00 
  801863:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801869:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186f:	48 89 d1             	mov    %rdx,%rcx
  801872:	48 89 c2             	mov    %rax,%rdx
  801875:	be 01 00 00 00       	mov    $0x1,%esi
  80187a:	bf 08 00 00 00       	mov    $0x8,%edi
  80187f:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  801886:	00 00 00 
  801889:	ff d0                	callq  *%rax
}
  80188b:	c9                   	leaveq 
  80188c:	c3                   	retq   

000000000080188d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	48 83 ec 20          	sub    $0x20,%rsp
  801895:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801898:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80189c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a3:	48 98                	cltq   
  8018a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ac:	00 
  8018ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b9:	48 89 d1             	mov    %rdx,%rcx
  8018bc:	48 89 c2             	mov    %rax,%rdx
  8018bf:	be 01 00 00 00       	mov    $0x1,%esi
  8018c4:	bf 09 00 00 00       	mov    $0x9,%edi
  8018c9:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 20          	sub    $0x20,%rsp
  8018df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ed:	48 98                	cltq   
  8018ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f6:	00 
  8018f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801903:	48 89 d1             	mov    %rdx,%rcx
  801906:	48 89 c2             	mov    %rax,%rdx
  801909:	be 01 00 00 00       	mov    $0x1,%esi
  80190e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801913:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	callq  *%rax
}
  80191f:	c9                   	leaveq 
  801920:	c3                   	retq   

0000000000801921 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801921:	55                   	push   %rbp
  801922:	48 89 e5             	mov    %rsp,%rbp
  801925:	48 83 ec 20          	sub    $0x20,%rsp
  801929:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801930:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801934:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801937:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80193a:	48 63 f0             	movslq %eax,%rsi
  80193d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801944:	48 98                	cltq   
  801946:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801951:	00 
  801952:	49 89 f1             	mov    %rsi,%r9
  801955:	49 89 c8             	mov    %rcx,%r8
  801958:	48 89 d1             	mov    %rdx,%rcx
  80195b:	48 89 c2             	mov    %rax,%rdx
  80195e:	be 00 00 00 00       	mov    $0x0,%esi
  801963:	bf 0c 00 00 00       	mov    $0xc,%edi
  801968:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  80196f:	00 00 00 
  801972:	ff d0                	callq  *%rax
}
  801974:	c9                   	leaveq 
  801975:	c3                   	retq   

0000000000801976 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801976:	55                   	push   %rbp
  801977:	48 89 e5             	mov    %rsp,%rbp
  80197a:	48 83 ec 10          	sub    $0x10,%rsp
  80197e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801982:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801986:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198d:	00 
  80198e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801994:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199f:	48 89 c2             	mov    %rax,%rdx
  8019a2:	be 01 00 00 00       	mov    $0x1,%esi
  8019a7:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019ac:	48 b8 77 15 80 00 00 	movabs $0x801577,%rax
  8019b3:	00 00 00 
  8019b6:	ff d0                	callq  *%rax
}
  8019b8:	c9                   	leaveq 
  8019b9:	c3                   	retq   

00000000008019ba <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8019ba:	55                   	push   %rbp
  8019bb:	48 89 e5             	mov    %rsp,%rbp
  8019be:	48 83 ec 08          	sub    $0x8,%rsp
  8019c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019ca:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019d1:	ff ff ff 
  8019d4:	48 01 d0             	add    %rdx,%rax
  8019d7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019db:	c9                   	leaveq 
  8019dc:	c3                   	retq   

00000000008019dd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019dd:	55                   	push   %rbp
  8019de:	48 89 e5             	mov    %rsp,%rbp
  8019e1:	48 83 ec 08          	sub    $0x8,%rsp
  8019e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8019e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ed:	48 89 c7             	mov    %rax,%rdi
  8019f0:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  8019f7:	00 00 00 
  8019fa:	ff d0                	callq  *%rax
  8019fc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a02:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a06:	c9                   	leaveq 
  801a07:	c3                   	retq   

0000000000801a08 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
  801a0c:	48 83 ec 18          	sub    $0x18,%rsp
  801a10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a1b:	eb 6b                	jmp    801a88 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a20:	48 98                	cltq   
  801a22:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a28:	48 c1 e0 0c          	shl    $0xc,%rax
  801a2c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a34:	48 c1 e8 15          	shr    $0x15,%rax
  801a38:	48 89 c2             	mov    %rax,%rdx
  801a3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801a42:	01 00 00 
  801a45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a49:	83 e0 01             	and    $0x1,%eax
  801a4c:	48 85 c0             	test   %rax,%rax
  801a4f:	74 21                	je     801a72 <fd_alloc+0x6a>
  801a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a55:	48 c1 e8 0c          	shr    $0xc,%rax
  801a59:	48 89 c2             	mov    %rax,%rdx
  801a5c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a63:	01 00 00 
  801a66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a6a:	83 e0 01             	and    $0x1,%eax
  801a6d:	48 85 c0             	test   %rax,%rax
  801a70:	75 12                	jne    801a84 <fd_alloc+0x7c>
			*fd_store = fd;
  801a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a7a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a82:	eb 1a                	jmp    801a9e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a84:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801a88:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801a8c:	7e 8f                	jle    801a1d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a92:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801a99:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801a9e:	c9                   	leaveq 
  801a9f:	c3                   	retq   

0000000000801aa0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801aa0:	55                   	push   %rbp
  801aa1:	48 89 e5             	mov    %rsp,%rbp
  801aa4:	48 83 ec 20          	sub    $0x20,%rsp
  801aa8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801aab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801aaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ab3:	78 06                	js     801abb <fd_lookup+0x1b>
  801ab5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ab9:	7e 07                	jle    801ac2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801abb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac0:	eb 6c                	jmp    801b2e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ac2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ac5:	48 98                	cltq   
  801ac7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801acd:	48 c1 e0 0c          	shl    $0xc,%rax
  801ad1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ad5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad9:	48 c1 e8 15          	shr    $0x15,%rax
  801add:	48 89 c2             	mov    %rax,%rdx
  801ae0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ae7:	01 00 00 
  801aea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801aee:	83 e0 01             	and    $0x1,%eax
  801af1:	48 85 c0             	test   %rax,%rax
  801af4:	74 21                	je     801b17 <fd_lookup+0x77>
  801af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801afa:	48 c1 e8 0c          	shr    $0xc,%rax
  801afe:	48 89 c2             	mov    %rax,%rdx
  801b01:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b08:	01 00 00 
  801b0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b0f:	83 e0 01             	and    $0x1,%eax
  801b12:	48 85 c0             	test   %rax,%rax
  801b15:	75 07                	jne    801b1e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b1c:	eb 10                	jmp    801b2e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b22:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b26:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2e:	c9                   	leaveq 
  801b2f:	c3                   	retq   

0000000000801b30 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b30:	55                   	push   %rbp
  801b31:	48 89 e5             	mov    %rsp,%rbp
  801b34:	48 83 ec 30          	sub    $0x30,%rsp
  801b38:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b3c:	89 f0                	mov    %esi,%eax
  801b3e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b45:	48 89 c7             	mov    %rax,%rdi
  801b48:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
  801b54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b58:	48 89 d6             	mov    %rdx,%rsi
  801b5b:	89 c7                	mov    %eax,%edi
  801b5d:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  801b64:	00 00 00 
  801b67:	ff d0                	callq  *%rax
  801b69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b70:	78 0a                	js     801b7c <fd_close+0x4c>
	    || fd != fd2)
  801b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b76:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801b7a:	74 12                	je     801b8e <fd_close+0x5e>
		return (must_exist ? r : 0);
  801b7c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801b80:	74 05                	je     801b87 <fd_close+0x57>
  801b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b85:	eb 05                	jmp    801b8c <fd_close+0x5c>
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8c:	eb 69                	jmp    801bf7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b92:	8b 00                	mov    (%rax),%eax
  801b94:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801b98:	48 89 d6             	mov    %rdx,%rsi
  801b9b:	89 c7                	mov    %eax,%edi
  801b9d:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
  801ba9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb0:	78 2a                	js     801bdc <fd_close+0xac>
		if (dev->dev_close)
  801bb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb6:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bba:	48 85 c0             	test   %rax,%rax
  801bbd:	74 16                	je     801bd5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801bbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bc7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bcb:	48 89 d7             	mov    %rdx,%rdi
  801bce:	ff d0                	callq  *%rax
  801bd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bd3:	eb 07                	jmp    801bdc <fd_close+0xac>
		else
			r = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bdc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be0:	48 89 c6             	mov    %rax,%rsi
  801be3:	bf 00 00 00 00       	mov    $0x0,%edi
  801be8:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  801bef:	00 00 00 
  801bf2:	ff d0                	callq  *%rax
	return r;
  801bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801bf7:	c9                   	leaveq 
  801bf8:	c3                   	retq   

0000000000801bf9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801bf9:	55                   	push   %rbp
  801bfa:	48 89 e5             	mov    %rsp,%rbp
  801bfd:	48 83 ec 20          	sub    $0x20,%rsp
  801c01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c0f:	eb 41                	jmp    801c52 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c11:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c18:	00 00 00 
  801c1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c1e:	48 63 d2             	movslq %edx,%rdx
  801c21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c25:	8b 00                	mov    (%rax),%eax
  801c27:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c2a:	75 22                	jne    801c4e <dev_lookup+0x55>
			*dev = devtab[i];
  801c2c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c33:	00 00 00 
  801c36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c39:	48 63 d2             	movslq %edx,%rdx
  801c3c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c44:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c47:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4c:	eb 60                	jmp    801cae <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c4e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c52:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c59:	00 00 00 
  801c5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c5f:	48 63 d2             	movslq %edx,%rdx
  801c62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c66:	48 85 c0             	test   %rax,%rax
  801c69:	75 a6                	jne    801c11 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c6b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801c72:	00 00 00 
  801c75:	48 8b 00             	mov    (%rax),%rax
  801c78:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c7e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c81:	89 c6                	mov    %eax,%esi
  801c83:	48 bf 38 3b 80 00 00 	movabs $0x803b38,%rdi
  801c8a:	00 00 00 
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c92:	48 b9 56 02 80 00 00 	movabs $0x800256,%rcx
  801c99:	00 00 00 
  801c9c:	ff d1                	callq  *%rcx
	*dev = 0;
  801c9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ca9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cae:	c9                   	leaveq 
  801caf:	c3                   	retq   

0000000000801cb0 <close>:

int
close(int fdnum)
{
  801cb0:	55                   	push   %rbp
  801cb1:	48 89 e5             	mov    %rsp,%rbp
  801cb4:	48 83 ec 20          	sub    $0x20,%rsp
  801cb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cbb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cc2:	48 89 d6             	mov    %rdx,%rsi
  801cc5:	89 c7                	mov    %eax,%edi
  801cc7:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  801cce:	00 00 00 
  801cd1:	ff d0                	callq  *%rax
  801cd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cda:	79 05                	jns    801ce1 <close+0x31>
		return r;
  801cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdf:	eb 18                	jmp    801cf9 <close+0x49>
	else
		return fd_close(fd, 1);
  801ce1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce5:	be 01 00 00 00       	mov    $0x1,%esi
  801cea:	48 89 c7             	mov    %rax,%rdi
  801ced:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  801cf4:	00 00 00 
  801cf7:	ff d0                	callq  *%rax
}
  801cf9:	c9                   	leaveq 
  801cfa:	c3                   	retq   

0000000000801cfb <close_all>:

void
close_all(void)
{
  801cfb:	55                   	push   %rbp
  801cfc:	48 89 e5             	mov    %rsp,%rbp
  801cff:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d0a:	eb 15                	jmp    801d21 <close_all+0x26>
		close(i);
  801d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0f:	89 c7                	mov    %eax,%edi
  801d11:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d1d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d21:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d25:	7e e5                	jle    801d0c <close_all+0x11>
		close(i);
}
  801d27:	c9                   	leaveq 
  801d28:	c3                   	retq   

0000000000801d29 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d29:	55                   	push   %rbp
  801d2a:	48 89 e5             	mov    %rsp,%rbp
  801d2d:	48 83 ec 40          	sub    $0x40,%rsp
  801d31:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d34:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d37:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801d3b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d3e:	48 89 d6             	mov    %rdx,%rsi
  801d41:	89 c7                	mov    %eax,%edi
  801d43:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  801d4a:	00 00 00 
  801d4d:	ff d0                	callq  *%rax
  801d4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d56:	79 08                	jns    801d60 <dup+0x37>
		return r;
  801d58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5b:	e9 70 01 00 00       	jmpq   801ed0 <dup+0x1a7>
	close(newfdnum);
  801d60:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d63:	89 c7                	mov    %eax,%edi
  801d65:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801d71:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d74:	48 98                	cltq   
  801d76:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d7c:	48 c1 e0 0c          	shl    $0xc,%rax
  801d80:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801d84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d88:	48 89 c7             	mov    %rax,%rdi
  801d8b:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  801d92:	00 00 00 
  801d95:	ff d0                	callq  *%rax
  801d97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801d9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d9f:	48 89 c7             	mov    %rax,%rdi
  801da2:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
  801dae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801db2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db6:	48 c1 e8 15          	shr    $0x15,%rax
  801dba:	48 89 c2             	mov    %rax,%rdx
  801dbd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dc4:	01 00 00 
  801dc7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dcb:	83 e0 01             	and    $0x1,%eax
  801dce:	48 85 c0             	test   %rax,%rax
  801dd1:	74 73                	je     801e46 <dup+0x11d>
  801dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd7:	48 c1 e8 0c          	shr    $0xc,%rax
  801ddb:	48 89 c2             	mov    %rax,%rdx
  801dde:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801de5:	01 00 00 
  801de8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dec:	83 e0 01             	and    $0x1,%eax
  801def:	48 85 c0             	test   %rax,%rax
  801df2:	74 52                	je     801e46 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df8:	48 c1 e8 0c          	shr    $0xc,%rax
  801dfc:	48 89 c2             	mov    %rax,%rdx
  801dff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e06:	01 00 00 
  801e09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e0d:	25 07 0e 00 00       	and    $0xe07,%eax
  801e12:	89 c1                	mov    %eax,%ecx
  801e14:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1c:	41 89 c8             	mov    %ecx,%r8d
  801e1f:	48 89 d1             	mov    %rdx,%rcx
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
  801e27:	48 89 c6             	mov    %rax,%rsi
  801e2a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2f:	48 b8 9d 17 80 00 00 	movabs $0x80179d,%rax
  801e36:	00 00 00 
  801e39:	ff d0                	callq  *%rax
  801e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e42:	79 02                	jns    801e46 <dup+0x11d>
			goto err;
  801e44:	eb 57                	jmp    801e9d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4a:	48 c1 e8 0c          	shr    $0xc,%rax
  801e4e:	48 89 c2             	mov    %rax,%rdx
  801e51:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e58:	01 00 00 
  801e5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5f:	25 07 0e 00 00       	and    $0xe07,%eax
  801e64:	89 c1                	mov    %eax,%ecx
  801e66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6e:	41 89 c8             	mov    %ecx,%r8d
  801e71:	48 89 d1             	mov    %rdx,%rcx
  801e74:	ba 00 00 00 00       	mov    $0x0,%edx
  801e79:	48 89 c6             	mov    %rax,%rsi
  801e7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e81:	48 b8 9d 17 80 00 00 	movabs $0x80179d,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax
  801e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e94:	79 02                	jns    801e98 <dup+0x16f>
		goto err;
  801e96:	eb 05                	jmp    801e9d <dup+0x174>

	return newfdnum;
  801e98:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e9b:	eb 33                	jmp    801ed0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801e9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea1:	48 89 c6             	mov    %rax,%rsi
  801ea4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea9:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  801eb0:	00 00 00 
  801eb3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801eb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb9:	48 89 c6             	mov    %rax,%rsi
  801ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec1:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	callq  *%rax
	return r;
  801ecd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ed0:	c9                   	leaveq 
  801ed1:	c3                   	retq   

0000000000801ed2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ed2:	55                   	push   %rbp
  801ed3:	48 89 e5             	mov    %rsp,%rbp
  801ed6:	48 83 ec 40          	sub    $0x40,%rsp
  801eda:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801edd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801ee1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ee5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ee9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801eec:	48 89 d6             	mov    %rdx,%rsi
  801eef:	89 c7                	mov    %eax,%edi
  801ef1:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  801ef8:	00 00 00 
  801efb:	ff d0                	callq  *%rax
  801efd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f04:	78 24                	js     801f2a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0a:	8b 00                	mov    (%rax),%eax
  801f0c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f10:	48 89 d6             	mov    %rdx,%rsi
  801f13:	89 c7                	mov    %eax,%edi
  801f15:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  801f1c:	00 00 00 
  801f1f:	ff d0                	callq  *%rax
  801f21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f28:	79 05                	jns    801f2f <read+0x5d>
		return r;
  801f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2d:	eb 76                	jmp    801fa5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f33:	8b 40 08             	mov    0x8(%rax),%eax
  801f36:	83 e0 03             	and    $0x3,%eax
  801f39:	83 f8 01             	cmp    $0x1,%eax
  801f3c:	75 3a                	jne    801f78 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f3e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f45:	00 00 00 
  801f48:	48 8b 00             	mov    (%rax),%rax
  801f4b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f51:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f54:	89 c6                	mov    %eax,%esi
  801f56:	48 bf 57 3b 80 00 00 	movabs $0x803b57,%rdi
  801f5d:	00 00 00 
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	48 b9 56 02 80 00 00 	movabs $0x800256,%rcx
  801f6c:	00 00 00 
  801f6f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801f71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f76:	eb 2d                	jmp    801fa5 <read+0xd3>
	}
	if (!dev->dev_read)
  801f78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f80:	48 85 c0             	test   %rax,%rax
  801f83:	75 07                	jne    801f8c <read+0xba>
		return -E_NOT_SUPP;
  801f85:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801f8a:	eb 19                	jmp    801fa5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f90:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f94:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f98:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801f9c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801fa0:	48 89 cf             	mov    %rcx,%rdi
  801fa3:	ff d0                	callq  *%rax
}
  801fa5:	c9                   	leaveq 
  801fa6:	c3                   	retq   

0000000000801fa7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801fa7:	55                   	push   %rbp
  801fa8:	48 89 e5             	mov    %rsp,%rbp
  801fab:	48 83 ec 30          	sub    $0x30,%rsp
  801faf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fb6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801fba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fc1:	eb 49                	jmp    80200c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc6:	48 98                	cltq   
  801fc8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fcc:	48 29 c2             	sub    %rax,%rdx
  801fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd2:	48 63 c8             	movslq %eax,%rcx
  801fd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd9:	48 01 c1             	add    %rax,%rcx
  801fdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fdf:	48 89 ce             	mov    %rcx,%rsi
  801fe2:	89 c7                	mov    %eax,%edi
  801fe4:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	callq  *%rax
  801ff0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801ff3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ff7:	79 05                	jns    801ffe <readn+0x57>
			return m;
  801ff9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ffc:	eb 1c                	jmp    80201a <readn+0x73>
		if (m == 0)
  801ffe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802002:	75 02                	jne    802006 <readn+0x5f>
			break;
  802004:	eb 11                	jmp    802017 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802006:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802009:	01 45 fc             	add    %eax,-0x4(%rbp)
  80200c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200f:	48 98                	cltq   
  802011:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802015:	72 ac                	jb     801fc3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802017:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80201a:	c9                   	leaveq 
  80201b:	c3                   	retq   

000000000080201c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80201c:	55                   	push   %rbp
  80201d:	48 89 e5             	mov    %rsp,%rbp
  802020:	48 83 ec 40          	sub    $0x40,%rsp
  802024:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802027:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80202b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80202f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802033:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802036:	48 89 d6             	mov    %rdx,%rsi
  802039:	89 c7                	mov    %eax,%edi
  80203b:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax
  802047:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80204a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80204e:	78 24                	js     802074 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802054:	8b 00                	mov    (%rax),%eax
  802056:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80205a:	48 89 d6             	mov    %rdx,%rsi
  80205d:	89 c7                	mov    %eax,%edi
  80205f:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  802066:	00 00 00 
  802069:	ff d0                	callq  *%rax
  80206b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802072:	79 05                	jns    802079 <write+0x5d>
		return r;
  802074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802077:	eb 75                	jmp    8020ee <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207d:	8b 40 08             	mov    0x8(%rax),%eax
  802080:	83 e0 03             	and    $0x3,%eax
  802083:	85 c0                	test   %eax,%eax
  802085:	75 3a                	jne    8020c1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802087:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80208e:	00 00 00 
  802091:	48 8b 00             	mov    (%rax),%rax
  802094:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80209a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80209d:	89 c6                	mov    %eax,%esi
  80209f:	48 bf 73 3b 80 00 00 	movabs $0x803b73,%rdi
  8020a6:	00 00 00 
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	48 b9 56 02 80 00 00 	movabs $0x800256,%rcx
  8020b5:	00 00 00 
  8020b8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020bf:	eb 2d                	jmp    8020ee <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020c9:	48 85 c0             	test   %rax,%rax
  8020cc:	75 07                	jne    8020d5 <write+0xb9>
		return -E_NOT_SUPP;
  8020ce:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020d3:	eb 19                	jmp    8020ee <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8020d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020e5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8020e9:	48 89 cf             	mov    %rcx,%rdi
  8020ec:	ff d0                	callq  *%rax
}
  8020ee:	c9                   	leaveq 
  8020ef:	c3                   	retq   

00000000008020f0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8020f0:	55                   	push   %rbp
  8020f1:	48 89 e5             	mov    %rsp,%rbp
  8020f4:	48 83 ec 18          	sub    $0x18,%rsp
  8020f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020fb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802102:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802105:	48 89 d6             	mov    %rdx,%rsi
  802108:	89 c7                	mov    %eax,%edi
  80210a:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
  802116:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802119:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80211d:	79 05                	jns    802124 <seek+0x34>
		return r;
  80211f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802122:	eb 0f                	jmp    802133 <seek+0x43>
	fd->fd_offset = offset;
  802124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802128:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80212b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802133:	c9                   	leaveq 
  802134:	c3                   	retq   

0000000000802135 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802135:	55                   	push   %rbp
  802136:	48 89 e5             	mov    %rsp,%rbp
  802139:	48 83 ec 30          	sub    $0x30,%rsp
  80213d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802140:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802143:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802147:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80214a:	48 89 d6             	mov    %rdx,%rsi
  80214d:	89 c7                	mov    %eax,%edi
  80214f:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  802156:	00 00 00 
  802159:	ff d0                	callq  *%rax
  80215b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80215e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802162:	78 24                	js     802188 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802168:	8b 00                	mov    (%rax),%eax
  80216a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80216e:	48 89 d6             	mov    %rdx,%rsi
  802171:	89 c7                	mov    %eax,%edi
  802173:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax
  80217f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802182:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802186:	79 05                	jns    80218d <ftruncate+0x58>
		return r;
  802188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218b:	eb 72                	jmp    8021ff <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80218d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802191:	8b 40 08             	mov    0x8(%rax),%eax
  802194:	83 e0 03             	and    $0x3,%eax
  802197:	85 c0                	test   %eax,%eax
  802199:	75 3a                	jne    8021d5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80219b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021a2:	00 00 00 
  8021a5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021a8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021ae:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021b1:	89 c6                	mov    %eax,%esi
  8021b3:	48 bf 90 3b 80 00 00 	movabs $0x803b90,%rdi
  8021ba:	00 00 00 
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	48 b9 56 02 80 00 00 	movabs $0x800256,%rcx
  8021c9:	00 00 00 
  8021cc:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8021ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021d3:	eb 2a                	jmp    8021ff <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8021d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021dd:	48 85 c0             	test   %rax,%rax
  8021e0:	75 07                	jne    8021e9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8021e2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021e7:	eb 16                	jmp    8021ff <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8021e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ed:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021f5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8021f8:	89 ce                	mov    %ecx,%esi
  8021fa:	48 89 d7             	mov    %rdx,%rdi
  8021fd:	ff d0                	callq  *%rax
}
  8021ff:	c9                   	leaveq 
  802200:	c3                   	retq   

0000000000802201 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802201:	55                   	push   %rbp
  802202:	48 89 e5             	mov    %rsp,%rbp
  802205:	48 83 ec 30          	sub    $0x30,%rsp
  802209:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80220c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802210:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802214:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802217:	48 89 d6             	mov    %rdx,%rsi
  80221a:	89 c7                	mov    %eax,%edi
  80221c:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  802223:	00 00 00 
  802226:	ff d0                	callq  *%rax
  802228:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80222b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222f:	78 24                	js     802255 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802235:	8b 00                	mov    (%rax),%eax
  802237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80223b:	48 89 d6             	mov    %rdx,%rsi
  80223e:	89 c7                	mov    %eax,%edi
  802240:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  802247:	00 00 00 
  80224a:	ff d0                	callq  *%rax
  80224c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802253:	79 05                	jns    80225a <fstat+0x59>
		return r;
  802255:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802258:	eb 5e                	jmp    8022b8 <fstat+0xb7>
	if (!dev->dev_stat)
  80225a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802262:	48 85 c0             	test   %rax,%rax
  802265:	75 07                	jne    80226e <fstat+0x6d>
		return -E_NOT_SUPP;
  802267:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80226c:	eb 4a                	jmp    8022b8 <fstat+0xb7>
	stat->st_name[0] = 0;
  80226e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802272:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802275:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802279:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802280:	00 00 00 
	stat->st_isdir = 0;
  802283:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802287:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80228e:	00 00 00 
	stat->st_dev = dev;
  802291:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802295:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802299:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8022a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ac:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022b0:	48 89 ce             	mov    %rcx,%rsi
  8022b3:	48 89 d7             	mov    %rdx,%rdi
  8022b6:	ff d0                	callq  *%rax
}
  8022b8:	c9                   	leaveq 
  8022b9:	c3                   	retq   

00000000008022ba <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022ba:	55                   	push   %rbp
  8022bb:	48 89 e5             	mov    %rsp,%rbp
  8022be:	48 83 ec 20          	sub    $0x20,%rsp
  8022c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ce:	be 00 00 00 00       	mov    $0x0,%esi
  8022d3:	48 89 c7             	mov    %rax,%rdi
  8022d6:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  8022dd:	00 00 00 
  8022e0:	ff d0                	callq  *%rax
  8022e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e9:	79 05                	jns    8022f0 <stat+0x36>
		return fd;
  8022eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ee:	eb 2f                	jmp    80231f <stat+0x65>
	r = fstat(fd, stat);
  8022f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f7:	48 89 d6             	mov    %rdx,%rsi
  8022fa:	89 c7                	mov    %eax,%edi
  8022fc:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  802303:	00 00 00 
  802306:	ff d0                	callq  *%rax
  802308:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80230b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230e:	89 c7                	mov    %eax,%edi
  802310:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  802317:	00 00 00 
  80231a:	ff d0                	callq  *%rax
	return r;
  80231c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80231f:	c9                   	leaveq 
  802320:	c3                   	retq   

0000000000802321 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802321:	55                   	push   %rbp
  802322:	48 89 e5             	mov    %rsp,%rbp
  802325:	48 83 ec 10          	sub    $0x10,%rsp
  802329:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80232c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802330:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802337:	00 00 00 
  80233a:	8b 00                	mov    (%rax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	75 1d                	jne    80235d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802340:	bf 01 00 00 00       	mov    $0x1,%edi
  802345:	48 b8 ec 34 80 00 00 	movabs $0x8034ec,%rax
  80234c:	00 00 00 
  80234f:	ff d0                	callq  *%rax
  802351:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802358:	00 00 00 
  80235b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80235d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802364:	00 00 00 
  802367:	8b 00                	mov    (%rax),%eax
  802369:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80236c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802371:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802378:	00 00 00 
  80237b:	89 c7                	mov    %eax,%edi
  80237d:	48 b8 54 34 80 00 00 	movabs $0x803454,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238d:	ba 00 00 00 00       	mov    $0x0,%edx
  802392:	48 89 c6             	mov    %rax,%rsi
  802395:	bf 00 00 00 00       	mov    $0x0,%edi
  80239a:	48 b8 93 33 80 00 00 	movabs $0x803393,%rax
  8023a1:	00 00 00 
  8023a4:	ff d0                	callq  *%rax
}
  8023a6:	c9                   	leaveq 
  8023a7:	c3                   	retq   

00000000008023a8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023a8:	55                   	push   %rbp
  8023a9:	48 89 e5             	mov    %rsp,%rbp
  8023ac:	48 83 ec 20          	sub    $0x20,%rsp
  8023b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023b4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	48 89 c7             	mov    %rax,%rdi
  8023be:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax
  8023ca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023cf:	7e 0a                	jle    8023db <open+0x33>
		return -E_BAD_PATH;
  8023d1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8023d6:	e9 a5 00 00 00       	jmpq   802480 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8023db:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8023df:	48 89 c7             	mov    %rax,%rdi
  8023e2:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax
  8023ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f5:	79 08                	jns    8023ff <open+0x57>
		return r;
  8023f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fa:	e9 81 00 00 00       	jmpq   802480 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8023ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802403:	48 89 c6             	mov    %rax,%rsi
  802406:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80240d:	00 00 00 
  802410:	48 b8 1e 0e 80 00 00 	movabs $0x800e1e,%rax
  802417:	00 00 00 
  80241a:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80241c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802423:	00 00 00 
  802426:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802429:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80242f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802433:	48 89 c6             	mov    %rax,%rsi
  802436:	bf 01 00 00 00       	mov    $0x1,%edi
  80243b:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
  802447:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244e:	79 1d                	jns    80246d <open+0xc5>
		fd_close(fd, 0);
  802450:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802454:	be 00 00 00 00       	mov    $0x0,%esi
  802459:	48 89 c7             	mov    %rax,%rdi
  80245c:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  802463:	00 00 00 
  802466:	ff d0                	callq  *%rax
		return r;
  802468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246b:	eb 13                	jmp    802480 <open+0xd8>
	}

	return fd2num(fd);
  80246d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802471:	48 89 c7             	mov    %rax,%rdi
  802474:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802480:	c9                   	leaveq 
  802481:	c3                   	retq   

0000000000802482 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802482:	55                   	push   %rbp
  802483:	48 89 e5             	mov    %rsp,%rbp
  802486:	48 83 ec 10          	sub    $0x10,%rsp
  80248a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80248e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802492:	8b 50 0c             	mov    0xc(%rax),%edx
  802495:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80249c:	00 00 00 
  80249f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8024a1:	be 00 00 00 00       	mov    $0x0,%esi
  8024a6:	bf 06 00 00 00       	mov    $0x6,%edi
  8024ab:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	callq  *%rax
}
  8024b7:	c9                   	leaveq 
  8024b8:	c3                   	retq   

00000000008024b9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8024b9:	55                   	push   %rbp
  8024ba:	48 89 e5             	mov    %rsp,%rbp
  8024bd:	48 83 ec 30          	sub    $0x30,%rsp
  8024c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d1:	8b 50 0c             	mov    0xc(%rax),%edx
  8024d4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024db:	00 00 00 
  8024de:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8024e0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024e7:	00 00 00 
  8024ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024ee:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8024f2:	be 00 00 00 00       	mov    $0x0,%esi
  8024f7:	bf 03 00 00 00       	mov    $0x3,%edi
  8024fc:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	79 08                	jns    802519 <devfile_read+0x60>
		return r;
  802511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802514:	e9 a4 00 00 00       	jmpq   8025bd <devfile_read+0x104>
	assert(r <= n);
  802519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251c:	48 98                	cltq   
  80251e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802522:	76 35                	jbe    802559 <devfile_read+0xa0>
  802524:	48 b9 bd 3b 80 00 00 	movabs $0x803bbd,%rcx
  80252b:	00 00 00 
  80252e:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  802535:	00 00 00 
  802538:	be 84 00 00 00       	mov    $0x84,%esi
  80253d:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  802544:	00 00 00 
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	49 b8 7f 32 80 00 00 	movabs $0x80327f,%r8
  802553:	00 00 00 
  802556:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802559:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802560:	7e 35                	jle    802597 <devfile_read+0xde>
  802562:	48 b9 e4 3b 80 00 00 	movabs $0x803be4,%rcx
  802569:	00 00 00 
  80256c:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  802573:	00 00 00 
  802576:	be 85 00 00 00       	mov    $0x85,%esi
  80257b:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  802582:	00 00 00 
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
  80258a:	49 b8 7f 32 80 00 00 	movabs $0x80327f,%r8
  802591:	00 00 00 
  802594:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802597:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80259a:	48 63 d0             	movslq %eax,%rdx
  80259d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a1:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8025a8:	00 00 00 
  8025ab:	48 89 c7             	mov    %rax,%rdi
  8025ae:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  8025b5:	00 00 00 
  8025b8:	ff d0                	callq  *%rax
	return r;
  8025ba:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8025bd:	c9                   	leaveq 
  8025be:	c3                   	retq   

00000000008025bf <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8025bf:	55                   	push   %rbp
  8025c0:	48 89 e5             	mov    %rsp,%rbp
  8025c3:	48 83 ec 30          	sub    $0x30,%rsp
  8025c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d7:	8b 50 0c             	mov    0xc(%rax),%edx
  8025da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025e1:	00 00 00 
  8025e4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8025e6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025ed:	00 00 00 
  8025f0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025f4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8025f8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8025ff:	00 
  802600:	76 35                	jbe    802637 <devfile_write+0x78>
  802602:	48 b9 f0 3b 80 00 00 	movabs $0x803bf0,%rcx
  802609:	00 00 00 
  80260c:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  802613:	00 00 00 
  802616:	be 9e 00 00 00       	mov    $0x9e,%esi
  80261b:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  802622:	00 00 00 
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
  80262a:	49 b8 7f 32 80 00 00 	movabs $0x80327f,%r8
  802631:	00 00 00 
  802634:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802637:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80263b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263f:	48 89 c6             	mov    %rax,%rsi
  802642:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802649:	00 00 00 
  80264c:	48 b8 59 12 80 00 00 	movabs $0x801259,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802658:	be 00 00 00 00       	mov    $0x0,%esi
  80265d:	bf 04 00 00 00       	mov    $0x4,%edi
  802662:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  802669:	00 00 00 
  80266c:	ff d0                	callq  *%rax
  80266e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802675:	79 05                	jns    80267c <devfile_write+0xbd>
		return r;
  802677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267a:	eb 43                	jmp    8026bf <devfile_write+0x100>
	assert(r <= n);
  80267c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267f:	48 98                	cltq   
  802681:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802685:	76 35                	jbe    8026bc <devfile_write+0xfd>
  802687:	48 b9 bd 3b 80 00 00 	movabs $0x803bbd,%rcx
  80268e:	00 00 00 
  802691:	48 ba c4 3b 80 00 00 	movabs $0x803bc4,%rdx
  802698:	00 00 00 
  80269b:	be a2 00 00 00       	mov    $0xa2,%esi
  8026a0:	48 bf d9 3b 80 00 00 	movabs $0x803bd9,%rdi
  8026a7:	00 00 00 
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026af:	49 b8 7f 32 80 00 00 	movabs $0x80327f,%r8
  8026b6:	00 00 00 
  8026b9:	41 ff d0             	callq  *%r8
	return r;
  8026bc:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8026bf:	c9                   	leaveq 
  8026c0:	c3                   	retq   

00000000008026c1 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026c1:	55                   	push   %rbp
  8026c2:	48 89 e5             	mov    %rsp,%rbp
  8026c5:	48 83 ec 20          	sub    $0x20,%rsp
  8026c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8026d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d5:	8b 50 0c             	mov    0xc(%rax),%edx
  8026d8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026df:	00 00 00 
  8026e2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8026e4:	be 00 00 00 00       	mov    $0x0,%esi
  8026e9:	bf 05 00 00 00       	mov    $0x5,%edi
  8026ee:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	callq  *%rax
  8026fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802701:	79 05                	jns    802708 <devfile_stat+0x47>
		return r;
  802703:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802706:	eb 56                	jmp    80275e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802708:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80270c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802713:	00 00 00 
  802716:	48 89 c7             	mov    %rax,%rdi
  802719:	48 b8 1e 0e 80 00 00 	movabs $0x800e1e,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802725:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80272c:	00 00 00 
  80272f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802735:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802739:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80273f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802746:	00 00 00 
  802749:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80274f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802753:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802759:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275e:	c9                   	leaveq 
  80275f:	c3                   	retq   

0000000000802760 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802760:	55                   	push   %rbp
  802761:	48 89 e5             	mov    %rsp,%rbp
  802764:	48 83 ec 10          	sub    $0x10,%rsp
  802768:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80276c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80276f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802773:	8b 50 0c             	mov    0xc(%rax),%edx
  802776:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80277d:	00 00 00 
  802780:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802782:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802789:	00 00 00 
  80278c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80278f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802792:	be 00 00 00 00       	mov    $0x0,%esi
  802797:	bf 02 00 00 00       	mov    $0x2,%edi
  80279c:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
}
  8027a8:	c9                   	leaveq 
  8027a9:	c3                   	retq   

00000000008027aa <remove>:

// Delete a file
int
remove(const char *path)
{
  8027aa:	55                   	push   %rbp
  8027ab:	48 89 e5             	mov    %rsp,%rbp
  8027ae:	48 83 ec 10          	sub    $0x10,%rsp
  8027b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8027b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ba:	48 89 c7             	mov    %rax,%rdi
  8027bd:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027ce:	7e 07                	jle    8027d7 <remove+0x2d>
		return -E_BAD_PATH;
  8027d0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027d5:	eb 33                	jmp    80280a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8027d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027db:	48 89 c6             	mov    %rax,%rsi
  8027de:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8027e5:	00 00 00 
  8027e8:	48 b8 1e 0e 80 00 00 	movabs $0x800e1e,%rax
  8027ef:	00 00 00 
  8027f2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8027f4:	be 00 00 00 00       	mov    $0x0,%esi
  8027f9:	bf 07 00 00 00       	mov    $0x7,%edi
  8027fe:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  802805:	00 00 00 
  802808:	ff d0                	callq  *%rax
}
  80280a:	c9                   	leaveq 
  80280b:	c3                   	retq   

000000000080280c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80280c:	55                   	push   %rbp
  80280d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802810:	be 00 00 00 00       	mov    $0x0,%esi
  802815:	bf 08 00 00 00       	mov    $0x8,%edi
  80281a:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
}
  802826:	5d                   	pop    %rbp
  802827:	c3                   	retq   

0000000000802828 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802828:	55                   	push   %rbp
  802829:	48 89 e5             	mov    %rsp,%rbp
  80282c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802833:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80283a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802841:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802848:	be 00 00 00 00       	mov    $0x0,%esi
  80284d:	48 89 c7             	mov    %rax,%rdi
  802850:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
  80285c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80285f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802863:	79 28                	jns    80288d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802865:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802868:	89 c6                	mov    %eax,%esi
  80286a:	48 bf 1d 3c 80 00 00 	movabs $0x803c1d,%rdi
  802871:	00 00 00 
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
  802879:	48 ba 56 02 80 00 00 	movabs $0x800256,%rdx
  802880:	00 00 00 
  802883:	ff d2                	callq  *%rdx
		return fd_src;
  802885:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802888:	e9 74 01 00 00       	jmpq   802a01 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80288d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802894:	be 01 01 00 00       	mov    $0x101,%esi
  802899:	48 89 c7             	mov    %rax,%rdi
  80289c:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  8028a3:	00 00 00 
  8028a6:	ff d0                	callq  *%rax
  8028a8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8028ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028af:	79 39                	jns    8028ea <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8028b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028b4:	89 c6                	mov    %eax,%esi
  8028b6:	48 bf 33 3c 80 00 00 	movabs $0x803c33,%rdi
  8028bd:	00 00 00 
  8028c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c5:	48 ba 56 02 80 00 00 	movabs $0x800256,%rdx
  8028cc:	00 00 00 
  8028cf:	ff d2                	callq  *%rdx
		close(fd_src);
  8028d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d4:	89 c7                	mov    %eax,%edi
  8028d6:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  8028dd:	00 00 00 
  8028e0:	ff d0                	callq  *%rax
		return fd_dest;
  8028e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028e5:	e9 17 01 00 00       	jmpq   802a01 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8028ea:	eb 74                	jmp    802960 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8028ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028ef:	48 63 d0             	movslq %eax,%rdx
  8028f2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8028f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028fc:	48 89 ce             	mov    %rcx,%rsi
  8028ff:	89 c7                	mov    %eax,%edi
  802901:	48 b8 1c 20 80 00 00 	movabs $0x80201c,%rax
  802908:	00 00 00 
  80290b:	ff d0                	callq  *%rax
  80290d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802910:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802914:	79 4a                	jns    802960 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802916:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802919:	89 c6                	mov    %eax,%esi
  80291b:	48 bf 4d 3c 80 00 00 	movabs $0x803c4d,%rdi
  802922:	00 00 00 
  802925:	b8 00 00 00 00       	mov    $0x0,%eax
  80292a:	48 ba 56 02 80 00 00 	movabs $0x800256,%rdx
  802931:	00 00 00 
  802934:	ff d2                	callq  *%rdx
			close(fd_src);
  802936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802939:	89 c7                	mov    %eax,%edi
  80293b:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
			close(fd_dest);
  802947:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80294a:	89 c7                	mov    %eax,%edi
  80294c:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  802953:	00 00 00 
  802956:	ff d0                	callq  *%rax
			return write_size;
  802958:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80295b:	e9 a1 00 00 00       	jmpq   802a01 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802960:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296a:	ba 00 02 00 00       	mov    $0x200,%edx
  80296f:	48 89 ce             	mov    %rcx,%rsi
  802972:	89 c7                	mov    %eax,%edi
  802974:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  80297b:	00 00 00 
  80297e:	ff d0                	callq  *%rax
  802980:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802983:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802987:	0f 8f 5f ff ff ff    	jg     8028ec <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80298d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802991:	79 47                	jns    8029da <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802993:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802996:	89 c6                	mov    %eax,%esi
  802998:	48 bf 60 3c 80 00 00 	movabs $0x803c60,%rdi
  80299f:	00 00 00 
  8029a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a7:	48 ba 56 02 80 00 00 	movabs $0x800256,%rdx
  8029ae:	00 00 00 
  8029b1:	ff d2                	callq  *%rdx
		close(fd_src);
  8029b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b6:	89 c7                	mov    %eax,%edi
  8029b8:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
		close(fd_dest);
  8029c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
		return read_size;
  8029d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029d8:	eb 27                	jmp    802a01 <copy+0x1d9>
	}
	close(fd_src);
  8029da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dd:	89 c7                	mov    %eax,%edi
  8029df:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
	close(fd_dest);
  8029eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ee:	89 c7                	mov    %eax,%edi
  8029f0:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  8029f7:	00 00 00 
  8029fa:	ff d0                	callq  *%rax
	return 0;
  8029fc:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802a01:	c9                   	leaveq 
  802a02:	c3                   	retq   

0000000000802a03 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a03:	55                   	push   %rbp
  802a04:	48 89 e5             	mov    %rsp,%rbp
  802a07:	53                   	push   %rbx
  802a08:	48 83 ec 38          	sub    $0x38,%rsp
  802a0c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a10:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a14:	48 89 c7             	mov    %rax,%rdi
  802a17:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
  802a23:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a26:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a2a:	0f 88 bf 01 00 00    	js     802bef <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a34:	ba 07 04 00 00       	mov    $0x407,%edx
  802a39:	48 89 c6             	mov    %rax,%rsi
  802a3c:	bf 00 00 00 00       	mov    $0x0,%edi
  802a41:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802a48:	00 00 00 
  802a4b:	ff d0                	callq  *%rax
  802a4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a54:	0f 88 95 01 00 00    	js     802bef <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802a5a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802a5e:	48 89 c7             	mov    %rax,%rdi
  802a61:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
  802a6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a74:	0f 88 5d 01 00 00    	js     802bd7 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7e:	ba 07 04 00 00       	mov    $0x407,%edx
  802a83:	48 89 c6             	mov    %rax,%rsi
  802a86:	bf 00 00 00 00       	mov    $0x0,%edi
  802a8b:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	callq  *%rax
  802a97:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a9e:	0f 88 33 01 00 00    	js     802bd7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa8:	48 89 c7             	mov    %rax,%rdi
  802aab:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802ab2:	00 00 00 
  802ab5:	ff d0                	callq  *%rax
  802ab7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802abb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802abf:	ba 07 04 00 00       	mov    $0x407,%edx
  802ac4:	48 89 c6             	mov    %rax,%rsi
  802ac7:	bf 00 00 00 00       	mov    $0x0,%edi
  802acc:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802adb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802adf:	79 05                	jns    802ae6 <pipe+0xe3>
		goto err2;
  802ae1:	e9 d9 00 00 00       	jmpq   802bbf <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ae6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aea:	48 89 c7             	mov    %rax,%rdi
  802aed:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
  802af9:	48 89 c2             	mov    %rax,%rdx
  802afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b00:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b06:	48 89 d1             	mov    %rdx,%rcx
  802b09:	ba 00 00 00 00       	mov    $0x0,%edx
  802b0e:	48 89 c6             	mov    %rax,%rsi
  802b11:	bf 00 00 00 00       	mov    $0x0,%edi
  802b16:	48 b8 9d 17 80 00 00 	movabs $0x80179d,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
  802b22:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b25:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b29:	79 1b                	jns    802b46 <pipe+0x143>
		goto err3;
  802b2b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802b2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b30:	48 89 c6             	mov    %rax,%rsi
  802b33:	bf 00 00 00 00       	mov    $0x0,%edi
  802b38:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
  802b44:	eb 79                	jmp    802bbf <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b4a:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b51:	00 00 00 
  802b54:	8b 12                	mov    (%rdx),%edx
  802b56:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802b58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b67:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b6e:	00 00 00 
  802b71:	8b 12                	mov    (%rdx),%edx
  802b73:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802b75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b79:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802b80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b84:	48 89 c7             	mov    %rax,%rdi
  802b87:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  802b8e:	00 00 00 
  802b91:	ff d0                	callq  *%rax
  802b93:	89 c2                	mov    %eax,%edx
  802b95:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b99:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802b9b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b9f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802ba3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba7:	48 89 c7             	mov    %rax,%rdi
  802baa:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
  802bb6:	89 03                	mov    %eax,(%rbx)
	return 0;
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbd:	eb 33                	jmp    802bf2 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802bbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bc3:	48 89 c6             	mov    %rax,%rsi
  802bc6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bcb:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802bd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bdb:	48 89 c6             	mov    %rax,%rsi
  802bde:	bf 00 00 00 00       	mov    $0x0,%edi
  802be3:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
err:
	return r;
  802bef:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802bf2:	48 83 c4 38          	add    $0x38,%rsp
  802bf6:	5b                   	pop    %rbx
  802bf7:	5d                   	pop    %rbp
  802bf8:	c3                   	retq   

0000000000802bf9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802bf9:	55                   	push   %rbp
  802bfa:	48 89 e5             	mov    %rsp,%rbp
  802bfd:	53                   	push   %rbx
  802bfe:	48 83 ec 28          	sub    $0x28,%rsp
  802c02:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c06:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c0a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c11:	00 00 00 
  802c14:	48 8b 00             	mov    (%rax),%rax
  802c17:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c24:	48 89 c7             	mov    %rax,%rdi
  802c27:	48 b8 6e 35 80 00 00 	movabs $0x80356e,%rax
  802c2e:	00 00 00 
  802c31:	ff d0                	callq  *%rax
  802c33:	89 c3                	mov    %eax,%ebx
  802c35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c39:	48 89 c7             	mov    %rax,%rdi
  802c3c:	48 b8 6e 35 80 00 00 	movabs $0x80356e,%rax
  802c43:	00 00 00 
  802c46:	ff d0                	callq  *%rax
  802c48:	39 c3                	cmp    %eax,%ebx
  802c4a:	0f 94 c0             	sete   %al
  802c4d:	0f b6 c0             	movzbl %al,%eax
  802c50:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802c53:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c5a:	00 00 00 
  802c5d:	48 8b 00             	mov    (%rax),%rax
  802c60:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c66:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802c69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c6c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c6f:	75 05                	jne    802c76 <_pipeisclosed+0x7d>
			return ret;
  802c71:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c74:	eb 4f                	jmp    802cc5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802c76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c79:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c7c:	74 42                	je     802cc0 <_pipeisclosed+0xc7>
  802c7e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802c82:	75 3c                	jne    802cc0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c84:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c8b:	00 00 00 
  802c8e:	48 8b 00             	mov    (%rax),%rax
  802c91:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802c97:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802c9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c9d:	89 c6                	mov    %eax,%esi
  802c9f:	48 bf 7b 3c 80 00 00 	movabs $0x803c7b,%rdi
  802ca6:	00 00 00 
  802ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cae:	49 b8 56 02 80 00 00 	movabs $0x800256,%r8
  802cb5:	00 00 00 
  802cb8:	41 ff d0             	callq  *%r8
	}
  802cbb:	e9 4a ff ff ff       	jmpq   802c0a <_pipeisclosed+0x11>
  802cc0:	e9 45 ff ff ff       	jmpq   802c0a <_pipeisclosed+0x11>
}
  802cc5:	48 83 c4 28          	add    $0x28,%rsp
  802cc9:	5b                   	pop    %rbx
  802cca:	5d                   	pop    %rbp
  802ccb:	c3                   	retq   

0000000000802ccc <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802ccc:	55                   	push   %rbp
  802ccd:	48 89 e5             	mov    %rsp,%rbp
  802cd0:	48 83 ec 30          	sub    $0x30,%rsp
  802cd4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cdb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cde:	48 89 d6             	mov    %rdx,%rsi
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf6:	79 05                	jns    802cfd <pipeisclosed+0x31>
		return r;
  802cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfb:	eb 31                	jmp    802d2e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802cfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d01:	48 89 c7             	mov    %rax,%rdi
  802d04:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802d0b:	00 00 00 
  802d0e:	ff d0                	callq  *%rax
  802d10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d1c:	48 89 d6             	mov    %rdx,%rsi
  802d1f:	48 89 c7             	mov    %rax,%rdi
  802d22:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  802d29:	00 00 00 
  802d2c:	ff d0                	callq  *%rax
}
  802d2e:	c9                   	leaveq 
  802d2f:	c3                   	retq   

0000000000802d30 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d30:	55                   	push   %rbp
  802d31:	48 89 e5             	mov    %rsp,%rbp
  802d34:	48 83 ec 40          	sub    $0x40,%rsp
  802d38:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d3c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d40:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d48:	48 89 c7             	mov    %rax,%rdi
  802d4b:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802d5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d63:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d6a:	00 
  802d6b:	e9 92 00 00 00       	jmpq   802e02 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802d70:	eb 41                	jmp    802db3 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d72:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802d77:	74 09                	je     802d82 <devpipe_read+0x52>
				return i;
  802d79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7d:	e9 92 00 00 00       	jmpq   802e14 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d8a:	48 89 d6             	mov    %rdx,%rsi
  802d8d:	48 89 c7             	mov    %rax,%rdi
  802d90:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 07                	je     802da7 <devpipe_read+0x77>
				return 0;
  802da0:	b8 00 00 00 00       	mov    $0x0,%eax
  802da5:	eb 6d                	jmp    802e14 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802da7:	48 b8 0f 17 80 00 00 	movabs $0x80170f,%rax
  802dae:	00 00 00 
  802db1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db7:	8b 10                	mov    (%rax),%edx
  802db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbd:	8b 40 04             	mov    0x4(%rax),%eax
  802dc0:	39 c2                	cmp    %eax,%edx
  802dc2:	74 ae                	je     802d72 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802dc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dcc:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802dd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd4:	8b 00                	mov    (%rax),%eax
  802dd6:	99                   	cltd   
  802dd7:	c1 ea 1b             	shr    $0x1b,%edx
  802dda:	01 d0                	add    %edx,%eax
  802ddc:	83 e0 1f             	and    $0x1f,%eax
  802ddf:	29 d0                	sub    %edx,%eax
  802de1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802de5:	48 98                	cltq   
  802de7:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802dec:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df2:	8b 00                	mov    (%rax),%eax
  802df4:	8d 50 01             	lea    0x1(%rax),%edx
  802df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfb:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802dfd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e06:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e0a:	0f 82 60 ff ff ff    	jb     802d70 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e14:	c9                   	leaveq 
  802e15:	c3                   	retq   

0000000000802e16 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e16:	55                   	push   %rbp
  802e17:	48 89 e5             	mov    %rsp,%rbp
  802e1a:	48 83 ec 40          	sub    $0x40,%rsp
  802e1e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e22:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e26:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e2e:	48 89 c7             	mov    %rax,%rdi
  802e31:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
  802e3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802e49:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802e50:	00 
  802e51:	e9 8e 00 00 00       	jmpq   802ee4 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e56:	eb 31                	jmp    802e89 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802e58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e60:	48 89 d6             	mov    %rdx,%rsi
  802e63:	48 89 c7             	mov    %rax,%rdi
  802e66:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 07                	je     802e7d <devpipe_write+0x67>
				return 0;
  802e76:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7b:	eb 79                	jmp    802ef6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802e7d:	48 b8 0f 17 80 00 00 	movabs $0x80170f,%rax
  802e84:	00 00 00 
  802e87:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e8d:	8b 40 04             	mov    0x4(%rax),%eax
  802e90:	48 63 d0             	movslq %eax,%rdx
  802e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e97:	8b 00                	mov    (%rax),%eax
  802e99:	48 98                	cltq   
  802e9b:	48 83 c0 20          	add    $0x20,%rax
  802e9f:	48 39 c2             	cmp    %rax,%rdx
  802ea2:	73 b4                	jae    802e58 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea8:	8b 40 04             	mov    0x4(%rax),%eax
  802eab:	99                   	cltd   
  802eac:	c1 ea 1b             	shr    $0x1b,%edx
  802eaf:	01 d0                	add    %edx,%eax
  802eb1:	83 e0 1f             	and    $0x1f,%eax
  802eb4:	29 d0                	sub    %edx,%eax
  802eb6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802eba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ebe:	48 01 ca             	add    %rcx,%rdx
  802ec1:	0f b6 0a             	movzbl (%rdx),%ecx
  802ec4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ec8:	48 98                	cltq   
  802eca:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed2:	8b 40 04             	mov    0x4(%rax),%eax
  802ed5:	8d 50 01             	lea    0x1(%rax),%edx
  802ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802edf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ee4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802eec:	0f 82 64 ff ff ff    	jb     802e56 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ef6:	c9                   	leaveq 
  802ef7:	c3                   	retq   

0000000000802ef8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ef8:	55                   	push   %rbp
  802ef9:	48 89 e5             	mov    %rsp,%rbp
  802efc:	48 83 ec 20          	sub    $0x20,%rsp
  802f00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0c:	48 89 c7             	mov    %rax,%rdi
  802f0f:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802f16:	00 00 00 
  802f19:	ff d0                	callq  *%rax
  802f1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f23:	48 be 8e 3c 80 00 00 	movabs $0x803c8e,%rsi
  802f2a:	00 00 00 
  802f2d:	48 89 c7             	mov    %rax,%rdi
  802f30:	48 b8 1e 0e 80 00 00 	movabs $0x800e1e,%rax
  802f37:	00 00 00 
  802f3a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802f3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f40:	8b 50 04             	mov    0x4(%rax),%edx
  802f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f47:	8b 00                	mov    (%rax),%eax
  802f49:	29 c2                	sub    %eax,%edx
  802f4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802f55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f59:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f60:	00 00 00 
	stat->st_dev = &devpipe;
  802f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f67:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802f6e:	00 00 00 
  802f71:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802f78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f7d:	c9                   	leaveq 
  802f7e:	c3                   	retq   

0000000000802f7f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802f7f:	55                   	push   %rbp
  802f80:	48 89 e5             	mov    %rsp,%rbp
  802f83:	48 83 ec 10          	sub    $0x10,%rsp
  802f87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802f8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8f:	48 89 c6             	mov    %rax,%rsi
  802f92:	bf 00 00 00 00       	mov    $0x0,%edi
  802f97:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa7:	48 89 c7             	mov    %rax,%rdi
  802faa:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802fb1:	00 00 00 
  802fb4:	ff d0                	callq  *%rax
  802fb6:	48 89 c6             	mov    %rax,%rsi
  802fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  802fbe:	48 b8 f8 17 80 00 00 	movabs $0x8017f8,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
}
  802fca:	c9                   	leaveq 
  802fcb:	c3                   	retq   

0000000000802fcc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802fcc:	55                   	push   %rbp
  802fcd:	48 89 e5             	mov    %rsp,%rbp
  802fd0:	48 83 ec 20          	sub    $0x20,%rsp
  802fd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802fd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fda:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802fdd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802fe1:	be 01 00 00 00       	mov    $0x1,%esi
  802fe6:	48 89 c7             	mov    %rax,%rdi
  802fe9:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <getchar>:

int
getchar(void)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802fff:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803003:	ba 01 00 00 00       	mov    $0x1,%edx
  803008:	48 89 c6             	mov    %rax,%rsi
  80300b:	bf 00 00 00 00       	mov    $0x0,%edi
  803010:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
  80301c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80301f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803023:	79 05                	jns    80302a <getchar+0x33>
		return r;
  803025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803028:	eb 14                	jmp    80303e <getchar+0x47>
	if (r < 1)
  80302a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302e:	7f 07                	jg     803037 <getchar+0x40>
		return -E_EOF;
  803030:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803035:	eb 07                	jmp    80303e <getchar+0x47>
	return c;
  803037:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80303b:	0f b6 c0             	movzbl %al,%eax
}
  80303e:	c9                   	leaveq 
  80303f:	c3                   	retq   

0000000000803040 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803040:	55                   	push   %rbp
  803041:	48 89 e5             	mov    %rsp,%rbp
  803044:	48 83 ec 20          	sub    $0x20,%rsp
  803048:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80304b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80304f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803052:	48 89 d6             	mov    %rdx,%rsi
  803055:	89 c7                	mov    %eax,%edi
  803057:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax
  803063:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803066:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306a:	79 05                	jns    803071 <iscons+0x31>
		return r;
  80306c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306f:	eb 1a                	jmp    80308b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803075:	8b 10                	mov    (%rax),%edx
  803077:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80307e:	00 00 00 
  803081:	8b 00                	mov    (%rax),%eax
  803083:	39 c2                	cmp    %eax,%edx
  803085:	0f 94 c0             	sete   %al
  803088:	0f b6 c0             	movzbl %al,%eax
}
  80308b:	c9                   	leaveq 
  80308c:	c3                   	retq   

000000000080308d <opencons>:

int
opencons(void)
{
  80308d:	55                   	push   %rbp
  80308e:	48 89 e5             	mov    %rsp,%rbp
  803091:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803095:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803099:	48 89 c7             	mov    %rax,%rdi
  80309c:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  8030a3:	00 00 00 
  8030a6:	ff d0                	callq  *%rax
  8030a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030af:	79 05                	jns    8030b6 <opencons+0x29>
		return r;
  8030b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b4:	eb 5b                	jmp    803111 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8030b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8030bf:	48 89 c6             	mov    %rax,%rsi
  8030c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c7:	48 b8 4d 17 80 00 00 	movabs $0x80174d,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	callq  *%rax
  8030d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030da:	79 05                	jns    8030e1 <opencons+0x54>
		return r;
  8030dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030df:	eb 30                	jmp    803111 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8030e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e5:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8030ec:	00 00 00 
  8030ef:	8b 12                	mov    (%rdx),%edx
  8030f1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8030f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8030fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803102:	48 89 c7             	mov    %rax,%rdi
  803105:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
}
  803111:	c9                   	leaveq 
  803112:	c3                   	retq   

0000000000803113 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803113:	55                   	push   %rbp
  803114:	48 89 e5             	mov    %rsp,%rbp
  803117:	48 83 ec 30          	sub    $0x30,%rsp
  80311b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80311f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803123:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803127:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80312c:	75 07                	jne    803135 <devcons_read+0x22>
		return 0;
  80312e:	b8 00 00 00 00       	mov    $0x0,%eax
  803133:	eb 4b                	jmp    803180 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803135:	eb 0c                	jmp    803143 <devcons_read+0x30>
		sys_yield();
  803137:	48 b8 0f 17 80 00 00 	movabs $0x80170f,%rax
  80313e:	00 00 00 
  803141:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803143:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  80314a:	00 00 00 
  80314d:	ff d0                	callq  *%rax
  80314f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803156:	74 df                	je     803137 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803158:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315c:	79 05                	jns    803163 <devcons_read+0x50>
		return c;
  80315e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803161:	eb 1d                	jmp    803180 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803163:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803167:	75 07                	jne    803170 <devcons_read+0x5d>
		return 0;
  803169:	b8 00 00 00 00       	mov    $0x0,%eax
  80316e:	eb 10                	jmp    803180 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803173:	89 c2                	mov    %eax,%edx
  803175:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803179:	88 10                	mov    %dl,(%rax)
	return 1;
  80317b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803180:	c9                   	leaveq 
  803181:	c3                   	retq   

0000000000803182 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803182:	55                   	push   %rbp
  803183:	48 89 e5             	mov    %rsp,%rbp
  803186:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80318d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803194:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80319b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8031a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031a9:	eb 76                	jmp    803221 <devcons_write+0x9f>
		m = n - tot;
  8031ab:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8031b2:	89 c2                	mov    %eax,%edx
  8031b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b7:	29 c2                	sub    %eax,%edx
  8031b9:	89 d0                	mov    %edx,%eax
  8031bb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8031be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031c1:	83 f8 7f             	cmp    $0x7f,%eax
  8031c4:	76 07                	jbe    8031cd <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8031c6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8031cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031d0:	48 63 d0             	movslq %eax,%rdx
  8031d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d6:	48 63 c8             	movslq %eax,%rcx
  8031d9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8031e0:	48 01 c1             	add    %rax,%rcx
  8031e3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8031ea:	48 89 ce             	mov    %rcx,%rsi
  8031ed:	48 89 c7             	mov    %rax,%rdi
  8031f0:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8031fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ff:	48 63 d0             	movslq %eax,%rdx
  803202:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803209:	48 89 d6             	mov    %rdx,%rsi
  80320c:	48 89 c7             	mov    %rax,%rdi
  80320f:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  803216:	00 00 00 
  803219:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80321b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80321e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803224:	48 98                	cltq   
  803226:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80322d:	0f 82 78 ff ff ff    	jb     8031ab <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803233:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803236:	c9                   	leaveq 
  803237:	c3                   	retq   

0000000000803238 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803238:	55                   	push   %rbp
  803239:	48 89 e5             	mov    %rsp,%rbp
  80323c:	48 83 ec 08          	sub    $0x8,%rsp
  803240:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803244:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803249:	c9                   	leaveq 
  80324a:	c3                   	retq   

000000000080324b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80324b:	55                   	push   %rbp
  80324c:	48 89 e5             	mov    %rsp,%rbp
  80324f:	48 83 ec 10          	sub    $0x10,%rsp
  803253:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803257:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80325b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325f:	48 be 9a 3c 80 00 00 	movabs $0x803c9a,%rsi
  803266:	00 00 00 
  803269:	48 89 c7             	mov    %rax,%rdi
  80326c:	48 b8 1e 0e 80 00 00 	movabs $0x800e1e,%rax
  803273:	00 00 00 
  803276:	ff d0                	callq  *%rax
	return 0;
  803278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80327d:	c9                   	leaveq 
  80327e:	c3                   	retq   

000000000080327f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80327f:	55                   	push   %rbp
  803280:	48 89 e5             	mov    %rsp,%rbp
  803283:	53                   	push   %rbx
  803284:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80328b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803292:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803298:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80329f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8032a6:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8032ad:	84 c0                	test   %al,%al
  8032af:	74 23                	je     8032d4 <_panic+0x55>
  8032b1:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8032b8:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8032bc:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8032c0:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8032c4:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8032c8:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8032cc:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8032d0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8032d4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8032db:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8032e2:	00 00 00 
  8032e5:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8032ec:	00 00 00 
  8032ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032f3:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8032fa:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803301:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803308:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80330f:	00 00 00 
  803312:	48 8b 18             	mov    (%rax),%rbx
  803315:	48 b8 d1 16 80 00 00 	movabs $0x8016d1,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	callq  *%rax
  803321:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803327:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80332e:	41 89 c8             	mov    %ecx,%r8d
  803331:	48 89 d1             	mov    %rdx,%rcx
  803334:	48 89 da             	mov    %rbx,%rdx
  803337:	89 c6                	mov    %eax,%esi
  803339:	48 bf a8 3c 80 00 00 	movabs $0x803ca8,%rdi
  803340:	00 00 00 
  803343:	b8 00 00 00 00       	mov    $0x0,%eax
  803348:	49 b9 56 02 80 00 00 	movabs $0x800256,%r9
  80334f:	00 00 00 
  803352:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803355:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80335c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803363:	48 89 d6             	mov    %rdx,%rsi
  803366:	48 89 c7             	mov    %rax,%rdi
  803369:	48 b8 aa 01 80 00 00 	movabs $0x8001aa,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
	cprintf("\n");
  803375:	48 bf cb 3c 80 00 00 	movabs $0x803ccb,%rdi
  80337c:	00 00 00 
  80337f:	b8 00 00 00 00       	mov    $0x0,%eax
  803384:	48 ba 56 02 80 00 00 	movabs $0x800256,%rdx
  80338b:	00 00 00 
  80338e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803390:	cc                   	int3   
  803391:	eb fd                	jmp    803390 <_panic+0x111>

0000000000803393 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803393:	55                   	push   %rbp
  803394:	48 89 e5             	mov    %rsp,%rbp
  803397:	48 83 ec 30          	sub    $0x30,%rsp
  80339b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80339f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8033a7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033ac:	75 0e                	jne    8033bc <ipc_recv+0x29>
        pg = (void *)UTOP;
  8033ae:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033b5:	00 00 00 
  8033b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8033bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c0:	48 89 c7             	mov    %rax,%rdi
  8033c3:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
  8033cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d6:	79 27                	jns    8033ff <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8033d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033dd:	74 0a                	je     8033e9 <ipc_recv+0x56>
            *from_env_store = 0;
  8033df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8033e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033ee:	74 0a                	je     8033fa <ipc_recv+0x67>
            *perm_store = 0;
  8033f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8033fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fd:	eb 53                	jmp    803452 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8033ff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803404:	74 19                	je     80341f <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803406:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80340d:	00 00 00 
  803410:	48 8b 00             	mov    (%rax),%rax
  803413:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341d:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80341f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803424:	74 19                	je     80343f <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803426:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80342d:	00 00 00 
  803430:	48 8b 00             	mov    (%rax),%rax
  803433:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80343d:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80343f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803446:	00 00 00 
  803449:	48 8b 00             	mov    (%rax),%rax
  80344c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803452:	c9                   	leaveq 
  803453:	c3                   	retq   

0000000000803454 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803454:	55                   	push   %rbp
  803455:	48 89 e5             	mov    %rsp,%rbp
  803458:	48 83 ec 30          	sub    $0x30,%rsp
  80345c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80345f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803462:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803466:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803469:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80346e:	75 0e                	jne    80347e <ipc_send+0x2a>
        pg = (void *)UTOP;
  803470:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803477:	00 00 00 
  80347a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  80347e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803481:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803484:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803488:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348b:	89 c7                	mov    %eax,%edi
  80348d:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
  803499:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  80349c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a0:	79 36                	jns    8034d8 <ipc_send+0x84>
  8034a2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034a6:	74 30                	je     8034d8 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8034a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ab:	89 c1                	mov    %eax,%ecx
  8034ad:	48 ba cd 3c 80 00 00 	movabs $0x803ccd,%rdx
  8034b4:	00 00 00 
  8034b7:	be 49 00 00 00       	mov    $0x49,%esi
  8034bc:	48 bf da 3c 80 00 00 	movabs $0x803cda,%rdi
  8034c3:	00 00 00 
  8034c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cb:	49 b8 7f 32 80 00 00 	movabs $0x80327f,%r8
  8034d2:	00 00 00 
  8034d5:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8034d8:	48 b8 0f 17 80 00 00 	movabs $0x80170f,%rax
  8034df:	00 00 00 
  8034e2:	ff d0                	callq  *%rax
    } while(r != 0);
  8034e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e8:	75 94                	jne    80347e <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8034ea:	c9                   	leaveq 
  8034eb:	c3                   	retq   

00000000008034ec <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034ec:	55                   	push   %rbp
  8034ed:	48 89 e5             	mov    %rsp,%rbp
  8034f0:	48 83 ec 14          	sub    $0x14,%rsp
  8034f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8034f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034fe:	eb 5e                	jmp    80355e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803500:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803507:	00 00 00 
  80350a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350d:	48 63 d0             	movslq %eax,%rdx
  803510:	48 89 d0             	mov    %rdx,%rax
  803513:	48 c1 e0 03          	shl    $0x3,%rax
  803517:	48 01 d0             	add    %rdx,%rax
  80351a:	48 c1 e0 05          	shl    $0x5,%rax
  80351e:	48 01 c8             	add    %rcx,%rax
  803521:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803527:	8b 00                	mov    (%rax),%eax
  803529:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80352c:	75 2c                	jne    80355a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80352e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803535:	00 00 00 
  803538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353b:	48 63 d0             	movslq %eax,%rdx
  80353e:	48 89 d0             	mov    %rdx,%rax
  803541:	48 c1 e0 03          	shl    $0x3,%rax
  803545:	48 01 d0             	add    %rdx,%rax
  803548:	48 c1 e0 05          	shl    $0x5,%rax
  80354c:	48 01 c8             	add    %rcx,%rax
  80354f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803555:	8b 40 08             	mov    0x8(%rax),%eax
  803558:	eb 12                	jmp    80356c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80355a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80355e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803565:	7e 99                	jle    803500 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803567:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80356c:	c9                   	leaveq 
  80356d:	c3                   	retq   

000000000080356e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80356e:	55                   	push   %rbp
  80356f:	48 89 e5             	mov    %rsp,%rbp
  803572:	48 83 ec 18          	sub    $0x18,%rsp
  803576:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80357a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357e:	48 c1 e8 15          	shr    $0x15,%rax
  803582:	48 89 c2             	mov    %rax,%rdx
  803585:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80358c:	01 00 00 
  80358f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803593:	83 e0 01             	and    $0x1,%eax
  803596:	48 85 c0             	test   %rax,%rax
  803599:	75 07                	jne    8035a2 <pageref+0x34>
		return 0;
  80359b:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a0:	eb 53                	jmp    8035f5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8035a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8035aa:	48 89 c2             	mov    %rax,%rdx
  8035ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035b4:	01 00 00 
  8035b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c3:	83 e0 01             	and    $0x1,%eax
  8035c6:	48 85 c0             	test   %rax,%rax
  8035c9:	75 07                	jne    8035d2 <pageref+0x64>
		return 0;
  8035cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d0:	eb 23                	jmp    8035f5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8035da:	48 89 c2             	mov    %rax,%rdx
  8035dd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035e4:	00 00 00 
  8035e7:	48 c1 e2 04          	shl    $0x4,%rdx
  8035eb:	48 01 d0             	add    %rdx,%rax
  8035ee:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035f2:	0f b7 c0             	movzwl %ax,%eax
}
  8035f5:	c9                   	leaveq 
  8035f6:	c3                   	retq   
