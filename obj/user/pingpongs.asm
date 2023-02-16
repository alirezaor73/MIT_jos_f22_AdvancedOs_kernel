
obj/user/pingpongs:     file format elf64-x86-64


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
  80003c:	e8 b6 01 00 00       	callq  8001f7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	41 56                	push   %r14
  800049:	41 55                	push   %r13
  80004b:	41 54                	push   %r12
  80004d:	53                   	push   %rbx
  80004e:	48 83 ec 20          	sub    $0x20,%rsp
  800052:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800055:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	envid_t who;
	uint32_t i;

	i = 0;
  800059:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	if ((who = sfork()) != 0) {
  800060:	48 b8 10 21 80 00 00 	movabs $0x802110,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf e0 3e 80 00 00 	movabs $0x803ee0,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 d0 03 80 00 00 	movabs $0x8003d0,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf fa 3e 80 00 00 	movabs $0x803efa,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 d0 03 80 00 00 	movabs $0x8003d0,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 3e 21 80 00 00 	movabs $0x80213e,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf 10 3f 80 00 00 	movabs $0x803f10,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba d0 03 80 00 00 	movabs $0x8003d0,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8001d9:	00 00 00 
  8001dc:	8b 00                	mov    (%rax),%eax
  8001de:	83 f8 0a             	cmp    $0xa,%eax
  8001e1:	75 02                	jne    8001e5 <umain+0x1a2>
			return;
  8001e3:	eb 05                	jmp    8001ea <umain+0x1a7>
	}
  8001e5:	e9 17 ff ff ff       	jmpq   800101 <umain+0xbe>

}
  8001ea:	48 83 c4 20          	add    $0x20,%rsp
  8001ee:	5b                   	pop    %rbx
  8001ef:	41 5c                	pop    %r12
  8001f1:	41 5d                	pop    %r13
  8001f3:	41 5e                	pop    %r14
  8001f5:	5d                   	pop    %rbp
  8001f6:	c3                   	retq   

00000000008001f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 20          	sub    $0x20,%rsp
  8001ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800202:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800206:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800218:	25 ff 03 00 00       	and    $0x3ff,%eax
  80021d:	48 63 d0             	movslq %eax,%rdx
  800220:	48 89 d0             	mov    %rdx,%rax
  800223:	48 c1 e0 03          	shl    $0x3,%rax
  800227:	48 01 d0             	add    %rdx,%rax
  80022a:	48 c1 e0 05          	shl    $0x5,%rax
  80022e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800235:	00 00 00 
  800238:	48 01 c2             	add    %rax,%rdx
  80023b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800242:	00 00 00 
  800245:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800248:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80024c:	7e 14                	jle    800262 <libmain+0x6b>
		binaryname = argv[0];
  80024e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800252:	48 8b 10             	mov    (%rax),%rdx
  800255:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80025c:	00 00 00 
  80025f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800262:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800266:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800269:	48 89 d6             	mov    %rdx,%rsi
  80026c:	89 c7                	mov    %eax,%edi
  80026e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80027a:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800281:	00 00 00 
  800284:	ff d0                	callq  *%rax
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80028c:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800298:	bf 00 00 00 00       	mov    $0x0,%edi
  80029d:	48 b8 07 18 80 00 00 	movabs $0x801807,%rax
  8002a4:	00 00 00 
  8002a7:	ff d0                	callq  *%rax
}
  8002a9:	5d                   	pop    %rbp
  8002aa:	c3                   	retq   

00000000008002ab <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002ab:	55                   	push   %rbp
  8002ac:	48 89 e5             	mov    %rsp,%rbp
  8002af:	48 83 ec 10          	sub    $0x10,%rsp
  8002b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002be:	8b 00                	mov    (%rax),%eax
  8002c0:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c7:	89 0a                	mov    %ecx,(%rdx)
  8002c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002cc:	89 d1                	mov    %edx,%ecx
  8002ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d2:	48 98                	cltq   
  8002d4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002dc:	8b 00                	mov    (%rax),%eax
  8002de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e3:	75 2c                	jne    800311 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e9:	8b 00                	mov    (%rax),%eax
  8002eb:	48 98                	cltq   
  8002ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f1:	48 83 c2 08          	add    $0x8,%rdx
  8002f5:	48 89 c6             	mov    %rax,%rsi
  8002f8:	48 89 d7             	mov    %rdx,%rdi
  8002fb:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  800302:	00 00 00 
  800305:	ff d0                	callq  *%rax
        b->idx = 0;
  800307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800315:	8b 40 04             	mov    0x4(%rax),%eax
  800318:	8d 50 01             	lea    0x1(%rax),%edx
  80031b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80031f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800322:	c9                   	leaveq 
  800323:	c3                   	retq   

0000000000800324 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800324:	55                   	push   %rbp
  800325:	48 89 e5             	mov    %rsp,%rbp
  800328:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80032f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800336:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80033d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800344:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80034b:	48 8b 0a             	mov    (%rdx),%rcx
  80034e:	48 89 08             	mov    %rcx,(%rax)
  800351:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800355:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800359:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800361:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800368:	00 00 00 
    b.cnt = 0;
  80036b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800372:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800375:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80037c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800383:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80038a:	48 89 c6             	mov    %rax,%rsi
  80038d:	48 bf ab 02 80 00 00 	movabs $0x8002ab,%rdi
  800394:	00 00 00 
  800397:	48 b8 83 07 80 00 00 	movabs $0x800783,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8003a3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a9:	48 98                	cltq   
  8003ab:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b2:	48 83 c2 08          	add    $0x8,%rdx
  8003b6:	48 89 c6             	mov    %rax,%rsi
  8003b9:	48 89 d7             	mov    %rdx,%rdi
  8003bc:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003ce:	c9                   	leaveq 
  8003cf:	c3                   	retq   

00000000008003d0 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003d0:	55                   	push   %rbp
  8003d1:	48 89 e5             	mov    %rsp,%rbp
  8003d4:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003db:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003f0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003fe:	84 c0                	test   %al,%al
  800400:	74 20                	je     800422 <cprintf+0x52>
  800402:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800406:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80040a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80040e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800412:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800416:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80041a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80041e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800422:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800429:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800430:	00 00 00 
  800433:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80043a:	00 00 00 
  80043d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800441:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800448:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80044f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800456:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80045d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800464:	48 8b 0a             	mov    (%rdx),%rcx
  800467:	48 89 08             	mov    %rcx,(%rax)
  80046a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80046e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800472:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800476:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80047a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800481:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800488:	48 89 d6             	mov    %rdx,%rsi
  80048b:	48 89 c7             	mov    %rax,%rdi
  80048e:	48 b8 24 03 80 00 00 	movabs $0x800324,%rax
  800495:	00 00 00 
  800498:	ff d0                	callq  *%rax
  80049a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8004a0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a6:	c9                   	leaveq 
  8004a7:	c3                   	retq   

00000000008004a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a8:	55                   	push   %rbp
  8004a9:	48 89 e5             	mov    %rsp,%rbp
  8004ac:	53                   	push   %rbx
  8004ad:	48 83 ec 38          	sub    $0x38,%rsp
  8004b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004bd:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004c0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004cb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004cf:	77 3b                	ja     80050c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d4:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004d8:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004df:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e4:	48 f7 f3             	div    %rbx
  8004e7:	48 89 c2             	mov    %rax,%rdx
  8004ea:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004ed:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f8:	41 89 f9             	mov    %edi,%r9d
  8004fb:	48 89 c7             	mov    %rax,%rdi
  8004fe:	48 b8 a8 04 80 00 00 	movabs $0x8004a8,%rax
  800505:	00 00 00 
  800508:	ff d0                	callq  *%rax
  80050a:	eb 1e                	jmp    80052a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050c:	eb 12                	jmp    800520 <printnum+0x78>
			putch(padc, putdat);
  80050e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800512:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800515:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800519:	48 89 ce             	mov    %rcx,%rsi
  80051c:	89 d7                	mov    %edx,%edi
  80051e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800520:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800524:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800528:	7f e4                	jg     80050e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80052d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800531:	ba 00 00 00 00       	mov    $0x0,%edx
  800536:	48 f7 f1             	div    %rcx
  800539:	48 89 d0             	mov    %rdx,%rax
  80053c:	48 ba 30 41 80 00 00 	movabs $0x804130,%rdx
  800543:	00 00 00 
  800546:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80054a:	0f be d0             	movsbl %al,%edx
  80054d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	48 89 ce             	mov    %rcx,%rsi
  800558:	89 d7                	mov    %edx,%edi
  80055a:	ff d0                	callq  *%rax
}
  80055c:	48 83 c4 38          	add    $0x38,%rsp
  800560:	5b                   	pop    %rbx
  800561:	5d                   	pop    %rbp
  800562:	c3                   	retq   

0000000000800563 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800563:	55                   	push   %rbp
  800564:	48 89 e5             	mov    %rsp,%rbp
  800567:	48 83 ec 1c          	sub    $0x1c,%rsp
  80056b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80056f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800572:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800576:	7e 52                	jle    8005ca <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	8b 00                	mov    (%rax),%eax
  80057e:	83 f8 30             	cmp    $0x30,%eax
  800581:	73 24                	jae    8005a7 <getuint+0x44>
  800583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800587:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058f:	8b 00                	mov    (%rax),%eax
  800591:	89 c0                	mov    %eax,%eax
  800593:	48 01 d0             	add    %rdx,%rax
  800596:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059a:	8b 12                	mov    (%rdx),%edx
  80059c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a3:	89 0a                	mov    %ecx,(%rdx)
  8005a5:	eb 17                	jmp    8005be <getuint+0x5b>
  8005a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005af:	48 89 d0             	mov    %rdx,%rax
  8005b2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005be:	48 8b 00             	mov    (%rax),%rax
  8005c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c5:	e9 a3 00 00 00       	jmpq   80066d <getuint+0x10a>
	else if (lflag)
  8005ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005ce:	74 4f                	je     80061f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d4:	8b 00                	mov    (%rax),%eax
  8005d6:	83 f8 30             	cmp    $0x30,%eax
  8005d9:	73 24                	jae    8005ff <getuint+0x9c>
  8005db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e7:	8b 00                	mov    (%rax),%eax
  8005e9:	89 c0                	mov    %eax,%eax
  8005eb:	48 01 d0             	add    %rdx,%rax
  8005ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f2:	8b 12                	mov    (%rdx),%edx
  8005f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fb:	89 0a                	mov    %ecx,(%rdx)
  8005fd:	eb 17                	jmp    800616 <getuint+0xb3>
  8005ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800603:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800607:	48 89 d0             	mov    %rdx,%rax
  80060a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800612:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800616:	48 8b 00             	mov    (%rax),%rax
  800619:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061d:	eb 4e                	jmp    80066d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	8b 00                	mov    (%rax),%eax
  800625:	83 f8 30             	cmp    $0x30,%eax
  800628:	73 24                	jae    80064e <getuint+0xeb>
  80062a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800636:	8b 00                	mov    (%rax),%eax
  800638:	89 c0                	mov    %eax,%eax
  80063a:	48 01 d0             	add    %rdx,%rax
  80063d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800641:	8b 12                	mov    (%rdx),%edx
  800643:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800646:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064a:	89 0a                	mov    %ecx,(%rdx)
  80064c:	eb 17                	jmp    800665 <getuint+0x102>
  80064e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800652:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800656:	48 89 d0             	mov    %rdx,%rax
  800659:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80065d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800661:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800665:	8b 00                	mov    (%rax),%eax
  800667:	89 c0                	mov    %eax,%eax
  800669:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80066d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800671:	c9                   	leaveq 
  800672:	c3                   	retq   

0000000000800673 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800673:	55                   	push   %rbp
  800674:	48 89 e5             	mov    %rsp,%rbp
  800677:	48 83 ec 1c          	sub    $0x1c,%rsp
  80067b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800682:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800686:	7e 52                	jle    8006da <getint+0x67>
		x=va_arg(*ap, long long);
  800688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068c:	8b 00                	mov    (%rax),%eax
  80068e:	83 f8 30             	cmp    $0x30,%eax
  800691:	73 24                	jae    8006b7 <getint+0x44>
  800693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800697:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069f:	8b 00                	mov    (%rax),%eax
  8006a1:	89 c0                	mov    %eax,%eax
  8006a3:	48 01 d0             	add    %rdx,%rax
  8006a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006aa:	8b 12                	mov    (%rdx),%edx
  8006ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b3:	89 0a                	mov    %ecx,(%rdx)
  8006b5:	eb 17                	jmp    8006ce <getint+0x5b>
  8006b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006bf:	48 89 d0             	mov    %rdx,%rax
  8006c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ce:	48 8b 00             	mov    (%rax),%rax
  8006d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d5:	e9 a3 00 00 00       	jmpq   80077d <getint+0x10a>
	else if (lflag)
  8006da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006de:	74 4f                	je     80072f <getint+0xbc>
		x=va_arg(*ap, long);
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	8b 00                	mov    (%rax),%eax
  8006e6:	83 f8 30             	cmp    $0x30,%eax
  8006e9:	73 24                	jae    80070f <getint+0x9c>
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f7:	8b 00                	mov    (%rax),%eax
  8006f9:	89 c0                	mov    %eax,%eax
  8006fb:	48 01 d0             	add    %rdx,%rax
  8006fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800702:	8b 12                	mov    (%rdx),%edx
  800704:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070b:	89 0a                	mov    %ecx,(%rdx)
  80070d:	eb 17                	jmp    800726 <getint+0xb3>
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800717:	48 89 d0             	mov    %rdx,%rax
  80071a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800722:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800726:	48 8b 00             	mov    (%rax),%rax
  800729:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072d:	eb 4e                	jmp    80077d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80072f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800733:	8b 00                	mov    (%rax),%eax
  800735:	83 f8 30             	cmp    $0x30,%eax
  800738:	73 24                	jae    80075e <getint+0xeb>
  80073a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	8b 00                	mov    (%rax),%eax
  800748:	89 c0                	mov    %eax,%eax
  80074a:	48 01 d0             	add    %rdx,%rax
  80074d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800751:	8b 12                	mov    (%rdx),%edx
  800753:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075a:	89 0a                	mov    %ecx,(%rdx)
  80075c:	eb 17                	jmp    800775 <getint+0x102>
  80075e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800762:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800766:	48 89 d0             	mov    %rdx,%rax
  800769:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800771:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800775:	8b 00                	mov    (%rax),%eax
  800777:	48 98                	cltq   
  800779:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800781:	c9                   	leaveq 
  800782:	c3                   	retq   

0000000000800783 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800783:	55                   	push   %rbp
  800784:	48 89 e5             	mov    %rsp,%rbp
  800787:	41 54                	push   %r12
  800789:	53                   	push   %rbx
  80078a:	48 83 ec 60          	sub    $0x60,%rsp
  80078e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800792:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800796:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80079a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80079e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a6:	48 8b 0a             	mov    (%rdx),%rcx
  8007a9:	48 89 08             	mov    %rcx,(%rax)
  8007ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x52>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 df 04 00 00    	je     800ca5 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8007c6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ce:	48 89 d6             	mov    %rdx,%rsi
  8007d1:	89 df                	mov    %ebx,%edi
  8007d3:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007e1:	0f b6 00             	movzbl (%rax),%eax
  8007e4:	0f b6 d8             	movzbl %al,%ebx
  8007e7:	83 fb 25             	cmp    $0x25,%ebx
  8007ea:	75 d2                	jne    8007be <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ec:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800805:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800810:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800814:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800818:	0f b6 00             	movzbl (%rax),%eax
  80081b:	0f b6 d8             	movzbl %al,%ebx
  80081e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800821:	83 f8 55             	cmp    $0x55,%eax
  800824:	0f 87 47 04 00 00    	ja     800c71 <vprintfmt+0x4ee>
  80082a:	89 c0                	mov    %eax,%eax
  80082c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800833:	00 
  800834:	48 b8 58 41 80 00 00 	movabs $0x804158,%rax
  80083b:	00 00 00 
  80083e:	48 01 d0             	add    %rdx,%rax
  800841:	48 8b 00             	mov    (%rax),%rax
  800844:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800846:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80084a:	eb c0                	jmp    80080c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800850:	eb ba                	jmp    80080c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800852:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800859:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80085c:	89 d0                	mov    %edx,%eax
  80085e:	c1 e0 02             	shl    $0x2,%eax
  800861:	01 d0                	add    %edx,%eax
  800863:	01 c0                	add    %eax,%eax
  800865:	01 d8                	add    %ebx,%eax
  800867:	83 e8 30             	sub    $0x30,%eax
  80086a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80086d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800871:	0f b6 00             	movzbl (%rax),%eax
  800874:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800877:	83 fb 2f             	cmp    $0x2f,%ebx
  80087a:	7e 0c                	jle    800888 <vprintfmt+0x105>
  80087c:	83 fb 39             	cmp    $0x39,%ebx
  80087f:	7f 07                	jg     800888 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800881:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800886:	eb d1                	jmp    800859 <vprintfmt+0xd6>
			goto process_precision;
  800888:	eb 58                	jmp    8008e2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80088a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088d:	83 f8 30             	cmp    $0x30,%eax
  800890:	73 17                	jae    8008a9 <vprintfmt+0x126>
  800892:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800896:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800899:	89 c0                	mov    %eax,%eax
  80089b:	48 01 d0             	add    %rdx,%rax
  80089e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a1:	83 c2 08             	add    $0x8,%edx
  8008a4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a7:	eb 0f                	jmp    8008b8 <vprintfmt+0x135>
  8008a9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ad:	48 89 d0             	mov    %rdx,%rax
  8008b0:	48 83 c2 08          	add    $0x8,%rdx
  8008b4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b8:	8b 00                	mov    (%rax),%eax
  8008ba:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008bd:	eb 23                	jmp    8008e2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c3:	79 0c                	jns    8008d1 <vprintfmt+0x14e>
				width = 0;
  8008c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008cc:	e9 3b ff ff ff       	jmpq   80080c <vprintfmt+0x89>
  8008d1:	e9 36 ff ff ff       	jmpq   80080c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008d6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008dd:	e9 2a ff ff ff       	jmpq   80080c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e6:	79 12                	jns    8008fa <vprintfmt+0x177>
				width = precision, precision = -1;
  8008e8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008eb:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008f5:	e9 12 ff ff ff       	jmpq   80080c <vprintfmt+0x89>
  8008fa:	e9 0d ff ff ff       	jmpq   80080c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ff:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800903:	e9 04 ff ff ff       	jmpq   80080c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800908:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090b:	83 f8 30             	cmp    $0x30,%eax
  80090e:	73 17                	jae    800927 <vprintfmt+0x1a4>
  800910:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800914:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800917:	89 c0                	mov    %eax,%eax
  800919:	48 01 d0             	add    %rdx,%rax
  80091c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091f:	83 c2 08             	add    $0x8,%edx
  800922:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800925:	eb 0f                	jmp    800936 <vprintfmt+0x1b3>
  800927:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092b:	48 89 d0             	mov    %rdx,%rax
  80092e:	48 83 c2 08          	add    $0x8,%rdx
  800932:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800936:	8b 10                	mov    (%rax),%edx
  800938:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80093c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800940:	48 89 ce             	mov    %rcx,%rsi
  800943:	89 d7                	mov    %edx,%edi
  800945:	ff d0                	callq  *%rax
			break;
  800947:	e9 53 03 00 00       	jmpq   800c9f <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80094c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094f:	83 f8 30             	cmp    $0x30,%eax
  800952:	73 17                	jae    80096b <vprintfmt+0x1e8>
  800954:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800958:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095b:	89 c0                	mov    %eax,%eax
  80095d:	48 01 d0             	add    %rdx,%rax
  800960:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800963:	83 c2 08             	add    $0x8,%edx
  800966:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800969:	eb 0f                	jmp    80097a <vprintfmt+0x1f7>
  80096b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096f:	48 89 d0             	mov    %rdx,%rax
  800972:	48 83 c2 08          	add    $0x8,%rdx
  800976:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80097c:	85 db                	test   %ebx,%ebx
  80097e:	79 02                	jns    800982 <vprintfmt+0x1ff>
				err = -err;
  800980:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800982:	83 fb 15             	cmp    $0x15,%ebx
  800985:	7f 16                	jg     80099d <vprintfmt+0x21a>
  800987:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  80098e:	00 00 00 
  800991:	48 63 d3             	movslq %ebx,%rdx
  800994:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800998:	4d 85 e4             	test   %r12,%r12
  80099b:	75 2e                	jne    8009cb <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80099d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a5:	89 d9                	mov    %ebx,%ecx
  8009a7:	48 ba 41 41 80 00 00 	movabs $0x804141,%rdx
  8009ae:	00 00 00 
  8009b1:	48 89 c7             	mov    %rax,%rdi
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b9:	49 b8 ae 0c 80 00 00 	movabs $0x800cae,%r8
  8009c0:	00 00 00 
  8009c3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c6:	e9 d4 02 00 00       	jmpq   800c9f <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009cb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d3:	4c 89 e1             	mov    %r12,%rcx
  8009d6:	48 ba 4a 41 80 00 00 	movabs $0x80414a,%rdx
  8009dd:	00 00 00 
  8009e0:	48 89 c7             	mov    %rax,%rdi
  8009e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e8:	49 b8 ae 0c 80 00 00 	movabs $0x800cae,%r8
  8009ef:	00 00 00 
  8009f2:	41 ff d0             	callq  *%r8
			break;
  8009f5:	e9 a5 02 00 00       	jmpq   800c9f <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fd:	83 f8 30             	cmp    $0x30,%eax
  800a00:	73 17                	jae    800a19 <vprintfmt+0x296>
  800a02:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a09:	89 c0                	mov    %eax,%eax
  800a0b:	48 01 d0             	add    %rdx,%rax
  800a0e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a11:	83 c2 08             	add    $0x8,%edx
  800a14:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a17:	eb 0f                	jmp    800a28 <vprintfmt+0x2a5>
  800a19:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1d:	48 89 d0             	mov    %rdx,%rax
  800a20:	48 83 c2 08          	add    $0x8,%rdx
  800a24:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a28:	4c 8b 20             	mov    (%rax),%r12
  800a2b:	4d 85 e4             	test   %r12,%r12
  800a2e:	75 0a                	jne    800a3a <vprintfmt+0x2b7>
				p = "(null)";
  800a30:	49 bc 4d 41 80 00 00 	movabs $0x80414d,%r12
  800a37:	00 00 00 
			if (width > 0 && padc != '-')
  800a3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3e:	7e 3f                	jle    800a7f <vprintfmt+0x2fc>
  800a40:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a44:	74 39                	je     800a7f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a46:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a49:	48 98                	cltq   
  800a4b:	48 89 c6             	mov    %rax,%rsi
  800a4e:	4c 89 e7             	mov    %r12,%rdi
  800a51:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  800a58:	00 00 00 
  800a5b:	ff d0                	callq  *%rax
  800a5d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a60:	eb 17                	jmp    800a79 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a62:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a66:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6e:	48 89 ce             	mov    %rcx,%rsi
  800a71:	89 d7                	mov    %edx,%edi
  800a73:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a75:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a7d:	7f e3                	jg     800a62 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7f:	eb 37                	jmp    800ab8 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a81:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a85:	74 1e                	je     800aa5 <vprintfmt+0x322>
  800a87:	83 fb 1f             	cmp    $0x1f,%ebx
  800a8a:	7e 05                	jle    800a91 <vprintfmt+0x30e>
  800a8c:	83 fb 7e             	cmp    $0x7e,%ebx
  800a8f:	7e 14                	jle    800aa5 <vprintfmt+0x322>
					putch('?', putdat);
  800a91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a99:	48 89 d6             	mov    %rdx,%rsi
  800a9c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800aa1:	ff d0                	callq  *%rax
  800aa3:	eb 0f                	jmp    800ab4 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800aa5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aad:	48 89 d6             	mov    %rdx,%rsi
  800ab0:	89 df                	mov    %ebx,%edi
  800ab2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab8:	4c 89 e0             	mov    %r12,%rax
  800abb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800abf:	0f b6 00             	movzbl (%rax),%eax
  800ac2:	0f be d8             	movsbl %al,%ebx
  800ac5:	85 db                	test   %ebx,%ebx
  800ac7:	74 10                	je     800ad9 <vprintfmt+0x356>
  800ac9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800acd:	78 b2                	js     800a81 <vprintfmt+0x2fe>
  800acf:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ad3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad7:	79 a8                	jns    800a81 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad9:	eb 16                	jmp    800af1 <vprintfmt+0x36e>
				putch(' ', putdat);
  800adb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800adf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae3:	48 89 d6             	mov    %rdx,%rsi
  800ae6:	bf 20 00 00 00       	mov    $0x20,%edi
  800aeb:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aed:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af5:	7f e4                	jg     800adb <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800af7:	e9 a3 01 00 00       	jmpq   800c9f <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800afc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b00:	be 03 00 00 00       	mov    $0x3,%esi
  800b05:	48 89 c7             	mov    %rax,%rdi
  800b08:	48 b8 73 06 80 00 00 	movabs $0x800673,%rax
  800b0f:	00 00 00 
  800b12:	ff d0                	callq  *%rax
  800b14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1c:	48 85 c0             	test   %rax,%rax
  800b1f:	79 1d                	jns    800b3e <vprintfmt+0x3bb>
				putch('-', putdat);
  800b21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b29:	48 89 d6             	mov    %rdx,%rsi
  800b2c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b31:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b37:	48 f7 d8             	neg    %rax
  800b3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b3e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b45:	e9 e8 00 00 00       	jmpq   800c32 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b4a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4e:	be 03 00 00 00       	mov    $0x3,%esi
  800b53:	48 89 c7             	mov    %rax,%rdi
  800b56:	48 b8 63 05 80 00 00 	movabs $0x800563,%rax
  800b5d:	00 00 00 
  800b60:	ff d0                	callq  *%rax
  800b62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b66:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b6d:	e9 c0 00 00 00       	jmpq   800c32 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7a:	48 89 d6             	mov    %rdx,%rsi
  800b7d:	bf 58 00 00 00       	mov    $0x58,%edi
  800b82:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8c:	48 89 d6             	mov    %rdx,%rsi
  800b8f:	bf 58 00 00 00       	mov    $0x58,%edi
  800b94:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9e:	48 89 d6             	mov    %rdx,%rsi
  800ba1:	bf 58 00 00 00       	mov    $0x58,%edi
  800ba6:	ff d0                	callq  *%rax
			break;
  800ba8:	e9 f2 00 00 00       	jmpq   800c9f <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800bad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb5:	48 89 d6             	mov    %rdx,%rsi
  800bb8:	bf 30 00 00 00       	mov    $0x30,%edi
  800bbd:	ff d0                	callq  *%rax
			putch('x', putdat);
  800bbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc7:	48 89 d6             	mov    %rdx,%rsi
  800bca:	bf 78 00 00 00       	mov    $0x78,%edi
  800bcf:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd4:	83 f8 30             	cmp    $0x30,%eax
  800bd7:	73 17                	jae    800bf0 <vprintfmt+0x46d>
  800bd9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bdd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be0:	89 c0                	mov    %eax,%eax
  800be2:	48 01 d0             	add    %rdx,%rax
  800be5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800be8:	83 c2 08             	add    $0x8,%edx
  800beb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bee:	eb 0f                	jmp    800bff <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800bf0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bf4:	48 89 d0             	mov    %rdx,%rax
  800bf7:	48 83 c2 08          	add    $0x8,%rdx
  800bfb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bff:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c06:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c0d:	eb 23                	jmp    800c32 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c13:	be 03 00 00 00       	mov    $0x3,%esi
  800c18:	48 89 c7             	mov    %rax,%rdi
  800c1b:	48 b8 63 05 80 00 00 	movabs $0x800563,%rax
  800c22:	00 00 00 
  800c25:	ff d0                	callq  *%rax
  800c27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c2b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c32:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c37:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c3a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c3d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c41:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c49:	45 89 c1             	mov    %r8d,%r9d
  800c4c:	41 89 f8             	mov    %edi,%r8d
  800c4f:	48 89 c7             	mov    %rax,%rdi
  800c52:	48 b8 a8 04 80 00 00 	movabs $0x8004a8,%rax
  800c59:	00 00 00 
  800c5c:	ff d0                	callq  *%rax
			break;
  800c5e:	eb 3f                	jmp    800c9f <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c60:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c68:	48 89 d6             	mov    %rdx,%rsi
  800c6b:	89 df                	mov    %ebx,%edi
  800c6d:	ff d0                	callq  *%rax
			break;
  800c6f:	eb 2e                	jmp    800c9f <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c79:	48 89 d6             	mov    %rdx,%rsi
  800c7c:	bf 25 00 00 00       	mov    $0x25,%edi
  800c81:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c83:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c88:	eb 05                	jmp    800c8f <vprintfmt+0x50c>
  800c8a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c8f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c93:	48 83 e8 01          	sub    $0x1,%rax
  800c97:	0f b6 00             	movzbl (%rax),%eax
  800c9a:	3c 25                	cmp    $0x25,%al
  800c9c:	75 ec                	jne    800c8a <vprintfmt+0x507>
				/* do nothing */;
			break;
  800c9e:	90                   	nop
		}
	}
  800c9f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca0:	e9 30 fb ff ff       	jmpq   8007d5 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ca5:	48 83 c4 60          	add    $0x60,%rsp
  800ca9:	5b                   	pop    %rbx
  800caa:	41 5c                	pop    %r12
  800cac:	5d                   	pop    %rbp
  800cad:	c3                   	retq   

0000000000800cae <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cae:	55                   	push   %rbp
  800caf:	48 89 e5             	mov    %rsp,%rbp
  800cb2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800cb9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cc0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cc7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cce:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cd5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cdc:	84 c0                	test   %al,%al
  800cde:	74 20                	je     800d00 <printfmt+0x52>
  800ce0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ce4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ce8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cec:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cf0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cf4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cf8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cfc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d00:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d07:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d0e:	00 00 00 
  800d11:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d18:	00 00 00 
  800d1b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d1f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d26:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d2d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d34:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d3b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d42:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d49:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d50:	48 89 c7             	mov    %rax,%rdi
  800d53:	48 b8 83 07 80 00 00 	movabs $0x800783,%rax
  800d5a:	00 00 00 
  800d5d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d5f:	c9                   	leaveq 
  800d60:	c3                   	retq   

0000000000800d61 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d61:	55                   	push   %rbp
  800d62:	48 89 e5             	mov    %rsp,%rbp
  800d65:	48 83 ec 10          	sub    $0x10,%rsp
  800d69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d74:	8b 40 10             	mov    0x10(%rax),%eax
  800d77:	8d 50 01             	lea    0x1(%rax),%edx
  800d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d85:	48 8b 10             	mov    (%rax),%rdx
  800d88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d90:	48 39 c2             	cmp    %rax,%rdx
  800d93:	73 17                	jae    800dac <sprintputch+0x4b>
		*b->buf++ = ch;
  800d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d99:	48 8b 00             	mov    (%rax),%rax
  800d9c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800da4:	48 89 0a             	mov    %rcx,(%rdx)
  800da7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800daa:	88 10                	mov    %dl,(%rax)
}
  800dac:	c9                   	leaveq 
  800dad:	c3                   	retq   

0000000000800dae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dae:	55                   	push   %rbp
  800daf:	48 89 e5             	mov    %rsp,%rbp
  800db2:	48 83 ec 50          	sub    $0x50,%rsp
  800db6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800dba:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800dbd:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dc1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dc5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800dc9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800dcd:	48 8b 0a             	mov    (%rdx),%rcx
  800dd0:	48 89 08             	mov    %rcx,(%rax)
  800dd3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dd7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ddb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ddf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800de3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800de7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800deb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dee:	48 98                	cltq   
  800df0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800df4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800df8:	48 01 d0             	add    %rdx,%rax
  800dfb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e06:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e0b:	74 06                	je     800e13 <vsnprintf+0x65>
  800e0d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e11:	7f 07                	jg     800e1a <vsnprintf+0x6c>
		return -E_INVAL;
  800e13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e18:	eb 2f                	jmp    800e49 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e1a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e1e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e22:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e26:	48 89 c6             	mov    %rax,%rsi
  800e29:	48 bf 61 0d 80 00 00 	movabs $0x800d61,%rdi
  800e30:	00 00 00 
  800e33:	48 b8 83 07 80 00 00 	movabs $0x800783,%rax
  800e3a:	00 00 00 
  800e3d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e43:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e46:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e49:	c9                   	leaveq 
  800e4a:	c3                   	retq   

0000000000800e4b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e4b:	55                   	push   %rbp
  800e4c:	48 89 e5             	mov    %rsp,%rbp
  800e4f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e56:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e5d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e63:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e6a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e71:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e78:	84 c0                	test   %al,%al
  800e7a:	74 20                	je     800e9c <snprintf+0x51>
  800e7c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e80:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e84:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e88:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e8c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e90:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e94:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e98:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e9c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ea3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800eaa:	00 00 00 
  800ead:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800eb4:	00 00 00 
  800eb7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ebb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ec2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ec9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ed0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ed7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ede:	48 8b 0a             	mov    (%rdx),%rcx
  800ee1:	48 89 08             	mov    %rcx,(%rax)
  800ee4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ef4:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800efb:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f02:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f08:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f0f:	48 89 c7             	mov    %rax,%rdi
  800f12:	48 b8 ae 0d 80 00 00 	movabs $0x800dae,%rax
  800f19:	00 00 00 
  800f1c:	ff d0                	callq  *%rax
  800f1e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f24:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f2a:	c9                   	leaveq 
  800f2b:	c3                   	retq   

0000000000800f2c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f2c:	55                   	push   %rbp
  800f2d:	48 89 e5             	mov    %rsp,%rbp
  800f30:	48 83 ec 18          	sub    $0x18,%rsp
  800f34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f3f:	eb 09                	jmp    800f4a <strlen+0x1e>
		n++;
  800f41:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f45:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4e:	0f b6 00             	movzbl (%rax),%eax
  800f51:	84 c0                	test   %al,%al
  800f53:	75 ec                	jne    800f41 <strlen+0x15>
		n++;
	return n;
  800f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 20          	sub    $0x20,%rsp
  800f62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f71:	eb 0e                	jmp    800f81 <strnlen+0x27>
		n++;
  800f73:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f77:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f7c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f81:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f86:	74 0b                	je     800f93 <strnlen+0x39>
  800f88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8c:	0f b6 00             	movzbl (%rax),%eax
  800f8f:	84 c0                	test   %al,%al
  800f91:	75 e0                	jne    800f73 <strnlen+0x19>
		n++;
	return n;
  800f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 83 ec 20          	sub    $0x20,%rsp
  800fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fb0:	90                   	nop
  800fb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fb9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fbd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fc1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fc5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fc9:	0f b6 12             	movzbl (%rdx),%edx
  800fcc:	88 10                	mov    %dl,(%rax)
  800fce:	0f b6 00             	movzbl (%rax),%eax
  800fd1:	84 c0                	test   %al,%al
  800fd3:	75 dc                	jne    800fb1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fd9:	c9                   	leaveq 
  800fda:	c3                   	retq   

0000000000800fdb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fdb:	55                   	push   %rbp
  800fdc:	48 89 e5             	mov    %rsp,%rbp
  800fdf:	48 83 ec 20          	sub    $0x20,%rsp
  800fe3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fef:	48 89 c7             	mov    %rax,%rdi
  800ff2:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  800ff9:	00 00 00 
  800ffc:	ff d0                	callq  *%rax
  800ffe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801004:	48 63 d0             	movslq %eax,%rdx
  801007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100b:	48 01 c2             	add    %rax,%rdx
  80100e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801012:	48 89 c6             	mov    %rax,%rsi
  801015:	48 89 d7             	mov    %rdx,%rdi
  801018:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  80101f:	00 00 00 
  801022:	ff d0                	callq  *%rax
	return dst;
  801024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801028:	c9                   	leaveq 
  801029:	c3                   	retq   

000000000080102a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80102a:	55                   	push   %rbp
  80102b:	48 89 e5             	mov    %rsp,%rbp
  80102e:	48 83 ec 28          	sub    $0x28,%rsp
  801032:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801036:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80103a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80103e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801042:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801046:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80104d:	00 
  80104e:	eb 2a                	jmp    80107a <strncpy+0x50>
		*dst++ = *src;
  801050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801054:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801058:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80105c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801060:	0f b6 12             	movzbl (%rdx),%edx
  801063:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801065:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801069:	0f b6 00             	movzbl (%rax),%eax
  80106c:	84 c0                	test   %al,%al
  80106e:	74 05                	je     801075 <strncpy+0x4b>
			src++;
  801070:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801075:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801082:	72 cc                	jb     801050 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 28          	sub    $0x28,%rsp
  801092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801096:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80109a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010a6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010ab:	74 3d                	je     8010ea <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8010ad:	eb 1d                	jmp    8010cc <strlcpy+0x42>
			*dst++ = *src++;
  8010af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010bf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010c3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010c7:	0f b6 12             	movzbl (%rdx),%edx
  8010ca:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010cc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010d1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010d6:	74 0b                	je     8010e3 <strlcpy+0x59>
  8010d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010dc:	0f b6 00             	movzbl (%rax),%eax
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 cc                	jne    8010af <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f2:	48 29 c2             	sub    %rax,%rdx
  8010f5:	48 89 d0             	mov    %rdx,%rax
}
  8010f8:	c9                   	leaveq 
  8010f9:	c3                   	retq   

00000000008010fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	48 83 ec 10          	sub    $0x10,%rsp
  801102:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801106:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80110a:	eb 0a                	jmp    801116 <strcmp+0x1c>
		p++, q++;
  80110c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801111:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	84 c0                	test   %al,%al
  80111f:	74 12                	je     801133 <strcmp+0x39>
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801125:	0f b6 10             	movzbl (%rax),%edx
  801128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112c:	0f b6 00             	movzbl (%rax),%eax
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 d9                	je     80110c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801137:	0f b6 00             	movzbl (%rax),%eax
  80113a:	0f b6 d0             	movzbl %al,%edx
  80113d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801141:	0f b6 00             	movzbl (%rax),%eax
  801144:	0f b6 c0             	movzbl %al,%eax
  801147:	29 c2                	sub    %eax,%edx
  801149:	89 d0                	mov    %edx,%eax
}
  80114b:	c9                   	leaveq 
  80114c:	c3                   	retq   

000000000080114d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80114d:	55                   	push   %rbp
  80114e:	48 89 e5             	mov    %rsp,%rbp
  801151:	48 83 ec 18          	sub    $0x18,%rsp
  801155:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801159:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80115d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801161:	eb 0f                	jmp    801172 <strncmp+0x25>
		n--, p++, q++;
  801163:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801168:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80116d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801172:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801177:	74 1d                	je     801196 <strncmp+0x49>
  801179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117d:	0f b6 00             	movzbl (%rax),%eax
  801180:	84 c0                	test   %al,%al
  801182:	74 12                	je     801196 <strncmp+0x49>
  801184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801188:	0f b6 10             	movzbl (%rax),%edx
  80118b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118f:	0f b6 00             	movzbl (%rax),%eax
  801192:	38 c2                	cmp    %al,%dl
  801194:	74 cd                	je     801163 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801196:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119b:	75 07                	jne    8011a4 <strncmp+0x57>
		return 0;
  80119d:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a2:	eb 18                	jmp    8011bc <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a8:	0f b6 00             	movzbl (%rax),%eax
  8011ab:	0f b6 d0             	movzbl %al,%edx
  8011ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b2:	0f b6 00             	movzbl (%rax),%eax
  8011b5:	0f b6 c0             	movzbl %al,%eax
  8011b8:	29 c2                	sub    %eax,%edx
  8011ba:	89 d0                	mov    %edx,%eax
}
  8011bc:	c9                   	leaveq 
  8011bd:	c3                   	retq   

00000000008011be <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011be:	55                   	push   %rbp
  8011bf:	48 89 e5             	mov    %rsp,%rbp
  8011c2:	48 83 ec 0c          	sub    $0xc,%rsp
  8011c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ca:	89 f0                	mov    %esi,%eax
  8011cc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011cf:	eb 17                	jmp    8011e8 <strchr+0x2a>
		if (*s == c)
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	0f b6 00             	movzbl (%rax),%eax
  8011d8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011db:	75 06                	jne    8011e3 <strchr+0x25>
			return (char *) s;
  8011dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e1:	eb 15                	jmp    8011f8 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ec:	0f b6 00             	movzbl (%rax),%eax
  8011ef:	84 c0                	test   %al,%al
  8011f1:	75 de                	jne    8011d1 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f8:	c9                   	leaveq 
  8011f9:	c3                   	retq   

00000000008011fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011fa:	55                   	push   %rbp
  8011fb:	48 89 e5             	mov    %rsp,%rbp
  8011fe:	48 83 ec 0c          	sub    $0xc,%rsp
  801202:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801206:	89 f0                	mov    %esi,%eax
  801208:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80120b:	eb 13                	jmp    801220 <strfind+0x26>
		if (*s == c)
  80120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801211:	0f b6 00             	movzbl (%rax),%eax
  801214:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801217:	75 02                	jne    80121b <strfind+0x21>
			break;
  801219:	eb 10                	jmp    80122b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80121b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801224:	0f b6 00             	movzbl (%rax),%eax
  801227:	84 c0                	test   %al,%al
  801229:	75 e2                	jne    80120d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80122f:	c9                   	leaveq 
  801230:	c3                   	retq   

0000000000801231 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801231:	55                   	push   %rbp
  801232:	48 89 e5             	mov    %rsp,%rbp
  801235:	48 83 ec 18          	sub    $0x18,%rsp
  801239:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80123d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801240:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801244:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801249:	75 06                	jne    801251 <memset+0x20>
		return v;
  80124b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124f:	eb 69                	jmp    8012ba <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801255:	83 e0 03             	and    $0x3,%eax
  801258:	48 85 c0             	test   %rax,%rax
  80125b:	75 48                	jne    8012a5 <memset+0x74>
  80125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801261:	83 e0 03             	and    $0x3,%eax
  801264:	48 85 c0             	test   %rax,%rax
  801267:	75 3c                	jne    8012a5 <memset+0x74>
		c &= 0xFF;
  801269:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801270:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801273:	c1 e0 18             	shl    $0x18,%eax
  801276:	89 c2                	mov    %eax,%edx
  801278:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80127b:	c1 e0 10             	shl    $0x10,%eax
  80127e:	09 c2                	or     %eax,%edx
  801280:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801283:	c1 e0 08             	shl    $0x8,%eax
  801286:	09 d0                	or     %edx,%eax
  801288:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80128b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128f:	48 c1 e8 02          	shr    $0x2,%rax
  801293:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801296:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80129d:	48 89 d7             	mov    %rdx,%rdi
  8012a0:	fc                   	cld    
  8012a1:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012a3:	eb 11                	jmp    8012b6 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012b0:	48 89 d7             	mov    %rdx,%rdi
  8012b3:	fc                   	cld    
  8012b4:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ba:	c9                   	leaveq 
  8012bb:	c3                   	retq   

00000000008012bc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012bc:	55                   	push   %rbp
  8012bd:	48 89 e5             	mov    %rsp,%rbp
  8012c0:	48 83 ec 28          	sub    $0x28,%rsp
  8012c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e8:	0f 83 88 00 00 00    	jae    801376 <memmove+0xba>
  8012ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f6:	48 01 d0             	add    %rdx,%rax
  8012f9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012fd:	76 77                	jbe    801376 <memmove+0xba>
		s += n;
  8012ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801303:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	83 e0 03             	and    $0x3,%eax
  801316:	48 85 c0             	test   %rax,%rax
  801319:	75 3b                	jne    801356 <memmove+0x9a>
  80131b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 2f                	jne    801356 <memmove+0x9a>
  801327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132b:	83 e0 03             	and    $0x3,%eax
  80132e:	48 85 c0             	test   %rax,%rax
  801331:	75 23                	jne    801356 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801337:	48 83 e8 04          	sub    $0x4,%rax
  80133b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133f:	48 83 ea 04          	sub    $0x4,%rdx
  801343:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801347:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80134b:	48 89 c7             	mov    %rax,%rdi
  80134e:	48 89 d6             	mov    %rdx,%rsi
  801351:	fd                   	std    
  801352:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801354:	eb 1d                	jmp    801373 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801356:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80135e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801362:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136a:	48 89 d7             	mov    %rdx,%rdi
  80136d:	48 89 c1             	mov    %rax,%rcx
  801370:	fd                   	std    
  801371:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801373:	fc                   	cld    
  801374:	eb 57                	jmp    8013cd <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	83 e0 03             	and    $0x3,%eax
  80137d:	48 85 c0             	test   %rax,%rax
  801380:	75 36                	jne    8013b8 <memmove+0xfc>
  801382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801386:	83 e0 03             	and    $0x3,%eax
  801389:	48 85 c0             	test   %rax,%rax
  80138c:	75 2a                	jne    8013b8 <memmove+0xfc>
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	83 e0 03             	and    $0x3,%eax
  801395:	48 85 c0             	test   %rax,%rax
  801398:	75 1e                	jne    8013b8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80139a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139e:	48 c1 e8 02          	shr    $0x2,%rax
  8013a2:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ad:	48 89 c7             	mov    %rax,%rdi
  8013b0:	48 89 d6             	mov    %rdx,%rsi
  8013b3:	fc                   	cld    
  8013b4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013b6:	eb 15                	jmp    8013cd <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013c4:	48 89 c7             	mov    %rax,%rdi
  8013c7:	48 89 d6             	mov    %rdx,%rsi
  8013ca:	fc                   	cld    
  8013cb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 83 ec 18          	sub    $0x18,%rsp
  8013db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013eb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f3:	48 89 ce             	mov    %rcx,%rsi
  8013f6:	48 89 c7             	mov    %rax,%rdi
  8013f9:	48 b8 bc 12 80 00 00 	movabs $0x8012bc,%rax
  801400:	00 00 00 
  801403:	ff d0                	callq  *%rax
}
  801405:	c9                   	leaveq 
  801406:	c3                   	retq   

0000000000801407 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801407:	55                   	push   %rbp
  801408:	48 89 e5             	mov    %rsp,%rbp
  80140b:	48 83 ec 28          	sub    $0x28,%rsp
  80140f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801413:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801417:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80141b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801423:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801427:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80142b:	eb 36                	jmp    801463 <memcmp+0x5c>
		if (*s1 != *s2)
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801431:	0f b6 10             	movzbl (%rax),%edx
  801434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	38 c2                	cmp    %al,%dl
  80143d:	74 1a                	je     801459 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80143f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	0f b6 d0             	movzbl %al,%edx
  801449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	0f b6 c0             	movzbl %al,%eax
  801453:	29 c2                	sub    %eax,%edx
  801455:	89 d0                	mov    %edx,%eax
  801457:	eb 20                	jmp    801479 <memcmp+0x72>
		s1++, s2++;
  801459:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801463:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801467:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80146b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80146f:	48 85 c0             	test   %rax,%rax
  801472:	75 b9                	jne    80142d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801479:	c9                   	leaveq 
  80147a:	c3                   	retq   

000000000080147b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80147b:	55                   	push   %rbp
  80147c:	48 89 e5             	mov    %rsp,%rbp
  80147f:	48 83 ec 28          	sub    $0x28,%rsp
  801483:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801487:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80148a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80148e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801492:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801496:	48 01 d0             	add    %rdx,%rax
  801499:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80149d:	eb 15                	jmp    8014b4 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80149f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a3:	0f b6 10             	movzbl (%rax),%edx
  8014a6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014a9:	38 c2                	cmp    %al,%dl
  8014ab:	75 02                	jne    8014af <memfind+0x34>
			break;
  8014ad:	eb 0f                	jmp    8014be <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014af:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014bc:	72 e1                	jb     80149f <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014c2:	c9                   	leaveq 
  8014c3:	c3                   	retq   

00000000008014c4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014c4:	55                   	push   %rbp
  8014c5:	48 89 e5             	mov    %rsp,%rbp
  8014c8:	48 83 ec 34          	sub    $0x34,%rsp
  8014cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014d4:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014de:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014e5:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014e6:	eb 05                	jmp    8014ed <strtol+0x29>
		s++;
  8014e8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	3c 20                	cmp    $0x20,%al
  8014f6:	74 f0                	je     8014e8 <strtol+0x24>
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	3c 09                	cmp    $0x9,%al
  801501:	74 e5                	je     8014e8 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	3c 2b                	cmp    $0x2b,%al
  80150c:	75 07                	jne    801515 <strtol+0x51>
		s++;
  80150e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801513:	eb 17                	jmp    80152c <strtol+0x68>
	else if (*s == '-')
  801515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801519:	0f b6 00             	movzbl (%rax),%eax
  80151c:	3c 2d                	cmp    $0x2d,%al
  80151e:	75 0c                	jne    80152c <strtol+0x68>
		s++, neg = 1;
  801520:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801525:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80152c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801530:	74 06                	je     801538 <strtol+0x74>
  801532:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801536:	75 28                	jne    801560 <strtol+0x9c>
  801538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	3c 30                	cmp    $0x30,%al
  801541:	75 1d                	jne    801560 <strtol+0x9c>
  801543:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801547:	48 83 c0 01          	add    $0x1,%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	3c 78                	cmp    $0x78,%al
  801550:	75 0e                	jne    801560 <strtol+0x9c>
		s += 2, base = 16;
  801552:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801557:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80155e:	eb 2c                	jmp    80158c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801560:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801564:	75 19                	jne    80157f <strtol+0xbb>
  801566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156a:	0f b6 00             	movzbl (%rax),%eax
  80156d:	3c 30                	cmp    $0x30,%al
  80156f:	75 0e                	jne    80157f <strtol+0xbb>
		s++, base = 8;
  801571:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801576:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80157d:	eb 0d                	jmp    80158c <strtol+0xc8>
	else if (base == 0)
  80157f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801583:	75 07                	jne    80158c <strtol+0xc8>
		base = 10;
  801585:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80158c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	3c 2f                	cmp    $0x2f,%al
  801595:	7e 1d                	jle    8015b4 <strtol+0xf0>
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	3c 39                	cmp    $0x39,%al
  8015a0:	7f 12                	jg     8015b4 <strtol+0xf0>
			dig = *s - '0';
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	0f be c0             	movsbl %al,%eax
  8015ac:	83 e8 30             	sub    $0x30,%eax
  8015af:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015b2:	eb 4e                	jmp    801602 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b8:	0f b6 00             	movzbl (%rax),%eax
  8015bb:	3c 60                	cmp    $0x60,%al
  8015bd:	7e 1d                	jle    8015dc <strtol+0x118>
  8015bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	3c 7a                	cmp    $0x7a,%al
  8015c8:	7f 12                	jg     8015dc <strtol+0x118>
			dig = *s - 'a' + 10;
  8015ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ce:	0f b6 00             	movzbl (%rax),%eax
  8015d1:	0f be c0             	movsbl %al,%eax
  8015d4:	83 e8 57             	sub    $0x57,%eax
  8015d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015da:	eb 26                	jmp    801602 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	3c 40                	cmp    $0x40,%al
  8015e5:	7e 48                	jle    80162f <strtol+0x16b>
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	3c 5a                	cmp    $0x5a,%al
  8015f0:	7f 3d                	jg     80162f <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f6:	0f b6 00             	movzbl (%rax),%eax
  8015f9:	0f be c0             	movsbl %al,%eax
  8015fc:	83 e8 37             	sub    $0x37,%eax
  8015ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801602:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801605:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801608:	7c 02                	jl     80160c <strtol+0x148>
			break;
  80160a:	eb 23                	jmp    80162f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80160c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801611:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801614:	48 98                	cltq   
  801616:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80161b:	48 89 c2             	mov    %rax,%rdx
  80161e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801621:	48 98                	cltq   
  801623:	48 01 d0             	add    %rdx,%rax
  801626:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80162a:	e9 5d ff ff ff       	jmpq   80158c <strtol+0xc8>

	if (endptr)
  80162f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801634:	74 0b                	je     801641 <strtol+0x17d>
		*endptr = (char *) s;
  801636:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80163a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80163e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801645:	74 09                	je     801650 <strtol+0x18c>
  801647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164b:	48 f7 d8             	neg    %rax
  80164e:	eb 04                	jmp    801654 <strtol+0x190>
  801650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801654:	c9                   	leaveq 
  801655:	c3                   	retq   

0000000000801656 <strstr>:

char * strstr(const char *in, const char *str)
{
  801656:	55                   	push   %rbp
  801657:	48 89 e5             	mov    %rsp,%rbp
  80165a:	48 83 ec 30          	sub    $0x30,%rsp
  80165e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801662:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801666:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80166e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801678:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80167c:	75 06                	jne    801684 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	eb 6b                	jmp    8016ef <strstr+0x99>

	len = strlen(str);
  801684:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801688:	48 89 c7             	mov    %rax,%rdi
  80168b:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  801692:	00 00 00 
  801695:	ff d0                	callq  *%rax
  801697:	48 98                	cltq   
  801699:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80169d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016a9:	0f b6 00             	movzbl (%rax),%eax
  8016ac:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8016af:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016b3:	75 07                	jne    8016bc <strstr+0x66>
				return (char *) 0;
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	eb 33                	jmp    8016ef <strstr+0x99>
		} while (sc != c);
  8016bc:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016c0:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016c3:	75 d8                	jne    80169d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016c9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	48 89 ce             	mov    %rcx,%rsi
  8016d4:	48 89 c7             	mov    %rax,%rdi
  8016d7:	48 b8 4d 11 80 00 00 	movabs $0x80114d,%rax
  8016de:	00 00 00 
  8016e1:	ff d0                	callq  *%rax
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	75 b6                	jne    80169d <strstr+0x47>

	return (char *) (in - 1);
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	48 83 e8 01          	sub    $0x1,%rax
}
  8016ef:	c9                   	leaveq 
  8016f0:	c3                   	retq   

00000000008016f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016f1:	55                   	push   %rbp
  8016f2:	48 89 e5             	mov    %rsp,%rbp
  8016f5:	53                   	push   %rbx
  8016f6:	48 83 ec 48          	sub    $0x48,%rsp
  8016fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016fd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801700:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801704:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801708:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80170c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801710:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801713:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801717:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80171b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80171f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801723:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801727:	4c 89 c3             	mov    %r8,%rbx
  80172a:	cd 30                	int    $0x30
  80172c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801730:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801734:	74 3e                	je     801774 <syscall+0x83>
  801736:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80173b:	7e 37                	jle    801774 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80173d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801741:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801744:	49 89 d0             	mov    %rdx,%r8
  801747:	89 c1                	mov    %eax,%ecx
  801749:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  801750:	00 00 00 
  801753:	be 23 00 00 00       	mov    $0x23,%esi
  801758:	48 bf 25 44 80 00 00 	movabs $0x804425,%rdi
  80175f:	00 00 00 
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
  801767:	49 b9 de 3b 80 00 00 	movabs $0x803bde,%r9
  80176e:	00 00 00 
  801771:	41 ff d1             	callq  *%r9

	return ret;
  801774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801778:	48 83 c4 48          	add    $0x48,%rsp
  80177c:	5b                   	pop    %rbx
  80177d:	5d                   	pop    %rbp
  80177e:	c3                   	retq   

000000000080177f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80177f:	55                   	push   %rbp
  801780:	48 89 e5             	mov    %rsp,%rbp
  801783:	48 83 ec 20          	sub    $0x20,%rsp
  801787:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80178b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80178f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801793:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801797:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80179e:	00 
  80179f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ab:	48 89 d1             	mov    %rdx,%rcx
  8017ae:	48 89 c2             	mov    %rax,%rdx
  8017b1:	be 00 00 00 00       	mov    $0x0,%esi
  8017b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8017bb:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  8017c2:	00 00 00 
  8017c5:	ff d0                	callq  *%rax
}
  8017c7:	c9                   	leaveq 
  8017c8:	c3                   	retq   

00000000008017c9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c9:	55                   	push   %rbp
  8017ca:	48 89 e5             	mov    %rsp,%rbp
  8017cd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d8:	00 
  8017d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	be 00 00 00 00       	mov    $0x0,%esi
  8017f4:	bf 01 00 00 00       	mov    $0x1,%edi
  8017f9:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801800:	00 00 00 
  801803:	ff d0                	callq  *%rax
}
  801805:	c9                   	leaveq 
  801806:	c3                   	retq   

0000000000801807 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801807:	55                   	push   %rbp
  801808:	48 89 e5             	mov    %rsp,%rbp
  80180b:	48 83 ec 10          	sub    $0x10,%rsp
  80180f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801815:	48 98                	cltq   
  801817:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80181e:	00 
  80181f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801825:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801830:	48 89 c2             	mov    %rax,%rdx
  801833:	be 01 00 00 00       	mov    $0x1,%esi
  801838:	bf 03 00 00 00       	mov    $0x3,%edi
  80183d:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801844:	00 00 00 
  801847:	ff d0                	callq  *%rax
}
  801849:	c9                   	leaveq 
  80184a:	c3                   	retq   

000000000080184b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80184b:	55                   	push   %rbp
  80184c:	48 89 e5             	mov    %rsp,%rbp
  80184f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801853:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185a:	00 
  80185b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801861:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801867:	b9 00 00 00 00       	mov    $0x0,%ecx
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	be 00 00 00 00       	mov    $0x0,%esi
  801876:	bf 02 00 00 00       	mov    $0x2,%edi
  80187b:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801882:	00 00 00 
  801885:	ff d0                	callq  *%rax
}
  801887:	c9                   	leaveq 
  801888:	c3                   	retq   

0000000000801889 <sys_yield>:

void
sys_yield(void)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801891:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801898:	00 
  801899:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018af:	be 00 00 00 00       	mov    $0x0,%esi
  8018b4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018b9:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 20          	sub    $0x20,%rsp
  8018cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018dc:	48 63 c8             	movslq %eax,%rcx
  8018df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e6:	48 98                	cltq   
  8018e8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ef:	00 
  8018f0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f6:	49 89 c8             	mov    %rcx,%r8
  8018f9:	48 89 d1             	mov    %rdx,%rcx
  8018fc:	48 89 c2             	mov    %rax,%rdx
  8018ff:	be 01 00 00 00       	mov    $0x1,%esi
  801904:	bf 04 00 00 00       	mov    $0x4,%edi
  801909:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801910:	00 00 00 
  801913:	ff d0                	callq  *%rax
}
  801915:	c9                   	leaveq 
  801916:	c3                   	retq   

0000000000801917 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801917:	55                   	push   %rbp
  801918:	48 89 e5             	mov    %rsp,%rbp
  80191b:	48 83 ec 30          	sub    $0x30,%rsp
  80191f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801922:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801926:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801929:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80192d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801931:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801934:	48 63 c8             	movslq %eax,%rcx
  801937:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80193b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80193e:	48 63 f0             	movslq %eax,%rsi
  801941:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801945:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801948:	48 98                	cltq   
  80194a:	48 89 0c 24          	mov    %rcx,(%rsp)
  80194e:	49 89 f9             	mov    %rdi,%r9
  801951:	49 89 f0             	mov    %rsi,%r8
  801954:	48 89 d1             	mov    %rdx,%rcx
  801957:	48 89 c2             	mov    %rax,%rdx
  80195a:	be 01 00 00 00       	mov    $0x1,%esi
  80195f:	bf 05 00 00 00       	mov    $0x5,%edi
  801964:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  80196b:	00 00 00 
  80196e:	ff d0                	callq  *%rax
}
  801970:	c9                   	leaveq 
  801971:	c3                   	retq   

0000000000801972 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801972:	55                   	push   %rbp
  801973:	48 89 e5             	mov    %rsp,%rbp
  801976:	48 83 ec 20          	sub    $0x20,%rsp
  80197a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801981:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801985:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801988:	48 98                	cltq   
  80198a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801991:	00 
  801992:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801998:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199e:	48 89 d1             	mov    %rdx,%rcx
  8019a1:	48 89 c2             	mov    %rax,%rdx
  8019a4:	be 01 00 00 00       	mov    $0x1,%esi
  8019a9:	bf 06 00 00 00       	mov    $0x6,%edi
  8019ae:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	callq  *%rax
}
  8019ba:	c9                   	leaveq 
  8019bb:	c3                   	retq   

00000000008019bc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	48 83 ec 10          	sub    $0x10,%rsp
  8019c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019cd:	48 63 d0             	movslq %eax,%rdx
  8019d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d3:	48 98                	cltq   
  8019d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019dc:	00 
  8019dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e9:	48 89 d1             	mov    %rdx,%rcx
  8019ec:	48 89 c2             	mov    %rax,%rdx
  8019ef:	be 01 00 00 00       	mov    $0x1,%esi
  8019f4:	bf 08 00 00 00       	mov    $0x8,%edi
  8019f9:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801a00:	00 00 00 
  801a03:	ff d0                	callq  *%rax
}
  801a05:	c9                   	leaveq 
  801a06:	c3                   	retq   

0000000000801a07 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a07:	55                   	push   %rbp
  801a08:	48 89 e5             	mov    %rsp,%rbp
  801a0b:	48 83 ec 20          	sub    $0x20,%rsp
  801a0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1d:	48 98                	cltq   
  801a1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a26:	00 
  801a27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a33:	48 89 d1             	mov    %rdx,%rcx
  801a36:	48 89 c2             	mov    %rax,%rdx
  801a39:	be 01 00 00 00       	mov    $0x1,%esi
  801a3e:	bf 09 00 00 00       	mov    $0x9,%edi
  801a43:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	callq  *%rax
}
  801a4f:	c9                   	leaveq 
  801a50:	c3                   	retq   

0000000000801a51 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a51:	55                   	push   %rbp
  801a52:	48 89 e5             	mov    %rsp,%rbp
  801a55:	48 83 ec 20          	sub    $0x20,%rsp
  801a59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a67:	48 98                	cltq   
  801a69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a70:	00 
  801a71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7d:	48 89 d1             	mov    %rdx,%rcx
  801a80:	48 89 c2             	mov    %rax,%rdx
  801a83:	be 01 00 00 00       	mov    $0x1,%esi
  801a88:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a8d:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	48 83 ec 20          	sub    $0x20,%rsp
  801aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aaa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801aae:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ab1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab4:	48 63 f0             	movslq %eax,%rsi
  801ab7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801abe:	48 98                	cltq   
  801ac0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acb:	00 
  801acc:	49 89 f1             	mov    %rsi,%r9
  801acf:	49 89 c8             	mov    %rcx,%r8
  801ad2:	48 89 d1             	mov    %rdx,%rcx
  801ad5:	48 89 c2             	mov    %rax,%rdx
  801ad8:	be 00 00 00 00       	mov    $0x0,%esi
  801add:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ae2:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	callq  *%rax
}
  801aee:	c9                   	leaveq 
  801aef:	c3                   	retq   

0000000000801af0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801af0:	55                   	push   %rbp
  801af1:	48 89 e5             	mov    %rsp,%rbp
  801af4:	48 83 ec 10          	sub    $0x10,%rsp
  801af8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801afc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b07:	00 
  801b08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b14:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b19:	48 89 c2             	mov    %rax,%rdx
  801b1c:	be 01 00 00 00       	mov    $0x1,%esi
  801b21:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b26:	48 b8 f1 16 80 00 00 	movabs $0x8016f1,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	callq  *%rax
}
  801b32:	c9                   	leaveq 
  801b33:	c3                   	retq   

0000000000801b34 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	48 83 ec 30          	sub    $0x30,%rsp
  801b3c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b44:	48 8b 00             	mov    (%rax),%rax
  801b47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b53:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b59:	83 e0 02             	and    $0x2,%eax
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	75 4d                	jne    801bad <pgfault+0x79>
  801b60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b64:	48 c1 e8 0c          	shr    $0xc,%rax
  801b68:	48 89 c2             	mov    %rax,%rdx
  801b6b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b72:	01 00 00 
  801b75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b79:	25 00 08 00 00       	and    $0x800,%eax
  801b7e:	48 85 c0             	test   %rax,%rax
  801b81:	74 2a                	je     801bad <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801b83:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801b8a:	00 00 00 
  801b8d:	be 1e 00 00 00       	mov    $0x1e,%esi
  801b92:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801b99:	00 00 00 
  801b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba1:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801ba8:	00 00 00 
  801bab:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801bad:	ba 07 00 00 00       	mov    $0x7,%edx
  801bb2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbc:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  801bc3:	00 00 00 
  801bc6:	ff d0                	callq  *%rax
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	0f 85 cd 00 00 00    	jne    801c9d <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801bd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801be2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801be6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bea:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bef:	48 89 c6             	mov    %rax,%rsi
  801bf2:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801bf7:	48 b8 bc 12 80 00 00 	movabs $0x8012bc,%rax
  801bfe:	00 00 00 
  801c01:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c07:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c0d:	48 89 c1             	mov    %rax,%rcx
  801c10:	ba 00 00 00 00       	mov    $0x0,%edx
  801c15:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c1f:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	callq  *%rax
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	79 2a                	jns    801c59 <pgfault+0x125>
				panic("Page map at temp address failed");
  801c2f:	48 ba 68 44 80 00 00 	movabs $0x804468,%rdx
  801c36:	00 00 00 
  801c39:	be 2f 00 00 00       	mov    $0x2f,%esi
  801c3e:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801c45:	00 00 00 
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4d:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801c54:	00 00 00 
  801c57:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c59:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c63:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  801c6a:	00 00 00 
  801c6d:	ff d0                	callq  *%rax
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	79 54                	jns    801cc7 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c73:	48 ba 88 44 80 00 00 	movabs $0x804488,%rdx
  801c7a:	00 00 00 
  801c7d:	be 31 00 00 00       	mov    $0x31,%esi
  801c82:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801c89:	00 00 00 
  801c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c91:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801c98:	00 00 00 
  801c9b:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801c9d:	48 ba b0 44 80 00 00 	movabs $0x8044b0,%rdx
  801ca4:	00 00 00 
  801ca7:	be 35 00 00 00       	mov    $0x35,%esi
  801cac:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801cb3:	00 00 00 
  801cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbb:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801cc2:	00 00 00 
  801cc5:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801cc7:	c9                   	leaveq 
  801cc8:	c3                   	retq   

0000000000801cc9 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801cc9:	55                   	push   %rbp
  801cca:	48 89 e5             	mov    %rsp,%rbp
  801ccd:	48 83 ec 20          	sub    $0x20,%rsp
  801cd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cd4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801cd7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cde:	01 00 00 
  801ce1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ce4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ce8:	25 07 0e 00 00       	and    $0xe07,%eax
  801ced:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801cf0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801cf3:	48 c1 e0 0c          	shl    $0xc,%rax
  801cf7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801cfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfe:	25 00 04 00 00       	and    $0x400,%eax
  801d03:	85 c0                	test   %eax,%eax
  801d05:	74 57                	je     801d5e <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d07:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d0a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d0e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d15:	41 89 f0             	mov    %esi,%r8d
  801d18:	48 89 c6             	mov    %rax,%rsi
  801d1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d20:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  801d27:	00 00 00 
  801d2a:	ff d0                	callq  *%rax
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	0f 8e 52 01 00 00    	jle    801e86 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801d34:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801d3b:	00 00 00 
  801d3e:	be 52 00 00 00       	mov    $0x52,%esi
  801d43:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801d4a:	00 00 00 
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d52:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801d59:	00 00 00 
  801d5c:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d61:	83 e0 02             	and    $0x2,%eax
  801d64:	85 c0                	test   %eax,%eax
  801d66:	75 10                	jne    801d78 <duppage+0xaf>
  801d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6b:	25 00 08 00 00       	and    $0x800,%eax
  801d70:	85 c0                	test   %eax,%eax
  801d72:	0f 84 bb 00 00 00    	je     801e33 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7b:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801d80:	80 cc 08             	or     $0x8,%ah
  801d83:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d86:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d89:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d8d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d94:	41 89 f0             	mov    %esi,%r8d
  801d97:	48 89 c6             	mov    %rax,%rsi
  801d9a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9f:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
  801dab:	85 c0                	test   %eax,%eax
  801dad:	7e 2a                	jle    801dd9 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801daf:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801db6:	00 00 00 
  801db9:	be 5a 00 00 00       	mov    $0x5a,%esi
  801dbe:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801dc5:	00 00 00 
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcd:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801dd4:	00 00 00 
  801dd7:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801dd9:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801ddc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de4:	41 89 c8             	mov    %ecx,%r8d
  801de7:	48 89 d1             	mov    %rdx,%rcx
  801dea:	ba 00 00 00 00       	mov    $0x0,%edx
  801def:	48 89 c6             	mov    %rax,%rsi
  801df2:	bf 00 00 00 00       	mov    $0x0,%edi
  801df7:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  801dfe:	00 00 00 
  801e01:	ff d0                	callq  *%rax
  801e03:	85 c0                	test   %eax,%eax
  801e05:	7e 2a                	jle    801e31 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801e07:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801e0e:	00 00 00 
  801e11:	be 5d 00 00 00       	mov    $0x5d,%esi
  801e16:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801e1d:	00 00 00 
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
  801e25:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801e2c:	00 00 00 
  801e2f:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e31:	eb 53                	jmp    801e86 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e33:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e36:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e3a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e41:	41 89 f0             	mov    %esi,%r8d
  801e44:	48 89 c6             	mov    %rax,%rsi
  801e47:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4c:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  801e53:	00 00 00 
  801e56:	ff d0                	callq  *%rax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	7e 2a                	jle    801e86 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801e5c:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801e63:	00 00 00 
  801e66:	be 61 00 00 00       	mov    $0x61,%esi
  801e6b:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801e72:	00 00 00 
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  801e81:	00 00 00 
  801e84:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	c9                   	leaveq 
  801e8c:	c3                   	retq   

0000000000801e8d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e8d:	55                   	push   %rbp
  801e8e:	48 89 e5             	mov    %rsp,%rbp
  801e91:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801e95:	48 bf 34 1b 80 00 00 	movabs $0x801b34,%rdi
  801e9c:	00 00 00 
  801e9f:	48 b8 f2 3c 80 00 00 	movabs $0x803cf2,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801eab:	b8 07 00 00 00       	mov    $0x7,%eax
  801eb0:	cd 30                	int    $0x30
  801eb2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801eb5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801eb8:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ebf:	79 30                	jns    801ef1 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801ec1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ec4:	89 c1                	mov    %eax,%ecx
  801ec6:	48 ba fb 44 80 00 00 	movabs $0x8044fb,%rdx
  801ecd:	00 00 00 
  801ed0:	be 89 00 00 00       	mov    $0x89,%esi
  801ed5:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801edc:	00 00 00 
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  801eeb:	00 00 00 
  801eee:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ef5:	75 46                	jne    801f3d <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ef7:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  801efe:	00 00 00 
  801f01:	ff d0                	callq  *%rax
  801f03:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f08:	48 63 d0             	movslq %eax,%rdx
  801f0b:	48 89 d0             	mov    %rdx,%rax
  801f0e:	48 c1 e0 03          	shl    $0x3,%rax
  801f12:	48 01 d0             	add    %rdx,%rax
  801f15:	48 c1 e0 05          	shl    $0x5,%rax
  801f19:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f20:	00 00 00 
  801f23:	48 01 c2             	add    %rax,%rdx
  801f26:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f2d:	00 00 00 
  801f30:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f33:	b8 00 00 00 00       	mov    $0x0,%eax
  801f38:	e9 d1 01 00 00       	jmpq   80210e <fork+0x281>
	}

	uint64_t ad = 0;
  801f3d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f44:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801f45:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801f4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801f4e:	e9 df 00 00 00       	jmpq   802032 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801f53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f57:	48 c1 e8 27          	shr    $0x27,%rax
  801f5b:	48 89 c2             	mov    %rax,%rdx
  801f5e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f65:	01 00 00 
  801f68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f6c:	83 e0 01             	and    $0x1,%eax
  801f6f:	48 85 c0             	test   %rax,%rax
  801f72:	0f 84 9e 00 00 00    	je     802016 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7c:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f80:	48 89 c2             	mov    %rax,%rdx
  801f83:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f8a:	01 00 00 
  801f8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f91:	83 e0 01             	and    $0x1,%eax
  801f94:	48 85 c0             	test   %rax,%rax
  801f97:	74 73                	je     80200c <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801f99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9d:	48 c1 e8 15          	shr    $0x15,%rax
  801fa1:	48 89 c2             	mov    %rax,%rdx
  801fa4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fab:	01 00 00 
  801fae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb2:	83 e0 01             	and    $0x1,%eax
  801fb5:	48 85 c0             	test   %rax,%rax
  801fb8:	74 48                	je     802002 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbe:	48 c1 e8 0c          	shr    $0xc,%rax
  801fc2:	48 89 c2             	mov    %rax,%rdx
  801fc5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fcc:	01 00 00 
  801fcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fdb:	83 e0 01             	and    $0x1,%eax
  801fde:	48 85 c0             	test   %rax,%rax
  801fe1:	74 47                	je     80202a <fork+0x19d>
						duppage(envid, VPN(addr));
  801fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe7:	48 c1 e8 0c          	shr    $0xc,%rax
  801feb:	89 c2                	mov    %eax,%edx
  801fed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ff0:	89 d6                	mov    %edx,%esi
  801ff2:	89 c7                	mov    %eax,%edi
  801ff4:	48 b8 c9 1c 80 00 00 	movabs $0x801cc9,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
  802000:	eb 28                	jmp    80202a <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  802002:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802009:	00 
  80200a:	eb 1e                	jmp    80202a <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80200c:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802013:	40 
  802014:	eb 14                	jmp    80202a <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  802016:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201a:	48 c1 e8 27          	shr    $0x27,%rax
  80201e:	48 83 c0 01          	add    $0x1,%rax
  802022:	48 c1 e0 27          	shl    $0x27,%rax
  802026:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  80202a:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802031:	00 
  802032:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802039:	00 
  80203a:	0f 87 13 ff ff ff    	ja     801f53 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802040:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802043:	ba 07 00 00 00       	mov    $0x7,%edx
  802048:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80205b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80205e:	ba 07 00 00 00       	mov    $0x7,%edx
  802063:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802068:	89 c7                	mov    %eax,%edi
  80206a:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802071:	00 00 00 
  802074:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802076:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802079:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80207f:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802084:	ba 00 00 00 00       	mov    $0x0,%edx
  802089:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80208e:	89 c7                	mov    %eax,%edi
  802090:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  802097:	00 00 00 
  80209a:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80209c:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020a1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020a6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8020ab:	48 b8 bc 12 80 00 00 	movabs $0x8012bc,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8020b7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c1:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  8020c8:	00 00 00 
  8020cb:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8020cd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020d4:	00 00 00 
  8020d7:	48 8b 00             	mov    (%rax),%rax
  8020da:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8020e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020e4:	48 89 d6             	mov    %rdx,%rsi
  8020e7:	89 c7                	mov    %eax,%edi
  8020e9:	48 b8 51 1a 80 00 00 	movabs $0x801a51,%rax
  8020f0:	00 00 00 
  8020f3:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  8020f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f8:	be 02 00 00 00       	mov    $0x2,%esi
  8020fd:	89 c7                	mov    %eax,%edi
  8020ff:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax

	return envid;
  80210b:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  80210e:	c9                   	leaveq 
  80210f:	c3                   	retq   

0000000000802110 <sfork>:

// Challenge!
int
sfork(void)
{
  802110:	55                   	push   %rbp
  802111:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802114:	48 ba 13 45 80 00 00 	movabs $0x804513,%rdx
  80211b:	00 00 00 
  80211e:	be b8 00 00 00       	mov    $0xb8,%esi
  802123:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  80212a:	00 00 00 
  80212d:	b8 00 00 00 00       	mov    $0x0,%eax
  802132:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  802139:	00 00 00 
  80213c:	ff d1                	callq  *%rcx

000000000080213e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80213e:	55                   	push   %rbp
  80213f:	48 89 e5             	mov    %rsp,%rbp
  802142:	48 83 ec 30          	sub    $0x30,%rsp
  802146:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80214a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80214e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  802152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802157:	75 0e                	jne    802167 <ipc_recv+0x29>
        pg = (void *)UTOP;
  802159:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802160:	00 00 00 
  802163:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  802167:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80216b:	48 89 c7             	mov    %rax,%rdi
  80216e:	48 b8 f0 1a 80 00 00 	movabs $0x801af0,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802181:	79 27                	jns    8021aa <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  802183:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802188:	74 0a                	je     802194 <ipc_recv+0x56>
            *from_env_store = 0;
  80218a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  802194:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802199:	74 0a                	je     8021a5 <ipc_recv+0x67>
            *perm_store = 0;
  80219b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8021a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a8:	eb 53                	jmp    8021fd <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8021aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021af:	74 19                	je     8021ca <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8021b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021b8:	00 00 00 
  8021bb:	48 8b 00             	mov    (%rax),%rax
  8021be:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8021c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c8:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8021ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021cf:	74 19                	je     8021ea <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8021d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021d8:	00 00 00 
  8021db:	48 8b 00             	mov    (%rax),%rax
  8021de:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8021e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e8:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8021ea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021f1:	00 00 00 
  8021f4:	48 8b 00             	mov    (%rax),%rax
  8021f7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8021fd:	c9                   	leaveq 
  8021fe:	c3                   	retq   

00000000008021ff <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021ff:	55                   	push   %rbp
  802200:	48 89 e5             	mov    %rsp,%rbp
  802203:	48 83 ec 30          	sub    $0x30,%rsp
  802207:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80220a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80220d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802211:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  802214:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802219:	75 0e                	jne    802229 <ipc_send+0x2a>
        pg = (void *)UTOP;
  80221b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802222:	00 00 00 
  802225:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  802229:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80222c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80222f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802233:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802236:	89 c7                	mov    %eax,%edi
  802238:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  80223f:	00 00 00 
  802242:	ff d0                	callq  *%rax
  802244:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  802247:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224b:	79 36                	jns    802283 <ipc_send+0x84>
  80224d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802251:	74 30                	je     802283 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  802253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802256:	89 c1                	mov    %eax,%ecx
  802258:	48 ba 29 45 80 00 00 	movabs $0x804529,%rdx
  80225f:	00 00 00 
  802262:	be 49 00 00 00       	mov    $0x49,%esi
  802267:	48 bf 36 45 80 00 00 	movabs $0x804536,%rdi
  80226e:	00 00 00 
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
  802276:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  80227d:	00 00 00 
  802280:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  802283:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	callq  *%rax
    } while(r != 0);
  80228f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802293:	75 94                	jne    802229 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  802295:	c9                   	leaveq 
  802296:	c3                   	retq   

0000000000802297 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802297:	55                   	push   %rbp
  802298:	48 89 e5             	mov    %rsp,%rbp
  80229b:	48 83 ec 14          	sub    $0x14,%rsp
  80229f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8022a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022a9:	eb 5e                	jmp    802309 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8022ab:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022b2:	00 00 00 
  8022b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b8:	48 63 d0             	movslq %eax,%rdx
  8022bb:	48 89 d0             	mov    %rdx,%rax
  8022be:	48 c1 e0 03          	shl    $0x3,%rax
  8022c2:	48 01 d0             	add    %rdx,%rax
  8022c5:	48 c1 e0 05          	shl    $0x5,%rax
  8022c9:	48 01 c8             	add    %rcx,%rax
  8022cc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8022d2:	8b 00                	mov    (%rax),%eax
  8022d4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8022d7:	75 2c                	jne    802305 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8022d9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022e0:	00 00 00 
  8022e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e6:	48 63 d0             	movslq %eax,%rdx
  8022e9:	48 89 d0             	mov    %rdx,%rax
  8022ec:	48 c1 e0 03          	shl    $0x3,%rax
  8022f0:	48 01 d0             	add    %rdx,%rax
  8022f3:	48 c1 e0 05          	shl    $0x5,%rax
  8022f7:	48 01 c8             	add    %rcx,%rax
  8022fa:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802300:	8b 40 08             	mov    0x8(%rax),%eax
  802303:	eb 12                	jmp    802317 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802305:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802309:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802310:	7e 99                	jle    8022ab <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802312:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802317:	c9                   	leaveq 
  802318:	c3                   	retq   

0000000000802319 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802319:	55                   	push   %rbp
  80231a:	48 89 e5             	mov    %rsp,%rbp
  80231d:	48 83 ec 08          	sub    $0x8,%rsp
  802321:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802325:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802329:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802330:	ff ff ff 
  802333:	48 01 d0             	add    %rdx,%rax
  802336:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80233a:	c9                   	leaveq 
  80233b:	c3                   	retq   

000000000080233c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80233c:	55                   	push   %rbp
  80233d:	48 89 e5             	mov    %rsp,%rbp
  802340:	48 83 ec 08          	sub    $0x8,%rsp
  802344:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234c:	48 89 c7             	mov    %rax,%rdi
  80234f:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802356:	00 00 00 
  802359:	ff d0                	callq  *%rax
  80235b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802361:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802365:	c9                   	leaveq 
  802366:	c3                   	retq   

0000000000802367 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802367:	55                   	push   %rbp
  802368:	48 89 e5             	mov    %rsp,%rbp
  80236b:	48 83 ec 18          	sub    $0x18,%rsp
  80236f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80237a:	eb 6b                	jmp    8023e7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80237c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237f:	48 98                	cltq   
  802381:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802387:	48 c1 e0 0c          	shl    $0xc,%rax
  80238b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80238f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802393:	48 c1 e8 15          	shr    $0x15,%rax
  802397:	48 89 c2             	mov    %rax,%rdx
  80239a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023a1:	01 00 00 
  8023a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a8:	83 e0 01             	and    $0x1,%eax
  8023ab:	48 85 c0             	test   %rax,%rax
  8023ae:	74 21                	je     8023d1 <fd_alloc+0x6a>
  8023b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8023b8:	48 89 c2             	mov    %rax,%rdx
  8023bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023c2:	01 00 00 
  8023c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c9:	83 e0 01             	and    $0x1,%eax
  8023cc:	48 85 c0             	test   %rax,%rax
  8023cf:	75 12                	jne    8023e3 <fd_alloc+0x7c>
			*fd_store = fd;
  8023d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	eb 1a                	jmp    8023fd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023e7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023eb:	7e 8f                	jle    80237c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023f8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023fd:	c9                   	leaveq 
  8023fe:	c3                   	retq   

00000000008023ff <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023ff:	55                   	push   %rbp
  802400:	48 89 e5             	mov    %rsp,%rbp
  802403:	48 83 ec 20          	sub    $0x20,%rsp
  802407:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80240a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80240e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802412:	78 06                	js     80241a <fd_lookup+0x1b>
  802414:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802418:	7e 07                	jle    802421 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80241a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80241f:	eb 6c                	jmp    80248d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802421:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802424:	48 98                	cltq   
  802426:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80242c:	48 c1 e0 0c          	shl    $0xc,%rax
  802430:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802438:	48 c1 e8 15          	shr    $0x15,%rax
  80243c:	48 89 c2             	mov    %rax,%rdx
  80243f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802446:	01 00 00 
  802449:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244d:	83 e0 01             	and    $0x1,%eax
  802450:	48 85 c0             	test   %rax,%rax
  802453:	74 21                	je     802476 <fd_lookup+0x77>
  802455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802459:	48 c1 e8 0c          	shr    $0xc,%rax
  80245d:	48 89 c2             	mov    %rax,%rdx
  802460:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802467:	01 00 00 
  80246a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246e:	83 e0 01             	and    $0x1,%eax
  802471:	48 85 c0             	test   %rax,%rax
  802474:	75 07                	jne    80247d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802476:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80247b:	eb 10                	jmp    80248d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80247d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802481:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802485:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248d:	c9                   	leaveq 
  80248e:	c3                   	retq   

000000000080248f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80248f:	55                   	push   %rbp
  802490:	48 89 e5             	mov    %rsp,%rbp
  802493:	48 83 ec 30          	sub    $0x30,%rsp
  802497:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80249b:	89 f0                	mov    %esi,%eax
  80249d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024a4:	48 89 c7             	mov    %rax,%rdi
  8024a7:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	callq  *%rax
  8024b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b7:	48 89 d6             	mov    %rdx,%rsi
  8024ba:	89 c7                	mov    %eax,%edi
  8024bc:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8024c3:	00 00 00 
  8024c6:	ff d0                	callq  *%rax
  8024c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024cf:	78 0a                	js     8024db <fd_close+0x4c>
	    || fd != fd2)
  8024d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d5:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024d9:	74 12                	je     8024ed <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024db:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024df:	74 05                	je     8024e6 <fd_close+0x57>
  8024e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e4:	eb 05                	jmp    8024eb <fd_close+0x5c>
  8024e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024eb:	eb 69                	jmp    802556 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024f1:	8b 00                	mov    (%rax),%eax
  8024f3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 58 25 80 00 00 	movabs $0x802558,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	78 2a                	js     80253b <fd_close+0xac>
		if (dev->dev_close)
  802511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802515:	48 8b 40 20          	mov    0x20(%rax),%rax
  802519:	48 85 c0             	test   %rax,%rax
  80251c:	74 16                	je     802534 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80251e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802522:	48 8b 40 20          	mov    0x20(%rax),%rax
  802526:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80252a:	48 89 d7             	mov    %rdx,%rdi
  80252d:	ff d0                	callq  *%rax
  80252f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802532:	eb 07                	jmp    80253b <fd_close+0xac>
		else
			r = 0;
  802534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80253b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253f:	48 89 c6             	mov    %rax,%rsi
  802542:	bf 00 00 00 00       	mov    $0x0,%edi
  802547:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  80254e:	00 00 00 
  802551:	ff d0                	callq  *%rax
	return r;
  802553:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802556:	c9                   	leaveq 
  802557:	c3                   	retq   

0000000000802558 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802558:	55                   	push   %rbp
  802559:	48 89 e5             	mov    %rsp,%rbp
  80255c:	48 83 ec 20          	sub    $0x20,%rsp
  802560:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802563:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80256e:	eb 41                	jmp    8025b1 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802570:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802577:	00 00 00 
  80257a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80257d:	48 63 d2             	movslq %edx,%rdx
  802580:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802584:	8b 00                	mov    (%rax),%eax
  802586:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802589:	75 22                	jne    8025ad <dev_lookup+0x55>
			*dev = devtab[i];
  80258b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802592:	00 00 00 
  802595:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802598:	48 63 d2             	movslq %edx,%rdx
  80259b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80259f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	eb 60                	jmp    80260d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025b8:	00 00 00 
  8025bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025be:	48 63 d2             	movslq %edx,%rdx
  8025c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c5:	48 85 c0             	test   %rax,%rax
  8025c8:	75 a6                	jne    802570 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025ca:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025d1:	00 00 00 
  8025d4:	48 8b 00             	mov    (%rax),%rax
  8025d7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025dd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025e0:	89 c6                	mov    %eax,%esi
  8025e2:	48 bf 40 45 80 00 00 	movabs $0x804540,%rdi
  8025e9:	00 00 00 
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f1:	48 b9 d0 03 80 00 00 	movabs $0x8003d0,%rcx
  8025f8:	00 00 00 
  8025fb:	ff d1                	callq  *%rcx
	*dev = 0;
  8025fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802601:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802608:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80260d:	c9                   	leaveq 
  80260e:	c3                   	retq   

000000000080260f <close>:

int
close(int fdnum)
{
  80260f:	55                   	push   %rbp
  802610:	48 89 e5             	mov    %rsp,%rbp
  802613:	48 83 ec 20          	sub    $0x20,%rsp
  802617:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80261a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802621:	48 89 d6             	mov    %rdx,%rsi
  802624:	89 c7                	mov    %eax,%edi
  802626:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  80262d:	00 00 00 
  802630:	ff d0                	callq  *%rax
  802632:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802635:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802639:	79 05                	jns    802640 <close+0x31>
		return r;
  80263b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263e:	eb 18                	jmp    802658 <close+0x49>
	else
		return fd_close(fd, 1);
  802640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802644:	be 01 00 00 00       	mov    $0x1,%esi
  802649:	48 89 c7             	mov    %rax,%rdi
  80264c:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
}
  802658:	c9                   	leaveq 
  802659:	c3                   	retq   

000000000080265a <close_all>:

void
close_all(void)
{
  80265a:	55                   	push   %rbp
  80265b:	48 89 e5             	mov    %rsp,%rbp
  80265e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802662:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802669:	eb 15                	jmp    802680 <close_all+0x26>
		close(i);
  80266b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266e:	89 c7                	mov    %eax,%edi
  802670:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  802677:	00 00 00 
  80267a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80267c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802680:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802684:	7e e5                	jle    80266b <close_all+0x11>
		close(i);
}
  802686:	c9                   	leaveq 
  802687:	c3                   	retq   

0000000000802688 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802688:	55                   	push   %rbp
  802689:	48 89 e5             	mov    %rsp,%rbp
  80268c:	48 83 ec 40          	sub    $0x40,%rsp
  802690:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802693:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802696:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80269a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80269d:	48 89 d6             	mov    %rdx,%rsi
  8026a0:	89 c7                	mov    %eax,%edi
  8026a2:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	callq  *%rax
  8026ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b5:	79 08                	jns    8026bf <dup+0x37>
		return r;
  8026b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ba:	e9 70 01 00 00       	jmpq   80282f <dup+0x1a7>
	close(newfdnum);
  8026bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026c2:	89 c7                	mov    %eax,%edi
  8026c4:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026d0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026d3:	48 98                	cltq   
  8026d5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026db:	48 c1 e0 0c          	shl    $0xc,%rax
  8026df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e7:	48 89 c7             	mov    %rax,%rdi
  8026ea:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
  8026f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fe:	48 89 c7             	mov    %rax,%rdi
  802701:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  802708:	00 00 00 
  80270b:	ff d0                	callq  *%rax
  80270d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802715:	48 c1 e8 15          	shr    $0x15,%rax
  802719:	48 89 c2             	mov    %rax,%rdx
  80271c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802723:	01 00 00 
  802726:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80272a:	83 e0 01             	and    $0x1,%eax
  80272d:	48 85 c0             	test   %rax,%rax
  802730:	74 73                	je     8027a5 <dup+0x11d>
  802732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802736:	48 c1 e8 0c          	shr    $0xc,%rax
  80273a:	48 89 c2             	mov    %rax,%rdx
  80273d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802744:	01 00 00 
  802747:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274b:	83 e0 01             	and    $0x1,%eax
  80274e:	48 85 c0             	test   %rax,%rax
  802751:	74 52                	je     8027a5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802757:	48 c1 e8 0c          	shr    $0xc,%rax
  80275b:	48 89 c2             	mov    %rax,%rdx
  80275e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802765:	01 00 00 
  802768:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80276c:	25 07 0e 00 00       	and    $0xe07,%eax
  802771:	89 c1                	mov    %eax,%ecx
  802773:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277b:	41 89 c8             	mov    %ecx,%r8d
  80277e:	48 89 d1             	mov    %rdx,%rcx
  802781:	ba 00 00 00 00       	mov    $0x0,%edx
  802786:	48 89 c6             	mov    %rax,%rsi
  802789:	bf 00 00 00 00       	mov    $0x0,%edi
  80278e:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
  80279a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a1:	79 02                	jns    8027a5 <dup+0x11d>
			goto err;
  8027a3:	eb 57                	jmp    8027fc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8027ad:	48 89 c2             	mov    %rax,%rdx
  8027b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027b7:	01 00 00 
  8027ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027be:	25 07 0e 00 00       	and    $0xe07,%eax
  8027c3:	89 c1                	mov    %eax,%ecx
  8027c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027cd:	41 89 c8             	mov    %ecx,%r8d
  8027d0:	48 89 d1             	mov    %rdx,%rcx
  8027d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d8:	48 89 c6             	mov    %rax,%rsi
  8027db:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e0:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	callq  *%rax
  8027ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f3:	79 02                	jns    8027f7 <dup+0x16f>
		goto err;
  8027f5:	eb 05                	jmp    8027fc <dup+0x174>

	return newfdnum;
  8027f7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027fa:	eb 33                	jmp    80282f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802800:	48 89 c6             	mov    %rax,%rsi
  802803:	bf 00 00 00 00       	mov    $0x0,%edi
  802808:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802814:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802818:	48 89 c6             	mov    %rax,%rsi
  80281b:	bf 00 00 00 00       	mov    $0x0,%edi
  802820:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax
	return r;
  80282c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80282f:	c9                   	leaveq 
  802830:	c3                   	retq   

0000000000802831 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802831:	55                   	push   %rbp
  802832:	48 89 e5             	mov    %rsp,%rbp
  802835:	48 83 ec 40          	sub    $0x40,%rsp
  802839:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80283c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802840:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802844:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802848:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80284b:	48 89 d6             	mov    %rdx,%rsi
  80284e:	89 c7                	mov    %eax,%edi
  802850:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
  80285c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802863:	78 24                	js     802889 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802869:	8b 00                	mov    (%rax),%eax
  80286b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80286f:	48 89 d6             	mov    %rdx,%rsi
  802872:	89 c7                	mov    %eax,%edi
  802874:	48 b8 58 25 80 00 00 	movabs $0x802558,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	callq  *%rax
  802880:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802883:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802887:	79 05                	jns    80288e <read+0x5d>
		return r;
  802889:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288c:	eb 76                	jmp    802904 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80288e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802892:	8b 40 08             	mov    0x8(%rax),%eax
  802895:	83 e0 03             	and    $0x3,%eax
  802898:	83 f8 01             	cmp    $0x1,%eax
  80289b:	75 3a                	jne    8028d7 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80289d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028a4:	00 00 00 
  8028a7:	48 8b 00             	mov    (%rax),%rax
  8028aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028b0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028b3:	89 c6                	mov    %eax,%esi
  8028b5:	48 bf 5f 45 80 00 00 	movabs $0x80455f,%rdi
  8028bc:	00 00 00 
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	48 b9 d0 03 80 00 00 	movabs $0x8003d0,%rcx
  8028cb:	00 00 00 
  8028ce:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028d5:	eb 2d                	jmp    802904 <read+0xd3>
	}
	if (!dev->dev_read)
  8028d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028db:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028df:	48 85 c0             	test   %rax,%rax
  8028e2:	75 07                	jne    8028eb <read+0xba>
		return -E_NOT_SUPP;
  8028e4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028e9:	eb 19                	jmp    802904 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ef:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028f3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028f7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028fb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028ff:	48 89 cf             	mov    %rcx,%rdi
  802902:	ff d0                	callq  *%rax
}
  802904:	c9                   	leaveq 
  802905:	c3                   	retq   

0000000000802906 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802906:	55                   	push   %rbp
  802907:	48 89 e5             	mov    %rsp,%rbp
  80290a:	48 83 ec 30          	sub    $0x30,%rsp
  80290e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802911:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802915:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802919:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802920:	eb 49                	jmp    80296b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802925:	48 98                	cltq   
  802927:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80292b:	48 29 c2             	sub    %rax,%rdx
  80292e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802931:	48 63 c8             	movslq %eax,%rcx
  802934:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802938:	48 01 c1             	add    %rax,%rcx
  80293b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80293e:	48 89 ce             	mov    %rcx,%rsi
  802941:	89 c7                	mov    %eax,%edi
  802943:	48 b8 31 28 80 00 00 	movabs $0x802831,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
  80294f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802952:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802956:	79 05                	jns    80295d <readn+0x57>
			return m;
  802958:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80295b:	eb 1c                	jmp    802979 <readn+0x73>
		if (m == 0)
  80295d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802961:	75 02                	jne    802965 <readn+0x5f>
			break;
  802963:	eb 11                	jmp    802976 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802965:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802968:	01 45 fc             	add    %eax,-0x4(%rbp)
  80296b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296e:	48 98                	cltq   
  802970:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802974:	72 ac                	jb     802922 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802976:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802979:	c9                   	leaveq 
  80297a:	c3                   	retq   

000000000080297b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80297b:	55                   	push   %rbp
  80297c:	48 89 e5             	mov    %rsp,%rbp
  80297f:	48 83 ec 40          	sub    $0x40,%rsp
  802983:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802986:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80298a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80298e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802992:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802995:	48 89 d6             	mov    %rdx,%rsi
  802998:	89 c7                	mov    %eax,%edi
  80299a:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8029a1:	00 00 00 
  8029a4:	ff d0                	callq  *%rax
  8029a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ad:	78 24                	js     8029d3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b3:	8b 00                	mov    (%rax),%eax
  8029b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b9:	48 89 d6             	mov    %rdx,%rsi
  8029bc:	89 c7                	mov    %eax,%edi
  8029be:	48 b8 58 25 80 00 00 	movabs $0x802558,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	callq  *%rax
  8029ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d1:	79 05                	jns    8029d8 <write+0x5d>
		return r;
  8029d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d6:	eb 75                	jmp    802a4d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029dc:	8b 40 08             	mov    0x8(%rax),%eax
  8029df:	83 e0 03             	and    $0x3,%eax
  8029e2:	85 c0                	test   %eax,%eax
  8029e4:	75 3a                	jne    802a20 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029e6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029ed:	00 00 00 
  8029f0:	48 8b 00             	mov    (%rax),%rax
  8029f3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029f9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029fc:	89 c6                	mov    %eax,%esi
  8029fe:	48 bf 7b 45 80 00 00 	movabs $0x80457b,%rdi
  802a05:	00 00 00 
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0d:	48 b9 d0 03 80 00 00 	movabs $0x8003d0,%rcx
  802a14:	00 00 00 
  802a17:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a1e:	eb 2d                	jmp    802a4d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a24:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a28:	48 85 c0             	test   %rax,%rax
  802a2b:	75 07                	jne    802a34 <write+0xb9>
		return -E_NOT_SUPP;
  802a2d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a32:	eb 19                	jmp    802a4d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a38:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a3c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a40:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a44:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a48:	48 89 cf             	mov    %rcx,%rdi
  802a4b:	ff d0                	callq  *%rax
}
  802a4d:	c9                   	leaveq 
  802a4e:	c3                   	retq   

0000000000802a4f <seek>:

int
seek(int fdnum, off_t offset)
{
  802a4f:	55                   	push   %rbp
  802a50:	48 89 e5             	mov    %rsp,%rbp
  802a53:	48 83 ec 18          	sub    $0x18,%rsp
  802a57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a5a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a64:	48 89 d6             	mov    %rdx,%rsi
  802a67:	89 c7                	mov    %eax,%edi
  802a69:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802a70:	00 00 00 
  802a73:	ff d0                	callq  *%rax
  802a75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7c:	79 05                	jns    802a83 <seek+0x34>
		return r;
  802a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a81:	eb 0f                	jmp    802a92 <seek+0x43>
	fd->fd_offset = offset;
  802a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a87:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a8a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a92:	c9                   	leaveq 
  802a93:	c3                   	retq   

0000000000802a94 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a94:	55                   	push   %rbp
  802a95:	48 89 e5             	mov    %rsp,%rbp
  802a98:	48 83 ec 30          	sub    $0x30,%rsp
  802a9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a9f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aa2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aa6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aa9:	48 89 d6             	mov    %rdx,%rsi
  802aac:	89 c7                	mov    %eax,%edi
  802aae:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	callq  *%rax
  802aba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802abd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac1:	78 24                	js     802ae7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac7:	8b 00                	mov    (%rax),%eax
  802ac9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802acd:	48 89 d6             	mov    %rdx,%rsi
  802ad0:	89 c7                	mov    %eax,%edi
  802ad2:	48 b8 58 25 80 00 00 	movabs $0x802558,%rax
  802ad9:	00 00 00 
  802adc:	ff d0                	callq  *%rax
  802ade:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae5:	79 05                	jns    802aec <ftruncate+0x58>
		return r;
  802ae7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aea:	eb 72                	jmp    802b5e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af0:	8b 40 08             	mov    0x8(%rax),%eax
  802af3:	83 e0 03             	and    $0x3,%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	75 3a                	jne    802b34 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802afa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b01:	00 00 00 
  802b04:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b07:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b0d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b10:	89 c6                	mov    %eax,%esi
  802b12:	48 bf 98 45 80 00 00 	movabs $0x804598,%rdi
  802b19:	00 00 00 
  802b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b21:	48 b9 d0 03 80 00 00 	movabs $0x8003d0,%rcx
  802b28:	00 00 00 
  802b2b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b32:	eb 2a                	jmp    802b5e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b38:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b3c:	48 85 c0             	test   %rax,%rax
  802b3f:	75 07                	jne    802b48 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b41:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b46:	eb 16                	jmp    802b5e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b54:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b57:	89 ce                	mov    %ecx,%esi
  802b59:	48 89 d7             	mov    %rdx,%rdi
  802b5c:	ff d0                	callq  *%rax
}
  802b5e:	c9                   	leaveq 
  802b5f:	c3                   	retq   

0000000000802b60 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b60:	55                   	push   %rbp
  802b61:	48 89 e5             	mov    %rsp,%rbp
  802b64:	48 83 ec 30          	sub    $0x30,%rsp
  802b68:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b6b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b76:	48 89 d6             	mov    %rdx,%rsi
  802b79:	89 c7                	mov    %eax,%edi
  802b7b:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802b82:	00 00 00 
  802b85:	ff d0                	callq  *%rax
  802b87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8e:	78 24                	js     802bb4 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b94:	8b 00                	mov    (%rax),%eax
  802b96:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b9a:	48 89 d6             	mov    %rdx,%rsi
  802b9d:	89 c7                	mov    %eax,%edi
  802b9f:	48 b8 58 25 80 00 00 	movabs $0x802558,%rax
  802ba6:	00 00 00 
  802ba9:	ff d0                	callq  *%rax
  802bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb2:	79 05                	jns    802bb9 <fstat+0x59>
		return r;
  802bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb7:	eb 5e                	jmp    802c17 <fstat+0xb7>
	if (!dev->dev_stat)
  802bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbd:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bc1:	48 85 c0             	test   %rax,%rax
  802bc4:	75 07                	jne    802bcd <fstat+0x6d>
		return -E_NOT_SUPP;
  802bc6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bcb:	eb 4a                	jmp    802c17 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd1:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bdf:	00 00 00 
	stat->st_isdir = 0;
  802be2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bed:	00 00 00 
	stat->st_dev = dev;
  802bf0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bf4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c03:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c0b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c0f:	48 89 ce             	mov    %rcx,%rsi
  802c12:	48 89 d7             	mov    %rdx,%rdi
  802c15:	ff d0                	callq  *%rax
}
  802c17:	c9                   	leaveq 
  802c18:	c3                   	retq   

0000000000802c19 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c19:	55                   	push   %rbp
  802c1a:	48 89 e5             	mov    %rsp,%rbp
  802c1d:	48 83 ec 20          	sub    $0x20,%rsp
  802c21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2d:	be 00 00 00 00       	mov    $0x0,%esi
  802c32:	48 89 c7             	mov    %rax,%rdi
  802c35:	48 b8 07 2d 80 00 00 	movabs $0x802d07,%rax
  802c3c:	00 00 00 
  802c3f:	ff d0                	callq  *%rax
  802c41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c48:	79 05                	jns    802c4f <stat+0x36>
		return fd;
  802c4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4d:	eb 2f                	jmp    802c7e <stat+0x65>
	r = fstat(fd, stat);
  802c4f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c56:	48 89 d6             	mov    %rdx,%rsi
  802c59:	89 c7                	mov    %eax,%edi
  802c5b:	48 b8 60 2b 80 00 00 	movabs $0x802b60,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	callq  *%rax
  802c67:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6d:	89 c7                	mov    %eax,%edi
  802c6f:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
	return r;
  802c7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c7e:	c9                   	leaveq 
  802c7f:	c3                   	retq   

0000000000802c80 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c80:	55                   	push   %rbp
  802c81:	48 89 e5             	mov    %rsp,%rbp
  802c84:	48 83 ec 10          	sub    $0x10,%rsp
  802c88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c8f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c96:	00 00 00 
  802c99:	8b 00                	mov    (%rax),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	75 1d                	jne    802cbc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c9f:	bf 01 00 00 00       	mov    $0x1,%edi
  802ca4:	48 b8 97 22 80 00 00 	movabs $0x802297,%rax
  802cab:	00 00 00 
  802cae:	ff d0                	callq  *%rax
  802cb0:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802cb7:	00 00 00 
  802cba:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cbc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cc3:	00 00 00 
  802cc6:	8b 00                	mov    (%rax),%eax
  802cc8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ccb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cd0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802cd7:	00 00 00 
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 ff 21 80 00 00 	movabs $0x8021ff,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ce8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cec:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf1:	48 89 c6             	mov    %rax,%rsi
  802cf4:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf9:	48 b8 3e 21 80 00 00 	movabs $0x80213e,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
}
  802d05:	c9                   	leaveq 
  802d06:	c3                   	retq   

0000000000802d07 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d07:	55                   	push   %rbp
  802d08:	48 89 e5             	mov    %rsp,%rbp
  802d0b:	48 83 ec 20          	sub    $0x20,%rsp
  802d0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d13:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1a:	48 89 c7             	mov    %rax,%rdi
  802d1d:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
  802d29:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d2e:	7e 0a                	jle    802d3a <open+0x33>
		return -E_BAD_PATH;
  802d30:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d35:	e9 a5 00 00 00       	jmpq   802ddf <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802d3a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d3e:	48 89 c7             	mov    %rax,%rdi
  802d41:	48 b8 67 23 80 00 00 	movabs $0x802367,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
  802d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d54:	79 08                	jns    802d5e <open+0x57>
		return r;
  802d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d59:	e9 81 00 00 00       	jmpq   802ddf <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802d5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d62:	48 89 c6             	mov    %rax,%rsi
  802d65:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d6c:	00 00 00 
  802d6f:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  802d76:	00 00 00 
  802d79:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802d7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d82:	00 00 00 
  802d85:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d88:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d92:	48 89 c6             	mov    %rax,%rsi
  802d95:	bf 01 00 00 00       	mov    $0x1,%edi
  802d9a:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dad:	79 1d                	jns    802dcc <open+0xc5>
		fd_close(fd, 0);
  802daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db3:	be 00 00 00 00       	mov    $0x0,%esi
  802db8:	48 89 c7             	mov    %rax,%rdi
  802dbb:	48 b8 8f 24 80 00 00 	movabs $0x80248f,%rax
  802dc2:	00 00 00 
  802dc5:	ff d0                	callq  *%rax
		return r;
  802dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dca:	eb 13                	jmp    802ddf <open+0xd8>
	}

	return fd2num(fd);
  802dcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd0:	48 89 c7             	mov    %rax,%rdi
  802dd3:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802ddf:	c9                   	leaveq 
  802de0:	c3                   	retq   

0000000000802de1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802de1:	55                   	push   %rbp
  802de2:	48 89 e5             	mov    %rsp,%rbp
  802de5:	48 83 ec 10          	sub    $0x10,%rsp
  802de9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ded:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df1:	8b 50 0c             	mov    0xc(%rax),%edx
  802df4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dfb:	00 00 00 
  802dfe:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e00:	be 00 00 00 00       	mov    $0x0,%esi
  802e05:	bf 06 00 00 00       	mov    $0x6,%edi
  802e0a:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
}
  802e16:	c9                   	leaveq 
  802e17:	c3                   	retq   

0000000000802e18 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 30          	sub    $0x30,%rsp
  802e20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e30:	8b 50 0c             	mov    0xc(%rax),%edx
  802e33:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e3a:	00 00 00 
  802e3d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e3f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e46:	00 00 00 
  802e49:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e4d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e51:	be 00 00 00 00       	mov    $0x0,%esi
  802e56:	bf 03 00 00 00       	mov    $0x3,%edi
  802e5b:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
  802e67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6e:	79 08                	jns    802e78 <devfile_read+0x60>
		return r;
  802e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e73:	e9 a4 00 00 00       	jmpq   802f1c <devfile_read+0x104>
	assert(r <= n);
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	48 98                	cltq   
  802e7d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e81:	76 35                	jbe    802eb8 <devfile_read+0xa0>
  802e83:	48 b9 c5 45 80 00 00 	movabs $0x8045c5,%rcx
  802e8a:	00 00 00 
  802e8d:	48 ba cc 45 80 00 00 	movabs $0x8045cc,%rdx
  802e94:	00 00 00 
  802e97:	be 84 00 00 00       	mov    $0x84,%esi
  802e9c:	48 bf e1 45 80 00 00 	movabs $0x8045e1,%rdi
  802ea3:	00 00 00 
  802ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eab:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  802eb2:	00 00 00 
  802eb5:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802eb8:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802ebf:	7e 35                	jle    802ef6 <devfile_read+0xde>
  802ec1:	48 b9 ec 45 80 00 00 	movabs $0x8045ec,%rcx
  802ec8:	00 00 00 
  802ecb:	48 ba cc 45 80 00 00 	movabs $0x8045cc,%rdx
  802ed2:	00 00 00 
  802ed5:	be 85 00 00 00       	mov    $0x85,%esi
  802eda:	48 bf e1 45 80 00 00 	movabs $0x8045e1,%rdi
  802ee1:	00 00 00 
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee9:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  802ef0:	00 00 00 
  802ef3:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef9:	48 63 d0             	movslq %eax,%rdx
  802efc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f00:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f07:	00 00 00 
  802f0a:	48 89 c7             	mov    %rax,%rdi
  802f0d:	48 b8 bc 12 80 00 00 	movabs $0x8012bc,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
	return r;
  802f19:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802f1c:	c9                   	leaveq 
  802f1d:	c3                   	retq   

0000000000802f1e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f1e:	55                   	push   %rbp
  802f1f:	48 89 e5             	mov    %rsp,%rbp
  802f22:	48 83 ec 30          	sub    $0x30,%rsp
  802f26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f36:	8b 50 0c             	mov    0xc(%rax),%edx
  802f39:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f40:	00 00 00 
  802f43:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802f45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f4c:	00 00 00 
  802f4f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f53:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802f57:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f5e:	00 
  802f5f:	76 35                	jbe    802f96 <devfile_write+0x78>
  802f61:	48 b9 f8 45 80 00 00 	movabs $0x8045f8,%rcx
  802f68:	00 00 00 
  802f6b:	48 ba cc 45 80 00 00 	movabs $0x8045cc,%rdx
  802f72:	00 00 00 
  802f75:	be 9e 00 00 00       	mov    $0x9e,%esi
  802f7a:	48 bf e1 45 80 00 00 	movabs $0x8045e1,%rdi
  802f81:	00 00 00 
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
  802f89:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  802f90:	00 00 00 
  802f93:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802f96:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f9e:	48 89 c6             	mov    %rax,%rsi
  802fa1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802fa8:	00 00 00 
  802fab:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802fb7:	be 00 00 00 00       	mov    $0x0,%esi
  802fbc:	bf 04 00 00 00       	mov    $0x4,%edi
  802fc1:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd4:	79 05                	jns    802fdb <devfile_write+0xbd>
		return r;
  802fd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd9:	eb 43                	jmp    80301e <devfile_write+0x100>
	assert(r <= n);
  802fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fde:	48 98                	cltq   
  802fe0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fe4:	76 35                	jbe    80301b <devfile_write+0xfd>
  802fe6:	48 b9 c5 45 80 00 00 	movabs $0x8045c5,%rcx
  802fed:	00 00 00 
  802ff0:	48 ba cc 45 80 00 00 	movabs $0x8045cc,%rdx
  802ff7:	00 00 00 
  802ffa:	be a2 00 00 00       	mov    $0xa2,%esi
  802fff:	48 bf e1 45 80 00 00 	movabs $0x8045e1,%rdi
  803006:	00 00 00 
  803009:	b8 00 00 00 00       	mov    $0x0,%eax
  80300e:	49 b8 de 3b 80 00 00 	movabs $0x803bde,%r8
  803015:	00 00 00 
  803018:	41 ff d0             	callq  *%r8
	return r;
  80301b:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80301e:	c9                   	leaveq 
  80301f:	c3                   	retq   

0000000000803020 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803020:	55                   	push   %rbp
  803021:	48 89 e5             	mov    %rsp,%rbp
  803024:	48 83 ec 20          	sub    $0x20,%rsp
  803028:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80302c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803034:	8b 50 0c             	mov    0xc(%rax),%edx
  803037:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80303e:	00 00 00 
  803041:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803043:	be 00 00 00 00       	mov    $0x0,%esi
  803048:	bf 05 00 00 00       	mov    $0x5,%edi
  80304d:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  803054:	00 00 00 
  803057:	ff d0                	callq  *%rax
  803059:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80305c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803060:	79 05                	jns    803067 <devfile_stat+0x47>
		return r;
  803062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803065:	eb 56                	jmp    8030bd <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803067:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80306b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803072:	00 00 00 
  803075:	48 89 c7             	mov    %rax,%rdi
  803078:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  80307f:	00 00 00 
  803082:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803084:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80308b:	00 00 00 
  80308e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803094:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803098:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80309e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a5:	00 00 00 
  8030a8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030bd:	c9                   	leaveq 
  8030be:	c3                   	retq   

00000000008030bf <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030bf:	55                   	push   %rbp
  8030c0:	48 89 e5             	mov    %rsp,%rbp
  8030c3:	48 83 ec 10          	sub    $0x10,%rsp
  8030c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030cb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8030d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030dc:	00 00 00 
  8030df:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030e1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e8:	00 00 00 
  8030eb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030ee:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030f1:	be 00 00 00 00       	mov    $0x0,%esi
  8030f6:	bf 02 00 00 00       	mov    $0x2,%edi
  8030fb:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  803102:	00 00 00 
  803105:	ff d0                	callq  *%rax
}
  803107:	c9                   	leaveq 
  803108:	c3                   	retq   

0000000000803109 <remove>:

// Delete a file
int
remove(const char *path)
{
  803109:	55                   	push   %rbp
  80310a:	48 89 e5             	mov    %rsp,%rbp
  80310d:	48 83 ec 10          	sub    $0x10,%rsp
  803111:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803119:	48 89 c7             	mov    %rax,%rdi
  80311c:	48 b8 2c 0f 80 00 00 	movabs $0x800f2c,%rax
  803123:	00 00 00 
  803126:	ff d0                	callq  *%rax
  803128:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80312d:	7e 07                	jle    803136 <remove+0x2d>
		return -E_BAD_PATH;
  80312f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803134:	eb 33                	jmp    803169 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313a:	48 89 c6             	mov    %rax,%rsi
  80313d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803144:	00 00 00 
  803147:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803153:	be 00 00 00 00       	mov    $0x0,%esi
  803158:	bf 07 00 00 00       	mov    $0x7,%edi
  80315d:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
}
  803169:	c9                   	leaveq 
  80316a:	c3                   	retq   

000000000080316b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80316b:	55                   	push   %rbp
  80316c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80316f:	be 00 00 00 00       	mov    $0x0,%esi
  803174:	bf 08 00 00 00       	mov    $0x8,%edi
  803179:	48 b8 80 2c 80 00 00 	movabs $0x802c80,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
}
  803185:	5d                   	pop    %rbp
  803186:	c3                   	retq   

0000000000803187 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803187:	55                   	push   %rbp
  803188:	48 89 e5             	mov    %rsp,%rbp
  80318b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803192:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803199:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8031a0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8031a7:	be 00 00 00 00       	mov    $0x0,%esi
  8031ac:	48 89 c7             	mov    %rax,%rdi
  8031af:	48 b8 07 2d 80 00 00 	movabs $0x802d07,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
  8031bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8031be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c2:	79 28                	jns    8031ec <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8031c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c7:	89 c6                	mov    %eax,%esi
  8031c9:	48 bf 25 46 80 00 00 	movabs $0x804625,%rdi
  8031d0:	00 00 00 
  8031d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d8:	48 ba d0 03 80 00 00 	movabs $0x8003d0,%rdx
  8031df:	00 00 00 
  8031e2:	ff d2                	callq  *%rdx
		return fd_src;
  8031e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e7:	e9 74 01 00 00       	jmpq   803360 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8031ec:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8031f3:	be 01 01 00 00       	mov    $0x101,%esi
  8031f8:	48 89 c7             	mov    %rax,%rdi
  8031fb:	48 b8 07 2d 80 00 00 	movabs $0x802d07,%rax
  803202:	00 00 00 
  803205:	ff d0                	callq  *%rax
  803207:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80320a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80320e:	79 39                	jns    803249 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803210:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803213:	89 c6                	mov    %eax,%esi
  803215:	48 bf 3b 46 80 00 00 	movabs $0x80463b,%rdi
  80321c:	00 00 00 
  80321f:	b8 00 00 00 00       	mov    $0x0,%eax
  803224:	48 ba d0 03 80 00 00 	movabs $0x8003d0,%rdx
  80322b:	00 00 00 
  80322e:	ff d2                	callq  *%rdx
		close(fd_src);
  803230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803233:	89 c7                	mov    %eax,%edi
  803235:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
		return fd_dest;
  803241:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803244:	e9 17 01 00 00       	jmpq   803360 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803249:	eb 74                	jmp    8032bf <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80324b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80324e:	48 63 d0             	movslq %eax,%rdx
  803251:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803258:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80325b:	48 89 ce             	mov    %rcx,%rsi
  80325e:	89 c7                	mov    %eax,%edi
  803260:	48 b8 7b 29 80 00 00 	movabs $0x80297b,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
  80326c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80326f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803273:	79 4a                	jns    8032bf <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803275:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803278:	89 c6                	mov    %eax,%esi
  80327a:	48 bf 55 46 80 00 00 	movabs $0x804655,%rdi
  803281:	00 00 00 
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
  803289:	48 ba d0 03 80 00 00 	movabs $0x8003d0,%rdx
  803290:	00 00 00 
  803293:	ff d2                	callq  *%rdx
			close(fd_src);
  803295:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803298:	89 c7                	mov    %eax,%edi
  80329a:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
			close(fd_dest);
  8032a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032a9:	89 c7                	mov    %eax,%edi
  8032ab:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
			return write_size;
  8032b7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032ba:	e9 a1 00 00 00       	jmpq   803360 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032bf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c9:	ba 00 02 00 00       	mov    $0x200,%edx
  8032ce:	48 89 ce             	mov    %rcx,%rsi
  8032d1:	89 c7                	mov    %eax,%edi
  8032d3:	48 b8 31 28 80 00 00 	movabs $0x802831,%rax
  8032da:	00 00 00 
  8032dd:	ff d0                	callq  *%rax
  8032df:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032e6:	0f 8f 5f ff ff ff    	jg     80324b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8032ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032f0:	79 47                	jns    803339 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8032f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032f5:	89 c6                	mov    %eax,%esi
  8032f7:	48 bf 68 46 80 00 00 	movabs $0x804668,%rdi
  8032fe:	00 00 00 
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
  803306:	48 ba d0 03 80 00 00 	movabs $0x8003d0,%rdx
  80330d:	00 00 00 
  803310:	ff d2                	callq  *%rdx
		close(fd_src);
  803312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803315:	89 c7                	mov    %eax,%edi
  803317:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
		close(fd_dest);
  803323:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803326:	89 c7                	mov    %eax,%edi
  803328:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
		return read_size;
  803334:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803337:	eb 27                	jmp    803360 <copy+0x1d9>
	}
	close(fd_src);
  803339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333c:	89 c7                	mov    %eax,%edi
  80333e:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
	close(fd_dest);
  80334a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80334d:	89 c7                	mov    %eax,%edi
  80334f:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
	return 0;
  80335b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  803360:	c9                   	leaveq 
  803361:	c3                   	retq   

0000000000803362 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803362:	55                   	push   %rbp
  803363:	48 89 e5             	mov    %rsp,%rbp
  803366:	53                   	push   %rbx
  803367:	48 83 ec 38          	sub    $0x38,%rsp
  80336b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80336f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803373:	48 89 c7             	mov    %rax,%rdi
  803376:	48 b8 67 23 80 00 00 	movabs $0x802367,%rax
  80337d:	00 00 00 
  803380:	ff d0                	callq  *%rax
  803382:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803385:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803389:	0f 88 bf 01 00 00    	js     80354e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80338f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803393:	ba 07 04 00 00       	mov    $0x407,%edx
  803398:	48 89 c6             	mov    %rax,%rsi
  80339b:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a0:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
  8033ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033b3:	0f 88 95 01 00 00    	js     80354e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8033b9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033bd:	48 89 c7             	mov    %rax,%rdi
  8033c0:	48 b8 67 23 80 00 00 	movabs $0x802367,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	callq  *%rax
  8033cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d3:	0f 88 5d 01 00 00    	js     803536 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033dd:	ba 07 04 00 00       	mov    $0x407,%edx
  8033e2:	48 89 c6             	mov    %rax,%rsi
  8033e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ea:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8033f1:	00 00 00 
  8033f4:	ff d0                	callq  *%rax
  8033f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033fd:	0f 88 33 01 00 00    	js     803536 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803407:	48 89 c7             	mov    %rax,%rdi
  80340a:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  803411:	00 00 00 
  803414:	ff d0                	callq  *%rax
  803416:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80341a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341e:	ba 07 04 00 00       	mov    $0x407,%edx
  803423:	48 89 c6             	mov    %rax,%rsi
  803426:	bf 00 00 00 00       	mov    $0x0,%edi
  80342b:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
  803437:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80343a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80343e:	79 05                	jns    803445 <pipe+0xe3>
		goto err2;
  803440:	e9 d9 00 00 00       	jmpq   80351e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803445:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803449:	48 89 c7             	mov    %rax,%rdi
  80344c:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  803453:	00 00 00 
  803456:	ff d0                	callq  *%rax
  803458:	48 89 c2             	mov    %rax,%rdx
  80345b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80345f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803465:	48 89 d1             	mov    %rdx,%rcx
  803468:	ba 00 00 00 00       	mov    $0x0,%edx
  80346d:	48 89 c6             	mov    %rax,%rsi
  803470:	bf 00 00 00 00       	mov    $0x0,%edi
  803475:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
  803481:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803484:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803488:	79 1b                	jns    8034a5 <pipe+0x143>
		goto err3;
  80348a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80348b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80348f:	48 89 c6             	mov    %rax,%rsi
  803492:	bf 00 00 00 00       	mov    $0x0,%edi
  803497:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  80349e:	00 00 00 
  8034a1:	ff d0                	callq  *%rax
  8034a3:	eb 79                	jmp    80351e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8034a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034a9:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8034b0:	00 00 00 
  8034b3:	8b 12                	mov    (%rdx),%edx
  8034b5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8034b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8034c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c6:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8034cd:	00 00 00 
  8034d0:	8b 12                	mov    (%rdx),%edx
  8034d2:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8034d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8034df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e3:	48 89 c7             	mov    %rax,%rdi
  8034e6:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
  8034f2:	89 c2                	mov    %eax,%edx
  8034f4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034f8:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8034fa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034fe:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803502:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803506:	48 89 c7             	mov    %rax,%rdi
  803509:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
  803515:	89 03                	mov    %eax,(%rbx)
	return 0;
  803517:	b8 00 00 00 00       	mov    $0x0,%eax
  80351c:	eb 33                	jmp    803551 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80351e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803522:	48 89 c6             	mov    %rax,%rsi
  803525:	bf 00 00 00 00       	mov    $0x0,%edi
  80352a:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80353a:	48 89 c6             	mov    %rax,%rsi
  80353d:	bf 00 00 00 00       	mov    $0x0,%edi
  803542:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  803549:	00 00 00 
  80354c:	ff d0                	callq  *%rax
err:
	return r;
  80354e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803551:	48 83 c4 38          	add    $0x38,%rsp
  803555:	5b                   	pop    %rbx
  803556:	5d                   	pop    %rbp
  803557:	c3                   	retq   

0000000000803558 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803558:	55                   	push   %rbp
  803559:	48 89 e5             	mov    %rsp,%rbp
  80355c:	53                   	push   %rbx
  80355d:	48 83 ec 28          	sub    $0x28,%rsp
  803561:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803565:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803569:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803570:	00 00 00 
  803573:	48 8b 00             	mov    (%rax),%rax
  803576:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80357c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80357f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803583:	48 89 c7             	mov    %rax,%rdi
  803586:	48 b8 3c 3e 80 00 00 	movabs $0x803e3c,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	89 c3                	mov    %eax,%ebx
  803594:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803598:	48 89 c7             	mov    %rax,%rdi
  80359b:	48 b8 3c 3e 80 00 00 	movabs $0x803e3c,%rax
  8035a2:	00 00 00 
  8035a5:	ff d0                	callq  *%rax
  8035a7:	39 c3                	cmp    %eax,%ebx
  8035a9:	0f 94 c0             	sete   %al
  8035ac:	0f b6 c0             	movzbl %al,%eax
  8035af:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8035b2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8035b9:	00 00 00 
  8035bc:	48 8b 00             	mov    (%rax),%rax
  8035bf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035c5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8035c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035cb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035ce:	75 05                	jne    8035d5 <_pipeisclosed+0x7d>
			return ret;
  8035d0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035d3:	eb 4f                	jmp    803624 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8035d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035db:	74 42                	je     80361f <_pipeisclosed+0xc7>
  8035dd:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8035e1:	75 3c                	jne    80361f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035e3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8035ea:	00 00 00 
  8035ed:	48 8b 00             	mov    (%rax),%rax
  8035f0:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8035f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035fc:	89 c6                	mov    %eax,%esi
  8035fe:	48 bf 83 46 80 00 00 	movabs $0x804683,%rdi
  803605:	00 00 00 
  803608:	b8 00 00 00 00       	mov    $0x0,%eax
  80360d:	49 b8 d0 03 80 00 00 	movabs $0x8003d0,%r8
  803614:	00 00 00 
  803617:	41 ff d0             	callq  *%r8
	}
  80361a:	e9 4a ff ff ff       	jmpq   803569 <_pipeisclosed+0x11>
  80361f:	e9 45 ff ff ff       	jmpq   803569 <_pipeisclosed+0x11>
}
  803624:	48 83 c4 28          	add    $0x28,%rsp
  803628:	5b                   	pop    %rbx
  803629:	5d                   	pop    %rbp
  80362a:	c3                   	retq   

000000000080362b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80362b:	55                   	push   %rbp
  80362c:	48 89 e5             	mov    %rsp,%rbp
  80362f:	48 83 ec 30          	sub    $0x30,%rsp
  803633:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803636:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80363a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80363d:	48 89 d6             	mov    %rdx,%rsi
  803640:	89 c7                	mov    %eax,%edi
  803642:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  803649:	00 00 00 
  80364c:	ff d0                	callq  *%rax
  80364e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803655:	79 05                	jns    80365c <pipeisclosed+0x31>
		return r;
  803657:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365a:	eb 31                	jmp    80368d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80365c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803660:	48 89 c7             	mov    %rax,%rdi
  803663:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  80366a:	00 00 00 
  80366d:	ff d0                	callq  *%rax
  80366f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803677:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80367b:	48 89 d6             	mov    %rdx,%rsi
  80367e:	48 89 c7             	mov    %rax,%rdi
  803681:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  803688:	00 00 00 
  80368b:	ff d0                	callq  *%rax
}
  80368d:	c9                   	leaveq 
  80368e:	c3                   	retq   

000000000080368f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80368f:	55                   	push   %rbp
  803690:	48 89 e5             	mov    %rsp,%rbp
  803693:	48 83 ec 40          	sub    $0x40,%rsp
  803697:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80369b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80369f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a7:	48 89 c7             	mov    %rax,%rdi
  8036aa:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  8036b1:	00 00 00 
  8036b4:	ff d0                	callq  *%rax
  8036b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036c2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036c9:	00 
  8036ca:	e9 92 00 00 00       	jmpq   803761 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8036cf:	eb 41                	jmp    803712 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8036d1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8036d6:	74 09                	je     8036e1 <devpipe_read+0x52>
				return i;
  8036d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036dc:	e9 92 00 00 00       	jmpq   803773 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8036e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e9:	48 89 d6             	mov    %rdx,%rsi
  8036ec:	48 89 c7             	mov    %rax,%rdi
  8036ef:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 07                	je     803706 <devpipe_read+0x77>
				return 0;
  8036ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803704:	eb 6d                	jmp    803773 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803706:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  80370d:	00 00 00 
  803710:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803716:	8b 10                	mov    (%rax),%edx
  803718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371c:	8b 40 04             	mov    0x4(%rax),%eax
  80371f:	39 c2                	cmp    %eax,%edx
  803721:	74 ae                	je     8036d1 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80372b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80372f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803733:	8b 00                	mov    (%rax),%eax
  803735:	99                   	cltd   
  803736:	c1 ea 1b             	shr    $0x1b,%edx
  803739:	01 d0                	add    %edx,%eax
  80373b:	83 e0 1f             	and    $0x1f,%eax
  80373e:	29 d0                	sub    %edx,%eax
  803740:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803744:	48 98                	cltq   
  803746:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80374b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80374d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803751:	8b 00                	mov    (%rax),%eax
  803753:	8d 50 01             	lea    0x1(%rax),%edx
  803756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80375c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803765:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803769:	0f 82 60 ff ff ff    	jb     8036cf <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80376f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803773:	c9                   	leaveq 
  803774:	c3                   	retq   

0000000000803775 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803775:	55                   	push   %rbp
  803776:	48 89 e5             	mov    %rsp,%rbp
  803779:	48 83 ec 40          	sub    $0x40,%rsp
  80377d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803781:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803785:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80378d:	48 89 c7             	mov    %rax,%rdi
  803790:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
  80379c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037a8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037af:	00 
  8037b0:	e9 8e 00 00 00       	jmpq   803843 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037b5:	eb 31                	jmp    8037e8 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8037b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037bf:	48 89 d6             	mov    %rdx,%rsi
  8037c2:	48 89 c7             	mov    %rax,%rdi
  8037c5:	48 b8 58 35 80 00 00 	movabs $0x803558,%rax
  8037cc:	00 00 00 
  8037cf:	ff d0                	callq  *%rax
  8037d1:	85 c0                	test   %eax,%eax
  8037d3:	74 07                	je     8037dc <devpipe_write+0x67>
				return 0;
  8037d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8037da:	eb 79                	jmp    803855 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8037dc:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ec:	8b 40 04             	mov    0x4(%rax),%eax
  8037ef:	48 63 d0             	movslq %eax,%rdx
  8037f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f6:	8b 00                	mov    (%rax),%eax
  8037f8:	48 98                	cltq   
  8037fa:	48 83 c0 20          	add    $0x20,%rax
  8037fe:	48 39 c2             	cmp    %rax,%rdx
  803801:	73 b4                	jae    8037b7 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803807:	8b 40 04             	mov    0x4(%rax),%eax
  80380a:	99                   	cltd   
  80380b:	c1 ea 1b             	shr    $0x1b,%edx
  80380e:	01 d0                	add    %edx,%eax
  803810:	83 e0 1f             	and    $0x1f,%eax
  803813:	29 d0                	sub    %edx,%eax
  803815:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803819:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80381d:	48 01 ca             	add    %rcx,%rdx
  803820:	0f b6 0a             	movzbl (%rdx),%ecx
  803823:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803827:	48 98                	cltq   
  803829:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80382d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803831:	8b 40 04             	mov    0x4(%rax),%eax
  803834:	8d 50 01             	lea    0x1(%rax),%edx
  803837:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80383e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803843:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803847:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80384b:	0f 82 64 ff ff ff    	jb     8037b5 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803855:	c9                   	leaveq 
  803856:	c3                   	retq   

0000000000803857 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803857:	55                   	push   %rbp
  803858:	48 89 e5             	mov    %rsp,%rbp
  80385b:	48 83 ec 20          	sub    $0x20,%rsp
  80385f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803863:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80386b:	48 89 c7             	mov    %rax,%rdi
  80386e:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  803875:	00 00 00 
  803878:	ff d0                	callq  *%rax
  80387a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80387e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803882:	48 be 96 46 80 00 00 	movabs $0x804696,%rsi
  803889:	00 00 00 
  80388c:	48 89 c7             	mov    %rax,%rdi
  80388f:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80389b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389f:	8b 50 04             	mov    0x4(%rax),%edx
  8038a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a6:	8b 00                	mov    (%rax),%eax
  8038a8:	29 c2                	sub    %eax,%edx
  8038aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ae:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8038b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8038bf:	00 00 00 
	stat->st_dev = &devpipe;
  8038c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038c6:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8038cd:	00 00 00 
  8038d0:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8038d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038dc:	c9                   	leaveq 
  8038dd:	c3                   	retq   

00000000008038de <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8038de:	55                   	push   %rbp
  8038df:	48 89 e5             	mov    %rsp,%rbp
  8038e2:	48 83 ec 10          	sub    $0x10,%rsp
  8038e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8038ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ee:	48 89 c6             	mov    %rax,%rsi
  8038f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f6:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  8038fd:	00 00 00 
  803900:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803902:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803906:	48 89 c7             	mov    %rax,%rdi
  803909:	48 b8 3c 23 80 00 00 	movabs $0x80233c,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
  803915:	48 89 c6             	mov    %rax,%rsi
  803918:	bf 00 00 00 00       	mov    $0x0,%edi
  80391d:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
}
  803929:	c9                   	leaveq 
  80392a:	c3                   	retq   

000000000080392b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80392b:	55                   	push   %rbp
  80392c:	48 89 e5             	mov    %rsp,%rbp
  80392f:	48 83 ec 20          	sub    $0x20,%rsp
  803933:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803936:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803939:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80393c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803940:	be 01 00 00 00       	mov    $0x1,%esi
  803945:	48 89 c7             	mov    %rax,%rdi
  803948:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  80394f:	00 00 00 
  803952:	ff d0                	callq  *%rax
}
  803954:	c9                   	leaveq 
  803955:	c3                   	retq   

0000000000803956 <getchar>:

int
getchar(void)
{
  803956:	55                   	push   %rbp
  803957:	48 89 e5             	mov    %rsp,%rbp
  80395a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80395e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803962:	ba 01 00 00 00       	mov    $0x1,%edx
  803967:	48 89 c6             	mov    %rax,%rsi
  80396a:	bf 00 00 00 00       	mov    $0x0,%edi
  80396f:	48 b8 31 28 80 00 00 	movabs $0x802831,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
  80397b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80397e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803982:	79 05                	jns    803989 <getchar+0x33>
		return r;
  803984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803987:	eb 14                	jmp    80399d <getchar+0x47>
	if (r < 1)
  803989:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80398d:	7f 07                	jg     803996 <getchar+0x40>
		return -E_EOF;
  80398f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803994:	eb 07                	jmp    80399d <getchar+0x47>
	return c;
  803996:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80399a:	0f b6 c0             	movzbl %al,%eax
}
  80399d:	c9                   	leaveq 
  80399e:	c3                   	retq   

000000000080399f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80399f:	55                   	push   %rbp
  8039a0:	48 89 e5             	mov    %rsp,%rbp
  8039a3:	48 83 ec 20          	sub    $0x20,%rsp
  8039a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039aa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039b1:	48 89 d6             	mov    %rdx,%rsi
  8039b4:	89 c7                	mov    %eax,%edi
  8039b6:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
  8039c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c9:	79 05                	jns    8039d0 <iscons+0x31>
		return r;
  8039cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ce:	eb 1a                	jmp    8039ea <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8039d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d4:	8b 10                	mov    (%rax),%edx
  8039d6:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8039dd:	00 00 00 
  8039e0:	8b 00                	mov    (%rax),%eax
  8039e2:	39 c2                	cmp    %eax,%edx
  8039e4:	0f 94 c0             	sete   %al
  8039e7:	0f b6 c0             	movzbl %al,%eax
}
  8039ea:	c9                   	leaveq 
  8039eb:	c3                   	retq   

00000000008039ec <opencons>:

int
opencons(void)
{
  8039ec:	55                   	push   %rbp
  8039ed:	48 89 e5             	mov    %rsp,%rbp
  8039f0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8039f4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039f8:	48 89 c7             	mov    %rax,%rdi
  8039fb:	48 b8 67 23 80 00 00 	movabs $0x802367,%rax
  803a02:	00 00 00 
  803a05:	ff d0                	callq  *%rax
  803a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a0e:	79 05                	jns    803a15 <opencons+0x29>
		return r;
  803a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a13:	eb 5b                	jmp    803a70 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a19:	ba 07 04 00 00       	mov    $0x407,%edx
  803a1e:	48 89 c6             	mov    %rax,%rsi
  803a21:	bf 00 00 00 00       	mov    $0x0,%edi
  803a26:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
  803a32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a39:	79 05                	jns    803a40 <opencons+0x54>
		return r;
  803a3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3e:	eb 30                	jmp    803a70 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803a40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a44:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803a4b:	00 00 00 
  803a4e:	8b 12                	mov    (%rdx),%edx
  803a50:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803a52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a56:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a61:	48 89 c7             	mov    %rax,%rdi
  803a64:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  803a6b:	00 00 00 
  803a6e:	ff d0                	callq  *%rax
}
  803a70:	c9                   	leaveq 
  803a71:	c3                   	retq   

0000000000803a72 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a72:	55                   	push   %rbp
  803a73:	48 89 e5             	mov    %rsp,%rbp
  803a76:	48 83 ec 30          	sub    $0x30,%rsp
  803a7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a82:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a86:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a8b:	75 07                	jne    803a94 <devcons_read+0x22>
		return 0;
  803a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a92:	eb 4b                	jmp    803adf <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803a94:	eb 0c                	jmp    803aa2 <devcons_read+0x30>
		sys_yield();
  803a96:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803aa2:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
  803aae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ab1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab5:	74 df                	je     803a96 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abb:	79 05                	jns    803ac2 <devcons_read+0x50>
		return c;
  803abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac0:	eb 1d                	jmp    803adf <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ac2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ac6:	75 07                	jne    803acf <devcons_read+0x5d>
		return 0;
  803ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  803acd:	eb 10                	jmp    803adf <devcons_read+0x6d>
	*(char*)vbuf = c;
  803acf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad2:	89 c2                	mov    %eax,%edx
  803ad4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad8:	88 10                	mov    %dl,(%rax)
	return 1;
  803ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803adf:	c9                   	leaveq 
  803ae0:	c3                   	retq   

0000000000803ae1 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ae1:	55                   	push   %rbp
  803ae2:	48 89 e5             	mov    %rsp,%rbp
  803ae5:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803aec:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803af3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803afa:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b08:	eb 76                	jmp    803b80 <devcons_write+0x9f>
		m = n - tot;
  803b0a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803b11:	89 c2                	mov    %eax,%edx
  803b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b16:	29 c2                	sub    %eax,%edx
  803b18:	89 d0                	mov    %edx,%eax
  803b1a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803b1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b20:	83 f8 7f             	cmp    $0x7f,%eax
  803b23:	76 07                	jbe    803b2c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803b25:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803b2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b2f:	48 63 d0             	movslq %eax,%rdx
  803b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b35:	48 63 c8             	movslq %eax,%rcx
  803b38:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803b3f:	48 01 c1             	add    %rax,%rcx
  803b42:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b49:	48 89 ce             	mov    %rcx,%rsi
  803b4c:	48 89 c7             	mov    %rax,%rdi
  803b4f:	48 b8 bc 12 80 00 00 	movabs $0x8012bc,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803b5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b5e:	48 63 d0             	movslq %eax,%rdx
  803b61:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b68:	48 89 d6             	mov    %rdx,%rsi
  803b6b:	48 89 c7             	mov    %rax,%rdi
  803b6e:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  803b75:	00 00 00 
  803b78:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b7d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b83:	48 98                	cltq   
  803b85:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b8c:	0f 82 78 ff ff ff    	jb     803b0a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b92:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b95:	c9                   	leaveq 
  803b96:	c3                   	retq   

0000000000803b97 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b97:	55                   	push   %rbp
  803b98:	48 89 e5             	mov    %rsp,%rbp
  803b9b:	48 83 ec 08          	sub    $0x8,%rsp
  803b9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ba8:	c9                   	leaveq 
  803ba9:	c3                   	retq   

0000000000803baa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803baa:	55                   	push   %rbp
  803bab:	48 89 e5             	mov    %rsp,%rbp
  803bae:	48 83 ec 10          	sub    $0x10,%rsp
  803bb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803bb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbe:	48 be a2 46 80 00 00 	movabs $0x8046a2,%rsi
  803bc5:	00 00 00 
  803bc8:	48 89 c7             	mov    %rax,%rdi
  803bcb:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  803bd2:	00 00 00 
  803bd5:	ff d0                	callq  *%rax
	return 0;
  803bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bdc:	c9                   	leaveq 
  803bdd:	c3                   	retq   

0000000000803bde <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803bde:	55                   	push   %rbp
  803bdf:	48 89 e5             	mov    %rsp,%rbp
  803be2:	53                   	push   %rbx
  803be3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803bea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803bf1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803bf7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803bfe:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803c05:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803c0c:	84 c0                	test   %al,%al
  803c0e:	74 23                	je     803c33 <_panic+0x55>
  803c10:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803c17:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803c1b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803c1f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803c23:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803c27:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803c2b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803c2f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803c33:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803c3a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803c41:	00 00 00 
  803c44:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803c4b:	00 00 00 
  803c4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c52:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803c59:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803c60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803c67:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803c6e:	00 00 00 
  803c71:	48 8b 18             	mov    (%rax),%rbx
  803c74:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  803c7b:	00 00 00 
  803c7e:	ff d0                	callq  *%rax
  803c80:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803c86:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803c8d:	41 89 c8             	mov    %ecx,%r8d
  803c90:	48 89 d1             	mov    %rdx,%rcx
  803c93:	48 89 da             	mov    %rbx,%rdx
  803c96:	89 c6                	mov    %eax,%esi
  803c98:	48 bf b0 46 80 00 00 	movabs $0x8046b0,%rdi
  803c9f:	00 00 00 
  803ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca7:	49 b9 d0 03 80 00 00 	movabs $0x8003d0,%r9
  803cae:	00 00 00 
  803cb1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803cb4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803cbb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803cc2:	48 89 d6             	mov    %rdx,%rsi
  803cc5:	48 89 c7             	mov    %rax,%rdi
  803cc8:	48 b8 24 03 80 00 00 	movabs $0x800324,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
	cprintf("\n");
  803cd4:	48 bf d3 46 80 00 00 	movabs $0x8046d3,%rdi
  803cdb:	00 00 00 
  803cde:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce3:	48 ba d0 03 80 00 00 	movabs $0x8003d0,%rdx
  803cea:	00 00 00 
  803ced:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803cef:	cc                   	int3   
  803cf0:	eb fd                	jmp    803cef <_panic+0x111>

0000000000803cf2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803cf2:	55                   	push   %rbp
  803cf3:	48 89 e5             	mov    %rsp,%rbp
  803cf6:	48 83 ec 10          	sub    $0x10,%rsp
  803cfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803cfe:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d05:	00 00 00 
  803d08:	48 8b 00             	mov    (%rax),%rax
  803d0b:	48 85 c0             	test   %rax,%rax
  803d0e:	75 49                	jne    803d59 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803d10:	ba 07 00 00 00       	mov    $0x7,%edx
  803d15:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d1f:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803d26:	00 00 00 
  803d29:	ff d0                	callq  *%rax
  803d2b:	85 c0                	test   %eax,%eax
  803d2d:	79 2a                	jns    803d59 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803d2f:	48 ba d8 46 80 00 00 	movabs $0x8046d8,%rdx
  803d36:	00 00 00 
  803d39:	be 21 00 00 00       	mov    $0x21,%esi
  803d3e:	48 bf 03 47 80 00 00 	movabs $0x804703,%rdi
  803d45:	00 00 00 
  803d48:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4d:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  803d54:	00 00 00 
  803d57:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803d59:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d60:	00 00 00 
  803d63:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d67:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803d6a:	48 be b5 3d 80 00 00 	movabs $0x803db5,%rsi
  803d71:	00 00 00 
  803d74:	bf 00 00 00 00       	mov    $0x0,%edi
  803d79:	48 b8 51 1a 80 00 00 	movabs $0x801a51,%rax
  803d80:	00 00 00 
  803d83:	ff d0                	callq  *%rax
  803d85:	85 c0                	test   %eax,%eax
  803d87:	79 2a                	jns    803db3 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803d89:	48 ba 18 47 80 00 00 	movabs $0x804718,%rdx
  803d90:	00 00 00 
  803d93:	be 27 00 00 00       	mov    $0x27,%esi
  803d98:	48 bf 03 47 80 00 00 	movabs $0x804703,%rdi
  803d9f:	00 00 00 
  803da2:	b8 00 00 00 00       	mov    $0x0,%eax
  803da7:	48 b9 de 3b 80 00 00 	movabs $0x803bde,%rcx
  803dae:	00 00 00 
  803db1:	ff d1                	callq  *%rcx
}
  803db3:	c9                   	leaveq 
  803db4:	c3                   	retq   

0000000000803db5 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803db5:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803db8:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803dbf:	00 00 00 
call *%rax
  803dc2:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803dc4:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803dcb:	00 
    movq 152(%rsp), %rcx
  803dcc:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803dd3:	00 
    subq $8, %rcx
  803dd4:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803dd8:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803ddb:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803de2:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803de3:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803de7:	4c 8b 3c 24          	mov    (%rsp),%r15
  803deb:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803df0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803df5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803dfa:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803dff:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e04:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e09:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e0e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e13:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e18:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e1d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e22:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e27:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e2c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e31:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803e35:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803e39:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803e3a:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803e3b:	c3                   	retq   

0000000000803e3c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e3c:	55                   	push   %rbp
  803e3d:	48 89 e5             	mov    %rsp,%rbp
  803e40:	48 83 ec 18          	sub    $0x18,%rsp
  803e44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4c:	48 c1 e8 15          	shr    $0x15,%rax
  803e50:	48 89 c2             	mov    %rax,%rdx
  803e53:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e5a:	01 00 00 
  803e5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e61:	83 e0 01             	and    $0x1,%eax
  803e64:	48 85 c0             	test   %rax,%rax
  803e67:	75 07                	jne    803e70 <pageref+0x34>
		return 0;
  803e69:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6e:	eb 53                	jmp    803ec3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e74:	48 c1 e8 0c          	shr    $0xc,%rax
  803e78:	48 89 c2             	mov    %rax,%rdx
  803e7b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e82:	01 00 00 
  803e85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e89:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e91:	83 e0 01             	and    $0x1,%eax
  803e94:	48 85 c0             	test   %rax,%rax
  803e97:	75 07                	jne    803ea0 <pageref+0x64>
		return 0;
  803e99:	b8 00 00 00 00       	mov    $0x0,%eax
  803e9e:	eb 23                	jmp    803ec3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ea4:	48 c1 e8 0c          	shr    $0xc,%rax
  803ea8:	48 89 c2             	mov    %rax,%rdx
  803eab:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803eb2:	00 00 00 
  803eb5:	48 c1 e2 04          	shl    $0x4,%rdx
  803eb9:	48 01 d0             	add    %rdx,%rax
  803ebc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ec0:	0f b7 c0             	movzwl %ax,%eax
}
  803ec3:	c9                   	leaveq 
  803ec4:	c3                   	retq   
