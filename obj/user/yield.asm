
obj/user/yield:     file format elf64-x86-64


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
  80003c:	e8 c5 00 00 00       	callq  800106 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800052:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 20 1b 80 00 00 	movabs $0x801b20,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba d3 02 80 00 00 	movabs $0x8002d3,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800089:	eb 43                	jmp    8000ce <umain+0x8b>
		sys_yield();
  80008b:	48 b8 8c 17 80 00 00 	movabs $0x80178c,%rax
  800092:	00 00 00 
  800095:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800097:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80009e:	00 00 00 
  8000a1:	48 8b 00             	mov    (%rax),%rax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  8000a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000ad:	89 c6                	mov    %eax,%esi
  8000af:	48 bf 40 1b 80 00 00 	movabs $0x801b40,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 d3 02 80 00 00 	movabs $0x8002d3,%rcx
  8000c5:	00 00 00 
  8000c8:	ff d1                	callq  *%rcx
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  8000ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8000d2:	7e b7                	jle    80008b <umain+0x48>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000d4:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000db:	00 00 00 
  8000de:	48 8b 00             	mov    (%rax),%rax
  8000e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	48 bf 70 1b 80 00 00 	movabs $0x801b70,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 ba d3 02 80 00 00 	movabs $0x8002d3,%rdx
  8000ff:	00 00 00 
  800102:	ff d2                	callq  *%rdx
}
  800104:	c9                   	leaveq 
  800105:	c3                   	retq   

0000000000800106 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800106:	55                   	push   %rbp
  800107:	48 89 e5             	mov    %rsp,%rbp
  80010a:	48 83 ec 20          	sub    $0x20,%rsp
  80010e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800111:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800115:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800124:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800127:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 89 d0             	mov    %rdx,%rax
  800132:	48 c1 e0 03          	shl    $0x3,%rax
  800136:	48 01 d0             	add    %rdx,%rax
  800139:	48 c1 e0 05          	shl    $0x5,%rax
  80013d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800144:	00 00 00 
  800147:	48 01 c2             	add    %rax,%rdx
  80014a:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800151:	00 00 00 
  800154:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800157:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80015b:	7e 14                	jle    800171 <libmain+0x6b>
		binaryname = argv[0];
  80015d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800161:	48 8b 10             	mov    (%rax),%rdx
  800164:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80016b:	00 00 00 
  80016e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800171:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800175:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800178:	48 89 d6             	mov    %rdx,%rsi
  80017b:	89 c7                	mov    %eax,%edi
  80017d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800184:	00 00 00 
  800187:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800189:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  800190:	00 00 00 
  800193:	ff d0                	callq  *%rax
}
  800195:	c9                   	leaveq 
  800196:	c3                   	retq   

0000000000800197 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800197:	55                   	push   %rbp
  800198:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80019b:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a0:	48 b8 0a 17 80 00 00 	movabs $0x80170a,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
}
  8001ac:	5d                   	pop    %rbp
  8001ad:	c3                   	retq   

00000000008001ae <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001ae:	55                   	push   %rbp
  8001af:	48 89 e5             	mov    %rsp,%rbp
  8001b2:	48 83 ec 10          	sub    $0x10,%rsp
  8001b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c1:	8b 00                	mov    (%rax),%eax
  8001c3:	8d 48 01             	lea    0x1(%rax),%ecx
  8001c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ca:	89 0a                	mov    %ecx,(%rdx)
  8001cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d5:	48 98                	cltq   
  8001d7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001df:	8b 00                	mov    (%rax),%eax
  8001e1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e6:	75 2c                	jne    800214 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ec:	8b 00                	mov    (%rax),%eax
  8001ee:	48 98                	cltq   
  8001f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f4:	48 83 c2 08          	add    $0x8,%rdx
  8001f8:	48 89 c6             	mov    %rax,%rsi
  8001fb:	48 89 d7             	mov    %rdx,%rdi
  8001fe:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
        b->idx = 0;
  80020a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800218:	8b 40 04             	mov    0x4(%rax),%eax
  80021b:	8d 50 01             	lea    0x1(%rax),%edx
  80021e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800222:	89 50 04             	mov    %edx,0x4(%rax)
}
  800225:	c9                   	leaveq 
  800226:	c3                   	retq   

0000000000800227 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800227:	55                   	push   %rbp
  800228:	48 89 e5             	mov    %rsp,%rbp
  80022b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800232:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800239:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800240:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800247:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80024e:	48 8b 0a             	mov    (%rdx),%rcx
  800251:	48 89 08             	mov    %rcx,(%rax)
  800254:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800258:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80025c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800260:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800264:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80026b:	00 00 00 
    b.cnt = 0;
  80026e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800275:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800278:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80027f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800286:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80028d:	48 89 c6             	mov    %rax,%rsi
  800290:	48 bf ae 01 80 00 00 	movabs $0x8001ae,%rdi
  800297:	00 00 00 
  80029a:	48 b8 86 06 80 00 00 	movabs $0x800686,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002a6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002ac:	48 98                	cltq   
  8002ae:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002b5:	48 83 c2 08          	add    $0x8,%rdx
  8002b9:	48 89 c6             	mov    %rax,%rsi
  8002bc:	48 89 d7             	mov    %rdx,%rdi
  8002bf:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002d1:	c9                   	leaveq 
  8002d2:	c3                   	retq   

00000000008002d3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002d3:	55                   	push   %rbp
  8002d4:	48 89 e5             	mov    %rsp,%rbp
  8002d7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002de:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002e5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002ec:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002f3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002fa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800301:	84 c0                	test   %al,%al
  800303:	74 20                	je     800325 <cprintf+0x52>
  800305:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800309:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80030d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800311:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800315:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800319:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80031d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800321:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800325:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80032c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800333:	00 00 00 
  800336:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80033d:	00 00 00 
  800340:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800344:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80034b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800352:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800359:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800360:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800367:	48 8b 0a             	mov    (%rdx),%rcx
  80036a:	48 89 08             	mov    %rcx,(%rax)
  80036d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800371:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800375:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800379:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80037d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800384:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80038b:	48 89 d6             	mov    %rdx,%rsi
  80038e:	48 89 c7             	mov    %rax,%rdi
  800391:	48 b8 27 02 80 00 00 	movabs $0x800227,%rax
  800398:	00 00 00 
  80039b:	ff d0                	callq  *%rax
  80039d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003a3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003a9:	c9                   	leaveq 
  8003aa:	c3                   	retq   

00000000008003ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ab:	55                   	push   %rbp
  8003ac:	48 89 e5             	mov    %rsp,%rbp
  8003af:	53                   	push   %rbx
  8003b0:	48 83 ec 38          	sub    $0x38,%rsp
  8003b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003c0:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003c3:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003c7:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003d2:	77 3b                	ja     80040f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003d7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003db:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e7:	48 f7 f3             	div    %rbx
  8003ea:	48 89 c2             	mov    %rax,%rdx
  8003ed:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003f0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003f3:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fb:	41 89 f9             	mov    %edi,%r9d
  8003fe:	48 89 c7             	mov    %rax,%rdi
  800401:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  800408:	00 00 00 
  80040b:	ff d0                	callq  *%rax
  80040d:	eb 1e                	jmp    80042d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040f:	eb 12                	jmp    800423 <printnum+0x78>
			putch(padc, putdat);
  800411:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800415:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041c:	48 89 ce             	mov    %rcx,%rsi
  80041f:	89 d7                	mov    %edx,%edi
  800421:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800423:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800427:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80042b:	7f e4                	jg     800411 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800434:	ba 00 00 00 00       	mov    $0x0,%edx
  800439:	48 f7 f1             	div    %rcx
  80043c:	48 89 d0             	mov    %rdx,%rax
  80043f:	48 ba f0 1c 80 00 00 	movabs $0x801cf0,%rdx
  800446:	00 00 00 
  800449:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80044d:	0f be d0             	movsbl %al,%edx
  800450:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800458:	48 89 ce             	mov    %rcx,%rsi
  80045b:	89 d7                	mov    %edx,%edi
  80045d:	ff d0                	callq  *%rax
}
  80045f:	48 83 c4 38          	add    $0x38,%rsp
  800463:	5b                   	pop    %rbx
  800464:	5d                   	pop    %rbp
  800465:	c3                   	retq   

0000000000800466 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800466:	55                   	push   %rbp
  800467:	48 89 e5             	mov    %rsp,%rbp
  80046a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80046e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800472:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800475:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800479:	7e 52                	jle    8004cd <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80047b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	83 f8 30             	cmp    $0x30,%eax
  800484:	73 24                	jae    8004aa <getuint+0x44>
  800486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80048e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800492:	8b 00                	mov    (%rax),%eax
  800494:	89 c0                	mov    %eax,%eax
  800496:	48 01 d0             	add    %rdx,%rax
  800499:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049d:	8b 12                	mov    (%rdx),%edx
  80049f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a6:	89 0a                	mov    %ecx,(%rdx)
  8004a8:	eb 17                	jmp    8004c1 <getuint+0x5b>
  8004aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ae:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004b2:	48 89 d0             	mov    %rdx,%rax
  8004b5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004bd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004c1:	48 8b 00             	mov    (%rax),%rax
  8004c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004c8:	e9 a3 00 00 00       	jmpq   800570 <getuint+0x10a>
	else if (lflag)
  8004cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004d1:	74 4f                	je     800522 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d7:	8b 00                	mov    (%rax),%eax
  8004d9:	83 f8 30             	cmp    $0x30,%eax
  8004dc:	73 24                	jae    800502 <getuint+0x9c>
  8004de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ea:	8b 00                	mov    (%rax),%eax
  8004ec:	89 c0                	mov    %eax,%eax
  8004ee:	48 01 d0             	add    %rdx,%rax
  8004f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f5:	8b 12                	mov    (%rdx),%edx
  8004f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fe:	89 0a                	mov    %ecx,(%rdx)
  800500:	eb 17                	jmp    800519 <getuint+0xb3>
  800502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800506:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80050a:	48 89 d0             	mov    %rdx,%rax
  80050d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800511:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800515:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800519:	48 8b 00             	mov    (%rax),%rax
  80051c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800520:	eb 4e                	jmp    800570 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800526:	8b 00                	mov    (%rax),%eax
  800528:	83 f8 30             	cmp    $0x30,%eax
  80052b:	73 24                	jae    800551 <getuint+0xeb>
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800539:	8b 00                	mov    (%rax),%eax
  80053b:	89 c0                	mov    %eax,%eax
  80053d:	48 01 d0             	add    %rdx,%rax
  800540:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800544:	8b 12                	mov    (%rdx),%edx
  800546:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800549:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054d:	89 0a                	mov    %ecx,(%rdx)
  80054f:	eb 17                	jmp    800568 <getuint+0x102>
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800559:	48 89 d0             	mov    %rdx,%rax
  80055c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800560:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800564:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800568:	8b 00                	mov    (%rax),%eax
  80056a:	89 c0                	mov    %eax,%eax
  80056c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800574:	c9                   	leaveq 
  800575:	c3                   	retq   

0000000000800576 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800576:	55                   	push   %rbp
  800577:	48 89 e5             	mov    %rsp,%rbp
  80057a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80057e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800582:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800585:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800589:	7e 52                	jle    8005dd <getint+0x67>
		x=va_arg(*ap, long long);
  80058b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058f:	8b 00                	mov    (%rax),%eax
  800591:	83 f8 30             	cmp    $0x30,%eax
  800594:	73 24                	jae    8005ba <getint+0x44>
  800596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	8b 00                	mov    (%rax),%eax
  8005a4:	89 c0                	mov    %eax,%eax
  8005a6:	48 01 d0             	add    %rdx,%rax
  8005a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ad:	8b 12                	mov    (%rdx),%edx
  8005af:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b6:	89 0a                	mov    %ecx,(%rdx)
  8005b8:	eb 17                	jmp    8005d1 <getint+0x5b>
  8005ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005be:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c2:	48 89 d0             	mov    %rdx,%rax
  8005c5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d1:	48 8b 00             	mov    (%rax),%rax
  8005d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d8:	e9 a3 00 00 00       	jmpq   800680 <getint+0x10a>
	else if (lflag)
  8005dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005e1:	74 4f                	je     800632 <getint+0xbc>
		x=va_arg(*ap, long);
  8005e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e7:	8b 00                	mov    (%rax),%eax
  8005e9:	83 f8 30             	cmp    $0x30,%eax
  8005ec:	73 24                	jae    800612 <getint+0x9c>
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fa:	8b 00                	mov    (%rax),%eax
  8005fc:	89 c0                	mov    %eax,%eax
  8005fe:	48 01 d0             	add    %rdx,%rax
  800601:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800605:	8b 12                	mov    (%rdx),%edx
  800607:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060e:	89 0a                	mov    %ecx,(%rdx)
  800610:	eb 17                	jmp    800629 <getint+0xb3>
  800612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800616:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061a:	48 89 d0             	mov    %rdx,%rax
  80061d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800621:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800625:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800629:	48 8b 00             	mov    (%rax),%rax
  80062c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800630:	eb 4e                	jmp    800680 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800636:	8b 00                	mov    (%rax),%eax
  800638:	83 f8 30             	cmp    $0x30,%eax
  80063b:	73 24                	jae    800661 <getint+0xeb>
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800649:	8b 00                	mov    (%rax),%eax
  80064b:	89 c0                	mov    %eax,%eax
  80064d:	48 01 d0             	add    %rdx,%rax
  800650:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800654:	8b 12                	mov    (%rdx),%edx
  800656:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800659:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065d:	89 0a                	mov    %ecx,(%rdx)
  80065f:	eb 17                	jmp    800678 <getint+0x102>
  800661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800665:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800669:	48 89 d0             	mov    %rdx,%rax
  80066c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800670:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800674:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800678:	8b 00                	mov    (%rax),%eax
  80067a:	48 98                	cltq   
  80067c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800684:	c9                   	leaveq 
  800685:	c3                   	retq   

0000000000800686 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800686:	55                   	push   %rbp
  800687:	48 89 e5             	mov    %rsp,%rbp
  80068a:	41 54                	push   %r12
  80068c:	53                   	push   %rbx
  80068d:	48 83 ec 60          	sub    $0x60,%rsp
  800691:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800695:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800699:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80069d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006a1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006a5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006a9:	48 8b 0a             	mov    (%rdx),%rcx
  8006ac:	48 89 08             	mov    %rcx,(%rax)
  8006af:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bf:	eb 17                	jmp    8006d8 <vprintfmt+0x52>
			if (ch == '\0')
  8006c1:	85 db                	test   %ebx,%ebx
  8006c3:	0f 84 df 04 00 00    	je     800ba8 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8006c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006d1:	48 89 d6             	mov    %rdx,%rsi
  8006d4:	89 df                	mov    %ebx,%edi
  8006d6:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e4:	0f b6 00             	movzbl (%rax),%eax
  8006e7:	0f b6 d8             	movzbl %al,%ebx
  8006ea:	83 fb 25             	cmp    $0x25,%ebx
  8006ed:	75 d2                	jne    8006c1 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006ef:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006f3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800701:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800708:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800713:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800717:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80071b:	0f b6 00             	movzbl (%rax),%eax
  80071e:	0f b6 d8             	movzbl %al,%ebx
  800721:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800724:	83 f8 55             	cmp    $0x55,%eax
  800727:	0f 87 47 04 00 00    	ja     800b74 <vprintfmt+0x4ee>
  80072d:	89 c0                	mov    %eax,%eax
  80072f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800736:	00 
  800737:	48 b8 18 1d 80 00 00 	movabs $0x801d18,%rax
  80073e:	00 00 00 
  800741:	48 01 d0             	add    %rdx,%rax
  800744:	48 8b 00             	mov    (%rax),%rax
  800747:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800749:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80074d:	eb c0                	jmp    80070f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80074f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800753:	eb ba                	jmp    80070f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800755:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80075c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80075f:	89 d0                	mov    %edx,%eax
  800761:	c1 e0 02             	shl    $0x2,%eax
  800764:	01 d0                	add    %edx,%eax
  800766:	01 c0                	add    %eax,%eax
  800768:	01 d8                	add    %ebx,%eax
  80076a:	83 e8 30             	sub    $0x30,%eax
  80076d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800770:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800774:	0f b6 00             	movzbl (%rax),%eax
  800777:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80077a:	83 fb 2f             	cmp    $0x2f,%ebx
  80077d:	7e 0c                	jle    80078b <vprintfmt+0x105>
  80077f:	83 fb 39             	cmp    $0x39,%ebx
  800782:	7f 07                	jg     80078b <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800784:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800789:	eb d1                	jmp    80075c <vprintfmt+0xd6>
			goto process_precision;
  80078b:	eb 58                	jmp    8007e5 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80078d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800790:	83 f8 30             	cmp    $0x30,%eax
  800793:	73 17                	jae    8007ac <vprintfmt+0x126>
  800795:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800799:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079c:	89 c0                	mov    %eax,%eax
  80079e:	48 01 d0             	add    %rdx,%rax
  8007a1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a4:	83 c2 08             	add    $0x8,%edx
  8007a7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007aa:	eb 0f                	jmp    8007bb <vprintfmt+0x135>
  8007ac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b0:	48 89 d0             	mov    %rdx,%rax
  8007b3:	48 83 c2 08          	add    $0x8,%rdx
  8007b7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007c0:	eb 23                	jmp    8007e5 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007c6:	79 0c                	jns    8007d4 <vprintfmt+0x14e>
				width = 0;
  8007c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007cf:	e9 3b ff ff ff       	jmpq   80070f <vprintfmt+0x89>
  8007d4:	e9 36 ff ff ff       	jmpq   80070f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007d9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007e0:	e9 2a ff ff ff       	jmpq   80070f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007e9:	79 12                	jns    8007fd <vprintfmt+0x177>
				width = precision, precision = -1;
  8007eb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007ee:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007f8:	e9 12 ff ff ff       	jmpq   80070f <vprintfmt+0x89>
  8007fd:	e9 0d ff ff ff       	jmpq   80070f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800802:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800806:	e9 04 ff ff ff       	jmpq   80070f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80080b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080e:	83 f8 30             	cmp    $0x30,%eax
  800811:	73 17                	jae    80082a <vprintfmt+0x1a4>
  800813:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800817:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081a:	89 c0                	mov    %eax,%eax
  80081c:	48 01 d0             	add    %rdx,%rax
  80081f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800822:	83 c2 08             	add    $0x8,%edx
  800825:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800828:	eb 0f                	jmp    800839 <vprintfmt+0x1b3>
  80082a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80082e:	48 89 d0             	mov    %rdx,%rax
  800831:	48 83 c2 08          	add    $0x8,%rdx
  800835:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800839:	8b 10                	mov    (%rax),%edx
  80083b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80083f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800843:	48 89 ce             	mov    %rcx,%rsi
  800846:	89 d7                	mov    %edx,%edi
  800848:	ff d0                	callq  *%rax
			break;
  80084a:	e9 53 03 00 00       	jmpq   800ba2 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80084f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800852:	83 f8 30             	cmp    $0x30,%eax
  800855:	73 17                	jae    80086e <vprintfmt+0x1e8>
  800857:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085e:	89 c0                	mov    %eax,%eax
  800860:	48 01 d0             	add    %rdx,%rax
  800863:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800866:	83 c2 08             	add    $0x8,%edx
  800869:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086c:	eb 0f                	jmp    80087d <vprintfmt+0x1f7>
  80086e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800872:	48 89 d0             	mov    %rdx,%rax
  800875:	48 83 c2 08          	add    $0x8,%rdx
  800879:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80087d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80087f:	85 db                	test   %ebx,%ebx
  800881:	79 02                	jns    800885 <vprintfmt+0x1ff>
				err = -err;
  800883:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800885:	83 fb 15             	cmp    $0x15,%ebx
  800888:	7f 16                	jg     8008a0 <vprintfmt+0x21a>
  80088a:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  800891:	00 00 00 
  800894:	48 63 d3             	movslq %ebx,%rdx
  800897:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80089b:	4d 85 e4             	test   %r12,%r12
  80089e:	75 2e                	jne    8008ce <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008a0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a8:	89 d9                	mov    %ebx,%ecx
  8008aa:	48 ba 01 1d 80 00 00 	movabs $0x801d01,%rdx
  8008b1:	00 00 00 
  8008b4:	48 89 c7             	mov    %rax,%rdi
  8008b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bc:	49 b8 b1 0b 80 00 00 	movabs $0x800bb1,%r8
  8008c3:	00 00 00 
  8008c6:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008c9:	e9 d4 02 00 00       	jmpq   800ba2 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ce:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d6:	4c 89 e1             	mov    %r12,%rcx
  8008d9:	48 ba 0a 1d 80 00 00 	movabs $0x801d0a,%rdx
  8008e0:	00 00 00 
  8008e3:	48 89 c7             	mov    %rax,%rdi
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	49 b8 b1 0b 80 00 00 	movabs $0x800bb1,%r8
  8008f2:	00 00 00 
  8008f5:	41 ff d0             	callq  *%r8
			break;
  8008f8:	e9 a5 02 00 00       	jmpq   800ba2 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800900:	83 f8 30             	cmp    $0x30,%eax
  800903:	73 17                	jae    80091c <vprintfmt+0x296>
  800905:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800909:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 01 d0             	add    %rdx,%rax
  800911:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800914:	83 c2 08             	add    $0x8,%edx
  800917:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80091a:	eb 0f                	jmp    80092b <vprintfmt+0x2a5>
  80091c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800920:	48 89 d0             	mov    %rdx,%rax
  800923:	48 83 c2 08          	add    $0x8,%rdx
  800927:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80092b:	4c 8b 20             	mov    (%rax),%r12
  80092e:	4d 85 e4             	test   %r12,%r12
  800931:	75 0a                	jne    80093d <vprintfmt+0x2b7>
				p = "(null)";
  800933:	49 bc 0d 1d 80 00 00 	movabs $0x801d0d,%r12
  80093a:	00 00 00 
			if (width > 0 && padc != '-')
  80093d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800941:	7e 3f                	jle    800982 <vprintfmt+0x2fc>
  800943:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800947:	74 39                	je     800982 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800949:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80094c:	48 98                	cltq   
  80094e:	48 89 c6             	mov    %rax,%rsi
  800951:	4c 89 e7             	mov    %r12,%rdi
  800954:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  80095b:	00 00 00 
  80095e:	ff d0                	callq  *%rax
  800960:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800963:	eb 17                	jmp    80097c <vprintfmt+0x2f6>
					putch(padc, putdat);
  800965:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800969:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80096d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800971:	48 89 ce             	mov    %rcx,%rsi
  800974:	89 d7                	mov    %edx,%edi
  800976:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800978:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80097c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800980:	7f e3                	jg     800965 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800982:	eb 37                	jmp    8009bb <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800984:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800988:	74 1e                	je     8009a8 <vprintfmt+0x322>
  80098a:	83 fb 1f             	cmp    $0x1f,%ebx
  80098d:	7e 05                	jle    800994 <vprintfmt+0x30e>
  80098f:	83 fb 7e             	cmp    $0x7e,%ebx
  800992:	7e 14                	jle    8009a8 <vprintfmt+0x322>
					putch('?', putdat);
  800994:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800998:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099c:	48 89 d6             	mov    %rdx,%rsi
  80099f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009a4:	ff d0                	callq  *%rax
  8009a6:	eb 0f                	jmp    8009b7 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009a8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b0:	48 89 d6             	mov    %rdx,%rsi
  8009b3:	89 df                	mov    %ebx,%edi
  8009b5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009bb:	4c 89 e0             	mov    %r12,%rax
  8009be:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009c2:	0f b6 00             	movzbl (%rax),%eax
  8009c5:	0f be d8             	movsbl %al,%ebx
  8009c8:	85 db                	test   %ebx,%ebx
  8009ca:	74 10                	je     8009dc <vprintfmt+0x356>
  8009cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009d0:	78 b2                	js     800984 <vprintfmt+0x2fe>
  8009d2:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009da:	79 a8                	jns    800984 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009dc:	eb 16                	jmp    8009f4 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e6:	48 89 d6             	mov    %rdx,%rsi
  8009e9:	bf 20 00 00 00       	mov    $0x20,%edi
  8009ee:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f8:	7f e4                	jg     8009de <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8009fa:	e9 a3 01 00 00       	jmpq   800ba2 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009ff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a03:	be 03 00 00 00       	mov    $0x3,%esi
  800a08:	48 89 c7             	mov    %rax,%rdi
  800a0b:	48 b8 76 05 80 00 00 	movabs $0x800576,%rax
  800a12:	00 00 00 
  800a15:	ff d0                	callq  *%rax
  800a17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1f:	48 85 c0             	test   %rax,%rax
  800a22:	79 1d                	jns    800a41 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2c:	48 89 d6             	mov    %rdx,%rsi
  800a2f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a34:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3a:	48 f7 d8             	neg    %rax
  800a3d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a41:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a48:	e9 e8 00 00 00       	jmpq   800b35 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a4d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a51:	be 03 00 00 00       	mov    $0x3,%esi
  800a56:	48 89 c7             	mov    %rax,%rdi
  800a59:	48 b8 66 04 80 00 00 	movabs $0x800466,%rax
  800a60:	00 00 00 
  800a63:	ff d0                	callq  *%rax
  800a65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a69:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a70:	e9 c0 00 00 00       	jmpq   800b35 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7d:	48 89 d6             	mov    %rdx,%rsi
  800a80:	bf 58 00 00 00       	mov    $0x58,%edi
  800a85:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8f:	48 89 d6             	mov    %rdx,%rsi
  800a92:	bf 58 00 00 00       	mov    $0x58,%edi
  800a97:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa1:	48 89 d6             	mov    %rdx,%rsi
  800aa4:	bf 58 00 00 00       	mov    $0x58,%edi
  800aa9:	ff d0                	callq  *%rax
			break;
  800aab:	e9 f2 00 00 00       	jmpq   800ba2 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ab0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab8:	48 89 d6             	mov    %rdx,%rsi
  800abb:	bf 30 00 00 00       	mov    $0x30,%edi
  800ac0:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ac2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aca:	48 89 d6             	mov    %rdx,%rsi
  800acd:	bf 78 00 00 00       	mov    $0x78,%edi
  800ad2:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ad4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad7:	83 f8 30             	cmp    $0x30,%eax
  800ada:	73 17                	jae    800af3 <vprintfmt+0x46d>
  800adc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	89 c0                	mov    %eax,%eax
  800ae5:	48 01 d0             	add    %rdx,%rax
  800ae8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aeb:	83 c2 08             	add    $0x8,%edx
  800aee:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af1:	eb 0f                	jmp    800b02 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800af3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af7:	48 89 d0             	mov    %rdx,%rax
  800afa:	48 83 c2 08          	add    $0x8,%rdx
  800afe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b02:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b09:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b10:	eb 23                	jmp    800b35 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b16:	be 03 00 00 00       	mov    $0x3,%esi
  800b1b:	48 89 c7             	mov    %rax,%rdi
  800b1e:	48 b8 66 04 80 00 00 	movabs $0x800466,%rax
  800b25:	00 00 00 
  800b28:	ff d0                	callq  *%rax
  800b2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b2e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b35:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b3a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b3d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b44:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4c:	45 89 c1             	mov    %r8d,%r9d
  800b4f:	41 89 f8             	mov    %edi,%r8d
  800b52:	48 89 c7             	mov    %rax,%rdi
  800b55:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	callq  *%rax
			break;
  800b61:	eb 3f                	jmp    800ba2 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6b:	48 89 d6             	mov    %rdx,%rsi
  800b6e:	89 df                	mov    %ebx,%edi
  800b70:	ff d0                	callq  *%rax
			break;
  800b72:	eb 2e                	jmp    800ba2 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7c:	48 89 d6             	mov    %rdx,%rsi
  800b7f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b84:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b86:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b8b:	eb 05                	jmp    800b92 <vprintfmt+0x50c>
  800b8d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b92:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b96:	48 83 e8 01          	sub    $0x1,%rax
  800b9a:	0f b6 00             	movzbl (%rax),%eax
  800b9d:	3c 25                	cmp    $0x25,%al
  800b9f:	75 ec                	jne    800b8d <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ba1:	90                   	nop
		}
	}
  800ba2:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ba3:	e9 30 fb ff ff       	jmpq   8006d8 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ba8:	48 83 c4 60          	add    $0x60,%rsp
  800bac:	5b                   	pop    %rbx
  800bad:	41 5c                	pop    %r12
  800baf:	5d                   	pop    %rbp
  800bb0:	c3                   	retq   

0000000000800bb1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb1:	55                   	push   %rbp
  800bb2:	48 89 e5             	mov    %rsp,%rbp
  800bb5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bbc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bc3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bd1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bd8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bdf:	84 c0                	test   %al,%al
  800be1:	74 20                	je     800c03 <printfmt+0x52>
  800be3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800be7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800beb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bf3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bf7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bfb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c03:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c0a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c11:	00 00 00 
  800c14:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c1b:	00 00 00 
  800c1e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c22:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c29:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c30:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c37:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c3e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c45:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c4c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c53:	48 89 c7             	mov    %rax,%rdi
  800c56:	48 b8 86 06 80 00 00 	movabs $0x800686,%rax
  800c5d:	00 00 00 
  800c60:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c62:	c9                   	leaveq 
  800c63:	c3                   	retq   

0000000000800c64 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c64:	55                   	push   %rbp
  800c65:	48 89 e5             	mov    %rsp,%rbp
  800c68:	48 83 ec 10          	sub    $0x10,%rsp
  800c6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c77:	8b 40 10             	mov    0x10(%rax),%eax
  800c7a:	8d 50 01             	lea    0x1(%rax),%edx
  800c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c81:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c88:	48 8b 10             	mov    (%rax),%rdx
  800c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c93:	48 39 c2             	cmp    %rax,%rdx
  800c96:	73 17                	jae    800caf <sprintputch+0x4b>
		*b->buf++ = ch;
  800c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9c:	48 8b 00             	mov    (%rax),%rax
  800c9f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ca3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ca7:	48 89 0a             	mov    %rcx,(%rdx)
  800caa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cad:	88 10                	mov    %dl,(%rax)
}
  800caf:	c9                   	leaveq 
  800cb0:	c3                   	retq   

0000000000800cb1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb1:	55                   	push   %rbp
  800cb2:	48 89 e5             	mov    %rsp,%rbp
  800cb5:	48 83 ec 50          	sub    $0x50,%rsp
  800cb9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cbd:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cc0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cc4:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cc8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ccc:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cd0:	48 8b 0a             	mov    (%rdx),%rcx
  800cd3:	48 89 08             	mov    %rcx,(%rax)
  800cd6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cda:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cde:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ce2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ce6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cee:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cf1:	48 98                	cltq   
  800cf3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cf7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cfb:	48 01 d0             	add    %rdx,%rax
  800cfe:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d02:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d09:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d0e:	74 06                	je     800d16 <vsnprintf+0x65>
  800d10:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d14:	7f 07                	jg     800d1d <vsnprintf+0x6c>
		return -E_INVAL;
  800d16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d1b:	eb 2f                	jmp    800d4c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d1d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d21:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d25:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d29:	48 89 c6             	mov    %rax,%rsi
  800d2c:	48 bf 64 0c 80 00 00 	movabs $0x800c64,%rdi
  800d33:	00 00 00 
  800d36:	48 b8 86 06 80 00 00 	movabs $0x800686,%rax
  800d3d:	00 00 00 
  800d40:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d46:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d49:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d4c:	c9                   	leaveq 
  800d4d:	c3                   	retq   

0000000000800d4e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d4e:	55                   	push   %rbp
  800d4f:	48 89 e5             	mov    %rsp,%rbp
  800d52:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d59:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d60:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d66:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d6d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d74:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d7b:	84 c0                	test   %al,%al
  800d7d:	74 20                	je     800d9f <snprintf+0x51>
  800d7f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d83:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d87:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d8b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d8f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d93:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d97:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d9b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d9f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800da6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dad:	00 00 00 
  800db0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800db7:	00 00 00 
  800dba:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dbe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dc5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dcc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dd3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dda:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800de1:	48 8b 0a             	mov    (%rdx),%rcx
  800de4:	48 89 08             	mov    %rcx,(%rax)
  800de7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800deb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800def:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800df3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800df7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dfe:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e05:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e0b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e12:	48 89 c7             	mov    %rax,%rdi
  800e15:	48 b8 b1 0c 80 00 00 	movabs $0x800cb1,%rax
  800e1c:	00 00 00 
  800e1f:	ff d0                	callq  *%rax
  800e21:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e27:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e2d:	c9                   	leaveq 
  800e2e:	c3                   	retq   

0000000000800e2f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e2f:	55                   	push   %rbp
  800e30:	48 89 e5             	mov    %rsp,%rbp
  800e33:	48 83 ec 18          	sub    $0x18,%rsp
  800e37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e42:	eb 09                	jmp    800e4d <strlen+0x1e>
		n++;
  800e44:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e48:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e51:	0f b6 00             	movzbl (%rax),%eax
  800e54:	84 c0                	test   %al,%al
  800e56:	75 ec                	jne    800e44 <strlen+0x15>
		n++;
	return n;
  800e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e5b:	c9                   	leaveq 
  800e5c:	c3                   	retq   

0000000000800e5d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e5d:	55                   	push   %rbp
  800e5e:	48 89 e5             	mov    %rsp,%rbp
  800e61:	48 83 ec 20          	sub    $0x20,%rsp
  800e65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e74:	eb 0e                	jmp    800e84 <strnlen+0x27>
		n++;
  800e76:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e7f:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e84:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e89:	74 0b                	je     800e96 <strnlen+0x39>
  800e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8f:	0f b6 00             	movzbl (%rax),%eax
  800e92:	84 c0                	test   %al,%al
  800e94:	75 e0                	jne    800e76 <strnlen+0x19>
		n++;
	return n;
  800e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e99:	c9                   	leaveq 
  800e9a:	c3                   	retq   

0000000000800e9b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9b:	55                   	push   %rbp
  800e9c:	48 89 e5             	mov    %rsp,%rbp
  800e9f:	48 83 ec 20          	sub    $0x20,%rsp
  800ea3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ea7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800eb3:	90                   	nop
  800eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ebc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ec0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ec8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ecc:	0f b6 12             	movzbl (%rdx),%edx
  800ecf:	88 10                	mov    %dl,(%rax)
  800ed1:	0f b6 00             	movzbl (%rax),%eax
  800ed4:	84 c0                	test   %al,%al
  800ed6:	75 dc                	jne    800eb4 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ed8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800edc:	c9                   	leaveq 
  800edd:	c3                   	retq   

0000000000800ede <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ede:	55                   	push   %rbp
  800edf:	48 89 e5             	mov    %rsp,%rbp
  800ee2:	48 83 ec 20          	sub    $0x20,%rsp
  800ee6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef2:	48 89 c7             	mov    %rax,%rdi
  800ef5:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  800efc:	00 00 00 
  800eff:	ff d0                	callq  *%rax
  800f01:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f07:	48 63 d0             	movslq %eax,%rdx
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0e:	48 01 c2             	add    %rax,%rdx
  800f11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f15:	48 89 c6             	mov    %rax,%rsi
  800f18:	48 89 d7             	mov    %rdx,%rdi
  800f1b:	48 b8 9b 0e 80 00 00 	movabs $0x800e9b,%rax
  800f22:	00 00 00 
  800f25:	ff d0                	callq  *%rax
	return dst;
  800f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f2b:	c9                   	leaveq 
  800f2c:	c3                   	retq   

0000000000800f2d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f2d:	55                   	push   %rbp
  800f2e:	48 89 e5             	mov    %rsp,%rbp
  800f31:	48 83 ec 28          	sub    $0x28,%rsp
  800f35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f45:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f49:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f50:	00 
  800f51:	eb 2a                	jmp    800f7d <strncpy+0x50>
		*dst++ = *src;
  800f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f57:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f5b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f5f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f63:	0f b6 12             	movzbl (%rdx),%edx
  800f66:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f6c:	0f b6 00             	movzbl (%rax),%eax
  800f6f:	84 c0                	test   %al,%al
  800f71:	74 05                	je     800f78 <strncpy+0x4b>
			src++;
  800f73:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f78:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f81:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f85:	72 cc                	jb     800f53 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f8b:	c9                   	leaveq 
  800f8c:	c3                   	retq   

0000000000800f8d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f8d:	55                   	push   %rbp
  800f8e:	48 89 e5             	mov    %rsp,%rbp
  800f91:	48 83 ec 28          	sub    $0x28,%rsp
  800f95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f9d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fa9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fae:	74 3d                	je     800fed <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fb0:	eb 1d                	jmp    800fcf <strlcpy+0x42>
			*dst++ = *src++;
  800fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fbe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fc2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fc6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fca:	0f b6 12             	movzbl (%rdx),%edx
  800fcd:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcf:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fd4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fd9:	74 0b                	je     800fe6 <strlcpy+0x59>
  800fdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fdf:	0f b6 00             	movzbl (%rax),%eax
  800fe2:	84 c0                	test   %al,%al
  800fe4:	75 cc                	jne    800fb2 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff5:	48 29 c2             	sub    %rax,%rdx
  800ff8:	48 89 d0             	mov    %rdx,%rax
}
  800ffb:	c9                   	leaveq 
  800ffc:	c3                   	retq   

0000000000800ffd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ffd:	55                   	push   %rbp
  800ffe:	48 89 e5             	mov    %rsp,%rbp
  801001:	48 83 ec 10          	sub    $0x10,%rsp
  801005:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801009:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80100d:	eb 0a                	jmp    801019 <strcmp+0x1c>
		p++, q++;
  80100f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801014:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801019:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101d:	0f b6 00             	movzbl (%rax),%eax
  801020:	84 c0                	test   %al,%al
  801022:	74 12                	je     801036 <strcmp+0x39>
  801024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801028:	0f b6 10             	movzbl (%rax),%edx
  80102b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102f:	0f b6 00             	movzbl (%rax),%eax
  801032:	38 c2                	cmp    %al,%dl
  801034:	74 d9                	je     80100f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801036:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103a:	0f b6 00             	movzbl (%rax),%eax
  80103d:	0f b6 d0             	movzbl %al,%edx
  801040:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801044:	0f b6 00             	movzbl (%rax),%eax
  801047:	0f b6 c0             	movzbl %al,%eax
  80104a:	29 c2                	sub    %eax,%edx
  80104c:	89 d0                	mov    %edx,%eax
}
  80104e:	c9                   	leaveq 
  80104f:	c3                   	retq   

0000000000801050 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801050:	55                   	push   %rbp
  801051:	48 89 e5             	mov    %rsp,%rbp
  801054:	48 83 ec 18          	sub    $0x18,%rsp
  801058:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801060:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801064:	eb 0f                	jmp    801075 <strncmp+0x25>
		n--, p++, q++;
  801066:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80106b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801070:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801075:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80107a:	74 1d                	je     801099 <strncmp+0x49>
  80107c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801080:	0f b6 00             	movzbl (%rax),%eax
  801083:	84 c0                	test   %al,%al
  801085:	74 12                	je     801099 <strncmp+0x49>
  801087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108b:	0f b6 10             	movzbl (%rax),%edx
  80108e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	38 c2                	cmp    %al,%dl
  801097:	74 cd                	je     801066 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801099:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80109e:	75 07                	jne    8010a7 <strncmp+0x57>
		return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a5:	eb 18                	jmp    8010bf <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ab:	0f b6 00             	movzbl (%rax),%eax
  8010ae:	0f b6 d0             	movzbl %al,%edx
  8010b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b5:	0f b6 00             	movzbl (%rax),%eax
  8010b8:	0f b6 c0             	movzbl %al,%eax
  8010bb:	29 c2                	sub    %eax,%edx
  8010bd:	89 d0                	mov    %edx,%eax
}
  8010bf:	c9                   	leaveq 
  8010c0:	c3                   	retq   

00000000008010c1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010c1:	55                   	push   %rbp
  8010c2:	48 89 e5             	mov    %rsp,%rbp
  8010c5:	48 83 ec 0c          	sub    $0xc,%rsp
  8010c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010cd:	89 f0                	mov    %esi,%eax
  8010cf:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010d2:	eb 17                	jmp    8010eb <strchr+0x2a>
		if (*s == c)
  8010d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d8:	0f b6 00             	movzbl (%rax),%eax
  8010db:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010de:	75 06                	jne    8010e6 <strchr+0x25>
			return (char *) s;
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	eb 15                	jmp    8010fb <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010e6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ef:	0f b6 00             	movzbl (%rax),%eax
  8010f2:	84 c0                	test   %al,%al
  8010f4:	75 de                	jne    8010d4 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fb:	c9                   	leaveq 
  8010fc:	c3                   	retq   

00000000008010fd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010fd:	55                   	push   %rbp
  8010fe:	48 89 e5             	mov    %rsp,%rbp
  801101:	48 83 ec 0c          	sub    $0xc,%rsp
  801105:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801109:	89 f0                	mov    %esi,%eax
  80110b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80110e:	eb 13                	jmp    801123 <strfind+0x26>
		if (*s == c)
  801110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801114:	0f b6 00             	movzbl (%rax),%eax
  801117:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80111a:	75 02                	jne    80111e <strfind+0x21>
			break;
  80111c:	eb 10                	jmp    80112e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80111e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801123:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801127:	0f b6 00             	movzbl (%rax),%eax
  80112a:	84 c0                	test   %al,%al
  80112c:	75 e2                	jne    801110 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80112e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801132:	c9                   	leaveq 
  801133:	c3                   	retq   

0000000000801134 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801134:	55                   	push   %rbp
  801135:	48 89 e5             	mov    %rsp,%rbp
  801138:	48 83 ec 18          	sub    $0x18,%rsp
  80113c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801140:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801143:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801147:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80114c:	75 06                	jne    801154 <memset+0x20>
		return v;
  80114e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801152:	eb 69                	jmp    8011bd <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801158:	83 e0 03             	and    $0x3,%eax
  80115b:	48 85 c0             	test   %rax,%rax
  80115e:	75 48                	jne    8011a8 <memset+0x74>
  801160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801164:	83 e0 03             	and    $0x3,%eax
  801167:	48 85 c0             	test   %rax,%rax
  80116a:	75 3c                	jne    8011a8 <memset+0x74>
		c &= 0xFF;
  80116c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801173:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801176:	c1 e0 18             	shl    $0x18,%eax
  801179:	89 c2                	mov    %eax,%edx
  80117b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80117e:	c1 e0 10             	shl    $0x10,%eax
  801181:	09 c2                	or     %eax,%edx
  801183:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801186:	c1 e0 08             	shl    $0x8,%eax
  801189:	09 d0                	or     %edx,%eax
  80118b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80118e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801192:	48 c1 e8 02          	shr    $0x2,%rax
  801196:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801199:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80119d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a0:	48 89 d7             	mov    %rdx,%rdi
  8011a3:	fc                   	cld    
  8011a4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011a6:	eb 11                	jmp    8011b9 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011af:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011b3:	48 89 d7             	mov    %rdx,%rdi
  8011b6:	fc                   	cld    
  8011b7:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011bd:	c9                   	leaveq 
  8011be:	c3                   	retq   

00000000008011bf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011bf:	55                   	push   %rbp
  8011c0:	48 89 e5             	mov    %rsp,%rbp
  8011c3:	48 83 ec 28          	sub    $0x28,%rsp
  8011c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011eb:	0f 83 88 00 00 00    	jae    801279 <memmove+0xba>
  8011f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f9:	48 01 d0             	add    %rdx,%rax
  8011fc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801200:	76 77                	jbe    801279 <memmove+0xba>
		s += n;
  801202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801206:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80120a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	83 e0 03             	and    $0x3,%eax
  801219:	48 85 c0             	test   %rax,%rax
  80121c:	75 3b                	jne    801259 <memmove+0x9a>
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	83 e0 03             	and    $0x3,%eax
  801225:	48 85 c0             	test   %rax,%rax
  801228:	75 2f                	jne    801259 <memmove+0x9a>
  80122a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122e:	83 e0 03             	and    $0x3,%eax
  801231:	48 85 c0             	test   %rax,%rax
  801234:	75 23                	jne    801259 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123a:	48 83 e8 04          	sub    $0x4,%rax
  80123e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801242:	48 83 ea 04          	sub    $0x4,%rdx
  801246:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80124a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80124e:	48 89 c7             	mov    %rax,%rdi
  801251:	48 89 d6             	mov    %rdx,%rsi
  801254:	fd                   	std    
  801255:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801257:	eb 1d                	jmp    801276 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801259:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801261:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801265:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126d:	48 89 d7             	mov    %rdx,%rdi
  801270:	48 89 c1             	mov    %rax,%rcx
  801273:	fd                   	std    
  801274:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801276:	fc                   	cld    
  801277:	eb 57                	jmp    8012d0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127d:	83 e0 03             	and    $0x3,%eax
  801280:	48 85 c0             	test   %rax,%rax
  801283:	75 36                	jne    8012bb <memmove+0xfc>
  801285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801289:	83 e0 03             	and    $0x3,%eax
  80128c:	48 85 c0             	test   %rax,%rax
  80128f:	75 2a                	jne    8012bb <memmove+0xfc>
  801291:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801295:	83 e0 03             	and    $0x3,%eax
  801298:	48 85 c0             	test   %rax,%rax
  80129b:	75 1e                	jne    8012bb <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80129d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a1:	48 c1 e8 02          	shr    $0x2,%rax
  8012a5:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b0:	48 89 c7             	mov    %rax,%rdi
  8012b3:	48 89 d6             	mov    %rdx,%rsi
  8012b6:	fc                   	cld    
  8012b7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012b9:	eb 15                	jmp    8012d0 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012c7:	48 89 c7             	mov    %rax,%rdi
  8012ca:	48 89 d6             	mov    %rdx,%rsi
  8012cd:	fc                   	cld    
  8012ce:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012d4:	c9                   	leaveq 
  8012d5:	c3                   	retq   

00000000008012d6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012d6:	55                   	push   %rbp
  8012d7:	48 89 e5             	mov    %rsp,%rbp
  8012da:	48 83 ec 18          	sub    $0x18,%rsp
  8012de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ee:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	48 89 ce             	mov    %rcx,%rsi
  8012f9:	48 89 c7             	mov    %rax,%rdi
  8012fc:	48 b8 bf 11 80 00 00 	movabs $0x8011bf,%rax
  801303:	00 00 00 
  801306:	ff d0                	callq  *%rax
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 28          	sub    $0x28,%rsp
  801312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801316:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80131a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80131e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801322:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801326:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80132e:	eb 36                	jmp    801366 <memcmp+0x5c>
		if (*s1 != *s2)
  801330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801334:	0f b6 10             	movzbl (%rax),%edx
  801337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	38 c2                	cmp    %al,%dl
  801340:	74 1a                	je     80135c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801346:	0f b6 00             	movzbl (%rax),%eax
  801349:	0f b6 d0             	movzbl %al,%edx
  80134c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801350:	0f b6 00             	movzbl (%rax),%eax
  801353:	0f b6 c0             	movzbl %al,%eax
  801356:	29 c2                	sub    %eax,%edx
  801358:	89 d0                	mov    %edx,%eax
  80135a:	eb 20                	jmp    80137c <memcmp+0x72>
		s1++, s2++;
  80135c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801361:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80136e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801372:	48 85 c0             	test   %rax,%rax
  801375:	75 b9                	jne    801330 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137c:	c9                   	leaveq 
  80137d:	c3                   	retq   

000000000080137e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80137e:	55                   	push   %rbp
  80137f:	48 89 e5             	mov    %rsp,%rbp
  801382:	48 83 ec 28          	sub    $0x28,%rsp
  801386:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80138d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801395:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801399:	48 01 d0             	add    %rdx,%rax
  80139c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013a0:	eb 15                	jmp    8013b7 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	0f b6 10             	movzbl (%rax),%edx
  8013a9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013ac:	38 c2                	cmp    %al,%dl
  8013ae:	75 02                	jne    8013b2 <memfind+0x34>
			break;
  8013b0:	eb 0f                	jmp    8013c1 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013b2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013bf:	72 e1                	jb     8013a2 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013c5:	c9                   	leaveq 
  8013c6:	c3                   	retq   

00000000008013c7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013c7:	55                   	push   %rbp
  8013c8:	48 89 e5             	mov    %rsp,%rbp
  8013cb:	48 83 ec 34          	sub    $0x34,%rsp
  8013cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013d7:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013e1:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013e8:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e9:	eb 05                	jmp    8013f0 <strtol+0x29>
		s++;
  8013eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f4:	0f b6 00             	movzbl (%rax),%eax
  8013f7:	3c 20                	cmp    $0x20,%al
  8013f9:	74 f0                	je     8013eb <strtol+0x24>
  8013fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	3c 09                	cmp    $0x9,%al
  801404:	74 e5                	je     8013eb <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3c 2b                	cmp    $0x2b,%al
  80140f:	75 07                	jne    801418 <strtol+0x51>
		s++;
  801411:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801416:	eb 17                	jmp    80142f <strtol+0x68>
	else if (*s == '-')
  801418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141c:	0f b6 00             	movzbl (%rax),%eax
  80141f:	3c 2d                	cmp    $0x2d,%al
  801421:	75 0c                	jne    80142f <strtol+0x68>
		s++, neg = 1;
  801423:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801428:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80142f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801433:	74 06                	je     80143b <strtol+0x74>
  801435:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801439:	75 28                	jne    801463 <strtol+0x9c>
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	3c 30                	cmp    $0x30,%al
  801444:	75 1d                	jne    801463 <strtol+0x9c>
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	48 83 c0 01          	add    $0x1,%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	3c 78                	cmp    $0x78,%al
  801453:	75 0e                	jne    801463 <strtol+0x9c>
		s += 2, base = 16;
  801455:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80145a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801461:	eb 2c                	jmp    80148f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801463:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801467:	75 19                	jne    801482 <strtol+0xbb>
  801469:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	3c 30                	cmp    $0x30,%al
  801472:	75 0e                	jne    801482 <strtol+0xbb>
		s++, base = 8;
  801474:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801479:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801480:	eb 0d                	jmp    80148f <strtol+0xc8>
	else if (base == 0)
  801482:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801486:	75 07                	jne    80148f <strtol+0xc8>
		base = 10;
  801488:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801493:	0f b6 00             	movzbl (%rax),%eax
  801496:	3c 2f                	cmp    $0x2f,%al
  801498:	7e 1d                	jle    8014b7 <strtol+0xf0>
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	3c 39                	cmp    $0x39,%al
  8014a3:	7f 12                	jg     8014b7 <strtol+0xf0>
			dig = *s - '0';
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	0f b6 00             	movzbl (%rax),%eax
  8014ac:	0f be c0             	movsbl %al,%eax
  8014af:	83 e8 30             	sub    $0x30,%eax
  8014b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014b5:	eb 4e                	jmp    801505 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	3c 60                	cmp    $0x60,%al
  8014c0:	7e 1d                	jle    8014df <strtol+0x118>
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 7a                	cmp    $0x7a,%al
  8014cb:	7f 12                	jg     8014df <strtol+0x118>
			dig = *s - 'a' + 10;
  8014cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	0f be c0             	movsbl %al,%eax
  8014d7:	83 e8 57             	sub    $0x57,%eax
  8014da:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014dd:	eb 26                	jmp    801505 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	3c 40                	cmp    $0x40,%al
  8014e8:	7e 48                	jle    801532 <strtol+0x16b>
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3c 5a                	cmp    $0x5a,%al
  8014f3:	7f 3d                	jg     801532 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f9:	0f b6 00             	movzbl (%rax),%eax
  8014fc:	0f be c0             	movsbl %al,%eax
  8014ff:	83 e8 37             	sub    $0x37,%eax
  801502:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801505:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801508:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80150b:	7c 02                	jl     80150f <strtol+0x148>
			break;
  80150d:	eb 23                	jmp    801532 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80150f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801514:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801517:	48 98                	cltq   
  801519:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80151e:	48 89 c2             	mov    %rax,%rdx
  801521:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801524:	48 98                	cltq   
  801526:	48 01 d0             	add    %rdx,%rax
  801529:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80152d:	e9 5d ff ff ff       	jmpq   80148f <strtol+0xc8>

	if (endptr)
  801532:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801537:	74 0b                	je     801544 <strtol+0x17d>
		*endptr = (char *) s;
  801539:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80153d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801541:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801544:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801548:	74 09                	je     801553 <strtol+0x18c>
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	48 f7 d8             	neg    %rax
  801551:	eb 04                	jmp    801557 <strtol+0x190>
  801553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801557:	c9                   	leaveq 
  801558:	c3                   	retq   

0000000000801559 <strstr>:

char * strstr(const char *in, const char *str)
{
  801559:	55                   	push   %rbp
  80155a:	48 89 e5             	mov    %rsp,%rbp
  80155d:	48 83 ec 30          	sub    $0x30,%rsp
  801561:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801565:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801569:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80156d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801571:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80157b:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80157f:	75 06                	jne    801587 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	eb 6b                	jmp    8015f2 <strstr+0x99>

	len = strlen(str);
  801587:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80158b:	48 89 c7             	mov    %rax,%rdi
  80158e:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  801595:	00 00 00 
  801598:	ff d0                	callq  *%rax
  80159a:	48 98                	cltq   
  80159c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015b2:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015b6:	75 07                	jne    8015bf <strstr+0x66>
				return (char *) 0;
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	eb 33                	jmp    8015f2 <strstr+0x99>
		} while (sc != c);
  8015bf:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015c3:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015c6:	75 d8                	jne    8015a0 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015cc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	48 89 ce             	mov    %rcx,%rsi
  8015d7:	48 89 c7             	mov    %rax,%rdi
  8015da:	48 b8 50 10 80 00 00 	movabs $0x801050,%rax
  8015e1:	00 00 00 
  8015e4:	ff d0                	callq  *%rax
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	75 b6                	jne    8015a0 <strstr+0x47>

	return (char *) (in - 1);
  8015ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ee:	48 83 e8 01          	sub    $0x1,%rax
}
  8015f2:	c9                   	leaveq 
  8015f3:	c3                   	retq   

00000000008015f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	53                   	push   %rbx
  8015f9:	48 83 ec 48          	sub    $0x48,%rsp
  8015fd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801600:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801603:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801607:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80160b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80160f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801613:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801616:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80161a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80161e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801622:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801626:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80162a:	4c 89 c3             	mov    %r8,%rbx
  80162d:	cd 30                	int    $0x30
  80162f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801633:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801637:	74 3e                	je     801677 <syscall+0x83>
  801639:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80163e:	7e 37                	jle    801677 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801644:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801647:	49 89 d0             	mov    %rdx,%r8
  80164a:	89 c1                	mov    %eax,%ecx
  80164c:	48 ba c8 1f 80 00 00 	movabs $0x801fc8,%rdx
  801653:	00 00 00 
  801656:	be 23 00 00 00       	mov    $0x23,%esi
  80165b:	48 bf e5 1f 80 00 00 	movabs $0x801fe5,%rdi
  801662:	00 00 00 
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
  80166a:	49 b9 ed 19 80 00 00 	movabs $0x8019ed,%r9
  801671:	00 00 00 
  801674:	41 ff d1             	callq  *%r9

	return ret;
  801677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80167b:	48 83 c4 48          	add    $0x48,%rsp
  80167f:	5b                   	pop    %rbx
  801680:	5d                   	pop    %rbp
  801681:	c3                   	retq   

0000000000801682 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801682:	55                   	push   %rbp
  801683:	48 89 e5             	mov    %rsp,%rbp
  801686:	48 83 ec 20          	sub    $0x20,%rsp
  80168a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80168e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801692:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801696:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80169a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a1:	00 
  8016a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ae:	48 89 d1             	mov    %rdx,%rcx
  8016b1:	48 89 c2             	mov    %rax,%rdx
  8016b4:	be 00 00 00 00       	mov    $0x0,%esi
  8016b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8016be:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  8016c5:	00 00 00 
  8016c8:	ff d0                	callq  *%rax
}
  8016ca:	c9                   	leaveq 
  8016cb:	c3                   	retq   

00000000008016cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8016cc:	55                   	push   %rbp
  8016cd:	48 89 e5             	mov    %rsp,%rbp
  8016d0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016db:	00 
  8016dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f2:	be 00 00 00 00       	mov    $0x0,%esi
  8016f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8016fc:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  801703:	00 00 00 
  801706:	ff d0                	callq  *%rax
}
  801708:	c9                   	leaveq 
  801709:	c3                   	retq   

000000000080170a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80170a:	55                   	push   %rbp
  80170b:	48 89 e5             	mov    %rsp,%rbp
  80170e:	48 83 ec 10          	sub    $0x10,%rsp
  801712:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801718:	48 98                	cltq   
  80171a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801721:	00 
  801722:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801728:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80172e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801733:	48 89 c2             	mov    %rax,%rdx
  801736:	be 01 00 00 00       	mov    $0x1,%esi
  80173b:	bf 03 00 00 00       	mov    $0x3,%edi
  801740:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  801747:	00 00 00 
  80174a:	ff d0                	callq  *%rax
}
  80174c:	c9                   	leaveq 
  80174d:	c3                   	retq   

000000000080174e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80174e:	55                   	push   %rbp
  80174f:	48 89 e5             	mov    %rsp,%rbp
  801752:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801756:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80175d:	00 
  80175e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801764:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80176a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80176f:	ba 00 00 00 00       	mov    $0x0,%edx
  801774:	be 00 00 00 00       	mov    $0x0,%esi
  801779:	bf 02 00 00 00       	mov    $0x2,%edi
  80177e:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  801785:	00 00 00 
  801788:	ff d0                	callq  *%rax
}
  80178a:	c9                   	leaveq 
  80178b:	c3                   	retq   

000000000080178c <sys_yield>:

void
sys_yield(void)
{
  80178c:	55                   	push   %rbp
  80178d:	48 89 e5             	mov    %rsp,%rbp
  801790:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801794:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80179b:	00 
  80179c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b2:	be 00 00 00 00       	mov    $0x0,%esi
  8017b7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8017bc:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  8017c3:	00 00 00 
  8017c6:	ff d0                	callq  *%rax
}
  8017c8:	c9                   	leaveq 
  8017c9:	c3                   	retq   

00000000008017ca <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ca:	55                   	push   %rbp
  8017cb:	48 89 e5             	mov    %rsp,%rbp
  8017ce:	48 83 ec 20          	sub    $0x20,%rsp
  8017d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017d9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017df:	48 63 c8             	movslq %eax,%rcx
  8017e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e9:	48 98                	cltq   
  8017eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017f2:	00 
  8017f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f9:	49 89 c8             	mov    %rcx,%r8
  8017fc:	48 89 d1             	mov    %rdx,%rcx
  8017ff:	48 89 c2             	mov    %rax,%rdx
  801802:	be 01 00 00 00       	mov    $0x1,%esi
  801807:	bf 04 00 00 00       	mov    $0x4,%edi
  80180c:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  801813:	00 00 00 
  801816:	ff d0                	callq  *%rax
}
  801818:	c9                   	leaveq 
  801819:	c3                   	retq   

000000000080181a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80181a:	55                   	push   %rbp
  80181b:	48 89 e5             	mov    %rsp,%rbp
  80181e:	48 83 ec 30          	sub    $0x30,%rsp
  801822:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801825:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801829:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80182c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801830:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801834:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801837:	48 63 c8             	movslq %eax,%rcx
  80183a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80183e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801841:	48 63 f0             	movslq %eax,%rsi
  801844:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184b:	48 98                	cltq   
  80184d:	48 89 0c 24          	mov    %rcx,(%rsp)
  801851:	49 89 f9             	mov    %rdi,%r9
  801854:	49 89 f0             	mov    %rsi,%r8
  801857:	48 89 d1             	mov    %rdx,%rcx
  80185a:	48 89 c2             	mov    %rax,%rdx
  80185d:	be 01 00 00 00       	mov    $0x1,%esi
  801862:	bf 05 00 00 00       	mov    $0x5,%edi
  801867:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
}
  801873:	c9                   	leaveq 
  801874:	c3                   	retq   

0000000000801875 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801875:	55                   	push   %rbp
  801876:	48 89 e5             	mov    %rsp,%rbp
  801879:	48 83 ec 20          	sub    $0x20,%rsp
  80187d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801880:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801884:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80188b:	48 98                	cltq   
  80188d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801894:	00 
  801895:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a1:	48 89 d1             	mov    %rdx,%rcx
  8018a4:	48 89 c2             	mov    %rax,%rdx
  8018a7:	be 01 00 00 00       	mov    $0x1,%esi
  8018ac:	bf 06 00 00 00       	mov    $0x6,%edi
  8018b1:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  8018b8:	00 00 00 
  8018bb:	ff d0                	callq  *%rax
}
  8018bd:	c9                   	leaveq 
  8018be:	c3                   	retq   

00000000008018bf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018bf:	55                   	push   %rbp
  8018c0:	48 89 e5             	mov    %rsp,%rbp
  8018c3:	48 83 ec 10          	sub    $0x10,%rsp
  8018c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ca:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018d0:	48 63 d0             	movslq %eax,%rdx
  8018d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d6:	48 98                	cltq   
  8018d8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018df:	00 
  8018e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ec:	48 89 d1             	mov    %rdx,%rcx
  8018ef:	48 89 c2             	mov    %rax,%rdx
  8018f2:	be 01 00 00 00       	mov    $0x1,%esi
  8018f7:	bf 08 00 00 00       	mov    $0x8,%edi
  8018fc:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  801903:	00 00 00 
  801906:	ff d0                	callq  *%rax
}
  801908:	c9                   	leaveq 
  801909:	c3                   	retq   

000000000080190a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80190a:	55                   	push   %rbp
  80190b:	48 89 e5             	mov    %rsp,%rbp
  80190e:	48 83 ec 20          	sub    $0x20,%rsp
  801912:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801915:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801919:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801920:	48 98                	cltq   
  801922:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801929:	00 
  80192a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801930:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801936:	48 89 d1             	mov    %rdx,%rcx
  801939:	48 89 c2             	mov    %rax,%rdx
  80193c:	be 01 00 00 00       	mov    $0x1,%esi
  801941:	bf 09 00 00 00       	mov    $0x9,%edi
  801946:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
}
  801952:	c9                   	leaveq 
  801953:	c3                   	retq   

0000000000801954 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	48 83 ec 20          	sub    $0x20,%rsp
  80195c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80195f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801963:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801967:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80196a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80196d:	48 63 f0             	movslq %eax,%rsi
  801970:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801977:	48 98                	cltq   
  801979:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801984:	00 
  801985:	49 89 f1             	mov    %rsi,%r9
  801988:	49 89 c8             	mov    %rcx,%r8
  80198b:	48 89 d1             	mov    %rdx,%rcx
  80198e:	48 89 c2             	mov    %rax,%rdx
  801991:	be 00 00 00 00       	mov    $0x0,%esi
  801996:	bf 0b 00 00 00       	mov    $0xb,%edi
  80199b:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	callq  *%rax
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 10          	sub    $0x10,%rsp
  8019b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c0:	00 
  8019c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d2:	48 89 c2             	mov    %rax,%rdx
  8019d5:	be 01 00 00 00       	mov    $0x1,%esi
  8019da:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019df:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  8019e6:	00 00 00 
  8019e9:	ff d0                	callq  *%rax
}
  8019eb:	c9                   	leaveq 
  8019ec:	c3                   	retq   

00000000008019ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8019ed:	55                   	push   %rbp
  8019ee:	48 89 e5             	mov    %rsp,%rbp
  8019f1:	53                   	push   %rbx
  8019f2:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8019f9:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801a00:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801a06:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801a0d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801a14:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801a1b:	84 c0                	test   %al,%al
  801a1d:	74 23                	je     801a42 <_panic+0x55>
  801a1f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801a26:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801a2a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801a2e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801a32:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801a36:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801a3a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801a3e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801a42:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801a49:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801a50:	00 00 00 
  801a53:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801a5a:	00 00 00 
  801a5d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a61:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801a68:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801a6f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a76:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801a7d:	00 00 00 
  801a80:	48 8b 18             	mov    (%rax),%rbx
  801a83:	48 b8 4e 17 80 00 00 	movabs $0x80174e,%rax
  801a8a:	00 00 00 
  801a8d:	ff d0                	callq  *%rax
  801a8f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801a95:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801a9c:	41 89 c8             	mov    %ecx,%r8d
  801a9f:	48 89 d1             	mov    %rdx,%rcx
  801aa2:	48 89 da             	mov    %rbx,%rdx
  801aa5:	89 c6                	mov    %eax,%esi
  801aa7:	48 bf f8 1f 80 00 00 	movabs $0x801ff8,%rdi
  801aae:	00 00 00 
  801ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab6:	49 b9 d3 02 80 00 00 	movabs $0x8002d3,%r9
  801abd:	00 00 00 
  801ac0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ac3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801aca:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801ad1:	48 89 d6             	mov    %rdx,%rsi
  801ad4:	48 89 c7             	mov    %rax,%rdi
  801ad7:	48 b8 27 02 80 00 00 	movabs $0x800227,%rax
  801ade:	00 00 00 
  801ae1:	ff d0                	callq  *%rax
	cprintf("\n");
  801ae3:	48 bf 1b 20 80 00 00 	movabs $0x80201b,%rdi
  801aea:	00 00 00 
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
  801af2:	48 ba d3 02 80 00 00 	movabs $0x8002d3,%rdx
  801af9:	00 00 00 
  801afc:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801afe:	cc                   	int3   
  801aff:	eb fd                	jmp    801afe <_panic+0x111>
