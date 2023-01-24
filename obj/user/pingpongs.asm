
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
  800060:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf 40 25 80 00 00 	movabs $0x802540,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 c4 03 80 00 00 	movabs $0x8003c4,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf 5a 25 80 00 00 	movabs $0x80255a,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 c4 03 80 00 00 	movabs $0x8003c4,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 e8 20 80 00 00 	movabs $0x8020e8,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf 70 25 80 00 00 	movabs $0x802570,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba c4 03 80 00 00 	movabs $0x8003c4,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 a9 21 80 00 00 	movabs $0x8021a9,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
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
	envid_t id = sys_getenvid();
  800206:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
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
  80023b:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  800242:	00 00 00 
  800245:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800248:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80024c:	7e 14                	jle    800262 <libmain+0x6b>
		binaryname = argv[0];
  80024e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800252:	48 8b 10             	mov    (%rax),%rdx
  800255:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
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
	sys_env_destroy(0);
  80028c:	bf 00 00 00 00       	mov    $0x0,%edi
  800291:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  800298:	00 00 00 
  80029b:	ff d0                	callq  *%rax
}
  80029d:	5d                   	pop    %rbp
  80029e:	c3                   	retq   

000000000080029f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80029f:	55                   	push   %rbp
  8002a0:	48 89 e5             	mov    %rsp,%rbp
  8002a3:	48 83 ec 10          	sub    $0x10,%rsp
  8002a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b2:	8b 00                	mov    (%rax),%eax
  8002b4:	8d 48 01             	lea    0x1(%rax),%ecx
  8002b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002bb:	89 0a                	mov    %ecx,(%rdx)
  8002bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002c0:	89 d1                	mov    %edx,%ecx
  8002c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c6:	48 98                	cltq   
  8002c8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d0:	8b 00                	mov    (%rax),%eax
  8002d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d7:	75 2c                	jne    800305 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002dd:	8b 00                	mov    (%rax),%eax
  8002df:	48 98                	cltq   
  8002e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002e5:	48 83 c2 08          	add    $0x8,%rdx
  8002e9:	48 89 c6             	mov    %rax,%rsi
  8002ec:	48 89 d7             	mov    %rdx,%rdi
  8002ef:	48 b8 73 17 80 00 00 	movabs $0x801773,%rax
  8002f6:	00 00 00 
  8002f9:	ff d0                	callq  *%rax
        b->idx = 0;
  8002fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ff:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800309:	8b 40 04             	mov    0x4(%rax),%eax
  80030c:	8d 50 01             	lea    0x1(%rax),%edx
  80030f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800313:	89 50 04             	mov    %edx,0x4(%rax)
}
  800316:	c9                   	leaveq 
  800317:	c3                   	retq   

0000000000800318 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800318:	55                   	push   %rbp
  800319:	48 89 e5             	mov    %rsp,%rbp
  80031c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800323:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80032a:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800331:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800338:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80033f:	48 8b 0a             	mov    (%rdx),%rcx
  800342:	48 89 08             	mov    %rcx,(%rax)
  800345:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800349:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80034d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800351:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800355:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80035c:	00 00 00 
    b.cnt = 0;
  80035f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800366:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800369:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800370:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800377:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80037e:	48 89 c6             	mov    %rax,%rsi
  800381:	48 bf 9f 02 80 00 00 	movabs $0x80029f,%rdi
  800388:	00 00 00 
  80038b:	48 b8 77 07 80 00 00 	movabs $0x800777,%rax
  800392:	00 00 00 
  800395:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800397:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80039d:	48 98                	cltq   
  80039f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003a6:	48 83 c2 08          	add    $0x8,%rdx
  8003aa:	48 89 c6             	mov    %rax,%rsi
  8003ad:	48 89 d7             	mov    %rdx,%rdi
  8003b0:	48 b8 73 17 80 00 00 	movabs $0x801773,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003c2:	c9                   	leaveq 
  8003c3:	c3                   	retq   

00000000008003c4 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003c4:	55                   	push   %rbp
  8003c5:	48 89 e5             	mov    %rsp,%rbp
  8003c8:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003cf:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003d6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003f2:	84 c0                	test   %al,%al
  8003f4:	74 20                	je     800416 <cprintf+0x52>
  8003f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800402:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800406:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80040a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80040e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800412:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800416:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80041d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800424:	00 00 00 
  800427:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80042e:	00 00 00 
  800431:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800435:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80043c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800443:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80044a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800451:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800458:	48 8b 0a             	mov    (%rdx),%rcx
  80045b:	48 89 08             	mov    %rcx,(%rax)
  80045e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800462:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800466:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80046a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80046e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800475:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80047c:	48 89 d6             	mov    %rdx,%rsi
  80047f:	48 89 c7             	mov    %rax,%rdi
  800482:	48 b8 18 03 80 00 00 	movabs $0x800318,%rax
  800489:	00 00 00 
  80048c:	ff d0                	callq  *%rax
  80048e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800494:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80049a:	c9                   	leaveq 
  80049b:	c3                   	retq   

000000000080049c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80049c:	55                   	push   %rbp
  80049d:	48 89 e5             	mov    %rsp,%rbp
  8004a0:	53                   	push   %rbx
  8004a1:	48 83 ec 38          	sub    $0x38,%rsp
  8004a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004b1:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004b4:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004b8:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004bc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004bf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004c3:	77 3b                	ja     800500 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c5:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004c8:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004cc:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d8:	48 f7 f3             	div    %rbx
  8004db:	48 89 c2             	mov    %rax,%rdx
  8004de:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004e1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004e4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ec:	41 89 f9             	mov    %edi,%r9d
  8004ef:	48 89 c7             	mov    %rax,%rdi
  8004f2:	48 b8 9c 04 80 00 00 	movabs $0x80049c,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax
  8004fe:	eb 1e                	jmp    80051e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800500:	eb 12                	jmp    800514 <printnum+0x78>
			putch(padc, putdat);
  800502:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800506:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	48 89 ce             	mov    %rcx,%rsi
  800510:	89 d7                	mov    %edx,%edi
  800512:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800514:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800518:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80051c:	7f e4                	jg     800502 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80051e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800525:	ba 00 00 00 00       	mov    $0x0,%edx
  80052a:	48 f7 f1             	div    %rcx
  80052d:	48 89 d0             	mov    %rdx,%rax
  800530:	48 ba f0 26 80 00 00 	movabs $0x8026f0,%rdx
  800537:	00 00 00 
  80053a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80053e:	0f be d0             	movsbl %al,%edx
  800541:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800549:	48 89 ce             	mov    %rcx,%rsi
  80054c:	89 d7                	mov    %edx,%edi
  80054e:	ff d0                	callq  *%rax
}
  800550:	48 83 c4 38          	add    $0x38,%rsp
  800554:	5b                   	pop    %rbx
  800555:	5d                   	pop    %rbp
  800556:	c3                   	retq   

0000000000800557 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800557:	55                   	push   %rbp
  800558:	48 89 e5             	mov    %rsp,%rbp
  80055b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80055f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800563:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800566:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80056a:	7e 52                	jle    8005be <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	83 f8 30             	cmp    $0x30,%eax
  800575:	73 24                	jae    80059b <getuint+0x44>
  800577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800583:	8b 00                	mov    (%rax),%eax
  800585:	89 c0                	mov    %eax,%eax
  800587:	48 01 d0             	add    %rdx,%rax
  80058a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058e:	8b 12                	mov    (%rdx),%edx
  800590:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800593:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800597:	89 0a                	mov    %ecx,(%rdx)
  800599:	eb 17                	jmp    8005b2 <getuint+0x5b>
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a3:	48 89 d0             	mov    %rdx,%rax
  8005a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b2:	48 8b 00             	mov    (%rax),%rax
  8005b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b9:	e9 a3 00 00 00       	jmpq   800661 <getuint+0x10a>
	else if (lflag)
  8005be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c2:	74 4f                	je     800613 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	8b 00                	mov    (%rax),%eax
  8005ca:	83 f8 30             	cmp    $0x30,%eax
  8005cd:	73 24                	jae    8005f3 <getuint+0x9c>
  8005cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	89 c0                	mov    %eax,%eax
  8005df:	48 01 d0             	add    %rdx,%rax
  8005e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e6:	8b 12                	mov    (%rdx),%edx
  8005e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ef:	89 0a                	mov    %ecx,(%rdx)
  8005f1:	eb 17                	jmp    80060a <getuint+0xb3>
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fb:	48 89 d0             	mov    %rdx,%rax
  8005fe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800602:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800606:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060a:	48 8b 00             	mov    (%rax),%rax
  80060d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800611:	eb 4e                	jmp    800661 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	8b 00                	mov    (%rax),%eax
  800619:	83 f8 30             	cmp    $0x30,%eax
  80061c:	73 24                	jae    800642 <getuint+0xeb>
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800626:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062a:	8b 00                	mov    (%rax),%eax
  80062c:	89 c0                	mov    %eax,%eax
  80062e:	48 01 d0             	add    %rdx,%rax
  800631:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800635:	8b 12                	mov    (%rdx),%edx
  800637:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063e:	89 0a                	mov    %ecx,(%rdx)
  800640:	eb 17                	jmp    800659 <getuint+0x102>
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064a:	48 89 d0             	mov    %rdx,%rax
  80064d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800651:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800655:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	89 c0                	mov    %eax,%eax
  80065d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800661:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800665:	c9                   	leaveq 
  800666:	c3                   	retq   

0000000000800667 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800667:	55                   	push   %rbp
  800668:	48 89 e5             	mov    %rsp,%rbp
  80066b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80066f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800673:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800676:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80067a:	7e 52                	jle    8006ce <getint+0x67>
		x=va_arg(*ap, long long);
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	8b 00                	mov    (%rax),%eax
  800682:	83 f8 30             	cmp    $0x30,%eax
  800685:	73 24                	jae    8006ab <getint+0x44>
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	8b 00                	mov    (%rax),%eax
  800695:	89 c0                	mov    %eax,%eax
  800697:	48 01 d0             	add    %rdx,%rax
  80069a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069e:	8b 12                	mov    (%rdx),%edx
  8006a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a7:	89 0a                	mov    %ecx,(%rdx)
  8006a9:	eb 17                	jmp    8006c2 <getint+0x5b>
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b3:	48 89 d0             	mov    %rdx,%rax
  8006b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c2:	48 8b 00             	mov    (%rax),%rax
  8006c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006c9:	e9 a3 00 00 00       	jmpq   800771 <getint+0x10a>
	else if (lflag)
  8006ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d2:	74 4f                	je     800723 <getint+0xbc>
		x=va_arg(*ap, long);
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	8b 00                	mov    (%rax),%eax
  8006da:	83 f8 30             	cmp    $0x30,%eax
  8006dd:	73 24                	jae    800703 <getint+0x9c>
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	8b 00                	mov    (%rax),%eax
  8006ed:	89 c0                	mov    %eax,%eax
  8006ef:	48 01 d0             	add    %rdx,%rax
  8006f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f6:	8b 12                	mov    (%rdx),%edx
  8006f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	89 0a                	mov    %ecx,(%rdx)
  800701:	eb 17                	jmp    80071a <getint+0xb3>
  800703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800707:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070b:	48 89 d0             	mov    %rdx,%rax
  80070e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071a:	48 8b 00             	mov    (%rax),%rax
  80071d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800721:	eb 4e                	jmp    800771 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800727:	8b 00                	mov    (%rax),%eax
  800729:	83 f8 30             	cmp    $0x30,%eax
  80072c:	73 24                	jae    800752 <getint+0xeb>
  80072e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800732:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	8b 00                	mov    (%rax),%eax
  80073c:	89 c0                	mov    %eax,%eax
  80073e:	48 01 d0             	add    %rdx,%rax
  800741:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800745:	8b 12                	mov    (%rdx),%edx
  800747:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074e:	89 0a                	mov    %ecx,(%rdx)
  800750:	eb 17                	jmp    800769 <getint+0x102>
  800752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800756:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075a:	48 89 d0             	mov    %rdx,%rax
  80075d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800761:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800765:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800769:	8b 00                	mov    (%rax),%eax
  80076b:	48 98                	cltq   
  80076d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800771:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800775:	c9                   	leaveq 
  800776:	c3                   	retq   

0000000000800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %rbp
  800778:	48 89 e5             	mov    %rsp,%rbp
  80077b:	41 54                	push   %r12
  80077d:	53                   	push   %rbx
  80077e:	48 83 ec 60          	sub    $0x60,%rsp
  800782:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800786:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80078a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80078e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800792:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800796:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80079a:	48 8b 0a             	mov    (%rdx),%rcx
  80079d:	48 89 08             	mov    %rcx,(%rax)
  8007a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b0:	eb 17                	jmp    8007c9 <vprintfmt+0x52>
			if (ch == '\0')
  8007b2:	85 db                	test   %ebx,%ebx
  8007b4:	0f 84 df 04 00 00    	je     800c99 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8007ba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c2:	48 89 d6             	mov    %rdx,%rsi
  8007c5:	89 df                	mov    %ebx,%edi
  8007c7:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007d5:	0f b6 00             	movzbl (%rax),%eax
  8007d8:	0f b6 d8             	movzbl %al,%ebx
  8007db:	83 fb 25             	cmp    $0x25,%ebx
  8007de:	75 d2                	jne    8007b2 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007e4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007eb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007f9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800800:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800804:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800808:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80080c:	0f b6 00             	movzbl (%rax),%eax
  80080f:	0f b6 d8             	movzbl %al,%ebx
  800812:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800815:	83 f8 55             	cmp    $0x55,%eax
  800818:	0f 87 47 04 00 00    	ja     800c65 <vprintfmt+0x4ee>
  80081e:	89 c0                	mov    %eax,%eax
  800820:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800827:	00 
  800828:	48 b8 18 27 80 00 00 	movabs $0x802718,%rax
  80082f:	00 00 00 
  800832:	48 01 d0             	add    %rdx,%rax
  800835:	48 8b 00             	mov    (%rax),%rax
  800838:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80083e:	eb c0                	jmp    800800 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800844:	eb ba                	jmp    800800 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800861:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800865:	0f b6 00             	movzbl (%rax),%eax
  800868:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80086b:	83 fb 2f             	cmp    $0x2f,%ebx
  80086e:	7e 0c                	jle    80087c <vprintfmt+0x105>
  800870:	83 fb 39             	cmp    $0x39,%ebx
  800873:	7f 07                	jg     80087c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800875:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80087a:	eb d1                	jmp    80084d <vprintfmt+0xd6>
			goto process_precision;
  80087c:	eb 58                	jmp    8008d6 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80087e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800881:	83 f8 30             	cmp    $0x30,%eax
  800884:	73 17                	jae    80089d <vprintfmt+0x126>
  800886:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80088a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088d:	89 c0                	mov    %eax,%eax
  80088f:	48 01 d0             	add    %rdx,%rax
  800892:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800895:	83 c2 08             	add    $0x8,%edx
  800898:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80089b:	eb 0f                	jmp    8008ac <vprintfmt+0x135>
  80089d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a1:	48 89 d0             	mov    %rdx,%rax
  8008a4:	48 83 c2 08          	add    $0x8,%rdx
  8008a8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ac:	8b 00                	mov    (%rax),%eax
  8008ae:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008b1:	eb 23                	jmp    8008d6 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008b7:	79 0c                	jns    8008c5 <vprintfmt+0x14e>
				width = 0;
  8008b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008c0:	e9 3b ff ff ff       	jmpq   800800 <vprintfmt+0x89>
  8008c5:	e9 36 ff ff ff       	jmpq   800800 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008d1:	e9 2a ff ff ff       	jmpq   800800 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008da:	79 12                	jns    8008ee <vprintfmt+0x177>
				width = precision, precision = -1;
  8008dc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008df:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008e9:	e9 12 ff ff ff       	jmpq   800800 <vprintfmt+0x89>
  8008ee:	e9 0d ff ff ff       	jmpq   800800 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008f7:	e9 04 ff ff ff       	jmpq   800800 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ff:	83 f8 30             	cmp    $0x30,%eax
  800902:	73 17                	jae    80091b <vprintfmt+0x1a4>
  800904:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800908:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090b:	89 c0                	mov    %eax,%eax
  80090d:	48 01 d0             	add    %rdx,%rax
  800910:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800913:	83 c2 08             	add    $0x8,%edx
  800916:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x1b3>
  80091b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091f:	48 89 d0             	mov    %rdx,%rax
  800922:	48 83 c2 08          	add    $0x8,%rdx
  800926:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80092a:	8b 10                	mov    (%rax),%edx
  80092c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800930:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800934:	48 89 ce             	mov    %rcx,%rsi
  800937:	89 d7                	mov    %edx,%edi
  800939:	ff d0                	callq  *%rax
			break;
  80093b:	e9 53 03 00 00       	jmpq   800c93 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800940:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800943:	83 f8 30             	cmp    $0x30,%eax
  800946:	73 17                	jae    80095f <vprintfmt+0x1e8>
  800948:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80094c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094f:	89 c0                	mov    %eax,%eax
  800951:	48 01 d0             	add    %rdx,%rax
  800954:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800957:	83 c2 08             	add    $0x8,%edx
  80095a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80095d:	eb 0f                	jmp    80096e <vprintfmt+0x1f7>
  80095f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800963:	48 89 d0             	mov    %rdx,%rax
  800966:	48 83 c2 08          	add    $0x8,%rdx
  80096a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80096e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800970:	85 db                	test   %ebx,%ebx
  800972:	79 02                	jns    800976 <vprintfmt+0x1ff>
				err = -err;
  800974:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800976:	83 fb 15             	cmp    $0x15,%ebx
  800979:	7f 16                	jg     800991 <vprintfmt+0x21a>
  80097b:	48 b8 40 26 80 00 00 	movabs $0x802640,%rax
  800982:	00 00 00 
  800985:	48 63 d3             	movslq %ebx,%rdx
  800988:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80098c:	4d 85 e4             	test   %r12,%r12
  80098f:	75 2e                	jne    8009bf <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800991:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800995:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800999:	89 d9                	mov    %ebx,%ecx
  80099b:	48 ba 01 27 80 00 00 	movabs $0x802701,%rdx
  8009a2:	00 00 00 
  8009a5:	48 89 c7             	mov    %rax,%rdi
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	49 b8 a2 0c 80 00 00 	movabs $0x800ca2,%r8
  8009b4:	00 00 00 
  8009b7:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ba:	e9 d4 02 00 00       	jmpq   800c93 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009bf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c7:	4c 89 e1             	mov    %r12,%rcx
  8009ca:	48 ba 0a 27 80 00 00 	movabs $0x80270a,%rdx
  8009d1:	00 00 00 
  8009d4:	48 89 c7             	mov    %rax,%rdi
  8009d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dc:	49 b8 a2 0c 80 00 00 	movabs $0x800ca2,%r8
  8009e3:	00 00 00 
  8009e6:	41 ff d0             	callq  *%r8
			break;
  8009e9:	e9 a5 02 00 00       	jmpq   800c93 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f1:	83 f8 30             	cmp    $0x30,%eax
  8009f4:	73 17                	jae    800a0d <vprintfmt+0x296>
  8009f6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fd:	89 c0                	mov    %eax,%eax
  8009ff:	48 01 d0             	add    %rdx,%rax
  800a02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a05:	83 c2 08             	add    $0x8,%edx
  800a08:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0b:	eb 0f                	jmp    800a1c <vprintfmt+0x2a5>
  800a0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a11:	48 89 d0             	mov    %rdx,%rax
  800a14:	48 83 c2 08          	add    $0x8,%rdx
  800a18:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1c:	4c 8b 20             	mov    (%rax),%r12
  800a1f:	4d 85 e4             	test   %r12,%r12
  800a22:	75 0a                	jne    800a2e <vprintfmt+0x2b7>
				p = "(null)";
  800a24:	49 bc 0d 27 80 00 00 	movabs $0x80270d,%r12
  800a2b:	00 00 00 
			if (width > 0 && padc != '-')
  800a2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a32:	7e 3f                	jle    800a73 <vprintfmt+0x2fc>
  800a34:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a38:	74 39                	je     800a73 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a3d:	48 98                	cltq   
  800a3f:	48 89 c6             	mov    %rax,%rsi
  800a42:	4c 89 e7             	mov    %r12,%rdi
  800a45:	48 b8 4e 0f 80 00 00 	movabs $0x800f4e,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a54:	eb 17                	jmp    800a6d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a56:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a5a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a62:	48 89 ce             	mov    %rcx,%rsi
  800a65:	89 d7                	mov    %edx,%edi
  800a67:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a69:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a71:	7f e3                	jg     800a56 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	eb 37                	jmp    800aac <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a75:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a79:	74 1e                	je     800a99 <vprintfmt+0x322>
  800a7b:	83 fb 1f             	cmp    $0x1f,%ebx
  800a7e:	7e 05                	jle    800a85 <vprintfmt+0x30e>
  800a80:	83 fb 7e             	cmp    $0x7e,%ebx
  800a83:	7e 14                	jle    800a99 <vprintfmt+0x322>
					putch('?', putdat);
  800a85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8d:	48 89 d6             	mov    %rdx,%rsi
  800a90:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a95:	ff d0                	callq  *%rax
  800a97:	eb 0f                	jmp    800aa8 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa1:	48 89 d6             	mov    %rdx,%rsi
  800aa4:	89 df                	mov    %ebx,%edi
  800aa6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aac:	4c 89 e0             	mov    %r12,%rax
  800aaf:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ab3:	0f b6 00             	movzbl (%rax),%eax
  800ab6:	0f be d8             	movsbl %al,%ebx
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	74 10                	je     800acd <vprintfmt+0x356>
  800abd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ac1:	78 b2                	js     800a75 <vprintfmt+0x2fe>
  800ac3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ac7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800acb:	79 a8                	jns    800a75 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acd:	eb 16                	jmp    800ae5 <vprintfmt+0x36e>
				putch(' ', putdat);
  800acf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad7:	48 89 d6             	mov    %rdx,%rsi
  800ada:	bf 20 00 00 00       	mov    $0x20,%edi
  800adf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ae5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ae9:	7f e4                	jg     800acf <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800aeb:	e9 a3 01 00 00       	jmpq   800c93 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800af0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800af4:	be 03 00 00 00       	mov    $0x3,%esi
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b10:	48 85 c0             	test   %rax,%rax
  800b13:	79 1d                	jns    800b32 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1d:	48 89 d6             	mov    %rdx,%rsi
  800b20:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b25:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2b:	48 f7 d8             	neg    %rax
  800b2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b39:	e9 e8 00 00 00       	jmpq   800c26 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b42:	be 03 00 00 00       	mov    $0x3,%esi
  800b47:	48 89 c7             	mov    %rax,%rdi
  800b4a:	48 b8 57 05 80 00 00 	movabs $0x800557,%rax
  800b51:	00 00 00 
  800b54:	ff d0                	callq  *%rax
  800b56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b5a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b61:	e9 c0 00 00 00       	jmpq   800c26 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6e:	48 89 d6             	mov    %rdx,%rsi
  800b71:	bf 58 00 00 00       	mov    $0x58,%edi
  800b76:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b80:	48 89 d6             	mov    %rdx,%rsi
  800b83:	bf 58 00 00 00       	mov    $0x58,%edi
  800b88:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b92:	48 89 d6             	mov    %rdx,%rsi
  800b95:	bf 58 00 00 00       	mov    $0x58,%edi
  800b9a:	ff d0                	callq  *%rax
			break;
  800b9c:	e9 f2 00 00 00       	jmpq   800c93 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ba1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba9:	48 89 d6             	mov    %rdx,%rsi
  800bac:	bf 30 00 00 00       	mov    $0x30,%edi
  800bb1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800bb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbb:	48 89 d6             	mov    %rdx,%rsi
  800bbe:	bf 78 00 00 00       	mov    $0x78,%edi
  800bc3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc8:	83 f8 30             	cmp    $0x30,%eax
  800bcb:	73 17                	jae    800be4 <vprintfmt+0x46d>
  800bcd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd4:	89 c0                	mov    %eax,%eax
  800bd6:	48 01 d0             	add    %rdx,%rax
  800bd9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bdc:	83 c2 08             	add    $0x8,%edx
  800bdf:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be2:	eb 0f                	jmp    800bf3 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800be4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be8:	48 89 d0             	mov    %rdx,%rax
  800beb:	48 83 c2 08          	add    $0x8,%rdx
  800bef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bfa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c01:	eb 23                	jmp    800c26 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c07:	be 03 00 00 00       	mov    $0x3,%esi
  800c0c:	48 89 c7             	mov    %rax,%rdi
  800c0f:	48 b8 57 05 80 00 00 	movabs $0x800557,%rax
  800c16:	00 00 00 
  800c19:	ff d0                	callq  *%rax
  800c1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c1f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c26:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c2b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c2e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c35:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3d:	45 89 c1             	mov    %r8d,%r9d
  800c40:	41 89 f8             	mov    %edi,%r8d
  800c43:	48 89 c7             	mov    %rax,%rdi
  800c46:	48 b8 9c 04 80 00 00 	movabs $0x80049c,%rax
  800c4d:	00 00 00 
  800c50:	ff d0                	callq  *%rax
			break;
  800c52:	eb 3f                	jmp    800c93 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	89 df                	mov    %ebx,%edi
  800c61:	ff d0                	callq  *%rax
			break;
  800c63:	eb 2e                	jmp    800c93 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c65:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6d:	48 89 d6             	mov    %rdx,%rsi
  800c70:	bf 25 00 00 00       	mov    $0x25,%edi
  800c75:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c77:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c7c:	eb 05                	jmp    800c83 <vprintfmt+0x50c>
  800c7e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c83:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c87:	48 83 e8 01          	sub    $0x1,%rax
  800c8b:	0f b6 00             	movzbl (%rax),%eax
  800c8e:	3c 25                	cmp    $0x25,%al
  800c90:	75 ec                	jne    800c7e <vprintfmt+0x507>
				/* do nothing */;
			break;
  800c92:	90                   	nop
		}
	}
  800c93:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c94:	e9 30 fb ff ff       	jmpq   8007c9 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c99:	48 83 c4 60          	add    $0x60,%rsp
  800c9d:	5b                   	pop    %rbx
  800c9e:	41 5c                	pop    %r12
  800ca0:	5d                   	pop    %rbp
  800ca1:	c3                   	retq   

0000000000800ca2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ca2:	55                   	push   %rbp
  800ca3:	48 89 e5             	mov    %rsp,%rbp
  800ca6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800cad:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cb4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cbb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cc2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cc9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cd0:	84 c0                	test   %al,%al
  800cd2:	74 20                	je     800cf4 <printfmt+0x52>
  800cd4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cd8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cdc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ce0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ce4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ce8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cf0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cf4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cfb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d02:	00 00 00 
  800d05:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d0c:	00 00 00 
  800d0f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d13:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d1a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d21:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d28:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d2f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d36:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d3d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d44:	48 89 c7             	mov    %rax,%rdi
  800d47:	48 b8 77 07 80 00 00 	movabs $0x800777,%rax
  800d4e:	00 00 00 
  800d51:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d53:	c9                   	leaveq 
  800d54:	c3                   	retq   

0000000000800d55 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d55:	55                   	push   %rbp
  800d56:	48 89 e5             	mov    %rsp,%rbp
  800d59:	48 83 ec 10          	sub    $0x10,%rsp
  800d5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d68:	8b 40 10             	mov    0x10(%rax),%eax
  800d6b:	8d 50 01             	lea    0x1(%rax),%edx
  800d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d72:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d79:	48 8b 10             	mov    (%rax),%rdx
  800d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d80:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d84:	48 39 c2             	cmp    %rax,%rdx
  800d87:	73 17                	jae    800da0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8d:	48 8b 00             	mov    (%rax),%rax
  800d90:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d98:	48 89 0a             	mov    %rcx,(%rdx)
  800d9b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d9e:	88 10                	mov    %dl,(%rax)
}
  800da0:	c9                   	leaveq 
  800da1:	c3                   	retq   

0000000000800da2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da2:	55                   	push   %rbp
  800da3:	48 89 e5             	mov    %rsp,%rbp
  800da6:	48 83 ec 50          	sub    $0x50,%rsp
  800daa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800dae:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800db1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800db5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800db9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800dbd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800dc1:	48 8b 0a             	mov    (%rdx),%rcx
  800dc4:	48 89 08             	mov    %rcx,(%rax)
  800dc7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dcb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dcf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dd3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ddb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ddf:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800de2:	48 98                	cltq   
  800de4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800de8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dec:	48 01 d0             	add    %rdx,%rax
  800def:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800df3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dfa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dff:	74 06                	je     800e07 <vsnprintf+0x65>
  800e01:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e05:	7f 07                	jg     800e0e <vsnprintf+0x6c>
		return -E_INVAL;
  800e07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e0c:	eb 2f                	jmp    800e3d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e0e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e12:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e16:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e1a:	48 89 c6             	mov    %rax,%rsi
  800e1d:	48 bf 55 0d 80 00 00 	movabs $0x800d55,%rdi
  800e24:	00 00 00 
  800e27:	48 b8 77 07 80 00 00 	movabs $0x800777,%rax
  800e2e:	00 00 00 
  800e31:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e37:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e3a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e3d:	c9                   	leaveq 
  800e3e:	c3                   	retq   

0000000000800e3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3f:	55                   	push   %rbp
  800e40:	48 89 e5             	mov    %rsp,%rbp
  800e43:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e4a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e51:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e57:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e5e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e65:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e6c:	84 c0                	test   %al,%al
  800e6e:	74 20                	je     800e90 <snprintf+0x51>
  800e70:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e74:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e78:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e7c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e80:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e84:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e88:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e8c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e90:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e97:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e9e:	00 00 00 
  800ea1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ea8:	00 00 00 
  800eab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800eaf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800eb6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ebd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ec4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ecb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ed2:	48 8b 0a             	mov    (%rdx),%rcx
  800ed5:	48 89 08             	mov    %rcx,(%rax)
  800ed8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800edc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ee8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800eef:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ef6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800efc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f03:	48 89 c7             	mov    %rax,%rdi
  800f06:	48 b8 a2 0d 80 00 00 	movabs $0x800da2,%rax
  800f0d:	00 00 00 
  800f10:	ff d0                	callq  *%rax
  800f12:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f18:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 18          	sub    $0x18,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f33:	eb 09                	jmp    800f3e <strlen+0x1e>
		n++;
  800f35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f39:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	0f b6 00             	movzbl (%rax),%eax
  800f45:	84 c0                	test   %al,%al
  800f47:	75 ec                	jne    800f35 <strlen+0x15>
		n++;
	return n;
  800f49:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f4c:	c9                   	leaveq 
  800f4d:	c3                   	retq   

0000000000800f4e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f4e:	55                   	push   %rbp
  800f4f:	48 89 e5             	mov    %rsp,%rbp
  800f52:	48 83 ec 20          	sub    $0x20,%rsp
  800f56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f65:	eb 0e                	jmp    800f75 <strnlen+0x27>
		n++;
  800f67:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f6b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f70:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f75:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f7a:	74 0b                	je     800f87 <strnlen+0x39>
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	0f b6 00             	movzbl (%rax),%eax
  800f83:	84 c0                	test   %al,%al
  800f85:	75 e0                	jne    800f67 <strnlen+0x19>
		n++;
	return n;
  800f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f8a:	c9                   	leaveq 
  800f8b:	c3                   	retq   

0000000000800f8c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f8c:	55                   	push   %rbp
  800f8d:	48 89 e5             	mov    %rsp,%rbp
  800f90:	48 83 ec 20          	sub    $0x20,%rsp
  800f94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fa4:	90                   	nop
  800fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fbd:	0f b6 12             	movzbl (%rdx),%edx
  800fc0:	88 10                	mov    %dl,(%rax)
  800fc2:	0f b6 00             	movzbl (%rax),%eax
  800fc5:	84 c0                	test   %al,%al
  800fc7:	75 dc                	jne    800fa5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 83 ec 20          	sub    $0x20,%rsp
  800fd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe3:	48 89 c7             	mov    %rax,%rdi
  800fe6:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  800fed:	00 00 00 
  800ff0:	ff d0                	callq  *%rax
  800ff2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff8:	48 63 d0             	movslq %eax,%rdx
  800ffb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fff:	48 01 c2             	add    %rax,%rdx
  801002:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801006:	48 89 c6             	mov    %rax,%rsi
  801009:	48 89 d7             	mov    %rdx,%rdi
  80100c:	48 b8 8c 0f 80 00 00 	movabs $0x800f8c,%rax
  801013:	00 00 00 
  801016:	ff d0                	callq  *%rax
	return dst;
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80101c:	c9                   	leaveq 
  80101d:	c3                   	retq   

000000000080101e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80101e:	55                   	push   %rbp
  80101f:	48 89 e5             	mov    %rsp,%rbp
  801022:	48 83 ec 28          	sub    $0x28,%rsp
  801026:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80102e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80103a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801041:	00 
  801042:	eb 2a                	jmp    80106e <strncpy+0x50>
		*dst++ = *src;
  801044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801048:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80104c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801050:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801054:	0f b6 12             	movzbl (%rdx),%edx
  801057:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801059:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80105d:	0f b6 00             	movzbl (%rax),%eax
  801060:	84 c0                	test   %al,%al
  801062:	74 05                	je     801069 <strncpy+0x4b>
			src++;
  801064:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801069:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80106e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801072:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801076:	72 cc                	jb     801044 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801078:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80107c:	c9                   	leaveq 
  80107d:	c3                   	retq   

000000000080107e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80107e:	55                   	push   %rbp
  80107f:	48 89 e5             	mov    %rsp,%rbp
  801082:	48 83 ec 28          	sub    $0x28,%rsp
  801086:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80108e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801096:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80109a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80109f:	74 3d                	je     8010de <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8010a1:	eb 1d                	jmp    8010c0 <strlcpy+0x42>
			*dst++ = *src++;
  8010a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010b3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010b7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010bb:	0f b6 12             	movzbl (%rdx),%edx
  8010be:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010ca:	74 0b                	je     8010d7 <strlcpy+0x59>
  8010cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d0:	0f b6 00             	movzbl (%rax),%eax
  8010d3:	84 c0                	test   %al,%al
  8010d5:	75 cc                	jne    8010a3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e6:	48 29 c2             	sub    %rax,%rdx
  8010e9:	48 89 d0             	mov    %rdx,%rax
}
  8010ec:	c9                   	leaveq 
  8010ed:	c3                   	retq   

00000000008010ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010ee:	55                   	push   %rbp
  8010ef:	48 89 e5             	mov    %rsp,%rbp
  8010f2:	48 83 ec 10          	sub    $0x10,%rsp
  8010f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010fe:	eb 0a                	jmp    80110a <strcmp+0x1c>
		p++, q++;
  801100:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801105:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80110a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110e:	0f b6 00             	movzbl (%rax),%eax
  801111:	84 c0                	test   %al,%al
  801113:	74 12                	je     801127 <strcmp+0x39>
  801115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801119:	0f b6 10             	movzbl (%rax),%edx
  80111c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801120:	0f b6 00             	movzbl (%rax),%eax
  801123:	38 c2                	cmp    %al,%dl
  801125:	74 d9                	je     801100 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801127:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112b:	0f b6 00             	movzbl (%rax),%eax
  80112e:	0f b6 d0             	movzbl %al,%edx
  801131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801135:	0f b6 00             	movzbl (%rax),%eax
  801138:	0f b6 c0             	movzbl %al,%eax
  80113b:	29 c2                	sub    %eax,%edx
  80113d:	89 d0                	mov    %edx,%eax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 18          	sub    $0x18,%rsp
  801149:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801151:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801155:	eb 0f                	jmp    801166 <strncmp+0x25>
		n--, p++, q++;
  801157:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80115c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801161:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801166:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80116b:	74 1d                	je     80118a <strncmp+0x49>
  80116d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801171:	0f b6 00             	movzbl (%rax),%eax
  801174:	84 c0                	test   %al,%al
  801176:	74 12                	je     80118a <strncmp+0x49>
  801178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117c:	0f b6 10             	movzbl (%rax),%edx
  80117f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801183:	0f b6 00             	movzbl (%rax),%eax
  801186:	38 c2                	cmp    %al,%dl
  801188:	74 cd                	je     801157 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80118a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80118f:	75 07                	jne    801198 <strncmp+0x57>
		return 0;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
  801196:	eb 18                	jmp    8011b0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801198:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119c:	0f b6 00             	movzbl (%rax),%eax
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	0f b6 c0             	movzbl %al,%eax
  8011ac:	29 c2                	sub    %eax,%edx
  8011ae:	89 d0                	mov    %edx,%eax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011be:	89 f0                	mov    %esi,%eax
  8011c0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011c3:	eb 17                	jmp    8011dc <strchr+0x2a>
		if (*s == c)
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011cf:	75 06                	jne    8011d7 <strchr+0x25>
			return (char *) s;
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	eb 15                	jmp    8011ec <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	0f b6 00             	movzbl (%rax),%eax
  8011e3:	84 c0                	test   %al,%al
  8011e5:	75 de                	jne    8011c5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 0c          	sub    $0xc,%rsp
  8011f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011fa:	89 f0                	mov    %esi,%eax
  8011fc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011ff:	eb 13                	jmp    801214 <strfind+0x26>
		if (*s == c)
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	0f b6 00             	movzbl (%rax),%eax
  801208:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80120b:	75 02                	jne    80120f <strfind+0x21>
			break;
  80120d:	eb 10                	jmp    80121f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80120f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801218:	0f b6 00             	movzbl (%rax),%eax
  80121b:	84 c0                	test   %al,%al
  80121d:	75 e2                	jne    801201 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80121f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801223:	c9                   	leaveq 
  801224:	c3                   	retq   

0000000000801225 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801225:	55                   	push   %rbp
  801226:	48 89 e5             	mov    %rsp,%rbp
  801229:	48 83 ec 18          	sub    $0x18,%rsp
  80122d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801231:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801238:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123d:	75 06                	jne    801245 <memset+0x20>
		return v;
  80123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801243:	eb 69                	jmp    8012ae <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801249:	83 e0 03             	and    $0x3,%eax
  80124c:	48 85 c0             	test   %rax,%rax
  80124f:	75 48                	jne    801299 <memset+0x74>
  801251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801255:	83 e0 03             	and    $0x3,%eax
  801258:	48 85 c0             	test   %rax,%rax
  80125b:	75 3c                	jne    801299 <memset+0x74>
		c &= 0xFF;
  80125d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801264:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801267:	c1 e0 18             	shl    $0x18,%eax
  80126a:	89 c2                	mov    %eax,%edx
  80126c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126f:	c1 e0 10             	shl    $0x10,%eax
  801272:	09 c2                	or     %eax,%edx
  801274:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801277:	c1 e0 08             	shl    $0x8,%eax
  80127a:	09 d0                	or     %edx,%eax
  80127c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 c1 e8 02          	shr    $0x2,%rax
  801287:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80128a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801291:	48 89 d7             	mov    %rdx,%rdi
  801294:	fc                   	cld    
  801295:	f3 ab                	rep stos %eax,%es:(%rdi)
  801297:	eb 11                	jmp    8012aa <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801299:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012a0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012a4:	48 89 d7             	mov    %rdx,%rdi
  8012a7:	fc                   	cld    
  8012a8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 28          	sub    $0x28,%rsp
  8012b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012dc:	0f 83 88 00 00 00    	jae    80136a <memmove+0xba>
  8012e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ea:	48 01 d0             	add    %rdx,%rax
  8012ed:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012f1:	76 77                	jbe    80136a <memmove+0xba>
		s += n;
  8012f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ff:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801307:	83 e0 03             	and    $0x3,%eax
  80130a:	48 85 c0             	test   %rax,%rax
  80130d:	75 3b                	jne    80134a <memmove+0x9a>
  80130f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801313:	83 e0 03             	and    $0x3,%eax
  801316:	48 85 c0             	test   %rax,%rax
  801319:	75 2f                	jne    80134a <memmove+0x9a>
  80131b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 23                	jne    80134a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132b:	48 83 e8 04          	sub    $0x4,%rax
  80132f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801333:	48 83 ea 04          	sub    $0x4,%rdx
  801337:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80133b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80133f:	48 89 c7             	mov    %rax,%rdi
  801342:	48 89 d6             	mov    %rdx,%rsi
  801345:	fd                   	std    
  801346:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801348:	eb 1d                	jmp    801367 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80134a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80135a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135e:	48 89 d7             	mov    %rdx,%rdi
  801361:	48 89 c1             	mov    %rax,%rcx
  801364:	fd                   	std    
  801365:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801367:	fc                   	cld    
  801368:	eb 57                	jmp    8013c1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	83 e0 03             	and    $0x3,%eax
  801371:	48 85 c0             	test   %rax,%rax
  801374:	75 36                	jne    8013ac <memmove+0xfc>
  801376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137a:	83 e0 03             	and    $0x3,%eax
  80137d:	48 85 c0             	test   %rax,%rax
  801380:	75 2a                	jne    8013ac <memmove+0xfc>
  801382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801386:	83 e0 03             	and    $0x3,%eax
  801389:	48 85 c0             	test   %rax,%rax
  80138c:	75 1e                	jne    8013ac <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	48 c1 e8 02          	shr    $0x2,%rax
  801396:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a1:	48 89 c7             	mov    %rax,%rdi
  8013a4:	48 89 d6             	mov    %rdx,%rsi
  8013a7:	fc                   	cld    
  8013a8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013aa:	eb 15                	jmp    8013c1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013b8:	48 89 c7             	mov    %rax,%rdi
  8013bb:	48 89 d6             	mov    %rdx,%rsi
  8013be:	fc                   	cld    
  8013bf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013c5:	c9                   	leaveq 
  8013c6:	c3                   	retq   

00000000008013c7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013c7:	55                   	push   %rbp
  8013c8:	48 89 e5             	mov    %rsp,%rbp
  8013cb:	48 83 ec 18          	sub    $0x18,%rsp
  8013cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013df:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	48 89 ce             	mov    %rcx,%rsi
  8013ea:	48 89 c7             	mov    %rax,%rdi
  8013ed:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  8013f4:	00 00 00 
  8013f7:	ff d0                	callq  *%rax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 28          	sub    $0x28,%rsp
  801403:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801407:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801413:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801417:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80141f:	eb 36                	jmp    801457 <memcmp+0x5c>
		if (*s1 != *s2)
  801421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801425:	0f b6 10             	movzbl (%rax),%edx
  801428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	38 c2                	cmp    %al,%dl
  801431:	74 1a                	je     80144d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	0f b6 d0             	movzbl %al,%edx
  80143d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	0f b6 c0             	movzbl %al,%eax
  801447:	29 c2                	sub    %eax,%edx
  801449:	89 d0                	mov    %edx,%eax
  80144b:	eb 20                	jmp    80146d <memcmp+0x72>
		s1++, s2++;
  80144d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801452:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801457:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80145f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 b9                	jne    801421 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 28          	sub    $0x28,%rsp
  801477:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80147e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801482:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801486:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80148a:	48 01 d0             	add    %rdx,%rax
  80148d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801491:	eb 15                	jmp    8014a8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801497:	0f b6 10             	movzbl (%rax),%edx
  80149a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80149d:	38 c2                	cmp    %al,%dl
  80149f:	75 02                	jne    8014a3 <memfind+0x34>
			break;
  8014a1:	eb 0f                	jmp    8014b2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014a3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ac:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014b0:	72 e1                	jb     801493 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b6:	c9                   	leaveq 
  8014b7:	c3                   	retq   

00000000008014b8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014b8:	55                   	push   %rbp
  8014b9:	48 89 e5             	mov    %rsp,%rbp
  8014bc:	48 83 ec 34          	sub    $0x34,%rsp
  8014c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014c8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014d2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014d9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014da:	eb 05                	jmp    8014e1 <strtol+0x29>
		s++;
  8014dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	3c 20                	cmp    $0x20,%al
  8014ea:	74 f0                	je     8014dc <strtol+0x24>
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 09                	cmp    $0x9,%al
  8014f5:	74 e5                	je     8014dc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	3c 2b                	cmp    $0x2b,%al
  801500:	75 07                	jne    801509 <strtol+0x51>
		s++;
  801502:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801507:	eb 17                	jmp    801520 <strtol+0x68>
	else if (*s == '-')
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	3c 2d                	cmp    $0x2d,%al
  801512:	75 0c                	jne    801520 <strtol+0x68>
		s++, neg = 1;
  801514:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801519:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801520:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801524:	74 06                	je     80152c <strtol+0x74>
  801526:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80152a:	75 28                	jne    801554 <strtol+0x9c>
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	3c 30                	cmp    $0x30,%al
  801535:	75 1d                	jne    801554 <strtol+0x9c>
  801537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153b:	48 83 c0 01          	add    $0x1,%rax
  80153f:	0f b6 00             	movzbl (%rax),%eax
  801542:	3c 78                	cmp    $0x78,%al
  801544:	75 0e                	jne    801554 <strtol+0x9c>
		s += 2, base = 16;
  801546:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80154b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801552:	eb 2c                	jmp    801580 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801554:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801558:	75 19                	jne    801573 <strtol+0xbb>
  80155a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155e:	0f b6 00             	movzbl (%rax),%eax
  801561:	3c 30                	cmp    $0x30,%al
  801563:	75 0e                	jne    801573 <strtol+0xbb>
		s++, base = 8;
  801565:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80156a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801571:	eb 0d                	jmp    801580 <strtol+0xc8>
	else if (base == 0)
  801573:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801577:	75 07                	jne    801580 <strtol+0xc8>
		base = 10;
  801579:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	3c 2f                	cmp    $0x2f,%al
  801589:	7e 1d                	jle    8015a8 <strtol+0xf0>
  80158b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158f:	0f b6 00             	movzbl (%rax),%eax
  801592:	3c 39                	cmp    $0x39,%al
  801594:	7f 12                	jg     8015a8 <strtol+0xf0>
			dig = *s - '0';
  801596:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	0f be c0             	movsbl %al,%eax
  8015a0:	83 e8 30             	sub    $0x30,%eax
  8015a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015a6:	eb 4e                	jmp    8015f6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	3c 60                	cmp    $0x60,%al
  8015b1:	7e 1d                	jle    8015d0 <strtol+0x118>
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	3c 7a                	cmp    $0x7a,%al
  8015bc:	7f 12                	jg     8015d0 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	0f be c0             	movsbl %al,%eax
  8015c8:	83 e8 57             	sub    $0x57,%eax
  8015cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015ce:	eb 26                	jmp    8015f6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	3c 40                	cmp    $0x40,%al
  8015d9:	7e 48                	jle    801623 <strtol+0x16b>
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	3c 5a                	cmp    $0x5a,%al
  8015e4:	7f 3d                	jg     801623 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	0f be c0             	movsbl %al,%eax
  8015f0:	83 e8 37             	sub    $0x37,%eax
  8015f3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015fc:	7c 02                	jl     801600 <strtol+0x148>
			break;
  8015fe:	eb 23                	jmp    801623 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801600:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801605:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801608:	48 98                	cltq   
  80160a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80160f:	48 89 c2             	mov    %rax,%rdx
  801612:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801615:	48 98                	cltq   
  801617:	48 01 d0             	add    %rdx,%rax
  80161a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80161e:	e9 5d ff ff ff       	jmpq   801580 <strtol+0xc8>

	if (endptr)
  801623:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801628:	74 0b                	je     801635 <strtol+0x17d>
		*endptr = (char *) s;
  80162a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80162e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801632:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801635:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801639:	74 09                	je     801644 <strtol+0x18c>
  80163b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163f:	48 f7 d8             	neg    %rax
  801642:	eb 04                	jmp    801648 <strtol+0x190>
  801644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801648:	c9                   	leaveq 
  801649:	c3                   	retq   

000000000080164a <strstr>:

char * strstr(const char *in, const char *str)
{
  80164a:	55                   	push   %rbp
  80164b:	48 89 e5             	mov    %rsp,%rbp
  80164e:	48 83 ec 30          	sub    $0x30,%rsp
  801652:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801656:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80165a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80165e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801662:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80166c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801670:	75 06                	jne    801678 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801676:	eb 6b                	jmp    8016e3 <strstr+0x99>

	len = strlen(str);
  801678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167c:	48 89 c7             	mov    %rax,%rdi
  80167f:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  801686:	00 00 00 
  801689:	ff d0                	callq  *%rax
  80168b:	48 98                	cltq   
  80168d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801699:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8016a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016a7:	75 07                	jne    8016b0 <strstr+0x66>
				return (char *) 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 33                	jmp    8016e3 <strstr+0x99>
		} while (sc != c);
  8016b0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016b4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016b7:	75 d8                	jne    801691 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016bd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	48 89 ce             	mov    %rcx,%rsi
  8016c8:	48 89 c7             	mov    %rax,%rdi
  8016cb:	48 b8 41 11 80 00 00 	movabs $0x801141,%rax
  8016d2:	00 00 00 
  8016d5:	ff d0                	callq  *%rax
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	75 b6                	jne    801691 <strstr+0x47>

	return (char *) (in - 1);
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	48 83 e8 01          	sub    $0x1,%rax
}
  8016e3:	c9                   	leaveq 
  8016e4:	c3                   	retq   

00000000008016e5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016e5:	55                   	push   %rbp
  8016e6:	48 89 e5             	mov    %rsp,%rbp
  8016e9:	53                   	push   %rbx
  8016ea:	48 83 ec 48          	sub    $0x48,%rsp
  8016ee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016f1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016f4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016f8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016fc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801700:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801704:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801707:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80170b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80170f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801713:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801717:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80171b:	4c 89 c3             	mov    %r8,%rbx
  80171e:	cd 30                	int    $0x30
  801720:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801724:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801728:	74 3e                	je     801768 <syscall+0x83>
  80172a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80172f:	7e 37                	jle    801768 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801731:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801735:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801738:	49 89 d0             	mov    %rdx,%r8
  80173b:	89 c1                	mov    %eax,%ecx
  80173d:	48 ba c8 29 80 00 00 	movabs $0x8029c8,%rdx
  801744:	00 00 00 
  801747:	be 23 00 00 00       	mov    $0x23,%esi
  80174c:	48 bf e5 29 80 00 00 	movabs $0x8029e5,%rdi
  801753:	00 00 00 
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	49 b9 c3 22 80 00 00 	movabs $0x8022c3,%r9
  801762:	00 00 00 
  801765:	41 ff d1             	callq  *%r9

	return ret;
  801768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80176c:	48 83 c4 48          	add    $0x48,%rsp
  801770:	5b                   	pop    %rbx
  801771:	5d                   	pop    %rbp
  801772:	c3                   	retq   

0000000000801773 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801773:	55                   	push   %rbp
  801774:	48 89 e5             	mov    %rsp,%rbp
  801777:	48 83 ec 20          	sub    $0x20,%rsp
  80177b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80177f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801783:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801787:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801792:	00 
  801793:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801799:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179f:	48 89 d1             	mov    %rdx,%rcx
  8017a2:	48 89 c2             	mov    %rax,%rdx
  8017a5:	be 00 00 00 00       	mov    $0x0,%esi
  8017aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8017af:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8017b6:	00 00 00 
  8017b9:	ff d0                	callq  *%rax
}
  8017bb:	c9                   	leaveq 
  8017bc:	c3                   	retq   

00000000008017bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8017bd:	55                   	push   %rbp
  8017be:	48 89 e5             	mov    %rsp,%rbp
  8017c1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cc:	00 
  8017cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	be 00 00 00 00       	mov    $0x0,%esi
  8017e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8017ed:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8017f4:	00 00 00 
  8017f7:	ff d0                	callq  *%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	48 83 ec 10          	sub    $0x10,%rsp
  801803:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801806:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801809:	48 98                	cltq   
  80180b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801812:	00 
  801813:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801819:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80181f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801824:	48 89 c2             	mov    %rax,%rdx
  801827:	be 01 00 00 00       	mov    $0x1,%esi
  80182c:	bf 03 00 00 00       	mov    $0x3,%edi
  801831:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801838:	00 00 00 
  80183b:	ff d0                	callq  *%rax
}
  80183d:	c9                   	leaveq 
  80183e:	c3                   	retq   

000000000080183f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80183f:	55                   	push   %rbp
  801840:	48 89 e5             	mov    %rsp,%rbp
  801843:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801847:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184e:	00 
  80184f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801855:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801860:	ba 00 00 00 00       	mov    $0x0,%edx
  801865:	be 00 00 00 00       	mov    $0x0,%esi
  80186a:	bf 02 00 00 00       	mov    $0x2,%edi
  80186f:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801876:	00 00 00 
  801879:	ff d0                	callq  *%rax
}
  80187b:	c9                   	leaveq 
  80187c:	c3                   	retq   

000000000080187d <sys_yield>:

void
sys_yield(void)
{
  80187d:	55                   	push   %rbp
  80187e:	48 89 e5             	mov    %rsp,%rbp
  801881:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801885:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188c:	00 
  80188d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801893:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801899:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189e:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a3:	be 00 00 00 00       	mov    $0x0,%esi
  8018a8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8018ad:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8018b4:	00 00 00 
  8018b7:	ff d0                	callq  *%rax
}
  8018b9:	c9                   	leaveq 
  8018ba:	c3                   	retq   

00000000008018bb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018bb:	55                   	push   %rbp
  8018bc:	48 89 e5             	mov    %rsp,%rbp
  8018bf:	48 83 ec 20          	sub    $0x20,%rsp
  8018c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018ca:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018d0:	48 63 c8             	movslq %eax,%rcx
  8018d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018da:	48 98                	cltq   
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	49 89 c8             	mov    %rcx,%r8
  8018ed:	48 89 d1             	mov    %rdx,%rcx
  8018f0:	48 89 c2             	mov    %rax,%rdx
  8018f3:	be 01 00 00 00       	mov    $0x1,%esi
  8018f8:	bf 04 00 00 00       	mov    $0x4,%edi
  8018fd:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801904:	00 00 00 
  801907:	ff d0                	callq  *%rax
}
  801909:	c9                   	leaveq 
  80190a:	c3                   	retq   

000000000080190b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80190b:	55                   	push   %rbp
  80190c:	48 89 e5             	mov    %rsp,%rbp
  80190f:	48 83 ec 30          	sub    $0x30,%rsp
  801913:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801916:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80191a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80191d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801921:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801925:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801928:	48 63 c8             	movslq %eax,%rcx
  80192b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80192f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801932:	48 63 f0             	movslq %eax,%rsi
  801935:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193c:	48 98                	cltq   
  80193e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801942:	49 89 f9             	mov    %rdi,%r9
  801945:	49 89 f0             	mov    %rsi,%r8
  801948:	48 89 d1             	mov    %rdx,%rcx
  80194b:	48 89 c2             	mov    %rax,%rdx
  80194e:	be 01 00 00 00       	mov    $0x1,%esi
  801953:	bf 05 00 00 00       	mov    $0x5,%edi
  801958:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  80195f:	00 00 00 
  801962:	ff d0                	callq  *%rax
}
  801964:	c9                   	leaveq 
  801965:	c3                   	retq   

0000000000801966 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801966:	55                   	push   %rbp
  801967:	48 89 e5             	mov    %rsp,%rbp
  80196a:	48 83 ec 20          	sub    $0x20,%rsp
  80196e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801971:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801975:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197c:	48 98                	cltq   
  80197e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801985:	00 
  801986:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801992:	48 89 d1             	mov    %rdx,%rcx
  801995:	48 89 c2             	mov    %rax,%rdx
  801998:	be 01 00 00 00       	mov    $0x1,%esi
  80199d:	bf 06 00 00 00       	mov    $0x6,%edi
  8019a2:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8019a9:	00 00 00 
  8019ac:	ff d0                	callq  *%rax
}
  8019ae:	c9                   	leaveq 
  8019af:	c3                   	retq   

00000000008019b0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
  8019b4:	48 83 ec 10          	sub    $0x10,%rsp
  8019b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c1:	48 63 d0             	movslq %eax,%rdx
  8019c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c7:	48 98                	cltq   
  8019c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d0:	00 
  8019d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019dd:	48 89 d1             	mov    %rdx,%rcx
  8019e0:	48 89 c2             	mov    %rax,%rdx
  8019e3:	be 01 00 00 00       	mov    $0x1,%esi
  8019e8:	bf 08 00 00 00       	mov    $0x8,%edi
  8019ed:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  8019f4:	00 00 00 
  8019f7:	ff d0                	callq  *%rax
}
  8019f9:	c9                   	leaveq 
  8019fa:	c3                   	retq   

00000000008019fb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019fb:	55                   	push   %rbp
  8019fc:	48 89 e5             	mov    %rsp,%rbp
  8019ff:	48 83 ec 20          	sub    $0x20,%rsp
  801a03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a11:	48 98                	cltq   
  801a13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1a:	00 
  801a1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a27:	48 89 d1             	mov    %rdx,%rcx
  801a2a:	48 89 c2             	mov    %rax,%rdx
  801a2d:	be 01 00 00 00       	mov    $0x1,%esi
  801a32:	bf 09 00 00 00       	mov    $0x9,%edi
  801a37:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 20          	sub    $0x20,%rsp
  801a4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a54:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a58:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a5e:	48 63 f0             	movslq %eax,%rsi
  801a61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a68:	48 98                	cltq   
  801a6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a75:	00 
  801a76:	49 89 f1             	mov    %rsi,%r9
  801a79:	49 89 c8             	mov    %rcx,%r8
  801a7c:	48 89 d1             	mov    %rdx,%rcx
  801a7f:	48 89 c2             	mov    %rax,%rdx
  801a82:	be 00 00 00 00       	mov    $0x0,%esi
  801a87:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a8c:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801a93:	00 00 00 
  801a96:	ff d0                	callq  *%rax
}
  801a98:	c9                   	leaveq 
  801a99:	c3                   	retq   

0000000000801a9a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a9a:	55                   	push   %rbp
  801a9b:	48 89 e5             	mov    %rsp,%rbp
  801a9e:	48 83 ec 10          	sub    $0x10,%rsp
  801aa2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801aa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aaa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab1:	00 
  801ab2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac3:	48 89 c2             	mov    %rax,%rdx
  801ac6:	be 01 00 00 00       	mov    $0x1,%esi
  801acb:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ad0:	48 b8 e5 16 80 00 00 	movabs $0x8016e5,%rax
  801ad7:	00 00 00 
  801ada:	ff d0                	callq  *%rax
}
  801adc:	c9                   	leaveq 
  801add:	c3                   	retq   

0000000000801ade <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ade:	55                   	push   %rbp
  801adf:	48 89 e5             	mov    %rsp,%rbp
  801ae2:	48 83 ec 30          	sub    $0x30,%rsp
  801ae6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801aea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aee:	48 8b 00             	mov    (%rax),%rax
  801af1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af9:	48 8b 40 08          	mov    0x8(%rax),%rax
  801afd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b00:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b03:	83 e0 02             	and    $0x2,%eax
  801b06:	85 c0                	test   %eax,%eax
  801b08:	75 4d                	jne    801b57 <pgfault+0x79>
  801b0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0e:	48 c1 e8 0c          	shr    $0xc,%rax
  801b12:	48 89 c2             	mov    %rax,%rdx
  801b15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b1c:	01 00 00 
  801b1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b23:	25 00 08 00 00       	and    $0x800,%eax
  801b28:	48 85 c0             	test   %rax,%rax
  801b2b:	74 2a                	je     801b57 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801b2d:	48 ba f8 29 80 00 00 	movabs $0x8029f8,%rdx
  801b34:	00 00 00 
  801b37:	be 1e 00 00 00       	mov    $0x1e,%esi
  801b3c:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801b43:	00 00 00 
  801b46:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4b:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801b52:	00 00 00 
  801b55:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801b57:	ba 07 00 00 00       	mov    $0x7,%edx
  801b5c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b61:	bf 00 00 00 00       	mov    $0x0,%edi
  801b66:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  801b6d:	00 00 00 
  801b70:	ff d0                	callq  *%rax
  801b72:	85 c0                	test   %eax,%eax
  801b74:	0f 85 cd 00 00 00    	jne    801c47 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801b7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b86:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b8c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801b90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b94:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b99:	48 89 c6             	mov    %rax,%rsi
  801b9c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ba1:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801bad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bb1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801bb7:	48 89 c1             	mov    %rax,%rcx
  801bba:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bc4:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc9:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	callq  *%rax
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	79 2a                	jns    801c03 <pgfault+0x125>
				panic("Page map at temp address failed");
  801bd9:	48 ba 28 2a 80 00 00 	movabs $0x802a28,%rdx
  801be0:	00 00 00 
  801be3:	be 2f 00 00 00       	mov    $0x2f,%esi
  801be8:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801bef:	00 00 00 
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf7:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801bfe:	00 00 00 
  801c01:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c03:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c08:	bf 00 00 00 00       	mov    $0x0,%edi
  801c0d:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  801c14:	00 00 00 
  801c17:	ff d0                	callq  *%rax
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	79 54                	jns    801c71 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c1d:	48 ba 48 2a 80 00 00 	movabs $0x802a48,%rdx
  801c24:	00 00 00 
  801c27:	be 31 00 00 00       	mov    $0x31,%esi
  801c2c:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801c33:	00 00 00 
  801c36:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3b:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801c42:	00 00 00 
  801c45:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801c47:	48 ba 70 2a 80 00 00 	movabs $0x802a70,%rdx
  801c4e:	00 00 00 
  801c51:	be 35 00 00 00       	mov    $0x35,%esi
  801c56:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801c5d:	00 00 00 
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
  801c65:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801c6c:	00 00 00 
  801c6f:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801c71:	c9                   	leaveq 
  801c72:	c3                   	retq   

0000000000801c73 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c73:	55                   	push   %rbp
  801c74:	48 89 e5             	mov    %rsp,%rbp
  801c77:	48 83 ec 20          	sub    $0x20,%rsp
  801c7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c7e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801c81:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c88:	01 00 00 
  801c8b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c92:	25 07 0e 00 00       	and    $0xe07,%eax
  801c97:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c9a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c9d:	48 c1 e0 0c          	shl    $0xc,%rax
  801ca1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca8:	25 00 04 00 00       	and    $0x400,%eax
  801cad:	85 c0                	test   %eax,%eax
  801caf:	74 57                	je     801d08 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cb1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cb4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cb8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cbf:	41 89 f0             	mov    %esi,%r8d
  801cc2:	48 89 c6             	mov    %rax,%rsi
  801cc5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cca:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	callq  *%rax
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	0f 8e 52 01 00 00    	jle    801e30 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801cde:	48 ba 9d 2a 80 00 00 	movabs $0x802a9d,%rdx
  801ce5:	00 00 00 
  801ce8:	be 52 00 00 00       	mov    $0x52,%esi
  801ced:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801cf4:	00 00 00 
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801d03:	00 00 00 
  801d06:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0b:	83 e0 02             	and    $0x2,%eax
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	75 10                	jne    801d22 <duppage+0xaf>
  801d12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d15:	25 00 08 00 00       	and    $0x800,%eax
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	0f 84 bb 00 00 00    	je     801ddd <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d25:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801d2a:	80 cc 08             	or     $0x8,%ah
  801d2d:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d30:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d33:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d37:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d3e:	41 89 f0             	mov    %esi,%r8d
  801d41:	48 89 c6             	mov    %rax,%rsi
  801d44:	bf 00 00 00 00       	mov    $0x0,%edi
  801d49:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801d50:	00 00 00 
  801d53:	ff d0                	callq  *%rax
  801d55:	85 c0                	test   %eax,%eax
  801d57:	7e 2a                	jle    801d83 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801d59:	48 ba 9d 2a 80 00 00 	movabs $0x802a9d,%rdx
  801d60:	00 00 00 
  801d63:	be 5a 00 00 00       	mov    $0x5a,%esi
  801d68:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801d6f:	00 00 00 
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
  801d77:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801d7e:	00 00 00 
  801d81:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d83:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8e:	41 89 c8             	mov    %ecx,%r8d
  801d91:	48 89 d1             	mov    %rdx,%rcx
  801d94:	ba 00 00 00 00       	mov    $0x0,%edx
  801d99:	48 89 c6             	mov    %rax,%rsi
  801d9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801da1:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
  801dad:	85 c0                	test   %eax,%eax
  801daf:	7e 2a                	jle    801ddb <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801db1:	48 ba 9d 2a 80 00 00 	movabs $0x802a9d,%rdx
  801db8:	00 00 00 
  801dbb:	be 5d 00 00 00       	mov    $0x5d,%esi
  801dc0:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801dc7:	00 00 00 
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcf:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801dd6:	00 00 00 
  801dd9:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ddb:	eb 53                	jmp    801e30 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ddd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801de0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801de4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801deb:	41 89 f0             	mov    %esi,%r8d
  801dee:	48 89 c6             	mov    %rax,%rsi
  801df1:	bf 00 00 00 00       	mov    $0x0,%edi
  801df6:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
  801e02:	85 c0                	test   %eax,%eax
  801e04:	7e 2a                	jle    801e30 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801e06:	48 ba 9d 2a 80 00 00 	movabs $0x802a9d,%rdx
  801e0d:	00 00 00 
  801e10:	be 61 00 00 00       	mov    $0x61,%esi
  801e15:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801e1c:	00 00 00 
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  801e2b:	00 00 00 
  801e2e:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e35:	c9                   	leaveq 
  801e36:	c3                   	retq   

0000000000801e37 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e37:	55                   	push   %rbp
  801e38:	48 89 e5             	mov    %rsp,%rbp
  801e3b:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801e3f:	48 bf de 1a 80 00 00 	movabs $0x801ade,%rdi
  801e46:	00 00 00 
  801e49:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e55:	b8 07 00 00 00       	mov    $0x7,%eax
  801e5a:	cd 30                	int    $0x30
  801e5c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e5f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801e62:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e69:	79 30                	jns    801e9b <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801e6b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e6e:	89 c1                	mov    %eax,%ecx
  801e70:	48 ba bb 2a 80 00 00 	movabs $0x802abb,%rdx
  801e77:	00 00 00 
  801e7a:	be 89 00 00 00       	mov    $0x89,%esi
  801e7f:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  801e86:	00 00 00 
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	49 b8 c3 22 80 00 00 	movabs $0x8022c3,%r8
  801e95:	00 00 00 
  801e98:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801e9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e9f:	75 46                	jne    801ee7 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801ea1:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	callq  *%rax
  801ead:	25 ff 03 00 00       	and    $0x3ff,%eax
  801eb2:	48 63 d0             	movslq %eax,%rdx
  801eb5:	48 89 d0             	mov    %rdx,%rax
  801eb8:	48 c1 e0 03          	shl    $0x3,%rax
  801ebc:	48 01 d0             	add    %rdx,%rax
  801ebf:	48 c1 e0 05          	shl    $0x5,%rax
  801ec3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801eca:	00 00 00 
  801ecd:	48 01 c2             	add    %rax,%rdx
  801ed0:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  801ed7:	00 00 00 
  801eda:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee2:	e9 d1 01 00 00       	jmpq   8020b8 <fork+0x281>
	}

	uint64_t ad = 0;
  801ee7:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801eee:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801eef:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801ef4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801ef8:	e9 df 00 00 00       	jmpq   801fdc <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f01:	48 c1 e8 27          	shr    $0x27,%rax
  801f05:	48 89 c2             	mov    %rax,%rdx
  801f08:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f0f:	01 00 00 
  801f12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f16:	83 e0 01             	and    $0x1,%eax
  801f19:	48 85 c0             	test   %rax,%rax
  801f1c:	0f 84 9e 00 00 00    	je     801fc0 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f26:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f2a:	48 89 c2             	mov    %rax,%rdx
  801f2d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f34:	01 00 00 
  801f37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3b:	83 e0 01             	and    $0x1,%eax
  801f3e:	48 85 c0             	test   %rax,%rax
  801f41:	74 73                	je     801fb6 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f47:	48 c1 e8 15          	shr    $0x15,%rax
  801f4b:	48 89 c2             	mov    %rax,%rdx
  801f4e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f55:	01 00 00 
  801f58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5c:	83 e0 01             	and    $0x1,%eax
  801f5f:	48 85 c0             	test   %rax,%rax
  801f62:	74 48                	je     801fac <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801f64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f68:	48 c1 e8 0c          	shr    $0xc,%rax
  801f6c:	48 89 c2             	mov    %rax,%rdx
  801f6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f76:	01 00 00 
  801f79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f85:	83 e0 01             	and    $0x1,%eax
  801f88:	48 85 c0             	test   %rax,%rax
  801f8b:	74 47                	je     801fd4 <fork+0x19d>
						duppage(envid, VPN(addr));
  801f8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f91:	48 c1 e8 0c          	shr    $0xc,%rax
  801f95:	89 c2                	mov    %eax,%edx
  801f97:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f9a:	89 d6                	mov    %edx,%esi
  801f9c:	89 c7                	mov    %eax,%edi
  801f9e:	48 b8 73 1c 80 00 00 	movabs $0x801c73,%rax
  801fa5:	00 00 00 
  801fa8:	ff d0                	callq  *%rax
  801faa:	eb 28                	jmp    801fd4 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  801fac:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801fb3:	00 
  801fb4:	eb 1e                	jmp    801fd4 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801fb6:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801fbd:	40 
  801fbe:	eb 14                	jmp    801fd4 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  801fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc4:	48 c1 e8 27          	shr    $0x27,%rax
  801fc8:	48 83 c0 01          	add    $0x1,%rax
  801fcc:	48 c1 e0 27          	shl    $0x27,%rax
  801fd0:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801fd4:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801fdb:	00 
  801fdc:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  801fe3:	00 
  801fe4:	0f 87 13 ff ff ff    	ja     801efd <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801fea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fed:	ba 07 00 00 00       	mov    $0x7,%edx
  801ff2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801ff7:	89 c7                	mov    %eax,%edi
  801ff9:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802005:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802008:	ba 07 00 00 00       	mov    $0x7,%edx
  80200d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802012:	89 c7                	mov    %eax,%edi
  802014:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  80201b:	00 00 00 
  80201e:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802020:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802023:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802029:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80202e:	ba 00 00 00 00       	mov    $0x0,%edx
  802033:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802038:	89 c7                	mov    %eax,%edi
  80203a:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802046:	ba 00 10 00 00       	mov    $0x1000,%edx
  80204b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802050:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802055:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  80205c:	00 00 00 
  80205f:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802061:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802066:	bf 00 00 00 00       	mov    $0x0,%edi
  80206b:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  802072:	00 00 00 
  802075:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802077:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80207e:	00 00 00 
  802081:	48 8b 00             	mov    (%rax),%rax
  802084:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80208b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80208e:	48 89 d6             	mov    %rdx,%rsi
  802091:	89 c7                	mov    %eax,%edi
  802093:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  80209f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020a2:	be 02 00 00 00       	mov    $0x2,%esi
  8020a7:	89 c7                	mov    %eax,%edi
  8020a9:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	callq  *%rax

	return envid;
  8020b5:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8020b8:	c9                   	leaveq 
  8020b9:	c3                   	retq   

00000000008020ba <sfork>:

// Challenge!
int
sfork(void)
{
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020be:	48 ba d3 2a 80 00 00 	movabs $0x802ad3,%rdx
  8020c5:	00 00 00 
  8020c8:	be b8 00 00 00       	mov    $0xb8,%esi
  8020cd:	48 bf 1d 2a 80 00 00 	movabs $0x802a1d,%rdi
  8020d4:	00 00 00 
  8020d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020dc:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  8020e3:	00 00 00 
  8020e6:	ff d1                	callq  *%rcx

00000000008020e8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020e8:	55                   	push   %rbp
  8020e9:	48 89 e5             	mov    %rsp,%rbp
  8020ec:	48 83 ec 30          	sub    $0x30,%rsp
  8020f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8020f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8020f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8020fc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802101:	75 0e                	jne    802111 <ipc_recv+0x29>
        pg = (void *)UTOP;
  802103:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80210a:	00 00 00 
  80210d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  802111:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802115:	48 89 c7             	mov    %rax,%rdi
  802118:	48 b8 9a 1a 80 00 00 	movabs $0x801a9a,%rax
  80211f:	00 00 00 
  802122:	ff d0                	callq  *%rax
  802124:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802127:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80212b:	79 27                	jns    802154 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80212d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802132:	74 0a                	je     80213e <ipc_recv+0x56>
            *from_env_store = 0;
  802134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802138:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80213e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802143:	74 0a                	je     80214f <ipc_recv+0x67>
            *perm_store = 0;
  802145:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802149:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80214f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802152:	eb 53                	jmp    8021a7 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  802154:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802159:	74 19                	je     802174 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80215b:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802162:	00 00 00 
  802165:	48 8b 00             	mov    (%rax),%rax
  802168:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  802174:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802179:	74 19                	je     802194 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80217b:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802182:	00 00 00 
  802185:	48 8b 00             	mov    (%rax),%rax
  802188:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80218e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802192:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  802194:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80219b:	00 00 00 
  80219e:	48 8b 00             	mov    (%rax),%rax
  8021a1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8021a7:	c9                   	leaveq 
  8021a8:	c3                   	retq   

00000000008021a9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021a9:	55                   	push   %rbp
  8021aa:	48 89 e5             	mov    %rsp,%rbp
  8021ad:	48 83 ec 30          	sub    $0x30,%rsp
  8021b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021b4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8021b7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8021bb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8021be:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8021c3:	75 0e                	jne    8021d3 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8021c5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8021cc:	00 00 00 
  8021cf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8021d3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8021d6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8021d9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021e0:	89 c7                	mov    %eax,%edi
  8021e2:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	callq  *%rax
  8021ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8021f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f5:	79 36                	jns    80222d <ipc_send+0x84>
  8021f7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8021fb:	74 30                	je     80222d <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8021fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802200:	89 c1                	mov    %eax,%ecx
  802202:	48 ba e9 2a 80 00 00 	movabs $0x802ae9,%rdx
  802209:	00 00 00 
  80220c:	be 49 00 00 00       	mov    $0x49,%esi
  802211:	48 bf f6 2a 80 00 00 	movabs $0x802af6,%rdi
  802218:	00 00 00 
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
  802220:	49 b8 c3 22 80 00 00 	movabs $0x8022c3,%r8
  802227:	00 00 00 
  80222a:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80222d:	48 b8 7d 18 80 00 00 	movabs $0x80187d,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
    } while(r != 0);
  802239:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223d:	75 94                	jne    8021d3 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80223f:	c9                   	leaveq 
  802240:	c3                   	retq   

0000000000802241 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802241:	55                   	push   %rbp
  802242:	48 89 e5             	mov    %rsp,%rbp
  802245:	48 83 ec 14          	sub    $0x14,%rsp
  802249:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80224c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802253:	eb 5e                	jmp    8022b3 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802255:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80225c:	00 00 00 
  80225f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802262:	48 63 d0             	movslq %eax,%rdx
  802265:	48 89 d0             	mov    %rdx,%rax
  802268:	48 c1 e0 03          	shl    $0x3,%rax
  80226c:	48 01 d0             	add    %rdx,%rax
  80226f:	48 c1 e0 05          	shl    $0x5,%rax
  802273:	48 01 c8             	add    %rcx,%rax
  802276:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80227c:	8b 00                	mov    (%rax),%eax
  80227e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802281:	75 2c                	jne    8022af <ipc_find_env+0x6e>
			return envs[i].env_id;
  802283:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80228a:	00 00 00 
  80228d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802290:	48 63 d0             	movslq %eax,%rdx
  802293:	48 89 d0             	mov    %rdx,%rax
  802296:	48 c1 e0 03          	shl    $0x3,%rax
  80229a:	48 01 d0             	add    %rdx,%rax
  80229d:	48 c1 e0 05          	shl    $0x5,%rax
  8022a1:	48 01 c8             	add    %rcx,%rax
  8022a4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8022aa:	8b 40 08             	mov    0x8(%rax),%eax
  8022ad:	eb 12                	jmp    8022c1 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8022af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022b3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8022ba:	7e 99                	jle    802255 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c1:	c9                   	leaveq 
  8022c2:	c3                   	retq   

00000000008022c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022c3:	55                   	push   %rbp
  8022c4:	48 89 e5             	mov    %rsp,%rbp
  8022c7:	53                   	push   %rbx
  8022c8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8022cf:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8022d6:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8022dc:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8022e3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8022ea:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8022f1:	84 c0                	test   %al,%al
  8022f3:	74 23                	je     802318 <_panic+0x55>
  8022f5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8022fc:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802300:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802304:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802308:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80230c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802310:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802314:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802318:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80231f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802326:	00 00 00 
  802329:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802330:	00 00 00 
  802333:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802337:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80233e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802345:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80234c:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802353:	00 00 00 
  802356:	48 8b 18             	mov    (%rax),%rbx
  802359:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802360:	00 00 00 
  802363:	ff d0                	callq  *%rax
  802365:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80236b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802372:	41 89 c8             	mov    %ecx,%r8d
  802375:	48 89 d1             	mov    %rdx,%rcx
  802378:	48 89 da             	mov    %rbx,%rdx
  80237b:	89 c6                	mov    %eax,%esi
  80237d:	48 bf 00 2b 80 00 00 	movabs $0x802b00,%rdi
  802384:	00 00 00 
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	49 b9 c4 03 80 00 00 	movabs $0x8003c4,%r9
  802393:	00 00 00 
  802396:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802399:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8023a0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8023a7:	48 89 d6             	mov    %rdx,%rsi
  8023aa:	48 89 c7             	mov    %rax,%rdi
  8023ad:	48 b8 18 03 80 00 00 	movabs $0x800318,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	callq  *%rax
	cprintf("\n");
  8023b9:	48 bf 23 2b 80 00 00 	movabs $0x802b23,%rdi
  8023c0:	00 00 00 
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	48 ba c4 03 80 00 00 	movabs $0x8003c4,%rdx
  8023cf:	00 00 00 
  8023d2:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023d4:	cc                   	int3   
  8023d5:	eb fd                	jmp    8023d4 <_panic+0x111>

00000000008023d7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023d7:	55                   	push   %rbp
  8023d8:	48 89 e5             	mov    %rsp,%rbp
  8023db:	48 83 ec 10          	sub    $0x10,%rsp
  8023df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8023e3:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  8023ea:	00 00 00 
  8023ed:	48 8b 00             	mov    (%rax),%rax
  8023f0:	48 85 c0             	test   %rax,%rax
  8023f3:	75 49                	jne    80243e <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8023f5:	ba 07 00 00 00       	mov    $0x7,%edx
  8023fa:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802404:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
  802410:	85 c0                	test   %eax,%eax
  802412:	79 2a                	jns    80243e <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  802414:	48 ba 28 2b 80 00 00 	movabs $0x802b28,%rdx
  80241b:	00 00 00 
  80241e:	be 21 00 00 00       	mov    $0x21,%esi
  802423:	48 bf 53 2b 80 00 00 	movabs $0x802b53,%rdi
  80242a:	00 00 00 
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
  802432:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  802439:	00 00 00 
  80243c:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80243e:	48 b8 18 40 80 00 00 	movabs $0x804018,%rax
  802445:	00 00 00 
  802448:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80244c:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80244f:	48 be 9a 24 80 00 00 	movabs $0x80249a,%rsi
  802456:	00 00 00 
  802459:	bf 00 00 00 00       	mov    $0x0,%edi
  80245e:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  802465:	00 00 00 
  802468:	ff d0                	callq  *%rax
  80246a:	85 c0                	test   %eax,%eax
  80246c:	79 2a                	jns    802498 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  80246e:	48 ba 68 2b 80 00 00 	movabs $0x802b68,%rdx
  802475:	00 00 00 
  802478:	be 27 00 00 00       	mov    $0x27,%esi
  80247d:	48 bf 53 2b 80 00 00 	movabs $0x802b53,%rdi
  802484:	00 00 00 
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
  80248c:	48 b9 c3 22 80 00 00 	movabs $0x8022c3,%rcx
  802493:	00 00 00 
  802496:	ff d1                	callq  *%rcx
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80249a:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80249d:	48 a1 18 40 80 00 00 	movabs 0x804018,%rax
  8024a4:	00 00 00 
call *%rax
  8024a7:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  8024a9:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8024b0:	00 
    movq 152(%rsp), %rcx
  8024b1:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8024b8:	00 
    subq $8, %rcx
  8024b9:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  8024bd:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  8024c0:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8024c7:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  8024c8:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8024cc:	4c 8b 3c 24          	mov    (%rsp),%r15
  8024d0:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8024d5:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8024da:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8024df:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8024e4:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8024e9:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8024ee:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8024f3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8024f8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8024fd:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802502:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802507:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80250c:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802511:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802516:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  80251a:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  80251e:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  80251f:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  802520:	c3                   	retq   
