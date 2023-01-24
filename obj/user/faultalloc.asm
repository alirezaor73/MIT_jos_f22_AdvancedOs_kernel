
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
  800061:	48 bf e0 1c 80 00 00 	movabs $0x801ce0,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 61 04 80 00 00 	movabs $0x800461,%rdx
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
  80009b:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
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
  8000bd:	48 ba f0 1c 80 00 00 	movabs $0x801cf0,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cc:	48 bf 1b 1d 80 00 00 	movabs $0x801d1b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 28 02 80 00 00 	movabs $0x800228,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 30 1d 80 00 00 	movabs $0x801d30,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 dc 0e 80 00 00 	movabs $0x800edc,%r8
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
  800132:	48 b8 7b 1b 80 00 00 	movabs $0x801b7b,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013e:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800143:	48 bf 51 1d 80 00 00 	movabs $0x801d51,%rdi
  80014a:	00 00 00 
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
  800152:	48 ba 61 04 80 00 00 	movabs $0x800461,%rdx
  800159:	00 00 00 
  80015c:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015e:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800163:	48 bf 51 1d 80 00 00 	movabs $0x801d51,%rdi
  80016a:	00 00 00 
  80016d:	b8 00 00 00 00       	mov    $0x0,%eax
  800172:	48 ba 61 04 80 00 00 	movabs $0x800461,%rdx
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
	envid_t id = sys_getenvid();
  80018f:	48 b8 dc 18 80 00 00 	movabs $0x8018dc,%rax
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
  8001c4:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8001cb:	00 00 00 
  8001ce:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001d5:	7e 14                	jle    8001eb <libmain+0x6b>
		binaryname = argv[0];
  8001d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001db:	48 8b 10             	mov    (%rax),%rdx
  8001de:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  800215:	bf 00 00 00 00       	mov    $0x0,%edi
  80021a:	48 b8 98 18 80 00 00 	movabs $0x801898,%rax
  800221:	00 00 00 
  800224:	ff d0                	callq  *%rax
}
  800226:	5d                   	pop    %rbp
  800227:	c3                   	retq   

0000000000800228 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800228:	55                   	push   %rbp
  800229:	48 89 e5             	mov    %rsp,%rbp
  80022c:	53                   	push   %rbx
  80022d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800234:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80023b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800241:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800248:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80024f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800256:	84 c0                	test   %al,%al
  800258:	74 23                	je     80027d <_panic+0x55>
  80025a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800261:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800265:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800269:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80026d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800271:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800275:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800279:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80027d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800284:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80028b:	00 00 00 
  80028e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800295:	00 00 00 
  800298:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80029c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002a3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002aa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b1:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002b8:	00 00 00 
  8002bb:	48 8b 18             	mov    (%rax),%rbx
  8002be:	48 b8 dc 18 80 00 00 	movabs $0x8018dc,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
  8002ca:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002d0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002d7:	41 89 c8             	mov    %ecx,%r8d
  8002da:	48 89 d1             	mov    %rdx,%rcx
  8002dd:	48 89 da             	mov    %rbx,%rdx
  8002e0:	89 c6                	mov    %eax,%esi
  8002e2:	48 bf 60 1d 80 00 00 	movabs $0x801d60,%rdi
  8002e9:	00 00 00 
  8002ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f1:	49 b9 61 04 80 00 00 	movabs $0x800461,%r9
  8002f8:	00 00 00 
  8002fb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002fe:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800305:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80030c:	48 89 d6             	mov    %rdx,%rsi
  80030f:	48 89 c7             	mov    %rax,%rdi
  800312:	48 b8 b5 03 80 00 00 	movabs $0x8003b5,%rax
  800319:	00 00 00 
  80031c:	ff d0                	callq  *%rax
	cprintf("\n");
  80031e:	48 bf 83 1d 80 00 00 	movabs $0x801d83,%rdi
  800325:	00 00 00 
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	48 ba 61 04 80 00 00 	movabs $0x800461,%rdx
  800334:	00 00 00 
  800337:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800339:	cc                   	int3   
  80033a:	eb fd                	jmp    800339 <_panic+0x111>

000000000080033c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80033c:	55                   	push   %rbp
  80033d:	48 89 e5             	mov    %rsp,%rbp
  800340:	48 83 ec 10          	sub    $0x10,%rsp
  800344:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800347:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80034b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034f:	8b 00                	mov    (%rax),%eax
  800351:	8d 48 01             	lea    0x1(%rax),%ecx
  800354:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800358:	89 0a                	mov    %ecx,(%rdx)
  80035a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80035d:	89 d1                	mov    %edx,%ecx
  80035f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800363:	48 98                	cltq   
  800365:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036d:	8b 00                	mov    (%rax),%eax
  80036f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800374:	75 2c                	jne    8003a2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037a:	8b 00                	mov    (%rax),%eax
  80037c:	48 98                	cltq   
  80037e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800382:	48 83 c2 08          	add    $0x8,%rdx
  800386:	48 89 c6             	mov    %rax,%rsi
  800389:	48 89 d7             	mov    %rdx,%rdi
  80038c:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
        b->idx = 0;
  800398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a6:	8b 40 04             	mov    0x4(%rax),%eax
  8003a9:	8d 50 01             	lea    0x1(%rax),%edx
  8003ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003b3:	c9                   	leaveq 
  8003b4:	c3                   	retq   

00000000008003b5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003b5:	55                   	push   %rbp
  8003b6:	48 89 e5             	mov    %rsp,%rbp
  8003b9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003c0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003c7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003ce:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003d5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003dc:	48 8b 0a             	mov    (%rdx),%rcx
  8003df:	48 89 08             	mov    %rcx,(%rax)
  8003e2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003e6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003ea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003ee:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003f9:	00 00 00 
    b.cnt = 0;
  8003fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800403:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800406:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80040d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800414:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80041b:	48 89 c6             	mov    %rax,%rsi
  80041e:	48 bf 3c 03 80 00 00 	movabs $0x80033c,%rdi
  800425:	00 00 00 
  800428:	48 b8 14 08 80 00 00 	movabs $0x800814,%rax
  80042f:	00 00 00 
  800432:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800434:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80043a:	48 98                	cltq   
  80043c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800443:	48 83 c2 08          	add    $0x8,%rdx
  800447:	48 89 c6             	mov    %rax,%rsi
  80044a:	48 89 d7             	mov    %rdx,%rdi
  80044d:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  800454:	00 00 00 
  800457:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800459:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80045f:	c9                   	leaveq 
  800460:	c3                   	retq   

0000000000800461 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800461:	55                   	push   %rbp
  800462:	48 89 e5             	mov    %rsp,%rbp
  800465:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80046c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800473:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80047a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800481:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800488:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80048f:	84 c0                	test   %al,%al
  800491:	74 20                	je     8004b3 <cprintf+0x52>
  800493:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800497:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80049b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80049f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004a3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004a7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004ab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004af:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004b3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004ba:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004c1:	00 00 00 
  8004c4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004cb:	00 00 00 
  8004ce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004d2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004d9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004e0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004e7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004ee:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004f5:	48 8b 0a             	mov    (%rdx),%rcx
  8004f8:	48 89 08             	mov    %rcx,(%rax)
  8004fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800503:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800507:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80050b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800512:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800519:	48 89 d6             	mov    %rdx,%rsi
  80051c:	48 89 c7             	mov    %rax,%rdi
  80051f:	48 b8 b5 03 80 00 00 	movabs $0x8003b5,%rax
  800526:	00 00 00 
  800529:	ff d0                	callq  *%rax
  80052b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800531:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800537:	c9                   	leaveq 
  800538:	c3                   	retq   

0000000000800539 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800539:	55                   	push   %rbp
  80053a:	48 89 e5             	mov    %rsp,%rbp
  80053d:	53                   	push   %rbx
  80053e:	48 83 ec 38          	sub    $0x38,%rsp
  800542:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800546:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80054a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80054e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800551:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800555:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800559:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80055c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800560:	77 3b                	ja     80059d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800562:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800565:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800569:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80056c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800570:	ba 00 00 00 00       	mov    $0x0,%edx
  800575:	48 f7 f3             	div    %rbx
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80057e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800581:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800589:	41 89 f9             	mov    %edi,%r9d
  80058c:	48 89 c7             	mov    %rax,%rdi
  80058f:	48 b8 39 05 80 00 00 	movabs $0x800539,%rax
  800596:	00 00 00 
  800599:	ff d0                	callq  *%rax
  80059b:	eb 1e                	jmp    8005bb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80059d:	eb 12                	jmp    8005b1 <printnum+0x78>
			putch(padc, putdat);
  80059f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005a3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005aa:	48 89 ce             	mov    %rcx,%rsi
  8005ad:	89 d7                	mov    %edx,%edi
  8005af:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005b1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005b5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005b9:	7f e4                	jg     80059f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005bb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	48 f7 f1             	div    %rcx
  8005ca:	48 89 d0             	mov    %rdx,%rax
  8005cd:	48 ba f0 1e 80 00 00 	movabs $0x801ef0,%rdx
  8005d4:	00 00 00 
  8005d7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005db:	0f be d0             	movsbl %al,%edx
  8005de:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 89 ce             	mov    %rcx,%rsi
  8005e9:	89 d7                	mov    %edx,%edi
  8005eb:	ff d0                	callq  *%rax
}
  8005ed:	48 83 c4 38          	add    $0x38,%rsp
  8005f1:	5b                   	pop    %rbx
  8005f2:	5d                   	pop    %rbp
  8005f3:	c3                   	retq   

00000000008005f4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005f4:	55                   	push   %rbp
  8005f5:	48 89 e5             	mov    %rsp,%rbp
  8005f8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800600:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800603:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800607:	7e 52                	jle    80065b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060d:	8b 00                	mov    (%rax),%eax
  80060f:	83 f8 30             	cmp    $0x30,%eax
  800612:	73 24                	jae    800638 <getuint+0x44>
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80061c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800620:	8b 00                	mov    (%rax),%eax
  800622:	89 c0                	mov    %eax,%eax
  800624:	48 01 d0             	add    %rdx,%rax
  800627:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062b:	8b 12                	mov    (%rdx),%edx
  80062d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800630:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800634:	89 0a                	mov    %ecx,(%rdx)
  800636:	eb 17                	jmp    80064f <getuint+0x5b>
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800640:	48 89 d0             	mov    %rdx,%rax
  800643:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800647:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800656:	e9 a3 00 00 00       	jmpq   8006fe <getuint+0x10a>
	else if (lflag)
  80065b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80065f:	74 4f                	je     8006b0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800665:	8b 00                	mov    (%rax),%eax
  800667:	83 f8 30             	cmp    $0x30,%eax
  80066a:	73 24                	jae    800690 <getuint+0x9c>
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	8b 00                	mov    (%rax),%eax
  80067a:	89 c0                	mov    %eax,%eax
  80067c:	48 01 d0             	add    %rdx,%rax
  80067f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800683:	8b 12                	mov    (%rdx),%edx
  800685:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068c:	89 0a                	mov    %ecx,(%rdx)
  80068e:	eb 17                	jmp    8006a7 <getuint+0xb3>
  800690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800694:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800698:	48 89 d0             	mov    %rdx,%rax
  80069b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80069f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a7:	48 8b 00             	mov    (%rax),%rax
  8006aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ae:	eb 4e                	jmp    8006fe <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	8b 00                	mov    (%rax),%eax
  8006b6:	83 f8 30             	cmp    $0x30,%eax
  8006b9:	73 24                	jae    8006df <getuint+0xeb>
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	8b 00                	mov    (%rax),%eax
  8006c9:	89 c0                	mov    %eax,%eax
  8006cb:	48 01 d0             	add    %rdx,%rax
  8006ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d2:	8b 12                	mov    (%rdx),%edx
  8006d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006db:	89 0a                	mov    %ecx,(%rdx)
  8006dd:	eb 17                	jmp    8006f6 <getuint+0x102>
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e7:	48 89 d0             	mov    %rdx,%rax
  8006ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f6:	8b 00                	mov    (%rax),%eax
  8006f8:	89 c0                	mov    %eax,%eax
  8006fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800702:	c9                   	leaveq 
  800703:	c3                   	retq   

0000000000800704 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800704:	55                   	push   %rbp
  800705:	48 89 e5             	mov    %rsp,%rbp
  800708:	48 83 ec 1c          	sub    $0x1c,%rsp
  80070c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800710:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800713:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800717:	7e 52                	jle    80076b <getint+0x67>
		x=va_arg(*ap, long long);
  800719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071d:	8b 00                	mov    (%rax),%eax
  80071f:	83 f8 30             	cmp    $0x30,%eax
  800722:	73 24                	jae    800748 <getint+0x44>
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80072c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800730:	8b 00                	mov    (%rax),%eax
  800732:	89 c0                	mov    %eax,%eax
  800734:	48 01 d0             	add    %rdx,%rax
  800737:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073b:	8b 12                	mov    (%rdx),%edx
  80073d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800740:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800744:	89 0a                	mov    %ecx,(%rdx)
  800746:	eb 17                	jmp    80075f <getint+0x5b>
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800750:	48 89 d0             	mov    %rdx,%rax
  800753:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800757:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80075f:	48 8b 00             	mov    (%rax),%rax
  800762:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800766:	e9 a3 00 00 00       	jmpq   80080e <getint+0x10a>
	else if (lflag)
  80076b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80076f:	74 4f                	je     8007c0 <getint+0xbc>
		x=va_arg(*ap, long);
  800771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800775:	8b 00                	mov    (%rax),%eax
  800777:	83 f8 30             	cmp    $0x30,%eax
  80077a:	73 24                	jae    8007a0 <getint+0x9c>
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	8b 00                	mov    (%rax),%eax
  80078a:	89 c0                	mov    %eax,%eax
  80078c:	48 01 d0             	add    %rdx,%rax
  80078f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800793:	8b 12                	mov    (%rdx),%edx
  800795:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800798:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079c:	89 0a                	mov    %ecx,(%rdx)
  80079e:	eb 17                	jmp    8007b7 <getint+0xb3>
  8007a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a8:	48 89 d0             	mov    %rdx,%rax
  8007ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b7:	48 8b 00             	mov    (%rax),%rax
  8007ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007be:	eb 4e                	jmp    80080e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c4:	8b 00                	mov    (%rax),%eax
  8007c6:	83 f8 30             	cmp    $0x30,%eax
  8007c9:	73 24                	jae    8007ef <getint+0xeb>
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d7:	8b 00                	mov    (%rax),%eax
  8007d9:	89 c0                	mov    %eax,%eax
  8007db:	48 01 d0             	add    %rdx,%rax
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	8b 12                	mov    (%rdx),%edx
  8007e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007eb:	89 0a                	mov    %ecx,(%rdx)
  8007ed:	eb 17                	jmp    800806 <getint+0x102>
  8007ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f7:	48 89 d0             	mov    %rdx,%rax
  8007fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800806:	8b 00                	mov    (%rax),%eax
  800808:	48 98                	cltq   
  80080a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80080e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800812:	c9                   	leaveq 
  800813:	c3                   	retq   

0000000000800814 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800814:	55                   	push   %rbp
  800815:	48 89 e5             	mov    %rsp,%rbp
  800818:	41 54                	push   %r12
  80081a:	53                   	push   %rbx
  80081b:	48 83 ec 60          	sub    $0x60,%rsp
  80081f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800823:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800827:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80082b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80082f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800833:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800837:	48 8b 0a             	mov    (%rdx),%rcx
  80083a:	48 89 08             	mov    %rcx,(%rax)
  80083d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800841:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800845:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800849:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084d:	eb 17                	jmp    800866 <vprintfmt+0x52>
			if (ch == '\0')
  80084f:	85 db                	test   %ebx,%ebx
  800851:	0f 84 df 04 00 00    	je     800d36 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800857:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80085b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085f:	48 89 d6             	mov    %rdx,%rsi
  800862:	89 df                	mov    %ebx,%edi
  800864:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800866:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80086a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80086e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800872:	0f b6 00             	movzbl (%rax),%eax
  800875:	0f b6 d8             	movzbl %al,%ebx
  800878:	83 fb 25             	cmp    $0x25,%ebx
  80087b:	75 d2                	jne    80084f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80087d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800881:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800888:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800896:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a9:	0f b6 00             	movzbl (%rax),%eax
  8008ac:	0f b6 d8             	movzbl %al,%ebx
  8008af:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008b2:	83 f8 55             	cmp    $0x55,%eax
  8008b5:	0f 87 47 04 00 00    	ja     800d02 <vprintfmt+0x4ee>
  8008bb:	89 c0                	mov    %eax,%eax
  8008bd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008c4:	00 
  8008c5:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  8008cc:	00 00 00 
  8008cf:	48 01 d0             	add    %rdx,%rax
  8008d2:	48 8b 00             	mov    (%rax),%rax
  8008d5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008d7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008db:	eb c0                	jmp    80089d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008dd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008e1:	eb ba                	jmp    80089d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008ea:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008ed:	89 d0                	mov    %edx,%eax
  8008ef:	c1 e0 02             	shl    $0x2,%eax
  8008f2:	01 d0                	add    %edx,%eax
  8008f4:	01 c0                	add    %eax,%eax
  8008f6:	01 d8                	add    %ebx,%eax
  8008f8:	83 e8 30             	sub    $0x30,%eax
  8008fb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008fe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800902:	0f b6 00             	movzbl (%rax),%eax
  800905:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800908:	83 fb 2f             	cmp    $0x2f,%ebx
  80090b:	7e 0c                	jle    800919 <vprintfmt+0x105>
  80090d:	83 fb 39             	cmp    $0x39,%ebx
  800910:	7f 07                	jg     800919 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800912:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800917:	eb d1                	jmp    8008ea <vprintfmt+0xd6>
			goto process_precision;
  800919:	eb 58                	jmp    800973 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80091b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091e:	83 f8 30             	cmp    $0x30,%eax
  800921:	73 17                	jae    80093a <vprintfmt+0x126>
  800923:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800927:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092a:	89 c0                	mov    %eax,%eax
  80092c:	48 01 d0             	add    %rdx,%rax
  80092f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800932:	83 c2 08             	add    $0x8,%edx
  800935:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800938:	eb 0f                	jmp    800949 <vprintfmt+0x135>
  80093a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093e:	48 89 d0             	mov    %rdx,%rax
  800941:	48 83 c2 08          	add    $0x8,%rdx
  800945:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800949:	8b 00                	mov    (%rax),%eax
  80094b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80094e:	eb 23                	jmp    800973 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800950:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800954:	79 0c                	jns    800962 <vprintfmt+0x14e>
				width = 0;
  800956:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80095d:	e9 3b ff ff ff       	jmpq   80089d <vprintfmt+0x89>
  800962:	e9 36 ff ff ff       	jmpq   80089d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800967:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80096e:	e9 2a ff ff ff       	jmpq   80089d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800973:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800977:	79 12                	jns    80098b <vprintfmt+0x177>
				width = precision, precision = -1;
  800979:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80097c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80097f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800986:	e9 12 ff ff ff       	jmpq   80089d <vprintfmt+0x89>
  80098b:	e9 0d ff ff ff       	jmpq   80089d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800994:	e9 04 ff ff ff       	jmpq   80089d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800999:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099c:	83 f8 30             	cmp    $0x30,%eax
  80099f:	73 17                	jae    8009b8 <vprintfmt+0x1a4>
  8009a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a8:	89 c0                	mov    %eax,%eax
  8009aa:	48 01 d0             	add    %rdx,%rax
  8009ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b0:	83 c2 08             	add    $0x8,%edx
  8009b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b6:	eb 0f                	jmp    8009c7 <vprintfmt+0x1b3>
  8009b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009bc:	48 89 d0             	mov    %rdx,%rax
  8009bf:	48 83 c2 08          	add    $0x8,%rdx
  8009c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009c7:	8b 10                	mov    (%rax),%edx
  8009c9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d1:	48 89 ce             	mov    %rcx,%rsi
  8009d4:	89 d7                	mov    %edx,%edi
  8009d6:	ff d0                	callq  *%rax
			break;
  8009d8:	e9 53 03 00 00       	jmpq   800d30 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e0:	83 f8 30             	cmp    $0x30,%eax
  8009e3:	73 17                	jae    8009fc <vprintfmt+0x1e8>
  8009e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ec:	89 c0                	mov    %eax,%eax
  8009ee:	48 01 d0             	add    %rdx,%rax
  8009f1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f4:	83 c2 08             	add    $0x8,%edx
  8009f7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009fa:	eb 0f                	jmp    800a0b <vprintfmt+0x1f7>
  8009fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a00:	48 89 d0             	mov    %rdx,%rax
  800a03:	48 83 c2 08          	add    $0x8,%rdx
  800a07:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a0b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a0d:	85 db                	test   %ebx,%ebx
  800a0f:	79 02                	jns    800a13 <vprintfmt+0x1ff>
				err = -err;
  800a11:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a13:	83 fb 15             	cmp    $0x15,%ebx
  800a16:	7f 16                	jg     800a2e <vprintfmt+0x21a>
  800a18:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  800a1f:	00 00 00 
  800a22:	48 63 d3             	movslq %ebx,%rdx
  800a25:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a29:	4d 85 e4             	test   %r12,%r12
  800a2c:	75 2e                	jne    800a5c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a2e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a36:	89 d9                	mov    %ebx,%ecx
  800a38:	48 ba 01 1f 80 00 00 	movabs $0x801f01,%rdx
  800a3f:	00 00 00 
  800a42:	48 89 c7             	mov    %rax,%rdi
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	49 b8 3f 0d 80 00 00 	movabs $0x800d3f,%r8
  800a51:	00 00 00 
  800a54:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a57:	e9 d4 02 00 00       	jmpq   800d30 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a5c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a64:	4c 89 e1             	mov    %r12,%rcx
  800a67:	48 ba 0a 1f 80 00 00 	movabs $0x801f0a,%rdx
  800a6e:	00 00 00 
  800a71:	48 89 c7             	mov    %rax,%rdi
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b8 3f 0d 80 00 00 	movabs $0x800d3f,%r8
  800a80:	00 00 00 
  800a83:	41 ff d0             	callq  *%r8
			break;
  800a86:	e9 a5 02 00 00       	jmpq   800d30 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8e:	83 f8 30             	cmp    $0x30,%eax
  800a91:	73 17                	jae    800aaa <vprintfmt+0x296>
  800a93:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9a:	89 c0                	mov    %eax,%eax
  800a9c:	48 01 d0             	add    %rdx,%rax
  800a9f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa2:	83 c2 08             	add    $0x8,%edx
  800aa5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa8:	eb 0f                	jmp    800ab9 <vprintfmt+0x2a5>
  800aaa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aae:	48 89 d0             	mov    %rdx,%rax
  800ab1:	48 83 c2 08          	add    $0x8,%rdx
  800ab5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab9:	4c 8b 20             	mov    (%rax),%r12
  800abc:	4d 85 e4             	test   %r12,%r12
  800abf:	75 0a                	jne    800acb <vprintfmt+0x2b7>
				p = "(null)";
  800ac1:	49 bc 0d 1f 80 00 00 	movabs $0x801f0d,%r12
  800ac8:	00 00 00 
			if (width > 0 && padc != '-')
  800acb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acf:	7e 3f                	jle    800b10 <vprintfmt+0x2fc>
  800ad1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ad5:	74 39                	je     800b10 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ada:	48 98                	cltq   
  800adc:	48 89 c6             	mov    %rax,%rsi
  800adf:	4c 89 e7             	mov    %r12,%rdi
  800ae2:	48 b8 eb 0f 80 00 00 	movabs $0x800feb,%rax
  800ae9:	00 00 00 
  800aec:	ff d0                	callq  *%rax
  800aee:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800af1:	eb 17                	jmp    800b0a <vprintfmt+0x2f6>
					putch(padc, putdat);
  800af3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800af7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 ce             	mov    %rcx,%rsi
  800b02:	89 d7                	mov    %edx,%edi
  800b04:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b06:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b0a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0e:	7f e3                	jg     800af3 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b10:	eb 37                	jmp    800b49 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b12:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b16:	74 1e                	je     800b36 <vprintfmt+0x322>
  800b18:	83 fb 1f             	cmp    $0x1f,%ebx
  800b1b:	7e 05                	jle    800b22 <vprintfmt+0x30e>
  800b1d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b20:	7e 14                	jle    800b36 <vprintfmt+0x322>
					putch('?', putdat);
  800b22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2a:	48 89 d6             	mov    %rdx,%rsi
  800b2d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b32:	ff d0                	callq  *%rax
  800b34:	eb 0f                	jmp    800b45 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3e:	48 89 d6             	mov    %rdx,%rsi
  800b41:	89 df                	mov    %ebx,%edi
  800b43:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b45:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b49:	4c 89 e0             	mov    %r12,%rax
  800b4c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b50:	0f b6 00             	movzbl (%rax),%eax
  800b53:	0f be d8             	movsbl %al,%ebx
  800b56:	85 db                	test   %ebx,%ebx
  800b58:	74 10                	je     800b6a <vprintfmt+0x356>
  800b5a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b5e:	78 b2                	js     800b12 <vprintfmt+0x2fe>
  800b60:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b64:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b68:	79 a8                	jns    800b12 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6a:	eb 16                	jmp    800b82 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b74:	48 89 d6             	mov    %rdx,%rsi
  800b77:	bf 20 00 00 00       	mov    $0x20,%edi
  800b7c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b82:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b86:	7f e4                	jg     800b6c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b88:	e9 a3 01 00 00       	jmpq   800d30 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b8d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b91:	be 03 00 00 00       	mov    $0x3,%esi
  800b96:	48 89 c7             	mov    %rax,%rdi
  800b99:	48 b8 04 07 80 00 00 	movabs $0x800704,%rax
  800ba0:	00 00 00 
  800ba3:	ff d0                	callq  *%rax
  800ba5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bad:	48 85 c0             	test   %rax,%rax
  800bb0:	79 1d                	jns    800bcf <vprintfmt+0x3bb>
				putch('-', putdat);
  800bb2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	48 89 d6             	mov    %rdx,%rsi
  800bbd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bc2:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc8:	48 f7 d8             	neg    %rax
  800bcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bcf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bd6:	e9 e8 00 00 00       	jmpq   800cc3 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bdb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdf:	be 03 00 00 00       	mov    $0x3,%esi
  800be4:	48 89 c7             	mov    %rax,%rdi
  800be7:	48 b8 f4 05 80 00 00 	movabs $0x8005f4,%rax
  800bee:	00 00 00 
  800bf1:	ff d0                	callq  *%rax
  800bf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bf7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bfe:	e9 c0 00 00 00       	jmpq   800cc3 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0b:	48 89 d6             	mov    %rdx,%rsi
  800c0e:	bf 58 00 00 00       	mov    $0x58,%edi
  800c13:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1d:	48 89 d6             	mov    %rdx,%rsi
  800c20:	bf 58 00 00 00       	mov    $0x58,%edi
  800c25:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2f:	48 89 d6             	mov    %rdx,%rsi
  800c32:	bf 58 00 00 00       	mov    $0x58,%edi
  800c37:	ff d0                	callq  *%rax
			break;
  800c39:	e9 f2 00 00 00       	jmpq   800d30 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c46:	48 89 d6             	mov    %rdx,%rsi
  800c49:	bf 30 00 00 00       	mov    $0x30,%edi
  800c4e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c58:	48 89 d6             	mov    %rdx,%rsi
  800c5b:	bf 78 00 00 00       	mov    $0x78,%edi
  800c60:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c65:	83 f8 30             	cmp    $0x30,%eax
  800c68:	73 17                	jae    800c81 <vprintfmt+0x46d>
  800c6a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c71:	89 c0                	mov    %eax,%eax
  800c73:	48 01 d0             	add    %rdx,%rax
  800c76:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c79:	83 c2 08             	add    $0x8,%edx
  800c7c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7f:	eb 0f                	jmp    800c90 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800c81:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c85:	48 89 d0             	mov    %rdx,%rax
  800c88:	48 83 c2 08          	add    $0x8,%rdx
  800c8c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c90:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c97:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c9e:	eb 23                	jmp    800cc3 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ca0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ca4:	be 03 00 00 00       	mov    $0x3,%esi
  800ca9:	48 89 c7             	mov    %rax,%rdi
  800cac:	48 b8 f4 05 80 00 00 	movabs $0x8005f4,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	callq  *%rax
  800cb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cbc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cc8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ccb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cda:	45 89 c1             	mov    %r8d,%r9d
  800cdd:	41 89 f8             	mov    %edi,%r8d
  800ce0:	48 89 c7             	mov    %rax,%rdi
  800ce3:	48 b8 39 05 80 00 00 	movabs $0x800539,%rax
  800cea:	00 00 00 
  800ced:	ff d0                	callq  *%rax
			break;
  800cef:	eb 3f                	jmp    800d30 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf9:	48 89 d6             	mov    %rdx,%rsi
  800cfc:	89 df                	mov    %ebx,%edi
  800cfe:	ff d0                	callq  *%rax
			break;
  800d00:	eb 2e                	jmp    800d30 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0a:	48 89 d6             	mov    %rdx,%rsi
  800d0d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d12:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d14:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d19:	eb 05                	jmp    800d20 <vprintfmt+0x50c>
  800d1b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d20:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d24:	48 83 e8 01          	sub    $0x1,%rax
  800d28:	0f b6 00             	movzbl (%rax),%eax
  800d2b:	3c 25                	cmp    $0x25,%al
  800d2d:	75 ec                	jne    800d1b <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d2f:	90                   	nop
		}
	}
  800d30:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d31:	e9 30 fb ff ff       	jmpq   800866 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d36:	48 83 c4 60          	add    $0x60,%rsp
  800d3a:	5b                   	pop    %rbx
  800d3b:	41 5c                	pop    %r12
  800d3d:	5d                   	pop    %rbp
  800d3e:	c3                   	retq   

0000000000800d3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d3f:	55                   	push   %rbp
  800d40:	48 89 e5             	mov    %rsp,%rbp
  800d43:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d4a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d51:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d58:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d5f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d66:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 20                	je     800d91 <printfmt+0x52>
  800d71:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d75:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d79:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d7d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d81:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d85:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d89:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d8d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d91:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d98:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d9f:	00 00 00 
  800da2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800da9:	00 00 00 
  800dac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800db0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800db7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dbe:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dcc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dd3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dda:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800de1:	48 89 c7             	mov    %rax,%rdi
  800de4:	48 b8 14 08 80 00 00 	movabs $0x800814,%rax
  800deb:	00 00 00 
  800dee:	ff d0                	callq  *%rax
	va_end(ap);
}
  800df0:	c9                   	leaveq 
  800df1:	c3                   	retq   

0000000000800df2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800df2:	55                   	push   %rbp
  800df3:	48 89 e5             	mov    %rsp,%rbp
  800df6:	48 83 ec 10          	sub    $0x10,%rsp
  800dfa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e05:	8b 40 10             	mov    0x10(%rax),%eax
  800e08:	8d 50 01             	lea    0x1(%rax),%edx
  800e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e16:	48 8b 10             	mov    (%rax),%rdx
  800e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e21:	48 39 c2             	cmp    %rax,%rdx
  800e24:	73 17                	jae    800e3d <sprintputch+0x4b>
		*b->buf++ = ch;
  800e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2a:	48 8b 00             	mov    (%rax),%rax
  800e2d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e35:	48 89 0a             	mov    %rcx,(%rdx)
  800e38:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e3b:	88 10                	mov    %dl,(%rax)
}
  800e3d:	c9                   	leaveq 
  800e3e:	c3                   	retq   

0000000000800e3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e3f:	55                   	push   %rbp
  800e40:	48 89 e5             	mov    %rsp,%rbp
  800e43:	48 83 ec 50          	sub    $0x50,%rsp
  800e47:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e4b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e4e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e52:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e56:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e5a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e5e:	48 8b 0a             	mov    (%rdx),%rcx
  800e61:	48 89 08             	mov    %rcx,(%rax)
  800e64:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e68:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e6c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e70:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e74:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e78:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e7c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e7f:	48 98                	cltq   
  800e81:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e85:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e89:	48 01 d0             	add    %rdx,%rax
  800e8c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e90:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e97:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e9c:	74 06                	je     800ea4 <vsnprintf+0x65>
  800e9e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ea2:	7f 07                	jg     800eab <vsnprintf+0x6c>
		return -E_INVAL;
  800ea4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea9:	eb 2f                	jmp    800eda <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eab:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800eaf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eb3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eb7:	48 89 c6             	mov    %rax,%rsi
  800eba:	48 bf f2 0d 80 00 00 	movabs $0x800df2,%rdi
  800ec1:	00 00 00 
  800ec4:	48 b8 14 08 80 00 00 	movabs $0x800814,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ed0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ed4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ed7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eda:	c9                   	leaveq 
  800edb:	c3                   	retq   

0000000000800edc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800edc:	55                   	push   %rbp
  800edd:	48 89 e5             	mov    %rsp,%rbp
  800ee0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ee7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800eee:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ef4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800efb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f02:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f09:	84 c0                	test   %al,%al
  800f0b:	74 20                	je     800f2d <snprintf+0x51>
  800f0d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f11:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f15:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f19:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f1d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f21:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f25:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f29:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f2d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f34:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f3b:	00 00 00 
  800f3e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f45:	00 00 00 
  800f48:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f4c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f53:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f5a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f61:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f68:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f6f:	48 8b 0a             	mov    (%rdx),%rcx
  800f72:	48 89 08             	mov    %rcx,(%rax)
  800f75:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f79:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f7d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f81:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f85:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f8c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f93:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f99:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fa0:	48 89 c7             	mov    %rax,%rdi
  800fa3:	48 b8 3f 0e 80 00 00 	movabs $0x800e3f,%rax
  800faa:	00 00 00 
  800fad:	ff d0                	callq  *%rax
  800faf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fb5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fbb:	c9                   	leaveq 
  800fbc:	c3                   	retq   

0000000000800fbd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fbd:	55                   	push   %rbp
  800fbe:	48 89 e5             	mov    %rsp,%rbp
  800fc1:	48 83 ec 18          	sub    $0x18,%rsp
  800fc5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fd0:	eb 09                	jmp    800fdb <strlen+0x1e>
		n++;
  800fd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdf:	0f b6 00             	movzbl (%rax),%eax
  800fe2:	84 c0                	test   %al,%al
  800fe4:	75 ec                	jne    800fd2 <strlen+0x15>
		n++;
	return n;
  800fe6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fe9:	c9                   	leaveq 
  800fea:	c3                   	retq   

0000000000800feb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800feb:	55                   	push   %rbp
  800fec:	48 89 e5             	mov    %rsp,%rbp
  800fef:	48 83 ec 20          	sub    $0x20,%rsp
  800ff3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ffb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801002:	eb 0e                	jmp    801012 <strnlen+0x27>
		n++;
  801004:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801008:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80100d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801012:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801017:	74 0b                	je     801024 <strnlen+0x39>
  801019:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101d:	0f b6 00             	movzbl (%rax),%eax
  801020:	84 c0                	test   %al,%al
  801022:	75 e0                	jne    801004 <strnlen+0x19>
		n++;
	return n;
  801024:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801027:	c9                   	leaveq 
  801028:	c3                   	retq   

0000000000801029 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801029:	55                   	push   %rbp
  80102a:	48 89 e5             	mov    %rsp,%rbp
  80102d:	48 83 ec 20          	sub    $0x20,%rsp
  801031:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801035:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801041:	90                   	nop
  801042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801046:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80104a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80104e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801052:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801056:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80105a:	0f b6 12             	movzbl (%rdx),%edx
  80105d:	88 10                	mov    %dl,(%rax)
  80105f:	0f b6 00             	movzbl (%rax),%eax
  801062:	84 c0                	test   %al,%al
  801064:	75 dc                	jne    801042 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80106a:	c9                   	leaveq 
  80106b:	c3                   	retq   

000000000080106c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80106c:	55                   	push   %rbp
  80106d:	48 89 e5             	mov    %rsp,%rbp
  801070:	48 83 ec 20          	sub    $0x20,%rsp
  801074:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801078:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80107c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801080:	48 89 c7             	mov    %rax,%rdi
  801083:	48 b8 bd 0f 80 00 00 	movabs $0x800fbd,%rax
  80108a:	00 00 00 
  80108d:	ff d0                	callq  *%rax
  80108f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801092:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801095:	48 63 d0             	movslq %eax,%rdx
  801098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109c:	48 01 c2             	add    %rax,%rdx
  80109f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010a3:	48 89 c6             	mov    %rax,%rsi
  8010a6:	48 89 d7             	mov    %rdx,%rdi
  8010a9:	48 b8 29 10 80 00 00 	movabs $0x801029,%rax
  8010b0:	00 00 00 
  8010b3:	ff d0                	callq  *%rax
	return dst;
  8010b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010b9:	c9                   	leaveq 
  8010ba:	c3                   	retq   

00000000008010bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010bb:	55                   	push   %rbp
  8010bc:	48 89 e5             	mov    %rsp,%rbp
  8010bf:	48 83 ec 28          	sub    $0x28,%rsp
  8010c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010d7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010de:	00 
  8010df:	eb 2a                	jmp    80110b <strncpy+0x50>
		*dst++ = *src;
  8010e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010f1:	0f b6 12             	movzbl (%rdx),%edx
  8010f4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010fa:	0f b6 00             	movzbl (%rax),%eax
  8010fd:	84 c0                	test   %al,%al
  8010ff:	74 05                	je     801106 <strncpy+0x4b>
			src++;
  801101:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801106:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80110b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801113:	72 cc                	jb     8010e1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801119:	c9                   	leaveq 
  80111a:	c3                   	retq   

000000000080111b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80111b:	55                   	push   %rbp
  80111c:	48 89 e5             	mov    %rsp,%rbp
  80111f:	48 83 ec 28          	sub    $0x28,%rsp
  801123:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801127:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80112b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801133:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801137:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80113c:	74 3d                	je     80117b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80113e:	eb 1d                	jmp    80115d <strlcpy+0x42>
			*dst++ = *src++;
  801140:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801144:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801148:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80114c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801150:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801154:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801158:	0f b6 12             	movzbl (%rdx),%edx
  80115b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80115d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801162:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801167:	74 0b                	je     801174 <strlcpy+0x59>
  801169:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116d:	0f b6 00             	movzbl (%rax),%eax
  801170:	84 c0                	test   %al,%al
  801172:	75 cc                	jne    801140 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80117b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80117f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801183:	48 29 c2             	sub    %rax,%rdx
  801186:	48 89 d0             	mov    %rdx,%rax
}
  801189:	c9                   	leaveq 
  80118a:	c3                   	retq   

000000000080118b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80118b:	55                   	push   %rbp
  80118c:	48 89 e5             	mov    %rsp,%rbp
  80118f:	48 83 ec 10          	sub    $0x10,%rsp
  801193:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801197:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80119b:	eb 0a                	jmp    8011a7 <strcmp+0x1c>
		p++, q++;
  80119d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	0f b6 00             	movzbl (%rax),%eax
  8011ae:	84 c0                	test   %al,%al
  8011b0:	74 12                	je     8011c4 <strcmp+0x39>
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	0f b6 10             	movzbl (%rax),%edx
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	0f b6 00             	movzbl (%rax),%eax
  8011c0:	38 c2                	cmp    %al,%dl
  8011c2:	74 d9                	je     80119d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c8:	0f b6 00             	movzbl (%rax),%eax
  8011cb:	0f b6 d0             	movzbl %al,%edx
  8011ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d2:	0f b6 00             	movzbl (%rax),%eax
  8011d5:	0f b6 c0             	movzbl %al,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
}
  8011dc:	c9                   	leaveq 
  8011dd:	c3                   	retq   

00000000008011de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011de:	55                   	push   %rbp
  8011df:	48 89 e5             	mov    %rsp,%rbp
  8011e2:	48 83 ec 18          	sub    $0x18,%rsp
  8011e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011f2:	eb 0f                	jmp    801203 <strncmp+0x25>
		n--, p++, q++;
  8011f4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801203:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801208:	74 1d                	je     801227 <strncmp+0x49>
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	84 c0                	test   %al,%al
  801213:	74 12                	je     801227 <strncmp+0x49>
  801215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801219:	0f b6 10             	movzbl (%rax),%edx
  80121c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	38 c2                	cmp    %al,%dl
  801225:	74 cd                	je     8011f4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801227:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80122c:	75 07                	jne    801235 <strncmp+0x57>
		return 0;
  80122e:	b8 00 00 00 00       	mov    $0x0,%eax
  801233:	eb 18                	jmp    80124d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	0f b6 00             	movzbl (%rax),%eax
  80123c:	0f b6 d0             	movzbl %al,%edx
  80123f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801243:	0f b6 00             	movzbl (%rax),%eax
  801246:	0f b6 c0             	movzbl %al,%eax
  801249:	29 c2                	sub    %eax,%edx
  80124b:	89 d0                	mov    %edx,%eax
}
  80124d:	c9                   	leaveq 
  80124e:	c3                   	retq   

000000000080124f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80124f:	55                   	push   %rbp
  801250:	48 89 e5             	mov    %rsp,%rbp
  801253:	48 83 ec 0c          	sub    $0xc,%rsp
  801257:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80125b:	89 f0                	mov    %esi,%eax
  80125d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801260:	eb 17                	jmp    801279 <strchr+0x2a>
		if (*s == c)
  801262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801266:	0f b6 00             	movzbl (%rax),%eax
  801269:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80126c:	75 06                	jne    801274 <strchr+0x25>
			return (char *) s;
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	eb 15                	jmp    801289 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801274:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127d:	0f b6 00             	movzbl (%rax),%eax
  801280:	84 c0                	test   %al,%al
  801282:	75 de                	jne    801262 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 0c          	sub    $0xc,%rsp
  801293:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801297:	89 f0                	mov    %esi,%eax
  801299:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80129c:	eb 13                	jmp    8012b1 <strfind+0x26>
		if (*s == c)
  80129e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a2:	0f b6 00             	movzbl (%rax),%eax
  8012a5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a8:	75 02                	jne    8012ac <strfind+0x21>
			break;
  8012aa:	eb 10                	jmp    8012bc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b5:	0f b6 00             	movzbl (%rax),%eax
  8012b8:	84 c0                	test   %al,%al
  8012ba:	75 e2                	jne    80129e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012c0:	c9                   	leaveq 
  8012c1:	c3                   	retq   

00000000008012c2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012c2:	55                   	push   %rbp
  8012c3:	48 89 e5             	mov    %rsp,%rbp
  8012c6:	48 83 ec 18          	sub    $0x18,%rsp
  8012ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ce:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012da:	75 06                	jne    8012e2 <memset+0x20>
		return v;
  8012dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e0:	eb 69                	jmp    80134b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e6:	83 e0 03             	and    $0x3,%eax
  8012e9:	48 85 c0             	test   %rax,%rax
  8012ec:	75 48                	jne    801336 <memset+0x74>
  8012ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f2:	83 e0 03             	and    $0x3,%eax
  8012f5:	48 85 c0             	test   %rax,%rax
  8012f8:	75 3c                	jne    801336 <memset+0x74>
		c &= 0xFF;
  8012fa:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801301:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801304:	c1 e0 18             	shl    $0x18,%eax
  801307:	89 c2                	mov    %eax,%edx
  801309:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130c:	c1 e0 10             	shl    $0x10,%eax
  80130f:	09 c2                	or     %eax,%edx
  801311:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801314:	c1 e0 08             	shl    $0x8,%eax
  801317:	09 d0                	or     %edx,%eax
  801319:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80131c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801320:	48 c1 e8 02          	shr    $0x2,%rax
  801324:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801327:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132e:	48 89 d7             	mov    %rdx,%rdi
  801331:	fc                   	cld    
  801332:	f3 ab                	rep stos %eax,%es:(%rdi)
  801334:	eb 11                	jmp    801347 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801336:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801341:	48 89 d7             	mov    %rdx,%rdi
  801344:	fc                   	cld    
  801345:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80134b:	c9                   	leaveq 
  80134c:	c3                   	retq   

000000000080134d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80134d:	55                   	push   %rbp
  80134e:	48 89 e5             	mov    %rsp,%rbp
  801351:	48 83 ec 28          	sub    $0x28,%rsp
  801355:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801359:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80135d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801365:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801375:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801379:	0f 83 88 00 00 00    	jae    801407 <memmove+0xba>
  80137f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801383:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801387:	48 01 d0             	add    %rdx,%rax
  80138a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80138e:	76 77                	jbe    801407 <memmove+0xba>
		s += n;
  801390:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801394:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a4:	83 e0 03             	and    $0x3,%eax
  8013a7:	48 85 c0             	test   %rax,%rax
  8013aa:	75 3b                	jne    8013e7 <memmove+0x9a>
  8013ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b0:	83 e0 03             	and    $0x3,%eax
  8013b3:	48 85 c0             	test   %rax,%rax
  8013b6:	75 2f                	jne    8013e7 <memmove+0x9a>
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	83 e0 03             	and    $0x3,%eax
  8013bf:	48 85 c0             	test   %rax,%rax
  8013c2:	75 23                	jne    8013e7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c8:	48 83 e8 04          	sub    $0x4,%rax
  8013cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d0:	48 83 ea 04          	sub    $0x4,%rdx
  8013d4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013d8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013dc:	48 89 c7             	mov    %rax,%rdi
  8013df:	48 89 d6             	mov    %rdx,%rsi
  8013e2:	fd                   	std    
  8013e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013e5:	eb 1d                	jmp    801404 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013eb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fb:	48 89 d7             	mov    %rdx,%rdi
  8013fe:	48 89 c1             	mov    %rax,%rcx
  801401:	fd                   	std    
  801402:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801404:	fc                   	cld    
  801405:	eb 57                	jmp    80145e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140b:	83 e0 03             	and    $0x3,%eax
  80140e:	48 85 c0             	test   %rax,%rax
  801411:	75 36                	jne    801449 <memmove+0xfc>
  801413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801417:	83 e0 03             	and    $0x3,%eax
  80141a:	48 85 c0             	test   %rax,%rax
  80141d:	75 2a                	jne    801449 <memmove+0xfc>
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	83 e0 03             	and    $0x3,%eax
  801426:	48 85 c0             	test   %rax,%rax
  801429:	75 1e                	jne    801449 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80142b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142f:	48 c1 e8 02          	shr    $0x2,%rax
  801433:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143e:	48 89 c7             	mov    %rax,%rdi
  801441:	48 89 d6             	mov    %rdx,%rsi
  801444:	fc                   	cld    
  801445:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801447:	eb 15                	jmp    80145e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801451:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801455:	48 89 c7             	mov    %rax,%rdi
  801458:	48 89 d6             	mov    %rdx,%rsi
  80145b:	fc                   	cld    
  80145c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80145e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801462:	c9                   	leaveq 
  801463:	c3                   	retq   

0000000000801464 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801464:	55                   	push   %rbp
  801465:	48 89 e5             	mov    %rsp,%rbp
  801468:	48 83 ec 18          	sub    $0x18,%rsp
  80146c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801470:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801474:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801478:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80147c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	48 89 ce             	mov    %rcx,%rsi
  801487:	48 89 c7             	mov    %rax,%rdi
  80148a:	48 b8 4d 13 80 00 00 	movabs $0x80134d,%rax
  801491:	00 00 00 
  801494:	ff d0                	callq  *%rax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 28          	sub    $0x28,%rsp
  8014a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014bc:	eb 36                	jmp    8014f4 <memcmp+0x5c>
		if (*s1 != *s2)
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	0f b6 10             	movzbl (%rax),%edx
  8014c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c9:	0f b6 00             	movzbl (%rax),%eax
  8014cc:	38 c2                	cmp    %al,%dl
  8014ce:	74 1a                	je     8014ea <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	0f b6 d0             	movzbl %al,%edx
  8014da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	0f b6 c0             	movzbl %al,%eax
  8014e4:	29 c2                	sub    %eax,%edx
  8014e6:	89 d0                	mov    %edx,%eax
  8014e8:	eb 20                	jmp    80150a <memcmp+0x72>
		s1++, s2++;
  8014ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ef:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801500:	48 85 c0             	test   %rax,%rax
  801503:	75 b9                	jne    8014be <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801505:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150a:	c9                   	leaveq 
  80150b:	c3                   	retq   

000000000080150c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80150c:	55                   	push   %rbp
  80150d:	48 89 e5             	mov    %rsp,%rbp
  801510:	48 83 ec 28          	sub    $0x28,%rsp
  801514:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801518:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80151b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801527:	48 01 d0             	add    %rdx,%rax
  80152a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80152e:	eb 15                	jmp    801545 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801534:	0f b6 10             	movzbl (%rax),%edx
  801537:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80153a:	38 c2                	cmp    %al,%dl
  80153c:	75 02                	jne    801540 <memfind+0x34>
			break;
  80153e:	eb 0f                	jmp    80154f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801540:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801549:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80154d:	72 e1                	jb     801530 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80154f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801553:	c9                   	leaveq 
  801554:	c3                   	retq   

0000000000801555 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801555:	55                   	push   %rbp
  801556:	48 89 e5             	mov    %rsp,%rbp
  801559:	48 83 ec 34          	sub    $0x34,%rsp
  80155d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801561:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801565:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801568:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80156f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801576:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801577:	eb 05                	jmp    80157e <strtol+0x29>
		s++;
  801579:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	3c 20                	cmp    $0x20,%al
  801587:	74 f0                	je     801579 <strtol+0x24>
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	3c 09                	cmp    $0x9,%al
  801592:	74 e5                	je     801579 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	3c 2b                	cmp    $0x2b,%al
  80159d:	75 07                	jne    8015a6 <strtol+0x51>
		s++;
  80159f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a4:	eb 17                	jmp    8015bd <strtol+0x68>
	else if (*s == '-')
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 2d                	cmp    $0x2d,%al
  8015af:	75 0c                	jne    8015bd <strtol+0x68>
		s++, neg = 1;
  8015b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015c1:	74 06                	je     8015c9 <strtol+0x74>
  8015c3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015c7:	75 28                	jne    8015f1 <strtol+0x9c>
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	0f b6 00             	movzbl (%rax),%eax
  8015d0:	3c 30                	cmp    $0x30,%al
  8015d2:	75 1d                	jne    8015f1 <strtol+0x9c>
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	48 83 c0 01          	add    $0x1,%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	3c 78                	cmp    $0x78,%al
  8015e1:	75 0e                	jne    8015f1 <strtol+0x9c>
		s += 2, base = 16;
  8015e3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015e8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015ef:	eb 2c                	jmp    80161d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f5:	75 19                	jne    801610 <strtol+0xbb>
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 30                	cmp    $0x30,%al
  801600:	75 0e                	jne    801610 <strtol+0xbb>
		s++, base = 8;
  801602:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801607:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80160e:	eb 0d                	jmp    80161d <strtol+0xc8>
	else if (base == 0)
  801610:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801614:	75 07                	jne    80161d <strtol+0xc8>
		base = 10;
  801616:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80161d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801621:	0f b6 00             	movzbl (%rax),%eax
  801624:	3c 2f                	cmp    $0x2f,%al
  801626:	7e 1d                	jle    801645 <strtol+0xf0>
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	3c 39                	cmp    $0x39,%al
  801631:	7f 12                	jg     801645 <strtol+0xf0>
			dig = *s - '0';
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	0f be c0             	movsbl %al,%eax
  80163d:	83 e8 30             	sub    $0x30,%eax
  801640:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801643:	eb 4e                	jmp    801693 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 60                	cmp    $0x60,%al
  80164e:	7e 1d                	jle    80166d <strtol+0x118>
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 7a                	cmp    $0x7a,%al
  801659:	7f 12                	jg     80166d <strtol+0x118>
			dig = *s - 'a' + 10;
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166b:	eb 26                	jmp    801693 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	3c 40                	cmp    $0x40,%al
  801676:	7e 48                	jle    8016c0 <strtol+0x16b>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 5a                	cmp    $0x5a,%al
  801681:	7f 3d                	jg     8016c0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	83 e8 37             	sub    $0x37,%eax
  801690:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801693:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801696:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801699:	7c 02                	jl     80169d <strtol+0x148>
			break;
  80169b:	eb 23                	jmp    8016c0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80169d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016a5:	48 98                	cltq   
  8016a7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016ac:	48 89 c2             	mov    %rax,%rdx
  8016af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b2:	48 98                	cltq   
  8016b4:	48 01 d0             	add    %rdx,%rax
  8016b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016bb:	e9 5d ff ff ff       	jmpq   80161d <strtol+0xc8>

	if (endptr)
  8016c0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016c5:	74 0b                	je     8016d2 <strtol+0x17d>
		*endptr = (char *) s;
  8016c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016cf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d6:	74 09                	je     8016e1 <strtol+0x18c>
  8016d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016dc:	48 f7 d8             	neg    %rax
  8016df:	eb 04                	jmp    8016e5 <strtol+0x190>
  8016e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016e5:	c9                   	leaveq 
  8016e6:	c3                   	retq   

00000000008016e7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016e7:	55                   	push   %rbp
  8016e8:	48 89 e5             	mov    %rsp,%rbp
  8016eb:	48 83 ec 30          	sub    $0x30,%rsp
  8016ef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016ff:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801703:	0f b6 00             	movzbl (%rax),%eax
  801706:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801709:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80170d:	75 06                	jne    801715 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80170f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801713:	eb 6b                	jmp    801780 <strstr+0x99>

	len = strlen(str);
  801715:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801719:	48 89 c7             	mov    %rax,%rdi
  80171c:	48 b8 bd 0f 80 00 00 	movabs $0x800fbd,%rax
  801723:	00 00 00 
  801726:	ff d0                	callq  *%rax
  801728:	48 98                	cltq   
  80172a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80172e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801732:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801736:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80173a:	0f b6 00             	movzbl (%rax),%eax
  80173d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801740:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801744:	75 07                	jne    80174d <strstr+0x66>
				return (char *) 0;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
  80174b:	eb 33                	jmp    801780 <strstr+0x99>
		} while (sc != c);
  80174d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801751:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801754:	75 d8                	jne    80172e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801756:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80175a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80175e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801762:	48 89 ce             	mov    %rcx,%rsi
  801765:	48 89 c7             	mov    %rax,%rdi
  801768:	48 b8 de 11 80 00 00 	movabs $0x8011de,%rax
  80176f:	00 00 00 
  801772:	ff d0                	callq  *%rax
  801774:	85 c0                	test   %eax,%eax
  801776:	75 b6                	jne    80172e <strstr+0x47>

	return (char *) (in - 1);
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	48 83 e8 01          	sub    $0x1,%rax
}
  801780:	c9                   	leaveq 
  801781:	c3                   	retq   

0000000000801782 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801782:	55                   	push   %rbp
  801783:	48 89 e5             	mov    %rsp,%rbp
  801786:	53                   	push   %rbx
  801787:	48 83 ec 48          	sub    $0x48,%rsp
  80178b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80178e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801791:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801795:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801799:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80179d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017a4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017a8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017ac:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017b0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017b4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017b8:	4c 89 c3             	mov    %r8,%rbx
  8017bb:	cd 30                	int    $0x30
  8017bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017c5:	74 3e                	je     801805 <syscall+0x83>
  8017c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017cc:	7e 37                	jle    801805 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d5:	49 89 d0             	mov    %rdx,%r8
  8017d8:	89 c1                	mov    %eax,%ecx
  8017da:	48 ba c8 21 80 00 00 	movabs $0x8021c8,%rdx
  8017e1:	00 00 00 
  8017e4:	be 23 00 00 00       	mov    $0x23,%esi
  8017e9:	48 bf e5 21 80 00 00 	movabs $0x8021e5,%rdi
  8017f0:	00 00 00 
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f8:	49 b9 28 02 80 00 00 	movabs $0x800228,%r9
  8017ff:	00 00 00 
  801802:	41 ff d1             	callq  *%r9

	return ret;
  801805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801809:	48 83 c4 48          	add    $0x48,%rsp
  80180d:	5b                   	pop    %rbx
  80180e:	5d                   	pop    %rbp
  80180f:	c3                   	retq   

0000000000801810 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801810:	55                   	push   %rbp
  801811:	48 89 e5             	mov    %rsp,%rbp
  801814:	48 83 ec 20          	sub    $0x20,%rsp
  801818:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80181c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801820:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801824:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801828:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182f:	00 
  801830:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801836:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80183c:	48 89 d1             	mov    %rdx,%rcx
  80183f:	48 89 c2             	mov    %rax,%rdx
  801842:	be 00 00 00 00       	mov    $0x0,%esi
  801847:	bf 00 00 00 00       	mov    $0x0,%edi
  80184c:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801853:	00 00 00 
  801856:	ff d0                	callq  *%rax
}
  801858:	c9                   	leaveq 
  801859:	c3                   	retq   

000000000080185a <sys_cgetc>:

int
sys_cgetc(void)
{
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
  80185e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801862:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801869:	00 
  80186a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801870:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801876:	b9 00 00 00 00       	mov    $0x0,%ecx
  80187b:	ba 00 00 00 00       	mov    $0x0,%edx
  801880:	be 00 00 00 00       	mov    $0x0,%esi
  801885:	bf 01 00 00 00       	mov    $0x1,%edi
  80188a:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801891:	00 00 00 
  801894:	ff d0                	callq  *%rax
}
  801896:	c9                   	leaveq 
  801897:	c3                   	retq   

0000000000801898 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801898:	55                   	push   %rbp
  801899:	48 89 e5             	mov    %rsp,%rbp
  80189c:	48 83 ec 10          	sub    $0x10,%rsp
  8018a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a6:	48 98                	cltq   
  8018a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018af:	00 
  8018b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c1:	48 89 c2             	mov    %rax,%rdx
  8018c4:	be 01 00 00 00       	mov    $0x1,%esi
  8018c9:	bf 03 00 00 00       	mov    $0x3,%edi
  8018ce:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  8018d5:	00 00 00 
  8018d8:	ff d0                	callq  *%rax
}
  8018da:	c9                   	leaveq 
  8018db:	c3                   	retq   

00000000008018dc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018dc:	55                   	push   %rbp
  8018dd:	48 89 e5             	mov    %rsp,%rbp
  8018e0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018eb:	00 
  8018ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801902:	be 00 00 00 00       	mov    $0x0,%esi
  801907:	bf 02 00 00 00       	mov    $0x2,%edi
  80190c:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
}
  801918:	c9                   	leaveq 
  801919:	c3                   	retq   

000000000080191a <sys_yield>:

void
sys_yield(void)
{
  80191a:	55                   	push   %rbp
  80191b:	48 89 e5             	mov    %rsp,%rbp
  80191e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801922:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801929:	00 
  80192a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801930:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193b:	ba 00 00 00 00       	mov    $0x0,%edx
  801940:	be 00 00 00 00       	mov    $0x0,%esi
  801945:	bf 0a 00 00 00       	mov    $0xa,%edi
  80194a:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	48 83 ec 20          	sub    $0x20,%rsp
  801960:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801963:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801967:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80196a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80196d:	48 63 c8             	movslq %eax,%rcx
  801970:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801977:	48 98                	cltq   
  801979:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801980:	00 
  801981:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801987:	49 89 c8             	mov    %rcx,%r8
  80198a:	48 89 d1             	mov    %rdx,%rcx
  80198d:	48 89 c2             	mov    %rax,%rdx
  801990:	be 01 00 00 00       	mov    $0x1,%esi
  801995:	bf 04 00 00 00       	mov    $0x4,%edi
  80199a:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  8019a1:	00 00 00 
  8019a4:	ff d0                	callq  *%rax
}
  8019a6:	c9                   	leaveq 
  8019a7:	c3                   	retq   

00000000008019a8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019a8:	55                   	push   %rbp
  8019a9:	48 89 e5             	mov    %rsp,%rbp
  8019ac:	48 83 ec 30          	sub    $0x30,%rsp
  8019b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019ba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019be:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019c2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019c5:	48 63 c8             	movslq %eax,%rcx
  8019c8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019cf:	48 63 f0             	movslq %eax,%rsi
  8019d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d9:	48 98                	cltq   
  8019db:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019df:	49 89 f9             	mov    %rdi,%r9
  8019e2:	49 89 f0             	mov    %rsi,%r8
  8019e5:	48 89 d1             	mov    %rdx,%rcx
  8019e8:	48 89 c2             	mov    %rax,%rdx
  8019eb:	be 01 00 00 00       	mov    $0x1,%esi
  8019f0:	bf 05 00 00 00       	mov    $0x5,%edi
  8019f5:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
}
  801a01:	c9                   	leaveq 
  801a02:	c3                   	retq   

0000000000801a03 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a03:	55                   	push   %rbp
  801a04:	48 89 e5             	mov    %rsp,%rbp
  801a07:	48 83 ec 20          	sub    $0x20,%rsp
  801a0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a19:	48 98                	cltq   
  801a1b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a22:	00 
  801a23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2f:	48 89 d1             	mov    %rdx,%rcx
  801a32:	48 89 c2             	mov    %rax,%rdx
  801a35:	be 01 00 00 00       	mov    $0x1,%esi
  801a3a:	bf 06 00 00 00       	mov    $0x6,%edi
  801a3f:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801a46:	00 00 00 
  801a49:	ff d0                	callq  *%rax
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 10          	sub    $0x10,%rsp
  801a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a5e:	48 63 d0             	movslq %eax,%rdx
  801a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a64:	48 98                	cltq   
  801a66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6d:	00 
  801a6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7a:	48 89 d1             	mov    %rdx,%rcx
  801a7d:	48 89 c2             	mov    %rax,%rdx
  801a80:	be 01 00 00 00       	mov    $0x1,%esi
  801a85:	bf 08 00 00 00       	mov    $0x8,%edi
  801a8a:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801a91:	00 00 00 
  801a94:	ff d0                	callq  *%rax
}
  801a96:	c9                   	leaveq 
  801a97:	c3                   	retq   

0000000000801a98 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a98:	55                   	push   %rbp
  801a99:	48 89 e5             	mov    %rsp,%rbp
  801a9c:	48 83 ec 20          	sub    $0x20,%rsp
  801aa0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801aa7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aae:	48 98                	cltq   
  801ab0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab7:	00 
  801ab8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac4:	48 89 d1             	mov    %rdx,%rcx
  801ac7:	48 89 c2             	mov    %rax,%rdx
  801aca:	be 01 00 00 00       	mov    $0x1,%esi
  801acf:	bf 09 00 00 00       	mov    $0x9,%edi
  801ad4:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801adb:	00 00 00 
  801ade:	ff d0                	callq  *%rax
}
  801ae0:	c9                   	leaveq 
  801ae1:	c3                   	retq   

0000000000801ae2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ae2:	55                   	push   %rbp
  801ae3:	48 89 e5             	mov    %rsp,%rbp
  801ae6:	48 83 ec 20          	sub    $0x20,%rsp
  801aea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801af1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801af5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801af8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801afb:	48 63 f0             	movslq %eax,%rsi
  801afe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b05:	48 98                	cltq   
  801b07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b12:	00 
  801b13:	49 89 f1             	mov    %rsi,%r9
  801b16:	49 89 c8             	mov    %rcx,%r8
  801b19:	48 89 d1             	mov    %rdx,%rcx
  801b1c:	48 89 c2             	mov    %rax,%rdx
  801b1f:	be 00 00 00 00       	mov    $0x0,%esi
  801b24:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b29:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	callq  *%rax
}
  801b35:	c9                   	leaveq 
  801b36:	c3                   	retq   

0000000000801b37 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b37:	55                   	push   %rbp
  801b38:	48 89 e5             	mov    %rsp,%rbp
  801b3b:	48 83 ec 10          	sub    $0x10,%rsp
  801b3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4e:	00 
  801b4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b60:	48 89 c2             	mov    %rax,%rdx
  801b63:	be 01 00 00 00       	mov    $0x1,%esi
  801b68:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b6d:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	callq  *%rax
}
  801b79:	c9                   	leaveq 
  801b7a:	c3                   	retq   

0000000000801b7b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b7b:	55                   	push   %rbp
  801b7c:	48 89 e5             	mov    %rsp,%rbp
  801b7f:	48 83 ec 10          	sub    $0x10,%rsp
  801b83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801b87:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801b8e:	00 00 00 
  801b91:	48 8b 00             	mov    (%rax),%rax
  801b94:	48 85 c0             	test   %rax,%rax
  801b97:	75 49                	jne    801be2 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801b99:	ba 07 00 00 00       	mov    $0x7,%edx
  801b9e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba8:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	callq  *%rax
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	79 2a                	jns    801be2 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801bb8:	48 ba f8 21 80 00 00 	movabs $0x8021f8,%rdx
  801bbf:	00 00 00 
  801bc2:	be 21 00 00 00       	mov    $0x21,%esi
  801bc7:	48 bf 23 22 80 00 00 	movabs $0x802223,%rdi
  801bce:	00 00 00 
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd6:	48 b9 28 02 80 00 00 	movabs $0x800228,%rcx
  801bdd:	00 00 00 
  801be0:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801be2:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801be9:	00 00 00 
  801bec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bf0:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801bf3:	48 be 3e 1c 80 00 00 	movabs $0x801c3e,%rsi
  801bfa:	00 00 00 
  801bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  801c02:	48 b8 98 1a 80 00 00 	movabs $0x801a98,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	callq  *%rax
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	79 2a                	jns    801c3c <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801c12:	48 ba 38 22 80 00 00 	movabs $0x802238,%rdx
  801c19:	00 00 00 
  801c1c:	be 27 00 00 00       	mov    $0x27,%esi
  801c21:	48 bf 23 22 80 00 00 	movabs $0x802223,%rdi
  801c28:	00 00 00 
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	48 b9 28 02 80 00 00 	movabs $0x800228,%rcx
  801c37:	00 00 00 
  801c3a:	ff d1                	callq  *%rcx
}
  801c3c:	c9                   	leaveq 
  801c3d:	c3                   	retq   

0000000000801c3e <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801c3e:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801c41:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  801c48:	00 00 00 
call *%rax
  801c4b:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  801c4d:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801c54:	00 
    movq 152(%rsp), %rcx
  801c55:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801c5c:	00 
    subq $8, %rcx
  801c5d:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  801c61:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  801c64:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801c6b:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  801c6c:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  801c70:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c74:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801c79:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801c7e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801c83:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801c88:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801c8d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801c92:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801c97:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801c9c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801ca1:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801ca6:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801cab:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801cb0:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801cb5:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801cba:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  801cbe:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  801cc2:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  801cc3:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  801cc4:	c3                   	retq   
