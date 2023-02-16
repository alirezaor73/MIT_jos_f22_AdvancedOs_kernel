
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
  800052:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 80 36 80 00 00 	movabs $0x803680,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba df 02 80 00 00 	movabs $0x8002df,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800089:	eb 43                	jmp    8000ce <umain+0x8b>
		sys_yield();
  80008b:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  800092:	00 00 00 
  800095:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800097:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  8000af:	48 bf a0 36 80 00 00 	movabs $0x8036a0,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 df 02 80 00 00 	movabs $0x8002df,%rcx
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
  8000d4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000db:	00 00 00 
  8000de:	48 8b 00             	mov    (%rax),%rax
  8000e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	48 bf d0 36 80 00 00 	movabs $0x8036d0,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 ba df 02 80 00 00 	movabs $0x8002df,%rdx
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800115:	48 b8 5a 17 80 00 00 	movabs $0x80175a,%rax
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
  80014a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800151:	00 00 00 
  800154:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800157:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80015b:	7e 14                	jle    800171 <libmain+0x6b>
		binaryname = argv[0];
  80015d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800161:	48 8b 10             	mov    (%rax),%rdx
  800164:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
	close_all();
  80019b:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ac:	48 b8 16 17 80 00 00 	movabs $0x801716,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	callq  *%rax
}
  8001b8:	5d                   	pop    %rbp
  8001b9:	c3                   	retq   

00000000008001ba <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001ba:	55                   	push   %rbp
  8001bb:	48 89 e5             	mov    %rsp,%rbp
  8001be:	48 83 ec 10          	sub    $0x10,%rsp
  8001c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001cd:	8b 00                	mov    (%rax),%eax
  8001cf:	8d 48 01             	lea    0x1(%rax),%ecx
  8001d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d6:	89 0a                	mov    %ecx,(%rdx)
  8001d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001db:	89 d1                	mov    %edx,%ecx
  8001dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e1:	48 98                	cltq   
  8001e3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001eb:	8b 00                	mov    (%rax),%eax
  8001ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f2:	75 2c                	jne    800220 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f8:	8b 00                	mov    (%rax),%eax
  8001fa:	48 98                	cltq   
  8001fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800200:	48 83 c2 08          	add    $0x8,%rdx
  800204:	48 89 c6             	mov    %rax,%rsi
  800207:	48 89 d7             	mov    %rdx,%rdi
  80020a:	48 b8 8e 16 80 00 00 	movabs $0x80168e,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
        b->idx = 0;
  800216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800224:	8b 40 04             	mov    0x4(%rax),%eax
  800227:	8d 50 01             	lea    0x1(%rax),%edx
  80022a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800231:	c9                   	leaveq 
  800232:	c3                   	retq   

0000000000800233 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80023e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800245:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80024c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800253:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80025a:	48 8b 0a             	mov    (%rdx),%rcx
  80025d:	48 89 08             	mov    %rcx,(%rax)
  800260:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800264:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800268:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80026c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800270:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800277:	00 00 00 
    b.cnt = 0;
  80027a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800281:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800284:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80028b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800292:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800299:	48 89 c6             	mov    %rax,%rsi
  80029c:	48 bf ba 01 80 00 00 	movabs $0x8001ba,%rdi
  8002a3:	00 00 00 
  8002a6:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  8002ad:	00 00 00 
  8002b0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002b2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002b8:	48 98                	cltq   
  8002ba:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002c1:	48 83 c2 08          	add    $0x8,%rdx
  8002c5:	48 89 c6             	mov    %rax,%rsi
  8002c8:	48 89 d7             	mov    %rdx,%rdi
  8002cb:	48 b8 8e 16 80 00 00 	movabs $0x80168e,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002dd:	c9                   	leaveq 
  8002de:	c3                   	retq   

00000000008002df <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002df:	55                   	push   %rbp
  8002e0:	48 89 e5             	mov    %rsp,%rbp
  8002e3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002ea:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002f1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002f8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002ff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800306:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80030d:	84 c0                	test   %al,%al
  80030f:	74 20                	je     800331 <cprintf+0x52>
  800311:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800315:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800319:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80031d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800321:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800325:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800329:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80032d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800331:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800338:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80033f:	00 00 00 
  800342:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800349:	00 00 00 
  80034c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800350:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800357:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80035e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800365:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80036c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800373:	48 8b 0a             	mov    (%rdx),%rcx
  800376:	48 89 08             	mov    %rcx,(%rax)
  800379:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80037d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800381:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800385:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800389:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800390:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800397:	48 89 d6             	mov    %rdx,%rsi
  80039a:	48 89 c7             	mov    %rax,%rdi
  80039d:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax
  8003a9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003af:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003b5:	c9                   	leaveq 
  8003b6:	c3                   	retq   

00000000008003b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b7:	55                   	push   %rbp
  8003b8:	48 89 e5             	mov    %rsp,%rbp
  8003bb:	53                   	push   %rbx
  8003bc:	48 83 ec 38          	sub    $0x38,%rsp
  8003c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003cc:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003cf:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003d3:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003da:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003de:	77 3b                	ja     80041b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003e3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003e7:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	48 f7 f3             	div    %rbx
  8003f6:	48 89 c2             	mov    %rax,%rdx
  8003f9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003fc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003ff:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800407:	41 89 f9             	mov    %edi,%r9d
  80040a:	48 89 c7             	mov    %rax,%rdi
  80040d:	48 b8 b7 03 80 00 00 	movabs $0x8003b7,%rax
  800414:	00 00 00 
  800417:	ff d0                	callq  *%rax
  800419:	eb 1e                	jmp    800439 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041b:	eb 12                	jmp    80042f <printnum+0x78>
			putch(padc, putdat);
  80041d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800421:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800428:	48 89 ce             	mov    %rcx,%rsi
  80042b:	89 d7                	mov    %edx,%edi
  80042d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800433:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800437:	7f e4                	jg     80041d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800439:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800440:	ba 00 00 00 00       	mov    $0x0,%edx
  800445:	48 f7 f1             	div    %rcx
  800448:	48 89 d0             	mov    %rdx,%rax
  80044b:	48 ba f0 38 80 00 00 	movabs $0x8038f0,%rdx
  800452:	00 00 00 
  800455:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800459:	0f be d0             	movsbl %al,%edx
  80045c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800464:	48 89 ce             	mov    %rcx,%rsi
  800467:	89 d7                	mov    %edx,%edi
  800469:	ff d0                	callq  *%rax
}
  80046b:	48 83 c4 38          	add    $0x38,%rsp
  80046f:	5b                   	pop    %rbx
  800470:	5d                   	pop    %rbp
  800471:	c3                   	retq   

0000000000800472 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800472:	55                   	push   %rbp
  800473:	48 89 e5             	mov    %rsp,%rbp
  800476:	48 83 ec 1c          	sub    $0x1c,%rsp
  80047a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80047e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800481:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800485:	7e 52                	jle    8004d9 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048b:	8b 00                	mov    (%rax),%eax
  80048d:	83 f8 30             	cmp    $0x30,%eax
  800490:	73 24                	jae    8004b6 <getuint+0x44>
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80049a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049e:	8b 00                	mov    (%rax),%eax
  8004a0:	89 c0                	mov    %eax,%eax
  8004a2:	48 01 d0             	add    %rdx,%rax
  8004a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a9:	8b 12                	mov    (%rdx),%edx
  8004ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b2:	89 0a                	mov    %ecx,(%rdx)
  8004b4:	eb 17                	jmp    8004cd <getuint+0x5b>
  8004b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004be:	48 89 d0             	mov    %rdx,%rax
  8004c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004cd:	48 8b 00             	mov    (%rax),%rax
  8004d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004d4:	e9 a3 00 00 00       	jmpq   80057c <getuint+0x10a>
	else if (lflag)
  8004d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004dd:	74 4f                	je     80052e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e3:	8b 00                	mov    (%rax),%eax
  8004e5:	83 f8 30             	cmp    $0x30,%eax
  8004e8:	73 24                	jae    80050e <getuint+0x9c>
  8004ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f6:	8b 00                	mov    (%rax),%eax
  8004f8:	89 c0                	mov    %eax,%eax
  8004fa:	48 01 d0             	add    %rdx,%rax
  8004fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800501:	8b 12                	mov    (%rdx),%edx
  800503:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800506:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050a:	89 0a                	mov    %ecx,(%rdx)
  80050c:	eb 17                	jmp    800525 <getuint+0xb3>
  80050e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800512:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800516:	48 89 d0             	mov    %rdx,%rax
  800519:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800521:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800525:	48 8b 00             	mov    (%rax),%rax
  800528:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052c:	eb 4e                	jmp    80057c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80052e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800532:	8b 00                	mov    (%rax),%eax
  800534:	83 f8 30             	cmp    $0x30,%eax
  800537:	73 24                	jae    80055d <getuint+0xeb>
  800539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800545:	8b 00                	mov    (%rax),%eax
  800547:	89 c0                	mov    %eax,%eax
  800549:	48 01 d0             	add    %rdx,%rax
  80054c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800550:	8b 12                	mov    (%rdx),%edx
  800552:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800555:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800559:	89 0a                	mov    %ecx,(%rdx)
  80055b:	eb 17                	jmp    800574 <getuint+0x102>
  80055d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800561:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800565:	48 89 d0             	mov    %rdx,%rax
  800568:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800570:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800574:	8b 00                	mov    (%rax),%eax
  800576:	89 c0                	mov    %eax,%eax
  800578:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80057c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800580:	c9                   	leaveq 
  800581:	c3                   	retq   

0000000000800582 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800582:	55                   	push   %rbp
  800583:	48 89 e5             	mov    %rsp,%rbp
  800586:	48 83 ec 1c          	sub    $0x1c,%rsp
  80058a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80058e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800591:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800595:	7e 52                	jle    8005e9 <getint+0x67>
		x=va_arg(*ap, long long);
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	8b 00                	mov    (%rax),%eax
  80059d:	83 f8 30             	cmp    $0x30,%eax
  8005a0:	73 24                	jae    8005c6 <getint+0x44>
  8005a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ae:	8b 00                	mov    (%rax),%eax
  8005b0:	89 c0                	mov    %eax,%eax
  8005b2:	48 01 d0             	add    %rdx,%rax
  8005b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b9:	8b 12                	mov    (%rdx),%edx
  8005bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c2:	89 0a                	mov    %ecx,(%rdx)
  8005c4:	eb 17                	jmp    8005dd <getint+0x5b>
  8005c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ce:	48 89 d0             	mov    %rdx,%rax
  8005d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005dd:	48 8b 00             	mov    (%rax),%rax
  8005e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e4:	e9 a3 00 00 00       	jmpq   80068c <getint+0x10a>
	else if (lflag)
  8005e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005ed:	74 4f                	je     80063e <getint+0xbc>
		x=va_arg(*ap, long);
  8005ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f3:	8b 00                	mov    (%rax),%eax
  8005f5:	83 f8 30             	cmp    $0x30,%eax
  8005f8:	73 24                	jae    80061e <getint+0x9c>
  8005fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800606:	8b 00                	mov    (%rax),%eax
  800608:	89 c0                	mov    %eax,%eax
  80060a:	48 01 d0             	add    %rdx,%rax
  80060d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800611:	8b 12                	mov    (%rdx),%edx
  800613:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061a:	89 0a                	mov    %ecx,(%rdx)
  80061c:	eb 17                	jmp    800635 <getint+0xb3>
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800626:	48 89 d0             	mov    %rdx,%rax
  800629:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800631:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800635:	48 8b 00             	mov    (%rax),%rax
  800638:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063c:	eb 4e                	jmp    80068c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	8b 00                	mov    (%rax),%eax
  800644:	83 f8 30             	cmp    $0x30,%eax
  800647:	73 24                	jae    80066d <getint+0xeb>
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	8b 00                	mov    (%rax),%eax
  800657:	89 c0                	mov    %eax,%eax
  800659:	48 01 d0             	add    %rdx,%rax
  80065c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800660:	8b 12                	mov    (%rdx),%edx
  800662:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800669:	89 0a                	mov    %ecx,(%rdx)
  80066b:	eb 17                	jmp    800684 <getint+0x102>
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800675:	48 89 d0             	mov    %rdx,%rax
  800678:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800680:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800684:	8b 00                	mov    (%rax),%eax
  800686:	48 98                	cltq   
  800688:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80068c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800690:	c9                   	leaveq 
  800691:	c3                   	retq   

0000000000800692 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800692:	55                   	push   %rbp
  800693:	48 89 e5             	mov    %rsp,%rbp
  800696:	41 54                	push   %r12
  800698:	53                   	push   %rbx
  800699:	48 83 ec 60          	sub    $0x60,%rsp
  80069d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006a1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006a5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006b1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006b5:	48 8b 0a             	mov    (%rdx),%rcx
  8006b8:	48 89 08             	mov    %rcx,(%rax)
  8006bb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006bf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cb:	eb 17                	jmp    8006e4 <vprintfmt+0x52>
			if (ch == '\0')
  8006cd:	85 db                	test   %ebx,%ebx
  8006cf:	0f 84 df 04 00 00    	je     800bb4 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8006d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006dd:	48 89 d6             	mov    %rdx,%rsi
  8006e0:	89 df                	mov    %ebx,%edi
  8006e2:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ec:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006f0:	0f b6 00             	movzbl (%rax),%eax
  8006f3:	0f b6 d8             	movzbl %al,%ebx
  8006f6:	83 fb 25             	cmp    $0x25,%ebx
  8006f9:	75 d2                	jne    8006cd <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006fb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006ff:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800706:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80070d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800714:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80071f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800723:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800727:	0f b6 00             	movzbl (%rax),%eax
  80072a:	0f b6 d8             	movzbl %al,%ebx
  80072d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800730:	83 f8 55             	cmp    $0x55,%eax
  800733:	0f 87 47 04 00 00    	ja     800b80 <vprintfmt+0x4ee>
  800739:	89 c0                	mov    %eax,%eax
  80073b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800742:	00 
  800743:	48 b8 18 39 80 00 00 	movabs $0x803918,%rax
  80074a:	00 00 00 
  80074d:	48 01 d0             	add    %rdx,%rax
  800750:	48 8b 00             	mov    (%rax),%rax
  800753:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800755:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800759:	eb c0                	jmp    80071b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80075b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80075f:	eb ba                	jmp    80071b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800761:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800768:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80076b:	89 d0                	mov    %edx,%eax
  80076d:	c1 e0 02             	shl    $0x2,%eax
  800770:	01 d0                	add    %edx,%eax
  800772:	01 c0                	add    %eax,%eax
  800774:	01 d8                	add    %ebx,%eax
  800776:	83 e8 30             	sub    $0x30,%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80077c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800780:	0f b6 00             	movzbl (%rax),%eax
  800783:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800786:	83 fb 2f             	cmp    $0x2f,%ebx
  800789:	7e 0c                	jle    800797 <vprintfmt+0x105>
  80078b:	83 fb 39             	cmp    $0x39,%ebx
  80078e:	7f 07                	jg     800797 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800795:	eb d1                	jmp    800768 <vprintfmt+0xd6>
			goto process_precision;
  800797:	eb 58                	jmp    8007f1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800799:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079c:	83 f8 30             	cmp    $0x30,%eax
  80079f:	73 17                	jae    8007b8 <vprintfmt+0x126>
  8007a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a8:	89 c0                	mov    %eax,%eax
  8007aa:	48 01 d0             	add    %rdx,%rax
  8007ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007b0:	83 c2 08             	add    $0x8,%edx
  8007b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b6:	eb 0f                	jmp    8007c7 <vprintfmt+0x135>
  8007b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007bc:	48 89 d0             	mov    %rdx,%rax
  8007bf:	48 83 c2 08          	add    $0x8,%rdx
  8007c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c7:	8b 00                	mov    (%rax),%eax
  8007c9:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007cc:	eb 23                	jmp    8007f1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007d2:	79 0c                	jns    8007e0 <vprintfmt+0x14e>
				width = 0;
  8007d4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007db:	e9 3b ff ff ff       	jmpq   80071b <vprintfmt+0x89>
  8007e0:	e9 36 ff ff ff       	jmpq   80071b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007e5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007ec:	e9 2a ff ff ff       	jmpq   80071b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007f5:	79 12                	jns    800809 <vprintfmt+0x177>
				width = precision, precision = -1;
  8007f7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007fa:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800804:	e9 12 ff ff ff       	jmpq   80071b <vprintfmt+0x89>
  800809:	e9 0d ff ff ff       	jmpq   80071b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800812:	e9 04 ff ff ff       	jmpq   80071b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800817:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081a:	83 f8 30             	cmp    $0x30,%eax
  80081d:	73 17                	jae    800836 <vprintfmt+0x1a4>
  80081f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800823:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800826:	89 c0                	mov    %eax,%eax
  800828:	48 01 d0             	add    %rdx,%rax
  80082b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80082e:	83 c2 08             	add    $0x8,%edx
  800831:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800834:	eb 0f                	jmp    800845 <vprintfmt+0x1b3>
  800836:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80083a:	48 89 d0             	mov    %rdx,%rax
  80083d:	48 83 c2 08          	add    $0x8,%rdx
  800841:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800845:	8b 10                	mov    (%rax),%edx
  800847:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80084b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80084f:	48 89 ce             	mov    %rcx,%rsi
  800852:	89 d7                	mov    %edx,%edi
  800854:	ff d0                	callq  *%rax
			break;
  800856:	e9 53 03 00 00       	jmpq   800bae <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80085b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085e:	83 f8 30             	cmp    $0x30,%eax
  800861:	73 17                	jae    80087a <vprintfmt+0x1e8>
  800863:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800867:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086a:	89 c0                	mov    %eax,%eax
  80086c:	48 01 d0             	add    %rdx,%rax
  80086f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800872:	83 c2 08             	add    $0x8,%edx
  800875:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800878:	eb 0f                	jmp    800889 <vprintfmt+0x1f7>
  80087a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087e:	48 89 d0             	mov    %rdx,%rax
  800881:	48 83 c2 08          	add    $0x8,%rdx
  800885:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800889:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80088b:	85 db                	test   %ebx,%ebx
  80088d:	79 02                	jns    800891 <vprintfmt+0x1ff>
				err = -err;
  80088f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800891:	83 fb 15             	cmp    $0x15,%ebx
  800894:	7f 16                	jg     8008ac <vprintfmt+0x21a>
  800896:	48 b8 40 38 80 00 00 	movabs $0x803840,%rax
  80089d:	00 00 00 
  8008a0:	48 63 d3             	movslq %ebx,%rdx
  8008a3:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008a7:	4d 85 e4             	test   %r12,%r12
  8008aa:	75 2e                	jne    8008da <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008ac:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b4:	89 d9                	mov    %ebx,%ecx
  8008b6:	48 ba 01 39 80 00 00 	movabs $0x803901,%rdx
  8008bd:	00 00 00 
  8008c0:	48 89 c7             	mov    %rax,%rdi
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c8:	49 b8 bd 0b 80 00 00 	movabs $0x800bbd,%r8
  8008cf:	00 00 00 
  8008d2:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008d5:	e9 d4 02 00 00       	jmpq   800bae <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008da:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e2:	4c 89 e1             	mov    %r12,%rcx
  8008e5:	48 ba 0a 39 80 00 00 	movabs $0x80390a,%rdx
  8008ec:	00 00 00 
  8008ef:	48 89 c7             	mov    %rax,%rdi
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f7:	49 b8 bd 0b 80 00 00 	movabs $0x800bbd,%r8
  8008fe:	00 00 00 
  800901:	41 ff d0             	callq  *%r8
			break;
  800904:	e9 a5 02 00 00       	jmpq   800bae <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800909:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090c:	83 f8 30             	cmp    $0x30,%eax
  80090f:	73 17                	jae    800928 <vprintfmt+0x296>
  800911:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800915:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800918:	89 c0                	mov    %eax,%eax
  80091a:	48 01 d0             	add    %rdx,%rax
  80091d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800920:	83 c2 08             	add    $0x8,%edx
  800923:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800926:	eb 0f                	jmp    800937 <vprintfmt+0x2a5>
  800928:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092c:	48 89 d0             	mov    %rdx,%rax
  80092f:	48 83 c2 08          	add    $0x8,%rdx
  800933:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800937:	4c 8b 20             	mov    (%rax),%r12
  80093a:	4d 85 e4             	test   %r12,%r12
  80093d:	75 0a                	jne    800949 <vprintfmt+0x2b7>
				p = "(null)";
  80093f:	49 bc 0d 39 80 00 00 	movabs $0x80390d,%r12
  800946:	00 00 00 
			if (width > 0 && padc != '-')
  800949:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80094d:	7e 3f                	jle    80098e <vprintfmt+0x2fc>
  80094f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800953:	74 39                	je     80098e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800958:	48 98                	cltq   
  80095a:	48 89 c6             	mov    %rax,%rsi
  80095d:	4c 89 e7             	mov    %r12,%rdi
  800960:	48 b8 69 0e 80 00 00 	movabs $0x800e69,%rax
  800967:	00 00 00 
  80096a:	ff d0                	callq  *%rax
  80096c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80096f:	eb 17                	jmp    800988 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800971:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800975:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800979:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097d:	48 89 ce             	mov    %rcx,%rsi
  800980:	89 d7                	mov    %edx,%edi
  800982:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800984:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098c:	7f e3                	jg     800971 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098e:	eb 37                	jmp    8009c7 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800990:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800994:	74 1e                	je     8009b4 <vprintfmt+0x322>
  800996:	83 fb 1f             	cmp    $0x1f,%ebx
  800999:	7e 05                	jle    8009a0 <vprintfmt+0x30e>
  80099b:	83 fb 7e             	cmp    $0x7e,%ebx
  80099e:	7e 14                	jle    8009b4 <vprintfmt+0x322>
					putch('?', putdat);
  8009a0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a8:	48 89 d6             	mov    %rdx,%rsi
  8009ab:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009b0:	ff d0                	callq  *%rax
  8009b2:	eb 0f                	jmp    8009c3 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009b4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bc:	48 89 d6             	mov    %rdx,%rsi
  8009bf:	89 df                	mov    %ebx,%edi
  8009c1:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c7:	4c 89 e0             	mov    %r12,%rax
  8009ca:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009ce:	0f b6 00             	movzbl (%rax),%eax
  8009d1:	0f be d8             	movsbl %al,%ebx
  8009d4:	85 db                	test   %ebx,%ebx
  8009d6:	74 10                	je     8009e8 <vprintfmt+0x356>
  8009d8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009dc:	78 b2                	js     800990 <vprintfmt+0x2fe>
  8009de:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009e6:	79 a8                	jns    800990 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e8:	eb 16                	jmp    800a00 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f2:	48 89 d6             	mov    %rdx,%rsi
  8009f5:	bf 20 00 00 00       	mov    $0x20,%edi
  8009fa:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a00:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a04:	7f e4                	jg     8009ea <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a06:	e9 a3 01 00 00       	jmpq   800bae <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a0b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a0f:	be 03 00 00 00       	mov    $0x3,%esi
  800a14:	48 89 c7             	mov    %rax,%rdi
  800a17:	48 b8 82 05 80 00 00 	movabs $0x800582,%rax
  800a1e:	00 00 00 
  800a21:	ff d0                	callq  *%rax
  800a23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	48 85 c0             	test   %rax,%rax
  800a2e:	79 1d                	jns    800a4d <vprintfmt+0x3bb>
				putch('-', putdat);
  800a30:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a38:	48 89 d6             	mov    %rdx,%rsi
  800a3b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a40:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a46:	48 f7 d8             	neg    %rax
  800a49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a4d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a54:	e9 e8 00 00 00       	jmpq   800b41 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a59:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a5d:	be 03 00 00 00       	mov    $0x3,%esi
  800a62:	48 89 c7             	mov    %rax,%rdi
  800a65:	48 b8 72 04 80 00 00 	movabs $0x800472,%rax
  800a6c:	00 00 00 
  800a6f:	ff d0                	callq  *%rax
  800a71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a75:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a7c:	e9 c0 00 00 00       	jmpq   800b41 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a89:	48 89 d6             	mov    %rdx,%rsi
  800a8c:	bf 58 00 00 00       	mov    $0x58,%edi
  800a91:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9b:	48 89 d6             	mov    %rdx,%rsi
  800a9e:	bf 58 00 00 00       	mov    $0x58,%edi
  800aa3:	ff d0                	callq  *%rax
			putch('X', putdat);
  800aa5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aad:	48 89 d6             	mov    %rdx,%rsi
  800ab0:	bf 58 00 00 00       	mov    $0x58,%edi
  800ab5:	ff d0                	callq  *%rax
			break;
  800ab7:	e9 f2 00 00 00       	jmpq   800bae <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800abc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac4:	48 89 d6             	mov    %rdx,%rsi
  800ac7:	bf 30 00 00 00       	mov    $0x30,%edi
  800acc:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ace:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad6:	48 89 d6             	mov    %rdx,%rsi
  800ad9:	bf 78 00 00 00       	mov    $0x78,%edi
  800ade:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ae0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae3:	83 f8 30             	cmp    $0x30,%eax
  800ae6:	73 17                	jae    800aff <vprintfmt+0x46d>
  800ae8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aef:	89 c0                	mov    %eax,%eax
  800af1:	48 01 d0             	add    %rdx,%rax
  800af4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af7:	83 c2 08             	add    $0x8,%edx
  800afa:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afd:	eb 0f                	jmp    800b0e <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800aff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b03:	48 89 d0             	mov    %rdx,%rax
  800b06:	48 83 c2 08          	add    $0x8,%rdx
  800b0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b15:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b1c:	eb 23                	jmp    800b41 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b1e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b22:	be 03 00 00 00       	mov    $0x3,%esi
  800b27:	48 89 c7             	mov    %rax,%rdi
  800b2a:	48 b8 72 04 80 00 00 	movabs $0x800472,%rax
  800b31:	00 00 00 
  800b34:	ff d0                	callq  *%rax
  800b36:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b3a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b41:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b46:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b49:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b50:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b58:	45 89 c1             	mov    %r8d,%r9d
  800b5b:	41 89 f8             	mov    %edi,%r8d
  800b5e:	48 89 c7             	mov    %rax,%rdi
  800b61:	48 b8 b7 03 80 00 00 	movabs $0x8003b7,%rax
  800b68:	00 00 00 
  800b6b:	ff d0                	callq  *%rax
			break;
  800b6d:	eb 3f                	jmp    800bae <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b77:	48 89 d6             	mov    %rdx,%rsi
  800b7a:	89 df                	mov    %ebx,%edi
  800b7c:	ff d0                	callq  *%rax
			break;
  800b7e:	eb 2e                	jmp    800bae <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b88:	48 89 d6             	mov    %rdx,%rsi
  800b8b:	bf 25 00 00 00       	mov    $0x25,%edi
  800b90:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b92:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b97:	eb 05                	jmp    800b9e <vprintfmt+0x50c>
  800b99:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b9e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba2:	48 83 e8 01          	sub    $0x1,%rax
  800ba6:	0f b6 00             	movzbl (%rax),%eax
  800ba9:	3c 25                	cmp    $0x25,%al
  800bab:	75 ec                	jne    800b99 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800bad:	90                   	nop
		}
	}
  800bae:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800baf:	e9 30 fb ff ff       	jmpq   8006e4 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bb4:	48 83 c4 60          	add    $0x60,%rsp
  800bb8:	5b                   	pop    %rbx
  800bb9:	41 5c                	pop    %r12
  800bbb:	5d                   	pop    %rbp
  800bbc:	c3                   	retq   

0000000000800bbd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbd:	55                   	push   %rbp
  800bbe:	48 89 e5             	mov    %rsp,%rbp
  800bc1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bc8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bcf:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bd6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bdd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800be4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800beb:	84 c0                	test   %al,%al
  800bed:	74 20                	je     800c0f <printfmt+0x52>
  800bef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bf3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bf7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bfb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c03:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c07:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c0b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c0f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c16:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c1d:	00 00 00 
  800c20:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c27:	00 00 00 
  800c2a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c2e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c35:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c3c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c43:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c4a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c51:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c58:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c5f:	48 89 c7             	mov    %rax,%rdi
  800c62:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  800c69:	00 00 00 
  800c6c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c6e:	c9                   	leaveq 
  800c6f:	c3                   	retq   

0000000000800c70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c70:	55                   	push   %rbp
  800c71:	48 89 e5             	mov    %rsp,%rbp
  800c74:	48 83 ec 10          	sub    $0x10,%rsp
  800c78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c83:	8b 40 10             	mov    0x10(%rax),%eax
  800c86:	8d 50 01             	lea    0x1(%rax),%edx
  800c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c94:	48 8b 10             	mov    (%rax),%rdx
  800c97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c9f:	48 39 c2             	cmp    %rax,%rdx
  800ca2:	73 17                	jae    800cbb <sprintputch+0x4b>
		*b->buf++ = ch;
  800ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca8:	48 8b 00             	mov    (%rax),%rax
  800cab:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800caf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb3:	48 89 0a             	mov    %rcx,(%rdx)
  800cb6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cb9:	88 10                	mov    %dl,(%rax)
}
  800cbb:	c9                   	leaveq 
  800cbc:	c3                   	retq   

0000000000800cbd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbd:	55                   	push   %rbp
  800cbe:	48 89 e5             	mov    %rsp,%rbp
  800cc1:	48 83 ec 50          	sub    $0x50,%rsp
  800cc5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cc9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ccc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cd0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cd4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cd8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cdc:	48 8b 0a             	mov    (%rdx),%rcx
  800cdf:	48 89 08             	mov    %rcx,(%rax)
  800ce2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ce6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cee:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cfa:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cfd:	48 98                	cltq   
  800cff:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d03:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d07:	48 01 d0             	add    %rdx,%rax
  800d0a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d15:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d1a:	74 06                	je     800d22 <vsnprintf+0x65>
  800d1c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d20:	7f 07                	jg     800d29 <vsnprintf+0x6c>
		return -E_INVAL;
  800d22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d27:	eb 2f                	jmp    800d58 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d29:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d2d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d31:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d35:	48 89 c6             	mov    %rax,%rsi
  800d38:	48 bf 70 0c 80 00 00 	movabs $0x800c70,%rdi
  800d3f:	00 00 00 
  800d42:	48 b8 92 06 80 00 00 	movabs $0x800692,%rax
  800d49:	00 00 00 
  800d4c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d52:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d55:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d58:	c9                   	leaveq 
  800d59:	c3                   	retq   

0000000000800d5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d5a:	55                   	push   %rbp
  800d5b:	48 89 e5             	mov    %rsp,%rbp
  800d5e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d65:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d6c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d72:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d79:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d80:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d87:	84 c0                	test   %al,%al
  800d89:	74 20                	je     800dab <snprintf+0x51>
  800d8b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d8f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d93:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d97:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d9f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dab:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800db2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800db9:	00 00 00 
  800dbc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dc3:	00 00 00 
  800dc6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dd1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ddf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800de6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ded:	48 8b 0a             	mov    (%rdx),%rcx
  800df0:	48 89 08             	mov    %rcx,(%rax)
  800df3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800df7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dfb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e03:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e0a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e11:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e17:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e1e:	48 89 c7             	mov    %rax,%rdi
  800e21:	48 b8 bd 0c 80 00 00 	movabs $0x800cbd,%rax
  800e28:	00 00 00 
  800e2b:	ff d0                	callq  *%rax
  800e2d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e33:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e39:	c9                   	leaveq 
  800e3a:	c3                   	retq   

0000000000800e3b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e3b:	55                   	push   %rbp
  800e3c:	48 89 e5             	mov    %rsp,%rbp
  800e3f:	48 83 ec 18          	sub    $0x18,%rsp
  800e43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e4e:	eb 09                	jmp    800e59 <strlen+0x1e>
		n++;
  800e50:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e54:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5d:	0f b6 00             	movzbl (%rax),%eax
  800e60:	84 c0                	test   %al,%al
  800e62:	75 ec                	jne    800e50 <strlen+0x15>
		n++;
	return n;
  800e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e67:	c9                   	leaveq 
  800e68:	c3                   	retq   

0000000000800e69 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e69:	55                   	push   %rbp
  800e6a:	48 89 e5             	mov    %rsp,%rbp
  800e6d:	48 83 ec 20          	sub    $0x20,%rsp
  800e71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e80:	eb 0e                	jmp    800e90 <strnlen+0x27>
		n++;
  800e82:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e86:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e8b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e90:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e95:	74 0b                	je     800ea2 <strnlen+0x39>
  800e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9b:	0f b6 00             	movzbl (%rax),%eax
  800e9e:	84 c0                	test   %al,%al
  800ea0:	75 e0                	jne    800e82 <strnlen+0x19>
		n++;
	return n;
  800ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea5:	c9                   	leaveq 
  800ea6:	c3                   	retq   

0000000000800ea7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea7:	55                   	push   %rbp
  800ea8:	48 89 e5             	mov    %rsp,%rbp
  800eab:	48 83 ec 20          	sub    $0x20,%rsp
  800eaf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ebf:	90                   	nop
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ec8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ecc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ed0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ed4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ed8:	0f b6 12             	movzbl (%rdx),%edx
  800edb:	88 10                	mov    %dl,(%rax)
  800edd:	0f b6 00             	movzbl (%rax),%eax
  800ee0:	84 c0                	test   %al,%al
  800ee2:	75 dc                	jne    800ec0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ee4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ee8:	c9                   	leaveq 
  800ee9:	c3                   	retq   

0000000000800eea <strcat>:

char *
strcat(char *dst, const char *src)
{
  800eea:	55                   	push   %rbp
  800eeb:	48 89 e5             	mov    %rsp,%rbp
  800eee:	48 83 ec 20          	sub    $0x20,%rsp
  800ef2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800efa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efe:	48 89 c7             	mov    %rax,%rdi
  800f01:	48 b8 3b 0e 80 00 00 	movabs $0x800e3b,%rax
  800f08:	00 00 00 
  800f0b:	ff d0                	callq  *%rax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f13:	48 63 d0             	movslq %eax,%rdx
  800f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1a:	48 01 c2             	add    %rax,%rdx
  800f1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f21:	48 89 c6             	mov    %rax,%rsi
  800f24:	48 89 d7             	mov    %rdx,%rdi
  800f27:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  800f2e:	00 00 00 
  800f31:	ff d0                	callq  *%rax
	return dst;
  800f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f37:	c9                   	leaveq 
  800f38:	c3                   	retq   

0000000000800f39 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f39:	55                   	push   %rbp
  800f3a:	48 89 e5             	mov    %rsp,%rbp
  800f3d:	48 83 ec 28          	sub    $0x28,%rsp
  800f41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f55:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f5c:	00 
  800f5d:	eb 2a                	jmp    800f89 <strncpy+0x50>
		*dst++ = *src;
  800f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f63:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f67:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f6b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6f:	0f b6 12             	movzbl (%rdx),%edx
  800f72:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f78:	0f b6 00             	movzbl (%rax),%eax
  800f7b:	84 c0                	test   %al,%al
  800f7d:	74 05                	je     800f84 <strncpy+0x4b>
			src++;
  800f7f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f84:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f91:	72 cc                	jb     800f5f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f97:	c9                   	leaveq 
  800f98:	c3                   	retq   

0000000000800f99 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f99:	55                   	push   %rbp
  800f9a:	48 89 e5             	mov    %rsp,%rbp
  800f9d:	48 83 ec 28          	sub    $0x28,%rsp
  800fa1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fa9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fb5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fba:	74 3d                	je     800ff9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fbc:	eb 1d                	jmp    800fdb <strlcpy+0x42>
			*dst++ = *src++;
  800fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fc6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fce:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fd2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fd6:	0f b6 12             	movzbl (%rdx),%edx
  800fd9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fdb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fe0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe5:	74 0b                	je     800ff2 <strlcpy+0x59>
  800fe7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800feb:	0f b6 00             	movzbl (%rax),%eax
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 cc                	jne    800fbe <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800ff9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801001:	48 29 c2             	sub    %rax,%rdx
  801004:	48 89 d0             	mov    %rdx,%rax
}
  801007:	c9                   	leaveq 
  801008:	c3                   	retq   

0000000000801009 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801009:	55                   	push   %rbp
  80100a:	48 89 e5             	mov    %rsp,%rbp
  80100d:	48 83 ec 10          	sub    $0x10,%rsp
  801011:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801015:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801019:	eb 0a                	jmp    801025 <strcmp+0x1c>
		p++, q++;
  80101b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801020:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801029:	0f b6 00             	movzbl (%rax),%eax
  80102c:	84 c0                	test   %al,%al
  80102e:	74 12                	je     801042 <strcmp+0x39>
  801030:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801034:	0f b6 10             	movzbl (%rax),%edx
  801037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103b:	0f b6 00             	movzbl (%rax),%eax
  80103e:	38 c2                	cmp    %al,%dl
  801040:	74 d9                	je     80101b <strcmp+0x12>
		p++, q++;
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

000000000080105c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 18          	sub    $0x18,%rsp
  801064:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801068:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80106c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801070:	eb 0f                	jmp    801081 <strncmp+0x25>
		n--, p++, q++;
  801072:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801077:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801081:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801086:	74 1d                	je     8010a5 <strncmp+0x49>
  801088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108c:	0f b6 00             	movzbl (%rax),%eax
  80108f:	84 c0                	test   %al,%al
  801091:	74 12                	je     8010a5 <strncmp+0x49>
  801093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801097:	0f b6 10             	movzbl (%rax),%edx
  80109a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	38 c2                	cmp    %al,%dl
  8010a3:	74 cd                	je     801072 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010aa:	75 07                	jne    8010b3 <strncmp+0x57>
		return 0;
  8010ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b1:	eb 18                	jmp    8010cb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b7:	0f b6 00             	movzbl (%rax),%eax
  8010ba:	0f b6 d0             	movzbl %al,%edx
  8010bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c1:	0f b6 00             	movzbl (%rax),%eax
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
}
  8010cb:	c9                   	leaveq 
  8010cc:	c3                   	retq   

00000000008010cd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	48 83 ec 0c          	sub    $0xc,%rsp
  8010d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d9:	89 f0                	mov    %esi,%eax
  8010db:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010de:	eb 17                	jmp    8010f7 <strchr+0x2a>
		if (*s == c)
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010ea:	75 06                	jne    8010f2 <strchr+0x25>
			return (char *) s;
  8010ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f0:	eb 15                	jmp    801107 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fb:	0f b6 00             	movzbl (%rax),%eax
  8010fe:	84 c0                	test   %al,%al
  801100:	75 de                	jne    8010e0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801102:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801107:	c9                   	leaveq 
  801108:	c3                   	retq   

0000000000801109 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801109:	55                   	push   %rbp
  80110a:	48 89 e5             	mov    %rsp,%rbp
  80110d:	48 83 ec 0c          	sub    $0xc,%rsp
  801111:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801115:	89 f0                	mov    %esi,%eax
  801117:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80111a:	eb 13                	jmp    80112f <strfind+0x26>
		if (*s == c)
  80111c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801120:	0f b6 00             	movzbl (%rax),%eax
  801123:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801126:	75 02                	jne    80112a <strfind+0x21>
			break;
  801128:	eb 10                	jmp    80113a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80112a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801133:	0f b6 00             	movzbl (%rax),%eax
  801136:	84 c0                	test   %al,%al
  801138:	75 e2                	jne    80111c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80113a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113e:	c9                   	leaveq 
  80113f:	c3                   	retq   

0000000000801140 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801140:	55                   	push   %rbp
  801141:	48 89 e5             	mov    %rsp,%rbp
  801144:	48 83 ec 18          	sub    $0x18,%rsp
  801148:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80114f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801153:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801158:	75 06                	jne    801160 <memset+0x20>
		return v;
  80115a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115e:	eb 69                	jmp    8011c9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801164:	83 e0 03             	and    $0x3,%eax
  801167:	48 85 c0             	test   %rax,%rax
  80116a:	75 48                	jne    8011b4 <memset+0x74>
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	83 e0 03             	and    $0x3,%eax
  801173:	48 85 c0             	test   %rax,%rax
  801176:	75 3c                	jne    8011b4 <memset+0x74>
		c &= 0xFF;
  801178:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80117f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801182:	c1 e0 18             	shl    $0x18,%eax
  801185:	89 c2                	mov    %eax,%edx
  801187:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118a:	c1 e0 10             	shl    $0x10,%eax
  80118d:	09 c2                	or     %eax,%edx
  80118f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801192:	c1 e0 08             	shl    $0x8,%eax
  801195:	09 d0                	or     %edx,%eax
  801197:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80119a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119e:	48 c1 e8 02          	shr    $0x2,%rax
  8011a2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ac:	48 89 d7             	mov    %rdx,%rdi
  8011af:	fc                   	cld    
  8011b0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011b2:	eb 11                	jmp    8011c5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011bb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011bf:	48 89 d7             	mov    %rdx,%rdi
  8011c2:	fc                   	cld    
  8011c3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c9:	c9                   	leaveq 
  8011ca:	c3                   	retq   

00000000008011cb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011cb:	55                   	push   %rbp
  8011cc:	48 89 e5             	mov    %rsp,%rbp
  8011cf:	48 83 ec 28          	sub    $0x28,%rsp
  8011d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011f7:	0f 83 88 00 00 00    	jae    801285 <memmove+0xba>
  8011fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801201:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801205:	48 01 d0             	add    %rdx,%rax
  801208:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80120c:	76 77                	jbe    801285 <memmove+0xba>
		s += n;
  80120e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801212:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801216:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80121e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801222:	83 e0 03             	and    $0x3,%eax
  801225:	48 85 c0             	test   %rax,%rax
  801228:	75 3b                	jne    801265 <memmove+0x9a>
  80122a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122e:	83 e0 03             	and    $0x3,%eax
  801231:	48 85 c0             	test   %rax,%rax
  801234:	75 2f                	jne    801265 <memmove+0x9a>
  801236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123a:	83 e0 03             	and    $0x3,%eax
  80123d:	48 85 c0             	test   %rax,%rax
  801240:	75 23                	jne    801265 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801246:	48 83 e8 04          	sub    $0x4,%rax
  80124a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124e:	48 83 ea 04          	sub    $0x4,%rdx
  801252:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801256:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80125a:	48 89 c7             	mov    %rax,%rdi
  80125d:	48 89 d6             	mov    %rdx,%rsi
  801260:	fd                   	std    
  801261:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801263:	eb 1d                	jmp    801282 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801269:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80126d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801271:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801275:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801279:	48 89 d7             	mov    %rdx,%rdi
  80127c:	48 89 c1             	mov    %rax,%rcx
  80127f:	fd                   	std    
  801280:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801282:	fc                   	cld    
  801283:	eb 57                	jmp    8012dc <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	83 e0 03             	and    $0x3,%eax
  80128c:	48 85 c0             	test   %rax,%rax
  80128f:	75 36                	jne    8012c7 <memmove+0xfc>
  801291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801295:	83 e0 03             	and    $0x3,%eax
  801298:	48 85 c0             	test   %rax,%rax
  80129b:	75 2a                	jne    8012c7 <memmove+0xfc>
  80129d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a1:	83 e0 03             	and    $0x3,%eax
  8012a4:	48 85 c0             	test   %rax,%rax
  8012a7:	75 1e                	jne    8012c7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ad:	48 c1 e8 02          	shr    $0x2,%rax
  8012b1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012bc:	48 89 c7             	mov    %rax,%rdi
  8012bf:	48 89 d6             	mov    %rdx,%rsi
  8012c2:	fc                   	cld    
  8012c3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012c5:	eb 15                	jmp    8012dc <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012cf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d3:	48 89 c7             	mov    %rax,%rdi
  8012d6:	48 89 d6             	mov    %rdx,%rsi
  8012d9:	fc                   	cld    
  8012da:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 18          	sub    $0x18,%rsp
  8012ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012fa:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801302:	48 89 ce             	mov    %rcx,%rsi
  801305:	48 89 c7             	mov    %rax,%rdi
  801308:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  80130f:	00 00 00 
  801312:	ff d0                	callq  *%rax
}
  801314:	c9                   	leaveq 
  801315:	c3                   	retq   

0000000000801316 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801316:	55                   	push   %rbp
  801317:	48 89 e5             	mov    %rsp,%rbp
  80131a:	48 83 ec 28          	sub    $0x28,%rsp
  80131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801326:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801332:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801336:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80133a:	eb 36                	jmp    801372 <memcmp+0x5c>
		if (*s1 != *s2)
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	0f b6 10             	movzbl (%rax),%edx
  801343:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801347:	0f b6 00             	movzbl (%rax),%eax
  80134a:	38 c2                	cmp    %al,%dl
  80134c:	74 1a                	je     801368 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	0f b6 00             	movzbl (%rax),%eax
  801355:	0f b6 d0             	movzbl %al,%edx
  801358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	0f b6 c0             	movzbl %al,%eax
  801362:	29 c2                	sub    %eax,%edx
  801364:	89 d0                	mov    %edx,%eax
  801366:	eb 20                	jmp    801388 <memcmp+0x72>
		s1++, s2++;
  801368:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80137a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80137e:	48 85 c0             	test   %rax,%rax
  801381:	75 b9                	jne    80133c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801383:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801388:	c9                   	leaveq 
  801389:	c3                   	retq   

000000000080138a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80138a:	55                   	push   %rbp
  80138b:	48 89 e5             	mov    %rsp,%rbp
  80138e:	48 83 ec 28          	sub    $0x28,%rsp
  801392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801396:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80139d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a5:	48 01 d0             	add    %rdx,%rax
  8013a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013ac:	eb 15                	jmp    8013c3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b2:	0f b6 10             	movzbl (%rax),%edx
  8013b5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013b8:	38 c2                	cmp    %al,%dl
  8013ba:	75 02                	jne    8013be <memfind+0x34>
			break;
  8013bc:	eb 0f                	jmp    8013cd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013cb:	72 e1                	jb     8013ae <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 83 ec 34          	sub    $0x34,%rsp
  8013db:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013e3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013ed:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013f4:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f5:	eb 05                	jmp    8013fc <strtol+0x29>
		s++;
  8013f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801400:	0f b6 00             	movzbl (%rax),%eax
  801403:	3c 20                	cmp    $0x20,%al
  801405:	74 f0                	je     8013f7 <strtol+0x24>
  801407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140b:	0f b6 00             	movzbl (%rax),%eax
  80140e:	3c 09                	cmp    $0x9,%al
  801410:	74 e5                	je     8013f7 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	0f b6 00             	movzbl (%rax),%eax
  801419:	3c 2b                	cmp    $0x2b,%al
  80141b:	75 07                	jne    801424 <strtol+0x51>
		s++;
  80141d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801422:	eb 17                	jmp    80143b <strtol+0x68>
	else if (*s == '-')
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	0f b6 00             	movzbl (%rax),%eax
  80142b:	3c 2d                	cmp    $0x2d,%al
  80142d:	75 0c                	jne    80143b <strtol+0x68>
		s++, neg = 1;
  80142f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80143f:	74 06                	je     801447 <strtol+0x74>
  801441:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801445:	75 28                	jne    80146f <strtol+0x9c>
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	0f b6 00             	movzbl (%rax),%eax
  80144e:	3c 30                	cmp    $0x30,%al
  801450:	75 1d                	jne    80146f <strtol+0x9c>
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	48 83 c0 01          	add    $0x1,%rax
  80145a:	0f b6 00             	movzbl (%rax),%eax
  80145d:	3c 78                	cmp    $0x78,%al
  80145f:	75 0e                	jne    80146f <strtol+0x9c>
		s += 2, base = 16;
  801461:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801466:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80146d:	eb 2c                	jmp    80149b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80146f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801473:	75 19                	jne    80148e <strtol+0xbb>
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	0f b6 00             	movzbl (%rax),%eax
  80147c:	3c 30                	cmp    $0x30,%al
  80147e:	75 0e                	jne    80148e <strtol+0xbb>
		s++, base = 8;
  801480:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801485:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80148c:	eb 0d                	jmp    80149b <strtol+0xc8>
	else if (base == 0)
  80148e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801492:	75 07                	jne    80149b <strtol+0xc8>
		base = 10;
  801494:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	3c 2f                	cmp    $0x2f,%al
  8014a4:	7e 1d                	jle    8014c3 <strtol+0xf0>
  8014a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014aa:	0f b6 00             	movzbl (%rax),%eax
  8014ad:	3c 39                	cmp    $0x39,%al
  8014af:	7f 12                	jg     8014c3 <strtol+0xf0>
			dig = *s - '0';
  8014b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b5:	0f b6 00             	movzbl (%rax),%eax
  8014b8:	0f be c0             	movsbl %al,%eax
  8014bb:	83 e8 30             	sub    $0x30,%eax
  8014be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c1:	eb 4e                	jmp    801511 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c7:	0f b6 00             	movzbl (%rax),%eax
  8014ca:	3c 60                	cmp    $0x60,%al
  8014cc:	7e 1d                	jle    8014eb <strtol+0x118>
  8014ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	3c 7a                	cmp    $0x7a,%al
  8014d7:	7f 12                	jg     8014eb <strtol+0x118>
			dig = *s - 'a' + 10;
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	0f be c0             	movsbl %al,%eax
  8014e3:	83 e8 57             	sub    $0x57,%eax
  8014e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014e9:	eb 26                	jmp    801511 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	0f b6 00             	movzbl (%rax),%eax
  8014f2:	3c 40                	cmp    $0x40,%al
  8014f4:	7e 48                	jle    80153e <strtol+0x16b>
  8014f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fa:	0f b6 00             	movzbl (%rax),%eax
  8014fd:	3c 5a                	cmp    $0x5a,%al
  8014ff:	7f 3d                	jg     80153e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801505:	0f b6 00             	movzbl (%rax),%eax
  801508:	0f be c0             	movsbl %al,%eax
  80150b:	83 e8 37             	sub    $0x37,%eax
  80150e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801511:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801514:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801517:	7c 02                	jl     80151b <strtol+0x148>
			break;
  801519:	eb 23                	jmp    80153e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80151b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801520:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801523:	48 98                	cltq   
  801525:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80152a:	48 89 c2             	mov    %rax,%rdx
  80152d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801530:	48 98                	cltq   
  801532:	48 01 d0             	add    %rdx,%rax
  801535:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801539:	e9 5d ff ff ff       	jmpq   80149b <strtol+0xc8>

	if (endptr)
  80153e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801543:	74 0b                	je     801550 <strtol+0x17d>
		*endptr = (char *) s;
  801545:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801549:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80154d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801550:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801554:	74 09                	je     80155f <strtol+0x18c>
  801556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155a:	48 f7 d8             	neg    %rax
  80155d:	eb 04                	jmp    801563 <strtol+0x190>
  80155f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801563:	c9                   	leaveq 
  801564:	c3                   	retq   

0000000000801565 <strstr>:

char * strstr(const char *in, const char *str)
{
  801565:	55                   	push   %rbp
  801566:	48 89 e5             	mov    %rsp,%rbp
  801569:	48 83 ec 30          	sub    $0x30,%rsp
  80156d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801571:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801575:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801579:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80157d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801581:	0f b6 00             	movzbl (%rax),%eax
  801584:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801587:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80158b:	75 06                	jne    801593 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80158d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801591:	eb 6b                	jmp    8015fe <strstr+0x99>

	len = strlen(str);
  801593:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801597:	48 89 c7             	mov    %rax,%rdi
  80159a:	48 b8 3b 0e 80 00 00 	movabs $0x800e3b,%rax
  8015a1:	00 00 00 
  8015a4:	ff d0                	callq  *%rax
  8015a6:	48 98                	cltq   
  8015a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015b8:	0f b6 00             	movzbl (%rax),%eax
  8015bb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015be:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015c2:	75 07                	jne    8015cb <strstr+0x66>
				return (char *) 0;
  8015c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c9:	eb 33                	jmp    8015fe <strstr+0x99>
		} while (sc != c);
  8015cb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015cf:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015d2:	75 d8                	jne    8015ac <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015d8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e0:	48 89 ce             	mov    %rcx,%rsi
  8015e3:	48 89 c7             	mov    %rax,%rdi
  8015e6:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  8015ed:	00 00 00 
  8015f0:	ff d0                	callq  *%rax
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	75 b6                	jne    8015ac <strstr+0x47>

	return (char *) (in - 1);
  8015f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fa:	48 83 e8 01          	sub    $0x1,%rax
}
  8015fe:	c9                   	leaveq 
  8015ff:	c3                   	retq   

0000000000801600 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801600:	55                   	push   %rbp
  801601:	48 89 e5             	mov    %rsp,%rbp
  801604:	53                   	push   %rbx
  801605:	48 83 ec 48          	sub    $0x48,%rsp
  801609:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80160c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80160f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801613:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801617:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80161b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801622:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801626:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80162a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80162e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801632:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801636:	4c 89 c3             	mov    %r8,%rbx
  801639:	cd 30                	int    $0x30
  80163b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80163f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801643:	74 3e                	je     801683 <syscall+0x83>
  801645:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80164a:	7e 37                	jle    801683 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80164c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801650:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801653:	49 89 d0             	mov    %rdx,%r8
  801656:	89 c1                	mov    %eax,%ecx
  801658:	48 ba c8 3b 80 00 00 	movabs $0x803bc8,%rdx
  80165f:	00 00 00 
  801662:	be 23 00 00 00       	mov    $0x23,%esi
  801667:	48 bf e5 3b 80 00 00 	movabs $0x803be5,%rdi
  80166e:	00 00 00 
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
  801676:	49 b9 08 33 80 00 00 	movabs $0x803308,%r9
  80167d:	00 00 00 
  801680:	41 ff d1             	callq  *%r9

	return ret;
  801683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801687:	48 83 c4 48          	add    $0x48,%rsp
  80168b:	5b                   	pop    %rbx
  80168c:	5d                   	pop    %rbp
  80168d:	c3                   	retq   

000000000080168e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80168e:	55                   	push   %rbp
  80168f:	48 89 e5             	mov    %rsp,%rbp
  801692:	48 83 ec 20          	sub    $0x20,%rsp
  801696:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80169e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ad:	00 
  8016ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ba:	48 89 d1             	mov    %rdx,%rcx
  8016bd:	48 89 c2             	mov    %rax,%rdx
  8016c0:	be 00 00 00 00       	mov    $0x0,%esi
  8016c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ca:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  8016d1:	00 00 00 
  8016d4:	ff d0                	callq  *%rax
}
  8016d6:	c9                   	leaveq 
  8016d7:	c3                   	retq   

00000000008016d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d8:	55                   	push   %rbp
  8016d9:	48 89 e5             	mov    %rsp,%rbp
  8016dc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016e0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e7:	00 
  8016e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fe:	be 00 00 00 00       	mov    $0x0,%esi
  801703:	bf 01 00 00 00       	mov    $0x1,%edi
  801708:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  80170f:	00 00 00 
  801712:	ff d0                	callq  *%rax
}
  801714:	c9                   	leaveq 
  801715:	c3                   	retq   

0000000000801716 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801716:	55                   	push   %rbp
  801717:	48 89 e5             	mov    %rsp,%rbp
  80171a:	48 83 ec 10          	sub    $0x10,%rsp
  80171e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801724:	48 98                	cltq   
  801726:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172d:	00 
  80172e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801734:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173f:	48 89 c2             	mov    %rax,%rdx
  801742:	be 01 00 00 00       	mov    $0x1,%esi
  801747:	bf 03 00 00 00       	mov    $0x3,%edi
  80174c:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  801753:	00 00 00 
  801756:	ff d0                	callq  *%rax
}
  801758:	c9                   	leaveq 
  801759:	c3                   	retq   

000000000080175a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
  80175e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801762:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801769:	00 
  80176a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801770:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801776:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	be 00 00 00 00       	mov    $0x0,%esi
  801785:	bf 02 00 00 00       	mov    $0x2,%edi
  80178a:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  801791:	00 00 00 
  801794:	ff d0                	callq  *%rax
}
  801796:	c9                   	leaveq 
  801797:	c3                   	retq   

0000000000801798 <sys_yield>:

void
sys_yield(void)
{
  801798:	55                   	push   %rbp
  801799:	48 89 e5             	mov    %rsp,%rbp
  80179c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017a7:	00 
  8017a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	be 00 00 00 00       	mov    $0x0,%esi
  8017c3:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017c8:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  8017cf:	00 00 00 
  8017d2:	ff d0                	callq  *%rax
}
  8017d4:	c9                   	leaveq 
  8017d5:	c3                   	retq   

00000000008017d6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017d6:	55                   	push   %rbp
  8017d7:	48 89 e5             	mov    %rsp,%rbp
  8017da:	48 83 ec 20          	sub    $0x20,%rsp
  8017de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017e5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017eb:	48 63 c8             	movslq %eax,%rcx
  8017ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f5:	48 98                	cltq   
  8017f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fe:	00 
  8017ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801805:	49 89 c8             	mov    %rcx,%r8
  801808:	48 89 d1             	mov    %rdx,%rcx
  80180b:	48 89 c2             	mov    %rax,%rdx
  80180e:	be 01 00 00 00       	mov    $0x1,%esi
  801813:	bf 04 00 00 00       	mov    $0x4,%edi
  801818:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  80181f:	00 00 00 
  801822:	ff d0                	callq  *%rax
}
  801824:	c9                   	leaveq 
  801825:	c3                   	retq   

0000000000801826 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801826:	55                   	push   %rbp
  801827:	48 89 e5             	mov    %rsp,%rbp
  80182a:	48 83 ec 30          	sub    $0x30,%rsp
  80182e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801831:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801835:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801838:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80183c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801840:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801843:	48 63 c8             	movslq %eax,%rcx
  801846:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80184a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80184d:	48 63 f0             	movslq %eax,%rsi
  801850:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801854:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801857:	48 98                	cltq   
  801859:	48 89 0c 24          	mov    %rcx,(%rsp)
  80185d:	49 89 f9             	mov    %rdi,%r9
  801860:	49 89 f0             	mov    %rsi,%r8
  801863:	48 89 d1             	mov    %rdx,%rcx
  801866:	48 89 c2             	mov    %rax,%rdx
  801869:	be 01 00 00 00       	mov    $0x1,%esi
  80186e:	bf 05 00 00 00       	mov    $0x5,%edi
  801873:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  80187a:	00 00 00 
  80187d:	ff d0                	callq  *%rax
}
  80187f:	c9                   	leaveq 
  801880:	c3                   	retq   

0000000000801881 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801881:	55                   	push   %rbp
  801882:	48 89 e5             	mov    %rsp,%rbp
  801885:	48 83 ec 20          	sub    $0x20,%rsp
  801889:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
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
  8018b8:	bf 06 00 00 00       	mov    $0x6,%edi
  8018bd:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  8018c4:	00 00 00 
  8018c7:	ff d0                	callq  *%rax
}
  8018c9:	c9                   	leaveq 
  8018ca:	c3                   	retq   

00000000008018cb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	48 83 ec 10          	sub    $0x10,%rsp
  8018d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018dc:	48 63 d0             	movslq %eax,%rdx
  8018df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e2:	48 98                	cltq   
  8018e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018eb:	00 
  8018ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f8:	48 89 d1             	mov    %rdx,%rcx
  8018fb:	48 89 c2             	mov    %rax,%rdx
  8018fe:	be 01 00 00 00       	mov    $0x1,%esi
  801903:	bf 08 00 00 00       	mov    $0x8,%edi
  801908:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  80190f:	00 00 00 
  801912:	ff d0                	callq  *%rax
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 20          	sub    $0x20,%rsp
  80191e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801921:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801925:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192c:	48 98                	cltq   
  80192e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801935:	00 
  801936:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801942:	48 89 d1             	mov    %rdx,%rcx
  801945:	48 89 c2             	mov    %rax,%rdx
  801948:	be 01 00 00 00       	mov    $0x1,%esi
  80194d:	bf 09 00 00 00       	mov    $0x9,%edi
  801952:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
}
  80195e:	c9                   	leaveq 
  80195f:	c3                   	retq   

0000000000801960 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801960:	55                   	push   %rbp
  801961:	48 89 e5             	mov    %rsp,%rbp
  801964:	48 83 ec 20          	sub    $0x20,%rsp
  801968:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80196f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801976:	48 98                	cltq   
  801978:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197f:	00 
  801980:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801986:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198c:	48 89 d1             	mov    %rdx,%rcx
  80198f:	48 89 c2             	mov    %rax,%rdx
  801992:	be 01 00 00 00       	mov    $0x1,%esi
  801997:	bf 0a 00 00 00       	mov    $0xa,%edi
  80199c:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  8019a3:	00 00 00 
  8019a6:	ff d0                	callq  *%rax
}
  8019a8:	c9                   	leaveq 
  8019a9:	c3                   	retq   

00000000008019aa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019aa:	55                   	push   %rbp
  8019ab:	48 89 e5             	mov    %rsp,%rbp
  8019ae:	48 83 ec 20          	sub    $0x20,%rsp
  8019b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019bd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c3:	48 63 f0             	movslq %eax,%rsi
  8019c6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cd:	48 98                	cltq   
  8019cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019da:	00 
  8019db:	49 89 f1             	mov    %rsi,%r9
  8019de:	49 89 c8             	mov    %rcx,%r8
  8019e1:	48 89 d1             	mov    %rdx,%rcx
  8019e4:	48 89 c2             	mov    %rax,%rdx
  8019e7:	be 00 00 00 00       	mov    $0x0,%esi
  8019ec:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019f1:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  8019f8:	00 00 00 
  8019fb:	ff d0                	callq  *%rax
}
  8019fd:	c9                   	leaveq 
  8019fe:	c3                   	retq   

00000000008019ff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019ff:	55                   	push   %rbp
  801a00:	48 89 e5             	mov    %rsp,%rbp
  801a03:	48 83 ec 10          	sub    $0x10,%rsp
  801a07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a16:	00 
  801a17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a23:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a28:	48 89 c2             	mov    %rax,%rdx
  801a2b:	be 01 00 00 00       	mov    $0x1,%esi
  801a30:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a35:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  801a3c:	00 00 00 
  801a3f:	ff d0                	callq  *%rax
}
  801a41:	c9                   	leaveq 
  801a42:	c3                   	retq   

0000000000801a43 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801a43:	55                   	push   %rbp
  801a44:	48 89 e5             	mov    %rsp,%rbp
  801a47:	48 83 ec 08          	sub    $0x8,%rsp
  801a4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a4f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a53:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a5a:	ff ff ff 
  801a5d:	48 01 d0             	add    %rdx,%rax
  801a60:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a64:	c9                   	leaveq 
  801a65:	c3                   	retq   

0000000000801a66 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a66:	55                   	push   %rbp
  801a67:	48 89 e5             	mov    %rsp,%rbp
  801a6a:	48 83 ec 08          	sub    $0x8,%rsp
  801a6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a76:	48 89 c7             	mov    %rax,%rdi
  801a79:	48 b8 43 1a 80 00 00 	movabs $0x801a43,%rax
  801a80:	00 00 00 
  801a83:	ff d0                	callq  *%rax
  801a85:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a8b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a8f:	c9                   	leaveq 
  801a90:	c3                   	retq   

0000000000801a91 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a91:	55                   	push   %rbp
  801a92:	48 89 e5             	mov    %rsp,%rbp
  801a95:	48 83 ec 18          	sub    $0x18,%rsp
  801a99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801aa4:	eb 6b                	jmp    801b11 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa9:	48 98                	cltq   
  801aab:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ab1:	48 c1 e0 0c          	shl    $0xc,%rax
  801ab5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ab9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801abd:	48 c1 e8 15          	shr    $0x15,%rax
  801ac1:	48 89 c2             	mov    %rax,%rdx
  801ac4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801acb:	01 00 00 
  801ace:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ad2:	83 e0 01             	and    $0x1,%eax
  801ad5:	48 85 c0             	test   %rax,%rax
  801ad8:	74 21                	je     801afb <fd_alloc+0x6a>
  801ada:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ade:	48 c1 e8 0c          	shr    $0xc,%rax
  801ae2:	48 89 c2             	mov    %rax,%rdx
  801ae5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801aec:	01 00 00 
  801aef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801af3:	83 e0 01             	and    $0x1,%eax
  801af6:	48 85 c0             	test   %rax,%rax
  801af9:	75 12                	jne    801b0d <fd_alloc+0x7c>
			*fd_store = fd;
  801afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b03:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801b06:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0b:	eb 1a                	jmp    801b27 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b0d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b11:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801b15:	7e 8f                	jle    801aa6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b1b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801b22:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801b27:	c9                   	leaveq 
  801b28:	c3                   	retq   

0000000000801b29 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b29:	55                   	push   %rbp
  801b2a:	48 89 e5             	mov    %rsp,%rbp
  801b2d:	48 83 ec 20          	sub    $0x20,%rsp
  801b31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b3c:	78 06                	js     801b44 <fd_lookup+0x1b>
  801b3e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801b42:	7e 07                	jle    801b4b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b49:	eb 6c                	jmp    801bb7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801b4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b4e:	48 98                	cltq   
  801b50:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b56:	48 c1 e0 0c          	shl    $0xc,%rax
  801b5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801b5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b62:	48 c1 e8 15          	shr    $0x15,%rax
  801b66:	48 89 c2             	mov    %rax,%rdx
  801b69:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b70:	01 00 00 
  801b73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b77:	83 e0 01             	and    $0x1,%eax
  801b7a:	48 85 c0             	test   %rax,%rax
  801b7d:	74 21                	je     801ba0 <fd_lookup+0x77>
  801b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b83:	48 c1 e8 0c          	shr    $0xc,%rax
  801b87:	48 89 c2             	mov    %rax,%rdx
  801b8a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b91:	01 00 00 
  801b94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b98:	83 e0 01             	and    $0x1,%eax
  801b9b:	48 85 c0             	test   %rax,%rax
  801b9e:	75 07                	jne    801ba7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ba0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba5:	eb 10                	jmp    801bb7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ba7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801baf:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb7:	c9                   	leaveq 
  801bb8:	c3                   	retq   

0000000000801bb9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801bb9:	55                   	push   %rbp
  801bba:	48 89 e5             	mov    %rsp,%rbp
  801bbd:	48 83 ec 30          	sub    $0x30,%rsp
  801bc1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bc5:	89 f0                	mov    %esi,%eax
  801bc7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bce:	48 89 c7             	mov    %rax,%rdi
  801bd1:	48 b8 43 1a 80 00 00 	movabs $0x801a43,%rax
  801bd8:	00 00 00 
  801bdb:	ff d0                	callq  *%rax
  801bdd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801be1:	48 89 d6             	mov    %rdx,%rsi
  801be4:	89 c7                	mov    %eax,%edi
  801be6:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801bed:	00 00 00 
  801bf0:	ff d0                	callq  *%rax
  801bf2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bf5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bf9:	78 0a                	js     801c05 <fd_close+0x4c>
	    || fd != fd2)
  801bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bff:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801c03:	74 12                	je     801c17 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801c05:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801c09:	74 05                	je     801c10 <fd_close+0x57>
  801c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0e:	eb 05                	jmp    801c15 <fd_close+0x5c>
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
  801c15:	eb 69                	jmp    801c80 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c1b:	8b 00                	mov    (%rax),%eax
  801c1d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c21:	48 89 d6             	mov    %rdx,%rsi
  801c24:	89 c7                	mov    %eax,%edi
  801c26:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
  801c32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c39:	78 2a                	js     801c65 <fd_close+0xac>
		if (dev->dev_close)
  801c3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c43:	48 85 c0             	test   %rax,%rax
  801c46:	74 16                	je     801c5e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801c48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c4c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c50:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c54:	48 89 d7             	mov    %rdx,%rdi
  801c57:	ff d0                	callq  *%rax
  801c59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c5c:	eb 07                	jmp    801c65 <fd_close+0xac>
		else
			r = 0;
  801c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c69:	48 89 c6             	mov    %rax,%rsi
  801c6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c71:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	callq  *%rax
	return r;
  801c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 20          	sub    $0x20,%rsp
  801c8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c98:	eb 41                	jmp    801cdb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c9a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ca1:	00 00 00 
  801ca4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ca7:	48 63 d2             	movslq %edx,%rdx
  801caa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cae:	8b 00                	mov    (%rax),%eax
  801cb0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801cb3:	75 22                	jne    801cd7 <dev_lookup+0x55>
			*dev = devtab[i];
  801cb5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801cbc:	00 00 00 
  801cbf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cc2:	48 63 d2             	movslq %edx,%rdx
  801cc5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801cc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ccd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd5:	eb 60                	jmp    801d37 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801cd7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cdb:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ce2:	00 00 00 
  801ce5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ce8:	48 63 d2             	movslq %edx,%rdx
  801ceb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cef:	48 85 c0             	test   %rax,%rax
  801cf2:	75 a6                	jne    801c9a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801cf4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801cfb:	00 00 00 
  801cfe:	48 8b 00             	mov    (%rax),%rax
  801d01:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801d07:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d0a:	89 c6                	mov    %eax,%esi
  801d0c:	48 bf f8 3b 80 00 00 	movabs $0x803bf8,%rdi
  801d13:	00 00 00 
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1b:	48 b9 df 02 80 00 00 	movabs $0x8002df,%rcx
  801d22:	00 00 00 
  801d25:	ff d1                	callq  *%rcx
	*dev = 0;
  801d27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d2b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801d32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d37:	c9                   	leaveq 
  801d38:	c3                   	retq   

0000000000801d39 <close>:

int
close(int fdnum)
{
  801d39:	55                   	push   %rbp
  801d3a:	48 89 e5             	mov    %rsp,%rbp
  801d3d:	48 83 ec 20          	sub    $0x20,%rsp
  801d41:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d4b:	48 89 d6             	mov    %rdx,%rsi
  801d4e:	89 c7                	mov    %eax,%edi
  801d50:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	callq  *%rax
  801d5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d63:	79 05                	jns    801d6a <close+0x31>
		return r;
  801d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d68:	eb 18                	jmp    801d82 <close+0x49>
	else
		return fd_close(fd, 1);
  801d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6e:	be 01 00 00 00       	mov    $0x1,%esi
  801d73:	48 89 c7             	mov    %rax,%rdi
  801d76:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	callq  *%rax
}
  801d82:	c9                   	leaveq 
  801d83:	c3                   	retq   

0000000000801d84 <close_all>:

void
close_all(void)
{
  801d84:	55                   	push   %rbp
  801d85:	48 89 e5             	mov    %rsp,%rbp
  801d88:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d93:	eb 15                	jmp    801daa <close_all+0x26>
		close(i);
  801d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d98:	89 c7                	mov    %eax,%edi
  801d9a:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  801da1:	00 00 00 
  801da4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801da6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801daa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dae:	7e e5                	jle    801d95 <close_all+0x11>
		close(i);
}
  801db0:	c9                   	leaveq 
  801db1:	c3                   	retq   

0000000000801db2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801db2:	55                   	push   %rbp
  801db3:	48 89 e5             	mov    %rsp,%rbp
  801db6:	48 83 ec 40          	sub    $0x40,%rsp
  801dba:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801dbd:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801dc0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801dc4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801dc7:	48 89 d6             	mov    %rdx,%rsi
  801dca:	89 c7                	mov    %eax,%edi
  801dcc:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801dd3:	00 00 00 
  801dd6:	ff d0                	callq  *%rax
  801dd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ddb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ddf:	79 08                	jns    801de9 <dup+0x37>
		return r;
  801de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de4:	e9 70 01 00 00       	jmpq   801f59 <dup+0x1a7>
	close(newfdnum);
  801de9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801dec:	89 c7                	mov    %eax,%edi
  801dee:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  801df5:	00 00 00 
  801df8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801dfa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801dfd:	48 98                	cltq   
  801dff:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e05:	48 c1 e0 0c          	shl    $0xc,%rax
  801e09:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801e0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e11:	48 89 c7             	mov    %rax,%rdi
  801e14:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
  801e20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e28:	48 89 c7             	mov    %rax,%rdi
  801e2b:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  801e32:	00 00 00 
  801e35:	ff d0                	callq  *%rax
  801e37:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e3f:	48 c1 e8 15          	shr    $0x15,%rax
  801e43:	48 89 c2             	mov    %rax,%rdx
  801e46:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e4d:	01 00 00 
  801e50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e54:	83 e0 01             	and    $0x1,%eax
  801e57:	48 85 c0             	test   %rax,%rax
  801e5a:	74 73                	je     801ecf <dup+0x11d>
  801e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e60:	48 c1 e8 0c          	shr    $0xc,%rax
  801e64:	48 89 c2             	mov    %rax,%rdx
  801e67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e6e:	01 00 00 
  801e71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e75:	83 e0 01             	and    $0x1,%eax
  801e78:	48 85 c0             	test   %rax,%rax
  801e7b:	74 52                	je     801ecf <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e81:	48 c1 e8 0c          	shr    $0xc,%rax
  801e85:	48 89 c2             	mov    %rax,%rdx
  801e88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e8f:	01 00 00 
  801e92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e96:	25 07 0e 00 00       	and    $0xe07,%eax
  801e9b:	89 c1                	mov    %eax,%ecx
  801e9d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801ea1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea5:	41 89 c8             	mov    %ecx,%r8d
  801ea8:	48 89 d1             	mov    %rdx,%rcx
  801eab:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb0:	48 89 c6             	mov    %rax,%rsi
  801eb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb8:	48 b8 26 18 80 00 00 	movabs $0x801826,%rax
  801ebf:	00 00 00 
  801ec2:	ff d0                	callq  *%rax
  801ec4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ecb:	79 02                	jns    801ecf <dup+0x11d>
			goto err;
  801ecd:	eb 57                	jmp    801f26 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ecf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed3:	48 c1 e8 0c          	shr    $0xc,%rax
  801ed7:	48 89 c2             	mov    %rax,%rdx
  801eda:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ee1:	01 00 00 
  801ee4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee8:	25 07 0e 00 00       	and    $0xe07,%eax
  801eed:	89 c1                	mov    %eax,%ecx
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef7:	41 89 c8             	mov    %ecx,%r8d
  801efa:	48 89 d1             	mov    %rdx,%rcx
  801efd:	ba 00 00 00 00       	mov    $0x0,%edx
  801f02:	48 89 c6             	mov    %rax,%rsi
  801f05:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0a:	48 b8 26 18 80 00 00 	movabs $0x801826,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
  801f16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f1d:	79 02                	jns    801f21 <dup+0x16f>
		goto err;
  801f1f:	eb 05                	jmp    801f26 <dup+0x174>

	return newfdnum;
  801f21:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f24:	eb 33                	jmp    801f59 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2a:	48 89 c6             	mov    %rax,%rsi
  801f2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f32:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801f3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f42:	48 89 c6             	mov    %rax,%rsi
  801f45:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4a:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801f51:	00 00 00 
  801f54:	ff d0                	callq  *%rax
	return r;
  801f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f59:	c9                   	leaveq 
  801f5a:	c3                   	retq   

0000000000801f5b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f5b:	55                   	push   %rbp
  801f5c:	48 89 e5             	mov    %rsp,%rbp
  801f5f:	48 83 ec 40          	sub    $0x40,%rsp
  801f63:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f6a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f6e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f72:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f75:	48 89 d6             	mov    %rdx,%rsi
  801f78:	89 c7                	mov    %eax,%edi
  801f7a:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
  801f86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f8d:	78 24                	js     801fb3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f93:	8b 00                	mov    (%rax),%eax
  801f95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f99:	48 89 d6             	mov    %rdx,%rsi
  801f9c:	89 c7                	mov    %eax,%edi
  801f9e:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	callq  *%rax
  801faa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb1:	79 05                	jns    801fb8 <read+0x5d>
		return r;
  801fb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb6:	eb 76                	jmp    80202e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbc:	8b 40 08             	mov    0x8(%rax),%eax
  801fbf:	83 e0 03             	and    $0x3,%eax
  801fc2:	83 f8 01             	cmp    $0x1,%eax
  801fc5:	75 3a                	jne    802001 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801fc7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fce:	00 00 00 
  801fd1:	48 8b 00             	mov    (%rax),%rax
  801fd4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fda:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801fdd:	89 c6                	mov    %eax,%esi
  801fdf:	48 bf 17 3c 80 00 00 	movabs $0x803c17,%rdi
  801fe6:	00 00 00 
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	48 b9 df 02 80 00 00 	movabs $0x8002df,%rcx
  801ff5:	00 00 00 
  801ff8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801ffa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fff:	eb 2d                	jmp    80202e <read+0xd3>
	}
	if (!dev->dev_read)
  802001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802005:	48 8b 40 10          	mov    0x10(%rax),%rax
  802009:	48 85 c0             	test   %rax,%rax
  80200c:	75 07                	jne    802015 <read+0xba>
		return -E_NOT_SUPP;
  80200e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802013:	eb 19                	jmp    80202e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802019:	48 8b 40 10          	mov    0x10(%rax),%rax
  80201d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802021:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802025:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802029:	48 89 cf             	mov    %rcx,%rdi
  80202c:	ff d0                	callq  *%rax
}
  80202e:	c9                   	leaveq 
  80202f:	c3                   	retq   

0000000000802030 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802030:	55                   	push   %rbp
  802031:	48 89 e5             	mov    %rsp,%rbp
  802034:	48 83 ec 30          	sub    $0x30,%rsp
  802038:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80203b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80203f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802043:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80204a:	eb 49                	jmp    802095 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80204c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204f:	48 98                	cltq   
  802051:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802055:	48 29 c2             	sub    %rax,%rdx
  802058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205b:	48 63 c8             	movslq %eax,%rcx
  80205e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802062:	48 01 c1             	add    %rax,%rcx
  802065:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802068:	48 89 ce             	mov    %rcx,%rsi
  80206b:	89 c7                	mov    %eax,%edi
  80206d:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
  802079:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80207c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802080:	79 05                	jns    802087 <readn+0x57>
			return m;
  802082:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802085:	eb 1c                	jmp    8020a3 <readn+0x73>
		if (m == 0)
  802087:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80208b:	75 02                	jne    80208f <readn+0x5f>
			break;
  80208d:	eb 11                	jmp    8020a0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80208f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802092:	01 45 fc             	add    %eax,-0x4(%rbp)
  802095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802098:	48 98                	cltq   
  80209a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80209e:	72 ac                	jb     80204c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8020a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020a3:	c9                   	leaveq 
  8020a4:	c3                   	retq   

00000000008020a5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8020a5:	55                   	push   %rbp
  8020a6:	48 89 e5             	mov    %rsp,%rbp
  8020a9:	48 83 ec 40          	sub    $0x40,%rsp
  8020ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020b0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8020b4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020bf:	48 89 d6             	mov    %rdx,%rsi
  8020c2:	89 c7                	mov    %eax,%edi
  8020c4:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  8020cb:	00 00 00 
  8020ce:	ff d0                	callq  *%rax
  8020d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020d7:	78 24                	js     8020fd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dd:	8b 00                	mov    (%rax),%eax
  8020df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020e3:	48 89 d6             	mov    %rdx,%rsi
  8020e6:	89 c7                	mov    %eax,%edi
  8020e8:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	callq  *%rax
  8020f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fb:	79 05                	jns    802102 <write+0x5d>
		return r;
  8020fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802100:	eb 75                	jmp    802177 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802106:	8b 40 08             	mov    0x8(%rax),%eax
  802109:	83 e0 03             	and    $0x3,%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	75 3a                	jne    80214a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802110:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802117:	00 00 00 
  80211a:	48 8b 00             	mov    (%rax),%rax
  80211d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802123:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802126:	89 c6                	mov    %eax,%esi
  802128:	48 bf 33 3c 80 00 00 	movabs $0x803c33,%rdi
  80212f:	00 00 00 
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	48 b9 df 02 80 00 00 	movabs $0x8002df,%rcx
  80213e:	00 00 00 
  802141:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802143:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802148:	eb 2d                	jmp    802177 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80214a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802152:	48 85 c0             	test   %rax,%rax
  802155:	75 07                	jne    80215e <write+0xb9>
		return -E_NOT_SUPP;
  802157:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80215c:	eb 19                	jmp    802177 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80215e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802162:	48 8b 40 18          	mov    0x18(%rax),%rax
  802166:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80216a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80216e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802172:	48 89 cf             	mov    %rcx,%rdi
  802175:	ff d0                	callq  *%rax
}
  802177:	c9                   	leaveq 
  802178:	c3                   	retq   

0000000000802179 <seek>:

int
seek(int fdnum, off_t offset)
{
  802179:	55                   	push   %rbp
  80217a:	48 89 e5             	mov    %rsp,%rbp
  80217d:	48 83 ec 18          	sub    $0x18,%rsp
  802181:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802184:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802187:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80218b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80218e:	48 89 d6             	mov    %rdx,%rsi
  802191:	89 c7                	mov    %eax,%edi
  802193:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	callq  *%rax
  80219f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a6:	79 05                	jns    8021ad <seek+0x34>
		return r;
  8021a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ab:	eb 0f                	jmp    8021bc <seek+0x43>
	fd->fd_offset = offset;
  8021ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021b4:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bc:	c9                   	leaveq 
  8021bd:	c3                   	retq   

00000000008021be <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021be:	55                   	push   %rbp
  8021bf:	48 89 e5             	mov    %rsp,%rbp
  8021c2:	48 83 ec 30          	sub    $0x30,%rsp
  8021c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021c9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021d3:	48 89 d6             	mov    %rdx,%rsi
  8021d6:	89 c7                	mov    %eax,%edi
  8021d8:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	callq  *%rax
  8021e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021eb:	78 24                	js     802211 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f1:	8b 00                	mov    (%rax),%eax
  8021f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021f7:	48 89 d6             	mov    %rdx,%rsi
  8021fa:	89 c7                	mov    %eax,%edi
  8021fc:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802203:	00 00 00 
  802206:	ff d0                	callq  *%rax
  802208:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80220f:	79 05                	jns    802216 <ftruncate+0x58>
		return r;
  802211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802214:	eb 72                	jmp    802288 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221a:	8b 40 08             	mov    0x8(%rax),%eax
  80221d:	83 e0 03             	and    $0x3,%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	75 3a                	jne    80225e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802224:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80222b:	00 00 00 
  80222e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802231:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802237:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80223a:	89 c6                	mov    %eax,%esi
  80223c:	48 bf 50 3c 80 00 00 	movabs $0x803c50,%rdi
  802243:	00 00 00 
  802246:	b8 00 00 00 00       	mov    $0x0,%eax
  80224b:	48 b9 df 02 80 00 00 	movabs $0x8002df,%rcx
  802252:	00 00 00 
  802255:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802257:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80225c:	eb 2a                	jmp    802288 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80225e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802262:	48 8b 40 30          	mov    0x30(%rax),%rax
  802266:	48 85 c0             	test   %rax,%rax
  802269:	75 07                	jne    802272 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80226b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802270:	eb 16                	jmp    802288 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802276:	48 8b 40 30          	mov    0x30(%rax),%rax
  80227a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802281:	89 ce                	mov    %ecx,%esi
  802283:	48 89 d7             	mov    %rdx,%rdi
  802286:	ff d0                	callq  *%rax
}
  802288:	c9                   	leaveq 
  802289:	c3                   	retq   

000000000080228a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80228a:	55                   	push   %rbp
  80228b:	48 89 e5             	mov    %rsp,%rbp
  80228e:	48 83 ec 30          	sub    $0x30,%rsp
  802292:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802295:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802299:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80229d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022a0:	48 89 d6             	mov    %rdx,%rsi
  8022a3:	89 c7                	mov    %eax,%edi
  8022a5:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
  8022b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b8:	78 24                	js     8022de <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022be:	8b 00                	mov    (%rax),%eax
  8022c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022c4:	48 89 d6             	mov    %rdx,%rsi
  8022c7:	89 c7                	mov    %eax,%edi
  8022c9:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022dc:	79 05                	jns    8022e3 <fstat+0x59>
		return r;
  8022de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e1:	eb 5e                	jmp    802341 <fstat+0xb7>
	if (!dev->dev_stat)
  8022e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022eb:	48 85 c0             	test   %rax,%rax
  8022ee:	75 07                	jne    8022f7 <fstat+0x6d>
		return -E_NOT_SUPP;
  8022f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022f5:	eb 4a                	jmp    802341 <fstat+0xb7>
	stat->st_name[0] = 0;
  8022f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022fb:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8022fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802302:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802309:	00 00 00 
	stat->st_isdir = 0;
  80230c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802310:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802317:	00 00 00 
	stat->st_dev = dev;
  80231a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80231e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802322:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802331:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802335:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802339:	48 89 ce             	mov    %rcx,%rsi
  80233c:	48 89 d7             	mov    %rdx,%rdi
  80233f:	ff d0                	callq  *%rax
}
  802341:	c9                   	leaveq 
  802342:	c3                   	retq   

0000000000802343 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802343:	55                   	push   %rbp
  802344:	48 89 e5             	mov    %rsp,%rbp
  802347:	48 83 ec 20          	sub    $0x20,%rsp
  80234b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80234f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802357:	be 00 00 00 00       	mov    $0x0,%esi
  80235c:	48 89 c7             	mov    %rax,%rdi
  80235f:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  802366:	00 00 00 
  802369:	ff d0                	callq  *%rax
  80236b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802372:	79 05                	jns    802379 <stat+0x36>
		return fd;
  802374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802377:	eb 2f                	jmp    8023a8 <stat+0x65>
	r = fstat(fd, stat);
  802379:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80237d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802380:	48 89 d6             	mov    %rdx,%rsi
  802383:	89 c7                	mov    %eax,%edi
  802385:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  80238c:	00 00 00 
  80238f:	ff d0                	callq  *%rax
  802391:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802397:	89 c7                	mov    %eax,%edi
  802399:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  8023a0:	00 00 00 
  8023a3:	ff d0                	callq  *%rax
	return r;
  8023a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8023a8:	c9                   	leaveq 
  8023a9:	c3                   	retq   

00000000008023aa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023aa:	55                   	push   %rbp
  8023ab:	48 89 e5             	mov    %rsp,%rbp
  8023ae:	48 83 ec 10          	sub    $0x10,%rsp
  8023b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8023b9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023c0:	00 00 00 
  8023c3:	8b 00                	mov    (%rax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	75 1d                	jne    8023e6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8023ce:	48 b8 75 35 80 00 00 	movabs $0x803575,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax
  8023da:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8023e1:	00 00 00 
  8023e4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023e6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023ed:	00 00 00 
  8023f0:	8b 00                	mov    (%rax),%eax
  8023f2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8023f5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8023fa:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802401:	00 00 00 
  802404:	89 c7                	mov    %eax,%edi
  802406:	48 b8 dd 34 80 00 00 	movabs $0x8034dd,%rax
  80240d:	00 00 00 
  802410:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802416:	ba 00 00 00 00       	mov    $0x0,%edx
  80241b:	48 89 c6             	mov    %rax,%rsi
  80241e:	bf 00 00 00 00       	mov    $0x0,%edi
  802423:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  80242a:	00 00 00 
  80242d:	ff d0                	callq  *%rax
}
  80242f:	c9                   	leaveq 
  802430:	c3                   	retq   

0000000000802431 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802431:	55                   	push   %rbp
  802432:	48 89 e5             	mov    %rsp,%rbp
  802435:	48 83 ec 20          	sub    $0x20,%rsp
  802439:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80243d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802444:	48 89 c7             	mov    %rax,%rdi
  802447:	48 b8 3b 0e 80 00 00 	movabs $0x800e3b,%rax
  80244e:	00 00 00 
  802451:	ff d0                	callq  *%rax
  802453:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802458:	7e 0a                	jle    802464 <open+0x33>
		return -E_BAD_PATH;
  80245a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80245f:	e9 a5 00 00 00       	jmpq   802509 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802464:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802468:	48 89 c7             	mov    %rax,%rdi
  80246b:	48 b8 91 1a 80 00 00 	movabs $0x801a91,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
  802477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247e:	79 08                	jns    802488 <open+0x57>
		return r;
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	e9 81 00 00 00       	jmpq   802509 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248c:	48 89 c6             	mov    %rax,%rsi
  80248f:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802496:	00 00 00 
  802499:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  8024a0:	00 00 00 
  8024a3:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8024a5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024ac:	00 00 00 
  8024af:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8024b2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8024b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bc:	48 89 c6             	mov    %rax,%rsi
  8024bf:	bf 01 00 00 00       	mov    $0x1,%edi
  8024c4:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  8024cb:	00 00 00 
  8024ce:	ff d0                	callq  *%rax
  8024d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d7:	79 1d                	jns    8024f6 <open+0xc5>
		fd_close(fd, 0);
  8024d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024dd:	be 00 00 00 00       	mov    $0x0,%esi
  8024e2:	48 89 c7             	mov    %rax,%rdi
  8024e5:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  8024ec:	00 00 00 
  8024ef:	ff d0                	callq  *%rax
		return r;
  8024f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f4:	eb 13                	jmp    802509 <open+0xd8>
	}

	return fd2num(fd);
  8024f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fa:	48 89 c7             	mov    %rax,%rdi
  8024fd:	48 b8 43 1a 80 00 00 	movabs $0x801a43,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802509:	c9                   	leaveq 
  80250a:	c3                   	retq   

000000000080250b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80250b:	55                   	push   %rbp
  80250c:	48 89 e5             	mov    %rsp,%rbp
  80250f:	48 83 ec 10          	sub    $0x10,%rsp
  802513:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80251b:	8b 50 0c             	mov    0xc(%rax),%edx
  80251e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802525:	00 00 00 
  802528:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80252a:	be 00 00 00 00       	mov    $0x0,%esi
  80252f:	bf 06 00 00 00       	mov    $0x6,%edi
  802534:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  80253b:	00 00 00 
  80253e:	ff d0                	callq  *%rax
}
  802540:	c9                   	leaveq 
  802541:	c3                   	retq   

0000000000802542 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802542:	55                   	push   %rbp
  802543:	48 89 e5             	mov    %rsp,%rbp
  802546:	48 83 ec 30          	sub    $0x30,%rsp
  80254a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80254e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802552:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255a:	8b 50 0c             	mov    0xc(%rax),%edx
  80255d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802564:	00 00 00 
  802567:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802569:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802570:	00 00 00 
  802573:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802577:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80257b:	be 00 00 00 00       	mov    $0x0,%esi
  802580:	bf 03 00 00 00       	mov    $0x3,%edi
  802585:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  80258c:	00 00 00 
  80258f:	ff d0                	callq  *%rax
  802591:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802594:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802598:	79 08                	jns    8025a2 <devfile_read+0x60>
		return r;
  80259a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80259d:	e9 a4 00 00 00       	jmpq   802646 <devfile_read+0x104>
	assert(r <= n);
  8025a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a5:	48 98                	cltq   
  8025a7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8025ab:	76 35                	jbe    8025e2 <devfile_read+0xa0>
  8025ad:	48 b9 7d 3c 80 00 00 	movabs $0x803c7d,%rcx
  8025b4:	00 00 00 
  8025b7:	48 ba 84 3c 80 00 00 	movabs $0x803c84,%rdx
  8025be:	00 00 00 
  8025c1:	be 84 00 00 00       	mov    $0x84,%esi
  8025c6:	48 bf 99 3c 80 00 00 	movabs $0x803c99,%rdi
  8025cd:	00 00 00 
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	49 b8 08 33 80 00 00 	movabs $0x803308,%r8
  8025dc:	00 00 00 
  8025df:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8025e2:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8025e9:	7e 35                	jle    802620 <devfile_read+0xde>
  8025eb:	48 b9 a4 3c 80 00 00 	movabs $0x803ca4,%rcx
  8025f2:	00 00 00 
  8025f5:	48 ba 84 3c 80 00 00 	movabs $0x803c84,%rdx
  8025fc:	00 00 00 
  8025ff:	be 85 00 00 00       	mov    $0x85,%esi
  802604:	48 bf 99 3c 80 00 00 	movabs $0x803c99,%rdi
  80260b:	00 00 00 
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
  802613:	49 b8 08 33 80 00 00 	movabs $0x803308,%r8
  80261a:	00 00 00 
  80261d:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802623:	48 63 d0             	movslq %eax,%rdx
  802626:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802631:	00 00 00 
  802634:	48 89 c7             	mov    %rax,%rdi
  802637:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
	return r;
  802643:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802646:	c9                   	leaveq 
  802647:	c3                   	retq   

0000000000802648 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802648:	55                   	push   %rbp
  802649:	48 89 e5             	mov    %rsp,%rbp
  80264c:	48 83 ec 30          	sub    $0x30,%rsp
  802650:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802654:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802658:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80265c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802660:	8b 50 0c             	mov    0xc(%rax),%edx
  802663:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80266a:	00 00 00 
  80266d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80266f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802676:	00 00 00 
  802679:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80267d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802681:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802688:	00 
  802689:	76 35                	jbe    8026c0 <devfile_write+0x78>
  80268b:	48 b9 b0 3c 80 00 00 	movabs $0x803cb0,%rcx
  802692:	00 00 00 
  802695:	48 ba 84 3c 80 00 00 	movabs $0x803c84,%rdx
  80269c:	00 00 00 
  80269f:	be 9e 00 00 00       	mov    $0x9e,%esi
  8026a4:	48 bf 99 3c 80 00 00 	movabs $0x803c99,%rdi
  8026ab:	00 00 00 
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b3:	49 b8 08 33 80 00 00 	movabs $0x803308,%r8
  8026ba:	00 00 00 
  8026bd:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8026c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026c8:	48 89 c6             	mov    %rax,%rsi
  8026cb:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8026d2:	00 00 00 
  8026d5:	48 b8 e2 12 80 00 00 	movabs $0x8012e2,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8026e1:	be 00 00 00 00       	mov    $0x0,%esi
  8026e6:	bf 04 00 00 00       	mov    $0x4,%edi
  8026eb:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  8026f2:	00 00 00 
  8026f5:	ff d0                	callq  *%rax
  8026f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fe:	79 05                	jns    802705 <devfile_write+0xbd>
		return r;
  802700:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802703:	eb 43                	jmp    802748 <devfile_write+0x100>
	assert(r <= n);
  802705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802708:	48 98                	cltq   
  80270a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80270e:	76 35                	jbe    802745 <devfile_write+0xfd>
  802710:	48 b9 7d 3c 80 00 00 	movabs $0x803c7d,%rcx
  802717:	00 00 00 
  80271a:	48 ba 84 3c 80 00 00 	movabs $0x803c84,%rdx
  802721:	00 00 00 
  802724:	be a2 00 00 00       	mov    $0xa2,%esi
  802729:	48 bf 99 3c 80 00 00 	movabs $0x803c99,%rdi
  802730:	00 00 00 
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	49 b8 08 33 80 00 00 	movabs $0x803308,%r8
  80273f:	00 00 00 
  802742:	41 ff d0             	callq  *%r8
	return r;
  802745:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802748:	c9                   	leaveq 
  802749:	c3                   	retq   

000000000080274a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80274a:	55                   	push   %rbp
  80274b:	48 89 e5             	mov    %rsp,%rbp
  80274e:	48 83 ec 20          	sub    $0x20,%rsp
  802752:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802756:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80275a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80275e:	8b 50 0c             	mov    0xc(%rax),%edx
  802761:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802768:	00 00 00 
  80276b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80276d:	be 00 00 00 00       	mov    $0x0,%esi
  802772:	bf 05 00 00 00       	mov    $0x5,%edi
  802777:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278a:	79 05                	jns    802791 <devfile_stat+0x47>
		return r;
  80278c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278f:	eb 56                	jmp    8027e7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802791:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802795:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80279c:	00 00 00 
  80279f:	48 89 c7             	mov    %rax,%rdi
  8027a2:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8027ae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027b5:	00 00 00 
  8027b8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027c8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027cf:	00 00 00 
  8027d2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8027d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027dc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e7:	c9                   	leaveq 
  8027e8:	c3                   	retq   

00000000008027e9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027e9:	55                   	push   %rbp
  8027ea:	48 89 e5             	mov    %rsp,%rbp
  8027ed:	48 83 ec 10          	sub    $0x10,%rsp
  8027f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027f5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027fc:	8b 50 0c             	mov    0xc(%rax),%edx
  8027ff:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802806:	00 00 00 
  802809:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80280b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802812:	00 00 00 
  802815:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802818:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80281b:	be 00 00 00 00       	mov    $0x0,%esi
  802820:	bf 02 00 00 00       	mov    $0x2,%edi
  802825:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  80282c:	00 00 00 
  80282f:	ff d0                	callq  *%rax
}
  802831:	c9                   	leaveq 
  802832:	c3                   	retq   

0000000000802833 <remove>:

// Delete a file
int
remove(const char *path)
{
  802833:	55                   	push   %rbp
  802834:	48 89 e5             	mov    %rsp,%rbp
  802837:	48 83 ec 10          	sub    $0x10,%rsp
  80283b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80283f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802843:	48 89 c7             	mov    %rax,%rdi
  802846:	48 b8 3b 0e 80 00 00 	movabs $0x800e3b,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
  802852:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802857:	7e 07                	jle    802860 <remove+0x2d>
		return -E_BAD_PATH;
  802859:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80285e:	eb 33                	jmp    802893 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802864:	48 89 c6             	mov    %rax,%rsi
  802867:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80286e:	00 00 00 
  802871:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80287d:	be 00 00 00 00       	mov    $0x0,%esi
  802882:	bf 07 00 00 00       	mov    $0x7,%edi
  802887:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  80288e:	00 00 00 
  802891:	ff d0                	callq  *%rax
}
  802893:	c9                   	leaveq 
  802894:	c3                   	retq   

0000000000802895 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802895:	55                   	push   %rbp
  802896:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802899:	be 00 00 00 00       	mov    $0x0,%esi
  80289e:	bf 08 00 00 00       	mov    $0x8,%edi
  8028a3:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
}
  8028af:	5d                   	pop    %rbp
  8028b0:	c3                   	retq   

00000000008028b1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8028b1:	55                   	push   %rbp
  8028b2:	48 89 e5             	mov    %rsp,%rbp
  8028b5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8028bc:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8028c3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8028ca:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028d1:	be 00 00 00 00       	mov    $0x0,%esi
  8028d6:	48 89 c7             	mov    %rax,%rdi
  8028d9:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax
  8028e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8028e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ec:	79 28                	jns    802916 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8028ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f1:	89 c6                	mov    %eax,%esi
  8028f3:	48 bf dd 3c 80 00 00 	movabs $0x803cdd,%rdi
  8028fa:	00 00 00 
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802902:	48 ba df 02 80 00 00 	movabs $0x8002df,%rdx
  802909:	00 00 00 
  80290c:	ff d2                	callq  *%rdx
		return fd_src;
  80290e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802911:	e9 74 01 00 00       	jmpq   802a8a <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802916:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80291d:	be 01 01 00 00       	mov    $0x101,%esi
  802922:	48 89 c7             	mov    %rax,%rdi
  802925:	48 b8 31 24 80 00 00 	movabs $0x802431,%rax
  80292c:	00 00 00 
  80292f:	ff d0                	callq  *%rax
  802931:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802934:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802938:	79 39                	jns    802973 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80293a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80293d:	89 c6                	mov    %eax,%esi
  80293f:	48 bf f3 3c 80 00 00 	movabs $0x803cf3,%rdi
  802946:	00 00 00 
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
  80294e:	48 ba df 02 80 00 00 	movabs $0x8002df,%rdx
  802955:	00 00 00 
  802958:	ff d2                	callq  *%rdx
		close(fd_src);
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	89 c7                	mov    %eax,%edi
  80295f:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
		return fd_dest;
  80296b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80296e:	e9 17 01 00 00       	jmpq   802a8a <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802973:	eb 74                	jmp    8029e9 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802975:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802978:	48 63 d0             	movslq %eax,%rdx
  80297b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802982:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802985:	48 89 ce             	mov    %rcx,%rsi
  802988:	89 c7                	mov    %eax,%edi
  80298a:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  802991:	00 00 00 
  802994:	ff d0                	callq  *%rax
  802996:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802999:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80299d:	79 4a                	jns    8029e9 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80299f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029a2:	89 c6                	mov    %eax,%esi
  8029a4:	48 bf 0d 3d 80 00 00 	movabs $0x803d0d,%rdi
  8029ab:	00 00 00 
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b3:	48 ba df 02 80 00 00 	movabs $0x8002df,%rdx
  8029ba:	00 00 00 
  8029bd:	ff d2                	callq  *%rdx
			close(fd_src);
  8029bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
			close(fd_dest);
  8029d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029d3:	89 c7                	mov    %eax,%edi
  8029d5:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  8029dc:	00 00 00 
  8029df:	ff d0                	callq  *%rax
			return write_size;
  8029e1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029e4:	e9 a1 00 00 00       	jmpq   802a8a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029e9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f3:	ba 00 02 00 00       	mov    $0x200,%edx
  8029f8:	48 89 ce             	mov    %rcx,%rsi
  8029fb:	89 c7                	mov    %eax,%edi
  8029fd:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  802a04:	00 00 00 
  802a07:	ff d0                	callq  *%rax
  802a09:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a10:	0f 8f 5f ff ff ff    	jg     802975 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a1a:	79 47                	jns    802a63 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802a1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a1f:	89 c6                	mov    %eax,%esi
  802a21:	48 bf 20 3d 80 00 00 	movabs $0x803d20,%rdi
  802a28:	00 00 00 
  802a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a30:	48 ba df 02 80 00 00 	movabs $0x8002df,%rdx
  802a37:	00 00 00 
  802a3a:	ff d2                	callq  *%rdx
		close(fd_src);
  802a3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3f:	89 c7                	mov    %eax,%edi
  802a41:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  802a48:	00 00 00 
  802a4b:	ff d0                	callq  *%rax
		close(fd_dest);
  802a4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
		return read_size;
  802a5e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a61:	eb 27                	jmp    802a8a <copy+0x1d9>
	}
	close(fd_src);
  802a63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a66:	89 c7                	mov    %eax,%edi
  802a68:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  802a6f:	00 00 00 
  802a72:	ff d0                	callq  *%rax
	close(fd_dest);
  802a74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a77:	89 c7                	mov    %eax,%edi
  802a79:	48 b8 39 1d 80 00 00 	movabs $0x801d39,%rax
  802a80:	00 00 00 
  802a83:	ff d0                	callq  *%rax
	return 0;
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802a8a:	c9                   	leaveq 
  802a8b:	c3                   	retq   

0000000000802a8c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a8c:	55                   	push   %rbp
  802a8d:	48 89 e5             	mov    %rsp,%rbp
  802a90:	53                   	push   %rbx
  802a91:	48 83 ec 38          	sub    $0x38,%rsp
  802a95:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a99:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a9d:	48 89 c7             	mov    %rax,%rdi
  802aa0:	48 b8 91 1a 80 00 00 	movabs $0x801a91,%rax
  802aa7:	00 00 00 
  802aaa:	ff d0                	callq  *%rax
  802aac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802aaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ab3:	0f 88 bf 01 00 00    	js     802c78 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802abd:	ba 07 04 00 00       	mov    $0x407,%edx
  802ac2:	48 89 c6             	mov    %rax,%rsi
  802ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aca:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
  802ad6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ad9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802add:	0f 88 95 01 00 00    	js     802c78 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ae3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ae7:	48 89 c7             	mov    %rax,%rdi
  802aea:	48 b8 91 1a 80 00 00 	movabs $0x801a91,%rax
  802af1:	00 00 00 
  802af4:	ff d0                	callq  *%rax
  802af6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802af9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802afd:	0f 88 5d 01 00 00    	js     802c60 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b07:	ba 07 04 00 00       	mov    $0x407,%edx
  802b0c:	48 89 c6             	mov    %rax,%rsi
  802b0f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b14:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	callq  *%rax
  802b20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b27:	0f 88 33 01 00 00    	js     802c60 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b31:	48 89 c7             	mov    %rax,%rdi
  802b34:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	callq  *%rax
  802b40:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b48:	ba 07 04 00 00       	mov    $0x407,%edx
  802b4d:	48 89 c6             	mov    %rax,%rsi
  802b50:	bf 00 00 00 00       	mov    $0x0,%edi
  802b55:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
  802b61:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b64:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b68:	79 05                	jns    802b6f <pipe+0xe3>
		goto err2;
  802b6a:	e9 d9 00 00 00       	jmpq   802c48 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b73:	48 89 c7             	mov    %rax,%rdi
  802b76:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
  802b82:	48 89 c2             	mov    %rax,%rdx
  802b85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b89:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b8f:	48 89 d1             	mov    %rdx,%rcx
  802b92:	ba 00 00 00 00       	mov    $0x0,%edx
  802b97:	48 89 c6             	mov    %rax,%rsi
  802b9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b9f:	48 b8 26 18 80 00 00 	movabs $0x801826,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
  802bab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bb2:	79 1b                	jns    802bcf <pipe+0x143>
		goto err3;
  802bb4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802bb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb9:	48 89 c6             	mov    %rax,%rsi
  802bbc:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc1:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  802bc8:	00 00 00 
  802bcb:	ff d0                	callq  *%rax
  802bcd:	eb 79                	jmp    802c48 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802bcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bd3:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802bda:	00 00 00 
  802bdd:	8b 12                	mov    (%rdx),%edx
  802bdf:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802be1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802be5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802bec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf0:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802bf7:	00 00 00 
  802bfa:	8b 12                	mov    (%rdx),%edx
  802bfc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802bfe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c02:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802c09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c0d:	48 89 c7             	mov    %rax,%rdi
  802c10:	48 b8 43 1a 80 00 00 	movabs $0x801a43,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	callq  *%rax
  802c1c:	89 c2                	mov    %eax,%edx
  802c1e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c22:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802c24:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c28:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802c2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c30:	48 89 c7             	mov    %rax,%rdi
  802c33:	48 b8 43 1a 80 00 00 	movabs $0x801a43,%rax
  802c3a:	00 00 00 
  802c3d:	ff d0                	callq  *%rax
  802c3f:	89 03                	mov    %eax,(%rbx)
	return 0;
  802c41:	b8 00 00 00 00       	mov    $0x0,%eax
  802c46:	eb 33                	jmp    802c7b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802c48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c4c:	48 89 c6             	mov    %rax,%rsi
  802c4f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c54:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  802c5b:	00 00 00 
  802c5e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802c60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c64:	48 89 c6             	mov    %rax,%rsi
  802c67:	bf 00 00 00 00       	mov    $0x0,%edi
  802c6c:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  802c73:	00 00 00 
  802c76:	ff d0                	callq  *%rax
err:
	return r;
  802c78:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c7b:	48 83 c4 38          	add    $0x38,%rsp
  802c7f:	5b                   	pop    %rbx
  802c80:	5d                   	pop    %rbp
  802c81:	c3                   	retq   

0000000000802c82 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c82:	55                   	push   %rbp
  802c83:	48 89 e5             	mov    %rsp,%rbp
  802c86:	53                   	push   %rbx
  802c87:	48 83 ec 28          	sub    $0x28,%rsp
  802c8b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c8f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c93:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c9a:	00 00 00 
  802c9d:	48 8b 00             	mov    (%rax),%rax
  802ca0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802ca6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802ca9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cad:	48 89 c7             	mov    %rax,%rdi
  802cb0:	48 b8 f7 35 80 00 00 	movabs $0x8035f7,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
  802cbc:	89 c3                	mov    %eax,%ebx
  802cbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc2:	48 89 c7             	mov    %rax,%rdi
  802cc5:	48 b8 f7 35 80 00 00 	movabs $0x8035f7,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	callq  *%rax
  802cd1:	39 c3                	cmp    %eax,%ebx
  802cd3:	0f 94 c0             	sete   %al
  802cd6:	0f b6 c0             	movzbl %al,%eax
  802cd9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802cdc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ce3:	00 00 00 
  802ce6:	48 8b 00             	mov    (%rax),%rax
  802ce9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802cef:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802cf2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cf5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802cf8:	75 05                	jne    802cff <_pipeisclosed+0x7d>
			return ret;
  802cfa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cfd:	eb 4f                	jmp    802d4e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802cff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d02:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802d05:	74 42                	je     802d49 <_pipeisclosed+0xc7>
  802d07:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802d0b:	75 3c                	jne    802d49 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d0d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802d14:	00 00 00 
  802d17:	48 8b 00             	mov    (%rax),%rax
  802d1a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802d20:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d26:	89 c6                	mov    %eax,%esi
  802d28:	48 bf 3b 3d 80 00 00 	movabs $0x803d3b,%rdi
  802d2f:	00 00 00 
  802d32:	b8 00 00 00 00       	mov    $0x0,%eax
  802d37:	49 b8 df 02 80 00 00 	movabs $0x8002df,%r8
  802d3e:	00 00 00 
  802d41:	41 ff d0             	callq  *%r8
	}
  802d44:	e9 4a ff ff ff       	jmpq   802c93 <_pipeisclosed+0x11>
  802d49:	e9 45 ff ff ff       	jmpq   802c93 <_pipeisclosed+0x11>
}
  802d4e:	48 83 c4 28          	add    $0x28,%rsp
  802d52:	5b                   	pop    %rbx
  802d53:	5d                   	pop    %rbp
  802d54:	c3                   	retq   

0000000000802d55 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802d55:	55                   	push   %rbp
  802d56:	48 89 e5             	mov    %rsp,%rbp
  802d59:	48 83 ec 30          	sub    $0x30,%rsp
  802d5d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d60:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d64:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d67:	48 89 d6             	mov    %rdx,%rsi
  802d6a:	89 c7                	mov    %eax,%edi
  802d6c:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  802d73:	00 00 00 
  802d76:	ff d0                	callq  *%rax
  802d78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7f:	79 05                	jns    802d86 <pipeisclosed+0x31>
		return r;
  802d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d84:	eb 31                	jmp    802db7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8a:	48 89 c7             	mov    %rax,%rdi
  802d8d:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
  802d99:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da5:	48 89 d6             	mov    %rdx,%rsi
  802da8:	48 89 c7             	mov    %rax,%rdi
  802dab:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802db2:	00 00 00 
  802db5:	ff d0                	callq  *%rax
}
  802db7:	c9                   	leaveq 
  802db8:	c3                   	retq   

0000000000802db9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802db9:	55                   	push   %rbp
  802dba:	48 89 e5             	mov    %rsp,%rbp
  802dbd:	48 83 ec 40          	sub    $0x40,%rsp
  802dc1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802dc5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dc9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802dcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dd1:	48 89 c7             	mov    %rax,%rdi
  802dd4:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
  802de0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802de4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802dec:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802df3:	00 
  802df4:	e9 92 00 00 00       	jmpq   802e8b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802df9:	eb 41                	jmp    802e3c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802dfb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802e00:	74 09                	je     802e0b <devpipe_read+0x52>
				return i;
  802e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e06:	e9 92 00 00 00       	jmpq   802e9d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802e0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e13:	48 89 d6             	mov    %rdx,%rsi
  802e16:	48 89 c7             	mov    %rax,%rdi
  802e19:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 07                	je     802e30 <devpipe_read+0x77>
				return 0;
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	eb 6d                	jmp    802e9d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802e30:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  802e37:	00 00 00 
  802e3a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e40:	8b 10                	mov    (%rax),%edx
  802e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e46:	8b 40 04             	mov    0x4(%rax),%eax
  802e49:	39 c2                	cmp    %eax,%edx
  802e4b:	74 ae                	je     802dfb <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e55:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5d:	8b 00                	mov    (%rax),%eax
  802e5f:	99                   	cltd   
  802e60:	c1 ea 1b             	shr    $0x1b,%edx
  802e63:	01 d0                	add    %edx,%eax
  802e65:	83 e0 1f             	and    $0x1f,%eax
  802e68:	29 d0                	sub    %edx,%eax
  802e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e6e:	48 98                	cltq   
  802e70:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e75:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7b:	8b 00                	mov    (%rax),%eax
  802e7d:	8d 50 01             	lea    0x1(%rax),%edx
  802e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e84:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e86:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e93:	0f 82 60 ff ff ff    	jb     802df9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e9d:	c9                   	leaveq 
  802e9e:	c3                   	retq   

0000000000802e9f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e9f:	55                   	push   %rbp
  802ea0:	48 89 e5             	mov    %rsp,%rbp
  802ea3:	48 83 ec 40          	sub    $0x40,%rsp
  802ea7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802eab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eaf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802eb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb7:	48 89 c7             	mov    %rax,%rdi
  802eba:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  802ec1:	00 00 00 
  802ec4:	ff d0                	callq  *%rax
  802ec6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802eca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ece:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802ed2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ed9:	00 
  802eda:	e9 8e 00 00 00       	jmpq   802f6d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802edf:	eb 31                	jmp    802f12 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ee1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ee5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee9:	48 89 d6             	mov    %rdx,%rsi
  802eec:	48 89 c7             	mov    %rax,%rdi
  802eef:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 07                	je     802f06 <devpipe_write+0x67>
				return 0;
  802eff:	b8 00 00 00 00       	mov    $0x0,%eax
  802f04:	eb 79                	jmp    802f7f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802f06:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f16:	8b 40 04             	mov    0x4(%rax),%eax
  802f19:	48 63 d0             	movslq %eax,%rdx
  802f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f20:	8b 00                	mov    (%rax),%eax
  802f22:	48 98                	cltq   
  802f24:	48 83 c0 20          	add    $0x20,%rax
  802f28:	48 39 c2             	cmp    %rax,%rdx
  802f2b:	73 b4                	jae    802ee1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f31:	8b 40 04             	mov    0x4(%rax),%eax
  802f34:	99                   	cltd   
  802f35:	c1 ea 1b             	shr    $0x1b,%edx
  802f38:	01 d0                	add    %edx,%eax
  802f3a:	83 e0 1f             	and    $0x1f,%eax
  802f3d:	29 d0                	sub    %edx,%eax
  802f3f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f43:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f47:	48 01 ca             	add    %rcx,%rdx
  802f4a:	0f b6 0a             	movzbl (%rdx),%ecx
  802f4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f51:	48 98                	cltq   
  802f53:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5b:	8b 40 04             	mov    0x4(%rax),%eax
  802f5e:	8d 50 01             	lea    0x1(%rax),%edx
  802f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f65:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f68:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f71:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f75:	0f 82 64 ff ff ff    	jb     802edf <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f7f:	c9                   	leaveq 
  802f80:	c3                   	retq   

0000000000802f81 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f81:	55                   	push   %rbp
  802f82:	48 89 e5             	mov    %rsp,%rbp
  802f85:	48 83 ec 20          	sub    $0x20,%rsp
  802f89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f95:	48 89 c7             	mov    %rax,%rdi
  802f98:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
  802fa4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802fa8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fac:	48 be 4e 3d 80 00 00 	movabs $0x803d4e,%rsi
  802fb3:	00 00 00 
  802fb6:	48 89 c7             	mov    %rax,%rdi
  802fb9:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc9:	8b 50 04             	mov    0x4(%rax),%edx
  802fcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd0:	8b 00                	mov    (%rax),%eax
  802fd2:	29 c2                	sub    %eax,%edx
  802fd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802fde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fe9:	00 00 00 
	stat->st_dev = &devpipe;
  802fec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff0:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802ff7:	00 00 00 
  802ffa:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803006:	c9                   	leaveq 
  803007:	c3                   	retq   

0000000000803008 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803008:	55                   	push   %rbp
  803009:	48 89 e5             	mov    %rsp,%rbp
  80300c:	48 83 ec 10          	sub    $0x10,%rsp
  803010:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803018:	48 89 c6             	mov    %rax,%rsi
  80301b:	bf 00 00 00 00       	mov    $0x0,%edi
  803020:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  803027:	00 00 00 
  80302a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80302c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803030:	48 89 c7             	mov    %rax,%rdi
  803033:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  80303a:	00 00 00 
  80303d:	ff d0                	callq  *%rax
  80303f:	48 89 c6             	mov    %rax,%rsi
  803042:	bf 00 00 00 00       	mov    $0x0,%edi
  803047:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  80304e:	00 00 00 
  803051:	ff d0                	callq  *%rax
}
  803053:	c9                   	leaveq 
  803054:	c3                   	retq   

0000000000803055 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803055:	55                   	push   %rbp
  803056:	48 89 e5             	mov    %rsp,%rbp
  803059:	48 83 ec 20          	sub    $0x20,%rsp
  80305d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803060:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803063:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803066:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80306a:	be 01 00 00 00       	mov    $0x1,%esi
  80306f:	48 89 c7             	mov    %rax,%rdi
  803072:	48 b8 8e 16 80 00 00 	movabs $0x80168e,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
}
  80307e:	c9                   	leaveq 
  80307f:	c3                   	retq   

0000000000803080 <getchar>:

int
getchar(void)
{
  803080:	55                   	push   %rbp
  803081:	48 89 e5             	mov    %rsp,%rbp
  803084:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803088:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80308c:	ba 01 00 00 00       	mov    $0x1,%edx
  803091:	48 89 c6             	mov    %rax,%rsi
  803094:	bf 00 00 00 00       	mov    $0x0,%edi
  803099:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  8030a0:	00 00 00 
  8030a3:	ff d0                	callq  *%rax
  8030a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8030a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ac:	79 05                	jns    8030b3 <getchar+0x33>
		return r;
  8030ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b1:	eb 14                	jmp    8030c7 <getchar+0x47>
	if (r < 1)
  8030b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b7:	7f 07                	jg     8030c0 <getchar+0x40>
		return -E_EOF;
  8030b9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8030be:	eb 07                	jmp    8030c7 <getchar+0x47>
	return c;
  8030c0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8030c4:	0f b6 c0             	movzbl %al,%eax
}
  8030c7:	c9                   	leaveq 
  8030c8:	c3                   	retq   

00000000008030c9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8030c9:	55                   	push   %rbp
  8030ca:	48 89 e5             	mov    %rsp,%rbp
  8030cd:	48 83 ec 20          	sub    $0x20,%rsp
  8030d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030db:	48 89 d6             	mov    %rdx,%rsi
  8030de:	89 c7                	mov    %eax,%edi
  8030e0:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  8030e7:	00 00 00 
  8030ea:	ff d0                	callq  *%rax
  8030ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f3:	79 05                	jns    8030fa <iscons+0x31>
		return r;
  8030f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f8:	eb 1a                	jmp    803114 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8030fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fe:	8b 10                	mov    (%rax),%edx
  803100:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803107:	00 00 00 
  80310a:	8b 00                	mov    (%rax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 94 c0             	sete   %al
  803111:	0f b6 c0             	movzbl %al,%eax
}
  803114:	c9                   	leaveq 
  803115:	c3                   	retq   

0000000000803116 <opencons>:

int
opencons(void)
{
  803116:	55                   	push   %rbp
  803117:	48 89 e5             	mov    %rsp,%rbp
  80311a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80311e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803122:	48 89 c7             	mov    %rax,%rdi
  803125:	48 b8 91 1a 80 00 00 	movabs $0x801a91,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803138:	79 05                	jns    80313f <opencons+0x29>
		return r;
  80313a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313d:	eb 5b                	jmp    80319a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80313f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803143:	ba 07 04 00 00       	mov    $0x407,%edx
  803148:	48 89 c6             	mov    %rax,%rsi
  80314b:	bf 00 00 00 00       	mov    $0x0,%edi
  803150:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  803157:	00 00 00 
  80315a:	ff d0                	callq  *%rax
  80315c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803163:	79 05                	jns    80316a <opencons+0x54>
		return r;
  803165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803168:	eb 30                	jmp    80319a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80316a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316e:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803175:	00 00 00 
  803178:	8b 12                	mov    (%rdx),%edx
  80317a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80317c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803180:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318b:	48 89 c7             	mov    %rax,%rdi
  80318e:	48 b8 43 1a 80 00 00 	movabs $0x801a43,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
}
  80319a:	c9                   	leaveq 
  80319b:	c3                   	retq   

000000000080319c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
  8031a0:	48 83 ec 30          	sub    $0x30,%rsp
  8031a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8031b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8031b5:	75 07                	jne    8031be <devcons_read+0x22>
		return 0;
  8031b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bc:	eb 4b                	jmp    803209 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8031be:	eb 0c                	jmp    8031cc <devcons_read+0x30>
		sys_yield();
  8031c0:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8031c7:	00 00 00 
  8031ca:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8031cc:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
  8031d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031df:	74 df                	je     8031c0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8031e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e5:	79 05                	jns    8031ec <devcons_read+0x50>
		return c;
  8031e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ea:	eb 1d                	jmp    803209 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8031ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8031f0:	75 07                	jne    8031f9 <devcons_read+0x5d>
		return 0;
  8031f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f7:	eb 10                	jmp    803209 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8031f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fc:	89 c2                	mov    %eax,%edx
  8031fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803202:	88 10                	mov    %dl,(%rax)
	return 1;
  803204:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803209:	c9                   	leaveq 
  80320a:	c3                   	retq   

000000000080320b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80320b:	55                   	push   %rbp
  80320c:	48 89 e5             	mov    %rsp,%rbp
  80320f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803216:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80321d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803224:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80322b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803232:	eb 76                	jmp    8032aa <devcons_write+0x9f>
		m = n - tot;
  803234:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80323b:	89 c2                	mov    %eax,%edx
  80323d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803240:	29 c2                	sub    %eax,%edx
  803242:	89 d0                	mov    %edx,%eax
  803244:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803247:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324a:	83 f8 7f             	cmp    $0x7f,%eax
  80324d:	76 07                	jbe    803256 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80324f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803256:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803259:	48 63 d0             	movslq %eax,%rdx
  80325c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325f:	48 63 c8             	movslq %eax,%rcx
  803262:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803269:	48 01 c1             	add    %rax,%rcx
  80326c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803273:	48 89 ce             	mov    %rcx,%rsi
  803276:	48 89 c7             	mov    %rax,%rdi
  803279:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803285:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803288:	48 63 d0             	movslq %eax,%rdx
  80328b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803292:	48 89 d6             	mov    %rdx,%rsi
  803295:	48 89 c7             	mov    %rax,%rdi
  803298:	48 b8 8e 16 80 00 00 	movabs $0x80168e,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8032a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032a7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8032aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ad:	48 98                	cltq   
  8032af:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8032b6:	0f 82 78 ff ff ff    	jb     803234 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8032bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032bf:	c9                   	leaveq 
  8032c0:	c3                   	retq   

00000000008032c1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8032c1:	55                   	push   %rbp
  8032c2:	48 89 e5             	mov    %rsp,%rbp
  8032c5:	48 83 ec 08          	sub    $0x8,%rsp
  8032c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8032cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032d2:	c9                   	leaveq 
  8032d3:	c3                   	retq   

00000000008032d4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8032d4:	55                   	push   %rbp
  8032d5:	48 89 e5             	mov    %rsp,%rbp
  8032d8:	48 83 ec 10          	sub    $0x10,%rsp
  8032dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8032e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e8:	48 be 5a 3d 80 00 00 	movabs $0x803d5a,%rsi
  8032ef:	00 00 00 
  8032f2:	48 89 c7             	mov    %rax,%rdi
  8032f5:	48 b8 a7 0e 80 00 00 	movabs $0x800ea7,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
	return 0;
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803306:	c9                   	leaveq 
  803307:	c3                   	retq   

0000000000803308 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803308:	55                   	push   %rbp
  803309:	48 89 e5             	mov    %rsp,%rbp
  80330c:	53                   	push   %rbx
  80330d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803314:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80331b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803321:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803328:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80332f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803336:	84 c0                	test   %al,%al
  803338:	74 23                	je     80335d <_panic+0x55>
  80333a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803341:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803345:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803349:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80334d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803351:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803355:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803359:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80335d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803364:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80336b:	00 00 00 
  80336e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803375:	00 00 00 
  803378:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80337c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803383:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80338a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803391:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803398:	00 00 00 
  80339b:	48 8b 18             	mov    (%rax),%rbx
  80339e:	48 b8 5a 17 80 00 00 	movabs $0x80175a,%rax
  8033a5:	00 00 00 
  8033a8:	ff d0                	callq  *%rax
  8033aa:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8033b0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8033b7:	41 89 c8             	mov    %ecx,%r8d
  8033ba:	48 89 d1             	mov    %rdx,%rcx
  8033bd:	48 89 da             	mov    %rbx,%rdx
  8033c0:	89 c6                	mov    %eax,%esi
  8033c2:	48 bf 68 3d 80 00 00 	movabs $0x803d68,%rdi
  8033c9:	00 00 00 
  8033cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d1:	49 b9 df 02 80 00 00 	movabs $0x8002df,%r9
  8033d8:	00 00 00 
  8033db:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8033de:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8033e5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033ec:	48 89 d6             	mov    %rdx,%rsi
  8033ef:	48 89 c7             	mov    %rax,%rdi
  8033f2:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
	cprintf("\n");
  8033fe:	48 bf 8b 3d 80 00 00 	movabs $0x803d8b,%rdi
  803405:	00 00 00 
  803408:	b8 00 00 00 00       	mov    $0x0,%eax
  80340d:	48 ba df 02 80 00 00 	movabs $0x8002df,%rdx
  803414:	00 00 00 
  803417:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803419:	cc                   	int3   
  80341a:	eb fd                	jmp    803419 <_panic+0x111>

000000000080341c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80341c:	55                   	push   %rbp
  80341d:	48 89 e5             	mov    %rsp,%rbp
  803420:	48 83 ec 30          	sub    $0x30,%rsp
  803424:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803428:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80342c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803430:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803435:	75 0e                	jne    803445 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803437:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80343e:	00 00 00 
  803441:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803445:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803449:	48 89 c7             	mov    %rax,%rdi
  80344c:	48 b8 ff 19 80 00 00 	movabs $0x8019ff,%rax
  803453:	00 00 00 
  803456:	ff d0                	callq  *%rax
  803458:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345f:	79 27                	jns    803488 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803461:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803466:	74 0a                	je     803472 <ipc_recv+0x56>
            *from_env_store = 0;
  803468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80346c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803472:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803477:	74 0a                	je     803483 <ipc_recv+0x67>
            *perm_store = 0;
  803479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803486:	eb 53                	jmp    8034db <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803488:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80348d:	74 19                	je     8034a8 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80348f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803496:	00 00 00 
  803499:	48 8b 00             	mov    (%rax),%rax
  80349c:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8034a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a6:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8034a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034ad:	74 19                	je     8034c8 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8034af:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034b6:	00 00 00 
  8034b9:	48 8b 00             	mov    (%rax),%rax
  8034bc:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8034c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c6:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8034c8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034cf:	00 00 00 
  8034d2:	48 8b 00             	mov    (%rax),%rax
  8034d5:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8034db:	c9                   	leaveq 
  8034dc:	c3                   	retq   

00000000008034dd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034dd:	55                   	push   %rbp
  8034de:	48 89 e5             	mov    %rsp,%rbp
  8034e1:	48 83 ec 30          	sub    $0x30,%rsp
  8034e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034e8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034eb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8034ef:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8034f2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034f7:	75 0e                	jne    803507 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8034f9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803500:	00 00 00 
  803503:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803507:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80350a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80350d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803511:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803514:	89 c7                	mov    %eax,%edi
  803516:	48 b8 aa 19 80 00 00 	movabs $0x8019aa,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
  803522:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803525:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803529:	79 36                	jns    803561 <ipc_send+0x84>
  80352b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80352f:	74 30                	je     803561 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803534:	89 c1                	mov    %eax,%ecx
  803536:	48 ba 8d 3d 80 00 00 	movabs $0x803d8d,%rdx
  80353d:	00 00 00 
  803540:	be 49 00 00 00       	mov    $0x49,%esi
  803545:	48 bf 9a 3d 80 00 00 	movabs $0x803d9a,%rdi
  80354c:	00 00 00 
  80354f:	b8 00 00 00 00       	mov    $0x0,%eax
  803554:	49 b8 08 33 80 00 00 	movabs $0x803308,%r8
  80355b:	00 00 00 
  80355e:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803561:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  803568:	00 00 00 
  80356b:	ff d0                	callq  *%rax
    } while(r != 0);
  80356d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803571:	75 94                	jne    803507 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803573:	c9                   	leaveq 
  803574:	c3                   	retq   

0000000000803575 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803575:	55                   	push   %rbp
  803576:	48 89 e5             	mov    %rsp,%rbp
  803579:	48 83 ec 14          	sub    $0x14,%rsp
  80357d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803587:	eb 5e                	jmp    8035e7 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803589:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803590:	00 00 00 
  803593:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803596:	48 63 d0             	movslq %eax,%rdx
  803599:	48 89 d0             	mov    %rdx,%rax
  80359c:	48 c1 e0 03          	shl    $0x3,%rax
  8035a0:	48 01 d0             	add    %rdx,%rax
  8035a3:	48 c1 e0 05          	shl    $0x5,%rax
  8035a7:	48 01 c8             	add    %rcx,%rax
  8035aa:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8035b0:	8b 00                	mov    (%rax),%eax
  8035b2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8035b5:	75 2c                	jne    8035e3 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8035b7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035be:	00 00 00 
  8035c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c4:	48 63 d0             	movslq %eax,%rdx
  8035c7:	48 89 d0             	mov    %rdx,%rax
  8035ca:	48 c1 e0 03          	shl    $0x3,%rax
  8035ce:	48 01 d0             	add    %rdx,%rax
  8035d1:	48 c1 e0 05          	shl    $0x5,%rax
  8035d5:	48 01 c8             	add    %rcx,%rax
  8035d8:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8035de:	8b 40 08             	mov    0x8(%rax),%eax
  8035e1:	eb 12                	jmp    8035f5 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8035e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8035e7:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8035ee:	7e 99                	jle    803589 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8035f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035f5:	c9                   	leaveq 
  8035f6:	c3                   	retq   

00000000008035f7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8035f7:	55                   	push   %rbp
  8035f8:	48 89 e5             	mov    %rsp,%rbp
  8035fb:	48 83 ec 18          	sub    $0x18,%rsp
  8035ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803607:	48 c1 e8 15          	shr    $0x15,%rax
  80360b:	48 89 c2             	mov    %rax,%rdx
  80360e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803615:	01 00 00 
  803618:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80361c:	83 e0 01             	and    $0x1,%eax
  80361f:	48 85 c0             	test   %rax,%rax
  803622:	75 07                	jne    80362b <pageref+0x34>
		return 0;
  803624:	b8 00 00 00 00       	mov    $0x0,%eax
  803629:	eb 53                	jmp    80367e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80362b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362f:	48 c1 e8 0c          	shr    $0xc,%rax
  803633:	48 89 c2             	mov    %rax,%rdx
  803636:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80363d:	01 00 00 
  803640:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803644:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803648:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364c:	83 e0 01             	and    $0x1,%eax
  80364f:	48 85 c0             	test   %rax,%rax
  803652:	75 07                	jne    80365b <pageref+0x64>
		return 0;
  803654:	b8 00 00 00 00       	mov    $0x0,%eax
  803659:	eb 23                	jmp    80367e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80365b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365f:	48 c1 e8 0c          	shr    $0xc,%rax
  803663:	48 89 c2             	mov    %rax,%rdx
  803666:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80366d:	00 00 00 
  803670:	48 c1 e2 04          	shl    $0x4,%rdx
  803674:	48 01 d0             	add    %rdx,%rax
  803677:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80367b:	0f b7 c0             	movzwl %ax,%eax
}
  80367e:	c9                   	leaveq 
  80367f:	c3                   	retq   
