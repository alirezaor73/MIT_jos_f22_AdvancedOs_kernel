
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
  80005b:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
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
  80007e:	48 ba 40 3e 80 00 00 	movabs $0x803e40,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 b9 0d 80 00 00 	movabs $0x800db9,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
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
  8000df:	48 b8 b9 17 80 00 00 	movabs $0x8017b9,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf 45 3e 80 00 00 	movabs $0x803e45,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 3e 03 80 00 00 	movabs $0x80033e,%rcx
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
  80014d:	48 bf 56 3e 80 00 00 	movabs $0x803e56,%rdi
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800174:	48 b8 b9 17 80 00 00 	movabs $0x8017b9,%rax
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
  8001a9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001b0:	00 00 00 
  8001b3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001ba:	7e 14                	jle    8001d0 <libmain+0x6b>
		binaryname = argv[0];
  8001bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001c0:	48 8b 10             	mov    (%rax),%rdx
  8001c3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
	close_all();
  8001fa:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  800201:	00 00 00 
  800204:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800206:	bf 00 00 00 00       	mov    $0x0,%edi
  80020b:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax
}
  800217:	5d                   	pop    %rbp
  800218:	c3                   	retq   

0000000000800219 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800219:	55                   	push   %rbp
  80021a:	48 89 e5             	mov    %rsp,%rbp
  80021d:	48 83 ec 10          	sub    $0x10,%rsp
  800221:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800224:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	8b 00                	mov    (%rax),%eax
  80022e:	8d 48 01             	lea    0x1(%rax),%ecx
  800231:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800235:	89 0a                	mov    %ecx,(%rdx)
  800237:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80023a:	89 d1                	mov    %edx,%ecx
  80023c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800240:	48 98                	cltq   
  800242:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024a:	8b 00                	mov    (%rax),%eax
  80024c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800251:	75 2c                	jne    80027f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800257:	8b 00                	mov    (%rax),%eax
  800259:	48 98                	cltq   
  80025b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80025f:	48 83 c2 08          	add    $0x8,%rdx
  800263:	48 89 c6             	mov    %rax,%rsi
  800266:	48 89 d7             	mov    %rdx,%rdi
  800269:	48 b8 ed 16 80 00 00 	movabs $0x8016ed,%rax
  800270:	00 00 00 
  800273:	ff d0                	callq  *%rax
        b->idx = 0;
  800275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800279:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80027f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800283:	8b 40 04             	mov    0x4(%rax),%eax
  800286:	8d 50 01             	lea    0x1(%rax),%edx
  800289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80028d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800290:	c9                   	leaveq 
  800291:	c3                   	retq   

0000000000800292 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800292:	55                   	push   %rbp
  800293:	48 89 e5             	mov    %rsp,%rbp
  800296:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80029d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002a4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002ab:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002b2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b9:	48 8b 0a             	mov    (%rdx),%rcx
  8002bc:	48 89 08             	mov    %rcx,(%rax)
  8002bf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002c3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002cb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d6:	00 00 00 
    b.cnt = 0;
  8002d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002e0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002e3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002ea:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f8:	48 89 c6             	mov    %rax,%rsi
  8002fb:	48 bf 19 02 80 00 00 	movabs $0x800219,%rdi
  800302:	00 00 00 
  800305:	48 b8 f1 06 80 00 00 	movabs $0x8006f1,%rax
  80030c:	00 00 00 
  80030f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800311:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800317:	48 98                	cltq   
  800319:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800320:	48 83 c2 08          	add    $0x8,%rdx
  800324:	48 89 c6             	mov    %rax,%rsi
  800327:	48 89 d7             	mov    %rdx,%rdi
  80032a:	48 b8 ed 16 80 00 00 	movabs $0x8016ed,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800336:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80033c:	c9                   	leaveq 
  80033d:	c3                   	retq   

000000000080033e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80033e:	55                   	push   %rbp
  80033f:	48 89 e5             	mov    %rsp,%rbp
  800342:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800349:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800350:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800357:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80035e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800365:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80036c:	84 c0                	test   %al,%al
  80036e:	74 20                	je     800390 <cprintf+0x52>
  800370:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800374:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800378:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80037c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800380:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800384:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800388:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80038c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800390:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800397:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80039e:	00 00 00 
  8003a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a8:	00 00 00 
  8003ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003c4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003cb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003d2:	48 8b 0a             	mov    (%rdx),%rcx
  8003d5:	48 89 08             	mov    %rcx,(%rax)
  8003d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003e8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003ef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f6:	48 89 d6             	mov    %rdx,%rsi
  8003f9:	48 89 c7             	mov    %rax,%rdi
  8003fc:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  800403:	00 00 00 
  800406:	ff d0                	callq  *%rax
  800408:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80040e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800414:	c9                   	leaveq 
  800415:	c3                   	retq   

0000000000800416 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800416:	55                   	push   %rbp
  800417:	48 89 e5             	mov    %rsp,%rbp
  80041a:	53                   	push   %rbx
  80041b:	48 83 ec 38          	sub    $0x38,%rsp
  80041f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800423:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800427:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80042e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800432:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800436:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800439:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80043d:	77 3b                	ja     80047a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800442:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800446:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80044d:	ba 00 00 00 00       	mov    $0x0,%edx
  800452:	48 f7 f3             	div    %rbx
  800455:	48 89 c2             	mov    %rax,%rdx
  800458:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80045b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80045e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800466:	41 89 f9             	mov    %edi,%r9d
  800469:	48 89 c7             	mov    %rax,%rdi
  80046c:	48 b8 16 04 80 00 00 	movabs $0x800416,%rax
  800473:	00 00 00 
  800476:	ff d0                	callq  *%rax
  800478:	eb 1e                	jmp    800498 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80047a:	eb 12                	jmp    80048e <printnum+0x78>
			putch(padc, putdat);
  80047c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800480:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800487:	48 89 ce             	mov    %rcx,%rsi
  80048a:	89 d7                	mov    %edx,%edi
  80048c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800492:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800496:	7f e4                	jg     80047c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800498:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80049b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a4:	48 f7 f1             	div    %rcx
  8004a7:	48 89 d0             	mov    %rdx,%rax
  8004aa:	48 ba 70 40 80 00 00 	movabs $0x804070,%rdx
  8004b1:	00 00 00 
  8004b4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004b8:	0f be d0             	movsbl %al,%edx
  8004bb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c3:	48 89 ce             	mov    %rcx,%rsi
  8004c6:	89 d7                	mov    %edx,%edi
  8004c8:	ff d0                	callq  *%rax
}
  8004ca:	48 83 c4 38          	add    $0x38,%rsp
  8004ce:	5b                   	pop    %rbx
  8004cf:	5d                   	pop    %rbp
  8004d0:	c3                   	retq   

00000000008004d1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004d1:	55                   	push   %rbp
  8004d2:	48 89 e5             	mov    %rsp,%rbp
  8004d5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004dd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8004e0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004e4:	7e 52                	jle    800538 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ea:	8b 00                	mov    (%rax),%eax
  8004ec:	83 f8 30             	cmp    $0x30,%eax
  8004ef:	73 24                	jae    800515 <getuint+0x44>
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fd:	8b 00                	mov    (%rax),%eax
  8004ff:	89 c0                	mov    %eax,%eax
  800501:	48 01 d0             	add    %rdx,%rax
  800504:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800508:	8b 12                	mov    (%rdx),%edx
  80050a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80050d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800511:	89 0a                	mov    %ecx,(%rdx)
  800513:	eb 17                	jmp    80052c <getuint+0x5b>
  800515:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800519:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80051d:	48 89 d0             	mov    %rdx,%rax
  800520:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800524:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800528:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80052c:	48 8b 00             	mov    (%rax),%rax
  80052f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800533:	e9 a3 00 00 00       	jmpq   8005db <getuint+0x10a>
	else if (lflag)
  800538:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80053c:	74 4f                	je     80058d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80053e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800542:	8b 00                	mov    (%rax),%eax
  800544:	83 f8 30             	cmp    $0x30,%eax
  800547:	73 24                	jae    80056d <getuint+0x9c>
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	8b 00                	mov    (%rax),%eax
  800557:	89 c0                	mov    %eax,%eax
  800559:	48 01 d0             	add    %rdx,%rax
  80055c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800560:	8b 12                	mov    (%rdx),%edx
  800562:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800565:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800569:	89 0a                	mov    %ecx,(%rdx)
  80056b:	eb 17                	jmp    800584 <getuint+0xb3>
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800575:	48 89 d0             	mov    %rdx,%rax
  800578:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800580:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800584:	48 8b 00             	mov    (%rax),%rax
  800587:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058b:	eb 4e                	jmp    8005db <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80058d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800591:	8b 00                	mov    (%rax),%eax
  800593:	83 f8 30             	cmp    $0x30,%eax
  800596:	73 24                	jae    8005bc <getuint+0xeb>
  800598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a4:	8b 00                	mov    (%rax),%eax
  8005a6:	89 c0                	mov    %eax,%eax
  8005a8:	48 01 d0             	add    %rdx,%rax
  8005ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005af:	8b 12                	mov    (%rdx),%edx
  8005b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b8:	89 0a                	mov    %ecx,(%rdx)
  8005ba:	eb 17                	jmp    8005d3 <getuint+0x102>
  8005bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c4:	48 89 d0             	mov    %rdx,%rax
  8005c7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d3:	8b 00                	mov    (%rax),%eax
  8005d5:	89 c0                	mov    %eax,%eax
  8005d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005df:	c9                   	leaveq 
  8005e0:	c3                   	retq   

00000000008005e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e1:	55                   	push   %rbp
  8005e2:	48 89 e5             	mov    %rsp,%rbp
  8005e5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005f0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005f4:	7e 52                	jle    800648 <getint+0x67>
		x=va_arg(*ap, long long);
  8005f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fa:	8b 00                	mov    (%rax),%eax
  8005fc:	83 f8 30             	cmp    $0x30,%eax
  8005ff:	73 24                	jae    800625 <getint+0x44>
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060d:	8b 00                	mov    (%rax),%eax
  80060f:	89 c0                	mov    %eax,%eax
  800611:	48 01 d0             	add    %rdx,%rax
  800614:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800618:	8b 12                	mov    (%rdx),%edx
  80061a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80061d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800621:	89 0a                	mov    %ecx,(%rdx)
  800623:	eb 17                	jmp    80063c <getint+0x5b>
  800625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800629:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80062d:	48 89 d0             	mov    %rdx,%rax
  800630:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800634:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800638:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80063c:	48 8b 00             	mov    (%rax),%rax
  80063f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800643:	e9 a3 00 00 00       	jmpq   8006eb <getint+0x10a>
	else if (lflag)
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80064c:	74 4f                	je     80069d <getint+0xbc>
		x=va_arg(*ap, long);
  80064e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800652:	8b 00                	mov    (%rax),%eax
  800654:	83 f8 30             	cmp    $0x30,%eax
  800657:	73 24                	jae    80067d <getint+0x9c>
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800665:	8b 00                	mov    (%rax),%eax
  800667:	89 c0                	mov    %eax,%eax
  800669:	48 01 d0             	add    %rdx,%rax
  80066c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800670:	8b 12                	mov    (%rdx),%edx
  800672:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800679:	89 0a                	mov    %ecx,(%rdx)
  80067b:	eb 17                	jmp    800694 <getint+0xb3>
  80067d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800681:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800685:	48 89 d0             	mov    %rdx,%rax
  800688:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800690:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800694:	48 8b 00             	mov    (%rax),%rax
  800697:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069b:	eb 4e                	jmp    8006eb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80069d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a1:	8b 00                	mov    (%rax),%eax
  8006a3:	83 f8 30             	cmp    $0x30,%eax
  8006a6:	73 24                	jae    8006cc <getint+0xeb>
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	8b 00                	mov    (%rax),%eax
  8006b6:	89 c0                	mov    %eax,%eax
  8006b8:	48 01 d0             	add    %rdx,%rax
  8006bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bf:	8b 12                	mov    (%rdx),%edx
  8006c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	89 0a                	mov    %ecx,(%rdx)
  8006ca:	eb 17                	jmp    8006e3 <getint+0x102>
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d4:	48 89 d0             	mov    %rdx,%rax
  8006d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e3:	8b 00                	mov    (%rax),%eax
  8006e5:	48 98                	cltq   
  8006e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006ef:	c9                   	leaveq 
  8006f0:	c3                   	retq   

00000000008006f1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f1:	55                   	push   %rbp
  8006f2:	48 89 e5             	mov    %rsp,%rbp
  8006f5:	41 54                	push   %r12
  8006f7:	53                   	push   %rbx
  8006f8:	48 83 ec 60          	sub    $0x60,%rsp
  8006fc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800700:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800704:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800708:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80070c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800710:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800714:	48 8b 0a             	mov    (%rdx),%rcx
  800717:	48 89 08             	mov    %rcx,(%rax)
  80071a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80071e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800722:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800726:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072a:	eb 17                	jmp    800743 <vprintfmt+0x52>
			if (ch == '\0')
  80072c:	85 db                	test   %ebx,%ebx
  80072e:	0f 84 df 04 00 00    	je     800c13 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800734:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800738:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80073c:	48 89 d6             	mov    %rdx,%rsi
  80073f:	89 df                	mov    %ebx,%edi
  800741:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800743:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800747:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80074b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80074f:	0f b6 00             	movzbl (%rax),%eax
  800752:	0f b6 d8             	movzbl %al,%ebx
  800755:	83 fb 25             	cmp    $0x25,%ebx
  800758:	75 d2                	jne    80072c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80075a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80075e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800765:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800773:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80077e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800782:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800786:	0f b6 00             	movzbl (%rax),%eax
  800789:	0f b6 d8             	movzbl %al,%ebx
  80078c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80078f:	83 f8 55             	cmp    $0x55,%eax
  800792:	0f 87 47 04 00 00    	ja     800bdf <vprintfmt+0x4ee>
  800798:	89 c0                	mov    %eax,%eax
  80079a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007a1:	00 
  8007a2:	48 b8 98 40 80 00 00 	movabs $0x804098,%rax
  8007a9:	00 00 00 
  8007ac:	48 01 d0             	add    %rdx,%rax
  8007af:	48 8b 00             	mov    (%rax),%rax
  8007b2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007b4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007b8:	eb c0                	jmp    80077a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ba:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007be:	eb ba                	jmp    80077a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007c7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	c1 e0 02             	shl    $0x2,%eax
  8007cf:	01 d0                	add    %edx,%eax
  8007d1:	01 c0                	add    %eax,%eax
  8007d3:	01 d8                	add    %ebx,%eax
  8007d5:	83 e8 30             	sub    $0x30,%eax
  8007d8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007db:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007df:	0f b6 00             	movzbl (%rax),%eax
  8007e2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e8:	7e 0c                	jle    8007f6 <vprintfmt+0x105>
  8007ea:	83 fb 39             	cmp    $0x39,%ebx
  8007ed:	7f 07                	jg     8007f6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ef:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f4:	eb d1                	jmp    8007c7 <vprintfmt+0xd6>
			goto process_precision;
  8007f6:	eb 58                	jmp    800850 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fb:	83 f8 30             	cmp    $0x30,%eax
  8007fe:	73 17                	jae    800817 <vprintfmt+0x126>
  800800:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800804:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800807:	89 c0                	mov    %eax,%eax
  800809:	48 01 d0             	add    %rdx,%rax
  80080c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80080f:	83 c2 08             	add    $0x8,%edx
  800812:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800815:	eb 0f                	jmp    800826 <vprintfmt+0x135>
  800817:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80081b:	48 89 d0             	mov    %rdx,%rax
  80081e:	48 83 c2 08          	add    $0x8,%rdx
  800822:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800826:	8b 00                	mov    (%rax),%eax
  800828:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80082b:	eb 23                	jmp    800850 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80082d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800831:	79 0c                	jns    80083f <vprintfmt+0x14e>
				width = 0;
  800833:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80083a:	e9 3b ff ff ff       	jmpq   80077a <vprintfmt+0x89>
  80083f:	e9 36 ff ff ff       	jmpq   80077a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800844:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80084b:	e9 2a ff ff ff       	jmpq   80077a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800850:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800854:	79 12                	jns    800868 <vprintfmt+0x177>
				width = precision, precision = -1;
  800856:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800859:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80085c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800863:	e9 12 ff ff ff       	jmpq   80077a <vprintfmt+0x89>
  800868:	e9 0d ff ff ff       	jmpq   80077a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80086d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800871:	e9 04 ff ff ff       	jmpq   80077a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800876:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800879:	83 f8 30             	cmp    $0x30,%eax
  80087c:	73 17                	jae    800895 <vprintfmt+0x1a4>
  80087e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800882:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800885:	89 c0                	mov    %eax,%eax
  800887:	48 01 d0             	add    %rdx,%rax
  80088a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088d:	83 c2 08             	add    $0x8,%edx
  800890:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800893:	eb 0f                	jmp    8008a4 <vprintfmt+0x1b3>
  800895:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800899:	48 89 d0             	mov    %rdx,%rax
  80089c:	48 83 c2 08          	add    $0x8,%rdx
  8008a0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a4:	8b 10                	mov    (%rax),%edx
  8008a6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ae:	48 89 ce             	mov    %rcx,%rsi
  8008b1:	89 d7                	mov    %edx,%edi
  8008b3:	ff d0                	callq  *%rax
			break;
  8008b5:	e9 53 03 00 00       	jmpq   800c0d <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bd:	83 f8 30             	cmp    $0x30,%eax
  8008c0:	73 17                	jae    8008d9 <vprintfmt+0x1e8>
  8008c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c9:	89 c0                	mov    %eax,%eax
  8008cb:	48 01 d0             	add    %rdx,%rax
  8008ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d1:	83 c2 08             	add    $0x8,%edx
  8008d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008d7:	eb 0f                	jmp    8008e8 <vprintfmt+0x1f7>
  8008d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008dd:	48 89 d0             	mov    %rdx,%rax
  8008e0:	48 83 c2 08          	add    $0x8,%rdx
  8008e4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008e8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008ea:	85 db                	test   %ebx,%ebx
  8008ec:	79 02                	jns    8008f0 <vprintfmt+0x1ff>
				err = -err;
  8008ee:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008f0:	83 fb 15             	cmp    $0x15,%ebx
  8008f3:	7f 16                	jg     80090b <vprintfmt+0x21a>
  8008f5:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  8008fc:	00 00 00 
  8008ff:	48 63 d3             	movslq %ebx,%rdx
  800902:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800906:	4d 85 e4             	test   %r12,%r12
  800909:	75 2e                	jne    800939 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80090b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80090f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800913:	89 d9                	mov    %ebx,%ecx
  800915:	48 ba 81 40 80 00 00 	movabs $0x804081,%rdx
  80091c:	00 00 00 
  80091f:	48 89 c7             	mov    %rax,%rdi
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
  800927:	49 b8 1c 0c 80 00 00 	movabs $0x800c1c,%r8
  80092e:	00 00 00 
  800931:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800934:	e9 d4 02 00 00       	jmpq   800c0d <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800939:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80093d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800941:	4c 89 e1             	mov    %r12,%rcx
  800944:	48 ba 8a 40 80 00 00 	movabs $0x80408a,%rdx
  80094b:	00 00 00 
  80094e:	48 89 c7             	mov    %rax,%rdi
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
  800956:	49 b8 1c 0c 80 00 00 	movabs $0x800c1c,%r8
  80095d:	00 00 00 
  800960:	41 ff d0             	callq  *%r8
			break;
  800963:	e9 a5 02 00 00       	jmpq   800c0d <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800968:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096b:	83 f8 30             	cmp    $0x30,%eax
  80096e:	73 17                	jae    800987 <vprintfmt+0x296>
  800970:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800974:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800977:	89 c0                	mov    %eax,%eax
  800979:	48 01 d0             	add    %rdx,%rax
  80097c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097f:	83 c2 08             	add    $0x8,%edx
  800982:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800985:	eb 0f                	jmp    800996 <vprintfmt+0x2a5>
  800987:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098b:	48 89 d0             	mov    %rdx,%rax
  80098e:	48 83 c2 08          	add    $0x8,%rdx
  800992:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800996:	4c 8b 20             	mov    (%rax),%r12
  800999:	4d 85 e4             	test   %r12,%r12
  80099c:	75 0a                	jne    8009a8 <vprintfmt+0x2b7>
				p = "(null)";
  80099e:	49 bc 8d 40 80 00 00 	movabs $0x80408d,%r12
  8009a5:	00 00 00 
			if (width > 0 && padc != '-')
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ac:	7e 3f                	jle    8009ed <vprintfmt+0x2fc>
  8009ae:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009b2:	74 39                	je     8009ed <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b7:	48 98                	cltq   
  8009b9:	48 89 c6             	mov    %rax,%rsi
  8009bc:	4c 89 e7             	mov    %r12,%rdi
  8009bf:	48 b8 c8 0e 80 00 00 	movabs $0x800ec8,%rax
  8009c6:	00 00 00 
  8009c9:	ff d0                	callq  *%rax
  8009cb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009ce:	eb 17                	jmp    8009e7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009d0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009d4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009dc:	48 89 ce             	mov    %rcx,%rsi
  8009df:	89 d7                	mov    %edx,%edi
  8009e1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009eb:	7f e3                	jg     8009d0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ed:	eb 37                	jmp    800a26 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009f3:	74 1e                	je     800a13 <vprintfmt+0x322>
  8009f5:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f8:	7e 05                	jle    8009ff <vprintfmt+0x30e>
  8009fa:	83 fb 7e             	cmp    $0x7e,%ebx
  8009fd:	7e 14                	jle    800a13 <vprintfmt+0x322>
					putch('?', putdat);
  8009ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a07:	48 89 d6             	mov    %rdx,%rsi
  800a0a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a0f:	ff d0                	callq  *%rax
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1b:	48 89 d6             	mov    %rdx,%rsi
  800a1e:	89 df                	mov    %ebx,%edi
  800a20:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a26:	4c 89 e0             	mov    %r12,%rax
  800a29:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a2d:	0f b6 00             	movzbl (%rax),%eax
  800a30:	0f be d8             	movsbl %al,%ebx
  800a33:	85 db                	test   %ebx,%ebx
  800a35:	74 10                	je     800a47 <vprintfmt+0x356>
  800a37:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a3b:	78 b2                	js     8009ef <vprintfmt+0x2fe>
  800a3d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a41:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a45:	79 a8                	jns    8009ef <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x36e>
				putch(' ', putdat);
  800a49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a51:	48 89 d6             	mov    %rdx,%rsi
  800a54:	bf 20 00 00 00       	mov    $0x20,%edi
  800a59:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a5b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a65:	e9 a3 01 00 00       	jmpq   800c0d <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a6a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6e:	be 03 00 00 00       	mov    $0x3,%esi
  800a73:	48 89 c7             	mov    %rax,%rdi
  800a76:	48 b8 e1 05 80 00 00 	movabs $0x8005e1,%rax
  800a7d:	00 00 00 
  800a80:	ff d0                	callq  *%rax
  800a82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 85 c0             	test   %rax,%rax
  800a8d:	79 1d                	jns    800aac <vprintfmt+0x3bb>
				putch('-', putdat);
  800a8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a97:	48 89 d6             	mov    %rdx,%rsi
  800a9a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a9f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa5:	48 f7 d8             	neg    %rax
  800aa8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800aac:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab3:	e9 e8 00 00 00       	jmpq   800ba0 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ab8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abc:	be 03 00 00 00       	mov    $0x3,%esi
  800ac1:	48 89 c7             	mov    %rax,%rdi
  800ac4:	48 b8 d1 04 80 00 00 	movabs $0x8004d1,%rax
  800acb:	00 00 00 
  800ace:	ff d0                	callq  *%rax
  800ad0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ad4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800adb:	e9 c0 00 00 00       	jmpq   800ba0 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae8:	48 89 d6             	mov    %rdx,%rsi
  800aeb:	bf 58 00 00 00       	mov    $0x58,%edi
  800af0:	ff d0                	callq  *%rax
			putch('X', putdat);
  800af2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afa:	48 89 d6             	mov    %rdx,%rsi
  800afd:	bf 58 00 00 00       	mov    $0x58,%edi
  800b02:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0c:	48 89 d6             	mov    %rdx,%rsi
  800b0f:	bf 58 00 00 00       	mov    $0x58,%edi
  800b14:	ff d0                	callq  *%rax
			break;
  800b16:	e9 f2 00 00 00       	jmpq   800c0d <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800b1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b23:	48 89 d6             	mov    %rdx,%rsi
  800b26:	bf 30 00 00 00       	mov    $0x30,%edi
  800b2b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b35:	48 89 d6             	mov    %rdx,%rsi
  800b38:	bf 78 00 00 00       	mov    $0x78,%edi
  800b3d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b42:	83 f8 30             	cmp    $0x30,%eax
  800b45:	73 17                	jae    800b5e <vprintfmt+0x46d>
  800b47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4e:	89 c0                	mov    %eax,%eax
  800b50:	48 01 d0             	add    %rdx,%rax
  800b53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b56:	83 c2 08             	add    $0x8,%edx
  800b59:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	eb 0f                	jmp    800b6d <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800b5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b62:	48 89 d0             	mov    %rdx,%rax
  800b65:	48 83 c2 08          	add    $0x8,%rdx
  800b69:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b6d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b7b:	eb 23                	jmp    800ba0 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b81:	be 03 00 00 00       	mov    $0x3,%esi
  800b86:	48 89 c7             	mov    %rax,%rdi
  800b89:	48 b8 d1 04 80 00 00 	movabs $0x8004d1,%rax
  800b90:	00 00 00 
  800b93:	ff d0                	callq  *%rax
  800b95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b99:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ba0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ba5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ba8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800baf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb7:	45 89 c1             	mov    %r8d,%r9d
  800bba:	41 89 f8             	mov    %edi,%r8d
  800bbd:	48 89 c7             	mov    %rax,%rdi
  800bc0:	48 b8 16 04 80 00 00 	movabs $0x800416,%rax
  800bc7:	00 00 00 
  800bca:	ff d0                	callq  *%rax
			break;
  800bcc:	eb 3f                	jmp    800c0d <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd6:	48 89 d6             	mov    %rdx,%rsi
  800bd9:	89 df                	mov    %ebx,%edi
  800bdb:	ff d0                	callq  *%rax
			break;
  800bdd:	eb 2e                	jmp    800c0d <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be7:	48 89 d6             	mov    %rdx,%rsi
  800bea:	bf 25 00 00 00       	mov    $0x25,%edi
  800bef:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bf6:	eb 05                	jmp    800bfd <vprintfmt+0x50c>
  800bf8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bfd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c01:	48 83 e8 01          	sub    $0x1,%rax
  800c05:	0f b6 00             	movzbl (%rax),%eax
  800c08:	3c 25                	cmp    $0x25,%al
  800c0a:	75 ec                	jne    800bf8 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800c0c:	90                   	nop
		}
	}
  800c0d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0e:	e9 30 fb ff ff       	jmpq   800743 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c13:	48 83 c4 60          	add    $0x60,%rsp
  800c17:	5b                   	pop    %rbx
  800c18:	41 5c                	pop    %r12
  800c1a:	5d                   	pop    %rbp
  800c1b:	c3                   	retq   

0000000000800c1c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c1c:	55                   	push   %rbp
  800c1d:	48 89 e5             	mov    %rsp,%rbp
  800c20:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c27:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c2e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c35:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c3c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c43:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 20                	je     800c6e <printfmt+0x52>
  800c4e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c52:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c56:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c5a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c5e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c62:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c66:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c6a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c6e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c75:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c7c:	00 00 00 
  800c7f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c86:	00 00 00 
  800c89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c8d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c94:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c9b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ca2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ca9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cb0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cb7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cbe:	48 89 c7             	mov    %rax,%rdi
  800cc1:	48 b8 f1 06 80 00 00 	movabs $0x8006f1,%rax
  800cc8:	00 00 00 
  800ccb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ccd:	c9                   	leaveq 
  800cce:	c3                   	retq   

0000000000800ccf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ccf:	55                   	push   %rbp
  800cd0:	48 89 e5             	mov    %rsp,%rbp
  800cd3:	48 83 ec 10          	sub    $0x10,%rsp
  800cd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce2:	8b 40 10             	mov    0x10(%rax),%eax
  800ce5:	8d 50 01             	lea    0x1(%rax),%edx
  800ce8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cec:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf3:	48 8b 10             	mov    (%rax),%rdx
  800cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cfa:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cfe:	48 39 c2             	cmp    %rax,%rdx
  800d01:	73 17                	jae    800d1a <sprintputch+0x4b>
		*b->buf++ = ch;
  800d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d07:	48 8b 00             	mov    (%rax),%rax
  800d0a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d12:	48 89 0a             	mov    %rcx,(%rdx)
  800d15:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d18:	88 10                	mov    %dl,(%rax)
}
  800d1a:	c9                   	leaveq 
  800d1b:	c3                   	retq   

0000000000800d1c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d1c:	55                   	push   %rbp
  800d1d:	48 89 e5             	mov    %rsp,%rbp
  800d20:	48 83 ec 50          	sub    $0x50,%rsp
  800d24:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d28:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d2b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d2f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d33:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d37:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d3b:	48 8b 0a             	mov    (%rdx),%rcx
  800d3e:	48 89 08             	mov    %rcx,(%rax)
  800d41:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d45:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d49:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d4d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d55:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d59:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d5c:	48 98                	cltq   
  800d5e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d66:	48 01 d0             	add    %rdx,%rax
  800d69:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d74:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d79:	74 06                	je     800d81 <vsnprintf+0x65>
  800d7b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d7f:	7f 07                	jg     800d88 <vsnprintf+0x6c>
		return -E_INVAL;
  800d81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d86:	eb 2f                	jmp    800db7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d88:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d8c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d90:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d94:	48 89 c6             	mov    %rax,%rsi
  800d97:	48 bf cf 0c 80 00 00 	movabs $0x800ccf,%rdi
  800d9e:	00 00 00 
  800da1:	48 b8 f1 06 80 00 00 	movabs $0x8006f1,%rax
  800da8:	00 00 00 
  800dab:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800db1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800db4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800db7:	c9                   	leaveq 
  800db8:	c3                   	retq   

0000000000800db9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db9:	55                   	push   %rbp
  800dba:	48 89 e5             	mov    %rsp,%rbp
  800dbd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dc4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800dcb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800dd1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ddf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de6:	84 c0                	test   %al,%al
  800de8:	74 20                	je     800e0a <snprintf+0x51>
  800dea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800df2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dfa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dfe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e02:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e06:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e0a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e11:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e18:	00 00 00 
  800e1b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e22:	00 00 00 
  800e25:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e29:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e30:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e37:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e3e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e45:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e4c:	48 8b 0a             	mov    (%rdx),%rcx
  800e4f:	48 89 08             	mov    %rcx,(%rax)
  800e52:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e56:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e5a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e5e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e62:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e69:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e70:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e76:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e7d:	48 89 c7             	mov    %rax,%rdi
  800e80:	48 b8 1c 0d 80 00 00 	movabs $0x800d1c,%rax
  800e87:	00 00 00 
  800e8a:	ff d0                	callq  *%rax
  800e8c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e92:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e98:	c9                   	leaveq 
  800e99:	c3                   	retq   

0000000000800e9a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e9a:	55                   	push   %rbp
  800e9b:	48 89 e5             	mov    %rsp,%rbp
  800e9e:	48 83 ec 18          	sub    $0x18,%rsp
  800ea2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ead:	eb 09                	jmp    800eb8 <strlen+0x1e>
		n++;
  800eaf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eb3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	0f b6 00             	movzbl (%rax),%eax
  800ebf:	84 c0                	test   %al,%al
  800ec1:	75 ec                	jne    800eaf <strlen+0x15>
		n++;
	return n;
  800ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ec6:	c9                   	leaveq 
  800ec7:	c3                   	retq   

0000000000800ec8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ec8:	55                   	push   %rbp
  800ec9:	48 89 e5             	mov    %rsp,%rbp
  800ecc:	48 83 ec 20          	sub    $0x20,%rsp
  800ed0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800edf:	eb 0e                	jmp    800eef <strnlen+0x27>
		n++;
  800ee1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eea:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ef4:	74 0b                	je     800f01 <strnlen+0x39>
  800ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efa:	0f b6 00             	movzbl (%rax),%eax
  800efd:	84 c0                	test   %al,%al
  800eff:	75 e0                	jne    800ee1 <strnlen+0x19>
		n++;
	return n;
  800f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f04:	c9                   	leaveq 
  800f05:	c3                   	retq   

0000000000800f06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f06:	55                   	push   %rbp
  800f07:	48 89 e5             	mov    %rsp,%rbp
  800f0a:	48 83 ec 20          	sub    $0x20,%rsp
  800f0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f1e:	90                   	nop
  800f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f23:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f27:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f2b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f33:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f37:	0f b6 12             	movzbl (%rdx),%edx
  800f3a:	88 10                	mov    %dl,(%rax)
  800f3c:	0f b6 00             	movzbl (%rax),%eax
  800f3f:	84 c0                	test   %al,%al
  800f41:	75 dc                	jne    800f1f <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f47:	c9                   	leaveq 
  800f48:	c3                   	retq   

0000000000800f49 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f49:	55                   	push   %rbp
  800f4a:	48 89 e5             	mov    %rsp,%rbp
  800f4d:	48 83 ec 20          	sub    $0x20,%rsp
  800f51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5d:	48 89 c7             	mov    %rax,%rdi
  800f60:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  800f67:	00 00 00 
  800f6a:	ff d0                	callq  *%rax
  800f6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f72:	48 63 d0             	movslq %eax,%rdx
  800f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f79:	48 01 c2             	add    %rax,%rdx
  800f7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f80:	48 89 c6             	mov    %rax,%rsi
  800f83:	48 89 d7             	mov    %rdx,%rdi
  800f86:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  800f8d:	00 00 00 
  800f90:	ff d0                	callq  *%rax
	return dst;
  800f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 83 ec 28          	sub    $0x28,%rsp
  800fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fa8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fb4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fbb:	00 
  800fbc:	eb 2a                	jmp    800fe8 <strncpy+0x50>
		*dst++ = *src;
  800fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fc6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fce:	0f b6 12             	movzbl (%rdx),%edx
  800fd1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd7:	0f b6 00             	movzbl (%rax),%eax
  800fda:	84 c0                	test   %al,%al
  800fdc:	74 05                	je     800fe3 <strncpy+0x4b>
			src++;
  800fde:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fe3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ff0:	72 cc                	jb     800fbe <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ff6:	c9                   	leaveq 
  800ff7:	c3                   	retq   

0000000000800ff8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ff8:	55                   	push   %rbp
  800ff9:	48 89 e5             	mov    %rsp,%rbp
  800ffc:	48 83 ec 28          	sub    $0x28,%rsp
  801000:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801004:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801008:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80100c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801010:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801014:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801019:	74 3d                	je     801058 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80101b:	eb 1d                	jmp    80103a <strlcpy+0x42>
			*dst++ = *src++;
  80101d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801021:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801025:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801029:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80102d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801031:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801035:	0f b6 12             	movzbl (%rdx),%edx
  801038:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80103a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80103f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801044:	74 0b                	je     801051 <strlcpy+0x59>
  801046:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	84 c0                	test   %al,%al
  80104f:	75 cc                	jne    80101d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801055:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801058:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801060:	48 29 c2             	sub    %rax,%rdx
  801063:	48 89 d0             	mov    %rdx,%rax
}
  801066:	c9                   	leaveq 
  801067:	c3                   	retq   

0000000000801068 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801068:	55                   	push   %rbp
  801069:	48 89 e5             	mov    %rsp,%rbp
  80106c:	48 83 ec 10          	sub    $0x10,%rsp
  801070:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801074:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801078:	eb 0a                	jmp    801084 <strcmp+0x1c>
		p++, q++;
  80107a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	74 12                	je     8010a1 <strcmp+0x39>
  80108f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801093:	0f b6 10             	movzbl (%rax),%edx
  801096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109a:	0f b6 00             	movzbl (%rax),%eax
  80109d:	38 c2                	cmp    %al,%dl
  80109f:	74 d9                	je     80107a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a5:	0f b6 00             	movzbl (%rax),%eax
  8010a8:	0f b6 d0             	movzbl %al,%edx
  8010ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010af:	0f b6 00             	movzbl (%rax),%eax
  8010b2:	0f b6 c0             	movzbl %al,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
}
  8010b9:	c9                   	leaveq 
  8010ba:	c3                   	retq   

00000000008010bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010bb:	55                   	push   %rbp
  8010bc:	48 89 e5             	mov    %rsp,%rbp
  8010bf:	48 83 ec 18          	sub    $0x18,%rsp
  8010c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010cf:	eb 0f                	jmp    8010e0 <strncmp+0x25>
		n--, p++, q++;
  8010d1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e5:	74 1d                	je     801104 <strncmp+0x49>
  8010e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010eb:	0f b6 00             	movzbl (%rax),%eax
  8010ee:	84 c0                	test   %al,%al
  8010f0:	74 12                	je     801104 <strncmp+0x49>
  8010f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f6:	0f b6 10             	movzbl (%rax),%edx
  8010f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fd:	0f b6 00             	movzbl (%rax),%eax
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 cd                	je     8010d1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801104:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801109:	75 07                	jne    801112 <strncmp+0x57>
		return 0;
  80110b:	b8 00 00 00 00       	mov    $0x0,%eax
  801110:	eb 18                	jmp    80112a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801112:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801116:	0f b6 00             	movzbl (%rax),%eax
  801119:	0f b6 d0             	movzbl %al,%edx
  80111c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801120:	0f b6 00             	movzbl (%rax),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	29 c2                	sub    %eax,%edx
  801128:	89 d0                	mov    %edx,%eax
}
  80112a:	c9                   	leaveq 
  80112b:	c3                   	retq   

000000000080112c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80112c:	55                   	push   %rbp
  80112d:	48 89 e5             	mov    %rsp,%rbp
  801130:	48 83 ec 0c          	sub    $0xc,%rsp
  801134:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801138:	89 f0                	mov    %esi,%eax
  80113a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80113d:	eb 17                	jmp    801156 <strchr+0x2a>
		if (*s == c)
  80113f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801143:	0f b6 00             	movzbl (%rax),%eax
  801146:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801149:	75 06                	jne    801151 <strchr+0x25>
			return (char *) s;
  80114b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114f:	eb 15                	jmp    801166 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801151:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115a:	0f b6 00             	movzbl (%rax),%eax
  80115d:	84 c0                	test   %al,%al
  80115f:	75 de                	jne    80113f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801166:	c9                   	leaveq 
  801167:	c3                   	retq   

0000000000801168 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801168:	55                   	push   %rbp
  801169:	48 89 e5             	mov    %rsp,%rbp
  80116c:	48 83 ec 0c          	sub    $0xc,%rsp
  801170:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801174:	89 f0                	mov    %esi,%eax
  801176:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801179:	eb 13                	jmp    80118e <strfind+0x26>
		if (*s == c)
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117f:	0f b6 00             	movzbl (%rax),%eax
  801182:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801185:	75 02                	jne    801189 <strfind+0x21>
			break;
  801187:	eb 10                	jmp    801199 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801189:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80118e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801192:	0f b6 00             	movzbl (%rax),%eax
  801195:	84 c0                	test   %al,%al
  801197:	75 e2                	jne    80117b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80119d:	c9                   	leaveq 
  80119e:	c3                   	retq   

000000000080119f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 18          	sub    $0x18,%rsp
  8011a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ab:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011b7:	75 06                	jne    8011bf <memset+0x20>
		return v;
  8011b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bd:	eb 69                	jmp    801228 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	83 e0 03             	and    $0x3,%eax
  8011c6:	48 85 c0             	test   %rax,%rax
  8011c9:	75 48                	jne    801213 <memset+0x74>
  8011cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cf:	83 e0 03             	and    $0x3,%eax
  8011d2:	48 85 c0             	test   %rax,%rax
  8011d5:	75 3c                	jne    801213 <memset+0x74>
		c &= 0xFF;
  8011d7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e1:	c1 e0 18             	shl    $0x18,%eax
  8011e4:	89 c2                	mov    %eax,%edx
  8011e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e9:	c1 e0 10             	shl    $0x10,%eax
  8011ec:	09 c2                	or     %eax,%edx
  8011ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f1:	c1 e0 08             	shl    $0x8,%eax
  8011f4:	09 d0                	or     %edx,%eax
  8011f6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fd:	48 c1 e8 02          	shr    $0x2,%rax
  801201:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801204:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801208:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80120b:	48 89 d7             	mov    %rdx,%rdi
  80120e:	fc                   	cld    
  80120f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801211:	eb 11                	jmp    801224 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801213:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801217:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80121a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80121e:	48 89 d7             	mov    %rdx,%rdi
  801221:	fc                   	cld    
  801222:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801228:	c9                   	leaveq 
  801229:	c3                   	retq   

000000000080122a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80122a:	55                   	push   %rbp
  80122b:	48 89 e5             	mov    %rsp,%rbp
  80122e:	48 83 ec 28          	sub    $0x28,%rsp
  801232:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801236:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80123a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80123e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801242:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801246:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80124e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801252:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801256:	0f 83 88 00 00 00    	jae    8012e4 <memmove+0xba>
  80125c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801260:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801264:	48 01 d0             	add    %rdx,%rax
  801267:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80126b:	76 77                	jbe    8012e4 <memmove+0xba>
		s += n;
  80126d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801271:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801275:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801279:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80127d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801281:	83 e0 03             	and    $0x3,%eax
  801284:	48 85 c0             	test   %rax,%rax
  801287:	75 3b                	jne    8012c4 <memmove+0x9a>
  801289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128d:	83 e0 03             	and    $0x3,%eax
  801290:	48 85 c0             	test   %rax,%rax
  801293:	75 2f                	jne    8012c4 <memmove+0x9a>
  801295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801299:	83 e0 03             	and    $0x3,%eax
  80129c:	48 85 c0             	test   %rax,%rax
  80129f:	75 23                	jne    8012c4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a5:	48 83 e8 04          	sub    $0x4,%rax
  8012a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ad:	48 83 ea 04          	sub    $0x4,%rdx
  8012b1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012b5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012b9:	48 89 c7             	mov    %rax,%rdi
  8012bc:	48 89 d6             	mov    %rdx,%rsi
  8012bf:	fd                   	std    
  8012c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012c2:	eb 1d                	jmp    8012e1 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d8:	48 89 d7             	mov    %rdx,%rdi
  8012db:	48 89 c1             	mov    %rax,%rcx
  8012de:	fd                   	std    
  8012df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012e1:	fc                   	cld    
  8012e2:	eb 57                	jmp    80133b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	83 e0 03             	and    $0x3,%eax
  8012eb:	48 85 c0             	test   %rax,%rax
  8012ee:	75 36                	jne    801326 <memmove+0xfc>
  8012f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f4:	83 e0 03             	and    $0x3,%eax
  8012f7:	48 85 c0             	test   %rax,%rax
  8012fa:	75 2a                	jne    801326 <memmove+0xfc>
  8012fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801300:	83 e0 03             	and    $0x3,%eax
  801303:	48 85 c0             	test   %rax,%rax
  801306:	75 1e                	jne    801326 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801308:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130c:	48 c1 e8 02          	shr    $0x2,%rax
  801310:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801317:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80131b:	48 89 c7             	mov    %rax,%rdi
  80131e:	48 89 d6             	mov    %rdx,%rsi
  801321:	fc                   	cld    
  801322:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801324:	eb 15                	jmp    80133b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	48 89 d6             	mov    %rdx,%rsi
  801338:	fc                   	cld    
  801339:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80133f:	c9                   	leaveq 
  801340:	c3                   	retq   

0000000000801341 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801341:	55                   	push   %rbp
  801342:	48 89 e5             	mov    %rsp,%rbp
  801345:	48 83 ec 18          	sub    $0x18,%rsp
  801349:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801351:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801355:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801359:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80135d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801361:	48 89 ce             	mov    %rcx,%rsi
  801364:	48 89 c7             	mov    %rax,%rdi
  801367:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  80136e:	00 00 00 
  801371:	ff d0                	callq  *%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 28          	sub    $0x28,%rsp
  80137d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801381:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801385:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801391:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801395:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801399:	eb 36                	jmp    8013d1 <memcmp+0x5c>
		if (*s1 != *s2)
  80139b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139f:	0f b6 10             	movzbl (%rax),%edx
  8013a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	38 c2                	cmp    %al,%dl
  8013ab:	74 1a                	je     8013c7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	0f b6 d0             	movzbl %al,%edx
  8013b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bb:	0f b6 00             	movzbl (%rax),%eax
  8013be:	0f b6 c0             	movzbl %al,%eax
  8013c1:	29 c2                	sub    %eax,%edx
  8013c3:	89 d0                	mov    %edx,%eax
  8013c5:	eb 20                	jmp    8013e7 <memcmp+0x72>
		s1++, s2++;
  8013c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013dd:	48 85 c0             	test   %rax,%rax
  8013e0:	75 b9                	jne    80139b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e7:	c9                   	leaveq 
  8013e8:	c3                   	retq   

00000000008013e9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013e9:	55                   	push   %rbp
  8013ea:	48 89 e5             	mov    %rsp,%rbp
  8013ed:	48 83 ec 28          	sub    $0x28,%rsp
  8013f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801400:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801404:	48 01 d0             	add    %rdx,%rax
  801407:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80140b:	eb 15                	jmp    801422 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801411:	0f b6 10             	movzbl (%rax),%edx
  801414:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801417:	38 c2                	cmp    %al,%dl
  801419:	75 02                	jne    80141d <memfind+0x34>
			break;
  80141b:	eb 0f                	jmp    80142c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801426:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80142a:	72 e1                	jb     80140d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80142c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801430:	c9                   	leaveq 
  801431:	c3                   	retq   

0000000000801432 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801432:	55                   	push   %rbp
  801433:	48 89 e5             	mov    %rsp,%rbp
  801436:	48 83 ec 34          	sub    $0x34,%rsp
  80143a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80143e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801442:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801445:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80144c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801453:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801454:	eb 05                	jmp    80145b <strtol+0x29>
		s++;
  801456:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80145b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	3c 20                	cmp    $0x20,%al
  801464:	74 f0                	je     801456 <strtol+0x24>
  801466:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	3c 09                	cmp    $0x9,%al
  80146f:	74 e5                	je     801456 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	0f b6 00             	movzbl (%rax),%eax
  801478:	3c 2b                	cmp    $0x2b,%al
  80147a:	75 07                	jne    801483 <strtol+0x51>
		s++;
  80147c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801481:	eb 17                	jmp    80149a <strtol+0x68>
	else if (*s == '-')
  801483:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801487:	0f b6 00             	movzbl (%rax),%eax
  80148a:	3c 2d                	cmp    $0x2d,%al
  80148c:	75 0c                	jne    80149a <strtol+0x68>
		s++, neg = 1;
  80148e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801493:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149e:	74 06                	je     8014a6 <strtol+0x74>
  8014a0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014a4:	75 28                	jne    8014ce <strtol+0x9c>
  8014a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014aa:	0f b6 00             	movzbl (%rax),%eax
  8014ad:	3c 30                	cmp    $0x30,%al
  8014af:	75 1d                	jne    8014ce <strtol+0x9c>
  8014b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b5:	48 83 c0 01          	add    $0x1,%rax
  8014b9:	0f b6 00             	movzbl (%rax),%eax
  8014bc:	3c 78                	cmp    $0x78,%al
  8014be:	75 0e                	jne    8014ce <strtol+0x9c>
		s += 2, base = 16;
  8014c0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014c5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014cc:	eb 2c                	jmp    8014fa <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d2:	75 19                	jne    8014ed <strtol+0xbb>
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	0f b6 00             	movzbl (%rax),%eax
  8014db:	3c 30                	cmp    $0x30,%al
  8014dd:	75 0e                	jne    8014ed <strtol+0xbb>
		s++, base = 8;
  8014df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014e4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014eb:	eb 0d                	jmp    8014fa <strtol+0xc8>
	else if (base == 0)
  8014ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014f1:	75 07                	jne    8014fa <strtol+0xc8>
		base = 10;
  8014f3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	3c 2f                	cmp    $0x2f,%al
  801503:	7e 1d                	jle    801522 <strtol+0xf0>
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	3c 39                	cmp    $0x39,%al
  80150e:	7f 12                	jg     801522 <strtol+0xf0>
			dig = *s - '0';
  801510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801514:	0f b6 00             	movzbl (%rax),%eax
  801517:	0f be c0             	movsbl %al,%eax
  80151a:	83 e8 30             	sub    $0x30,%eax
  80151d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801520:	eb 4e                	jmp    801570 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801526:	0f b6 00             	movzbl (%rax),%eax
  801529:	3c 60                	cmp    $0x60,%al
  80152b:	7e 1d                	jle    80154a <strtol+0x118>
  80152d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	3c 7a                	cmp    $0x7a,%al
  801536:	7f 12                	jg     80154a <strtol+0x118>
			dig = *s - 'a' + 10;
  801538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	0f be c0             	movsbl %al,%eax
  801542:	83 e8 57             	sub    $0x57,%eax
  801545:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801548:	eb 26                	jmp    801570 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80154a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	3c 40                	cmp    $0x40,%al
  801553:	7e 48                	jle    80159d <strtol+0x16b>
  801555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801559:	0f b6 00             	movzbl (%rax),%eax
  80155c:	3c 5a                	cmp    $0x5a,%al
  80155e:	7f 3d                	jg     80159d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	0f b6 00             	movzbl (%rax),%eax
  801567:	0f be c0             	movsbl %al,%eax
  80156a:	83 e8 37             	sub    $0x37,%eax
  80156d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801570:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801573:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801576:	7c 02                	jl     80157a <strtol+0x148>
			break;
  801578:	eb 23                	jmp    80159d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80157a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801582:	48 98                	cltq   
  801584:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801589:	48 89 c2             	mov    %rax,%rdx
  80158c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80158f:	48 98                	cltq   
  801591:	48 01 d0             	add    %rdx,%rax
  801594:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801598:	e9 5d ff ff ff       	jmpq   8014fa <strtol+0xc8>

	if (endptr)
  80159d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015a2:	74 0b                	je     8015af <strtol+0x17d>
		*endptr = (char *) s;
  8015a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015ac:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015b3:	74 09                	je     8015be <strtol+0x18c>
  8015b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b9:	48 f7 d8             	neg    %rax
  8015bc:	eb 04                	jmp    8015c2 <strtol+0x190>
  8015be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015c2:	c9                   	leaveq 
  8015c3:	c3                   	retq   

00000000008015c4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015c4:	55                   	push   %rbp
  8015c5:	48 89 e5             	mov    %rsp,%rbp
  8015c8:	48 83 ec 30          	sub    $0x30,%rsp
  8015cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015e6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015ea:	75 06                	jne    8015f2 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	eb 6b                	jmp    80165d <strstr+0x99>

	len = strlen(str);
  8015f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015f6:	48 89 c7             	mov    %rax,%rdi
  8015f9:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  801600:	00 00 00 
  801603:	ff d0                	callq  *%rax
  801605:	48 98                	cltq   
  801607:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80160b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801613:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80161d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801621:	75 07                	jne    80162a <strstr+0x66>
				return (char *) 0;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
  801628:	eb 33                	jmp    80165d <strstr+0x99>
		} while (sc != c);
  80162a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80162e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801631:	75 d8                	jne    80160b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801633:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801637:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	48 89 ce             	mov    %rcx,%rsi
  801642:	48 89 c7             	mov    %rax,%rdi
  801645:	48 b8 bb 10 80 00 00 	movabs $0x8010bb,%rax
  80164c:	00 00 00 
  80164f:	ff d0                	callq  *%rax
  801651:	85 c0                	test   %eax,%eax
  801653:	75 b6                	jne    80160b <strstr+0x47>

	return (char *) (in - 1);
  801655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801659:	48 83 e8 01          	sub    $0x1,%rax
}
  80165d:	c9                   	leaveq 
  80165e:	c3                   	retq   

000000000080165f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80165f:	55                   	push   %rbp
  801660:	48 89 e5             	mov    %rsp,%rbp
  801663:	53                   	push   %rbx
  801664:	48 83 ec 48          	sub    $0x48,%rsp
  801668:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80166b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80166e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801672:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801676:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80167a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80167e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801681:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801685:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801689:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80168d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801691:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801695:	4c 89 c3             	mov    %r8,%rbx
  801698:	cd 30                	int    $0x30
  80169a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80169e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016a2:	74 3e                	je     8016e2 <syscall+0x83>
  8016a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a9:	7e 37                	jle    8016e2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016b2:	49 89 d0             	mov    %rdx,%r8
  8016b5:	89 c1                	mov    %eax,%ecx
  8016b7:	48 ba 48 43 80 00 00 	movabs $0x804348,%rdx
  8016be:	00 00 00 
  8016c1:	be 23 00 00 00       	mov    $0x23,%esi
  8016c6:	48 bf 65 43 80 00 00 	movabs $0x804365,%rdi
  8016cd:	00 00 00 
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d5:	49 b9 71 39 80 00 00 	movabs $0x803971,%r9
  8016dc:	00 00 00 
  8016df:	41 ff d1             	callq  *%r9

	return ret;
  8016e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e6:	48 83 c4 48          	add    $0x48,%rsp
  8016ea:	5b                   	pop    %rbx
  8016eb:	5d                   	pop    %rbp
  8016ec:	c3                   	retq   

00000000008016ed <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	48 83 ec 20          	sub    $0x20,%rsp
  8016f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801701:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801705:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80170c:	00 
  80170d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801713:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801719:	48 89 d1             	mov    %rdx,%rcx
  80171c:	48 89 c2             	mov    %rax,%rdx
  80171f:	be 00 00 00 00       	mov    $0x0,%esi
  801724:	bf 00 00 00 00       	mov    $0x0,%edi
  801729:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  801730:	00 00 00 
  801733:	ff d0                	callq  *%rax
}
  801735:	c9                   	leaveq 
  801736:	c3                   	retq   

0000000000801737 <sys_cgetc>:

int
sys_cgetc(void)
{
  801737:	55                   	push   %rbp
  801738:	48 89 e5             	mov    %rsp,%rbp
  80173b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80173f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801746:	00 
  801747:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80174d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801753:	b9 00 00 00 00       	mov    $0x0,%ecx
  801758:	ba 00 00 00 00       	mov    $0x0,%edx
  80175d:	be 00 00 00 00       	mov    $0x0,%esi
  801762:	bf 01 00 00 00       	mov    $0x1,%edi
  801767:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
}
  801773:	c9                   	leaveq 
  801774:	c3                   	retq   

0000000000801775 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	48 83 ec 10          	sub    $0x10,%rsp
  80177d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801783:	48 98                	cltq   
  801785:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178c:	00 
  80178d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801793:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801799:	b9 00 00 00 00       	mov    $0x0,%ecx
  80179e:	48 89 c2             	mov    %rax,%rdx
  8017a1:	be 01 00 00 00       	mov    $0x1,%esi
  8017a6:	bf 03 00 00 00       	mov    $0x3,%edi
  8017ab:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  8017b2:	00 00 00 
  8017b5:	ff d0                	callq  *%rax
}
  8017b7:	c9                   	leaveq 
  8017b8:	c3                   	retq   

00000000008017b9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017b9:	55                   	push   %rbp
  8017ba:	48 89 e5             	mov    %rsp,%rbp
  8017bd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c8:	00 
  8017c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	be 00 00 00 00       	mov    $0x0,%esi
  8017e4:	bf 02 00 00 00       	mov    $0x2,%edi
  8017e9:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
}
  8017f5:	c9                   	leaveq 
  8017f6:	c3                   	retq   

00000000008017f7 <sys_yield>:

void
sys_yield(void)
{
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801806:	00 
  801807:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801813:	b9 00 00 00 00       	mov    $0x0,%ecx
  801818:	ba 00 00 00 00       	mov    $0x0,%edx
  80181d:	be 00 00 00 00       	mov    $0x0,%esi
  801822:	bf 0b 00 00 00       	mov    $0xb,%edi
  801827:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  80182e:	00 00 00 
  801831:	ff d0                	callq  *%rax
}
  801833:	c9                   	leaveq 
  801834:	c3                   	retq   

0000000000801835 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801835:	55                   	push   %rbp
  801836:	48 89 e5             	mov    %rsp,%rbp
  801839:	48 83 ec 20          	sub    $0x20,%rsp
  80183d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801840:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801844:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801847:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80184a:	48 63 c8             	movslq %eax,%rcx
  80184d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801854:	48 98                	cltq   
  801856:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185d:	00 
  80185e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801864:	49 89 c8             	mov    %rcx,%r8
  801867:	48 89 d1             	mov    %rdx,%rcx
  80186a:	48 89 c2             	mov    %rax,%rdx
  80186d:	be 01 00 00 00       	mov    $0x1,%esi
  801872:	bf 04 00 00 00       	mov    $0x4,%edi
  801877:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  80187e:	00 00 00 
  801881:	ff d0                	callq  *%rax
}
  801883:	c9                   	leaveq 
  801884:	c3                   	retq   

0000000000801885 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801885:	55                   	push   %rbp
  801886:	48 89 e5             	mov    %rsp,%rbp
  801889:	48 83 ec 30          	sub    $0x30,%rsp
  80188d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801890:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801894:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801897:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80189b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80189f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018a2:	48 63 c8             	movslq %eax,%rcx
  8018a5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018ac:	48 63 f0             	movslq %eax,%rsi
  8018af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b6:	48 98                	cltq   
  8018b8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018bc:	49 89 f9             	mov    %rdi,%r9
  8018bf:	49 89 f0             	mov    %rsi,%r8
  8018c2:	48 89 d1             	mov    %rdx,%rcx
  8018c5:	48 89 c2             	mov    %rax,%rdx
  8018c8:	be 01 00 00 00       	mov    $0x1,%esi
  8018cd:	bf 05 00 00 00       	mov    $0x5,%edi
  8018d2:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	callq  *%rax
}
  8018de:	c9                   	leaveq 
  8018df:	c3                   	retq   

00000000008018e0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 20          	sub    $0x20,%rsp
  8018e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f6:	48 98                	cltq   
  8018f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ff:	00 
  801900:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801906:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190c:	48 89 d1             	mov    %rdx,%rcx
  80190f:	48 89 c2             	mov    %rax,%rdx
  801912:	be 01 00 00 00       	mov    $0x1,%esi
  801917:	bf 06 00 00 00       	mov    $0x6,%edi
  80191c:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
}
  801928:	c9                   	leaveq 
  801929:	c3                   	retq   

000000000080192a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80192a:	55                   	push   %rbp
  80192b:	48 89 e5             	mov    %rsp,%rbp
  80192e:	48 83 ec 10          	sub    $0x10,%rsp
  801932:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801935:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801938:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80193b:	48 63 d0             	movslq %eax,%rdx
  80193e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801941:	48 98                	cltq   
  801943:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194a:	00 
  80194b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801951:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801957:	48 89 d1             	mov    %rdx,%rcx
  80195a:	48 89 c2             	mov    %rax,%rdx
  80195d:	be 01 00 00 00       	mov    $0x1,%esi
  801962:	bf 08 00 00 00       	mov    $0x8,%edi
  801967:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  80196e:	00 00 00 
  801971:	ff d0                	callq  *%rax
}
  801973:	c9                   	leaveq 
  801974:	c3                   	retq   

0000000000801975 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801975:	55                   	push   %rbp
  801976:	48 89 e5             	mov    %rsp,%rbp
  801979:	48 83 ec 20          	sub    $0x20,%rsp
  80197d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801980:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801984:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198b:	48 98                	cltq   
  80198d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801994:	00 
  801995:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a1:	48 89 d1             	mov    %rdx,%rcx
  8019a4:	48 89 c2             	mov    %rax,%rdx
  8019a7:	be 01 00 00 00       	mov    $0x1,%esi
  8019ac:	bf 09 00 00 00       	mov    $0x9,%edi
  8019b1:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  8019b8:	00 00 00 
  8019bb:	ff d0                	callq  *%rax
}
  8019bd:	c9                   	leaveq 
  8019be:	c3                   	retq   

00000000008019bf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019bf:	55                   	push   %rbp
  8019c0:	48 89 e5             	mov    %rsp,%rbp
  8019c3:	48 83 ec 20          	sub    $0x20,%rsp
  8019c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d5:	48 98                	cltq   
  8019d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019de:	00 
  8019df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019eb:	48 89 d1             	mov    %rdx,%rcx
  8019ee:	48 89 c2             	mov    %rax,%rdx
  8019f1:	be 01 00 00 00       	mov    $0x1,%esi
  8019f6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019fb:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	callq  *%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	48 83 ec 20          	sub    $0x20,%rsp
  801a11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a18:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a1c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a22:	48 63 f0             	movslq %eax,%rsi
  801a25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2c:	48 98                	cltq   
  801a2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a39:	00 
  801a3a:	49 89 f1             	mov    %rsi,%r9
  801a3d:	49 89 c8             	mov    %rcx,%r8
  801a40:	48 89 d1             	mov    %rdx,%rcx
  801a43:	48 89 c2             	mov    %rax,%rdx
  801a46:	be 00 00 00 00       	mov    $0x0,%esi
  801a4b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a50:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  801a57:	00 00 00 
  801a5a:	ff d0                	callq  *%rax
}
  801a5c:	c9                   	leaveq 
  801a5d:	c3                   	retq   

0000000000801a5e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a5e:	55                   	push   %rbp
  801a5f:	48 89 e5             	mov    %rsp,%rbp
  801a62:	48 83 ec 10          	sub    $0x10,%rsp
  801a66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a75:	00 
  801a76:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a82:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a87:	48 89 c2             	mov    %rax,%rdx
  801a8a:	be 01 00 00 00       	mov    $0x1,%esi
  801a8f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a94:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  801a9b:	00 00 00 
  801a9e:	ff d0                	callq  *%rax
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 30          	sub    $0x30,%rsp
  801aaa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801aae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab2:	48 8b 00             	mov    (%rax),%rax
  801ab5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abd:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ac1:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801ac4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ac7:	83 e0 02             	and    $0x2,%eax
  801aca:	85 c0                	test   %eax,%eax
  801acc:	75 4d                	jne    801b1b <pgfault+0x79>
  801ace:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad2:	48 c1 e8 0c          	shr    $0xc,%rax
  801ad6:	48 89 c2             	mov    %rax,%rdx
  801ad9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ae0:	01 00 00 
  801ae3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ae7:	25 00 08 00 00       	and    $0x800,%eax
  801aec:	48 85 c0             	test   %rax,%rax
  801aef:	74 2a                	je     801b1b <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801af1:	48 ba 78 43 80 00 00 	movabs $0x804378,%rdx
  801af8:	00 00 00 
  801afb:	be 1e 00 00 00       	mov    $0x1e,%esi
  801b00:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801b07:	00 00 00 
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0f:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801b16:	00 00 00 
  801b19:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801b1b:	ba 07 00 00 00       	mov    $0x7,%edx
  801b20:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b25:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2a:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
  801b36:	85 c0                	test   %eax,%eax
  801b38:	0f 85 cd 00 00 00    	jne    801c0b <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801b3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b4a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b50:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801b54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b58:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b5d:	48 89 c6             	mov    %rax,%rsi
  801b60:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b65:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  801b6c:	00 00 00 
  801b6f:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801b71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b75:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b7b:	48 89 c1             	mov    %rax,%rcx
  801b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b83:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b88:	bf 00 00 00 00       	mov    $0x0,%edi
  801b8d:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  801b94:	00 00 00 
  801b97:	ff d0                	callq  *%rax
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	79 2a                	jns    801bc7 <pgfault+0x125>
				panic("Page map at temp address failed");
  801b9d:	48 ba a8 43 80 00 00 	movabs $0x8043a8,%rdx
  801ba4:	00 00 00 
  801ba7:	be 2f 00 00 00       	mov    $0x2f,%esi
  801bac:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801bb3:	00 00 00 
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbb:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801bc2:	00 00 00 
  801bc5:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801bc7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bcc:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd1:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  801bd8:	00 00 00 
  801bdb:	ff d0                	callq  *%rax
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	79 54                	jns    801c35 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801be1:	48 ba c8 43 80 00 00 	movabs $0x8043c8,%rdx
  801be8:	00 00 00 
  801beb:	be 31 00 00 00       	mov    $0x31,%esi
  801bf0:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801bf7:	00 00 00 
  801bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801bff:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801c06:	00 00 00 
  801c09:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801c0b:	48 ba f0 43 80 00 00 	movabs $0x8043f0,%rdx
  801c12:	00 00 00 
  801c15:	be 35 00 00 00       	mov    $0x35,%esi
  801c1a:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801c21:	00 00 00 
  801c24:	b8 00 00 00 00       	mov    $0x0,%eax
  801c29:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801c30:	00 00 00 
  801c33:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801c35:	c9                   	leaveq 
  801c36:	c3                   	retq   

0000000000801c37 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	48 83 ec 20          	sub    $0x20,%rsp
  801c3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c42:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801c45:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c4c:	01 00 00 
  801c4f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c56:	25 07 0e 00 00       	and    $0xe07,%eax
  801c5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c5e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c61:	48 c1 e0 0c          	shl    $0xc,%rax
  801c65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6c:	25 00 04 00 00       	and    $0x400,%eax
  801c71:	85 c0                	test   %eax,%eax
  801c73:	74 57                	je     801ccc <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c75:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c78:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c7c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c83:	41 89 f0             	mov    %esi,%r8d
  801c86:	48 89 c6             	mov    %rax,%rsi
  801c89:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8e:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	0f 8e 52 01 00 00    	jle    801df4 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801ca2:	48 ba 1d 44 80 00 00 	movabs $0x80441d,%rdx
  801ca9:	00 00 00 
  801cac:	be 52 00 00 00       	mov    $0x52,%esi
  801cb1:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801cb8:	00 00 00 
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801cc7:	00 00 00 
  801cca:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccf:	83 e0 02             	and    $0x2,%eax
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	75 10                	jne    801ce6 <duppage+0xaf>
  801cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd9:	25 00 08 00 00       	and    $0x800,%eax
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	0f 84 bb 00 00 00    	je     801da1 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801ce6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce9:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801cee:	80 cc 08             	or     $0x8,%ah
  801cf1:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cf4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cf7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cfb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d02:	41 89 f0             	mov    %esi,%r8d
  801d05:	48 89 c6             	mov    %rax,%rsi
  801d08:	bf 00 00 00 00       	mov    $0x0,%edi
  801d0d:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	callq  *%rax
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	7e 2a                	jle    801d47 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801d1d:	48 ba 1d 44 80 00 00 	movabs $0x80441d,%rdx
  801d24:	00 00 00 
  801d27:	be 5a 00 00 00       	mov    $0x5a,%esi
  801d2c:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801d33:	00 00 00 
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3b:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801d42:	00 00 00 
  801d45:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d47:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d52:	41 89 c8             	mov    %ecx,%r8d
  801d55:	48 89 d1             	mov    %rdx,%rcx
  801d58:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5d:	48 89 c6             	mov    %rax,%rsi
  801d60:	bf 00 00 00 00       	mov    $0x0,%edi
  801d65:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	callq  *%rax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	7e 2a                	jle    801d9f <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801d75:	48 ba 1d 44 80 00 00 	movabs $0x80441d,%rdx
  801d7c:	00 00 00 
  801d7f:	be 5d 00 00 00       	mov    $0x5d,%esi
  801d84:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801d8b:	00 00 00 
  801d8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d93:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801d9a:	00 00 00 
  801d9d:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d9f:	eb 53                	jmp    801df4 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801da1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801da4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801da8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801daf:	41 89 f0             	mov    %esi,%r8d
  801db2:	48 89 c6             	mov    %rax,%rsi
  801db5:	bf 00 00 00 00       	mov    $0x0,%edi
  801dba:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	7e 2a                	jle    801df4 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801dca:	48 ba 1d 44 80 00 00 	movabs $0x80441d,%rdx
  801dd1:	00 00 00 
  801dd4:	be 61 00 00 00       	mov    $0x61,%esi
  801dd9:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801de0:	00 00 00 
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
  801de8:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  801def:	00 00 00 
  801df2:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df9:	c9                   	leaveq 
  801dfa:	c3                   	retq   

0000000000801dfb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801dfb:	55                   	push   %rbp
  801dfc:	48 89 e5             	mov    %rsp,%rbp
  801dff:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801e03:	48 bf a2 1a 80 00 00 	movabs $0x801aa2,%rdi
  801e0a:	00 00 00 
  801e0d:	48 b8 85 3a 80 00 00 	movabs $0x803a85,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e19:	b8 07 00 00 00       	mov    $0x7,%eax
  801e1e:	cd 30                	int    $0x30
  801e20:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e23:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801e26:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e2d:	79 30                	jns    801e5f <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801e2f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e32:	89 c1                	mov    %eax,%ecx
  801e34:	48 ba 3b 44 80 00 00 	movabs $0x80443b,%rdx
  801e3b:	00 00 00 
  801e3e:	be 89 00 00 00       	mov    $0x89,%esi
  801e43:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801e4a:	00 00 00 
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	49 b8 71 39 80 00 00 	movabs $0x803971,%r8
  801e59:	00 00 00 
  801e5c:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e63:	75 46                	jne    801eab <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e65:	48 b8 b9 17 80 00 00 	movabs $0x8017b9,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
  801e71:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e76:	48 63 d0             	movslq %eax,%rdx
  801e79:	48 89 d0             	mov    %rdx,%rax
  801e7c:	48 c1 e0 03          	shl    $0x3,%rax
  801e80:	48 01 d0             	add    %rdx,%rax
  801e83:	48 c1 e0 05          	shl    $0x5,%rax
  801e87:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e8e:	00 00 00 
  801e91:	48 01 c2             	add    %rax,%rdx
  801e94:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801e9b:	00 00 00 
  801e9e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea6:	e9 d1 01 00 00       	jmpq   80207c <fork+0x281>
	}

	uint64_t ad = 0;
  801eab:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801eb2:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801eb3:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801eb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801ebc:	e9 df 00 00 00       	jmpq   801fa0 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec5:	48 c1 e8 27          	shr    $0x27,%rax
  801ec9:	48 89 c2             	mov    %rax,%rdx
  801ecc:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ed3:	01 00 00 
  801ed6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eda:	83 e0 01             	and    $0x1,%eax
  801edd:	48 85 c0             	test   %rax,%rax
  801ee0:	0f 84 9e 00 00 00    	je     801f84 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801ee6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eea:	48 c1 e8 1e          	shr    $0x1e,%rax
  801eee:	48 89 c2             	mov    %rax,%rdx
  801ef1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ef8:	01 00 00 
  801efb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eff:	83 e0 01             	and    $0x1,%eax
  801f02:	48 85 c0             	test   %rax,%rax
  801f05:	74 73                	je     801f7a <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0b:	48 c1 e8 15          	shr    $0x15,%rax
  801f0f:	48 89 c2             	mov    %rax,%rdx
  801f12:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f19:	01 00 00 
  801f1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f20:	83 e0 01             	and    $0x1,%eax
  801f23:	48 85 c0             	test   %rax,%rax
  801f26:	74 48                	je     801f70 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f30:	48 89 c2             	mov    %rax,%rdx
  801f33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f3a:	01 00 00 
  801f3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f49:	83 e0 01             	and    $0x1,%eax
  801f4c:	48 85 c0             	test   %rax,%rax
  801f4f:	74 47                	je     801f98 <fork+0x19d>
						duppage(envid, VPN(addr));
  801f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f55:	48 c1 e8 0c          	shr    $0xc,%rax
  801f59:	89 c2                	mov    %eax,%edx
  801f5b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f5e:	89 d6                	mov    %edx,%esi
  801f60:	89 c7                	mov    %eax,%edi
  801f62:	48 b8 37 1c 80 00 00 	movabs $0x801c37,%rax
  801f69:	00 00 00 
  801f6c:	ff d0                	callq  *%rax
  801f6e:	eb 28                	jmp    801f98 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  801f70:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801f77:	00 
  801f78:	eb 1e                	jmp    801f98 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801f7a:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801f81:	40 
  801f82:	eb 14                	jmp    801f98 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  801f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f88:	48 c1 e8 27          	shr    $0x27,%rax
  801f8c:	48 83 c0 01          	add    $0x1,%rax
  801f90:	48 c1 e0 27          	shl    $0x27,%rax
  801f94:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801f98:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801f9f:	00 
  801fa0:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  801fa7:	00 
  801fa8:	0f 87 13 ff ff ff    	ja     801ec1 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801fae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fb1:	ba 07 00 00 00       	mov    $0x7,%edx
  801fb6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801fbb:	89 c7                	mov    %eax,%edi
  801fbd:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  801fc4:	00 00 00 
  801fc7:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801fc9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fcc:	ba 07 00 00 00       	mov    $0x7,%edx
  801fd1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fd6:	89 c7                	mov    %eax,%edi
  801fd8:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  801fdf:	00 00 00 
  801fe2:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  801fe4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fe7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fed:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  801ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff7:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801ffc:	89 c7                	mov    %eax,%edi
  801ffe:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  802005:	00 00 00 
  802008:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80200a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80200f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802014:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802019:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  802020:	00 00 00 
  802023:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802025:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80202a:	bf 00 00 00 00       	mov    $0x0,%edi
  80202f:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80203b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802042:	00 00 00 
  802045:	48 8b 00             	mov    (%rax),%rax
  802048:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80204f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802052:	48 89 d6             	mov    %rdx,%rsi
  802055:	89 c7                	mov    %eax,%edi
  802057:	48 b8 bf 19 80 00 00 	movabs $0x8019bf,%rax
  80205e:	00 00 00 
  802061:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  802063:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802066:	be 02 00 00 00       	mov    $0x2,%esi
  80206b:	89 c7                	mov    %eax,%edi
  80206d:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax

	return envid;
  802079:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  80207c:	c9                   	leaveq 
  80207d:	c3                   	retq   

000000000080207e <sfork>:

// Challenge!
int
sfork(void)
{
  80207e:	55                   	push   %rbp
  80207f:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802082:	48 ba 53 44 80 00 00 	movabs $0x804453,%rdx
  802089:	00 00 00 
  80208c:	be b8 00 00 00       	mov    $0xb8,%esi
  802091:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  802098:	00 00 00 
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  8020a7:	00 00 00 
  8020aa:	ff d1                	callq  *%rcx

00000000008020ac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020ac:	55                   	push   %rbp
  8020ad:	48 89 e5             	mov    %rsp,%rbp
  8020b0:	48 83 ec 08          	sub    $0x8,%rsp
  8020b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020bc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020c3:	ff ff ff 
  8020c6:	48 01 d0             	add    %rdx,%rax
  8020c9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020cd:	c9                   	leaveq 
  8020ce:	c3                   	retq   

00000000008020cf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020cf:	55                   	push   %rbp
  8020d0:	48 89 e5             	mov    %rsp,%rbp
  8020d3:	48 83 ec 08          	sub    $0x8,%rsp
  8020d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020df:	48 89 c7             	mov    %rax,%rdi
  8020e2:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8020e9:	00 00 00 
  8020ec:	ff d0                	callq  *%rax
  8020ee:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8020f4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8020f8:	c9                   	leaveq 
  8020f9:	c3                   	retq   

00000000008020fa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8020fa:	55                   	push   %rbp
  8020fb:	48 89 e5             	mov    %rsp,%rbp
  8020fe:	48 83 ec 18          	sub    $0x18,%rsp
  802102:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80210d:	eb 6b                	jmp    80217a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80210f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802112:	48 98                	cltq   
  802114:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80211a:	48 c1 e0 0c          	shl    $0xc,%rax
  80211e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802126:	48 c1 e8 15          	shr    $0x15,%rax
  80212a:	48 89 c2             	mov    %rax,%rdx
  80212d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802134:	01 00 00 
  802137:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213b:	83 e0 01             	and    $0x1,%eax
  80213e:	48 85 c0             	test   %rax,%rax
  802141:	74 21                	je     802164 <fd_alloc+0x6a>
  802143:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802147:	48 c1 e8 0c          	shr    $0xc,%rax
  80214b:	48 89 c2             	mov    %rax,%rdx
  80214e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802155:	01 00 00 
  802158:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215c:	83 e0 01             	and    $0x1,%eax
  80215f:	48 85 c0             	test   %rax,%rax
  802162:	75 12                	jne    802176 <fd_alloc+0x7c>
			*fd_store = fd;
  802164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802168:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80216c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	eb 1a                	jmp    802190 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802176:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80217a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80217e:	7e 8f                	jle    80210f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802184:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80218b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802190:	c9                   	leaveq 
  802191:	c3                   	retq   

0000000000802192 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802192:	55                   	push   %rbp
  802193:	48 89 e5             	mov    %rsp,%rbp
  802196:	48 83 ec 20          	sub    $0x20,%rsp
  80219a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80219d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021a5:	78 06                	js     8021ad <fd_lookup+0x1b>
  8021a7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021ab:	7e 07                	jle    8021b4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021b2:	eb 6c                	jmp    802220 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021b7:	48 98                	cltq   
  8021b9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8021c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021cb:	48 c1 e8 15          	shr    $0x15,%rax
  8021cf:	48 89 c2             	mov    %rax,%rdx
  8021d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021d9:	01 00 00 
  8021dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e0:	83 e0 01             	and    $0x1,%eax
  8021e3:	48 85 c0             	test   %rax,%rax
  8021e6:	74 21                	je     802209 <fd_lookup+0x77>
  8021e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f0:	48 89 c2             	mov    %rax,%rdx
  8021f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fa:	01 00 00 
  8021fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802201:	83 e0 01             	and    $0x1,%eax
  802204:	48 85 c0             	test   %rax,%rax
  802207:	75 07                	jne    802210 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802209:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80220e:	eb 10                	jmp    802220 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802210:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802214:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802218:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802220:	c9                   	leaveq 
  802221:	c3                   	retq   

0000000000802222 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802222:	55                   	push   %rbp
  802223:	48 89 e5             	mov    %rsp,%rbp
  802226:	48 83 ec 30          	sub    $0x30,%rsp
  80222a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80222e:	89 f0                	mov    %esi,%eax
  802230:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802237:	48 89 c7             	mov    %rax,%rdi
  80223a:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802241:	00 00 00 
  802244:	ff d0                	callq  *%rax
  802246:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80224a:	48 89 d6             	mov    %rdx,%rsi
  80224d:	89 c7                	mov    %eax,%edi
  80224f:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  802256:	00 00 00 
  802259:	ff d0                	callq  *%rax
  80225b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802262:	78 0a                	js     80226e <fd_close+0x4c>
	    || fd != fd2)
  802264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802268:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80226c:	74 12                	je     802280 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80226e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802272:	74 05                	je     802279 <fd_close+0x57>
  802274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802277:	eb 05                	jmp    80227e <fd_close+0x5c>
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 69                	jmp    8022e9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802280:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802284:	8b 00                	mov    (%rax),%eax
  802286:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80228a:	48 89 d6             	mov    %rdx,%rsi
  80228d:	89 c7                	mov    %eax,%edi
  80228f:	48 b8 eb 22 80 00 00 	movabs $0x8022eb,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
  80229b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a2:	78 2a                	js     8022ce <fd_close+0xac>
		if (dev->dev_close)
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022ac:	48 85 c0             	test   %rax,%rax
  8022af:	74 16                	je     8022c7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8022b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022bd:	48 89 d7             	mov    %rdx,%rdi
  8022c0:	ff d0                	callq  *%rax
  8022c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c5:	eb 07                	jmp    8022ce <fd_close+0xac>
		else
			r = 0;
  8022c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d2:	48 89 c6             	mov    %rax,%rsi
  8022d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8022da:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	callq  *%rax
	return r;
  8022e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022e9:	c9                   	leaveq 
  8022ea:	c3                   	retq   

00000000008022eb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8022eb:	55                   	push   %rbp
  8022ec:	48 89 e5             	mov    %rsp,%rbp
  8022ef:	48 83 ec 20          	sub    $0x20,%rsp
  8022f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8022fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802301:	eb 41                	jmp    802344 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802303:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80230a:	00 00 00 
  80230d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802310:	48 63 d2             	movslq %edx,%rdx
  802313:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802317:	8b 00                	mov    (%rax),%eax
  802319:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80231c:	75 22                	jne    802340 <dev_lookup+0x55>
			*dev = devtab[i];
  80231e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802325:	00 00 00 
  802328:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80232b:	48 63 d2             	movslq %edx,%rdx
  80232e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802332:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802336:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	eb 60                	jmp    8023a0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802340:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802344:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80234b:	00 00 00 
  80234e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802351:	48 63 d2             	movslq %edx,%rdx
  802354:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802358:	48 85 c0             	test   %rax,%rax
  80235b:	75 a6                	jne    802303 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80235d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802364:	00 00 00 
  802367:	48 8b 00             	mov    (%rax),%rax
  80236a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802370:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802373:	89 c6                	mov    %eax,%esi
  802375:	48 bf 70 44 80 00 00 	movabs $0x804470,%rdi
  80237c:	00 00 00 
  80237f:	b8 00 00 00 00       	mov    $0x0,%eax
  802384:	48 b9 3e 03 80 00 00 	movabs $0x80033e,%rcx
  80238b:	00 00 00 
  80238e:	ff d1                	callq  *%rcx
	*dev = 0;
  802390:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802394:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80239b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023a0:	c9                   	leaveq 
  8023a1:	c3                   	retq   

00000000008023a2 <close>:

int
close(int fdnum)
{
  8023a2:	55                   	push   %rbp
  8023a3:	48 89 e5             	mov    %rsp,%rbp
  8023a6:	48 83 ec 20          	sub    $0x20,%rsp
  8023aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023b4:	48 89 d6             	mov    %rdx,%rsi
  8023b7:	89 c7                	mov    %eax,%edi
  8023b9:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  8023c0:	00 00 00 
  8023c3:	ff d0                	callq  *%rax
  8023c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cc:	79 05                	jns    8023d3 <close+0x31>
		return r;
  8023ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d1:	eb 18                	jmp    8023eb <close+0x49>
	else
		return fd_close(fd, 1);
  8023d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d7:	be 01 00 00 00       	mov    $0x1,%esi
  8023dc:	48 89 c7             	mov    %rax,%rdi
  8023df:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
}
  8023eb:	c9                   	leaveq 
  8023ec:	c3                   	retq   

00000000008023ed <close_all>:

void
close_all(void)
{
  8023ed:	55                   	push   %rbp
  8023ee:	48 89 e5             	mov    %rsp,%rbp
  8023f1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8023f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023fc:	eb 15                	jmp    802413 <close_all+0x26>
		close(i);
  8023fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802401:	89 c7                	mov    %eax,%edi
  802403:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  80240a:	00 00 00 
  80240d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80240f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802413:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802417:	7e e5                	jle    8023fe <close_all+0x11>
		close(i);
}
  802419:	c9                   	leaveq 
  80241a:	c3                   	retq   

000000000080241b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80241b:	55                   	push   %rbp
  80241c:	48 89 e5             	mov    %rsp,%rbp
  80241f:	48 83 ec 40          	sub    $0x40,%rsp
  802423:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802426:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802429:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80242d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802430:	48 89 d6             	mov    %rdx,%rsi
  802433:	89 c7                	mov    %eax,%edi
  802435:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	callq  *%rax
  802441:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802444:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802448:	79 08                	jns    802452 <dup+0x37>
		return r;
  80244a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80244d:	e9 70 01 00 00       	jmpq   8025c2 <dup+0x1a7>
	close(newfdnum);
  802452:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802455:	89 c7                	mov    %eax,%edi
  802457:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  80245e:	00 00 00 
  802461:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802463:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802466:	48 98                	cltq   
  802468:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80246e:	48 c1 e0 0c          	shl    $0xc,%rax
  802472:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80247a:	48 89 c7             	mov    %rax,%rdi
  80247d:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  802484:	00 00 00 
  802487:	ff d0                	callq  *%rax
  802489:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80248d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802491:	48 89 c7             	mov    %rax,%rdi
  802494:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	callq  *%rax
  8024a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a8:	48 c1 e8 15          	shr    $0x15,%rax
  8024ac:	48 89 c2             	mov    %rax,%rdx
  8024af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024b6:	01 00 00 
  8024b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bd:	83 e0 01             	and    $0x1,%eax
  8024c0:	48 85 c0             	test   %rax,%rax
  8024c3:	74 73                	je     802538 <dup+0x11d>
  8024c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8024cd:	48 89 c2             	mov    %rax,%rdx
  8024d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024d7:	01 00 00 
  8024da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024de:	83 e0 01             	and    $0x1,%eax
  8024e1:	48 85 c0             	test   %rax,%rax
  8024e4:	74 52                	je     802538 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8024e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ea:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ee:	48 89 c2             	mov    %rax,%rdx
  8024f1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f8:	01 00 00 
  8024fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ff:	25 07 0e 00 00       	and    $0xe07,%eax
  802504:	89 c1                	mov    %eax,%ecx
  802506:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80250a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250e:	41 89 c8             	mov    %ecx,%r8d
  802511:	48 89 d1             	mov    %rdx,%rcx
  802514:	ba 00 00 00 00       	mov    $0x0,%edx
  802519:	48 89 c6             	mov    %rax,%rsi
  80251c:	bf 00 00 00 00       	mov    $0x0,%edi
  802521:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  802528:	00 00 00 
  80252b:	ff d0                	callq  *%rax
  80252d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802530:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802534:	79 02                	jns    802538 <dup+0x11d>
			goto err;
  802536:	eb 57                	jmp    80258f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253c:	48 c1 e8 0c          	shr    $0xc,%rax
  802540:	48 89 c2             	mov    %rax,%rdx
  802543:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80254a:	01 00 00 
  80254d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802551:	25 07 0e 00 00       	and    $0xe07,%eax
  802556:	89 c1                	mov    %eax,%ecx
  802558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80255c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802560:	41 89 c8             	mov    %ecx,%r8d
  802563:	48 89 d1             	mov    %rdx,%rcx
  802566:	ba 00 00 00 00       	mov    $0x0,%edx
  80256b:	48 89 c6             	mov    %rax,%rsi
  80256e:	bf 00 00 00 00       	mov    $0x0,%edi
  802573:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  80257a:	00 00 00 
  80257d:	ff d0                	callq  *%rax
  80257f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802582:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802586:	79 02                	jns    80258a <dup+0x16f>
		goto err;
  802588:	eb 05                	jmp    80258f <dup+0x174>

	return newfdnum;
  80258a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80258d:	eb 33                	jmp    8025c2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80258f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802593:	48 89 c6             	mov    %rax,%rsi
  802596:	bf 00 00 00 00       	mov    $0x0,%edi
  80259b:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8025a2:	00 00 00 
  8025a5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ab:	48 89 c6             	mov    %rax,%rsi
  8025ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b3:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8025ba:	00 00 00 
  8025bd:	ff d0                	callq  *%rax
	return r;
  8025bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025c2:	c9                   	leaveq 
  8025c3:	c3                   	retq   

00000000008025c4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025c4:	55                   	push   %rbp
  8025c5:	48 89 e5             	mov    %rsp,%rbp
  8025c8:	48 83 ec 40          	sub    $0x40,%rsp
  8025cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025d3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025d7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025db:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025de:	48 89 d6             	mov    %rdx,%rsi
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  8025ea:	00 00 00 
  8025ed:	ff d0                	callq  *%rax
  8025ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f6:	78 24                	js     80261c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fc:	8b 00                	mov    (%rax),%eax
  8025fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802602:	48 89 d6             	mov    %rdx,%rsi
  802605:	89 c7                	mov    %eax,%edi
  802607:	48 b8 eb 22 80 00 00 	movabs $0x8022eb,%rax
  80260e:	00 00 00 
  802611:	ff d0                	callq  *%rax
  802613:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802616:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261a:	79 05                	jns    802621 <read+0x5d>
		return r;
  80261c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261f:	eb 76                	jmp    802697 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802625:	8b 40 08             	mov    0x8(%rax),%eax
  802628:	83 e0 03             	and    $0x3,%eax
  80262b:	83 f8 01             	cmp    $0x1,%eax
  80262e:	75 3a                	jne    80266a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802630:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802637:	00 00 00 
  80263a:	48 8b 00             	mov    (%rax),%rax
  80263d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802643:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802646:	89 c6                	mov    %eax,%esi
  802648:	48 bf 8f 44 80 00 00 	movabs $0x80448f,%rdi
  80264f:	00 00 00 
  802652:	b8 00 00 00 00       	mov    $0x0,%eax
  802657:	48 b9 3e 03 80 00 00 	movabs $0x80033e,%rcx
  80265e:	00 00 00 
  802661:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802663:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802668:	eb 2d                	jmp    802697 <read+0xd3>
	}
	if (!dev->dev_read)
  80266a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802672:	48 85 c0             	test   %rax,%rax
  802675:	75 07                	jne    80267e <read+0xba>
		return -E_NOT_SUPP;
  802677:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80267c:	eb 19                	jmp    802697 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80267e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802682:	48 8b 40 10          	mov    0x10(%rax),%rax
  802686:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80268a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80268e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802692:	48 89 cf             	mov    %rcx,%rdi
  802695:	ff d0                	callq  *%rax
}
  802697:	c9                   	leaveq 
  802698:	c3                   	retq   

0000000000802699 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802699:	55                   	push   %rbp
  80269a:	48 89 e5             	mov    %rsp,%rbp
  80269d:	48 83 ec 30          	sub    $0x30,%rsp
  8026a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026b3:	eb 49                	jmp    8026fe <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b8:	48 98                	cltq   
  8026ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026be:	48 29 c2             	sub    %rax,%rdx
  8026c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c4:	48 63 c8             	movslq %eax,%rcx
  8026c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026cb:	48 01 c1             	add    %rax,%rcx
  8026ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026d1:	48 89 ce             	mov    %rcx,%rsi
  8026d4:	89 c7                	mov    %eax,%edi
  8026d6:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax
  8026e2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8026e5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026e9:	79 05                	jns    8026f0 <readn+0x57>
			return m;
  8026eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026ee:	eb 1c                	jmp    80270c <readn+0x73>
		if (m == 0)
  8026f0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026f4:	75 02                	jne    8026f8 <readn+0x5f>
			break;
  8026f6:	eb 11                	jmp    802709 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026fb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8026fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802701:	48 98                	cltq   
  802703:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802707:	72 ac                	jb     8026b5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802709:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	48 83 ec 40          	sub    $0x40,%rsp
  802716:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802719:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80271d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802721:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802725:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802728:	48 89 d6             	mov    %rdx,%rsi
  80272b:	89 c7                	mov    %eax,%edi
  80272d:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  802734:	00 00 00 
  802737:	ff d0                	callq  *%rax
  802739:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802740:	78 24                	js     802766 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802746:	8b 00                	mov    (%rax),%eax
  802748:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274c:	48 89 d6             	mov    %rdx,%rsi
  80274f:	89 c7                	mov    %eax,%edi
  802751:	48 b8 eb 22 80 00 00 	movabs $0x8022eb,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	79 05                	jns    80276b <write+0x5d>
		return r;
  802766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802769:	eb 75                	jmp    8027e0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80276b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276f:	8b 40 08             	mov    0x8(%rax),%eax
  802772:	83 e0 03             	and    $0x3,%eax
  802775:	85 c0                	test   %eax,%eax
  802777:	75 3a                	jne    8027b3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802779:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802780:	00 00 00 
  802783:	48 8b 00             	mov    (%rax),%rax
  802786:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80278c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80278f:	89 c6                	mov    %eax,%esi
  802791:	48 bf ab 44 80 00 00 	movabs $0x8044ab,%rdi
  802798:	00 00 00 
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	48 b9 3e 03 80 00 00 	movabs $0x80033e,%rcx
  8027a7:	00 00 00 
  8027aa:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027b1:	eb 2d                	jmp    8027e0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8027b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027bb:	48 85 c0             	test   %rax,%rax
  8027be:	75 07                	jne    8027c7 <write+0xb9>
		return -E_NOT_SUPP;
  8027c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027c5:	eb 19                	jmp    8027e0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027d3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027d7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027db:	48 89 cf             	mov    %rcx,%rdi
  8027de:	ff d0                	callq  *%rax
}
  8027e0:	c9                   	leaveq 
  8027e1:	c3                   	retq   

00000000008027e2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 18          	sub    $0x18,%rsp
  8027ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ed:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f7:	48 89 d6             	mov    %rdx,%rsi
  8027fa:	89 c7                	mov    %eax,%edi
  8027fc:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  802803:	00 00 00 
  802806:	ff d0                	callq  *%rax
  802808:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80280b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280f:	79 05                	jns    802816 <seek+0x34>
		return r;
  802811:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802814:	eb 0f                	jmp    802825 <seek+0x43>
	fd->fd_offset = offset;
  802816:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80281d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802820:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802825:	c9                   	leaveq 
  802826:	c3                   	retq   

0000000000802827 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802827:	55                   	push   %rbp
  802828:	48 89 e5             	mov    %rsp,%rbp
  80282b:	48 83 ec 30          	sub    $0x30,%rsp
  80282f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802832:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802835:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802839:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80283c:	48 89 d6             	mov    %rdx,%rsi
  80283f:	89 c7                	mov    %eax,%edi
  802841:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  802848:	00 00 00 
  80284b:	ff d0                	callq  *%rax
  80284d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802850:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802854:	78 24                	js     80287a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285a:	8b 00                	mov    (%rax),%eax
  80285c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802860:	48 89 d6             	mov    %rdx,%rsi
  802863:	89 c7                	mov    %eax,%edi
  802865:	48 b8 eb 22 80 00 00 	movabs $0x8022eb,%rax
  80286c:	00 00 00 
  80286f:	ff d0                	callq  *%rax
  802871:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802874:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802878:	79 05                	jns    80287f <ftruncate+0x58>
		return r;
  80287a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287d:	eb 72                	jmp    8028f1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80287f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802883:	8b 40 08             	mov    0x8(%rax),%eax
  802886:	83 e0 03             	and    $0x3,%eax
  802889:	85 c0                	test   %eax,%eax
  80288b:	75 3a                	jne    8028c7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80288d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802894:	00 00 00 
  802897:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80289a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028a0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028a3:	89 c6                	mov    %eax,%esi
  8028a5:	48 bf c8 44 80 00 00 	movabs $0x8044c8,%rdi
  8028ac:	00 00 00 
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	48 b9 3e 03 80 00 00 	movabs $0x80033e,%rcx
  8028bb:	00 00 00 
  8028be:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c5:	eb 2a                	jmp    8028f1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028cf:	48 85 c0             	test   %rax,%rax
  8028d2:	75 07                	jne    8028db <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028d4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d9:	eb 16                	jmp    8028f1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028df:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028e7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8028ea:	89 ce                	mov    %ecx,%esi
  8028ec:	48 89 d7             	mov    %rdx,%rdi
  8028ef:	ff d0                	callq  *%rax
}
  8028f1:	c9                   	leaveq 
  8028f2:	c3                   	retq   

00000000008028f3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8028f3:	55                   	push   %rbp
  8028f4:	48 89 e5             	mov    %rsp,%rbp
  8028f7:	48 83 ec 30          	sub    $0x30,%rsp
  8028fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802902:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802906:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802909:	48 89 d6             	mov    %rdx,%rsi
  80290c:	89 c7                	mov    %eax,%edi
  80290e:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
  80291a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802921:	78 24                	js     802947 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802927:	8b 00                	mov    (%rax),%eax
  802929:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80292d:	48 89 d6             	mov    %rdx,%rsi
  802930:	89 c7                	mov    %eax,%edi
  802932:	48 b8 eb 22 80 00 00 	movabs $0x8022eb,%rax
  802939:	00 00 00 
  80293c:	ff d0                	callq  *%rax
  80293e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802941:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802945:	79 05                	jns    80294c <fstat+0x59>
		return r;
  802947:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294a:	eb 5e                	jmp    8029aa <fstat+0xb7>
	if (!dev->dev_stat)
  80294c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802950:	48 8b 40 28          	mov    0x28(%rax),%rax
  802954:	48 85 c0             	test   %rax,%rax
  802957:	75 07                	jne    802960 <fstat+0x6d>
		return -E_NOT_SUPP;
  802959:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80295e:	eb 4a                	jmp    8029aa <fstat+0xb7>
	stat->st_name[0] = 0;
  802960:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802964:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802967:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80296b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802972:	00 00 00 
	stat->st_isdir = 0;
  802975:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802979:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802980:	00 00 00 
	stat->st_dev = dev;
  802983:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802987:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80298b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802992:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802996:	48 8b 40 28          	mov    0x28(%rax),%rax
  80299a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80299e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029a2:	48 89 ce             	mov    %rcx,%rsi
  8029a5:	48 89 d7             	mov    %rdx,%rdi
  8029a8:	ff d0                	callq  *%rax
}
  8029aa:	c9                   	leaveq 
  8029ab:	c3                   	retq   

00000000008029ac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029ac:	55                   	push   %rbp
  8029ad:	48 89 e5             	mov    %rsp,%rbp
  8029b0:	48 83 ec 20          	sub    $0x20,%rsp
  8029b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c0:	be 00 00 00 00       	mov    $0x0,%esi
  8029c5:	48 89 c7             	mov    %rax,%rdi
  8029c8:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	callq  *%rax
  8029d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029db:	79 05                	jns    8029e2 <stat+0x36>
		return fd;
  8029dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e0:	eb 2f                	jmp    802a11 <stat+0x65>
	r = fstat(fd, stat);
  8029e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e9:	48 89 d6             	mov    %rdx,%rsi
  8029ec:	89 c7                	mov    %eax,%edi
  8029ee:	48 b8 f3 28 80 00 00 	movabs $0x8028f3,%rax
  8029f5:	00 00 00 
  8029f8:	ff d0                	callq  *%rax
  8029fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8029fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a00:	89 c7                	mov    %eax,%edi
  802a02:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	callq  *%rax
	return r;
  802a0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a11:	c9                   	leaveq 
  802a12:	c3                   	retq   

0000000000802a13 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a13:	55                   	push   %rbp
  802a14:	48 89 e5             	mov    %rsp,%rbp
  802a17:	48 83 ec 10          	sub    $0x10,%rsp
  802a1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a22:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a29:	00 00 00 
  802a2c:	8b 00                	mov    (%rax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	75 1d                	jne    802a4f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a32:	bf 01 00 00 00       	mov    $0x1,%edi
  802a37:	48 b8 28 3d 80 00 00 	movabs $0x803d28,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
  802a43:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802a4a:	00 00 00 
  802a4d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a4f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a56:	00 00 00 
  802a59:	8b 00                	mov    (%rax),%eax
  802a5b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a5e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a63:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a6a:	00 00 00 
  802a6d:	89 c7                	mov    %eax,%edi
  802a6f:	48 b8 90 3c 80 00 00 	movabs $0x803c90,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a84:	48 89 c6             	mov    %rax,%rsi
  802a87:	bf 00 00 00 00       	mov    $0x0,%edi
  802a8c:	48 b8 cf 3b 80 00 00 	movabs $0x803bcf,%rax
  802a93:	00 00 00 
  802a96:	ff d0                	callq  *%rax
}
  802a98:	c9                   	leaveq 
  802a99:	c3                   	retq   

0000000000802a9a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a9a:	55                   	push   %rbp
  802a9b:	48 89 e5             	mov    %rsp,%rbp
  802a9e:	48 83 ec 20          	sub    $0x20,%rsp
  802aa2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aad:	48 89 c7             	mov    %rax,%rdi
  802ab0:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  802ab7:	00 00 00 
  802aba:	ff d0                	callq  *%rax
  802abc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ac1:	7e 0a                	jle    802acd <open+0x33>
		return -E_BAD_PATH;
  802ac3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ac8:	e9 a5 00 00 00       	jmpq   802b72 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802acd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ad1:	48 89 c7             	mov    %rax,%rdi
  802ad4:	48 b8 fa 20 80 00 00 	movabs $0x8020fa,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
  802ae0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae7:	79 08                	jns    802af1 <open+0x57>
		return r;
  802ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aec:	e9 81 00 00 00       	jmpq   802b72 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802af1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af5:	48 89 c6             	mov    %rax,%rsi
  802af8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802aff:	00 00 00 
  802b02:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802b0e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b15:	00 00 00 
  802b18:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b1b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802b21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b25:	48 89 c6             	mov    %rax,%rsi
  802b28:	bf 01 00 00 00       	mov    $0x1,%edi
  802b2d:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802b34:	00 00 00 
  802b37:	ff d0                	callq  *%rax
  802b39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b40:	79 1d                	jns    802b5f <open+0xc5>
		fd_close(fd, 0);
  802b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b46:	be 00 00 00 00       	mov    $0x0,%esi
  802b4b:	48 89 c7             	mov    %rax,%rdi
  802b4e:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
		return r;
  802b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5d:	eb 13                	jmp    802b72 <open+0xd8>
	}

	return fd2num(fd);
  802b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b63:	48 89 c7             	mov    %rax,%rdi
  802b66:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  802b6d:	00 00 00 
  802b70:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802b72:	c9                   	leaveq 
  802b73:	c3                   	retq   

0000000000802b74 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802b74:	55                   	push   %rbp
  802b75:	48 89 e5             	mov    %rsp,%rbp
  802b78:	48 83 ec 10          	sub    $0x10,%rsp
  802b7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b84:	8b 50 0c             	mov    0xc(%rax),%edx
  802b87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b8e:	00 00 00 
  802b91:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b93:	be 00 00 00 00       	mov    $0x0,%esi
  802b98:	bf 06 00 00 00       	mov    $0x6,%edi
  802b9d:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802ba4:	00 00 00 
  802ba7:	ff d0                	callq  *%rax
}
  802ba9:	c9                   	leaveq 
  802baa:	c3                   	retq   

0000000000802bab <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802bab:	55                   	push   %rbp
  802bac:	48 89 e5             	mov    %rsp,%rbp
  802baf:	48 83 ec 30          	sub    $0x30,%rsp
  802bb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bbb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802bbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc3:	8b 50 0c             	mov    0xc(%rax),%edx
  802bc6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bcd:	00 00 00 
  802bd0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802bd2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bd9:	00 00 00 
  802bdc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802be0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802be4:	be 00 00 00 00       	mov    $0x0,%esi
  802be9:	bf 03 00 00 00       	mov    $0x3,%edi
  802bee:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802bf5:	00 00 00 
  802bf8:	ff d0                	callq  *%rax
  802bfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c01:	79 08                	jns    802c0b <devfile_read+0x60>
		return r;
  802c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c06:	e9 a4 00 00 00       	jmpq   802caf <devfile_read+0x104>
	assert(r <= n);
  802c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0e:	48 98                	cltq   
  802c10:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c14:	76 35                	jbe    802c4b <devfile_read+0xa0>
  802c16:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  802c1d:	00 00 00 
  802c20:	48 ba fc 44 80 00 00 	movabs $0x8044fc,%rdx
  802c27:	00 00 00 
  802c2a:	be 84 00 00 00       	mov    $0x84,%esi
  802c2f:	48 bf 11 45 80 00 00 	movabs $0x804511,%rdi
  802c36:	00 00 00 
  802c39:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3e:	49 b8 71 39 80 00 00 	movabs $0x803971,%r8
  802c45:	00 00 00 
  802c48:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802c4b:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802c52:	7e 35                	jle    802c89 <devfile_read+0xde>
  802c54:	48 b9 1c 45 80 00 00 	movabs $0x80451c,%rcx
  802c5b:	00 00 00 
  802c5e:	48 ba fc 44 80 00 00 	movabs $0x8044fc,%rdx
  802c65:	00 00 00 
  802c68:	be 85 00 00 00       	mov    $0x85,%esi
  802c6d:	48 bf 11 45 80 00 00 	movabs $0x804511,%rdi
  802c74:	00 00 00 
  802c77:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7c:	49 b8 71 39 80 00 00 	movabs $0x803971,%r8
  802c83:	00 00 00 
  802c86:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802c89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8c:	48 63 d0             	movslq %eax,%rdx
  802c8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c93:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c9a:	00 00 00 
  802c9d:	48 89 c7             	mov    %rax,%rdi
  802ca0:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
	return r;
  802cac:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802caf:	c9                   	leaveq 
  802cb0:	c3                   	retq   

0000000000802cb1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802cb1:	55                   	push   %rbp
  802cb2:	48 89 e5             	mov    %rsp,%rbp
  802cb5:	48 83 ec 30          	sub    $0x30,%rsp
  802cb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cbd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cc1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc9:	8b 50 0c             	mov    0xc(%rax),%edx
  802ccc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cd3:	00 00 00 
  802cd6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802cd8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cdf:	00 00 00 
  802ce2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ce6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802cea:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802cf1:	00 
  802cf2:	76 35                	jbe    802d29 <devfile_write+0x78>
  802cf4:	48 b9 28 45 80 00 00 	movabs $0x804528,%rcx
  802cfb:	00 00 00 
  802cfe:	48 ba fc 44 80 00 00 	movabs $0x8044fc,%rdx
  802d05:	00 00 00 
  802d08:	be 9e 00 00 00       	mov    $0x9e,%esi
  802d0d:	48 bf 11 45 80 00 00 	movabs $0x804511,%rdi
  802d14:	00 00 00 
  802d17:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1c:	49 b8 71 39 80 00 00 	movabs $0x803971,%r8
  802d23:	00 00 00 
  802d26:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802d29:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d31:	48 89 c6             	mov    %rax,%rsi
  802d34:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d3b:	00 00 00 
  802d3e:	48 b8 41 13 80 00 00 	movabs $0x801341,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802d4a:	be 00 00 00 00       	mov    $0x0,%esi
  802d4f:	bf 04 00 00 00       	mov    $0x4,%edi
  802d54:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	callq  *%rax
  802d60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d67:	79 05                	jns    802d6e <devfile_write+0xbd>
		return r;
  802d69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6c:	eb 43                	jmp    802db1 <devfile_write+0x100>
	assert(r <= n);
  802d6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d71:	48 98                	cltq   
  802d73:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d77:	76 35                	jbe    802dae <devfile_write+0xfd>
  802d79:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  802d80:	00 00 00 
  802d83:	48 ba fc 44 80 00 00 	movabs $0x8044fc,%rdx
  802d8a:	00 00 00 
  802d8d:	be a2 00 00 00       	mov    $0xa2,%esi
  802d92:	48 bf 11 45 80 00 00 	movabs $0x804511,%rdi
  802d99:	00 00 00 
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802da1:	49 b8 71 39 80 00 00 	movabs $0x803971,%r8
  802da8:	00 00 00 
  802dab:	41 ff d0             	callq  *%r8
	return r;
  802dae:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802db1:	c9                   	leaveq 
  802db2:	c3                   	retq   

0000000000802db3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802db3:	55                   	push   %rbp
  802db4:	48 89 e5             	mov    %rsp,%rbp
  802db7:	48 83 ec 20          	sub    $0x20,%rsp
  802dbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dbf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc7:	8b 50 0c             	mov    0xc(%rax),%edx
  802dca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dd1:	00 00 00 
  802dd4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802dd6:	be 00 00 00 00       	mov    $0x0,%esi
  802ddb:	bf 05 00 00 00       	mov    $0x5,%edi
  802de0:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	callq  *%rax
  802dec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802def:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df3:	79 05                	jns    802dfa <devfile_stat+0x47>
		return r;
  802df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df8:	eb 56                	jmp    802e50 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dfe:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e05:	00 00 00 
  802e08:	48 89 c7             	mov    %rax,%rdi
  802e0b:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e17:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e1e:	00 00 00 
  802e21:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e2b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e31:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e38:	00 00 00 
  802e3b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e45:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e50:	c9                   	leaveq 
  802e51:	c3                   	retq   

0000000000802e52 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e52:	55                   	push   %rbp
  802e53:	48 89 e5             	mov    %rsp,%rbp
  802e56:	48 83 ec 10          	sub    $0x10,%rsp
  802e5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e65:	8b 50 0c             	mov    0xc(%rax),%edx
  802e68:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e6f:	00 00 00 
  802e72:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e74:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e7b:	00 00 00 
  802e7e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e81:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e84:	be 00 00 00 00       	mov    $0x0,%esi
  802e89:	bf 02 00 00 00       	mov    $0x2,%edi
  802e8e:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
}
  802e9a:	c9                   	leaveq 
  802e9b:	c3                   	retq   

0000000000802e9c <remove>:

// Delete a file
int
remove(const char *path)
{
  802e9c:	55                   	push   %rbp
  802e9d:	48 89 e5             	mov    %rsp,%rbp
  802ea0:	48 83 ec 10          	sub    $0x10,%rsp
  802ea4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eac:	48 89 c7             	mov    %rax,%rdi
  802eaf:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  802eb6:	00 00 00 
  802eb9:	ff d0                	callq  *%rax
  802ebb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ec0:	7e 07                	jle    802ec9 <remove+0x2d>
		return -E_BAD_PATH;
  802ec2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ec7:	eb 33                	jmp    802efc <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ecd:	48 89 c6             	mov    %rax,%rsi
  802ed0:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ed7:	00 00 00 
  802eda:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ee6:	be 00 00 00 00       	mov    $0x0,%esi
  802eeb:	bf 07 00 00 00       	mov    $0x7,%edi
  802ef0:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
}
  802efc:	c9                   	leaveq 
  802efd:	c3                   	retq   

0000000000802efe <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802efe:	55                   	push   %rbp
  802eff:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f02:	be 00 00 00 00       	mov    $0x0,%esi
  802f07:	bf 08 00 00 00       	mov    $0x8,%edi
  802f0c:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  802f13:	00 00 00 
  802f16:	ff d0                	callq  *%rax
}
  802f18:	5d                   	pop    %rbp
  802f19:	c3                   	retq   

0000000000802f1a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802f1a:	55                   	push   %rbp
  802f1b:	48 89 e5             	mov    %rsp,%rbp
  802f1e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802f25:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802f2c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f33:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f3a:	be 00 00 00 00       	mov    $0x0,%esi
  802f3f:	48 89 c7             	mov    %rax,%rdi
  802f42:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	callq  *%rax
  802f4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f55:	79 28                	jns    802f7f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5a:	89 c6                	mov    %eax,%esi
  802f5c:	48 bf 55 45 80 00 00 	movabs $0x804555,%rdi
  802f63:	00 00 00 
  802f66:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6b:	48 ba 3e 03 80 00 00 	movabs $0x80033e,%rdx
  802f72:	00 00 00 
  802f75:	ff d2                	callq  *%rdx
		return fd_src;
  802f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7a:	e9 74 01 00 00       	jmpq   8030f3 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f7f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f86:	be 01 01 00 00       	mov    $0x101,%esi
  802f8b:	48 89 c7             	mov    %rax,%rdi
  802f8e:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
  802f9a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f9d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fa1:	79 39                	jns    802fdc <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802fa3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa6:	89 c6                	mov    %eax,%esi
  802fa8:	48 bf 6b 45 80 00 00 	movabs $0x80456b,%rdi
  802faf:	00 00 00 
  802fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb7:	48 ba 3e 03 80 00 00 	movabs $0x80033e,%rdx
  802fbe:	00 00 00 
  802fc1:	ff d2                	callq  *%rdx
		close(fd_src);
  802fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc6:	89 c7                	mov    %eax,%edi
  802fc8:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
		return fd_dest;
  802fd4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fd7:	e9 17 01 00 00       	jmpq   8030f3 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fdc:	eb 74                	jmp    803052 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802fde:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fe1:	48 63 d0             	movslq %eax,%rdx
  802fe4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802feb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fee:	48 89 ce             	mov    %rcx,%rsi
  802ff1:	89 c7                	mov    %eax,%edi
  802ff3:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
  802fff:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803002:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803006:	79 4a                	jns    803052 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803008:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80300b:	89 c6                	mov    %eax,%esi
  80300d:	48 bf 85 45 80 00 00 	movabs $0x804585,%rdi
  803014:	00 00 00 
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
  80301c:	48 ba 3e 03 80 00 00 	movabs $0x80033e,%rdx
  803023:	00 00 00 
  803026:	ff d2                	callq  *%rdx
			close(fd_src);
  803028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302b:	89 c7                	mov    %eax,%edi
  80302d:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  803034:	00 00 00 
  803037:	ff d0                	callq  *%rax
			close(fd_dest);
  803039:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80303c:	89 c7                	mov    %eax,%edi
  80303e:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
			return write_size;
  80304a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80304d:	e9 a1 00 00 00       	jmpq   8030f3 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803052:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305c:	ba 00 02 00 00       	mov    $0x200,%edx
  803061:	48 89 ce             	mov    %rcx,%rsi
  803064:	89 c7                	mov    %eax,%edi
  803066:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803075:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803079:	0f 8f 5f ff ff ff    	jg     802fde <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80307f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803083:	79 47                	jns    8030cc <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803085:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803088:	89 c6                	mov    %eax,%esi
  80308a:	48 bf 98 45 80 00 00 	movabs $0x804598,%rdi
  803091:	00 00 00 
  803094:	b8 00 00 00 00       	mov    $0x0,%eax
  803099:	48 ba 3e 03 80 00 00 	movabs $0x80033e,%rdx
  8030a0:	00 00 00 
  8030a3:	ff d2                	callq  *%rdx
		close(fd_src);
  8030a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a8:	89 c7                	mov    %eax,%edi
  8030aa:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
		close(fd_dest);
  8030b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b9:	89 c7                	mov    %eax,%edi
  8030bb:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
		return read_size;
  8030c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030ca:	eb 27                	jmp    8030f3 <copy+0x1d9>
	}
	close(fd_src);
  8030cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cf:	89 c7                	mov    %eax,%edi
  8030d1:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
	close(fd_dest);
  8030dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e0:	89 c7                	mov    %eax,%edi
  8030e2:	48 b8 a2 23 80 00 00 	movabs $0x8023a2,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
	return 0;
  8030ee:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8030f3:	c9                   	leaveq 
  8030f4:	c3                   	retq   

00000000008030f5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030f5:	55                   	push   %rbp
  8030f6:	48 89 e5             	mov    %rsp,%rbp
  8030f9:	53                   	push   %rbx
  8030fa:	48 83 ec 38          	sub    $0x38,%rsp
  8030fe:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803102:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803106:	48 89 c7             	mov    %rax,%rdi
  803109:	48 b8 fa 20 80 00 00 	movabs $0x8020fa,%rax
  803110:	00 00 00 
  803113:	ff d0                	callq  *%rax
  803115:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803118:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80311c:	0f 88 bf 01 00 00    	js     8032e1 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803122:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803126:	ba 07 04 00 00       	mov    $0x407,%edx
  80312b:	48 89 c6             	mov    %rax,%rsi
  80312e:	bf 00 00 00 00       	mov    $0x0,%edi
  803133:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803142:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803146:	0f 88 95 01 00 00    	js     8032e1 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80314c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803150:	48 89 c7             	mov    %rax,%rdi
  803153:	48 b8 fa 20 80 00 00 	movabs $0x8020fa,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
  80315f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803162:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803166:	0f 88 5d 01 00 00    	js     8032c9 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80316c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803170:	ba 07 04 00 00       	mov    $0x407,%edx
  803175:	48 89 c6             	mov    %rax,%rsi
  803178:	bf 00 00 00 00       	mov    $0x0,%edi
  80317d:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
  803189:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80318c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803190:	0f 88 33 01 00 00    	js     8032c9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803196:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80319a:	48 89 c7             	mov    %rax,%rdi
  80319d:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  8031a4:	00 00 00 
  8031a7:	ff d0                	callq  *%rax
  8031a9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031b1:	ba 07 04 00 00       	mov    $0x407,%edx
  8031b6:	48 89 c6             	mov    %rax,%rsi
  8031b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8031be:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  8031c5:	00 00 00 
  8031c8:	ff d0                	callq  *%rax
  8031ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031d1:	79 05                	jns    8031d8 <pipe+0xe3>
		goto err2;
  8031d3:	e9 d9 00 00 00       	jmpq   8032b1 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031dc:	48 89 c7             	mov    %rax,%rdi
  8031df:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  8031e6:	00 00 00 
  8031e9:	ff d0                	callq  *%rax
  8031eb:	48 89 c2             	mov    %rax,%rdx
  8031ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8031f8:	48 89 d1             	mov    %rdx,%rcx
  8031fb:	ba 00 00 00 00       	mov    $0x0,%edx
  803200:	48 89 c6             	mov    %rax,%rsi
  803203:	bf 00 00 00 00       	mov    $0x0,%edi
  803208:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803217:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80321b:	79 1b                	jns    803238 <pipe+0x143>
		goto err3;
  80321d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80321e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803222:	48 89 c6             	mov    %rax,%rsi
  803225:	bf 00 00 00 00       	mov    $0x0,%edi
  80322a:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803231:	00 00 00 
  803234:	ff d0                	callq  *%rax
  803236:	eb 79                	jmp    8032b1 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803238:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323c:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803243:	00 00 00 
  803246:	8b 12                	mov    (%rdx),%edx
  803248:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80324a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803255:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803259:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803260:	00 00 00 
  803263:	8b 12                	mov    (%rdx),%edx
  803265:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803267:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80326b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803272:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803276:	48 89 c7             	mov    %rax,%rdi
  803279:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
  803285:	89 c2                	mov    %eax,%edx
  803287:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80328b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80328d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803291:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803295:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803299:	48 89 c7             	mov    %rax,%rdi
  80329c:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
  8032a8:	89 03                	mov    %eax,(%rbx)
	return 0;
  8032aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032af:	eb 33                	jmp    8032e4 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8032b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b5:	48 89 c6             	mov    %rax,%rsi
  8032b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8032bd:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8032c4:	00 00 00 
  8032c7:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8032c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032cd:	48 89 c6             	mov    %rax,%rsi
  8032d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d5:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8032dc:	00 00 00 
  8032df:	ff d0                	callq  *%rax
err:
	return r;
  8032e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8032e4:	48 83 c4 38          	add    $0x38,%rsp
  8032e8:	5b                   	pop    %rbx
  8032e9:	5d                   	pop    %rbp
  8032ea:	c3                   	retq   

00000000008032eb <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8032eb:	55                   	push   %rbp
  8032ec:	48 89 e5             	mov    %rsp,%rbp
  8032ef:	53                   	push   %rbx
  8032f0:	48 83 ec 28          	sub    $0x28,%rsp
  8032f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8032fc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803303:	00 00 00 
  803306:	48 8b 00             	mov    (%rax),%rax
  803309:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80330f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803316:	48 89 c7             	mov    %rax,%rdi
  803319:	48 b8 aa 3d 80 00 00 	movabs $0x803daa,%rax
  803320:	00 00 00 
  803323:	ff d0                	callq  *%rax
  803325:	89 c3                	mov    %eax,%ebx
  803327:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332b:	48 89 c7             	mov    %rax,%rdi
  80332e:	48 b8 aa 3d 80 00 00 	movabs $0x803daa,%rax
  803335:	00 00 00 
  803338:	ff d0                	callq  *%rax
  80333a:	39 c3                	cmp    %eax,%ebx
  80333c:	0f 94 c0             	sete   %al
  80333f:	0f b6 c0             	movzbl %al,%eax
  803342:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803345:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80334c:	00 00 00 
  80334f:	48 8b 00             	mov    (%rax),%rax
  803352:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803358:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80335b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80335e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803361:	75 05                	jne    803368 <_pipeisclosed+0x7d>
			return ret;
  803363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803366:	eb 4f                	jmp    8033b7 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80336e:	74 42                	je     8033b2 <_pipeisclosed+0xc7>
  803370:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803374:	75 3c                	jne    8033b2 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803376:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80337d:	00 00 00 
  803380:	48 8b 00             	mov    (%rax),%rax
  803383:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803389:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80338c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80338f:	89 c6                	mov    %eax,%esi
  803391:	48 bf b3 45 80 00 00 	movabs $0x8045b3,%rdi
  803398:	00 00 00 
  80339b:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a0:	49 b8 3e 03 80 00 00 	movabs $0x80033e,%r8
  8033a7:	00 00 00 
  8033aa:	41 ff d0             	callq  *%r8
	}
  8033ad:	e9 4a ff ff ff       	jmpq   8032fc <_pipeisclosed+0x11>
  8033b2:	e9 45 ff ff ff       	jmpq   8032fc <_pipeisclosed+0x11>
}
  8033b7:	48 83 c4 28          	add    $0x28,%rsp
  8033bb:	5b                   	pop    %rbx
  8033bc:	5d                   	pop    %rbp
  8033bd:	c3                   	retq   

00000000008033be <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8033be:	55                   	push   %rbp
  8033bf:	48 89 e5             	mov    %rsp,%rbp
  8033c2:	48 83 ec 30          	sub    $0x30,%rsp
  8033c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033d0:	48 89 d6             	mov    %rdx,%rsi
  8033d3:	89 c7                	mov    %eax,%edi
  8033d5:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  8033dc:	00 00 00 
  8033df:	ff d0                	callq  *%rax
  8033e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e8:	79 05                	jns    8033ef <pipeisclosed+0x31>
		return r;
  8033ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ed:	eb 31                	jmp    803420 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8033ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f3:	48 89 c7             	mov    %rax,%rdi
  8033f6:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  8033fd:	00 00 00 
  803400:	ff d0                	callq  *%rax
  803402:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80340e:	48 89 d6             	mov    %rdx,%rsi
  803411:	48 89 c7             	mov    %rax,%rdi
  803414:	48 b8 eb 32 80 00 00 	movabs $0x8032eb,%rax
  80341b:	00 00 00 
  80341e:	ff d0                	callq  *%rax
}
  803420:	c9                   	leaveq 
  803421:	c3                   	retq   

0000000000803422 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803422:	55                   	push   %rbp
  803423:	48 89 e5             	mov    %rsp,%rbp
  803426:	48 83 ec 40          	sub    $0x40,%rsp
  80342a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80342e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803432:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803436:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80343a:	48 89 c7             	mov    %rax,%rdi
  80343d:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
  803449:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80344d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803451:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803455:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80345c:	00 
  80345d:	e9 92 00 00 00       	jmpq   8034f4 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803462:	eb 41                	jmp    8034a5 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803464:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803469:	74 09                	je     803474 <devpipe_read+0x52>
				return i;
  80346b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346f:	e9 92 00 00 00       	jmpq   803506 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803474:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347c:	48 89 d6             	mov    %rdx,%rsi
  80347f:	48 89 c7             	mov    %rax,%rdi
  803482:	48 b8 eb 32 80 00 00 	movabs $0x8032eb,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
  80348e:	85 c0                	test   %eax,%eax
  803490:	74 07                	je     803499 <devpipe_read+0x77>
				return 0;
  803492:	b8 00 00 00 00       	mov    $0x0,%eax
  803497:	eb 6d                	jmp    803506 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803499:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  8034a0:	00 00 00 
  8034a3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8034a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a9:	8b 10                	mov    (%rax),%edx
  8034ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034af:	8b 40 04             	mov    0x4(%rax),%eax
  8034b2:	39 c2                	cmp    %eax,%edx
  8034b4:	74 ae                	je     803464 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034be:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8034c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c6:	8b 00                	mov    (%rax),%eax
  8034c8:	99                   	cltd   
  8034c9:	c1 ea 1b             	shr    $0x1b,%edx
  8034cc:	01 d0                	add    %edx,%eax
  8034ce:	83 e0 1f             	and    $0x1f,%eax
  8034d1:	29 d0                	sub    %edx,%eax
  8034d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034d7:	48 98                	cltq   
  8034d9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8034de:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8034e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e4:	8b 00                	mov    (%rax),%eax
  8034e6:	8d 50 01             	lea    0x1(%rax),%edx
  8034e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ed:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034fc:	0f 82 60 ff ff ff    	jb     803462 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803506:	c9                   	leaveq 
  803507:	c3                   	retq   

0000000000803508 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803508:	55                   	push   %rbp
  803509:	48 89 e5             	mov    %rsp,%rbp
  80350c:	48 83 ec 40          	sub    $0x40,%rsp
  803510:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803514:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803518:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80351c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803520:	48 89 c7             	mov    %rax,%rdi
  803523:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
  80352f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803537:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80353b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803542:	00 
  803543:	e9 8e 00 00 00       	jmpq   8035d6 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803548:	eb 31                	jmp    80357b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80354a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80354e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803552:	48 89 d6             	mov    %rdx,%rsi
  803555:	48 89 c7             	mov    %rax,%rdi
  803558:	48 b8 eb 32 80 00 00 	movabs $0x8032eb,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
  803564:	85 c0                	test   %eax,%eax
  803566:	74 07                	je     80356f <devpipe_write+0x67>
				return 0;
  803568:	b8 00 00 00 00       	mov    $0x0,%eax
  80356d:	eb 79                	jmp    8035e8 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80356f:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  803576:	00 00 00 
  803579:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80357b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357f:	8b 40 04             	mov    0x4(%rax),%eax
  803582:	48 63 d0             	movslq %eax,%rdx
  803585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803589:	8b 00                	mov    (%rax),%eax
  80358b:	48 98                	cltq   
  80358d:	48 83 c0 20          	add    $0x20,%rax
  803591:	48 39 c2             	cmp    %rax,%rdx
  803594:	73 b4                	jae    80354a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359a:	8b 40 04             	mov    0x4(%rax),%eax
  80359d:	99                   	cltd   
  80359e:	c1 ea 1b             	shr    $0x1b,%edx
  8035a1:	01 d0                	add    %edx,%eax
  8035a3:	83 e0 1f             	and    $0x1f,%eax
  8035a6:	29 d0                	sub    %edx,%eax
  8035a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035ac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8035b0:	48 01 ca             	add    %rcx,%rdx
  8035b3:	0f b6 0a             	movzbl (%rdx),%ecx
  8035b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035ba:	48 98                	cltq   
  8035bc:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8035c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c4:	8b 40 04             	mov    0x4(%rax),%eax
  8035c7:	8d 50 01             	lea    0x1(%rax),%edx
  8035ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ce:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035da:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035de:	0f 82 64 ff ff ff    	jb     803548 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8035e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035e8:	c9                   	leaveq 
  8035e9:	c3                   	retq   

00000000008035ea <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8035ea:	55                   	push   %rbp
  8035eb:	48 89 e5             	mov    %rsp,%rbp
  8035ee:	48 83 ec 20          	sub    $0x20,%rsp
  8035f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8035fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fe:	48 89 c7             	mov    %rax,%rdi
  803601:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  803608:	00 00 00 
  80360b:	ff d0                	callq  *%rax
  80360d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803611:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803615:	48 be c6 45 80 00 00 	movabs $0x8045c6,%rsi
  80361c:	00 00 00 
  80361f:	48 89 c7             	mov    %rax,%rdi
  803622:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80362e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803632:	8b 50 04             	mov    0x4(%rax),%edx
  803635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803639:	8b 00                	mov    (%rax),%eax
  80363b:	29 c2                	sub    %eax,%edx
  80363d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803641:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803647:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80364b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803652:	00 00 00 
	stat->st_dev = &devpipe;
  803655:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803659:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803660:	00 00 00 
  803663:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80366a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80366f:	c9                   	leaveq 
  803670:	c3                   	retq   

0000000000803671 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803671:	55                   	push   %rbp
  803672:	48 89 e5             	mov    %rsp,%rbp
  803675:	48 83 ec 10          	sub    $0x10,%rsp
  803679:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80367d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803681:	48 89 c6             	mov    %rax,%rsi
  803684:	bf 00 00 00 00       	mov    $0x0,%edi
  803689:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803690:	00 00 00 
  803693:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803699:	48 89 c7             	mov    %rax,%rdi
  80369c:	48 b8 cf 20 80 00 00 	movabs $0x8020cf,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
  8036a8:	48 89 c6             	mov    %rax,%rsi
  8036ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b0:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
}
  8036bc:	c9                   	leaveq 
  8036bd:	c3                   	retq   

00000000008036be <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8036be:	55                   	push   %rbp
  8036bf:	48 89 e5             	mov    %rsp,%rbp
  8036c2:	48 83 ec 20          	sub    $0x20,%rsp
  8036c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8036c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036cc:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8036cf:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8036d3:	be 01 00 00 00       	mov    $0x1,%esi
  8036d8:	48 89 c7             	mov    %rax,%rdi
  8036db:	48 b8 ed 16 80 00 00 	movabs $0x8016ed,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
}
  8036e7:	c9                   	leaveq 
  8036e8:	c3                   	retq   

00000000008036e9 <getchar>:

int
getchar(void)
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8036f1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8036f5:	ba 01 00 00 00       	mov    $0x1,%edx
  8036fa:	48 89 c6             	mov    %rax,%rsi
  8036fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803702:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  803709:	00 00 00 
  80370c:	ff d0                	callq  *%rax
  80370e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803711:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803715:	79 05                	jns    80371c <getchar+0x33>
		return r;
  803717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371a:	eb 14                	jmp    803730 <getchar+0x47>
	if (r < 1)
  80371c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803720:	7f 07                	jg     803729 <getchar+0x40>
		return -E_EOF;
  803722:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803727:	eb 07                	jmp    803730 <getchar+0x47>
	return c;
  803729:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80372d:	0f b6 c0             	movzbl %al,%eax
}
  803730:	c9                   	leaveq 
  803731:	c3                   	retq   

0000000000803732 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803732:	55                   	push   %rbp
  803733:	48 89 e5             	mov    %rsp,%rbp
  803736:	48 83 ec 20          	sub    $0x20,%rsp
  80373a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80373d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803741:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803744:	48 89 d6             	mov    %rdx,%rsi
  803747:	89 c7                	mov    %eax,%edi
  803749:	48 b8 92 21 80 00 00 	movabs $0x802192,%rax
  803750:	00 00 00 
  803753:	ff d0                	callq  *%rax
  803755:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375c:	79 05                	jns    803763 <iscons+0x31>
		return r;
  80375e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803761:	eb 1a                	jmp    80377d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803767:	8b 10                	mov    (%rax),%edx
  803769:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803770:	00 00 00 
  803773:	8b 00                	mov    (%rax),%eax
  803775:	39 c2                	cmp    %eax,%edx
  803777:	0f 94 c0             	sete   %al
  80377a:	0f b6 c0             	movzbl %al,%eax
}
  80377d:	c9                   	leaveq 
  80377e:	c3                   	retq   

000000000080377f <opencons>:

int
opencons(void)
{
  80377f:	55                   	push   %rbp
  803780:	48 89 e5             	mov    %rsp,%rbp
  803783:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803787:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80378b:	48 89 c7             	mov    %rax,%rdi
  80378e:	48 b8 fa 20 80 00 00 	movabs $0x8020fa,%rax
  803795:	00 00 00 
  803798:	ff d0                	callq  *%rax
  80379a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a1:	79 05                	jns    8037a8 <opencons+0x29>
		return r;
  8037a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a6:	eb 5b                	jmp    803803 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8037a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ac:	ba 07 04 00 00       	mov    $0x407,%edx
  8037b1:	48 89 c6             	mov    %rax,%rsi
  8037b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b9:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
  8037c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cc:	79 05                	jns    8037d3 <opencons+0x54>
		return r;
  8037ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d1:	eb 30                	jmp    803803 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8037d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d7:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8037de:	00 00 00 
  8037e1:	8b 12                	mov    (%rdx),%edx
  8037e3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8037e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8037f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f4:	48 89 c7             	mov    %rax,%rdi
  8037f7:	48 b8 ac 20 80 00 00 	movabs $0x8020ac,%rax
  8037fe:	00 00 00 
  803801:	ff d0                	callq  *%rax
}
  803803:	c9                   	leaveq 
  803804:	c3                   	retq   

0000000000803805 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803805:	55                   	push   %rbp
  803806:	48 89 e5             	mov    %rsp,%rbp
  803809:	48 83 ec 30          	sub    $0x30,%rsp
  80380d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803811:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803815:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803819:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80381e:	75 07                	jne    803827 <devcons_read+0x22>
		return 0;
  803820:	b8 00 00 00 00       	mov    $0x0,%eax
  803825:	eb 4b                	jmp    803872 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803827:	eb 0c                	jmp    803835 <devcons_read+0x30>
		sys_yield();
  803829:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803835:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
  803841:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803844:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803848:	74 df                	je     803829 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80384a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384e:	79 05                	jns    803855 <devcons_read+0x50>
		return c;
  803850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803853:	eb 1d                	jmp    803872 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803855:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803859:	75 07                	jne    803862 <devcons_read+0x5d>
		return 0;
  80385b:	b8 00 00 00 00       	mov    $0x0,%eax
  803860:	eb 10                	jmp    803872 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803862:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803865:	89 c2                	mov    %eax,%edx
  803867:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80386b:	88 10                	mov    %dl,(%rax)
	return 1;
  80386d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803872:	c9                   	leaveq 
  803873:	c3                   	retq   

0000000000803874 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803874:	55                   	push   %rbp
  803875:	48 89 e5             	mov    %rsp,%rbp
  803878:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80387f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803886:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80388d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80389b:	eb 76                	jmp    803913 <devcons_write+0x9f>
		m = n - tot;
  80389d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8038a4:	89 c2                	mov    %eax,%edx
  8038a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a9:	29 c2                	sub    %eax,%edx
  8038ab:	89 d0                	mov    %edx,%eax
  8038ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8038b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038b3:	83 f8 7f             	cmp    $0x7f,%eax
  8038b6:	76 07                	jbe    8038bf <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8038b8:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8038bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038c2:	48 63 d0             	movslq %eax,%rdx
  8038c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c8:	48 63 c8             	movslq %eax,%rcx
  8038cb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8038d2:	48 01 c1             	add    %rax,%rcx
  8038d5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038dc:	48 89 ce             	mov    %rcx,%rsi
  8038df:	48 89 c7             	mov    %rax,%rdi
  8038e2:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8038ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038f1:	48 63 d0             	movslq %eax,%rdx
  8038f4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038fb:	48 89 d6             	mov    %rdx,%rsi
  8038fe:	48 89 c7             	mov    %rax,%rdi
  803901:	48 b8 ed 16 80 00 00 	movabs $0x8016ed,%rax
  803908:	00 00 00 
  80390b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80390d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803910:	01 45 fc             	add    %eax,-0x4(%rbp)
  803913:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803916:	48 98                	cltq   
  803918:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80391f:	0f 82 78 ff ff ff    	jb     80389d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803925:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803928:	c9                   	leaveq 
  803929:	c3                   	retq   

000000000080392a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80392a:	55                   	push   %rbp
  80392b:	48 89 e5             	mov    %rsp,%rbp
  80392e:	48 83 ec 08          	sub    $0x8,%rsp
  803932:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803936:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80393b:	c9                   	leaveq 
  80393c:	c3                   	retq   

000000000080393d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80393d:	55                   	push   %rbp
  80393e:	48 89 e5             	mov    %rsp,%rbp
  803941:	48 83 ec 10          	sub    $0x10,%rsp
  803945:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803949:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80394d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803951:	48 be d2 45 80 00 00 	movabs $0x8045d2,%rsi
  803958:	00 00 00 
  80395b:	48 89 c7             	mov    %rax,%rdi
  80395e:	48 b8 06 0f 80 00 00 	movabs $0x800f06,%rax
  803965:	00 00 00 
  803968:	ff d0                	callq  *%rax
	return 0;
  80396a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80396f:	c9                   	leaveq 
  803970:	c3                   	retq   

0000000000803971 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803971:	55                   	push   %rbp
  803972:	48 89 e5             	mov    %rsp,%rbp
  803975:	53                   	push   %rbx
  803976:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80397d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803984:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80398a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803991:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803998:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80399f:	84 c0                	test   %al,%al
  8039a1:	74 23                	je     8039c6 <_panic+0x55>
  8039a3:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8039aa:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8039ae:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8039b2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8039b6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8039ba:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8039be:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8039c2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8039c6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8039cd:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8039d4:	00 00 00 
  8039d7:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8039de:	00 00 00 
  8039e1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8039e5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8039ec:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8039f3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8039fa:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803a01:	00 00 00 
  803a04:	48 8b 18             	mov    (%rax),%rbx
  803a07:	48 b8 b9 17 80 00 00 	movabs $0x8017b9,%rax
  803a0e:	00 00 00 
  803a11:	ff d0                	callq  *%rax
  803a13:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803a19:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a20:	41 89 c8             	mov    %ecx,%r8d
  803a23:	48 89 d1             	mov    %rdx,%rcx
  803a26:	48 89 da             	mov    %rbx,%rdx
  803a29:	89 c6                	mov    %eax,%esi
  803a2b:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
  803a32:	00 00 00 
  803a35:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3a:	49 b9 3e 03 80 00 00 	movabs $0x80033e,%r9
  803a41:	00 00 00 
  803a44:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803a47:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803a4e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803a55:	48 89 d6             	mov    %rdx,%rsi
  803a58:	48 89 c7             	mov    %rax,%rdi
  803a5b:	48 b8 92 02 80 00 00 	movabs $0x800292,%rax
  803a62:	00 00 00 
  803a65:	ff d0                	callq  *%rax
	cprintf("\n");
  803a67:	48 bf 03 46 80 00 00 	movabs $0x804603,%rdi
  803a6e:	00 00 00 
  803a71:	b8 00 00 00 00       	mov    $0x0,%eax
  803a76:	48 ba 3e 03 80 00 00 	movabs $0x80033e,%rdx
  803a7d:	00 00 00 
  803a80:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803a82:	cc                   	int3   
  803a83:	eb fd                	jmp    803a82 <_panic+0x111>

0000000000803a85 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a85:	55                   	push   %rbp
  803a86:	48 89 e5             	mov    %rsp,%rbp
  803a89:	48 83 ec 10          	sub    $0x10,%rsp
  803a8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803a91:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803a98:	00 00 00 
  803a9b:	48 8b 00             	mov    (%rax),%rax
  803a9e:	48 85 c0             	test   %rax,%rax
  803aa1:	75 49                	jne    803aec <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803aa3:	ba 07 00 00 00       	mov    $0x7,%edx
  803aa8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803aad:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab2:	48 b8 35 18 80 00 00 	movabs $0x801835,%rax
  803ab9:	00 00 00 
  803abc:	ff d0                	callq  *%rax
  803abe:	85 c0                	test   %eax,%eax
  803ac0:	79 2a                	jns    803aec <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803ac2:	48 ba 08 46 80 00 00 	movabs $0x804608,%rdx
  803ac9:	00 00 00 
  803acc:	be 21 00 00 00       	mov    $0x21,%esi
  803ad1:	48 bf 33 46 80 00 00 	movabs $0x804633,%rdi
  803ad8:	00 00 00 
  803adb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae0:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  803ae7:	00 00 00 
  803aea:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803aec:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803af3:	00 00 00 
  803af6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803afa:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803afd:	48 be 48 3b 80 00 00 	movabs $0x803b48,%rsi
  803b04:	00 00 00 
  803b07:	bf 00 00 00 00       	mov    $0x0,%edi
  803b0c:	48 b8 bf 19 80 00 00 	movabs $0x8019bf,%rax
  803b13:	00 00 00 
  803b16:	ff d0                	callq  *%rax
  803b18:	85 c0                	test   %eax,%eax
  803b1a:	79 2a                	jns    803b46 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803b1c:	48 ba 48 46 80 00 00 	movabs $0x804648,%rdx
  803b23:	00 00 00 
  803b26:	be 27 00 00 00       	mov    $0x27,%esi
  803b2b:	48 bf 33 46 80 00 00 	movabs $0x804633,%rdi
  803b32:	00 00 00 
  803b35:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3a:	48 b9 71 39 80 00 00 	movabs $0x803971,%rcx
  803b41:	00 00 00 
  803b44:	ff d1                	callq  *%rcx
}
  803b46:	c9                   	leaveq 
  803b47:	c3                   	retq   

0000000000803b48 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803b48:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803b4b:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803b52:	00 00 00 
call *%rax
  803b55:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803b57:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803b5e:	00 
    movq 152(%rsp), %rcx
  803b5f:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803b66:	00 
    subq $8, %rcx
  803b67:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803b6b:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803b6e:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803b75:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803b76:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803b7a:	4c 8b 3c 24          	mov    (%rsp),%r15
  803b7e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b83:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b88:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803b8d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803b92:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803b97:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803b9c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803ba1:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803ba6:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803bab:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803bb0:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803bb5:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803bba:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803bbf:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803bc4:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803bc8:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803bcc:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803bcd:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803bce:	c3                   	retq   

0000000000803bcf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803bcf:	55                   	push   %rbp
  803bd0:	48 89 e5             	mov    %rsp,%rbp
  803bd3:	48 83 ec 30          	sub    $0x30,%rsp
  803bd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803be3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803be8:	75 0e                	jne    803bf8 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803bea:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803bf1:	00 00 00 
  803bf4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803bf8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bfc:	48 89 c7             	mov    %rax,%rdi
  803bff:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  803c06:	00 00 00 
  803c09:	ff d0                	callq  *%rax
  803c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c12:	79 27                	jns    803c3b <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803c14:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c19:	74 0a                	je     803c25 <ipc_recv+0x56>
            *from_env_store = 0;
  803c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c1f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803c25:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c2a:	74 0a                	je     803c36 <ipc_recv+0x67>
            *perm_store = 0;
  803c2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c30:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c39:	eb 53                	jmp    803c8e <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803c3b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c40:	74 19                	je     803c5b <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803c42:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c49:	00 00 00 
  803c4c:	48 8b 00             	mov    (%rax),%rax
  803c4f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803c55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c59:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803c5b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c60:	74 19                	je     803c7b <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803c62:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c69:	00 00 00 
  803c6c:	48 8b 00             	mov    (%rax),%rax
  803c6f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803c75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c79:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803c7b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c82:	00 00 00 
  803c85:	48 8b 00             	mov    (%rax),%rax
  803c88:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803c8e:	c9                   	leaveq 
  803c8f:	c3                   	retq   

0000000000803c90 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c90:	55                   	push   %rbp
  803c91:	48 89 e5             	mov    %rsp,%rbp
  803c94:	48 83 ec 30          	sub    $0x30,%rsp
  803c98:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c9b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c9e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ca2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803ca5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803caa:	75 0e                	jne    803cba <ipc_send+0x2a>
        pg = (void *)UTOP;
  803cac:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803cb3:	00 00 00 
  803cb6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803cba:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803cbd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803cc0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cc7:	89 c7                	mov    %eax,%edi
  803cc9:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803cd0:	00 00 00 
  803cd3:	ff d0                	callq  *%rax
  803cd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803cd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cdc:	79 36                	jns    803d14 <ipc_send+0x84>
  803cde:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ce2:	74 30                	je     803d14 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce7:	89 c1                	mov    %eax,%ecx
  803ce9:	48 ba 7f 46 80 00 00 	movabs $0x80467f,%rdx
  803cf0:	00 00 00 
  803cf3:	be 49 00 00 00       	mov    $0x49,%esi
  803cf8:	48 bf 8c 46 80 00 00 	movabs $0x80468c,%rdi
  803cff:	00 00 00 
  803d02:	b8 00 00 00 00       	mov    $0x0,%eax
  803d07:	49 b8 71 39 80 00 00 	movabs $0x803971,%r8
  803d0e:	00 00 00 
  803d11:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803d14:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  803d1b:	00 00 00 
  803d1e:	ff d0                	callq  *%rax
    } while(r != 0);
  803d20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d24:	75 94                	jne    803cba <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803d26:	c9                   	leaveq 
  803d27:	c3                   	retq   

0000000000803d28 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d28:	55                   	push   %rbp
  803d29:	48 89 e5             	mov    %rsp,%rbp
  803d2c:	48 83 ec 14          	sub    $0x14,%rsp
  803d30:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d3a:	eb 5e                	jmp    803d9a <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d3c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d43:	00 00 00 
  803d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d49:	48 63 d0             	movslq %eax,%rdx
  803d4c:	48 89 d0             	mov    %rdx,%rax
  803d4f:	48 c1 e0 03          	shl    $0x3,%rax
  803d53:	48 01 d0             	add    %rdx,%rax
  803d56:	48 c1 e0 05          	shl    $0x5,%rax
  803d5a:	48 01 c8             	add    %rcx,%rax
  803d5d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d63:	8b 00                	mov    (%rax),%eax
  803d65:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d68:	75 2c                	jne    803d96 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d6a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d71:	00 00 00 
  803d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d77:	48 63 d0             	movslq %eax,%rdx
  803d7a:	48 89 d0             	mov    %rdx,%rax
  803d7d:	48 c1 e0 03          	shl    $0x3,%rax
  803d81:	48 01 d0             	add    %rdx,%rax
  803d84:	48 c1 e0 05          	shl    $0x5,%rax
  803d88:	48 01 c8             	add    %rcx,%rax
  803d8b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d91:	8b 40 08             	mov    0x8(%rax),%eax
  803d94:	eb 12                	jmp    803da8 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803d96:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d9a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803da1:	7e 99                	jle    803d3c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803da8:	c9                   	leaveq 
  803da9:	c3                   	retq   

0000000000803daa <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803daa:	55                   	push   %rbp
  803dab:	48 89 e5             	mov    %rsp,%rbp
  803dae:	48 83 ec 18          	sub    $0x18,%rsp
  803db2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803db6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dba:	48 c1 e8 15          	shr    $0x15,%rax
  803dbe:	48 89 c2             	mov    %rax,%rdx
  803dc1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803dc8:	01 00 00 
  803dcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dcf:	83 e0 01             	and    $0x1,%eax
  803dd2:	48 85 c0             	test   %rax,%rax
  803dd5:	75 07                	jne    803dde <pageref+0x34>
		return 0;
  803dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  803ddc:	eb 53                	jmp    803e31 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803dde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803de2:	48 c1 e8 0c          	shr    $0xc,%rax
  803de6:	48 89 c2             	mov    %rax,%rdx
  803de9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803df0:	01 00 00 
  803df3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803df7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dff:	83 e0 01             	and    $0x1,%eax
  803e02:	48 85 c0             	test   %rax,%rax
  803e05:	75 07                	jne    803e0e <pageref+0x64>
		return 0;
  803e07:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0c:	eb 23                	jmp    803e31 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e12:	48 c1 e8 0c          	shr    $0xc,%rax
  803e16:	48 89 c2             	mov    %rax,%rdx
  803e19:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e20:	00 00 00 
  803e23:	48 c1 e2 04          	shl    $0x4,%rdx
  803e27:	48 01 d0             	add    %rdx,%rax
  803e2a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e2e:	0f b7 c0             	movzwl %ax,%eax
}
  803e31:	c9                   	leaveq 
  803e32:	c3                   	retq   
