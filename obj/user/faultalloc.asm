
obj/user/faultalloc:     file format elf64-x86-64


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
  80003c:	e8 3f 01 00 00       	callq  800180 <libmain>
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
  800061:	48 bf 60 38 80 00 00 	movabs $0x803860,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
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
  80009b:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
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
  8000bd:	48 ba 70 38 80 00 00 	movabs $0x803870,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cc:	48 bf 9b 38 80 00 00 	movabs $0x80389b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 34 02 80 00 00 	movabs $0x800234,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba b0 38 80 00 00 	movabs $0x8038b0,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 e8 0e 80 00 00 	movabs $0x800ee8,%r8
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
  800132:	48 b8 d1 1b 80 00 00 	movabs $0x801bd1,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013e:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800143:	48 bf d1 38 80 00 00 	movabs $0x8038d1,%rdi
  80014a:	00 00 00 
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
  800152:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
  800159:	00 00 00 
  80015c:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015e:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800163:	48 bf d1 38 80 00 00 	movabs $0x8038d1,%rdi
  80016a:	00 00 00 
  80016d:	b8 00 00 00 00       	mov    $0x0,%eax
  800172:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
  800179:	00 00 00 
  80017c:	ff d2                	callq  *%rdx
}
  80017e:	c9                   	leaveq 
  80017f:	c3                   	retq   

0000000000800180 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800180:	55                   	push   %rbp
  800181:	48 89 e5             	mov    %rsp,%rbp
  800184:	48 83 ec 20          	sub    $0x20,%rsp
  800188:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80018b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80018f:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  800196:	00 00 00 
  800199:	ff d0                	callq  *%rax
  80019b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  80019e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a6:	48 63 d0             	movslq %eax,%rdx
  8001a9:	48 89 d0             	mov    %rdx,%rax
  8001ac:	48 c1 e0 03          	shl    $0x3,%rax
  8001b0:	48 01 d0             	add    %rdx,%rax
  8001b3:	48 c1 e0 05          	shl    $0x5,%rax
  8001b7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001be:	00 00 00 
  8001c1:	48 01 c2             	add    %rax,%rdx
  8001c4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001cb:	00 00 00 
  8001ce:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001d5:	7e 14                	jle    8001eb <libmain+0x6b>
		binaryname = argv[0];
  8001d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001db:	48 8b 10             	mov    (%rax),%rdx
  8001de:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001e5:	00 00 00 
  8001e8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001eb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f2:	48 89 d6             	mov    %rdx,%rsi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800203:	48 b8 11 02 80 00 00 	movabs $0x800211,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
}
  80020f:	c9                   	leaveq 
  800210:	c3                   	retq   

0000000000800211 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800211:	55                   	push   %rbp
  800212:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800215:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800221:	bf 00 00 00 00       	mov    $0x0,%edi
  800226:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax
}
  800232:	5d                   	pop    %rbp
  800233:	c3                   	retq   

0000000000800234 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800234:	55                   	push   %rbp
  800235:	48 89 e5             	mov    %rsp,%rbp
  800238:	53                   	push   %rbx
  800239:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800240:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800247:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80024d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800254:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80025b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800262:	84 c0                	test   %al,%al
  800264:	74 23                	je     800289 <_panic+0x55>
  800266:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80026d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800271:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800275:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800279:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80027d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800281:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800285:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800289:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800290:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800297:	00 00 00 
  80029a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002a1:	00 00 00 
  8002a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002af:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002b6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002bd:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 18             	mov    (%rax),%rbx
  8002ca:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  8002d1:	00 00 00 
  8002d4:	ff d0                	callq  *%rax
  8002d6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002dc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002e3:	41 89 c8             	mov    %ecx,%r8d
  8002e6:	48 89 d1             	mov    %rdx,%rcx
  8002e9:	48 89 da             	mov    %rbx,%rdx
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf e0 38 80 00 00 	movabs $0x8038e0,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	49 b9 6d 04 80 00 00 	movabs $0x80046d,%r9
  800304:	00 00 00 
  800307:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80030a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800311:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800318:	48 89 d6             	mov    %rdx,%rsi
  80031b:	48 89 c7             	mov    %rax,%rdi
  80031e:	48 b8 c1 03 80 00 00 	movabs $0x8003c1,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax
	cprintf("\n");
  80032a:	48 bf 03 39 80 00 00 	movabs $0x803903,%rdi
  800331:	00 00 00 
  800334:	b8 00 00 00 00       	mov    $0x0,%eax
  800339:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
  800340:	00 00 00 
  800343:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800345:	cc                   	int3   
  800346:	eb fd                	jmp    800345 <_panic+0x111>

0000000000800348 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800348:	55                   	push   %rbp
  800349:	48 89 e5             	mov    %rsp,%rbp
  80034c:	48 83 ec 10          	sub    $0x10,%rsp
  800350:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800353:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80035b:	8b 00                	mov    (%rax),%eax
  80035d:	8d 48 01             	lea    0x1(%rax),%ecx
  800360:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800364:	89 0a                	mov    %ecx,(%rdx)
  800366:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800369:	89 d1                	mov    %edx,%ecx
  80036b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036f:	48 98                	cltq   
  800371:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800379:	8b 00                	mov    (%rax),%eax
  80037b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800380:	75 2c                	jne    8003ae <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800386:	8b 00                	mov    (%rax),%eax
  800388:	48 98                	cltq   
  80038a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038e:	48 83 c2 08          	add    $0x8,%rdx
  800392:	48 89 c6             	mov    %rax,%rsi
  800395:	48 89 d7             	mov    %rdx,%rdi
  800398:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
        b->idx = 0;
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b2:	8b 40 04             	mov    0x4(%rax),%eax
  8003b5:	8d 50 01             	lea    0x1(%rax),%edx
  8003b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bc:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003bf:	c9                   	leaveq 
  8003c0:	c3                   	retq   

00000000008003c1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003c1:	55                   	push   %rbp
  8003c2:	48 89 e5             	mov    %rsp,%rbp
  8003c5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003cc:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003d3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003da:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003e1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003e8:	48 8b 0a             	mov    (%rdx),%rcx
  8003eb:	48 89 08             	mov    %rcx,(%rax)
  8003ee:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003f2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003f6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003fa:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800405:	00 00 00 
    b.cnt = 0;
  800408:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80040f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800412:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800419:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800420:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800427:	48 89 c6             	mov    %rax,%rsi
  80042a:	48 bf 48 03 80 00 00 	movabs $0x800348,%rdi
  800431:	00 00 00 
  800434:	48 b8 20 08 80 00 00 	movabs $0x800820,%rax
  80043b:	00 00 00 
  80043e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800440:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800446:	48 98                	cltq   
  800448:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80044f:	48 83 c2 08          	add    $0x8,%rdx
  800453:	48 89 c6             	mov    %rax,%rsi
  800456:	48 89 d7             	mov    %rdx,%rdi
  800459:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  800460:	00 00 00 
  800463:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800465:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80046b:	c9                   	leaveq 
  80046c:	c3                   	retq   

000000000080046d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80046d:	55                   	push   %rbp
  80046e:	48 89 e5             	mov    %rsp,%rbp
  800471:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800478:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80047f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800486:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80048d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800494:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80049b:	84 c0                	test   %al,%al
  80049d:	74 20                	je     8004bf <cprintf+0x52>
  80049f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004a3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004a7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004ab:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004af:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004b3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004b7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004bb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004bf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004c6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004cd:	00 00 00 
  8004d0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004d7:	00 00 00 
  8004da:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004de:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004e5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004ec:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004f3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004fa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800501:	48 8b 0a             	mov    (%rdx),%rcx
  800504:	48 89 08             	mov    %rcx,(%rax)
  800507:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80050b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80050f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800513:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800517:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80051e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800525:	48 89 d6             	mov    %rdx,%rsi
  800528:	48 89 c7             	mov    %rax,%rdi
  80052b:	48 b8 c1 03 80 00 00 	movabs $0x8003c1,%rax
  800532:	00 00 00 
  800535:	ff d0                	callq  *%rax
  800537:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80053d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800543:	c9                   	leaveq 
  800544:	c3                   	retq   

0000000000800545 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800545:	55                   	push   %rbp
  800546:	48 89 e5             	mov    %rsp,%rbp
  800549:	53                   	push   %rbx
  80054a:	48 83 ec 38          	sub    $0x38,%rsp
  80054e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800552:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800556:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80055a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80055d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800561:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800565:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800568:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80056c:	77 3b                	ja     8005a9 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80056e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800571:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800575:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800578:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80057c:	ba 00 00 00 00       	mov    $0x0,%edx
  800581:	48 f7 f3             	div    %rbx
  800584:	48 89 c2             	mov    %rax,%rdx
  800587:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80058a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80058d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	41 89 f9             	mov    %edi,%r9d
  800598:	48 89 c7             	mov    %rax,%rdi
  80059b:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  8005a2:	00 00 00 
  8005a5:	ff d0                	callq  *%rax
  8005a7:	eb 1e                	jmp    8005c7 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005a9:	eb 12                	jmp    8005bd <printnum+0x78>
			putch(padc, putdat);
  8005ab:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005af:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b6:	48 89 ce             	mov    %rcx,%rsi
  8005b9:	89 d7                	mov    %edx,%edi
  8005bb:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005bd:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005c1:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005c5:	7f e4                	jg     8005ab <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005c7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d3:	48 f7 f1             	div    %rcx
  8005d6:	48 89 d0             	mov    %rdx,%rax
  8005d9:	48 ba 10 3b 80 00 00 	movabs $0x803b10,%rdx
  8005e0:	00 00 00 
  8005e3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005e7:	0f be d0             	movsbl %al,%edx
  8005ea:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	48 89 ce             	mov    %rcx,%rsi
  8005f5:	89 d7                	mov    %edx,%edi
  8005f7:	ff d0                	callq  *%rax
}
  8005f9:	48 83 c4 38          	add    $0x38,%rsp
  8005fd:	5b                   	pop    %rbx
  8005fe:	5d                   	pop    %rbp
  8005ff:	c3                   	retq   

0000000000800600 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800600:	55                   	push   %rbp
  800601:	48 89 e5             	mov    %rsp,%rbp
  800604:	48 83 ec 1c          	sub    $0x1c,%rsp
  800608:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80060f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800613:	7e 52                	jle    800667 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800619:	8b 00                	mov    (%rax),%eax
  80061b:	83 f8 30             	cmp    $0x30,%eax
  80061e:	73 24                	jae    800644 <getuint+0x44>
  800620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800624:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	8b 00                	mov    (%rax),%eax
  80062e:	89 c0                	mov    %eax,%eax
  800630:	48 01 d0             	add    %rdx,%rax
  800633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800637:	8b 12                	mov    (%rdx),%edx
  800639:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800640:	89 0a                	mov    %ecx,(%rdx)
  800642:	eb 17                	jmp    80065b <getuint+0x5b>
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064c:	48 89 d0             	mov    %rdx,%rax
  80064f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800657:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065b:	48 8b 00             	mov    (%rax),%rax
  80065e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800662:	e9 a3 00 00 00       	jmpq   80070a <getuint+0x10a>
	else if (lflag)
  800667:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80066b:	74 4f                	je     8006bc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	8b 00                	mov    (%rax),%eax
  800673:	83 f8 30             	cmp    $0x30,%eax
  800676:	73 24                	jae    80069c <getuint+0x9c>
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800684:	8b 00                	mov    (%rax),%eax
  800686:	89 c0                	mov    %eax,%eax
  800688:	48 01 d0             	add    %rdx,%rax
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	8b 12                	mov    (%rdx),%edx
  800691:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800694:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800698:	89 0a                	mov    %ecx,(%rdx)
  80069a:	eb 17                	jmp    8006b3 <getuint+0xb3>
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a4:	48 89 d0             	mov    %rdx,%rax
  8006a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b3:	48 8b 00             	mov    (%rax),%rax
  8006b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ba:	eb 4e                	jmp    80070a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c0:	8b 00                	mov    (%rax),%eax
  8006c2:	83 f8 30             	cmp    $0x30,%eax
  8006c5:	73 24                	jae    8006eb <getuint+0xeb>
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	8b 00                	mov    (%rax),%eax
  8006d5:	89 c0                	mov    %eax,%eax
  8006d7:	48 01 d0             	add    %rdx,%rax
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	8b 12                	mov    (%rdx),%edx
  8006e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e7:	89 0a                	mov    %ecx,(%rdx)
  8006e9:	eb 17                	jmp    800702 <getuint+0x102>
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f3:	48 89 d0             	mov    %rdx,%rax
  8006f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800702:	8b 00                	mov    (%rax),%eax
  800704:	89 c0                	mov    %eax,%eax
  800706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80070a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80070e:	c9                   	leaveq 
  80070f:	c3                   	retq   

0000000000800710 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800710:	55                   	push   %rbp
  800711:	48 89 e5             	mov    %rsp,%rbp
  800714:	48 83 ec 1c          	sub    $0x1c,%rsp
  800718:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80071c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80071f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800723:	7e 52                	jle    800777 <getint+0x67>
		x=va_arg(*ap, long long);
  800725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	83 f8 30             	cmp    $0x30,%eax
  80072e:	73 24                	jae    800754 <getint+0x44>
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	89 c0                	mov    %eax,%eax
  800740:	48 01 d0             	add    %rdx,%rax
  800743:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800747:	8b 12                	mov    (%rdx),%edx
  800749:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	89 0a                	mov    %ecx,(%rdx)
  800752:	eb 17                	jmp    80076b <getint+0x5b>
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075c:	48 89 d0             	mov    %rdx,%rax
  80075f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076b:	48 8b 00             	mov    (%rax),%rax
  80076e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800772:	e9 a3 00 00 00       	jmpq   80081a <getint+0x10a>
	else if (lflag)
  800777:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80077b:	74 4f                	je     8007cc <getint+0xbc>
		x=va_arg(*ap, long);
  80077d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800781:	8b 00                	mov    (%rax),%eax
  800783:	83 f8 30             	cmp    $0x30,%eax
  800786:	73 24                	jae    8007ac <getint+0x9c>
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	8b 00                	mov    (%rax),%eax
  800796:	89 c0                	mov    %eax,%eax
  800798:	48 01 d0             	add    %rdx,%rax
  80079b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079f:	8b 12                	mov    (%rdx),%edx
  8007a1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a8:	89 0a                	mov    %ecx,(%rdx)
  8007aa:	eb 17                	jmp    8007c3 <getint+0xb3>
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b4:	48 89 d0             	mov    %rdx,%rax
  8007b7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c3:	48 8b 00             	mov    (%rax),%rax
  8007c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ca:	eb 4e                	jmp    80081a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d0:	8b 00                	mov    (%rax),%eax
  8007d2:	83 f8 30             	cmp    $0x30,%eax
  8007d5:	73 24                	jae    8007fb <getint+0xeb>
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e3:	8b 00                	mov    (%rax),%eax
  8007e5:	89 c0                	mov    %eax,%eax
  8007e7:	48 01 d0             	add    %rdx,%rax
  8007ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ee:	8b 12                	mov    (%rdx),%edx
  8007f0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f7:	89 0a                	mov    %ecx,(%rdx)
  8007f9:	eb 17                	jmp    800812 <getint+0x102>
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800803:	48 89 d0             	mov    %rdx,%rax
  800806:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80080a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800812:	8b 00                	mov    (%rax),%eax
  800814:	48 98                	cltq   
  800816:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80081a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80081e:	c9                   	leaveq 
  80081f:	c3                   	retq   

0000000000800820 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800820:	55                   	push   %rbp
  800821:	48 89 e5             	mov    %rsp,%rbp
  800824:	41 54                	push   %r12
  800826:	53                   	push   %rbx
  800827:	48 83 ec 60          	sub    $0x60,%rsp
  80082b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80082f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800833:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800837:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80083b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80083f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800843:	48 8b 0a             	mov    (%rdx),%rcx
  800846:	48 89 08             	mov    %rcx,(%rax)
  800849:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80084d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800851:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800855:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800859:	eb 17                	jmp    800872 <vprintfmt+0x52>
			if (ch == '\0')
  80085b:	85 db                	test   %ebx,%ebx
  80085d:	0f 84 df 04 00 00    	je     800d42 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800863:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800867:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80086b:	48 89 d6             	mov    %rdx,%rsi
  80086e:	89 df                	mov    %ebx,%edi
  800870:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800872:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800876:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80087a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80087e:	0f b6 00             	movzbl (%rax),%eax
  800881:	0f b6 d8             	movzbl %al,%ebx
  800884:	83 fb 25             	cmp    $0x25,%ebx
  800887:	75 d2                	jne    80085b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800889:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80088d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800894:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80089b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008a2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008a9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008b1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b5:	0f b6 00             	movzbl (%rax),%eax
  8008b8:	0f b6 d8             	movzbl %al,%ebx
  8008bb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008be:	83 f8 55             	cmp    $0x55,%eax
  8008c1:	0f 87 47 04 00 00    	ja     800d0e <vprintfmt+0x4ee>
  8008c7:	89 c0                	mov    %eax,%eax
  8008c9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008d0:	00 
  8008d1:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  8008d8:	00 00 00 
  8008db:	48 01 d0             	add    %rdx,%rax
  8008de:	48 8b 00             	mov    (%rax),%rax
  8008e1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008e3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008e7:	eb c0                	jmp    8008a9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008e9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008ed:	eb ba                	jmp    8008a9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ef:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008f6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	c1 e0 02             	shl    $0x2,%eax
  8008fe:	01 d0                	add    %edx,%eax
  800900:	01 c0                	add    %eax,%eax
  800902:	01 d8                	add    %ebx,%eax
  800904:	83 e8 30             	sub    $0x30,%eax
  800907:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80090a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80090e:	0f b6 00             	movzbl (%rax),%eax
  800911:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800914:	83 fb 2f             	cmp    $0x2f,%ebx
  800917:	7e 0c                	jle    800925 <vprintfmt+0x105>
  800919:	83 fb 39             	cmp    $0x39,%ebx
  80091c:	7f 07                	jg     800925 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800923:	eb d1                	jmp    8008f6 <vprintfmt+0xd6>
			goto process_precision;
  800925:	eb 58                	jmp    80097f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800927:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092a:	83 f8 30             	cmp    $0x30,%eax
  80092d:	73 17                	jae    800946 <vprintfmt+0x126>
  80092f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800933:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800936:	89 c0                	mov    %eax,%eax
  800938:	48 01 d0             	add    %rdx,%rax
  80093b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093e:	83 c2 08             	add    $0x8,%edx
  800941:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800944:	eb 0f                	jmp    800955 <vprintfmt+0x135>
  800946:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094a:	48 89 d0             	mov    %rdx,%rax
  80094d:	48 83 c2 08          	add    $0x8,%rdx
  800951:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800955:	8b 00                	mov    (%rax),%eax
  800957:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80095a:	eb 23                	jmp    80097f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800960:	79 0c                	jns    80096e <vprintfmt+0x14e>
				width = 0;
  800962:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800969:	e9 3b ff ff ff       	jmpq   8008a9 <vprintfmt+0x89>
  80096e:	e9 36 ff ff ff       	jmpq   8008a9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800973:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80097a:	e9 2a ff ff ff       	jmpq   8008a9 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80097f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800983:	79 12                	jns    800997 <vprintfmt+0x177>
				width = precision, precision = -1;
  800985:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800988:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80098b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800992:	e9 12 ff ff ff       	jmpq   8008a9 <vprintfmt+0x89>
  800997:	e9 0d ff ff ff       	jmpq   8008a9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009a0:	e9 04 ff ff ff       	jmpq   8008a9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a8:	83 f8 30             	cmp    $0x30,%eax
  8009ab:	73 17                	jae    8009c4 <vprintfmt+0x1a4>
  8009ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b4:	89 c0                	mov    %eax,%eax
  8009b6:	48 01 d0             	add    %rdx,%rax
  8009b9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bc:	83 c2 08             	add    $0x8,%edx
  8009bf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c2:	eb 0f                	jmp    8009d3 <vprintfmt+0x1b3>
  8009c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c8:	48 89 d0             	mov    %rdx,%rax
  8009cb:	48 83 c2 08          	add    $0x8,%rdx
  8009cf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d3:	8b 10                	mov    (%rax),%edx
  8009d5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009dd:	48 89 ce             	mov    %rcx,%rsi
  8009e0:	89 d7                	mov    %edx,%edi
  8009e2:	ff d0                	callq  *%rax
			break;
  8009e4:	e9 53 03 00 00       	jmpq   800d3c <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ec:	83 f8 30             	cmp    $0x30,%eax
  8009ef:	73 17                	jae    800a08 <vprintfmt+0x1e8>
  8009f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f8:	89 c0                	mov    %eax,%eax
  8009fa:	48 01 d0             	add    %rdx,%rax
  8009fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a00:	83 c2 08             	add    $0x8,%edx
  800a03:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a06:	eb 0f                	jmp    800a17 <vprintfmt+0x1f7>
  800a08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0c:	48 89 d0             	mov    %rdx,%rax
  800a0f:	48 83 c2 08          	add    $0x8,%rdx
  800a13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a17:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a19:	85 db                	test   %ebx,%ebx
  800a1b:	79 02                	jns    800a1f <vprintfmt+0x1ff>
				err = -err;
  800a1d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a1f:	83 fb 15             	cmp    $0x15,%ebx
  800a22:	7f 16                	jg     800a3a <vprintfmt+0x21a>
  800a24:	48 b8 60 3a 80 00 00 	movabs $0x803a60,%rax
  800a2b:	00 00 00 
  800a2e:	48 63 d3             	movslq %ebx,%rdx
  800a31:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a35:	4d 85 e4             	test   %r12,%r12
  800a38:	75 2e                	jne    800a68 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a3a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a42:	89 d9                	mov    %ebx,%ecx
  800a44:	48 ba 21 3b 80 00 00 	movabs $0x803b21,%rdx
  800a4b:	00 00 00 
  800a4e:	48 89 c7             	mov    %rax,%rdi
  800a51:	b8 00 00 00 00       	mov    $0x0,%eax
  800a56:	49 b8 4b 0d 80 00 00 	movabs $0x800d4b,%r8
  800a5d:	00 00 00 
  800a60:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a63:	e9 d4 02 00 00       	jmpq   800d3c <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a68:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a70:	4c 89 e1             	mov    %r12,%rcx
  800a73:	48 ba 2a 3b 80 00 00 	movabs $0x803b2a,%rdx
  800a7a:	00 00 00 
  800a7d:	48 89 c7             	mov    %rax,%rdi
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	49 b8 4b 0d 80 00 00 	movabs $0x800d4b,%r8
  800a8c:	00 00 00 
  800a8f:	41 ff d0             	callq  *%r8
			break;
  800a92:	e9 a5 02 00 00       	jmpq   800d3c <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9a:	83 f8 30             	cmp    $0x30,%eax
  800a9d:	73 17                	jae    800ab6 <vprintfmt+0x296>
  800a9f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aa3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa6:	89 c0                	mov    %eax,%eax
  800aa8:	48 01 d0             	add    %rdx,%rax
  800aab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aae:	83 c2 08             	add    $0x8,%edx
  800ab1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ab4:	eb 0f                	jmp    800ac5 <vprintfmt+0x2a5>
  800ab6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aba:	48 89 d0             	mov    %rdx,%rax
  800abd:	48 83 c2 08          	add    $0x8,%rdx
  800ac1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac5:	4c 8b 20             	mov    (%rax),%r12
  800ac8:	4d 85 e4             	test   %r12,%r12
  800acb:	75 0a                	jne    800ad7 <vprintfmt+0x2b7>
				p = "(null)";
  800acd:	49 bc 2d 3b 80 00 00 	movabs $0x803b2d,%r12
  800ad4:	00 00 00 
			if (width > 0 && padc != '-')
  800ad7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800adb:	7e 3f                	jle    800b1c <vprintfmt+0x2fc>
  800add:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ae1:	74 39                	je     800b1c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae6:	48 98                	cltq   
  800ae8:	48 89 c6             	mov    %rax,%rsi
  800aeb:	4c 89 e7             	mov    %r12,%rdi
  800aee:	48 b8 f7 0f 80 00 00 	movabs $0x800ff7,%rax
  800af5:	00 00 00 
  800af8:	ff d0                	callq  *%rax
  800afa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800afd:	eb 17                	jmp    800b16 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800aff:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b03:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0b:	48 89 ce             	mov    %rcx,%rsi
  800b0e:	89 d7                	mov    %edx,%edi
  800b10:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b12:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1a:	7f e3                	jg     800aff <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1c:	eb 37                	jmp    800b55 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b22:	74 1e                	je     800b42 <vprintfmt+0x322>
  800b24:	83 fb 1f             	cmp    $0x1f,%ebx
  800b27:	7e 05                	jle    800b2e <vprintfmt+0x30e>
  800b29:	83 fb 7e             	cmp    $0x7e,%ebx
  800b2c:	7e 14                	jle    800b42 <vprintfmt+0x322>
					putch('?', putdat);
  800b2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b36:	48 89 d6             	mov    %rdx,%rsi
  800b39:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b3e:	ff d0                	callq  *%rax
  800b40:	eb 0f                	jmp    800b51 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4a:	48 89 d6             	mov    %rdx,%rsi
  800b4d:	89 df                	mov    %ebx,%edi
  800b4f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b51:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b55:	4c 89 e0             	mov    %r12,%rax
  800b58:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b5c:	0f b6 00             	movzbl (%rax),%eax
  800b5f:	0f be d8             	movsbl %al,%ebx
  800b62:	85 db                	test   %ebx,%ebx
  800b64:	74 10                	je     800b76 <vprintfmt+0x356>
  800b66:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b6a:	78 b2                	js     800b1e <vprintfmt+0x2fe>
  800b6c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b70:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b74:	79 a8                	jns    800b1e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b76:	eb 16                	jmp    800b8e <vprintfmt+0x36e>
				putch(' ', putdat);
  800b78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b80:	48 89 d6             	mov    %rdx,%rsi
  800b83:	bf 20 00 00 00       	mov    $0x20,%edi
  800b88:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b92:	7f e4                	jg     800b78 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b94:	e9 a3 01 00 00       	jmpq   800d3c <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b99:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b9d:	be 03 00 00 00       	mov    $0x3,%esi
  800ba2:	48 89 c7             	mov    %rax,%rdi
  800ba5:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800bac:	00 00 00 
  800baf:	ff d0                	callq  *%rax
  800bb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb9:	48 85 c0             	test   %rax,%rax
  800bbc:	79 1d                	jns    800bdb <vprintfmt+0x3bb>
				putch('-', putdat);
  800bbe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc6:	48 89 d6             	mov    %rdx,%rsi
  800bc9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bce:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd4:	48 f7 d8             	neg    %rax
  800bd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bdb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be2:	e9 e8 00 00 00       	jmpq   800ccf <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800be7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800beb:	be 03 00 00 00       	mov    $0x3,%esi
  800bf0:	48 89 c7             	mov    %rax,%rdi
  800bf3:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  800bfa:	00 00 00 
  800bfd:	ff d0                	callq  *%rax
  800bff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c03:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c0a:	e9 c0 00 00 00       	jmpq   800ccf <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c17:	48 89 d6             	mov    %rdx,%rsi
  800c1a:	bf 58 00 00 00       	mov    $0x58,%edi
  800c1f:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c29:	48 89 d6             	mov    %rdx,%rsi
  800c2c:	bf 58 00 00 00       	mov    $0x58,%edi
  800c31:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3b:	48 89 d6             	mov    %rdx,%rsi
  800c3e:	bf 58 00 00 00       	mov    $0x58,%edi
  800c43:	ff d0                	callq  *%rax
			break;
  800c45:	e9 f2 00 00 00       	jmpq   800d3c <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c52:	48 89 d6             	mov    %rdx,%rsi
  800c55:	bf 30 00 00 00       	mov    $0x30,%edi
  800c5a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	bf 78 00 00 00       	mov    $0x78,%edi
  800c6c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c71:	83 f8 30             	cmp    $0x30,%eax
  800c74:	73 17                	jae    800c8d <vprintfmt+0x46d>
  800c76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7d:	89 c0                	mov    %eax,%eax
  800c7f:	48 01 d0             	add    %rdx,%rax
  800c82:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c85:	83 c2 08             	add    $0x8,%edx
  800c88:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8b:	eb 0f                	jmp    800c9c <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800c8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c91:	48 89 d0             	mov    %rdx,%rax
  800c94:	48 83 c2 08          	add    $0x8,%rdx
  800c98:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ca3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800caa:	eb 23                	jmp    800ccf <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb0:	be 03 00 00 00       	mov    $0x3,%esi
  800cb5:	48 89 c7             	mov    %rax,%rdi
  800cb8:	48 b8 00 06 80 00 00 	movabs $0x800600,%rax
  800cbf:	00 00 00 
  800cc2:	ff d0                	callq  *%rax
  800cc4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cc8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ccf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cd4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cd7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cde:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ce2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce6:	45 89 c1             	mov    %r8d,%r9d
  800ce9:	41 89 f8             	mov    %edi,%r8d
  800cec:	48 89 c7             	mov    %rax,%rdi
  800cef:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  800cf6:	00 00 00 
  800cf9:	ff d0                	callq  *%rax
			break;
  800cfb:	eb 3f                	jmp    800d3c <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d05:	48 89 d6             	mov    %rdx,%rsi
  800d08:	89 df                	mov    %ebx,%edi
  800d0a:	ff d0                	callq  *%rax
			break;
  800d0c:	eb 2e                	jmp    800d3c <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d16:	48 89 d6             	mov    %rdx,%rsi
  800d19:	bf 25 00 00 00       	mov    $0x25,%edi
  800d1e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d20:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d25:	eb 05                	jmp    800d2c <vprintfmt+0x50c>
  800d27:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d2c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d30:	48 83 e8 01          	sub    $0x1,%rax
  800d34:	0f b6 00             	movzbl (%rax),%eax
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 ec                	jne    800d27 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d3d:	e9 30 fb ff ff       	jmpq   800872 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d42:	48 83 c4 60          	add    $0x60,%rsp
  800d46:	5b                   	pop    %rbx
  800d47:	41 5c                	pop    %r12
  800d49:	5d                   	pop    %rbp
  800d4a:	c3                   	retq   

0000000000800d4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4b:	55                   	push   %rbp
  800d4c:	48 89 e5             	mov    %rsp,%rbp
  800d4f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d56:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d5d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d64:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d6b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d72:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d79:	84 c0                	test   %al,%al
  800d7b:	74 20                	je     800d9d <printfmt+0x52>
  800d7d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d81:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d85:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d89:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d8d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d91:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d95:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d99:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d9d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800da4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dab:	00 00 00 
  800dae:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800db5:	00 00 00 
  800db8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dbc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dc3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dca:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd1:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dd8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ddf:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800de6:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ded:	48 89 c7             	mov    %rax,%rdi
  800df0:	48 b8 20 08 80 00 00 	movabs $0x800820,%rax
  800df7:	00 00 00 
  800dfa:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dfc:	c9                   	leaveq 
  800dfd:	c3                   	retq   

0000000000800dfe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dfe:	55                   	push   %rbp
  800dff:	48 89 e5             	mov    %rsp,%rbp
  800e02:	48 83 ec 10          	sub    $0x10,%rsp
  800e06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e11:	8b 40 10             	mov    0x10(%rax),%eax
  800e14:	8d 50 01             	lea    0x1(%rax),%edx
  800e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e22:	48 8b 10             	mov    (%rax),%rdx
  800e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e29:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e2d:	48 39 c2             	cmp    %rax,%rdx
  800e30:	73 17                	jae    800e49 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e36:	48 8b 00             	mov    (%rax),%rax
  800e39:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e41:	48 89 0a             	mov    %rcx,(%rdx)
  800e44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e47:	88 10                	mov    %dl,(%rax)
}
  800e49:	c9                   	leaveq 
  800e4a:	c3                   	retq   

0000000000800e4b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e4b:	55                   	push   %rbp
  800e4c:	48 89 e5             	mov    %rsp,%rbp
  800e4f:	48 83 ec 50          	sub    $0x50,%rsp
  800e53:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e57:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e5a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e5e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e62:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e66:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e6a:	48 8b 0a             	mov    (%rdx),%rcx
  800e6d:	48 89 08             	mov    %rcx,(%rax)
  800e70:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e74:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e78:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e7c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e80:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e84:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e88:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e8b:	48 98                	cltq   
  800e8d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e91:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e95:	48 01 d0             	add    %rdx,%rax
  800e98:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e9c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ea3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ea8:	74 06                	je     800eb0 <vsnprintf+0x65>
  800eaa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eae:	7f 07                	jg     800eb7 <vsnprintf+0x6c>
		return -E_INVAL;
  800eb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb5:	eb 2f                	jmp    800ee6 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eb7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ebb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ebf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ec3:	48 89 c6             	mov    %rax,%rsi
  800ec6:	48 bf fe 0d 80 00 00 	movabs $0x800dfe,%rdi
  800ecd:	00 00 00 
  800ed0:	48 b8 20 08 80 00 00 	movabs $0x800820,%rax
  800ed7:	00 00 00 
  800eda:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800edc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ee0:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ee3:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ee6:	c9                   	leaveq 
  800ee7:	c3                   	retq   

0000000000800ee8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee8:	55                   	push   %rbp
  800ee9:	48 89 e5             	mov    %rsp,%rbp
  800eec:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ef3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800efa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f00:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f07:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f0e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f15:	84 c0                	test   %al,%al
  800f17:	74 20                	je     800f39 <snprintf+0x51>
  800f19:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f1d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f21:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f25:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f29:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f2d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f31:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f35:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f39:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f40:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f47:	00 00 00 
  800f4a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f51:	00 00 00 
  800f54:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f58:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f5f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f66:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f6d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f74:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f7b:	48 8b 0a             	mov    (%rdx),%rcx
  800f7e:	48 89 08             	mov    %rcx,(%rax)
  800f81:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f85:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f89:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f8d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f91:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f98:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f9f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fa5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fac:	48 89 c7             	mov    %rax,%rdi
  800faf:	48 b8 4b 0e 80 00 00 	movabs $0x800e4b,%rax
  800fb6:	00 00 00 
  800fb9:	ff d0                	callq  *%rax
  800fbb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fc1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fc7:	c9                   	leaveq 
  800fc8:	c3                   	retq   

0000000000800fc9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fc9:	55                   	push   %rbp
  800fca:	48 89 e5             	mov    %rsp,%rbp
  800fcd:	48 83 ec 18          	sub    $0x18,%rsp
  800fd1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fdc:	eb 09                	jmp    800fe7 <strlen+0x1e>
		n++;
  800fde:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800feb:	0f b6 00             	movzbl (%rax),%eax
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ec                	jne    800fde <strlen+0x15>
		n++;
	return n;
  800ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ff5:	c9                   	leaveq 
  800ff6:	c3                   	retq   

0000000000800ff7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ff7:	55                   	push   %rbp
  800ff8:	48 89 e5             	mov    %rsp,%rbp
  800ffb:	48 83 ec 20          	sub    $0x20,%rsp
  800fff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801003:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801007:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80100e:	eb 0e                	jmp    80101e <strnlen+0x27>
		n++;
  801010:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801014:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801019:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80101e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801023:	74 0b                	je     801030 <strnlen+0x39>
  801025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801029:	0f b6 00             	movzbl (%rax),%eax
  80102c:	84 c0                	test   %al,%al
  80102e:	75 e0                	jne    801010 <strnlen+0x19>
		n++;
	return n;
  801030:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801033:	c9                   	leaveq 
  801034:	c3                   	retq   

0000000000801035 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	48 83 ec 20          	sub    $0x20,%rsp
  80103d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801041:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801049:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80104d:	90                   	nop
  80104e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801052:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801056:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80105a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80105e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801062:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801066:	0f b6 12             	movzbl (%rdx),%edx
  801069:	88 10                	mov    %dl,(%rax)
  80106b:	0f b6 00             	movzbl (%rax),%eax
  80106e:	84 c0                	test   %al,%al
  801070:	75 dc                	jne    80104e <strcpy+0x19>
		/* do nothing */;
	return ret;
  801072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801076:	c9                   	leaveq 
  801077:	c3                   	retq   

0000000000801078 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801078:	55                   	push   %rbp
  801079:	48 89 e5             	mov    %rsp,%rbp
  80107c:	48 83 ec 20          	sub    $0x20,%rsp
  801080:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801084:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	48 89 c7             	mov    %rax,%rdi
  80108f:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  801096:	00 00 00 
  801099:	ff d0                	callq  *%rax
  80109b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80109e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a1:	48 63 d0             	movslq %eax,%rdx
  8010a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a8:	48 01 c2             	add    %rax,%rdx
  8010ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010af:	48 89 c6             	mov    %rax,%rsi
  8010b2:	48 89 d7             	mov    %rdx,%rdi
  8010b5:	48 b8 35 10 80 00 00 	movabs $0x801035,%rax
  8010bc:	00 00 00 
  8010bf:	ff d0                	callq  *%rax
	return dst;
  8010c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010c5:	c9                   	leaveq 
  8010c6:	c3                   	retq   

00000000008010c7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	48 83 ec 28          	sub    $0x28,%rsp
  8010cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010e3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010ea:	00 
  8010eb:	eb 2a                	jmp    801117 <strncpy+0x50>
		*dst++ = *src;
  8010ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010fd:	0f b6 12             	movzbl (%rdx),%edx
  801100:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801102:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801106:	0f b6 00             	movzbl (%rax),%eax
  801109:	84 c0                	test   %al,%al
  80110b:	74 05                	je     801112 <strncpy+0x4b>
			src++;
  80110d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801112:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801117:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80111f:	72 cc                	jb     8010ed <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801125:	c9                   	leaveq 
  801126:	c3                   	retq   

0000000000801127 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	48 83 ec 28          	sub    $0x28,%rsp
  80112f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801133:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801137:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801143:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801148:	74 3d                	je     801187 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80114a:	eb 1d                	jmp    801169 <strlcpy+0x42>
			*dst++ = *src++;
  80114c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801150:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801154:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801158:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80115c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801160:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801164:	0f b6 12             	movzbl (%rdx),%edx
  801167:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801169:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80116e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801173:	74 0b                	je     801180 <strlcpy+0x59>
  801175:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801179:	0f b6 00             	movzbl (%rax),%eax
  80117c:	84 c0                	test   %al,%al
  80117e:	75 cc                	jne    80114c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801184:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801187:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80118b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118f:	48 29 c2             	sub    %rax,%rdx
  801192:	48 89 d0             	mov    %rdx,%rax
}
  801195:	c9                   	leaveq 
  801196:	c3                   	retq   

0000000000801197 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801197:	55                   	push   %rbp
  801198:	48 89 e5             	mov    %rsp,%rbp
  80119b:	48 83 ec 10          	sub    $0x10,%rsp
  80119f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011a7:	eb 0a                	jmp    8011b3 <strcmp+0x1c>
		p++, q++;
  8011a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ae:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b7:	0f b6 00             	movzbl (%rax),%eax
  8011ba:	84 c0                	test   %al,%al
  8011bc:	74 12                	je     8011d0 <strcmp+0x39>
  8011be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c2:	0f b6 10             	movzbl (%rax),%edx
  8011c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	38 c2                	cmp    %al,%dl
  8011ce:	74 d9                	je     8011a9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d4:	0f b6 00             	movzbl (%rax),%eax
  8011d7:	0f b6 d0             	movzbl %al,%edx
  8011da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011de:	0f b6 00             	movzbl (%rax),%eax
  8011e1:	0f b6 c0             	movzbl %al,%eax
  8011e4:	29 c2                	sub    %eax,%edx
  8011e6:	89 d0                	mov    %edx,%eax
}
  8011e8:	c9                   	leaveq 
  8011e9:	c3                   	retq   

00000000008011ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011ea:	55                   	push   %rbp
  8011eb:	48 89 e5             	mov    %rsp,%rbp
  8011ee:	48 83 ec 18          	sub    $0x18,%rsp
  8011f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011fe:	eb 0f                	jmp    80120f <strncmp+0x25>
		n--, p++, q++;
  801200:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801205:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80120f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801214:	74 1d                	je     801233 <strncmp+0x49>
  801216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121a:	0f b6 00             	movzbl (%rax),%eax
  80121d:	84 c0                	test   %al,%al
  80121f:	74 12                	je     801233 <strncmp+0x49>
  801221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801225:	0f b6 10             	movzbl (%rax),%edx
  801228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122c:	0f b6 00             	movzbl (%rax),%eax
  80122f:	38 c2                	cmp    %al,%dl
  801231:	74 cd                	je     801200 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801233:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801238:	75 07                	jne    801241 <strncmp+0x57>
		return 0;
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
  80123f:	eb 18                	jmp    801259 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801245:	0f b6 00             	movzbl (%rax),%eax
  801248:	0f b6 d0             	movzbl %al,%edx
  80124b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124f:	0f b6 00             	movzbl (%rax),%eax
  801252:	0f b6 c0             	movzbl %al,%eax
  801255:	29 c2                	sub    %eax,%edx
  801257:	89 d0                	mov    %edx,%eax
}
  801259:	c9                   	leaveq 
  80125a:	c3                   	retq   

000000000080125b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80125b:	55                   	push   %rbp
  80125c:	48 89 e5             	mov    %rsp,%rbp
  80125f:	48 83 ec 0c          	sub    $0xc,%rsp
  801263:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801267:	89 f0                	mov    %esi,%eax
  801269:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80126c:	eb 17                	jmp    801285 <strchr+0x2a>
		if (*s == c)
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	0f b6 00             	movzbl (%rax),%eax
  801275:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801278:	75 06                	jne    801280 <strchr+0x25>
			return (char *) s;
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	eb 15                	jmp    801295 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	0f b6 00             	movzbl (%rax),%eax
  80128c:	84 c0                	test   %al,%al
  80128e:	75 de                	jne    80126e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801295:	c9                   	leaveq 
  801296:	c3                   	retq   

0000000000801297 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801297:	55                   	push   %rbp
  801298:	48 89 e5             	mov    %rsp,%rbp
  80129b:	48 83 ec 0c          	sub    $0xc,%rsp
  80129f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a3:	89 f0                	mov    %esi,%eax
  8012a5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a8:	eb 13                	jmp    8012bd <strfind+0x26>
		if (*s == c)
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012b4:	75 02                	jne    8012b8 <strfind+0x21>
			break;
  8012b6:	eb 10                	jmp    8012c8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c1:	0f b6 00             	movzbl (%rax),%eax
  8012c4:	84 c0                	test   %al,%al
  8012c6:	75 e2                	jne    8012aa <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 18          	sub    $0x18,%rsp
  8012d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012da:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012dd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e6:	75 06                	jne    8012ee <memset+0x20>
		return v;
  8012e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ec:	eb 69                	jmp    801357 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	83 e0 03             	and    $0x3,%eax
  8012f5:	48 85 c0             	test   %rax,%rax
  8012f8:	75 48                	jne    801342 <memset+0x74>
  8012fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fe:	83 e0 03             	and    $0x3,%eax
  801301:	48 85 c0             	test   %rax,%rax
  801304:	75 3c                	jne    801342 <memset+0x74>
		c &= 0xFF;
  801306:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80130d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801310:	c1 e0 18             	shl    $0x18,%eax
  801313:	89 c2                	mov    %eax,%edx
  801315:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801318:	c1 e0 10             	shl    $0x10,%eax
  80131b:	09 c2                	or     %eax,%edx
  80131d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801320:	c1 e0 08             	shl    $0x8,%eax
  801323:	09 d0                	or     %edx,%eax
  801325:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132c:	48 c1 e8 02          	shr    $0x2,%rax
  801330:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801333:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801337:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133a:	48 89 d7             	mov    %rdx,%rdi
  80133d:	fc                   	cld    
  80133e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801340:	eb 11                	jmp    801353 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801342:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801346:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801349:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80134d:	48 89 d7             	mov    %rdx,%rdi
  801350:	fc                   	cld    
  801351:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801357:	c9                   	leaveq 
  801358:	c3                   	retq   

0000000000801359 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801359:	55                   	push   %rbp
  80135a:	48 89 e5             	mov    %rsp,%rbp
  80135d:	48 83 ec 28          	sub    $0x28,%rsp
  801361:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801365:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801369:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80136d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801371:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801379:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801381:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801385:	0f 83 88 00 00 00    	jae    801413 <memmove+0xba>
  80138b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801393:	48 01 d0             	add    %rdx,%rax
  801396:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80139a:	76 77                	jbe    801413 <memmove+0xba>
		s += n;
  80139c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b0:	83 e0 03             	and    $0x3,%eax
  8013b3:	48 85 c0             	test   %rax,%rax
  8013b6:	75 3b                	jne    8013f3 <memmove+0x9a>
  8013b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bc:	83 e0 03             	and    $0x3,%eax
  8013bf:	48 85 c0             	test   %rax,%rax
  8013c2:	75 2f                	jne    8013f3 <memmove+0x9a>
  8013c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c8:	83 e0 03             	and    $0x3,%eax
  8013cb:	48 85 c0             	test   %rax,%rax
  8013ce:	75 23                	jne    8013f3 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d4:	48 83 e8 04          	sub    $0x4,%rax
  8013d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013dc:	48 83 ea 04          	sub    $0x4,%rdx
  8013e0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013e4:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013e8:	48 89 c7             	mov    %rax,%rdi
  8013eb:	48 89 d6             	mov    %rdx,%rsi
  8013ee:	fd                   	std    
  8013ef:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013f1:	eb 1d                	jmp    801410 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ff:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801407:	48 89 d7             	mov    %rdx,%rdi
  80140a:	48 89 c1             	mov    %rax,%rcx
  80140d:	fd                   	std    
  80140e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801410:	fc                   	cld    
  801411:	eb 57                	jmp    80146a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801413:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801417:	83 e0 03             	and    $0x3,%eax
  80141a:	48 85 c0             	test   %rax,%rax
  80141d:	75 36                	jne    801455 <memmove+0xfc>
  80141f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801423:	83 e0 03             	and    $0x3,%eax
  801426:	48 85 c0             	test   %rax,%rax
  801429:	75 2a                	jne    801455 <memmove+0xfc>
  80142b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142f:	83 e0 03             	and    $0x3,%eax
  801432:	48 85 c0             	test   %rax,%rax
  801435:	75 1e                	jne    801455 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143b:	48 c1 e8 02          	shr    $0x2,%rax
  80143f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144a:	48 89 c7             	mov    %rax,%rdi
  80144d:	48 89 d6             	mov    %rdx,%rsi
  801450:	fc                   	cld    
  801451:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801453:	eb 15                	jmp    80146a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801459:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801461:	48 89 c7             	mov    %rax,%rdi
  801464:	48 89 d6             	mov    %rdx,%rsi
  801467:	fc                   	cld    
  801468:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80146a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80146e:	c9                   	leaveq 
  80146f:	c3                   	retq   

0000000000801470 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801470:	55                   	push   %rbp
  801471:	48 89 e5             	mov    %rsp,%rbp
  801474:	48 83 ec 18          	sub    $0x18,%rsp
  801478:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801480:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801484:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801488:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801490:	48 89 ce             	mov    %rcx,%rsi
  801493:	48 89 c7             	mov    %rax,%rdi
  801496:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  80149d:	00 00 00 
  8014a0:	ff d0                	callq  *%rax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 28          	sub    $0x28,%rsp
  8014ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014c8:	eb 36                	jmp    801500 <memcmp+0x5c>
		if (*s1 != *s2)
  8014ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ce:	0f b6 10             	movzbl (%rax),%edx
  8014d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	38 c2                	cmp    %al,%dl
  8014da:	74 1a                	je     8014f6 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	0f b6 d0             	movzbl %al,%edx
  8014e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	0f b6 c0             	movzbl %al,%eax
  8014f0:	29 c2                	sub    %eax,%edx
  8014f2:	89 d0                	mov    %edx,%eax
  8014f4:	eb 20                	jmp    801516 <memcmp+0x72>
		s1++, s2++;
  8014f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014fb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801508:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80150c:	48 85 c0             	test   %rax,%rax
  80150f:	75 b9                	jne    8014ca <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801516:	c9                   	leaveq 
  801517:	c3                   	retq   

0000000000801518 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801518:	55                   	push   %rbp
  801519:	48 89 e5             	mov    %rsp,%rbp
  80151c:	48 83 ec 28          	sub    $0x28,%rsp
  801520:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801524:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801527:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801533:	48 01 d0             	add    %rdx,%rax
  801536:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80153a:	eb 15                	jmp    801551 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80153c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801540:	0f b6 10             	movzbl (%rax),%edx
  801543:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801546:	38 c2                	cmp    %al,%dl
  801548:	75 02                	jne    80154c <memfind+0x34>
			break;
  80154a:	eb 0f                	jmp    80155b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80154c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801555:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801559:	72 e1                	jb     80153c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80155b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80155f:	c9                   	leaveq 
  801560:	c3                   	retq   

0000000000801561 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801561:	55                   	push   %rbp
  801562:	48 89 e5             	mov    %rsp,%rbp
  801565:	48 83 ec 34          	sub    $0x34,%rsp
  801569:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80156d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801571:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801574:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80157b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801582:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801583:	eb 05                	jmp    80158a <strtol+0x29>
		s++;
  801585:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80158a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158e:	0f b6 00             	movzbl (%rax),%eax
  801591:	3c 20                	cmp    $0x20,%al
  801593:	74 f0                	je     801585 <strtol+0x24>
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	0f b6 00             	movzbl (%rax),%eax
  80159c:	3c 09                	cmp    $0x9,%al
  80159e:	74 e5                	je     801585 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a4:	0f b6 00             	movzbl (%rax),%eax
  8015a7:	3c 2b                	cmp    $0x2b,%al
  8015a9:	75 07                	jne    8015b2 <strtol+0x51>
		s++;
  8015ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b0:	eb 17                	jmp    8015c9 <strtol+0x68>
	else if (*s == '-')
  8015b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b6:	0f b6 00             	movzbl (%rax),%eax
  8015b9:	3c 2d                	cmp    $0x2d,%al
  8015bb:	75 0c                	jne    8015c9 <strtol+0x68>
		s++, neg = 1;
  8015bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015cd:	74 06                	je     8015d5 <strtol+0x74>
  8015cf:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015d3:	75 28                	jne    8015fd <strtol+0x9c>
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	3c 30                	cmp    $0x30,%al
  8015de:	75 1d                	jne    8015fd <strtol+0x9c>
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	48 83 c0 01          	add    $0x1,%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	3c 78                	cmp    $0x78,%al
  8015ed:	75 0e                	jne    8015fd <strtol+0x9c>
		s += 2, base = 16;
  8015ef:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015f4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015fb:	eb 2c                	jmp    801629 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801601:	75 19                	jne    80161c <strtol+0xbb>
  801603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	3c 30                	cmp    $0x30,%al
  80160c:	75 0e                	jne    80161c <strtol+0xbb>
		s++, base = 8;
  80160e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801613:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xc8>
	else if (base == 0)
  80161c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801620:	75 07                	jne    801629 <strtol+0xc8>
		base = 10;
  801622:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	3c 2f                	cmp    $0x2f,%al
  801632:	7e 1d                	jle    801651 <strtol+0xf0>
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3c 39                	cmp    $0x39,%al
  80163d:	7f 12                	jg     801651 <strtol+0xf0>
			dig = *s - '0';
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	0f be c0             	movsbl %al,%eax
  801649:	83 e8 30             	sub    $0x30,%eax
  80164c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80164f:	eb 4e                	jmp    80169f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 60                	cmp    $0x60,%al
  80165a:	7e 1d                	jle    801679 <strtol+0x118>
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	0f b6 00             	movzbl (%rax),%eax
  801663:	3c 7a                	cmp    $0x7a,%al
  801665:	7f 12                	jg     801679 <strtol+0x118>
			dig = *s - 'a' + 10;
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	0f be c0             	movsbl %al,%eax
  801671:	83 e8 57             	sub    $0x57,%eax
  801674:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801677:	eb 26                	jmp    80169f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	3c 40                	cmp    $0x40,%al
  801682:	7e 48                	jle    8016cc <strtol+0x16b>
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	3c 5a                	cmp    $0x5a,%al
  80168d:	7f 3d                	jg     8016cc <strtol+0x16b>
			dig = *s - 'A' + 10;
  80168f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801693:	0f b6 00             	movzbl (%rax),%eax
  801696:	0f be c0             	movsbl %al,%eax
  801699:	83 e8 37             	sub    $0x37,%eax
  80169c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80169f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016a5:	7c 02                	jl     8016a9 <strtol+0x148>
			break;
  8016a7:	eb 23                	jmp    8016cc <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ae:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016b1:	48 98                	cltq   
  8016b3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016b8:	48 89 c2             	mov    %rax,%rdx
  8016bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016be:	48 98                	cltq   
  8016c0:	48 01 d0             	add    %rdx,%rax
  8016c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016c7:	e9 5d ff ff ff       	jmpq   801629 <strtol+0xc8>

	if (endptr)
  8016cc:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016d1:	74 0b                	je     8016de <strtol+0x17d>
		*endptr = (char *) s;
  8016d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016db:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016e2:	74 09                	je     8016ed <strtol+0x18c>
  8016e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e8:	48 f7 d8             	neg    %rax
  8016eb:	eb 04                	jmp    8016f1 <strtol+0x190>
  8016ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 30          	sub    $0x30,%rsp
  8016fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801703:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801707:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80170b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801715:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801719:	75 06                	jne    801721 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80171b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171f:	eb 6b                	jmp    80178c <strstr+0x99>

	len = strlen(str);
  801721:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801725:	48 89 c7             	mov    %rax,%rdi
  801728:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  80172f:	00 00 00 
  801732:	ff d0                	callq  *%rax
  801734:	48 98                	cltq   
  801736:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801742:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80174c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801750:	75 07                	jne    801759 <strstr+0x66>
				return (char *) 0;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	eb 33                	jmp    80178c <strstr+0x99>
		} while (sc != c);
  801759:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80175d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801760:	75 d8                	jne    80173a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801762:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801766:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80176a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176e:	48 89 ce             	mov    %rcx,%rsi
  801771:	48 89 c7             	mov    %rax,%rdi
  801774:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	callq  *%rax
  801780:	85 c0                	test   %eax,%eax
  801782:	75 b6                	jne    80173a <strstr+0x47>

	return (char *) (in - 1);
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	48 83 e8 01          	sub    $0x1,%rax
}
  80178c:	c9                   	leaveq 
  80178d:	c3                   	retq   

000000000080178e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80178e:	55                   	push   %rbp
  80178f:	48 89 e5             	mov    %rsp,%rbp
  801792:	53                   	push   %rbx
  801793:	48 83 ec 48          	sub    $0x48,%rsp
  801797:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80179a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80179d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017a1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017a5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017a9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017b0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017b4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017b8:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017bc:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017c0:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017c4:	4c 89 c3             	mov    %r8,%rbx
  8017c7:	cd 30                	int    $0x30
  8017c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017d1:	74 3e                	je     801811 <syscall+0x83>
  8017d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017d8:	7e 37                	jle    801811 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017e1:	49 89 d0             	mov    %rdx,%r8
  8017e4:	89 c1                	mov    %eax,%ecx
  8017e6:	48 ba e8 3d 80 00 00 	movabs $0x803de8,%rdx
  8017ed:	00 00 00 
  8017f0:	be 23 00 00 00       	mov    $0x23,%esi
  8017f5:	48 bf 05 3e 80 00 00 	movabs $0x803e05,%rdi
  8017fc:	00 00 00 
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	49 b9 34 02 80 00 00 	movabs $0x800234,%r9
  80180b:	00 00 00 
  80180e:	41 ff d1             	callq  *%r9

	return ret;
  801811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801815:	48 83 c4 48          	add    $0x48,%rsp
  801819:	5b                   	pop    %rbx
  80181a:	5d                   	pop    %rbp
  80181b:	c3                   	retq   

000000000080181c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80181c:	55                   	push   %rbp
  80181d:	48 89 e5             	mov    %rsp,%rbp
  801820:	48 83 ec 20          	sub    $0x20,%rsp
  801824:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801828:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80182c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801830:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801834:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183b:	00 
  80183c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801842:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801848:	48 89 d1             	mov    %rdx,%rcx
  80184b:	48 89 c2             	mov    %rax,%rdx
  80184e:	be 00 00 00 00       	mov    $0x0,%esi
  801853:	bf 00 00 00 00       	mov    $0x0,%edi
  801858:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  80185f:	00 00 00 
  801862:	ff d0                	callq  *%rax
}
  801864:	c9                   	leaveq 
  801865:	c3                   	retq   

0000000000801866 <sys_cgetc>:

int
sys_cgetc(void)
{
  801866:	55                   	push   %rbp
  801867:	48 89 e5             	mov    %rsp,%rbp
  80186a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80186e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801875:	00 
  801876:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801882:	b9 00 00 00 00       	mov    $0x0,%ecx
  801887:	ba 00 00 00 00       	mov    $0x0,%edx
  80188c:	be 00 00 00 00       	mov    $0x0,%esi
  801891:	bf 01 00 00 00       	mov    $0x1,%edi
  801896:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  80189d:	00 00 00 
  8018a0:	ff d0                	callq  *%rax
}
  8018a2:	c9                   	leaveq 
  8018a3:	c3                   	retq   

00000000008018a4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018a4:	55                   	push   %rbp
  8018a5:	48 89 e5             	mov    %rsp,%rbp
  8018a8:	48 83 ec 10          	sub    $0x10,%rsp
  8018ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b2:	48 98                	cltq   
  8018b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018bb:	00 
  8018bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018cd:	48 89 c2             	mov    %rax,%rdx
  8018d0:	be 01 00 00 00       	mov    $0x1,%esi
  8018d5:	bf 03 00 00 00       	mov    $0x3,%edi
  8018da:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  8018e1:	00 00 00 
  8018e4:	ff d0                	callq  *%rax
}
  8018e6:	c9                   	leaveq 
  8018e7:	c3                   	retq   

00000000008018e8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018e8:	55                   	push   %rbp
  8018e9:	48 89 e5             	mov    %rsp,%rbp
  8018ec:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f7:	00 
  8018f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801904:	b9 00 00 00 00       	mov    $0x0,%ecx
  801909:	ba 00 00 00 00       	mov    $0x0,%edx
  80190e:	be 00 00 00 00       	mov    $0x0,%esi
  801913:	bf 02 00 00 00       	mov    $0x2,%edi
  801918:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  80191f:	00 00 00 
  801922:	ff d0                	callq  *%rax
}
  801924:	c9                   	leaveq 
  801925:	c3                   	retq   

0000000000801926 <sys_yield>:

void
sys_yield(void)
{
  801926:	55                   	push   %rbp
  801927:	48 89 e5             	mov    %rsp,%rbp
  80192a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80192e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801935:	00 
  801936:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801942:	b9 00 00 00 00       	mov    $0x0,%ecx
  801947:	ba 00 00 00 00       	mov    $0x0,%edx
  80194c:	be 00 00 00 00       	mov    $0x0,%esi
  801951:	bf 0b 00 00 00       	mov    $0xb,%edi
  801956:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	48 83 ec 20          	sub    $0x20,%rsp
  80196c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801973:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801976:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801979:	48 63 c8             	movslq %eax,%rcx
  80197c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801980:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801983:	48 98                	cltq   
  801985:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198c:	00 
  80198d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801993:	49 89 c8             	mov    %rcx,%r8
  801996:	48 89 d1             	mov    %rdx,%rcx
  801999:	48 89 c2             	mov    %rax,%rdx
  80199c:	be 01 00 00 00       	mov    $0x1,%esi
  8019a1:	bf 04 00 00 00       	mov    $0x4,%edi
  8019a6:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  8019ad:	00 00 00 
  8019b0:	ff d0                	callq  *%rax
}
  8019b2:	c9                   	leaveq 
  8019b3:	c3                   	retq   

00000000008019b4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019b4:	55                   	push   %rbp
  8019b5:	48 89 e5             	mov    %rsp,%rbp
  8019b8:	48 83 ec 30          	sub    $0x30,%rsp
  8019bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019c3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019c6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019ca:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019ce:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019d1:	48 63 c8             	movslq %eax,%rcx
  8019d4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019db:	48 63 f0             	movslq %eax,%rsi
  8019de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e5:	48 98                	cltq   
  8019e7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019eb:	49 89 f9             	mov    %rdi,%r9
  8019ee:	49 89 f0             	mov    %rsi,%r8
  8019f1:	48 89 d1             	mov    %rdx,%rcx
  8019f4:	48 89 c2             	mov    %rax,%rdx
  8019f7:	be 01 00 00 00       	mov    $0x1,%esi
  8019fc:	bf 05 00 00 00       	mov    $0x5,%edi
  801a01:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	callq  *%rax
}
  801a0d:	c9                   	leaveq 
  801a0e:	c3                   	retq   

0000000000801a0f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a0f:	55                   	push   %rbp
  801a10:	48 89 e5             	mov    %rsp,%rbp
  801a13:	48 83 ec 20          	sub    $0x20,%rsp
  801a17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a25:	48 98                	cltq   
  801a27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2e:	00 
  801a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3b:	48 89 d1             	mov    %rdx,%rcx
  801a3e:	48 89 c2             	mov    %rax,%rdx
  801a41:	be 01 00 00 00       	mov    $0x1,%esi
  801a46:	bf 06 00 00 00       	mov    $0x6,%edi
  801a4b:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
}
  801a57:	c9                   	leaveq 
  801a58:	c3                   	retq   

0000000000801a59 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
  801a5d:	48 83 ec 10          	sub    $0x10,%rsp
  801a61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a64:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a6a:	48 63 d0             	movslq %eax,%rdx
  801a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a70:	48 98                	cltq   
  801a72:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a79:	00 
  801a7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a86:	48 89 d1             	mov    %rdx,%rcx
  801a89:	48 89 c2             	mov    %rax,%rdx
  801a8c:	be 01 00 00 00       	mov    $0x1,%esi
  801a91:	bf 08 00 00 00       	mov    $0x8,%edi
  801a96:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  801a9d:	00 00 00 
  801aa0:	ff d0                	callq  *%rax
}
  801aa2:	c9                   	leaveq 
  801aa3:	c3                   	retq   

0000000000801aa4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801aa4:	55                   	push   %rbp
  801aa5:	48 89 e5             	mov    %rsp,%rbp
  801aa8:	48 83 ec 20          	sub    $0x20,%rsp
  801aac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ab3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aba:	48 98                	cltq   
  801abc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac3:	00 
  801ac4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad0:	48 89 d1             	mov    %rdx,%rcx
  801ad3:	48 89 c2             	mov    %rax,%rdx
  801ad6:	be 01 00 00 00       	mov    $0x1,%esi
  801adb:	bf 09 00 00 00       	mov    $0x9,%edi
  801ae0:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  801ae7:	00 00 00 
  801aea:	ff d0                	callq  *%rax
}
  801aec:	c9                   	leaveq 
  801aed:	c3                   	retq   

0000000000801aee <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aee:	55                   	push   %rbp
  801aef:	48 89 e5             	mov    %rsp,%rbp
  801af2:	48 83 ec 20          	sub    $0x20,%rsp
  801af6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801afd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b04:	48 98                	cltq   
  801b06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0d:	00 
  801b0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1a:	48 89 d1             	mov    %rdx,%rcx
  801b1d:	48 89 c2             	mov    %rax,%rdx
  801b20:	be 01 00 00 00       	mov    $0x1,%esi
  801b25:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b2a:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 20          	sub    $0x20,%rsp
  801b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b4b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b51:	48 63 f0             	movslq %eax,%rsi
  801b54:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5b:	48 98                	cltq   
  801b5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b68:	00 
  801b69:	49 89 f1             	mov    %rsi,%r9
  801b6c:	49 89 c8             	mov    %rcx,%r8
  801b6f:	48 89 d1             	mov    %rdx,%rcx
  801b72:	48 89 c2             	mov    %rax,%rdx
  801b75:	be 00 00 00 00       	mov    $0x0,%esi
  801b7a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b7f:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  801b86:	00 00 00 
  801b89:	ff d0                	callq  *%rax
}
  801b8b:	c9                   	leaveq 
  801b8c:	c3                   	retq   

0000000000801b8d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b8d:	55                   	push   %rbp
  801b8e:	48 89 e5             	mov    %rsp,%rbp
  801b91:	48 83 ec 10          	sub    $0x10,%rsp
  801b95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba4:	00 
  801ba5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb6:	48 89 c2             	mov    %rax,%rdx
  801bb9:	be 01 00 00 00       	mov    $0x1,%esi
  801bbe:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bc3:	48 b8 8e 17 80 00 00 	movabs $0x80178e,%rax
  801bca:	00 00 00 
  801bcd:	ff d0                	callq  *%rax
}
  801bcf:	c9                   	leaveq 
  801bd0:	c3                   	retq   

0000000000801bd1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801bd1:	55                   	push   %rbp
  801bd2:	48 89 e5             	mov    %rsp,%rbp
  801bd5:	48 83 ec 10          	sub    $0x10,%rsp
  801bd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801bdd:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801be4:	00 00 00 
  801be7:	48 8b 00             	mov    (%rax),%rax
  801bea:	48 85 c0             	test   %rax,%rax
  801bed:	75 49                	jne    801c38 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801bef:	ba 07 00 00 00       	mov    $0x7,%edx
  801bf4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bfe:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	79 2a                	jns    801c38 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801c0e:	48 ba 18 3e 80 00 00 	movabs $0x803e18,%rdx
  801c15:	00 00 00 
  801c18:	be 21 00 00 00       	mov    $0x21,%esi
  801c1d:	48 bf 43 3e 80 00 00 	movabs $0x803e43,%rdi
  801c24:	00 00 00 
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2c:	48 b9 34 02 80 00 00 	movabs $0x800234,%rcx
  801c33:	00 00 00 
  801c36:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c38:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801c3f:	00 00 00 
  801c42:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c46:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801c49:	48 be 94 1c 80 00 00 	movabs $0x801c94,%rsi
  801c50:	00 00 00 
  801c53:	bf 00 00 00 00       	mov    $0x0,%edi
  801c58:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	callq  *%rax
  801c64:	85 c0                	test   %eax,%eax
  801c66:	79 2a                	jns    801c92 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801c68:	48 ba 58 3e 80 00 00 	movabs $0x803e58,%rdx
  801c6f:	00 00 00 
  801c72:	be 27 00 00 00       	mov    $0x27,%esi
  801c77:	48 bf 43 3e 80 00 00 	movabs $0x803e43,%rdi
  801c7e:	00 00 00 
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	48 b9 34 02 80 00 00 	movabs $0x800234,%rcx
  801c8d:	00 00 00 
  801c90:	ff d1                	callq  *%rcx
}
  801c92:	c9                   	leaveq 
  801c93:	c3                   	retq   

0000000000801c94 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801c94:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801c97:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801c9e:	00 00 00 
call *%rax
  801ca1:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  801ca3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801caa:	00 
    movq 152(%rsp), %rcx
  801cab:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801cb2:	00 
    subq $8, %rcx
  801cb3:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  801cb7:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  801cba:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801cc1:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  801cc2:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  801cc6:	4c 8b 3c 24          	mov    (%rsp),%r15
  801cca:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801ccf:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801cd4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801cd9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801cde:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801ce3:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801ce8:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801ced:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801cf2:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801cf7:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801cfc:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801d01:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801d06:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801d0b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801d10:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  801d14:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  801d18:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  801d19:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  801d1a:	c3                   	retq   

0000000000801d1b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 08          	sub    $0x8,%rsp
  801d23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d27:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d2b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d32:	ff ff ff 
  801d35:	48 01 d0             	add    %rdx,%rax
  801d38:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d3c:	c9                   	leaveq 
  801d3d:	c3                   	retq   

0000000000801d3e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d3e:	55                   	push   %rbp
  801d3f:	48 89 e5             	mov    %rsp,%rbp
  801d42:	48 83 ec 08          	sub    $0x8,%rsp
  801d46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4e:	48 89 c7             	mov    %rax,%rdi
  801d51:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  801d58:	00 00 00 
  801d5b:	ff d0                	callq  *%rax
  801d5d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d63:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d67:	c9                   	leaveq 
  801d68:	c3                   	retq   

0000000000801d69 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d69:	55                   	push   %rbp
  801d6a:	48 89 e5             	mov    %rsp,%rbp
  801d6d:	48 83 ec 18          	sub    $0x18,%rsp
  801d71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d7c:	eb 6b                	jmp    801de9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d81:	48 98                	cltq   
  801d83:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d89:	48 c1 e0 0c          	shl    $0xc,%rax
  801d8d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d95:	48 c1 e8 15          	shr    $0x15,%rax
  801d99:	48 89 c2             	mov    %rax,%rdx
  801d9c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801da3:	01 00 00 
  801da6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801daa:	83 e0 01             	and    $0x1,%eax
  801dad:	48 85 c0             	test   %rax,%rax
  801db0:	74 21                	je     801dd3 <fd_alloc+0x6a>
  801db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db6:	48 c1 e8 0c          	shr    $0xc,%rax
  801dba:	48 89 c2             	mov    %rax,%rdx
  801dbd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dc4:	01 00 00 
  801dc7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dcb:	83 e0 01             	and    $0x1,%eax
  801dce:	48 85 c0             	test   %rax,%rax
  801dd1:	75 12                	jne    801de5 <fd_alloc+0x7c>
			*fd_store = fd;
  801dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ddb:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	eb 1a                	jmp    801dff <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801de5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801de9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ded:	7e 8f                	jle    801d7e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dfa:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dff:	c9                   	leaveq 
  801e00:	c3                   	retq   

0000000000801e01 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e01:	55                   	push   %rbp
  801e02:	48 89 e5             	mov    %rsp,%rbp
  801e05:	48 83 ec 20          	sub    $0x20,%rsp
  801e09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e10:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e14:	78 06                	js     801e1c <fd_lookup+0x1b>
  801e16:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e1a:	7e 07                	jle    801e23 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e21:	eb 6c                	jmp    801e8f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e26:	48 98                	cltq   
  801e28:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e2e:	48 c1 e0 0c          	shl    $0xc,%rax
  801e32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e3a:	48 c1 e8 15          	shr    $0x15,%rax
  801e3e:	48 89 c2             	mov    %rax,%rdx
  801e41:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e48:	01 00 00 
  801e4b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4f:	83 e0 01             	and    $0x1,%eax
  801e52:	48 85 c0             	test   %rax,%rax
  801e55:	74 21                	je     801e78 <fd_lookup+0x77>
  801e57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5b:	48 c1 e8 0c          	shr    $0xc,%rax
  801e5f:	48 89 c2             	mov    %rax,%rdx
  801e62:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e69:	01 00 00 
  801e6c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e70:	83 e0 01             	and    $0x1,%eax
  801e73:	48 85 c0             	test   %rax,%rax
  801e76:	75 07                	jne    801e7f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e7d:	eb 10                	jmp    801e8f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e83:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e87:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8f:	c9                   	leaveq 
  801e90:	c3                   	retq   

0000000000801e91 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e91:	55                   	push   %rbp
  801e92:	48 89 e5             	mov    %rsp,%rbp
  801e95:	48 83 ec 30          	sub    $0x30,%rsp
  801e99:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e9d:	89 f0                	mov    %esi,%eax
  801e9f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ea2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea6:	48 89 c7             	mov    %rax,%rdi
  801ea9:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  801eb0:	00 00 00 
  801eb3:	ff d0                	callq  *%rax
  801eb5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eb9:	48 89 d6             	mov    %rdx,%rsi
  801ebc:	89 c7                	mov    %eax,%edi
  801ebe:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	callq  *%rax
  801eca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ecd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ed1:	78 0a                	js     801edd <fd_close+0x4c>
	    || fd != fd2)
  801ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed7:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801edb:	74 12                	je     801eef <fd_close+0x5e>
		return (must_exist ? r : 0);
  801edd:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ee1:	74 05                	je     801ee8 <fd_close+0x57>
  801ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee6:	eb 05                	jmp    801eed <fd_close+0x5c>
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  801eed:	eb 69                	jmp    801f58 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	8b 00                	mov    (%rax),%eax
  801ef5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ef9:	48 89 d6             	mov    %rdx,%rsi
  801efc:	89 c7                	mov    %eax,%edi
  801efe:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  801f05:	00 00 00 
  801f08:	ff d0                	callq  *%rax
  801f0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f11:	78 2a                	js     801f3d <fd_close+0xac>
		if (dev->dev_close)
  801f13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f17:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f1b:	48 85 c0             	test   %rax,%rax
  801f1e:	74 16                	je     801f36 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f24:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f28:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f2c:	48 89 d7             	mov    %rdx,%rdi
  801f2f:	ff d0                	callq  *%rax
  801f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f34:	eb 07                	jmp    801f3d <fd_close+0xac>
		else
			r = 0;
  801f36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f41:	48 89 c6             	mov    %rax,%rsi
  801f44:	bf 00 00 00 00       	mov    $0x0,%edi
  801f49:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801f50:	00 00 00 
  801f53:	ff d0                	callq  *%rax
	return r;
  801f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f58:	c9                   	leaveq 
  801f59:	c3                   	retq   

0000000000801f5a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f5a:	55                   	push   %rbp
  801f5b:	48 89 e5             	mov    %rsp,%rbp
  801f5e:	48 83 ec 20          	sub    $0x20,%rsp
  801f62:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f70:	eb 41                	jmp    801fb3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f72:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f79:	00 00 00 
  801f7c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f7f:	48 63 d2             	movslq %edx,%rdx
  801f82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f86:	8b 00                	mov    (%rax),%eax
  801f88:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f8b:	75 22                	jne    801faf <dev_lookup+0x55>
			*dev = devtab[i];
  801f8d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f94:	00 00 00 
  801f97:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f9a:	48 63 d2             	movslq %edx,%rdx
  801f9d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fad:	eb 60                	jmp    80200f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801faf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fb3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801fba:	00 00 00 
  801fbd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fc0:	48 63 d2             	movslq %edx,%rdx
  801fc3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc7:	48 85 c0             	test   %rax,%rax
  801fca:	75 a6                	jne    801f72 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fcc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fd3:	00 00 00 
  801fd6:	48 8b 00             	mov    (%rax),%rax
  801fd9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fdf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fe2:	89 c6                	mov    %eax,%esi
  801fe4:	48 bf 90 3e 80 00 00 	movabs $0x803e90,%rdi
  801feb:	00 00 00 
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	48 b9 6d 04 80 00 00 	movabs $0x80046d,%rcx
  801ffa:	00 00 00 
  801ffd:	ff d1                	callq  *%rcx
	*dev = 0;
  801fff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802003:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80200a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80200f:	c9                   	leaveq 
  802010:	c3                   	retq   

0000000000802011 <close>:

int
close(int fdnum)
{
  802011:	55                   	push   %rbp
  802012:	48 89 e5             	mov    %rsp,%rbp
  802015:	48 83 ec 20          	sub    $0x20,%rsp
  802019:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802020:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802023:	48 89 d6             	mov    %rdx,%rsi
  802026:	89 c7                	mov    %eax,%edi
  802028:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  80202f:	00 00 00 
  802032:	ff d0                	callq  *%rax
  802034:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80203b:	79 05                	jns    802042 <close+0x31>
		return r;
  80203d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802040:	eb 18                	jmp    80205a <close+0x49>
	else
		return fd_close(fd, 1);
  802042:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802046:	be 01 00 00 00       	mov    $0x1,%esi
  80204b:	48 89 c7             	mov    %rax,%rdi
  80204e:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  802055:	00 00 00 
  802058:	ff d0                	callq  *%rax
}
  80205a:	c9                   	leaveq 
  80205b:	c3                   	retq   

000000000080205c <close_all>:

void
close_all(void)
{
  80205c:	55                   	push   %rbp
  80205d:	48 89 e5             	mov    %rsp,%rbp
  802060:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80206b:	eb 15                	jmp    802082 <close_all+0x26>
		close(i);
  80206d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802070:	89 c7                	mov    %eax,%edi
  802072:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802079:	00 00 00 
  80207c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80207e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802082:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802086:	7e e5                	jle    80206d <close_all+0x11>
		close(i);
}
  802088:	c9                   	leaveq 
  802089:	c3                   	retq   

000000000080208a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80208a:	55                   	push   %rbp
  80208b:	48 89 e5             	mov    %rsp,%rbp
  80208e:	48 83 ec 40          	sub    $0x40,%rsp
  802092:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802095:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802098:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80209c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80209f:	48 89 d6             	mov    %rdx,%rsi
  8020a2:	89 c7                	mov    %eax,%edi
  8020a4:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax
  8020b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b7:	79 08                	jns    8020c1 <dup+0x37>
		return r;
  8020b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bc:	e9 70 01 00 00       	jmpq   802231 <dup+0x1a7>
	close(newfdnum);
  8020c1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020c4:	89 c7                	mov    %eax,%edi
  8020c6:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020d2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020d5:	48 98                	cltq   
  8020d7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8020e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e9:	48 89 c7             	mov    %rax,%rdi
  8020ec:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	callq  *%rax
  8020f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802100:	48 89 c7             	mov    %rax,%rdi
  802103:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  80210a:	00 00 00 
  80210d:	ff d0                	callq  *%rax
  80210f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802117:	48 c1 e8 15          	shr    $0x15,%rax
  80211b:	48 89 c2             	mov    %rax,%rdx
  80211e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802125:	01 00 00 
  802128:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212c:	83 e0 01             	and    $0x1,%eax
  80212f:	48 85 c0             	test   %rax,%rax
  802132:	74 73                	je     8021a7 <dup+0x11d>
  802134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802138:	48 c1 e8 0c          	shr    $0xc,%rax
  80213c:	48 89 c2             	mov    %rax,%rdx
  80213f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802146:	01 00 00 
  802149:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214d:	83 e0 01             	and    $0x1,%eax
  802150:	48 85 c0             	test   %rax,%rax
  802153:	74 52                	je     8021a7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802159:	48 c1 e8 0c          	shr    $0xc,%rax
  80215d:	48 89 c2             	mov    %rax,%rdx
  802160:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802167:	01 00 00 
  80216a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80216e:	25 07 0e 00 00       	and    $0xe07,%eax
  802173:	89 c1                	mov    %eax,%ecx
  802175:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217d:	41 89 c8             	mov    %ecx,%r8d
  802180:	48 89 d1             	mov    %rdx,%rcx
  802183:	ba 00 00 00 00       	mov    $0x0,%edx
  802188:	48 89 c6             	mov    %rax,%rsi
  80218b:	bf 00 00 00 00       	mov    $0x0,%edi
  802190:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  802197:	00 00 00 
  80219a:	ff d0                	callq  *%rax
  80219c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80219f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a3:	79 02                	jns    8021a7 <dup+0x11d>
			goto err;
  8021a5:	eb 57                	jmp    8021fe <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8021af:	48 89 c2             	mov    %rax,%rdx
  8021b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b9:	01 00 00 
  8021bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8021c5:	89 c1                	mov    %eax,%ecx
  8021c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021cf:	41 89 c8             	mov    %ecx,%r8d
  8021d2:	48 89 d1             	mov    %rdx,%rcx
  8021d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021da:	48 89 c6             	mov    %rax,%rsi
  8021dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e2:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	callq  *%rax
  8021ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f5:	79 02                	jns    8021f9 <dup+0x16f>
		goto err;
  8021f7:	eb 05                	jmp    8021fe <dup+0x174>

	return newfdnum;
  8021f9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021fc:	eb 33                	jmp    802231 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802202:	48 89 c6             	mov    %rax,%rsi
  802205:	bf 00 00 00 00       	mov    $0x0,%edi
  80220a:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  802211:	00 00 00 
  802214:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802216:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80221a:	48 89 c6             	mov    %rax,%rsi
  80221d:	bf 00 00 00 00       	mov    $0x0,%edi
  802222:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  802229:	00 00 00 
  80222c:	ff d0                	callq  *%rax
	return r;
  80222e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802231:	c9                   	leaveq 
  802232:	c3                   	retq   

0000000000802233 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802233:	55                   	push   %rbp
  802234:	48 89 e5             	mov    %rsp,%rbp
  802237:	48 83 ec 40          	sub    $0x40,%rsp
  80223b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80223e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802242:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802246:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80224a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80224d:	48 89 d6             	mov    %rdx,%rsi
  802250:	89 c7                	mov    %eax,%edi
  802252:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  802259:	00 00 00 
  80225c:	ff d0                	callq  *%rax
  80225e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802261:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802265:	78 24                	js     80228b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226b:	8b 00                	mov    (%rax),%eax
  80226d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802271:	48 89 d6             	mov    %rdx,%rsi
  802274:	89 c7                	mov    %eax,%edi
  802276:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  80227d:	00 00 00 
  802280:	ff d0                	callq  *%rax
  802282:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802285:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802289:	79 05                	jns    802290 <read+0x5d>
		return r;
  80228b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228e:	eb 76                	jmp    802306 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802294:	8b 40 08             	mov    0x8(%rax),%eax
  802297:	83 e0 03             	and    $0x3,%eax
  80229a:	83 f8 01             	cmp    $0x1,%eax
  80229d:	75 3a                	jne    8022d9 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80229f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8022a6:	00 00 00 
  8022a9:	48 8b 00             	mov    (%rax),%rax
  8022ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022b5:	89 c6                	mov    %eax,%esi
  8022b7:	48 bf af 3e 80 00 00 	movabs $0x803eaf,%rdi
  8022be:	00 00 00 
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c6:	48 b9 6d 04 80 00 00 	movabs $0x80046d,%rcx
  8022cd:	00 00 00 
  8022d0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d7:	eb 2d                	jmp    802306 <read+0xd3>
	}
	if (!dev->dev_read)
  8022d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022dd:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022e1:	48 85 c0             	test   %rax,%rax
  8022e4:	75 07                	jne    8022ed <read+0xba>
		return -E_NOT_SUPP;
  8022e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022eb:	eb 19                	jmp    802306 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022fd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802301:	48 89 cf             	mov    %rcx,%rdi
  802304:	ff d0                	callq  *%rax
}
  802306:	c9                   	leaveq 
  802307:	c3                   	retq   

0000000000802308 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802308:	55                   	push   %rbp
  802309:	48 89 e5             	mov    %rsp,%rbp
  80230c:	48 83 ec 30          	sub    $0x30,%rsp
  802310:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802313:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802317:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80231b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802322:	eb 49                	jmp    80236d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802327:	48 98                	cltq   
  802329:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80232d:	48 29 c2             	sub    %rax,%rdx
  802330:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802333:	48 63 c8             	movslq %eax,%rcx
  802336:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80233a:	48 01 c1             	add    %rax,%rcx
  80233d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802340:	48 89 ce             	mov    %rcx,%rsi
  802343:	89 c7                	mov    %eax,%edi
  802345:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  80234c:	00 00 00 
  80234f:	ff d0                	callq  *%rax
  802351:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802354:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802358:	79 05                	jns    80235f <readn+0x57>
			return m;
  80235a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235d:	eb 1c                	jmp    80237b <readn+0x73>
		if (m == 0)
  80235f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802363:	75 02                	jne    802367 <readn+0x5f>
			break;
  802365:	eb 11                	jmp    802378 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802367:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80236a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802370:	48 98                	cltq   
  802372:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802376:	72 ac                	jb     802324 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802378:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80237b:	c9                   	leaveq 
  80237c:	c3                   	retq   

000000000080237d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80237d:	55                   	push   %rbp
  80237e:	48 89 e5             	mov    %rsp,%rbp
  802381:	48 83 ec 40          	sub    $0x40,%rsp
  802385:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802388:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80238c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802390:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802394:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802397:	48 89 d6             	mov    %rdx,%rsi
  80239a:	89 c7                	mov    %eax,%edi
  80239c:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  8023a3:	00 00 00 
  8023a6:	ff d0                	callq  *%rax
  8023a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023af:	78 24                	js     8023d5 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b5:	8b 00                	mov    (%rax),%eax
  8023b7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023bb:	48 89 d6             	mov    %rdx,%rsi
  8023be:	89 c7                	mov    %eax,%edi
  8023c0:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	callq  *%rax
  8023cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d3:	79 05                	jns    8023da <write+0x5d>
		return r;
  8023d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d8:	eb 75                	jmp    80244f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023de:	8b 40 08             	mov    0x8(%rax),%eax
  8023e1:	83 e0 03             	and    $0x3,%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	75 3a                	jne    802422 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023e8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023ef:	00 00 00 
  8023f2:	48 8b 00             	mov    (%rax),%rax
  8023f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023fe:	89 c6                	mov    %eax,%esi
  802400:	48 bf cb 3e 80 00 00 	movabs $0x803ecb,%rdi
  802407:	00 00 00 
  80240a:	b8 00 00 00 00       	mov    $0x0,%eax
  80240f:	48 b9 6d 04 80 00 00 	movabs $0x80046d,%rcx
  802416:	00 00 00 
  802419:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80241b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802420:	eb 2d                	jmp    80244f <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802426:	48 8b 40 18          	mov    0x18(%rax),%rax
  80242a:	48 85 c0             	test   %rax,%rax
  80242d:	75 07                	jne    802436 <write+0xb9>
		return -E_NOT_SUPP;
  80242f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802434:	eb 19                	jmp    80244f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80243e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802442:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802446:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80244a:	48 89 cf             	mov    %rcx,%rdi
  80244d:	ff d0                	callq  *%rax
}
  80244f:	c9                   	leaveq 
  802450:	c3                   	retq   

0000000000802451 <seek>:

int
seek(int fdnum, off_t offset)
{
  802451:	55                   	push   %rbp
  802452:	48 89 e5             	mov    %rsp,%rbp
  802455:	48 83 ec 18          	sub    $0x18,%rsp
  802459:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80245c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80245f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802463:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802466:	48 89 d6             	mov    %rdx,%rsi
  802469:	89 c7                	mov    %eax,%edi
  80246b:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
  802477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247e:	79 05                	jns    802485 <seek+0x34>
		return r;
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	eb 0f                	jmp    802494 <seek+0x43>
	fd->fd_offset = offset;
  802485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802489:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80248c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802494:	c9                   	leaveq 
  802495:	c3                   	retq   

0000000000802496 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802496:	55                   	push   %rbp
  802497:	48 89 e5             	mov    %rsp,%rbp
  80249a:	48 83 ec 30          	sub    $0x30,%rsp
  80249e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024a1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024ab:	48 89 d6             	mov    %rdx,%rsi
  8024ae:	89 c7                	mov    %eax,%edi
  8024b0:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  8024b7:	00 00 00 
  8024ba:	ff d0                	callq  *%rax
  8024bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c3:	78 24                	js     8024e9 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c9:	8b 00                	mov    (%rax),%eax
  8024cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024cf:	48 89 d6             	mov    %rdx,%rsi
  8024d2:	89 c7                	mov    %eax,%edi
  8024d4:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  8024db:	00 00 00 
  8024de:	ff d0                	callq  *%rax
  8024e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e7:	79 05                	jns    8024ee <ftruncate+0x58>
		return r;
  8024e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ec:	eb 72                	jmp    802560 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f2:	8b 40 08             	mov    0x8(%rax),%eax
  8024f5:	83 e0 03             	and    $0x3,%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	75 3a                	jne    802536 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024fc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802503:	00 00 00 
  802506:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802509:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80250f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802512:	89 c6                	mov    %eax,%esi
  802514:	48 bf e8 3e 80 00 00 	movabs $0x803ee8,%rdi
  80251b:	00 00 00 
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	48 b9 6d 04 80 00 00 	movabs $0x80046d,%rcx
  80252a:	00 00 00 
  80252d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80252f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802534:	eb 2a                	jmp    802560 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802536:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80253e:	48 85 c0             	test   %rax,%rax
  802541:	75 07                	jne    80254a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802543:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802548:	eb 16                	jmp    802560 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80254a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802552:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802556:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802559:	89 ce                	mov    %ecx,%esi
  80255b:	48 89 d7             	mov    %rdx,%rdi
  80255e:	ff d0                	callq  *%rax
}
  802560:	c9                   	leaveq 
  802561:	c3                   	retq   

0000000000802562 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802562:	55                   	push   %rbp
  802563:	48 89 e5             	mov    %rsp,%rbp
  802566:	48 83 ec 30          	sub    $0x30,%rsp
  80256a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80256d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802571:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802575:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802578:	48 89 d6             	mov    %rdx,%rsi
  80257b:	89 c7                	mov    %eax,%edi
  80257d:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  802584:	00 00 00 
  802587:	ff d0                	callq  *%rax
  802589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802590:	78 24                	js     8025b6 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802596:	8b 00                	mov    (%rax),%eax
  802598:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80259c:	48 89 d6             	mov    %rdx,%rsi
  80259f:	89 c7                	mov    %eax,%edi
  8025a1:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
  8025ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b4:	79 05                	jns    8025bb <fstat+0x59>
		return r;
  8025b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b9:	eb 5e                	jmp    802619 <fstat+0xb7>
	if (!dev->dev_stat)
  8025bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bf:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025c3:	48 85 c0             	test   %rax,%rax
  8025c6:	75 07                	jne    8025cf <fstat+0x6d>
		return -E_NOT_SUPP;
  8025c8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025cd:	eb 4a                	jmp    802619 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d3:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025da:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025e1:	00 00 00 
	stat->st_isdir = 0;
  8025e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025ef:	00 00 00 
	stat->st_dev = dev;
  8025f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fa:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802605:	48 8b 40 28          	mov    0x28(%rax),%rax
  802609:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80260d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802611:	48 89 ce             	mov    %rcx,%rsi
  802614:	48 89 d7             	mov    %rdx,%rdi
  802617:	ff d0                	callq  *%rax
}
  802619:	c9                   	leaveq 
  80261a:	c3                   	retq   

000000000080261b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80261b:	55                   	push   %rbp
  80261c:	48 89 e5             	mov    %rsp,%rbp
  80261f:	48 83 ec 20          	sub    $0x20,%rsp
  802623:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802627:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80262b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262f:	be 00 00 00 00       	mov    $0x0,%esi
  802634:	48 89 c7             	mov    %rax,%rdi
  802637:	48 b8 09 27 80 00 00 	movabs $0x802709,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
  802643:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802646:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264a:	79 05                	jns    802651 <stat+0x36>
		return fd;
  80264c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264f:	eb 2f                	jmp    802680 <stat+0x65>
	r = fstat(fd, stat);
  802651:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802658:	48 89 d6             	mov    %rdx,%rsi
  80265b:	89 c7                	mov    %eax,%edi
  80265d:	48 b8 62 25 80 00 00 	movabs $0x802562,%rax
  802664:	00 00 00 
  802667:	ff d0                	callq  *%rax
  802669:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80266c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266f:	89 c7                	mov    %eax,%edi
  802671:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802678:	00 00 00 
  80267b:	ff d0                	callq  *%rax
	return r;
  80267d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802680:	c9                   	leaveq 
  802681:	c3                   	retq   

0000000000802682 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802682:	55                   	push   %rbp
  802683:	48 89 e5             	mov    %rsp,%rbp
  802686:	48 83 ec 10          	sub    $0x10,%rsp
  80268a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80268d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802691:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802698:	00 00 00 
  80269b:	8b 00                	mov    (%rax),%eax
  80269d:	85 c0                	test   %eax,%eax
  80269f:	75 1d                	jne    8026be <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8026a6:	48 b8 39 37 80 00 00 	movabs $0x803739,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
  8026b2:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8026b9:	00 00 00 
  8026bc:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026be:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8026c5:	00 00 00 
  8026c8:	8b 00                	mov    (%rax),%eax
  8026ca:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026cd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026d2:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026d9:	00 00 00 
  8026dc:	89 c7                	mov    %eax,%edi
  8026de:	48 b8 a1 36 80 00 00 	movabs $0x8036a1,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f3:	48 89 c6             	mov    %rax,%rsi
  8026f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8026fb:	48 b8 e0 35 80 00 00 	movabs $0x8035e0,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
}
  802707:	c9                   	leaveq 
  802708:	c3                   	retq   

0000000000802709 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802709:	55                   	push   %rbp
  80270a:	48 89 e5             	mov    %rsp,%rbp
  80270d:	48 83 ec 20          	sub    $0x20,%rsp
  802711:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802715:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271c:	48 89 c7             	mov    %rax,%rdi
  80271f:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  802726:	00 00 00 
  802729:	ff d0                	callq  *%rax
  80272b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802730:	7e 0a                	jle    80273c <open+0x33>
		return -E_BAD_PATH;
  802732:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802737:	e9 a5 00 00 00       	jmpq   8027e1 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80273c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802740:	48 89 c7             	mov    %rax,%rdi
  802743:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  80274a:	00 00 00 
  80274d:	ff d0                	callq  *%rax
  80274f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802752:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802756:	79 08                	jns    802760 <open+0x57>
		return r;
  802758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275b:	e9 81 00 00 00       	jmpq   8027e1 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802764:	48 89 c6             	mov    %rax,%rsi
  802767:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80276e:	00 00 00 
  802771:	48 b8 35 10 80 00 00 	movabs $0x801035,%rax
  802778:	00 00 00 
  80277b:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80277d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802784:	00 00 00 
  802787:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80278a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802794:	48 89 c6             	mov    %rax,%rsi
  802797:	bf 01 00 00 00       	mov    $0x1,%edi
  80279c:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027af:	79 1d                	jns    8027ce <open+0xc5>
		fd_close(fd, 0);
  8027b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b5:	be 00 00 00 00       	mov    $0x0,%esi
  8027ba:	48 89 c7             	mov    %rax,%rdi
  8027bd:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
		return r;
  8027c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cc:	eb 13                	jmp    8027e1 <open+0xd8>
	}

	return fd2num(fd);
  8027ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d2:	48 89 c7             	mov    %rax,%rdi
  8027d5:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8027e1:	c9                   	leaveq 
  8027e2:	c3                   	retq   

00000000008027e3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027e3:	55                   	push   %rbp
  8027e4:	48 89 e5             	mov    %rsp,%rbp
  8027e7:	48 83 ec 10          	sub    $0x10,%rsp
  8027eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f3:	8b 50 0c             	mov    0xc(%rax),%edx
  8027f6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027fd:	00 00 00 
  802800:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802802:	be 00 00 00 00       	mov    $0x0,%esi
  802807:	bf 06 00 00 00       	mov    $0x6,%edi
  80280c:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
}
  802818:	c9                   	leaveq 
  802819:	c3                   	retq   

000000000080281a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80281a:	55                   	push   %rbp
  80281b:	48 89 e5             	mov    %rsp,%rbp
  80281e:	48 83 ec 30          	sub    $0x30,%rsp
  802822:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802826:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80282a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80282e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802832:	8b 50 0c             	mov    0xc(%rax),%edx
  802835:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80283c:	00 00 00 
  80283f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802841:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802848:	00 00 00 
  80284b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802853:	be 00 00 00 00       	mov    $0x0,%esi
  802858:	bf 03 00 00 00       	mov    $0x3,%edi
  80285d:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
  802869:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802870:	79 08                	jns    80287a <devfile_read+0x60>
		return r;
  802872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802875:	e9 a4 00 00 00       	jmpq   80291e <devfile_read+0x104>
	assert(r <= n);
  80287a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287d:	48 98                	cltq   
  80287f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802883:	76 35                	jbe    8028ba <devfile_read+0xa0>
  802885:	48 b9 15 3f 80 00 00 	movabs $0x803f15,%rcx
  80288c:	00 00 00 
  80288f:	48 ba 1c 3f 80 00 00 	movabs $0x803f1c,%rdx
  802896:	00 00 00 
  802899:	be 84 00 00 00       	mov    $0x84,%esi
  80289e:	48 bf 31 3f 80 00 00 	movabs $0x803f31,%rdi
  8028a5:	00 00 00 
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ad:	49 b8 34 02 80 00 00 	movabs $0x800234,%r8
  8028b4:	00 00 00 
  8028b7:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8028ba:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8028c1:	7e 35                	jle    8028f8 <devfile_read+0xde>
  8028c3:	48 b9 3c 3f 80 00 00 	movabs $0x803f3c,%rcx
  8028ca:	00 00 00 
  8028cd:	48 ba 1c 3f 80 00 00 	movabs $0x803f1c,%rdx
  8028d4:	00 00 00 
  8028d7:	be 85 00 00 00       	mov    $0x85,%esi
  8028dc:	48 bf 31 3f 80 00 00 	movabs $0x803f31,%rdi
  8028e3:	00 00 00 
  8028e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028eb:	49 b8 34 02 80 00 00 	movabs $0x800234,%r8
  8028f2:	00 00 00 
  8028f5:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fb:	48 63 d0             	movslq %eax,%rdx
  8028fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802902:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802909:	00 00 00 
  80290c:	48 89 c7             	mov    %rax,%rdi
  80290f:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
	return r;
  80291b:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80291e:	c9                   	leaveq 
  80291f:	c3                   	retq   

0000000000802920 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802920:	55                   	push   %rbp
  802921:	48 89 e5             	mov    %rsp,%rbp
  802924:	48 83 ec 30          	sub    $0x30,%rsp
  802928:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80292c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802930:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802938:	8b 50 0c             	mov    0xc(%rax),%edx
  80293b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802942:	00 00 00 
  802945:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802947:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80294e:	00 00 00 
  802951:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802955:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802959:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802960:	00 
  802961:	76 35                	jbe    802998 <devfile_write+0x78>
  802963:	48 b9 48 3f 80 00 00 	movabs $0x803f48,%rcx
  80296a:	00 00 00 
  80296d:	48 ba 1c 3f 80 00 00 	movabs $0x803f1c,%rdx
  802974:	00 00 00 
  802977:	be 9e 00 00 00       	mov    $0x9e,%esi
  80297c:	48 bf 31 3f 80 00 00 	movabs $0x803f31,%rdi
  802983:	00 00 00 
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
  80298b:	49 b8 34 02 80 00 00 	movabs $0x800234,%r8
  802992:	00 00 00 
  802995:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802998:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80299c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a0:	48 89 c6             	mov    %rax,%rsi
  8029a3:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8029aa:	00 00 00 
  8029ad:	48 b8 70 14 80 00 00 	movabs $0x801470,%rax
  8029b4:	00 00 00 
  8029b7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8029b9:	be 00 00 00 00       	mov    $0x0,%esi
  8029be:	bf 04 00 00 00       	mov    $0x4,%edi
  8029c3:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	callq  *%rax
  8029cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d6:	79 05                	jns    8029dd <devfile_write+0xbd>
		return r;
  8029d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029db:	eb 43                	jmp    802a20 <devfile_write+0x100>
	assert(r <= n);
  8029dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e0:	48 98                	cltq   
  8029e2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029e6:	76 35                	jbe    802a1d <devfile_write+0xfd>
  8029e8:	48 b9 15 3f 80 00 00 	movabs $0x803f15,%rcx
  8029ef:	00 00 00 
  8029f2:	48 ba 1c 3f 80 00 00 	movabs $0x803f1c,%rdx
  8029f9:	00 00 00 
  8029fc:	be a2 00 00 00       	mov    $0xa2,%esi
  802a01:	48 bf 31 3f 80 00 00 	movabs $0x803f31,%rdi
  802a08:	00 00 00 
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a10:	49 b8 34 02 80 00 00 	movabs $0x800234,%r8
  802a17:	00 00 00 
  802a1a:	41 ff d0             	callq  *%r8
	return r;
  802a1d:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802a20:	c9                   	leaveq 
  802a21:	c3                   	retq   

0000000000802a22 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a22:	55                   	push   %rbp
  802a23:	48 89 e5             	mov    %rsp,%rbp
  802a26:	48 83 ec 20          	sub    $0x20,%rsp
  802a2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a36:	8b 50 0c             	mov    0xc(%rax),%edx
  802a39:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a40:	00 00 00 
  802a43:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a45:	be 00 00 00 00       	mov    $0x0,%esi
  802a4a:	bf 05 00 00 00       	mov    $0x5,%edi
  802a4f:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  802a56:	00 00 00 
  802a59:	ff d0                	callq  *%rax
  802a5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a62:	79 05                	jns    802a69 <devfile_stat+0x47>
		return r;
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	eb 56                	jmp    802abf <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a74:	00 00 00 
  802a77:	48 89 c7             	mov    %rax,%rdi
  802a7a:	48 b8 35 10 80 00 00 	movabs $0x801035,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a86:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a8d:	00 00 00 
  802a90:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a9a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802aa0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aa7:	00 00 00 
  802aaa:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ab0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802abf:	c9                   	leaveq 
  802ac0:	c3                   	retq   

0000000000802ac1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ac1:	55                   	push   %rbp
  802ac2:	48 89 e5             	mov    %rsp,%rbp
  802ac5:	48 83 ec 10          	sub    $0x10,%rsp
  802ac9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802acd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad4:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ade:	00 00 00 
  802ae1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ae3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aea:	00 00 00 
  802aed:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802af3:	be 00 00 00 00       	mov    $0x0,%esi
  802af8:	bf 02 00 00 00       	mov    $0x2,%edi
  802afd:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	callq  *%rax
}
  802b09:	c9                   	leaveq 
  802b0a:	c3                   	retq   

0000000000802b0b <remove>:

// Delete a file
int
remove(const char *path)
{
  802b0b:	55                   	push   %rbp
  802b0c:	48 89 e5             	mov    %rsp,%rbp
  802b0f:	48 83 ec 10          	sub    $0x10,%rsp
  802b13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b1b:	48 89 c7             	mov    %rax,%rdi
  802b1e:	48 b8 c9 0f 80 00 00 	movabs $0x800fc9,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	callq  *%rax
  802b2a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b2f:	7e 07                	jle    802b38 <remove+0x2d>
		return -E_BAD_PATH;
  802b31:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b36:	eb 33                	jmp    802b6b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3c:	48 89 c6             	mov    %rax,%rsi
  802b3f:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802b46:	00 00 00 
  802b49:	48 b8 35 10 80 00 00 	movabs $0x801035,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b55:	be 00 00 00 00       	mov    $0x0,%esi
  802b5a:	bf 07 00 00 00       	mov    $0x7,%edi
  802b5f:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
}
  802b6b:	c9                   	leaveq 
  802b6c:	c3                   	retq   

0000000000802b6d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b6d:	55                   	push   %rbp
  802b6e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b71:	be 00 00 00 00       	mov    $0x0,%esi
  802b76:	bf 08 00 00 00       	mov    $0x8,%edi
  802b7b:	48 b8 82 26 80 00 00 	movabs $0x802682,%rax
  802b82:	00 00 00 
  802b85:	ff d0                	callq  *%rax
}
  802b87:	5d                   	pop    %rbp
  802b88:	c3                   	retq   

0000000000802b89 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b89:	55                   	push   %rbp
  802b8a:	48 89 e5             	mov    %rsp,%rbp
  802b8d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b94:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b9b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ba2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ba9:	be 00 00 00 00       	mov    $0x0,%esi
  802bae:	48 89 c7             	mov    %rax,%rdi
  802bb1:	48 b8 09 27 80 00 00 	movabs $0x802709,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	callq  *%rax
  802bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc4:	79 28                	jns    802bee <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc9:	89 c6                	mov    %eax,%esi
  802bcb:	48 bf 75 3f 80 00 00 	movabs $0x803f75,%rdi
  802bd2:	00 00 00 
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bda:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
  802be1:	00 00 00 
  802be4:	ff d2                	callq  *%rdx
		return fd_src;
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be9:	e9 74 01 00 00       	jmpq   802d62 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bee:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bf5:	be 01 01 00 00       	mov    $0x101,%esi
  802bfa:	48 89 c7             	mov    %rax,%rdi
  802bfd:	48 b8 09 27 80 00 00 	movabs $0x802709,%rax
  802c04:	00 00 00 
  802c07:	ff d0                	callq  *%rax
  802c09:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c10:	79 39                	jns    802c4b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c15:	89 c6                	mov    %eax,%esi
  802c17:	48 bf 8b 3f 80 00 00 	movabs $0x803f8b,%rdi
  802c1e:	00 00 00 
  802c21:	b8 00 00 00 00       	mov    $0x0,%eax
  802c26:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
  802c2d:	00 00 00 
  802c30:	ff d2                	callq  *%rdx
		close(fd_src);
  802c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c35:	89 c7                	mov    %eax,%edi
  802c37:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802c3e:	00 00 00 
  802c41:	ff d0                	callq  *%rax
		return fd_dest;
  802c43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c46:	e9 17 01 00 00       	jmpq   802d62 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c4b:	eb 74                	jmp    802cc1 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c4d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c50:	48 63 d0             	movslq %eax,%rdx
  802c53:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c5d:	48 89 ce             	mov    %rcx,%rsi
  802c60:	89 c7                	mov    %eax,%edi
  802c62:	48 b8 7d 23 80 00 00 	movabs $0x80237d,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
  802c6e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c75:	79 4a                	jns    802cc1 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c77:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c7a:	89 c6                	mov    %eax,%esi
  802c7c:	48 bf a5 3f 80 00 00 	movabs $0x803fa5,%rdi
  802c83:	00 00 00 
  802c86:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8b:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
  802c92:	00 00 00 
  802c95:	ff d2                	callq  *%rdx
			close(fd_src);
  802c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9a:	89 c7                	mov    %eax,%edi
  802c9c:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
			close(fd_dest);
  802ca8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cab:	89 c7                	mov    %eax,%edi
  802cad:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802cb4:	00 00 00 
  802cb7:	ff d0                	callq  *%rax
			return write_size;
  802cb9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cbc:	e9 a1 00 00 00       	jmpq   802d62 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cc1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccb:	ba 00 02 00 00       	mov    $0x200,%edx
  802cd0:	48 89 ce             	mov    %rcx,%rsi
  802cd3:	89 c7                	mov    %eax,%edi
  802cd5:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  802cdc:	00 00 00 
  802cdf:	ff d0                	callq  *%rax
  802ce1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ce8:	0f 8f 5f ff ff ff    	jg     802c4d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802cee:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cf2:	79 47                	jns    802d3b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cf4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cf7:	89 c6                	mov    %eax,%esi
  802cf9:	48 bf b8 3f 80 00 00 	movabs $0x803fb8,%rdi
  802d00:	00 00 00 
  802d03:	b8 00 00 00 00       	mov    $0x0,%eax
  802d08:	48 ba 6d 04 80 00 00 	movabs $0x80046d,%rdx
  802d0f:	00 00 00 
  802d12:	ff d2                	callq  *%rdx
		close(fd_src);
  802d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d17:	89 c7                	mov    %eax,%edi
  802d19:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
		close(fd_dest);
  802d25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d28:	89 c7                	mov    %eax,%edi
  802d2a:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
		return read_size;
  802d36:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d39:	eb 27                	jmp    802d62 <copy+0x1d9>
	}
	close(fd_src);
  802d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3e:	89 c7                	mov    %eax,%edi
  802d40:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802d47:	00 00 00 
  802d4a:	ff d0                	callq  *%rax
	close(fd_dest);
  802d4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d4f:	89 c7                	mov    %eax,%edi
  802d51:	48 b8 11 20 80 00 00 	movabs $0x802011,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
	return 0;
  802d5d:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802d62:	c9                   	leaveq 
  802d63:	c3                   	retq   

0000000000802d64 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d64:	55                   	push   %rbp
  802d65:	48 89 e5             	mov    %rsp,%rbp
  802d68:	53                   	push   %rbx
  802d69:	48 83 ec 38          	sub    $0x38,%rsp
  802d6d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d71:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802d75:	48 89 c7             	mov    %rax,%rdi
  802d78:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  802d7f:	00 00 00 
  802d82:	ff d0                	callq  *%rax
  802d84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d8b:	0f 88 bf 01 00 00    	js     802f50 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d95:	ba 07 04 00 00       	mov    $0x407,%edx
  802d9a:	48 89 c6             	mov    %rax,%rsi
  802d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  802da2:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
  802dae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802db1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802db5:	0f 88 95 01 00 00    	js     802f50 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802dbb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802dbf:	48 89 c7             	mov    %rax,%rdi
  802dc2:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  802dc9:	00 00 00 
  802dcc:	ff d0                	callq  *%rax
  802dce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dd5:	0f 88 5d 01 00 00    	js     802f38 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ddb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ddf:	ba 07 04 00 00       	mov    $0x407,%edx
  802de4:	48 89 c6             	mov    %rax,%rsi
  802de7:	bf 00 00 00 00       	mov    $0x0,%edi
  802dec:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
  802df8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dff:	0f 88 33 01 00 00    	js     802f38 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802e05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e09:	48 89 c7             	mov    %rax,%rdi
  802e0c:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
  802e18:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e20:	ba 07 04 00 00       	mov    $0x407,%edx
  802e25:	48 89 c6             	mov    %rax,%rsi
  802e28:	bf 00 00 00 00       	mov    $0x0,%edi
  802e2d:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  802e34:	00 00 00 
  802e37:	ff d0                	callq  *%rax
  802e39:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e40:	79 05                	jns    802e47 <pipe+0xe3>
		goto err2;
  802e42:	e9 d9 00 00 00       	jmpq   802f20 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e4b:	48 89 c7             	mov    %rax,%rdi
  802e4e:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  802e55:	00 00 00 
  802e58:	ff d0                	callq  *%rax
  802e5a:	48 89 c2             	mov    %rax,%rdx
  802e5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e61:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802e67:	48 89 d1             	mov    %rdx,%rcx
  802e6a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6f:	48 89 c6             	mov    %rax,%rsi
  802e72:	bf 00 00 00 00       	mov    $0x0,%edi
  802e77:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
  802e83:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e86:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e8a:	79 1b                	jns    802ea7 <pipe+0x143>
		goto err3;
  802e8c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802e8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e91:	48 89 c6             	mov    %rax,%rsi
  802e94:	bf 00 00 00 00       	mov    $0x0,%edi
  802e99:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	eb 79                	jmp    802f20 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802ea7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eab:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802eb2:	00 00 00 
  802eb5:	8b 12                	mov    (%rdx),%edx
  802eb7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ebd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802ec4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec8:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ecf:	00 00 00 
  802ed2:	8b 12                	mov    (%rdx),%edx
  802ed4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802ed6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eda:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802ee1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee5:	48 89 c7             	mov    %rax,%rdi
  802ee8:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
  802ef4:	89 c2                	mov    %eax,%edx
  802ef6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802efa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802efc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f00:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802f04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f08:	48 89 c7             	mov    %rax,%rdi
  802f0b:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802f12:	00 00 00 
  802f15:	ff d0                	callq  *%rax
  802f17:	89 03                	mov    %eax,(%rbx)
	return 0;
  802f19:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1e:	eb 33                	jmp    802f53 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802f20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f24:	48 89 c6             	mov    %rax,%rsi
  802f27:	bf 00 00 00 00       	mov    $0x0,%edi
  802f2c:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802f38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3c:	48 89 c6             	mov    %rax,%rsi
  802f3f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f44:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
err:
	return r;
  802f50:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802f53:	48 83 c4 38          	add    $0x38,%rsp
  802f57:	5b                   	pop    %rbx
  802f58:	5d                   	pop    %rbp
  802f59:	c3                   	retq   

0000000000802f5a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f5a:	55                   	push   %rbp
  802f5b:	48 89 e5             	mov    %rsp,%rbp
  802f5e:	53                   	push   %rbx
  802f5f:	48 83 ec 28          	sub    $0x28,%rsp
  802f63:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f67:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802f6b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f72:	00 00 00 
  802f75:	48 8b 00             	mov    (%rax),%rax
  802f78:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f7e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802f81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f85:	48 89 c7             	mov    %rax,%rdi
  802f88:	48 b8 bb 37 80 00 00 	movabs $0x8037bb,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
  802f94:	89 c3                	mov    %eax,%ebx
  802f96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f9a:	48 89 c7             	mov    %rax,%rdi
  802f9d:	48 b8 bb 37 80 00 00 	movabs $0x8037bb,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
  802fa9:	39 c3                	cmp    %eax,%ebx
  802fab:	0f 94 c0             	sete   %al
  802fae:	0f b6 c0             	movzbl %al,%eax
  802fb1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802fb4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802fbb:	00 00 00 
  802fbe:	48 8b 00             	mov    (%rax),%rax
  802fc1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802fc7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802fca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fcd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802fd0:	75 05                	jne    802fd7 <_pipeisclosed+0x7d>
			return ret;
  802fd2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fd5:	eb 4f                	jmp    803026 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802fd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fda:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802fdd:	74 42                	je     803021 <_pipeisclosed+0xc7>
  802fdf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802fe3:	75 3c                	jne    803021 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802fe5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802fec:	00 00 00 
  802fef:	48 8b 00             	mov    (%rax),%rax
  802ff2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802ff8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802ffb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ffe:	89 c6                	mov    %eax,%esi
  803000:	48 bf d3 3f 80 00 00 	movabs $0x803fd3,%rdi
  803007:	00 00 00 
  80300a:	b8 00 00 00 00       	mov    $0x0,%eax
  80300f:	49 b8 6d 04 80 00 00 	movabs $0x80046d,%r8
  803016:	00 00 00 
  803019:	41 ff d0             	callq  *%r8
	}
  80301c:	e9 4a ff ff ff       	jmpq   802f6b <_pipeisclosed+0x11>
  803021:	e9 45 ff ff ff       	jmpq   802f6b <_pipeisclosed+0x11>
}
  803026:	48 83 c4 28          	add    $0x28,%rsp
  80302a:	5b                   	pop    %rbx
  80302b:	5d                   	pop    %rbp
  80302c:	c3                   	retq   

000000000080302d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80302d:	55                   	push   %rbp
  80302e:	48 89 e5             	mov    %rsp,%rbp
  803031:	48 83 ec 30          	sub    $0x30,%rsp
  803035:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803038:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80303c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80303f:	48 89 d6             	mov    %rdx,%rsi
  803042:	89 c7                	mov    %eax,%edi
  803044:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
  803050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803057:	79 05                	jns    80305e <pipeisclosed+0x31>
		return r;
  803059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305c:	eb 31                	jmp    80308f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80305e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803062:	48 89 c7             	mov    %rax,%rdi
  803065:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  80306c:	00 00 00 
  80306f:	ff d0                	callq  *%rax
  803071:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803079:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80307d:	48 89 d6             	mov    %rdx,%rsi
  803080:	48 89 c7             	mov    %rax,%rdi
  803083:	48 b8 5a 2f 80 00 00 	movabs $0x802f5a,%rax
  80308a:	00 00 00 
  80308d:	ff d0                	callq  *%rax
}
  80308f:	c9                   	leaveq 
  803090:	c3                   	retq   

0000000000803091 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803091:	55                   	push   %rbp
  803092:	48 89 e5             	mov    %rsp,%rbp
  803095:	48 83 ec 40          	sub    $0x40,%rsp
  803099:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80309d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8030a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a9:	48 89 c7             	mov    %rax,%rdi
  8030ac:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
  8030b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8030bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8030c4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8030cb:	00 
  8030cc:	e9 92 00 00 00       	jmpq   803163 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8030d1:	eb 41                	jmp    803114 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8030d3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8030d8:	74 09                	je     8030e3 <devpipe_read+0x52>
				return i;
  8030da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030de:	e9 92 00 00 00       	jmpq   803175 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8030e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030eb:	48 89 d6             	mov    %rdx,%rsi
  8030ee:	48 89 c7             	mov    %rax,%rdi
  8030f1:	48 b8 5a 2f 80 00 00 	movabs $0x802f5a,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	85 c0                	test   %eax,%eax
  8030ff:	74 07                	je     803108 <devpipe_read+0x77>
				return 0;
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
  803106:	eb 6d                	jmp    803175 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803108:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  80310f:	00 00 00 
  803112:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803118:	8b 10                	mov    (%rax),%edx
  80311a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311e:	8b 40 04             	mov    0x4(%rax),%eax
  803121:	39 c2                	cmp    %eax,%edx
  803123:	74 ae                	je     8030d3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803129:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80312d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803135:	8b 00                	mov    (%rax),%eax
  803137:	99                   	cltd   
  803138:	c1 ea 1b             	shr    $0x1b,%edx
  80313b:	01 d0                	add    %edx,%eax
  80313d:	83 e0 1f             	and    $0x1f,%eax
  803140:	29 d0                	sub    %edx,%eax
  803142:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803146:	48 98                	cltq   
  803148:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80314d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80314f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803153:	8b 00                	mov    (%rax),%eax
  803155:	8d 50 01             	lea    0x1(%rax),%edx
  803158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80315e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803167:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80316b:	0f 82 60 ff ff ff    	jb     8030d1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803175:	c9                   	leaveq 
  803176:	c3                   	retq   

0000000000803177 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803177:	55                   	push   %rbp
  803178:	48 89 e5             	mov    %rsp,%rbp
  80317b:	48 83 ec 40          	sub    $0x40,%rsp
  80317f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803183:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803187:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80318b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318f:	48 89 c7             	mov    %rax,%rdi
  803192:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8031a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8031aa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031b1:	00 
  8031b2:	e9 8e 00 00 00       	jmpq   803245 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8031b7:	eb 31                	jmp    8031ea <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8031b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c1:	48 89 d6             	mov    %rdx,%rsi
  8031c4:	48 89 c7             	mov    %rax,%rdi
  8031c7:	48 b8 5a 2f 80 00 00 	movabs $0x802f5a,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 07                	je     8031de <devpipe_write+0x67>
				return 0;
  8031d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031dc:	eb 79                	jmp    803257 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8031de:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  8031e5:	00 00 00 
  8031e8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8031ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ee:	8b 40 04             	mov    0x4(%rax),%eax
  8031f1:	48 63 d0             	movslq %eax,%rdx
  8031f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f8:	8b 00                	mov    (%rax),%eax
  8031fa:	48 98                	cltq   
  8031fc:	48 83 c0 20          	add    $0x20,%rax
  803200:	48 39 c2             	cmp    %rax,%rdx
  803203:	73 b4                	jae    8031b9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803209:	8b 40 04             	mov    0x4(%rax),%eax
  80320c:	99                   	cltd   
  80320d:	c1 ea 1b             	shr    $0x1b,%edx
  803210:	01 d0                	add    %edx,%eax
  803212:	83 e0 1f             	and    $0x1f,%eax
  803215:	29 d0                	sub    %edx,%eax
  803217:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80321b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80321f:	48 01 ca             	add    %rcx,%rdx
  803222:	0f b6 0a             	movzbl (%rdx),%ecx
  803225:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803229:	48 98                	cltq   
  80322b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80322f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803233:	8b 40 04             	mov    0x4(%rax),%eax
  803236:	8d 50 01             	lea    0x1(%rax),%edx
  803239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80323d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803240:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803249:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80324d:	0f 82 64 ff ff ff    	jb     8031b7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803257:	c9                   	leaveq 
  803258:	c3                   	retq   

0000000000803259 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803259:	55                   	push   %rbp
  80325a:	48 89 e5             	mov    %rsp,%rbp
  80325d:	48 83 ec 20          	sub    $0x20,%rsp
  803261:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803265:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80326d:	48 89 c7             	mov    %rax,%rdi
  803270:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803280:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803284:	48 be e6 3f 80 00 00 	movabs $0x803fe6,%rsi
  80328b:	00 00 00 
  80328e:	48 89 c7             	mov    %rax,%rdi
  803291:	48 b8 35 10 80 00 00 	movabs $0x801035,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80329d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a1:	8b 50 04             	mov    0x4(%rax),%edx
  8032a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a8:	8b 00                	mov    (%rax),%eax
  8032aa:	29 c2                	sub    %eax,%edx
  8032ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8032b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ba:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8032c1:	00 00 00 
	stat->st_dev = &devpipe;
  8032c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c8:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8032cf:	00 00 00 
  8032d2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8032d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032de:	c9                   	leaveq 
  8032df:	c3                   	retq   

00000000008032e0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8032e0:	55                   	push   %rbp
  8032e1:	48 89 e5             	mov    %rsp,%rbp
  8032e4:	48 83 ec 10          	sub    $0x10,%rsp
  8032e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8032ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f0:	48 89 c6             	mov    %rax,%rsi
  8032f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f8:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803308:	48 89 c7             	mov    %rax,%rdi
  80330b:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  803312:	00 00 00 
  803315:	ff d0                	callq  *%rax
  803317:	48 89 c6             	mov    %rax,%rsi
  80331a:	bf 00 00 00 00       	mov    $0x0,%edi
  80331f:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
}
  80332b:	c9                   	leaveq 
  80332c:	c3                   	retq   

000000000080332d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80332d:	55                   	push   %rbp
  80332e:	48 89 e5             	mov    %rsp,%rbp
  803331:	48 83 ec 20          	sub    $0x20,%rsp
  803335:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803338:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80333b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80333e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803342:	be 01 00 00 00       	mov    $0x1,%esi
  803347:	48 89 c7             	mov    %rax,%rdi
  80334a:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803351:	00 00 00 
  803354:	ff d0                	callq  *%rax
}
  803356:	c9                   	leaveq 
  803357:	c3                   	retq   

0000000000803358 <getchar>:

int
getchar(void)
{
  803358:	55                   	push   %rbp
  803359:	48 89 e5             	mov    %rsp,%rbp
  80335c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803360:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803364:	ba 01 00 00 00       	mov    $0x1,%edx
  803369:	48 89 c6             	mov    %rax,%rsi
  80336c:	bf 00 00 00 00       	mov    $0x0,%edi
  803371:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  803378:	00 00 00 
  80337b:	ff d0                	callq  *%rax
  80337d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803380:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803384:	79 05                	jns    80338b <getchar+0x33>
		return r;
  803386:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803389:	eb 14                	jmp    80339f <getchar+0x47>
	if (r < 1)
  80338b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80338f:	7f 07                	jg     803398 <getchar+0x40>
		return -E_EOF;
  803391:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803396:	eb 07                	jmp    80339f <getchar+0x47>
	return c;
  803398:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80339c:	0f b6 c0             	movzbl %al,%eax
}
  80339f:	c9                   	leaveq 
  8033a0:	c3                   	retq   

00000000008033a1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8033a1:	55                   	push   %rbp
  8033a2:	48 89 e5             	mov    %rsp,%rbp
  8033a5:	48 83 ec 20          	sub    $0x20,%rsp
  8033a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b3:	48 89 d6             	mov    %rdx,%rsi
  8033b6:	89 c7                	mov    %eax,%edi
  8033b8:	48 b8 01 1e 80 00 00 	movabs $0x801e01,%rax
  8033bf:	00 00 00 
  8033c2:	ff d0                	callq  *%rax
  8033c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033cb:	79 05                	jns    8033d2 <iscons+0x31>
		return r;
  8033cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d0:	eb 1a                	jmp    8033ec <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8033d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d6:	8b 10                	mov    (%rax),%edx
  8033d8:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8033df:	00 00 00 
  8033e2:	8b 00                	mov    (%rax),%eax
  8033e4:	39 c2                	cmp    %eax,%edx
  8033e6:	0f 94 c0             	sete   %al
  8033e9:	0f b6 c0             	movzbl %al,%eax
}
  8033ec:	c9                   	leaveq 
  8033ed:	c3                   	retq   

00000000008033ee <opencons>:

int
opencons(void)
{
  8033ee:	55                   	push   %rbp
  8033ef:	48 89 e5             	mov    %rsp,%rbp
  8033f2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8033f6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033fa:	48 89 c7             	mov    %rax,%rdi
  8033fd:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  803404:	00 00 00 
  803407:	ff d0                	callq  *%rax
  803409:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80340c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803410:	79 05                	jns    803417 <opencons+0x29>
		return r;
  803412:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803415:	eb 5b                	jmp    803472 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341b:	ba 07 04 00 00       	mov    $0x407,%edx
  803420:	48 89 c6             	mov    %rax,%rsi
  803423:	bf 00 00 00 00       	mov    $0x0,%edi
  803428:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
  803434:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343b:	79 05                	jns    803442 <opencons+0x54>
		return r;
  80343d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803440:	eb 30                	jmp    803472 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803446:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80344d:	00 00 00 
  803450:	8b 12                	mov    (%rdx),%edx
  803452:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803458:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80345f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803463:	48 89 c7             	mov    %rax,%rdi
  803466:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
}
  803472:	c9                   	leaveq 
  803473:	c3                   	retq   

0000000000803474 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803474:	55                   	push   %rbp
  803475:	48 89 e5             	mov    %rsp,%rbp
  803478:	48 83 ec 30          	sub    $0x30,%rsp
  80347c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803480:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803484:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803488:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80348d:	75 07                	jne    803496 <devcons_read+0x22>
		return 0;
  80348f:	b8 00 00 00 00       	mov    $0x0,%eax
  803494:	eb 4b                	jmp    8034e1 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803496:	eb 0c                	jmp    8034a4 <devcons_read+0x30>
		sys_yield();
  803498:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8034a4:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
  8034b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b7:	74 df                	je     803498 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8034b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034bd:	79 05                	jns    8034c4 <devcons_read+0x50>
		return c;
  8034bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c2:	eb 1d                	jmp    8034e1 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8034c4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8034c8:	75 07                	jne    8034d1 <devcons_read+0x5d>
		return 0;
  8034ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cf:	eb 10                	jmp    8034e1 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8034d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d4:	89 c2                	mov    %eax,%edx
  8034d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034da:	88 10                	mov    %dl,(%rax)
	return 1;
  8034dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8034e1:	c9                   	leaveq 
  8034e2:	c3                   	retq   

00000000008034e3 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034e3:	55                   	push   %rbp
  8034e4:	48 89 e5             	mov    %rsp,%rbp
  8034e7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8034ee:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8034f5:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8034fc:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803503:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80350a:	eb 76                	jmp    803582 <devcons_write+0x9f>
		m = n - tot;
  80350c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803513:	89 c2                	mov    %eax,%edx
  803515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803518:	29 c2                	sub    %eax,%edx
  80351a:	89 d0                	mov    %edx,%eax
  80351c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80351f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803522:	83 f8 7f             	cmp    $0x7f,%eax
  803525:	76 07                	jbe    80352e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803527:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80352e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803531:	48 63 d0             	movslq %eax,%rdx
  803534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803537:	48 63 c8             	movslq %eax,%rcx
  80353a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803541:	48 01 c1             	add    %rax,%rcx
  803544:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80354b:	48 89 ce             	mov    %rcx,%rsi
  80354e:	48 89 c7             	mov    %rax,%rdi
  803551:	48 b8 59 13 80 00 00 	movabs $0x801359,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80355d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803560:	48 63 d0             	movslq %eax,%rdx
  803563:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80356a:	48 89 d6             	mov    %rdx,%rsi
  80356d:	48 89 c7             	mov    %rax,%rdi
  803570:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803577:	00 00 00 
  80357a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80357c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80357f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803585:	48 98                	cltq   
  803587:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80358e:	0f 82 78 ff ff ff    	jb     80350c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803594:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803597:	c9                   	leaveq 
  803598:	c3                   	retq   

0000000000803599 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803599:	55                   	push   %rbp
  80359a:	48 89 e5             	mov    %rsp,%rbp
  80359d:	48 83 ec 08          	sub    $0x8,%rsp
  8035a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8035a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035aa:	c9                   	leaveq 
  8035ab:	c3                   	retq   

00000000008035ac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8035ac:	55                   	push   %rbp
  8035ad:	48 89 e5             	mov    %rsp,%rbp
  8035b0:	48 83 ec 10          	sub    $0x10,%rsp
  8035b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8035bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c0:	48 be f2 3f 80 00 00 	movabs $0x803ff2,%rsi
  8035c7:	00 00 00 
  8035ca:	48 89 c7             	mov    %rax,%rdi
  8035cd:	48 b8 35 10 80 00 00 	movabs $0x801035,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
	return 0;
  8035d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035de:	c9                   	leaveq 
  8035df:	c3                   	retq   

00000000008035e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8035e0:	55                   	push   %rbp
  8035e1:	48 89 e5             	mov    %rsp,%rbp
  8035e4:	48 83 ec 30          	sub    $0x30,%rsp
  8035e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8035f4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035f9:	75 0e                	jne    803609 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8035fb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803602:	00 00 00 
  803605:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803609:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80360d:	48 89 c7             	mov    %rax,%rdi
  803610:	48 b8 8d 1b 80 00 00 	movabs $0x801b8d,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80361f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803623:	79 27                	jns    80364c <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803625:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80362a:	74 0a                	je     803636 <ipc_recv+0x56>
            *from_env_store = 0;
  80362c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803630:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803636:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80363b:	74 0a                	je     803647 <ipc_recv+0x67>
            *perm_store = 0;
  80363d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803647:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364a:	eb 53                	jmp    80369f <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  80364c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803651:	74 19                	je     80366c <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803653:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80365a:	00 00 00 
  80365d:	48 8b 00             	mov    (%rax),%rax
  803660:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366a:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80366c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803671:	74 19                	je     80368c <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803673:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80367a:	00 00 00 
  80367d:	48 8b 00             	mov    (%rax),%rax
  803680:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368a:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80368c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803693:	00 00 00 
  803696:	48 8b 00             	mov    (%rax),%rax
  803699:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80369f:	c9                   	leaveq 
  8036a0:	c3                   	retq   

00000000008036a1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8036a1:	55                   	push   %rbp
  8036a2:	48 89 e5             	mov    %rsp,%rbp
  8036a5:	48 83 ec 30          	sub    $0x30,%rsp
  8036a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ac:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036af:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8036b3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8036b6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8036bb:	75 0e                	jne    8036cb <ipc_send+0x2a>
        pg = (void *)UTOP;
  8036bd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8036c4:	00 00 00 
  8036c7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8036cb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8036ce:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8036d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8036d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036d8:	89 c7                	mov    %eax,%edi
  8036da:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  8036e1:	00 00 00 
  8036e4:	ff d0                	callq  *%rax
  8036e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8036e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ed:	79 36                	jns    803725 <ipc_send+0x84>
  8036ef:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8036f3:	74 30                	je     803725 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8036f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f8:	89 c1                	mov    %eax,%ecx
  8036fa:	48 ba f9 3f 80 00 00 	movabs $0x803ff9,%rdx
  803701:	00 00 00 
  803704:	be 49 00 00 00       	mov    $0x49,%esi
  803709:	48 bf 06 40 80 00 00 	movabs $0x804006,%rdi
  803710:	00 00 00 
  803713:	b8 00 00 00 00       	mov    $0x0,%eax
  803718:	49 b8 34 02 80 00 00 	movabs $0x800234,%r8
  80371f:	00 00 00 
  803722:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803725:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  80372c:	00 00 00 
  80372f:	ff d0                	callq  *%rax
    } while(r != 0);
  803731:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803735:	75 94                	jne    8036cb <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803737:	c9                   	leaveq 
  803738:	c3                   	retq   

0000000000803739 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803739:	55                   	push   %rbp
  80373a:	48 89 e5             	mov    %rsp,%rbp
  80373d:	48 83 ec 14          	sub    $0x14,%rsp
  803741:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803744:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80374b:	eb 5e                	jmp    8037ab <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80374d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803754:	00 00 00 
  803757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375a:	48 63 d0             	movslq %eax,%rdx
  80375d:	48 89 d0             	mov    %rdx,%rax
  803760:	48 c1 e0 03          	shl    $0x3,%rax
  803764:	48 01 d0             	add    %rdx,%rax
  803767:	48 c1 e0 05          	shl    $0x5,%rax
  80376b:	48 01 c8             	add    %rcx,%rax
  80376e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803774:	8b 00                	mov    (%rax),%eax
  803776:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803779:	75 2c                	jne    8037a7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80377b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803782:	00 00 00 
  803785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803788:	48 63 d0             	movslq %eax,%rdx
  80378b:	48 89 d0             	mov    %rdx,%rax
  80378e:	48 c1 e0 03          	shl    $0x3,%rax
  803792:	48 01 d0             	add    %rdx,%rax
  803795:	48 c1 e0 05          	shl    $0x5,%rax
  803799:	48 01 c8             	add    %rcx,%rax
  80379c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8037a2:	8b 40 08             	mov    0x8(%rax),%eax
  8037a5:	eb 12                	jmp    8037b9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8037a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8037ab:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8037b2:	7e 99                	jle    80374d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8037b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037b9:	c9                   	leaveq 
  8037ba:	c3                   	retq   

00000000008037bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8037bb:	55                   	push   %rbp
  8037bc:	48 89 e5             	mov    %rsp,%rbp
  8037bf:	48 83 ec 18          	sub    $0x18,%rsp
  8037c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8037c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037cb:	48 c1 e8 15          	shr    $0x15,%rax
  8037cf:	48 89 c2             	mov    %rax,%rdx
  8037d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037d9:	01 00 00 
  8037dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037e0:	83 e0 01             	and    $0x1,%eax
  8037e3:	48 85 c0             	test   %rax,%rax
  8037e6:	75 07                	jne    8037ef <pageref+0x34>
		return 0;
  8037e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ed:	eb 53                	jmp    803842 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8037ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f3:	48 c1 e8 0c          	shr    $0xc,%rax
  8037f7:	48 89 c2             	mov    %rax,%rdx
  8037fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803801:	01 00 00 
  803804:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80380c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803810:	83 e0 01             	and    $0x1,%eax
  803813:	48 85 c0             	test   %rax,%rax
  803816:	75 07                	jne    80381f <pageref+0x64>
		return 0;
  803818:	b8 00 00 00 00       	mov    $0x0,%eax
  80381d:	eb 23                	jmp    803842 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80381f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803823:	48 c1 e8 0c          	shr    $0xc,%rax
  803827:	48 89 c2             	mov    %rax,%rdx
  80382a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803831:	00 00 00 
  803834:	48 c1 e2 04          	shl    $0x4,%rdx
  803838:	48 01 d0             	add    %rdx,%rax
  80383b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80383f:	0f b7 c0             	movzwl %ax,%eax
}
  803842:	c9                   	leaveq 
  803843:	c3                   	retq   
