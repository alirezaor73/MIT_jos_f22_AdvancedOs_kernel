
obj/user/spawnhello:     file format elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba d4 03 80 00 00 	movabs $0x8003d4,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be fe 40 80 00 00 	movabs $0x8040fe,%rsi
  80008e:	00 00 00 
  800091:	48 bf 04 41 80 00 00 	movabs $0x804104,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 dc 2e 80 00 00 	movabs $0x802edc,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba 0f 41 80 00 00 	movabs $0x80410f,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf 27 41 80 00 00 	movabs $0x804127,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 20          	sub    $0x20,%rsp
  8000ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8000f6:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010d:	48 63 d0             	movslq %eax,%rdx
  800110:	48 89 d0             	mov    %rdx,%rax
  800113:	48 c1 e0 03          	shl    $0x3,%rax
  800117:	48 01 d0             	add    %rdx,%rax
  80011a:	48 c1 e0 05          	shl    $0x5,%rax
  80011e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800125:	00 00 00 
  800128:	48 01 c2             	add    %rax,%rdx
  80012b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800132:	00 00 00 
  800135:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800138:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80013c:	7e 14                	jle    800152 <libmain+0x6b>
		binaryname = argv[0];
  80013e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800142:	48 8b 10             	mov    (%rax),%rdx
  800145:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80014c:	00 00 00 
  80014f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800152:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800156:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800159:	48 89 d6             	mov    %rdx,%rsi
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800165:	00 00 00 
  800168:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80016a:	48 b8 78 01 80 00 00 	movabs $0x800178,%rax
  800171:	00 00 00 
  800174:	ff d0                	callq  *%rax
}
  800176:	c9                   	leaveq 
  800177:	c3                   	retq   

0000000000800178 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800178:	55                   	push   %rbp
  800179:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80017c:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800188:	bf 00 00 00 00       	mov    $0x0,%edi
  80018d:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  800194:	00 00 00 
  800197:	ff d0                	callq  *%rax
}
  800199:	5d                   	pop    %rbp
  80019a:	c3                   	retq   

000000000080019b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019b:	55                   	push   %rbp
  80019c:	48 89 e5             	mov    %rsp,%rbp
  80019f:	53                   	push   %rbx
  8001a0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8001a7:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001ae:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001b4:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001bb:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001c2:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001c9:	84 c0                	test   %al,%al
  8001cb:	74 23                	je     8001f0 <_panic+0x55>
  8001cd:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001d4:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001d8:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001dc:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001e0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001e4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001e8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001ec:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001f0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001f7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001fe:	00 00 00 
  800201:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800208:	00 00 00 
  80020b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80020f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800216:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80021d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800224:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80022b:	00 00 00 
  80022e:	48 8b 18             	mov    (%rax),%rbx
  800231:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  800238:	00 00 00 
  80023b:	ff d0                	callq  *%rax
  80023d:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800243:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80024a:	41 89 c8             	mov    %ecx,%r8d
  80024d:	48 89 d1             	mov    %rdx,%rcx
  800250:	48 89 da             	mov    %rbx,%rdx
  800253:	89 c6                	mov    %eax,%esi
  800255:	48 bf 48 41 80 00 00 	movabs $0x804148,%rdi
  80025c:	00 00 00 
  80025f:	b8 00 00 00 00       	mov    $0x0,%eax
  800264:	49 b9 d4 03 80 00 00 	movabs $0x8003d4,%r9
  80026b:	00 00 00 
  80026e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800271:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800278:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80027f:	48 89 d6             	mov    %rdx,%rsi
  800282:	48 89 c7             	mov    %rax,%rdi
  800285:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  80028c:	00 00 00 
  80028f:	ff d0                	callq  *%rax
	cprintf("\n");
  800291:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800298:	00 00 00 
  80029b:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a0:	48 ba d4 03 80 00 00 	movabs $0x8003d4,%rdx
  8002a7:	00 00 00 
  8002aa:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ac:	cc                   	int3   
  8002ad:	eb fd                	jmp    8002ac <_panic+0x111>

00000000008002af <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002af:	55                   	push   %rbp
  8002b0:	48 89 e5             	mov    %rsp,%rbp
  8002b3:	48 83 ec 10          	sub    $0x10,%rsp
  8002b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002c2:	8b 00                	mov    (%rax),%eax
  8002c4:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002cb:	89 0a                	mov    %ecx,(%rdx)
  8002cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002d0:	89 d1                	mov    %edx,%ecx
  8002d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d6:	48 98                	cltq   
  8002d8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e0:	8b 00                	mov    (%rax),%eax
  8002e2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e7:	75 2c                	jne    800315 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ed:	8b 00                	mov    (%rax),%eax
  8002ef:	48 98                	cltq   
  8002f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f5:	48 83 c2 08          	add    $0x8,%rdx
  8002f9:	48 89 c6             	mov    %rax,%rsi
  8002fc:	48 89 d7             	mov    %rdx,%rdi
  8002ff:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
        b->idx = 0;
  80030b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800319:	8b 40 04             	mov    0x4(%rax),%eax
  80031c:	8d 50 01             	lea    0x1(%rax),%edx
  80031f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800323:	89 50 04             	mov    %edx,0x4(%rax)
}
  800326:	c9                   	leaveq 
  800327:	c3                   	retq   

0000000000800328 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800328:	55                   	push   %rbp
  800329:	48 89 e5             	mov    %rsp,%rbp
  80032c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800333:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80033a:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800341:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800348:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80034f:	48 8b 0a             	mov    (%rdx),%rcx
  800352:	48 89 08             	mov    %rcx,(%rax)
  800355:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800359:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80035d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800361:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800365:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80036c:	00 00 00 
    b.cnt = 0;
  80036f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800376:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800379:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800380:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800387:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80038e:	48 89 c6             	mov    %rax,%rsi
  800391:	48 bf af 02 80 00 00 	movabs $0x8002af,%rdi
  800398:	00 00 00 
  80039b:	48 b8 87 07 80 00 00 	movabs $0x800787,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8003a7:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003ad:	48 98                	cltq   
  8003af:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b6:	48 83 c2 08          	add    $0x8,%rdx
  8003ba:	48 89 c6             	mov    %rax,%rsi
  8003bd:	48 89 d7             	mov    %rdx,%rdi
  8003c0:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003cc:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003d2:	c9                   	leaveq 
  8003d3:	c3                   	retq   

00000000008003d4 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003d4:	55                   	push   %rbp
  8003d5:	48 89 e5             	mov    %rsp,%rbp
  8003d8:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003df:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003ed:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003f4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003fb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800402:	84 c0                	test   %al,%al
  800404:	74 20                	je     800426 <cprintf+0x52>
  800406:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80040a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80040e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800412:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800416:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80041a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80041e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800422:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800426:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80042d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800434:	00 00 00 
  800437:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80043e:	00 00 00 
  800441:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800445:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80044c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800453:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80045a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800461:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800468:	48 8b 0a             	mov    (%rdx),%rcx
  80046b:	48 89 08             	mov    %rcx,(%rax)
  80046e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800472:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800476:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80047a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80047e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800485:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80048c:	48 89 d6             	mov    %rdx,%rsi
  80048f:	48 89 c7             	mov    %rax,%rdi
  800492:	48 b8 28 03 80 00 00 	movabs $0x800328,%rax
  800499:	00 00 00 
  80049c:	ff d0                	callq  *%rax
  80049e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8004a4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004aa:	c9                   	leaveq 
  8004ab:	c3                   	retq   

00000000008004ac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ac:	55                   	push   %rbp
  8004ad:	48 89 e5             	mov    %rsp,%rbp
  8004b0:	53                   	push   %rbx
  8004b1:	48 83 ec 38          	sub    $0x38,%rsp
  8004b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004c1:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004c4:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c8:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004cf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004d3:	77 3b                	ja     800510 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d5:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d8:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004dc:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e8:	48 f7 f3             	div    %rbx
  8004eb:	48 89 c2             	mov    %rax,%rdx
  8004ee:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004f1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fc:	41 89 f9             	mov    %edi,%r9d
  8004ff:	48 89 c7             	mov    %rax,%rdi
  800502:	48 b8 ac 04 80 00 00 	movabs $0x8004ac,%rax
  800509:	00 00 00 
  80050c:	ff d0                	callq  *%rax
  80050e:	eb 1e                	jmp    80052e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800510:	eb 12                	jmp    800524 <printnum+0x78>
			putch(padc, putdat);
  800512:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800516:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051d:	48 89 ce             	mov    %rcx,%rsi
  800520:	89 d7                	mov    %edx,%edi
  800522:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800524:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800528:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80052c:	7f e4                	jg     800512 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800535:	ba 00 00 00 00       	mov    $0x0,%edx
  80053a:	48 f7 f1             	div    %rcx
  80053d:	48 89 d0             	mov    %rdx,%rax
  800540:	48 ba 70 43 80 00 00 	movabs $0x804370,%rdx
  800547:	00 00 00 
  80054a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80054e:	0f be d0             	movsbl %al,%edx
  800551:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800559:	48 89 ce             	mov    %rcx,%rsi
  80055c:	89 d7                	mov    %edx,%edi
  80055e:	ff d0                	callq  *%rax
}
  800560:	48 83 c4 38          	add    $0x38,%rsp
  800564:	5b                   	pop    %rbx
  800565:	5d                   	pop    %rbp
  800566:	c3                   	retq   

0000000000800567 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800567:	55                   	push   %rbp
  800568:	48 89 e5             	mov    %rsp,%rbp
  80056b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80056f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800573:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800576:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80057a:	7e 52                	jle    8005ce <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80057c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800580:	8b 00                	mov    (%rax),%eax
  800582:	83 f8 30             	cmp    $0x30,%eax
  800585:	73 24                	jae    8005ab <getuint+0x44>
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
  8005a9:	eb 17                	jmp    8005c2 <getuint+0x5b>
  8005ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b3:	48 89 d0             	mov    %rdx,%rax
  8005b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c2:	48 8b 00             	mov    (%rax),%rax
  8005c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c9:	e9 a3 00 00 00       	jmpq   800671 <getuint+0x10a>
	else if (lflag)
  8005ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005d2:	74 4f                	je     800623 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d8:	8b 00                	mov    (%rax),%eax
  8005da:	83 f8 30             	cmp    $0x30,%eax
  8005dd:	73 24                	jae    800603 <getuint+0x9c>
  8005df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005eb:	8b 00                	mov    (%rax),%eax
  8005ed:	89 c0                	mov    %eax,%eax
  8005ef:	48 01 d0             	add    %rdx,%rax
  8005f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f6:	8b 12                	mov    (%rdx),%edx
  8005f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ff:	89 0a                	mov    %ecx,(%rdx)
  800601:	eb 17                	jmp    80061a <getuint+0xb3>
  800603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800607:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060b:	48 89 d0             	mov    %rdx,%rax
  80060e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800612:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800616:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061a:	48 8b 00             	mov    (%rax),%rax
  80061d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800621:	eb 4e                	jmp    800671 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800627:	8b 00                	mov    (%rax),%eax
  800629:	83 f8 30             	cmp    $0x30,%eax
  80062c:	73 24                	jae    800652 <getuint+0xeb>
  80062e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800632:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	8b 00                	mov    (%rax),%eax
  80063c:	89 c0                	mov    %eax,%eax
  80063e:	48 01 d0             	add    %rdx,%rax
  800641:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800645:	8b 12                	mov    (%rdx),%edx
  800647:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80064a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064e:	89 0a                	mov    %ecx,(%rdx)
  800650:	eb 17                	jmp    800669 <getuint+0x102>
  800652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800656:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80065a:	48 89 d0             	mov    %rdx,%rax
  80065d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800661:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800665:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800669:	8b 00                	mov    (%rax),%eax
  80066b:	89 c0                	mov    %eax,%eax
  80066d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800675:	c9                   	leaveq 
  800676:	c3                   	retq   

0000000000800677 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800677:	55                   	push   %rbp
  800678:	48 89 e5             	mov    %rsp,%rbp
  80067b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80067f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800683:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800686:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80068a:	7e 52                	jle    8006de <getint+0x67>
		x=va_arg(*ap, long long);
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	83 f8 30             	cmp    $0x30,%eax
  800695:	73 24                	jae    8006bb <getint+0x44>
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a3:	8b 00                	mov    (%rax),%eax
  8006a5:	89 c0                	mov    %eax,%eax
  8006a7:	48 01 d0             	add    %rdx,%rax
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	8b 12                	mov    (%rdx),%edx
  8006b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	89 0a                	mov    %ecx,(%rdx)
  8006b9:	eb 17                	jmp    8006d2 <getint+0x5b>
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c3:	48 89 d0             	mov    %rdx,%rax
  8006c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d2:	48 8b 00             	mov    (%rax),%rax
  8006d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d9:	e9 a3 00 00 00       	jmpq   800781 <getint+0x10a>
	else if (lflag)
  8006de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006e2:	74 4f                	je     800733 <getint+0xbc>
		x=va_arg(*ap, long);
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	8b 00                	mov    (%rax),%eax
  8006ea:	83 f8 30             	cmp    $0x30,%eax
  8006ed:	73 24                	jae    800713 <getint+0x9c>
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fb:	8b 00                	mov    (%rax),%eax
  8006fd:	89 c0                	mov    %eax,%eax
  8006ff:	48 01 d0             	add    %rdx,%rax
  800702:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800706:	8b 12                	mov    (%rdx),%edx
  800708:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070f:	89 0a                	mov    %ecx,(%rdx)
  800711:	eb 17                	jmp    80072a <getint+0xb3>
  800713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800717:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071b:	48 89 d0             	mov    %rdx,%rax
  80071e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800722:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800726:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072a:	48 8b 00             	mov    (%rax),%rax
  80072d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800731:	eb 4e                	jmp    800781 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	83 f8 30             	cmp    $0x30,%eax
  80073c:	73 24                	jae    800762 <getint+0xeb>
  80073e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800742:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	8b 00                	mov    (%rax),%eax
  80074c:	89 c0                	mov    %eax,%eax
  80074e:	48 01 d0             	add    %rdx,%rax
  800751:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800755:	8b 12                	mov    (%rdx),%edx
  800757:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075e:	89 0a                	mov    %ecx,(%rdx)
  800760:	eb 17                	jmp    800779 <getint+0x102>
  800762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800766:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076a:	48 89 d0             	mov    %rdx,%rax
  80076d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800771:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800775:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800779:	8b 00                	mov    (%rax),%eax
  80077b:	48 98                	cltq   
  80077d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800781:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800785:	c9                   	leaveq 
  800786:	c3                   	retq   

0000000000800787 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800787:	55                   	push   %rbp
  800788:	48 89 e5             	mov    %rsp,%rbp
  80078b:	41 54                	push   %r12
  80078d:	53                   	push   %rbx
  80078e:	48 83 ec 60          	sub    $0x60,%rsp
  800792:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800796:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80079a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80079e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007a2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a6:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007aa:	48 8b 0a             	mov    (%rdx),%rcx
  8007ad:	48 89 08             	mov    %rcx,(%rax)
  8007b0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007bc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c0:	eb 17                	jmp    8007d9 <vprintfmt+0x52>
			if (ch == '\0')
  8007c2:	85 db                	test   %ebx,%ebx
  8007c4:	0f 84 df 04 00 00    	je     800ca9 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8007ca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007d2:	48 89 d6             	mov    %rdx,%rsi
  8007d5:	89 df                	mov    %ebx,%edi
  8007d7:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007e1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007e5:	0f b6 00             	movzbl (%rax),%eax
  8007e8:	0f b6 d8             	movzbl %al,%ebx
  8007eb:	83 fb 25             	cmp    $0x25,%ebx
  8007ee:	75 d2                	jne    8007c2 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007f4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007fb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800802:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800809:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800810:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800814:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800818:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80081c:	0f b6 00             	movzbl (%rax),%eax
  80081f:	0f b6 d8             	movzbl %al,%ebx
  800822:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800825:	83 f8 55             	cmp    $0x55,%eax
  800828:	0f 87 47 04 00 00    	ja     800c75 <vprintfmt+0x4ee>
  80082e:	89 c0                	mov    %eax,%eax
  800830:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800837:	00 
  800838:	48 b8 98 43 80 00 00 	movabs $0x804398,%rax
  80083f:	00 00 00 
  800842:	48 01 d0             	add    %rdx,%rax
  800845:	48 8b 00             	mov    (%rax),%rax
  800848:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80084a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80084e:	eb c0                	jmp    800810 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800850:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800854:	eb ba                	jmp    800810 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800856:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80085d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800860:	89 d0                	mov    %edx,%eax
  800862:	c1 e0 02             	shl    $0x2,%eax
  800865:	01 d0                	add    %edx,%eax
  800867:	01 c0                	add    %eax,%eax
  800869:	01 d8                	add    %ebx,%eax
  80086b:	83 e8 30             	sub    $0x30,%eax
  80086e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800871:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800875:	0f b6 00             	movzbl (%rax),%eax
  800878:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087b:	83 fb 2f             	cmp    $0x2f,%ebx
  80087e:	7e 0c                	jle    80088c <vprintfmt+0x105>
  800880:	83 fb 39             	cmp    $0x39,%ebx
  800883:	7f 07                	jg     80088c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800885:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80088a:	eb d1                	jmp    80085d <vprintfmt+0xd6>
			goto process_precision;
  80088c:	eb 58                	jmp    8008e6 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80088e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800891:	83 f8 30             	cmp    $0x30,%eax
  800894:	73 17                	jae    8008ad <vprintfmt+0x126>
  800896:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80089a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089d:	89 c0                	mov    %eax,%eax
  80089f:	48 01 d0             	add    %rdx,%rax
  8008a2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a5:	83 c2 08             	add    $0x8,%edx
  8008a8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ab:	eb 0f                	jmp    8008bc <vprintfmt+0x135>
  8008ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b1:	48 89 d0             	mov    %rdx,%rax
  8008b4:	48 83 c2 08          	add    $0x8,%rdx
  8008b8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008c1:	eb 23                	jmp    8008e6 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c7:	79 0c                	jns    8008d5 <vprintfmt+0x14e>
				width = 0;
  8008c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008d0:	e9 3b ff ff ff       	jmpq   800810 <vprintfmt+0x89>
  8008d5:	e9 36 ff ff ff       	jmpq   800810 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008da:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008e1:	e9 2a ff ff ff       	jmpq   800810 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ea:	79 12                	jns    8008fe <vprintfmt+0x177>
				width = precision, precision = -1;
  8008ec:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008ef:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008f9:	e9 12 ff ff ff       	jmpq   800810 <vprintfmt+0x89>
  8008fe:	e9 0d ff ff ff       	jmpq   800810 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800903:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800907:	e9 04 ff ff ff       	jmpq   800810 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80090c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090f:	83 f8 30             	cmp    $0x30,%eax
  800912:	73 17                	jae    80092b <vprintfmt+0x1a4>
  800914:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800918:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091b:	89 c0                	mov    %eax,%eax
  80091d:	48 01 d0             	add    %rdx,%rax
  800920:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800923:	83 c2 08             	add    $0x8,%edx
  800926:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800929:	eb 0f                	jmp    80093a <vprintfmt+0x1b3>
  80092b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092f:	48 89 d0             	mov    %rdx,%rax
  800932:	48 83 c2 08          	add    $0x8,%rdx
  800936:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80093a:	8b 10                	mov    (%rax),%edx
  80093c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800940:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800944:	48 89 ce             	mov    %rcx,%rsi
  800947:	89 d7                	mov    %edx,%edi
  800949:	ff d0                	callq  *%rax
			break;
  80094b:	e9 53 03 00 00       	jmpq   800ca3 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800950:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800953:	83 f8 30             	cmp    $0x30,%eax
  800956:	73 17                	jae    80096f <vprintfmt+0x1e8>
  800958:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095f:	89 c0                	mov    %eax,%eax
  800961:	48 01 d0             	add    %rdx,%rax
  800964:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800967:	83 c2 08             	add    $0x8,%edx
  80096a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096d:	eb 0f                	jmp    80097e <vprintfmt+0x1f7>
  80096f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800973:	48 89 d0             	mov    %rdx,%rax
  800976:	48 83 c2 08          	add    $0x8,%rdx
  80097a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800980:	85 db                	test   %ebx,%ebx
  800982:	79 02                	jns    800986 <vprintfmt+0x1ff>
				err = -err;
  800984:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800986:	83 fb 15             	cmp    $0x15,%ebx
  800989:	7f 16                	jg     8009a1 <vprintfmt+0x21a>
  80098b:	48 b8 c0 42 80 00 00 	movabs $0x8042c0,%rax
  800992:	00 00 00 
  800995:	48 63 d3             	movslq %ebx,%rdx
  800998:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80099c:	4d 85 e4             	test   %r12,%r12
  80099f:	75 2e                	jne    8009cf <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8009a1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a9:	89 d9                	mov    %ebx,%ecx
  8009ab:	48 ba 81 43 80 00 00 	movabs $0x804381,%rdx
  8009b2:	00 00 00 
  8009b5:	48 89 c7             	mov    %rax,%rdi
  8009b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bd:	49 b8 b2 0c 80 00 00 	movabs $0x800cb2,%r8
  8009c4:	00 00 00 
  8009c7:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ca:	e9 d4 02 00 00       	jmpq   800ca3 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009cf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d7:	4c 89 e1             	mov    %r12,%rcx
  8009da:	48 ba 8a 43 80 00 00 	movabs $0x80438a,%rdx
  8009e1:	00 00 00 
  8009e4:	48 89 c7             	mov    %rax,%rdi
  8009e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ec:	49 b8 b2 0c 80 00 00 	movabs $0x800cb2,%r8
  8009f3:	00 00 00 
  8009f6:	41 ff d0             	callq  *%r8
			break;
  8009f9:	e9 a5 02 00 00       	jmpq   800ca3 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a01:	83 f8 30             	cmp    $0x30,%eax
  800a04:	73 17                	jae    800a1d <vprintfmt+0x296>
  800a06:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0d:	89 c0                	mov    %eax,%eax
  800a0f:	48 01 d0             	add    %rdx,%rax
  800a12:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a15:	83 c2 08             	add    $0x8,%edx
  800a18:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1b:	eb 0f                	jmp    800a2c <vprintfmt+0x2a5>
  800a1d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a21:	48 89 d0             	mov    %rdx,%rax
  800a24:	48 83 c2 08          	add    $0x8,%rdx
  800a28:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2c:	4c 8b 20             	mov    (%rax),%r12
  800a2f:	4d 85 e4             	test   %r12,%r12
  800a32:	75 0a                	jne    800a3e <vprintfmt+0x2b7>
				p = "(null)";
  800a34:	49 bc 8d 43 80 00 00 	movabs $0x80438d,%r12
  800a3b:	00 00 00 
			if (width > 0 && padc != '-')
  800a3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a42:	7e 3f                	jle    800a83 <vprintfmt+0x2fc>
  800a44:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a48:	74 39                	je     800a83 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a4a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a4d:	48 98                	cltq   
  800a4f:	48 89 c6             	mov    %rax,%rsi
  800a52:	4c 89 e7             	mov    %r12,%rdi
  800a55:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  800a5c:	00 00 00 
  800a5f:	ff d0                	callq  *%rax
  800a61:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a64:	eb 17                	jmp    800a7d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a66:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a6a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a72:	48 89 ce             	mov    %rcx,%rsi
  800a75:	89 d7                	mov    %edx,%edi
  800a77:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a79:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a81:	7f e3                	jg     800a66 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a83:	eb 37                	jmp    800abc <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a85:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a89:	74 1e                	je     800aa9 <vprintfmt+0x322>
  800a8b:	83 fb 1f             	cmp    $0x1f,%ebx
  800a8e:	7e 05                	jle    800a95 <vprintfmt+0x30e>
  800a90:	83 fb 7e             	cmp    $0x7e,%ebx
  800a93:	7e 14                	jle    800aa9 <vprintfmt+0x322>
					putch('?', putdat);
  800a95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9d:	48 89 d6             	mov    %rdx,%rsi
  800aa0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800aa5:	ff d0                	callq  *%rax
  800aa7:	eb 0f                	jmp    800ab8 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800aa9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab1:	48 89 d6             	mov    %rdx,%rsi
  800ab4:	89 df                	mov    %ebx,%edi
  800ab6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800abc:	4c 89 e0             	mov    %r12,%rax
  800abf:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ac3:	0f b6 00             	movzbl (%rax),%eax
  800ac6:	0f be d8             	movsbl %al,%ebx
  800ac9:	85 db                	test   %ebx,%ebx
  800acb:	74 10                	je     800add <vprintfmt+0x356>
  800acd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad1:	78 b2                	js     800a85 <vprintfmt+0x2fe>
  800ad3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ad7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800adb:	79 a8                	jns    800a85 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800add:	eb 16                	jmp    800af5 <vprintfmt+0x36e>
				putch(' ', putdat);
  800adf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae7:	48 89 d6             	mov    %rdx,%rsi
  800aea:	bf 20 00 00 00       	mov    $0x20,%edi
  800aef:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af9:	7f e4                	jg     800adf <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800afb:	e9 a3 01 00 00       	jmpq   800ca3 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b00:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b04:	be 03 00 00 00       	mov    $0x3,%esi
  800b09:	48 89 c7             	mov    %rax,%rdi
  800b0c:	48 b8 77 06 80 00 00 	movabs $0x800677,%rax
  800b13:	00 00 00 
  800b16:	ff d0                	callq  *%rax
  800b18:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b20:	48 85 c0             	test   %rax,%rax
  800b23:	79 1d                	jns    800b42 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2d:	48 89 d6             	mov    %rdx,%rsi
  800b30:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b35:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3b:	48 f7 d8             	neg    %rax
  800b3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b42:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b49:	e9 e8 00 00 00       	jmpq   800c36 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b4e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b52:	be 03 00 00 00       	mov    $0x3,%esi
  800b57:	48 89 c7             	mov    %rax,%rdi
  800b5a:	48 b8 67 05 80 00 00 	movabs $0x800567,%rax
  800b61:	00 00 00 
  800b64:	ff d0                	callq  *%rax
  800b66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b6a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b71:	e9 c0 00 00 00       	jmpq   800c36 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7e:	48 89 d6             	mov    %rdx,%rsi
  800b81:	bf 58 00 00 00       	mov    $0x58,%edi
  800b86:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b88:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b90:	48 89 d6             	mov    %rdx,%rsi
  800b93:	bf 58 00 00 00       	mov    $0x58,%edi
  800b98:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba2:	48 89 d6             	mov    %rdx,%rsi
  800ba5:	bf 58 00 00 00       	mov    $0x58,%edi
  800baa:	ff d0                	callq  *%rax
			break;
  800bac:	e9 f2 00 00 00       	jmpq   800ca3 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800bb1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb9:	48 89 d6             	mov    %rdx,%rsi
  800bbc:	bf 30 00 00 00       	mov    $0x30,%edi
  800bc1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800bc3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcb:	48 89 d6             	mov    %rdx,%rsi
  800bce:	bf 78 00 00 00       	mov    $0x78,%edi
  800bd3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd8:	83 f8 30             	cmp    $0x30,%eax
  800bdb:	73 17                	jae    800bf4 <vprintfmt+0x46d>
  800bdd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	89 c0                	mov    %eax,%eax
  800be6:	48 01 d0             	add    %rdx,%rax
  800be9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bec:	83 c2 08             	add    $0x8,%edx
  800bef:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf2:	eb 0f                	jmp    800c03 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800bf4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bf8:	48 89 d0             	mov    %rdx,%rax
  800bfb:	48 83 c2 08          	add    $0x8,%rdx
  800bff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c03:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c0a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c11:	eb 23                	jmp    800c36 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c13:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c17:	be 03 00 00 00       	mov    $0x3,%esi
  800c1c:	48 89 c7             	mov    %rax,%rdi
  800c1f:	48 b8 67 05 80 00 00 	movabs $0x800567,%rax
  800c26:	00 00 00 
  800c29:	ff d0                	callq  *%rax
  800c2b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c2f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c36:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c3b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c3e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c45:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4d:	45 89 c1             	mov    %r8d,%r9d
  800c50:	41 89 f8             	mov    %edi,%r8d
  800c53:	48 89 c7             	mov    %rax,%rdi
  800c56:	48 b8 ac 04 80 00 00 	movabs $0x8004ac,%rax
  800c5d:	00 00 00 
  800c60:	ff d0                	callq  *%rax
			break;
  800c62:	eb 3f                	jmp    800ca3 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6c:	48 89 d6             	mov    %rdx,%rsi
  800c6f:	89 df                	mov    %ebx,%edi
  800c71:	ff d0                	callq  *%rax
			break;
  800c73:	eb 2e                	jmp    800ca3 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7d:	48 89 d6             	mov    %rdx,%rsi
  800c80:	bf 25 00 00 00       	mov    $0x25,%edi
  800c85:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c87:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c8c:	eb 05                	jmp    800c93 <vprintfmt+0x50c>
  800c8e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c93:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c97:	48 83 e8 01          	sub    $0x1,%rax
  800c9b:	0f b6 00             	movzbl (%rax),%eax
  800c9e:	3c 25                	cmp    $0x25,%al
  800ca0:	75 ec                	jne    800c8e <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ca2:	90                   	nop
		}
	}
  800ca3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca4:	e9 30 fb ff ff       	jmpq   8007d9 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ca9:	48 83 c4 60          	add    $0x60,%rsp
  800cad:	5b                   	pop    %rbx
  800cae:	41 5c                	pop    %r12
  800cb0:	5d                   	pop    %rbp
  800cb1:	c3                   	retq   

0000000000800cb2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cb2:	55                   	push   %rbp
  800cb3:	48 89 e5             	mov    %rsp,%rbp
  800cb6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800cbd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cc4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ccb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cd2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cd9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ce0:	84 c0                	test   %al,%al
  800ce2:	74 20                	je     800d04 <printfmt+0x52>
  800ce4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ce8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cec:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cf0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cf4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cf8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cfc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d00:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d04:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d0b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d12:	00 00 00 
  800d15:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d1c:	00 00 00 
  800d1f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d23:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d2a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d31:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d38:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d3f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d46:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d4d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d54:	48 89 c7             	mov    %rax,%rdi
  800d57:	48 b8 87 07 80 00 00 	movabs $0x800787,%rax
  800d5e:	00 00 00 
  800d61:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d63:	c9                   	leaveq 
  800d64:	c3                   	retq   

0000000000800d65 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d65:	55                   	push   %rbp
  800d66:	48 89 e5             	mov    %rsp,%rbp
  800d69:	48 83 ec 10          	sub    $0x10,%rsp
  800d6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d78:	8b 40 10             	mov    0x10(%rax),%eax
  800d7b:	8d 50 01             	lea    0x1(%rax),%edx
  800d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d82:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d89:	48 8b 10             	mov    (%rax),%rdx
  800d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d90:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d94:	48 39 c2             	cmp    %rax,%rdx
  800d97:	73 17                	jae    800db0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d9d:	48 8b 00             	mov    (%rax),%rax
  800da0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800da4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800da8:	48 89 0a             	mov    %rcx,(%rdx)
  800dab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800dae:	88 10                	mov    %dl,(%rax)
}
  800db0:	c9                   	leaveq 
  800db1:	c3                   	retq   

0000000000800db2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db2:	55                   	push   %rbp
  800db3:	48 89 e5             	mov    %rsp,%rbp
  800db6:	48 83 ec 50          	sub    $0x50,%rsp
  800dba:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800dbe:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800dc1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dc5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dc9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800dcd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800dd1:	48 8b 0a             	mov    (%rdx),%rcx
  800dd4:	48 89 08             	mov    %rcx,(%rax)
  800dd7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ddb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ddf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800de3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800de7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800deb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800def:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800df2:	48 98                	cltq   
  800df4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800df8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dfc:	48 01 d0             	add    %rdx,%rax
  800dff:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e0a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e0f:	74 06                	je     800e17 <vsnprintf+0x65>
  800e11:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e15:	7f 07                	jg     800e1e <vsnprintf+0x6c>
		return -E_INVAL;
  800e17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e1c:	eb 2f                	jmp    800e4d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e1e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e22:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e26:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e2a:	48 89 c6             	mov    %rax,%rsi
  800e2d:	48 bf 65 0d 80 00 00 	movabs $0x800d65,%rdi
  800e34:	00 00 00 
  800e37:	48 b8 87 07 80 00 00 	movabs $0x800787,%rax
  800e3e:	00 00 00 
  800e41:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e47:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e4a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e4d:	c9                   	leaveq 
  800e4e:	c3                   	retq   

0000000000800e4f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e4f:	55                   	push   %rbp
  800e50:	48 89 e5             	mov    %rsp,%rbp
  800e53:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e5a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e61:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e67:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e6e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e75:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e7c:	84 c0                	test   %al,%al
  800e7e:	74 20                	je     800ea0 <snprintf+0x51>
  800e80:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e84:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e88:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e8c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e90:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e94:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e98:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e9c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ea0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ea7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800eae:	00 00 00 
  800eb1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800eb8:	00 00 00 
  800ebb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ebf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ec6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ecd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ed4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800edb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ee2:	48 8b 0a             	mov    (%rdx),%rcx
  800ee5:	48 89 08             	mov    %rcx,(%rax)
  800ee8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ef8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800eff:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f06:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f0c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f13:	48 89 c7             	mov    %rax,%rdi
  800f16:	48 b8 b2 0d 80 00 00 	movabs $0x800db2,%rax
  800f1d:	00 00 00 
  800f20:	ff d0                	callq  *%rax
  800f22:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f28:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f2e:	c9                   	leaveq 
  800f2f:	c3                   	retq   

0000000000800f30 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f30:	55                   	push   %rbp
  800f31:	48 89 e5             	mov    %rsp,%rbp
  800f34:	48 83 ec 18          	sub    $0x18,%rsp
  800f38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f43:	eb 09                	jmp    800f4e <strlen+0x1e>
		n++;
  800f45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f49:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f52:	0f b6 00             	movzbl (%rax),%eax
  800f55:	84 c0                	test   %al,%al
  800f57:	75 ec                	jne    800f45 <strlen+0x15>
		n++;
	return n;
  800f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f5c:	c9                   	leaveq 
  800f5d:	c3                   	retq   

0000000000800f5e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f5e:	55                   	push   %rbp
  800f5f:	48 89 e5             	mov    %rsp,%rbp
  800f62:	48 83 ec 20          	sub    $0x20,%rsp
  800f66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f75:	eb 0e                	jmp    800f85 <strnlen+0x27>
		n++;
  800f77:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f7b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f80:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f85:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f8a:	74 0b                	je     800f97 <strnlen+0x39>
  800f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f90:	0f b6 00             	movzbl (%rax),%eax
  800f93:	84 c0                	test   %al,%al
  800f95:	75 e0                	jne    800f77 <strnlen+0x19>
		n++;
	return n;
  800f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f9a:	c9                   	leaveq 
  800f9b:	c3                   	retq   

0000000000800f9c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f9c:	55                   	push   %rbp
  800f9d:	48 89 e5             	mov    %rsp,%rbp
  800fa0:	48 83 ec 20          	sub    $0x20,%rsp
  800fa4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fb4:	90                   	nop
  800fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fbd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fc1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fc5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fc9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fcd:	0f b6 12             	movzbl (%rdx),%edx
  800fd0:	88 10                	mov    %dl,(%rax)
  800fd2:	0f b6 00             	movzbl (%rax),%eax
  800fd5:	84 c0                	test   %al,%al
  800fd7:	75 dc                	jne    800fb5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fdd:	c9                   	leaveq 
  800fde:	c3                   	retq   

0000000000800fdf <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 83 ec 20          	sub    $0x20,%rsp
  800fe7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800feb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff3:	48 89 c7             	mov    %rax,%rdi
  800ff6:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  800ffd:	00 00 00 
  801000:	ff d0                	callq  *%rax
  801002:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801005:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801008:	48 63 d0             	movslq %eax,%rdx
  80100b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100f:	48 01 c2             	add    %rax,%rdx
  801012:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801016:	48 89 c6             	mov    %rax,%rsi
  801019:	48 89 d7             	mov    %rdx,%rdi
  80101c:	48 b8 9c 0f 80 00 00 	movabs $0x800f9c,%rax
  801023:	00 00 00 
  801026:	ff d0                	callq  *%rax
	return dst;
  801028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80102c:	c9                   	leaveq 
  80102d:	c3                   	retq   

000000000080102e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80102e:	55                   	push   %rbp
  80102f:	48 89 e5             	mov    %rsp,%rbp
  801032:	48 83 ec 28          	sub    $0x28,%rsp
  801036:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80103e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801046:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80104a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801051:	00 
  801052:	eb 2a                	jmp    80107e <strncpy+0x50>
		*dst++ = *src;
  801054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801058:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801060:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801064:	0f b6 12             	movzbl (%rdx),%edx
  801067:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801069:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106d:	0f b6 00             	movzbl (%rax),%eax
  801070:	84 c0                	test   %al,%al
  801072:	74 05                	je     801079 <strncpy+0x4b>
			src++;
  801074:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801079:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801082:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801086:	72 cc                	jb     801054 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80108c:	c9                   	leaveq 
  80108d:	c3                   	retq   

000000000080108e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80108e:	55                   	push   %rbp
  80108f:	48 89 e5             	mov    %rsp,%rbp
  801092:	48 83 ec 28          	sub    $0x28,%rsp
  801096:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80109a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80109e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010af:	74 3d                	je     8010ee <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8010b1:	eb 1d                	jmp    8010d0 <strlcpy+0x42>
			*dst++ = *src++;
  8010b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010bf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010c7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010cb:	0f b6 12             	movzbl (%rdx),%edx
  8010ce:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010da:	74 0b                	je     8010e7 <strlcpy+0x59>
  8010dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e0:	0f b6 00             	movzbl (%rax),%eax
  8010e3:	84 c0                	test   %al,%al
  8010e5:	75 cc                	jne    8010b3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f6:	48 29 c2             	sub    %rax,%rdx
  8010f9:	48 89 d0             	mov    %rdx,%rax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 10          	sub    $0x10,%rsp
  801106:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80110e:	eb 0a                	jmp    80111a <strcmp+0x1c>
		p++, q++;
  801110:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801115:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111e:	0f b6 00             	movzbl (%rax),%eax
  801121:	84 c0                	test   %al,%al
  801123:	74 12                	je     801137 <strcmp+0x39>
  801125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801129:	0f b6 10             	movzbl (%rax),%edx
  80112c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801130:	0f b6 00             	movzbl (%rax),%eax
  801133:	38 c2                	cmp    %al,%dl
  801135:	74 d9                	je     801110 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	0f b6 d0             	movzbl %al,%edx
  801141:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801145:	0f b6 00             	movzbl (%rax),%eax
  801148:	0f b6 c0             	movzbl %al,%eax
  80114b:	29 c2                	sub    %eax,%edx
  80114d:	89 d0                	mov    %edx,%eax
}
  80114f:	c9                   	leaveq 
  801150:	c3                   	retq   

0000000000801151 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801151:	55                   	push   %rbp
  801152:	48 89 e5             	mov    %rsp,%rbp
  801155:	48 83 ec 18          	sub    $0x18,%rsp
  801159:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80115d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801161:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801165:	eb 0f                	jmp    801176 <strncmp+0x25>
		n--, p++, q++;
  801167:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80116c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801171:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801176:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80117b:	74 1d                	je     80119a <strncmp+0x49>
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	0f b6 00             	movzbl (%rax),%eax
  801184:	84 c0                	test   %al,%al
  801186:	74 12                	je     80119a <strncmp+0x49>
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118c:	0f b6 10             	movzbl (%rax),%edx
  80118f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801193:	0f b6 00             	movzbl (%rax),%eax
  801196:	38 c2                	cmp    %al,%dl
  801198:	74 cd                	je     801167 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80119a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119f:	75 07                	jne    8011a8 <strncmp+0x57>
		return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a6:	eb 18                	jmp    8011c0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ac:	0f b6 00             	movzbl (%rax),%eax
  8011af:	0f b6 d0             	movzbl %al,%edx
  8011b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	0f b6 c0             	movzbl %al,%eax
  8011bc:	29 c2                	sub    %eax,%edx
  8011be:	89 d0                	mov    %edx,%eax
}
  8011c0:	c9                   	leaveq 
  8011c1:	c3                   	retq   

00000000008011c2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011c2:	55                   	push   %rbp
  8011c3:	48 89 e5             	mov    %rsp,%rbp
  8011c6:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ce:	89 f0                	mov    %esi,%eax
  8011d0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011d3:	eb 17                	jmp    8011ec <strchr+0x2a>
		if (*s == c)
  8011d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d9:	0f b6 00             	movzbl (%rax),%eax
  8011dc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011df:	75 06                	jne    8011e7 <strchr+0x25>
			return (char *) s;
  8011e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e5:	eb 15                	jmp    8011fc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	84 c0                	test   %al,%al
  8011f5:	75 de                	jne    8011d5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fc:	c9                   	leaveq 
  8011fd:	c3                   	retq   

00000000008011fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	48 83 ec 0c          	sub    $0xc,%rsp
  801206:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80120a:	89 f0                	mov    %esi,%eax
  80120c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80120f:	eb 13                	jmp    801224 <strfind+0x26>
		if (*s == c)
  801211:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801215:	0f b6 00             	movzbl (%rax),%eax
  801218:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80121b:	75 02                	jne    80121f <strfind+0x21>
			break;
  80121d:	eb 10                	jmp    80122f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80121f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801228:	0f b6 00             	movzbl (%rax),%eax
  80122b:	84 c0                	test   %al,%al
  80122d:	75 e2                	jne    801211 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80122f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801233:	c9                   	leaveq 
  801234:	c3                   	retq   

0000000000801235 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801235:	55                   	push   %rbp
  801236:	48 89 e5             	mov    %rsp,%rbp
  801239:	48 83 ec 18          	sub    $0x18,%rsp
  80123d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801241:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801244:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801248:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80124d:	75 06                	jne    801255 <memset+0x20>
		return v;
  80124f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801253:	eb 69                	jmp    8012be <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801259:	83 e0 03             	and    $0x3,%eax
  80125c:	48 85 c0             	test   %rax,%rax
  80125f:	75 48                	jne    8012a9 <memset+0x74>
  801261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801265:	83 e0 03             	and    $0x3,%eax
  801268:	48 85 c0             	test   %rax,%rax
  80126b:	75 3c                	jne    8012a9 <memset+0x74>
		c &= 0xFF;
  80126d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801274:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801277:	c1 e0 18             	shl    $0x18,%eax
  80127a:	89 c2                	mov    %eax,%edx
  80127c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80127f:	c1 e0 10             	shl    $0x10,%eax
  801282:	09 c2                	or     %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801287:	c1 e0 08             	shl    $0x8,%eax
  80128a:	09 d0                	or     %edx,%eax
  80128c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	48 c1 e8 02          	shr    $0x2,%rax
  801297:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80129a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012a1:	48 89 d7             	mov    %rdx,%rdi
  8012a4:	fc                   	cld    
  8012a5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012a7:	eb 11                	jmp    8012ba <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012b0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012b4:	48 89 d7             	mov    %rdx,%rdi
  8012b7:	fc                   	cld    
  8012b8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012be:	c9                   	leaveq 
  8012bf:	c3                   	retq   

00000000008012c0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012c0:	55                   	push   %rbp
  8012c1:	48 89 e5             	mov    %rsp,%rbp
  8012c4:	48 83 ec 28          	sub    $0x28,%rsp
  8012c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012ec:	0f 83 88 00 00 00    	jae    80137a <memmove+0xba>
  8012f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012fa:	48 01 d0             	add    %rdx,%rax
  8012fd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801301:	76 77                	jbe    80137a <memmove+0xba>
		s += n;
  801303:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801307:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80130b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801317:	83 e0 03             	and    $0x3,%eax
  80131a:	48 85 c0             	test   %rax,%rax
  80131d:	75 3b                	jne    80135a <memmove+0x9a>
  80131f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801323:	83 e0 03             	and    $0x3,%eax
  801326:	48 85 c0             	test   %rax,%rax
  801329:	75 2f                	jne    80135a <memmove+0x9a>
  80132b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80132f:	83 e0 03             	and    $0x3,%eax
  801332:	48 85 c0             	test   %rax,%rax
  801335:	75 23                	jne    80135a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133b:	48 83 e8 04          	sub    $0x4,%rax
  80133f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801343:	48 83 ea 04          	sub    $0x4,%rdx
  801347:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80134b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80134f:	48 89 c7             	mov    %rax,%rdi
  801352:	48 89 d6             	mov    %rdx,%rsi
  801355:	fd                   	std    
  801356:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801358:	eb 1d                	jmp    801377 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80135a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80136a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136e:	48 89 d7             	mov    %rdx,%rdi
  801371:	48 89 c1             	mov    %rax,%rcx
  801374:	fd                   	std    
  801375:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801377:	fc                   	cld    
  801378:	eb 57                	jmp    8013d1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137e:	83 e0 03             	and    $0x3,%eax
  801381:	48 85 c0             	test   %rax,%rax
  801384:	75 36                	jne    8013bc <memmove+0xfc>
  801386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138a:	83 e0 03             	and    $0x3,%eax
  80138d:	48 85 c0             	test   %rax,%rax
  801390:	75 2a                	jne    8013bc <memmove+0xfc>
  801392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801396:	83 e0 03             	and    $0x3,%eax
  801399:	48 85 c0             	test   %rax,%rax
  80139c:	75 1e                	jne    8013bc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80139e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a2:	48 c1 e8 02          	shr    $0x2,%rax
  8013a6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b1:	48 89 c7             	mov    %rax,%rdi
  8013b4:	48 89 d6             	mov    %rdx,%rsi
  8013b7:	fc                   	cld    
  8013b8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013ba:	eb 15                	jmp    8013d1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013c8:	48 89 c7             	mov    %rax,%rdi
  8013cb:	48 89 d6             	mov    %rdx,%rsi
  8013ce:	fc                   	cld    
  8013cf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d5:	c9                   	leaveq 
  8013d6:	c3                   	retq   

00000000008013d7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013d7:	55                   	push   %rbp
  8013d8:	48 89 e5             	mov    %rsp,%rbp
  8013db:	48 83 ec 18          	sub    $0x18,%rsp
  8013df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013ef:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f7:	48 89 ce             	mov    %rcx,%rsi
  8013fa:	48 89 c7             	mov    %rax,%rdi
  8013fd:	48 b8 c0 12 80 00 00 	movabs $0x8012c0,%rax
  801404:	00 00 00 
  801407:	ff d0                	callq  *%rax
}
  801409:	c9                   	leaveq 
  80140a:	c3                   	retq   

000000000080140b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80140b:	55                   	push   %rbp
  80140c:	48 89 e5             	mov    %rsp,%rbp
  80140f:	48 83 ec 28          	sub    $0x28,%rsp
  801413:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801417:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80141b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80141f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801423:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801427:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80142f:	eb 36                	jmp    801467 <memcmp+0x5c>
		if (*s1 != *s2)
  801431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801435:	0f b6 10             	movzbl (%rax),%edx
  801438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	38 c2                	cmp    %al,%dl
  801441:	74 1a                	je     80145d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801447:	0f b6 00             	movzbl (%rax),%eax
  80144a:	0f b6 d0             	movzbl %al,%edx
  80144d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	0f b6 c0             	movzbl %al,%eax
  801457:	29 c2                	sub    %eax,%edx
  801459:	89 d0                	mov    %edx,%eax
  80145b:	eb 20                	jmp    80147d <memcmp+0x72>
		s1++, s2++;
  80145d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801462:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80146f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801473:	48 85 c0             	test   %rax,%rax
  801476:	75 b9                	jne    801431 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147d:	c9                   	leaveq 
  80147e:	c3                   	retq   

000000000080147f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80147f:	55                   	push   %rbp
  801480:	48 89 e5             	mov    %rsp,%rbp
  801483:	48 83 ec 28          	sub    $0x28,%rsp
  801487:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80148b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80148e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80149a:	48 01 d0             	add    %rdx,%rax
  80149d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014a1:	eb 15                	jmp    8014b8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a7:	0f b6 10             	movzbl (%rax),%edx
  8014aa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014ad:	38 c2                	cmp    %al,%dl
  8014af:	75 02                	jne    8014b3 <memfind+0x34>
			break;
  8014b1:	eb 0f                	jmp    8014c2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014b3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014c0:	72 e1                	jb     8014a3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014c6:	c9                   	leaveq 
  8014c7:	c3                   	retq   

00000000008014c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014c8:	55                   	push   %rbp
  8014c9:	48 89 e5             	mov    %rsp,%rbp
  8014cc:	48 83 ec 34          	sub    $0x34,%rsp
  8014d0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014d8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014e2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014e9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ea:	eb 05                	jmp    8014f1 <strtol+0x29>
		s++;
  8014ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	0f b6 00             	movzbl (%rax),%eax
  8014f8:	3c 20                	cmp    $0x20,%al
  8014fa:	74 f0                	je     8014ec <strtol+0x24>
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	3c 09                	cmp    $0x9,%al
  801505:	74 e5                	je     8014ec <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801507:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	3c 2b                	cmp    $0x2b,%al
  801510:	75 07                	jne    801519 <strtol+0x51>
		s++;
  801512:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801517:	eb 17                	jmp    801530 <strtol+0x68>
	else if (*s == '-')
  801519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151d:	0f b6 00             	movzbl (%rax),%eax
  801520:	3c 2d                	cmp    $0x2d,%al
  801522:	75 0c                	jne    801530 <strtol+0x68>
		s++, neg = 1;
  801524:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801529:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801530:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801534:	74 06                	je     80153c <strtol+0x74>
  801536:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80153a:	75 28                	jne    801564 <strtol+0x9c>
  80153c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801540:	0f b6 00             	movzbl (%rax),%eax
  801543:	3c 30                	cmp    $0x30,%al
  801545:	75 1d                	jne    801564 <strtol+0x9c>
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 83 c0 01          	add    $0x1,%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	3c 78                	cmp    $0x78,%al
  801554:	75 0e                	jne    801564 <strtol+0x9c>
		s += 2, base = 16;
  801556:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80155b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801562:	eb 2c                	jmp    801590 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801564:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801568:	75 19                	jne    801583 <strtol+0xbb>
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	3c 30                	cmp    $0x30,%al
  801573:	75 0e                	jne    801583 <strtol+0xbb>
		s++, base = 8;
  801575:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801581:	eb 0d                	jmp    801590 <strtol+0xc8>
	else if (base == 0)
  801583:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801587:	75 07                	jne    801590 <strtol+0xc8>
		base = 10;
  801589:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	3c 2f                	cmp    $0x2f,%al
  801599:	7e 1d                	jle    8015b8 <strtol+0xf0>
  80159b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	3c 39                	cmp    $0x39,%al
  8015a4:	7f 12                	jg     8015b8 <strtol+0xf0>
			dig = *s - '0';
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	0f be c0             	movsbl %al,%eax
  8015b0:	83 e8 30             	sub    $0x30,%eax
  8015b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015b6:	eb 4e                	jmp    801606 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	0f b6 00             	movzbl (%rax),%eax
  8015bf:	3c 60                	cmp    $0x60,%al
  8015c1:	7e 1d                	jle    8015e0 <strtol+0x118>
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	3c 7a                	cmp    $0x7a,%al
  8015cc:	7f 12                	jg     8015e0 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	0f be c0             	movsbl %al,%eax
  8015d8:	83 e8 57             	sub    $0x57,%eax
  8015db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015de:	eb 26                	jmp    801606 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	0f b6 00             	movzbl (%rax),%eax
  8015e7:	3c 40                	cmp    $0x40,%al
  8015e9:	7e 48                	jle    801633 <strtol+0x16b>
  8015eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	3c 5a                	cmp    $0x5a,%al
  8015f4:	7f 3d                	jg     801633 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	0f be c0             	movsbl %al,%eax
  801600:	83 e8 37             	sub    $0x37,%eax
  801603:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801609:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80160c:	7c 02                	jl     801610 <strtol+0x148>
			break;
  80160e:	eb 23                	jmp    801633 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801610:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801615:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801618:	48 98                	cltq   
  80161a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80161f:	48 89 c2             	mov    %rax,%rdx
  801622:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801625:	48 98                	cltq   
  801627:	48 01 d0             	add    %rdx,%rax
  80162a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80162e:	e9 5d ff ff ff       	jmpq   801590 <strtol+0xc8>

	if (endptr)
  801633:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801638:	74 0b                	je     801645 <strtol+0x17d>
		*endptr = (char *) s;
  80163a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80163e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801642:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801645:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801649:	74 09                	je     801654 <strtol+0x18c>
  80164b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164f:	48 f7 d8             	neg    %rax
  801652:	eb 04                	jmp    801658 <strtol+0x190>
  801654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801658:	c9                   	leaveq 
  801659:	c3                   	retq   

000000000080165a <strstr>:

char * strstr(const char *in, const char *str)
{
  80165a:	55                   	push   %rbp
  80165b:	48 89 e5             	mov    %rsp,%rbp
  80165e:	48 83 ec 30          	sub    $0x30,%rsp
  801662:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801666:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80166a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801672:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801676:	0f b6 00             	movzbl (%rax),%eax
  801679:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80167c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801680:	75 06                	jne    801688 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801686:	eb 6b                	jmp    8016f3 <strstr+0x99>

	len = strlen(str);
  801688:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80168c:	48 89 c7             	mov    %rax,%rdi
  80168f:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  801696:	00 00 00 
  801699:	ff d0                	callq  *%rax
  80169b:	48 98                	cltq   
  80169d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8016b3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016b7:	75 07                	jne    8016c0 <strstr+0x66>
				return (char *) 0;
  8016b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016be:	eb 33                	jmp    8016f3 <strstr+0x99>
		} while (sc != c);
  8016c0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016c4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016c7:	75 d8                	jne    8016a1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016cd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	48 89 ce             	mov    %rcx,%rsi
  8016d8:	48 89 c7             	mov    %rax,%rdi
  8016db:	48 b8 51 11 80 00 00 	movabs $0x801151,%rax
  8016e2:	00 00 00 
  8016e5:	ff d0                	callq  *%rax
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	75 b6                	jne    8016a1 <strstr+0x47>

	return (char *) (in - 1);
  8016eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ef:	48 83 e8 01          	sub    $0x1,%rax
}
  8016f3:	c9                   	leaveq 
  8016f4:	c3                   	retq   

00000000008016f5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016f5:	55                   	push   %rbp
  8016f6:	48 89 e5             	mov    %rsp,%rbp
  8016f9:	53                   	push   %rbx
  8016fa:	48 83 ec 48          	sub    $0x48,%rsp
  8016fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801701:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801704:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801708:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80170c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801710:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801714:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801717:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80171b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80171f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801723:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801727:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80172b:	4c 89 c3             	mov    %r8,%rbx
  80172e:	cd 30                	int    $0x30
  801730:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801734:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801738:	74 3e                	je     801778 <syscall+0x83>
  80173a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80173f:	7e 37                	jle    801778 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801741:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801745:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801748:	49 89 d0             	mov    %rdx,%r8
  80174b:	89 c1                	mov    %eax,%ecx
  80174d:	48 ba 48 46 80 00 00 	movabs $0x804648,%rdx
  801754:	00 00 00 
  801757:	be 23 00 00 00       	mov    $0x23,%esi
  80175c:	48 bf 65 46 80 00 00 	movabs $0x804665,%rdi
  801763:	00 00 00 
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	49 b9 9b 01 80 00 00 	movabs $0x80019b,%r9
  801772:	00 00 00 
  801775:	41 ff d1             	callq  *%r9

	return ret;
  801778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80177c:	48 83 c4 48          	add    $0x48,%rsp
  801780:	5b                   	pop    %rbx
  801781:	5d                   	pop    %rbp
  801782:	c3                   	retq   

0000000000801783 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801783:	55                   	push   %rbp
  801784:	48 89 e5             	mov    %rsp,%rbp
  801787:	48 83 ec 20          	sub    $0x20,%rsp
  80178b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80178f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801797:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80179b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017a2:	00 
  8017a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017af:	48 89 d1             	mov    %rdx,%rcx
  8017b2:	48 89 c2             	mov    %rax,%rdx
  8017b5:	be 00 00 00 00       	mov    $0x0,%esi
  8017ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8017bf:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  8017c6:	00 00 00 
  8017c9:	ff d0                	callq  *%rax
}
  8017cb:	c9                   	leaveq 
  8017cc:	c3                   	retq   

00000000008017cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8017cd:	55                   	push   %rbp
  8017ce:	48 89 e5             	mov    %rsp,%rbp
  8017d1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017dc:	00 
  8017dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f3:	be 00 00 00 00       	mov    $0x0,%esi
  8017f8:	bf 01 00 00 00       	mov    $0x1,%edi
  8017fd:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801804:	00 00 00 
  801807:	ff d0                	callq  *%rax
}
  801809:	c9                   	leaveq 
  80180a:	c3                   	retq   

000000000080180b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80180b:	55                   	push   %rbp
  80180c:	48 89 e5             	mov    %rsp,%rbp
  80180f:	48 83 ec 10          	sub    $0x10,%rsp
  801813:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801816:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801819:	48 98                	cltq   
  80181b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801822:	00 
  801823:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801829:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801834:	48 89 c2             	mov    %rax,%rdx
  801837:	be 01 00 00 00       	mov    $0x1,%esi
  80183c:	bf 03 00 00 00       	mov    $0x3,%edi
  801841:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801857:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185e:	00 
  80185f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801865:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801870:	ba 00 00 00 00       	mov    $0x0,%edx
  801875:	be 00 00 00 00       	mov    $0x0,%esi
  80187a:	bf 02 00 00 00       	mov    $0x2,%edi
  80187f:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801886:	00 00 00 
  801889:	ff d0                	callq  *%rax
}
  80188b:	c9                   	leaveq 
  80188c:	c3                   	retq   

000000000080188d <sys_yield>:

void
sys_yield(void)
{
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801895:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189c:	00 
  80189d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b3:	be 00 00 00 00       	mov    $0x0,%esi
  8018b8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018bd:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  8018c4:	00 00 00 
  8018c7:	ff d0                	callq  *%rax
}
  8018c9:	c9                   	leaveq 
  8018ca:	c3                   	retq   

00000000008018cb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	48 83 ec 20          	sub    $0x20,%rsp
  8018d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018da:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e0:	48 63 c8             	movslq %eax,%rcx
  8018e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ea:	48 98                	cltq   
  8018ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f3:	00 
  8018f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fa:	49 89 c8             	mov    %rcx,%r8
  8018fd:	48 89 d1             	mov    %rdx,%rcx
  801900:	48 89 c2             	mov    %rax,%rdx
  801903:	be 01 00 00 00       	mov    $0x1,%esi
  801908:	bf 04 00 00 00       	mov    $0x4,%edi
  80190d:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801914:	00 00 00 
  801917:	ff d0                	callq  *%rax
}
  801919:	c9                   	leaveq 
  80191a:	c3                   	retq   

000000000080191b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80191b:	55                   	push   %rbp
  80191c:	48 89 e5             	mov    %rsp,%rbp
  80191f:	48 83 ec 30          	sub    $0x30,%rsp
  801923:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801926:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80192a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80192d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801931:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801935:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801938:	48 63 c8             	movslq %eax,%rcx
  80193b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80193f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801942:	48 63 f0             	movslq %eax,%rsi
  801945:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801949:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194c:	48 98                	cltq   
  80194e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801952:	49 89 f9             	mov    %rdi,%r9
  801955:	49 89 f0             	mov    %rsi,%r8
  801958:	48 89 d1             	mov    %rdx,%rcx
  80195b:	48 89 c2             	mov    %rax,%rdx
  80195e:	be 01 00 00 00       	mov    $0x1,%esi
  801963:	bf 05 00 00 00       	mov    $0x5,%edi
  801968:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  80196f:	00 00 00 
  801972:	ff d0                	callq  *%rax
}
  801974:	c9                   	leaveq 
  801975:	c3                   	retq   

0000000000801976 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801976:	55                   	push   %rbp
  801977:	48 89 e5             	mov    %rsp,%rbp
  80197a:	48 83 ec 20          	sub    $0x20,%rsp
  80197e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801981:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801985:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801989:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198c:	48 98                	cltq   
  80198e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801995:	00 
  801996:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a2:	48 89 d1             	mov    %rdx,%rcx
  8019a5:	48 89 c2             	mov    %rax,%rdx
  8019a8:	be 01 00 00 00       	mov    $0x1,%esi
  8019ad:	bf 06 00 00 00       	mov    $0x6,%edi
  8019b2:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  8019b9:	00 00 00 
  8019bc:	ff d0                	callq  *%rax
}
  8019be:	c9                   	leaveq 
  8019bf:	c3                   	retq   

00000000008019c0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019c0:	55                   	push   %rbp
  8019c1:	48 89 e5             	mov    %rsp,%rbp
  8019c4:	48 83 ec 10          	sub    $0x10,%rsp
  8019c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019cb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019d1:	48 63 d0             	movslq %eax,%rdx
  8019d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d7:	48 98                	cltq   
  8019d9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e0:	00 
  8019e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ed:	48 89 d1             	mov    %rdx,%rcx
  8019f0:	48 89 c2             	mov    %rax,%rdx
  8019f3:	be 01 00 00 00       	mov    $0x1,%esi
  8019f8:	bf 08 00 00 00       	mov    $0x8,%edi
  8019fd:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801a04:	00 00 00 
  801a07:	ff d0                	callq  *%rax
}
  801a09:	c9                   	leaveq 
  801a0a:	c3                   	retq   

0000000000801a0b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a0b:	55                   	push   %rbp
  801a0c:	48 89 e5             	mov    %rsp,%rbp
  801a0f:	48 83 ec 20          	sub    $0x20,%rsp
  801a13:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a21:	48 98                	cltq   
  801a23:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2a:	00 
  801a2b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a31:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a37:	48 89 d1             	mov    %rdx,%rcx
  801a3a:	48 89 c2             	mov    %rax,%rdx
  801a3d:	be 01 00 00 00       	mov    $0x1,%esi
  801a42:	bf 09 00 00 00       	mov    $0x9,%edi
  801a47:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801a4e:	00 00 00 
  801a51:	ff d0                	callq  *%rax
}
  801a53:	c9                   	leaveq 
  801a54:	c3                   	retq   

0000000000801a55 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a55:	55                   	push   %rbp
  801a56:	48 89 e5             	mov    %rsp,%rbp
  801a59:	48 83 ec 20          	sub    $0x20,%rsp
  801a5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6b:	48 98                	cltq   
  801a6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a74:	00 
  801a75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a81:	48 89 d1             	mov    %rdx,%rcx
  801a84:	48 89 c2             	mov    %rax,%rdx
  801a87:	be 01 00 00 00       	mov    $0x1,%esi
  801a8c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a91:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801a98:	00 00 00 
  801a9b:	ff d0                	callq  *%rax
}
  801a9d:	c9                   	leaveq 
  801a9e:	c3                   	retq   

0000000000801a9f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a9f:	55                   	push   %rbp
  801aa0:	48 89 e5             	mov    %rsp,%rbp
  801aa3:	48 83 ec 20          	sub    $0x20,%rsp
  801aa7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aaa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ab2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab8:	48 63 f0             	movslq %eax,%rsi
  801abb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801abf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac2:	48 98                	cltq   
  801ac4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acf:	00 
  801ad0:	49 89 f1             	mov    %rsi,%r9
  801ad3:	49 89 c8             	mov    %rcx,%r8
  801ad6:	48 89 d1             	mov    %rdx,%rcx
  801ad9:	48 89 c2             	mov    %rax,%rdx
  801adc:	be 00 00 00 00       	mov    $0x0,%esi
  801ae1:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ae6:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801aed:	00 00 00 
  801af0:	ff d0                	callq  *%rax
}
  801af2:	c9                   	leaveq 
  801af3:	c3                   	retq   

0000000000801af4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801af4:	55                   	push   %rbp
  801af5:	48 89 e5             	mov    %rsp,%rbp
  801af8:	48 83 ec 10          	sub    $0x10,%rsp
  801afc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0b:	00 
  801b0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b1d:	48 89 c2             	mov    %rax,%rdx
  801b20:	be 01 00 00 00       	mov    $0x1,%esi
  801b25:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b2a:	48 b8 f5 16 80 00 00 	movabs $0x8016f5,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 08          	sub    $0x8,%rsp
  801b40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b44:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b48:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b4f:	ff ff ff 
  801b52:	48 01 d0             	add    %rdx,%rax
  801b55:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b59:	c9                   	leaveq 
  801b5a:	c3                   	retq   

0000000000801b5b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	48 83 ec 08          	sub    $0x8,%rsp
  801b63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6b:	48 89 c7             	mov    %rax,%rdi
  801b6e:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801b75:	00 00 00 
  801b78:	ff d0                	callq  *%rax
  801b7a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b80:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b84:	c9                   	leaveq 
  801b85:	c3                   	retq   

0000000000801b86 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b86:	55                   	push   %rbp
  801b87:	48 89 e5             	mov    %rsp,%rbp
  801b8a:	48 83 ec 18          	sub    $0x18,%rsp
  801b8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b99:	eb 6b                	jmp    801c06 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9e:	48 98                	cltq   
  801ba0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ba6:	48 c1 e0 0c          	shl    $0xc,%rax
  801baa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb2:	48 c1 e8 15          	shr    $0x15,%rax
  801bb6:	48 89 c2             	mov    %rax,%rdx
  801bb9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bc0:	01 00 00 
  801bc3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bc7:	83 e0 01             	and    $0x1,%eax
  801bca:	48 85 c0             	test   %rax,%rax
  801bcd:	74 21                	je     801bf0 <fd_alloc+0x6a>
  801bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd3:	48 c1 e8 0c          	shr    $0xc,%rax
  801bd7:	48 89 c2             	mov    %rax,%rdx
  801bda:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801be1:	01 00 00 
  801be4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801be8:	83 e0 01             	and    $0x1,%eax
  801beb:	48 85 c0             	test   %rax,%rax
  801bee:	75 12                	jne    801c02 <fd_alloc+0x7c>
			*fd_store = fd;
  801bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801c00:	eb 1a                	jmp    801c1c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c02:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c06:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801c0a:	7e 8f                	jle    801b9b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c10:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c17:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c1c:	c9                   	leaveq 
  801c1d:	c3                   	retq   

0000000000801c1e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c1e:	55                   	push   %rbp
  801c1f:	48 89 e5             	mov    %rsp,%rbp
  801c22:	48 83 ec 20          	sub    $0x20,%rsp
  801c26:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c29:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c31:	78 06                	js     801c39 <fd_lookup+0x1b>
  801c33:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c37:	7e 07                	jle    801c40 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c3e:	eb 6c                	jmp    801cac <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c43:	48 98                	cltq   
  801c45:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c4b:	48 c1 e0 0c          	shl    $0xc,%rax
  801c4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c57:	48 c1 e8 15          	shr    $0x15,%rax
  801c5b:	48 89 c2             	mov    %rax,%rdx
  801c5e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c65:	01 00 00 
  801c68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c6c:	83 e0 01             	and    $0x1,%eax
  801c6f:	48 85 c0             	test   %rax,%rax
  801c72:	74 21                	je     801c95 <fd_lookup+0x77>
  801c74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c78:	48 c1 e8 0c          	shr    $0xc,%rax
  801c7c:	48 89 c2             	mov    %rax,%rdx
  801c7f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c86:	01 00 00 
  801c89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c8d:	83 e0 01             	and    $0x1,%eax
  801c90:	48 85 c0             	test   %rax,%rax
  801c93:	75 07                	jne    801c9c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c9a:	eb 10                	jmp    801cac <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ca4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cac:	c9                   	leaveq 
  801cad:	c3                   	retq   

0000000000801cae <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801cae:	55                   	push   %rbp
  801caf:	48 89 e5             	mov    %rsp,%rbp
  801cb2:	48 83 ec 30          	sub    $0x30,%rsp
  801cb6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801cba:	89 f0                	mov    %esi,%eax
  801cbc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc3:	48 89 c7             	mov    %rax,%rdi
  801cc6:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801ccd:	00 00 00 
  801cd0:	ff d0                	callq  *%rax
  801cd2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cd6:	48 89 d6             	mov    %rdx,%rsi
  801cd9:	89 c7                	mov    %eax,%edi
  801cdb:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  801ce2:	00 00 00 
  801ce5:	ff d0                	callq  *%rax
  801ce7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cee:	78 0a                	js     801cfa <fd_close+0x4c>
	    || fd != fd2)
  801cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801cf8:	74 12                	je     801d0c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801cfa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801cfe:	74 05                	je     801d05 <fd_close+0x57>
  801d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d03:	eb 05                	jmp    801d0a <fd_close+0x5c>
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	eb 69                	jmp    801d75 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d10:	8b 00                	mov    (%rax),%eax
  801d12:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d16:	48 89 d6             	mov    %rdx,%rsi
  801d19:	89 c7                	mov    %eax,%edi
  801d1b:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  801d22:	00 00 00 
  801d25:	ff d0                	callq  *%rax
  801d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d2e:	78 2a                	js     801d5a <fd_close+0xac>
		if (dev->dev_close)
  801d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d34:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d38:	48 85 c0             	test   %rax,%rax
  801d3b:	74 16                	je     801d53 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d41:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d45:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d49:	48 89 d7             	mov    %rdx,%rdi
  801d4c:	ff d0                	callq  *%rax
  801d4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d51:	eb 07                	jmp    801d5a <fd_close+0xac>
		else
			r = 0;
  801d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d5e:	48 89 c6             	mov    %rax,%rsi
  801d61:	bf 00 00 00 00       	mov    $0x0,%edi
  801d66:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  801d6d:	00 00 00 
  801d70:	ff d0                	callq  *%rax
	return r;
  801d72:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d75:	c9                   	leaveq 
  801d76:	c3                   	retq   

0000000000801d77 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d77:	55                   	push   %rbp
  801d78:	48 89 e5             	mov    %rsp,%rbp
  801d7b:	48 83 ec 20          	sub    $0x20,%rsp
  801d7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d8d:	eb 41                	jmp    801dd0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d8f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d96:	00 00 00 
  801d99:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d9c:	48 63 d2             	movslq %edx,%rdx
  801d9f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da3:	8b 00                	mov    (%rax),%eax
  801da5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801da8:	75 22                	jne    801dcc <dev_lookup+0x55>
			*dev = devtab[i];
  801daa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801db1:	00 00 00 
  801db4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801db7:	48 63 d2             	movslq %edx,%rdx
  801dba:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801dbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dc2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dca:	eb 60                	jmp    801e2c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801dcc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dd0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801dd7:	00 00 00 
  801dda:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ddd:	48 63 d2             	movslq %edx,%rdx
  801de0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de4:	48 85 c0             	test   %rax,%rax
  801de7:	75 a6                	jne    801d8f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801de9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801df0:	00 00 00 
  801df3:	48 8b 00             	mov    (%rax),%rax
  801df6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801dfc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dff:	89 c6                	mov    %eax,%esi
  801e01:	48 bf 78 46 80 00 00 	movabs $0x804678,%rdi
  801e08:	00 00 00 
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e10:	48 b9 d4 03 80 00 00 	movabs $0x8003d4,%rcx
  801e17:	00 00 00 
  801e1a:	ff d1                	callq  *%rcx
	*dev = 0;
  801e1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e20:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e2c:	c9                   	leaveq 
  801e2d:	c3                   	retq   

0000000000801e2e <close>:

int
close(int fdnum)
{
  801e2e:	55                   	push   %rbp
  801e2f:	48 89 e5             	mov    %rsp,%rbp
  801e32:	48 83 ec 20          	sub    $0x20,%rsp
  801e36:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e39:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e40:	48 89 d6             	mov    %rdx,%rsi
  801e43:	89 c7                	mov    %eax,%edi
  801e45:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  801e4c:	00 00 00 
  801e4f:	ff d0                	callq  *%rax
  801e51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e58:	79 05                	jns    801e5f <close+0x31>
		return r;
  801e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5d:	eb 18                	jmp    801e77 <close+0x49>
	else
		return fd_close(fd, 1);
  801e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e63:	be 01 00 00 00       	mov    $0x1,%esi
  801e68:	48 89 c7             	mov    %rax,%rdi
  801e6b:	48 b8 ae 1c 80 00 00 	movabs $0x801cae,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	callq  *%rax
}
  801e77:	c9                   	leaveq 
  801e78:	c3                   	retq   

0000000000801e79 <close_all>:

void
close_all(void)
{
  801e79:	55                   	push   %rbp
  801e7a:	48 89 e5             	mov    %rsp,%rbp
  801e7d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e88:	eb 15                	jmp    801e9f <close_all+0x26>
		close(i);
  801e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8d:	89 c7                	mov    %eax,%edi
  801e8f:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  801e96:	00 00 00 
  801e99:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e9b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e9f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ea3:	7e e5                	jle    801e8a <close_all+0x11>
		close(i);
}
  801ea5:	c9                   	leaveq 
  801ea6:	c3                   	retq   

0000000000801ea7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ea7:	55                   	push   %rbp
  801ea8:	48 89 e5             	mov    %rsp,%rbp
  801eab:	48 83 ec 40          	sub    $0x40,%rsp
  801eaf:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801eb2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801eb5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801eb9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ebc:	48 89 d6             	mov    %rdx,%rsi
  801ebf:	89 c7                	mov    %eax,%edi
  801ec1:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	callq  *%rax
  801ecd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ed0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ed4:	79 08                	jns    801ede <dup+0x37>
		return r;
  801ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed9:	e9 70 01 00 00       	jmpq   80204e <dup+0x1a7>
	close(newfdnum);
  801ede:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ee1:	89 c7                	mov    %eax,%edi
  801ee3:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801eef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ef2:	48 98                	cltq   
  801ef4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801efa:	48 c1 e0 0c          	shl    $0xc,%rax
  801efe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801f02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f06:	48 89 c7             	mov    %rax,%rdi
  801f09:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	callq  *%rax
  801f15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f1d:	48 89 c7             	mov    %rax,%rdi
  801f20:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  801f27:	00 00 00 
  801f2a:	ff d0                	callq  *%rax
  801f2c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f34:	48 c1 e8 15          	shr    $0x15,%rax
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f42:	01 00 00 
  801f45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f49:	83 e0 01             	and    $0x1,%eax
  801f4c:	48 85 c0             	test   %rax,%rax
  801f4f:	74 73                	je     801fc4 <dup+0x11d>
  801f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f55:	48 c1 e8 0c          	shr    $0xc,%rax
  801f59:	48 89 c2             	mov    %rax,%rdx
  801f5c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f63:	01 00 00 
  801f66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f6a:	83 e0 01             	and    $0x1,%eax
  801f6d:	48 85 c0             	test   %rax,%rax
  801f70:	74 52                	je     801fc4 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f76:	48 c1 e8 0c          	shr    $0xc,%rax
  801f7a:	48 89 c2             	mov    %rax,%rdx
  801f7d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f84:	01 00 00 
  801f87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f8b:	25 07 0e 00 00       	and    $0xe07,%eax
  801f90:	89 c1                	mov    %eax,%ecx
  801f92:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f9a:	41 89 c8             	mov    %ecx,%r8d
  801f9d:	48 89 d1             	mov    %rdx,%rcx
  801fa0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa5:	48 89 c6             	mov    %rax,%rsi
  801fa8:	bf 00 00 00 00       	mov    $0x0,%edi
  801fad:	48 b8 1b 19 80 00 00 	movabs $0x80191b,%rax
  801fb4:	00 00 00 
  801fb7:	ff d0                	callq  *%rax
  801fb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc0:	79 02                	jns    801fc4 <dup+0x11d>
			goto err;
  801fc2:	eb 57                	jmp    80201b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc8:	48 c1 e8 0c          	shr    $0xc,%rax
  801fcc:	48 89 c2             	mov    %rax,%rdx
  801fcf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fd6:	01 00 00 
  801fd9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fdd:	25 07 0e 00 00       	and    $0xe07,%eax
  801fe2:	89 c1                	mov    %eax,%ecx
  801fe4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fec:	41 89 c8             	mov    %ecx,%r8d
  801fef:	48 89 d1             	mov    %rdx,%rcx
  801ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff7:	48 89 c6             	mov    %rax,%rsi
  801ffa:	bf 00 00 00 00       	mov    $0x0,%edi
  801fff:	48 b8 1b 19 80 00 00 	movabs $0x80191b,%rax
  802006:	00 00 00 
  802009:	ff d0                	callq  *%rax
  80200b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80200e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802012:	79 02                	jns    802016 <dup+0x16f>
		goto err;
  802014:	eb 05                	jmp    80201b <dup+0x174>

	return newfdnum;
  802016:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802019:	eb 33                	jmp    80204e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80201b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201f:	48 89 c6             	mov    %rax,%rsi
  802022:	bf 00 00 00 00       	mov    $0x0,%edi
  802027:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  80202e:	00 00 00 
  802031:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802033:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802037:	48 89 c6             	mov    %rax,%rsi
  80203a:	bf 00 00 00 00       	mov    $0x0,%edi
  80203f:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  802046:	00 00 00 
  802049:	ff d0                	callq  *%rax
	return r;
  80204b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80204e:	c9                   	leaveq 
  80204f:	c3                   	retq   

0000000000802050 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802050:	55                   	push   %rbp
  802051:	48 89 e5             	mov    %rsp,%rbp
  802054:	48 83 ec 40          	sub    $0x40,%rsp
  802058:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80205b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80205f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802063:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802067:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80206a:	48 89 d6             	mov    %rdx,%rsi
  80206d:	89 c7                	mov    %eax,%edi
  80206f:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  802076:	00 00 00 
  802079:	ff d0                	callq  *%rax
  80207b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802082:	78 24                	js     8020a8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802088:	8b 00                	mov    (%rax),%eax
  80208a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80208e:	48 89 d6             	mov    %rdx,%rsi
  802091:	89 c7                	mov    %eax,%edi
  802093:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  80209a:	00 00 00 
  80209d:	ff d0                	callq  *%rax
  80209f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a6:	79 05                	jns    8020ad <read+0x5d>
		return r;
  8020a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ab:	eb 76                	jmp    802123 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b1:	8b 40 08             	mov    0x8(%rax),%eax
  8020b4:	83 e0 03             	and    $0x3,%eax
  8020b7:	83 f8 01             	cmp    $0x1,%eax
  8020ba:	75 3a                	jne    8020f6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020c3:	00 00 00 
  8020c6:	48 8b 00             	mov    (%rax),%rax
  8020c9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020cf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020d2:	89 c6                	mov    %eax,%esi
  8020d4:	48 bf 97 46 80 00 00 	movabs $0x804697,%rdi
  8020db:	00 00 00 
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e3:	48 b9 d4 03 80 00 00 	movabs $0x8003d4,%rcx
  8020ea:	00 00 00 
  8020ed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020f4:	eb 2d                	jmp    802123 <read+0xd3>
	}
	if (!dev->dev_read)
  8020f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020fe:	48 85 c0             	test   %rax,%rax
  802101:	75 07                	jne    80210a <read+0xba>
		return -E_NOT_SUPP;
  802103:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802108:	eb 19                	jmp    802123 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80210a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802112:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802116:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80211a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80211e:	48 89 cf             	mov    %rcx,%rdi
  802121:	ff d0                	callq  *%rax
}
  802123:	c9                   	leaveq 
  802124:	c3                   	retq   

0000000000802125 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802125:	55                   	push   %rbp
  802126:	48 89 e5             	mov    %rsp,%rbp
  802129:	48 83 ec 30          	sub    $0x30,%rsp
  80212d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802130:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802134:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80213f:	eb 49                	jmp    80218a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802144:	48 98                	cltq   
  802146:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80214a:	48 29 c2             	sub    %rax,%rdx
  80214d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802150:	48 63 c8             	movslq %eax,%rcx
  802153:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802157:	48 01 c1             	add    %rax,%rcx
  80215a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80215d:	48 89 ce             	mov    %rcx,%rsi
  802160:	89 c7                	mov    %eax,%edi
  802162:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  802169:	00 00 00 
  80216c:	ff d0                	callq  *%rax
  80216e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802171:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802175:	79 05                	jns    80217c <readn+0x57>
			return m;
  802177:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80217a:	eb 1c                	jmp    802198 <readn+0x73>
		if (m == 0)
  80217c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802180:	75 02                	jne    802184 <readn+0x5f>
			break;
  802182:	eb 11                	jmp    802195 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802184:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802187:	01 45 fc             	add    %eax,-0x4(%rbp)
  80218a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218d:	48 98                	cltq   
  80218f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802193:	72 ac                	jb     802141 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802195:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802198:	c9                   	leaveq 
  802199:	c3                   	retq   

000000000080219a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80219a:	55                   	push   %rbp
  80219b:	48 89 e5             	mov    %rsp,%rbp
  80219e:	48 83 ec 40          	sub    $0x40,%rsp
  8021a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021a9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021b4:	48 89 d6             	mov    %rdx,%rsi
  8021b7:	89 c7                	mov    %eax,%edi
  8021b9:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
  8021c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cc:	78 24                	js     8021f2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d2:	8b 00                	mov    (%rax),%eax
  8021d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021d8:	48 89 d6             	mov    %rdx,%rsi
  8021db:	89 c7                	mov    %eax,%edi
  8021dd:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
  8021e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f0:	79 05                	jns    8021f7 <write+0x5d>
		return r;
  8021f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f5:	eb 75                	jmp    80226c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fb:	8b 40 08             	mov    0x8(%rax),%eax
  8021fe:	83 e0 03             	and    $0x3,%eax
  802201:	85 c0                	test   %eax,%eax
  802203:	75 3a                	jne    80223f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802205:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80220c:	00 00 00 
  80220f:	48 8b 00             	mov    (%rax),%rax
  802212:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802218:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80221b:	89 c6                	mov    %eax,%esi
  80221d:	48 bf b3 46 80 00 00 	movabs $0x8046b3,%rdi
  802224:	00 00 00 
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
  80222c:	48 b9 d4 03 80 00 00 	movabs $0x8003d4,%rcx
  802233:	00 00 00 
  802236:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223d:	eb 2d                	jmp    80226c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80223f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802243:	48 8b 40 18          	mov    0x18(%rax),%rax
  802247:	48 85 c0             	test   %rax,%rax
  80224a:	75 07                	jne    802253 <write+0xb9>
		return -E_NOT_SUPP;
  80224c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802251:	eb 19                	jmp    80226c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802257:	48 8b 40 18          	mov    0x18(%rax),%rax
  80225b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80225f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802263:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802267:	48 89 cf             	mov    %rcx,%rdi
  80226a:	ff d0                	callq  *%rax
}
  80226c:	c9                   	leaveq 
  80226d:	c3                   	retq   

000000000080226e <seek>:

int
seek(int fdnum, off_t offset)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 18          	sub    $0x18,%rsp
  802276:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802279:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80227c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802280:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802283:	48 89 d6             	mov    %rdx,%rsi
  802286:	89 c7                	mov    %eax,%edi
  802288:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  80228f:	00 00 00 
  802292:	ff d0                	callq  *%rax
  802294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229b:	79 05                	jns    8022a2 <seek+0x34>
		return r;
  80229d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a0:	eb 0f                	jmp    8022b1 <seek+0x43>
	fd->fd_offset = offset;
  8022a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022a9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b1:	c9                   	leaveq 
  8022b2:	c3                   	retq   

00000000008022b3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022b3:	55                   	push   %rbp
  8022b4:	48 89 e5             	mov    %rsp,%rbp
  8022b7:	48 83 ec 30          	sub    $0x30,%rsp
  8022bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022be:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c8:	48 89 d6             	mov    %rdx,%rsi
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
  8022d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e0:	78 24                	js     802306 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e6:	8b 00                	mov    (%rax),%eax
  8022e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ec:	48 89 d6             	mov    %rdx,%rsi
  8022ef:	89 c7                	mov    %eax,%edi
  8022f1:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  8022f8:	00 00 00 
  8022fb:	ff d0                	callq  *%rax
  8022fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802300:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802304:	79 05                	jns    80230b <ftruncate+0x58>
		return r;
  802306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802309:	eb 72                	jmp    80237d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80230b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230f:	8b 40 08             	mov    0x8(%rax),%eax
  802312:	83 e0 03             	and    $0x3,%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	75 3a                	jne    802353 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802319:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802320:	00 00 00 
  802323:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802326:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80232c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80232f:	89 c6                	mov    %eax,%esi
  802331:	48 bf d0 46 80 00 00 	movabs $0x8046d0,%rdi
  802338:	00 00 00 
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	48 b9 d4 03 80 00 00 	movabs $0x8003d4,%rcx
  802347:	00 00 00 
  80234a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80234c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802351:	eb 2a                	jmp    80237d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802357:	48 8b 40 30          	mov    0x30(%rax),%rax
  80235b:	48 85 c0             	test   %rax,%rax
  80235e:	75 07                	jne    802367 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802360:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802365:	eb 16                	jmp    80237d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80236f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802373:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802376:	89 ce                	mov    %ecx,%esi
  802378:	48 89 d7             	mov    %rdx,%rdi
  80237b:	ff d0                	callq  *%rax
}
  80237d:	c9                   	leaveq 
  80237e:	c3                   	retq   

000000000080237f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80237f:	55                   	push   %rbp
  802380:	48 89 e5             	mov    %rsp,%rbp
  802383:	48 83 ec 30          	sub    $0x30,%rsp
  802387:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80238a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802392:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802395:	48 89 d6             	mov    %rdx,%rsi
  802398:	89 c7                	mov    %eax,%edi
  80239a:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  8023a1:	00 00 00 
  8023a4:	ff d0                	callq  *%rax
  8023a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ad:	78 24                	js     8023d3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b3:	8b 00                	mov    (%rax),%eax
  8023b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b9:	48 89 d6             	mov    %rdx,%rsi
  8023bc:	89 c7                	mov    %eax,%edi
  8023be:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax
  8023ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d1:	79 05                	jns    8023d8 <fstat+0x59>
		return r;
  8023d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d6:	eb 5e                	jmp    802436 <fstat+0xb7>
	if (!dev->dev_stat)
  8023d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023dc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023e0:	48 85 c0             	test   %rax,%rax
  8023e3:	75 07                	jne    8023ec <fstat+0x6d>
		return -E_NOT_SUPP;
  8023e5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023ea:	eb 4a                	jmp    802436 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023fe:	00 00 00 
	stat->st_isdir = 0;
  802401:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802405:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80240c:	00 00 00 
	stat->st_dev = dev;
  80240f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802413:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802417:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80241e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802422:	48 8b 40 28          	mov    0x28(%rax),%rax
  802426:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80242a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80242e:	48 89 ce             	mov    %rcx,%rsi
  802431:	48 89 d7             	mov    %rdx,%rdi
  802434:	ff d0                	callq  *%rax
}
  802436:	c9                   	leaveq 
  802437:	c3                   	retq   

0000000000802438 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802438:	55                   	push   %rbp
  802439:	48 89 e5             	mov    %rsp,%rbp
  80243c:	48 83 ec 20          	sub    $0x20,%rsp
  802440:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802444:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244c:	be 00 00 00 00       	mov    $0x0,%esi
  802451:	48 89 c7             	mov    %rax,%rdi
  802454:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  80245b:	00 00 00 
  80245e:	ff d0                	callq  *%rax
  802460:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802463:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802467:	79 05                	jns    80246e <stat+0x36>
		return fd;
  802469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246c:	eb 2f                	jmp    80249d <stat+0x65>
	r = fstat(fd, stat);
  80246e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802475:	48 89 d6             	mov    %rdx,%rsi
  802478:	89 c7                	mov    %eax,%edi
  80247a:	48 b8 7f 23 80 00 00 	movabs $0x80237f,%rax
  802481:	00 00 00 
  802484:	ff d0                	callq  *%rax
  802486:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802489:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248c:	89 c7                	mov    %eax,%edi
  80248e:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
	return r;
  80249a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80249d:	c9                   	leaveq 
  80249e:	c3                   	retq   

000000000080249f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80249f:	55                   	push   %rbp
  8024a0:	48 89 e5             	mov    %rsp,%rbp
  8024a3:	48 83 ec 10          	sub    $0x10,%rsp
  8024a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8024ae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024b5:	00 00 00 
  8024b8:	8b 00                	mov    (%rax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	75 1d                	jne    8024db <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024be:	bf 01 00 00 00       	mov    $0x1,%edi
  8024c3:	48 b8 c0 3f 80 00 00 	movabs $0x803fc0,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	callq  *%rax
  8024cf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8024d6:	00 00 00 
  8024d9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024db:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024e2:	00 00 00 
  8024e5:	8b 00                	mov    (%rax),%eax
  8024e7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024ea:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024ef:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8024f6:	00 00 00 
  8024f9:	89 c7                	mov    %eax,%edi
  8024fb:	48 b8 28 3f 80 00 00 	movabs $0x803f28,%rax
  802502:	00 00 00 
  802505:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250b:	ba 00 00 00 00       	mov    $0x0,%edx
  802510:	48 89 c6             	mov    %rax,%rsi
  802513:	bf 00 00 00 00       	mov    $0x0,%edi
  802518:	48 b8 67 3e 80 00 00 	movabs $0x803e67,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax
}
  802524:	c9                   	leaveq 
  802525:	c3                   	retq   

0000000000802526 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802526:	55                   	push   %rbp
  802527:	48 89 e5             	mov    %rsp,%rbp
  80252a:	48 83 ec 20          	sub    $0x20,%rsp
  80252e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802532:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802539:	48 89 c7             	mov    %rax,%rdi
  80253c:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  802543:	00 00 00 
  802546:	ff d0                	callq  *%rax
  802548:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80254d:	7e 0a                	jle    802559 <open+0x33>
		return -E_BAD_PATH;
  80254f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802554:	e9 a5 00 00 00       	jmpq   8025fe <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802559:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80255d:	48 89 c7             	mov    %rax,%rdi
  802560:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  802567:	00 00 00 
  80256a:	ff d0                	callq  *%rax
  80256c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802573:	79 08                	jns    80257d <open+0x57>
		return r;
  802575:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802578:	e9 81 00 00 00       	jmpq   8025fe <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80257d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802581:	48 89 c6             	mov    %rax,%rsi
  802584:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80258b:	00 00 00 
  80258e:	48 b8 9c 0f 80 00 00 	movabs $0x800f9c,%rax
  802595:	00 00 00 
  802598:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80259a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025a1:	00 00 00 
  8025a4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8025a7:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b1:	48 89 c6             	mov    %rax,%rsi
  8025b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8025b9:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
  8025c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025cc:	79 1d                	jns    8025eb <open+0xc5>
		fd_close(fd, 0);
  8025ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d2:	be 00 00 00 00       	mov    $0x0,%esi
  8025d7:	48 89 c7             	mov    %rax,%rdi
  8025da:	48 b8 ae 1c 80 00 00 	movabs $0x801cae,%rax
  8025e1:	00 00 00 
  8025e4:	ff d0                	callq  *%rax
		return r;
  8025e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e9:	eb 13                	jmp    8025fe <open+0xd8>
	}

	return fd2num(fd);
  8025eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ef:	48 89 c7             	mov    %rax,%rdi
  8025f2:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  8025f9:	00 00 00 
  8025fc:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8025fe:	c9                   	leaveq 
  8025ff:	c3                   	retq   

0000000000802600 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802600:	55                   	push   %rbp
  802601:	48 89 e5             	mov    %rsp,%rbp
  802604:	48 83 ec 10          	sub    $0x10,%rsp
  802608:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80260c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802610:	8b 50 0c             	mov    0xc(%rax),%edx
  802613:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80261a:	00 00 00 
  80261d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80261f:	be 00 00 00 00       	mov    $0x0,%esi
  802624:	bf 06 00 00 00       	mov    $0x6,%edi
  802629:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802630:	00 00 00 
  802633:	ff d0                	callq  *%rax
}
  802635:	c9                   	leaveq 
  802636:	c3                   	retq   

0000000000802637 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802637:	55                   	push   %rbp
  802638:	48 89 e5             	mov    %rsp,%rbp
  80263b:	48 83 ec 30          	sub    $0x30,%rsp
  80263f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802643:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802647:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80264b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264f:	8b 50 0c             	mov    0xc(%rax),%edx
  802652:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802659:	00 00 00 
  80265c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80265e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802665:	00 00 00 
  802668:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80266c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802670:	be 00 00 00 00       	mov    $0x0,%esi
  802675:	bf 03 00 00 00       	mov    $0x3,%edi
  80267a:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802681:	00 00 00 
  802684:	ff d0                	callq  *%rax
  802686:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802689:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268d:	79 08                	jns    802697 <devfile_read+0x60>
		return r;
  80268f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802692:	e9 a4 00 00 00       	jmpq   80273b <devfile_read+0x104>
	assert(r <= n);
  802697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269a:	48 98                	cltq   
  80269c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8026a0:	76 35                	jbe    8026d7 <devfile_read+0xa0>
  8026a2:	48 b9 fd 46 80 00 00 	movabs $0x8046fd,%rcx
  8026a9:	00 00 00 
  8026ac:	48 ba 04 47 80 00 00 	movabs $0x804704,%rdx
  8026b3:	00 00 00 
  8026b6:	be 84 00 00 00       	mov    $0x84,%esi
  8026bb:	48 bf 19 47 80 00 00 	movabs $0x804719,%rdi
  8026c2:	00 00 00 
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  8026d1:	00 00 00 
  8026d4:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8026d7:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8026de:	7e 35                	jle    802715 <devfile_read+0xde>
  8026e0:	48 b9 24 47 80 00 00 	movabs $0x804724,%rcx
  8026e7:	00 00 00 
  8026ea:	48 ba 04 47 80 00 00 	movabs $0x804704,%rdx
  8026f1:	00 00 00 
  8026f4:	be 85 00 00 00       	mov    $0x85,%esi
  8026f9:	48 bf 19 47 80 00 00 	movabs $0x804719,%rdi
  802700:	00 00 00 
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
  802708:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  80270f:	00 00 00 
  802712:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802718:	48 63 d0             	movslq %eax,%rdx
  80271b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80271f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802726:	00 00 00 
  802729:	48 89 c7             	mov    %rax,%rdi
  80272c:	48 b8 c0 12 80 00 00 	movabs $0x8012c0,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
	return r;
  802738:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80273b:	c9                   	leaveq 
  80273c:	c3                   	retq   

000000000080273d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80273d:	55                   	push   %rbp
  80273e:	48 89 e5             	mov    %rsp,%rbp
  802741:	48 83 ec 30          	sub    $0x30,%rsp
  802745:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802749:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80274d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802755:	8b 50 0c             	mov    0xc(%rax),%edx
  802758:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80275f:	00 00 00 
  802762:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802764:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80276b:	00 00 00 
  80276e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802772:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802776:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80277d:	00 
  80277e:	76 35                	jbe    8027b5 <devfile_write+0x78>
  802780:	48 b9 30 47 80 00 00 	movabs $0x804730,%rcx
  802787:	00 00 00 
  80278a:	48 ba 04 47 80 00 00 	movabs $0x804704,%rdx
  802791:	00 00 00 
  802794:	be 9e 00 00 00       	mov    $0x9e,%esi
  802799:	48 bf 19 47 80 00 00 	movabs $0x804719,%rdi
  8027a0:	00 00 00 
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  8027af:	00 00 00 
  8027b2:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8027b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027bd:	48 89 c6             	mov    %rax,%rsi
  8027c0:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8027c7:	00 00 00 
  8027ca:	48 b8 d7 13 80 00 00 	movabs $0x8013d7,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8027d6:	be 00 00 00 00       	mov    $0x0,%esi
  8027db:	bf 04 00 00 00       	mov    $0x4,%edi
  8027e0:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	callq  *%rax
  8027ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f3:	79 05                	jns    8027fa <devfile_write+0xbd>
		return r;
  8027f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f8:	eb 43                	jmp    80283d <devfile_write+0x100>
	assert(r <= n);
  8027fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fd:	48 98                	cltq   
  8027ff:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802803:	76 35                	jbe    80283a <devfile_write+0xfd>
  802805:	48 b9 fd 46 80 00 00 	movabs $0x8046fd,%rcx
  80280c:	00 00 00 
  80280f:	48 ba 04 47 80 00 00 	movabs $0x804704,%rdx
  802816:	00 00 00 
  802819:	be a2 00 00 00       	mov    $0xa2,%esi
  80281e:	48 bf 19 47 80 00 00 	movabs $0x804719,%rdi
  802825:	00 00 00 
  802828:	b8 00 00 00 00       	mov    $0x0,%eax
  80282d:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  802834:	00 00 00 
  802837:	41 ff d0             	callq  *%r8
	return r;
  80283a:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80283d:	c9                   	leaveq 
  80283e:	c3                   	retq   

000000000080283f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80283f:	55                   	push   %rbp
  802840:	48 89 e5             	mov    %rsp,%rbp
  802843:	48 83 ec 20          	sub    $0x20,%rsp
  802847:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80284b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80284f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802853:	8b 50 0c             	mov    0xc(%rax),%edx
  802856:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80285d:	00 00 00 
  802860:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802862:	be 00 00 00 00       	mov    $0x0,%esi
  802867:	bf 05 00 00 00       	mov    $0x5,%edi
  80286c:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802873:	00 00 00 
  802876:	ff d0                	callq  *%rax
  802878:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287f:	79 05                	jns    802886 <devfile_stat+0x47>
		return r;
  802881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802884:	eb 56                	jmp    8028dc <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802886:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80288a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802891:	00 00 00 
  802894:	48 89 c7             	mov    %rax,%rdi
  802897:	48 b8 9c 0f 80 00 00 	movabs $0x800f9c,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8028a3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028aa:	00 00 00 
  8028ad:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8028b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8028bd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028c4:	00 00 00 
  8028c7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8028cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8028d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028dc:	c9                   	leaveq 
  8028dd:	c3                   	retq   

00000000008028de <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028de:	55                   	push   %rbp
  8028df:	48 89 e5             	mov    %rsp,%rbp
  8028e2:	48 83 ec 10          	sub    $0x10,%rsp
  8028e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028ea:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028f1:	8b 50 0c             	mov    0xc(%rax),%edx
  8028f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028fb:	00 00 00 
  8028fe:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802900:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802907:	00 00 00 
  80290a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80290d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802910:	be 00 00 00 00       	mov    $0x0,%esi
  802915:	bf 02 00 00 00       	mov    $0x2,%edi
  80291a:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802921:	00 00 00 
  802924:	ff d0                	callq  *%rax
}
  802926:	c9                   	leaveq 
  802927:	c3                   	retq   

0000000000802928 <remove>:

// Delete a file
int
remove(const char *path)
{
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	48 83 ec 10          	sub    $0x10,%rsp
  802930:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802938:	48 89 c7             	mov    %rax,%rdi
  80293b:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
  802947:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80294c:	7e 07                	jle    802955 <remove+0x2d>
		return -E_BAD_PATH;
  80294e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802953:	eb 33                	jmp    802988 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802955:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802959:	48 89 c6             	mov    %rax,%rsi
  80295c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802963:	00 00 00 
  802966:	48 b8 9c 0f 80 00 00 	movabs $0x800f9c,%rax
  80296d:	00 00 00 
  802970:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802972:	be 00 00 00 00       	mov    $0x0,%esi
  802977:	bf 07 00 00 00       	mov    $0x7,%edi
  80297c:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  802983:	00 00 00 
  802986:	ff d0                	callq  *%rax
}
  802988:	c9                   	leaveq 
  802989:	c3                   	retq   

000000000080298a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80298a:	55                   	push   %rbp
  80298b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80298e:	be 00 00 00 00       	mov    $0x0,%esi
  802993:	bf 08 00 00 00       	mov    $0x8,%edi
  802998:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
}
  8029a4:	5d                   	pop    %rbp
  8029a5:	c3                   	retq   

00000000008029a6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
  8029aa:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8029b1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8029b8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8029bf:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8029c6:	be 00 00 00 00       	mov    $0x0,%esi
  8029cb:	48 89 c7             	mov    %rax,%rdi
  8029ce:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
  8029da:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8029dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e1:	79 28                	jns    802a0b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e6:	89 c6                	mov    %eax,%esi
  8029e8:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  8029ef:	00 00 00 
  8029f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f7:	48 ba d4 03 80 00 00 	movabs $0x8003d4,%rdx
  8029fe:	00 00 00 
  802a01:	ff d2                	callq  *%rdx
		return fd_src;
  802a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a06:	e9 74 01 00 00       	jmpq   802b7f <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a0b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a12:	be 01 01 00 00       	mov    $0x101,%esi
  802a17:	48 89 c7             	mov    %rax,%rdi
  802a1a:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
  802a26:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a29:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a2d:	79 39                	jns    802a68 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a32:	89 c6                	mov    %eax,%esi
  802a34:	48 bf 73 47 80 00 00 	movabs $0x804773,%rdi
  802a3b:	00 00 00 
  802a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a43:	48 ba d4 03 80 00 00 	movabs $0x8003d4,%rdx
  802a4a:	00 00 00 
  802a4d:	ff d2                	callq  *%rdx
		close(fd_src);
  802a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a52:	89 c7                	mov    %eax,%edi
  802a54:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
		return fd_dest;
  802a60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a63:	e9 17 01 00 00       	jmpq   802b7f <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a68:	eb 74                	jmp    802ade <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802a6a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a6d:	48 63 d0             	movslq %eax,%rdx
  802a70:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a7a:	48 89 ce             	mov    %rcx,%rsi
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	48 b8 9a 21 80 00 00 	movabs $0x80219a,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax
  802a8b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a92:	79 4a                	jns    802ade <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a94:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a97:	89 c6                	mov    %eax,%esi
  802a99:	48 bf 8d 47 80 00 00 	movabs $0x80478d,%rdi
  802aa0:	00 00 00 
  802aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa8:	48 ba d4 03 80 00 00 	movabs $0x8003d4,%rdx
  802aaf:	00 00 00 
  802ab2:	ff d2                	callq  *%rdx
			close(fd_src);
  802ab4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab7:	89 c7                	mov    %eax,%edi
  802ab9:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	callq  *%rax
			close(fd_dest);
  802ac5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ac8:	89 c7                	mov    %eax,%edi
  802aca:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
			return write_size;
  802ad6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ad9:	e9 a1 00 00 00       	jmpq   802b7f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ade:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae8:	ba 00 02 00 00       	mov    $0x200,%edx
  802aed:	48 89 ce             	mov    %rcx,%rsi
  802af0:	89 c7                	mov    %eax,%edi
  802af2:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  802af9:	00 00 00 
  802afc:	ff d0                	callq  *%rax
  802afe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b01:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b05:	0f 8f 5f ff ff ff    	jg     802a6a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b0f:	79 47                	jns    802b58 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b11:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b14:	89 c6                	mov    %eax,%esi
  802b16:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  802b1d:	00 00 00 
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
  802b25:	48 ba d4 03 80 00 00 	movabs $0x8003d4,%rdx
  802b2c:	00 00 00 
  802b2f:	ff d2                	callq  *%rdx
		close(fd_src);
  802b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b34:	89 c7                	mov    %eax,%edi
  802b36:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802b3d:	00 00 00 
  802b40:	ff d0                	callq  *%rax
		close(fd_dest);
  802b42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b45:	89 c7                	mov    %eax,%edi
  802b47:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
		return read_size;
  802b53:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b56:	eb 27                	jmp    802b7f <copy+0x1d9>
	}
	close(fd_src);
  802b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5b:	89 c7                	mov    %eax,%edi
  802b5d:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
	close(fd_dest);
  802b69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b6c:	89 c7                	mov    %eax,%edi
  802b6e:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802b75:	00 00 00 
  802b78:	ff d0                	callq  *%rax
	return 0;
  802b7a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802b7f:	c9                   	leaveq 
  802b80:	c3                   	retq   

0000000000802b81 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802b81:	55                   	push   %rbp
  802b82:	48 89 e5             	mov    %rsp,%rbp
  802b85:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802b8c:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802b93:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802b9a:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802ba1:	be 00 00 00 00       	mov    $0x0,%esi
  802ba6:	48 89 c7             	mov    %rax,%rdi
  802ba9:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802bb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802bbc:	79 08                	jns    802bc6 <spawn+0x45>
		return r;
  802bbe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802bc1:	e9 14 03 00 00       	jmpq   802eda <spawn+0x359>
	fd = r;
  802bc6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802bc9:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802bcc:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802bd3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802bd7:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802bde:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802be1:	ba 00 02 00 00       	mov    $0x200,%edx
  802be6:	48 89 ce             	mov    %rcx,%rsi
  802be9:	89 c7                	mov    %eax,%edi
  802beb:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
  802bf7:	3d 00 02 00 00       	cmp    $0x200,%eax
  802bfc:	75 0d                	jne    802c0b <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802bfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c02:	8b 00                	mov    (%rax),%eax
  802c04:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802c09:	74 43                	je     802c4e <spawn+0xcd>
		close(fd);
  802c0b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c0e:	89 c7                	mov    %eax,%edi
  802c10:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802c1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c20:	8b 00                	mov    (%rax),%eax
  802c22:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802c27:	89 c6                	mov    %eax,%esi
  802c29:	48 bf b8 47 80 00 00 	movabs $0x8047b8,%rdi
  802c30:	00 00 00 
  802c33:	b8 00 00 00 00       	mov    $0x0,%eax
  802c38:	48 b9 d4 03 80 00 00 	movabs $0x8003d4,%rcx
  802c3f:	00 00 00 
  802c42:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802c44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802c49:	e9 8c 02 00 00       	jmpq   802eda <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802c4e:	b8 07 00 00 00       	mov    $0x7,%eax
  802c53:	cd 30                	int    $0x30
  802c55:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802c58:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802c5b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c62:	79 08                	jns    802c6c <spawn+0xeb>
		return r;
  802c64:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c67:	e9 6e 02 00 00       	jmpq   802eda <spawn+0x359>
	child = r;
  802c6c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c6f:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802c72:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c75:	25 ff 03 00 00       	and    $0x3ff,%eax
  802c7a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802c81:	00 00 00 
  802c84:	48 63 d0             	movslq %eax,%rdx
  802c87:	48 89 d0             	mov    %rdx,%rax
  802c8a:	48 c1 e0 03          	shl    $0x3,%rax
  802c8e:	48 01 d0             	add    %rdx,%rax
  802c91:	48 c1 e0 05          	shl    $0x5,%rax
  802c95:	48 01 c8             	add    %rcx,%rax
  802c98:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802c9f:	48 89 c6             	mov    %rax,%rsi
  802ca2:	b8 18 00 00 00       	mov    $0x18,%eax
  802ca7:	48 89 d7             	mov    %rdx,%rdi
  802caa:	48 89 c1             	mov    %rax,%rcx
  802cad:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802cb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cb8:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802cbf:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802cc6:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802ccd:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802cd4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802cd7:	48 89 ce             	mov    %rcx,%rsi
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
  802ce8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ceb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cef:	79 08                	jns    802cf9 <spawn+0x178>
		return r;
  802cf1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cf4:	e9 e1 01 00 00       	jmpq   802eda <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802cf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cfd:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d01:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802d08:	48 01 d0             	add    %rdx,%rax
  802d0b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d16:	e9 a3 00 00 00       	jmpq   802dbe <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1f:	8b 00                	mov    (%rax),%eax
  802d21:	83 f8 01             	cmp    $0x1,%eax
  802d24:	74 05                	je     802d2b <spawn+0x1aa>
			continue;
  802d26:	e9 8a 00 00 00       	jmpq   802db5 <spawn+0x234>
		perm = PTE_P | PTE_U;
  802d2b:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802d32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d36:	8b 40 04             	mov    0x4(%rax),%eax
  802d39:	83 e0 02             	and    $0x2,%eax
  802d3c:	85 c0                	test   %eax,%eax
  802d3e:	74 04                	je     802d44 <spawn+0x1c3>
			perm |= PTE_W;
  802d40:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802d44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d48:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802d4c:	41 89 c1             	mov    %eax,%r9d
  802d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d53:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802d5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d63:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802d67:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802d6a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d6d:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802d70:	89 3c 24             	mov    %edi,(%rsp)
  802d73:	89 c7                	mov    %eax,%edi
  802d75:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  802d7c:	00 00 00 
  802d7f:	ff d0                	callq  *%rax
  802d81:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d84:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d88:	79 2b                	jns    802db5 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802d8a:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802d8b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d8e:	89 c7                	mov    %eax,%edi
  802d90:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
	close(fd);
  802d9c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d9f:	89 c7                	mov    %eax,%edi
  802da1:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802da8:	00 00 00 
  802dab:	ff d0                	callq  *%rax
	return r;
  802dad:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802db0:	e9 25 01 00 00       	jmpq   802eda <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802db5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802db9:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802dbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dc2:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802dc6:	0f b7 c0             	movzwl %ax,%eax
  802dc9:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802dcc:	0f 8f 49 ff ff ff    	jg     802d1b <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802dd2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802dd5:	89 c7                	mov    %eax,%edi
  802dd7:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802dde:	00 00 00 
  802de1:	ff d0                	callq  *%rax
	fd = -1;
  802de3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802dea:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ded:	89 c7                	mov    %eax,%edi
  802def:	48 b8 d9 35 80 00 00 	movabs $0x8035d9,%rax
  802df6:	00 00 00 
  802df9:	ff d0                	callq  *%rax
  802dfb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802dfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e02:	79 30                	jns    802e34 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802e04:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e07:	89 c1                	mov    %eax,%ecx
  802e09:	48 ba d2 47 80 00 00 	movabs $0x8047d2,%rdx
  802e10:	00 00 00 
  802e13:	be 82 00 00 00       	mov    $0x82,%esi
  802e18:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  802e1f:	00 00 00 
  802e22:	b8 00 00 00 00       	mov    $0x0,%eax
  802e27:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  802e2e:	00 00 00 
  802e31:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802e34:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802e3b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e3e:	48 89 d6             	mov    %rdx,%rsi
  802e41:	89 c7                	mov    %eax,%edi
  802e43:	48 b8 0b 1a 80 00 00 	movabs $0x801a0b,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	callq  *%rax
  802e4f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e52:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e56:	79 30                	jns    802e88 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802e58:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e5b:	89 c1                	mov    %eax,%ecx
  802e5d:	48 ba f4 47 80 00 00 	movabs $0x8047f4,%rdx
  802e64:	00 00 00 
  802e67:	be 85 00 00 00       	mov    $0x85,%esi
  802e6c:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  802e73:	00 00 00 
  802e76:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7b:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  802e82:	00 00 00 
  802e85:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802e88:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e8b:	be 02 00 00 00       	mov    $0x2,%esi
  802e90:	89 c7                	mov    %eax,%edi
  802e92:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  802e99:	00 00 00 
  802e9c:	ff d0                	callq  *%rax
  802e9e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ea1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ea5:	79 30                	jns    802ed7 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802ea7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802eaa:	89 c1                	mov    %eax,%ecx
  802eac:	48 ba 0e 48 80 00 00 	movabs $0x80480e,%rdx
  802eb3:	00 00 00 
  802eb6:	be 88 00 00 00       	mov    $0x88,%esi
  802ebb:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  802ec2:	00 00 00 
  802ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eca:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  802ed1:	00 00 00 
  802ed4:	41 ff d0             	callq  *%r8

	return child;
  802ed7:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802eda:	c9                   	leaveq 
  802edb:	c3                   	retq   

0000000000802edc <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802edc:	55                   	push   %rbp
  802edd:	48 89 e5             	mov    %rsp,%rbp
  802ee0:	41 55                	push   %r13
  802ee2:	41 54                	push   %r12
  802ee4:	53                   	push   %rbx
  802ee5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802eec:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802ef3:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802efa:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802f01:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802f08:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802f0f:	84 c0                	test   %al,%al
  802f11:	74 26                	je     802f39 <spawnl+0x5d>
  802f13:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802f1a:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802f21:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802f25:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802f29:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802f2d:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802f31:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802f35:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802f39:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802f40:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802f47:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802f4a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802f51:	00 00 00 
  802f54:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802f5b:	00 00 00 
  802f5e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f62:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802f69:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802f70:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802f77:	eb 07                	jmp    802f80 <spawnl+0xa4>
		argc++;
  802f79:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802f80:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802f86:	83 f8 30             	cmp    $0x30,%eax
  802f89:	73 23                	jae    802fae <spawnl+0xd2>
  802f8b:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802f92:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802f98:	89 c0                	mov    %eax,%eax
  802f9a:	48 01 d0             	add    %rdx,%rax
  802f9d:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802fa3:	83 c2 08             	add    $0x8,%edx
  802fa6:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802fac:	eb 15                	jmp    802fc3 <spawnl+0xe7>
  802fae:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802fb5:	48 89 d0             	mov    %rdx,%rax
  802fb8:	48 83 c2 08          	add    $0x8,%rdx
  802fbc:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802fc3:	48 8b 00             	mov    (%rax),%rax
  802fc6:	48 85 c0             	test   %rax,%rax
  802fc9:	75 ae                	jne    802f79 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802fcb:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802fd1:	83 c0 02             	add    $0x2,%eax
  802fd4:	48 89 e2             	mov    %rsp,%rdx
  802fd7:	48 89 d3             	mov    %rdx,%rbx
  802fda:	48 63 d0             	movslq %eax,%rdx
  802fdd:	48 83 ea 01          	sub    $0x1,%rdx
  802fe1:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  802fe8:	48 63 d0             	movslq %eax,%rdx
  802feb:	49 89 d4             	mov    %rdx,%r12
  802fee:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802ff4:	48 63 d0             	movslq %eax,%rdx
  802ff7:	49 89 d2             	mov    %rdx,%r10
  802ffa:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803000:	48 98                	cltq   
  803002:	48 c1 e0 03          	shl    $0x3,%rax
  803006:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80300a:	b8 10 00 00 00       	mov    $0x10,%eax
  80300f:	48 83 e8 01          	sub    $0x1,%rax
  803013:	48 01 d0             	add    %rdx,%rax
  803016:	bf 10 00 00 00       	mov    $0x10,%edi
  80301b:	ba 00 00 00 00       	mov    $0x0,%edx
  803020:	48 f7 f7             	div    %rdi
  803023:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803027:	48 29 c4             	sub    %rax,%rsp
  80302a:	48 89 e0             	mov    %rsp,%rax
  80302d:	48 83 c0 07          	add    $0x7,%rax
  803031:	48 c1 e8 03          	shr    $0x3,%rax
  803035:	48 c1 e0 03          	shl    $0x3,%rax
  803039:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803040:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803047:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80304e:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803051:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803057:	8d 50 01             	lea    0x1(%rax),%edx
  80305a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803061:	48 63 d2             	movslq %edx,%rdx
  803064:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80306b:	00 

	va_start(vl, arg0);
  80306c:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803073:	00 00 00 
  803076:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80307d:	00 00 00 
  803080:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803084:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80308b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803092:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803099:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8030a0:	00 00 00 
  8030a3:	eb 63                	jmp    803108 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8030a5:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8030ab:	8d 70 01             	lea    0x1(%rax),%esi
  8030ae:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8030b4:	83 f8 30             	cmp    $0x30,%eax
  8030b7:	73 23                	jae    8030dc <spawnl+0x200>
  8030b9:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8030c0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8030c6:	89 c0                	mov    %eax,%eax
  8030c8:	48 01 d0             	add    %rdx,%rax
  8030cb:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030d1:	83 c2 08             	add    $0x8,%edx
  8030d4:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8030da:	eb 15                	jmp    8030f1 <spawnl+0x215>
  8030dc:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8030e3:	48 89 d0             	mov    %rdx,%rax
  8030e6:	48 83 c2 08          	add    $0x8,%rdx
  8030ea:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8030f1:	48 8b 08             	mov    (%rax),%rcx
  8030f4:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030fb:	89 f2                	mov    %esi,%edx
  8030fd:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803101:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803108:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80310e:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803114:	77 8f                	ja     8030a5 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803116:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80311d:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803124:	48 89 d6             	mov    %rdx,%rsi
  803127:	48 89 c7             	mov    %rax,%rdi
  80312a:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
  803136:	48 89 dc             	mov    %rbx,%rsp
}
  803139:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80313d:	5b                   	pop    %rbx
  80313e:	41 5c                	pop    %r12
  803140:	41 5d                	pop    %r13
  803142:	5d                   	pop    %rbp
  803143:	c3                   	retq   

0000000000803144 <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  803144:	55                   	push   %rbp
  803145:	48 89 e5             	mov    %rsp,%rbp
  803148:	48 83 ec 50          	sub    $0x50,%rsp
  80314c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80314f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803153:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803157:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80315e:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80315f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803166:	eb 33                	jmp    80319b <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803168:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80316b:	48 98                	cltq   
  80316d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803174:	00 
  803175:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803179:	48 01 d0             	add    %rdx,%rax
  80317c:	48 8b 00             	mov    (%rax),%rax
  80317f:	48 89 c7             	mov    %rax,%rdi
  803182:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  803189:	00 00 00 
  80318c:	ff d0                	callq  *%rax
  80318e:	83 c0 01             	add    $0x1,%eax
  803191:	48 98                	cltq   
  803193:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803197:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80319b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80319e:	48 98                	cltq   
  8031a0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031a7:	00 
  8031a8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031ac:	48 01 d0             	add    %rdx,%rax
  8031af:	48 8b 00             	mov    (%rax),%rax
  8031b2:	48 85 c0             	test   %rax,%rax
  8031b5:	75 b1                	jne    803168 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8031b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bb:	48 f7 d8             	neg    %rax
  8031be:	48 05 00 10 40 00    	add    $0x401000,%rax
  8031c4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8031c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8031d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d4:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8031d8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031db:	83 c2 01             	add    $0x1,%edx
  8031de:	c1 e2 03             	shl    $0x3,%edx
  8031e1:	48 63 d2             	movslq %edx,%rdx
  8031e4:	48 f7 da             	neg    %rdx
  8031e7:	48 01 d0             	add    %rdx,%rax
  8031ea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8031ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f2:	48 83 e8 10          	sub    $0x10,%rax
  8031f6:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8031fc:	77 0a                	ja     803208 <init_stack+0xc4>
		return -E_NO_MEM;
  8031fe:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803203:	e9 e3 01 00 00       	jmpq   8033eb <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803208:	ba 07 00 00 00       	mov    $0x7,%edx
  80320d:	be 00 00 40 00       	mov    $0x400000,%esi
  803212:	bf 00 00 00 00       	mov    $0x0,%edi
  803217:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  80321e:	00 00 00 
  803221:	ff d0                	callq  *%rax
  803223:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803226:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80322a:	79 08                	jns    803234 <init_stack+0xf0>
		return r;
  80322c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80322f:	e9 b7 01 00 00       	jmpq   8033eb <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80323b:	e9 8a 00 00 00       	jmpq   8032ca <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803240:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803243:	48 98                	cltq   
  803245:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80324c:	00 
  80324d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803251:	48 01 c2             	add    %rax,%rdx
  803254:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803259:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325d:	48 01 c8             	add    %rcx,%rax
  803260:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803266:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803269:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80326c:	48 98                	cltq   
  80326e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803275:	00 
  803276:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80327a:	48 01 d0             	add    %rdx,%rax
  80327d:	48 8b 10             	mov    (%rax),%rdx
  803280:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803284:	48 89 d6             	mov    %rdx,%rsi
  803287:	48 89 c7             	mov    %rax,%rdi
  80328a:	48 b8 9c 0f 80 00 00 	movabs $0x800f9c,%rax
  803291:	00 00 00 
  803294:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803296:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803299:	48 98                	cltq   
  80329b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032a2:	00 
  8032a3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032a7:	48 01 d0             	add    %rdx,%rax
  8032aa:	48 8b 00             	mov    (%rax),%rax
  8032ad:	48 89 c7             	mov    %rax,%rdi
  8032b0:	48 b8 30 0f 80 00 00 	movabs $0x800f30,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
  8032bc:	48 98                	cltq   
  8032be:	48 83 c0 01          	add    $0x1,%rax
  8032c2:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8032c6:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8032ca:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032cd:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8032d0:	0f 8c 6a ff ff ff    	jl     803240 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8032d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032d9:	48 98                	cltq   
  8032db:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032e2:	00 
  8032e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e7:	48 01 d0             	add    %rdx,%rax
  8032ea:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8032f1:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8032f8:	00 
  8032f9:	74 35                	je     803330 <init_stack+0x1ec>
  8032fb:	48 b9 28 48 80 00 00 	movabs $0x804828,%rcx
  803302:	00 00 00 
  803305:	48 ba 4e 48 80 00 00 	movabs $0x80484e,%rdx
  80330c:	00 00 00 
  80330f:	be f1 00 00 00       	mov    $0xf1,%esi
  803314:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  80331b:	00 00 00 
  80331e:	b8 00 00 00 00       	mov    $0x0,%eax
  803323:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  80332a:	00 00 00 
  80332d:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803330:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803334:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803338:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80333d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803341:	48 01 c8             	add    %rcx,%rax
  803344:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80334a:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80334d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803351:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803355:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803358:	48 98                	cltq   
  80335a:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  80335d:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803362:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803366:	48 01 d0             	add    %rdx,%rax
  803369:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80336f:	48 89 c2             	mov    %rax,%rdx
  803372:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803376:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803379:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80337c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803382:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803387:	89 c2                	mov    %eax,%edx
  803389:	be 00 00 40 00       	mov    $0x400000,%esi
  80338e:	bf 00 00 00 00       	mov    $0x0,%edi
  803393:	48 b8 1b 19 80 00 00 	movabs $0x80191b,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
  80339f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a6:	79 02                	jns    8033aa <init_stack+0x266>
		goto error;
  8033a8:	eb 28                	jmp    8033d2 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8033aa:	be 00 00 40 00       	mov    $0x400000,%esi
  8033af:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b4:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  8033bb:	00 00 00 
  8033be:	ff d0                	callq  *%rax
  8033c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033c7:	79 02                	jns    8033cb <init_stack+0x287>
		goto error;
  8033c9:	eb 07                	jmp    8033d2 <init_stack+0x28e>

	return 0;
  8033cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d0:	eb 19                	jmp    8033eb <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8033d2:	be 00 00 40 00       	mov    $0x400000,%esi
  8033d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8033dc:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
	return r;
  8033e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033eb:	c9                   	leaveq 
  8033ec:	c3                   	retq   

00000000008033ed <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8033ed:	55                   	push   %rbp
  8033ee:	48 89 e5             	mov    %rsp,%rbp
  8033f1:	48 83 ec 50          	sub    $0x50,%rsp
  8033f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8033f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033fc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803400:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803403:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803407:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80340b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80340f:	25 ff 0f 00 00       	and    $0xfff,%eax
  803414:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803417:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80341b:	74 21                	je     80343e <map_segment+0x51>
		va -= i;
  80341d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803420:	48 98                	cltq   
  803422:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803429:	48 98                	cltq   
  80342b:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80342f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803432:	48 98                	cltq   
  803434:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343b:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80343e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803445:	e9 79 01 00 00       	jmpq   8035c3 <map_segment+0x1d6>
		if (i >= filesz) {
  80344a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344d:	48 98                	cltq   
  80344f:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803453:	72 3c                	jb     803491 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803458:	48 63 d0             	movslq %eax,%rdx
  80345b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80345f:	48 01 d0             	add    %rdx,%rax
  803462:	48 89 c1             	mov    %rax,%rcx
  803465:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803468:	8b 55 10             	mov    0x10(%rbp),%edx
  80346b:	48 89 ce             	mov    %rcx,%rsi
  80346e:	89 c7                	mov    %eax,%edi
  803470:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80347f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803483:	0f 89 33 01 00 00    	jns    8035bc <map_segment+0x1cf>
				return r;
  803489:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80348c:	e9 46 01 00 00       	jmpq   8035d7 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803491:	ba 07 00 00 00       	mov    $0x7,%edx
  803496:	be 00 00 40 00       	mov    $0x400000,%esi
  80349b:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a0:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034b3:	79 08                	jns    8034bd <map_segment+0xd0>
				return r;
  8034b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034b8:	e9 1a 01 00 00       	jmpq   8035d7 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8034bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c0:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8034c3:	01 c2                	add    %eax,%edx
  8034c5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8034c8:	89 d6                	mov    %edx,%esi
  8034ca:	89 c7                	mov    %eax,%edi
  8034cc:	48 b8 6e 22 80 00 00 	movabs $0x80226e,%rax
  8034d3:	00 00 00 
  8034d6:	ff d0                	callq  *%rax
  8034d8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034db:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034df:	79 08                	jns    8034e9 <map_segment+0xfc>
				return r;
  8034e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034e4:	e9 ee 00 00 00       	jmpq   8035d7 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8034e9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8034f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f3:	48 98                	cltq   
  8034f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8034f9:	48 29 c2             	sub    %rax,%rdx
  8034fc:	48 89 d0             	mov    %rdx,%rax
  8034ff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803503:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803506:	48 63 d0             	movslq %eax,%rdx
  803509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80350d:	48 39 c2             	cmp    %rax,%rdx
  803510:	48 0f 47 d0          	cmova  %rax,%rdx
  803514:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803517:	be 00 00 40 00       	mov    $0x400000,%esi
  80351c:	89 c7                	mov    %eax,%edi
  80351e:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  803525:	00 00 00 
  803528:	ff d0                	callq  *%rax
  80352a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80352d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803531:	79 08                	jns    80353b <map_segment+0x14e>
				return r;
  803533:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803536:	e9 9c 00 00 00       	jmpq   8035d7 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80353b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353e:	48 63 d0             	movslq %eax,%rdx
  803541:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803545:	48 01 d0             	add    %rdx,%rax
  803548:	48 89 c2             	mov    %rax,%rdx
  80354b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80354e:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803552:	48 89 d1             	mov    %rdx,%rcx
  803555:	89 c2                	mov    %eax,%edx
  803557:	be 00 00 40 00       	mov    $0x400000,%esi
  80355c:	bf 00 00 00 00       	mov    $0x0,%edi
  803561:	48 b8 1b 19 80 00 00 	movabs $0x80191b,%rax
  803568:	00 00 00 
  80356b:	ff d0                	callq  *%rax
  80356d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803570:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803574:	79 30                	jns    8035a6 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803576:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803579:	89 c1                	mov    %eax,%ecx
  80357b:	48 ba 63 48 80 00 00 	movabs $0x804863,%rdx
  803582:	00 00 00 
  803585:	be 24 01 00 00       	mov    $0x124,%esi
  80358a:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  803591:	00 00 00 
  803594:	b8 00 00 00 00       	mov    $0x0,%eax
  803599:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  8035a0:	00 00 00 
  8035a3:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8035a6:	be 00 00 40 00       	mov    $0x400000,%esi
  8035ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8035b0:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8035bc:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8035c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c6:	48 98                	cltq   
  8035c8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035cc:	0f 82 78 fe ff ff    	jb     80344a <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8035d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035d7:	c9                   	leaveq 
  8035d8:	c3                   	retq   

00000000008035d9 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8035d9:	55                   	push   %rbp
  8035da:	48 89 e5             	mov    %rsp,%rbp
  8035dd:	48 83 ec 04          	sub    $0x4,%rsp
  8035e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  8035e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035e9:	c9                   	leaveq 
  8035ea:	c3                   	retq   

00000000008035eb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035eb:	55                   	push   %rbp
  8035ec:	48 89 e5             	mov    %rsp,%rbp
  8035ef:	53                   	push   %rbx
  8035f0:	48 83 ec 38          	sub    $0x38,%rsp
  8035f4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035f8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035fc:	48 89 c7             	mov    %rax,%rdi
  8035ff:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
  80360b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80360e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803612:	0f 88 bf 01 00 00    	js     8037d7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361c:	ba 07 04 00 00       	mov    $0x407,%edx
  803621:	48 89 c6             	mov    %rax,%rsi
  803624:	bf 00 00 00 00       	mov    $0x0,%edi
  803629:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  803630:	00 00 00 
  803633:	ff d0                	callq  *%rax
  803635:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803638:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80363c:	0f 88 95 01 00 00    	js     8037d7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803642:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803646:	48 89 c7             	mov    %rax,%rdi
  803649:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
  803655:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803658:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80365c:	0f 88 5d 01 00 00    	js     8037bf <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803662:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803666:	ba 07 04 00 00       	mov    $0x407,%edx
  80366b:	48 89 c6             	mov    %rax,%rsi
  80366e:	bf 00 00 00 00       	mov    $0x0,%edi
  803673:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
  80367f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803682:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803686:	0f 88 33 01 00 00    	js     8037bf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80368c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803690:	48 89 c7             	mov    %rax,%rdi
  803693:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
  80369f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a7:	ba 07 04 00 00       	mov    $0x407,%edx
  8036ac:	48 89 c6             	mov    %rax,%rsi
  8036af:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b4:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  8036bb:	00 00 00 
  8036be:	ff d0                	callq  *%rax
  8036c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c7:	79 05                	jns    8036ce <pipe+0xe3>
		goto err2;
  8036c9:	e9 d9 00 00 00       	jmpq   8037a7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036d2:	48 89 c7             	mov    %rax,%rdi
  8036d5:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
  8036e1:	48 89 c2             	mov    %rax,%rdx
  8036e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036ee:	48 89 d1             	mov    %rdx,%rcx
  8036f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8036f6:	48 89 c6             	mov    %rax,%rsi
  8036f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fe:	48 b8 1b 19 80 00 00 	movabs $0x80191b,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
  80370a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80370d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803711:	79 1b                	jns    80372e <pipe+0x143>
		goto err3;
  803713:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803714:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803718:	48 89 c6             	mov    %rax,%rsi
  80371b:	bf 00 00 00 00       	mov    $0x0,%edi
  803720:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  803727:	00 00 00 
  80372a:	ff d0                	callq  *%rax
  80372c:	eb 79                	jmp    8037a7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80372e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803732:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803739:	00 00 00 
  80373c:	8b 12                	mov    (%rdx),%edx
  80373e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803744:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80374b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374f:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803756:	00 00 00 
  803759:	8b 12                	mov    (%rdx),%edx
  80375b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80375d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803761:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376c:	48 89 c7             	mov    %rax,%rdi
  80376f:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
  80377b:	89 c2                	mov    %eax,%edx
  80377d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803781:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803783:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803787:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80378b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80378f:	48 89 c7             	mov    %rax,%rdi
  803792:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803799:	00 00 00 
  80379c:	ff d0                	callq  *%rax
  80379e:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a5:	eb 33                	jmp    8037da <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037ab:	48 89 c6             	mov    %rax,%rsi
  8037ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b3:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  8037ba:	00 00 00 
  8037bd:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c3:	48 89 c6             	mov    %rax,%rsi
  8037c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8037cb:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
err:
	return r;
  8037d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037da:	48 83 c4 38          	add    $0x38,%rsp
  8037de:	5b                   	pop    %rbx
  8037df:	5d                   	pop    %rbp
  8037e0:	c3                   	retq   

00000000008037e1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037e1:	55                   	push   %rbp
  8037e2:	48 89 e5             	mov    %rsp,%rbp
  8037e5:	53                   	push   %rbx
  8037e6:	48 83 ec 28          	sub    $0x28,%rsp
  8037ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037f9:	00 00 00 
  8037fc:	48 8b 00             	mov    (%rax),%rax
  8037ff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803805:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380c:	48 89 c7             	mov    %rax,%rdi
  80380f:	48 b8 42 40 80 00 00 	movabs $0x804042,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
  80381b:	89 c3                	mov    %eax,%ebx
  80381d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803821:	48 89 c7             	mov    %rax,%rdi
  803824:	48 b8 42 40 80 00 00 	movabs $0x804042,%rax
  80382b:	00 00 00 
  80382e:	ff d0                	callq  *%rax
  803830:	39 c3                	cmp    %eax,%ebx
  803832:	0f 94 c0             	sete   %al
  803835:	0f b6 c0             	movzbl %al,%eax
  803838:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80383b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803842:	00 00 00 
  803845:	48 8b 00             	mov    (%rax),%rax
  803848:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80384e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803851:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803854:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803857:	75 05                	jne    80385e <_pipeisclosed+0x7d>
			return ret;
  803859:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80385c:	eb 4f                	jmp    8038ad <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80385e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803861:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803864:	74 42                	je     8038a8 <_pipeisclosed+0xc7>
  803866:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80386a:	75 3c                	jne    8038a8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80386c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803873:	00 00 00 
  803876:	48 8b 00             	mov    (%rax),%rax
  803879:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80387f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803882:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803885:	89 c6                	mov    %eax,%esi
  803887:	48 bf 85 48 80 00 00 	movabs $0x804885,%rdi
  80388e:	00 00 00 
  803891:	b8 00 00 00 00       	mov    $0x0,%eax
  803896:	49 b8 d4 03 80 00 00 	movabs $0x8003d4,%r8
  80389d:	00 00 00 
  8038a0:	41 ff d0             	callq  *%r8
	}
  8038a3:	e9 4a ff ff ff       	jmpq   8037f2 <_pipeisclosed+0x11>
  8038a8:	e9 45 ff ff ff       	jmpq   8037f2 <_pipeisclosed+0x11>
}
  8038ad:	48 83 c4 28          	add    $0x28,%rsp
  8038b1:	5b                   	pop    %rbx
  8038b2:	5d                   	pop    %rbp
  8038b3:	c3                   	retq   

00000000008038b4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038b4:	55                   	push   %rbp
  8038b5:	48 89 e5             	mov    %rsp,%rbp
  8038b8:	48 83 ec 30          	sub    $0x30,%rsp
  8038bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038bf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038c6:	48 89 d6             	mov    %rdx,%rsi
  8038c9:	89 c7                	mov    %eax,%edi
  8038cb:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  8038d2:	00 00 00 
  8038d5:	ff d0                	callq  *%rax
  8038d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038de:	79 05                	jns    8038e5 <pipeisclosed+0x31>
		return r;
  8038e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e3:	eb 31                	jmp    803916 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e9:	48 89 c7             	mov    %rax,%rdi
  8038ec:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  8038f3:	00 00 00 
  8038f6:	ff d0                	callq  *%rax
  8038f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803900:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803904:	48 89 d6             	mov    %rdx,%rsi
  803907:	48 89 c7             	mov    %rax,%rdi
  80390a:	48 b8 e1 37 80 00 00 	movabs $0x8037e1,%rax
  803911:	00 00 00 
  803914:	ff d0                	callq  *%rax
}
  803916:	c9                   	leaveq 
  803917:	c3                   	retq   

0000000000803918 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803918:	55                   	push   %rbp
  803919:	48 89 e5             	mov    %rsp,%rbp
  80391c:	48 83 ec 40          	sub    $0x40,%rsp
  803920:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803924:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803928:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80392c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803930:	48 89 c7             	mov    %rax,%rdi
  803933:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  80393a:	00 00 00 
  80393d:	ff d0                	callq  *%rax
  80393f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803943:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803947:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80394b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803952:	00 
  803953:	e9 92 00 00 00       	jmpq   8039ea <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803958:	eb 41                	jmp    80399b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80395a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80395f:	74 09                	je     80396a <devpipe_read+0x52>
				return i;
  803961:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803965:	e9 92 00 00 00       	jmpq   8039fc <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80396a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80396e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803972:	48 89 d6             	mov    %rdx,%rsi
  803975:	48 89 c7             	mov    %rax,%rdi
  803978:	48 b8 e1 37 80 00 00 	movabs $0x8037e1,%rax
  80397f:	00 00 00 
  803982:	ff d0                	callq  *%rax
  803984:	85 c0                	test   %eax,%eax
  803986:	74 07                	je     80398f <devpipe_read+0x77>
				return 0;
  803988:	b8 00 00 00 00       	mov    $0x0,%eax
  80398d:	eb 6d                	jmp    8039fc <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80398f:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  803996:	00 00 00 
  803999:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80399b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399f:	8b 10                	mov    (%rax),%edx
  8039a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a5:	8b 40 04             	mov    0x4(%rax),%eax
  8039a8:	39 c2                	cmp    %eax,%edx
  8039aa:	74 ae                	je     80395a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039b4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bc:	8b 00                	mov    (%rax),%eax
  8039be:	99                   	cltd   
  8039bf:	c1 ea 1b             	shr    $0x1b,%edx
  8039c2:	01 d0                	add    %edx,%eax
  8039c4:	83 e0 1f             	and    $0x1f,%eax
  8039c7:	29 d0                	sub    %edx,%eax
  8039c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039cd:	48 98                	cltq   
  8039cf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039d4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039da:	8b 00                	mov    (%rax),%eax
  8039dc:	8d 50 01             	lea    0x1(%rax),%edx
  8039df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ee:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039f2:	0f 82 60 ff ff ff    	jb     803958 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039fc:	c9                   	leaveq 
  8039fd:	c3                   	retq   

00000000008039fe <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039fe:	55                   	push   %rbp
  8039ff:	48 89 e5             	mov    %rsp,%rbp
  803a02:	48 83 ec 40          	sub    $0x40,%rsp
  803a06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a0a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a0e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a16:	48 89 c7             	mov    %rax,%rdi
  803a19:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  803a20:	00 00 00 
  803a23:	ff d0                	callq  *%rax
  803a25:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a31:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a38:	00 
  803a39:	e9 8e 00 00 00       	jmpq   803acc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a3e:	eb 31                	jmp    803a71 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a48:	48 89 d6             	mov    %rdx,%rsi
  803a4b:	48 89 c7             	mov    %rax,%rdi
  803a4e:	48 b8 e1 37 80 00 00 	movabs $0x8037e1,%rax
  803a55:	00 00 00 
  803a58:	ff d0                	callq  *%rax
  803a5a:	85 c0                	test   %eax,%eax
  803a5c:	74 07                	je     803a65 <devpipe_write+0x67>
				return 0;
  803a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a63:	eb 79                	jmp    803ade <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a65:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a75:	8b 40 04             	mov    0x4(%rax),%eax
  803a78:	48 63 d0             	movslq %eax,%rdx
  803a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7f:	8b 00                	mov    (%rax),%eax
  803a81:	48 98                	cltq   
  803a83:	48 83 c0 20          	add    $0x20,%rax
  803a87:	48 39 c2             	cmp    %rax,%rdx
  803a8a:	73 b4                	jae    803a40 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a90:	8b 40 04             	mov    0x4(%rax),%eax
  803a93:	99                   	cltd   
  803a94:	c1 ea 1b             	shr    $0x1b,%edx
  803a97:	01 d0                	add    %edx,%eax
  803a99:	83 e0 1f             	and    $0x1f,%eax
  803a9c:	29 d0                	sub    %edx,%eax
  803a9e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803aa2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803aa6:	48 01 ca             	add    %rcx,%rdx
  803aa9:	0f b6 0a             	movzbl (%rdx),%ecx
  803aac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ab0:	48 98                	cltq   
  803ab2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aba:	8b 40 04             	mov    0x4(%rax),%eax
  803abd:	8d 50 01             	lea    0x1(%rax),%edx
  803ac0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ac7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803acc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ad0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ad4:	0f 82 64 ff ff ff    	jb     803a3e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ada:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ade:	c9                   	leaveq 
  803adf:	c3                   	retq   

0000000000803ae0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ae0:	55                   	push   %rbp
  803ae1:	48 89 e5             	mov    %rsp,%rbp
  803ae4:	48 83 ec 20          	sub    $0x20,%rsp
  803ae8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803aec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af4:	48 89 c7             	mov    %rax,%rdi
  803af7:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  803afe:	00 00 00 
  803b01:	ff d0                	callq  *%rax
  803b03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0b:	48 be 98 48 80 00 00 	movabs $0x804898,%rsi
  803b12:	00 00 00 
  803b15:	48 89 c7             	mov    %rax,%rdi
  803b18:	48 b8 9c 0f 80 00 00 	movabs $0x800f9c,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b28:	8b 50 04             	mov    0x4(%rax),%edx
  803b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2f:	8b 00                	mov    (%rax),%eax
  803b31:	29 c2                	sub    %eax,%edx
  803b33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b37:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b41:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b48:	00 00 00 
	stat->st_dev = &devpipe;
  803b4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4f:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803b56:	00 00 00 
  803b59:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b65:	c9                   	leaveq 
  803b66:	c3                   	retq   

0000000000803b67 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b67:	55                   	push   %rbp
  803b68:	48 89 e5             	mov    %rsp,%rbp
  803b6b:	48 83 ec 10          	sub    $0x10,%rsp
  803b6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b77:	48 89 c6             	mov    %rax,%rsi
  803b7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7f:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  803b86:	00 00 00 
  803b89:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8f:	48 89 c7             	mov    %rax,%rdi
  803b92:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
  803b9e:	48 89 c6             	mov    %rax,%rsi
  803ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba6:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  803bad:	00 00 00 
  803bb0:	ff d0                	callq  *%rax
}
  803bb2:	c9                   	leaveq 
  803bb3:	c3                   	retq   

0000000000803bb4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bb4:	55                   	push   %rbp
  803bb5:	48 89 e5             	mov    %rsp,%rbp
  803bb8:	48 83 ec 20          	sub    $0x20,%rsp
  803bbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bc2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bc5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bc9:	be 01 00 00 00       	mov    $0x1,%esi
  803bce:	48 89 c7             	mov    %rax,%rdi
  803bd1:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  803bd8:	00 00 00 
  803bdb:	ff d0                	callq  *%rax
}
  803bdd:	c9                   	leaveq 
  803bde:	c3                   	retq   

0000000000803bdf <getchar>:

int
getchar(void)
{
  803bdf:	55                   	push   %rbp
  803be0:	48 89 e5             	mov    %rsp,%rbp
  803be3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803be7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803beb:	ba 01 00 00 00       	mov    $0x1,%edx
  803bf0:	48 89 c6             	mov    %rax,%rsi
  803bf3:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf8:	48 b8 50 20 80 00 00 	movabs $0x802050,%rax
  803bff:	00 00 00 
  803c02:	ff d0                	callq  *%rax
  803c04:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0b:	79 05                	jns    803c12 <getchar+0x33>
		return r;
  803c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c10:	eb 14                	jmp    803c26 <getchar+0x47>
	if (r < 1)
  803c12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c16:	7f 07                	jg     803c1f <getchar+0x40>
		return -E_EOF;
  803c18:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c1d:	eb 07                	jmp    803c26 <getchar+0x47>
	return c;
  803c1f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c23:	0f b6 c0             	movzbl %al,%eax
}
  803c26:	c9                   	leaveq 
  803c27:	c3                   	retq   

0000000000803c28 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c28:	55                   	push   %rbp
  803c29:	48 89 e5             	mov    %rsp,%rbp
  803c2c:	48 83 ec 20          	sub    $0x20,%rsp
  803c30:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c33:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c3a:	48 89 d6             	mov    %rdx,%rsi
  803c3d:	89 c7                	mov    %eax,%edi
  803c3f:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  803c46:	00 00 00 
  803c49:	ff d0                	callq  *%rax
  803c4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c52:	79 05                	jns    803c59 <iscons+0x31>
		return r;
  803c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c57:	eb 1a                	jmp    803c73 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5d:	8b 10                	mov    (%rax),%edx
  803c5f:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803c66:	00 00 00 
  803c69:	8b 00                	mov    (%rax),%eax
  803c6b:	39 c2                	cmp    %eax,%edx
  803c6d:	0f 94 c0             	sete   %al
  803c70:	0f b6 c0             	movzbl %al,%eax
}
  803c73:	c9                   	leaveq 
  803c74:	c3                   	retq   

0000000000803c75 <opencons>:

int
opencons(void)
{
  803c75:	55                   	push   %rbp
  803c76:	48 89 e5             	mov    %rsp,%rbp
  803c79:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c7d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c81:	48 89 c7             	mov    %rax,%rdi
  803c84:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  803c8b:	00 00 00 
  803c8e:	ff d0                	callq  *%rax
  803c90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c97:	79 05                	jns    803c9e <opencons+0x29>
		return r;
  803c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c9c:	eb 5b                	jmp    803cf9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca2:	ba 07 04 00 00       	mov    $0x407,%edx
  803ca7:	48 89 c6             	mov    %rax,%rsi
  803caa:	bf 00 00 00 00       	mov    $0x0,%edi
  803caf:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  803cb6:	00 00 00 
  803cb9:	ff d0                	callq  *%rax
  803cbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc2:	79 05                	jns    803cc9 <opencons+0x54>
		return r;
  803cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc7:	eb 30                	jmp    803cf9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ccd:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803cd4:	00 00 00 
  803cd7:	8b 12                	mov    (%rdx),%edx
  803cd9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cea:	48 89 c7             	mov    %rax,%rdi
  803ced:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax
}
  803cf9:	c9                   	leaveq 
  803cfa:	c3                   	retq   

0000000000803cfb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cfb:	55                   	push   %rbp
  803cfc:	48 89 e5             	mov    %rsp,%rbp
  803cff:	48 83 ec 30          	sub    $0x30,%rsp
  803d03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d0f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d14:	75 07                	jne    803d1d <devcons_read+0x22>
		return 0;
  803d16:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1b:	eb 4b                	jmp    803d68 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d1d:	eb 0c                	jmp    803d2b <devcons_read+0x30>
		sys_yield();
  803d1f:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  803d26:	00 00 00 
  803d29:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d2b:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  803d32:	00 00 00 
  803d35:	ff d0                	callq  *%rax
  803d37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d3e:	74 df                	je     803d1f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d44:	79 05                	jns    803d4b <devcons_read+0x50>
		return c;
  803d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d49:	eb 1d                	jmp    803d68 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d4b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d4f:	75 07                	jne    803d58 <devcons_read+0x5d>
		return 0;
  803d51:	b8 00 00 00 00       	mov    $0x0,%eax
  803d56:	eb 10                	jmp    803d68 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5b:	89 c2                	mov    %eax,%edx
  803d5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d61:	88 10                	mov    %dl,(%rax)
	return 1;
  803d63:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d68:	c9                   	leaveq 
  803d69:	c3                   	retq   

0000000000803d6a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d6a:	55                   	push   %rbp
  803d6b:	48 89 e5             	mov    %rsp,%rbp
  803d6e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d75:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d7c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d83:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d91:	eb 76                	jmp    803e09 <devcons_write+0x9f>
		m = n - tot;
  803d93:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d9a:	89 c2                	mov    %eax,%edx
  803d9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d9f:	29 c2                	sub    %eax,%edx
  803da1:	89 d0                	mov    %edx,%eax
  803da3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803da6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da9:	83 f8 7f             	cmp    $0x7f,%eax
  803dac:	76 07                	jbe    803db5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dae:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803db5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803db8:	48 63 d0             	movslq %eax,%rdx
  803dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbe:	48 63 c8             	movslq %eax,%rcx
  803dc1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803dc8:	48 01 c1             	add    %rax,%rcx
  803dcb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dd2:	48 89 ce             	mov    %rcx,%rsi
  803dd5:	48 89 c7             	mov    %rax,%rdi
  803dd8:	48 b8 c0 12 80 00 00 	movabs $0x8012c0,%rax
  803ddf:	00 00 00 
  803de2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803de4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de7:	48 63 d0             	movslq %eax,%rdx
  803dea:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803df1:	48 89 d6             	mov    %rdx,%rsi
  803df4:	48 89 c7             	mov    %rax,%rdi
  803df7:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  803dfe:	00 00 00 
  803e01:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e06:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0c:	48 98                	cltq   
  803e0e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e15:	0f 82 78 ff ff ff    	jb     803d93 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e1e:	c9                   	leaveq 
  803e1f:	c3                   	retq   

0000000000803e20 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e20:	55                   	push   %rbp
  803e21:	48 89 e5             	mov    %rsp,%rbp
  803e24:	48 83 ec 08          	sub    $0x8,%rsp
  803e28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e31:	c9                   	leaveq 
  803e32:	c3                   	retq   

0000000000803e33 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e33:	55                   	push   %rbp
  803e34:	48 89 e5             	mov    %rsp,%rbp
  803e37:	48 83 ec 10          	sub    $0x10,%rsp
  803e3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e47:	48 be a4 48 80 00 00 	movabs $0x8048a4,%rsi
  803e4e:	00 00 00 
  803e51:	48 89 c7             	mov    %rax,%rdi
  803e54:	48 b8 9c 0f 80 00 00 	movabs $0x800f9c,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
	return 0;
  803e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e65:	c9                   	leaveq 
  803e66:	c3                   	retq   

0000000000803e67 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e67:	55                   	push   %rbp
  803e68:	48 89 e5             	mov    %rsp,%rbp
  803e6b:	48 83 ec 30          	sub    $0x30,%rsp
  803e6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e77:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803e7b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e80:	75 0e                	jne    803e90 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803e82:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e89:	00 00 00 
  803e8c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803e90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e94:	48 89 c7             	mov    %rax,%rdi
  803e97:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  803e9e:	00 00 00 
  803ea1:	ff d0                	callq  *%rax
  803ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eaa:	79 27                	jns    803ed3 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803eac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803eb1:	74 0a                	je     803ebd <ipc_recv+0x56>
            *from_env_store = 0;
  803eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eb7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803ebd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ec2:	74 0a                	je     803ece <ipc_recv+0x67>
            *perm_store = 0;
  803ec4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed1:	eb 53                	jmp    803f26 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803ed3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ed8:	74 19                	je     803ef3 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803eda:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ee1:	00 00 00 
  803ee4:	48 8b 00             	mov    (%rax),%rax
  803ee7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef1:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803ef3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ef8:	74 19                	je     803f13 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803efa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f01:	00 00 00 
  803f04:	48 8b 00             	mov    (%rax),%rax
  803f07:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f11:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803f13:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f1a:	00 00 00 
  803f1d:	48 8b 00             	mov    (%rax),%rax
  803f20:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803f26:	c9                   	leaveq 
  803f27:	c3                   	retq   

0000000000803f28 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f28:	55                   	push   %rbp
  803f29:	48 89 e5             	mov    %rsp,%rbp
  803f2c:	48 83 ec 30          	sub    $0x30,%rsp
  803f30:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f33:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f36:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f3a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803f3d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f42:	75 0e                	jne    803f52 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803f44:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f4b:	00 00 00 
  803f4e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803f52:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f55:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f58:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f5f:	89 c7                	mov    %eax,%edi
  803f61:	48 b8 9f 1a 80 00 00 	movabs $0x801a9f,%rax
  803f68:	00 00 00 
  803f6b:	ff d0                	callq  *%rax
  803f6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f74:	79 36                	jns    803fac <ipc_send+0x84>
  803f76:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f7a:	74 30                	je     803fac <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803f7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f7f:	89 c1                	mov    %eax,%ecx
  803f81:	48 ba ab 48 80 00 00 	movabs $0x8048ab,%rdx
  803f88:	00 00 00 
  803f8b:	be 49 00 00 00       	mov    $0x49,%esi
  803f90:	48 bf b8 48 80 00 00 	movabs $0x8048b8,%rdi
  803f97:	00 00 00 
  803f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f9f:	49 b8 9b 01 80 00 00 	movabs $0x80019b,%r8
  803fa6:	00 00 00 
  803fa9:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803fac:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  803fb3:	00 00 00 
  803fb6:	ff d0                	callq  *%rax
    } while(r != 0);
  803fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fbc:	75 94                	jne    803f52 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803fbe:	c9                   	leaveq 
  803fbf:	c3                   	retq   

0000000000803fc0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fc0:	55                   	push   %rbp
  803fc1:	48 89 e5             	mov    %rsp,%rbp
  803fc4:	48 83 ec 14          	sub    $0x14,%rsp
  803fc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fd2:	eb 5e                	jmp    804032 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803fd4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fdb:	00 00 00 
  803fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe1:	48 63 d0             	movslq %eax,%rdx
  803fe4:	48 89 d0             	mov    %rdx,%rax
  803fe7:	48 c1 e0 03          	shl    $0x3,%rax
  803feb:	48 01 d0             	add    %rdx,%rax
  803fee:	48 c1 e0 05          	shl    $0x5,%rax
  803ff2:	48 01 c8             	add    %rcx,%rax
  803ff5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ffb:	8b 00                	mov    (%rax),%eax
  803ffd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804000:	75 2c                	jne    80402e <ipc_find_env+0x6e>
			return envs[i].env_id;
  804002:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804009:	00 00 00 
  80400c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80400f:	48 63 d0             	movslq %eax,%rdx
  804012:	48 89 d0             	mov    %rdx,%rax
  804015:	48 c1 e0 03          	shl    $0x3,%rax
  804019:	48 01 d0             	add    %rdx,%rax
  80401c:	48 c1 e0 05          	shl    $0x5,%rax
  804020:	48 01 c8             	add    %rcx,%rax
  804023:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804029:	8b 40 08             	mov    0x8(%rax),%eax
  80402c:	eb 12                	jmp    804040 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80402e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804032:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804039:	7e 99                	jle    803fd4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80403b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804040:	c9                   	leaveq 
  804041:	c3                   	retq   

0000000000804042 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804042:	55                   	push   %rbp
  804043:	48 89 e5             	mov    %rsp,%rbp
  804046:	48 83 ec 18          	sub    $0x18,%rsp
  80404a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80404e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804052:	48 c1 e8 15          	shr    $0x15,%rax
  804056:	48 89 c2             	mov    %rax,%rdx
  804059:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804060:	01 00 00 
  804063:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804067:	83 e0 01             	and    $0x1,%eax
  80406a:	48 85 c0             	test   %rax,%rax
  80406d:	75 07                	jne    804076 <pageref+0x34>
		return 0;
  80406f:	b8 00 00 00 00       	mov    $0x0,%eax
  804074:	eb 53                	jmp    8040c9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80407a:	48 c1 e8 0c          	shr    $0xc,%rax
  80407e:	48 89 c2             	mov    %rax,%rdx
  804081:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804088:	01 00 00 
  80408b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80408f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804097:	83 e0 01             	and    $0x1,%eax
  80409a:	48 85 c0             	test   %rax,%rax
  80409d:	75 07                	jne    8040a6 <pageref+0x64>
		return 0;
  80409f:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a4:	eb 23                	jmp    8040c9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8040ae:	48 89 c2             	mov    %rax,%rdx
  8040b1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040b8:	00 00 00 
  8040bb:	48 c1 e2 04          	shl    $0x4,%rdx
  8040bf:	48 01 d0             	add    %rdx,%rax
  8040c2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040c6:	0f b7 c0             	movzwl %ax,%eax
}
  8040c9:	c9                   	leaveq 
  8040ca:	c3                   	retq   
