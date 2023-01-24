
obj/user/forktree:     file format elf64-x86-64


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
  80003c:	e8 24 01 00 00       	callq  800165 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba c0 22 80 00 00 	movabs $0x8022c0,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 ad 0d 80 00 00 	movabs $0x800dad,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 a5 1d 80 00 00 	movabs $0x801da5,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 f6 01 80 00 00 	movabs $0x8001f6,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf c5 22 80 00 00 	movabs $0x8022c5,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 32 03 80 00 00 	movabs $0x800332,%rcx
  800107:	00 00 00 
  80010a:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  80010c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800110:	be 30 00 00 00       	mov    $0x30,%esi
  800115:	48 89 c7             	mov    %rax,%rdi
  800118:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800128:	be 31 00 00 00       	mov    $0x31,%esi
  80012d:	48 89 c7             	mov    %rax,%rdi
  800130:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax
}
  80013c:	c9                   	leaveq 
  80013d:	c3                   	retq   

000000000080013e <umain>:

void
umain(int argc, char **argv)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	48 83 ec 10          	sub    $0x10,%rsp
  800146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  80014d:	48 bf d6 22 80 00 00 	movabs $0x8022d6,%rdi
  800154:	00 00 00 
  800157:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
}
  800163:	c9                   	leaveq 
  800164:	c3                   	retq   

0000000000800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 83 ec 20          	sub    $0x20,%rsp
  80016d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800170:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800174:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800186:	25 ff 03 00 00       	and    $0x3ff,%eax
  80018b:	48 63 d0             	movslq %eax,%rdx
  80018e:	48 89 d0             	mov    %rdx,%rax
  800191:	48 c1 e0 03          	shl    $0x3,%rax
  800195:	48 01 d0             	add    %rdx,%rax
  800198:	48 c1 e0 05          	shl    $0x5,%rax
  80019c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001a3:	00 00 00 
  8001a6:	48 01 c2             	add    %rax,%rdx
  8001a9:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8001b0:	00 00 00 
  8001b3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001ba:	7e 14                	jle    8001d0 <libmain+0x6b>
		binaryname = argv[0];
  8001bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001c0:	48 8b 10             	mov    (%rax),%rdx
  8001c3:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8001ca:	00 00 00 
  8001cd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001d7:	48 89 d6             	mov    %rdx,%rsi
  8001da:	89 c7                	mov    %eax,%edi
  8001dc:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8001e3:	00 00 00 
  8001e6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001e8:	48 b8 f6 01 80 00 00 	movabs $0x8001f6,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	callq  *%rax
}
  8001f4:	c9                   	leaveq 
  8001f5:	c3                   	retq   

00000000008001f6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f6:	55                   	push   %rbp
  8001f7:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ff:	48 b8 69 17 80 00 00 	movabs $0x801769,%rax
  800206:	00 00 00 
  800209:	ff d0                	callq  *%rax
}
  80020b:	5d                   	pop    %rbp
  80020c:	c3                   	retq   

000000000080020d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80020d:	55                   	push   %rbp
  80020e:	48 89 e5             	mov    %rsp,%rbp
  800211:	48 83 ec 10          	sub    $0x10,%rsp
  800215:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800218:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80021c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800220:	8b 00                	mov    (%rax),%eax
  800222:	8d 48 01             	lea    0x1(%rax),%ecx
  800225:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800229:	89 0a                	mov    %ecx,(%rdx)
  80022b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80022e:	89 d1                	mov    %edx,%ecx
  800230:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800234:	48 98                	cltq   
  800236:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80023a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023e:	8b 00                	mov    (%rax),%eax
  800240:	3d ff 00 00 00       	cmp    $0xff,%eax
  800245:	75 2c                	jne    800273 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024b:	8b 00                	mov    (%rax),%eax
  80024d:	48 98                	cltq   
  80024f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800253:	48 83 c2 08          	add    $0x8,%rdx
  800257:	48 89 c6             	mov    %rax,%rsi
  80025a:	48 89 d7             	mov    %rdx,%rdi
  80025d:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
        b->idx = 0;
  800269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800277:	8b 40 04             	mov    0x4(%rax),%eax
  80027a:	8d 50 01             	lea    0x1(%rax),%edx
  80027d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800281:	89 50 04             	mov    %edx,0x4(%rax)
}
  800284:	c9                   	leaveq 
  800285:	c3                   	retq   

0000000000800286 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800286:	55                   	push   %rbp
  800287:	48 89 e5             	mov    %rsp,%rbp
  80028a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800291:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800298:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80029f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002a6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002ad:	48 8b 0a             	mov    (%rdx),%rcx
  8002b0:	48 89 08             	mov    %rcx,(%rax)
  8002b3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002b7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002bb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002bf:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002ca:	00 00 00 
    b.cnt = 0;
  8002cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002d4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002d7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002de:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002e5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002ec:	48 89 c6             	mov    %rax,%rsi
  8002ef:	48 bf 0d 02 80 00 00 	movabs $0x80020d,%rdi
  8002f6:	00 00 00 
  8002f9:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800305:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80030b:	48 98                	cltq   
  80030d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800314:	48 83 c2 08          	add    $0x8,%rdx
  800318:	48 89 c6             	mov    %rax,%rsi
  80031b:	48 89 d7             	mov    %rdx,%rdi
  80031e:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80032a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800330:	c9                   	leaveq 
  800331:	c3                   	retq   

0000000000800332 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
  800336:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80033d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800344:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80034b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800352:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800359:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800360:	84 c0                	test   %al,%al
  800362:	74 20                	je     800384 <cprintf+0x52>
  800364:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800368:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80036c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800370:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800374:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800378:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80037c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800380:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800384:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80038b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800392:	00 00 00 
  800395:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80039c:	00 00 00 
  80039f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003a3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003aa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003b1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003b8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003bf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003c6:	48 8b 0a             	mov    (%rdx),%rcx
  8003c9:	48 89 08             	mov    %rcx,(%rax)
  8003cc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003d0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003d4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003d8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003dc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003e3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003ea:	48 89 d6             	mov    %rdx,%rsi
  8003ed:	48 89 c7             	mov    %rax,%rdi
  8003f0:	48 b8 86 02 80 00 00 	movabs $0x800286,%rax
  8003f7:	00 00 00 
  8003fa:	ff d0                	callq  *%rax
  8003fc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800402:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800408:	c9                   	leaveq 
  800409:	c3                   	retq   

000000000080040a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80040a:	55                   	push   %rbp
  80040b:	48 89 e5             	mov    %rsp,%rbp
  80040e:	53                   	push   %rbx
  80040f:	48 83 ec 38          	sub    $0x38,%rsp
  800413:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800417:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80041b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80041f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800422:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800426:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80042a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80042d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800431:	77 3b                	ja     80046e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800433:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800436:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80043a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80043d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	48 f7 f3             	div    %rbx
  800449:	48 89 c2             	mov    %rax,%rdx
  80044c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80044f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800452:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045a:	41 89 f9             	mov    %edi,%r9d
  80045d:	48 89 c7             	mov    %rax,%rdi
  800460:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800467:	00 00 00 
  80046a:	ff d0                	callq  *%rax
  80046c:	eb 1e                	jmp    80048c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046e:	eb 12                	jmp    800482 <printnum+0x78>
			putch(padc, putdat);
  800470:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800474:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047b:	48 89 ce             	mov    %rcx,%rsi
  80047e:	89 d7                	mov    %edx,%edi
  800480:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800482:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800486:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80048a:	7f e4                	jg     800470 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80048f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800493:	ba 00 00 00 00       	mov    $0x0,%edx
  800498:	48 f7 f1             	div    %rcx
  80049b:	48 89 d0             	mov    %rdx,%rax
  80049e:	48 ba 50 24 80 00 00 	movabs $0x802450,%rdx
  8004a5:	00 00 00 
  8004a8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004ac:	0f be d0             	movsbl %al,%edx
  8004af:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b7:	48 89 ce             	mov    %rcx,%rsi
  8004ba:	89 d7                	mov    %edx,%edi
  8004bc:	ff d0                	callq  *%rax
}
  8004be:	48 83 c4 38          	add    $0x38,%rsp
  8004c2:	5b                   	pop    %rbx
  8004c3:	5d                   	pop    %rbp
  8004c4:	c3                   	retq   

00000000008004c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c5:	55                   	push   %rbp
  8004c6:	48 89 e5             	mov    %rsp,%rbp
  8004c9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004d1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004d4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004d8:	7e 52                	jle    80052c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004de:	8b 00                	mov    (%rax),%eax
  8004e0:	83 f8 30             	cmp    $0x30,%eax
  8004e3:	73 24                	jae    800509 <getuint+0x44>
  8004e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f1:	8b 00                	mov    (%rax),%eax
  8004f3:	89 c0                	mov    %eax,%eax
  8004f5:	48 01 d0             	add    %rdx,%rax
  8004f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fc:	8b 12                	mov    (%rdx),%edx
  8004fe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800501:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800505:	89 0a                	mov    %ecx,(%rdx)
  800507:	eb 17                	jmp    800520 <getuint+0x5b>
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800511:	48 89 d0             	mov    %rdx,%rax
  800514:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800518:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800520:	48 8b 00             	mov    (%rax),%rax
  800523:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800527:	e9 a3 00 00 00       	jmpq   8005cf <getuint+0x10a>
	else if (lflag)
  80052c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800530:	74 4f                	je     800581 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800536:	8b 00                	mov    (%rax),%eax
  800538:	83 f8 30             	cmp    $0x30,%eax
  80053b:	73 24                	jae    800561 <getuint+0x9c>
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	89 c0                	mov    %eax,%eax
  80054d:	48 01 d0             	add    %rdx,%rax
  800550:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800554:	8b 12                	mov    (%rdx),%edx
  800556:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800559:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055d:	89 0a                	mov    %ecx,(%rdx)
  80055f:	eb 17                	jmp    800578 <getuint+0xb3>
  800561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800565:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800569:	48 89 d0             	mov    %rdx,%rax
  80056c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800570:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800574:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800578:	48 8b 00             	mov    (%rax),%rax
  80057b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057f:	eb 4e                	jmp    8005cf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	83 f8 30             	cmp    $0x30,%eax
  80058a:	73 24                	jae    8005b0 <getuint+0xeb>
  80058c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800590:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800598:	8b 00                	mov    (%rax),%eax
  80059a:	89 c0                	mov    %eax,%eax
  80059c:	48 01 d0             	add    %rdx,%rax
  80059f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a3:	8b 12                	mov    (%rdx),%edx
  8005a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ac:	89 0a                	mov    %ecx,(%rdx)
  8005ae:	eb 17                	jmp    8005c7 <getuint+0x102>
  8005b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b8:	48 89 d0             	mov    %rdx,%rax
  8005bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c7:	8b 00                	mov    (%rax),%eax
  8005c9:	89 c0                	mov    %eax,%eax
  8005cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005d3:	c9                   	leaveq 
  8005d4:	c3                   	retq   

00000000008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %rbp
  8005d6:	48 89 e5             	mov    %rsp,%rbp
  8005d9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005e4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e8:	7e 52                	jle    80063c <getint+0x67>
		x=va_arg(*ap, long long);
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	83 f8 30             	cmp    $0x30,%eax
  8005f3:	73 24                	jae    800619 <getint+0x44>
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800601:	8b 00                	mov    (%rax),%eax
  800603:	89 c0                	mov    %eax,%eax
  800605:	48 01 d0             	add    %rdx,%rax
  800608:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060c:	8b 12                	mov    (%rdx),%edx
  80060e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	89 0a                	mov    %ecx,(%rdx)
  800617:	eb 17                	jmp    800630 <getint+0x5b>
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800621:	48 89 d0             	mov    %rdx,%rax
  800624:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800628:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800637:	e9 a3 00 00 00       	jmpq   8006df <getint+0x10a>
	else if (lflag)
  80063c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800640:	74 4f                	je     800691 <getint+0xbc>
		x=va_arg(*ap, long);
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	8b 00                	mov    (%rax),%eax
  800648:	83 f8 30             	cmp    $0x30,%eax
  80064b:	73 24                	jae    800671 <getint+0x9c>
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	89 c0                	mov    %eax,%eax
  80065d:	48 01 d0             	add    %rdx,%rax
  800660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800664:	8b 12                	mov    (%rdx),%edx
  800666:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800669:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066d:	89 0a                	mov    %ecx,(%rdx)
  80066f:	eb 17                	jmp    800688 <getint+0xb3>
  800671:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800675:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800679:	48 89 d0             	mov    %rdx,%rax
  80067c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800684:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800688:	48 8b 00             	mov    (%rax),%rax
  80068b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068f:	eb 4e                	jmp    8006df <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	83 f8 30             	cmp    $0x30,%eax
  80069a:	73 24                	jae    8006c0 <getint+0xeb>
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a8:	8b 00                	mov    (%rax),%eax
  8006aa:	89 c0                	mov    %eax,%eax
  8006ac:	48 01 d0             	add    %rdx,%rax
  8006af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b3:	8b 12                	mov    (%rdx),%edx
  8006b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bc:	89 0a                	mov    %ecx,(%rdx)
  8006be:	eb 17                	jmp    8006d7 <getint+0x102>
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c8:	48 89 d0             	mov    %rdx,%rax
  8006cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d7:	8b 00                	mov    (%rax),%eax
  8006d9:	48 98                	cltq   
  8006db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e3:	c9                   	leaveq 
  8006e4:	c3                   	retq   

00000000008006e5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e5:	55                   	push   %rbp
  8006e6:	48 89 e5             	mov    %rsp,%rbp
  8006e9:	41 54                	push   %r12
  8006eb:	53                   	push   %rbx
  8006ec:	48 83 ec 60          	sub    $0x60,%rsp
  8006f0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006f4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006f8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006fc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800700:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800704:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800708:	48 8b 0a             	mov    (%rdx),%rcx
  80070b:	48 89 08             	mov    %rcx,(%rax)
  80070e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800712:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800716:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80071a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071e:	eb 17                	jmp    800737 <vprintfmt+0x52>
			if (ch == '\0')
  800720:	85 db                	test   %ebx,%ebx
  800722:	0f 84 df 04 00 00    	je     800c07 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800728:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80072c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800730:	48 89 d6             	mov    %rdx,%rsi
  800733:	89 df                	mov    %ebx,%edi
  800735:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800737:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80073b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80073f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800743:	0f b6 00             	movzbl (%rax),%eax
  800746:	0f b6 d8             	movzbl %al,%ebx
  800749:	83 fb 25             	cmp    $0x25,%ebx
  80074c:	75 d2                	jne    800720 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80074e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800752:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800759:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800760:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800767:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800772:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800776:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80077a:	0f b6 00             	movzbl (%rax),%eax
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 47 04 00 00    	ja     800bd3 <vprintfmt+0x4ee>
  80078c:	89 c0                	mov    %eax,%eax
  80078e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800795:	00 
  800796:	48 b8 78 24 80 00 00 	movabs $0x802478,%rax
  80079d:	00 00 00 
  8007a0:	48 01 d0             	add    %rdx,%rax
  8007a3:	48 8b 00             	mov    (%rax),%rax
  8007a6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007a8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007ac:	eb c0                	jmp    80076e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ae:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007b2:	eb ba                	jmp    80076e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007bb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007be:	89 d0                	mov    %edx,%eax
  8007c0:	c1 e0 02             	shl    $0x2,%eax
  8007c3:	01 d0                	add    %edx,%eax
  8007c5:	01 c0                	add    %eax,%eax
  8007c7:	01 d8                	add    %ebx,%eax
  8007c9:	83 e8 30             	sub    $0x30,%eax
  8007cc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007cf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d3:	0f b6 00             	movzbl (%rax),%eax
  8007d6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007d9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007dc:	7e 0c                	jle    8007ea <vprintfmt+0x105>
  8007de:	83 fb 39             	cmp    $0x39,%ebx
  8007e1:	7f 07                	jg     8007ea <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e8:	eb d1                	jmp    8007bb <vprintfmt+0xd6>
			goto process_precision;
  8007ea:	eb 58                	jmp    800844 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ef:	83 f8 30             	cmp    $0x30,%eax
  8007f2:	73 17                	jae    80080b <vprintfmt+0x126>
  8007f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fb:	89 c0                	mov    %eax,%eax
  8007fd:	48 01 d0             	add    %rdx,%rax
  800800:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800803:	83 c2 08             	add    $0x8,%edx
  800806:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800809:	eb 0f                	jmp    80081a <vprintfmt+0x135>
  80080b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080f:	48 89 d0             	mov    %rdx,%rax
  800812:	48 83 c2 08          	add    $0x8,%rdx
  800816:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80081a:	8b 00                	mov    (%rax),%eax
  80081c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80081f:	eb 23                	jmp    800844 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800821:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800825:	79 0c                	jns    800833 <vprintfmt+0x14e>
				width = 0;
  800827:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80082e:	e9 3b ff ff ff       	jmpq   80076e <vprintfmt+0x89>
  800833:	e9 36 ff ff ff       	jmpq   80076e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800838:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80083f:	e9 2a ff ff ff       	jmpq   80076e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800844:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800848:	79 12                	jns    80085c <vprintfmt+0x177>
				width = precision, precision = -1;
  80084a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80084d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800850:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800857:	e9 12 ff ff ff       	jmpq   80076e <vprintfmt+0x89>
  80085c:	e9 0d ff ff ff       	jmpq   80076e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800861:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800865:	e9 04 ff ff ff       	jmpq   80076e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80086a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086d:	83 f8 30             	cmp    $0x30,%eax
  800870:	73 17                	jae    800889 <vprintfmt+0x1a4>
  800872:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800876:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800879:	89 c0                	mov    %eax,%eax
  80087b:	48 01 d0             	add    %rdx,%rax
  80087e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800881:	83 c2 08             	add    $0x8,%edx
  800884:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800887:	eb 0f                	jmp    800898 <vprintfmt+0x1b3>
  800889:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80088d:	48 89 d0             	mov    %rdx,%rax
  800890:	48 83 c2 08          	add    $0x8,%rdx
  800894:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800898:	8b 10                	mov    (%rax),%edx
  80089a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80089e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a2:	48 89 ce             	mov    %rcx,%rsi
  8008a5:	89 d7                	mov    %edx,%edi
  8008a7:	ff d0                	callq  *%rax
			break;
  8008a9:	e9 53 03 00 00       	jmpq   800c01 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b1:	83 f8 30             	cmp    $0x30,%eax
  8008b4:	73 17                	jae    8008cd <vprintfmt+0x1e8>
  8008b6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bd:	89 c0                	mov    %eax,%eax
  8008bf:	48 01 d0             	add    %rdx,%rax
  8008c2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c5:	83 c2 08             	add    $0x8,%edx
  8008c8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008cb:	eb 0f                	jmp    8008dc <vprintfmt+0x1f7>
  8008cd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d1:	48 89 d0             	mov    %rdx,%rax
  8008d4:	48 83 c2 08          	add    $0x8,%rdx
  8008d8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008dc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008de:	85 db                	test   %ebx,%ebx
  8008e0:	79 02                	jns    8008e4 <vprintfmt+0x1ff>
				err = -err;
  8008e2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008e4:	83 fb 15             	cmp    $0x15,%ebx
  8008e7:	7f 16                	jg     8008ff <vprintfmt+0x21a>
  8008e9:	48 b8 a0 23 80 00 00 	movabs $0x8023a0,%rax
  8008f0:	00 00 00 
  8008f3:	48 63 d3             	movslq %ebx,%rdx
  8008f6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008fa:	4d 85 e4             	test   %r12,%r12
  8008fd:	75 2e                	jne    80092d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008ff:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800903:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800907:	89 d9                	mov    %ebx,%ecx
  800909:	48 ba 61 24 80 00 00 	movabs $0x802461,%rdx
  800910:	00 00 00 
  800913:	48 89 c7             	mov    %rax,%rdi
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	49 b8 10 0c 80 00 00 	movabs $0x800c10,%r8
  800922:	00 00 00 
  800925:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800928:	e9 d4 02 00 00       	jmpq   800c01 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80092d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800931:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800935:	4c 89 e1             	mov    %r12,%rcx
  800938:	48 ba 6a 24 80 00 00 	movabs $0x80246a,%rdx
  80093f:	00 00 00 
  800942:	48 89 c7             	mov    %rax,%rdi
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	49 b8 10 0c 80 00 00 	movabs $0x800c10,%r8
  800951:	00 00 00 
  800954:	41 ff d0             	callq  *%r8
			break;
  800957:	e9 a5 02 00 00       	jmpq   800c01 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80095c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095f:	83 f8 30             	cmp    $0x30,%eax
  800962:	73 17                	jae    80097b <vprintfmt+0x296>
  800964:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800968:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096b:	89 c0                	mov    %eax,%eax
  80096d:	48 01 d0             	add    %rdx,%rax
  800970:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800973:	83 c2 08             	add    $0x8,%edx
  800976:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800979:	eb 0f                	jmp    80098a <vprintfmt+0x2a5>
  80097b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097f:	48 89 d0             	mov    %rdx,%rax
  800982:	48 83 c2 08          	add    $0x8,%rdx
  800986:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80098a:	4c 8b 20             	mov    (%rax),%r12
  80098d:	4d 85 e4             	test   %r12,%r12
  800990:	75 0a                	jne    80099c <vprintfmt+0x2b7>
				p = "(null)";
  800992:	49 bc 6d 24 80 00 00 	movabs $0x80246d,%r12
  800999:	00 00 00 
			if (width > 0 && padc != '-')
  80099c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a0:	7e 3f                	jle    8009e1 <vprintfmt+0x2fc>
  8009a2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009a6:	74 39                	je     8009e1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009ab:	48 98                	cltq   
  8009ad:	48 89 c6             	mov    %rax,%rsi
  8009b0:	4c 89 e7             	mov    %r12,%rdi
  8009b3:	48 b8 bc 0e 80 00 00 	movabs $0x800ebc,%rax
  8009ba:	00 00 00 
  8009bd:	ff d0                	callq  *%rax
  8009bf:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009c2:	eb 17                	jmp    8009db <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009c4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009c8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009cc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d0:	48 89 ce             	mov    %rcx,%rsi
  8009d3:	89 d7                	mov    %edx,%edi
  8009d5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009db:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009df:	7f e3                	jg     8009c4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e1:	eb 37                	jmp    800a1a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009e7:	74 1e                	je     800a07 <vprintfmt+0x322>
  8009e9:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ec:	7e 05                	jle    8009f3 <vprintfmt+0x30e>
  8009ee:	83 fb 7e             	cmp    $0x7e,%ebx
  8009f1:	7e 14                	jle    800a07 <vprintfmt+0x322>
					putch('?', putdat);
  8009f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fb:	48 89 d6             	mov    %rdx,%rsi
  8009fe:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a03:	ff d0                	callq  *%rax
  800a05:	eb 0f                	jmp    800a16 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0f:	48 89 d6             	mov    %rdx,%rsi
  800a12:	89 df                	mov    %ebx,%edi
  800a14:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a16:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a1a:	4c 89 e0             	mov    %r12,%rax
  800a1d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a21:	0f b6 00             	movzbl (%rax),%eax
  800a24:	0f be d8             	movsbl %al,%ebx
  800a27:	85 db                	test   %ebx,%ebx
  800a29:	74 10                	je     800a3b <vprintfmt+0x356>
  800a2b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a2f:	78 b2                	js     8009e3 <vprintfmt+0x2fe>
  800a31:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a35:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a39:	79 a8                	jns    8009e3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3b:	eb 16                	jmp    800a53 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a3d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a45:	48 89 d6             	mov    %rdx,%rsi
  800a48:	bf 20 00 00 00       	mov    $0x20,%edi
  800a4d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a53:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a57:	7f e4                	jg     800a3d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a59:	e9 a3 01 00 00       	jmpq   800c01 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a5e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a62:	be 03 00 00 00       	mov    $0x3,%esi
  800a67:	48 89 c7             	mov    %rax,%rdi
  800a6a:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  800a71:	00 00 00 
  800a74:	ff d0                	callq  *%rax
  800a76:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	48 85 c0             	test   %rax,%rax
  800a81:	79 1d                	jns    800aa0 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8b:	48 89 d6             	mov    %rdx,%rsi
  800a8e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a93:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a99:	48 f7 d8             	neg    %rax
  800a9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800aa0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800aa7:	e9 e8 00 00 00       	jmpq   800b94 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800aac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ab0:	be 03 00 00 00       	mov    $0x3,%esi
  800ab5:	48 89 c7             	mov    %rax,%rdi
  800ab8:	48 b8 c5 04 80 00 00 	movabs $0x8004c5,%rax
  800abf:	00 00 00 
  800ac2:	ff d0                	callq  *%rax
  800ac4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ac8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800acf:	e9 c0 00 00 00       	jmpq   800b94 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  800af8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b00:	48 89 d6             	mov    %rdx,%rsi
  800b03:	bf 58 00 00 00       	mov    $0x58,%edi
  800b08:	ff d0                	callq  *%rax
			break;
  800b0a:	e9 f2 00 00 00       	jmpq   800c01 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800b0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b17:	48 89 d6             	mov    %rdx,%rsi
  800b1a:	bf 30 00 00 00       	mov    $0x30,%edi
  800b1f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b29:	48 89 d6             	mov    %rdx,%rsi
  800b2c:	bf 78 00 00 00       	mov    $0x78,%edi
  800b31:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b33:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b36:	83 f8 30             	cmp    $0x30,%eax
  800b39:	73 17                	jae    800b52 <vprintfmt+0x46d>
  800b3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b42:	89 c0                	mov    %eax,%eax
  800b44:	48 01 d0             	add    %rdx,%rax
  800b47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4a:	83 c2 08             	add    $0x8,%edx
  800b4d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b50:	eb 0f                	jmp    800b61 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800b52:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b56:	48 89 d0             	mov    %rdx,%rax
  800b59:	48 83 c2 08          	add    $0x8,%rdx
  800b5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b61:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b64:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b68:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b6f:	eb 23                	jmp    800b94 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b71:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b75:	be 03 00 00 00       	mov    $0x3,%esi
  800b7a:	48 89 c7             	mov    %rax,%rdi
  800b7d:	48 b8 c5 04 80 00 00 	movabs $0x8004c5,%rax
  800b84:	00 00 00 
  800b87:	ff d0                	callq  *%rax
  800b89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b8d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b94:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b99:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b9c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ba7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bab:	45 89 c1             	mov    %r8d,%r9d
  800bae:	41 89 f8             	mov    %edi,%r8d
  800bb1:	48 89 c7             	mov    %rax,%rdi
  800bb4:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800bbb:	00 00 00 
  800bbe:	ff d0                	callq  *%rax
			break;
  800bc0:	eb 3f                	jmp    800c01 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bca:	48 89 d6             	mov    %rdx,%rsi
  800bcd:	89 df                	mov    %ebx,%edi
  800bcf:	ff d0                	callq  *%rax
			break;
  800bd1:	eb 2e                	jmp    800c01 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bdb:	48 89 d6             	mov    %rdx,%rsi
  800bde:	bf 25 00 00 00       	mov    $0x25,%edi
  800be3:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bea:	eb 05                	jmp    800bf1 <vprintfmt+0x50c>
  800bec:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bf1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf5:	48 83 e8 01          	sub    $0x1,%rax
  800bf9:	0f b6 00             	movzbl (%rax),%eax
  800bfc:	3c 25                	cmp    $0x25,%al
  800bfe:	75 ec                	jne    800bec <vprintfmt+0x507>
				/* do nothing */;
			break;
  800c00:	90                   	nop
		}
	}
  800c01:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c02:	e9 30 fb ff ff       	jmpq   800737 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c07:	48 83 c4 60          	add    $0x60,%rsp
  800c0b:	5b                   	pop    %rbx
  800c0c:	41 5c                	pop    %r12
  800c0e:	5d                   	pop    %rbp
  800c0f:	c3                   	retq   

0000000000800c10 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c10:	55                   	push   %rbp
  800c11:	48 89 e5             	mov    %rsp,%rbp
  800c14:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c1b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c22:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c29:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c30:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c37:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c3e:	84 c0                	test   %al,%al
  800c40:	74 20                	je     800c62 <printfmt+0x52>
  800c42:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c46:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c4a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c4e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c52:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c56:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c5a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c5e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c62:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c69:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c70:	00 00 00 
  800c73:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c7a:	00 00 00 
  800c7d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c81:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c88:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c8f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c96:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c9d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ca4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cab:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cb2:	48 89 c7             	mov    %rax,%rdi
  800cb5:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  800cbc:	00 00 00 
  800cbf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cc1:	c9                   	leaveq 
  800cc2:	c3                   	retq   

0000000000800cc3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cc3:	55                   	push   %rbp
  800cc4:	48 89 e5             	mov    %rsp,%rbp
  800cc7:	48 83 ec 10          	sub    $0x10,%rsp
  800ccb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd6:	8b 40 10             	mov    0x10(%rax),%eax
  800cd9:	8d 50 01             	lea    0x1(%rax),%edx
  800cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce7:	48 8b 10             	mov    (%rax),%rdx
  800cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cee:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cf2:	48 39 c2             	cmp    %rax,%rdx
  800cf5:	73 17                	jae    800d0e <sprintputch+0x4b>
		*b->buf++ = ch;
  800cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cfb:	48 8b 00             	mov    (%rax),%rax
  800cfe:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d06:	48 89 0a             	mov    %rcx,(%rdx)
  800d09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d0c:	88 10                	mov    %dl,(%rax)
}
  800d0e:	c9                   	leaveq 
  800d0f:	c3                   	retq   

0000000000800d10 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d10:	55                   	push   %rbp
  800d11:	48 89 e5             	mov    %rsp,%rbp
  800d14:	48 83 ec 50          	sub    $0x50,%rsp
  800d18:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d1c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d1f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d23:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d27:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d2b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d2f:	48 8b 0a             	mov    (%rdx),%rcx
  800d32:	48 89 08             	mov    %rcx,(%rax)
  800d35:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d39:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d3d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d41:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d45:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d49:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d4d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d50:	48 98                	cltq   
  800d52:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d56:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d5a:	48 01 d0             	add    %rdx,%rax
  800d5d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d61:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d68:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d6d:	74 06                	je     800d75 <vsnprintf+0x65>
  800d6f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d73:	7f 07                	jg     800d7c <vsnprintf+0x6c>
		return -E_INVAL;
  800d75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d7a:	eb 2f                	jmp    800dab <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d7c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d80:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d84:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d88:	48 89 c6             	mov    %rax,%rsi
  800d8b:	48 bf c3 0c 80 00 00 	movabs $0x800cc3,%rdi
  800d92:	00 00 00 
  800d95:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  800d9c:	00 00 00 
  800d9f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800da1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800da5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800da8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800dab:	c9                   	leaveq 
  800dac:	c3                   	retq   

0000000000800dad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dad:	55                   	push   %rbp
  800dae:	48 89 e5             	mov    %rsp,%rbp
  800db1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800db8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800dbf:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800dc5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dcc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dd3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dda:	84 c0                	test   %al,%al
  800ddc:	74 20                	je     800dfe <snprintf+0x51>
  800dde:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800de2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800de6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dea:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dee:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800df2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800df6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dfa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dfe:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e05:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e0c:	00 00 00 
  800e0f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e16:	00 00 00 
  800e19:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e1d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e24:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e2b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e32:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e39:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e40:	48 8b 0a             	mov    (%rdx),%rcx
  800e43:	48 89 08             	mov    %rcx,(%rax)
  800e46:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e4a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e4e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e52:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e56:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e5d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e64:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e6a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e71:	48 89 c7             	mov    %rax,%rdi
  800e74:	48 b8 10 0d 80 00 00 	movabs $0x800d10,%rax
  800e7b:	00 00 00 
  800e7e:	ff d0                	callq  *%rax
  800e80:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e86:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e8c:	c9                   	leaveq 
  800e8d:	c3                   	retq   

0000000000800e8e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e8e:	55                   	push   %rbp
  800e8f:	48 89 e5             	mov    %rsp,%rbp
  800e92:	48 83 ec 18          	sub    $0x18,%rsp
  800e96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea1:	eb 09                	jmp    800eac <strlen+0x1e>
		n++;
  800ea3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb0:	0f b6 00             	movzbl (%rax),%eax
  800eb3:	84 c0                	test   %al,%al
  800eb5:	75 ec                	jne    800ea3 <strlen+0x15>
		n++;
	return n;
  800eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eba:	c9                   	leaveq 
  800ebb:	c3                   	retq   

0000000000800ebc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ebc:	55                   	push   %rbp
  800ebd:	48 89 e5             	mov    %rsp,%rbp
  800ec0:	48 83 ec 20          	sub    $0x20,%rsp
  800ec4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ecc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ed3:	eb 0e                	jmp    800ee3 <strnlen+0x27>
		n++;
  800ed5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ede:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ee3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ee8:	74 0b                	je     800ef5 <strnlen+0x39>
  800eea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eee:	0f b6 00             	movzbl (%rax),%eax
  800ef1:	84 c0                	test   %al,%al
  800ef3:	75 e0                	jne    800ed5 <strnlen+0x19>
		n++;
	return n;
  800ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ef8:	c9                   	leaveq 
  800ef9:	c3                   	retq   

0000000000800efa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800efa:	55                   	push   %rbp
  800efb:	48 89 e5             	mov    %rsp,%rbp
  800efe:	48 83 ec 20          	sub    $0x20,%rsp
  800f02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f12:	90                   	nop
  800f13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f17:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f1b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f1f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f23:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f27:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f2b:	0f b6 12             	movzbl (%rdx),%edx
  800f2e:	88 10                	mov    %dl,(%rax)
  800f30:	0f b6 00             	movzbl (%rax),%eax
  800f33:	84 c0                	test   %al,%al
  800f35:	75 dc                	jne    800f13 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f3b:	c9                   	leaveq 
  800f3c:	c3                   	retq   

0000000000800f3d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 83 ec 20          	sub    $0x20,%rsp
  800f45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f51:	48 89 c7             	mov    %rax,%rdi
  800f54:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  800f5b:	00 00 00 
  800f5e:	ff d0                	callq  *%rax
  800f60:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f66:	48 63 d0             	movslq %eax,%rdx
  800f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6d:	48 01 c2             	add    %rax,%rdx
  800f70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f74:	48 89 c6             	mov    %rax,%rsi
  800f77:	48 89 d7             	mov    %rdx,%rdi
  800f7a:	48 b8 fa 0e 80 00 00 	movabs $0x800efa,%rax
  800f81:	00 00 00 
  800f84:	ff d0                	callq  *%rax
	return dst;
  800f86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f8a:	c9                   	leaveq 
  800f8b:	c3                   	retq   

0000000000800f8c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f8c:	55                   	push   %rbp
  800f8d:	48 89 e5             	mov    %rsp,%rbp
  800f90:	48 83 ec 28          	sub    $0x28,%rsp
  800f94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fa8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800faf:	00 
  800fb0:	eb 2a                	jmp    800fdc <strncpy+0x50>
		*dst++ = *src;
  800fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fbe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fc2:	0f b6 12             	movzbl (%rdx),%edx
  800fc5:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fcb:	0f b6 00             	movzbl (%rax),%eax
  800fce:	84 c0                	test   %al,%al
  800fd0:	74 05                	je     800fd7 <strncpy+0x4b>
			src++;
  800fd2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fd7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fe4:	72 cc                	jb     800fb2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fea:	c9                   	leaveq 
  800feb:	c3                   	retq   

0000000000800fec <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fec:	55                   	push   %rbp
  800fed:	48 89 e5             	mov    %rsp,%rbp
  800ff0:	48 83 ec 28          	sub    $0x28,%rsp
  800ff4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ffc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801004:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801008:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80100d:	74 3d                	je     80104c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80100f:	eb 1d                	jmp    80102e <strlcpy+0x42>
			*dst++ = *src++;
  801011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801015:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801019:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80101d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801021:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801025:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801029:	0f b6 12             	movzbl (%rdx),%edx
  80102c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80102e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801033:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801038:	74 0b                	je     801045 <strlcpy+0x59>
  80103a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80103e:	0f b6 00             	movzbl (%rax),%eax
  801041:	84 c0                	test   %al,%al
  801043:	75 cc                	jne    801011 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801049:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80104c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801054:	48 29 c2             	sub    %rax,%rdx
  801057:	48 89 d0             	mov    %rdx,%rax
}
  80105a:	c9                   	leaveq 
  80105b:	c3                   	retq   

000000000080105c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 10          	sub    $0x10,%rsp
  801064:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801068:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80106c:	eb 0a                	jmp    801078 <strcmp+0x1c>
		p++, q++;
  80106e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801073:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107c:	0f b6 00             	movzbl (%rax),%eax
  80107f:	84 c0                	test   %al,%al
  801081:	74 12                	je     801095 <strcmp+0x39>
  801083:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801087:	0f b6 10             	movzbl (%rax),%edx
  80108a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108e:	0f b6 00             	movzbl (%rax),%eax
  801091:	38 c2                	cmp    %al,%dl
  801093:	74 d9                	je     80106e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801095:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801099:	0f b6 00             	movzbl (%rax),%eax
  80109c:	0f b6 d0             	movzbl %al,%edx
  80109f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	0f b6 c0             	movzbl %al,%eax
  8010a9:	29 c2                	sub    %eax,%edx
  8010ab:	89 d0                	mov    %edx,%eax
}
  8010ad:	c9                   	leaveq 
  8010ae:	c3                   	retq   

00000000008010af <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010af:	55                   	push   %rbp
  8010b0:	48 89 e5             	mov    %rsp,%rbp
  8010b3:	48 83 ec 18          	sub    $0x18,%rsp
  8010b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010c3:	eb 0f                	jmp    8010d4 <strncmp+0x25>
		n--, p++, q++;
  8010c5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010cf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010d4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d9:	74 1d                	je     8010f8 <strncmp+0x49>
  8010db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010df:	0f b6 00             	movzbl (%rax),%eax
  8010e2:	84 c0                	test   %al,%al
  8010e4:	74 12                	je     8010f8 <strncmp+0x49>
  8010e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ea:	0f b6 10             	movzbl (%rax),%edx
  8010ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f1:	0f b6 00             	movzbl (%rax),%eax
  8010f4:	38 c2                	cmp    %al,%dl
  8010f6:	74 cd                	je     8010c5 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010f8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010fd:	75 07                	jne    801106 <strncmp+0x57>
		return 0;
  8010ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801104:	eb 18                	jmp    80111e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110a:	0f b6 00             	movzbl (%rax),%eax
  80110d:	0f b6 d0             	movzbl %al,%edx
  801110:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801114:	0f b6 00             	movzbl (%rax),%eax
  801117:	0f b6 c0             	movzbl %al,%eax
  80111a:	29 c2                	sub    %eax,%edx
  80111c:	89 d0                	mov    %edx,%eax
}
  80111e:	c9                   	leaveq 
  80111f:	c3                   	retq   

0000000000801120 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801120:	55                   	push   %rbp
  801121:	48 89 e5             	mov    %rsp,%rbp
  801124:	48 83 ec 0c          	sub    $0xc,%rsp
  801128:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80112c:	89 f0                	mov    %esi,%eax
  80112e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801131:	eb 17                	jmp    80114a <strchr+0x2a>
		if (*s == c)
  801133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801137:	0f b6 00             	movzbl (%rax),%eax
  80113a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80113d:	75 06                	jne    801145 <strchr+0x25>
			return (char *) s;
  80113f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801143:	eb 15                	jmp    80115a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801145:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80114a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114e:	0f b6 00             	movzbl (%rax),%eax
  801151:	84 c0                	test   %al,%al
  801153:	75 de                	jne    801133 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115a:	c9                   	leaveq 
  80115b:	c3                   	retq   

000000000080115c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80115c:	55                   	push   %rbp
  80115d:	48 89 e5             	mov    %rsp,%rbp
  801160:	48 83 ec 0c          	sub    $0xc,%rsp
  801164:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801168:	89 f0                	mov    %esi,%eax
  80116a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80116d:	eb 13                	jmp    801182 <strfind+0x26>
		if (*s == c)
  80116f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801173:	0f b6 00             	movzbl (%rax),%eax
  801176:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801179:	75 02                	jne    80117d <strfind+0x21>
			break;
  80117b:	eb 10                	jmp    80118d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80117d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801186:	0f b6 00             	movzbl (%rax),%eax
  801189:	84 c0                	test   %al,%al
  80118b:	75 e2                	jne    80116f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80118d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801191:	c9                   	leaveq 
  801192:	c3                   	retq   

0000000000801193 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801193:	55                   	push   %rbp
  801194:	48 89 e5             	mov    %rsp,%rbp
  801197:	48 83 ec 18          	sub    $0x18,%rsp
  80119b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80119f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011ab:	75 06                	jne    8011b3 <memset+0x20>
		return v;
  8011ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b1:	eb 69                	jmp    80121c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b7:	83 e0 03             	and    $0x3,%eax
  8011ba:	48 85 c0             	test   %rax,%rax
  8011bd:	75 48                	jne    801207 <memset+0x74>
  8011bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c3:	83 e0 03             	and    $0x3,%eax
  8011c6:	48 85 c0             	test   %rax,%rax
  8011c9:	75 3c                	jne    801207 <memset+0x74>
		c &= 0xFF;
  8011cb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d5:	c1 e0 18             	shl    $0x18,%eax
  8011d8:	89 c2                	mov    %eax,%edx
  8011da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011dd:	c1 e0 10             	shl    $0x10,%eax
  8011e0:	09 c2                	or     %eax,%edx
  8011e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e5:	c1 e0 08             	shl    $0x8,%eax
  8011e8:	09 d0                	or     %edx,%eax
  8011ea:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f1:	48 c1 e8 02          	shr    $0x2,%rax
  8011f5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ff:	48 89 d7             	mov    %rdx,%rdi
  801202:	fc                   	cld    
  801203:	f3 ab                	rep stos %eax,%es:(%rdi)
  801205:	eb 11                	jmp    801218 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801207:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80120b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80120e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801212:	48 89 d7             	mov    %rdx,%rdi
  801215:	fc                   	cld    
  801216:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80121c:	c9                   	leaveq 
  80121d:	c3                   	retq   

000000000080121e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80121e:	55                   	push   %rbp
  80121f:	48 89 e5             	mov    %rsp,%rbp
  801222:	48 83 ec 28          	sub    $0x28,%rsp
  801226:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80122a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80122e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801232:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801236:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80123a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801246:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80124a:	0f 83 88 00 00 00    	jae    8012d8 <memmove+0xba>
  801250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801254:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801258:	48 01 d0             	add    %rdx,%rax
  80125b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80125f:	76 77                	jbe    8012d8 <memmove+0xba>
		s += n;
  801261:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801265:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	83 e0 03             	and    $0x3,%eax
  801278:	48 85 c0             	test   %rax,%rax
  80127b:	75 3b                	jne    8012b8 <memmove+0x9a>
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801281:	83 e0 03             	and    $0x3,%eax
  801284:	48 85 c0             	test   %rax,%rax
  801287:	75 2f                	jne    8012b8 <memmove+0x9a>
  801289:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80128d:	83 e0 03             	and    $0x3,%eax
  801290:	48 85 c0             	test   %rax,%rax
  801293:	75 23                	jne    8012b8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801299:	48 83 e8 04          	sub    $0x4,%rax
  80129d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a1:	48 83 ea 04          	sub    $0x4,%rdx
  8012a5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012a9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012ad:	48 89 c7             	mov    %rax,%rdi
  8012b0:	48 89 d6             	mov    %rdx,%rsi
  8012b3:	fd                   	std    
  8012b4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012b6:	eb 1d                	jmp    8012d5 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012cc:	48 89 d7             	mov    %rdx,%rdi
  8012cf:	48 89 c1             	mov    %rax,%rcx
  8012d2:	fd                   	std    
  8012d3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012d5:	fc                   	cld    
  8012d6:	eb 57                	jmp    80132f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dc:	83 e0 03             	and    $0x3,%eax
  8012df:	48 85 c0             	test   %rax,%rax
  8012e2:	75 36                	jne    80131a <memmove+0xfc>
  8012e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e8:	83 e0 03             	and    $0x3,%eax
  8012eb:	48 85 c0             	test   %rax,%rax
  8012ee:	75 2a                	jne    80131a <memmove+0xfc>
  8012f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f4:	83 e0 03             	and    $0x3,%eax
  8012f7:	48 85 c0             	test   %rax,%rax
  8012fa:	75 1e                	jne    80131a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801300:	48 c1 e8 02          	shr    $0x2,%rax
  801304:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80130f:	48 89 c7             	mov    %rax,%rdi
  801312:	48 89 d6             	mov    %rdx,%rsi
  801315:	fc                   	cld    
  801316:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801318:	eb 15                	jmp    80132f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80131a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801322:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801326:	48 89 c7             	mov    %rax,%rdi
  801329:	48 89 d6             	mov    %rdx,%rsi
  80132c:	fc                   	cld    
  80132d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801333:	c9                   	leaveq 
  801334:	c3                   	retq   

0000000000801335 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801335:	55                   	push   %rbp
  801336:	48 89 e5             	mov    %rsp,%rbp
  801339:	48 83 ec 18          	sub    $0x18,%rsp
  80133d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801341:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801345:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801349:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80134d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801355:	48 89 ce             	mov    %rcx,%rsi
  801358:	48 89 c7             	mov    %rax,%rdi
  80135b:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  801362:	00 00 00 
  801365:	ff d0                	callq  *%rax
}
  801367:	c9                   	leaveq 
  801368:	c3                   	retq   

0000000000801369 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801369:	55                   	push   %rbp
  80136a:	48 89 e5             	mov    %rsp,%rbp
  80136d:	48 83 ec 28          	sub    $0x28,%rsp
  801371:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801375:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801379:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80137d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801381:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801385:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801389:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80138d:	eb 36                	jmp    8013c5 <memcmp+0x5c>
		if (*s1 != *s2)
  80138f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801393:	0f b6 10             	movzbl (%rax),%edx
  801396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	38 c2                	cmp    %al,%dl
  80139f:	74 1a                	je     8013bb <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	0f b6 d0             	movzbl %al,%edx
  8013ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
  8013b9:	eb 20                	jmp    8013db <memcmp+0x72>
		s1++, s2++;
  8013bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013d1:	48 85 c0             	test   %rax,%rax
  8013d4:	75 b9                	jne    80138f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013db:	c9                   	leaveq 
  8013dc:	c3                   	retq   

00000000008013dd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	48 83 ec 28          	sub    $0x28,%rsp
  8013e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013f8:	48 01 d0             	add    %rdx,%rax
  8013fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013ff:	eb 15                	jmp    801416 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801405:	0f b6 10             	movzbl (%rax),%edx
  801408:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80140b:	38 c2                	cmp    %al,%dl
  80140d:	75 02                	jne    801411 <memfind+0x34>
			break;
  80140f:	eb 0f                	jmp    801420 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801411:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80141e:	72 e1                	jb     801401 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801424:	c9                   	leaveq 
  801425:	c3                   	retq   

0000000000801426 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801426:	55                   	push   %rbp
  801427:	48 89 e5             	mov    %rsp,%rbp
  80142a:	48 83 ec 34          	sub    $0x34,%rsp
  80142e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801432:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801436:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801439:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801440:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801447:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801448:	eb 05                	jmp    80144f <strtol+0x29>
		s++;
  80144a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801453:	0f b6 00             	movzbl (%rax),%eax
  801456:	3c 20                	cmp    $0x20,%al
  801458:	74 f0                	je     80144a <strtol+0x24>
  80145a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	3c 09                	cmp    $0x9,%al
  801463:	74 e5                	je     80144a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	0f b6 00             	movzbl (%rax),%eax
  80146c:	3c 2b                	cmp    $0x2b,%al
  80146e:	75 07                	jne    801477 <strtol+0x51>
		s++;
  801470:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801475:	eb 17                	jmp    80148e <strtol+0x68>
	else if (*s == '-')
  801477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147b:	0f b6 00             	movzbl (%rax),%eax
  80147e:	3c 2d                	cmp    $0x2d,%al
  801480:	75 0c                	jne    80148e <strtol+0x68>
		s++, neg = 1;
  801482:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801487:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80148e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801492:	74 06                	je     80149a <strtol+0x74>
  801494:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801498:	75 28                	jne    8014c2 <strtol+0x9c>
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	3c 30                	cmp    $0x30,%al
  8014a3:	75 1d                	jne    8014c2 <strtol+0x9c>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	48 83 c0 01          	add    $0x1,%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	3c 78                	cmp    $0x78,%al
  8014b2:	75 0e                	jne    8014c2 <strtol+0x9c>
		s += 2, base = 16;
  8014b4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014b9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014c0:	eb 2c                	jmp    8014ee <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c6:	75 19                	jne    8014e1 <strtol+0xbb>
  8014c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cc:	0f b6 00             	movzbl (%rax),%eax
  8014cf:	3c 30                	cmp    $0x30,%al
  8014d1:	75 0e                	jne    8014e1 <strtol+0xbb>
		s++, base = 8;
  8014d3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014df:	eb 0d                	jmp    8014ee <strtol+0xc8>
	else if (base == 0)
  8014e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014e5:	75 07                	jne    8014ee <strtol+0xc8>
		base = 10;
  8014e7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	3c 2f                	cmp    $0x2f,%al
  8014f7:	7e 1d                	jle    801516 <strtol+0xf0>
  8014f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 12                	jg     801516 <strtol+0xf0>
			dig = *s - '0';
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	0f be c0             	movsbl %al,%eax
  80150e:	83 e8 30             	sub    $0x30,%eax
  801511:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801514:	eb 4e                	jmp    801564 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	3c 60                	cmp    $0x60,%al
  80151f:	7e 1d                	jle    80153e <strtol+0x118>
  801521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	3c 7a                	cmp    $0x7a,%al
  80152a:	7f 12                	jg     80153e <strtol+0x118>
			dig = *s - 'a' + 10;
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	0f be c0             	movsbl %al,%eax
  801536:	83 e8 57             	sub    $0x57,%eax
  801539:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80153c:	eb 26                	jmp    801564 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80153e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	3c 40                	cmp    $0x40,%al
  801547:	7e 48                	jle    801591 <strtol+0x16b>
  801549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154d:	0f b6 00             	movzbl (%rax),%eax
  801550:	3c 5a                	cmp    $0x5a,%al
  801552:	7f 3d                	jg     801591 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	0f be c0             	movsbl %al,%eax
  80155e:	83 e8 37             	sub    $0x37,%eax
  801561:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801564:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801567:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80156a:	7c 02                	jl     80156e <strtol+0x148>
			break;
  80156c:	eb 23                	jmp    801591 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80156e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801573:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801576:	48 98                	cltq   
  801578:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80157d:	48 89 c2             	mov    %rax,%rdx
  801580:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801583:	48 98                	cltq   
  801585:	48 01 d0             	add    %rdx,%rax
  801588:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80158c:	e9 5d ff ff ff       	jmpq   8014ee <strtol+0xc8>

	if (endptr)
  801591:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801596:	74 0b                	je     8015a3 <strtol+0x17d>
		*endptr = (char *) s;
  801598:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80159c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015a0:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015a7:	74 09                	je     8015b2 <strtol+0x18c>
  8015a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ad:	48 f7 d8             	neg    %rax
  8015b0:	eb 04                	jmp    8015b6 <strtol+0x190>
  8015b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015b6:	c9                   	leaveq 
  8015b7:	c3                   	retq   

00000000008015b8 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015b8:	55                   	push   %rbp
  8015b9:	48 89 e5             	mov    %rsp,%rbp
  8015bc:	48 83 ec 30          	sub    $0x30,%rsp
  8015c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015d0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015da:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015de:	75 06                	jne    8015e6 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	eb 6b                	jmp    801651 <strstr+0x99>

	len = strlen(str);
  8015e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015ea:	48 89 c7             	mov    %rax,%rdi
  8015ed:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  8015f4:	00 00 00 
  8015f7:	ff d0                	callq  *%rax
  8015f9:	48 98                	cltq   
  8015fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801603:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801607:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80160b:	0f b6 00             	movzbl (%rax),%eax
  80160e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801611:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801615:	75 07                	jne    80161e <strstr+0x66>
				return (char *) 0;
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
  80161c:	eb 33                	jmp    801651 <strstr+0x99>
		} while (sc != c);
  80161e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801622:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801625:	75 d8                	jne    8015ff <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801627:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80162b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80162f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801633:	48 89 ce             	mov    %rcx,%rsi
  801636:	48 89 c7             	mov    %rax,%rdi
  801639:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  801640:	00 00 00 
  801643:	ff d0                	callq  *%rax
  801645:	85 c0                	test   %eax,%eax
  801647:	75 b6                	jne    8015ff <strstr+0x47>

	return (char *) (in - 1);
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	48 83 e8 01          	sub    $0x1,%rax
}
  801651:	c9                   	leaveq 
  801652:	c3                   	retq   

0000000000801653 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801653:	55                   	push   %rbp
  801654:	48 89 e5             	mov    %rsp,%rbp
  801657:	53                   	push   %rbx
  801658:	48 83 ec 48          	sub    $0x48,%rsp
  80165c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80165f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801662:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801666:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80166a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80166e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801672:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801675:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801679:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80167d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801681:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801685:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801689:	4c 89 c3             	mov    %r8,%rbx
  80168c:	cd 30                	int    $0x30
  80168e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801692:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801696:	74 3e                	je     8016d6 <syscall+0x83>
  801698:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80169d:	7e 37                	jle    8016d6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80169f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016a6:	49 89 d0             	mov    %rdx,%r8
  8016a9:	89 c1                	mov    %eax,%ecx
  8016ab:	48 ba 28 27 80 00 00 	movabs $0x802728,%rdx
  8016b2:	00 00 00 
  8016b5:	be 23 00 00 00       	mov    $0x23,%esi
  8016ba:	48 bf 45 27 80 00 00 	movabs $0x802745,%rdi
  8016c1:	00 00 00 
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	49 b9 56 20 80 00 00 	movabs $0x802056,%r9
  8016d0:	00 00 00 
  8016d3:	41 ff d1             	callq  *%r9

	return ret;
  8016d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016da:	48 83 c4 48          	add    $0x48,%rsp
  8016de:	5b                   	pop    %rbx
  8016df:	5d                   	pop    %rbp
  8016e0:	c3                   	retq   

00000000008016e1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016e1:	55                   	push   %rbp
  8016e2:	48 89 e5             	mov    %rsp,%rbp
  8016e5:	48 83 ec 20          	sub    $0x20,%rsp
  8016e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801700:	00 
  801701:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801707:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80170d:	48 89 d1             	mov    %rdx,%rcx
  801710:	48 89 c2             	mov    %rax,%rdx
  801713:	be 00 00 00 00       	mov    $0x0,%esi
  801718:	bf 00 00 00 00       	mov    $0x0,%edi
  80171d:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801724:	00 00 00 
  801727:	ff d0                	callq  *%rax
}
  801729:	c9                   	leaveq 
  80172a:	c3                   	retq   

000000000080172b <sys_cgetc>:

int
sys_cgetc(void)
{
  80172b:	55                   	push   %rbp
  80172c:	48 89 e5             	mov    %rsp,%rbp
  80172f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801733:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80173a:	00 
  80173b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801741:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801747:	b9 00 00 00 00       	mov    $0x0,%ecx
  80174c:	ba 00 00 00 00       	mov    $0x0,%edx
  801751:	be 00 00 00 00       	mov    $0x0,%esi
  801756:	bf 01 00 00 00       	mov    $0x1,%edi
  80175b:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801762:	00 00 00 
  801765:	ff d0                	callq  *%rax
}
  801767:	c9                   	leaveq 
  801768:	c3                   	retq   

0000000000801769 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801769:	55                   	push   %rbp
  80176a:	48 89 e5             	mov    %rsp,%rbp
  80176d:	48 83 ec 10          	sub    $0x10,%rsp
  801771:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801774:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801777:	48 98                	cltq   
  801779:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801780:	00 
  801781:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801787:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80178d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801792:	48 89 c2             	mov    %rax,%rdx
  801795:	be 01 00 00 00       	mov    $0x1,%esi
  80179a:	bf 03 00 00 00       	mov    $0x3,%edi
  80179f:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  8017a6:	00 00 00 
  8017a9:	ff d0                	callq  *%rax
}
  8017ab:	c9                   	leaveq 
  8017ac:	c3                   	retq   

00000000008017ad <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017ad:	55                   	push   %rbp
  8017ae:	48 89 e5             	mov    %rsp,%rbp
  8017b1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017b5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bc:	00 
  8017bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d3:	be 00 00 00 00       	mov    $0x0,%esi
  8017d8:	bf 02 00 00 00       	mov    $0x2,%edi
  8017dd:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
}
  8017e9:	c9                   	leaveq 
  8017ea:	c3                   	retq   

00000000008017eb <sys_yield>:

void
sys_yield(void)
{
  8017eb:	55                   	push   %rbp
  8017ec:	48 89 e5             	mov    %rsp,%rbp
  8017ef:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fa:	00 
  8017fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801801:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801807:	b9 00 00 00 00       	mov    $0x0,%ecx
  80180c:	ba 00 00 00 00       	mov    $0x0,%edx
  801811:	be 00 00 00 00       	mov    $0x0,%esi
  801816:	bf 0a 00 00 00       	mov    $0xa,%edi
  80181b:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801822:	00 00 00 
  801825:	ff d0                	callq  *%rax
}
  801827:	c9                   	leaveq 
  801828:	c3                   	retq   

0000000000801829 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801829:	55                   	push   %rbp
  80182a:	48 89 e5             	mov    %rsp,%rbp
  80182d:	48 83 ec 20          	sub    $0x20,%rsp
  801831:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801834:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801838:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80183b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80183e:	48 63 c8             	movslq %eax,%rcx
  801841:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801848:	48 98                	cltq   
  80184a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801851:	00 
  801852:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801858:	49 89 c8             	mov    %rcx,%r8
  80185b:	48 89 d1             	mov    %rdx,%rcx
  80185e:	48 89 c2             	mov    %rax,%rdx
  801861:	be 01 00 00 00       	mov    $0x1,%esi
  801866:	bf 04 00 00 00       	mov    $0x4,%edi
  80186b:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801872:	00 00 00 
  801875:	ff d0                	callq  *%rax
}
  801877:	c9                   	leaveq 
  801878:	c3                   	retq   

0000000000801879 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
  80187d:	48 83 ec 30          	sub    $0x30,%rsp
  801881:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801884:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801888:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80188b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80188f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801893:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801896:	48 63 c8             	movslq %eax,%rcx
  801899:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80189d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018a0:	48 63 f0             	movslq %eax,%rsi
  8018a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018aa:	48 98                	cltq   
  8018ac:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018b0:	49 89 f9             	mov    %rdi,%r9
  8018b3:	49 89 f0             	mov    %rsi,%r8
  8018b6:	48 89 d1             	mov    %rdx,%rcx
  8018b9:	48 89 c2             	mov    %rax,%rdx
  8018bc:	be 01 00 00 00       	mov    $0x1,%esi
  8018c1:	bf 05 00 00 00       	mov    $0x5,%edi
  8018c6:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  8018cd:	00 00 00 
  8018d0:	ff d0                	callq  *%rax
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	48 83 ec 20          	sub    $0x20,%rsp
  8018dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ea:	48 98                	cltq   
  8018ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f3:	00 
  8018f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801900:	48 89 d1             	mov    %rdx,%rcx
  801903:	48 89 c2             	mov    %rax,%rdx
  801906:	be 01 00 00 00       	mov    $0x1,%esi
  80190b:	bf 06 00 00 00       	mov    $0x6,%edi
  801910:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801917:	00 00 00 
  80191a:	ff d0                	callq  *%rax
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 10          	sub    $0x10,%rsp
  801926:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801929:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80192c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80192f:	48 63 d0             	movslq %eax,%rdx
  801932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801935:	48 98                	cltq   
  801937:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193e:	00 
  80193f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801945:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194b:	48 89 d1             	mov    %rdx,%rcx
  80194e:	48 89 c2             	mov    %rax,%rdx
  801951:	be 01 00 00 00       	mov    $0x1,%esi
  801956:	bf 08 00 00 00       	mov    $0x8,%edi
  80195b:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801962:	00 00 00 
  801965:	ff d0                	callq  *%rax
}
  801967:	c9                   	leaveq 
  801968:	c3                   	retq   

0000000000801969 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801969:	55                   	push   %rbp
  80196a:	48 89 e5             	mov    %rsp,%rbp
  80196d:	48 83 ec 20          	sub    $0x20,%rsp
  801971:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801974:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801978:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197f:	48 98                	cltq   
  801981:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801988:	00 
  801989:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801995:	48 89 d1             	mov    %rdx,%rcx
  801998:	48 89 c2             	mov    %rax,%rdx
  80199b:	be 01 00 00 00       	mov    $0x1,%esi
  8019a0:	bf 09 00 00 00       	mov    $0x9,%edi
  8019a5:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  8019ac:	00 00 00 
  8019af:	ff d0                	callq  *%rax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 20          	sub    $0x20,%rsp
  8019bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019c6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019cc:	48 63 f0             	movslq %eax,%rsi
  8019cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d6:	48 98                	cltq   
  8019d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e3:	00 
  8019e4:	49 89 f1             	mov    %rsi,%r9
  8019e7:	49 89 c8             	mov    %rcx,%r8
  8019ea:	48 89 d1             	mov    %rdx,%rcx
  8019ed:	48 89 c2             	mov    %rax,%rdx
  8019f0:	be 00 00 00 00       	mov    $0x0,%esi
  8019f5:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019fa:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	callq  *%rax
}
  801a06:	c9                   	leaveq 
  801a07:	c3                   	retq   

0000000000801a08 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
  801a0c:	48 83 ec 10          	sub    $0x10,%rsp
  801a10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1f:	00 
  801a20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a31:	48 89 c2             	mov    %rax,%rdx
  801a34:	be 01 00 00 00       	mov    $0x1,%esi
  801a39:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a3e:	48 b8 53 16 80 00 00 	movabs $0x801653,%rax
  801a45:	00 00 00 
  801a48:	ff d0                	callq  *%rax
}
  801a4a:	c9                   	leaveq 
  801a4b:	c3                   	retq   

0000000000801a4c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a4c:	55                   	push   %rbp
  801a4d:	48 89 e5             	mov    %rsp,%rbp
  801a50:	48 83 ec 30          	sub    $0x30,%rsp
  801a54:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5c:	48 8b 00             	mov    (%rax),%rax
  801a5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801a63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a67:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a6b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801a6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a71:	83 e0 02             	and    $0x2,%eax
  801a74:	85 c0                	test   %eax,%eax
  801a76:	75 4d                	jne    801ac5 <pgfault+0x79>
  801a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7c:	48 c1 e8 0c          	shr    $0xc,%rax
  801a80:	48 89 c2             	mov    %rax,%rdx
  801a83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a8a:	01 00 00 
  801a8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a91:	25 00 08 00 00       	and    $0x800,%eax
  801a96:	48 85 c0             	test   %rax,%rax
  801a99:	74 2a                	je     801ac5 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801a9b:	48 ba 58 27 80 00 00 	movabs $0x802758,%rdx
  801aa2:	00 00 00 
  801aa5:	be 1e 00 00 00       	mov    $0x1e,%esi
  801aaa:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801ab1:	00 00 00 
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab9:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801ac0:	00 00 00 
  801ac3:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801ac5:	ba 07 00 00 00       	mov    $0x7,%edx
  801aca:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801acf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad4:	48 b8 29 18 80 00 00 	movabs $0x801829,%rax
  801adb:	00 00 00 
  801ade:	ff d0                	callq  *%rax
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	0f 85 cd 00 00 00    	jne    801bb5 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801af4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801afa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801afe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b02:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b07:	48 89 c6             	mov    %rax,%rsi
  801b0a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b0f:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  801b16:	00 00 00 
  801b19:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801b1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b1f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b25:	48 89 c1             	mov    %rax,%rcx
  801b28:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b32:	bf 00 00 00 00       	mov    $0x0,%edi
  801b37:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  801b3e:	00 00 00 
  801b41:	ff d0                	callq  *%rax
  801b43:	85 c0                	test   %eax,%eax
  801b45:	79 2a                	jns    801b71 <pgfault+0x125>
				panic("Page map at temp address failed");
  801b47:	48 ba 88 27 80 00 00 	movabs $0x802788,%rdx
  801b4e:	00 00 00 
  801b51:	be 2f 00 00 00       	mov    $0x2f,%esi
  801b56:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801b5d:	00 00 00 
  801b60:	b8 00 00 00 00       	mov    $0x0,%eax
  801b65:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801b6c:	00 00 00 
  801b6f:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801b71:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b76:	bf 00 00 00 00       	mov    $0x0,%edi
  801b7b:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801b82:	00 00 00 
  801b85:	ff d0                	callq  *%rax
  801b87:	85 c0                	test   %eax,%eax
  801b89:	79 54                	jns    801bdf <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801b8b:	48 ba a8 27 80 00 00 	movabs $0x8027a8,%rdx
  801b92:	00 00 00 
  801b95:	be 31 00 00 00       	mov    $0x31,%esi
  801b9a:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801ba1:	00 00 00 
  801ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba9:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801bb0:	00 00 00 
  801bb3:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801bb5:	48 ba d0 27 80 00 00 	movabs $0x8027d0,%rdx
  801bbc:	00 00 00 
  801bbf:	be 35 00 00 00       	mov    $0x35,%esi
  801bc4:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801bcb:	00 00 00 
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd3:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801bda:	00 00 00 
  801bdd:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801bdf:	c9                   	leaveq 
  801be0:	c3                   	retq   

0000000000801be1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	48 83 ec 20          	sub    $0x20,%rsp
  801be9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801bec:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801bef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bf6:	01 00 00 
  801bf9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801bfc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c00:	25 07 0e 00 00       	and    $0xe07,%eax
  801c05:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c0b:	48 c1 e0 0c          	shl    $0xc,%rax
  801c0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c16:	25 00 04 00 00       	and    $0x400,%eax
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	74 57                	je     801c76 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c1f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c22:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c26:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c2d:	41 89 f0             	mov    %esi,%r8d
  801c30:	48 89 c6             	mov    %rax,%rsi
  801c33:	bf 00 00 00 00       	mov    $0x0,%edi
  801c38:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	0f 8e 52 01 00 00    	jle    801d9e <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801c4c:	48 ba fd 27 80 00 00 	movabs $0x8027fd,%rdx
  801c53:	00 00 00 
  801c56:	be 52 00 00 00       	mov    $0x52,%esi
  801c5b:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801c62:	00 00 00 
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801c71:	00 00 00 
  801c74:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801c76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c79:	83 e0 02             	and    $0x2,%eax
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	75 10                	jne    801c90 <duppage+0xaf>
  801c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c83:	25 00 08 00 00       	and    $0x800,%eax
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	0f 84 bb 00 00 00    	je     801d4b <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801c90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c93:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801c98:	80 cc 08             	or     $0x8,%ah
  801c9b:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c9e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ca1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ca5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cac:	41 89 f0             	mov    %esi,%r8d
  801caf:	48 89 c6             	mov    %rax,%rsi
  801cb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb7:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	callq  *%rax
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	7e 2a                	jle    801cf1 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801cc7:	48 ba fd 27 80 00 00 	movabs $0x8027fd,%rdx
  801cce:	00 00 00 
  801cd1:	be 5a 00 00 00       	mov    $0x5a,%esi
  801cd6:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801cdd:	00 00 00 
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce5:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801cec:	00 00 00 
  801cef:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801cf1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801cf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfc:	41 89 c8             	mov    %ecx,%r8d
  801cff:	48 89 d1             	mov    %rdx,%rcx
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
  801d07:	48 89 c6             	mov    %rax,%rsi
  801d0a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d0f:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	callq  *%rax
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	7e 2a                	jle    801d49 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801d1f:	48 ba fd 27 80 00 00 	movabs $0x8027fd,%rdx
  801d26:	00 00 00 
  801d29:	be 5d 00 00 00       	mov    $0x5d,%esi
  801d2e:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801d35:	00 00 00 
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3d:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801d44:	00 00 00 
  801d47:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d49:	eb 53                	jmp    801d9e <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d4b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d4e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d52:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d59:	41 89 f0             	mov    %esi,%r8d
  801d5c:	48 89 c6             	mov    %rax,%rsi
  801d5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d64:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	callq  *%rax
  801d70:	85 c0                	test   %eax,%eax
  801d72:	7e 2a                	jle    801d9e <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801d74:	48 ba fd 27 80 00 00 	movabs $0x8027fd,%rdx
  801d7b:	00 00 00 
  801d7e:	be 61 00 00 00       	mov    $0x61,%esi
  801d83:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801d8a:	00 00 00 
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d92:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  801d99:	00 00 00 
  801d9c:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leaveq 
  801da4:	c3                   	retq   

0000000000801da5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801da5:	55                   	push   %rbp
  801da6:	48 89 e5             	mov    %rsp,%rbp
  801da9:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801dad:	48 bf 4c 1a 80 00 00 	movabs $0x801a4c,%rdi
  801db4:	00 00 00 
  801db7:	48 b8 6a 21 80 00 00 	movabs $0x80216a,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801dc3:	b8 07 00 00 00       	mov    $0x7,%eax
  801dc8:	cd 30                	int    $0x30
  801dca:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801dcd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801dd0:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801dd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801dd7:	79 30                	jns    801e09 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801dd9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ddc:	89 c1                	mov    %eax,%ecx
  801dde:	48 ba 1b 28 80 00 00 	movabs $0x80281b,%rdx
  801de5:	00 00 00 
  801de8:	be 89 00 00 00       	mov    $0x89,%esi
  801ded:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  801df4:	00 00 00 
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	49 b8 56 20 80 00 00 	movabs $0x802056,%r8
  801e03:	00 00 00 
  801e06:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801e09:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e0d:	75 46                	jne    801e55 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e0f:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  801e16:	00 00 00 
  801e19:	ff d0                	callq  *%rax
  801e1b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e20:	48 63 d0             	movslq %eax,%rdx
  801e23:	48 89 d0             	mov    %rdx,%rax
  801e26:	48 c1 e0 03          	shl    $0x3,%rax
  801e2a:	48 01 d0             	add    %rdx,%rax
  801e2d:	48 c1 e0 05          	shl    $0x5,%rax
  801e31:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e38:	00 00 00 
  801e3b:	48 01 c2             	add    %rax,%rdx
  801e3e:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801e45:	00 00 00 
  801e48:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	e9 d1 01 00 00       	jmpq   802026 <fork+0x281>
	}

	uint64_t ad = 0;
  801e55:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801e5c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801e5d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801e62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801e66:	e9 df 00 00 00       	jmpq   801f4a <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6f:	48 c1 e8 27          	shr    $0x27,%rax
  801e73:	48 89 c2             	mov    %rax,%rdx
  801e76:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801e7d:	01 00 00 
  801e80:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e84:	83 e0 01             	and    $0x1,%eax
  801e87:	48 85 c0             	test   %rax,%rax
  801e8a:	0f 84 9e 00 00 00    	je     801f2e <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e94:	48 c1 e8 1e          	shr    $0x1e,%rax
  801e98:	48 89 c2             	mov    %rax,%rdx
  801e9b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ea2:	01 00 00 
  801ea5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea9:	83 e0 01             	and    $0x1,%eax
  801eac:	48 85 c0             	test   %rax,%rax
  801eaf:	74 73                	je     801f24 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801eb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb5:	48 c1 e8 15          	shr    $0x15,%rax
  801eb9:	48 89 c2             	mov    %rax,%rdx
  801ebc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ec3:	01 00 00 
  801ec6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eca:	83 e0 01             	and    $0x1,%eax
  801ecd:	48 85 c0             	test   %rax,%rax
  801ed0:	74 48                	je     801f1a <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801ed2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed6:	48 c1 e8 0c          	shr    $0xc,%rax
  801eda:	48 89 c2             	mov    %rax,%rdx
  801edd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ee4:	01 00 00 
  801ee7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eeb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef3:	83 e0 01             	and    $0x1,%eax
  801ef6:	48 85 c0             	test   %rax,%rax
  801ef9:	74 47                	je     801f42 <fork+0x19d>
						duppage(envid, VPN(addr));
  801efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eff:	48 c1 e8 0c          	shr    $0xc,%rax
  801f03:	89 c2                	mov    %eax,%edx
  801f05:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f08:	89 d6                	mov    %edx,%esi
  801f0a:	89 c7                	mov    %eax,%edi
  801f0c:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
  801f18:	eb 28                	jmp    801f42 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  801f1a:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801f21:	00 
  801f22:	eb 1e                	jmp    801f42 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801f24:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801f2b:	40 
  801f2c:	eb 14                	jmp    801f42 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  801f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f32:	48 c1 e8 27          	shr    $0x27,%rax
  801f36:	48 83 c0 01          	add    $0x1,%rax
  801f3a:	48 c1 e0 27          	shl    $0x27,%rax
  801f3e:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801f42:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801f49:	00 
  801f4a:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  801f51:	00 
  801f52:	0f 87 13 ff ff ff    	ja     801e6b <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801f58:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f5b:	ba 07 00 00 00       	mov    $0x7,%edx
  801f60:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f65:	89 c7                	mov    %eax,%edi
  801f67:	48 b8 29 18 80 00 00 	movabs $0x801829,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801f73:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f76:	ba 07 00 00 00       	mov    $0x7,%edx
  801f7b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801f80:	89 c7                	mov    %eax,%edi
  801f82:	48 b8 29 18 80 00 00 	movabs $0x801829,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  801f8e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f91:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f97:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  801f9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fa6:	89 c7                	mov    %eax,%edi
  801fa8:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  801faf:	00 00 00 
  801fb2:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  801fb4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fb9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fbe:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fc3:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  801fca:	00 00 00 
  801fcd:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  801fcf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fd4:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd9:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  801fe5:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801fec:	00 00 00 
  801fef:	48 8b 00             	mov    (%rax),%rax
  801ff2:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  801ff9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ffc:	48 89 d6             	mov    %rdx,%rsi
  801fff:	89 c7                	mov    %eax,%edi
  802001:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  802008:	00 00 00 
  80200b:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  80200d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802010:	be 02 00 00 00       	mov    $0x2,%esi
  802015:	89 c7                	mov    %eax,%edi
  802017:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax

	return envid;
  802023:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  802026:	c9                   	leaveq 
  802027:	c3                   	retq   

0000000000802028 <sfork>:

// Challenge!
int
sfork(void)
{
  802028:	55                   	push   %rbp
  802029:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80202c:	48 ba 33 28 80 00 00 	movabs $0x802833,%rdx
  802033:	00 00 00 
  802036:	be b8 00 00 00       	mov    $0xb8,%esi
  80203b:	48 bf 7d 27 80 00 00 	movabs $0x80277d,%rdi
  802042:	00 00 00 
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
  80204a:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  802051:	00 00 00 
  802054:	ff d1                	callq  *%rcx

0000000000802056 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802056:	55                   	push   %rbp
  802057:	48 89 e5             	mov    %rsp,%rbp
  80205a:	53                   	push   %rbx
  80205b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802062:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802069:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80206f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802076:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80207d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802084:	84 c0                	test   %al,%al
  802086:	74 23                	je     8020ab <_panic+0x55>
  802088:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80208f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802093:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802097:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80209b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80209f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8020a3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8020a7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8020ab:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8020b2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8020b9:	00 00 00 
  8020bc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8020c3:	00 00 00 
  8020c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020ca:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8020d1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8020d8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020df:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8020e6:	00 00 00 
  8020e9:	48 8b 18             	mov    (%rax),%rbx
  8020ec:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	callq  *%rax
  8020f8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8020fe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802105:	41 89 c8             	mov    %ecx,%r8d
  802108:	48 89 d1             	mov    %rdx,%rcx
  80210b:	48 89 da             	mov    %rbx,%rdx
  80210e:	89 c6                	mov    %eax,%esi
  802110:	48 bf 50 28 80 00 00 	movabs $0x802850,%rdi
  802117:	00 00 00 
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
  80211f:	49 b9 32 03 80 00 00 	movabs $0x800332,%r9
  802126:	00 00 00 
  802129:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80212c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802133:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80213a:	48 89 d6             	mov    %rdx,%rsi
  80213d:	48 89 c7             	mov    %rax,%rdi
  802140:	48 b8 86 02 80 00 00 	movabs $0x800286,%rax
  802147:	00 00 00 
  80214a:	ff d0                	callq  *%rax
	cprintf("\n");
  80214c:	48 bf 73 28 80 00 00 	movabs $0x802873,%rdi
  802153:	00 00 00 
  802156:	b8 00 00 00 00       	mov    $0x0,%eax
  80215b:	48 ba 32 03 80 00 00 	movabs $0x800332,%rdx
  802162:	00 00 00 
  802165:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802167:	cc                   	int3   
  802168:	eb fd                	jmp    802167 <_panic+0x111>

000000000080216a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80216a:	55                   	push   %rbp
  80216b:	48 89 e5             	mov    %rsp,%rbp
  80216e:	48 83 ec 10          	sub    $0x10,%rsp
  802172:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  802176:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  80217d:	00 00 00 
  802180:	48 8b 00             	mov    (%rax),%rax
  802183:	48 85 c0             	test   %rax,%rax
  802186:	75 49                	jne    8021d1 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  802188:	ba 07 00 00 00       	mov    $0x7,%edx
  80218d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802192:	bf 00 00 00 00       	mov    $0x0,%edi
  802197:	48 b8 29 18 80 00 00 	movabs $0x801829,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	79 2a                	jns    8021d1 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8021a7:	48 ba 78 28 80 00 00 	movabs $0x802878,%rdx
  8021ae:	00 00 00 
  8021b1:	be 21 00 00 00       	mov    $0x21,%esi
  8021b6:	48 bf a3 28 80 00 00 	movabs $0x8028a3,%rdi
  8021bd:	00 00 00 
  8021c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c5:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  8021cc:	00 00 00 
  8021cf:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021d1:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8021d8:	00 00 00 
  8021db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021df:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8021e2:	48 be 2d 22 80 00 00 	movabs $0x80222d,%rsi
  8021e9:	00 00 00 
  8021ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f1:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	79 2a                	jns    80222b <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  802201:	48 ba b8 28 80 00 00 	movabs $0x8028b8,%rdx
  802208:	00 00 00 
  80220b:	be 27 00 00 00       	mov    $0x27,%esi
  802210:	48 bf a3 28 80 00 00 	movabs $0x8028a3,%rdi
  802217:	00 00 00 
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
  80221f:	48 b9 56 20 80 00 00 	movabs $0x802056,%rcx
  802226:	00 00 00 
  802229:	ff d1                	callq  *%rcx
}
  80222b:	c9                   	leaveq 
  80222c:	c3                   	retq   

000000000080222d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80222d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  802230:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  802237:	00 00 00 
call *%rax
  80223a:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  80223c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802243:	00 
    movq 152(%rsp), %rcx
  802244:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80224b:	00 
    subq $8, %rcx
  80224c:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  802250:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  802253:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80225a:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  80225b:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  80225f:	4c 8b 3c 24          	mov    (%rsp),%r15
  802263:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802268:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80226d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802272:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802277:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80227c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802281:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802286:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80228b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802290:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802295:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80229a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80229f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8022a4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8022a9:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  8022ad:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  8022b1:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  8022b2:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  8022b3:	c3                   	retq   
