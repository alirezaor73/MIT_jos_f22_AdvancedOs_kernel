
obj/user/pingpong:     file format elf64-x86-64


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
  80003c:	e8 06 01 00 00       	callq  800147 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t who;

	if ((who = fork()) != 0) {
  800053:	48 b8 dd 1d 80 00 00 	movabs $0x801ddd,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800062:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	74 4e                	je     8000b7 <umain+0x74>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800069:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006c:	48 b8 9b 17 80 00 00 	movabs $0x80179b,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax
  800078:	89 da                	mov    %ebx,%edx
  80007a:	89 c6                	mov    %eax,%esi
  80007c:	48 bf 20 3e 80 00 00 	movabs $0x803e20,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  800092:	00 00 00 
  800095:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800097:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	be 00 00 00 00       	mov    $0x0,%esi
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	48 b8 4f 21 80 00 00 	movabs $0x80214f,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 00 00 00       	mov    $0x0,%esi
  8000c5:	48 89 c7             	mov    %rax,%rdi
  8000c8:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
  8000d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000d7:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000da:	48 b8 9b 17 80 00 00 	movabs $0x80179b,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000e9:	89 d9                	mov    %ebx,%ecx
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	48 bf 36 3e 80 00 00 	movabs $0x803e36,%rdi
  8000f4:	00 00 00 
  8000f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fc:	49 b8 20 03 80 00 00 	movabs $0x800320,%r8
  800103:	00 00 00 
  800106:	41 ff d0             	callq  *%r8
		if (i == 10)
  800109:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  80010d:	75 02                	jne    800111 <umain+0xce>
			return;
  80010f:	eb 2f                	jmp    800140 <umain+0xfd>
		i++;
  800111:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
		ipc_send(who, i, 0, 0);
  800115:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800118:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80011b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	48 b8 4f 21 80 00 00 	movabs $0x80214f,%rax
  80012e:	00 00 00 
  800131:	ff d0                	callq  *%rax
		if (i == 10)
  800133:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800137:	75 02                	jne    80013b <umain+0xf8>
			return;
  800139:	eb 05                	jmp    800140 <umain+0xfd>
	}
  80013b:	e9 77 ff ff ff       	jmpq   8000b7 <umain+0x74>

}
  800140:	48 83 c4 28          	add    $0x28,%rsp
  800144:	5b                   	pop    %rbx
  800145:	5d                   	pop    %rbp
  800146:	c3                   	retq   

0000000000800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 20          	sub    $0x20,%rsp
  80014f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800156:	48 b8 9b 17 80 00 00 	movabs $0x80179b,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016d:	48 63 d0             	movslq %eax,%rdx
  800170:	48 89 d0             	mov    %rdx,%rax
  800173:	48 c1 e0 03          	shl    $0x3,%rax
  800177:	48 01 d0             	add    %rdx,%rax
  80017a:	48 c1 e0 05          	shl    $0x5,%rax
  80017e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800185:	00 00 00 
  800188:	48 01 c2             	add    %rax,%rdx
  80018b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800192:	00 00 00 
  800195:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800198:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80019c:	7e 14                	jle    8001b2 <libmain+0x6b>
		binaryname = argv[0];
  80019e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001a2:	48 8b 10             	mov    (%rax),%rdx
  8001a5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001ac:	00 00 00 
  8001af:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001b9:	48 89 d6             	mov    %rdx,%rsi
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001ca:	48 b8 d8 01 80 00 00 	movabs $0x8001d8,%rax
  8001d1:	00 00 00 
  8001d4:	ff d0                	callq  *%rax
}
  8001d6:	c9                   	leaveq 
  8001d7:	c3                   	retq   

00000000008001d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d8:	55                   	push   %rbp
  8001d9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001dc:	48 b8 aa 25 80 00 00 	movabs $0x8025aa,%rax
  8001e3:	00 00 00 
  8001e6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ed:	48 b8 57 17 80 00 00 	movabs $0x801757,%rax
  8001f4:	00 00 00 
  8001f7:	ff d0                	callq  *%rax
}
  8001f9:	5d                   	pop    %rbp
  8001fa:	c3                   	retq   

00000000008001fb <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001fb:	55                   	push   %rbp
  8001fc:	48 89 e5             	mov    %rsp,%rbp
  8001ff:	48 83 ec 10          	sub    $0x10,%rsp
  800203:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800206:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80020a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020e:	8b 00                	mov    (%rax),%eax
  800210:	8d 48 01             	lea    0x1(%rax),%ecx
  800213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800217:	89 0a                	mov    %ecx,(%rdx)
  800219:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80021c:	89 d1                	mov    %edx,%ecx
  80021e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800222:	48 98                	cltq   
  800224:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	8b 00                	mov    (%rax),%eax
  80022e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800233:	75 2c                	jne    800261 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800239:	8b 00                	mov    (%rax),%eax
  80023b:	48 98                	cltq   
  80023d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800241:	48 83 c2 08          	add    $0x8,%rdx
  800245:	48 89 c6             	mov    %rax,%rsi
  800248:	48 89 d7             	mov    %rdx,%rdi
  80024b:	48 b8 cf 16 80 00 00 	movabs $0x8016cf,%rax
  800252:	00 00 00 
  800255:	ff d0                	callq  *%rax
        b->idx = 0;
  800257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800265:	8b 40 04             	mov    0x4(%rax),%eax
  800268:	8d 50 01             	lea    0x1(%rax),%edx
  80026b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800272:	c9                   	leaveq 
  800273:	c3                   	retq   

0000000000800274 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80027f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800286:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80028d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800294:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80029b:	48 8b 0a             	mov    (%rdx),%rcx
  80029e:	48 89 08             	mov    %rcx,(%rax)
  8002a1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ad:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b8:	00 00 00 
    b.cnt = 0;
  8002bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002c2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002c5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002cc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002d3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002da:	48 89 c6             	mov    %rax,%rsi
  8002dd:	48 bf fb 01 80 00 00 	movabs $0x8001fb,%rdi
  8002e4:	00 00 00 
  8002e7:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002f3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f9:	48 98                	cltq   
  8002fb:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800302:	48 83 c2 08          	add    $0x8,%rdx
  800306:	48 89 c6             	mov    %rax,%rsi
  800309:	48 89 d7             	mov    %rdx,%rdi
  80030c:	48 b8 cf 16 80 00 00 	movabs $0x8016cf,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800318:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80031e:	c9                   	leaveq 
  80031f:	c3                   	retq   

0000000000800320 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80032b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800332:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800339:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800340:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800347:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80034e:	84 c0                	test   %al,%al
  800350:	74 20                	je     800372 <cprintf+0x52>
  800352:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800356:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80035a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80035e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800362:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800366:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80036a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80036e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800372:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800379:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800380:	00 00 00 
  800383:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80038a:	00 00 00 
  80038d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800391:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800398:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80039f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003a6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ad:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003b4:	48 8b 0a             	mov    (%rdx),%rcx
  8003b7:	48 89 08             	mov    %rcx,(%rax)
  8003ba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003be:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003ca:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d8:	48 89 d6             	mov    %rdx,%rsi
  8003db:	48 89 c7             	mov    %rax,%rdi
  8003de:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  8003e5:	00 00 00 
  8003e8:	ff d0                	callq  *%rax
  8003ea:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003f0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f6:	c9                   	leaveq 
  8003f7:	c3                   	retq   

00000000008003f8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f8:	55                   	push   %rbp
  8003f9:	48 89 e5             	mov    %rsp,%rbp
  8003fc:	53                   	push   %rbx
  8003fd:	48 83 ec 38          	sub    $0x38,%rsp
  800401:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800409:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80040d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800410:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800414:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800418:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80041b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80041f:	77 3b                	ja     80045c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800421:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800424:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800428:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80042b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042f:	ba 00 00 00 00       	mov    $0x0,%edx
  800434:	48 f7 f3             	div    %rbx
  800437:	48 89 c2             	mov    %rax,%rdx
  80043a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80043d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800440:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800448:	41 89 f9             	mov    %edi,%r9d
  80044b:	48 89 c7             	mov    %rax,%rdi
  80044e:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
  80045a:	eb 1e                	jmp    80047a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045c:	eb 12                	jmp    800470 <printnum+0x78>
			putch(padc, putdat);
  80045e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800462:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800469:	48 89 ce             	mov    %rcx,%rsi
  80046c:	89 d7                	mov    %edx,%edi
  80046e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800470:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800474:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800478:	7f e4                	jg     80045e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80047d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800481:	ba 00 00 00 00       	mov    $0x0,%edx
  800486:	48 f7 f1             	div    %rcx
  800489:	48 89 d0             	mov    %rdx,%rax
  80048c:	48 ba 50 40 80 00 00 	movabs $0x804050,%rdx
  800493:	00 00 00 
  800496:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80049a:	0f be d0             	movsbl %al,%edx
  80049d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a5:	48 89 ce             	mov    %rcx,%rsi
  8004a8:	89 d7                	mov    %edx,%edi
  8004aa:	ff d0                	callq  *%rax
}
  8004ac:	48 83 c4 38          	add    $0x38,%rsp
  8004b0:	5b                   	pop    %rbx
  8004b1:	5d                   	pop    %rbp
  8004b2:	c3                   	retq   

00000000008004b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b3:	55                   	push   %rbp
  8004b4:	48 89 e5             	mov    %rsp,%rbp
  8004b7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8004c2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c6:	7e 52                	jle    80051a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	83 f8 30             	cmp    $0x30,%eax
  8004d1:	73 24                	jae    8004f7 <getuint+0x44>
  8004d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004df:	8b 00                	mov    (%rax),%eax
  8004e1:	89 c0                	mov    %eax,%eax
  8004e3:	48 01 d0             	add    %rdx,%rax
  8004e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ea:	8b 12                	mov    (%rdx),%edx
  8004ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f3:	89 0a                	mov    %ecx,(%rdx)
  8004f5:	eb 17                	jmp    80050e <getuint+0x5b>
  8004f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ff:	48 89 d0             	mov    %rdx,%rax
  800502:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800506:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050e:	48 8b 00             	mov    (%rax),%rax
  800511:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800515:	e9 a3 00 00 00       	jmpq   8005bd <getuint+0x10a>
	else if (lflag)
  80051a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80051e:	74 4f                	je     80056f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	8b 00                	mov    (%rax),%eax
  800526:	83 f8 30             	cmp    $0x30,%eax
  800529:	73 24                	jae    80054f <getuint+0x9c>
  80052b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	8b 00                	mov    (%rax),%eax
  800539:	89 c0                	mov    %eax,%eax
  80053b:	48 01 d0             	add    %rdx,%rax
  80053e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800542:	8b 12                	mov    (%rdx),%edx
  800544:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800547:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054b:	89 0a                	mov    %ecx,(%rdx)
  80054d:	eb 17                	jmp    800566 <getuint+0xb3>
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800557:	48 89 d0             	mov    %rdx,%rax
  80055a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800566:	48 8b 00             	mov    (%rax),%rax
  800569:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056d:	eb 4e                	jmp    8005bd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	8b 00                	mov    (%rax),%eax
  800575:	83 f8 30             	cmp    $0x30,%eax
  800578:	73 24                	jae    80059e <getuint+0xeb>
  80057a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	8b 00                	mov    (%rax),%eax
  800588:	89 c0                	mov    %eax,%eax
  80058a:	48 01 d0             	add    %rdx,%rax
  80058d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800591:	8b 12                	mov    (%rdx),%edx
  800593:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800596:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059a:	89 0a                	mov    %ecx,(%rdx)
  80059c:	eb 17                	jmp    8005b5 <getuint+0x102>
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a6:	48 89 d0             	mov    %rdx,%rax
  8005a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b5:	8b 00                	mov    (%rax),%eax
  8005b7:	89 c0                	mov    %eax,%eax
  8005b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d6:	7e 52                	jle    80062a <getint+0x67>
		x=va_arg(*ap, long long);
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	83 f8 30             	cmp    $0x30,%eax
  8005e1:	73 24                	jae    800607 <getint+0x44>
  8005e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	8b 00                	mov    (%rax),%eax
  8005f1:	89 c0                	mov    %eax,%eax
  8005f3:	48 01 d0             	add    %rdx,%rax
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	8b 12                	mov    (%rdx),%edx
  8005fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800603:	89 0a                	mov    %ecx,(%rdx)
  800605:	eb 17                	jmp    80061e <getint+0x5b>
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060f:	48 89 d0             	mov    %rdx,%rax
  800612:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061e:	48 8b 00             	mov    (%rax),%rax
  800621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800625:	e9 a3 00 00 00       	jmpq   8006cd <getint+0x10a>
	else if (lflag)
  80062a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80062e:	74 4f                	je     80067f <getint+0xbc>
		x=va_arg(*ap, long);
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	8b 00                	mov    (%rax),%eax
  800636:	83 f8 30             	cmp    $0x30,%eax
  800639:	73 24                	jae    80065f <getint+0x9c>
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	8b 00                	mov    (%rax),%eax
  800649:	89 c0                	mov    %eax,%eax
  80064b:	48 01 d0             	add    %rdx,%rax
  80064e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800652:	8b 12                	mov    (%rdx),%edx
  800654:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065b:	89 0a                	mov    %ecx,(%rdx)
  80065d:	eb 17                	jmp    800676 <getint+0xb3>
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800667:	48 89 d0             	mov    %rdx,%rax
  80066a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800672:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800676:	48 8b 00             	mov    (%rax),%rax
  800679:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067d:	eb 4e                	jmp    8006cd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	83 f8 30             	cmp    $0x30,%eax
  800688:	73 24                	jae    8006ae <getint+0xeb>
  80068a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	8b 00                	mov    (%rax),%eax
  800698:	89 c0                	mov    %eax,%eax
  80069a:	48 01 d0             	add    %rdx,%rax
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	8b 12                	mov    (%rdx),%edx
  8006a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006aa:	89 0a                	mov    %ecx,(%rdx)
  8006ac:	eb 17                	jmp    8006c5 <getint+0x102>
  8006ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b6:	48 89 d0             	mov    %rdx,%rax
  8006b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c5:	8b 00                	mov    (%rax),%eax
  8006c7:	48 98                	cltq   
  8006c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d1:	c9                   	leaveq 
  8006d2:	c3                   	retq   

00000000008006d3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d3:	55                   	push   %rbp
  8006d4:	48 89 e5             	mov    %rsp,%rbp
  8006d7:	41 54                	push   %r12
  8006d9:	53                   	push   %rbx
  8006da:	48 83 ec 60          	sub    $0x60,%rsp
  8006de:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ea:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f6:	48 8b 0a             	mov    (%rdx),%rcx
  8006f9:	48 89 08             	mov    %rcx,(%rax)
  8006fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800700:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800704:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800708:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070c:	eb 17                	jmp    800725 <vprintfmt+0x52>
			if (ch == '\0')
  80070e:	85 db                	test   %ebx,%ebx
  800710:	0f 84 df 04 00 00    	je     800bf5 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800716:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80071a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80071e:	48 89 d6             	mov    %rdx,%rsi
  800721:	89 df                	mov    %ebx,%edi
  800723:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800729:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80072d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800731:	0f b6 00             	movzbl (%rax),%eax
  800734:	0f b6 d8             	movzbl %al,%ebx
  800737:	83 fb 25             	cmp    $0x25,%ebx
  80073a:	75 d2                	jne    80070e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800740:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800747:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80074e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800755:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800760:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800764:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800768:	0f b6 00             	movzbl (%rax),%eax
  80076b:	0f b6 d8             	movzbl %al,%ebx
  80076e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800771:	83 f8 55             	cmp    $0x55,%eax
  800774:	0f 87 47 04 00 00    	ja     800bc1 <vprintfmt+0x4ee>
  80077a:	89 c0                	mov    %eax,%eax
  80077c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800783:	00 
  800784:	48 b8 78 40 80 00 00 	movabs $0x804078,%rax
  80078b:	00 00 00 
  80078e:	48 01 d0             	add    %rdx,%rax
  800791:	48 8b 00             	mov    (%rax),%rax
  800794:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800796:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80079a:	eb c0                	jmp    80075c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007a0:	eb ba                	jmp    80075c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007a9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 02             	shl    $0x2,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d8                	add    %ebx,%eax
  8007b7:	83 e8 30             	sub    $0x30,%eax
  8007ba:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007bd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c1:	0f b6 00             	movzbl (%rax),%eax
  8007c4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ca:	7e 0c                	jle    8007d8 <vprintfmt+0x105>
  8007cc:	83 fb 39             	cmp    $0x39,%ebx
  8007cf:	7f 07                	jg     8007d8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d6:	eb d1                	jmp    8007a9 <vprintfmt+0xd6>
			goto process_precision;
  8007d8:	eb 58                	jmp    800832 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dd:	83 f8 30             	cmp    $0x30,%eax
  8007e0:	73 17                	jae    8007f9 <vprintfmt+0x126>
  8007e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e9:	89 c0                	mov    %eax,%eax
  8007eb:	48 01 d0             	add    %rdx,%rax
  8007ee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f1:	83 c2 08             	add    $0x8,%edx
  8007f4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f7:	eb 0f                	jmp    800808 <vprintfmt+0x135>
  8007f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fd:	48 89 d0             	mov    %rdx,%rax
  800800:	48 83 c2 08          	add    $0x8,%rdx
  800804:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800808:	8b 00                	mov    (%rax),%eax
  80080a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80080d:	eb 23                	jmp    800832 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80080f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800813:	79 0c                	jns    800821 <vprintfmt+0x14e>
				width = 0;
  800815:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80081c:	e9 3b ff ff ff       	jmpq   80075c <vprintfmt+0x89>
  800821:	e9 36 ff ff ff       	jmpq   80075c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800826:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80082d:	e9 2a ff ff ff       	jmpq   80075c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800832:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800836:	79 12                	jns    80084a <vprintfmt+0x177>
				width = precision, precision = -1;
  800838:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80083b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80083e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800845:	e9 12 ff ff ff       	jmpq   80075c <vprintfmt+0x89>
  80084a:	e9 0d ff ff ff       	jmpq   80075c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800853:	e9 04 ff ff ff       	jmpq   80075c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800858:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085b:	83 f8 30             	cmp    $0x30,%eax
  80085e:	73 17                	jae    800877 <vprintfmt+0x1a4>
  800860:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800864:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800867:	89 c0                	mov    %eax,%eax
  800869:	48 01 d0             	add    %rdx,%rax
  80086c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086f:	83 c2 08             	add    $0x8,%edx
  800872:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800875:	eb 0f                	jmp    800886 <vprintfmt+0x1b3>
  800877:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087b:	48 89 d0             	mov    %rdx,%rax
  80087e:	48 83 c2 08          	add    $0x8,%rdx
  800882:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800886:	8b 10                	mov    (%rax),%edx
  800888:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80088c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800890:	48 89 ce             	mov    %rcx,%rsi
  800893:	89 d7                	mov    %edx,%edi
  800895:	ff d0                	callq  *%rax
			break;
  800897:	e9 53 03 00 00       	jmpq   800bef <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80089c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089f:	83 f8 30             	cmp    $0x30,%eax
  8008a2:	73 17                	jae    8008bb <vprintfmt+0x1e8>
  8008a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	89 c0                	mov    %eax,%eax
  8008ad:	48 01 d0             	add    %rdx,%rax
  8008b0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b3:	83 c2 08             	add    $0x8,%edx
  8008b6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b9:	eb 0f                	jmp    8008ca <vprintfmt+0x1f7>
  8008bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bf:	48 89 d0             	mov    %rdx,%rax
  8008c2:	48 83 c2 08          	add    $0x8,%rdx
  8008c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ca:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008cc:	85 db                	test   %ebx,%ebx
  8008ce:	79 02                	jns    8008d2 <vprintfmt+0x1ff>
				err = -err;
  8008d0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d2:	83 fb 15             	cmp    $0x15,%ebx
  8008d5:	7f 16                	jg     8008ed <vprintfmt+0x21a>
  8008d7:	48 b8 a0 3f 80 00 00 	movabs $0x803fa0,%rax
  8008de:	00 00 00 
  8008e1:	48 63 d3             	movslq %ebx,%rdx
  8008e4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e8:	4d 85 e4             	test   %r12,%r12
  8008eb:	75 2e                	jne    80091b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008ed:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f5:	89 d9                	mov    %ebx,%ecx
  8008f7:	48 ba 61 40 80 00 00 	movabs $0x804061,%rdx
  8008fe:	00 00 00 
  800901:	48 89 c7             	mov    %rax,%rdi
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	49 b8 fe 0b 80 00 00 	movabs $0x800bfe,%r8
  800910:	00 00 00 
  800913:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800916:	e9 d4 02 00 00       	jmpq   800bef <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800923:	4c 89 e1             	mov    %r12,%rcx
  800926:	48 ba 6a 40 80 00 00 	movabs $0x80406a,%rdx
  80092d:	00 00 00 
  800930:	48 89 c7             	mov    %rax,%rdi
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
  800938:	49 b8 fe 0b 80 00 00 	movabs $0x800bfe,%r8
  80093f:	00 00 00 
  800942:	41 ff d0             	callq  *%r8
			break;
  800945:	e9 a5 02 00 00       	jmpq   800bef <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80094a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094d:	83 f8 30             	cmp    $0x30,%eax
  800950:	73 17                	jae    800969 <vprintfmt+0x296>
  800952:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	89 c0                	mov    %eax,%eax
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800961:	83 c2 08             	add    $0x8,%edx
  800964:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800967:	eb 0f                	jmp    800978 <vprintfmt+0x2a5>
  800969:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096d:	48 89 d0             	mov    %rdx,%rax
  800970:	48 83 c2 08          	add    $0x8,%rdx
  800974:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800978:	4c 8b 20             	mov    (%rax),%r12
  80097b:	4d 85 e4             	test   %r12,%r12
  80097e:	75 0a                	jne    80098a <vprintfmt+0x2b7>
				p = "(null)";
  800980:	49 bc 6d 40 80 00 00 	movabs $0x80406d,%r12
  800987:	00 00 00 
			if (width > 0 && padc != '-')
  80098a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098e:	7e 3f                	jle    8009cf <vprintfmt+0x2fc>
  800990:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800994:	74 39                	je     8009cf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800996:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800999:	48 98                	cltq   
  80099b:	48 89 c6             	mov    %rax,%rsi
  80099e:	4c 89 e7             	mov    %r12,%rdi
  8009a1:	48 b8 aa 0e 80 00 00 	movabs $0x800eaa,%rax
  8009a8:	00 00 00 
  8009ab:	ff d0                	callq  *%rax
  8009ad:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009b0:	eb 17                	jmp    8009c9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009b2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009ba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009be:	48 89 ce             	mov    %rcx,%rsi
  8009c1:	89 d7                	mov    %edx,%edi
  8009c3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cd:	7f e3                	jg     8009b2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cf:	eb 37                	jmp    800a08 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009d5:	74 1e                	je     8009f5 <vprintfmt+0x322>
  8009d7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009da:	7e 05                	jle    8009e1 <vprintfmt+0x30e>
  8009dc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009df:	7e 14                	jle    8009f5 <vprintfmt+0x322>
					putch('?', putdat);
  8009e1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e9:	48 89 d6             	mov    %rdx,%rsi
  8009ec:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009f1:	ff d0                	callq  *%rax
  8009f3:	eb 0f                	jmp    800a04 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009f5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fd:	48 89 d6             	mov    %rdx,%rsi
  800a00:	89 df                	mov    %ebx,%edi
  800a02:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a04:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a08:	4c 89 e0             	mov    %r12,%rax
  800a0b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a0f:	0f b6 00             	movzbl (%rax),%eax
  800a12:	0f be d8             	movsbl %al,%ebx
  800a15:	85 db                	test   %ebx,%ebx
  800a17:	74 10                	je     800a29 <vprintfmt+0x356>
  800a19:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1d:	78 b2                	js     8009d1 <vprintfmt+0x2fe>
  800a1f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a23:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a27:	79 a8                	jns    8009d1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a29:	eb 16                	jmp    800a41 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a33:	48 89 d6             	mov    %rdx,%rsi
  800a36:	bf 20 00 00 00       	mov    $0x20,%edi
  800a3b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a45:	7f e4                	jg     800a2b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a47:	e9 a3 01 00 00       	jmpq   800bef <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a4c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a50:	be 03 00 00 00       	mov    $0x3,%esi
  800a55:	48 89 c7             	mov    %rax,%rdi
  800a58:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800a5f:	00 00 00 
  800a62:	ff d0                	callq  *%rax
  800a64:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6c:	48 85 c0             	test   %rax,%rax
  800a6f:	79 1d                	jns    800a8e <vprintfmt+0x3bb>
				putch('-', putdat);
  800a71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a79:	48 89 d6             	mov    %rdx,%rsi
  800a7c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a81:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a87:	48 f7 d8             	neg    %rax
  800a8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a8e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a95:	e9 e8 00 00 00       	jmpq   800b82 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a9a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9e:	be 03 00 00 00       	mov    $0x3,%esi
  800aa3:	48 89 c7             	mov    %rax,%rdi
  800aa6:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800abd:	e9 c0 00 00 00       	jmpq   800b82 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aca:	48 89 d6             	mov    %rdx,%rsi
  800acd:	bf 58 00 00 00       	mov    $0x58,%edi
  800ad2:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ad4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adc:	48 89 d6             	mov    %rdx,%rsi
  800adf:	bf 58 00 00 00       	mov    $0x58,%edi
  800ae4:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ae6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aee:	48 89 d6             	mov    %rdx,%rsi
  800af1:	bf 58 00 00 00       	mov    $0x58,%edi
  800af6:	ff d0                	callq  *%rax
			break;
  800af8:	e9 f2 00 00 00       	jmpq   800bef <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800afd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b05:	48 89 d6             	mov    %rdx,%rsi
  800b08:	bf 30 00 00 00       	mov    $0x30,%edi
  800b0d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b17:	48 89 d6             	mov    %rdx,%rsi
  800b1a:	bf 78 00 00 00       	mov    $0x78,%edi
  800b1f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b24:	83 f8 30             	cmp    $0x30,%eax
  800b27:	73 17                	jae    800b40 <vprintfmt+0x46d>
  800b29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b30:	89 c0                	mov    %eax,%eax
  800b32:	48 01 d0             	add    %rdx,%rax
  800b35:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b38:	83 c2 08             	add    $0x8,%edx
  800b3b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3e:	eb 0f                	jmp    800b4f <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800b40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b44:	48 89 d0             	mov    %rdx,%rax
  800b47:	48 83 c2 08          	add    $0x8,%rdx
  800b4b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b56:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b5d:	eb 23                	jmp    800b82 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b5f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b63:	be 03 00 00 00       	mov    $0x3,%esi
  800b68:	48 89 c7             	mov    %rax,%rdi
  800b6b:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  800b72:	00 00 00 
  800b75:	ff d0                	callq  *%rax
  800b77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b7b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b82:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b87:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b8a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b91:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b99:	45 89 c1             	mov    %r8d,%r9d
  800b9c:	41 89 f8             	mov    %edi,%r8d
  800b9f:	48 89 c7             	mov    %rax,%rdi
  800ba2:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800ba9:	00 00 00 
  800bac:	ff d0                	callq  *%rax
			break;
  800bae:	eb 3f                	jmp    800bef <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb8:	48 89 d6             	mov    %rdx,%rsi
  800bbb:	89 df                	mov    %ebx,%edi
  800bbd:	ff d0                	callq  *%rax
			break;
  800bbf:	eb 2e                	jmp    800bef <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc9:	48 89 d6             	mov    %rdx,%rsi
  800bcc:	bf 25 00 00 00       	mov    $0x25,%edi
  800bd1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bd8:	eb 05                	jmp    800bdf <vprintfmt+0x50c>
  800bda:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bdf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be3:	48 83 e8 01          	sub    $0x1,%rax
  800be7:	0f b6 00             	movzbl (%rax),%eax
  800bea:	3c 25                	cmp    $0x25,%al
  800bec:	75 ec                	jne    800bda <vprintfmt+0x507>
				/* do nothing */;
			break;
  800bee:	90                   	nop
		}
	}
  800bef:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf0:	e9 30 fb ff ff       	jmpq   800725 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bf5:	48 83 c4 60          	add    $0x60,%rsp
  800bf9:	5b                   	pop    %rbx
  800bfa:	41 5c                	pop    %r12
  800bfc:	5d                   	pop    %rbp
  800bfd:	c3                   	retq   

0000000000800bfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bfe:	55                   	push   %rbp
  800bff:	48 89 e5             	mov    %rsp,%rbp
  800c02:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c09:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c10:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c17:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c1e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c25:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c2c:	84 c0                	test   %al,%al
  800c2e:	74 20                	je     800c50 <printfmt+0x52>
  800c30:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c34:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c38:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c3c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c40:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c44:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c48:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c4c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c50:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c57:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c5e:	00 00 00 
  800c61:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c68:	00 00 00 
  800c6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c6f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c76:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c7d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c84:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c8b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c92:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c99:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ca0:	48 89 c7             	mov    %rax,%rdi
  800ca3:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  800caa:	00 00 00 
  800cad:	ff d0                	callq  *%rax
	va_end(ap);
}
  800caf:	c9                   	leaveq 
  800cb0:	c3                   	retq   

0000000000800cb1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb1:	55                   	push   %rbp
  800cb2:	48 89 e5             	mov    %rsp,%rbp
  800cb5:	48 83 ec 10          	sub    $0x10,%rsp
  800cb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc4:	8b 40 10             	mov    0x10(%rax),%eax
  800cc7:	8d 50 01             	lea    0x1(%rax),%edx
  800cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cce:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd5:	48 8b 10             	mov    (%rax),%rdx
  800cd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdc:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ce0:	48 39 c2             	cmp    %rax,%rdx
  800ce3:	73 17                	jae    800cfc <sprintputch+0x4b>
		*b->buf++ = ch;
  800ce5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce9:	48 8b 00             	mov    (%rax),%rax
  800cec:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cf0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf4:	48 89 0a             	mov    %rcx,(%rdx)
  800cf7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cfa:	88 10                	mov    %dl,(%rax)
}
  800cfc:	c9                   	leaveq 
  800cfd:	c3                   	retq   

0000000000800cfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cfe:	55                   	push   %rbp
  800cff:	48 89 e5             	mov    %rsp,%rbp
  800d02:	48 83 ec 50          	sub    $0x50,%rsp
  800d06:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d0a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d0d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d11:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d15:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d19:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d1d:	48 8b 0a             	mov    (%rdx),%rcx
  800d20:	48 89 08             	mov    %rcx,(%rax)
  800d23:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d27:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d2b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d2f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d37:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d3b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d3e:	48 98                	cltq   
  800d40:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d48:	48 01 d0             	add    %rdx,%rax
  800d4b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d56:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d5b:	74 06                	je     800d63 <vsnprintf+0x65>
  800d5d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d61:	7f 07                	jg     800d6a <vsnprintf+0x6c>
		return -E_INVAL;
  800d63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d68:	eb 2f                	jmp    800d99 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d6a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d6e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d72:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d76:	48 89 c6             	mov    %rax,%rsi
  800d79:	48 bf b1 0c 80 00 00 	movabs $0x800cb1,%rdi
  800d80:	00 00 00 
  800d83:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  800d8a:	00 00 00 
  800d8d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d93:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d96:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d99:	c9                   	leaveq 
  800d9a:	c3                   	retq   

0000000000800d9b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9b:	55                   	push   %rbp
  800d9c:	48 89 e5             	mov    %rsp,%rbp
  800d9f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800da6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800dad:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800db3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dba:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 20                	je     800dec <snprintf+0x51>
  800dcc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dd0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ddc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800de0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dec:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800df3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dfa:	00 00 00 
  800dfd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e04:	00 00 00 
  800e07:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e0b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e12:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e19:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e20:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e27:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e2e:	48 8b 0a             	mov    (%rdx),%rcx
  800e31:	48 89 08             	mov    %rcx,(%rax)
  800e34:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e38:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e3c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e40:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e44:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e4b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e52:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e58:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e5f:	48 89 c7             	mov    %rax,%rdi
  800e62:	48 b8 fe 0c 80 00 00 	movabs $0x800cfe,%rax
  800e69:	00 00 00 
  800e6c:	ff d0                	callq  *%rax
  800e6e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e74:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e7a:	c9                   	leaveq 
  800e7b:	c3                   	retq   

0000000000800e7c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e7c:	55                   	push   %rbp
  800e7d:	48 89 e5             	mov    %rsp,%rbp
  800e80:	48 83 ec 18          	sub    $0x18,%rsp
  800e84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e8f:	eb 09                	jmp    800e9a <strlen+0x1e>
		n++;
  800e91:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e95:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9e:	0f b6 00             	movzbl (%rax),%eax
  800ea1:	84 c0                	test   %al,%al
  800ea3:	75 ec                	jne    800e91 <strlen+0x15>
		n++;
	return n;
  800ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea8:	c9                   	leaveq 
  800ea9:	c3                   	retq   

0000000000800eaa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eaa:	55                   	push   %rbp
  800eab:	48 89 e5             	mov    %rsp,%rbp
  800eae:	48 83 ec 20          	sub    $0x20,%rsp
  800eb2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ec1:	eb 0e                	jmp    800ed1 <strnlen+0x27>
		n++;
  800ec3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ecc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ed1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ed6:	74 0b                	je     800ee3 <strnlen+0x39>
  800ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edc:	0f b6 00             	movzbl (%rax),%eax
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 e0                	jne    800ec3 <strnlen+0x19>
		n++;
	return n;
  800ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ee6:	c9                   	leaveq 
  800ee7:	c3                   	retq   

0000000000800ee8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee8:	55                   	push   %rbp
  800ee9:	48 89 e5             	mov    %rsp,%rbp
  800eec:	48 83 ec 20          	sub    $0x20,%rsp
  800ef0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f00:	90                   	nop
  800f01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f05:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f09:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f0d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f11:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f15:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f19:	0f b6 12             	movzbl (%rdx),%edx
  800f1c:	88 10                	mov    %dl,(%rax)
  800f1e:	0f b6 00             	movzbl (%rax),%eax
  800f21:	84 c0                	test   %al,%al
  800f23:	75 dc                	jne    800f01 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f29:	c9                   	leaveq 
  800f2a:	c3                   	retq   

0000000000800f2b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f2b:	55                   	push   %rbp
  800f2c:	48 89 e5             	mov    %rsp,%rbp
  800f2f:	48 83 ec 20          	sub    $0x20,%rsp
  800f33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3f:	48 89 c7             	mov    %rax,%rdi
  800f42:	48 b8 7c 0e 80 00 00 	movabs $0x800e7c,%rax
  800f49:	00 00 00 
  800f4c:	ff d0                	callq  *%rax
  800f4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f54:	48 63 d0             	movslq %eax,%rdx
  800f57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5b:	48 01 c2             	add    %rax,%rdx
  800f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f62:	48 89 c6             	mov    %rax,%rsi
  800f65:	48 89 d7             	mov    %rdx,%rdi
  800f68:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  800f6f:	00 00 00 
  800f72:	ff d0                	callq  *%rax
	return dst;
  800f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f78:	c9                   	leaveq 
  800f79:	c3                   	retq   

0000000000800f7a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f7a:	55                   	push   %rbp
  800f7b:	48 89 e5             	mov    %rsp,%rbp
  800f7e:	48 83 ec 28          	sub    $0x28,%rsp
  800f82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f8a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f96:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f9d:	00 
  800f9e:	eb 2a                	jmp    800fca <strncpy+0x50>
		*dst++ = *src;
  800fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fac:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb0:	0f b6 12             	movzbl (%rdx),%edx
  800fb3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fb9:	0f b6 00             	movzbl (%rax),%eax
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 05                	je     800fc5 <strncpy+0x4b>
			src++;
  800fc0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fc5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fd2:	72 cc                	jb     800fa0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fd8:	c9                   	leaveq 
  800fd9:	c3                   	retq   

0000000000800fda <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fda:	55                   	push   %rbp
  800fdb:	48 89 e5             	mov    %rsp,%rbp
  800fde:	48 83 ec 28          	sub    $0x28,%rsp
  800fe2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800ff6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ffb:	74 3d                	je     80103a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ffd:	eb 1d                	jmp    80101c <strlcpy+0x42>
			*dst++ = *src++;
  800fff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801003:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801007:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80100b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80100f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801013:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801017:	0f b6 12             	movzbl (%rdx),%edx
  80101a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80101c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801021:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801026:	74 0b                	je     801033 <strlcpy+0x59>
  801028:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80102c:	0f b6 00             	movzbl (%rax),%eax
  80102f:	84 c0                	test   %al,%al
  801031:	75 cc                	jne    800fff <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801037:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80103a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80103e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801042:	48 29 c2             	sub    %rax,%rdx
  801045:	48 89 d0             	mov    %rdx,%rax
}
  801048:	c9                   	leaveq 
  801049:	c3                   	retq   

000000000080104a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80104a:	55                   	push   %rbp
  80104b:	48 89 e5             	mov    %rsp,%rbp
  80104e:	48 83 ec 10          	sub    $0x10,%rsp
  801052:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801056:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80105a:	eb 0a                	jmp    801066 <strcmp+0x1c>
		p++, q++;
  80105c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801061:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106a:	0f b6 00             	movzbl (%rax),%eax
  80106d:	84 c0                	test   %al,%al
  80106f:	74 12                	je     801083 <strcmp+0x39>
  801071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801075:	0f b6 10             	movzbl (%rax),%edx
  801078:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107c:	0f b6 00             	movzbl (%rax),%eax
  80107f:	38 c2                	cmp    %al,%dl
  801081:	74 d9                	je     80105c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801083:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801087:	0f b6 00             	movzbl (%rax),%eax
  80108a:	0f b6 d0             	movzbl %al,%edx
  80108d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801091:	0f b6 00             	movzbl (%rax),%eax
  801094:	0f b6 c0             	movzbl %al,%eax
  801097:	29 c2                	sub    %eax,%edx
  801099:	89 d0                	mov    %edx,%eax
}
  80109b:	c9                   	leaveq 
  80109c:	c3                   	retq   

000000000080109d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80109d:	55                   	push   %rbp
  80109e:	48 89 e5             	mov    %rsp,%rbp
  8010a1:	48 83 ec 18          	sub    $0x18,%rsp
  8010a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010b1:	eb 0f                	jmp    8010c2 <strncmp+0x25>
		n--, p++, q++;
  8010b3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010bd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010c2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010c7:	74 1d                	je     8010e6 <strncmp+0x49>
  8010c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cd:	0f b6 00             	movzbl (%rax),%eax
  8010d0:	84 c0                	test   %al,%al
  8010d2:	74 12                	je     8010e6 <strncmp+0x49>
  8010d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d8:	0f b6 10             	movzbl (%rax),%edx
  8010db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010df:	0f b6 00             	movzbl (%rax),%eax
  8010e2:	38 c2                	cmp    %al,%dl
  8010e4:	74 cd                	je     8010b3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010eb:	75 07                	jne    8010f4 <strncmp+0x57>
		return 0;
  8010ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f2:	eb 18                	jmp    80110c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f8:	0f b6 00             	movzbl (%rax),%eax
  8010fb:	0f b6 d0             	movzbl %al,%edx
  8010fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801102:	0f b6 00             	movzbl (%rax),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	29 c2                	sub    %eax,%edx
  80110a:	89 d0                	mov    %edx,%eax
}
  80110c:	c9                   	leaveq 
  80110d:	c3                   	retq   

000000000080110e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80110e:	55                   	push   %rbp
  80110f:	48 89 e5             	mov    %rsp,%rbp
  801112:	48 83 ec 0c          	sub    $0xc,%rsp
  801116:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111a:	89 f0                	mov    %esi,%eax
  80111c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80111f:	eb 17                	jmp    801138 <strchr+0x2a>
		if (*s == c)
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801125:	0f b6 00             	movzbl (%rax),%eax
  801128:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80112b:	75 06                	jne    801133 <strchr+0x25>
			return (char *) s;
  80112d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801131:	eb 15                	jmp    801148 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801133:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801138:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113c:	0f b6 00             	movzbl (%rax),%eax
  80113f:	84 c0                	test   %al,%al
  801141:	75 de                	jne    801121 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801143:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801148:	c9                   	leaveq 
  801149:	c3                   	retq   

000000000080114a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80114a:	55                   	push   %rbp
  80114b:	48 89 e5             	mov    %rsp,%rbp
  80114e:	48 83 ec 0c          	sub    $0xc,%rsp
  801152:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801156:	89 f0                	mov    %esi,%eax
  801158:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80115b:	eb 13                	jmp    801170 <strfind+0x26>
		if (*s == c)
  80115d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801161:	0f b6 00             	movzbl (%rax),%eax
  801164:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801167:	75 02                	jne    80116b <strfind+0x21>
			break;
  801169:	eb 10                	jmp    80117b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80116b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801174:	0f b6 00             	movzbl (%rax),%eax
  801177:	84 c0                	test   %al,%al
  801179:	75 e2                	jne    80115d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80117f:	c9                   	leaveq 
  801180:	c3                   	retq   

0000000000801181 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801181:	55                   	push   %rbp
  801182:	48 89 e5             	mov    %rsp,%rbp
  801185:	48 83 ec 18          	sub    $0x18,%rsp
  801189:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801190:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801194:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801199:	75 06                	jne    8011a1 <memset+0x20>
		return v;
  80119b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119f:	eb 69                	jmp    80120a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a5:	83 e0 03             	and    $0x3,%eax
  8011a8:	48 85 c0             	test   %rax,%rax
  8011ab:	75 48                	jne    8011f5 <memset+0x74>
  8011ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b1:	83 e0 03             	and    $0x3,%eax
  8011b4:	48 85 c0             	test   %rax,%rax
  8011b7:	75 3c                	jne    8011f5 <memset+0x74>
		c &= 0xFF;
  8011b9:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c3:	c1 e0 18             	shl    $0x18,%eax
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011cb:	c1 e0 10             	shl    $0x10,%eax
  8011ce:	09 c2                	or     %eax,%edx
  8011d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d3:	c1 e0 08             	shl    $0x8,%eax
  8011d6:	09 d0                	or     %edx,%eax
  8011d8:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	48 c1 e8 02          	shr    $0x2,%rax
  8011e3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ed:	48 89 d7             	mov    %rdx,%rdi
  8011f0:	fc                   	cld    
  8011f1:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011f3:	eb 11                	jmp    801206 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011fc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801200:	48 89 d7             	mov    %rdx,%rdi
  801203:	fc                   	cld    
  801204:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801206:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80120a:	c9                   	leaveq 
  80120b:	c3                   	retq   

000000000080120c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80120c:	55                   	push   %rbp
  80120d:	48 89 e5             	mov    %rsp,%rbp
  801210:	48 83 ec 28          	sub    $0x28,%rsp
  801214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801218:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801220:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801224:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801234:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801238:	0f 83 88 00 00 00    	jae    8012c6 <memmove+0xba>
  80123e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801242:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801246:	48 01 d0             	add    %rdx,%rax
  801249:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80124d:	76 77                	jbe    8012c6 <memmove+0xba>
		s += n;
  80124f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801253:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80125f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801263:	83 e0 03             	and    $0x3,%eax
  801266:	48 85 c0             	test   %rax,%rax
  801269:	75 3b                	jne    8012a6 <memmove+0x9a>
  80126b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126f:	83 e0 03             	and    $0x3,%eax
  801272:	48 85 c0             	test   %rax,%rax
  801275:	75 2f                	jne    8012a6 <memmove+0x9a>
  801277:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80127b:	83 e0 03             	and    $0x3,%eax
  80127e:	48 85 c0             	test   %rax,%rax
  801281:	75 23                	jne    8012a6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801287:	48 83 e8 04          	sub    $0x4,%rax
  80128b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128f:	48 83 ea 04          	sub    $0x4,%rdx
  801293:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801297:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80129b:	48 89 c7             	mov    %rax,%rdi
  80129e:	48 89 d6             	mov    %rdx,%rsi
  8012a1:	fd                   	std    
  8012a2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012a4:	eb 1d                	jmp    8012c3 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012aa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ba:	48 89 d7             	mov    %rdx,%rdi
  8012bd:	48 89 c1             	mov    %rax,%rcx
  8012c0:	fd                   	std    
  8012c1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012c3:	fc                   	cld    
  8012c4:	eb 57                	jmp    80131d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	83 e0 03             	and    $0x3,%eax
  8012cd:	48 85 c0             	test   %rax,%rax
  8012d0:	75 36                	jne    801308 <memmove+0xfc>
  8012d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d6:	83 e0 03             	and    $0x3,%eax
  8012d9:	48 85 c0             	test   %rax,%rax
  8012dc:	75 2a                	jne    801308 <memmove+0xfc>
  8012de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e2:	83 e0 03             	and    $0x3,%eax
  8012e5:	48 85 c0             	test   %rax,%rax
  8012e8:	75 1e                	jne    801308 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ee:	48 c1 e8 02          	shr    $0x2,%rax
  8012f2:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012fd:	48 89 c7             	mov    %rax,%rdi
  801300:	48 89 d6             	mov    %rdx,%rsi
  801303:	fc                   	cld    
  801304:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801306:	eb 15                	jmp    80131d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801310:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801314:	48 89 c7             	mov    %rax,%rdi
  801317:	48 89 d6             	mov    %rdx,%rsi
  80131a:	fc                   	cld    
  80131b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80131d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801321:	c9                   	leaveq 
  801322:	c3                   	retq   

0000000000801323 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp
  801327:	48 83 ec 18          	sub    $0x18,%rsp
  80132b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801333:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801337:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80133b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80133f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801343:	48 89 ce             	mov    %rcx,%rsi
  801346:	48 89 c7             	mov    %rax,%rdi
  801349:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
}
  801355:	c9                   	leaveq 
  801356:	c3                   	retq   

0000000000801357 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801357:	55                   	push   %rbp
  801358:	48 89 e5             	mov    %rsp,%rbp
  80135b:	48 83 ec 28          	sub    $0x28,%rsp
  80135f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801363:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801367:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80136b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801373:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801377:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80137b:	eb 36                	jmp    8013b3 <memcmp+0x5c>
		if (*s1 != *s2)
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801381:	0f b6 10             	movzbl (%rax),%edx
  801384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801388:	0f b6 00             	movzbl (%rax),%eax
  80138b:	38 c2                	cmp    %al,%dl
  80138d:	74 1a                	je     8013a9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80138f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	0f b6 d0             	movzbl %al,%edx
  801399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139d:	0f b6 00             	movzbl (%rax),%eax
  8013a0:	0f b6 c0             	movzbl %al,%eax
  8013a3:	29 c2                	sub    %eax,%edx
  8013a5:	89 d0                	mov    %edx,%eax
  8013a7:	eb 20                	jmp    8013c9 <memcmp+0x72>
		s1++, s2++;
  8013a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ae:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013bf:	48 85 c0             	test   %rax,%rax
  8013c2:	75 b9                	jne    80137d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c9:	c9                   	leaveq 
  8013ca:	c3                   	retq   

00000000008013cb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	48 83 ec 28          	sub    $0x28,%rsp
  8013d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013e6:	48 01 d0             	add    %rdx,%rax
  8013e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013ed:	eb 15                	jmp    801404 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f3:	0f b6 10             	movzbl (%rax),%edx
  8013f6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013f9:	38 c2                	cmp    %al,%dl
  8013fb:	75 02                	jne    8013ff <memfind+0x34>
			break;
  8013fd:	eb 0f                	jmp    80140e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ff:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801408:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80140c:	72 e1                	jb     8013ef <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80140e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801412:	c9                   	leaveq 
  801413:	c3                   	retq   

0000000000801414 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801414:	55                   	push   %rbp
  801415:	48 89 e5             	mov    %rsp,%rbp
  801418:	48 83 ec 34          	sub    $0x34,%rsp
  80141c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801420:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801424:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801427:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80142e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801435:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801436:	eb 05                	jmp    80143d <strtol+0x29>
		s++;
  801438:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	3c 20                	cmp    $0x20,%al
  801446:	74 f0                	je     801438 <strtol+0x24>
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	0f b6 00             	movzbl (%rax),%eax
  80144f:	3c 09                	cmp    $0x9,%al
  801451:	74 e5                	je     801438 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	0f b6 00             	movzbl (%rax),%eax
  80145a:	3c 2b                	cmp    $0x2b,%al
  80145c:	75 07                	jne    801465 <strtol+0x51>
		s++;
  80145e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801463:	eb 17                	jmp    80147c <strtol+0x68>
	else if (*s == '-')
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	0f b6 00             	movzbl (%rax),%eax
  80146c:	3c 2d                	cmp    $0x2d,%al
  80146e:	75 0c                	jne    80147c <strtol+0x68>
		s++, neg = 1;
  801470:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801475:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801480:	74 06                	je     801488 <strtol+0x74>
  801482:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801486:	75 28                	jne    8014b0 <strtol+0x9c>
  801488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	3c 30                	cmp    $0x30,%al
  801491:	75 1d                	jne    8014b0 <strtol+0x9c>
  801493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801497:	48 83 c0 01          	add    $0x1,%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	3c 78                	cmp    $0x78,%al
  8014a0:	75 0e                	jne    8014b0 <strtol+0x9c>
		s += 2, base = 16;
  8014a2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014a7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014ae:	eb 2c                	jmp    8014dc <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014b4:	75 19                	jne    8014cf <strtol+0xbb>
  8014b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	3c 30                	cmp    $0x30,%al
  8014bf:	75 0e                	jne    8014cf <strtol+0xbb>
		s++, base = 8;
  8014c1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014c6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014cd:	eb 0d                	jmp    8014dc <strtol+0xc8>
	else if (base == 0)
  8014cf:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d3:	75 07                	jne    8014dc <strtol+0xc8>
		base = 10;
  8014d5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	3c 2f                	cmp    $0x2f,%al
  8014e5:	7e 1d                	jle    801504 <strtol+0xf0>
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	3c 39                	cmp    $0x39,%al
  8014f0:	7f 12                	jg     801504 <strtol+0xf0>
			dig = *s - '0';
  8014f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f6:	0f b6 00             	movzbl (%rax),%eax
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	83 e8 30             	sub    $0x30,%eax
  8014ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801502:	eb 4e                	jmp    801552 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	3c 60                	cmp    $0x60,%al
  80150d:	7e 1d                	jle    80152c <strtol+0x118>
  80150f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	3c 7a                	cmp    $0x7a,%al
  801518:	7f 12                	jg     80152c <strtol+0x118>
			dig = *s - 'a' + 10;
  80151a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151e:	0f b6 00             	movzbl (%rax),%eax
  801521:	0f be c0             	movsbl %al,%eax
  801524:	83 e8 57             	sub    $0x57,%eax
  801527:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80152a:	eb 26                	jmp    801552 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	3c 40                	cmp    $0x40,%al
  801535:	7e 48                	jle    80157f <strtol+0x16b>
  801537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	3c 5a                	cmp    $0x5a,%al
  801540:	7f 3d                	jg     80157f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	0f b6 00             	movzbl (%rax),%eax
  801549:	0f be c0             	movsbl %al,%eax
  80154c:	83 e8 37             	sub    $0x37,%eax
  80154f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801552:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801555:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801558:	7c 02                	jl     80155c <strtol+0x148>
			break;
  80155a:	eb 23                	jmp    80157f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80155c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801561:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801564:	48 98                	cltq   
  801566:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80156b:	48 89 c2             	mov    %rax,%rdx
  80156e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801571:	48 98                	cltq   
  801573:	48 01 d0             	add    %rdx,%rax
  801576:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80157a:	e9 5d ff ff ff       	jmpq   8014dc <strtol+0xc8>

	if (endptr)
  80157f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801584:	74 0b                	je     801591 <strtol+0x17d>
		*endptr = (char *) s;
  801586:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80158a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80158e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801591:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801595:	74 09                	je     8015a0 <strtol+0x18c>
  801597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159b:	48 f7 d8             	neg    %rax
  80159e:	eb 04                	jmp    8015a4 <strtol+0x190>
  8015a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015a4:	c9                   	leaveq 
  8015a5:	c3                   	retq   

00000000008015a6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015a6:	55                   	push   %rbp
  8015a7:	48 89 e5             	mov    %rsp,%rbp
  8015aa:	48 83 ec 30          	sub    $0x30,%rsp
  8015ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015be:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015c8:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015cc:	75 06                	jne    8015d4 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	eb 6b                	jmp    80163f <strstr+0x99>

	len = strlen(str);
  8015d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d8:	48 89 c7             	mov    %rax,%rdi
  8015db:	48 b8 7c 0e 80 00 00 	movabs $0x800e7c,%rax
  8015e2:	00 00 00 
  8015e5:	ff d0                	callq  *%rax
  8015e7:	48 98                	cltq   
  8015e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015ff:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801603:	75 07                	jne    80160c <strstr+0x66>
				return (char *) 0;
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	eb 33                	jmp    80163f <strstr+0x99>
		} while (sc != c);
  80160c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801610:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801613:	75 d8                	jne    8015ed <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801615:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801619:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80161d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801621:	48 89 ce             	mov    %rcx,%rsi
  801624:	48 89 c7             	mov    %rax,%rdi
  801627:	48 b8 9d 10 80 00 00 	movabs $0x80109d,%rax
  80162e:	00 00 00 
  801631:	ff d0                	callq  *%rax
  801633:	85 c0                	test   %eax,%eax
  801635:	75 b6                	jne    8015ed <strstr+0x47>

	return (char *) (in - 1);
  801637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163b:	48 83 e8 01          	sub    $0x1,%rax
}
  80163f:	c9                   	leaveq 
  801640:	c3                   	retq   

0000000000801641 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	53                   	push   %rbx
  801646:	48 83 ec 48          	sub    $0x48,%rsp
  80164a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80164d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801650:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801654:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801658:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80165c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801660:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801663:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801667:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80166b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80166f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801673:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801677:	4c 89 c3             	mov    %r8,%rbx
  80167a:	cd 30                	int    $0x30
  80167c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801680:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801684:	74 3e                	je     8016c4 <syscall+0x83>
  801686:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80168b:	7e 37                	jle    8016c4 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80168d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801691:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801694:	49 89 d0             	mov    %rdx,%r8
  801697:	89 c1                	mov    %eax,%ecx
  801699:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  8016a0:	00 00 00 
  8016a3:	be 23 00 00 00       	mov    $0x23,%esi
  8016a8:	48 bf 45 43 80 00 00 	movabs $0x804345,%rdi
  8016af:	00 00 00 
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b7:	49 b9 2e 3b 80 00 00 	movabs $0x803b2e,%r9
  8016be:	00 00 00 
  8016c1:	41 ff d1             	callq  *%r9

	return ret;
  8016c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016c8:	48 83 c4 48          	add    $0x48,%rsp
  8016cc:	5b                   	pop    %rbx
  8016cd:	5d                   	pop    %rbp
  8016ce:	c3                   	retq   

00000000008016cf <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016cf:	55                   	push   %rbp
  8016d0:	48 89 e5             	mov    %rsp,%rbp
  8016d3:	48 83 ec 20          	sub    $0x20,%rsp
  8016d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ee:	00 
  8016ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016fb:	48 89 d1             	mov    %rdx,%rcx
  8016fe:	48 89 c2             	mov    %rax,%rdx
  801701:	be 00 00 00 00       	mov    $0x0,%esi
  801706:	bf 00 00 00 00       	mov    $0x0,%edi
  80170b:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801712:	00 00 00 
  801715:	ff d0                	callq  *%rax
}
  801717:	c9                   	leaveq 
  801718:	c3                   	retq   

0000000000801719 <sys_cgetc>:

int
sys_cgetc(void)
{
  801719:	55                   	push   %rbp
  80171a:	48 89 e5             	mov    %rsp,%rbp
  80171d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801721:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801728:	00 
  801729:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801735:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173a:	ba 00 00 00 00       	mov    $0x0,%edx
  80173f:	be 00 00 00 00       	mov    $0x0,%esi
  801744:	bf 01 00 00 00       	mov    $0x1,%edi
  801749:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801750:	00 00 00 
  801753:	ff d0                	callq  *%rax
}
  801755:	c9                   	leaveq 
  801756:	c3                   	retq   

0000000000801757 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801757:	55                   	push   %rbp
  801758:	48 89 e5             	mov    %rsp,%rbp
  80175b:	48 83 ec 10          	sub    $0x10,%rsp
  80175f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801762:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801765:	48 98                	cltq   
  801767:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80176e:	00 
  80176f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801775:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80177b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801780:	48 89 c2             	mov    %rax,%rdx
  801783:	be 01 00 00 00       	mov    $0x1,%esi
  801788:	bf 03 00 00 00       	mov    $0x3,%edi
  80178d:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801794:	00 00 00 
  801797:	ff d0                	callq  *%rax
}
  801799:	c9                   	leaveq 
  80179a:	c3                   	retq   

000000000080179b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80179b:	55                   	push   %rbp
  80179c:	48 89 e5             	mov    %rsp,%rbp
  80179f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017aa:	00 
  8017ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c1:	be 00 00 00 00       	mov    $0x0,%esi
  8017c6:	bf 02 00 00 00       	mov    $0x2,%edi
  8017cb:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  8017d2:	00 00 00 
  8017d5:	ff d0                	callq  *%rax
}
  8017d7:	c9                   	leaveq 
  8017d8:	c3                   	retq   

00000000008017d9 <sys_yield>:

void
sys_yield(void)
{
  8017d9:	55                   	push   %rbp
  8017da:	48 89 e5             	mov    %rsp,%rbp
  8017dd:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017e1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e8:	00 
  8017e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ff:	be 00 00 00 00       	mov    $0x0,%esi
  801804:	bf 0b 00 00 00       	mov    $0xb,%edi
  801809:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801810:	00 00 00 
  801813:	ff d0                	callq  *%rax
}
  801815:	c9                   	leaveq 
  801816:	c3                   	retq   

0000000000801817 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801817:	55                   	push   %rbp
  801818:	48 89 e5             	mov    %rsp,%rbp
  80181b:	48 83 ec 20          	sub    $0x20,%rsp
  80181f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801822:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801826:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801829:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80182c:	48 63 c8             	movslq %eax,%rcx
  80182f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801833:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801836:	48 98                	cltq   
  801838:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183f:	00 
  801840:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801846:	49 89 c8             	mov    %rcx,%r8
  801849:	48 89 d1             	mov    %rdx,%rcx
  80184c:	48 89 c2             	mov    %rax,%rdx
  80184f:	be 01 00 00 00       	mov    $0x1,%esi
  801854:	bf 04 00 00 00       	mov    $0x4,%edi
  801859:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801860:	00 00 00 
  801863:	ff d0                	callq  *%rax
}
  801865:	c9                   	leaveq 
  801866:	c3                   	retq   

0000000000801867 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801867:	55                   	push   %rbp
  801868:	48 89 e5             	mov    %rsp,%rbp
  80186b:	48 83 ec 30          	sub    $0x30,%rsp
  80186f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801872:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801876:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801879:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80187d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801881:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801884:	48 63 c8             	movslq %eax,%rcx
  801887:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80188b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80188e:	48 63 f0             	movslq %eax,%rsi
  801891:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801898:	48 98                	cltq   
  80189a:	48 89 0c 24          	mov    %rcx,(%rsp)
  80189e:	49 89 f9             	mov    %rdi,%r9
  8018a1:	49 89 f0             	mov    %rsi,%r8
  8018a4:	48 89 d1             	mov    %rdx,%rcx
  8018a7:	48 89 c2             	mov    %rax,%rdx
  8018aa:	be 01 00 00 00       	mov    $0x1,%esi
  8018af:	bf 05 00 00 00       	mov    $0x5,%edi
  8018b4:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  8018bb:	00 00 00 
  8018be:	ff d0                	callq  *%rax
}
  8018c0:	c9                   	leaveq 
  8018c1:	c3                   	retq   

00000000008018c2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018c2:	55                   	push   %rbp
  8018c3:	48 89 e5             	mov    %rsp,%rbp
  8018c6:	48 83 ec 20          	sub    $0x20,%rsp
  8018ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d8:	48 98                	cltq   
  8018da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e1:	00 
  8018e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ee:	48 89 d1             	mov    %rdx,%rcx
  8018f1:	48 89 c2             	mov    %rax,%rdx
  8018f4:	be 01 00 00 00       	mov    $0x1,%esi
  8018f9:	bf 06 00 00 00       	mov    $0x6,%edi
  8018fe:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801905:	00 00 00 
  801908:	ff d0                	callq  *%rax
}
  80190a:	c9                   	leaveq 
  80190b:	c3                   	retq   

000000000080190c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80190c:	55                   	push   %rbp
  80190d:	48 89 e5             	mov    %rsp,%rbp
  801910:	48 83 ec 10          	sub    $0x10,%rsp
  801914:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801917:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80191a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80191d:	48 63 d0             	movslq %eax,%rdx
  801920:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801923:	48 98                	cltq   
  801925:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192c:	00 
  80192d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801933:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801939:	48 89 d1             	mov    %rdx,%rcx
  80193c:	48 89 c2             	mov    %rax,%rdx
  80193f:	be 01 00 00 00       	mov    $0x1,%esi
  801944:	bf 08 00 00 00       	mov    $0x8,%edi
  801949:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801950:	00 00 00 
  801953:	ff d0                	callq  *%rax
}
  801955:	c9                   	leaveq 
  801956:	c3                   	retq   

0000000000801957 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
  80195b:	48 83 ec 20          	sub    $0x20,%rsp
  80195f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801962:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801966:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196d:	48 98                	cltq   
  80196f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801976:	00 
  801977:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801983:	48 89 d1             	mov    %rdx,%rcx
  801986:	48 89 c2             	mov    %rax,%rdx
  801989:	be 01 00 00 00       	mov    $0x1,%esi
  80198e:	bf 09 00 00 00       	mov    $0x9,%edi
  801993:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  80199a:	00 00 00 
  80199d:	ff d0                	callq  *%rax
}
  80199f:	c9                   	leaveq 
  8019a0:	c3                   	retq   

00000000008019a1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019a1:	55                   	push   %rbp
  8019a2:	48 89 e5             	mov    %rsp,%rbp
  8019a5:	48 83 ec 20          	sub    $0x20,%rsp
  8019a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b7:	48 98                	cltq   
  8019b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c0:	00 
  8019c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cd:	48 89 d1             	mov    %rdx,%rcx
  8019d0:	48 89 c2             	mov    %rax,%rdx
  8019d3:	be 01 00 00 00       	mov    $0x1,%esi
  8019d8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019dd:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
}
  8019e9:	c9                   	leaveq 
  8019ea:	c3                   	retq   

00000000008019eb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019eb:	55                   	push   %rbp
  8019ec:	48 89 e5             	mov    %rsp,%rbp
  8019ef:	48 83 ec 20          	sub    $0x20,%rsp
  8019f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019fe:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a04:	48 63 f0             	movslq %eax,%rsi
  801a07:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0e:	48 98                	cltq   
  801a10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1b:	00 
  801a1c:	49 89 f1             	mov    %rsi,%r9
  801a1f:	49 89 c8             	mov    %rcx,%r8
  801a22:	48 89 d1             	mov    %rdx,%rcx
  801a25:	48 89 c2             	mov    %rax,%rdx
  801a28:	be 00 00 00 00       	mov    $0x0,%esi
  801a2d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a32:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	callq  *%rax
}
  801a3e:	c9                   	leaveq 
  801a3f:	c3                   	retq   

0000000000801a40 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a40:	55                   	push   %rbp
  801a41:	48 89 e5             	mov    %rsp,%rbp
  801a44:	48 83 ec 10          	sub    $0x10,%rsp
  801a48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a57:	00 
  801a58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a64:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a69:	48 89 c2             	mov    %rax,%rdx
  801a6c:	be 01 00 00 00       	mov    $0x1,%esi
  801a71:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a76:	48 b8 41 16 80 00 00 	movabs $0x801641,%rax
  801a7d:	00 00 00 
  801a80:	ff d0                	callq  *%rax
}
  801a82:	c9                   	leaveq 
  801a83:	c3                   	retq   

0000000000801a84 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a84:	55                   	push   %rbp
  801a85:	48 89 e5             	mov    %rsp,%rbp
  801a88:	48 83 ec 30          	sub    $0x30,%rsp
  801a8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a94:	48 8b 00             	mov    (%rax),%rax
  801a97:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801a9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801aa3:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801aa6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801aa9:	83 e0 02             	and    $0x2,%eax
  801aac:	85 c0                	test   %eax,%eax
  801aae:	75 4d                	jne    801afd <pgfault+0x79>
  801ab0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab4:	48 c1 e8 0c          	shr    $0xc,%rax
  801ab8:	48 89 c2             	mov    %rax,%rdx
  801abb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ac2:	01 00 00 
  801ac5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ac9:	25 00 08 00 00       	and    $0x800,%eax
  801ace:	48 85 c0             	test   %rax,%rax
  801ad1:	74 2a                	je     801afd <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801ad3:	48 ba 58 43 80 00 00 	movabs $0x804358,%rdx
  801ada:	00 00 00 
  801add:	be 1e 00 00 00       	mov    $0x1e,%esi
  801ae2:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801ae9:	00 00 00 
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
  801af1:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801af8:	00 00 00 
  801afb:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801afd:	ba 07 00 00 00       	mov    $0x7,%edx
  801b02:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b07:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0c:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	0f 85 cd 00 00 00    	jne    801bed <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b2c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b32:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801b36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b3f:	48 89 c6             	mov    %rax,%rsi
  801b42:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b47:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  801b4e:	00 00 00 
  801b51:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801b53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b57:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b5d:	48 89 c1             	mov    %rax,%rcx
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6f:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  801b76:	00 00 00 
  801b79:	ff d0                	callq  *%rax
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	79 2a                	jns    801ba9 <pgfault+0x125>
				panic("Page map at temp address failed");
  801b7f:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  801b86:	00 00 00 
  801b89:	be 2f 00 00 00       	mov    $0x2f,%esi
  801b8e:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801b95:	00 00 00 
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9d:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801ba4:	00 00 00 
  801ba7:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801ba9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bae:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb3:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  801bba:	00 00 00 
  801bbd:	ff d0                	callq  *%rax
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	79 54                	jns    801c17 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801bc3:	48 ba a8 43 80 00 00 	movabs $0x8043a8,%rdx
  801bca:	00 00 00 
  801bcd:	be 31 00 00 00       	mov    $0x31,%esi
  801bd2:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801bd9:	00 00 00 
  801bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801be1:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801be8:	00 00 00 
  801beb:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801bed:	48 ba d0 43 80 00 00 	movabs $0x8043d0,%rdx
  801bf4:	00 00 00 
  801bf7:	be 35 00 00 00       	mov    $0x35,%esi
  801bfc:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801c03:	00 00 00 
  801c06:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0b:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801c12:	00 00 00 
  801c15:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801c17:	c9                   	leaveq 
  801c18:	c3                   	retq   

0000000000801c19 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c19:	55                   	push   %rbp
  801c1a:	48 89 e5             	mov    %rsp,%rbp
  801c1d:	48 83 ec 20          	sub    $0x20,%rsp
  801c21:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c24:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801c27:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c2e:	01 00 00 
  801c31:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c38:	25 07 0e 00 00       	and    $0xe07,%eax
  801c3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c40:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c43:	48 c1 e0 0c          	shl    $0xc,%rax
  801c47:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4e:	25 00 04 00 00       	and    $0x400,%eax
  801c53:	85 c0                	test   %eax,%eax
  801c55:	74 57                	je     801cae <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c57:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c5a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c5e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c65:	41 89 f0             	mov    %esi,%r8d
  801c68:	48 89 c6             	mov    %rax,%rsi
  801c6b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c70:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	0f 8e 52 01 00 00    	jle    801dd6 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801c84:	48 ba fd 43 80 00 00 	movabs $0x8043fd,%rdx
  801c8b:	00 00 00 
  801c8e:	be 52 00 00 00       	mov    $0x52,%esi
  801c93:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801c9a:	00 00 00 
  801c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca2:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801ca9:	00 00 00 
  801cac:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb1:	83 e0 02             	and    $0x2,%eax
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	75 10                	jne    801cc8 <duppage+0xaf>
  801cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbb:	25 00 08 00 00       	and    $0x800,%eax
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	0f 84 bb 00 00 00    	je     801d83 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccb:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801cd0:	80 cc 08             	or     $0x8,%ah
  801cd3:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cd6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cd9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cdd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ce0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce4:	41 89 f0             	mov    %esi,%r8d
  801ce7:	48 89 c6             	mov    %rax,%rsi
  801cea:	bf 00 00 00 00       	mov    $0x0,%edi
  801cef:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  801cf6:	00 00 00 
  801cf9:	ff d0                	callq  *%rax
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	7e 2a                	jle    801d29 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801cff:	48 ba fd 43 80 00 00 	movabs $0x8043fd,%rdx
  801d06:	00 00 00 
  801d09:	be 5a 00 00 00       	mov    $0x5a,%esi
  801d0e:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801d15:	00 00 00 
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801d24:	00 00 00 
  801d27:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d29:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d34:	41 89 c8             	mov    %ecx,%r8d
  801d37:	48 89 d1             	mov    %rdx,%rcx
  801d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3f:	48 89 c6             	mov    %rax,%rsi
  801d42:	bf 00 00 00 00       	mov    $0x0,%edi
  801d47:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  801d4e:	00 00 00 
  801d51:	ff d0                	callq  *%rax
  801d53:	85 c0                	test   %eax,%eax
  801d55:	7e 2a                	jle    801d81 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801d57:	48 ba fd 43 80 00 00 	movabs $0x8043fd,%rdx
  801d5e:	00 00 00 
  801d61:	be 5d 00 00 00       	mov    $0x5d,%esi
  801d66:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801d6d:	00 00 00 
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
  801d75:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801d7c:	00 00 00 
  801d7f:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d81:	eb 53                	jmp    801dd6 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d83:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d86:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d8a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d91:	41 89 f0             	mov    %esi,%r8d
  801d94:	48 89 c6             	mov    %rax,%rsi
  801d97:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9c:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
  801da8:	85 c0                	test   %eax,%eax
  801daa:	7e 2a                	jle    801dd6 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801dac:	48 ba fd 43 80 00 00 	movabs $0x8043fd,%rdx
  801db3:	00 00 00 
  801db6:	be 61 00 00 00       	mov    $0x61,%esi
  801dbb:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801dc2:	00 00 00 
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dca:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  801dd1:	00 00 00 
  801dd4:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddb:	c9                   	leaveq 
  801ddc:	c3                   	retq   

0000000000801ddd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ddd:	55                   	push   %rbp
  801dde:	48 89 e5             	mov    %rsp,%rbp
  801de1:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801de5:	48 bf 84 1a 80 00 00 	movabs $0x801a84,%rdi
  801dec:	00 00 00 
  801def:	48 b8 42 3c 80 00 00 	movabs $0x803c42,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801dfb:	b8 07 00 00 00       	mov    $0x7,%eax
  801e00:	cd 30                	int    $0x30
  801e02:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801e08:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801e0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e0f:	79 30                	jns    801e41 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801e11:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e14:	89 c1                	mov    %eax,%ecx
  801e16:	48 ba 1b 44 80 00 00 	movabs $0x80441b,%rdx
  801e1d:	00 00 00 
  801e20:	be 89 00 00 00       	mov    $0x89,%esi
  801e25:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  801e2c:	00 00 00 
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	49 b8 2e 3b 80 00 00 	movabs $0x803b2e,%r8
  801e3b:	00 00 00 
  801e3e:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e45:	75 46                	jne    801e8d <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e47:	48 b8 9b 17 80 00 00 	movabs $0x80179b,%rax
  801e4e:	00 00 00 
  801e51:	ff d0                	callq  *%rax
  801e53:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e58:	48 63 d0             	movslq %eax,%rdx
  801e5b:	48 89 d0             	mov    %rdx,%rax
  801e5e:	48 c1 e0 03          	shl    $0x3,%rax
  801e62:	48 01 d0             	add    %rdx,%rax
  801e65:	48 c1 e0 05          	shl    $0x5,%rax
  801e69:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e70:	00 00 00 
  801e73:	48 01 c2             	add    %rax,%rdx
  801e76:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801e7d:	00 00 00 
  801e80:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e83:	b8 00 00 00 00       	mov    $0x0,%eax
  801e88:	e9 d1 01 00 00       	jmpq   80205e <fork+0x281>
	}

	uint64_t ad = 0;
  801e8d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801e94:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801e95:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801e9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801e9e:	e9 df 00 00 00       	jmpq   801f82 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea7:	48 c1 e8 27          	shr    $0x27,%rax
  801eab:	48 89 c2             	mov    %rax,%rdx
  801eae:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801eb5:	01 00 00 
  801eb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebc:	83 e0 01             	and    $0x1,%eax
  801ebf:	48 85 c0             	test   %rax,%rax
  801ec2:	0f 84 9e 00 00 00    	je     801f66 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801ec8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecc:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ed0:	48 89 c2             	mov    %rax,%rdx
  801ed3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801eda:	01 00 00 
  801edd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee1:	83 e0 01             	and    $0x1,%eax
  801ee4:	48 85 c0             	test   %rax,%rax
  801ee7:	74 73                	je     801f5c <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801ee9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eed:	48 c1 e8 15          	shr    $0x15,%rax
  801ef1:	48 89 c2             	mov    %rax,%rdx
  801ef4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801efb:	01 00 00 
  801efe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f02:	83 e0 01             	and    $0x1,%eax
  801f05:	48 85 c0             	test   %rax,%rax
  801f08:	74 48                	je     801f52 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f12:	48 89 c2             	mov    %rax,%rdx
  801f15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f1c:	01 00 00 
  801f1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f23:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2b:	83 e0 01             	and    $0x1,%eax
  801f2e:	48 85 c0             	test   %rax,%rax
  801f31:	74 47                	je     801f7a <fork+0x19d>
						duppage(envid, VPN(addr));
  801f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f37:	48 c1 e8 0c          	shr    $0xc,%rax
  801f3b:	89 c2                	mov    %eax,%edx
  801f3d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f40:	89 d6                	mov    %edx,%esi
  801f42:	89 c7                	mov    %eax,%edi
  801f44:	48 b8 19 1c 80 00 00 	movabs $0x801c19,%rax
  801f4b:	00 00 00 
  801f4e:	ff d0                	callq  *%rax
  801f50:	eb 28                	jmp    801f7a <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  801f52:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801f59:	00 
  801f5a:	eb 1e                	jmp    801f7a <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801f5c:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801f63:	40 
  801f64:	eb 14                	jmp    801f7a <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  801f66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f6a:	48 c1 e8 27          	shr    $0x27,%rax
  801f6e:	48 83 c0 01          	add    $0x1,%rax
  801f72:	48 c1 e0 27          	shl    $0x27,%rax
  801f76:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801f7a:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801f81:	00 
  801f82:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  801f89:	00 
  801f8a:	0f 87 13 ff ff ff    	ja     801ea3 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801f90:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f93:	ba 07 00 00 00       	mov    $0x7,%edx
  801f98:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f9d:	89 c7                	mov    %eax,%edi
  801f9f:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801fab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fae:	ba 07 00 00 00       	mov    $0x7,%edx
  801fb3:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fb8:	89 c7                	mov    %eax,%edi
  801fba:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  801fc1:	00 00 00 
  801fc4:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  801fc6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fc9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fcf:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  801fd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fde:	89 c7                	mov    %eax,%edi
  801fe0:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  801fe7:	00 00 00 
  801fea:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  801fec:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ff1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801ff6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ffb:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  802002:	00 00 00 
  802005:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802007:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80200c:	bf 00 00 00 00       	mov    $0x0,%edi
  802011:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80201d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802024:	00 00 00 
  802027:	48 8b 00             	mov    (%rax),%rax
  80202a:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802031:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802034:	48 89 d6             	mov    %rdx,%rsi
  802037:	89 c7                	mov    %eax,%edi
  802039:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  802040:	00 00 00 
  802043:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  802045:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802048:	be 02 00 00 00       	mov    $0x2,%esi
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	48 b8 0c 19 80 00 00 	movabs $0x80190c,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax

	return envid;
  80205b:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  80205e:	c9                   	leaveq 
  80205f:	c3                   	retq   

0000000000802060 <sfork>:

// Challenge!
int
sfork(void)
{
  802060:	55                   	push   %rbp
  802061:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802064:	48 ba 33 44 80 00 00 	movabs $0x804433,%rdx
  80206b:	00 00 00 
  80206e:	be b8 00 00 00       	mov    $0xb8,%esi
  802073:	48 bf 7d 43 80 00 00 	movabs $0x80437d,%rdi
  80207a:	00 00 00 
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  802089:	00 00 00 
  80208c:	ff d1                	callq  *%rcx

000000000080208e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80208e:	55                   	push   %rbp
  80208f:	48 89 e5             	mov    %rsp,%rbp
  802092:	48 83 ec 30          	sub    $0x30,%rsp
  802096:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80209a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80209e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8020a2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8020a7:	75 0e                	jne    8020b7 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8020a9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8020b0:	00 00 00 
  8020b3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8020b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020bb:	48 89 c7             	mov    %rax,%rdi
  8020be:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  8020c5:	00 00 00 
  8020c8:	ff d0                	callq  *%rax
  8020ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020d1:	79 27                	jns    8020fa <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8020d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020d8:	74 0a                	je     8020e4 <ipc_recv+0x56>
            *from_env_store = 0;
  8020da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020de:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8020e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8020e9:	74 0a                	je     8020f5 <ipc_recv+0x67>
            *perm_store = 0;
  8020eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ef:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8020f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f8:	eb 53                	jmp    80214d <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8020fa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020ff:	74 19                	je     80211a <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  802101:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802108:	00 00 00 
  80210b:	48 8b 00             	mov    (%rax),%rax
  80210e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802118:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80211a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80211f:	74 19                	je     80213a <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  802121:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802128:	00 00 00 
  80212b:	48 8b 00             	mov    (%rax),%rax
  80212e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802134:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802138:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80213a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802141:	00 00 00 
  802144:	48 8b 00             	mov    (%rax),%rax
  802147:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80214d:	c9                   	leaveq 
  80214e:	c3                   	retq   

000000000080214f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80214f:	55                   	push   %rbp
  802150:	48 89 e5             	mov    %rsp,%rbp
  802153:	48 83 ec 30          	sub    $0x30,%rsp
  802157:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80215a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80215d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802161:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  802164:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802169:	75 0e                	jne    802179 <ipc_send+0x2a>
        pg = (void *)UTOP;
  80216b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802172:	00 00 00 
  802175:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  802179:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80217c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80217f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802183:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802186:	89 c7                	mov    %eax,%edi
  802188:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
  802194:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  802197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219b:	79 36                	jns    8021d3 <ipc_send+0x84>
  80219d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8021a1:	74 30                	je     8021d3 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8021a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a6:	89 c1                	mov    %eax,%ecx
  8021a8:	48 ba 49 44 80 00 00 	movabs $0x804449,%rdx
  8021af:	00 00 00 
  8021b2:	be 49 00 00 00       	mov    $0x49,%esi
  8021b7:	48 bf 56 44 80 00 00 	movabs $0x804456,%rdi
  8021be:	00 00 00 
  8021c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c6:	49 b8 2e 3b 80 00 00 	movabs $0x803b2e,%r8
  8021cd:	00 00 00 
  8021d0:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8021d3:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  8021da:	00 00 00 
  8021dd:	ff d0                	callq  *%rax
    } while(r != 0);
  8021df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e3:	75 94                	jne    802179 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8021e5:	c9                   	leaveq 
  8021e6:	c3                   	retq   

00000000008021e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021e7:	55                   	push   %rbp
  8021e8:	48 89 e5             	mov    %rsp,%rbp
  8021eb:	48 83 ec 14          	sub    $0x14,%rsp
  8021ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8021f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f9:	eb 5e                	jmp    802259 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8021fb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802202:	00 00 00 
  802205:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802208:	48 63 d0             	movslq %eax,%rdx
  80220b:	48 89 d0             	mov    %rdx,%rax
  80220e:	48 c1 e0 03          	shl    $0x3,%rax
  802212:	48 01 d0             	add    %rdx,%rax
  802215:	48 c1 e0 05          	shl    $0x5,%rax
  802219:	48 01 c8             	add    %rcx,%rax
  80221c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802222:	8b 00                	mov    (%rax),%eax
  802224:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802227:	75 2c                	jne    802255 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802229:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802230:	00 00 00 
  802233:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802236:	48 63 d0             	movslq %eax,%rdx
  802239:	48 89 d0             	mov    %rdx,%rax
  80223c:	48 c1 e0 03          	shl    $0x3,%rax
  802240:	48 01 d0             	add    %rdx,%rax
  802243:	48 c1 e0 05          	shl    $0x5,%rax
  802247:	48 01 c8             	add    %rcx,%rax
  80224a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802250:	8b 40 08             	mov    0x8(%rax),%eax
  802253:	eb 12                	jmp    802267 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802255:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802259:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802260:	7e 99                	jle    8021fb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802262:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802267:	c9                   	leaveq 
  802268:	c3                   	retq   

0000000000802269 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802269:	55                   	push   %rbp
  80226a:	48 89 e5             	mov    %rsp,%rbp
  80226d:	48 83 ec 08          	sub    $0x8,%rsp
  802271:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802275:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802279:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802280:	ff ff ff 
  802283:	48 01 d0             	add    %rdx,%rax
  802286:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80228a:	c9                   	leaveq 
  80228b:	c3                   	retq   

000000000080228c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80228c:	55                   	push   %rbp
  80228d:	48 89 e5             	mov    %rsp,%rbp
  802290:	48 83 ec 08          	sub    $0x8,%rsp
  802294:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80229c:	48 89 c7             	mov    %rax,%rdi
  80229f:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
  8022ab:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8022b1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8022b5:	c9                   	leaveq 
  8022b6:	c3                   	retq   

00000000008022b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8022b7:	55                   	push   %rbp
  8022b8:	48 89 e5             	mov    %rsp,%rbp
  8022bb:	48 83 ec 18          	sub    $0x18,%rsp
  8022bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022ca:	eb 6b                	jmp    802337 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cf:	48 98                	cltq   
  8022d1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022d7:	48 c1 e0 0c          	shl    $0xc,%rax
  8022db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e3:	48 c1 e8 15          	shr    $0x15,%rax
  8022e7:	48 89 c2             	mov    %rax,%rdx
  8022ea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022f1:	01 00 00 
  8022f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f8:	83 e0 01             	and    $0x1,%eax
  8022fb:	48 85 c0             	test   %rax,%rax
  8022fe:	74 21                	je     802321 <fd_alloc+0x6a>
  802300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802304:	48 c1 e8 0c          	shr    $0xc,%rax
  802308:	48 89 c2             	mov    %rax,%rdx
  80230b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802312:	01 00 00 
  802315:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802319:	83 e0 01             	and    $0x1,%eax
  80231c:	48 85 c0             	test   %rax,%rax
  80231f:	75 12                	jne    802333 <fd_alloc+0x7c>
			*fd_store = fd;
  802321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802325:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802329:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
  802331:	eb 1a                	jmp    80234d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802333:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802337:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80233b:	7e 8f                	jle    8022cc <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80233d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802341:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802348:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80234d:	c9                   	leaveq 
  80234e:	c3                   	retq   

000000000080234f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80234f:	55                   	push   %rbp
  802350:	48 89 e5             	mov    %rsp,%rbp
  802353:	48 83 ec 20          	sub    $0x20,%rsp
  802357:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80235a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80235e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802362:	78 06                	js     80236a <fd_lookup+0x1b>
  802364:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802368:	7e 07                	jle    802371 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80236a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80236f:	eb 6c                	jmp    8023dd <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802371:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802374:	48 98                	cltq   
  802376:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80237c:	48 c1 e0 0c          	shl    $0xc,%rax
  802380:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802388:	48 c1 e8 15          	shr    $0x15,%rax
  80238c:	48 89 c2             	mov    %rax,%rdx
  80238f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802396:	01 00 00 
  802399:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239d:	83 e0 01             	and    $0x1,%eax
  8023a0:	48 85 c0             	test   %rax,%rax
  8023a3:	74 21                	je     8023c6 <fd_lookup+0x77>
  8023a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8023ad:	48 89 c2             	mov    %rax,%rdx
  8023b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b7:	01 00 00 
  8023ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023be:	83 e0 01             	and    $0x1,%eax
  8023c1:	48 85 c0             	test   %rax,%rax
  8023c4:	75 07                	jne    8023cd <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023cb:	eb 10                	jmp    8023dd <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023d5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023dd:	c9                   	leaveq 
  8023de:	c3                   	retq   

00000000008023df <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023df:	55                   	push   %rbp
  8023e0:	48 89 e5             	mov    %rsp,%rbp
  8023e3:	48 83 ec 30          	sub    $0x30,%rsp
  8023e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023eb:	89 f0                	mov    %esi,%eax
  8023ed:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f4:	48 89 c7             	mov    %rax,%rdi
  8023f7:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax
  802403:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802407:	48 89 d6             	mov    %rdx,%rsi
  80240a:	89 c7                	mov    %eax,%edi
  80240c:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  802413:	00 00 00 
  802416:	ff d0                	callq  *%rax
  802418:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80241b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241f:	78 0a                	js     80242b <fd_close+0x4c>
	    || fd != fd2)
  802421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802425:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802429:	74 12                	je     80243d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80242b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80242f:	74 05                	je     802436 <fd_close+0x57>
  802431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802434:	eb 05                	jmp    80243b <fd_close+0x5c>
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
  80243b:	eb 69                	jmp    8024a6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80243d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802441:	8b 00                	mov    (%rax),%eax
  802443:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802447:	48 89 d6             	mov    %rdx,%rsi
  80244a:	89 c7                	mov    %eax,%edi
  80244c:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802453:	00 00 00 
  802456:	ff d0                	callq  *%rax
  802458:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245f:	78 2a                	js     80248b <fd_close+0xac>
		if (dev->dev_close)
  802461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802465:	48 8b 40 20          	mov    0x20(%rax),%rax
  802469:	48 85 c0             	test   %rax,%rax
  80246c:	74 16                	je     802484 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80246e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802472:	48 8b 40 20          	mov    0x20(%rax),%rax
  802476:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80247a:	48 89 d7             	mov    %rdx,%rdi
  80247d:	ff d0                	callq  *%rax
  80247f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802482:	eb 07                	jmp    80248b <fd_close+0xac>
		else
			r = 0;
  802484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80248b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248f:	48 89 c6             	mov    %rax,%rsi
  802492:	bf 00 00 00 00       	mov    $0x0,%edi
  802497:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	callq  *%rax
	return r;
  8024a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024a6:	c9                   	leaveq 
  8024a7:	c3                   	retq   

00000000008024a8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8024a8:	55                   	push   %rbp
  8024a9:	48 89 e5             	mov    %rsp,%rbp
  8024ac:	48 83 ec 20          	sub    $0x20,%rsp
  8024b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8024b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024be:	eb 41                	jmp    802501 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024c0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024c7:	00 00 00 
  8024ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024cd:	48 63 d2             	movslq %edx,%rdx
  8024d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d4:	8b 00                	mov    (%rax),%eax
  8024d6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024d9:	75 22                	jne    8024fd <dev_lookup+0x55>
			*dev = devtab[i];
  8024db:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024e2:	00 00 00 
  8024e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024e8:	48 63 d2             	movslq %edx,%rdx
  8024eb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024f3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	eb 60                	jmp    80255d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802501:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802508:	00 00 00 
  80250b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80250e:	48 63 d2             	movslq %edx,%rdx
  802511:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802515:	48 85 c0             	test   %rax,%rax
  802518:	75 a6                	jne    8024c0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80251a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802521:	00 00 00 
  802524:	48 8b 00             	mov    (%rax),%rax
  802527:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80252d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802530:	89 c6                	mov    %eax,%esi
  802532:	48 bf 60 44 80 00 00 	movabs $0x804460,%rdi
  802539:	00 00 00 
  80253c:	b8 00 00 00 00       	mov    $0x0,%eax
  802541:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  802548:	00 00 00 
  80254b:	ff d1                	callq  *%rcx
	*dev = 0;
  80254d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802551:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802558:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80255d:	c9                   	leaveq 
  80255e:	c3                   	retq   

000000000080255f <close>:

int
close(int fdnum)
{
  80255f:	55                   	push   %rbp
  802560:	48 89 e5             	mov    %rsp,%rbp
  802563:	48 83 ec 20          	sub    $0x20,%rsp
  802567:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80256a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802571:	48 89 d6             	mov    %rdx,%rsi
  802574:	89 c7                	mov    %eax,%edi
  802576:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
  802582:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802585:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802589:	79 05                	jns    802590 <close+0x31>
		return r;
  80258b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258e:	eb 18                	jmp    8025a8 <close+0x49>
	else
		return fd_close(fd, 1);
  802590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802594:	be 01 00 00 00       	mov    $0x1,%esi
  802599:	48 89 c7             	mov    %rax,%rdi
  80259c:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  8025a3:	00 00 00 
  8025a6:	ff d0                	callq  *%rax
}
  8025a8:	c9                   	leaveq 
  8025a9:	c3                   	retq   

00000000008025aa <close_all>:

void
close_all(void)
{
  8025aa:	55                   	push   %rbp
  8025ab:	48 89 e5             	mov    %rsp,%rbp
  8025ae:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8025b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025b9:	eb 15                	jmp    8025d0 <close_all+0x26>
		close(i);
  8025bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025be:	89 c7                	mov    %eax,%edi
  8025c0:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  8025c7:	00 00 00 
  8025ca:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025d0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025d4:	7e e5                	jle    8025bb <close_all+0x11>
		close(i);
}
  8025d6:	c9                   	leaveq 
  8025d7:	c3                   	retq   

00000000008025d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025d8:	55                   	push   %rbp
  8025d9:	48 89 e5             	mov    %rsp,%rbp
  8025dc:	48 83 ec 40          	sub    $0x40,%rsp
  8025e0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025e3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025e6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025ed:	48 89 d6             	mov    %rdx,%rsi
  8025f0:	89 c7                	mov    %eax,%edi
  8025f2:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  8025f9:	00 00 00 
  8025fc:	ff d0                	callq  *%rax
  8025fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802601:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802605:	79 08                	jns    80260f <dup+0x37>
		return r;
  802607:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260a:	e9 70 01 00 00       	jmpq   80277f <dup+0x1a7>
	close(newfdnum);
  80260f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802612:	89 c7                	mov    %eax,%edi
  802614:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  80261b:	00 00 00 
  80261e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802620:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802623:	48 98                	cltq   
  802625:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80262b:	48 c1 e0 0c          	shl    $0xc,%rax
  80262f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802637:	48 89 c7             	mov    %rax,%rdi
  80263a:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax
  802646:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80264a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264e:	48 89 c7             	mov    %rax,%rdi
  802651:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  802658:	00 00 00 
  80265b:	ff d0                	callq  *%rax
  80265d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802665:	48 c1 e8 15          	shr    $0x15,%rax
  802669:	48 89 c2             	mov    %rax,%rdx
  80266c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802673:	01 00 00 
  802676:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80267a:	83 e0 01             	and    $0x1,%eax
  80267d:	48 85 c0             	test   %rax,%rax
  802680:	74 73                	je     8026f5 <dup+0x11d>
  802682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802686:	48 c1 e8 0c          	shr    $0xc,%rax
  80268a:	48 89 c2             	mov    %rax,%rdx
  80268d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802694:	01 00 00 
  802697:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269b:	83 e0 01             	and    $0x1,%eax
  80269e:	48 85 c0             	test   %rax,%rax
  8026a1:	74 52                	je     8026f5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8026ab:	48 89 c2             	mov    %rax,%rdx
  8026ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026b5:	01 00 00 
  8026b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026cb:	41 89 c8             	mov    %ecx,%r8d
  8026ce:	48 89 d1             	mov    %rdx,%rcx
  8026d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d6:	48 89 c6             	mov    %rax,%rsi
  8026d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026de:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	callq  *%rax
  8026ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f1:	79 02                	jns    8026f5 <dup+0x11d>
			goto err;
  8026f3:	eb 57                	jmp    80274c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8026fd:	48 89 c2             	mov    %rax,%rdx
  802700:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802707:	01 00 00 
  80270a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270e:	25 07 0e 00 00       	and    $0xe07,%eax
  802713:	89 c1                	mov    %eax,%ecx
  802715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802719:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80271d:	41 89 c8             	mov    %ecx,%r8d
  802720:	48 89 d1             	mov    %rdx,%rcx
  802723:	ba 00 00 00 00       	mov    $0x0,%edx
  802728:	48 89 c6             	mov    %rax,%rsi
  80272b:	bf 00 00 00 00       	mov    $0x0,%edi
  802730:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
  80273c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802743:	79 02                	jns    802747 <dup+0x16f>
		goto err;
  802745:	eb 05                	jmp    80274c <dup+0x174>

	return newfdnum;
  802747:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80274a:	eb 33                	jmp    80277f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80274c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802750:	48 89 c6             	mov    %rax,%rsi
  802753:	bf 00 00 00 00       	mov    $0x0,%edi
  802758:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  80275f:	00 00 00 
  802762:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802764:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802768:	48 89 c6             	mov    %rax,%rsi
  80276b:	bf 00 00 00 00       	mov    $0x0,%edi
  802770:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  802777:	00 00 00 
  80277a:	ff d0                	callq  *%rax
	return r;
  80277c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80277f:	c9                   	leaveq 
  802780:	c3                   	retq   

0000000000802781 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802781:	55                   	push   %rbp
  802782:	48 89 e5             	mov    %rsp,%rbp
  802785:	48 83 ec 40          	sub    $0x40,%rsp
  802789:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80278c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802790:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802794:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802798:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80279b:	48 89 d6             	mov    %rdx,%rsi
  80279e:	89 c7                	mov    %eax,%edi
  8027a0:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  8027a7:	00 00 00 
  8027aa:	ff d0                	callq  *%rax
  8027ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b3:	78 24                	js     8027d9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b9:	8b 00                	mov    (%rax),%eax
  8027bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027bf:	48 89 d6             	mov    %rdx,%rsi
  8027c2:	89 c7                	mov    %eax,%edi
  8027c4:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  8027cb:	00 00 00 
  8027ce:	ff d0                	callq  *%rax
  8027d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d7:	79 05                	jns    8027de <read+0x5d>
		return r;
  8027d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027dc:	eb 76                	jmp    802854 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e2:	8b 40 08             	mov    0x8(%rax),%eax
  8027e5:	83 e0 03             	and    $0x3,%eax
  8027e8:	83 f8 01             	cmp    $0x1,%eax
  8027eb:	75 3a                	jne    802827 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027ed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027f4:	00 00 00 
  8027f7:	48 8b 00             	mov    (%rax),%rax
  8027fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802800:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802803:	89 c6                	mov    %eax,%esi
  802805:	48 bf 7f 44 80 00 00 	movabs $0x80447f,%rdi
  80280c:	00 00 00 
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
  802814:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  80281b:	00 00 00 
  80281e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802820:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802825:	eb 2d                	jmp    802854 <read+0xd3>
	}
	if (!dev->dev_read)
  802827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80282f:	48 85 c0             	test   %rax,%rax
  802832:	75 07                	jne    80283b <read+0xba>
		return -E_NOT_SUPP;
  802834:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802839:	eb 19                	jmp    802854 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80283b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802843:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802847:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80284b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80284f:	48 89 cf             	mov    %rcx,%rdi
  802852:	ff d0                	callq  *%rax
}
  802854:	c9                   	leaveq 
  802855:	c3                   	retq   

0000000000802856 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802856:	55                   	push   %rbp
  802857:	48 89 e5             	mov    %rsp,%rbp
  80285a:	48 83 ec 30          	sub    $0x30,%rsp
  80285e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802861:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802865:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802869:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802870:	eb 49                	jmp    8028bb <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802875:	48 98                	cltq   
  802877:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80287b:	48 29 c2             	sub    %rax,%rdx
  80287e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802881:	48 63 c8             	movslq %eax,%rcx
  802884:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802888:	48 01 c1             	add    %rax,%rcx
  80288b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80288e:	48 89 ce             	mov    %rcx,%rsi
  802891:	89 c7                	mov    %eax,%edi
  802893:	48 b8 81 27 80 00 00 	movabs $0x802781,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	callq  *%rax
  80289f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028a6:	79 05                	jns    8028ad <readn+0x57>
			return m;
  8028a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028ab:	eb 1c                	jmp    8028c9 <readn+0x73>
		if (m == 0)
  8028ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028b1:	75 02                	jne    8028b5 <readn+0x5f>
			break;
  8028b3:	eb 11                	jmp    8028c6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028b8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028be:	48 98                	cltq   
  8028c0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028c4:	72 ac                	jb     802872 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8028c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028c9:	c9                   	leaveq 
  8028ca:	c3                   	retq   

00000000008028cb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028cb:	55                   	push   %rbp
  8028cc:	48 89 e5             	mov    %rsp,%rbp
  8028cf:	48 83 ec 40          	sub    $0x40,%rsp
  8028d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028e5:	48 89 d6             	mov    %rdx,%rsi
  8028e8:	89 c7                	mov    %eax,%edi
  8028ea:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	callq  *%rax
  8028f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fd:	78 24                	js     802923 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802903:	8b 00                	mov    (%rax),%eax
  802905:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802909:	48 89 d6             	mov    %rdx,%rsi
  80290c:	89 c7                	mov    %eax,%edi
  80290e:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
  80291a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802921:	79 05                	jns    802928 <write+0x5d>
		return r;
  802923:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802926:	eb 75                	jmp    80299d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292c:	8b 40 08             	mov    0x8(%rax),%eax
  80292f:	83 e0 03             	and    $0x3,%eax
  802932:	85 c0                	test   %eax,%eax
  802934:	75 3a                	jne    802970 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802936:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80293d:	00 00 00 
  802940:	48 8b 00             	mov    (%rax),%rax
  802943:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802949:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80294c:	89 c6                	mov    %eax,%esi
  80294e:	48 bf 9b 44 80 00 00 	movabs $0x80449b,%rdi
  802955:	00 00 00 
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
  80295d:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  802964:	00 00 00 
  802967:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802969:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80296e:	eb 2d                	jmp    80299d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802974:	48 8b 40 18          	mov    0x18(%rax),%rax
  802978:	48 85 c0             	test   %rax,%rax
  80297b:	75 07                	jne    802984 <write+0xb9>
		return -E_NOT_SUPP;
  80297d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802982:	eb 19                	jmp    80299d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802988:	48 8b 40 18          	mov    0x18(%rax),%rax
  80298c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802990:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802994:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802998:	48 89 cf             	mov    %rcx,%rdi
  80299b:	ff d0                	callq  *%rax
}
  80299d:	c9                   	leaveq 
  80299e:	c3                   	retq   

000000000080299f <seek>:

int
seek(int fdnum, off_t offset)
{
  80299f:	55                   	push   %rbp
  8029a0:	48 89 e5             	mov    %rsp,%rbp
  8029a3:	48 83 ec 18          	sub    $0x18,%rsp
  8029a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029b4:	48 89 d6             	mov    %rdx,%rsi
  8029b7:	89 c7                	mov    %eax,%edi
  8029b9:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cc:	79 05                	jns    8029d3 <seek+0x34>
		return r;
  8029ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d1:	eb 0f                	jmp    8029e2 <seek+0x43>
	fd->fd_offset = offset;
  8029d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e2:	c9                   	leaveq 
  8029e3:	c3                   	retq   

00000000008029e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029e4:	55                   	push   %rbp
  8029e5:	48 89 e5             	mov    %rsp,%rbp
  8029e8:	48 83 ec 30          	sub    $0x30,%rsp
  8029ec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ef:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f9:	48 89 d6             	mov    %rdx,%rsi
  8029fc:	89 c7                	mov    %eax,%edi
  8029fe:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  802a05:	00 00 00 
  802a08:	ff d0                	callq  *%rax
  802a0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a11:	78 24                	js     802a37 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	8b 00                	mov    (%rax),%eax
  802a19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1d:	48 89 d6             	mov    %rdx,%rsi
  802a20:	89 c7                	mov    %eax,%edi
  802a22:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a35:	79 05                	jns    802a3c <ftruncate+0x58>
		return r;
  802a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3a:	eb 72                	jmp    802aae <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a40:	8b 40 08             	mov    0x8(%rax),%eax
  802a43:	83 e0 03             	and    $0x3,%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	75 3a                	jne    802a84 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a4a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a51:	00 00 00 
  802a54:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a57:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a5d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a60:	89 c6                	mov    %eax,%esi
  802a62:	48 bf b8 44 80 00 00 	movabs $0x8044b8,%rdi
  802a69:	00 00 00 
  802a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a71:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  802a78:	00 00 00 
  802a7b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a82:	eb 2a                	jmp    802aae <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a88:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a8c:	48 85 c0             	test   %rax,%rax
  802a8f:	75 07                	jne    802a98 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a91:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a96:	eb 16                	jmp    802aae <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802aa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aa4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802aa7:	89 ce                	mov    %ecx,%esi
  802aa9:	48 89 d7             	mov    %rdx,%rdi
  802aac:	ff d0                	callq  *%rax
}
  802aae:	c9                   	leaveq 
  802aaf:	c3                   	retq   

0000000000802ab0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ab0:	55                   	push   %rbp
  802ab1:	48 89 e5             	mov    %rsp,%rbp
  802ab4:	48 83 ec 30          	sub    $0x30,%rsp
  802ab8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802abb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802abf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac6:	48 89 d6             	mov    %rdx,%rsi
  802ac9:	89 c7                	mov    %eax,%edi
  802acb:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
  802ad7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ade:	78 24                	js     802b04 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae4:	8b 00                	mov    (%rax),%eax
  802ae6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aea:	48 89 d6             	mov    %rdx,%rsi
  802aed:	89 c7                	mov    %eax,%edi
  802aef:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b02:	79 05                	jns    802b09 <fstat+0x59>
		return r;
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	eb 5e                	jmp    802b67 <fstat+0xb7>
	if (!dev->dev_stat)
  802b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b11:	48 85 c0             	test   %rax,%rax
  802b14:	75 07                	jne    802b1d <fstat+0x6d>
		return -E_NOT_SUPP;
  802b16:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b1b:	eb 4a                	jmp    802b67 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b21:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b28:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b2f:	00 00 00 
	stat->st_isdir = 0;
  802b32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b36:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b3d:	00 00 00 
	stat->st_dev = dev;
  802b40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b48:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b53:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b5b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b5f:	48 89 ce             	mov    %rcx,%rsi
  802b62:	48 89 d7             	mov    %rdx,%rdi
  802b65:	ff d0                	callq  *%rax
}
  802b67:	c9                   	leaveq 
  802b68:	c3                   	retq   

0000000000802b69 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b69:	55                   	push   %rbp
  802b6a:	48 89 e5             	mov    %rsp,%rbp
  802b6d:	48 83 ec 20          	sub    $0x20,%rsp
  802b71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7d:	be 00 00 00 00       	mov    $0x0,%esi
  802b82:	48 89 c7             	mov    %rax,%rdi
  802b85:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	callq  *%rax
  802b91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b98:	79 05                	jns    802b9f <stat+0x36>
		return fd;
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	eb 2f                	jmp    802bce <stat+0x65>
	r = fstat(fd, stat);
  802b9f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba6:	48 89 d6             	mov    %rdx,%rsi
  802ba9:	89 c7                	mov    %eax,%edi
  802bab:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
  802bb7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802bba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbd:	89 c7                	mov    %eax,%edi
  802bbf:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	callq  *%rax
	return r;
  802bcb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bce:	c9                   	leaveq 
  802bcf:	c3                   	retq   

0000000000802bd0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bd0:	55                   	push   %rbp
  802bd1:	48 89 e5             	mov    %rsp,%rbp
  802bd4:	48 83 ec 10          	sub    $0x10,%rsp
  802bd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bdf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802be6:	00 00 00 
  802be9:	8b 00                	mov    (%rax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	75 1d                	jne    802c0c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bef:	bf 01 00 00 00       	mov    $0x1,%edi
  802bf4:	48 b8 e7 21 80 00 00 	movabs $0x8021e7,%rax
  802bfb:	00 00 00 
  802bfe:	ff d0                	callq  *%rax
  802c00:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c07:	00 00 00 
  802c0a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c0c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c13:	00 00 00 
  802c16:	8b 00                	mov    (%rax),%eax
  802c18:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c1b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c20:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c27:	00 00 00 
  802c2a:	89 c7                	mov    %eax,%edi
  802c2c:	48 b8 4f 21 80 00 00 	movabs $0x80214f,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c41:	48 89 c6             	mov    %rax,%rsi
  802c44:	bf 00 00 00 00       	mov    $0x0,%edi
  802c49:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802c50:	00 00 00 
  802c53:	ff d0                	callq  *%rax
}
  802c55:	c9                   	leaveq 
  802c56:	c3                   	retq   

0000000000802c57 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c57:	55                   	push   %rbp
  802c58:	48 89 e5             	mov    %rsp,%rbp
  802c5b:	48 83 ec 20          	sub    $0x20,%rsp
  802c5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c63:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6a:	48 89 c7             	mov    %rax,%rdi
  802c6d:	48 b8 7c 0e 80 00 00 	movabs $0x800e7c,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c7e:	7e 0a                	jle    802c8a <open+0x33>
		return -E_BAD_PATH;
  802c80:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c85:	e9 a5 00 00 00       	jmpq   802d2f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802c8a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c8e:	48 89 c7             	mov    %rax,%rdi
  802c91:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	79 08                	jns    802cae <open+0x57>
		return r;
  802ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca9:	e9 81 00 00 00       	jmpq   802d2f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802cae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb2:	48 89 c6             	mov    %rax,%rsi
  802cb5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cbc:	00 00 00 
  802cbf:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ccb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cd2:	00 00 00 
  802cd5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802cd8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce2:	48 89 c6             	mov    %rax,%rsi
  802ce5:	bf 01 00 00 00       	mov    $0x1,%edi
  802cea:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
  802cf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfd:	79 1d                	jns    802d1c <open+0xc5>
		fd_close(fd, 0);
  802cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d03:	be 00 00 00 00       	mov    $0x0,%esi
  802d08:	48 89 c7             	mov    %rax,%rdi
  802d0b:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax
		return r;
  802d17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1a:	eb 13                	jmp    802d2f <open+0xd8>
	}

	return fd2num(fd);
  802d1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d20:	48 89 c7             	mov    %rax,%rdi
  802d23:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  802d2a:	00 00 00 
  802d2d:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802d2f:	c9                   	leaveq 
  802d30:	c3                   	retq   

0000000000802d31 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d31:	55                   	push   %rbp
  802d32:	48 89 e5             	mov    %rsp,%rbp
  802d35:	48 83 ec 10          	sub    $0x10,%rsp
  802d39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d41:	8b 50 0c             	mov    0xc(%rax),%edx
  802d44:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d4b:	00 00 00 
  802d4e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d50:	be 00 00 00 00       	mov    $0x0,%esi
  802d55:	bf 06 00 00 00       	mov    $0x6,%edi
  802d5a:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
}
  802d66:	c9                   	leaveq 
  802d67:	c3                   	retq   

0000000000802d68 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d68:	55                   	push   %rbp
  802d69:	48 89 e5             	mov    %rsp,%rbp
  802d6c:	48 83 ec 30          	sub    $0x30,%rsp
  802d70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d78:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d80:	8b 50 0c             	mov    0xc(%rax),%edx
  802d83:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d8a:	00 00 00 
  802d8d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d8f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d96:	00 00 00 
  802d99:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d9d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802da1:	be 00 00 00 00       	mov    $0x0,%esi
  802da6:	bf 03 00 00 00       	mov    $0x3,%edi
  802dab:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  802db2:	00 00 00 
  802db5:	ff d0                	callq  *%rax
  802db7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbe:	79 08                	jns    802dc8 <devfile_read+0x60>
		return r;
  802dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc3:	e9 a4 00 00 00       	jmpq   802e6c <devfile_read+0x104>
	assert(r <= n);
  802dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcb:	48 98                	cltq   
  802dcd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802dd1:	76 35                	jbe    802e08 <devfile_read+0xa0>
  802dd3:	48 b9 e5 44 80 00 00 	movabs $0x8044e5,%rcx
  802dda:	00 00 00 
  802ddd:	48 ba ec 44 80 00 00 	movabs $0x8044ec,%rdx
  802de4:	00 00 00 
  802de7:	be 84 00 00 00       	mov    $0x84,%esi
  802dec:	48 bf 01 45 80 00 00 	movabs $0x804501,%rdi
  802df3:	00 00 00 
  802df6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfb:	49 b8 2e 3b 80 00 00 	movabs $0x803b2e,%r8
  802e02:	00 00 00 
  802e05:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802e08:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802e0f:	7e 35                	jle    802e46 <devfile_read+0xde>
  802e11:	48 b9 0c 45 80 00 00 	movabs $0x80450c,%rcx
  802e18:	00 00 00 
  802e1b:	48 ba ec 44 80 00 00 	movabs $0x8044ec,%rdx
  802e22:	00 00 00 
  802e25:	be 85 00 00 00       	mov    $0x85,%esi
  802e2a:	48 bf 01 45 80 00 00 	movabs $0x804501,%rdi
  802e31:	00 00 00 
  802e34:	b8 00 00 00 00       	mov    $0x0,%eax
  802e39:	49 b8 2e 3b 80 00 00 	movabs $0x803b2e,%r8
  802e40:	00 00 00 
  802e43:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e49:	48 63 d0             	movslq %eax,%rdx
  802e4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e50:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e57:	00 00 00 
  802e5a:	48 89 c7             	mov    %rax,%rdi
  802e5d:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
	return r;
  802e69:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802e6c:	c9                   	leaveq 
  802e6d:	c3                   	retq   

0000000000802e6e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e6e:	55                   	push   %rbp
  802e6f:	48 89 e5             	mov    %rsp,%rbp
  802e72:	48 83 ec 30          	sub    $0x30,%rsp
  802e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e86:	8b 50 0c             	mov    0xc(%rax),%edx
  802e89:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e90:	00 00 00 
  802e93:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e95:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e9c:	00 00 00 
  802e9f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ea3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802ea7:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802eae:	00 
  802eaf:	76 35                	jbe    802ee6 <devfile_write+0x78>
  802eb1:	48 b9 18 45 80 00 00 	movabs $0x804518,%rcx
  802eb8:	00 00 00 
  802ebb:	48 ba ec 44 80 00 00 	movabs $0x8044ec,%rdx
  802ec2:	00 00 00 
  802ec5:	be 9e 00 00 00       	mov    $0x9e,%esi
  802eca:	48 bf 01 45 80 00 00 	movabs $0x804501,%rdi
  802ed1:	00 00 00 
  802ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed9:	49 b8 2e 3b 80 00 00 	movabs $0x803b2e,%r8
  802ee0:	00 00 00 
  802ee3:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802ee6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eee:	48 89 c6             	mov    %rax,%rsi
  802ef1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ef8:	00 00 00 
  802efb:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802f07:	be 00 00 00 00       	mov    $0x0,%esi
  802f0c:	bf 04 00 00 00       	mov    $0x4,%edi
  802f11:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
  802f1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f24:	79 05                	jns    802f2b <devfile_write+0xbd>
		return r;
  802f26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f29:	eb 43                	jmp    802f6e <devfile_write+0x100>
	assert(r <= n);
  802f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2e:	48 98                	cltq   
  802f30:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f34:	76 35                	jbe    802f6b <devfile_write+0xfd>
  802f36:	48 b9 e5 44 80 00 00 	movabs $0x8044e5,%rcx
  802f3d:	00 00 00 
  802f40:	48 ba ec 44 80 00 00 	movabs $0x8044ec,%rdx
  802f47:	00 00 00 
  802f4a:	be a2 00 00 00       	mov    $0xa2,%esi
  802f4f:	48 bf 01 45 80 00 00 	movabs $0x804501,%rdi
  802f56:	00 00 00 
  802f59:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5e:	49 b8 2e 3b 80 00 00 	movabs $0x803b2e,%r8
  802f65:	00 00 00 
  802f68:	41 ff d0             	callq  *%r8
	return r;
  802f6b:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802f6e:	c9                   	leaveq 
  802f6f:	c3                   	retq   

0000000000802f70 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f70:	55                   	push   %rbp
  802f71:	48 89 e5             	mov    %rsp,%rbp
  802f74:	48 83 ec 20          	sub    $0x20,%rsp
  802f78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f84:	8b 50 0c             	mov    0xc(%rax),%edx
  802f87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8e:	00 00 00 
  802f91:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f93:	be 00 00 00 00       	mov    $0x0,%esi
  802f98:	bf 05 00 00 00       	mov    $0x5,%edi
  802f9d:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
  802fa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb0:	79 05                	jns    802fb7 <devfile_stat+0x47>
		return r;
  802fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb5:	eb 56                	jmp    80300d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802fb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fbb:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fc2:	00 00 00 
  802fc5:	48 89 c7             	mov    %rax,%rdi
  802fc8:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fd4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fdb:	00 00 00 
  802fde:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fe4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fee:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff5:	00 00 00 
  802ff8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ffe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803002:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80300d:	c9                   	leaveq 
  80300e:	c3                   	retq   

000000000080300f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80300f:	55                   	push   %rbp
  803010:	48 89 e5             	mov    %rsp,%rbp
  803013:	48 83 ec 10          	sub    $0x10,%rsp
  803017:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80301b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80301e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803022:	8b 50 0c             	mov    0xc(%rax),%edx
  803025:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80302c:	00 00 00 
  80302f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803031:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803038:	00 00 00 
  80303b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803041:	be 00 00 00 00       	mov    $0x0,%esi
  803046:	bf 02 00 00 00       	mov    $0x2,%edi
  80304b:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  803052:	00 00 00 
  803055:	ff d0                	callq  *%rax
}
  803057:	c9                   	leaveq 
  803058:	c3                   	retq   

0000000000803059 <remove>:

// Delete a file
int
remove(const char *path)
{
  803059:	55                   	push   %rbp
  80305a:	48 89 e5             	mov    %rsp,%rbp
  80305d:	48 83 ec 10          	sub    $0x10,%rsp
  803061:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803069:	48 89 c7             	mov    %rax,%rdi
  80306c:	48 b8 7c 0e 80 00 00 	movabs $0x800e7c,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
  803078:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80307d:	7e 07                	jle    803086 <remove+0x2d>
		return -E_BAD_PATH;
  80307f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803084:	eb 33                	jmp    8030b9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80308a:	48 89 c6             	mov    %rax,%rsi
  80308d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803094:	00 00 00 
  803097:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030a3:	be 00 00 00 00       	mov    $0x0,%esi
  8030a8:	bf 07 00 00 00       	mov    $0x7,%edi
  8030ad:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  8030b4:	00 00 00 
  8030b7:	ff d0                	callq  *%rax
}
  8030b9:	c9                   	leaveq 
  8030ba:	c3                   	retq   

00000000008030bb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030bb:	55                   	push   %rbp
  8030bc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030bf:	be 00 00 00 00       	mov    $0x0,%esi
  8030c4:	bf 08 00 00 00       	mov    $0x8,%edi
  8030c9:	48 b8 d0 2b 80 00 00 	movabs $0x802bd0,%rax
  8030d0:	00 00 00 
  8030d3:	ff d0                	callq  *%rax
}
  8030d5:	5d                   	pop    %rbp
  8030d6:	c3                   	retq   

00000000008030d7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030d7:	55                   	push   %rbp
  8030d8:	48 89 e5             	mov    %rsp,%rbp
  8030db:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030e2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030e9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8030f0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030f7:	be 00 00 00 00       	mov    $0x0,%esi
  8030fc:	48 89 c7             	mov    %rax,%rdi
  8030ff:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
  80310b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80310e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803112:	79 28                	jns    80313c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803117:	89 c6                	mov    %eax,%esi
  803119:	48 bf 45 45 80 00 00 	movabs $0x804545,%rdi
  803120:	00 00 00 
  803123:	b8 00 00 00 00       	mov    $0x0,%eax
  803128:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  80312f:	00 00 00 
  803132:	ff d2                	callq  *%rdx
		return fd_src;
  803134:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803137:	e9 74 01 00 00       	jmpq   8032b0 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80313c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803143:	be 01 01 00 00       	mov    $0x101,%esi
  803148:	48 89 c7             	mov    %rax,%rdi
  80314b:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
  803157:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80315a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80315e:	79 39                	jns    803199 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803160:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803163:	89 c6                	mov    %eax,%esi
  803165:	48 bf 5b 45 80 00 00 	movabs $0x80455b,%rdi
  80316c:	00 00 00 
  80316f:	b8 00 00 00 00       	mov    $0x0,%eax
  803174:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  80317b:	00 00 00 
  80317e:	ff d2                	callq  *%rdx
		close(fd_src);
  803180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803183:	89 c7                	mov    %eax,%edi
  803185:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
		return fd_dest;
  803191:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803194:	e9 17 01 00 00       	jmpq   8032b0 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803199:	eb 74                	jmp    80320f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80319b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80319e:	48 63 d0             	movslq %eax,%rdx
  8031a1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ab:	48 89 ce             	mov    %rcx,%rsi
  8031ae:	89 c7                	mov    %eax,%edi
  8031b0:	48 b8 cb 28 80 00 00 	movabs $0x8028cb,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
  8031bc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8031bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031c3:	79 4a                	jns    80320f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8031c5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031c8:	89 c6                	mov    %eax,%esi
  8031ca:	48 bf 75 45 80 00 00 	movabs $0x804575,%rdi
  8031d1:	00 00 00 
  8031d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d9:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  8031e0:	00 00 00 
  8031e3:	ff d2                	callq  *%rdx
			close(fd_src);
  8031e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e8:	89 c7                	mov    %eax,%edi
  8031ea:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  8031f1:	00 00 00 
  8031f4:	ff d0                	callq  *%rax
			close(fd_dest);
  8031f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031f9:	89 c7                	mov    %eax,%edi
  8031fb:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  803202:	00 00 00 
  803205:	ff d0                	callq  *%rax
			return write_size;
  803207:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80320a:	e9 a1 00 00 00       	jmpq   8032b0 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80320f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803219:	ba 00 02 00 00       	mov    $0x200,%edx
  80321e:	48 89 ce             	mov    %rcx,%rsi
  803221:	89 c7                	mov    %eax,%edi
  803223:	48 b8 81 27 80 00 00 	movabs $0x802781,%rax
  80322a:	00 00 00 
  80322d:	ff d0                	callq  *%rax
  80322f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803232:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803236:	0f 8f 5f ff ff ff    	jg     80319b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80323c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803240:	79 47                	jns    803289 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803242:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803245:	89 c6                	mov    %eax,%esi
  803247:	48 bf 88 45 80 00 00 	movabs $0x804588,%rdi
  80324e:	00 00 00 
  803251:	b8 00 00 00 00       	mov    $0x0,%eax
  803256:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  80325d:	00 00 00 
  803260:	ff d2                	callq  *%rdx
		close(fd_src);
  803262:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803265:	89 c7                	mov    %eax,%edi
  803267:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
		close(fd_dest);
  803273:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803276:	89 c7                	mov    %eax,%edi
  803278:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
		return read_size;
  803284:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803287:	eb 27                	jmp    8032b0 <copy+0x1d9>
	}
	close(fd_src);
  803289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328c:	89 c7                	mov    %eax,%edi
  80328e:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  803295:	00 00 00 
  803298:	ff d0                	callq  *%rax
	close(fd_dest);
  80329a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80329d:	89 c7                	mov    %eax,%edi
  80329f:	48 b8 5f 25 80 00 00 	movabs $0x80255f,%rax
  8032a6:	00 00 00 
  8032a9:	ff d0                	callq  *%rax
	return 0;
  8032ab:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8032b0:	c9                   	leaveq 
  8032b1:	c3                   	retq   

00000000008032b2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032b2:	55                   	push   %rbp
  8032b3:	48 89 e5             	mov    %rsp,%rbp
  8032b6:	53                   	push   %rbx
  8032b7:	48 83 ec 38          	sub    $0x38,%rsp
  8032bb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8032bf:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8032c3:	48 89 c7             	mov    %rax,%rdi
  8032c6:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  8032cd:	00 00 00 
  8032d0:	ff d0                	callq  *%rax
  8032d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032d9:	0f 88 bf 01 00 00    	js     80349e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8032e8:	48 89 c6             	mov    %rax,%rsi
  8032eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f0:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
  8032fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803303:	0f 88 95 01 00 00    	js     80349e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803309:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80330d:	48 89 c7             	mov    %rax,%rdi
  803310:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  803317:	00 00 00 
  80331a:	ff d0                	callq  *%rax
  80331c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80331f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803323:	0f 88 5d 01 00 00    	js     803486 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803329:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332d:	ba 07 04 00 00       	mov    $0x407,%edx
  803332:	48 89 c6             	mov    %rax,%rsi
  803335:	bf 00 00 00 00       	mov    $0x0,%edi
  80333a:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  803341:	00 00 00 
  803344:	ff d0                	callq  *%rax
  803346:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803349:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80334d:	0f 88 33 01 00 00    	js     803486 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803353:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803357:	48 89 c7             	mov    %rax,%rdi
  80335a:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
  803366:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80336a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80336e:	ba 07 04 00 00       	mov    $0x407,%edx
  803373:	48 89 c6             	mov    %rax,%rsi
  803376:	bf 00 00 00 00       	mov    $0x0,%edi
  80337b:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
  803387:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80338a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80338e:	79 05                	jns    803395 <pipe+0xe3>
		goto err2;
  803390:	e9 d9 00 00 00       	jmpq   80346e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803395:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803399:	48 89 c7             	mov    %rax,%rdi
  80339c:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  8033a3:	00 00 00 
  8033a6:	ff d0                	callq  *%rax
  8033a8:	48 89 c2             	mov    %rax,%rdx
  8033ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033af:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033b5:	48 89 d1             	mov    %rdx,%rcx
  8033b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8033bd:	48 89 c6             	mov    %rax,%rsi
  8033c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c5:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  8033cc:	00 00 00 
  8033cf:	ff d0                	callq  *%rax
  8033d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d8:	79 1b                	jns    8033f5 <pipe+0x143>
		goto err3;
  8033da:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8033db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033df:	48 89 c6             	mov    %rax,%rsi
  8033e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e7:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
  8033f3:	eb 79                	jmp    80346e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f9:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803400:	00 00 00 
  803403:	8b 12                	mov    (%rdx),%edx
  803405:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803412:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803416:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80341d:	00 00 00 
  803420:	8b 12                	mov    (%rdx),%edx
  803422:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803424:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803428:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80342f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803433:	48 89 c7             	mov    %rax,%rdi
  803436:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
  803442:	89 c2                	mov    %eax,%edx
  803444:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803448:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80344a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80344e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803452:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803456:	48 89 c7             	mov    %rax,%rdi
  803459:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  803460:	00 00 00 
  803463:	ff d0                	callq  *%rax
  803465:	89 03                	mov    %eax,(%rbx)
	return 0;
  803467:	b8 00 00 00 00       	mov    $0x0,%eax
  80346c:	eb 33                	jmp    8034a1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80346e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803472:	48 89 c6             	mov    %rax,%rsi
  803475:	bf 00 00 00 00       	mov    $0x0,%edi
  80347a:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80348a:	48 89 c6             	mov    %rax,%rsi
  80348d:	bf 00 00 00 00       	mov    $0x0,%edi
  803492:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax
err:
	return r;
  80349e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034a1:	48 83 c4 38          	add    $0x38,%rsp
  8034a5:	5b                   	pop    %rbx
  8034a6:	5d                   	pop    %rbp
  8034a7:	c3                   	retq   

00000000008034a8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034a8:	55                   	push   %rbp
  8034a9:	48 89 e5             	mov    %rsp,%rbp
  8034ac:	53                   	push   %rbx
  8034ad:	48 83 ec 28          	sub    $0x28,%rsp
  8034b1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034b5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034b9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034c0:	00 00 00 
  8034c3:	48 8b 00             	mov    (%rax),%rax
  8034c6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8034cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034d3:	48 89 c7             	mov    %rax,%rdi
  8034d6:	48 b8 8c 3d 80 00 00 	movabs $0x803d8c,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
  8034e2:	89 c3                	mov    %eax,%ebx
  8034e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034e8:	48 89 c7             	mov    %rax,%rdi
  8034eb:	48 b8 8c 3d 80 00 00 	movabs $0x803d8c,%rax
  8034f2:	00 00 00 
  8034f5:	ff d0                	callq  *%rax
  8034f7:	39 c3                	cmp    %eax,%ebx
  8034f9:	0f 94 c0             	sete   %al
  8034fc:	0f b6 c0             	movzbl %al,%eax
  8034ff:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803502:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803509:	00 00 00 
  80350c:	48 8b 00             	mov    (%rax),%rax
  80350f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803515:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803518:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80351b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80351e:	75 05                	jne    803525 <_pipeisclosed+0x7d>
			return ret;
  803520:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803523:	eb 4f                	jmp    803574 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803525:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803528:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80352b:	74 42                	je     80356f <_pipeisclosed+0xc7>
  80352d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803531:	75 3c                	jne    80356f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803533:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80353a:	00 00 00 
  80353d:	48 8b 00             	mov    (%rax),%rax
  803540:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803546:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80354c:	89 c6                	mov    %eax,%esi
  80354e:	48 bf a3 45 80 00 00 	movabs $0x8045a3,%rdi
  803555:	00 00 00 
  803558:	b8 00 00 00 00       	mov    $0x0,%eax
  80355d:	49 b8 20 03 80 00 00 	movabs $0x800320,%r8
  803564:	00 00 00 
  803567:	41 ff d0             	callq  *%r8
	}
  80356a:	e9 4a ff ff ff       	jmpq   8034b9 <_pipeisclosed+0x11>
  80356f:	e9 45 ff ff ff       	jmpq   8034b9 <_pipeisclosed+0x11>
}
  803574:	48 83 c4 28          	add    $0x28,%rsp
  803578:	5b                   	pop    %rbx
  803579:	5d                   	pop    %rbp
  80357a:	c3                   	retq   

000000000080357b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80357b:	55                   	push   %rbp
  80357c:	48 89 e5             	mov    %rsp,%rbp
  80357f:	48 83 ec 30          	sub    $0x30,%rsp
  803583:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803586:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80358a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80358d:	48 89 d6             	mov    %rdx,%rsi
  803590:	89 c7                	mov    %eax,%edi
  803592:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
  80359e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a5:	79 05                	jns    8035ac <pipeisclosed+0x31>
		return r;
  8035a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035aa:	eb 31                	jmp    8035dd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8035ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b0:	48 89 c7             	mov    %rax,%rdi
  8035b3:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
  8035bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8035c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035cb:	48 89 d6             	mov    %rdx,%rsi
  8035ce:	48 89 c7             	mov    %rax,%rdi
  8035d1:	48 b8 a8 34 80 00 00 	movabs $0x8034a8,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
}
  8035dd:	c9                   	leaveq 
  8035de:	c3                   	retq   

00000000008035df <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035df:	55                   	push   %rbp
  8035e0:	48 89 e5             	mov    %rsp,%rbp
  8035e3:	48 83 ec 40          	sub    $0x40,%rsp
  8035e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f7:	48 89 c7             	mov    %rax,%rdi
  8035fa:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  803601:	00 00 00 
  803604:	ff d0                	callq  *%rax
  803606:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80360a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803612:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803619:	00 
  80361a:	e9 92 00 00 00       	jmpq   8036b1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80361f:	eb 41                	jmp    803662 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803621:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803626:	74 09                	je     803631 <devpipe_read+0x52>
				return i;
  803628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362c:	e9 92 00 00 00       	jmpq   8036c3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803631:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803639:	48 89 d6             	mov    %rdx,%rsi
  80363c:	48 89 c7             	mov    %rax,%rdi
  80363f:	48 b8 a8 34 80 00 00 	movabs $0x8034a8,%rax
  803646:	00 00 00 
  803649:	ff d0                	callq  *%rax
  80364b:	85 c0                	test   %eax,%eax
  80364d:	74 07                	je     803656 <devpipe_read+0x77>
				return 0;
  80364f:	b8 00 00 00 00       	mov    $0x0,%eax
  803654:	eb 6d                	jmp    8036c3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803656:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  80365d:	00 00 00 
  803660:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803666:	8b 10                	mov    (%rax),%edx
  803668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366c:	8b 40 04             	mov    0x4(%rax),%eax
  80366f:	39 c2                	cmp    %eax,%edx
  803671:	74 ae                	je     803621 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80367b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80367f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803683:	8b 00                	mov    (%rax),%eax
  803685:	99                   	cltd   
  803686:	c1 ea 1b             	shr    $0x1b,%edx
  803689:	01 d0                	add    %edx,%eax
  80368b:	83 e0 1f             	and    $0x1f,%eax
  80368e:	29 d0                	sub    %edx,%eax
  803690:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803694:	48 98                	cltq   
  803696:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80369b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80369d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a1:	8b 00                	mov    (%rax),%eax
  8036a3:	8d 50 01             	lea    0x1(%rax),%edx
  8036a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036aa:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036b9:	0f 82 60 ff ff ff    	jb     80361f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8036bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036c3:	c9                   	leaveq 
  8036c4:	c3                   	retq   

00000000008036c5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036c5:	55                   	push   %rbp
  8036c6:	48 89 e5             	mov    %rsp,%rbp
  8036c9:	48 83 ec 40          	sub    $0x40,%rsp
  8036cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036dd:	48 89 c7             	mov    %rax,%rdi
  8036e0:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  8036e7:	00 00 00 
  8036ea:	ff d0                	callq  *%rax
  8036ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036f8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036ff:	00 
  803700:	e9 8e 00 00 00       	jmpq   803793 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803705:	eb 31                	jmp    803738 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803707:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80370b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80370f:	48 89 d6             	mov    %rdx,%rsi
  803712:	48 89 c7             	mov    %rax,%rdi
  803715:	48 b8 a8 34 80 00 00 	movabs $0x8034a8,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 07                	je     80372c <devpipe_write+0x67>
				return 0;
  803725:	b8 00 00 00 00       	mov    $0x0,%eax
  80372a:	eb 79                	jmp    8037a5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80372c:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803738:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373c:	8b 40 04             	mov    0x4(%rax),%eax
  80373f:	48 63 d0             	movslq %eax,%rdx
  803742:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803746:	8b 00                	mov    (%rax),%eax
  803748:	48 98                	cltq   
  80374a:	48 83 c0 20          	add    $0x20,%rax
  80374e:	48 39 c2             	cmp    %rax,%rdx
  803751:	73 b4                	jae    803707 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803753:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803757:	8b 40 04             	mov    0x4(%rax),%eax
  80375a:	99                   	cltd   
  80375b:	c1 ea 1b             	shr    $0x1b,%edx
  80375e:	01 d0                	add    %edx,%eax
  803760:	83 e0 1f             	and    $0x1f,%eax
  803763:	29 d0                	sub    %edx,%eax
  803765:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803769:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80376d:	48 01 ca             	add    %rcx,%rdx
  803770:	0f b6 0a             	movzbl (%rdx),%ecx
  803773:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803777:	48 98                	cltq   
  803779:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80377d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803781:	8b 40 04             	mov    0x4(%rax),%eax
  803784:	8d 50 01             	lea    0x1(%rax),%edx
  803787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80378e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803797:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80379b:	0f 82 64 ff ff ff    	jb     803705 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037a5:	c9                   	leaveq 
  8037a6:	c3                   	retq   

00000000008037a7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037a7:	55                   	push   %rbp
  8037a8:	48 89 e5             	mov    %rsp,%rbp
  8037ab:	48 83 ec 20          	sub    $0x20,%rsp
  8037af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bb:	48 89 c7             	mov    %rax,%rdi
  8037be:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  8037c5:	00 00 00 
  8037c8:	ff d0                	callq  *%rax
  8037ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8037ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d2:	48 be b6 45 80 00 00 	movabs $0x8045b6,%rsi
  8037d9:	00 00 00 
  8037dc:	48 89 c7             	mov    %rax,%rdi
  8037df:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  8037e6:	00 00 00 
  8037e9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ef:	8b 50 04             	mov    0x4(%rax),%edx
  8037f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f6:	8b 00                	mov    (%rax),%eax
  8037f8:	29 c2                	sub    %eax,%edx
  8037fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037fe:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803804:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803808:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80380f:	00 00 00 
	stat->st_dev = &devpipe;
  803812:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803816:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80381d:	00 00 00 
  803820:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803827:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80382c:	c9                   	leaveq 
  80382d:	c3                   	retq   

000000000080382e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80382e:	55                   	push   %rbp
  80382f:	48 89 e5             	mov    %rsp,%rbp
  803832:	48 83 ec 10          	sub    $0x10,%rsp
  803836:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80383a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80383e:	48 89 c6             	mov    %rax,%rsi
  803841:	bf 00 00 00 00       	mov    $0x0,%edi
  803846:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803852:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803856:	48 89 c7             	mov    %rax,%rdi
  803859:	48 b8 8c 22 80 00 00 	movabs $0x80228c,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
  803865:	48 89 c6             	mov    %rax,%rsi
  803868:	bf 00 00 00 00       	mov    $0x0,%edi
  80386d:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  803874:	00 00 00 
  803877:	ff d0                	callq  *%rax
}
  803879:	c9                   	leaveq 
  80387a:	c3                   	retq   

000000000080387b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80387b:	55                   	push   %rbp
  80387c:	48 89 e5             	mov    %rsp,%rbp
  80387f:	48 83 ec 20          	sub    $0x20,%rsp
  803883:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803886:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803889:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80388c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803890:	be 01 00 00 00       	mov    $0x1,%esi
  803895:	48 89 c7             	mov    %rax,%rdi
  803898:	48 b8 cf 16 80 00 00 	movabs $0x8016cf,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
}
  8038a4:	c9                   	leaveq 
  8038a5:	c3                   	retq   

00000000008038a6 <getchar>:

int
getchar(void)
{
  8038a6:	55                   	push   %rbp
  8038a7:	48 89 e5             	mov    %rsp,%rbp
  8038aa:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038ae:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038b2:	ba 01 00 00 00       	mov    $0x1,%edx
  8038b7:	48 89 c6             	mov    %rax,%rsi
  8038ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8038bf:	48 b8 81 27 80 00 00 	movabs $0x802781,%rax
  8038c6:	00 00 00 
  8038c9:	ff d0                	callq  *%rax
  8038cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d2:	79 05                	jns    8038d9 <getchar+0x33>
		return r;
  8038d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d7:	eb 14                	jmp    8038ed <getchar+0x47>
	if (r < 1)
  8038d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038dd:	7f 07                	jg     8038e6 <getchar+0x40>
		return -E_EOF;
  8038df:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038e4:	eb 07                	jmp    8038ed <getchar+0x47>
	return c;
  8038e6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038ea:	0f b6 c0             	movzbl %al,%eax
}
  8038ed:	c9                   	leaveq 
  8038ee:	c3                   	retq   

00000000008038ef <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038ef:	55                   	push   %rbp
  8038f0:	48 89 e5             	mov    %rsp,%rbp
  8038f3:	48 83 ec 20          	sub    $0x20,%rsp
  8038f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803901:	48 89 d6             	mov    %rdx,%rsi
  803904:	89 c7                	mov    %eax,%edi
  803906:	48 b8 4f 23 80 00 00 	movabs $0x80234f,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
  803912:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803915:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803919:	79 05                	jns    803920 <iscons+0x31>
		return r;
  80391b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391e:	eb 1a                	jmp    80393a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803924:	8b 10                	mov    (%rax),%edx
  803926:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80392d:	00 00 00 
  803930:	8b 00                	mov    (%rax),%eax
  803932:	39 c2                	cmp    %eax,%edx
  803934:	0f 94 c0             	sete   %al
  803937:	0f b6 c0             	movzbl %al,%eax
}
  80393a:	c9                   	leaveq 
  80393b:	c3                   	retq   

000000000080393c <opencons>:

int
opencons(void)
{
  80393c:	55                   	push   %rbp
  80393d:	48 89 e5             	mov    %rsp,%rbp
  803940:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803944:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803948:	48 89 c7             	mov    %rax,%rdi
  80394b:	48 b8 b7 22 80 00 00 	movabs $0x8022b7,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
  803957:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80395a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395e:	79 05                	jns    803965 <opencons+0x29>
		return r;
  803960:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803963:	eb 5b                	jmp    8039c0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803969:	ba 07 04 00 00       	mov    $0x407,%edx
  80396e:	48 89 c6             	mov    %rax,%rsi
  803971:	bf 00 00 00 00       	mov    $0x0,%edi
  803976:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  80397d:	00 00 00 
  803980:	ff d0                	callq  *%rax
  803982:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803985:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803989:	79 05                	jns    803990 <opencons+0x54>
		return r;
  80398b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398e:	eb 30                	jmp    8039c0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803990:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803994:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80399b:	00 00 00 
  80399e:	8b 12                	mov    (%rdx),%edx
  8039a0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b1:	48 89 c7             	mov    %rax,%rdi
  8039b4:	48 b8 69 22 80 00 00 	movabs $0x802269,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
}
  8039c0:	c9                   	leaveq 
  8039c1:	c3                   	retq   

00000000008039c2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039c2:	55                   	push   %rbp
  8039c3:	48 89 e5             	mov    %rsp,%rbp
  8039c6:	48 83 ec 30          	sub    $0x30,%rsp
  8039ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039d6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039db:	75 07                	jne    8039e4 <devcons_read+0x22>
		return 0;
  8039dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e2:	eb 4b                	jmp    803a2f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039e4:	eb 0c                	jmp    8039f2 <devcons_read+0x30>
		sys_yield();
  8039e6:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  8039ed:	00 00 00 
  8039f0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039f2:	48 b8 19 17 80 00 00 	movabs $0x801719,%rax
  8039f9:	00 00 00 
  8039fc:	ff d0                	callq  *%rax
  8039fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a05:	74 df                	je     8039e6 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a0b:	79 05                	jns    803a12 <devcons_read+0x50>
		return c;
  803a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a10:	eb 1d                	jmp    803a2f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a12:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a16:	75 07                	jne    803a1f <devcons_read+0x5d>
		return 0;
  803a18:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1d:	eb 10                	jmp    803a2f <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a22:	89 c2                	mov    %eax,%edx
  803a24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a28:	88 10                	mov    %dl,(%rax)
	return 1;
  803a2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a2f:	c9                   	leaveq 
  803a30:	c3                   	retq   

0000000000803a31 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a31:	55                   	push   %rbp
  803a32:	48 89 e5             	mov    %rsp,%rbp
  803a35:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a3c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a43:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a4a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a58:	eb 76                	jmp    803ad0 <devcons_write+0x9f>
		m = n - tot;
  803a5a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a61:	89 c2                	mov    %eax,%edx
  803a63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a66:	29 c2                	sub    %eax,%edx
  803a68:	89 d0                	mov    %edx,%eax
  803a6a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a70:	83 f8 7f             	cmp    $0x7f,%eax
  803a73:	76 07                	jbe    803a7c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a75:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a7f:	48 63 d0             	movslq %eax,%rdx
  803a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a85:	48 63 c8             	movslq %eax,%rcx
  803a88:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a8f:	48 01 c1             	add    %rax,%rcx
  803a92:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a99:	48 89 ce             	mov    %rcx,%rsi
  803a9c:	48 89 c7             	mov    %rax,%rdi
  803a9f:	48 b8 0c 12 80 00 00 	movabs $0x80120c,%rax
  803aa6:	00 00 00 
  803aa9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803aab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aae:	48 63 d0             	movslq %eax,%rdx
  803ab1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ab8:	48 89 d6             	mov    %rdx,%rsi
  803abb:	48 89 c7             	mov    %rax,%rdi
  803abe:	48 b8 cf 16 80 00 00 	movabs $0x8016cf,%rax
  803ac5:	00 00 00 
  803ac8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803aca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803acd:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad3:	48 98                	cltq   
  803ad5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803adc:	0f 82 78 ff ff ff    	jb     803a5a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ae5:	c9                   	leaveq 
  803ae6:	c3                   	retq   

0000000000803ae7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ae7:	55                   	push   %rbp
  803ae8:	48 89 e5             	mov    %rsp,%rbp
  803aeb:	48 83 ec 08          	sub    $0x8,%rsp
  803aef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803af8:	c9                   	leaveq 
  803af9:	c3                   	retq   

0000000000803afa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803afa:	55                   	push   %rbp
  803afb:	48 89 e5             	mov    %rsp,%rbp
  803afe:	48 83 ec 10          	sub    $0x10,%rsp
  803b02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0e:	48 be c2 45 80 00 00 	movabs $0x8045c2,%rsi
  803b15:	00 00 00 
  803b18:	48 89 c7             	mov    %rax,%rdi
  803b1b:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  803b22:	00 00 00 
  803b25:	ff d0                	callq  *%rax
	return 0;
  803b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b2c:	c9                   	leaveq 
  803b2d:	c3                   	retq   

0000000000803b2e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803b2e:	55                   	push   %rbp
  803b2f:	48 89 e5             	mov    %rsp,%rbp
  803b32:	53                   	push   %rbx
  803b33:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803b3a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803b41:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803b47:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803b4e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803b55:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803b5c:	84 c0                	test   %al,%al
  803b5e:	74 23                	je     803b83 <_panic+0x55>
  803b60:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b67:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b6b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b6f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b73:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b77:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b7b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b7f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b83:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b8a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b91:	00 00 00 
  803b94:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b9b:	00 00 00 
  803b9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ba2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803ba9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803bb0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803bb7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803bbe:	00 00 00 
  803bc1:	48 8b 18             	mov    (%rax),%rbx
  803bc4:	48 b8 9b 17 80 00 00 	movabs $0x80179b,%rax
  803bcb:	00 00 00 
  803bce:	ff d0                	callq  *%rax
  803bd0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803bd6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803bdd:	41 89 c8             	mov    %ecx,%r8d
  803be0:	48 89 d1             	mov    %rdx,%rcx
  803be3:	48 89 da             	mov    %rbx,%rdx
  803be6:	89 c6                	mov    %eax,%esi
  803be8:	48 bf d0 45 80 00 00 	movabs $0x8045d0,%rdi
  803bef:	00 00 00 
  803bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf7:	49 b9 20 03 80 00 00 	movabs $0x800320,%r9
  803bfe:	00 00 00 
  803c01:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803c04:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803c0b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803c12:	48 89 d6             	mov    %rdx,%rsi
  803c15:	48 89 c7             	mov    %rax,%rdi
  803c18:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  803c1f:	00 00 00 
  803c22:	ff d0                	callq  *%rax
	cprintf("\n");
  803c24:	48 bf f3 45 80 00 00 	movabs $0x8045f3,%rdi
  803c2b:	00 00 00 
  803c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c33:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  803c3a:	00 00 00 
  803c3d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803c3f:	cc                   	int3   
  803c40:	eb fd                	jmp    803c3f <_panic+0x111>

0000000000803c42 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803c42:	55                   	push   %rbp
  803c43:	48 89 e5             	mov    %rsp,%rbp
  803c46:	48 83 ec 10          	sub    $0x10,%rsp
  803c4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803c4e:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c55:	00 00 00 
  803c58:	48 8b 00             	mov    (%rax),%rax
  803c5b:	48 85 c0             	test   %rax,%rax
  803c5e:	75 49                	jne    803ca9 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803c60:	ba 07 00 00 00       	mov    $0x7,%edx
  803c65:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803c6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6f:	48 b8 17 18 80 00 00 	movabs $0x801817,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
  803c7b:	85 c0                	test   %eax,%eax
  803c7d:	79 2a                	jns    803ca9 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803c7f:	48 ba f8 45 80 00 00 	movabs $0x8045f8,%rdx
  803c86:	00 00 00 
  803c89:	be 21 00 00 00       	mov    $0x21,%esi
  803c8e:	48 bf 23 46 80 00 00 	movabs $0x804623,%rdi
  803c95:	00 00 00 
  803c98:	b8 00 00 00 00       	mov    $0x0,%eax
  803c9d:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  803ca4:	00 00 00 
  803ca7:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803ca9:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803cb0:	00 00 00 
  803cb3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803cb7:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803cba:	48 be 05 3d 80 00 00 	movabs $0x803d05,%rsi
  803cc1:	00 00 00 
  803cc4:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc9:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  803cd0:	00 00 00 
  803cd3:	ff d0                	callq  *%rax
  803cd5:	85 c0                	test   %eax,%eax
  803cd7:	79 2a                	jns    803d03 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803cd9:	48 ba 38 46 80 00 00 	movabs $0x804638,%rdx
  803ce0:	00 00 00 
  803ce3:	be 27 00 00 00       	mov    $0x27,%esi
  803ce8:	48 bf 23 46 80 00 00 	movabs $0x804623,%rdi
  803cef:	00 00 00 
  803cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf7:	48 b9 2e 3b 80 00 00 	movabs $0x803b2e,%rcx
  803cfe:	00 00 00 
  803d01:	ff d1                	callq  *%rcx
}
  803d03:	c9                   	leaveq 
  803d04:	c3                   	retq   

0000000000803d05 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803d05:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803d08:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803d0f:	00 00 00 
call *%rax
  803d12:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803d14:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803d1b:	00 
    movq 152(%rsp), %rcx
  803d1c:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803d23:	00 
    subq $8, %rcx
  803d24:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803d28:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803d2b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803d32:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803d33:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803d37:	4c 8b 3c 24          	mov    (%rsp),%r15
  803d3b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803d40:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803d45:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803d4a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803d4f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803d54:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803d59:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803d5e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803d63:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803d68:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803d6d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803d72:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803d77:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803d7c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803d81:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803d85:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803d89:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803d8a:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803d8b:	c3                   	retq   

0000000000803d8c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d8c:	55                   	push   %rbp
  803d8d:	48 89 e5             	mov    %rsp,%rbp
  803d90:	48 83 ec 18          	sub    $0x18,%rsp
  803d94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d9c:	48 c1 e8 15          	shr    $0x15,%rax
  803da0:	48 89 c2             	mov    %rax,%rdx
  803da3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803daa:	01 00 00 
  803dad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803db1:	83 e0 01             	and    $0x1,%eax
  803db4:	48 85 c0             	test   %rax,%rax
  803db7:	75 07                	jne    803dc0 <pageref+0x34>
		return 0;
  803db9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dbe:	eb 53                	jmp    803e13 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803dc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dc4:	48 c1 e8 0c          	shr    $0xc,%rax
  803dc8:	48 89 c2             	mov    %rax,%rdx
  803dcb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dd2:	01 00 00 
  803dd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de1:	83 e0 01             	and    $0x1,%eax
  803de4:	48 85 c0             	test   %rax,%rax
  803de7:	75 07                	jne    803df0 <pageref+0x64>
		return 0;
  803de9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dee:	eb 23                	jmp    803e13 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df4:	48 c1 e8 0c          	shr    $0xc,%rax
  803df8:	48 89 c2             	mov    %rax,%rdx
  803dfb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e02:	00 00 00 
  803e05:	48 c1 e2 04          	shl    $0x4,%rdx
  803e09:	48 01 d0             	add    %rdx,%rax
  803e0c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e10:	0f b7 c0             	movzwl %ax,%eax
}
  803e13:	c9                   	leaveq 
  803e14:	c3                   	retq   
