
obj/user/fairness:     file format elf64-x86-64


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
  80003c:	e8 dd 00 00 00       	callq  80011e <libmain>
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
	envid_t who, id;

	id = sys_getenvid();
  800052:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800061:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800068:	00 00 00 
  80006b:	48 8b 10             	mov    (%rax),%rdx
  80006e:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	75 42                	jne    8000bf <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007d:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
  800086:	be 00 00 00 00       	mov    $0x0,%esi
  80008b:	48 89 c7             	mov    %rax,%rdi
  80008e:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf a0 36 80 00 00 	movabs $0x8036a0,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  8000b8:	00 00 00 
  8000bb:	ff d1                	callq  *%rcx
		}
  8000bd:	eb be                	jmp    80007d <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c6:	00 00 00 
  8000c9:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	48 bf b1 36 80 00 00 	movabs $0x8036b1,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  8000ea:	00 00 00 
  8000ed:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f6:	00 00 00 
  8000f9:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	be 00 00 00 00       	mov    $0x0,%esi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
  80011c:	eb d1                	jmp    8000ef <umain+0xac>

000000000080011e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 20          	sub    $0x20,%rsp
  800126:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800129:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80012d:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800144:	48 63 d0             	movslq %eax,%rdx
  800147:	48 89 d0             	mov    %rdx,%rax
  80014a:	48 c1 e0 03          	shl    $0x3,%rax
  80014e:	48 01 d0             	add    %rdx,%rax
  800151:	48 c1 e0 05          	shl    $0x5,%rax
  800155:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80015c:	00 00 00 
  80015f:	48 01 c2             	add    %rax,%rdx
  800162:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800169:	00 00 00 
  80016c:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800173:	7e 14                	jle    800189 <libmain+0x6b>
		binaryname = argv[0];
  800175:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800179:	48 8b 10             	mov    (%rax),%rdx
  80017c:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800183:	00 00 00 
  800186:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800189:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80018d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800190:	48 89 d6             	mov    %rdx,%rsi
  800193:	89 c7                	mov    %eax,%edi
  800195:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001a1:	48 b8 af 01 80 00 00 	movabs $0x8001af,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	callq  *%rax
}
  8001ad:	c9                   	leaveq 
  8001ae:	c3                   	retq   

00000000008001af <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001af:	55                   	push   %rbp
  8001b0:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001b3:	48 b8 77 1f 80 00 00 	movabs $0x801f77,%rax
  8001ba:	00 00 00 
  8001bd:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c4:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
}
  8001d0:	5d                   	pop    %rbp
  8001d1:	c3                   	retq   

00000000008001d2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001d2:	55                   	push   %rbp
  8001d3:	48 89 e5             	mov    %rsp,%rbp
  8001d6:	48 83 ec 10          	sub    $0x10,%rsp
  8001da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e5:	8b 00                	mov    (%rax),%eax
  8001e7:	8d 48 01             	lea    0x1(%rax),%ecx
  8001ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ee:	89 0a                	mov    %ecx,(%rdx)
  8001f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001f3:	89 d1                	mov    %edx,%ecx
  8001f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f9:	48 98                	cltq   
  8001fb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800203:	8b 00                	mov    (%rax),%eax
  800205:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020a:	75 2c                	jne    800238 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80020c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800210:	8b 00                	mov    (%rax),%eax
  800212:	48 98                	cltq   
  800214:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800218:	48 83 c2 08          	add    $0x8,%rdx
  80021c:	48 89 c6             	mov    %rax,%rsi
  80021f:	48 89 d7             	mov    %rdx,%rdi
  800222:	48 b8 a6 16 80 00 00 	movabs $0x8016a6,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
        b->idx = 0;
  80022e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800232:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023c:	8b 40 04             	mov    0x4(%rax),%eax
  80023f:	8d 50 01             	lea    0x1(%rax),%edx
  800242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800246:	89 50 04             	mov    %edx,0x4(%rax)
}
  800249:	c9                   	leaveq 
  80024a:	c3                   	retq   

000000000080024b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80024b:	55                   	push   %rbp
  80024c:	48 89 e5             	mov    %rsp,%rbp
  80024f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800256:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80025d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800264:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80026b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800272:	48 8b 0a             	mov    (%rdx),%rcx
  800275:	48 89 08             	mov    %rcx,(%rax)
  800278:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80027c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800280:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800284:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800288:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80028f:	00 00 00 
    b.cnt = 0;
  800292:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800299:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80029c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002a3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002aa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002b1:	48 89 c6             	mov    %rax,%rsi
  8002b4:	48 bf d2 01 80 00 00 	movabs $0x8001d2,%rdi
  8002bb:	00 00 00 
  8002be:	48 b8 aa 06 80 00 00 	movabs $0x8006aa,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002ca:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002d0:	48 98                	cltq   
  8002d2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d9:	48 83 c2 08          	add    $0x8,%rdx
  8002dd:	48 89 c6             	mov    %rax,%rsi
  8002e0:	48 89 d7             	mov    %rdx,%rdi
  8002e3:	48 b8 a6 16 80 00 00 	movabs $0x8016a6,%rax
  8002ea:	00 00 00 
  8002ed:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002f5:	c9                   	leaveq 
  8002f6:	c3                   	retq   

00000000008002f7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002f7:	55                   	push   %rbp
  8002f8:	48 89 e5             	mov    %rsp,%rbp
  8002fb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800302:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800309:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800310:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800317:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80031e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800325:	84 c0                	test   %al,%al
  800327:	74 20                	je     800349 <cprintf+0x52>
  800329:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80032d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800331:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800335:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800339:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80033d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800341:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800345:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800349:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800350:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800357:	00 00 00 
  80035a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800361:	00 00 00 
  800364:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800368:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80036f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800376:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80037d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800384:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80038b:	48 8b 0a             	mov    (%rdx),%rcx
  80038e:	48 89 08             	mov    %rcx,(%rax)
  800391:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800395:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800399:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80039d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003a1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003af:	48 89 d6             	mov    %rdx,%rsi
  8003b2:	48 89 c7             	mov    %rax,%rdi
  8003b5:	48 b8 4b 02 80 00 00 	movabs $0x80024b,%rax
  8003bc:	00 00 00 
  8003bf:	ff d0                	callq  *%rax
  8003c1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003c7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003cd:	c9                   	leaveq 
  8003ce:	c3                   	retq   

00000000008003cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003cf:	55                   	push   %rbp
  8003d0:	48 89 e5             	mov    %rsp,%rbp
  8003d3:	53                   	push   %rbx
  8003d4:	48 83 ec 38          	sub    $0x38,%rsp
  8003d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003e4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003e7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003eb:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ef:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003f6:	77 3b                	ja     800433 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003fb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003ff:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800406:	ba 00 00 00 00       	mov    $0x0,%edx
  80040b:	48 f7 f3             	div    %rbx
  80040e:	48 89 c2             	mov    %rax,%rdx
  800411:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800414:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800417:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80041b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041f:	41 89 f9             	mov    %edi,%r9d
  800422:	48 89 c7             	mov    %rax,%rdi
  800425:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  80042c:	00 00 00 
  80042f:	ff d0                	callq  *%rax
  800431:	eb 1e                	jmp    800451 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800433:	eb 12                	jmp    800447 <printnum+0x78>
			putch(padc, putdat);
  800435:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800439:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80043c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800440:	48 89 ce             	mov    %rcx,%rsi
  800443:	89 d7                	mov    %edx,%edi
  800445:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800447:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80044b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80044f:	7f e4                	jg     800435 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800451:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800458:	ba 00 00 00 00       	mov    $0x0,%edx
  80045d:	48 f7 f1             	div    %rcx
  800460:	48 89 d0             	mov    %rdx,%rax
  800463:	48 ba d0 38 80 00 00 	movabs $0x8038d0,%rdx
  80046a:	00 00 00 
  80046d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800471:	0f be d0             	movsbl %al,%edx
  800474:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800478:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047c:	48 89 ce             	mov    %rcx,%rsi
  80047f:	89 d7                	mov    %edx,%edi
  800481:	ff d0                	callq  *%rax
}
  800483:	48 83 c4 38          	add    $0x38,%rsp
  800487:	5b                   	pop    %rbx
  800488:	5d                   	pop    %rbp
  800489:	c3                   	retq   

000000000080048a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048a:	55                   	push   %rbp
  80048b:	48 89 e5             	mov    %rsp,%rbp
  80048e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800492:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800496:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800499:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80049d:	7e 52                	jle    8004f1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80049f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a3:	8b 00                	mov    (%rax),%eax
  8004a5:	83 f8 30             	cmp    $0x30,%eax
  8004a8:	73 24                	jae    8004ce <getuint+0x44>
  8004aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b6:	8b 00                	mov    (%rax),%eax
  8004b8:	89 c0                	mov    %eax,%eax
  8004ba:	48 01 d0             	add    %rdx,%rax
  8004bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c1:	8b 12                	mov    (%rdx),%edx
  8004c3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ca:	89 0a                	mov    %ecx,(%rdx)
  8004cc:	eb 17                	jmp    8004e5 <getuint+0x5b>
  8004ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d6:	48 89 d0             	mov    %rdx,%rax
  8004d9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004e5:	48 8b 00             	mov    (%rax),%rax
  8004e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004ec:	e9 a3 00 00 00       	jmpq   800594 <getuint+0x10a>
	else if (lflag)
  8004f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004f5:	74 4f                	je     800546 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fb:	8b 00                	mov    (%rax),%eax
  8004fd:	83 f8 30             	cmp    $0x30,%eax
  800500:	73 24                	jae    800526 <getuint+0x9c>
  800502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800506:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80050a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050e:	8b 00                	mov    (%rax),%eax
  800510:	89 c0                	mov    %eax,%eax
  800512:	48 01 d0             	add    %rdx,%rax
  800515:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800519:	8b 12                	mov    (%rdx),%edx
  80051b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80051e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800522:	89 0a                	mov    %ecx,(%rdx)
  800524:	eb 17                	jmp    80053d <getuint+0xb3>
  800526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80052e:	48 89 d0             	mov    %rdx,%rax
  800531:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800535:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800539:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80053d:	48 8b 00             	mov    (%rax),%rax
  800540:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800544:	eb 4e                	jmp    800594 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054a:	8b 00                	mov    (%rax),%eax
  80054c:	83 f8 30             	cmp    $0x30,%eax
  80054f:	73 24                	jae    800575 <getuint+0xeb>
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	89 c0                	mov    %eax,%eax
  800561:	48 01 d0             	add    %rdx,%rax
  800564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800568:	8b 12                	mov    (%rdx),%edx
  80056a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80056d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800571:	89 0a                	mov    %ecx,(%rdx)
  800573:	eb 17                	jmp    80058c <getuint+0x102>
  800575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800579:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80057d:	48 89 d0             	mov    %rdx,%rax
  800580:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800588:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058c:	8b 00                	mov    (%rax),%eax
  80058e:	89 c0                	mov    %eax,%eax
  800590:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800598:	c9                   	leaveq 
  800599:	c3                   	retq   

000000000080059a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80059a:	55                   	push   %rbp
  80059b:	48 89 e5             	mov    %rsp,%rbp
  80059e:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005a9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ad:	7e 52                	jle    800601 <getint+0x67>
		x=va_arg(*ap, long long);
  8005af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b3:	8b 00                	mov    (%rax),%eax
  8005b5:	83 f8 30             	cmp    $0x30,%eax
  8005b8:	73 24                	jae    8005de <getint+0x44>
  8005ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c6:	8b 00                	mov    (%rax),%eax
  8005c8:	89 c0                	mov    %eax,%eax
  8005ca:	48 01 d0             	add    %rdx,%rax
  8005cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d1:	8b 12                	mov    (%rdx),%edx
  8005d3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005da:	89 0a                	mov    %ecx,(%rdx)
  8005dc:	eb 17                	jmp    8005f5 <getint+0x5b>
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e6:	48 89 d0             	mov    %rdx,%rax
  8005e9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f5:	48 8b 00             	mov    (%rax),%rax
  8005f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005fc:	e9 a3 00 00 00       	jmpq   8006a4 <getint+0x10a>
	else if (lflag)
  800601:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800605:	74 4f                	je     800656 <getint+0xbc>
		x=va_arg(*ap, long);
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	8b 00                	mov    (%rax),%eax
  80060d:	83 f8 30             	cmp    $0x30,%eax
  800610:	73 24                	jae    800636 <getint+0x9c>
  800612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800616:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	8b 00                	mov    (%rax),%eax
  800620:	89 c0                	mov    %eax,%eax
  800622:	48 01 d0             	add    %rdx,%rax
  800625:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800629:	8b 12                	mov    (%rdx),%edx
  80062b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	89 0a                	mov    %ecx,(%rdx)
  800634:	eb 17                	jmp    80064d <getint+0xb3>
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80063e:	48 89 d0             	mov    %rdx,%rax
  800641:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800649:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064d:	48 8b 00             	mov    (%rax),%rax
  800650:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800654:	eb 4e                	jmp    8006a4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065a:	8b 00                	mov    (%rax),%eax
  80065c:	83 f8 30             	cmp    $0x30,%eax
  80065f:	73 24                	jae    800685 <getint+0xeb>
  800661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800665:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066d:	8b 00                	mov    (%rax),%eax
  80066f:	89 c0                	mov    %eax,%eax
  800671:	48 01 d0             	add    %rdx,%rax
  800674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800678:	8b 12                	mov    (%rdx),%edx
  80067a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800681:	89 0a                	mov    %ecx,(%rdx)
  800683:	eb 17                	jmp    80069c <getint+0x102>
  800685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800689:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068d:	48 89 d0             	mov    %rdx,%rax
  800690:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800694:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800698:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069c:	8b 00                	mov    (%rax),%eax
  80069e:	48 98                	cltq   
  8006a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006a8:	c9                   	leaveq 
  8006a9:	c3                   	retq   

00000000008006aa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006aa:	55                   	push   %rbp
  8006ab:	48 89 e5             	mov    %rsp,%rbp
  8006ae:	41 54                	push   %r12
  8006b0:	53                   	push   %rbx
  8006b1:	48 83 ec 60          	sub    $0x60,%rsp
  8006b5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006b9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006bd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006c5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006c9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006cd:	48 8b 0a             	mov    (%rdx),%rcx
  8006d0:	48 89 08             	mov    %rcx,(%rax)
  8006d3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006db:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006df:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e3:	eb 17                	jmp    8006fc <vprintfmt+0x52>
			if (ch == '\0')
  8006e5:	85 db                	test   %ebx,%ebx
  8006e7:	0f 84 df 04 00 00    	je     800bcc <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8006ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006f5:	48 89 d6             	mov    %rdx,%rsi
  8006f8:	89 df                	mov    %ebx,%edi
  8006fa:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800700:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800704:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800708:	0f b6 00             	movzbl (%rax),%eax
  80070b:	0f b6 d8             	movzbl %al,%ebx
  80070e:	83 fb 25             	cmp    $0x25,%ebx
  800711:	75 d2                	jne    8006e5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800713:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800717:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80071e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800725:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80072c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800733:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800737:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80073b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80073f:	0f b6 00             	movzbl (%rax),%eax
  800742:	0f b6 d8             	movzbl %al,%ebx
  800745:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800748:	83 f8 55             	cmp    $0x55,%eax
  80074b:	0f 87 47 04 00 00    	ja     800b98 <vprintfmt+0x4ee>
  800751:	89 c0                	mov    %eax,%eax
  800753:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80075a:	00 
  80075b:	48 b8 f8 38 80 00 00 	movabs $0x8038f8,%rax
  800762:	00 00 00 
  800765:	48 01 d0             	add    %rdx,%rax
  800768:	48 8b 00             	mov    (%rax),%rax
  80076b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80076d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800771:	eb c0                	jmp    800733 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800773:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800777:	eb ba                	jmp    800733 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800779:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800780:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800783:	89 d0                	mov    %edx,%eax
  800785:	c1 e0 02             	shl    $0x2,%eax
  800788:	01 d0                	add    %edx,%eax
  80078a:	01 c0                	add    %eax,%eax
  80078c:	01 d8                	add    %ebx,%eax
  80078e:	83 e8 30             	sub    $0x30,%eax
  800791:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800794:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800798:	0f b6 00             	movzbl (%rax),%eax
  80079b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079e:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a1:	7e 0c                	jle    8007af <vprintfmt+0x105>
  8007a3:	83 fb 39             	cmp    $0x39,%ebx
  8007a6:	7f 07                	jg     8007af <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ad:	eb d1                	jmp    800780 <vprintfmt+0xd6>
			goto process_precision;
  8007af:	eb 58                	jmp    800809 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b4:	83 f8 30             	cmp    $0x30,%eax
  8007b7:	73 17                	jae    8007d0 <vprintfmt+0x126>
  8007b9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007bd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c0:	89 c0                	mov    %eax,%eax
  8007c2:	48 01 d0             	add    %rdx,%rax
  8007c5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c8:	83 c2 08             	add    $0x8,%edx
  8007cb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ce:	eb 0f                	jmp    8007df <vprintfmt+0x135>
  8007d0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d4:	48 89 d0             	mov    %rdx,%rax
  8007d7:	48 83 c2 08          	add    $0x8,%rdx
  8007db:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007df:	8b 00                	mov    (%rax),%eax
  8007e1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007e4:	eb 23                	jmp    800809 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ea:	79 0c                	jns    8007f8 <vprintfmt+0x14e>
				width = 0;
  8007ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007f3:	e9 3b ff ff ff       	jmpq   800733 <vprintfmt+0x89>
  8007f8:	e9 36 ff ff ff       	jmpq   800733 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007fd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800804:	e9 2a ff ff ff       	jmpq   800733 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800809:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080d:	79 12                	jns    800821 <vprintfmt+0x177>
				width = precision, precision = -1;
  80080f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800812:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800815:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80081c:	e9 12 ff ff ff       	jmpq   800733 <vprintfmt+0x89>
  800821:	e9 0d ff ff ff       	jmpq   800733 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800826:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80082a:	e9 04 ff ff ff       	jmpq   800733 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80082f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800832:	83 f8 30             	cmp    $0x30,%eax
  800835:	73 17                	jae    80084e <vprintfmt+0x1a4>
  800837:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80083b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083e:	89 c0                	mov    %eax,%eax
  800840:	48 01 d0             	add    %rdx,%rax
  800843:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800846:	83 c2 08             	add    $0x8,%edx
  800849:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80084c:	eb 0f                	jmp    80085d <vprintfmt+0x1b3>
  80084e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800852:	48 89 d0             	mov    %rdx,%rax
  800855:	48 83 c2 08          	add    $0x8,%rdx
  800859:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085d:	8b 10                	mov    (%rax),%edx
  80085f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800863:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800867:	48 89 ce             	mov    %rcx,%rsi
  80086a:	89 d7                	mov    %edx,%edi
  80086c:	ff d0                	callq  *%rax
			break;
  80086e:	e9 53 03 00 00       	jmpq   800bc6 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800873:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800876:	83 f8 30             	cmp    $0x30,%eax
  800879:	73 17                	jae    800892 <vprintfmt+0x1e8>
  80087b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80087f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800882:	89 c0                	mov    %eax,%eax
  800884:	48 01 d0             	add    %rdx,%rax
  800887:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088a:	83 c2 08             	add    $0x8,%edx
  80088d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800890:	eb 0f                	jmp    8008a1 <vprintfmt+0x1f7>
  800892:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800896:	48 89 d0             	mov    %rdx,%rax
  800899:	48 83 c2 08          	add    $0x8,%rdx
  80089d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x1ff>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 15             	cmp    $0x15,%ebx
  8008ac:	7f 16                	jg     8008c4 <vprintfmt+0x21a>
  8008ae:	48 b8 20 38 80 00 00 	movabs $0x803820,%rax
  8008b5:	00 00 00 
  8008b8:	48 63 d3             	movslq %ebx,%rdx
  8008bb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008bf:	4d 85 e4             	test   %r12,%r12
  8008c2:	75 2e                	jne    8008f2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008c4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008cc:	89 d9                	mov    %ebx,%ecx
  8008ce:	48 ba e1 38 80 00 00 	movabs $0x8038e1,%rdx
  8008d5:	00 00 00 
  8008d8:	48 89 c7             	mov    %rax,%rdi
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	49 b8 d5 0b 80 00 00 	movabs $0x800bd5,%r8
  8008e7:	00 00 00 
  8008ea:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ed:	e9 d4 02 00 00       	jmpq   800bc6 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fa:	4c 89 e1             	mov    %r12,%rcx
  8008fd:	48 ba ea 38 80 00 00 	movabs $0x8038ea,%rdx
  800904:	00 00 00 
  800907:	48 89 c7             	mov    %rax,%rdi
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
  80090f:	49 b8 d5 0b 80 00 00 	movabs $0x800bd5,%r8
  800916:	00 00 00 
  800919:	41 ff d0             	callq  *%r8
			break;
  80091c:	e9 a5 02 00 00       	jmpq   800bc6 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800921:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800924:	83 f8 30             	cmp    $0x30,%eax
  800927:	73 17                	jae    800940 <vprintfmt+0x296>
  800929:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80092d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800930:	89 c0                	mov    %eax,%eax
  800932:	48 01 d0             	add    %rdx,%rax
  800935:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800938:	83 c2 08             	add    $0x8,%edx
  80093b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80093e:	eb 0f                	jmp    80094f <vprintfmt+0x2a5>
  800940:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800944:	48 89 d0             	mov    %rdx,%rax
  800947:	48 83 c2 08          	add    $0x8,%rdx
  80094b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80094f:	4c 8b 20             	mov    (%rax),%r12
  800952:	4d 85 e4             	test   %r12,%r12
  800955:	75 0a                	jne    800961 <vprintfmt+0x2b7>
				p = "(null)";
  800957:	49 bc ed 38 80 00 00 	movabs $0x8038ed,%r12
  80095e:	00 00 00 
			if (width > 0 && padc != '-')
  800961:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800965:	7e 3f                	jle    8009a6 <vprintfmt+0x2fc>
  800967:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80096b:	74 39                	je     8009a6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80096d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800970:	48 98                	cltq   
  800972:	48 89 c6             	mov    %rax,%rsi
  800975:	4c 89 e7             	mov    %r12,%rdi
  800978:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  80097f:	00 00 00 
  800982:	ff d0                	callq  *%rax
  800984:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800987:	eb 17                	jmp    8009a0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800989:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80098d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800991:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800995:	48 89 ce             	mov    %rcx,%rsi
  800998:	89 d7                	mov    %edx,%edi
  80099a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a4:	7f e3                	jg     800989 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 37                	jmp    8009df <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ac:	74 1e                	je     8009cc <vprintfmt+0x322>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x30e>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 14                	jle    8009cc <vprintfmt+0x322>
					putch('?', putdat);
  8009b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c0:	48 89 d6             	mov    %rdx,%rsi
  8009c3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009c8:	ff d0                	callq  *%rax
  8009ca:	eb 0f                	jmp    8009db <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009cc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d4:	48 89 d6             	mov    %rdx,%rsi
  8009d7:	89 df                	mov    %ebx,%edi
  8009d9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009df:	4c 89 e0             	mov    %r12,%rax
  8009e2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009e6:	0f b6 00             	movzbl (%rax),%eax
  8009e9:	0f be d8             	movsbl %al,%ebx
  8009ec:	85 db                	test   %ebx,%ebx
  8009ee:	74 10                	je     800a00 <vprintfmt+0x356>
  8009f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009f4:	78 b2                	js     8009a8 <vprintfmt+0x2fe>
  8009f6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009fe:	79 a8                	jns    8009a8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a00:	eb 16                	jmp    800a18 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0a:	48 89 d6             	mov    %rdx,%rsi
  800a0d:	bf 20 00 00 00       	mov    $0x20,%edi
  800a12:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a14:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a18:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a1c:	7f e4                	jg     800a02 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a1e:	e9 a3 01 00 00       	jmpq   800bc6 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a23:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a27:	be 03 00 00 00       	mov    $0x3,%esi
  800a2c:	48 89 c7             	mov    %rax,%rdi
  800a2f:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  800a36:	00 00 00 
  800a39:	ff d0                	callq  *%rax
  800a3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	48 85 c0             	test   %rax,%rax
  800a46:	79 1d                	jns    800a65 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a50:	48 89 d6             	mov    %rdx,%rsi
  800a53:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a58:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	48 f7 d8             	neg    %rax
  800a61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a65:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a6c:	e9 e8 00 00 00       	jmpq   800b59 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a71:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a75:	be 03 00 00 00       	mov    $0x3,%esi
  800a7a:	48 89 c7             	mov    %rax,%rdi
  800a7d:	48 b8 8a 04 80 00 00 	movabs $0x80048a,%rax
  800a84:	00 00 00 
  800a87:	ff d0                	callq  *%rax
  800a89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a8d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a94:	e9 c0 00 00 00       	jmpq   800b59 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa1:	48 89 d6             	mov    %rdx,%rsi
  800aa4:	bf 58 00 00 00       	mov    $0x58,%edi
  800aa9:	ff d0                	callq  *%rax
			putch('X', putdat);
  800aab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aaf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab3:	48 89 d6             	mov    %rdx,%rsi
  800ab6:	bf 58 00 00 00       	mov    $0x58,%edi
  800abb:	ff d0                	callq  *%rax
			putch('X', putdat);
  800abd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac5:	48 89 d6             	mov    %rdx,%rsi
  800ac8:	bf 58 00 00 00       	mov    $0x58,%edi
  800acd:	ff d0                	callq  *%rax
			break;
  800acf:	e9 f2 00 00 00       	jmpq   800bc6 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ad4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adc:	48 89 d6             	mov    %rdx,%rsi
  800adf:	bf 30 00 00 00       	mov    $0x30,%edi
  800ae4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ae6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aee:	48 89 d6             	mov    %rdx,%rsi
  800af1:	bf 78 00 00 00       	mov    $0x78,%edi
  800af6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800af8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afb:	83 f8 30             	cmp    $0x30,%eax
  800afe:	73 17                	jae    800b17 <vprintfmt+0x46d>
  800b00:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b07:	89 c0                	mov    %eax,%eax
  800b09:	48 01 d0             	add    %rdx,%rax
  800b0c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0f:	83 c2 08             	add    $0x8,%edx
  800b12:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b15:	eb 0f                	jmp    800b26 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800b17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1b:	48 89 d0             	mov    %rdx,%rax
  800b1e:	48 83 c2 08          	add    $0x8,%rdx
  800b22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b26:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b2d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b34:	eb 23                	jmp    800b59 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b36:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b3a:	be 03 00 00 00       	mov    $0x3,%esi
  800b3f:	48 89 c7             	mov    %rax,%rdi
  800b42:	48 b8 8a 04 80 00 00 	movabs $0x80048a,%rax
  800b49:	00 00 00 
  800b4c:	ff d0                	callq  *%rax
  800b4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b52:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b59:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b5e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b61:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b68:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b70:	45 89 c1             	mov    %r8d,%r9d
  800b73:	41 89 f8             	mov    %edi,%r8d
  800b76:	48 89 c7             	mov    %rax,%rdi
  800b79:	48 b8 cf 03 80 00 00 	movabs $0x8003cf,%rax
  800b80:	00 00 00 
  800b83:	ff d0                	callq  *%rax
			break;
  800b85:	eb 3f                	jmp    800bc6 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8f:	48 89 d6             	mov    %rdx,%rsi
  800b92:	89 df                	mov    %ebx,%edi
  800b94:	ff d0                	callq  *%rax
			break;
  800b96:	eb 2e                	jmp    800bc6 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba0:	48 89 d6             	mov    %rdx,%rsi
  800ba3:	bf 25 00 00 00       	mov    $0x25,%edi
  800ba8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800baa:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800baf:	eb 05                	jmp    800bb6 <vprintfmt+0x50c>
  800bb1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bb6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bba:	48 83 e8 01          	sub    $0x1,%rax
  800bbe:	0f b6 00             	movzbl (%rax),%eax
  800bc1:	3c 25                	cmp    $0x25,%al
  800bc3:	75 ec                	jne    800bb1 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800bc5:	90                   	nop
		}
	}
  800bc6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc7:	e9 30 fb ff ff       	jmpq   8006fc <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bcc:	48 83 c4 60          	add    $0x60,%rsp
  800bd0:	5b                   	pop    %rbx
  800bd1:	41 5c                	pop    %r12
  800bd3:	5d                   	pop    %rbp
  800bd4:	c3                   	retq   

0000000000800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %rbp
  800bd6:	48 89 e5             	mov    %rsp,%rbp
  800bd9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800be0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800be7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bee:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bf5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bfc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c03:	84 c0                	test   %al,%al
  800c05:	74 20                	je     800c27 <printfmt+0x52>
  800c07:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c0b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c0f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c13:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c17:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c1b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c1f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c23:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c27:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c2e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c35:	00 00 00 
  800c38:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c3f:	00 00 00 
  800c42:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c46:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c4d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c54:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c62:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c69:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c70:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c77:	48 89 c7             	mov    %rax,%rdi
  800c7a:	48 b8 aa 06 80 00 00 	movabs $0x8006aa,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c86:	c9                   	leaveq 
  800c87:	c3                   	retq   

0000000000800c88 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c88:	55                   	push   %rbp
  800c89:	48 89 e5             	mov    %rsp,%rbp
  800c8c:	48 83 ec 10          	sub    $0x10,%rsp
  800c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9b:	8b 40 10             	mov    0x10(%rax),%eax
  800c9e:	8d 50 01             	lea    0x1(%rax),%edx
  800ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cac:	48 8b 10             	mov    (%rax),%rdx
  800caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cb7:	48 39 c2             	cmp    %rax,%rdx
  800cba:	73 17                	jae    800cd3 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc0:	48 8b 00             	mov    (%rax),%rax
  800cc3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ccb:	48 89 0a             	mov    %rcx,(%rdx)
  800cce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cd1:	88 10                	mov    %dl,(%rax)
}
  800cd3:	c9                   	leaveq 
  800cd4:	c3                   	retq   

0000000000800cd5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cd5:	55                   	push   %rbp
  800cd6:	48 89 e5             	mov    %rsp,%rbp
  800cd9:	48 83 ec 50          	sub    $0x50,%rsp
  800cdd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ce1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ce4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ce8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cec:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cf0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cf4:	48 8b 0a             	mov    (%rdx),%rcx
  800cf7:	48 89 08             	mov    %rcx,(%rax)
  800cfa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cfe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d02:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d06:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d0e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d12:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d15:	48 98                	cltq   
  800d17:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d1b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d1f:	48 01 d0             	add    %rdx,%rax
  800d22:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d2d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d32:	74 06                	je     800d3a <vsnprintf+0x65>
  800d34:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d38:	7f 07                	jg     800d41 <vsnprintf+0x6c>
		return -E_INVAL;
  800d3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d3f:	eb 2f                	jmp    800d70 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d41:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d45:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d49:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d4d:	48 89 c6             	mov    %rax,%rsi
  800d50:	48 bf 88 0c 80 00 00 	movabs $0x800c88,%rdi
  800d57:	00 00 00 
  800d5a:	48 b8 aa 06 80 00 00 	movabs $0x8006aa,%rax
  800d61:	00 00 00 
  800d64:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d6a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d6d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d70:	c9                   	leaveq 
  800d71:	c3                   	retq   

0000000000800d72 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d72:	55                   	push   %rbp
  800d73:	48 89 e5             	mov    %rsp,%rbp
  800d76:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d7d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d84:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d8a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d91:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d98:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d9f:	84 c0                	test   %al,%al
  800da1:	74 20                	je     800dc3 <snprintf+0x51>
  800da3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800da7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dab:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800daf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800db3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800db7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dbb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dbf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dc3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dca:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dd1:	00 00 00 
  800dd4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ddb:	00 00 00 
  800dde:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800de9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800df0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800df7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dfe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e05:	48 8b 0a             	mov    (%rdx),%rcx
  800e08:	48 89 08             	mov    %rcx,(%rax)
  800e0b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e0f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e13:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e17:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e1b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e22:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e29:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e2f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e36:	48 89 c7             	mov    %rax,%rdi
  800e39:	48 b8 d5 0c 80 00 00 	movabs $0x800cd5,%rax
  800e40:	00 00 00 
  800e43:	ff d0                	callq  *%rax
  800e45:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e4b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e51:	c9                   	leaveq 
  800e52:	c3                   	retq   

0000000000800e53 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e53:	55                   	push   %rbp
  800e54:	48 89 e5             	mov    %rsp,%rbp
  800e57:	48 83 ec 18          	sub    $0x18,%rsp
  800e5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e66:	eb 09                	jmp    800e71 <strlen+0x1e>
		n++;
  800e68:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e75:	0f b6 00             	movzbl (%rax),%eax
  800e78:	84 c0                	test   %al,%al
  800e7a:	75 ec                	jne    800e68 <strlen+0x15>
		n++;
	return n;
  800e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e7f:	c9                   	leaveq 
  800e80:	c3                   	retq   

0000000000800e81 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e81:	55                   	push   %rbp
  800e82:	48 89 e5             	mov    %rsp,%rbp
  800e85:	48 83 ec 20          	sub    $0x20,%rsp
  800e89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e98:	eb 0e                	jmp    800ea8 <strnlen+0x27>
		n++;
  800e9a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ea3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ea8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ead:	74 0b                	je     800eba <strnlen+0x39>
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb3:	0f b6 00             	movzbl (%rax),%eax
  800eb6:	84 c0                	test   %al,%al
  800eb8:	75 e0                	jne    800e9a <strnlen+0x19>
		n++;
	return n;
  800eba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ebd:	c9                   	leaveq 
  800ebe:	c3                   	retq   

0000000000800ebf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ebf:	55                   	push   %rbp
  800ec0:	48 89 e5             	mov    %rsp,%rbp
  800ec3:	48 83 ec 20          	sub    $0x20,%rsp
  800ec7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ecb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ed7:	90                   	nop
  800ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ee0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ee4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ee8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800eec:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ef0:	0f b6 12             	movzbl (%rdx),%edx
  800ef3:	88 10                	mov    %dl,(%rax)
  800ef5:	0f b6 00             	movzbl (%rax),%eax
  800ef8:	84 c0                	test   %al,%al
  800efa:	75 dc                	jne    800ed8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800efc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f00:	c9                   	leaveq 
  800f01:	c3                   	retq   

0000000000800f02 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f02:	55                   	push   %rbp
  800f03:	48 89 e5             	mov    %rsp,%rbp
  800f06:	48 83 ec 20          	sub    $0x20,%rsp
  800f0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f16:	48 89 c7             	mov    %rax,%rdi
  800f19:	48 b8 53 0e 80 00 00 	movabs $0x800e53,%rax
  800f20:	00 00 00 
  800f23:	ff d0                	callq  *%rax
  800f25:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2b:	48 63 d0             	movslq %eax,%rdx
  800f2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f32:	48 01 c2             	add    %rax,%rdx
  800f35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f39:	48 89 c6             	mov    %rax,%rsi
  800f3c:	48 89 d7             	mov    %rdx,%rdi
  800f3f:	48 b8 bf 0e 80 00 00 	movabs $0x800ebf,%rax
  800f46:	00 00 00 
  800f49:	ff d0                	callq  *%rax
	return dst;
  800f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f4f:	c9                   	leaveq 
  800f50:	c3                   	retq   

0000000000800f51 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f51:	55                   	push   %rbp
  800f52:	48 89 e5             	mov    %rsp,%rbp
  800f55:	48 83 ec 28          	sub    $0x28,%rsp
  800f59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f61:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f69:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f6d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f74:	00 
  800f75:	eb 2a                	jmp    800fa1 <strncpy+0x50>
		*dst++ = *src;
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f87:	0f b6 12             	movzbl (%rdx),%edx
  800f8a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f90:	0f b6 00             	movzbl (%rax),%eax
  800f93:	84 c0                	test   %al,%al
  800f95:	74 05                	je     800f9c <strncpy+0x4b>
			src++;
  800f97:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f9c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fa9:	72 cc                	jb     800f77 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800faf:	c9                   	leaveq 
  800fb0:	c3                   	retq   

0000000000800fb1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fb1:	55                   	push   %rbp
  800fb2:	48 89 e5             	mov    %rsp,%rbp
  800fb5:	48 83 ec 28          	sub    $0x28,%rsp
  800fb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fbd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fc1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fcd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fd2:	74 3d                	je     801011 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fd4:	eb 1d                	jmp    800ff3 <strlcpy+0x42>
			*dst++ = *src++;
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fde:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fe2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fe6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fea:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fee:	0f b6 12             	movzbl (%rdx),%edx
  800ff1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ff3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800ff8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ffd:	74 0b                	je     80100a <strlcpy+0x59>
  800fff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801003:	0f b6 00             	movzbl (%rax),%eax
  801006:	84 c0                	test   %al,%al
  801008:	75 cc                	jne    800fd6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80100a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801011:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801019:	48 29 c2             	sub    %rax,%rdx
  80101c:	48 89 d0             	mov    %rdx,%rax
}
  80101f:	c9                   	leaveq 
  801020:	c3                   	retq   

0000000000801021 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801021:	55                   	push   %rbp
  801022:	48 89 e5             	mov    %rsp,%rbp
  801025:	48 83 ec 10          	sub    $0x10,%rsp
  801029:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80102d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801031:	eb 0a                	jmp    80103d <strcmp+0x1c>
		p++, q++;
  801033:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801038:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80103d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801041:	0f b6 00             	movzbl (%rax),%eax
  801044:	84 c0                	test   %al,%al
  801046:	74 12                	je     80105a <strcmp+0x39>
  801048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104c:	0f b6 10             	movzbl (%rax),%edx
  80104f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801053:	0f b6 00             	movzbl (%rax),%eax
  801056:	38 c2                	cmp    %al,%dl
  801058:	74 d9                	je     801033 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80105a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105e:	0f b6 00             	movzbl (%rax),%eax
  801061:	0f b6 d0             	movzbl %al,%edx
  801064:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801068:	0f b6 00             	movzbl (%rax),%eax
  80106b:	0f b6 c0             	movzbl %al,%eax
  80106e:	29 c2                	sub    %eax,%edx
  801070:	89 d0                	mov    %edx,%eax
}
  801072:	c9                   	leaveq 
  801073:	c3                   	retq   

0000000000801074 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801074:	55                   	push   %rbp
  801075:	48 89 e5             	mov    %rsp,%rbp
  801078:	48 83 ec 18          	sub    $0x18,%rsp
  80107c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801080:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801084:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801088:	eb 0f                	jmp    801099 <strncmp+0x25>
		n--, p++, q++;
  80108a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80108f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801094:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801099:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80109e:	74 1d                	je     8010bd <strncmp+0x49>
  8010a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a4:	0f b6 00             	movzbl (%rax),%eax
  8010a7:	84 c0                	test   %al,%al
  8010a9:	74 12                	je     8010bd <strncmp+0x49>
  8010ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010af:	0f b6 10             	movzbl (%rax),%edx
  8010b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	38 c2                	cmp    %al,%dl
  8010bb:	74 cd                	je     80108a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010c2:	75 07                	jne    8010cb <strncmp+0x57>
		return 0;
  8010c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c9:	eb 18                	jmp    8010e3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cf:	0f b6 00             	movzbl (%rax),%eax
  8010d2:	0f b6 d0             	movzbl %al,%edx
  8010d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	0f b6 c0             	movzbl %al,%eax
  8010df:	29 c2                	sub    %eax,%edx
  8010e1:	89 d0                	mov    %edx,%eax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 0c          	sub    $0xc,%rsp
  8010ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010f1:	89 f0                	mov    %esi,%eax
  8010f3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010f6:	eb 17                	jmp    80110f <strchr+0x2a>
		if (*s == c)
  8010f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fc:	0f b6 00             	movzbl (%rax),%eax
  8010ff:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801102:	75 06                	jne    80110a <strchr+0x25>
			return (char *) s;
  801104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801108:	eb 15                	jmp    80111f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80110a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80110f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	84 c0                	test   %al,%al
  801118:	75 de                	jne    8010f8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80111a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111f:	c9                   	leaveq 
  801120:	c3                   	retq   

0000000000801121 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801121:	55                   	push   %rbp
  801122:	48 89 e5             	mov    %rsp,%rbp
  801125:	48 83 ec 0c          	sub    $0xc,%rsp
  801129:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80112d:	89 f0                	mov    %esi,%eax
  80112f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801132:	eb 13                	jmp    801147 <strfind+0x26>
		if (*s == c)
  801134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801138:	0f b6 00             	movzbl (%rax),%eax
  80113b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80113e:	75 02                	jne    801142 <strfind+0x21>
			break;
  801140:	eb 10                	jmp    801152 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801142:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114b:	0f b6 00             	movzbl (%rax),%eax
  80114e:	84 c0                	test   %al,%al
  801150:	75 e2                	jne    801134 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 18          	sub    $0x18,%rsp
  801160:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801164:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801167:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80116b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801170:	75 06                	jne    801178 <memset+0x20>
		return v;
  801172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801176:	eb 69                	jmp    8011e1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117c:	83 e0 03             	and    $0x3,%eax
  80117f:	48 85 c0             	test   %rax,%rax
  801182:	75 48                	jne    8011cc <memset+0x74>
  801184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801188:	83 e0 03             	and    $0x3,%eax
  80118b:	48 85 c0             	test   %rax,%rax
  80118e:	75 3c                	jne    8011cc <memset+0x74>
		c &= 0xFF;
  801190:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801197:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80119a:	c1 e0 18             	shl    $0x18,%eax
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a2:	c1 e0 10             	shl    $0x10,%eax
  8011a5:	09 c2                	or     %eax,%edx
  8011a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011aa:	c1 e0 08             	shl    $0x8,%eax
  8011ad:	09 d0                	or     %edx,%eax
  8011af:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b6:	48 c1 e8 02          	shr    $0x2,%rax
  8011ba:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c4:	48 89 d7             	mov    %rdx,%rdi
  8011c7:	fc                   	cld    
  8011c8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011ca:	eb 11                	jmp    8011dd <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011d7:	48 89 d7             	mov    %rdx,%rdi
  8011da:	fc                   	cld    
  8011db:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011e1:	c9                   	leaveq 
  8011e2:	c3                   	retq   

00000000008011e3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011e3:	55                   	push   %rbp
  8011e4:	48 89 e5             	mov    %rsp,%rbp
  8011e7:	48 83 ec 28          	sub    $0x28,%rsp
  8011eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801203:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80120f:	0f 83 88 00 00 00    	jae    80129d <memmove+0xba>
  801215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801219:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80121d:	48 01 d0             	add    %rdx,%rax
  801220:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801224:	76 77                	jbe    80129d <memmove+0xba>
		s += n;
  801226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80122e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801232:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123a:	83 e0 03             	and    $0x3,%eax
  80123d:	48 85 c0             	test   %rax,%rax
  801240:	75 3b                	jne    80127d <memmove+0x9a>
  801242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801246:	83 e0 03             	and    $0x3,%eax
  801249:	48 85 c0             	test   %rax,%rax
  80124c:	75 2f                	jne    80127d <memmove+0x9a>
  80124e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801252:	83 e0 03             	and    $0x3,%eax
  801255:	48 85 c0             	test   %rax,%rax
  801258:	75 23                	jne    80127d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80125a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125e:	48 83 e8 04          	sub    $0x4,%rax
  801262:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801266:	48 83 ea 04          	sub    $0x4,%rdx
  80126a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80126e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801272:	48 89 c7             	mov    %rax,%rdi
  801275:	48 89 d6             	mov    %rdx,%rsi
  801278:	fd                   	std    
  801279:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80127b:	eb 1d                	jmp    80129a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801281:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80128d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801291:	48 89 d7             	mov    %rdx,%rdi
  801294:	48 89 c1             	mov    %rax,%rcx
  801297:	fd                   	std    
  801298:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80129a:	fc                   	cld    
  80129b:	eb 57                	jmp    8012f4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80129d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a1:	83 e0 03             	and    $0x3,%eax
  8012a4:	48 85 c0             	test   %rax,%rax
  8012a7:	75 36                	jne    8012df <memmove+0xfc>
  8012a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ad:	83 e0 03             	and    $0x3,%eax
  8012b0:	48 85 c0             	test   %rax,%rax
  8012b3:	75 2a                	jne    8012df <memmove+0xfc>
  8012b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b9:	83 e0 03             	and    $0x3,%eax
  8012bc:	48 85 c0             	test   %rax,%rax
  8012bf:	75 1e                	jne    8012df <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c5:	48 c1 e8 02          	shr    $0x2,%rax
  8012c9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012d4:	48 89 c7             	mov    %rax,%rdi
  8012d7:	48 89 d6             	mov    %rdx,%rsi
  8012da:	fc                   	cld    
  8012db:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012dd:	eb 15                	jmp    8012f4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012eb:	48 89 c7             	mov    %rax,%rdi
  8012ee:	48 89 d6             	mov    %rdx,%rsi
  8012f1:	fc                   	cld    
  8012f2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012f8:	c9                   	leaveq 
  8012f9:	c3                   	retq   

00000000008012fa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012fa:	55                   	push   %rbp
  8012fb:	48 89 e5             	mov    %rsp,%rbp
  8012fe:	48 83 ec 18          	sub    $0x18,%rsp
  801302:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801306:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80130a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80130e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801312:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	48 89 ce             	mov    %rcx,%rsi
  80131d:	48 89 c7             	mov    %rax,%rdi
  801320:	48 b8 e3 11 80 00 00 	movabs $0x8011e3,%rax
  801327:	00 00 00 
  80132a:	ff d0                	callq  *%rax
}
  80132c:	c9                   	leaveq 
  80132d:	c3                   	retq   

000000000080132e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80132e:	55                   	push   %rbp
  80132f:	48 89 e5             	mov    %rsp,%rbp
  801332:	48 83 ec 28          	sub    $0x28,%rsp
  801336:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80133e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801346:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80134a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80134e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801352:	eb 36                	jmp    80138a <memcmp+0x5c>
		if (*s1 != *s2)
  801354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801358:	0f b6 10             	movzbl (%rax),%edx
  80135b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135f:	0f b6 00             	movzbl (%rax),%eax
  801362:	38 c2                	cmp    %al,%dl
  801364:	74 1a                	je     801380 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	0f b6 d0             	movzbl %al,%edx
  801370:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801374:	0f b6 00             	movzbl (%rax),%eax
  801377:	0f b6 c0             	movzbl %al,%eax
  80137a:	29 c2                	sub    %eax,%edx
  80137c:	89 d0                	mov    %edx,%eax
  80137e:	eb 20                	jmp    8013a0 <memcmp+0x72>
		s1++, s2++;
  801380:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801385:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801392:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801396:	48 85 c0             	test   %rax,%rax
  801399:	75 b9                	jne    801354 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a0:	c9                   	leaveq 
  8013a1:	c3                   	retq   

00000000008013a2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013a2:	55                   	push   %rbp
  8013a3:	48 89 e5             	mov    %rsp,%rbp
  8013a6:	48 83 ec 28          	sub    $0x28,%rsp
  8013aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ae:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013bd:	48 01 d0             	add    %rdx,%rax
  8013c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013c4:	eb 15                	jmp    8013db <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ca:	0f b6 10             	movzbl (%rax),%edx
  8013cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013d0:	38 c2                	cmp    %al,%dl
  8013d2:	75 02                	jne    8013d6 <memfind+0x34>
			break;
  8013d4:	eb 0f                	jmp    8013e5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013d6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013df:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013e3:	72 e1                	jb     8013c6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013e9:	c9                   	leaveq 
  8013ea:	c3                   	retq   

00000000008013eb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013eb:	55                   	push   %rbp
  8013ec:	48 89 e5             	mov    %rsp,%rbp
  8013ef:	48 83 ec 34          	sub    $0x34,%rsp
  8013f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013fb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801405:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80140c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80140d:	eb 05                	jmp    801414 <strtol+0x29>
		s++;
  80140f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	3c 20                	cmp    $0x20,%al
  80141d:	74 f0                	je     80140f <strtol+0x24>
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	3c 09                	cmp    $0x9,%al
  801428:	74 e5                	je     80140f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	3c 2b                	cmp    $0x2b,%al
  801433:	75 07                	jne    80143c <strtol+0x51>
		s++;
  801435:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80143a:	eb 17                	jmp    801453 <strtol+0x68>
	else if (*s == '-')
  80143c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	3c 2d                	cmp    $0x2d,%al
  801445:	75 0c                	jne    801453 <strtol+0x68>
		s++, neg = 1;
  801447:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80144c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801453:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801457:	74 06                	je     80145f <strtol+0x74>
  801459:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80145d:	75 28                	jne    801487 <strtol+0x9c>
  80145f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	3c 30                	cmp    $0x30,%al
  801468:	75 1d                	jne    801487 <strtol+0x9c>
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	48 83 c0 01          	add    $0x1,%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	3c 78                	cmp    $0x78,%al
  801477:	75 0e                	jne    801487 <strtol+0x9c>
		s += 2, base = 16;
  801479:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80147e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801485:	eb 2c                	jmp    8014b3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801487:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80148b:	75 19                	jne    8014a6 <strtol+0xbb>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	3c 30                	cmp    $0x30,%al
  801496:	75 0e                	jne    8014a6 <strtol+0xbb>
		s++, base = 8;
  801498:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80149d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014a4:	eb 0d                	jmp    8014b3 <strtol+0xc8>
	else if (base == 0)
  8014a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014aa:	75 07                	jne    8014b3 <strtol+0xc8>
		base = 10;
  8014ac:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	0f b6 00             	movzbl (%rax),%eax
  8014ba:	3c 2f                	cmp    $0x2f,%al
  8014bc:	7e 1d                	jle    8014db <strtol+0xf0>
  8014be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	3c 39                	cmp    $0x39,%al
  8014c7:	7f 12                	jg     8014db <strtol+0xf0>
			dig = *s - '0';
  8014c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cd:	0f b6 00             	movzbl (%rax),%eax
  8014d0:	0f be c0             	movsbl %al,%eax
  8014d3:	83 e8 30             	sub    $0x30,%eax
  8014d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014d9:	eb 4e                	jmp    801529 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	3c 60                	cmp    $0x60,%al
  8014e4:	7e 1d                	jle    801503 <strtol+0x118>
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	3c 7a                	cmp    $0x7a,%al
  8014ef:	7f 12                	jg     801503 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	0f b6 00             	movzbl (%rax),%eax
  8014f8:	0f be c0             	movsbl %al,%eax
  8014fb:	83 e8 57             	sub    $0x57,%eax
  8014fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801501:	eb 26                	jmp    801529 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	3c 40                	cmp    $0x40,%al
  80150c:	7e 48                	jle    801556 <strtol+0x16b>
  80150e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	3c 5a                	cmp    $0x5a,%al
  801517:	7f 3d                	jg     801556 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151d:	0f b6 00             	movzbl (%rax),%eax
  801520:	0f be c0             	movsbl %al,%eax
  801523:	83 e8 37             	sub    $0x37,%eax
  801526:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801529:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80152c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80152f:	7c 02                	jl     801533 <strtol+0x148>
			break;
  801531:	eb 23                	jmp    801556 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801533:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801538:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80153b:	48 98                	cltq   
  80153d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801542:	48 89 c2             	mov    %rax,%rdx
  801545:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801548:	48 98                	cltq   
  80154a:	48 01 d0             	add    %rdx,%rax
  80154d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801551:	e9 5d ff ff ff       	jmpq   8014b3 <strtol+0xc8>

	if (endptr)
  801556:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80155b:	74 0b                	je     801568 <strtol+0x17d>
		*endptr = (char *) s;
  80155d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801561:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801565:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801568:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80156c:	74 09                	je     801577 <strtol+0x18c>
  80156e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801572:	48 f7 d8             	neg    %rax
  801575:	eb 04                	jmp    80157b <strtol+0x190>
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <strstr>:

char * strstr(const char *in, const char *str)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 83 ec 30          	sub    $0x30,%rsp
  801585:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801589:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80158d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801591:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801595:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801599:	0f b6 00             	movzbl (%rax),%eax
  80159c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80159f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015a3:	75 06                	jne    8015ab <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a9:	eb 6b                	jmp    801616 <strstr+0x99>

	len = strlen(str);
  8015ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015af:	48 89 c7             	mov    %rax,%rdi
  8015b2:	48 b8 53 0e 80 00 00 	movabs $0x800e53,%rax
  8015b9:	00 00 00 
  8015bc:	ff d0                	callq  *%rax
  8015be:	48 98                	cltq   
  8015c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015d0:	0f b6 00             	movzbl (%rax),%eax
  8015d3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015d6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015da:	75 07                	jne    8015e3 <strstr+0x66>
				return (char *) 0;
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e1:	eb 33                	jmp    801616 <strstr+0x99>
		} while (sc != c);
  8015e3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015e7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015ea:	75 d8                	jne    8015c4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015f0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	48 89 ce             	mov    %rcx,%rsi
  8015fb:	48 89 c7             	mov    %rax,%rdi
  8015fe:	48 b8 74 10 80 00 00 	movabs $0x801074,%rax
  801605:	00 00 00 
  801608:	ff d0                	callq  *%rax
  80160a:	85 c0                	test   %eax,%eax
  80160c:	75 b6                	jne    8015c4 <strstr+0x47>

	return (char *) (in - 1);
  80160e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801612:	48 83 e8 01          	sub    $0x1,%rax
}
  801616:	c9                   	leaveq 
  801617:	c3                   	retq   

0000000000801618 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801618:	55                   	push   %rbp
  801619:	48 89 e5             	mov    %rsp,%rbp
  80161c:	53                   	push   %rbx
  80161d:	48 83 ec 48          	sub    $0x48,%rsp
  801621:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801624:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801627:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80162b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80162f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801633:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801637:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80163a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80163e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801642:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801646:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80164a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80164e:	4c 89 c3             	mov    %r8,%rbx
  801651:	cd 30                	int    $0x30
  801653:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801657:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80165b:	74 3e                	je     80169b <syscall+0x83>
  80165d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801662:	7e 37                	jle    80169b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801668:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80166b:	49 89 d0             	mov    %rdx,%r8
  80166e:	89 c1                	mov    %eax,%ecx
  801670:	48 ba a8 3b 80 00 00 	movabs $0x803ba8,%rdx
  801677:	00 00 00 
  80167a:	be 23 00 00 00       	mov    $0x23,%esi
  80167f:	48 bf c5 3b 80 00 00 	movabs $0x803bc5,%rdi
  801686:	00 00 00 
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
  80168e:	49 b9 fb 34 80 00 00 	movabs $0x8034fb,%r9
  801695:	00 00 00 
  801698:	41 ff d1             	callq  *%r9

	return ret;
  80169b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80169f:	48 83 c4 48          	add    $0x48,%rsp
  8016a3:	5b                   	pop    %rbx
  8016a4:	5d                   	pop    %rbp
  8016a5:	c3                   	retq   

00000000008016a6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016a6:	55                   	push   %rbp
  8016a7:	48 89 e5             	mov    %rsp,%rbp
  8016aa:	48 83 ec 20          	sub    $0x20,%rsp
  8016ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016c5:	00 
  8016c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016d2:	48 89 d1             	mov    %rdx,%rcx
  8016d5:	48 89 c2             	mov    %rax,%rdx
  8016d8:	be 00 00 00 00       	mov    $0x0,%esi
  8016dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8016e2:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  8016e9:	00 00 00 
  8016ec:	ff d0                	callq  *%rax
}
  8016ee:	c9                   	leaveq 
  8016ef:	c3                   	retq   

00000000008016f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016f0:	55                   	push   %rbp
  8016f1:	48 89 e5             	mov    %rsp,%rbp
  8016f4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ff:	00 
  801700:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801706:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80170c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801711:	ba 00 00 00 00       	mov    $0x0,%edx
  801716:	be 00 00 00 00       	mov    $0x0,%esi
  80171b:	bf 01 00 00 00       	mov    $0x1,%edi
  801720:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  801727:	00 00 00 
  80172a:	ff d0                	callq  *%rax
}
  80172c:	c9                   	leaveq 
  80172d:	c3                   	retq   

000000000080172e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80172e:	55                   	push   %rbp
  80172f:	48 89 e5             	mov    %rsp,%rbp
  801732:	48 83 ec 10          	sub    $0x10,%rsp
  801736:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80173c:	48 98                	cltq   
  80173e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801745:	00 
  801746:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80174c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801752:	b9 00 00 00 00       	mov    $0x0,%ecx
  801757:	48 89 c2             	mov    %rax,%rdx
  80175a:	be 01 00 00 00       	mov    $0x1,%esi
  80175f:	bf 03 00 00 00       	mov    $0x3,%edi
  801764:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  80176b:	00 00 00 
  80176e:	ff d0                	callq  *%rax
}
  801770:	c9                   	leaveq 
  801771:	c3                   	retq   

0000000000801772 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801772:	55                   	push   %rbp
  801773:	48 89 e5             	mov    %rsp,%rbp
  801776:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80177a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801781:	00 
  801782:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801788:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80178e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801793:	ba 00 00 00 00       	mov    $0x0,%edx
  801798:	be 00 00 00 00       	mov    $0x0,%esi
  80179d:	bf 02 00 00 00       	mov    $0x2,%edi
  8017a2:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  8017a9:	00 00 00 
  8017ac:	ff d0                	callq  *%rax
}
  8017ae:	c9                   	leaveq 
  8017af:	c3                   	retq   

00000000008017b0 <sys_yield>:

void
sys_yield(void)
{
  8017b0:	55                   	push   %rbp
  8017b1:	48 89 e5             	mov    %rsp,%rbp
  8017b4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bf:	00 
  8017c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d6:	be 00 00 00 00       	mov    $0x0,%esi
  8017db:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017e0:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  8017e7:	00 00 00 
  8017ea:	ff d0                	callq  *%rax
}
  8017ec:	c9                   	leaveq 
  8017ed:	c3                   	retq   

00000000008017ee <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ee:	55                   	push   %rbp
  8017ef:	48 89 e5             	mov    %rsp,%rbp
  8017f2:	48 83 ec 20          	sub    $0x20,%rsp
  8017f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017fd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801800:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801803:	48 63 c8             	movslq %eax,%rcx
  801806:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80180d:	48 98                	cltq   
  80180f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801816:	00 
  801817:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80181d:	49 89 c8             	mov    %rcx,%r8
  801820:	48 89 d1             	mov    %rdx,%rcx
  801823:	48 89 c2             	mov    %rax,%rdx
  801826:	be 01 00 00 00       	mov    $0x1,%esi
  80182b:	bf 04 00 00 00       	mov    $0x4,%edi
  801830:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  801837:	00 00 00 
  80183a:	ff d0                	callq  *%rax
}
  80183c:	c9                   	leaveq 
  80183d:	c3                   	retq   

000000000080183e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80183e:	55                   	push   %rbp
  80183f:	48 89 e5             	mov    %rsp,%rbp
  801842:	48 83 ec 30          	sub    $0x30,%rsp
  801846:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801849:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80184d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801850:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801854:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801858:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80185b:	48 63 c8             	movslq %eax,%rcx
  80185e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801862:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801865:	48 63 f0             	movslq %eax,%rsi
  801868:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 89 0c 24          	mov    %rcx,(%rsp)
  801875:	49 89 f9             	mov    %rdi,%r9
  801878:	49 89 f0             	mov    %rsi,%r8
  80187b:	48 89 d1             	mov    %rdx,%rcx
  80187e:	48 89 c2             	mov    %rax,%rdx
  801881:	be 01 00 00 00       	mov    $0x1,%esi
  801886:	bf 05 00 00 00       	mov    $0x5,%edi
  80188b:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  801892:	00 00 00 
  801895:	ff d0                	callq  *%rax
}
  801897:	c9                   	leaveq 
  801898:	c3                   	retq   

0000000000801899 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801899:	55                   	push   %rbp
  80189a:	48 89 e5             	mov    %rsp,%rbp
  80189d:	48 83 ec 20          	sub    $0x20,%rsp
  8018a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018af:	48 98                	cltq   
  8018b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b8:	00 
  8018b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c5:	48 89 d1             	mov    %rdx,%rcx
  8018c8:	48 89 c2             	mov    %rax,%rdx
  8018cb:	be 01 00 00 00       	mov    $0x1,%esi
  8018d0:	bf 06 00 00 00       	mov    $0x6,%edi
  8018d5:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	callq  *%rax
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 10          	sub    $0x10,%rsp
  8018eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ee:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018f4:	48 63 d0             	movslq %eax,%rdx
  8018f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018fa:	48 98                	cltq   
  8018fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801903:	00 
  801904:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801910:	48 89 d1             	mov    %rdx,%rcx
  801913:	48 89 c2             	mov    %rax,%rdx
  801916:	be 01 00 00 00       	mov    $0x1,%esi
  80191b:	bf 08 00 00 00       	mov    $0x8,%edi
  801920:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  801927:	00 00 00 
  80192a:	ff d0                	callq  *%rax
}
  80192c:	c9                   	leaveq 
  80192d:	c3                   	retq   

000000000080192e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80192e:	55                   	push   %rbp
  80192f:	48 89 e5             	mov    %rsp,%rbp
  801932:	48 83 ec 20          	sub    $0x20,%rsp
  801936:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801939:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80193d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801944:	48 98                	cltq   
  801946:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194d:	00 
  80194e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801954:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195a:	48 89 d1             	mov    %rdx,%rcx
  80195d:	48 89 c2             	mov    %rax,%rdx
  801960:	be 01 00 00 00       	mov    $0x1,%esi
  801965:	bf 09 00 00 00       	mov    $0x9,%edi
  80196a:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  801971:	00 00 00 
  801974:	ff d0                	callq  *%rax
}
  801976:	c9                   	leaveq 
  801977:	c3                   	retq   

0000000000801978 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	48 83 ec 20          	sub    $0x20,%rsp
  801980:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801983:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801987:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198e:	48 98                	cltq   
  801990:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801997:	00 
  801998:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a4:	48 89 d1             	mov    %rdx,%rcx
  8019a7:	48 89 c2             	mov    %rax,%rdx
  8019aa:	be 01 00 00 00       	mov    $0x1,%esi
  8019af:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019b4:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  8019bb:	00 00 00 
  8019be:	ff d0                	callq  *%rax
}
  8019c0:	c9                   	leaveq 
  8019c1:	c3                   	retq   

00000000008019c2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019c2:	55                   	push   %rbp
  8019c3:	48 89 e5             	mov    %rsp,%rbp
  8019c6:	48 83 ec 20          	sub    $0x20,%rsp
  8019ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019d5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019db:	48 63 f0             	movslq %eax,%rsi
  8019de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e5:	48 98                	cltq   
  8019e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f2:	00 
  8019f3:	49 89 f1             	mov    %rsi,%r9
  8019f6:	49 89 c8             	mov    %rcx,%r8
  8019f9:	48 89 d1             	mov    %rdx,%rcx
  8019fc:	48 89 c2             	mov    %rax,%rdx
  8019ff:	be 00 00 00 00       	mov    $0x0,%esi
  801a04:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a09:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  801a10:	00 00 00 
  801a13:	ff d0                	callq  *%rax
}
  801a15:	c9                   	leaveq 
  801a16:	c3                   	retq   

0000000000801a17 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a17:	55                   	push   %rbp
  801a18:	48 89 e5             	mov    %rsp,%rbp
  801a1b:	48 83 ec 10          	sub    $0x10,%rsp
  801a1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2e:	00 
  801a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a40:	48 89 c2             	mov    %rax,%rdx
  801a43:	be 01 00 00 00       	mov    $0x1,%esi
  801a48:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a4d:	48 b8 18 16 80 00 00 	movabs $0x801618,%rax
  801a54:	00 00 00 
  801a57:	ff d0                	callq  *%rax
}
  801a59:	c9                   	leaveq 
  801a5a:	c3                   	retq   

0000000000801a5b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a5b:	55                   	push   %rbp
  801a5c:	48 89 e5             	mov    %rsp,%rbp
  801a5f:	48 83 ec 30          	sub    $0x30,%rsp
  801a63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a6b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  801a6f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a74:	75 0e                	jne    801a84 <ipc_recv+0x29>
        pg = (void *)UTOP;
  801a76:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801a7d:	00 00 00 
  801a80:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  801a84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a88:	48 89 c7             	mov    %rax,%rdi
  801a8b:	48 b8 17 1a 80 00 00 	movabs $0x801a17,%rax
  801a92:	00 00 00 
  801a95:	ff d0                	callq  *%rax
  801a97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a9e:	79 27                	jns    801ac7 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  801aa0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aa5:	74 0a                	je     801ab1 <ipc_recv+0x56>
            *from_env_store = 0;
  801aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aab:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  801ab1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ab6:	74 0a                	je     801ac2 <ipc_recv+0x67>
            *perm_store = 0;
  801ab8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  801ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac5:	eb 53                	jmp    801b1a <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  801ac7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801acc:	74 19                	je     801ae7 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  801ace:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801ad5:	00 00 00 
  801ad8:	48 8b 00             	mov    (%rax),%rax
  801adb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae5:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  801ae7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801aec:	74 19                	je     801b07 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  801aee:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801af5:	00 00 00 
  801af8:	48 8b 00             	mov    (%rax),%rax
  801afb:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801b01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b05:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  801b07:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801b0e:	00 00 00 
  801b11:	48 8b 00             	mov    (%rax),%rax
  801b14:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  801b1a:	c9                   	leaveq 
  801b1b:	c3                   	retq   

0000000000801b1c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b1c:	55                   	push   %rbp
  801b1d:	48 89 e5             	mov    %rsp,%rbp
  801b20:	48 83 ec 30          	sub    $0x30,%rsp
  801b24:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b27:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801b2a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801b2e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  801b31:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b36:	75 0e                	jne    801b46 <ipc_send+0x2a>
        pg = (void *)UTOP;
  801b38:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801b3f:	00 00 00 
  801b42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  801b46:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801b49:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801b4c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b53:	89 c7                	mov    %eax,%edi
  801b55:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
  801b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  801b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b68:	79 36                	jns    801ba0 <ipc_send+0x84>
  801b6a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801b6e:	74 30                	je     801ba0 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  801b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b73:	89 c1                	mov    %eax,%ecx
  801b75:	48 ba d3 3b 80 00 00 	movabs $0x803bd3,%rdx
  801b7c:	00 00 00 
  801b7f:	be 49 00 00 00       	mov    $0x49,%esi
  801b84:	48 bf e0 3b 80 00 00 	movabs $0x803be0,%rdi
  801b8b:	00 00 00 
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	49 b8 fb 34 80 00 00 	movabs $0x8034fb,%r8
  801b9a:	00 00 00 
  801b9d:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  801ba0:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  801ba7:	00 00 00 
  801baa:	ff d0                	callq  *%rax
    } while(r != 0);
  801bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb0:	75 94                	jne    801b46 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  801bb2:	c9                   	leaveq 
  801bb3:	c3                   	retq   

0000000000801bb4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801bb4:	55                   	push   %rbp
  801bb5:	48 89 e5             	mov    %rsp,%rbp
  801bb8:	48 83 ec 14          	sub    $0x14,%rsp
  801bbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  801bbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801bc6:	eb 5e                	jmp    801c26 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801bc8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801bcf:	00 00 00 
  801bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd5:	48 63 d0             	movslq %eax,%rdx
  801bd8:	48 89 d0             	mov    %rdx,%rax
  801bdb:	48 c1 e0 03          	shl    $0x3,%rax
  801bdf:	48 01 d0             	add    %rdx,%rax
  801be2:	48 c1 e0 05          	shl    $0x5,%rax
  801be6:	48 01 c8             	add    %rcx,%rax
  801be9:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801bef:	8b 00                	mov    (%rax),%eax
  801bf1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801bf4:	75 2c                	jne    801c22 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801bf6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801bfd:	00 00 00 
  801c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c03:	48 63 d0             	movslq %eax,%rdx
  801c06:	48 89 d0             	mov    %rdx,%rax
  801c09:	48 c1 e0 03          	shl    $0x3,%rax
  801c0d:	48 01 d0             	add    %rdx,%rax
  801c10:	48 c1 e0 05          	shl    $0x5,%rax
  801c14:	48 01 c8             	add    %rcx,%rax
  801c17:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801c1d:	8b 40 08             	mov    0x8(%rax),%eax
  801c20:	eb 12                	jmp    801c34 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  801c22:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c26:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801c2d:	7e 99                	jle    801bc8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c34:	c9                   	leaveq 
  801c35:	c3                   	retq   

0000000000801c36 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c36:	55                   	push   %rbp
  801c37:	48 89 e5             	mov    %rsp,%rbp
  801c3a:	48 83 ec 08          	sub    $0x8,%rsp
  801c3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c42:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c46:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c4d:	ff ff ff 
  801c50:	48 01 d0             	add    %rdx,%rax
  801c53:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c57:	c9                   	leaveq 
  801c58:	c3                   	retq   

0000000000801c59 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c59:	55                   	push   %rbp
  801c5a:	48 89 e5             	mov    %rsp,%rbp
  801c5d:	48 83 ec 08          	sub    $0x8,%rsp
  801c61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c69:	48 89 c7             	mov    %rax,%rdi
  801c6c:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	callq  *%rax
  801c78:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c7e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c82:	c9                   	leaveq 
  801c83:	c3                   	retq   

0000000000801c84 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c84:	55                   	push   %rbp
  801c85:	48 89 e5             	mov    %rsp,%rbp
  801c88:	48 83 ec 18          	sub    $0x18,%rsp
  801c8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c97:	eb 6b                	jmp    801d04 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9c:	48 98                	cltq   
  801c9e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ca4:	48 c1 e0 0c          	shl    $0xc,%rax
  801ca8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb0:	48 c1 e8 15          	shr    $0x15,%rax
  801cb4:	48 89 c2             	mov    %rax,%rdx
  801cb7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cbe:	01 00 00 
  801cc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cc5:	83 e0 01             	and    $0x1,%eax
  801cc8:	48 85 c0             	test   %rax,%rax
  801ccb:	74 21                	je     801cee <fd_alloc+0x6a>
  801ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd1:	48 c1 e8 0c          	shr    $0xc,%rax
  801cd5:	48 89 c2             	mov    %rax,%rdx
  801cd8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cdf:	01 00 00 
  801ce2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ce6:	83 e0 01             	and    $0x1,%eax
  801ce9:	48 85 c0             	test   %rax,%rax
  801cec:	75 12                	jne    801d00 <fd_alloc+0x7c>
			*fd_store = fd;
  801cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfe:	eb 1a                	jmp    801d1a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d00:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d04:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d08:	7e 8f                	jle    801c99 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d15:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d1a:	c9                   	leaveq 
  801d1b:	c3                   	retq   

0000000000801d1c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d1c:	55                   	push   %rbp
  801d1d:	48 89 e5             	mov    %rsp,%rbp
  801d20:	48 83 ec 20          	sub    $0x20,%rsp
  801d24:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d2f:	78 06                	js     801d37 <fd_lookup+0x1b>
  801d31:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d35:	7e 07                	jle    801d3e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d3c:	eb 6c                	jmp    801daa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d3e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d41:	48 98                	cltq   
  801d43:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d49:	48 c1 e0 0c          	shl    $0xc,%rax
  801d4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d55:	48 c1 e8 15          	shr    $0x15,%rax
  801d59:	48 89 c2             	mov    %rax,%rdx
  801d5c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d63:	01 00 00 
  801d66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d6a:	83 e0 01             	and    $0x1,%eax
  801d6d:	48 85 c0             	test   %rax,%rax
  801d70:	74 21                	je     801d93 <fd_lookup+0x77>
  801d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d76:	48 c1 e8 0c          	shr    $0xc,%rax
  801d7a:	48 89 c2             	mov    %rax,%rdx
  801d7d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d84:	01 00 00 
  801d87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d8b:	83 e0 01             	and    $0x1,%eax
  801d8e:	48 85 c0             	test   %rax,%rax
  801d91:	75 07                	jne    801d9a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d98:	eb 10                	jmp    801daa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d9e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801da2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801daa:	c9                   	leaveq 
  801dab:	c3                   	retq   

0000000000801dac <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801dac:	55                   	push   %rbp
  801dad:	48 89 e5             	mov    %rsp,%rbp
  801db0:	48 83 ec 30          	sub    $0x30,%rsp
  801db4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801db8:	89 f0                	mov    %esi,%eax
  801dba:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801dbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc1:	48 89 c7             	mov    %rax,%rdi
  801dc4:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  801dcb:	00 00 00 
  801dce:	ff d0                	callq  *%rax
  801dd0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dd4:	48 89 d6             	mov    %rdx,%rsi
  801dd7:	89 c7                	mov    %eax,%edi
  801dd9:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  801de0:	00 00 00 
  801de3:	ff d0                	callq  *%rax
  801de5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801de8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dec:	78 0a                	js     801df8 <fd_close+0x4c>
	    || fd != fd2)
  801dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801df6:	74 12                	je     801e0a <fd_close+0x5e>
		return (must_exist ? r : 0);
  801df8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801dfc:	74 05                	je     801e03 <fd_close+0x57>
  801dfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e01:	eb 05                	jmp    801e08 <fd_close+0x5c>
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
  801e08:	eb 69                	jmp    801e73 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0e:	8b 00                	mov    (%rax),%eax
  801e10:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e14:	48 89 d6             	mov    %rdx,%rsi
  801e17:	89 c7                	mov    %eax,%edi
  801e19:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
  801e25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e2c:	78 2a                	js     801e58 <fd_close+0xac>
		if (dev->dev_close)
  801e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e32:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e36:	48 85 c0             	test   %rax,%rax
  801e39:	74 16                	je     801e51 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e3f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e43:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e47:	48 89 d7             	mov    %rdx,%rdi
  801e4a:	ff d0                	callq  *%rax
  801e4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e4f:	eb 07                	jmp    801e58 <fd_close+0xac>
		else
			r = 0;
  801e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5c:	48 89 c6             	mov    %rax,%rsi
  801e5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e64:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  801e6b:	00 00 00 
  801e6e:	ff d0                	callq  *%rax
	return r;
  801e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e73:	c9                   	leaveq 
  801e74:	c3                   	retq   

0000000000801e75 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e75:	55                   	push   %rbp
  801e76:	48 89 e5             	mov    %rsp,%rbp
  801e79:	48 83 ec 20          	sub    $0x20,%rsp
  801e7d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e8b:	eb 41                	jmp    801ece <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e8d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e94:	00 00 00 
  801e97:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e9a:	48 63 d2             	movslq %edx,%rdx
  801e9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea1:	8b 00                	mov    (%rax),%eax
  801ea3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ea6:	75 22                	jne    801eca <dev_lookup+0x55>
			*dev = devtab[i];
  801ea8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801eaf:	00 00 00 
  801eb2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eb5:	48 63 d2             	movslq %edx,%rdx
  801eb8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ebc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ec0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec8:	eb 60                	jmp    801f2a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801eca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ece:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ed5:	00 00 00 
  801ed8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801edb:	48 63 d2             	movslq %edx,%rdx
  801ede:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee2:	48 85 c0             	test   %rax,%rax
  801ee5:	75 a6                	jne    801e8d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ee7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801eee:	00 00 00 
  801ef1:	48 8b 00             	mov    (%rax),%rax
  801ef4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801efa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801efd:	89 c6                	mov    %eax,%esi
  801eff:	48 bf f0 3b 80 00 00 	movabs $0x803bf0,%rdi
  801f06:	00 00 00 
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0e:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  801f15:	00 00 00 
  801f18:	ff d1                	callq  *%rcx
	*dev = 0;
  801f1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f1e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f2a:	c9                   	leaveq 
  801f2b:	c3                   	retq   

0000000000801f2c <close>:

int
close(int fdnum)
{
  801f2c:	55                   	push   %rbp
  801f2d:	48 89 e5             	mov    %rsp,%rbp
  801f30:	48 83 ec 20          	sub    $0x20,%rsp
  801f34:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f37:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f3e:	48 89 d6             	mov    %rdx,%rsi
  801f41:	89 c7                	mov    %eax,%edi
  801f43:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  801f4a:	00 00 00 
  801f4d:	ff d0                	callq  *%rax
  801f4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f56:	79 05                	jns    801f5d <close+0x31>
		return r;
  801f58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f5b:	eb 18                	jmp    801f75 <close+0x49>
	else
		return fd_close(fd, 1);
  801f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f61:	be 01 00 00 00       	mov    $0x1,%esi
  801f66:	48 89 c7             	mov    %rax,%rdi
  801f69:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  801f70:	00 00 00 
  801f73:	ff d0                	callq  *%rax
}
  801f75:	c9                   	leaveq 
  801f76:	c3                   	retq   

0000000000801f77 <close_all>:

void
close_all(void)
{
  801f77:	55                   	push   %rbp
  801f78:	48 89 e5             	mov    %rsp,%rbp
  801f7b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f86:	eb 15                	jmp    801f9d <close_all+0x26>
		close(i);
  801f88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8b:	89 c7                	mov    %eax,%edi
  801f8d:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  801f94:	00 00 00 
  801f97:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f99:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f9d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fa1:	7e e5                	jle    801f88 <close_all+0x11>
		close(i);
}
  801fa3:	c9                   	leaveq 
  801fa4:	c3                   	retq   

0000000000801fa5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fa5:	55                   	push   %rbp
  801fa6:	48 89 e5             	mov    %rsp,%rbp
  801fa9:	48 83 ec 40          	sub    $0x40,%rsp
  801fad:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801fb0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fb3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fb7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fba:	48 89 d6             	mov    %rdx,%rsi
  801fbd:	89 c7                	mov    %eax,%edi
  801fbf:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	callq  *%rax
  801fcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd2:	79 08                	jns    801fdc <dup+0x37>
		return r;
  801fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd7:	e9 70 01 00 00       	jmpq   80214c <dup+0x1a7>
	close(newfdnum);
  801fdc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fdf:	89 c7                	mov    %eax,%edi
  801fe1:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  801fe8:	00 00 00 
  801feb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fed:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ff0:	48 98                	cltq   
  801ff2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ff8:	48 c1 e0 0c          	shl    $0xc,%rax
  801ffc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802000:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802004:	48 89 c7             	mov    %rax,%rdi
  802007:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  80200e:	00 00 00 
  802011:	ff d0                	callq  *%rax
  802013:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201b:	48 89 c7             	mov    %rax,%rdi
  80201e:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80202e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802032:	48 c1 e8 15          	shr    $0x15,%rax
  802036:	48 89 c2             	mov    %rax,%rdx
  802039:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802040:	01 00 00 
  802043:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802047:	83 e0 01             	and    $0x1,%eax
  80204a:	48 85 c0             	test   %rax,%rax
  80204d:	74 73                	je     8020c2 <dup+0x11d>
  80204f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802053:	48 c1 e8 0c          	shr    $0xc,%rax
  802057:	48 89 c2             	mov    %rax,%rdx
  80205a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802061:	01 00 00 
  802064:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802068:	83 e0 01             	and    $0x1,%eax
  80206b:	48 85 c0             	test   %rax,%rax
  80206e:	74 52                	je     8020c2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802074:	48 c1 e8 0c          	shr    $0xc,%rax
  802078:	48 89 c2             	mov    %rax,%rdx
  80207b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802082:	01 00 00 
  802085:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802089:	25 07 0e 00 00       	and    $0xe07,%eax
  80208e:	89 c1                	mov    %eax,%ecx
  802090:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802098:	41 89 c8             	mov    %ecx,%r8d
  80209b:	48 89 d1             	mov    %rdx,%rcx
  80209e:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a3:	48 89 c6             	mov    %rax,%rsi
  8020a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ab:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
  8020b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020be:	79 02                	jns    8020c2 <dup+0x11d>
			goto err;
  8020c0:	eb 57                	jmp    802119 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8020ca:	48 89 c2             	mov    %rax,%rdx
  8020cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020d4:	01 00 00 
  8020d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020db:	25 07 0e 00 00       	and    $0xe07,%eax
  8020e0:	89 c1                	mov    %eax,%ecx
  8020e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ea:	41 89 c8             	mov    %ecx,%r8d
  8020ed:	48 89 d1             	mov    %rdx,%rcx
  8020f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f5:	48 89 c6             	mov    %rax,%rsi
  8020f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fd:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  802104:	00 00 00 
  802107:	ff d0                	callq  *%rax
  802109:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80210c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802110:	79 02                	jns    802114 <dup+0x16f>
		goto err;
  802112:	eb 05                	jmp    802119 <dup+0x174>

	return newfdnum;
  802114:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802117:	eb 33                	jmp    80214c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802119:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80211d:	48 89 c6             	mov    %rax,%rsi
  802120:	bf 00 00 00 00       	mov    $0x0,%edi
  802125:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  80212c:	00 00 00 
  80212f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802131:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802135:	48 89 c6             	mov    %rax,%rsi
  802138:	bf 00 00 00 00       	mov    $0x0,%edi
  80213d:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
	return r;
  802149:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80214c:	c9                   	leaveq 
  80214d:	c3                   	retq   

000000000080214e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80214e:	55                   	push   %rbp
  80214f:	48 89 e5             	mov    %rsp,%rbp
  802152:	48 83 ec 40          	sub    $0x40,%rsp
  802156:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802159:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80215d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802161:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802165:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802168:	48 89 d6             	mov    %rdx,%rsi
  80216b:	89 c7                	mov    %eax,%edi
  80216d:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
  802179:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802180:	78 24                	js     8021a6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802186:	8b 00                	mov    (%rax),%eax
  802188:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80218c:	48 89 d6             	mov    %rdx,%rsi
  80218f:	89 c7                	mov    %eax,%edi
  802191:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  802198:	00 00 00 
  80219b:	ff d0                	callq  *%rax
  80219d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a4:	79 05                	jns    8021ab <read+0x5d>
		return r;
  8021a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a9:	eb 76                	jmp    802221 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021af:	8b 40 08             	mov    0x8(%rax),%eax
  8021b2:	83 e0 03             	and    $0x3,%eax
  8021b5:	83 f8 01             	cmp    $0x1,%eax
  8021b8:	75 3a                	jne    8021f4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021ba:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021c1:	00 00 00 
  8021c4:	48 8b 00             	mov    (%rax),%rax
  8021c7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021cd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021d0:	89 c6                	mov    %eax,%esi
  8021d2:	48 bf 0f 3c 80 00 00 	movabs $0x803c0f,%rdi
  8021d9:	00 00 00 
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  8021e8:	00 00 00 
  8021eb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021f2:	eb 2d                	jmp    802221 <read+0xd3>
	}
	if (!dev->dev_read)
  8021f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021fc:	48 85 c0             	test   %rax,%rax
  8021ff:	75 07                	jne    802208 <read+0xba>
		return -E_NOT_SUPP;
  802201:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802206:	eb 19                	jmp    802221 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802210:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802214:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802218:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80221c:	48 89 cf             	mov    %rcx,%rdi
  80221f:	ff d0                	callq  *%rax
}
  802221:	c9                   	leaveq 
  802222:	c3                   	retq   

0000000000802223 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802223:	55                   	push   %rbp
  802224:	48 89 e5             	mov    %rsp,%rbp
  802227:	48 83 ec 30          	sub    $0x30,%rsp
  80222b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80222e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802232:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80223d:	eb 49                	jmp    802288 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80223f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802242:	48 98                	cltq   
  802244:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802248:	48 29 c2             	sub    %rax,%rdx
  80224b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80224e:	48 63 c8             	movslq %eax,%rcx
  802251:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802255:	48 01 c1             	add    %rax,%rcx
  802258:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80225b:	48 89 ce             	mov    %rcx,%rsi
  80225e:	89 c7                	mov    %eax,%edi
  802260:	48 b8 4e 21 80 00 00 	movabs $0x80214e,%rax
  802267:	00 00 00 
  80226a:	ff d0                	callq  *%rax
  80226c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80226f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802273:	79 05                	jns    80227a <readn+0x57>
			return m;
  802275:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802278:	eb 1c                	jmp    802296 <readn+0x73>
		if (m == 0)
  80227a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80227e:	75 02                	jne    802282 <readn+0x5f>
			break;
  802280:	eb 11                	jmp    802293 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802282:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802285:	01 45 fc             	add    %eax,-0x4(%rbp)
  802288:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228b:	48 98                	cltq   
  80228d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802291:	72 ac                	jb     80223f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802293:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802296:	c9                   	leaveq 
  802297:	c3                   	retq   

0000000000802298 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802298:	55                   	push   %rbp
  802299:	48 89 e5             	mov    %rsp,%rbp
  80229c:	48 83 ec 40          	sub    $0x40,%rsp
  8022a0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022a3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022a7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022b2:	48 89 d6             	mov    %rdx,%rsi
  8022b5:	89 c7                	mov    %eax,%edi
  8022b7:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  8022be:	00 00 00 
  8022c1:	ff d0                	callq  *%rax
  8022c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ca:	78 24                	js     8022f0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d0:	8b 00                	mov    (%rax),%eax
  8022d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d6:	48 89 d6             	mov    %rdx,%rsi
  8022d9:	89 c7                	mov    %eax,%edi
  8022db:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  8022e2:	00 00 00 
  8022e5:	ff d0                	callq  *%rax
  8022e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ee:	79 05                	jns    8022f5 <write+0x5d>
		return r;
  8022f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f3:	eb 75                	jmp    80236a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f9:	8b 40 08             	mov    0x8(%rax),%eax
  8022fc:	83 e0 03             	and    $0x3,%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	75 3a                	jne    80233d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802303:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80230a:	00 00 00 
  80230d:	48 8b 00             	mov    (%rax),%rax
  802310:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802316:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802319:	89 c6                	mov    %eax,%esi
  80231b:	48 bf 2b 3c 80 00 00 	movabs $0x803c2b,%rdi
  802322:	00 00 00 
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
  80232a:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  802331:	00 00 00 
  802334:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802336:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80233b:	eb 2d                	jmp    80236a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80233d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802341:	48 8b 40 18          	mov    0x18(%rax),%rax
  802345:	48 85 c0             	test   %rax,%rax
  802348:	75 07                	jne    802351 <write+0xb9>
		return -E_NOT_SUPP;
  80234a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80234f:	eb 19                	jmp    80236a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802351:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802355:	48 8b 40 18          	mov    0x18(%rax),%rax
  802359:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80235d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802361:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802365:	48 89 cf             	mov    %rcx,%rdi
  802368:	ff d0                	callq  *%rax
}
  80236a:	c9                   	leaveq 
  80236b:	c3                   	retq   

000000000080236c <seek>:

int
seek(int fdnum, off_t offset)
{
  80236c:	55                   	push   %rbp
  80236d:	48 89 e5             	mov    %rsp,%rbp
  802370:	48 83 ec 18          	sub    $0x18,%rsp
  802374:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802377:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80237a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80237e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802381:	48 89 d6             	mov    %rdx,%rsi
  802384:	89 c7                	mov    %eax,%edi
  802386:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  80238d:	00 00 00 
  802390:	ff d0                	callq  *%rax
  802392:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802395:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802399:	79 05                	jns    8023a0 <seek+0x34>
		return r;
  80239b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239e:	eb 0f                	jmp    8023af <seek+0x43>
	fd->fd_offset = offset;
  8023a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023a7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023af:	c9                   	leaveq 
  8023b0:	c3                   	retq   

00000000008023b1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023b1:	55                   	push   %rbp
  8023b2:	48 89 e5             	mov    %rsp,%rbp
  8023b5:	48 83 ec 30          	sub    $0x30,%rsp
  8023b9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023bc:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023bf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c6:	48 89 d6             	mov    %rdx,%rsi
  8023c9:	89 c7                	mov    %eax,%edi
  8023cb:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
  8023d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023de:	78 24                	js     802404 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e4:	8b 00                	mov    (%rax),%eax
  8023e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ea:	48 89 d6             	mov    %rdx,%rsi
  8023ed:	89 c7                	mov    %eax,%edi
  8023ef:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	callq  *%rax
  8023fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802402:	79 05                	jns    802409 <ftruncate+0x58>
		return r;
  802404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802407:	eb 72                	jmp    80247b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240d:	8b 40 08             	mov    0x8(%rax),%eax
  802410:	83 e0 03             	and    $0x3,%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	75 3a                	jne    802451 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802417:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80241e:	00 00 00 
  802421:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802424:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80242a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80242d:	89 c6                	mov    %eax,%esi
  80242f:	48 bf 48 3c 80 00 00 	movabs $0x803c48,%rdi
  802436:	00 00 00 
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
  80243e:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  802445:	00 00 00 
  802448:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80244a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244f:	eb 2a                	jmp    80247b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802455:	48 8b 40 30          	mov    0x30(%rax),%rax
  802459:	48 85 c0             	test   %rax,%rax
  80245c:	75 07                	jne    802465 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80245e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802463:	eb 16                	jmp    80247b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802469:	48 8b 40 30          	mov    0x30(%rax),%rax
  80246d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802471:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802474:	89 ce                	mov    %ecx,%esi
  802476:	48 89 d7             	mov    %rdx,%rdi
  802479:	ff d0                	callq  *%rax
}
  80247b:	c9                   	leaveq 
  80247c:	c3                   	retq   

000000000080247d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80247d:	55                   	push   %rbp
  80247e:	48 89 e5             	mov    %rsp,%rbp
  802481:	48 83 ec 30          	sub    $0x30,%rsp
  802485:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802488:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80248c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802490:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802493:	48 89 d6             	mov    %rdx,%rsi
  802496:	89 c7                	mov    %eax,%edi
  802498:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
  8024a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ab:	78 24                	js     8024d1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b1:	8b 00                	mov    (%rax),%eax
  8024b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b7:	48 89 d6             	mov    %rdx,%rsi
  8024ba:	89 c7                	mov    %eax,%edi
  8024bc:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  8024c3:	00 00 00 
  8024c6:	ff d0                	callq  *%rax
  8024c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024cf:	79 05                	jns    8024d6 <fstat+0x59>
		return r;
  8024d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d4:	eb 5e                	jmp    802534 <fstat+0xb7>
	if (!dev->dev_stat)
  8024d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024da:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024de:	48 85 c0             	test   %rax,%rax
  8024e1:	75 07                	jne    8024ea <fstat+0x6d>
		return -E_NOT_SUPP;
  8024e3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e8:	eb 4a                	jmp    802534 <fstat+0xb7>
	stat->st_name[0] = 0;
  8024ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ee:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024f5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024fc:	00 00 00 
	stat->st_isdir = 0;
  8024ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802503:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80250a:	00 00 00 
	stat->st_dev = dev;
  80250d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802511:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802515:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80251c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802520:	48 8b 40 28          	mov    0x28(%rax),%rax
  802524:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802528:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80252c:	48 89 ce             	mov    %rcx,%rsi
  80252f:	48 89 d7             	mov    %rdx,%rdi
  802532:	ff d0                	callq  *%rax
}
  802534:	c9                   	leaveq 
  802535:	c3                   	retq   

0000000000802536 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802536:	55                   	push   %rbp
  802537:	48 89 e5             	mov    %rsp,%rbp
  80253a:	48 83 ec 20          	sub    $0x20,%rsp
  80253e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802542:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254a:	be 00 00 00 00       	mov    $0x0,%esi
  80254f:	48 89 c7             	mov    %rax,%rdi
  802552:	48 b8 24 26 80 00 00 	movabs $0x802624,%rax
  802559:	00 00 00 
  80255c:	ff d0                	callq  *%rax
  80255e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802561:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802565:	79 05                	jns    80256c <stat+0x36>
		return fd;
  802567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256a:	eb 2f                	jmp    80259b <stat+0x65>
	r = fstat(fd, stat);
  80256c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802570:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802573:	48 89 d6             	mov    %rdx,%rsi
  802576:	89 c7                	mov    %eax,%edi
  802578:	48 b8 7d 24 80 00 00 	movabs $0x80247d,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
  802584:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258a:	89 c7                	mov    %eax,%edi
  80258c:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802593:	00 00 00 
  802596:	ff d0                	callq  *%rax
	return r;
  802598:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80259b:	c9                   	leaveq 
  80259c:	c3                   	retq   

000000000080259d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80259d:	55                   	push   %rbp
  80259e:	48 89 e5             	mov    %rsp,%rbp
  8025a1:	48 83 ec 10          	sub    $0x10,%rsp
  8025a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025ac:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025b3:	00 00 00 
  8025b6:	8b 00                	mov    (%rax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	75 1d                	jne    8025d9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025bc:	bf 01 00 00 00       	mov    $0x1,%edi
  8025c1:	48 b8 b4 1b 80 00 00 	movabs $0x801bb4,%rax
  8025c8:	00 00 00 
  8025cb:	ff d0                	callq  *%rax
  8025cd:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8025d4:	00 00 00 
  8025d7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025d9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025e0:	00 00 00 
  8025e3:	8b 00                	mov    (%rax),%eax
  8025e5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025e8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025ed:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8025f4:	00 00 00 
  8025f7:	89 c7                	mov    %eax,%edi
  8025f9:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802609:	ba 00 00 00 00       	mov    $0x0,%edx
  80260e:	48 89 c6             	mov    %rax,%rsi
  802611:	bf 00 00 00 00       	mov    $0x0,%edi
  802616:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
}
  802622:	c9                   	leaveq 
  802623:	c3                   	retq   

0000000000802624 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802624:	55                   	push   %rbp
  802625:	48 89 e5             	mov    %rsp,%rbp
  802628:	48 83 ec 20          	sub    $0x20,%rsp
  80262c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802630:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802637:	48 89 c7             	mov    %rax,%rdi
  80263a:	48 b8 53 0e 80 00 00 	movabs $0x800e53,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax
  802646:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80264b:	7e 0a                	jle    802657 <open+0x33>
		return -E_BAD_PATH;
  80264d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802652:	e9 a5 00 00 00       	jmpq   8026fc <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802657:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80265b:	48 89 c7             	mov    %rax,%rdi
  80265e:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
  80266a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802671:	79 08                	jns    80267b <open+0x57>
		return r;
  802673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802676:	e9 81 00 00 00       	jmpq   8026fc <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80267b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267f:	48 89 c6             	mov    %rax,%rsi
  802682:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802689:	00 00 00 
  80268c:	48 b8 bf 0e 80 00 00 	movabs $0x800ebf,%rax
  802693:	00 00 00 
  802696:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802698:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80269f:	00 00 00 
  8026a2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8026a5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8026ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026af:	48 89 c6             	mov    %rax,%rsi
  8026b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8026b7:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  8026be:	00 00 00 
  8026c1:	ff d0                	callq  *%rax
  8026c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ca:	79 1d                	jns    8026e9 <open+0xc5>
		fd_close(fd, 0);
  8026cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d0:	be 00 00 00 00       	mov    $0x0,%esi
  8026d5:	48 89 c7             	mov    %rax,%rdi
  8026d8:	48 b8 ac 1d 80 00 00 	movabs $0x801dac,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
		return r;
  8026e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e7:	eb 13                	jmp    8026fc <open+0xd8>
	}

	return fd2num(fd);
  8026e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ed:	48 89 c7             	mov    %rax,%rdi
  8026f0:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8026fc:	c9                   	leaveq 
  8026fd:	c3                   	retq   

00000000008026fe <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026fe:	55                   	push   %rbp
  8026ff:	48 89 e5             	mov    %rsp,%rbp
  802702:	48 83 ec 10          	sub    $0x10,%rsp
  802706:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80270a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80270e:	8b 50 0c             	mov    0xc(%rax),%edx
  802711:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802718:	00 00 00 
  80271b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80271d:	be 00 00 00 00       	mov    $0x0,%esi
  802722:	bf 06 00 00 00       	mov    $0x6,%edi
  802727:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  80272e:	00 00 00 
  802731:	ff d0                	callq  *%rax
}
  802733:	c9                   	leaveq 
  802734:	c3                   	retq   

0000000000802735 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802735:	55                   	push   %rbp
  802736:	48 89 e5             	mov    %rsp,%rbp
  802739:	48 83 ec 30          	sub    $0x30,%rsp
  80273d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802741:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802745:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274d:	8b 50 0c             	mov    0xc(%rax),%edx
  802750:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802757:	00 00 00 
  80275a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80275c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802763:	00 00 00 
  802766:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80276a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80276e:	be 00 00 00 00       	mov    $0x0,%esi
  802773:	bf 03 00 00 00       	mov    $0x3,%edi
  802778:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  80277f:	00 00 00 
  802782:	ff d0                	callq  *%rax
  802784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278b:	79 08                	jns    802795 <devfile_read+0x60>
		return r;
  80278d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802790:	e9 a4 00 00 00       	jmpq   802839 <devfile_read+0x104>
	assert(r <= n);
  802795:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802798:	48 98                	cltq   
  80279a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80279e:	76 35                	jbe    8027d5 <devfile_read+0xa0>
  8027a0:	48 b9 75 3c 80 00 00 	movabs $0x803c75,%rcx
  8027a7:	00 00 00 
  8027aa:	48 ba 7c 3c 80 00 00 	movabs $0x803c7c,%rdx
  8027b1:	00 00 00 
  8027b4:	be 84 00 00 00       	mov    $0x84,%esi
  8027b9:	48 bf 91 3c 80 00 00 	movabs $0x803c91,%rdi
  8027c0:	00 00 00 
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	49 b8 fb 34 80 00 00 	movabs $0x8034fb,%r8
  8027cf:	00 00 00 
  8027d2:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8027d5:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8027dc:	7e 35                	jle    802813 <devfile_read+0xde>
  8027de:	48 b9 9c 3c 80 00 00 	movabs $0x803c9c,%rcx
  8027e5:	00 00 00 
  8027e8:	48 ba 7c 3c 80 00 00 	movabs $0x803c7c,%rdx
  8027ef:	00 00 00 
  8027f2:	be 85 00 00 00       	mov    $0x85,%esi
  8027f7:	48 bf 91 3c 80 00 00 	movabs $0x803c91,%rdi
  8027fe:	00 00 00 
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
  802806:	49 b8 fb 34 80 00 00 	movabs $0x8034fb,%r8
  80280d:	00 00 00 
  802810:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802816:	48 63 d0             	movslq %eax,%rdx
  802819:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80281d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802824:	00 00 00 
  802827:	48 89 c7             	mov    %rax,%rdi
  80282a:	48 b8 e3 11 80 00 00 	movabs $0x8011e3,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
	return r;
  802836:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 30          	sub    $0x30,%rsp
  802843:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802847:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80284b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80284f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802853:	8b 50 0c             	mov    0xc(%rax),%edx
  802856:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80285d:	00 00 00 
  802860:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802862:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802869:	00 00 00 
  80286c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802870:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802874:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80287b:	00 
  80287c:	76 35                	jbe    8028b3 <devfile_write+0x78>
  80287e:	48 b9 a8 3c 80 00 00 	movabs $0x803ca8,%rcx
  802885:	00 00 00 
  802888:	48 ba 7c 3c 80 00 00 	movabs $0x803c7c,%rdx
  80288f:	00 00 00 
  802892:	be 9e 00 00 00       	mov    $0x9e,%esi
  802897:	48 bf 91 3c 80 00 00 	movabs $0x803c91,%rdi
  80289e:	00 00 00 
  8028a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a6:	49 b8 fb 34 80 00 00 	movabs $0x8034fb,%r8
  8028ad:	00 00 00 
  8028b0:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8028b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028bb:	48 89 c6             	mov    %rax,%rsi
  8028be:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8028c5:	00 00 00 
  8028c8:	48 b8 fa 12 80 00 00 	movabs $0x8012fa,%rax
  8028cf:	00 00 00 
  8028d2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8028d4:	be 00 00 00 00       	mov    $0x0,%esi
  8028d9:	bf 04 00 00 00       	mov    $0x4,%edi
  8028de:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	callq  *%rax
  8028ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f1:	79 05                	jns    8028f8 <devfile_write+0xbd>
		return r;
  8028f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f6:	eb 43                	jmp    80293b <devfile_write+0x100>
	assert(r <= n);
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fb:	48 98                	cltq   
  8028fd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802901:	76 35                	jbe    802938 <devfile_write+0xfd>
  802903:	48 b9 75 3c 80 00 00 	movabs $0x803c75,%rcx
  80290a:	00 00 00 
  80290d:	48 ba 7c 3c 80 00 00 	movabs $0x803c7c,%rdx
  802914:	00 00 00 
  802917:	be a2 00 00 00       	mov    $0xa2,%esi
  80291c:	48 bf 91 3c 80 00 00 	movabs $0x803c91,%rdi
  802923:	00 00 00 
  802926:	b8 00 00 00 00       	mov    $0x0,%eax
  80292b:	49 b8 fb 34 80 00 00 	movabs $0x8034fb,%r8
  802932:	00 00 00 
  802935:	41 ff d0             	callq  *%r8
	return r;
  802938:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80293b:	c9                   	leaveq 
  80293c:	c3                   	retq   

000000000080293d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80293d:	55                   	push   %rbp
  80293e:	48 89 e5             	mov    %rsp,%rbp
  802941:	48 83 ec 20          	sub    $0x20,%rsp
  802945:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802949:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80294d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802951:	8b 50 0c             	mov    0xc(%rax),%edx
  802954:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80295b:	00 00 00 
  80295e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802960:	be 00 00 00 00       	mov    $0x0,%esi
  802965:	bf 05 00 00 00       	mov    $0x5,%edi
  80296a:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  802971:	00 00 00 
  802974:	ff d0                	callq  *%rax
  802976:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802979:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297d:	79 05                	jns    802984 <devfile_stat+0x47>
		return r;
  80297f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802982:	eb 56                	jmp    8029da <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802984:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802988:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80298f:	00 00 00 
  802992:	48 89 c7             	mov    %rax,%rdi
  802995:	48 b8 bf 0e 80 00 00 	movabs $0x800ebf,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029a1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029a8:	00 00 00 
  8029ab:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029bb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029c2:	00 00 00 
  8029c5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029cf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029da:	c9                   	leaveq 
  8029db:	c3                   	retq   

00000000008029dc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029dc:	55                   	push   %rbp
  8029dd:	48 89 e5             	mov    %rsp,%rbp
  8029e0:	48 83 ec 10          	sub    $0x10,%rsp
  8029e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029e8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029ef:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029f9:	00 00 00 
  8029fc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029fe:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a05:	00 00 00 
  802a08:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a0b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a0e:	be 00 00 00 00       	mov    $0x0,%esi
  802a13:	bf 02 00 00 00       	mov    $0x2,%edi
  802a18:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  802a1f:	00 00 00 
  802a22:	ff d0                	callq  *%rax
}
  802a24:	c9                   	leaveq 
  802a25:	c3                   	retq   

0000000000802a26 <remove>:

// Delete a file
int
remove(const char *path)
{
  802a26:	55                   	push   %rbp
  802a27:	48 89 e5             	mov    %rsp,%rbp
  802a2a:	48 83 ec 10          	sub    $0x10,%rsp
  802a2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a36:	48 89 c7             	mov    %rax,%rdi
  802a39:	48 b8 53 0e 80 00 00 	movabs $0x800e53,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
  802a45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a4a:	7e 07                	jle    802a53 <remove+0x2d>
		return -E_BAD_PATH;
  802a4c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a51:	eb 33                	jmp    802a86 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a57:	48 89 c6             	mov    %rax,%rsi
  802a5a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a61:	00 00 00 
  802a64:	48 b8 bf 0e 80 00 00 	movabs $0x800ebf,%rax
  802a6b:	00 00 00 
  802a6e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a70:	be 00 00 00 00       	mov    $0x0,%esi
  802a75:	bf 07 00 00 00       	mov    $0x7,%edi
  802a7a:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
}
  802a86:	c9                   	leaveq 
  802a87:	c3                   	retq   

0000000000802a88 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a88:	55                   	push   %rbp
  802a89:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a8c:	be 00 00 00 00       	mov    $0x0,%esi
  802a91:	bf 08 00 00 00       	mov    $0x8,%edi
  802a96:	48 b8 9d 25 80 00 00 	movabs $0x80259d,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
}
  802aa2:	5d                   	pop    %rbp
  802aa3:	c3                   	retq   

0000000000802aa4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802aa4:	55                   	push   %rbp
  802aa5:	48 89 e5             	mov    %rsp,%rbp
  802aa8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802aaf:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ab6:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802abd:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ac4:	be 00 00 00 00       	mov    $0x0,%esi
  802ac9:	48 89 c7             	mov    %rax,%rdi
  802acc:	48 b8 24 26 80 00 00 	movabs $0x802624,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802adb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802adf:	79 28                	jns    802b09 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae4:	89 c6                	mov    %eax,%esi
  802ae6:	48 bf d5 3c 80 00 00 	movabs $0x803cd5,%rdi
  802aed:	00 00 00 
  802af0:	b8 00 00 00 00       	mov    $0x0,%eax
  802af5:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  802afc:	00 00 00 
  802aff:	ff d2                	callq  *%rdx
		return fd_src;
  802b01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b04:	e9 74 01 00 00       	jmpq   802c7d <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b09:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b10:	be 01 01 00 00       	mov    $0x101,%esi
  802b15:	48 89 c7             	mov    %rax,%rdi
  802b18:	48 b8 24 26 80 00 00 	movabs $0x802624,%rax
  802b1f:	00 00 00 
  802b22:	ff d0                	callq  *%rax
  802b24:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b27:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b2b:	79 39                	jns    802b66 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b30:	89 c6                	mov    %eax,%esi
  802b32:	48 bf eb 3c 80 00 00 	movabs $0x803ceb,%rdi
  802b39:	00 00 00 
  802b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b41:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  802b48:	00 00 00 
  802b4b:	ff d2                	callq  *%rdx
		close(fd_src);
  802b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b50:	89 c7                	mov    %eax,%edi
  802b52:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
		return fd_dest;
  802b5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b61:	e9 17 01 00 00       	jmpq   802c7d <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b66:	eb 74                	jmp    802bdc <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b68:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b6b:	48 63 d0             	movslq %eax,%rdx
  802b6e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b78:	48 89 ce             	mov    %rcx,%rsi
  802b7b:	89 c7                	mov    %eax,%edi
  802b7d:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  802b84:	00 00 00 
  802b87:	ff d0                	callq  *%rax
  802b89:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b90:	79 4a                	jns    802bdc <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b92:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b95:	89 c6                	mov    %eax,%esi
  802b97:	48 bf 05 3d 80 00 00 	movabs $0x803d05,%rdi
  802b9e:	00 00 00 
  802ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba6:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  802bad:	00 00 00 
  802bb0:	ff d2                	callq  *%rdx
			close(fd_src);
  802bb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb5:	89 c7                	mov    %eax,%edi
  802bb7:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802bbe:	00 00 00 
  802bc1:	ff d0                	callq  *%rax
			close(fd_dest);
  802bc3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc6:	89 c7                	mov    %eax,%edi
  802bc8:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
			return write_size;
  802bd4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bd7:	e9 a1 00 00 00       	jmpq   802c7d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bdc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be6:	ba 00 02 00 00       	mov    $0x200,%edx
  802beb:	48 89 ce             	mov    %rcx,%rsi
  802bee:	89 c7                	mov    %eax,%edi
  802bf0:	48 b8 4e 21 80 00 00 	movabs $0x80214e,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
  802bfc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802bff:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c03:	0f 8f 5f ff ff ff    	jg     802b68 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c0d:	79 47                	jns    802c56 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c0f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c12:	89 c6                	mov    %eax,%esi
  802c14:	48 bf 18 3d 80 00 00 	movabs $0x803d18,%rdi
  802c1b:	00 00 00 
  802c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c23:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  802c2a:	00 00 00 
  802c2d:	ff d2                	callq  *%rdx
		close(fd_src);
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
		close(fd_dest);
  802c40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
		return read_size;
  802c51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c54:	eb 27                	jmp    802c7d <copy+0x1d9>
	}
	close(fd_src);
  802c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c59:	89 c7                	mov    %eax,%edi
  802c5b:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	callq  *%rax
	close(fd_dest);
  802c67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c6a:	89 c7                	mov    %eax,%edi
  802c6c:	48 b8 2c 1f 80 00 00 	movabs $0x801f2c,%rax
  802c73:	00 00 00 
  802c76:	ff d0                	callq  *%rax
	return 0;
  802c78:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802c7d:	c9                   	leaveq 
  802c7e:	c3                   	retq   

0000000000802c7f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802c7f:	55                   	push   %rbp
  802c80:	48 89 e5             	mov    %rsp,%rbp
  802c83:	53                   	push   %rbx
  802c84:	48 83 ec 38          	sub    $0x38,%rsp
  802c88:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c8c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802c90:	48 89 c7             	mov    %rax,%rdi
  802c93:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
  802c9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ca2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ca6:	0f 88 bf 01 00 00    	js     802e6b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb0:	ba 07 04 00 00       	mov    $0x407,%edx
  802cb5:	48 89 c6             	mov    %rax,%rsi
  802cb8:	bf 00 00 00 00       	mov    $0x0,%edi
  802cbd:	48 b8 ee 17 80 00 00 	movabs $0x8017ee,%rax
  802cc4:	00 00 00 
  802cc7:	ff d0                	callq  *%rax
  802cc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ccc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cd0:	0f 88 95 01 00 00    	js     802e6b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802cd6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802cda:	48 89 c7             	mov    %rax,%rdi
  802cdd:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	callq  *%rax
  802ce9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cf0:	0f 88 5d 01 00 00    	js     802e53 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cf6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cfa:	ba 07 04 00 00       	mov    $0x407,%edx
  802cff:	48 89 c6             	mov    %rax,%rsi
  802d02:	bf 00 00 00 00       	mov    $0x0,%edi
  802d07:	48 b8 ee 17 80 00 00 	movabs $0x8017ee,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
  802d13:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d16:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d1a:	0f 88 33 01 00 00    	js     802e53 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802d20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d24:	48 89 c7             	mov    %rax,%rdi
  802d27:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
  802d33:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d3b:	ba 07 04 00 00       	mov    $0x407,%edx
  802d40:	48 89 c6             	mov    %rax,%rsi
  802d43:	bf 00 00 00 00       	mov    $0x0,%edi
  802d48:	48 b8 ee 17 80 00 00 	movabs $0x8017ee,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d57:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d5b:	79 05                	jns    802d62 <pipe+0xe3>
		goto err2;
  802d5d:	e9 d9 00 00 00       	jmpq   802e3b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d62:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d66:	48 89 c7             	mov    %rax,%rdi
  802d69:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	48 89 c2             	mov    %rax,%rdx
  802d78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802d82:	48 89 d1             	mov    %rdx,%rcx
  802d85:	ba 00 00 00 00       	mov    $0x0,%edx
  802d8a:	48 89 c6             	mov    %rax,%rsi
  802d8d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d92:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
  802d9e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802da1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802da5:	79 1b                	jns    802dc2 <pipe+0x143>
		goto err3;
  802da7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802da8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dac:	48 89 c6             	mov    %rax,%rsi
  802daf:	bf 00 00 00 00       	mov    $0x0,%edi
  802db4:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  802dbb:	00 00 00 
  802dbe:	ff d0                	callq  *%rax
  802dc0:	eb 79                	jmp    802e3b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802dc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dc6:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802dcd:	00 00 00 
  802dd0:	8b 12                	mov    (%rdx),%edx
  802dd2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802dd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802ddf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de3:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802dea:	00 00 00 
  802ded:	8b 12                	mov    (%rdx),%edx
  802def:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802df1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802dfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e00:	48 89 c7             	mov    %rax,%rdi
  802e03:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
  802e0f:	89 c2                	mov    %eax,%edx
  802e11:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e15:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802e17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802e1b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802e1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e23:	48 89 c7             	mov    %rax,%rdi
  802e26:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
  802e32:	89 03                	mov    %eax,(%rbx)
	return 0;
  802e34:	b8 00 00 00 00       	mov    $0x0,%eax
  802e39:	eb 33                	jmp    802e6e <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802e3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e3f:	48 89 c6             	mov    %rax,%rsi
  802e42:	bf 00 00 00 00       	mov    $0x0,%edi
  802e47:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802e53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e57:	48 89 c6             	mov    %rax,%rsi
  802e5a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e5f:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  802e66:	00 00 00 
  802e69:	ff d0                	callq  *%rax
err:
	return r;
  802e6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802e6e:	48 83 c4 38          	add    $0x38,%rsp
  802e72:	5b                   	pop    %rbx
  802e73:	5d                   	pop    %rbp
  802e74:	c3                   	retq   

0000000000802e75 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802e75:	55                   	push   %rbp
  802e76:	48 89 e5             	mov    %rsp,%rbp
  802e79:	53                   	push   %rbx
  802e7a:	48 83 ec 28          	sub    $0x28,%rsp
  802e7e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e82:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802e86:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e8d:	00 00 00 
  802e90:	48 8b 00             	mov    (%rax),%rax
  802e93:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e99:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802e9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea0:	48 89 c7             	mov    %rax,%rdi
  802ea3:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  802eaa:	00 00 00 
  802ead:	ff d0                	callq  *%rax
  802eaf:	89 c3                	mov    %eax,%ebx
  802eb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb5:	48 89 c7             	mov    %rax,%rdi
  802eb8:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
  802ec4:	39 c3                	cmp    %eax,%ebx
  802ec6:	0f 94 c0             	sete   %al
  802ec9:	0f b6 c0             	movzbl %al,%eax
  802ecc:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802ecf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ed6:	00 00 00 
  802ed9:	48 8b 00             	mov    (%rax),%rax
  802edc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802ee2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802ee5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ee8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802eeb:	75 05                	jne    802ef2 <_pipeisclosed+0x7d>
			return ret;
  802eed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ef0:	eb 4f                	jmp    802f41 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802ef2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802ef8:	74 42                	je     802f3c <_pipeisclosed+0xc7>
  802efa:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802efe:	75 3c                	jne    802f3c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802f00:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f07:	00 00 00 
  802f0a:	48 8b 00             	mov    (%rax),%rax
  802f0d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802f13:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802f16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f19:	89 c6                	mov    %eax,%esi
  802f1b:	48 bf 33 3d 80 00 00 	movabs $0x803d33,%rdi
  802f22:	00 00 00 
  802f25:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2a:	49 b8 f7 02 80 00 00 	movabs $0x8002f7,%r8
  802f31:	00 00 00 
  802f34:	41 ff d0             	callq  *%r8
	}
  802f37:	e9 4a ff ff ff       	jmpq   802e86 <_pipeisclosed+0x11>
  802f3c:	e9 45 ff ff ff       	jmpq   802e86 <_pipeisclosed+0x11>
}
  802f41:	48 83 c4 28          	add    $0x28,%rsp
  802f45:	5b                   	pop    %rbx
  802f46:	5d                   	pop    %rbp
  802f47:	c3                   	retq   

0000000000802f48 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 30          	sub    $0x30,%rsp
  802f50:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f53:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f57:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f5a:	48 89 d6             	mov    %rdx,%rsi
  802f5d:	89 c7                	mov    %eax,%edi
  802f5f:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  802f66:	00 00 00 
  802f69:	ff d0                	callq  *%rax
  802f6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f72:	79 05                	jns    802f79 <pipeisclosed+0x31>
		return r;
  802f74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f77:	eb 31                	jmp    802faa <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7d:	48 89 c7             	mov    %rax,%rdi
  802f80:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  802f87:	00 00 00 
  802f8a:	ff d0                	callq  *%rax
  802f8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f98:	48 89 d6             	mov    %rdx,%rsi
  802f9b:	48 89 c7             	mov    %rax,%rdi
  802f9e:	48 b8 75 2e 80 00 00 	movabs $0x802e75,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
}
  802faa:	c9                   	leaveq 
  802fab:	c3                   	retq   

0000000000802fac <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802fac:	55                   	push   %rbp
  802fad:	48 89 e5             	mov    %rsp,%rbp
  802fb0:	48 83 ec 40          	sub    $0x40,%rsp
  802fb4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fb8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fbc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802fc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc4:	48 89 c7             	mov    %rax,%rdi
  802fc7:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  802fce:	00 00 00 
  802fd1:	ff d0                	callq  *%rax
  802fd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802fd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fdb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802fdf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802fe6:	00 
  802fe7:	e9 92 00 00 00       	jmpq   80307e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802fec:	eb 41                	jmp    80302f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802fee:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802ff3:	74 09                	je     802ffe <devpipe_read+0x52>
				return i;
  802ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff9:	e9 92 00 00 00       	jmpq   803090 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802ffe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803006:	48 89 d6             	mov    %rdx,%rsi
  803009:	48 89 c7             	mov    %rax,%rdi
  80300c:	48 b8 75 2e 80 00 00 	movabs $0x802e75,%rax
  803013:	00 00 00 
  803016:	ff d0                	callq  *%rax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 07                	je     803023 <devpipe_read+0x77>
				return 0;
  80301c:	b8 00 00 00 00       	mov    $0x0,%eax
  803021:	eb 6d                	jmp    803090 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803023:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  80302a:	00 00 00 
  80302d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80302f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803033:	8b 10                	mov    (%rax),%edx
  803035:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803039:	8b 40 04             	mov    0x4(%rax),%eax
  80303c:	39 c2                	cmp    %eax,%edx
  80303e:	74 ae                	je     802fee <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803044:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803048:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80304c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803050:	8b 00                	mov    (%rax),%eax
  803052:	99                   	cltd   
  803053:	c1 ea 1b             	shr    $0x1b,%edx
  803056:	01 d0                	add    %edx,%eax
  803058:	83 e0 1f             	and    $0x1f,%eax
  80305b:	29 d0                	sub    %edx,%eax
  80305d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803061:	48 98                	cltq   
  803063:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803068:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80306a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306e:	8b 00                	mov    (%rax),%eax
  803070:	8d 50 01             	lea    0x1(%rax),%edx
  803073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803077:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803079:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80307e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803082:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803086:	0f 82 60 ff ff ff    	jb     802fec <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80308c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803090:	c9                   	leaveq 
  803091:	c3                   	retq   

0000000000803092 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803092:	55                   	push   %rbp
  803093:	48 89 e5             	mov    %rsp,%rbp
  803096:	48 83 ec 40          	sub    $0x40,%rsp
  80309a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80309e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030a2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8030a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030aa:	48 89 c7             	mov    %rax,%rdi
  8030ad:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  8030b4:	00 00 00 
  8030b7:	ff d0                	callq  *%rax
  8030b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8030bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8030c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8030cc:	00 
  8030cd:	e9 8e 00 00 00       	jmpq   803160 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030d2:	eb 31                	jmp    803105 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8030d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030dc:	48 89 d6             	mov    %rdx,%rsi
  8030df:	48 89 c7             	mov    %rax,%rdi
  8030e2:	48 b8 75 2e 80 00 00 	movabs $0x802e75,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	74 07                	je     8030f9 <devpipe_write+0x67>
				return 0;
  8030f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f7:	eb 79                	jmp    803172 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8030f9:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803109:	8b 40 04             	mov    0x4(%rax),%eax
  80310c:	48 63 d0             	movslq %eax,%rdx
  80310f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803113:	8b 00                	mov    (%rax),%eax
  803115:	48 98                	cltq   
  803117:	48 83 c0 20          	add    $0x20,%rax
  80311b:	48 39 c2             	cmp    %rax,%rdx
  80311e:	73 b4                	jae    8030d4 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803124:	8b 40 04             	mov    0x4(%rax),%eax
  803127:	99                   	cltd   
  803128:	c1 ea 1b             	shr    $0x1b,%edx
  80312b:	01 d0                	add    %edx,%eax
  80312d:	83 e0 1f             	and    $0x1f,%eax
  803130:	29 d0                	sub    %edx,%eax
  803132:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803136:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80313a:	48 01 ca             	add    %rcx,%rdx
  80313d:	0f b6 0a             	movzbl (%rdx),%ecx
  803140:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803144:	48 98                	cltq   
  803146:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80314a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80314e:	8b 40 04             	mov    0x4(%rax),%eax
  803151:	8d 50 01             	lea    0x1(%rax),%edx
  803154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803158:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80315b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803164:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803168:	0f 82 64 ff ff ff    	jb     8030d2 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80316e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803172:	c9                   	leaveq 
  803173:	c3                   	retq   

0000000000803174 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803174:	55                   	push   %rbp
  803175:	48 89 e5             	mov    %rsp,%rbp
  803178:	48 83 ec 20          	sub    $0x20,%rsp
  80317c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803180:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803188:	48 89 c7             	mov    %rax,%rdi
  80318b:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  803192:	00 00 00 
  803195:	ff d0                	callq  *%rax
  803197:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80319b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319f:	48 be 46 3d 80 00 00 	movabs $0x803d46,%rsi
  8031a6:	00 00 00 
  8031a9:	48 89 c7             	mov    %rax,%rdi
  8031ac:	48 b8 bf 0e 80 00 00 	movabs $0x800ebf,%rax
  8031b3:	00 00 00 
  8031b6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8031b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bc:	8b 50 04             	mov    0x4(%rax),%edx
  8031bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c3:	8b 00                	mov    (%rax),%eax
  8031c5:	29 c2                	sub    %eax,%edx
  8031c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8031d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8031dc:	00 00 00 
	stat->st_dev = &devpipe;
  8031df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e3:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8031ea:	00 00 00 
  8031ed:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8031f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f9:	c9                   	leaveq 
  8031fa:	c3                   	retq   

00000000008031fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8031fb:	55                   	push   %rbp
  8031fc:	48 89 e5             	mov    %rsp,%rbp
  8031ff:	48 83 ec 10          	sub    $0x10,%rsp
  803203:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80320b:	48 89 c6             	mov    %rax,%rsi
  80320e:	bf 00 00 00 00       	mov    $0x0,%edi
  803213:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80321f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803223:	48 89 c7             	mov    %rax,%rdi
  803226:	48 b8 59 1c 80 00 00 	movabs $0x801c59,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	48 89 c6             	mov    %rax,%rsi
  803235:	bf 00 00 00 00       	mov    $0x0,%edi
  80323a:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  803241:	00 00 00 
  803244:	ff d0                	callq  *%rax
}
  803246:	c9                   	leaveq 
  803247:	c3                   	retq   

0000000000803248 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803248:	55                   	push   %rbp
  803249:	48 89 e5             	mov    %rsp,%rbp
  80324c:	48 83 ec 20          	sub    $0x20,%rsp
  803250:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803253:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803256:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803259:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80325d:	be 01 00 00 00       	mov    $0x1,%esi
  803262:	48 89 c7             	mov    %rax,%rdi
  803265:	48 b8 a6 16 80 00 00 	movabs $0x8016a6,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
}
  803271:	c9                   	leaveq 
  803272:	c3                   	retq   

0000000000803273 <getchar>:

int
getchar(void)
{
  803273:	55                   	push   %rbp
  803274:	48 89 e5             	mov    %rsp,%rbp
  803277:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80327b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80327f:	ba 01 00 00 00       	mov    $0x1,%edx
  803284:	48 89 c6             	mov    %rax,%rsi
  803287:	bf 00 00 00 00       	mov    $0x0,%edi
  80328c:	48 b8 4e 21 80 00 00 	movabs $0x80214e,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80329b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80329f:	79 05                	jns    8032a6 <getchar+0x33>
		return r;
  8032a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a4:	eb 14                	jmp    8032ba <getchar+0x47>
	if (r < 1)
  8032a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032aa:	7f 07                	jg     8032b3 <getchar+0x40>
		return -E_EOF;
  8032ac:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8032b1:	eb 07                	jmp    8032ba <getchar+0x47>
	return c;
  8032b3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8032b7:	0f b6 c0             	movzbl %al,%eax
}
  8032ba:	c9                   	leaveq 
  8032bb:	c3                   	retq   

00000000008032bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	48 83 ec 20          	sub    $0x20,%rsp
  8032c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ce:	48 89 d6             	mov    %rdx,%rsi
  8032d1:	89 c7                	mov    %eax,%edi
  8032d3:	48 b8 1c 1d 80 00 00 	movabs $0x801d1c,%rax
  8032da:	00 00 00 
  8032dd:	ff d0                	callq  *%rax
  8032df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e6:	79 05                	jns    8032ed <iscons+0x31>
		return r;
  8032e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032eb:	eb 1a                	jmp    803307 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8032ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f1:	8b 10                	mov    (%rax),%edx
  8032f3:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8032fa:	00 00 00 
  8032fd:	8b 00                	mov    (%rax),%eax
  8032ff:	39 c2                	cmp    %eax,%edx
  803301:	0f 94 c0             	sete   %al
  803304:	0f b6 c0             	movzbl %al,%eax
}
  803307:	c9                   	leaveq 
  803308:	c3                   	retq   

0000000000803309 <opencons>:

int
opencons(void)
{
  803309:	55                   	push   %rbp
  80330a:	48 89 e5             	mov    %rsp,%rbp
  80330d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803311:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803315:	48 89 c7             	mov    %rax,%rdi
  803318:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
  803324:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803327:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332b:	79 05                	jns    803332 <opencons+0x29>
		return r;
  80332d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803330:	eb 5b                	jmp    80338d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803336:	ba 07 04 00 00       	mov    $0x407,%edx
  80333b:	48 89 c6             	mov    %rax,%rsi
  80333e:	bf 00 00 00 00       	mov    $0x0,%edi
  803343:	48 b8 ee 17 80 00 00 	movabs $0x8017ee,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	callq  *%rax
  80334f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803356:	79 05                	jns    80335d <opencons+0x54>
		return r;
  803358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335b:	eb 30                	jmp    80338d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80335d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803361:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803368:	00 00 00 
  80336b:	8b 12                	mov    (%rdx),%edx
  80336d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80336f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803373:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80337a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337e:	48 89 c7             	mov    %rax,%rdi
  803381:	48 b8 36 1c 80 00 00 	movabs $0x801c36,%rax
  803388:	00 00 00 
  80338b:	ff d0                	callq  *%rax
}
  80338d:	c9                   	leaveq 
  80338e:	c3                   	retq   

000000000080338f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80338f:	55                   	push   %rbp
  803390:	48 89 e5             	mov    %rsp,%rbp
  803393:	48 83 ec 30          	sub    $0x30,%rsp
  803397:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80339b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80339f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8033a3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033a8:	75 07                	jne    8033b1 <devcons_read+0x22>
		return 0;
  8033aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033af:	eb 4b                	jmp    8033fc <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8033b1:	eb 0c                	jmp    8033bf <devcons_read+0x30>
		sys_yield();
  8033b3:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  8033ba:	00 00 00 
  8033bd:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8033bf:	48 b8 f0 16 80 00 00 	movabs $0x8016f0,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
  8033cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d2:	74 df                	je     8033b3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8033d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d8:	79 05                	jns    8033df <devcons_read+0x50>
		return c;
  8033da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033dd:	eb 1d                	jmp    8033fc <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8033df:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8033e3:	75 07                	jne    8033ec <devcons_read+0x5d>
		return 0;
  8033e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ea:	eb 10                	jmp    8033fc <devcons_read+0x6d>
	*(char*)vbuf = c;
  8033ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ef:	89 c2                	mov    %eax,%edx
  8033f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f5:	88 10                	mov    %dl,(%rax)
	return 1;
  8033f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8033fc:	c9                   	leaveq 
  8033fd:	c3                   	retq   

00000000008033fe <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033fe:	55                   	push   %rbp
  8033ff:	48 89 e5             	mov    %rsp,%rbp
  803402:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803409:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803410:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803417:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80341e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803425:	eb 76                	jmp    80349d <devcons_write+0x9f>
		m = n - tot;
  803427:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80342e:	89 c2                	mov    %eax,%edx
  803430:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803433:	29 c2                	sub    %eax,%edx
  803435:	89 d0                	mov    %edx,%eax
  803437:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80343a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80343d:	83 f8 7f             	cmp    $0x7f,%eax
  803440:	76 07                	jbe    803449 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803442:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803449:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80344c:	48 63 d0             	movslq %eax,%rdx
  80344f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803452:	48 63 c8             	movslq %eax,%rcx
  803455:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80345c:	48 01 c1             	add    %rax,%rcx
  80345f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803466:	48 89 ce             	mov    %rcx,%rsi
  803469:	48 89 c7             	mov    %rax,%rdi
  80346c:	48 b8 e3 11 80 00 00 	movabs $0x8011e3,%rax
  803473:	00 00 00 
  803476:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803478:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80347b:	48 63 d0             	movslq %eax,%rdx
  80347e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803485:	48 89 d6             	mov    %rdx,%rsi
  803488:	48 89 c7             	mov    %rax,%rdi
  80348b:	48 b8 a6 16 80 00 00 	movabs $0x8016a6,%rax
  803492:	00 00 00 
  803495:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803497:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80349a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80349d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a0:	48 98                	cltq   
  8034a2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8034a9:	0f 82 78 ff ff ff    	jb     803427 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8034af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034b2:	c9                   	leaveq 
  8034b3:	c3                   	retq   

00000000008034b4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8034b4:	55                   	push   %rbp
  8034b5:	48 89 e5             	mov    %rsp,%rbp
  8034b8:	48 83 ec 08          	sub    $0x8,%rsp
  8034bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034c5:	c9                   	leaveq 
  8034c6:	c3                   	retq   

00000000008034c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8034c7:	55                   	push   %rbp
  8034c8:	48 89 e5             	mov    %rsp,%rbp
  8034cb:	48 83 ec 10          	sub    $0x10,%rsp
  8034cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8034d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034db:	48 be 52 3d 80 00 00 	movabs $0x803d52,%rsi
  8034e2:	00 00 00 
  8034e5:	48 89 c7             	mov    %rax,%rdi
  8034e8:	48 b8 bf 0e 80 00 00 	movabs $0x800ebf,%rax
  8034ef:	00 00 00 
  8034f2:	ff d0                	callq  *%rax
	return 0;
  8034f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034f9:	c9                   	leaveq 
  8034fa:	c3                   	retq   

00000000008034fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8034fb:	55                   	push   %rbp
  8034fc:	48 89 e5             	mov    %rsp,%rbp
  8034ff:	53                   	push   %rbx
  803500:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803507:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80350e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803514:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80351b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803522:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803529:	84 c0                	test   %al,%al
  80352b:	74 23                	je     803550 <_panic+0x55>
  80352d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803534:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803538:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80353c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803540:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803544:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803548:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80354c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803550:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803557:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80355e:	00 00 00 
  803561:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803568:	00 00 00 
  80356b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80356f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803576:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80357d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803584:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80358b:	00 00 00 
  80358e:	48 8b 18             	mov    (%rax),%rbx
  803591:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  803598:	00 00 00 
  80359b:	ff d0                	callq  *%rax
  80359d:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8035a3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8035aa:	41 89 c8             	mov    %ecx,%r8d
  8035ad:	48 89 d1             	mov    %rdx,%rcx
  8035b0:	48 89 da             	mov    %rbx,%rdx
  8035b3:	89 c6                	mov    %eax,%esi
  8035b5:	48 bf 60 3d 80 00 00 	movabs $0x803d60,%rdi
  8035bc:	00 00 00 
  8035bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c4:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  8035cb:	00 00 00 
  8035ce:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8035d1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8035d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8035df:	48 89 d6             	mov    %rdx,%rsi
  8035e2:	48 89 c7             	mov    %rax,%rdi
  8035e5:	48 b8 4b 02 80 00 00 	movabs $0x80024b,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
	cprintf("\n");
  8035f1:	48 bf 83 3d 80 00 00 	movabs $0x803d83,%rdi
  8035f8:	00 00 00 
  8035fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803600:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  803607:	00 00 00 
  80360a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80360c:	cc                   	int3   
  80360d:	eb fd                	jmp    80360c <_panic+0x111>

000000000080360f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80360f:	55                   	push   %rbp
  803610:	48 89 e5             	mov    %rsp,%rbp
  803613:	48 83 ec 18          	sub    $0x18,%rsp
  803617:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80361b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361f:	48 c1 e8 15          	shr    $0x15,%rax
  803623:	48 89 c2             	mov    %rax,%rdx
  803626:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80362d:	01 00 00 
  803630:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803634:	83 e0 01             	and    $0x1,%eax
  803637:	48 85 c0             	test   %rax,%rax
  80363a:	75 07                	jne    803643 <pageref+0x34>
		return 0;
  80363c:	b8 00 00 00 00       	mov    $0x0,%eax
  803641:	eb 53                	jmp    803696 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803647:	48 c1 e8 0c          	shr    $0xc,%rax
  80364b:	48 89 c2             	mov    %rax,%rdx
  80364e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803655:	01 00 00 
  803658:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80365c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803664:	83 e0 01             	and    $0x1,%eax
  803667:	48 85 c0             	test   %rax,%rax
  80366a:	75 07                	jne    803673 <pageref+0x64>
		return 0;
  80366c:	b8 00 00 00 00       	mov    $0x0,%eax
  803671:	eb 23                	jmp    803696 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803677:	48 c1 e8 0c          	shr    $0xc,%rax
  80367b:	48 89 c2             	mov    %rax,%rdx
  80367e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803685:	00 00 00 
  803688:	48 c1 e2 04          	shl    $0x4,%rdx
  80368c:	48 01 d0             	add    %rdx,%rax
  80368f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803693:	0f b7 c0             	movzwl %ax,%eax
}
  803696:	c9                   	leaveq 
  803697:	c3                   	retq   
