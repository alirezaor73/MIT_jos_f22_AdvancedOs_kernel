
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
  800052:	48 bf a0 1a 80 00 00 	movabs $0x801aa0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 6c 02 80 00 00 	movabs $0x80026c,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf ae 1a 80 00 00 	movabs $0x801aae,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 6c 02 80 00 00 	movabs $0x80026c,%rdx
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
	envid_t id = sys_getenvid();
  8000ae:	48 b8 e7 16 80 00 00 	movabs $0x8016e7,%rax
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
  8000e3:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000ea:	00 00 00 
  8000ed:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000f4:	7e 14                	jle    80010a <libmain+0x6b>
		binaryname = argv[0];
  8000f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fa:	48 8b 10             	mov    (%rax),%rdx
  8000fd:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  800134:	bf 00 00 00 00       	mov    $0x0,%edi
  800139:	48 b8 a3 16 80 00 00 	movabs $0x8016a3,%rax
  800140:	00 00 00 
  800143:	ff d0                	callq  *%rax
}
  800145:	5d                   	pop    %rbp
  800146:	c3                   	retq   

0000000000800147 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800152:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015a:	8b 00                	mov    (%rax),%eax
  80015c:	8d 48 01             	lea    0x1(%rax),%ecx
  80015f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800163:	89 0a                	mov    %ecx,(%rdx)
  800165:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800168:	89 d1                	mov    %edx,%ecx
  80016a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016e:	48 98                	cltq   
  800170:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800178:	8b 00                	mov    (%rax),%eax
  80017a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017f:	75 2c                	jne    8001ad <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800181:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800185:	8b 00                	mov    (%rax),%eax
  800187:	48 98                	cltq   
  800189:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018d:	48 83 c2 08          	add    $0x8,%rdx
  800191:	48 89 c6             	mov    %rax,%rsi
  800194:	48 89 d7             	mov    %rdx,%rdi
  800197:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax
        b->idx = 0;
  8001a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b1:	8b 40 04             	mov    0x4(%rax),%eax
  8001b4:	8d 50 01             	lea    0x1(%rax),%edx
  8001b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001be:	c9                   	leaveq 
  8001bf:	c3                   	retq   

00000000008001c0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001c0:	55                   	push   %rbp
  8001c1:	48 89 e5             	mov    %rsp,%rbp
  8001c4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001cb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001d9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001e0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001e7:	48 8b 0a             	mov    (%rdx),%rcx
  8001ea:	48 89 08             	mov    %rcx,(%rax)
  8001ed:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001f1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001f5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001f9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800204:	00 00 00 
    b.cnt = 0;
  800207:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80020e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800211:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800218:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80021f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	48 bf 47 01 80 00 00 	movabs $0x800147,%rdi
  800230:	00 00 00 
  800233:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  80023a:	00 00 00 
  80023d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80023f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800245:	48 98                	cltq   
  800247:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80024e:	48 83 c2 08          	add    $0x8,%rdx
  800252:	48 89 c6             	mov    %rax,%rsi
  800255:	48 89 d7             	mov    %rdx,%rdi
  800258:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800264:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80026a:	c9                   	leaveq 
  80026b:	c3                   	retq   

000000000080026c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80026c:	55                   	push   %rbp
  80026d:	48 89 e5             	mov    %rsp,%rbp
  800270:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800277:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80027e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800285:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80028c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800293:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80029a:	84 c0                	test   %al,%al
  80029c:	74 20                	je     8002be <cprintf+0x52>
  80029e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002a2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002a6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002aa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002ae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002b2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002b6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002ba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002be:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002c5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002cc:	00 00 00 
  8002cf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002d6:	00 00 00 
  8002d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002e4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002eb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002f2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002f9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800300:	48 8b 0a             	mov    (%rdx),%rcx
  800303:	48 89 08             	mov    %rcx,(%rax)
  800306:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80030a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80030e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800312:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800316:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80031d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800324:	48 89 d6             	mov    %rdx,%rsi
  800327:	48 89 c7             	mov    %rax,%rdi
  80032a:	48 b8 c0 01 80 00 00 	movabs $0x8001c0,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
  800336:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80033c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800342:	c9                   	leaveq 
  800343:	c3                   	retq   

0000000000800344 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800344:	55                   	push   %rbp
  800345:	48 89 e5             	mov    %rsp,%rbp
  800348:	53                   	push   %rbx
  800349:	48 83 ec 38          	sub    $0x38,%rsp
  80034d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800351:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800355:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800359:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80035c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800360:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800364:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800367:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80036b:	77 3b                	ja     8003a8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800370:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800374:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800377:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80037b:	ba 00 00 00 00       	mov    $0x0,%edx
  800380:	48 f7 f3             	div    %rbx
  800383:	48 89 c2             	mov    %rax,%rdx
  800386:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800389:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80038c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800394:	41 89 f9             	mov    %edi,%r9d
  800397:	48 89 c7             	mov    %rax,%rdi
  80039a:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  8003a1:	00 00 00 
  8003a4:	ff d0                	callq  *%rax
  8003a6:	eb 1e                	jmp    8003c6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a8:	eb 12                	jmp    8003bc <printnum+0x78>
			putch(padc, putdat);
  8003aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003ae:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b5:	48 89 ce             	mov    %rcx,%rsi
  8003b8:	89 d7                	mov    %edx,%edi
  8003ba:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003bc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003c4:	7f e4                	jg     8003aa <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d2:	48 f7 f1             	div    %rcx
  8003d5:	48 89 d0             	mov    %rdx,%rax
  8003d8:	48 ba 30 1c 80 00 00 	movabs $0x801c30,%rdx
  8003df:	00 00 00 
  8003e2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003e6:	0f be d0             	movsbl %al,%edx
  8003e9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f1:	48 89 ce             	mov    %rcx,%rsi
  8003f4:	89 d7                	mov    %edx,%edi
  8003f6:	ff d0                	callq  *%rax
}
  8003f8:	48 83 c4 38          	add    $0x38,%rsp
  8003fc:	5b                   	pop    %rbx
  8003fd:	5d                   	pop    %rbp
  8003fe:	c3                   	retq   

00000000008003ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ff:	55                   	push   %rbp
  800400:	48 89 e5             	mov    %rsp,%rbp
  800403:	48 83 ec 1c          	sub    $0x1c,%rsp
  800407:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80040b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80040e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800412:	7e 52                	jle    800466 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800418:	8b 00                	mov    (%rax),%eax
  80041a:	83 f8 30             	cmp    $0x30,%eax
  80041d:	73 24                	jae    800443 <getuint+0x44>
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
  800441:	eb 17                	jmp    80045a <getuint+0x5b>
  800443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800447:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80044b:	48 89 d0             	mov    %rdx,%rax
  80044e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800452:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800456:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80045a:	48 8b 00             	mov    (%rax),%rax
  80045d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800461:	e9 a3 00 00 00       	jmpq   800509 <getuint+0x10a>
	else if (lflag)
  800466:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80046a:	74 4f                	je     8004bb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80046c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800470:	8b 00                	mov    (%rax),%eax
  800472:	83 f8 30             	cmp    $0x30,%eax
  800475:	73 24                	jae    80049b <getuint+0x9c>
  800477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80047f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800483:	8b 00                	mov    (%rax),%eax
  800485:	89 c0                	mov    %eax,%eax
  800487:	48 01 d0             	add    %rdx,%rax
  80048a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80048e:	8b 12                	mov    (%rdx),%edx
  800490:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800493:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800497:	89 0a                	mov    %ecx,(%rdx)
  800499:	eb 17                	jmp    8004b2 <getuint+0xb3>
  80049b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004a3:	48 89 d0             	mov    %rdx,%rax
  8004a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004b2:	48 8b 00             	mov    (%rax),%rax
  8004b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004b9:	eb 4e                	jmp    800509 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bf:	8b 00                	mov    (%rax),%eax
  8004c1:	83 f8 30             	cmp    $0x30,%eax
  8004c4:	73 24                	jae    8004ea <getuint+0xeb>
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d2:	8b 00                	mov    (%rax),%eax
  8004d4:	89 c0                	mov    %eax,%eax
  8004d6:	48 01 d0             	add    %rdx,%rax
  8004d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004dd:	8b 12                	mov    (%rdx),%edx
  8004df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e6:	89 0a                	mov    %ecx,(%rdx)
  8004e8:	eb 17                	jmp    800501 <getuint+0x102>
  8004ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f2:	48 89 d0             	mov    %rdx,%rax
  8004f5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800501:	8b 00                	mov    (%rax),%eax
  800503:	89 c0                	mov    %eax,%eax
  800505:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80050d:	c9                   	leaveq 
  80050e:	c3                   	retq   

000000000080050f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80050f:	55                   	push   %rbp
  800510:	48 89 e5             	mov    %rsp,%rbp
  800513:	48 83 ec 1c          	sub    $0x1c,%rsp
  800517:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80051b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80051e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800522:	7e 52                	jle    800576 <getint+0x67>
		x=va_arg(*ap, long long);
  800524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800528:	8b 00                	mov    (%rax),%eax
  80052a:	83 f8 30             	cmp    $0x30,%eax
  80052d:	73 24                	jae    800553 <getint+0x44>
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
  800551:	eb 17                	jmp    80056a <getint+0x5b>
  800553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800557:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80055b:	48 89 d0             	mov    %rdx,%rax
  80055e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800562:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800566:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056a:	48 8b 00             	mov    (%rax),%rax
  80056d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800571:	e9 a3 00 00 00       	jmpq   800619 <getint+0x10a>
	else if (lflag)
  800576:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80057a:	74 4f                	je     8005cb <getint+0xbc>
		x=va_arg(*ap, long);
  80057c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800580:	8b 00                	mov    (%rax),%eax
  800582:	83 f8 30             	cmp    $0x30,%eax
  800585:	73 24                	jae    8005ab <getint+0x9c>
  800587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800593:	8b 00                	mov    (%rax),%eax
  800595:	89 c0                	mov    %eax,%eax
  800597:	48 01 d0             	add    %rdx,%rax
  80059a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059e:	8b 12                	mov    (%rdx),%edx
  8005a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a7:	89 0a                	mov    %ecx,(%rdx)
  8005a9:	eb 17                	jmp    8005c2 <getint+0xb3>
  8005ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b3:	48 89 d0             	mov    %rdx,%rax
  8005b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c2:	48 8b 00             	mov    (%rax),%rax
  8005c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c9:	eb 4e                	jmp    800619 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cf:	8b 00                	mov    (%rax),%eax
  8005d1:	83 f8 30             	cmp    $0x30,%eax
  8005d4:	73 24                	jae    8005fa <getint+0xeb>
  8005d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	8b 00                	mov    (%rax),%eax
  8005e4:	89 c0                	mov    %eax,%eax
  8005e6:	48 01 d0             	add    %rdx,%rax
  8005e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ed:	8b 12                	mov    (%rdx),%edx
  8005ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f6:	89 0a                	mov    %ecx,(%rdx)
  8005f8:	eb 17                	jmp    800611 <getint+0x102>
  8005fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800602:	48 89 d0             	mov    %rdx,%rax
  800605:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800609:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800611:	8b 00                	mov    (%rax),%eax
  800613:	48 98                	cltq   
  800615:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800619:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80061d:	c9                   	leaveq 
  80061e:	c3                   	retq   

000000000080061f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80061f:	55                   	push   %rbp
  800620:	48 89 e5             	mov    %rsp,%rbp
  800623:	41 54                	push   %r12
  800625:	53                   	push   %rbx
  800626:	48 83 ec 60          	sub    $0x60,%rsp
  80062a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80062e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800632:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800636:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80063a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80063e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800642:	48 8b 0a             	mov    (%rdx),%rcx
  800645:	48 89 08             	mov    %rcx,(%rax)
  800648:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80064c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800650:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800654:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800658:	eb 17                	jmp    800671 <vprintfmt+0x52>
			if (ch == '\0')
  80065a:	85 db                	test   %ebx,%ebx
  80065c:	0f 84 df 04 00 00    	je     800b41 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800662:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800666:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80066a:	48 89 d6             	mov    %rdx,%rsi
  80066d:	89 df                	mov    %ebx,%edi
  80066f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800671:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800675:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800679:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067d:	0f b6 00             	movzbl (%rax),%eax
  800680:	0f b6 d8             	movzbl %al,%ebx
  800683:	83 fb 25             	cmp    $0x25,%ebx
  800686:	75 d2                	jne    80065a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800688:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80068c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800693:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80069a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006a1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006b0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006b4:	0f b6 00             	movzbl (%rax),%eax
  8006b7:	0f b6 d8             	movzbl %al,%ebx
  8006ba:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006bd:	83 f8 55             	cmp    $0x55,%eax
  8006c0:	0f 87 47 04 00 00    	ja     800b0d <vprintfmt+0x4ee>
  8006c6:	89 c0                	mov    %eax,%eax
  8006c8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006cf:	00 
  8006d0:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  8006d7:	00 00 00 
  8006da:	48 01 d0             	add    %rdx,%rax
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006e2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006e6:	eb c0                	jmp    8006a8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006ec:	eb ba                	jmp    8006a8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006f5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006f8:	89 d0                	mov    %edx,%eax
  8006fa:	c1 e0 02             	shl    $0x2,%eax
  8006fd:	01 d0                	add    %edx,%eax
  8006ff:	01 c0                	add    %eax,%eax
  800701:	01 d8                	add    %ebx,%eax
  800703:	83 e8 30             	sub    $0x30,%eax
  800706:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800709:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80070d:	0f b6 00             	movzbl (%rax),%eax
  800710:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800713:	83 fb 2f             	cmp    $0x2f,%ebx
  800716:	7e 0c                	jle    800724 <vprintfmt+0x105>
  800718:	83 fb 39             	cmp    $0x39,%ebx
  80071b:	7f 07                	jg     800724 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800722:	eb d1                	jmp    8006f5 <vprintfmt+0xd6>
			goto process_precision;
  800724:	eb 58                	jmp    80077e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800726:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800729:	83 f8 30             	cmp    $0x30,%eax
  80072c:	73 17                	jae    800745 <vprintfmt+0x126>
  80072e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800732:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800735:	89 c0                	mov    %eax,%eax
  800737:	48 01 d0             	add    %rdx,%rax
  80073a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80073d:	83 c2 08             	add    $0x8,%edx
  800740:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800743:	eb 0f                	jmp    800754 <vprintfmt+0x135>
  800745:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800749:	48 89 d0             	mov    %rdx,%rax
  80074c:	48 83 c2 08          	add    $0x8,%rdx
  800750:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800754:	8b 00                	mov    (%rax),%eax
  800756:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800759:	eb 23                	jmp    80077e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80075b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80075f:	79 0c                	jns    80076d <vprintfmt+0x14e>
				width = 0;
  800761:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800768:	e9 3b ff ff ff       	jmpq   8006a8 <vprintfmt+0x89>
  80076d:	e9 36 ff ff ff       	jmpq   8006a8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800772:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800779:	e9 2a ff ff ff       	jmpq   8006a8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80077e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800782:	79 12                	jns    800796 <vprintfmt+0x177>
				width = precision, precision = -1;
  800784:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800787:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80078a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800791:	e9 12 ff ff ff       	jmpq   8006a8 <vprintfmt+0x89>
  800796:	e9 0d ff ff ff       	jmpq   8006a8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80079b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80079f:	e9 04 ff ff ff       	jmpq   8006a8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a7:	83 f8 30             	cmp    $0x30,%eax
  8007aa:	73 17                	jae    8007c3 <vprintfmt+0x1a4>
  8007ac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b3:	89 c0                	mov    %eax,%eax
  8007b5:	48 01 d0             	add    %rdx,%rax
  8007b8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007bb:	83 c2 08             	add    $0x8,%edx
  8007be:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c1:	eb 0f                	jmp    8007d2 <vprintfmt+0x1b3>
  8007c3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c7:	48 89 d0             	mov    %rdx,%rax
  8007ca:	48 83 c2 08          	add    $0x8,%rdx
  8007ce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d2:	8b 10                	mov    (%rax),%edx
  8007d4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007dc:	48 89 ce             	mov    %rcx,%rsi
  8007df:	89 d7                	mov    %edx,%edi
  8007e1:	ff d0                	callq  *%rax
			break;
  8007e3:	e9 53 03 00 00       	jmpq   800b3b <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007eb:	83 f8 30             	cmp    $0x30,%eax
  8007ee:	73 17                	jae    800807 <vprintfmt+0x1e8>
  8007f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ff:	83 c2 08             	add    $0x8,%edx
  800802:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800805:	eb 0f                	jmp    800816 <vprintfmt+0x1f7>
  800807:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080b:	48 89 d0             	mov    %rdx,%rax
  80080e:	48 83 c2 08          	add    $0x8,%rdx
  800812:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800816:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800818:	85 db                	test   %ebx,%ebx
  80081a:	79 02                	jns    80081e <vprintfmt+0x1ff>
				err = -err;
  80081c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80081e:	83 fb 15             	cmp    $0x15,%ebx
  800821:	7f 16                	jg     800839 <vprintfmt+0x21a>
  800823:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  80082a:	00 00 00 
  80082d:	48 63 d3             	movslq %ebx,%rdx
  800830:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800834:	4d 85 e4             	test   %r12,%r12
  800837:	75 2e                	jne    800867 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800839:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80083d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800841:	89 d9                	mov    %ebx,%ecx
  800843:	48 ba 41 1c 80 00 00 	movabs $0x801c41,%rdx
  80084a:	00 00 00 
  80084d:	48 89 c7             	mov    %rax,%rdi
  800850:	b8 00 00 00 00       	mov    $0x0,%eax
  800855:	49 b8 4a 0b 80 00 00 	movabs $0x800b4a,%r8
  80085c:	00 00 00 
  80085f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800862:	e9 d4 02 00 00       	jmpq   800b3b <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800867:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80086b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80086f:	4c 89 e1             	mov    %r12,%rcx
  800872:	48 ba 4a 1c 80 00 00 	movabs $0x801c4a,%rdx
  800879:	00 00 00 
  80087c:	48 89 c7             	mov    %rax,%rdi
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	49 b8 4a 0b 80 00 00 	movabs $0x800b4a,%r8
  80088b:	00 00 00 
  80088e:	41 ff d0             	callq  *%r8
			break;
  800891:	e9 a5 02 00 00       	jmpq   800b3b <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800896:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800899:	83 f8 30             	cmp    $0x30,%eax
  80089c:	73 17                	jae    8008b5 <vprintfmt+0x296>
  80089e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 01 d0             	add    %rdx,%rax
  8008aa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ad:	83 c2 08             	add    $0x8,%edx
  8008b0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b3:	eb 0f                	jmp    8008c4 <vprintfmt+0x2a5>
  8008b5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b9:	48 89 d0             	mov    %rdx,%rax
  8008bc:	48 83 c2 08          	add    $0x8,%rdx
  8008c0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c4:	4c 8b 20             	mov    (%rax),%r12
  8008c7:	4d 85 e4             	test   %r12,%r12
  8008ca:	75 0a                	jne    8008d6 <vprintfmt+0x2b7>
				p = "(null)";
  8008cc:	49 bc 4d 1c 80 00 00 	movabs $0x801c4d,%r12
  8008d3:	00 00 00 
			if (width > 0 && padc != '-')
  8008d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008da:	7e 3f                	jle    80091b <vprintfmt+0x2fc>
  8008dc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008e0:	74 39                	je     80091b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e5:	48 98                	cltq   
  8008e7:	48 89 c6             	mov    %rax,%rsi
  8008ea:	4c 89 e7             	mov    %r12,%rdi
  8008ed:	48 b8 f6 0d 80 00 00 	movabs $0x800df6,%rax
  8008f4:	00 00 00 
  8008f7:	ff d0                	callq  *%rax
  8008f9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008fc:	eb 17                	jmp    800915 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008fe:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800902:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800906:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090a:	48 89 ce             	mov    %rcx,%rsi
  80090d:	89 d7                	mov    %edx,%edi
  80090f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800915:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800919:	7f e3                	jg     8008fe <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	eb 37                	jmp    800954 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80091d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800921:	74 1e                	je     800941 <vprintfmt+0x322>
  800923:	83 fb 1f             	cmp    $0x1f,%ebx
  800926:	7e 05                	jle    80092d <vprintfmt+0x30e>
  800928:	83 fb 7e             	cmp    $0x7e,%ebx
  80092b:	7e 14                	jle    800941 <vprintfmt+0x322>
					putch('?', putdat);
  80092d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800931:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800935:	48 89 d6             	mov    %rdx,%rsi
  800938:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80093d:	ff d0                	callq  *%rax
  80093f:	eb 0f                	jmp    800950 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800941:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800945:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800949:	48 89 d6             	mov    %rdx,%rsi
  80094c:	89 df                	mov    %ebx,%edi
  80094e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800950:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800954:	4c 89 e0             	mov    %r12,%rax
  800957:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80095b:	0f b6 00             	movzbl (%rax),%eax
  80095e:	0f be d8             	movsbl %al,%ebx
  800961:	85 db                	test   %ebx,%ebx
  800963:	74 10                	je     800975 <vprintfmt+0x356>
  800965:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800969:	78 b2                	js     80091d <vprintfmt+0x2fe>
  80096b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80096f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800973:	79 a8                	jns    80091d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800975:	eb 16                	jmp    80098d <vprintfmt+0x36e>
				putch(' ', putdat);
  800977:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80097b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097f:	48 89 d6             	mov    %rdx,%rsi
  800982:	bf 20 00 00 00       	mov    $0x20,%edi
  800987:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800989:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80098d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800991:	7f e4                	jg     800977 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800993:	e9 a3 01 00 00       	jmpq   800b3b <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800998:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80099c:	be 03 00 00 00       	mov    $0x3,%esi
  8009a1:	48 89 c7             	mov    %rax,%rdi
  8009a4:	48 b8 0f 05 80 00 00 	movabs $0x80050f,%rax
  8009ab:	00 00 00 
  8009ae:	ff d0                	callq  *%rax
  8009b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	48 85 c0             	test   %rax,%rax
  8009bb:	79 1d                	jns    8009da <vprintfmt+0x3bb>
				putch('-', putdat);
  8009bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c5:	48 89 d6             	mov    %rdx,%rsi
  8009c8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009cd:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d3:	48 f7 d8             	neg    %rax
  8009d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009da:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e1:	e9 e8 00 00 00       	jmpq   800ace <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009e6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ea:	be 03 00 00 00       	mov    $0x3,%esi
  8009ef:	48 89 c7             	mov    %rax,%rdi
  8009f2:	48 b8 ff 03 80 00 00 	movabs $0x8003ff,%rax
  8009f9:	00 00 00 
  8009fc:	ff d0                	callq  *%rax
  8009fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a02:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a09:	e9 c0 00 00 00       	jmpq   800ace <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a16:	48 89 d6             	mov    %rdx,%rsi
  800a19:	bf 58 00 00 00       	mov    $0x58,%edi
  800a1e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a28:	48 89 d6             	mov    %rdx,%rsi
  800a2b:	bf 58 00 00 00       	mov    $0x58,%edi
  800a30:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3a:	48 89 d6             	mov    %rdx,%rsi
  800a3d:	bf 58 00 00 00       	mov    $0x58,%edi
  800a42:	ff d0                	callq  *%rax
			break;
  800a44:	e9 f2 00 00 00       	jmpq   800b3b <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a51:	48 89 d6             	mov    %rdx,%rsi
  800a54:	bf 30 00 00 00       	mov    $0x30,%edi
  800a59:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a63:	48 89 d6             	mov    %rdx,%rsi
  800a66:	bf 78 00 00 00       	mov    $0x78,%edi
  800a6b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 30             	cmp    $0x30,%eax
  800a73:	73 17                	jae    800a8c <vprintfmt+0x46d>
  800a75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	89 c0                	mov    %eax,%eax
  800a7e:	48 01 d0             	add    %rdx,%rax
  800a81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a84:	83 c2 08             	add    $0x8,%edx
  800a87:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8a:	eb 0f                	jmp    800a9b <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a90:	48 89 d0             	mov    %rdx,%rax
  800a93:	48 83 c2 08          	add    $0x8,%rdx
  800a97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800aa2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aa9:	eb 23                	jmp    800ace <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800aab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aaf:	be 03 00 00 00       	mov    $0x3,%esi
  800ab4:	48 89 c7             	mov    %rax,%rdi
  800ab7:	48 b8 ff 03 80 00 00 	movabs $0x8003ff,%rax
  800abe:	00 00 00 
  800ac1:	ff d0                	callq  *%rax
  800ac3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ac7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ace:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ad3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ad6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ad9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800add:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae5:	45 89 c1             	mov    %r8d,%r9d
  800ae8:	41 89 f8             	mov    %edi,%r8d
  800aeb:	48 89 c7             	mov    %rax,%rdi
  800aee:	48 b8 44 03 80 00 00 	movabs $0x800344,%rax
  800af5:	00 00 00 
  800af8:	ff d0                	callq  *%rax
			break;
  800afa:	eb 3f                	jmp    800b3b <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800afc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b04:	48 89 d6             	mov    %rdx,%rsi
  800b07:	89 df                	mov    %ebx,%edi
  800b09:	ff d0                	callq  *%rax
			break;
  800b0b:	eb 2e                	jmp    800b3b <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b15:	48 89 d6             	mov    %rdx,%rsi
  800b18:	bf 25 00 00 00       	mov    $0x25,%edi
  800b1d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b24:	eb 05                	jmp    800b2b <vprintfmt+0x50c>
  800b26:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b2b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b2f:	48 83 e8 01          	sub    $0x1,%rax
  800b33:	0f b6 00             	movzbl (%rax),%eax
  800b36:	3c 25                	cmp    $0x25,%al
  800b38:	75 ec                	jne    800b26 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b3a:	90                   	nop
		}
	}
  800b3b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3c:	e9 30 fb ff ff       	jmpq   800671 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b41:	48 83 c4 60          	add    $0x60,%rsp
  800b45:	5b                   	pop    %rbx
  800b46:	41 5c                	pop    %r12
  800b48:	5d                   	pop    %rbp
  800b49:	c3                   	retq   

0000000000800b4a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b4a:	55                   	push   %rbp
  800b4b:	48 89 e5             	mov    %rsp,%rbp
  800b4e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b55:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b5c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b63:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b6a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b71:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b78:	84 c0                	test   %al,%al
  800b7a:	74 20                	je     800b9c <printfmt+0x52>
  800b7c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b80:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b84:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b88:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b8c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b90:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b94:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b98:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b9c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ba3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800baa:	00 00 00 
  800bad:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bb4:	00 00 00 
  800bb7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bbb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bc2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bc9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bd7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bde:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800be5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bec:	48 89 c7             	mov    %rax,%rdi
  800bef:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bfb:	c9                   	leaveq 
  800bfc:	c3                   	retq   

0000000000800bfd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfd:	55                   	push   %rbp
  800bfe:	48 89 e5             	mov    %rsp,%rbp
  800c01:	48 83 ec 10          	sub    $0x10,%rsp
  800c05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c10:	8b 40 10             	mov    0x10(%rax),%eax
  800c13:	8d 50 01             	lea    0x1(%rax),%edx
  800c16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c21:	48 8b 10             	mov    (%rax),%rdx
  800c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c28:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c2c:	48 39 c2             	cmp    %rax,%rdx
  800c2f:	73 17                	jae    800c48 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c35:	48 8b 00             	mov    (%rax),%rax
  800c38:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c40:	48 89 0a             	mov    %rcx,(%rdx)
  800c43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c46:	88 10                	mov    %dl,(%rax)
}
  800c48:	c9                   	leaveq 
  800c49:	c3                   	retq   

0000000000800c4a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %rbp
  800c4b:	48 89 e5             	mov    %rsp,%rbp
  800c4e:	48 83 ec 50          	sub    $0x50,%rsp
  800c52:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c56:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c59:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c5d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c61:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c65:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c69:	48 8b 0a             	mov    (%rdx),%rcx
  800c6c:	48 89 08             	mov    %rcx,(%rax)
  800c6f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c73:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c77:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c7b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c83:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c87:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c8a:	48 98                	cltq   
  800c8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c90:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c94:	48 01 d0             	add    %rdx,%rax
  800c97:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ca2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ca7:	74 06                	je     800caf <vsnprintf+0x65>
  800ca9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cad:	7f 07                	jg     800cb6 <vsnprintf+0x6c>
		return -E_INVAL;
  800caf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb4:	eb 2f                	jmp    800ce5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cb6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cba:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cbe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cc2:	48 89 c6             	mov    %rax,%rsi
  800cc5:	48 bf fd 0b 80 00 00 	movabs $0x800bfd,%rdi
  800ccc:	00 00 00 
  800ccf:	48 b8 1f 06 80 00 00 	movabs $0x80061f,%rax
  800cd6:	00 00 00 
  800cd9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cdb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cdf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ce2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ce5:	c9                   	leaveq 
  800ce6:	c3                   	retq   

0000000000800ce7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce7:	55                   	push   %rbp
  800ce8:	48 89 e5             	mov    %rsp,%rbp
  800ceb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cf2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cf9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d14:	84 c0                	test   %al,%al
  800d16:	74 20                	je     800d38 <snprintf+0x51>
  800d18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d38:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d3f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d46:	00 00 00 
  800d49:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d50:	00 00 00 
  800d53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d57:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d65:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d6c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d73:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d7a:	48 8b 0a             	mov    (%rdx),%rcx
  800d7d:	48 89 08             	mov    %rcx,(%rax)
  800d80:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d84:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d88:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d8c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d90:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d97:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d9e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800da4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dab:	48 89 c7             	mov    %rax,%rdi
  800dae:	48 b8 4a 0c 80 00 00 	movabs $0x800c4a,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	callq  *%rax
  800dba:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dc0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dc6:	c9                   	leaveq 
  800dc7:	c3                   	retq   

0000000000800dc8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dc8:	55                   	push   %rbp
  800dc9:	48 89 e5             	mov    %rsp,%rbp
  800dcc:	48 83 ec 18          	sub    $0x18,%rsp
  800dd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ddb:	eb 09                	jmp    800de6 <strlen+0x1e>
		n++;
  800ddd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dea:	0f b6 00             	movzbl (%rax),%eax
  800ded:	84 c0                	test   %al,%al
  800def:	75 ec                	jne    800ddd <strlen+0x15>
		n++;
	return n;
  800df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800df4:	c9                   	leaveq 
  800df5:	c3                   	retq   

0000000000800df6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800df6:	55                   	push   %rbp
  800df7:	48 89 e5             	mov    %rsp,%rbp
  800dfa:	48 83 ec 20          	sub    $0x20,%rsp
  800dfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e0d:	eb 0e                	jmp    800e1d <strnlen+0x27>
		n++;
  800e0f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e13:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e18:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e22:	74 0b                	je     800e2f <strnlen+0x39>
  800e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e28:	0f b6 00             	movzbl (%rax),%eax
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 e0                	jne    800e0f <strnlen+0x19>
		n++;
	return n;
  800e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e32:	c9                   	leaveq 
  800e33:	c3                   	retq   

0000000000800e34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 83 ec 20          	sub    $0x20,%rsp
  800e3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e51:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e59:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e5d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e61:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e65:	0f b6 12             	movzbl (%rdx),%edx
  800e68:	88 10                	mov    %dl,(%rax)
  800e6a:	0f b6 00             	movzbl (%rax),%eax
  800e6d:	84 c0                	test   %al,%al
  800e6f:	75 dc                	jne    800e4d <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e75:	c9                   	leaveq 
  800e76:	c3                   	retq   

0000000000800e77 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e77:	55                   	push   %rbp
  800e78:	48 89 e5             	mov    %rsp,%rbp
  800e7b:	48 83 ec 20          	sub    $0x20,%rsp
  800e7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 c8 0d 80 00 00 	movabs $0x800dc8,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea0:	48 63 d0             	movslq %eax,%rdx
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 01 c2             	add    %rax,%rdx
  800eaa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eae:	48 89 c6             	mov    %rax,%rsi
  800eb1:	48 89 d7             	mov    %rdx,%rdi
  800eb4:	48 b8 34 0e 80 00 00 	movabs $0x800e34,%rax
  800ebb:	00 00 00 
  800ebe:	ff d0                	callq  *%rax
	return dst;
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ec4:	c9                   	leaveq 
  800ec5:	c3                   	retq   

0000000000800ec6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ec6:	55                   	push   %rbp
  800ec7:	48 89 e5             	mov    %rsp,%rbp
  800eca:	48 83 ec 28          	sub    $0x28,%rsp
  800ece:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ed6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ede:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ee2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ee9:	00 
  800eea:	eb 2a                	jmp    800f16 <strncpy+0x50>
		*dst++ = *src;
  800eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800efc:	0f b6 12             	movzbl (%rdx),%edx
  800eff:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f05:	0f b6 00             	movzbl (%rax),%eax
  800f08:	84 c0                	test   %al,%al
  800f0a:	74 05                	je     800f11 <strncpy+0x4b>
			src++;
  800f0c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f11:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f1a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f1e:	72 cc                	jb     800eec <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f24:	c9                   	leaveq 
  800f25:	c3                   	retq   

0000000000800f26 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f26:	55                   	push   %rbp
  800f27:	48 89 e5             	mov    %rsp,%rbp
  800f2a:	48 83 ec 28          	sub    $0x28,%rsp
  800f2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f36:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f42:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f47:	74 3d                	je     800f86 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f49:	eb 1d                	jmp    800f68 <strlcpy+0x42>
			*dst++ = *src++;
  800f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f53:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f57:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f5b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f5f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f63:	0f b6 12             	movzbl (%rdx),%edx
  800f66:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f6d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f72:	74 0b                	je     800f7f <strlcpy+0x59>
  800f74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f78:	0f b6 00             	movzbl (%rax),%eax
  800f7b:	84 c0                	test   %al,%al
  800f7d:	75 cc                	jne    800f4b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f83:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8e:	48 29 c2             	sub    %rax,%rdx
  800f91:	48 89 d0             	mov    %rdx,%rax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 83 ec 10          	sub    $0x10,%rsp
  800f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fa2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fa6:	eb 0a                	jmp    800fb2 <strcmp+0x1c>
		p++, q++;
  800fa8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fad:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb6:	0f b6 00             	movzbl (%rax),%eax
  800fb9:	84 c0                	test   %al,%al
  800fbb:	74 12                	je     800fcf <strcmp+0x39>
  800fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc1:	0f b6 10             	movzbl (%rax),%edx
  800fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc8:	0f b6 00             	movzbl (%rax),%eax
  800fcb:	38 c2                	cmp    %al,%dl
  800fcd:	74 d9                	je     800fa8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd3:	0f b6 00             	movzbl (%rax),%eax
  800fd6:	0f b6 d0             	movzbl %al,%edx
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdd:	0f b6 00             	movzbl (%rax),%eax
  800fe0:	0f b6 c0             	movzbl %al,%eax
  800fe3:	29 c2                	sub    %eax,%edx
  800fe5:	89 d0                	mov    %edx,%eax
}
  800fe7:	c9                   	leaveq 
  800fe8:	c3                   	retq   

0000000000800fe9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fe9:	55                   	push   %rbp
  800fea:	48 89 e5             	mov    %rsp,%rbp
  800fed:	48 83 ec 18          	sub    $0x18,%rsp
  800ff1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ff5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ff9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800ffd:	eb 0f                	jmp    80100e <strncmp+0x25>
		n--, p++, q++;
  800fff:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801004:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801009:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80100e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801013:	74 1d                	je     801032 <strncmp+0x49>
  801015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801019:	0f b6 00             	movzbl (%rax),%eax
  80101c:	84 c0                	test   %al,%al
  80101e:	74 12                	je     801032 <strncmp+0x49>
  801020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801024:	0f b6 10             	movzbl (%rax),%edx
  801027:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102b:	0f b6 00             	movzbl (%rax),%eax
  80102e:	38 c2                	cmp    %al,%dl
  801030:	74 cd                	je     800fff <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801032:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801037:	75 07                	jne    801040 <strncmp+0x57>
		return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
  80103e:	eb 18                	jmp    801058 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801044:	0f b6 00             	movzbl (%rax),%eax
  801047:	0f b6 d0             	movzbl %al,%edx
  80104a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104e:	0f b6 00             	movzbl (%rax),%eax
  801051:	0f b6 c0             	movzbl %al,%eax
  801054:	29 c2                	sub    %eax,%edx
  801056:	89 d0                	mov    %edx,%eax
}
  801058:	c9                   	leaveq 
  801059:	c3                   	retq   

000000000080105a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80105a:	55                   	push   %rbp
  80105b:	48 89 e5             	mov    %rsp,%rbp
  80105e:	48 83 ec 0c          	sub    $0xc,%rsp
  801062:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801066:	89 f0                	mov    %esi,%eax
  801068:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80106b:	eb 17                	jmp    801084 <strchr+0x2a>
		if (*s == c)
  80106d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801071:	0f b6 00             	movzbl (%rax),%eax
  801074:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801077:	75 06                	jne    80107f <strchr+0x25>
			return (char *) s;
  801079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107d:	eb 15                	jmp    801094 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80107f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	75 de                	jne    80106d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80108f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801094:	c9                   	leaveq 
  801095:	c3                   	retq   

0000000000801096 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801096:	55                   	push   %rbp
  801097:	48 89 e5             	mov    %rsp,%rbp
  80109a:	48 83 ec 0c          	sub    $0xc,%rsp
  80109e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a2:	89 f0                	mov    %esi,%eax
  8010a4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010a7:	eb 13                	jmp    8010bc <strfind+0x26>
		if (*s == c)
  8010a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ad:	0f b6 00             	movzbl (%rax),%eax
  8010b0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010b3:	75 02                	jne    8010b7 <strfind+0x21>
			break;
  8010b5:	eb 10                	jmp    8010c7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c0:	0f b6 00             	movzbl (%rax),%eax
  8010c3:	84 c0                	test   %al,%al
  8010c5:	75 e2                	jne    8010a9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010cb:	c9                   	leaveq 
  8010cc:	c3                   	retq   

00000000008010cd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	48 83 ec 18          	sub    $0x18,%rsp
  8010d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e5:	75 06                	jne    8010ed <memset+0x20>
		return v;
  8010e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010eb:	eb 69                	jmp    801156 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f1:	83 e0 03             	and    $0x3,%eax
  8010f4:	48 85 c0             	test   %rax,%rax
  8010f7:	75 48                	jne    801141 <memset+0x74>
  8010f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fd:	83 e0 03             	and    $0x3,%eax
  801100:	48 85 c0             	test   %rax,%rax
  801103:	75 3c                	jne    801141 <memset+0x74>
		c &= 0xFF;
  801105:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80110c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110f:	c1 e0 18             	shl    $0x18,%eax
  801112:	89 c2                	mov    %eax,%edx
  801114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801117:	c1 e0 10             	shl    $0x10,%eax
  80111a:	09 c2                	or     %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80111f:	c1 e0 08             	shl    $0x8,%eax
  801122:	09 d0                	or     %edx,%eax
  801124:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 c1 e8 02          	shr    $0x2,%rax
  80112f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801132:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801136:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801139:	48 89 d7             	mov    %rdx,%rdi
  80113c:	fc                   	cld    
  80113d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80113f:	eb 11                	jmp    801152 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801141:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801145:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801148:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80114c:	48 89 d7             	mov    %rdx,%rdi
  80114f:	fc                   	cld    
  801150:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 28          	sub    $0x28,%rsp
  801160:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801164:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801168:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80116c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801170:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80117c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801180:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801184:	0f 83 88 00 00 00    	jae    801212 <memmove+0xba>
  80118a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80118e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801192:	48 01 d0             	add    %rdx,%rax
  801195:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801199:	76 77                	jbe    801212 <memmove+0xba>
		s += n;
  80119b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011af:	83 e0 03             	and    $0x3,%eax
  8011b2:	48 85 c0             	test   %rax,%rax
  8011b5:	75 3b                	jne    8011f2 <memmove+0x9a>
  8011b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bb:	83 e0 03             	and    $0x3,%eax
  8011be:	48 85 c0             	test   %rax,%rax
  8011c1:	75 2f                	jne    8011f2 <memmove+0x9a>
  8011c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c7:	83 e0 03             	and    $0x3,%eax
  8011ca:	48 85 c0             	test   %rax,%rax
  8011cd:	75 23                	jne    8011f2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d3:	48 83 e8 04          	sub    $0x4,%rax
  8011d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011db:	48 83 ea 04          	sub    $0x4,%rdx
  8011df:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011e3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011e7:	48 89 c7             	mov    %rax,%rdi
  8011ea:	48 89 d6             	mov    %rdx,%rsi
  8011ed:	fd                   	std    
  8011ee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011f0:	eb 1d                	jmp    80120f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fe:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801206:	48 89 d7             	mov    %rdx,%rdi
  801209:	48 89 c1             	mov    %rax,%rcx
  80120c:	fd                   	std    
  80120d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80120f:	fc                   	cld    
  801210:	eb 57                	jmp    801269 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	83 e0 03             	and    $0x3,%eax
  801219:	48 85 c0             	test   %rax,%rax
  80121c:	75 36                	jne    801254 <memmove+0xfc>
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	83 e0 03             	and    $0x3,%eax
  801225:	48 85 c0             	test   %rax,%rax
  801228:	75 2a                	jne    801254 <memmove+0xfc>
  80122a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122e:	83 e0 03             	and    $0x3,%eax
  801231:	48 85 c0             	test   %rax,%rax
  801234:	75 1e                	jne    801254 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123a:	48 c1 e8 02          	shr    $0x2,%rax
  80123e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801245:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801249:	48 89 c7             	mov    %rax,%rdi
  80124c:	48 89 d6             	mov    %rdx,%rsi
  80124f:	fc                   	cld    
  801250:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801252:	eb 15                	jmp    801269 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801258:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801260:	48 89 c7             	mov    %rax,%rdi
  801263:	48 89 d6             	mov    %rdx,%rsi
  801266:	fc                   	cld    
  801267:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 18          	sub    $0x18,%rsp
  801277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80127b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80127f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801283:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801287:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80128b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128f:	48 89 ce             	mov    %rcx,%rsi
  801292:	48 89 c7             	mov    %rax,%rdi
  801295:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  80129c:	00 00 00 
  80129f:	ff d0                	callq  *%rax
}
  8012a1:	c9                   	leaveq 
  8012a2:	c3                   	retq   

00000000008012a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012a3:	55                   	push   %rbp
  8012a4:	48 89 e5             	mov    %rsp,%rbp
  8012a7:	48 83 ec 28          	sub    $0x28,%rsp
  8012ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012c7:	eb 36                	jmp    8012ff <memcmp+0x5c>
		if (*s1 != *s2)
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	0f b6 10             	movzbl (%rax),%edx
  8012d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d4:	0f b6 00             	movzbl (%rax),%eax
  8012d7:	38 c2                	cmp    %al,%dl
  8012d9:	74 1a                	je     8012f5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	0f b6 d0             	movzbl %al,%edx
  8012e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e9:	0f b6 00             	movzbl (%rax),%eax
  8012ec:	0f b6 c0             	movzbl %al,%eax
  8012ef:	29 c2                	sub    %eax,%edx
  8012f1:	89 d0                	mov    %edx,%eax
  8012f3:	eb 20                	jmp    801315 <memcmp+0x72>
		s1++, s2++;
  8012f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801303:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801307:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80130b:	48 85 c0             	test   %rax,%rax
  80130e:	75 b9                	jne    8012c9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801315:	c9                   	leaveq 
  801316:	c3                   	retq   

0000000000801317 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801317:	55                   	push   %rbp
  801318:	48 89 e5             	mov    %rsp,%rbp
  80131b:	48 83 ec 28          	sub    $0x28,%rsp
  80131f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801323:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801326:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80132a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801332:	48 01 d0             	add    %rdx,%rax
  801335:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801339:	eb 15                	jmp    801350 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133f:	0f b6 10             	movzbl (%rax),%edx
  801342:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801345:	38 c2                	cmp    %al,%dl
  801347:	75 02                	jne    80134b <memfind+0x34>
			break;
  801349:	eb 0f                	jmp    80135a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80134b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801354:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801358:	72 e1                	jb     80133b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80135a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 34          	sub    $0x34,%rsp
  801368:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80136c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801370:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80137a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801381:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801382:	eb 05                	jmp    801389 <strtol+0x29>
		s++;
  801384:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	3c 20                	cmp    $0x20,%al
  801392:	74 f0                	je     801384 <strtol+0x24>
  801394:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	3c 09                	cmp    $0x9,%al
  80139d:	74 e5                	je     801384 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80139f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a3:	0f b6 00             	movzbl (%rax),%eax
  8013a6:	3c 2b                	cmp    $0x2b,%al
  8013a8:	75 07                	jne    8013b1 <strtol+0x51>
		s++;
  8013aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013af:	eb 17                	jmp    8013c8 <strtol+0x68>
	else if (*s == '-')
  8013b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b5:	0f b6 00             	movzbl (%rax),%eax
  8013b8:	3c 2d                	cmp    $0x2d,%al
  8013ba:	75 0c                	jne    8013c8 <strtol+0x68>
		s++, neg = 1;
  8013bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013cc:	74 06                	je     8013d4 <strtol+0x74>
  8013ce:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013d2:	75 28                	jne    8013fc <strtol+0x9c>
  8013d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	3c 30                	cmp    $0x30,%al
  8013dd:	75 1d                	jne    8013fc <strtol+0x9c>
  8013df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e3:	48 83 c0 01          	add    $0x1,%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	3c 78                	cmp    $0x78,%al
  8013ec:	75 0e                	jne    8013fc <strtol+0x9c>
		s += 2, base = 16;
  8013ee:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013f3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013fa:	eb 2c                	jmp    801428 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801400:	75 19                	jne    80141b <strtol+0xbb>
  801402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	3c 30                	cmp    $0x30,%al
  80140b:	75 0e                	jne    80141b <strtol+0xbb>
		s++, base = 8;
  80140d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801412:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801419:	eb 0d                	jmp    801428 <strtol+0xc8>
	else if (base == 0)
  80141b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80141f:	75 07                	jne    801428 <strtol+0xc8>
		base = 10;
  801421:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	3c 2f                	cmp    $0x2f,%al
  801431:	7e 1d                	jle    801450 <strtol+0xf0>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	3c 39                	cmp    $0x39,%al
  80143c:	7f 12                	jg     801450 <strtol+0xf0>
			dig = *s - '0';
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	0f b6 00             	movzbl (%rax),%eax
  801445:	0f be c0             	movsbl %al,%eax
  801448:	83 e8 30             	sub    $0x30,%eax
  80144b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80144e:	eb 4e                	jmp    80149e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801450:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801454:	0f b6 00             	movzbl (%rax),%eax
  801457:	3c 60                	cmp    $0x60,%al
  801459:	7e 1d                	jle    801478 <strtol+0x118>
  80145b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	3c 7a                	cmp    $0x7a,%al
  801464:	7f 12                	jg     801478 <strtol+0x118>
			dig = *s - 'a' + 10;
  801466:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	0f be c0             	movsbl %al,%eax
  801470:	83 e8 57             	sub    $0x57,%eax
  801473:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801476:	eb 26                	jmp    80149e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	3c 40                	cmp    $0x40,%al
  801481:	7e 48                	jle    8014cb <strtol+0x16b>
  801483:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801487:	0f b6 00             	movzbl (%rax),%eax
  80148a:	3c 5a                	cmp    $0x5a,%al
  80148c:	7f 3d                	jg     8014cb <strtol+0x16b>
			dig = *s - 'A' + 10;
  80148e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	0f be c0             	movsbl %al,%eax
  801498:	83 e8 37             	sub    $0x37,%eax
  80149b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80149e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014a1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014a4:	7c 02                	jl     8014a8 <strtol+0x148>
			break;
  8014a6:	eb 23                	jmp    8014cb <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ad:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014b0:	48 98                	cltq   
  8014b2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014b7:	48 89 c2             	mov    %rax,%rdx
  8014ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014bd:	48 98                	cltq   
  8014bf:	48 01 d0             	add    %rdx,%rax
  8014c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014c6:	e9 5d ff ff ff       	jmpq   801428 <strtol+0xc8>

	if (endptr)
  8014cb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014d0:	74 0b                	je     8014dd <strtol+0x17d>
		*endptr = (char *) s;
  8014d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014da:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014e1:	74 09                	je     8014ec <strtol+0x18c>
  8014e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e7:	48 f7 d8             	neg    %rax
  8014ea:	eb 04                	jmp    8014f0 <strtol+0x190>
  8014ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014f0:	c9                   	leaveq 
  8014f1:	c3                   	retq   

00000000008014f2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014f2:	55                   	push   %rbp
  8014f3:	48 89 e5             	mov    %rsp,%rbp
  8014f6:	48 83 ec 30          	sub    $0x30,%rsp
  8014fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801502:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801506:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80150a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80150e:	0f b6 00             	movzbl (%rax),%eax
  801511:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801514:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801518:	75 06                	jne    801520 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80151a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151e:	eb 6b                	jmp    80158b <strstr+0x99>

	len = strlen(str);
  801520:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801524:	48 89 c7             	mov    %rax,%rdi
  801527:	48 b8 c8 0d 80 00 00 	movabs $0x800dc8,%rax
  80152e:	00 00 00 
  801531:	ff d0                	callq  *%rax
  801533:	48 98                	cltq   
  801535:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801539:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801541:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801545:	0f b6 00             	movzbl (%rax),%eax
  801548:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80154b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80154f:	75 07                	jne    801558 <strstr+0x66>
				return (char *) 0;
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	eb 33                	jmp    80158b <strstr+0x99>
		} while (sc != c);
  801558:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80155c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80155f:	75 d8                	jne    801539 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801561:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801565:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156d:	48 89 ce             	mov    %rcx,%rsi
  801570:	48 89 c7             	mov    %rax,%rdi
  801573:	48 b8 e9 0f 80 00 00 	movabs $0x800fe9,%rax
  80157a:	00 00 00 
  80157d:	ff d0                	callq  *%rax
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 b6                	jne    801539 <strstr+0x47>

	return (char *) (in - 1);
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	48 83 e8 01          	sub    $0x1,%rax
}
  80158b:	c9                   	leaveq 
  80158c:	c3                   	retq   

000000000080158d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80158d:	55                   	push   %rbp
  80158e:	48 89 e5             	mov    %rsp,%rbp
  801591:	53                   	push   %rbx
  801592:	48 83 ec 48          	sub    $0x48,%rsp
  801596:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801599:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80159c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015a0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015a4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015a8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015af:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015b3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015b7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015bb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015bf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015c3:	4c 89 c3             	mov    %r8,%rbx
  8015c6:	cd 30                	int    $0x30
  8015c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015d0:	74 3e                	je     801610 <syscall+0x83>
  8015d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d7:	7e 37                	jle    801610 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e0:	49 89 d0             	mov    %rdx,%r8
  8015e3:	89 c1                	mov    %eax,%ecx
  8015e5:	48 ba 08 1f 80 00 00 	movabs $0x801f08,%rdx
  8015ec:	00 00 00 
  8015ef:	be 23 00 00 00       	mov    $0x23,%esi
  8015f4:	48 bf 25 1f 80 00 00 	movabs $0x801f25,%rdi
  8015fb:	00 00 00 
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801603:	49 b9 86 19 80 00 00 	movabs $0x801986,%r9
  80160a:	00 00 00 
  80160d:	41 ff d1             	callq  *%r9

	return ret;
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801614:	48 83 c4 48          	add    $0x48,%rsp
  801618:	5b                   	pop    %rbx
  801619:	5d                   	pop    %rbp
  80161a:	c3                   	retq   

000000000080161b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80161b:	55                   	push   %rbp
  80161c:	48 89 e5             	mov    %rsp,%rbp
  80161f:	48 83 ec 20          	sub    $0x20,%rsp
  801623:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801627:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80162b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801633:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80163a:	00 
  80163b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801641:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801647:	48 89 d1             	mov    %rdx,%rcx
  80164a:	48 89 c2             	mov    %rax,%rdx
  80164d:	be 00 00 00 00       	mov    $0x0,%esi
  801652:	bf 00 00 00 00       	mov    $0x0,%edi
  801657:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80165e:	00 00 00 
  801661:	ff d0                	callq  *%rax
}
  801663:	c9                   	leaveq 
  801664:	c3                   	retq   

0000000000801665 <sys_cgetc>:

int
sys_cgetc(void)
{
  801665:	55                   	push   %rbp
  801666:	48 89 e5             	mov    %rsp,%rbp
  801669:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80166d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801674:	00 
  801675:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80167b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801681:	b9 00 00 00 00       	mov    $0x0,%ecx
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	be 00 00 00 00       	mov    $0x0,%esi
  801690:	bf 01 00 00 00       	mov    $0x1,%edi
  801695:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80169c:	00 00 00 
  80169f:	ff d0                	callq  *%rax
}
  8016a1:	c9                   	leaveq 
  8016a2:	c3                   	retq   

00000000008016a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016a3:	55                   	push   %rbp
  8016a4:	48 89 e5             	mov    %rsp,%rbp
  8016a7:	48 83 ec 10          	sub    $0x10,%rsp
  8016ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016b1:	48 98                	cltq   
  8016b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ba:	00 
  8016bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016cc:	48 89 c2             	mov    %rax,%rdx
  8016cf:	be 01 00 00 00       	mov    $0x1,%esi
  8016d4:	bf 03 00 00 00       	mov    $0x3,%edi
  8016d9:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  8016e0:	00 00 00 
  8016e3:	ff d0                	callq  *%rax
}
  8016e5:	c9                   	leaveq 
  8016e6:	c3                   	retq   

00000000008016e7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016e7:	55                   	push   %rbp
  8016e8:	48 89 e5             	mov    %rsp,%rbp
  8016eb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f6:	00 
  8016f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801703:	b9 00 00 00 00       	mov    $0x0,%ecx
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	be 00 00 00 00       	mov    $0x0,%esi
  801712:	bf 02 00 00 00       	mov    $0x2,%edi
  801717:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80171e:	00 00 00 
  801721:	ff d0                	callq  *%rax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <sys_yield>:

void
sys_yield(void)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80172d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801734:	00 
  801735:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80173b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801741:	b9 00 00 00 00       	mov    $0x0,%ecx
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	be 00 00 00 00       	mov    $0x0,%esi
  801750:	bf 0a 00 00 00       	mov    $0xa,%edi
  801755:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	callq  *%rax
}
  801761:	c9                   	leaveq 
  801762:	c3                   	retq   

0000000000801763 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801763:	55                   	push   %rbp
  801764:	48 89 e5             	mov    %rsp,%rbp
  801767:	48 83 ec 20          	sub    $0x20,%rsp
  80176b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80176e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801772:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801778:	48 63 c8             	movslq %eax,%rcx
  80177b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801782:	48 98                	cltq   
  801784:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178b:	00 
  80178c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801792:	49 89 c8             	mov    %rcx,%r8
  801795:	48 89 d1             	mov    %rdx,%rcx
  801798:	48 89 c2             	mov    %rax,%rdx
  80179b:	be 01 00 00 00       	mov    $0x1,%esi
  8017a0:	bf 04 00 00 00       	mov    $0x4,%edi
  8017a5:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  8017ac:	00 00 00 
  8017af:	ff d0                	callq  *%rax
}
  8017b1:	c9                   	leaveq 
  8017b2:	c3                   	retq   

00000000008017b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017b3:	55                   	push   %rbp
  8017b4:	48 89 e5             	mov    %rsp,%rbp
  8017b7:	48 83 ec 30          	sub    $0x30,%rsp
  8017bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017c2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017c5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017c9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017d0:	48 63 c8             	movslq %eax,%rcx
  8017d3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017da:	48 63 f0             	movslq %eax,%rsi
  8017dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e4:	48 98                	cltq   
  8017e6:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017ea:	49 89 f9             	mov    %rdi,%r9
  8017ed:	49 89 f0             	mov    %rsi,%r8
  8017f0:	48 89 d1             	mov    %rdx,%rcx
  8017f3:	48 89 c2             	mov    %rax,%rdx
  8017f6:	be 01 00 00 00       	mov    $0x1,%esi
  8017fb:	bf 05 00 00 00       	mov    $0x5,%edi
  801800:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  801807:	00 00 00 
  80180a:	ff d0                	callq  *%rax
}
  80180c:	c9                   	leaveq 
  80180d:	c3                   	retq   

000000000080180e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80180e:	55                   	push   %rbp
  80180f:	48 89 e5             	mov    %rsp,%rbp
  801812:	48 83 ec 20          	sub    $0x20,%rsp
  801816:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801819:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80181d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801824:	48 98                	cltq   
  801826:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182d:	00 
  80182e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801834:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80183a:	48 89 d1             	mov    %rdx,%rcx
  80183d:	48 89 c2             	mov    %rax,%rdx
  801840:	be 01 00 00 00       	mov    $0x1,%esi
  801845:	bf 06 00 00 00       	mov    $0x6,%edi
  80184a:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  801851:	00 00 00 
  801854:	ff d0                	callq  *%rax
}
  801856:	c9                   	leaveq 
  801857:	c3                   	retq   

0000000000801858 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801858:	55                   	push   %rbp
  801859:	48 89 e5             	mov    %rsp,%rbp
  80185c:	48 83 ec 10          	sub    $0x10,%rsp
  801860:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801863:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801866:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801869:	48 63 d0             	movslq %eax,%rdx
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801878:	00 
  801879:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801885:	48 89 d1             	mov    %rdx,%rcx
  801888:	48 89 c2             	mov    %rax,%rdx
  80188b:	be 01 00 00 00       	mov    $0x1,%esi
  801890:	bf 08 00 00 00       	mov    $0x8,%edi
  801895:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80189c:	00 00 00 
  80189f:	ff d0                	callq  *%rax
}
  8018a1:	c9                   	leaveq 
  8018a2:	c3                   	retq   

00000000008018a3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018a3:	55                   	push   %rbp
  8018a4:	48 89 e5             	mov    %rsp,%rbp
  8018a7:	48 83 ec 20          	sub    $0x20,%rsp
  8018ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b9:	48 98                	cltq   
  8018bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c2:	00 
  8018c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cf:	48 89 d1             	mov    %rdx,%rcx
  8018d2:	48 89 c2             	mov    %rax,%rdx
  8018d5:	be 01 00 00 00       	mov    $0x1,%esi
  8018da:	bf 09 00 00 00       	mov    $0x9,%edi
  8018df:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	callq  *%rax
}
  8018eb:	c9                   	leaveq 
  8018ec:	c3                   	retq   

00000000008018ed <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018ed:	55                   	push   %rbp
  8018ee:	48 89 e5             	mov    %rsp,%rbp
  8018f1:	48 83 ec 20          	sub    $0x20,%rsp
  8018f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801900:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801903:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801906:	48 63 f0             	movslq %eax,%rsi
  801909:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80190d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801910:	48 98                	cltq   
  801912:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801916:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191d:	00 
  80191e:	49 89 f1             	mov    %rsi,%r9
  801921:	49 89 c8             	mov    %rcx,%r8
  801924:	48 89 d1             	mov    %rdx,%rcx
  801927:	48 89 c2             	mov    %rax,%rdx
  80192a:	be 00 00 00 00       	mov    $0x0,%esi
  80192f:	bf 0b 00 00 00       	mov    $0xb,%edi
  801934:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80193b:	00 00 00 
  80193e:	ff d0                	callq  *%rax
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   

0000000000801942 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801942:	55                   	push   %rbp
  801943:	48 89 e5             	mov    %rsp,%rbp
  801946:	48 83 ec 10          	sub    $0x10,%rsp
  80194a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80194e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801952:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801959:	00 
  80195a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801960:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801966:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196b:	48 89 c2             	mov    %rax,%rdx
  80196e:	be 01 00 00 00       	mov    $0x1,%esi
  801973:	bf 0c 00 00 00       	mov    $0xc,%edi
  801978:	48 b8 8d 15 80 00 00 	movabs $0x80158d,%rax
  80197f:	00 00 00 
  801982:	ff d0                	callq  *%rax
}
  801984:	c9                   	leaveq 
  801985:	c3                   	retq   

0000000000801986 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801986:	55                   	push   %rbp
  801987:	48 89 e5             	mov    %rsp,%rbp
  80198a:	53                   	push   %rbx
  80198b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801992:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801999:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80199f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8019a6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8019ad:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8019b4:	84 c0                	test   %al,%al
  8019b6:	74 23                	je     8019db <_panic+0x55>
  8019b8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8019bf:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8019c3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019c7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019cb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019cf:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019d3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019d7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8019db:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019e2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019e9:	00 00 00 
  8019ec:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019f3:	00 00 00 
  8019f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019fa:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801a01:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801a08:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a0f:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801a16:	00 00 00 
  801a19:	48 8b 18             	mov    (%rax),%rbx
  801a1c:	48 b8 e7 16 80 00 00 	movabs $0x8016e7,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
  801a28:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801a2e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801a35:	41 89 c8             	mov    %ecx,%r8d
  801a38:	48 89 d1             	mov    %rdx,%rcx
  801a3b:	48 89 da             	mov    %rbx,%rdx
  801a3e:	89 c6                	mov    %eax,%esi
  801a40:	48 bf 38 1f 80 00 00 	movabs $0x801f38,%rdi
  801a47:	00 00 00 
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4f:	49 b9 6c 02 80 00 00 	movabs $0x80026c,%r9
  801a56:	00 00 00 
  801a59:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a5c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a63:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a6a:	48 89 d6             	mov    %rdx,%rsi
  801a6d:	48 89 c7             	mov    %rax,%rdi
  801a70:	48 b8 c0 01 80 00 00 	movabs $0x8001c0,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
	cprintf("\n");
  801a7c:	48 bf 5b 1f 80 00 00 	movabs $0x801f5b,%rdi
  801a83:	00 00 00 
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8b:	48 ba 6c 02 80 00 00 	movabs $0x80026c,%rdx
  801a92:	00 00 00 
  801a95:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a97:	cc                   	int3   
  801a98:	eb fd                	jmp    801a97 <_panic+0x111>
