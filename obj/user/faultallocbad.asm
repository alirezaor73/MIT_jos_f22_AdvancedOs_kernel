
obj/user/faultallocbad:     file format elf64-x86-64


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
  80003c:	e8 15 01 00 00       	callq  800156 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	cprintf("fault %x\n", addr);
  80005a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80005e:	48 89 c6             	mov    %rax,%rsi
  800061:	48 bf 20 38 80 00 00 	movabs $0x803820,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 43 04 80 00 00 	movabs $0x800443,%rdx
  800077:	00 00 00 
  80007a:	ff d2                	callq  *%rdx
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80007c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800080:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800088:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80008e:	ba 07 00 00 00       	mov    $0x7,%edx
  800093:	48 89 c6             	mov    %rax,%rsi
  800096:	bf 00 00 00 00       	mov    $0x0,%edi
  80009b:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ae:	79 38                	jns    8000e8 <handler+0xa5>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b7:	41 89 d0             	mov    %edx,%r8d
  8000ba:	48 89 c1             	mov    %rax,%rcx
  8000bd:	48 ba 30 38 80 00 00 	movabs $0x803830,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cc:	48 bf 5b 38 80 00 00 	movabs $0x80385b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 0a 02 80 00 00 	movabs $0x80020a,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 70 38 80 00 00 	movabs $0x803870,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 be 0e 80 00 00 	movabs $0x800ebe,%r8
  800111:	00 00 00 
  800114:	41 ff d0             	callq  *%r8
}
  800117:	c9                   	leaveq 
  800118:	c3                   	retq   

0000000000800119 <umain>:

void
umain(int argc, char **argv)
{
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	48 83 ec 10          	sub    $0x10,%rsp
  800121:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800124:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  800128:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  80012f:	00 00 00 
  800132:	48 b8 a7 1b 80 00 00 	movabs $0x801ba7,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013e:	be 04 00 00 00       	mov    $0x4,%esi
  800143:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800148:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
}
  800154:	c9                   	leaveq 
  800155:	c3                   	retq   

0000000000800156 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800156:	55                   	push   %rbp
  800157:	48 89 e5             	mov    %rsp,%rbp
  80015a:	48 83 ec 20          	sub    $0x20,%rsp
  80015e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800161:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800165:	48 b8 be 18 80 00 00 	movabs $0x8018be,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
  800171:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800177:	25 ff 03 00 00       	and    $0x3ff,%eax
  80017c:	48 63 d0             	movslq %eax,%rdx
  80017f:	48 89 d0             	mov    %rdx,%rax
  800182:	48 c1 e0 03          	shl    $0x3,%rax
  800186:	48 01 d0             	add    %rdx,%rax
  800189:	48 c1 e0 05          	shl    $0x5,%rax
  80018d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800194:	00 00 00 
  800197:	48 01 c2             	add    %rax,%rdx
  80019a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001a1:	00 00 00 
  8001a4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001ab:	7e 14                	jle    8001c1 <libmain+0x6b>
		binaryname = argv[0];
  8001ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001b1:	48 8b 10             	mov    (%rax),%rdx
  8001b4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001bb:	00 00 00 
  8001be:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c8:	48 89 d6             	mov    %rdx,%rsi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d9:	48 b8 e7 01 80 00 00 	movabs $0x8001e7,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax
}
  8001e5:	c9                   	leaveq 
  8001e6:	c3                   	retq   

00000000008001e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e7:	55                   	push   %rbp
  8001e8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001eb:	48 b8 32 20 80 00 00 	movabs $0x802032,%rax
  8001f2:	00 00 00 
  8001f5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 7a 18 80 00 00 	movabs $0x80187a,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
}
  800208:	5d                   	pop    %rbp
  800209:	c3                   	retq   

000000000080020a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80020a:	55                   	push   %rbp
  80020b:	48 89 e5             	mov    %rsp,%rbp
  80020e:	53                   	push   %rbx
  80020f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800216:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80021d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800223:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80022a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800231:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800238:	84 c0                	test   %al,%al
  80023a:	74 23                	je     80025f <_panic+0x55>
  80023c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800243:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800247:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80024b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80024f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800253:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800257:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80025b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80025f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800266:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80026d:	00 00 00 
  800270:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800277:	00 00 00 
  80027a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80027e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800285:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80028c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800293:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80029a:	00 00 00 
  80029d:	48 8b 18             	mov    (%rax),%rbx
  8002a0:	48 b8 be 18 80 00 00 	movabs $0x8018be,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	callq  *%rax
  8002ac:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002b2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002b9:	41 89 c8             	mov    %ecx,%r8d
  8002bc:	48 89 d1             	mov    %rdx,%rcx
  8002bf:	48 89 da             	mov    %rbx,%rdx
  8002c2:	89 c6                	mov    %eax,%esi
  8002c4:	48 bf a0 38 80 00 00 	movabs $0x8038a0,%rdi
  8002cb:	00 00 00 
  8002ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d3:	49 b9 43 04 80 00 00 	movabs $0x800443,%r9
  8002da:	00 00 00 
  8002dd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002ee:	48 89 d6             	mov    %rdx,%rsi
  8002f1:	48 89 c7             	mov    %rax,%rdi
  8002f4:	48 b8 97 03 80 00 00 	movabs $0x800397,%rax
  8002fb:	00 00 00 
  8002fe:	ff d0                	callq  *%rax
	cprintf("\n");
  800300:	48 bf c3 38 80 00 00 	movabs $0x8038c3,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	48 ba 43 04 80 00 00 	movabs $0x800443,%rdx
  800316:	00 00 00 
  800319:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80031b:	cc                   	int3   
  80031c:	eb fd                	jmp    80031b <_panic+0x111>

000000000080031e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80031e:	55                   	push   %rbp
  80031f:	48 89 e5             	mov    %rsp,%rbp
  800322:	48 83 ec 10          	sub    $0x10,%rsp
  800326:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800329:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80032d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800331:	8b 00                	mov    (%rax),%eax
  800333:	8d 48 01             	lea    0x1(%rax),%ecx
  800336:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80033a:	89 0a                	mov    %ecx,(%rdx)
  80033c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80033f:	89 d1                	mov    %edx,%ecx
  800341:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800345:	48 98                	cltq   
  800347:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80034b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034f:	8b 00                	mov    (%rax),%eax
  800351:	3d ff 00 00 00       	cmp    $0xff,%eax
  800356:	75 2c                	jne    800384 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80035c:	8b 00                	mov    (%rax),%eax
  80035e:	48 98                	cltq   
  800360:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800364:	48 83 c2 08          	add    $0x8,%rdx
  800368:	48 89 c6             	mov    %rax,%rsi
  80036b:	48 89 d7             	mov    %rdx,%rdi
  80036e:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
        b->idx = 0;
  80037a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800388:	8b 40 04             	mov    0x4(%rax),%eax
  80038b:	8d 50 01             	lea    0x1(%rax),%edx
  80038e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800392:	89 50 04             	mov    %edx,0x4(%rax)
}
  800395:	c9                   	leaveq 
  800396:	c3                   	retq   

0000000000800397 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800397:	55                   	push   %rbp
  800398:	48 89 e5             	mov    %rsp,%rbp
  80039b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003a2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003a9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003b0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003b7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003be:	48 8b 0a             	mov    (%rdx),%rcx
  8003c1:	48 89 08             	mov    %rcx,(%rax)
  8003c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003c8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003cc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003d0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003db:	00 00 00 
    b.cnt = 0;
  8003de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003e5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8003e8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8003ef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003f6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003fd:	48 89 c6             	mov    %rax,%rsi
  800400:	48 bf 1e 03 80 00 00 	movabs $0x80031e,%rdi
  800407:	00 00 00 
  80040a:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  800411:	00 00 00 
  800414:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800416:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80041c:	48 98                	cltq   
  80041e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800425:	48 83 c2 08          	add    $0x8,%rdx
  800429:	48 89 c6             	mov    %rax,%rsi
  80042c:	48 89 d7             	mov    %rdx,%rdi
  80042f:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  800436:	00 00 00 
  800439:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80043b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800441:	c9                   	leaveq 
  800442:	c3                   	retq   

0000000000800443 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800443:	55                   	push   %rbp
  800444:	48 89 e5             	mov    %rsp,%rbp
  800447:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80044e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800455:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80045c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800463:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80046a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800471:	84 c0                	test   %al,%al
  800473:	74 20                	je     800495 <cprintf+0x52>
  800475:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800479:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80047d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800481:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800485:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800489:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80048d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800491:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800495:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80049c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004a3:	00 00 00 
  8004a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004ad:	00 00 00 
  8004b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004d7:	48 8b 0a             	mov    (%rdx),%rcx
  8004da:	48 89 08             	mov    %rcx,(%rax)
  8004dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8004ed:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004f4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 97 03 80 00 00 	movabs $0x800397,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
  80050d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800513:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	53                   	push   %rbx
  800520:	48 83 ec 38          	sub    $0x38,%rsp
  800524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800528:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80052c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800530:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800533:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800537:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80053b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80053e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800542:	77 3b                	ja     80057f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800544:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800547:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80054b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80054e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	48 f7 f3             	div    %rbx
  80055a:	48 89 c2             	mov    %rax,%rdx
  80055d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800560:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800563:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056b:	41 89 f9             	mov    %edi,%r9d
  80056e:	48 89 c7             	mov    %rax,%rdi
  800571:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800578:	00 00 00 
  80057b:	ff d0                	callq  *%rax
  80057d:	eb 1e                	jmp    80059d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80057f:	eb 12                	jmp    800593 <printnum+0x78>
			putch(padc, putdat);
  800581:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800585:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	48 89 ce             	mov    %rcx,%rsi
  80058f:	89 d7                	mov    %edx,%edi
  800591:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800593:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800597:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80059b:	7f e4                	jg     800581 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80059d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a9:	48 f7 f1             	div    %rcx
  8005ac:	48 89 d0             	mov    %rdx,%rax
  8005af:	48 ba d0 3a 80 00 00 	movabs $0x803ad0,%rdx
  8005b6:	00 00 00 
  8005b9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005bd:	0f be d0             	movsbl %al,%edx
  8005c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 89 ce             	mov    %rcx,%rsi
  8005cb:	89 d7                	mov    %edx,%edi
  8005cd:	ff d0                	callq  *%rax
}
  8005cf:	48 83 c4 38          	add    $0x38,%rsp
  8005d3:	5b                   	pop    %rbx
  8005d4:	5d                   	pop    %rbp
  8005d5:	c3                   	retq   

00000000008005d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d6:	55                   	push   %rbp
  8005d7:	48 89 e5             	mov    %rsp,%rbp
  8005da:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8005e5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e9:	7e 52                	jle    80063d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	8b 00                	mov    (%rax),%eax
  8005f1:	83 f8 30             	cmp    $0x30,%eax
  8005f4:	73 24                	jae    80061a <getuint+0x44>
  8005f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800602:	8b 00                	mov    (%rax),%eax
  800604:	89 c0                	mov    %eax,%eax
  800606:	48 01 d0             	add    %rdx,%rax
  800609:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060d:	8b 12                	mov    (%rdx),%edx
  80060f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800612:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800616:	89 0a                	mov    %ecx,(%rdx)
  800618:	eb 17                	jmp    800631 <getuint+0x5b>
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800622:	48 89 d0             	mov    %rdx,%rax
  800625:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800629:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800631:	48 8b 00             	mov    (%rax),%rax
  800634:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800638:	e9 a3 00 00 00       	jmpq   8006e0 <getuint+0x10a>
	else if (lflag)
  80063d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800641:	74 4f                	je     800692 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	8b 00                	mov    (%rax),%eax
  800649:	83 f8 30             	cmp    $0x30,%eax
  80064c:	73 24                	jae    800672 <getuint+0x9c>
  80064e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800652:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065a:	8b 00                	mov    (%rax),%eax
  80065c:	89 c0                	mov    %eax,%eax
  80065e:	48 01 d0             	add    %rdx,%rax
  800661:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800665:	8b 12                	mov    (%rdx),%edx
  800667:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066e:	89 0a                	mov    %ecx,(%rdx)
  800670:	eb 17                	jmp    800689 <getuint+0xb3>
  800672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800676:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067a:	48 89 d0             	mov    %rdx,%rax
  80067d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800681:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800685:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800689:	48 8b 00             	mov    (%rax),%rax
  80068c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800690:	eb 4e                	jmp    8006e0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	8b 00                	mov    (%rax),%eax
  800698:	83 f8 30             	cmp    $0x30,%eax
  80069b:	73 24                	jae    8006c1 <getuint+0xeb>
  80069d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a9:	8b 00                	mov    (%rax),%eax
  8006ab:	89 c0                	mov    %eax,%eax
  8006ad:	48 01 d0             	add    %rdx,%rax
  8006b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b4:	8b 12                	mov    (%rdx),%edx
  8006b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bd:	89 0a                	mov    %ecx,(%rdx)
  8006bf:	eb 17                	jmp    8006d8 <getuint+0x102>
  8006c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c9:	48 89 d0             	mov    %rdx,%rax
  8006cc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d8:	8b 00                	mov    (%rax),%eax
  8006da:	89 c0                	mov    %eax,%eax
  8006dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e4:	c9                   	leaveq 
  8006e5:	c3                   	retq   

00000000008006e6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e6:	55                   	push   %rbp
  8006e7:	48 89 e5             	mov    %rsp,%rbp
  8006ea:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8006f5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006f9:	7e 52                	jle    80074d <getint+0x67>
		x=va_arg(*ap, long long);
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	8b 00                	mov    (%rax),%eax
  800701:	83 f8 30             	cmp    $0x30,%eax
  800704:	73 24                	jae    80072a <getint+0x44>
  800706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	8b 00                	mov    (%rax),%eax
  800714:	89 c0                	mov    %eax,%eax
  800716:	48 01 d0             	add    %rdx,%rax
  800719:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071d:	8b 12                	mov    (%rdx),%edx
  80071f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800722:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800726:	89 0a                	mov    %ecx,(%rdx)
  800728:	eb 17                	jmp    800741 <getint+0x5b>
  80072a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800732:	48 89 d0             	mov    %rdx,%rax
  800735:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800739:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800741:	48 8b 00             	mov    (%rax),%rax
  800744:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800748:	e9 a3 00 00 00       	jmpq   8007f0 <getint+0x10a>
	else if (lflag)
  80074d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800751:	74 4f                	je     8007a2 <getint+0xbc>
		x=va_arg(*ap, long);
  800753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800757:	8b 00                	mov    (%rax),%eax
  800759:	83 f8 30             	cmp    $0x30,%eax
  80075c:	73 24                	jae    800782 <getint+0x9c>
  80075e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800762:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	8b 00                	mov    (%rax),%eax
  80076c:	89 c0                	mov    %eax,%eax
  80076e:	48 01 d0             	add    %rdx,%rax
  800771:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800775:	8b 12                	mov    (%rdx),%edx
  800777:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077e:	89 0a                	mov    %ecx,(%rdx)
  800780:	eb 17                	jmp    800799 <getint+0xb3>
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078a:	48 89 d0             	mov    %rdx,%rax
  80078d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800795:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800799:	48 8b 00             	mov    (%rax),%rax
  80079c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a0:	eb 4e                	jmp    8007f0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	8b 00                	mov    (%rax),%eax
  8007a8:	83 f8 30             	cmp    $0x30,%eax
  8007ab:	73 24                	jae    8007d1 <getint+0xeb>
  8007ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b9:	8b 00                	mov    (%rax),%eax
  8007bb:	89 c0                	mov    %eax,%eax
  8007bd:	48 01 d0             	add    %rdx,%rax
  8007c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c4:	8b 12                	mov    (%rdx),%edx
  8007c6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cd:	89 0a                	mov    %ecx,(%rdx)
  8007cf:	eb 17                	jmp    8007e8 <getint+0x102>
  8007d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d9:	48 89 d0             	mov    %rdx,%rax
  8007dc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e8:	8b 00                	mov    (%rax),%eax
  8007ea:	48 98                	cltq   
  8007ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007f4:	c9                   	leaveq 
  8007f5:	c3                   	retq   

00000000008007f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f6:	55                   	push   %rbp
  8007f7:	48 89 e5             	mov    %rsp,%rbp
  8007fa:	41 54                	push   %r12
  8007fc:	53                   	push   %rbx
  8007fd:	48 83 ec 60          	sub    $0x60,%rsp
  800801:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800805:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800809:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80080d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800811:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800815:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800819:	48 8b 0a             	mov    (%rdx),%rcx
  80081c:	48 89 08             	mov    %rcx,(%rax)
  80081f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800823:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800827:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80082b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082f:	eb 17                	jmp    800848 <vprintfmt+0x52>
			if (ch == '\0')
  800831:	85 db                	test   %ebx,%ebx
  800833:	0f 84 df 04 00 00    	je     800d18 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800839:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80083d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800841:	48 89 d6             	mov    %rdx,%rsi
  800844:	89 df                	mov    %ebx,%edi
  800846:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800848:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80084c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800850:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800854:	0f b6 00             	movzbl (%rax),%eax
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	83 fb 25             	cmp    $0x25,%ebx
  80085d:	75 d2                	jne    800831 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800863:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80086a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800871:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800878:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800883:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800887:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088b:	0f b6 00             	movzbl (%rax),%eax
  80088e:	0f b6 d8             	movzbl %al,%ebx
  800891:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800894:	83 f8 55             	cmp    $0x55,%eax
  800897:	0f 87 47 04 00 00    	ja     800ce4 <vprintfmt+0x4ee>
  80089d:	89 c0                	mov    %eax,%eax
  80089f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008a6:	00 
  8008a7:	48 b8 f8 3a 80 00 00 	movabs $0x803af8,%rax
  8008ae:	00 00 00 
  8008b1:	48 01 d0             	add    %rdx,%rax
  8008b4:	48 8b 00             	mov    (%rax),%rax
  8008b7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008b9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008bd:	eb c0                	jmp    80087f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008bf:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008c3:	eb ba                	jmp    80087f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008cc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008cf:	89 d0                	mov    %edx,%eax
  8008d1:	c1 e0 02             	shl    $0x2,%eax
  8008d4:	01 d0                	add    %edx,%eax
  8008d6:	01 c0                	add    %eax,%eax
  8008d8:	01 d8                	add    %ebx,%eax
  8008da:	83 e8 30             	sub    $0x30,%eax
  8008dd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008e0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e4:	0f b6 00             	movzbl (%rax),%eax
  8008e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8008ed:	7e 0c                	jle    8008fb <vprintfmt+0x105>
  8008ef:	83 fb 39             	cmp    $0x39,%ebx
  8008f2:	7f 07                	jg     8008fb <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008f9:	eb d1                	jmp    8008cc <vprintfmt+0xd6>
			goto process_precision;
  8008fb:	eb 58                	jmp    800955 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8008fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800900:	83 f8 30             	cmp    $0x30,%eax
  800903:	73 17                	jae    80091c <vprintfmt+0x126>
  800905:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800909:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 01 d0             	add    %rdx,%rax
  800911:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800914:	83 c2 08             	add    $0x8,%edx
  800917:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80091a:	eb 0f                	jmp    80092b <vprintfmt+0x135>
  80091c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800920:	48 89 d0             	mov    %rdx,%rax
  800923:	48 83 c2 08          	add    $0x8,%rdx
  800927:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80092b:	8b 00                	mov    (%rax),%eax
  80092d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800930:	eb 23                	jmp    800955 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800932:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800936:	79 0c                	jns    800944 <vprintfmt+0x14e>
				width = 0;
  800938:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80093f:	e9 3b ff ff ff       	jmpq   80087f <vprintfmt+0x89>
  800944:	e9 36 ff ff ff       	jmpq   80087f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800949:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800950:	e9 2a ff ff ff       	jmpq   80087f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800955:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800959:	79 12                	jns    80096d <vprintfmt+0x177>
				width = precision, precision = -1;
  80095b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80095e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800961:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800968:	e9 12 ff ff ff       	jmpq   80087f <vprintfmt+0x89>
  80096d:	e9 0d ff ff ff       	jmpq   80087f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800972:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800976:	e9 04 ff ff ff       	jmpq   80087f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80097b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097e:	83 f8 30             	cmp    $0x30,%eax
  800981:	73 17                	jae    80099a <vprintfmt+0x1a4>
  800983:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800987:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098a:	89 c0                	mov    %eax,%eax
  80098c:	48 01 d0             	add    %rdx,%rax
  80098f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800992:	83 c2 08             	add    $0x8,%edx
  800995:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800998:	eb 0f                	jmp    8009a9 <vprintfmt+0x1b3>
  80099a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099e:	48 89 d0             	mov    %rdx,%rax
  8009a1:	48 83 c2 08          	add    $0x8,%rdx
  8009a5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a9:	8b 10                	mov    (%rax),%edx
  8009ab:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b3:	48 89 ce             	mov    %rcx,%rsi
  8009b6:	89 d7                	mov    %edx,%edi
  8009b8:	ff d0                	callq  *%rax
			break;
  8009ba:	e9 53 03 00 00       	jmpq   800d12 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c2:	83 f8 30             	cmp    $0x30,%eax
  8009c5:	73 17                	jae    8009de <vprintfmt+0x1e8>
  8009c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ce:	89 c0                	mov    %eax,%eax
  8009d0:	48 01 d0             	add    %rdx,%rax
  8009d3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d6:	83 c2 08             	add    $0x8,%edx
  8009d9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009dc:	eb 0f                	jmp    8009ed <vprintfmt+0x1f7>
  8009de:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 83 c2 08          	add    $0x8,%rdx
  8009e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ed:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	79 02                	jns    8009f5 <vprintfmt+0x1ff>
				err = -err;
  8009f3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009f5:	83 fb 15             	cmp    $0x15,%ebx
  8009f8:	7f 16                	jg     800a10 <vprintfmt+0x21a>
  8009fa:	48 b8 20 3a 80 00 00 	movabs $0x803a20,%rax
  800a01:	00 00 00 
  800a04:	48 63 d3             	movslq %ebx,%rdx
  800a07:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a0b:	4d 85 e4             	test   %r12,%r12
  800a0e:	75 2e                	jne    800a3e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a10:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a18:	89 d9                	mov    %ebx,%ecx
  800a1a:	48 ba e1 3a 80 00 00 	movabs $0x803ae1,%rdx
  800a21:	00 00 00 
  800a24:	48 89 c7             	mov    %rax,%rdi
  800a27:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2c:	49 b8 21 0d 80 00 00 	movabs $0x800d21,%r8
  800a33:	00 00 00 
  800a36:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a39:	e9 d4 02 00 00       	jmpq   800d12 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a3e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a46:	4c 89 e1             	mov    %r12,%rcx
  800a49:	48 ba ea 3a 80 00 00 	movabs $0x803aea,%rdx
  800a50:	00 00 00 
  800a53:	48 89 c7             	mov    %rax,%rdi
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	49 b8 21 0d 80 00 00 	movabs $0x800d21,%r8
  800a62:	00 00 00 
  800a65:	41 ff d0             	callq  *%r8
			break;
  800a68:	e9 a5 02 00 00       	jmpq   800d12 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 30             	cmp    $0x30,%eax
  800a73:	73 17                	jae    800a8c <vprintfmt+0x296>
  800a75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	89 c0                	mov    %eax,%eax
  800a7e:	48 01 d0             	add    %rdx,%rax
  800a81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a84:	83 c2 08             	add    $0x8,%edx
  800a87:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8a:	eb 0f                	jmp    800a9b <vprintfmt+0x2a5>
  800a8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a90:	48 89 d0             	mov    %rdx,%rax
  800a93:	48 83 c2 08          	add    $0x8,%rdx
  800a97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9b:	4c 8b 20             	mov    (%rax),%r12
  800a9e:	4d 85 e4             	test   %r12,%r12
  800aa1:	75 0a                	jne    800aad <vprintfmt+0x2b7>
				p = "(null)";
  800aa3:	49 bc ed 3a 80 00 00 	movabs $0x803aed,%r12
  800aaa:	00 00 00 
			if (width > 0 && padc != '-')
  800aad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab1:	7e 3f                	jle    800af2 <vprintfmt+0x2fc>
  800ab3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ab7:	74 39                	je     800af2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800abc:	48 98                	cltq   
  800abe:	48 89 c6             	mov    %rax,%rsi
  800ac1:	4c 89 e7             	mov    %r12,%rdi
  800ac4:	48 b8 cd 0f 80 00 00 	movabs $0x800fcd,%rax
  800acb:	00 00 00 
  800ace:	ff d0                	callq  *%rax
  800ad0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ad3:	eb 17                	jmp    800aec <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ad5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ad9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800add:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae1:	48 89 ce             	mov    %rcx,%rsi
  800ae4:	89 d7                	mov    %edx,%edi
  800ae6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aec:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af0:	7f e3                	jg     800ad5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af2:	eb 37                	jmp    800b2b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800af4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800af8:	74 1e                	je     800b18 <vprintfmt+0x322>
  800afa:	83 fb 1f             	cmp    $0x1f,%ebx
  800afd:	7e 05                	jle    800b04 <vprintfmt+0x30e>
  800aff:	83 fb 7e             	cmp    $0x7e,%ebx
  800b02:	7e 14                	jle    800b18 <vprintfmt+0x322>
					putch('?', putdat);
  800b04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0c:	48 89 d6             	mov    %rdx,%rsi
  800b0f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b14:	ff d0                	callq  *%rax
  800b16:	eb 0f                	jmp    800b27 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b20:	48 89 d6             	mov    %rdx,%rsi
  800b23:	89 df                	mov    %ebx,%edi
  800b25:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b27:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b2b:	4c 89 e0             	mov    %r12,%rax
  800b2e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b32:	0f b6 00             	movzbl (%rax),%eax
  800b35:	0f be d8             	movsbl %al,%ebx
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	74 10                	je     800b4c <vprintfmt+0x356>
  800b3c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b40:	78 b2                	js     800af4 <vprintfmt+0x2fe>
  800b42:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b46:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b4a:	79 a8                	jns    800af4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4c:	eb 16                	jmp    800b64 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b56:	48 89 d6             	mov    %rdx,%rsi
  800b59:	bf 20 00 00 00       	mov    $0x20,%edi
  800b5e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b60:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b68:	7f e4                	jg     800b4e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b6a:	e9 a3 01 00 00       	jmpq   800d12 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b73:	be 03 00 00 00       	mov    $0x3,%esi
  800b78:	48 89 c7             	mov    %rax,%rdi
  800b7b:	48 b8 e6 06 80 00 00 	movabs $0x8006e6,%rax
  800b82:	00 00 00 
  800b85:	ff d0                	callq  *%rax
  800b87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8f:	48 85 c0             	test   %rax,%rax
  800b92:	79 1d                	jns    800bb1 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9c:	48 89 d6             	mov    %rdx,%rsi
  800b9f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ba4:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ba6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800baa:	48 f7 d8             	neg    %rax
  800bad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bb1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bb8:	e9 e8 00 00 00       	jmpq   800ca5 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bbd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc1:	be 03 00 00 00       	mov    $0x3,%esi
  800bc6:	48 89 c7             	mov    %rax,%rdi
  800bc9:	48 b8 d6 05 80 00 00 	movabs $0x8005d6,%rax
  800bd0:	00 00 00 
  800bd3:	ff d0                	callq  *%rax
  800bd5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bd9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be0:	e9 c0 00 00 00       	jmpq   800ca5 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bed:	48 89 d6             	mov    %rdx,%rsi
  800bf0:	bf 58 00 00 00       	mov    $0x58,%edi
  800bf5:	ff d0                	callq  *%rax
			putch('X', putdat);
  800bf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bff:	48 89 d6             	mov    %rdx,%rsi
  800c02:	bf 58 00 00 00       	mov    $0x58,%edi
  800c07:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c11:	48 89 d6             	mov    %rdx,%rsi
  800c14:	bf 58 00 00 00       	mov    $0x58,%edi
  800c19:	ff d0                	callq  *%rax
			break;
  800c1b:	e9 f2 00 00 00       	jmpq   800d12 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c28:	48 89 d6             	mov    %rdx,%rsi
  800c2b:	bf 30 00 00 00       	mov    $0x30,%edi
  800c30:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3a:	48 89 d6             	mov    %rdx,%rsi
  800c3d:	bf 78 00 00 00       	mov    $0x78,%edi
  800c42:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c47:	83 f8 30             	cmp    $0x30,%eax
  800c4a:	73 17                	jae    800c63 <vprintfmt+0x46d>
  800c4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c53:	89 c0                	mov    %eax,%eax
  800c55:	48 01 d0             	add    %rdx,%rax
  800c58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c5b:	83 c2 08             	add    $0x8,%edx
  800c5e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c61:	eb 0f                	jmp    800c72 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800c63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c67:	48 89 d0             	mov    %rdx,%rax
  800c6a:	48 83 c2 08          	add    $0x8,%rdx
  800c6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c72:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c79:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c80:	eb 23                	jmp    800ca5 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c82:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c86:	be 03 00 00 00       	mov    $0x3,%esi
  800c8b:	48 89 c7             	mov    %rax,%rdi
  800c8e:	48 b8 d6 05 80 00 00 	movabs $0x8005d6,%rax
  800c95:	00 00 00 
  800c98:	ff d0                	callq  *%rax
  800c9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c9e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ca5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800caa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cad:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cb4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbc:	45 89 c1             	mov    %r8d,%r9d
  800cbf:	41 89 f8             	mov    %edi,%r8d
  800cc2:	48 89 c7             	mov    %rax,%rdi
  800cc5:	48 b8 1b 05 80 00 00 	movabs $0x80051b,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
			break;
  800cd1:	eb 3f                	jmp    800d12 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdb:	48 89 d6             	mov    %rdx,%rsi
  800cde:	89 df                	mov    %ebx,%edi
  800ce0:	ff d0                	callq  *%rax
			break;
  800ce2:	eb 2e                	jmp    800d12 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cec:	48 89 d6             	mov    %rdx,%rsi
  800cef:	bf 25 00 00 00       	mov    $0x25,%edi
  800cf4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cfb:	eb 05                	jmp    800d02 <vprintfmt+0x50c>
  800cfd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d02:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d06:	48 83 e8 01          	sub    $0x1,%rax
  800d0a:	0f b6 00             	movzbl (%rax),%eax
  800d0d:	3c 25                	cmp    $0x25,%al
  800d0f:	75 ec                	jne    800cfd <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d11:	90                   	nop
		}
	}
  800d12:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d13:	e9 30 fb ff ff       	jmpq   800848 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d18:	48 83 c4 60          	add    $0x60,%rsp
  800d1c:	5b                   	pop    %rbx
  800d1d:	41 5c                	pop    %r12
  800d1f:	5d                   	pop    %rbp
  800d20:	c3                   	retq   

0000000000800d21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d21:	55                   	push   %rbp
  800d22:	48 89 e5             	mov    %rsp,%rbp
  800d25:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d2c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d3a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d41:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d48:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d4f:	84 c0                	test   %al,%al
  800d51:	74 20                	je     800d73 <printfmt+0x52>
  800d53:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d57:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d5b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d5f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d63:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d67:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d6b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d6f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d73:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d7a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d81:	00 00 00 
  800d84:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d8b:	00 00 00 
  800d8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d92:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800da0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800da7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800db5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dbc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dc3:	48 89 c7             	mov    %rax,%rdi
  800dc6:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  800dcd:	00 00 00 
  800dd0:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dd2:	c9                   	leaveq 
  800dd3:	c3                   	retq   

0000000000800dd4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dd4:	55                   	push   %rbp
  800dd5:	48 89 e5             	mov    %rsp,%rbp
  800dd8:	48 83 ec 10          	sub    $0x10,%rsp
  800ddc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ddf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de7:	8b 40 10             	mov    0x10(%rax),%eax
  800dea:	8d 50 01             	lea    0x1(%rax),%edx
  800ded:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df8:	48 8b 10             	mov    (%rax),%rdx
  800dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dff:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e03:	48 39 c2             	cmp    %rax,%rdx
  800e06:	73 17                	jae    800e1f <sprintputch+0x4b>
		*b->buf++ = ch;
  800e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0c:	48 8b 00             	mov    (%rax),%rax
  800e0f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e17:	48 89 0a             	mov    %rcx,(%rdx)
  800e1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e1d:	88 10                	mov    %dl,(%rax)
}
  800e1f:	c9                   	leaveq 
  800e20:	c3                   	retq   

0000000000800e21 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e21:	55                   	push   %rbp
  800e22:	48 89 e5             	mov    %rsp,%rbp
  800e25:	48 83 ec 50          	sub    $0x50,%rsp
  800e29:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e2d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e30:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e34:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e38:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e3c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e40:	48 8b 0a             	mov    (%rdx),%rcx
  800e43:	48 89 08             	mov    %rcx,(%rax)
  800e46:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e4a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e4e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e52:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e56:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e5a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e5e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e61:	48 98                	cltq   
  800e63:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e6b:	48 01 d0             	add    %rdx,%rax
  800e6e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e79:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e7e:	74 06                	je     800e86 <vsnprintf+0x65>
  800e80:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e84:	7f 07                	jg     800e8d <vsnprintf+0x6c>
		return -E_INVAL;
  800e86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8b:	eb 2f                	jmp    800ebc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e8d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e91:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e95:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e99:	48 89 c6             	mov    %rax,%rsi
  800e9c:	48 bf d4 0d 80 00 00 	movabs $0x800dd4,%rdi
  800ea3:	00 00 00 
  800ea6:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  800ead:	00 00 00 
  800eb0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800eb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eb9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ebc:	c9                   	leaveq 
  800ebd:	c3                   	retq   

0000000000800ebe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ebe:	55                   	push   %rbp
  800ebf:	48 89 e5             	mov    %rsp,%rbp
  800ec2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ec9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ed0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ed6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800edd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ee4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 20                	je     800f0f <snprintf+0x51>
  800eef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ef3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ef7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800efb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f03:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f07:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f0b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f0f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f16:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f1d:	00 00 00 
  800f20:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f27:	00 00 00 
  800f2a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f2e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f35:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f3c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f43:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f4a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f51:	48 8b 0a             	mov    (%rdx),%rcx
  800f54:	48 89 08             	mov    %rcx,(%rax)
  800f57:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f5b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f5f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f63:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f67:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f6e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f75:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f7b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f82:	48 89 c7             	mov    %rax,%rdi
  800f85:	48 b8 21 0e 80 00 00 	movabs $0x800e21,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	callq  *%rax
  800f91:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f97:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f9d:	c9                   	leaveq 
  800f9e:	c3                   	retq   

0000000000800f9f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f9f:	55                   	push   %rbp
  800fa0:	48 89 e5             	mov    %rsp,%rbp
  800fa3:	48 83 ec 18          	sub    $0x18,%rsp
  800fa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fb2:	eb 09                	jmp    800fbd <strlen+0x1e>
		n++;
  800fb4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fb8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc1:	0f b6 00             	movzbl (%rax),%eax
  800fc4:	84 c0                	test   %al,%al
  800fc6:	75 ec                	jne    800fb4 <strlen+0x15>
		n++;
	return n;
  800fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fcb:	c9                   	leaveq 
  800fcc:	c3                   	retq   

0000000000800fcd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fcd:	55                   	push   %rbp
  800fce:	48 89 e5             	mov    %rsp,%rbp
  800fd1:	48 83 ec 20          	sub    $0x20,%rsp
  800fd5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fe4:	eb 0e                	jmp    800ff4 <strnlen+0x27>
		n++;
  800fe6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fef:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ff4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ff9:	74 0b                	je     801006 <strnlen+0x39>
  800ffb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fff:	0f b6 00             	movzbl (%rax),%eax
  801002:	84 c0                	test   %al,%al
  801004:	75 e0                	jne    800fe6 <strnlen+0x19>
		n++;
	return n;
  801006:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   

000000000080100b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	48 83 ec 20          	sub    $0x20,%rsp
  801013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801017:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80101b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801023:	90                   	nop
  801024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801028:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80102c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801030:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801034:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801038:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80103c:	0f b6 12             	movzbl (%rdx),%edx
  80103f:	88 10                	mov    %dl,(%rax)
  801041:	0f b6 00             	movzbl (%rax),%eax
  801044:	84 c0                	test   %al,%al
  801046:	75 dc                	jne    801024 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80104c:	c9                   	leaveq 
  80104d:	c3                   	retq   

000000000080104e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80104e:	55                   	push   %rbp
  80104f:	48 89 e5             	mov    %rsp,%rbp
  801052:	48 83 ec 20          	sub    $0x20,%rsp
  801056:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80105e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801062:	48 89 c7             	mov    %rax,%rdi
  801065:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  80106c:	00 00 00 
  80106f:	ff d0                	callq  *%rax
  801071:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801077:	48 63 d0             	movslq %eax,%rdx
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	48 01 c2             	add    %rax,%rdx
  801081:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801085:	48 89 c6             	mov    %rax,%rsi
  801088:	48 89 d7             	mov    %rdx,%rdi
  80108b:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  801092:	00 00 00 
  801095:	ff d0                	callq  *%rax
	return dst;
  801097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80109b:	c9                   	leaveq 
  80109c:	c3                   	retq   

000000000080109d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80109d:	55                   	push   %rbp
  80109e:	48 89 e5             	mov    %rsp,%rbp
  8010a1:	48 83 ec 28          	sub    $0x28,%rsp
  8010a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010c0:	00 
  8010c1:	eb 2a                	jmp    8010ed <strncpy+0x50>
		*dst++ = *src;
  8010c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010d3:	0f b6 12             	movzbl (%rdx),%edx
  8010d6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010dc:	0f b6 00             	movzbl (%rax),%eax
  8010df:	84 c0                	test   %al,%al
  8010e1:	74 05                	je     8010e8 <strncpy+0x4b>
			src++;
  8010e3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010f5:	72 cc                	jb     8010c3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010fb:	c9                   	leaveq 
  8010fc:	c3                   	retq   

00000000008010fd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010fd:	55                   	push   %rbp
  8010fe:	48 89 e5             	mov    %rsp,%rbp
  801101:	48 83 ec 28          	sub    $0x28,%rsp
  801105:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801109:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80110d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801115:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801119:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80111e:	74 3d                	je     80115d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801120:	eb 1d                	jmp    80113f <strlcpy+0x42>
			*dst++ = *src++;
  801122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80112e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801132:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801136:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80113a:	0f b6 12             	movzbl (%rdx),%edx
  80113d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801144:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801149:	74 0b                	je     801156 <strlcpy+0x59>
  80114b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80114f:	0f b6 00             	movzbl (%rax),%eax
  801152:	84 c0                	test   %al,%al
  801154:	75 cc                	jne    801122 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80115d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801161:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801165:	48 29 c2             	sub    %rax,%rdx
  801168:	48 89 d0             	mov    %rdx,%rax
}
  80116b:	c9                   	leaveq 
  80116c:	c3                   	retq   

000000000080116d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80116d:	55                   	push   %rbp
  80116e:	48 89 e5             	mov    %rsp,%rbp
  801171:	48 83 ec 10          	sub    $0x10,%rsp
  801175:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801179:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80117d:	eb 0a                	jmp    801189 <strcmp+0x1c>
		p++, q++;
  80117f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801184:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118d:	0f b6 00             	movzbl (%rax),%eax
  801190:	84 c0                	test   %al,%al
  801192:	74 12                	je     8011a6 <strcmp+0x39>
  801194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801198:	0f b6 10             	movzbl (%rax),%edx
  80119b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119f:	0f b6 00             	movzbl (%rax),%eax
  8011a2:	38 c2                	cmp    %al,%dl
  8011a4:	74 d9                	je     80117f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011aa:	0f b6 00             	movzbl (%rax),%eax
  8011ad:	0f b6 d0             	movzbl %al,%edx
  8011b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b4:	0f b6 00             	movzbl (%rax),%eax
  8011b7:	0f b6 c0             	movzbl %al,%eax
  8011ba:	29 c2                	sub    %eax,%edx
  8011bc:	89 d0                	mov    %edx,%eax
}
  8011be:	c9                   	leaveq 
  8011bf:	c3                   	retq   

00000000008011c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
  8011c4:	48 83 ec 18          	sub    $0x18,%rsp
  8011c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011d4:	eb 0f                	jmp    8011e5 <strncmp+0x25>
		n--, p++, q++;
  8011d6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011ea:	74 1d                	je     801209 <strncmp+0x49>
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	84 c0                	test   %al,%al
  8011f5:	74 12                	je     801209 <strncmp+0x49>
  8011f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fb:	0f b6 10             	movzbl (%rax),%edx
  8011fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801202:	0f b6 00             	movzbl (%rax),%eax
  801205:	38 c2                	cmp    %al,%dl
  801207:	74 cd                	je     8011d6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801209:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80120e:	75 07                	jne    801217 <strncmp+0x57>
		return 0;
  801210:	b8 00 00 00 00       	mov    $0x0,%eax
  801215:	eb 18                	jmp    80122f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121b:	0f b6 00             	movzbl (%rax),%eax
  80121e:	0f b6 d0             	movzbl %al,%edx
  801221:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801225:	0f b6 00             	movzbl (%rax),%eax
  801228:	0f b6 c0             	movzbl %al,%eax
  80122b:	29 c2                	sub    %eax,%edx
  80122d:	89 d0                	mov    %edx,%eax
}
  80122f:	c9                   	leaveq 
  801230:	c3                   	retq   

0000000000801231 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801231:	55                   	push   %rbp
  801232:	48 89 e5             	mov    %rsp,%rbp
  801235:	48 83 ec 0c          	sub    $0xc,%rsp
  801239:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80123d:	89 f0                	mov    %esi,%eax
  80123f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801242:	eb 17                	jmp    80125b <strchr+0x2a>
		if (*s == c)
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80124e:	75 06                	jne    801256 <strchr+0x25>
			return (char *) s;
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	eb 15                	jmp    80126b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801256:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	75 de                	jne    801244 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80126b:	c9                   	leaveq 
  80126c:	c3                   	retq   

000000000080126d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80126d:	55                   	push   %rbp
  80126e:	48 89 e5             	mov    %rsp,%rbp
  801271:	48 83 ec 0c          	sub    $0xc,%rsp
  801275:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801279:	89 f0                	mov    %esi,%eax
  80127b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80127e:	eb 13                	jmp    801293 <strfind+0x26>
		if (*s == c)
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80128a:	75 02                	jne    80128e <strfind+0x21>
			break;
  80128c:	eb 10                	jmp    80129e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80128e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801297:	0f b6 00             	movzbl (%rax),%eax
  80129a:	84 c0                	test   %al,%al
  80129c:	75 e2                	jne    801280 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80129e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a2:	c9                   	leaveq 
  8012a3:	c3                   	retq   

00000000008012a4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012a4:	55                   	push   %rbp
  8012a5:	48 89 e5             	mov    %rsp,%rbp
  8012a8:	48 83 ec 18          	sub    $0x18,%rsp
  8012ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012bc:	75 06                	jne    8012c4 <memset+0x20>
		return v;
  8012be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c2:	eb 69                	jmp    80132d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c8:	83 e0 03             	and    $0x3,%eax
  8012cb:	48 85 c0             	test   %rax,%rax
  8012ce:	75 48                	jne    801318 <memset+0x74>
  8012d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d4:	83 e0 03             	and    $0x3,%eax
  8012d7:	48 85 c0             	test   %rax,%rax
  8012da:	75 3c                	jne    801318 <memset+0x74>
		c &= 0xFF;
  8012dc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e6:	c1 e0 18             	shl    $0x18,%eax
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ee:	c1 e0 10             	shl    $0x10,%eax
  8012f1:	09 c2                	or     %eax,%edx
  8012f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f6:	c1 e0 08             	shl    $0x8,%eax
  8012f9:	09 d0                	or     %edx,%eax
  8012fb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801302:	48 c1 e8 02          	shr    $0x2,%rax
  801306:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801309:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80130d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801310:	48 89 d7             	mov    %rdx,%rdi
  801313:	fc                   	cld    
  801314:	f3 ab                	rep stos %eax,%es:(%rdi)
  801316:	eb 11                	jmp    801329 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801318:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80131c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801323:	48 89 d7             	mov    %rdx,%rdi
  801326:	fc                   	cld    
  801327:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80132d:	c9                   	leaveq 
  80132e:	c3                   	retq   

000000000080132f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80132f:	55                   	push   %rbp
  801330:	48 89 e5             	mov    %rsp,%rbp
  801333:	48 83 ec 28          	sub    $0x28,%rsp
  801337:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80133f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801343:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801347:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801357:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80135b:	0f 83 88 00 00 00    	jae    8013e9 <memmove+0xba>
  801361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801365:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801369:	48 01 d0             	add    %rdx,%rax
  80136c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801370:	76 77                	jbe    8013e9 <memmove+0xba>
		s += n;
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80137a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	83 e0 03             	and    $0x3,%eax
  801389:	48 85 c0             	test   %rax,%rax
  80138c:	75 3b                	jne    8013c9 <memmove+0x9a>
  80138e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801392:	83 e0 03             	and    $0x3,%eax
  801395:	48 85 c0             	test   %rax,%rax
  801398:	75 2f                	jne    8013c9 <memmove+0x9a>
  80139a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139e:	83 e0 03             	and    $0x3,%eax
  8013a1:	48 85 c0             	test   %rax,%rax
  8013a4:	75 23                	jne    8013c9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013aa:	48 83 e8 04          	sub    $0x4,%rax
  8013ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b2:	48 83 ea 04          	sub    $0x4,%rdx
  8013b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ba:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013be:	48 89 c7             	mov    %rax,%rdi
  8013c1:	48 89 d6             	mov    %rdx,%rsi
  8013c4:	fd                   	std    
  8013c5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013c7:	eb 1d                	jmp    8013e6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dd:	48 89 d7             	mov    %rdx,%rdi
  8013e0:	48 89 c1             	mov    %rax,%rcx
  8013e3:	fd                   	std    
  8013e4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013e6:	fc                   	cld    
  8013e7:	eb 57                	jmp    801440 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ed:	83 e0 03             	and    $0x3,%eax
  8013f0:	48 85 c0             	test   %rax,%rax
  8013f3:	75 36                	jne    80142b <memmove+0xfc>
  8013f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f9:	83 e0 03             	and    $0x3,%eax
  8013fc:	48 85 c0             	test   %rax,%rax
  8013ff:	75 2a                	jne    80142b <memmove+0xfc>
  801401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801405:	83 e0 03             	and    $0x3,%eax
  801408:	48 85 c0             	test   %rax,%rax
  80140b:	75 1e                	jne    80142b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80140d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801411:	48 c1 e8 02          	shr    $0x2,%rax
  801415:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801420:	48 89 c7             	mov    %rax,%rdi
  801423:	48 89 d6             	mov    %rdx,%rsi
  801426:	fc                   	cld    
  801427:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801429:	eb 15                	jmp    801440 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80142b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801433:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801437:	48 89 c7             	mov    %rax,%rdi
  80143a:	48 89 d6             	mov    %rdx,%rsi
  80143d:	fc                   	cld    
  80143e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801444:	c9                   	leaveq 
  801445:	c3                   	retq   

0000000000801446 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801446:	55                   	push   %rbp
  801447:	48 89 e5             	mov    %rsp,%rbp
  80144a:	48 83 ec 18          	sub    $0x18,%rsp
  80144e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801452:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801456:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80145a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80145e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801466:	48 89 ce             	mov    %rcx,%rsi
  801469:	48 89 c7             	mov    %rax,%rdi
  80146c:	48 b8 2f 13 80 00 00 	movabs $0x80132f,%rax
  801473:	00 00 00 
  801476:	ff d0                	callq  *%rax
}
  801478:	c9                   	leaveq 
  801479:	c3                   	retq   

000000000080147a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80147a:	55                   	push   %rbp
  80147b:	48 89 e5             	mov    %rsp,%rbp
  80147e:	48 83 ec 28          	sub    $0x28,%rsp
  801482:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801486:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80148a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80148e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801492:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801496:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80149a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80149e:	eb 36                	jmp    8014d6 <memcmp+0x5c>
		if (*s1 != *s2)
  8014a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a4:	0f b6 10             	movzbl (%rax),%edx
  8014a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	38 c2                	cmp    %al,%dl
  8014b0:	74 1a                	je     8014cc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	0f b6 d0             	movzbl %al,%edx
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	0f b6 c0             	movzbl %al,%eax
  8014c6:	29 c2                	sub    %eax,%edx
  8014c8:	89 d0                	mov    %edx,%eax
  8014ca:	eb 20                	jmp    8014ec <memcmp+0x72>
		s1++, s2++;
  8014cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014da:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014e2:	48 85 c0             	test   %rax,%rax
  8014e5:	75 b9                	jne    8014a0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ec:	c9                   	leaveq 
  8014ed:	c3                   	retq   

00000000008014ee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014ee:	55                   	push   %rbp
  8014ef:	48 89 e5             	mov    %rsp,%rbp
  8014f2:	48 83 ec 28          	sub    $0x28,%rsp
  8014f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801509:	48 01 d0             	add    %rdx,%rax
  80150c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801510:	eb 15                	jmp    801527 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801516:	0f b6 10             	movzbl (%rax),%edx
  801519:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80151c:	38 c2                	cmp    %al,%dl
  80151e:	75 02                	jne    801522 <memfind+0x34>
			break;
  801520:	eb 0f                	jmp    801531 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801522:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80152f:	72 e1                	jb     801512 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 34          	sub    $0x34,%rsp
  80153f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801543:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801547:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80154a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801551:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801558:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801559:	eb 05                	jmp    801560 <strtol+0x29>
		s++;
  80155b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	0f b6 00             	movzbl (%rax),%eax
  801567:	3c 20                	cmp    $0x20,%al
  801569:	74 f0                	je     80155b <strtol+0x24>
  80156b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156f:	0f b6 00             	movzbl (%rax),%eax
  801572:	3c 09                	cmp    $0x9,%al
  801574:	74 e5                	je     80155b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157a:	0f b6 00             	movzbl (%rax),%eax
  80157d:	3c 2b                	cmp    $0x2b,%al
  80157f:	75 07                	jne    801588 <strtol+0x51>
		s++;
  801581:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801586:	eb 17                	jmp    80159f <strtol+0x68>
	else if (*s == '-')
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	0f b6 00             	movzbl (%rax),%eax
  80158f:	3c 2d                	cmp    $0x2d,%al
  801591:	75 0c                	jne    80159f <strtol+0x68>
		s++, neg = 1;
  801593:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801598:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80159f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015a3:	74 06                	je     8015ab <strtol+0x74>
  8015a5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015a9:	75 28                	jne    8015d3 <strtol+0x9c>
  8015ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015af:	0f b6 00             	movzbl (%rax),%eax
  8015b2:	3c 30                	cmp    $0x30,%al
  8015b4:	75 1d                	jne    8015d3 <strtol+0x9c>
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	48 83 c0 01          	add    $0x1,%rax
  8015be:	0f b6 00             	movzbl (%rax),%eax
  8015c1:	3c 78                	cmp    $0x78,%al
  8015c3:	75 0e                	jne    8015d3 <strtol+0x9c>
		s += 2, base = 16;
  8015c5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015ca:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015d1:	eb 2c                	jmp    8015ff <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015d7:	75 19                	jne    8015f2 <strtol+0xbb>
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	3c 30                	cmp    $0x30,%al
  8015e2:	75 0e                	jne    8015f2 <strtol+0xbb>
		s++, base = 8;
  8015e4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015f0:	eb 0d                	jmp    8015ff <strtol+0xc8>
	else if (base == 0)
  8015f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f6:	75 07                	jne    8015ff <strtol+0xc8>
		base = 10;
  8015f8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801603:	0f b6 00             	movzbl (%rax),%eax
  801606:	3c 2f                	cmp    $0x2f,%al
  801608:	7e 1d                	jle    801627 <strtol+0xf0>
  80160a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160e:	0f b6 00             	movzbl (%rax),%eax
  801611:	3c 39                	cmp    $0x39,%al
  801613:	7f 12                	jg     801627 <strtol+0xf0>
			dig = *s - '0';
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	0f be c0             	movsbl %al,%eax
  80161f:	83 e8 30             	sub    $0x30,%eax
  801622:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801625:	eb 4e                	jmp    801675 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801627:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162b:	0f b6 00             	movzbl (%rax),%eax
  80162e:	3c 60                	cmp    $0x60,%al
  801630:	7e 1d                	jle    80164f <strtol+0x118>
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	3c 7a                	cmp    $0x7a,%al
  80163b:	7f 12                	jg     80164f <strtol+0x118>
			dig = *s - 'a' + 10;
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	0f be c0             	movsbl %al,%eax
  801647:	83 e8 57             	sub    $0x57,%eax
  80164a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80164d:	eb 26                	jmp    801675 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80164f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801653:	0f b6 00             	movzbl (%rax),%eax
  801656:	3c 40                	cmp    $0x40,%al
  801658:	7e 48                	jle    8016a2 <strtol+0x16b>
  80165a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	3c 5a                	cmp    $0x5a,%al
  801663:	7f 3d                	jg     8016a2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	0f be c0             	movsbl %al,%eax
  80166f:	83 e8 37             	sub    $0x37,%eax
  801672:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801675:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801678:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80167b:	7c 02                	jl     80167f <strtol+0x148>
			break;
  80167d:	eb 23                	jmp    8016a2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80167f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801684:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801687:	48 98                	cltq   
  801689:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80168e:	48 89 c2             	mov    %rax,%rdx
  801691:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801694:	48 98                	cltq   
  801696:	48 01 d0             	add    %rdx,%rax
  801699:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80169d:	e9 5d ff ff ff       	jmpq   8015ff <strtol+0xc8>

	if (endptr)
  8016a2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016a7:	74 0b                	je     8016b4 <strtol+0x17d>
		*endptr = (char *) s;
  8016a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016b1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016b8:	74 09                	je     8016c3 <strtol+0x18c>
  8016ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016be:	48 f7 d8             	neg    %rax
  8016c1:	eb 04                	jmp    8016c7 <strtol+0x190>
  8016c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016c7:	c9                   	leaveq 
  8016c8:	c3                   	retq   

00000000008016c9 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016c9:	55                   	push   %rbp
  8016ca:	48 89 e5             	mov    %rsp,%rbp
  8016cd:	48 83 ec 30          	sub    $0x30,%rsp
  8016d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016e1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016e5:	0f b6 00             	movzbl (%rax),%eax
  8016e8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016eb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016ef:	75 06                	jne    8016f7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	eb 6b                	jmp    801762 <strstr+0x99>

	len = strlen(str);
  8016f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fb:	48 89 c7             	mov    %rax,%rdi
  8016fe:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  801705:	00 00 00 
  801708:	ff d0                	callq  *%rax
  80170a:	48 98                	cltq   
  80170c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801714:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801718:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80171c:	0f b6 00             	movzbl (%rax),%eax
  80171f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801722:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801726:	75 07                	jne    80172f <strstr+0x66>
				return (char *) 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 33                	jmp    801762 <strstr+0x99>
		} while (sc != c);
  80172f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801733:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801736:	75 d8                	jne    801710 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801738:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80173c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801744:	48 89 ce             	mov    %rcx,%rsi
  801747:	48 89 c7             	mov    %rax,%rdi
  80174a:	48 b8 c0 11 80 00 00 	movabs $0x8011c0,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
  801756:	85 c0                	test   %eax,%eax
  801758:	75 b6                	jne    801710 <strstr+0x47>

	return (char *) (in - 1);
  80175a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175e:	48 83 e8 01          	sub    $0x1,%rax
}
  801762:	c9                   	leaveq 
  801763:	c3                   	retq   

0000000000801764 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
  801768:	53                   	push   %rbx
  801769:	48 83 ec 48          	sub    $0x48,%rsp
  80176d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801770:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801773:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801777:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80177b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80177f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801783:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801786:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80178a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80178e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801792:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801796:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80179a:	4c 89 c3             	mov    %r8,%rbx
  80179d:	cd 30                	int    $0x30
  80179f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017a7:	74 3e                	je     8017e7 <syscall+0x83>
  8017a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ae:	7e 37                	jle    8017e7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017b7:	49 89 d0             	mov    %rdx,%r8
  8017ba:	89 c1                	mov    %eax,%ecx
  8017bc:	48 ba a8 3d 80 00 00 	movabs $0x803da8,%rdx
  8017c3:	00 00 00 
  8017c6:	be 23 00 00 00       	mov    $0x23,%esi
  8017cb:	48 bf c5 3d 80 00 00 	movabs $0x803dc5,%rdi
  8017d2:	00 00 00 
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	49 b9 0a 02 80 00 00 	movabs $0x80020a,%r9
  8017e1:	00 00 00 
  8017e4:	41 ff d1             	callq  *%r9

	return ret;
  8017e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017eb:	48 83 c4 48          	add    $0x48,%rsp
  8017ef:	5b                   	pop    %rbx
  8017f0:	5d                   	pop    %rbp
  8017f1:	c3                   	retq   

00000000008017f2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	48 83 ec 20          	sub    $0x20,%rsp
  8017fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801802:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801806:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80180a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801811:	00 
  801812:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801818:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80181e:	48 89 d1             	mov    %rdx,%rcx
  801821:	48 89 c2             	mov    %rax,%rdx
  801824:	be 00 00 00 00       	mov    $0x0,%esi
  801829:	bf 00 00 00 00       	mov    $0x0,%edi
  80182e:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801835:	00 00 00 
  801838:	ff d0                	callq  *%rax
}
  80183a:	c9                   	leaveq 
  80183b:	c3                   	retq   

000000000080183c <sys_cgetc>:

int
sys_cgetc(void)
{
  80183c:	55                   	push   %rbp
  80183d:	48 89 e5             	mov    %rsp,%rbp
  801840:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801844:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184b:	00 
  80184c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801852:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801858:	b9 00 00 00 00       	mov    $0x0,%ecx
  80185d:	ba 00 00 00 00       	mov    $0x0,%edx
  801862:	be 00 00 00 00       	mov    $0x0,%esi
  801867:	bf 01 00 00 00       	mov    $0x1,%edi
  80186c:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
}
  801878:	c9                   	leaveq 
  801879:	c3                   	retq   

000000000080187a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80187a:	55                   	push   %rbp
  80187b:	48 89 e5             	mov    %rsp,%rbp
  80187e:	48 83 ec 10          	sub    $0x10,%rsp
  801882:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801885:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801888:	48 98                	cltq   
  80188a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801891:	00 
  801892:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801898:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a3:	48 89 c2             	mov    %rax,%rdx
  8018a6:	be 01 00 00 00       	mov    $0x1,%esi
  8018ab:	bf 03 00 00 00       	mov    $0x3,%edi
  8018b0:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  8018b7:	00 00 00 
  8018ba:	ff d0                	callq  *%rax
}
  8018bc:	c9                   	leaveq 
  8018bd:	c3                   	retq   

00000000008018be <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018be:	55                   	push   %rbp
  8018bf:	48 89 e5             	mov    %rsp,%rbp
  8018c2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018cd:	00 
  8018ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	be 00 00 00 00       	mov    $0x0,%esi
  8018e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8018ee:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  8018f5:	00 00 00 
  8018f8:	ff d0                	callq  *%rax
}
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <sys_yield>:

void
sys_yield(void)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801904:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190b:	00 
  80190c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801912:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801918:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	be 00 00 00 00       	mov    $0x0,%esi
  801927:	bf 0b 00 00 00       	mov    $0xb,%edi
  80192c:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
}
  801938:	c9                   	leaveq 
  801939:	c3                   	retq   

000000000080193a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80193a:	55                   	push   %rbp
  80193b:	48 89 e5             	mov    %rsp,%rbp
  80193e:	48 83 ec 20          	sub    $0x20,%rsp
  801942:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801945:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801949:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80194c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80194f:	48 63 c8             	movslq %eax,%rcx
  801952:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801959:	48 98                	cltq   
  80195b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801962:	00 
  801963:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801969:	49 89 c8             	mov    %rcx,%r8
  80196c:	48 89 d1             	mov    %rdx,%rcx
  80196f:	48 89 c2             	mov    %rax,%rdx
  801972:	be 01 00 00 00       	mov    $0x1,%esi
  801977:	bf 04 00 00 00       	mov    $0x4,%edi
  80197c:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801983:	00 00 00 
  801986:	ff d0                	callq  *%rax
}
  801988:	c9                   	leaveq 
  801989:	c3                   	retq   

000000000080198a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80198a:	55                   	push   %rbp
  80198b:	48 89 e5             	mov    %rsp,%rbp
  80198e:	48 83 ec 30          	sub    $0x30,%rsp
  801992:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801995:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801999:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80199c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019a0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019a4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019a7:	48 63 c8             	movslq %eax,%rcx
  8019aa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b1:	48 63 f0             	movslq %eax,%rsi
  8019b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bb:	48 98                	cltq   
  8019bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019c1:	49 89 f9             	mov    %rdi,%r9
  8019c4:	49 89 f0             	mov    %rsi,%r8
  8019c7:	48 89 d1             	mov    %rdx,%rcx
  8019ca:	48 89 c2             	mov    %rax,%rdx
  8019cd:	be 01 00 00 00       	mov    $0x1,%esi
  8019d2:	bf 05 00 00 00       	mov    $0x5,%edi
  8019d7:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  8019de:	00 00 00 
  8019e1:	ff d0                	callq  *%rax
}
  8019e3:	c9                   	leaveq 
  8019e4:	c3                   	retq   

00000000008019e5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019e5:	55                   	push   %rbp
  8019e6:	48 89 e5             	mov    %rsp,%rbp
  8019e9:	48 83 ec 20          	sub    $0x20,%rsp
  8019ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fb:	48 98                	cltq   
  8019fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a04:	00 
  801a05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a11:	48 89 d1             	mov    %rdx,%rcx
  801a14:	48 89 c2             	mov    %rax,%rdx
  801a17:	be 01 00 00 00       	mov    $0x1,%esi
  801a1c:	bf 06 00 00 00       	mov    $0x6,%edi
  801a21:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   

0000000000801a2f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	48 83 ec 10          	sub    $0x10,%rsp
  801a37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a3a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a40:	48 63 d0             	movslq %eax,%rdx
  801a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a46:	48 98                	cltq   
  801a48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4f:	00 
  801a50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5c:	48 89 d1             	mov    %rdx,%rcx
  801a5f:	48 89 c2             	mov    %rax,%rdx
  801a62:	be 01 00 00 00       	mov    $0x1,%esi
  801a67:	bf 08 00 00 00       	mov    $0x8,%edi
  801a6c:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 20          	sub    $0x20,%rsp
  801a82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a90:	48 98                	cltq   
  801a92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a99:	00 
  801a9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa6:	48 89 d1             	mov    %rdx,%rcx
  801aa9:	48 89 c2             	mov    %rax,%rdx
  801aac:	be 01 00 00 00       	mov    $0x1,%esi
  801ab1:	bf 09 00 00 00       	mov    $0x9,%edi
  801ab6:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801abd:	00 00 00 
  801ac0:	ff d0                	callq  *%rax
}
  801ac2:	c9                   	leaveq 
  801ac3:	c3                   	retq   

0000000000801ac4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ac4:	55                   	push   %rbp
  801ac5:	48 89 e5             	mov    %rsp,%rbp
  801ac8:	48 83 ec 20          	sub    $0x20,%rsp
  801acc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801acf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ad3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ada:	48 98                	cltq   
  801adc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae3:	00 
  801ae4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af0:	48 89 d1             	mov    %rdx,%rcx
  801af3:	48 89 c2             	mov    %rax,%rdx
  801af6:	be 01 00 00 00       	mov    $0x1,%esi
  801afb:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b00:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801b07:	00 00 00 
  801b0a:	ff d0                	callq  *%rax
}
  801b0c:	c9                   	leaveq 
  801b0d:	c3                   	retq   

0000000000801b0e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	48 83 ec 20          	sub    $0x20,%rsp
  801b16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b21:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b27:	48 63 f0             	movslq %eax,%rsi
  801b2a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b31:	48 98                	cltq   
  801b33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3e:	00 
  801b3f:	49 89 f1             	mov    %rsi,%r9
  801b42:	49 89 c8             	mov    %rcx,%r8
  801b45:	48 89 d1             	mov    %rdx,%rcx
  801b48:	48 89 c2             	mov    %rax,%rdx
  801b4b:	be 00 00 00 00       	mov    $0x0,%esi
  801b50:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b55:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
}
  801b61:	c9                   	leaveq 
  801b62:	c3                   	retq   

0000000000801b63 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b63:	55                   	push   %rbp
  801b64:	48 89 e5             	mov    %rsp,%rbp
  801b67:	48 83 ec 10          	sub    $0x10,%rsp
  801b6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7a:	00 
  801b7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8c:	48 89 c2             	mov    %rax,%rdx
  801b8f:	be 01 00 00 00       	mov    $0x1,%esi
  801b94:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b99:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801ba0:	00 00 00 
  801ba3:	ff d0                	callq  *%rax
}
  801ba5:	c9                   	leaveq 
  801ba6:	c3                   	retq   

0000000000801ba7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ba7:	55                   	push   %rbp
  801ba8:	48 89 e5             	mov    %rsp,%rbp
  801bab:	48 83 ec 10          	sub    $0x10,%rsp
  801baf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801bb3:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801bba:	00 00 00 
  801bbd:	48 8b 00             	mov    (%rax),%rax
  801bc0:	48 85 c0             	test   %rax,%rax
  801bc3:	75 49                	jne    801c0e <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801bc5:	ba 07 00 00 00       	mov    $0x7,%edx
  801bca:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd4:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  801bdb:	00 00 00 
  801bde:	ff d0                	callq  *%rax
  801be0:	85 c0                	test   %eax,%eax
  801be2:	79 2a                	jns    801c0e <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801be4:	48 ba d8 3d 80 00 00 	movabs $0x803dd8,%rdx
  801beb:	00 00 00 
  801bee:	be 21 00 00 00       	mov    $0x21,%esi
  801bf3:	48 bf 03 3e 80 00 00 	movabs $0x803e03,%rdi
  801bfa:	00 00 00 
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801c02:	48 b9 0a 02 80 00 00 	movabs $0x80020a,%rcx
  801c09:	00 00 00 
  801c0c:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c0e:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801c15:	00 00 00 
  801c18:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c1c:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801c1f:	48 be 6a 1c 80 00 00 	movabs $0x801c6a,%rsi
  801c26:	00 00 00 
  801c29:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2e:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	79 2a                	jns    801c68 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801c3e:	48 ba 18 3e 80 00 00 	movabs $0x803e18,%rdx
  801c45:	00 00 00 
  801c48:	be 27 00 00 00       	mov    $0x27,%esi
  801c4d:	48 bf 03 3e 80 00 00 	movabs $0x803e03,%rdi
  801c54:	00 00 00 
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5c:	48 b9 0a 02 80 00 00 	movabs $0x80020a,%rcx
  801c63:	00 00 00 
  801c66:	ff d1                	callq  *%rcx
}
  801c68:	c9                   	leaveq 
  801c69:	c3                   	retq   

0000000000801c6a <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801c6a:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801c6d:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801c74:	00 00 00 
call *%rax
  801c77:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  801c79:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801c80:	00 
    movq 152(%rsp), %rcx
  801c81:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801c88:	00 
    subq $8, %rcx
  801c89:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  801c8d:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  801c90:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801c97:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  801c98:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  801c9c:	4c 8b 3c 24          	mov    (%rsp),%r15
  801ca0:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801ca5:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801caa:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801caf:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801cb4:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801cb9:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801cbe:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801cc3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801cc8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801ccd:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801cd2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801cd7:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801cdc:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801ce1:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801ce6:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  801cea:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  801cee:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  801cef:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  801cf0:	c3                   	retq   

0000000000801cf1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cf1:	55                   	push   %rbp
  801cf2:	48 89 e5             	mov    %rsp,%rbp
  801cf5:	48 83 ec 08          	sub    $0x8,%rsp
  801cf9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cfd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d01:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d08:	ff ff ff 
  801d0b:	48 01 d0             	add    %rdx,%rax
  801d0e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d12:	c9                   	leaveq 
  801d13:	c3                   	retq   

0000000000801d14 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d14:	55                   	push   %rbp
  801d15:	48 89 e5             	mov    %rsp,%rbp
  801d18:	48 83 ec 08          	sub    $0x8,%rsp
  801d1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d24:	48 89 c7             	mov    %rax,%rdi
  801d27:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  801d2e:	00 00 00 
  801d31:	ff d0                	callq  *%rax
  801d33:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d39:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d3d:	c9                   	leaveq 
  801d3e:	c3                   	retq   

0000000000801d3f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d3f:	55                   	push   %rbp
  801d40:	48 89 e5             	mov    %rsp,%rbp
  801d43:	48 83 ec 18          	sub    $0x18,%rsp
  801d47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d52:	eb 6b                	jmp    801dbf <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d57:	48 98                	cltq   
  801d59:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d5f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d63:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6b:	48 c1 e8 15          	shr    $0x15,%rax
  801d6f:	48 89 c2             	mov    %rax,%rdx
  801d72:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d79:	01 00 00 
  801d7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d80:	83 e0 01             	and    $0x1,%eax
  801d83:	48 85 c0             	test   %rax,%rax
  801d86:	74 21                	je     801da9 <fd_alloc+0x6a>
  801d88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d90:	48 89 c2             	mov    %rax,%rdx
  801d93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d9a:	01 00 00 
  801d9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da1:	83 e0 01             	and    $0x1,%eax
  801da4:	48 85 c0             	test   %rax,%rax
  801da7:	75 12                	jne    801dbb <fd_alloc+0x7c>
			*fd_store = fd;
  801da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	eb 1a                	jmp    801dd5 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dbf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dc3:	7e 8f                	jle    801d54 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dd0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dd5:	c9                   	leaveq 
  801dd6:	c3                   	retq   

0000000000801dd7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
  801ddb:	48 83 ec 20          	sub    $0x20,%rsp
  801ddf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801de2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801de6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801dea:	78 06                	js     801df2 <fd_lookup+0x1b>
  801dec:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801df0:	7e 07                	jle    801df9 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801df7:	eb 6c                	jmp    801e65 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801df9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dfc:	48 98                	cltq   
  801dfe:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e04:	48 c1 e0 0c          	shl    $0xc,%rax
  801e08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e10:	48 c1 e8 15          	shr    $0x15,%rax
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e1e:	01 00 00 
  801e21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e25:	83 e0 01             	and    $0x1,%eax
  801e28:	48 85 c0             	test   %rax,%rax
  801e2b:	74 21                	je     801e4e <fd_lookup+0x77>
  801e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e31:	48 c1 e8 0c          	shr    $0xc,%rax
  801e35:	48 89 c2             	mov    %rax,%rdx
  801e38:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e3f:	01 00 00 
  801e42:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e46:	83 e0 01             	and    $0x1,%eax
  801e49:	48 85 c0             	test   %rax,%rax
  801e4c:	75 07                	jne    801e55 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e53:	eb 10                	jmp    801e65 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e59:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e5d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e65:	c9                   	leaveq 
  801e66:	c3                   	retq   

0000000000801e67 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e67:	55                   	push   %rbp
  801e68:	48 89 e5             	mov    %rsp,%rbp
  801e6b:	48 83 ec 30          	sub    $0x30,%rsp
  801e6f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e73:	89 f0                	mov    %esi,%eax
  801e75:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7c:	48 89 c7             	mov    %rax,%rdi
  801e7f:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  801e86:	00 00 00 
  801e89:	ff d0                	callq  *%rax
  801e8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e8f:	48 89 d6             	mov    %rdx,%rsi
  801e92:	89 c7                	mov    %eax,%edi
  801e94:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  801e9b:	00 00 00 
  801e9e:	ff d0                	callq  *%rax
  801ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea7:	78 0a                	js     801eb3 <fd_close+0x4c>
	    || fd != fd2)
  801ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ead:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eb1:	74 12                	je     801ec5 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eb3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801eb7:	74 05                	je     801ebe <fd_close+0x57>
  801eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ebc:	eb 05                	jmp    801ec3 <fd_close+0x5c>
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	eb 69                	jmp    801f2e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ec5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec9:	8b 00                	mov    (%rax),%eax
  801ecb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ecf:	48 89 d6             	mov    %rdx,%rsi
  801ed2:	89 c7                	mov    %eax,%edi
  801ed4:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  801edb:	00 00 00 
  801ede:	ff d0                	callq  *%rax
  801ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ee7:	78 2a                	js     801f13 <fd_close+0xac>
		if (dev->dev_close)
  801ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eed:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ef1:	48 85 c0             	test   %rax,%rax
  801ef4:	74 16                	je     801f0c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801efa:	48 8b 40 20          	mov    0x20(%rax),%rax
  801efe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f02:	48 89 d7             	mov    %rdx,%rdi
  801f05:	ff d0                	callq  *%rax
  801f07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f0a:	eb 07                	jmp    801f13 <fd_close+0xac>
		else
			r = 0;
  801f0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f17:	48 89 c6             	mov    %rax,%rsi
  801f1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1f:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	callq  *%rax
	return r;
  801f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f2e:	c9                   	leaveq 
  801f2f:	c3                   	retq   

0000000000801f30 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f30:	55                   	push   %rbp
  801f31:	48 89 e5             	mov    %rsp,%rbp
  801f34:	48 83 ec 20          	sub    $0x20,%rsp
  801f38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f46:	eb 41                	jmp    801f89 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f48:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f4f:	00 00 00 
  801f52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f55:	48 63 d2             	movslq %edx,%rdx
  801f58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5c:	8b 00                	mov    (%rax),%eax
  801f5e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f61:	75 22                	jne    801f85 <dev_lookup+0x55>
			*dev = devtab[i];
  801f63:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f6a:	00 00 00 
  801f6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f70:	48 63 d2             	movslq %edx,%rdx
  801f73:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f7b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f83:	eb 60                	jmp    801fe5 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f89:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f90:	00 00 00 
  801f93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f96:	48 63 d2             	movslq %edx,%rdx
  801f99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9d:	48 85 c0             	test   %rax,%rax
  801fa0:	75 a6                	jne    801f48 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fa2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fa9:	00 00 00 
  801fac:	48 8b 00             	mov    (%rax),%rax
  801faf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fb5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fb8:	89 c6                	mov    %eax,%esi
  801fba:	48 bf 50 3e 80 00 00 	movabs $0x803e50,%rdi
  801fc1:	00 00 00 
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc9:	48 b9 43 04 80 00 00 	movabs $0x800443,%rcx
  801fd0:	00 00 00 
  801fd3:	ff d1                	callq  *%rcx
	*dev = 0;
  801fd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fe0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fe5:	c9                   	leaveq 
  801fe6:	c3                   	retq   

0000000000801fe7 <close>:

int
close(int fdnum)
{
  801fe7:	55                   	push   %rbp
  801fe8:	48 89 e5             	mov    %rsp,%rbp
  801feb:	48 83 ec 20          	sub    $0x20,%rsp
  801fef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ff6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff9:	48 89 d6             	mov    %rdx,%rsi
  801ffc:	89 c7                	mov    %eax,%edi
  801ffe:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802005:	00 00 00 
  802008:	ff d0                	callq  *%rax
  80200a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80200d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802011:	79 05                	jns    802018 <close+0x31>
		return r;
  802013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802016:	eb 18                	jmp    802030 <close+0x49>
	else
		return fd_close(fd, 1);
  802018:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201c:	be 01 00 00 00       	mov    $0x1,%esi
  802021:	48 89 c7             	mov    %rax,%rdi
  802024:	48 b8 67 1e 80 00 00 	movabs $0x801e67,%rax
  80202b:	00 00 00 
  80202e:	ff d0                	callq  *%rax
}
  802030:	c9                   	leaveq 
  802031:	c3                   	retq   

0000000000802032 <close_all>:

void
close_all(void)
{
  802032:	55                   	push   %rbp
  802033:	48 89 e5             	mov    %rsp,%rbp
  802036:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80203a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802041:	eb 15                	jmp    802058 <close_all+0x26>
		close(i);
  802043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802046:	89 c7                	mov    %eax,%edi
  802048:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  80204f:	00 00 00 
  802052:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802054:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802058:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80205c:	7e e5                	jle    802043 <close_all+0x11>
		close(i);
}
  80205e:	c9                   	leaveq 
  80205f:	c3                   	retq   

0000000000802060 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802060:	55                   	push   %rbp
  802061:	48 89 e5             	mov    %rsp,%rbp
  802064:	48 83 ec 40          	sub    $0x40,%rsp
  802068:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80206b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80206e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802072:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802075:	48 89 d6             	mov    %rdx,%rsi
  802078:	89 c7                	mov    %eax,%edi
  80207a:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802081:	00 00 00 
  802084:	ff d0                	callq  *%rax
  802086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80208d:	79 08                	jns    802097 <dup+0x37>
		return r;
  80208f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802092:	e9 70 01 00 00       	jmpq   802207 <dup+0x1a7>
	close(newfdnum);
  802097:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80209a:	89 c7                	mov    %eax,%edi
  80209c:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020a8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ab:	48 98                	cltq   
  8020ad:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020b3:	48 c1 e0 0c          	shl    $0xc,%rax
  8020b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bf:	48 89 c7             	mov    %rax,%rdi
  8020c2:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
  8020ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d6:	48 89 c7             	mov    %rax,%rdi
  8020d9:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8020e0:	00 00 00 
  8020e3:	ff d0                	callq  *%rax
  8020e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ed:	48 c1 e8 15          	shr    $0x15,%rax
  8020f1:	48 89 c2             	mov    %rax,%rdx
  8020f4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020fb:	01 00 00 
  8020fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802102:	83 e0 01             	and    $0x1,%eax
  802105:	48 85 c0             	test   %rax,%rax
  802108:	74 73                	je     80217d <dup+0x11d>
  80210a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210e:	48 c1 e8 0c          	shr    $0xc,%rax
  802112:	48 89 c2             	mov    %rax,%rdx
  802115:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80211c:	01 00 00 
  80211f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802123:	83 e0 01             	and    $0x1,%eax
  802126:	48 85 c0             	test   %rax,%rax
  802129:	74 52                	je     80217d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80212b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212f:	48 c1 e8 0c          	shr    $0xc,%rax
  802133:	48 89 c2             	mov    %rax,%rdx
  802136:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213d:	01 00 00 
  802140:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802144:	25 07 0e 00 00       	and    $0xe07,%eax
  802149:	89 c1                	mov    %eax,%ecx
  80214b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80214f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802153:	41 89 c8             	mov    %ecx,%r8d
  802156:	48 89 d1             	mov    %rdx,%rcx
  802159:	ba 00 00 00 00       	mov    $0x0,%edx
  80215e:	48 89 c6             	mov    %rax,%rsi
  802161:	bf 00 00 00 00       	mov    $0x0,%edi
  802166:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
  802172:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802175:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802179:	79 02                	jns    80217d <dup+0x11d>
			goto err;
  80217b:	eb 57                	jmp    8021d4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80217d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802181:	48 c1 e8 0c          	shr    $0xc,%rax
  802185:	48 89 c2             	mov    %rax,%rdx
  802188:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218f:	01 00 00 
  802192:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802196:	25 07 0e 00 00       	and    $0xe07,%eax
  80219b:	89 c1                	mov    %eax,%ecx
  80219d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021a5:	41 89 c8             	mov    %ecx,%r8d
  8021a8:	48 89 d1             	mov    %rdx,%rcx
  8021ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b0:	48 89 c6             	mov    %rax,%rsi
  8021b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b8:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  8021bf:	00 00 00 
  8021c2:	ff d0                	callq  *%rax
  8021c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cb:	79 02                	jns    8021cf <dup+0x16f>
		goto err;
  8021cd:	eb 05                	jmp    8021d4 <dup+0x174>

	return newfdnum;
  8021cf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021d2:	eb 33                	jmp    802207 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d8:	48 89 c6             	mov    %rax,%rsi
  8021db:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e0:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  8021e7:	00 00 00 
  8021ea:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f0:	48 89 c6             	mov    %rax,%rsi
  8021f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f8:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  8021ff:	00 00 00 
  802202:	ff d0                	callq  *%rax
	return r;
  802204:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802207:	c9                   	leaveq 
  802208:	c3                   	retq   

0000000000802209 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802209:	55                   	push   %rbp
  80220a:	48 89 e5             	mov    %rsp,%rbp
  80220d:	48 83 ec 40          	sub    $0x40,%rsp
  802211:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802214:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802218:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80221c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802220:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802223:	48 89 d6             	mov    %rdx,%rsi
  802226:	89 c7                	mov    %eax,%edi
  802228:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80222f:	00 00 00 
  802232:	ff d0                	callq  *%rax
  802234:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802237:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223b:	78 24                	js     802261 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80223d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802241:	8b 00                	mov    (%rax),%eax
  802243:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802247:	48 89 d6             	mov    %rdx,%rsi
  80224a:	89 c7                	mov    %eax,%edi
  80224c:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80225f:	79 05                	jns    802266 <read+0x5d>
		return r;
  802261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802264:	eb 76                	jmp    8022dc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802266:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226a:	8b 40 08             	mov    0x8(%rax),%eax
  80226d:	83 e0 03             	and    $0x3,%eax
  802270:	83 f8 01             	cmp    $0x1,%eax
  802273:	75 3a                	jne    8022af <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802275:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80227c:	00 00 00 
  80227f:	48 8b 00             	mov    (%rax),%rax
  802282:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802288:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80228b:	89 c6                	mov    %eax,%esi
  80228d:	48 bf 6f 3e 80 00 00 	movabs $0x803e6f,%rdi
  802294:	00 00 00 
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
  80229c:	48 b9 43 04 80 00 00 	movabs $0x800443,%rcx
  8022a3:	00 00 00 
  8022a6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ad:	eb 2d                	jmp    8022dc <read+0xd3>
	}
	if (!dev->dev_read)
  8022af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022b7:	48 85 c0             	test   %rax,%rax
  8022ba:	75 07                	jne    8022c3 <read+0xba>
		return -E_NOT_SUPP;
  8022bc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022c1:	eb 19                	jmp    8022dc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022cb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022cf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022d3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022d7:	48 89 cf             	mov    %rcx,%rdi
  8022da:	ff d0                	callq  *%rax
}
  8022dc:	c9                   	leaveq 
  8022dd:	c3                   	retq   

00000000008022de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022de:	55                   	push   %rbp
  8022df:	48 89 e5             	mov    %rsp,%rbp
  8022e2:	48 83 ec 30          	sub    $0x30,%rsp
  8022e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022f8:	eb 49                	jmp    802343 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fd:	48 98                	cltq   
  8022ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802303:	48 29 c2             	sub    %rax,%rdx
  802306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802309:	48 63 c8             	movslq %eax,%rcx
  80230c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802310:	48 01 c1             	add    %rax,%rcx
  802313:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802316:	48 89 ce             	mov    %rcx,%rsi
  802319:	89 c7                	mov    %eax,%edi
  80231b:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  802322:	00 00 00 
  802325:	ff d0                	callq  *%rax
  802327:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80232a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80232e:	79 05                	jns    802335 <readn+0x57>
			return m;
  802330:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802333:	eb 1c                	jmp    802351 <readn+0x73>
		if (m == 0)
  802335:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802339:	75 02                	jne    80233d <readn+0x5f>
			break;
  80233b:	eb 11                	jmp    80234e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80233d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802340:	01 45 fc             	add    %eax,-0x4(%rbp)
  802343:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802346:	48 98                	cltq   
  802348:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80234c:	72 ac                	jb     8022fa <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80234e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802351:	c9                   	leaveq 
  802352:	c3                   	retq   

0000000000802353 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802353:	55                   	push   %rbp
  802354:	48 89 e5             	mov    %rsp,%rbp
  802357:	48 83 ec 40          	sub    $0x40,%rsp
  80235b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80235e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802362:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802366:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80236a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80236d:	48 89 d6             	mov    %rdx,%rsi
  802370:	89 c7                	mov    %eax,%edi
  802372:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
  80237e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802381:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802385:	78 24                	js     8023ab <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238b:	8b 00                	mov    (%rax),%eax
  80238d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802391:	48 89 d6             	mov    %rdx,%rsi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a9:	79 05                	jns    8023b0 <write+0x5d>
		return r;
  8023ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ae:	eb 75                	jmp    802425 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b4:	8b 40 08             	mov    0x8(%rax),%eax
  8023b7:	83 e0 03             	and    $0x3,%eax
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	75 3a                	jne    8023f8 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023c5:	00 00 00 
  8023c8:	48 8b 00             	mov    (%rax),%rax
  8023cb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023d1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023d4:	89 c6                	mov    %eax,%esi
  8023d6:	48 bf 8b 3e 80 00 00 	movabs $0x803e8b,%rdi
  8023dd:	00 00 00 
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e5:	48 b9 43 04 80 00 00 	movabs $0x800443,%rcx
  8023ec:	00 00 00 
  8023ef:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023f6:	eb 2d                	jmp    802425 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fc:	48 8b 40 18          	mov    0x18(%rax),%rax
  802400:	48 85 c0             	test   %rax,%rax
  802403:	75 07                	jne    80240c <write+0xb9>
		return -E_NOT_SUPP;
  802405:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80240a:	eb 19                	jmp    802425 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80240c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802410:	48 8b 40 18          	mov    0x18(%rax),%rax
  802414:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802418:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80241c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802420:	48 89 cf             	mov    %rcx,%rdi
  802423:	ff d0                	callq  *%rax
}
  802425:	c9                   	leaveq 
  802426:	c3                   	retq   

0000000000802427 <seek>:

int
seek(int fdnum, off_t offset)
{
  802427:	55                   	push   %rbp
  802428:	48 89 e5             	mov    %rsp,%rbp
  80242b:	48 83 ec 18          	sub    $0x18,%rsp
  80242f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802432:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802435:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802439:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80243c:	48 89 d6             	mov    %rdx,%rsi
  80243f:	89 c7                	mov    %eax,%edi
  802441:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax
  80244d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802450:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802454:	79 05                	jns    80245b <seek+0x34>
		return r;
  802456:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802459:	eb 0f                	jmp    80246a <seek+0x43>
	fd->fd_offset = offset;
  80245b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802462:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802465:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246a:	c9                   	leaveq 
  80246b:	c3                   	retq   

000000000080246c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80246c:	55                   	push   %rbp
  80246d:	48 89 e5             	mov    %rsp,%rbp
  802470:	48 83 ec 30          	sub    $0x30,%rsp
  802474:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802477:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80247a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80247e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802481:	48 89 d6             	mov    %rdx,%rsi
  802484:	89 c7                	mov    %eax,%edi
  802486:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80248d:	00 00 00 
  802490:	ff d0                	callq  *%rax
  802492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802499:	78 24                	js     8024bf <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80249b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249f:	8b 00                	mov    (%rax),%eax
  8024a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a5:	48 89 d6             	mov    %rdx,%rsi
  8024a8:	89 c7                	mov    %eax,%edi
  8024aa:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  8024b1:	00 00 00 
  8024b4:	ff d0                	callq  *%rax
  8024b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bd:	79 05                	jns    8024c4 <ftruncate+0x58>
		return r;
  8024bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c2:	eb 72                	jmp    802536 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c8:	8b 40 08             	mov    0x8(%rax),%eax
  8024cb:	83 e0 03             	and    $0x3,%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	75 3a                	jne    80250c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024d2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024d9:	00 00 00 
  8024dc:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024df:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024e5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024e8:	89 c6                	mov    %eax,%esi
  8024ea:	48 bf a8 3e 80 00 00 	movabs $0x803ea8,%rdi
  8024f1:	00 00 00 
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f9:	48 b9 43 04 80 00 00 	movabs $0x800443,%rcx
  802500:	00 00 00 
  802503:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802505:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80250a:	eb 2a                	jmp    802536 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80250c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802510:	48 8b 40 30          	mov    0x30(%rax),%rax
  802514:	48 85 c0             	test   %rax,%rax
  802517:	75 07                	jne    802520 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802519:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80251e:	eb 16                	jmp    802536 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802524:	48 8b 40 30          	mov    0x30(%rax),%rax
  802528:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80252c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80252f:	89 ce                	mov    %ecx,%esi
  802531:	48 89 d7             	mov    %rdx,%rdi
  802534:	ff d0                	callq  *%rax
}
  802536:	c9                   	leaveq 
  802537:	c3                   	retq   

0000000000802538 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802538:	55                   	push   %rbp
  802539:	48 89 e5             	mov    %rsp,%rbp
  80253c:	48 83 ec 30          	sub    $0x30,%rsp
  802540:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802543:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802547:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80254b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80254e:	48 89 d6             	mov    %rdx,%rsi
  802551:	89 c7                	mov    %eax,%edi
  802553:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80255a:	00 00 00 
  80255d:	ff d0                	callq  *%rax
  80255f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802566:	78 24                	js     80258c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256c:	8b 00                	mov    (%rax),%eax
  80256e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802572:	48 89 d6             	mov    %rdx,%rsi
  802575:	89 c7                	mov    %eax,%edi
  802577:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
  802583:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258a:	79 05                	jns    802591 <fstat+0x59>
		return r;
  80258c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258f:	eb 5e                	jmp    8025ef <fstat+0xb7>
	if (!dev->dev_stat)
  802591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802595:	48 8b 40 28          	mov    0x28(%rax),%rax
  802599:	48 85 c0             	test   %rax,%rax
  80259c:	75 07                	jne    8025a5 <fstat+0x6d>
		return -E_NOT_SUPP;
  80259e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025a3:	eb 4a                	jmp    8025ef <fstat+0xb7>
	stat->st_name[0] = 0;
  8025a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025a9:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025b7:	00 00 00 
	stat->st_isdir = 0;
  8025ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025be:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025c5:	00 00 00 
	stat->st_dev = dev;
  8025c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025db:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025e3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025e7:	48 89 ce             	mov    %rcx,%rsi
  8025ea:	48 89 d7             	mov    %rdx,%rdi
  8025ed:	ff d0                	callq  *%rax
}
  8025ef:	c9                   	leaveq 
  8025f0:	c3                   	retq   

00000000008025f1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025f1:	55                   	push   %rbp
  8025f2:	48 89 e5             	mov    %rsp,%rbp
  8025f5:	48 83 ec 20          	sub    $0x20,%rsp
  8025f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802605:	be 00 00 00 00       	mov    $0x0,%esi
  80260a:	48 89 c7             	mov    %rax,%rdi
  80260d:	48 b8 df 26 80 00 00 	movabs $0x8026df,%rax
  802614:	00 00 00 
  802617:	ff d0                	callq  *%rax
  802619:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802620:	79 05                	jns    802627 <stat+0x36>
		return fd;
  802622:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802625:	eb 2f                	jmp    802656 <stat+0x65>
	r = fstat(fd, stat);
  802627:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80262b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262e:	48 89 d6             	mov    %rdx,%rsi
  802631:	89 c7                	mov    %eax,%edi
  802633:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  80263a:	00 00 00 
  80263d:	ff d0                	callq  *%rax
  80263f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802645:	89 c7                	mov    %eax,%edi
  802647:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  80264e:	00 00 00 
  802651:	ff d0                	callq  *%rax
	return r;
  802653:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802656:	c9                   	leaveq 
  802657:	c3                   	retq   

0000000000802658 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802658:	55                   	push   %rbp
  802659:	48 89 e5             	mov    %rsp,%rbp
  80265c:	48 83 ec 10          	sub    $0x10,%rsp
  802660:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802663:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802667:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80266e:	00 00 00 
  802671:	8b 00                	mov    (%rax),%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	75 1d                	jne    802694 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802677:	bf 01 00 00 00       	mov    $0x1,%edi
  80267c:	48 b8 0f 37 80 00 00 	movabs $0x80370f,%rax
  802683:	00 00 00 
  802686:	ff d0                	callq  *%rax
  802688:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80268f:	00 00 00 
  802692:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802694:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80269b:	00 00 00 
  80269e:	8b 00                	mov    (%rax),%eax
  8026a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026a3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026a8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026af:	00 00 00 
  8026b2:	89 c7                	mov    %eax,%edi
  8026b4:	48 b8 77 36 80 00 00 	movabs $0x803677,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c9:	48 89 c6             	mov    %rax,%rsi
  8026cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d1:	48 b8 b6 35 80 00 00 	movabs $0x8035b6,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	callq  *%rax
}
  8026dd:	c9                   	leaveq 
  8026de:	c3                   	retq   

00000000008026df <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026df:	55                   	push   %rbp
  8026e0:	48 89 e5             	mov    %rsp,%rbp
  8026e3:	48 83 ec 20          	sub    $0x20,%rsp
  8026e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8026ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f2:	48 89 c7             	mov    %rax,%rdi
  8026f5:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
  802701:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802706:	7e 0a                	jle    802712 <open+0x33>
		return -E_BAD_PATH;
  802708:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80270d:	e9 a5 00 00 00       	jmpq   8027b7 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802712:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802716:	48 89 c7             	mov    %rax,%rdi
  802719:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
  802725:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802728:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272c:	79 08                	jns    802736 <open+0x57>
		return r;
  80272e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802731:	e9 81 00 00 00       	jmpq   8027b7 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273a:	48 89 c6             	mov    %rax,%rsi
  80273d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802744:	00 00 00 
  802747:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  80274e:	00 00 00 
  802751:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802753:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80275a:	00 00 00 
  80275d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802760:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276a:	48 89 c6             	mov    %rax,%rsi
  80276d:	bf 01 00 00 00       	mov    $0x1,%edi
  802772:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  802779:	00 00 00 
  80277c:	ff d0                	callq  *%rax
  80277e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802781:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802785:	79 1d                	jns    8027a4 <open+0xc5>
		fd_close(fd, 0);
  802787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278b:	be 00 00 00 00       	mov    $0x0,%esi
  802790:	48 89 c7             	mov    %rax,%rdi
  802793:	48 b8 67 1e 80 00 00 	movabs $0x801e67,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
		return r;
  80279f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a2:	eb 13                	jmp    8027b7 <open+0xd8>
	}

	return fd2num(fd);
  8027a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a8:	48 89 c7             	mov    %rax,%rdi
  8027ab:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8027b7:	c9                   	leaveq 
  8027b8:	c3                   	retq   

00000000008027b9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027b9:	55                   	push   %rbp
  8027ba:	48 89 e5             	mov    %rsp,%rbp
  8027bd:	48 83 ec 10          	sub    $0x10,%rsp
  8027c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8027cc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027d3:	00 00 00 
  8027d6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027d8:	be 00 00 00 00       	mov    $0x0,%esi
  8027dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8027e2:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  8027e9:	00 00 00 
  8027ec:	ff d0                	callq  *%rax
}
  8027ee:	c9                   	leaveq 
  8027ef:	c3                   	retq   

00000000008027f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027f0:	55                   	push   %rbp
  8027f1:	48 89 e5             	mov    %rsp,%rbp
  8027f4:	48 83 ec 30          	sub    $0x30,%rsp
  8027f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802800:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802808:	8b 50 0c             	mov    0xc(%rax),%edx
  80280b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802812:	00 00 00 
  802815:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802817:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80281e:	00 00 00 
  802821:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802825:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802829:	be 00 00 00 00       	mov    $0x0,%esi
  80282e:	bf 03 00 00 00       	mov    $0x3,%edi
  802833:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  80283a:	00 00 00 
  80283d:	ff d0                	callq  *%rax
  80283f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802842:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802846:	79 08                	jns    802850 <devfile_read+0x60>
		return r;
  802848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284b:	e9 a4 00 00 00       	jmpq   8028f4 <devfile_read+0x104>
	assert(r <= n);
  802850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802853:	48 98                	cltq   
  802855:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802859:	76 35                	jbe    802890 <devfile_read+0xa0>
  80285b:	48 b9 d5 3e 80 00 00 	movabs $0x803ed5,%rcx
  802862:	00 00 00 
  802865:	48 ba dc 3e 80 00 00 	movabs $0x803edc,%rdx
  80286c:	00 00 00 
  80286f:	be 84 00 00 00       	mov    $0x84,%esi
  802874:	48 bf f1 3e 80 00 00 	movabs $0x803ef1,%rdi
  80287b:	00 00 00 
  80287e:	b8 00 00 00 00       	mov    $0x0,%eax
  802883:	49 b8 0a 02 80 00 00 	movabs $0x80020a,%r8
  80288a:	00 00 00 
  80288d:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802890:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802897:	7e 35                	jle    8028ce <devfile_read+0xde>
  802899:	48 b9 fc 3e 80 00 00 	movabs $0x803efc,%rcx
  8028a0:	00 00 00 
  8028a3:	48 ba dc 3e 80 00 00 	movabs $0x803edc,%rdx
  8028aa:	00 00 00 
  8028ad:	be 85 00 00 00       	mov    $0x85,%esi
  8028b2:	48 bf f1 3e 80 00 00 	movabs $0x803ef1,%rdi
  8028b9:	00 00 00 
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c1:	49 b8 0a 02 80 00 00 	movabs $0x80020a,%r8
  8028c8:	00 00 00 
  8028cb:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8028ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d1:	48 63 d0             	movslq %eax,%rdx
  8028d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d8:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8028df:	00 00 00 
  8028e2:	48 89 c7             	mov    %rax,%rdi
  8028e5:	48 b8 2f 13 80 00 00 	movabs $0x80132f,%rax
  8028ec:	00 00 00 
  8028ef:	ff d0                	callq  *%rax
	return r;
  8028f1:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8028f4:	c9                   	leaveq 
  8028f5:	c3                   	retq   

00000000008028f6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028f6:	55                   	push   %rbp
  8028f7:	48 89 e5             	mov    %rsp,%rbp
  8028fa:	48 83 ec 30          	sub    $0x30,%rsp
  8028fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802902:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802906:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80290a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290e:	8b 50 0c             	mov    0xc(%rax),%edx
  802911:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802918:	00 00 00 
  80291b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80291d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802924:	00 00 00 
  802927:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80292b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80292f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802936:	00 
  802937:	76 35                	jbe    80296e <devfile_write+0x78>
  802939:	48 b9 08 3f 80 00 00 	movabs $0x803f08,%rcx
  802940:	00 00 00 
  802943:	48 ba dc 3e 80 00 00 	movabs $0x803edc,%rdx
  80294a:	00 00 00 
  80294d:	be 9e 00 00 00       	mov    $0x9e,%esi
  802952:	48 bf f1 3e 80 00 00 	movabs $0x803ef1,%rdi
  802959:	00 00 00 
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
  802961:	49 b8 0a 02 80 00 00 	movabs $0x80020a,%r8
  802968:	00 00 00 
  80296b:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80296e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802972:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802976:	48 89 c6             	mov    %rax,%rsi
  802979:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802980:	00 00 00 
  802983:	48 b8 46 14 80 00 00 	movabs $0x801446,%rax
  80298a:	00 00 00 
  80298d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80298f:	be 00 00 00 00       	mov    $0x0,%esi
  802994:	bf 04 00 00 00       	mov    $0x4,%edi
  802999:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  8029a0:	00 00 00 
  8029a3:	ff d0                	callq  *%rax
  8029a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ac:	79 05                	jns    8029b3 <devfile_write+0xbd>
		return r;
  8029ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b1:	eb 43                	jmp    8029f6 <devfile_write+0x100>
	assert(r <= n);
  8029b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b6:	48 98                	cltq   
  8029b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029bc:	76 35                	jbe    8029f3 <devfile_write+0xfd>
  8029be:	48 b9 d5 3e 80 00 00 	movabs $0x803ed5,%rcx
  8029c5:	00 00 00 
  8029c8:	48 ba dc 3e 80 00 00 	movabs $0x803edc,%rdx
  8029cf:	00 00 00 
  8029d2:	be a2 00 00 00       	mov    $0xa2,%esi
  8029d7:	48 bf f1 3e 80 00 00 	movabs $0x803ef1,%rdi
  8029de:	00 00 00 
  8029e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e6:	49 b8 0a 02 80 00 00 	movabs $0x80020a,%r8
  8029ed:	00 00 00 
  8029f0:	41 ff d0             	callq  *%r8
	return r;
  8029f3:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8029f6:	c9                   	leaveq 
  8029f7:	c3                   	retq   

00000000008029f8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029f8:	55                   	push   %rbp
  8029f9:	48 89 e5             	mov    %rsp,%rbp
  8029fc:	48 83 ec 20          	sub    $0x20,%rsp
  802a00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a0f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a16:	00 00 00 
  802a19:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a1b:	be 00 00 00 00       	mov    $0x0,%esi
  802a20:	bf 05 00 00 00       	mov    $0x5,%edi
  802a25:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a38:	79 05                	jns    802a3f <devfile_stat+0x47>
		return r;
  802a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3d:	eb 56                	jmp    802a95 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a43:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a4a:	00 00 00 
  802a4d:	48 89 c7             	mov    %rax,%rdi
  802a50:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a5c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a63:	00 00 00 
  802a66:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a70:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a76:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a7d:	00 00 00 
  802a80:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a95:	c9                   	leaveq 
  802a96:	c3                   	retq   

0000000000802a97 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a97:	55                   	push   %rbp
  802a98:	48 89 e5             	mov    %rsp,%rbp
  802a9b:	48 83 ec 10          	sub    $0x10,%rsp
  802a9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802aa3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802aa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aaa:	8b 50 0c             	mov    0xc(%rax),%edx
  802aad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ab4:	00 00 00 
  802ab7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ab9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ac0:	00 00 00 
  802ac3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ac9:	be 00 00 00 00       	mov    $0x0,%esi
  802ace:	bf 02 00 00 00       	mov    $0x2,%edi
  802ad3:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  802ada:	00 00 00 
  802add:	ff d0                	callq  *%rax
}
  802adf:	c9                   	leaveq 
  802ae0:	c3                   	retq   

0000000000802ae1 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ae1:	55                   	push   %rbp
  802ae2:	48 89 e5             	mov    %rsp,%rbp
  802ae5:	48 83 ec 10          	sub    $0x10,%rsp
  802ae9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af1:	48 89 c7             	mov    %rax,%rdi
  802af4:	48 b8 9f 0f 80 00 00 	movabs $0x800f9f,%rax
  802afb:	00 00 00 
  802afe:	ff d0                	callq  *%rax
  802b00:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b05:	7e 07                	jle    802b0e <remove+0x2d>
		return -E_BAD_PATH;
  802b07:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b0c:	eb 33                	jmp    802b41 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b12:	48 89 c6             	mov    %rax,%rsi
  802b15:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802b1c:	00 00 00 
  802b1f:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  802b26:	00 00 00 
  802b29:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b2b:	be 00 00 00 00       	mov    $0x0,%esi
  802b30:	bf 07 00 00 00       	mov    $0x7,%edi
  802b35:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  802b3c:	00 00 00 
  802b3f:	ff d0                	callq  *%rax
}
  802b41:	c9                   	leaveq 
  802b42:	c3                   	retq   

0000000000802b43 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b47:	be 00 00 00 00       	mov    $0x0,%esi
  802b4c:	bf 08 00 00 00       	mov    $0x8,%edi
  802b51:	48 b8 58 26 80 00 00 	movabs $0x802658,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
}
  802b5d:	5d                   	pop    %rbp
  802b5e:	c3                   	retq   

0000000000802b5f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b5f:	55                   	push   %rbp
  802b60:	48 89 e5             	mov    %rsp,%rbp
  802b63:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b6a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b71:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b78:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b7f:	be 00 00 00 00       	mov    $0x0,%esi
  802b84:	48 89 c7             	mov    %rax,%rdi
  802b87:	48 b8 df 26 80 00 00 	movabs $0x8026df,%rax
  802b8e:	00 00 00 
  802b91:	ff d0                	callq  *%rax
  802b93:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9a:	79 28                	jns    802bc4 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9f:	89 c6                	mov    %eax,%esi
  802ba1:	48 bf 35 3f 80 00 00 	movabs $0x803f35,%rdi
  802ba8:	00 00 00 
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb0:	48 ba 43 04 80 00 00 	movabs $0x800443,%rdx
  802bb7:	00 00 00 
  802bba:	ff d2                	callq  *%rdx
		return fd_src;
  802bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bbf:	e9 74 01 00 00       	jmpq   802d38 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bc4:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bcb:	be 01 01 00 00       	mov    $0x101,%esi
  802bd0:	48 89 c7             	mov    %rax,%rdi
  802bd3:	48 b8 df 26 80 00 00 	movabs $0x8026df,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
  802bdf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802be2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802be6:	79 39                	jns    802c21 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802be8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802beb:	89 c6                	mov    %eax,%esi
  802bed:	48 bf 4b 3f 80 00 00 	movabs $0x803f4b,%rdi
  802bf4:	00 00 00 
  802bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfc:	48 ba 43 04 80 00 00 	movabs $0x800443,%rdx
  802c03:	00 00 00 
  802c06:	ff d2                	callq  *%rdx
		close(fd_src);
  802c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0b:	89 c7                	mov    %eax,%edi
  802c0d:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  802c14:	00 00 00 
  802c17:	ff d0                	callq  *%rax
		return fd_dest;
  802c19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c1c:	e9 17 01 00 00       	jmpq   802d38 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c21:	eb 74                	jmp    802c97 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c23:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c26:	48 63 d0             	movslq %eax,%rdx
  802c29:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c33:	48 89 ce             	mov    %rcx,%rsi
  802c36:	89 c7                	mov    %eax,%edi
  802c38:	48 b8 53 23 80 00 00 	movabs $0x802353,%rax
  802c3f:	00 00 00 
  802c42:	ff d0                	callq  *%rax
  802c44:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c47:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c4b:	79 4a                	jns    802c97 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c4d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c50:	89 c6                	mov    %eax,%esi
  802c52:	48 bf 65 3f 80 00 00 	movabs $0x803f65,%rdi
  802c59:	00 00 00 
  802c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c61:	48 ba 43 04 80 00 00 	movabs $0x800443,%rdx
  802c68:	00 00 00 
  802c6b:	ff d2                	callq  *%rdx
			close(fd_src);
  802c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c70:	89 c7                	mov    %eax,%edi
  802c72:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	callq  *%rax
			close(fd_dest);
  802c7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c81:	89 c7                	mov    %eax,%edi
  802c83:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
			return write_size;
  802c8f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c92:	e9 a1 00 00 00       	jmpq   802d38 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c97:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca1:	ba 00 02 00 00       	mov    $0x200,%edx
  802ca6:	48 89 ce             	mov    %rcx,%rsi
  802ca9:	89 c7                	mov    %eax,%edi
  802cab:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  802cb2:	00 00 00 
  802cb5:	ff d0                	callq  *%rax
  802cb7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cbe:	0f 8f 5f ff ff ff    	jg     802c23 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cc8:	79 47                	jns    802d11 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ccd:	89 c6                	mov    %eax,%esi
  802ccf:	48 bf 78 3f 80 00 00 	movabs $0x803f78,%rdi
  802cd6:	00 00 00 
  802cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cde:	48 ba 43 04 80 00 00 	movabs $0x800443,%rdx
  802ce5:	00 00 00 
  802ce8:	ff d2                	callq  *%rdx
		close(fd_src);
  802cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ced:	89 c7                	mov    %eax,%edi
  802cef:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
		close(fd_dest);
  802cfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cfe:	89 c7                	mov    %eax,%edi
  802d00:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  802d07:	00 00 00 
  802d0a:	ff d0                	callq  *%rax
		return read_size;
  802d0c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d0f:	eb 27                	jmp    802d38 <copy+0x1d9>
	}
	close(fd_src);
  802d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d14:	89 c7                	mov    %eax,%edi
  802d16:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
	close(fd_dest);
  802d22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d25:	89 c7                	mov    %eax,%edi
  802d27:	48 b8 e7 1f 80 00 00 	movabs $0x801fe7,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
	return 0;
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802d38:	c9                   	leaveq 
  802d39:	c3                   	retq   

0000000000802d3a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d3a:	55                   	push   %rbp
  802d3b:	48 89 e5             	mov    %rsp,%rbp
  802d3e:	53                   	push   %rbx
  802d3f:	48 83 ec 38          	sub    $0x38,%rsp
  802d43:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d47:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802d4b:	48 89 c7             	mov    %rax,%rdi
  802d4e:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
  802d5a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d61:	0f 88 bf 01 00 00    	js     802f26 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d6b:	ba 07 04 00 00       	mov    $0x407,%edx
  802d70:	48 89 c6             	mov    %rax,%rsi
  802d73:	bf 00 00 00 00       	mov    $0x0,%edi
  802d78:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  802d7f:	00 00 00 
  802d82:	ff d0                	callq  *%rax
  802d84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d8b:	0f 88 95 01 00 00    	js     802f26 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d91:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802d95:	48 89 c7             	mov    %rax,%rdi
  802d98:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  802d9f:	00 00 00 
  802da2:	ff d0                	callq  *%rax
  802da4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802da7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dab:	0f 88 5d 01 00 00    	js     802f0e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802db1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db5:	ba 07 04 00 00       	mov    $0x407,%edx
  802dba:	48 89 c6             	mov    %rax,%rsi
  802dbd:	bf 00 00 00 00       	mov    $0x0,%edi
  802dc2:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  802dc9:	00 00 00 
  802dcc:	ff d0                	callq  *%rax
  802dce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dd5:	0f 88 33 01 00 00    	js     802f0e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ddf:	48 89 c7             	mov    %rax,%rdi
  802de2:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	callq  *%rax
  802dee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802df2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df6:	ba 07 04 00 00       	mov    $0x407,%edx
  802dfb:	48 89 c6             	mov    %rax,%rsi
  802dfe:	bf 00 00 00 00       	mov    $0x0,%edi
  802e03:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
  802e0f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e12:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e16:	79 05                	jns    802e1d <pipe+0xe3>
		goto err2;
  802e18:	e9 d9 00 00 00       	jmpq   802ef6 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e21:	48 89 c7             	mov    %rax,%rdi
  802e24:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
  802e30:	48 89 c2             	mov    %rax,%rdx
  802e33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e37:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802e3d:	48 89 d1             	mov    %rdx,%rcx
  802e40:	ba 00 00 00 00       	mov    $0x0,%edx
  802e45:	48 89 c6             	mov    %rax,%rsi
  802e48:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4d:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	callq  *%rax
  802e59:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e60:	79 1b                	jns    802e7d <pipe+0x143>
		goto err3;
  802e62:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802e63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e67:	48 89 c6             	mov    %rax,%rsi
  802e6a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e6f:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
  802e7b:	eb 79                	jmp    802ef6 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e81:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e88:	00 00 00 
  802e8b:	8b 12                	mov    (%rdx),%edx
  802e8d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802e8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e9e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ea5:	00 00 00 
  802ea8:	8b 12                	mov    (%rdx),%edx
  802eaa:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802eac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802eb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ebb:	48 89 c7             	mov    %rax,%rdi
  802ebe:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  802ec5:	00 00 00 
  802ec8:	ff d0                	callq  *%rax
  802eca:	89 c2                	mov    %eax,%edx
  802ecc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ed0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802ed2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ed6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802eda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ede:	48 89 c7             	mov    %rax,%rdi
  802ee1:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
  802eed:	89 03                	mov    %eax,(%rbx)
	return 0;
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef4:	eb 33                	jmp    802f29 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802ef6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802efa:	48 89 c6             	mov    %rax,%rsi
  802efd:	bf 00 00 00 00       	mov    $0x0,%edi
  802f02:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802f0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f12:	48 89 c6             	mov    %rax,%rsi
  802f15:	bf 00 00 00 00       	mov    $0x0,%edi
  802f1a:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
err:
	return r;
  802f26:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802f29:	48 83 c4 38          	add    $0x38,%rsp
  802f2d:	5b                   	pop    %rbx
  802f2e:	5d                   	pop    %rbp
  802f2f:	c3                   	retq   

0000000000802f30 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f30:	55                   	push   %rbp
  802f31:	48 89 e5             	mov    %rsp,%rbp
  802f34:	53                   	push   %rbx
  802f35:	48 83 ec 28          	sub    $0x28,%rsp
  802f39:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f3d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802f41:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f48:	00 00 00 
  802f4b:	48 8b 00             	mov    (%rax),%rax
  802f4e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f54:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802f57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f5b:	48 89 c7             	mov    %rax,%rdi
  802f5e:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	callq  *%rax
  802f6a:	89 c3                	mov    %eax,%ebx
  802f6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f70:	48 89 c7             	mov    %rax,%rdi
  802f73:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
  802f7f:	39 c3                	cmp    %eax,%ebx
  802f81:	0f 94 c0             	sete   %al
  802f84:	0f b6 c0             	movzbl %al,%eax
  802f87:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802f8a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f91:	00 00 00 
  802f94:	48 8b 00             	mov    (%rax),%rax
  802f97:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f9d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802fa0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802fa6:	75 05                	jne    802fad <_pipeisclosed+0x7d>
			return ret;
  802fa8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fab:	eb 4f                	jmp    802ffc <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802fad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fb0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802fb3:	74 42                	je     802ff7 <_pipeisclosed+0xc7>
  802fb5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802fb9:	75 3c                	jne    802ff7 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802fbb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802fc2:	00 00 00 
  802fc5:	48 8b 00             	mov    (%rax),%rax
  802fc8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802fce:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802fd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fd4:	89 c6                	mov    %eax,%esi
  802fd6:	48 bf 93 3f 80 00 00 	movabs $0x803f93,%rdi
  802fdd:	00 00 00 
  802fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe5:	49 b8 43 04 80 00 00 	movabs $0x800443,%r8
  802fec:	00 00 00 
  802fef:	41 ff d0             	callq  *%r8
	}
  802ff2:	e9 4a ff ff ff       	jmpq   802f41 <_pipeisclosed+0x11>
  802ff7:	e9 45 ff ff ff       	jmpq   802f41 <_pipeisclosed+0x11>
}
  802ffc:	48 83 c4 28          	add    $0x28,%rsp
  803000:	5b                   	pop    %rbx
  803001:	5d                   	pop    %rbp
  803002:	c3                   	retq   

0000000000803003 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803003:	55                   	push   %rbp
  803004:	48 89 e5             	mov    %rsp,%rbp
  803007:	48 83 ec 30          	sub    $0x30,%rsp
  80300b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80300e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803012:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803015:	48 89 d6             	mov    %rdx,%rsi
  803018:	89 c7                	mov    %eax,%edi
  80301a:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803021:	00 00 00 
  803024:	ff d0                	callq  *%rax
  803026:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803029:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302d:	79 05                	jns    803034 <pipeisclosed+0x31>
		return r;
  80302f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803032:	eb 31                	jmp    803065 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803038:	48 89 c7             	mov    %rax,%rdi
  80303b:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
  803047:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80304b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803053:	48 89 d6             	mov    %rdx,%rsi
  803056:	48 89 c7             	mov    %rax,%rdi
  803059:	48 b8 30 2f 80 00 00 	movabs $0x802f30,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
}
  803065:	c9                   	leaveq 
  803066:	c3                   	retq   

0000000000803067 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803067:	55                   	push   %rbp
  803068:	48 89 e5             	mov    %rsp,%rbp
  80306b:	48 83 ec 40          	sub    $0x40,%rsp
  80306f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803073:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803077:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80307b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80307f:	48 89 c7             	mov    %rax,%rdi
  803082:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
  80308e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803092:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803096:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80309a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8030a1:	00 
  8030a2:	e9 92 00 00 00       	jmpq   803139 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8030a7:	eb 41                	jmp    8030ea <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8030a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8030ae:	74 09                	je     8030b9 <devpipe_read+0x52>
				return i;
  8030b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b4:	e9 92 00 00 00       	jmpq   80314b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8030b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c1:	48 89 d6             	mov    %rdx,%rsi
  8030c4:	48 89 c7             	mov    %rax,%rdi
  8030c7:	48 b8 30 2f 80 00 00 	movabs $0x802f30,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	callq  *%rax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 07                	je     8030de <devpipe_read+0x77>
				return 0;
  8030d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030dc:	eb 6d                	jmp    80314b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8030de:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8030ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ee:	8b 10                	mov    (%rax),%edx
  8030f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f4:	8b 40 04             	mov    0x4(%rax),%eax
  8030f7:	39 c2                	cmp    %eax,%edx
  8030f9:	74 ae                	je     8030a9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803103:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80310b:	8b 00                	mov    (%rax),%eax
  80310d:	99                   	cltd   
  80310e:	c1 ea 1b             	shr    $0x1b,%edx
  803111:	01 d0                	add    %edx,%eax
  803113:	83 e0 1f             	and    $0x1f,%eax
  803116:	29 d0                	sub    %edx,%eax
  803118:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80311c:	48 98                	cltq   
  80311e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803123:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803125:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803129:	8b 00                	mov    (%rax),%eax
  80312b:	8d 50 01             	lea    0x1(%rax),%edx
  80312e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803132:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803134:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803141:	0f 82 60 ff ff ff    	jb     8030a7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
  803151:	48 83 ec 40          	sub    $0x40,%rsp
  803155:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803159:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80315d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803165:	48 89 c7             	mov    %rax,%rdi
  803168:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
  803174:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803178:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80317c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803180:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803187:	00 
  803188:	e9 8e 00 00 00       	jmpq   80321b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80318d:	eb 31                	jmp    8031c0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80318f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803193:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803197:	48 89 d6             	mov    %rdx,%rsi
  80319a:	48 89 c7             	mov    %rax,%rdi
  80319d:	48 b8 30 2f 80 00 00 	movabs $0x802f30,%rax
  8031a4:	00 00 00 
  8031a7:	ff d0                	callq  *%rax
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	74 07                	je     8031b4 <devpipe_write+0x67>
				return 0;
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b2:	eb 79                	jmp    80322d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8031b4:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8031c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c4:	8b 40 04             	mov    0x4(%rax),%eax
  8031c7:	48 63 d0             	movslq %eax,%rdx
  8031ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ce:	8b 00                	mov    (%rax),%eax
  8031d0:	48 98                	cltq   
  8031d2:	48 83 c0 20          	add    $0x20,%rax
  8031d6:	48 39 c2             	cmp    %rax,%rdx
  8031d9:	73 b4                	jae    80318f <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8031db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031df:	8b 40 04             	mov    0x4(%rax),%eax
  8031e2:	99                   	cltd   
  8031e3:	c1 ea 1b             	shr    $0x1b,%edx
  8031e6:	01 d0                	add    %edx,%eax
  8031e8:	83 e0 1f             	and    $0x1f,%eax
  8031eb:	29 d0                	sub    %edx,%eax
  8031ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031f5:	48 01 ca             	add    %rcx,%rdx
  8031f8:	0f b6 0a             	movzbl (%rdx),%ecx
  8031fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031ff:	48 98                	cltq   
  803201:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803209:	8b 40 04             	mov    0x4(%rax),%eax
  80320c:	8d 50 01             	lea    0x1(%rax),%edx
  80320f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803213:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803216:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80321b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80321f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803223:	0f 82 64 ff ff ff    	jb     80318d <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80322d:	c9                   	leaveq 
  80322e:	c3                   	retq   

000000000080322f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80322f:	55                   	push   %rbp
  803230:	48 89 e5             	mov    %rsp,%rbp
  803233:	48 83 ec 20          	sub    $0x20,%rsp
  803237:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80323b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80323f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803243:	48 89 c7             	mov    %rax,%rdi
  803246:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
  803252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803256:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80325a:	48 be a6 3f 80 00 00 	movabs $0x803fa6,%rsi
  803261:	00 00 00 
  803264:	48 89 c7             	mov    %rax,%rdi
  803267:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803277:	8b 50 04             	mov    0x4(%rax),%edx
  80327a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80327e:	8b 00                	mov    (%rax),%eax
  803280:	29 c2                	sub    %eax,%edx
  803282:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803286:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80328c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803290:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803297:	00 00 00 
	stat->st_dev = &devpipe;
  80329a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329e:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8032a5:	00 00 00 
  8032a8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8032af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032b4:	c9                   	leaveq 
  8032b5:	c3                   	retq   

00000000008032b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8032b6:	55                   	push   %rbp
  8032b7:	48 89 e5             	mov    %rsp,%rbp
  8032ba:	48 83 ec 10          	sub    $0x10,%rsp
  8032be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8032c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c6:	48 89 c6             	mov    %rax,%rsi
  8032c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ce:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8032da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032de:	48 89 c7             	mov    %rax,%rdi
  8032e1:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	48 89 c6             	mov    %rax,%rsi
  8032f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f5:	48 b8 e5 19 80 00 00 	movabs $0x8019e5,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
}
  803301:	c9                   	leaveq 
  803302:	c3                   	retq   

0000000000803303 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803303:	55                   	push   %rbp
  803304:	48 89 e5             	mov    %rsp,%rbp
  803307:	48 83 ec 20          	sub    $0x20,%rsp
  80330b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80330e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803311:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803314:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803318:	be 01 00 00 00       	mov    $0x1,%esi
  80331d:	48 89 c7             	mov    %rax,%rdi
  803320:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
}
  80332c:	c9                   	leaveq 
  80332d:	c3                   	retq   

000000000080332e <getchar>:

int
getchar(void)
{
  80332e:	55                   	push   %rbp
  80332f:	48 89 e5             	mov    %rsp,%rbp
  803332:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803336:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80333a:	ba 01 00 00 00       	mov    $0x1,%edx
  80333f:	48 89 c6             	mov    %rax,%rsi
  803342:	bf 00 00 00 00       	mov    $0x0,%edi
  803347:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  80334e:	00 00 00 
  803351:	ff d0                	callq  *%rax
  803353:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80335a:	79 05                	jns    803361 <getchar+0x33>
		return r;
  80335c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335f:	eb 14                	jmp    803375 <getchar+0x47>
	if (r < 1)
  803361:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803365:	7f 07                	jg     80336e <getchar+0x40>
		return -E_EOF;
  803367:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80336c:	eb 07                	jmp    803375 <getchar+0x47>
	return c;
  80336e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803372:	0f b6 c0             	movzbl %al,%eax
}
  803375:	c9                   	leaveq 
  803376:	c3                   	retq   

0000000000803377 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803377:	55                   	push   %rbp
  803378:	48 89 e5             	mov    %rsp,%rbp
  80337b:	48 83 ec 20          	sub    $0x20,%rsp
  80337f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803382:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803386:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803389:	48 89 d6             	mov    %rdx,%rsi
  80338c:	89 c7                	mov    %eax,%edi
  80338e:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803395:	00 00 00 
  803398:	ff d0                	callq  *%rax
  80339a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033a1:	79 05                	jns    8033a8 <iscons+0x31>
		return r;
  8033a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a6:	eb 1a                	jmp    8033c2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8033a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ac:	8b 10                	mov    (%rax),%edx
  8033ae:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8033b5:	00 00 00 
  8033b8:	8b 00                	mov    (%rax),%eax
  8033ba:	39 c2                	cmp    %eax,%edx
  8033bc:	0f 94 c0             	sete   %al
  8033bf:	0f b6 c0             	movzbl %al,%eax
}
  8033c2:	c9                   	leaveq 
  8033c3:	c3                   	retq   

00000000008033c4 <opencons>:

int
opencons(void)
{
  8033c4:	55                   	push   %rbp
  8033c5:	48 89 e5             	mov    %rsp,%rbp
  8033c8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8033cc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033d0:	48 89 c7             	mov    %rax,%rdi
  8033d3:	48 b8 3f 1d 80 00 00 	movabs $0x801d3f,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
  8033df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e6:	79 05                	jns    8033ed <opencons+0x29>
		return r;
  8033e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033eb:	eb 5b                	jmp    803448 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8033ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f1:	ba 07 04 00 00       	mov    $0x407,%edx
  8033f6:	48 89 c6             	mov    %rax,%rsi
  8033f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fe:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
  80340a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80340d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803411:	79 05                	jns    803418 <opencons+0x54>
		return r;
  803413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803416:	eb 30                	jmp    803448 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341c:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803423:	00 00 00 
  803426:	8b 12                	mov    (%rdx),%edx
  803428:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80342a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803439:	48 89 c7             	mov    %rax,%rdi
  80343c:	48 b8 f1 1c 80 00 00 	movabs $0x801cf1,%rax
  803443:	00 00 00 
  803446:	ff d0                	callq  *%rax
}
  803448:	c9                   	leaveq 
  803449:	c3                   	retq   

000000000080344a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80344a:	55                   	push   %rbp
  80344b:	48 89 e5             	mov    %rsp,%rbp
  80344e:	48 83 ec 30          	sub    $0x30,%rsp
  803452:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803456:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80345a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80345e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803463:	75 07                	jne    80346c <devcons_read+0x22>
		return 0;
  803465:	b8 00 00 00 00       	mov    $0x0,%eax
  80346a:	eb 4b                	jmp    8034b7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80346c:	eb 0c                	jmp    80347a <devcons_read+0x30>
		sys_yield();
  80346e:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  803475:	00 00 00 
  803478:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80347a:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
  803486:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803489:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348d:	74 df                	je     80346e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80348f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803493:	79 05                	jns    80349a <devcons_read+0x50>
		return c;
  803495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803498:	eb 1d                	jmp    8034b7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80349a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80349e:	75 07                	jne    8034a7 <devcons_read+0x5d>
		return 0;
  8034a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a5:	eb 10                	jmp    8034b7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8034a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034aa:	89 c2                	mov    %eax,%edx
  8034ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b0:	88 10                	mov    %dl,(%rax)
	return 1;
  8034b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8034b7:	c9                   	leaveq 
  8034b8:	c3                   	retq   

00000000008034b9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034b9:	55                   	push   %rbp
  8034ba:	48 89 e5             	mov    %rsp,%rbp
  8034bd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8034c4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8034cb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8034d2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8034d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034e0:	eb 76                	jmp    803558 <devcons_write+0x9f>
		m = n - tot;
  8034e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8034e9:	89 c2                	mov    %eax,%edx
  8034eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ee:	29 c2                	sub    %eax,%edx
  8034f0:	89 d0                	mov    %edx,%eax
  8034f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8034f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034f8:	83 f8 7f             	cmp    $0x7f,%eax
  8034fb:	76 07                	jbe    803504 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8034fd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803504:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803507:	48 63 d0             	movslq %eax,%rdx
  80350a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350d:	48 63 c8             	movslq %eax,%rcx
  803510:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803517:	48 01 c1             	add    %rax,%rcx
  80351a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803521:	48 89 ce             	mov    %rcx,%rsi
  803524:	48 89 c7             	mov    %rax,%rdi
  803527:	48 b8 2f 13 80 00 00 	movabs $0x80132f,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803533:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803536:	48 63 d0             	movslq %eax,%rdx
  803539:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803540:	48 89 d6             	mov    %rdx,%rsi
  803543:	48 89 c7             	mov    %rax,%rdi
  803546:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  80354d:	00 00 00 
  803550:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803552:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803555:	01 45 fc             	add    %eax,-0x4(%rbp)
  803558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355b:	48 98                	cltq   
  80355d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803564:	0f 82 78 ff ff ff    	jb     8034e2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80356a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80356d:	c9                   	leaveq 
  80356e:	c3                   	retq   

000000000080356f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80356f:	55                   	push   %rbp
  803570:	48 89 e5             	mov    %rsp,%rbp
  803573:	48 83 ec 08          	sub    $0x8,%rsp
  803577:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80357b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803580:	c9                   	leaveq 
  803581:	c3                   	retq   

0000000000803582 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803582:	55                   	push   %rbp
  803583:	48 89 e5             	mov    %rsp,%rbp
  803586:	48 83 ec 10          	sub    $0x10,%rsp
  80358a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80358e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803596:	48 be b2 3f 80 00 00 	movabs $0x803fb2,%rsi
  80359d:	00 00 00 
  8035a0:	48 89 c7             	mov    %rax,%rdi
  8035a3:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
	return 0;
  8035af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035b4:	c9                   	leaveq 
  8035b5:	c3                   	retq   

00000000008035b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8035b6:	55                   	push   %rbp
  8035b7:	48 89 e5             	mov    %rsp,%rbp
  8035ba:	48 83 ec 30          	sub    $0x30,%rsp
  8035be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8035ca:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035cf:	75 0e                	jne    8035df <ipc_recv+0x29>
        pg = (void *)UTOP;
  8035d1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8035d8:	00 00 00 
  8035db:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8035df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e3:	48 89 c7             	mov    %rax,%rdi
  8035e6:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f9:	79 27                	jns    803622 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8035fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803600:	74 0a                	je     80360c <ipc_recv+0x56>
            *from_env_store = 0;
  803602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803606:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80360c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803611:	74 0a                	je     80361d <ipc_recv+0x67>
            *perm_store = 0;
  803613:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803617:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80361d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803620:	eb 53                	jmp    803675 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803622:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803627:	74 19                	je     803642 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803629:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803630:	00 00 00 
  803633:	48 8b 00             	mov    (%rax),%rax
  803636:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80363c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803640:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803642:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803647:	74 19                	je     803662 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803649:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803650:	00 00 00 
  803653:	48 8b 00             	mov    (%rax),%rax
  803656:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80365c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803660:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803662:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803669:	00 00 00 
  80366c:	48 8b 00             	mov    (%rax),%rax
  80366f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803675:	c9                   	leaveq 
  803676:	c3                   	retq   

0000000000803677 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803677:	55                   	push   %rbp
  803678:	48 89 e5             	mov    %rsp,%rbp
  80367b:	48 83 ec 30          	sub    $0x30,%rsp
  80367f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803682:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803685:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803689:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80368c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803691:	75 0e                	jne    8036a1 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803693:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80369a:	00 00 00 
  80369d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8036a1:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8036a4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8036a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8036ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ae:	89 c7                	mov    %eax,%edi
  8036b0:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
  8036bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8036bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c3:	79 36                	jns    8036fb <ipc_send+0x84>
  8036c5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8036c9:	74 30                	je     8036fb <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8036cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ce:	89 c1                	mov    %eax,%ecx
  8036d0:	48 ba b9 3f 80 00 00 	movabs $0x803fb9,%rdx
  8036d7:	00 00 00 
  8036da:	be 49 00 00 00       	mov    $0x49,%esi
  8036df:	48 bf c6 3f 80 00 00 	movabs $0x803fc6,%rdi
  8036e6:	00 00 00 
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ee:	49 b8 0a 02 80 00 00 	movabs $0x80020a,%r8
  8036f5:	00 00 00 
  8036f8:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8036fb:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  803702:	00 00 00 
  803705:	ff d0                	callq  *%rax
    } while(r != 0);
  803707:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370b:	75 94                	jne    8036a1 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80370d:	c9                   	leaveq 
  80370e:	c3                   	retq   

000000000080370f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80370f:	55                   	push   %rbp
  803710:	48 89 e5             	mov    %rsp,%rbp
  803713:	48 83 ec 14          	sub    $0x14,%rsp
  803717:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80371a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803721:	eb 5e                	jmp    803781 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803723:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80372a:	00 00 00 
  80372d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803730:	48 63 d0             	movslq %eax,%rdx
  803733:	48 89 d0             	mov    %rdx,%rax
  803736:	48 c1 e0 03          	shl    $0x3,%rax
  80373a:	48 01 d0             	add    %rdx,%rax
  80373d:	48 c1 e0 05          	shl    $0x5,%rax
  803741:	48 01 c8             	add    %rcx,%rax
  803744:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80374a:	8b 00                	mov    (%rax),%eax
  80374c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80374f:	75 2c                	jne    80377d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803751:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803758:	00 00 00 
  80375b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375e:	48 63 d0             	movslq %eax,%rdx
  803761:	48 89 d0             	mov    %rdx,%rax
  803764:	48 c1 e0 03          	shl    $0x3,%rax
  803768:	48 01 d0             	add    %rdx,%rax
  80376b:	48 c1 e0 05          	shl    $0x5,%rax
  80376f:	48 01 c8             	add    %rcx,%rax
  803772:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803778:	8b 40 08             	mov    0x8(%rax),%eax
  80377b:	eb 12                	jmp    80378f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80377d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803781:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803788:	7e 99                	jle    803723 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80378a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80378f:	c9                   	leaveq 
  803790:	c3                   	retq   

0000000000803791 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803791:	55                   	push   %rbp
  803792:	48 89 e5             	mov    %rsp,%rbp
  803795:	48 83 ec 18          	sub    $0x18,%rsp
  803799:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80379d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a1:	48 c1 e8 15          	shr    $0x15,%rax
  8037a5:	48 89 c2             	mov    %rax,%rdx
  8037a8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037af:	01 00 00 
  8037b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037b6:	83 e0 01             	and    $0x1,%eax
  8037b9:	48 85 c0             	test   %rax,%rax
  8037bc:	75 07                	jne    8037c5 <pageref+0x34>
		return 0;
  8037be:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c3:	eb 53                	jmp    803818 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8037c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8037cd:	48 89 c2             	mov    %rax,%rdx
  8037d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037d7:	01 00 00 
  8037da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8037e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e6:	83 e0 01             	and    $0x1,%eax
  8037e9:	48 85 c0             	test   %rax,%rax
  8037ec:	75 07                	jne    8037f5 <pageref+0x64>
		return 0;
  8037ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f3:	eb 23                	jmp    803818 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8037f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8037fd:	48 89 c2             	mov    %rax,%rdx
  803800:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803807:	00 00 00 
  80380a:	48 c1 e2 04          	shl    $0x4,%rdx
  80380e:	48 01 d0             	add    %rdx,%rax
  803811:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803815:	0f b7 c0             	movzwl %ax,%eax
}
  803818:	c9                   	leaveq 
  803819:	c3                   	retq   
